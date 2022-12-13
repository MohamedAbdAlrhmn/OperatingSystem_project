
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
  800041:	e8 4f 1f 00 00       	call   801f95 <sys_disable_interrupt>
		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 e0 3c 80 00       	push   $0x803ce0
  80004e:	e8 f2 09 00 00       	call   800a45 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 e2 3c 80 00       	push   $0x803ce2
  80005e:	e8 e2 09 00 00       	call   800a45 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   QUICK SORT   !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 fb 3c 80 00       	push   $0x803cfb
  80006e:	e8 d2 09 00 00       	call   800a45 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 e2 3c 80 00       	push   $0x803ce2
  80007e:	e8 c2 09 00 00       	call   800a45 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 e0 3c 80 00       	push   $0x803ce0
  80008e:	e8 b2 09 00 00       	call   800a45 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 14 3d 80 00       	push   $0x803d14
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
  8000de:	68 34 3d 80 00       	push   $0x803d34
  8000e3:	e8 5d 09 00 00       	call   800a45 <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 56 3d 80 00       	push   $0x803d56
  8000f3:	e8 4d 09 00 00       	call   800a45 <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 64 3d 80 00       	push   $0x803d64
  800103:	e8 3d 09 00 00       	call   800a45 <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 73 3d 80 00       	push   $0x803d73
  800113:	e8 2d 09 00 00       	call   800a45 <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 83 3d 80 00       	push   $0x803d83
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
  800162:	e8 48 1e 00 00       	call   801faf <sys_enable_interrupt>

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
  8001d5:	e8 bb 1d 00 00       	call   801f95 <sys_disable_interrupt>
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	68 8c 3d 80 00       	push   $0x803d8c
  8001e2:	e8 5e 08 00 00       	call   800a45 <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
		//		PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001ea:	e8 c0 1d 00 00       	call   801faf <sys_enable_interrupt>

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
  80020c:	68 c0 3d 80 00       	push   $0x803dc0
  800211:	6a 48                	push   $0x48
  800213:	68 e2 3d 80 00       	push   $0x803de2
  800218:	e8 74 05 00 00       	call   800791 <_panic>
		else
		{
			sys_disable_interrupt();
  80021d:	e8 73 1d 00 00       	call   801f95 <sys_disable_interrupt>
			cprintf("\n===============================================\n") ;
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	68 f8 3d 80 00       	push   $0x803df8
  80022a:	e8 16 08 00 00       	call   800a45 <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 2c 3e 80 00       	push   $0x803e2c
  80023a:	e8 06 08 00 00       	call   800a45 <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	68 60 3e 80 00       	push   $0x803e60
  80024a:	e8 f6 07 00 00       	call   800a45 <cprintf>
  80024f:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800252:	e8 58 1d 00 00       	call   801faf <sys_enable_interrupt>
		}

		sys_disable_interrupt();
  800257:	e8 39 1d 00 00       	call   801f95 <sys_disable_interrupt>
			Chose = 0 ;
  80025c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800260:	eb 42                	jmp    8002a4 <_main+0x26c>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800262:	83 ec 0c             	sub    $0xc,%esp
  800265:	68 92 3e 80 00       	push   $0x803e92
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
  8002b0:	e8 fa 1c 00 00       	call   801faf <sys_enable_interrupt>

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
  800555:	68 e0 3c 80 00       	push   $0x803ce0
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
  800577:	68 b0 3e 80 00       	push   $0x803eb0
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
  8005a5:	68 b5 3e 80 00       	push   $0x803eb5
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
  8005c9:	e8 fb 19 00 00       	call   801fc9 <sys_cputc>
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
  8005da:	e8 b6 19 00 00       	call   801f95 <sys_disable_interrupt>
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
  8005ed:	e8 d7 19 00 00       	call   801fc9 <sys_cputc>
  8005f2:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8005f5:	e8 b5 19 00 00       	call   801faf <sys_enable_interrupt>
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
  80060c:	e8 ff 17 00 00       	call   801e10 <sys_cgetc>
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
  800625:	e8 6b 19 00 00       	call   801f95 <sys_disable_interrupt>
	int c=0;
  80062a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800631:	eb 08                	jmp    80063b <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800633:	e8 d8 17 00 00       	call   801e10 <sys_cgetc>
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
  800641:	e8 69 19 00 00       	call   801faf <sys_enable_interrupt>
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
  80065b:	e8 28 1b 00 00       	call   802188 <sys_getenvindex>
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
  8006c6:	e8 ca 18 00 00       	call   801f95 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8006cb:	83 ec 0c             	sub    $0xc,%esp
  8006ce:	68 d4 3e 80 00       	push   $0x803ed4
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
  8006f6:	68 fc 3e 80 00       	push   $0x803efc
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
  800727:	68 24 3f 80 00       	push   $0x803f24
  80072c:	e8 14 03 00 00       	call   800a45 <cprintf>
  800731:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800734:	a1 24 50 80 00       	mov    0x805024,%eax
  800739:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80073f:	83 ec 08             	sub    $0x8,%esp
  800742:	50                   	push   %eax
  800743:	68 7c 3f 80 00       	push   $0x803f7c
  800748:	e8 f8 02 00 00       	call   800a45 <cprintf>
  80074d:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800750:	83 ec 0c             	sub    $0xc,%esp
  800753:	68 d4 3e 80 00       	push   $0x803ed4
  800758:	e8 e8 02 00 00       	call   800a45 <cprintf>
  80075d:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800760:	e8 4a 18 00 00       	call   801faf <sys_enable_interrupt>

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
  800778:	e8 d7 19 00 00       	call   802154 <sys_destroy_env>
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
  800789:	e8 2c 1a 00 00       	call   8021ba <sys_exit_env>
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
  8007b2:	68 90 3f 80 00       	push   $0x803f90
  8007b7:	e8 89 02 00 00       	call   800a45 <cprintf>
  8007bc:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007bf:	a1 00 50 80 00       	mov    0x805000,%eax
  8007c4:	ff 75 0c             	pushl  0xc(%ebp)
  8007c7:	ff 75 08             	pushl  0x8(%ebp)
  8007ca:	50                   	push   %eax
  8007cb:	68 95 3f 80 00       	push   $0x803f95
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
  8007ef:	68 b1 3f 80 00       	push   $0x803fb1
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
  80081b:	68 b4 3f 80 00       	push   $0x803fb4
  800820:	6a 26                	push   $0x26
  800822:	68 00 40 80 00       	push   $0x804000
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
  8008ed:	68 0c 40 80 00       	push   $0x80400c
  8008f2:	6a 3a                	push   $0x3a
  8008f4:	68 00 40 80 00       	push   $0x804000
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
  80095d:	68 60 40 80 00       	push   $0x804060
  800962:	6a 44                	push   $0x44
  800964:	68 00 40 80 00       	push   $0x804000
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
  8009b7:	e8 2b 14 00 00       	call   801de7 <sys_cputs>
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
  800a2e:	e8 b4 13 00 00       	call   801de7 <sys_cputs>
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
  800a78:	e8 18 15 00 00       	call   801f95 <sys_disable_interrupt>
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
  800a98:	e8 12 15 00 00       	call   801faf <sys_enable_interrupt>
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
  800ae2:	e8 85 2f 00 00       	call   803a6c <__udivdi3>
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
  800b32:	e8 45 30 00 00       	call   803b7c <__umoddi3>
  800b37:	83 c4 10             	add    $0x10,%esp
  800b3a:	05 d4 42 80 00       	add    $0x8042d4,%eax
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
  800c8d:	8b 04 85 f8 42 80 00 	mov    0x8042f8(,%eax,4),%eax
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
  800d6e:	8b 34 9d 40 41 80 00 	mov    0x804140(,%ebx,4),%esi
  800d75:	85 f6                	test   %esi,%esi
  800d77:	75 19                	jne    800d92 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d79:	53                   	push   %ebx
  800d7a:	68 e5 42 80 00       	push   $0x8042e5
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
  800d93:	68 ee 42 80 00       	push   $0x8042ee
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
  800dc0:	be f1 42 80 00       	mov    $0x8042f1,%esi
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
  8010d9:	68 50 44 80 00       	push   $0x804450
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
  80111b:	68 53 44 80 00       	push   $0x804453
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
  8011cb:	e8 c5 0d 00 00       	call   801f95 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  8011d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011d4:	74 13                	je     8011e9 <atomic_readline+0x24>
		cprintf("%s", prompt);
  8011d6:	83 ec 08             	sub    $0x8,%esp
  8011d9:	ff 75 08             	pushl  0x8(%ebp)
  8011dc:	68 50 44 80 00       	push   $0x804450
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
  80121a:	68 53 44 80 00       	push   $0x804453
  80121f:	e8 21 f8 ff ff       	call   800a45 <cprintf>
  801224:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801227:	e8 83 0d 00 00       	call   801faf <sys_enable_interrupt>
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
  8012bf:	e8 eb 0c 00 00       	call   801faf <sys_enable_interrupt>
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
  8019ec:	68 64 44 80 00       	push   $0x804464
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
  801abc:	e8 6a 04 00 00       	call   801f2b <sys_allocate_chunk>
  801ac1:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801ac4:	a1 20 51 80 00       	mov    0x805120,%eax
  801ac9:	83 ec 0c             	sub    $0xc,%esp
  801acc:	50                   	push   %eax
  801acd:	e8 df 0a 00 00       	call   8025b1 <initialize_MemBlocksList>
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
  801afa:	68 89 44 80 00       	push   $0x804489
  801aff:	6a 33                	push   $0x33
  801b01:	68 a7 44 80 00       	push   $0x8044a7
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
  801b79:	68 b4 44 80 00       	push   $0x8044b4
  801b7e:	6a 34                	push   $0x34
  801b80:	68 a7 44 80 00       	push   $0x8044a7
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
  801c11:	e8 e3 06 00 00       	call   8022f9 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801c16:	85 c0                	test   %eax,%eax
  801c18:	74 11                	je     801c2b <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801c1a:	83 ec 0c             	sub    $0xc,%esp
  801c1d:	ff 75 e8             	pushl  -0x18(%ebp)
  801c20:	e8 4e 0d 00 00       	call   802973 <alloc_block_FF>
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
  801c37:	e8 aa 0a 00 00       	call   8026e6 <insert_sorted_allocList>
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
  801c57:	68 d8 44 80 00       	push   $0x8044d8
  801c5c:	6a 6f                	push   $0x6f
  801c5e:	68 a7 44 80 00       	push   $0x8044a7
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
  801c7d:	75 07                	jne    801c86 <smalloc+0x1e>
  801c7f:	b8 00 00 00 00       	mov    $0x0,%eax
  801c84:	eb 7c                	jmp    801d02 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801c86:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801c8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c93:	01 d0                	add    %edx,%eax
  801c95:	48                   	dec    %eax
  801c96:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801c99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c9c:	ba 00 00 00 00       	mov    $0x0,%edx
  801ca1:	f7 75 f0             	divl   -0x10(%ebp)
  801ca4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ca7:	29 d0                	sub    %edx,%eax
  801ca9:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801cac:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801cb3:	e8 41 06 00 00       	call   8022f9 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801cb8:	85 c0                	test   %eax,%eax
  801cba:	74 11                	je     801ccd <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  801cbc:	83 ec 0c             	sub    $0xc,%esp
  801cbf:	ff 75 e8             	pushl  -0x18(%ebp)
  801cc2:	e8 ac 0c 00 00       	call   802973 <alloc_block_FF>
  801cc7:	83 c4 10             	add    $0x10,%esp
  801cca:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801ccd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801cd1:	74 2a                	je     801cfd <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801cd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cd6:	8b 40 08             	mov    0x8(%eax),%eax
  801cd9:	89 c2                	mov    %eax,%edx
  801cdb:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801cdf:	52                   	push   %edx
  801ce0:	50                   	push   %eax
  801ce1:	ff 75 0c             	pushl  0xc(%ebp)
  801ce4:	ff 75 08             	pushl  0x8(%ebp)
  801ce7:	e8 92 03 00 00       	call   80207e <sys_createSharedObject>
  801cec:	83 c4 10             	add    $0x10,%esp
  801cef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  801cf2:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  801cf6:	74 05                	je     801cfd <smalloc+0x95>
			return (void*)virtual_address;
  801cf8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801cfb:	eb 05                	jmp    801d02 <smalloc+0x9a>
	}
	return NULL;
  801cfd:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801d02:	c9                   	leave  
  801d03:	c3                   	ret    

00801d04 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801d04:	55                   	push   %ebp
  801d05:	89 e5                	mov    %esp,%ebp
  801d07:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d0a:	e8 c6 fc ff ff       	call   8019d5 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801d0f:	83 ec 04             	sub    $0x4,%esp
  801d12:	68 fc 44 80 00       	push   $0x8044fc
  801d17:	68 b0 00 00 00       	push   $0xb0
  801d1c:	68 a7 44 80 00       	push   $0x8044a7
  801d21:	e8 6b ea ff ff       	call   800791 <_panic>

00801d26 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801d26:	55                   	push   %ebp
  801d27:	89 e5                	mov    %esp,%ebp
  801d29:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d2c:	e8 a4 fc ff ff       	call   8019d5 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801d31:	83 ec 04             	sub    $0x4,%esp
  801d34:	68 20 45 80 00       	push   $0x804520
  801d39:	68 f4 00 00 00       	push   $0xf4
  801d3e:	68 a7 44 80 00       	push   $0x8044a7
  801d43:	e8 49 ea ff ff       	call   800791 <_panic>

00801d48 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801d48:	55                   	push   %ebp
  801d49:	89 e5                	mov    %esp,%ebp
  801d4b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801d4e:	83 ec 04             	sub    $0x4,%esp
  801d51:	68 48 45 80 00       	push   $0x804548
  801d56:	68 08 01 00 00       	push   $0x108
  801d5b:	68 a7 44 80 00       	push   $0x8044a7
  801d60:	e8 2c ea ff ff       	call   800791 <_panic>

00801d65 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801d65:	55                   	push   %ebp
  801d66:	89 e5                	mov    %esp,%ebp
  801d68:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d6b:	83 ec 04             	sub    $0x4,%esp
  801d6e:	68 6c 45 80 00       	push   $0x80456c
  801d73:	68 13 01 00 00       	push   $0x113
  801d78:	68 a7 44 80 00       	push   $0x8044a7
  801d7d:	e8 0f ea ff ff       	call   800791 <_panic>

00801d82 <shrink>:

}
void shrink(uint32 newSize)
{
  801d82:	55                   	push   %ebp
  801d83:	89 e5                	mov    %esp,%ebp
  801d85:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d88:	83 ec 04             	sub    $0x4,%esp
  801d8b:	68 6c 45 80 00       	push   $0x80456c
  801d90:	68 18 01 00 00       	push   $0x118
  801d95:	68 a7 44 80 00       	push   $0x8044a7
  801d9a:	e8 f2 e9 ff ff       	call   800791 <_panic>

00801d9f <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801d9f:	55                   	push   %ebp
  801da0:	89 e5                	mov    %esp,%ebp
  801da2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801da5:	83 ec 04             	sub    $0x4,%esp
  801da8:	68 6c 45 80 00       	push   $0x80456c
  801dad:	68 1d 01 00 00       	push   $0x11d
  801db2:	68 a7 44 80 00       	push   $0x8044a7
  801db7:	e8 d5 e9 ff ff       	call   800791 <_panic>

00801dbc <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801dbc:	55                   	push   %ebp
  801dbd:	89 e5                	mov    %esp,%ebp
  801dbf:	57                   	push   %edi
  801dc0:	56                   	push   %esi
  801dc1:	53                   	push   %ebx
  801dc2:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dcb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dce:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801dd1:	8b 7d 18             	mov    0x18(%ebp),%edi
  801dd4:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801dd7:	cd 30                	int    $0x30
  801dd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801ddc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ddf:	83 c4 10             	add    $0x10,%esp
  801de2:	5b                   	pop    %ebx
  801de3:	5e                   	pop    %esi
  801de4:	5f                   	pop    %edi
  801de5:	5d                   	pop    %ebp
  801de6:	c3                   	ret    

00801de7 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801de7:	55                   	push   %ebp
  801de8:	89 e5                	mov    %esp,%ebp
  801dea:	83 ec 04             	sub    $0x4,%esp
  801ded:	8b 45 10             	mov    0x10(%ebp),%eax
  801df0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801df3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801df7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	52                   	push   %edx
  801dff:	ff 75 0c             	pushl  0xc(%ebp)
  801e02:	50                   	push   %eax
  801e03:	6a 00                	push   $0x0
  801e05:	e8 b2 ff ff ff       	call   801dbc <syscall>
  801e0a:	83 c4 18             	add    $0x18,%esp
}
  801e0d:	90                   	nop
  801e0e:	c9                   	leave  
  801e0f:	c3                   	ret    

00801e10 <sys_cgetc>:

int
sys_cgetc(void)
{
  801e10:	55                   	push   %ebp
  801e11:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	6a 00                	push   $0x0
  801e19:	6a 00                	push   $0x0
  801e1b:	6a 00                	push   $0x0
  801e1d:	6a 01                	push   $0x1
  801e1f:	e8 98 ff ff ff       	call   801dbc <syscall>
  801e24:	83 c4 18             	add    $0x18,%esp
}
  801e27:	c9                   	leave  
  801e28:	c3                   	ret    

00801e29 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801e29:	55                   	push   %ebp
  801e2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801e2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e32:	6a 00                	push   $0x0
  801e34:	6a 00                	push   $0x0
  801e36:	6a 00                	push   $0x0
  801e38:	52                   	push   %edx
  801e39:	50                   	push   %eax
  801e3a:	6a 05                	push   $0x5
  801e3c:	e8 7b ff ff ff       	call   801dbc <syscall>
  801e41:	83 c4 18             	add    $0x18,%esp
}
  801e44:	c9                   	leave  
  801e45:	c3                   	ret    

