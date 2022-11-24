
obj/user/quicksort_freeheap:     file format elf32-i386


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
  800031:	e8 b4 05 00 00       	call   8005ea <libmain>
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
  80003b:	53                   	push   %ebx
  80003c:	81 ec 24 01 00 00    	sub    $0x124,%esp
	char Chose ;
	char Line[255] ;
	int Iteration = 0 ;
  800042:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	do
	{
		int InitFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames();
  800049:	e8 45 1b 00 00       	call   801b93 <sys_calculate_free_frames>
  80004e:	89 c3                	mov    %eax,%ebx
  800050:	e8 57 1b 00 00       	call   801bac <sys_calculate_modified_frames>
  800055:	01 d8                	add    %ebx,%eax
  800057:	89 45 f0             	mov    %eax,-0x10(%ebp)

		Iteration++ ;
  80005a:	ff 45 f4             	incl   -0xc(%ebp)
		//		cprintf("Free Frames Before Allocation = %d\n", sys_calculate_free_frames()) ;

		//	sys_disable_interrupt();

		readline("Enter the number of elements: ", Line);
  80005d:	83 ec 08             	sub    $0x8,%esp
  800060:	8d 85 e1 fe ff ff    	lea    -0x11f(%ebp),%eax
  800066:	50                   	push   %eax
  800067:	68 80 23 80 00       	push   $0x802380
  80006c:	e8 eb 0f 00 00       	call   80105c <readline>
  800071:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  800074:	83 ec 04             	sub    $0x4,%esp
  800077:	6a 0a                	push   $0xa
  800079:	6a 00                	push   $0x0
  80007b:	8d 85 e1 fe ff ff    	lea    -0x11f(%ebp),%eax
  800081:	50                   	push   %eax
  800082:	e8 3b 15 00 00       	call   8015c2 <strtol>
  800087:	83 c4 10             	add    $0x10,%esp
  80008a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  80008d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800090:	c1 e0 02             	shl    $0x2,%eax
  800093:	83 ec 0c             	sub    $0xc,%esp
  800096:	50                   	push   %eax
  800097:	e8 e8 18 00 00       	call   801984 <malloc>
  80009c:	83 c4 10             	add    $0x10,%esp
  80009f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		cprintf("Choose the initialization method:\n") ;
  8000a2:	83 ec 0c             	sub    $0xc,%esp
  8000a5:	68 a0 23 80 00       	push   $0x8023a0
  8000aa:	e8 2b 09 00 00       	call   8009da <cprintf>
  8000af:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000b2:	83 ec 0c             	sub    $0xc,%esp
  8000b5:	68 c3 23 80 00       	push   $0x8023c3
  8000ba:	e8 1b 09 00 00       	call   8009da <cprintf>
  8000bf:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000c2:	83 ec 0c             	sub    $0xc,%esp
  8000c5:	68 d1 23 80 00       	push   $0x8023d1
  8000ca:	e8 0b 09 00 00       	call   8009da <cprintf>
  8000cf:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  8000d2:	83 ec 0c             	sub    $0xc,%esp
  8000d5:	68 e0 23 80 00       	push   $0x8023e0
  8000da:	e8 fb 08 00 00       	call   8009da <cprintf>
  8000df:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  8000e2:	83 ec 0c             	sub    $0xc,%esp
  8000e5:	68 f0 23 80 00       	push   $0x8023f0
  8000ea:	e8 eb 08 00 00       	call   8009da <cprintf>
  8000ef:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  8000f2:	e8 9b 04 00 00       	call   800592 <getchar>
  8000f7:	88 45 e7             	mov    %al,-0x19(%ebp)
			cputchar(Chose);
  8000fa:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  8000fe:	83 ec 0c             	sub    $0xc,%esp
  800101:	50                   	push   %eax
  800102:	e8 43 04 00 00       	call   80054a <cputchar>
  800107:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  80010a:	83 ec 0c             	sub    $0xc,%esp
  80010d:	6a 0a                	push   $0xa
  80010f:	e8 36 04 00 00       	call   80054a <cputchar>
  800114:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800117:	80 7d e7 61          	cmpb   $0x61,-0x19(%ebp)
  80011b:	74 0c                	je     800129 <_main+0xf1>
  80011d:	80 7d e7 62          	cmpb   $0x62,-0x19(%ebp)
  800121:	74 06                	je     800129 <_main+0xf1>
  800123:	80 7d e7 63          	cmpb   $0x63,-0x19(%ebp)
  800127:	75 b9                	jne    8000e2 <_main+0xaa>
		//sys_enable_interrupt();
		int  i ;
		switch (Chose)
  800129:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  80012d:	83 f8 62             	cmp    $0x62,%eax
  800130:	74 1d                	je     80014f <_main+0x117>
  800132:	83 f8 63             	cmp    $0x63,%eax
  800135:	74 2b                	je     800162 <_main+0x12a>
  800137:	83 f8 61             	cmp    $0x61,%eax
  80013a:	75 39                	jne    800175 <_main+0x13d>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  80013c:	83 ec 08             	sub    $0x8,%esp
  80013f:	ff 75 ec             	pushl  -0x14(%ebp)
  800142:	ff 75 e8             	pushl  -0x18(%ebp)
  800145:	e8 c8 02 00 00       	call   800412 <InitializeAscending>
  80014a:	83 c4 10             	add    $0x10,%esp
			break ;
  80014d:	eb 37                	jmp    800186 <_main+0x14e>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80014f:	83 ec 08             	sub    $0x8,%esp
  800152:	ff 75 ec             	pushl  -0x14(%ebp)
  800155:	ff 75 e8             	pushl  -0x18(%ebp)
  800158:	e8 e6 02 00 00       	call   800443 <InitializeDescending>
  80015d:	83 c4 10             	add    $0x10,%esp
			break ;
  800160:	eb 24                	jmp    800186 <_main+0x14e>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  800162:	83 ec 08             	sub    $0x8,%esp
  800165:	ff 75 ec             	pushl  -0x14(%ebp)
  800168:	ff 75 e8             	pushl  -0x18(%ebp)
  80016b:	e8 08 03 00 00       	call   800478 <InitializeSemiRandom>
  800170:	83 c4 10             	add    $0x10,%esp
			break ;
  800173:	eb 11                	jmp    800186 <_main+0x14e>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  800175:	83 ec 08             	sub    $0x8,%esp
  800178:	ff 75 ec             	pushl  -0x14(%ebp)
  80017b:	ff 75 e8             	pushl  -0x18(%ebp)
  80017e:	e8 f5 02 00 00       	call   800478 <InitializeSemiRandom>
  800183:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  800186:	83 ec 08             	sub    $0x8,%esp
  800189:	ff 75 ec             	pushl  -0x14(%ebp)
  80018c:	ff 75 e8             	pushl  -0x18(%ebp)
  80018f:	e8 c3 00 00 00       	call   800257 <QuickSort>
  800194:	83 c4 10             	add    $0x10,%esp

		//		PrintElements(Elements, NumOfElements);

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  800197:	83 ec 08             	sub    $0x8,%esp
  80019a:	ff 75 ec             	pushl  -0x14(%ebp)
  80019d:	ff 75 e8             	pushl  -0x18(%ebp)
  8001a0:	e8 c3 01 00 00       	call   800368 <CheckSorted>
  8001a5:	83 c4 10             	add    $0x10,%esp
  8001a8:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001ab:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8001af:	75 14                	jne    8001c5 <_main+0x18d>
  8001b1:	83 ec 04             	sub    $0x4,%esp
  8001b4:	68 fc 23 80 00       	push   $0x8023fc
  8001b9:	6a 45                	push   $0x45
  8001bb:	68 1e 24 80 00       	push   $0x80241e
  8001c0:	e8 61 05 00 00       	call   800726 <_panic>
		else
		{ 
			cprintf("===============================================\n") ;
  8001c5:	83 ec 0c             	sub    $0xc,%esp
  8001c8:	68 38 24 80 00       	push   $0x802438
  8001cd:	e8 08 08 00 00       	call   8009da <cprintf>
  8001d2:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  8001d5:	83 ec 0c             	sub    $0xc,%esp
  8001d8:	68 6c 24 80 00       	push   $0x80246c
  8001dd:	e8 f8 07 00 00       	call   8009da <cprintf>
  8001e2:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  8001e5:	83 ec 0c             	sub    $0xc,%esp
  8001e8:	68 a0 24 80 00       	push   $0x8024a0
  8001ed:	e8 e8 07 00 00       	call   8009da <cprintf>
  8001f2:	83 c4 10             	add    $0x10,%esp
		}

		//		cprintf("Free Frames After Calculation = %d\n", sys_calculate_free_frames()) ;

		cprintf("Freeing the Heap...\n\n") ;
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	68 d2 24 80 00       	push   $0x8024d2
  8001fd:	e8 d8 07 00 00       	call   8009da <cprintf>
  800202:	83 c4 10             	add    $0x10,%esp

		//freeHeap() ;

		///========================================================================
		//sys_disable_interrupt();
		cprintf("Do you want to repeat (y/n): ") ;
  800205:	83 ec 0c             	sub    $0xc,%esp
  800208:	68 e8 24 80 00       	push   $0x8024e8
  80020d:	e8 c8 07 00 00       	call   8009da <cprintf>
  800212:	83 c4 10             	add    $0x10,%esp
		Chose = getchar() ;
  800215:	e8 78 03 00 00       	call   800592 <getchar>
  80021a:	88 45 e7             	mov    %al,-0x19(%ebp)
		cputchar(Chose);
  80021d:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  800221:	83 ec 0c             	sub    $0xc,%esp
  800224:	50                   	push   %eax
  800225:	e8 20 03 00 00       	call   80054a <cputchar>
  80022a:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  80022d:	83 ec 0c             	sub    $0xc,%esp
  800230:	6a 0a                	push   $0xa
  800232:	e8 13 03 00 00       	call   80054a <cputchar>
  800237:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  80023a:	83 ec 0c             	sub    $0xc,%esp
  80023d:	6a 0a                	push   $0xa
  80023f:	e8 06 03 00 00       	call   80054a <cputchar>
  800244:	83 c4 10             	add    $0x10,%esp
		//sys_enable_interrupt();

	} while (Chose == 'y');
  800247:	80 7d e7 79          	cmpb   $0x79,-0x19(%ebp)
  80024b:	0f 84 f8 fd ff ff    	je     800049 <_main+0x11>

}
  800251:	90                   	nop
  800252:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800255:	c9                   	leave  
  800256:	c3                   	ret    

00800257 <QuickSort>:

///Quick sort 
void QuickSort(int *Elements, int NumOfElements)
{
  800257:	55                   	push   %ebp
  800258:	89 e5                	mov    %esp,%ebp
  80025a:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  80025d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800260:	48                   	dec    %eax
  800261:	50                   	push   %eax
  800262:	6a 00                	push   $0x0
  800264:	ff 75 0c             	pushl  0xc(%ebp)
  800267:	ff 75 08             	pushl  0x8(%ebp)
  80026a:	e8 06 00 00 00       	call   800275 <QSort>
  80026f:	83 c4 10             	add    $0x10,%esp
}
  800272:	90                   	nop
  800273:	c9                   	leave  
  800274:	c3                   	ret    

00800275 <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  800275:	55                   	push   %ebp
  800276:	89 e5                	mov    %esp,%ebp
  800278:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  80027b:	8b 45 10             	mov    0x10(%ebp),%eax
  80027e:	3b 45 14             	cmp    0x14(%ebp),%eax
  800281:	0f 8d de 00 00 00    	jge    800365 <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  800287:	8b 45 10             	mov    0x10(%ebp),%eax
  80028a:	40                   	inc    %eax
  80028b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80028e:	8b 45 14             	mov    0x14(%ebp),%eax
  800291:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  800294:	e9 80 00 00 00       	jmp    800319 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800299:	ff 45 f4             	incl   -0xc(%ebp)
  80029c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80029f:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002a2:	7f 2b                	jg     8002cf <QSort+0x5a>
  8002a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8002a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b1:	01 d0                	add    %edx,%eax
  8002b3:	8b 10                	mov    (%eax),%edx
  8002b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002b8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c2:	01 c8                	add    %ecx,%eax
  8002c4:	8b 00                	mov    (%eax),%eax
  8002c6:	39 c2                	cmp    %eax,%edx
  8002c8:	7d cf                	jge    800299 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  8002ca:	eb 03                	jmp    8002cf <QSort+0x5a>
  8002cc:	ff 4d f0             	decl   -0x10(%ebp)
  8002cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002d2:	3b 45 10             	cmp    0x10(%ebp),%eax
  8002d5:	7e 26                	jle    8002fd <QSort+0x88>
  8002d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8002da:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e4:	01 d0                	add    %edx,%eax
  8002e6:	8b 10                	mov    (%eax),%edx
  8002e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002eb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f5:	01 c8                	add    %ecx,%eax
  8002f7:	8b 00                	mov    (%eax),%eax
  8002f9:	39 c2                	cmp    %eax,%edx
  8002fb:	7e cf                	jle    8002cc <QSort+0x57>

		if (i <= j)
  8002fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800300:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800303:	7f 14                	jg     800319 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  800305:	83 ec 04             	sub    $0x4,%esp
  800308:	ff 75 f0             	pushl  -0x10(%ebp)
  80030b:	ff 75 f4             	pushl  -0xc(%ebp)
  80030e:	ff 75 08             	pushl  0x8(%ebp)
  800311:	e8 a9 00 00 00       	call   8003bf <Swap>
  800316:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800319:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80031c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80031f:	0f 8e 77 ff ff ff    	jle    80029c <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  800325:	83 ec 04             	sub    $0x4,%esp
  800328:	ff 75 f0             	pushl  -0x10(%ebp)
  80032b:	ff 75 10             	pushl  0x10(%ebp)
  80032e:	ff 75 08             	pushl  0x8(%ebp)
  800331:	e8 89 00 00 00       	call   8003bf <Swap>
  800336:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  800339:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80033c:	48                   	dec    %eax
  80033d:	50                   	push   %eax
  80033e:	ff 75 10             	pushl  0x10(%ebp)
  800341:	ff 75 0c             	pushl  0xc(%ebp)
  800344:	ff 75 08             	pushl  0x8(%ebp)
  800347:	e8 29 ff ff ff       	call   800275 <QSort>
  80034c:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  80034f:	ff 75 14             	pushl  0x14(%ebp)
  800352:	ff 75 f4             	pushl  -0xc(%ebp)
  800355:	ff 75 0c             	pushl  0xc(%ebp)
  800358:	ff 75 08             	pushl  0x8(%ebp)
  80035b:	e8 15 ff ff ff       	call   800275 <QSort>
  800360:	83 c4 10             	add    $0x10,%esp
  800363:	eb 01                	jmp    800366 <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  800365:	90                   	nop

	Swap( Elements, startIndex, j);

	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);
}
  800366:	c9                   	leave  
  800367:	c3                   	ret    

00800368 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  800368:	55                   	push   %ebp
  800369:	89 e5                	mov    %esp,%ebp
  80036b:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  80036e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800375:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80037c:	eb 33                	jmp    8003b1 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  80037e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800381:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800388:	8b 45 08             	mov    0x8(%ebp),%eax
  80038b:	01 d0                	add    %edx,%eax
  80038d:	8b 10                	mov    (%eax),%edx
  80038f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800392:	40                   	inc    %eax
  800393:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80039a:	8b 45 08             	mov    0x8(%ebp),%eax
  80039d:	01 c8                	add    %ecx,%eax
  80039f:	8b 00                	mov    (%eax),%eax
  8003a1:	39 c2                	cmp    %eax,%edx
  8003a3:	7e 09                	jle    8003ae <CheckSorted+0x46>
		{
			Sorted = 0 ;
  8003a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  8003ac:	eb 0c                	jmp    8003ba <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8003ae:	ff 45 f8             	incl   -0x8(%ebp)
  8003b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b4:	48                   	dec    %eax
  8003b5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8003b8:	7f c4                	jg     80037e <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  8003ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8003bd:	c9                   	leave  
  8003be:	c3                   	ret    

008003bf <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  8003bf:	55                   	push   %ebp
  8003c0:	89 e5                	mov    %esp,%ebp
  8003c2:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  8003c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d2:	01 d0                	add    %edx,%eax
  8003d4:	8b 00                	mov    (%eax),%eax
  8003d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  8003d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003dc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e6:	01 c2                	add    %eax,%edx
  8003e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8003eb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f5:	01 c8                	add    %ecx,%eax
  8003f7:	8b 00                	mov    (%eax),%eax
  8003f9:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  8003fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8003fe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800405:	8b 45 08             	mov    0x8(%ebp),%eax
  800408:	01 c2                	add    %eax,%edx
  80040a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80040d:	89 02                	mov    %eax,(%edx)
}
  80040f:	90                   	nop
  800410:	c9                   	leave  
  800411:	c3                   	ret    

00800412 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  800412:	55                   	push   %ebp
  800413:	89 e5                	mov    %esp,%ebp
  800415:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800418:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80041f:	eb 17                	jmp    800438 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  800421:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800424:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80042b:	8b 45 08             	mov    0x8(%ebp),%eax
  80042e:	01 c2                	add    %eax,%edx
  800430:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800433:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800435:	ff 45 fc             	incl   -0x4(%ebp)
  800438:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80043b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80043e:	7c e1                	jl     800421 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  800440:	90                   	nop
  800441:	c9                   	leave  
  800442:	c3                   	ret    

00800443 <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  800443:	55                   	push   %ebp
  800444:	89 e5                	mov    %esp,%ebp
  800446:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800449:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800450:	eb 1b                	jmp    80046d <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  800452:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800455:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80045c:	8b 45 08             	mov    0x8(%ebp),%eax
  80045f:	01 c2                	add    %eax,%edx
  800461:	8b 45 0c             	mov    0xc(%ebp),%eax
  800464:	2b 45 fc             	sub    -0x4(%ebp),%eax
  800467:	48                   	dec    %eax
  800468:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80046a:	ff 45 fc             	incl   -0x4(%ebp)
  80046d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800470:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800473:	7c dd                	jl     800452 <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  800475:	90                   	nop
  800476:	c9                   	leave  
  800477:	c3                   	ret    

00800478 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  800478:	55                   	push   %ebp
  800479:	89 e5                	mov    %esp,%ebp
  80047b:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  80047e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800481:	b8 56 55 55 55       	mov    $0x55555556,%eax
  800486:	f7 e9                	imul   %ecx
  800488:	c1 f9 1f             	sar    $0x1f,%ecx
  80048b:	89 d0                	mov    %edx,%eax
  80048d:	29 c8                	sub    %ecx,%eax
  80048f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  800492:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800499:	eb 1e                	jmp    8004b9 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  80049b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80049e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a8:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8004ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004ae:	99                   	cltd   
  8004af:	f7 7d f8             	idivl  -0x8(%ebp)
  8004b2:	89 d0                	mov    %edx,%eax
  8004b4:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004b6:	ff 45 fc             	incl   -0x4(%ebp)
  8004b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004bc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004bf:	7c da                	jl     80049b <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
	}

}
  8004c1:	90                   	nop
  8004c2:	c9                   	leave  
  8004c3:	c3                   	ret    

