
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
  800041:	e8 07 22 00 00       	call   80224d <sys_disable_interrupt>

		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 a0 3f 80 00       	push   $0x803fa0
  80004e:	e8 62 0b 00 00       	call   800bb5 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 a2 3f 80 00       	push   $0x803fa2
  80005e:	e8 52 0b 00 00       	call   800bb5 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 b8 3f 80 00       	push   $0x803fb8
  80006e:	e8 42 0b 00 00       	call   800bb5 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 a2 3f 80 00       	push   $0x803fa2
  80007e:	e8 32 0b 00 00       	call   800bb5 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 a0 3f 80 00       	push   $0x803fa0
  80008e:	e8 22 0b 00 00       	call   800bb5 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 d0 3f 80 00       	push   $0x803fd0
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
  8000de:	68 f0 3f 80 00       	push   $0x803ff0
  8000e3:	e8 cd 0a 00 00       	call   800bb5 <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 12 40 80 00       	push   $0x804012
  8000f3:	e8 bd 0a 00 00       	call   800bb5 <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 20 40 80 00       	push   $0x804020
  800103:	e8 ad 0a 00 00       	call   800bb5 <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 2f 40 80 00       	push   $0x80402f
  800113:	e8 9d 0a 00 00       	call   800bb5 <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 3f 40 80 00       	push   $0x80403f
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
  800162:	e8 00 21 00 00       	call   802267 <sys_enable_interrupt>

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
  8001d7:	e8 71 20 00 00       	call   80224d <sys_disable_interrupt>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	68 48 40 80 00       	push   $0x804048
  8001e4:	e8 cc 09 00 00       	call   800bb5 <cprintf>
  8001e9:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001ec:	e8 76 20 00 00       	call   802267 <sys_enable_interrupt>

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
  80020e:	68 7c 40 80 00       	push   $0x80407c
  800213:	6a 4a                	push   $0x4a
  800215:	68 9e 40 80 00       	push   $0x80409e
  80021a:	e8 e2 06 00 00       	call   800901 <_panic>
		else
		{
			sys_disable_interrupt();
  80021f:	e8 29 20 00 00       	call   80224d <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	68 bc 40 80 00       	push   $0x8040bc
  80022c:	e8 84 09 00 00       	call   800bb5 <cprintf>
  800231:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	68 f0 40 80 00       	push   $0x8040f0
  80023c:	e8 74 09 00 00       	call   800bb5 <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 24 41 80 00       	push   $0x804124
  80024c:	e8 64 09 00 00       	call   800bb5 <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800254:	e8 0e 20 00 00       	call   802267 <sys_enable_interrupt>
		}

		free(Elements) ;
  800259:	83 ec 0c             	sub    $0xc,%esp
  80025c:	ff 75 ec             	pushl  -0x14(%ebp)
  80025f:	e8 5a 1b 00 00       	call   801dbe <free>
  800264:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  800267:	e8 e1 1f 00 00       	call   80224d <sys_disable_interrupt>
			Chose = 0 ;
  80026c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800270:	eb 42                	jmp    8002b4 <_main+0x27c>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800272:	83 ec 0c             	sub    $0xc,%esp
  800275:	68 56 41 80 00       	push   $0x804156
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
  8002c0:	e8 a2 1f 00 00       	call   802267 <sys_enable_interrupt>

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
  800454:	68 a0 3f 80 00       	push   $0x803fa0
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
  800476:	68 74 41 80 00       	push   $0x804174
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
  8004a4:	68 79 41 80 00       	push   $0x804179
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
  80070c:	e8 ad 16 00 00       	call   801dbe <free>
  800711:	83 c4 10             	add    $0x10,%esp
	//cprintf("free RIGHT\n");
	free(Right);
  800714:	83 ec 0c             	sub    $0xc,%esp
  800717:	ff 75 d4             	pushl  -0x2c(%ebp)
  80071a:	e8 9f 16 00 00       	call   801dbe <free>
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
  800739:	e8 43 1b 00 00       	call   802281 <sys_cputc>
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
  80074a:	e8 fe 1a 00 00       	call   80224d <sys_disable_interrupt>
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
  80075d:	e8 1f 1b 00 00       	call   802281 <sys_cputc>
  800762:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800765:	e8 fd 1a 00 00       	call   802267 <sys_enable_interrupt>
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
  80077c:	e8 47 19 00 00       	call   8020c8 <sys_cgetc>
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
  800795:	e8 b3 1a 00 00       	call   80224d <sys_disable_interrupt>
	int c=0;
  80079a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8007a1:	eb 08                	jmp    8007ab <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  8007a3:	e8 20 19 00 00       	call   8020c8 <sys_cgetc>
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
  8007b1:	e8 b1 1a 00 00       	call   802267 <sys_enable_interrupt>
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
  8007cb:	e8 70 1c 00 00       	call   802440 <sys_getenvindex>
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
  800836:	e8 12 1a 00 00       	call   80224d <sys_disable_interrupt>
	cprintf("**************************************\n");
  80083b:	83 ec 0c             	sub    $0xc,%esp
  80083e:	68 98 41 80 00       	push   $0x804198
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
  800866:	68 c0 41 80 00       	push   $0x8041c0
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
  800897:	68 e8 41 80 00       	push   $0x8041e8
  80089c:	e8 14 03 00 00       	call   800bb5 <cprintf>
  8008a1:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8008a4:	a1 24 50 80 00       	mov    0x805024,%eax
  8008a9:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8008af:	83 ec 08             	sub    $0x8,%esp
  8008b2:	50                   	push   %eax
  8008b3:	68 40 42 80 00       	push   $0x804240
  8008b8:	e8 f8 02 00 00       	call   800bb5 <cprintf>
  8008bd:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8008c0:	83 ec 0c             	sub    $0xc,%esp
  8008c3:	68 98 41 80 00       	push   $0x804198
  8008c8:	e8 e8 02 00 00       	call   800bb5 <cprintf>
  8008cd:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8008d0:	e8 92 19 00 00       	call   802267 <sys_enable_interrupt>

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
  8008e8:	e8 1f 1b 00 00       	call   80240c <sys_destroy_env>
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
  8008f9:	e8 74 1b 00 00       	call   802472 <sys_exit_env>
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
  800922:	68 54 42 80 00       	push   $0x804254
  800927:	e8 89 02 00 00       	call   800bb5 <cprintf>
  80092c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80092f:	a1 00 50 80 00       	mov    0x805000,%eax
  800934:	ff 75 0c             	pushl  0xc(%ebp)
  800937:	ff 75 08             	pushl  0x8(%ebp)
  80093a:	50                   	push   %eax
  80093b:	68 59 42 80 00       	push   $0x804259
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
  80095f:	68 75 42 80 00       	push   $0x804275
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
  80098b:	68 78 42 80 00       	push   $0x804278
  800990:	6a 26                	push   $0x26
  800992:	68 c4 42 80 00       	push   $0x8042c4
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
  800a5d:	68 d0 42 80 00       	push   $0x8042d0
  800a62:	6a 3a                	push   $0x3a
  800a64:	68 c4 42 80 00       	push   $0x8042c4
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
  800acd:	68 24 43 80 00       	push   $0x804324
  800ad2:	6a 44                	push   $0x44
  800ad4:	68 c4 42 80 00       	push   $0x8042c4
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
  800b27:	e8 73 15 00 00       	call   80209f <sys_cputs>
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
  800b9e:	e8 fc 14 00 00       	call   80209f <sys_cputs>
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
  800be8:	e8 60 16 00 00       	call   80224d <sys_disable_interrupt>
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
  800c08:	e8 5a 16 00 00       	call   802267 <sys_enable_interrupt>
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
  800c52:	e8 cd 30 00 00       	call   803d24 <__udivdi3>
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
  800ca2:	e8 8d 31 00 00       	call   803e34 <__umoddi3>
  800ca7:	83 c4 10             	add    $0x10,%esp
  800caa:	05 94 45 80 00       	add    $0x804594,%eax
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
  800dfd:	8b 04 85 b8 45 80 00 	mov    0x8045b8(,%eax,4),%eax
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
  800ede:	8b 34 9d 00 44 80 00 	mov    0x804400(,%ebx,4),%esi
  800ee5:	85 f6                	test   %esi,%esi
  800ee7:	75 19                	jne    800f02 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ee9:	53                   	push   %ebx
  800eea:	68 a5 45 80 00       	push   $0x8045a5
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
  800f03:	68 ae 45 80 00       	push   $0x8045ae
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
  800f30:	be b1 45 80 00       	mov    $0x8045b1,%esi
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
  801249:	68 10 47 80 00       	push   $0x804710
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
  80128b:	68 13 47 80 00       	push   $0x804713
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
  80133b:	e8 0d 0f 00 00       	call   80224d <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  801340:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801344:	74 13                	je     801359 <atomic_readline+0x24>
		cprintf("%s", prompt);
  801346:	83 ec 08             	sub    $0x8,%esp
  801349:	ff 75 08             	pushl  0x8(%ebp)
  80134c:	68 10 47 80 00       	push   $0x804710
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
  80138a:	68 13 47 80 00       	push   $0x804713
  80138f:	e8 21 f8 ff ff       	call   800bb5 <cprintf>
  801394:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801397:	e8 cb 0e 00 00       	call   802267 <sys_enable_interrupt>
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
  80142f:	e8 33 0e 00 00       	call   802267 <sys_enable_interrupt>
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
  801b5c:	68 24 47 80 00       	push   $0x804724
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
  801c2c:	e8 b2 05 00 00       	call   8021e3 <sys_allocate_chunk>
  801c31:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801c34:	a1 20 51 80 00       	mov    0x805120,%eax
  801c39:	83 ec 0c             	sub    $0xc,%esp
  801c3c:	50                   	push   %eax
  801c3d:	e8 27 0c 00 00       	call   802869 <initialize_MemBlocksList>
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
  801c6a:	68 49 47 80 00       	push   $0x804749
  801c6f:	6a 33                	push   $0x33
  801c71:	68 67 47 80 00       	push   $0x804767
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
  801ce9:	68 74 47 80 00       	push   $0x804774
  801cee:	6a 34                	push   $0x34
  801cf0:	68 67 47 80 00       	push   $0x804767
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
  801d46:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d49:	e8 f7 fd ff ff       	call   801b45 <InitializeUHeap>
	if (size == 0) return NULL ;
  801d4e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d52:	75 07                	jne    801d5b <malloc+0x18>
  801d54:	b8 00 00 00 00       	mov    $0x0,%eax
  801d59:	eb 61                	jmp    801dbc <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  801d5b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801d62:	8b 55 08             	mov    0x8(%ebp),%edx
  801d65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d68:	01 d0                	add    %edx,%eax
  801d6a:	48                   	dec    %eax
  801d6b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801d6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d71:	ba 00 00 00 00       	mov    $0x0,%edx
  801d76:	f7 75 f0             	divl   -0x10(%ebp)
  801d79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d7c:	29 d0                	sub    %edx,%eax
  801d7e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801d81:	e8 2b 08 00 00       	call   8025b1 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d86:	85 c0                	test   %eax,%eax
  801d88:	74 11                	je     801d9b <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801d8a:	83 ec 0c             	sub    $0xc,%esp
  801d8d:	ff 75 e8             	pushl  -0x18(%ebp)
  801d90:	e8 96 0e 00 00       	call   802c2b <alloc_block_FF>
  801d95:	83 c4 10             	add    $0x10,%esp
  801d98:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  801d9b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d9f:	74 16                	je     801db7 <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  801da1:	83 ec 0c             	sub    $0xc,%esp
  801da4:	ff 75 f4             	pushl  -0xc(%ebp)
  801da7:	e8 f2 0b 00 00       	call   80299e <insert_sorted_allocList>
  801dac:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  801daf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db2:	8b 40 08             	mov    0x8(%eax),%eax
  801db5:	eb 05                	jmp    801dbc <malloc+0x79>
	}

    return NULL;
  801db7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dbc:	c9                   	leave  
  801dbd:	c3                   	ret    

00801dbe <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801dbe:	55                   	push   %ebp
  801dbf:	89 e5                	mov    %esp,%ebp
  801dc1:	83 ec 18             	sub    $0x18,%esp
<<<<<<< HEAD
=======
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc7:	83 ec 08             	sub    $0x8,%esp
  801dca:	50                   	push   %eax
  801dcb:	68 40 50 80 00       	push   $0x805040
  801dd0:	e8 71 0b 00 00       	call   802946 <find_block>
  801dd5:	83 c4 10             	add    $0x10,%esp
  801dd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(free_block!=NULL)
  801ddb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ddf:	0f 84 a6 00 00 00    	je     801e8b <free+0xcd>
	{
		sys_free_user_mem(free_block->sva,free_block->size);
  801de5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de8:	8b 50 0c             	mov    0xc(%eax),%edx
  801deb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dee:	8b 40 08             	mov    0x8(%eax),%eax
  801df1:	83 ec 08             	sub    $0x8,%esp
  801df4:	52                   	push   %edx
  801df5:	50                   	push   %eax
  801df6:	e8 b0 03 00 00       	call   8021ab <sys_free_user_mem>
  801dfb:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,free_block);
  801dfe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e02:	75 14                	jne    801e18 <free+0x5a>
  801e04:	83 ec 04             	sub    $0x4,%esp
  801e07:	68 49 47 80 00       	push   $0x804749
  801e0c:	6a 74                	push   $0x74
  801e0e:	68 67 47 80 00       	push   $0x804767
  801e13:	e8 e9 ea ff ff       	call   800901 <_panic>
  801e18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e1b:	8b 00                	mov    (%eax),%eax
  801e1d:	85 c0                	test   %eax,%eax
  801e1f:	74 10                	je     801e31 <free+0x73>
  801e21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e24:	8b 00                	mov    (%eax),%eax
  801e26:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e29:	8b 52 04             	mov    0x4(%edx),%edx
  801e2c:	89 50 04             	mov    %edx,0x4(%eax)
  801e2f:	eb 0b                	jmp    801e3c <free+0x7e>
  801e31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e34:	8b 40 04             	mov    0x4(%eax),%eax
  801e37:	a3 44 50 80 00       	mov    %eax,0x805044
  801e3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e3f:	8b 40 04             	mov    0x4(%eax),%eax
  801e42:	85 c0                	test   %eax,%eax
  801e44:	74 0f                	je     801e55 <free+0x97>
  801e46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e49:	8b 40 04             	mov    0x4(%eax),%eax
  801e4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e4f:	8b 12                	mov    (%edx),%edx
  801e51:	89 10                	mov    %edx,(%eax)
  801e53:	eb 0a                	jmp    801e5f <free+0xa1>
  801e55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e58:	8b 00                	mov    (%eax),%eax
  801e5a:	a3 40 50 80 00       	mov    %eax,0x805040
  801e5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e62:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e6b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e72:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801e77:	48                   	dec    %eax
  801e78:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(free_block);
  801e7d:	83 ec 0c             	sub    $0xc,%esp
  801e80:	ff 75 f4             	pushl  -0xc(%ebp)
  801e83:	e8 4e 17 00 00       	call   8035d6 <insert_sorted_with_merge_freeList>
  801e88:	83 c4 10             	add    $0x10,%esp
	}
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
<<<<<<< HEAD

	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc7:	83 ec 08             	sub    $0x8,%esp
  801dca:	50                   	push   %eax
  801dcb:	68 40 50 80 00       	push   $0x805040
  801dd0:	e8 71 0b 00 00       	call   802946 <find_block>
  801dd5:	83 c4 10             	add    $0x10,%esp
  801dd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    if(free_block!=NULL)
  801ddb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ddf:	0f 84 a6 00 00 00    	je     801e8b <free+0xcd>
	    {
	    	sys_free_user_mem(free_block->sva,free_block->size);
  801de5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de8:	8b 50 0c             	mov    0xc(%eax),%edx
  801deb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dee:	8b 40 08             	mov    0x8(%eax),%eax
  801df1:	83 ec 08             	sub    $0x8,%esp
  801df4:	52                   	push   %edx
  801df5:	50                   	push   %eax
  801df6:	e8 b0 03 00 00       	call   8021ab <sys_free_user_mem>
  801dfb:	83 c4 10             	add    $0x10,%esp
	    	LIST_REMOVE(&AllocMemBlocksList,free_block);
  801dfe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e02:	75 14                	jne    801e18 <free+0x5a>
  801e04:	83 ec 04             	sub    $0x4,%esp
  801e07:	68 49 47 80 00       	push   $0x804749
  801e0c:	6a 7a                	push   $0x7a
  801e0e:	68 67 47 80 00       	push   $0x804767
  801e13:	e8 e9 ea ff ff       	call   800901 <_panic>
  801e18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e1b:	8b 00                	mov    (%eax),%eax
  801e1d:	85 c0                	test   %eax,%eax
  801e1f:	74 10                	je     801e31 <free+0x73>
  801e21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e24:	8b 00                	mov    (%eax),%eax
  801e26:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e29:	8b 52 04             	mov    0x4(%edx),%edx
  801e2c:	89 50 04             	mov    %edx,0x4(%eax)
  801e2f:	eb 0b                	jmp    801e3c <free+0x7e>
  801e31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e34:	8b 40 04             	mov    0x4(%eax),%eax
  801e37:	a3 44 50 80 00       	mov    %eax,0x805044
  801e3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e3f:	8b 40 04             	mov    0x4(%eax),%eax
  801e42:	85 c0                	test   %eax,%eax
  801e44:	74 0f                	je     801e55 <free+0x97>
  801e46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e49:	8b 40 04             	mov    0x4(%eax),%eax
  801e4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e4f:	8b 12                	mov    (%edx),%edx
  801e51:	89 10                	mov    %edx,(%eax)
  801e53:	eb 0a                	jmp    801e5f <free+0xa1>
  801e55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e58:	8b 00                	mov    (%eax),%eax
  801e5a:	a3 40 50 80 00       	mov    %eax,0x805040
  801e5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e62:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e6b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e72:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801e77:	48                   	dec    %eax
  801e78:	a3 4c 50 80 00       	mov    %eax,0x80504c
	        insert_sorted_with_merge_freeList(free_block);
  801e7d:	83 ec 0c             	sub    $0xc,%esp
  801e80:	ff 75 f4             	pushl  -0xc(%ebp)
  801e83:	e8 4e 17 00 00       	call   8035d6 <insert_sorted_with_merge_freeList>
  801e88:	83 c4 10             	add    $0x10,%esp



	    }
=======
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
}
  801e8b:	90                   	nop
  801e8c:	c9                   	leave  
  801e8d:	c3                   	ret    