00801e46 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801e46:	55                   	push   %ebp
  801e47:	89 e5                	mov    %esp,%ebp
  801e49:	56                   	push   %esi
  801e4a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801e4b:	8b 75 18             	mov    0x18(%ebp),%esi
  801e4e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e51:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e54:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e57:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5a:	56                   	push   %esi
  801e5b:	53                   	push   %ebx
  801e5c:	51                   	push   %ecx
  801e5d:	52                   	push   %edx
  801e5e:	50                   	push   %eax
  801e5f:	6a 06                	push   $0x6
  801e61:	e8 56 ff ff ff       	call   801dbc <syscall>
  801e66:	83 c4 18             	add    $0x18,%esp
}
  801e69:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e6c:	5b                   	pop    %ebx
  801e6d:	5e                   	pop    %esi
  801e6e:	5d                   	pop    %ebp
  801e6f:	c3                   	ret    

00801e70 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801e70:	55                   	push   %ebp
  801e71:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801e73:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e76:	8b 45 08             	mov    0x8(%ebp),%eax
  801e79:	6a 00                	push   $0x0
  801e7b:	6a 00                	push   $0x0
  801e7d:	6a 00                	push   $0x0
  801e7f:	52                   	push   %edx
  801e80:	50                   	push   %eax
  801e81:	6a 07                	push   $0x7
  801e83:	e8 34 ff ff ff       	call   801dbc <syscall>
  801e88:	83 c4 18             	add    $0x18,%esp
}
  801e8b:	c9                   	leave  
  801e8c:	c3                   	ret    

00801e8d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801e8d:	55                   	push   %ebp
  801e8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801e90:	6a 00                	push   $0x0
  801e92:	6a 00                	push   $0x0
  801e94:	6a 00                	push   $0x0
  801e96:	ff 75 0c             	pushl  0xc(%ebp)
  801e99:	ff 75 08             	pushl  0x8(%ebp)
  801e9c:	6a 08                	push   $0x8
  801e9e:	e8 19 ff ff ff       	call   801dbc <syscall>
  801ea3:	83 c4 18             	add    $0x18,%esp
}
  801ea6:	c9                   	leave  
  801ea7:	c3                   	ret    

00801ea8 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801ea8:	55                   	push   %ebp
  801ea9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801eab:	6a 00                	push   $0x0
  801ead:	6a 00                	push   $0x0
  801eaf:	6a 00                	push   $0x0
  801eb1:	6a 00                	push   $0x0
  801eb3:	6a 00                	push   $0x0
  801eb5:	6a 09                	push   $0x9
  801eb7:	e8 00 ff ff ff       	call   801dbc <syscall>
  801ebc:	83 c4 18             	add    $0x18,%esp
}
  801ebf:	c9                   	leave  
  801ec0:	c3                   	ret    

00801ec1 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801ec1:	55                   	push   %ebp
  801ec2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 0a                	push   $0xa
  801ed0:	e8 e7 fe ff ff       	call   801dbc <syscall>
  801ed5:	83 c4 18             	add    $0x18,%esp
}
  801ed8:	c9                   	leave  
  801ed9:	c3                   	ret    

00801eda <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801eda:	55                   	push   %ebp
  801edb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801edd:	6a 00                	push   $0x0
  801edf:	6a 00                	push   $0x0
  801ee1:	6a 00                	push   $0x0
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 0b                	push   $0xb
  801ee9:	e8 ce fe ff ff       	call   801dbc <syscall>
  801eee:	83 c4 18             	add    $0x18,%esp
}
  801ef1:	c9                   	leave  
  801ef2:	c3                   	ret    

00801ef3 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801ef3:	55                   	push   %ebp
  801ef4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801ef6:	6a 00                	push   $0x0
  801ef8:	6a 00                	push   $0x0
  801efa:	6a 00                	push   $0x0
  801efc:	ff 75 0c             	pushl  0xc(%ebp)
  801eff:	ff 75 08             	pushl  0x8(%ebp)
  801f02:	6a 0f                	push   $0xf
  801f04:	e8 b3 fe ff ff       	call   801dbc <syscall>
  801f09:	83 c4 18             	add    $0x18,%esp
	return;
  801f0c:	90                   	nop
}
  801f0d:	c9                   	leave  
  801f0e:	c3                   	ret    

00801f0f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801f0f:	55                   	push   %ebp
  801f10:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801f12:	6a 00                	push   $0x0
  801f14:	6a 00                	push   $0x0
  801f16:	6a 00                	push   $0x0
  801f18:	ff 75 0c             	pushl  0xc(%ebp)
  801f1b:	ff 75 08             	pushl  0x8(%ebp)
  801f1e:	6a 10                	push   $0x10
  801f20:	e8 97 fe ff ff       	call   801dbc <syscall>
  801f25:	83 c4 18             	add    $0x18,%esp
	return ;
  801f28:	90                   	nop
}
  801f29:	c9                   	leave  
  801f2a:	c3                   	ret    

00801f2b <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801f2b:	55                   	push   %ebp
  801f2c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801f2e:	6a 00                	push   $0x0
  801f30:	6a 00                	push   $0x0
  801f32:	ff 75 10             	pushl  0x10(%ebp)
  801f35:	ff 75 0c             	pushl  0xc(%ebp)
  801f38:	ff 75 08             	pushl  0x8(%ebp)
  801f3b:	6a 11                	push   $0x11
  801f3d:	e8 7a fe ff ff       	call   801dbc <syscall>
  801f42:	83 c4 18             	add    $0x18,%esp
	return ;
  801f45:	90                   	nop
}
  801f46:	c9                   	leave  
  801f47:	c3                   	ret    

00801f48 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801f48:	55                   	push   %ebp
  801f49:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801f4b:	6a 00                	push   $0x0
  801f4d:	6a 00                	push   $0x0
  801f4f:	6a 00                	push   $0x0
  801f51:	6a 00                	push   $0x0
  801f53:	6a 00                	push   $0x0
  801f55:	6a 0c                	push   $0xc
  801f57:	e8 60 fe ff ff       	call   801dbc <syscall>
  801f5c:	83 c4 18             	add    $0x18,%esp
}
  801f5f:	c9                   	leave  
  801f60:	c3                   	ret    

00801f61 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801f61:	55                   	push   %ebp
  801f62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801f64:	6a 00                	push   $0x0
  801f66:	6a 00                	push   $0x0
  801f68:	6a 00                	push   $0x0
  801f6a:	6a 00                	push   $0x0
  801f6c:	ff 75 08             	pushl  0x8(%ebp)
  801f6f:	6a 0d                	push   $0xd
  801f71:	e8 46 fe ff ff       	call   801dbc <syscall>
  801f76:	83 c4 18             	add    $0x18,%esp
}
  801f79:	c9                   	leave  
  801f7a:	c3                   	ret    

00801f7b <sys_scarce_memory>:

void sys_scarce_memory()
{
  801f7b:	55                   	push   %ebp
  801f7c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801f7e:	6a 00                	push   $0x0
  801f80:	6a 00                	push   $0x0
  801f82:	6a 00                	push   $0x0
  801f84:	6a 00                	push   $0x0
  801f86:	6a 00                	push   $0x0
  801f88:	6a 0e                	push   $0xe
  801f8a:	e8 2d fe ff ff       	call   801dbc <syscall>
  801f8f:	83 c4 18             	add    $0x18,%esp
}
  801f92:	90                   	nop
  801f93:	c9                   	leave  
  801f94:	c3                   	ret    

00801f95 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801f95:	55                   	push   %ebp
  801f96:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801f98:	6a 00                	push   $0x0
  801f9a:	6a 00                	push   $0x0
  801f9c:	6a 00                	push   $0x0
  801f9e:	6a 00                	push   $0x0
  801fa0:	6a 00                	push   $0x0
  801fa2:	6a 13                	push   $0x13
  801fa4:	e8 13 fe ff ff       	call   801dbc <syscall>
  801fa9:	83 c4 18             	add    $0x18,%esp
}
  801fac:	90                   	nop
  801fad:	c9                   	leave  
  801fae:	c3                   	ret    

00801faf <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801faf:	55                   	push   %ebp
  801fb0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801fb2:	6a 00                	push   $0x0
  801fb4:	6a 00                	push   $0x0
  801fb6:	6a 00                	push   $0x0
  801fb8:	6a 00                	push   $0x0
  801fba:	6a 00                	push   $0x0
  801fbc:	6a 14                	push   $0x14
  801fbe:	e8 f9 fd ff ff       	call   801dbc <syscall>
  801fc3:	83 c4 18             	add    $0x18,%esp
}
  801fc6:	90                   	nop
  801fc7:	c9                   	leave  
  801fc8:	c3                   	ret    

00801fc9 <sys_cputc>:


void
sys_cputc(const char c)
{
  801fc9:	55                   	push   %ebp
  801fca:	89 e5                	mov    %esp,%ebp
  801fcc:	83 ec 04             	sub    $0x4,%esp
  801fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801fd5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801fd9:	6a 00                	push   $0x0
  801fdb:	6a 00                	push   $0x0
  801fdd:	6a 00                	push   $0x0
  801fdf:	6a 00                	push   $0x0
  801fe1:	50                   	push   %eax
  801fe2:	6a 15                	push   $0x15
  801fe4:	e8 d3 fd ff ff       	call   801dbc <syscall>
  801fe9:	83 c4 18             	add    $0x18,%esp
}
  801fec:	90                   	nop
  801fed:	c9                   	leave  
  801fee:	c3                   	ret    

00801fef <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801fef:	55                   	push   %ebp
  801ff0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ff2:	6a 00                	push   $0x0
  801ff4:	6a 00                	push   $0x0
  801ff6:	6a 00                	push   $0x0
  801ff8:	6a 00                	push   $0x0
  801ffa:	6a 00                	push   $0x0
  801ffc:	6a 16                	push   $0x16
  801ffe:	e8 b9 fd ff ff       	call   801dbc <syscall>
  802003:	83 c4 18             	add    $0x18,%esp
}
  802006:	90                   	nop
  802007:	c9                   	leave  
  802008:	c3                   	ret    

00802009 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802009:	55                   	push   %ebp
  80200a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80200c:	8b 45 08             	mov    0x8(%ebp),%eax
  80200f:	6a 00                	push   $0x0
  802011:	6a 00                	push   $0x0
  802013:	6a 00                	push   $0x0
  802015:	ff 75 0c             	pushl  0xc(%ebp)
  802018:	50                   	push   %eax
  802019:	6a 17                	push   $0x17
  80201b:	e8 9c fd ff ff       	call   801dbc <syscall>
  802020:	83 c4 18             	add    $0x18,%esp
}
  802023:	c9                   	leave  
  802024:	c3                   	ret    

00802025 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802025:	55                   	push   %ebp
  802026:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802028:	8b 55 0c             	mov    0xc(%ebp),%edx
  80202b:	8b 45 08             	mov    0x8(%ebp),%eax
  80202e:	6a 00                	push   $0x0
  802030:	6a 00                	push   $0x0
  802032:	6a 00                	push   $0x0
  802034:	52                   	push   %edx
  802035:	50                   	push   %eax
  802036:	6a 1a                	push   $0x1a
  802038:	e8 7f fd ff ff       	call   801dbc <syscall>
  80203d:	83 c4 18             	add    $0x18,%esp
}
  802040:	c9                   	leave  
  802041:	c3                   	ret    

00802042 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802042:	55                   	push   %ebp
  802043:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802045:	8b 55 0c             	mov    0xc(%ebp),%edx
  802048:	8b 45 08             	mov    0x8(%ebp),%eax
  80204b:	6a 00                	push   $0x0
  80204d:	6a 00                	push   $0x0
  80204f:	6a 00                	push   $0x0
  802051:	52                   	push   %edx
  802052:	50                   	push   %eax
  802053:	6a 18                	push   $0x18
  802055:	e8 62 fd ff ff       	call   801dbc <syscall>
  80205a:	83 c4 18             	add    $0x18,%esp
}
  80205d:	90                   	nop
  80205e:	c9                   	leave  
  80205f:	c3                   	ret    

00802060 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802060:	55                   	push   %ebp
  802061:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802063:	8b 55 0c             	mov    0xc(%ebp),%edx
  802066:	8b 45 08             	mov    0x8(%ebp),%eax
  802069:	6a 00                	push   $0x0
  80206b:	6a 00                	push   $0x0
  80206d:	6a 00                	push   $0x0
  80206f:	52                   	push   %edx
  802070:	50                   	push   %eax
  802071:	6a 19                	push   $0x19
  802073:	e8 44 fd ff ff       	call   801dbc <syscall>
  802078:	83 c4 18             	add    $0x18,%esp
}
  80207b:	90                   	nop
  80207c:	c9                   	leave  
  80207d:	c3                   	ret    

0080207e <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80207e:	55                   	push   %ebp
  80207f:	89 e5                	mov    %esp,%ebp
  802081:	83 ec 04             	sub    $0x4,%esp
  802084:	8b 45 10             	mov    0x10(%ebp),%eax
  802087:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80208a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80208d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802091:	8b 45 08             	mov    0x8(%ebp),%eax
  802094:	6a 00                	push   $0x0
  802096:	51                   	push   %ecx
  802097:	52                   	push   %edx
  802098:	ff 75 0c             	pushl  0xc(%ebp)
  80209b:	50                   	push   %eax
  80209c:	6a 1b                	push   $0x1b
  80209e:	e8 19 fd ff ff       	call   801dbc <syscall>
  8020a3:	83 c4 18             	add    $0x18,%esp
}
  8020a6:	c9                   	leave  
  8020a7:	c3                   	ret    

008020a8 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8020a8:	55                   	push   %ebp
  8020a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8020ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b1:	6a 00                	push   $0x0
  8020b3:	6a 00                	push   $0x0
  8020b5:	6a 00                	push   $0x0
  8020b7:	52                   	push   %edx
  8020b8:	50                   	push   %eax
  8020b9:	6a 1c                	push   $0x1c
  8020bb:	e8 fc fc ff ff       	call   801dbc <syscall>
  8020c0:	83 c4 18             	add    $0x18,%esp
}
  8020c3:	c9                   	leave  
  8020c4:	c3                   	ret    

008020c5 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8020c5:	55                   	push   %ebp
  8020c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8020c8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d1:	6a 00                	push   $0x0
  8020d3:	6a 00                	push   $0x0
  8020d5:	51                   	push   %ecx
  8020d6:	52                   	push   %edx
  8020d7:	50                   	push   %eax
  8020d8:	6a 1d                	push   $0x1d
  8020da:	e8 dd fc ff ff       	call   801dbc <syscall>
  8020df:	83 c4 18             	add    $0x18,%esp
}
  8020e2:	c9                   	leave  
  8020e3:	c3                   	ret    

008020e4 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8020e4:	55                   	push   %ebp
  8020e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8020e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ed:	6a 00                	push   $0x0
  8020ef:	6a 00                	push   $0x0
  8020f1:	6a 00                	push   $0x0
  8020f3:	52                   	push   %edx
  8020f4:	50                   	push   %eax
  8020f5:	6a 1e                	push   $0x1e
  8020f7:	e8 c0 fc ff ff       	call   801dbc <syscall>
  8020fc:	83 c4 18             	add    $0x18,%esp
}
  8020ff:	c9                   	leave  
  802100:	c3                   	ret    

00802101 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802101:	55                   	push   %ebp
  802102:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802104:	6a 00                	push   $0x0
  802106:	6a 00                	push   $0x0
  802108:	6a 00                	push   $0x0
  80210a:	6a 00                	push   $0x0
  80210c:	6a 00                	push   $0x0
  80210e:	6a 1f                	push   $0x1f
  802110:	e8 a7 fc ff ff       	call   801dbc <syscall>
  802115:	83 c4 18             	add    $0x18,%esp
}
  802118:	c9                   	leave  
  802119:	c3                   	ret    

0080211a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80211a:	55                   	push   %ebp
  80211b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80211d:	8b 45 08             	mov    0x8(%ebp),%eax
  802120:	6a 00                	push   $0x0
  802122:	ff 75 14             	pushl  0x14(%ebp)
  802125:	ff 75 10             	pushl  0x10(%ebp)
  802128:	ff 75 0c             	pushl  0xc(%ebp)
  80212b:	50                   	push   %eax
  80212c:	6a 20                	push   $0x20
  80212e:	e8 89 fc ff ff       	call   801dbc <syscall>
  802133:	83 c4 18             	add    $0x18,%esp
}
  802136:	c9                   	leave  
  802137:	c3                   	ret    

00802138 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802138:	55                   	push   %ebp
  802139:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80213b:	8b 45 08             	mov    0x8(%ebp),%eax
  80213e:	6a 00                	push   $0x0
  802140:	6a 00                	push   $0x0
  802142:	6a 00                	push   $0x0
  802144:	6a 00                	push   $0x0
  802146:	50                   	push   %eax
  802147:	6a 21                	push   $0x21
  802149:	e8 6e fc ff ff       	call   801dbc <syscall>
  80214e:	83 c4 18             	add    $0x18,%esp
}
  802151:	90                   	nop
  802152:	c9                   	leave  
  802153:	c3                   	ret    

00802154 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802154:	55                   	push   %ebp
  802155:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802157:	8b 45 08             	mov    0x8(%ebp),%eax
  80215a:	6a 00                	push   $0x0
  80215c:	6a 00                	push   $0x0
  80215e:	6a 00                	push   $0x0
  802160:	6a 00                	push   $0x0
  802162:	50                   	push   %eax
  802163:	6a 22                	push   $0x22
  802165:	e8 52 fc ff ff       	call   801dbc <syscall>
  80216a:	83 c4 18             	add    $0x18,%esp
}
  80216d:	c9                   	leave  
  80216e:	c3                   	ret    

0080216f <sys_getenvid>:

