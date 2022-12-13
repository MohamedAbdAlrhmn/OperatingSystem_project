
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
  800049:	e8 ef 1d 00 00       	call   801e3d <sys_calculate_free_frames>
  80004e:	89 c3                	mov    %eax,%ebx
  800050:	e8 01 1e 00 00       	call   801e56 <sys_calculate_modified_frames>
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
  800067:	68 80 3c 80 00       	push   $0x803c80
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
  8000a5:	68 a0 3c 80 00       	push   $0x803ca0
  8000aa:	e8 2b 09 00 00       	call   8009da <cprintf>
  8000af:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000b2:	83 ec 0c             	sub    $0xc,%esp
  8000b5:	68 c3 3c 80 00       	push   $0x803cc3
  8000ba:	e8 1b 09 00 00       	call   8009da <cprintf>
  8000bf:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000c2:	83 ec 0c             	sub    $0xc,%esp
  8000c5:	68 d1 3c 80 00       	push   $0x803cd1
  8000ca:	e8 0b 09 00 00       	call   8009da <cprintf>
  8000cf:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  8000d2:	83 ec 0c             	sub    $0xc,%esp
  8000d5:	68 e0 3c 80 00       	push   $0x803ce0
  8000da:	e8 fb 08 00 00       	call   8009da <cprintf>
  8000df:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  8000e2:	83 ec 0c             	sub    $0xc,%esp
  8000e5:	68 f0 3c 80 00       	push   $0x803cf0
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
  8001b4:	68 fc 3c 80 00       	push   $0x803cfc
  8001b9:	6a 45                	push   $0x45
  8001bb:	68 1e 3d 80 00       	push   $0x803d1e
  8001c0:	e8 61 05 00 00       	call   800726 <_panic>
		else
		{ 
			cprintf("===============================================\n") ;
  8001c5:	83 ec 0c             	sub    $0xc,%esp
  8001c8:	68 38 3d 80 00       	push   $0x803d38
  8001cd:	e8 08 08 00 00       	call   8009da <cprintf>
  8001d2:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  8001d5:	83 ec 0c             	sub    $0xc,%esp
  8001d8:	68 6c 3d 80 00       	push   $0x803d6c
  8001dd:	e8 f8 07 00 00       	call   8009da <cprintf>
  8001e2:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  8001e5:	83 ec 0c             	sub    $0xc,%esp
  8001e8:	68 a0 3d 80 00       	push   $0x803da0
  8001ed:	e8 e8 07 00 00       	call   8009da <cprintf>
  8001f2:	83 c4 10             	add    $0x10,%esp
		}

		//		cprintf("Free Frames After Calculation = %d\n", sys_calculate_free_frames()) ;

		cprintf("Freeing the Heap...\n\n") ;
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	68 d2 3d 80 00       	push   $0x803dd2
  8001fd:	e8 d8 07 00 00       	call   8009da <cprintf>
  800202:	83 c4 10             	add    $0x10,%esp

		//freeHeap() ;

		///========================================================================
		//sys_disable_interrupt();
		cprintf("Do you want to repeat (y/n): ") ;
  800205:	83 ec 0c             	sub    $0xc,%esp
  800208:	68 e8 3d 80 00       	push   $0x803de8
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
  8004ea:	68 06 3e 80 00       	push   $0x803e06
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
  80050c:	68 08 3e 80 00       	push   $0x803e08
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
  80053a:	68 0d 3e 80 00       	push   $0x803e0d
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
  80055e:	e8 fb 19 00 00       	call   801f5e <sys_cputc>
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
  80056f:	e8 b6 19 00 00       	call   801f2a <sys_disable_interrupt>
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
  800582:	e8 d7 19 00 00       	call   801f5e <sys_cputc>
  800587:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80058a:	e8 b5 19 00 00       	call   801f44 <sys_enable_interrupt>
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
  8005a1:	e8 ff 17 00 00       	call   801da5 <sys_cgetc>
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
  8005ba:	e8 6b 19 00 00       	call   801f2a <sys_disable_interrupt>
	int c=0;
  8005bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8005c6:	eb 08                	jmp    8005d0 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  8005c8:	e8 d8 17 00 00       	call   801da5 <sys_cgetc>
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
  8005d6:	e8 69 19 00 00       	call   801f44 <sys_enable_interrupt>
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
  8005f0:	e8 28 1b 00 00       	call   80211d <sys_getenvindex>
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
  80065b:	e8 ca 18 00 00       	call   801f2a <sys_disable_interrupt>
	cprintf("**************************************\n");
  800660:	83 ec 0c             	sub    $0xc,%esp
  800663:	68 2c 3e 80 00       	push   $0x803e2c
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
  80068b:	68 54 3e 80 00       	push   $0x803e54
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
  8006bc:	68 7c 3e 80 00       	push   $0x803e7c
  8006c1:	e8 14 03 00 00       	call   8009da <cprintf>
  8006c6:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006c9:	a1 24 50 80 00       	mov    0x805024,%eax
  8006ce:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8006d4:	83 ec 08             	sub    $0x8,%esp
  8006d7:	50                   	push   %eax
  8006d8:	68 d4 3e 80 00       	push   $0x803ed4
  8006dd:	e8 f8 02 00 00       	call   8009da <cprintf>
  8006e2:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8006e5:	83 ec 0c             	sub    $0xc,%esp
  8006e8:	68 2c 3e 80 00       	push   $0x803e2c
  8006ed:	e8 e8 02 00 00       	call   8009da <cprintf>
  8006f2:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8006f5:	e8 4a 18 00 00       	call   801f44 <sys_enable_interrupt>

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
  80070d:	e8 d7 19 00 00       	call   8020e9 <sys_destroy_env>
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
  80071e:	e8 2c 1a 00 00       	call   80214f <sys_exit_env>
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
  800747:	68 e8 3e 80 00       	push   $0x803ee8
  80074c:	e8 89 02 00 00       	call   8009da <cprintf>
  800751:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800754:	a1 00 50 80 00       	mov    0x805000,%eax
  800759:	ff 75 0c             	pushl  0xc(%ebp)
  80075c:	ff 75 08             	pushl  0x8(%ebp)
  80075f:	50                   	push   %eax
  800760:	68 ed 3e 80 00       	push   $0x803eed
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
  800784:	68 09 3f 80 00       	push   $0x803f09
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
  8007b0:	68 0c 3f 80 00       	push   $0x803f0c
  8007b5:	6a 26                	push   $0x26
  8007b7:	68 58 3f 80 00       	push   $0x803f58
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
  800882:	68 64 3f 80 00       	push   $0x803f64
  800887:	6a 3a                	push   $0x3a
  800889:	68 58 3f 80 00       	push   $0x803f58
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
  8008f2:	68 b8 3f 80 00       	push   $0x803fb8
  8008f7:	6a 44                	push   $0x44
  8008f9:	68 58 3f 80 00       	push   $0x803f58
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
  80094c:	e8 2b 14 00 00       	call   801d7c <sys_cputs>
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
  8009c3:	e8 b4 13 00 00       	call   801d7c <sys_cputs>
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
  800a0d:	e8 18 15 00 00       	call   801f2a <sys_disable_interrupt>
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
  800a2d:	e8 12 15 00 00       	call   801f44 <sys_enable_interrupt>
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
  800a77:	e8 84 2f 00 00       	call   803a00 <__udivdi3>
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
  800ac7:	e8 44 30 00 00       	call   803b10 <__umoddi3>
  800acc:	83 c4 10             	add    $0x10,%esp
  800acf:	05 34 42 80 00       	add    $0x804234,%eax
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
  800c22:	8b 04 85 58 42 80 00 	mov    0x804258(,%eax,4),%eax
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
  800d03:	8b 34 9d a0 40 80 00 	mov    0x8040a0(,%ebx,4),%esi
  800d0a:	85 f6                	test   %esi,%esi
  800d0c:	75 19                	jne    800d27 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d0e:	53                   	push   %ebx
  800d0f:	68 45 42 80 00       	push   $0x804245
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
  800d28:	68 4e 42 80 00       	push   $0x80424e
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
  800d55:	be 51 42 80 00       	mov    $0x804251,%esi
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
  80106e:	68 b0 43 80 00       	push   $0x8043b0
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
  8010b0:	68 b3 43 80 00       	push   $0x8043b3
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
  801160:	e8 c5 0d 00 00       	call   801f2a <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  801165:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801169:	74 13                	je     80117e <atomic_readline+0x24>
		cprintf("%s", prompt);
  80116b:	83 ec 08             	sub    $0x8,%esp
  80116e:	ff 75 08             	pushl  0x8(%ebp)
  801171:	68 b0 43 80 00       	push   $0x8043b0
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
  8011af:	68 b3 43 80 00       	push   $0x8043b3
  8011b4:	e8 21 f8 ff ff       	call   8009da <cprintf>
  8011b9:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  8011bc:	e8 83 0d 00 00       	call   801f44 <sys_enable_interrupt>
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
  801254:	e8 eb 0c 00 00       	call   801f44 <sys_enable_interrupt>
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
  801981:	68 c4 43 80 00       	push   $0x8043c4
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
  801a51:	e8 6a 04 00 00       	call   801ec0 <sys_allocate_chunk>
  801a56:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801a59:	a1 20 51 80 00       	mov    0x805120,%eax
  801a5e:	83 ec 0c             	sub    $0xc,%esp
  801a61:	50                   	push   %eax
  801a62:	e8 df 0a 00 00       	call   802546 <initialize_MemBlocksList>
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
  801a8f:	68 e9 43 80 00       	push   $0x8043e9
  801a94:	6a 33                	push   $0x33
  801a96:	68 07 44 80 00       	push   $0x804407
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
  801b0e:	68 14 44 80 00       	push   $0x804414
  801b13:	6a 34                	push   $0x34
  801b15:	68 07 44 80 00       	push   $0x804407
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
  801ba6:	e8 e3 06 00 00       	call   80228e <sys_isUHeapPlacementStrategyFIRSTFIT>
  801bab:	85 c0                	test   %eax,%eax
  801bad:	74 11                	je     801bc0 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801baf:	83 ec 0c             	sub    $0xc,%esp
  801bb2:	ff 75 e8             	pushl  -0x18(%ebp)
  801bb5:	e8 4e 0d 00 00       	call   802908 <alloc_block_FF>
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
  801bcc:	e8 aa 0a 00 00       	call   80267b <insert_sorted_allocList>
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
  801be6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801be9:	83 ec 04             	sub    $0x4,%esp
  801bec:	68 38 44 80 00       	push   $0x804438
  801bf1:	6a 6f                	push   $0x6f
  801bf3:	68 07 44 80 00       	push   $0x804407
  801bf8:	e8 29 eb ff ff       	call   800726 <_panic>

00801bfd <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801bfd:	55                   	push   %ebp
  801bfe:	89 e5                	mov    %esp,%ebp
  801c00:	83 ec 38             	sub    $0x38,%esp
  801c03:	8b 45 10             	mov    0x10(%ebp),%eax
  801c06:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c09:	e8 5c fd ff ff       	call   80196a <InitializeUHeap>
	if (size == 0) return NULL ;
  801c0e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c12:	75 07                	jne    801c1b <smalloc+0x1e>
  801c14:	b8 00 00 00 00       	mov    $0x0,%eax
  801c19:	eb 7c                	jmp    801c97 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801c1b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801c22:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c28:	01 d0                	add    %edx,%eax
  801c2a:	48                   	dec    %eax
  801c2b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801c2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c31:	ba 00 00 00 00       	mov    $0x0,%edx
  801c36:	f7 75 f0             	divl   -0x10(%ebp)
  801c39:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c3c:	29 d0                	sub    %edx,%eax
  801c3e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801c41:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801c48:	e8 41 06 00 00       	call   80228e <sys_isUHeapPlacementStrategyFIRSTFIT>
  801c4d:	85 c0                	test   %eax,%eax
  801c4f:	74 11                	je     801c62 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  801c51:	83 ec 0c             	sub    $0xc,%esp
  801c54:	ff 75 e8             	pushl  -0x18(%ebp)
  801c57:	e8 ac 0c 00 00       	call   802908 <alloc_block_FF>
  801c5c:	83 c4 10             	add    $0x10,%esp
  801c5f:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801c62:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c66:	74 2a                	je     801c92 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801c68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c6b:	8b 40 08             	mov    0x8(%eax),%eax
  801c6e:	89 c2                	mov    %eax,%edx
  801c70:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801c74:	52                   	push   %edx
  801c75:	50                   	push   %eax
  801c76:	ff 75 0c             	pushl  0xc(%ebp)
  801c79:	ff 75 08             	pushl  0x8(%ebp)
  801c7c:	e8 92 03 00 00       	call   802013 <sys_createSharedObject>
  801c81:	83 c4 10             	add    $0x10,%esp
  801c84:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  801c87:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  801c8b:	74 05                	je     801c92 <smalloc+0x95>
			return (void*)virtual_address;
  801c8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c90:	eb 05                	jmp    801c97 <smalloc+0x9a>
	}
	return NULL;
  801c92:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801c97:	c9                   	leave  
  801c98:	c3                   	ret    

00801c99 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801c99:	55                   	push   %ebp
  801c9a:	89 e5                	mov    %esp,%ebp
  801c9c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c9f:	e8 c6 fc ff ff       	call   80196a <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801ca4:	83 ec 04             	sub    $0x4,%esp
  801ca7:	68 5c 44 80 00       	push   $0x80445c
  801cac:	68 b0 00 00 00       	push   $0xb0
  801cb1:	68 07 44 80 00       	push   $0x804407
  801cb6:	e8 6b ea ff ff       	call   800726 <_panic>

00801cbb <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801cbb:	55                   	push   %ebp
  801cbc:	89 e5                	mov    %esp,%ebp
  801cbe:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801cc1:	e8 a4 fc ff ff       	call   80196a <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801cc6:	83 ec 04             	sub    $0x4,%esp
  801cc9:	68 80 44 80 00       	push   $0x804480
  801cce:	68 f4 00 00 00       	push   $0xf4
  801cd3:	68 07 44 80 00       	push   $0x804407
  801cd8:	e8 49 ea ff ff       	call   800726 <_panic>

00801cdd <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801cdd:	55                   	push   %ebp
  801cde:	89 e5                	mov    %esp,%ebp
  801ce0:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801ce3:	83 ec 04             	sub    $0x4,%esp
  801ce6:	68 a8 44 80 00       	push   $0x8044a8
  801ceb:	68 08 01 00 00       	push   $0x108
  801cf0:	68 07 44 80 00       	push   $0x804407
  801cf5:	e8 2c ea ff ff       	call   800726 <_panic>

00801cfa <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801cfa:	55                   	push   %ebp
  801cfb:	89 e5                	mov    %esp,%ebp
  801cfd:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d00:	83 ec 04             	sub    $0x4,%esp
  801d03:	68 cc 44 80 00       	push   $0x8044cc
  801d08:	68 13 01 00 00       	push   $0x113
  801d0d:	68 07 44 80 00       	push   $0x804407
  801d12:	e8 0f ea ff ff       	call   800726 <_panic>

00801d17 <shrink>:

}
void shrink(uint32 newSize)
{
  801d17:	55                   	push   %ebp
  801d18:	89 e5                	mov    %esp,%ebp
  801d1a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d1d:	83 ec 04             	sub    $0x4,%esp
  801d20:	68 cc 44 80 00       	push   $0x8044cc
  801d25:	68 18 01 00 00       	push   $0x118
  801d2a:	68 07 44 80 00       	push   $0x804407
  801d2f:	e8 f2 e9 ff ff       	call   800726 <_panic>

00801d34 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801d34:	55                   	push   %ebp
  801d35:	89 e5                	mov    %esp,%ebp
  801d37:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d3a:	83 ec 04             	sub    $0x4,%esp
  801d3d:	68 cc 44 80 00       	push   $0x8044cc
  801d42:	68 1d 01 00 00       	push   $0x11d
  801d47:	68 07 44 80 00       	push   $0x804407
  801d4c:	e8 d5 e9 ff ff       	call   800726 <_panic>

00801d51 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801d51:	55                   	push   %ebp
  801d52:	89 e5                	mov    %esp,%ebp
  801d54:	57                   	push   %edi
  801d55:	56                   	push   %esi
  801d56:	53                   	push   %ebx
  801d57:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d60:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d63:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d66:	8b 7d 18             	mov    0x18(%ebp),%edi
  801d69:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801d6c:	cd 30                	int    $0x30
  801d6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801d71:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801d74:	83 c4 10             	add    $0x10,%esp
  801d77:	5b                   	pop    %ebx
  801d78:	5e                   	pop    %esi
  801d79:	5f                   	pop    %edi
  801d7a:	5d                   	pop    %ebp
  801d7b:	c3                   	ret    

00801d7c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801d7c:	55                   	push   %ebp
  801d7d:	89 e5                	mov    %esp,%ebp
  801d7f:	83 ec 04             	sub    $0x4,%esp
  801d82:	8b 45 10             	mov    0x10(%ebp),%eax
  801d85:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801d88:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 00                	push   $0x0
  801d93:	52                   	push   %edx
  801d94:	ff 75 0c             	pushl  0xc(%ebp)
  801d97:	50                   	push   %eax
  801d98:	6a 00                	push   $0x0
  801d9a:	e8 b2 ff ff ff       	call   801d51 <syscall>
  801d9f:	83 c4 18             	add    $0x18,%esp
}
  801da2:	90                   	nop
  801da3:	c9                   	leave  
  801da4:	c3                   	ret    

00801da5 <sys_cgetc>:

int
sys_cgetc(void)
{
  801da5:	55                   	push   %ebp
  801da6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801da8:	6a 00                	push   $0x0
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 01                	push   $0x1
  801db4:	e8 98 ff ff ff       	call   801d51 <syscall>
  801db9:	83 c4 18             	add    $0x18,%esp
}
  801dbc:	c9                   	leave  
  801dbd:	c3                   	ret    

