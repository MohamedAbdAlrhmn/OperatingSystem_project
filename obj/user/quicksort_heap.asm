
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
  800041:	e8 9a 1e 00 00       	call   801ee0 <sys_disable_interrupt>
		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 20 3c 80 00       	push   $0x803c20
  80004e:	e8 f2 09 00 00       	call   800a45 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 22 3c 80 00       	push   $0x803c22
  80005e:	e8 e2 09 00 00       	call   800a45 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   QUICK SORT   !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 3b 3c 80 00       	push   $0x803c3b
  80006e:	e8 d2 09 00 00       	call   800a45 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 22 3c 80 00       	push   $0x803c22
  80007e:	e8 c2 09 00 00       	call   800a45 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 20 3c 80 00       	push   $0x803c20
  80008e:	e8 b2 09 00 00       	call   800a45 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 54 3c 80 00       	push   $0x803c54
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
  8000de:	68 74 3c 80 00       	push   $0x803c74
  8000e3:	e8 5d 09 00 00       	call   800a45 <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 96 3c 80 00       	push   $0x803c96
  8000f3:	e8 4d 09 00 00       	call   800a45 <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 a4 3c 80 00       	push   $0x803ca4
  800103:	e8 3d 09 00 00       	call   800a45 <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 b3 3c 80 00       	push   $0x803cb3
  800113:	e8 2d 09 00 00       	call   800a45 <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 c3 3c 80 00       	push   $0x803cc3
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
  800162:	e8 93 1d 00 00       	call   801efa <sys_enable_interrupt>

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
  8001d5:	e8 06 1d 00 00       	call   801ee0 <sys_disable_interrupt>
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	68 cc 3c 80 00       	push   $0x803ccc
  8001e2:	e8 5e 08 00 00       	call   800a45 <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
		//		PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001ea:	e8 0b 1d 00 00       	call   801efa <sys_enable_interrupt>

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
  80020c:	68 00 3d 80 00       	push   $0x803d00
  800211:	6a 48                	push   $0x48
  800213:	68 22 3d 80 00       	push   $0x803d22
  800218:	e8 74 05 00 00       	call   800791 <_panic>
		else
		{
			sys_disable_interrupt();
  80021d:	e8 be 1c 00 00       	call   801ee0 <sys_disable_interrupt>
			cprintf("\n===============================================\n") ;
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	68 38 3d 80 00       	push   $0x803d38
  80022a:	e8 16 08 00 00       	call   800a45 <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 6c 3d 80 00       	push   $0x803d6c
  80023a:	e8 06 08 00 00       	call   800a45 <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	68 a0 3d 80 00       	push   $0x803da0
  80024a:	e8 f6 07 00 00       	call   800a45 <cprintf>
  80024f:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800252:	e8 a3 1c 00 00       	call   801efa <sys_enable_interrupt>
		}

		sys_disable_interrupt();
  800257:	e8 84 1c 00 00       	call   801ee0 <sys_disable_interrupt>
			Chose = 0 ;
  80025c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800260:	eb 42                	jmp    8002a4 <_main+0x26c>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800262:	83 ec 0c             	sub    $0xc,%esp
  800265:	68 d2 3d 80 00       	push   $0x803dd2
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
  8002b0:	e8 45 1c 00 00       	call   801efa <sys_enable_interrupt>

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
  800555:	68 20 3c 80 00       	push   $0x803c20
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
  800577:	68 f0 3d 80 00       	push   $0x803df0
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
  8005a5:	68 f5 3d 80 00       	push   $0x803df5
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
  8005c9:	e8 46 19 00 00       	call   801f14 <sys_cputc>
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
  8005da:	e8 01 19 00 00       	call   801ee0 <sys_disable_interrupt>
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
  8005ed:	e8 22 19 00 00       	call   801f14 <sys_cputc>
  8005f2:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8005f5:	e8 00 19 00 00       	call   801efa <sys_enable_interrupt>
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
  80060c:	e8 4a 17 00 00       	call   801d5b <sys_cgetc>
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
  800625:	e8 b6 18 00 00       	call   801ee0 <sys_disable_interrupt>
	int c=0;
  80062a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800631:	eb 08                	jmp    80063b <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800633:	e8 23 17 00 00       	call   801d5b <sys_cgetc>
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
  800641:	e8 b4 18 00 00       	call   801efa <sys_enable_interrupt>
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
  80065b:	e8 73 1a 00 00       	call   8020d3 <sys_getenvindex>
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
  8006c6:	e8 15 18 00 00       	call   801ee0 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8006cb:	83 ec 0c             	sub    $0xc,%esp
  8006ce:	68 14 3e 80 00       	push   $0x803e14
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
  8006f6:	68 3c 3e 80 00       	push   $0x803e3c
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
  800727:	68 64 3e 80 00       	push   $0x803e64
  80072c:	e8 14 03 00 00       	call   800a45 <cprintf>
  800731:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800734:	a1 24 50 80 00       	mov    0x805024,%eax
  800739:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80073f:	83 ec 08             	sub    $0x8,%esp
  800742:	50                   	push   %eax
  800743:	68 bc 3e 80 00       	push   $0x803ebc
  800748:	e8 f8 02 00 00       	call   800a45 <cprintf>
  80074d:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800750:	83 ec 0c             	sub    $0xc,%esp
  800753:	68 14 3e 80 00       	push   $0x803e14
  800758:	e8 e8 02 00 00       	call   800a45 <cprintf>
  80075d:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800760:	e8 95 17 00 00       	call   801efa <sys_enable_interrupt>

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
  800778:	e8 22 19 00 00       	call   80209f <sys_destroy_env>
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
  800789:	e8 77 19 00 00       	call   802105 <sys_exit_env>
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
  8007b2:	68 d0 3e 80 00       	push   $0x803ed0
  8007b7:	e8 89 02 00 00       	call   800a45 <cprintf>
  8007bc:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007bf:	a1 00 50 80 00       	mov    0x805000,%eax
  8007c4:	ff 75 0c             	pushl  0xc(%ebp)
  8007c7:	ff 75 08             	pushl  0x8(%ebp)
  8007ca:	50                   	push   %eax
  8007cb:	68 d5 3e 80 00       	push   $0x803ed5
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
  8007ef:	68 f1 3e 80 00       	push   $0x803ef1
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
  80081b:	68 f4 3e 80 00       	push   $0x803ef4
  800820:	6a 26                	push   $0x26
  800822:	68 40 3f 80 00       	push   $0x803f40
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
  8008ed:	68 4c 3f 80 00       	push   $0x803f4c
  8008f2:	6a 3a                	push   $0x3a
  8008f4:	68 40 3f 80 00       	push   $0x803f40
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
  80095d:	68 a0 3f 80 00       	push   $0x803fa0
  800962:	6a 44                	push   $0x44
  800964:	68 40 3f 80 00       	push   $0x803f40
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
  8009b7:	e8 76 13 00 00       	call   801d32 <sys_cputs>
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
  800a2e:	e8 ff 12 00 00       	call   801d32 <sys_cputs>
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
  800a78:	e8 63 14 00 00       	call   801ee0 <sys_disable_interrupt>
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
  800a98:	e8 5d 14 00 00       	call   801efa <sys_enable_interrupt>
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
  800ae2:	e8 d1 2e 00 00       	call   8039b8 <__udivdi3>
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
  800b32:	e8 91 2f 00 00       	call   803ac8 <__umoddi3>
  800b37:	83 c4 10             	add    $0x10,%esp
  800b3a:	05 14 42 80 00       	add    $0x804214,%eax
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
  800c8d:	8b 04 85 38 42 80 00 	mov    0x804238(,%eax,4),%eax
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
  800d6e:	8b 34 9d 80 40 80 00 	mov    0x804080(,%ebx,4),%esi
  800d75:	85 f6                	test   %esi,%esi
  800d77:	75 19                	jne    800d92 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d79:	53                   	push   %ebx
  800d7a:	68 25 42 80 00       	push   $0x804225
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
  800d93:	68 2e 42 80 00       	push   $0x80422e
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
  800dc0:	be 31 42 80 00       	mov    $0x804231,%esi
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
  8010d9:	68 90 43 80 00       	push   $0x804390
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
  80111b:	68 93 43 80 00       	push   $0x804393
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
  8011cb:	e8 10 0d 00 00       	call   801ee0 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  8011d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011d4:	74 13                	je     8011e9 <atomic_readline+0x24>
		cprintf("%s", prompt);
  8011d6:	83 ec 08             	sub    $0x8,%esp
  8011d9:	ff 75 08             	pushl  0x8(%ebp)
  8011dc:	68 90 43 80 00       	push   $0x804390
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
  80121a:	68 93 43 80 00       	push   $0x804393
  80121f:	e8 21 f8 ff ff       	call   800a45 <cprintf>
  801224:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801227:	e8 ce 0c 00 00       	call   801efa <sys_enable_interrupt>
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
  8012bf:	e8 36 0c 00 00       	call   801efa <sys_enable_interrupt>
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
  8019ec:	68 a4 43 80 00       	push   $0x8043a4
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
  801abc:	e8 b5 03 00 00       	call   801e76 <sys_allocate_chunk>
  801ac1:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801ac4:	a1 20 51 80 00       	mov    0x805120,%eax
  801ac9:	83 ec 0c             	sub    $0xc,%esp
  801acc:	50                   	push   %eax
  801acd:	e8 2a 0a 00 00       	call   8024fc <initialize_MemBlocksList>
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
  801afa:	68 c9 43 80 00       	push   $0x8043c9
  801aff:	6a 33                	push   $0x33
  801b01:	68 e7 43 80 00       	push   $0x8043e7
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
  801b79:	68 f4 43 80 00       	push   $0x8043f4
  801b7e:	6a 34                	push   $0x34
  801b80:	68 e7 43 80 00       	push   $0x8043e7
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
  801bee:	68 18 44 80 00       	push   $0x804418
  801bf3:	6a 46                	push   $0x46
  801bf5:	68 e7 43 80 00       	push   $0x8043e7
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
  801c0a:	68 40 44 80 00       	push   $0x804440
  801c0f:	6a 61                	push   $0x61
  801c11:	68 e7 43 80 00       	push   $0x8043e7
  801c16:	e8 76 eb ff ff       	call   800791 <_panic>

00801c1b <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801c1b:	55                   	push   %ebp
  801c1c:	89 e5                	mov    %esp,%ebp
  801c1e:	83 ec 18             	sub    $0x18,%esp
  801c21:	8b 45 10             	mov    0x10(%ebp),%eax
  801c24:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c27:	e8 a9 fd ff ff       	call   8019d5 <InitializeUHeap>
	if (size == 0) return NULL ;
  801c2c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c30:	75 07                	jne    801c39 <smalloc+0x1e>
  801c32:	b8 00 00 00 00       	mov    $0x0,%eax
  801c37:	eb 14                	jmp    801c4d <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801c39:	83 ec 04             	sub    $0x4,%esp
  801c3c:	68 64 44 80 00       	push   $0x804464
  801c41:	6a 76                	push   $0x76
  801c43:	68 e7 43 80 00       	push   $0x8043e7
  801c48:	e8 44 eb ff ff       	call   800791 <_panic>

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801c4d:	c9                   	leave  
  801c4e:	c3                   	ret    

00801c4f <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801c4f:	55                   	push   %ebp
  801c50:	89 e5                	mov    %esp,%ebp
  801c52:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c55:	e8 7b fd ff ff       	call   8019d5 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801c5a:	83 ec 04             	sub    $0x4,%esp
  801c5d:	68 8c 44 80 00       	push   $0x80448c
  801c62:	68 93 00 00 00       	push   $0x93
  801c67:	68 e7 43 80 00       	push   $0x8043e7
  801c6c:	e8 20 eb ff ff       	call   800791 <_panic>

00801c71 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801c71:	55                   	push   %ebp
  801c72:	89 e5                	mov    %esp,%ebp
  801c74:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c77:	e8 59 fd ff ff       	call   8019d5 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801c7c:	83 ec 04             	sub    $0x4,%esp
  801c7f:	68 b0 44 80 00       	push   $0x8044b0
  801c84:	68 c5 00 00 00       	push   $0xc5
  801c89:	68 e7 43 80 00       	push   $0x8043e7
  801c8e:	e8 fe ea ff ff       	call   800791 <_panic>

00801c93 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801c93:	55                   	push   %ebp
  801c94:	89 e5                	mov    %esp,%ebp
  801c96:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801c99:	83 ec 04             	sub    $0x4,%esp
  801c9c:	68 d8 44 80 00       	push   $0x8044d8
  801ca1:	68 d9 00 00 00       	push   $0xd9
  801ca6:	68 e7 43 80 00       	push   $0x8043e7
  801cab:	e8 e1 ea ff ff       	call   800791 <_panic>

00801cb0 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801cb0:	55                   	push   %ebp
  801cb1:	89 e5                	mov    %esp,%ebp
  801cb3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801cb6:	83 ec 04             	sub    $0x4,%esp
  801cb9:	68 fc 44 80 00       	push   $0x8044fc
  801cbe:	68 e4 00 00 00       	push   $0xe4
  801cc3:	68 e7 43 80 00       	push   $0x8043e7
  801cc8:	e8 c4 ea ff ff       	call   800791 <_panic>

00801ccd <shrink>:

}
void shrink(uint32 newSize)
{
  801ccd:	55                   	push   %ebp
  801cce:	89 e5                	mov    %esp,%ebp
  801cd0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801cd3:	83 ec 04             	sub    $0x4,%esp
  801cd6:	68 fc 44 80 00       	push   $0x8044fc
  801cdb:	68 e9 00 00 00       	push   $0xe9
  801ce0:	68 e7 43 80 00       	push   $0x8043e7
  801ce5:	e8 a7 ea ff ff       	call   800791 <_panic>

00801cea <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801cea:	55                   	push   %ebp
  801ceb:	89 e5                	mov    %esp,%ebp
  801ced:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801cf0:	83 ec 04             	sub    $0x4,%esp
  801cf3:	68 fc 44 80 00       	push   $0x8044fc
  801cf8:	68 ee 00 00 00       	push   $0xee
  801cfd:	68 e7 43 80 00       	push   $0x8043e7
  801d02:	e8 8a ea ff ff       	call   800791 <_panic>

00801d07 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801d07:	55                   	push   %ebp
  801d08:	89 e5                	mov    %esp,%ebp
  801d0a:	57                   	push   %edi
  801d0b:	56                   	push   %esi
  801d0c:	53                   	push   %ebx
  801d0d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801d10:	8b 45 08             	mov    0x8(%ebp),%eax
  801d13:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d16:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d19:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d1c:	8b 7d 18             	mov    0x18(%ebp),%edi
  801d1f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801d22:	cd 30                	int    $0x30
  801d24:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801d27:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801d2a:	83 c4 10             	add    $0x10,%esp
  801d2d:	5b                   	pop    %ebx
  801d2e:	5e                   	pop    %esi
  801d2f:	5f                   	pop    %edi
  801d30:	5d                   	pop    %ebp
  801d31:	c3                   	ret    

00801d32 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801d32:	55                   	push   %ebp
  801d33:	89 e5                	mov    %esp,%ebp
  801d35:	83 ec 04             	sub    $0x4,%esp
  801d38:	8b 45 10             	mov    0x10(%ebp),%eax
  801d3b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801d3e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d42:	8b 45 08             	mov    0x8(%ebp),%eax
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	52                   	push   %edx
  801d4a:	ff 75 0c             	pushl  0xc(%ebp)
  801d4d:	50                   	push   %eax
  801d4e:	6a 00                	push   $0x0
  801d50:	e8 b2 ff ff ff       	call   801d07 <syscall>
  801d55:	83 c4 18             	add    $0x18,%esp
}
  801d58:	90                   	nop
  801d59:	c9                   	leave  
  801d5a:	c3                   	ret    

