
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
  800049:	e8 c7 1d 00 00       	call   801e15 <sys_calculate_free_frames>
  80004e:	89 c3                	mov    %eax,%ebx
  800050:	e8 d9 1d 00 00       	call   801e2e <sys_calculate_modified_frames>
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
  800067:	68 40 3c 80 00       	push   $0x803c40
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
  8000a5:	68 60 3c 80 00       	push   $0x803c60
  8000aa:	e8 2b 09 00 00       	call   8009da <cprintf>
  8000af:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000b2:	83 ec 0c             	sub    $0xc,%esp
  8000b5:	68 83 3c 80 00       	push   $0x803c83
  8000ba:	e8 1b 09 00 00       	call   8009da <cprintf>
  8000bf:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000c2:	83 ec 0c             	sub    $0xc,%esp
  8000c5:	68 91 3c 80 00       	push   $0x803c91
  8000ca:	e8 0b 09 00 00       	call   8009da <cprintf>
  8000cf:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  8000d2:	83 ec 0c             	sub    $0xc,%esp
  8000d5:	68 a0 3c 80 00       	push   $0x803ca0
  8000da:	e8 fb 08 00 00       	call   8009da <cprintf>
  8000df:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  8000e2:	83 ec 0c             	sub    $0xc,%esp
  8000e5:	68 b0 3c 80 00       	push   $0x803cb0
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
  8001b4:	68 bc 3c 80 00       	push   $0x803cbc
  8001b9:	6a 45                	push   $0x45
  8001bb:	68 de 3c 80 00       	push   $0x803cde
  8001c0:	e8 61 05 00 00       	call   800726 <_panic>
		else
		{ 
			cprintf("===============================================\n") ;
  8001c5:	83 ec 0c             	sub    $0xc,%esp
  8001c8:	68 f8 3c 80 00       	push   $0x803cf8
  8001cd:	e8 08 08 00 00       	call   8009da <cprintf>
  8001d2:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  8001d5:	83 ec 0c             	sub    $0xc,%esp
  8001d8:	68 2c 3d 80 00       	push   $0x803d2c
  8001dd:	e8 f8 07 00 00       	call   8009da <cprintf>
  8001e2:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  8001e5:	83 ec 0c             	sub    $0xc,%esp
  8001e8:	68 60 3d 80 00       	push   $0x803d60
  8001ed:	e8 e8 07 00 00       	call   8009da <cprintf>
  8001f2:	83 c4 10             	add    $0x10,%esp
		}

		//		cprintf("Free Frames After Calculation = %d\n", sys_calculate_free_frames()) ;

		cprintf("Freeing the Heap...\n\n") ;
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	68 92 3d 80 00       	push   $0x803d92
  8001fd:	e8 d8 07 00 00       	call   8009da <cprintf>
  800202:	83 c4 10             	add    $0x10,%esp

		//freeHeap() ;

		///========================================================================
		//sys_disable_interrupt();
		cprintf("Do you want to repeat (y/n): ") ;
  800205:	83 ec 0c             	sub    $0xc,%esp
  800208:	68 a8 3d 80 00       	push   $0x803da8
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
  8004ea:	68 c6 3d 80 00       	push   $0x803dc6
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
  80050c:	68 c8 3d 80 00       	push   $0x803dc8
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
  80053a:	68 cd 3d 80 00       	push   $0x803dcd
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
  80055e:	e8 d3 19 00 00       	call   801f36 <sys_cputc>
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
  80056f:	e8 8e 19 00 00       	call   801f02 <sys_disable_interrupt>
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
  800582:	e8 af 19 00 00       	call   801f36 <sys_cputc>
  800587:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80058a:	e8 8d 19 00 00       	call   801f1c <sys_enable_interrupt>
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
  8005a1:	e8 d7 17 00 00       	call   801d7d <sys_cgetc>
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
  8005ba:	e8 43 19 00 00       	call   801f02 <sys_disable_interrupt>
	int c=0;
  8005bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8005c6:	eb 08                	jmp    8005d0 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  8005c8:	e8 b0 17 00 00       	call   801d7d <sys_cgetc>
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
  8005d6:	e8 41 19 00 00       	call   801f1c <sys_enable_interrupt>
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
  8005f0:	e8 00 1b 00 00       	call   8020f5 <sys_getenvindex>
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
  80065b:	e8 a2 18 00 00       	call   801f02 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800660:	83 ec 0c             	sub    $0xc,%esp
  800663:	68 ec 3d 80 00       	push   $0x803dec
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
  80068b:	68 14 3e 80 00       	push   $0x803e14
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
  8006bc:	68 3c 3e 80 00       	push   $0x803e3c
  8006c1:	e8 14 03 00 00       	call   8009da <cprintf>
  8006c6:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006c9:	a1 24 50 80 00       	mov    0x805024,%eax
  8006ce:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8006d4:	83 ec 08             	sub    $0x8,%esp
  8006d7:	50                   	push   %eax
  8006d8:	68 94 3e 80 00       	push   $0x803e94
  8006dd:	e8 f8 02 00 00       	call   8009da <cprintf>
  8006e2:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8006e5:	83 ec 0c             	sub    $0xc,%esp
  8006e8:	68 ec 3d 80 00       	push   $0x803dec
  8006ed:	e8 e8 02 00 00       	call   8009da <cprintf>
  8006f2:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8006f5:	e8 22 18 00 00       	call   801f1c <sys_enable_interrupt>

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
  80070d:	e8 af 19 00 00       	call   8020c1 <sys_destroy_env>
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
  80071e:	e8 04 1a 00 00       	call   802127 <sys_exit_env>
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
  800747:	68 a8 3e 80 00       	push   $0x803ea8
  80074c:	e8 89 02 00 00       	call   8009da <cprintf>
  800751:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800754:	a1 00 50 80 00       	mov    0x805000,%eax
  800759:	ff 75 0c             	pushl  0xc(%ebp)
  80075c:	ff 75 08             	pushl  0x8(%ebp)
  80075f:	50                   	push   %eax
  800760:	68 ad 3e 80 00       	push   $0x803ead
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
  800784:	68 c9 3e 80 00       	push   $0x803ec9
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
  8007b0:	68 cc 3e 80 00       	push   $0x803ecc
  8007b5:	6a 26                	push   $0x26
  8007b7:	68 18 3f 80 00       	push   $0x803f18
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
  800882:	68 24 3f 80 00       	push   $0x803f24
  800887:	6a 3a                	push   $0x3a
  800889:	68 18 3f 80 00       	push   $0x803f18
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
  8008f2:	68 78 3f 80 00       	push   $0x803f78
  8008f7:	6a 44                	push   $0x44
  8008f9:	68 18 3f 80 00       	push   $0x803f18
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
  80094c:	e8 03 14 00 00       	call   801d54 <sys_cputs>
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
  8009c3:	e8 8c 13 00 00       	call   801d54 <sys_cputs>
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
  800a0d:	e8 f0 14 00 00       	call   801f02 <sys_disable_interrupt>
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
  800a2d:	e8 ea 14 00 00       	call   801f1c <sys_enable_interrupt>
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
  800a77:	e8 5c 2f 00 00       	call   8039d8 <__udivdi3>
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
  800ac7:	e8 1c 30 00 00       	call   803ae8 <__umoddi3>
  800acc:	83 c4 10             	add    $0x10,%esp
  800acf:	05 f4 41 80 00       	add    $0x8041f4,%eax
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
  800c22:	8b 04 85 18 42 80 00 	mov    0x804218(,%eax,4),%eax
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
  800d03:	8b 34 9d 60 40 80 00 	mov    0x804060(,%ebx,4),%esi
  800d0a:	85 f6                	test   %esi,%esi
  800d0c:	75 19                	jne    800d27 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d0e:	53                   	push   %ebx
  800d0f:	68 05 42 80 00       	push   $0x804205
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
  800d28:	68 0e 42 80 00       	push   $0x80420e
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
  800d55:	be 11 42 80 00       	mov    $0x804211,%esi
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
  80106e:	68 70 43 80 00       	push   $0x804370
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
  8010b0:	68 73 43 80 00       	push   $0x804373
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
  801160:	e8 9d 0d 00 00       	call   801f02 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  801165:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801169:	74 13                	je     80117e <atomic_readline+0x24>
		cprintf("%s", prompt);
  80116b:	83 ec 08             	sub    $0x8,%esp
  80116e:	ff 75 08             	pushl  0x8(%ebp)
  801171:	68 70 43 80 00       	push   $0x804370
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
  8011af:	68 73 43 80 00       	push   $0x804373
  8011b4:	e8 21 f8 ff ff       	call   8009da <cprintf>
  8011b9:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  8011bc:	e8 5b 0d 00 00       	call   801f1c <sys_enable_interrupt>
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
  801254:	e8 c3 0c 00 00       	call   801f1c <sys_enable_interrupt>
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
  801981:	68 84 43 80 00       	push   $0x804384
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
  801a51:	e8 42 04 00 00       	call   801e98 <sys_allocate_chunk>
  801a56:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801a59:	a1 20 51 80 00       	mov    0x805120,%eax
  801a5e:	83 ec 0c             	sub    $0xc,%esp
  801a61:	50                   	push   %eax
  801a62:	e8 b7 0a 00 00       	call   80251e <initialize_MemBlocksList>
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
  801a8f:	68 a9 43 80 00       	push   $0x8043a9
  801a94:	6a 33                	push   $0x33
  801a96:	68 c7 43 80 00       	push   $0x8043c7
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
  801b0e:	68 d4 43 80 00       	push   $0x8043d4
  801b13:	6a 34                	push   $0x34
  801b15:	68 c7 43 80 00       	push   $0x8043c7
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
  801b6b:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b6e:	e8 f7 fd ff ff       	call   80196a <InitializeUHeap>
	if (size == 0) return NULL ;
  801b73:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b77:	75 07                	jne    801b80 <malloc+0x18>
  801b79:	b8 00 00 00 00       	mov    $0x0,%eax
  801b7e:	eb 14                	jmp    801b94 <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801b80:	83 ec 04             	sub    $0x4,%esp
  801b83:	68 f8 43 80 00       	push   $0x8043f8
  801b88:	6a 46                	push   $0x46
  801b8a:	68 c7 43 80 00       	push   $0x8043c7
  801b8f:	e8 92 eb ff ff       	call   800726 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801b94:	c9                   	leave  
  801b95:	c3                   	ret    

00801b96 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801b96:	55                   	push   %ebp
  801b97:	89 e5                	mov    %esp,%ebp
  801b99:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801b9c:	83 ec 04             	sub    $0x4,%esp
  801b9f:	68 20 44 80 00       	push   $0x804420
  801ba4:	6a 61                	push   $0x61
  801ba6:	68 c7 43 80 00       	push   $0x8043c7
  801bab:	e8 76 eb ff ff       	call   800726 <_panic>

00801bb0 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801bb0:	55                   	push   %ebp
  801bb1:	89 e5                	mov    %esp,%ebp
  801bb3:	83 ec 38             	sub    $0x38,%esp
  801bb6:	8b 45 10             	mov    0x10(%ebp),%eax
  801bb9:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801bbc:	e8 a9 fd ff ff       	call   80196a <InitializeUHeap>
	if (size == 0) return NULL ;
  801bc1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801bc5:	75 0a                	jne    801bd1 <smalloc+0x21>
  801bc7:	b8 00 00 00 00       	mov    $0x0,%eax
  801bcc:	e9 9e 00 00 00       	jmp    801c6f <smalloc+0xbf>
	//3-If the Kernel successfully creates the shared variable, return its virtual address
	//4-Else, return NULL



	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801bd1:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801bd8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bde:	01 d0                	add    %edx,%eax
  801be0:	48                   	dec    %eax
  801be1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801be4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801be7:	ba 00 00 00 00       	mov    $0x0,%edx
  801bec:	f7 75 f0             	divl   -0x10(%ebp)
  801bef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bf2:	29 d0                	sub    %edx,%eax
  801bf4:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801bf7:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801bfe:	e8 63 06 00 00       	call   802266 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801c03:	85 c0                	test   %eax,%eax
  801c05:	74 11                	je     801c18 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801c07:	83 ec 0c             	sub    $0xc,%esp
  801c0a:	ff 75 e8             	pushl  -0x18(%ebp)
  801c0d:	e8 ce 0c 00 00       	call   8028e0 <alloc_block_FF>
  801c12:	83 c4 10             	add    $0x10,%esp
  801c15:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801c18:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c1c:	74 4c                	je     801c6a <smalloc+0xba>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801c1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c21:	8b 40 08             	mov    0x8(%eax),%eax
  801c24:	89 c2                	mov    %eax,%edx
  801c26:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801c2a:	52                   	push   %edx
  801c2b:	50                   	push   %eax
  801c2c:	ff 75 0c             	pushl  0xc(%ebp)
  801c2f:	ff 75 08             	pushl  0x8(%ebp)
  801c32:	e8 b4 03 00 00       	call   801feb <sys_createSharedObject>
  801c37:	83 c4 10             	add    $0x10,%esp
  801c3a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("Output is :  %d \n" , result);
  801c3d:	83 ec 08             	sub    $0x8,%esp
  801c40:	ff 75 e0             	pushl  -0x20(%ebp)
  801c43:	68 43 44 80 00       	push   $0x804443
  801c48:	e8 8d ed ff ff       	call   8009da <cprintf>
  801c4d:	83 c4 10             	add    $0x10,%esp
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801c50:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801c54:	74 14                	je     801c6a <smalloc+0xba>
  801c56:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801c5a:	74 0e                	je     801c6a <smalloc+0xba>
  801c5c:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801c60:	74 08                	je     801c6a <smalloc+0xba>
			return (void*) mem_block->sva;
  801c62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c65:	8b 40 08             	mov    0x8(%eax),%eax
  801c68:	eb 05                	jmp    801c6f <smalloc+0xbf>
	}
	return NULL;
  801c6a:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801c6f:	c9                   	leave  
  801c70:	c3                   	ret    

00801c71 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801c71:	55                   	push   %ebp
  801c72:	89 e5                	mov    %esp,%ebp
  801c74:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c77:	e8 ee fc ff ff       	call   80196a <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801c7c:	83 ec 04             	sub    $0x4,%esp
  801c7f:	68 58 44 80 00       	push   $0x804458
  801c84:	68 ab 00 00 00       	push   $0xab
  801c89:	68 c7 43 80 00       	push   $0x8043c7
  801c8e:	e8 93 ea ff ff       	call   800726 <_panic>

00801c93 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801c93:	55                   	push   %ebp
  801c94:	89 e5                	mov    %esp,%ebp
  801c96:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c99:	e8 cc fc ff ff       	call   80196a <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801c9e:	83 ec 04             	sub    $0x4,%esp
  801ca1:	68 7c 44 80 00       	push   $0x80447c
  801ca6:	68 ef 00 00 00       	push   $0xef
  801cab:	68 c7 43 80 00       	push   $0x8043c7
  801cb0:	e8 71 ea ff ff       	call   800726 <_panic>

00801cb5 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801cb5:	55                   	push   %ebp
  801cb6:	89 e5                	mov    %esp,%ebp
  801cb8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801cbb:	83 ec 04             	sub    $0x4,%esp
  801cbe:	68 a4 44 80 00       	push   $0x8044a4
  801cc3:	68 03 01 00 00       	push   $0x103
  801cc8:	68 c7 43 80 00       	push   $0x8043c7
  801ccd:	e8 54 ea ff ff       	call   800726 <_panic>

00801cd2 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801cd2:	55                   	push   %ebp
  801cd3:	89 e5                	mov    %esp,%ebp
  801cd5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801cd8:	83 ec 04             	sub    $0x4,%esp
  801cdb:	68 c8 44 80 00       	push   $0x8044c8
  801ce0:	68 0e 01 00 00       	push   $0x10e
  801ce5:	68 c7 43 80 00       	push   $0x8043c7
  801cea:	e8 37 ea ff ff       	call   800726 <_panic>

00801cef <shrink>:

}
void shrink(uint32 newSize)
{
  801cef:	55                   	push   %ebp
  801cf0:	89 e5                	mov    %esp,%ebp
  801cf2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801cf5:	83 ec 04             	sub    $0x4,%esp
  801cf8:	68 c8 44 80 00       	push   $0x8044c8
  801cfd:	68 13 01 00 00       	push   $0x113
  801d02:	68 c7 43 80 00       	push   $0x8043c7
  801d07:	e8 1a ea ff ff       	call   800726 <_panic>

00801d0c <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801d0c:	55                   	push   %ebp
  801d0d:	89 e5                	mov    %esp,%ebp
  801d0f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d12:	83 ec 04             	sub    $0x4,%esp
  801d15:	68 c8 44 80 00       	push   $0x8044c8
  801d1a:	68 18 01 00 00       	push   $0x118
  801d1f:	68 c7 43 80 00       	push   $0x8043c7
  801d24:	e8 fd e9 ff ff       	call   800726 <_panic>

00801d29 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801d29:	55                   	push   %ebp
  801d2a:	89 e5                	mov    %esp,%ebp
  801d2c:	57                   	push   %edi
  801d2d:	56                   	push   %esi
  801d2e:	53                   	push   %ebx
  801d2f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801d32:	8b 45 08             	mov    0x8(%ebp),%eax
  801d35:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d38:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d3b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d3e:	8b 7d 18             	mov    0x18(%ebp),%edi
  801d41:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801d44:	cd 30                	int    $0x30
  801d46:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801d49:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801d4c:	83 c4 10             	add    $0x10,%esp
  801d4f:	5b                   	pop    %ebx
  801d50:	5e                   	pop    %esi
  801d51:	5f                   	pop    %edi
  801d52:	5d                   	pop    %ebp
  801d53:	c3                   	ret    

00801d54 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801d54:	55                   	push   %ebp
  801d55:	89 e5                	mov    %esp,%ebp
  801d57:	83 ec 04             	sub    $0x4,%esp
  801d5a:	8b 45 10             	mov    0x10(%ebp),%eax
  801d5d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801d60:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d64:	8b 45 08             	mov    0x8(%ebp),%eax
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	52                   	push   %edx
  801d6c:	ff 75 0c             	pushl  0xc(%ebp)
  801d6f:	50                   	push   %eax
  801d70:	6a 00                	push   $0x0
  801d72:	e8 b2 ff ff ff       	call   801d29 <syscall>
  801d77:	83 c4 18             	add    $0x18,%esp
}
  801d7a:	90                   	nop
  801d7b:	c9                   	leave  
  801d7c:	c3                   	ret    