008004c4 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  8004c4:	55                   	push   %ebp
  8004c5:	89 e5                	mov    %esp,%ebp
  8004c7:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  8004ca:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  8004d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8004d8:	eb 42                	jmp    80051c <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  8004da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004dd:	99                   	cltd   
  8004de:	f7 7d f0             	idivl  -0x10(%ebp)
  8004e1:	89 d0                	mov    %edx,%eax
  8004e3:	85 c0                	test   %eax,%eax
  8004e5:	75 10                	jne    8004f7 <PrintElements+0x33>
			cprintf("\n");
  8004e7:	83 ec 0c             	sub    $0xc,%esp
  8004ea:	68 06 25 80 00       	push   $0x802506
  8004ef:	e8 e6 04 00 00       	call   8009da <cprintf>
  8004f4:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  8004f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800501:	8b 45 08             	mov    0x8(%ebp),%eax
  800504:	01 d0                	add    %edx,%eax
  800506:	8b 00                	mov    (%eax),%eax
  800508:	83 ec 08             	sub    $0x8,%esp
  80050b:	50                   	push   %eax
  80050c:	68 08 25 80 00       	push   $0x802508
  800511:	e8 c4 04 00 00       	call   8009da <cprintf>
  800516:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800519:	ff 45 f4             	incl   -0xc(%ebp)
  80051c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80051f:	48                   	dec    %eax
  800520:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800523:	7f b5                	jg     8004da <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800525:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800528:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80052f:	8b 45 08             	mov    0x8(%ebp),%eax
  800532:	01 d0                	add    %edx,%eax
  800534:	8b 00                	mov    (%eax),%eax
  800536:	83 ec 08             	sub    $0x8,%esp
  800539:	50                   	push   %eax
  80053a:	68 0d 25 80 00       	push   $0x80250d
  80053f:	e8 96 04 00 00       	call   8009da <cprintf>
  800544:	83 c4 10             	add    $0x10,%esp
}
  800547:	90                   	nop
  800548:	c9                   	leave  
  800549:	c3                   	ret    

0080054a <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  80054a:	55                   	push   %ebp
  80054b:	89 e5                	mov    %esp,%ebp
  80054d:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  800550:	8b 45 08             	mov    0x8(%ebp),%eax
  800553:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800556:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80055a:	83 ec 0c             	sub    $0xc,%esp
  80055d:	50                   	push   %eax
  80055e:	e8 51 17 00 00       	call   801cb4 <sys_cputc>
  800563:	83 c4 10             	add    $0x10,%esp
}
  800566:	90                   	nop
  800567:	c9                   	leave  
  800568:	c3                   	ret    

00800569 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  800569:	55                   	push   %ebp
  80056a:	89 e5                	mov    %esp,%ebp
  80056c:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80056f:	e8 0c 17 00 00       	call   801c80 <sys_disable_interrupt>
	char c = ch;
  800574:	8b 45 08             	mov    0x8(%ebp),%eax
  800577:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  80057a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80057e:	83 ec 0c             	sub    $0xc,%esp
  800581:	50                   	push   %eax
  800582:	e8 2d 17 00 00       	call   801cb4 <sys_cputc>
  800587:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80058a:	e8 0b 17 00 00       	call   801c9a <sys_enable_interrupt>
}
  80058f:	90                   	nop
  800590:	c9                   	leave  
  800591:	c3                   	ret    

00800592 <getchar>:

int
getchar(void)
{
  800592:	55                   	push   %ebp
  800593:	89 e5                	mov    %esp,%ebp
  800595:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800598:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80059f:	eb 08                	jmp    8005a9 <getchar+0x17>
	{
		c = sys_cgetc();
  8005a1:	e8 55 15 00 00       	call   801afb <sys_cgetc>
  8005a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  8005a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8005ad:	74 f2                	je     8005a1 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  8005af:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8005b2:	c9                   	leave  
  8005b3:	c3                   	ret    

008005b4 <atomic_getchar>:

int
atomic_getchar(void)
{
  8005b4:	55                   	push   %ebp
  8005b5:	89 e5                	mov    %esp,%ebp
  8005b7:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005ba:	e8 c1 16 00 00       	call   801c80 <sys_disable_interrupt>
	int c=0;
  8005bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8005c6:	eb 08                	jmp    8005d0 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  8005c8:	e8 2e 15 00 00       	call   801afb <sys_cgetc>
  8005cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  8005d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8005d4:	74 f2                	je     8005c8 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  8005d6:	e8 bf 16 00 00       	call   801c9a <sys_enable_interrupt>
	return c;
  8005db:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8005de:	c9                   	leave  
  8005df:	c3                   	ret    

008005e0 <iscons>:

int iscons(int fdnum)
{
  8005e0:	55                   	push   %ebp
  8005e1:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8005e3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8005e8:	5d                   	pop    %ebp
  8005e9:	c3                   	ret    

008005ea <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8005ea:	55                   	push   %ebp
  8005eb:	89 e5                	mov    %esp,%ebp
  8005ed:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8005f0:	e8 7e 18 00 00       	call   801e73 <sys_getenvindex>
  8005f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8005f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005fb:	89 d0                	mov    %edx,%eax
  8005fd:	c1 e0 03             	shl    $0x3,%eax
  800600:	01 d0                	add    %edx,%eax
  800602:	01 c0                	add    %eax,%eax
  800604:	01 d0                	add    %edx,%eax
  800606:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80060d:	01 d0                	add    %edx,%eax
  80060f:	c1 e0 04             	shl    $0x4,%eax
  800612:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800617:	a3 24 30 80 00       	mov    %eax,0x803024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80061c:	a1 24 30 80 00       	mov    0x803024,%eax
  800621:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800627:	84 c0                	test   %al,%al
  800629:	74 0f                	je     80063a <libmain+0x50>
		binaryname = myEnv->prog_name;
  80062b:	a1 24 30 80 00       	mov    0x803024,%eax
  800630:	05 5c 05 00 00       	add    $0x55c,%eax
  800635:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80063a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80063e:	7e 0a                	jle    80064a <libmain+0x60>
		binaryname = argv[0];
  800640:	8b 45 0c             	mov    0xc(%ebp),%eax
  800643:	8b 00                	mov    (%eax),%eax
  800645:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80064a:	83 ec 08             	sub    $0x8,%esp
  80064d:	ff 75 0c             	pushl  0xc(%ebp)
  800650:	ff 75 08             	pushl  0x8(%ebp)
  800653:	e8 e0 f9 ff ff       	call   800038 <_main>
  800658:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80065b:	e8 20 16 00 00       	call   801c80 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800660:	83 ec 0c             	sub    $0xc,%esp
  800663:	68 2c 25 80 00       	push   $0x80252c
  800668:	e8 6d 03 00 00       	call   8009da <cprintf>
  80066d:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800670:	a1 24 30 80 00       	mov    0x803024,%eax
  800675:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80067b:	a1 24 30 80 00       	mov    0x803024,%eax
  800680:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800686:	83 ec 04             	sub    $0x4,%esp
  800689:	52                   	push   %edx
  80068a:	50                   	push   %eax
  80068b:	68 54 25 80 00       	push   $0x802554
  800690:	e8 45 03 00 00       	call   8009da <cprintf>
  800695:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800698:	a1 24 30 80 00       	mov    0x803024,%eax
  80069d:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8006a3:	a1 24 30 80 00       	mov    0x803024,%eax
  8006a8:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8006ae:	a1 24 30 80 00       	mov    0x803024,%eax
  8006b3:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8006b9:	51                   	push   %ecx
  8006ba:	52                   	push   %edx
  8006bb:	50                   	push   %eax
  8006bc:	68 7c 25 80 00       	push   $0x80257c
  8006c1:	e8 14 03 00 00       	call   8009da <cprintf>
  8006c6:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006c9:	a1 24 30 80 00       	mov    0x803024,%eax
  8006ce:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8006d4:	83 ec 08             	sub    $0x8,%esp
  8006d7:	50                   	push   %eax
  8006d8:	68 d4 25 80 00       	push   $0x8025d4
  8006dd:	e8 f8 02 00 00       	call   8009da <cprintf>
  8006e2:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8006e5:	83 ec 0c             	sub    $0xc,%esp
  8006e8:	68 2c 25 80 00       	push   $0x80252c
  8006ed:	e8 e8 02 00 00       	call   8009da <cprintf>
  8006f2:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8006f5:	e8 a0 15 00 00       	call   801c9a <sys_enable_interrupt>

	// exit gracefully
	exit();
  8006fa:	e8 19 00 00 00       	call   800718 <exit>
}
  8006ff:	90                   	nop
  800700:	c9                   	leave  
  800701:	c3                   	ret    

00800702 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800702:	55                   	push   %ebp
  800703:	89 e5                	mov    %esp,%ebp
  800705:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800708:	83 ec 0c             	sub    $0xc,%esp
  80070b:	6a 00                	push   $0x0
  80070d:	e8 2d 17 00 00       	call   801e3f <sys_destroy_env>
  800712:	83 c4 10             	add    $0x10,%esp
}
  800715:	90                   	nop
  800716:	c9                   	leave  
  800717:	c3                   	ret    

00800718 <exit>:

void
exit(void)
{
  800718:	55                   	push   %ebp
  800719:	89 e5                	mov    %esp,%ebp
  80071b:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80071e:	e8 82 17 00 00       	call   801ea5 <sys_exit_env>
}
  800723:	90                   	nop
  800724:	c9                   	leave  
  800725:	c3                   	ret    

00800726 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800726:	55                   	push   %ebp
  800727:	89 e5                	mov    %esp,%ebp
  800729:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80072c:	8d 45 10             	lea    0x10(%ebp),%eax
  80072f:	83 c0 04             	add    $0x4,%eax
  800732:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800735:	a1 5c 31 80 00       	mov    0x80315c,%eax
  80073a:	85 c0                	test   %eax,%eax
  80073c:	74 16                	je     800754 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80073e:	a1 5c 31 80 00       	mov    0x80315c,%eax
  800743:	83 ec 08             	sub    $0x8,%esp
  800746:	50                   	push   %eax
  800747:	68 e8 25 80 00       	push   $0x8025e8
  80074c:	e8 89 02 00 00       	call   8009da <cprintf>
  800751:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800754:	a1 00 30 80 00       	mov    0x803000,%eax
  800759:	ff 75 0c             	pushl  0xc(%ebp)
  80075c:	ff 75 08             	pushl  0x8(%ebp)
  80075f:	50                   	push   %eax
  800760:	68 ed 25 80 00       	push   $0x8025ed
  800765:	e8 70 02 00 00       	call   8009da <cprintf>
  80076a:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80076d:	8b 45 10             	mov    0x10(%ebp),%eax
  800770:	83 ec 08             	sub    $0x8,%esp
  800773:	ff 75 f4             	pushl  -0xc(%ebp)
  800776:	50                   	push   %eax
  800777:	e8 f3 01 00 00       	call   80096f <vcprintf>
  80077c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80077f:	83 ec 08             	sub    $0x8,%esp
  800782:	6a 00                	push   $0x0
  800784:	68 09 26 80 00       	push   $0x802609
  800789:	e8 e1 01 00 00       	call   80096f <vcprintf>
  80078e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800791:	e8 82 ff ff ff       	call   800718 <exit>

	// should not return here
	while (1) ;
  800796:	eb fe                	jmp    800796 <_panic+0x70>

00800798 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800798:	55                   	push   %ebp
  800799:	89 e5                	mov    %esp,%ebp
  80079b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80079e:	a1 24 30 80 00       	mov    0x803024,%eax
  8007a3:	8b 50 74             	mov    0x74(%eax),%edx
  8007a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007a9:	39 c2                	cmp    %eax,%edx
  8007ab:	74 14                	je     8007c1 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8007ad:	83 ec 04             	sub    $0x4,%esp
  8007b0:	68 0c 26 80 00       	push   $0x80260c
  8007b5:	6a 26                	push   $0x26
  8007b7:	68 58 26 80 00       	push   $0x802658
  8007bc:	e8 65 ff ff ff       	call   800726 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8007c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8007c8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8007cf:	e9 c2 00 00 00       	jmp    800896 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8007d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007d7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007de:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e1:	01 d0                	add    %edx,%eax
  8007e3:	8b 00                	mov    (%eax),%eax
  8007e5:	85 c0                	test   %eax,%eax
  8007e7:	75 08                	jne    8007f1 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8007e9:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8007ec:	e9 a2 00 00 00       	jmp    800893 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8007f1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007f8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8007ff:	eb 69                	jmp    80086a <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800801:	a1 24 30 80 00       	mov    0x803024,%eax
  800806:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80080c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80080f:	89 d0                	mov    %edx,%eax
  800811:	01 c0                	add    %eax,%eax
  800813:	01 d0                	add    %edx,%eax
  800815:	c1 e0 03             	shl    $0x3,%eax
  800818:	01 c8                	add    %ecx,%eax
  80081a:	8a 40 04             	mov    0x4(%eax),%al
  80081d:	84 c0                	test   %al,%al
  80081f:	75 46                	jne    800867 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800821:	a1 24 30 80 00       	mov    0x803024,%eax
  800826:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80082c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80082f:	89 d0                	mov    %edx,%eax
  800831:	01 c0                	add    %eax,%eax
  800833:	01 d0                	add    %edx,%eax
  800835:	c1 e0 03             	shl    $0x3,%eax
  800838:	01 c8                	add    %ecx,%eax
  80083a:	8b 00                	mov    (%eax),%eax
  80083c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80083f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800842:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800847:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800849:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80084c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800853:	8b 45 08             	mov    0x8(%ebp),%eax
  800856:	01 c8                	add    %ecx,%eax
  800858:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80085a:	39 c2                	cmp    %eax,%edx
  80085c:	75 09                	jne    800867 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80085e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800865:	eb 12                	jmp    800879 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800867:	ff 45 e8             	incl   -0x18(%ebp)
  80086a:	a1 24 30 80 00       	mov    0x803024,%eax
  80086f:	8b 50 74             	mov    0x74(%eax),%edx
  800872:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800875:	39 c2                	cmp    %eax,%edx
  800877:	77 88                	ja     800801 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800879:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80087d:	75 14                	jne    800893 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80087f:	83 ec 04             	sub    $0x4,%esp
  800882:	68 64 26 80 00       	push   $0x802664
  800887:	6a 3a                	push   $0x3a
  800889:	68 58 26 80 00       	push   $0x802658
  80088e:	e8 93 fe ff ff       	call   800726 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800893:	ff 45 f0             	incl   -0x10(%ebp)
  800896:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800899:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80089c:	0f 8c 32 ff ff ff    	jl     8007d4 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8008a2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008a9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8008b0:	eb 26                	jmp    8008d8 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8008b2:	a1 24 30 80 00       	mov    0x803024,%eax
  8008b7:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8008bd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008c0:	89 d0                	mov    %edx,%eax
  8008c2:	01 c0                	add    %eax,%eax
  8008c4:	01 d0                	add    %edx,%eax
  8008c6:	c1 e0 03             	shl    $0x3,%eax
  8008c9:	01 c8                	add    %ecx,%eax
  8008cb:	8a 40 04             	mov    0x4(%eax),%al
  8008ce:	3c 01                	cmp    $0x1,%al
  8008d0:	75 03                	jne    8008d5 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8008d2:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008d5:	ff 45 e0             	incl   -0x20(%ebp)
  8008d8:	a1 24 30 80 00       	mov    0x803024,%eax
  8008dd:	8b 50 74             	mov    0x74(%eax),%edx
  8008e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008e3:	39 c2                	cmp    %eax,%edx
  8008e5:	77 cb                	ja     8008b2 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8008e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008ea:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8008ed:	74 14                	je     800903 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8008ef:	83 ec 04             	sub    $0x4,%esp
  8008f2:	68 b8 26 80 00       	push   $0x8026b8
  8008f7:	6a 44                	push   $0x44
  8008f9:	68 58 26 80 00       	push   $0x802658
  8008fe:	e8 23 fe ff ff       	call   800726 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800903:	90                   	nop
  800904:	c9                   	leave  
  800905:	c3                   	ret    

00800906 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800906:	55                   	push   %ebp
  800907:	89 e5                	mov    %esp,%ebp
  800909:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80090c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80090f:	8b 00                	mov    (%eax),%eax
  800911:	8d 48 01             	lea    0x1(%eax),%ecx
  800914:	8b 55 0c             	mov    0xc(%ebp),%edx
  800917:	89 0a                	mov    %ecx,(%edx)
  800919:	8b 55 08             	mov    0x8(%ebp),%edx
  80091c:	88 d1                	mov    %dl,%cl
  80091e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800921:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800925:	8b 45 0c             	mov    0xc(%ebp),%eax
  800928:	8b 00                	mov    (%eax),%eax
  80092a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80092f:	75 2c                	jne    80095d <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800931:	a0 28 30 80 00       	mov    0x803028,%al
  800936:	0f b6 c0             	movzbl %al,%eax
  800939:	8b 55 0c             	mov    0xc(%ebp),%edx
  80093c:	8b 12                	mov    (%edx),%edx
  80093e:	89 d1                	mov    %edx,%ecx
  800940:	8b 55 0c             	mov    0xc(%ebp),%edx
  800943:	83 c2 08             	add    $0x8,%edx
  800946:	83 ec 04             	sub    $0x4,%esp
  800949:	50                   	push   %eax
  80094a:	51                   	push   %ecx
  80094b:	52                   	push   %edx
  80094c:	e8 81 11 00 00       	call   801ad2 <sys_cputs>
  800951:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800954:	8b 45 0c             	mov    0xc(%ebp),%eax
  800957:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80095d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800960:	8b 40 04             	mov    0x4(%eax),%eax
  800963:	8d 50 01             	lea    0x1(%eax),%edx
  800966:	8b 45 0c             	mov    0xc(%ebp),%eax
  800969:	89 50 04             	mov    %edx,0x4(%eax)
}
  80096c:	90                   	nop
  80096d:	c9                   	leave  
  80096e:	c3                   	ret    

0080096f <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80096f:	55                   	push   %ebp
  800970:	89 e5                	mov    %esp,%ebp
  800972:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800978:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80097f:	00 00 00 
	b.cnt = 0;
  800982:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800989:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80098c:	ff 75 0c             	pushl  0xc(%ebp)
  80098f:	ff 75 08             	pushl  0x8(%ebp)
  800992:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800998:	50                   	push   %eax
  800999:	68 06 09 80 00       	push   $0x800906
  80099e:	e8 11 02 00 00       	call   800bb4 <vprintfmt>
  8009a3:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8009a6:	a0 28 30 80 00       	mov    0x803028,%al
  8009ab:	0f b6 c0             	movzbl %al,%eax
  8009ae:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8009b4:	83 ec 04             	sub    $0x4,%esp
  8009b7:	50                   	push   %eax
  8009b8:	52                   	push   %edx
  8009b9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009bf:	83 c0 08             	add    $0x8,%eax
  8009c2:	50                   	push   %eax
  8009c3:	e8 0a 11 00 00       	call   801ad2 <sys_cputs>
  8009c8:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8009cb:	c6 05 28 30 80 00 00 	movb   $0x0,0x803028
	return b.cnt;
  8009d2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8009d8:	c9                   	leave  
  8009d9:	c3                   	ret    

008009da <cprintf>:

int cprintf(const char *fmt, ...) {
  8009da:	55                   	push   %ebp
  8009db:	89 e5                	mov    %esp,%ebp
  8009dd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8009e0:	c6 05 28 30 80 00 01 	movb   $0x1,0x803028
	va_start(ap, fmt);
  8009e7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f0:	83 ec 08             	sub    $0x8,%esp
  8009f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8009f6:	50                   	push   %eax
  8009f7:	e8 73 ff ff ff       	call   80096f <vcprintf>
  8009fc:	83 c4 10             	add    $0x10,%esp
  8009ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a02:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a05:	c9                   	leave  
  800a06:	c3                   	ret    

00800a07 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a07:	55                   	push   %ebp
  800a08:	89 e5                	mov    %esp,%ebp
  800a0a:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a0d:	e8 6e 12 00 00       	call   801c80 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a12:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a15:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a18:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1b:	83 ec 08             	sub    $0x8,%esp
  800a1e:	ff 75 f4             	pushl  -0xc(%ebp)
  800a21:	50                   	push   %eax
  800a22:	e8 48 ff ff ff       	call   80096f <vcprintf>
  800a27:	83 c4 10             	add    $0x10,%esp
  800a2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a2d:	e8 68 12 00 00       	call   801c9a <sys_enable_interrupt>
	return cnt;
  800a32:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a35:	c9                   	leave  
  800a36:	c3                   	ret    

00800a37 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a37:	55                   	push   %ebp
  800a38:	89 e5                	mov    %esp,%ebp
  800a3a:	53                   	push   %ebx
  800a3b:	83 ec 14             	sub    $0x14,%esp
  800a3e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a41:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a44:	8b 45 14             	mov    0x14(%ebp),%eax
  800a47:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a4a:	8b 45 18             	mov    0x18(%ebp),%eax
  800a4d:	ba 00 00 00 00       	mov    $0x0,%edx
  800a52:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a55:	77 55                	ja     800aac <printnum+0x75>
  800a57:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a5a:	72 05                	jb     800a61 <printnum+0x2a>
  800a5c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a5f:	77 4b                	ja     800aac <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a61:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a64:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a67:	8b 45 18             	mov    0x18(%ebp),%eax
  800a6a:	ba 00 00 00 00       	mov    $0x0,%edx
  800a6f:	52                   	push   %edx
  800a70:	50                   	push   %eax
  800a71:	ff 75 f4             	pushl  -0xc(%ebp)
  800a74:	ff 75 f0             	pushl  -0x10(%ebp)
  800a77:	e8 8c 16 00 00       	call   802108 <__udivdi3>
  800a7c:	83 c4 10             	add    $0x10,%esp
  800a7f:	83 ec 04             	sub    $0x4,%esp
  800a82:	ff 75 20             	pushl  0x20(%ebp)
  800a85:	53                   	push   %ebx
  800a86:	ff 75 18             	pushl  0x18(%ebp)
  800a89:	52                   	push   %edx
  800a8a:	50                   	push   %eax
  800a8b:	ff 75 0c             	pushl  0xc(%ebp)
  800a8e:	ff 75 08             	pushl  0x8(%ebp)
  800a91:	e8 a1 ff ff ff       	call   800a37 <printnum>
  800a96:	83 c4 20             	add    $0x20,%esp
  800a99:	eb 1a                	jmp    800ab5 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a9b:	83 ec 08             	sub    $0x8,%esp
  800a9e:	ff 75 0c             	pushl  0xc(%ebp)
  800aa1:	ff 75 20             	pushl  0x20(%ebp)
  800aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa7:	ff d0                	call   *%eax
  800aa9:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800aac:	ff 4d 1c             	decl   0x1c(%ebp)
  800aaf:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800ab3:	7f e6                	jg     800a9b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800ab5:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800ab8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800abd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ac0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ac3:	53                   	push   %ebx
  800ac4:	51                   	push   %ecx
  800ac5:	52                   	push   %edx
  800ac6:	50                   	push   %eax
  800ac7:	e8 4c 17 00 00       	call   802218 <__umoddi3>
  800acc:	83 c4 10             	add    $0x10,%esp
  800acf:	05 34 29 80 00       	add    $0x802934,%eax
  800ad4:	8a 00                	mov    (%eax),%al
  800ad6:	0f be c0             	movsbl %al,%eax
  800ad9:	83 ec 08             	sub    $0x8,%esp
  800adc:	ff 75 0c             	pushl  0xc(%ebp)
  800adf:	50                   	push   %eax
  800ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae3:	ff d0                	call   *%eax
  800ae5:	83 c4 10             	add    $0x10,%esp
}
  800ae8:	90                   	nop
  800ae9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800aec:	c9                   	leave  
  800aed:	c3                   	ret    

00800aee <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800aee:	55                   	push   %ebp
  800aef:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800af1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800af5:	7e 1c                	jle    800b13 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800af7:	8b 45 08             	mov    0x8(%ebp),%eax
  800afa:	8b 00                	mov    (%eax),%eax
  800afc:	8d 50 08             	lea    0x8(%eax),%edx
  800aff:	8b 45 08             	mov    0x8(%ebp),%eax
  800b02:	89 10                	mov    %edx,(%eax)
  800b04:	8b 45 08             	mov    0x8(%ebp),%eax
  800b07:	8b 00                	mov    (%eax),%eax
  800b09:	83 e8 08             	sub    $0x8,%eax
  800b0c:	8b 50 04             	mov    0x4(%eax),%edx
  800b0f:	8b 00                	mov    (%eax),%eax
  800b11:	eb 40                	jmp    800b53 <getuint+0x65>
	else if (lflag)
  800b13:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b17:	74 1e                	je     800b37 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b19:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1c:	8b 00                	mov    (%eax),%eax
  800b1e:	8d 50 04             	lea    0x4(%eax),%edx
  800b21:	8b 45 08             	mov    0x8(%ebp),%eax
  800b24:	89 10                	mov    %edx,(%eax)
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
  800b29:	8b 00                	mov    (%eax),%eax
  800b2b:	83 e8 04             	sub    $0x4,%eax
  800b2e:	8b 00                	mov    (%eax),%eax
  800b30:	ba 00 00 00 00       	mov    $0x0,%edx
  800b35:	eb 1c                	jmp    800b53 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b37:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3a:	8b 00                	mov    (%eax),%eax
  800b3c:	8d 50 04             	lea    0x4(%eax),%edx
  800b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b42:	89 10                	mov    %edx,(%eax)
  800b44:	8b 45 08             	mov    0x8(%ebp),%eax
  800b47:	8b 00                	mov    (%eax),%eax
  800b49:	83 e8 04             	sub    $0x4,%eax
  800b4c:	8b 00                	mov    (%eax),%eax
  800b4e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b53:	5d                   	pop    %ebp
  800b54:	c3                   	ret    

00800b55 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b55:	55                   	push   %ebp
  800b56:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b58:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b5c:	7e 1c                	jle    800b7a <getint+0x25>
		return va_arg(*ap, long long);
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b61:	8b 00                	mov    (%eax),%eax
  800b63:	8d 50 08             	lea    0x8(%eax),%edx
  800b66:	8b 45 08             	mov    0x8(%ebp),%eax
  800b69:	89 10                	mov    %edx,(%eax)
  800b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6e:	8b 00                	mov    (%eax),%eax
  800b70:	83 e8 08             	sub    $0x8,%eax
  800b73:	8b 50 04             	mov    0x4(%eax),%edx
  800b76:	8b 00                	mov    (%eax),%eax
  800b78:	eb 38                	jmp    800bb2 <getint+0x5d>
	else if (lflag)
  800b7a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b7e:	74 1a                	je     800b9a <getint+0x45>
		return va_arg(*ap, long);
  800b80:	8b 45 08             	mov    0x8(%ebp),%eax
  800b83:	8b 00                	mov    (%eax),%eax
  800b85:	8d 50 04             	lea    0x4(%eax),%edx
  800b88:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8b:	89 10                	mov    %edx,(%eax)
  800b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b90:	8b 00                	mov    (%eax),%eax
  800b92:	83 e8 04             	sub    $0x4,%eax
  800b95:	8b 00                	mov    (%eax),%eax
  800b97:	99                   	cltd   
  800b98:	eb 18                	jmp    800bb2 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9d:	8b 00                	mov    (%eax),%eax
  800b9f:	8d 50 04             	lea    0x4(%eax),%edx
  800ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba5:	89 10                	mov    %edx,(%eax)
  800ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  800baa:	8b 00                	mov    (%eax),%eax
  800bac:	83 e8 04             	sub    $0x4,%eax
  800baf:	8b 00                	mov    (%eax),%eax
  800bb1:	99                   	cltd   
}
  800bb2:	5d                   	pop    %ebp
  800bb3:	c3                   	ret    