00801d5b <sys_cgetc>:

int
sys_cgetc(void)
{
  801d5b:	55                   	push   %ebp
  801d5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 01                	push   $0x1
  801d6a:	e8 98 ff ff ff       	call   801d07 <syscall>
  801d6f:	83 c4 18             	add    $0x18,%esp
}
  801d72:	c9                   	leave  
  801d73:	c3                   	ret    

00801d74 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801d74:	55                   	push   %ebp
  801d75:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801d77:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	52                   	push   %edx
  801d84:	50                   	push   %eax
  801d85:	6a 05                	push   $0x5
  801d87:	e8 7b ff ff ff       	call   801d07 <syscall>
  801d8c:	83 c4 18             	add    $0x18,%esp
}
  801d8f:	c9                   	leave  
  801d90:	c3                   	ret    

00801d91 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801d91:	55                   	push   %ebp
  801d92:	89 e5                	mov    %esp,%ebp
  801d94:	56                   	push   %esi
  801d95:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801d96:	8b 75 18             	mov    0x18(%ebp),%esi
  801d99:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d9c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801da2:	8b 45 08             	mov    0x8(%ebp),%eax
  801da5:	56                   	push   %esi
  801da6:	53                   	push   %ebx
  801da7:	51                   	push   %ecx
  801da8:	52                   	push   %edx
  801da9:	50                   	push   %eax
  801daa:	6a 06                	push   $0x6
  801dac:	e8 56 ff ff ff       	call   801d07 <syscall>
  801db1:	83 c4 18             	add    $0x18,%esp
}
  801db4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801db7:	5b                   	pop    %ebx
  801db8:	5e                   	pop    %esi
  801db9:	5d                   	pop    %ebp
  801dba:	c3                   	ret    

00801dbb <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801dbb:	55                   	push   %ebp
  801dbc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801dbe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc4:	6a 00                	push   $0x0
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 00                	push   $0x0
  801dca:	52                   	push   %edx
  801dcb:	50                   	push   %eax
  801dcc:	6a 07                	push   $0x7
  801dce:	e8 34 ff ff ff       	call   801d07 <syscall>
  801dd3:	83 c4 18             	add    $0x18,%esp
}
  801dd6:	c9                   	leave  
  801dd7:	c3                   	ret    

00801dd8 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801dd8:	55                   	push   %ebp
  801dd9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	ff 75 0c             	pushl  0xc(%ebp)
  801de4:	ff 75 08             	pushl  0x8(%ebp)
  801de7:	6a 08                	push   $0x8
  801de9:	e8 19 ff ff ff       	call   801d07 <syscall>
  801dee:	83 c4 18             	add    $0x18,%esp
}
  801df1:	c9                   	leave  
  801df2:	c3                   	ret    

00801df3 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801df3:	55                   	push   %ebp
  801df4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 09                	push   $0x9
  801e02:	e8 00 ff ff ff       	call   801d07 <syscall>
  801e07:	83 c4 18             	add    $0x18,%esp
}
  801e0a:	c9                   	leave  
  801e0b:	c3                   	ret    

00801e0c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801e0c:	55                   	push   %ebp
  801e0d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	6a 00                	push   $0x0
  801e19:	6a 0a                	push   $0xa
  801e1b:	e8 e7 fe ff ff       	call   801d07 <syscall>
  801e20:	83 c4 18             	add    $0x18,%esp
}
  801e23:	c9                   	leave  
  801e24:	c3                   	ret    

00801e25 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801e25:	55                   	push   %ebp
  801e26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 00                	push   $0x0
  801e32:	6a 0b                	push   $0xb
  801e34:	e8 ce fe ff ff       	call   801d07 <syscall>
  801e39:	83 c4 18             	add    $0x18,%esp
}
  801e3c:	c9                   	leave  
  801e3d:	c3                   	ret    

00801e3e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801e3e:	55                   	push   %ebp
  801e3f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801e41:	6a 00                	push   $0x0
  801e43:	6a 00                	push   $0x0
  801e45:	6a 00                	push   $0x0
  801e47:	ff 75 0c             	pushl  0xc(%ebp)
  801e4a:	ff 75 08             	pushl  0x8(%ebp)
  801e4d:	6a 0f                	push   $0xf
  801e4f:	e8 b3 fe ff ff       	call   801d07 <syscall>
  801e54:	83 c4 18             	add    $0x18,%esp
	return;
  801e57:	90                   	nop
}
  801e58:	c9                   	leave  
  801e59:	c3                   	ret    

00801e5a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801e5a:	55                   	push   %ebp
  801e5b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 00                	push   $0x0
  801e63:	ff 75 0c             	pushl  0xc(%ebp)
  801e66:	ff 75 08             	pushl  0x8(%ebp)
  801e69:	6a 10                	push   $0x10
  801e6b:	e8 97 fe ff ff       	call   801d07 <syscall>
  801e70:	83 c4 18             	add    $0x18,%esp
	return ;
  801e73:	90                   	nop
}
  801e74:	c9                   	leave  
  801e75:	c3                   	ret    

00801e76 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e76:	55                   	push   %ebp
  801e77:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e79:	6a 00                	push   $0x0
  801e7b:	6a 00                	push   $0x0
  801e7d:	ff 75 10             	pushl  0x10(%ebp)
  801e80:	ff 75 0c             	pushl  0xc(%ebp)
  801e83:	ff 75 08             	pushl  0x8(%ebp)
  801e86:	6a 11                	push   $0x11
  801e88:	e8 7a fe ff ff       	call   801d07 <syscall>
  801e8d:	83 c4 18             	add    $0x18,%esp
	return ;
  801e90:	90                   	nop
}
  801e91:	c9                   	leave  
  801e92:	c3                   	ret    

00801e93 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801e93:	55                   	push   %ebp
  801e94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801e96:	6a 00                	push   $0x0
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 00                	push   $0x0
  801e9e:	6a 00                	push   $0x0
  801ea0:	6a 0c                	push   $0xc
  801ea2:	e8 60 fe ff ff       	call   801d07 <syscall>
  801ea7:	83 c4 18             	add    $0x18,%esp
}
  801eaa:	c9                   	leave  
  801eab:	c3                   	ret    

00801eac <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801eac:	55                   	push   %ebp
  801ead:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801eaf:	6a 00                	push   $0x0
  801eb1:	6a 00                	push   $0x0
  801eb3:	6a 00                	push   $0x0
  801eb5:	6a 00                	push   $0x0
  801eb7:	ff 75 08             	pushl  0x8(%ebp)
  801eba:	6a 0d                	push   $0xd
  801ebc:	e8 46 fe ff ff       	call   801d07 <syscall>
  801ec1:	83 c4 18             	add    $0x18,%esp
}
  801ec4:	c9                   	leave  
  801ec5:	c3                   	ret    

00801ec6 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ec6:	55                   	push   %ebp
  801ec7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ec9:	6a 00                	push   $0x0
  801ecb:	6a 00                	push   $0x0
  801ecd:	6a 00                	push   $0x0
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 0e                	push   $0xe
  801ed5:	e8 2d fe ff ff       	call   801d07 <syscall>
  801eda:	83 c4 18             	add    $0x18,%esp
}
  801edd:	90                   	nop
  801ede:	c9                   	leave  
  801edf:	c3                   	ret    

00801ee0 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801ee0:	55                   	push   %ebp
  801ee1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 00                	push   $0x0
  801eeb:	6a 00                	push   $0x0
  801eed:	6a 13                	push   $0x13
  801eef:	e8 13 fe ff ff       	call   801d07 <syscall>
  801ef4:	83 c4 18             	add    $0x18,%esp
}
  801ef7:	90                   	nop
  801ef8:	c9                   	leave  
  801ef9:	c3                   	ret    

00801efa <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801efa:	55                   	push   %ebp
  801efb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801efd:	6a 00                	push   $0x0
  801eff:	6a 00                	push   $0x0
  801f01:	6a 00                	push   $0x0
  801f03:	6a 00                	push   $0x0
  801f05:	6a 00                	push   $0x0
  801f07:	6a 14                	push   $0x14
  801f09:	e8 f9 fd ff ff       	call   801d07 <syscall>
  801f0e:	83 c4 18             	add    $0x18,%esp
}
  801f11:	90                   	nop
  801f12:	c9                   	leave  
  801f13:	c3                   	ret    

00801f14 <sys_cputc>:


void
sys_cputc(const char c)
{
  801f14:	55                   	push   %ebp
  801f15:	89 e5                	mov    %esp,%ebp
  801f17:	83 ec 04             	sub    $0x4,%esp
  801f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801f20:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f24:	6a 00                	push   $0x0
  801f26:	6a 00                	push   $0x0
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 00                	push   $0x0
  801f2c:	50                   	push   %eax
  801f2d:	6a 15                	push   $0x15
  801f2f:	e8 d3 fd ff ff       	call   801d07 <syscall>
  801f34:	83 c4 18             	add    $0x18,%esp
}
  801f37:	90                   	nop
  801f38:	c9                   	leave  
  801f39:	c3                   	ret    

00801f3a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801f3a:	55                   	push   %ebp
  801f3b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801f3d:	6a 00                	push   $0x0
  801f3f:	6a 00                	push   $0x0
  801f41:	6a 00                	push   $0x0
  801f43:	6a 00                	push   $0x0
  801f45:	6a 00                	push   $0x0
  801f47:	6a 16                	push   $0x16
  801f49:	e8 b9 fd ff ff       	call   801d07 <syscall>
  801f4e:	83 c4 18             	add    $0x18,%esp
}
  801f51:	90                   	nop
  801f52:	c9                   	leave  
  801f53:	c3                   	ret    

00801f54 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801f54:	55                   	push   %ebp
  801f55:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801f57:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5a:	6a 00                	push   $0x0
  801f5c:	6a 00                	push   $0x0
  801f5e:	6a 00                	push   $0x0
  801f60:	ff 75 0c             	pushl  0xc(%ebp)
  801f63:	50                   	push   %eax
  801f64:	6a 17                	push   $0x17
  801f66:	e8 9c fd ff ff       	call   801d07 <syscall>
  801f6b:	83 c4 18             	add    $0x18,%esp
}
  801f6e:	c9                   	leave  
  801f6f:	c3                   	ret    

00801f70 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801f70:	55                   	push   %ebp
  801f71:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f73:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f76:	8b 45 08             	mov    0x8(%ebp),%eax
  801f79:	6a 00                	push   $0x0
  801f7b:	6a 00                	push   $0x0
  801f7d:	6a 00                	push   $0x0
  801f7f:	52                   	push   %edx
  801f80:	50                   	push   %eax
  801f81:	6a 1a                	push   $0x1a
  801f83:	e8 7f fd ff ff       	call   801d07 <syscall>
  801f88:	83 c4 18             	add    $0x18,%esp
}
  801f8b:	c9                   	leave  
  801f8c:	c3                   	ret    

00801f8d <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f8d:	55                   	push   %ebp
  801f8e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f90:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f93:	8b 45 08             	mov    0x8(%ebp),%eax
  801f96:	6a 00                	push   $0x0
  801f98:	6a 00                	push   $0x0
  801f9a:	6a 00                	push   $0x0
  801f9c:	52                   	push   %edx
  801f9d:	50                   	push   %eax
  801f9e:	6a 18                	push   $0x18
  801fa0:	e8 62 fd ff ff       	call   801d07 <syscall>
  801fa5:	83 c4 18             	add    $0x18,%esp
}
  801fa8:	90                   	nop
  801fa9:	c9                   	leave  
  801faa:	c3                   	ret    

00801fab <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801fab:	55                   	push   %ebp
  801fac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801fae:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb4:	6a 00                	push   $0x0
  801fb6:	6a 00                	push   $0x0
  801fb8:	6a 00                	push   $0x0
  801fba:	52                   	push   %edx
  801fbb:	50                   	push   %eax
  801fbc:	6a 19                	push   $0x19
  801fbe:	e8 44 fd ff ff       	call   801d07 <syscall>
  801fc3:	83 c4 18             	add    $0x18,%esp
}
  801fc6:	90                   	nop
  801fc7:	c9                   	leave  
  801fc8:	c3                   	ret    

00801fc9 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801fc9:	55                   	push   %ebp
  801fca:	89 e5                	mov    %esp,%ebp
  801fcc:	83 ec 04             	sub    $0x4,%esp
  801fcf:	8b 45 10             	mov    0x10(%ebp),%eax
  801fd2:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801fd5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801fd8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdf:	6a 00                	push   $0x0
  801fe1:	51                   	push   %ecx
  801fe2:	52                   	push   %edx
  801fe3:	ff 75 0c             	pushl  0xc(%ebp)
  801fe6:	50                   	push   %eax
  801fe7:	6a 1b                	push   $0x1b
  801fe9:	e8 19 fd ff ff       	call   801d07 <syscall>
  801fee:	83 c4 18             	add    $0x18,%esp
}
  801ff1:	c9                   	leave  
  801ff2:	c3                   	ret    

00801ff3 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ff3:	55                   	push   %ebp
  801ff4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ff6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffc:	6a 00                	push   $0x0
  801ffe:	6a 00                	push   $0x0
  802000:	6a 00                	push   $0x0
  802002:	52                   	push   %edx
  802003:	50                   	push   %eax
  802004:	6a 1c                	push   $0x1c
  802006:	e8 fc fc ff ff       	call   801d07 <syscall>
  80200b:	83 c4 18             	add    $0x18,%esp
}
  80200e:	c9                   	leave  
  80200f:	c3                   	ret    

00802010 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802010:	55                   	push   %ebp
  802011:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802013:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802016:	8b 55 0c             	mov    0xc(%ebp),%edx
  802019:	8b 45 08             	mov    0x8(%ebp),%eax
  80201c:	6a 00                	push   $0x0
  80201e:	6a 00                	push   $0x0
  802020:	51                   	push   %ecx
  802021:	52                   	push   %edx
  802022:	50                   	push   %eax
  802023:	6a 1d                	push   $0x1d
  802025:	e8 dd fc ff ff       	call   801d07 <syscall>
  80202a:	83 c4 18             	add    $0x18,%esp
}
  80202d:	c9                   	leave  
  80202e:	c3                   	ret    

0080202f <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80202f:	55                   	push   %ebp
  802030:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802032:	8b 55 0c             	mov    0xc(%ebp),%edx
  802035:	8b 45 08             	mov    0x8(%ebp),%eax
  802038:	6a 00                	push   $0x0
  80203a:	6a 00                	push   $0x0
  80203c:	6a 00                	push   $0x0
  80203e:	52                   	push   %edx
  80203f:	50                   	push   %eax
  802040:	6a 1e                	push   $0x1e
  802042:	e8 c0 fc ff ff       	call   801d07 <syscall>
  802047:	83 c4 18             	add    $0x18,%esp
}
  80204a:	c9                   	leave  
  80204b:	c3                   	ret    

0080204c <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80204c:	55                   	push   %ebp
  80204d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80204f:	6a 00                	push   $0x0
  802051:	6a 00                	push   $0x0
  802053:	6a 00                	push   $0x0
  802055:	6a 00                	push   $0x0
  802057:	6a 00                	push   $0x0
  802059:	6a 1f                	push   $0x1f
  80205b:	e8 a7 fc ff ff       	call   801d07 <syscall>
  802060:	83 c4 18             	add    $0x18,%esp
}
  802063:	c9                   	leave  
  802064:	c3                   	ret    