00801e8e <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801e8e:	55                   	push   %ebp
  801e8f:	89 e5                	mov    %esp,%ebp
  801e91:	83 ec 38             	sub    $0x38,%esp
  801e94:	8b 45 10             	mov    0x10(%ebp),%eax
  801e97:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e9a:	e8 a6 fc ff ff       	call   801b45 <InitializeUHeap>
	if (size == 0) return NULL ;
  801e9f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ea3:	75 0a                	jne    801eaf <smalloc+0x21>
  801ea5:	b8 00 00 00 00       	mov    $0x0,%eax
  801eaa:	e9 8b 00 00 00       	jmp    801f3a <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801eaf:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801eb6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ebc:	01 d0                	add    %edx,%eax
  801ebe:	48                   	dec    %eax
  801ebf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ec2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ec5:	ba 00 00 00 00       	mov    $0x0,%edx
  801eca:	f7 75 f0             	divl   -0x10(%ebp)
  801ecd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ed0:	29 d0                	sub    %edx,%eax
  801ed2:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801ed5:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801edc:	e8 d0 06 00 00       	call   8025b1 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801ee1:	85 c0                	test   %eax,%eax
  801ee3:	74 11                	je     801ef6 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801ee5:	83 ec 0c             	sub    $0xc,%esp
  801ee8:	ff 75 e8             	pushl  -0x18(%ebp)
  801eeb:	e8 3b 0d 00 00       	call   802c2b <alloc_block_FF>
  801ef0:	83 c4 10             	add    $0x10,%esp
  801ef3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  801ef6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801efa:	74 39                	je     801f35 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801efc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eff:	8b 40 08             	mov    0x8(%eax),%eax
  801f02:	89 c2                	mov    %eax,%edx
  801f04:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801f08:	52                   	push   %edx
  801f09:	50                   	push   %eax
  801f0a:	ff 75 0c             	pushl  0xc(%ebp)
  801f0d:	ff 75 08             	pushl  0x8(%ebp)
  801f10:	e8 21 04 00 00       	call   802336 <sys_createSharedObject>
  801f15:	83 c4 10             	add    $0x10,%esp
  801f18:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801f1b:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801f1f:	74 14                	je     801f35 <smalloc+0xa7>
  801f21:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801f25:	74 0e                	je     801f35 <smalloc+0xa7>
  801f27:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801f2b:	74 08                	je     801f35 <smalloc+0xa7>
			return (void*) mem_block->sva;
  801f2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f30:	8b 40 08             	mov    0x8(%eax),%eax
  801f33:	eb 05                	jmp    801f3a <smalloc+0xac>
	}
	return NULL;
  801f35:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801f3a:	c9                   	leave  
  801f3b:	c3                   	ret    

00801f3c <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801f3c:	55                   	push   %ebp
  801f3d:	89 e5                	mov    %esp,%ebp
  801f3f:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f42:	e8 fe fb ff ff       	call   801b45 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801f47:	83 ec 08             	sub    $0x8,%esp
  801f4a:	ff 75 0c             	pushl  0xc(%ebp)
  801f4d:	ff 75 08             	pushl  0x8(%ebp)
  801f50:	e8 0b 04 00 00       	call   802360 <sys_getSizeOfSharedObject>
  801f55:	83 c4 10             	add    $0x10,%esp
  801f58:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  801f5b:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  801f5f:	74 76                	je     801fd7 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801f61:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801f68:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f6e:	01 d0                	add    %edx,%eax
  801f70:	48                   	dec    %eax
  801f71:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801f74:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f77:	ba 00 00 00 00       	mov    $0x0,%edx
  801f7c:	f7 75 ec             	divl   -0x14(%ebp)
  801f7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f82:	29 d0                	sub    %edx,%eax
  801f84:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801f87:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801f8e:	e8 1e 06 00 00       	call   8025b1 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801f93:	85 c0                	test   %eax,%eax
  801f95:	74 11                	je     801fa8 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801f97:	83 ec 0c             	sub    $0xc,%esp
  801f9a:	ff 75 e4             	pushl  -0x1c(%ebp)
  801f9d:	e8 89 0c 00 00       	call   802c2b <alloc_block_FF>
  801fa2:	83 c4 10             	add    $0x10,%esp
  801fa5:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  801fa8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fac:	74 29                	je     801fd7 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801fae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb1:	8b 40 08             	mov    0x8(%eax),%eax
  801fb4:	83 ec 04             	sub    $0x4,%esp
  801fb7:	50                   	push   %eax
  801fb8:	ff 75 0c             	pushl  0xc(%ebp)
  801fbb:	ff 75 08             	pushl  0x8(%ebp)
  801fbe:	e8 ba 03 00 00       	call   80237d <sys_getSharedObject>
  801fc3:	83 c4 10             	add    $0x10,%esp
  801fc6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  801fc9:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  801fcd:	74 08                	je     801fd7 <sget+0x9b>
				return (void *)mem_block->sva;
  801fcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd2:	8b 40 08             	mov    0x8(%eax),%eax
  801fd5:	eb 05                	jmp    801fdc <sget+0xa0>
		}
	}
	return NULL;
  801fd7:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801fdc:	c9                   	leave  
  801fdd:	c3                   	ret    

00801fde <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801fde:	55                   	push   %ebp
  801fdf:	89 e5                	mov    %esp,%ebp
  801fe1:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801fe4:	e8 5c fb ff ff       	call   801b45 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801fe9:	83 ec 04             	sub    $0x4,%esp
  801fec:	68 98 47 80 00       	push   $0x804798
<<<<<<< HEAD
  801ff1:	68 fc 00 00 00       	push   $0xfc
=======
  801ff1:	68 f7 00 00 00       	push   $0xf7
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  801ff6:	68 67 47 80 00       	push   $0x804767
  801ffb:	e8 01 e9 ff ff       	call   800901 <_panic>

00802000 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802000:	55                   	push   %ebp
  802001:	89 e5                	mov    %esp,%ebp
  802003:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()


	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802006:	83 ec 04             	sub    $0x4,%esp
  802009:	68 c0 47 80 00       	push   $0x8047c0
<<<<<<< HEAD
  80200e:	68 10 01 00 00       	push   $0x110
=======
  80200e:	68 0c 01 00 00       	push   $0x10c
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  802013:	68 67 47 80 00       	push   $0x804767
  802018:	e8 e4 e8 ff ff       	call   800901 <_panic>

0080201d <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80201d:	55                   	push   %ebp
  80201e:	89 e5                	mov    %esp,%ebp
  802020:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802023:	83 ec 04             	sub    $0x4,%esp
  802026:	68 e4 47 80 00       	push   $0x8047e4
<<<<<<< HEAD
  80202b:	68 1b 01 00 00       	push   $0x11b
=======
  80202b:	68 44 01 00 00       	push   $0x144
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  802030:	68 67 47 80 00       	push   $0x804767
  802035:	e8 c7 e8 ff ff       	call   800901 <_panic>

0080203a <shrink>:

}
void shrink(uint32 newSize)
{
  80203a:	55                   	push   %ebp
  80203b:	89 e5                	mov    %esp,%ebp
  80203d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802040:	83 ec 04             	sub    $0x4,%esp
  802043:	68 e4 47 80 00       	push   $0x8047e4
<<<<<<< HEAD
  802048:	68 20 01 00 00       	push   $0x120
=======
  802048:	68 49 01 00 00       	push   $0x149
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  80204d:	68 67 47 80 00       	push   $0x804767
  802052:	e8 aa e8 ff ff       	call   800901 <_panic>

00802057 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802057:	55                   	push   %ebp
  802058:	89 e5                	mov    %esp,%ebp
  80205a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80205d:	83 ec 04             	sub    $0x4,%esp
  802060:	68 e4 47 80 00       	push   $0x8047e4
<<<<<<< HEAD
  802065:	68 25 01 00 00       	push   $0x125
=======
  802065:	68 4e 01 00 00       	push   $0x14e
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  80206a:	68 67 47 80 00       	push   $0x804767
  80206f:	e8 8d e8 ff ff       	call   800901 <_panic>

00802074 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802074:	55                   	push   %ebp
  802075:	89 e5                	mov    %esp,%ebp
  802077:	57                   	push   %edi
  802078:	56                   	push   %esi
  802079:	53                   	push   %ebx
  80207a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80207d:	8b 45 08             	mov    0x8(%ebp),%eax
  802080:	8b 55 0c             	mov    0xc(%ebp),%edx
  802083:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802086:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802089:	8b 7d 18             	mov    0x18(%ebp),%edi
  80208c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80208f:	cd 30                	int    $0x30
  802091:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802094:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802097:	83 c4 10             	add    $0x10,%esp
  80209a:	5b                   	pop    %ebx
  80209b:	5e                   	pop    %esi
  80209c:	5f                   	pop    %edi
  80209d:	5d                   	pop    %ebp
  80209e:	c3                   	ret    

0080209f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80209f:	55                   	push   %ebp
  8020a0:	89 e5                	mov    %esp,%ebp
  8020a2:	83 ec 04             	sub    $0x4,%esp
  8020a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8020a8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8020ab:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8020af:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b2:	6a 00                	push   $0x0
  8020b4:	6a 00                	push   $0x0
  8020b6:	52                   	push   %edx
  8020b7:	ff 75 0c             	pushl  0xc(%ebp)
  8020ba:	50                   	push   %eax
  8020bb:	6a 00                	push   $0x0
  8020bd:	e8 b2 ff ff ff       	call   802074 <syscall>
  8020c2:	83 c4 18             	add    $0x18,%esp
}
  8020c5:	90                   	nop
  8020c6:	c9                   	leave  
  8020c7:	c3                   	ret    

008020c8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8020c8:	55                   	push   %ebp
  8020c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8020cb:	6a 00                	push   $0x0
  8020cd:	6a 00                	push   $0x0
  8020cf:	6a 00                	push   $0x0
  8020d1:	6a 00                	push   $0x0
  8020d3:	6a 00                	push   $0x0
  8020d5:	6a 01                	push   $0x1
  8020d7:	e8 98 ff ff ff       	call   802074 <syscall>
  8020dc:	83 c4 18             	add    $0x18,%esp
}
  8020df:	c9                   	leave  
  8020e0:	c3                   	ret    

008020e1 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8020e1:	55                   	push   %ebp
  8020e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8020e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ea:	6a 00                	push   $0x0
  8020ec:	6a 00                	push   $0x0
  8020ee:	6a 00                	push   $0x0
  8020f0:	52                   	push   %edx
  8020f1:	50                   	push   %eax
  8020f2:	6a 05                	push   $0x5
  8020f4:	e8 7b ff ff ff       	call   802074 <syscall>
  8020f9:	83 c4 18             	add    $0x18,%esp
}
  8020fc:	c9                   	leave  
  8020fd:	c3                   	ret    

008020fe <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8020fe:	55                   	push   %ebp
  8020ff:	89 e5                	mov    %esp,%ebp
  802101:	56                   	push   %esi
  802102:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802103:	8b 75 18             	mov    0x18(%ebp),%esi
  802106:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802109:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80210c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80210f:	8b 45 08             	mov    0x8(%ebp),%eax
  802112:	56                   	push   %esi
  802113:	53                   	push   %ebx
  802114:	51                   	push   %ecx
  802115:	52                   	push   %edx
  802116:	50                   	push   %eax
  802117:	6a 06                	push   $0x6
  802119:	e8 56 ff ff ff       	call   802074 <syscall>
  80211e:	83 c4 18             	add    $0x18,%esp
}
  802121:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802124:	5b                   	pop    %ebx
  802125:	5e                   	pop    %esi
  802126:	5d                   	pop    %ebp
  802127:	c3                   	ret    

00802128 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802128:	55                   	push   %ebp
  802129:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80212b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80212e:	8b 45 08             	mov    0x8(%ebp),%eax
  802131:	6a 00                	push   $0x0
  802133:	6a 00                	push   $0x0
  802135:	6a 00                	push   $0x0
  802137:	52                   	push   %edx
  802138:	50                   	push   %eax
  802139:	6a 07                	push   $0x7
  80213b:	e8 34 ff ff ff       	call   802074 <syscall>
  802140:	83 c4 18             	add    $0x18,%esp
}
  802143:	c9                   	leave  
  802144:	c3                   	ret    

00802145 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802145:	55                   	push   %ebp
  802146:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802148:	6a 00                	push   $0x0
  80214a:	6a 00                	push   $0x0
  80214c:	6a 00                	push   $0x0
  80214e:	ff 75 0c             	pushl  0xc(%ebp)
  802151:	ff 75 08             	pushl  0x8(%ebp)
  802154:	6a 08                	push   $0x8
  802156:	e8 19 ff ff ff       	call   802074 <syscall>
  80215b:	83 c4 18             	add    $0x18,%esp
}
  80215e:	c9                   	leave  
  80215f:	c3                   	ret    

00802160 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802160:	55                   	push   %ebp
  802161:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802163:	6a 00                	push   $0x0
  802165:	6a 00                	push   $0x0
  802167:	6a 00                	push   $0x0
  802169:	6a 00                	push   $0x0
  80216b:	6a 00                	push   $0x0
  80216d:	6a 09                	push   $0x9
  80216f:	e8 00 ff ff ff       	call   802074 <syscall>
  802174:	83 c4 18             	add    $0x18,%esp
}
  802177:	c9                   	leave  
  802178:	c3                   	ret    

00802179 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802179:	55                   	push   %ebp
  80217a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80217c:	6a 00                	push   $0x0
  80217e:	6a 00                	push   $0x0
  802180:	6a 00                	push   $0x0
  802182:	6a 00                	push   $0x0
  802184:	6a 00                	push   $0x0
  802186:	6a 0a                	push   $0xa
  802188:	e8 e7 fe ff ff       	call   802074 <syscall>
  80218d:	83 c4 18             	add    $0x18,%esp
}
  802190:	c9                   	leave  
  802191:	c3                   	ret    

00802192 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802192:	55                   	push   %ebp
  802193:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802195:	6a 00                	push   $0x0
  802197:	6a 00                	push   $0x0
  802199:	6a 00                	push   $0x0
  80219b:	6a 00                	push   $0x0
  80219d:	6a 00                	push   $0x0
  80219f:	6a 0b                	push   $0xb
  8021a1:	e8 ce fe ff ff       	call   802074 <syscall>
  8021a6:	83 c4 18             	add    $0x18,%esp
}
  8021a9:	c9                   	leave  
  8021aa:	c3                   	ret    

008021ab <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8021ab:	55                   	push   %ebp
  8021ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8021ae:	6a 00                	push   $0x0
  8021b0:	6a 00                	push   $0x0
  8021b2:	6a 00                	push   $0x0
  8021b4:	ff 75 0c             	pushl  0xc(%ebp)
  8021b7:	ff 75 08             	pushl  0x8(%ebp)
  8021ba:	6a 0f                	push   $0xf
  8021bc:	e8 b3 fe ff ff       	call   802074 <syscall>
  8021c1:	83 c4 18             	add    $0x18,%esp
	return;
  8021c4:	90                   	nop
}
  8021c5:	c9                   	leave  
  8021c6:	c3                   	ret    

008021c7 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8021c7:	55                   	push   %ebp
  8021c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8021ca:	6a 00                	push   $0x0
  8021cc:	6a 00                	push   $0x0
  8021ce:	6a 00                	push   $0x0
  8021d0:	ff 75 0c             	pushl  0xc(%ebp)
  8021d3:	ff 75 08             	pushl  0x8(%ebp)
  8021d6:	6a 10                	push   $0x10
  8021d8:	e8 97 fe ff ff       	call   802074 <syscall>
  8021dd:	83 c4 18             	add    $0x18,%esp
	return ;
  8021e0:	90                   	nop
}
  8021e1:	c9                   	leave  
  8021e2:	c3                   	ret    

008021e3 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8021e3:	55                   	push   %ebp
  8021e4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8021e6:	6a 00                	push   $0x0
  8021e8:	6a 00                	push   $0x0
  8021ea:	ff 75 10             	pushl  0x10(%ebp)
  8021ed:	ff 75 0c             	pushl  0xc(%ebp)
  8021f0:	ff 75 08             	pushl  0x8(%ebp)
  8021f3:	6a 11                	push   $0x11
  8021f5:	e8 7a fe ff ff       	call   802074 <syscall>
  8021fa:	83 c4 18             	add    $0x18,%esp
	return ;
  8021fd:	90                   	nop
}
  8021fe:	c9                   	leave  
  8021ff:	c3                   	ret    

00802200 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802200:	55                   	push   %ebp
  802201:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802203:	6a 00                	push   $0x0
  802205:	6a 00                	push   $0x0
  802207:	6a 00                	push   $0x0
  802209:	6a 00                	push   $0x0
  80220b:	6a 00                	push   $0x0
  80220d:	6a 0c                	push   $0xc
  80220f:	e8 60 fe ff ff       	call   802074 <syscall>
  802214:	83 c4 18             	add    $0x18,%esp
}
  802217:	c9                   	leave  
  802218:	c3                   	ret    

00802219 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802219:	55                   	push   %ebp
  80221a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80221c:	6a 00                	push   $0x0
  80221e:	6a 00                	push   $0x0
  802220:	6a 00                	push   $0x0
  802222:	6a 00                	push   $0x0
  802224:	ff 75 08             	pushl  0x8(%ebp)
  802227:	6a 0d                	push   $0xd
  802229:	e8 46 fe ff ff       	call   802074 <syscall>
  80222e:	83 c4 18             	add    $0x18,%esp
}
  802231:	c9                   	leave  
  802232:	c3                   	ret    

00802233 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802233:	55                   	push   %ebp
  802234:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802236:	6a 00                	push   $0x0
  802238:	6a 00                	push   $0x0
  80223a:	6a 00                	push   $0x0
  80223c:	6a 00                	push   $0x0
  80223e:	6a 00                	push   $0x0
  802240:	6a 0e                	push   $0xe
  802242:	e8 2d fe ff ff       	call   802074 <syscall>
  802247:	83 c4 18             	add    $0x18,%esp
}
  80224a:	90                   	nop
  80224b:	c9                   	leave  
  80224c:	c3                   	ret    

0080224d <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80224d:	55                   	push   %ebp
  80224e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802250:	6a 00                	push   $0x0
  802252:	6a 00                	push   $0x0
  802254:	6a 00                	push   $0x0
  802256:	6a 00                	push   $0x0
  802258:	6a 00                	push   $0x0
  80225a:	6a 13                	push   $0x13
  80225c:	e8 13 fe ff ff       	call   802074 <syscall>
  802261:	83 c4 18             	add    $0x18,%esp
}
  802264:	90                   	nop
  802265:	c9                   	leave  
  802266:	c3                   	ret    

00802267 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802267:	55                   	push   %ebp
  802268:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80226a:	6a 00                	push   $0x0
  80226c:	6a 00                	push   $0x0
  80226e:	6a 00                	push   $0x0
  802270:	6a 00                	push   $0x0
  802272:	6a 00                	push   $0x0
  802274:	6a 14                	push   $0x14
  802276:	e8 f9 fd ff ff       	call   802074 <syscall>
  80227b:	83 c4 18             	add    $0x18,%esp
}
  80227e:	90                   	nop
  80227f:	c9                   	leave  
  802280:	c3                   	ret    

00802281 <sys_cputc>:


void
sys_cputc(const char c)
{
  802281:	55                   	push   %ebp
  802282:	89 e5                	mov    %esp,%ebp
  802284:	83 ec 04             	sub    $0x4,%esp
  802287:	8b 45 08             	mov    0x8(%ebp),%eax
  80228a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80228d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802291:	6a 00                	push   $0x0
  802293:	6a 00                	push   $0x0
  802295:	6a 00                	push   $0x0
  802297:	6a 00                	push   $0x0
  802299:	50                   	push   %eax
  80229a:	6a 15                	push   $0x15
  80229c:	e8 d3 fd ff ff       	call   802074 <syscall>
  8022a1:	83 c4 18             	add    $0x18,%esp
}
  8022a4:	90                   	nop
  8022a5:	c9                   	leave  
  8022a6:	c3                   	ret    

