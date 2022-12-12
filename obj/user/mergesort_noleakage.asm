
obj/user/mergesort_noleakage:     file format elf32-i386


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
  800031:	e8 8f 07 00 00       	call   8007c5 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void Merge(int* A, int p, int q, int r);

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
  800041:	e8 72 20 00 00       	call   8020b8 <sys_disable_interrupt>

		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 00 3e 80 00       	push   $0x803e00
  80004e:	e8 62 0b 00 00       	call   800bb5 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 02 3e 80 00       	push   $0x803e02
  80005e:	e8 52 0b 00 00       	call   800bb5 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 18 3e 80 00       	push   $0x803e18
  80006e:	e8 42 0b 00 00       	call   800bb5 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 02 3e 80 00       	push   $0x803e02
  80007e:	e8 32 0b 00 00       	call   800bb5 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 00 3e 80 00       	push   $0x803e00
  80008e:	e8 22 0b 00 00       	call   800bb5 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 30 3e 80 00       	push   $0x803e30
  8000a5:	e8 8d 11 00 00       	call   801237 <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 dd 16 00 00       	call   80179d <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 6e 1c 00 00       	call   801d43 <malloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	68 50 3e 80 00       	push   $0x803e50
  8000e3:	e8 cd 0a 00 00       	call   800bb5 <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 72 3e 80 00       	push   $0x803e72
  8000f3:	e8 bd 0a 00 00       	call   800bb5 <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 80 3e 80 00       	push   $0x803e80
  800103:	e8 ad 0a 00 00       	call   800bb5 <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 8f 3e 80 00       	push   $0x803e8f
  800113:	e8 9d 0a 00 00       	call   800bb5 <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 9f 3e 80 00       	push   $0x803e9f
  800123:	e8 8d 0a 00 00       	call   800bb5 <cprintf>
  800128:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80012b:	e8 3d 06 00 00       	call   80076d <getchar>
  800130:	88 45 f7             	mov    %al,-0x9(%ebp)
			cputchar(Chose);
  800133:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	50                   	push   %eax
  80013b:	e8 e5 05 00 00       	call   800725 <cputchar>
  800140:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	6a 0a                	push   $0xa
  800148:	e8 d8 05 00 00       	call   800725 <cputchar>
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
  800162:	e8 6b 1f 00 00       	call   8020d2 <sys_enable_interrupt>

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
  800183:	e8 f4 01 00 00       	call   80037c <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f0             	pushl  -0x10(%ebp)
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	e8 12 02 00 00       	call   8003ad <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a9:	e8 34 02 00 00       	call   8003e2 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 21 02 00 00       	call   8003e2 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001c4:	83 ec 04             	sub    $0x4,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	6a 01                	push   $0x1
  8001cc:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cf:	e8 e0 02 00 00       	call   8004b4 <MSort>
  8001d4:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  8001d7:	e8 dc 1e 00 00       	call   8020b8 <sys_disable_interrupt>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	68 a8 3e 80 00       	push   $0x803ea8
  8001e4:	e8 cc 09 00 00       	call   800bb5 <cprintf>
  8001e9:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001ec:	e8 e1 1e 00 00       	call   8020d2 <sys_enable_interrupt>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001f1:	83 ec 08             	sub    $0x8,%esp
  8001f4:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001fa:	e8 d3 00 00 00       	call   8002d2 <CheckSorted>
  8001ff:	83 c4 10             	add    $0x10,%esp
  800202:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800205:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800209:	75 14                	jne    80021f <_main+0x1e7>
  80020b:	83 ec 04             	sub    $0x4,%esp
  80020e:	68 dc 3e 80 00       	push   $0x803edc
  800213:	6a 4a                	push   $0x4a
  800215:	68 fe 3e 80 00       	push   $0x803efe
  80021a:	e8 e2 06 00 00       	call   800901 <_panic>
		else
		{
			sys_disable_interrupt();
  80021f:	e8 94 1e 00 00       	call   8020b8 <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	68 1c 3f 80 00       	push   $0x803f1c
  80022c:	e8 84 09 00 00       	call   800bb5 <cprintf>
  800231:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	68 50 3f 80 00       	push   $0x803f50
  80023c:	e8 74 09 00 00       	call   800bb5 <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 84 3f 80 00       	push   $0x803f84
  80024c:	e8 64 09 00 00       	call   800bb5 <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800254:	e8 79 1e 00 00       	call   8020d2 <sys_enable_interrupt>
		}

		free(Elements) ;
  800259:	83 ec 0c             	sub    $0xc,%esp
  80025c:	ff 75 ec             	pushl  -0x14(%ebp)
  80025f:	e8 0d 1b 00 00       	call   801d71 <free>
  800264:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  800267:	e8 4c 1e 00 00       	call   8020b8 <sys_disable_interrupt>
			Chose = 0 ;
  80026c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800270:	eb 42                	jmp    8002b4 <_main+0x27c>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800272:	83 ec 0c             	sub    $0xc,%esp
  800275:	68 b6 3f 80 00       	push   $0x803fb6
  80027a:	e8 36 09 00 00       	call   800bb5 <cprintf>
  80027f:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800282:	e8 e6 04 00 00       	call   80076d <getchar>
  800287:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  80028a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80028e:	83 ec 0c             	sub    $0xc,%esp
  800291:	50                   	push   %eax
  800292:	e8 8e 04 00 00       	call   800725 <cputchar>
  800297:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80029a:	83 ec 0c             	sub    $0xc,%esp
  80029d:	6a 0a                	push   $0xa
  80029f:	e8 81 04 00 00       	call   800725 <cputchar>
  8002a4:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  8002a7:	83 ec 0c             	sub    $0xc,%esp
  8002aa:	6a 0a                	push   $0xa
  8002ac:	e8 74 04 00 00       	call   800725 <cputchar>
  8002b1:	83 c4 10             	add    $0x10,%esp

		free(Elements) ;

		sys_disable_interrupt();
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002b4:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002b8:	74 06                	je     8002c0 <_main+0x288>
  8002ba:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002be:	75 b2                	jne    800272 <_main+0x23a>
				Chose = getchar() ;
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		sys_enable_interrupt();
  8002c0:	e8 0d 1e 00 00       	call   8020d2 <sys_enable_interrupt>

	} while (Chose == 'y');
  8002c5:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002c9:	0f 84 72 fd ff ff    	je     800041 <_main+0x9>

}
  8002cf:	90                   	nop
  8002d0:	c9                   	leave  
  8002d1:	c3                   	ret    

008002d2 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8002d2:	55                   	push   %ebp
  8002d3:	89 e5                	mov    %esp,%ebp
  8002d5:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8002d8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8002df:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8002e6:	eb 33                	jmp    80031b <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8002e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f5:	01 d0                	add    %edx,%eax
  8002f7:	8b 10                	mov    (%eax),%edx
  8002f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002fc:	40                   	inc    %eax
  8002fd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800304:	8b 45 08             	mov    0x8(%ebp),%eax
  800307:	01 c8                	add    %ecx,%eax
  800309:	8b 00                	mov    (%eax),%eax
  80030b:	39 c2                	cmp    %eax,%edx
  80030d:	7e 09                	jle    800318 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  80030f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800316:	eb 0c                	jmp    800324 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800318:	ff 45 f8             	incl   -0x8(%ebp)
  80031b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80031e:	48                   	dec    %eax
  80031f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800322:	7f c4                	jg     8002e8 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800324:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800327:	c9                   	leave  
  800328:	c3                   	ret    

00800329 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  800329:	55                   	push   %ebp
  80032a:	89 e5                	mov    %esp,%ebp
  80032c:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  80032f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800332:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800339:	8b 45 08             	mov    0x8(%ebp),%eax
  80033c:	01 d0                	add    %edx,%eax
  80033e:	8b 00                	mov    (%eax),%eax
  800340:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800343:	8b 45 0c             	mov    0xc(%ebp),%eax
  800346:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80034d:	8b 45 08             	mov    0x8(%ebp),%eax
  800350:	01 c2                	add    %eax,%edx
  800352:	8b 45 10             	mov    0x10(%ebp),%eax
  800355:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80035c:	8b 45 08             	mov    0x8(%ebp),%eax
  80035f:	01 c8                	add    %ecx,%eax
  800361:	8b 00                	mov    (%eax),%eax
  800363:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800365:	8b 45 10             	mov    0x10(%ebp),%eax
  800368:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80036f:	8b 45 08             	mov    0x8(%ebp),%eax
  800372:	01 c2                	add    %eax,%edx
  800374:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800377:	89 02                	mov    %eax,(%edx)
}
  800379:	90                   	nop
  80037a:	c9                   	leave  
  80037b:	c3                   	ret    

0080037c <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80037c:	55                   	push   %ebp
  80037d:	89 e5                	mov    %esp,%ebp
  80037f:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800382:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800389:	eb 17                	jmp    8003a2 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80038b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80038e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800395:	8b 45 08             	mov    0x8(%ebp),%eax
  800398:	01 c2                	add    %eax,%edx
  80039a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80039d:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80039f:	ff 45 fc             	incl   -0x4(%ebp)
  8003a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003a5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003a8:	7c e1                	jl     80038b <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8003aa:	90                   	nop
  8003ab:	c9                   	leave  
  8003ac:	c3                   	ret    

008003ad <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8003ad:	55                   	push   %ebp
  8003ae:	89 e5                	mov    %esp,%ebp
  8003b0:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003ba:	eb 1b                	jmp    8003d7 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8003bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003bf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c9:	01 c2                	add    %eax,%edx
  8003cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ce:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8003d1:	48                   	dec    %eax
  8003d2:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003d4:	ff 45 fc             	incl   -0x4(%ebp)
  8003d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003da:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003dd:	7c dd                	jl     8003bc <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8003df:	90                   	nop
  8003e0:	c9                   	leave  
  8003e1:	c3                   	ret    

008003e2 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8003e2:	55                   	push   %ebp
  8003e3:	89 e5                	mov    %esp,%ebp
  8003e5:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8003e8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003eb:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8003f0:	f7 e9                	imul   %ecx
  8003f2:	c1 f9 1f             	sar    $0x1f,%ecx
  8003f5:	89 d0                	mov    %edx,%eax
  8003f7:	29 c8                	sub    %ecx,%eax
  8003f9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8003fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800403:	eb 1e                	jmp    800423 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  800405:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800408:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80040f:	8b 45 08             	mov    0x8(%ebp),%eax
  800412:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800415:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800418:	99                   	cltd   
  800419:	f7 7d f8             	idivl  -0x8(%ebp)
  80041c:	89 d0                	mov    %edx,%eax
  80041e:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800420:	ff 45 fc             	incl   -0x4(%ebp)
  800423:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800426:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800429:	7c da                	jl     800405 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
			//cprintf("i=%d\n",i);
	}

}
  80042b:	90                   	nop
  80042c:	c9                   	leave  
  80042d:	c3                   	ret    

0080042e <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  80042e:	55                   	push   %ebp
  80042f:	89 e5                	mov    %esp,%ebp
  800431:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800434:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80043b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800442:	eb 42                	jmp    800486 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800444:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800447:	99                   	cltd   
  800448:	f7 7d f0             	idivl  -0x10(%ebp)
  80044b:	89 d0                	mov    %edx,%eax
  80044d:	85 c0                	test   %eax,%eax
  80044f:	75 10                	jne    800461 <PrintElements+0x33>
			cprintf("\n");
  800451:	83 ec 0c             	sub    $0xc,%esp
  800454:	68 00 3e 80 00       	push   $0x803e00
  800459:	e8 57 07 00 00       	call   800bb5 <cprintf>
  80045e:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800461:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800464:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80046b:	8b 45 08             	mov    0x8(%ebp),%eax
  80046e:	01 d0                	add    %edx,%eax
  800470:	8b 00                	mov    (%eax),%eax
  800472:	83 ec 08             	sub    $0x8,%esp
  800475:	50                   	push   %eax
  800476:	68 d4 3f 80 00       	push   $0x803fd4
  80047b:	e8 35 07 00 00       	call   800bb5 <cprintf>
  800480:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800483:	ff 45 f4             	incl   -0xc(%ebp)
  800486:	8b 45 0c             	mov    0xc(%ebp),%eax
  800489:	48                   	dec    %eax
  80048a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80048d:	7f b5                	jg     800444 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  80048f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800492:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800499:	8b 45 08             	mov    0x8(%ebp),%eax
  80049c:	01 d0                	add    %edx,%eax
  80049e:	8b 00                	mov    (%eax),%eax
  8004a0:	83 ec 08             	sub    $0x8,%esp
  8004a3:	50                   	push   %eax
  8004a4:	68 d9 3f 80 00       	push   $0x803fd9
  8004a9:	e8 07 07 00 00       	call   800bb5 <cprintf>
  8004ae:	83 c4 10             	add    $0x10,%esp

}
  8004b1:	90                   	nop
  8004b2:	c9                   	leave  
  8004b3:	c3                   	ret    

008004b4 <MSort>:


void MSort(int* A, int p, int r)
{
  8004b4:	55                   	push   %ebp
  8004b5:	89 e5                	mov    %esp,%ebp
  8004b7:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  8004ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004bd:	3b 45 10             	cmp    0x10(%ebp),%eax
  8004c0:	7d 54                	jge    800516 <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  8004c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8004c8:	01 d0                	add    %edx,%eax
  8004ca:	89 c2                	mov    %eax,%edx
  8004cc:	c1 ea 1f             	shr    $0x1f,%edx
  8004cf:	01 d0                	add    %edx,%eax
  8004d1:	d1 f8                	sar    %eax
  8004d3:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  8004d6:	83 ec 04             	sub    $0x4,%esp
  8004d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8004dc:	ff 75 0c             	pushl  0xc(%ebp)
  8004df:	ff 75 08             	pushl  0x8(%ebp)
  8004e2:	e8 cd ff ff ff       	call   8004b4 <MSort>
  8004e7:	83 c4 10             	add    $0x10,%esp

	MSort(A, q + 1, r);
  8004ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004ed:	40                   	inc    %eax
  8004ee:	83 ec 04             	sub    $0x4,%esp
  8004f1:	ff 75 10             	pushl  0x10(%ebp)
  8004f4:	50                   	push   %eax
  8004f5:	ff 75 08             	pushl  0x8(%ebp)
  8004f8:	e8 b7 ff ff ff       	call   8004b4 <MSort>
  8004fd:	83 c4 10             	add    $0x10,%esp

	Merge(A, p, q, r);
  800500:	ff 75 10             	pushl  0x10(%ebp)
  800503:	ff 75 f4             	pushl  -0xc(%ebp)
  800506:	ff 75 0c             	pushl  0xc(%ebp)
  800509:	ff 75 08             	pushl  0x8(%ebp)
  80050c:	e8 08 00 00 00       	call   800519 <Merge>
  800511:	83 c4 10             	add    $0x10,%esp
  800514:	eb 01                	jmp    800517 <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  800516:	90                   	nop

	MSort(A, q + 1, r);

	Merge(A, p, q, r);

}
  800517:	c9                   	leave  
  800518:	c3                   	ret    

00800519 <Merge>:

void Merge(int* A, int p, int q, int r)
{
  800519:	55                   	push   %ebp
  80051a:	89 e5                	mov    %esp,%ebp
  80051c:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  80051f:	8b 45 10             	mov    0x10(%ebp),%eax
  800522:	2b 45 0c             	sub    0xc(%ebp),%eax
  800525:	40                   	inc    %eax
  800526:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  800529:	8b 45 14             	mov    0x14(%ebp),%eax
  80052c:	2b 45 10             	sub    0x10(%ebp),%eax
  80052f:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  800532:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  800539:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	//cprintf("allocate LEFT\n");
	int* Left = malloc(sizeof(int) * leftCapacity);
  800540:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800543:	c1 e0 02             	shl    $0x2,%eax
  800546:	83 ec 0c             	sub    $0xc,%esp
  800549:	50                   	push   %eax
  80054a:	e8 f4 17 00 00       	call   801d43 <malloc>
  80054f:	83 c4 10             	add    $0x10,%esp
  800552:	89 45 d8             	mov    %eax,-0x28(%ebp)

	//cprintf("allocate RIGHT\n");
	int* Right = malloc(sizeof(int) * rightCapacity);
  800555:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800558:	c1 e0 02             	shl    $0x2,%eax
  80055b:	83 ec 0c             	sub    $0xc,%esp
  80055e:	50                   	push   %eax
  80055f:	e8 df 17 00 00       	call   801d43 <malloc>
  800564:	83 c4 10             	add    $0x10,%esp
  800567:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  80056a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800571:	eb 2f                	jmp    8005a2 <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  800573:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800576:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80057d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800580:	01 c2                	add    %eax,%edx
  800582:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800585:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800588:	01 c8                	add    %ecx,%eax
  80058a:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80058f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800596:	8b 45 08             	mov    0x8(%ebp),%eax
  800599:	01 c8                	add    %ecx,%eax
  80059b:	8b 00                	mov    (%eax),%eax
  80059d:	89 02                	mov    %eax,(%edx)

	//cprintf("allocate RIGHT\n");
	int* Right = malloc(sizeof(int) * rightCapacity);

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  80059f:	ff 45 ec             	incl   -0x14(%ebp)
  8005a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005a5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005a8:	7c c9                	jl     800573 <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005aa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005b1:	eb 2a                	jmp    8005dd <Merge+0xc4>
	{
		Right[j] = A[q + j];
  8005b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005b6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005bd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005c0:	01 c2                	add    %eax,%edx
  8005c2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005c8:	01 c8                	add    %ecx,%eax
  8005ca:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d4:	01 c8                	add    %ecx,%eax
  8005d6:	8b 00                	mov    (%eax),%eax
  8005d8:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005da:	ff 45 e8             	incl   -0x18(%ebp)
  8005dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005e0:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005e3:	7c ce                	jl     8005b3 <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8005e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005eb:	e9 0a 01 00 00       	jmp    8006fa <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  8005f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005f3:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005f6:	0f 8d 95 00 00 00    	jge    800691 <Merge+0x178>
  8005fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005ff:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800602:	0f 8d 89 00 00 00    	jge    800691 <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800608:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80060b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800612:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800615:	01 d0                	add    %edx,%eax
  800617:	8b 10                	mov    (%eax),%edx
  800619:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80061c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800623:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800626:	01 c8                	add    %ecx,%eax
  800628:	8b 00                	mov    (%eax),%eax
  80062a:	39 c2                	cmp    %eax,%edx
  80062c:	7d 33                	jge    800661 <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  80062e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800631:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800636:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80063d:	8b 45 08             	mov    0x8(%ebp),%eax
  800640:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800643:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800646:	8d 50 01             	lea    0x1(%eax),%edx
  800649:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80064c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800653:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800656:	01 d0                	add    %edx,%eax
  800658:	8b 00                	mov    (%eax),%eax
  80065a:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80065c:	e9 96 00 00 00       	jmp    8006f7 <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  800661:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800664:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800669:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800670:	8b 45 08             	mov    0x8(%ebp),%eax
  800673:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800676:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800679:	8d 50 01             	lea    0x1(%eax),%edx
  80067c:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80067f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800686:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800689:	01 d0                	add    %edx,%eax
  80068b:	8b 00                	mov    (%eax),%eax
  80068d:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80068f:	eb 66                	jmp    8006f7 <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  800691:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800694:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800697:	7d 30                	jge    8006c9 <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  800699:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80069c:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006a1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ab:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006b1:	8d 50 01             	lea    0x1(%eax),%edx
  8006b4:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8006b7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006be:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006c1:	01 d0                	add    %edx,%eax
  8006c3:	8b 00                	mov    (%eax),%eax
  8006c5:	89 01                	mov    %eax,(%ecx)
  8006c7:	eb 2e                	jmp    8006f7 <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  8006c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006cc:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006db:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006e1:	8d 50 01             	lea    0x1(%eax),%edx
  8006e4:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8006e7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006f1:	01 d0                	add    %edx,%eax
  8006f3:	8b 00                	mov    (%eax),%eax
  8006f5:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8006f7:	ff 45 e4             	incl   -0x1c(%ebp)
  8006fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006fd:	3b 45 14             	cmp    0x14(%ebp),%eax
  800700:	0f 8e ea fe ff ff    	jle    8005f0 <Merge+0xd7>
			A[k - 1] = Right[rightIndex++];
		}
	}

	//cprintf("free LEFT\n");
	free(Left);
  800706:	83 ec 0c             	sub    $0xc,%esp
  800709:	ff 75 d8             	pushl  -0x28(%ebp)
  80070c:	e8 60 16 00 00       	call   801d71 <free>
  800711:	83 c4 10             	add    $0x10,%esp
	//cprintf("free RIGHT\n");
	free(Right);
  800714:	83 ec 0c             	sub    $0xc,%esp
  800717:	ff 75 d4             	pushl  -0x2c(%ebp)
  80071a:	e8 52 16 00 00       	call   801d71 <free>
  80071f:	83 c4 10             	add    $0x10,%esp

}
  800722:	90                   	nop
  800723:	c9                   	leave  
  800724:	c3                   	ret    

00800725 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800725:	55                   	push   %ebp
  800726:	89 e5                	mov    %esp,%ebp
  800728:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  80072b:	8b 45 08             	mov    0x8(%ebp),%eax
  80072e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800731:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800735:	83 ec 0c             	sub    $0xc,%esp
  800738:	50                   	push   %eax
  800739:	e8 ae 19 00 00       	call   8020ec <sys_cputc>
  80073e:	83 c4 10             	add    $0x10,%esp
}
  800741:	90                   	nop
  800742:	c9                   	leave  
  800743:	c3                   	ret    

00800744 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  800744:	55                   	push   %ebp
  800745:	89 e5                	mov    %esp,%ebp
  800747:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80074a:	e8 69 19 00 00       	call   8020b8 <sys_disable_interrupt>
	char c = ch;
  80074f:	8b 45 08             	mov    0x8(%ebp),%eax
  800752:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800755:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800759:	83 ec 0c             	sub    $0xc,%esp
  80075c:	50                   	push   %eax
  80075d:	e8 8a 19 00 00       	call   8020ec <sys_cputc>
  800762:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800765:	e8 68 19 00 00       	call   8020d2 <sys_enable_interrupt>
}
  80076a:	90                   	nop
  80076b:	c9                   	leave  
  80076c:	c3                   	ret    

0080076d <getchar>:

int
getchar(void)
{
  80076d:	55                   	push   %ebp
  80076e:	89 e5                	mov    %esp,%ebp
  800770:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800773:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80077a:	eb 08                	jmp    800784 <getchar+0x17>
	{
		c = sys_cgetc();
  80077c:	e8 b2 17 00 00       	call   801f33 <sys_cgetc>
  800781:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800784:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800788:	74 f2                	je     80077c <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  80078a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80078d:	c9                   	leave  
  80078e:	c3                   	ret    

0080078f <atomic_getchar>:

int
atomic_getchar(void)
{
  80078f:	55                   	push   %ebp
  800790:	89 e5                	mov    %esp,%ebp
  800792:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800795:	e8 1e 19 00 00       	call   8020b8 <sys_disable_interrupt>
	int c=0;
  80079a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8007a1:	eb 08                	jmp    8007ab <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  8007a3:	e8 8b 17 00 00       	call   801f33 <sys_cgetc>
  8007a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  8007ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8007af:	74 f2                	je     8007a3 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  8007b1:	e8 1c 19 00 00       	call   8020d2 <sys_enable_interrupt>
	return c;
  8007b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8007b9:	c9                   	leave  
  8007ba:	c3                   	ret    

008007bb <iscons>:

int iscons(int fdnum)
{
  8007bb:	55                   	push   %ebp
  8007bc:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8007be:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8007c3:	5d                   	pop    %ebp
  8007c4:	c3                   	ret    

008007c5 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8007c5:	55                   	push   %ebp
  8007c6:	89 e5                	mov    %esp,%ebp
  8007c8:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8007cb:	e8 db 1a 00 00       	call   8022ab <sys_getenvindex>
  8007d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8007d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007d6:	89 d0                	mov    %edx,%eax
  8007d8:	c1 e0 03             	shl    $0x3,%eax
  8007db:	01 d0                	add    %edx,%eax
  8007dd:	01 c0                	add    %eax,%eax
  8007df:	01 d0                	add    %edx,%eax
  8007e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007e8:	01 d0                	add    %edx,%eax
  8007ea:	c1 e0 04             	shl    $0x4,%eax
  8007ed:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8007f2:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8007f7:	a1 24 50 80 00       	mov    0x805024,%eax
  8007fc:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800802:	84 c0                	test   %al,%al
  800804:	74 0f                	je     800815 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800806:	a1 24 50 80 00       	mov    0x805024,%eax
  80080b:	05 5c 05 00 00       	add    $0x55c,%eax
  800810:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800815:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800819:	7e 0a                	jle    800825 <libmain+0x60>
		binaryname = argv[0];
  80081b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80081e:	8b 00                	mov    (%eax),%eax
  800820:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800825:	83 ec 08             	sub    $0x8,%esp
  800828:	ff 75 0c             	pushl  0xc(%ebp)
  80082b:	ff 75 08             	pushl  0x8(%ebp)
  80082e:	e8 05 f8 ff ff       	call   800038 <_main>
  800833:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800836:	e8 7d 18 00 00       	call   8020b8 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80083b:	83 ec 0c             	sub    $0xc,%esp
  80083e:	68 f8 3f 80 00       	push   $0x803ff8
  800843:	e8 6d 03 00 00       	call   800bb5 <cprintf>
  800848:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80084b:	a1 24 50 80 00       	mov    0x805024,%eax
  800850:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800856:	a1 24 50 80 00       	mov    0x805024,%eax
  80085b:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800861:	83 ec 04             	sub    $0x4,%esp
  800864:	52                   	push   %edx
  800865:	50                   	push   %eax
  800866:	68 20 40 80 00       	push   $0x804020
  80086b:	e8 45 03 00 00       	call   800bb5 <cprintf>
  800870:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800873:	a1 24 50 80 00       	mov    0x805024,%eax
  800878:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80087e:	a1 24 50 80 00       	mov    0x805024,%eax
  800883:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800889:	a1 24 50 80 00       	mov    0x805024,%eax
  80088e:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800894:	51                   	push   %ecx
  800895:	52                   	push   %edx
  800896:	50                   	push   %eax
  800897:	68 48 40 80 00       	push   $0x804048
  80089c:	e8 14 03 00 00       	call   800bb5 <cprintf>
  8008a1:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8008a4:	a1 24 50 80 00       	mov    0x805024,%eax
  8008a9:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8008af:	83 ec 08             	sub    $0x8,%esp
  8008b2:	50                   	push   %eax
  8008b3:	68 a0 40 80 00       	push   $0x8040a0
  8008b8:	e8 f8 02 00 00       	call   800bb5 <cprintf>
  8008bd:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8008c0:	83 ec 0c             	sub    $0xc,%esp
  8008c3:	68 f8 3f 80 00       	push   $0x803ff8
  8008c8:	e8 e8 02 00 00       	call   800bb5 <cprintf>
  8008cd:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8008d0:	e8 fd 17 00 00       	call   8020d2 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8008d5:	e8 19 00 00 00       	call   8008f3 <exit>
}
  8008da:	90                   	nop
  8008db:	c9                   	leave  
  8008dc:	c3                   	ret    

008008dd <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8008dd:	55                   	push   %ebp
  8008de:	89 e5                	mov    %esp,%ebp
  8008e0:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8008e3:	83 ec 0c             	sub    $0xc,%esp
  8008e6:	6a 00                	push   $0x0
  8008e8:	e8 8a 19 00 00       	call   802277 <sys_destroy_env>
  8008ed:	83 c4 10             	add    $0x10,%esp
}
  8008f0:	90                   	nop
  8008f1:	c9                   	leave  
  8008f2:	c3                   	ret    

008008f3 <exit>:

void
exit(void)
{
  8008f3:	55                   	push   %ebp
  8008f4:	89 e5                	mov    %esp,%ebp
  8008f6:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8008f9:	e8 df 19 00 00       	call   8022dd <sys_exit_env>
}
  8008fe:	90                   	nop
  8008ff:	c9                   	leave  
  800900:	c3                   	ret    

00800901 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800901:	55                   	push   %ebp
  800902:	89 e5                	mov    %esp,%ebp
  800904:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800907:	8d 45 10             	lea    0x10(%ebp),%eax
  80090a:	83 c0 04             	add    $0x4,%eax
  80090d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800910:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800915:	85 c0                	test   %eax,%eax
  800917:	74 16                	je     80092f <_panic+0x2e>
		cprintf("%s: ", argv0);
  800919:	a1 5c 51 80 00       	mov    0x80515c,%eax
  80091e:	83 ec 08             	sub    $0x8,%esp
  800921:	50                   	push   %eax
  800922:	68 b4 40 80 00       	push   $0x8040b4
  800927:	e8 89 02 00 00       	call   800bb5 <cprintf>
  80092c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80092f:	a1 00 50 80 00       	mov    0x805000,%eax
  800934:	ff 75 0c             	pushl  0xc(%ebp)
  800937:	ff 75 08             	pushl  0x8(%ebp)
  80093a:	50                   	push   %eax
  80093b:	68 b9 40 80 00       	push   $0x8040b9
  800940:	e8 70 02 00 00       	call   800bb5 <cprintf>
  800945:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800948:	8b 45 10             	mov    0x10(%ebp),%eax
  80094b:	83 ec 08             	sub    $0x8,%esp
  80094e:	ff 75 f4             	pushl  -0xc(%ebp)
  800951:	50                   	push   %eax
  800952:	e8 f3 01 00 00       	call   800b4a <vcprintf>
  800957:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80095a:	83 ec 08             	sub    $0x8,%esp
  80095d:	6a 00                	push   $0x0
  80095f:	68 d5 40 80 00       	push   $0x8040d5
  800964:	e8 e1 01 00 00       	call   800b4a <vcprintf>
  800969:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80096c:	e8 82 ff ff ff       	call   8008f3 <exit>

	// should not return here
	while (1) ;
  800971:	eb fe                	jmp    800971 <_panic+0x70>

00800973 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800973:	55                   	push   %ebp
  800974:	89 e5                	mov    %esp,%ebp
  800976:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800979:	a1 24 50 80 00       	mov    0x805024,%eax
  80097e:	8b 50 74             	mov    0x74(%eax),%edx
  800981:	8b 45 0c             	mov    0xc(%ebp),%eax
  800984:	39 c2                	cmp    %eax,%edx
  800986:	74 14                	je     80099c <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800988:	83 ec 04             	sub    $0x4,%esp
  80098b:	68 d8 40 80 00       	push   $0x8040d8
  800990:	6a 26                	push   $0x26
  800992:	68 24 41 80 00       	push   $0x804124
  800997:	e8 65 ff ff ff       	call   800901 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80099c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8009a3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009aa:	e9 c2 00 00 00       	jmp    800a71 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8009af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bc:	01 d0                	add    %edx,%eax
  8009be:	8b 00                	mov    (%eax),%eax
  8009c0:	85 c0                	test   %eax,%eax
  8009c2:	75 08                	jne    8009cc <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8009c4:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8009c7:	e9 a2 00 00 00       	jmp    800a6e <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8009cc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009d3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8009da:	eb 69                	jmp    800a45 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8009dc:	a1 24 50 80 00       	mov    0x805024,%eax
  8009e1:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8009e7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009ea:	89 d0                	mov    %edx,%eax
  8009ec:	01 c0                	add    %eax,%eax
  8009ee:	01 d0                	add    %edx,%eax
  8009f0:	c1 e0 03             	shl    $0x3,%eax
  8009f3:	01 c8                	add    %ecx,%eax
  8009f5:	8a 40 04             	mov    0x4(%eax),%al
  8009f8:	84 c0                	test   %al,%al
  8009fa:	75 46                	jne    800a42 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009fc:	a1 24 50 80 00       	mov    0x805024,%eax
  800a01:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800a07:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a0a:	89 d0                	mov    %edx,%eax
  800a0c:	01 c0                	add    %eax,%eax
  800a0e:	01 d0                	add    %edx,%eax
  800a10:	c1 e0 03             	shl    $0x3,%eax
  800a13:	01 c8                	add    %ecx,%eax
  800a15:	8b 00                	mov    (%eax),%eax
  800a17:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a1a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a1d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a22:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800a24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a27:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a31:	01 c8                	add    %ecx,%eax
  800a33:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a35:	39 c2                	cmp    %eax,%edx
  800a37:	75 09                	jne    800a42 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800a39:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a40:	eb 12                	jmp    800a54 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a42:	ff 45 e8             	incl   -0x18(%ebp)
  800a45:	a1 24 50 80 00       	mov    0x805024,%eax
  800a4a:	8b 50 74             	mov    0x74(%eax),%edx
  800a4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a50:	39 c2                	cmp    %eax,%edx
  800a52:	77 88                	ja     8009dc <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a54:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a58:	75 14                	jne    800a6e <CheckWSWithoutLastIndex+0xfb>
			panic(
  800a5a:	83 ec 04             	sub    $0x4,%esp
  800a5d:	68 30 41 80 00       	push   $0x804130
  800a62:	6a 3a                	push   $0x3a
  800a64:	68 24 41 80 00       	push   $0x804124
  800a69:	e8 93 fe ff ff       	call   800901 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a6e:	ff 45 f0             	incl   -0x10(%ebp)
  800a71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a74:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a77:	0f 8c 32 ff ff ff    	jl     8009af <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a7d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a84:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a8b:	eb 26                	jmp    800ab3 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a8d:	a1 24 50 80 00       	mov    0x805024,%eax
  800a92:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800a98:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a9b:	89 d0                	mov    %edx,%eax
  800a9d:	01 c0                	add    %eax,%eax
  800a9f:	01 d0                	add    %edx,%eax
  800aa1:	c1 e0 03             	shl    $0x3,%eax
  800aa4:	01 c8                	add    %ecx,%eax
  800aa6:	8a 40 04             	mov    0x4(%eax),%al
  800aa9:	3c 01                	cmp    $0x1,%al
  800aab:	75 03                	jne    800ab0 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800aad:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ab0:	ff 45 e0             	incl   -0x20(%ebp)
  800ab3:	a1 24 50 80 00       	mov    0x805024,%eax
  800ab8:	8b 50 74             	mov    0x74(%eax),%edx
  800abb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800abe:	39 c2                	cmp    %eax,%edx
  800ac0:	77 cb                	ja     800a8d <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ac5:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800ac8:	74 14                	je     800ade <CheckWSWithoutLastIndex+0x16b>
		panic(
  800aca:	83 ec 04             	sub    $0x4,%esp
  800acd:	68 84 41 80 00       	push   $0x804184
  800ad2:	6a 44                	push   $0x44
  800ad4:	68 24 41 80 00       	push   $0x804124
  800ad9:	e8 23 fe ff ff       	call   800901 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800ade:	90                   	nop
  800adf:	c9                   	leave  
  800ae0:	c3                   	ret    

00800ae1 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800ae1:	55                   	push   %ebp
  800ae2:	89 e5                	mov    %esp,%ebp
  800ae4:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800ae7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aea:	8b 00                	mov    (%eax),%eax
  800aec:	8d 48 01             	lea    0x1(%eax),%ecx
  800aef:	8b 55 0c             	mov    0xc(%ebp),%edx
  800af2:	89 0a                	mov    %ecx,(%edx)
  800af4:	8b 55 08             	mov    0x8(%ebp),%edx
  800af7:	88 d1                	mov    %dl,%cl
  800af9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800afc:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800b00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b03:	8b 00                	mov    (%eax),%eax
  800b05:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b0a:	75 2c                	jne    800b38 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800b0c:	a0 28 50 80 00       	mov    0x805028,%al
  800b11:	0f b6 c0             	movzbl %al,%eax
  800b14:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b17:	8b 12                	mov    (%edx),%edx
  800b19:	89 d1                	mov    %edx,%ecx
  800b1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b1e:	83 c2 08             	add    $0x8,%edx
  800b21:	83 ec 04             	sub    $0x4,%esp
  800b24:	50                   	push   %eax
  800b25:	51                   	push   %ecx
  800b26:	52                   	push   %edx
  800b27:	e8 de 13 00 00       	call   801f0a <sys_cputs>
  800b2c:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b32:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3b:	8b 40 04             	mov    0x4(%eax),%eax
  800b3e:	8d 50 01             	lea    0x1(%eax),%edx
  800b41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b44:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b47:	90                   	nop
  800b48:	c9                   	leave  
  800b49:	c3                   	ret    

00800b4a <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b4a:	55                   	push   %ebp
  800b4b:	89 e5                	mov    %esp,%ebp
  800b4d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b53:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b5a:	00 00 00 
	b.cnt = 0;
  800b5d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b64:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b67:	ff 75 0c             	pushl  0xc(%ebp)
  800b6a:	ff 75 08             	pushl  0x8(%ebp)
  800b6d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b73:	50                   	push   %eax
  800b74:	68 e1 0a 80 00       	push   $0x800ae1
  800b79:	e8 11 02 00 00       	call   800d8f <vprintfmt>
  800b7e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800b81:	a0 28 50 80 00       	mov    0x805028,%al
  800b86:	0f b6 c0             	movzbl %al,%eax
  800b89:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800b8f:	83 ec 04             	sub    $0x4,%esp
  800b92:	50                   	push   %eax
  800b93:	52                   	push   %edx
  800b94:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b9a:	83 c0 08             	add    $0x8,%eax
  800b9d:	50                   	push   %eax
  800b9e:	e8 67 13 00 00       	call   801f0a <sys_cputs>
  800ba3:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800ba6:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800bad:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800bb3:	c9                   	leave  
  800bb4:	c3                   	ret    

00800bb5 <cprintf>:

int cprintf(const char *fmt, ...) {
  800bb5:	55                   	push   %ebp
  800bb6:	89 e5                	mov    %esp,%ebp
  800bb8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800bbb:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800bc2:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcb:	83 ec 08             	sub    $0x8,%esp
  800bce:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd1:	50                   	push   %eax
  800bd2:	e8 73 ff ff ff       	call   800b4a <vcprintf>
  800bd7:	83 c4 10             	add    $0x10,%esp
  800bda:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800bdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800be0:	c9                   	leave  
  800be1:	c3                   	ret    

00800be2 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800be2:	55                   	push   %ebp
  800be3:	89 e5                	mov    %esp,%ebp
  800be5:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800be8:	e8 cb 14 00 00       	call   8020b8 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800bed:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bf0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf6:	83 ec 08             	sub    $0x8,%esp
  800bf9:	ff 75 f4             	pushl  -0xc(%ebp)
  800bfc:	50                   	push   %eax
  800bfd:	e8 48 ff ff ff       	call   800b4a <vcprintf>
  800c02:	83 c4 10             	add    $0x10,%esp
  800c05:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800c08:	e8 c5 14 00 00       	call   8020d2 <sys_enable_interrupt>
	return cnt;
  800c0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c10:	c9                   	leave  
  800c11:	c3                   	ret    

00800c12 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c12:	55                   	push   %ebp
  800c13:	89 e5                	mov    %esp,%ebp
  800c15:	53                   	push   %ebx
  800c16:	83 ec 14             	sub    $0x14,%esp
  800c19:	8b 45 10             	mov    0x10(%ebp),%eax
  800c1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c1f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c22:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c25:	8b 45 18             	mov    0x18(%ebp),%eax
  800c28:	ba 00 00 00 00       	mov    $0x0,%edx
  800c2d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c30:	77 55                	ja     800c87 <printnum+0x75>
  800c32:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c35:	72 05                	jb     800c3c <printnum+0x2a>
  800c37:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c3a:	77 4b                	ja     800c87 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c3c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800c3f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800c42:	8b 45 18             	mov    0x18(%ebp),%eax
  800c45:	ba 00 00 00 00       	mov    $0x0,%edx
  800c4a:	52                   	push   %edx
  800c4b:	50                   	push   %eax
  800c4c:	ff 75 f4             	pushl  -0xc(%ebp)
  800c4f:	ff 75 f0             	pushl  -0x10(%ebp)
  800c52:	e8 39 2f 00 00       	call   803b90 <__udivdi3>
  800c57:	83 c4 10             	add    $0x10,%esp
  800c5a:	83 ec 04             	sub    $0x4,%esp
  800c5d:	ff 75 20             	pushl  0x20(%ebp)
  800c60:	53                   	push   %ebx
  800c61:	ff 75 18             	pushl  0x18(%ebp)
  800c64:	52                   	push   %edx
  800c65:	50                   	push   %eax
  800c66:	ff 75 0c             	pushl  0xc(%ebp)
  800c69:	ff 75 08             	pushl  0x8(%ebp)
  800c6c:	e8 a1 ff ff ff       	call   800c12 <printnum>
  800c71:	83 c4 20             	add    $0x20,%esp
  800c74:	eb 1a                	jmp    800c90 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c76:	83 ec 08             	sub    $0x8,%esp
  800c79:	ff 75 0c             	pushl  0xc(%ebp)
  800c7c:	ff 75 20             	pushl  0x20(%ebp)
  800c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c82:	ff d0                	call   *%eax
  800c84:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c87:	ff 4d 1c             	decl   0x1c(%ebp)
  800c8a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c8e:	7f e6                	jg     800c76 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c90:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c93:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c9e:	53                   	push   %ebx
  800c9f:	51                   	push   %ecx
  800ca0:	52                   	push   %edx
  800ca1:	50                   	push   %eax
  800ca2:	e8 f9 2f 00 00       	call   803ca0 <__umoddi3>
  800ca7:	83 c4 10             	add    $0x10,%esp
  800caa:	05 f4 43 80 00       	add    $0x8043f4,%eax
  800caf:	8a 00                	mov    (%eax),%al
  800cb1:	0f be c0             	movsbl %al,%eax
  800cb4:	83 ec 08             	sub    $0x8,%esp
  800cb7:	ff 75 0c             	pushl  0xc(%ebp)
  800cba:	50                   	push   %eax
  800cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbe:	ff d0                	call   *%eax
  800cc0:	83 c4 10             	add    $0x10,%esp
}
  800cc3:	90                   	nop
  800cc4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800cc7:	c9                   	leave  
  800cc8:	c3                   	ret    

00800cc9 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800cc9:	55                   	push   %ebp
  800cca:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ccc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800cd0:	7e 1c                	jle    800cee <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd5:	8b 00                	mov    (%eax),%eax
  800cd7:	8d 50 08             	lea    0x8(%eax),%edx
  800cda:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdd:	89 10                	mov    %edx,(%eax)
  800cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce2:	8b 00                	mov    (%eax),%eax
  800ce4:	83 e8 08             	sub    $0x8,%eax
  800ce7:	8b 50 04             	mov    0x4(%eax),%edx
  800cea:	8b 00                	mov    (%eax),%eax
  800cec:	eb 40                	jmp    800d2e <getuint+0x65>
	else if (lflag)
  800cee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cf2:	74 1e                	je     800d12 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf7:	8b 00                	mov    (%eax),%eax
  800cf9:	8d 50 04             	lea    0x4(%eax),%edx
  800cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cff:	89 10                	mov    %edx,(%eax)
  800d01:	8b 45 08             	mov    0x8(%ebp),%eax
  800d04:	8b 00                	mov    (%eax),%eax
  800d06:	83 e8 04             	sub    $0x4,%eax
  800d09:	8b 00                	mov    (%eax),%eax
  800d0b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d10:	eb 1c                	jmp    800d2e <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800d12:	8b 45 08             	mov    0x8(%ebp),%eax
  800d15:	8b 00                	mov    (%eax),%eax
  800d17:	8d 50 04             	lea    0x4(%eax),%edx
  800d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1d:	89 10                	mov    %edx,(%eax)
  800d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d22:	8b 00                	mov    (%eax),%eax
  800d24:	83 e8 04             	sub    $0x4,%eax
  800d27:	8b 00                	mov    (%eax),%eax
  800d29:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800d2e:	5d                   	pop    %ebp
  800d2f:	c3                   	ret    

00800d30 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800d30:	55                   	push   %ebp
  800d31:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d33:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d37:	7e 1c                	jle    800d55 <getint+0x25>
		return va_arg(*ap, long long);
  800d39:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3c:	8b 00                	mov    (%eax),%eax
  800d3e:	8d 50 08             	lea    0x8(%eax),%edx
  800d41:	8b 45 08             	mov    0x8(%ebp),%eax
  800d44:	89 10                	mov    %edx,(%eax)
  800d46:	8b 45 08             	mov    0x8(%ebp),%eax
  800d49:	8b 00                	mov    (%eax),%eax
  800d4b:	83 e8 08             	sub    $0x8,%eax
  800d4e:	8b 50 04             	mov    0x4(%eax),%edx
  800d51:	8b 00                	mov    (%eax),%eax
  800d53:	eb 38                	jmp    800d8d <getint+0x5d>
	else if (lflag)
  800d55:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d59:	74 1a                	je     800d75 <getint+0x45>
		return va_arg(*ap, long);
  800d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5e:	8b 00                	mov    (%eax),%eax
  800d60:	8d 50 04             	lea    0x4(%eax),%edx
  800d63:	8b 45 08             	mov    0x8(%ebp),%eax
  800d66:	89 10                	mov    %edx,(%eax)
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6b:	8b 00                	mov    (%eax),%eax
  800d6d:	83 e8 04             	sub    $0x4,%eax
  800d70:	8b 00                	mov    (%eax),%eax
  800d72:	99                   	cltd   
  800d73:	eb 18                	jmp    800d8d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d75:	8b 45 08             	mov    0x8(%ebp),%eax
  800d78:	8b 00                	mov    (%eax),%eax
  800d7a:	8d 50 04             	lea    0x4(%eax),%edx
  800d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d80:	89 10                	mov    %edx,(%eax)
  800d82:	8b 45 08             	mov    0x8(%ebp),%eax
  800d85:	8b 00                	mov    (%eax),%eax
  800d87:	83 e8 04             	sub    $0x4,%eax
  800d8a:	8b 00                	mov    (%eax),%eax
  800d8c:	99                   	cltd   
}
  800d8d:	5d                   	pop    %ebp
  800d8e:	c3                   	ret    

00800d8f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d8f:	55                   	push   %ebp
  800d90:	89 e5                	mov    %esp,%ebp
  800d92:	56                   	push   %esi
  800d93:	53                   	push   %ebx
  800d94:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d97:	eb 17                	jmp    800db0 <vprintfmt+0x21>
			if (ch == '\0')
  800d99:	85 db                	test   %ebx,%ebx
  800d9b:	0f 84 af 03 00 00    	je     801150 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800da1:	83 ec 08             	sub    $0x8,%esp
  800da4:	ff 75 0c             	pushl  0xc(%ebp)
  800da7:	53                   	push   %ebx
  800da8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dab:	ff d0                	call   *%eax
  800dad:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800db0:	8b 45 10             	mov    0x10(%ebp),%eax
  800db3:	8d 50 01             	lea    0x1(%eax),%edx
  800db6:	89 55 10             	mov    %edx,0x10(%ebp)
  800db9:	8a 00                	mov    (%eax),%al
  800dbb:	0f b6 d8             	movzbl %al,%ebx
  800dbe:	83 fb 25             	cmp    $0x25,%ebx
  800dc1:	75 d6                	jne    800d99 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800dc3:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800dc7:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800dce:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800dd5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800ddc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800de3:	8b 45 10             	mov    0x10(%ebp),%eax
  800de6:	8d 50 01             	lea    0x1(%eax),%edx
  800de9:	89 55 10             	mov    %edx,0x10(%ebp)
  800dec:	8a 00                	mov    (%eax),%al
  800dee:	0f b6 d8             	movzbl %al,%ebx
  800df1:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800df4:	83 f8 55             	cmp    $0x55,%eax
  800df7:	0f 87 2b 03 00 00    	ja     801128 <vprintfmt+0x399>
  800dfd:	8b 04 85 18 44 80 00 	mov    0x804418(,%eax,4),%eax
  800e04:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800e06:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800e0a:	eb d7                	jmp    800de3 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800e0c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800e10:	eb d1                	jmp    800de3 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e12:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800e19:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e1c:	89 d0                	mov    %edx,%eax
  800e1e:	c1 e0 02             	shl    $0x2,%eax
  800e21:	01 d0                	add    %edx,%eax
  800e23:	01 c0                	add    %eax,%eax
  800e25:	01 d8                	add    %ebx,%eax
  800e27:	83 e8 30             	sub    $0x30,%eax
  800e2a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800e2d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e30:	8a 00                	mov    (%eax),%al
  800e32:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e35:	83 fb 2f             	cmp    $0x2f,%ebx
  800e38:	7e 3e                	jle    800e78 <vprintfmt+0xe9>
  800e3a:	83 fb 39             	cmp    $0x39,%ebx
  800e3d:	7f 39                	jg     800e78 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e3f:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800e42:	eb d5                	jmp    800e19 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800e44:	8b 45 14             	mov    0x14(%ebp),%eax
  800e47:	83 c0 04             	add    $0x4,%eax
  800e4a:	89 45 14             	mov    %eax,0x14(%ebp)
  800e4d:	8b 45 14             	mov    0x14(%ebp),%eax
  800e50:	83 e8 04             	sub    $0x4,%eax
  800e53:	8b 00                	mov    (%eax),%eax
  800e55:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800e58:	eb 1f                	jmp    800e79 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800e5a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e5e:	79 83                	jns    800de3 <vprintfmt+0x54>
				width = 0;
  800e60:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800e67:	e9 77 ff ff ff       	jmp    800de3 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e6c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e73:	e9 6b ff ff ff       	jmp    800de3 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e78:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e79:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e7d:	0f 89 60 ff ff ff    	jns    800de3 <vprintfmt+0x54>
				width = precision, precision = -1;
  800e83:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e86:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e89:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e90:	e9 4e ff ff ff       	jmp    800de3 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e95:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800e98:	e9 46 ff ff ff       	jmp    800de3 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800e9d:	8b 45 14             	mov    0x14(%ebp),%eax
  800ea0:	83 c0 04             	add    $0x4,%eax
  800ea3:	89 45 14             	mov    %eax,0x14(%ebp)
  800ea6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ea9:	83 e8 04             	sub    $0x4,%eax
  800eac:	8b 00                	mov    (%eax),%eax
  800eae:	83 ec 08             	sub    $0x8,%esp
  800eb1:	ff 75 0c             	pushl  0xc(%ebp)
  800eb4:	50                   	push   %eax
  800eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb8:	ff d0                	call   *%eax
  800eba:	83 c4 10             	add    $0x10,%esp
			break;
  800ebd:	e9 89 02 00 00       	jmp    80114b <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ec2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec5:	83 c0 04             	add    $0x4,%eax
  800ec8:	89 45 14             	mov    %eax,0x14(%ebp)
  800ecb:	8b 45 14             	mov    0x14(%ebp),%eax
  800ece:	83 e8 04             	sub    $0x4,%eax
  800ed1:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ed3:	85 db                	test   %ebx,%ebx
  800ed5:	79 02                	jns    800ed9 <vprintfmt+0x14a>
				err = -err;
  800ed7:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ed9:	83 fb 64             	cmp    $0x64,%ebx
  800edc:	7f 0b                	jg     800ee9 <vprintfmt+0x15a>
  800ede:	8b 34 9d 60 42 80 00 	mov    0x804260(,%ebx,4),%esi
  800ee5:	85 f6                	test   %esi,%esi
  800ee7:	75 19                	jne    800f02 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ee9:	53                   	push   %ebx
  800eea:	68 05 44 80 00       	push   $0x804405
  800eef:	ff 75 0c             	pushl  0xc(%ebp)
  800ef2:	ff 75 08             	pushl  0x8(%ebp)
  800ef5:	e8 5e 02 00 00       	call   801158 <printfmt>
  800efa:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800efd:	e9 49 02 00 00       	jmp    80114b <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800f02:	56                   	push   %esi
  800f03:	68 0e 44 80 00       	push   $0x80440e
  800f08:	ff 75 0c             	pushl  0xc(%ebp)
  800f0b:	ff 75 08             	pushl  0x8(%ebp)
  800f0e:	e8 45 02 00 00       	call   801158 <printfmt>
  800f13:	83 c4 10             	add    $0x10,%esp
			break;
  800f16:	e9 30 02 00 00       	jmp    80114b <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800f1b:	8b 45 14             	mov    0x14(%ebp),%eax
  800f1e:	83 c0 04             	add    $0x4,%eax
  800f21:	89 45 14             	mov    %eax,0x14(%ebp)
  800f24:	8b 45 14             	mov    0x14(%ebp),%eax
  800f27:	83 e8 04             	sub    $0x4,%eax
  800f2a:	8b 30                	mov    (%eax),%esi
  800f2c:	85 f6                	test   %esi,%esi
  800f2e:	75 05                	jne    800f35 <vprintfmt+0x1a6>
				p = "(null)";
  800f30:	be 11 44 80 00       	mov    $0x804411,%esi
			if (width > 0 && padc != '-')
  800f35:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f39:	7e 6d                	jle    800fa8 <vprintfmt+0x219>
  800f3b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800f3f:	74 67                	je     800fa8 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800f41:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f44:	83 ec 08             	sub    $0x8,%esp
  800f47:	50                   	push   %eax
  800f48:	56                   	push   %esi
  800f49:	e8 12 05 00 00       	call   801460 <strnlen>
  800f4e:	83 c4 10             	add    $0x10,%esp
  800f51:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800f54:	eb 16                	jmp    800f6c <vprintfmt+0x1dd>
					putch(padc, putdat);
  800f56:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800f5a:	83 ec 08             	sub    $0x8,%esp
  800f5d:	ff 75 0c             	pushl  0xc(%ebp)
  800f60:	50                   	push   %eax
  800f61:	8b 45 08             	mov    0x8(%ebp),%eax
  800f64:	ff d0                	call   *%eax
  800f66:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f69:	ff 4d e4             	decl   -0x1c(%ebp)
  800f6c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f70:	7f e4                	jg     800f56 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f72:	eb 34                	jmp    800fa8 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f74:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f78:	74 1c                	je     800f96 <vprintfmt+0x207>
  800f7a:	83 fb 1f             	cmp    $0x1f,%ebx
  800f7d:	7e 05                	jle    800f84 <vprintfmt+0x1f5>
  800f7f:	83 fb 7e             	cmp    $0x7e,%ebx
  800f82:	7e 12                	jle    800f96 <vprintfmt+0x207>
					putch('?', putdat);
  800f84:	83 ec 08             	sub    $0x8,%esp
  800f87:	ff 75 0c             	pushl  0xc(%ebp)
  800f8a:	6a 3f                	push   $0x3f
  800f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8f:	ff d0                	call   *%eax
  800f91:	83 c4 10             	add    $0x10,%esp
  800f94:	eb 0f                	jmp    800fa5 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800f96:	83 ec 08             	sub    $0x8,%esp
  800f99:	ff 75 0c             	pushl  0xc(%ebp)
  800f9c:	53                   	push   %ebx
  800f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa0:	ff d0                	call   *%eax
  800fa2:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800fa5:	ff 4d e4             	decl   -0x1c(%ebp)
  800fa8:	89 f0                	mov    %esi,%eax
  800faa:	8d 70 01             	lea    0x1(%eax),%esi
  800fad:	8a 00                	mov    (%eax),%al
  800faf:	0f be d8             	movsbl %al,%ebx
  800fb2:	85 db                	test   %ebx,%ebx
  800fb4:	74 24                	je     800fda <vprintfmt+0x24b>
  800fb6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fba:	78 b8                	js     800f74 <vprintfmt+0x1e5>
  800fbc:	ff 4d e0             	decl   -0x20(%ebp)
  800fbf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fc3:	79 af                	jns    800f74 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fc5:	eb 13                	jmp    800fda <vprintfmt+0x24b>
				putch(' ', putdat);
  800fc7:	83 ec 08             	sub    $0x8,%esp
  800fca:	ff 75 0c             	pushl  0xc(%ebp)
  800fcd:	6a 20                	push   $0x20
  800fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd2:	ff d0                	call   *%eax
  800fd4:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fd7:	ff 4d e4             	decl   -0x1c(%ebp)
  800fda:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fde:	7f e7                	jg     800fc7 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800fe0:	e9 66 01 00 00       	jmp    80114b <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800fe5:	83 ec 08             	sub    $0x8,%esp
  800fe8:	ff 75 e8             	pushl  -0x18(%ebp)
  800feb:	8d 45 14             	lea    0x14(%ebp),%eax
  800fee:	50                   	push   %eax
  800fef:	e8 3c fd ff ff       	call   800d30 <getint>
  800ff4:	83 c4 10             	add    $0x10,%esp
  800ff7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ffa:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ffd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801000:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801003:	85 d2                	test   %edx,%edx
  801005:	79 23                	jns    80102a <vprintfmt+0x29b>
				putch('-', putdat);
  801007:	83 ec 08             	sub    $0x8,%esp
  80100a:	ff 75 0c             	pushl  0xc(%ebp)
  80100d:	6a 2d                	push   $0x2d
  80100f:	8b 45 08             	mov    0x8(%ebp),%eax
  801012:	ff d0                	call   *%eax
  801014:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801017:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80101a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80101d:	f7 d8                	neg    %eax
  80101f:	83 d2 00             	adc    $0x0,%edx
  801022:	f7 da                	neg    %edx
  801024:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801027:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80102a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801031:	e9 bc 00 00 00       	jmp    8010f2 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801036:	83 ec 08             	sub    $0x8,%esp
  801039:	ff 75 e8             	pushl  -0x18(%ebp)
  80103c:	8d 45 14             	lea    0x14(%ebp),%eax
  80103f:	50                   	push   %eax
  801040:	e8 84 fc ff ff       	call   800cc9 <getuint>
  801045:	83 c4 10             	add    $0x10,%esp
  801048:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80104b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80104e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801055:	e9 98 00 00 00       	jmp    8010f2 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80105a:	83 ec 08             	sub    $0x8,%esp
  80105d:	ff 75 0c             	pushl  0xc(%ebp)
  801060:	6a 58                	push   $0x58
  801062:	8b 45 08             	mov    0x8(%ebp),%eax
  801065:	ff d0                	call   *%eax
  801067:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80106a:	83 ec 08             	sub    $0x8,%esp
  80106d:	ff 75 0c             	pushl  0xc(%ebp)
  801070:	6a 58                	push   $0x58
  801072:	8b 45 08             	mov    0x8(%ebp),%eax
  801075:	ff d0                	call   *%eax
  801077:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80107a:	83 ec 08             	sub    $0x8,%esp
  80107d:	ff 75 0c             	pushl  0xc(%ebp)
  801080:	6a 58                	push   $0x58
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	ff d0                	call   *%eax
  801087:	83 c4 10             	add    $0x10,%esp
			break;
  80108a:	e9 bc 00 00 00       	jmp    80114b <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80108f:	83 ec 08             	sub    $0x8,%esp
  801092:	ff 75 0c             	pushl  0xc(%ebp)
  801095:	6a 30                	push   $0x30
  801097:	8b 45 08             	mov    0x8(%ebp),%eax
  80109a:	ff d0                	call   *%eax
  80109c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80109f:	83 ec 08             	sub    $0x8,%esp
  8010a2:	ff 75 0c             	pushl  0xc(%ebp)
  8010a5:	6a 78                	push   $0x78
  8010a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010aa:	ff d0                	call   *%eax
  8010ac:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8010af:	8b 45 14             	mov    0x14(%ebp),%eax
  8010b2:	83 c0 04             	add    $0x4,%eax
  8010b5:	89 45 14             	mov    %eax,0x14(%ebp)
  8010b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8010bb:	83 e8 04             	sub    $0x4,%eax
  8010be:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8010c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8010ca:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8010d1:	eb 1f                	jmp    8010f2 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8010d3:	83 ec 08             	sub    $0x8,%esp
  8010d6:	ff 75 e8             	pushl  -0x18(%ebp)
  8010d9:	8d 45 14             	lea    0x14(%ebp),%eax
  8010dc:	50                   	push   %eax
  8010dd:	e8 e7 fb ff ff       	call   800cc9 <getuint>
  8010e2:	83 c4 10             	add    $0x10,%esp
  8010e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010e8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8010eb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8010f2:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8010f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010f9:	83 ec 04             	sub    $0x4,%esp
  8010fc:	52                   	push   %edx
  8010fd:	ff 75 e4             	pushl  -0x1c(%ebp)
  801100:	50                   	push   %eax
  801101:	ff 75 f4             	pushl  -0xc(%ebp)
  801104:	ff 75 f0             	pushl  -0x10(%ebp)
  801107:	ff 75 0c             	pushl  0xc(%ebp)
  80110a:	ff 75 08             	pushl  0x8(%ebp)
  80110d:	e8 00 fb ff ff       	call   800c12 <printnum>
  801112:	83 c4 20             	add    $0x20,%esp
			break;
  801115:	eb 34                	jmp    80114b <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801117:	83 ec 08             	sub    $0x8,%esp
  80111a:	ff 75 0c             	pushl  0xc(%ebp)
  80111d:	53                   	push   %ebx
  80111e:	8b 45 08             	mov    0x8(%ebp),%eax
  801121:	ff d0                	call   *%eax
  801123:	83 c4 10             	add    $0x10,%esp
			break;
  801126:	eb 23                	jmp    80114b <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801128:	83 ec 08             	sub    $0x8,%esp
  80112b:	ff 75 0c             	pushl  0xc(%ebp)
  80112e:	6a 25                	push   $0x25
  801130:	8b 45 08             	mov    0x8(%ebp),%eax
  801133:	ff d0                	call   *%eax
  801135:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801138:	ff 4d 10             	decl   0x10(%ebp)
  80113b:	eb 03                	jmp    801140 <vprintfmt+0x3b1>
  80113d:	ff 4d 10             	decl   0x10(%ebp)
  801140:	8b 45 10             	mov    0x10(%ebp),%eax
  801143:	48                   	dec    %eax
  801144:	8a 00                	mov    (%eax),%al
  801146:	3c 25                	cmp    $0x25,%al
  801148:	75 f3                	jne    80113d <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80114a:	90                   	nop
		}
	}
  80114b:	e9 47 fc ff ff       	jmp    800d97 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801150:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801151:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801154:	5b                   	pop    %ebx
  801155:	5e                   	pop    %esi
  801156:	5d                   	pop    %ebp
  801157:	c3                   	ret    

00801158 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801158:	55                   	push   %ebp
  801159:	89 e5                	mov    %esp,%ebp
  80115b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80115e:	8d 45 10             	lea    0x10(%ebp),%eax
  801161:	83 c0 04             	add    $0x4,%eax
  801164:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801167:	8b 45 10             	mov    0x10(%ebp),%eax
  80116a:	ff 75 f4             	pushl  -0xc(%ebp)
  80116d:	50                   	push   %eax
  80116e:	ff 75 0c             	pushl  0xc(%ebp)
  801171:	ff 75 08             	pushl  0x8(%ebp)
  801174:	e8 16 fc ff ff       	call   800d8f <vprintfmt>
  801179:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80117c:	90                   	nop
  80117d:	c9                   	leave  
  80117e:	c3                   	ret    

0080117f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80117f:	55                   	push   %ebp
  801180:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801182:	8b 45 0c             	mov    0xc(%ebp),%eax
  801185:	8b 40 08             	mov    0x8(%eax),%eax
  801188:	8d 50 01             	lea    0x1(%eax),%edx
  80118b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801191:	8b 45 0c             	mov    0xc(%ebp),%eax
  801194:	8b 10                	mov    (%eax),%edx
  801196:	8b 45 0c             	mov    0xc(%ebp),%eax
  801199:	8b 40 04             	mov    0x4(%eax),%eax
  80119c:	39 c2                	cmp    %eax,%edx
  80119e:	73 12                	jae    8011b2 <sprintputch+0x33>
		*b->buf++ = ch;
  8011a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a3:	8b 00                	mov    (%eax),%eax
  8011a5:	8d 48 01             	lea    0x1(%eax),%ecx
  8011a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011ab:	89 0a                	mov    %ecx,(%edx)
  8011ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b0:	88 10                	mov    %dl,(%eax)
}
  8011b2:	90                   	nop
  8011b3:	5d                   	pop    %ebp
  8011b4:	c3                   	ret    