00802065 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802065:	55                   	push   %ebp
  802066:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802068:	8b 45 08             	mov    0x8(%ebp),%eax
  80206b:	6a 00                	push   $0x0
  80206d:	ff 75 14             	pushl  0x14(%ebp)
  802070:	ff 75 10             	pushl  0x10(%ebp)
  802073:	ff 75 0c             	pushl  0xc(%ebp)
  802076:	50                   	push   %eax
  802077:	6a 20                	push   $0x20
  802079:	e8 89 fc ff ff       	call   801d07 <syscall>
  80207e:	83 c4 18             	add    $0x18,%esp
}
  802081:	c9                   	leave  
  802082:	c3                   	ret    

00802083 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802083:	55                   	push   %ebp
  802084:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802086:	8b 45 08             	mov    0x8(%ebp),%eax
  802089:	6a 00                	push   $0x0
  80208b:	6a 00                	push   $0x0
  80208d:	6a 00                	push   $0x0
  80208f:	6a 00                	push   $0x0
  802091:	50                   	push   %eax
  802092:	6a 21                	push   $0x21
  802094:	e8 6e fc ff ff       	call   801d07 <syscall>
  802099:	83 c4 18             	add    $0x18,%esp
}
  80209c:	90                   	nop
  80209d:	c9                   	leave  
  80209e:	c3                   	ret    

0080209f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80209f:	55                   	push   %ebp
  8020a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8020a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a5:	6a 00                	push   $0x0
  8020a7:	6a 00                	push   $0x0
  8020a9:	6a 00                	push   $0x0
  8020ab:	6a 00                	push   $0x0
  8020ad:	50                   	push   %eax
  8020ae:	6a 22                	push   $0x22
  8020b0:	e8 52 fc ff ff       	call   801d07 <syscall>
  8020b5:	83 c4 18             	add    $0x18,%esp
}
  8020b8:	c9                   	leave  
  8020b9:	c3                   	ret    

008020ba <sys_getenvid>:

int32 sys_getenvid(void)
{
  8020ba:	55                   	push   %ebp
  8020bb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8020bd:	6a 00                	push   $0x0
  8020bf:	6a 00                	push   $0x0
  8020c1:	6a 00                	push   $0x0
  8020c3:	6a 00                	push   $0x0
  8020c5:	6a 00                	push   $0x0
  8020c7:	6a 02                	push   $0x2
  8020c9:	e8 39 fc ff ff       	call   801d07 <syscall>
  8020ce:	83 c4 18             	add    $0x18,%esp
}
  8020d1:	c9                   	leave  
  8020d2:	c3                   	ret    

008020d3 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8020d3:	55                   	push   %ebp
  8020d4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8020d6:	6a 00                	push   $0x0
  8020d8:	6a 00                	push   $0x0
  8020da:	6a 00                	push   $0x0
  8020dc:	6a 00                	push   $0x0
  8020de:	6a 00                	push   $0x0
  8020e0:	6a 03                	push   $0x3
  8020e2:	e8 20 fc ff ff       	call   801d07 <syscall>
  8020e7:	83 c4 18             	add    $0x18,%esp
}
  8020ea:	c9                   	leave  
  8020eb:	c3                   	ret    

008020ec <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8020ec:	55                   	push   %ebp
  8020ed:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8020ef:	6a 00                	push   $0x0
  8020f1:	6a 00                	push   $0x0
  8020f3:	6a 00                	push   $0x0
  8020f5:	6a 00                	push   $0x0
  8020f7:	6a 00                	push   $0x0
  8020f9:	6a 04                	push   $0x4
  8020fb:	e8 07 fc ff ff       	call   801d07 <syscall>
  802100:	83 c4 18             	add    $0x18,%esp
}
  802103:	c9                   	leave  
  802104:	c3                   	ret    

00802105 <sys_exit_env>:


void sys_exit_env(void)
{
  802105:	55                   	push   %ebp
  802106:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802108:	6a 00                	push   $0x0
  80210a:	6a 00                	push   $0x0
  80210c:	6a 00                	push   $0x0
  80210e:	6a 00                	push   $0x0
  802110:	6a 00                	push   $0x0
  802112:	6a 23                	push   $0x23
  802114:	e8 ee fb ff ff       	call   801d07 <syscall>
  802119:	83 c4 18             	add    $0x18,%esp
}
  80211c:	90                   	nop
  80211d:	c9                   	leave  
  80211e:	c3                   	ret    

0080211f <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80211f:	55                   	push   %ebp
  802120:	89 e5                	mov    %esp,%ebp
  802122:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802125:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802128:	8d 50 04             	lea    0x4(%eax),%edx
  80212b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80212e:	6a 00                	push   $0x0
  802130:	6a 00                	push   $0x0
  802132:	6a 00                	push   $0x0
  802134:	52                   	push   %edx
  802135:	50                   	push   %eax
  802136:	6a 24                	push   $0x24
  802138:	e8 ca fb ff ff       	call   801d07 <syscall>
  80213d:	83 c4 18             	add    $0x18,%esp
	return result;
  802140:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802143:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802146:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802149:	89 01                	mov    %eax,(%ecx)
  80214b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80214e:	8b 45 08             	mov    0x8(%ebp),%eax
  802151:	c9                   	leave  
  802152:	c2 04 00             	ret    $0x4

00802155 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802155:	55                   	push   %ebp
  802156:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802158:	6a 00                	push   $0x0
  80215a:	6a 00                	push   $0x0
  80215c:	ff 75 10             	pushl  0x10(%ebp)
  80215f:	ff 75 0c             	pushl  0xc(%ebp)
  802162:	ff 75 08             	pushl  0x8(%ebp)
  802165:	6a 12                	push   $0x12
  802167:	e8 9b fb ff ff       	call   801d07 <syscall>
  80216c:	83 c4 18             	add    $0x18,%esp
	return ;
  80216f:	90                   	nop
}
  802170:	c9                   	leave  
  802171:	c3                   	ret    

00802172 <sys_rcr2>:
uint32 sys_rcr2()
{
  802172:	55                   	push   %ebp
  802173:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802175:	6a 00                	push   $0x0
  802177:	6a 00                	push   $0x0
  802179:	6a 00                	push   $0x0
  80217b:	6a 00                	push   $0x0
  80217d:	6a 00                	push   $0x0
  80217f:	6a 25                	push   $0x25
  802181:	e8 81 fb ff ff       	call   801d07 <syscall>
  802186:	83 c4 18             	add    $0x18,%esp
}
  802189:	c9                   	leave  
  80218a:	c3                   	ret    

0080218b <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80218b:	55                   	push   %ebp
  80218c:	89 e5                	mov    %esp,%ebp
  80218e:	83 ec 04             	sub    $0x4,%esp
  802191:	8b 45 08             	mov    0x8(%ebp),%eax
  802194:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802197:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80219b:	6a 00                	push   $0x0
  80219d:	6a 00                	push   $0x0
  80219f:	6a 00                	push   $0x0
  8021a1:	6a 00                	push   $0x0
  8021a3:	50                   	push   %eax
  8021a4:	6a 26                	push   $0x26
  8021a6:	e8 5c fb ff ff       	call   801d07 <syscall>
  8021ab:	83 c4 18             	add    $0x18,%esp
	return ;
  8021ae:	90                   	nop
}
  8021af:	c9                   	leave  
  8021b0:	c3                   	ret    

008021b1 <rsttst>:
void rsttst()
{
  8021b1:	55                   	push   %ebp
  8021b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8021b4:	6a 00                	push   $0x0
  8021b6:	6a 00                	push   $0x0
  8021b8:	6a 00                	push   $0x0
  8021ba:	6a 00                	push   $0x0
  8021bc:	6a 00                	push   $0x0
  8021be:	6a 28                	push   $0x28
  8021c0:	e8 42 fb ff ff       	call   801d07 <syscall>
  8021c5:	83 c4 18             	add    $0x18,%esp
	return ;
  8021c8:	90                   	nop
}
  8021c9:	c9                   	leave  
  8021ca:	c3                   	ret    

008021cb <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8021cb:	55                   	push   %ebp
  8021cc:	89 e5                	mov    %esp,%ebp
  8021ce:	83 ec 04             	sub    $0x4,%esp
  8021d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8021d4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8021d7:	8b 55 18             	mov    0x18(%ebp),%edx
  8021da:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8021de:	52                   	push   %edx
  8021df:	50                   	push   %eax
  8021e0:	ff 75 10             	pushl  0x10(%ebp)
  8021e3:	ff 75 0c             	pushl  0xc(%ebp)
  8021e6:	ff 75 08             	pushl  0x8(%ebp)
  8021e9:	6a 27                	push   $0x27
  8021eb:	e8 17 fb ff ff       	call   801d07 <syscall>
  8021f0:	83 c4 18             	add    $0x18,%esp
	return ;
  8021f3:	90                   	nop
}
  8021f4:	c9                   	leave  
  8021f5:	c3                   	ret    

008021f6 <chktst>:
void chktst(uint32 n)
{
  8021f6:	55                   	push   %ebp
  8021f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8021f9:	6a 00                	push   $0x0
  8021fb:	6a 00                	push   $0x0
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 00                	push   $0x0
  802201:	ff 75 08             	pushl  0x8(%ebp)
  802204:	6a 29                	push   $0x29
  802206:	e8 fc fa ff ff       	call   801d07 <syscall>
  80220b:	83 c4 18             	add    $0x18,%esp
	return ;
  80220e:	90                   	nop
}
  80220f:	c9                   	leave  
  802210:	c3                   	ret    

00802211 <inctst>:

void inctst()
{
  802211:	55                   	push   %ebp
  802212:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802214:	6a 00                	push   $0x0
  802216:	6a 00                	push   $0x0
  802218:	6a 00                	push   $0x0
  80221a:	6a 00                	push   $0x0
  80221c:	6a 00                	push   $0x0
  80221e:	6a 2a                	push   $0x2a
  802220:	e8 e2 fa ff ff       	call   801d07 <syscall>
  802225:	83 c4 18             	add    $0x18,%esp
	return ;
  802228:	90                   	nop
}
  802229:	c9                   	leave  
  80222a:	c3                   	ret    

0080222b <gettst>:
uint32 gettst()
{
  80222b:	55                   	push   %ebp
  80222c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80222e:	6a 00                	push   $0x0
  802230:	6a 00                	push   $0x0
  802232:	6a 00                	push   $0x0
  802234:	6a 00                	push   $0x0
  802236:	6a 00                	push   $0x0
  802238:	6a 2b                	push   $0x2b
  80223a:	e8 c8 fa ff ff       	call   801d07 <syscall>
  80223f:	83 c4 18             	add    $0x18,%esp
}
  802242:	c9                   	leave  
  802243:	c3                   	ret    

00802244 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802244:	55                   	push   %ebp
  802245:	89 e5                	mov    %esp,%ebp
  802247:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80224a:	6a 00                	push   $0x0
  80224c:	6a 00                	push   $0x0
  80224e:	6a 00                	push   $0x0
  802250:	6a 00                	push   $0x0
  802252:	6a 00                	push   $0x0
  802254:	6a 2c                	push   $0x2c
  802256:	e8 ac fa ff ff       	call   801d07 <syscall>
  80225b:	83 c4 18             	add    $0x18,%esp
  80225e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802261:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802265:	75 07                	jne    80226e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802267:	b8 01 00 00 00       	mov    $0x1,%eax
  80226c:	eb 05                	jmp    802273 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80226e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802273:	c9                   	leave  
  802274:	c3                   	ret    

00802275 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802275:	55                   	push   %ebp
  802276:	89 e5                	mov    %esp,%ebp
  802278:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80227b:	6a 00                	push   $0x0
  80227d:	6a 00                	push   $0x0
  80227f:	6a 00                	push   $0x0
  802281:	6a 00                	push   $0x0
  802283:	6a 00                	push   $0x0
  802285:	6a 2c                	push   $0x2c
  802287:	e8 7b fa ff ff       	call   801d07 <syscall>
  80228c:	83 c4 18             	add    $0x18,%esp
  80228f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802292:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802296:	75 07                	jne    80229f <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802298:	b8 01 00 00 00       	mov    $0x1,%eax
  80229d:	eb 05                	jmp    8022a4 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80229f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022a4:	c9                   	leave  
  8022a5:	c3                   	ret    

008022a6 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8022a6:	55                   	push   %ebp
  8022a7:	89 e5                	mov    %esp,%ebp
  8022a9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022ac:	6a 00                	push   $0x0
  8022ae:	6a 00                	push   $0x0
  8022b0:	6a 00                	push   $0x0
  8022b2:	6a 00                	push   $0x0
  8022b4:	6a 00                	push   $0x0
  8022b6:	6a 2c                	push   $0x2c
  8022b8:	e8 4a fa ff ff       	call   801d07 <syscall>
  8022bd:	83 c4 18             	add    $0x18,%esp
  8022c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8022c3:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8022c7:	75 07                	jne    8022d0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8022c9:	b8 01 00 00 00       	mov    $0x1,%eax
  8022ce:	eb 05                	jmp    8022d5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8022d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022d5:	c9                   	leave  
  8022d6:	c3                   	ret    

008022d7 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8022d7:	55                   	push   %ebp
  8022d8:	89 e5                	mov    %esp,%ebp
  8022da:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022dd:	6a 00                	push   $0x0
  8022df:	6a 00                	push   $0x0
  8022e1:	6a 00                	push   $0x0
  8022e3:	6a 00                	push   $0x0
  8022e5:	6a 00                	push   $0x0
  8022e7:	6a 2c                	push   $0x2c
  8022e9:	e8 19 fa ff ff       	call   801d07 <syscall>
  8022ee:	83 c4 18             	add    $0x18,%esp
  8022f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8022f4:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8022f8:	75 07                	jne    802301 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8022fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8022ff:	eb 05                	jmp    802306 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802301:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802306:	c9                   	leave  
  802307:	c3                   	ret    

00802308 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802308:	55                   	push   %ebp
  802309:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80230b:	6a 00                	push   $0x0
  80230d:	6a 00                	push   $0x0
  80230f:	6a 00                	push   $0x0
  802311:	6a 00                	push   $0x0
  802313:	ff 75 08             	pushl  0x8(%ebp)
  802316:	6a 2d                	push   $0x2d
  802318:	e8 ea f9 ff ff       	call   801d07 <syscall>
  80231d:	83 c4 18             	add    $0x18,%esp
	return ;
  802320:	90                   	nop
}
  802321:	c9                   	leave  
  802322:	c3                   	ret    

00802323 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802323:	55                   	push   %ebp
  802324:	89 e5                	mov    %esp,%ebp
  802326:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802327:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80232a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80232d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802330:	8b 45 08             	mov    0x8(%ebp),%eax
  802333:	6a 00                	push   $0x0
  802335:	53                   	push   %ebx
  802336:	51                   	push   %ecx
  802337:	52                   	push   %edx
  802338:	50                   	push   %eax
  802339:	6a 2e                	push   $0x2e
  80233b:	e8 c7 f9 ff ff       	call   801d07 <syscall>
  802340:	83 c4 18             	add    $0x18,%esp
}
  802343:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802346:	c9                   	leave  
  802347:	c3                   	ret    

00802348 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802348:	55                   	push   %ebp
  802349:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80234b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80234e:	8b 45 08             	mov    0x8(%ebp),%eax
  802351:	6a 00                	push   $0x0
  802353:	6a 00                	push   $0x0
  802355:	6a 00                	push   $0x0
  802357:	52                   	push   %edx
  802358:	50                   	push   %eax
  802359:	6a 2f                	push   $0x2f
  80235b:	e8 a7 f9 ff ff       	call   801d07 <syscall>
  802360:	83 c4 18             	add    $0x18,%esp
}
  802363:	c9                   	leave  
  802364:	c3                   	ret    