008022a7 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8022a7:	55                   	push   %ebp
  8022a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8022aa:	6a 00                	push   $0x0
  8022ac:	6a 00                	push   $0x0
  8022ae:	6a 00                	push   $0x0
  8022b0:	6a 00                	push   $0x0
  8022b2:	6a 00                	push   $0x0
  8022b4:	6a 16                	push   $0x16
  8022b6:	e8 b9 fd ff ff       	call   802074 <syscall>
  8022bb:	83 c4 18             	add    $0x18,%esp
}
  8022be:	90                   	nop
  8022bf:	c9                   	leave  
  8022c0:	c3                   	ret    

008022c1 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8022c1:	55                   	push   %ebp
  8022c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8022c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c7:	6a 00                	push   $0x0
  8022c9:	6a 00                	push   $0x0
  8022cb:	6a 00                	push   $0x0
  8022cd:	ff 75 0c             	pushl  0xc(%ebp)
  8022d0:	50                   	push   %eax
  8022d1:	6a 17                	push   $0x17
  8022d3:	e8 9c fd ff ff       	call   802074 <syscall>
  8022d8:	83 c4 18             	add    $0x18,%esp
}
  8022db:	c9                   	leave  
  8022dc:	c3                   	ret    

008022dd <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8022dd:	55                   	push   %ebp
  8022de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e6:	6a 00                	push   $0x0
  8022e8:	6a 00                	push   $0x0
  8022ea:	6a 00                	push   $0x0
  8022ec:	52                   	push   %edx
  8022ed:	50                   	push   %eax
  8022ee:	6a 1a                	push   $0x1a
  8022f0:	e8 7f fd ff ff       	call   802074 <syscall>
  8022f5:	83 c4 18             	add    $0x18,%esp
}
  8022f8:	c9                   	leave  
  8022f9:	c3                   	ret    

008022fa <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8022fa:	55                   	push   %ebp
  8022fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802300:	8b 45 08             	mov    0x8(%ebp),%eax
  802303:	6a 00                	push   $0x0
  802305:	6a 00                	push   $0x0
  802307:	6a 00                	push   $0x0
  802309:	52                   	push   %edx
  80230a:	50                   	push   %eax
  80230b:	6a 18                	push   $0x18
  80230d:	e8 62 fd ff ff       	call   802074 <syscall>
  802312:	83 c4 18             	add    $0x18,%esp
}
  802315:	90                   	nop
  802316:	c9                   	leave  
  802317:	c3                   	ret    

00802318 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802318:	55                   	push   %ebp
  802319:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80231b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80231e:	8b 45 08             	mov    0x8(%ebp),%eax
  802321:	6a 00                	push   $0x0
  802323:	6a 00                	push   $0x0
  802325:	6a 00                	push   $0x0
  802327:	52                   	push   %edx
  802328:	50                   	push   %eax
  802329:	6a 19                	push   $0x19
  80232b:	e8 44 fd ff ff       	call   802074 <syscall>
  802330:	83 c4 18             	add    $0x18,%esp
}
  802333:	90                   	nop
  802334:	c9                   	leave  
  802335:	c3                   	ret    

00802336 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802336:	55                   	push   %ebp
  802337:	89 e5                	mov    %esp,%ebp
  802339:	83 ec 04             	sub    $0x4,%esp
  80233c:	8b 45 10             	mov    0x10(%ebp),%eax
  80233f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802342:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802345:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802349:	8b 45 08             	mov    0x8(%ebp),%eax
  80234c:	6a 00                	push   $0x0
  80234e:	51                   	push   %ecx
  80234f:	52                   	push   %edx
  802350:	ff 75 0c             	pushl  0xc(%ebp)
  802353:	50                   	push   %eax
  802354:	6a 1b                	push   $0x1b
  802356:	e8 19 fd ff ff       	call   802074 <syscall>
  80235b:	83 c4 18             	add    $0x18,%esp
}
  80235e:	c9                   	leave  
  80235f:	c3                   	ret    

00802360 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802360:	55                   	push   %ebp
  802361:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802363:	8b 55 0c             	mov    0xc(%ebp),%edx
  802366:	8b 45 08             	mov    0x8(%ebp),%eax
  802369:	6a 00                	push   $0x0
  80236b:	6a 00                	push   $0x0
  80236d:	6a 00                	push   $0x0
  80236f:	52                   	push   %edx
  802370:	50                   	push   %eax
  802371:	6a 1c                	push   $0x1c
  802373:	e8 fc fc ff ff       	call   802074 <syscall>
  802378:	83 c4 18             	add    $0x18,%esp
}
  80237b:	c9                   	leave  
  80237c:	c3                   	ret    

0080237d <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80237d:	55                   	push   %ebp
  80237e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802380:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802383:	8b 55 0c             	mov    0xc(%ebp),%edx
  802386:	8b 45 08             	mov    0x8(%ebp),%eax
  802389:	6a 00                	push   $0x0
  80238b:	6a 00                	push   $0x0
  80238d:	51                   	push   %ecx
  80238e:	52                   	push   %edx
  80238f:	50                   	push   %eax
  802390:	6a 1d                	push   $0x1d
  802392:	e8 dd fc ff ff       	call   802074 <syscall>
  802397:	83 c4 18             	add    $0x18,%esp
}
  80239a:	c9                   	leave  
  80239b:	c3                   	ret    

0080239c <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80239c:	55                   	push   %ebp
  80239d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80239f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a5:	6a 00                	push   $0x0
  8023a7:	6a 00                	push   $0x0
  8023a9:	6a 00                	push   $0x0
  8023ab:	52                   	push   %edx
  8023ac:	50                   	push   %eax
  8023ad:	6a 1e                	push   $0x1e
  8023af:	e8 c0 fc ff ff       	call   802074 <syscall>
  8023b4:	83 c4 18             	add    $0x18,%esp
}
  8023b7:	c9                   	leave  
  8023b8:	c3                   	ret    

008023b9 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8023b9:	55                   	push   %ebp
  8023ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8023bc:	6a 00                	push   $0x0
  8023be:	6a 00                	push   $0x0
  8023c0:	6a 00                	push   $0x0
  8023c2:	6a 00                	push   $0x0
  8023c4:	6a 00                	push   $0x0
  8023c6:	6a 1f                	push   $0x1f
  8023c8:	e8 a7 fc ff ff       	call   802074 <syscall>
  8023cd:	83 c4 18             	add    $0x18,%esp
}
  8023d0:	c9                   	leave  
  8023d1:	c3                   	ret    

008023d2 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8023d2:	55                   	push   %ebp
  8023d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8023d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d8:	6a 00                	push   $0x0
  8023da:	ff 75 14             	pushl  0x14(%ebp)
  8023dd:	ff 75 10             	pushl  0x10(%ebp)
  8023e0:	ff 75 0c             	pushl  0xc(%ebp)
  8023e3:	50                   	push   %eax
  8023e4:	6a 20                	push   $0x20
  8023e6:	e8 89 fc ff ff       	call   802074 <syscall>
  8023eb:	83 c4 18             	add    $0x18,%esp
}
  8023ee:	c9                   	leave  
  8023ef:	c3                   	ret    

008023f0 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8023f0:	55                   	push   %ebp
  8023f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8023f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f6:	6a 00                	push   $0x0
  8023f8:	6a 00                	push   $0x0
  8023fa:	6a 00                	push   $0x0
  8023fc:	6a 00                	push   $0x0
  8023fe:	50                   	push   %eax
  8023ff:	6a 21                	push   $0x21
  802401:	e8 6e fc ff ff       	call   802074 <syscall>
  802406:	83 c4 18             	add    $0x18,%esp
}
  802409:	90                   	nop
  80240a:	c9                   	leave  
  80240b:	c3                   	ret    

0080240c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80240c:	55                   	push   %ebp
  80240d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80240f:	8b 45 08             	mov    0x8(%ebp),%eax
  802412:	6a 00                	push   $0x0
  802414:	6a 00                	push   $0x0
  802416:	6a 00                	push   $0x0
  802418:	6a 00                	push   $0x0
  80241a:	50                   	push   %eax
  80241b:	6a 22                	push   $0x22
  80241d:	e8 52 fc ff ff       	call   802074 <syscall>
  802422:	83 c4 18             	add    $0x18,%esp
}
  802425:	c9                   	leave  
  802426:	c3                   	ret    

00802427 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802427:	55                   	push   %ebp
  802428:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80242a:	6a 00                	push   $0x0
  80242c:	6a 00                	push   $0x0
  80242e:	6a 00                	push   $0x0
  802430:	6a 00                	push   $0x0
  802432:	6a 00                	push   $0x0
  802434:	6a 02                	push   $0x2
  802436:	e8 39 fc ff ff       	call   802074 <syscall>
  80243b:	83 c4 18             	add    $0x18,%esp
}
  80243e:	c9                   	leave  
  80243f:	c3                   	ret    

00802440 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802440:	55                   	push   %ebp
  802441:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802443:	6a 00                	push   $0x0
  802445:	6a 00                	push   $0x0
  802447:	6a 00                	push   $0x0
  802449:	6a 00                	push   $0x0
  80244b:	6a 00                	push   $0x0
  80244d:	6a 03                	push   $0x3
  80244f:	e8 20 fc ff ff       	call   802074 <syscall>
  802454:	83 c4 18             	add    $0x18,%esp
}
  802457:	c9                   	leave  
  802458:	c3                   	ret    

00802459 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802459:	55                   	push   %ebp
  80245a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80245c:	6a 00                	push   $0x0
  80245e:	6a 00                	push   $0x0
  802460:	6a 00                	push   $0x0
  802462:	6a 00                	push   $0x0
  802464:	6a 00                	push   $0x0
  802466:	6a 04                	push   $0x4
  802468:	e8 07 fc ff ff       	call   802074 <syscall>
  80246d:	83 c4 18             	add    $0x18,%esp
}
  802470:	c9                   	leave  
  802471:	c3                   	ret    

00802472 <sys_exit_env>:


void sys_exit_env(void)
{
  802472:	55                   	push   %ebp
  802473:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802475:	6a 00                	push   $0x0
  802477:	6a 00                	push   $0x0
  802479:	6a 00                	push   $0x0
  80247b:	6a 00                	push   $0x0
  80247d:	6a 00                	push   $0x0
  80247f:	6a 23                	push   $0x23
  802481:	e8 ee fb ff ff       	call   802074 <syscall>
  802486:	83 c4 18             	add    $0x18,%esp
}
  802489:	90                   	nop
  80248a:	c9                   	leave  
  80248b:	c3                   	ret    

0080248c <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80248c:	55                   	push   %ebp
  80248d:	89 e5                	mov    %esp,%ebp
  80248f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802492:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802495:	8d 50 04             	lea    0x4(%eax),%edx
  802498:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80249b:	6a 00                	push   $0x0
  80249d:	6a 00                	push   $0x0
  80249f:	6a 00                	push   $0x0
  8024a1:	52                   	push   %edx
  8024a2:	50                   	push   %eax
  8024a3:	6a 24                	push   $0x24
  8024a5:	e8 ca fb ff ff       	call   802074 <syscall>
  8024aa:	83 c4 18             	add    $0x18,%esp
	return result;
  8024ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024b3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024b6:	89 01                	mov    %eax,(%ecx)
  8024b8:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8024bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024be:	c9                   	leave  
  8024bf:	c2 04 00             	ret    $0x4

008024c2 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8024c2:	55                   	push   %ebp
  8024c3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8024c5:	6a 00                	push   $0x0
  8024c7:	6a 00                	push   $0x0
  8024c9:	ff 75 10             	pushl  0x10(%ebp)
  8024cc:	ff 75 0c             	pushl  0xc(%ebp)
  8024cf:	ff 75 08             	pushl  0x8(%ebp)
  8024d2:	6a 12                	push   $0x12
  8024d4:	e8 9b fb ff ff       	call   802074 <syscall>
  8024d9:	83 c4 18             	add    $0x18,%esp
	return ;
  8024dc:	90                   	nop
}
  8024dd:	c9                   	leave  
  8024de:	c3                   	ret    

008024df <sys_rcr2>:
uint32 sys_rcr2()
{
  8024df:	55                   	push   %ebp
  8024e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8024e2:	6a 00                	push   $0x0
  8024e4:	6a 00                	push   $0x0
  8024e6:	6a 00                	push   $0x0
  8024e8:	6a 00                	push   $0x0
  8024ea:	6a 00                	push   $0x0
  8024ec:	6a 25                	push   $0x25
  8024ee:	e8 81 fb ff ff       	call   802074 <syscall>
  8024f3:	83 c4 18             	add    $0x18,%esp
}
  8024f6:	c9                   	leave  
  8024f7:	c3                   	ret    

008024f8 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8024f8:	55                   	push   %ebp
  8024f9:	89 e5                	mov    %esp,%ebp
  8024fb:	83 ec 04             	sub    $0x4,%esp
  8024fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802501:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802504:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802508:	6a 00                	push   $0x0
  80250a:	6a 00                	push   $0x0
  80250c:	6a 00                	push   $0x0
  80250e:	6a 00                	push   $0x0
  802510:	50                   	push   %eax
  802511:	6a 26                	push   $0x26
  802513:	e8 5c fb ff ff       	call   802074 <syscall>
  802518:	83 c4 18             	add    $0x18,%esp
	return ;
  80251b:	90                   	nop
}
  80251c:	c9                   	leave  
  80251d:	c3                   	ret    

0080251e <rsttst>:
void rsttst()
{
  80251e:	55                   	push   %ebp
  80251f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802521:	6a 00                	push   $0x0
  802523:	6a 00                	push   $0x0
  802525:	6a 00                	push   $0x0
  802527:	6a 00                	push   $0x0
  802529:	6a 00                	push   $0x0
  80252b:	6a 28                	push   $0x28
  80252d:	e8 42 fb ff ff       	call   802074 <syscall>
  802532:	83 c4 18             	add    $0x18,%esp
	return ;
  802535:	90                   	nop
}
  802536:	c9                   	leave  
  802537:	c3                   	ret    

00802538 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802538:	55                   	push   %ebp
  802539:	89 e5                	mov    %esp,%ebp
  80253b:	83 ec 04             	sub    $0x4,%esp
  80253e:	8b 45 14             	mov    0x14(%ebp),%eax
  802541:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802544:	8b 55 18             	mov    0x18(%ebp),%edx
  802547:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80254b:	52                   	push   %edx
  80254c:	50                   	push   %eax
  80254d:	ff 75 10             	pushl  0x10(%ebp)
  802550:	ff 75 0c             	pushl  0xc(%ebp)
  802553:	ff 75 08             	pushl  0x8(%ebp)
  802556:	6a 27                	push   $0x27
  802558:	e8 17 fb ff ff       	call   802074 <syscall>
  80255d:	83 c4 18             	add    $0x18,%esp
	return ;
  802560:	90                   	nop
}
  802561:	c9                   	leave  
  802562:	c3                   	ret    

00802563 <chktst>:
void chktst(uint32 n)
{
  802563:	55                   	push   %ebp
  802564:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802566:	6a 00                	push   $0x0
  802568:	6a 00                	push   $0x0
  80256a:	6a 00                	push   $0x0
  80256c:	6a 00                	push   $0x0
  80256e:	ff 75 08             	pushl  0x8(%ebp)
  802571:	6a 29                	push   $0x29
  802573:	e8 fc fa ff ff       	call   802074 <syscall>
  802578:	83 c4 18             	add    $0x18,%esp
	return ;
  80257b:	90                   	nop
}
  80257c:	c9                   	leave  
  80257d:	c3                   	ret    

0080257e <inctst>:

void inctst()
{
  80257e:	55                   	push   %ebp
  80257f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802581:	6a 00                	push   $0x0
  802583:	6a 00                	push   $0x0
  802585:	6a 00                	push   $0x0
  802587:	6a 00                	push   $0x0
  802589:	6a 00                	push   $0x0
  80258b:	6a 2a                	push   $0x2a
  80258d:	e8 e2 fa ff ff       	call   802074 <syscall>
  802592:	83 c4 18             	add    $0x18,%esp
	return ;
  802595:	90                   	nop
}
  802596:	c9                   	leave  
  802597:	c3                   	ret    

00802598 <gettst>:
uint32 gettst()
{
  802598:	55                   	push   %ebp
  802599:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80259b:	6a 00                	push   $0x0
  80259d:	6a 00                	push   $0x0
  80259f:	6a 00                	push   $0x0
  8025a1:	6a 00                	push   $0x0
  8025a3:	6a 00                	push   $0x0
  8025a5:	6a 2b                	push   $0x2b
  8025a7:	e8 c8 fa ff ff       	call   802074 <syscall>
  8025ac:	83 c4 18             	add    $0x18,%esp
}
  8025af:	c9                   	leave  
  8025b0:	c3                   	ret    

008025b1 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8025b1:	55                   	push   %ebp
  8025b2:	89 e5                	mov    %esp,%ebp
  8025b4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025b7:	6a 00                	push   $0x0
  8025b9:	6a 00                	push   $0x0
  8025bb:	6a 00                	push   $0x0
  8025bd:	6a 00                	push   $0x0
  8025bf:	6a 00                	push   $0x0
  8025c1:	6a 2c                	push   $0x2c
  8025c3:	e8 ac fa ff ff       	call   802074 <syscall>
  8025c8:	83 c4 18             	add    $0x18,%esp
  8025cb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8025ce:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8025d2:	75 07                	jne    8025db <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8025d4:	b8 01 00 00 00       	mov    $0x1,%eax
  8025d9:	eb 05                	jmp    8025e0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8025db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025e0:	c9                   	leave  
  8025e1:	c3                   	ret    

008025e2 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8025e2:	55                   	push   %ebp
  8025e3:	89 e5                	mov    %esp,%ebp
  8025e5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025e8:	6a 00                	push   $0x0
  8025ea:	6a 00                	push   $0x0
  8025ec:	6a 00                	push   $0x0
  8025ee:	6a 00                	push   $0x0
  8025f0:	6a 00                	push   $0x0
  8025f2:	6a 2c                	push   $0x2c
  8025f4:	e8 7b fa ff ff       	call   802074 <syscall>
  8025f9:	83 c4 18             	add    $0x18,%esp
  8025fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8025ff:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802603:	75 07                	jne    80260c <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802605:	b8 01 00 00 00       	mov    $0x1,%eax
  80260a:	eb 05                	jmp    802611 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80260c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802611:	c9                   	leave  
  802612:	c3                   	ret    

00802613 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802613:	55                   	push   %ebp
  802614:	89 e5                	mov    %esp,%ebp
  802616:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802619:	6a 00                	push   $0x0
  80261b:	6a 00                	push   $0x0
  80261d:	6a 00                	push   $0x0
  80261f:	6a 00                	push   $0x0
  802621:	6a 00                	push   $0x0
  802623:	6a 2c                	push   $0x2c
  802625:	e8 4a fa ff ff       	call   802074 <syscall>
  80262a:	83 c4 18             	add    $0x18,%esp
  80262d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802630:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802634:	75 07                	jne    80263d <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802636:	b8 01 00 00 00       	mov    $0x1,%eax
  80263b:	eb 05                	jmp    802642 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80263d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802642:	c9                   	leave  
  802643:	c3                   	ret    