008011b5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8011b5:	55                   	push   %ebp
  8011b6:	89 e5                	mov    %esp,%ebp
  8011b8:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8011bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011be:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8011c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ca:	01 d0                	add    %edx,%eax
  8011cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8011d6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011da:	74 06                	je     8011e2 <vsnprintf+0x2d>
  8011dc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011e0:	7f 07                	jg     8011e9 <vsnprintf+0x34>
		return -E_INVAL;
  8011e2:	b8 03 00 00 00       	mov    $0x3,%eax
  8011e7:	eb 20                	jmp    801209 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8011e9:	ff 75 14             	pushl  0x14(%ebp)
  8011ec:	ff 75 10             	pushl  0x10(%ebp)
  8011ef:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8011f2:	50                   	push   %eax
  8011f3:	68 7f 11 80 00       	push   $0x80117f
  8011f8:	e8 92 fb ff ff       	call   800d8f <vprintfmt>
  8011fd:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801200:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801203:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801206:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801209:	c9                   	leave  
  80120a:	c3                   	ret    

0080120b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80120b:	55                   	push   %ebp
  80120c:	89 e5                	mov    %esp,%ebp
  80120e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801211:	8d 45 10             	lea    0x10(%ebp),%eax
  801214:	83 c0 04             	add    $0x4,%eax
  801217:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80121a:	8b 45 10             	mov    0x10(%ebp),%eax
  80121d:	ff 75 f4             	pushl  -0xc(%ebp)
  801220:	50                   	push   %eax
  801221:	ff 75 0c             	pushl  0xc(%ebp)
  801224:	ff 75 08             	pushl  0x8(%ebp)
  801227:	e8 89 ff ff ff       	call   8011b5 <vsnprintf>
  80122c:	83 c4 10             	add    $0x10,%esp
  80122f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801232:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801235:	c9                   	leave  
  801236:	c3                   	ret    

00801237 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  801237:	55                   	push   %ebp
  801238:	89 e5                	mov    %esp,%ebp
  80123a:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  80123d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801241:	74 13                	je     801256 <readline+0x1f>
		cprintf("%s", prompt);
  801243:	83 ec 08             	sub    $0x8,%esp
  801246:	ff 75 08             	pushl  0x8(%ebp)
  801249:	68 70 45 80 00       	push   $0x804570
  80124e:	e8 62 f9 ff ff       	call   800bb5 <cprintf>
  801253:	83 c4 10             	add    $0x10,%esp

	i = 0;
  801256:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  80125d:	83 ec 0c             	sub    $0xc,%esp
  801260:	6a 00                	push   $0x0
  801262:	e8 54 f5 ff ff       	call   8007bb <iscons>
  801267:	83 c4 10             	add    $0x10,%esp
  80126a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  80126d:	e8 fb f4 ff ff       	call   80076d <getchar>
  801272:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801275:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801279:	79 22                	jns    80129d <readline+0x66>
			if (c != -E_EOF)
  80127b:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80127f:	0f 84 ad 00 00 00    	je     801332 <readline+0xfb>
				cprintf("read error: %e\n", c);
  801285:	83 ec 08             	sub    $0x8,%esp
  801288:	ff 75 ec             	pushl  -0x14(%ebp)
  80128b:	68 73 45 80 00       	push   $0x804573
  801290:	e8 20 f9 ff ff       	call   800bb5 <cprintf>
  801295:	83 c4 10             	add    $0x10,%esp
			return;
  801298:	e9 95 00 00 00       	jmp    801332 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80129d:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8012a1:	7e 34                	jle    8012d7 <readline+0xa0>
  8012a3:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8012aa:	7f 2b                	jg     8012d7 <readline+0xa0>
			if (echoing)
  8012ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012b0:	74 0e                	je     8012c0 <readline+0x89>
				cputchar(c);
  8012b2:	83 ec 0c             	sub    $0xc,%esp
  8012b5:	ff 75 ec             	pushl  -0x14(%ebp)
  8012b8:	e8 68 f4 ff ff       	call   800725 <cputchar>
  8012bd:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8012c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012c3:	8d 50 01             	lea    0x1(%eax),%edx
  8012c6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8012c9:	89 c2                	mov    %eax,%edx
  8012cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ce:	01 d0                	add    %edx,%eax
  8012d0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012d3:	88 10                	mov    %dl,(%eax)
  8012d5:	eb 56                	jmp    80132d <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  8012d7:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8012db:	75 1f                	jne    8012fc <readline+0xc5>
  8012dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8012e1:	7e 19                	jle    8012fc <readline+0xc5>
			if (echoing)
  8012e3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012e7:	74 0e                	je     8012f7 <readline+0xc0>
				cputchar(c);
  8012e9:	83 ec 0c             	sub    $0xc,%esp
  8012ec:	ff 75 ec             	pushl  -0x14(%ebp)
  8012ef:	e8 31 f4 ff ff       	call   800725 <cputchar>
  8012f4:	83 c4 10             	add    $0x10,%esp

			i--;
  8012f7:	ff 4d f4             	decl   -0xc(%ebp)
  8012fa:	eb 31                	jmp    80132d <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  8012fc:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801300:	74 0a                	je     80130c <readline+0xd5>
  801302:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801306:	0f 85 61 ff ff ff    	jne    80126d <readline+0x36>
			if (echoing)
  80130c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801310:	74 0e                	je     801320 <readline+0xe9>
				cputchar(c);
  801312:	83 ec 0c             	sub    $0xc,%esp
  801315:	ff 75 ec             	pushl  -0x14(%ebp)
  801318:	e8 08 f4 ff ff       	call   800725 <cputchar>
  80131d:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  801320:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801323:	8b 45 0c             	mov    0xc(%ebp),%eax
  801326:	01 d0                	add    %edx,%eax
  801328:	c6 00 00             	movb   $0x0,(%eax)
			return;
  80132b:	eb 06                	jmp    801333 <readline+0xfc>
		}
	}
  80132d:	e9 3b ff ff ff       	jmp    80126d <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  801332:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  801333:	c9                   	leave  
  801334:	c3                   	ret    

00801335 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  801335:	55                   	push   %ebp
  801336:	89 e5                	mov    %esp,%ebp
  801338:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80133b:	e8 78 0d 00 00       	call   8020b8 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  801340:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801344:	74 13                	je     801359 <atomic_readline+0x24>
		cprintf("%s", prompt);
  801346:	83 ec 08             	sub    $0x8,%esp
  801349:	ff 75 08             	pushl  0x8(%ebp)
  80134c:	68 70 45 80 00       	push   $0x804570
  801351:	e8 5f f8 ff ff       	call   800bb5 <cprintf>
  801356:	83 c4 10             	add    $0x10,%esp

	i = 0;
  801359:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801360:	83 ec 0c             	sub    $0xc,%esp
  801363:	6a 00                	push   $0x0
  801365:	e8 51 f4 ff ff       	call   8007bb <iscons>
  80136a:	83 c4 10             	add    $0x10,%esp
  80136d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801370:	e8 f8 f3 ff ff       	call   80076d <getchar>
  801375:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801378:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80137c:	79 23                	jns    8013a1 <atomic_readline+0x6c>
			if (c != -E_EOF)
  80137e:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801382:	74 13                	je     801397 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  801384:	83 ec 08             	sub    $0x8,%esp
  801387:	ff 75 ec             	pushl  -0x14(%ebp)
  80138a:	68 73 45 80 00       	push   $0x804573
  80138f:	e8 21 f8 ff ff       	call   800bb5 <cprintf>
  801394:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801397:	e8 36 0d 00 00       	call   8020d2 <sys_enable_interrupt>
			return;
  80139c:	e9 9a 00 00 00       	jmp    80143b <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8013a1:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8013a5:	7e 34                	jle    8013db <atomic_readline+0xa6>
  8013a7:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8013ae:	7f 2b                	jg     8013db <atomic_readline+0xa6>
			if (echoing)
  8013b0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013b4:	74 0e                	je     8013c4 <atomic_readline+0x8f>
				cputchar(c);
  8013b6:	83 ec 0c             	sub    $0xc,%esp
  8013b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8013bc:	e8 64 f3 ff ff       	call   800725 <cputchar>
  8013c1:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8013c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013c7:	8d 50 01             	lea    0x1(%eax),%edx
  8013ca:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8013cd:	89 c2                	mov    %eax,%edx
  8013cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d2:	01 d0                	add    %edx,%eax
  8013d4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013d7:	88 10                	mov    %dl,(%eax)
  8013d9:	eb 5b                	jmp    801436 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  8013db:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8013df:	75 1f                	jne    801400 <atomic_readline+0xcb>
  8013e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8013e5:	7e 19                	jle    801400 <atomic_readline+0xcb>
			if (echoing)
  8013e7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013eb:	74 0e                	je     8013fb <atomic_readline+0xc6>
				cputchar(c);
  8013ed:	83 ec 0c             	sub    $0xc,%esp
  8013f0:	ff 75 ec             	pushl  -0x14(%ebp)
  8013f3:	e8 2d f3 ff ff       	call   800725 <cputchar>
  8013f8:	83 c4 10             	add    $0x10,%esp
			i--;
  8013fb:	ff 4d f4             	decl   -0xc(%ebp)
  8013fe:	eb 36                	jmp    801436 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  801400:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801404:	74 0a                	je     801410 <atomic_readline+0xdb>
  801406:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80140a:	0f 85 60 ff ff ff    	jne    801370 <atomic_readline+0x3b>
			if (echoing)
  801410:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801414:	74 0e                	je     801424 <atomic_readline+0xef>
				cputchar(c);
  801416:	83 ec 0c             	sub    $0xc,%esp
  801419:	ff 75 ec             	pushl  -0x14(%ebp)
  80141c:	e8 04 f3 ff ff       	call   800725 <cputchar>
  801421:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  801424:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801427:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142a:	01 d0                	add    %edx,%eax
  80142c:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  80142f:	e8 9e 0c 00 00       	call   8020d2 <sys_enable_interrupt>
			return;
  801434:	eb 05                	jmp    80143b <atomic_readline+0x106>
		}
	}
  801436:	e9 35 ff ff ff       	jmp    801370 <atomic_readline+0x3b>
}
  80143b:	c9                   	leave  
  80143c:	c3                   	ret    

0080143d <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80143d:	55                   	push   %ebp
  80143e:	89 e5                	mov    %esp,%ebp
  801440:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801443:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80144a:	eb 06                	jmp    801452 <strlen+0x15>
		n++;
  80144c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80144f:	ff 45 08             	incl   0x8(%ebp)
  801452:	8b 45 08             	mov    0x8(%ebp),%eax
  801455:	8a 00                	mov    (%eax),%al
  801457:	84 c0                	test   %al,%al
  801459:	75 f1                	jne    80144c <strlen+0xf>
		n++;
	return n;
  80145b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80145e:	c9                   	leave  
  80145f:	c3                   	ret    

00801460 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801460:	55                   	push   %ebp
  801461:	89 e5                	mov    %esp,%ebp
  801463:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801466:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80146d:	eb 09                	jmp    801478 <strnlen+0x18>
		n++;
  80146f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801472:	ff 45 08             	incl   0x8(%ebp)
  801475:	ff 4d 0c             	decl   0xc(%ebp)
  801478:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80147c:	74 09                	je     801487 <strnlen+0x27>
  80147e:	8b 45 08             	mov    0x8(%ebp),%eax
  801481:	8a 00                	mov    (%eax),%al
  801483:	84 c0                	test   %al,%al
  801485:	75 e8                	jne    80146f <strnlen+0xf>
		n++;
	return n;
  801487:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80148a:	c9                   	leave  
  80148b:	c3                   	ret    

0080148c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80148c:	55                   	push   %ebp
  80148d:	89 e5                	mov    %esp,%ebp
  80148f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801492:	8b 45 08             	mov    0x8(%ebp),%eax
  801495:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801498:	90                   	nop
  801499:	8b 45 08             	mov    0x8(%ebp),%eax
  80149c:	8d 50 01             	lea    0x1(%eax),%edx
  80149f:	89 55 08             	mov    %edx,0x8(%ebp)
  8014a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014a5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014a8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8014ab:	8a 12                	mov    (%edx),%dl
  8014ad:	88 10                	mov    %dl,(%eax)
  8014af:	8a 00                	mov    (%eax),%al
  8014b1:	84 c0                	test   %al,%al
  8014b3:	75 e4                	jne    801499 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8014b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8014b8:	c9                   	leave  
  8014b9:	c3                   	ret    

008014ba <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8014ba:	55                   	push   %ebp
  8014bb:	89 e5                	mov    %esp,%ebp
  8014bd:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8014c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8014c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014cd:	eb 1f                	jmp    8014ee <strncpy+0x34>
		*dst++ = *src;
  8014cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d2:	8d 50 01             	lea    0x1(%eax),%edx
  8014d5:	89 55 08             	mov    %edx,0x8(%ebp)
  8014d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014db:	8a 12                	mov    (%edx),%dl
  8014dd:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8014df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e2:	8a 00                	mov    (%eax),%al
  8014e4:	84 c0                	test   %al,%al
  8014e6:	74 03                	je     8014eb <strncpy+0x31>
			src++;
  8014e8:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8014eb:	ff 45 fc             	incl   -0x4(%ebp)
  8014ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014f1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014f4:	72 d9                	jb     8014cf <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8014f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014f9:	c9                   	leave  
  8014fa:	c3                   	ret    

008014fb <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8014fb:	55                   	push   %ebp
  8014fc:	89 e5                	mov    %esp,%ebp
  8014fe:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801501:	8b 45 08             	mov    0x8(%ebp),%eax
  801504:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801507:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80150b:	74 30                	je     80153d <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80150d:	eb 16                	jmp    801525 <strlcpy+0x2a>
			*dst++ = *src++;
  80150f:	8b 45 08             	mov    0x8(%ebp),%eax
  801512:	8d 50 01             	lea    0x1(%eax),%edx
  801515:	89 55 08             	mov    %edx,0x8(%ebp)
  801518:	8b 55 0c             	mov    0xc(%ebp),%edx
  80151b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80151e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801521:	8a 12                	mov    (%edx),%dl
  801523:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801525:	ff 4d 10             	decl   0x10(%ebp)
  801528:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80152c:	74 09                	je     801537 <strlcpy+0x3c>
  80152e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801531:	8a 00                	mov    (%eax),%al
  801533:	84 c0                	test   %al,%al
  801535:	75 d8                	jne    80150f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801537:	8b 45 08             	mov    0x8(%ebp),%eax
  80153a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80153d:	8b 55 08             	mov    0x8(%ebp),%edx
  801540:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801543:	29 c2                	sub    %eax,%edx
  801545:	89 d0                	mov    %edx,%eax
}
  801547:	c9                   	leave  
  801548:	c3                   	ret    

00801549 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801549:	55                   	push   %ebp
  80154a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80154c:	eb 06                	jmp    801554 <strcmp+0xb>
		p++, q++;
  80154e:	ff 45 08             	incl   0x8(%ebp)
  801551:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801554:	8b 45 08             	mov    0x8(%ebp),%eax
  801557:	8a 00                	mov    (%eax),%al
  801559:	84 c0                	test   %al,%al
  80155b:	74 0e                	je     80156b <strcmp+0x22>
  80155d:	8b 45 08             	mov    0x8(%ebp),%eax
  801560:	8a 10                	mov    (%eax),%dl
  801562:	8b 45 0c             	mov    0xc(%ebp),%eax
  801565:	8a 00                	mov    (%eax),%al
  801567:	38 c2                	cmp    %al,%dl
  801569:	74 e3                	je     80154e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80156b:	8b 45 08             	mov    0x8(%ebp),%eax
  80156e:	8a 00                	mov    (%eax),%al
  801570:	0f b6 d0             	movzbl %al,%edx
  801573:	8b 45 0c             	mov    0xc(%ebp),%eax
  801576:	8a 00                	mov    (%eax),%al
  801578:	0f b6 c0             	movzbl %al,%eax
  80157b:	29 c2                	sub    %eax,%edx
  80157d:	89 d0                	mov    %edx,%eax
}
  80157f:	5d                   	pop    %ebp
  801580:	c3                   	ret    

00801581 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801581:	55                   	push   %ebp
  801582:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801584:	eb 09                	jmp    80158f <strncmp+0xe>
		n--, p++, q++;
  801586:	ff 4d 10             	decl   0x10(%ebp)
  801589:	ff 45 08             	incl   0x8(%ebp)
  80158c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80158f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801593:	74 17                	je     8015ac <strncmp+0x2b>
  801595:	8b 45 08             	mov    0x8(%ebp),%eax
  801598:	8a 00                	mov    (%eax),%al
  80159a:	84 c0                	test   %al,%al
  80159c:	74 0e                	je     8015ac <strncmp+0x2b>
  80159e:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a1:	8a 10                	mov    (%eax),%dl
  8015a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a6:	8a 00                	mov    (%eax),%al
  8015a8:	38 c2                	cmp    %al,%dl
  8015aa:	74 da                	je     801586 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8015ac:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015b0:	75 07                	jne    8015b9 <strncmp+0x38>
		return 0;
  8015b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8015b7:	eb 14                	jmp    8015cd <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8015b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bc:	8a 00                	mov    (%eax),%al
  8015be:	0f b6 d0             	movzbl %al,%edx
  8015c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c4:	8a 00                	mov    (%eax),%al
  8015c6:	0f b6 c0             	movzbl %al,%eax
  8015c9:	29 c2                	sub    %eax,%edx
  8015cb:	89 d0                	mov    %edx,%eax
}
  8015cd:	5d                   	pop    %ebp
  8015ce:	c3                   	ret    

008015cf <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8015cf:	55                   	push   %ebp
  8015d0:	89 e5                	mov    %esp,%ebp
  8015d2:	83 ec 04             	sub    $0x4,%esp
  8015d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015db:	eb 12                	jmp    8015ef <strchr+0x20>
		if (*s == c)
  8015dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e0:	8a 00                	mov    (%eax),%al
  8015e2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015e5:	75 05                	jne    8015ec <strchr+0x1d>
			return (char *) s;
  8015e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ea:	eb 11                	jmp    8015fd <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8015ec:	ff 45 08             	incl   0x8(%ebp)
  8015ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f2:	8a 00                	mov    (%eax),%al
  8015f4:	84 c0                	test   %al,%al
  8015f6:	75 e5                	jne    8015dd <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8015f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015fd:	c9                   	leave  
  8015fe:	c3                   	ret    

008015ff <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8015ff:	55                   	push   %ebp
  801600:	89 e5                	mov    %esp,%ebp
  801602:	83 ec 04             	sub    $0x4,%esp
  801605:	8b 45 0c             	mov    0xc(%ebp),%eax
  801608:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80160b:	eb 0d                	jmp    80161a <strfind+0x1b>
		if (*s == c)
  80160d:	8b 45 08             	mov    0x8(%ebp),%eax
  801610:	8a 00                	mov    (%eax),%al
  801612:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801615:	74 0e                	je     801625 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801617:	ff 45 08             	incl   0x8(%ebp)
  80161a:	8b 45 08             	mov    0x8(%ebp),%eax
  80161d:	8a 00                	mov    (%eax),%al
  80161f:	84 c0                	test   %al,%al
  801621:	75 ea                	jne    80160d <strfind+0xe>
  801623:	eb 01                	jmp    801626 <strfind+0x27>
		if (*s == c)
			break;
  801625:	90                   	nop
	return (char *) s;
  801626:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801629:	c9                   	leave  
  80162a:	c3                   	ret    

0080162b <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80162b:	55                   	push   %ebp
  80162c:	89 e5                	mov    %esp,%ebp
  80162e:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801631:	8b 45 08             	mov    0x8(%ebp),%eax
  801634:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801637:	8b 45 10             	mov    0x10(%ebp),%eax
  80163a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80163d:	eb 0e                	jmp    80164d <memset+0x22>
		*p++ = c;
  80163f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801642:	8d 50 01             	lea    0x1(%eax),%edx
  801645:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801648:	8b 55 0c             	mov    0xc(%ebp),%edx
  80164b:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80164d:	ff 4d f8             	decl   -0x8(%ebp)
  801650:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801654:	79 e9                	jns    80163f <memset+0x14>
		*p++ = c;

	return v;
  801656:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801659:	c9                   	leave  
  80165a:	c3                   	ret    

0080165b <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80165b:	55                   	push   %ebp
  80165c:	89 e5                	mov    %esp,%ebp
  80165e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801661:	8b 45 0c             	mov    0xc(%ebp),%eax
  801664:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801667:	8b 45 08             	mov    0x8(%ebp),%eax
  80166a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80166d:	eb 16                	jmp    801685 <memcpy+0x2a>
		*d++ = *s++;
  80166f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801672:	8d 50 01             	lea    0x1(%eax),%edx
  801675:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801678:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80167b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80167e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801681:	8a 12                	mov    (%edx),%dl
  801683:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801685:	8b 45 10             	mov    0x10(%ebp),%eax
  801688:	8d 50 ff             	lea    -0x1(%eax),%edx
  80168b:	89 55 10             	mov    %edx,0x10(%ebp)
  80168e:	85 c0                	test   %eax,%eax
  801690:	75 dd                	jne    80166f <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801692:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801695:	c9                   	leave  
  801696:	c3                   	ret    

00801697 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801697:	55                   	push   %ebp
  801698:	89 e5                	mov    %esp,%ebp
  80169a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80169d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8016a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8016a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016ac:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8016af:	73 50                	jae    801701 <memmove+0x6a>
  8016b1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b7:	01 d0                	add    %edx,%eax
  8016b9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8016bc:	76 43                	jbe    801701 <memmove+0x6a>
		s += n;
  8016be:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c1:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8016c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c7:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8016ca:	eb 10                	jmp    8016dc <memmove+0x45>
			*--d = *--s;
  8016cc:	ff 4d f8             	decl   -0x8(%ebp)
  8016cf:	ff 4d fc             	decl   -0x4(%ebp)
  8016d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016d5:	8a 10                	mov    (%eax),%dl
  8016d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016da:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8016dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8016df:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016e2:	89 55 10             	mov    %edx,0x10(%ebp)
  8016e5:	85 c0                	test   %eax,%eax
  8016e7:	75 e3                	jne    8016cc <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8016e9:	eb 23                	jmp    80170e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8016eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016ee:	8d 50 01             	lea    0x1(%eax),%edx
  8016f1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016f4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016f7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016fa:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8016fd:	8a 12                	mov    (%edx),%dl
  8016ff:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801701:	8b 45 10             	mov    0x10(%ebp),%eax
  801704:	8d 50 ff             	lea    -0x1(%eax),%edx
  801707:	89 55 10             	mov    %edx,0x10(%ebp)
  80170a:	85 c0                	test   %eax,%eax
  80170c:	75 dd                	jne    8016eb <memmove+0x54>
			*d++ = *s++;

	return dst;
  80170e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801711:	c9                   	leave  
  801712:	c3                   	ret    

00801713 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801713:	55                   	push   %ebp
  801714:	89 e5                	mov    %esp,%ebp
  801716:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801719:	8b 45 08             	mov    0x8(%ebp),%eax
  80171c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80171f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801722:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801725:	eb 2a                	jmp    801751 <memcmp+0x3e>
		if (*s1 != *s2)
  801727:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80172a:	8a 10                	mov    (%eax),%dl
  80172c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80172f:	8a 00                	mov    (%eax),%al
  801731:	38 c2                	cmp    %al,%dl
  801733:	74 16                	je     80174b <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801735:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801738:	8a 00                	mov    (%eax),%al
  80173a:	0f b6 d0             	movzbl %al,%edx
  80173d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801740:	8a 00                	mov    (%eax),%al
  801742:	0f b6 c0             	movzbl %al,%eax
  801745:	29 c2                	sub    %eax,%edx
  801747:	89 d0                	mov    %edx,%eax
  801749:	eb 18                	jmp    801763 <memcmp+0x50>
		s1++, s2++;
  80174b:	ff 45 fc             	incl   -0x4(%ebp)
  80174e:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801751:	8b 45 10             	mov    0x10(%ebp),%eax
  801754:	8d 50 ff             	lea    -0x1(%eax),%edx
  801757:	89 55 10             	mov    %edx,0x10(%ebp)
  80175a:	85 c0                	test   %eax,%eax
  80175c:	75 c9                	jne    801727 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80175e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801763:	c9                   	leave  
  801764:	c3                   	ret    

00801765 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801765:	55                   	push   %ebp
  801766:	89 e5                	mov    %esp,%ebp
  801768:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80176b:	8b 55 08             	mov    0x8(%ebp),%edx
  80176e:	8b 45 10             	mov    0x10(%ebp),%eax
  801771:	01 d0                	add    %edx,%eax
  801773:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801776:	eb 15                	jmp    80178d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801778:	8b 45 08             	mov    0x8(%ebp),%eax
  80177b:	8a 00                	mov    (%eax),%al
  80177d:	0f b6 d0             	movzbl %al,%edx
  801780:	8b 45 0c             	mov    0xc(%ebp),%eax
  801783:	0f b6 c0             	movzbl %al,%eax
  801786:	39 c2                	cmp    %eax,%edx
  801788:	74 0d                	je     801797 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80178a:	ff 45 08             	incl   0x8(%ebp)
  80178d:	8b 45 08             	mov    0x8(%ebp),%eax
  801790:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801793:	72 e3                	jb     801778 <memfind+0x13>
  801795:	eb 01                	jmp    801798 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801797:	90                   	nop
	return (void *) s;
  801798:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80179b:	c9                   	leave  
  80179c:	c3                   	ret    

