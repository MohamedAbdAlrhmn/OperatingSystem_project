
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
  800049:	e8 37 1f 00 00       	call   801f85 <sys_calculate_free_frames>
  80004e:	89 c3                	mov    %eax,%ebx
  800050:	e8 49 1f 00 00       	call   801f9e <sys_calculate_modified_frames>
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
  800067:	68 c0 3d 80 00       	push   $0x803dc0
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
  800097:	e8 cc 1a 00 00       	call   801b68 <malloc>
  80009c:	83 c4 10             	add    $0x10,%esp
  80009f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		cprintf("Choose the initialization method:\n") ;
  8000a2:	83 ec 0c             	sub    $0xc,%esp
  8000a5:	68 e0 3d 80 00       	push   $0x803de0
  8000aa:	e8 2b 09 00 00       	call   8009da <cprintf>
  8000af:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000b2:	83 ec 0c             	sub    $0xc,%esp
  8000b5:	68 03 3e 80 00       	push   $0x803e03
  8000ba:	e8 1b 09 00 00       	call   8009da <cprintf>
  8000bf:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000c2:	83 ec 0c             	sub    $0xc,%esp
  8000c5:	68 11 3e 80 00       	push   $0x803e11
  8000ca:	e8 0b 09 00 00       	call   8009da <cprintf>
  8000cf:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  8000d2:	83 ec 0c             	sub    $0xc,%esp
  8000d5:	68 20 3e 80 00       	push   $0x803e20
  8000da:	e8 fb 08 00 00       	call   8009da <cprintf>
  8000df:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  8000e2:	83 ec 0c             	sub    $0xc,%esp
  8000e5:	68 30 3e 80 00       	push   $0x803e30
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
  8001b4:	68 3c 3e 80 00       	push   $0x803e3c
  8001b9:	6a 45                	push   $0x45
  8001bb:	68 5e 3e 80 00       	push   $0x803e5e
  8001c0:	e8 61 05 00 00       	call   800726 <_panic>
		else
		{ 
			cprintf("===============================================\n") ;
  8001c5:	83 ec 0c             	sub    $0xc,%esp
  8001c8:	68 78 3e 80 00       	push   $0x803e78
  8001cd:	e8 08 08 00 00       	call   8009da <cprintf>
  8001d2:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  8001d5:	83 ec 0c             	sub    $0xc,%esp
  8001d8:	68 ac 3e 80 00       	push   $0x803eac
  8001dd:	e8 f8 07 00 00       	call   8009da <cprintf>
  8001e2:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  8001e5:	83 ec 0c             	sub    $0xc,%esp
  8001e8:	68 e0 3e 80 00       	push   $0x803ee0
  8001ed:	e8 e8 07 00 00       	call   8009da <cprintf>
  8001f2:	83 c4 10             	add    $0x10,%esp
		}

		//		cprintf("Free Frames After Calculation = %d\n", sys_calculate_free_frames()) ;

		cprintf("Freeing the Heap...\n\n") ;
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	68 12 3f 80 00       	push   $0x803f12
  8001fd:	e8 d8 07 00 00       	call   8009da <cprintf>
  800202:	83 c4 10             	add    $0x10,%esp

		//freeHeap() ;

		///========================================================================
		//sys_disable_interrupt();
		cprintf("Do you want to repeat (y/n): ") ;
  800205:	83 ec 0c             	sub    $0xc,%esp
  800208:	68 28 3f 80 00       	push   $0x803f28
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
  8004ea:	68 46 3f 80 00       	push   $0x803f46
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
  80050c:	68 48 3f 80 00       	push   $0x803f48
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
  80053a:	68 4d 3f 80 00       	push   $0x803f4d
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
  80055e:	e8 43 1b 00 00       	call   8020a6 <sys_cputc>
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
  80056f:	e8 fe 1a 00 00       	call   802072 <sys_disable_interrupt>
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
  800582:	e8 1f 1b 00 00       	call   8020a6 <sys_cputc>
  800587:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80058a:	e8 fd 1a 00 00       	call   80208c <sys_enable_interrupt>
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
  8005a1:	e8 47 19 00 00       	call   801eed <sys_cgetc>
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
  8005ba:	e8 b3 1a 00 00       	call   802072 <sys_disable_interrupt>
	int c=0;
  8005bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8005c6:	eb 08                	jmp    8005d0 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  8005c8:	e8 20 19 00 00       	call   801eed <sys_cgetc>
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
  8005d6:	e8 b1 1a 00 00       	call   80208c <sys_enable_interrupt>
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
  8005f0:	e8 70 1c 00 00       	call   802265 <sys_getenvindex>
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
  800617:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80061c:	a1 24 50 80 00       	mov    0x805024,%eax
  800621:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800627:	84 c0                	test   %al,%al
  800629:	74 0f                	je     80063a <libmain+0x50>
		binaryname = myEnv->prog_name;
  80062b:	a1 24 50 80 00       	mov    0x805024,%eax
  800630:	05 5c 05 00 00       	add    $0x55c,%eax
  800635:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80063a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80063e:	7e 0a                	jle    80064a <libmain+0x60>
		binaryname = argv[0];
  800640:	8b 45 0c             	mov    0xc(%ebp),%eax
  800643:	8b 00                	mov    (%eax),%eax
  800645:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  80064a:	83 ec 08             	sub    $0x8,%esp
  80064d:	ff 75 0c             	pushl  0xc(%ebp)
  800650:	ff 75 08             	pushl  0x8(%ebp)
  800653:	e8 e0 f9 ff ff       	call   800038 <_main>
  800658:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80065b:	e8 12 1a 00 00       	call   802072 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800660:	83 ec 0c             	sub    $0xc,%esp
  800663:	68 6c 3f 80 00       	push   $0x803f6c
  800668:	e8 6d 03 00 00       	call   8009da <cprintf>
  80066d:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800670:	a1 24 50 80 00       	mov    0x805024,%eax
  800675:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80067b:	a1 24 50 80 00       	mov    0x805024,%eax
  800680:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800686:	83 ec 04             	sub    $0x4,%esp
  800689:	52                   	push   %edx
  80068a:	50                   	push   %eax
  80068b:	68 94 3f 80 00       	push   $0x803f94
  800690:	e8 45 03 00 00       	call   8009da <cprintf>
  800695:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800698:	a1 24 50 80 00       	mov    0x805024,%eax
  80069d:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8006a3:	a1 24 50 80 00       	mov    0x805024,%eax
  8006a8:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8006ae:	a1 24 50 80 00       	mov    0x805024,%eax
  8006b3:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8006b9:	51                   	push   %ecx
  8006ba:	52                   	push   %edx
  8006bb:	50                   	push   %eax
  8006bc:	68 bc 3f 80 00       	push   $0x803fbc
  8006c1:	e8 14 03 00 00       	call   8009da <cprintf>
  8006c6:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006c9:	a1 24 50 80 00       	mov    0x805024,%eax
  8006ce:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8006d4:	83 ec 08             	sub    $0x8,%esp
  8006d7:	50                   	push   %eax
  8006d8:	68 14 40 80 00       	push   $0x804014
  8006dd:	e8 f8 02 00 00       	call   8009da <cprintf>
  8006e2:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8006e5:	83 ec 0c             	sub    $0xc,%esp
  8006e8:	68 6c 3f 80 00       	push   $0x803f6c
  8006ed:	e8 e8 02 00 00       	call   8009da <cprintf>
  8006f2:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8006f5:	e8 92 19 00 00       	call   80208c <sys_enable_interrupt>

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
  80070d:	e8 1f 1b 00 00       	call   802231 <sys_destroy_env>
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
  80071e:	e8 74 1b 00 00       	call   802297 <sys_exit_env>
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
  800735:	a1 5c 51 80 00       	mov    0x80515c,%eax
  80073a:	85 c0                	test   %eax,%eax
  80073c:	74 16                	je     800754 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80073e:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800743:	83 ec 08             	sub    $0x8,%esp
  800746:	50                   	push   %eax
  800747:	68 28 40 80 00       	push   $0x804028
  80074c:	e8 89 02 00 00       	call   8009da <cprintf>
  800751:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800754:	a1 00 50 80 00       	mov    0x805000,%eax
  800759:	ff 75 0c             	pushl  0xc(%ebp)
  80075c:	ff 75 08             	pushl  0x8(%ebp)
  80075f:	50                   	push   %eax
  800760:	68 2d 40 80 00       	push   $0x80402d
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
  800784:	68 49 40 80 00       	push   $0x804049
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
  80079e:	a1 24 50 80 00       	mov    0x805024,%eax
  8007a3:	8b 50 74             	mov    0x74(%eax),%edx
  8007a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007a9:	39 c2                	cmp    %eax,%edx
  8007ab:	74 14                	je     8007c1 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8007ad:	83 ec 04             	sub    $0x4,%esp
  8007b0:	68 4c 40 80 00       	push   $0x80404c
  8007b5:	6a 26                	push   $0x26
  8007b7:	68 98 40 80 00       	push   $0x804098
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
  800801:	a1 24 50 80 00       	mov    0x805024,%eax
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
  800821:	a1 24 50 80 00       	mov    0x805024,%eax
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
  80086a:	a1 24 50 80 00       	mov    0x805024,%eax
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
  800882:	68 a4 40 80 00       	push   $0x8040a4
  800887:	6a 3a                	push   $0x3a
  800889:	68 98 40 80 00       	push   $0x804098
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
  8008b2:	a1 24 50 80 00       	mov    0x805024,%eax
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
  8008d8:	a1 24 50 80 00       	mov    0x805024,%eax
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
  8008f2:	68 f8 40 80 00       	push   $0x8040f8
  8008f7:	6a 44                	push   $0x44
  8008f9:	68 98 40 80 00       	push   $0x804098
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
  800931:	a0 28 50 80 00       	mov    0x805028,%al
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
  80094c:	e8 73 15 00 00       	call   801ec4 <sys_cputs>
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
  8009a6:	a0 28 50 80 00       	mov    0x805028,%al
  8009ab:	0f b6 c0             	movzbl %al,%eax
  8009ae:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8009b4:	83 ec 04             	sub    $0x4,%esp
  8009b7:	50                   	push   %eax
  8009b8:	52                   	push   %edx
  8009b9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009bf:	83 c0 08             	add    $0x8,%eax
  8009c2:	50                   	push   %eax
  8009c3:	e8 fc 14 00 00       	call   801ec4 <sys_cputs>
  8009c8:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8009cb:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
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
  8009e0:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
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
  800a0d:	e8 60 16 00 00       	call   802072 <sys_disable_interrupt>
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
  800a2d:	e8 5a 16 00 00       	call   80208c <sys_enable_interrupt>
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
  800a77:	e8 cc 30 00 00       	call   803b48 <__udivdi3>
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
  800ac7:	e8 8c 31 00 00       	call   803c58 <__umoddi3>
  800acc:	83 c4 10             	add    $0x10,%esp
  800acf:	05 74 43 80 00       	add    $0x804374,%eax
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
  800c22:	8b 04 85 98 43 80 00 	mov    0x804398(,%eax,4),%eax
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
  800d03:	8b 34 9d e0 41 80 00 	mov    0x8041e0(,%ebx,4),%esi
  800d0a:	85 f6                	test   %esi,%esi
  800d0c:	75 19                	jne    800d27 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d0e:	53                   	push   %ebx
  800d0f:	68 85 43 80 00       	push   $0x804385
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
  800d28:	68 8e 43 80 00       	push   $0x80438e
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
  800d55:	be 91 43 80 00       	mov    $0x804391,%esi
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
  80106e:	68 f0 44 80 00       	push   $0x8044f0
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
  8010b0:	68 f3 44 80 00       	push   $0x8044f3
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
  801160:	e8 0d 0f 00 00       	call   802072 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  801165:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801169:	74 13                	je     80117e <atomic_readline+0x24>
		cprintf("%s", prompt);
  80116b:	83 ec 08             	sub    $0x8,%esp
  80116e:	ff 75 08             	pushl  0x8(%ebp)
  801171:	68 f0 44 80 00       	push   $0x8044f0
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
  8011af:	68 f3 44 80 00       	push   $0x8044f3
  8011b4:	e8 21 f8 ff ff       	call   8009da <cprintf>
  8011b9:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  8011bc:	e8 cb 0e 00 00       	call   80208c <sys_enable_interrupt>
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
  801254:	e8 33 0e 00 00       	call   80208c <sys_enable_interrupt>
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

0080196a <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80196a:	55                   	push   %ebp
  80196b:	89 e5                	mov    %esp,%ebp
  80196d:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801970:	a1 04 50 80 00       	mov    0x805004,%eax
  801975:	85 c0                	test   %eax,%eax
  801977:	74 1f                	je     801998 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801979:	e8 1d 00 00 00       	call   80199b <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80197e:	83 ec 0c             	sub    $0xc,%esp
  801981:	68 04 45 80 00       	push   $0x804504
  801986:	e8 4f f0 ff ff       	call   8009da <cprintf>
  80198b:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80198e:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801995:	00 00 00 
	}
}
  801998:	90                   	nop
  801999:	c9                   	leave  
  80199a:	c3                   	ret    

0080199b <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80199b:	55                   	push   %ebp
  80199c:	89 e5                	mov    %esp,%ebp
  80199e:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  8019a1:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  8019a8:	00 00 00 
  8019ab:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  8019b2:	00 00 00 
  8019b5:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  8019bc:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  8019bf:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  8019c6:	00 00 00 
  8019c9:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  8019d0:	00 00 00 
  8019d3:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  8019da:	00 00 00 
	uint32 arr_size = 0;
  8019dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  8019e4:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  8019eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019ee:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8019f3:	2d 00 10 00 00       	sub    $0x1000,%eax
  8019f8:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  8019fd:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801a04:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  801a07:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801a0e:	a1 20 51 80 00       	mov    0x805120,%eax
  801a13:	c1 e0 04             	shl    $0x4,%eax
  801a16:	89 c2                	mov    %eax,%edx
  801a18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a1b:	01 d0                	add    %edx,%eax
  801a1d:	48                   	dec    %eax
  801a1e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801a21:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a24:	ba 00 00 00 00       	mov    $0x0,%edx
  801a29:	f7 75 ec             	divl   -0x14(%ebp)
  801a2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a2f:	29 d0                	sub    %edx,%eax
  801a31:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  801a34:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801a3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a3e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a43:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a48:	83 ec 04             	sub    $0x4,%esp
  801a4b:	6a 06                	push   $0x6
  801a4d:	ff 75 f4             	pushl  -0xc(%ebp)
  801a50:	50                   	push   %eax
  801a51:	e8 b2 05 00 00       	call   802008 <sys_allocate_chunk>
  801a56:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801a59:	a1 20 51 80 00       	mov    0x805120,%eax
  801a5e:	83 ec 0c             	sub    $0xc,%esp
  801a61:	50                   	push   %eax
  801a62:	e8 27 0c 00 00       	call   80268e <initialize_MemBlocksList>
  801a67:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  801a6a:	a1 48 51 80 00       	mov    0x805148,%eax
  801a6f:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  801a72:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a75:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  801a7c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a7f:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  801a86:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801a8a:	75 14                	jne    801aa0 <initialize_dyn_block_system+0x105>
  801a8c:	83 ec 04             	sub    $0x4,%esp
  801a8f:	68 29 45 80 00       	push   $0x804529
  801a94:	6a 33                	push   $0x33
  801a96:	68 47 45 80 00       	push   $0x804547
  801a9b:	e8 86 ec ff ff       	call   800726 <_panic>
  801aa0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801aa3:	8b 00                	mov    (%eax),%eax
  801aa5:	85 c0                	test   %eax,%eax
  801aa7:	74 10                	je     801ab9 <initialize_dyn_block_system+0x11e>
  801aa9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801aac:	8b 00                	mov    (%eax),%eax
  801aae:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ab1:	8b 52 04             	mov    0x4(%edx),%edx
  801ab4:	89 50 04             	mov    %edx,0x4(%eax)
  801ab7:	eb 0b                	jmp    801ac4 <initialize_dyn_block_system+0x129>
  801ab9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801abc:	8b 40 04             	mov    0x4(%eax),%eax
  801abf:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801ac4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ac7:	8b 40 04             	mov    0x4(%eax),%eax
  801aca:	85 c0                	test   %eax,%eax
  801acc:	74 0f                	je     801add <initialize_dyn_block_system+0x142>
  801ace:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ad1:	8b 40 04             	mov    0x4(%eax),%eax
  801ad4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ad7:	8b 12                	mov    (%edx),%edx
  801ad9:	89 10                	mov    %edx,(%eax)
  801adb:	eb 0a                	jmp    801ae7 <initialize_dyn_block_system+0x14c>
  801add:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ae0:	8b 00                	mov    (%eax),%eax
  801ae2:	a3 48 51 80 00       	mov    %eax,0x805148
  801ae7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801aea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801af0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801af3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801afa:	a1 54 51 80 00       	mov    0x805154,%eax
  801aff:	48                   	dec    %eax
  801b00:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  801b05:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801b09:	75 14                	jne    801b1f <initialize_dyn_block_system+0x184>
  801b0b:	83 ec 04             	sub    $0x4,%esp
  801b0e:	68 54 45 80 00       	push   $0x804554
  801b13:	6a 34                	push   $0x34
  801b15:	68 47 45 80 00       	push   $0x804547
  801b1a:	e8 07 ec ff ff       	call   800726 <_panic>
  801b1f:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801b25:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b28:	89 10                	mov    %edx,(%eax)
  801b2a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b2d:	8b 00                	mov    (%eax),%eax
  801b2f:	85 c0                	test   %eax,%eax
  801b31:	74 0d                	je     801b40 <initialize_dyn_block_system+0x1a5>
  801b33:	a1 38 51 80 00       	mov    0x805138,%eax
  801b38:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b3b:	89 50 04             	mov    %edx,0x4(%eax)
  801b3e:	eb 08                	jmp    801b48 <initialize_dyn_block_system+0x1ad>
  801b40:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b43:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801b48:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b4b:	a3 38 51 80 00       	mov    %eax,0x805138
  801b50:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b53:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801b5a:	a1 44 51 80 00       	mov    0x805144,%eax
  801b5f:	40                   	inc    %eax
  801b60:	a3 44 51 80 00       	mov    %eax,0x805144
}
  801b65:	90                   	nop
  801b66:	c9                   	leave  
  801b67:	c3                   	ret    

00801b68 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801b68:	55                   	push   %ebp
  801b69:	89 e5                	mov    %esp,%ebp
  801b6b:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b6e:	e8 f7 fd ff ff       	call   80196a <InitializeUHeap>
	if (size == 0) return NULL ;
  801b73:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b77:	75 07                	jne    801b80 <malloc+0x18>
  801b79:	b8 00 00 00 00       	mov    $0x0,%eax
  801b7e:	eb 61                	jmp    801be1 <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  801b80:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801b87:	8b 55 08             	mov    0x8(%ebp),%edx
  801b8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b8d:	01 d0                	add    %edx,%eax
  801b8f:	48                   	dec    %eax
  801b90:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801b93:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b96:	ba 00 00 00 00       	mov    $0x0,%edx
  801b9b:	f7 75 f0             	divl   -0x10(%ebp)
  801b9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ba1:	29 d0                	sub    %edx,%eax
  801ba3:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801ba6:	e8 2b 08 00 00       	call   8023d6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801bab:	85 c0                	test   %eax,%eax
  801bad:	74 11                	je     801bc0 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801baf:	83 ec 0c             	sub    $0xc,%esp
  801bb2:	ff 75 e8             	pushl  -0x18(%ebp)
  801bb5:	e8 96 0e 00 00       	call   802a50 <alloc_block_FF>
  801bba:	83 c4 10             	add    $0x10,%esp
  801bbd:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  801bc0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bc4:	74 16                	je     801bdc <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  801bc6:	83 ec 0c             	sub    $0xc,%esp
  801bc9:	ff 75 f4             	pushl  -0xc(%ebp)
  801bcc:	e8 f2 0b 00 00       	call   8027c3 <insert_sorted_allocList>
  801bd1:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  801bd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bd7:	8b 40 08             	mov    0x8(%eax),%eax
  801bda:	eb 05                	jmp    801be1 <malloc+0x79>
	}

    return NULL;
  801bdc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801be1:	c9                   	leave  
  801be2:	c3                   	ret    