00801dbe <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801dbe:	55                   	push   %ebp
  801dbf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801dc1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	52                   	push   %edx
  801dce:	50                   	push   %eax
  801dcf:	6a 05                	push   $0x5
  801dd1:	e8 7b ff ff ff       	call   801d51 <syscall>
  801dd6:	83 c4 18             	add    $0x18,%esp
}
  801dd9:	c9                   	leave  
  801dda:	c3                   	ret    

00801ddb <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801ddb:	55                   	push   %ebp
  801ddc:	89 e5                	mov    %esp,%ebp
  801dde:	56                   	push   %esi
  801ddf:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801de0:	8b 75 18             	mov    0x18(%ebp),%esi
  801de3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801de6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801de9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dec:	8b 45 08             	mov    0x8(%ebp),%eax
  801def:	56                   	push   %esi
  801df0:	53                   	push   %ebx
  801df1:	51                   	push   %ecx
  801df2:	52                   	push   %edx
  801df3:	50                   	push   %eax
  801df4:	6a 06                	push   $0x6
  801df6:	e8 56 ff ff ff       	call   801d51 <syscall>
  801dfb:	83 c4 18             	add    $0x18,%esp
}
  801dfe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e01:	5b                   	pop    %ebx
  801e02:	5e                   	pop    %esi
  801e03:	5d                   	pop    %ebp
  801e04:	c3                   	ret    

00801e05 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801e05:	55                   	push   %ebp
  801e06:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801e08:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	52                   	push   %edx
  801e15:	50                   	push   %eax
  801e16:	6a 07                	push   $0x7
  801e18:	e8 34 ff ff ff       	call   801d51 <syscall>
  801e1d:	83 c4 18             	add    $0x18,%esp
}
  801e20:	c9                   	leave  
  801e21:	c3                   	ret    

00801e22 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801e22:	55                   	push   %ebp
  801e23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801e25:	6a 00                	push   $0x0
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	ff 75 0c             	pushl  0xc(%ebp)
  801e2e:	ff 75 08             	pushl  0x8(%ebp)
  801e31:	6a 08                	push   $0x8
  801e33:	e8 19 ff ff ff       	call   801d51 <syscall>
  801e38:	83 c4 18             	add    $0x18,%esp
}
  801e3b:	c9                   	leave  
  801e3c:	c3                   	ret    

00801e3d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801e3d:	55                   	push   %ebp
  801e3e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801e40:	6a 00                	push   $0x0
  801e42:	6a 00                	push   $0x0
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	6a 00                	push   $0x0
  801e4a:	6a 09                	push   $0x9
  801e4c:	e8 00 ff ff ff       	call   801d51 <syscall>
  801e51:	83 c4 18             	add    $0x18,%esp
}
  801e54:	c9                   	leave  
  801e55:	c3                   	ret    

00801e56 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801e56:	55                   	push   %ebp
  801e57:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801e59:	6a 00                	push   $0x0
  801e5b:	6a 00                	push   $0x0
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 00                	push   $0x0
  801e63:	6a 0a                	push   $0xa
  801e65:	e8 e7 fe ff ff       	call   801d51 <syscall>
  801e6a:	83 c4 18             	add    $0x18,%esp
}
  801e6d:	c9                   	leave  
  801e6e:	c3                   	ret    

00801e6f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801e6f:	55                   	push   %ebp
  801e70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801e72:	6a 00                	push   $0x0
  801e74:	6a 00                	push   $0x0
  801e76:	6a 00                	push   $0x0
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 00                	push   $0x0
  801e7c:	6a 0b                	push   $0xb
  801e7e:	e8 ce fe ff ff       	call   801d51 <syscall>
  801e83:	83 c4 18             	add    $0x18,%esp
}
  801e86:	c9                   	leave  
  801e87:	c3                   	ret    

00801e88 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801e88:	55                   	push   %ebp
  801e89:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801e8b:	6a 00                	push   $0x0
  801e8d:	6a 00                	push   $0x0
  801e8f:	6a 00                	push   $0x0
  801e91:	ff 75 0c             	pushl  0xc(%ebp)
  801e94:	ff 75 08             	pushl  0x8(%ebp)
  801e97:	6a 0f                	push   $0xf
  801e99:	e8 b3 fe ff ff       	call   801d51 <syscall>
  801e9e:	83 c4 18             	add    $0x18,%esp
	return;
  801ea1:	90                   	nop
}
  801ea2:	c9                   	leave  
  801ea3:	c3                   	ret    

00801ea4 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801ea4:	55                   	push   %ebp
  801ea5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801ea7:	6a 00                	push   $0x0
  801ea9:	6a 00                	push   $0x0
  801eab:	6a 00                	push   $0x0
  801ead:	ff 75 0c             	pushl  0xc(%ebp)
  801eb0:	ff 75 08             	pushl  0x8(%ebp)
  801eb3:	6a 10                	push   $0x10
  801eb5:	e8 97 fe ff ff       	call   801d51 <syscall>
  801eba:	83 c4 18             	add    $0x18,%esp
	return ;
  801ebd:	90                   	nop
}
  801ebe:	c9                   	leave  
  801ebf:	c3                   	ret    

00801ec0 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ec0:	55                   	push   %ebp
  801ec1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ec3:	6a 00                	push   $0x0
  801ec5:	6a 00                	push   $0x0
  801ec7:	ff 75 10             	pushl  0x10(%ebp)
  801eca:	ff 75 0c             	pushl  0xc(%ebp)
  801ecd:	ff 75 08             	pushl  0x8(%ebp)
  801ed0:	6a 11                	push   $0x11
  801ed2:	e8 7a fe ff ff       	call   801d51 <syscall>
  801ed7:	83 c4 18             	add    $0x18,%esp
	return ;
  801eda:	90                   	nop
}
  801edb:	c9                   	leave  
  801edc:	c3                   	ret    

00801edd <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801edd:	55                   	push   %ebp
  801ede:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801ee0:	6a 00                	push   $0x0
  801ee2:	6a 00                	push   $0x0
  801ee4:	6a 00                	push   $0x0
  801ee6:	6a 00                	push   $0x0
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 0c                	push   $0xc
  801eec:	e8 60 fe ff ff       	call   801d51 <syscall>
  801ef1:	83 c4 18             	add    $0x18,%esp
}
  801ef4:	c9                   	leave  
  801ef5:	c3                   	ret    

00801ef6 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ef6:	55                   	push   %ebp
  801ef7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ef9:	6a 00                	push   $0x0
  801efb:	6a 00                	push   $0x0
  801efd:	6a 00                	push   $0x0
  801eff:	6a 00                	push   $0x0
  801f01:	ff 75 08             	pushl  0x8(%ebp)
  801f04:	6a 0d                	push   $0xd
  801f06:	e8 46 fe ff ff       	call   801d51 <syscall>
  801f0b:	83 c4 18             	add    $0x18,%esp
}
  801f0e:	c9                   	leave  
  801f0f:	c3                   	ret    

00801f10 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801f10:	55                   	push   %ebp
  801f11:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801f13:	6a 00                	push   $0x0
  801f15:	6a 00                	push   $0x0
  801f17:	6a 00                	push   $0x0
  801f19:	6a 00                	push   $0x0
  801f1b:	6a 00                	push   $0x0
  801f1d:	6a 0e                	push   $0xe
  801f1f:	e8 2d fe ff ff       	call   801d51 <syscall>
  801f24:	83 c4 18             	add    $0x18,%esp
}
  801f27:	90                   	nop
  801f28:	c9                   	leave  
  801f29:	c3                   	ret    

00801f2a <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801f2a:	55                   	push   %ebp
  801f2b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801f2d:	6a 00                	push   $0x0
  801f2f:	6a 00                	push   $0x0
  801f31:	6a 00                	push   $0x0
  801f33:	6a 00                	push   $0x0
  801f35:	6a 00                	push   $0x0
  801f37:	6a 13                	push   $0x13
  801f39:	e8 13 fe ff ff       	call   801d51 <syscall>
  801f3e:	83 c4 18             	add    $0x18,%esp
}
  801f41:	90                   	nop
  801f42:	c9                   	leave  
  801f43:	c3                   	ret    

00801f44 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801f44:	55                   	push   %ebp
  801f45:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801f47:	6a 00                	push   $0x0
  801f49:	6a 00                	push   $0x0
  801f4b:	6a 00                	push   $0x0
  801f4d:	6a 00                	push   $0x0
  801f4f:	6a 00                	push   $0x0
  801f51:	6a 14                	push   $0x14
  801f53:	e8 f9 fd ff ff       	call   801d51 <syscall>
  801f58:	83 c4 18             	add    $0x18,%esp
}
  801f5b:	90                   	nop
  801f5c:	c9                   	leave  
  801f5d:	c3                   	ret    

00801f5e <sys_cputc>:


void
sys_cputc(const char c)
{
  801f5e:	55                   	push   %ebp
  801f5f:	89 e5                	mov    %esp,%ebp
  801f61:	83 ec 04             	sub    $0x4,%esp
  801f64:	8b 45 08             	mov    0x8(%ebp),%eax
  801f67:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801f6a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f6e:	6a 00                	push   $0x0
  801f70:	6a 00                	push   $0x0
  801f72:	6a 00                	push   $0x0
  801f74:	6a 00                	push   $0x0
  801f76:	50                   	push   %eax
  801f77:	6a 15                	push   $0x15
  801f79:	e8 d3 fd ff ff       	call   801d51 <syscall>
  801f7e:	83 c4 18             	add    $0x18,%esp
}
  801f81:	90                   	nop
  801f82:	c9                   	leave  
  801f83:	c3                   	ret    

00801f84 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801f84:	55                   	push   %ebp
  801f85:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801f87:	6a 00                	push   $0x0
  801f89:	6a 00                	push   $0x0
  801f8b:	6a 00                	push   $0x0
  801f8d:	6a 00                	push   $0x0
  801f8f:	6a 00                	push   $0x0
  801f91:	6a 16                	push   $0x16
  801f93:	e8 b9 fd ff ff       	call   801d51 <syscall>
  801f98:	83 c4 18             	add    $0x18,%esp
}
  801f9b:	90                   	nop
  801f9c:	c9                   	leave  
  801f9d:	c3                   	ret    

00801f9e <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801f9e:	55                   	push   %ebp
  801f9f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa4:	6a 00                	push   $0x0
  801fa6:	6a 00                	push   $0x0
  801fa8:	6a 00                	push   $0x0
  801faa:	ff 75 0c             	pushl  0xc(%ebp)
  801fad:	50                   	push   %eax
  801fae:	6a 17                	push   $0x17
  801fb0:	e8 9c fd ff ff       	call   801d51 <syscall>
  801fb5:	83 c4 18             	add    $0x18,%esp
}
  801fb8:	c9                   	leave  
  801fb9:	c3                   	ret    

00801fba <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801fba:	55                   	push   %ebp
  801fbb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801fbd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc3:	6a 00                	push   $0x0
  801fc5:	6a 00                	push   $0x0
  801fc7:	6a 00                	push   $0x0
  801fc9:	52                   	push   %edx
  801fca:	50                   	push   %eax
  801fcb:	6a 1a                	push   $0x1a
  801fcd:	e8 7f fd ff ff       	call   801d51 <syscall>
  801fd2:	83 c4 18             	add    $0x18,%esp
}
  801fd5:	c9                   	leave  
  801fd6:	c3                   	ret    

00801fd7 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801fd7:	55                   	push   %ebp
  801fd8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801fda:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe0:	6a 00                	push   $0x0
  801fe2:	6a 00                	push   $0x0
  801fe4:	6a 00                	push   $0x0
  801fe6:	52                   	push   %edx
  801fe7:	50                   	push   %eax
  801fe8:	6a 18                	push   $0x18
  801fea:	e8 62 fd ff ff       	call   801d51 <syscall>
  801fef:	83 c4 18             	add    $0x18,%esp
}
  801ff2:	90                   	nop
  801ff3:	c9                   	leave  
  801ff4:	c3                   	ret    

00801ff5 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ff5:	55                   	push   %ebp
  801ff6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ff8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffe:	6a 00                	push   $0x0
  802000:	6a 00                	push   $0x0
  802002:	6a 00                	push   $0x0
  802004:	52                   	push   %edx
  802005:	50                   	push   %eax
  802006:	6a 19                	push   $0x19
  802008:	e8 44 fd ff ff       	call   801d51 <syscall>
  80200d:	83 c4 18             	add    $0x18,%esp
}
  802010:	90                   	nop
  802011:	c9                   	leave  
  802012:	c3                   	ret    

00802013 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802013:	55                   	push   %ebp
  802014:	89 e5                	mov    %esp,%ebp
  802016:	83 ec 04             	sub    $0x4,%esp
  802019:	8b 45 10             	mov    0x10(%ebp),%eax
  80201c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80201f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802022:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802026:	8b 45 08             	mov    0x8(%ebp),%eax
  802029:	6a 00                	push   $0x0
  80202b:	51                   	push   %ecx
  80202c:	52                   	push   %edx
  80202d:	ff 75 0c             	pushl  0xc(%ebp)
  802030:	50                   	push   %eax
  802031:	6a 1b                	push   $0x1b
  802033:	e8 19 fd ff ff       	call   801d51 <syscall>
  802038:	83 c4 18             	add    $0x18,%esp
}
  80203b:	c9                   	leave  
  80203c:	c3                   	ret    

0080203d <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80203d:	55                   	push   %ebp
  80203e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802040:	8b 55 0c             	mov    0xc(%ebp),%edx
  802043:	8b 45 08             	mov    0x8(%ebp),%eax
  802046:	6a 00                	push   $0x0
  802048:	6a 00                	push   $0x0
  80204a:	6a 00                	push   $0x0
  80204c:	52                   	push   %edx
  80204d:	50                   	push   %eax
  80204e:	6a 1c                	push   $0x1c
  802050:	e8 fc fc ff ff       	call   801d51 <syscall>
  802055:	83 c4 18             	add    $0x18,%esp
}
  802058:	c9                   	leave  
  802059:	c3                   	ret    

0080205a <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80205a:	55                   	push   %ebp
  80205b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80205d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802060:	8b 55 0c             	mov    0xc(%ebp),%edx
  802063:	8b 45 08             	mov    0x8(%ebp),%eax
  802066:	6a 00                	push   $0x0
  802068:	6a 00                	push   $0x0
  80206a:	51                   	push   %ecx
  80206b:	52                   	push   %edx
  80206c:	50                   	push   %eax
  80206d:	6a 1d                	push   $0x1d
  80206f:	e8 dd fc ff ff       	call   801d51 <syscall>
  802074:	83 c4 18             	add    $0x18,%esp
}
  802077:	c9                   	leave  
  802078:	c3                   	ret    

00802079 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802079:	55                   	push   %ebp
  80207a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80207c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80207f:	8b 45 08             	mov    0x8(%ebp),%eax
  802082:	6a 00                	push   $0x0
  802084:	6a 00                	push   $0x0
  802086:	6a 00                	push   $0x0
  802088:	52                   	push   %edx
  802089:	50                   	push   %eax
  80208a:	6a 1e                	push   $0x1e
  80208c:	e8 c0 fc ff ff       	call   801d51 <syscall>
  802091:	83 c4 18             	add    $0x18,%esp
}
  802094:	c9                   	leave  
  802095:	c3                   	ret    

00802096 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802096:	55                   	push   %ebp
  802097:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802099:	6a 00                	push   $0x0
  80209b:	6a 00                	push   $0x0
  80209d:	6a 00                	push   $0x0
  80209f:	6a 00                	push   $0x0
  8020a1:	6a 00                	push   $0x0
  8020a3:	6a 1f                	push   $0x1f
  8020a5:	e8 a7 fc ff ff       	call   801d51 <syscall>
  8020aa:	83 c4 18             	add    $0x18,%esp
}
  8020ad:	c9                   	leave  
  8020ae:	c3                   	ret    

008020af <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8020af:	55                   	push   %ebp
  8020b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8020b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b5:	6a 00                	push   $0x0
  8020b7:	ff 75 14             	pushl  0x14(%ebp)
  8020ba:	ff 75 10             	pushl  0x10(%ebp)
  8020bd:	ff 75 0c             	pushl  0xc(%ebp)
  8020c0:	50                   	push   %eax
  8020c1:	6a 20                	push   $0x20
  8020c3:	e8 89 fc ff ff       	call   801d51 <syscall>
  8020c8:	83 c4 18             	add    $0x18,%esp
}
  8020cb:	c9                   	leave  
  8020cc:	c3                   	ret    

008020cd <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8020cd:	55                   	push   %ebp
  8020ce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8020d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d3:	6a 00                	push   $0x0
  8020d5:	6a 00                	push   $0x0
  8020d7:	6a 00                	push   $0x0
  8020d9:	6a 00                	push   $0x0
  8020db:	50                   	push   %eax
  8020dc:	6a 21                	push   $0x21
  8020de:	e8 6e fc ff ff       	call   801d51 <syscall>
  8020e3:	83 c4 18             	add    $0x18,%esp
}
  8020e6:	90                   	nop
  8020e7:	c9                   	leave  
  8020e8:	c3                   	ret    

008020e9 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8020e9:	55                   	push   %ebp
  8020ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8020ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ef:	6a 00                	push   $0x0
  8020f1:	6a 00                	push   $0x0
  8020f3:	6a 00                	push   $0x0
  8020f5:	6a 00                	push   $0x0
  8020f7:	50                   	push   %eax
  8020f8:	6a 22                	push   $0x22
  8020fa:	e8 52 fc ff ff       	call   801d51 <syscall>
  8020ff:	83 c4 18             	add    $0x18,%esp
}
  802102:	c9                   	leave  
  802103:	c3                   	ret    