int32 sys_getenvid(void)
{
  80216f:	55                   	push   %ebp
  802170:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802172:	6a 00                	push   $0x0
  802174:	6a 00                	push   $0x0
  802176:	6a 00                	push   $0x0
  802178:	6a 00                	push   $0x0
  80217a:	6a 00                	push   $0x0
  80217c:	6a 02                	push   $0x2
  80217e:	e8 39 fc ff ff       	call   801dbc <syscall>
  802183:	83 c4 18             	add    $0x18,%esp
}
  802186:	c9                   	leave  
  802187:	c3                   	ret    

00802188 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802188:	55                   	push   %ebp
  802189:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80218b:	6a 00                	push   $0x0
  80218d:	6a 00                	push   $0x0
  80218f:	6a 00                	push   $0x0
  802191:	6a 00                	push   $0x0
  802193:	6a 00                	push   $0x0
  802195:	6a 03                	push   $0x3
  802197:	e8 20 fc ff ff       	call   801dbc <syscall>
  80219c:	83 c4 18             	add    $0x18,%esp
}
  80219f:	c9                   	leave  
  8021a0:	c3                   	ret    

008021a1 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8021a1:	55                   	push   %ebp
  8021a2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8021a4:	6a 00                	push   $0x0
  8021a6:	6a 00                	push   $0x0
  8021a8:	6a 00                	push   $0x0
  8021aa:	6a 00                	push   $0x0
  8021ac:	6a 00                	push   $0x0
  8021ae:	6a 04                	push   $0x4
  8021b0:	e8 07 fc ff ff       	call   801dbc <syscall>
  8021b5:	83 c4 18             	add    $0x18,%esp
}
  8021b8:	c9                   	leave  
  8021b9:	c3                   	ret    

008021ba <sys_exit_env>:


void sys_exit_env(void)
{
  8021ba:	55                   	push   %ebp
  8021bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8021bd:	6a 00                	push   $0x0
  8021bf:	6a 00                	push   $0x0
  8021c1:	6a 00                	push   $0x0
  8021c3:	6a 00                	push   $0x0
  8021c5:	6a 00                	push   $0x0
  8021c7:	6a 23                	push   $0x23
  8021c9:	e8 ee fb ff ff       	call   801dbc <syscall>
  8021ce:	83 c4 18             	add    $0x18,%esp
}
  8021d1:	90                   	nop
  8021d2:	c9                   	leave  
  8021d3:	c3                   	ret    

008021d4 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8021d4:	55                   	push   %ebp
  8021d5:	89 e5                	mov    %esp,%ebp
  8021d7:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8021da:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8021dd:	8d 50 04             	lea    0x4(%eax),%edx
  8021e0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8021e3:	6a 00                	push   $0x0
  8021e5:	6a 00                	push   $0x0
  8021e7:	6a 00                	push   $0x0
  8021e9:	52                   	push   %edx
  8021ea:	50                   	push   %eax
  8021eb:	6a 24                	push   $0x24
  8021ed:	e8 ca fb ff ff       	call   801dbc <syscall>
  8021f2:	83 c4 18             	add    $0x18,%esp
	return result;
  8021f5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021fb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8021fe:	89 01                	mov    %eax,(%ecx)
  802200:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802203:	8b 45 08             	mov    0x8(%ebp),%eax
  802206:	c9                   	leave  
  802207:	c2 04 00             	ret    $0x4

0080220a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80220a:	55                   	push   %ebp
  80220b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80220d:	6a 00                	push   $0x0
  80220f:	6a 00                	push   $0x0
  802211:	ff 75 10             	pushl  0x10(%ebp)
  802214:	ff 75 0c             	pushl  0xc(%ebp)
  802217:	ff 75 08             	pushl  0x8(%ebp)
  80221a:	6a 12                	push   $0x12
  80221c:	e8 9b fb ff ff       	call   801dbc <syscall>
  802221:	83 c4 18             	add    $0x18,%esp
	return ;
  802224:	90                   	nop
}
  802225:	c9                   	leave  
  802226:	c3                   	ret    

00802227 <sys_rcr2>:
uint32 sys_rcr2()
{
  802227:	55                   	push   %ebp
  802228:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80222a:	6a 00                	push   $0x0
  80222c:	6a 00                	push   $0x0
  80222e:	6a 00                	push   $0x0
  802230:	6a 00                	push   $0x0
  802232:	6a 00                	push   $0x0
  802234:	6a 25                	push   $0x25
  802236:	e8 81 fb ff ff       	call   801dbc <syscall>
  80223b:	83 c4 18             	add    $0x18,%esp
}
  80223e:	c9                   	leave  
  80223f:	c3                   	ret    

00802240 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802240:	55                   	push   %ebp
  802241:	89 e5                	mov    %esp,%ebp
  802243:	83 ec 04             	sub    $0x4,%esp
  802246:	8b 45 08             	mov    0x8(%ebp),%eax
  802249:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80224c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802250:	6a 00                	push   $0x0
  802252:	6a 00                	push   $0x0
  802254:	6a 00                	push   $0x0
  802256:	6a 00                	push   $0x0
  802258:	50                   	push   %eax
  802259:	6a 26                	push   $0x26
  80225b:	e8 5c fb ff ff       	call   801dbc <syscall>
  802260:	83 c4 18             	add    $0x18,%esp
	return ;
  802263:	90                   	nop
}
  802264:	c9                   	leave  
  802265:	c3                   	ret    

00802266 <rsttst>:
void rsttst()
{
  802266:	55                   	push   %ebp
  802267:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802269:	6a 00                	push   $0x0
  80226b:	6a 00                	push   $0x0
  80226d:	6a 00                	push   $0x0
  80226f:	6a 00                	push   $0x0
  802271:	6a 00                	push   $0x0
  802273:	6a 28                	push   $0x28
  802275:	e8 42 fb ff ff       	call   801dbc <syscall>
  80227a:	83 c4 18             	add    $0x18,%esp
	return ;
  80227d:	90                   	nop
}
  80227e:	c9                   	leave  
  80227f:	c3                   	ret    

00802280 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802280:	55                   	push   %ebp
  802281:	89 e5                	mov    %esp,%ebp
  802283:	83 ec 04             	sub    $0x4,%esp
  802286:	8b 45 14             	mov    0x14(%ebp),%eax
  802289:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80228c:	8b 55 18             	mov    0x18(%ebp),%edx
  80228f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802293:	52                   	push   %edx
  802294:	50                   	push   %eax
  802295:	ff 75 10             	pushl  0x10(%ebp)
  802298:	ff 75 0c             	pushl  0xc(%ebp)
  80229b:	ff 75 08             	pushl  0x8(%ebp)
  80229e:	6a 27                	push   $0x27
  8022a0:	e8 17 fb ff ff       	call   801dbc <syscall>
  8022a5:	83 c4 18             	add    $0x18,%esp
	return ;
  8022a8:	90                   	nop
}
  8022a9:	c9                   	leave  
  8022aa:	c3                   	ret    

008022ab <chktst>:
void chktst(uint32 n)
{
  8022ab:	55                   	push   %ebp
  8022ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8022ae:	6a 00                	push   $0x0
  8022b0:	6a 00                	push   $0x0
  8022b2:	6a 00                	push   $0x0
  8022b4:	6a 00                	push   $0x0
  8022b6:	ff 75 08             	pushl  0x8(%ebp)
  8022b9:	6a 29                	push   $0x29
  8022bb:	e8 fc fa ff ff       	call   801dbc <syscall>
  8022c0:	83 c4 18             	add    $0x18,%esp
	return ;
  8022c3:	90                   	nop
}
  8022c4:	c9                   	leave  
  8022c5:	c3                   	ret    

008022c6 <inctst>:

void inctst()
{
  8022c6:	55                   	push   %ebp
  8022c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8022c9:	6a 00                	push   $0x0
  8022cb:	6a 00                	push   $0x0
  8022cd:	6a 00                	push   $0x0
  8022cf:	6a 00                	push   $0x0
  8022d1:	6a 00                	push   $0x0
  8022d3:	6a 2a                	push   $0x2a
  8022d5:	e8 e2 fa ff ff       	call   801dbc <syscall>
  8022da:	83 c4 18             	add    $0x18,%esp
	return ;
  8022dd:	90                   	nop
}
  8022de:	c9                   	leave  
  8022df:	c3                   	ret    

008022e0 <gettst>:
uint32 gettst()
{
  8022e0:	55                   	push   %ebp
  8022e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8022e3:	6a 00                	push   $0x0
  8022e5:	6a 00                	push   $0x0
  8022e7:	6a 00                	push   $0x0
  8022e9:	6a 00                	push   $0x0
  8022eb:	6a 00                	push   $0x0
  8022ed:	6a 2b                	push   $0x2b
  8022ef:	e8 c8 fa ff ff       	call   801dbc <syscall>
  8022f4:	83 c4 18             	add    $0x18,%esp
}
  8022f7:	c9                   	leave  
  8022f8:	c3                   	ret    

008022f9 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8022f9:	55                   	push   %ebp
  8022fa:	89 e5                	mov    %esp,%ebp
  8022fc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022ff:	6a 00                	push   $0x0
  802301:	6a 00                	push   $0x0
  802303:	6a 00                	push   $0x0
  802305:	6a 00                	push   $0x0
  802307:	6a 00                	push   $0x0
  802309:	6a 2c                	push   $0x2c
  80230b:	e8 ac fa ff ff       	call   801dbc <syscall>
  802310:	83 c4 18             	add    $0x18,%esp
  802313:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802316:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80231a:	75 07                	jne    802323 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80231c:	b8 01 00 00 00       	mov    $0x1,%eax
  802321:	eb 05                	jmp    802328 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802323:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802328:	c9                   	leave  
  802329:	c3                   	ret    

0080232a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80232a:	55                   	push   %ebp
  80232b:	89 e5                	mov    %esp,%ebp
  80232d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802330:	6a 00                	push   $0x0
  802332:	6a 00                	push   $0x0
  802334:	6a 00                	push   $0x0
  802336:	6a 00                	push   $0x0
  802338:	6a 00                	push   $0x0
  80233a:	6a 2c                	push   $0x2c
  80233c:	e8 7b fa ff ff       	call   801dbc <syscall>
  802341:	83 c4 18             	add    $0x18,%esp
  802344:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802347:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80234b:	75 07                	jne    802354 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80234d:	b8 01 00 00 00       	mov    $0x1,%eax
  802352:	eb 05                	jmp    802359 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802354:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802359:	c9                   	leave  
  80235a:	c3                   	ret    

0080235b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80235b:	55                   	push   %ebp
  80235c:	89 e5                	mov    %esp,%ebp
  80235e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802361:	6a 00                	push   $0x0
  802363:	6a 00                	push   $0x0
  802365:	6a 00                	push   $0x0
  802367:	6a 00                	push   $0x0
  802369:	6a 00                	push   $0x0
  80236b:	6a 2c                	push   $0x2c
  80236d:	e8 4a fa ff ff       	call   801dbc <syscall>
  802372:	83 c4 18             	add    $0x18,%esp
  802375:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802378:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80237c:	75 07                	jne    802385 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80237e:	b8 01 00 00 00       	mov    $0x1,%eax
  802383:	eb 05                	jmp    80238a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802385:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80238a:	c9                   	leave  
  80238b:	c3                   	ret    

0080238c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80238c:	55                   	push   %ebp
  80238d:	89 e5                	mov    %esp,%ebp
  80238f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802392:	6a 00                	push   $0x0
  802394:	6a 00                	push   $0x0
  802396:	6a 00                	push   $0x0
  802398:	6a 00                	push   $0x0
  80239a:	6a 00                	push   $0x0
  80239c:	6a 2c                	push   $0x2c
  80239e:	e8 19 fa ff ff       	call   801dbc <syscall>
  8023a3:	83 c4 18             	add    $0x18,%esp
  8023a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8023a9:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8023ad:	75 07                	jne    8023b6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8023af:	b8 01 00 00 00       	mov    $0x1,%eax
  8023b4:	eb 05                	jmp    8023bb <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8023b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023bb:	c9                   	leave  
  8023bc:	c3                   	ret    

008023bd <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8023bd:	55                   	push   %ebp
  8023be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8023c0:	6a 00                	push   $0x0
  8023c2:	6a 00                	push   $0x0
  8023c4:	6a 00                	push   $0x0
  8023c6:	6a 00                	push   $0x0
  8023c8:	ff 75 08             	pushl  0x8(%ebp)
  8023cb:	6a 2d                	push   $0x2d
  8023cd:	e8 ea f9 ff ff       	call   801dbc <syscall>
  8023d2:	83 c4 18             	add    $0x18,%esp
	return ;
  8023d5:	90                   	nop
}
  8023d6:	c9                   	leave  
  8023d7:	c3                   	ret    

008023d8 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8023d8:	55                   	push   %ebp
  8023d9:	89 e5                	mov    %esp,%ebp
  8023db:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8023dc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8023df:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8023e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e8:	6a 00                	push   $0x0
  8023ea:	53                   	push   %ebx
  8023eb:	51                   	push   %ecx
  8023ec:	52                   	push   %edx
  8023ed:	50                   	push   %eax
  8023ee:	6a 2e                	push   $0x2e
  8023f0:	e8 c7 f9 ff ff       	call   801dbc <syscall>
  8023f5:	83 c4 18             	add    $0x18,%esp
}
  8023f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023fb:	c9                   	leave  
  8023fc:	c3                   	ret    

008023fd <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8023fd:	55                   	push   %ebp
  8023fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802400:	8b 55 0c             	mov    0xc(%ebp),%edx
  802403:	8b 45 08             	mov    0x8(%ebp),%eax
  802406:	6a 00                	push   $0x0
  802408:	6a 00                	push   $0x0
  80240a:	6a 00                	push   $0x0
  80240c:	52                   	push   %edx
  80240d:	50                   	push   %eax
  80240e:	6a 2f                	push   $0x2f
  802410:	e8 a7 f9 ff ff       	call   801dbc <syscall>
  802415:	83 c4 18             	add    $0x18,%esp
}
  802418:	c9                   	leave  
  802419:	c3                   	ret    

0080241a <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80241a:	55                   	push   %ebp
  80241b:	89 e5                	mov    %esp,%ebp
  80241d:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802420:	83 ec 0c             	sub    $0xc,%esp
  802423:	68 7c 45 80 00       	push   $0x80457c
  802428:	e8 18 e6 ff ff       	call   800a45 <cprintf>
  80242d:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802430:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802437:	83 ec 0c             	sub    $0xc,%esp
  80243a:	68 a8 45 80 00       	push   $0x8045a8
  80243f:	e8 01 e6 ff ff       	call   800a45 <cprintf>
  802444:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802447:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80244b:	a1 38 51 80 00       	mov    0x805138,%eax
  802450:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802453:	eb 56                	jmp    8024ab <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802455:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802459:	74 1c                	je     802477 <print_mem_block_lists+0x5d>
  80245b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245e:	8b 50 08             	mov    0x8(%eax),%edx
  802461:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802464:	8b 48 08             	mov    0x8(%eax),%ecx
  802467:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80246a:	8b 40 0c             	mov    0xc(%eax),%eax
  80246d:	01 c8                	add    %ecx,%eax
  80246f:	39 c2                	cmp    %eax,%edx
  802471:	73 04                	jae    802477 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802473:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802477:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247a:	8b 50 08             	mov    0x8(%eax),%edx
  80247d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802480:	8b 40 0c             	mov    0xc(%eax),%eax
  802483:	01 c2                	add    %eax,%edx
  802485:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802488:	8b 40 08             	mov    0x8(%eax),%eax
  80248b:	83 ec 04             	sub    $0x4,%esp
  80248e:	52                   	push   %edx
  80248f:	50                   	push   %eax
  802490:	68 bd 45 80 00       	push   $0x8045bd
  802495:	e8 ab e5 ff ff       	call   800a45 <cprintf>
  80249a:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80249d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8024a3:	a1 40 51 80 00       	mov    0x805140,%eax
  8024a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024af:	74 07                	je     8024b8 <print_mem_block_lists+0x9e>
  8024b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b4:	8b 00                	mov    (%eax),%eax
  8024b6:	eb 05                	jmp    8024bd <print_mem_block_lists+0xa3>
  8024b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8024bd:	a3 40 51 80 00       	mov    %eax,0x805140
  8024c2:	a1 40 51 80 00       	mov    0x805140,%eax
  8024c7:	85 c0                	test   %eax,%eax
  8024c9:	75 8a                	jne    802455 <print_mem_block_lists+0x3b>
  8024cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024cf:	75 84                	jne    802455 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8024d1:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8024d5:	75 10                	jne    8024e7 <print_mem_block_lists+0xcd>
  8024d7:	83 ec 0c             	sub    $0xc,%esp
  8024da:	68 cc 45 80 00       	push   $0x8045cc
  8024df:	e8 61 e5 ff ff       	call   800a45 <cprintf>
  8024e4:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8024e7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8024ee:	83 ec 0c             	sub    $0xc,%esp
  8024f1:	68 f0 45 80 00       	push   $0x8045f0
  8024f6:	e8 4a e5 ff ff       	call   800a45 <cprintf>
  8024fb:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8024fe:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802502:	a1 40 50 80 00       	mov    0x805040,%eax
  802507:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80250a:	eb 56                	jmp    802562 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80250c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802510:	74 1c                	je     80252e <print_mem_block_lists+0x114>
  802512:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802515:	8b 50 08             	mov    0x8(%eax),%edx
  802518:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80251b:	8b 48 08             	mov    0x8(%eax),%ecx
  80251e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802521:	8b 40 0c             	mov    0xc(%eax),%eax
  802524:	01 c8                	add    %ecx,%eax
  802526:	39 c2                	cmp    %eax,%edx
  802528:	73 04                	jae    80252e <print_mem_block_lists+0x114>
			sorted = 0 ;
  80252a:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80252e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802531:	8b 50 08             	mov    0x8(%eax),%edx
  802534:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802537:	8b 40 0c             	mov    0xc(%eax),%eax
  80253a:	01 c2                	add    %eax,%edx
  80253c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253f:	8b 40 08             	mov    0x8(%eax),%eax
  802542:	83 ec 04             	sub    $0x4,%esp
  802545:	52                   	push   %edx
  802546:	50                   	push   %eax
  802547:	68 bd 45 80 00       	push   $0x8045bd
  80254c:	e8 f4 e4 ff ff       	call   800a45 <cprintf>
  802551:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802554:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802557:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80255a:	a1 48 50 80 00       	mov    0x805048,%eax
  80255f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802562:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802566:	74 07                	je     80256f <print_mem_block_lists+0x155>
  802568:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256b:	8b 00                	mov    (%eax),%eax
  80256d:	eb 05                	jmp    802574 <print_mem_block_lists+0x15a>
  80256f:	b8 00 00 00 00       	mov    $0x0,%eax
  802574:	a3 48 50 80 00       	mov    %eax,0x805048
  802579:	a1 48 50 80 00       	mov    0x805048,%eax
  80257e:	85 c0                	test   %eax,%eax
  802580:	75 8a                	jne    80250c <print_mem_block_lists+0xf2>
  802582:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802586:	75 84                	jne    80250c <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802588:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80258c:	75 10                	jne    80259e <print_mem_block_lists+0x184>
  80258e:	83 ec 0c             	sub    $0xc,%esp
  802591:	68 08 46 80 00       	push   $0x804608
  802596:	e8 aa e4 ff ff       	call   800a45 <cprintf>
  80259b:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80259e:	83 ec 0c             	sub    $0xc,%esp
  8025a1:	68 7c 45 80 00       	push   $0x80457c
  8025a6:	e8 9a e4 ff ff       	call   800a45 <cprintf>
  8025ab:	83 c4 10             	add    $0x10,%esp

}
  8025ae:	90                   	nop
  8025af:	c9                   	leave  
  8025b0:	c3                   	ret    