00801d7d <sys_cgetc>:

int
sys_cgetc(void)
{
  801d7d:	55                   	push   %ebp
  801d7e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801d80:	6a 00                	push   $0x0
  801d82:	6a 00                	push   $0x0
  801d84:	6a 00                	push   $0x0
  801d86:	6a 00                	push   $0x0
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 01                	push   $0x1
  801d8c:	e8 98 ff ff ff       	call   801d29 <syscall>
  801d91:	83 c4 18             	add    $0x18,%esp
}
  801d94:	c9                   	leave  
  801d95:	c3                   	ret    

00801d96 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801d96:	55                   	push   %ebp
  801d97:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801d99:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 00                	push   $0x0
  801da3:	6a 00                	push   $0x0
  801da5:	52                   	push   %edx
  801da6:	50                   	push   %eax
  801da7:	6a 05                	push   $0x5
  801da9:	e8 7b ff ff ff       	call   801d29 <syscall>
  801dae:	83 c4 18             	add    $0x18,%esp
}
  801db1:	c9                   	leave  
  801db2:	c3                   	ret    

00801db3 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801db3:	55                   	push   %ebp
  801db4:	89 e5                	mov    %esp,%ebp
  801db6:	56                   	push   %esi
  801db7:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801db8:	8b 75 18             	mov    0x18(%ebp),%esi
  801dbb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801dbe:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dc1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc7:	56                   	push   %esi
  801dc8:	53                   	push   %ebx
  801dc9:	51                   	push   %ecx
  801dca:	52                   	push   %edx
  801dcb:	50                   	push   %eax
  801dcc:	6a 06                	push   $0x6
  801dce:	e8 56 ff ff ff       	call   801d29 <syscall>
  801dd3:	83 c4 18             	add    $0x18,%esp
}
  801dd6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dd9:	5b                   	pop    %ebx
  801dda:	5e                   	pop    %esi
  801ddb:	5d                   	pop    %ebp
  801ddc:	c3                   	ret    

00801ddd <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801ddd:	55                   	push   %ebp
  801dde:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801de0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801de3:	8b 45 08             	mov    0x8(%ebp),%eax
  801de6:	6a 00                	push   $0x0
  801de8:	6a 00                	push   $0x0
  801dea:	6a 00                	push   $0x0
  801dec:	52                   	push   %edx
  801ded:	50                   	push   %eax
  801dee:	6a 07                	push   $0x7
  801df0:	e8 34 ff ff ff       	call   801d29 <syscall>
  801df5:	83 c4 18             	add    $0x18,%esp
}
  801df8:	c9                   	leave  
  801df9:	c3                   	ret    

00801dfa <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801dfa:	55                   	push   %ebp
  801dfb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 00                	push   $0x0
  801e01:	6a 00                	push   $0x0
  801e03:	ff 75 0c             	pushl  0xc(%ebp)
  801e06:	ff 75 08             	pushl  0x8(%ebp)
  801e09:	6a 08                	push   $0x8
  801e0b:	e8 19 ff ff ff       	call   801d29 <syscall>
  801e10:	83 c4 18             	add    $0x18,%esp
}
  801e13:	c9                   	leave  
  801e14:	c3                   	ret    

00801e15 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801e15:	55                   	push   %ebp
  801e16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801e18:	6a 00                	push   $0x0
  801e1a:	6a 00                	push   $0x0
  801e1c:	6a 00                	push   $0x0
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	6a 09                	push   $0x9
  801e24:	e8 00 ff ff ff       	call   801d29 <syscall>
  801e29:	83 c4 18             	add    $0x18,%esp
}
  801e2c:	c9                   	leave  
  801e2d:	c3                   	ret    

00801e2e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801e2e:	55                   	push   %ebp
  801e2f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801e31:	6a 00                	push   $0x0
  801e33:	6a 00                	push   $0x0
  801e35:	6a 00                	push   $0x0
  801e37:	6a 00                	push   $0x0
  801e39:	6a 00                	push   $0x0
  801e3b:	6a 0a                	push   $0xa
  801e3d:	e8 e7 fe ff ff       	call   801d29 <syscall>
  801e42:	83 c4 18             	add    $0x18,%esp
}
  801e45:	c9                   	leave  
  801e46:	c3                   	ret    

00801e47 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801e47:	55                   	push   %ebp
  801e48:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801e4a:	6a 00                	push   $0x0
  801e4c:	6a 00                	push   $0x0
  801e4e:	6a 00                	push   $0x0
  801e50:	6a 00                	push   $0x0
  801e52:	6a 00                	push   $0x0
  801e54:	6a 0b                	push   $0xb
  801e56:	e8 ce fe ff ff       	call   801d29 <syscall>
  801e5b:	83 c4 18             	add    $0x18,%esp
}
  801e5e:	c9                   	leave  
  801e5f:	c3                   	ret    

00801e60 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801e60:	55                   	push   %ebp
  801e61:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801e63:	6a 00                	push   $0x0
  801e65:	6a 00                	push   $0x0
  801e67:	6a 00                	push   $0x0
  801e69:	ff 75 0c             	pushl  0xc(%ebp)
  801e6c:	ff 75 08             	pushl  0x8(%ebp)
  801e6f:	6a 0f                	push   $0xf
  801e71:	e8 b3 fe ff ff       	call   801d29 <syscall>
  801e76:	83 c4 18             	add    $0x18,%esp
	return;
  801e79:	90                   	nop
}
  801e7a:	c9                   	leave  
  801e7b:	c3                   	ret    

00801e7c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801e7c:	55                   	push   %ebp
  801e7d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	ff 75 0c             	pushl  0xc(%ebp)
  801e88:	ff 75 08             	pushl  0x8(%ebp)
  801e8b:	6a 10                	push   $0x10
  801e8d:	e8 97 fe ff ff       	call   801d29 <syscall>
  801e92:	83 c4 18             	add    $0x18,%esp
	return ;
  801e95:	90                   	nop
}
  801e96:	c9                   	leave  
  801e97:	c3                   	ret    

00801e98 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e98:	55                   	push   %ebp
  801e99:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	ff 75 10             	pushl  0x10(%ebp)
  801ea2:	ff 75 0c             	pushl  0xc(%ebp)
  801ea5:	ff 75 08             	pushl  0x8(%ebp)
  801ea8:	6a 11                	push   $0x11
  801eaa:	e8 7a fe ff ff       	call   801d29 <syscall>
  801eaf:	83 c4 18             	add    $0x18,%esp
	return ;
  801eb2:	90                   	nop
}
  801eb3:	c9                   	leave  
  801eb4:	c3                   	ret    

00801eb5 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801eb5:	55                   	push   %ebp
  801eb6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801eb8:	6a 00                	push   $0x0
  801eba:	6a 00                	push   $0x0
  801ebc:	6a 00                	push   $0x0
  801ebe:	6a 00                	push   $0x0
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 0c                	push   $0xc
  801ec4:	e8 60 fe ff ff       	call   801d29 <syscall>
  801ec9:	83 c4 18             	add    $0x18,%esp
}
  801ecc:	c9                   	leave  
  801ecd:	c3                   	ret    

00801ece <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ece:	55                   	push   %ebp
  801ecf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 00                	push   $0x0
  801ed5:	6a 00                	push   $0x0
  801ed7:	6a 00                	push   $0x0
  801ed9:	ff 75 08             	pushl  0x8(%ebp)
  801edc:	6a 0d                	push   $0xd
  801ede:	e8 46 fe ff ff       	call   801d29 <syscall>
  801ee3:	83 c4 18             	add    $0x18,%esp
}
  801ee6:	c9                   	leave  
  801ee7:	c3                   	ret    

00801ee8 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ee8:	55                   	push   %ebp
  801ee9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801eeb:	6a 00                	push   $0x0
  801eed:	6a 00                	push   $0x0
  801eef:	6a 00                	push   $0x0
  801ef1:	6a 00                	push   $0x0
  801ef3:	6a 00                	push   $0x0
  801ef5:	6a 0e                	push   $0xe
  801ef7:	e8 2d fe ff ff       	call   801d29 <syscall>
  801efc:	83 c4 18             	add    $0x18,%esp
}
  801eff:	90                   	nop
  801f00:	c9                   	leave  
  801f01:	c3                   	ret    

00801f02 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801f02:	55                   	push   %ebp
  801f03:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801f05:	6a 00                	push   $0x0
  801f07:	6a 00                	push   $0x0
  801f09:	6a 00                	push   $0x0
  801f0b:	6a 00                	push   $0x0
  801f0d:	6a 00                	push   $0x0
  801f0f:	6a 13                	push   $0x13
  801f11:	e8 13 fe ff ff       	call   801d29 <syscall>
  801f16:	83 c4 18             	add    $0x18,%esp
}
  801f19:	90                   	nop
  801f1a:	c9                   	leave  
  801f1b:	c3                   	ret    

00801f1c <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801f1c:	55                   	push   %ebp
  801f1d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801f1f:	6a 00                	push   $0x0
  801f21:	6a 00                	push   $0x0
  801f23:	6a 00                	push   $0x0
  801f25:	6a 00                	push   $0x0
  801f27:	6a 00                	push   $0x0
  801f29:	6a 14                	push   $0x14
  801f2b:	e8 f9 fd ff ff       	call   801d29 <syscall>
  801f30:	83 c4 18             	add    $0x18,%esp
}
  801f33:	90                   	nop
  801f34:	c9                   	leave  
  801f35:	c3                   	ret    

00801f36 <sys_cputc>:


void
sys_cputc(const char c)
{
  801f36:	55                   	push   %ebp
  801f37:	89 e5                	mov    %esp,%ebp
  801f39:	83 ec 04             	sub    $0x4,%esp
  801f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801f42:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f46:	6a 00                	push   $0x0
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 00                	push   $0x0
  801f4e:	50                   	push   %eax
  801f4f:	6a 15                	push   $0x15
  801f51:	e8 d3 fd ff ff       	call   801d29 <syscall>
  801f56:	83 c4 18             	add    $0x18,%esp
}
  801f59:	90                   	nop
  801f5a:	c9                   	leave  
  801f5b:	c3                   	ret    

00801f5c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801f5c:	55                   	push   %ebp
  801f5d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801f5f:	6a 00                	push   $0x0
  801f61:	6a 00                	push   $0x0
  801f63:	6a 00                	push   $0x0
  801f65:	6a 00                	push   $0x0
  801f67:	6a 00                	push   $0x0
  801f69:	6a 16                	push   $0x16
  801f6b:	e8 b9 fd ff ff       	call   801d29 <syscall>
  801f70:	83 c4 18             	add    $0x18,%esp
}
  801f73:	90                   	nop
  801f74:	c9                   	leave  
  801f75:	c3                   	ret    

00801f76 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801f76:	55                   	push   %ebp
  801f77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801f79:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7c:	6a 00                	push   $0x0
  801f7e:	6a 00                	push   $0x0
  801f80:	6a 00                	push   $0x0
  801f82:	ff 75 0c             	pushl  0xc(%ebp)
  801f85:	50                   	push   %eax
  801f86:	6a 17                	push   $0x17
  801f88:	e8 9c fd ff ff       	call   801d29 <syscall>
  801f8d:	83 c4 18             	add    $0x18,%esp
}
  801f90:	c9                   	leave  
  801f91:	c3                   	ret    

00801f92 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801f92:	55                   	push   %ebp
  801f93:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f95:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f98:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9b:	6a 00                	push   $0x0
  801f9d:	6a 00                	push   $0x0
  801f9f:	6a 00                	push   $0x0
  801fa1:	52                   	push   %edx
  801fa2:	50                   	push   %eax
  801fa3:	6a 1a                	push   $0x1a
  801fa5:	e8 7f fd ff ff       	call   801d29 <syscall>
  801faa:	83 c4 18             	add    $0x18,%esp
}
  801fad:	c9                   	leave  
  801fae:	c3                   	ret    

00801faf <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801faf:	55                   	push   %ebp
  801fb0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801fb2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb8:	6a 00                	push   $0x0
  801fba:	6a 00                	push   $0x0
  801fbc:	6a 00                	push   $0x0
  801fbe:	52                   	push   %edx
  801fbf:	50                   	push   %eax
  801fc0:	6a 18                	push   $0x18
  801fc2:	e8 62 fd ff ff       	call   801d29 <syscall>
  801fc7:	83 c4 18             	add    $0x18,%esp
}
  801fca:	90                   	nop
  801fcb:	c9                   	leave  
  801fcc:	c3                   	ret    

00801fcd <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801fcd:	55                   	push   %ebp
  801fce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801fd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd6:	6a 00                	push   $0x0
  801fd8:	6a 00                	push   $0x0
  801fda:	6a 00                	push   $0x0
  801fdc:	52                   	push   %edx
  801fdd:	50                   	push   %eax
  801fde:	6a 19                	push   $0x19
  801fe0:	e8 44 fd ff ff       	call   801d29 <syscall>
  801fe5:	83 c4 18             	add    $0x18,%esp
}
  801fe8:	90                   	nop
  801fe9:	c9                   	leave  
  801fea:	c3                   	ret    

00801feb <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801feb:	55                   	push   %ebp
  801fec:	89 e5                	mov    %esp,%ebp
  801fee:	83 ec 04             	sub    $0x4,%esp
  801ff1:	8b 45 10             	mov    0x10(%ebp),%eax
  801ff4:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ff7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ffa:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  802001:	6a 00                	push   $0x0
  802003:	51                   	push   %ecx
  802004:	52                   	push   %edx
  802005:	ff 75 0c             	pushl  0xc(%ebp)
  802008:	50                   	push   %eax
  802009:	6a 1b                	push   $0x1b
  80200b:	e8 19 fd ff ff       	call   801d29 <syscall>
  802010:	83 c4 18             	add    $0x18,%esp
}
  802013:	c9                   	leave  
  802014:	c3                   	ret    

00802015 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802015:	55                   	push   %ebp
  802016:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802018:	8b 55 0c             	mov    0xc(%ebp),%edx
  80201b:	8b 45 08             	mov    0x8(%ebp),%eax
  80201e:	6a 00                	push   $0x0
  802020:	6a 00                	push   $0x0
  802022:	6a 00                	push   $0x0
  802024:	52                   	push   %edx
  802025:	50                   	push   %eax
  802026:	6a 1c                	push   $0x1c
  802028:	e8 fc fc ff ff       	call   801d29 <syscall>
  80202d:	83 c4 18             	add    $0x18,%esp
}
  802030:	c9                   	leave  
  802031:	c3                   	ret    

00802032 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802032:	55                   	push   %ebp
  802033:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802035:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802038:	8b 55 0c             	mov    0xc(%ebp),%edx
  80203b:	8b 45 08             	mov    0x8(%ebp),%eax
  80203e:	6a 00                	push   $0x0
  802040:	6a 00                	push   $0x0
  802042:	51                   	push   %ecx
  802043:	52                   	push   %edx
  802044:	50                   	push   %eax
  802045:	6a 1d                	push   $0x1d
  802047:	e8 dd fc ff ff       	call   801d29 <syscall>
  80204c:	83 c4 18             	add    $0x18,%esp
}
  80204f:	c9                   	leave  
  802050:	c3                   	ret    

00802051 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802051:	55                   	push   %ebp
  802052:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802054:	8b 55 0c             	mov    0xc(%ebp),%edx
  802057:	8b 45 08             	mov    0x8(%ebp),%eax
  80205a:	6a 00                	push   $0x0
  80205c:	6a 00                	push   $0x0
  80205e:	6a 00                	push   $0x0
  802060:	52                   	push   %edx
  802061:	50                   	push   %eax
  802062:	6a 1e                	push   $0x1e
  802064:	e8 c0 fc ff ff       	call   801d29 <syscall>
  802069:	83 c4 18             	add    $0x18,%esp
}
  80206c:	c9                   	leave  
  80206d:	c3                   	ret    

0080206e <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80206e:	55                   	push   %ebp
  80206f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802071:	6a 00                	push   $0x0
  802073:	6a 00                	push   $0x0
  802075:	6a 00                	push   $0x0
  802077:	6a 00                	push   $0x0
  802079:	6a 00                	push   $0x0
  80207b:	6a 1f                	push   $0x1f
  80207d:	e8 a7 fc ff ff       	call   801d29 <syscall>
  802082:	83 c4 18             	add    $0x18,%esp
}
  802085:	c9                   	leave  
  802086:	c3                   	ret    

00802087 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802087:	55                   	push   %ebp
  802088:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80208a:	8b 45 08             	mov    0x8(%ebp),%eax
  80208d:	6a 00                	push   $0x0
  80208f:	ff 75 14             	pushl  0x14(%ebp)
  802092:	ff 75 10             	pushl  0x10(%ebp)
  802095:	ff 75 0c             	pushl  0xc(%ebp)
  802098:	50                   	push   %eax
  802099:	6a 20                	push   $0x20
  80209b:	e8 89 fc ff ff       	call   801d29 <syscall>
  8020a0:	83 c4 18             	add    $0x18,%esp
}
  8020a3:	c9                   	leave  
  8020a4:	c3                   	ret    

008020a5 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8020a5:	55                   	push   %ebp
  8020a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8020a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ab:	6a 00                	push   $0x0
  8020ad:	6a 00                	push   $0x0
  8020af:	6a 00                	push   $0x0
  8020b1:	6a 00                	push   $0x0
  8020b3:	50                   	push   %eax
  8020b4:	6a 21                	push   $0x21
  8020b6:	e8 6e fc ff ff       	call   801d29 <syscall>
  8020bb:	83 c4 18             	add    $0x18,%esp
}
  8020be:	90                   	nop
  8020bf:	c9                   	leave  
  8020c0:	c3                   	ret    