00801be3 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801be3:	55                   	push   %ebp
  801be4:	89 e5                	mov    %esp,%ebp
  801be6:	83 ec 18             	sub    $0x18,%esp
<<<<<<< HEAD
=======
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801be9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bec:	83 ec 08             	sub    $0x8,%esp
  801bef:	50                   	push   %eax
  801bf0:	68 40 50 80 00       	push   $0x805040
  801bf5:	e8 71 0b 00 00       	call   80276b <find_block>
  801bfa:	83 c4 10             	add    $0x10,%esp
  801bfd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(free_block!=NULL)
  801c00:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c04:	0f 84 a6 00 00 00    	je     801cb0 <free+0xcd>
	{
		sys_free_user_mem(free_block->sva,free_block->size);
  801c0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c0d:	8b 50 0c             	mov    0xc(%eax),%edx
  801c10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c13:	8b 40 08             	mov    0x8(%eax),%eax
  801c16:	83 ec 08             	sub    $0x8,%esp
  801c19:	52                   	push   %edx
  801c1a:	50                   	push   %eax
  801c1b:	e8 b0 03 00 00       	call   801fd0 <sys_free_user_mem>
  801c20:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,free_block);
  801c23:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c27:	75 14                	jne    801c3d <free+0x5a>
  801c29:	83 ec 04             	sub    $0x4,%esp
  801c2c:	68 29 45 80 00       	push   $0x804529
  801c31:	6a 74                	push   $0x74
  801c33:	68 47 45 80 00       	push   $0x804547
  801c38:	e8 e9 ea ff ff       	call   800726 <_panic>
  801c3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c40:	8b 00                	mov    (%eax),%eax
  801c42:	85 c0                	test   %eax,%eax
  801c44:	74 10                	je     801c56 <free+0x73>
  801c46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c49:	8b 00                	mov    (%eax),%eax
  801c4b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c4e:	8b 52 04             	mov    0x4(%edx),%edx
  801c51:	89 50 04             	mov    %edx,0x4(%eax)
  801c54:	eb 0b                	jmp    801c61 <free+0x7e>
  801c56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c59:	8b 40 04             	mov    0x4(%eax),%eax
  801c5c:	a3 44 50 80 00       	mov    %eax,0x805044
  801c61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c64:	8b 40 04             	mov    0x4(%eax),%eax
  801c67:	85 c0                	test   %eax,%eax
  801c69:	74 0f                	je     801c7a <free+0x97>
  801c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c6e:	8b 40 04             	mov    0x4(%eax),%eax
  801c71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c74:	8b 12                	mov    (%edx),%edx
  801c76:	89 10                	mov    %edx,(%eax)
  801c78:	eb 0a                	jmp    801c84 <free+0xa1>
  801c7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c7d:	8b 00                	mov    (%eax),%eax
  801c7f:	a3 40 50 80 00       	mov    %eax,0x805040
  801c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c87:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801c8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c90:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801c97:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801c9c:	48                   	dec    %eax
  801c9d:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(free_block);
  801ca2:	83 ec 0c             	sub    $0xc,%esp
  801ca5:	ff 75 f4             	pushl  -0xc(%ebp)
  801ca8:	e8 4e 17 00 00       	call   8033fb <insert_sorted_with_merge_freeList>
  801cad:	83 c4 10             	add    $0x10,%esp
	}
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
<<<<<<< HEAD

	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801be9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bec:	83 ec 08             	sub    $0x8,%esp
  801bef:	50                   	push   %eax
  801bf0:	68 40 50 80 00       	push   $0x805040
  801bf5:	e8 71 0b 00 00       	call   80276b <find_block>
  801bfa:	83 c4 10             	add    $0x10,%esp
  801bfd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    if(free_block!=NULL)
  801c00:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c04:	0f 84 a6 00 00 00    	je     801cb0 <free+0xcd>
	    {
	    	sys_free_user_mem(free_block->sva,free_block->size);
  801c0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c0d:	8b 50 0c             	mov    0xc(%eax),%edx
  801c10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c13:	8b 40 08             	mov    0x8(%eax),%eax
  801c16:	83 ec 08             	sub    $0x8,%esp
  801c19:	52                   	push   %edx
  801c1a:	50                   	push   %eax
  801c1b:	e8 b0 03 00 00       	call   801fd0 <sys_free_user_mem>
  801c20:	83 c4 10             	add    $0x10,%esp
	    	LIST_REMOVE(&AllocMemBlocksList,free_block);
  801c23:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c27:	75 14                	jne    801c3d <free+0x5a>
  801c29:	83 ec 04             	sub    $0x4,%esp
  801c2c:	68 29 45 80 00       	push   $0x804529
  801c31:	6a 7a                	push   $0x7a
  801c33:	68 47 45 80 00       	push   $0x804547
  801c38:	e8 e9 ea ff ff       	call   800726 <_panic>
  801c3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c40:	8b 00                	mov    (%eax),%eax
  801c42:	85 c0                	test   %eax,%eax
  801c44:	74 10                	je     801c56 <free+0x73>
  801c46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c49:	8b 00                	mov    (%eax),%eax
  801c4b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c4e:	8b 52 04             	mov    0x4(%edx),%edx
  801c51:	89 50 04             	mov    %edx,0x4(%eax)
  801c54:	eb 0b                	jmp    801c61 <free+0x7e>
  801c56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c59:	8b 40 04             	mov    0x4(%eax),%eax
  801c5c:	a3 44 50 80 00       	mov    %eax,0x805044
  801c61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c64:	8b 40 04             	mov    0x4(%eax),%eax
  801c67:	85 c0                	test   %eax,%eax
  801c69:	74 0f                	je     801c7a <free+0x97>
  801c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c6e:	8b 40 04             	mov    0x4(%eax),%eax
  801c71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c74:	8b 12                	mov    (%edx),%edx
  801c76:	89 10                	mov    %edx,(%eax)
  801c78:	eb 0a                	jmp    801c84 <free+0xa1>
  801c7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c7d:	8b 00                	mov    (%eax),%eax
  801c7f:	a3 40 50 80 00       	mov    %eax,0x805040
  801c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c87:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801c8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c90:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801c97:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801c9c:	48                   	dec    %eax
  801c9d:	a3 4c 50 80 00       	mov    %eax,0x80504c
	        insert_sorted_with_merge_freeList(free_block);
  801ca2:	83 ec 0c             	sub    $0xc,%esp
  801ca5:	ff 75 f4             	pushl  -0xc(%ebp)
  801ca8:	e8 4e 17 00 00       	call   8033fb <insert_sorted_with_merge_freeList>
  801cad:	83 c4 10             	add    $0x10,%esp



	    }
=======
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
}
  801cb0:	90                   	nop
  801cb1:	c9                   	leave  
  801cb2:	c3                   	ret    

00801cb3 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801cb3:	55                   	push   %ebp
  801cb4:	89 e5                	mov    %esp,%ebp
  801cb6:	83 ec 38             	sub    $0x38,%esp
  801cb9:	8b 45 10             	mov    0x10(%ebp),%eax
  801cbc:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801cbf:	e8 a6 fc ff ff       	call   80196a <InitializeUHeap>
	if (size == 0) return NULL ;
  801cc4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801cc8:	75 0a                	jne    801cd4 <smalloc+0x21>
  801cca:	b8 00 00 00 00       	mov    $0x0,%eax
  801ccf:	e9 8b 00 00 00       	jmp    801d5f <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801cd4:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801cdb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ce1:	01 d0                	add    %edx,%eax
  801ce3:	48                   	dec    %eax
  801ce4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ce7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cea:	ba 00 00 00 00       	mov    $0x0,%edx
  801cef:	f7 75 f0             	divl   -0x10(%ebp)
  801cf2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cf5:	29 d0                	sub    %edx,%eax
  801cf7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801cfa:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801d01:	e8 d0 06 00 00       	call   8023d6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d06:	85 c0                	test   %eax,%eax
  801d08:	74 11                	je     801d1b <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801d0a:	83 ec 0c             	sub    $0xc,%esp
  801d0d:	ff 75 e8             	pushl  -0x18(%ebp)
  801d10:	e8 3b 0d 00 00       	call   802a50 <alloc_block_FF>
  801d15:	83 c4 10             	add    $0x10,%esp
  801d18:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  801d1b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d1f:	74 39                	je     801d5a <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801d21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d24:	8b 40 08             	mov    0x8(%eax),%eax
  801d27:	89 c2                	mov    %eax,%edx
  801d29:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801d2d:	52                   	push   %edx
  801d2e:	50                   	push   %eax
  801d2f:	ff 75 0c             	pushl  0xc(%ebp)
  801d32:	ff 75 08             	pushl  0x8(%ebp)
  801d35:	e8 21 04 00 00       	call   80215b <sys_createSharedObject>
  801d3a:	83 c4 10             	add    $0x10,%esp
  801d3d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801d40:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801d44:	74 14                	je     801d5a <smalloc+0xa7>
  801d46:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801d4a:	74 0e                	je     801d5a <smalloc+0xa7>
  801d4c:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801d50:	74 08                	je     801d5a <smalloc+0xa7>
			return (void*) mem_block->sva;
  801d52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d55:	8b 40 08             	mov    0x8(%eax),%eax
  801d58:	eb 05                	jmp    801d5f <smalloc+0xac>
	}
	return NULL;
  801d5a:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801d5f:	c9                   	leave  
  801d60:	c3                   	ret    

00801d61 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801d61:	55                   	push   %ebp
  801d62:	89 e5                	mov    %esp,%ebp
  801d64:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d67:	e8 fe fb ff ff       	call   80196a <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801d6c:	83 ec 08             	sub    $0x8,%esp
  801d6f:	ff 75 0c             	pushl  0xc(%ebp)
  801d72:	ff 75 08             	pushl  0x8(%ebp)
  801d75:	e8 0b 04 00 00       	call   802185 <sys_getSizeOfSharedObject>
  801d7a:	83 c4 10             	add    $0x10,%esp
  801d7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  801d80:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  801d84:	74 76                	je     801dfc <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801d86:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801d8d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d93:	01 d0                	add    %edx,%eax
  801d95:	48                   	dec    %eax
  801d96:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801d99:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d9c:	ba 00 00 00 00       	mov    $0x0,%edx
  801da1:	f7 75 ec             	divl   -0x14(%ebp)
  801da4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801da7:	29 d0                	sub    %edx,%eax
  801da9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801dac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801db3:	e8 1e 06 00 00       	call   8023d6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801db8:	85 c0                	test   %eax,%eax
  801dba:	74 11                	je     801dcd <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801dbc:	83 ec 0c             	sub    $0xc,%esp
  801dbf:	ff 75 e4             	pushl  -0x1c(%ebp)
  801dc2:	e8 89 0c 00 00       	call   802a50 <alloc_block_FF>
  801dc7:	83 c4 10             	add    $0x10,%esp
  801dca:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  801dcd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dd1:	74 29                	je     801dfc <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801dd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd6:	8b 40 08             	mov    0x8(%eax),%eax
  801dd9:	83 ec 04             	sub    $0x4,%esp
  801ddc:	50                   	push   %eax
  801ddd:	ff 75 0c             	pushl  0xc(%ebp)
  801de0:	ff 75 08             	pushl  0x8(%ebp)
  801de3:	e8 ba 03 00 00       	call   8021a2 <sys_getSharedObject>
  801de8:	83 c4 10             	add    $0x10,%esp
  801deb:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  801dee:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  801df2:	74 08                	je     801dfc <sget+0x9b>
				return (void *)mem_block->sva;
  801df4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df7:	8b 40 08             	mov    0x8(%eax),%eax
  801dfa:	eb 05                	jmp    801e01 <sget+0xa0>
		}
	}
	return NULL;
  801dfc:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801e01:	c9                   	leave  
  801e02:	c3                   	ret    

00801e03 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801e03:	55                   	push   %ebp
  801e04:	89 e5                	mov    %esp,%ebp
  801e06:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e09:	e8 5c fb ff ff       	call   80196a <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801e0e:	83 ec 04             	sub    $0x4,%esp
  801e11:	68 78 45 80 00       	push   $0x804578
<<<<<<< HEAD
  801e16:	68 fc 00 00 00       	push   $0xfc
=======
  801e16:	68 f7 00 00 00       	push   $0xf7
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  801e1b:	68 47 45 80 00       	push   $0x804547
  801e20:	e8 01 e9 ff ff       	call   800726 <_panic>

00801e25 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801e25:	55                   	push   %ebp
  801e26:	89 e5                	mov    %esp,%ebp
  801e28:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()


	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801e2b:	83 ec 04             	sub    $0x4,%esp
  801e2e:	68 a0 45 80 00       	push   $0x8045a0
<<<<<<< HEAD
  801e33:	68 10 01 00 00       	push   $0x110
=======
  801e33:	68 0c 01 00 00       	push   $0x10c
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  801e38:	68 47 45 80 00       	push   $0x804547
  801e3d:	e8 e4 e8 ff ff       	call   800726 <_panic>

00801e42 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801e42:	55                   	push   %ebp
  801e43:	89 e5                	mov    %esp,%ebp
  801e45:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e48:	83 ec 04             	sub    $0x4,%esp
  801e4b:	68 c4 45 80 00       	push   $0x8045c4
<<<<<<< HEAD
  801e50:	68 1b 01 00 00       	push   $0x11b
=======
  801e50:	68 44 01 00 00       	push   $0x144
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  801e55:	68 47 45 80 00       	push   $0x804547
  801e5a:	e8 c7 e8 ff ff       	call   800726 <_panic>

00801e5f <shrink>:

}
void shrink(uint32 newSize)
{
  801e5f:	55                   	push   %ebp
  801e60:	89 e5                	mov    %esp,%ebp
  801e62:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e65:	83 ec 04             	sub    $0x4,%esp
  801e68:	68 c4 45 80 00       	push   $0x8045c4
<<<<<<< HEAD
  801e6d:	68 20 01 00 00       	push   $0x120
=======
  801e6d:	68 49 01 00 00       	push   $0x149
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  801e72:	68 47 45 80 00       	push   $0x804547
  801e77:	e8 aa e8 ff ff       	call   800726 <_panic>

00801e7c <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801e7c:	55                   	push   %ebp
  801e7d:	89 e5                	mov    %esp,%ebp
  801e7f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e82:	83 ec 04             	sub    $0x4,%esp
  801e85:	68 c4 45 80 00       	push   $0x8045c4
<<<<<<< HEAD
  801e8a:	68 25 01 00 00       	push   $0x125
=======
  801e8a:	68 4e 01 00 00       	push   $0x14e
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  801e8f:	68 47 45 80 00       	push   $0x804547
  801e94:	e8 8d e8 ff ff       	call   800726 <_panic>

00801e99 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801e99:	55                   	push   %ebp
  801e9a:	89 e5                	mov    %esp,%ebp
  801e9c:	57                   	push   %edi
  801e9d:	56                   	push   %esi
  801e9e:	53                   	push   %ebx
  801e9f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ea8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801eab:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801eae:	8b 7d 18             	mov    0x18(%ebp),%edi
  801eb1:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801eb4:	cd 30                	int    $0x30
  801eb6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801eb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ebc:	83 c4 10             	add    $0x10,%esp
  801ebf:	5b                   	pop    %ebx
  801ec0:	5e                   	pop    %esi
  801ec1:	5f                   	pop    %edi
  801ec2:	5d                   	pop    %ebp
  801ec3:	c3                   	ret    

00801ec4 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801ec4:	55                   	push   %ebp
  801ec5:	89 e5                	mov    %esp,%ebp
  801ec7:	83 ec 04             	sub    $0x4,%esp
  801eca:	8b 45 10             	mov    0x10(%ebp),%eax
  801ecd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801ed0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed7:	6a 00                	push   $0x0
  801ed9:	6a 00                	push   $0x0
  801edb:	52                   	push   %edx
  801edc:	ff 75 0c             	pushl  0xc(%ebp)
  801edf:	50                   	push   %eax
  801ee0:	6a 00                	push   $0x0
  801ee2:	e8 b2 ff ff ff       	call   801e99 <syscall>
  801ee7:	83 c4 18             	add    $0x18,%esp
}
  801eea:	90                   	nop
  801eeb:	c9                   	leave  
  801eec:	c3                   	ret    

00801eed <sys_cgetc>:

int
sys_cgetc(void)
{
  801eed:	55                   	push   %ebp
  801eee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801ef0:	6a 00                	push   $0x0
  801ef2:	6a 00                	push   $0x0
  801ef4:	6a 00                	push   $0x0
  801ef6:	6a 00                	push   $0x0
  801ef8:	6a 00                	push   $0x0
  801efa:	6a 01                	push   $0x1
  801efc:	e8 98 ff ff ff       	call   801e99 <syscall>
  801f01:	83 c4 18             	add    $0x18,%esp
}
  801f04:	c9                   	leave  
  801f05:	c3                   	ret    

00801f06 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801f06:	55                   	push   %ebp
  801f07:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801f09:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0f:	6a 00                	push   $0x0
  801f11:	6a 00                	push   $0x0
  801f13:	6a 00                	push   $0x0
  801f15:	52                   	push   %edx
  801f16:	50                   	push   %eax
  801f17:	6a 05                	push   $0x5
  801f19:	e8 7b ff ff ff       	call   801e99 <syscall>
  801f1e:	83 c4 18             	add    $0x18,%esp
}
  801f21:	c9                   	leave  
  801f22:	c3                   	ret    

00801f23 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801f23:	55                   	push   %ebp
  801f24:	89 e5                	mov    %esp,%ebp
  801f26:	56                   	push   %esi
  801f27:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801f28:	8b 75 18             	mov    0x18(%ebp),%esi
  801f2b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f2e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f31:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f34:	8b 45 08             	mov    0x8(%ebp),%eax
  801f37:	56                   	push   %esi
  801f38:	53                   	push   %ebx
  801f39:	51                   	push   %ecx
  801f3a:	52                   	push   %edx
  801f3b:	50                   	push   %eax
  801f3c:	6a 06                	push   $0x6
  801f3e:	e8 56 ff ff ff       	call   801e99 <syscall>
  801f43:	83 c4 18             	add    $0x18,%esp
}
  801f46:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f49:	5b                   	pop    %ebx
  801f4a:	5e                   	pop    %esi
  801f4b:	5d                   	pop    %ebp
  801f4c:	c3                   	ret    

00801f4d <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801f4d:	55                   	push   %ebp
  801f4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801f50:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f53:	8b 45 08             	mov    0x8(%ebp),%eax
  801f56:	6a 00                	push   $0x0
  801f58:	6a 00                	push   $0x0
  801f5a:	6a 00                	push   $0x0
  801f5c:	52                   	push   %edx
  801f5d:	50                   	push   %eax
  801f5e:	6a 07                	push   $0x7
  801f60:	e8 34 ff ff ff       	call   801e99 <syscall>
  801f65:	83 c4 18             	add    $0x18,%esp
}
  801f68:	c9                   	leave  
  801f69:	c3                   	ret    

00801f6a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801f6a:	55                   	push   %ebp
  801f6b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801f6d:	6a 00                	push   $0x0
  801f6f:	6a 00                	push   $0x0
  801f71:	6a 00                	push   $0x0
  801f73:	ff 75 0c             	pushl  0xc(%ebp)
  801f76:	ff 75 08             	pushl  0x8(%ebp)
  801f79:	6a 08                	push   $0x8
  801f7b:	e8 19 ff ff ff       	call   801e99 <syscall>
  801f80:	83 c4 18             	add    $0x18,%esp
}
  801f83:	c9                   	leave  
  801f84:	c3                   	ret    

00801f85 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801f85:	55                   	push   %ebp
  801f86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801f88:	6a 00                	push   $0x0
  801f8a:	6a 00                	push   $0x0
  801f8c:	6a 00                	push   $0x0
  801f8e:	6a 00                	push   $0x0
  801f90:	6a 00                	push   $0x0
  801f92:	6a 09                	push   $0x9
  801f94:	e8 00 ff ff ff       	call   801e99 <syscall>
  801f99:	83 c4 18             	add    $0x18,%esp
}
  801f9c:	c9                   	leave  
  801f9d:	c3                   	ret    