008025b1 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8025b1:	55                   	push   %ebp
  8025b2:	89 e5                	mov    %esp,%ebp
  8025b4:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8025b7:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8025be:	00 00 00 
  8025c1:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8025c8:	00 00 00 
  8025cb:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8025d2:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8025d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8025dc:	e9 9e 00 00 00       	jmp    80267f <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8025e1:	a1 50 50 80 00       	mov    0x805050,%eax
  8025e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025e9:	c1 e2 04             	shl    $0x4,%edx
  8025ec:	01 d0                	add    %edx,%eax
  8025ee:	85 c0                	test   %eax,%eax
  8025f0:	75 14                	jne    802606 <initialize_MemBlocksList+0x55>
  8025f2:	83 ec 04             	sub    $0x4,%esp
  8025f5:	68 30 46 80 00       	push   $0x804630
  8025fa:	6a 46                	push   $0x46
  8025fc:	68 53 46 80 00       	push   $0x804653
  802601:	e8 8b e1 ff ff       	call   800791 <_panic>
  802606:	a1 50 50 80 00       	mov    0x805050,%eax
  80260b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80260e:	c1 e2 04             	shl    $0x4,%edx
  802611:	01 d0                	add    %edx,%eax
  802613:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802619:	89 10                	mov    %edx,(%eax)
  80261b:	8b 00                	mov    (%eax),%eax
  80261d:	85 c0                	test   %eax,%eax
  80261f:	74 18                	je     802639 <initialize_MemBlocksList+0x88>
  802621:	a1 48 51 80 00       	mov    0x805148,%eax
  802626:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80262c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80262f:	c1 e1 04             	shl    $0x4,%ecx
  802632:	01 ca                	add    %ecx,%edx
  802634:	89 50 04             	mov    %edx,0x4(%eax)
  802637:	eb 12                	jmp    80264b <initialize_MemBlocksList+0x9a>
  802639:	a1 50 50 80 00       	mov    0x805050,%eax
  80263e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802641:	c1 e2 04             	shl    $0x4,%edx
  802644:	01 d0                	add    %edx,%eax
  802646:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80264b:	a1 50 50 80 00       	mov    0x805050,%eax
  802650:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802653:	c1 e2 04             	shl    $0x4,%edx
  802656:	01 d0                	add    %edx,%eax
  802658:	a3 48 51 80 00       	mov    %eax,0x805148
  80265d:	a1 50 50 80 00       	mov    0x805050,%eax
  802662:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802665:	c1 e2 04             	shl    $0x4,%edx
  802668:	01 d0                	add    %edx,%eax
  80266a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802671:	a1 54 51 80 00       	mov    0x805154,%eax
  802676:	40                   	inc    %eax
  802677:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  80267c:	ff 45 f4             	incl   -0xc(%ebp)
  80267f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802682:	3b 45 08             	cmp    0x8(%ebp),%eax
  802685:	0f 82 56 ff ff ff    	jb     8025e1 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  80268b:	90                   	nop
  80268c:	c9                   	leave  
  80268d:	c3                   	ret    

0080268e <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80268e:	55                   	push   %ebp
  80268f:	89 e5                	mov    %esp,%ebp
  802691:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802694:	8b 45 08             	mov    0x8(%ebp),%eax
  802697:	8b 00                	mov    (%eax),%eax
  802699:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80269c:	eb 19                	jmp    8026b7 <find_block+0x29>
	{
		if(va==point->sva)
  80269e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8026a1:	8b 40 08             	mov    0x8(%eax),%eax
  8026a4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8026a7:	75 05                	jne    8026ae <find_block+0x20>
		   return point;
  8026a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8026ac:	eb 36                	jmp    8026e4 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8026ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b1:	8b 40 08             	mov    0x8(%eax),%eax
  8026b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8026b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8026bb:	74 07                	je     8026c4 <find_block+0x36>
  8026bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8026c0:	8b 00                	mov    (%eax),%eax
  8026c2:	eb 05                	jmp    8026c9 <find_block+0x3b>
  8026c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8026c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8026cc:	89 42 08             	mov    %eax,0x8(%edx)
  8026cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d2:	8b 40 08             	mov    0x8(%eax),%eax
  8026d5:	85 c0                	test   %eax,%eax
  8026d7:	75 c5                	jne    80269e <find_block+0x10>
  8026d9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8026dd:	75 bf                	jne    80269e <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8026df:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026e4:	c9                   	leave  
  8026e5:	c3                   	ret    

008026e6 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8026e6:	55                   	push   %ebp
  8026e7:	89 e5                	mov    %esp,%ebp
  8026e9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8026ec:	a1 40 50 80 00       	mov    0x805040,%eax
  8026f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8026f4:	a1 44 50 80 00       	mov    0x805044,%eax
  8026f9:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8026fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ff:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802702:	74 24                	je     802728 <insert_sorted_allocList+0x42>
  802704:	8b 45 08             	mov    0x8(%ebp),%eax
  802707:	8b 50 08             	mov    0x8(%eax),%edx
  80270a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80270d:	8b 40 08             	mov    0x8(%eax),%eax
  802710:	39 c2                	cmp    %eax,%edx
  802712:	76 14                	jbe    802728 <insert_sorted_allocList+0x42>
  802714:	8b 45 08             	mov    0x8(%ebp),%eax
  802717:	8b 50 08             	mov    0x8(%eax),%edx
  80271a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80271d:	8b 40 08             	mov    0x8(%eax),%eax
  802720:	39 c2                	cmp    %eax,%edx
  802722:	0f 82 60 01 00 00    	jb     802888 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802728:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80272c:	75 65                	jne    802793 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80272e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802732:	75 14                	jne    802748 <insert_sorted_allocList+0x62>
  802734:	83 ec 04             	sub    $0x4,%esp
  802737:	68 30 46 80 00       	push   $0x804630
  80273c:	6a 6b                	push   $0x6b
  80273e:	68 53 46 80 00       	push   $0x804653
  802743:	e8 49 e0 ff ff       	call   800791 <_panic>
  802748:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80274e:	8b 45 08             	mov    0x8(%ebp),%eax
  802751:	89 10                	mov    %edx,(%eax)
  802753:	8b 45 08             	mov    0x8(%ebp),%eax
  802756:	8b 00                	mov    (%eax),%eax
  802758:	85 c0                	test   %eax,%eax
  80275a:	74 0d                	je     802769 <insert_sorted_allocList+0x83>
  80275c:	a1 40 50 80 00       	mov    0x805040,%eax
  802761:	8b 55 08             	mov    0x8(%ebp),%edx
  802764:	89 50 04             	mov    %edx,0x4(%eax)
  802767:	eb 08                	jmp    802771 <insert_sorted_allocList+0x8b>
  802769:	8b 45 08             	mov    0x8(%ebp),%eax
  80276c:	a3 44 50 80 00       	mov    %eax,0x805044
  802771:	8b 45 08             	mov    0x8(%ebp),%eax
  802774:	a3 40 50 80 00       	mov    %eax,0x805040
  802779:	8b 45 08             	mov    0x8(%ebp),%eax
  80277c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802783:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802788:	40                   	inc    %eax
  802789:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80278e:	e9 dc 01 00 00       	jmp    80296f <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802793:	8b 45 08             	mov    0x8(%ebp),%eax
  802796:	8b 50 08             	mov    0x8(%eax),%edx
  802799:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80279c:	8b 40 08             	mov    0x8(%eax),%eax
  80279f:	39 c2                	cmp    %eax,%edx
  8027a1:	77 6c                	ja     80280f <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8027a3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027a7:	74 06                	je     8027af <insert_sorted_allocList+0xc9>
  8027a9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027ad:	75 14                	jne    8027c3 <insert_sorted_allocList+0xdd>
  8027af:	83 ec 04             	sub    $0x4,%esp
  8027b2:	68 6c 46 80 00       	push   $0x80466c
  8027b7:	6a 6f                	push   $0x6f
  8027b9:	68 53 46 80 00       	push   $0x804653
  8027be:	e8 ce df ff ff       	call   800791 <_panic>
  8027c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c6:	8b 50 04             	mov    0x4(%eax),%edx
  8027c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027cc:	89 50 04             	mov    %edx,0x4(%eax)
  8027cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027d5:	89 10                	mov    %edx,(%eax)
  8027d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027da:	8b 40 04             	mov    0x4(%eax),%eax
  8027dd:	85 c0                	test   %eax,%eax
  8027df:	74 0d                	je     8027ee <insert_sorted_allocList+0x108>
  8027e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e4:	8b 40 04             	mov    0x4(%eax),%eax
  8027e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8027ea:	89 10                	mov    %edx,(%eax)
  8027ec:	eb 08                	jmp    8027f6 <insert_sorted_allocList+0x110>
  8027ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f1:	a3 40 50 80 00       	mov    %eax,0x805040
  8027f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8027fc:	89 50 04             	mov    %edx,0x4(%eax)
  8027ff:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802804:	40                   	inc    %eax
  802805:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80280a:	e9 60 01 00 00       	jmp    80296f <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80280f:	8b 45 08             	mov    0x8(%ebp),%eax
  802812:	8b 50 08             	mov    0x8(%eax),%edx
  802815:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802818:	8b 40 08             	mov    0x8(%eax),%eax
  80281b:	39 c2                	cmp    %eax,%edx
  80281d:	0f 82 4c 01 00 00    	jb     80296f <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802823:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802827:	75 14                	jne    80283d <insert_sorted_allocList+0x157>
  802829:	83 ec 04             	sub    $0x4,%esp
  80282c:	68 a4 46 80 00       	push   $0x8046a4
  802831:	6a 73                	push   $0x73
  802833:	68 53 46 80 00       	push   $0x804653
  802838:	e8 54 df ff ff       	call   800791 <_panic>
  80283d:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802843:	8b 45 08             	mov    0x8(%ebp),%eax
  802846:	89 50 04             	mov    %edx,0x4(%eax)
  802849:	8b 45 08             	mov    0x8(%ebp),%eax
  80284c:	8b 40 04             	mov    0x4(%eax),%eax
  80284f:	85 c0                	test   %eax,%eax
  802851:	74 0c                	je     80285f <insert_sorted_allocList+0x179>
  802853:	a1 44 50 80 00       	mov    0x805044,%eax
  802858:	8b 55 08             	mov    0x8(%ebp),%edx
  80285b:	89 10                	mov    %edx,(%eax)
  80285d:	eb 08                	jmp    802867 <insert_sorted_allocList+0x181>
  80285f:	8b 45 08             	mov    0x8(%ebp),%eax
  802862:	a3 40 50 80 00       	mov    %eax,0x805040
  802867:	8b 45 08             	mov    0x8(%ebp),%eax
  80286a:	a3 44 50 80 00       	mov    %eax,0x805044
  80286f:	8b 45 08             	mov    0x8(%ebp),%eax
  802872:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802878:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80287d:	40                   	inc    %eax
  80287e:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802883:	e9 e7 00 00 00       	jmp    80296f <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802888:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80288b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80288e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802895:	a1 40 50 80 00       	mov    0x805040,%eax
  80289a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80289d:	e9 9d 00 00 00       	jmp    80293f <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8028a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a5:	8b 00                	mov    (%eax),%eax
  8028a7:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8028aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ad:	8b 50 08             	mov    0x8(%eax),%edx
  8028b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b3:	8b 40 08             	mov    0x8(%eax),%eax
  8028b6:	39 c2                	cmp    %eax,%edx
  8028b8:	76 7d                	jbe    802937 <insert_sorted_allocList+0x251>
  8028ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8028bd:	8b 50 08             	mov    0x8(%eax),%edx
  8028c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028c3:	8b 40 08             	mov    0x8(%eax),%eax
  8028c6:	39 c2                	cmp    %eax,%edx
  8028c8:	73 6d                	jae    802937 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8028ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028ce:	74 06                	je     8028d6 <insert_sorted_allocList+0x1f0>
  8028d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028d4:	75 14                	jne    8028ea <insert_sorted_allocList+0x204>
  8028d6:	83 ec 04             	sub    $0x4,%esp
  8028d9:	68 c8 46 80 00       	push   $0x8046c8
  8028de:	6a 7f                	push   $0x7f
  8028e0:	68 53 46 80 00       	push   $0x804653
  8028e5:	e8 a7 de ff ff       	call   800791 <_panic>
  8028ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ed:	8b 10                	mov    (%eax),%edx
  8028ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f2:	89 10                	mov    %edx,(%eax)
  8028f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f7:	8b 00                	mov    (%eax),%eax
  8028f9:	85 c0                	test   %eax,%eax
  8028fb:	74 0b                	je     802908 <insert_sorted_allocList+0x222>
  8028fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802900:	8b 00                	mov    (%eax),%eax
  802902:	8b 55 08             	mov    0x8(%ebp),%edx
  802905:	89 50 04             	mov    %edx,0x4(%eax)
  802908:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290b:	8b 55 08             	mov    0x8(%ebp),%edx
  80290e:	89 10                	mov    %edx,(%eax)
  802910:	8b 45 08             	mov    0x8(%ebp),%eax
  802913:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802916:	89 50 04             	mov    %edx,0x4(%eax)
  802919:	8b 45 08             	mov    0x8(%ebp),%eax
  80291c:	8b 00                	mov    (%eax),%eax
  80291e:	85 c0                	test   %eax,%eax
  802920:	75 08                	jne    80292a <insert_sorted_allocList+0x244>
  802922:	8b 45 08             	mov    0x8(%ebp),%eax
  802925:	a3 44 50 80 00       	mov    %eax,0x805044
  80292a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80292f:	40                   	inc    %eax
  802930:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802935:	eb 39                	jmp    802970 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802937:	a1 48 50 80 00       	mov    0x805048,%eax
  80293c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80293f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802943:	74 07                	je     80294c <insert_sorted_allocList+0x266>
  802945:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802948:	8b 00                	mov    (%eax),%eax
  80294a:	eb 05                	jmp    802951 <insert_sorted_allocList+0x26b>
  80294c:	b8 00 00 00 00       	mov    $0x0,%eax
  802951:	a3 48 50 80 00       	mov    %eax,0x805048
  802956:	a1 48 50 80 00       	mov    0x805048,%eax
  80295b:	85 c0                	test   %eax,%eax
  80295d:	0f 85 3f ff ff ff    	jne    8028a2 <insert_sorted_allocList+0x1bc>
  802963:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802967:	0f 85 35 ff ff ff    	jne    8028a2 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80296d:	eb 01                	jmp    802970 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80296f:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802970:	90                   	nop
  802971:	c9                   	leave  
  802972:	c3                   	ret    

00802973 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802973:	55                   	push   %ebp
  802974:	89 e5                	mov    %esp,%ebp
  802976:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802979:	a1 38 51 80 00       	mov    0x805138,%eax
  80297e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802981:	e9 85 01 00 00       	jmp    802b0b <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802986:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802989:	8b 40 0c             	mov    0xc(%eax),%eax
  80298c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80298f:	0f 82 6e 01 00 00    	jb     802b03 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802995:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802998:	8b 40 0c             	mov    0xc(%eax),%eax
  80299b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80299e:	0f 85 8a 00 00 00    	jne    802a2e <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8029a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029a8:	75 17                	jne    8029c1 <alloc_block_FF+0x4e>
  8029aa:	83 ec 04             	sub    $0x4,%esp
  8029ad:	68 fc 46 80 00       	push   $0x8046fc
  8029b2:	68 93 00 00 00       	push   $0x93
  8029b7:	68 53 46 80 00       	push   $0x804653
  8029bc:	e8 d0 dd ff ff       	call   800791 <_panic>
  8029c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c4:	8b 00                	mov    (%eax),%eax
  8029c6:	85 c0                	test   %eax,%eax
  8029c8:	74 10                	je     8029da <alloc_block_FF+0x67>
  8029ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cd:	8b 00                	mov    (%eax),%eax
  8029cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029d2:	8b 52 04             	mov    0x4(%edx),%edx
  8029d5:	89 50 04             	mov    %edx,0x4(%eax)
  8029d8:	eb 0b                	jmp    8029e5 <alloc_block_FF+0x72>
  8029da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029dd:	8b 40 04             	mov    0x4(%eax),%eax
  8029e0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8029e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e8:	8b 40 04             	mov    0x4(%eax),%eax
  8029eb:	85 c0                	test   %eax,%eax
  8029ed:	74 0f                	je     8029fe <alloc_block_FF+0x8b>
  8029ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f2:	8b 40 04             	mov    0x4(%eax),%eax
  8029f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029f8:	8b 12                	mov    (%edx),%edx
  8029fa:	89 10                	mov    %edx,(%eax)
  8029fc:	eb 0a                	jmp    802a08 <alloc_block_FF+0x95>
  8029fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a01:	8b 00                	mov    (%eax),%eax
  802a03:	a3 38 51 80 00       	mov    %eax,0x805138
  802a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a14:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a1b:	a1 44 51 80 00       	mov    0x805144,%eax
  802a20:	48                   	dec    %eax
  802a21:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802a26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a29:	e9 10 01 00 00       	jmp    802b3e <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802a2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a31:	8b 40 0c             	mov    0xc(%eax),%eax
  802a34:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a37:	0f 86 c6 00 00 00    	jbe    802b03 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a3d:	a1 48 51 80 00       	mov    0x805148,%eax
  802a42:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a48:	8b 50 08             	mov    0x8(%eax),%edx
  802a4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a4e:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802a51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a54:	8b 55 08             	mov    0x8(%ebp),%edx
  802a57:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802a5a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a5e:	75 17                	jne    802a77 <alloc_block_FF+0x104>
  802a60:	83 ec 04             	sub    $0x4,%esp
  802a63:	68 fc 46 80 00       	push   $0x8046fc
  802a68:	68 9b 00 00 00       	push   $0x9b
  802a6d:	68 53 46 80 00       	push   $0x804653
  802a72:	e8 1a dd ff ff       	call   800791 <_panic>
  802a77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a7a:	8b 00                	mov    (%eax),%eax
  802a7c:	85 c0                	test   %eax,%eax
  802a7e:	74 10                	je     802a90 <alloc_block_FF+0x11d>
  802a80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a83:	8b 00                	mov    (%eax),%eax
  802a85:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a88:	8b 52 04             	mov    0x4(%edx),%edx
  802a8b:	89 50 04             	mov    %edx,0x4(%eax)
  802a8e:	eb 0b                	jmp    802a9b <alloc_block_FF+0x128>
  802a90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a93:	8b 40 04             	mov    0x4(%eax),%eax
  802a96:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a9e:	8b 40 04             	mov    0x4(%eax),%eax
  802aa1:	85 c0                	test   %eax,%eax
  802aa3:	74 0f                	je     802ab4 <alloc_block_FF+0x141>
  802aa5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa8:	8b 40 04             	mov    0x4(%eax),%eax
  802aab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802aae:	8b 12                	mov    (%edx),%edx
  802ab0:	89 10                	mov    %edx,(%eax)
  802ab2:	eb 0a                	jmp    802abe <alloc_block_FF+0x14b>
  802ab4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab7:	8b 00                	mov    (%eax),%eax
  802ab9:	a3 48 51 80 00       	mov    %eax,0x805148
  802abe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ac7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ad1:	a1 54 51 80 00       	mov    0x805154,%eax
  802ad6:	48                   	dec    %eax
  802ad7:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802adc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adf:	8b 50 08             	mov    0x8(%eax),%edx
  802ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae5:	01 c2                	add    %eax,%edx
  802ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aea:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af0:	8b 40 0c             	mov    0xc(%eax),%eax
  802af3:	2b 45 08             	sub    0x8(%ebp),%eax
  802af6:	89 c2                	mov    %eax,%edx
  802af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afb:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802afe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b01:	eb 3b                	jmp    802b3e <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802b03:	a1 40 51 80 00       	mov    0x805140,%eax
  802b08:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b0b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b0f:	74 07                	je     802b18 <alloc_block_FF+0x1a5>
  802b11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b14:	8b 00                	mov    (%eax),%eax
  802b16:	eb 05                	jmp    802b1d <alloc_block_FF+0x1aa>
  802b18:	b8 00 00 00 00       	mov    $0x0,%eax
  802b1d:	a3 40 51 80 00       	mov    %eax,0x805140
  802b22:	a1 40 51 80 00       	mov    0x805140,%eax
  802b27:	85 c0                	test   %eax,%eax
  802b29:	0f 85 57 fe ff ff    	jne    802986 <alloc_block_FF+0x13>
  802b2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b33:	0f 85 4d fe ff ff    	jne    802986 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802b39:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b3e:	c9                   	leave  
  802b3f:	c3                   	ret    

00802b40 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802b40:	55                   	push   %ebp
  802b41:	89 e5                	mov    %esp,%ebp
  802b43:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802b46:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802b4d:	a1 38 51 80 00       	mov    0x805138,%eax
  802b52:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b55:	e9 df 00 00 00       	jmp    802c39 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5d:	8b 40 0c             	mov    0xc(%eax),%eax
  802b60:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b63:	0f 82 c8 00 00 00    	jb     802c31 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6c:	8b 40 0c             	mov    0xc(%eax),%eax
  802b6f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b72:	0f 85 8a 00 00 00    	jne    802c02 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802b78:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b7c:	75 17                	jne    802b95 <alloc_block_BF+0x55>
  802b7e:	83 ec 04             	sub    $0x4,%esp
  802b81:	68 fc 46 80 00       	push   $0x8046fc
  802b86:	68 b7 00 00 00       	push   $0xb7
  802b8b:	68 53 46 80 00       	push   $0x804653
  802b90:	e8 fc db ff ff       	call   800791 <_panic>
  802b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b98:	8b 00                	mov    (%eax),%eax
  802b9a:	85 c0                	test   %eax,%eax
  802b9c:	74 10                	je     802bae <alloc_block_BF+0x6e>
  802b9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba1:	8b 00                	mov    (%eax),%eax
  802ba3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ba6:	8b 52 04             	mov    0x4(%edx),%edx
  802ba9:	89 50 04             	mov    %edx,0x4(%eax)
  802bac:	eb 0b                	jmp    802bb9 <alloc_block_BF+0x79>
  802bae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb1:	8b 40 04             	mov    0x4(%eax),%eax
  802bb4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802bb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbc:	8b 40 04             	mov    0x4(%eax),%eax
  802bbf:	85 c0                	test   %eax,%eax
  802bc1:	74 0f                	je     802bd2 <alloc_block_BF+0x92>
  802bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc6:	8b 40 04             	mov    0x4(%eax),%eax
  802bc9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bcc:	8b 12                	mov    (%edx),%edx
  802bce:	89 10                	mov    %edx,(%eax)
  802bd0:	eb 0a                	jmp    802bdc <alloc_block_BF+0x9c>
  802bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd5:	8b 00                	mov    (%eax),%eax
  802bd7:	a3 38 51 80 00       	mov    %eax,0x805138
  802bdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802be5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bef:	a1 44 51 80 00       	mov    0x805144,%eax
  802bf4:	48                   	dec    %eax
  802bf5:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfd:	e9 4d 01 00 00       	jmp    802d4f <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802c02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c05:	8b 40 0c             	mov    0xc(%eax),%eax
  802c08:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c0b:	76 24                	jbe    802c31 <alloc_block_BF+0xf1>
  802c0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c10:	8b 40 0c             	mov    0xc(%eax),%eax
  802c13:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802c16:	73 19                	jae    802c31 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802c18:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c22:	8b 40 0c             	mov    0xc(%eax),%eax
  802c25:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2b:	8b 40 08             	mov    0x8(%eax),%eax
  802c2e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802c31:	a1 40 51 80 00       	mov    0x805140,%eax
  802c36:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c39:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c3d:	74 07                	je     802c46 <alloc_block_BF+0x106>
  802c3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c42:	8b 00                	mov    (%eax),%eax
  802c44:	eb 05                	jmp    802c4b <alloc_block_BF+0x10b>
  802c46:	b8 00 00 00 00       	mov    $0x0,%eax
  802c4b:	a3 40 51 80 00       	mov    %eax,0x805140
  802c50:	a1 40 51 80 00       	mov    0x805140,%eax
  802c55:	85 c0                	test   %eax,%eax
  802c57:	0f 85 fd fe ff ff    	jne    802b5a <alloc_block_BF+0x1a>
  802c5d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c61:	0f 85 f3 fe ff ff    	jne    802b5a <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802c67:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802c6b:	0f 84 d9 00 00 00    	je     802d4a <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802c71:	a1 48 51 80 00       	mov    0x805148,%eax
  802c76:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802c79:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c7c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c7f:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802c82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c85:	8b 55 08             	mov    0x8(%ebp),%edx
  802c88:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802c8b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802c8f:	75 17                	jne    802ca8 <alloc_block_BF+0x168>
  802c91:	83 ec 04             	sub    $0x4,%esp
  802c94:	68 fc 46 80 00       	push   $0x8046fc
  802c99:	68 c7 00 00 00       	push   $0xc7
  802c9e:	68 53 46 80 00       	push   $0x804653
  802ca3:	e8 e9 da ff ff       	call   800791 <_panic>
  802ca8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cab:	8b 00                	mov    (%eax),%eax
  802cad:	85 c0                	test   %eax,%eax
  802caf:	74 10                	je     802cc1 <alloc_block_BF+0x181>
  802cb1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cb4:	8b 00                	mov    (%eax),%eax
  802cb6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802cb9:	8b 52 04             	mov    0x4(%edx),%edx
  802cbc:	89 50 04             	mov    %edx,0x4(%eax)
  802cbf:	eb 0b                	jmp    802ccc <alloc_block_BF+0x18c>
  802cc1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cc4:	8b 40 04             	mov    0x4(%eax),%eax
  802cc7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ccc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ccf:	8b 40 04             	mov    0x4(%eax),%eax
  802cd2:	85 c0                	test   %eax,%eax
  802cd4:	74 0f                	je     802ce5 <alloc_block_BF+0x1a5>
  802cd6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cd9:	8b 40 04             	mov    0x4(%eax),%eax
  802cdc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802cdf:	8b 12                	mov    (%edx),%edx
  802ce1:	89 10                	mov    %edx,(%eax)
  802ce3:	eb 0a                	jmp    802cef <alloc_block_BF+0x1af>
  802ce5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ce8:	8b 00                	mov    (%eax),%eax
  802cea:	a3 48 51 80 00       	mov    %eax,0x805148
  802cef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cf2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cf8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cfb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d02:	a1 54 51 80 00       	mov    0x805154,%eax
  802d07:	48                   	dec    %eax
  802d08:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802d0d:	83 ec 08             	sub    $0x8,%esp
  802d10:	ff 75 ec             	pushl  -0x14(%ebp)
  802d13:	68 38 51 80 00       	push   $0x805138
  802d18:	e8 71 f9 ff ff       	call   80268e <find_block>
  802d1d:	83 c4 10             	add    $0x10,%esp
  802d20:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802d23:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d26:	8b 50 08             	mov    0x8(%eax),%edx
  802d29:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2c:	01 c2                	add    %eax,%edx
  802d2e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d31:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802d34:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d37:	8b 40 0c             	mov    0xc(%eax),%eax
  802d3a:	2b 45 08             	sub    0x8(%ebp),%eax
  802d3d:	89 c2                	mov    %eax,%edx
  802d3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d42:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802d45:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d48:	eb 05                	jmp    802d4f <alloc_block_BF+0x20f>
	}
	return NULL;
  802d4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d4f:	c9                   	leave  
  802d50:	c3                   	ret    