0080179d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80179d:	55                   	push   %ebp
  80179e:	89 e5                	mov    %esp,%ebp
  8017a0:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8017a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8017aa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017b1:	eb 03                	jmp    8017b6 <strtol+0x19>
		s++;
  8017b3:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b9:	8a 00                	mov    (%eax),%al
  8017bb:	3c 20                	cmp    $0x20,%al
  8017bd:	74 f4                	je     8017b3 <strtol+0x16>
  8017bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c2:	8a 00                	mov    (%eax),%al
  8017c4:	3c 09                	cmp    $0x9,%al
  8017c6:	74 eb                	je     8017b3 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8017c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cb:	8a 00                	mov    (%eax),%al
  8017cd:	3c 2b                	cmp    $0x2b,%al
  8017cf:	75 05                	jne    8017d6 <strtol+0x39>
		s++;
  8017d1:	ff 45 08             	incl   0x8(%ebp)
  8017d4:	eb 13                	jmp    8017e9 <strtol+0x4c>
	else if (*s == '-')
  8017d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d9:	8a 00                	mov    (%eax),%al
  8017db:	3c 2d                	cmp    $0x2d,%al
  8017dd:	75 0a                	jne    8017e9 <strtol+0x4c>
		s++, neg = 1;
  8017df:	ff 45 08             	incl   0x8(%ebp)
  8017e2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017e9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017ed:	74 06                	je     8017f5 <strtol+0x58>
  8017ef:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8017f3:	75 20                	jne    801815 <strtol+0x78>
  8017f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f8:	8a 00                	mov    (%eax),%al
  8017fa:	3c 30                	cmp    $0x30,%al
  8017fc:	75 17                	jne    801815 <strtol+0x78>
  8017fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801801:	40                   	inc    %eax
  801802:	8a 00                	mov    (%eax),%al
  801804:	3c 78                	cmp    $0x78,%al
  801806:	75 0d                	jne    801815 <strtol+0x78>
		s += 2, base = 16;
  801808:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80180c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801813:	eb 28                	jmp    80183d <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801815:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801819:	75 15                	jne    801830 <strtol+0x93>
  80181b:	8b 45 08             	mov    0x8(%ebp),%eax
  80181e:	8a 00                	mov    (%eax),%al
  801820:	3c 30                	cmp    $0x30,%al
  801822:	75 0c                	jne    801830 <strtol+0x93>
		s++, base = 8;
  801824:	ff 45 08             	incl   0x8(%ebp)
  801827:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80182e:	eb 0d                	jmp    80183d <strtol+0xa0>
	else if (base == 0)
  801830:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801834:	75 07                	jne    80183d <strtol+0xa0>
		base = 10;
  801836:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80183d:	8b 45 08             	mov    0x8(%ebp),%eax
  801840:	8a 00                	mov    (%eax),%al
  801842:	3c 2f                	cmp    $0x2f,%al
  801844:	7e 19                	jle    80185f <strtol+0xc2>
  801846:	8b 45 08             	mov    0x8(%ebp),%eax
  801849:	8a 00                	mov    (%eax),%al
  80184b:	3c 39                	cmp    $0x39,%al
  80184d:	7f 10                	jg     80185f <strtol+0xc2>
			dig = *s - '0';
  80184f:	8b 45 08             	mov    0x8(%ebp),%eax
  801852:	8a 00                	mov    (%eax),%al
  801854:	0f be c0             	movsbl %al,%eax
  801857:	83 e8 30             	sub    $0x30,%eax
  80185a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80185d:	eb 42                	jmp    8018a1 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80185f:	8b 45 08             	mov    0x8(%ebp),%eax
  801862:	8a 00                	mov    (%eax),%al
  801864:	3c 60                	cmp    $0x60,%al
  801866:	7e 19                	jle    801881 <strtol+0xe4>
  801868:	8b 45 08             	mov    0x8(%ebp),%eax
  80186b:	8a 00                	mov    (%eax),%al
  80186d:	3c 7a                	cmp    $0x7a,%al
  80186f:	7f 10                	jg     801881 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801871:	8b 45 08             	mov    0x8(%ebp),%eax
  801874:	8a 00                	mov    (%eax),%al
  801876:	0f be c0             	movsbl %al,%eax
  801879:	83 e8 57             	sub    $0x57,%eax
  80187c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80187f:	eb 20                	jmp    8018a1 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801881:	8b 45 08             	mov    0x8(%ebp),%eax
  801884:	8a 00                	mov    (%eax),%al
  801886:	3c 40                	cmp    $0x40,%al
  801888:	7e 39                	jle    8018c3 <strtol+0x126>
  80188a:	8b 45 08             	mov    0x8(%ebp),%eax
  80188d:	8a 00                	mov    (%eax),%al
  80188f:	3c 5a                	cmp    $0x5a,%al
  801891:	7f 30                	jg     8018c3 <strtol+0x126>
			dig = *s - 'A' + 10;
  801893:	8b 45 08             	mov    0x8(%ebp),%eax
  801896:	8a 00                	mov    (%eax),%al
  801898:	0f be c0             	movsbl %al,%eax
  80189b:	83 e8 37             	sub    $0x37,%eax
  80189e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8018a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018a4:	3b 45 10             	cmp    0x10(%ebp),%eax
  8018a7:	7d 19                	jge    8018c2 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8018a9:	ff 45 08             	incl   0x8(%ebp)
  8018ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018af:	0f af 45 10          	imul   0x10(%ebp),%eax
  8018b3:	89 c2                	mov    %eax,%edx
  8018b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018b8:	01 d0                	add    %edx,%eax
  8018ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8018bd:	e9 7b ff ff ff       	jmp    80183d <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8018c2:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8018c3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8018c7:	74 08                	je     8018d1 <strtol+0x134>
		*endptr = (char *) s;
  8018c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8018cf:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8018d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018d5:	74 07                	je     8018de <strtol+0x141>
  8018d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018da:	f7 d8                	neg    %eax
  8018dc:	eb 03                	jmp    8018e1 <strtol+0x144>
  8018de:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8018e1:	c9                   	leave  
  8018e2:	c3                   	ret    

008018e3 <ltostr>:

void
ltostr(long value, char *str)
{
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
  8018e6:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8018e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8018f0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8018f7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018fb:	79 13                	jns    801910 <ltostr+0x2d>
	{
		neg = 1;
  8018fd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801904:	8b 45 0c             	mov    0xc(%ebp),%eax
  801907:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80190a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80190d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801910:	8b 45 08             	mov    0x8(%ebp),%eax
  801913:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801918:	99                   	cltd   
  801919:	f7 f9                	idiv   %ecx
  80191b:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80191e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801921:	8d 50 01             	lea    0x1(%eax),%edx
  801924:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801927:	89 c2                	mov    %eax,%edx
  801929:	8b 45 0c             	mov    0xc(%ebp),%eax
  80192c:	01 d0                	add    %edx,%eax
  80192e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801931:	83 c2 30             	add    $0x30,%edx
  801934:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801936:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801939:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80193e:	f7 e9                	imul   %ecx
  801940:	c1 fa 02             	sar    $0x2,%edx
  801943:	89 c8                	mov    %ecx,%eax
  801945:	c1 f8 1f             	sar    $0x1f,%eax
  801948:	29 c2                	sub    %eax,%edx
  80194a:	89 d0                	mov    %edx,%eax
  80194c:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80194f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801952:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801957:	f7 e9                	imul   %ecx
  801959:	c1 fa 02             	sar    $0x2,%edx
  80195c:	89 c8                	mov    %ecx,%eax
  80195e:	c1 f8 1f             	sar    $0x1f,%eax
  801961:	29 c2                	sub    %eax,%edx
  801963:	89 d0                	mov    %edx,%eax
  801965:	c1 e0 02             	shl    $0x2,%eax
  801968:	01 d0                	add    %edx,%eax
  80196a:	01 c0                	add    %eax,%eax
  80196c:	29 c1                	sub    %eax,%ecx
  80196e:	89 ca                	mov    %ecx,%edx
  801970:	85 d2                	test   %edx,%edx
  801972:	75 9c                	jne    801910 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801974:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80197b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80197e:	48                   	dec    %eax
  80197f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801982:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801986:	74 3d                	je     8019c5 <ltostr+0xe2>
		start = 1 ;
  801988:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80198f:	eb 34                	jmp    8019c5 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801991:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801994:	8b 45 0c             	mov    0xc(%ebp),%eax
  801997:	01 d0                	add    %edx,%eax
  801999:	8a 00                	mov    (%eax),%al
  80199b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80199e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a4:	01 c2                	add    %eax,%edx
  8019a6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8019a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ac:	01 c8                	add    %ecx,%eax
  8019ae:	8a 00                	mov    (%eax),%al
  8019b0:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8019b2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019b8:	01 c2                	add    %eax,%edx
  8019ba:	8a 45 eb             	mov    -0x15(%ebp),%al
  8019bd:	88 02                	mov    %al,(%edx)
		start++ ;
  8019bf:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8019c2:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8019c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019cb:	7c c4                	jl     801991 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8019cd:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8019d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019d3:	01 d0                	add    %edx,%eax
  8019d5:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8019d8:	90                   	nop
  8019d9:	c9                   	leave  
  8019da:	c3                   	ret    

008019db <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8019db:	55                   	push   %ebp
  8019dc:	89 e5                	mov    %esp,%ebp
  8019de:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8019e1:	ff 75 08             	pushl  0x8(%ebp)
  8019e4:	e8 54 fa ff ff       	call   80143d <strlen>
  8019e9:	83 c4 04             	add    $0x4,%esp
  8019ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8019ef:	ff 75 0c             	pushl  0xc(%ebp)
  8019f2:	e8 46 fa ff ff       	call   80143d <strlen>
  8019f7:	83 c4 04             	add    $0x4,%esp
  8019fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8019fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801a04:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801a0b:	eb 17                	jmp    801a24 <strcconcat+0x49>
		final[s] = str1[s] ;
  801a0d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a10:	8b 45 10             	mov    0x10(%ebp),%eax
  801a13:	01 c2                	add    %eax,%edx
  801a15:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801a18:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1b:	01 c8                	add    %ecx,%eax
  801a1d:	8a 00                	mov    (%eax),%al
  801a1f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801a21:	ff 45 fc             	incl   -0x4(%ebp)
  801a24:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a27:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801a2a:	7c e1                	jl     801a0d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801a2c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801a33:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801a3a:	eb 1f                	jmp    801a5b <strcconcat+0x80>
		final[s++] = str2[i] ;
  801a3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a3f:	8d 50 01             	lea    0x1(%eax),%edx
  801a42:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801a45:	89 c2                	mov    %eax,%edx
  801a47:	8b 45 10             	mov    0x10(%ebp),%eax
  801a4a:	01 c2                	add    %eax,%edx
  801a4c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801a4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a52:	01 c8                	add    %ecx,%eax
  801a54:	8a 00                	mov    (%eax),%al
  801a56:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801a58:	ff 45 f8             	incl   -0x8(%ebp)
  801a5b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a5e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a61:	7c d9                	jl     801a3c <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801a63:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a66:	8b 45 10             	mov    0x10(%ebp),%eax
  801a69:	01 d0                	add    %edx,%eax
  801a6b:	c6 00 00             	movb   $0x0,(%eax)
}
  801a6e:	90                   	nop
  801a6f:	c9                   	leave  
  801a70:	c3                   	ret    

00801a71 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801a71:	55                   	push   %ebp
  801a72:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801a74:	8b 45 14             	mov    0x14(%ebp),%eax
  801a77:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801a7d:	8b 45 14             	mov    0x14(%ebp),%eax
  801a80:	8b 00                	mov    (%eax),%eax
  801a82:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a89:	8b 45 10             	mov    0x10(%ebp),%eax
  801a8c:	01 d0                	add    %edx,%eax
  801a8e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a94:	eb 0c                	jmp    801aa2 <strsplit+0x31>
			*string++ = 0;
  801a96:	8b 45 08             	mov    0x8(%ebp),%eax
  801a99:	8d 50 01             	lea    0x1(%eax),%edx
  801a9c:	89 55 08             	mov    %edx,0x8(%ebp)
  801a9f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa5:	8a 00                	mov    (%eax),%al
  801aa7:	84 c0                	test   %al,%al
  801aa9:	74 18                	je     801ac3 <strsplit+0x52>
  801aab:	8b 45 08             	mov    0x8(%ebp),%eax
  801aae:	8a 00                	mov    (%eax),%al
  801ab0:	0f be c0             	movsbl %al,%eax
  801ab3:	50                   	push   %eax
  801ab4:	ff 75 0c             	pushl  0xc(%ebp)
  801ab7:	e8 13 fb ff ff       	call   8015cf <strchr>
  801abc:	83 c4 08             	add    $0x8,%esp
  801abf:	85 c0                	test   %eax,%eax
  801ac1:	75 d3                	jne    801a96 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac6:	8a 00                	mov    (%eax),%al
  801ac8:	84 c0                	test   %al,%al
  801aca:	74 5a                	je     801b26 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801acc:	8b 45 14             	mov    0x14(%ebp),%eax
  801acf:	8b 00                	mov    (%eax),%eax
  801ad1:	83 f8 0f             	cmp    $0xf,%eax
  801ad4:	75 07                	jne    801add <strsplit+0x6c>
		{
			return 0;
  801ad6:	b8 00 00 00 00       	mov    $0x0,%eax
  801adb:	eb 66                	jmp    801b43 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801add:	8b 45 14             	mov    0x14(%ebp),%eax
  801ae0:	8b 00                	mov    (%eax),%eax
  801ae2:	8d 48 01             	lea    0x1(%eax),%ecx
  801ae5:	8b 55 14             	mov    0x14(%ebp),%edx
  801ae8:	89 0a                	mov    %ecx,(%edx)
  801aea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801af1:	8b 45 10             	mov    0x10(%ebp),%eax
  801af4:	01 c2                	add    %eax,%edx
  801af6:	8b 45 08             	mov    0x8(%ebp),%eax
  801af9:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801afb:	eb 03                	jmp    801b00 <strsplit+0x8f>
			string++;
  801afd:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801b00:	8b 45 08             	mov    0x8(%ebp),%eax
  801b03:	8a 00                	mov    (%eax),%al
  801b05:	84 c0                	test   %al,%al
  801b07:	74 8b                	je     801a94 <strsplit+0x23>
  801b09:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0c:	8a 00                	mov    (%eax),%al
  801b0e:	0f be c0             	movsbl %al,%eax
  801b11:	50                   	push   %eax
  801b12:	ff 75 0c             	pushl  0xc(%ebp)
  801b15:	e8 b5 fa ff ff       	call   8015cf <strchr>
  801b1a:	83 c4 08             	add    $0x8,%esp
  801b1d:	85 c0                	test   %eax,%eax
  801b1f:	74 dc                	je     801afd <strsplit+0x8c>
			string++;
	}
  801b21:	e9 6e ff ff ff       	jmp    801a94 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801b26:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801b27:	8b 45 14             	mov    0x14(%ebp),%eax
  801b2a:	8b 00                	mov    (%eax),%eax
  801b2c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b33:	8b 45 10             	mov    0x10(%ebp),%eax
  801b36:	01 d0                	add    %edx,%eax
  801b38:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801b3e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801b43:	c9                   	leave  
  801b44:	c3                   	ret    

00801b45 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801b45:	55                   	push   %ebp
  801b46:	89 e5                	mov    %esp,%ebp
  801b48:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801b4b:	a1 04 50 80 00       	mov    0x805004,%eax
  801b50:	85 c0                	test   %eax,%eax
  801b52:	74 1f                	je     801b73 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801b54:	e8 1d 00 00 00       	call   801b76 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801b59:	83 ec 0c             	sub    $0xc,%esp
  801b5c:	68 84 45 80 00       	push   $0x804584
  801b61:	e8 4f f0 ff ff       	call   800bb5 <cprintf>
  801b66:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801b69:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801b70:	00 00 00 
	}
}
  801b73:	90                   	nop
  801b74:	c9                   	leave  
  801b75:	c3                   	ret    

00801b76 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801b76:	55                   	push   %ebp
  801b77:	89 e5                	mov    %esp,%ebp
  801b79:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  801b7c:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801b83:	00 00 00 
  801b86:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801b8d:	00 00 00 
  801b90:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801b97:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801b9a:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801ba1:	00 00 00 
  801ba4:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801bab:	00 00 00 
  801bae:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801bb5:	00 00 00 
	uint32 arr_size = 0;
  801bb8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  801bbf:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801bc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bc9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801bce:	2d 00 10 00 00       	sub    $0x1000,%eax
  801bd3:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  801bd8:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801bdf:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  801be2:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801be9:	a1 20 51 80 00       	mov    0x805120,%eax
  801bee:	c1 e0 04             	shl    $0x4,%eax
  801bf1:	89 c2                	mov    %eax,%edx
  801bf3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bf6:	01 d0                	add    %edx,%eax
  801bf8:	48                   	dec    %eax
  801bf9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801bfc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bff:	ba 00 00 00 00       	mov    $0x0,%edx
  801c04:	f7 75 ec             	divl   -0x14(%ebp)
  801c07:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c0a:	29 d0                	sub    %edx,%eax
  801c0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  801c0f:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801c16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c19:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c1e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801c23:	83 ec 04             	sub    $0x4,%esp
  801c26:	6a 06                	push   $0x6
  801c28:	ff 75 f4             	pushl  -0xc(%ebp)
  801c2b:	50                   	push   %eax
  801c2c:	e8 1d 04 00 00       	call   80204e <sys_allocate_chunk>
  801c31:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801c34:	a1 20 51 80 00       	mov    0x805120,%eax
  801c39:	83 ec 0c             	sub    $0xc,%esp
  801c3c:	50                   	push   %eax
  801c3d:	e8 92 0a 00 00       	call   8026d4 <initialize_MemBlocksList>
  801c42:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  801c45:	a1 48 51 80 00       	mov    0x805148,%eax
  801c4a:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  801c4d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c50:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  801c57:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c5a:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  801c61:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c65:	75 14                	jne    801c7b <initialize_dyn_block_system+0x105>
  801c67:	83 ec 04             	sub    $0x4,%esp
  801c6a:	68 a9 45 80 00       	push   $0x8045a9
  801c6f:	6a 33                	push   $0x33
  801c71:	68 c7 45 80 00       	push   $0x8045c7
  801c76:	e8 86 ec ff ff       	call   800901 <_panic>
  801c7b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c7e:	8b 00                	mov    (%eax),%eax
  801c80:	85 c0                	test   %eax,%eax
  801c82:	74 10                	je     801c94 <initialize_dyn_block_system+0x11e>
  801c84:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c87:	8b 00                	mov    (%eax),%eax
  801c89:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c8c:	8b 52 04             	mov    0x4(%edx),%edx
  801c8f:	89 50 04             	mov    %edx,0x4(%eax)
  801c92:	eb 0b                	jmp    801c9f <initialize_dyn_block_system+0x129>
  801c94:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c97:	8b 40 04             	mov    0x4(%eax),%eax
  801c9a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801c9f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ca2:	8b 40 04             	mov    0x4(%eax),%eax
  801ca5:	85 c0                	test   %eax,%eax
  801ca7:	74 0f                	je     801cb8 <initialize_dyn_block_system+0x142>
  801ca9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cac:	8b 40 04             	mov    0x4(%eax),%eax
  801caf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801cb2:	8b 12                	mov    (%edx),%edx
  801cb4:	89 10                	mov    %edx,(%eax)
  801cb6:	eb 0a                	jmp    801cc2 <initialize_dyn_block_system+0x14c>
  801cb8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cbb:	8b 00                	mov    (%eax),%eax
  801cbd:	a3 48 51 80 00       	mov    %eax,0x805148
  801cc2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cc5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ccb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801cd5:	a1 54 51 80 00       	mov    0x805154,%eax
  801cda:	48                   	dec    %eax
  801cdb:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  801ce0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ce4:	75 14                	jne    801cfa <initialize_dyn_block_system+0x184>
  801ce6:	83 ec 04             	sub    $0x4,%esp
  801ce9:	68 d4 45 80 00       	push   $0x8045d4
  801cee:	6a 34                	push   $0x34
  801cf0:	68 c7 45 80 00       	push   $0x8045c7
  801cf5:	e8 07 ec ff ff       	call   800901 <_panic>
  801cfa:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801d00:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d03:	89 10                	mov    %edx,(%eax)
  801d05:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d08:	8b 00                	mov    (%eax),%eax
  801d0a:	85 c0                	test   %eax,%eax
  801d0c:	74 0d                	je     801d1b <initialize_dyn_block_system+0x1a5>
  801d0e:	a1 38 51 80 00       	mov    0x805138,%eax
  801d13:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d16:	89 50 04             	mov    %edx,0x4(%eax)
  801d19:	eb 08                	jmp    801d23 <initialize_dyn_block_system+0x1ad>
  801d1b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d1e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801d23:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d26:	a3 38 51 80 00       	mov    %eax,0x805138
  801d2b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d2e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801d35:	a1 44 51 80 00       	mov    0x805144,%eax
  801d3a:	40                   	inc    %eax
  801d3b:	a3 44 51 80 00       	mov    %eax,0x805144
}
  801d40:	90                   	nop
  801d41:	c9                   	leave  
  801d42:	c3                   	ret    

00801d43 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801d43:	55                   	push   %ebp
  801d44:	89 e5                	mov    %esp,%ebp
  801d46:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d49:	e8 f7 fd ff ff       	call   801b45 <InitializeUHeap>
	if (size == 0) return NULL ;
  801d4e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d52:	75 07                	jne    801d5b <malloc+0x18>
  801d54:	b8 00 00 00 00       	mov    $0x0,%eax
  801d59:	eb 14                	jmp    801d6f <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801d5b:	83 ec 04             	sub    $0x4,%esp
  801d5e:	68 f8 45 80 00       	push   $0x8045f8
  801d63:	6a 46                	push   $0x46
  801d65:	68 c7 45 80 00       	push   $0x8045c7
  801d6a:	e8 92 eb ff ff       	call   800901 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801d6f:	c9                   	leave  
  801d70:	c3                   	ret    

00801d71 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801d71:	55                   	push   %ebp
  801d72:	89 e5                	mov    %esp,%ebp
  801d74:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801d77:	83 ec 04             	sub    $0x4,%esp
  801d7a:	68 20 46 80 00       	push   $0x804620
  801d7f:	6a 61                	push   $0x61
  801d81:	68 c7 45 80 00       	push   $0x8045c7
  801d86:	e8 76 eb ff ff       	call   800901 <_panic>

00801d8b <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801d8b:	55                   	push   %ebp
  801d8c:	89 e5                	mov    %esp,%ebp
  801d8e:	83 ec 38             	sub    $0x38,%esp
  801d91:	8b 45 10             	mov    0x10(%ebp),%eax
  801d94:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d97:	e8 a9 fd ff ff       	call   801b45 <InitializeUHeap>
	if (size == 0) return NULL ;
  801d9c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801da0:	75 07                	jne    801da9 <smalloc+0x1e>
  801da2:	b8 00 00 00 00       	mov    $0x0,%eax
  801da7:	eb 7c                	jmp    801e25 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801da9:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801db0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801db3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801db6:	01 d0                	add    %edx,%eax
  801db8:	48                   	dec    %eax
  801db9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801dbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dbf:	ba 00 00 00 00       	mov    $0x0,%edx
  801dc4:	f7 75 f0             	divl   -0x10(%ebp)
  801dc7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dca:	29 d0                	sub    %edx,%eax
  801dcc:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801dcf:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801dd6:	e8 41 06 00 00       	call   80241c <sys_isUHeapPlacementStrategyFIRSTFIT>
  801ddb:	85 c0                	test   %eax,%eax
  801ddd:	74 11                	je     801df0 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  801ddf:	83 ec 0c             	sub    $0xc,%esp
  801de2:	ff 75 e8             	pushl  -0x18(%ebp)
  801de5:	e8 ac 0c 00 00       	call   802a96 <alloc_block_FF>
  801dea:	83 c4 10             	add    $0x10,%esp
  801ded:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801df0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801df4:	74 2a                	je     801e20 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801df6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df9:	8b 40 08             	mov    0x8(%eax),%eax
  801dfc:	89 c2                	mov    %eax,%edx
  801dfe:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801e02:	52                   	push   %edx
  801e03:	50                   	push   %eax
  801e04:	ff 75 0c             	pushl  0xc(%ebp)
  801e07:	ff 75 08             	pushl  0x8(%ebp)
  801e0a:	e8 92 03 00 00       	call   8021a1 <sys_createSharedObject>
  801e0f:	83 c4 10             	add    $0x10,%esp
  801e12:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  801e15:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  801e19:	74 05                	je     801e20 <smalloc+0x95>
			return (void*)virtual_address;
  801e1b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e1e:	eb 05                	jmp    801e25 <smalloc+0x9a>
	}
	return NULL;
  801e20:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801e25:	c9                   	leave  
  801e26:	c3                   	ret    

00801e27 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801e27:	55                   	push   %ebp
  801e28:	89 e5                	mov    %esp,%ebp
  801e2a:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e2d:	e8 13 fd ff ff       	call   801b45 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801e32:	83 ec 04             	sub    $0x4,%esp
  801e35:	68 44 46 80 00       	push   $0x804644
  801e3a:	68 a2 00 00 00       	push   $0xa2
  801e3f:	68 c7 45 80 00       	push   $0x8045c7
  801e44:	e8 b8 ea ff ff       	call   800901 <_panic>

00801e49 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801e49:	55                   	push   %ebp
  801e4a:	89 e5                	mov    %esp,%ebp
  801e4c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e4f:	e8 f1 fc ff ff       	call   801b45 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801e54:	83 ec 04             	sub    $0x4,%esp
  801e57:	68 68 46 80 00       	push   $0x804668
  801e5c:	68 e6 00 00 00       	push   $0xe6
  801e61:	68 c7 45 80 00       	push   $0x8045c7
  801e66:	e8 96 ea ff ff       	call   800901 <_panic>

00801e6b <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801e6b:	55                   	push   %ebp
  801e6c:	89 e5                	mov    %esp,%ebp
  801e6e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801e71:	83 ec 04             	sub    $0x4,%esp
  801e74:	68 90 46 80 00       	push   $0x804690
  801e79:	68 fa 00 00 00       	push   $0xfa
  801e7e:	68 c7 45 80 00       	push   $0x8045c7
  801e83:	e8 79 ea ff ff       	call   800901 <_panic>

00801e88 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801e88:	55                   	push   %ebp
  801e89:	89 e5                	mov    %esp,%ebp
  801e8b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e8e:	83 ec 04             	sub    $0x4,%esp
  801e91:	68 b4 46 80 00       	push   $0x8046b4
  801e96:	68 05 01 00 00       	push   $0x105
  801e9b:	68 c7 45 80 00       	push   $0x8045c7
  801ea0:	e8 5c ea ff ff       	call   800901 <_panic>

00801ea5 <shrink>:

}
void shrink(uint32 newSize)
{
  801ea5:	55                   	push   %ebp
  801ea6:	89 e5                	mov    %esp,%ebp
  801ea8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801eab:	83 ec 04             	sub    $0x4,%esp
  801eae:	68 b4 46 80 00       	push   $0x8046b4
  801eb3:	68 0a 01 00 00       	push   $0x10a
  801eb8:	68 c7 45 80 00       	push   $0x8045c7
  801ebd:	e8 3f ea ff ff       	call   800901 <_panic>

00801ec2 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801ec2:	55                   	push   %ebp
  801ec3:	89 e5                	mov    %esp,%ebp
  801ec5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ec8:	83 ec 04             	sub    $0x4,%esp
  801ecb:	68 b4 46 80 00       	push   $0x8046b4
  801ed0:	68 0f 01 00 00       	push   $0x10f
  801ed5:	68 c7 45 80 00       	push   $0x8045c7
  801eda:	e8 22 ea ff ff       	call   800901 <_panic>

00801edf <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801edf:	55                   	push   %ebp
  801ee0:	89 e5                	mov    %esp,%ebp
  801ee2:	57                   	push   %edi
  801ee3:	56                   	push   %esi
  801ee4:	53                   	push   %ebx
  801ee5:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  801eeb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eee:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ef1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ef4:	8b 7d 18             	mov    0x18(%ebp),%edi
  801ef7:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801efa:	cd 30                	int    $0x30
  801efc:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801eff:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f02:	83 c4 10             	add    $0x10,%esp
  801f05:	5b                   	pop    %ebx
  801f06:	5e                   	pop    %esi
  801f07:	5f                   	pop    %edi
  801f08:	5d                   	pop    %ebp
  801f09:	c3                   	ret    

00801f0a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801f0a:	55                   	push   %ebp
  801f0b:	89 e5                	mov    %esp,%ebp
  801f0d:	83 ec 04             	sub    $0x4,%esp
  801f10:	8b 45 10             	mov    0x10(%ebp),%eax
  801f13:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801f16:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1d:	6a 00                	push   $0x0
  801f1f:	6a 00                	push   $0x0
  801f21:	52                   	push   %edx
  801f22:	ff 75 0c             	pushl  0xc(%ebp)
  801f25:	50                   	push   %eax
  801f26:	6a 00                	push   $0x0
  801f28:	e8 b2 ff ff ff       	call   801edf <syscall>
  801f2d:	83 c4 18             	add    $0x18,%esp
}
  801f30:	90                   	nop
  801f31:	c9                   	leave  
  801f32:	c3                   	ret    

00801f33 <sys_cgetc>:

int
sys_cgetc(void)
{
  801f33:	55                   	push   %ebp
  801f34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801f36:	6a 00                	push   $0x0
  801f38:	6a 00                	push   $0x0
  801f3a:	6a 00                	push   $0x0
  801f3c:	6a 00                	push   $0x0
  801f3e:	6a 00                	push   $0x0
  801f40:	6a 01                	push   $0x1
  801f42:	e8 98 ff ff ff       	call   801edf <syscall>
  801f47:	83 c4 18             	add    $0x18,%esp
}
  801f4a:	c9                   	leave  
  801f4b:	c3                   	ret    

00801f4c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801f4c:	55                   	push   %ebp
  801f4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801f4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f52:	8b 45 08             	mov    0x8(%ebp),%eax
  801f55:	6a 00                	push   $0x0
  801f57:	6a 00                	push   $0x0
  801f59:	6a 00                	push   $0x0
  801f5b:	52                   	push   %edx
  801f5c:	50                   	push   %eax
  801f5d:	6a 05                	push   $0x5
  801f5f:	e8 7b ff ff ff       	call   801edf <syscall>
  801f64:	83 c4 18             	add    $0x18,%esp
}
  801f67:	c9                   	leave  
  801f68:	c3                   	ret    

00801f69 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801f69:	55                   	push   %ebp
  801f6a:	89 e5                	mov    %esp,%ebp
  801f6c:	56                   	push   %esi
  801f6d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801f6e:	8b 75 18             	mov    0x18(%ebp),%esi
  801f71:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f74:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f77:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7d:	56                   	push   %esi
  801f7e:	53                   	push   %ebx
  801f7f:	51                   	push   %ecx
  801f80:	52                   	push   %edx
  801f81:	50                   	push   %eax
  801f82:	6a 06                	push   $0x6
  801f84:	e8 56 ff ff ff       	call   801edf <syscall>
  801f89:	83 c4 18             	add    $0x18,%esp
}
  801f8c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f8f:	5b                   	pop    %ebx
  801f90:	5e                   	pop    %esi
  801f91:	5d                   	pop    %ebp
  801f92:	c3                   	ret    

00801f93 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801f93:	55                   	push   %ebp
  801f94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801f96:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f99:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9c:	6a 00                	push   $0x0
  801f9e:	6a 00                	push   $0x0
  801fa0:	6a 00                	push   $0x0
  801fa2:	52                   	push   %edx
  801fa3:	50                   	push   %eax
  801fa4:	6a 07                	push   $0x7
  801fa6:	e8 34 ff ff ff       	call   801edf <syscall>
  801fab:	83 c4 18             	add    $0x18,%esp
}
  801fae:	c9                   	leave  
  801faf:	c3                   	ret    

00801fb0 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801fb0:	55                   	push   %ebp
  801fb1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801fb3:	6a 00                	push   $0x0
  801fb5:	6a 00                	push   $0x0
  801fb7:	6a 00                	push   $0x0
  801fb9:	ff 75 0c             	pushl  0xc(%ebp)
  801fbc:	ff 75 08             	pushl  0x8(%ebp)
  801fbf:	6a 08                	push   $0x8
  801fc1:	e8 19 ff ff ff       	call   801edf <syscall>
  801fc6:	83 c4 18             	add    $0x18,%esp
}
  801fc9:	c9                   	leave  
  801fca:	c3                   	ret    