00802644 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802644:	55                   	push   %ebp
  802645:	89 e5                	mov    %esp,%ebp
  802647:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80264a:	6a 00                	push   $0x0
  80264c:	6a 00                	push   $0x0
  80264e:	6a 00                	push   $0x0
  802650:	6a 00                	push   $0x0
  802652:	6a 00                	push   $0x0
  802654:	6a 2c                	push   $0x2c
  802656:	e8 19 fa ff ff       	call   802074 <syscall>
  80265b:	83 c4 18             	add    $0x18,%esp
  80265e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802661:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802665:	75 07                	jne    80266e <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802667:	b8 01 00 00 00       	mov    $0x1,%eax
  80266c:	eb 05                	jmp    802673 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80266e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802673:	c9                   	leave  
  802674:	c3                   	ret    

00802675 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802675:	55                   	push   %ebp
  802676:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802678:	6a 00                	push   $0x0
  80267a:	6a 00                	push   $0x0
  80267c:	6a 00                	push   $0x0
  80267e:	6a 00                	push   $0x0
  802680:	ff 75 08             	pushl  0x8(%ebp)
  802683:	6a 2d                	push   $0x2d
  802685:	e8 ea f9 ff ff       	call   802074 <syscall>
  80268a:	83 c4 18             	add    $0x18,%esp
	return ;
  80268d:	90                   	nop
}
  80268e:	c9                   	leave  
  80268f:	c3                   	ret    

00802690 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802690:	55                   	push   %ebp
  802691:	89 e5                	mov    %esp,%ebp
  802693:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802694:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802697:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80269a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80269d:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a0:	6a 00                	push   $0x0
  8026a2:	53                   	push   %ebx
  8026a3:	51                   	push   %ecx
  8026a4:	52                   	push   %edx
  8026a5:	50                   	push   %eax
  8026a6:	6a 2e                	push   $0x2e
  8026a8:	e8 c7 f9 ff ff       	call   802074 <syscall>
  8026ad:	83 c4 18             	add    $0x18,%esp
}
  8026b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8026b3:	c9                   	leave  
  8026b4:	c3                   	ret    

008026b5 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8026b5:	55                   	push   %ebp
  8026b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8026b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8026be:	6a 00                	push   $0x0
  8026c0:	6a 00                	push   $0x0
  8026c2:	6a 00                	push   $0x0
  8026c4:	52                   	push   %edx
  8026c5:	50                   	push   %eax
  8026c6:	6a 2f                	push   $0x2f
  8026c8:	e8 a7 f9 ff ff       	call   802074 <syscall>
  8026cd:	83 c4 18             	add    $0x18,%esp
}
  8026d0:	c9                   	leave  
  8026d1:	c3                   	ret    

008026d2 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8026d2:	55                   	push   %ebp
  8026d3:	89 e5                	mov    %esp,%ebp
  8026d5:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8026d8:	83 ec 0c             	sub    $0xc,%esp
  8026db:	68 f4 47 80 00       	push   $0x8047f4
  8026e0:	e8 d0 e4 ff ff       	call   800bb5 <cprintf>
  8026e5:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8026e8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8026ef:	83 ec 0c             	sub    $0xc,%esp
  8026f2:	68 20 48 80 00       	push   $0x804820
  8026f7:	e8 b9 e4 ff ff       	call   800bb5 <cprintf>
  8026fc:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8026ff:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802703:	a1 38 51 80 00       	mov    0x805138,%eax
  802708:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80270b:	eb 56                	jmp    802763 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80270d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802711:	74 1c                	je     80272f <print_mem_block_lists+0x5d>
  802713:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802716:	8b 50 08             	mov    0x8(%eax),%edx
  802719:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80271c:	8b 48 08             	mov    0x8(%eax),%ecx
  80271f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802722:	8b 40 0c             	mov    0xc(%eax),%eax
  802725:	01 c8                	add    %ecx,%eax
  802727:	39 c2                	cmp    %eax,%edx
  802729:	73 04                	jae    80272f <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80272b:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80272f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802732:	8b 50 08             	mov    0x8(%eax),%edx
  802735:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802738:	8b 40 0c             	mov    0xc(%eax),%eax
  80273b:	01 c2                	add    %eax,%edx
  80273d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802740:	8b 40 08             	mov    0x8(%eax),%eax
  802743:	83 ec 04             	sub    $0x4,%esp
  802746:	52                   	push   %edx
  802747:	50                   	push   %eax
  802748:	68 35 48 80 00       	push   $0x804835
  80274d:	e8 63 e4 ff ff       	call   800bb5 <cprintf>
  802752:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802755:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802758:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80275b:	a1 40 51 80 00       	mov    0x805140,%eax
  802760:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802763:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802767:	74 07                	je     802770 <print_mem_block_lists+0x9e>
  802769:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276c:	8b 00                	mov    (%eax),%eax
  80276e:	eb 05                	jmp    802775 <print_mem_block_lists+0xa3>
  802770:	b8 00 00 00 00       	mov    $0x0,%eax
  802775:	a3 40 51 80 00       	mov    %eax,0x805140
  80277a:	a1 40 51 80 00       	mov    0x805140,%eax
  80277f:	85 c0                	test   %eax,%eax
  802781:	75 8a                	jne    80270d <print_mem_block_lists+0x3b>
  802783:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802787:	75 84                	jne    80270d <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802789:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80278d:	75 10                	jne    80279f <print_mem_block_lists+0xcd>
  80278f:	83 ec 0c             	sub    $0xc,%esp
  802792:	68 44 48 80 00       	push   $0x804844
  802797:	e8 19 e4 ff ff       	call   800bb5 <cprintf>
  80279c:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80279f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8027a6:	83 ec 0c             	sub    $0xc,%esp
  8027a9:	68 68 48 80 00       	push   $0x804868
  8027ae:	e8 02 e4 ff ff       	call   800bb5 <cprintf>
  8027b3:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8027b6:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8027ba:	a1 40 50 80 00       	mov    0x805040,%eax
  8027bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027c2:	eb 56                	jmp    80281a <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8027c4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027c8:	74 1c                	je     8027e6 <print_mem_block_lists+0x114>
  8027ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cd:	8b 50 08             	mov    0x8(%eax),%edx
  8027d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d3:	8b 48 08             	mov    0x8(%eax),%ecx
  8027d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8027dc:	01 c8                	add    %ecx,%eax
  8027de:	39 c2                	cmp    %eax,%edx
  8027e0:	73 04                	jae    8027e6 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8027e2:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8027e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e9:	8b 50 08             	mov    0x8(%eax),%edx
  8027ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8027f2:	01 c2                	add    %eax,%edx
  8027f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f7:	8b 40 08             	mov    0x8(%eax),%eax
  8027fa:	83 ec 04             	sub    $0x4,%esp
  8027fd:	52                   	push   %edx
  8027fe:	50                   	push   %eax
  8027ff:	68 35 48 80 00       	push   $0x804835
  802804:	e8 ac e3 ff ff       	call   800bb5 <cprintf>
  802809:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80280c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802812:	a1 48 50 80 00       	mov    0x805048,%eax
  802817:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80281a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80281e:	74 07                	je     802827 <print_mem_block_lists+0x155>
  802820:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802823:	8b 00                	mov    (%eax),%eax
  802825:	eb 05                	jmp    80282c <print_mem_block_lists+0x15a>
  802827:	b8 00 00 00 00       	mov    $0x0,%eax
  80282c:	a3 48 50 80 00       	mov    %eax,0x805048
  802831:	a1 48 50 80 00       	mov    0x805048,%eax
  802836:	85 c0                	test   %eax,%eax
  802838:	75 8a                	jne    8027c4 <print_mem_block_lists+0xf2>
  80283a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80283e:	75 84                	jne    8027c4 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802840:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802844:	75 10                	jne    802856 <print_mem_block_lists+0x184>
  802846:	83 ec 0c             	sub    $0xc,%esp
  802849:	68 80 48 80 00       	push   $0x804880
  80284e:	e8 62 e3 ff ff       	call   800bb5 <cprintf>
  802853:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802856:	83 ec 0c             	sub    $0xc,%esp
  802859:	68 f4 47 80 00       	push   $0x8047f4
  80285e:	e8 52 e3 ff ff       	call   800bb5 <cprintf>
  802863:	83 c4 10             	add    $0x10,%esp

}
  802866:	90                   	nop
  802867:	c9                   	leave  
  802868:	c3                   	ret    

00802869 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802869:	55                   	push   %ebp
  80286a:	89 e5                	mov    %esp,%ebp
  80286c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  80286f:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802876:	00 00 00 
  802879:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802880:	00 00 00 
  802883:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80288a:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  80288d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802894:	e9 9e 00 00 00       	jmp    802937 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802899:	a1 50 50 80 00       	mov    0x805050,%eax
  80289e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028a1:	c1 e2 04             	shl    $0x4,%edx
  8028a4:	01 d0                	add    %edx,%eax
  8028a6:	85 c0                	test   %eax,%eax
  8028a8:	75 14                	jne    8028be <initialize_MemBlocksList+0x55>
  8028aa:	83 ec 04             	sub    $0x4,%esp
  8028ad:	68 a8 48 80 00       	push   $0x8048a8
  8028b2:	6a 46                	push   $0x46
  8028b4:	68 cb 48 80 00       	push   $0x8048cb
  8028b9:	e8 43 e0 ff ff       	call   800901 <_panic>
  8028be:	a1 50 50 80 00       	mov    0x805050,%eax
  8028c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028c6:	c1 e2 04             	shl    $0x4,%edx
  8028c9:	01 d0                	add    %edx,%eax
  8028cb:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8028d1:	89 10                	mov    %edx,(%eax)
  8028d3:	8b 00                	mov    (%eax),%eax
  8028d5:	85 c0                	test   %eax,%eax
  8028d7:	74 18                	je     8028f1 <initialize_MemBlocksList+0x88>
  8028d9:	a1 48 51 80 00       	mov    0x805148,%eax
  8028de:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8028e4:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8028e7:	c1 e1 04             	shl    $0x4,%ecx
  8028ea:	01 ca                	add    %ecx,%edx
  8028ec:	89 50 04             	mov    %edx,0x4(%eax)
  8028ef:	eb 12                	jmp    802903 <initialize_MemBlocksList+0x9a>
  8028f1:	a1 50 50 80 00       	mov    0x805050,%eax
  8028f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028f9:	c1 e2 04             	shl    $0x4,%edx
  8028fc:	01 d0                	add    %edx,%eax
  8028fe:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802903:	a1 50 50 80 00       	mov    0x805050,%eax
  802908:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80290b:	c1 e2 04             	shl    $0x4,%edx
  80290e:	01 d0                	add    %edx,%eax
  802910:	a3 48 51 80 00       	mov    %eax,0x805148
  802915:	a1 50 50 80 00       	mov    0x805050,%eax
  80291a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80291d:	c1 e2 04             	shl    $0x4,%edx
  802920:	01 d0                	add    %edx,%eax
  802922:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802929:	a1 54 51 80 00       	mov    0x805154,%eax
  80292e:	40                   	inc    %eax
  80292f:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802934:	ff 45 f4             	incl   -0xc(%ebp)
  802937:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80293d:	0f 82 56 ff ff ff    	jb     802899 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802943:	90                   	nop
  802944:	c9                   	leave  
  802945:	c3                   	ret    