00802d51 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802d51:	55                   	push   %ebp
  802d52:	89 e5                	mov    %esp,%ebp
  802d54:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802d57:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802d5c:	85 c0                	test   %eax,%eax
  802d5e:	0f 85 de 01 00 00    	jne    802f42 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802d64:	a1 38 51 80 00       	mov    0x805138,%eax
  802d69:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d6c:	e9 9e 01 00 00       	jmp    802f0f <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802d71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d74:	8b 40 0c             	mov    0xc(%eax),%eax
  802d77:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d7a:	0f 82 87 01 00 00    	jb     802f07 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d83:	8b 40 0c             	mov    0xc(%eax),%eax
  802d86:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d89:	0f 85 95 00 00 00    	jne    802e24 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802d8f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d93:	75 17                	jne    802dac <alloc_block_NF+0x5b>
  802d95:	83 ec 04             	sub    $0x4,%esp
  802d98:	68 fc 46 80 00       	push   $0x8046fc
  802d9d:	68 e0 00 00 00       	push   $0xe0
  802da2:	68 53 46 80 00       	push   $0x804653
  802da7:	e8 e5 d9 ff ff       	call   800791 <_panic>
  802dac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802daf:	8b 00                	mov    (%eax),%eax
  802db1:	85 c0                	test   %eax,%eax
  802db3:	74 10                	je     802dc5 <alloc_block_NF+0x74>
  802db5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db8:	8b 00                	mov    (%eax),%eax
  802dba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dbd:	8b 52 04             	mov    0x4(%edx),%edx
  802dc0:	89 50 04             	mov    %edx,0x4(%eax)
  802dc3:	eb 0b                	jmp    802dd0 <alloc_block_NF+0x7f>
  802dc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc8:	8b 40 04             	mov    0x4(%eax),%eax
  802dcb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802dd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd3:	8b 40 04             	mov    0x4(%eax),%eax
  802dd6:	85 c0                	test   %eax,%eax
  802dd8:	74 0f                	je     802de9 <alloc_block_NF+0x98>
  802dda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddd:	8b 40 04             	mov    0x4(%eax),%eax
  802de0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802de3:	8b 12                	mov    (%edx),%edx
  802de5:	89 10                	mov    %edx,(%eax)
  802de7:	eb 0a                	jmp    802df3 <alloc_block_NF+0xa2>
  802de9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dec:	8b 00                	mov    (%eax),%eax
  802dee:	a3 38 51 80 00       	mov    %eax,0x805138
  802df3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e06:	a1 44 51 80 00       	mov    0x805144,%eax
  802e0b:	48                   	dec    %eax
  802e0c:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802e11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e14:	8b 40 08             	mov    0x8(%eax),%eax
  802e17:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   return  point;
  802e1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1f:	e9 f8 04 00 00       	jmp    80331c <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802e24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e27:	8b 40 0c             	mov    0xc(%eax),%eax
  802e2a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e2d:	0f 86 d4 00 00 00    	jbe    802f07 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802e33:	a1 48 51 80 00       	mov    0x805148,%eax
  802e38:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802e3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3e:	8b 50 08             	mov    0x8(%eax),%edx
  802e41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e44:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802e47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e4a:	8b 55 08             	mov    0x8(%ebp),%edx
  802e4d:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802e50:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e54:	75 17                	jne    802e6d <alloc_block_NF+0x11c>
  802e56:	83 ec 04             	sub    $0x4,%esp
  802e59:	68 fc 46 80 00       	push   $0x8046fc
  802e5e:	68 e9 00 00 00       	push   $0xe9
  802e63:	68 53 46 80 00       	push   $0x804653
  802e68:	e8 24 d9 ff ff       	call   800791 <_panic>
  802e6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e70:	8b 00                	mov    (%eax),%eax
  802e72:	85 c0                	test   %eax,%eax
  802e74:	74 10                	je     802e86 <alloc_block_NF+0x135>
  802e76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e79:	8b 00                	mov    (%eax),%eax
  802e7b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e7e:	8b 52 04             	mov    0x4(%edx),%edx
  802e81:	89 50 04             	mov    %edx,0x4(%eax)
  802e84:	eb 0b                	jmp    802e91 <alloc_block_NF+0x140>
  802e86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e89:	8b 40 04             	mov    0x4(%eax),%eax
  802e8c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e94:	8b 40 04             	mov    0x4(%eax),%eax
  802e97:	85 c0                	test   %eax,%eax
  802e99:	74 0f                	je     802eaa <alloc_block_NF+0x159>
  802e9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e9e:	8b 40 04             	mov    0x4(%eax),%eax
  802ea1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ea4:	8b 12                	mov    (%edx),%edx
  802ea6:	89 10                	mov    %edx,(%eax)
  802ea8:	eb 0a                	jmp    802eb4 <alloc_block_NF+0x163>
  802eaa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ead:	8b 00                	mov    (%eax),%eax
  802eaf:	a3 48 51 80 00       	mov    %eax,0x805148
  802eb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ebd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ec7:	a1 54 51 80 00       	mov    0x805154,%eax
  802ecc:	48                   	dec    %eax
  802ecd:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802ed2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed5:	8b 40 08             	mov    0x8(%eax),%eax
  802ed8:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   point->sva += size;
  802edd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee0:	8b 50 08             	mov    0x8(%eax),%edx
  802ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee6:	01 c2                	add    %eax,%edx
  802ee8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eeb:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ef4:	2b 45 08             	sub    0x8(%ebp),%eax
  802ef7:	89 c2                	mov    %eax,%edx
  802ef9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efc:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802eff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f02:	e9 15 04 00 00       	jmp    80331c <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802f07:	a1 40 51 80 00       	mov    0x805140,%eax
  802f0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f0f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f13:	74 07                	je     802f1c <alloc_block_NF+0x1cb>
  802f15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f18:	8b 00                	mov    (%eax),%eax
  802f1a:	eb 05                	jmp    802f21 <alloc_block_NF+0x1d0>
  802f1c:	b8 00 00 00 00       	mov    $0x0,%eax
  802f21:	a3 40 51 80 00       	mov    %eax,0x805140
  802f26:	a1 40 51 80 00       	mov    0x805140,%eax
  802f2b:	85 c0                	test   %eax,%eax
  802f2d:	0f 85 3e fe ff ff    	jne    802d71 <alloc_block_NF+0x20>
  802f33:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f37:	0f 85 34 fe ff ff    	jne    802d71 <alloc_block_NF+0x20>
  802f3d:	e9 d5 03 00 00       	jmp    803317 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802f42:	a1 38 51 80 00       	mov    0x805138,%eax
  802f47:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f4a:	e9 b1 01 00 00       	jmp    803100 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802f4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f52:	8b 50 08             	mov    0x8(%eax),%edx
  802f55:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802f5a:	39 c2                	cmp    %eax,%edx
  802f5c:	0f 82 96 01 00 00    	jb     8030f8 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802f62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f65:	8b 40 0c             	mov    0xc(%eax),%eax
  802f68:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f6b:	0f 82 87 01 00 00    	jb     8030f8 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802f71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f74:	8b 40 0c             	mov    0xc(%eax),%eax
  802f77:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f7a:	0f 85 95 00 00 00    	jne    803015 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802f80:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f84:	75 17                	jne    802f9d <alloc_block_NF+0x24c>
  802f86:	83 ec 04             	sub    $0x4,%esp
  802f89:	68 fc 46 80 00       	push   $0x8046fc
  802f8e:	68 fc 00 00 00       	push   $0xfc
  802f93:	68 53 46 80 00       	push   $0x804653
  802f98:	e8 f4 d7 ff ff       	call   800791 <_panic>
  802f9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa0:	8b 00                	mov    (%eax),%eax
  802fa2:	85 c0                	test   %eax,%eax
  802fa4:	74 10                	je     802fb6 <alloc_block_NF+0x265>
  802fa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa9:	8b 00                	mov    (%eax),%eax
  802fab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fae:	8b 52 04             	mov    0x4(%edx),%edx
  802fb1:	89 50 04             	mov    %edx,0x4(%eax)
  802fb4:	eb 0b                	jmp    802fc1 <alloc_block_NF+0x270>
  802fb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb9:	8b 40 04             	mov    0x4(%eax),%eax
  802fbc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc4:	8b 40 04             	mov    0x4(%eax),%eax
  802fc7:	85 c0                	test   %eax,%eax
  802fc9:	74 0f                	je     802fda <alloc_block_NF+0x289>
  802fcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fce:	8b 40 04             	mov    0x4(%eax),%eax
  802fd1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fd4:	8b 12                	mov    (%edx),%edx
  802fd6:	89 10                	mov    %edx,(%eax)
  802fd8:	eb 0a                	jmp    802fe4 <alloc_block_NF+0x293>
  802fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fdd:	8b 00                	mov    (%eax),%eax
  802fdf:	a3 38 51 80 00       	mov    %eax,0x805138
  802fe4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ff7:	a1 44 51 80 00       	mov    0x805144,%eax
  802ffc:	48                   	dec    %eax
  802ffd:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803002:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803005:	8b 40 08             	mov    0x8(%eax),%eax
  803008:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  80300d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803010:	e9 07 03 00 00       	jmp    80331c <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803015:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803018:	8b 40 0c             	mov    0xc(%eax),%eax
  80301b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80301e:	0f 86 d4 00 00 00    	jbe    8030f8 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803024:	a1 48 51 80 00       	mov    0x805148,%eax
  803029:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  80302c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302f:	8b 50 08             	mov    0x8(%eax),%edx
  803032:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803035:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803038:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80303b:	8b 55 08             	mov    0x8(%ebp),%edx
  80303e:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803041:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803045:	75 17                	jne    80305e <alloc_block_NF+0x30d>
  803047:	83 ec 04             	sub    $0x4,%esp
  80304a:	68 fc 46 80 00       	push   $0x8046fc
  80304f:	68 04 01 00 00       	push   $0x104
  803054:	68 53 46 80 00       	push   $0x804653
  803059:	e8 33 d7 ff ff       	call   800791 <_panic>
  80305e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803061:	8b 00                	mov    (%eax),%eax
  803063:	85 c0                	test   %eax,%eax
  803065:	74 10                	je     803077 <alloc_block_NF+0x326>
  803067:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80306a:	8b 00                	mov    (%eax),%eax
  80306c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80306f:	8b 52 04             	mov    0x4(%edx),%edx
  803072:	89 50 04             	mov    %edx,0x4(%eax)
  803075:	eb 0b                	jmp    803082 <alloc_block_NF+0x331>
  803077:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80307a:	8b 40 04             	mov    0x4(%eax),%eax
  80307d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803082:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803085:	8b 40 04             	mov    0x4(%eax),%eax
  803088:	85 c0                	test   %eax,%eax
  80308a:	74 0f                	je     80309b <alloc_block_NF+0x34a>
  80308c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80308f:	8b 40 04             	mov    0x4(%eax),%eax
  803092:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803095:	8b 12                	mov    (%edx),%edx
  803097:	89 10                	mov    %edx,(%eax)
  803099:	eb 0a                	jmp    8030a5 <alloc_block_NF+0x354>
  80309b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80309e:	8b 00                	mov    (%eax),%eax
  8030a0:	a3 48 51 80 00       	mov    %eax,0x805148
  8030a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030b8:	a1 54 51 80 00       	mov    0x805154,%eax
  8030bd:	48                   	dec    %eax
  8030be:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8030c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c6:	8b 40 08             	mov    0x8(%eax),%eax
  8030c9:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  8030ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d1:	8b 50 08             	mov    0x8(%eax),%edx
  8030d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d7:	01 c2                	add    %eax,%edx
  8030d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030dc:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8030df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8030e5:	2b 45 08             	sub    0x8(%ebp),%eax
  8030e8:	89 c2                	mov    %eax,%edx
  8030ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ed:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8030f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f3:	e9 24 02 00 00       	jmp    80331c <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8030f8:	a1 40 51 80 00       	mov    0x805140,%eax
  8030fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803100:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803104:	74 07                	je     80310d <alloc_block_NF+0x3bc>
  803106:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803109:	8b 00                	mov    (%eax),%eax
  80310b:	eb 05                	jmp    803112 <alloc_block_NF+0x3c1>
  80310d:	b8 00 00 00 00       	mov    $0x0,%eax
  803112:	a3 40 51 80 00       	mov    %eax,0x805140
  803117:	a1 40 51 80 00       	mov    0x805140,%eax
  80311c:	85 c0                	test   %eax,%eax
  80311e:	0f 85 2b fe ff ff    	jne    802f4f <alloc_block_NF+0x1fe>
  803124:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803128:	0f 85 21 fe ff ff    	jne    802f4f <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  80312e:	a1 38 51 80 00       	mov    0x805138,%eax
  803133:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803136:	e9 ae 01 00 00       	jmp    8032e9 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  80313b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313e:	8b 50 08             	mov    0x8(%eax),%edx
  803141:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803146:	39 c2                	cmp    %eax,%edx
  803148:	0f 83 93 01 00 00    	jae    8032e1 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  80314e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803151:	8b 40 0c             	mov    0xc(%eax),%eax
  803154:	3b 45 08             	cmp    0x8(%ebp),%eax
  803157:	0f 82 84 01 00 00    	jb     8032e1 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  80315d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803160:	8b 40 0c             	mov    0xc(%eax),%eax
  803163:	3b 45 08             	cmp    0x8(%ebp),%eax
  803166:	0f 85 95 00 00 00    	jne    803201 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80316c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803170:	75 17                	jne    803189 <alloc_block_NF+0x438>
  803172:	83 ec 04             	sub    $0x4,%esp
  803175:	68 fc 46 80 00       	push   $0x8046fc
  80317a:	68 14 01 00 00       	push   $0x114
  80317f:	68 53 46 80 00       	push   $0x804653
  803184:	e8 08 d6 ff ff       	call   800791 <_panic>
  803189:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318c:	8b 00                	mov    (%eax),%eax
  80318e:	85 c0                	test   %eax,%eax
  803190:	74 10                	je     8031a2 <alloc_block_NF+0x451>
  803192:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803195:	8b 00                	mov    (%eax),%eax
  803197:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80319a:	8b 52 04             	mov    0x4(%edx),%edx
  80319d:	89 50 04             	mov    %edx,0x4(%eax)
  8031a0:	eb 0b                	jmp    8031ad <alloc_block_NF+0x45c>
  8031a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a5:	8b 40 04             	mov    0x4(%eax),%eax
  8031a8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b0:	8b 40 04             	mov    0x4(%eax),%eax
  8031b3:	85 c0                	test   %eax,%eax
  8031b5:	74 0f                	je     8031c6 <alloc_block_NF+0x475>
  8031b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ba:	8b 40 04             	mov    0x4(%eax),%eax
  8031bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031c0:	8b 12                	mov    (%edx),%edx
  8031c2:	89 10                	mov    %edx,(%eax)
  8031c4:	eb 0a                	jmp    8031d0 <alloc_block_NF+0x47f>
  8031c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c9:	8b 00                	mov    (%eax),%eax
  8031cb:	a3 38 51 80 00       	mov    %eax,0x805138
  8031d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031dc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031e3:	a1 44 51 80 00       	mov    0x805144,%eax
  8031e8:	48                   	dec    %eax
  8031e9:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8031ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f1:	8b 40 08             	mov    0x8(%eax),%eax
  8031f4:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  8031f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031fc:	e9 1b 01 00 00       	jmp    80331c <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803201:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803204:	8b 40 0c             	mov    0xc(%eax),%eax
  803207:	3b 45 08             	cmp    0x8(%ebp),%eax
  80320a:	0f 86 d1 00 00 00    	jbe    8032e1 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803210:	a1 48 51 80 00       	mov    0x805148,%eax
  803215:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  803218:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80321b:	8b 50 08             	mov    0x8(%eax),%edx
  80321e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803221:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803224:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803227:	8b 55 08             	mov    0x8(%ebp),%edx
  80322a:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80322d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803231:	75 17                	jne    80324a <alloc_block_NF+0x4f9>
  803233:	83 ec 04             	sub    $0x4,%esp
  803236:	68 fc 46 80 00       	push   $0x8046fc
  80323b:	68 1c 01 00 00       	push   $0x11c
  803240:	68 53 46 80 00       	push   $0x804653
  803245:	e8 47 d5 ff ff       	call   800791 <_panic>
  80324a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80324d:	8b 00                	mov    (%eax),%eax
  80324f:	85 c0                	test   %eax,%eax
  803251:	74 10                	je     803263 <alloc_block_NF+0x512>
  803253:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803256:	8b 00                	mov    (%eax),%eax
  803258:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80325b:	8b 52 04             	mov    0x4(%edx),%edx
  80325e:	89 50 04             	mov    %edx,0x4(%eax)
  803261:	eb 0b                	jmp    80326e <alloc_block_NF+0x51d>
  803263:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803266:	8b 40 04             	mov    0x4(%eax),%eax
  803269:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80326e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803271:	8b 40 04             	mov    0x4(%eax),%eax
  803274:	85 c0                	test   %eax,%eax
  803276:	74 0f                	je     803287 <alloc_block_NF+0x536>
  803278:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80327b:	8b 40 04             	mov    0x4(%eax),%eax
  80327e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803281:	8b 12                	mov    (%edx),%edx
  803283:	89 10                	mov    %edx,(%eax)
  803285:	eb 0a                	jmp    803291 <alloc_block_NF+0x540>
  803287:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80328a:	8b 00                	mov    (%eax),%eax
  80328c:	a3 48 51 80 00       	mov    %eax,0x805148
  803291:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803294:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80329a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80329d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032a4:	a1 54 51 80 00       	mov    0x805154,%eax
  8032a9:	48                   	dec    %eax
  8032aa:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8032af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032b2:	8b 40 08             	mov    0x8(%eax),%eax
  8032b5:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  8032ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032bd:	8b 50 08             	mov    0x8(%eax),%edx
  8032c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c3:	01 c2                	add    %eax,%edx
  8032c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c8:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8032cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8032d1:	2b 45 08             	sub    0x8(%ebp),%eax
  8032d4:	89 c2                	mov    %eax,%edx
  8032d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d9:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8032dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032df:	eb 3b                	jmp    80331c <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8032e1:	a1 40 51 80 00       	mov    0x805140,%eax
  8032e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032ed:	74 07                	je     8032f6 <alloc_block_NF+0x5a5>
  8032ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f2:	8b 00                	mov    (%eax),%eax
  8032f4:	eb 05                	jmp    8032fb <alloc_block_NF+0x5aa>
  8032f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8032fb:	a3 40 51 80 00       	mov    %eax,0x805140
  803300:	a1 40 51 80 00       	mov    0x805140,%eax
  803305:	85 c0                	test   %eax,%eax
  803307:	0f 85 2e fe ff ff    	jne    80313b <alloc_block_NF+0x3ea>
  80330d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803311:	0f 85 24 fe ff ff    	jne    80313b <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  803317:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80331c:	c9                   	leave  
  80331d:	c3                   	ret    