00802365 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802365:	55                   	push   %ebp
  802366:	89 e5                	mov    %esp,%ebp
  802368:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80236b:	83 ec 0c             	sub    $0xc,%esp
  80236e:	68 0c 45 80 00       	push   $0x80450c
  802373:	e8 cd e6 ff ff       	call   800a45 <cprintf>
  802378:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80237b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802382:	83 ec 0c             	sub    $0xc,%esp
  802385:	68 38 45 80 00       	push   $0x804538
  80238a:	e8 b6 e6 ff ff       	call   800a45 <cprintf>
  80238f:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802392:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802396:	a1 38 51 80 00       	mov    0x805138,%eax
  80239b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80239e:	eb 56                	jmp    8023f6 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8023a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023a4:	74 1c                	je     8023c2 <print_mem_block_lists+0x5d>
  8023a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a9:	8b 50 08             	mov    0x8(%eax),%edx
  8023ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023af:	8b 48 08             	mov    0x8(%eax),%ecx
  8023b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8023b8:	01 c8                	add    %ecx,%eax
  8023ba:	39 c2                	cmp    %eax,%edx
  8023bc:	73 04                	jae    8023c2 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8023be:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8023c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c5:	8b 50 08             	mov    0x8(%eax),%edx
  8023c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8023ce:	01 c2                	add    %eax,%edx
  8023d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d3:	8b 40 08             	mov    0x8(%eax),%eax
  8023d6:	83 ec 04             	sub    $0x4,%esp
  8023d9:	52                   	push   %edx
  8023da:	50                   	push   %eax
  8023db:	68 4d 45 80 00       	push   $0x80454d
  8023e0:	e8 60 e6 ff ff       	call   800a45 <cprintf>
  8023e5:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8023e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8023ee:	a1 40 51 80 00       	mov    0x805140,%eax
  8023f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023fa:	74 07                	je     802403 <print_mem_block_lists+0x9e>
  8023fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ff:	8b 00                	mov    (%eax),%eax
  802401:	eb 05                	jmp    802408 <print_mem_block_lists+0xa3>
  802403:	b8 00 00 00 00       	mov    $0x0,%eax
  802408:	a3 40 51 80 00       	mov    %eax,0x805140
  80240d:	a1 40 51 80 00       	mov    0x805140,%eax
  802412:	85 c0                	test   %eax,%eax
  802414:	75 8a                	jne    8023a0 <print_mem_block_lists+0x3b>
  802416:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80241a:	75 84                	jne    8023a0 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80241c:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802420:	75 10                	jne    802432 <print_mem_block_lists+0xcd>
  802422:	83 ec 0c             	sub    $0xc,%esp
  802425:	68 5c 45 80 00       	push   $0x80455c
  80242a:	e8 16 e6 ff ff       	call   800a45 <cprintf>
  80242f:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802432:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802439:	83 ec 0c             	sub    $0xc,%esp
  80243c:	68 80 45 80 00       	push   $0x804580
  802441:	e8 ff e5 ff ff       	call   800a45 <cprintf>
  802446:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802449:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80244d:	a1 40 50 80 00       	mov    0x805040,%eax
  802452:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802455:	eb 56                	jmp    8024ad <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802457:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80245b:	74 1c                	je     802479 <print_mem_block_lists+0x114>
  80245d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802460:	8b 50 08             	mov    0x8(%eax),%edx
  802463:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802466:	8b 48 08             	mov    0x8(%eax),%ecx
  802469:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80246c:	8b 40 0c             	mov    0xc(%eax),%eax
  80246f:	01 c8                	add    %ecx,%eax
  802471:	39 c2                	cmp    %eax,%edx
  802473:	73 04                	jae    802479 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802475:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802479:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247c:	8b 50 08             	mov    0x8(%eax),%edx
  80247f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802482:	8b 40 0c             	mov    0xc(%eax),%eax
  802485:	01 c2                	add    %eax,%edx
  802487:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248a:	8b 40 08             	mov    0x8(%eax),%eax
  80248d:	83 ec 04             	sub    $0x4,%esp
  802490:	52                   	push   %edx
  802491:	50                   	push   %eax
  802492:	68 4d 45 80 00       	push   $0x80454d
  802497:	e8 a9 e5 ff ff       	call   800a45 <cprintf>
  80249c:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80249f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8024a5:	a1 48 50 80 00       	mov    0x805048,%eax
  8024aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024b1:	74 07                	je     8024ba <print_mem_block_lists+0x155>
  8024b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b6:	8b 00                	mov    (%eax),%eax
  8024b8:	eb 05                	jmp    8024bf <print_mem_block_lists+0x15a>
  8024ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8024bf:	a3 48 50 80 00       	mov    %eax,0x805048
  8024c4:	a1 48 50 80 00       	mov    0x805048,%eax
  8024c9:	85 c0                	test   %eax,%eax
  8024cb:	75 8a                	jne    802457 <print_mem_block_lists+0xf2>
  8024cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024d1:	75 84                	jne    802457 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8024d3:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8024d7:	75 10                	jne    8024e9 <print_mem_block_lists+0x184>
  8024d9:	83 ec 0c             	sub    $0xc,%esp
  8024dc:	68 98 45 80 00       	push   $0x804598
  8024e1:	e8 5f e5 ff ff       	call   800a45 <cprintf>
  8024e6:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8024e9:	83 ec 0c             	sub    $0xc,%esp
  8024ec:	68 0c 45 80 00       	push   $0x80450c
  8024f1:	e8 4f e5 ff ff       	call   800a45 <cprintf>
  8024f6:	83 c4 10             	add    $0x10,%esp

}
  8024f9:	90                   	nop
  8024fa:	c9                   	leave  
  8024fb:	c3                   	ret    

008024fc <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8024fc:	55                   	push   %ebp
  8024fd:	89 e5                	mov    %esp,%ebp
  8024ff:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802502:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802509:	00 00 00 
  80250c:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802513:	00 00 00 
  802516:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80251d:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802520:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802527:	e9 9e 00 00 00       	jmp    8025ca <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  80252c:	a1 50 50 80 00       	mov    0x805050,%eax
  802531:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802534:	c1 e2 04             	shl    $0x4,%edx
  802537:	01 d0                	add    %edx,%eax
  802539:	85 c0                	test   %eax,%eax
  80253b:	75 14                	jne    802551 <initialize_MemBlocksList+0x55>
  80253d:	83 ec 04             	sub    $0x4,%esp
  802540:	68 c0 45 80 00       	push   $0x8045c0
  802545:	6a 46                	push   $0x46
  802547:	68 e3 45 80 00       	push   $0x8045e3
  80254c:	e8 40 e2 ff ff       	call   800791 <_panic>
  802551:	a1 50 50 80 00       	mov    0x805050,%eax
  802556:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802559:	c1 e2 04             	shl    $0x4,%edx
  80255c:	01 d0                	add    %edx,%eax
  80255e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802564:	89 10                	mov    %edx,(%eax)
  802566:	8b 00                	mov    (%eax),%eax
  802568:	85 c0                	test   %eax,%eax
  80256a:	74 18                	je     802584 <initialize_MemBlocksList+0x88>
  80256c:	a1 48 51 80 00       	mov    0x805148,%eax
  802571:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802577:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80257a:	c1 e1 04             	shl    $0x4,%ecx
  80257d:	01 ca                	add    %ecx,%edx
  80257f:	89 50 04             	mov    %edx,0x4(%eax)
  802582:	eb 12                	jmp    802596 <initialize_MemBlocksList+0x9a>
  802584:	a1 50 50 80 00       	mov    0x805050,%eax
  802589:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80258c:	c1 e2 04             	shl    $0x4,%edx
  80258f:	01 d0                	add    %edx,%eax
  802591:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802596:	a1 50 50 80 00       	mov    0x805050,%eax
  80259b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80259e:	c1 e2 04             	shl    $0x4,%edx
  8025a1:	01 d0                	add    %edx,%eax
  8025a3:	a3 48 51 80 00       	mov    %eax,0x805148
  8025a8:	a1 50 50 80 00       	mov    0x805050,%eax
  8025ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025b0:	c1 e2 04             	shl    $0x4,%edx
  8025b3:	01 d0                	add    %edx,%eax
  8025b5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025bc:	a1 54 51 80 00       	mov    0x805154,%eax
  8025c1:	40                   	inc    %eax
  8025c2:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8025c7:	ff 45 f4             	incl   -0xc(%ebp)
  8025ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025d0:	0f 82 56 ff ff ff    	jb     80252c <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8025d6:	90                   	nop
  8025d7:	c9                   	leave  
  8025d8:	c3                   	ret    