00800bb4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800bb4:	55                   	push   %ebp
  800bb5:	89 e5                	mov    %esp,%ebp
  800bb7:	56                   	push   %esi
  800bb8:	53                   	push   %ebx
  800bb9:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bbc:	eb 17                	jmp    800bd5 <vprintfmt+0x21>
			if (ch == '\0')
  800bbe:	85 db                	test   %ebx,%ebx
  800bc0:	0f 84 af 03 00 00    	je     800f75 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800bc6:	83 ec 08             	sub    $0x8,%esp
  800bc9:	ff 75 0c             	pushl  0xc(%ebp)
  800bcc:	53                   	push   %ebx
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	ff d0                	call   *%eax
  800bd2:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bd5:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd8:	8d 50 01             	lea    0x1(%eax),%edx
  800bdb:	89 55 10             	mov    %edx,0x10(%ebp)
  800bde:	8a 00                	mov    (%eax),%al
  800be0:	0f b6 d8             	movzbl %al,%ebx
  800be3:	83 fb 25             	cmp    $0x25,%ebx
  800be6:	75 d6                	jne    800bbe <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800be8:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800bec:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800bf3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800bfa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c01:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c08:	8b 45 10             	mov    0x10(%ebp),%eax
  800c0b:	8d 50 01             	lea    0x1(%eax),%edx
  800c0e:	89 55 10             	mov    %edx,0x10(%ebp)
  800c11:	8a 00                	mov    (%eax),%al
  800c13:	0f b6 d8             	movzbl %al,%ebx
  800c16:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c19:	83 f8 55             	cmp    $0x55,%eax
  800c1c:	0f 87 2b 03 00 00    	ja     800f4d <vprintfmt+0x399>
  800c22:	8b 04 85 58 29 80 00 	mov    0x802958(,%eax,4),%eax
  800c29:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c2b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c2f:	eb d7                	jmp    800c08 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c31:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c35:	eb d1                	jmp    800c08 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c37:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c3e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c41:	89 d0                	mov    %edx,%eax
  800c43:	c1 e0 02             	shl    $0x2,%eax
  800c46:	01 d0                	add    %edx,%eax
  800c48:	01 c0                	add    %eax,%eax
  800c4a:	01 d8                	add    %ebx,%eax
  800c4c:	83 e8 30             	sub    $0x30,%eax
  800c4f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c52:	8b 45 10             	mov    0x10(%ebp),%eax
  800c55:	8a 00                	mov    (%eax),%al
  800c57:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c5a:	83 fb 2f             	cmp    $0x2f,%ebx
  800c5d:	7e 3e                	jle    800c9d <vprintfmt+0xe9>
  800c5f:	83 fb 39             	cmp    $0x39,%ebx
  800c62:	7f 39                	jg     800c9d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c64:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c67:	eb d5                	jmp    800c3e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c69:	8b 45 14             	mov    0x14(%ebp),%eax
  800c6c:	83 c0 04             	add    $0x4,%eax
  800c6f:	89 45 14             	mov    %eax,0x14(%ebp)
  800c72:	8b 45 14             	mov    0x14(%ebp),%eax
  800c75:	83 e8 04             	sub    $0x4,%eax
  800c78:	8b 00                	mov    (%eax),%eax
  800c7a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c7d:	eb 1f                	jmp    800c9e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c7f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c83:	79 83                	jns    800c08 <vprintfmt+0x54>
				width = 0;
  800c85:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c8c:	e9 77 ff ff ff       	jmp    800c08 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c91:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c98:	e9 6b ff ff ff       	jmp    800c08 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c9d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c9e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ca2:	0f 89 60 ff ff ff    	jns    800c08 <vprintfmt+0x54>
				width = precision, precision = -1;
  800ca8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800cae:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800cb5:	e9 4e ff ff ff       	jmp    800c08 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800cba:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800cbd:	e9 46 ff ff ff       	jmp    800c08 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800cc2:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc5:	83 c0 04             	add    $0x4,%eax
  800cc8:	89 45 14             	mov    %eax,0x14(%ebp)
  800ccb:	8b 45 14             	mov    0x14(%ebp),%eax
  800cce:	83 e8 04             	sub    $0x4,%eax
  800cd1:	8b 00                	mov    (%eax),%eax
  800cd3:	83 ec 08             	sub    $0x8,%esp
  800cd6:	ff 75 0c             	pushl  0xc(%ebp)
  800cd9:	50                   	push   %eax
  800cda:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdd:	ff d0                	call   *%eax
  800cdf:	83 c4 10             	add    $0x10,%esp
			break;
  800ce2:	e9 89 02 00 00       	jmp    800f70 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ce7:	8b 45 14             	mov    0x14(%ebp),%eax
  800cea:	83 c0 04             	add    $0x4,%eax
  800ced:	89 45 14             	mov    %eax,0x14(%ebp)
  800cf0:	8b 45 14             	mov    0x14(%ebp),%eax
  800cf3:	83 e8 04             	sub    $0x4,%eax
  800cf6:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800cf8:	85 db                	test   %ebx,%ebx
  800cfa:	79 02                	jns    800cfe <vprintfmt+0x14a>
				err = -err;
  800cfc:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800cfe:	83 fb 64             	cmp    $0x64,%ebx
  800d01:	7f 0b                	jg     800d0e <vprintfmt+0x15a>
  800d03:	8b 34 9d a0 27 80 00 	mov    0x8027a0(,%ebx,4),%esi
  800d0a:	85 f6                	test   %esi,%esi
  800d0c:	75 19                	jne    800d27 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d0e:	53                   	push   %ebx
  800d0f:	68 45 29 80 00       	push   $0x802945
  800d14:	ff 75 0c             	pushl  0xc(%ebp)
  800d17:	ff 75 08             	pushl  0x8(%ebp)
  800d1a:	e8 5e 02 00 00       	call   800f7d <printfmt>
  800d1f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d22:	e9 49 02 00 00       	jmp    800f70 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d27:	56                   	push   %esi
  800d28:	68 4e 29 80 00       	push   $0x80294e
  800d2d:	ff 75 0c             	pushl  0xc(%ebp)
  800d30:	ff 75 08             	pushl  0x8(%ebp)
  800d33:	e8 45 02 00 00       	call   800f7d <printfmt>
  800d38:	83 c4 10             	add    $0x10,%esp
			break;
  800d3b:	e9 30 02 00 00       	jmp    800f70 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d40:	8b 45 14             	mov    0x14(%ebp),%eax
  800d43:	83 c0 04             	add    $0x4,%eax
  800d46:	89 45 14             	mov    %eax,0x14(%ebp)
  800d49:	8b 45 14             	mov    0x14(%ebp),%eax
  800d4c:	83 e8 04             	sub    $0x4,%eax
  800d4f:	8b 30                	mov    (%eax),%esi
  800d51:	85 f6                	test   %esi,%esi
  800d53:	75 05                	jne    800d5a <vprintfmt+0x1a6>
				p = "(null)";
  800d55:	be 51 29 80 00       	mov    $0x802951,%esi
			if (width > 0 && padc != '-')
  800d5a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d5e:	7e 6d                	jle    800dcd <vprintfmt+0x219>
  800d60:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d64:	74 67                	je     800dcd <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d66:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d69:	83 ec 08             	sub    $0x8,%esp
  800d6c:	50                   	push   %eax
  800d6d:	56                   	push   %esi
  800d6e:	e8 12 05 00 00       	call   801285 <strnlen>
  800d73:	83 c4 10             	add    $0x10,%esp
  800d76:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d79:	eb 16                	jmp    800d91 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d7b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d7f:	83 ec 08             	sub    $0x8,%esp
  800d82:	ff 75 0c             	pushl  0xc(%ebp)
  800d85:	50                   	push   %eax
  800d86:	8b 45 08             	mov    0x8(%ebp),%eax
  800d89:	ff d0                	call   *%eax
  800d8b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d8e:	ff 4d e4             	decl   -0x1c(%ebp)
  800d91:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d95:	7f e4                	jg     800d7b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d97:	eb 34                	jmp    800dcd <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d99:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d9d:	74 1c                	je     800dbb <vprintfmt+0x207>
  800d9f:	83 fb 1f             	cmp    $0x1f,%ebx
  800da2:	7e 05                	jle    800da9 <vprintfmt+0x1f5>
  800da4:	83 fb 7e             	cmp    $0x7e,%ebx
  800da7:	7e 12                	jle    800dbb <vprintfmt+0x207>
					putch('?', putdat);
  800da9:	83 ec 08             	sub    $0x8,%esp
  800dac:	ff 75 0c             	pushl  0xc(%ebp)
  800daf:	6a 3f                	push   $0x3f
  800db1:	8b 45 08             	mov    0x8(%ebp),%eax
  800db4:	ff d0                	call   *%eax
  800db6:	83 c4 10             	add    $0x10,%esp
  800db9:	eb 0f                	jmp    800dca <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800dbb:	83 ec 08             	sub    $0x8,%esp
  800dbe:	ff 75 0c             	pushl  0xc(%ebp)
  800dc1:	53                   	push   %ebx
  800dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc5:	ff d0                	call   *%eax
  800dc7:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dca:	ff 4d e4             	decl   -0x1c(%ebp)
  800dcd:	89 f0                	mov    %esi,%eax
  800dcf:	8d 70 01             	lea    0x1(%eax),%esi
  800dd2:	8a 00                	mov    (%eax),%al
  800dd4:	0f be d8             	movsbl %al,%ebx
  800dd7:	85 db                	test   %ebx,%ebx
  800dd9:	74 24                	je     800dff <vprintfmt+0x24b>
  800ddb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ddf:	78 b8                	js     800d99 <vprintfmt+0x1e5>
  800de1:	ff 4d e0             	decl   -0x20(%ebp)
  800de4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800de8:	79 af                	jns    800d99 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800dea:	eb 13                	jmp    800dff <vprintfmt+0x24b>
				putch(' ', putdat);
  800dec:	83 ec 08             	sub    $0x8,%esp
  800def:	ff 75 0c             	pushl  0xc(%ebp)
  800df2:	6a 20                	push   $0x20
  800df4:	8b 45 08             	mov    0x8(%ebp),%eax
  800df7:	ff d0                	call   *%eax
  800df9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800dfc:	ff 4d e4             	decl   -0x1c(%ebp)
  800dff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e03:	7f e7                	jg     800dec <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e05:	e9 66 01 00 00       	jmp    800f70 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e0a:	83 ec 08             	sub    $0x8,%esp
  800e0d:	ff 75 e8             	pushl  -0x18(%ebp)
  800e10:	8d 45 14             	lea    0x14(%ebp),%eax
  800e13:	50                   	push   %eax
  800e14:	e8 3c fd ff ff       	call   800b55 <getint>
  800e19:	83 c4 10             	add    $0x10,%esp
  800e1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e1f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e25:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e28:	85 d2                	test   %edx,%edx
  800e2a:	79 23                	jns    800e4f <vprintfmt+0x29b>
				putch('-', putdat);
  800e2c:	83 ec 08             	sub    $0x8,%esp
  800e2f:	ff 75 0c             	pushl  0xc(%ebp)
  800e32:	6a 2d                	push   $0x2d
  800e34:	8b 45 08             	mov    0x8(%ebp),%eax
  800e37:	ff d0                	call   *%eax
  800e39:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e42:	f7 d8                	neg    %eax
  800e44:	83 d2 00             	adc    $0x0,%edx
  800e47:	f7 da                	neg    %edx
  800e49:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e4c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e4f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e56:	e9 bc 00 00 00       	jmp    800f17 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e5b:	83 ec 08             	sub    $0x8,%esp
  800e5e:	ff 75 e8             	pushl  -0x18(%ebp)
  800e61:	8d 45 14             	lea    0x14(%ebp),%eax
  800e64:	50                   	push   %eax
  800e65:	e8 84 fc ff ff       	call   800aee <getuint>
  800e6a:	83 c4 10             	add    $0x10,%esp
  800e6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e70:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e73:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e7a:	e9 98 00 00 00       	jmp    800f17 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e7f:	83 ec 08             	sub    $0x8,%esp
  800e82:	ff 75 0c             	pushl  0xc(%ebp)
  800e85:	6a 58                	push   $0x58
  800e87:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8a:	ff d0                	call   *%eax
  800e8c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e8f:	83 ec 08             	sub    $0x8,%esp
  800e92:	ff 75 0c             	pushl  0xc(%ebp)
  800e95:	6a 58                	push   $0x58
  800e97:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9a:	ff d0                	call   *%eax
  800e9c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e9f:	83 ec 08             	sub    $0x8,%esp
  800ea2:	ff 75 0c             	pushl  0xc(%ebp)
  800ea5:	6a 58                	push   $0x58
  800ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eaa:	ff d0                	call   *%eax
  800eac:	83 c4 10             	add    $0x10,%esp
			break;
  800eaf:	e9 bc 00 00 00       	jmp    800f70 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800eb4:	83 ec 08             	sub    $0x8,%esp
  800eb7:	ff 75 0c             	pushl  0xc(%ebp)
  800eba:	6a 30                	push   $0x30
  800ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebf:	ff d0                	call   *%eax
  800ec1:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ec4:	83 ec 08             	sub    $0x8,%esp
  800ec7:	ff 75 0c             	pushl  0xc(%ebp)
  800eca:	6a 78                	push   $0x78
  800ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecf:	ff d0                	call   *%eax
  800ed1:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ed4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ed7:	83 c0 04             	add    $0x4,%eax
  800eda:	89 45 14             	mov    %eax,0x14(%ebp)
  800edd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ee0:	83 e8 04             	sub    $0x4,%eax
  800ee3:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ee5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ee8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800eef:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ef6:	eb 1f                	jmp    800f17 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ef8:	83 ec 08             	sub    $0x8,%esp
  800efb:	ff 75 e8             	pushl  -0x18(%ebp)
  800efe:	8d 45 14             	lea    0x14(%ebp),%eax
  800f01:	50                   	push   %eax
  800f02:	e8 e7 fb ff ff       	call   800aee <getuint>
  800f07:	83 c4 10             	add    $0x10,%esp
  800f0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f0d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f10:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f17:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f1e:	83 ec 04             	sub    $0x4,%esp
  800f21:	52                   	push   %edx
  800f22:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f25:	50                   	push   %eax
  800f26:	ff 75 f4             	pushl  -0xc(%ebp)
  800f29:	ff 75 f0             	pushl  -0x10(%ebp)
  800f2c:	ff 75 0c             	pushl  0xc(%ebp)
  800f2f:	ff 75 08             	pushl  0x8(%ebp)
  800f32:	e8 00 fb ff ff       	call   800a37 <printnum>
  800f37:	83 c4 20             	add    $0x20,%esp
			break;
  800f3a:	eb 34                	jmp    800f70 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f3c:	83 ec 08             	sub    $0x8,%esp
  800f3f:	ff 75 0c             	pushl  0xc(%ebp)
  800f42:	53                   	push   %ebx
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
  800f46:	ff d0                	call   *%eax
  800f48:	83 c4 10             	add    $0x10,%esp
			break;
  800f4b:	eb 23                	jmp    800f70 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f4d:	83 ec 08             	sub    $0x8,%esp
  800f50:	ff 75 0c             	pushl  0xc(%ebp)
  800f53:	6a 25                	push   $0x25
  800f55:	8b 45 08             	mov    0x8(%ebp),%eax
  800f58:	ff d0                	call   *%eax
  800f5a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f5d:	ff 4d 10             	decl   0x10(%ebp)
  800f60:	eb 03                	jmp    800f65 <vprintfmt+0x3b1>
  800f62:	ff 4d 10             	decl   0x10(%ebp)
  800f65:	8b 45 10             	mov    0x10(%ebp),%eax
  800f68:	48                   	dec    %eax
  800f69:	8a 00                	mov    (%eax),%al
  800f6b:	3c 25                	cmp    $0x25,%al
  800f6d:	75 f3                	jne    800f62 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800f6f:	90                   	nop
		}
	}
  800f70:	e9 47 fc ff ff       	jmp    800bbc <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f75:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f76:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f79:	5b                   	pop    %ebx
  800f7a:	5e                   	pop    %esi
  800f7b:	5d                   	pop    %ebp
  800f7c:	c3                   	ret    