008020c1 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8020c1:	55                   	push   %ebp
  8020c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8020c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c7:	6a 00                	push   $0x0
  8020c9:	6a 00                	push   $0x0
  8020cb:	6a 00                	push   $0x0
  8020cd:	6a 00                	push   $0x0
  8020cf:	50                   	push   %eax
  8020d0:	6a 22                	push   $0x22
  8020d2:	e8 52 fc ff ff       	call   801d29 <syscall>
  8020d7:	83 c4 18             	add    $0x18,%esp
}
  8020da:	c9                   	leave  
  8020db:	c3                   	ret    

008020dc <sys_getenvid>:

int32 sys_getenvid(void)
{
  8020dc:	55                   	push   %ebp
  8020dd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8020df:	6a 00                	push   $0x0
  8020e1:	6a 00                	push   $0x0
  8020e3:	6a 00                	push   $0x0
  8020e5:	6a 00                	push   $0x0
  8020e7:	6a 00                	push   $0x0
  8020e9:	6a 02                	push   $0x2
  8020eb:	e8 39 fc ff ff       	call   801d29 <syscall>
  8020f0:	83 c4 18             	add    $0x18,%esp
}
  8020f3:	c9                   	leave  
  8020f4:	c3                   	ret    

008020f5 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8020f5:	55                   	push   %ebp
  8020f6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8020f8:	6a 00                	push   $0x0
  8020fa:	6a 00                	push   $0x0
  8020fc:	6a 00                	push   $0x0
  8020fe:	6a 00                	push   $0x0
  802100:	6a 00                	push   $0x0
  802102:	6a 03                	push   $0x3
  802104:	e8 20 fc ff ff       	call   801d29 <syscall>
  802109:	83 c4 18             	add    $0x18,%esp
}
  80210c:	c9                   	leave  
  80210d:	c3                   	ret    

0080210e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80210e:	55                   	push   %ebp
  80210f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802111:	6a 00                	push   $0x0
  802113:	6a 00                	push   $0x0
  802115:	6a 00                	push   $0x0
  802117:	6a 00                	push   $0x0
  802119:	6a 00                	push   $0x0
  80211b:	6a 04                	push   $0x4
  80211d:	e8 07 fc ff ff       	call   801d29 <syscall>
  802122:	83 c4 18             	add    $0x18,%esp
}
  802125:	c9                   	leave  
  802126:	c3                   	ret    

00802127 <sys_exit_env>:


void sys_exit_env(void)
{
  802127:	55                   	push   %ebp
  802128:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80212a:	6a 00                	push   $0x0
  80212c:	6a 00                	push   $0x0
  80212e:	6a 00                	push   $0x0
  802130:	6a 00                	push   $0x0
  802132:	6a 00                	push   $0x0
  802134:	6a 23                	push   $0x23
  802136:	e8 ee fb ff ff       	call   801d29 <syscall>
  80213b:	83 c4 18             	add    $0x18,%esp
}
  80213e:	90                   	nop
  80213f:	c9                   	leave  
  802140:	c3                   	ret    

00802141 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802141:	55                   	push   %ebp
  802142:	89 e5                	mov    %esp,%ebp
  802144:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802147:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80214a:	8d 50 04             	lea    0x4(%eax),%edx
  80214d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802150:	6a 00                	push   $0x0
  802152:	6a 00                	push   $0x0
  802154:	6a 00                	push   $0x0
  802156:	52                   	push   %edx
  802157:	50                   	push   %eax
  802158:	6a 24                	push   $0x24
  80215a:	e8 ca fb ff ff       	call   801d29 <syscall>
  80215f:	83 c4 18             	add    $0x18,%esp
	return result;
  802162:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802165:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802168:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80216b:	89 01                	mov    %eax,(%ecx)
  80216d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802170:	8b 45 08             	mov    0x8(%ebp),%eax
  802173:	c9                   	leave  
  802174:	c2 04 00             	ret    $0x4

00802177 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802177:	55                   	push   %ebp
  802178:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80217a:	6a 00                	push   $0x0
  80217c:	6a 00                	push   $0x0
  80217e:	ff 75 10             	pushl  0x10(%ebp)
  802181:	ff 75 0c             	pushl  0xc(%ebp)
  802184:	ff 75 08             	pushl  0x8(%ebp)
  802187:	6a 12                	push   $0x12
  802189:	e8 9b fb ff ff       	call   801d29 <syscall>
  80218e:	83 c4 18             	add    $0x18,%esp
	return ;
  802191:	90                   	nop
}
  802192:	c9                   	leave  
  802193:	c3                   	ret    

00802194 <sys_rcr2>:
uint32 sys_rcr2()
{
  802194:	55                   	push   %ebp
  802195:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802197:	6a 00                	push   $0x0
  802199:	6a 00                	push   $0x0
  80219b:	6a 00                	push   $0x0
  80219d:	6a 00                	push   $0x0
  80219f:	6a 00                	push   $0x0
  8021a1:	6a 25                	push   $0x25
  8021a3:	e8 81 fb ff ff       	call   801d29 <syscall>
  8021a8:	83 c4 18             	add    $0x18,%esp
}
  8021ab:	c9                   	leave  
  8021ac:	c3                   	ret    

008021ad <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8021ad:	55                   	push   %ebp
  8021ae:	89 e5                	mov    %esp,%ebp
  8021b0:	83 ec 04             	sub    $0x4,%esp
  8021b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8021b9:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8021bd:	6a 00                	push   $0x0
  8021bf:	6a 00                	push   $0x0
  8021c1:	6a 00                	push   $0x0
  8021c3:	6a 00                	push   $0x0
  8021c5:	50                   	push   %eax
  8021c6:	6a 26                	push   $0x26
  8021c8:	e8 5c fb ff ff       	call   801d29 <syscall>
  8021cd:	83 c4 18             	add    $0x18,%esp
	return ;
  8021d0:	90                   	nop
}
  8021d1:	c9                   	leave  
  8021d2:	c3                   	ret    

008021d3 <rsttst>:
void rsttst()
{
  8021d3:	55                   	push   %ebp
  8021d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8021d6:	6a 00                	push   $0x0
  8021d8:	6a 00                	push   $0x0
  8021da:	6a 00                	push   $0x0
  8021dc:	6a 00                	push   $0x0
  8021de:	6a 00                	push   $0x0
  8021e0:	6a 28                	push   $0x28
  8021e2:	e8 42 fb ff ff       	call   801d29 <syscall>
  8021e7:	83 c4 18             	add    $0x18,%esp
	return ;
  8021ea:	90                   	nop
}
  8021eb:	c9                   	leave  
  8021ec:	c3                   	ret    

008021ed <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8021ed:	55                   	push   %ebp
  8021ee:	89 e5                	mov    %esp,%ebp
  8021f0:	83 ec 04             	sub    $0x4,%esp
  8021f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8021f6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8021f9:	8b 55 18             	mov    0x18(%ebp),%edx
  8021fc:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802200:	52                   	push   %edx
  802201:	50                   	push   %eax
  802202:	ff 75 10             	pushl  0x10(%ebp)
  802205:	ff 75 0c             	pushl  0xc(%ebp)
  802208:	ff 75 08             	pushl  0x8(%ebp)
  80220b:	6a 27                	push   $0x27
  80220d:	e8 17 fb ff ff       	call   801d29 <syscall>
  802212:	83 c4 18             	add    $0x18,%esp
	return ;
  802215:	90                   	nop
}
  802216:	c9                   	leave  
  802217:	c3                   	ret    

00802218 <chktst>:
void chktst(uint32 n)
{
  802218:	55                   	push   %ebp
  802219:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80221b:	6a 00                	push   $0x0
  80221d:	6a 00                	push   $0x0
  80221f:	6a 00                	push   $0x0
  802221:	6a 00                	push   $0x0
  802223:	ff 75 08             	pushl  0x8(%ebp)
  802226:	6a 29                	push   $0x29
  802228:	e8 fc fa ff ff       	call   801d29 <syscall>
  80222d:	83 c4 18             	add    $0x18,%esp
	return ;
  802230:	90                   	nop
}
  802231:	c9                   	leave  
  802232:	c3                   	ret    

00802233 <inctst>:

void inctst()
{
  802233:	55                   	push   %ebp
  802234:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802236:	6a 00                	push   $0x0
  802238:	6a 00                	push   $0x0
  80223a:	6a 00                	push   $0x0
  80223c:	6a 00                	push   $0x0
  80223e:	6a 00                	push   $0x0
  802240:	6a 2a                	push   $0x2a
  802242:	e8 e2 fa ff ff       	call   801d29 <syscall>
  802247:	83 c4 18             	add    $0x18,%esp
	return ;
  80224a:	90                   	nop
}
  80224b:	c9                   	leave  
  80224c:	c3                   	ret    

0080224d <gettst>:
uint32 gettst()
{
  80224d:	55                   	push   %ebp
  80224e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802250:	6a 00                	push   $0x0
  802252:	6a 00                	push   $0x0
  802254:	6a 00                	push   $0x0
  802256:	6a 00                	push   $0x0
  802258:	6a 00                	push   $0x0
  80225a:	6a 2b                	push   $0x2b
  80225c:	e8 c8 fa ff ff       	call   801d29 <syscall>
  802261:	83 c4 18             	add    $0x18,%esp
}
  802264:	c9                   	leave  
  802265:	c3                   	ret    

00802266 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802266:	55                   	push   %ebp
  802267:	89 e5                	mov    %esp,%ebp
  802269:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80226c:	6a 00                	push   $0x0
  80226e:	6a 00                	push   $0x0
  802270:	6a 00                	push   $0x0
  802272:	6a 00                	push   $0x0
  802274:	6a 00                	push   $0x0
  802276:	6a 2c                	push   $0x2c
  802278:	e8 ac fa ff ff       	call   801d29 <syscall>
  80227d:	83 c4 18             	add    $0x18,%esp
  802280:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802283:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802287:	75 07                	jne    802290 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802289:	b8 01 00 00 00       	mov    $0x1,%eax
  80228e:	eb 05                	jmp    802295 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802290:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802295:	c9                   	leave  
  802296:	c3                   	ret    

00802297 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802297:	55                   	push   %ebp
  802298:	89 e5                	mov    %esp,%ebp
  80229a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80229d:	6a 00                	push   $0x0
  80229f:	6a 00                	push   $0x0
  8022a1:	6a 00                	push   $0x0
  8022a3:	6a 00                	push   $0x0
  8022a5:	6a 00                	push   $0x0
  8022a7:	6a 2c                	push   $0x2c
  8022a9:	e8 7b fa ff ff       	call   801d29 <syscall>
  8022ae:	83 c4 18             	add    $0x18,%esp
  8022b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8022b4:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8022b8:	75 07                	jne    8022c1 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8022ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8022bf:	eb 05                	jmp    8022c6 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8022c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022c6:	c9                   	leave  
  8022c7:	c3                   	ret    

008022c8 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8022c8:	55                   	push   %ebp
  8022c9:	89 e5                	mov    %esp,%ebp
  8022cb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022ce:	6a 00                	push   $0x0
  8022d0:	6a 00                	push   $0x0
  8022d2:	6a 00                	push   $0x0
  8022d4:	6a 00                	push   $0x0
  8022d6:	6a 00                	push   $0x0
  8022d8:	6a 2c                	push   $0x2c
  8022da:	e8 4a fa ff ff       	call   801d29 <syscall>
  8022df:	83 c4 18             	add    $0x18,%esp
  8022e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8022e5:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8022e9:	75 07                	jne    8022f2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8022eb:	b8 01 00 00 00       	mov    $0x1,%eax
  8022f0:	eb 05                	jmp    8022f7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8022f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022f7:	c9                   	leave  
  8022f8:	c3                   	ret    

008022f9 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
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
  80230b:	e8 19 fa ff ff       	call   801d29 <syscall>
  802310:	83 c4 18             	add    $0x18,%esp
  802313:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802316:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80231a:	75 07                	jne    802323 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80231c:	b8 01 00 00 00       	mov    $0x1,%eax
  802321:	eb 05                	jmp    802328 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802323:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802328:	c9                   	leave  
  802329:	c3                   	ret    

0080232a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80232a:	55                   	push   %ebp
  80232b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80232d:	6a 00                	push   $0x0
  80232f:	6a 00                	push   $0x0
  802331:	6a 00                	push   $0x0
  802333:	6a 00                	push   $0x0
  802335:	ff 75 08             	pushl  0x8(%ebp)
  802338:	6a 2d                	push   $0x2d
  80233a:	e8 ea f9 ff ff       	call   801d29 <syscall>
  80233f:	83 c4 18             	add    $0x18,%esp
	return ;
  802342:	90                   	nop
}
  802343:	c9                   	leave  
  802344:	c3                   	ret    

00802345 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802345:	55                   	push   %ebp
  802346:	89 e5                	mov    %esp,%ebp
  802348:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802349:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80234c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80234f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802352:	8b 45 08             	mov    0x8(%ebp),%eax
  802355:	6a 00                	push   $0x0
  802357:	53                   	push   %ebx
  802358:	51                   	push   %ecx
  802359:	52                   	push   %edx
  80235a:	50                   	push   %eax
  80235b:	6a 2e                	push   $0x2e
  80235d:	e8 c7 f9 ff ff       	call   801d29 <syscall>
  802362:	83 c4 18             	add    $0x18,%esp
}
  802365:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802368:	c9                   	leave  
  802369:	c3                   	ret    

0080236a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80236a:	55                   	push   %ebp
  80236b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80236d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802370:	8b 45 08             	mov    0x8(%ebp),%eax
  802373:	6a 00                	push   $0x0
  802375:	6a 00                	push   $0x0
  802377:	6a 00                	push   $0x0
  802379:	52                   	push   %edx
  80237a:	50                   	push   %eax
  80237b:	6a 2f                	push   $0x2f
  80237d:	e8 a7 f9 ff ff       	call   801d29 <syscall>
  802382:	83 c4 18             	add    $0x18,%esp
}
  802385:	c9                   	leave  
  802386:	c3                   	ret    

00802387 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802387:	55                   	push   %ebp
  802388:	89 e5                	mov    %esp,%ebp
  80238a:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80238d:	83 ec 0c             	sub    $0xc,%esp
  802390:	68 d8 44 80 00       	push   $0x8044d8
  802395:	e8 40 e6 ff ff       	call   8009da <cprintf>
  80239a:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80239d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8023a4:	83 ec 0c             	sub    $0xc,%esp
  8023a7:	68 04 45 80 00       	push   $0x804504
  8023ac:	e8 29 e6 ff ff       	call   8009da <cprintf>
  8023b1:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8023b4:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8023b8:	a1 38 51 80 00       	mov    0x805138,%eax
  8023bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023c0:	eb 56                	jmp    802418 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8023c2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023c6:	74 1c                	je     8023e4 <print_mem_block_lists+0x5d>
  8023c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cb:	8b 50 08             	mov    0x8(%eax),%edx
  8023ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d1:	8b 48 08             	mov    0x8(%eax),%ecx
  8023d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8023da:	01 c8                	add    %ecx,%eax
  8023dc:	39 c2                	cmp    %eax,%edx
  8023de:	73 04                	jae    8023e4 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8023e0:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8023e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e7:	8b 50 08             	mov    0x8(%eax),%edx
  8023ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8023f0:	01 c2                	add    %eax,%edx
  8023f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f5:	8b 40 08             	mov    0x8(%eax),%eax
  8023f8:	83 ec 04             	sub    $0x4,%esp
  8023fb:	52                   	push   %edx
  8023fc:	50                   	push   %eax
  8023fd:	68 19 45 80 00       	push   $0x804519
  802402:	e8 d3 e5 ff ff       	call   8009da <cprintf>
  802407:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80240a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802410:	a1 40 51 80 00       	mov    0x805140,%eax
  802415:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802418:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80241c:	74 07                	je     802425 <print_mem_block_lists+0x9e>
  80241e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802421:	8b 00                	mov    (%eax),%eax
  802423:	eb 05                	jmp    80242a <print_mem_block_lists+0xa3>
  802425:	b8 00 00 00 00       	mov    $0x0,%eax
  80242a:	a3 40 51 80 00       	mov    %eax,0x805140
  80242f:	a1 40 51 80 00       	mov    0x805140,%eax
  802434:	85 c0                	test   %eax,%eax
  802436:	75 8a                	jne    8023c2 <print_mem_block_lists+0x3b>
  802438:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80243c:	75 84                	jne    8023c2 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80243e:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802442:	75 10                	jne    802454 <print_mem_block_lists+0xcd>
  802444:	83 ec 0c             	sub    $0xc,%esp
  802447:	68 28 45 80 00       	push   $0x804528
  80244c:	e8 89 e5 ff ff       	call   8009da <cprintf>
  802451:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802454:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80245b:	83 ec 0c             	sub    $0xc,%esp
  80245e:	68 4c 45 80 00       	push   $0x80454c
  802463:	e8 72 e5 ff ff       	call   8009da <cprintf>
  802468:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80246b:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80246f:	a1 40 50 80 00       	mov    0x805040,%eax
  802474:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802477:	eb 56                	jmp    8024cf <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802479:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80247d:	74 1c                	je     80249b <print_mem_block_lists+0x114>
  80247f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802482:	8b 50 08             	mov    0x8(%eax),%edx
  802485:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802488:	8b 48 08             	mov    0x8(%eax),%ecx
  80248b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80248e:	8b 40 0c             	mov    0xc(%eax),%eax
  802491:	01 c8                	add    %ecx,%eax
  802493:	39 c2                	cmp    %eax,%edx
  802495:	73 04                	jae    80249b <print_mem_block_lists+0x114>
			sorted = 0 ;
  802497:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80249b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249e:	8b 50 08             	mov    0x8(%eax),%edx
  8024a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8024a7:	01 c2                	add    %eax,%edx
  8024a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ac:	8b 40 08             	mov    0x8(%eax),%eax
  8024af:	83 ec 04             	sub    $0x4,%esp
  8024b2:	52                   	push   %edx
  8024b3:	50                   	push   %eax
  8024b4:	68 19 45 80 00       	push   $0x804519
  8024b9:	e8 1c e5 ff ff       	call   8009da <cprintf>
  8024be:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8024c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8024c7:	a1 48 50 80 00       	mov    0x805048,%eax
  8024cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024d3:	74 07                	je     8024dc <print_mem_block_lists+0x155>
  8024d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d8:	8b 00                	mov    (%eax),%eax
  8024da:	eb 05                	jmp    8024e1 <print_mem_block_lists+0x15a>
  8024dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8024e1:	a3 48 50 80 00       	mov    %eax,0x805048
  8024e6:	a1 48 50 80 00       	mov    0x805048,%eax
  8024eb:	85 c0                	test   %eax,%eax
  8024ed:	75 8a                	jne    802479 <print_mem_block_lists+0xf2>
  8024ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024f3:	75 84                	jne    802479 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8024f5:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8024f9:	75 10                	jne    80250b <print_mem_block_lists+0x184>
  8024fb:	83 ec 0c             	sub    $0xc,%esp
  8024fe:	68 64 45 80 00       	push   $0x804564
  802503:	e8 d2 e4 ff ff       	call   8009da <cprintf>
  802508:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80250b:	83 ec 0c             	sub    $0xc,%esp
  80250e:	68 d8 44 80 00       	push   $0x8044d8
  802513:	e8 c2 e4 ff ff       	call   8009da <cprintf>
  802518:	83 c4 10             	add    $0x10,%esp

}
  80251b:	90                   	nop
  80251c:	c9                   	leave  
  80251d:	c3                   	ret    