00801f9e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801f9e:	55                   	push   %ebp
  801f9f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801fa1:	6a 00                	push   $0x0
  801fa3:	6a 00                	push   $0x0
  801fa5:	6a 00                	push   $0x0
  801fa7:	6a 00                	push   $0x0
  801fa9:	6a 00                	push   $0x0
  801fab:	6a 0a                	push   $0xa
  801fad:	e8 e7 fe ff ff       	call   801e99 <syscall>
  801fb2:	83 c4 18             	add    $0x18,%esp
}
  801fb5:	c9                   	leave  
  801fb6:	c3                   	ret    

00801fb7 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801fb7:	55                   	push   %ebp
  801fb8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801fba:	6a 00                	push   $0x0
  801fbc:	6a 00                	push   $0x0
  801fbe:	6a 00                	push   $0x0
  801fc0:	6a 00                	push   $0x0
  801fc2:	6a 00                	push   $0x0
  801fc4:	6a 0b                	push   $0xb
  801fc6:	e8 ce fe ff ff       	call   801e99 <syscall>
  801fcb:	83 c4 18             	add    $0x18,%esp
}
  801fce:	c9                   	leave  
  801fcf:	c3                   	ret    

00801fd0 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801fd0:	55                   	push   %ebp
  801fd1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801fd3:	6a 00                	push   $0x0
  801fd5:	6a 00                	push   $0x0
  801fd7:	6a 00                	push   $0x0
  801fd9:	ff 75 0c             	pushl  0xc(%ebp)
  801fdc:	ff 75 08             	pushl  0x8(%ebp)
  801fdf:	6a 0f                	push   $0xf
  801fe1:	e8 b3 fe ff ff       	call   801e99 <syscall>
  801fe6:	83 c4 18             	add    $0x18,%esp
	return;
  801fe9:	90                   	nop
}
  801fea:	c9                   	leave  
  801feb:	c3                   	ret    

00801fec <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801fec:	55                   	push   %ebp
  801fed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801fef:	6a 00                	push   $0x0
  801ff1:	6a 00                	push   $0x0
  801ff3:	6a 00                	push   $0x0
  801ff5:	ff 75 0c             	pushl  0xc(%ebp)
  801ff8:	ff 75 08             	pushl  0x8(%ebp)
  801ffb:	6a 10                	push   $0x10
  801ffd:	e8 97 fe ff ff       	call   801e99 <syscall>
  802002:	83 c4 18             	add    $0x18,%esp
	return ;
  802005:	90                   	nop
}
  802006:	c9                   	leave  
  802007:	c3                   	ret    

00802008 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802008:	55                   	push   %ebp
  802009:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80200b:	6a 00                	push   $0x0
  80200d:	6a 00                	push   $0x0
  80200f:	ff 75 10             	pushl  0x10(%ebp)
  802012:	ff 75 0c             	pushl  0xc(%ebp)
  802015:	ff 75 08             	pushl  0x8(%ebp)
  802018:	6a 11                	push   $0x11
  80201a:	e8 7a fe ff ff       	call   801e99 <syscall>
  80201f:	83 c4 18             	add    $0x18,%esp
	return ;
  802022:	90                   	nop
}
  802023:	c9                   	leave  
  802024:	c3                   	ret    

00802025 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802025:	55                   	push   %ebp
  802026:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802028:	6a 00                	push   $0x0
  80202a:	6a 00                	push   $0x0
  80202c:	6a 00                	push   $0x0
  80202e:	6a 00                	push   $0x0
  802030:	6a 00                	push   $0x0
  802032:	6a 0c                	push   $0xc
  802034:	e8 60 fe ff ff       	call   801e99 <syscall>
  802039:	83 c4 18             	add    $0x18,%esp
}
  80203c:	c9                   	leave  
  80203d:	c3                   	ret    

0080203e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80203e:	55                   	push   %ebp
  80203f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802041:	6a 00                	push   $0x0
  802043:	6a 00                	push   $0x0
  802045:	6a 00                	push   $0x0
  802047:	6a 00                	push   $0x0
  802049:	ff 75 08             	pushl  0x8(%ebp)
  80204c:	6a 0d                	push   $0xd
  80204e:	e8 46 fe ff ff       	call   801e99 <syscall>
  802053:	83 c4 18             	add    $0x18,%esp
}
  802056:	c9                   	leave  
  802057:	c3                   	ret    

00802058 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802058:	55                   	push   %ebp
  802059:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80205b:	6a 00                	push   $0x0
  80205d:	6a 00                	push   $0x0
  80205f:	6a 00                	push   $0x0
  802061:	6a 00                	push   $0x0
  802063:	6a 00                	push   $0x0
  802065:	6a 0e                	push   $0xe
  802067:	e8 2d fe ff ff       	call   801e99 <syscall>
  80206c:	83 c4 18             	add    $0x18,%esp
}
  80206f:	90                   	nop
  802070:	c9                   	leave  
  802071:	c3                   	ret    

00802072 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802072:	55                   	push   %ebp
  802073:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802075:	6a 00                	push   $0x0
  802077:	6a 00                	push   $0x0
  802079:	6a 00                	push   $0x0
  80207b:	6a 00                	push   $0x0
  80207d:	6a 00                	push   $0x0
  80207f:	6a 13                	push   $0x13
  802081:	e8 13 fe ff ff       	call   801e99 <syscall>
  802086:	83 c4 18             	add    $0x18,%esp
}
  802089:	90                   	nop
  80208a:	c9                   	leave  
  80208b:	c3                   	ret    

0080208c <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80208c:	55                   	push   %ebp
  80208d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80208f:	6a 00                	push   $0x0
  802091:	6a 00                	push   $0x0
  802093:	6a 00                	push   $0x0
  802095:	6a 00                	push   $0x0
  802097:	6a 00                	push   $0x0
  802099:	6a 14                	push   $0x14
  80209b:	e8 f9 fd ff ff       	call   801e99 <syscall>
  8020a0:	83 c4 18             	add    $0x18,%esp
}
  8020a3:	90                   	nop
  8020a4:	c9                   	leave  
  8020a5:	c3                   	ret    

008020a6 <sys_cputc>:


void
sys_cputc(const char c)
{
  8020a6:	55                   	push   %ebp
  8020a7:	89 e5                	mov    %esp,%ebp
  8020a9:	83 ec 04             	sub    $0x4,%esp
  8020ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8020af:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8020b2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020b6:	6a 00                	push   $0x0
  8020b8:	6a 00                	push   $0x0
  8020ba:	6a 00                	push   $0x0
  8020bc:	6a 00                	push   $0x0
  8020be:	50                   	push   %eax
  8020bf:	6a 15                	push   $0x15
  8020c1:	e8 d3 fd ff ff       	call   801e99 <syscall>
  8020c6:	83 c4 18             	add    $0x18,%esp
}
  8020c9:	90                   	nop
  8020ca:	c9                   	leave  
  8020cb:	c3                   	ret    

008020cc <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8020cc:	55                   	push   %ebp
  8020cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8020cf:	6a 00                	push   $0x0
  8020d1:	6a 00                	push   $0x0
  8020d3:	6a 00                	push   $0x0
  8020d5:	6a 00                	push   $0x0
  8020d7:	6a 00                	push   $0x0
  8020d9:	6a 16                	push   $0x16
  8020db:	e8 b9 fd ff ff       	call   801e99 <syscall>
  8020e0:	83 c4 18             	add    $0x18,%esp
}
  8020e3:	90                   	nop
  8020e4:	c9                   	leave  
  8020e5:	c3                   	ret    

008020e6 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8020e6:	55                   	push   %ebp
  8020e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8020e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ec:	6a 00                	push   $0x0
  8020ee:	6a 00                	push   $0x0
  8020f0:	6a 00                	push   $0x0
  8020f2:	ff 75 0c             	pushl  0xc(%ebp)
  8020f5:	50                   	push   %eax
  8020f6:	6a 17                	push   $0x17
  8020f8:	e8 9c fd ff ff       	call   801e99 <syscall>
  8020fd:	83 c4 18             	add    $0x18,%esp
}
  802100:	c9                   	leave  
  802101:	c3                   	ret    

00802102 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802102:	55                   	push   %ebp
  802103:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802105:	8b 55 0c             	mov    0xc(%ebp),%edx
  802108:	8b 45 08             	mov    0x8(%ebp),%eax
  80210b:	6a 00                	push   $0x0
  80210d:	6a 00                	push   $0x0
  80210f:	6a 00                	push   $0x0
  802111:	52                   	push   %edx
  802112:	50                   	push   %eax
  802113:	6a 1a                	push   $0x1a
  802115:	e8 7f fd ff ff       	call   801e99 <syscall>
  80211a:	83 c4 18             	add    $0x18,%esp
}
  80211d:	c9                   	leave  
  80211e:	c3                   	ret    

0080211f <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80211f:	55                   	push   %ebp
  802120:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802122:	8b 55 0c             	mov    0xc(%ebp),%edx
  802125:	8b 45 08             	mov    0x8(%ebp),%eax
  802128:	6a 00                	push   $0x0
  80212a:	6a 00                	push   $0x0
  80212c:	6a 00                	push   $0x0
  80212e:	52                   	push   %edx
  80212f:	50                   	push   %eax
  802130:	6a 18                	push   $0x18
  802132:	e8 62 fd ff ff       	call   801e99 <syscall>
  802137:	83 c4 18             	add    $0x18,%esp
}
  80213a:	90                   	nop
  80213b:	c9                   	leave  
  80213c:	c3                   	ret    

0080213d <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80213d:	55                   	push   %ebp
  80213e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802140:	8b 55 0c             	mov    0xc(%ebp),%edx
  802143:	8b 45 08             	mov    0x8(%ebp),%eax
  802146:	6a 00                	push   $0x0
  802148:	6a 00                	push   $0x0
  80214a:	6a 00                	push   $0x0
  80214c:	52                   	push   %edx
  80214d:	50                   	push   %eax
  80214e:	6a 19                	push   $0x19
  802150:	e8 44 fd ff ff       	call   801e99 <syscall>
  802155:	83 c4 18             	add    $0x18,%esp
}
  802158:	90                   	nop
  802159:	c9                   	leave  
  80215a:	c3                   	ret    

0080215b <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80215b:	55                   	push   %ebp
  80215c:	89 e5                	mov    %esp,%ebp
  80215e:	83 ec 04             	sub    $0x4,%esp
  802161:	8b 45 10             	mov    0x10(%ebp),%eax
  802164:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802167:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80216a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80216e:	8b 45 08             	mov    0x8(%ebp),%eax
  802171:	6a 00                	push   $0x0
  802173:	51                   	push   %ecx
  802174:	52                   	push   %edx
  802175:	ff 75 0c             	pushl  0xc(%ebp)
  802178:	50                   	push   %eax
  802179:	6a 1b                	push   $0x1b
  80217b:	e8 19 fd ff ff       	call   801e99 <syscall>
  802180:	83 c4 18             	add    $0x18,%esp
}
  802183:	c9                   	leave  
  802184:	c3                   	ret    

00802185 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802185:	55                   	push   %ebp
  802186:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802188:	8b 55 0c             	mov    0xc(%ebp),%edx
  80218b:	8b 45 08             	mov    0x8(%ebp),%eax
  80218e:	6a 00                	push   $0x0
  802190:	6a 00                	push   $0x0
  802192:	6a 00                	push   $0x0
  802194:	52                   	push   %edx
  802195:	50                   	push   %eax
  802196:	6a 1c                	push   $0x1c
  802198:	e8 fc fc ff ff       	call   801e99 <syscall>
  80219d:	83 c4 18             	add    $0x18,%esp
}
  8021a0:	c9                   	leave  
  8021a1:	c3                   	ret    

008021a2 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8021a2:	55                   	push   %ebp
  8021a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8021a5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ae:	6a 00                	push   $0x0
  8021b0:	6a 00                	push   $0x0
  8021b2:	51                   	push   %ecx
  8021b3:	52                   	push   %edx
  8021b4:	50                   	push   %eax
  8021b5:	6a 1d                	push   $0x1d
  8021b7:	e8 dd fc ff ff       	call   801e99 <syscall>
  8021bc:	83 c4 18             	add    $0x18,%esp
}
  8021bf:	c9                   	leave  
  8021c0:	c3                   	ret    

008021c1 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8021c1:	55                   	push   %ebp
  8021c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8021c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ca:	6a 00                	push   $0x0
  8021cc:	6a 00                	push   $0x0
  8021ce:	6a 00                	push   $0x0
  8021d0:	52                   	push   %edx
  8021d1:	50                   	push   %eax
  8021d2:	6a 1e                	push   $0x1e
  8021d4:	e8 c0 fc ff ff       	call   801e99 <syscall>
  8021d9:	83 c4 18             	add    $0x18,%esp
}
  8021dc:	c9                   	leave  
  8021dd:	c3                   	ret    

008021de <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8021de:	55                   	push   %ebp
  8021df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8021e1:	6a 00                	push   $0x0
  8021e3:	6a 00                	push   $0x0
  8021e5:	6a 00                	push   $0x0
  8021e7:	6a 00                	push   $0x0
  8021e9:	6a 00                	push   $0x0
  8021eb:	6a 1f                	push   $0x1f
  8021ed:	e8 a7 fc ff ff       	call   801e99 <syscall>
  8021f2:	83 c4 18             	add    $0x18,%esp
}
  8021f5:	c9                   	leave  
  8021f6:	c3                   	ret    

008021f7 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8021f7:	55                   	push   %ebp
  8021f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8021fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fd:	6a 00                	push   $0x0
  8021ff:	ff 75 14             	pushl  0x14(%ebp)
  802202:	ff 75 10             	pushl  0x10(%ebp)
  802205:	ff 75 0c             	pushl  0xc(%ebp)
  802208:	50                   	push   %eax
  802209:	6a 20                	push   $0x20
  80220b:	e8 89 fc ff ff       	call   801e99 <syscall>
  802210:	83 c4 18             	add    $0x18,%esp
}
  802213:	c9                   	leave  
  802214:	c3                   	ret    

00802215 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802215:	55                   	push   %ebp
  802216:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802218:	8b 45 08             	mov    0x8(%ebp),%eax
  80221b:	6a 00                	push   $0x0
  80221d:	6a 00                	push   $0x0
  80221f:	6a 00                	push   $0x0
  802221:	6a 00                	push   $0x0
  802223:	50                   	push   %eax
  802224:	6a 21                	push   $0x21
  802226:	e8 6e fc ff ff       	call   801e99 <syscall>
  80222b:	83 c4 18             	add    $0x18,%esp
}
  80222e:	90                   	nop
  80222f:	c9                   	leave  
  802230:	c3                   	ret    

00802231 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802231:	55                   	push   %ebp
  802232:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802234:	8b 45 08             	mov    0x8(%ebp),%eax
  802237:	6a 00                	push   $0x0
  802239:	6a 00                	push   $0x0
  80223b:	6a 00                	push   $0x0
  80223d:	6a 00                	push   $0x0
  80223f:	50                   	push   %eax
  802240:	6a 22                	push   $0x22
  802242:	e8 52 fc ff ff       	call   801e99 <syscall>
  802247:	83 c4 18             	add    $0x18,%esp
}
  80224a:	c9                   	leave  
  80224b:	c3                   	ret    

0080224c <sys_getenvid>:

int32 sys_getenvid(void)
{
  80224c:	55                   	push   %ebp
  80224d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80224f:	6a 00                	push   $0x0
  802251:	6a 00                	push   $0x0
  802253:	6a 00                	push   $0x0
  802255:	6a 00                	push   $0x0
  802257:	6a 00                	push   $0x0
  802259:	6a 02                	push   $0x2
  80225b:	e8 39 fc ff ff       	call   801e99 <syscall>
  802260:	83 c4 18             	add    $0x18,%esp
}
  802263:	c9                   	leave  
  802264:	c3                   	ret    

00802265 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802265:	55                   	push   %ebp
  802266:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802268:	6a 00                	push   $0x0
  80226a:	6a 00                	push   $0x0
  80226c:	6a 00                	push   $0x0
  80226e:	6a 00                	push   $0x0
  802270:	6a 00                	push   $0x0
  802272:	6a 03                	push   $0x3
  802274:	e8 20 fc ff ff       	call   801e99 <syscall>
  802279:	83 c4 18             	add    $0x18,%esp
}
  80227c:	c9                   	leave  
  80227d:	c3                   	ret    

0080227e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80227e:	55                   	push   %ebp
  80227f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802281:	6a 00                	push   $0x0
  802283:	6a 00                	push   $0x0
  802285:	6a 00                	push   $0x0
  802287:	6a 00                	push   $0x0
  802289:	6a 00                	push   $0x0
  80228b:	6a 04                	push   $0x4
  80228d:	e8 07 fc ff ff       	call   801e99 <syscall>
  802292:	83 c4 18             	add    $0x18,%esp
}
  802295:	c9                   	leave  
  802296:	c3                   	ret    

00802297 <sys_exit_env>:


void sys_exit_env(void)
{
  802297:	55                   	push   %ebp
  802298:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80229a:	6a 00                	push   $0x0
  80229c:	6a 00                	push   $0x0
  80229e:	6a 00                	push   $0x0
  8022a0:	6a 00                	push   $0x0
  8022a2:	6a 00                	push   $0x0
  8022a4:	6a 23                	push   $0x23
  8022a6:	e8 ee fb ff ff       	call   801e99 <syscall>
  8022ab:	83 c4 18             	add    $0x18,%esp
}
  8022ae:	90                   	nop
  8022af:	c9                   	leave  
  8022b0:	c3                   	ret    

008022b1 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8022b1:	55                   	push   %ebp
  8022b2:	89 e5                	mov    %esp,%ebp
  8022b4:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8022b7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022ba:	8d 50 04             	lea    0x4(%eax),%edx
  8022bd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022c0:	6a 00                	push   $0x0
  8022c2:	6a 00                	push   $0x0
  8022c4:	6a 00                	push   $0x0
  8022c6:	52                   	push   %edx
  8022c7:	50                   	push   %eax
  8022c8:	6a 24                	push   $0x24
  8022ca:	e8 ca fb ff ff       	call   801e99 <syscall>
  8022cf:	83 c4 18             	add    $0x18,%esp
	return result;
  8022d2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022d8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8022db:	89 01                	mov    %eax,(%ecx)
  8022dd:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8022e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e3:	c9                   	leave  
  8022e4:	c2 04 00             	ret    $0x4

008022e7 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8022e7:	55                   	push   %ebp
  8022e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8022ea:	6a 00                	push   $0x0
  8022ec:	6a 00                	push   $0x0
  8022ee:	ff 75 10             	pushl  0x10(%ebp)
  8022f1:	ff 75 0c             	pushl  0xc(%ebp)
  8022f4:	ff 75 08             	pushl  0x8(%ebp)
  8022f7:	6a 12                	push   $0x12
  8022f9:	e8 9b fb ff ff       	call   801e99 <syscall>
  8022fe:	83 c4 18             	add    $0x18,%esp
	return ;
  802301:	90                   	nop
}
  802302:	c9                   	leave  
  802303:	c3                   	ret    

00802304 <sys_rcr2>:
uint32 sys_rcr2()
{
  802304:	55                   	push   %ebp
  802305:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802307:	6a 00                	push   $0x0
  802309:	6a 00                	push   $0x0
  80230b:	6a 00                	push   $0x0
  80230d:	6a 00                	push   $0x0
  80230f:	6a 00                	push   $0x0
  802311:	6a 25                	push   $0x25
  802313:	e8 81 fb ff ff       	call   801e99 <syscall>
  802318:	83 c4 18             	add    $0x18,%esp
}
  80231b:	c9                   	leave  
  80231c:	c3                   	ret    

0080231d <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80231d:	55                   	push   %ebp
  80231e:	89 e5                	mov    %esp,%ebp
  802320:	83 ec 04             	sub    $0x4,%esp
  802323:	8b 45 08             	mov    0x8(%ebp),%eax
  802326:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802329:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80232d:	6a 00                	push   $0x0
  80232f:	6a 00                	push   $0x0
  802331:	6a 00                	push   $0x0
  802333:	6a 00                	push   $0x0
  802335:	50                   	push   %eax
  802336:	6a 26                	push   $0x26
  802338:	e8 5c fb ff ff       	call   801e99 <syscall>
  80233d:	83 c4 18             	add    $0x18,%esp
	return ;
  802340:	90                   	nop
}
  802341:	c9                   	leave  
  802342:	c3                   	ret    