00800f7d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f7d:	55                   	push   %ebp
  800f7e:	89 e5                	mov    %esp,%ebp
  800f80:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f83:	8d 45 10             	lea    0x10(%ebp),%eax
  800f86:	83 c0 04             	add    $0x4,%eax
  800f89:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f8c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8f:	ff 75 f4             	pushl  -0xc(%ebp)
  800f92:	50                   	push   %eax
  800f93:	ff 75 0c             	pushl  0xc(%ebp)
  800f96:	ff 75 08             	pushl  0x8(%ebp)
  800f99:	e8 16 fc ff ff       	call   800bb4 <vprintfmt>
  800f9e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800fa1:	90                   	nop
  800fa2:	c9                   	leave  
  800fa3:	c3                   	ret    

00800fa4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fa4:	55                   	push   %ebp
  800fa5:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800fa7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800faa:	8b 40 08             	mov    0x8(%eax),%eax
  800fad:	8d 50 01             	lea    0x1(%eax),%edx
  800fb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb3:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800fb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb9:	8b 10                	mov    (%eax),%edx
  800fbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbe:	8b 40 04             	mov    0x4(%eax),%eax
  800fc1:	39 c2                	cmp    %eax,%edx
  800fc3:	73 12                	jae    800fd7 <sprintputch+0x33>
		*b->buf++ = ch;
  800fc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc8:	8b 00                	mov    (%eax),%eax
  800fca:	8d 48 01             	lea    0x1(%eax),%ecx
  800fcd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fd0:	89 0a                	mov    %ecx,(%edx)
  800fd2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd5:	88 10                	mov    %dl,(%eax)
}
  800fd7:	90                   	nop
  800fd8:	5d                   	pop    %ebp
  800fd9:	c3                   	ret    

00800fda <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800fda:	55                   	push   %ebp
  800fdb:	89 e5                	mov    %esp,%ebp
  800fdd:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800fe6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fec:	8b 45 08             	mov    0x8(%ebp),%eax
  800fef:	01 d0                	add    %edx,%eax
  800ff1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ff4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ffb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fff:	74 06                	je     801007 <vsnprintf+0x2d>
  801001:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801005:	7f 07                	jg     80100e <vsnprintf+0x34>
		return -E_INVAL;
  801007:	b8 03 00 00 00       	mov    $0x3,%eax
  80100c:	eb 20                	jmp    80102e <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80100e:	ff 75 14             	pushl  0x14(%ebp)
  801011:	ff 75 10             	pushl  0x10(%ebp)
  801014:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801017:	50                   	push   %eax
  801018:	68 a4 0f 80 00       	push   $0x800fa4
  80101d:	e8 92 fb ff ff       	call   800bb4 <vprintfmt>
  801022:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801025:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801028:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80102b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80102e:	c9                   	leave  
  80102f:	c3                   	ret    

00801030 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801030:	55                   	push   %ebp
  801031:	89 e5                	mov    %esp,%ebp
  801033:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801036:	8d 45 10             	lea    0x10(%ebp),%eax
  801039:	83 c0 04             	add    $0x4,%eax
  80103c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80103f:	8b 45 10             	mov    0x10(%ebp),%eax
  801042:	ff 75 f4             	pushl  -0xc(%ebp)
  801045:	50                   	push   %eax
  801046:	ff 75 0c             	pushl  0xc(%ebp)
  801049:	ff 75 08             	pushl  0x8(%ebp)
  80104c:	e8 89 ff ff ff       	call   800fda <vsnprintf>
  801051:	83 c4 10             	add    $0x10,%esp
  801054:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801057:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80105a:	c9                   	leave  
  80105b:	c3                   	ret    

0080105c <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  80105c:	55                   	push   %ebp
  80105d:	89 e5                	mov    %esp,%ebp
  80105f:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  801062:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801066:	74 13                	je     80107b <readline+0x1f>
		cprintf("%s", prompt);
  801068:	83 ec 08             	sub    $0x8,%esp
  80106b:	ff 75 08             	pushl  0x8(%ebp)
  80106e:	68 b0 2a 80 00       	push   $0x802ab0
  801073:	e8 62 f9 ff ff       	call   8009da <cprintf>
  801078:	83 c4 10             	add    $0x10,%esp

	i = 0;
  80107b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801082:	83 ec 0c             	sub    $0xc,%esp
  801085:	6a 00                	push   $0x0
  801087:	e8 54 f5 ff ff       	call   8005e0 <iscons>
  80108c:	83 c4 10             	add    $0x10,%esp
  80108f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801092:	e8 fb f4 ff ff       	call   800592 <getchar>
  801097:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  80109a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80109e:	79 22                	jns    8010c2 <readline+0x66>
			if (c != -E_EOF)
  8010a0:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8010a4:	0f 84 ad 00 00 00    	je     801157 <readline+0xfb>
				cprintf("read error: %e\n", c);
  8010aa:	83 ec 08             	sub    $0x8,%esp
  8010ad:	ff 75 ec             	pushl  -0x14(%ebp)
  8010b0:	68 b3 2a 80 00       	push   $0x802ab3
  8010b5:	e8 20 f9 ff ff       	call   8009da <cprintf>
  8010ba:	83 c4 10             	add    $0x10,%esp
			return;
  8010bd:	e9 95 00 00 00       	jmp    801157 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8010c2:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8010c6:	7e 34                	jle    8010fc <readline+0xa0>
  8010c8:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8010cf:	7f 2b                	jg     8010fc <readline+0xa0>
			if (echoing)
  8010d1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8010d5:	74 0e                	je     8010e5 <readline+0x89>
				cputchar(c);
  8010d7:	83 ec 0c             	sub    $0xc,%esp
  8010da:	ff 75 ec             	pushl  -0x14(%ebp)
  8010dd:	e8 68 f4 ff ff       	call   80054a <cputchar>
  8010e2:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8010e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010e8:	8d 50 01             	lea    0x1(%eax),%edx
  8010eb:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8010ee:	89 c2                	mov    %eax,%edx
  8010f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f3:	01 d0                	add    %edx,%eax
  8010f5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010f8:	88 10                	mov    %dl,(%eax)
  8010fa:	eb 56                	jmp    801152 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  8010fc:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801100:	75 1f                	jne    801121 <readline+0xc5>
  801102:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801106:	7e 19                	jle    801121 <readline+0xc5>
			if (echoing)
  801108:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80110c:	74 0e                	je     80111c <readline+0xc0>
				cputchar(c);
  80110e:	83 ec 0c             	sub    $0xc,%esp
  801111:	ff 75 ec             	pushl  -0x14(%ebp)
  801114:	e8 31 f4 ff ff       	call   80054a <cputchar>
  801119:	83 c4 10             	add    $0x10,%esp

			i--;
  80111c:	ff 4d f4             	decl   -0xc(%ebp)
  80111f:	eb 31                	jmp    801152 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801121:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801125:	74 0a                	je     801131 <readline+0xd5>
  801127:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80112b:	0f 85 61 ff ff ff    	jne    801092 <readline+0x36>
			if (echoing)
  801131:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801135:	74 0e                	je     801145 <readline+0xe9>
				cputchar(c);
  801137:	83 ec 0c             	sub    $0xc,%esp
  80113a:	ff 75 ec             	pushl  -0x14(%ebp)
  80113d:	e8 08 f4 ff ff       	call   80054a <cputchar>
  801142:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  801145:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801148:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114b:	01 d0                	add    %edx,%eax
  80114d:	c6 00 00             	movb   $0x0,(%eax)
			return;
  801150:	eb 06                	jmp    801158 <readline+0xfc>
		}
	}
  801152:	e9 3b ff ff ff       	jmp    801092 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  801157:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  801158:	c9                   	leave  
  801159:	c3                   	ret    

0080115a <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  80115a:	55                   	push   %ebp
  80115b:	89 e5                	mov    %esp,%ebp
  80115d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801160:	e8 1b 0b 00 00       	call   801c80 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  801165:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801169:	74 13                	je     80117e <atomic_readline+0x24>
		cprintf("%s", prompt);
  80116b:	83 ec 08             	sub    $0x8,%esp
  80116e:	ff 75 08             	pushl  0x8(%ebp)
  801171:	68 b0 2a 80 00       	push   $0x802ab0
  801176:	e8 5f f8 ff ff       	call   8009da <cprintf>
  80117b:	83 c4 10             	add    $0x10,%esp

	i = 0;
  80117e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801185:	83 ec 0c             	sub    $0xc,%esp
  801188:	6a 00                	push   $0x0
  80118a:	e8 51 f4 ff ff       	call   8005e0 <iscons>
  80118f:	83 c4 10             	add    $0x10,%esp
  801192:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801195:	e8 f8 f3 ff ff       	call   800592 <getchar>
  80119a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  80119d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8011a1:	79 23                	jns    8011c6 <atomic_readline+0x6c>
			if (c != -E_EOF)
  8011a3:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8011a7:	74 13                	je     8011bc <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  8011a9:	83 ec 08             	sub    $0x8,%esp
  8011ac:	ff 75 ec             	pushl  -0x14(%ebp)
  8011af:	68 b3 2a 80 00       	push   $0x802ab3
  8011b4:	e8 21 f8 ff ff       	call   8009da <cprintf>
  8011b9:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  8011bc:	e8 d9 0a 00 00       	call   801c9a <sys_enable_interrupt>
			return;
  8011c1:	e9 9a 00 00 00       	jmp    801260 <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8011c6:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8011ca:	7e 34                	jle    801200 <atomic_readline+0xa6>
  8011cc:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8011d3:	7f 2b                	jg     801200 <atomic_readline+0xa6>
			if (echoing)
  8011d5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8011d9:	74 0e                	je     8011e9 <atomic_readline+0x8f>
				cputchar(c);
  8011db:	83 ec 0c             	sub    $0xc,%esp
  8011de:	ff 75 ec             	pushl  -0x14(%ebp)
  8011e1:	e8 64 f3 ff ff       	call   80054a <cputchar>
  8011e6:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8011e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011ec:	8d 50 01             	lea    0x1(%eax),%edx
  8011ef:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8011f2:	89 c2                	mov    %eax,%edx
  8011f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f7:	01 d0                	add    %edx,%eax
  8011f9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011fc:	88 10                	mov    %dl,(%eax)
  8011fe:	eb 5b                	jmp    80125b <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  801200:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801204:	75 1f                	jne    801225 <atomic_readline+0xcb>
  801206:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80120a:	7e 19                	jle    801225 <atomic_readline+0xcb>
			if (echoing)
  80120c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801210:	74 0e                	je     801220 <atomic_readline+0xc6>
				cputchar(c);
  801212:	83 ec 0c             	sub    $0xc,%esp
  801215:	ff 75 ec             	pushl  -0x14(%ebp)
  801218:	e8 2d f3 ff ff       	call   80054a <cputchar>
  80121d:	83 c4 10             	add    $0x10,%esp
			i--;
  801220:	ff 4d f4             	decl   -0xc(%ebp)
  801223:	eb 36                	jmp    80125b <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  801225:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801229:	74 0a                	je     801235 <atomic_readline+0xdb>
  80122b:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80122f:	0f 85 60 ff ff ff    	jne    801195 <atomic_readline+0x3b>
			if (echoing)
  801235:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801239:	74 0e                	je     801249 <atomic_readline+0xef>
				cputchar(c);
  80123b:	83 ec 0c             	sub    $0xc,%esp
  80123e:	ff 75 ec             	pushl  -0x14(%ebp)
  801241:	e8 04 f3 ff ff       	call   80054a <cputchar>
  801246:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  801249:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80124c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124f:	01 d0                	add    %edx,%eax
  801251:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  801254:	e8 41 0a 00 00       	call   801c9a <sys_enable_interrupt>
			return;
  801259:	eb 05                	jmp    801260 <atomic_readline+0x106>
		}
	}
  80125b:	e9 35 ff ff ff       	jmp    801195 <atomic_readline+0x3b>
}
  801260:	c9                   	leave  
  801261:	c3                   	ret    

00801262 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801262:	55                   	push   %ebp
  801263:	89 e5                	mov    %esp,%ebp
  801265:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801268:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80126f:	eb 06                	jmp    801277 <strlen+0x15>
		n++;
  801271:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801274:	ff 45 08             	incl   0x8(%ebp)
  801277:	8b 45 08             	mov    0x8(%ebp),%eax
  80127a:	8a 00                	mov    (%eax),%al
  80127c:	84 c0                	test   %al,%al
  80127e:	75 f1                	jne    801271 <strlen+0xf>
		n++;
	return n;
  801280:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801283:	c9                   	leave  
  801284:	c3                   	ret    

00801285 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801285:	55                   	push   %ebp
  801286:	89 e5                	mov    %esp,%ebp
  801288:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80128b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801292:	eb 09                	jmp    80129d <strnlen+0x18>
		n++;
  801294:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801297:	ff 45 08             	incl   0x8(%ebp)
  80129a:	ff 4d 0c             	decl   0xc(%ebp)
  80129d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012a1:	74 09                	je     8012ac <strnlen+0x27>
  8012a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a6:	8a 00                	mov    (%eax),%al
  8012a8:	84 c0                	test   %al,%al
  8012aa:	75 e8                	jne    801294 <strnlen+0xf>
		n++;
	return n;
  8012ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012af:	c9                   	leave  
  8012b0:	c3                   	ret    

008012b1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8012b1:	55                   	push   %ebp
  8012b2:	89 e5                	mov    %esp,%ebp
  8012b4:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8012b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8012bd:	90                   	nop
  8012be:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c1:	8d 50 01             	lea    0x1(%eax),%edx
  8012c4:	89 55 08             	mov    %edx,0x8(%ebp)
  8012c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ca:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012cd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8012d0:	8a 12                	mov    (%edx),%dl
  8012d2:	88 10                	mov    %dl,(%eax)
  8012d4:	8a 00                	mov    (%eax),%al
  8012d6:	84 c0                	test   %al,%al
  8012d8:	75 e4                	jne    8012be <strcpy+0xd>
		/* do nothing */;
	return ret;
  8012da:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012dd:	c9                   	leave  
  8012de:	c3                   	ret    