008025d9 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8025d9:	55                   	push   %ebp
  8025da:	89 e5                	mov    %esp,%ebp
  8025dc:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8025df:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e2:	8b 00                	mov    (%eax),%eax
  8025e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8025e7:	eb 19                	jmp    802602 <find_block+0x29>
	{
		if(va==point->sva)
  8025e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025ec:	8b 40 08             	mov    0x8(%eax),%eax
  8025ef:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8025f2:	75 05                	jne    8025f9 <find_block+0x20>
		   return point;
  8025f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025f7:	eb 36                	jmp    80262f <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8025f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fc:	8b 40 08             	mov    0x8(%eax),%eax
  8025ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802602:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802606:	74 07                	je     80260f <find_block+0x36>
  802608:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80260b:	8b 00                	mov    (%eax),%eax
  80260d:	eb 05                	jmp    802614 <find_block+0x3b>
  80260f:	b8 00 00 00 00       	mov    $0x0,%eax
  802614:	8b 55 08             	mov    0x8(%ebp),%edx
  802617:	89 42 08             	mov    %eax,0x8(%edx)
  80261a:	8b 45 08             	mov    0x8(%ebp),%eax
  80261d:	8b 40 08             	mov    0x8(%eax),%eax
  802620:	85 c0                	test   %eax,%eax
  802622:	75 c5                	jne    8025e9 <find_block+0x10>
  802624:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802628:	75 bf                	jne    8025e9 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  80262a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80262f:	c9                   	leave  
  802630:	c3                   	ret    

00802631 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802631:	55                   	push   %ebp
  802632:	89 e5                	mov    %esp,%ebp
  802634:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802637:	a1 40 50 80 00       	mov    0x805040,%eax
  80263c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  80263f:	a1 44 50 80 00       	mov    0x805044,%eax
  802644:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802647:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80264a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80264d:	74 24                	je     802673 <insert_sorted_allocList+0x42>
  80264f:	8b 45 08             	mov    0x8(%ebp),%eax
  802652:	8b 50 08             	mov    0x8(%eax),%edx
  802655:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802658:	8b 40 08             	mov    0x8(%eax),%eax
  80265b:	39 c2                	cmp    %eax,%edx
  80265d:	76 14                	jbe    802673 <insert_sorted_allocList+0x42>
  80265f:	8b 45 08             	mov    0x8(%ebp),%eax
  802662:	8b 50 08             	mov    0x8(%eax),%edx
  802665:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802668:	8b 40 08             	mov    0x8(%eax),%eax
  80266b:	39 c2                	cmp    %eax,%edx
  80266d:	0f 82 60 01 00 00    	jb     8027d3 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802673:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802677:	75 65                	jne    8026de <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802679:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80267d:	75 14                	jne    802693 <insert_sorted_allocList+0x62>
  80267f:	83 ec 04             	sub    $0x4,%esp
  802682:	68 c0 45 80 00       	push   $0x8045c0
  802687:	6a 6b                	push   $0x6b
  802689:	68 e3 45 80 00       	push   $0x8045e3
  80268e:	e8 fe e0 ff ff       	call   800791 <_panic>
  802693:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802699:	8b 45 08             	mov    0x8(%ebp),%eax
  80269c:	89 10                	mov    %edx,(%eax)
  80269e:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a1:	8b 00                	mov    (%eax),%eax
  8026a3:	85 c0                	test   %eax,%eax
  8026a5:	74 0d                	je     8026b4 <insert_sorted_allocList+0x83>
  8026a7:	a1 40 50 80 00       	mov    0x805040,%eax
  8026ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8026af:	89 50 04             	mov    %edx,0x4(%eax)
  8026b2:	eb 08                	jmp    8026bc <insert_sorted_allocList+0x8b>
  8026b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b7:	a3 44 50 80 00       	mov    %eax,0x805044
  8026bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8026bf:	a3 40 50 80 00       	mov    %eax,0x805040
  8026c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026ce:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8026d3:	40                   	inc    %eax
  8026d4:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8026d9:	e9 dc 01 00 00       	jmp    8028ba <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8026de:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e1:	8b 50 08             	mov    0x8(%eax),%edx
  8026e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e7:	8b 40 08             	mov    0x8(%eax),%eax
  8026ea:	39 c2                	cmp    %eax,%edx
  8026ec:	77 6c                	ja     80275a <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8026ee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026f2:	74 06                	je     8026fa <insert_sorted_allocList+0xc9>
  8026f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026f8:	75 14                	jne    80270e <insert_sorted_allocList+0xdd>
  8026fa:	83 ec 04             	sub    $0x4,%esp
  8026fd:	68 fc 45 80 00       	push   $0x8045fc
  802702:	6a 6f                	push   $0x6f
  802704:	68 e3 45 80 00       	push   $0x8045e3
  802709:	e8 83 e0 ff ff       	call   800791 <_panic>
  80270e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802711:	8b 50 04             	mov    0x4(%eax),%edx
  802714:	8b 45 08             	mov    0x8(%ebp),%eax
  802717:	89 50 04             	mov    %edx,0x4(%eax)
  80271a:	8b 45 08             	mov    0x8(%ebp),%eax
  80271d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802720:	89 10                	mov    %edx,(%eax)
  802722:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802725:	8b 40 04             	mov    0x4(%eax),%eax
  802728:	85 c0                	test   %eax,%eax
  80272a:	74 0d                	je     802739 <insert_sorted_allocList+0x108>
  80272c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80272f:	8b 40 04             	mov    0x4(%eax),%eax
  802732:	8b 55 08             	mov    0x8(%ebp),%edx
  802735:	89 10                	mov    %edx,(%eax)
  802737:	eb 08                	jmp    802741 <insert_sorted_allocList+0x110>
  802739:	8b 45 08             	mov    0x8(%ebp),%eax
  80273c:	a3 40 50 80 00       	mov    %eax,0x805040
  802741:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802744:	8b 55 08             	mov    0x8(%ebp),%edx
  802747:	89 50 04             	mov    %edx,0x4(%eax)
  80274a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80274f:	40                   	inc    %eax
  802750:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802755:	e9 60 01 00 00       	jmp    8028ba <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80275a:	8b 45 08             	mov    0x8(%ebp),%eax
  80275d:	8b 50 08             	mov    0x8(%eax),%edx
  802760:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802763:	8b 40 08             	mov    0x8(%eax),%eax
  802766:	39 c2                	cmp    %eax,%edx
  802768:	0f 82 4c 01 00 00    	jb     8028ba <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80276e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802772:	75 14                	jne    802788 <insert_sorted_allocList+0x157>
  802774:	83 ec 04             	sub    $0x4,%esp
  802777:	68 34 46 80 00       	push   $0x804634
  80277c:	6a 73                	push   $0x73
  80277e:	68 e3 45 80 00       	push   $0x8045e3
  802783:	e8 09 e0 ff ff       	call   800791 <_panic>
  802788:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80278e:	8b 45 08             	mov    0x8(%ebp),%eax
  802791:	89 50 04             	mov    %edx,0x4(%eax)
  802794:	8b 45 08             	mov    0x8(%ebp),%eax
  802797:	8b 40 04             	mov    0x4(%eax),%eax
  80279a:	85 c0                	test   %eax,%eax
  80279c:	74 0c                	je     8027aa <insert_sorted_allocList+0x179>
  80279e:	a1 44 50 80 00       	mov    0x805044,%eax
  8027a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8027a6:	89 10                	mov    %edx,(%eax)
  8027a8:	eb 08                	jmp    8027b2 <insert_sorted_allocList+0x181>
  8027aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ad:	a3 40 50 80 00       	mov    %eax,0x805040
  8027b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b5:	a3 44 50 80 00       	mov    %eax,0x805044
  8027ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8027bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027c3:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8027c8:	40                   	inc    %eax
  8027c9:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8027ce:	e9 e7 00 00 00       	jmp    8028ba <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8027d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8027d9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8027e0:	a1 40 50 80 00       	mov    0x805040,%eax
  8027e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027e8:	e9 9d 00 00 00       	jmp    80288a <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8027ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f0:	8b 00                	mov    (%eax),%eax
  8027f2:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8027f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f8:	8b 50 08             	mov    0x8(%eax),%edx
  8027fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fe:	8b 40 08             	mov    0x8(%eax),%eax
  802801:	39 c2                	cmp    %eax,%edx
  802803:	76 7d                	jbe    802882 <insert_sorted_allocList+0x251>
  802805:	8b 45 08             	mov    0x8(%ebp),%eax
  802808:	8b 50 08             	mov    0x8(%eax),%edx
  80280b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80280e:	8b 40 08             	mov    0x8(%eax),%eax
  802811:	39 c2                	cmp    %eax,%edx
  802813:	73 6d                	jae    802882 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802815:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802819:	74 06                	je     802821 <insert_sorted_allocList+0x1f0>
  80281b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80281f:	75 14                	jne    802835 <insert_sorted_allocList+0x204>
  802821:	83 ec 04             	sub    $0x4,%esp
  802824:	68 58 46 80 00       	push   $0x804658
  802829:	6a 7f                	push   $0x7f
  80282b:	68 e3 45 80 00       	push   $0x8045e3
  802830:	e8 5c df ff ff       	call   800791 <_panic>
  802835:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802838:	8b 10                	mov    (%eax),%edx
  80283a:	8b 45 08             	mov    0x8(%ebp),%eax
  80283d:	89 10                	mov    %edx,(%eax)
  80283f:	8b 45 08             	mov    0x8(%ebp),%eax
  802842:	8b 00                	mov    (%eax),%eax
  802844:	85 c0                	test   %eax,%eax
  802846:	74 0b                	je     802853 <insert_sorted_allocList+0x222>
  802848:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284b:	8b 00                	mov    (%eax),%eax
  80284d:	8b 55 08             	mov    0x8(%ebp),%edx
  802850:	89 50 04             	mov    %edx,0x4(%eax)
  802853:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802856:	8b 55 08             	mov    0x8(%ebp),%edx
  802859:	89 10                	mov    %edx,(%eax)
  80285b:	8b 45 08             	mov    0x8(%ebp),%eax
  80285e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802861:	89 50 04             	mov    %edx,0x4(%eax)
  802864:	8b 45 08             	mov    0x8(%ebp),%eax
  802867:	8b 00                	mov    (%eax),%eax
  802869:	85 c0                	test   %eax,%eax
  80286b:	75 08                	jne    802875 <insert_sorted_allocList+0x244>
  80286d:	8b 45 08             	mov    0x8(%ebp),%eax
  802870:	a3 44 50 80 00       	mov    %eax,0x805044
  802875:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80287a:	40                   	inc    %eax
  80287b:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802880:	eb 39                	jmp    8028bb <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802882:	a1 48 50 80 00       	mov    0x805048,%eax
  802887:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80288a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80288e:	74 07                	je     802897 <insert_sorted_allocList+0x266>
  802890:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802893:	8b 00                	mov    (%eax),%eax
  802895:	eb 05                	jmp    80289c <insert_sorted_allocList+0x26b>
  802897:	b8 00 00 00 00       	mov    $0x0,%eax
  80289c:	a3 48 50 80 00       	mov    %eax,0x805048
  8028a1:	a1 48 50 80 00       	mov    0x805048,%eax
  8028a6:	85 c0                	test   %eax,%eax
  8028a8:	0f 85 3f ff ff ff    	jne    8027ed <insert_sorted_allocList+0x1bc>
  8028ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028b2:	0f 85 35 ff ff ff    	jne    8027ed <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8028b8:	eb 01                	jmp    8028bb <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8028ba:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8028bb:	90                   	nop
  8028bc:	c9                   	leave  
  8028bd:	c3                   	ret    

008028be <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8028be:	55                   	push   %ebp
  8028bf:	89 e5                	mov    %esp,%ebp
  8028c1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8028c4:	a1 38 51 80 00       	mov    0x805138,%eax
  8028c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028cc:	e9 85 01 00 00       	jmp    802a56 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8028d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8028d7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028da:	0f 82 6e 01 00 00    	jb     802a4e <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8028e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e3:	8b 40 0c             	mov    0xc(%eax),%eax
  8028e6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028e9:	0f 85 8a 00 00 00    	jne    802979 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8028ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028f3:	75 17                	jne    80290c <alloc_block_FF+0x4e>
  8028f5:	83 ec 04             	sub    $0x4,%esp
  8028f8:	68 8c 46 80 00       	push   $0x80468c
  8028fd:	68 93 00 00 00       	push   $0x93
  802902:	68 e3 45 80 00       	push   $0x8045e3
  802907:	e8 85 de ff ff       	call   800791 <_panic>
  80290c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290f:	8b 00                	mov    (%eax),%eax
  802911:	85 c0                	test   %eax,%eax
  802913:	74 10                	je     802925 <alloc_block_FF+0x67>
  802915:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802918:	8b 00                	mov    (%eax),%eax
  80291a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80291d:	8b 52 04             	mov    0x4(%edx),%edx
  802920:	89 50 04             	mov    %edx,0x4(%eax)
  802923:	eb 0b                	jmp    802930 <alloc_block_FF+0x72>
  802925:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802928:	8b 40 04             	mov    0x4(%eax),%eax
  80292b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802930:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802933:	8b 40 04             	mov    0x4(%eax),%eax
  802936:	85 c0                	test   %eax,%eax
  802938:	74 0f                	je     802949 <alloc_block_FF+0x8b>
  80293a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293d:	8b 40 04             	mov    0x4(%eax),%eax
  802940:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802943:	8b 12                	mov    (%edx),%edx
  802945:	89 10                	mov    %edx,(%eax)
  802947:	eb 0a                	jmp    802953 <alloc_block_FF+0x95>
  802949:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294c:	8b 00                	mov    (%eax),%eax
  80294e:	a3 38 51 80 00       	mov    %eax,0x805138
  802953:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802956:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80295c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802966:	a1 44 51 80 00       	mov    0x805144,%eax
  80296b:	48                   	dec    %eax
  80296c:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802971:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802974:	e9 10 01 00 00       	jmp    802a89 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802979:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297c:	8b 40 0c             	mov    0xc(%eax),%eax
  80297f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802982:	0f 86 c6 00 00 00    	jbe    802a4e <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802988:	a1 48 51 80 00       	mov    0x805148,%eax
  80298d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802990:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802993:	8b 50 08             	mov    0x8(%eax),%edx
  802996:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802999:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  80299c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80299f:	8b 55 08             	mov    0x8(%ebp),%edx
  8029a2:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8029a5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029a9:	75 17                	jne    8029c2 <alloc_block_FF+0x104>
  8029ab:	83 ec 04             	sub    $0x4,%esp
  8029ae:	68 8c 46 80 00       	push   $0x80468c
  8029b3:	68 9b 00 00 00       	push   $0x9b
  8029b8:	68 e3 45 80 00       	push   $0x8045e3
  8029bd:	e8 cf dd ff ff       	call   800791 <_panic>
  8029c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c5:	8b 00                	mov    (%eax),%eax
  8029c7:	85 c0                	test   %eax,%eax
  8029c9:	74 10                	je     8029db <alloc_block_FF+0x11d>
  8029cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ce:	8b 00                	mov    (%eax),%eax
  8029d0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029d3:	8b 52 04             	mov    0x4(%edx),%edx
  8029d6:	89 50 04             	mov    %edx,0x4(%eax)
  8029d9:	eb 0b                	jmp    8029e6 <alloc_block_FF+0x128>
  8029db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029de:	8b 40 04             	mov    0x4(%eax),%eax
  8029e1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e9:	8b 40 04             	mov    0x4(%eax),%eax
  8029ec:	85 c0                	test   %eax,%eax
  8029ee:	74 0f                	je     8029ff <alloc_block_FF+0x141>
  8029f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f3:	8b 40 04             	mov    0x4(%eax),%eax
  8029f6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029f9:	8b 12                	mov    (%edx),%edx
  8029fb:	89 10                	mov    %edx,(%eax)
  8029fd:	eb 0a                	jmp    802a09 <alloc_block_FF+0x14b>
  8029ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a02:	8b 00                	mov    (%eax),%eax
  802a04:	a3 48 51 80 00       	mov    %eax,0x805148
  802a09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a0c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a15:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a1c:	a1 54 51 80 00       	mov    0x805154,%eax
  802a21:	48                   	dec    %eax
  802a22:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2a:	8b 50 08             	mov    0x8(%eax),%edx
  802a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a30:	01 c2                	add    %eax,%edx
  802a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a35:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802a38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3b:	8b 40 0c             	mov    0xc(%eax),%eax
  802a3e:	2b 45 08             	sub    0x8(%ebp),%eax
  802a41:	89 c2                	mov    %eax,%edx
  802a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a46:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802a49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a4c:	eb 3b                	jmp    802a89 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802a4e:	a1 40 51 80 00       	mov    0x805140,%eax
  802a53:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a56:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a5a:	74 07                	je     802a63 <alloc_block_FF+0x1a5>
  802a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5f:	8b 00                	mov    (%eax),%eax
  802a61:	eb 05                	jmp    802a68 <alloc_block_FF+0x1aa>
  802a63:	b8 00 00 00 00       	mov    $0x0,%eax
  802a68:	a3 40 51 80 00       	mov    %eax,0x805140
  802a6d:	a1 40 51 80 00       	mov    0x805140,%eax
  802a72:	85 c0                	test   %eax,%eax
  802a74:	0f 85 57 fe ff ff    	jne    8028d1 <alloc_block_FF+0x13>
  802a7a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a7e:	0f 85 4d fe ff ff    	jne    8028d1 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802a84:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a89:	c9                   	leave  
  802a8a:	c3                   	ret    

00802a8b <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802a8b:	55                   	push   %ebp
  802a8c:	89 e5                	mov    %esp,%ebp
  802a8e:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802a91:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802a98:	a1 38 51 80 00       	mov    0x805138,%eax
  802a9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aa0:	e9 df 00 00 00       	jmp    802b84 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa8:	8b 40 0c             	mov    0xc(%eax),%eax
  802aab:	3b 45 08             	cmp    0x8(%ebp),%eax
  802aae:	0f 82 c8 00 00 00    	jb     802b7c <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab7:	8b 40 0c             	mov    0xc(%eax),%eax
  802aba:	3b 45 08             	cmp    0x8(%ebp),%eax
  802abd:	0f 85 8a 00 00 00    	jne    802b4d <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802ac3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ac7:	75 17                	jne    802ae0 <alloc_block_BF+0x55>
  802ac9:	83 ec 04             	sub    $0x4,%esp
  802acc:	68 8c 46 80 00       	push   $0x80468c
  802ad1:	68 b7 00 00 00       	push   $0xb7
  802ad6:	68 e3 45 80 00       	push   $0x8045e3
  802adb:	e8 b1 dc ff ff       	call   800791 <_panic>
  802ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae3:	8b 00                	mov    (%eax),%eax
  802ae5:	85 c0                	test   %eax,%eax
  802ae7:	74 10                	je     802af9 <alloc_block_BF+0x6e>
  802ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aec:	8b 00                	mov    (%eax),%eax
  802aee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802af1:	8b 52 04             	mov    0x4(%edx),%edx
  802af4:	89 50 04             	mov    %edx,0x4(%eax)
  802af7:	eb 0b                	jmp    802b04 <alloc_block_BF+0x79>
  802af9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afc:	8b 40 04             	mov    0x4(%eax),%eax
  802aff:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b07:	8b 40 04             	mov    0x4(%eax),%eax
  802b0a:	85 c0                	test   %eax,%eax
  802b0c:	74 0f                	je     802b1d <alloc_block_BF+0x92>
  802b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b11:	8b 40 04             	mov    0x4(%eax),%eax
  802b14:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b17:	8b 12                	mov    (%edx),%edx
  802b19:	89 10                	mov    %edx,(%eax)
  802b1b:	eb 0a                	jmp    802b27 <alloc_block_BF+0x9c>
  802b1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b20:	8b 00                	mov    (%eax),%eax
  802b22:	a3 38 51 80 00       	mov    %eax,0x805138
  802b27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b33:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b3a:	a1 44 51 80 00       	mov    0x805144,%eax
  802b3f:	48                   	dec    %eax
  802b40:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b48:	e9 4d 01 00 00       	jmp    802c9a <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b50:	8b 40 0c             	mov    0xc(%eax),%eax
  802b53:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b56:	76 24                	jbe    802b7c <alloc_block_BF+0xf1>
  802b58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5b:	8b 40 0c             	mov    0xc(%eax),%eax
  802b5e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802b61:	73 19                	jae    802b7c <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802b63:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802b6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6d:	8b 40 0c             	mov    0xc(%eax),%eax
  802b70:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b76:	8b 40 08             	mov    0x8(%eax),%eax
  802b79:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802b7c:	a1 40 51 80 00       	mov    0x805140,%eax
  802b81:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b84:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b88:	74 07                	je     802b91 <alloc_block_BF+0x106>
  802b8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8d:	8b 00                	mov    (%eax),%eax
  802b8f:	eb 05                	jmp    802b96 <alloc_block_BF+0x10b>
  802b91:	b8 00 00 00 00       	mov    $0x0,%eax
  802b96:	a3 40 51 80 00       	mov    %eax,0x805140
  802b9b:	a1 40 51 80 00       	mov    0x805140,%eax
  802ba0:	85 c0                	test   %eax,%eax
  802ba2:	0f 85 fd fe ff ff    	jne    802aa5 <alloc_block_BF+0x1a>
  802ba8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bac:	0f 85 f3 fe ff ff    	jne    802aa5 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802bb2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802bb6:	0f 84 d9 00 00 00    	je     802c95 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802bbc:	a1 48 51 80 00       	mov    0x805148,%eax
  802bc1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802bc4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bc7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bca:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802bcd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bd0:	8b 55 08             	mov    0x8(%ebp),%edx
  802bd3:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802bd6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802bda:	75 17                	jne    802bf3 <alloc_block_BF+0x168>
  802bdc:	83 ec 04             	sub    $0x4,%esp
  802bdf:	68 8c 46 80 00       	push   $0x80468c
  802be4:	68 c7 00 00 00       	push   $0xc7
  802be9:	68 e3 45 80 00       	push   $0x8045e3
  802bee:	e8 9e db ff ff       	call   800791 <_panic>
  802bf3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bf6:	8b 00                	mov    (%eax),%eax
  802bf8:	85 c0                	test   %eax,%eax
  802bfa:	74 10                	je     802c0c <alloc_block_BF+0x181>
  802bfc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bff:	8b 00                	mov    (%eax),%eax
  802c01:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c04:	8b 52 04             	mov    0x4(%edx),%edx
  802c07:	89 50 04             	mov    %edx,0x4(%eax)
  802c0a:	eb 0b                	jmp    802c17 <alloc_block_BF+0x18c>
  802c0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c0f:	8b 40 04             	mov    0x4(%eax),%eax
  802c12:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c1a:	8b 40 04             	mov    0x4(%eax),%eax
  802c1d:	85 c0                	test   %eax,%eax
  802c1f:	74 0f                	je     802c30 <alloc_block_BF+0x1a5>
  802c21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c24:	8b 40 04             	mov    0x4(%eax),%eax
  802c27:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c2a:	8b 12                	mov    (%edx),%edx
  802c2c:	89 10                	mov    %edx,(%eax)
  802c2e:	eb 0a                	jmp    802c3a <alloc_block_BF+0x1af>
  802c30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c33:	8b 00                	mov    (%eax),%eax
  802c35:	a3 48 51 80 00       	mov    %eax,0x805148
  802c3a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c3d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c46:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c4d:	a1 54 51 80 00       	mov    0x805154,%eax
  802c52:	48                   	dec    %eax
  802c53:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802c58:	83 ec 08             	sub    $0x8,%esp
  802c5b:	ff 75 ec             	pushl  -0x14(%ebp)
  802c5e:	68 38 51 80 00       	push   $0x805138
  802c63:	e8 71 f9 ff ff       	call   8025d9 <find_block>
  802c68:	83 c4 10             	add    $0x10,%esp
  802c6b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802c6e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c71:	8b 50 08             	mov    0x8(%eax),%edx
  802c74:	8b 45 08             	mov    0x8(%ebp),%eax
  802c77:	01 c2                	add    %eax,%edx
  802c79:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c7c:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802c7f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c82:	8b 40 0c             	mov    0xc(%eax),%eax
  802c85:	2b 45 08             	sub    0x8(%ebp),%eax
  802c88:	89 c2                	mov    %eax,%edx
  802c8a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c8d:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802c90:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c93:	eb 05                	jmp    802c9a <alloc_block_BF+0x20f>
	}
	return NULL;
  802c95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c9a:	c9                   	leave  
  802c9b:	c3                   	ret    