0080251e <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80251e:	55                   	push   %ebp
  80251f:	89 e5                	mov    %esp,%ebp
  802521:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802524:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80252b:	00 00 00 
  80252e:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802535:	00 00 00 
  802538:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80253f:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802542:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802549:	e9 9e 00 00 00       	jmp    8025ec <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  80254e:	a1 50 50 80 00       	mov    0x805050,%eax
  802553:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802556:	c1 e2 04             	shl    $0x4,%edx
  802559:	01 d0                	add    %edx,%eax
  80255b:	85 c0                	test   %eax,%eax
  80255d:	75 14                	jne    802573 <initialize_MemBlocksList+0x55>
  80255f:	83 ec 04             	sub    $0x4,%esp
  802562:	68 8c 45 80 00       	push   $0x80458c
  802567:	6a 46                	push   $0x46
  802569:	68 af 45 80 00       	push   $0x8045af
  80256e:	e8 b3 e1 ff ff       	call   800726 <_panic>
  802573:	a1 50 50 80 00       	mov    0x805050,%eax
  802578:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80257b:	c1 e2 04             	shl    $0x4,%edx
  80257e:	01 d0                	add    %edx,%eax
  802580:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802586:	89 10                	mov    %edx,(%eax)
  802588:	8b 00                	mov    (%eax),%eax
  80258a:	85 c0                	test   %eax,%eax
  80258c:	74 18                	je     8025a6 <initialize_MemBlocksList+0x88>
  80258e:	a1 48 51 80 00       	mov    0x805148,%eax
  802593:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802599:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80259c:	c1 e1 04             	shl    $0x4,%ecx
  80259f:	01 ca                	add    %ecx,%edx
  8025a1:	89 50 04             	mov    %edx,0x4(%eax)
  8025a4:	eb 12                	jmp    8025b8 <initialize_MemBlocksList+0x9a>
  8025a6:	a1 50 50 80 00       	mov    0x805050,%eax
  8025ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025ae:	c1 e2 04             	shl    $0x4,%edx
  8025b1:	01 d0                	add    %edx,%eax
  8025b3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8025b8:	a1 50 50 80 00       	mov    0x805050,%eax
  8025bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025c0:	c1 e2 04             	shl    $0x4,%edx
  8025c3:	01 d0                	add    %edx,%eax
  8025c5:	a3 48 51 80 00       	mov    %eax,0x805148
  8025ca:	a1 50 50 80 00       	mov    0x805050,%eax
  8025cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025d2:	c1 e2 04             	shl    $0x4,%edx
  8025d5:	01 d0                	add    %edx,%eax
  8025d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025de:	a1 54 51 80 00       	mov    0x805154,%eax
  8025e3:	40                   	inc    %eax
  8025e4:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8025e9:	ff 45 f4             	incl   -0xc(%ebp)
  8025ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ef:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025f2:	0f 82 56 ff ff ff    	jb     80254e <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8025f8:	90                   	nop
  8025f9:	c9                   	leave  
  8025fa:	c3                   	ret    

008025fb <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8025fb:	55                   	push   %ebp
  8025fc:	89 e5                	mov    %esp,%ebp
  8025fe:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802601:	8b 45 08             	mov    0x8(%ebp),%eax
  802604:	8b 00                	mov    (%eax),%eax
  802606:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802609:	eb 19                	jmp    802624 <find_block+0x29>
	{
		if(va==point->sva)
  80260b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80260e:	8b 40 08             	mov    0x8(%eax),%eax
  802611:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802614:	75 05                	jne    80261b <find_block+0x20>
		   return point;
  802616:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802619:	eb 36                	jmp    802651 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80261b:	8b 45 08             	mov    0x8(%ebp),%eax
  80261e:	8b 40 08             	mov    0x8(%eax),%eax
  802621:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802624:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802628:	74 07                	je     802631 <find_block+0x36>
  80262a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80262d:	8b 00                	mov    (%eax),%eax
  80262f:	eb 05                	jmp    802636 <find_block+0x3b>
  802631:	b8 00 00 00 00       	mov    $0x0,%eax
  802636:	8b 55 08             	mov    0x8(%ebp),%edx
  802639:	89 42 08             	mov    %eax,0x8(%edx)
  80263c:	8b 45 08             	mov    0x8(%ebp),%eax
  80263f:	8b 40 08             	mov    0x8(%eax),%eax
  802642:	85 c0                	test   %eax,%eax
  802644:	75 c5                	jne    80260b <find_block+0x10>
  802646:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80264a:	75 bf                	jne    80260b <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  80264c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802651:	c9                   	leave  
  802652:	c3                   	ret    

00802653 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802653:	55                   	push   %ebp
  802654:	89 e5                	mov    %esp,%ebp
  802656:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802659:	a1 40 50 80 00       	mov    0x805040,%eax
  80265e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802661:	a1 44 50 80 00       	mov    0x805044,%eax
  802666:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802669:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80266c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80266f:	74 24                	je     802695 <insert_sorted_allocList+0x42>
  802671:	8b 45 08             	mov    0x8(%ebp),%eax
  802674:	8b 50 08             	mov    0x8(%eax),%edx
  802677:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80267a:	8b 40 08             	mov    0x8(%eax),%eax
  80267d:	39 c2                	cmp    %eax,%edx
  80267f:	76 14                	jbe    802695 <insert_sorted_allocList+0x42>
  802681:	8b 45 08             	mov    0x8(%ebp),%eax
  802684:	8b 50 08             	mov    0x8(%eax),%edx
  802687:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80268a:	8b 40 08             	mov    0x8(%eax),%eax
  80268d:	39 c2                	cmp    %eax,%edx
  80268f:	0f 82 60 01 00 00    	jb     8027f5 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802695:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802699:	75 65                	jne    802700 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80269b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80269f:	75 14                	jne    8026b5 <insert_sorted_allocList+0x62>
  8026a1:	83 ec 04             	sub    $0x4,%esp
  8026a4:	68 8c 45 80 00       	push   $0x80458c
  8026a9:	6a 6b                	push   $0x6b
  8026ab:	68 af 45 80 00       	push   $0x8045af
  8026b0:	e8 71 e0 ff ff       	call   800726 <_panic>
  8026b5:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8026bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8026be:	89 10                	mov    %edx,(%eax)
  8026c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c3:	8b 00                	mov    (%eax),%eax
  8026c5:	85 c0                	test   %eax,%eax
  8026c7:	74 0d                	je     8026d6 <insert_sorted_allocList+0x83>
  8026c9:	a1 40 50 80 00       	mov    0x805040,%eax
  8026ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8026d1:	89 50 04             	mov    %edx,0x4(%eax)
  8026d4:	eb 08                	jmp    8026de <insert_sorted_allocList+0x8b>
  8026d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d9:	a3 44 50 80 00       	mov    %eax,0x805044
  8026de:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e1:	a3 40 50 80 00       	mov    %eax,0x805040
  8026e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026f0:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8026f5:	40                   	inc    %eax
  8026f6:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8026fb:	e9 dc 01 00 00       	jmp    8028dc <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802700:	8b 45 08             	mov    0x8(%ebp),%eax
  802703:	8b 50 08             	mov    0x8(%eax),%edx
  802706:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802709:	8b 40 08             	mov    0x8(%eax),%eax
  80270c:	39 c2                	cmp    %eax,%edx
  80270e:	77 6c                	ja     80277c <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802710:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802714:	74 06                	je     80271c <insert_sorted_allocList+0xc9>
  802716:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80271a:	75 14                	jne    802730 <insert_sorted_allocList+0xdd>
  80271c:	83 ec 04             	sub    $0x4,%esp
  80271f:	68 c8 45 80 00       	push   $0x8045c8
  802724:	6a 6f                	push   $0x6f
  802726:	68 af 45 80 00       	push   $0x8045af
  80272b:	e8 f6 df ff ff       	call   800726 <_panic>
  802730:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802733:	8b 50 04             	mov    0x4(%eax),%edx
  802736:	8b 45 08             	mov    0x8(%ebp),%eax
  802739:	89 50 04             	mov    %edx,0x4(%eax)
  80273c:	8b 45 08             	mov    0x8(%ebp),%eax
  80273f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802742:	89 10                	mov    %edx,(%eax)
  802744:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802747:	8b 40 04             	mov    0x4(%eax),%eax
  80274a:	85 c0                	test   %eax,%eax
  80274c:	74 0d                	je     80275b <insert_sorted_allocList+0x108>
  80274e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802751:	8b 40 04             	mov    0x4(%eax),%eax
  802754:	8b 55 08             	mov    0x8(%ebp),%edx
  802757:	89 10                	mov    %edx,(%eax)
  802759:	eb 08                	jmp    802763 <insert_sorted_allocList+0x110>
  80275b:	8b 45 08             	mov    0x8(%ebp),%eax
  80275e:	a3 40 50 80 00       	mov    %eax,0x805040
  802763:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802766:	8b 55 08             	mov    0x8(%ebp),%edx
  802769:	89 50 04             	mov    %edx,0x4(%eax)
  80276c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802771:	40                   	inc    %eax
  802772:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802777:	e9 60 01 00 00       	jmp    8028dc <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80277c:	8b 45 08             	mov    0x8(%ebp),%eax
  80277f:	8b 50 08             	mov    0x8(%eax),%edx
  802782:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802785:	8b 40 08             	mov    0x8(%eax),%eax
  802788:	39 c2                	cmp    %eax,%edx
  80278a:	0f 82 4c 01 00 00    	jb     8028dc <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802790:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802794:	75 14                	jne    8027aa <insert_sorted_allocList+0x157>
  802796:	83 ec 04             	sub    $0x4,%esp
  802799:	68 00 46 80 00       	push   $0x804600
  80279e:	6a 73                	push   $0x73
  8027a0:	68 af 45 80 00       	push   $0x8045af
  8027a5:	e8 7c df ff ff       	call   800726 <_panic>
  8027aa:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8027b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b3:	89 50 04             	mov    %edx,0x4(%eax)
  8027b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b9:	8b 40 04             	mov    0x4(%eax),%eax
  8027bc:	85 c0                	test   %eax,%eax
  8027be:	74 0c                	je     8027cc <insert_sorted_allocList+0x179>
  8027c0:	a1 44 50 80 00       	mov    0x805044,%eax
  8027c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8027c8:	89 10                	mov    %edx,(%eax)
  8027ca:	eb 08                	jmp    8027d4 <insert_sorted_allocList+0x181>
  8027cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027cf:	a3 40 50 80 00       	mov    %eax,0x805040
  8027d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d7:	a3 44 50 80 00       	mov    %eax,0x805044
  8027dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027e5:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8027ea:	40                   	inc    %eax
  8027eb:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8027f0:	e9 e7 00 00 00       	jmp    8028dc <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8027f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8027fb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802802:	a1 40 50 80 00       	mov    0x805040,%eax
  802807:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80280a:	e9 9d 00 00 00       	jmp    8028ac <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80280f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802812:	8b 00                	mov    (%eax),%eax
  802814:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802817:	8b 45 08             	mov    0x8(%ebp),%eax
  80281a:	8b 50 08             	mov    0x8(%eax),%edx
  80281d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802820:	8b 40 08             	mov    0x8(%eax),%eax
  802823:	39 c2                	cmp    %eax,%edx
  802825:	76 7d                	jbe    8028a4 <insert_sorted_allocList+0x251>
  802827:	8b 45 08             	mov    0x8(%ebp),%eax
  80282a:	8b 50 08             	mov    0x8(%eax),%edx
  80282d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802830:	8b 40 08             	mov    0x8(%eax),%eax
  802833:	39 c2                	cmp    %eax,%edx
  802835:	73 6d                	jae    8028a4 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802837:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80283b:	74 06                	je     802843 <insert_sorted_allocList+0x1f0>
  80283d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802841:	75 14                	jne    802857 <insert_sorted_allocList+0x204>
  802843:	83 ec 04             	sub    $0x4,%esp
  802846:	68 24 46 80 00       	push   $0x804624
  80284b:	6a 7f                	push   $0x7f
  80284d:	68 af 45 80 00       	push   $0x8045af
  802852:	e8 cf de ff ff       	call   800726 <_panic>
  802857:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285a:	8b 10                	mov    (%eax),%edx
  80285c:	8b 45 08             	mov    0x8(%ebp),%eax
  80285f:	89 10                	mov    %edx,(%eax)
  802861:	8b 45 08             	mov    0x8(%ebp),%eax
  802864:	8b 00                	mov    (%eax),%eax
  802866:	85 c0                	test   %eax,%eax
  802868:	74 0b                	je     802875 <insert_sorted_allocList+0x222>
  80286a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286d:	8b 00                	mov    (%eax),%eax
  80286f:	8b 55 08             	mov    0x8(%ebp),%edx
  802872:	89 50 04             	mov    %edx,0x4(%eax)
  802875:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802878:	8b 55 08             	mov    0x8(%ebp),%edx
  80287b:	89 10                	mov    %edx,(%eax)
  80287d:	8b 45 08             	mov    0x8(%ebp),%eax
  802880:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802883:	89 50 04             	mov    %edx,0x4(%eax)
  802886:	8b 45 08             	mov    0x8(%ebp),%eax
  802889:	8b 00                	mov    (%eax),%eax
  80288b:	85 c0                	test   %eax,%eax
  80288d:	75 08                	jne    802897 <insert_sorted_allocList+0x244>
  80288f:	8b 45 08             	mov    0x8(%ebp),%eax
  802892:	a3 44 50 80 00       	mov    %eax,0x805044
  802897:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80289c:	40                   	inc    %eax
  80289d:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8028a2:	eb 39                	jmp    8028dd <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8028a4:	a1 48 50 80 00       	mov    0x805048,%eax
  8028a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028b0:	74 07                	je     8028b9 <insert_sorted_allocList+0x266>
  8028b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b5:	8b 00                	mov    (%eax),%eax
  8028b7:	eb 05                	jmp    8028be <insert_sorted_allocList+0x26b>
  8028b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8028be:	a3 48 50 80 00       	mov    %eax,0x805048
  8028c3:	a1 48 50 80 00       	mov    0x805048,%eax
  8028c8:	85 c0                	test   %eax,%eax
  8028ca:	0f 85 3f ff ff ff    	jne    80280f <insert_sorted_allocList+0x1bc>
  8028d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028d4:	0f 85 35 ff ff ff    	jne    80280f <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8028da:	eb 01                	jmp    8028dd <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8028dc:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8028dd:	90                   	nop
  8028de:	c9                   	leave  
  8028df:	c3                   	ret    

008028e0 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8028e0:	55                   	push   %ebp
  8028e1:	89 e5                	mov    %esp,%ebp
  8028e3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8028e6:	a1 38 51 80 00       	mov    0x805138,%eax
  8028eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028ee:	e9 85 01 00 00       	jmp    802a78 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8028f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8028f9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028fc:	0f 82 6e 01 00 00    	jb     802a70 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802902:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802905:	8b 40 0c             	mov    0xc(%eax),%eax
  802908:	3b 45 08             	cmp    0x8(%ebp),%eax
  80290b:	0f 85 8a 00 00 00    	jne    80299b <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802911:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802915:	75 17                	jne    80292e <alloc_block_FF+0x4e>
  802917:	83 ec 04             	sub    $0x4,%esp
  80291a:	68 58 46 80 00       	push   $0x804658
  80291f:	68 93 00 00 00       	push   $0x93
  802924:	68 af 45 80 00       	push   $0x8045af
  802929:	e8 f8 dd ff ff       	call   800726 <_panic>
  80292e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802931:	8b 00                	mov    (%eax),%eax
  802933:	85 c0                	test   %eax,%eax
  802935:	74 10                	je     802947 <alloc_block_FF+0x67>
  802937:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293a:	8b 00                	mov    (%eax),%eax
  80293c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80293f:	8b 52 04             	mov    0x4(%edx),%edx
  802942:	89 50 04             	mov    %edx,0x4(%eax)
  802945:	eb 0b                	jmp    802952 <alloc_block_FF+0x72>
  802947:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294a:	8b 40 04             	mov    0x4(%eax),%eax
  80294d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802952:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802955:	8b 40 04             	mov    0x4(%eax),%eax
  802958:	85 c0                	test   %eax,%eax
  80295a:	74 0f                	je     80296b <alloc_block_FF+0x8b>
  80295c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295f:	8b 40 04             	mov    0x4(%eax),%eax
  802962:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802965:	8b 12                	mov    (%edx),%edx
  802967:	89 10                	mov    %edx,(%eax)
  802969:	eb 0a                	jmp    802975 <alloc_block_FF+0x95>
  80296b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296e:	8b 00                	mov    (%eax),%eax
  802970:	a3 38 51 80 00       	mov    %eax,0x805138
  802975:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802978:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80297e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802981:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802988:	a1 44 51 80 00       	mov    0x805144,%eax
  80298d:	48                   	dec    %eax
  80298e:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802993:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802996:	e9 10 01 00 00       	jmp    802aab <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  80299b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299e:	8b 40 0c             	mov    0xc(%eax),%eax
  8029a1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029a4:	0f 86 c6 00 00 00    	jbe    802a70 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8029aa:	a1 48 51 80 00       	mov    0x805148,%eax
  8029af:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8029b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b5:	8b 50 08             	mov    0x8(%eax),%edx
  8029b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029bb:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8029be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8029c4:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8029c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029cb:	75 17                	jne    8029e4 <alloc_block_FF+0x104>
  8029cd:	83 ec 04             	sub    $0x4,%esp
  8029d0:	68 58 46 80 00       	push   $0x804658
  8029d5:	68 9b 00 00 00       	push   $0x9b
  8029da:	68 af 45 80 00       	push   $0x8045af
  8029df:	e8 42 dd ff ff       	call   800726 <_panic>
  8029e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e7:	8b 00                	mov    (%eax),%eax
  8029e9:	85 c0                	test   %eax,%eax
  8029eb:	74 10                	je     8029fd <alloc_block_FF+0x11d>
  8029ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f0:	8b 00                	mov    (%eax),%eax
  8029f2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029f5:	8b 52 04             	mov    0x4(%edx),%edx
  8029f8:	89 50 04             	mov    %edx,0x4(%eax)
  8029fb:	eb 0b                	jmp    802a08 <alloc_block_FF+0x128>
  8029fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a00:	8b 40 04             	mov    0x4(%eax),%eax
  802a03:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a0b:	8b 40 04             	mov    0x4(%eax),%eax
  802a0e:	85 c0                	test   %eax,%eax
  802a10:	74 0f                	je     802a21 <alloc_block_FF+0x141>
  802a12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a15:	8b 40 04             	mov    0x4(%eax),%eax
  802a18:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a1b:	8b 12                	mov    (%edx),%edx
  802a1d:	89 10                	mov    %edx,(%eax)
  802a1f:	eb 0a                	jmp    802a2b <alloc_block_FF+0x14b>
  802a21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a24:	8b 00                	mov    (%eax),%eax
  802a26:	a3 48 51 80 00       	mov    %eax,0x805148
  802a2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a2e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a37:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a3e:	a1 54 51 80 00       	mov    0x805154,%eax
  802a43:	48                   	dec    %eax
  802a44:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4c:	8b 50 08             	mov    0x8(%eax),%edx
  802a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a52:	01 c2                	add    %eax,%edx
  802a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a57:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5d:	8b 40 0c             	mov    0xc(%eax),%eax
  802a60:	2b 45 08             	sub    0x8(%ebp),%eax
  802a63:	89 c2                	mov    %eax,%edx
  802a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a68:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802a6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a6e:	eb 3b                	jmp    802aab <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802a70:	a1 40 51 80 00       	mov    0x805140,%eax
  802a75:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a78:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a7c:	74 07                	je     802a85 <alloc_block_FF+0x1a5>
  802a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a81:	8b 00                	mov    (%eax),%eax
  802a83:	eb 05                	jmp    802a8a <alloc_block_FF+0x1aa>
  802a85:	b8 00 00 00 00       	mov    $0x0,%eax
  802a8a:	a3 40 51 80 00       	mov    %eax,0x805140
  802a8f:	a1 40 51 80 00       	mov    0x805140,%eax
  802a94:	85 c0                	test   %eax,%eax
  802a96:	0f 85 57 fe ff ff    	jne    8028f3 <alloc_block_FF+0x13>
  802a9c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aa0:	0f 85 4d fe ff ff    	jne    8028f3 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802aa6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802aab:	c9                   	leave  
  802aac:	c3                   	ret    

00802aad <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802aad:	55                   	push   %ebp
  802aae:	89 e5                	mov    %esp,%ebp
  802ab0:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802ab3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802aba:	a1 38 51 80 00       	mov    0x805138,%eax
  802abf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ac2:	e9 df 00 00 00       	jmp    802ba6 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802ac7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aca:	8b 40 0c             	mov    0xc(%eax),%eax
  802acd:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ad0:	0f 82 c8 00 00 00    	jb     802b9e <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad9:	8b 40 0c             	mov    0xc(%eax),%eax
  802adc:	3b 45 08             	cmp    0x8(%ebp),%eax
  802adf:	0f 85 8a 00 00 00    	jne    802b6f <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802ae5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ae9:	75 17                	jne    802b02 <alloc_block_BF+0x55>
  802aeb:	83 ec 04             	sub    $0x4,%esp
  802aee:	68 58 46 80 00       	push   $0x804658
  802af3:	68 b7 00 00 00       	push   $0xb7
  802af8:	68 af 45 80 00       	push   $0x8045af
  802afd:	e8 24 dc ff ff       	call   800726 <_panic>
  802b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b05:	8b 00                	mov    (%eax),%eax
  802b07:	85 c0                	test   %eax,%eax
  802b09:	74 10                	je     802b1b <alloc_block_BF+0x6e>
  802b0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0e:	8b 00                	mov    (%eax),%eax
  802b10:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b13:	8b 52 04             	mov    0x4(%edx),%edx
  802b16:	89 50 04             	mov    %edx,0x4(%eax)
  802b19:	eb 0b                	jmp    802b26 <alloc_block_BF+0x79>
  802b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1e:	8b 40 04             	mov    0x4(%eax),%eax
  802b21:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b29:	8b 40 04             	mov    0x4(%eax),%eax
  802b2c:	85 c0                	test   %eax,%eax
  802b2e:	74 0f                	je     802b3f <alloc_block_BF+0x92>
  802b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b33:	8b 40 04             	mov    0x4(%eax),%eax
  802b36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b39:	8b 12                	mov    (%edx),%edx
  802b3b:	89 10                	mov    %edx,(%eax)
  802b3d:	eb 0a                	jmp    802b49 <alloc_block_BF+0x9c>
  802b3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b42:	8b 00                	mov    (%eax),%eax
  802b44:	a3 38 51 80 00       	mov    %eax,0x805138
  802b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b55:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b5c:	a1 44 51 80 00       	mov    0x805144,%eax
  802b61:	48                   	dec    %eax
  802b62:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802b67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6a:	e9 4d 01 00 00       	jmp    802cbc <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802b6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b72:	8b 40 0c             	mov    0xc(%eax),%eax
  802b75:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b78:	76 24                	jbe    802b9e <alloc_block_BF+0xf1>
  802b7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7d:	8b 40 0c             	mov    0xc(%eax),%eax
  802b80:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802b83:	73 19                	jae    802b9e <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802b85:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802b8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8f:	8b 40 0c             	mov    0xc(%eax),%eax
  802b92:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b98:	8b 40 08             	mov    0x8(%eax),%eax
  802b9b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802b9e:	a1 40 51 80 00       	mov    0x805140,%eax
  802ba3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ba6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802baa:	74 07                	je     802bb3 <alloc_block_BF+0x106>
  802bac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802baf:	8b 00                	mov    (%eax),%eax
  802bb1:	eb 05                	jmp    802bb8 <alloc_block_BF+0x10b>
  802bb3:	b8 00 00 00 00       	mov    $0x0,%eax
  802bb8:	a3 40 51 80 00       	mov    %eax,0x805140
  802bbd:	a1 40 51 80 00       	mov    0x805140,%eax
  802bc2:	85 c0                	test   %eax,%eax
  802bc4:	0f 85 fd fe ff ff    	jne    802ac7 <alloc_block_BF+0x1a>
  802bca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bce:	0f 85 f3 fe ff ff    	jne    802ac7 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802bd4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802bd8:	0f 84 d9 00 00 00    	je     802cb7 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802bde:	a1 48 51 80 00       	mov    0x805148,%eax
  802be3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802be6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802be9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bec:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802bef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bf2:	8b 55 08             	mov    0x8(%ebp),%edx
  802bf5:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802bf8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802bfc:	75 17                	jne    802c15 <alloc_block_BF+0x168>
  802bfe:	83 ec 04             	sub    $0x4,%esp
  802c01:	68 58 46 80 00       	push   $0x804658
  802c06:	68 c7 00 00 00       	push   $0xc7
  802c0b:	68 af 45 80 00       	push   $0x8045af
  802c10:	e8 11 db ff ff       	call   800726 <_panic>
  802c15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c18:	8b 00                	mov    (%eax),%eax
  802c1a:	85 c0                	test   %eax,%eax
  802c1c:	74 10                	je     802c2e <alloc_block_BF+0x181>
  802c1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c21:	8b 00                	mov    (%eax),%eax
  802c23:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c26:	8b 52 04             	mov    0x4(%edx),%edx
  802c29:	89 50 04             	mov    %edx,0x4(%eax)
  802c2c:	eb 0b                	jmp    802c39 <alloc_block_BF+0x18c>
  802c2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c31:	8b 40 04             	mov    0x4(%eax),%eax
  802c34:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c3c:	8b 40 04             	mov    0x4(%eax),%eax
  802c3f:	85 c0                	test   %eax,%eax
  802c41:	74 0f                	je     802c52 <alloc_block_BF+0x1a5>
  802c43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c46:	8b 40 04             	mov    0x4(%eax),%eax
  802c49:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c4c:	8b 12                	mov    (%edx),%edx
  802c4e:	89 10                	mov    %edx,(%eax)
  802c50:	eb 0a                	jmp    802c5c <alloc_block_BF+0x1af>
  802c52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c55:	8b 00                	mov    (%eax),%eax
  802c57:	a3 48 51 80 00       	mov    %eax,0x805148
  802c5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c5f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c65:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c68:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c6f:	a1 54 51 80 00       	mov    0x805154,%eax
  802c74:	48                   	dec    %eax
  802c75:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802c7a:	83 ec 08             	sub    $0x8,%esp
  802c7d:	ff 75 ec             	pushl  -0x14(%ebp)
  802c80:	68 38 51 80 00       	push   $0x805138
  802c85:	e8 71 f9 ff ff       	call   8025fb <find_block>
  802c8a:	83 c4 10             	add    $0x10,%esp
  802c8d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802c90:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c93:	8b 50 08             	mov    0x8(%eax),%edx
  802c96:	8b 45 08             	mov    0x8(%ebp),%eax
  802c99:	01 c2                	add    %eax,%edx
  802c9b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c9e:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802ca1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ca4:	8b 40 0c             	mov    0xc(%eax),%eax
  802ca7:	2b 45 08             	sub    0x8(%ebp),%eax
  802caa:	89 c2                	mov    %eax,%edx
  802cac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802caf:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802cb2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cb5:	eb 05                	jmp    802cbc <alloc_block_BF+0x20f>
	}
	return NULL;
  802cb7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cbc:	c9                   	leave  
  802cbd:	c3                   	ret    