0080331e <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80331e:	55                   	push   %ebp
  80331f:	89 e5                	mov    %esp,%ebp
  803321:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  803324:	a1 38 51 80 00       	mov    0x805138,%eax
  803329:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  80332c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803331:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  803334:	a1 38 51 80 00       	mov    0x805138,%eax
  803339:	85 c0                	test   %eax,%eax
  80333b:	74 14                	je     803351 <insert_sorted_with_merge_freeList+0x33>
  80333d:	8b 45 08             	mov    0x8(%ebp),%eax
  803340:	8b 50 08             	mov    0x8(%eax),%edx
  803343:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803346:	8b 40 08             	mov    0x8(%eax),%eax
  803349:	39 c2                	cmp    %eax,%edx
  80334b:	0f 87 9b 01 00 00    	ja     8034ec <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  803351:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803355:	75 17                	jne    80336e <insert_sorted_with_merge_freeList+0x50>
  803357:	83 ec 04             	sub    $0x4,%esp
  80335a:	68 30 46 80 00       	push   $0x804630
  80335f:	68 38 01 00 00       	push   $0x138
  803364:	68 53 46 80 00       	push   $0x804653
  803369:	e8 23 d4 ff ff       	call   800791 <_panic>
  80336e:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803374:	8b 45 08             	mov    0x8(%ebp),%eax
  803377:	89 10                	mov    %edx,(%eax)
  803379:	8b 45 08             	mov    0x8(%ebp),%eax
  80337c:	8b 00                	mov    (%eax),%eax
  80337e:	85 c0                	test   %eax,%eax
  803380:	74 0d                	je     80338f <insert_sorted_with_merge_freeList+0x71>
  803382:	a1 38 51 80 00       	mov    0x805138,%eax
  803387:	8b 55 08             	mov    0x8(%ebp),%edx
  80338a:	89 50 04             	mov    %edx,0x4(%eax)
  80338d:	eb 08                	jmp    803397 <insert_sorted_with_merge_freeList+0x79>
  80338f:	8b 45 08             	mov    0x8(%ebp),%eax
  803392:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803397:	8b 45 08             	mov    0x8(%ebp),%eax
  80339a:	a3 38 51 80 00       	mov    %eax,0x805138
  80339f:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033a9:	a1 44 51 80 00       	mov    0x805144,%eax
  8033ae:	40                   	inc    %eax
  8033af:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8033b4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033b8:	0f 84 a8 06 00 00    	je     803a66 <insert_sorted_with_merge_freeList+0x748>
  8033be:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c1:	8b 50 08             	mov    0x8(%eax),%edx
  8033c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8033ca:	01 c2                	add    %eax,%edx
  8033cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033cf:	8b 40 08             	mov    0x8(%eax),%eax
  8033d2:	39 c2                	cmp    %eax,%edx
  8033d4:	0f 85 8c 06 00 00    	jne    803a66 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  8033da:	8b 45 08             	mov    0x8(%ebp),%eax
  8033dd:	8b 50 0c             	mov    0xc(%eax),%edx
  8033e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033e3:	8b 40 0c             	mov    0xc(%eax),%eax
  8033e6:	01 c2                	add    %eax,%edx
  8033e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8033eb:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  8033ee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033f2:	75 17                	jne    80340b <insert_sorted_with_merge_freeList+0xed>
  8033f4:	83 ec 04             	sub    $0x4,%esp
  8033f7:	68 fc 46 80 00       	push   $0x8046fc
  8033fc:	68 3c 01 00 00       	push   $0x13c
  803401:	68 53 46 80 00       	push   $0x804653
  803406:	e8 86 d3 ff ff       	call   800791 <_panic>
  80340b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80340e:	8b 00                	mov    (%eax),%eax
  803410:	85 c0                	test   %eax,%eax
  803412:	74 10                	je     803424 <insert_sorted_with_merge_freeList+0x106>
  803414:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803417:	8b 00                	mov    (%eax),%eax
  803419:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80341c:	8b 52 04             	mov    0x4(%edx),%edx
  80341f:	89 50 04             	mov    %edx,0x4(%eax)
  803422:	eb 0b                	jmp    80342f <insert_sorted_with_merge_freeList+0x111>
  803424:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803427:	8b 40 04             	mov    0x4(%eax),%eax
  80342a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80342f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803432:	8b 40 04             	mov    0x4(%eax),%eax
  803435:	85 c0                	test   %eax,%eax
  803437:	74 0f                	je     803448 <insert_sorted_with_merge_freeList+0x12a>
  803439:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80343c:	8b 40 04             	mov    0x4(%eax),%eax
  80343f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803442:	8b 12                	mov    (%edx),%edx
  803444:	89 10                	mov    %edx,(%eax)
  803446:	eb 0a                	jmp    803452 <insert_sorted_with_merge_freeList+0x134>
  803448:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80344b:	8b 00                	mov    (%eax),%eax
  80344d:	a3 38 51 80 00       	mov    %eax,0x805138
  803452:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803455:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80345b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80345e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803465:	a1 44 51 80 00       	mov    0x805144,%eax
  80346a:	48                   	dec    %eax
  80346b:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  803470:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803473:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  80347a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80347d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803484:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803488:	75 17                	jne    8034a1 <insert_sorted_with_merge_freeList+0x183>
  80348a:	83 ec 04             	sub    $0x4,%esp
  80348d:	68 30 46 80 00       	push   $0x804630
  803492:	68 3f 01 00 00       	push   $0x13f
  803497:	68 53 46 80 00       	push   $0x804653
  80349c:	e8 f0 d2 ff ff       	call   800791 <_panic>
  8034a1:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034aa:	89 10                	mov    %edx,(%eax)
  8034ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034af:	8b 00                	mov    (%eax),%eax
  8034b1:	85 c0                	test   %eax,%eax
  8034b3:	74 0d                	je     8034c2 <insert_sorted_with_merge_freeList+0x1a4>
  8034b5:	a1 48 51 80 00       	mov    0x805148,%eax
  8034ba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034bd:	89 50 04             	mov    %edx,0x4(%eax)
  8034c0:	eb 08                	jmp    8034ca <insert_sorted_with_merge_freeList+0x1ac>
  8034c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034c5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034cd:	a3 48 51 80 00       	mov    %eax,0x805148
  8034d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034d5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034dc:	a1 54 51 80 00       	mov    0x805154,%eax
  8034e1:	40                   	inc    %eax
  8034e2:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8034e7:	e9 7a 05 00 00       	jmp    803a66 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  8034ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ef:	8b 50 08             	mov    0x8(%eax),%edx
  8034f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034f5:	8b 40 08             	mov    0x8(%eax),%eax
  8034f8:	39 c2                	cmp    %eax,%edx
  8034fa:	0f 82 14 01 00 00    	jb     803614 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803500:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803503:	8b 50 08             	mov    0x8(%eax),%edx
  803506:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803509:	8b 40 0c             	mov    0xc(%eax),%eax
  80350c:	01 c2                	add    %eax,%edx
  80350e:	8b 45 08             	mov    0x8(%ebp),%eax
  803511:	8b 40 08             	mov    0x8(%eax),%eax
  803514:	39 c2                	cmp    %eax,%edx
  803516:	0f 85 90 00 00 00    	jne    8035ac <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  80351c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80351f:	8b 50 0c             	mov    0xc(%eax),%edx
  803522:	8b 45 08             	mov    0x8(%ebp),%eax
  803525:	8b 40 0c             	mov    0xc(%eax),%eax
  803528:	01 c2                	add    %eax,%edx
  80352a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80352d:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803530:	8b 45 08             	mov    0x8(%ebp),%eax
  803533:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  80353a:	8b 45 08             	mov    0x8(%ebp),%eax
  80353d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803544:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803548:	75 17                	jne    803561 <insert_sorted_with_merge_freeList+0x243>
  80354a:	83 ec 04             	sub    $0x4,%esp
  80354d:	68 30 46 80 00       	push   $0x804630
  803552:	68 49 01 00 00       	push   $0x149
  803557:	68 53 46 80 00       	push   $0x804653
  80355c:	e8 30 d2 ff ff       	call   800791 <_panic>
  803561:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803567:	8b 45 08             	mov    0x8(%ebp),%eax
  80356a:	89 10                	mov    %edx,(%eax)
  80356c:	8b 45 08             	mov    0x8(%ebp),%eax
  80356f:	8b 00                	mov    (%eax),%eax
  803571:	85 c0                	test   %eax,%eax
  803573:	74 0d                	je     803582 <insert_sorted_with_merge_freeList+0x264>
  803575:	a1 48 51 80 00       	mov    0x805148,%eax
  80357a:	8b 55 08             	mov    0x8(%ebp),%edx
  80357d:	89 50 04             	mov    %edx,0x4(%eax)
  803580:	eb 08                	jmp    80358a <insert_sorted_with_merge_freeList+0x26c>
  803582:	8b 45 08             	mov    0x8(%ebp),%eax
  803585:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80358a:	8b 45 08             	mov    0x8(%ebp),%eax
  80358d:	a3 48 51 80 00       	mov    %eax,0x805148
  803592:	8b 45 08             	mov    0x8(%ebp),%eax
  803595:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80359c:	a1 54 51 80 00       	mov    0x805154,%eax
  8035a1:	40                   	inc    %eax
  8035a2:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8035a7:	e9 bb 04 00 00       	jmp    803a67 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8035ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035b0:	75 17                	jne    8035c9 <insert_sorted_with_merge_freeList+0x2ab>
  8035b2:	83 ec 04             	sub    $0x4,%esp
  8035b5:	68 a4 46 80 00       	push   $0x8046a4
  8035ba:	68 4c 01 00 00       	push   $0x14c
  8035bf:	68 53 46 80 00       	push   $0x804653
  8035c4:	e8 c8 d1 ff ff       	call   800791 <_panic>
  8035c9:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8035cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d2:	89 50 04             	mov    %edx,0x4(%eax)
  8035d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d8:	8b 40 04             	mov    0x4(%eax),%eax
  8035db:	85 c0                	test   %eax,%eax
  8035dd:	74 0c                	je     8035eb <insert_sorted_with_merge_freeList+0x2cd>
  8035df:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8035e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8035e7:	89 10                	mov    %edx,(%eax)
  8035e9:	eb 08                	jmp    8035f3 <insert_sorted_with_merge_freeList+0x2d5>
  8035eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ee:	a3 38 51 80 00       	mov    %eax,0x805138
  8035f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8035fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8035fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803604:	a1 44 51 80 00       	mov    0x805144,%eax
  803609:	40                   	inc    %eax
  80360a:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80360f:	e9 53 04 00 00       	jmp    803a67 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803614:	a1 38 51 80 00       	mov    0x805138,%eax
  803619:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80361c:	e9 15 04 00 00       	jmp    803a36 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803621:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803624:	8b 00                	mov    (%eax),%eax
  803626:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803629:	8b 45 08             	mov    0x8(%ebp),%eax
  80362c:	8b 50 08             	mov    0x8(%eax),%edx
  80362f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803632:	8b 40 08             	mov    0x8(%eax),%eax
  803635:	39 c2                	cmp    %eax,%edx
  803637:	0f 86 f1 03 00 00    	jbe    803a2e <insert_sorted_with_merge_freeList+0x710>
  80363d:	8b 45 08             	mov    0x8(%ebp),%eax
  803640:	8b 50 08             	mov    0x8(%eax),%edx
  803643:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803646:	8b 40 08             	mov    0x8(%eax),%eax
  803649:	39 c2                	cmp    %eax,%edx
  80364b:	0f 83 dd 03 00 00    	jae    803a2e <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803651:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803654:	8b 50 08             	mov    0x8(%eax),%edx
  803657:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80365a:	8b 40 0c             	mov    0xc(%eax),%eax
  80365d:	01 c2                	add    %eax,%edx
  80365f:	8b 45 08             	mov    0x8(%ebp),%eax
  803662:	8b 40 08             	mov    0x8(%eax),%eax
  803665:	39 c2                	cmp    %eax,%edx
  803667:	0f 85 b9 01 00 00    	jne    803826 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80366d:	8b 45 08             	mov    0x8(%ebp),%eax
  803670:	8b 50 08             	mov    0x8(%eax),%edx
  803673:	8b 45 08             	mov    0x8(%ebp),%eax
  803676:	8b 40 0c             	mov    0xc(%eax),%eax
  803679:	01 c2                	add    %eax,%edx
  80367b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80367e:	8b 40 08             	mov    0x8(%eax),%eax
  803681:	39 c2                	cmp    %eax,%edx
  803683:	0f 85 0d 01 00 00    	jne    803796 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803689:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80368c:	8b 50 0c             	mov    0xc(%eax),%edx
  80368f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803692:	8b 40 0c             	mov    0xc(%eax),%eax
  803695:	01 c2                	add    %eax,%edx
  803697:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80369a:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80369d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8036a1:	75 17                	jne    8036ba <insert_sorted_with_merge_freeList+0x39c>
  8036a3:	83 ec 04             	sub    $0x4,%esp
  8036a6:	68 fc 46 80 00       	push   $0x8046fc
  8036ab:	68 5c 01 00 00       	push   $0x15c
  8036b0:	68 53 46 80 00       	push   $0x804653
  8036b5:	e8 d7 d0 ff ff       	call   800791 <_panic>
  8036ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036bd:	8b 00                	mov    (%eax),%eax
  8036bf:	85 c0                	test   %eax,%eax
  8036c1:	74 10                	je     8036d3 <insert_sorted_with_merge_freeList+0x3b5>
  8036c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036c6:	8b 00                	mov    (%eax),%eax
  8036c8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036cb:	8b 52 04             	mov    0x4(%edx),%edx
  8036ce:	89 50 04             	mov    %edx,0x4(%eax)
  8036d1:	eb 0b                	jmp    8036de <insert_sorted_with_merge_freeList+0x3c0>
  8036d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036d6:	8b 40 04             	mov    0x4(%eax),%eax
  8036d9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8036de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036e1:	8b 40 04             	mov    0x4(%eax),%eax
  8036e4:	85 c0                	test   %eax,%eax
  8036e6:	74 0f                	je     8036f7 <insert_sorted_with_merge_freeList+0x3d9>
  8036e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036eb:	8b 40 04             	mov    0x4(%eax),%eax
  8036ee:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036f1:	8b 12                	mov    (%edx),%edx
  8036f3:	89 10                	mov    %edx,(%eax)
  8036f5:	eb 0a                	jmp    803701 <insert_sorted_with_merge_freeList+0x3e3>
  8036f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036fa:	8b 00                	mov    (%eax),%eax
  8036fc:	a3 38 51 80 00       	mov    %eax,0x805138
  803701:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803704:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80370a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80370d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803714:	a1 44 51 80 00       	mov    0x805144,%eax
  803719:	48                   	dec    %eax
  80371a:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  80371f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803722:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803729:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80372c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803733:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803737:	75 17                	jne    803750 <insert_sorted_with_merge_freeList+0x432>
  803739:	83 ec 04             	sub    $0x4,%esp
  80373c:	68 30 46 80 00       	push   $0x804630
  803741:	68 5f 01 00 00       	push   $0x15f
  803746:	68 53 46 80 00       	push   $0x804653
  80374b:	e8 41 d0 ff ff       	call   800791 <_panic>
  803750:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803756:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803759:	89 10                	mov    %edx,(%eax)
  80375b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80375e:	8b 00                	mov    (%eax),%eax
  803760:	85 c0                	test   %eax,%eax
  803762:	74 0d                	je     803771 <insert_sorted_with_merge_freeList+0x453>
  803764:	a1 48 51 80 00       	mov    0x805148,%eax
  803769:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80376c:	89 50 04             	mov    %edx,0x4(%eax)
  80376f:	eb 08                	jmp    803779 <insert_sorted_with_merge_freeList+0x45b>
  803771:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803774:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803779:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80377c:	a3 48 51 80 00       	mov    %eax,0x805148
  803781:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803784:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80378b:	a1 54 51 80 00       	mov    0x805154,%eax
  803790:	40                   	inc    %eax
  803791:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803796:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803799:	8b 50 0c             	mov    0xc(%eax),%edx
  80379c:	8b 45 08             	mov    0x8(%ebp),%eax
  80379f:	8b 40 0c             	mov    0xc(%eax),%eax
  8037a2:	01 c2                	add    %eax,%edx
  8037a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037a7:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8037aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ad:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8037b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8037be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037c2:	75 17                	jne    8037db <insert_sorted_with_merge_freeList+0x4bd>
  8037c4:	83 ec 04             	sub    $0x4,%esp
  8037c7:	68 30 46 80 00       	push   $0x804630
  8037cc:	68 64 01 00 00       	push   $0x164
  8037d1:	68 53 46 80 00       	push   $0x804653
  8037d6:	e8 b6 cf ff ff       	call   800791 <_panic>
  8037db:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8037e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e4:	89 10                	mov    %edx,(%eax)
  8037e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e9:	8b 00                	mov    (%eax),%eax
  8037eb:	85 c0                	test   %eax,%eax
  8037ed:	74 0d                	je     8037fc <insert_sorted_with_merge_freeList+0x4de>
  8037ef:	a1 48 51 80 00       	mov    0x805148,%eax
  8037f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8037f7:	89 50 04             	mov    %edx,0x4(%eax)
  8037fa:	eb 08                	jmp    803804 <insert_sorted_with_merge_freeList+0x4e6>
  8037fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ff:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803804:	8b 45 08             	mov    0x8(%ebp),%eax
  803807:	a3 48 51 80 00       	mov    %eax,0x805148
  80380c:	8b 45 08             	mov    0x8(%ebp),%eax
  80380f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803816:	a1 54 51 80 00       	mov    0x805154,%eax
  80381b:	40                   	inc    %eax
  80381c:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803821:	e9 41 02 00 00       	jmp    803a67 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803826:	8b 45 08             	mov    0x8(%ebp),%eax
  803829:	8b 50 08             	mov    0x8(%eax),%edx
  80382c:	8b 45 08             	mov    0x8(%ebp),%eax
  80382f:	8b 40 0c             	mov    0xc(%eax),%eax
  803832:	01 c2                	add    %eax,%edx
  803834:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803837:	8b 40 08             	mov    0x8(%eax),%eax
  80383a:	39 c2                	cmp    %eax,%edx
  80383c:	0f 85 7c 01 00 00    	jne    8039be <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803842:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803846:	74 06                	je     80384e <insert_sorted_with_merge_freeList+0x530>
  803848:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80384c:	75 17                	jne    803865 <insert_sorted_with_merge_freeList+0x547>
  80384e:	83 ec 04             	sub    $0x4,%esp
  803851:	68 6c 46 80 00       	push   $0x80466c
  803856:	68 69 01 00 00       	push   $0x169
  80385b:	68 53 46 80 00       	push   $0x804653
  803860:	e8 2c cf ff ff       	call   800791 <_panic>
  803865:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803868:	8b 50 04             	mov    0x4(%eax),%edx
  80386b:	8b 45 08             	mov    0x8(%ebp),%eax
  80386e:	89 50 04             	mov    %edx,0x4(%eax)
  803871:	8b 45 08             	mov    0x8(%ebp),%eax
  803874:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803877:	89 10                	mov    %edx,(%eax)
  803879:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80387c:	8b 40 04             	mov    0x4(%eax),%eax
  80387f:	85 c0                	test   %eax,%eax
  803881:	74 0d                	je     803890 <insert_sorted_with_merge_freeList+0x572>
  803883:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803886:	8b 40 04             	mov    0x4(%eax),%eax
  803889:	8b 55 08             	mov    0x8(%ebp),%edx
  80388c:	89 10                	mov    %edx,(%eax)
  80388e:	eb 08                	jmp    803898 <insert_sorted_with_merge_freeList+0x57a>
  803890:	8b 45 08             	mov    0x8(%ebp),%eax
  803893:	a3 38 51 80 00       	mov    %eax,0x805138
  803898:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80389b:	8b 55 08             	mov    0x8(%ebp),%edx
  80389e:	89 50 04             	mov    %edx,0x4(%eax)
  8038a1:	a1 44 51 80 00       	mov    0x805144,%eax
  8038a6:	40                   	inc    %eax
  8038a7:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8038ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8038af:	8b 50 0c             	mov    0xc(%eax),%edx
  8038b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8038b8:	01 c2                	add    %eax,%edx
  8038ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8038bd:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8038c0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8038c4:	75 17                	jne    8038dd <insert_sorted_with_merge_freeList+0x5bf>
  8038c6:	83 ec 04             	sub    $0x4,%esp
  8038c9:	68 fc 46 80 00       	push   $0x8046fc
  8038ce:	68 6b 01 00 00       	push   $0x16b
  8038d3:	68 53 46 80 00       	push   $0x804653
  8038d8:	e8 b4 ce ff ff       	call   800791 <_panic>
  8038dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038e0:	8b 00                	mov    (%eax),%eax
  8038e2:	85 c0                	test   %eax,%eax
  8038e4:	74 10                	je     8038f6 <insert_sorted_with_merge_freeList+0x5d8>
  8038e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038e9:	8b 00                	mov    (%eax),%eax
  8038eb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038ee:	8b 52 04             	mov    0x4(%edx),%edx
  8038f1:	89 50 04             	mov    %edx,0x4(%eax)
  8038f4:	eb 0b                	jmp    803901 <insert_sorted_with_merge_freeList+0x5e3>
  8038f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038f9:	8b 40 04             	mov    0x4(%eax),%eax
  8038fc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803901:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803904:	8b 40 04             	mov    0x4(%eax),%eax
  803907:	85 c0                	test   %eax,%eax
  803909:	74 0f                	je     80391a <insert_sorted_with_merge_freeList+0x5fc>
  80390b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80390e:	8b 40 04             	mov    0x4(%eax),%eax
  803911:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803914:	8b 12                	mov    (%edx),%edx
  803916:	89 10                	mov    %edx,(%eax)
  803918:	eb 0a                	jmp    803924 <insert_sorted_with_merge_freeList+0x606>
  80391a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80391d:	8b 00                	mov    (%eax),%eax
  80391f:	a3 38 51 80 00       	mov    %eax,0x805138
  803924:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803927:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80392d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803930:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803937:	a1 44 51 80 00       	mov    0x805144,%eax
  80393c:	48                   	dec    %eax
  80393d:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803942:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803945:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80394c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80394f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803956:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80395a:	75 17                	jne    803973 <insert_sorted_with_merge_freeList+0x655>
  80395c:	83 ec 04             	sub    $0x4,%esp
  80395f:	68 30 46 80 00       	push   $0x804630
  803964:	68 6e 01 00 00       	push   $0x16e
  803969:	68 53 46 80 00       	push   $0x804653
  80396e:	e8 1e ce ff ff       	call   800791 <_panic>
  803973:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803979:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80397c:	89 10                	mov    %edx,(%eax)
  80397e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803981:	8b 00                	mov    (%eax),%eax
  803983:	85 c0                	test   %eax,%eax
  803985:	74 0d                	je     803994 <insert_sorted_with_merge_freeList+0x676>
  803987:	a1 48 51 80 00       	mov    0x805148,%eax
  80398c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80398f:	89 50 04             	mov    %edx,0x4(%eax)
  803992:	eb 08                	jmp    80399c <insert_sorted_with_merge_freeList+0x67e>
  803994:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803997:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80399c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80399f:	a3 48 51 80 00       	mov    %eax,0x805148
  8039a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039a7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039ae:	a1 54 51 80 00       	mov    0x805154,%eax
  8039b3:	40                   	inc    %eax
  8039b4:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8039b9:	e9 a9 00 00 00       	jmp    803a67 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8039be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039c2:	74 06                	je     8039ca <insert_sorted_with_merge_freeList+0x6ac>
  8039c4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8039c8:	75 17                	jne    8039e1 <insert_sorted_with_merge_freeList+0x6c3>
  8039ca:	83 ec 04             	sub    $0x4,%esp
  8039cd:	68 c8 46 80 00       	push   $0x8046c8
  8039d2:	68 73 01 00 00       	push   $0x173
  8039d7:	68 53 46 80 00       	push   $0x804653
  8039dc:	e8 b0 cd ff ff       	call   800791 <_panic>
  8039e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039e4:	8b 10                	mov    (%eax),%edx
  8039e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8039e9:	89 10                	mov    %edx,(%eax)
  8039eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ee:	8b 00                	mov    (%eax),%eax
  8039f0:	85 c0                	test   %eax,%eax
  8039f2:	74 0b                	je     8039ff <insert_sorted_with_merge_freeList+0x6e1>
  8039f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039f7:	8b 00                	mov    (%eax),%eax
  8039f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8039fc:	89 50 04             	mov    %edx,0x4(%eax)
  8039ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a02:	8b 55 08             	mov    0x8(%ebp),%edx
  803a05:	89 10                	mov    %edx,(%eax)
  803a07:	8b 45 08             	mov    0x8(%ebp),%eax
  803a0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a0d:	89 50 04             	mov    %edx,0x4(%eax)
  803a10:	8b 45 08             	mov    0x8(%ebp),%eax
  803a13:	8b 00                	mov    (%eax),%eax
  803a15:	85 c0                	test   %eax,%eax
  803a17:	75 08                	jne    803a21 <insert_sorted_with_merge_freeList+0x703>
  803a19:	8b 45 08             	mov    0x8(%ebp),%eax
  803a1c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803a21:	a1 44 51 80 00       	mov    0x805144,%eax
  803a26:	40                   	inc    %eax
  803a27:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803a2c:	eb 39                	jmp    803a67 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803a2e:	a1 40 51 80 00       	mov    0x805140,%eax
  803a33:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a36:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a3a:	74 07                	je     803a43 <insert_sorted_with_merge_freeList+0x725>
  803a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a3f:	8b 00                	mov    (%eax),%eax
  803a41:	eb 05                	jmp    803a48 <insert_sorted_with_merge_freeList+0x72a>
  803a43:	b8 00 00 00 00       	mov    $0x0,%eax
  803a48:	a3 40 51 80 00       	mov    %eax,0x805140
  803a4d:	a1 40 51 80 00       	mov    0x805140,%eax
  803a52:	85 c0                	test   %eax,%eax
  803a54:	0f 85 c7 fb ff ff    	jne    803621 <insert_sorted_with_merge_freeList+0x303>
  803a5a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a5e:	0f 85 bd fb ff ff    	jne    803621 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803a64:	eb 01                	jmp    803a67 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803a66:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803a67:	90                   	nop
  803a68:	c9                   	leave  
  803a69:	c3                   	ret    
  803a6a:	66 90                	xchg   %ax,%ax