00801fcb <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801fcb:	55                   	push   %ebp
  801fcc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801fce:	6a 00                	push   $0x0
  801fd0:	6a 00                	push   $0x0
  801fd2:	6a 00                	push   $0x0
  801fd4:	6a 00                	push   $0x0
  801fd6:	6a 00                	push   $0x0
  801fd8:	6a 09                	push   $0x9
  801fda:	e8 00 ff ff ff       	call   801edf <syscall>
  801fdf:	83 c4 18             	add    $0x18,%esp
}
  801fe2:	c9                   	leave  
  801fe3:	c3                   	ret    

00801fe4 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801fe4:	55                   	push   %ebp
  801fe5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801fe7:	6a 00                	push   $0x0
  801fe9:	6a 00                	push   $0x0
  801feb:	6a 00                	push   $0x0
  801fed:	6a 00                	push   $0x0
  801fef:	6a 00                	push   $0x0
  801ff1:	6a 0a                	push   $0xa
  801ff3:	e8 e7 fe ff ff       	call   801edf <syscall>
  801ff8:	83 c4 18             	add    $0x18,%esp
}
  801ffb:	c9                   	leave  
  801ffc:	c3                   	ret    

00801ffd <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801ffd:	55                   	push   %ebp
  801ffe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802000:	6a 00                	push   $0x0
  802002:	6a 00                	push   $0x0
  802004:	6a 00                	push   $0x0
  802006:	6a 00                	push   $0x0
  802008:	6a 00                	push   $0x0
  80200a:	6a 0b                	push   $0xb
  80200c:	e8 ce fe ff ff       	call   801edf <syscall>
  802011:	83 c4 18             	add    $0x18,%esp
}
  802014:	c9                   	leave  
  802015:	c3                   	ret    

00802016 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802016:	55                   	push   %ebp
  802017:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802019:	6a 00                	push   $0x0
  80201b:	6a 00                	push   $0x0
  80201d:	6a 00                	push   $0x0
  80201f:	ff 75 0c             	pushl  0xc(%ebp)
  802022:	ff 75 08             	pushl  0x8(%ebp)
  802025:	6a 0f                	push   $0xf
  802027:	e8 b3 fe ff ff       	call   801edf <syscall>
  80202c:	83 c4 18             	add    $0x18,%esp
	return;
  80202f:	90                   	nop
}
  802030:	c9                   	leave  
  802031:	c3                   	ret    

00802032 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802032:	55                   	push   %ebp
  802033:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802035:	6a 00                	push   $0x0
  802037:	6a 00                	push   $0x0
  802039:	6a 00                	push   $0x0
  80203b:	ff 75 0c             	pushl  0xc(%ebp)
  80203e:	ff 75 08             	pushl  0x8(%ebp)
  802041:	6a 10                	push   $0x10
  802043:	e8 97 fe ff ff       	call   801edf <syscall>
  802048:	83 c4 18             	add    $0x18,%esp
	return ;
  80204b:	90                   	nop
}
  80204c:	c9                   	leave  
  80204d:	c3                   	ret    

0080204e <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80204e:	55                   	push   %ebp
  80204f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802051:	6a 00                	push   $0x0
  802053:	6a 00                	push   $0x0
  802055:	ff 75 10             	pushl  0x10(%ebp)
  802058:	ff 75 0c             	pushl  0xc(%ebp)
  80205b:	ff 75 08             	pushl  0x8(%ebp)
  80205e:	6a 11                	push   $0x11
  802060:	e8 7a fe ff ff       	call   801edf <syscall>
  802065:	83 c4 18             	add    $0x18,%esp
	return ;
  802068:	90                   	nop
}
  802069:	c9                   	leave  
  80206a:	c3                   	ret    

0080206b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80206b:	55                   	push   %ebp
  80206c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80206e:	6a 00                	push   $0x0
  802070:	6a 00                	push   $0x0
  802072:	6a 00                	push   $0x0
  802074:	6a 00                	push   $0x0
  802076:	6a 00                	push   $0x0
  802078:	6a 0c                	push   $0xc
  80207a:	e8 60 fe ff ff       	call   801edf <syscall>
  80207f:	83 c4 18             	add    $0x18,%esp
}
  802082:	c9                   	leave  
  802083:	c3                   	ret    

00802084 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802084:	55                   	push   %ebp
  802085:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802087:	6a 00                	push   $0x0
  802089:	6a 00                	push   $0x0
  80208b:	6a 00                	push   $0x0
  80208d:	6a 00                	push   $0x0
  80208f:	ff 75 08             	pushl  0x8(%ebp)
  802092:	6a 0d                	push   $0xd
  802094:	e8 46 fe ff ff       	call   801edf <syscall>
  802099:	83 c4 18             	add    $0x18,%esp
}
  80209c:	c9                   	leave  
  80209d:	c3                   	ret    

0080209e <sys_scarce_memory>:

void sys_scarce_memory()
{
  80209e:	55                   	push   %ebp
  80209f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8020a1:	6a 00                	push   $0x0
  8020a3:	6a 00                	push   $0x0
  8020a5:	6a 00                	push   $0x0
  8020a7:	6a 00                	push   $0x0
  8020a9:	6a 00                	push   $0x0
  8020ab:	6a 0e                	push   $0xe
  8020ad:	e8 2d fe ff ff       	call   801edf <syscall>
  8020b2:	83 c4 18             	add    $0x18,%esp
}
  8020b5:	90                   	nop
  8020b6:	c9                   	leave  
  8020b7:	c3                   	ret    

008020b8 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8020b8:	55                   	push   %ebp
  8020b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8020bb:	6a 00                	push   $0x0
  8020bd:	6a 00                	push   $0x0
  8020bf:	6a 00                	push   $0x0
  8020c1:	6a 00                	push   $0x0
  8020c3:	6a 00                	push   $0x0
  8020c5:	6a 13                	push   $0x13
  8020c7:	e8 13 fe ff ff       	call   801edf <syscall>
  8020cc:	83 c4 18             	add    $0x18,%esp
}
  8020cf:	90                   	nop
  8020d0:	c9                   	leave  
  8020d1:	c3                   	ret    

008020d2 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8020d2:	55                   	push   %ebp
  8020d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8020d5:	6a 00                	push   $0x0
  8020d7:	6a 00                	push   $0x0
  8020d9:	6a 00                	push   $0x0
  8020db:	6a 00                	push   $0x0
  8020dd:	6a 00                	push   $0x0
  8020df:	6a 14                	push   $0x14
  8020e1:	e8 f9 fd ff ff       	call   801edf <syscall>
  8020e6:	83 c4 18             	add    $0x18,%esp
}
  8020e9:	90                   	nop
  8020ea:	c9                   	leave  
  8020eb:	c3                   	ret    

008020ec <sys_cputc>:


void
sys_cputc(const char c)
{
  8020ec:	55                   	push   %ebp
  8020ed:	89 e5                	mov    %esp,%ebp
  8020ef:	83 ec 04             	sub    $0x4,%esp
  8020f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8020f8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020fc:	6a 00                	push   $0x0
  8020fe:	6a 00                	push   $0x0
  802100:	6a 00                	push   $0x0
  802102:	6a 00                	push   $0x0
  802104:	50                   	push   %eax
  802105:	6a 15                	push   $0x15
  802107:	e8 d3 fd ff ff       	call   801edf <syscall>
  80210c:	83 c4 18             	add    $0x18,%esp
}
  80210f:	90                   	nop
  802110:	c9                   	leave  
  802111:	c3                   	ret    

00802112 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802112:	55                   	push   %ebp
  802113:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802115:	6a 00                	push   $0x0
  802117:	6a 00                	push   $0x0
  802119:	6a 00                	push   $0x0
  80211b:	6a 00                	push   $0x0
  80211d:	6a 00                	push   $0x0
  80211f:	6a 16                	push   $0x16
  802121:	e8 b9 fd ff ff       	call   801edf <syscall>
  802126:	83 c4 18             	add    $0x18,%esp
}
  802129:	90                   	nop
  80212a:	c9                   	leave  
  80212b:	c3                   	ret    

0080212c <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80212c:	55                   	push   %ebp
  80212d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80212f:	8b 45 08             	mov    0x8(%ebp),%eax
  802132:	6a 00                	push   $0x0
  802134:	6a 00                	push   $0x0
  802136:	6a 00                	push   $0x0
  802138:	ff 75 0c             	pushl  0xc(%ebp)
  80213b:	50                   	push   %eax
  80213c:	6a 17                	push   $0x17
  80213e:	e8 9c fd ff ff       	call   801edf <syscall>
  802143:	83 c4 18             	add    $0x18,%esp
}
  802146:	c9                   	leave  
  802147:	c3                   	ret    

00802148 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802148:	55                   	push   %ebp
  802149:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80214b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80214e:	8b 45 08             	mov    0x8(%ebp),%eax
  802151:	6a 00                	push   $0x0
  802153:	6a 00                	push   $0x0
  802155:	6a 00                	push   $0x0
  802157:	52                   	push   %edx
  802158:	50                   	push   %eax
  802159:	6a 1a                	push   $0x1a
  80215b:	e8 7f fd ff ff       	call   801edf <syscall>
  802160:	83 c4 18             	add    $0x18,%esp
}
  802163:	c9                   	leave  
  802164:	c3                   	ret    

00802165 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802165:	55                   	push   %ebp
  802166:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802168:	8b 55 0c             	mov    0xc(%ebp),%edx
  80216b:	8b 45 08             	mov    0x8(%ebp),%eax
  80216e:	6a 00                	push   $0x0
  802170:	6a 00                	push   $0x0
  802172:	6a 00                	push   $0x0
  802174:	52                   	push   %edx
  802175:	50                   	push   %eax
  802176:	6a 18                	push   $0x18
  802178:	e8 62 fd ff ff       	call   801edf <syscall>
  80217d:	83 c4 18             	add    $0x18,%esp
}
  802180:	90                   	nop
  802181:	c9                   	leave  
  802182:	c3                   	ret    

00802183 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802183:	55                   	push   %ebp
  802184:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802186:	8b 55 0c             	mov    0xc(%ebp),%edx
  802189:	8b 45 08             	mov    0x8(%ebp),%eax
  80218c:	6a 00                	push   $0x0
  80218e:	6a 00                	push   $0x0
  802190:	6a 00                	push   $0x0
  802192:	52                   	push   %edx
  802193:	50                   	push   %eax
  802194:	6a 19                	push   $0x19
  802196:	e8 44 fd ff ff       	call   801edf <syscall>
  80219b:	83 c4 18             	add    $0x18,%esp
}
  80219e:	90                   	nop
  80219f:	c9                   	leave  
  8021a0:	c3                   	ret    

008021a1 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8021a1:	55                   	push   %ebp
  8021a2:	89 e5                	mov    %esp,%ebp
  8021a4:	83 ec 04             	sub    $0x4,%esp
  8021a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8021aa:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8021ad:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8021b0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8021b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b7:	6a 00                	push   $0x0
  8021b9:	51                   	push   %ecx
  8021ba:	52                   	push   %edx
  8021bb:	ff 75 0c             	pushl  0xc(%ebp)
  8021be:	50                   	push   %eax
  8021bf:	6a 1b                	push   $0x1b
  8021c1:	e8 19 fd ff ff       	call   801edf <syscall>
  8021c6:	83 c4 18             	add    $0x18,%esp
}
  8021c9:	c9                   	leave  
  8021ca:	c3                   	ret    

008021cb <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8021cb:	55                   	push   %ebp
  8021cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8021ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d4:	6a 00                	push   $0x0
  8021d6:	6a 00                	push   $0x0
  8021d8:	6a 00                	push   $0x0
  8021da:	52                   	push   %edx
  8021db:	50                   	push   %eax
  8021dc:	6a 1c                	push   $0x1c
  8021de:	e8 fc fc ff ff       	call   801edf <syscall>
  8021e3:	83 c4 18             	add    $0x18,%esp
}
  8021e6:	c9                   	leave  
  8021e7:	c3                   	ret    

008021e8 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8021e8:	55                   	push   %ebp
  8021e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8021eb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f4:	6a 00                	push   $0x0
  8021f6:	6a 00                	push   $0x0
  8021f8:	51                   	push   %ecx
  8021f9:	52                   	push   %edx
  8021fa:	50                   	push   %eax
  8021fb:	6a 1d                	push   $0x1d
  8021fd:	e8 dd fc ff ff       	call   801edf <syscall>
  802202:	83 c4 18             	add    $0x18,%esp
}
  802205:	c9                   	leave  
  802206:	c3                   	ret    

00802207 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802207:	55                   	push   %ebp
  802208:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80220a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80220d:	8b 45 08             	mov    0x8(%ebp),%eax
  802210:	6a 00                	push   $0x0
  802212:	6a 00                	push   $0x0
  802214:	6a 00                	push   $0x0
  802216:	52                   	push   %edx
  802217:	50                   	push   %eax
  802218:	6a 1e                	push   $0x1e
  80221a:	e8 c0 fc ff ff       	call   801edf <syscall>
  80221f:	83 c4 18             	add    $0x18,%esp
}
  802222:	c9                   	leave  
  802223:	c3                   	ret    

00802224 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802224:	55                   	push   %ebp
  802225:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802227:	6a 00                	push   $0x0
  802229:	6a 00                	push   $0x0
  80222b:	6a 00                	push   $0x0
  80222d:	6a 00                	push   $0x0
  80222f:	6a 00                	push   $0x0
  802231:	6a 1f                	push   $0x1f
  802233:	e8 a7 fc ff ff       	call   801edf <syscall>
  802238:	83 c4 18             	add    $0x18,%esp
}
  80223b:	c9                   	leave  
  80223c:	c3                   	ret    

0080223d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80223d:	55                   	push   %ebp
  80223e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802240:	8b 45 08             	mov    0x8(%ebp),%eax
  802243:	6a 00                	push   $0x0
  802245:	ff 75 14             	pushl  0x14(%ebp)
  802248:	ff 75 10             	pushl  0x10(%ebp)
  80224b:	ff 75 0c             	pushl  0xc(%ebp)
  80224e:	50                   	push   %eax
  80224f:	6a 20                	push   $0x20
  802251:	e8 89 fc ff ff       	call   801edf <syscall>
  802256:	83 c4 18             	add    $0x18,%esp
}
  802259:	c9                   	leave  
  80225a:	c3                   	ret    

0080225b <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80225b:	55                   	push   %ebp
  80225c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80225e:	8b 45 08             	mov    0x8(%ebp),%eax
  802261:	6a 00                	push   $0x0
  802263:	6a 00                	push   $0x0
  802265:	6a 00                	push   $0x0
  802267:	6a 00                	push   $0x0
  802269:	50                   	push   %eax
  80226a:	6a 21                	push   $0x21
  80226c:	e8 6e fc ff ff       	call   801edf <syscall>
  802271:	83 c4 18             	add    $0x18,%esp
}
  802274:	90                   	nop
  802275:	c9                   	leave  
  802276:	c3                   	ret    

00802277 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802277:	55                   	push   %ebp
  802278:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80227a:	8b 45 08             	mov    0x8(%ebp),%eax
  80227d:	6a 00                	push   $0x0
  80227f:	6a 00                	push   $0x0
  802281:	6a 00                	push   $0x0
  802283:	6a 00                	push   $0x0
  802285:	50                   	push   %eax
  802286:	6a 22                	push   $0x22
  802288:	e8 52 fc ff ff       	call   801edf <syscall>
  80228d:	83 c4 18             	add    $0x18,%esp
}
  802290:	c9                   	leave  
  802291:	c3                   	ret    

00802292 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802292:	55                   	push   %ebp
  802293:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802295:	6a 00                	push   $0x0
  802297:	6a 00                	push   $0x0
  802299:	6a 00                	push   $0x0
  80229b:	6a 00                	push   $0x0
  80229d:	6a 00                	push   $0x0
  80229f:	6a 02                	push   $0x2
  8022a1:	e8 39 fc ff ff       	call   801edf <syscall>
  8022a6:	83 c4 18             	add    $0x18,%esp
}
  8022a9:	c9                   	leave  
  8022aa:	c3                   	ret    

008022ab <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8022ab:	55                   	push   %ebp
  8022ac:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8022ae:	6a 00                	push   $0x0
  8022b0:	6a 00                	push   $0x0
  8022b2:	6a 00                	push   $0x0
  8022b4:	6a 00                	push   $0x0
  8022b6:	6a 00                	push   $0x0
  8022b8:	6a 03                	push   $0x3
  8022ba:	e8 20 fc ff ff       	call   801edf <syscall>
  8022bf:	83 c4 18             	add    $0x18,%esp
}
  8022c2:	c9                   	leave  
  8022c3:	c3                   	ret    

008022c4 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8022c4:	55                   	push   %ebp
  8022c5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8022c7:	6a 00                	push   $0x0
  8022c9:	6a 00                	push   $0x0
  8022cb:	6a 00                	push   $0x0
  8022cd:	6a 00                	push   $0x0
  8022cf:	6a 00                	push   $0x0
  8022d1:	6a 04                	push   $0x4
  8022d3:	e8 07 fc ff ff       	call   801edf <syscall>
  8022d8:	83 c4 18             	add    $0x18,%esp
}
  8022db:	c9                   	leave  
  8022dc:	c3                   	ret    

008022dd <sys_exit_env>:


void sys_exit_env(void)
{
  8022dd:	55                   	push   %ebp
  8022de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8022e0:	6a 00                	push   $0x0
  8022e2:	6a 00                	push   $0x0
  8022e4:	6a 00                	push   $0x0
  8022e6:	6a 00                	push   $0x0
  8022e8:	6a 00                	push   $0x0
  8022ea:	6a 23                	push   $0x23
  8022ec:	e8 ee fb ff ff       	call   801edf <syscall>
  8022f1:	83 c4 18             	add    $0x18,%esp
}
  8022f4:	90                   	nop
  8022f5:	c9                   	leave  
  8022f6:	c3                   	ret    

008022f7 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8022f7:	55                   	push   %ebp
  8022f8:	89 e5                	mov    %esp,%ebp
  8022fa:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8022fd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802300:	8d 50 04             	lea    0x4(%eax),%edx
  802303:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802306:	6a 00                	push   $0x0
  802308:	6a 00                	push   $0x0
  80230a:	6a 00                	push   $0x0
  80230c:	52                   	push   %edx
  80230d:	50                   	push   %eax
  80230e:	6a 24                	push   $0x24
  802310:	e8 ca fb ff ff       	call   801edf <syscall>
  802315:	83 c4 18             	add    $0x18,%esp
	return result;
  802318:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80231b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80231e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802321:	89 01                	mov    %eax,(%ecx)
  802323:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802326:	8b 45 08             	mov    0x8(%ebp),%eax
  802329:	c9                   	leave  
  80232a:	c2 04 00             	ret    $0x4

0080232d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80232d:	55                   	push   %ebp
  80232e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802330:	6a 00                	push   $0x0
  802332:	6a 00                	push   $0x0
  802334:	ff 75 10             	pushl  0x10(%ebp)
  802337:	ff 75 0c             	pushl  0xc(%ebp)
  80233a:	ff 75 08             	pushl  0x8(%ebp)
  80233d:	6a 12                	push   $0x12
  80233f:	e8 9b fb ff ff       	call   801edf <syscall>
  802344:	83 c4 18             	add    $0x18,%esp
	return ;
  802347:	90                   	nop
}
  802348:	c9                   	leave  
  802349:	c3                   	ret    

0080234a <sys_rcr2>:
uint32 sys_rcr2()
{
  80234a:	55                   	push   %ebp
  80234b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80234d:	6a 00                	push   $0x0
  80234f:	6a 00                	push   $0x0
  802351:	6a 00                	push   $0x0
  802353:	6a 00                	push   $0x0
  802355:	6a 00                	push   $0x0
  802357:	6a 25                	push   $0x25
  802359:	e8 81 fb ff ff       	call   801edf <syscall>
  80235e:	83 c4 18             	add    $0x18,%esp
}
  802361:	c9                   	leave  
  802362:	c3                   	ret    

00802363 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802363:	55                   	push   %ebp
  802364:	89 e5                	mov    %esp,%ebp
  802366:	83 ec 04             	sub    $0x4,%esp
  802369:	8b 45 08             	mov    0x8(%ebp),%eax
  80236c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80236f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802373:	6a 00                	push   $0x0
  802375:	6a 00                	push   $0x0
  802377:	6a 00                	push   $0x0
  802379:	6a 00                	push   $0x0
  80237b:	50                   	push   %eax
  80237c:	6a 26                	push   $0x26
  80237e:	e8 5c fb ff ff       	call   801edf <syscall>
  802383:	83 c4 18             	add    $0x18,%esp
	return ;
  802386:	90                   	nop
}
  802387:	c9                   	leave  
  802388:	c3                   	ret    

00802389 <rsttst>:
void rsttst()
{
  802389:	55                   	push   %ebp
  80238a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80238c:	6a 00                	push   $0x0
  80238e:	6a 00                	push   $0x0
  802390:	6a 00                	push   $0x0
  802392:	6a 00                	push   $0x0
  802394:	6a 00                	push   $0x0
  802396:	6a 28                	push   $0x28
  802398:	e8 42 fb ff ff       	call   801edf <syscall>
  80239d:	83 c4 18             	add    $0x18,%esp
	return ;
  8023a0:	90                   	nop
}
  8023a1:	c9                   	leave  
  8023a2:	c3                   	ret    

008023a3 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8023a3:	55                   	push   %ebp
  8023a4:	89 e5                	mov    %esp,%ebp
  8023a6:	83 ec 04             	sub    $0x4,%esp
  8023a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8023ac:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8023af:	8b 55 18             	mov    0x18(%ebp),%edx
  8023b2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8023b6:	52                   	push   %edx
  8023b7:	50                   	push   %eax
  8023b8:	ff 75 10             	pushl  0x10(%ebp)
  8023bb:	ff 75 0c             	pushl  0xc(%ebp)
  8023be:	ff 75 08             	pushl  0x8(%ebp)
  8023c1:	6a 27                	push   $0x27
  8023c3:	e8 17 fb ff ff       	call   801edf <syscall>
  8023c8:	83 c4 18             	add    $0x18,%esp
	return ;
  8023cb:	90                   	nop
}
  8023cc:	c9                   	leave  
  8023cd:	c3                   	ret    

008023ce <chktst>:
void chktst(uint32 n)
{
  8023ce:	55                   	push   %ebp
  8023cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8023d1:	6a 00                	push   $0x0
  8023d3:	6a 00                	push   $0x0
  8023d5:	6a 00                	push   $0x0
  8023d7:	6a 00                	push   $0x0
  8023d9:	ff 75 08             	pushl  0x8(%ebp)
  8023dc:	6a 29                	push   $0x29
  8023de:	e8 fc fa ff ff       	call   801edf <syscall>
  8023e3:	83 c4 18             	add    $0x18,%esp
	return ;
  8023e6:	90                   	nop
}
  8023e7:	c9                   	leave  
  8023e8:	c3                   	ret    

008023e9 <inctst>:

void inctst()
{
  8023e9:	55                   	push   %ebp
  8023ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8023ec:	6a 00                	push   $0x0
  8023ee:	6a 00                	push   $0x0
  8023f0:	6a 00                	push   $0x0
  8023f2:	6a 00                	push   $0x0
  8023f4:	6a 00                	push   $0x0
  8023f6:	6a 2a                	push   $0x2a
  8023f8:	e8 e2 fa ff ff       	call   801edf <syscall>
  8023fd:	83 c4 18             	add    $0x18,%esp
	return ;
  802400:	90                   	nop
}
  802401:	c9                   	leave  
  802402:	c3                   	ret    

00802403 <gettst>:
uint32 gettst()
{
  802403:	55                   	push   %ebp
  802404:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802406:	6a 00                	push   $0x0
  802408:	6a 00                	push   $0x0
  80240a:	6a 00                	push   $0x0
  80240c:	6a 00                	push   $0x0
  80240e:	6a 00                	push   $0x0
  802410:	6a 2b                	push   $0x2b
  802412:	e8 c8 fa ff ff       	call   801edf <syscall>
  802417:	83 c4 18             	add    $0x18,%esp
}
  80241a:	c9                   	leave  
  80241b:	c3                   	ret    

0080241c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80241c:	55                   	push   %ebp
  80241d:	89 e5                	mov    %esp,%ebp
  80241f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802422:	6a 00                	push   $0x0
  802424:	6a 00                	push   $0x0
  802426:	6a 00                	push   $0x0
  802428:	6a 00                	push   $0x0
  80242a:	6a 00                	push   $0x0
  80242c:	6a 2c                	push   $0x2c
  80242e:	e8 ac fa ff ff       	call   801edf <syscall>
  802433:	83 c4 18             	add    $0x18,%esp
  802436:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802439:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80243d:	75 07                	jne    802446 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80243f:	b8 01 00 00 00       	mov    $0x1,%eax
  802444:	eb 05                	jmp    80244b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802446:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80244b:	c9                   	leave  
  80244c:	c3                   	ret    

0080244d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80244d:	55                   	push   %ebp
  80244e:	89 e5                	mov    %esp,%ebp
  802450:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802453:	6a 00                	push   $0x0
  802455:	6a 00                	push   $0x0
  802457:	6a 00                	push   $0x0
  802459:	6a 00                	push   $0x0
  80245b:	6a 00                	push   $0x0
  80245d:	6a 2c                	push   $0x2c
  80245f:	e8 7b fa ff ff       	call   801edf <syscall>
  802464:	83 c4 18             	add    $0x18,%esp
  802467:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80246a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80246e:	75 07                	jne    802477 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802470:	b8 01 00 00 00       	mov    $0x1,%eax
  802475:	eb 05                	jmp    80247c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802477:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80247c:	c9                   	leave  
  80247d:	c3                   	ret    

0080247e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80247e:	55                   	push   %ebp
  80247f:	89 e5                	mov    %esp,%ebp
  802481:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802484:	6a 00                	push   $0x0
  802486:	6a 00                	push   $0x0
  802488:	6a 00                	push   $0x0
  80248a:	6a 00                	push   $0x0
  80248c:	6a 00                	push   $0x0
  80248e:	6a 2c                	push   $0x2c
  802490:	e8 4a fa ff ff       	call   801edf <syscall>
  802495:	83 c4 18             	add    $0x18,%esp
  802498:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80249b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80249f:	75 07                	jne    8024a8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8024a1:	b8 01 00 00 00       	mov    $0x1,%eax
  8024a6:	eb 05                	jmp    8024ad <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8024a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024ad:	c9                   	leave  
  8024ae:	c3                   	ret    

008024af <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8024af:	55                   	push   %ebp
  8024b0:	89 e5                	mov    %esp,%ebp
  8024b2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024b5:	6a 00                	push   $0x0
  8024b7:	6a 00                	push   $0x0
  8024b9:	6a 00                	push   $0x0
  8024bb:	6a 00                	push   $0x0
  8024bd:	6a 00                	push   $0x0
  8024bf:	6a 2c                	push   $0x2c
  8024c1:	e8 19 fa ff ff       	call   801edf <syscall>
  8024c6:	83 c4 18             	add    $0x18,%esp
  8024c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8024cc:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8024d0:	75 07                	jne    8024d9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8024d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8024d7:	eb 05                	jmp    8024de <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8024d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024de:	c9                   	leave  
  8024df:	c3                   	ret    

008024e0 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8024e0:	55                   	push   %ebp
  8024e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8024e3:	6a 00                	push   $0x0
  8024e5:	6a 00                	push   $0x0
  8024e7:	6a 00                	push   $0x0
  8024e9:	6a 00                	push   $0x0
  8024eb:	ff 75 08             	pushl  0x8(%ebp)
  8024ee:	6a 2d                	push   $0x2d
  8024f0:	e8 ea f9 ff ff       	call   801edf <syscall>
  8024f5:	83 c4 18             	add    $0x18,%esp
	return ;
  8024f8:	90                   	nop
}
  8024f9:	c9                   	leave  
  8024fa:	c3                   	ret    

008024fb <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8024fb:	55                   	push   %ebp
  8024fc:	89 e5                	mov    %esp,%ebp
  8024fe:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8024ff:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802502:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802505:	8b 55 0c             	mov    0xc(%ebp),%edx
  802508:	8b 45 08             	mov    0x8(%ebp),%eax
  80250b:	6a 00                	push   $0x0
  80250d:	53                   	push   %ebx
  80250e:	51                   	push   %ecx
  80250f:	52                   	push   %edx
  802510:	50                   	push   %eax
  802511:	6a 2e                	push   $0x2e
  802513:	e8 c7 f9 ff ff       	call   801edf <syscall>
  802518:	83 c4 18             	add    $0x18,%esp
}
  80251b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80251e:	c9                   	leave  
  80251f:	c3                   	ret    

00802520 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802520:	55                   	push   %ebp
  802521:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802523:	8b 55 0c             	mov    0xc(%ebp),%edx
  802526:	8b 45 08             	mov    0x8(%ebp),%eax
  802529:	6a 00                	push   $0x0
  80252b:	6a 00                	push   $0x0
  80252d:	6a 00                	push   $0x0
  80252f:	52                   	push   %edx
  802530:	50                   	push   %eax
  802531:	6a 2f                	push   $0x2f
  802533:	e8 a7 f9 ff ff       	call   801edf <syscall>
  802538:	83 c4 18             	add    $0x18,%esp
}
  80253b:	c9                   	leave  
  80253c:	c3                   	ret    