008012df <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8012df:	55                   	push   %ebp
  8012e0:	89 e5                	mov    %esp,%ebp
  8012e2:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8012e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8012eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012f2:	eb 1f                	jmp    801313 <strncpy+0x34>
		*dst++ = *src;
  8012f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f7:	8d 50 01             	lea    0x1(%eax),%edx
  8012fa:	89 55 08             	mov    %edx,0x8(%ebp)
  8012fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801300:	8a 12                	mov    (%edx),%dl
  801302:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801304:	8b 45 0c             	mov    0xc(%ebp),%eax
  801307:	8a 00                	mov    (%eax),%al
  801309:	84 c0                	test   %al,%al
  80130b:	74 03                	je     801310 <strncpy+0x31>
			src++;
  80130d:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801310:	ff 45 fc             	incl   -0x4(%ebp)
  801313:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801316:	3b 45 10             	cmp    0x10(%ebp),%eax
  801319:	72 d9                	jb     8012f4 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80131b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80131e:	c9                   	leave  
  80131f:	c3                   	ret    

00801320 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801320:	55                   	push   %ebp
  801321:	89 e5                	mov    %esp,%ebp
  801323:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801326:	8b 45 08             	mov    0x8(%ebp),%eax
  801329:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80132c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801330:	74 30                	je     801362 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801332:	eb 16                	jmp    80134a <strlcpy+0x2a>
			*dst++ = *src++;
  801334:	8b 45 08             	mov    0x8(%ebp),%eax
  801337:	8d 50 01             	lea    0x1(%eax),%edx
  80133a:	89 55 08             	mov    %edx,0x8(%ebp)
  80133d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801340:	8d 4a 01             	lea    0x1(%edx),%ecx
  801343:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801346:	8a 12                	mov    (%edx),%dl
  801348:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80134a:	ff 4d 10             	decl   0x10(%ebp)
  80134d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801351:	74 09                	je     80135c <strlcpy+0x3c>
  801353:	8b 45 0c             	mov    0xc(%ebp),%eax
  801356:	8a 00                	mov    (%eax),%al
  801358:	84 c0                	test   %al,%al
  80135a:	75 d8                	jne    801334 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80135c:	8b 45 08             	mov    0x8(%ebp),%eax
  80135f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801362:	8b 55 08             	mov    0x8(%ebp),%edx
  801365:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801368:	29 c2                	sub    %eax,%edx
  80136a:	89 d0                	mov    %edx,%eax
}
  80136c:	c9                   	leave  
  80136d:	c3                   	ret    

0080136e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80136e:	55                   	push   %ebp
  80136f:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801371:	eb 06                	jmp    801379 <strcmp+0xb>
		p++, q++;
  801373:	ff 45 08             	incl   0x8(%ebp)
  801376:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801379:	8b 45 08             	mov    0x8(%ebp),%eax
  80137c:	8a 00                	mov    (%eax),%al
  80137e:	84 c0                	test   %al,%al
  801380:	74 0e                	je     801390 <strcmp+0x22>
  801382:	8b 45 08             	mov    0x8(%ebp),%eax
  801385:	8a 10                	mov    (%eax),%dl
  801387:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138a:	8a 00                	mov    (%eax),%al
  80138c:	38 c2                	cmp    %al,%dl
  80138e:	74 e3                	je     801373 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801390:	8b 45 08             	mov    0x8(%ebp),%eax
  801393:	8a 00                	mov    (%eax),%al
  801395:	0f b6 d0             	movzbl %al,%edx
  801398:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139b:	8a 00                	mov    (%eax),%al
  80139d:	0f b6 c0             	movzbl %al,%eax
  8013a0:	29 c2                	sub    %eax,%edx
  8013a2:	89 d0                	mov    %edx,%eax
}
  8013a4:	5d                   	pop    %ebp
  8013a5:	c3                   	ret    

008013a6 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8013a6:	55                   	push   %ebp
  8013a7:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8013a9:	eb 09                	jmp    8013b4 <strncmp+0xe>
		n--, p++, q++;
  8013ab:	ff 4d 10             	decl   0x10(%ebp)
  8013ae:	ff 45 08             	incl   0x8(%ebp)
  8013b1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8013b4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013b8:	74 17                	je     8013d1 <strncmp+0x2b>
  8013ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bd:	8a 00                	mov    (%eax),%al
  8013bf:	84 c0                	test   %al,%al
  8013c1:	74 0e                	je     8013d1 <strncmp+0x2b>
  8013c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c6:	8a 10                	mov    (%eax),%dl
  8013c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013cb:	8a 00                	mov    (%eax),%al
  8013cd:	38 c2                	cmp    %al,%dl
  8013cf:	74 da                	je     8013ab <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8013d1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013d5:	75 07                	jne    8013de <strncmp+0x38>
		return 0;
  8013d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8013dc:	eb 14                	jmp    8013f2 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8013de:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e1:	8a 00                	mov    (%eax),%al
  8013e3:	0f b6 d0             	movzbl %al,%edx
  8013e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e9:	8a 00                	mov    (%eax),%al
  8013eb:	0f b6 c0             	movzbl %al,%eax
  8013ee:	29 c2                	sub    %eax,%edx
  8013f0:	89 d0                	mov    %edx,%eax
}
  8013f2:	5d                   	pop    %ebp
  8013f3:	c3                   	ret    

008013f4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8013f4:	55                   	push   %ebp
  8013f5:	89 e5                	mov    %esp,%ebp
  8013f7:	83 ec 04             	sub    $0x4,%esp
  8013fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013fd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801400:	eb 12                	jmp    801414 <strchr+0x20>
		if (*s == c)
  801402:	8b 45 08             	mov    0x8(%ebp),%eax
  801405:	8a 00                	mov    (%eax),%al
  801407:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80140a:	75 05                	jne    801411 <strchr+0x1d>
			return (char *) s;
  80140c:	8b 45 08             	mov    0x8(%ebp),%eax
  80140f:	eb 11                	jmp    801422 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801411:	ff 45 08             	incl   0x8(%ebp)
  801414:	8b 45 08             	mov    0x8(%ebp),%eax
  801417:	8a 00                	mov    (%eax),%al
  801419:	84 c0                	test   %al,%al
  80141b:	75 e5                	jne    801402 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80141d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801422:	c9                   	leave  
  801423:	c3                   	ret    

00801424 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801424:	55                   	push   %ebp
  801425:	89 e5                	mov    %esp,%ebp
  801427:	83 ec 04             	sub    $0x4,%esp
  80142a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801430:	eb 0d                	jmp    80143f <strfind+0x1b>
		if (*s == c)
  801432:	8b 45 08             	mov    0x8(%ebp),%eax
  801435:	8a 00                	mov    (%eax),%al
  801437:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80143a:	74 0e                	je     80144a <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80143c:	ff 45 08             	incl   0x8(%ebp)
  80143f:	8b 45 08             	mov    0x8(%ebp),%eax
  801442:	8a 00                	mov    (%eax),%al
  801444:	84 c0                	test   %al,%al
  801446:	75 ea                	jne    801432 <strfind+0xe>
  801448:	eb 01                	jmp    80144b <strfind+0x27>
		if (*s == c)
			break;
  80144a:	90                   	nop
	return (char *) s;
  80144b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80144e:	c9                   	leave  
  80144f:	c3                   	ret    

00801450 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801450:	55                   	push   %ebp
  801451:	89 e5                	mov    %esp,%ebp
  801453:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801456:	8b 45 08             	mov    0x8(%ebp),%eax
  801459:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80145c:	8b 45 10             	mov    0x10(%ebp),%eax
  80145f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801462:	eb 0e                	jmp    801472 <memset+0x22>
		*p++ = c;
  801464:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801467:	8d 50 01             	lea    0x1(%eax),%edx
  80146a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80146d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801470:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801472:	ff 4d f8             	decl   -0x8(%ebp)
  801475:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801479:	79 e9                	jns    801464 <memset+0x14>
		*p++ = c;

	return v;
  80147b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80147e:	c9                   	leave  
  80147f:	c3                   	ret    

00801480 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801480:	55                   	push   %ebp
  801481:	89 e5                	mov    %esp,%ebp
  801483:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801486:	8b 45 0c             	mov    0xc(%ebp),%eax
  801489:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80148c:	8b 45 08             	mov    0x8(%ebp),%eax
  80148f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801492:	eb 16                	jmp    8014aa <memcpy+0x2a>
		*d++ = *s++;
  801494:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801497:	8d 50 01             	lea    0x1(%eax),%edx
  80149a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80149d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014a0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014a3:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8014a6:	8a 12                	mov    (%edx),%dl
  8014a8:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8014aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ad:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014b0:	89 55 10             	mov    %edx,0x10(%ebp)
  8014b3:	85 c0                	test   %eax,%eax
  8014b5:	75 dd                	jne    801494 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8014b7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014ba:	c9                   	leave  
  8014bb:	c3                   	ret    

008014bc <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8014bc:	55                   	push   %ebp
  8014bd:	89 e5                	mov    %esp,%ebp
  8014bf:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8014c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8014ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014d1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8014d4:	73 50                	jae    801526 <memmove+0x6a>
  8014d6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014dc:	01 d0                	add    %edx,%eax
  8014de:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8014e1:	76 43                	jbe    801526 <memmove+0x6a>
		s += n;
  8014e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e6:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8014e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ec:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8014ef:	eb 10                	jmp    801501 <memmove+0x45>
			*--d = *--s;
  8014f1:	ff 4d f8             	decl   -0x8(%ebp)
  8014f4:	ff 4d fc             	decl   -0x4(%ebp)
  8014f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014fa:	8a 10                	mov    (%eax),%dl
  8014fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014ff:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801501:	8b 45 10             	mov    0x10(%ebp),%eax
  801504:	8d 50 ff             	lea    -0x1(%eax),%edx
  801507:	89 55 10             	mov    %edx,0x10(%ebp)
  80150a:	85 c0                	test   %eax,%eax
  80150c:	75 e3                	jne    8014f1 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80150e:	eb 23                	jmp    801533 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801510:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801513:	8d 50 01             	lea    0x1(%eax),%edx
  801516:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801519:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80151c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80151f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801522:	8a 12                	mov    (%edx),%dl
  801524:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801526:	8b 45 10             	mov    0x10(%ebp),%eax
  801529:	8d 50 ff             	lea    -0x1(%eax),%edx
  80152c:	89 55 10             	mov    %edx,0x10(%ebp)
  80152f:	85 c0                	test   %eax,%eax
  801531:	75 dd                	jne    801510 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801533:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801536:	c9                   	leave  
  801537:	c3                   	ret    

00801538 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801538:	55                   	push   %ebp
  801539:	89 e5                	mov    %esp,%ebp
  80153b:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80153e:	8b 45 08             	mov    0x8(%ebp),%eax
  801541:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801544:	8b 45 0c             	mov    0xc(%ebp),%eax
  801547:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80154a:	eb 2a                	jmp    801576 <memcmp+0x3e>
		if (*s1 != *s2)
  80154c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80154f:	8a 10                	mov    (%eax),%dl
  801551:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801554:	8a 00                	mov    (%eax),%al
  801556:	38 c2                	cmp    %al,%dl
  801558:	74 16                	je     801570 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80155a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80155d:	8a 00                	mov    (%eax),%al
  80155f:	0f b6 d0             	movzbl %al,%edx
  801562:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801565:	8a 00                	mov    (%eax),%al
  801567:	0f b6 c0             	movzbl %al,%eax
  80156a:	29 c2                	sub    %eax,%edx
  80156c:	89 d0                	mov    %edx,%eax
  80156e:	eb 18                	jmp    801588 <memcmp+0x50>
		s1++, s2++;
  801570:	ff 45 fc             	incl   -0x4(%ebp)
  801573:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801576:	8b 45 10             	mov    0x10(%ebp),%eax
  801579:	8d 50 ff             	lea    -0x1(%eax),%edx
  80157c:	89 55 10             	mov    %edx,0x10(%ebp)
  80157f:	85 c0                	test   %eax,%eax
  801581:	75 c9                	jne    80154c <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801583:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801588:	c9                   	leave  
  801589:	c3                   	ret    

0080158a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80158a:	55                   	push   %ebp
  80158b:	89 e5                	mov    %esp,%ebp
  80158d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801590:	8b 55 08             	mov    0x8(%ebp),%edx
  801593:	8b 45 10             	mov    0x10(%ebp),%eax
  801596:	01 d0                	add    %edx,%eax
  801598:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80159b:	eb 15                	jmp    8015b2 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80159d:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a0:	8a 00                	mov    (%eax),%al
  8015a2:	0f b6 d0             	movzbl %al,%edx
  8015a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a8:	0f b6 c0             	movzbl %al,%eax
  8015ab:	39 c2                	cmp    %eax,%edx
  8015ad:	74 0d                	je     8015bc <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8015af:	ff 45 08             	incl   0x8(%ebp)
  8015b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8015b8:	72 e3                	jb     80159d <memfind+0x13>
  8015ba:	eb 01                	jmp    8015bd <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8015bc:	90                   	nop
	return (void *) s;
  8015bd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015c0:	c9                   	leave  
  8015c1:	c3                   	ret    

008015c2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015c2:	55                   	push   %ebp
  8015c3:	89 e5                	mov    %esp,%ebp
  8015c5:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8015c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8015cf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015d6:	eb 03                	jmp    8015db <strtol+0x19>
		s++;
  8015d8:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015db:	8b 45 08             	mov    0x8(%ebp),%eax
  8015de:	8a 00                	mov    (%eax),%al
  8015e0:	3c 20                	cmp    $0x20,%al
  8015e2:	74 f4                	je     8015d8 <strtol+0x16>
  8015e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e7:	8a 00                	mov    (%eax),%al
  8015e9:	3c 09                	cmp    $0x9,%al
  8015eb:	74 eb                	je     8015d8 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f0:	8a 00                	mov    (%eax),%al
  8015f2:	3c 2b                	cmp    $0x2b,%al
  8015f4:	75 05                	jne    8015fb <strtol+0x39>
		s++;
  8015f6:	ff 45 08             	incl   0x8(%ebp)
  8015f9:	eb 13                	jmp    80160e <strtol+0x4c>
	else if (*s == '-')
  8015fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fe:	8a 00                	mov    (%eax),%al
  801600:	3c 2d                	cmp    $0x2d,%al
  801602:	75 0a                	jne    80160e <strtol+0x4c>
		s++, neg = 1;
  801604:	ff 45 08             	incl   0x8(%ebp)
  801607:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80160e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801612:	74 06                	je     80161a <strtol+0x58>
  801614:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801618:	75 20                	jne    80163a <strtol+0x78>
  80161a:	8b 45 08             	mov    0x8(%ebp),%eax
  80161d:	8a 00                	mov    (%eax),%al
  80161f:	3c 30                	cmp    $0x30,%al
  801621:	75 17                	jne    80163a <strtol+0x78>
  801623:	8b 45 08             	mov    0x8(%ebp),%eax
  801626:	40                   	inc    %eax
  801627:	8a 00                	mov    (%eax),%al
  801629:	3c 78                	cmp    $0x78,%al
  80162b:	75 0d                	jne    80163a <strtol+0x78>
		s += 2, base = 16;
  80162d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801631:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801638:	eb 28                	jmp    801662 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80163a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80163e:	75 15                	jne    801655 <strtol+0x93>
  801640:	8b 45 08             	mov    0x8(%ebp),%eax
  801643:	8a 00                	mov    (%eax),%al
  801645:	3c 30                	cmp    $0x30,%al
  801647:	75 0c                	jne    801655 <strtol+0x93>
		s++, base = 8;
  801649:	ff 45 08             	incl   0x8(%ebp)
  80164c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801653:	eb 0d                	jmp    801662 <strtol+0xa0>
	else if (base == 0)
  801655:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801659:	75 07                	jne    801662 <strtol+0xa0>
		base = 10;
  80165b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801662:	8b 45 08             	mov    0x8(%ebp),%eax
  801665:	8a 00                	mov    (%eax),%al
  801667:	3c 2f                	cmp    $0x2f,%al
  801669:	7e 19                	jle    801684 <strtol+0xc2>
  80166b:	8b 45 08             	mov    0x8(%ebp),%eax
  80166e:	8a 00                	mov    (%eax),%al
  801670:	3c 39                	cmp    $0x39,%al
  801672:	7f 10                	jg     801684 <strtol+0xc2>
			dig = *s - '0';
  801674:	8b 45 08             	mov    0x8(%ebp),%eax
  801677:	8a 00                	mov    (%eax),%al
  801679:	0f be c0             	movsbl %al,%eax
  80167c:	83 e8 30             	sub    $0x30,%eax
  80167f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801682:	eb 42                	jmp    8016c6 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801684:	8b 45 08             	mov    0x8(%ebp),%eax
  801687:	8a 00                	mov    (%eax),%al
  801689:	3c 60                	cmp    $0x60,%al
  80168b:	7e 19                	jle    8016a6 <strtol+0xe4>
  80168d:	8b 45 08             	mov    0x8(%ebp),%eax
  801690:	8a 00                	mov    (%eax),%al
  801692:	3c 7a                	cmp    $0x7a,%al
  801694:	7f 10                	jg     8016a6 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801696:	8b 45 08             	mov    0x8(%ebp),%eax
  801699:	8a 00                	mov    (%eax),%al
  80169b:	0f be c0             	movsbl %al,%eax
  80169e:	83 e8 57             	sub    $0x57,%eax
  8016a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016a4:	eb 20                	jmp    8016c6 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8016a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a9:	8a 00                	mov    (%eax),%al
  8016ab:	3c 40                	cmp    $0x40,%al
  8016ad:	7e 39                	jle    8016e8 <strtol+0x126>
  8016af:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b2:	8a 00                	mov    (%eax),%al
  8016b4:	3c 5a                	cmp    $0x5a,%al
  8016b6:	7f 30                	jg     8016e8 <strtol+0x126>
			dig = *s - 'A' + 10;
  8016b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bb:	8a 00                	mov    (%eax),%al
  8016bd:	0f be c0             	movsbl %al,%eax
  8016c0:	83 e8 37             	sub    $0x37,%eax
  8016c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8016c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c9:	3b 45 10             	cmp    0x10(%ebp),%eax
  8016cc:	7d 19                	jge    8016e7 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8016ce:	ff 45 08             	incl   0x8(%ebp)
  8016d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016d4:	0f af 45 10          	imul   0x10(%ebp),%eax
  8016d8:	89 c2                	mov    %eax,%edx
  8016da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016dd:	01 d0                	add    %edx,%eax
  8016df:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8016e2:	e9 7b ff ff ff       	jmp    801662 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8016e7:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8016e8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016ec:	74 08                	je     8016f6 <strtol+0x134>
		*endptr = (char *) s;
  8016ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8016f4:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8016f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8016fa:	74 07                	je     801703 <strtol+0x141>
  8016fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016ff:	f7 d8                	neg    %eax
  801701:	eb 03                	jmp    801706 <strtol+0x144>
  801703:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801706:	c9                   	leave  
  801707:	c3                   	ret    