00802343 <rsttst>:
void rsttst()
{
  802343:	55                   	push   %ebp
  802344:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802346:	6a 00                	push   $0x0
  802348:	6a 00                	push   $0x0
  80234a:	6a 00                	push   $0x0
  80234c:	6a 00                	push   $0x0
  80234e:	6a 00                	push   $0x0
  802350:	6a 28                	push   $0x28
  802352:	e8 42 fb ff ff       	call   801e99 <syscall>
  802357:	83 c4 18             	add    $0x18,%esp
	return ;
  80235a:	90                   	nop
}
  80235b:	c9                   	leave  
  80235c:	c3                   	ret    

0080235d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80235d:	55                   	push   %ebp
  80235e:	89 e5                	mov    %esp,%ebp
  802360:	83 ec 04             	sub    $0x4,%esp
  802363:	8b 45 14             	mov    0x14(%ebp),%eax
  802366:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802369:	8b 55 18             	mov    0x18(%ebp),%edx
  80236c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802370:	52                   	push   %edx
  802371:	50                   	push   %eax
  802372:	ff 75 10             	pushl  0x10(%ebp)
  802375:	ff 75 0c             	pushl  0xc(%ebp)
  802378:	ff 75 08             	pushl  0x8(%ebp)
  80237b:	6a 27                	push   $0x27
  80237d:	e8 17 fb ff ff       	call   801e99 <syscall>
  802382:	83 c4 18             	add    $0x18,%esp
	return ;
  802385:	90                   	nop
}
  802386:	c9                   	leave  
  802387:	c3                   	ret    

00802388 <chktst>:
void chktst(uint32 n)
{
  802388:	55                   	push   %ebp
  802389:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80238b:	6a 00                	push   $0x0
  80238d:	6a 00                	push   $0x0
  80238f:	6a 00                	push   $0x0
  802391:	6a 00                	push   $0x0
  802393:	ff 75 08             	pushl  0x8(%ebp)
  802396:	6a 29                	push   $0x29
  802398:	e8 fc fa ff ff       	call   801e99 <syscall>
  80239d:	83 c4 18             	add    $0x18,%esp
	return ;
  8023a0:	90                   	nop
}
  8023a1:	c9                   	leave  
  8023a2:	c3                   	ret    

008023a3 <inctst>:

void inctst()
{
  8023a3:	55                   	push   %ebp
  8023a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8023a6:	6a 00                	push   $0x0
  8023a8:	6a 00                	push   $0x0
  8023aa:	6a 00                	push   $0x0
  8023ac:	6a 00                	push   $0x0
  8023ae:	6a 00                	push   $0x0
  8023b0:	6a 2a                	push   $0x2a
  8023b2:	e8 e2 fa ff ff       	call   801e99 <syscall>
  8023b7:	83 c4 18             	add    $0x18,%esp
	return ;
  8023ba:	90                   	nop
}
  8023bb:	c9                   	leave  
  8023bc:	c3                   	ret    

008023bd <gettst>:
uint32 gettst()
{
  8023bd:	55                   	push   %ebp
  8023be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8023c0:	6a 00                	push   $0x0
  8023c2:	6a 00                	push   $0x0
  8023c4:	6a 00                	push   $0x0
  8023c6:	6a 00                	push   $0x0
  8023c8:	6a 00                	push   $0x0
  8023ca:	6a 2b                	push   $0x2b
  8023cc:	e8 c8 fa ff ff       	call   801e99 <syscall>
  8023d1:	83 c4 18             	add    $0x18,%esp
}
  8023d4:	c9                   	leave  
  8023d5:	c3                   	ret    

008023d6 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8023d6:	55                   	push   %ebp
  8023d7:	89 e5                	mov    %esp,%ebp
  8023d9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023dc:	6a 00                	push   $0x0
  8023de:	6a 00                	push   $0x0
  8023e0:	6a 00                	push   $0x0
  8023e2:	6a 00                	push   $0x0
  8023e4:	6a 00                	push   $0x0
  8023e6:	6a 2c                	push   $0x2c
  8023e8:	e8 ac fa ff ff       	call   801e99 <syscall>
  8023ed:	83 c4 18             	add    $0x18,%esp
  8023f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8023f3:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8023f7:	75 07                	jne    802400 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8023f9:	b8 01 00 00 00       	mov    $0x1,%eax
  8023fe:	eb 05                	jmp    802405 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802400:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802405:	c9                   	leave  
  802406:	c3                   	ret    

00802407 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802407:	55                   	push   %ebp
  802408:	89 e5                	mov    %esp,%ebp
  80240a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80240d:	6a 00                	push   $0x0
  80240f:	6a 00                	push   $0x0
  802411:	6a 00                	push   $0x0
  802413:	6a 00                	push   $0x0
  802415:	6a 00                	push   $0x0
  802417:	6a 2c                	push   $0x2c
  802419:	e8 7b fa ff ff       	call   801e99 <syscall>
  80241e:	83 c4 18             	add    $0x18,%esp
  802421:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802424:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802428:	75 07                	jne    802431 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80242a:	b8 01 00 00 00       	mov    $0x1,%eax
  80242f:	eb 05                	jmp    802436 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802431:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802436:	c9                   	leave  
  802437:	c3                   	ret    

00802438 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802438:	55                   	push   %ebp
  802439:	89 e5                	mov    %esp,%ebp
  80243b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80243e:	6a 00                	push   $0x0
  802440:	6a 00                	push   $0x0
  802442:	6a 00                	push   $0x0
  802444:	6a 00                	push   $0x0
  802446:	6a 00                	push   $0x0
  802448:	6a 2c                	push   $0x2c
  80244a:	e8 4a fa ff ff       	call   801e99 <syscall>
  80244f:	83 c4 18             	add    $0x18,%esp
  802452:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802455:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802459:	75 07                	jne    802462 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80245b:	b8 01 00 00 00       	mov    $0x1,%eax
  802460:	eb 05                	jmp    802467 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802462:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802467:	c9                   	leave  
  802468:	c3                   	ret    

00802469 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802469:	55                   	push   %ebp
  80246a:	89 e5                	mov    %esp,%ebp
  80246c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80246f:	6a 00                	push   $0x0
  802471:	6a 00                	push   $0x0
  802473:	6a 00                	push   $0x0
  802475:	6a 00                	push   $0x0
  802477:	6a 00                	push   $0x0
  802479:	6a 2c                	push   $0x2c
  80247b:	e8 19 fa ff ff       	call   801e99 <syscall>
  802480:	83 c4 18             	add    $0x18,%esp
  802483:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802486:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80248a:	75 07                	jne    802493 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80248c:	b8 01 00 00 00       	mov    $0x1,%eax
  802491:	eb 05                	jmp    802498 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802493:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802498:	c9                   	leave  
  802499:	c3                   	ret    

0080249a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80249a:	55                   	push   %ebp
  80249b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80249d:	6a 00                	push   $0x0
  80249f:	6a 00                	push   $0x0
  8024a1:	6a 00                	push   $0x0
  8024a3:	6a 00                	push   $0x0
  8024a5:	ff 75 08             	pushl  0x8(%ebp)
  8024a8:	6a 2d                	push   $0x2d
  8024aa:	e8 ea f9 ff ff       	call   801e99 <syscall>
  8024af:	83 c4 18             	add    $0x18,%esp
	return ;
  8024b2:	90                   	nop
}
  8024b3:	c9                   	leave  
  8024b4:	c3                   	ret    

008024b5 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8024b5:	55                   	push   %ebp
  8024b6:	89 e5                	mov    %esp,%ebp
  8024b8:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8024b9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8024bc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c5:	6a 00                	push   $0x0
  8024c7:	53                   	push   %ebx
  8024c8:	51                   	push   %ecx
  8024c9:	52                   	push   %edx
  8024ca:	50                   	push   %eax
  8024cb:	6a 2e                	push   $0x2e
  8024cd:	e8 c7 f9 ff ff       	call   801e99 <syscall>
  8024d2:	83 c4 18             	add    $0x18,%esp
}
  8024d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024d8:	c9                   	leave  
  8024d9:	c3                   	ret    

008024da <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8024da:	55                   	push   %ebp
  8024db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8024dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e3:	6a 00                	push   $0x0
  8024e5:	6a 00                	push   $0x0
  8024e7:	6a 00                	push   $0x0
  8024e9:	52                   	push   %edx
  8024ea:	50                   	push   %eax
  8024eb:	6a 2f                	push   $0x2f
  8024ed:	e8 a7 f9 ff ff       	call   801e99 <syscall>
  8024f2:	83 c4 18             	add    $0x18,%esp
}
  8024f5:	c9                   	leave  
  8024f6:	c3                   	ret    

008024f7 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8024f7:	55                   	push   %ebp
  8024f8:	89 e5                	mov    %esp,%ebp
  8024fa:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8024fd:	83 ec 0c             	sub    $0xc,%esp
  802500:	68 d4 45 80 00       	push   $0x8045d4
  802505:	e8 d0 e4 ff ff       	call   8009da <cprintf>
  80250a:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80250d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802514:	83 ec 0c             	sub    $0xc,%esp
  802517:	68 00 46 80 00       	push   $0x804600
  80251c:	e8 b9 e4 ff ff       	call   8009da <cprintf>
  802521:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802524:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802528:	a1 38 51 80 00       	mov    0x805138,%eax
  80252d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802530:	eb 56                	jmp    802588 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802532:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802536:	74 1c                	je     802554 <print_mem_block_lists+0x5d>
  802538:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253b:	8b 50 08             	mov    0x8(%eax),%edx
  80253e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802541:	8b 48 08             	mov    0x8(%eax),%ecx
  802544:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802547:	8b 40 0c             	mov    0xc(%eax),%eax
  80254a:	01 c8                	add    %ecx,%eax
  80254c:	39 c2                	cmp    %eax,%edx
  80254e:	73 04                	jae    802554 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802550:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802554:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802557:	8b 50 08             	mov    0x8(%eax),%edx
  80255a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255d:	8b 40 0c             	mov    0xc(%eax),%eax
  802560:	01 c2                	add    %eax,%edx
  802562:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802565:	8b 40 08             	mov    0x8(%eax),%eax
  802568:	83 ec 04             	sub    $0x4,%esp
  80256b:	52                   	push   %edx
  80256c:	50                   	push   %eax
  80256d:	68 15 46 80 00       	push   $0x804615
  802572:	e8 63 e4 ff ff       	call   8009da <cprintf>
  802577:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80257a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802580:	a1 40 51 80 00       	mov    0x805140,%eax
  802585:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802588:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80258c:	74 07                	je     802595 <print_mem_block_lists+0x9e>
  80258e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802591:	8b 00                	mov    (%eax),%eax
  802593:	eb 05                	jmp    80259a <print_mem_block_lists+0xa3>
  802595:	b8 00 00 00 00       	mov    $0x0,%eax
  80259a:	a3 40 51 80 00       	mov    %eax,0x805140
  80259f:	a1 40 51 80 00       	mov    0x805140,%eax
  8025a4:	85 c0                	test   %eax,%eax
  8025a6:	75 8a                	jne    802532 <print_mem_block_lists+0x3b>
  8025a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ac:	75 84                	jne    802532 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8025ae:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8025b2:	75 10                	jne    8025c4 <print_mem_block_lists+0xcd>
  8025b4:	83 ec 0c             	sub    $0xc,%esp
  8025b7:	68 24 46 80 00       	push   $0x804624
  8025bc:	e8 19 e4 ff ff       	call   8009da <cprintf>
  8025c1:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8025c4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8025cb:	83 ec 0c             	sub    $0xc,%esp
  8025ce:	68 48 46 80 00       	push   $0x804648
  8025d3:	e8 02 e4 ff ff       	call   8009da <cprintf>
  8025d8:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8025db:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8025df:	a1 40 50 80 00       	mov    0x805040,%eax
  8025e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025e7:	eb 56                	jmp    80263f <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8025e9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025ed:	74 1c                	je     80260b <print_mem_block_lists+0x114>
  8025ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f2:	8b 50 08             	mov    0x8(%eax),%edx
  8025f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f8:	8b 48 08             	mov    0x8(%eax),%ecx
  8025fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025fe:	8b 40 0c             	mov    0xc(%eax),%eax
  802601:	01 c8                	add    %ecx,%eax
  802603:	39 c2                	cmp    %eax,%edx
  802605:	73 04                	jae    80260b <print_mem_block_lists+0x114>
			sorted = 0 ;
  802607:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80260b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260e:	8b 50 08             	mov    0x8(%eax),%edx
  802611:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802614:	8b 40 0c             	mov    0xc(%eax),%eax
  802617:	01 c2                	add    %eax,%edx
  802619:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261c:	8b 40 08             	mov    0x8(%eax),%eax
  80261f:	83 ec 04             	sub    $0x4,%esp
  802622:	52                   	push   %edx
  802623:	50                   	push   %eax
  802624:	68 15 46 80 00       	push   $0x804615
  802629:	e8 ac e3 ff ff       	call   8009da <cprintf>
  80262e:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802631:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802634:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802637:	a1 48 50 80 00       	mov    0x805048,%eax
  80263c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80263f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802643:	74 07                	je     80264c <print_mem_block_lists+0x155>
  802645:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802648:	8b 00                	mov    (%eax),%eax
  80264a:	eb 05                	jmp    802651 <print_mem_block_lists+0x15a>
  80264c:	b8 00 00 00 00       	mov    $0x0,%eax
  802651:	a3 48 50 80 00       	mov    %eax,0x805048
  802656:	a1 48 50 80 00       	mov    0x805048,%eax
  80265b:	85 c0                	test   %eax,%eax
  80265d:	75 8a                	jne    8025e9 <print_mem_block_lists+0xf2>
  80265f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802663:	75 84                	jne    8025e9 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802665:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802669:	75 10                	jne    80267b <print_mem_block_lists+0x184>
  80266b:	83 ec 0c             	sub    $0xc,%esp
  80266e:	68 60 46 80 00       	push   $0x804660
  802673:	e8 62 e3 ff ff       	call   8009da <cprintf>
  802678:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80267b:	83 ec 0c             	sub    $0xc,%esp
  80267e:	68 d4 45 80 00       	push   $0x8045d4
  802683:	e8 52 e3 ff ff       	call   8009da <cprintf>
  802688:	83 c4 10             	add    $0x10,%esp

}
  80268b:	90                   	nop
  80268c:	c9                   	leave  
  80268d:	c3                   	ret    

0080268e <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80268e:	55                   	push   %ebp
  80268f:	89 e5                	mov    %esp,%ebp
  802691:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802694:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80269b:	00 00 00 
  80269e:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8026a5:	00 00 00 
  8026a8:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8026af:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8026b2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8026b9:	e9 9e 00 00 00       	jmp    80275c <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8026be:	a1 50 50 80 00       	mov    0x805050,%eax
  8026c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026c6:	c1 e2 04             	shl    $0x4,%edx
  8026c9:	01 d0                	add    %edx,%eax
  8026cb:	85 c0                	test   %eax,%eax
  8026cd:	75 14                	jne    8026e3 <initialize_MemBlocksList+0x55>
  8026cf:	83 ec 04             	sub    $0x4,%esp
  8026d2:	68 88 46 80 00       	push   $0x804688
  8026d7:	6a 46                	push   $0x46
  8026d9:	68 ab 46 80 00       	push   $0x8046ab
  8026de:	e8 43 e0 ff ff       	call   800726 <_panic>
  8026e3:	a1 50 50 80 00       	mov    0x805050,%eax
  8026e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026eb:	c1 e2 04             	shl    $0x4,%edx
  8026ee:	01 d0                	add    %edx,%eax
  8026f0:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8026f6:	89 10                	mov    %edx,(%eax)
  8026f8:	8b 00                	mov    (%eax),%eax
  8026fa:	85 c0                	test   %eax,%eax
  8026fc:	74 18                	je     802716 <initialize_MemBlocksList+0x88>
  8026fe:	a1 48 51 80 00       	mov    0x805148,%eax
  802703:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802709:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80270c:	c1 e1 04             	shl    $0x4,%ecx
  80270f:	01 ca                	add    %ecx,%edx
  802711:	89 50 04             	mov    %edx,0x4(%eax)
  802714:	eb 12                	jmp    802728 <initialize_MemBlocksList+0x9a>
  802716:	a1 50 50 80 00       	mov    0x805050,%eax
  80271b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80271e:	c1 e2 04             	shl    $0x4,%edx
  802721:	01 d0                	add    %edx,%eax
  802723:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802728:	a1 50 50 80 00       	mov    0x805050,%eax
  80272d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802730:	c1 e2 04             	shl    $0x4,%edx
  802733:	01 d0                	add    %edx,%eax
  802735:	a3 48 51 80 00       	mov    %eax,0x805148
  80273a:	a1 50 50 80 00       	mov    0x805050,%eax
  80273f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802742:	c1 e2 04             	shl    $0x4,%edx
  802745:	01 d0                	add    %edx,%eax
  802747:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80274e:	a1 54 51 80 00       	mov    0x805154,%eax
  802753:	40                   	inc    %eax
  802754:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802759:	ff 45 f4             	incl   -0xc(%ebp)
  80275c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802762:	0f 82 56 ff ff ff    	jb     8026be <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802768:	90                   	nop
  802769:	c9                   	leave  
  80276a:	c3                   	ret    