00802946 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802946:	55                   	push   %ebp
  802947:	89 e5                	mov    %esp,%ebp
  802949:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80294c:	8b 45 08             	mov    0x8(%ebp),%eax
  80294f:	8b 00                	mov    (%eax),%eax
  802951:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802954:	eb 19                	jmp    80296f <find_block+0x29>
	{
		if(va==point->sva)
  802956:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802959:	8b 40 08             	mov    0x8(%eax),%eax
  80295c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80295f:	75 05                	jne    802966 <find_block+0x20>
		   return point;
  802961:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802964:	eb 36                	jmp    80299c <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802966:	8b 45 08             	mov    0x8(%ebp),%eax
  802969:	8b 40 08             	mov    0x8(%eax),%eax
  80296c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80296f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802973:	74 07                	je     80297c <find_block+0x36>
  802975:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802978:	8b 00                	mov    (%eax),%eax
  80297a:	eb 05                	jmp    802981 <find_block+0x3b>
  80297c:	b8 00 00 00 00       	mov    $0x0,%eax
  802981:	8b 55 08             	mov    0x8(%ebp),%edx
  802984:	89 42 08             	mov    %eax,0x8(%edx)
  802987:	8b 45 08             	mov    0x8(%ebp),%eax
  80298a:	8b 40 08             	mov    0x8(%eax),%eax
  80298d:	85 c0                	test   %eax,%eax
  80298f:	75 c5                	jne    802956 <find_block+0x10>
  802991:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802995:	75 bf                	jne    802956 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802997:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80299c:	c9                   	leave  
  80299d:	c3                   	ret    

0080299e <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80299e:	55                   	push   %ebp
  80299f:	89 e5                	mov    %esp,%ebp
  8029a1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8029a4:	a1 40 50 80 00       	mov    0x805040,%eax
  8029a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8029ac:	a1 44 50 80 00       	mov    0x805044,%eax
  8029b1:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8029b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8029ba:	74 24                	je     8029e0 <insert_sorted_allocList+0x42>
  8029bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bf:	8b 50 08             	mov    0x8(%eax),%edx
  8029c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c5:	8b 40 08             	mov    0x8(%eax),%eax
  8029c8:	39 c2                	cmp    %eax,%edx
  8029ca:	76 14                	jbe    8029e0 <insert_sorted_allocList+0x42>
  8029cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cf:	8b 50 08             	mov    0x8(%eax),%edx
  8029d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029d5:	8b 40 08             	mov    0x8(%eax),%eax
  8029d8:	39 c2                	cmp    %eax,%edx
  8029da:	0f 82 60 01 00 00    	jb     802b40 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8029e0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029e4:	75 65                	jne    802a4b <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8029e6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029ea:	75 14                	jne    802a00 <insert_sorted_allocList+0x62>
  8029ec:	83 ec 04             	sub    $0x4,%esp
  8029ef:	68 a8 48 80 00       	push   $0x8048a8
  8029f4:	6a 6b                	push   $0x6b
  8029f6:	68 cb 48 80 00       	push   $0x8048cb
  8029fb:	e8 01 df ff ff       	call   800901 <_panic>
  802a00:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802a06:	8b 45 08             	mov    0x8(%ebp),%eax
  802a09:	89 10                	mov    %edx,(%eax)
  802a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0e:	8b 00                	mov    (%eax),%eax
  802a10:	85 c0                	test   %eax,%eax
  802a12:	74 0d                	je     802a21 <insert_sorted_allocList+0x83>
  802a14:	a1 40 50 80 00       	mov    0x805040,%eax
  802a19:	8b 55 08             	mov    0x8(%ebp),%edx
  802a1c:	89 50 04             	mov    %edx,0x4(%eax)
  802a1f:	eb 08                	jmp    802a29 <insert_sorted_allocList+0x8b>
  802a21:	8b 45 08             	mov    0x8(%ebp),%eax
  802a24:	a3 44 50 80 00       	mov    %eax,0x805044
  802a29:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2c:	a3 40 50 80 00       	mov    %eax,0x805040
  802a31:	8b 45 08             	mov    0x8(%ebp),%eax
  802a34:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a3b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a40:	40                   	inc    %eax
  802a41:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802a46:	e9 dc 01 00 00       	jmp    802c27 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4e:	8b 50 08             	mov    0x8(%eax),%edx
  802a51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a54:	8b 40 08             	mov    0x8(%eax),%eax
  802a57:	39 c2                	cmp    %eax,%edx
  802a59:	77 6c                	ja     802ac7 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802a5b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a5f:	74 06                	je     802a67 <insert_sorted_allocList+0xc9>
  802a61:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a65:	75 14                	jne    802a7b <insert_sorted_allocList+0xdd>
  802a67:	83 ec 04             	sub    $0x4,%esp
  802a6a:	68 e4 48 80 00       	push   $0x8048e4
  802a6f:	6a 6f                	push   $0x6f
  802a71:	68 cb 48 80 00       	push   $0x8048cb
  802a76:	e8 86 de ff ff       	call   800901 <_panic>
  802a7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a7e:	8b 50 04             	mov    0x4(%eax),%edx
  802a81:	8b 45 08             	mov    0x8(%ebp),%eax
  802a84:	89 50 04             	mov    %edx,0x4(%eax)
  802a87:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a8d:	89 10                	mov    %edx,(%eax)
  802a8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a92:	8b 40 04             	mov    0x4(%eax),%eax
  802a95:	85 c0                	test   %eax,%eax
  802a97:	74 0d                	je     802aa6 <insert_sorted_allocList+0x108>
  802a99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a9c:	8b 40 04             	mov    0x4(%eax),%eax
  802a9f:	8b 55 08             	mov    0x8(%ebp),%edx
  802aa2:	89 10                	mov    %edx,(%eax)
  802aa4:	eb 08                	jmp    802aae <insert_sorted_allocList+0x110>
  802aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa9:	a3 40 50 80 00       	mov    %eax,0x805040
  802aae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab1:	8b 55 08             	mov    0x8(%ebp),%edx
  802ab4:	89 50 04             	mov    %edx,0x4(%eax)
  802ab7:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802abc:	40                   	inc    %eax
  802abd:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802ac2:	e9 60 01 00 00       	jmp    802c27 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aca:	8b 50 08             	mov    0x8(%eax),%edx
  802acd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ad0:	8b 40 08             	mov    0x8(%eax),%eax
  802ad3:	39 c2                	cmp    %eax,%edx
  802ad5:	0f 82 4c 01 00 00    	jb     802c27 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802adb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802adf:	75 14                	jne    802af5 <insert_sorted_allocList+0x157>
  802ae1:	83 ec 04             	sub    $0x4,%esp
  802ae4:	68 1c 49 80 00       	push   $0x80491c
  802ae9:	6a 73                	push   $0x73
  802aeb:	68 cb 48 80 00       	push   $0x8048cb
  802af0:	e8 0c de ff ff       	call   800901 <_panic>
  802af5:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802afb:	8b 45 08             	mov    0x8(%ebp),%eax
  802afe:	89 50 04             	mov    %edx,0x4(%eax)
  802b01:	8b 45 08             	mov    0x8(%ebp),%eax
  802b04:	8b 40 04             	mov    0x4(%eax),%eax
  802b07:	85 c0                	test   %eax,%eax
  802b09:	74 0c                	je     802b17 <insert_sorted_allocList+0x179>
  802b0b:	a1 44 50 80 00       	mov    0x805044,%eax
  802b10:	8b 55 08             	mov    0x8(%ebp),%edx
  802b13:	89 10                	mov    %edx,(%eax)
  802b15:	eb 08                	jmp    802b1f <insert_sorted_allocList+0x181>
  802b17:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1a:	a3 40 50 80 00       	mov    %eax,0x805040
  802b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b22:	a3 44 50 80 00       	mov    %eax,0x805044
  802b27:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b30:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b35:	40                   	inc    %eax
  802b36:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802b3b:	e9 e7 00 00 00       	jmp    802c27 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802b40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b43:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802b46:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802b4d:	a1 40 50 80 00       	mov    0x805040,%eax
  802b52:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b55:	e9 9d 00 00 00       	jmp    802bf7 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5d:	8b 00                	mov    (%eax),%eax
  802b5f:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802b62:	8b 45 08             	mov    0x8(%ebp),%eax
  802b65:	8b 50 08             	mov    0x8(%eax),%edx
  802b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6b:	8b 40 08             	mov    0x8(%eax),%eax
  802b6e:	39 c2                	cmp    %eax,%edx
  802b70:	76 7d                	jbe    802bef <insert_sorted_allocList+0x251>
  802b72:	8b 45 08             	mov    0x8(%ebp),%eax
  802b75:	8b 50 08             	mov    0x8(%eax),%edx
  802b78:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b7b:	8b 40 08             	mov    0x8(%eax),%eax
  802b7e:	39 c2                	cmp    %eax,%edx
  802b80:	73 6d                	jae    802bef <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802b82:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b86:	74 06                	je     802b8e <insert_sorted_allocList+0x1f0>
  802b88:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b8c:	75 14                	jne    802ba2 <insert_sorted_allocList+0x204>
  802b8e:	83 ec 04             	sub    $0x4,%esp
  802b91:	68 40 49 80 00       	push   $0x804940
  802b96:	6a 7f                	push   $0x7f
  802b98:	68 cb 48 80 00       	push   $0x8048cb
  802b9d:	e8 5f dd ff ff       	call   800901 <_panic>
  802ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba5:	8b 10                	mov    (%eax),%edx
  802ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  802baa:	89 10                	mov    %edx,(%eax)
  802bac:	8b 45 08             	mov    0x8(%ebp),%eax
  802baf:	8b 00                	mov    (%eax),%eax
  802bb1:	85 c0                	test   %eax,%eax
  802bb3:	74 0b                	je     802bc0 <insert_sorted_allocList+0x222>
  802bb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb8:	8b 00                	mov    (%eax),%eax
  802bba:	8b 55 08             	mov    0x8(%ebp),%edx
  802bbd:	89 50 04             	mov    %edx,0x4(%eax)
  802bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc3:	8b 55 08             	mov    0x8(%ebp),%edx
  802bc6:	89 10                	mov    %edx,(%eax)
  802bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bce:	89 50 04             	mov    %edx,0x4(%eax)
  802bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd4:	8b 00                	mov    (%eax),%eax
  802bd6:	85 c0                	test   %eax,%eax
  802bd8:	75 08                	jne    802be2 <insert_sorted_allocList+0x244>
  802bda:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdd:	a3 44 50 80 00       	mov    %eax,0x805044
  802be2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802be7:	40                   	inc    %eax
  802be8:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802bed:	eb 39                	jmp    802c28 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802bef:	a1 48 50 80 00       	mov    0x805048,%eax
  802bf4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bf7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bfb:	74 07                	je     802c04 <insert_sorted_allocList+0x266>
  802bfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c00:	8b 00                	mov    (%eax),%eax
  802c02:	eb 05                	jmp    802c09 <insert_sorted_allocList+0x26b>
  802c04:	b8 00 00 00 00       	mov    $0x0,%eax
  802c09:	a3 48 50 80 00       	mov    %eax,0x805048
  802c0e:	a1 48 50 80 00       	mov    0x805048,%eax
  802c13:	85 c0                	test   %eax,%eax
  802c15:	0f 85 3f ff ff ff    	jne    802b5a <insert_sorted_allocList+0x1bc>
  802c1b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c1f:	0f 85 35 ff ff ff    	jne    802b5a <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802c25:	eb 01                	jmp    802c28 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802c27:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802c28:	90                   	nop
  802c29:	c9                   	leave  
  802c2a:	c3                   	ret    

00802c2b <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802c2b:	55                   	push   %ebp
  802c2c:	89 e5                	mov    %esp,%ebp
  802c2e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802c31:	a1 38 51 80 00       	mov    0x805138,%eax
  802c36:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c39:	e9 85 01 00 00       	jmp    802dc3 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c41:	8b 40 0c             	mov    0xc(%eax),%eax
  802c44:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c47:	0f 82 6e 01 00 00    	jb     802dbb <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802c4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c50:	8b 40 0c             	mov    0xc(%eax),%eax
  802c53:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c56:	0f 85 8a 00 00 00    	jne    802ce6 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802c5c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c60:	75 17                	jne    802c79 <alloc_block_FF+0x4e>
  802c62:	83 ec 04             	sub    $0x4,%esp
  802c65:	68 74 49 80 00       	push   $0x804974
  802c6a:	68 93 00 00 00       	push   $0x93
  802c6f:	68 cb 48 80 00       	push   $0x8048cb
  802c74:	e8 88 dc ff ff       	call   800901 <_panic>
  802c79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7c:	8b 00                	mov    (%eax),%eax
  802c7e:	85 c0                	test   %eax,%eax
  802c80:	74 10                	je     802c92 <alloc_block_FF+0x67>
  802c82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c85:	8b 00                	mov    (%eax),%eax
  802c87:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c8a:	8b 52 04             	mov    0x4(%edx),%edx
  802c8d:	89 50 04             	mov    %edx,0x4(%eax)
  802c90:	eb 0b                	jmp    802c9d <alloc_block_FF+0x72>
  802c92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c95:	8b 40 04             	mov    0x4(%eax),%eax
  802c98:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca0:	8b 40 04             	mov    0x4(%eax),%eax
  802ca3:	85 c0                	test   %eax,%eax
  802ca5:	74 0f                	je     802cb6 <alloc_block_FF+0x8b>
  802ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802caa:	8b 40 04             	mov    0x4(%eax),%eax
  802cad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cb0:	8b 12                	mov    (%edx),%edx
  802cb2:	89 10                	mov    %edx,(%eax)
  802cb4:	eb 0a                	jmp    802cc0 <alloc_block_FF+0x95>
  802cb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb9:	8b 00                	mov    (%eax),%eax
  802cbb:	a3 38 51 80 00       	mov    %eax,0x805138
  802cc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cd3:	a1 44 51 80 00       	mov    0x805144,%eax
  802cd8:	48                   	dec    %eax
  802cd9:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802cde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce1:	e9 10 01 00 00       	jmp    802df6 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802ce6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce9:	8b 40 0c             	mov    0xc(%eax),%eax
  802cec:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cef:	0f 86 c6 00 00 00    	jbe    802dbb <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802cf5:	a1 48 51 80 00       	mov    0x805148,%eax
  802cfa:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802cfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d00:	8b 50 08             	mov    0x8(%eax),%edx
  802d03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d06:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802d09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d0c:	8b 55 08             	mov    0x8(%ebp),%edx
  802d0f:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802d12:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d16:	75 17                	jne    802d2f <alloc_block_FF+0x104>
  802d18:	83 ec 04             	sub    $0x4,%esp
  802d1b:	68 74 49 80 00       	push   $0x804974
  802d20:	68 9b 00 00 00       	push   $0x9b
  802d25:	68 cb 48 80 00       	push   $0x8048cb
  802d2a:	e8 d2 db ff ff       	call   800901 <_panic>
  802d2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d32:	8b 00                	mov    (%eax),%eax
  802d34:	85 c0                	test   %eax,%eax
  802d36:	74 10                	je     802d48 <alloc_block_FF+0x11d>
  802d38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d3b:	8b 00                	mov    (%eax),%eax
  802d3d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d40:	8b 52 04             	mov    0x4(%edx),%edx
  802d43:	89 50 04             	mov    %edx,0x4(%eax)
  802d46:	eb 0b                	jmp    802d53 <alloc_block_FF+0x128>
  802d48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4b:	8b 40 04             	mov    0x4(%eax),%eax
  802d4e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d56:	8b 40 04             	mov    0x4(%eax),%eax
  802d59:	85 c0                	test   %eax,%eax
  802d5b:	74 0f                	je     802d6c <alloc_block_FF+0x141>
  802d5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d60:	8b 40 04             	mov    0x4(%eax),%eax
  802d63:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d66:	8b 12                	mov    (%edx),%edx
  802d68:	89 10                	mov    %edx,(%eax)
  802d6a:	eb 0a                	jmp    802d76 <alloc_block_FF+0x14b>
  802d6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d6f:	8b 00                	mov    (%eax),%eax
  802d71:	a3 48 51 80 00       	mov    %eax,0x805148
  802d76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d79:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d82:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d89:	a1 54 51 80 00       	mov    0x805154,%eax
  802d8e:	48                   	dec    %eax
  802d8f:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802d94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d97:	8b 50 08             	mov    0x8(%eax),%edx
  802d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9d:	01 c2                	add    %eax,%edx
  802d9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da2:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802da5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da8:	8b 40 0c             	mov    0xc(%eax),%eax
  802dab:	2b 45 08             	sub    0x8(%ebp),%eax
  802dae:	89 c2                	mov    %eax,%edx
  802db0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db3:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802db6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db9:	eb 3b                	jmp    802df6 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802dbb:	a1 40 51 80 00       	mov    0x805140,%eax
  802dc0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dc3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dc7:	74 07                	je     802dd0 <alloc_block_FF+0x1a5>
  802dc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcc:	8b 00                	mov    (%eax),%eax
  802dce:	eb 05                	jmp    802dd5 <alloc_block_FF+0x1aa>
  802dd0:	b8 00 00 00 00       	mov    $0x0,%eax
  802dd5:	a3 40 51 80 00       	mov    %eax,0x805140
  802dda:	a1 40 51 80 00       	mov    0x805140,%eax
  802ddf:	85 c0                	test   %eax,%eax
  802de1:	0f 85 57 fe ff ff    	jne    802c3e <alloc_block_FF+0x13>
  802de7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802deb:	0f 85 4d fe ff ff    	jne    802c3e <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802df1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802df6:	c9                   	leave  
  802df7:	c3                   	ret    

00802df8 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802df8:	55                   	push   %ebp
  802df9:	89 e5                	mov    %esp,%ebp
  802dfb:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802dfe:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802e05:	a1 38 51 80 00       	mov    0x805138,%eax
  802e0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e0d:	e9 df 00 00 00       	jmp    802ef1 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802e12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e15:	8b 40 0c             	mov    0xc(%eax),%eax
  802e18:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e1b:	0f 82 c8 00 00 00    	jb     802ee9 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802e21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e24:	8b 40 0c             	mov    0xc(%eax),%eax
  802e27:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e2a:	0f 85 8a 00 00 00    	jne    802eba <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802e30:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e34:	75 17                	jne    802e4d <alloc_block_BF+0x55>
  802e36:	83 ec 04             	sub    $0x4,%esp
  802e39:	68 74 49 80 00       	push   $0x804974
  802e3e:	68 b7 00 00 00       	push   $0xb7
  802e43:	68 cb 48 80 00       	push   $0x8048cb
  802e48:	e8 b4 da ff ff       	call   800901 <_panic>
  802e4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e50:	8b 00                	mov    (%eax),%eax
  802e52:	85 c0                	test   %eax,%eax
  802e54:	74 10                	je     802e66 <alloc_block_BF+0x6e>
  802e56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e59:	8b 00                	mov    (%eax),%eax
  802e5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e5e:	8b 52 04             	mov    0x4(%edx),%edx
  802e61:	89 50 04             	mov    %edx,0x4(%eax)
  802e64:	eb 0b                	jmp    802e71 <alloc_block_BF+0x79>
  802e66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e69:	8b 40 04             	mov    0x4(%eax),%eax
  802e6c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e74:	8b 40 04             	mov    0x4(%eax),%eax
  802e77:	85 c0                	test   %eax,%eax
  802e79:	74 0f                	je     802e8a <alloc_block_BF+0x92>
  802e7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7e:	8b 40 04             	mov    0x4(%eax),%eax
  802e81:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e84:	8b 12                	mov    (%edx),%edx
  802e86:	89 10                	mov    %edx,(%eax)
  802e88:	eb 0a                	jmp    802e94 <alloc_block_BF+0x9c>
  802e8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8d:	8b 00                	mov    (%eax),%eax
  802e8f:	a3 38 51 80 00       	mov    %eax,0x805138
  802e94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e97:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ea7:	a1 44 51 80 00       	mov    0x805144,%eax
  802eac:	48                   	dec    %eax
  802ead:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802eb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb5:	e9 4d 01 00 00       	jmp    803007 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802eba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebd:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec0:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ec3:	76 24                	jbe    802ee9 <alloc_block_BF+0xf1>
  802ec5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec8:	8b 40 0c             	mov    0xc(%eax),%eax
  802ecb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802ece:	73 19                	jae    802ee9 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802ed0:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802ed7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eda:	8b 40 0c             	mov    0xc(%eax),%eax
  802edd:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802ee0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee3:	8b 40 08             	mov    0x8(%eax),%eax
  802ee6:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802ee9:	a1 40 51 80 00       	mov    0x805140,%eax
  802eee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ef1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ef5:	74 07                	je     802efe <alloc_block_BF+0x106>
  802ef7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efa:	8b 00                	mov    (%eax),%eax
  802efc:	eb 05                	jmp    802f03 <alloc_block_BF+0x10b>
  802efe:	b8 00 00 00 00       	mov    $0x0,%eax
  802f03:	a3 40 51 80 00       	mov    %eax,0x805140
  802f08:	a1 40 51 80 00       	mov    0x805140,%eax
  802f0d:	85 c0                	test   %eax,%eax
  802f0f:	0f 85 fd fe ff ff    	jne    802e12 <alloc_block_BF+0x1a>
  802f15:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f19:	0f 85 f3 fe ff ff    	jne    802e12 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802f1f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f23:	0f 84 d9 00 00 00    	je     803002 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802f29:	a1 48 51 80 00       	mov    0x805148,%eax
  802f2e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802f31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f34:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f37:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802f3a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f3d:	8b 55 08             	mov    0x8(%ebp),%edx
  802f40:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802f43:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802f47:	75 17                	jne    802f60 <alloc_block_BF+0x168>
  802f49:	83 ec 04             	sub    $0x4,%esp
  802f4c:	68 74 49 80 00       	push   $0x804974
  802f51:	68 c7 00 00 00       	push   $0xc7
  802f56:	68 cb 48 80 00       	push   $0x8048cb
  802f5b:	e8 a1 d9 ff ff       	call   800901 <_panic>
  802f60:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f63:	8b 00                	mov    (%eax),%eax
  802f65:	85 c0                	test   %eax,%eax
  802f67:	74 10                	je     802f79 <alloc_block_BF+0x181>
  802f69:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f6c:	8b 00                	mov    (%eax),%eax
  802f6e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f71:	8b 52 04             	mov    0x4(%edx),%edx
  802f74:	89 50 04             	mov    %edx,0x4(%eax)
  802f77:	eb 0b                	jmp    802f84 <alloc_block_BF+0x18c>
  802f79:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f7c:	8b 40 04             	mov    0x4(%eax),%eax
  802f7f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f84:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f87:	8b 40 04             	mov    0x4(%eax),%eax
  802f8a:	85 c0                	test   %eax,%eax
  802f8c:	74 0f                	je     802f9d <alloc_block_BF+0x1a5>
  802f8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f91:	8b 40 04             	mov    0x4(%eax),%eax
  802f94:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f97:	8b 12                	mov    (%edx),%edx
  802f99:	89 10                	mov    %edx,(%eax)
  802f9b:	eb 0a                	jmp    802fa7 <alloc_block_BF+0x1af>
  802f9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fa0:	8b 00                	mov    (%eax),%eax
  802fa2:	a3 48 51 80 00       	mov    %eax,0x805148
  802fa7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802faa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fb0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fb3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fba:	a1 54 51 80 00       	mov    0x805154,%eax
  802fbf:	48                   	dec    %eax
  802fc0:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802fc5:	83 ec 08             	sub    $0x8,%esp
  802fc8:	ff 75 ec             	pushl  -0x14(%ebp)
  802fcb:	68 38 51 80 00       	push   $0x805138
  802fd0:	e8 71 f9 ff ff       	call   802946 <find_block>
  802fd5:	83 c4 10             	add    $0x10,%esp
  802fd8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802fdb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fde:	8b 50 08             	mov    0x8(%eax),%edx
  802fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe4:	01 c2                	add    %eax,%edx
  802fe6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fe9:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802fec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fef:	8b 40 0c             	mov    0xc(%eax),%eax
  802ff2:	2b 45 08             	sub    0x8(%ebp),%eax
  802ff5:	89 c2                	mov    %eax,%edx
  802ff7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ffa:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802ffd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803000:	eb 05                	jmp    803007 <alloc_block_BF+0x20f>
	}
	return NULL;
  803002:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803007:	c9                   	leave  
  803008:	c3                   	ret    