00803a6c <__udivdi3>:
  803a6c:	55                   	push   %ebp
  803a6d:	57                   	push   %edi
  803a6e:	56                   	push   %esi
  803a6f:	53                   	push   %ebx
  803a70:	83 ec 1c             	sub    $0x1c,%esp
  803a73:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803a77:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803a7b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a7f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803a83:	89 ca                	mov    %ecx,%edx
  803a85:	89 f8                	mov    %edi,%eax
  803a87:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803a8b:	85 f6                	test   %esi,%esi
  803a8d:	75 2d                	jne    803abc <__udivdi3+0x50>
  803a8f:	39 cf                	cmp    %ecx,%edi
  803a91:	77 65                	ja     803af8 <__udivdi3+0x8c>
  803a93:	89 fd                	mov    %edi,%ebp
  803a95:	85 ff                	test   %edi,%edi
  803a97:	75 0b                	jne    803aa4 <__udivdi3+0x38>
  803a99:	b8 01 00 00 00       	mov    $0x1,%eax
  803a9e:	31 d2                	xor    %edx,%edx
  803aa0:	f7 f7                	div    %edi
  803aa2:	89 c5                	mov    %eax,%ebp
  803aa4:	31 d2                	xor    %edx,%edx
  803aa6:	89 c8                	mov    %ecx,%eax
  803aa8:	f7 f5                	div    %ebp
  803aaa:	89 c1                	mov    %eax,%ecx
  803aac:	89 d8                	mov    %ebx,%eax
  803aae:	f7 f5                	div    %ebp
  803ab0:	89 cf                	mov    %ecx,%edi
  803ab2:	89 fa                	mov    %edi,%edx
  803ab4:	83 c4 1c             	add    $0x1c,%esp
  803ab7:	5b                   	pop    %ebx
  803ab8:	5e                   	pop    %esi
  803ab9:	5f                   	pop    %edi
  803aba:	5d                   	pop    %ebp
  803abb:	c3                   	ret    
  803abc:	39 ce                	cmp    %ecx,%esi
  803abe:	77 28                	ja     803ae8 <__udivdi3+0x7c>
  803ac0:	0f bd fe             	bsr    %esi,%edi
  803ac3:	83 f7 1f             	xor    $0x1f,%edi
  803ac6:	75 40                	jne    803b08 <__udivdi3+0x9c>
  803ac8:	39 ce                	cmp    %ecx,%esi
  803aca:	72 0a                	jb     803ad6 <__udivdi3+0x6a>
  803acc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803ad0:	0f 87 9e 00 00 00    	ja     803b74 <__udivdi3+0x108>
  803ad6:	b8 01 00 00 00       	mov    $0x1,%eax
  803adb:	89 fa                	mov    %edi,%edx
  803add:	83 c4 1c             	add    $0x1c,%esp
  803ae0:	5b                   	pop    %ebx
  803ae1:	5e                   	pop    %esi
  803ae2:	5f                   	pop    %edi
  803ae3:	5d                   	pop    %ebp
  803ae4:	c3                   	ret    
  803ae5:	8d 76 00             	lea    0x0(%esi),%esi
  803ae8:	31 ff                	xor    %edi,%edi
  803aea:	31 c0                	xor    %eax,%eax
  803aec:	89 fa                	mov    %edi,%edx
  803aee:	83 c4 1c             	add    $0x1c,%esp
  803af1:	5b                   	pop    %ebx
  803af2:	5e                   	pop    %esi
  803af3:	5f                   	pop    %edi
  803af4:	5d                   	pop    %ebp
  803af5:	c3                   	ret    
  803af6:	66 90                	xchg   %ax,%ax
  803af8:	89 d8                	mov    %ebx,%eax
  803afa:	f7 f7                	div    %edi
  803afc:	31 ff                	xor    %edi,%edi
  803afe:	89 fa                	mov    %edi,%edx
  803b00:	83 c4 1c             	add    $0x1c,%esp
  803b03:	5b                   	pop    %ebx
  803b04:	5e                   	pop    %esi
  803b05:	5f                   	pop    %edi
  803b06:	5d                   	pop    %ebp
  803b07:	c3                   	ret    
  803b08:	bd 20 00 00 00       	mov    $0x20,%ebp
  803b0d:	89 eb                	mov    %ebp,%ebx
  803b0f:	29 fb                	sub    %edi,%ebx
  803b11:	89 f9                	mov    %edi,%ecx
  803b13:	d3 e6                	shl    %cl,%esi
  803b15:	89 c5                	mov    %eax,%ebp
  803b17:	88 d9                	mov    %bl,%cl
  803b19:	d3 ed                	shr    %cl,%ebp
  803b1b:	89 e9                	mov    %ebp,%ecx
  803b1d:	09 f1                	or     %esi,%ecx
  803b1f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803b23:	89 f9                	mov    %edi,%ecx
  803b25:	d3 e0                	shl    %cl,%eax
  803b27:	89 c5                	mov    %eax,%ebp
  803b29:	89 d6                	mov    %edx,%esi
  803b2b:	88 d9                	mov    %bl,%cl
  803b2d:	d3 ee                	shr    %cl,%esi
  803b2f:	89 f9                	mov    %edi,%ecx
  803b31:	d3 e2                	shl    %cl,%edx
  803b33:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b37:	88 d9                	mov    %bl,%cl
  803b39:	d3 e8                	shr    %cl,%eax
  803b3b:	09 c2                	or     %eax,%edx
  803b3d:	89 d0                	mov    %edx,%eax
  803b3f:	89 f2                	mov    %esi,%edx
  803b41:	f7 74 24 0c          	divl   0xc(%esp)
  803b45:	89 d6                	mov    %edx,%esi
  803b47:	89 c3                	mov    %eax,%ebx
  803b49:	f7 e5                	mul    %ebp
  803b4b:	39 d6                	cmp    %edx,%esi
  803b4d:	72 19                	jb     803b68 <__udivdi3+0xfc>
  803b4f:	74 0b                	je     803b5c <__udivdi3+0xf0>
  803b51:	89 d8                	mov    %ebx,%eax
  803b53:	31 ff                	xor    %edi,%edi
  803b55:	e9 58 ff ff ff       	jmp    803ab2 <__udivdi3+0x46>
  803b5a:	66 90                	xchg   %ax,%ax
  803b5c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803b60:	89 f9                	mov    %edi,%ecx
  803b62:	d3 e2                	shl    %cl,%edx
  803b64:	39 c2                	cmp    %eax,%edx
  803b66:	73 e9                	jae    803b51 <__udivdi3+0xe5>
  803b68:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803b6b:	31 ff                	xor    %edi,%edi
  803b6d:	e9 40 ff ff ff       	jmp    803ab2 <__udivdi3+0x46>
  803b72:	66 90                	xchg   %ax,%ax
  803b74:	31 c0                	xor    %eax,%eax
  803b76:	e9 37 ff ff ff       	jmp    803ab2 <__udivdi3+0x46>
  803b7b:	90                   	nop