00802104 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802104:	55                   	push   %ebp
  802105:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802107:	6a 00                	push   $0x0
  802109:	6a 00                	push   $0x0
  80210b:	6a 00                	push   $0x0
  80210d:	6a 00                	push   $0x0
  80210f:	6a 00                	push   $0x0
  802111:	6a 02                	push   $0x2
  802113:	e8 39 fc ff ff       	call   801d51 <syscall>
  802118:	83 c4 18             	add    $0x18,%esp
}
  80211b:	c9                   	leave  
  80211c:	c3                   	ret    

0080211d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80211d:	55                   	push   %ebp
  80211e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802120:	6a 00                	push   $0x0
  802122:	6a 00                	push   $0x0
  802124:	6a 00                	push   $0x0
  802126:	6a 00                	push   $0x0
  802128:	6a 00                	push   $0x0
  80212a:	6a 03                	push   $0x3
  80212c:	e8 20 fc ff ff       	call   801d51 <syscall>
  802131:	83 c4 18             	add    $0x18,%esp
}
  802134:	c9                   	leave  
  802135:	c3                   	ret    

00802136 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802136:	55                   	push   %ebp
  802137:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802139:	6a 00                	push   $0x0
  80213b:	6a 00                	push   $0x0
  80213d:	6a 00                	push   $0x0
  80213f:	6a 00                	push   $0x0
  802141:	6a 00                	push   $0x0
  802143:	6a 04                	push   $0x4
  802145:	e8 07 fc ff ff       	call   801d51 <syscall>
  80214a:	83 c4 18             	add    $0x18,%esp
}
  80214d:	c9                   	leave  
  80214e:	c3                   	ret    

0080214f <sys_exit_env>:


void sys_exit_env(void)
{
  80214f:	55                   	push   %ebp
  802150:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802152:	6a 00                	push   $0x0
  802154:	6a 00                	push   $0x0
  802156:	6a 00                	push   $0x0
  802158:	6a 00                	push   $0x0
  80215a:	6a 00                	push   $0x0
  80215c:	6a 23                	push   $0x23
  80215e:	e8 ee fb ff ff       	call   801d51 <syscall>
  802163:	83 c4 18             	add    $0x18,%esp
}
  802166:	90                   	nop
  802167:	c9                   	leave  
  802168:	c3                   	ret    

00802169 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802169:	55                   	push   %ebp
  80216a:	89 e5                	mov    %esp,%ebp
  80216c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80216f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802172:	8d 50 04             	lea    0x4(%eax),%edx
  802175:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802178:	6a 00                	push   $0x0
  80217a:	6a 00                	push   $0x0
  80217c:	6a 00                	push   $0x0
  80217e:	52                   	push   %edx
  80217f:	50                   	push   %eax
  802180:	6a 24                	push   $0x24
  802182:	e8 ca fb ff ff       	call   801d51 <syscall>
  802187:	83 c4 18             	add    $0x18,%esp
	return result;
  80218a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80218d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802190:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802193:	89 01                	mov    %eax,(%ecx)
  802195:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802198:	8b 45 08             	mov    0x8(%ebp),%eax
  80219b:	c9                   	leave  
  80219c:	c2 04 00             	ret    $0x4

0080219f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80219f:	55                   	push   %ebp
  8021a0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8021a2:	6a 00                	push   $0x0
  8021a4:	6a 00                	push   $0x0
  8021a6:	ff 75 10             	pushl  0x10(%ebp)
  8021a9:	ff 75 0c             	pushl  0xc(%ebp)
  8021ac:	ff 75 08             	pushl  0x8(%ebp)
  8021af:	6a 12                	push   $0x12
  8021b1:	e8 9b fb ff ff       	call   801d51 <syscall>
  8021b6:	83 c4 18             	add    $0x18,%esp
	return ;
  8021b9:	90                   	nop
}
  8021ba:	c9                   	leave  
  8021bb:	c3                   	ret    

008021bc <sys_rcr2>:
uint32 sys_rcr2()
{
  8021bc:	55                   	push   %ebp
  8021bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8021bf:	6a 00                	push   $0x0
  8021c1:	6a 00                	push   $0x0
  8021c3:	6a 00                	push   $0x0
  8021c5:	6a 00                	push   $0x0
  8021c7:	6a 00                	push   $0x0
  8021c9:	6a 25                	push   $0x25
  8021cb:	e8 81 fb ff ff       	call   801d51 <syscall>
  8021d0:	83 c4 18             	add    $0x18,%esp
}
  8021d3:	c9                   	leave  
  8021d4:	c3                   	ret    

008021d5 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8021d5:	55                   	push   %ebp
  8021d6:	89 e5                	mov    %esp,%ebp
  8021d8:	83 ec 04             	sub    $0x4,%esp
  8021db:	8b 45 08             	mov    0x8(%ebp),%eax
  8021de:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8021e1:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8021e5:	6a 00                	push   $0x0
  8021e7:	6a 00                	push   $0x0
  8021e9:	6a 00                	push   $0x0
  8021eb:	6a 00                	push   $0x0
  8021ed:	50                   	push   %eax
  8021ee:	6a 26                	push   $0x26
  8021f0:	e8 5c fb ff ff       	call   801d51 <syscall>
  8021f5:	83 c4 18             	add    $0x18,%esp
	return ;
  8021f8:	90                   	nop
}
  8021f9:	c9                   	leave  
  8021fa:	c3                   	ret    

008021fb <rsttst>:
void rsttst()
{
  8021fb:	55                   	push   %ebp
  8021fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8021fe:	6a 00                	push   $0x0
  802200:	6a 00                	push   $0x0
  802202:	6a 00                	push   $0x0
  802204:	6a 00                	push   $0x0
  802206:	6a 00                	push   $0x0
  802208:	6a 28                	push   $0x28
  80220a:	e8 42 fb ff ff       	call   801d51 <syscall>
  80220f:	83 c4 18             	add    $0x18,%esp
	return ;
  802212:	90                   	nop
}
  802213:	c9                   	leave  
  802214:	c3                   	ret    

00802215 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802215:	55                   	push   %ebp
  802216:	89 e5                	mov    %esp,%ebp
  802218:	83 ec 04             	sub    $0x4,%esp
  80221b:	8b 45 14             	mov    0x14(%ebp),%eax
  80221e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802221:	8b 55 18             	mov    0x18(%ebp),%edx
  802224:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802228:	52                   	push   %edx
  802229:	50                   	push   %eax
  80222a:	ff 75 10             	pushl  0x10(%ebp)
  80222d:	ff 75 0c             	pushl  0xc(%ebp)
  802230:	ff 75 08             	pushl  0x8(%ebp)
  802233:	6a 27                	push   $0x27
  802235:	e8 17 fb ff ff       	call   801d51 <syscall>
  80223a:	83 c4 18             	add    $0x18,%esp
	return ;
  80223d:	90                   	nop
}
  80223e:	c9                   	leave  
  80223f:	c3                   	ret    

00802240 <chktst>:
void chktst(uint32 n)
{
  802240:	55                   	push   %ebp
  802241:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802243:	6a 00                	push   $0x0
  802245:	6a 00                	push   $0x0
  802247:	6a 00                	push   $0x0
  802249:	6a 00                	push   $0x0
  80224b:	ff 75 08             	pushl  0x8(%ebp)
  80224e:	6a 29                	push   $0x29
  802250:	e8 fc fa ff ff       	call   801d51 <syscall>
  802255:	83 c4 18             	add    $0x18,%esp
	return ;
  802258:	90                   	nop
}
  802259:	c9                   	leave  
  80225a:	c3                   	ret    

0080225b <inctst>:

void inctst()
{
  80225b:	55                   	push   %ebp
  80225c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80225e:	6a 00                	push   $0x0
  802260:	6a 00                	push   $0x0
  802262:	6a 00                	push   $0x0
  802264:	6a 00                	push   $0x0
  802266:	6a 00                	push   $0x0
  802268:	6a 2a                	push   $0x2a
  80226a:	e8 e2 fa ff ff       	call   801d51 <syscall>
  80226f:	83 c4 18             	add    $0x18,%esp
	return ;
  802272:	90                   	nop
}
  802273:	c9                   	leave  
  802274:	c3                   	ret    

00802275 <gettst>:
uint32 gettst()
{
  802275:	55                   	push   %ebp
  802276:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802278:	6a 00                	push   $0x0
  80227a:	6a 00                	push   $0x0
  80227c:	6a 00                	push   $0x0
  80227e:	6a 00                	push   $0x0
  802280:	6a 00                	push   $0x0
  802282:	6a 2b                	push   $0x2b
  802284:	e8 c8 fa ff ff       	call   801d51 <syscall>
  802289:	83 c4 18             	add    $0x18,%esp
}
  80228c:	c9                   	leave  
  80228d:	c3                   	ret    

0080228e <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80228e:	55                   	push   %ebp
  80228f:	89 e5                	mov    %esp,%ebp
  802291:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802294:	6a 00                	push   $0x0
  802296:	6a 00                	push   $0x0
  802298:	6a 00                	push   $0x0
  80229a:	6a 00                	push   $0x0
  80229c:	6a 00                	push   $0x0
  80229e:	6a 2c                	push   $0x2c
  8022a0:	e8 ac fa ff ff       	call   801d51 <syscall>
  8022a5:	83 c4 18             	add    $0x18,%esp
  8022a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8022ab:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8022af:	75 07                	jne    8022b8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8022b1:	b8 01 00 00 00       	mov    $0x1,%eax
  8022b6:	eb 05                	jmp    8022bd <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8022b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022bd:	c9                   	leave  
  8022be:	c3                   	ret    

008022bf <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8022bf:	55                   	push   %ebp
  8022c0:	89 e5                	mov    %esp,%ebp
  8022c2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022c5:	6a 00                	push   $0x0
  8022c7:	6a 00                	push   $0x0
  8022c9:	6a 00                	push   $0x0
  8022cb:	6a 00                	push   $0x0
  8022cd:	6a 00                	push   $0x0
  8022cf:	6a 2c                	push   $0x2c
  8022d1:	e8 7b fa ff ff       	call   801d51 <syscall>
  8022d6:	83 c4 18             	add    $0x18,%esp
  8022d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8022dc:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8022e0:	75 07                	jne    8022e9 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8022e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8022e7:	eb 05                	jmp    8022ee <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8022e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022ee:	c9                   	leave  
  8022ef:	c3                   	ret    

008022f0 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8022f0:	55                   	push   %ebp
  8022f1:	89 e5                	mov    %esp,%ebp
  8022f3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022f6:	6a 00                	push   $0x0
  8022f8:	6a 00                	push   $0x0
  8022fa:	6a 00                	push   $0x0
  8022fc:	6a 00                	push   $0x0
  8022fe:	6a 00                	push   $0x0
  802300:	6a 2c                	push   $0x2c
  802302:	e8 4a fa ff ff       	call   801d51 <syscall>
  802307:	83 c4 18             	add    $0x18,%esp
  80230a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80230d:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802311:	75 07                	jne    80231a <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802313:	b8 01 00 00 00       	mov    $0x1,%eax
  802318:	eb 05                	jmp    80231f <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80231a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80231f:	c9                   	leave  
  802320:	c3                   	ret    

00802321 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802321:	55                   	push   %ebp
  802322:	89 e5                	mov    %esp,%ebp
  802324:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802327:	6a 00                	push   $0x0
  802329:	6a 00                	push   $0x0
  80232b:	6a 00                	push   $0x0
  80232d:	6a 00                	push   $0x0
  80232f:	6a 00                	push   $0x0
  802331:	6a 2c                	push   $0x2c
  802333:	e8 19 fa ff ff       	call   801d51 <syscall>
  802338:	83 c4 18             	add    $0x18,%esp
  80233b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80233e:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802342:	75 07                	jne    80234b <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802344:	b8 01 00 00 00       	mov    $0x1,%eax
  802349:	eb 05                	jmp    802350 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80234b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802350:	c9                   	leave  
  802351:	c3                   	ret    

00802352 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802352:	55                   	push   %ebp
  802353:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802355:	6a 00                	push   $0x0
  802357:	6a 00                	push   $0x0
  802359:	6a 00                	push   $0x0
  80235b:	6a 00                	push   $0x0
  80235d:	ff 75 08             	pushl  0x8(%ebp)
  802360:	6a 2d                	push   $0x2d
  802362:	e8 ea f9 ff ff       	call   801d51 <syscall>
  802367:	83 c4 18             	add    $0x18,%esp
	return ;
  80236a:	90                   	nop
}
  80236b:	c9                   	leave  
  80236c:	c3                   	ret    

0080236d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80236d:	55                   	push   %ebp
  80236e:	89 e5                	mov    %esp,%ebp
  802370:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802371:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802374:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802377:	8b 55 0c             	mov    0xc(%ebp),%edx
  80237a:	8b 45 08             	mov    0x8(%ebp),%eax
  80237d:	6a 00                	push   $0x0
  80237f:	53                   	push   %ebx
  802380:	51                   	push   %ecx
  802381:	52                   	push   %edx
  802382:	50                   	push   %eax
  802383:	6a 2e                	push   $0x2e
  802385:	e8 c7 f9 ff ff       	call   801d51 <syscall>
  80238a:	83 c4 18             	add    $0x18,%esp
}
  80238d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802390:	c9                   	leave  
  802391:	c3                   	ret    

00802392 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802392:	55                   	push   %ebp
  802393:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802395:	8b 55 0c             	mov    0xc(%ebp),%edx
  802398:	8b 45 08             	mov    0x8(%ebp),%eax
  80239b:	6a 00                	push   $0x0
  80239d:	6a 00                	push   $0x0
  80239f:	6a 00                	push   $0x0
  8023a1:	52                   	push   %edx
  8023a2:	50                   	push   %eax
  8023a3:	6a 2f                	push   $0x2f
  8023a5:	e8 a7 f9 ff ff       	call   801d51 <syscall>
  8023aa:	83 c4 18             	add    $0x18,%esp
}
  8023ad:	c9                   	leave  
  8023ae:	c3                   	ret    

008023af <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8023af:	55                   	push   %ebp
  8023b0:	89 e5                	mov    %esp,%ebp
  8023b2:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8023b5:	83 ec 0c             	sub    $0xc,%esp
  8023b8:	68 dc 44 80 00       	push   $0x8044dc
  8023bd:	e8 18 e6 ff ff       	call   8009da <cprintf>
  8023c2:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8023c5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8023cc:	83 ec 0c             	sub    $0xc,%esp
  8023cf:	68 08 45 80 00       	push   $0x804508
  8023d4:	e8 01 e6 ff ff       	call   8009da <cprintf>
  8023d9:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8023dc:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8023e0:	a1 38 51 80 00       	mov    0x805138,%eax
  8023e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023e8:	eb 56                	jmp    802440 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8023ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023ee:	74 1c                	je     80240c <print_mem_block_lists+0x5d>
  8023f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f3:	8b 50 08             	mov    0x8(%eax),%edx
  8023f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f9:	8b 48 08             	mov    0x8(%eax),%ecx
  8023fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ff:	8b 40 0c             	mov    0xc(%eax),%eax
  802402:	01 c8                	add    %ecx,%eax
  802404:	39 c2                	cmp    %eax,%edx
  802406:	73 04                	jae    80240c <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802408:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80240c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240f:	8b 50 08             	mov    0x8(%eax),%edx
  802412:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802415:	8b 40 0c             	mov    0xc(%eax),%eax
  802418:	01 c2                	add    %eax,%edx
  80241a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241d:	8b 40 08             	mov    0x8(%eax),%eax
  802420:	83 ec 04             	sub    $0x4,%esp
  802423:	52                   	push   %edx
  802424:	50                   	push   %eax
  802425:	68 1d 45 80 00       	push   $0x80451d
  80242a:	e8 ab e5 ff ff       	call   8009da <cprintf>
  80242f:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802432:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802435:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802438:	a1 40 51 80 00       	mov    0x805140,%eax
  80243d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802440:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802444:	74 07                	je     80244d <print_mem_block_lists+0x9e>
  802446:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802449:	8b 00                	mov    (%eax),%eax
  80244b:	eb 05                	jmp    802452 <print_mem_block_lists+0xa3>
  80244d:	b8 00 00 00 00       	mov    $0x0,%eax
  802452:	a3 40 51 80 00       	mov    %eax,0x805140
  802457:	a1 40 51 80 00       	mov    0x805140,%eax
  80245c:	85 c0                	test   %eax,%eax
  80245e:	75 8a                	jne    8023ea <print_mem_block_lists+0x3b>
  802460:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802464:	75 84                	jne    8023ea <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802466:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80246a:	75 10                	jne    80247c <print_mem_block_lists+0xcd>
  80246c:	83 ec 0c             	sub    $0xc,%esp
  80246f:	68 2c 45 80 00       	push   $0x80452c
  802474:	e8 61 e5 ff ff       	call   8009da <cprintf>
  802479:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80247c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802483:	83 ec 0c             	sub    $0xc,%esp
  802486:	68 50 45 80 00       	push   $0x804550
  80248b:	e8 4a e5 ff ff       	call   8009da <cprintf>
  802490:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802493:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802497:	a1 40 50 80 00       	mov    0x805040,%eax
  80249c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80249f:	eb 56                	jmp    8024f7 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8024a1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024a5:	74 1c                	je     8024c3 <print_mem_block_lists+0x114>
  8024a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024aa:	8b 50 08             	mov    0x8(%eax),%edx
  8024ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024b0:	8b 48 08             	mov    0x8(%eax),%ecx
  8024b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8024b9:	01 c8                	add    %ecx,%eax
  8024bb:	39 c2                	cmp    %eax,%edx
  8024bd:	73 04                	jae    8024c3 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8024bf:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8024c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c6:	8b 50 08             	mov    0x8(%eax),%edx
  8024c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8024cf:	01 c2                	add    %eax,%edx
  8024d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d4:	8b 40 08             	mov    0x8(%eax),%eax
  8024d7:	83 ec 04             	sub    $0x4,%esp
  8024da:	52                   	push   %edx
  8024db:	50                   	push   %eax
  8024dc:	68 1d 45 80 00       	push   $0x80451d
  8024e1:	e8 f4 e4 ff ff       	call   8009da <cprintf>
  8024e6:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8024e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8024ef:	a1 48 50 80 00       	mov    0x805048,%eax
  8024f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024fb:	74 07                	je     802504 <print_mem_block_lists+0x155>
  8024fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802500:	8b 00                	mov    (%eax),%eax
  802502:	eb 05                	jmp    802509 <print_mem_block_lists+0x15a>
  802504:	b8 00 00 00 00       	mov    $0x0,%eax
  802509:	a3 48 50 80 00       	mov    %eax,0x805048
  80250e:	a1 48 50 80 00       	mov    0x805048,%eax
  802513:	85 c0                	test   %eax,%eax
  802515:	75 8a                	jne    8024a1 <print_mem_block_lists+0xf2>
  802517:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80251b:	75 84                	jne    8024a1 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80251d:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802521:	75 10                	jne    802533 <print_mem_block_lists+0x184>
  802523:	83 ec 0c             	sub    $0xc,%esp
  802526:	68 68 45 80 00       	push   $0x804568
  80252b:	e8 aa e4 ff ff       	call   8009da <cprintf>
  802530:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802533:	83 ec 0c             	sub    $0xc,%esp
  802536:	68 dc 44 80 00       	push   $0x8044dc
  80253b:	e8 9a e4 ff ff       	call   8009da <cprintf>
  802540:	83 c4 10             	add    $0x10,%esp

}
  802543:	90                   	nop
  802544:	c9                   	leave  
  802545:	c3                   	ret    