0080276b <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80276b:	55                   	push   %ebp
  80276c:	89 e5                	mov    %esp,%ebp
  80276e:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802771:	8b 45 08             	mov    0x8(%ebp),%eax
  802774:	8b 00                	mov    (%eax),%eax
  802776:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802779:	eb 19                	jmp    802794 <find_block+0x29>
	{
		if(va==point->sva)
  80277b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80277e:	8b 40 08             	mov    0x8(%eax),%eax
  802781:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802784:	75 05                	jne    80278b <find_block+0x20>
		   return point;
  802786:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802789:	eb 36                	jmp    8027c1 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80278b:	8b 45 08             	mov    0x8(%ebp),%eax
  80278e:	8b 40 08             	mov    0x8(%eax),%eax
  802791:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802794:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802798:	74 07                	je     8027a1 <find_block+0x36>
  80279a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80279d:	8b 00                	mov    (%eax),%eax
  80279f:	eb 05                	jmp    8027a6 <find_block+0x3b>
  8027a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8027a9:	89 42 08             	mov    %eax,0x8(%edx)
  8027ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8027af:	8b 40 08             	mov    0x8(%eax),%eax
  8027b2:	85 c0                	test   %eax,%eax
  8027b4:	75 c5                	jne    80277b <find_block+0x10>
  8027b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8027ba:	75 bf                	jne    80277b <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8027bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027c1:	c9                   	leave  
  8027c2:	c3                   	ret    

008027c3 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8027c3:	55                   	push   %ebp
  8027c4:	89 e5                	mov    %esp,%ebp
  8027c6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8027c9:	a1 40 50 80 00       	mov    0x805040,%eax
  8027ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8027d1:	a1 44 50 80 00       	mov    0x805044,%eax
  8027d6:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8027d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027dc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8027df:	74 24                	je     802805 <insert_sorted_allocList+0x42>
  8027e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e4:	8b 50 08             	mov    0x8(%eax),%edx
  8027e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ea:	8b 40 08             	mov    0x8(%eax),%eax
  8027ed:	39 c2                	cmp    %eax,%edx
  8027ef:	76 14                	jbe    802805 <insert_sorted_allocList+0x42>
  8027f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f4:	8b 50 08             	mov    0x8(%eax),%edx
  8027f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027fa:	8b 40 08             	mov    0x8(%eax),%eax
  8027fd:	39 c2                	cmp    %eax,%edx
  8027ff:	0f 82 60 01 00 00    	jb     802965 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802805:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802809:	75 65                	jne    802870 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80280b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80280f:	75 14                	jne    802825 <insert_sorted_allocList+0x62>
  802811:	83 ec 04             	sub    $0x4,%esp
  802814:	68 88 46 80 00       	push   $0x804688
  802819:	6a 6b                	push   $0x6b
  80281b:	68 ab 46 80 00       	push   $0x8046ab
  802820:	e8 01 df ff ff       	call   800726 <_panic>
  802825:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80282b:	8b 45 08             	mov    0x8(%ebp),%eax
  80282e:	89 10                	mov    %edx,(%eax)
  802830:	8b 45 08             	mov    0x8(%ebp),%eax
  802833:	8b 00                	mov    (%eax),%eax
  802835:	85 c0                	test   %eax,%eax
  802837:	74 0d                	je     802846 <insert_sorted_allocList+0x83>
  802839:	a1 40 50 80 00       	mov    0x805040,%eax
  80283e:	8b 55 08             	mov    0x8(%ebp),%edx
  802841:	89 50 04             	mov    %edx,0x4(%eax)
  802844:	eb 08                	jmp    80284e <insert_sorted_allocList+0x8b>
  802846:	8b 45 08             	mov    0x8(%ebp),%eax
  802849:	a3 44 50 80 00       	mov    %eax,0x805044
  80284e:	8b 45 08             	mov    0x8(%ebp),%eax
  802851:	a3 40 50 80 00       	mov    %eax,0x805040
  802856:	8b 45 08             	mov    0x8(%ebp),%eax
  802859:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802860:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802865:	40                   	inc    %eax
  802866:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80286b:	e9 dc 01 00 00       	jmp    802a4c <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802870:	8b 45 08             	mov    0x8(%ebp),%eax
  802873:	8b 50 08             	mov    0x8(%eax),%edx
  802876:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802879:	8b 40 08             	mov    0x8(%eax),%eax
  80287c:	39 c2                	cmp    %eax,%edx
  80287e:	77 6c                	ja     8028ec <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802880:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802884:	74 06                	je     80288c <insert_sorted_allocList+0xc9>
  802886:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80288a:	75 14                	jne    8028a0 <insert_sorted_allocList+0xdd>
  80288c:	83 ec 04             	sub    $0x4,%esp
  80288f:	68 c4 46 80 00       	push   $0x8046c4
  802894:	6a 6f                	push   $0x6f
  802896:	68 ab 46 80 00       	push   $0x8046ab
  80289b:	e8 86 de ff ff       	call   800726 <_panic>
  8028a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a3:	8b 50 04             	mov    0x4(%eax),%edx
  8028a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a9:	89 50 04             	mov    %edx,0x4(%eax)
  8028ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8028af:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028b2:	89 10                	mov    %edx,(%eax)
  8028b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b7:	8b 40 04             	mov    0x4(%eax),%eax
  8028ba:	85 c0                	test   %eax,%eax
  8028bc:	74 0d                	je     8028cb <insert_sorted_allocList+0x108>
  8028be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c1:	8b 40 04             	mov    0x4(%eax),%eax
  8028c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8028c7:	89 10                	mov    %edx,(%eax)
  8028c9:	eb 08                	jmp    8028d3 <insert_sorted_allocList+0x110>
  8028cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ce:	a3 40 50 80 00       	mov    %eax,0x805040
  8028d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8028d9:	89 50 04             	mov    %edx,0x4(%eax)
  8028dc:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8028e1:	40                   	inc    %eax
  8028e2:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8028e7:	e9 60 01 00 00       	jmp    802a4c <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8028ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ef:	8b 50 08             	mov    0x8(%eax),%edx
  8028f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028f5:	8b 40 08             	mov    0x8(%eax),%eax
  8028f8:	39 c2                	cmp    %eax,%edx
  8028fa:	0f 82 4c 01 00 00    	jb     802a4c <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802900:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802904:	75 14                	jne    80291a <insert_sorted_allocList+0x157>
  802906:	83 ec 04             	sub    $0x4,%esp
  802909:	68 fc 46 80 00       	push   $0x8046fc
  80290e:	6a 73                	push   $0x73
  802910:	68 ab 46 80 00       	push   $0x8046ab
  802915:	e8 0c de ff ff       	call   800726 <_panic>
  80291a:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802920:	8b 45 08             	mov    0x8(%ebp),%eax
  802923:	89 50 04             	mov    %edx,0x4(%eax)
  802926:	8b 45 08             	mov    0x8(%ebp),%eax
  802929:	8b 40 04             	mov    0x4(%eax),%eax
  80292c:	85 c0                	test   %eax,%eax
  80292e:	74 0c                	je     80293c <insert_sorted_allocList+0x179>
  802930:	a1 44 50 80 00       	mov    0x805044,%eax
  802935:	8b 55 08             	mov    0x8(%ebp),%edx
  802938:	89 10                	mov    %edx,(%eax)
  80293a:	eb 08                	jmp    802944 <insert_sorted_allocList+0x181>
  80293c:	8b 45 08             	mov    0x8(%ebp),%eax
  80293f:	a3 40 50 80 00       	mov    %eax,0x805040
  802944:	8b 45 08             	mov    0x8(%ebp),%eax
  802947:	a3 44 50 80 00       	mov    %eax,0x805044
  80294c:	8b 45 08             	mov    0x8(%ebp),%eax
  80294f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802955:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80295a:	40                   	inc    %eax
  80295b:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802960:	e9 e7 00 00 00       	jmp    802a4c <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802965:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802968:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80296b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802972:	a1 40 50 80 00       	mov    0x805040,%eax
  802977:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80297a:	e9 9d 00 00 00       	jmp    802a1c <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80297f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802982:	8b 00                	mov    (%eax),%eax
  802984:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802987:	8b 45 08             	mov    0x8(%ebp),%eax
  80298a:	8b 50 08             	mov    0x8(%eax),%edx
  80298d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802990:	8b 40 08             	mov    0x8(%eax),%eax
  802993:	39 c2                	cmp    %eax,%edx
  802995:	76 7d                	jbe    802a14 <insert_sorted_allocList+0x251>
  802997:	8b 45 08             	mov    0x8(%ebp),%eax
  80299a:	8b 50 08             	mov    0x8(%eax),%edx
  80299d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029a0:	8b 40 08             	mov    0x8(%eax),%eax
  8029a3:	39 c2                	cmp    %eax,%edx
  8029a5:	73 6d                	jae    802a14 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8029a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029ab:	74 06                	je     8029b3 <insert_sorted_allocList+0x1f0>
  8029ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029b1:	75 14                	jne    8029c7 <insert_sorted_allocList+0x204>
  8029b3:	83 ec 04             	sub    $0x4,%esp
  8029b6:	68 20 47 80 00       	push   $0x804720
  8029bb:	6a 7f                	push   $0x7f
  8029bd:	68 ab 46 80 00       	push   $0x8046ab
  8029c2:	e8 5f dd ff ff       	call   800726 <_panic>
  8029c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ca:	8b 10                	mov    (%eax),%edx
  8029cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cf:	89 10                	mov    %edx,(%eax)
  8029d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d4:	8b 00                	mov    (%eax),%eax
  8029d6:	85 c0                	test   %eax,%eax
  8029d8:	74 0b                	je     8029e5 <insert_sorted_allocList+0x222>
  8029da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029dd:	8b 00                	mov    (%eax),%eax
  8029df:	8b 55 08             	mov    0x8(%ebp),%edx
  8029e2:	89 50 04             	mov    %edx,0x4(%eax)
  8029e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8029eb:	89 10                	mov    %edx,(%eax)
  8029ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029f3:	89 50 04             	mov    %edx,0x4(%eax)
  8029f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f9:	8b 00                	mov    (%eax),%eax
  8029fb:	85 c0                	test   %eax,%eax
  8029fd:	75 08                	jne    802a07 <insert_sorted_allocList+0x244>
  8029ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802a02:	a3 44 50 80 00       	mov    %eax,0x805044
  802a07:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a0c:	40                   	inc    %eax
  802a0d:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802a12:	eb 39                	jmp    802a4d <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802a14:	a1 48 50 80 00       	mov    0x805048,%eax
  802a19:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a20:	74 07                	je     802a29 <insert_sorted_allocList+0x266>
  802a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a25:	8b 00                	mov    (%eax),%eax
  802a27:	eb 05                	jmp    802a2e <insert_sorted_allocList+0x26b>
  802a29:	b8 00 00 00 00       	mov    $0x0,%eax
  802a2e:	a3 48 50 80 00       	mov    %eax,0x805048
  802a33:	a1 48 50 80 00       	mov    0x805048,%eax
  802a38:	85 c0                	test   %eax,%eax
  802a3a:	0f 85 3f ff ff ff    	jne    80297f <insert_sorted_allocList+0x1bc>
  802a40:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a44:	0f 85 35 ff ff ff    	jne    80297f <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802a4a:	eb 01                	jmp    802a4d <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802a4c:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802a4d:	90                   	nop
  802a4e:	c9                   	leave  
  802a4f:	c3                   	ret    

00802a50 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802a50:	55                   	push   %ebp
  802a51:	89 e5                	mov    %esp,%ebp
  802a53:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802a56:	a1 38 51 80 00       	mov    0x805138,%eax
  802a5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a5e:	e9 85 01 00 00       	jmp    802be8 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a66:	8b 40 0c             	mov    0xc(%eax),%eax
  802a69:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a6c:	0f 82 6e 01 00 00    	jb     802be0 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a75:	8b 40 0c             	mov    0xc(%eax),%eax
  802a78:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a7b:	0f 85 8a 00 00 00    	jne    802b0b <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802a81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a85:	75 17                	jne    802a9e <alloc_block_FF+0x4e>
  802a87:	83 ec 04             	sub    $0x4,%esp
  802a8a:	68 54 47 80 00       	push   $0x804754
  802a8f:	68 93 00 00 00       	push   $0x93
  802a94:	68 ab 46 80 00       	push   $0x8046ab
  802a99:	e8 88 dc ff ff       	call   800726 <_panic>
  802a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa1:	8b 00                	mov    (%eax),%eax
  802aa3:	85 c0                	test   %eax,%eax
  802aa5:	74 10                	je     802ab7 <alloc_block_FF+0x67>
  802aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aaa:	8b 00                	mov    (%eax),%eax
  802aac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aaf:	8b 52 04             	mov    0x4(%edx),%edx
  802ab2:	89 50 04             	mov    %edx,0x4(%eax)
  802ab5:	eb 0b                	jmp    802ac2 <alloc_block_FF+0x72>
  802ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aba:	8b 40 04             	mov    0x4(%eax),%eax
  802abd:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac5:	8b 40 04             	mov    0x4(%eax),%eax
  802ac8:	85 c0                	test   %eax,%eax
  802aca:	74 0f                	je     802adb <alloc_block_FF+0x8b>
  802acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acf:	8b 40 04             	mov    0x4(%eax),%eax
  802ad2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ad5:	8b 12                	mov    (%edx),%edx
  802ad7:	89 10                	mov    %edx,(%eax)
  802ad9:	eb 0a                	jmp    802ae5 <alloc_block_FF+0x95>
  802adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ade:	8b 00                	mov    (%eax),%eax
  802ae0:	a3 38 51 80 00       	mov    %eax,0x805138
  802ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802af8:	a1 44 51 80 00       	mov    0x805144,%eax
  802afd:	48                   	dec    %eax
  802afe:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802b03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b06:	e9 10 01 00 00       	jmp    802c1b <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802b0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0e:	8b 40 0c             	mov    0xc(%eax),%eax
  802b11:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b14:	0f 86 c6 00 00 00    	jbe    802be0 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b1a:	a1 48 51 80 00       	mov    0x805148,%eax
  802b1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b25:	8b 50 08             	mov    0x8(%eax),%edx
  802b28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2b:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802b2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b31:	8b 55 08             	mov    0x8(%ebp),%edx
  802b34:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b37:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b3b:	75 17                	jne    802b54 <alloc_block_FF+0x104>
  802b3d:	83 ec 04             	sub    $0x4,%esp
  802b40:	68 54 47 80 00       	push   $0x804754
  802b45:	68 9b 00 00 00       	push   $0x9b
  802b4a:	68 ab 46 80 00       	push   $0x8046ab
  802b4f:	e8 d2 db ff ff       	call   800726 <_panic>
  802b54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b57:	8b 00                	mov    (%eax),%eax
  802b59:	85 c0                	test   %eax,%eax
  802b5b:	74 10                	je     802b6d <alloc_block_FF+0x11d>
  802b5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b60:	8b 00                	mov    (%eax),%eax
  802b62:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b65:	8b 52 04             	mov    0x4(%edx),%edx
  802b68:	89 50 04             	mov    %edx,0x4(%eax)
  802b6b:	eb 0b                	jmp    802b78 <alloc_block_FF+0x128>
  802b6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b70:	8b 40 04             	mov    0x4(%eax),%eax
  802b73:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b7b:	8b 40 04             	mov    0x4(%eax),%eax
  802b7e:	85 c0                	test   %eax,%eax
  802b80:	74 0f                	je     802b91 <alloc_block_FF+0x141>
  802b82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b85:	8b 40 04             	mov    0x4(%eax),%eax
  802b88:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b8b:	8b 12                	mov    (%edx),%edx
  802b8d:	89 10                	mov    %edx,(%eax)
  802b8f:	eb 0a                	jmp    802b9b <alloc_block_FF+0x14b>
  802b91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b94:	8b 00                	mov    (%eax),%eax
  802b96:	a3 48 51 80 00       	mov    %eax,0x805148
  802b9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b9e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ba4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bae:	a1 54 51 80 00       	mov    0x805154,%eax
  802bb3:	48                   	dec    %eax
  802bb4:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802bb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbc:	8b 50 08             	mov    0x8(%eax),%edx
  802bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc2:	01 c2                	add    %eax,%edx
  802bc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc7:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802bca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcd:	8b 40 0c             	mov    0xc(%eax),%eax
  802bd0:	2b 45 08             	sub    0x8(%ebp),%eax
  802bd3:	89 c2                	mov    %eax,%edx
  802bd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd8:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802bdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bde:	eb 3b                	jmp    802c1b <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802be0:	a1 40 51 80 00       	mov    0x805140,%eax
  802be5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802be8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bec:	74 07                	je     802bf5 <alloc_block_FF+0x1a5>
  802bee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf1:	8b 00                	mov    (%eax),%eax
  802bf3:	eb 05                	jmp    802bfa <alloc_block_FF+0x1aa>
  802bf5:	b8 00 00 00 00       	mov    $0x0,%eax
  802bfa:	a3 40 51 80 00       	mov    %eax,0x805140
  802bff:	a1 40 51 80 00       	mov    0x805140,%eax
  802c04:	85 c0                	test   %eax,%eax
  802c06:	0f 85 57 fe ff ff    	jne    802a63 <alloc_block_FF+0x13>
  802c0c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c10:	0f 85 4d fe ff ff    	jne    802a63 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802c16:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c1b:	c9                   	leave  
  802c1c:	c3                   	ret    

00802c1d <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802c1d:	55                   	push   %ebp
  802c1e:	89 e5                	mov    %esp,%ebp
  802c20:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802c23:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802c2a:	a1 38 51 80 00       	mov    0x805138,%eax
  802c2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c32:	e9 df 00 00 00       	jmp    802d16 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3a:	8b 40 0c             	mov    0xc(%eax),%eax
  802c3d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c40:	0f 82 c8 00 00 00    	jb     802d0e <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802c46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c49:	8b 40 0c             	mov    0xc(%eax),%eax
  802c4c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c4f:	0f 85 8a 00 00 00    	jne    802cdf <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802c55:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c59:	75 17                	jne    802c72 <alloc_block_BF+0x55>
  802c5b:	83 ec 04             	sub    $0x4,%esp
  802c5e:	68 54 47 80 00       	push   $0x804754
  802c63:	68 b7 00 00 00       	push   $0xb7
  802c68:	68 ab 46 80 00       	push   $0x8046ab
  802c6d:	e8 b4 da ff ff       	call   800726 <_panic>
  802c72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c75:	8b 00                	mov    (%eax),%eax
  802c77:	85 c0                	test   %eax,%eax
  802c79:	74 10                	je     802c8b <alloc_block_BF+0x6e>
  802c7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7e:	8b 00                	mov    (%eax),%eax
  802c80:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c83:	8b 52 04             	mov    0x4(%edx),%edx
  802c86:	89 50 04             	mov    %edx,0x4(%eax)
  802c89:	eb 0b                	jmp    802c96 <alloc_block_BF+0x79>
  802c8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8e:	8b 40 04             	mov    0x4(%eax),%eax
  802c91:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c99:	8b 40 04             	mov    0x4(%eax),%eax
  802c9c:	85 c0                	test   %eax,%eax
  802c9e:	74 0f                	je     802caf <alloc_block_BF+0x92>
  802ca0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca3:	8b 40 04             	mov    0x4(%eax),%eax
  802ca6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ca9:	8b 12                	mov    (%edx),%edx
  802cab:	89 10                	mov    %edx,(%eax)
  802cad:	eb 0a                	jmp    802cb9 <alloc_block_BF+0x9c>
  802caf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb2:	8b 00                	mov    (%eax),%eax
  802cb4:	a3 38 51 80 00       	mov    %eax,0x805138
  802cb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ccc:	a1 44 51 80 00       	mov    0x805144,%eax
  802cd1:	48                   	dec    %eax
  802cd2:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802cd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cda:	e9 4d 01 00 00       	jmp    802e2c <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802cdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce2:	8b 40 0c             	mov    0xc(%eax),%eax
  802ce5:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ce8:	76 24                	jbe    802d0e <alloc_block_BF+0xf1>
  802cea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ced:	8b 40 0c             	mov    0xc(%eax),%eax
  802cf0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802cf3:	73 19                	jae    802d0e <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802cf5:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802cfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cff:	8b 40 0c             	mov    0xc(%eax),%eax
  802d02:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802d05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d08:	8b 40 08             	mov    0x8(%eax),%eax
  802d0b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802d0e:	a1 40 51 80 00       	mov    0x805140,%eax
  802d13:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d16:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d1a:	74 07                	je     802d23 <alloc_block_BF+0x106>
  802d1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1f:	8b 00                	mov    (%eax),%eax
  802d21:	eb 05                	jmp    802d28 <alloc_block_BF+0x10b>
  802d23:	b8 00 00 00 00       	mov    $0x0,%eax
  802d28:	a3 40 51 80 00       	mov    %eax,0x805140
  802d2d:	a1 40 51 80 00       	mov    0x805140,%eax
  802d32:	85 c0                	test   %eax,%eax
  802d34:	0f 85 fd fe ff ff    	jne    802c37 <alloc_block_BF+0x1a>
  802d3a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d3e:	0f 85 f3 fe ff ff    	jne    802c37 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802d44:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d48:	0f 84 d9 00 00 00    	je     802e27 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d4e:	a1 48 51 80 00       	mov    0x805148,%eax
  802d53:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802d56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d59:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d5c:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802d5f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d62:	8b 55 08             	mov    0x8(%ebp),%edx
  802d65:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802d68:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802d6c:	75 17                	jne    802d85 <alloc_block_BF+0x168>
  802d6e:	83 ec 04             	sub    $0x4,%esp
  802d71:	68 54 47 80 00       	push   $0x804754
  802d76:	68 c7 00 00 00       	push   $0xc7
  802d7b:	68 ab 46 80 00       	push   $0x8046ab
  802d80:	e8 a1 d9 ff ff       	call   800726 <_panic>
  802d85:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d88:	8b 00                	mov    (%eax),%eax
  802d8a:	85 c0                	test   %eax,%eax
  802d8c:	74 10                	je     802d9e <alloc_block_BF+0x181>
  802d8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d91:	8b 00                	mov    (%eax),%eax
  802d93:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d96:	8b 52 04             	mov    0x4(%edx),%edx
  802d99:	89 50 04             	mov    %edx,0x4(%eax)
  802d9c:	eb 0b                	jmp    802da9 <alloc_block_BF+0x18c>
  802d9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802da1:	8b 40 04             	mov    0x4(%eax),%eax
  802da4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802da9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dac:	8b 40 04             	mov    0x4(%eax),%eax
  802daf:	85 c0                	test   %eax,%eax
  802db1:	74 0f                	je     802dc2 <alloc_block_BF+0x1a5>
  802db3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802db6:	8b 40 04             	mov    0x4(%eax),%eax
  802db9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802dbc:	8b 12                	mov    (%edx),%edx
  802dbe:	89 10                	mov    %edx,(%eax)
  802dc0:	eb 0a                	jmp    802dcc <alloc_block_BF+0x1af>
  802dc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dc5:	8b 00                	mov    (%eax),%eax
  802dc7:	a3 48 51 80 00       	mov    %eax,0x805148
  802dcc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dcf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dd5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dd8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ddf:	a1 54 51 80 00       	mov    0x805154,%eax
  802de4:	48                   	dec    %eax
  802de5:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802dea:	83 ec 08             	sub    $0x8,%esp
  802ded:	ff 75 ec             	pushl  -0x14(%ebp)
  802df0:	68 38 51 80 00       	push   $0x805138
  802df5:	e8 71 f9 ff ff       	call   80276b <find_block>
  802dfa:	83 c4 10             	add    $0x10,%esp
  802dfd:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802e00:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e03:	8b 50 08             	mov    0x8(%eax),%edx
  802e06:	8b 45 08             	mov    0x8(%ebp),%eax
  802e09:	01 c2                	add    %eax,%edx
  802e0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e0e:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802e11:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e14:	8b 40 0c             	mov    0xc(%eax),%eax
  802e17:	2b 45 08             	sub    0x8(%ebp),%eax
  802e1a:	89 c2                	mov    %eax,%edx
  802e1c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e1f:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802e22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e25:	eb 05                	jmp    802e2c <alloc_block_BF+0x20f>
	}
	return NULL;
  802e27:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e2c:	c9                   	leave  
  802e2d:	c3                   	ret    