0080253d <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80253d:	55                   	push   %ebp
  80253e:	89 e5                	mov    %esp,%ebp
  802540:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802543:	83 ec 0c             	sub    $0xc,%esp
  802546:	68 c4 46 80 00       	push   $0x8046c4
  80254b:	e8 65 e6 ff ff       	call   800bb5 <cprintf>
  802550:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802553:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80255a:	83 ec 0c             	sub    $0xc,%esp
  80255d:	68 f0 46 80 00       	push   $0x8046f0
  802562:	e8 4e e6 ff ff       	call   800bb5 <cprintf>
  802567:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80256a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80256e:	a1 38 51 80 00       	mov    0x805138,%eax
  802573:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802576:	eb 56                	jmp    8025ce <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802578:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80257c:	74 1c                	je     80259a <print_mem_block_lists+0x5d>
  80257e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802581:	8b 50 08             	mov    0x8(%eax),%edx
  802584:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802587:	8b 48 08             	mov    0x8(%eax),%ecx
  80258a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80258d:	8b 40 0c             	mov    0xc(%eax),%eax
  802590:	01 c8                	add    %ecx,%eax
  802592:	39 c2                	cmp    %eax,%edx
  802594:	73 04                	jae    80259a <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802596:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80259a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259d:	8b 50 08             	mov    0x8(%eax),%edx
  8025a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8025a6:	01 c2                	add    %eax,%edx
  8025a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ab:	8b 40 08             	mov    0x8(%eax),%eax
  8025ae:	83 ec 04             	sub    $0x4,%esp
  8025b1:	52                   	push   %edx
  8025b2:	50                   	push   %eax
  8025b3:	68 05 47 80 00       	push   $0x804705
  8025b8:	e8 f8 e5 ff ff       	call   800bb5 <cprintf>
  8025bd:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8025c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8025c6:	a1 40 51 80 00       	mov    0x805140,%eax
  8025cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025d2:	74 07                	je     8025db <print_mem_block_lists+0x9e>
  8025d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d7:	8b 00                	mov    (%eax),%eax
  8025d9:	eb 05                	jmp    8025e0 <print_mem_block_lists+0xa3>
  8025db:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e0:	a3 40 51 80 00       	mov    %eax,0x805140
  8025e5:	a1 40 51 80 00       	mov    0x805140,%eax
  8025ea:	85 c0                	test   %eax,%eax
  8025ec:	75 8a                	jne    802578 <print_mem_block_lists+0x3b>
  8025ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025f2:	75 84                	jne    802578 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8025f4:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8025f8:	75 10                	jne    80260a <print_mem_block_lists+0xcd>
  8025fa:	83 ec 0c             	sub    $0xc,%esp
  8025fd:	68 14 47 80 00       	push   $0x804714
  802602:	e8 ae e5 ff ff       	call   800bb5 <cprintf>
  802607:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80260a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802611:	83 ec 0c             	sub    $0xc,%esp
  802614:	68 38 47 80 00       	push   $0x804738
  802619:	e8 97 e5 ff ff       	call   800bb5 <cprintf>
  80261e:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802621:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802625:	a1 40 50 80 00       	mov    0x805040,%eax
  80262a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80262d:	eb 56                	jmp    802685 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80262f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802633:	74 1c                	je     802651 <print_mem_block_lists+0x114>
  802635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802638:	8b 50 08             	mov    0x8(%eax),%edx
  80263b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80263e:	8b 48 08             	mov    0x8(%eax),%ecx
  802641:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802644:	8b 40 0c             	mov    0xc(%eax),%eax
  802647:	01 c8                	add    %ecx,%eax
  802649:	39 c2                	cmp    %eax,%edx
  80264b:	73 04                	jae    802651 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80264d:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802651:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802654:	8b 50 08             	mov    0x8(%eax),%edx
  802657:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265a:	8b 40 0c             	mov    0xc(%eax),%eax
  80265d:	01 c2                	add    %eax,%edx
  80265f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802662:	8b 40 08             	mov    0x8(%eax),%eax
  802665:	83 ec 04             	sub    $0x4,%esp
  802668:	52                   	push   %edx
  802669:	50                   	push   %eax
  80266a:	68 05 47 80 00       	push   $0x804705
  80266f:	e8 41 e5 ff ff       	call   800bb5 <cprintf>
  802674:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802677:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80267d:	a1 48 50 80 00       	mov    0x805048,%eax
  802682:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802685:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802689:	74 07                	je     802692 <print_mem_block_lists+0x155>
  80268b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268e:	8b 00                	mov    (%eax),%eax
  802690:	eb 05                	jmp    802697 <print_mem_block_lists+0x15a>
  802692:	b8 00 00 00 00       	mov    $0x0,%eax
  802697:	a3 48 50 80 00       	mov    %eax,0x805048
  80269c:	a1 48 50 80 00       	mov    0x805048,%eax
  8026a1:	85 c0                	test   %eax,%eax
  8026a3:	75 8a                	jne    80262f <print_mem_block_lists+0xf2>
  8026a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026a9:	75 84                	jne    80262f <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8026ab:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8026af:	75 10                	jne    8026c1 <print_mem_block_lists+0x184>
  8026b1:	83 ec 0c             	sub    $0xc,%esp
  8026b4:	68 50 47 80 00       	push   $0x804750
  8026b9:	e8 f7 e4 ff ff       	call   800bb5 <cprintf>
  8026be:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8026c1:	83 ec 0c             	sub    $0xc,%esp
  8026c4:	68 c4 46 80 00       	push   $0x8046c4
  8026c9:	e8 e7 e4 ff ff       	call   800bb5 <cprintf>
  8026ce:	83 c4 10             	add    $0x10,%esp

}
  8026d1:	90                   	nop
  8026d2:	c9                   	leave  
  8026d3:	c3                   	ret    

008026d4 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8026d4:	55                   	push   %ebp
  8026d5:	89 e5                	mov    %esp,%ebp
  8026d7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8026da:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8026e1:	00 00 00 
  8026e4:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8026eb:	00 00 00 
  8026ee:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8026f5:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8026f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8026ff:	e9 9e 00 00 00       	jmp    8027a2 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802704:	a1 50 50 80 00       	mov    0x805050,%eax
  802709:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80270c:	c1 e2 04             	shl    $0x4,%edx
  80270f:	01 d0                	add    %edx,%eax
  802711:	85 c0                	test   %eax,%eax
  802713:	75 14                	jne    802729 <initialize_MemBlocksList+0x55>
  802715:	83 ec 04             	sub    $0x4,%esp
  802718:	68 78 47 80 00       	push   $0x804778
  80271d:	6a 46                	push   $0x46
  80271f:	68 9b 47 80 00       	push   $0x80479b
  802724:	e8 d8 e1 ff ff       	call   800901 <_panic>
  802729:	a1 50 50 80 00       	mov    0x805050,%eax
  80272e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802731:	c1 e2 04             	shl    $0x4,%edx
  802734:	01 d0                	add    %edx,%eax
  802736:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80273c:	89 10                	mov    %edx,(%eax)
  80273e:	8b 00                	mov    (%eax),%eax
  802740:	85 c0                	test   %eax,%eax
  802742:	74 18                	je     80275c <initialize_MemBlocksList+0x88>
  802744:	a1 48 51 80 00       	mov    0x805148,%eax
  802749:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80274f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802752:	c1 e1 04             	shl    $0x4,%ecx
  802755:	01 ca                	add    %ecx,%edx
  802757:	89 50 04             	mov    %edx,0x4(%eax)
  80275a:	eb 12                	jmp    80276e <initialize_MemBlocksList+0x9a>
  80275c:	a1 50 50 80 00       	mov    0x805050,%eax
  802761:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802764:	c1 e2 04             	shl    $0x4,%edx
  802767:	01 d0                	add    %edx,%eax
  802769:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80276e:	a1 50 50 80 00       	mov    0x805050,%eax
  802773:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802776:	c1 e2 04             	shl    $0x4,%edx
  802779:	01 d0                	add    %edx,%eax
  80277b:	a3 48 51 80 00       	mov    %eax,0x805148
  802780:	a1 50 50 80 00       	mov    0x805050,%eax
  802785:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802788:	c1 e2 04             	shl    $0x4,%edx
  80278b:	01 d0                	add    %edx,%eax
  80278d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802794:	a1 54 51 80 00       	mov    0x805154,%eax
  802799:	40                   	inc    %eax
  80279a:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  80279f:	ff 45 f4             	incl   -0xc(%ebp)
  8027a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027a8:	0f 82 56 ff ff ff    	jb     802704 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8027ae:	90                   	nop
  8027af:	c9                   	leave  
  8027b0:	c3                   	ret    

008027b1 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8027b1:	55                   	push   %ebp
  8027b2:	89 e5                	mov    %esp,%ebp
  8027b4:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8027b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ba:	8b 00                	mov    (%eax),%eax
  8027bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8027bf:	eb 19                	jmp    8027da <find_block+0x29>
	{
		if(va==point->sva)
  8027c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027c4:	8b 40 08             	mov    0x8(%eax),%eax
  8027c7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8027ca:	75 05                	jne    8027d1 <find_block+0x20>
		   return point;
  8027cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027cf:	eb 36                	jmp    802807 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8027d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d4:	8b 40 08             	mov    0x8(%eax),%eax
  8027d7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8027da:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8027de:	74 07                	je     8027e7 <find_block+0x36>
  8027e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027e3:	8b 00                	mov    (%eax),%eax
  8027e5:	eb 05                	jmp    8027ec <find_block+0x3b>
  8027e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8027ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8027ef:	89 42 08             	mov    %eax,0x8(%edx)
  8027f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f5:	8b 40 08             	mov    0x8(%eax),%eax
  8027f8:	85 c0                	test   %eax,%eax
  8027fa:	75 c5                	jne    8027c1 <find_block+0x10>
  8027fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802800:	75 bf                	jne    8027c1 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802802:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802807:	c9                   	leave  
  802808:	c3                   	ret    

00802809 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802809:	55                   	push   %ebp
  80280a:	89 e5                	mov    %esp,%ebp
  80280c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80280f:	a1 40 50 80 00       	mov    0x805040,%eax
  802814:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802817:	a1 44 50 80 00       	mov    0x805044,%eax
  80281c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80281f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802822:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802825:	74 24                	je     80284b <insert_sorted_allocList+0x42>
  802827:	8b 45 08             	mov    0x8(%ebp),%eax
  80282a:	8b 50 08             	mov    0x8(%eax),%edx
  80282d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802830:	8b 40 08             	mov    0x8(%eax),%eax
  802833:	39 c2                	cmp    %eax,%edx
  802835:	76 14                	jbe    80284b <insert_sorted_allocList+0x42>
  802837:	8b 45 08             	mov    0x8(%ebp),%eax
  80283a:	8b 50 08             	mov    0x8(%eax),%edx
  80283d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802840:	8b 40 08             	mov    0x8(%eax),%eax
  802843:	39 c2                	cmp    %eax,%edx
  802845:	0f 82 60 01 00 00    	jb     8029ab <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  80284b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80284f:	75 65                	jne    8028b6 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802851:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802855:	75 14                	jne    80286b <insert_sorted_allocList+0x62>
  802857:	83 ec 04             	sub    $0x4,%esp
  80285a:	68 78 47 80 00       	push   $0x804778
  80285f:	6a 6b                	push   $0x6b
  802861:	68 9b 47 80 00       	push   $0x80479b
  802866:	e8 96 e0 ff ff       	call   800901 <_panic>
  80286b:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802871:	8b 45 08             	mov    0x8(%ebp),%eax
  802874:	89 10                	mov    %edx,(%eax)
  802876:	8b 45 08             	mov    0x8(%ebp),%eax
  802879:	8b 00                	mov    (%eax),%eax
  80287b:	85 c0                	test   %eax,%eax
  80287d:	74 0d                	je     80288c <insert_sorted_allocList+0x83>
  80287f:	a1 40 50 80 00       	mov    0x805040,%eax
  802884:	8b 55 08             	mov    0x8(%ebp),%edx
  802887:	89 50 04             	mov    %edx,0x4(%eax)
  80288a:	eb 08                	jmp    802894 <insert_sorted_allocList+0x8b>
  80288c:	8b 45 08             	mov    0x8(%ebp),%eax
  80288f:	a3 44 50 80 00       	mov    %eax,0x805044
  802894:	8b 45 08             	mov    0x8(%ebp),%eax
  802897:	a3 40 50 80 00       	mov    %eax,0x805040
  80289c:	8b 45 08             	mov    0x8(%ebp),%eax
  80289f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028a6:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8028ab:	40                   	inc    %eax
  8028ac:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8028b1:	e9 dc 01 00 00       	jmp    802a92 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8028b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b9:	8b 50 08             	mov    0x8(%eax),%edx
  8028bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028bf:	8b 40 08             	mov    0x8(%eax),%eax
  8028c2:	39 c2                	cmp    %eax,%edx
  8028c4:	77 6c                	ja     802932 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8028c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028ca:	74 06                	je     8028d2 <insert_sorted_allocList+0xc9>
  8028cc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028d0:	75 14                	jne    8028e6 <insert_sorted_allocList+0xdd>
  8028d2:	83 ec 04             	sub    $0x4,%esp
  8028d5:	68 b4 47 80 00       	push   $0x8047b4
  8028da:	6a 6f                	push   $0x6f
  8028dc:	68 9b 47 80 00       	push   $0x80479b
  8028e1:	e8 1b e0 ff ff       	call   800901 <_panic>
  8028e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e9:	8b 50 04             	mov    0x4(%eax),%edx
  8028ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ef:	89 50 04             	mov    %edx,0x4(%eax)
  8028f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028f8:	89 10                	mov    %edx,(%eax)
  8028fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028fd:	8b 40 04             	mov    0x4(%eax),%eax
  802900:	85 c0                	test   %eax,%eax
  802902:	74 0d                	je     802911 <insert_sorted_allocList+0x108>
  802904:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802907:	8b 40 04             	mov    0x4(%eax),%eax
  80290a:	8b 55 08             	mov    0x8(%ebp),%edx
  80290d:	89 10                	mov    %edx,(%eax)
  80290f:	eb 08                	jmp    802919 <insert_sorted_allocList+0x110>
  802911:	8b 45 08             	mov    0x8(%ebp),%eax
  802914:	a3 40 50 80 00       	mov    %eax,0x805040
  802919:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80291c:	8b 55 08             	mov    0x8(%ebp),%edx
  80291f:	89 50 04             	mov    %edx,0x4(%eax)
  802922:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802927:	40                   	inc    %eax
  802928:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80292d:	e9 60 01 00 00       	jmp    802a92 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802932:	8b 45 08             	mov    0x8(%ebp),%eax
  802935:	8b 50 08             	mov    0x8(%eax),%edx
  802938:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80293b:	8b 40 08             	mov    0x8(%eax),%eax
  80293e:	39 c2                	cmp    %eax,%edx
  802940:	0f 82 4c 01 00 00    	jb     802a92 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802946:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80294a:	75 14                	jne    802960 <insert_sorted_allocList+0x157>
  80294c:	83 ec 04             	sub    $0x4,%esp
  80294f:	68 ec 47 80 00       	push   $0x8047ec
  802954:	6a 73                	push   $0x73
  802956:	68 9b 47 80 00       	push   $0x80479b
  80295b:	e8 a1 df ff ff       	call   800901 <_panic>
  802960:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802966:	8b 45 08             	mov    0x8(%ebp),%eax
  802969:	89 50 04             	mov    %edx,0x4(%eax)
  80296c:	8b 45 08             	mov    0x8(%ebp),%eax
  80296f:	8b 40 04             	mov    0x4(%eax),%eax
  802972:	85 c0                	test   %eax,%eax
  802974:	74 0c                	je     802982 <insert_sorted_allocList+0x179>
  802976:	a1 44 50 80 00       	mov    0x805044,%eax
  80297b:	8b 55 08             	mov    0x8(%ebp),%edx
  80297e:	89 10                	mov    %edx,(%eax)
  802980:	eb 08                	jmp    80298a <insert_sorted_allocList+0x181>
  802982:	8b 45 08             	mov    0x8(%ebp),%eax
  802985:	a3 40 50 80 00       	mov    %eax,0x805040
  80298a:	8b 45 08             	mov    0x8(%ebp),%eax
  80298d:	a3 44 50 80 00       	mov    %eax,0x805044
  802992:	8b 45 08             	mov    0x8(%ebp),%eax
  802995:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80299b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029a0:	40                   	inc    %eax
  8029a1:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8029a6:	e9 e7 00 00 00       	jmp    802a92 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8029ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8029b1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8029b8:	a1 40 50 80 00       	mov    0x805040,%eax
  8029bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029c0:	e9 9d 00 00 00       	jmp    802a62 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8029c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c8:	8b 00                	mov    (%eax),%eax
  8029ca:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8029cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d0:	8b 50 08             	mov    0x8(%eax),%edx
  8029d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d6:	8b 40 08             	mov    0x8(%eax),%eax
  8029d9:	39 c2                	cmp    %eax,%edx
  8029db:	76 7d                	jbe    802a5a <insert_sorted_allocList+0x251>
  8029dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e0:	8b 50 08             	mov    0x8(%eax),%edx
  8029e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029e6:	8b 40 08             	mov    0x8(%eax),%eax
  8029e9:	39 c2                	cmp    %eax,%edx
  8029eb:	73 6d                	jae    802a5a <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8029ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029f1:	74 06                	je     8029f9 <insert_sorted_allocList+0x1f0>
  8029f3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029f7:	75 14                	jne    802a0d <insert_sorted_allocList+0x204>
  8029f9:	83 ec 04             	sub    $0x4,%esp
  8029fc:	68 10 48 80 00       	push   $0x804810
  802a01:	6a 7f                	push   $0x7f
  802a03:	68 9b 47 80 00       	push   $0x80479b
  802a08:	e8 f4 de ff ff       	call   800901 <_panic>
  802a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a10:	8b 10                	mov    (%eax),%edx
  802a12:	8b 45 08             	mov    0x8(%ebp),%eax
  802a15:	89 10                	mov    %edx,(%eax)
  802a17:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1a:	8b 00                	mov    (%eax),%eax
  802a1c:	85 c0                	test   %eax,%eax
  802a1e:	74 0b                	je     802a2b <insert_sorted_allocList+0x222>
  802a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a23:	8b 00                	mov    (%eax),%eax
  802a25:	8b 55 08             	mov    0x8(%ebp),%edx
  802a28:	89 50 04             	mov    %edx,0x4(%eax)
  802a2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2e:	8b 55 08             	mov    0x8(%ebp),%edx
  802a31:	89 10                	mov    %edx,(%eax)
  802a33:	8b 45 08             	mov    0x8(%ebp),%eax
  802a36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a39:	89 50 04             	mov    %edx,0x4(%eax)
  802a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3f:	8b 00                	mov    (%eax),%eax
  802a41:	85 c0                	test   %eax,%eax
  802a43:	75 08                	jne    802a4d <insert_sorted_allocList+0x244>
  802a45:	8b 45 08             	mov    0x8(%ebp),%eax
  802a48:	a3 44 50 80 00       	mov    %eax,0x805044
  802a4d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a52:	40                   	inc    %eax
  802a53:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802a58:	eb 39                	jmp    802a93 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802a5a:	a1 48 50 80 00       	mov    0x805048,%eax
  802a5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a62:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a66:	74 07                	je     802a6f <insert_sorted_allocList+0x266>
  802a68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6b:	8b 00                	mov    (%eax),%eax
  802a6d:	eb 05                	jmp    802a74 <insert_sorted_allocList+0x26b>
  802a6f:	b8 00 00 00 00       	mov    $0x0,%eax
  802a74:	a3 48 50 80 00       	mov    %eax,0x805048
  802a79:	a1 48 50 80 00       	mov    0x805048,%eax
  802a7e:	85 c0                	test   %eax,%eax
  802a80:	0f 85 3f ff ff ff    	jne    8029c5 <insert_sorted_allocList+0x1bc>
  802a86:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a8a:	0f 85 35 ff ff ff    	jne    8029c5 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802a90:	eb 01                	jmp    802a93 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802a92:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802a93:	90                   	nop
  802a94:	c9                   	leave  
  802a95:	c3                   	ret    

00802a96 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802a96:	55                   	push   %ebp
  802a97:	89 e5                	mov    %esp,%ebp
  802a99:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802a9c:	a1 38 51 80 00       	mov    0x805138,%eax
  802aa1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aa4:	e9 85 01 00 00       	jmp    802c2e <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802aa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aac:	8b 40 0c             	mov    0xc(%eax),%eax
  802aaf:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ab2:	0f 82 6e 01 00 00    	jb     802c26 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802ab8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abb:	8b 40 0c             	mov    0xc(%eax),%eax
  802abe:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ac1:	0f 85 8a 00 00 00    	jne    802b51 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802ac7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802acb:	75 17                	jne    802ae4 <alloc_block_FF+0x4e>
  802acd:	83 ec 04             	sub    $0x4,%esp
  802ad0:	68 44 48 80 00       	push   $0x804844
  802ad5:	68 93 00 00 00       	push   $0x93
  802ada:	68 9b 47 80 00       	push   $0x80479b
  802adf:	e8 1d de ff ff       	call   800901 <_panic>
  802ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae7:	8b 00                	mov    (%eax),%eax
  802ae9:	85 c0                	test   %eax,%eax
  802aeb:	74 10                	je     802afd <alloc_block_FF+0x67>
  802aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af0:	8b 00                	mov    (%eax),%eax
  802af2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802af5:	8b 52 04             	mov    0x4(%edx),%edx
  802af8:	89 50 04             	mov    %edx,0x4(%eax)
  802afb:	eb 0b                	jmp    802b08 <alloc_block_FF+0x72>
  802afd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b00:	8b 40 04             	mov    0x4(%eax),%eax
  802b03:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0b:	8b 40 04             	mov    0x4(%eax),%eax
  802b0e:	85 c0                	test   %eax,%eax
  802b10:	74 0f                	je     802b21 <alloc_block_FF+0x8b>
  802b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b15:	8b 40 04             	mov    0x4(%eax),%eax
  802b18:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b1b:	8b 12                	mov    (%edx),%edx
  802b1d:	89 10                	mov    %edx,(%eax)
  802b1f:	eb 0a                	jmp    802b2b <alloc_block_FF+0x95>
  802b21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b24:	8b 00                	mov    (%eax),%eax
  802b26:	a3 38 51 80 00       	mov    %eax,0x805138
  802b2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b37:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b3e:	a1 44 51 80 00       	mov    0x805144,%eax
  802b43:	48                   	dec    %eax
  802b44:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4c:	e9 10 01 00 00       	jmp    802c61 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802b51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b54:	8b 40 0c             	mov    0xc(%eax),%eax
  802b57:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b5a:	0f 86 c6 00 00 00    	jbe    802c26 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b60:	a1 48 51 80 00       	mov    0x805148,%eax
  802b65:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6b:	8b 50 08             	mov    0x8(%eax),%edx
  802b6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b71:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802b74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b77:	8b 55 08             	mov    0x8(%ebp),%edx
  802b7a:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b7d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b81:	75 17                	jne    802b9a <alloc_block_FF+0x104>
  802b83:	83 ec 04             	sub    $0x4,%esp
  802b86:	68 44 48 80 00       	push   $0x804844
  802b8b:	68 9b 00 00 00       	push   $0x9b
  802b90:	68 9b 47 80 00       	push   $0x80479b
  802b95:	e8 67 dd ff ff       	call   800901 <_panic>
  802b9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b9d:	8b 00                	mov    (%eax),%eax
  802b9f:	85 c0                	test   %eax,%eax
  802ba1:	74 10                	je     802bb3 <alloc_block_FF+0x11d>
  802ba3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba6:	8b 00                	mov    (%eax),%eax
  802ba8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bab:	8b 52 04             	mov    0x4(%edx),%edx
  802bae:	89 50 04             	mov    %edx,0x4(%eax)
  802bb1:	eb 0b                	jmp    802bbe <alloc_block_FF+0x128>
  802bb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb6:	8b 40 04             	mov    0x4(%eax),%eax
  802bb9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802bbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc1:	8b 40 04             	mov    0x4(%eax),%eax
  802bc4:	85 c0                	test   %eax,%eax
  802bc6:	74 0f                	je     802bd7 <alloc_block_FF+0x141>
  802bc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bcb:	8b 40 04             	mov    0x4(%eax),%eax
  802bce:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bd1:	8b 12                	mov    (%edx),%edx
  802bd3:	89 10                	mov    %edx,(%eax)
  802bd5:	eb 0a                	jmp    802be1 <alloc_block_FF+0x14b>
  802bd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bda:	8b 00                	mov    (%eax),%eax
  802bdc:	a3 48 51 80 00       	mov    %eax,0x805148
  802be1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bf4:	a1 54 51 80 00       	mov    0x805154,%eax
  802bf9:	48                   	dec    %eax
  802bfa:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802bff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c02:	8b 50 08             	mov    0x8(%eax),%edx
  802c05:	8b 45 08             	mov    0x8(%ebp),%eax
  802c08:	01 c2                	add    %eax,%edx
  802c0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0d:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802c10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c13:	8b 40 0c             	mov    0xc(%eax),%eax
  802c16:	2b 45 08             	sub    0x8(%ebp),%eax
  802c19:	89 c2                	mov    %eax,%edx
  802c1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1e:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802c21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c24:	eb 3b                	jmp    802c61 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802c26:	a1 40 51 80 00       	mov    0x805140,%eax
  802c2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c32:	74 07                	je     802c3b <alloc_block_FF+0x1a5>
  802c34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c37:	8b 00                	mov    (%eax),%eax
  802c39:	eb 05                	jmp    802c40 <alloc_block_FF+0x1aa>
  802c3b:	b8 00 00 00 00       	mov    $0x0,%eax
  802c40:	a3 40 51 80 00       	mov    %eax,0x805140
  802c45:	a1 40 51 80 00       	mov    0x805140,%eax
  802c4a:	85 c0                	test   %eax,%eax
  802c4c:	0f 85 57 fe ff ff    	jne    802aa9 <alloc_block_FF+0x13>
  802c52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c56:	0f 85 4d fe ff ff    	jne    802aa9 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802c5c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c61:	c9                   	leave  
  802c62:	c3                   	ret    

00802c63 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802c63:	55                   	push   %ebp
  802c64:	89 e5                	mov    %esp,%ebp
  802c66:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802c69:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802c70:	a1 38 51 80 00       	mov    0x805138,%eax
  802c75:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c78:	e9 df 00 00 00       	jmp    802d5c <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802c7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c80:	8b 40 0c             	mov    0xc(%eax),%eax
  802c83:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c86:	0f 82 c8 00 00 00    	jb     802d54 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802c8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8f:	8b 40 0c             	mov    0xc(%eax),%eax
  802c92:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c95:	0f 85 8a 00 00 00    	jne    802d25 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802c9b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c9f:	75 17                	jne    802cb8 <alloc_block_BF+0x55>
  802ca1:	83 ec 04             	sub    $0x4,%esp
  802ca4:	68 44 48 80 00       	push   $0x804844
  802ca9:	68 b7 00 00 00       	push   $0xb7
  802cae:	68 9b 47 80 00       	push   $0x80479b
  802cb3:	e8 49 dc ff ff       	call   800901 <_panic>
  802cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbb:	8b 00                	mov    (%eax),%eax
  802cbd:	85 c0                	test   %eax,%eax
  802cbf:	74 10                	je     802cd1 <alloc_block_BF+0x6e>
  802cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc4:	8b 00                	mov    (%eax),%eax
  802cc6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cc9:	8b 52 04             	mov    0x4(%edx),%edx
  802ccc:	89 50 04             	mov    %edx,0x4(%eax)
  802ccf:	eb 0b                	jmp    802cdc <alloc_block_BF+0x79>
  802cd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd4:	8b 40 04             	mov    0x4(%eax),%eax
  802cd7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdf:	8b 40 04             	mov    0x4(%eax),%eax
  802ce2:	85 c0                	test   %eax,%eax
  802ce4:	74 0f                	je     802cf5 <alloc_block_BF+0x92>
  802ce6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce9:	8b 40 04             	mov    0x4(%eax),%eax
  802cec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cef:	8b 12                	mov    (%edx),%edx
  802cf1:	89 10                	mov    %edx,(%eax)
  802cf3:	eb 0a                	jmp    802cff <alloc_block_BF+0x9c>
  802cf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf8:	8b 00                	mov    (%eax),%eax
  802cfa:	a3 38 51 80 00       	mov    %eax,0x805138
  802cff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d02:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d12:	a1 44 51 80 00       	mov    0x805144,%eax
  802d17:	48                   	dec    %eax
  802d18:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802d1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d20:	e9 4d 01 00 00       	jmp    802e72 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802d25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d28:	8b 40 0c             	mov    0xc(%eax),%eax
  802d2b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d2e:	76 24                	jbe    802d54 <alloc_block_BF+0xf1>
  802d30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d33:	8b 40 0c             	mov    0xc(%eax),%eax
  802d36:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802d39:	73 19                	jae    802d54 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802d3b:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802d42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d45:	8b 40 0c             	mov    0xc(%eax),%eax
  802d48:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802d4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4e:	8b 40 08             	mov    0x8(%eax),%eax
  802d51:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802d54:	a1 40 51 80 00       	mov    0x805140,%eax
  802d59:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d5c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d60:	74 07                	je     802d69 <alloc_block_BF+0x106>
  802d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d65:	8b 00                	mov    (%eax),%eax
  802d67:	eb 05                	jmp    802d6e <alloc_block_BF+0x10b>
  802d69:	b8 00 00 00 00       	mov    $0x0,%eax
  802d6e:	a3 40 51 80 00       	mov    %eax,0x805140
  802d73:	a1 40 51 80 00       	mov    0x805140,%eax
  802d78:	85 c0                	test   %eax,%eax
  802d7a:	0f 85 fd fe ff ff    	jne    802c7d <alloc_block_BF+0x1a>
  802d80:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d84:	0f 85 f3 fe ff ff    	jne    802c7d <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802d8a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d8e:	0f 84 d9 00 00 00    	je     802e6d <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d94:	a1 48 51 80 00       	mov    0x805148,%eax
  802d99:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802d9c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d9f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802da2:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802da5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802da8:	8b 55 08             	mov    0x8(%ebp),%edx
  802dab:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802dae:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802db2:	75 17                	jne    802dcb <alloc_block_BF+0x168>
  802db4:	83 ec 04             	sub    $0x4,%esp
  802db7:	68 44 48 80 00       	push   $0x804844
  802dbc:	68 c7 00 00 00       	push   $0xc7
  802dc1:	68 9b 47 80 00       	push   $0x80479b
  802dc6:	e8 36 db ff ff       	call   800901 <_panic>
  802dcb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dce:	8b 00                	mov    (%eax),%eax
  802dd0:	85 c0                	test   %eax,%eax
  802dd2:	74 10                	je     802de4 <alloc_block_BF+0x181>
  802dd4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dd7:	8b 00                	mov    (%eax),%eax
  802dd9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ddc:	8b 52 04             	mov    0x4(%edx),%edx
  802ddf:	89 50 04             	mov    %edx,0x4(%eax)
  802de2:	eb 0b                	jmp    802def <alloc_block_BF+0x18c>
  802de4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802de7:	8b 40 04             	mov    0x4(%eax),%eax
  802dea:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802def:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802df2:	8b 40 04             	mov    0x4(%eax),%eax
  802df5:	85 c0                	test   %eax,%eax
  802df7:	74 0f                	je     802e08 <alloc_block_BF+0x1a5>
  802df9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dfc:	8b 40 04             	mov    0x4(%eax),%eax
  802dff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e02:	8b 12                	mov    (%edx),%edx
  802e04:	89 10                	mov    %edx,(%eax)
  802e06:	eb 0a                	jmp    802e12 <alloc_block_BF+0x1af>
  802e08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e0b:	8b 00                	mov    (%eax),%eax
  802e0d:	a3 48 51 80 00       	mov    %eax,0x805148
  802e12:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e15:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e1b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e1e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e25:	a1 54 51 80 00       	mov    0x805154,%eax
  802e2a:	48                   	dec    %eax
  802e2b:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802e30:	83 ec 08             	sub    $0x8,%esp
  802e33:	ff 75 ec             	pushl  -0x14(%ebp)
  802e36:	68 38 51 80 00       	push   $0x805138
  802e3b:	e8 71 f9 ff ff       	call   8027b1 <find_block>
  802e40:	83 c4 10             	add    $0x10,%esp
  802e43:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802e46:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e49:	8b 50 08             	mov    0x8(%eax),%edx
  802e4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4f:	01 c2                	add    %eax,%edx
  802e51:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e54:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802e57:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e5a:	8b 40 0c             	mov    0xc(%eax),%eax
  802e5d:	2b 45 08             	sub    0x8(%ebp),%eax
  802e60:	89 c2                	mov    %eax,%edx
  802e62:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e65:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802e68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e6b:	eb 05                	jmp    802e72 <alloc_block_BF+0x20f>
	}
	return NULL;
  802e6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e72:	c9                   	leave  
  802e73:	c3                   	ret    