00802546 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802546:	55                   	push   %ebp
  802547:	89 e5                	mov    %esp,%ebp
  802549:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  80254c:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802553:	00 00 00 
  802556:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80255d:	00 00 00 
  802560:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802567:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  80256a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802571:	e9 9e 00 00 00       	jmp    802614 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802576:	a1 50 50 80 00       	mov    0x805050,%eax
  80257b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80257e:	c1 e2 04             	shl    $0x4,%edx
  802581:	01 d0                	add    %edx,%eax
  802583:	85 c0                	test   %eax,%eax
  802585:	75 14                	jne    80259b <initialize_MemBlocksList+0x55>
  802587:	83 ec 04             	sub    $0x4,%esp
  80258a:	68 90 45 80 00       	push   $0x804590
  80258f:	6a 46                	push   $0x46
  802591:	68 b3 45 80 00       	push   $0x8045b3
  802596:	e8 8b e1 ff ff       	call   800726 <_panic>
  80259b:	a1 50 50 80 00       	mov    0x805050,%eax
  8025a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025a3:	c1 e2 04             	shl    $0x4,%edx
  8025a6:	01 d0                	add    %edx,%eax
  8025a8:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8025ae:	89 10                	mov    %edx,(%eax)
  8025b0:	8b 00                	mov    (%eax),%eax
  8025b2:	85 c0                	test   %eax,%eax
  8025b4:	74 18                	je     8025ce <initialize_MemBlocksList+0x88>
  8025b6:	a1 48 51 80 00       	mov    0x805148,%eax
  8025bb:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8025c1:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8025c4:	c1 e1 04             	shl    $0x4,%ecx
  8025c7:	01 ca                	add    %ecx,%edx
  8025c9:	89 50 04             	mov    %edx,0x4(%eax)
  8025cc:	eb 12                	jmp    8025e0 <initialize_MemBlocksList+0x9a>
  8025ce:	a1 50 50 80 00       	mov    0x805050,%eax
  8025d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025d6:	c1 e2 04             	shl    $0x4,%edx
  8025d9:	01 d0                	add    %edx,%eax
  8025db:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8025e0:	a1 50 50 80 00       	mov    0x805050,%eax
  8025e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025e8:	c1 e2 04             	shl    $0x4,%edx
  8025eb:	01 d0                	add    %edx,%eax
  8025ed:	a3 48 51 80 00       	mov    %eax,0x805148
  8025f2:	a1 50 50 80 00       	mov    0x805050,%eax
  8025f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025fa:	c1 e2 04             	shl    $0x4,%edx
  8025fd:	01 d0                	add    %edx,%eax
  8025ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802606:	a1 54 51 80 00       	mov    0x805154,%eax
  80260b:	40                   	inc    %eax
  80260c:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802611:	ff 45 f4             	incl   -0xc(%ebp)
  802614:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802617:	3b 45 08             	cmp    0x8(%ebp),%eax
  80261a:	0f 82 56 ff ff ff    	jb     802576 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802620:	90                   	nop
  802621:	c9                   	leave  
  802622:	c3                   	ret    

00802623 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802623:	55                   	push   %ebp
  802624:	89 e5                	mov    %esp,%ebp
  802626:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802629:	8b 45 08             	mov    0x8(%ebp),%eax
  80262c:	8b 00                	mov    (%eax),%eax
  80262e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802631:	eb 19                	jmp    80264c <find_block+0x29>
	{
		if(va==point->sva)
  802633:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802636:	8b 40 08             	mov    0x8(%eax),%eax
  802639:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80263c:	75 05                	jne    802643 <find_block+0x20>
		   return point;
  80263e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802641:	eb 36                	jmp    802679 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802643:	8b 45 08             	mov    0x8(%ebp),%eax
  802646:	8b 40 08             	mov    0x8(%eax),%eax
  802649:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80264c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802650:	74 07                	je     802659 <find_block+0x36>
  802652:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802655:	8b 00                	mov    (%eax),%eax
  802657:	eb 05                	jmp    80265e <find_block+0x3b>
  802659:	b8 00 00 00 00       	mov    $0x0,%eax
  80265e:	8b 55 08             	mov    0x8(%ebp),%edx
  802661:	89 42 08             	mov    %eax,0x8(%edx)
  802664:	8b 45 08             	mov    0x8(%ebp),%eax
  802667:	8b 40 08             	mov    0x8(%eax),%eax
  80266a:	85 c0                	test   %eax,%eax
  80266c:	75 c5                	jne    802633 <find_block+0x10>
  80266e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802672:	75 bf                	jne    802633 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802674:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802679:	c9                   	leave  
  80267a:	c3                   	ret    

0080267b <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80267b:	55                   	push   %ebp
  80267c:	89 e5                	mov    %esp,%ebp
  80267e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802681:	a1 40 50 80 00       	mov    0x805040,%eax
  802686:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802689:	a1 44 50 80 00       	mov    0x805044,%eax
  80268e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802691:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802694:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802697:	74 24                	je     8026bd <insert_sorted_allocList+0x42>
  802699:	8b 45 08             	mov    0x8(%ebp),%eax
  80269c:	8b 50 08             	mov    0x8(%eax),%edx
  80269f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026a2:	8b 40 08             	mov    0x8(%eax),%eax
  8026a5:	39 c2                	cmp    %eax,%edx
  8026a7:	76 14                	jbe    8026bd <insert_sorted_allocList+0x42>
  8026a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ac:	8b 50 08             	mov    0x8(%eax),%edx
  8026af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026b2:	8b 40 08             	mov    0x8(%eax),%eax
  8026b5:	39 c2                	cmp    %eax,%edx
  8026b7:	0f 82 60 01 00 00    	jb     80281d <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8026bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026c1:	75 65                	jne    802728 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8026c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026c7:	75 14                	jne    8026dd <insert_sorted_allocList+0x62>
  8026c9:	83 ec 04             	sub    $0x4,%esp
  8026cc:	68 90 45 80 00       	push   $0x804590
  8026d1:	6a 6b                	push   $0x6b
  8026d3:	68 b3 45 80 00       	push   $0x8045b3
  8026d8:	e8 49 e0 ff ff       	call   800726 <_panic>
  8026dd:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8026e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e6:	89 10                	mov    %edx,(%eax)
  8026e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026eb:	8b 00                	mov    (%eax),%eax
  8026ed:	85 c0                	test   %eax,%eax
  8026ef:	74 0d                	je     8026fe <insert_sorted_allocList+0x83>
  8026f1:	a1 40 50 80 00       	mov    0x805040,%eax
  8026f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8026f9:	89 50 04             	mov    %edx,0x4(%eax)
  8026fc:	eb 08                	jmp    802706 <insert_sorted_allocList+0x8b>
  8026fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802701:	a3 44 50 80 00       	mov    %eax,0x805044
  802706:	8b 45 08             	mov    0x8(%ebp),%eax
  802709:	a3 40 50 80 00       	mov    %eax,0x805040
  80270e:	8b 45 08             	mov    0x8(%ebp),%eax
  802711:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802718:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80271d:	40                   	inc    %eax
  80271e:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802723:	e9 dc 01 00 00       	jmp    802904 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802728:	8b 45 08             	mov    0x8(%ebp),%eax
  80272b:	8b 50 08             	mov    0x8(%eax),%edx
  80272e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802731:	8b 40 08             	mov    0x8(%eax),%eax
  802734:	39 c2                	cmp    %eax,%edx
  802736:	77 6c                	ja     8027a4 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802738:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80273c:	74 06                	je     802744 <insert_sorted_allocList+0xc9>
  80273e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802742:	75 14                	jne    802758 <insert_sorted_allocList+0xdd>
  802744:	83 ec 04             	sub    $0x4,%esp
  802747:	68 cc 45 80 00       	push   $0x8045cc
  80274c:	6a 6f                	push   $0x6f
  80274e:	68 b3 45 80 00       	push   $0x8045b3
  802753:	e8 ce df ff ff       	call   800726 <_panic>
  802758:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80275b:	8b 50 04             	mov    0x4(%eax),%edx
  80275e:	8b 45 08             	mov    0x8(%ebp),%eax
  802761:	89 50 04             	mov    %edx,0x4(%eax)
  802764:	8b 45 08             	mov    0x8(%ebp),%eax
  802767:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80276a:	89 10                	mov    %edx,(%eax)
  80276c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80276f:	8b 40 04             	mov    0x4(%eax),%eax
  802772:	85 c0                	test   %eax,%eax
  802774:	74 0d                	je     802783 <insert_sorted_allocList+0x108>
  802776:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802779:	8b 40 04             	mov    0x4(%eax),%eax
  80277c:	8b 55 08             	mov    0x8(%ebp),%edx
  80277f:	89 10                	mov    %edx,(%eax)
  802781:	eb 08                	jmp    80278b <insert_sorted_allocList+0x110>
  802783:	8b 45 08             	mov    0x8(%ebp),%eax
  802786:	a3 40 50 80 00       	mov    %eax,0x805040
  80278b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80278e:	8b 55 08             	mov    0x8(%ebp),%edx
  802791:	89 50 04             	mov    %edx,0x4(%eax)
  802794:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802799:	40                   	inc    %eax
  80279a:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80279f:	e9 60 01 00 00       	jmp    802904 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8027a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a7:	8b 50 08             	mov    0x8(%eax),%edx
  8027aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ad:	8b 40 08             	mov    0x8(%eax),%eax
  8027b0:	39 c2                	cmp    %eax,%edx
  8027b2:	0f 82 4c 01 00 00    	jb     802904 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8027b8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027bc:	75 14                	jne    8027d2 <insert_sorted_allocList+0x157>
  8027be:	83 ec 04             	sub    $0x4,%esp
  8027c1:	68 04 46 80 00       	push   $0x804604
  8027c6:	6a 73                	push   $0x73
  8027c8:	68 b3 45 80 00       	push   $0x8045b3
  8027cd:	e8 54 df ff ff       	call   800726 <_panic>
  8027d2:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8027d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027db:	89 50 04             	mov    %edx,0x4(%eax)
  8027de:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e1:	8b 40 04             	mov    0x4(%eax),%eax
  8027e4:	85 c0                	test   %eax,%eax
  8027e6:	74 0c                	je     8027f4 <insert_sorted_allocList+0x179>
  8027e8:	a1 44 50 80 00       	mov    0x805044,%eax
  8027ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8027f0:	89 10                	mov    %edx,(%eax)
  8027f2:	eb 08                	jmp    8027fc <insert_sorted_allocList+0x181>
  8027f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f7:	a3 40 50 80 00       	mov    %eax,0x805040
  8027fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ff:	a3 44 50 80 00       	mov    %eax,0x805044
  802804:	8b 45 08             	mov    0x8(%ebp),%eax
  802807:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80280d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802812:	40                   	inc    %eax
  802813:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802818:	e9 e7 00 00 00       	jmp    802904 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80281d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802820:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802823:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80282a:	a1 40 50 80 00       	mov    0x805040,%eax
  80282f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802832:	e9 9d 00 00 00       	jmp    8028d4 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802837:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283a:	8b 00                	mov    (%eax),%eax
  80283c:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80283f:	8b 45 08             	mov    0x8(%ebp),%eax
  802842:	8b 50 08             	mov    0x8(%eax),%edx
  802845:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802848:	8b 40 08             	mov    0x8(%eax),%eax
  80284b:	39 c2                	cmp    %eax,%edx
  80284d:	76 7d                	jbe    8028cc <insert_sorted_allocList+0x251>
  80284f:	8b 45 08             	mov    0x8(%ebp),%eax
  802852:	8b 50 08             	mov    0x8(%eax),%edx
  802855:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802858:	8b 40 08             	mov    0x8(%eax),%eax
  80285b:	39 c2                	cmp    %eax,%edx
  80285d:	73 6d                	jae    8028cc <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80285f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802863:	74 06                	je     80286b <insert_sorted_allocList+0x1f0>
  802865:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802869:	75 14                	jne    80287f <insert_sorted_allocList+0x204>
  80286b:	83 ec 04             	sub    $0x4,%esp
  80286e:	68 28 46 80 00       	push   $0x804628
  802873:	6a 7f                	push   $0x7f
  802875:	68 b3 45 80 00       	push   $0x8045b3
  80287a:	e8 a7 de ff ff       	call   800726 <_panic>
  80287f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802882:	8b 10                	mov    (%eax),%edx
  802884:	8b 45 08             	mov    0x8(%ebp),%eax
  802887:	89 10                	mov    %edx,(%eax)
  802889:	8b 45 08             	mov    0x8(%ebp),%eax
  80288c:	8b 00                	mov    (%eax),%eax
  80288e:	85 c0                	test   %eax,%eax
  802890:	74 0b                	je     80289d <insert_sorted_allocList+0x222>
  802892:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802895:	8b 00                	mov    (%eax),%eax
  802897:	8b 55 08             	mov    0x8(%ebp),%edx
  80289a:	89 50 04             	mov    %edx,0x4(%eax)
  80289d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8028a3:	89 10                	mov    %edx,(%eax)
  8028a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028ab:	89 50 04             	mov    %edx,0x4(%eax)
  8028ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b1:	8b 00                	mov    (%eax),%eax
  8028b3:	85 c0                	test   %eax,%eax
  8028b5:	75 08                	jne    8028bf <insert_sorted_allocList+0x244>
  8028b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ba:	a3 44 50 80 00       	mov    %eax,0x805044
  8028bf:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8028c4:	40                   	inc    %eax
  8028c5:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8028ca:	eb 39                	jmp    802905 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8028cc:	a1 48 50 80 00       	mov    0x805048,%eax
  8028d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028d8:	74 07                	je     8028e1 <insert_sorted_allocList+0x266>
  8028da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028dd:	8b 00                	mov    (%eax),%eax
  8028df:	eb 05                	jmp    8028e6 <insert_sorted_allocList+0x26b>
  8028e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8028e6:	a3 48 50 80 00       	mov    %eax,0x805048
  8028eb:	a1 48 50 80 00       	mov    0x805048,%eax
  8028f0:	85 c0                	test   %eax,%eax
  8028f2:	0f 85 3f ff ff ff    	jne    802837 <insert_sorted_allocList+0x1bc>
  8028f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028fc:	0f 85 35 ff ff ff    	jne    802837 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802902:	eb 01                	jmp    802905 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802904:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802905:	90                   	nop
  802906:	c9                   	leave  
  802907:	c3                   	ret    

00802908 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802908:	55                   	push   %ebp
  802909:	89 e5                	mov    %esp,%ebp
  80290b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80290e:	a1 38 51 80 00       	mov    0x805138,%eax
  802913:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802916:	e9 85 01 00 00       	jmp    802aa0 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  80291b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291e:	8b 40 0c             	mov    0xc(%eax),%eax
  802921:	3b 45 08             	cmp    0x8(%ebp),%eax
  802924:	0f 82 6e 01 00 00    	jb     802a98 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80292a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292d:	8b 40 0c             	mov    0xc(%eax),%eax
  802930:	3b 45 08             	cmp    0x8(%ebp),%eax
  802933:	0f 85 8a 00 00 00    	jne    8029c3 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802939:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80293d:	75 17                	jne    802956 <alloc_block_FF+0x4e>
  80293f:	83 ec 04             	sub    $0x4,%esp
  802942:	68 5c 46 80 00       	push   $0x80465c
  802947:	68 93 00 00 00       	push   $0x93
  80294c:	68 b3 45 80 00       	push   $0x8045b3
  802951:	e8 d0 dd ff ff       	call   800726 <_panic>
  802956:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802959:	8b 00                	mov    (%eax),%eax
  80295b:	85 c0                	test   %eax,%eax
  80295d:	74 10                	je     80296f <alloc_block_FF+0x67>
  80295f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802962:	8b 00                	mov    (%eax),%eax
  802964:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802967:	8b 52 04             	mov    0x4(%edx),%edx
  80296a:	89 50 04             	mov    %edx,0x4(%eax)
  80296d:	eb 0b                	jmp    80297a <alloc_block_FF+0x72>
  80296f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802972:	8b 40 04             	mov    0x4(%eax),%eax
  802975:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80297a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297d:	8b 40 04             	mov    0x4(%eax),%eax
  802980:	85 c0                	test   %eax,%eax
  802982:	74 0f                	je     802993 <alloc_block_FF+0x8b>
  802984:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802987:	8b 40 04             	mov    0x4(%eax),%eax
  80298a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80298d:	8b 12                	mov    (%edx),%edx
  80298f:	89 10                	mov    %edx,(%eax)
  802991:	eb 0a                	jmp    80299d <alloc_block_FF+0x95>
  802993:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802996:	8b 00                	mov    (%eax),%eax
  802998:	a3 38 51 80 00       	mov    %eax,0x805138
  80299d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029b0:	a1 44 51 80 00       	mov    0x805144,%eax
  8029b5:	48                   	dec    %eax
  8029b6:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8029bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029be:	e9 10 01 00 00       	jmp    802ad3 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8029c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8029c9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029cc:	0f 86 c6 00 00 00    	jbe    802a98 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8029d2:	a1 48 51 80 00       	mov    0x805148,%eax
  8029d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8029da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029dd:	8b 50 08             	mov    0x8(%eax),%edx
  8029e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e3:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8029e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8029ec:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8029ef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029f3:	75 17                	jne    802a0c <alloc_block_FF+0x104>
  8029f5:	83 ec 04             	sub    $0x4,%esp
  8029f8:	68 5c 46 80 00       	push   $0x80465c
  8029fd:	68 9b 00 00 00       	push   $0x9b
  802a02:	68 b3 45 80 00       	push   $0x8045b3
  802a07:	e8 1a dd ff ff       	call   800726 <_panic>
  802a0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a0f:	8b 00                	mov    (%eax),%eax
  802a11:	85 c0                	test   %eax,%eax
  802a13:	74 10                	je     802a25 <alloc_block_FF+0x11d>
  802a15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a18:	8b 00                	mov    (%eax),%eax
  802a1a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a1d:	8b 52 04             	mov    0x4(%edx),%edx
  802a20:	89 50 04             	mov    %edx,0x4(%eax)
  802a23:	eb 0b                	jmp    802a30 <alloc_block_FF+0x128>
  802a25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a28:	8b 40 04             	mov    0x4(%eax),%eax
  802a2b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a33:	8b 40 04             	mov    0x4(%eax),%eax
  802a36:	85 c0                	test   %eax,%eax
  802a38:	74 0f                	je     802a49 <alloc_block_FF+0x141>
  802a3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a3d:	8b 40 04             	mov    0x4(%eax),%eax
  802a40:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a43:	8b 12                	mov    (%edx),%edx
  802a45:	89 10                	mov    %edx,(%eax)
  802a47:	eb 0a                	jmp    802a53 <alloc_block_FF+0x14b>
  802a49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a4c:	8b 00                	mov    (%eax),%eax
  802a4e:	a3 48 51 80 00       	mov    %eax,0x805148
  802a53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a56:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a5f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a66:	a1 54 51 80 00       	mov    0x805154,%eax
  802a6b:	48                   	dec    %eax
  802a6c:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a74:	8b 50 08             	mov    0x8(%eax),%edx
  802a77:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7a:	01 c2                	add    %eax,%edx
  802a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7f:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802a82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a85:	8b 40 0c             	mov    0xc(%eax),%eax
  802a88:	2b 45 08             	sub    0x8(%ebp),%eax
  802a8b:	89 c2                	mov    %eax,%edx
  802a8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a90:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802a93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a96:	eb 3b                	jmp    802ad3 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802a98:	a1 40 51 80 00       	mov    0x805140,%eax
  802a9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aa0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aa4:	74 07                	je     802aad <alloc_block_FF+0x1a5>
  802aa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa9:	8b 00                	mov    (%eax),%eax
  802aab:	eb 05                	jmp    802ab2 <alloc_block_FF+0x1aa>
  802aad:	b8 00 00 00 00       	mov    $0x0,%eax
  802ab2:	a3 40 51 80 00       	mov    %eax,0x805140
  802ab7:	a1 40 51 80 00       	mov    0x805140,%eax
  802abc:	85 c0                	test   %eax,%eax
  802abe:	0f 85 57 fe ff ff    	jne    80291b <alloc_block_FF+0x13>
  802ac4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ac8:	0f 85 4d fe ff ff    	jne    80291b <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802ace:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ad3:	c9                   	leave  
  802ad4:	c3                   	ret    

00802ad5 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802ad5:	55                   	push   %ebp
  802ad6:	89 e5                	mov    %esp,%ebp
  802ad8:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802adb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802ae2:	a1 38 51 80 00       	mov    0x805138,%eax
  802ae7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aea:	e9 df 00 00 00       	jmp    802bce <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af2:	8b 40 0c             	mov    0xc(%eax),%eax
  802af5:	3b 45 08             	cmp    0x8(%ebp),%eax
  802af8:	0f 82 c8 00 00 00    	jb     802bc6 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b01:	8b 40 0c             	mov    0xc(%eax),%eax
  802b04:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b07:	0f 85 8a 00 00 00    	jne    802b97 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802b0d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b11:	75 17                	jne    802b2a <alloc_block_BF+0x55>
  802b13:	83 ec 04             	sub    $0x4,%esp
  802b16:	68 5c 46 80 00       	push   $0x80465c
  802b1b:	68 b7 00 00 00       	push   $0xb7
  802b20:	68 b3 45 80 00       	push   $0x8045b3
  802b25:	e8 fc db ff ff       	call   800726 <_panic>
  802b2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2d:	8b 00                	mov    (%eax),%eax
  802b2f:	85 c0                	test   %eax,%eax
  802b31:	74 10                	je     802b43 <alloc_block_BF+0x6e>
  802b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b36:	8b 00                	mov    (%eax),%eax
  802b38:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b3b:	8b 52 04             	mov    0x4(%edx),%edx
  802b3e:	89 50 04             	mov    %edx,0x4(%eax)
  802b41:	eb 0b                	jmp    802b4e <alloc_block_BF+0x79>
  802b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b46:	8b 40 04             	mov    0x4(%eax),%eax
  802b49:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b51:	8b 40 04             	mov    0x4(%eax),%eax
  802b54:	85 c0                	test   %eax,%eax
  802b56:	74 0f                	je     802b67 <alloc_block_BF+0x92>
  802b58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5b:	8b 40 04             	mov    0x4(%eax),%eax
  802b5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b61:	8b 12                	mov    (%edx),%edx
  802b63:	89 10                	mov    %edx,(%eax)
  802b65:	eb 0a                	jmp    802b71 <alloc_block_BF+0x9c>
  802b67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6a:	8b 00                	mov    (%eax),%eax
  802b6c:	a3 38 51 80 00       	mov    %eax,0x805138
  802b71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b74:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b84:	a1 44 51 80 00       	mov    0x805144,%eax
  802b89:	48                   	dec    %eax
  802b8a:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b92:	e9 4d 01 00 00       	jmp    802ce4 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802b97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9a:	8b 40 0c             	mov    0xc(%eax),%eax
  802b9d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ba0:	76 24                	jbe    802bc6 <alloc_block_BF+0xf1>
  802ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ba8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802bab:	73 19                	jae    802bc6 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802bad:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb7:	8b 40 0c             	mov    0xc(%eax),%eax
  802bba:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802bbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc0:	8b 40 08             	mov    0x8(%eax),%eax
  802bc3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802bc6:	a1 40 51 80 00       	mov    0x805140,%eax
  802bcb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bd2:	74 07                	je     802bdb <alloc_block_BF+0x106>
  802bd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd7:	8b 00                	mov    (%eax),%eax
  802bd9:	eb 05                	jmp    802be0 <alloc_block_BF+0x10b>
  802bdb:	b8 00 00 00 00       	mov    $0x0,%eax
  802be0:	a3 40 51 80 00       	mov    %eax,0x805140
  802be5:	a1 40 51 80 00       	mov    0x805140,%eax
  802bea:	85 c0                	test   %eax,%eax
  802bec:	0f 85 fd fe ff ff    	jne    802aef <alloc_block_BF+0x1a>
  802bf2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bf6:	0f 85 f3 fe ff ff    	jne    802aef <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802bfc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802c00:	0f 84 d9 00 00 00    	je     802cdf <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802c06:	a1 48 51 80 00       	mov    0x805148,%eax
  802c0b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802c0e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c11:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c14:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802c17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c1a:	8b 55 08             	mov    0x8(%ebp),%edx
  802c1d:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802c20:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802c24:	75 17                	jne    802c3d <alloc_block_BF+0x168>
  802c26:	83 ec 04             	sub    $0x4,%esp
  802c29:	68 5c 46 80 00       	push   $0x80465c
  802c2e:	68 c7 00 00 00       	push   $0xc7
  802c33:	68 b3 45 80 00       	push   $0x8045b3
  802c38:	e8 e9 da ff ff       	call   800726 <_panic>
  802c3d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c40:	8b 00                	mov    (%eax),%eax
  802c42:	85 c0                	test   %eax,%eax
  802c44:	74 10                	je     802c56 <alloc_block_BF+0x181>
  802c46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c49:	8b 00                	mov    (%eax),%eax
  802c4b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c4e:	8b 52 04             	mov    0x4(%edx),%edx
  802c51:	89 50 04             	mov    %edx,0x4(%eax)
  802c54:	eb 0b                	jmp    802c61 <alloc_block_BF+0x18c>
  802c56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c59:	8b 40 04             	mov    0x4(%eax),%eax
  802c5c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c64:	8b 40 04             	mov    0x4(%eax),%eax
  802c67:	85 c0                	test   %eax,%eax
  802c69:	74 0f                	je     802c7a <alloc_block_BF+0x1a5>
  802c6b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c6e:	8b 40 04             	mov    0x4(%eax),%eax
  802c71:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c74:	8b 12                	mov    (%edx),%edx
  802c76:	89 10                	mov    %edx,(%eax)
  802c78:	eb 0a                	jmp    802c84 <alloc_block_BF+0x1af>
  802c7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c7d:	8b 00                	mov    (%eax),%eax
  802c7f:	a3 48 51 80 00       	mov    %eax,0x805148
  802c84:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c87:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c90:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c97:	a1 54 51 80 00       	mov    0x805154,%eax
  802c9c:	48                   	dec    %eax
  802c9d:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802ca2:	83 ec 08             	sub    $0x8,%esp
  802ca5:	ff 75 ec             	pushl  -0x14(%ebp)
  802ca8:	68 38 51 80 00       	push   $0x805138
  802cad:	e8 71 f9 ff ff       	call   802623 <find_block>
  802cb2:	83 c4 10             	add    $0x10,%esp
  802cb5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802cb8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cbb:	8b 50 08             	mov    0x8(%eax),%edx
  802cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc1:	01 c2                	add    %eax,%edx
  802cc3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cc6:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802cc9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ccc:	8b 40 0c             	mov    0xc(%eax),%eax
  802ccf:	2b 45 08             	sub    0x8(%ebp),%eax
  802cd2:	89 c2                	mov    %eax,%edx
  802cd4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cd7:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802cda:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cdd:	eb 05                	jmp    802ce4 <alloc_block_BF+0x20f>
	}
	return NULL;
  802cdf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ce4:	c9                   	leave  
  802ce5:	c3                   	ret    