00803009 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  803009:	55                   	push   %ebp
  80300a:	89 e5                	mov    %esp,%ebp
  80300c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  80300f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803014:	85 c0                	test   %eax,%eax
  803016:	0f 85 de 01 00 00    	jne    8031fa <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80301c:	a1 38 51 80 00       	mov    0x805138,%eax
  803021:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803024:	e9 9e 01 00 00       	jmp    8031c7 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  803029:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302c:	8b 40 0c             	mov    0xc(%eax),%eax
  80302f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803032:	0f 82 87 01 00 00    	jb     8031bf <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  803038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303b:	8b 40 0c             	mov    0xc(%eax),%eax
  80303e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803041:	0f 85 95 00 00 00    	jne    8030dc <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  803047:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80304b:	75 17                	jne    803064 <alloc_block_NF+0x5b>
  80304d:	83 ec 04             	sub    $0x4,%esp
  803050:	68 74 49 80 00       	push   $0x804974
  803055:	68 e0 00 00 00       	push   $0xe0
  80305a:	68 cb 48 80 00       	push   $0x8048cb
  80305f:	e8 9d d8 ff ff       	call   800901 <_panic>
  803064:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803067:	8b 00                	mov    (%eax),%eax
  803069:	85 c0                	test   %eax,%eax
  80306b:	74 10                	je     80307d <alloc_block_NF+0x74>
  80306d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803070:	8b 00                	mov    (%eax),%eax
  803072:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803075:	8b 52 04             	mov    0x4(%edx),%edx
  803078:	89 50 04             	mov    %edx,0x4(%eax)
  80307b:	eb 0b                	jmp    803088 <alloc_block_NF+0x7f>
  80307d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803080:	8b 40 04             	mov    0x4(%eax),%eax
  803083:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803088:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308b:	8b 40 04             	mov    0x4(%eax),%eax
  80308e:	85 c0                	test   %eax,%eax
  803090:	74 0f                	je     8030a1 <alloc_block_NF+0x98>
  803092:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803095:	8b 40 04             	mov    0x4(%eax),%eax
  803098:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80309b:	8b 12                	mov    (%edx),%edx
  80309d:	89 10                	mov    %edx,(%eax)
  80309f:	eb 0a                	jmp    8030ab <alloc_block_NF+0xa2>
  8030a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a4:	8b 00                	mov    (%eax),%eax
  8030a6:	a3 38 51 80 00       	mov    %eax,0x805138
  8030ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030be:	a1 44 51 80 00       	mov    0x805144,%eax
  8030c3:	48                   	dec    %eax
  8030c4:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8030c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030cc:	8b 40 08             	mov    0x8(%eax),%eax
  8030cf:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   return  point;
  8030d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d7:	e9 f8 04 00 00       	jmp    8035d4 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8030dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030df:	8b 40 0c             	mov    0xc(%eax),%eax
  8030e2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030e5:	0f 86 d4 00 00 00    	jbe    8031bf <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8030eb:	a1 48 51 80 00       	mov    0x805148,%eax
  8030f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8030f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f6:	8b 50 08             	mov    0x8(%eax),%edx
  8030f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030fc:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8030ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803102:	8b 55 08             	mov    0x8(%ebp),%edx
  803105:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803108:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80310c:	75 17                	jne    803125 <alloc_block_NF+0x11c>
  80310e:	83 ec 04             	sub    $0x4,%esp
  803111:	68 74 49 80 00       	push   $0x804974
  803116:	68 e9 00 00 00       	push   $0xe9
  80311b:	68 cb 48 80 00       	push   $0x8048cb
  803120:	e8 dc d7 ff ff       	call   800901 <_panic>
  803125:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803128:	8b 00                	mov    (%eax),%eax
  80312a:	85 c0                	test   %eax,%eax
  80312c:	74 10                	je     80313e <alloc_block_NF+0x135>
  80312e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803131:	8b 00                	mov    (%eax),%eax
  803133:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803136:	8b 52 04             	mov    0x4(%edx),%edx
  803139:	89 50 04             	mov    %edx,0x4(%eax)
  80313c:	eb 0b                	jmp    803149 <alloc_block_NF+0x140>
  80313e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803141:	8b 40 04             	mov    0x4(%eax),%eax
  803144:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803149:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80314c:	8b 40 04             	mov    0x4(%eax),%eax
  80314f:	85 c0                	test   %eax,%eax
  803151:	74 0f                	je     803162 <alloc_block_NF+0x159>
  803153:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803156:	8b 40 04             	mov    0x4(%eax),%eax
  803159:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80315c:	8b 12                	mov    (%edx),%edx
  80315e:	89 10                	mov    %edx,(%eax)
  803160:	eb 0a                	jmp    80316c <alloc_block_NF+0x163>
  803162:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803165:	8b 00                	mov    (%eax),%eax
  803167:	a3 48 51 80 00       	mov    %eax,0x805148
  80316c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80316f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803175:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803178:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80317f:	a1 54 51 80 00       	mov    0x805154,%eax
  803184:	48                   	dec    %eax
  803185:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  80318a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80318d:	8b 40 08             	mov    0x8(%eax),%eax
  803190:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   point->sva += size;
  803195:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803198:	8b 50 08             	mov    0x8(%eax),%edx
  80319b:	8b 45 08             	mov    0x8(%ebp),%eax
  80319e:	01 c2                	add    %eax,%edx
  8031a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a3:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8031a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8031ac:	2b 45 08             	sub    0x8(%ebp),%eax
  8031af:	89 c2                	mov    %eax,%edx
  8031b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b4:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8031b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ba:	e9 15 04 00 00       	jmp    8035d4 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8031bf:	a1 40 51 80 00       	mov    0x805140,%eax
  8031c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031cb:	74 07                	je     8031d4 <alloc_block_NF+0x1cb>
  8031cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d0:	8b 00                	mov    (%eax),%eax
  8031d2:	eb 05                	jmp    8031d9 <alloc_block_NF+0x1d0>
  8031d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8031d9:	a3 40 51 80 00       	mov    %eax,0x805140
  8031de:	a1 40 51 80 00       	mov    0x805140,%eax
  8031e3:	85 c0                	test   %eax,%eax
  8031e5:	0f 85 3e fe ff ff    	jne    803029 <alloc_block_NF+0x20>
  8031eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031ef:	0f 85 34 fe ff ff    	jne    803029 <alloc_block_NF+0x20>
  8031f5:	e9 d5 03 00 00       	jmp    8035cf <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8031fa:	a1 38 51 80 00       	mov    0x805138,%eax
  8031ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803202:	e9 b1 01 00 00       	jmp    8033b8 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  803207:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320a:	8b 50 08             	mov    0x8(%eax),%edx
  80320d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803212:	39 c2                	cmp    %eax,%edx
  803214:	0f 82 96 01 00 00    	jb     8033b0 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  80321a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80321d:	8b 40 0c             	mov    0xc(%eax),%eax
  803220:	3b 45 08             	cmp    0x8(%ebp),%eax
  803223:	0f 82 87 01 00 00    	jb     8033b0 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  803229:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322c:	8b 40 0c             	mov    0xc(%eax),%eax
  80322f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803232:	0f 85 95 00 00 00    	jne    8032cd <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803238:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80323c:	75 17                	jne    803255 <alloc_block_NF+0x24c>
  80323e:	83 ec 04             	sub    $0x4,%esp
  803241:	68 74 49 80 00       	push   $0x804974
  803246:	68 fc 00 00 00       	push   $0xfc
  80324b:	68 cb 48 80 00       	push   $0x8048cb
  803250:	e8 ac d6 ff ff       	call   800901 <_panic>
  803255:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803258:	8b 00                	mov    (%eax),%eax
  80325a:	85 c0                	test   %eax,%eax
  80325c:	74 10                	je     80326e <alloc_block_NF+0x265>
  80325e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803261:	8b 00                	mov    (%eax),%eax
  803263:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803266:	8b 52 04             	mov    0x4(%edx),%edx
  803269:	89 50 04             	mov    %edx,0x4(%eax)
  80326c:	eb 0b                	jmp    803279 <alloc_block_NF+0x270>
  80326e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803271:	8b 40 04             	mov    0x4(%eax),%eax
  803274:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803279:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80327c:	8b 40 04             	mov    0x4(%eax),%eax
  80327f:	85 c0                	test   %eax,%eax
  803281:	74 0f                	je     803292 <alloc_block_NF+0x289>
  803283:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803286:	8b 40 04             	mov    0x4(%eax),%eax
  803289:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80328c:	8b 12                	mov    (%edx),%edx
  80328e:	89 10                	mov    %edx,(%eax)
  803290:	eb 0a                	jmp    80329c <alloc_block_NF+0x293>
  803292:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803295:	8b 00                	mov    (%eax),%eax
  803297:	a3 38 51 80 00       	mov    %eax,0x805138
  80329c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80329f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032af:	a1 44 51 80 00       	mov    0x805144,%eax
  8032b4:	48                   	dec    %eax
  8032b5:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8032ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032bd:	8b 40 08             	mov    0x8(%eax),%eax
  8032c0:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  8032c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c8:	e9 07 03 00 00       	jmp    8035d4 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8032cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8032d3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032d6:	0f 86 d4 00 00 00    	jbe    8033b0 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8032dc:	a1 48 51 80 00       	mov    0x805148,%eax
  8032e1:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8032e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e7:	8b 50 08             	mov    0x8(%eax),%edx
  8032ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ed:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8032f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8032f6:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8032f9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032fd:	75 17                	jne    803316 <alloc_block_NF+0x30d>
  8032ff:	83 ec 04             	sub    $0x4,%esp
  803302:	68 74 49 80 00       	push   $0x804974
  803307:	68 04 01 00 00       	push   $0x104
  80330c:	68 cb 48 80 00       	push   $0x8048cb
  803311:	e8 eb d5 ff ff       	call   800901 <_panic>
  803316:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803319:	8b 00                	mov    (%eax),%eax
  80331b:	85 c0                	test   %eax,%eax
  80331d:	74 10                	je     80332f <alloc_block_NF+0x326>
  80331f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803322:	8b 00                	mov    (%eax),%eax
  803324:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803327:	8b 52 04             	mov    0x4(%edx),%edx
  80332a:	89 50 04             	mov    %edx,0x4(%eax)
  80332d:	eb 0b                	jmp    80333a <alloc_block_NF+0x331>
  80332f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803332:	8b 40 04             	mov    0x4(%eax),%eax
  803335:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80333a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80333d:	8b 40 04             	mov    0x4(%eax),%eax
  803340:	85 c0                	test   %eax,%eax
  803342:	74 0f                	je     803353 <alloc_block_NF+0x34a>
  803344:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803347:	8b 40 04             	mov    0x4(%eax),%eax
  80334a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80334d:	8b 12                	mov    (%edx),%edx
  80334f:	89 10                	mov    %edx,(%eax)
  803351:	eb 0a                	jmp    80335d <alloc_block_NF+0x354>
  803353:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803356:	8b 00                	mov    (%eax),%eax
  803358:	a3 48 51 80 00       	mov    %eax,0x805148
  80335d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803360:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803366:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803369:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803370:	a1 54 51 80 00       	mov    0x805154,%eax
  803375:	48                   	dec    %eax
  803376:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  80337b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80337e:	8b 40 08             	mov    0x8(%eax),%eax
  803381:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  803386:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803389:	8b 50 08             	mov    0x8(%eax),%edx
  80338c:	8b 45 08             	mov    0x8(%ebp),%eax
  80338f:	01 c2                	add    %eax,%edx
  803391:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803394:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803397:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80339a:	8b 40 0c             	mov    0xc(%eax),%eax
  80339d:	2b 45 08             	sub    0x8(%ebp),%eax
  8033a0:	89 c2                	mov    %eax,%edx
  8033a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a5:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8033a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ab:	e9 24 02 00 00       	jmp    8035d4 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8033b0:	a1 40 51 80 00       	mov    0x805140,%eax
  8033b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033bc:	74 07                	je     8033c5 <alloc_block_NF+0x3bc>
  8033be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c1:	8b 00                	mov    (%eax),%eax
  8033c3:	eb 05                	jmp    8033ca <alloc_block_NF+0x3c1>
  8033c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8033ca:	a3 40 51 80 00       	mov    %eax,0x805140
  8033cf:	a1 40 51 80 00       	mov    0x805140,%eax
  8033d4:	85 c0                	test   %eax,%eax
  8033d6:	0f 85 2b fe ff ff    	jne    803207 <alloc_block_NF+0x1fe>
  8033dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033e0:	0f 85 21 fe ff ff    	jne    803207 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8033e6:	a1 38 51 80 00       	mov    0x805138,%eax
  8033eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033ee:	e9 ae 01 00 00       	jmp    8035a1 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8033f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f6:	8b 50 08             	mov    0x8(%eax),%edx
  8033f9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8033fe:	39 c2                	cmp    %eax,%edx
  803400:	0f 83 93 01 00 00    	jae    803599 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  803406:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803409:	8b 40 0c             	mov    0xc(%eax),%eax
  80340c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80340f:	0f 82 84 01 00 00    	jb     803599 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  803415:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803418:	8b 40 0c             	mov    0xc(%eax),%eax
  80341b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80341e:	0f 85 95 00 00 00    	jne    8034b9 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803424:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803428:	75 17                	jne    803441 <alloc_block_NF+0x438>
  80342a:	83 ec 04             	sub    $0x4,%esp
  80342d:	68 74 49 80 00       	push   $0x804974
  803432:	68 14 01 00 00       	push   $0x114
  803437:	68 cb 48 80 00       	push   $0x8048cb
  80343c:	e8 c0 d4 ff ff       	call   800901 <_panic>
  803441:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803444:	8b 00                	mov    (%eax),%eax
  803446:	85 c0                	test   %eax,%eax
  803448:	74 10                	je     80345a <alloc_block_NF+0x451>
  80344a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80344d:	8b 00                	mov    (%eax),%eax
  80344f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803452:	8b 52 04             	mov    0x4(%edx),%edx
  803455:	89 50 04             	mov    %edx,0x4(%eax)
  803458:	eb 0b                	jmp    803465 <alloc_block_NF+0x45c>
  80345a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80345d:	8b 40 04             	mov    0x4(%eax),%eax
  803460:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803465:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803468:	8b 40 04             	mov    0x4(%eax),%eax
  80346b:	85 c0                	test   %eax,%eax
  80346d:	74 0f                	je     80347e <alloc_block_NF+0x475>
  80346f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803472:	8b 40 04             	mov    0x4(%eax),%eax
  803475:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803478:	8b 12                	mov    (%edx),%edx
  80347a:	89 10                	mov    %edx,(%eax)
  80347c:	eb 0a                	jmp    803488 <alloc_block_NF+0x47f>
  80347e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803481:	8b 00                	mov    (%eax),%eax
  803483:	a3 38 51 80 00       	mov    %eax,0x805138
  803488:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80348b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803491:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803494:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80349b:	a1 44 51 80 00       	mov    0x805144,%eax
  8034a0:	48                   	dec    %eax
  8034a1:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8034a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a9:	8b 40 08             	mov    0x8(%eax),%eax
  8034ac:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  8034b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b4:	e9 1b 01 00 00       	jmp    8035d4 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8034b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8034bf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8034c2:	0f 86 d1 00 00 00    	jbe    803599 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8034c8:	a1 48 51 80 00       	mov    0x805148,%eax
  8034cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  8034d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d3:	8b 50 08             	mov    0x8(%eax),%edx
  8034d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034d9:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8034dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034df:	8b 55 08             	mov    0x8(%ebp),%edx
  8034e2:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8034e5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8034e9:	75 17                	jne    803502 <alloc_block_NF+0x4f9>
  8034eb:	83 ec 04             	sub    $0x4,%esp
  8034ee:	68 74 49 80 00       	push   $0x804974
  8034f3:	68 1c 01 00 00       	push   $0x11c
  8034f8:	68 cb 48 80 00       	push   $0x8048cb
  8034fd:	e8 ff d3 ff ff       	call   800901 <_panic>
  803502:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803505:	8b 00                	mov    (%eax),%eax
  803507:	85 c0                	test   %eax,%eax
  803509:	74 10                	je     80351b <alloc_block_NF+0x512>
  80350b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80350e:	8b 00                	mov    (%eax),%eax
  803510:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803513:	8b 52 04             	mov    0x4(%edx),%edx
  803516:	89 50 04             	mov    %edx,0x4(%eax)
  803519:	eb 0b                	jmp    803526 <alloc_block_NF+0x51d>
  80351b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80351e:	8b 40 04             	mov    0x4(%eax),%eax
  803521:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803526:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803529:	8b 40 04             	mov    0x4(%eax),%eax
  80352c:	85 c0                	test   %eax,%eax
  80352e:	74 0f                	je     80353f <alloc_block_NF+0x536>
  803530:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803533:	8b 40 04             	mov    0x4(%eax),%eax
  803536:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803539:	8b 12                	mov    (%edx),%edx
  80353b:	89 10                	mov    %edx,(%eax)
  80353d:	eb 0a                	jmp    803549 <alloc_block_NF+0x540>
  80353f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803542:	8b 00                	mov    (%eax),%eax
  803544:	a3 48 51 80 00       	mov    %eax,0x805148
  803549:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80354c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803552:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803555:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80355c:	a1 54 51 80 00       	mov    0x805154,%eax
  803561:	48                   	dec    %eax
  803562:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803567:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80356a:	8b 40 08             	mov    0x8(%eax),%eax
  80356d:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  803572:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803575:	8b 50 08             	mov    0x8(%eax),%edx
  803578:	8b 45 08             	mov    0x8(%ebp),%eax
  80357b:	01 c2                	add    %eax,%edx
  80357d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803580:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803583:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803586:	8b 40 0c             	mov    0xc(%eax),%eax
  803589:	2b 45 08             	sub    0x8(%ebp),%eax
  80358c:	89 c2                	mov    %eax,%edx
  80358e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803591:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803594:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803597:	eb 3b                	jmp    8035d4 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803599:	a1 40 51 80 00       	mov    0x805140,%eax
  80359e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035a5:	74 07                	je     8035ae <alloc_block_NF+0x5a5>
  8035a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035aa:	8b 00                	mov    (%eax),%eax
  8035ac:	eb 05                	jmp    8035b3 <alloc_block_NF+0x5aa>
  8035ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8035b3:	a3 40 51 80 00       	mov    %eax,0x805140
  8035b8:	a1 40 51 80 00       	mov    0x805140,%eax
  8035bd:	85 c0                	test   %eax,%eax
  8035bf:	0f 85 2e fe ff ff    	jne    8033f3 <alloc_block_NF+0x3ea>
  8035c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035c9:	0f 85 24 fe ff ff    	jne    8033f3 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  8035cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8035d4:	c9                   	leave  
  8035d5:	c3                   	ret    