00802e2e <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802e2e:	55                   	push   %ebp
  802e2f:	89 e5                	mov    %esp,%ebp
  802e31:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802e34:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e39:	85 c0                	test   %eax,%eax
  802e3b:	0f 85 de 01 00 00    	jne    80301f <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802e41:	a1 38 51 80 00       	mov    0x805138,%eax
  802e46:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e49:	e9 9e 01 00 00       	jmp    802fec <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802e4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e51:	8b 40 0c             	mov    0xc(%eax),%eax
  802e54:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e57:	0f 82 87 01 00 00    	jb     802fe4 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802e5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e60:	8b 40 0c             	mov    0xc(%eax),%eax
  802e63:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e66:	0f 85 95 00 00 00    	jne    802f01 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802e6c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e70:	75 17                	jne    802e89 <alloc_block_NF+0x5b>
  802e72:	83 ec 04             	sub    $0x4,%esp
  802e75:	68 54 47 80 00       	push   $0x804754
  802e7a:	68 e0 00 00 00       	push   $0xe0
  802e7f:	68 ab 46 80 00       	push   $0x8046ab
  802e84:	e8 9d d8 ff ff       	call   800726 <_panic>
  802e89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8c:	8b 00                	mov    (%eax),%eax
  802e8e:	85 c0                	test   %eax,%eax
  802e90:	74 10                	je     802ea2 <alloc_block_NF+0x74>
  802e92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e95:	8b 00                	mov    (%eax),%eax
  802e97:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e9a:	8b 52 04             	mov    0x4(%edx),%edx
  802e9d:	89 50 04             	mov    %edx,0x4(%eax)
  802ea0:	eb 0b                	jmp    802ead <alloc_block_NF+0x7f>
  802ea2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea5:	8b 40 04             	mov    0x4(%eax),%eax
  802ea8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ead:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb0:	8b 40 04             	mov    0x4(%eax),%eax
  802eb3:	85 c0                	test   %eax,%eax
  802eb5:	74 0f                	je     802ec6 <alloc_block_NF+0x98>
  802eb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eba:	8b 40 04             	mov    0x4(%eax),%eax
  802ebd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ec0:	8b 12                	mov    (%edx),%edx
  802ec2:	89 10                	mov    %edx,(%eax)
  802ec4:	eb 0a                	jmp    802ed0 <alloc_block_NF+0xa2>
  802ec6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec9:	8b 00                	mov    (%eax),%eax
  802ecb:	a3 38 51 80 00       	mov    %eax,0x805138
  802ed0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ed9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ee3:	a1 44 51 80 00       	mov    0x805144,%eax
  802ee8:	48                   	dec    %eax
  802ee9:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef1:	8b 40 08             	mov    0x8(%eax),%eax
  802ef4:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   return  point;
  802ef9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efc:	e9 f8 04 00 00       	jmp    8033f9 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802f01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f04:	8b 40 0c             	mov    0xc(%eax),%eax
  802f07:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f0a:	0f 86 d4 00 00 00    	jbe    802fe4 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802f10:	a1 48 51 80 00       	mov    0x805148,%eax
  802f15:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802f18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1b:	8b 50 08             	mov    0x8(%eax),%edx
  802f1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f21:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802f24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f27:	8b 55 08             	mov    0x8(%ebp),%edx
  802f2a:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802f2d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f31:	75 17                	jne    802f4a <alloc_block_NF+0x11c>
  802f33:	83 ec 04             	sub    $0x4,%esp
  802f36:	68 54 47 80 00       	push   $0x804754
  802f3b:	68 e9 00 00 00       	push   $0xe9
  802f40:	68 ab 46 80 00       	push   $0x8046ab
  802f45:	e8 dc d7 ff ff       	call   800726 <_panic>
  802f4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f4d:	8b 00                	mov    (%eax),%eax
  802f4f:	85 c0                	test   %eax,%eax
  802f51:	74 10                	je     802f63 <alloc_block_NF+0x135>
  802f53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f56:	8b 00                	mov    (%eax),%eax
  802f58:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f5b:	8b 52 04             	mov    0x4(%edx),%edx
  802f5e:	89 50 04             	mov    %edx,0x4(%eax)
  802f61:	eb 0b                	jmp    802f6e <alloc_block_NF+0x140>
  802f63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f66:	8b 40 04             	mov    0x4(%eax),%eax
  802f69:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f71:	8b 40 04             	mov    0x4(%eax),%eax
  802f74:	85 c0                	test   %eax,%eax
  802f76:	74 0f                	je     802f87 <alloc_block_NF+0x159>
  802f78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f7b:	8b 40 04             	mov    0x4(%eax),%eax
  802f7e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f81:	8b 12                	mov    (%edx),%edx
  802f83:	89 10                	mov    %edx,(%eax)
  802f85:	eb 0a                	jmp    802f91 <alloc_block_NF+0x163>
  802f87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f8a:	8b 00                	mov    (%eax),%eax
  802f8c:	a3 48 51 80 00       	mov    %eax,0x805148
  802f91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f94:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f9d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fa4:	a1 54 51 80 00       	mov    0x805154,%eax
  802fa9:	48                   	dec    %eax
  802faa:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802faf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb2:	8b 40 08             	mov    0x8(%eax),%eax
  802fb5:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   point->sva += size;
  802fba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbd:	8b 50 08             	mov    0x8(%eax),%edx
  802fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc3:	01 c2                	add    %eax,%edx
  802fc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc8:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802fcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fce:	8b 40 0c             	mov    0xc(%eax),%eax
  802fd1:	2b 45 08             	sub    0x8(%ebp),%eax
  802fd4:	89 c2                	mov    %eax,%edx
  802fd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd9:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802fdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fdf:	e9 15 04 00 00       	jmp    8033f9 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802fe4:	a1 40 51 80 00       	mov    0x805140,%eax
  802fe9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ff0:	74 07                	je     802ff9 <alloc_block_NF+0x1cb>
  802ff2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff5:	8b 00                	mov    (%eax),%eax
  802ff7:	eb 05                	jmp    802ffe <alloc_block_NF+0x1d0>
  802ff9:	b8 00 00 00 00       	mov    $0x0,%eax
  802ffe:	a3 40 51 80 00       	mov    %eax,0x805140
  803003:	a1 40 51 80 00       	mov    0x805140,%eax
  803008:	85 c0                	test   %eax,%eax
  80300a:	0f 85 3e fe ff ff    	jne    802e4e <alloc_block_NF+0x20>
  803010:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803014:	0f 85 34 fe ff ff    	jne    802e4e <alloc_block_NF+0x20>
  80301a:	e9 d5 03 00 00       	jmp    8033f4 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80301f:	a1 38 51 80 00       	mov    0x805138,%eax
  803024:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803027:	e9 b1 01 00 00       	jmp    8031dd <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  80302c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302f:	8b 50 08             	mov    0x8(%eax),%edx
  803032:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803037:	39 c2                	cmp    %eax,%edx
  803039:	0f 82 96 01 00 00    	jb     8031d5 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  80303f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803042:	8b 40 0c             	mov    0xc(%eax),%eax
  803045:	3b 45 08             	cmp    0x8(%ebp),%eax
  803048:	0f 82 87 01 00 00    	jb     8031d5 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  80304e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803051:	8b 40 0c             	mov    0xc(%eax),%eax
  803054:	3b 45 08             	cmp    0x8(%ebp),%eax
  803057:	0f 85 95 00 00 00    	jne    8030f2 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80305d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803061:	75 17                	jne    80307a <alloc_block_NF+0x24c>
  803063:	83 ec 04             	sub    $0x4,%esp
  803066:	68 54 47 80 00       	push   $0x804754
  80306b:	68 fc 00 00 00       	push   $0xfc
  803070:	68 ab 46 80 00       	push   $0x8046ab
  803075:	e8 ac d6 ff ff       	call   800726 <_panic>
  80307a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307d:	8b 00                	mov    (%eax),%eax
  80307f:	85 c0                	test   %eax,%eax
  803081:	74 10                	je     803093 <alloc_block_NF+0x265>
  803083:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803086:	8b 00                	mov    (%eax),%eax
  803088:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80308b:	8b 52 04             	mov    0x4(%edx),%edx
  80308e:	89 50 04             	mov    %edx,0x4(%eax)
  803091:	eb 0b                	jmp    80309e <alloc_block_NF+0x270>
  803093:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803096:	8b 40 04             	mov    0x4(%eax),%eax
  803099:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80309e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a1:	8b 40 04             	mov    0x4(%eax),%eax
  8030a4:	85 c0                	test   %eax,%eax
  8030a6:	74 0f                	je     8030b7 <alloc_block_NF+0x289>
  8030a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ab:	8b 40 04             	mov    0x4(%eax),%eax
  8030ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030b1:	8b 12                	mov    (%edx),%edx
  8030b3:	89 10                	mov    %edx,(%eax)
  8030b5:	eb 0a                	jmp    8030c1 <alloc_block_NF+0x293>
  8030b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ba:	8b 00                	mov    (%eax),%eax
  8030bc:	a3 38 51 80 00       	mov    %eax,0x805138
  8030c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030cd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030d4:	a1 44 51 80 00       	mov    0x805144,%eax
  8030d9:	48                   	dec    %eax
  8030da:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8030df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e2:	8b 40 08             	mov    0x8(%eax),%eax
  8030e5:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  8030ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ed:	e9 07 03 00 00       	jmp    8033f9 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8030f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8030f8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030fb:	0f 86 d4 00 00 00    	jbe    8031d5 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803101:	a1 48 51 80 00       	mov    0x805148,%eax
  803106:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  803109:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310c:	8b 50 08             	mov    0x8(%eax),%edx
  80310f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803112:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803115:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803118:	8b 55 08             	mov    0x8(%ebp),%edx
  80311b:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80311e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803122:	75 17                	jne    80313b <alloc_block_NF+0x30d>
  803124:	83 ec 04             	sub    $0x4,%esp
  803127:	68 54 47 80 00       	push   $0x804754
  80312c:	68 04 01 00 00       	push   $0x104
  803131:	68 ab 46 80 00       	push   $0x8046ab
  803136:	e8 eb d5 ff ff       	call   800726 <_panic>
  80313b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80313e:	8b 00                	mov    (%eax),%eax
  803140:	85 c0                	test   %eax,%eax
  803142:	74 10                	je     803154 <alloc_block_NF+0x326>
  803144:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803147:	8b 00                	mov    (%eax),%eax
  803149:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80314c:	8b 52 04             	mov    0x4(%edx),%edx
  80314f:	89 50 04             	mov    %edx,0x4(%eax)
  803152:	eb 0b                	jmp    80315f <alloc_block_NF+0x331>
  803154:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803157:	8b 40 04             	mov    0x4(%eax),%eax
  80315a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80315f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803162:	8b 40 04             	mov    0x4(%eax),%eax
  803165:	85 c0                	test   %eax,%eax
  803167:	74 0f                	je     803178 <alloc_block_NF+0x34a>
  803169:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80316c:	8b 40 04             	mov    0x4(%eax),%eax
  80316f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803172:	8b 12                	mov    (%edx),%edx
  803174:	89 10                	mov    %edx,(%eax)
  803176:	eb 0a                	jmp    803182 <alloc_block_NF+0x354>
  803178:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80317b:	8b 00                	mov    (%eax),%eax
  80317d:	a3 48 51 80 00       	mov    %eax,0x805148
  803182:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803185:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80318b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80318e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803195:	a1 54 51 80 00       	mov    0x805154,%eax
  80319a:	48                   	dec    %eax
  80319b:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8031a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a3:	8b 40 08             	mov    0x8(%eax),%eax
  8031a6:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  8031ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ae:	8b 50 08             	mov    0x8(%eax),%edx
  8031b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b4:	01 c2                	add    %eax,%edx
  8031b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b9:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8031bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8031c2:	2b 45 08             	sub    0x8(%ebp),%eax
  8031c5:	89 c2                	mov    %eax,%edx
  8031c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ca:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8031cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d0:	e9 24 02 00 00       	jmp    8033f9 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8031d5:	a1 40 51 80 00       	mov    0x805140,%eax
  8031da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031e1:	74 07                	je     8031ea <alloc_block_NF+0x3bc>
  8031e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e6:	8b 00                	mov    (%eax),%eax
  8031e8:	eb 05                	jmp    8031ef <alloc_block_NF+0x3c1>
  8031ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8031ef:	a3 40 51 80 00       	mov    %eax,0x805140
  8031f4:	a1 40 51 80 00       	mov    0x805140,%eax
  8031f9:	85 c0                	test   %eax,%eax
  8031fb:	0f 85 2b fe ff ff    	jne    80302c <alloc_block_NF+0x1fe>
  803201:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803205:	0f 85 21 fe ff ff    	jne    80302c <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  80320b:	a1 38 51 80 00       	mov    0x805138,%eax
  803210:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803213:	e9 ae 01 00 00       	jmp    8033c6 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  803218:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80321b:	8b 50 08             	mov    0x8(%eax),%edx
  80321e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803223:	39 c2                	cmp    %eax,%edx
  803225:	0f 83 93 01 00 00    	jae    8033be <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  80322b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322e:	8b 40 0c             	mov    0xc(%eax),%eax
  803231:	3b 45 08             	cmp    0x8(%ebp),%eax
  803234:	0f 82 84 01 00 00    	jb     8033be <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  80323a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80323d:	8b 40 0c             	mov    0xc(%eax),%eax
  803240:	3b 45 08             	cmp    0x8(%ebp),%eax
  803243:	0f 85 95 00 00 00    	jne    8032de <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803249:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80324d:	75 17                	jne    803266 <alloc_block_NF+0x438>
  80324f:	83 ec 04             	sub    $0x4,%esp
  803252:	68 54 47 80 00       	push   $0x804754
  803257:	68 14 01 00 00       	push   $0x114
  80325c:	68 ab 46 80 00       	push   $0x8046ab
  803261:	e8 c0 d4 ff ff       	call   800726 <_panic>
  803266:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803269:	8b 00                	mov    (%eax),%eax
  80326b:	85 c0                	test   %eax,%eax
  80326d:	74 10                	je     80327f <alloc_block_NF+0x451>
  80326f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803272:	8b 00                	mov    (%eax),%eax
  803274:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803277:	8b 52 04             	mov    0x4(%edx),%edx
  80327a:	89 50 04             	mov    %edx,0x4(%eax)
  80327d:	eb 0b                	jmp    80328a <alloc_block_NF+0x45c>
  80327f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803282:	8b 40 04             	mov    0x4(%eax),%eax
  803285:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80328a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328d:	8b 40 04             	mov    0x4(%eax),%eax
  803290:	85 c0                	test   %eax,%eax
  803292:	74 0f                	je     8032a3 <alloc_block_NF+0x475>
  803294:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803297:	8b 40 04             	mov    0x4(%eax),%eax
  80329a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80329d:	8b 12                	mov    (%edx),%edx
  80329f:	89 10                	mov    %edx,(%eax)
  8032a1:	eb 0a                	jmp    8032ad <alloc_block_NF+0x47f>
  8032a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a6:	8b 00                	mov    (%eax),%eax
  8032a8:	a3 38 51 80 00       	mov    %eax,0x805138
  8032ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032c0:	a1 44 51 80 00       	mov    0x805144,%eax
  8032c5:	48                   	dec    %eax
  8032c6:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8032cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ce:	8b 40 08             	mov    0x8(%eax),%eax
  8032d1:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  8032d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d9:	e9 1b 01 00 00       	jmp    8033f9 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8032de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8032e4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032e7:	0f 86 d1 00 00 00    	jbe    8033be <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8032ed:	a1 48 51 80 00       	mov    0x805148,%eax
  8032f2:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  8032f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f8:	8b 50 08             	mov    0x8(%eax),%edx
  8032fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032fe:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803301:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803304:	8b 55 08             	mov    0x8(%ebp),%edx
  803307:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80330a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80330e:	75 17                	jne    803327 <alloc_block_NF+0x4f9>
  803310:	83 ec 04             	sub    $0x4,%esp
  803313:	68 54 47 80 00       	push   $0x804754
  803318:	68 1c 01 00 00       	push   $0x11c
  80331d:	68 ab 46 80 00       	push   $0x8046ab
  803322:	e8 ff d3 ff ff       	call   800726 <_panic>
  803327:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80332a:	8b 00                	mov    (%eax),%eax
  80332c:	85 c0                	test   %eax,%eax
  80332e:	74 10                	je     803340 <alloc_block_NF+0x512>
  803330:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803333:	8b 00                	mov    (%eax),%eax
  803335:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803338:	8b 52 04             	mov    0x4(%edx),%edx
  80333b:	89 50 04             	mov    %edx,0x4(%eax)
  80333e:	eb 0b                	jmp    80334b <alloc_block_NF+0x51d>
  803340:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803343:	8b 40 04             	mov    0x4(%eax),%eax
  803346:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80334b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80334e:	8b 40 04             	mov    0x4(%eax),%eax
  803351:	85 c0                	test   %eax,%eax
  803353:	74 0f                	je     803364 <alloc_block_NF+0x536>
  803355:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803358:	8b 40 04             	mov    0x4(%eax),%eax
  80335b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80335e:	8b 12                	mov    (%edx),%edx
  803360:	89 10                	mov    %edx,(%eax)
  803362:	eb 0a                	jmp    80336e <alloc_block_NF+0x540>
  803364:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803367:	8b 00                	mov    (%eax),%eax
  803369:	a3 48 51 80 00       	mov    %eax,0x805148
  80336e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803371:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803377:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80337a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803381:	a1 54 51 80 00       	mov    0x805154,%eax
  803386:	48                   	dec    %eax
  803387:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  80338c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80338f:	8b 40 08             	mov    0x8(%eax),%eax
  803392:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  803397:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80339a:	8b 50 08             	mov    0x8(%eax),%edx
  80339d:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a0:	01 c2                	add    %eax,%edx
  8033a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a5:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8033a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8033ae:	2b 45 08             	sub    0x8(%ebp),%eax
  8033b1:	89 c2                	mov    %eax,%edx
  8033b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b6:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8033b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033bc:	eb 3b                	jmp    8033f9 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8033be:	a1 40 51 80 00       	mov    0x805140,%eax
  8033c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033ca:	74 07                	je     8033d3 <alloc_block_NF+0x5a5>
  8033cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033cf:	8b 00                	mov    (%eax),%eax
  8033d1:	eb 05                	jmp    8033d8 <alloc_block_NF+0x5aa>
  8033d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8033d8:	a3 40 51 80 00       	mov    %eax,0x805140
  8033dd:	a1 40 51 80 00       	mov    0x805140,%eax
  8033e2:	85 c0                	test   %eax,%eax
  8033e4:	0f 85 2e fe ff ff    	jne    803218 <alloc_block_NF+0x3ea>
  8033ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033ee:	0f 85 24 fe ff ff    	jne    803218 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  8033f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033f9:	c9                   	leave  
  8033fa:	c3                   	ret    