00802ce6 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802ce6:	55                   	push   %ebp
  802ce7:	89 e5                	mov    %esp,%ebp
  802ce9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802cec:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802cf1:	85 c0                	test   %eax,%eax
  802cf3:	0f 85 de 01 00 00    	jne    802ed7 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802cf9:	a1 38 51 80 00       	mov    0x805138,%eax
  802cfe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d01:	e9 9e 01 00 00       	jmp    802ea4 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802d06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d09:	8b 40 0c             	mov    0xc(%eax),%eax
  802d0c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d0f:	0f 82 87 01 00 00    	jb     802e9c <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802d15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d18:	8b 40 0c             	mov    0xc(%eax),%eax
  802d1b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d1e:	0f 85 95 00 00 00    	jne    802db9 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802d24:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d28:	75 17                	jne    802d41 <alloc_block_NF+0x5b>
  802d2a:	83 ec 04             	sub    $0x4,%esp
  802d2d:	68 5c 46 80 00       	push   $0x80465c
  802d32:	68 e0 00 00 00       	push   $0xe0
  802d37:	68 b3 45 80 00       	push   $0x8045b3
  802d3c:	e8 e5 d9 ff ff       	call   800726 <_panic>
  802d41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d44:	8b 00                	mov    (%eax),%eax
  802d46:	85 c0                	test   %eax,%eax
  802d48:	74 10                	je     802d5a <alloc_block_NF+0x74>
  802d4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4d:	8b 00                	mov    (%eax),%eax
  802d4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d52:	8b 52 04             	mov    0x4(%edx),%edx
  802d55:	89 50 04             	mov    %edx,0x4(%eax)
  802d58:	eb 0b                	jmp    802d65 <alloc_block_NF+0x7f>
  802d5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5d:	8b 40 04             	mov    0x4(%eax),%eax
  802d60:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d68:	8b 40 04             	mov    0x4(%eax),%eax
  802d6b:	85 c0                	test   %eax,%eax
  802d6d:	74 0f                	je     802d7e <alloc_block_NF+0x98>
  802d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d72:	8b 40 04             	mov    0x4(%eax),%eax
  802d75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d78:	8b 12                	mov    (%edx),%edx
  802d7a:	89 10                	mov    %edx,(%eax)
  802d7c:	eb 0a                	jmp    802d88 <alloc_block_NF+0xa2>
  802d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d81:	8b 00                	mov    (%eax),%eax
  802d83:	a3 38 51 80 00       	mov    %eax,0x805138
  802d88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d94:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d9b:	a1 44 51 80 00       	mov    0x805144,%eax
  802da0:	48                   	dec    %eax
  802da1:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802da6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da9:	8b 40 08             	mov    0x8(%eax),%eax
  802dac:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   return  point;
  802db1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db4:	e9 f8 04 00 00       	jmp    8032b1 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbc:	8b 40 0c             	mov    0xc(%eax),%eax
  802dbf:	3b 45 08             	cmp    0x8(%ebp),%eax
  802dc2:	0f 86 d4 00 00 00    	jbe    802e9c <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802dc8:	a1 48 51 80 00       	mov    0x805148,%eax
  802dcd:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802dd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd3:	8b 50 08             	mov    0x8(%eax),%edx
  802dd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd9:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802ddc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ddf:	8b 55 08             	mov    0x8(%ebp),%edx
  802de2:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802de5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802de9:	75 17                	jne    802e02 <alloc_block_NF+0x11c>
  802deb:	83 ec 04             	sub    $0x4,%esp
  802dee:	68 5c 46 80 00       	push   $0x80465c
  802df3:	68 e9 00 00 00       	push   $0xe9
  802df8:	68 b3 45 80 00       	push   $0x8045b3
  802dfd:	e8 24 d9 ff ff       	call   800726 <_panic>
  802e02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e05:	8b 00                	mov    (%eax),%eax
  802e07:	85 c0                	test   %eax,%eax
  802e09:	74 10                	je     802e1b <alloc_block_NF+0x135>
  802e0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e0e:	8b 00                	mov    (%eax),%eax
  802e10:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e13:	8b 52 04             	mov    0x4(%edx),%edx
  802e16:	89 50 04             	mov    %edx,0x4(%eax)
  802e19:	eb 0b                	jmp    802e26 <alloc_block_NF+0x140>
  802e1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e1e:	8b 40 04             	mov    0x4(%eax),%eax
  802e21:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e29:	8b 40 04             	mov    0x4(%eax),%eax
  802e2c:	85 c0                	test   %eax,%eax
  802e2e:	74 0f                	je     802e3f <alloc_block_NF+0x159>
  802e30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e33:	8b 40 04             	mov    0x4(%eax),%eax
  802e36:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e39:	8b 12                	mov    (%edx),%edx
  802e3b:	89 10                	mov    %edx,(%eax)
  802e3d:	eb 0a                	jmp    802e49 <alloc_block_NF+0x163>
  802e3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e42:	8b 00                	mov    (%eax),%eax
  802e44:	a3 48 51 80 00       	mov    %eax,0x805148
  802e49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e4c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e55:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e5c:	a1 54 51 80 00       	mov    0x805154,%eax
  802e61:	48                   	dec    %eax
  802e62:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802e67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e6a:	8b 40 08             	mov    0x8(%eax),%eax
  802e6d:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   point->sva += size;
  802e72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e75:	8b 50 08             	mov    0x8(%eax),%edx
  802e78:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7b:	01 c2                	add    %eax,%edx
  802e7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e80:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802e83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e86:	8b 40 0c             	mov    0xc(%eax),%eax
  802e89:	2b 45 08             	sub    0x8(%ebp),%eax
  802e8c:	89 c2                	mov    %eax,%edx
  802e8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e91:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802e94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e97:	e9 15 04 00 00       	jmp    8032b1 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802e9c:	a1 40 51 80 00       	mov    0x805140,%eax
  802ea1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ea4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ea8:	74 07                	je     802eb1 <alloc_block_NF+0x1cb>
  802eaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ead:	8b 00                	mov    (%eax),%eax
  802eaf:	eb 05                	jmp    802eb6 <alloc_block_NF+0x1d0>
  802eb1:	b8 00 00 00 00       	mov    $0x0,%eax
  802eb6:	a3 40 51 80 00       	mov    %eax,0x805140
  802ebb:	a1 40 51 80 00       	mov    0x805140,%eax
  802ec0:	85 c0                	test   %eax,%eax
  802ec2:	0f 85 3e fe ff ff    	jne    802d06 <alloc_block_NF+0x20>
  802ec8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ecc:	0f 85 34 fe ff ff    	jne    802d06 <alloc_block_NF+0x20>
  802ed2:	e9 d5 03 00 00       	jmp    8032ac <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802ed7:	a1 38 51 80 00       	mov    0x805138,%eax
  802edc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802edf:	e9 b1 01 00 00       	jmp    803095 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802ee4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee7:	8b 50 08             	mov    0x8(%eax),%edx
  802eea:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802eef:	39 c2                	cmp    %eax,%edx
  802ef1:	0f 82 96 01 00 00    	jb     80308d <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802ef7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efa:	8b 40 0c             	mov    0xc(%eax),%eax
  802efd:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f00:	0f 82 87 01 00 00    	jb     80308d <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802f06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f09:	8b 40 0c             	mov    0xc(%eax),%eax
  802f0c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f0f:	0f 85 95 00 00 00    	jne    802faa <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802f15:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f19:	75 17                	jne    802f32 <alloc_block_NF+0x24c>
  802f1b:	83 ec 04             	sub    $0x4,%esp
  802f1e:	68 5c 46 80 00       	push   $0x80465c
  802f23:	68 fc 00 00 00       	push   $0xfc
  802f28:	68 b3 45 80 00       	push   $0x8045b3
  802f2d:	e8 f4 d7 ff ff       	call   800726 <_panic>
  802f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f35:	8b 00                	mov    (%eax),%eax
  802f37:	85 c0                	test   %eax,%eax
  802f39:	74 10                	je     802f4b <alloc_block_NF+0x265>
  802f3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3e:	8b 00                	mov    (%eax),%eax
  802f40:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f43:	8b 52 04             	mov    0x4(%edx),%edx
  802f46:	89 50 04             	mov    %edx,0x4(%eax)
  802f49:	eb 0b                	jmp    802f56 <alloc_block_NF+0x270>
  802f4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4e:	8b 40 04             	mov    0x4(%eax),%eax
  802f51:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f59:	8b 40 04             	mov    0x4(%eax),%eax
  802f5c:	85 c0                	test   %eax,%eax
  802f5e:	74 0f                	je     802f6f <alloc_block_NF+0x289>
  802f60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f63:	8b 40 04             	mov    0x4(%eax),%eax
  802f66:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f69:	8b 12                	mov    (%edx),%edx
  802f6b:	89 10                	mov    %edx,(%eax)
  802f6d:	eb 0a                	jmp    802f79 <alloc_block_NF+0x293>
  802f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f72:	8b 00                	mov    (%eax),%eax
  802f74:	a3 38 51 80 00       	mov    %eax,0x805138
  802f79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f85:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f8c:	a1 44 51 80 00       	mov    0x805144,%eax
  802f91:	48                   	dec    %eax
  802f92:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802f97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9a:	8b 40 08             	mov    0x8(%eax),%eax
  802f9d:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  802fa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa5:	e9 07 03 00 00       	jmp    8032b1 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802faa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fad:	8b 40 0c             	mov    0xc(%eax),%eax
  802fb0:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fb3:	0f 86 d4 00 00 00    	jbe    80308d <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802fb9:	a1 48 51 80 00       	mov    0x805148,%eax
  802fbe:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc4:	8b 50 08             	mov    0x8(%eax),%edx
  802fc7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fca:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802fcd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fd0:	8b 55 08             	mov    0x8(%ebp),%edx
  802fd3:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802fd6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fda:	75 17                	jne    802ff3 <alloc_block_NF+0x30d>
  802fdc:	83 ec 04             	sub    $0x4,%esp
  802fdf:	68 5c 46 80 00       	push   $0x80465c
  802fe4:	68 04 01 00 00       	push   $0x104
  802fe9:	68 b3 45 80 00       	push   $0x8045b3
  802fee:	e8 33 d7 ff ff       	call   800726 <_panic>
  802ff3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff6:	8b 00                	mov    (%eax),%eax
  802ff8:	85 c0                	test   %eax,%eax
  802ffa:	74 10                	je     80300c <alloc_block_NF+0x326>
  802ffc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fff:	8b 00                	mov    (%eax),%eax
  803001:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803004:	8b 52 04             	mov    0x4(%edx),%edx
  803007:	89 50 04             	mov    %edx,0x4(%eax)
  80300a:	eb 0b                	jmp    803017 <alloc_block_NF+0x331>
  80300c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80300f:	8b 40 04             	mov    0x4(%eax),%eax
  803012:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803017:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80301a:	8b 40 04             	mov    0x4(%eax),%eax
  80301d:	85 c0                	test   %eax,%eax
  80301f:	74 0f                	je     803030 <alloc_block_NF+0x34a>
  803021:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803024:	8b 40 04             	mov    0x4(%eax),%eax
  803027:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80302a:	8b 12                	mov    (%edx),%edx
  80302c:	89 10                	mov    %edx,(%eax)
  80302e:	eb 0a                	jmp    80303a <alloc_block_NF+0x354>
  803030:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803033:	8b 00                	mov    (%eax),%eax
  803035:	a3 48 51 80 00       	mov    %eax,0x805148
  80303a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80303d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803043:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803046:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80304d:	a1 54 51 80 00       	mov    0x805154,%eax
  803052:	48                   	dec    %eax
  803053:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803058:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80305b:	8b 40 08             	mov    0x8(%eax),%eax
  80305e:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  803063:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803066:	8b 50 08             	mov    0x8(%eax),%edx
  803069:	8b 45 08             	mov    0x8(%ebp),%eax
  80306c:	01 c2                	add    %eax,%edx
  80306e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803071:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803074:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803077:	8b 40 0c             	mov    0xc(%eax),%eax
  80307a:	2b 45 08             	sub    0x8(%ebp),%eax
  80307d:	89 c2                	mov    %eax,%edx
  80307f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803082:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803085:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803088:	e9 24 02 00 00       	jmp    8032b1 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80308d:	a1 40 51 80 00       	mov    0x805140,%eax
  803092:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803095:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803099:	74 07                	je     8030a2 <alloc_block_NF+0x3bc>
  80309b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309e:	8b 00                	mov    (%eax),%eax
  8030a0:	eb 05                	jmp    8030a7 <alloc_block_NF+0x3c1>
  8030a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8030a7:	a3 40 51 80 00       	mov    %eax,0x805140
  8030ac:	a1 40 51 80 00       	mov    0x805140,%eax
  8030b1:	85 c0                	test   %eax,%eax
  8030b3:	0f 85 2b fe ff ff    	jne    802ee4 <alloc_block_NF+0x1fe>
  8030b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030bd:	0f 85 21 fe ff ff    	jne    802ee4 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8030c3:	a1 38 51 80 00       	mov    0x805138,%eax
  8030c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030cb:	e9 ae 01 00 00       	jmp    80327e <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8030d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d3:	8b 50 08             	mov    0x8(%eax),%edx
  8030d6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030db:	39 c2                	cmp    %eax,%edx
  8030dd:	0f 83 93 01 00 00    	jae    803276 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  8030e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e6:	8b 40 0c             	mov    0xc(%eax),%eax
  8030e9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030ec:	0f 82 84 01 00 00    	jb     803276 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  8030f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8030f8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030fb:	0f 85 95 00 00 00    	jne    803196 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803101:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803105:	75 17                	jne    80311e <alloc_block_NF+0x438>
  803107:	83 ec 04             	sub    $0x4,%esp
  80310a:	68 5c 46 80 00       	push   $0x80465c
  80310f:	68 14 01 00 00       	push   $0x114
  803114:	68 b3 45 80 00       	push   $0x8045b3
  803119:	e8 08 d6 ff ff       	call   800726 <_panic>
  80311e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803121:	8b 00                	mov    (%eax),%eax
  803123:	85 c0                	test   %eax,%eax
  803125:	74 10                	je     803137 <alloc_block_NF+0x451>
  803127:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312a:	8b 00                	mov    (%eax),%eax
  80312c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80312f:	8b 52 04             	mov    0x4(%edx),%edx
  803132:	89 50 04             	mov    %edx,0x4(%eax)
  803135:	eb 0b                	jmp    803142 <alloc_block_NF+0x45c>
  803137:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313a:	8b 40 04             	mov    0x4(%eax),%eax
  80313d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803142:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803145:	8b 40 04             	mov    0x4(%eax),%eax
  803148:	85 c0                	test   %eax,%eax
  80314a:	74 0f                	je     80315b <alloc_block_NF+0x475>
  80314c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314f:	8b 40 04             	mov    0x4(%eax),%eax
  803152:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803155:	8b 12                	mov    (%edx),%edx
  803157:	89 10                	mov    %edx,(%eax)
  803159:	eb 0a                	jmp    803165 <alloc_block_NF+0x47f>
  80315b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315e:	8b 00                	mov    (%eax),%eax
  803160:	a3 38 51 80 00       	mov    %eax,0x805138
  803165:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803168:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80316e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803171:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803178:	a1 44 51 80 00       	mov    0x805144,%eax
  80317d:	48                   	dec    %eax
  80317e:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803183:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803186:	8b 40 08             	mov    0x8(%eax),%eax
  803189:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  80318e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803191:	e9 1b 01 00 00       	jmp    8032b1 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803196:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803199:	8b 40 0c             	mov    0xc(%eax),%eax
  80319c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80319f:	0f 86 d1 00 00 00    	jbe    803276 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8031a5:	a1 48 51 80 00       	mov    0x805148,%eax
  8031aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  8031ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b0:	8b 50 08             	mov    0x8(%eax),%edx
  8031b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031b6:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8031b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8031bf:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8031c2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8031c6:	75 17                	jne    8031df <alloc_block_NF+0x4f9>
  8031c8:	83 ec 04             	sub    $0x4,%esp
  8031cb:	68 5c 46 80 00       	push   $0x80465c
  8031d0:	68 1c 01 00 00       	push   $0x11c
  8031d5:	68 b3 45 80 00       	push   $0x8045b3
  8031da:	e8 47 d5 ff ff       	call   800726 <_panic>
  8031df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031e2:	8b 00                	mov    (%eax),%eax
  8031e4:	85 c0                	test   %eax,%eax
  8031e6:	74 10                	je     8031f8 <alloc_block_NF+0x512>
  8031e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031eb:	8b 00                	mov    (%eax),%eax
  8031ed:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8031f0:	8b 52 04             	mov    0x4(%edx),%edx
  8031f3:	89 50 04             	mov    %edx,0x4(%eax)
  8031f6:	eb 0b                	jmp    803203 <alloc_block_NF+0x51d>
  8031f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031fb:	8b 40 04             	mov    0x4(%eax),%eax
  8031fe:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803203:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803206:	8b 40 04             	mov    0x4(%eax),%eax
  803209:	85 c0                	test   %eax,%eax
  80320b:	74 0f                	je     80321c <alloc_block_NF+0x536>
  80320d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803210:	8b 40 04             	mov    0x4(%eax),%eax
  803213:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803216:	8b 12                	mov    (%edx),%edx
  803218:	89 10                	mov    %edx,(%eax)
  80321a:	eb 0a                	jmp    803226 <alloc_block_NF+0x540>
  80321c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80321f:	8b 00                	mov    (%eax),%eax
  803221:	a3 48 51 80 00       	mov    %eax,0x805148
  803226:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803229:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80322f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803232:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803239:	a1 54 51 80 00       	mov    0x805154,%eax
  80323e:	48                   	dec    %eax
  80323f:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803244:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803247:	8b 40 08             	mov    0x8(%eax),%eax
  80324a:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  80324f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803252:	8b 50 08             	mov    0x8(%eax),%edx
  803255:	8b 45 08             	mov    0x8(%ebp),%eax
  803258:	01 c2                	add    %eax,%edx
  80325a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325d:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803260:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803263:	8b 40 0c             	mov    0xc(%eax),%eax
  803266:	2b 45 08             	sub    0x8(%ebp),%eax
  803269:	89 c2                	mov    %eax,%edx
  80326b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326e:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803271:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803274:	eb 3b                	jmp    8032b1 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803276:	a1 40 51 80 00       	mov    0x805140,%eax
  80327b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80327e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803282:	74 07                	je     80328b <alloc_block_NF+0x5a5>
  803284:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803287:	8b 00                	mov    (%eax),%eax
  803289:	eb 05                	jmp    803290 <alloc_block_NF+0x5aa>
  80328b:	b8 00 00 00 00       	mov    $0x0,%eax
  803290:	a3 40 51 80 00       	mov    %eax,0x805140
  803295:	a1 40 51 80 00       	mov    0x805140,%eax
  80329a:	85 c0                	test   %eax,%eax
  80329c:	0f 85 2e fe ff ff    	jne    8030d0 <alloc_block_NF+0x3ea>
  8032a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032a6:	0f 85 24 fe ff ff    	jne    8030d0 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  8032ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8032b1:	c9                   	leave  
  8032b2:	c3                   	ret    