008035d6 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8035d6:	55                   	push   %ebp
  8035d7:	89 e5                	mov    %esp,%ebp
  8035d9:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  8035dc:	a1 38 51 80 00       	mov    0x805138,%eax
  8035e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  8035e4:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8035e9:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  8035ec:	a1 38 51 80 00       	mov    0x805138,%eax
  8035f1:	85 c0                	test   %eax,%eax
  8035f3:	74 14                	je     803609 <insert_sorted_with_merge_freeList+0x33>
  8035f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f8:	8b 50 08             	mov    0x8(%eax),%edx
  8035fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035fe:	8b 40 08             	mov    0x8(%eax),%eax
  803601:	39 c2                	cmp    %eax,%edx
  803603:	0f 87 9b 01 00 00    	ja     8037a4 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  803609:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80360d:	75 17                	jne    803626 <insert_sorted_with_merge_freeList+0x50>
  80360f:	83 ec 04             	sub    $0x4,%esp
  803612:	68 a8 48 80 00       	push   $0x8048a8
  803617:	68 38 01 00 00       	push   $0x138
  80361c:	68 cb 48 80 00       	push   $0x8048cb
  803621:	e8 db d2 ff ff       	call   800901 <_panic>
  803626:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80362c:	8b 45 08             	mov    0x8(%ebp),%eax
  80362f:	89 10                	mov    %edx,(%eax)
  803631:	8b 45 08             	mov    0x8(%ebp),%eax
  803634:	8b 00                	mov    (%eax),%eax
  803636:	85 c0                	test   %eax,%eax
  803638:	74 0d                	je     803647 <insert_sorted_with_merge_freeList+0x71>
  80363a:	a1 38 51 80 00       	mov    0x805138,%eax
  80363f:	8b 55 08             	mov    0x8(%ebp),%edx
  803642:	89 50 04             	mov    %edx,0x4(%eax)
  803645:	eb 08                	jmp    80364f <insert_sorted_with_merge_freeList+0x79>
  803647:	8b 45 08             	mov    0x8(%ebp),%eax
  80364a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80364f:	8b 45 08             	mov    0x8(%ebp),%eax
  803652:	a3 38 51 80 00       	mov    %eax,0x805138
  803657:	8b 45 08             	mov    0x8(%ebp),%eax
  80365a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803661:	a1 44 51 80 00       	mov    0x805144,%eax
  803666:	40                   	inc    %eax
  803667:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80366c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803670:	0f 84 a8 06 00 00    	je     803d1e <insert_sorted_with_merge_freeList+0x748>
  803676:	8b 45 08             	mov    0x8(%ebp),%eax
  803679:	8b 50 08             	mov    0x8(%eax),%edx
  80367c:	8b 45 08             	mov    0x8(%ebp),%eax
  80367f:	8b 40 0c             	mov    0xc(%eax),%eax
  803682:	01 c2                	add    %eax,%edx
  803684:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803687:	8b 40 08             	mov    0x8(%eax),%eax
  80368a:	39 c2                	cmp    %eax,%edx
  80368c:	0f 85 8c 06 00 00    	jne    803d1e <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  803692:	8b 45 08             	mov    0x8(%ebp),%eax
  803695:	8b 50 0c             	mov    0xc(%eax),%edx
  803698:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80369b:	8b 40 0c             	mov    0xc(%eax),%eax
  80369e:	01 c2                	add    %eax,%edx
  8036a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a3:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  8036a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8036aa:	75 17                	jne    8036c3 <insert_sorted_with_merge_freeList+0xed>
  8036ac:	83 ec 04             	sub    $0x4,%esp
  8036af:	68 74 49 80 00       	push   $0x804974
  8036b4:	68 3c 01 00 00       	push   $0x13c
  8036b9:	68 cb 48 80 00       	push   $0x8048cb
  8036be:	e8 3e d2 ff ff       	call   800901 <_panic>
  8036c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036c6:	8b 00                	mov    (%eax),%eax
  8036c8:	85 c0                	test   %eax,%eax
  8036ca:	74 10                	je     8036dc <insert_sorted_with_merge_freeList+0x106>
  8036cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036cf:	8b 00                	mov    (%eax),%eax
  8036d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036d4:	8b 52 04             	mov    0x4(%edx),%edx
  8036d7:	89 50 04             	mov    %edx,0x4(%eax)
  8036da:	eb 0b                	jmp    8036e7 <insert_sorted_with_merge_freeList+0x111>
  8036dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036df:	8b 40 04             	mov    0x4(%eax),%eax
  8036e2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8036e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036ea:	8b 40 04             	mov    0x4(%eax),%eax
  8036ed:	85 c0                	test   %eax,%eax
  8036ef:	74 0f                	je     803700 <insert_sorted_with_merge_freeList+0x12a>
  8036f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036f4:	8b 40 04             	mov    0x4(%eax),%eax
  8036f7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036fa:	8b 12                	mov    (%edx),%edx
  8036fc:	89 10                	mov    %edx,(%eax)
  8036fe:	eb 0a                	jmp    80370a <insert_sorted_with_merge_freeList+0x134>
  803700:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803703:	8b 00                	mov    (%eax),%eax
  803705:	a3 38 51 80 00       	mov    %eax,0x805138
  80370a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80370d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803713:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803716:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80371d:	a1 44 51 80 00       	mov    0x805144,%eax
  803722:	48                   	dec    %eax
  803723:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  803728:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80372b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803732:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803735:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  80373c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803740:	75 17                	jne    803759 <insert_sorted_with_merge_freeList+0x183>
  803742:	83 ec 04             	sub    $0x4,%esp
  803745:	68 a8 48 80 00       	push   $0x8048a8
  80374a:	68 3f 01 00 00       	push   $0x13f
  80374f:	68 cb 48 80 00       	push   $0x8048cb
  803754:	e8 a8 d1 ff ff       	call   800901 <_panic>
  803759:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80375f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803762:	89 10                	mov    %edx,(%eax)
  803764:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803767:	8b 00                	mov    (%eax),%eax
  803769:	85 c0                	test   %eax,%eax
  80376b:	74 0d                	je     80377a <insert_sorted_with_merge_freeList+0x1a4>
  80376d:	a1 48 51 80 00       	mov    0x805148,%eax
  803772:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803775:	89 50 04             	mov    %edx,0x4(%eax)
  803778:	eb 08                	jmp    803782 <insert_sorted_with_merge_freeList+0x1ac>
  80377a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80377d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803782:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803785:	a3 48 51 80 00       	mov    %eax,0x805148
  80378a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80378d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803794:	a1 54 51 80 00       	mov    0x805154,%eax
  803799:	40                   	inc    %eax
  80379a:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80379f:	e9 7a 05 00 00       	jmp    803d1e <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  8037a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a7:	8b 50 08             	mov    0x8(%eax),%edx
  8037aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037ad:	8b 40 08             	mov    0x8(%eax),%eax
  8037b0:	39 c2                	cmp    %eax,%edx
  8037b2:	0f 82 14 01 00 00    	jb     8038cc <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8037b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037bb:	8b 50 08             	mov    0x8(%eax),%edx
  8037be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8037c4:	01 c2                	add    %eax,%edx
  8037c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c9:	8b 40 08             	mov    0x8(%eax),%eax
  8037cc:	39 c2                	cmp    %eax,%edx
  8037ce:	0f 85 90 00 00 00    	jne    803864 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8037d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037d7:	8b 50 0c             	mov    0xc(%eax),%edx
  8037da:	8b 45 08             	mov    0x8(%ebp),%eax
  8037dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8037e0:	01 c2                	add    %eax,%edx
  8037e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037e5:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  8037e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8037eb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8037f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8037fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803800:	75 17                	jne    803819 <insert_sorted_with_merge_freeList+0x243>
  803802:	83 ec 04             	sub    $0x4,%esp
  803805:	68 a8 48 80 00       	push   $0x8048a8
  80380a:	68 49 01 00 00       	push   $0x149
  80380f:	68 cb 48 80 00       	push   $0x8048cb
  803814:	e8 e8 d0 ff ff       	call   800901 <_panic>
  803819:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80381f:	8b 45 08             	mov    0x8(%ebp),%eax
  803822:	89 10                	mov    %edx,(%eax)
  803824:	8b 45 08             	mov    0x8(%ebp),%eax
  803827:	8b 00                	mov    (%eax),%eax
  803829:	85 c0                	test   %eax,%eax
  80382b:	74 0d                	je     80383a <insert_sorted_with_merge_freeList+0x264>
  80382d:	a1 48 51 80 00       	mov    0x805148,%eax
  803832:	8b 55 08             	mov    0x8(%ebp),%edx
  803835:	89 50 04             	mov    %edx,0x4(%eax)
  803838:	eb 08                	jmp    803842 <insert_sorted_with_merge_freeList+0x26c>
  80383a:	8b 45 08             	mov    0x8(%ebp),%eax
  80383d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803842:	8b 45 08             	mov    0x8(%ebp),%eax
  803845:	a3 48 51 80 00       	mov    %eax,0x805148
  80384a:	8b 45 08             	mov    0x8(%ebp),%eax
  80384d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803854:	a1 54 51 80 00       	mov    0x805154,%eax
  803859:	40                   	inc    %eax
  80385a:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80385f:	e9 bb 04 00 00       	jmp    803d1f <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803864:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803868:	75 17                	jne    803881 <insert_sorted_with_merge_freeList+0x2ab>
  80386a:	83 ec 04             	sub    $0x4,%esp
  80386d:	68 1c 49 80 00       	push   $0x80491c
  803872:	68 4c 01 00 00       	push   $0x14c
  803877:	68 cb 48 80 00       	push   $0x8048cb
  80387c:	e8 80 d0 ff ff       	call   800901 <_panic>
  803881:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803887:	8b 45 08             	mov    0x8(%ebp),%eax
  80388a:	89 50 04             	mov    %edx,0x4(%eax)
  80388d:	8b 45 08             	mov    0x8(%ebp),%eax
  803890:	8b 40 04             	mov    0x4(%eax),%eax
  803893:	85 c0                	test   %eax,%eax
  803895:	74 0c                	je     8038a3 <insert_sorted_with_merge_freeList+0x2cd>
  803897:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80389c:	8b 55 08             	mov    0x8(%ebp),%edx
  80389f:	89 10                	mov    %edx,(%eax)
  8038a1:	eb 08                	jmp    8038ab <insert_sorted_with_merge_freeList+0x2d5>
  8038a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a6:	a3 38 51 80 00       	mov    %eax,0x805138
  8038ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ae:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8038b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038bc:	a1 44 51 80 00       	mov    0x805144,%eax
  8038c1:	40                   	inc    %eax
  8038c2:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8038c7:	e9 53 04 00 00       	jmp    803d1f <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8038cc:	a1 38 51 80 00       	mov    0x805138,%eax
  8038d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8038d4:	e9 15 04 00 00       	jmp    803cee <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8038d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038dc:	8b 00                	mov    (%eax),%eax
  8038de:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8038e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e4:	8b 50 08             	mov    0x8(%eax),%edx
  8038e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038ea:	8b 40 08             	mov    0x8(%eax),%eax
  8038ed:	39 c2                	cmp    %eax,%edx
  8038ef:	0f 86 f1 03 00 00    	jbe    803ce6 <insert_sorted_with_merge_freeList+0x710>
  8038f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f8:	8b 50 08             	mov    0x8(%eax),%edx
  8038fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038fe:	8b 40 08             	mov    0x8(%eax),%eax
  803901:	39 c2                	cmp    %eax,%edx
  803903:	0f 83 dd 03 00 00    	jae    803ce6 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803909:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80390c:	8b 50 08             	mov    0x8(%eax),%edx
  80390f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803912:	8b 40 0c             	mov    0xc(%eax),%eax
  803915:	01 c2                	add    %eax,%edx
  803917:	8b 45 08             	mov    0x8(%ebp),%eax
  80391a:	8b 40 08             	mov    0x8(%eax),%eax
  80391d:	39 c2                	cmp    %eax,%edx
  80391f:	0f 85 b9 01 00 00    	jne    803ade <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803925:	8b 45 08             	mov    0x8(%ebp),%eax
  803928:	8b 50 08             	mov    0x8(%eax),%edx
  80392b:	8b 45 08             	mov    0x8(%ebp),%eax
  80392e:	8b 40 0c             	mov    0xc(%eax),%eax
  803931:	01 c2                	add    %eax,%edx
  803933:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803936:	8b 40 08             	mov    0x8(%eax),%eax
  803939:	39 c2                	cmp    %eax,%edx
  80393b:	0f 85 0d 01 00 00    	jne    803a4e <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803941:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803944:	8b 50 0c             	mov    0xc(%eax),%edx
  803947:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80394a:	8b 40 0c             	mov    0xc(%eax),%eax
  80394d:	01 c2                	add    %eax,%edx
  80394f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803952:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803955:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803959:	75 17                	jne    803972 <insert_sorted_with_merge_freeList+0x39c>
  80395b:	83 ec 04             	sub    $0x4,%esp
  80395e:	68 74 49 80 00       	push   $0x804974
  803963:	68 5c 01 00 00       	push   $0x15c
  803968:	68 cb 48 80 00       	push   $0x8048cb
  80396d:	e8 8f cf ff ff       	call   800901 <_panic>
  803972:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803975:	8b 00                	mov    (%eax),%eax
  803977:	85 c0                	test   %eax,%eax
  803979:	74 10                	je     80398b <insert_sorted_with_merge_freeList+0x3b5>
  80397b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80397e:	8b 00                	mov    (%eax),%eax
  803980:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803983:	8b 52 04             	mov    0x4(%edx),%edx
  803986:	89 50 04             	mov    %edx,0x4(%eax)
  803989:	eb 0b                	jmp    803996 <insert_sorted_with_merge_freeList+0x3c0>
  80398b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80398e:	8b 40 04             	mov    0x4(%eax),%eax
  803991:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803996:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803999:	8b 40 04             	mov    0x4(%eax),%eax
  80399c:	85 c0                	test   %eax,%eax
  80399e:	74 0f                	je     8039af <insert_sorted_with_merge_freeList+0x3d9>
  8039a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039a3:	8b 40 04             	mov    0x4(%eax),%eax
  8039a6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039a9:	8b 12                	mov    (%edx),%edx
  8039ab:	89 10                	mov    %edx,(%eax)
  8039ad:	eb 0a                	jmp    8039b9 <insert_sorted_with_merge_freeList+0x3e3>
  8039af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039b2:	8b 00                	mov    (%eax),%eax
  8039b4:	a3 38 51 80 00       	mov    %eax,0x805138
  8039b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039cc:	a1 44 51 80 00       	mov    0x805144,%eax
  8039d1:	48                   	dec    %eax
  8039d2:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8039d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039da:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8039e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039e4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8039eb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8039ef:	75 17                	jne    803a08 <insert_sorted_with_merge_freeList+0x432>
  8039f1:	83 ec 04             	sub    $0x4,%esp
  8039f4:	68 a8 48 80 00       	push   $0x8048a8
  8039f9:	68 5f 01 00 00       	push   $0x15f
  8039fe:	68 cb 48 80 00       	push   $0x8048cb
  803a03:	e8 f9 ce ff ff       	call   800901 <_panic>
  803a08:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a11:	89 10                	mov    %edx,(%eax)
  803a13:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a16:	8b 00                	mov    (%eax),%eax
  803a18:	85 c0                	test   %eax,%eax
  803a1a:	74 0d                	je     803a29 <insert_sorted_with_merge_freeList+0x453>
  803a1c:	a1 48 51 80 00       	mov    0x805148,%eax
  803a21:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a24:	89 50 04             	mov    %edx,0x4(%eax)
  803a27:	eb 08                	jmp    803a31 <insert_sorted_with_merge_freeList+0x45b>
  803a29:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a2c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803a31:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a34:	a3 48 51 80 00       	mov    %eax,0x805148
  803a39:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a3c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a43:	a1 54 51 80 00       	mov    0x805154,%eax
  803a48:	40                   	inc    %eax
  803a49:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803a4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a51:	8b 50 0c             	mov    0xc(%eax),%edx
  803a54:	8b 45 08             	mov    0x8(%ebp),%eax
  803a57:	8b 40 0c             	mov    0xc(%eax),%eax
  803a5a:	01 c2                	add    %eax,%edx
  803a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a5f:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803a62:	8b 45 08             	mov    0x8(%ebp),%eax
  803a65:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  803a6f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803a76:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a7a:	75 17                	jne    803a93 <insert_sorted_with_merge_freeList+0x4bd>
  803a7c:	83 ec 04             	sub    $0x4,%esp
  803a7f:	68 a8 48 80 00       	push   $0x8048a8
  803a84:	68 64 01 00 00       	push   $0x164
  803a89:	68 cb 48 80 00       	push   $0x8048cb
  803a8e:	e8 6e ce ff ff       	call   800901 <_panic>
  803a93:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a99:	8b 45 08             	mov    0x8(%ebp),%eax
  803a9c:	89 10                	mov    %edx,(%eax)
  803a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  803aa1:	8b 00                	mov    (%eax),%eax
  803aa3:	85 c0                	test   %eax,%eax
  803aa5:	74 0d                	je     803ab4 <insert_sorted_with_merge_freeList+0x4de>
  803aa7:	a1 48 51 80 00       	mov    0x805148,%eax
  803aac:	8b 55 08             	mov    0x8(%ebp),%edx
  803aaf:	89 50 04             	mov    %edx,0x4(%eax)
  803ab2:	eb 08                	jmp    803abc <insert_sorted_with_merge_freeList+0x4e6>
  803ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  803ab7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803abc:	8b 45 08             	mov    0x8(%ebp),%eax
  803abf:	a3 48 51 80 00       	mov    %eax,0x805148
  803ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  803ac7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ace:	a1 54 51 80 00       	mov    0x805154,%eax
  803ad3:	40                   	inc    %eax
  803ad4:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803ad9:	e9 41 02 00 00       	jmp    803d1f <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803ade:	8b 45 08             	mov    0x8(%ebp),%eax
  803ae1:	8b 50 08             	mov    0x8(%eax),%edx
  803ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  803ae7:	8b 40 0c             	mov    0xc(%eax),%eax
  803aea:	01 c2                	add    %eax,%edx
  803aec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803aef:	8b 40 08             	mov    0x8(%eax),%eax
  803af2:	39 c2                	cmp    %eax,%edx
  803af4:	0f 85 7c 01 00 00    	jne    803c76 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803afa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803afe:	74 06                	je     803b06 <insert_sorted_with_merge_freeList+0x530>
  803b00:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b04:	75 17                	jne    803b1d <insert_sorted_with_merge_freeList+0x547>
  803b06:	83 ec 04             	sub    $0x4,%esp
  803b09:	68 e4 48 80 00       	push   $0x8048e4
  803b0e:	68 69 01 00 00       	push   $0x169
  803b13:	68 cb 48 80 00       	push   $0x8048cb
  803b18:	e8 e4 cd ff ff       	call   800901 <_panic>
  803b1d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b20:	8b 50 04             	mov    0x4(%eax),%edx
  803b23:	8b 45 08             	mov    0x8(%ebp),%eax
  803b26:	89 50 04             	mov    %edx,0x4(%eax)
  803b29:	8b 45 08             	mov    0x8(%ebp),%eax
  803b2c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b2f:	89 10                	mov    %edx,(%eax)
  803b31:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b34:	8b 40 04             	mov    0x4(%eax),%eax
  803b37:	85 c0                	test   %eax,%eax
  803b39:	74 0d                	je     803b48 <insert_sorted_with_merge_freeList+0x572>
  803b3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b3e:	8b 40 04             	mov    0x4(%eax),%eax
  803b41:	8b 55 08             	mov    0x8(%ebp),%edx
  803b44:	89 10                	mov    %edx,(%eax)
  803b46:	eb 08                	jmp    803b50 <insert_sorted_with_merge_freeList+0x57a>
  803b48:	8b 45 08             	mov    0x8(%ebp),%eax
  803b4b:	a3 38 51 80 00       	mov    %eax,0x805138
  803b50:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b53:	8b 55 08             	mov    0x8(%ebp),%edx
  803b56:	89 50 04             	mov    %edx,0x4(%eax)
  803b59:	a1 44 51 80 00       	mov    0x805144,%eax
  803b5e:	40                   	inc    %eax
  803b5f:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803b64:	8b 45 08             	mov    0x8(%ebp),%eax
  803b67:	8b 50 0c             	mov    0xc(%eax),%edx
  803b6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b6d:	8b 40 0c             	mov    0xc(%eax),%eax
  803b70:	01 c2                	add    %eax,%edx
  803b72:	8b 45 08             	mov    0x8(%ebp),%eax
  803b75:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803b78:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803b7c:	75 17                	jne    803b95 <insert_sorted_with_merge_freeList+0x5bf>
  803b7e:	83 ec 04             	sub    $0x4,%esp
  803b81:	68 74 49 80 00       	push   $0x804974
  803b86:	68 6b 01 00 00       	push   $0x16b
  803b8b:	68 cb 48 80 00       	push   $0x8048cb
  803b90:	e8 6c cd ff ff       	call   800901 <_panic>
  803b95:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b98:	8b 00                	mov    (%eax),%eax
  803b9a:	85 c0                	test   %eax,%eax
  803b9c:	74 10                	je     803bae <insert_sorted_with_merge_freeList+0x5d8>
  803b9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ba1:	8b 00                	mov    (%eax),%eax
  803ba3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803ba6:	8b 52 04             	mov    0x4(%edx),%edx
  803ba9:	89 50 04             	mov    %edx,0x4(%eax)
  803bac:	eb 0b                	jmp    803bb9 <insert_sorted_with_merge_freeList+0x5e3>
  803bae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bb1:	8b 40 04             	mov    0x4(%eax),%eax
  803bb4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803bb9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bbc:	8b 40 04             	mov    0x4(%eax),%eax
  803bbf:	85 c0                	test   %eax,%eax
  803bc1:	74 0f                	je     803bd2 <insert_sorted_with_merge_freeList+0x5fc>
  803bc3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bc6:	8b 40 04             	mov    0x4(%eax),%eax
  803bc9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803bcc:	8b 12                	mov    (%edx),%edx
  803bce:	89 10                	mov    %edx,(%eax)
  803bd0:	eb 0a                	jmp    803bdc <insert_sorted_with_merge_freeList+0x606>
  803bd2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bd5:	8b 00                	mov    (%eax),%eax
  803bd7:	a3 38 51 80 00       	mov    %eax,0x805138
  803bdc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bdf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803be5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803be8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bef:	a1 44 51 80 00       	mov    0x805144,%eax
  803bf4:	48                   	dec    %eax
  803bf5:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803bfa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bfd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803c04:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c07:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803c0e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803c12:	75 17                	jne    803c2b <insert_sorted_with_merge_freeList+0x655>
  803c14:	83 ec 04             	sub    $0x4,%esp
  803c17:	68 a8 48 80 00       	push   $0x8048a8
  803c1c:	68 6e 01 00 00       	push   $0x16e
  803c21:	68 cb 48 80 00       	push   $0x8048cb
  803c26:	e8 d6 cc ff ff       	call   800901 <_panic>
  803c2b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803c31:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c34:	89 10                	mov    %edx,(%eax)
  803c36:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c39:	8b 00                	mov    (%eax),%eax
  803c3b:	85 c0                	test   %eax,%eax
  803c3d:	74 0d                	je     803c4c <insert_sorted_with_merge_freeList+0x676>
  803c3f:	a1 48 51 80 00       	mov    0x805148,%eax
  803c44:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c47:	89 50 04             	mov    %edx,0x4(%eax)
  803c4a:	eb 08                	jmp    803c54 <insert_sorted_with_merge_freeList+0x67e>
  803c4c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c4f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803c54:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c57:	a3 48 51 80 00       	mov    %eax,0x805148
  803c5c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c5f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c66:	a1 54 51 80 00       	mov    0x805154,%eax
  803c6b:	40                   	inc    %eax
  803c6c:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803c71:	e9 a9 00 00 00       	jmp    803d1f <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803c76:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c7a:	74 06                	je     803c82 <insert_sorted_with_merge_freeList+0x6ac>
  803c7c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c80:	75 17                	jne    803c99 <insert_sorted_with_merge_freeList+0x6c3>
  803c82:	83 ec 04             	sub    $0x4,%esp
  803c85:	68 40 49 80 00       	push   $0x804940
  803c8a:	68 73 01 00 00       	push   $0x173
  803c8f:	68 cb 48 80 00       	push   $0x8048cb
  803c94:	e8 68 cc ff ff       	call   800901 <_panic>
  803c99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c9c:	8b 10                	mov    (%eax),%edx
  803c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  803ca1:	89 10                	mov    %edx,(%eax)
  803ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  803ca6:	8b 00                	mov    (%eax),%eax
  803ca8:	85 c0                	test   %eax,%eax
  803caa:	74 0b                	je     803cb7 <insert_sorted_with_merge_freeList+0x6e1>
  803cac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803caf:	8b 00                	mov    (%eax),%eax
  803cb1:	8b 55 08             	mov    0x8(%ebp),%edx
  803cb4:	89 50 04             	mov    %edx,0x4(%eax)
  803cb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cba:	8b 55 08             	mov    0x8(%ebp),%edx
  803cbd:	89 10                	mov    %edx,(%eax)
  803cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  803cc2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803cc5:	89 50 04             	mov    %edx,0x4(%eax)
  803cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  803ccb:	8b 00                	mov    (%eax),%eax
  803ccd:	85 c0                	test   %eax,%eax
  803ccf:	75 08                	jne    803cd9 <insert_sorted_with_merge_freeList+0x703>
  803cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  803cd4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803cd9:	a1 44 51 80 00       	mov    0x805144,%eax
  803cde:	40                   	inc    %eax
  803cdf:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803ce4:	eb 39                	jmp    803d1f <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803ce6:	a1 40 51 80 00       	mov    0x805140,%eax
  803ceb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803cee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803cf2:	74 07                	je     803cfb <insert_sorted_with_merge_freeList+0x725>
  803cf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cf7:	8b 00                	mov    (%eax),%eax
  803cf9:	eb 05                	jmp    803d00 <insert_sorted_with_merge_freeList+0x72a>
  803cfb:	b8 00 00 00 00       	mov    $0x0,%eax
  803d00:	a3 40 51 80 00       	mov    %eax,0x805140
  803d05:	a1 40 51 80 00       	mov    0x805140,%eax
  803d0a:	85 c0                	test   %eax,%eax
  803d0c:	0f 85 c7 fb ff ff    	jne    8038d9 <insert_sorted_with_merge_freeList+0x303>
  803d12:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d16:	0f 85 bd fb ff ff    	jne    8038d9 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803d1c:	eb 01                	jmp    803d1f <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803d1e:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803d1f:	90                   	nop
  803d20:	c9                   	leave  
  803d21:	c3                   	ret    
  803d22:	66 90                	xchg   %ax,%ax