00803b7c <__umoddi3>:
  803b7c:	55                   	push   %ebp
  803b7d:	57                   	push   %edi
  803b7e:	56                   	push   %esi
  803b7f:	53                   	push   %ebx
  803b80:	83 ec 1c             	sub    $0x1c,%esp
  803b83:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803b87:	8b 74 24 34          	mov    0x34(%esp),%esi
  803b8b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b8f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803b93:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803b97:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803b9b:	89 f3                	mov    %esi,%ebx
  803b9d:	89 fa                	mov    %edi,%edx
  803b9f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ba3:	89 34 24             	mov    %esi,(%esp)
  803ba6:	85 c0                	test   %eax,%eax
  803ba8:	75 1a                	jne    803bc4 <__umoddi3+0x48>
  803baa:	39 f7                	cmp    %esi,%edi
  803bac:	0f 86 a2 00 00 00    	jbe    803c54 <__umoddi3+0xd8>
  803bb2:	89 c8                	mov    %ecx,%eax
  803bb4:	89 f2                	mov    %esi,%edx
  803bb6:	f7 f7                	div    %edi
  803bb8:	89 d0                	mov    %edx,%eax
  803bba:	31 d2                	xor    %edx,%edx
  803bbc:	83 c4 1c             	add    $0x1c,%esp
  803bbf:	5b                   	pop    %ebx
  803bc0:	5e                   	pop    %esi
  803bc1:	5f                   	pop    %edi
  803bc2:	5d                   	pop    %ebp
  803bc3:	c3                   	ret    
  803bc4:	39 f0                	cmp    %esi,%eax
  803bc6:	0f 87 ac 00 00 00    	ja     803c78 <__umoddi3+0xfc>
  803bcc:	0f bd e8             	bsr    %eax,%ebp
  803bcf:	83 f5 1f             	xor    $0x1f,%ebp
  803bd2:	0f 84 ac 00 00 00    	je     803c84 <__umoddi3+0x108>
  803bd8:	bf 20 00 00 00       	mov    $0x20,%edi
  803bdd:	29 ef                	sub    %ebp,%edi
  803bdf:	89 fe                	mov    %edi,%esi
  803be1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803be5:	89 e9                	mov    %ebp,%ecx
  803be7:	d3 e0                	shl    %cl,%eax
  803be9:	89 d7                	mov    %edx,%edi
  803beb:	89 f1                	mov    %esi,%ecx
  803bed:	d3 ef                	shr    %cl,%edi
  803bef:	09 c7                	or     %eax,%edi
  803bf1:	89 e9                	mov    %ebp,%ecx
  803bf3:	d3 e2                	shl    %cl,%edx
  803bf5:	89 14 24             	mov    %edx,(%esp)
  803bf8:	89 d8                	mov    %ebx,%eax
  803bfa:	d3 e0                	shl    %cl,%eax
  803bfc:	89 c2                	mov    %eax,%edx
  803bfe:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c02:	d3 e0                	shl    %cl,%eax
  803c04:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c08:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c0c:	89 f1                	mov    %esi,%ecx
  803c0e:	d3 e8                	shr    %cl,%eax
  803c10:	09 d0                	or     %edx,%eax
  803c12:	d3 eb                	shr    %cl,%ebx
  803c14:	89 da                	mov    %ebx,%edx
  803c16:	f7 f7                	div    %edi
  803c18:	89 d3                	mov    %edx,%ebx
  803c1a:	f7 24 24             	mull   (%esp)
  803c1d:	89 c6                	mov    %eax,%esi
  803c1f:	89 d1                	mov    %edx,%ecx
  803c21:	39 d3                	cmp    %edx,%ebx
  803c23:	0f 82 87 00 00 00    	jb     803cb0 <__umoddi3+0x134>
  803c29:	0f 84 91 00 00 00    	je     803cc0 <__umoddi3+0x144>
  803c2f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803c33:	29 f2                	sub    %esi,%edx
  803c35:	19 cb                	sbb    %ecx,%ebx
  803c37:	89 d8                	mov    %ebx,%eax
  803c39:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803c3d:	d3 e0                	shl    %cl,%eax
  803c3f:	89 e9                	mov    %ebp,%ecx
  803c41:	d3 ea                	shr    %cl,%edx
  803c43:	09 d0                	or     %edx,%eax
  803c45:	89 e9                	mov    %ebp,%ecx
  803c47:	d3 eb                	shr    %cl,%ebx
  803c49:	89 da                	mov    %ebx,%edx
  803c4b:	83 c4 1c             	add    $0x1c,%esp
  803c4e:	5b                   	pop    %ebx
  803c4f:	5e                   	pop    %esi
  803c50:	5f                   	pop    %edi
  803c51:	5d                   	pop    %ebp
  803c52:	c3                   	ret    
  803c53:	90                   	nop
  803c54:	89 fd                	mov    %edi,%ebp
  803c56:	85 ff                	test   %edi,%edi
  803c58:	75 0b                	jne    803c65 <__umoddi3+0xe9>
  803c5a:	b8 01 00 00 00       	mov    $0x1,%eax
  803c5f:	31 d2                	xor    %edx,%edx
  803c61:	f7 f7                	div    %edi
  803c63:	89 c5                	mov    %eax,%ebp
  803c65:	89 f0                	mov    %esi,%eax
  803c67:	31 d2                	xor    %edx,%edx
  803c69:	f7 f5                	div    %ebp
  803c6b:	89 c8                	mov    %ecx,%eax
  803c6d:	f7 f5                	div    %ebp
  803c6f:	89 d0                	mov    %edx,%eax
  803c71:	e9 44 ff ff ff       	jmp    803bba <__umoddi3+0x3e>
  803c76:	66 90                	xchg   %ax,%ax
  803c78:	89 c8                	mov    %ecx,%eax
  803c7a:	89 f2                	mov    %esi,%edx
  803c7c:	83 c4 1c             	add    $0x1c,%esp
  803c7f:	5b                   	pop    %ebx
  803c80:	5e                   	pop    %esi
  803c81:	5f                   	pop    %edi
  803c82:	5d                   	pop    %ebp
  803c83:	c3                   	ret    
  803c84:	3b 04 24             	cmp    (%esp),%eax
  803c87:	72 06                	jb     803c8f <__umoddi3+0x113>
  803c89:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803c8d:	77 0f                	ja     803c9e <__umoddi3+0x122>
  803c8f:	89 f2                	mov    %esi,%edx
  803c91:	29 f9                	sub    %edi,%ecx
  803c93:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803c97:	89 14 24             	mov    %edx,(%esp)
  803c9a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c9e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803ca2:	8b 14 24             	mov    (%esp),%edx
  803ca5:	83 c4 1c             	add    $0x1c,%esp
  803ca8:	5b                   	pop    %ebx
  803ca9:	5e                   	pop    %esi
  803caa:	5f                   	pop    %edi
  803cab:	5d                   	pop    %ebp
  803cac:	c3                   	ret    
  803cad:	8d 76 00             	lea    0x0(%esi),%esi
  803cb0:	2b 04 24             	sub    (%esp),%eax
  803cb3:	19 fa                	sbb    %edi,%edx
  803cb5:	89 d1                	mov    %edx,%ecx
  803cb7:	89 c6                	mov    %eax,%esi
  803cb9:	e9 71 ff ff ff       	jmp    803c2f <__umoddi3+0xb3>
  803cbe:	66 90                	xchg   %ax,%ax
  803cc0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803cc4:	72 ea                	jb     803cb0 <__umoddi3+0x134>
  803cc6:	89 d9                	mov    %ebx,%ecx
  803cc8:	e9 62 ff ff ff       	jmp    803c2f <__umoddi3+0xb3>