008032b3 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8032b3:	55                   	push   %ebp
  8032b4:	89 e5                	mov    %esp,%ebp
  8032b6:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  8032b9:	a1 38 51 80 00       	mov    0x805138,%eax
  8032be:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  8032c1:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8032c6:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  8032c9:	a1 38 51 80 00       	mov    0x805138,%eax
  8032ce:	85 c0                	test   %eax,%eax
  8032d0:	74 14                	je     8032e6 <insert_sorted_with_merge_freeList+0x33>
  8032d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d5:	8b 50 08             	mov    0x8(%eax),%edx
  8032d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032db:	8b 40 08             	mov    0x8(%eax),%eax
  8032de:	39 c2                	cmp    %eax,%edx
  8032e0:	0f 87 9b 01 00 00    	ja     803481 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  8032e6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032ea:	75 17                	jne    803303 <insert_sorted_with_merge_freeList+0x50>
  8032ec:	83 ec 04             	sub    $0x4,%esp
  8032ef:	68 90 45 80 00       	push   $0x804590
  8032f4:	68 38 01 00 00       	push   $0x138
  8032f9:	68 b3 45 80 00       	push   $0x8045b3
  8032fe:	e8 23 d4 ff ff       	call   800726 <_panic>
  803303:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803309:	8b 45 08             	mov    0x8(%ebp),%eax
  80330c:	89 10                	mov    %edx,(%eax)
  80330e:	8b 45 08             	mov    0x8(%ebp),%eax
  803311:	8b 00                	mov    (%eax),%eax
  803313:	85 c0                	test   %eax,%eax
  803315:	74 0d                	je     803324 <insert_sorted_with_merge_freeList+0x71>
  803317:	a1 38 51 80 00       	mov    0x805138,%eax
  80331c:	8b 55 08             	mov    0x8(%ebp),%edx
  80331f:	89 50 04             	mov    %edx,0x4(%eax)
  803322:	eb 08                	jmp    80332c <insert_sorted_with_merge_freeList+0x79>
  803324:	8b 45 08             	mov    0x8(%ebp),%eax
  803327:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80332c:	8b 45 08             	mov    0x8(%ebp),%eax
  80332f:	a3 38 51 80 00       	mov    %eax,0x805138
  803334:	8b 45 08             	mov    0x8(%ebp),%eax
  803337:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80333e:	a1 44 51 80 00       	mov    0x805144,%eax
  803343:	40                   	inc    %eax
  803344:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803349:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80334d:	0f 84 a8 06 00 00    	je     8039fb <insert_sorted_with_merge_freeList+0x748>
  803353:	8b 45 08             	mov    0x8(%ebp),%eax
  803356:	8b 50 08             	mov    0x8(%eax),%edx
  803359:	8b 45 08             	mov    0x8(%ebp),%eax
  80335c:	8b 40 0c             	mov    0xc(%eax),%eax
  80335f:	01 c2                	add    %eax,%edx
  803361:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803364:	8b 40 08             	mov    0x8(%eax),%eax
  803367:	39 c2                	cmp    %eax,%edx
  803369:	0f 85 8c 06 00 00    	jne    8039fb <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  80336f:	8b 45 08             	mov    0x8(%ebp),%eax
  803372:	8b 50 0c             	mov    0xc(%eax),%edx
  803375:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803378:	8b 40 0c             	mov    0xc(%eax),%eax
  80337b:	01 c2                	add    %eax,%edx
  80337d:	8b 45 08             	mov    0x8(%ebp),%eax
  803380:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803383:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803387:	75 17                	jne    8033a0 <insert_sorted_with_merge_freeList+0xed>
  803389:	83 ec 04             	sub    $0x4,%esp
  80338c:	68 5c 46 80 00       	push   $0x80465c
  803391:	68 3c 01 00 00       	push   $0x13c
  803396:	68 b3 45 80 00       	push   $0x8045b3
  80339b:	e8 86 d3 ff ff       	call   800726 <_panic>
  8033a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033a3:	8b 00                	mov    (%eax),%eax
  8033a5:	85 c0                	test   %eax,%eax
  8033a7:	74 10                	je     8033b9 <insert_sorted_with_merge_freeList+0x106>
  8033a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ac:	8b 00                	mov    (%eax),%eax
  8033ae:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033b1:	8b 52 04             	mov    0x4(%edx),%edx
  8033b4:	89 50 04             	mov    %edx,0x4(%eax)
  8033b7:	eb 0b                	jmp    8033c4 <insert_sorted_with_merge_freeList+0x111>
  8033b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033bc:	8b 40 04             	mov    0x4(%eax),%eax
  8033bf:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033c7:	8b 40 04             	mov    0x4(%eax),%eax
  8033ca:	85 c0                	test   %eax,%eax
  8033cc:	74 0f                	je     8033dd <insert_sorted_with_merge_freeList+0x12a>
  8033ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033d1:	8b 40 04             	mov    0x4(%eax),%eax
  8033d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033d7:	8b 12                	mov    (%edx),%edx
  8033d9:	89 10                	mov    %edx,(%eax)
  8033db:	eb 0a                	jmp    8033e7 <insert_sorted_with_merge_freeList+0x134>
  8033dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033e0:	8b 00                	mov    (%eax),%eax
  8033e2:	a3 38 51 80 00       	mov    %eax,0x805138
  8033e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033fa:	a1 44 51 80 00       	mov    0x805144,%eax
  8033ff:	48                   	dec    %eax
  803400:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  803405:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803408:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  80340f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803412:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803419:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80341d:	75 17                	jne    803436 <insert_sorted_with_merge_freeList+0x183>
  80341f:	83 ec 04             	sub    $0x4,%esp
  803422:	68 90 45 80 00       	push   $0x804590
  803427:	68 3f 01 00 00       	push   $0x13f
  80342c:	68 b3 45 80 00       	push   $0x8045b3
  803431:	e8 f0 d2 ff ff       	call   800726 <_panic>
  803436:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80343c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80343f:	89 10                	mov    %edx,(%eax)
  803441:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803444:	8b 00                	mov    (%eax),%eax
  803446:	85 c0                	test   %eax,%eax
  803448:	74 0d                	je     803457 <insert_sorted_with_merge_freeList+0x1a4>
  80344a:	a1 48 51 80 00       	mov    0x805148,%eax
  80344f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803452:	89 50 04             	mov    %edx,0x4(%eax)
  803455:	eb 08                	jmp    80345f <insert_sorted_with_merge_freeList+0x1ac>
  803457:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80345a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80345f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803462:	a3 48 51 80 00       	mov    %eax,0x805148
  803467:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80346a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803471:	a1 54 51 80 00       	mov    0x805154,%eax
  803476:	40                   	inc    %eax
  803477:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80347c:	e9 7a 05 00 00       	jmp    8039fb <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803481:	8b 45 08             	mov    0x8(%ebp),%eax
  803484:	8b 50 08             	mov    0x8(%eax),%edx
  803487:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80348a:	8b 40 08             	mov    0x8(%eax),%eax
  80348d:	39 c2                	cmp    %eax,%edx
  80348f:	0f 82 14 01 00 00    	jb     8035a9 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803495:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803498:	8b 50 08             	mov    0x8(%eax),%edx
  80349b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80349e:	8b 40 0c             	mov    0xc(%eax),%eax
  8034a1:	01 c2                	add    %eax,%edx
  8034a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a6:	8b 40 08             	mov    0x8(%eax),%eax
  8034a9:	39 c2                	cmp    %eax,%edx
  8034ab:	0f 85 90 00 00 00    	jne    803541 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8034b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034b4:	8b 50 0c             	mov    0xc(%eax),%edx
  8034b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8034bd:	01 c2                	add    %eax,%edx
  8034bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034c2:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  8034c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8034cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8034d9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034dd:	75 17                	jne    8034f6 <insert_sorted_with_merge_freeList+0x243>
  8034df:	83 ec 04             	sub    $0x4,%esp
  8034e2:	68 90 45 80 00       	push   $0x804590
  8034e7:	68 49 01 00 00       	push   $0x149
  8034ec:	68 b3 45 80 00       	push   $0x8045b3
  8034f1:	e8 30 d2 ff ff       	call   800726 <_panic>
  8034f6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ff:	89 10                	mov    %edx,(%eax)
  803501:	8b 45 08             	mov    0x8(%ebp),%eax
  803504:	8b 00                	mov    (%eax),%eax
  803506:	85 c0                	test   %eax,%eax
  803508:	74 0d                	je     803517 <insert_sorted_with_merge_freeList+0x264>
  80350a:	a1 48 51 80 00       	mov    0x805148,%eax
  80350f:	8b 55 08             	mov    0x8(%ebp),%edx
  803512:	89 50 04             	mov    %edx,0x4(%eax)
  803515:	eb 08                	jmp    80351f <insert_sorted_with_merge_freeList+0x26c>
  803517:	8b 45 08             	mov    0x8(%ebp),%eax
  80351a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80351f:	8b 45 08             	mov    0x8(%ebp),%eax
  803522:	a3 48 51 80 00       	mov    %eax,0x805148
  803527:	8b 45 08             	mov    0x8(%ebp),%eax
  80352a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803531:	a1 54 51 80 00       	mov    0x805154,%eax
  803536:	40                   	inc    %eax
  803537:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80353c:	e9 bb 04 00 00       	jmp    8039fc <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803541:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803545:	75 17                	jne    80355e <insert_sorted_with_merge_freeList+0x2ab>
  803547:	83 ec 04             	sub    $0x4,%esp
  80354a:	68 04 46 80 00       	push   $0x804604
  80354f:	68 4c 01 00 00       	push   $0x14c
  803554:	68 b3 45 80 00       	push   $0x8045b3
  803559:	e8 c8 d1 ff ff       	call   800726 <_panic>
  80355e:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803564:	8b 45 08             	mov    0x8(%ebp),%eax
  803567:	89 50 04             	mov    %edx,0x4(%eax)
  80356a:	8b 45 08             	mov    0x8(%ebp),%eax
  80356d:	8b 40 04             	mov    0x4(%eax),%eax
  803570:	85 c0                	test   %eax,%eax
  803572:	74 0c                	je     803580 <insert_sorted_with_merge_freeList+0x2cd>
  803574:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803579:	8b 55 08             	mov    0x8(%ebp),%edx
  80357c:	89 10                	mov    %edx,(%eax)
  80357e:	eb 08                	jmp    803588 <insert_sorted_with_merge_freeList+0x2d5>
  803580:	8b 45 08             	mov    0x8(%ebp),%eax
  803583:	a3 38 51 80 00       	mov    %eax,0x805138
  803588:	8b 45 08             	mov    0x8(%ebp),%eax
  80358b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803590:	8b 45 08             	mov    0x8(%ebp),%eax
  803593:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803599:	a1 44 51 80 00       	mov    0x805144,%eax
  80359e:	40                   	inc    %eax
  80359f:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8035a4:	e9 53 04 00 00       	jmp    8039fc <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8035a9:	a1 38 51 80 00       	mov    0x805138,%eax
  8035ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035b1:	e9 15 04 00 00       	jmp    8039cb <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8035b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b9:	8b 00                	mov    (%eax),%eax
  8035bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8035be:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c1:	8b 50 08             	mov    0x8(%eax),%edx
  8035c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c7:	8b 40 08             	mov    0x8(%eax),%eax
  8035ca:	39 c2                	cmp    %eax,%edx
  8035cc:	0f 86 f1 03 00 00    	jbe    8039c3 <insert_sorted_with_merge_freeList+0x710>
  8035d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d5:	8b 50 08             	mov    0x8(%eax),%edx
  8035d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035db:	8b 40 08             	mov    0x8(%eax),%eax
  8035de:	39 c2                	cmp    %eax,%edx
  8035e0:	0f 83 dd 03 00 00    	jae    8039c3 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8035e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e9:	8b 50 08             	mov    0x8(%eax),%edx
  8035ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8035f2:	01 c2                	add    %eax,%edx
  8035f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f7:	8b 40 08             	mov    0x8(%eax),%eax
  8035fa:	39 c2                	cmp    %eax,%edx
  8035fc:	0f 85 b9 01 00 00    	jne    8037bb <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803602:	8b 45 08             	mov    0x8(%ebp),%eax
  803605:	8b 50 08             	mov    0x8(%eax),%edx
  803608:	8b 45 08             	mov    0x8(%ebp),%eax
  80360b:	8b 40 0c             	mov    0xc(%eax),%eax
  80360e:	01 c2                	add    %eax,%edx
  803610:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803613:	8b 40 08             	mov    0x8(%eax),%eax
  803616:	39 c2                	cmp    %eax,%edx
  803618:	0f 85 0d 01 00 00    	jne    80372b <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  80361e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803621:	8b 50 0c             	mov    0xc(%eax),%edx
  803624:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803627:	8b 40 0c             	mov    0xc(%eax),%eax
  80362a:	01 c2                	add    %eax,%edx
  80362c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80362f:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803632:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803636:	75 17                	jne    80364f <insert_sorted_with_merge_freeList+0x39c>
  803638:	83 ec 04             	sub    $0x4,%esp
  80363b:	68 5c 46 80 00       	push   $0x80465c
  803640:	68 5c 01 00 00       	push   $0x15c
  803645:	68 b3 45 80 00       	push   $0x8045b3
  80364a:	e8 d7 d0 ff ff       	call   800726 <_panic>
  80364f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803652:	8b 00                	mov    (%eax),%eax
  803654:	85 c0                	test   %eax,%eax
  803656:	74 10                	je     803668 <insert_sorted_with_merge_freeList+0x3b5>
  803658:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80365b:	8b 00                	mov    (%eax),%eax
  80365d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803660:	8b 52 04             	mov    0x4(%edx),%edx
  803663:	89 50 04             	mov    %edx,0x4(%eax)
  803666:	eb 0b                	jmp    803673 <insert_sorted_with_merge_freeList+0x3c0>
  803668:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80366b:	8b 40 04             	mov    0x4(%eax),%eax
  80366e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803673:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803676:	8b 40 04             	mov    0x4(%eax),%eax
  803679:	85 c0                	test   %eax,%eax
  80367b:	74 0f                	je     80368c <insert_sorted_with_merge_freeList+0x3d9>
  80367d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803680:	8b 40 04             	mov    0x4(%eax),%eax
  803683:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803686:	8b 12                	mov    (%edx),%edx
  803688:	89 10                	mov    %edx,(%eax)
  80368a:	eb 0a                	jmp    803696 <insert_sorted_with_merge_freeList+0x3e3>
  80368c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80368f:	8b 00                	mov    (%eax),%eax
  803691:	a3 38 51 80 00       	mov    %eax,0x805138
  803696:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803699:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80369f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036a2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036a9:	a1 44 51 80 00       	mov    0x805144,%eax
  8036ae:	48                   	dec    %eax
  8036af:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8036b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036b7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8036be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036c1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8036c8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8036cc:	75 17                	jne    8036e5 <insert_sorted_with_merge_freeList+0x432>
  8036ce:	83 ec 04             	sub    $0x4,%esp
  8036d1:	68 90 45 80 00       	push   $0x804590
  8036d6:	68 5f 01 00 00       	push   $0x15f
  8036db:	68 b3 45 80 00       	push   $0x8045b3
  8036e0:	e8 41 d0 ff ff       	call   800726 <_panic>
  8036e5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8036eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036ee:	89 10                	mov    %edx,(%eax)
  8036f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036f3:	8b 00                	mov    (%eax),%eax
  8036f5:	85 c0                	test   %eax,%eax
  8036f7:	74 0d                	je     803706 <insert_sorted_with_merge_freeList+0x453>
  8036f9:	a1 48 51 80 00       	mov    0x805148,%eax
  8036fe:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803701:	89 50 04             	mov    %edx,0x4(%eax)
  803704:	eb 08                	jmp    80370e <insert_sorted_with_merge_freeList+0x45b>
  803706:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803709:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80370e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803711:	a3 48 51 80 00       	mov    %eax,0x805148
  803716:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803719:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803720:	a1 54 51 80 00       	mov    0x805154,%eax
  803725:	40                   	inc    %eax
  803726:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  80372b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80372e:	8b 50 0c             	mov    0xc(%eax),%edx
  803731:	8b 45 08             	mov    0x8(%ebp),%eax
  803734:	8b 40 0c             	mov    0xc(%eax),%eax
  803737:	01 c2                	add    %eax,%edx
  803739:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80373c:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80373f:	8b 45 08             	mov    0x8(%ebp),%eax
  803742:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803749:	8b 45 08             	mov    0x8(%ebp),%eax
  80374c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803753:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803757:	75 17                	jne    803770 <insert_sorted_with_merge_freeList+0x4bd>
  803759:	83 ec 04             	sub    $0x4,%esp
  80375c:	68 90 45 80 00       	push   $0x804590
  803761:	68 64 01 00 00       	push   $0x164
  803766:	68 b3 45 80 00       	push   $0x8045b3
  80376b:	e8 b6 cf ff ff       	call   800726 <_panic>
  803770:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803776:	8b 45 08             	mov    0x8(%ebp),%eax
  803779:	89 10                	mov    %edx,(%eax)
  80377b:	8b 45 08             	mov    0x8(%ebp),%eax
  80377e:	8b 00                	mov    (%eax),%eax
  803780:	85 c0                	test   %eax,%eax
  803782:	74 0d                	je     803791 <insert_sorted_with_merge_freeList+0x4de>
  803784:	a1 48 51 80 00       	mov    0x805148,%eax
  803789:	8b 55 08             	mov    0x8(%ebp),%edx
  80378c:	89 50 04             	mov    %edx,0x4(%eax)
  80378f:	eb 08                	jmp    803799 <insert_sorted_with_merge_freeList+0x4e6>
  803791:	8b 45 08             	mov    0x8(%ebp),%eax
  803794:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803799:	8b 45 08             	mov    0x8(%ebp),%eax
  80379c:	a3 48 51 80 00       	mov    %eax,0x805148
  8037a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037ab:	a1 54 51 80 00       	mov    0x805154,%eax
  8037b0:	40                   	inc    %eax
  8037b1:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8037b6:	e9 41 02 00 00       	jmp    8039fc <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8037bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8037be:	8b 50 08             	mov    0x8(%eax),%edx
  8037c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8037c7:	01 c2                	add    %eax,%edx
  8037c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037cc:	8b 40 08             	mov    0x8(%eax),%eax
  8037cf:	39 c2                	cmp    %eax,%edx
  8037d1:	0f 85 7c 01 00 00    	jne    803953 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8037d7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8037db:	74 06                	je     8037e3 <insert_sorted_with_merge_freeList+0x530>
  8037dd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037e1:	75 17                	jne    8037fa <insert_sorted_with_merge_freeList+0x547>
  8037e3:	83 ec 04             	sub    $0x4,%esp
  8037e6:	68 cc 45 80 00       	push   $0x8045cc
  8037eb:	68 69 01 00 00       	push   $0x169
  8037f0:	68 b3 45 80 00       	push   $0x8045b3
  8037f5:	e8 2c cf ff ff       	call   800726 <_panic>
  8037fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037fd:	8b 50 04             	mov    0x4(%eax),%edx
  803800:	8b 45 08             	mov    0x8(%ebp),%eax
  803803:	89 50 04             	mov    %edx,0x4(%eax)
  803806:	8b 45 08             	mov    0x8(%ebp),%eax
  803809:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80380c:	89 10                	mov    %edx,(%eax)
  80380e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803811:	8b 40 04             	mov    0x4(%eax),%eax
  803814:	85 c0                	test   %eax,%eax
  803816:	74 0d                	je     803825 <insert_sorted_with_merge_freeList+0x572>
  803818:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80381b:	8b 40 04             	mov    0x4(%eax),%eax
  80381e:	8b 55 08             	mov    0x8(%ebp),%edx
  803821:	89 10                	mov    %edx,(%eax)
  803823:	eb 08                	jmp    80382d <insert_sorted_with_merge_freeList+0x57a>
  803825:	8b 45 08             	mov    0x8(%ebp),%eax
  803828:	a3 38 51 80 00       	mov    %eax,0x805138
  80382d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803830:	8b 55 08             	mov    0x8(%ebp),%edx
  803833:	89 50 04             	mov    %edx,0x4(%eax)
  803836:	a1 44 51 80 00       	mov    0x805144,%eax
  80383b:	40                   	inc    %eax
  80383c:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803841:	8b 45 08             	mov    0x8(%ebp),%eax
  803844:	8b 50 0c             	mov    0xc(%eax),%edx
  803847:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80384a:	8b 40 0c             	mov    0xc(%eax),%eax
  80384d:	01 c2                	add    %eax,%edx
  80384f:	8b 45 08             	mov    0x8(%ebp),%eax
  803852:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803855:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803859:	75 17                	jne    803872 <insert_sorted_with_merge_freeList+0x5bf>
  80385b:	83 ec 04             	sub    $0x4,%esp
  80385e:	68 5c 46 80 00       	push   $0x80465c
  803863:	68 6b 01 00 00       	push   $0x16b
  803868:	68 b3 45 80 00       	push   $0x8045b3
  80386d:	e8 b4 ce ff ff       	call   800726 <_panic>
  803872:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803875:	8b 00                	mov    (%eax),%eax
  803877:	85 c0                	test   %eax,%eax
  803879:	74 10                	je     80388b <insert_sorted_with_merge_freeList+0x5d8>
  80387b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80387e:	8b 00                	mov    (%eax),%eax
  803880:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803883:	8b 52 04             	mov    0x4(%edx),%edx
  803886:	89 50 04             	mov    %edx,0x4(%eax)
  803889:	eb 0b                	jmp    803896 <insert_sorted_with_merge_freeList+0x5e3>
  80388b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80388e:	8b 40 04             	mov    0x4(%eax),%eax
  803891:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803896:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803899:	8b 40 04             	mov    0x4(%eax),%eax
  80389c:	85 c0                	test   %eax,%eax
  80389e:	74 0f                	je     8038af <insert_sorted_with_merge_freeList+0x5fc>
  8038a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038a3:	8b 40 04             	mov    0x4(%eax),%eax
  8038a6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038a9:	8b 12                	mov    (%edx),%edx
  8038ab:	89 10                	mov    %edx,(%eax)
  8038ad:	eb 0a                	jmp    8038b9 <insert_sorted_with_merge_freeList+0x606>
  8038af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038b2:	8b 00                	mov    (%eax),%eax
  8038b4:	a3 38 51 80 00       	mov    %eax,0x805138
  8038b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038cc:	a1 44 51 80 00       	mov    0x805144,%eax
  8038d1:	48                   	dec    %eax
  8038d2:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8038d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038da:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8038e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038e4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8038eb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8038ef:	75 17                	jne    803908 <insert_sorted_with_merge_freeList+0x655>
  8038f1:	83 ec 04             	sub    $0x4,%esp
  8038f4:	68 90 45 80 00       	push   $0x804590
  8038f9:	68 6e 01 00 00       	push   $0x16e
  8038fe:	68 b3 45 80 00       	push   $0x8045b3
  803903:	e8 1e ce ff ff       	call   800726 <_panic>
  803908:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80390e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803911:	89 10                	mov    %edx,(%eax)
  803913:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803916:	8b 00                	mov    (%eax),%eax
  803918:	85 c0                	test   %eax,%eax
  80391a:	74 0d                	je     803929 <insert_sorted_with_merge_freeList+0x676>
  80391c:	a1 48 51 80 00       	mov    0x805148,%eax
  803921:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803924:	89 50 04             	mov    %edx,0x4(%eax)
  803927:	eb 08                	jmp    803931 <insert_sorted_with_merge_freeList+0x67e>
  803929:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80392c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803931:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803934:	a3 48 51 80 00       	mov    %eax,0x805148
  803939:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80393c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803943:	a1 54 51 80 00       	mov    0x805154,%eax
  803948:	40                   	inc    %eax
  803949:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80394e:	e9 a9 00 00 00       	jmp    8039fc <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803953:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803957:	74 06                	je     80395f <insert_sorted_with_merge_freeList+0x6ac>
  803959:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80395d:	75 17                	jne    803976 <insert_sorted_with_merge_freeList+0x6c3>
  80395f:	83 ec 04             	sub    $0x4,%esp
  803962:	68 28 46 80 00       	push   $0x804628
  803967:	68 73 01 00 00       	push   $0x173
  80396c:	68 b3 45 80 00       	push   $0x8045b3
  803971:	e8 b0 cd ff ff       	call   800726 <_panic>
  803976:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803979:	8b 10                	mov    (%eax),%edx
  80397b:	8b 45 08             	mov    0x8(%ebp),%eax
  80397e:	89 10                	mov    %edx,(%eax)
  803980:	8b 45 08             	mov    0x8(%ebp),%eax
  803983:	8b 00                	mov    (%eax),%eax
  803985:	85 c0                	test   %eax,%eax
  803987:	74 0b                	je     803994 <insert_sorted_with_merge_freeList+0x6e1>
  803989:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80398c:	8b 00                	mov    (%eax),%eax
  80398e:	8b 55 08             	mov    0x8(%ebp),%edx
  803991:	89 50 04             	mov    %edx,0x4(%eax)
  803994:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803997:	8b 55 08             	mov    0x8(%ebp),%edx
  80399a:	89 10                	mov    %edx,(%eax)
  80399c:	8b 45 08             	mov    0x8(%ebp),%eax
  80399f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8039a2:	89 50 04             	mov    %edx,0x4(%eax)
  8039a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8039a8:	8b 00                	mov    (%eax),%eax
  8039aa:	85 c0                	test   %eax,%eax
  8039ac:	75 08                	jne    8039b6 <insert_sorted_with_merge_freeList+0x703>
  8039ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8039b1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8039b6:	a1 44 51 80 00       	mov    0x805144,%eax
  8039bb:	40                   	inc    %eax
  8039bc:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8039c1:	eb 39                	jmp    8039fc <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8039c3:	a1 40 51 80 00       	mov    0x805140,%eax
  8039c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8039cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039cf:	74 07                	je     8039d8 <insert_sorted_with_merge_freeList+0x725>
  8039d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039d4:	8b 00                	mov    (%eax),%eax
  8039d6:	eb 05                	jmp    8039dd <insert_sorted_with_merge_freeList+0x72a>
  8039d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8039dd:	a3 40 51 80 00       	mov    %eax,0x805140
  8039e2:	a1 40 51 80 00       	mov    0x805140,%eax
  8039e7:	85 c0                	test   %eax,%eax
  8039e9:	0f 85 c7 fb ff ff    	jne    8035b6 <insert_sorted_with_merge_freeList+0x303>
  8039ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039f3:	0f 85 bd fb ff ff    	jne    8035b6 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8039f9:	eb 01                	jmp    8039fc <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8039fb:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8039fc:	90                   	nop
  8039fd:	c9                   	leave  
  8039fe:	c3                   	ret    
  8039ff:	90                   	nop