008033fb <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8033fb:	55                   	push   %ebp
  8033fc:	89 e5                	mov    %esp,%ebp
  8033fe:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  803401:	a1 38 51 80 00       	mov    0x805138,%eax
  803406:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  803409:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80340e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  803411:	a1 38 51 80 00       	mov    0x805138,%eax
  803416:	85 c0                	test   %eax,%eax
  803418:	74 14                	je     80342e <insert_sorted_with_merge_freeList+0x33>
  80341a:	8b 45 08             	mov    0x8(%ebp),%eax
  80341d:	8b 50 08             	mov    0x8(%eax),%edx
  803420:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803423:	8b 40 08             	mov    0x8(%eax),%eax
  803426:	39 c2                	cmp    %eax,%edx
  803428:	0f 87 9b 01 00 00    	ja     8035c9 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  80342e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803432:	75 17                	jne    80344b <insert_sorted_with_merge_freeList+0x50>
  803434:	83 ec 04             	sub    $0x4,%esp
  803437:	68 88 46 80 00       	push   $0x804688
  80343c:	68 38 01 00 00       	push   $0x138
  803441:	68 ab 46 80 00       	push   $0x8046ab
  803446:	e8 db d2 ff ff       	call   800726 <_panic>
  80344b:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803451:	8b 45 08             	mov    0x8(%ebp),%eax
  803454:	89 10                	mov    %edx,(%eax)
  803456:	8b 45 08             	mov    0x8(%ebp),%eax
  803459:	8b 00                	mov    (%eax),%eax
  80345b:	85 c0                	test   %eax,%eax
  80345d:	74 0d                	je     80346c <insert_sorted_with_merge_freeList+0x71>
  80345f:	a1 38 51 80 00       	mov    0x805138,%eax
  803464:	8b 55 08             	mov    0x8(%ebp),%edx
  803467:	89 50 04             	mov    %edx,0x4(%eax)
  80346a:	eb 08                	jmp    803474 <insert_sorted_with_merge_freeList+0x79>
  80346c:	8b 45 08             	mov    0x8(%ebp),%eax
  80346f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803474:	8b 45 08             	mov    0x8(%ebp),%eax
  803477:	a3 38 51 80 00       	mov    %eax,0x805138
  80347c:	8b 45 08             	mov    0x8(%ebp),%eax
  80347f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803486:	a1 44 51 80 00       	mov    0x805144,%eax
  80348b:	40                   	inc    %eax
  80348c:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803491:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803495:	0f 84 a8 06 00 00    	je     803b43 <insert_sorted_with_merge_freeList+0x748>
  80349b:	8b 45 08             	mov    0x8(%ebp),%eax
  80349e:	8b 50 08             	mov    0x8(%eax),%edx
  8034a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8034a7:	01 c2                	add    %eax,%edx
  8034a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034ac:	8b 40 08             	mov    0x8(%eax),%eax
  8034af:	39 c2                	cmp    %eax,%edx
  8034b1:	0f 85 8c 06 00 00    	jne    803b43 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  8034b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ba:	8b 50 0c             	mov    0xc(%eax),%edx
  8034bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8034c3:	01 c2                	add    %eax,%edx
  8034c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c8:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  8034cb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8034cf:	75 17                	jne    8034e8 <insert_sorted_with_merge_freeList+0xed>
  8034d1:	83 ec 04             	sub    $0x4,%esp
  8034d4:	68 54 47 80 00       	push   $0x804754
  8034d9:	68 3c 01 00 00       	push   $0x13c
  8034de:	68 ab 46 80 00       	push   $0x8046ab
  8034e3:	e8 3e d2 ff ff       	call   800726 <_panic>
  8034e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034eb:	8b 00                	mov    (%eax),%eax
  8034ed:	85 c0                	test   %eax,%eax
  8034ef:	74 10                	je     803501 <insert_sorted_with_merge_freeList+0x106>
  8034f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034f4:	8b 00                	mov    (%eax),%eax
  8034f6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034f9:	8b 52 04             	mov    0x4(%edx),%edx
  8034fc:	89 50 04             	mov    %edx,0x4(%eax)
  8034ff:	eb 0b                	jmp    80350c <insert_sorted_with_merge_freeList+0x111>
  803501:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803504:	8b 40 04             	mov    0x4(%eax),%eax
  803507:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80350c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80350f:	8b 40 04             	mov    0x4(%eax),%eax
  803512:	85 c0                	test   %eax,%eax
  803514:	74 0f                	je     803525 <insert_sorted_with_merge_freeList+0x12a>
  803516:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803519:	8b 40 04             	mov    0x4(%eax),%eax
  80351c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80351f:	8b 12                	mov    (%edx),%edx
  803521:	89 10                	mov    %edx,(%eax)
  803523:	eb 0a                	jmp    80352f <insert_sorted_with_merge_freeList+0x134>
  803525:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803528:	8b 00                	mov    (%eax),%eax
  80352a:	a3 38 51 80 00       	mov    %eax,0x805138
  80352f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803532:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803538:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80353b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803542:	a1 44 51 80 00       	mov    0x805144,%eax
  803547:	48                   	dec    %eax
  803548:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  80354d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803550:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803557:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80355a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803561:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803565:	75 17                	jne    80357e <insert_sorted_with_merge_freeList+0x183>
  803567:	83 ec 04             	sub    $0x4,%esp
  80356a:	68 88 46 80 00       	push   $0x804688
  80356f:	68 3f 01 00 00       	push   $0x13f
  803574:	68 ab 46 80 00       	push   $0x8046ab
  803579:	e8 a8 d1 ff ff       	call   800726 <_panic>
  80357e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803584:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803587:	89 10                	mov    %edx,(%eax)
  803589:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80358c:	8b 00                	mov    (%eax),%eax
  80358e:	85 c0                	test   %eax,%eax
  803590:	74 0d                	je     80359f <insert_sorted_with_merge_freeList+0x1a4>
  803592:	a1 48 51 80 00       	mov    0x805148,%eax
  803597:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80359a:	89 50 04             	mov    %edx,0x4(%eax)
  80359d:	eb 08                	jmp    8035a7 <insert_sorted_with_merge_freeList+0x1ac>
  80359f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035a2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035aa:	a3 48 51 80 00       	mov    %eax,0x805148
  8035af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035b2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035b9:	a1 54 51 80 00       	mov    0x805154,%eax
  8035be:	40                   	inc    %eax
  8035bf:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8035c4:	e9 7a 05 00 00       	jmp    803b43 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  8035c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8035cc:	8b 50 08             	mov    0x8(%eax),%edx
  8035cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035d2:	8b 40 08             	mov    0x8(%eax),%eax
  8035d5:	39 c2                	cmp    %eax,%edx
  8035d7:	0f 82 14 01 00 00    	jb     8036f1 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8035dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035e0:	8b 50 08             	mov    0x8(%eax),%edx
  8035e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035e6:	8b 40 0c             	mov    0xc(%eax),%eax
  8035e9:	01 c2                	add    %eax,%edx
  8035eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ee:	8b 40 08             	mov    0x8(%eax),%eax
  8035f1:	39 c2                	cmp    %eax,%edx
  8035f3:	0f 85 90 00 00 00    	jne    803689 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8035f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035fc:	8b 50 0c             	mov    0xc(%eax),%edx
  8035ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803602:	8b 40 0c             	mov    0xc(%eax),%eax
  803605:	01 c2                	add    %eax,%edx
  803607:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80360a:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  80360d:	8b 45 08             	mov    0x8(%ebp),%eax
  803610:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803617:	8b 45 08             	mov    0x8(%ebp),%eax
  80361a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803621:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803625:	75 17                	jne    80363e <insert_sorted_with_merge_freeList+0x243>
  803627:	83 ec 04             	sub    $0x4,%esp
  80362a:	68 88 46 80 00       	push   $0x804688
  80362f:	68 49 01 00 00       	push   $0x149
  803634:	68 ab 46 80 00       	push   $0x8046ab
  803639:	e8 e8 d0 ff ff       	call   800726 <_panic>
  80363e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803644:	8b 45 08             	mov    0x8(%ebp),%eax
  803647:	89 10                	mov    %edx,(%eax)
  803649:	8b 45 08             	mov    0x8(%ebp),%eax
  80364c:	8b 00                	mov    (%eax),%eax
  80364e:	85 c0                	test   %eax,%eax
  803650:	74 0d                	je     80365f <insert_sorted_with_merge_freeList+0x264>
  803652:	a1 48 51 80 00       	mov    0x805148,%eax
  803657:	8b 55 08             	mov    0x8(%ebp),%edx
  80365a:	89 50 04             	mov    %edx,0x4(%eax)
  80365d:	eb 08                	jmp    803667 <insert_sorted_with_merge_freeList+0x26c>
  80365f:	8b 45 08             	mov    0x8(%ebp),%eax
  803662:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803667:	8b 45 08             	mov    0x8(%ebp),%eax
  80366a:	a3 48 51 80 00       	mov    %eax,0x805148
  80366f:	8b 45 08             	mov    0x8(%ebp),%eax
  803672:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803679:	a1 54 51 80 00       	mov    0x805154,%eax
  80367e:	40                   	inc    %eax
  80367f:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803684:	e9 bb 04 00 00       	jmp    803b44 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803689:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80368d:	75 17                	jne    8036a6 <insert_sorted_with_merge_freeList+0x2ab>
  80368f:	83 ec 04             	sub    $0x4,%esp
  803692:	68 fc 46 80 00       	push   $0x8046fc
  803697:	68 4c 01 00 00       	push   $0x14c
  80369c:	68 ab 46 80 00       	push   $0x8046ab
  8036a1:	e8 80 d0 ff ff       	call   800726 <_panic>
  8036a6:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8036ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8036af:	89 50 04             	mov    %edx,0x4(%eax)
  8036b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b5:	8b 40 04             	mov    0x4(%eax),%eax
  8036b8:	85 c0                	test   %eax,%eax
  8036ba:	74 0c                	je     8036c8 <insert_sorted_with_merge_freeList+0x2cd>
  8036bc:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8036c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8036c4:	89 10                	mov    %edx,(%eax)
  8036c6:	eb 08                	jmp    8036d0 <insert_sorted_with_merge_freeList+0x2d5>
  8036c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036cb:	a3 38 51 80 00       	mov    %eax,0x805138
  8036d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8036d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036e1:	a1 44 51 80 00       	mov    0x805144,%eax
  8036e6:	40                   	inc    %eax
  8036e7:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8036ec:	e9 53 04 00 00       	jmp    803b44 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8036f1:	a1 38 51 80 00       	mov    0x805138,%eax
  8036f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036f9:	e9 15 04 00 00       	jmp    803b13 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8036fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803701:	8b 00                	mov    (%eax),%eax
  803703:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803706:	8b 45 08             	mov    0x8(%ebp),%eax
  803709:	8b 50 08             	mov    0x8(%eax),%edx
  80370c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80370f:	8b 40 08             	mov    0x8(%eax),%eax
  803712:	39 c2                	cmp    %eax,%edx
  803714:	0f 86 f1 03 00 00    	jbe    803b0b <insert_sorted_with_merge_freeList+0x710>
  80371a:	8b 45 08             	mov    0x8(%ebp),%eax
  80371d:	8b 50 08             	mov    0x8(%eax),%edx
  803720:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803723:	8b 40 08             	mov    0x8(%eax),%eax
  803726:	39 c2                	cmp    %eax,%edx
  803728:	0f 83 dd 03 00 00    	jae    803b0b <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  80372e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803731:	8b 50 08             	mov    0x8(%eax),%edx
  803734:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803737:	8b 40 0c             	mov    0xc(%eax),%eax
  80373a:	01 c2                	add    %eax,%edx
  80373c:	8b 45 08             	mov    0x8(%ebp),%eax
  80373f:	8b 40 08             	mov    0x8(%eax),%eax
  803742:	39 c2                	cmp    %eax,%edx
  803744:	0f 85 b9 01 00 00    	jne    803903 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80374a:	8b 45 08             	mov    0x8(%ebp),%eax
  80374d:	8b 50 08             	mov    0x8(%eax),%edx
  803750:	8b 45 08             	mov    0x8(%ebp),%eax
  803753:	8b 40 0c             	mov    0xc(%eax),%eax
  803756:	01 c2                	add    %eax,%edx
  803758:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80375b:	8b 40 08             	mov    0x8(%eax),%eax
  80375e:	39 c2                	cmp    %eax,%edx
  803760:	0f 85 0d 01 00 00    	jne    803873 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803766:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803769:	8b 50 0c             	mov    0xc(%eax),%edx
  80376c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80376f:	8b 40 0c             	mov    0xc(%eax),%eax
  803772:	01 c2                	add    %eax,%edx
  803774:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803777:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80377a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80377e:	75 17                	jne    803797 <insert_sorted_with_merge_freeList+0x39c>
  803780:	83 ec 04             	sub    $0x4,%esp
  803783:	68 54 47 80 00       	push   $0x804754
  803788:	68 5c 01 00 00       	push   $0x15c
  80378d:	68 ab 46 80 00       	push   $0x8046ab
  803792:	e8 8f cf ff ff       	call   800726 <_panic>
  803797:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80379a:	8b 00                	mov    (%eax),%eax
  80379c:	85 c0                	test   %eax,%eax
  80379e:	74 10                	je     8037b0 <insert_sorted_with_merge_freeList+0x3b5>
  8037a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037a3:	8b 00                	mov    (%eax),%eax
  8037a5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037a8:	8b 52 04             	mov    0x4(%edx),%edx
  8037ab:	89 50 04             	mov    %edx,0x4(%eax)
  8037ae:	eb 0b                	jmp    8037bb <insert_sorted_with_merge_freeList+0x3c0>
  8037b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037b3:	8b 40 04             	mov    0x4(%eax),%eax
  8037b6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8037bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037be:	8b 40 04             	mov    0x4(%eax),%eax
  8037c1:	85 c0                	test   %eax,%eax
  8037c3:	74 0f                	je     8037d4 <insert_sorted_with_merge_freeList+0x3d9>
  8037c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037c8:	8b 40 04             	mov    0x4(%eax),%eax
  8037cb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037ce:	8b 12                	mov    (%edx),%edx
  8037d0:	89 10                	mov    %edx,(%eax)
  8037d2:	eb 0a                	jmp    8037de <insert_sorted_with_merge_freeList+0x3e3>
  8037d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037d7:	8b 00                	mov    (%eax),%eax
  8037d9:	a3 38 51 80 00       	mov    %eax,0x805138
  8037de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037ea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037f1:	a1 44 51 80 00       	mov    0x805144,%eax
  8037f6:	48                   	dec    %eax
  8037f7:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8037fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037ff:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803806:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803809:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803810:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803814:	75 17                	jne    80382d <insert_sorted_with_merge_freeList+0x432>
  803816:	83 ec 04             	sub    $0x4,%esp
  803819:	68 88 46 80 00       	push   $0x804688
  80381e:	68 5f 01 00 00       	push   $0x15f
  803823:	68 ab 46 80 00       	push   $0x8046ab
  803828:	e8 f9 ce ff ff       	call   800726 <_panic>
  80382d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803833:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803836:	89 10                	mov    %edx,(%eax)
  803838:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80383b:	8b 00                	mov    (%eax),%eax
  80383d:	85 c0                	test   %eax,%eax
  80383f:	74 0d                	je     80384e <insert_sorted_with_merge_freeList+0x453>
  803841:	a1 48 51 80 00       	mov    0x805148,%eax
  803846:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803849:	89 50 04             	mov    %edx,0x4(%eax)
  80384c:	eb 08                	jmp    803856 <insert_sorted_with_merge_freeList+0x45b>
  80384e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803851:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803856:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803859:	a3 48 51 80 00       	mov    %eax,0x805148
  80385e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803861:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803868:	a1 54 51 80 00       	mov    0x805154,%eax
  80386d:	40                   	inc    %eax
  80386e:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803873:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803876:	8b 50 0c             	mov    0xc(%eax),%edx
  803879:	8b 45 08             	mov    0x8(%ebp),%eax
  80387c:	8b 40 0c             	mov    0xc(%eax),%eax
  80387f:	01 c2                	add    %eax,%edx
  803881:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803884:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803887:	8b 45 08             	mov    0x8(%ebp),%eax
  80388a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803891:	8b 45 08             	mov    0x8(%ebp),%eax
  803894:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80389b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80389f:	75 17                	jne    8038b8 <insert_sorted_with_merge_freeList+0x4bd>
  8038a1:	83 ec 04             	sub    $0x4,%esp
  8038a4:	68 88 46 80 00       	push   $0x804688
  8038a9:	68 64 01 00 00       	push   $0x164
  8038ae:	68 ab 46 80 00       	push   $0x8046ab
  8038b3:	e8 6e ce ff ff       	call   800726 <_panic>
  8038b8:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8038be:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c1:	89 10                	mov    %edx,(%eax)
  8038c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c6:	8b 00                	mov    (%eax),%eax
  8038c8:	85 c0                	test   %eax,%eax
  8038ca:	74 0d                	je     8038d9 <insert_sorted_with_merge_freeList+0x4de>
  8038cc:	a1 48 51 80 00       	mov    0x805148,%eax
  8038d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8038d4:	89 50 04             	mov    %edx,0x4(%eax)
  8038d7:	eb 08                	jmp    8038e1 <insert_sorted_with_merge_freeList+0x4e6>
  8038d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8038dc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8038e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e4:	a3 48 51 80 00       	mov    %eax,0x805148
  8038e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038f3:	a1 54 51 80 00       	mov    0x805154,%eax
  8038f8:	40                   	inc    %eax
  8038f9:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8038fe:	e9 41 02 00 00       	jmp    803b44 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803903:	8b 45 08             	mov    0x8(%ebp),%eax
  803906:	8b 50 08             	mov    0x8(%eax),%edx
  803909:	8b 45 08             	mov    0x8(%ebp),%eax
  80390c:	8b 40 0c             	mov    0xc(%eax),%eax
  80390f:	01 c2                	add    %eax,%edx
  803911:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803914:	8b 40 08             	mov    0x8(%eax),%eax
  803917:	39 c2                	cmp    %eax,%edx
  803919:	0f 85 7c 01 00 00    	jne    803a9b <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80391f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803923:	74 06                	je     80392b <insert_sorted_with_merge_freeList+0x530>
  803925:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803929:	75 17                	jne    803942 <insert_sorted_with_merge_freeList+0x547>
  80392b:	83 ec 04             	sub    $0x4,%esp
  80392e:	68 c4 46 80 00       	push   $0x8046c4
  803933:	68 69 01 00 00       	push   $0x169
  803938:	68 ab 46 80 00       	push   $0x8046ab
  80393d:	e8 e4 cd ff ff       	call   800726 <_panic>
  803942:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803945:	8b 50 04             	mov    0x4(%eax),%edx
  803948:	8b 45 08             	mov    0x8(%ebp),%eax
  80394b:	89 50 04             	mov    %edx,0x4(%eax)
  80394e:	8b 45 08             	mov    0x8(%ebp),%eax
  803951:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803954:	89 10                	mov    %edx,(%eax)
  803956:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803959:	8b 40 04             	mov    0x4(%eax),%eax
  80395c:	85 c0                	test   %eax,%eax
  80395e:	74 0d                	je     80396d <insert_sorted_with_merge_freeList+0x572>
  803960:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803963:	8b 40 04             	mov    0x4(%eax),%eax
  803966:	8b 55 08             	mov    0x8(%ebp),%edx
  803969:	89 10                	mov    %edx,(%eax)
  80396b:	eb 08                	jmp    803975 <insert_sorted_with_merge_freeList+0x57a>
  80396d:	8b 45 08             	mov    0x8(%ebp),%eax
  803970:	a3 38 51 80 00       	mov    %eax,0x805138
  803975:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803978:	8b 55 08             	mov    0x8(%ebp),%edx
  80397b:	89 50 04             	mov    %edx,0x4(%eax)
  80397e:	a1 44 51 80 00       	mov    0x805144,%eax
  803983:	40                   	inc    %eax
  803984:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803989:	8b 45 08             	mov    0x8(%ebp),%eax
  80398c:	8b 50 0c             	mov    0xc(%eax),%edx
  80398f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803992:	8b 40 0c             	mov    0xc(%eax),%eax
  803995:	01 c2                	add    %eax,%edx
  803997:	8b 45 08             	mov    0x8(%ebp),%eax
  80399a:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80399d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8039a1:	75 17                	jne    8039ba <insert_sorted_with_merge_freeList+0x5bf>
  8039a3:	83 ec 04             	sub    $0x4,%esp
  8039a6:	68 54 47 80 00       	push   $0x804754
  8039ab:	68 6b 01 00 00       	push   $0x16b
  8039b0:	68 ab 46 80 00       	push   $0x8046ab
  8039b5:	e8 6c cd ff ff       	call   800726 <_panic>
  8039ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039bd:	8b 00                	mov    (%eax),%eax
  8039bf:	85 c0                	test   %eax,%eax
  8039c1:	74 10                	je     8039d3 <insert_sorted_with_merge_freeList+0x5d8>
  8039c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039c6:	8b 00                	mov    (%eax),%eax
  8039c8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039cb:	8b 52 04             	mov    0x4(%edx),%edx
  8039ce:	89 50 04             	mov    %edx,0x4(%eax)
  8039d1:	eb 0b                	jmp    8039de <insert_sorted_with_merge_freeList+0x5e3>
  8039d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039d6:	8b 40 04             	mov    0x4(%eax),%eax
  8039d9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8039de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039e1:	8b 40 04             	mov    0x4(%eax),%eax
  8039e4:	85 c0                	test   %eax,%eax
  8039e6:	74 0f                	je     8039f7 <insert_sorted_with_merge_freeList+0x5fc>
  8039e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039eb:	8b 40 04             	mov    0x4(%eax),%eax
  8039ee:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039f1:	8b 12                	mov    (%edx),%edx
  8039f3:	89 10                	mov    %edx,(%eax)
  8039f5:	eb 0a                	jmp    803a01 <insert_sorted_with_merge_freeList+0x606>
  8039f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039fa:	8b 00                	mov    (%eax),%eax
  8039fc:	a3 38 51 80 00       	mov    %eax,0x805138
  803a01:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a04:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a0a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a0d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a14:	a1 44 51 80 00       	mov    0x805144,%eax
  803a19:	48                   	dec    %eax
  803a1a:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803a1f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a22:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803a29:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a2c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803a33:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803a37:	75 17                	jne    803a50 <insert_sorted_with_merge_freeList+0x655>
  803a39:	83 ec 04             	sub    $0x4,%esp
  803a3c:	68 88 46 80 00       	push   $0x804688
  803a41:	68 6e 01 00 00       	push   $0x16e
  803a46:	68 ab 46 80 00       	push   $0x8046ab
  803a4b:	e8 d6 cc ff ff       	call   800726 <_panic>
  803a50:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a56:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a59:	89 10                	mov    %edx,(%eax)
  803a5b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a5e:	8b 00                	mov    (%eax),%eax
  803a60:	85 c0                	test   %eax,%eax
  803a62:	74 0d                	je     803a71 <insert_sorted_with_merge_freeList+0x676>
  803a64:	a1 48 51 80 00       	mov    0x805148,%eax
  803a69:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a6c:	89 50 04             	mov    %edx,0x4(%eax)
  803a6f:	eb 08                	jmp    803a79 <insert_sorted_with_merge_freeList+0x67e>
  803a71:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a74:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803a79:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a7c:	a3 48 51 80 00       	mov    %eax,0x805148
  803a81:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a84:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a8b:	a1 54 51 80 00       	mov    0x805154,%eax
  803a90:	40                   	inc    %eax
  803a91:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803a96:	e9 a9 00 00 00       	jmp    803b44 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803a9b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a9f:	74 06                	je     803aa7 <insert_sorted_with_merge_freeList+0x6ac>
  803aa1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803aa5:	75 17                	jne    803abe <insert_sorted_with_merge_freeList+0x6c3>
  803aa7:	83 ec 04             	sub    $0x4,%esp
  803aaa:	68 20 47 80 00       	push   $0x804720
  803aaf:	68 73 01 00 00       	push   $0x173
  803ab4:	68 ab 46 80 00       	push   $0x8046ab
  803ab9:	e8 68 cc ff ff       	call   800726 <_panic>
  803abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ac1:	8b 10                	mov    (%eax),%edx
  803ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  803ac6:	89 10                	mov    %edx,(%eax)
  803ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  803acb:	8b 00                	mov    (%eax),%eax
  803acd:	85 c0                	test   %eax,%eax
  803acf:	74 0b                	je     803adc <insert_sorted_with_merge_freeList+0x6e1>
  803ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ad4:	8b 00                	mov    (%eax),%eax
  803ad6:	8b 55 08             	mov    0x8(%ebp),%edx
  803ad9:	89 50 04             	mov    %edx,0x4(%eax)
  803adc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803adf:	8b 55 08             	mov    0x8(%ebp),%edx
  803ae2:	89 10                	mov    %edx,(%eax)
  803ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  803ae7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803aea:	89 50 04             	mov    %edx,0x4(%eax)
  803aed:	8b 45 08             	mov    0x8(%ebp),%eax
  803af0:	8b 00                	mov    (%eax),%eax
  803af2:	85 c0                	test   %eax,%eax
  803af4:	75 08                	jne    803afe <insert_sorted_with_merge_freeList+0x703>
  803af6:	8b 45 08             	mov    0x8(%ebp),%eax
  803af9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803afe:	a1 44 51 80 00       	mov    0x805144,%eax
  803b03:	40                   	inc    %eax
  803b04:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803b09:	eb 39                	jmp    803b44 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803b0b:	a1 40 51 80 00       	mov    0x805140,%eax
  803b10:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803b13:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b17:	74 07                	je     803b20 <insert_sorted_with_merge_freeList+0x725>
  803b19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b1c:	8b 00                	mov    (%eax),%eax
  803b1e:	eb 05                	jmp    803b25 <insert_sorted_with_merge_freeList+0x72a>
  803b20:	b8 00 00 00 00       	mov    $0x0,%eax
  803b25:	a3 40 51 80 00       	mov    %eax,0x805140
  803b2a:	a1 40 51 80 00       	mov    0x805140,%eax
  803b2f:	85 c0                	test   %eax,%eax
  803b31:	0f 85 c7 fb ff ff    	jne    8036fe <insert_sorted_with_merge_freeList+0x303>
  803b37:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b3b:	0f 85 bd fb ff ff    	jne    8036fe <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803b41:	eb 01                	jmp    803b44 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803b43:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803b44:	90                   	nop
  803b45:	c9                   	leave  
  803b46:	c3                   	ret    
  803b47:	90                   	nop