00802e74 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802e74:	55                   	push   %ebp
  802e75:	89 e5                	mov    %esp,%ebp
  802e77:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802e7a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e7f:	85 c0                	test   %eax,%eax
  802e81:	0f 85 de 01 00 00    	jne    803065 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802e87:	a1 38 51 80 00       	mov    0x805138,%eax
  802e8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e8f:	e9 9e 01 00 00       	jmp    803032 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802e94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e97:	8b 40 0c             	mov    0xc(%eax),%eax
  802e9a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e9d:	0f 82 87 01 00 00    	jb     80302a <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802ea3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ea9:	3b 45 08             	cmp    0x8(%ebp),%eax
  802eac:	0f 85 95 00 00 00    	jne    802f47 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802eb2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eb6:	75 17                	jne    802ecf <alloc_block_NF+0x5b>
  802eb8:	83 ec 04             	sub    $0x4,%esp
  802ebb:	68 44 48 80 00       	push   $0x804844
  802ec0:	68 e0 00 00 00       	push   $0xe0
  802ec5:	68 9b 47 80 00       	push   $0x80479b
  802eca:	e8 32 da ff ff       	call   800901 <_panic>
  802ecf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed2:	8b 00                	mov    (%eax),%eax
  802ed4:	85 c0                	test   %eax,%eax
  802ed6:	74 10                	je     802ee8 <alloc_block_NF+0x74>
  802ed8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edb:	8b 00                	mov    (%eax),%eax
  802edd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ee0:	8b 52 04             	mov    0x4(%edx),%edx
  802ee3:	89 50 04             	mov    %edx,0x4(%eax)
  802ee6:	eb 0b                	jmp    802ef3 <alloc_block_NF+0x7f>
  802ee8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eeb:	8b 40 04             	mov    0x4(%eax),%eax
  802eee:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ef3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef6:	8b 40 04             	mov    0x4(%eax),%eax
  802ef9:	85 c0                	test   %eax,%eax
  802efb:	74 0f                	je     802f0c <alloc_block_NF+0x98>
  802efd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f00:	8b 40 04             	mov    0x4(%eax),%eax
  802f03:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f06:	8b 12                	mov    (%edx),%edx
  802f08:	89 10                	mov    %edx,(%eax)
  802f0a:	eb 0a                	jmp    802f16 <alloc_block_NF+0xa2>
  802f0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0f:	8b 00                	mov    (%eax),%eax
  802f11:	a3 38 51 80 00       	mov    %eax,0x805138
  802f16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f19:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f22:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f29:	a1 44 51 80 00       	mov    0x805144,%eax
  802f2e:	48                   	dec    %eax
  802f2f:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802f34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f37:	8b 40 08             	mov    0x8(%eax),%eax
  802f3a:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   return  point;
  802f3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f42:	e9 f8 04 00 00       	jmp    80343f <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802f47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4a:	8b 40 0c             	mov    0xc(%eax),%eax
  802f4d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f50:	0f 86 d4 00 00 00    	jbe    80302a <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802f56:	a1 48 51 80 00       	mov    0x805148,%eax
  802f5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802f5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f61:	8b 50 08             	mov    0x8(%eax),%edx
  802f64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f67:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802f6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f6d:	8b 55 08             	mov    0x8(%ebp),%edx
  802f70:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802f73:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f77:	75 17                	jne    802f90 <alloc_block_NF+0x11c>
  802f79:	83 ec 04             	sub    $0x4,%esp
  802f7c:	68 44 48 80 00       	push   $0x804844
  802f81:	68 e9 00 00 00       	push   $0xe9
  802f86:	68 9b 47 80 00       	push   $0x80479b
  802f8b:	e8 71 d9 ff ff       	call   800901 <_panic>
  802f90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f93:	8b 00                	mov    (%eax),%eax
  802f95:	85 c0                	test   %eax,%eax
  802f97:	74 10                	je     802fa9 <alloc_block_NF+0x135>
  802f99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f9c:	8b 00                	mov    (%eax),%eax
  802f9e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fa1:	8b 52 04             	mov    0x4(%edx),%edx
  802fa4:	89 50 04             	mov    %edx,0x4(%eax)
  802fa7:	eb 0b                	jmp    802fb4 <alloc_block_NF+0x140>
  802fa9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fac:	8b 40 04             	mov    0x4(%eax),%eax
  802faf:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb7:	8b 40 04             	mov    0x4(%eax),%eax
  802fba:	85 c0                	test   %eax,%eax
  802fbc:	74 0f                	je     802fcd <alloc_block_NF+0x159>
  802fbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc1:	8b 40 04             	mov    0x4(%eax),%eax
  802fc4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fc7:	8b 12                	mov    (%edx),%edx
  802fc9:	89 10                	mov    %edx,(%eax)
  802fcb:	eb 0a                	jmp    802fd7 <alloc_block_NF+0x163>
  802fcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fd0:	8b 00                	mov    (%eax),%eax
  802fd2:	a3 48 51 80 00       	mov    %eax,0x805148
  802fd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fda:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fe0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fea:	a1 54 51 80 00       	mov    0x805154,%eax
  802fef:	48                   	dec    %eax
  802ff0:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802ff5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff8:	8b 40 08             	mov    0x8(%eax),%eax
  802ffb:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   point->sva += size;
  803000:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803003:	8b 50 08             	mov    0x8(%eax),%edx
  803006:	8b 45 08             	mov    0x8(%ebp),%eax
  803009:	01 c2                	add    %eax,%edx
  80300b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300e:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  803011:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803014:	8b 40 0c             	mov    0xc(%eax),%eax
  803017:	2b 45 08             	sub    0x8(%ebp),%eax
  80301a:	89 c2                	mov    %eax,%edx
  80301c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301f:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  803022:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803025:	e9 15 04 00 00       	jmp    80343f <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80302a:	a1 40 51 80 00       	mov    0x805140,%eax
  80302f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803032:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803036:	74 07                	je     80303f <alloc_block_NF+0x1cb>
  803038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303b:	8b 00                	mov    (%eax),%eax
  80303d:	eb 05                	jmp    803044 <alloc_block_NF+0x1d0>
  80303f:	b8 00 00 00 00       	mov    $0x0,%eax
  803044:	a3 40 51 80 00       	mov    %eax,0x805140
  803049:	a1 40 51 80 00       	mov    0x805140,%eax
  80304e:	85 c0                	test   %eax,%eax
  803050:	0f 85 3e fe ff ff    	jne    802e94 <alloc_block_NF+0x20>
  803056:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80305a:	0f 85 34 fe ff ff    	jne    802e94 <alloc_block_NF+0x20>
  803060:	e9 d5 03 00 00       	jmp    80343a <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803065:	a1 38 51 80 00       	mov    0x805138,%eax
  80306a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80306d:	e9 b1 01 00 00       	jmp    803223 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  803072:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803075:	8b 50 08             	mov    0x8(%eax),%edx
  803078:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80307d:	39 c2                	cmp    %eax,%edx
  80307f:	0f 82 96 01 00 00    	jb     80321b <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  803085:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803088:	8b 40 0c             	mov    0xc(%eax),%eax
  80308b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80308e:	0f 82 87 01 00 00    	jb     80321b <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  803094:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803097:	8b 40 0c             	mov    0xc(%eax),%eax
  80309a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80309d:	0f 85 95 00 00 00    	jne    803138 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8030a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030a7:	75 17                	jne    8030c0 <alloc_block_NF+0x24c>
  8030a9:	83 ec 04             	sub    $0x4,%esp
  8030ac:	68 44 48 80 00       	push   $0x804844
  8030b1:	68 fc 00 00 00       	push   $0xfc
  8030b6:	68 9b 47 80 00       	push   $0x80479b
  8030bb:	e8 41 d8 ff ff       	call   800901 <_panic>
  8030c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c3:	8b 00                	mov    (%eax),%eax
  8030c5:	85 c0                	test   %eax,%eax
  8030c7:	74 10                	je     8030d9 <alloc_block_NF+0x265>
  8030c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030cc:	8b 00                	mov    (%eax),%eax
  8030ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030d1:	8b 52 04             	mov    0x4(%edx),%edx
  8030d4:	89 50 04             	mov    %edx,0x4(%eax)
  8030d7:	eb 0b                	jmp    8030e4 <alloc_block_NF+0x270>
  8030d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030dc:	8b 40 04             	mov    0x4(%eax),%eax
  8030df:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e7:	8b 40 04             	mov    0x4(%eax),%eax
  8030ea:	85 c0                	test   %eax,%eax
  8030ec:	74 0f                	je     8030fd <alloc_block_NF+0x289>
  8030ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f1:	8b 40 04             	mov    0x4(%eax),%eax
  8030f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030f7:	8b 12                	mov    (%edx),%edx
  8030f9:	89 10                	mov    %edx,(%eax)
  8030fb:	eb 0a                	jmp    803107 <alloc_block_NF+0x293>
  8030fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803100:	8b 00                	mov    (%eax),%eax
  803102:	a3 38 51 80 00       	mov    %eax,0x805138
  803107:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803110:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803113:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80311a:	a1 44 51 80 00       	mov    0x805144,%eax
  80311f:	48                   	dec    %eax
  803120:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803125:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803128:	8b 40 08             	mov    0x8(%eax),%eax
  80312b:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  803130:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803133:	e9 07 03 00 00       	jmp    80343f <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803138:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313b:	8b 40 0c             	mov    0xc(%eax),%eax
  80313e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803141:	0f 86 d4 00 00 00    	jbe    80321b <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803147:	a1 48 51 80 00       	mov    0x805148,%eax
  80314c:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  80314f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803152:	8b 50 08             	mov    0x8(%eax),%edx
  803155:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803158:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80315b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80315e:	8b 55 08             	mov    0x8(%ebp),%edx
  803161:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803164:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803168:	75 17                	jne    803181 <alloc_block_NF+0x30d>
  80316a:	83 ec 04             	sub    $0x4,%esp
  80316d:	68 44 48 80 00       	push   $0x804844
  803172:	68 04 01 00 00       	push   $0x104
  803177:	68 9b 47 80 00       	push   $0x80479b
  80317c:	e8 80 d7 ff ff       	call   800901 <_panic>
  803181:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803184:	8b 00                	mov    (%eax),%eax
  803186:	85 c0                	test   %eax,%eax
  803188:	74 10                	je     80319a <alloc_block_NF+0x326>
  80318a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80318d:	8b 00                	mov    (%eax),%eax
  80318f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803192:	8b 52 04             	mov    0x4(%edx),%edx
  803195:	89 50 04             	mov    %edx,0x4(%eax)
  803198:	eb 0b                	jmp    8031a5 <alloc_block_NF+0x331>
  80319a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80319d:	8b 40 04             	mov    0x4(%eax),%eax
  8031a0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a8:	8b 40 04             	mov    0x4(%eax),%eax
  8031ab:	85 c0                	test   %eax,%eax
  8031ad:	74 0f                	je     8031be <alloc_block_NF+0x34a>
  8031af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b2:	8b 40 04             	mov    0x4(%eax),%eax
  8031b5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031b8:	8b 12                	mov    (%edx),%edx
  8031ba:	89 10                	mov    %edx,(%eax)
  8031bc:	eb 0a                	jmp    8031c8 <alloc_block_NF+0x354>
  8031be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c1:	8b 00                	mov    (%eax),%eax
  8031c3:	a3 48 51 80 00       	mov    %eax,0x805148
  8031c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031db:	a1 54 51 80 00       	mov    0x805154,%eax
  8031e0:	48                   	dec    %eax
  8031e1:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8031e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e9:	8b 40 08             	mov    0x8(%eax),%eax
  8031ec:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  8031f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f4:	8b 50 08             	mov    0x8(%eax),%edx
  8031f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fa:	01 c2                	add    %eax,%edx
  8031fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ff:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803202:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803205:	8b 40 0c             	mov    0xc(%eax),%eax
  803208:	2b 45 08             	sub    0x8(%ebp),%eax
  80320b:	89 c2                	mov    %eax,%edx
  80320d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803210:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803213:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803216:	e9 24 02 00 00       	jmp    80343f <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80321b:	a1 40 51 80 00       	mov    0x805140,%eax
  803220:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803223:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803227:	74 07                	je     803230 <alloc_block_NF+0x3bc>
  803229:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322c:	8b 00                	mov    (%eax),%eax
  80322e:	eb 05                	jmp    803235 <alloc_block_NF+0x3c1>
  803230:	b8 00 00 00 00       	mov    $0x0,%eax
  803235:	a3 40 51 80 00       	mov    %eax,0x805140
  80323a:	a1 40 51 80 00       	mov    0x805140,%eax
  80323f:	85 c0                	test   %eax,%eax
  803241:	0f 85 2b fe ff ff    	jne    803072 <alloc_block_NF+0x1fe>
  803247:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80324b:	0f 85 21 fe ff ff    	jne    803072 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803251:	a1 38 51 80 00       	mov    0x805138,%eax
  803256:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803259:	e9 ae 01 00 00       	jmp    80340c <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  80325e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803261:	8b 50 08             	mov    0x8(%eax),%edx
  803264:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803269:	39 c2                	cmp    %eax,%edx
  80326b:	0f 83 93 01 00 00    	jae    803404 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  803271:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803274:	8b 40 0c             	mov    0xc(%eax),%eax
  803277:	3b 45 08             	cmp    0x8(%ebp),%eax
  80327a:	0f 82 84 01 00 00    	jb     803404 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  803280:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803283:	8b 40 0c             	mov    0xc(%eax),%eax
  803286:	3b 45 08             	cmp    0x8(%ebp),%eax
  803289:	0f 85 95 00 00 00    	jne    803324 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80328f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803293:	75 17                	jne    8032ac <alloc_block_NF+0x438>
  803295:	83 ec 04             	sub    $0x4,%esp
  803298:	68 44 48 80 00       	push   $0x804844
  80329d:	68 14 01 00 00       	push   $0x114
  8032a2:	68 9b 47 80 00       	push   $0x80479b
  8032a7:	e8 55 d6 ff ff       	call   800901 <_panic>
  8032ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032af:	8b 00                	mov    (%eax),%eax
  8032b1:	85 c0                	test   %eax,%eax
  8032b3:	74 10                	je     8032c5 <alloc_block_NF+0x451>
  8032b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b8:	8b 00                	mov    (%eax),%eax
  8032ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032bd:	8b 52 04             	mov    0x4(%edx),%edx
  8032c0:	89 50 04             	mov    %edx,0x4(%eax)
  8032c3:	eb 0b                	jmp    8032d0 <alloc_block_NF+0x45c>
  8032c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c8:	8b 40 04             	mov    0x4(%eax),%eax
  8032cb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d3:	8b 40 04             	mov    0x4(%eax),%eax
  8032d6:	85 c0                	test   %eax,%eax
  8032d8:	74 0f                	je     8032e9 <alloc_block_NF+0x475>
  8032da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032dd:	8b 40 04             	mov    0x4(%eax),%eax
  8032e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032e3:	8b 12                	mov    (%edx),%edx
  8032e5:	89 10                	mov    %edx,(%eax)
  8032e7:	eb 0a                	jmp    8032f3 <alloc_block_NF+0x47f>
  8032e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ec:	8b 00                	mov    (%eax),%eax
  8032ee:	a3 38 51 80 00       	mov    %eax,0x805138
  8032f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803306:	a1 44 51 80 00       	mov    0x805144,%eax
  80330b:	48                   	dec    %eax
  80330c:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803311:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803314:	8b 40 08             	mov    0x8(%eax),%eax
  803317:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  80331c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80331f:	e9 1b 01 00 00       	jmp    80343f <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803324:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803327:	8b 40 0c             	mov    0xc(%eax),%eax
  80332a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80332d:	0f 86 d1 00 00 00    	jbe    803404 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803333:	a1 48 51 80 00       	mov    0x805148,%eax
  803338:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  80333b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333e:	8b 50 08             	mov    0x8(%eax),%edx
  803341:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803344:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803347:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80334a:	8b 55 08             	mov    0x8(%ebp),%edx
  80334d:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803350:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803354:	75 17                	jne    80336d <alloc_block_NF+0x4f9>
  803356:	83 ec 04             	sub    $0x4,%esp
  803359:	68 44 48 80 00       	push   $0x804844
  80335e:	68 1c 01 00 00       	push   $0x11c
  803363:	68 9b 47 80 00       	push   $0x80479b
  803368:	e8 94 d5 ff ff       	call   800901 <_panic>
  80336d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803370:	8b 00                	mov    (%eax),%eax
  803372:	85 c0                	test   %eax,%eax
  803374:	74 10                	je     803386 <alloc_block_NF+0x512>
  803376:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803379:	8b 00                	mov    (%eax),%eax
  80337b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80337e:	8b 52 04             	mov    0x4(%edx),%edx
  803381:	89 50 04             	mov    %edx,0x4(%eax)
  803384:	eb 0b                	jmp    803391 <alloc_block_NF+0x51d>
  803386:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803389:	8b 40 04             	mov    0x4(%eax),%eax
  80338c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803391:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803394:	8b 40 04             	mov    0x4(%eax),%eax
  803397:	85 c0                	test   %eax,%eax
  803399:	74 0f                	je     8033aa <alloc_block_NF+0x536>
  80339b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80339e:	8b 40 04             	mov    0x4(%eax),%eax
  8033a1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8033a4:	8b 12                	mov    (%edx),%edx
  8033a6:	89 10                	mov    %edx,(%eax)
  8033a8:	eb 0a                	jmp    8033b4 <alloc_block_NF+0x540>
  8033aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033ad:	8b 00                	mov    (%eax),%eax
  8033af:	a3 48 51 80 00       	mov    %eax,0x805148
  8033b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033c0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033c7:	a1 54 51 80 00       	mov    0x805154,%eax
  8033cc:	48                   	dec    %eax
  8033cd:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8033d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033d5:	8b 40 08             	mov    0x8(%eax),%eax
  8033d8:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  8033dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e0:	8b 50 08             	mov    0x8(%eax),%edx
  8033e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e6:	01 c2                	add    %eax,%edx
  8033e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033eb:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8033ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8033f4:	2b 45 08             	sub    0x8(%ebp),%eax
  8033f7:	89 c2                	mov    %eax,%edx
  8033f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033fc:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8033ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803402:	eb 3b                	jmp    80343f <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803404:	a1 40 51 80 00       	mov    0x805140,%eax
  803409:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80340c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803410:	74 07                	je     803419 <alloc_block_NF+0x5a5>
  803412:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803415:	8b 00                	mov    (%eax),%eax
  803417:	eb 05                	jmp    80341e <alloc_block_NF+0x5aa>
  803419:	b8 00 00 00 00       	mov    $0x0,%eax
  80341e:	a3 40 51 80 00       	mov    %eax,0x805140
  803423:	a1 40 51 80 00       	mov    0x805140,%eax
  803428:	85 c0                	test   %eax,%eax
  80342a:	0f 85 2e fe ff ff    	jne    80325e <alloc_block_NF+0x3ea>
  803430:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803434:	0f 85 24 fe ff ff    	jne    80325e <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  80343a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80343f:	c9                   	leave  
  803440:	c3                   	ret    