00803d24 <__udivdi3>:
  803d24:	55                   	push   %ebp
  803d25:	57                   	push   %edi
  803d26:	56                   	push   %esi
  803d27:	53                   	push   %ebx
  803d28:	83 ec 1c             	sub    $0x1c,%esp
  803d2b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803d2f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803d33:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803d37:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803d3b:	89 ca                	mov    %ecx,%edx
  803d3d:	89 f8                	mov    %edi,%eax
  803d3f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803d43:	85 f6                	test   %esi,%esi
  803d45:	75 2d                	jne    803d74 <__udivdi3+0x50>
  803d47:	39 cf                	cmp    %ecx,%edi
  803d49:	77 65                	ja     803db0 <__udivdi3+0x8c>
  803d4b:	89 fd                	mov    %edi,%ebp
  803d4d:	85 ff                	test   %edi,%edi
  803d4f:	75 0b                	jne    803d5c <__udivdi3+0x38>
  803d51:	b8 01 00 00 00       	mov    $0x1,%eax
  803d56:	31 d2                	xor    %edx,%edx
  803d58:	f7 f7                	div    %edi
  803d5a:	89 c5                	mov    %eax,%ebp
  803d5c:	31 d2                	xor    %edx,%edx
  803d5e:	89 c8                	mov    %ecx,%eax
  803d60:	f7 f5                	div    %ebp
  803d62:	89 c1                	mov    %eax,%ecx
  803d64:	89 d8                	mov    %ebx,%eax
  803d66:	f7 f5                	div    %ebp
  803d68:	89 cf                	mov    %ecx,%edi
  803d6a:	89 fa                	mov    %edi,%edx
  803d6c:	83 c4 1c             	add    $0x1c,%esp
  803d6f:	5b                   	pop    %ebx
  803d70:	5e                   	pop    %esi
  803d71:	5f                   	pop    %edi
  803d72:	5d                   	pop    %ebp
  803d73:	c3                   	ret    
  803d74:	39 ce                	cmp    %ecx,%esi
  803d76:	77 28                	ja     803da0 <__udivdi3+0x7c>
  803d78:	0f bd fe             	bsr    %esi,%edi
  803d7b:	83 f7 1f             	xor    $0x1f,%edi
  803d7e:	75 40                	jne    803dc0 <__udivdi3+0x9c>
  803d80:	39 ce                	cmp    %ecx,%esi
  803d82:	72 0a                	jb     803d8e <__udivdi3+0x6a>
  803d84:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803d88:	0f 87 9e 00 00 00    	ja     803e2c <__udivdi3+0x108>
  803d8e:	b8 01 00 00 00       	mov    $0x1,%eax
  803d93:	89 fa                	mov    %edi,%edx
  803d95:	83 c4 1c             	add    $0x1c,%esp
  803d98:	5b                   	pop    %ebx
  803d99:	5e                   	pop    %esi
  803d9a:	5f                   	pop    %edi
  803d9b:	5d                   	pop    %ebp
  803d9c:	c3                   	ret    
  803d9d:	8d 76 00             	lea    0x0(%esi),%esi
  803da0:	31 ff                	xor    %edi,%edi
  803da2:	31 c0                	xor    %eax,%eax
  803da4:	89 fa                	mov    %edi,%edx
  803da6:	83 c4 1c             	add    $0x1c,%esp
  803da9:	5b                   	pop    %ebx
  803daa:	5e                   	pop    %esi
  803dab:	5f                   	pop    %edi
  803dac:	5d                   	pop    %ebp
  803dad:	c3                   	ret    
  803dae:	66 90                	xchg   %ax,%ax
  803db0:	89 d8                	mov    %ebx,%eax
  803db2:	f7 f7                	div    %edi
  803db4:	31 ff                	xor    %edi,%edi
  803db6:	89 fa                	mov    %edi,%edx
  803db8:	83 c4 1c             	add    $0x1c,%esp
  803dbb:	5b                   	pop    %ebx
  803dbc:	5e                   	pop    %esi
  803dbd:	5f                   	pop    %edi
  803dbe:	5d                   	pop    %ebp
  803dbf:	c3                   	ret    
  803dc0:	bd 20 00 00 00       	mov    $0x20,%ebp
  803dc5:	89 eb                	mov    %ebp,%ebx
  803dc7:	29 fb                	sub    %edi,%ebx
  803dc9:	89 f9                	mov    %edi,%ecx
  803dcb:	d3 e6                	shl    %cl,%esi
  803dcd:	89 c5                	mov    %eax,%ebp
  803dcf:	88 d9                	mov    %bl,%cl
  803dd1:	d3 ed                	shr    %cl,%ebp
  803dd3:	89 e9                	mov    %ebp,%ecx
  803dd5:	09 f1                	or     %esi,%ecx
  803dd7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803ddb:	89 f9                	mov    %edi,%ecx
  803ddd:	d3 e0                	shl    %cl,%eax
  803ddf:	89 c5                	mov    %eax,%ebp
  803de1:	89 d6                	mov    %edx,%esi
  803de3:	88 d9                	mov    %bl,%cl
  803de5:	d3 ee                	shr    %cl,%esi
  803de7:	89 f9                	mov    %edi,%ecx
  803de9:	d3 e2                	shl    %cl,%edx
  803deb:	8b 44 24 08          	mov    0x8(%esp),%eax
  803def:	88 d9                	mov    %bl,%cl
  803df1:	d3 e8                	shr    %cl,%eax
  803df3:	09 c2                	or     %eax,%edx
  803df5:	89 d0                	mov    %edx,%eax
  803df7:	89 f2                	mov    %esi,%edx
  803df9:	f7 74 24 0c          	divl   0xc(%esp)
  803dfd:	89 d6                	mov    %edx,%esi
  803dff:	89 c3                	mov    %eax,%ebx
  803e01:	f7 e5                	mul    %ebp
  803e03:	39 d6                	cmp    %edx,%esi
  803e05:	72 19                	jb     803e20 <__udivdi3+0xfc>
  803e07:	74 0b                	je     803e14 <__udivdi3+0xf0>
  803e09:	89 d8                	mov    %ebx,%eax
  803e0b:	31 ff                	xor    %edi,%edi
  803e0d:	e9 58 ff ff ff       	jmp    803d6a <__udivdi3+0x46>
  803e12:	66 90                	xchg   %ax,%ax
  803e14:	8b 54 24 08          	mov    0x8(%esp),%edx
  803e18:	89 f9                	mov    %edi,%ecx
  803e1a:	d3 e2                	shl    %cl,%edx
  803e1c:	39 c2                	cmp    %eax,%edx
  803e1e:	73 e9                	jae    803e09 <__udivdi3+0xe5>
  803e20:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803e23:	31 ff                	xor    %edi,%edi
  803e25:	e9 40 ff ff ff       	jmp    803d6a <__udivdi3+0x46>
  803e2a:	66 90                	xchg   %ax,%ax
  803e2c:	31 c0                	xor    %eax,%eax
  803e2e:	e9 37 ff ff ff       	jmp    803d6a <__udivdi3+0x46>
  803e33:	90                   	nop

00803e34 <__umoddi3>:
  803e34:	55                   	push   %ebp
  803e35:	57                   	push   %edi
  803e36:	56                   	push   %esi
  803e37:	53                   	push   %ebx
  803e38:	83 ec 1c             	sub    $0x1c,%esp
  803e3b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803e3f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803e43:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803e47:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803e4b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803e4f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803e53:	89 f3                	mov    %esi,%ebx
  803e55:	89 fa                	mov    %edi,%edx
  803e57:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803e5b:	89 34 24             	mov    %esi,(%esp)
  803e5e:	85 c0                	test   %eax,%eax
  803e60:	75 1a                	jne    803e7c <__umoddi3+0x48>
  803e62:	39 f7                	cmp    %esi,%edi
  803e64:	0f 86 a2 00 00 00    	jbe    803f0c <__umoddi3+0xd8>
  803e6a:	89 c8                	mov    %ecx,%eax
  803e6c:	89 f2                	mov    %esi,%edx
  803e6e:	f7 f7                	div    %edi
  803e70:	89 d0                	mov    %edx,%eax
  803e72:	31 d2                	xor    %edx,%edx
  803e74:	83 c4 1c             	add    $0x1c,%esp
  803e77:	5b                   	pop    %ebx
  803e78:	5e                   	pop    %esi
  803e79:	5f                   	pop    %edi
  803e7a:	5d                   	pop    %ebp
  803e7b:	c3                   	ret    
  803e7c:	39 f0                	cmp    %esi,%eax
  803e7e:	0f 87 ac 00 00 00    	ja     803f30 <__umoddi3+0xfc>
  803e84:	0f bd e8             	bsr    %eax,%ebp
  803e87:	83 f5 1f             	xor    $0x1f,%ebp
  803e8a:	0f 84 ac 00 00 00    	je     803f3c <__umoddi3+0x108>
  803e90:	bf 20 00 00 00       	mov    $0x20,%edi
  803e95:	29 ef                	sub    %ebp,%edi
  803e97:	89 fe                	mov    %edi,%esi
  803e99:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803e9d:	89 e9                	mov    %ebp,%ecx
  803e9f:	d3 e0                	shl    %cl,%eax
  803ea1:	89 d7                	mov    %edx,%edi
  803ea3:	89 f1                	mov    %esi,%ecx
  803ea5:	d3 ef                	shr    %cl,%edi
  803ea7:	09 c7                	or     %eax,%edi
  803ea9:	89 e9                	mov    %ebp,%ecx
  803eab:	d3 e2                	shl    %cl,%edx
  803ead:	89 14 24             	mov    %edx,(%esp)
  803eb0:	89 d8                	mov    %ebx,%eax
  803eb2:	d3 e0                	shl    %cl,%eax
  803eb4:	89 c2                	mov    %eax,%edx
  803eb6:	8b 44 24 08          	mov    0x8(%esp),%eax
  803eba:	d3 e0                	shl    %cl,%eax
  803ebc:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ec0:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ec4:	89 f1                	mov    %esi,%ecx
  803ec6:	d3 e8                	shr    %cl,%eax
  803ec8:	09 d0                	or     %edx,%eax
  803eca:	d3 eb                	shr    %cl,%ebx
  803ecc:	89 da                	mov    %ebx,%edx
  803ece:	f7 f7                	div    %edi
  803ed0:	89 d3                	mov    %edx,%ebx
  803ed2:	f7 24 24             	mull   (%esp)
  803ed5:	89 c6                	mov    %eax,%esi
  803ed7:	89 d1                	mov    %edx,%ecx
  803ed9:	39 d3                	cmp    %edx,%ebx
  803edb:	0f 82 87 00 00 00    	jb     803f68 <__umoddi3+0x134>
  803ee1:	0f 84 91 00 00 00    	je     803f78 <__umoddi3+0x144>
  803ee7:	8b 54 24 04          	mov    0x4(%esp),%edx
  803eeb:	29 f2                	sub    %esi,%edx
  803eed:	19 cb                	sbb    %ecx,%ebx
  803eef:	89 d8                	mov    %ebx,%eax
  803ef1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803ef5:	d3 e0                	shl    %cl,%eax
  803ef7:	89 e9                	mov    %ebp,%ecx
  803ef9:	d3 ea                	shr    %cl,%edx
  803efb:	09 d0                	or     %edx,%eax
  803efd:	89 e9                	mov    %ebp,%ecx
  803eff:	d3 eb                	shr    %cl,%ebx
  803f01:	89 da                	mov    %ebx,%edx
  803f03:	83 c4 1c             	add    $0x1c,%esp
  803f06:	5b                   	pop    %ebx
  803f07:	5e                   	pop    %esi
  803f08:	5f                   	pop    %edi
  803f09:	5d                   	pop    %ebp
  803f0a:	c3                   	ret    
  803f0b:	90                   	nop
  803f0c:	89 fd                	mov    %edi,%ebp
  803f0e:	85 ff                	test   %edi,%edi
  803f10:	75 0b                	jne    803f1d <__umoddi3+0xe9>
  803f12:	b8 01 00 00 00       	mov    $0x1,%eax
  803f17:	31 d2                	xor    %edx,%edx
  803f19:	f7 f7                	div    %edi
  803f1b:	89 c5                	mov    %eax,%ebp
  803f1d:	89 f0                	mov    %esi,%eax
  803f1f:	31 d2                	xor    %edx,%edx
  803f21:	f7 f5                	div    %ebp
  803f23:	89 c8                	mov    %ecx,%eax
  803f25:	f7 f5                	div    %ebp
  803f27:	89 d0                	mov    %edx,%eax
  803f29:	e9 44 ff ff ff       	jmp    803e72 <__umoddi3+0x3e>
  803f2e:	66 90                	xchg   %ax,%ax
  803f30:	89 c8                	mov    %ecx,%eax
  803f32:	89 f2                	mov    %esi,%edx
  803f34:	83 c4 1c             	add    $0x1c,%esp
  803f37:	5b                   	pop    %ebx
  803f38:	5e                   	pop    %esi
  803f39:	5f                   	pop    %edi
  803f3a:	5d                   	pop    %ebp
  803f3b:	c3                   	ret    
  803f3c:	3b 04 24             	cmp    (%esp),%eax
  803f3f:	72 06                	jb     803f47 <__umoddi3+0x113>
  803f41:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803f45:	77 0f                	ja     803f56 <__umoddi3+0x122>
  803f47:	89 f2                	mov    %esi,%edx
  803f49:	29 f9                	sub    %edi,%ecx
  803f4b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803f4f:	89 14 24             	mov    %edx,(%esp)
  803f52:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803f56:	8b 44 24 04          	mov    0x4(%esp),%eax
  803f5a:	8b 14 24             	mov    (%esp),%edx
  803f5d:	83 c4 1c             	add    $0x1c,%esp
  803f60:	5b                   	pop    %ebx
  803f61:	5e                   	pop    %esi
  803f62:	5f                   	pop    %edi
  803f63:	5d                   	pop    %ebp
  803f64:	c3                   	ret    
  803f65:	8d 76 00             	lea    0x0(%esi),%esi
  803f68:	2b 04 24             	sub    (%esp),%eax
  803f6b:	19 fa                	sbb    %edi,%edx
  803f6d:	89 d1                	mov    %edx,%ecx
  803f6f:	89 c6                	mov    %eax,%esi
  803f71:	e9 71 ff ff ff       	jmp    803ee7 <__umoddi3+0xb3>
  803f76:	66 90                	xchg   %ax,%ax
  803f78:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803f7c:	72 ea                	jb     803f68 <__umoddi3+0x134>
  803f7e:	89 d9                	mov    %ebx,%ecx
  803f80:	e9 62 ff ff ff       	jmp    803ee7 <__umoddi3+0xb3>