00802cbe <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802cbe:	55                   	push   %ebp
  802cbf:	89 e5                	mov    %esp,%ebp
  802cc1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802cc4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802cc9:	85 c0                	test   %eax,%eax
  802ccb:	0f 85 de 01 00 00    	jne    802eaf <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802cd1:	a1 38 51 80 00       	mov    0x805138,%eax
  802cd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cd9:	e9 9e 01 00 00       	jmp    802e7c <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802cde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ce4:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ce7:	0f 82 87 01 00 00    	jb     802e74 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802ced:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf0:	8b 40 0c             	mov    0xc(%eax),%eax
  802cf3:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cf6:	0f 85 95 00 00 00    	jne    802d91 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802cfc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d00:	75 17                	jne    802d19 <alloc_block_NF+0x5b>
  802d02:	83 ec 04             	sub    $0x4,%esp
  802d05:	68 58 46 80 00       	push   $0x804658
  802d0a:	68 e0 00 00 00       	push   $0xe0
  802d0f:	68 af 45 80 00       	push   $0x8045af
  802d14:	e8 0d da ff ff       	call   800726 <_panic>
  802d19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1c:	8b 00                	mov    (%eax),%eax
  802d1e:	85 c0                	test   %eax,%eax
  802d20:	74 10                	je     802d32 <alloc_block_NF+0x74>
  802d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d25:	8b 00                	mov    (%eax),%eax
  802d27:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d2a:	8b 52 04             	mov    0x4(%edx),%edx
  802d2d:	89 50 04             	mov    %edx,0x4(%eax)
  802d30:	eb 0b                	jmp    802d3d <alloc_block_NF+0x7f>
  802d32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d35:	8b 40 04             	mov    0x4(%eax),%eax
  802d38:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d40:	8b 40 04             	mov    0x4(%eax),%eax
  802d43:	85 c0                	test   %eax,%eax
  802d45:	74 0f                	je     802d56 <alloc_block_NF+0x98>
  802d47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4a:	8b 40 04             	mov    0x4(%eax),%eax
  802d4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d50:	8b 12                	mov    (%edx),%edx
  802d52:	89 10                	mov    %edx,(%eax)
  802d54:	eb 0a                	jmp    802d60 <alloc_block_NF+0xa2>
  802d56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d59:	8b 00                	mov    (%eax),%eax
  802d5b:	a3 38 51 80 00       	mov    %eax,0x805138
  802d60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d63:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d73:	a1 44 51 80 00       	mov    0x805144,%eax
  802d78:	48                   	dec    %eax
  802d79:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d81:	8b 40 08             	mov    0x8(%eax),%eax
  802d84:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   return  point;
  802d89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8c:	e9 f8 04 00 00       	jmp    803289 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802d91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d94:	8b 40 0c             	mov    0xc(%eax),%eax
  802d97:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d9a:	0f 86 d4 00 00 00    	jbe    802e74 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802da0:	a1 48 51 80 00       	mov    0x805148,%eax
  802da5:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802da8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dab:	8b 50 08             	mov    0x8(%eax),%edx
  802dae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db1:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802db4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db7:	8b 55 08             	mov    0x8(%ebp),%edx
  802dba:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802dbd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dc1:	75 17                	jne    802dda <alloc_block_NF+0x11c>
  802dc3:	83 ec 04             	sub    $0x4,%esp
  802dc6:	68 58 46 80 00       	push   $0x804658
  802dcb:	68 e9 00 00 00       	push   $0xe9
  802dd0:	68 af 45 80 00       	push   $0x8045af
  802dd5:	e8 4c d9 ff ff       	call   800726 <_panic>
  802dda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ddd:	8b 00                	mov    (%eax),%eax
  802ddf:	85 c0                	test   %eax,%eax
  802de1:	74 10                	je     802df3 <alloc_block_NF+0x135>
  802de3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de6:	8b 00                	mov    (%eax),%eax
  802de8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802deb:	8b 52 04             	mov    0x4(%edx),%edx
  802dee:	89 50 04             	mov    %edx,0x4(%eax)
  802df1:	eb 0b                	jmp    802dfe <alloc_block_NF+0x140>
  802df3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df6:	8b 40 04             	mov    0x4(%eax),%eax
  802df9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802dfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e01:	8b 40 04             	mov    0x4(%eax),%eax
  802e04:	85 c0                	test   %eax,%eax
  802e06:	74 0f                	je     802e17 <alloc_block_NF+0x159>
  802e08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e0b:	8b 40 04             	mov    0x4(%eax),%eax
  802e0e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e11:	8b 12                	mov    (%edx),%edx
  802e13:	89 10                	mov    %edx,(%eax)
  802e15:	eb 0a                	jmp    802e21 <alloc_block_NF+0x163>
  802e17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e1a:	8b 00                	mov    (%eax),%eax
  802e1c:	a3 48 51 80 00       	mov    %eax,0x805148
  802e21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e24:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e2d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e34:	a1 54 51 80 00       	mov    0x805154,%eax
  802e39:	48                   	dec    %eax
  802e3a:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802e3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e42:	8b 40 08             	mov    0x8(%eax),%eax
  802e45:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   point->sva += size;
  802e4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4d:	8b 50 08             	mov    0x8(%eax),%edx
  802e50:	8b 45 08             	mov    0x8(%ebp),%eax
  802e53:	01 c2                	add    %eax,%edx
  802e55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e58:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802e5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5e:	8b 40 0c             	mov    0xc(%eax),%eax
  802e61:	2b 45 08             	sub    0x8(%ebp),%eax
  802e64:	89 c2                	mov    %eax,%edx
  802e66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e69:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802e6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e6f:	e9 15 04 00 00       	jmp    803289 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802e74:	a1 40 51 80 00       	mov    0x805140,%eax
  802e79:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e80:	74 07                	je     802e89 <alloc_block_NF+0x1cb>
  802e82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e85:	8b 00                	mov    (%eax),%eax
  802e87:	eb 05                	jmp    802e8e <alloc_block_NF+0x1d0>
  802e89:	b8 00 00 00 00       	mov    $0x0,%eax
  802e8e:	a3 40 51 80 00       	mov    %eax,0x805140
  802e93:	a1 40 51 80 00       	mov    0x805140,%eax
  802e98:	85 c0                	test   %eax,%eax
  802e9a:	0f 85 3e fe ff ff    	jne    802cde <alloc_block_NF+0x20>
  802ea0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ea4:	0f 85 34 fe ff ff    	jne    802cde <alloc_block_NF+0x20>
  802eaa:	e9 d5 03 00 00       	jmp    803284 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802eaf:	a1 38 51 80 00       	mov    0x805138,%eax
  802eb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802eb7:	e9 b1 01 00 00       	jmp    80306d <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802ebc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebf:	8b 50 08             	mov    0x8(%eax),%edx
  802ec2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802ec7:	39 c2                	cmp    %eax,%edx
  802ec9:	0f 82 96 01 00 00    	jb     803065 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802ecf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed2:	8b 40 0c             	mov    0xc(%eax),%eax
  802ed5:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ed8:	0f 82 87 01 00 00    	jb     803065 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802ede:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ee4:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ee7:	0f 85 95 00 00 00    	jne    802f82 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802eed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ef1:	75 17                	jne    802f0a <alloc_block_NF+0x24c>
  802ef3:	83 ec 04             	sub    $0x4,%esp
  802ef6:	68 58 46 80 00       	push   $0x804658
  802efb:	68 fc 00 00 00       	push   $0xfc
  802f00:	68 af 45 80 00       	push   $0x8045af
  802f05:	e8 1c d8 ff ff       	call   800726 <_panic>
  802f0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0d:	8b 00                	mov    (%eax),%eax
  802f0f:	85 c0                	test   %eax,%eax
  802f11:	74 10                	je     802f23 <alloc_block_NF+0x265>
  802f13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f16:	8b 00                	mov    (%eax),%eax
  802f18:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f1b:	8b 52 04             	mov    0x4(%edx),%edx
  802f1e:	89 50 04             	mov    %edx,0x4(%eax)
  802f21:	eb 0b                	jmp    802f2e <alloc_block_NF+0x270>
  802f23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f26:	8b 40 04             	mov    0x4(%eax),%eax
  802f29:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f31:	8b 40 04             	mov    0x4(%eax),%eax
  802f34:	85 c0                	test   %eax,%eax
  802f36:	74 0f                	je     802f47 <alloc_block_NF+0x289>
  802f38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3b:	8b 40 04             	mov    0x4(%eax),%eax
  802f3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f41:	8b 12                	mov    (%edx),%edx
  802f43:	89 10                	mov    %edx,(%eax)
  802f45:	eb 0a                	jmp    802f51 <alloc_block_NF+0x293>
  802f47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4a:	8b 00                	mov    (%eax),%eax
  802f4c:	a3 38 51 80 00       	mov    %eax,0x805138
  802f51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f54:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f64:	a1 44 51 80 00       	mov    0x805144,%eax
  802f69:	48                   	dec    %eax
  802f6a:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f72:	8b 40 08             	mov    0x8(%eax),%eax
  802f75:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  802f7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7d:	e9 07 03 00 00       	jmp    803289 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802f82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f85:	8b 40 0c             	mov    0xc(%eax),%eax
  802f88:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f8b:	0f 86 d4 00 00 00    	jbe    803065 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802f91:	a1 48 51 80 00       	mov    0x805148,%eax
  802f96:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802f99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9c:	8b 50 08             	mov    0x8(%eax),%edx
  802f9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fa2:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802fa5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fa8:	8b 55 08             	mov    0x8(%ebp),%edx
  802fab:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802fae:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fb2:	75 17                	jne    802fcb <alloc_block_NF+0x30d>
  802fb4:	83 ec 04             	sub    $0x4,%esp
  802fb7:	68 58 46 80 00       	push   $0x804658
  802fbc:	68 04 01 00 00       	push   $0x104
  802fc1:	68 af 45 80 00       	push   $0x8045af
  802fc6:	e8 5b d7 ff ff       	call   800726 <_panic>
  802fcb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fce:	8b 00                	mov    (%eax),%eax
  802fd0:	85 c0                	test   %eax,%eax
  802fd2:	74 10                	je     802fe4 <alloc_block_NF+0x326>
  802fd4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fd7:	8b 00                	mov    (%eax),%eax
  802fd9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fdc:	8b 52 04             	mov    0x4(%edx),%edx
  802fdf:	89 50 04             	mov    %edx,0x4(%eax)
  802fe2:	eb 0b                	jmp    802fef <alloc_block_NF+0x331>
  802fe4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe7:	8b 40 04             	mov    0x4(%eax),%eax
  802fea:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff2:	8b 40 04             	mov    0x4(%eax),%eax
  802ff5:	85 c0                	test   %eax,%eax
  802ff7:	74 0f                	je     803008 <alloc_block_NF+0x34a>
  802ff9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ffc:	8b 40 04             	mov    0x4(%eax),%eax
  802fff:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803002:	8b 12                	mov    (%edx),%edx
  803004:	89 10                	mov    %edx,(%eax)
  803006:	eb 0a                	jmp    803012 <alloc_block_NF+0x354>
  803008:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80300b:	8b 00                	mov    (%eax),%eax
  80300d:	a3 48 51 80 00       	mov    %eax,0x805148
  803012:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803015:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80301b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80301e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803025:	a1 54 51 80 00       	mov    0x805154,%eax
  80302a:	48                   	dec    %eax
  80302b:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803030:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803033:	8b 40 08             	mov    0x8(%eax),%eax
  803036:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  80303b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303e:	8b 50 08             	mov    0x8(%eax),%edx
  803041:	8b 45 08             	mov    0x8(%ebp),%eax
  803044:	01 c2                	add    %eax,%edx
  803046:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803049:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80304c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304f:	8b 40 0c             	mov    0xc(%eax),%eax
  803052:	2b 45 08             	sub    0x8(%ebp),%eax
  803055:	89 c2                	mov    %eax,%edx
  803057:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305a:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  80305d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803060:	e9 24 02 00 00       	jmp    803289 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803065:	a1 40 51 80 00       	mov    0x805140,%eax
  80306a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80306d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803071:	74 07                	je     80307a <alloc_block_NF+0x3bc>
  803073:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803076:	8b 00                	mov    (%eax),%eax
  803078:	eb 05                	jmp    80307f <alloc_block_NF+0x3c1>
  80307a:	b8 00 00 00 00       	mov    $0x0,%eax
  80307f:	a3 40 51 80 00       	mov    %eax,0x805140
  803084:	a1 40 51 80 00       	mov    0x805140,%eax
  803089:	85 c0                	test   %eax,%eax
  80308b:	0f 85 2b fe ff ff    	jne    802ebc <alloc_block_NF+0x1fe>
  803091:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803095:	0f 85 21 fe ff ff    	jne    802ebc <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  80309b:	a1 38 51 80 00       	mov    0x805138,%eax
  8030a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030a3:	e9 ae 01 00 00       	jmp    803256 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8030a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ab:	8b 50 08             	mov    0x8(%eax),%edx
  8030ae:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030b3:	39 c2                	cmp    %eax,%edx
  8030b5:	0f 83 93 01 00 00    	jae    80324e <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  8030bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030be:	8b 40 0c             	mov    0xc(%eax),%eax
  8030c1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030c4:	0f 82 84 01 00 00    	jb     80324e <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  8030ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8030d0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030d3:	0f 85 95 00 00 00    	jne    80316e <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8030d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030dd:	75 17                	jne    8030f6 <alloc_block_NF+0x438>
  8030df:	83 ec 04             	sub    $0x4,%esp
  8030e2:	68 58 46 80 00       	push   $0x804658
  8030e7:	68 14 01 00 00       	push   $0x114
  8030ec:	68 af 45 80 00       	push   $0x8045af
  8030f1:	e8 30 d6 ff ff       	call   800726 <_panic>
  8030f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f9:	8b 00                	mov    (%eax),%eax
  8030fb:	85 c0                	test   %eax,%eax
  8030fd:	74 10                	je     80310f <alloc_block_NF+0x451>
  8030ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803102:	8b 00                	mov    (%eax),%eax
  803104:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803107:	8b 52 04             	mov    0x4(%edx),%edx
  80310a:	89 50 04             	mov    %edx,0x4(%eax)
  80310d:	eb 0b                	jmp    80311a <alloc_block_NF+0x45c>
  80310f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803112:	8b 40 04             	mov    0x4(%eax),%eax
  803115:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80311a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80311d:	8b 40 04             	mov    0x4(%eax),%eax
  803120:	85 c0                	test   %eax,%eax
  803122:	74 0f                	je     803133 <alloc_block_NF+0x475>
  803124:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803127:	8b 40 04             	mov    0x4(%eax),%eax
  80312a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80312d:	8b 12                	mov    (%edx),%edx
  80312f:	89 10                	mov    %edx,(%eax)
  803131:	eb 0a                	jmp    80313d <alloc_block_NF+0x47f>
  803133:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803136:	8b 00                	mov    (%eax),%eax
  803138:	a3 38 51 80 00       	mov    %eax,0x805138
  80313d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803140:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803146:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803149:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803150:	a1 44 51 80 00       	mov    0x805144,%eax
  803155:	48                   	dec    %eax
  803156:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  80315b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315e:	8b 40 08             	mov    0x8(%eax),%eax
  803161:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  803166:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803169:	e9 1b 01 00 00       	jmp    803289 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80316e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803171:	8b 40 0c             	mov    0xc(%eax),%eax
  803174:	3b 45 08             	cmp    0x8(%ebp),%eax
  803177:	0f 86 d1 00 00 00    	jbe    80324e <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80317d:	a1 48 51 80 00       	mov    0x805148,%eax
  803182:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  803185:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803188:	8b 50 08             	mov    0x8(%eax),%edx
  80318b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80318e:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803191:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803194:	8b 55 08             	mov    0x8(%ebp),%edx
  803197:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80319a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80319e:	75 17                	jne    8031b7 <alloc_block_NF+0x4f9>
  8031a0:	83 ec 04             	sub    $0x4,%esp
  8031a3:	68 58 46 80 00       	push   $0x804658
  8031a8:	68 1c 01 00 00       	push   $0x11c
  8031ad:	68 af 45 80 00       	push   $0x8045af
  8031b2:	e8 6f d5 ff ff       	call   800726 <_panic>
  8031b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031ba:	8b 00                	mov    (%eax),%eax
  8031bc:	85 c0                	test   %eax,%eax
  8031be:	74 10                	je     8031d0 <alloc_block_NF+0x512>
  8031c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031c3:	8b 00                	mov    (%eax),%eax
  8031c5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8031c8:	8b 52 04             	mov    0x4(%edx),%edx
  8031cb:	89 50 04             	mov    %edx,0x4(%eax)
  8031ce:	eb 0b                	jmp    8031db <alloc_block_NF+0x51d>
  8031d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031d3:	8b 40 04             	mov    0x4(%eax),%eax
  8031d6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031de:	8b 40 04             	mov    0x4(%eax),%eax
  8031e1:	85 c0                	test   %eax,%eax
  8031e3:	74 0f                	je     8031f4 <alloc_block_NF+0x536>
  8031e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031e8:	8b 40 04             	mov    0x4(%eax),%eax
  8031eb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8031ee:	8b 12                	mov    (%edx),%edx
  8031f0:	89 10                	mov    %edx,(%eax)
  8031f2:	eb 0a                	jmp    8031fe <alloc_block_NF+0x540>
  8031f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031f7:	8b 00                	mov    (%eax),%eax
  8031f9:	a3 48 51 80 00       	mov    %eax,0x805148
  8031fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803201:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803207:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80320a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803211:	a1 54 51 80 00       	mov    0x805154,%eax
  803216:	48                   	dec    %eax
  803217:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  80321c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80321f:	8b 40 08             	mov    0x8(%eax),%eax
  803222:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  803227:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322a:	8b 50 08             	mov    0x8(%eax),%edx
  80322d:	8b 45 08             	mov    0x8(%ebp),%eax
  803230:	01 c2                	add    %eax,%edx
  803232:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803235:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803238:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80323b:	8b 40 0c             	mov    0xc(%eax),%eax
  80323e:	2b 45 08             	sub    0x8(%ebp),%eax
  803241:	89 c2                	mov    %eax,%edx
  803243:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803246:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803249:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80324c:	eb 3b                	jmp    803289 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  80324e:	a1 40 51 80 00       	mov    0x805140,%eax
  803253:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803256:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80325a:	74 07                	je     803263 <alloc_block_NF+0x5a5>
  80325c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325f:	8b 00                	mov    (%eax),%eax
  803261:	eb 05                	jmp    803268 <alloc_block_NF+0x5aa>
  803263:	b8 00 00 00 00       	mov    $0x0,%eax
  803268:	a3 40 51 80 00       	mov    %eax,0x805140
  80326d:	a1 40 51 80 00       	mov    0x805140,%eax
  803272:	85 c0                	test   %eax,%eax
  803274:	0f 85 2e fe ff ff    	jne    8030a8 <alloc_block_NF+0x3ea>
  80327a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80327e:	0f 85 24 fe ff ff    	jne    8030a8 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  803284:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803289:	c9                   	leave  
  80328a:	c3                   	ret    