00803b48 <__udivdi3>:
  803b48:	55                   	push   %ebp
  803b49:	57                   	push   %edi
  803b4a:	56                   	push   %esi
  803b4b:	53                   	push   %ebx
  803b4c:	83 ec 1c             	sub    $0x1c,%esp
  803b4f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803b53:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b57:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b5b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b5f:	89 ca                	mov    %ecx,%edx
  803b61:	89 f8                	mov    %edi,%eax
  803b63:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803b67:	85 f6                	test   %esi,%esi
  803b69:	75 2d                	jne    803b98 <__udivdi3+0x50>
  803b6b:	39 cf                	cmp    %ecx,%edi
  803b6d:	77 65                	ja     803bd4 <__udivdi3+0x8c>
  803b6f:	89 fd                	mov    %edi,%ebp
  803b71:	85 ff                	test   %edi,%edi
  803b73:	75 0b                	jne    803b80 <__udivdi3+0x38>
  803b75:	b8 01 00 00 00       	mov    $0x1,%eax
  803b7a:	31 d2                	xor    %edx,%edx
  803b7c:	f7 f7                	div    %edi
  803b7e:	89 c5                	mov    %eax,%ebp
  803b80:	31 d2                	xor    %edx,%edx
  803b82:	89 c8                	mov    %ecx,%eax
  803b84:	f7 f5                	div    %ebp
  803b86:	89 c1                	mov    %eax,%ecx
  803b88:	89 d8                	mov    %ebx,%eax
  803b8a:	f7 f5                	div    %ebp
  803b8c:	89 cf                	mov    %ecx,%edi
  803b8e:	89 fa                	mov    %edi,%edx
  803b90:	83 c4 1c             	add    $0x1c,%esp
  803b93:	5b                   	pop    %ebx
  803b94:	5e                   	pop    %esi
  803b95:	5f                   	pop    %edi
  803b96:	5d                   	pop    %ebp
  803b97:	c3                   	ret    
  803b98:	39 ce                	cmp    %ecx,%esi
  803b9a:	77 28                	ja     803bc4 <__udivdi3+0x7c>
  803b9c:	0f bd fe             	bsr    %esi,%edi
  803b9f:	83 f7 1f             	xor    $0x1f,%edi
  803ba2:	75 40                	jne    803be4 <__udivdi3+0x9c>
  803ba4:	39 ce                	cmp    %ecx,%esi
  803ba6:	72 0a                	jb     803bb2 <__udivdi3+0x6a>
  803ba8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803bac:	0f 87 9e 00 00 00    	ja     803c50 <__udivdi3+0x108>
  803bb2:	b8 01 00 00 00       	mov    $0x1,%eax
  803bb7:	89 fa                	mov    %edi,%edx
  803bb9:	83 c4 1c             	add    $0x1c,%esp
  803bbc:	5b                   	pop    %ebx
  803bbd:	5e                   	pop    %esi
  803bbe:	5f                   	pop    %edi
  803bbf:	5d                   	pop    %ebp
  803bc0:	c3                   	ret    
  803bc1:	8d 76 00             	lea    0x0(%esi),%esi
  803bc4:	31 ff                	xor    %edi,%edi
  803bc6:	31 c0                	xor    %eax,%eax
  803bc8:	89 fa                	mov    %edi,%edx
  803bca:	83 c4 1c             	add    $0x1c,%esp
  803bcd:	5b                   	pop    %ebx
  803bce:	5e                   	pop    %esi
  803bcf:	5f                   	pop    %edi
  803bd0:	5d                   	pop    %ebp
  803bd1:	c3                   	ret    
  803bd2:	66 90                	xchg   %ax,%ax
  803bd4:	89 d8                	mov    %ebx,%eax
  803bd6:	f7 f7                	div    %edi
  803bd8:	31 ff                	xor    %edi,%edi
  803bda:	89 fa                	mov    %edi,%edx
  803bdc:	83 c4 1c             	add    $0x1c,%esp
  803bdf:	5b                   	pop    %ebx
  803be0:	5e                   	pop    %esi
  803be1:	5f                   	pop    %edi
  803be2:	5d                   	pop    %ebp
  803be3:	c3                   	ret    
  803be4:	bd 20 00 00 00       	mov    $0x20,%ebp
  803be9:	89 eb                	mov    %ebp,%ebx
  803beb:	29 fb                	sub    %edi,%ebx
  803bed:	89 f9                	mov    %edi,%ecx
  803bef:	d3 e6                	shl    %cl,%esi
  803bf1:	89 c5                	mov    %eax,%ebp
  803bf3:	88 d9                	mov    %bl,%cl
  803bf5:	d3 ed                	shr    %cl,%ebp
  803bf7:	89 e9                	mov    %ebp,%ecx
  803bf9:	09 f1                	or     %esi,%ecx
  803bfb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803bff:	89 f9                	mov    %edi,%ecx
  803c01:	d3 e0                	shl    %cl,%eax
  803c03:	89 c5                	mov    %eax,%ebp
  803c05:	89 d6                	mov    %edx,%esi
  803c07:	88 d9                	mov    %bl,%cl
  803c09:	d3 ee                	shr    %cl,%esi
  803c0b:	89 f9                	mov    %edi,%ecx
  803c0d:	d3 e2                	shl    %cl,%edx
  803c0f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c13:	88 d9                	mov    %bl,%cl
  803c15:	d3 e8                	shr    %cl,%eax
  803c17:	09 c2                	or     %eax,%edx
  803c19:	89 d0                	mov    %edx,%eax
  803c1b:	89 f2                	mov    %esi,%edx
  803c1d:	f7 74 24 0c          	divl   0xc(%esp)
  803c21:	89 d6                	mov    %edx,%esi
  803c23:	89 c3                	mov    %eax,%ebx
  803c25:	f7 e5                	mul    %ebp
  803c27:	39 d6                	cmp    %edx,%esi
  803c29:	72 19                	jb     803c44 <__udivdi3+0xfc>
  803c2b:	74 0b                	je     803c38 <__udivdi3+0xf0>
  803c2d:	89 d8                	mov    %ebx,%eax
  803c2f:	31 ff                	xor    %edi,%edi
  803c31:	e9 58 ff ff ff       	jmp    803b8e <__udivdi3+0x46>
  803c36:	66 90                	xchg   %ax,%ax
  803c38:	8b 54 24 08          	mov    0x8(%esp),%edx
  803c3c:	89 f9                	mov    %edi,%ecx
  803c3e:	d3 e2                	shl    %cl,%edx
  803c40:	39 c2                	cmp    %eax,%edx
  803c42:	73 e9                	jae    803c2d <__udivdi3+0xe5>
  803c44:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803c47:	31 ff                	xor    %edi,%edi
  803c49:	e9 40 ff ff ff       	jmp    803b8e <__udivdi3+0x46>
  803c4e:	66 90                	xchg   %ax,%ax
  803c50:	31 c0                	xor    %eax,%eax
  803c52:	e9 37 ff ff ff       	jmp    803b8e <__udivdi3+0x46>
  803c57:	90                   	nop

00803c58 <__umoddi3>:
  803c58:	55                   	push   %ebp
  803c59:	57                   	push   %edi
  803c5a:	56                   	push   %esi
  803c5b:	53                   	push   %ebx
  803c5c:	83 ec 1c             	sub    $0x1c,%esp
  803c5f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803c63:	8b 74 24 34          	mov    0x34(%esp),%esi
  803c67:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c6b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c6f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c73:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c77:	89 f3                	mov    %esi,%ebx
  803c79:	89 fa                	mov    %edi,%edx
  803c7b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c7f:	89 34 24             	mov    %esi,(%esp)
  803c82:	85 c0                	test   %eax,%eax
  803c84:	75 1a                	jne    803ca0 <__umoddi3+0x48>
  803c86:	39 f7                	cmp    %esi,%edi
  803c88:	0f 86 a2 00 00 00    	jbe    803d30 <__umoddi3+0xd8>
  803c8e:	89 c8                	mov    %ecx,%eax
  803c90:	89 f2                	mov    %esi,%edx
  803c92:	f7 f7                	div    %edi
  803c94:	89 d0                	mov    %edx,%eax
  803c96:	31 d2                	xor    %edx,%edx
  803c98:	83 c4 1c             	add    $0x1c,%esp
  803c9b:	5b                   	pop    %ebx
  803c9c:	5e                   	pop    %esi
  803c9d:	5f                   	pop    %edi
  803c9e:	5d                   	pop    %ebp
  803c9f:	c3                   	ret    
  803ca0:	39 f0                	cmp    %esi,%eax
  803ca2:	0f 87 ac 00 00 00    	ja     803d54 <__umoddi3+0xfc>
  803ca8:	0f bd e8             	bsr    %eax,%ebp
  803cab:	83 f5 1f             	xor    $0x1f,%ebp
  803cae:	0f 84 ac 00 00 00    	je     803d60 <__umoddi3+0x108>
  803cb4:	bf 20 00 00 00       	mov    $0x20,%edi
  803cb9:	29 ef                	sub    %ebp,%edi
  803cbb:	89 fe                	mov    %edi,%esi
  803cbd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803cc1:	89 e9                	mov    %ebp,%ecx
  803cc3:	d3 e0                	shl    %cl,%eax
  803cc5:	89 d7                	mov    %edx,%edi
  803cc7:	89 f1                	mov    %esi,%ecx
  803cc9:	d3 ef                	shr    %cl,%edi
  803ccb:	09 c7                	or     %eax,%edi
  803ccd:	89 e9                	mov    %ebp,%ecx
  803ccf:	d3 e2                	shl    %cl,%edx
  803cd1:	89 14 24             	mov    %edx,(%esp)
  803cd4:	89 d8                	mov    %ebx,%eax
  803cd6:	d3 e0                	shl    %cl,%eax
  803cd8:	89 c2                	mov    %eax,%edx
  803cda:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cde:	d3 e0                	shl    %cl,%eax
  803ce0:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ce4:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ce8:	89 f1                	mov    %esi,%ecx
  803cea:	d3 e8                	shr    %cl,%eax
  803cec:	09 d0                	or     %edx,%eax
  803cee:	d3 eb                	shr    %cl,%ebx
  803cf0:	89 da                	mov    %ebx,%edx
  803cf2:	f7 f7                	div    %edi
  803cf4:	89 d3                	mov    %edx,%ebx
  803cf6:	f7 24 24             	mull   (%esp)
  803cf9:	89 c6                	mov    %eax,%esi
  803cfb:	89 d1                	mov    %edx,%ecx
  803cfd:	39 d3                	cmp    %edx,%ebx
  803cff:	0f 82 87 00 00 00    	jb     803d8c <__umoddi3+0x134>
  803d05:	0f 84 91 00 00 00    	je     803d9c <__umoddi3+0x144>
  803d0b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803d0f:	29 f2                	sub    %esi,%edx
  803d11:	19 cb                	sbb    %ecx,%ebx
  803d13:	89 d8                	mov    %ebx,%eax
  803d15:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803d19:	d3 e0                	shl    %cl,%eax
  803d1b:	89 e9                	mov    %ebp,%ecx
  803d1d:	d3 ea                	shr    %cl,%edx
  803d1f:	09 d0                	or     %edx,%eax
  803d21:	89 e9                	mov    %ebp,%ecx
  803d23:	d3 eb                	shr    %cl,%ebx
  803d25:	89 da                	mov    %ebx,%edx
  803d27:	83 c4 1c             	add    $0x1c,%esp
  803d2a:	5b                   	pop    %ebx
  803d2b:	5e                   	pop    %esi
  803d2c:	5f                   	pop    %edi
  803d2d:	5d                   	pop    %ebp
  803d2e:	c3                   	ret    
  803d2f:	90                   	nop
  803d30:	89 fd                	mov    %edi,%ebp
  803d32:	85 ff                	test   %edi,%edi
  803d34:	75 0b                	jne    803d41 <__umoddi3+0xe9>
  803d36:	b8 01 00 00 00       	mov    $0x1,%eax
  803d3b:	31 d2                	xor    %edx,%edx
  803d3d:	f7 f7                	div    %edi
  803d3f:	89 c5                	mov    %eax,%ebp
  803d41:	89 f0                	mov    %esi,%eax
  803d43:	31 d2                	xor    %edx,%edx
  803d45:	f7 f5                	div    %ebp
  803d47:	89 c8                	mov    %ecx,%eax
  803d49:	f7 f5                	div    %ebp
  803d4b:	89 d0                	mov    %edx,%eax
  803d4d:	e9 44 ff ff ff       	jmp    803c96 <__umoddi3+0x3e>
  803d52:	66 90                	xchg   %ax,%ax
  803d54:	89 c8                	mov    %ecx,%eax
  803d56:	89 f2                	mov    %esi,%edx
  803d58:	83 c4 1c             	add    $0x1c,%esp
  803d5b:	5b                   	pop    %ebx
  803d5c:	5e                   	pop    %esi
  803d5d:	5f                   	pop    %edi
  803d5e:	5d                   	pop    %ebp
  803d5f:	c3                   	ret    
  803d60:	3b 04 24             	cmp    (%esp),%eax
  803d63:	72 06                	jb     803d6b <__umoddi3+0x113>
  803d65:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803d69:	77 0f                	ja     803d7a <__umoddi3+0x122>
  803d6b:	89 f2                	mov    %esi,%edx
  803d6d:	29 f9                	sub    %edi,%ecx
  803d6f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d73:	89 14 24             	mov    %edx,(%esp)
  803d76:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d7a:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d7e:	8b 14 24             	mov    (%esp),%edx
  803d81:	83 c4 1c             	add    $0x1c,%esp
  803d84:	5b                   	pop    %ebx
  803d85:	5e                   	pop    %esi
  803d86:	5f                   	pop    %edi
  803d87:	5d                   	pop    %ebp
  803d88:	c3                   	ret    
  803d89:	8d 76 00             	lea    0x0(%esi),%esi
  803d8c:	2b 04 24             	sub    (%esp),%eax
  803d8f:	19 fa                	sbb    %edi,%edx
  803d91:	89 d1                	mov    %edx,%ecx
  803d93:	89 c6                	mov    %eax,%esi
  803d95:	e9 71 ff ff ff       	jmp    803d0b <__umoddi3+0xb3>
  803d9a:	66 90                	xchg   %ax,%ax
  803d9c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803da0:	72 ea                	jb     803d8c <__umoddi3+0x134>
  803da2:	89 d9                	mov    %ebx,%ecx
  803da4:	e9 62 ff ff ff       	jmp    803d0b <__umoddi3+0xb3>