00803a00 <__udivdi3>:
  803a00:	55                   	push   %ebp
  803a01:	57                   	push   %edi
  803a02:	56                   	push   %esi
  803a03:	53                   	push   %ebx
  803a04:	83 ec 1c             	sub    $0x1c,%esp
  803a07:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803a0b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803a0f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a13:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803a17:	89 ca                	mov    %ecx,%edx
  803a19:	89 f8                	mov    %edi,%eax
  803a1b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803a1f:	85 f6                	test   %esi,%esi
  803a21:	75 2d                	jne    803a50 <__udivdi3+0x50>
  803a23:	39 cf                	cmp    %ecx,%edi
  803a25:	77 65                	ja     803a8c <__udivdi3+0x8c>
  803a27:	89 fd                	mov    %edi,%ebp
  803a29:	85 ff                	test   %edi,%edi
  803a2b:	75 0b                	jne    803a38 <__udivdi3+0x38>
  803a2d:	b8 01 00 00 00       	mov    $0x1,%eax
  803a32:	31 d2                	xor    %edx,%edx
  803a34:	f7 f7                	div    %edi
  803a36:	89 c5                	mov    %eax,%ebp
  803a38:	31 d2                	xor    %edx,%edx
  803a3a:	89 c8                	mov    %ecx,%eax
  803a3c:	f7 f5                	div    %ebp
  803a3e:	89 c1                	mov    %eax,%ecx
  803a40:	89 d8                	mov    %ebx,%eax
  803a42:	f7 f5                	div    %ebp
  803a44:	89 cf                	mov    %ecx,%edi
  803a46:	89 fa                	mov    %edi,%edx
  803a48:	83 c4 1c             	add    $0x1c,%esp
  803a4b:	5b                   	pop    %ebx
  803a4c:	5e                   	pop    %esi
  803a4d:	5f                   	pop    %edi
  803a4e:	5d                   	pop    %ebp
  803a4f:	c3                   	ret    
  803a50:	39 ce                	cmp    %ecx,%esi
  803a52:	77 28                	ja     803a7c <__udivdi3+0x7c>
  803a54:	0f bd fe             	bsr    %esi,%edi
  803a57:	83 f7 1f             	xor    $0x1f,%edi
  803a5a:	75 40                	jne    803a9c <__udivdi3+0x9c>
  803a5c:	39 ce                	cmp    %ecx,%esi
  803a5e:	72 0a                	jb     803a6a <__udivdi3+0x6a>
  803a60:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803a64:	0f 87 9e 00 00 00    	ja     803b08 <__udivdi3+0x108>
  803a6a:	b8 01 00 00 00       	mov    $0x1,%eax
  803a6f:	89 fa                	mov    %edi,%edx
  803a71:	83 c4 1c             	add    $0x1c,%esp
  803a74:	5b                   	pop    %ebx
  803a75:	5e                   	pop    %esi
  803a76:	5f                   	pop    %edi
  803a77:	5d                   	pop    %ebp
  803a78:	c3                   	ret    
  803a79:	8d 76 00             	lea    0x0(%esi),%esi
  803a7c:	31 ff                	xor    %edi,%edi
  803a7e:	31 c0                	xor    %eax,%eax
  803a80:	89 fa                	mov    %edi,%edx
  803a82:	83 c4 1c             	add    $0x1c,%esp
  803a85:	5b                   	pop    %ebx
  803a86:	5e                   	pop    %esi
  803a87:	5f                   	pop    %edi
  803a88:	5d                   	pop    %ebp
  803a89:	c3                   	ret    
  803a8a:	66 90                	xchg   %ax,%ax
  803a8c:	89 d8                	mov    %ebx,%eax
  803a8e:	f7 f7                	div    %edi
  803a90:	31 ff                	xor    %edi,%edi
  803a92:	89 fa                	mov    %edi,%edx
  803a94:	83 c4 1c             	add    $0x1c,%esp
  803a97:	5b                   	pop    %ebx
  803a98:	5e                   	pop    %esi
  803a99:	5f                   	pop    %edi
  803a9a:	5d                   	pop    %ebp
  803a9b:	c3                   	ret    
  803a9c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803aa1:	89 eb                	mov    %ebp,%ebx
  803aa3:	29 fb                	sub    %edi,%ebx
  803aa5:	89 f9                	mov    %edi,%ecx
  803aa7:	d3 e6                	shl    %cl,%esi
  803aa9:	89 c5                	mov    %eax,%ebp
  803aab:	88 d9                	mov    %bl,%cl
  803aad:	d3 ed                	shr    %cl,%ebp
  803aaf:	89 e9                	mov    %ebp,%ecx
  803ab1:	09 f1                	or     %esi,%ecx
  803ab3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803ab7:	89 f9                	mov    %edi,%ecx
  803ab9:	d3 e0                	shl    %cl,%eax
  803abb:	89 c5                	mov    %eax,%ebp
  803abd:	89 d6                	mov    %edx,%esi
  803abf:	88 d9                	mov    %bl,%cl
  803ac1:	d3 ee                	shr    %cl,%esi
  803ac3:	89 f9                	mov    %edi,%ecx
  803ac5:	d3 e2                	shl    %cl,%edx
  803ac7:	8b 44 24 08          	mov    0x8(%esp),%eax
  803acb:	88 d9                	mov    %bl,%cl
  803acd:	d3 e8                	shr    %cl,%eax
  803acf:	09 c2                	or     %eax,%edx
  803ad1:	89 d0                	mov    %edx,%eax
  803ad3:	89 f2                	mov    %esi,%edx
  803ad5:	f7 74 24 0c          	divl   0xc(%esp)
  803ad9:	89 d6                	mov    %edx,%esi
  803adb:	89 c3                	mov    %eax,%ebx
  803add:	f7 e5                	mul    %ebp
  803adf:	39 d6                	cmp    %edx,%esi
  803ae1:	72 19                	jb     803afc <__udivdi3+0xfc>
  803ae3:	74 0b                	je     803af0 <__udivdi3+0xf0>
  803ae5:	89 d8                	mov    %ebx,%eax
  803ae7:	31 ff                	xor    %edi,%edi
  803ae9:	e9 58 ff ff ff       	jmp    803a46 <__udivdi3+0x46>
  803aee:	66 90                	xchg   %ax,%ax
  803af0:	8b 54 24 08          	mov    0x8(%esp),%edx
  803af4:	89 f9                	mov    %edi,%ecx
  803af6:	d3 e2                	shl    %cl,%edx
  803af8:	39 c2                	cmp    %eax,%edx
  803afa:	73 e9                	jae    803ae5 <__udivdi3+0xe5>
  803afc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803aff:	31 ff                	xor    %edi,%edi
  803b01:	e9 40 ff ff ff       	jmp    803a46 <__udivdi3+0x46>
  803b06:	66 90                	xchg   %ax,%ax
  803b08:	31 c0                	xor    %eax,%eax
  803b0a:	e9 37 ff ff ff       	jmp    803a46 <__udivdi3+0x46>
  803b0f:	90                   	nop