00801708 <ltostr>:

void
ltostr(long value, char *str)
{
  801708:	55                   	push   %ebp
  801709:	89 e5                	mov    %esp,%ebp
  80170b:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80170e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801715:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80171c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801720:	79 13                	jns    801735 <ltostr+0x2d>
	{
		neg = 1;
  801722:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801729:	8b 45 0c             	mov    0xc(%ebp),%eax
  80172c:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80172f:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801732:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801735:	8b 45 08             	mov    0x8(%ebp),%eax
  801738:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80173d:	99                   	cltd   
  80173e:	f7 f9                	idiv   %ecx
  801740:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801743:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801746:	8d 50 01             	lea    0x1(%eax),%edx
  801749:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80174c:	89 c2                	mov    %eax,%edx
  80174e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801751:	01 d0                	add    %edx,%eax
  801753:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801756:	83 c2 30             	add    $0x30,%edx
  801759:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80175b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80175e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801763:	f7 e9                	imul   %ecx
  801765:	c1 fa 02             	sar    $0x2,%edx
  801768:	89 c8                	mov    %ecx,%eax
  80176a:	c1 f8 1f             	sar    $0x1f,%eax
  80176d:	29 c2                	sub    %eax,%edx
  80176f:	89 d0                	mov    %edx,%eax
  801771:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801774:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801777:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80177c:	f7 e9                	imul   %ecx
  80177e:	c1 fa 02             	sar    $0x2,%edx
  801781:	89 c8                	mov    %ecx,%eax
  801783:	c1 f8 1f             	sar    $0x1f,%eax
  801786:	29 c2                	sub    %eax,%edx
  801788:	89 d0                	mov    %edx,%eax
  80178a:	c1 e0 02             	shl    $0x2,%eax
  80178d:	01 d0                	add    %edx,%eax
  80178f:	01 c0                	add    %eax,%eax
  801791:	29 c1                	sub    %eax,%ecx
  801793:	89 ca                	mov    %ecx,%edx
  801795:	85 d2                	test   %edx,%edx
  801797:	75 9c                	jne    801735 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801799:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8017a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017a3:	48                   	dec    %eax
  8017a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8017a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8017ab:	74 3d                	je     8017ea <ltostr+0xe2>
		start = 1 ;
  8017ad:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8017b4:	eb 34                	jmp    8017ea <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8017b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017bc:	01 d0                	add    %edx,%eax
  8017be:	8a 00                	mov    (%eax),%al
  8017c0:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8017c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c9:	01 c2                	add    %eax,%edx
  8017cb:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8017ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d1:	01 c8                	add    %ecx,%eax
  8017d3:	8a 00                	mov    (%eax),%al
  8017d5:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8017d7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017dd:	01 c2                	add    %eax,%edx
  8017df:	8a 45 eb             	mov    -0x15(%ebp),%al
  8017e2:	88 02                	mov    %al,(%edx)
		start++ ;
  8017e4:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8017e7:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8017ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ed:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8017f0:	7c c4                	jl     8017b6 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8017f2:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8017f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f8:	01 d0                	add    %edx,%eax
  8017fa:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8017fd:	90                   	nop
  8017fe:	c9                   	leave  
  8017ff:	c3                   	ret    

00801800 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
  801803:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801806:	ff 75 08             	pushl  0x8(%ebp)
  801809:	e8 54 fa ff ff       	call   801262 <strlen>
  80180e:	83 c4 04             	add    $0x4,%esp
  801811:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801814:	ff 75 0c             	pushl  0xc(%ebp)
  801817:	e8 46 fa ff ff       	call   801262 <strlen>
  80181c:	83 c4 04             	add    $0x4,%esp
  80181f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801822:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801829:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801830:	eb 17                	jmp    801849 <strcconcat+0x49>
		final[s] = str1[s] ;
  801832:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801835:	8b 45 10             	mov    0x10(%ebp),%eax
  801838:	01 c2                	add    %eax,%edx
  80183a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80183d:	8b 45 08             	mov    0x8(%ebp),%eax
  801840:	01 c8                	add    %ecx,%eax
  801842:	8a 00                	mov    (%eax),%al
  801844:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801846:	ff 45 fc             	incl   -0x4(%ebp)
  801849:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80184c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80184f:	7c e1                	jl     801832 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801851:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801858:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80185f:	eb 1f                	jmp    801880 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801861:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801864:	8d 50 01             	lea    0x1(%eax),%edx
  801867:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80186a:	89 c2                	mov    %eax,%edx
  80186c:	8b 45 10             	mov    0x10(%ebp),%eax
  80186f:	01 c2                	add    %eax,%edx
  801871:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801874:	8b 45 0c             	mov    0xc(%ebp),%eax
  801877:	01 c8                	add    %ecx,%eax
  801879:	8a 00                	mov    (%eax),%al
  80187b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80187d:	ff 45 f8             	incl   -0x8(%ebp)
  801880:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801883:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801886:	7c d9                	jl     801861 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801888:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80188b:	8b 45 10             	mov    0x10(%ebp),%eax
  80188e:	01 d0                	add    %edx,%eax
  801890:	c6 00 00             	movb   $0x0,(%eax)
}
  801893:	90                   	nop
  801894:	c9                   	leave  
  801895:	c3                   	ret    

00801896 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801896:	55                   	push   %ebp
  801897:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801899:	8b 45 14             	mov    0x14(%ebp),%eax
  80189c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8018a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8018a5:	8b 00                	mov    (%eax),%eax
  8018a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8018b1:	01 d0                	add    %edx,%eax
  8018b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018b9:	eb 0c                	jmp    8018c7 <strsplit+0x31>
			*string++ = 0;
  8018bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018be:	8d 50 01             	lea    0x1(%eax),%edx
  8018c1:	89 55 08             	mov    %edx,0x8(%ebp)
  8018c4:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ca:	8a 00                	mov    (%eax),%al
  8018cc:	84 c0                	test   %al,%al
  8018ce:	74 18                	je     8018e8 <strsplit+0x52>
  8018d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d3:	8a 00                	mov    (%eax),%al
  8018d5:	0f be c0             	movsbl %al,%eax
  8018d8:	50                   	push   %eax
  8018d9:	ff 75 0c             	pushl  0xc(%ebp)
  8018dc:	e8 13 fb ff ff       	call   8013f4 <strchr>
  8018e1:	83 c4 08             	add    $0x8,%esp
  8018e4:	85 c0                	test   %eax,%eax
  8018e6:	75 d3                	jne    8018bb <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8018e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018eb:	8a 00                	mov    (%eax),%al
  8018ed:	84 c0                	test   %al,%al
  8018ef:	74 5a                	je     80194b <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8018f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8018f4:	8b 00                	mov    (%eax),%eax
  8018f6:	83 f8 0f             	cmp    $0xf,%eax
  8018f9:	75 07                	jne    801902 <strsplit+0x6c>
		{
			return 0;
  8018fb:	b8 00 00 00 00       	mov    $0x0,%eax
  801900:	eb 66                	jmp    801968 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801902:	8b 45 14             	mov    0x14(%ebp),%eax
  801905:	8b 00                	mov    (%eax),%eax
  801907:	8d 48 01             	lea    0x1(%eax),%ecx
  80190a:	8b 55 14             	mov    0x14(%ebp),%edx
  80190d:	89 0a                	mov    %ecx,(%edx)
  80190f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801916:	8b 45 10             	mov    0x10(%ebp),%eax
  801919:	01 c2                	add    %eax,%edx
  80191b:	8b 45 08             	mov    0x8(%ebp),%eax
  80191e:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801920:	eb 03                	jmp    801925 <strsplit+0x8f>
			string++;
  801922:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801925:	8b 45 08             	mov    0x8(%ebp),%eax
  801928:	8a 00                	mov    (%eax),%al
  80192a:	84 c0                	test   %al,%al
  80192c:	74 8b                	je     8018b9 <strsplit+0x23>
  80192e:	8b 45 08             	mov    0x8(%ebp),%eax
  801931:	8a 00                	mov    (%eax),%al
  801933:	0f be c0             	movsbl %al,%eax
  801936:	50                   	push   %eax
  801937:	ff 75 0c             	pushl  0xc(%ebp)
  80193a:	e8 b5 fa ff ff       	call   8013f4 <strchr>
  80193f:	83 c4 08             	add    $0x8,%esp
  801942:	85 c0                	test   %eax,%eax
  801944:	74 dc                	je     801922 <strsplit+0x8c>
			string++;
	}
  801946:	e9 6e ff ff ff       	jmp    8018b9 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80194b:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80194c:	8b 45 14             	mov    0x14(%ebp),%eax
  80194f:	8b 00                	mov    (%eax),%eax
  801951:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801958:	8b 45 10             	mov    0x10(%ebp),%eax
  80195b:	01 d0                	add    %edx,%eax
  80195d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801963:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801968:	c9                   	leave  
  801969:	c3                   	ret    

0080196a <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80196a:	55                   	push   %ebp
  80196b:	89 e5                	mov    %esp,%ebp
  80196d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  801970:	83 ec 04             	sub    $0x4,%esp
  801973:	68 c4 2a 80 00       	push   $0x802ac4
  801978:	6a 0e                	push   $0xe
  80197a:	68 fe 2a 80 00       	push   $0x802afe
  80197f:	e8 a2 ed ff ff       	call   800726 <_panic>

00801984 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  801984:	55                   	push   %ebp
  801985:	89 e5                	mov    %esp,%ebp
  801987:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  80198a:	a1 04 30 80 00       	mov    0x803004,%eax
  80198f:	85 c0                	test   %eax,%eax
  801991:	74 0f                	je     8019a2 <malloc+0x1e>
	{
		initialize_dyn_block_system();
  801993:	e8 d2 ff ff ff       	call   80196a <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801998:	c7 05 04 30 80 00 00 	movl   $0x0,0x803004
  80199f:	00 00 00 
	}
	if (size == 0) return NULL ;
  8019a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8019a6:	75 07                	jne    8019af <malloc+0x2b>
  8019a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ad:	eb 14                	jmp    8019c3 <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8019af:	83 ec 04             	sub    $0x4,%esp
  8019b2:	68 0c 2b 80 00       	push   $0x802b0c
  8019b7:	6a 2e                	push   $0x2e
  8019b9:	68 fe 2a 80 00       	push   $0x802afe
  8019be:	e8 63 ed ff ff       	call   800726 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  8019c3:	c9                   	leave  
  8019c4:	c3                   	ret    

008019c5 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8019c5:	55                   	push   %ebp
  8019c6:	89 e5                	mov    %esp,%ebp
  8019c8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  8019cb:	83 ec 04             	sub    $0x4,%esp
  8019ce:	68 34 2b 80 00       	push   $0x802b34
  8019d3:	6a 49                	push   $0x49
  8019d5:	68 fe 2a 80 00       	push   $0x802afe
  8019da:	e8 47 ed ff ff       	call   800726 <_panic>

008019df <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8019df:	55                   	push   %ebp
  8019e0:	89 e5                	mov    %esp,%ebp
  8019e2:	83 ec 18             	sub    $0x18,%esp
  8019e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8019e8:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  8019eb:	83 ec 04             	sub    $0x4,%esp
  8019ee:	68 58 2b 80 00       	push   $0x802b58
  8019f3:	6a 57                	push   $0x57
  8019f5:	68 fe 2a 80 00       	push   $0x802afe
  8019fa:	e8 27 ed ff ff       	call   800726 <_panic>

008019ff <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8019ff:	55                   	push   %ebp
  801a00:	89 e5                	mov    %esp,%ebp
  801a02:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801a05:	83 ec 04             	sub    $0x4,%esp
  801a08:	68 80 2b 80 00       	push   $0x802b80
  801a0d:	6a 60                	push   $0x60
  801a0f:	68 fe 2a 80 00       	push   $0x802afe
  801a14:	e8 0d ed ff ff       	call   800726 <_panic>

00801a19 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801a19:	55                   	push   %ebp
  801a1a:	89 e5                	mov    %esp,%ebp
  801a1c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801a1f:	83 ec 04             	sub    $0x4,%esp
  801a22:	68 a4 2b 80 00       	push   $0x802ba4
  801a27:	6a 7c                	push   $0x7c
  801a29:	68 fe 2a 80 00       	push   $0x802afe
  801a2e:	e8 f3 ec ff ff       	call   800726 <_panic>

00801a33 <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  801a33:	55                   	push   %ebp
  801a34:	89 e5                	mov    %esp,%ebp
  801a36:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801a39:	83 ec 04             	sub    $0x4,%esp
  801a3c:	68 cc 2b 80 00       	push   $0x802bcc
  801a41:	68 86 00 00 00       	push   $0x86
  801a46:	68 fe 2a 80 00       	push   $0x802afe
  801a4b:	e8 d6 ec ff ff       	call   800726 <_panic>

00801a50 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801a50:	55                   	push   %ebp
  801a51:	89 e5                	mov    %esp,%ebp
  801a53:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a56:	83 ec 04             	sub    $0x4,%esp
  801a59:	68 f0 2b 80 00       	push   $0x802bf0
  801a5e:	68 91 00 00 00       	push   $0x91
  801a63:	68 fe 2a 80 00       	push   $0x802afe
  801a68:	e8 b9 ec ff ff       	call   800726 <_panic>

00801a6d <shrink>:

}
void shrink(uint32 newSize)
{
  801a6d:	55                   	push   %ebp
  801a6e:	89 e5                	mov    %esp,%ebp
  801a70:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a73:	83 ec 04             	sub    $0x4,%esp
  801a76:	68 f0 2b 80 00       	push   $0x802bf0
  801a7b:	68 96 00 00 00       	push   $0x96
  801a80:	68 fe 2a 80 00       	push   $0x802afe
  801a85:	e8 9c ec ff ff       	call   800726 <_panic>

00801a8a <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801a8a:	55                   	push   %ebp
  801a8b:	89 e5                	mov    %esp,%ebp
  801a8d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a90:	83 ec 04             	sub    $0x4,%esp
  801a93:	68 f0 2b 80 00       	push   $0x802bf0
  801a98:	68 9b 00 00 00       	push   $0x9b
  801a9d:	68 fe 2a 80 00       	push   $0x802afe
  801aa2:	e8 7f ec ff ff       	call   800726 <_panic>

00801aa7 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801aa7:	55                   	push   %ebp
  801aa8:	89 e5                	mov    %esp,%ebp
  801aaa:	57                   	push   %edi
  801aab:	56                   	push   %esi
  801aac:	53                   	push   %ebx
  801aad:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ab9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801abc:	8b 7d 18             	mov    0x18(%ebp),%edi
  801abf:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801ac2:	cd 30                	int    $0x30
  801ac4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801ac7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801aca:	83 c4 10             	add    $0x10,%esp
  801acd:	5b                   	pop    %ebx
  801ace:	5e                   	pop    %esi
  801acf:	5f                   	pop    %edi
  801ad0:	5d                   	pop    %ebp
  801ad1:	c3                   	ret    

00801ad2 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801ad2:	55                   	push   %ebp
  801ad3:	89 e5                	mov    %esp,%ebp
  801ad5:	83 ec 04             	sub    $0x4,%esp
  801ad8:	8b 45 10             	mov    0x10(%ebp),%eax
  801adb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801ade:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	52                   	push   %edx
  801aea:	ff 75 0c             	pushl  0xc(%ebp)
  801aed:	50                   	push   %eax
  801aee:	6a 00                	push   $0x0
  801af0:	e8 b2 ff ff ff       	call   801aa7 <syscall>
  801af5:	83 c4 18             	add    $0x18,%esp
}
  801af8:	90                   	nop
  801af9:	c9                   	leave  
  801afa:	c3                   	ret    

00801afb <sys_cgetc>:

int
sys_cgetc(void)
{
  801afb:	55                   	push   %ebp
  801afc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	6a 01                	push   $0x1
  801b0a:	e8 98 ff ff ff       	call   801aa7 <syscall>
  801b0f:	83 c4 18             	add    $0x18,%esp
}
  801b12:	c9                   	leave  
  801b13:	c3                   	ret    

00801b14 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801b14:	55                   	push   %ebp
  801b15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b17:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	52                   	push   %edx
  801b24:	50                   	push   %eax
  801b25:	6a 05                	push   $0x5
  801b27:	e8 7b ff ff ff       	call   801aa7 <syscall>
  801b2c:	83 c4 18             	add    $0x18,%esp
}
  801b2f:	c9                   	leave  
  801b30:	c3                   	ret    

00801b31 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b31:	55                   	push   %ebp
  801b32:	89 e5                	mov    %esp,%ebp
  801b34:	56                   	push   %esi
  801b35:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b36:	8b 75 18             	mov    0x18(%ebp),%esi
  801b39:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b3c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b42:	8b 45 08             	mov    0x8(%ebp),%eax
  801b45:	56                   	push   %esi
  801b46:	53                   	push   %ebx
  801b47:	51                   	push   %ecx
  801b48:	52                   	push   %edx
  801b49:	50                   	push   %eax
  801b4a:	6a 06                	push   $0x6
  801b4c:	e8 56 ff ff ff       	call   801aa7 <syscall>
  801b51:	83 c4 18             	add    $0x18,%esp
}
  801b54:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b57:	5b                   	pop    %ebx
  801b58:	5e                   	pop    %esi
  801b59:	5d                   	pop    %ebp
  801b5a:	c3                   	ret    

00801b5b <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801b5b:	55                   	push   %ebp
  801b5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801b5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b61:	8b 45 08             	mov    0x8(%ebp),%eax
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	52                   	push   %edx
  801b6b:	50                   	push   %eax
  801b6c:	6a 07                	push   $0x7
  801b6e:	e8 34 ff ff ff       	call   801aa7 <syscall>
  801b73:	83 c4 18             	add    $0x18,%esp
}
  801b76:	c9                   	leave  
  801b77:	c3                   	ret    

00801b78 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b78:	55                   	push   %ebp
  801b79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	ff 75 0c             	pushl  0xc(%ebp)
  801b84:	ff 75 08             	pushl  0x8(%ebp)
  801b87:	6a 08                	push   $0x8
  801b89:	e8 19 ff ff ff       	call   801aa7 <syscall>
  801b8e:	83 c4 18             	add    $0x18,%esp
}
  801b91:	c9                   	leave  
  801b92:	c3                   	ret    

00801b93 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801b93:	55                   	push   %ebp
  801b94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 09                	push   $0x9
  801ba2:	e8 00 ff ff ff       	call   801aa7 <syscall>
  801ba7:	83 c4 18             	add    $0x18,%esp
}
  801baa:	c9                   	leave  
  801bab:	c3                   	ret    

00801bac <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801bac:	55                   	push   %ebp
  801bad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 0a                	push   $0xa
  801bbb:	e8 e7 fe ff ff       	call   801aa7 <syscall>
  801bc0:	83 c4 18             	add    $0x18,%esp
}
  801bc3:	c9                   	leave  
  801bc4:	c3                   	ret    

00801bc5 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801bc5:	55                   	push   %ebp
  801bc6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 0b                	push   $0xb
  801bd4:	e8 ce fe ff ff       	call   801aa7 <syscall>
  801bd9:	83 c4 18             	add    $0x18,%esp
}
  801bdc:	c9                   	leave  
  801bdd:	c3                   	ret    