0080328b <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80328b:	55                   	push   %ebp
  80328c:	89 e5                	mov    %esp,%ebp
  80328e:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  803291:	a1 38 51 80 00       	mov    0x805138,%eax
  803296:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  803299:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80329e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  8032a1:	a1 38 51 80 00       	mov    0x805138,%eax
  8032a6:	85 c0                	test   %eax,%eax
  8032a8:	74 14                	je     8032be <insert_sorted_with_merge_freeList+0x33>
  8032aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ad:	8b 50 08             	mov    0x8(%eax),%edx
  8032b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032b3:	8b 40 08             	mov    0x8(%eax),%eax
  8032b6:	39 c2                	cmp    %eax,%edx
  8032b8:	0f 87 9b 01 00 00    	ja     803459 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  8032be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032c2:	75 17                	jne    8032db <insert_sorted_with_merge_freeList+0x50>
  8032c4:	83 ec 04             	sub    $0x4,%esp
  8032c7:	68 8c 45 80 00       	push   $0x80458c
  8032cc:	68 38 01 00 00       	push   $0x138
  8032d1:	68 af 45 80 00       	push   $0x8045af
  8032d6:	e8 4b d4 ff ff       	call   800726 <_panic>
  8032db:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8032e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e4:	89 10                	mov    %edx,(%eax)
  8032e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e9:	8b 00                	mov    (%eax),%eax
  8032eb:	85 c0                	test   %eax,%eax
  8032ed:	74 0d                	je     8032fc <insert_sorted_with_merge_freeList+0x71>
  8032ef:	a1 38 51 80 00       	mov    0x805138,%eax
  8032f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8032f7:	89 50 04             	mov    %edx,0x4(%eax)
  8032fa:	eb 08                	jmp    803304 <insert_sorted_with_merge_freeList+0x79>
  8032fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ff:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803304:	8b 45 08             	mov    0x8(%ebp),%eax
  803307:	a3 38 51 80 00       	mov    %eax,0x805138
  80330c:	8b 45 08             	mov    0x8(%ebp),%eax
  80330f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803316:	a1 44 51 80 00       	mov    0x805144,%eax
  80331b:	40                   	inc    %eax
  80331c:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803321:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803325:	0f 84 a8 06 00 00    	je     8039d3 <insert_sorted_with_merge_freeList+0x748>
  80332b:	8b 45 08             	mov    0x8(%ebp),%eax
  80332e:	8b 50 08             	mov    0x8(%eax),%edx
  803331:	8b 45 08             	mov    0x8(%ebp),%eax
  803334:	8b 40 0c             	mov    0xc(%eax),%eax
  803337:	01 c2                	add    %eax,%edx
  803339:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80333c:	8b 40 08             	mov    0x8(%eax),%eax
  80333f:	39 c2                	cmp    %eax,%edx
  803341:	0f 85 8c 06 00 00    	jne    8039d3 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  803347:	8b 45 08             	mov    0x8(%ebp),%eax
  80334a:	8b 50 0c             	mov    0xc(%eax),%edx
  80334d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803350:	8b 40 0c             	mov    0xc(%eax),%eax
  803353:	01 c2                	add    %eax,%edx
  803355:	8b 45 08             	mov    0x8(%ebp),%eax
  803358:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  80335b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80335f:	75 17                	jne    803378 <insert_sorted_with_merge_freeList+0xed>
  803361:	83 ec 04             	sub    $0x4,%esp
  803364:	68 58 46 80 00       	push   $0x804658
  803369:	68 3c 01 00 00       	push   $0x13c
  80336e:	68 af 45 80 00       	push   $0x8045af
  803373:	e8 ae d3 ff ff       	call   800726 <_panic>
  803378:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80337b:	8b 00                	mov    (%eax),%eax
  80337d:	85 c0                	test   %eax,%eax
  80337f:	74 10                	je     803391 <insert_sorted_with_merge_freeList+0x106>
  803381:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803384:	8b 00                	mov    (%eax),%eax
  803386:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803389:	8b 52 04             	mov    0x4(%edx),%edx
  80338c:	89 50 04             	mov    %edx,0x4(%eax)
  80338f:	eb 0b                	jmp    80339c <insert_sorted_with_merge_freeList+0x111>
  803391:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803394:	8b 40 04             	mov    0x4(%eax),%eax
  803397:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80339c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80339f:	8b 40 04             	mov    0x4(%eax),%eax
  8033a2:	85 c0                	test   %eax,%eax
  8033a4:	74 0f                	je     8033b5 <insert_sorted_with_merge_freeList+0x12a>
  8033a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033a9:	8b 40 04             	mov    0x4(%eax),%eax
  8033ac:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033af:	8b 12                	mov    (%edx),%edx
  8033b1:	89 10                	mov    %edx,(%eax)
  8033b3:	eb 0a                	jmp    8033bf <insert_sorted_with_merge_freeList+0x134>
  8033b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033b8:	8b 00                	mov    (%eax),%eax
  8033ba:	a3 38 51 80 00       	mov    %eax,0x805138
  8033bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033cb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033d2:	a1 44 51 80 00       	mov    0x805144,%eax
  8033d7:	48                   	dec    %eax
  8033d8:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  8033dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033e0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  8033e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ea:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  8033f1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033f5:	75 17                	jne    80340e <insert_sorted_with_merge_freeList+0x183>
  8033f7:	83 ec 04             	sub    $0x4,%esp
  8033fa:	68 8c 45 80 00       	push   $0x80458c
  8033ff:	68 3f 01 00 00       	push   $0x13f
  803404:	68 af 45 80 00       	push   $0x8045af
  803409:	e8 18 d3 ff ff       	call   800726 <_panic>
  80340e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803414:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803417:	89 10                	mov    %edx,(%eax)
  803419:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80341c:	8b 00                	mov    (%eax),%eax
  80341e:	85 c0                	test   %eax,%eax
  803420:	74 0d                	je     80342f <insert_sorted_with_merge_freeList+0x1a4>
  803422:	a1 48 51 80 00       	mov    0x805148,%eax
  803427:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80342a:	89 50 04             	mov    %edx,0x4(%eax)
  80342d:	eb 08                	jmp    803437 <insert_sorted_with_merge_freeList+0x1ac>
  80342f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803432:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803437:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80343a:	a3 48 51 80 00       	mov    %eax,0x805148
  80343f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803442:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803449:	a1 54 51 80 00       	mov    0x805154,%eax
  80344e:	40                   	inc    %eax
  80344f:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803454:	e9 7a 05 00 00       	jmp    8039d3 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803459:	8b 45 08             	mov    0x8(%ebp),%eax
  80345c:	8b 50 08             	mov    0x8(%eax),%edx
  80345f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803462:	8b 40 08             	mov    0x8(%eax),%eax
  803465:	39 c2                	cmp    %eax,%edx
  803467:	0f 82 14 01 00 00    	jb     803581 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  80346d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803470:	8b 50 08             	mov    0x8(%eax),%edx
  803473:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803476:	8b 40 0c             	mov    0xc(%eax),%eax
  803479:	01 c2                	add    %eax,%edx
  80347b:	8b 45 08             	mov    0x8(%ebp),%eax
  80347e:	8b 40 08             	mov    0x8(%eax),%eax
  803481:	39 c2                	cmp    %eax,%edx
  803483:	0f 85 90 00 00 00    	jne    803519 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803489:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80348c:	8b 50 0c             	mov    0xc(%eax),%edx
  80348f:	8b 45 08             	mov    0x8(%ebp),%eax
  803492:	8b 40 0c             	mov    0xc(%eax),%eax
  803495:	01 c2                	add    %eax,%edx
  803497:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80349a:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  80349d:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8034a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034aa:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8034b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034b5:	75 17                	jne    8034ce <insert_sorted_with_merge_freeList+0x243>
  8034b7:	83 ec 04             	sub    $0x4,%esp
  8034ba:	68 8c 45 80 00       	push   $0x80458c
  8034bf:	68 49 01 00 00       	push   $0x149
  8034c4:	68 af 45 80 00       	push   $0x8045af
  8034c9:	e8 58 d2 ff ff       	call   800726 <_panic>
  8034ce:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d7:	89 10                	mov    %edx,(%eax)
  8034d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034dc:	8b 00                	mov    (%eax),%eax
  8034de:	85 c0                	test   %eax,%eax
  8034e0:	74 0d                	je     8034ef <insert_sorted_with_merge_freeList+0x264>
  8034e2:	a1 48 51 80 00       	mov    0x805148,%eax
  8034e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8034ea:	89 50 04             	mov    %edx,0x4(%eax)
  8034ed:	eb 08                	jmp    8034f7 <insert_sorted_with_merge_freeList+0x26c>
  8034ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fa:	a3 48 51 80 00       	mov    %eax,0x805148
  8034ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803502:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803509:	a1 54 51 80 00       	mov    0x805154,%eax
  80350e:	40                   	inc    %eax
  80350f:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803514:	e9 bb 04 00 00       	jmp    8039d4 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803519:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80351d:	75 17                	jne    803536 <insert_sorted_with_merge_freeList+0x2ab>
  80351f:	83 ec 04             	sub    $0x4,%esp
  803522:	68 00 46 80 00       	push   $0x804600
  803527:	68 4c 01 00 00       	push   $0x14c
  80352c:	68 af 45 80 00       	push   $0x8045af
  803531:	e8 f0 d1 ff ff       	call   800726 <_panic>
  803536:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80353c:	8b 45 08             	mov    0x8(%ebp),%eax
  80353f:	89 50 04             	mov    %edx,0x4(%eax)
  803542:	8b 45 08             	mov    0x8(%ebp),%eax
  803545:	8b 40 04             	mov    0x4(%eax),%eax
  803548:	85 c0                	test   %eax,%eax
  80354a:	74 0c                	je     803558 <insert_sorted_with_merge_freeList+0x2cd>
  80354c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803551:	8b 55 08             	mov    0x8(%ebp),%edx
  803554:	89 10                	mov    %edx,(%eax)
  803556:	eb 08                	jmp    803560 <insert_sorted_with_merge_freeList+0x2d5>
  803558:	8b 45 08             	mov    0x8(%ebp),%eax
  80355b:	a3 38 51 80 00       	mov    %eax,0x805138
  803560:	8b 45 08             	mov    0x8(%ebp),%eax
  803563:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803568:	8b 45 08             	mov    0x8(%ebp),%eax
  80356b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803571:	a1 44 51 80 00       	mov    0x805144,%eax
  803576:	40                   	inc    %eax
  803577:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80357c:	e9 53 04 00 00       	jmp    8039d4 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803581:	a1 38 51 80 00       	mov    0x805138,%eax
  803586:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803589:	e9 15 04 00 00       	jmp    8039a3 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  80358e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803591:	8b 00                	mov    (%eax),%eax
  803593:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803596:	8b 45 08             	mov    0x8(%ebp),%eax
  803599:	8b 50 08             	mov    0x8(%eax),%edx
  80359c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80359f:	8b 40 08             	mov    0x8(%eax),%eax
  8035a2:	39 c2                	cmp    %eax,%edx
  8035a4:	0f 86 f1 03 00 00    	jbe    80399b <insert_sorted_with_merge_freeList+0x710>
  8035aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ad:	8b 50 08             	mov    0x8(%eax),%edx
  8035b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035b3:	8b 40 08             	mov    0x8(%eax),%eax
  8035b6:	39 c2                	cmp    %eax,%edx
  8035b8:	0f 83 dd 03 00 00    	jae    80399b <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8035be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c1:	8b 50 08             	mov    0x8(%eax),%edx
  8035c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8035ca:	01 c2                	add    %eax,%edx
  8035cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8035cf:	8b 40 08             	mov    0x8(%eax),%eax
  8035d2:	39 c2                	cmp    %eax,%edx
  8035d4:	0f 85 b9 01 00 00    	jne    803793 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8035da:	8b 45 08             	mov    0x8(%ebp),%eax
  8035dd:	8b 50 08             	mov    0x8(%eax),%edx
  8035e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e3:	8b 40 0c             	mov    0xc(%eax),%eax
  8035e6:	01 c2                	add    %eax,%edx
  8035e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035eb:	8b 40 08             	mov    0x8(%eax),%eax
  8035ee:	39 c2                	cmp    %eax,%edx
  8035f0:	0f 85 0d 01 00 00    	jne    803703 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8035f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f9:	8b 50 0c             	mov    0xc(%eax),%edx
  8035fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035ff:	8b 40 0c             	mov    0xc(%eax),%eax
  803602:	01 c2                	add    %eax,%edx
  803604:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803607:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80360a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80360e:	75 17                	jne    803627 <insert_sorted_with_merge_freeList+0x39c>
  803610:	83 ec 04             	sub    $0x4,%esp
  803613:	68 58 46 80 00       	push   $0x804658
  803618:	68 5c 01 00 00       	push   $0x15c
  80361d:	68 af 45 80 00       	push   $0x8045af
  803622:	e8 ff d0 ff ff       	call   800726 <_panic>
  803627:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80362a:	8b 00                	mov    (%eax),%eax
  80362c:	85 c0                	test   %eax,%eax
  80362e:	74 10                	je     803640 <insert_sorted_with_merge_freeList+0x3b5>
  803630:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803633:	8b 00                	mov    (%eax),%eax
  803635:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803638:	8b 52 04             	mov    0x4(%edx),%edx
  80363b:	89 50 04             	mov    %edx,0x4(%eax)
  80363e:	eb 0b                	jmp    80364b <insert_sorted_with_merge_freeList+0x3c0>
  803640:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803643:	8b 40 04             	mov    0x4(%eax),%eax
  803646:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80364b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80364e:	8b 40 04             	mov    0x4(%eax),%eax
  803651:	85 c0                	test   %eax,%eax
  803653:	74 0f                	je     803664 <insert_sorted_with_merge_freeList+0x3d9>
  803655:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803658:	8b 40 04             	mov    0x4(%eax),%eax
  80365b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80365e:	8b 12                	mov    (%edx),%edx
  803660:	89 10                	mov    %edx,(%eax)
  803662:	eb 0a                	jmp    80366e <insert_sorted_with_merge_freeList+0x3e3>
  803664:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803667:	8b 00                	mov    (%eax),%eax
  803669:	a3 38 51 80 00       	mov    %eax,0x805138
  80366e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803671:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803677:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80367a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803681:	a1 44 51 80 00       	mov    0x805144,%eax
  803686:	48                   	dec    %eax
  803687:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  80368c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80368f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803696:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803699:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8036a0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8036a4:	75 17                	jne    8036bd <insert_sorted_with_merge_freeList+0x432>
  8036a6:	83 ec 04             	sub    $0x4,%esp
  8036a9:	68 8c 45 80 00       	push   $0x80458c
  8036ae:	68 5f 01 00 00       	push   $0x15f
  8036b3:	68 af 45 80 00       	push   $0x8045af
  8036b8:	e8 69 d0 ff ff       	call   800726 <_panic>
  8036bd:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8036c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036c6:	89 10                	mov    %edx,(%eax)
  8036c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036cb:	8b 00                	mov    (%eax),%eax
  8036cd:	85 c0                	test   %eax,%eax
  8036cf:	74 0d                	je     8036de <insert_sorted_with_merge_freeList+0x453>
  8036d1:	a1 48 51 80 00       	mov    0x805148,%eax
  8036d6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036d9:	89 50 04             	mov    %edx,0x4(%eax)
  8036dc:	eb 08                	jmp    8036e6 <insert_sorted_with_merge_freeList+0x45b>
  8036de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036e1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036e9:	a3 48 51 80 00       	mov    %eax,0x805148
  8036ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036f1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036f8:	a1 54 51 80 00       	mov    0x805154,%eax
  8036fd:	40                   	inc    %eax
  8036fe:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803703:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803706:	8b 50 0c             	mov    0xc(%eax),%edx
  803709:	8b 45 08             	mov    0x8(%ebp),%eax
  80370c:	8b 40 0c             	mov    0xc(%eax),%eax
  80370f:	01 c2                	add    %eax,%edx
  803711:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803714:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803717:	8b 45 08             	mov    0x8(%ebp),%eax
  80371a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803721:	8b 45 08             	mov    0x8(%ebp),%eax
  803724:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80372b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80372f:	75 17                	jne    803748 <insert_sorted_with_merge_freeList+0x4bd>
  803731:	83 ec 04             	sub    $0x4,%esp
  803734:	68 8c 45 80 00       	push   $0x80458c
  803739:	68 64 01 00 00       	push   $0x164
  80373e:	68 af 45 80 00       	push   $0x8045af
  803743:	e8 de cf ff ff       	call   800726 <_panic>
  803748:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80374e:	8b 45 08             	mov    0x8(%ebp),%eax
  803751:	89 10                	mov    %edx,(%eax)
  803753:	8b 45 08             	mov    0x8(%ebp),%eax
  803756:	8b 00                	mov    (%eax),%eax
  803758:	85 c0                	test   %eax,%eax
  80375a:	74 0d                	je     803769 <insert_sorted_with_merge_freeList+0x4de>
  80375c:	a1 48 51 80 00       	mov    0x805148,%eax
  803761:	8b 55 08             	mov    0x8(%ebp),%edx
  803764:	89 50 04             	mov    %edx,0x4(%eax)
  803767:	eb 08                	jmp    803771 <insert_sorted_with_merge_freeList+0x4e6>
  803769:	8b 45 08             	mov    0x8(%ebp),%eax
  80376c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803771:	8b 45 08             	mov    0x8(%ebp),%eax
  803774:	a3 48 51 80 00       	mov    %eax,0x805148
  803779:	8b 45 08             	mov    0x8(%ebp),%eax
  80377c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803783:	a1 54 51 80 00       	mov    0x805154,%eax
  803788:	40                   	inc    %eax
  803789:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80378e:	e9 41 02 00 00       	jmp    8039d4 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803793:	8b 45 08             	mov    0x8(%ebp),%eax
  803796:	8b 50 08             	mov    0x8(%eax),%edx
  803799:	8b 45 08             	mov    0x8(%ebp),%eax
  80379c:	8b 40 0c             	mov    0xc(%eax),%eax
  80379f:	01 c2                	add    %eax,%edx
  8037a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037a4:	8b 40 08             	mov    0x8(%eax),%eax
  8037a7:	39 c2                	cmp    %eax,%edx
  8037a9:	0f 85 7c 01 00 00    	jne    80392b <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8037af:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8037b3:	74 06                	je     8037bb <insert_sorted_with_merge_freeList+0x530>
  8037b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037b9:	75 17                	jne    8037d2 <insert_sorted_with_merge_freeList+0x547>
  8037bb:	83 ec 04             	sub    $0x4,%esp
  8037be:	68 c8 45 80 00       	push   $0x8045c8
  8037c3:	68 69 01 00 00       	push   $0x169
  8037c8:	68 af 45 80 00       	push   $0x8045af
  8037cd:	e8 54 cf ff ff       	call   800726 <_panic>
  8037d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037d5:	8b 50 04             	mov    0x4(%eax),%edx
  8037d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8037db:	89 50 04             	mov    %edx,0x4(%eax)
  8037de:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037e4:	89 10                	mov    %edx,(%eax)
  8037e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037e9:	8b 40 04             	mov    0x4(%eax),%eax
  8037ec:	85 c0                	test   %eax,%eax
  8037ee:	74 0d                	je     8037fd <insert_sorted_with_merge_freeList+0x572>
  8037f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037f3:	8b 40 04             	mov    0x4(%eax),%eax
  8037f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8037f9:	89 10                	mov    %edx,(%eax)
  8037fb:	eb 08                	jmp    803805 <insert_sorted_with_merge_freeList+0x57a>
  8037fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803800:	a3 38 51 80 00       	mov    %eax,0x805138
  803805:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803808:	8b 55 08             	mov    0x8(%ebp),%edx
  80380b:	89 50 04             	mov    %edx,0x4(%eax)
  80380e:	a1 44 51 80 00       	mov    0x805144,%eax
  803813:	40                   	inc    %eax
  803814:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803819:	8b 45 08             	mov    0x8(%ebp),%eax
  80381c:	8b 50 0c             	mov    0xc(%eax),%edx
  80381f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803822:	8b 40 0c             	mov    0xc(%eax),%eax
  803825:	01 c2                	add    %eax,%edx
  803827:	8b 45 08             	mov    0x8(%ebp),%eax
  80382a:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80382d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803831:	75 17                	jne    80384a <insert_sorted_with_merge_freeList+0x5bf>
  803833:	83 ec 04             	sub    $0x4,%esp
  803836:	68 58 46 80 00       	push   $0x804658
  80383b:	68 6b 01 00 00       	push   $0x16b
  803840:	68 af 45 80 00       	push   $0x8045af
  803845:	e8 dc ce ff ff       	call   800726 <_panic>
  80384a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80384d:	8b 00                	mov    (%eax),%eax
  80384f:	85 c0                	test   %eax,%eax
  803851:	74 10                	je     803863 <insert_sorted_with_merge_freeList+0x5d8>
  803853:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803856:	8b 00                	mov    (%eax),%eax
  803858:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80385b:	8b 52 04             	mov    0x4(%edx),%edx
  80385e:	89 50 04             	mov    %edx,0x4(%eax)
  803861:	eb 0b                	jmp    80386e <insert_sorted_with_merge_freeList+0x5e3>
  803863:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803866:	8b 40 04             	mov    0x4(%eax),%eax
  803869:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80386e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803871:	8b 40 04             	mov    0x4(%eax),%eax
  803874:	85 c0                	test   %eax,%eax
  803876:	74 0f                	je     803887 <insert_sorted_with_merge_freeList+0x5fc>
  803878:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80387b:	8b 40 04             	mov    0x4(%eax),%eax
  80387e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803881:	8b 12                	mov    (%edx),%edx
  803883:	89 10                	mov    %edx,(%eax)
  803885:	eb 0a                	jmp    803891 <insert_sorted_with_merge_freeList+0x606>
  803887:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80388a:	8b 00                	mov    (%eax),%eax
  80388c:	a3 38 51 80 00       	mov    %eax,0x805138
  803891:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803894:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80389a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80389d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038a4:	a1 44 51 80 00       	mov    0x805144,%eax
  8038a9:	48                   	dec    %eax
  8038aa:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8038af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038b2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8038b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038bc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8038c3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8038c7:	75 17                	jne    8038e0 <insert_sorted_with_merge_freeList+0x655>
  8038c9:	83 ec 04             	sub    $0x4,%esp
  8038cc:	68 8c 45 80 00       	push   $0x80458c
  8038d1:	68 6e 01 00 00       	push   $0x16e
  8038d6:	68 af 45 80 00       	push   $0x8045af
  8038db:	e8 46 ce ff ff       	call   800726 <_panic>
  8038e0:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8038e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038e9:	89 10                	mov    %edx,(%eax)
  8038eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038ee:	8b 00                	mov    (%eax),%eax
  8038f0:	85 c0                	test   %eax,%eax
  8038f2:	74 0d                	je     803901 <insert_sorted_with_merge_freeList+0x676>
  8038f4:	a1 48 51 80 00       	mov    0x805148,%eax
  8038f9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038fc:	89 50 04             	mov    %edx,0x4(%eax)
  8038ff:	eb 08                	jmp    803909 <insert_sorted_with_merge_freeList+0x67e>
  803901:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803904:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803909:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80390c:	a3 48 51 80 00       	mov    %eax,0x805148
  803911:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803914:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80391b:	a1 54 51 80 00       	mov    0x805154,%eax
  803920:	40                   	inc    %eax
  803921:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803926:	e9 a9 00 00 00       	jmp    8039d4 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  80392b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80392f:	74 06                	je     803937 <insert_sorted_with_merge_freeList+0x6ac>
  803931:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803935:	75 17                	jne    80394e <insert_sorted_with_merge_freeList+0x6c3>
  803937:	83 ec 04             	sub    $0x4,%esp
  80393a:	68 24 46 80 00       	push   $0x804624
  80393f:	68 73 01 00 00       	push   $0x173
  803944:	68 af 45 80 00       	push   $0x8045af
  803949:	e8 d8 cd ff ff       	call   800726 <_panic>
  80394e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803951:	8b 10                	mov    (%eax),%edx
  803953:	8b 45 08             	mov    0x8(%ebp),%eax
  803956:	89 10                	mov    %edx,(%eax)
  803958:	8b 45 08             	mov    0x8(%ebp),%eax
  80395b:	8b 00                	mov    (%eax),%eax
  80395d:	85 c0                	test   %eax,%eax
  80395f:	74 0b                	je     80396c <insert_sorted_with_merge_freeList+0x6e1>
  803961:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803964:	8b 00                	mov    (%eax),%eax
  803966:	8b 55 08             	mov    0x8(%ebp),%edx
  803969:	89 50 04             	mov    %edx,0x4(%eax)
  80396c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80396f:	8b 55 08             	mov    0x8(%ebp),%edx
  803972:	89 10                	mov    %edx,(%eax)
  803974:	8b 45 08             	mov    0x8(%ebp),%eax
  803977:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80397a:	89 50 04             	mov    %edx,0x4(%eax)
  80397d:	8b 45 08             	mov    0x8(%ebp),%eax
  803980:	8b 00                	mov    (%eax),%eax
  803982:	85 c0                	test   %eax,%eax
  803984:	75 08                	jne    80398e <insert_sorted_with_merge_freeList+0x703>
  803986:	8b 45 08             	mov    0x8(%ebp),%eax
  803989:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80398e:	a1 44 51 80 00       	mov    0x805144,%eax
  803993:	40                   	inc    %eax
  803994:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803999:	eb 39                	jmp    8039d4 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80399b:	a1 40 51 80 00       	mov    0x805140,%eax
  8039a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8039a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039a7:	74 07                	je     8039b0 <insert_sorted_with_merge_freeList+0x725>
  8039a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039ac:	8b 00                	mov    (%eax),%eax
  8039ae:	eb 05                	jmp    8039b5 <insert_sorted_with_merge_freeList+0x72a>
  8039b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8039b5:	a3 40 51 80 00       	mov    %eax,0x805140
  8039ba:	a1 40 51 80 00       	mov    0x805140,%eax
  8039bf:	85 c0                	test   %eax,%eax
  8039c1:	0f 85 c7 fb ff ff    	jne    80358e <insert_sorted_with_merge_freeList+0x303>
  8039c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039cb:	0f 85 bd fb ff ff    	jne    80358e <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8039d1:	eb 01                	jmp    8039d4 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8039d3:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8039d4:	90                   	nop
  8039d5:	c9                   	leave  
  8039d6:	c3                   	ret    
  8039d7:	90                   	nop