00803b10 <__umoddi3>:
  803b10:	55                   	push   %ebp
  803b11:	57                   	push   %edi
  803b12:	56                   	push   %esi
  803b13:	53                   	push   %ebx
  803b14:	83 ec 1c             	sub    $0x1c,%esp
  803b17:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803b1b:	8b 74 24 34          	mov    0x34(%esp),%esi
  803b1f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b23:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803b27:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803b2b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803b2f:	89 f3                	mov    %esi,%ebx
  803b31:	89 fa                	mov    %edi,%edx
  803b33:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b37:	89 34 24             	mov    %esi,(%esp)
  803b3a:	85 c0                	test   %eax,%eax
  803b3c:	75 1a                	jne    803b58 <__umoddi3+0x48>
  803b3e:	39 f7                	cmp    %esi,%edi
  803b40:	0f 86 a2 00 00 00    	jbe    803be8 <__umoddi3+0xd8>
  803b46:	89 c8                	mov    %ecx,%eax
  803b48:	89 f2                	mov    %esi,%edx
  803b4a:	f7 f7                	div    %edi
  803b4c:	89 d0                	mov    %edx,%eax
  803b4e:	31 d2                	xor    %edx,%edx
  803b50:	83 c4 1c             	add    $0x1c,%esp
  803b53:	5b                   	pop    %ebx
  803b54:	5e                   	pop    %esi
  803b55:	5f                   	pop    %edi
  803b56:	5d                   	pop    %ebp
  803b57:	c3                   	ret    
  803b58:	39 f0                	cmp    %esi,%eax
  803b5a:	0f 87 ac 00 00 00    	ja     803c0c <__umoddi3+0xfc>
  803b60:	0f bd e8             	bsr    %eax,%ebp
  803b63:	83 f5 1f             	xor    $0x1f,%ebp
  803b66:	0f 84 ac 00 00 00    	je     803c18 <__umoddi3+0x108>
  803b6c:	bf 20 00 00 00       	mov    $0x20,%edi
  803b71:	29 ef                	sub    %ebp,%edi
  803b73:	89 fe                	mov    %edi,%esi
  803b75:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803b79:	89 e9                	mov    %ebp,%ecx
  803b7b:	d3 e0                	shl    %cl,%eax
  803b7d:	89 d7                	mov    %edx,%edi
  803b7f:	89 f1                	mov    %esi,%ecx
  803b81:	d3 ef                	shr    %cl,%edi
  803b83:	09 c7                	or     %eax,%edi
  803b85:	89 e9                	mov    %ebp,%ecx
  803b87:	d3 e2                	shl    %cl,%edx
  803b89:	89 14 24             	mov    %edx,(%esp)
  803b8c:	89 d8                	mov    %ebx,%eax
  803b8e:	d3 e0                	shl    %cl,%eax
  803b90:	89 c2                	mov    %eax,%edx
  803b92:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b96:	d3 e0                	shl    %cl,%eax
  803b98:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b9c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ba0:	89 f1                	mov    %esi,%ecx
  803ba2:	d3 e8                	shr    %cl,%eax
  803ba4:	09 d0                	or     %edx,%eax
  803ba6:	d3 eb                	shr    %cl,%ebx
  803ba8:	89 da                	mov    %ebx,%edx
  803baa:	f7 f7                	div    %edi
  803bac:	89 d3                	mov    %edx,%ebx
  803bae:	f7 24 24             	mull   (%esp)
  803bb1:	89 c6                	mov    %eax,%esi
  803bb3:	89 d1                	mov    %edx,%ecx
  803bb5:	39 d3                	cmp    %edx,%ebx
  803bb7:	0f 82 87 00 00 00    	jb     803c44 <__umoddi3+0x134>
  803bbd:	0f 84 91 00 00 00    	je     803c54 <__umoddi3+0x144>
  803bc3:	8b 54 24 04          	mov    0x4(%esp),%edx
  803bc7:	29 f2                	sub    %esi,%edx
  803bc9:	19 cb                	sbb    %ecx,%ebx
  803bcb:	89 d8                	mov    %ebx,%eax
  803bcd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803bd1:	d3 e0                	shl    %cl,%eax
  803bd3:	89 e9                	mov    %ebp,%ecx
  803bd5:	d3 ea                	shr    %cl,%edx
  803bd7:	09 d0                	or     %edx,%eax
  803bd9:	89 e9                	mov    %ebp,%ecx
  803bdb:	d3 eb                	shr    %cl,%ebx
  803bdd:	89 da                	mov    %ebx,%edx
  803bdf:	83 c4 1c             	add    $0x1c,%esp
  803be2:	5b                   	pop    %ebx
  803be3:	5e                   	pop    %esi
  803be4:	5f                   	pop    %edi
  803be5:	5d                   	pop    %ebp
  803be6:	c3                   	ret    
  803be7:	90                   	nop
  803be8:	89 fd                	mov    %edi,%ebp
  803bea:	85 ff                	test   %edi,%edi
  803bec:	75 0b                	jne    803bf9 <__umoddi3+0xe9>
  803bee:	b8 01 00 00 00       	mov    $0x1,%eax
  803bf3:	31 d2                	xor    %edx,%edx
  803bf5:	f7 f7                	div    %edi
  803bf7:	89 c5                	mov    %eax,%ebp
  803bf9:	89 f0                	mov    %esi,%eax
  803bfb:	31 d2                	xor    %edx,%edx
  803bfd:	f7 f5                	div    %ebp
  803bff:	89 c8                	mov    %ecx,%eax
  803c01:	f7 f5                	div    %ebp
  803c03:	89 d0                	mov    %edx,%eax
  803c05:	e9 44 ff ff ff       	jmp    803b4e <__umoddi3+0x3e>
  803c0a:	66 90                	xchg   %ax,%ax
  803c0c:	89 c8                	mov    %ecx,%eax
  803c0e:	89 f2                	mov    %esi,%edx
  803c10:	83 c4 1c             	add    $0x1c,%esp
  803c13:	5b                   	pop    %ebx
  803c14:	5e                   	pop    %esi
  803c15:	5f                   	pop    %edi
  803c16:	5d                   	pop    %ebp
  803c17:	c3                   	ret    
  803c18:	3b 04 24             	cmp    (%esp),%eax
  803c1b:	72 06                	jb     803c23 <__umoddi3+0x113>
  803c1d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803c21:	77 0f                	ja     803c32 <__umoddi3+0x122>
  803c23:	89 f2                	mov    %esi,%edx
  803c25:	29 f9                	sub    %edi,%ecx
  803c27:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803c2b:	89 14 24             	mov    %edx,(%esp)
  803c2e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c32:	8b 44 24 04          	mov    0x4(%esp),%eax
  803c36:	8b 14 24             	mov    (%esp),%edx
  803c39:	83 c4 1c             	add    $0x1c,%esp
  803c3c:	5b                   	pop    %ebx
  803c3d:	5e                   	pop    %esi
  803c3e:	5f                   	pop    %edi
  803c3f:	5d                   	pop    %ebp
  803c40:	c3                   	ret    
  803c41:	8d 76 00             	lea    0x0(%esi),%esi
  803c44:	2b 04 24             	sub    (%esp),%eax
  803c47:	19 fa                	sbb    %edi,%edx
  803c49:	89 d1                	mov    %edx,%ecx
  803c4b:	89 c6                	mov    %eax,%esi
  803c4d:	e9 71 ff ff ff       	jmp    803bc3 <__umoddi3+0xb3>
  803c52:	66 90                	xchg   %ax,%ax
  803c54:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803c58:	72 ea                	jb     803c44 <__umoddi3+0x134>
  803c5a:	89 d9                	mov    %ebx,%ecx
  803c5c:	e9 62 ff ff ff       	jmp    803bc3 <__umoddi3+0xb3>