00801bde <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801bde:	55                   	push   %ebp
  801bdf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	ff 75 0c             	pushl  0xc(%ebp)
  801bea:	ff 75 08             	pushl  0x8(%ebp)
  801bed:	6a 0f                	push   $0xf
  801bef:	e8 b3 fe ff ff       	call   801aa7 <syscall>
  801bf4:	83 c4 18             	add    $0x18,%esp
	return;
  801bf7:	90                   	nop
}
  801bf8:	c9                   	leave  
  801bf9:	c3                   	ret    

00801bfa <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801bfa:	55                   	push   %ebp
  801bfb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	ff 75 0c             	pushl  0xc(%ebp)
  801c06:	ff 75 08             	pushl  0x8(%ebp)
  801c09:	6a 10                	push   $0x10
  801c0b:	e8 97 fe ff ff       	call   801aa7 <syscall>
  801c10:	83 c4 18             	add    $0x18,%esp
	return ;
  801c13:	90                   	nop
}
  801c14:	c9                   	leave  
  801c15:	c3                   	ret    

00801c16 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801c16:	55                   	push   %ebp
  801c17:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	ff 75 10             	pushl  0x10(%ebp)
  801c20:	ff 75 0c             	pushl  0xc(%ebp)
  801c23:	ff 75 08             	pushl  0x8(%ebp)
  801c26:	6a 11                	push   $0x11
  801c28:	e8 7a fe ff ff       	call   801aa7 <syscall>
  801c2d:	83 c4 18             	add    $0x18,%esp
	return ;
  801c30:	90                   	nop
}
  801c31:	c9                   	leave  
  801c32:	c3                   	ret    

00801c33 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801c33:	55                   	push   %ebp
  801c34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 0c                	push   $0xc
  801c42:	e8 60 fe ff ff       	call   801aa7 <syscall>
  801c47:	83 c4 18             	add    $0x18,%esp
}
  801c4a:	c9                   	leave  
  801c4b:	c3                   	ret    

00801c4c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c4c:	55                   	push   %ebp
  801c4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	ff 75 08             	pushl  0x8(%ebp)
  801c5a:	6a 0d                	push   $0xd
  801c5c:	e8 46 fe ff ff       	call   801aa7 <syscall>
  801c61:	83 c4 18             	add    $0x18,%esp
}
  801c64:	c9                   	leave  
  801c65:	c3                   	ret    

00801c66 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c66:	55                   	push   %ebp
  801c67:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	6a 0e                	push   $0xe
  801c75:	e8 2d fe ff ff       	call   801aa7 <syscall>
  801c7a:	83 c4 18             	add    $0x18,%esp
}
  801c7d:	90                   	nop
  801c7e:	c9                   	leave  
  801c7f:	c3                   	ret    

00801c80 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801c80:	55                   	push   %ebp
  801c81:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 13                	push   $0x13
  801c8f:	e8 13 fe ff ff       	call   801aa7 <syscall>
  801c94:	83 c4 18             	add    $0x18,%esp
}
  801c97:	90                   	nop
  801c98:	c9                   	leave  
  801c99:	c3                   	ret    

00801c9a <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801c9a:	55                   	push   %ebp
  801c9b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 14                	push   $0x14
  801ca9:	e8 f9 fd ff ff       	call   801aa7 <syscall>
  801cae:	83 c4 18             	add    $0x18,%esp
}
  801cb1:	90                   	nop
  801cb2:	c9                   	leave  
  801cb3:	c3                   	ret    

00801cb4 <sys_cputc>:


void
sys_cputc(const char c)
{
  801cb4:	55                   	push   %ebp
  801cb5:	89 e5                	mov    %esp,%ebp
  801cb7:	83 ec 04             	sub    $0x4,%esp
  801cba:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801cc0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 00                	push   $0x0
  801ccc:	50                   	push   %eax
  801ccd:	6a 15                	push   $0x15
  801ccf:	e8 d3 fd ff ff       	call   801aa7 <syscall>
  801cd4:	83 c4 18             	add    $0x18,%esp
}
  801cd7:	90                   	nop
  801cd8:	c9                   	leave  
  801cd9:	c3                   	ret    

00801cda <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801cda:	55                   	push   %ebp
  801cdb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801cdd:	6a 00                	push   $0x0
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 16                	push   $0x16
  801ce9:	e8 b9 fd ff ff       	call   801aa7 <syscall>
  801cee:	83 c4 18             	add    $0x18,%esp
}
  801cf1:	90                   	nop
  801cf2:	c9                   	leave  
  801cf3:	c3                   	ret    

00801cf4 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801cf4:	55                   	push   %ebp
  801cf5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	ff 75 0c             	pushl  0xc(%ebp)
  801d03:	50                   	push   %eax
  801d04:	6a 17                	push   $0x17
  801d06:	e8 9c fd ff ff       	call   801aa7 <syscall>
  801d0b:	83 c4 18             	add    $0x18,%esp
}
  801d0e:	c9                   	leave  
  801d0f:	c3                   	ret    

00801d10 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801d10:	55                   	push   %ebp
  801d11:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d13:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d16:	8b 45 08             	mov    0x8(%ebp),%eax
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 00                	push   $0x0
  801d1f:	52                   	push   %edx
  801d20:	50                   	push   %eax
  801d21:	6a 1a                	push   $0x1a
  801d23:	e8 7f fd ff ff       	call   801aa7 <syscall>
  801d28:	83 c4 18             	add    $0x18,%esp
}
  801d2b:	c9                   	leave  
  801d2c:	c3                   	ret    

00801d2d <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d2d:	55                   	push   %ebp
  801d2e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d30:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d33:	8b 45 08             	mov    0x8(%ebp),%eax
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	52                   	push   %edx
  801d3d:	50                   	push   %eax
  801d3e:	6a 18                	push   $0x18
  801d40:	e8 62 fd ff ff       	call   801aa7 <syscall>
  801d45:	83 c4 18             	add    $0x18,%esp
}
  801d48:	90                   	nop
  801d49:	c9                   	leave  
  801d4a:	c3                   	ret    

00801d4b <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d4b:	55                   	push   %ebp
  801d4c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d51:	8b 45 08             	mov    0x8(%ebp),%eax
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	52                   	push   %edx
  801d5b:	50                   	push   %eax
  801d5c:	6a 19                	push   $0x19
  801d5e:	e8 44 fd ff ff       	call   801aa7 <syscall>
  801d63:	83 c4 18             	add    $0x18,%esp
}
  801d66:	90                   	nop
  801d67:	c9                   	leave  
  801d68:	c3                   	ret    

00801d69 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801d69:	55                   	push   %ebp
  801d6a:	89 e5                	mov    %esp,%ebp
  801d6c:	83 ec 04             	sub    $0x4,%esp
  801d6f:	8b 45 10             	mov    0x10(%ebp),%eax
  801d72:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801d75:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d78:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7f:	6a 00                	push   $0x0
  801d81:	51                   	push   %ecx
  801d82:	52                   	push   %edx
  801d83:	ff 75 0c             	pushl  0xc(%ebp)
  801d86:	50                   	push   %eax
  801d87:	6a 1b                	push   $0x1b
  801d89:	e8 19 fd ff ff       	call   801aa7 <syscall>
  801d8e:	83 c4 18             	add    $0x18,%esp
}
  801d91:	c9                   	leave  
  801d92:	c3                   	ret    

00801d93 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801d93:	55                   	push   %ebp
  801d94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801d96:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d99:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9c:	6a 00                	push   $0x0
  801d9e:	6a 00                	push   $0x0
  801da0:	6a 00                	push   $0x0
  801da2:	52                   	push   %edx
  801da3:	50                   	push   %eax
  801da4:	6a 1c                	push   $0x1c
  801da6:	e8 fc fc ff ff       	call   801aa7 <syscall>
  801dab:	83 c4 18             	add    $0x18,%esp
}
  801dae:	c9                   	leave  
  801daf:	c3                   	ret    

00801db0 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801db0:	55                   	push   %ebp
  801db1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801db3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801db6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801db9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	51                   	push   %ecx
  801dc1:	52                   	push   %edx
  801dc2:	50                   	push   %eax
  801dc3:	6a 1d                	push   $0x1d
  801dc5:	e8 dd fc ff ff       	call   801aa7 <syscall>
  801dca:	83 c4 18             	add    $0x18,%esp
}
  801dcd:	c9                   	leave  
  801dce:	c3                   	ret    

00801dcf <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801dcf:	55                   	push   %ebp
  801dd0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801dd2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	52                   	push   %edx
  801ddf:	50                   	push   %eax
  801de0:	6a 1e                	push   $0x1e
  801de2:	e8 c0 fc ff ff       	call   801aa7 <syscall>
  801de7:	83 c4 18             	add    $0x18,%esp
}
  801dea:	c9                   	leave  
  801deb:	c3                   	ret    

00801dec <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801dec:	55                   	push   %ebp
  801ded:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801def:	6a 00                	push   $0x0
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	6a 1f                	push   $0x1f
  801dfb:	e8 a7 fc ff ff       	call   801aa7 <syscall>
  801e00:	83 c4 18             	add    $0x18,%esp
}
  801e03:	c9                   	leave  
  801e04:	c3                   	ret    

00801e05 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801e05:	55                   	push   %ebp
  801e06:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801e08:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0b:	6a 00                	push   $0x0
  801e0d:	ff 75 14             	pushl  0x14(%ebp)
  801e10:	ff 75 10             	pushl  0x10(%ebp)
  801e13:	ff 75 0c             	pushl  0xc(%ebp)
  801e16:	50                   	push   %eax
  801e17:	6a 20                	push   $0x20
  801e19:	e8 89 fc ff ff       	call   801aa7 <syscall>
  801e1e:	83 c4 18             	add    $0x18,%esp
}
  801e21:	c9                   	leave  
  801e22:	c3                   	ret    

00801e23 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801e23:	55                   	push   %ebp
  801e24:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801e26:	8b 45 08             	mov    0x8(%ebp),%eax
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	50                   	push   %eax
  801e32:	6a 21                	push   $0x21
  801e34:	e8 6e fc ff ff       	call   801aa7 <syscall>
  801e39:	83 c4 18             	add    $0x18,%esp
}
  801e3c:	90                   	nop
  801e3d:	c9                   	leave  
  801e3e:	c3                   	ret    

00801e3f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801e3f:	55                   	push   %ebp
  801e40:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801e42:	8b 45 08             	mov    0x8(%ebp),%eax
  801e45:	6a 00                	push   $0x0
  801e47:	6a 00                	push   $0x0
  801e49:	6a 00                	push   $0x0
  801e4b:	6a 00                	push   $0x0
  801e4d:	50                   	push   %eax
  801e4e:	6a 22                	push   $0x22
  801e50:	e8 52 fc ff ff       	call   801aa7 <syscall>
  801e55:	83 c4 18             	add    $0x18,%esp
}
  801e58:	c9                   	leave  
  801e59:	c3                   	ret    

00801e5a <sys_getenvid>:

int32 sys_getenvid(void)
{
  801e5a:	55                   	push   %ebp
  801e5b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 00                	push   $0x0
  801e63:	6a 00                	push   $0x0
  801e65:	6a 00                	push   $0x0
  801e67:	6a 02                	push   $0x2
  801e69:	e8 39 fc ff ff       	call   801aa7 <syscall>
  801e6e:	83 c4 18             	add    $0x18,%esp
}
  801e71:	c9                   	leave  
  801e72:	c3                   	ret    

00801e73 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801e73:	55                   	push   %ebp
  801e74:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801e76:	6a 00                	push   $0x0
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 00                	push   $0x0
  801e7c:	6a 00                	push   $0x0
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 03                	push   $0x3
  801e82:	e8 20 fc ff ff       	call   801aa7 <syscall>
  801e87:	83 c4 18             	add    $0x18,%esp
}
  801e8a:	c9                   	leave  
  801e8b:	c3                   	ret    

00801e8c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801e8c:	55                   	push   %ebp
  801e8d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801e8f:	6a 00                	push   $0x0
  801e91:	6a 00                	push   $0x0
  801e93:	6a 00                	push   $0x0
  801e95:	6a 00                	push   $0x0
  801e97:	6a 00                	push   $0x0
  801e99:	6a 04                	push   $0x4
  801e9b:	e8 07 fc ff ff       	call   801aa7 <syscall>
  801ea0:	83 c4 18             	add    $0x18,%esp
}
  801ea3:	c9                   	leave  
  801ea4:	c3                   	ret    

00801ea5 <sys_exit_env>:


void sys_exit_env(void)
{
  801ea5:	55                   	push   %ebp
  801ea6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ea8:	6a 00                	push   $0x0
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 00                	push   $0x0
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 23                	push   $0x23
  801eb4:	e8 ee fb ff ff       	call   801aa7 <syscall>
  801eb9:	83 c4 18             	add    $0x18,%esp
}
  801ebc:	90                   	nop
  801ebd:	c9                   	leave  
  801ebe:	c3                   	ret    

00801ebf <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801ebf:	55                   	push   %ebp
  801ec0:	89 e5                	mov    %esp,%ebp
  801ec2:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ec5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ec8:	8d 50 04             	lea    0x4(%eax),%edx
  801ecb:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	52                   	push   %edx
  801ed5:	50                   	push   %eax
  801ed6:	6a 24                	push   $0x24
  801ed8:	e8 ca fb ff ff       	call   801aa7 <syscall>
  801edd:	83 c4 18             	add    $0x18,%esp
	return result;
  801ee0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ee3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ee6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ee9:	89 01                	mov    %eax,(%ecx)
  801eeb:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801eee:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef1:	c9                   	leave  
  801ef2:	c2 04 00             	ret    $0x4

00801ef5 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801ef5:	55                   	push   %ebp
  801ef6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ef8:	6a 00                	push   $0x0
  801efa:	6a 00                	push   $0x0
  801efc:	ff 75 10             	pushl  0x10(%ebp)
  801eff:	ff 75 0c             	pushl  0xc(%ebp)
  801f02:	ff 75 08             	pushl  0x8(%ebp)
  801f05:	6a 12                	push   $0x12
  801f07:	e8 9b fb ff ff       	call   801aa7 <syscall>
  801f0c:	83 c4 18             	add    $0x18,%esp
	return ;
  801f0f:	90                   	nop
}
  801f10:	c9                   	leave  
  801f11:	c3                   	ret    

00801f12 <sys_rcr2>:
uint32 sys_rcr2()
{
  801f12:	55                   	push   %ebp
  801f13:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801f15:	6a 00                	push   $0x0
  801f17:	6a 00                	push   $0x0
  801f19:	6a 00                	push   $0x0
  801f1b:	6a 00                	push   $0x0
  801f1d:	6a 00                	push   $0x0
  801f1f:	6a 25                	push   $0x25
  801f21:	e8 81 fb ff ff       	call   801aa7 <syscall>
  801f26:	83 c4 18             	add    $0x18,%esp
}
  801f29:	c9                   	leave  
  801f2a:	c3                   	ret    

00801f2b <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801f2b:	55                   	push   %ebp
  801f2c:	89 e5                	mov    %esp,%ebp
  801f2e:	83 ec 04             	sub    $0x4,%esp
  801f31:	8b 45 08             	mov    0x8(%ebp),%eax
  801f34:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801f37:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801f3b:	6a 00                	push   $0x0
  801f3d:	6a 00                	push   $0x0
  801f3f:	6a 00                	push   $0x0
  801f41:	6a 00                	push   $0x0
  801f43:	50                   	push   %eax
  801f44:	6a 26                	push   $0x26
  801f46:	e8 5c fb ff ff       	call   801aa7 <syscall>
  801f4b:	83 c4 18             	add    $0x18,%esp
	return ;
  801f4e:	90                   	nop
}
  801f4f:	c9                   	leave  
  801f50:	c3                   	ret    

00801f51 <rsttst>:
void rsttst()
{
  801f51:	55                   	push   %ebp
  801f52:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801f54:	6a 00                	push   $0x0
  801f56:	6a 00                	push   $0x0
  801f58:	6a 00                	push   $0x0
  801f5a:	6a 00                	push   $0x0
  801f5c:	6a 00                	push   $0x0
  801f5e:	6a 28                	push   $0x28
  801f60:	e8 42 fb ff ff       	call   801aa7 <syscall>
  801f65:	83 c4 18             	add    $0x18,%esp
	return ;
  801f68:	90                   	nop
}
  801f69:	c9                   	leave  
  801f6a:	c3                   	ret    

00801f6b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801f6b:	55                   	push   %ebp
  801f6c:	89 e5                	mov    %esp,%ebp
  801f6e:	83 ec 04             	sub    $0x4,%esp
  801f71:	8b 45 14             	mov    0x14(%ebp),%eax
  801f74:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801f77:	8b 55 18             	mov    0x18(%ebp),%edx
  801f7a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f7e:	52                   	push   %edx
  801f7f:	50                   	push   %eax
  801f80:	ff 75 10             	pushl  0x10(%ebp)
  801f83:	ff 75 0c             	pushl  0xc(%ebp)
  801f86:	ff 75 08             	pushl  0x8(%ebp)
  801f89:	6a 27                	push   $0x27
  801f8b:	e8 17 fb ff ff       	call   801aa7 <syscall>
  801f90:	83 c4 18             	add    $0x18,%esp
	return ;
  801f93:	90                   	nop
}
  801f94:	c9                   	leave  
  801f95:	c3                   	ret    

00801f96 <chktst>:
void chktst(uint32 n)
{
  801f96:	55                   	push   %ebp
  801f97:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801f99:	6a 00                	push   $0x0
  801f9b:	6a 00                	push   $0x0
  801f9d:	6a 00                	push   $0x0
  801f9f:	6a 00                	push   $0x0
  801fa1:	ff 75 08             	pushl  0x8(%ebp)
  801fa4:	6a 29                	push   $0x29
  801fa6:	e8 fc fa ff ff       	call   801aa7 <syscall>
  801fab:	83 c4 18             	add    $0x18,%esp
	return ;
  801fae:	90                   	nop
}
  801faf:	c9                   	leave  
  801fb0:	c3                   	ret    

00801fb1 <inctst>:

void inctst()
{
  801fb1:	55                   	push   %ebp
  801fb2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801fb4:	6a 00                	push   $0x0
  801fb6:	6a 00                	push   $0x0
  801fb8:	6a 00                	push   $0x0
  801fba:	6a 00                	push   $0x0
  801fbc:	6a 00                	push   $0x0
  801fbe:	6a 2a                	push   $0x2a
  801fc0:	e8 e2 fa ff ff       	call   801aa7 <syscall>
  801fc5:	83 c4 18             	add    $0x18,%esp
	return ;
  801fc8:	90                   	nop
}
  801fc9:	c9                   	leave  
  801fca:	c3                   	ret    

00801fcb <gettst>:
uint32 gettst()
{
  801fcb:	55                   	push   %ebp
  801fcc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801fce:	6a 00                	push   $0x0
  801fd0:	6a 00                	push   $0x0
  801fd2:	6a 00                	push   $0x0
  801fd4:	6a 00                	push   $0x0
  801fd6:	6a 00                	push   $0x0
  801fd8:	6a 2b                	push   $0x2b
  801fda:	e8 c8 fa ff ff       	call   801aa7 <syscall>
  801fdf:	83 c4 18             	add    $0x18,%esp
}
  801fe2:	c9                   	leave  
  801fe3:	c3                   	ret    