008039d8 <__udivdi3>:
  8039d8:	55                   	push   %ebp
  8039d9:	57                   	push   %edi
  8039da:	56                   	push   %esi
  8039db:	53                   	push   %ebx
  8039dc:	83 ec 1c             	sub    $0x1c,%esp
  8039df:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8039e3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8039e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8039eb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8039ef:	89 ca                	mov    %ecx,%edx
  8039f1:	89 f8                	mov    %edi,%eax
  8039f3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8039f7:	85 f6                	test   %esi,%esi
  8039f9:	75 2d                	jne    803a28 <__udivdi3+0x50>
  8039fb:	39 cf                	cmp    %ecx,%edi
  8039fd:	77 65                	ja     803a64 <__udivdi3+0x8c>
  8039ff:	89 fd                	mov    %edi,%ebp
  803a01:	85 ff                	test   %edi,%edi
  803a03:	75 0b                	jne    803a10 <__udivdi3+0x38>
  803a05:	b8 01 00 00 00       	mov    $0x1,%eax
  803a0a:	31 d2                	xor    %edx,%edx
  803a0c:	f7 f7                	div    %edi
  803a0e:	89 c5                	mov    %eax,%ebp
  803a10:	31 d2                	xor    %edx,%edx
  803a12:	89 c8                	mov    %ecx,%eax
  803a14:	f7 f5                	div    %ebp
  803a16:	89 c1                	mov    %eax,%ecx
  803a18:	89 d8                	mov    %ebx,%eax
  803a1a:	f7 f5                	div    %ebp
  803a1c:	89 cf                	mov    %ecx,%edi
  803a1e:	89 fa                	mov    %edi,%edx
  803a20:	83 c4 1c             	add    $0x1c,%esp
  803a23:	5b                   	pop    %ebx
  803a24:	5e                   	pop    %esi
  803a25:	5f                   	pop    %edi
  803a26:	5d                   	pop    %ebp
  803a27:	c3                   	ret    
  803a28:	39 ce                	cmp    %ecx,%esi
  803a2a:	77 28                	ja     803a54 <__udivdi3+0x7c>
  803a2c:	0f bd fe             	bsr    %esi,%edi
  803a2f:	83 f7 1f             	xor    $0x1f,%edi
  803a32:	75 40                	jne    803a74 <__udivdi3+0x9c>
  803a34:	39 ce                	cmp    %ecx,%esi
  803a36:	72 0a                	jb     803a42 <__udivdi3+0x6a>
  803a38:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803a3c:	0f 87 9e 00 00 00    	ja     803ae0 <__udivdi3+0x108>
  803a42:	b8 01 00 00 00       	mov    $0x1,%eax
  803a47:	89 fa                	mov    %edi,%edx
  803a49:	83 c4 1c             	add    $0x1c,%esp
  803a4c:	5b                   	pop    %ebx
  803a4d:	5e                   	pop    %esi
  803a4e:	5f                   	pop    %edi
  803a4f:	5d                   	pop    %ebp
  803a50:	c3                   	ret    
  803a51:	8d 76 00             	lea    0x0(%esi),%esi
  803a54:	31 ff                	xor    %edi,%edi
  803a56:	31 c0                	xor    %eax,%eax
  803a58:	89 fa                	mov    %edi,%edx
  803a5a:	83 c4 1c             	add    $0x1c,%esp
  803a5d:	5b                   	pop    %ebx
  803a5e:	5e                   	pop    %esi
  803a5f:	5f                   	pop    %edi
  803a60:	5d                   	pop    %ebp
  803a61:	c3                   	ret    
  803a62:	66 90                	xchg   %ax,%ax
  803a64:	89 d8                	mov    %ebx,%eax
  803a66:	f7 f7                	div    %edi
  803a68:	31 ff                	xor    %edi,%edi
  803a6a:	89 fa                	mov    %edi,%edx
  803a6c:	83 c4 1c             	add    $0x1c,%esp
  803a6f:	5b                   	pop    %ebx
  803a70:	5e                   	pop    %esi
  803a71:	5f                   	pop    %edi
  803a72:	5d                   	pop    %ebp
  803a73:	c3                   	ret    
  803a74:	bd 20 00 00 00       	mov    $0x20,%ebp
  803a79:	89 eb                	mov    %ebp,%ebx
  803a7b:	29 fb                	sub    %edi,%ebx
  803a7d:	89 f9                	mov    %edi,%ecx
  803a7f:	d3 e6                	shl    %cl,%esi
  803a81:	89 c5                	mov    %eax,%ebp
  803a83:	88 d9                	mov    %bl,%cl
  803a85:	d3 ed                	shr    %cl,%ebp
  803a87:	89 e9                	mov    %ebp,%ecx
  803a89:	09 f1                	or     %esi,%ecx
  803a8b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803a8f:	89 f9                	mov    %edi,%ecx
  803a91:	d3 e0                	shl    %cl,%eax
  803a93:	89 c5                	mov    %eax,%ebp
  803a95:	89 d6                	mov    %edx,%esi
  803a97:	88 d9                	mov    %bl,%cl
  803a99:	d3 ee                	shr    %cl,%esi
  803a9b:	89 f9                	mov    %edi,%ecx
  803a9d:	d3 e2                	shl    %cl,%edx
  803a9f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803aa3:	88 d9                	mov    %bl,%cl
  803aa5:	d3 e8                	shr    %cl,%eax
  803aa7:	09 c2                	or     %eax,%edx
  803aa9:	89 d0                	mov    %edx,%eax
  803aab:	89 f2                	mov    %esi,%edx
  803aad:	f7 74 24 0c          	divl   0xc(%esp)
  803ab1:	89 d6                	mov    %edx,%esi
  803ab3:	89 c3                	mov    %eax,%ebx
  803ab5:	f7 e5                	mul    %ebp
  803ab7:	39 d6                	cmp    %edx,%esi
  803ab9:	72 19                	jb     803ad4 <__udivdi3+0xfc>
  803abb:	74 0b                	je     803ac8 <__udivdi3+0xf0>
  803abd:	89 d8                	mov    %ebx,%eax
  803abf:	31 ff                	xor    %edi,%edi
  803ac1:	e9 58 ff ff ff       	jmp    803a1e <__udivdi3+0x46>
  803ac6:	66 90                	xchg   %ax,%ax
  803ac8:	8b 54 24 08          	mov    0x8(%esp),%edx
  803acc:	89 f9                	mov    %edi,%ecx
  803ace:	d3 e2                	shl    %cl,%edx
  803ad0:	39 c2                	cmp    %eax,%edx
  803ad2:	73 e9                	jae    803abd <__udivdi3+0xe5>
  803ad4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803ad7:	31 ff                	xor    %edi,%edi
  803ad9:	e9 40 ff ff ff       	jmp    803a1e <__udivdi3+0x46>
  803ade:	66 90                	xchg   %ax,%ax
  803ae0:	31 c0                	xor    %eax,%eax
  803ae2:	e9 37 ff ff ff       	jmp    803a1e <__udivdi3+0x46>
  803ae7:	90                   	nop