00802c9c <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802c9c:	55                   	push   %ebp
  802c9d:	89 e5                	mov    %esp,%ebp
  802c9f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802ca2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802ca7:	85 c0                	test   %eax,%eax
  802ca9:	0f 85 de 01 00 00    	jne    802e8d <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802caf:	a1 38 51 80 00       	mov    0x805138,%eax
  802cb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cb7:	e9 9e 01 00 00       	jmp    802e5a <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802cbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbf:	8b 40 0c             	mov    0xc(%eax),%eax
  802cc2:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cc5:	0f 82 87 01 00 00    	jb     802e52 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802ccb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cce:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd1:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cd4:	0f 85 95 00 00 00    	jne    802d6f <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802cda:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cde:	75 17                	jne    802cf7 <alloc_block_NF+0x5b>
  802ce0:	83 ec 04             	sub    $0x4,%esp
  802ce3:	68 8c 46 80 00       	push   $0x80468c
  802ce8:	68 e0 00 00 00       	push   $0xe0
  802ced:	68 e3 45 80 00       	push   $0x8045e3
  802cf2:	e8 9a da ff ff       	call   800791 <_panic>
  802cf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfa:	8b 00                	mov    (%eax),%eax
  802cfc:	85 c0                	test   %eax,%eax
  802cfe:	74 10                	je     802d10 <alloc_block_NF+0x74>
  802d00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d03:	8b 00                	mov    (%eax),%eax
  802d05:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d08:	8b 52 04             	mov    0x4(%edx),%edx
  802d0b:	89 50 04             	mov    %edx,0x4(%eax)
  802d0e:	eb 0b                	jmp    802d1b <alloc_block_NF+0x7f>
  802d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d13:	8b 40 04             	mov    0x4(%eax),%eax
  802d16:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1e:	8b 40 04             	mov    0x4(%eax),%eax
  802d21:	85 c0                	test   %eax,%eax
  802d23:	74 0f                	je     802d34 <alloc_block_NF+0x98>
  802d25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d28:	8b 40 04             	mov    0x4(%eax),%eax
  802d2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d2e:	8b 12                	mov    (%edx),%edx
  802d30:	89 10                	mov    %edx,(%eax)
  802d32:	eb 0a                	jmp    802d3e <alloc_block_NF+0xa2>
  802d34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d37:	8b 00                	mov    (%eax),%eax
  802d39:	a3 38 51 80 00       	mov    %eax,0x805138
  802d3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d41:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d51:	a1 44 51 80 00       	mov    0x805144,%eax
  802d56:	48                   	dec    %eax
  802d57:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802d5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5f:	8b 40 08             	mov    0x8(%eax),%eax
  802d62:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   return  point;
  802d67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6a:	e9 f8 04 00 00       	jmp    803267 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d72:	8b 40 0c             	mov    0xc(%eax),%eax
  802d75:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d78:	0f 86 d4 00 00 00    	jbe    802e52 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d7e:	a1 48 51 80 00       	mov    0x805148,%eax
  802d83:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802d86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d89:	8b 50 08             	mov    0x8(%eax),%edx
  802d8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d8f:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802d92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d95:	8b 55 08             	mov    0x8(%ebp),%edx
  802d98:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802d9b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d9f:	75 17                	jne    802db8 <alloc_block_NF+0x11c>
  802da1:	83 ec 04             	sub    $0x4,%esp
  802da4:	68 8c 46 80 00       	push   $0x80468c
  802da9:	68 e9 00 00 00       	push   $0xe9
  802dae:	68 e3 45 80 00       	push   $0x8045e3
  802db3:	e8 d9 d9 ff ff       	call   800791 <_panic>
  802db8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dbb:	8b 00                	mov    (%eax),%eax
  802dbd:	85 c0                	test   %eax,%eax
  802dbf:	74 10                	je     802dd1 <alloc_block_NF+0x135>
  802dc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc4:	8b 00                	mov    (%eax),%eax
  802dc6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dc9:	8b 52 04             	mov    0x4(%edx),%edx
  802dcc:	89 50 04             	mov    %edx,0x4(%eax)
  802dcf:	eb 0b                	jmp    802ddc <alloc_block_NF+0x140>
  802dd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd4:	8b 40 04             	mov    0x4(%eax),%eax
  802dd7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ddc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ddf:	8b 40 04             	mov    0x4(%eax),%eax
  802de2:	85 c0                	test   %eax,%eax
  802de4:	74 0f                	je     802df5 <alloc_block_NF+0x159>
  802de6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de9:	8b 40 04             	mov    0x4(%eax),%eax
  802dec:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802def:	8b 12                	mov    (%edx),%edx
  802df1:	89 10                	mov    %edx,(%eax)
  802df3:	eb 0a                	jmp    802dff <alloc_block_NF+0x163>
  802df5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df8:	8b 00                	mov    (%eax),%eax
  802dfa:	a3 48 51 80 00       	mov    %eax,0x805148
  802dff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e02:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e0b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e12:	a1 54 51 80 00       	mov    0x805154,%eax
  802e17:	48                   	dec    %eax
  802e18:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802e1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e20:	8b 40 08             	mov    0x8(%eax),%eax
  802e23:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   point->sva += size;
  802e28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2b:	8b 50 08             	mov    0x8(%eax),%edx
  802e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e31:	01 c2                	add    %eax,%edx
  802e33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e36:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802e39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e3f:	2b 45 08             	sub    0x8(%ebp),%eax
  802e42:	89 c2                	mov    %eax,%edx
  802e44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e47:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802e4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e4d:	e9 15 04 00 00       	jmp    803267 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802e52:	a1 40 51 80 00       	mov    0x805140,%eax
  802e57:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e5a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e5e:	74 07                	je     802e67 <alloc_block_NF+0x1cb>
  802e60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e63:	8b 00                	mov    (%eax),%eax
  802e65:	eb 05                	jmp    802e6c <alloc_block_NF+0x1d0>
  802e67:	b8 00 00 00 00       	mov    $0x0,%eax
  802e6c:	a3 40 51 80 00       	mov    %eax,0x805140
  802e71:	a1 40 51 80 00       	mov    0x805140,%eax
  802e76:	85 c0                	test   %eax,%eax
  802e78:	0f 85 3e fe ff ff    	jne    802cbc <alloc_block_NF+0x20>
  802e7e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e82:	0f 85 34 fe ff ff    	jne    802cbc <alloc_block_NF+0x20>
  802e88:	e9 d5 03 00 00       	jmp    803262 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802e8d:	a1 38 51 80 00       	mov    0x805138,%eax
  802e92:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e95:	e9 b1 01 00 00       	jmp    80304b <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802e9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9d:	8b 50 08             	mov    0x8(%eax),%edx
  802ea0:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802ea5:	39 c2                	cmp    %eax,%edx
  802ea7:	0f 82 96 01 00 00    	jb     803043 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802ead:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb0:	8b 40 0c             	mov    0xc(%eax),%eax
  802eb3:	3b 45 08             	cmp    0x8(%ebp),%eax
  802eb6:	0f 82 87 01 00 00    	jb     803043 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802ebc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebf:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec2:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ec5:	0f 85 95 00 00 00    	jne    802f60 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802ecb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ecf:	75 17                	jne    802ee8 <alloc_block_NF+0x24c>
  802ed1:	83 ec 04             	sub    $0x4,%esp
  802ed4:	68 8c 46 80 00       	push   $0x80468c
  802ed9:	68 fc 00 00 00       	push   $0xfc
  802ede:	68 e3 45 80 00       	push   $0x8045e3
  802ee3:	e8 a9 d8 ff ff       	call   800791 <_panic>
  802ee8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eeb:	8b 00                	mov    (%eax),%eax
  802eed:	85 c0                	test   %eax,%eax
  802eef:	74 10                	je     802f01 <alloc_block_NF+0x265>
  802ef1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef4:	8b 00                	mov    (%eax),%eax
  802ef6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ef9:	8b 52 04             	mov    0x4(%edx),%edx
  802efc:	89 50 04             	mov    %edx,0x4(%eax)
  802eff:	eb 0b                	jmp    802f0c <alloc_block_NF+0x270>
  802f01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f04:	8b 40 04             	mov    0x4(%eax),%eax
  802f07:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0f:	8b 40 04             	mov    0x4(%eax),%eax
  802f12:	85 c0                	test   %eax,%eax
  802f14:	74 0f                	je     802f25 <alloc_block_NF+0x289>
  802f16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f19:	8b 40 04             	mov    0x4(%eax),%eax
  802f1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f1f:	8b 12                	mov    (%edx),%edx
  802f21:	89 10                	mov    %edx,(%eax)
  802f23:	eb 0a                	jmp    802f2f <alloc_block_NF+0x293>
  802f25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f28:	8b 00                	mov    (%eax),%eax
  802f2a:	a3 38 51 80 00       	mov    %eax,0x805138
  802f2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f32:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f42:	a1 44 51 80 00       	mov    0x805144,%eax
  802f47:	48                   	dec    %eax
  802f48:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802f4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f50:	8b 40 08             	mov    0x8(%eax),%eax
  802f53:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  802f58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5b:	e9 07 03 00 00       	jmp    803267 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802f60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f63:	8b 40 0c             	mov    0xc(%eax),%eax
  802f66:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f69:	0f 86 d4 00 00 00    	jbe    803043 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802f6f:	a1 48 51 80 00       	mov    0x805148,%eax
  802f74:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802f77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7a:	8b 50 08             	mov    0x8(%eax),%edx
  802f7d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f80:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802f83:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f86:	8b 55 08             	mov    0x8(%ebp),%edx
  802f89:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802f8c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f90:	75 17                	jne    802fa9 <alloc_block_NF+0x30d>
  802f92:	83 ec 04             	sub    $0x4,%esp
  802f95:	68 8c 46 80 00       	push   $0x80468c
  802f9a:	68 04 01 00 00       	push   $0x104
  802f9f:	68 e3 45 80 00       	push   $0x8045e3
  802fa4:	e8 e8 d7 ff ff       	call   800791 <_panic>
  802fa9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fac:	8b 00                	mov    (%eax),%eax
  802fae:	85 c0                	test   %eax,%eax
  802fb0:	74 10                	je     802fc2 <alloc_block_NF+0x326>
  802fb2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb5:	8b 00                	mov    (%eax),%eax
  802fb7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fba:	8b 52 04             	mov    0x4(%edx),%edx
  802fbd:	89 50 04             	mov    %edx,0x4(%eax)
  802fc0:	eb 0b                	jmp    802fcd <alloc_block_NF+0x331>
  802fc2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc5:	8b 40 04             	mov    0x4(%eax),%eax
  802fc8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fcd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fd0:	8b 40 04             	mov    0x4(%eax),%eax
  802fd3:	85 c0                	test   %eax,%eax
  802fd5:	74 0f                	je     802fe6 <alloc_block_NF+0x34a>
  802fd7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fda:	8b 40 04             	mov    0x4(%eax),%eax
  802fdd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fe0:	8b 12                	mov    (%edx),%edx
  802fe2:	89 10                	mov    %edx,(%eax)
  802fe4:	eb 0a                	jmp    802ff0 <alloc_block_NF+0x354>
  802fe6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe9:	8b 00                	mov    (%eax),%eax
  802feb:	a3 48 51 80 00       	mov    %eax,0x805148
  802ff0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ff9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ffc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803003:	a1 54 51 80 00       	mov    0x805154,%eax
  803008:	48                   	dec    %eax
  803009:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  80300e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803011:	8b 40 08             	mov    0x8(%eax),%eax
  803014:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  803019:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301c:	8b 50 08             	mov    0x8(%eax),%edx
  80301f:	8b 45 08             	mov    0x8(%ebp),%eax
  803022:	01 c2                	add    %eax,%edx
  803024:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803027:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80302a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302d:	8b 40 0c             	mov    0xc(%eax),%eax
  803030:	2b 45 08             	sub    0x8(%ebp),%eax
  803033:	89 c2                	mov    %eax,%edx
  803035:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803038:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  80303b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80303e:	e9 24 02 00 00       	jmp    803267 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803043:	a1 40 51 80 00       	mov    0x805140,%eax
  803048:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80304b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80304f:	74 07                	je     803058 <alloc_block_NF+0x3bc>
  803051:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803054:	8b 00                	mov    (%eax),%eax
  803056:	eb 05                	jmp    80305d <alloc_block_NF+0x3c1>
  803058:	b8 00 00 00 00       	mov    $0x0,%eax
  80305d:	a3 40 51 80 00       	mov    %eax,0x805140
  803062:	a1 40 51 80 00       	mov    0x805140,%eax
  803067:	85 c0                	test   %eax,%eax
  803069:	0f 85 2b fe ff ff    	jne    802e9a <alloc_block_NF+0x1fe>
  80306f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803073:	0f 85 21 fe ff ff    	jne    802e9a <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803079:	a1 38 51 80 00       	mov    0x805138,%eax
  80307e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803081:	e9 ae 01 00 00       	jmp    803234 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  803086:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803089:	8b 50 08             	mov    0x8(%eax),%edx
  80308c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803091:	39 c2                	cmp    %eax,%edx
  803093:	0f 83 93 01 00 00    	jae    80322c <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  803099:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309c:	8b 40 0c             	mov    0xc(%eax),%eax
  80309f:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030a2:	0f 82 84 01 00 00    	jb     80322c <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  8030a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8030ae:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030b1:	0f 85 95 00 00 00    	jne    80314c <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8030b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030bb:	75 17                	jne    8030d4 <alloc_block_NF+0x438>
  8030bd:	83 ec 04             	sub    $0x4,%esp
  8030c0:	68 8c 46 80 00       	push   $0x80468c
  8030c5:	68 14 01 00 00       	push   $0x114
  8030ca:	68 e3 45 80 00       	push   $0x8045e3
  8030cf:	e8 bd d6 ff ff       	call   800791 <_panic>
  8030d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d7:	8b 00                	mov    (%eax),%eax
  8030d9:	85 c0                	test   %eax,%eax
  8030db:	74 10                	je     8030ed <alloc_block_NF+0x451>
  8030dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e0:	8b 00                	mov    (%eax),%eax
  8030e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030e5:	8b 52 04             	mov    0x4(%edx),%edx
  8030e8:	89 50 04             	mov    %edx,0x4(%eax)
  8030eb:	eb 0b                	jmp    8030f8 <alloc_block_NF+0x45c>
  8030ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f0:	8b 40 04             	mov    0x4(%eax),%eax
  8030f3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fb:	8b 40 04             	mov    0x4(%eax),%eax
  8030fe:	85 c0                	test   %eax,%eax
  803100:	74 0f                	je     803111 <alloc_block_NF+0x475>
  803102:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803105:	8b 40 04             	mov    0x4(%eax),%eax
  803108:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80310b:	8b 12                	mov    (%edx),%edx
  80310d:	89 10                	mov    %edx,(%eax)
  80310f:	eb 0a                	jmp    80311b <alloc_block_NF+0x47f>
  803111:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803114:	8b 00                	mov    (%eax),%eax
  803116:	a3 38 51 80 00       	mov    %eax,0x805138
  80311b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80311e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803124:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803127:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80312e:	a1 44 51 80 00       	mov    0x805144,%eax
  803133:	48                   	dec    %eax
  803134:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803139:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313c:	8b 40 08             	mov    0x8(%eax),%eax
  80313f:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  803144:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803147:	e9 1b 01 00 00       	jmp    803267 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80314c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314f:	8b 40 0c             	mov    0xc(%eax),%eax
  803152:	3b 45 08             	cmp    0x8(%ebp),%eax
  803155:	0f 86 d1 00 00 00    	jbe    80322c <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80315b:	a1 48 51 80 00       	mov    0x805148,%eax
  803160:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  803163:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803166:	8b 50 08             	mov    0x8(%eax),%edx
  803169:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80316c:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80316f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803172:	8b 55 08             	mov    0x8(%ebp),%edx
  803175:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803178:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80317c:	75 17                	jne    803195 <alloc_block_NF+0x4f9>
  80317e:	83 ec 04             	sub    $0x4,%esp
  803181:	68 8c 46 80 00       	push   $0x80468c
  803186:	68 1c 01 00 00       	push   $0x11c
  80318b:	68 e3 45 80 00       	push   $0x8045e3
  803190:	e8 fc d5 ff ff       	call   800791 <_panic>
  803195:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803198:	8b 00                	mov    (%eax),%eax
  80319a:	85 c0                	test   %eax,%eax
  80319c:	74 10                	je     8031ae <alloc_block_NF+0x512>
  80319e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031a1:	8b 00                	mov    (%eax),%eax
  8031a3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8031a6:	8b 52 04             	mov    0x4(%edx),%edx
  8031a9:	89 50 04             	mov    %edx,0x4(%eax)
  8031ac:	eb 0b                	jmp    8031b9 <alloc_block_NF+0x51d>
  8031ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031b1:	8b 40 04             	mov    0x4(%eax),%eax
  8031b4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031bc:	8b 40 04             	mov    0x4(%eax),%eax
  8031bf:	85 c0                	test   %eax,%eax
  8031c1:	74 0f                	je     8031d2 <alloc_block_NF+0x536>
  8031c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031c6:	8b 40 04             	mov    0x4(%eax),%eax
  8031c9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8031cc:	8b 12                	mov    (%edx),%edx
  8031ce:	89 10                	mov    %edx,(%eax)
  8031d0:	eb 0a                	jmp    8031dc <alloc_block_NF+0x540>
  8031d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031d5:	8b 00                	mov    (%eax),%eax
  8031d7:	a3 48 51 80 00       	mov    %eax,0x805148
  8031dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031ef:	a1 54 51 80 00       	mov    0x805154,%eax
  8031f4:	48                   	dec    %eax
  8031f5:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8031fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031fd:	8b 40 08             	mov    0x8(%eax),%eax
  803200:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  803205:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803208:	8b 50 08             	mov    0x8(%eax),%edx
  80320b:	8b 45 08             	mov    0x8(%ebp),%eax
  80320e:	01 c2                	add    %eax,%edx
  803210:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803213:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803216:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803219:	8b 40 0c             	mov    0xc(%eax),%eax
  80321c:	2b 45 08             	sub    0x8(%ebp),%eax
  80321f:	89 c2                	mov    %eax,%edx
  803221:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803224:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803227:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80322a:	eb 3b                	jmp    803267 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  80322c:	a1 40 51 80 00       	mov    0x805140,%eax
  803231:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803234:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803238:	74 07                	je     803241 <alloc_block_NF+0x5a5>
  80323a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80323d:	8b 00                	mov    (%eax),%eax
  80323f:	eb 05                	jmp    803246 <alloc_block_NF+0x5aa>
  803241:	b8 00 00 00 00       	mov    $0x0,%eax
  803246:	a3 40 51 80 00       	mov    %eax,0x805140
  80324b:	a1 40 51 80 00       	mov    0x805140,%eax
  803250:	85 c0                	test   %eax,%eax
  803252:	0f 85 2e fe ff ff    	jne    803086 <alloc_block_NF+0x3ea>
  803258:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80325c:	0f 85 24 fe ff ff    	jne    803086 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  803262:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803267:	c9                   	leave  
  803268:	c3                   	ret    