00801fe4 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801fe4:	55                   	push   %ebp
  801fe5:	89 e5                	mov    %esp,%ebp
  801fe7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fea:	6a 00                	push   $0x0
  801fec:	6a 00                	push   $0x0
  801fee:	6a 00                	push   $0x0
  801ff0:	6a 00                	push   $0x0
  801ff2:	6a 00                	push   $0x0
  801ff4:	6a 2c                	push   $0x2c
  801ff6:	e8 ac fa ff ff       	call   801aa7 <syscall>
  801ffb:	83 c4 18             	add    $0x18,%esp
  801ffe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802001:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802005:	75 07                	jne    80200e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802007:	b8 01 00 00 00       	mov    $0x1,%eax
  80200c:	eb 05                	jmp    802013 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80200e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802013:	c9                   	leave  
  802014:	c3                   	ret    

00802015 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802015:	55                   	push   %ebp
  802016:	89 e5                	mov    %esp,%ebp
  802018:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80201b:	6a 00                	push   $0x0
  80201d:	6a 00                	push   $0x0
  80201f:	6a 00                	push   $0x0
  802021:	6a 00                	push   $0x0
  802023:	6a 00                	push   $0x0
  802025:	6a 2c                	push   $0x2c
  802027:	e8 7b fa ff ff       	call   801aa7 <syscall>
  80202c:	83 c4 18             	add    $0x18,%esp
  80202f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802032:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802036:	75 07                	jne    80203f <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802038:	b8 01 00 00 00       	mov    $0x1,%eax
  80203d:	eb 05                	jmp    802044 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80203f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802044:	c9                   	leave  
  802045:	c3                   	ret    

00802046 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802046:	55                   	push   %ebp
  802047:	89 e5                	mov    %esp,%ebp
  802049:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80204c:	6a 00                	push   $0x0
  80204e:	6a 00                	push   $0x0
  802050:	6a 00                	push   $0x0
  802052:	6a 00                	push   $0x0
  802054:	6a 00                	push   $0x0
  802056:	6a 2c                	push   $0x2c
  802058:	e8 4a fa ff ff       	call   801aa7 <syscall>
  80205d:	83 c4 18             	add    $0x18,%esp
  802060:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802063:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802067:	75 07                	jne    802070 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802069:	b8 01 00 00 00       	mov    $0x1,%eax
  80206e:	eb 05                	jmp    802075 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802070:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802075:	c9                   	leave  
  802076:	c3                   	ret    

00802077 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802077:	55                   	push   %ebp
  802078:	89 e5                	mov    %esp,%ebp
  80207a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80207d:	6a 00                	push   $0x0
  80207f:	6a 00                	push   $0x0
  802081:	6a 00                	push   $0x0
  802083:	6a 00                	push   $0x0
  802085:	6a 00                	push   $0x0
  802087:	6a 2c                	push   $0x2c
  802089:	e8 19 fa ff ff       	call   801aa7 <syscall>
  80208e:	83 c4 18             	add    $0x18,%esp
  802091:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802094:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802098:	75 07                	jne    8020a1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80209a:	b8 01 00 00 00       	mov    $0x1,%eax
  80209f:	eb 05                	jmp    8020a6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8020a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020a6:	c9                   	leave  
  8020a7:	c3                   	ret    

008020a8 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8020a8:	55                   	push   %ebp
  8020a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8020ab:	6a 00                	push   $0x0
  8020ad:	6a 00                	push   $0x0
  8020af:	6a 00                	push   $0x0
  8020b1:	6a 00                	push   $0x0
  8020b3:	ff 75 08             	pushl  0x8(%ebp)
  8020b6:	6a 2d                	push   $0x2d
  8020b8:	e8 ea f9 ff ff       	call   801aa7 <syscall>
  8020bd:	83 c4 18             	add    $0x18,%esp
	return ;
  8020c0:	90                   	nop
}
  8020c1:	c9                   	leave  
  8020c2:	c3                   	ret    

008020c3 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8020c3:	55                   	push   %ebp
  8020c4:	89 e5                	mov    %esp,%ebp
  8020c6:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8020c7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020ca:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d3:	6a 00                	push   $0x0
  8020d5:	53                   	push   %ebx
  8020d6:	51                   	push   %ecx
  8020d7:	52                   	push   %edx
  8020d8:	50                   	push   %eax
  8020d9:	6a 2e                	push   $0x2e
  8020db:	e8 c7 f9 ff ff       	call   801aa7 <syscall>
  8020e0:	83 c4 18             	add    $0x18,%esp
}
  8020e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020e6:	c9                   	leave  
  8020e7:	c3                   	ret    

008020e8 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8020e8:	55                   	push   %ebp
  8020e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8020eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f1:	6a 00                	push   $0x0
  8020f3:	6a 00                	push   $0x0
  8020f5:	6a 00                	push   $0x0
  8020f7:	52                   	push   %edx
  8020f8:	50                   	push   %eax
  8020f9:	6a 2f                	push   $0x2f
  8020fb:	e8 a7 f9 ff ff       	call   801aa7 <syscall>
  802100:	83 c4 18             	add    $0x18,%esp
}
  802103:	c9                   	leave  
  802104:	c3                   	ret    
  802105:	66 90                	xchg   %ax,%ax
  802107:	90                   	nop

00802108 <__udivdi3>:
  802108:	55                   	push   %ebp
  802109:	57                   	push   %edi
  80210a:	56                   	push   %esi
  80210b:	53                   	push   %ebx
  80210c:	83 ec 1c             	sub    $0x1c,%esp
  80210f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802113:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802117:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80211b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80211f:	89 ca                	mov    %ecx,%edx
  802121:	89 f8                	mov    %edi,%eax
  802123:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802127:	85 f6                	test   %esi,%esi
  802129:	75 2d                	jne    802158 <__udivdi3+0x50>
  80212b:	39 cf                	cmp    %ecx,%edi
  80212d:	77 65                	ja     802194 <__udivdi3+0x8c>
  80212f:	89 fd                	mov    %edi,%ebp
  802131:	85 ff                	test   %edi,%edi
  802133:	75 0b                	jne    802140 <__udivdi3+0x38>
  802135:	b8 01 00 00 00       	mov    $0x1,%eax
  80213a:	31 d2                	xor    %edx,%edx
  80213c:	f7 f7                	div    %edi
  80213e:	89 c5                	mov    %eax,%ebp
  802140:	31 d2                	xor    %edx,%edx
  802142:	89 c8                	mov    %ecx,%eax
  802144:	f7 f5                	div    %ebp
  802146:	89 c1                	mov    %eax,%ecx
  802148:	89 d8                	mov    %ebx,%eax
  80214a:	f7 f5                	div    %ebp
  80214c:	89 cf                	mov    %ecx,%edi
  80214e:	89 fa                	mov    %edi,%edx
  802150:	83 c4 1c             	add    $0x1c,%esp
  802153:	5b                   	pop    %ebx
  802154:	5e                   	pop    %esi
  802155:	5f                   	pop    %edi
  802156:	5d                   	pop    %ebp
  802157:	c3                   	ret    
  802158:	39 ce                	cmp    %ecx,%esi
  80215a:	77 28                	ja     802184 <__udivdi3+0x7c>
  80215c:	0f bd fe             	bsr    %esi,%edi
  80215f:	83 f7 1f             	xor    $0x1f,%edi
  802162:	75 40                	jne    8021a4 <__udivdi3+0x9c>
  802164:	39 ce                	cmp    %ecx,%esi
  802166:	72 0a                	jb     802172 <__udivdi3+0x6a>
  802168:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80216c:	0f 87 9e 00 00 00    	ja     802210 <__udivdi3+0x108>
  802172:	b8 01 00 00 00       	mov    $0x1,%eax
  802177:	89 fa                	mov    %edi,%edx
  802179:	83 c4 1c             	add    $0x1c,%esp
  80217c:	5b                   	pop    %ebx
  80217d:	5e                   	pop    %esi
  80217e:	5f                   	pop    %edi
  80217f:	5d                   	pop    %ebp
  802180:	c3                   	ret    
  802181:	8d 76 00             	lea    0x0(%esi),%esi
  802184:	31 ff                	xor    %edi,%edi
  802186:	31 c0                	xor    %eax,%eax
  802188:	89 fa                	mov    %edi,%edx
  80218a:	83 c4 1c             	add    $0x1c,%esp
  80218d:	5b                   	pop    %ebx
  80218e:	5e                   	pop    %esi
  80218f:	5f                   	pop    %edi
  802190:	5d                   	pop    %ebp
  802191:	c3                   	ret    
  802192:	66 90                	xchg   %ax,%ax
  802194:	89 d8                	mov    %ebx,%eax
  802196:	f7 f7                	div    %edi
  802198:	31 ff                	xor    %edi,%edi
  80219a:	89 fa                	mov    %edi,%edx
  80219c:	83 c4 1c             	add    $0x1c,%esp
  80219f:	5b                   	pop    %ebx
  8021a0:	5e                   	pop    %esi
  8021a1:	5f                   	pop    %edi
  8021a2:	5d                   	pop    %ebp
  8021a3:	c3                   	ret    
  8021a4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8021a9:	89 eb                	mov    %ebp,%ebx
  8021ab:	29 fb                	sub    %edi,%ebx
  8021ad:	89 f9                	mov    %edi,%ecx
  8021af:	d3 e6                	shl    %cl,%esi
  8021b1:	89 c5                	mov    %eax,%ebp
  8021b3:	88 d9                	mov    %bl,%cl
  8021b5:	d3 ed                	shr    %cl,%ebp
  8021b7:	89 e9                	mov    %ebp,%ecx
  8021b9:	09 f1                	or     %esi,%ecx
  8021bb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8021bf:	89 f9                	mov    %edi,%ecx
  8021c1:	d3 e0                	shl    %cl,%eax
  8021c3:	89 c5                	mov    %eax,%ebp
  8021c5:	89 d6                	mov    %edx,%esi
  8021c7:	88 d9                	mov    %bl,%cl
  8021c9:	d3 ee                	shr    %cl,%esi
  8021cb:	89 f9                	mov    %edi,%ecx
  8021cd:	d3 e2                	shl    %cl,%edx
  8021cf:	8b 44 24 08          	mov    0x8(%esp),%eax
  8021d3:	88 d9                	mov    %bl,%cl
  8021d5:	d3 e8                	shr    %cl,%eax
  8021d7:	09 c2                	or     %eax,%edx
  8021d9:	89 d0                	mov    %edx,%eax
  8021db:	89 f2                	mov    %esi,%edx
  8021dd:	f7 74 24 0c          	divl   0xc(%esp)
  8021e1:	89 d6                	mov    %edx,%esi
  8021e3:	89 c3                	mov    %eax,%ebx
  8021e5:	f7 e5                	mul    %ebp
  8021e7:	39 d6                	cmp    %edx,%esi
  8021e9:	72 19                	jb     802204 <__udivdi3+0xfc>
  8021eb:	74 0b                	je     8021f8 <__udivdi3+0xf0>
  8021ed:	89 d8                	mov    %ebx,%eax
  8021ef:	31 ff                	xor    %edi,%edi
  8021f1:	e9 58 ff ff ff       	jmp    80214e <__udivdi3+0x46>
  8021f6:	66 90                	xchg   %ax,%ax
  8021f8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8021fc:	89 f9                	mov    %edi,%ecx
  8021fe:	d3 e2                	shl    %cl,%edx
  802200:	39 c2                	cmp    %eax,%edx
  802202:	73 e9                	jae    8021ed <__udivdi3+0xe5>
  802204:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802207:	31 ff                	xor    %edi,%edi
  802209:	e9 40 ff ff ff       	jmp    80214e <__udivdi3+0x46>
  80220e:	66 90                	xchg   %ax,%ax
  802210:	31 c0                	xor    %eax,%eax
  802212:	e9 37 ff ff ff       	jmp    80214e <__udivdi3+0x46>
  802217:	90                   	nop

00802218 <__umoddi3>:
  802218:	55                   	push   %ebp
  802219:	57                   	push   %edi
  80221a:	56                   	push   %esi
  80221b:	53                   	push   %ebx
  80221c:	83 ec 1c             	sub    $0x1c,%esp
  80221f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802223:	8b 74 24 34          	mov    0x34(%esp),%esi
  802227:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80222b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80222f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802233:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802237:	89 f3                	mov    %esi,%ebx
  802239:	89 fa                	mov    %edi,%edx
  80223b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80223f:	89 34 24             	mov    %esi,(%esp)
  802242:	85 c0                	test   %eax,%eax
  802244:	75 1a                	jne    802260 <__umoddi3+0x48>
  802246:	39 f7                	cmp    %esi,%edi
  802248:	0f 86 a2 00 00 00    	jbe    8022f0 <__umoddi3+0xd8>
  80224e:	89 c8                	mov    %ecx,%eax
  802250:	89 f2                	mov    %esi,%edx
  802252:	f7 f7                	div    %edi
  802254:	89 d0                	mov    %edx,%eax
  802256:	31 d2                	xor    %edx,%edx
  802258:	83 c4 1c             	add    $0x1c,%esp
  80225b:	5b                   	pop    %ebx
  80225c:	5e                   	pop    %esi
  80225d:	5f                   	pop    %edi
  80225e:	5d                   	pop    %ebp
  80225f:	c3                   	ret    
  802260:	39 f0                	cmp    %esi,%eax
  802262:	0f 87 ac 00 00 00    	ja     802314 <__umoddi3+0xfc>
  802268:	0f bd e8             	bsr    %eax,%ebp
  80226b:	83 f5 1f             	xor    $0x1f,%ebp
  80226e:	0f 84 ac 00 00 00    	je     802320 <__umoddi3+0x108>
  802274:	bf 20 00 00 00       	mov    $0x20,%edi
  802279:	29 ef                	sub    %ebp,%edi
  80227b:	89 fe                	mov    %edi,%esi
  80227d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802281:	89 e9                	mov    %ebp,%ecx
  802283:	d3 e0                	shl    %cl,%eax
  802285:	89 d7                	mov    %edx,%edi
  802287:	89 f1                	mov    %esi,%ecx
  802289:	d3 ef                	shr    %cl,%edi
  80228b:	09 c7                	or     %eax,%edi
  80228d:	89 e9                	mov    %ebp,%ecx
  80228f:	d3 e2                	shl    %cl,%edx
  802291:	89 14 24             	mov    %edx,(%esp)
  802294:	89 d8                	mov    %ebx,%eax
  802296:	d3 e0                	shl    %cl,%eax
  802298:	89 c2                	mov    %eax,%edx
  80229a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80229e:	d3 e0                	shl    %cl,%eax
  8022a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022a4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8022a8:	89 f1                	mov    %esi,%ecx
  8022aa:	d3 e8                	shr    %cl,%eax
  8022ac:	09 d0                	or     %edx,%eax
  8022ae:	d3 eb                	shr    %cl,%ebx
  8022b0:	89 da                	mov    %ebx,%edx
  8022b2:	f7 f7                	div    %edi
  8022b4:	89 d3                	mov    %edx,%ebx
  8022b6:	f7 24 24             	mull   (%esp)
  8022b9:	89 c6                	mov    %eax,%esi
  8022bb:	89 d1                	mov    %edx,%ecx
  8022bd:	39 d3                	cmp    %edx,%ebx
  8022bf:	0f 82 87 00 00 00    	jb     80234c <__umoddi3+0x134>
  8022c5:	0f 84 91 00 00 00    	je     80235c <__umoddi3+0x144>
  8022cb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8022cf:	29 f2                	sub    %esi,%edx
  8022d1:	19 cb                	sbb    %ecx,%ebx
  8022d3:	89 d8                	mov    %ebx,%eax
  8022d5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8022d9:	d3 e0                	shl    %cl,%eax
  8022db:	89 e9                	mov    %ebp,%ecx
  8022dd:	d3 ea                	shr    %cl,%edx
  8022df:	09 d0                	or     %edx,%eax
  8022e1:	89 e9                	mov    %ebp,%ecx
  8022e3:	d3 eb                	shr    %cl,%ebx
  8022e5:	89 da                	mov    %ebx,%edx
  8022e7:	83 c4 1c             	add    $0x1c,%esp
  8022ea:	5b                   	pop    %ebx
  8022eb:	5e                   	pop    %esi
  8022ec:	5f                   	pop    %edi
  8022ed:	5d                   	pop    %ebp
  8022ee:	c3                   	ret    
  8022ef:	90                   	nop
  8022f0:	89 fd                	mov    %edi,%ebp
  8022f2:	85 ff                	test   %edi,%edi
  8022f4:	75 0b                	jne    802301 <__umoddi3+0xe9>
  8022f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8022fb:	31 d2                	xor    %edx,%edx
  8022fd:	f7 f7                	div    %edi
  8022ff:	89 c5                	mov    %eax,%ebp
  802301:	89 f0                	mov    %esi,%eax
  802303:	31 d2                	xor    %edx,%edx
  802305:	f7 f5                	div    %ebp
  802307:	89 c8                	mov    %ecx,%eax
  802309:	f7 f5                	div    %ebp
  80230b:	89 d0                	mov    %edx,%eax
  80230d:	e9 44 ff ff ff       	jmp    802256 <__umoddi3+0x3e>
  802312:	66 90                	xchg   %ax,%ax
  802314:	89 c8                	mov    %ecx,%eax
  802316:	89 f2                	mov    %esi,%edx
  802318:	83 c4 1c             	add    $0x1c,%esp
  80231b:	5b                   	pop    %ebx
  80231c:	5e                   	pop    %esi
  80231d:	5f                   	pop    %edi
  80231e:	5d                   	pop    %ebp
  80231f:	c3                   	ret    
  802320:	3b 04 24             	cmp    (%esp),%eax
  802323:	72 06                	jb     80232b <__umoddi3+0x113>
  802325:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802329:	77 0f                	ja     80233a <__umoddi3+0x122>
  80232b:	89 f2                	mov    %esi,%edx
  80232d:	29 f9                	sub    %edi,%ecx
  80232f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802333:	89 14 24             	mov    %edx,(%esp)
  802336:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80233a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80233e:	8b 14 24             	mov    (%esp),%edx
  802341:	83 c4 1c             	add    $0x1c,%esp
  802344:	5b                   	pop    %ebx
  802345:	5e                   	pop    %esi
  802346:	5f                   	pop    %edi
  802347:	5d                   	pop    %ebp
  802348:	c3                   	ret    
  802349:	8d 76 00             	lea    0x0(%esi),%esi
  80234c:	2b 04 24             	sub    (%esp),%eax
  80234f:	19 fa                	sbb    %edi,%edx
  802351:	89 d1                	mov    %edx,%ecx
  802353:	89 c6                	mov    %eax,%esi
  802355:	e9 71 ff ff ff       	jmp    8022cb <__umoddi3+0xb3>
  80235a:	66 90                	xchg   %ax,%ax
  80235c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802360:	72 ea                	jb     80234c <__umoddi3+0x134>
  802362:	89 d9                	mov    %ebx,%ecx
  802364:	e9 62 ff ff ff       	jmp    8022cb <__umoddi3+0xb3>