00803441 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803441:	55                   	push   %ebp
  803442:	89 e5                	mov    %esp,%ebp
  803444:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  803447:	a1 38 51 80 00       	mov    0x805138,%eax
  80344c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  80344f:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803454:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  803457:	a1 38 51 80 00       	mov    0x805138,%eax
  80345c:	85 c0                	test   %eax,%eax
  80345e:	74 14                	je     803474 <insert_sorted_with_merge_freeList+0x33>
  803460:	8b 45 08             	mov    0x8(%ebp),%eax
  803463:	8b 50 08             	mov    0x8(%eax),%edx
  803466:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803469:	8b 40 08             	mov    0x8(%eax),%eax
  80346c:	39 c2                	cmp    %eax,%edx
  80346e:	0f 87 9b 01 00 00    	ja     80360f <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  803474:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803478:	75 17                	jne    803491 <insert_sorted_with_merge_freeList+0x50>
  80347a:	83 ec 04             	sub    $0x4,%esp
  80347d:	68 78 47 80 00       	push   $0x804778
  803482:	68 38 01 00 00       	push   $0x138
  803487:	68 9b 47 80 00       	push   $0x80479b
  80348c:	e8 70 d4 ff ff       	call   800901 <_panic>
  803491:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803497:	8b 45 08             	mov    0x8(%ebp),%eax
  80349a:	89 10                	mov    %edx,(%eax)
  80349c:	8b 45 08             	mov    0x8(%ebp),%eax
  80349f:	8b 00                	mov    (%eax),%eax
  8034a1:	85 c0                	test   %eax,%eax
  8034a3:	74 0d                	je     8034b2 <insert_sorted_with_merge_freeList+0x71>
  8034a5:	a1 38 51 80 00       	mov    0x805138,%eax
  8034aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8034ad:	89 50 04             	mov    %edx,0x4(%eax)
  8034b0:	eb 08                	jmp    8034ba <insert_sorted_with_merge_freeList+0x79>
  8034b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8034bd:	a3 38 51 80 00       	mov    %eax,0x805138
  8034c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034cc:	a1 44 51 80 00       	mov    0x805144,%eax
  8034d1:	40                   	inc    %eax
  8034d2:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8034d7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8034db:	0f 84 a8 06 00 00    	je     803b89 <insert_sorted_with_merge_freeList+0x748>
  8034e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e4:	8b 50 08             	mov    0x8(%eax),%edx
  8034e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8034ed:	01 c2                	add    %eax,%edx
  8034ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034f2:	8b 40 08             	mov    0x8(%eax),%eax
  8034f5:	39 c2                	cmp    %eax,%edx
  8034f7:	0f 85 8c 06 00 00    	jne    803b89 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  8034fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803500:	8b 50 0c             	mov    0xc(%eax),%edx
  803503:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803506:	8b 40 0c             	mov    0xc(%eax),%eax
  803509:	01 c2                	add    %eax,%edx
  80350b:	8b 45 08             	mov    0x8(%ebp),%eax
  80350e:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803511:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803515:	75 17                	jne    80352e <insert_sorted_with_merge_freeList+0xed>
  803517:	83 ec 04             	sub    $0x4,%esp
  80351a:	68 44 48 80 00       	push   $0x804844
  80351f:	68 3c 01 00 00       	push   $0x13c
  803524:	68 9b 47 80 00       	push   $0x80479b
  803529:	e8 d3 d3 ff ff       	call   800901 <_panic>
  80352e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803531:	8b 00                	mov    (%eax),%eax
  803533:	85 c0                	test   %eax,%eax
  803535:	74 10                	je     803547 <insert_sorted_with_merge_freeList+0x106>
  803537:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80353a:	8b 00                	mov    (%eax),%eax
  80353c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80353f:	8b 52 04             	mov    0x4(%edx),%edx
  803542:	89 50 04             	mov    %edx,0x4(%eax)
  803545:	eb 0b                	jmp    803552 <insert_sorted_with_merge_freeList+0x111>
  803547:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80354a:	8b 40 04             	mov    0x4(%eax),%eax
  80354d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803552:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803555:	8b 40 04             	mov    0x4(%eax),%eax
  803558:	85 c0                	test   %eax,%eax
  80355a:	74 0f                	je     80356b <insert_sorted_with_merge_freeList+0x12a>
  80355c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80355f:	8b 40 04             	mov    0x4(%eax),%eax
  803562:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803565:	8b 12                	mov    (%edx),%edx
  803567:	89 10                	mov    %edx,(%eax)
  803569:	eb 0a                	jmp    803575 <insert_sorted_with_merge_freeList+0x134>
  80356b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80356e:	8b 00                	mov    (%eax),%eax
  803570:	a3 38 51 80 00       	mov    %eax,0x805138
  803575:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803578:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80357e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803581:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803588:	a1 44 51 80 00       	mov    0x805144,%eax
  80358d:	48                   	dec    %eax
  80358e:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  803593:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803596:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  80359d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035a0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  8035a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8035ab:	75 17                	jne    8035c4 <insert_sorted_with_merge_freeList+0x183>
  8035ad:	83 ec 04             	sub    $0x4,%esp
  8035b0:	68 78 47 80 00       	push   $0x804778
  8035b5:	68 3f 01 00 00       	push   $0x13f
  8035ba:	68 9b 47 80 00       	push   $0x80479b
  8035bf:	e8 3d d3 ff ff       	call   800901 <_panic>
  8035c4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8035ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035cd:	89 10                	mov    %edx,(%eax)
  8035cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035d2:	8b 00                	mov    (%eax),%eax
  8035d4:	85 c0                	test   %eax,%eax
  8035d6:	74 0d                	je     8035e5 <insert_sorted_with_merge_freeList+0x1a4>
  8035d8:	a1 48 51 80 00       	mov    0x805148,%eax
  8035dd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035e0:	89 50 04             	mov    %edx,0x4(%eax)
  8035e3:	eb 08                	jmp    8035ed <insert_sorted_with_merge_freeList+0x1ac>
  8035e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035e8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035f0:	a3 48 51 80 00       	mov    %eax,0x805148
  8035f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035f8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035ff:	a1 54 51 80 00       	mov    0x805154,%eax
  803604:	40                   	inc    %eax
  803605:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80360a:	e9 7a 05 00 00       	jmp    803b89 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  80360f:	8b 45 08             	mov    0x8(%ebp),%eax
  803612:	8b 50 08             	mov    0x8(%eax),%edx
  803615:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803618:	8b 40 08             	mov    0x8(%eax),%eax
  80361b:	39 c2                	cmp    %eax,%edx
  80361d:	0f 82 14 01 00 00    	jb     803737 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803623:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803626:	8b 50 08             	mov    0x8(%eax),%edx
  803629:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80362c:	8b 40 0c             	mov    0xc(%eax),%eax
  80362f:	01 c2                	add    %eax,%edx
  803631:	8b 45 08             	mov    0x8(%ebp),%eax
  803634:	8b 40 08             	mov    0x8(%eax),%eax
  803637:	39 c2                	cmp    %eax,%edx
  803639:	0f 85 90 00 00 00    	jne    8036cf <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  80363f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803642:	8b 50 0c             	mov    0xc(%eax),%edx
  803645:	8b 45 08             	mov    0x8(%ebp),%eax
  803648:	8b 40 0c             	mov    0xc(%eax),%eax
  80364b:	01 c2                	add    %eax,%edx
  80364d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803650:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803653:	8b 45 08             	mov    0x8(%ebp),%eax
  803656:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  80365d:	8b 45 08             	mov    0x8(%ebp),%eax
  803660:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803667:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80366b:	75 17                	jne    803684 <insert_sorted_with_merge_freeList+0x243>
  80366d:	83 ec 04             	sub    $0x4,%esp
  803670:	68 78 47 80 00       	push   $0x804778
  803675:	68 49 01 00 00       	push   $0x149
  80367a:	68 9b 47 80 00       	push   $0x80479b
  80367f:	e8 7d d2 ff ff       	call   800901 <_panic>
  803684:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80368a:	8b 45 08             	mov    0x8(%ebp),%eax
  80368d:	89 10                	mov    %edx,(%eax)
  80368f:	8b 45 08             	mov    0x8(%ebp),%eax
  803692:	8b 00                	mov    (%eax),%eax
  803694:	85 c0                	test   %eax,%eax
  803696:	74 0d                	je     8036a5 <insert_sorted_with_merge_freeList+0x264>
  803698:	a1 48 51 80 00       	mov    0x805148,%eax
  80369d:	8b 55 08             	mov    0x8(%ebp),%edx
  8036a0:	89 50 04             	mov    %edx,0x4(%eax)
  8036a3:	eb 08                	jmp    8036ad <insert_sorted_with_merge_freeList+0x26c>
  8036a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b0:	a3 48 51 80 00       	mov    %eax,0x805148
  8036b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036bf:	a1 54 51 80 00       	mov    0x805154,%eax
  8036c4:	40                   	inc    %eax
  8036c5:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8036ca:	e9 bb 04 00 00       	jmp    803b8a <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8036cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036d3:	75 17                	jne    8036ec <insert_sorted_with_merge_freeList+0x2ab>
  8036d5:	83 ec 04             	sub    $0x4,%esp
  8036d8:	68 ec 47 80 00       	push   $0x8047ec
  8036dd:	68 4c 01 00 00       	push   $0x14c
  8036e2:	68 9b 47 80 00       	push   $0x80479b
  8036e7:	e8 15 d2 ff ff       	call   800901 <_panic>
  8036ec:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8036f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f5:	89 50 04             	mov    %edx,0x4(%eax)
  8036f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036fb:	8b 40 04             	mov    0x4(%eax),%eax
  8036fe:	85 c0                	test   %eax,%eax
  803700:	74 0c                	je     80370e <insert_sorted_with_merge_freeList+0x2cd>
  803702:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803707:	8b 55 08             	mov    0x8(%ebp),%edx
  80370a:	89 10                	mov    %edx,(%eax)
  80370c:	eb 08                	jmp    803716 <insert_sorted_with_merge_freeList+0x2d5>
  80370e:	8b 45 08             	mov    0x8(%ebp),%eax
  803711:	a3 38 51 80 00       	mov    %eax,0x805138
  803716:	8b 45 08             	mov    0x8(%ebp),%eax
  803719:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80371e:	8b 45 08             	mov    0x8(%ebp),%eax
  803721:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803727:	a1 44 51 80 00       	mov    0x805144,%eax
  80372c:	40                   	inc    %eax
  80372d:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803732:	e9 53 04 00 00       	jmp    803b8a <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803737:	a1 38 51 80 00       	mov    0x805138,%eax
  80373c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80373f:	e9 15 04 00 00       	jmp    803b59 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803744:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803747:	8b 00                	mov    (%eax),%eax
  803749:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  80374c:	8b 45 08             	mov    0x8(%ebp),%eax
  80374f:	8b 50 08             	mov    0x8(%eax),%edx
  803752:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803755:	8b 40 08             	mov    0x8(%eax),%eax
  803758:	39 c2                	cmp    %eax,%edx
  80375a:	0f 86 f1 03 00 00    	jbe    803b51 <insert_sorted_with_merge_freeList+0x710>
  803760:	8b 45 08             	mov    0x8(%ebp),%eax
  803763:	8b 50 08             	mov    0x8(%eax),%edx
  803766:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803769:	8b 40 08             	mov    0x8(%eax),%eax
  80376c:	39 c2                	cmp    %eax,%edx
  80376e:	0f 83 dd 03 00 00    	jae    803b51 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803774:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803777:	8b 50 08             	mov    0x8(%eax),%edx
  80377a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80377d:	8b 40 0c             	mov    0xc(%eax),%eax
  803780:	01 c2                	add    %eax,%edx
  803782:	8b 45 08             	mov    0x8(%ebp),%eax
  803785:	8b 40 08             	mov    0x8(%eax),%eax
  803788:	39 c2                	cmp    %eax,%edx
  80378a:	0f 85 b9 01 00 00    	jne    803949 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803790:	8b 45 08             	mov    0x8(%ebp),%eax
  803793:	8b 50 08             	mov    0x8(%eax),%edx
  803796:	8b 45 08             	mov    0x8(%ebp),%eax
  803799:	8b 40 0c             	mov    0xc(%eax),%eax
  80379c:	01 c2                	add    %eax,%edx
  80379e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037a1:	8b 40 08             	mov    0x8(%eax),%eax
  8037a4:	39 c2                	cmp    %eax,%edx
  8037a6:	0f 85 0d 01 00 00    	jne    8038b9 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8037ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037af:	8b 50 0c             	mov    0xc(%eax),%edx
  8037b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8037b8:	01 c2                	add    %eax,%edx
  8037ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037bd:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8037c0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8037c4:	75 17                	jne    8037dd <insert_sorted_with_merge_freeList+0x39c>
  8037c6:	83 ec 04             	sub    $0x4,%esp
  8037c9:	68 44 48 80 00       	push   $0x804844
  8037ce:	68 5c 01 00 00       	push   $0x15c
  8037d3:	68 9b 47 80 00       	push   $0x80479b
  8037d8:	e8 24 d1 ff ff       	call   800901 <_panic>
  8037dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037e0:	8b 00                	mov    (%eax),%eax
  8037e2:	85 c0                	test   %eax,%eax
  8037e4:	74 10                	je     8037f6 <insert_sorted_with_merge_freeList+0x3b5>
  8037e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037e9:	8b 00                	mov    (%eax),%eax
  8037eb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037ee:	8b 52 04             	mov    0x4(%edx),%edx
  8037f1:	89 50 04             	mov    %edx,0x4(%eax)
  8037f4:	eb 0b                	jmp    803801 <insert_sorted_with_merge_freeList+0x3c0>
  8037f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037f9:	8b 40 04             	mov    0x4(%eax),%eax
  8037fc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803801:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803804:	8b 40 04             	mov    0x4(%eax),%eax
  803807:	85 c0                	test   %eax,%eax
  803809:	74 0f                	je     80381a <insert_sorted_with_merge_freeList+0x3d9>
  80380b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80380e:	8b 40 04             	mov    0x4(%eax),%eax
  803811:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803814:	8b 12                	mov    (%edx),%edx
  803816:	89 10                	mov    %edx,(%eax)
  803818:	eb 0a                	jmp    803824 <insert_sorted_with_merge_freeList+0x3e3>
  80381a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80381d:	8b 00                	mov    (%eax),%eax
  80381f:	a3 38 51 80 00       	mov    %eax,0x805138
  803824:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803827:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80382d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803830:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803837:	a1 44 51 80 00       	mov    0x805144,%eax
  80383c:	48                   	dec    %eax
  80383d:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803842:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803845:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  80384c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80384f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803856:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80385a:	75 17                	jne    803873 <insert_sorted_with_merge_freeList+0x432>
  80385c:	83 ec 04             	sub    $0x4,%esp
  80385f:	68 78 47 80 00       	push   $0x804778
  803864:	68 5f 01 00 00       	push   $0x15f
  803869:	68 9b 47 80 00       	push   $0x80479b
  80386e:	e8 8e d0 ff ff       	call   800901 <_panic>
  803873:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803879:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80387c:	89 10                	mov    %edx,(%eax)
  80387e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803881:	8b 00                	mov    (%eax),%eax
  803883:	85 c0                	test   %eax,%eax
  803885:	74 0d                	je     803894 <insert_sorted_with_merge_freeList+0x453>
  803887:	a1 48 51 80 00       	mov    0x805148,%eax
  80388c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80388f:	89 50 04             	mov    %edx,0x4(%eax)
  803892:	eb 08                	jmp    80389c <insert_sorted_with_merge_freeList+0x45b>
  803894:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803897:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80389c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80389f:	a3 48 51 80 00       	mov    %eax,0x805148
  8038a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038a7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038ae:	a1 54 51 80 00       	mov    0x805154,%eax
  8038b3:	40                   	inc    %eax
  8038b4:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8038b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038bc:	8b 50 0c             	mov    0xc(%eax),%edx
  8038bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8038c5:	01 c2                	add    %eax,%edx
  8038c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038ca:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8038cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8038d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8038da:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8038e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038e5:	75 17                	jne    8038fe <insert_sorted_with_merge_freeList+0x4bd>
  8038e7:	83 ec 04             	sub    $0x4,%esp
  8038ea:	68 78 47 80 00       	push   $0x804778
  8038ef:	68 64 01 00 00       	push   $0x164
  8038f4:	68 9b 47 80 00       	push   $0x80479b
  8038f9:	e8 03 d0 ff ff       	call   800901 <_panic>
  8038fe:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803904:	8b 45 08             	mov    0x8(%ebp),%eax
  803907:	89 10                	mov    %edx,(%eax)
  803909:	8b 45 08             	mov    0x8(%ebp),%eax
  80390c:	8b 00                	mov    (%eax),%eax
  80390e:	85 c0                	test   %eax,%eax
  803910:	74 0d                	je     80391f <insert_sorted_with_merge_freeList+0x4de>
  803912:	a1 48 51 80 00       	mov    0x805148,%eax
  803917:	8b 55 08             	mov    0x8(%ebp),%edx
  80391a:	89 50 04             	mov    %edx,0x4(%eax)
  80391d:	eb 08                	jmp    803927 <insert_sorted_with_merge_freeList+0x4e6>
  80391f:	8b 45 08             	mov    0x8(%ebp),%eax
  803922:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803927:	8b 45 08             	mov    0x8(%ebp),%eax
  80392a:	a3 48 51 80 00       	mov    %eax,0x805148
  80392f:	8b 45 08             	mov    0x8(%ebp),%eax
  803932:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803939:	a1 54 51 80 00       	mov    0x805154,%eax
  80393e:	40                   	inc    %eax
  80393f:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803944:	e9 41 02 00 00       	jmp    803b8a <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803949:	8b 45 08             	mov    0x8(%ebp),%eax
  80394c:	8b 50 08             	mov    0x8(%eax),%edx
  80394f:	8b 45 08             	mov    0x8(%ebp),%eax
  803952:	8b 40 0c             	mov    0xc(%eax),%eax
  803955:	01 c2                	add    %eax,%edx
  803957:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80395a:	8b 40 08             	mov    0x8(%eax),%eax
  80395d:	39 c2                	cmp    %eax,%edx
  80395f:	0f 85 7c 01 00 00    	jne    803ae1 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803965:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803969:	74 06                	je     803971 <insert_sorted_with_merge_freeList+0x530>
  80396b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80396f:	75 17                	jne    803988 <insert_sorted_with_merge_freeList+0x547>
  803971:	83 ec 04             	sub    $0x4,%esp
  803974:	68 b4 47 80 00       	push   $0x8047b4
  803979:	68 69 01 00 00       	push   $0x169
  80397e:	68 9b 47 80 00       	push   $0x80479b
  803983:	e8 79 cf ff ff       	call   800901 <_panic>
  803988:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80398b:	8b 50 04             	mov    0x4(%eax),%edx
  80398e:	8b 45 08             	mov    0x8(%ebp),%eax
  803991:	89 50 04             	mov    %edx,0x4(%eax)
  803994:	8b 45 08             	mov    0x8(%ebp),%eax
  803997:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80399a:	89 10                	mov    %edx,(%eax)
  80399c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80399f:	8b 40 04             	mov    0x4(%eax),%eax
  8039a2:	85 c0                	test   %eax,%eax
  8039a4:	74 0d                	je     8039b3 <insert_sorted_with_merge_freeList+0x572>
  8039a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039a9:	8b 40 04             	mov    0x4(%eax),%eax
  8039ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8039af:	89 10                	mov    %edx,(%eax)
  8039b1:	eb 08                	jmp    8039bb <insert_sorted_with_merge_freeList+0x57a>
  8039b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8039b6:	a3 38 51 80 00       	mov    %eax,0x805138
  8039bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039be:	8b 55 08             	mov    0x8(%ebp),%edx
  8039c1:	89 50 04             	mov    %edx,0x4(%eax)
  8039c4:	a1 44 51 80 00       	mov    0x805144,%eax
  8039c9:	40                   	inc    %eax
  8039ca:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8039cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8039d2:	8b 50 0c             	mov    0xc(%eax),%edx
  8039d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8039db:	01 c2                	add    %eax,%edx
  8039dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8039e0:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8039e3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8039e7:	75 17                	jne    803a00 <insert_sorted_with_merge_freeList+0x5bf>
  8039e9:	83 ec 04             	sub    $0x4,%esp
  8039ec:	68 44 48 80 00       	push   $0x804844
  8039f1:	68 6b 01 00 00       	push   $0x16b
  8039f6:	68 9b 47 80 00       	push   $0x80479b
  8039fb:	e8 01 cf ff ff       	call   800901 <_panic>
  803a00:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a03:	8b 00                	mov    (%eax),%eax
  803a05:	85 c0                	test   %eax,%eax
  803a07:	74 10                	je     803a19 <insert_sorted_with_merge_freeList+0x5d8>
  803a09:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a0c:	8b 00                	mov    (%eax),%eax
  803a0e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a11:	8b 52 04             	mov    0x4(%edx),%edx
  803a14:	89 50 04             	mov    %edx,0x4(%eax)
  803a17:	eb 0b                	jmp    803a24 <insert_sorted_with_merge_freeList+0x5e3>
  803a19:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a1c:	8b 40 04             	mov    0x4(%eax),%eax
  803a1f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803a24:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a27:	8b 40 04             	mov    0x4(%eax),%eax
  803a2a:	85 c0                	test   %eax,%eax
  803a2c:	74 0f                	je     803a3d <insert_sorted_with_merge_freeList+0x5fc>
  803a2e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a31:	8b 40 04             	mov    0x4(%eax),%eax
  803a34:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a37:	8b 12                	mov    (%edx),%edx
  803a39:	89 10                	mov    %edx,(%eax)
  803a3b:	eb 0a                	jmp    803a47 <insert_sorted_with_merge_freeList+0x606>
  803a3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a40:	8b 00                	mov    (%eax),%eax
  803a42:	a3 38 51 80 00       	mov    %eax,0x805138
  803a47:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a4a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a50:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a53:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a5a:	a1 44 51 80 00       	mov    0x805144,%eax
  803a5f:	48                   	dec    %eax
  803a60:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803a65:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a68:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803a6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a72:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803a79:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803a7d:	75 17                	jne    803a96 <insert_sorted_with_merge_freeList+0x655>
  803a7f:	83 ec 04             	sub    $0x4,%esp
  803a82:	68 78 47 80 00       	push   $0x804778
  803a87:	68 6e 01 00 00       	push   $0x16e
  803a8c:	68 9b 47 80 00       	push   $0x80479b
  803a91:	e8 6b ce ff ff       	call   800901 <_panic>
  803a96:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a9f:	89 10                	mov    %edx,(%eax)
  803aa1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803aa4:	8b 00                	mov    (%eax),%eax
  803aa6:	85 c0                	test   %eax,%eax
  803aa8:	74 0d                	je     803ab7 <insert_sorted_with_merge_freeList+0x676>
  803aaa:	a1 48 51 80 00       	mov    0x805148,%eax
  803aaf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803ab2:	89 50 04             	mov    %edx,0x4(%eax)
  803ab5:	eb 08                	jmp    803abf <insert_sorted_with_merge_freeList+0x67e>
  803ab7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803aba:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803abf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ac2:	a3 48 51 80 00       	mov    %eax,0x805148
  803ac7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803aca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ad1:	a1 54 51 80 00       	mov    0x805154,%eax
  803ad6:	40                   	inc    %eax
  803ad7:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803adc:	e9 a9 00 00 00       	jmp    803b8a <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803ae1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ae5:	74 06                	je     803aed <insert_sorted_with_merge_freeList+0x6ac>
  803ae7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803aeb:	75 17                	jne    803b04 <insert_sorted_with_merge_freeList+0x6c3>
  803aed:	83 ec 04             	sub    $0x4,%esp
  803af0:	68 10 48 80 00       	push   $0x804810
  803af5:	68 73 01 00 00       	push   $0x173
  803afa:	68 9b 47 80 00       	push   $0x80479b
  803aff:	e8 fd cd ff ff       	call   800901 <_panic>
  803b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b07:	8b 10                	mov    (%eax),%edx
  803b09:	8b 45 08             	mov    0x8(%ebp),%eax
  803b0c:	89 10                	mov    %edx,(%eax)
  803b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  803b11:	8b 00                	mov    (%eax),%eax
  803b13:	85 c0                	test   %eax,%eax
  803b15:	74 0b                	je     803b22 <insert_sorted_with_merge_freeList+0x6e1>
  803b17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b1a:	8b 00                	mov    (%eax),%eax
  803b1c:	8b 55 08             	mov    0x8(%ebp),%edx
  803b1f:	89 50 04             	mov    %edx,0x4(%eax)
  803b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b25:	8b 55 08             	mov    0x8(%ebp),%edx
  803b28:	89 10                	mov    %edx,(%eax)
  803b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  803b2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b30:	89 50 04             	mov    %edx,0x4(%eax)
  803b33:	8b 45 08             	mov    0x8(%ebp),%eax
  803b36:	8b 00                	mov    (%eax),%eax
  803b38:	85 c0                	test   %eax,%eax
  803b3a:	75 08                	jne    803b44 <insert_sorted_with_merge_freeList+0x703>
  803b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  803b3f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803b44:	a1 44 51 80 00       	mov    0x805144,%eax
  803b49:	40                   	inc    %eax
  803b4a:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803b4f:	eb 39                	jmp    803b8a <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803b51:	a1 40 51 80 00       	mov    0x805140,%eax
  803b56:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803b59:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b5d:	74 07                	je     803b66 <insert_sorted_with_merge_freeList+0x725>
  803b5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b62:	8b 00                	mov    (%eax),%eax
  803b64:	eb 05                	jmp    803b6b <insert_sorted_with_merge_freeList+0x72a>
  803b66:	b8 00 00 00 00       	mov    $0x0,%eax
  803b6b:	a3 40 51 80 00       	mov    %eax,0x805140
  803b70:	a1 40 51 80 00       	mov    0x805140,%eax
  803b75:	85 c0                	test   %eax,%eax
  803b77:	0f 85 c7 fb ff ff    	jne    803744 <insert_sorted_with_merge_freeList+0x303>
  803b7d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b81:	0f 85 bd fb ff ff    	jne    803744 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803b87:	eb 01                	jmp    803b8a <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803b89:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803b8a:	90                   	nop
  803b8b:	c9                   	leave  
  803b8c:	c3                   	ret    
  803b8d:	66 90                	xchg   %ax,%ax
  803b8f:	90                   	nop

00803b90 <__udivdi3>:
  803b90:	55                   	push   %ebp
  803b91:	57                   	push   %edi
  803b92:	56                   	push   %esi
  803b93:	53                   	push   %ebx
  803b94:	83 ec 1c             	sub    $0x1c,%esp
  803b97:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803b9b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b9f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803ba3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803ba7:	89 ca                	mov    %ecx,%edx
  803ba9:	89 f8                	mov    %edi,%eax
  803bab:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803baf:	85 f6                	test   %esi,%esi
  803bb1:	75 2d                	jne    803be0 <__udivdi3+0x50>
  803bb3:	39 cf                	cmp    %ecx,%edi
  803bb5:	77 65                	ja     803c1c <__udivdi3+0x8c>
  803bb7:	89 fd                	mov    %edi,%ebp
  803bb9:	85 ff                	test   %edi,%edi
  803bbb:	75 0b                	jne    803bc8 <__udivdi3+0x38>
  803bbd:	b8 01 00 00 00       	mov    $0x1,%eax
  803bc2:	31 d2                	xor    %edx,%edx
  803bc4:	f7 f7                	div    %edi
  803bc6:	89 c5                	mov    %eax,%ebp
  803bc8:	31 d2                	xor    %edx,%edx
  803bca:	89 c8                	mov    %ecx,%eax
  803bcc:	f7 f5                	div    %ebp
  803bce:	89 c1                	mov    %eax,%ecx
  803bd0:	89 d8                	mov    %ebx,%eax
  803bd2:	f7 f5                	div    %ebp
  803bd4:	89 cf                	mov    %ecx,%edi
  803bd6:	89 fa                	mov    %edi,%edx
  803bd8:	83 c4 1c             	add    $0x1c,%esp
  803bdb:	5b                   	pop    %ebx
  803bdc:	5e                   	pop    %esi
  803bdd:	5f                   	pop    %edi
  803bde:	5d                   	pop    %ebp
  803bdf:	c3                   	ret    
  803be0:	39 ce                	cmp    %ecx,%esi
  803be2:	77 28                	ja     803c0c <__udivdi3+0x7c>
  803be4:	0f bd fe             	bsr    %esi,%edi
  803be7:	83 f7 1f             	xor    $0x1f,%edi
  803bea:	75 40                	jne    803c2c <__udivdi3+0x9c>
  803bec:	39 ce                	cmp    %ecx,%esi
  803bee:	72 0a                	jb     803bfa <__udivdi3+0x6a>
  803bf0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803bf4:	0f 87 9e 00 00 00    	ja     803c98 <__udivdi3+0x108>
  803bfa:	b8 01 00 00 00       	mov    $0x1,%eax
  803bff:	89 fa                	mov    %edi,%edx
  803c01:	83 c4 1c             	add    $0x1c,%esp
  803c04:	5b                   	pop    %ebx
  803c05:	5e                   	pop    %esi
  803c06:	5f                   	pop    %edi
  803c07:	5d                   	pop    %ebp
  803c08:	c3                   	ret    
  803c09:	8d 76 00             	lea    0x0(%esi),%esi
  803c0c:	31 ff                	xor    %edi,%edi
  803c0e:	31 c0                	xor    %eax,%eax
  803c10:	89 fa                	mov    %edi,%edx
  803c12:	83 c4 1c             	add    $0x1c,%esp
  803c15:	5b                   	pop    %ebx
  803c16:	5e                   	pop    %esi
  803c17:	5f                   	pop    %edi
  803c18:	5d                   	pop    %ebp
  803c19:	c3                   	ret    
  803c1a:	66 90                	xchg   %ax,%ax
  803c1c:	89 d8                	mov    %ebx,%eax
  803c1e:	f7 f7                	div    %edi
  803c20:	31 ff                	xor    %edi,%edi
  803c22:	89 fa                	mov    %edi,%edx
  803c24:	83 c4 1c             	add    $0x1c,%esp
  803c27:	5b                   	pop    %ebx
  803c28:	5e                   	pop    %esi
  803c29:	5f                   	pop    %edi
  803c2a:	5d                   	pop    %ebp
  803c2b:	c3                   	ret    
  803c2c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803c31:	89 eb                	mov    %ebp,%ebx
  803c33:	29 fb                	sub    %edi,%ebx
  803c35:	89 f9                	mov    %edi,%ecx
  803c37:	d3 e6                	shl    %cl,%esi
  803c39:	89 c5                	mov    %eax,%ebp
  803c3b:	88 d9                	mov    %bl,%cl
  803c3d:	d3 ed                	shr    %cl,%ebp
  803c3f:	89 e9                	mov    %ebp,%ecx
  803c41:	09 f1                	or     %esi,%ecx
  803c43:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803c47:	89 f9                	mov    %edi,%ecx
  803c49:	d3 e0                	shl    %cl,%eax
  803c4b:	89 c5                	mov    %eax,%ebp
  803c4d:	89 d6                	mov    %edx,%esi
  803c4f:	88 d9                	mov    %bl,%cl
  803c51:	d3 ee                	shr    %cl,%esi
  803c53:	89 f9                	mov    %edi,%ecx
  803c55:	d3 e2                	shl    %cl,%edx
  803c57:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c5b:	88 d9                	mov    %bl,%cl
  803c5d:	d3 e8                	shr    %cl,%eax
  803c5f:	09 c2                	or     %eax,%edx
  803c61:	89 d0                	mov    %edx,%eax
  803c63:	89 f2                	mov    %esi,%edx
  803c65:	f7 74 24 0c          	divl   0xc(%esp)
  803c69:	89 d6                	mov    %edx,%esi
  803c6b:	89 c3                	mov    %eax,%ebx
  803c6d:	f7 e5                	mul    %ebp
  803c6f:	39 d6                	cmp    %edx,%esi
  803c71:	72 19                	jb     803c8c <__udivdi3+0xfc>
  803c73:	74 0b                	je     803c80 <__udivdi3+0xf0>
  803c75:	89 d8                	mov    %ebx,%eax
  803c77:	31 ff                	xor    %edi,%edi
  803c79:	e9 58 ff ff ff       	jmp    803bd6 <__udivdi3+0x46>
  803c7e:	66 90                	xchg   %ax,%ax
  803c80:	8b 54 24 08          	mov    0x8(%esp),%edx
  803c84:	89 f9                	mov    %edi,%ecx
  803c86:	d3 e2                	shl    %cl,%edx
  803c88:	39 c2                	cmp    %eax,%edx
  803c8a:	73 e9                	jae    803c75 <__udivdi3+0xe5>
  803c8c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803c8f:	31 ff                	xor    %edi,%edi
  803c91:	e9 40 ff ff ff       	jmp    803bd6 <__udivdi3+0x46>
  803c96:	66 90                	xchg   %ax,%ax
  803c98:	31 c0                	xor    %eax,%eax
  803c9a:	e9 37 ff ff ff       	jmp    803bd6 <__udivdi3+0x46>
  803c9f:	90                   	nop

00803ca0 <__umoddi3>:
  803ca0:	55                   	push   %ebp
  803ca1:	57                   	push   %edi
  803ca2:	56                   	push   %esi
  803ca3:	53                   	push   %ebx
  803ca4:	83 ec 1c             	sub    $0x1c,%esp
  803ca7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803cab:	8b 74 24 34          	mov    0x34(%esp),%esi
  803caf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803cb3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803cb7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803cbb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803cbf:	89 f3                	mov    %esi,%ebx
  803cc1:	89 fa                	mov    %edi,%edx
  803cc3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803cc7:	89 34 24             	mov    %esi,(%esp)
  803cca:	85 c0                	test   %eax,%eax
  803ccc:	75 1a                	jne    803ce8 <__umoddi3+0x48>
  803cce:	39 f7                	cmp    %esi,%edi
  803cd0:	0f 86 a2 00 00 00    	jbe    803d78 <__umoddi3+0xd8>
  803cd6:	89 c8                	mov    %ecx,%eax
  803cd8:	89 f2                	mov    %esi,%edx
  803cda:	f7 f7                	div    %edi
  803cdc:	89 d0                	mov    %edx,%eax
  803cde:	31 d2                	xor    %edx,%edx
  803ce0:	83 c4 1c             	add    $0x1c,%esp
  803ce3:	5b                   	pop    %ebx
  803ce4:	5e                   	pop    %esi
  803ce5:	5f                   	pop    %edi
  803ce6:	5d                   	pop    %ebp
  803ce7:	c3                   	ret    
  803ce8:	39 f0                	cmp    %esi,%eax
  803cea:	0f 87 ac 00 00 00    	ja     803d9c <__umoddi3+0xfc>
  803cf0:	0f bd e8             	bsr    %eax,%ebp
  803cf3:	83 f5 1f             	xor    $0x1f,%ebp
  803cf6:	0f 84 ac 00 00 00    	je     803da8 <__umoddi3+0x108>
  803cfc:	bf 20 00 00 00       	mov    $0x20,%edi
  803d01:	29 ef                	sub    %ebp,%edi
  803d03:	89 fe                	mov    %edi,%esi
  803d05:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803d09:	89 e9                	mov    %ebp,%ecx
  803d0b:	d3 e0                	shl    %cl,%eax
  803d0d:	89 d7                	mov    %edx,%edi
  803d0f:	89 f1                	mov    %esi,%ecx
  803d11:	d3 ef                	shr    %cl,%edi
  803d13:	09 c7                	or     %eax,%edi
  803d15:	89 e9                	mov    %ebp,%ecx
  803d17:	d3 e2                	shl    %cl,%edx
  803d19:	89 14 24             	mov    %edx,(%esp)
  803d1c:	89 d8                	mov    %ebx,%eax
  803d1e:	d3 e0                	shl    %cl,%eax
  803d20:	89 c2                	mov    %eax,%edx
  803d22:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d26:	d3 e0                	shl    %cl,%eax
  803d28:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d2c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d30:	89 f1                	mov    %esi,%ecx
  803d32:	d3 e8                	shr    %cl,%eax
  803d34:	09 d0                	or     %edx,%eax
  803d36:	d3 eb                	shr    %cl,%ebx
  803d38:	89 da                	mov    %ebx,%edx
  803d3a:	f7 f7                	div    %edi
  803d3c:	89 d3                	mov    %edx,%ebx
  803d3e:	f7 24 24             	mull   (%esp)
  803d41:	89 c6                	mov    %eax,%esi
  803d43:	89 d1                	mov    %edx,%ecx
  803d45:	39 d3                	cmp    %edx,%ebx
  803d47:	0f 82 87 00 00 00    	jb     803dd4 <__umoddi3+0x134>
  803d4d:	0f 84 91 00 00 00    	je     803de4 <__umoddi3+0x144>
  803d53:	8b 54 24 04          	mov    0x4(%esp),%edx
  803d57:	29 f2                	sub    %esi,%edx
  803d59:	19 cb                	sbb    %ecx,%ebx
  803d5b:	89 d8                	mov    %ebx,%eax
  803d5d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803d61:	d3 e0                	shl    %cl,%eax
  803d63:	89 e9                	mov    %ebp,%ecx
  803d65:	d3 ea                	shr    %cl,%edx
  803d67:	09 d0                	or     %edx,%eax
  803d69:	89 e9                	mov    %ebp,%ecx
  803d6b:	d3 eb                	shr    %cl,%ebx
  803d6d:	89 da                	mov    %ebx,%edx
  803d6f:	83 c4 1c             	add    $0x1c,%esp
  803d72:	5b                   	pop    %ebx
  803d73:	5e                   	pop    %esi
  803d74:	5f                   	pop    %edi
  803d75:	5d                   	pop    %ebp
  803d76:	c3                   	ret    
  803d77:	90                   	nop
  803d78:	89 fd                	mov    %edi,%ebp
  803d7a:	85 ff                	test   %edi,%edi
  803d7c:	75 0b                	jne    803d89 <__umoddi3+0xe9>
  803d7e:	b8 01 00 00 00       	mov    $0x1,%eax
  803d83:	31 d2                	xor    %edx,%edx
  803d85:	f7 f7                	div    %edi
  803d87:	89 c5                	mov    %eax,%ebp
  803d89:	89 f0                	mov    %esi,%eax
  803d8b:	31 d2                	xor    %edx,%edx
  803d8d:	f7 f5                	div    %ebp
  803d8f:	89 c8                	mov    %ecx,%eax
  803d91:	f7 f5                	div    %ebp
  803d93:	89 d0                	mov    %edx,%eax
  803d95:	e9 44 ff ff ff       	jmp    803cde <__umoddi3+0x3e>
  803d9a:	66 90                	xchg   %ax,%ax
  803d9c:	89 c8                	mov    %ecx,%eax
  803d9e:	89 f2                	mov    %esi,%edx
  803da0:	83 c4 1c             	add    $0x1c,%esp
  803da3:	5b                   	pop    %ebx
  803da4:	5e                   	pop    %esi
  803da5:	5f                   	pop    %edi
  803da6:	5d                   	pop    %ebp
  803da7:	c3                   	ret    
  803da8:	3b 04 24             	cmp    (%esp),%eax
  803dab:	72 06                	jb     803db3 <__umoddi3+0x113>
  803dad:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803db1:	77 0f                	ja     803dc2 <__umoddi3+0x122>
  803db3:	89 f2                	mov    %esi,%edx
  803db5:	29 f9                	sub    %edi,%ecx
  803db7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803dbb:	89 14 24             	mov    %edx,(%esp)
  803dbe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803dc2:	8b 44 24 04          	mov    0x4(%esp),%eax
  803dc6:	8b 14 24             	mov    (%esp),%edx
  803dc9:	83 c4 1c             	add    $0x1c,%esp
  803dcc:	5b                   	pop    %ebx
  803dcd:	5e                   	pop    %esi
  803dce:	5f                   	pop    %edi
  803dcf:	5d                   	pop    %ebp
  803dd0:	c3                   	ret    
  803dd1:	8d 76 00             	lea    0x0(%esi),%esi
  803dd4:	2b 04 24             	sub    (%esp),%eax
  803dd7:	19 fa                	sbb    %edi,%edx
  803dd9:	89 d1                	mov    %edx,%ecx
  803ddb:	89 c6                	mov    %eax,%esi
  803ddd:	e9 71 ff ff ff       	jmp    803d53 <__umoddi3+0xb3>
  803de2:	66 90                	xchg   %ax,%ax
  803de4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803de8:	72 ea                	jb     803dd4 <__umoddi3+0x134>
  803dea:	89 d9                	mov    %ebx,%ecx
  803dec:	e9 62 ff ff ff       	jmp    803d53 <__umoddi3+0xb3>