00803269 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803269:	55                   	push   %ebp
  80326a:	89 e5                	mov    %esp,%ebp
  80326c:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  80326f:	a1 38 51 80 00       	mov    0x805138,%eax
  803274:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  803277:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80327c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  80327f:	a1 38 51 80 00       	mov    0x805138,%eax
  803284:	85 c0                	test   %eax,%eax
  803286:	74 14                	je     80329c <insert_sorted_with_merge_freeList+0x33>
  803288:	8b 45 08             	mov    0x8(%ebp),%eax
  80328b:	8b 50 08             	mov    0x8(%eax),%edx
  80328e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803291:	8b 40 08             	mov    0x8(%eax),%eax
  803294:	39 c2                	cmp    %eax,%edx
  803296:	0f 87 9b 01 00 00    	ja     803437 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  80329c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032a0:	75 17                	jne    8032b9 <insert_sorted_with_merge_freeList+0x50>
  8032a2:	83 ec 04             	sub    $0x4,%esp
  8032a5:	68 c0 45 80 00       	push   $0x8045c0
  8032aa:	68 38 01 00 00       	push   $0x138
  8032af:	68 e3 45 80 00       	push   $0x8045e3
  8032b4:	e8 d8 d4 ff ff       	call   800791 <_panic>
  8032b9:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8032bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c2:	89 10                	mov    %edx,(%eax)
  8032c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c7:	8b 00                	mov    (%eax),%eax
  8032c9:	85 c0                	test   %eax,%eax
  8032cb:	74 0d                	je     8032da <insert_sorted_with_merge_freeList+0x71>
  8032cd:	a1 38 51 80 00       	mov    0x805138,%eax
  8032d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8032d5:	89 50 04             	mov    %edx,0x4(%eax)
  8032d8:	eb 08                	jmp    8032e2 <insert_sorted_with_merge_freeList+0x79>
  8032da:	8b 45 08             	mov    0x8(%ebp),%eax
  8032dd:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e5:	a3 38 51 80 00       	mov    %eax,0x805138
  8032ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032f4:	a1 44 51 80 00       	mov    0x805144,%eax
  8032f9:	40                   	inc    %eax
  8032fa:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8032ff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803303:	0f 84 a8 06 00 00    	je     8039b1 <insert_sorted_with_merge_freeList+0x748>
  803309:	8b 45 08             	mov    0x8(%ebp),%eax
  80330c:	8b 50 08             	mov    0x8(%eax),%edx
  80330f:	8b 45 08             	mov    0x8(%ebp),%eax
  803312:	8b 40 0c             	mov    0xc(%eax),%eax
  803315:	01 c2                	add    %eax,%edx
  803317:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80331a:	8b 40 08             	mov    0x8(%eax),%eax
  80331d:	39 c2                	cmp    %eax,%edx
  80331f:	0f 85 8c 06 00 00    	jne    8039b1 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  803325:	8b 45 08             	mov    0x8(%ebp),%eax
  803328:	8b 50 0c             	mov    0xc(%eax),%edx
  80332b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80332e:	8b 40 0c             	mov    0xc(%eax),%eax
  803331:	01 c2                	add    %eax,%edx
  803333:	8b 45 08             	mov    0x8(%ebp),%eax
  803336:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803339:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80333d:	75 17                	jne    803356 <insert_sorted_with_merge_freeList+0xed>
  80333f:	83 ec 04             	sub    $0x4,%esp
  803342:	68 8c 46 80 00       	push   $0x80468c
  803347:	68 3c 01 00 00       	push   $0x13c
  80334c:	68 e3 45 80 00       	push   $0x8045e3
  803351:	e8 3b d4 ff ff       	call   800791 <_panic>
  803356:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803359:	8b 00                	mov    (%eax),%eax
  80335b:	85 c0                	test   %eax,%eax
  80335d:	74 10                	je     80336f <insert_sorted_with_merge_freeList+0x106>
  80335f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803362:	8b 00                	mov    (%eax),%eax
  803364:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803367:	8b 52 04             	mov    0x4(%edx),%edx
  80336a:	89 50 04             	mov    %edx,0x4(%eax)
  80336d:	eb 0b                	jmp    80337a <insert_sorted_with_merge_freeList+0x111>
  80336f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803372:	8b 40 04             	mov    0x4(%eax),%eax
  803375:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80337a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80337d:	8b 40 04             	mov    0x4(%eax),%eax
  803380:	85 c0                	test   %eax,%eax
  803382:	74 0f                	je     803393 <insert_sorted_with_merge_freeList+0x12a>
  803384:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803387:	8b 40 04             	mov    0x4(%eax),%eax
  80338a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80338d:	8b 12                	mov    (%edx),%edx
  80338f:	89 10                	mov    %edx,(%eax)
  803391:	eb 0a                	jmp    80339d <insert_sorted_with_merge_freeList+0x134>
  803393:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803396:	8b 00                	mov    (%eax),%eax
  803398:	a3 38 51 80 00       	mov    %eax,0x805138
  80339d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033a9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033b0:	a1 44 51 80 00       	mov    0x805144,%eax
  8033b5:	48                   	dec    %eax
  8033b6:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  8033bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033be:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  8033c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033c8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  8033cf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033d3:	75 17                	jne    8033ec <insert_sorted_with_merge_freeList+0x183>
  8033d5:	83 ec 04             	sub    $0x4,%esp
  8033d8:	68 c0 45 80 00       	push   $0x8045c0
  8033dd:	68 3f 01 00 00       	push   $0x13f
  8033e2:	68 e3 45 80 00       	push   $0x8045e3
  8033e7:	e8 a5 d3 ff ff       	call   800791 <_panic>
  8033ec:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033f5:	89 10                	mov    %edx,(%eax)
  8033f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033fa:	8b 00                	mov    (%eax),%eax
  8033fc:	85 c0                	test   %eax,%eax
  8033fe:	74 0d                	je     80340d <insert_sorted_with_merge_freeList+0x1a4>
  803400:	a1 48 51 80 00       	mov    0x805148,%eax
  803405:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803408:	89 50 04             	mov    %edx,0x4(%eax)
  80340b:	eb 08                	jmp    803415 <insert_sorted_with_merge_freeList+0x1ac>
  80340d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803410:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803415:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803418:	a3 48 51 80 00       	mov    %eax,0x805148
  80341d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803420:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803427:	a1 54 51 80 00       	mov    0x805154,%eax
  80342c:	40                   	inc    %eax
  80342d:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803432:	e9 7a 05 00 00       	jmp    8039b1 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803437:	8b 45 08             	mov    0x8(%ebp),%eax
  80343a:	8b 50 08             	mov    0x8(%eax),%edx
  80343d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803440:	8b 40 08             	mov    0x8(%eax),%eax
  803443:	39 c2                	cmp    %eax,%edx
  803445:	0f 82 14 01 00 00    	jb     80355f <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  80344b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80344e:	8b 50 08             	mov    0x8(%eax),%edx
  803451:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803454:	8b 40 0c             	mov    0xc(%eax),%eax
  803457:	01 c2                	add    %eax,%edx
  803459:	8b 45 08             	mov    0x8(%ebp),%eax
  80345c:	8b 40 08             	mov    0x8(%eax),%eax
  80345f:	39 c2                	cmp    %eax,%edx
  803461:	0f 85 90 00 00 00    	jne    8034f7 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803467:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80346a:	8b 50 0c             	mov    0xc(%eax),%edx
  80346d:	8b 45 08             	mov    0x8(%ebp),%eax
  803470:	8b 40 0c             	mov    0xc(%eax),%eax
  803473:	01 c2                	add    %eax,%edx
  803475:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803478:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  80347b:	8b 45 08             	mov    0x8(%ebp),%eax
  80347e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803485:	8b 45 08             	mov    0x8(%ebp),%eax
  803488:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80348f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803493:	75 17                	jne    8034ac <insert_sorted_with_merge_freeList+0x243>
  803495:	83 ec 04             	sub    $0x4,%esp
  803498:	68 c0 45 80 00       	push   $0x8045c0
  80349d:	68 49 01 00 00       	push   $0x149
  8034a2:	68 e3 45 80 00       	push   $0x8045e3
  8034a7:	e8 e5 d2 ff ff       	call   800791 <_panic>
  8034ac:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b5:	89 10                	mov    %edx,(%eax)
  8034b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ba:	8b 00                	mov    (%eax),%eax
  8034bc:	85 c0                	test   %eax,%eax
  8034be:	74 0d                	je     8034cd <insert_sorted_with_merge_freeList+0x264>
  8034c0:	a1 48 51 80 00       	mov    0x805148,%eax
  8034c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8034c8:	89 50 04             	mov    %edx,0x4(%eax)
  8034cb:	eb 08                	jmp    8034d5 <insert_sorted_with_merge_freeList+0x26c>
  8034cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d8:	a3 48 51 80 00       	mov    %eax,0x805148
  8034dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034e7:	a1 54 51 80 00       	mov    0x805154,%eax
  8034ec:	40                   	inc    %eax
  8034ed:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8034f2:	e9 bb 04 00 00       	jmp    8039b2 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8034f7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034fb:	75 17                	jne    803514 <insert_sorted_with_merge_freeList+0x2ab>
  8034fd:	83 ec 04             	sub    $0x4,%esp
  803500:	68 34 46 80 00       	push   $0x804634
  803505:	68 4c 01 00 00       	push   $0x14c
  80350a:	68 e3 45 80 00       	push   $0x8045e3
  80350f:	e8 7d d2 ff ff       	call   800791 <_panic>
  803514:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80351a:	8b 45 08             	mov    0x8(%ebp),%eax
  80351d:	89 50 04             	mov    %edx,0x4(%eax)
  803520:	8b 45 08             	mov    0x8(%ebp),%eax
  803523:	8b 40 04             	mov    0x4(%eax),%eax
  803526:	85 c0                	test   %eax,%eax
  803528:	74 0c                	je     803536 <insert_sorted_with_merge_freeList+0x2cd>
  80352a:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80352f:	8b 55 08             	mov    0x8(%ebp),%edx
  803532:	89 10                	mov    %edx,(%eax)
  803534:	eb 08                	jmp    80353e <insert_sorted_with_merge_freeList+0x2d5>
  803536:	8b 45 08             	mov    0x8(%ebp),%eax
  803539:	a3 38 51 80 00       	mov    %eax,0x805138
  80353e:	8b 45 08             	mov    0x8(%ebp),%eax
  803541:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803546:	8b 45 08             	mov    0x8(%ebp),%eax
  803549:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80354f:	a1 44 51 80 00       	mov    0x805144,%eax
  803554:	40                   	inc    %eax
  803555:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80355a:	e9 53 04 00 00       	jmp    8039b2 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80355f:	a1 38 51 80 00       	mov    0x805138,%eax
  803564:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803567:	e9 15 04 00 00       	jmp    803981 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  80356c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80356f:	8b 00                	mov    (%eax),%eax
  803571:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803574:	8b 45 08             	mov    0x8(%ebp),%eax
  803577:	8b 50 08             	mov    0x8(%eax),%edx
  80357a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80357d:	8b 40 08             	mov    0x8(%eax),%eax
  803580:	39 c2                	cmp    %eax,%edx
  803582:	0f 86 f1 03 00 00    	jbe    803979 <insert_sorted_with_merge_freeList+0x710>
  803588:	8b 45 08             	mov    0x8(%ebp),%eax
  80358b:	8b 50 08             	mov    0x8(%eax),%edx
  80358e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803591:	8b 40 08             	mov    0x8(%eax),%eax
  803594:	39 c2                	cmp    %eax,%edx
  803596:	0f 83 dd 03 00 00    	jae    803979 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  80359c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80359f:	8b 50 08             	mov    0x8(%eax),%edx
  8035a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8035a8:	01 c2                	add    %eax,%edx
  8035aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ad:	8b 40 08             	mov    0x8(%eax),%eax
  8035b0:	39 c2                	cmp    %eax,%edx
  8035b2:	0f 85 b9 01 00 00    	jne    803771 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8035b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8035bb:	8b 50 08             	mov    0x8(%eax),%edx
  8035be:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8035c4:	01 c2                	add    %eax,%edx
  8035c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035c9:	8b 40 08             	mov    0x8(%eax),%eax
  8035cc:	39 c2                	cmp    %eax,%edx
  8035ce:	0f 85 0d 01 00 00    	jne    8036e1 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8035d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d7:	8b 50 0c             	mov    0xc(%eax),%edx
  8035da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8035e0:	01 c2                	add    %eax,%edx
  8035e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e5:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8035e8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8035ec:	75 17                	jne    803605 <insert_sorted_with_merge_freeList+0x39c>
  8035ee:	83 ec 04             	sub    $0x4,%esp
  8035f1:	68 8c 46 80 00       	push   $0x80468c
  8035f6:	68 5c 01 00 00       	push   $0x15c
  8035fb:	68 e3 45 80 00       	push   $0x8045e3
  803600:	e8 8c d1 ff ff       	call   800791 <_panic>
  803605:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803608:	8b 00                	mov    (%eax),%eax
  80360a:	85 c0                	test   %eax,%eax
  80360c:	74 10                	je     80361e <insert_sorted_with_merge_freeList+0x3b5>
  80360e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803611:	8b 00                	mov    (%eax),%eax
  803613:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803616:	8b 52 04             	mov    0x4(%edx),%edx
  803619:	89 50 04             	mov    %edx,0x4(%eax)
  80361c:	eb 0b                	jmp    803629 <insert_sorted_with_merge_freeList+0x3c0>
  80361e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803621:	8b 40 04             	mov    0x4(%eax),%eax
  803624:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803629:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80362c:	8b 40 04             	mov    0x4(%eax),%eax
  80362f:	85 c0                	test   %eax,%eax
  803631:	74 0f                	je     803642 <insert_sorted_with_merge_freeList+0x3d9>
  803633:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803636:	8b 40 04             	mov    0x4(%eax),%eax
  803639:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80363c:	8b 12                	mov    (%edx),%edx
  80363e:	89 10                	mov    %edx,(%eax)
  803640:	eb 0a                	jmp    80364c <insert_sorted_with_merge_freeList+0x3e3>
  803642:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803645:	8b 00                	mov    (%eax),%eax
  803647:	a3 38 51 80 00       	mov    %eax,0x805138
  80364c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80364f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803655:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803658:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80365f:	a1 44 51 80 00       	mov    0x805144,%eax
  803664:	48                   	dec    %eax
  803665:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  80366a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80366d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803674:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803677:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80367e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803682:	75 17                	jne    80369b <insert_sorted_with_merge_freeList+0x432>
  803684:	83 ec 04             	sub    $0x4,%esp
  803687:	68 c0 45 80 00       	push   $0x8045c0
  80368c:	68 5f 01 00 00       	push   $0x15f
  803691:	68 e3 45 80 00       	push   $0x8045e3
  803696:	e8 f6 d0 ff ff       	call   800791 <_panic>
  80369b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8036a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036a4:	89 10                	mov    %edx,(%eax)
  8036a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036a9:	8b 00                	mov    (%eax),%eax
  8036ab:	85 c0                	test   %eax,%eax
  8036ad:	74 0d                	je     8036bc <insert_sorted_with_merge_freeList+0x453>
  8036af:	a1 48 51 80 00       	mov    0x805148,%eax
  8036b4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036b7:	89 50 04             	mov    %edx,0x4(%eax)
  8036ba:	eb 08                	jmp    8036c4 <insert_sorted_with_merge_freeList+0x45b>
  8036bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036bf:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036c7:	a3 48 51 80 00       	mov    %eax,0x805148
  8036cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036d6:	a1 54 51 80 00       	mov    0x805154,%eax
  8036db:	40                   	inc    %eax
  8036dc:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8036e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e4:	8b 50 0c             	mov    0xc(%eax),%edx
  8036e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8036ed:	01 c2                	add    %eax,%edx
  8036ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f2:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8036f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8036ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803702:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803709:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80370d:	75 17                	jne    803726 <insert_sorted_with_merge_freeList+0x4bd>
  80370f:	83 ec 04             	sub    $0x4,%esp
  803712:	68 c0 45 80 00       	push   $0x8045c0
  803717:	68 64 01 00 00       	push   $0x164
  80371c:	68 e3 45 80 00       	push   $0x8045e3
  803721:	e8 6b d0 ff ff       	call   800791 <_panic>
  803726:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80372c:	8b 45 08             	mov    0x8(%ebp),%eax
  80372f:	89 10                	mov    %edx,(%eax)
  803731:	8b 45 08             	mov    0x8(%ebp),%eax
  803734:	8b 00                	mov    (%eax),%eax
  803736:	85 c0                	test   %eax,%eax
  803738:	74 0d                	je     803747 <insert_sorted_with_merge_freeList+0x4de>
  80373a:	a1 48 51 80 00       	mov    0x805148,%eax
  80373f:	8b 55 08             	mov    0x8(%ebp),%edx
  803742:	89 50 04             	mov    %edx,0x4(%eax)
  803745:	eb 08                	jmp    80374f <insert_sorted_with_merge_freeList+0x4e6>
  803747:	8b 45 08             	mov    0x8(%ebp),%eax
  80374a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80374f:	8b 45 08             	mov    0x8(%ebp),%eax
  803752:	a3 48 51 80 00       	mov    %eax,0x805148
  803757:	8b 45 08             	mov    0x8(%ebp),%eax
  80375a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803761:	a1 54 51 80 00       	mov    0x805154,%eax
  803766:	40                   	inc    %eax
  803767:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80376c:	e9 41 02 00 00       	jmp    8039b2 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803771:	8b 45 08             	mov    0x8(%ebp),%eax
  803774:	8b 50 08             	mov    0x8(%eax),%edx
  803777:	8b 45 08             	mov    0x8(%ebp),%eax
  80377a:	8b 40 0c             	mov    0xc(%eax),%eax
  80377d:	01 c2                	add    %eax,%edx
  80377f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803782:	8b 40 08             	mov    0x8(%eax),%eax
  803785:	39 c2                	cmp    %eax,%edx
  803787:	0f 85 7c 01 00 00    	jne    803909 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80378d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803791:	74 06                	je     803799 <insert_sorted_with_merge_freeList+0x530>
  803793:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803797:	75 17                	jne    8037b0 <insert_sorted_with_merge_freeList+0x547>
  803799:	83 ec 04             	sub    $0x4,%esp
  80379c:	68 fc 45 80 00       	push   $0x8045fc
  8037a1:	68 69 01 00 00       	push   $0x169
  8037a6:	68 e3 45 80 00       	push   $0x8045e3
  8037ab:	e8 e1 cf ff ff       	call   800791 <_panic>
  8037b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037b3:	8b 50 04             	mov    0x4(%eax),%edx
  8037b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b9:	89 50 04             	mov    %edx,0x4(%eax)
  8037bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8037bf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037c2:	89 10                	mov    %edx,(%eax)
  8037c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037c7:	8b 40 04             	mov    0x4(%eax),%eax
  8037ca:	85 c0                	test   %eax,%eax
  8037cc:	74 0d                	je     8037db <insert_sorted_with_merge_freeList+0x572>
  8037ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037d1:	8b 40 04             	mov    0x4(%eax),%eax
  8037d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8037d7:	89 10                	mov    %edx,(%eax)
  8037d9:	eb 08                	jmp    8037e3 <insert_sorted_with_merge_freeList+0x57a>
  8037db:	8b 45 08             	mov    0x8(%ebp),%eax
  8037de:	a3 38 51 80 00       	mov    %eax,0x805138
  8037e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8037e9:	89 50 04             	mov    %edx,0x4(%eax)
  8037ec:	a1 44 51 80 00       	mov    0x805144,%eax
  8037f1:	40                   	inc    %eax
  8037f2:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8037f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8037fa:	8b 50 0c             	mov    0xc(%eax),%edx
  8037fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803800:	8b 40 0c             	mov    0xc(%eax),%eax
  803803:	01 c2                	add    %eax,%edx
  803805:	8b 45 08             	mov    0x8(%ebp),%eax
  803808:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80380b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80380f:	75 17                	jne    803828 <insert_sorted_with_merge_freeList+0x5bf>
  803811:	83 ec 04             	sub    $0x4,%esp
  803814:	68 8c 46 80 00       	push   $0x80468c
  803819:	68 6b 01 00 00       	push   $0x16b
  80381e:	68 e3 45 80 00       	push   $0x8045e3
  803823:	e8 69 cf ff ff       	call   800791 <_panic>
  803828:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80382b:	8b 00                	mov    (%eax),%eax
  80382d:	85 c0                	test   %eax,%eax
  80382f:	74 10                	je     803841 <insert_sorted_with_merge_freeList+0x5d8>
  803831:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803834:	8b 00                	mov    (%eax),%eax
  803836:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803839:	8b 52 04             	mov    0x4(%edx),%edx
  80383c:	89 50 04             	mov    %edx,0x4(%eax)
  80383f:	eb 0b                	jmp    80384c <insert_sorted_with_merge_freeList+0x5e3>
  803841:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803844:	8b 40 04             	mov    0x4(%eax),%eax
  803847:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80384c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80384f:	8b 40 04             	mov    0x4(%eax),%eax
  803852:	85 c0                	test   %eax,%eax
  803854:	74 0f                	je     803865 <insert_sorted_with_merge_freeList+0x5fc>
  803856:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803859:	8b 40 04             	mov    0x4(%eax),%eax
  80385c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80385f:	8b 12                	mov    (%edx),%edx
  803861:	89 10                	mov    %edx,(%eax)
  803863:	eb 0a                	jmp    80386f <insert_sorted_with_merge_freeList+0x606>
  803865:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803868:	8b 00                	mov    (%eax),%eax
  80386a:	a3 38 51 80 00       	mov    %eax,0x805138
  80386f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803872:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803878:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80387b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803882:	a1 44 51 80 00       	mov    0x805144,%eax
  803887:	48                   	dec    %eax
  803888:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  80388d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803890:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803897:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80389a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8038a1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8038a5:	75 17                	jne    8038be <insert_sorted_with_merge_freeList+0x655>
  8038a7:	83 ec 04             	sub    $0x4,%esp
  8038aa:	68 c0 45 80 00       	push   $0x8045c0
  8038af:	68 6e 01 00 00       	push   $0x16e
  8038b4:	68 e3 45 80 00       	push   $0x8045e3
  8038b9:	e8 d3 ce ff ff       	call   800791 <_panic>
  8038be:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8038c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038c7:	89 10                	mov    %edx,(%eax)
  8038c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038cc:	8b 00                	mov    (%eax),%eax
  8038ce:	85 c0                	test   %eax,%eax
  8038d0:	74 0d                	je     8038df <insert_sorted_with_merge_freeList+0x676>
  8038d2:	a1 48 51 80 00       	mov    0x805148,%eax
  8038d7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038da:	89 50 04             	mov    %edx,0x4(%eax)
  8038dd:	eb 08                	jmp    8038e7 <insert_sorted_with_merge_freeList+0x67e>
  8038df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038e2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8038e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038ea:	a3 48 51 80 00       	mov    %eax,0x805148
  8038ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038f2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038f9:	a1 54 51 80 00       	mov    0x805154,%eax
  8038fe:	40                   	inc    %eax
  8038ff:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803904:	e9 a9 00 00 00       	jmp    8039b2 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803909:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80390d:	74 06                	je     803915 <insert_sorted_with_merge_freeList+0x6ac>
  80390f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803913:	75 17                	jne    80392c <insert_sorted_with_merge_freeList+0x6c3>
  803915:	83 ec 04             	sub    $0x4,%esp
  803918:	68 58 46 80 00       	push   $0x804658
  80391d:	68 73 01 00 00       	push   $0x173
  803922:	68 e3 45 80 00       	push   $0x8045e3
  803927:	e8 65 ce ff ff       	call   800791 <_panic>
  80392c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80392f:	8b 10                	mov    (%eax),%edx
  803931:	8b 45 08             	mov    0x8(%ebp),%eax
  803934:	89 10                	mov    %edx,(%eax)
  803936:	8b 45 08             	mov    0x8(%ebp),%eax
  803939:	8b 00                	mov    (%eax),%eax
  80393b:	85 c0                	test   %eax,%eax
  80393d:	74 0b                	je     80394a <insert_sorted_with_merge_freeList+0x6e1>
  80393f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803942:	8b 00                	mov    (%eax),%eax
  803944:	8b 55 08             	mov    0x8(%ebp),%edx
  803947:	89 50 04             	mov    %edx,0x4(%eax)
  80394a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80394d:	8b 55 08             	mov    0x8(%ebp),%edx
  803950:	89 10                	mov    %edx,(%eax)
  803952:	8b 45 08             	mov    0x8(%ebp),%eax
  803955:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803958:	89 50 04             	mov    %edx,0x4(%eax)
  80395b:	8b 45 08             	mov    0x8(%ebp),%eax
  80395e:	8b 00                	mov    (%eax),%eax
  803960:	85 c0                	test   %eax,%eax
  803962:	75 08                	jne    80396c <insert_sorted_with_merge_freeList+0x703>
  803964:	8b 45 08             	mov    0x8(%ebp),%eax
  803967:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80396c:	a1 44 51 80 00       	mov    0x805144,%eax
  803971:	40                   	inc    %eax
  803972:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803977:	eb 39                	jmp    8039b2 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803979:	a1 40 51 80 00       	mov    0x805140,%eax
  80397e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803981:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803985:	74 07                	je     80398e <insert_sorted_with_merge_freeList+0x725>
  803987:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80398a:	8b 00                	mov    (%eax),%eax
  80398c:	eb 05                	jmp    803993 <insert_sorted_with_merge_freeList+0x72a>
  80398e:	b8 00 00 00 00       	mov    $0x0,%eax
  803993:	a3 40 51 80 00       	mov    %eax,0x805140
  803998:	a1 40 51 80 00       	mov    0x805140,%eax
  80399d:	85 c0                	test   %eax,%eax
  80399f:	0f 85 c7 fb ff ff    	jne    80356c <insert_sorted_with_merge_freeList+0x303>
  8039a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039a9:	0f 85 bd fb ff ff    	jne    80356c <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8039af:	eb 01                	jmp    8039b2 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8039b1:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8039b2:	90                   	nop
  8039b3:	c9                   	leave  
  8039b4:	c3                   	ret    
  8039b5:	66 90                	xchg   %ax,%ax
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