00803ae8 <__umoddi3>:
  803ae8:	55                   	push   %ebp
  803ae9:	57                   	push   %edi
  803aea:	56                   	push   %esi
  803aeb:	53                   	push   %ebx
  803aec:	83 ec 1c             	sub    $0x1c,%esp
  803aef:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803af3:	8b 74 24 34          	mov    0x34(%esp),%esi
  803af7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803afb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803aff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803b03:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803b07:	89 f3                	mov    %esi,%ebx
  803b09:	89 fa                	mov    %edi,%edx
  803b0b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b0f:	89 34 24             	mov    %esi,(%esp)
  803b12:	85 c0                	test   %eax,%eax
  803b14:	75 1a                	jne    803b30 <__umoddi3+0x48>
  803b16:	39 f7                	cmp    %esi,%edi
  803b18:	0f 86 a2 00 00 00    	jbe    803bc0 <__umoddi3+0xd8>
  803b1e:	89 c8                	mov    %ecx,%eax
  803b20:	89 f2                	mov    %esi,%edx
  803b22:	f7 f7                	div    %edi
  803b24:	89 d0                	mov    %edx,%eax
  803b26:	31 d2                	xor    %edx,%edx
  803b28:	83 c4 1c             	add    $0x1c,%esp
  803b2b:	5b                   	pop    %ebx
  803b2c:	5e                   	pop    %esi
  803b2d:	5f                   	pop    %edi
  803b2e:	5d                   	pop    %ebp
  803b2f:	c3                   	ret    
  803b30:	39 f0                	cmp    %esi,%eax
  803b32:	0f 87 ac 00 00 00    	ja     803be4 <__umoddi3+0xfc>
  803b38:	0f bd e8             	bsr    %eax,%ebp
  803b3b:	83 f5 1f             	xor    $0x1f,%ebp
  803b3e:	0f 84 ac 00 00 00    	je     803bf0 <__umoddi3+0x108>
  803b44:	bf 20 00 00 00       	mov    $0x20,%edi
  803b49:	29 ef                	sub    %ebp,%edi
  803b4b:	89 fe                	mov    %edi,%esi
  803b4d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803b51:	89 e9                	mov    %ebp,%ecx
  803b53:	d3 e0                	shl    %cl,%eax
  803b55:	89 d7                	mov    %edx,%edi
  803b57:	89 f1                	mov    %esi,%ecx
  803b59:	d3 ef                	shr    %cl,%edi
  803b5b:	09 c7                	or     %eax,%edi
  803b5d:	89 e9                	mov    %ebp,%ecx
  803b5f:	d3 e2                	shl    %cl,%edx
  803b61:	89 14 24             	mov    %edx,(%esp)
  803b64:	89 d8                	mov    %ebx,%eax
  803b66:	d3 e0                	shl    %cl,%eax
  803b68:	89 c2                	mov    %eax,%edx
  803b6a:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b6e:	d3 e0                	shl    %cl,%eax
  803b70:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b74:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b78:	89 f1                	mov    %esi,%ecx
  803b7a:	d3 e8                	shr    %cl,%eax
  803b7c:	09 d0                	or     %edx,%eax
  803b7e:	d3 eb                	shr    %cl,%ebx
  803b80:	89 da                	mov    %ebx,%edx
  803b82:	f7 f7                	div    %edi
  803b84:	89 d3                	mov    %edx,%ebx
  803b86:	f7 24 24             	mull   (%esp)
  803b89:	89 c6                	mov    %eax,%esi
  803b8b:	89 d1                	mov    %edx,%ecx
  803b8d:	39 d3                	cmp    %edx,%ebx
  803b8f:	0f 82 87 00 00 00    	jb     803c1c <__umoddi3+0x134>
  803b95:	0f 84 91 00 00 00    	je     803c2c <__umoddi3+0x144>
  803b9b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803b9f:	29 f2                	sub    %esi,%edx
  803ba1:	19 cb                	sbb    %ecx,%ebx
  803ba3:	89 d8                	mov    %ebx,%eax
  803ba5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803ba9:	d3 e0                	shl    %cl,%eax
  803bab:	89 e9                	mov    %ebp,%ecx
  803bad:	d3 ea                	shr    %cl,%edx
  803baf:	09 d0                	or     %edx,%eax
  803bb1:	89 e9                	mov    %ebp,%ecx
  803bb3:	d3 eb                	shr    %cl,%ebx
  803bb5:	89 da                	mov    %ebx,%edx
  803bb7:	83 c4 1c             	add    $0x1c,%esp
  803bba:	5b                   	pop    %ebx
  803bbb:	5e                   	pop    %esi
  803bbc:	5f                   	pop    %edi
  803bbd:	5d                   	pop    %ebp
  803bbe:	c3                   	ret    
  803bbf:	90                   	nop
  803bc0:	89 fd                	mov    %edi,%ebp
  803bc2:	85 ff                	test   %edi,%edi
  803bc4:	75 0b                	jne    803bd1 <__umoddi3+0xe9>
  803bc6:	b8 01 00 00 00       	mov    $0x1,%eax
  803bcb:	31 d2                	xor    %edx,%edx
  803bcd:	f7 f7                	div    %edi
  803bcf:	89 c5                	mov    %eax,%ebp
  803bd1:	89 f0                	mov    %esi,%eax
  803bd3:	31 d2                	xor    %edx,%edx
  803bd5:	f7 f5                	div    %ebp
  803bd7:	89 c8                	mov    %ecx,%eax
  803bd9:	f7 f5                	div    %ebp
  803bdb:	89 d0                	mov    %edx,%eax
  803bdd:	e9 44 ff ff ff       	jmp    803b26 <__umoddi3+0x3e>
  803be2:	66 90                	xchg   %ax,%ax
  803be4:	89 c8                	mov    %ecx,%eax
  803be6:	89 f2                	mov    %esi,%edx
  803be8:	83 c4 1c             	add    $0x1c,%esp
  803beb:	5b                   	pop    %ebx
  803bec:	5e                   	pop    %esi
  803bed:	5f                   	pop    %edi
  803bee:	5d                   	pop    %ebp
  803bef:	c3                   	ret    
  803bf0:	3b 04 24             	cmp    (%esp),%eax
  803bf3:	72 06                	jb     803bfb <__umoddi3+0x113>
  803bf5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803bf9:	77 0f                	ja     803c0a <__umoddi3+0x122>
  803bfb:	89 f2                	mov    %esi,%edx
  803bfd:	29 f9                	sub    %edi,%ecx
  803bff:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803c03:	89 14 24             	mov    %edx,(%esp)
  803c06:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c0a:	8b 44 24 04          	mov    0x4(%esp),%eax
  803c0e:	8b 14 24             	mov    (%esp),%edx
  803c11:	83 c4 1c             	add    $0x1c,%esp
  803c14:	5b                   	pop    %ebx
  803c15:	5e                   	pop    %esi
  803c16:	5f                   	pop    %edi
  803c17:	5d                   	pop    %ebp
  803c18:	c3                   	ret    
  803c19:	8d 76 00             	lea    0x0(%esi),%esi
  803c1c:	2b 04 24             	sub    (%esp),%eax
  803c1f:	19 fa                	sbb    %edi,%edx
  803c21:	89 d1                	mov    %edx,%ecx
  803c23:	89 c6                	mov    %eax,%esi
  803c25:	e9 71 ff ff ff       	jmp    803b9b <__umoddi3+0xb3>
  803c2a:	66 90                	xchg   %ax,%ax
  803c2c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803c30:	72 ea                	jb     803c1c <__umoddi3+0x134>
  803c32:	89 d9                	mov    %ebx,%ecx
  803c34:	e9 62 ff ff ff       	jmp    803b9b <__umoddi3+0xb3>
