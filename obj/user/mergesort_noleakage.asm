
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
  800041:	e8 0a 20 00 00       	call   802050 <sys_disable_interrupt>

		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 a0 3d 80 00       	push   $0x803da0
  80004e:	e8 62 0b 00 00       	call   800bb5 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 a2 3d 80 00       	push   $0x803da2
  80005e:	e8 52 0b 00 00       	call   800bb5 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 b8 3d 80 00       	push   $0x803db8
  80006e:	e8 42 0b 00 00       	call   800bb5 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 a2 3d 80 00       	push   $0x803da2
  80007e:	e8 32 0b 00 00       	call   800bb5 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 a0 3d 80 00       	push   $0x803da0
  80008e:	e8 22 0b 00 00       	call   800bb5 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 d0 3d 80 00       	push   $0x803dd0
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
  8000de:	68 f0 3d 80 00       	push   $0x803df0
  8000e3:	e8 cd 0a 00 00       	call   800bb5 <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 12 3e 80 00       	push   $0x803e12
  8000f3:	e8 bd 0a 00 00       	call   800bb5 <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 20 3e 80 00       	push   $0x803e20
  800103:	e8 ad 0a 00 00       	call   800bb5 <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 2f 3e 80 00       	push   $0x803e2f
  800113:	e8 9d 0a 00 00       	call   800bb5 <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 3f 3e 80 00       	push   $0x803e3f
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
  800162:	e8 03 1f 00 00       	call   80206a <sys_enable_interrupt>

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
  8001d7:	e8 74 1e 00 00       	call   802050 <sys_disable_interrupt>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	68 48 3e 80 00       	push   $0x803e48
  8001e4:	e8 cc 09 00 00       	call   800bb5 <cprintf>
  8001e9:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001ec:	e8 79 1e 00 00       	call   80206a <sys_enable_interrupt>

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
  80020e:	68 7c 3e 80 00       	push   $0x803e7c
  800213:	6a 4a                	push   $0x4a
  800215:	68 9e 3e 80 00       	push   $0x803e9e
  80021a:	e8 e2 06 00 00       	call   800901 <_panic>
		else
		{
			sys_disable_interrupt();
  80021f:	e8 2c 1e 00 00       	call   802050 <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	68 bc 3e 80 00       	push   $0x803ebc
  80022c:	e8 84 09 00 00       	call   800bb5 <cprintf>
  800231:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	68 f0 3e 80 00       	push   $0x803ef0
  80023c:	e8 74 09 00 00       	call   800bb5 <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 24 3f 80 00       	push   $0x803f24
  80024c:	e8 64 09 00 00       	call   800bb5 <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800254:	e8 11 1e 00 00       	call   80206a <sys_enable_interrupt>
		}

		free(Elements) ;
  800259:	83 ec 0c             	sub    $0xc,%esp
  80025c:	ff 75 ec             	pushl  -0x14(%ebp)
  80025f:	e8 0d 1b 00 00       	call   801d71 <free>
  800264:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  800267:	e8 e4 1d 00 00       	call   802050 <sys_disable_interrupt>
			Chose = 0 ;
  80026c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800270:	eb 42                	jmp    8002b4 <_main+0x27c>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800272:	83 ec 0c             	sub    $0xc,%esp
  800275:	68 56 3f 80 00       	push   $0x803f56
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
  8002c0:	e8 a5 1d 00 00       	call   80206a <sys_enable_interrupt>

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
  800454:	68 a0 3d 80 00       	push   $0x803da0
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
  800476:	68 74 3f 80 00       	push   $0x803f74
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
  8004a4:	68 79 3f 80 00       	push   $0x803f79
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
  800739:	e8 46 19 00 00       	call   802084 <sys_cputc>
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
  80074a:	e8 01 19 00 00       	call   802050 <sys_disable_interrupt>
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
  80075d:	e8 22 19 00 00       	call   802084 <sys_cputc>
  800762:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800765:	e8 00 19 00 00       	call   80206a <sys_enable_interrupt>
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
  80077c:	e8 4a 17 00 00       	call   801ecb <sys_cgetc>
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
  800795:	e8 b6 18 00 00       	call   802050 <sys_disable_interrupt>
	int c=0;
  80079a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8007a1:	eb 08                	jmp    8007ab <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  8007a3:	e8 23 17 00 00       	call   801ecb <sys_cgetc>
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
  8007b1:	e8 b4 18 00 00       	call   80206a <sys_enable_interrupt>
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
  8007cb:	e8 73 1a 00 00       	call   802243 <sys_getenvindex>
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
  800836:	e8 15 18 00 00       	call   802050 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80083b:	83 ec 0c             	sub    $0xc,%esp
  80083e:	68 98 3f 80 00       	push   $0x803f98
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
  800866:	68 c0 3f 80 00       	push   $0x803fc0
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
  800897:	68 e8 3f 80 00       	push   $0x803fe8
  80089c:	e8 14 03 00 00       	call   800bb5 <cprintf>
  8008a1:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8008a4:	a1 24 50 80 00       	mov    0x805024,%eax
  8008a9:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8008af:	83 ec 08             	sub    $0x8,%esp
  8008b2:	50                   	push   %eax
  8008b3:	68 40 40 80 00       	push   $0x804040
  8008b8:	e8 f8 02 00 00       	call   800bb5 <cprintf>
  8008bd:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8008c0:	83 ec 0c             	sub    $0xc,%esp
  8008c3:	68 98 3f 80 00       	push   $0x803f98
  8008c8:	e8 e8 02 00 00       	call   800bb5 <cprintf>
  8008cd:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8008d0:	e8 95 17 00 00       	call   80206a <sys_enable_interrupt>

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
  8008e8:	e8 22 19 00 00       	call   80220f <sys_destroy_env>
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
  8008f9:	e8 77 19 00 00       	call   802275 <sys_exit_env>
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
  800922:	68 54 40 80 00       	push   $0x804054
  800927:	e8 89 02 00 00       	call   800bb5 <cprintf>
  80092c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80092f:	a1 00 50 80 00       	mov    0x805000,%eax
  800934:	ff 75 0c             	pushl  0xc(%ebp)
  800937:	ff 75 08             	pushl  0x8(%ebp)
  80093a:	50                   	push   %eax
  80093b:	68 59 40 80 00       	push   $0x804059
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
  80095f:	68 75 40 80 00       	push   $0x804075
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
  80098b:	68 78 40 80 00       	push   $0x804078
  800990:	6a 26                	push   $0x26
  800992:	68 c4 40 80 00       	push   $0x8040c4
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
  800a5d:	68 d0 40 80 00       	push   $0x8040d0
  800a62:	6a 3a                	push   $0x3a
  800a64:	68 c4 40 80 00       	push   $0x8040c4
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
  800acd:	68 24 41 80 00       	push   $0x804124
  800ad2:	6a 44                	push   $0x44
  800ad4:	68 c4 40 80 00       	push   $0x8040c4
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
  800b27:	e8 76 13 00 00       	call   801ea2 <sys_cputs>
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
  800b9e:	e8 ff 12 00 00       	call   801ea2 <sys_cputs>
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
  800be8:	e8 63 14 00 00       	call   802050 <sys_disable_interrupt>
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
  800c08:	e8 5d 14 00 00       	call   80206a <sys_enable_interrupt>
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
  800c52:	e8 d1 2e 00 00       	call   803b28 <__udivdi3>
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
  800ca2:	e8 91 2f 00 00       	call   803c38 <__umoddi3>
  800ca7:	83 c4 10             	add    $0x10,%esp
  800caa:	05 94 43 80 00       	add    $0x804394,%eax
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
  800dfd:	8b 04 85 b8 43 80 00 	mov    0x8043b8(,%eax,4),%eax
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
  800ede:	8b 34 9d 00 42 80 00 	mov    0x804200(,%ebx,4),%esi
  800ee5:	85 f6                	test   %esi,%esi
  800ee7:	75 19                	jne    800f02 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ee9:	53                   	push   %ebx
  800eea:	68 a5 43 80 00       	push   $0x8043a5
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
  800f03:	68 ae 43 80 00       	push   $0x8043ae
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
  800f30:	be b1 43 80 00       	mov    $0x8043b1,%esi
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
  801249:	68 10 45 80 00       	push   $0x804510
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
  80128b:	68 13 45 80 00       	push   $0x804513
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
  80133b:	e8 10 0d 00 00       	call   802050 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  801340:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801344:	74 13                	je     801359 <atomic_readline+0x24>
		cprintf("%s", prompt);
  801346:	83 ec 08             	sub    $0x8,%esp
  801349:	ff 75 08             	pushl  0x8(%ebp)
  80134c:	68 10 45 80 00       	push   $0x804510
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
  80138a:	68 13 45 80 00       	push   $0x804513
  80138f:	e8 21 f8 ff ff       	call   800bb5 <cprintf>
  801394:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801397:	e8 ce 0c 00 00       	call   80206a <sys_enable_interrupt>
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
  80142f:	e8 36 0c 00 00       	call   80206a <sys_enable_interrupt>
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
  801b5c:	68 24 45 80 00       	push   $0x804524
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
  801c2c:	e8 b5 03 00 00       	call   801fe6 <sys_allocate_chunk>
  801c31:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801c34:	a1 20 51 80 00       	mov    0x805120,%eax
  801c39:	83 ec 0c             	sub    $0xc,%esp
  801c3c:	50                   	push   %eax
  801c3d:	e8 2a 0a 00 00       	call   80266c <initialize_MemBlocksList>
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
  801c6a:	68 49 45 80 00       	push   $0x804549
  801c6f:	6a 33                	push   $0x33
  801c71:	68 67 45 80 00       	push   $0x804567
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
  801ce9:	68 74 45 80 00       	push   $0x804574
  801cee:	6a 34                	push   $0x34
  801cf0:	68 67 45 80 00       	push   $0x804567
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
  801d5e:	68 98 45 80 00       	push   $0x804598
  801d63:	6a 46                	push   $0x46
  801d65:	68 67 45 80 00       	push   $0x804567
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
  801d7a:	68 c0 45 80 00       	push   $0x8045c0
  801d7f:	6a 61                	push   $0x61
  801d81:	68 67 45 80 00       	push   $0x804567
  801d86:	e8 76 eb ff ff       	call   800901 <_panic>

00801d8b <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801d8b:	55                   	push   %ebp
  801d8c:	89 e5                	mov    %esp,%ebp
  801d8e:	83 ec 18             	sub    $0x18,%esp
  801d91:	8b 45 10             	mov    0x10(%ebp),%eax
  801d94:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d97:	e8 a9 fd ff ff       	call   801b45 <InitializeUHeap>
	if (size == 0) return NULL ;
  801d9c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801da0:	75 07                	jne    801da9 <smalloc+0x1e>
  801da2:	b8 00 00 00 00       	mov    $0x0,%eax
  801da7:	eb 14                	jmp    801dbd <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801da9:	83 ec 04             	sub    $0x4,%esp
  801dac:	68 e4 45 80 00       	push   $0x8045e4
  801db1:	6a 76                	push   $0x76
  801db3:	68 67 45 80 00       	push   $0x804567
  801db8:	e8 44 eb ff ff       	call   800901 <_panic>

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801dbd:	c9                   	leave  
  801dbe:	c3                   	ret    

00801dbf <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801dbf:	55                   	push   %ebp
  801dc0:	89 e5                	mov    %esp,%ebp
  801dc2:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801dc5:	e8 7b fd ff ff       	call   801b45 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801dca:	83 ec 04             	sub    $0x4,%esp
  801dcd:	68 0c 46 80 00       	push   $0x80460c
  801dd2:	68 93 00 00 00       	push   $0x93
  801dd7:	68 67 45 80 00       	push   $0x804567
  801ddc:	e8 20 eb ff ff       	call   800901 <_panic>

00801de1 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801de1:	55                   	push   %ebp
  801de2:	89 e5                	mov    %esp,%ebp
  801de4:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801de7:	e8 59 fd ff ff       	call   801b45 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801dec:	83 ec 04             	sub    $0x4,%esp
  801def:	68 30 46 80 00       	push   $0x804630
  801df4:	68 c5 00 00 00       	push   $0xc5
  801df9:	68 67 45 80 00       	push   $0x804567
  801dfe:	e8 fe ea ff ff       	call   800901 <_panic>

00801e03 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801e03:	55                   	push   %ebp
  801e04:	89 e5                	mov    %esp,%ebp
  801e06:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801e09:	83 ec 04             	sub    $0x4,%esp
  801e0c:	68 58 46 80 00       	push   $0x804658
  801e11:	68 d9 00 00 00       	push   $0xd9
  801e16:	68 67 45 80 00       	push   $0x804567
  801e1b:	e8 e1 ea ff ff       	call   800901 <_panic>

00801e20 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801e20:	55                   	push   %ebp
  801e21:	89 e5                	mov    %esp,%ebp
  801e23:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e26:	83 ec 04             	sub    $0x4,%esp
  801e29:	68 7c 46 80 00       	push   $0x80467c
  801e2e:	68 e4 00 00 00       	push   $0xe4
  801e33:	68 67 45 80 00       	push   $0x804567
  801e38:	e8 c4 ea ff ff       	call   800901 <_panic>

00801e3d <shrink>:

}
void shrink(uint32 newSize)
{
  801e3d:	55                   	push   %ebp
  801e3e:	89 e5                	mov    %esp,%ebp
  801e40:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e43:	83 ec 04             	sub    $0x4,%esp
  801e46:	68 7c 46 80 00       	push   $0x80467c
  801e4b:	68 e9 00 00 00       	push   $0xe9
  801e50:	68 67 45 80 00       	push   $0x804567
  801e55:	e8 a7 ea ff ff       	call   800901 <_panic>

00801e5a <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801e5a:	55                   	push   %ebp
  801e5b:	89 e5                	mov    %esp,%ebp
  801e5d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e60:	83 ec 04             	sub    $0x4,%esp
  801e63:	68 7c 46 80 00       	push   $0x80467c
  801e68:	68 ee 00 00 00       	push   $0xee
  801e6d:	68 67 45 80 00       	push   $0x804567
  801e72:	e8 8a ea ff ff       	call   800901 <_panic>

00801e77 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801e77:	55                   	push   %ebp
  801e78:	89 e5                	mov    %esp,%ebp
  801e7a:	57                   	push   %edi
  801e7b:	56                   	push   %esi
  801e7c:	53                   	push   %ebx
  801e7d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801e80:	8b 45 08             	mov    0x8(%ebp),%eax
  801e83:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e86:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e89:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e8c:	8b 7d 18             	mov    0x18(%ebp),%edi
  801e8f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801e92:	cd 30                	int    $0x30
  801e94:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801e97:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801e9a:	83 c4 10             	add    $0x10,%esp
  801e9d:	5b                   	pop    %ebx
  801e9e:	5e                   	pop    %esi
  801e9f:	5f                   	pop    %edi
  801ea0:	5d                   	pop    %ebp
  801ea1:	c3                   	ret    

00801ea2 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801ea2:	55                   	push   %ebp
  801ea3:	89 e5                	mov    %esp,%ebp
  801ea5:	83 ec 04             	sub    $0x4,%esp
  801ea8:	8b 45 10             	mov    0x10(%ebp),%eax
  801eab:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801eae:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 00                	push   $0x0
  801eb9:	52                   	push   %edx
  801eba:	ff 75 0c             	pushl  0xc(%ebp)
  801ebd:	50                   	push   %eax
  801ebe:	6a 00                	push   $0x0
  801ec0:	e8 b2 ff ff ff       	call   801e77 <syscall>
  801ec5:	83 c4 18             	add    $0x18,%esp
}
  801ec8:	90                   	nop
  801ec9:	c9                   	leave  
  801eca:	c3                   	ret    

00801ecb <sys_cgetc>:

int
sys_cgetc(void)
{
  801ecb:	55                   	push   %ebp
  801ecc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 00                	push   $0x0
  801ed8:	6a 01                	push   $0x1
  801eda:	e8 98 ff ff ff       	call   801e77 <syscall>
  801edf:	83 c4 18             	add    $0x18,%esp
}
  801ee2:	c9                   	leave  
  801ee3:	c3                   	ret    

00801ee4 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801ee4:	55                   	push   %ebp
  801ee5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801ee7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eea:	8b 45 08             	mov    0x8(%ebp),%eax
  801eed:	6a 00                	push   $0x0
  801eef:	6a 00                	push   $0x0
  801ef1:	6a 00                	push   $0x0
  801ef3:	52                   	push   %edx
  801ef4:	50                   	push   %eax
  801ef5:	6a 05                	push   $0x5
  801ef7:	e8 7b ff ff ff       	call   801e77 <syscall>
  801efc:	83 c4 18             	add    $0x18,%esp
}
  801eff:	c9                   	leave  
  801f00:	c3                   	ret    

00801f01 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801f01:	55                   	push   %ebp
  801f02:	89 e5                	mov    %esp,%ebp
  801f04:	56                   	push   %esi
  801f05:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801f06:	8b 75 18             	mov    0x18(%ebp),%esi
  801f09:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f0c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f12:	8b 45 08             	mov    0x8(%ebp),%eax
  801f15:	56                   	push   %esi
  801f16:	53                   	push   %ebx
  801f17:	51                   	push   %ecx
  801f18:	52                   	push   %edx
  801f19:	50                   	push   %eax
  801f1a:	6a 06                	push   $0x6
  801f1c:	e8 56 ff ff ff       	call   801e77 <syscall>
  801f21:	83 c4 18             	add    $0x18,%esp
}
  801f24:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f27:	5b                   	pop    %ebx
  801f28:	5e                   	pop    %esi
  801f29:	5d                   	pop    %ebp
  801f2a:	c3                   	ret    

00801f2b <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801f2b:	55                   	push   %ebp
  801f2c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801f2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f31:	8b 45 08             	mov    0x8(%ebp),%eax
  801f34:	6a 00                	push   $0x0
  801f36:	6a 00                	push   $0x0
  801f38:	6a 00                	push   $0x0
  801f3a:	52                   	push   %edx
  801f3b:	50                   	push   %eax
  801f3c:	6a 07                	push   $0x7
  801f3e:	e8 34 ff ff ff       	call   801e77 <syscall>
  801f43:	83 c4 18             	add    $0x18,%esp
}
  801f46:	c9                   	leave  
  801f47:	c3                   	ret    

00801f48 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801f48:	55                   	push   %ebp
  801f49:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801f4b:	6a 00                	push   $0x0
  801f4d:	6a 00                	push   $0x0
  801f4f:	6a 00                	push   $0x0
  801f51:	ff 75 0c             	pushl  0xc(%ebp)
  801f54:	ff 75 08             	pushl  0x8(%ebp)
  801f57:	6a 08                	push   $0x8
  801f59:	e8 19 ff ff ff       	call   801e77 <syscall>
  801f5e:	83 c4 18             	add    $0x18,%esp
}
  801f61:	c9                   	leave  
  801f62:	c3                   	ret    

00801f63 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801f63:	55                   	push   %ebp
  801f64:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801f66:	6a 00                	push   $0x0
  801f68:	6a 00                	push   $0x0
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 00                	push   $0x0
  801f6e:	6a 00                	push   $0x0
  801f70:	6a 09                	push   $0x9
  801f72:	e8 00 ff ff ff       	call   801e77 <syscall>
  801f77:	83 c4 18             	add    $0x18,%esp
}
  801f7a:	c9                   	leave  
  801f7b:	c3                   	ret    

00801f7c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801f7c:	55                   	push   %ebp
  801f7d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801f7f:	6a 00                	push   $0x0
  801f81:	6a 00                	push   $0x0
  801f83:	6a 00                	push   $0x0
  801f85:	6a 00                	push   $0x0
  801f87:	6a 00                	push   $0x0
  801f89:	6a 0a                	push   $0xa
  801f8b:	e8 e7 fe ff ff       	call   801e77 <syscall>
  801f90:	83 c4 18             	add    $0x18,%esp
}
  801f93:	c9                   	leave  
  801f94:	c3                   	ret    

00801f95 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801f95:	55                   	push   %ebp
  801f96:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801f98:	6a 00                	push   $0x0
  801f9a:	6a 00                	push   $0x0
  801f9c:	6a 00                	push   $0x0
  801f9e:	6a 00                	push   $0x0
  801fa0:	6a 00                	push   $0x0
  801fa2:	6a 0b                	push   $0xb
  801fa4:	e8 ce fe ff ff       	call   801e77 <syscall>
  801fa9:	83 c4 18             	add    $0x18,%esp
}
  801fac:	c9                   	leave  
  801fad:	c3                   	ret    

00801fae <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801fae:	55                   	push   %ebp
  801faf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801fb1:	6a 00                	push   $0x0
  801fb3:	6a 00                	push   $0x0
  801fb5:	6a 00                	push   $0x0
  801fb7:	ff 75 0c             	pushl  0xc(%ebp)
  801fba:	ff 75 08             	pushl  0x8(%ebp)
  801fbd:	6a 0f                	push   $0xf
  801fbf:	e8 b3 fe ff ff       	call   801e77 <syscall>
  801fc4:	83 c4 18             	add    $0x18,%esp
	return;
  801fc7:	90                   	nop
}
  801fc8:	c9                   	leave  
  801fc9:	c3                   	ret    

00801fca <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801fca:	55                   	push   %ebp
  801fcb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801fcd:	6a 00                	push   $0x0
  801fcf:	6a 00                	push   $0x0
  801fd1:	6a 00                	push   $0x0
  801fd3:	ff 75 0c             	pushl  0xc(%ebp)
  801fd6:	ff 75 08             	pushl  0x8(%ebp)
  801fd9:	6a 10                	push   $0x10
  801fdb:	e8 97 fe ff ff       	call   801e77 <syscall>
  801fe0:	83 c4 18             	add    $0x18,%esp
	return ;
  801fe3:	90                   	nop
}
  801fe4:	c9                   	leave  
  801fe5:	c3                   	ret    

00801fe6 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801fe6:	55                   	push   %ebp
  801fe7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801fe9:	6a 00                	push   $0x0
  801feb:	6a 00                	push   $0x0
  801fed:	ff 75 10             	pushl  0x10(%ebp)
  801ff0:	ff 75 0c             	pushl  0xc(%ebp)
  801ff3:	ff 75 08             	pushl  0x8(%ebp)
  801ff6:	6a 11                	push   $0x11
  801ff8:	e8 7a fe ff ff       	call   801e77 <syscall>
  801ffd:	83 c4 18             	add    $0x18,%esp
	return ;
  802000:	90                   	nop
}
  802001:	c9                   	leave  
  802002:	c3                   	ret    

00802003 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802003:	55                   	push   %ebp
  802004:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802006:	6a 00                	push   $0x0
  802008:	6a 00                	push   $0x0
  80200a:	6a 00                	push   $0x0
  80200c:	6a 00                	push   $0x0
  80200e:	6a 00                	push   $0x0
  802010:	6a 0c                	push   $0xc
  802012:	e8 60 fe ff ff       	call   801e77 <syscall>
  802017:	83 c4 18             	add    $0x18,%esp
}
  80201a:	c9                   	leave  
  80201b:	c3                   	ret    

0080201c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80201c:	55                   	push   %ebp
  80201d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80201f:	6a 00                	push   $0x0
  802021:	6a 00                	push   $0x0
  802023:	6a 00                	push   $0x0
  802025:	6a 00                	push   $0x0
  802027:	ff 75 08             	pushl  0x8(%ebp)
  80202a:	6a 0d                	push   $0xd
  80202c:	e8 46 fe ff ff       	call   801e77 <syscall>
  802031:	83 c4 18             	add    $0x18,%esp
}
  802034:	c9                   	leave  
  802035:	c3                   	ret    

00802036 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802036:	55                   	push   %ebp
  802037:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802039:	6a 00                	push   $0x0
  80203b:	6a 00                	push   $0x0
  80203d:	6a 00                	push   $0x0
  80203f:	6a 00                	push   $0x0
  802041:	6a 00                	push   $0x0
  802043:	6a 0e                	push   $0xe
  802045:	e8 2d fe ff ff       	call   801e77 <syscall>
  80204a:	83 c4 18             	add    $0x18,%esp
}
  80204d:	90                   	nop
  80204e:	c9                   	leave  
  80204f:	c3                   	ret    

00802050 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802050:	55                   	push   %ebp
  802051:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802053:	6a 00                	push   $0x0
  802055:	6a 00                	push   $0x0
  802057:	6a 00                	push   $0x0
  802059:	6a 00                	push   $0x0
  80205b:	6a 00                	push   $0x0
  80205d:	6a 13                	push   $0x13
  80205f:	e8 13 fe ff ff       	call   801e77 <syscall>
  802064:	83 c4 18             	add    $0x18,%esp
}
  802067:	90                   	nop
  802068:	c9                   	leave  
  802069:	c3                   	ret    

0080206a <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80206a:	55                   	push   %ebp
  80206b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80206d:	6a 00                	push   $0x0
  80206f:	6a 00                	push   $0x0
  802071:	6a 00                	push   $0x0
  802073:	6a 00                	push   $0x0
  802075:	6a 00                	push   $0x0
  802077:	6a 14                	push   $0x14
  802079:	e8 f9 fd ff ff       	call   801e77 <syscall>
  80207e:	83 c4 18             	add    $0x18,%esp
}
  802081:	90                   	nop
  802082:	c9                   	leave  
  802083:	c3                   	ret    

00802084 <sys_cputc>:


void
sys_cputc(const char c)
{
  802084:	55                   	push   %ebp
  802085:	89 e5                	mov    %esp,%ebp
  802087:	83 ec 04             	sub    $0x4,%esp
  80208a:	8b 45 08             	mov    0x8(%ebp),%eax
  80208d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802090:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802094:	6a 00                	push   $0x0
  802096:	6a 00                	push   $0x0
  802098:	6a 00                	push   $0x0
  80209a:	6a 00                	push   $0x0
  80209c:	50                   	push   %eax
  80209d:	6a 15                	push   $0x15
  80209f:	e8 d3 fd ff ff       	call   801e77 <syscall>
  8020a4:	83 c4 18             	add    $0x18,%esp
}
  8020a7:	90                   	nop
  8020a8:	c9                   	leave  
  8020a9:	c3                   	ret    

008020aa <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8020aa:	55                   	push   %ebp
  8020ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8020ad:	6a 00                	push   $0x0
  8020af:	6a 00                	push   $0x0
  8020b1:	6a 00                	push   $0x0
  8020b3:	6a 00                	push   $0x0
  8020b5:	6a 00                	push   $0x0
  8020b7:	6a 16                	push   $0x16
  8020b9:	e8 b9 fd ff ff       	call   801e77 <syscall>
  8020be:	83 c4 18             	add    $0x18,%esp
}
  8020c1:	90                   	nop
  8020c2:	c9                   	leave  
  8020c3:	c3                   	ret    

008020c4 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8020c4:	55                   	push   %ebp
  8020c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8020c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ca:	6a 00                	push   $0x0
  8020cc:	6a 00                	push   $0x0
  8020ce:	6a 00                	push   $0x0
  8020d0:	ff 75 0c             	pushl  0xc(%ebp)
  8020d3:	50                   	push   %eax
  8020d4:	6a 17                	push   $0x17
  8020d6:	e8 9c fd ff ff       	call   801e77 <syscall>
  8020db:	83 c4 18             	add    $0x18,%esp
}
  8020de:	c9                   	leave  
  8020df:	c3                   	ret    

008020e0 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8020e0:	55                   	push   %ebp
  8020e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8020e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e9:	6a 00                	push   $0x0
  8020eb:	6a 00                	push   $0x0
  8020ed:	6a 00                	push   $0x0
  8020ef:	52                   	push   %edx
  8020f0:	50                   	push   %eax
  8020f1:	6a 1a                	push   $0x1a
  8020f3:	e8 7f fd ff ff       	call   801e77 <syscall>
  8020f8:	83 c4 18             	add    $0x18,%esp
}
  8020fb:	c9                   	leave  
  8020fc:	c3                   	ret    

008020fd <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8020fd:	55                   	push   %ebp
  8020fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802100:	8b 55 0c             	mov    0xc(%ebp),%edx
  802103:	8b 45 08             	mov    0x8(%ebp),%eax
  802106:	6a 00                	push   $0x0
  802108:	6a 00                	push   $0x0
  80210a:	6a 00                	push   $0x0
  80210c:	52                   	push   %edx
  80210d:	50                   	push   %eax
  80210e:	6a 18                	push   $0x18
  802110:	e8 62 fd ff ff       	call   801e77 <syscall>
  802115:	83 c4 18             	add    $0x18,%esp
}
  802118:	90                   	nop
  802119:	c9                   	leave  
  80211a:	c3                   	ret    

0080211b <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80211b:	55                   	push   %ebp
  80211c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80211e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802121:	8b 45 08             	mov    0x8(%ebp),%eax
  802124:	6a 00                	push   $0x0
  802126:	6a 00                	push   $0x0
  802128:	6a 00                	push   $0x0
  80212a:	52                   	push   %edx
  80212b:	50                   	push   %eax
  80212c:	6a 19                	push   $0x19
  80212e:	e8 44 fd ff ff       	call   801e77 <syscall>
  802133:	83 c4 18             	add    $0x18,%esp
}
  802136:	90                   	nop
  802137:	c9                   	leave  
  802138:	c3                   	ret    

00802139 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802139:	55                   	push   %ebp
  80213a:	89 e5                	mov    %esp,%ebp
  80213c:	83 ec 04             	sub    $0x4,%esp
  80213f:	8b 45 10             	mov    0x10(%ebp),%eax
  802142:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802145:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802148:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80214c:	8b 45 08             	mov    0x8(%ebp),%eax
  80214f:	6a 00                	push   $0x0
  802151:	51                   	push   %ecx
  802152:	52                   	push   %edx
  802153:	ff 75 0c             	pushl  0xc(%ebp)
  802156:	50                   	push   %eax
  802157:	6a 1b                	push   $0x1b
  802159:	e8 19 fd ff ff       	call   801e77 <syscall>
  80215e:	83 c4 18             	add    $0x18,%esp
}
  802161:	c9                   	leave  
  802162:	c3                   	ret    

00802163 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802163:	55                   	push   %ebp
  802164:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802166:	8b 55 0c             	mov    0xc(%ebp),%edx
  802169:	8b 45 08             	mov    0x8(%ebp),%eax
  80216c:	6a 00                	push   $0x0
  80216e:	6a 00                	push   $0x0
  802170:	6a 00                	push   $0x0
  802172:	52                   	push   %edx
  802173:	50                   	push   %eax
  802174:	6a 1c                	push   $0x1c
  802176:	e8 fc fc ff ff       	call   801e77 <syscall>
  80217b:	83 c4 18             	add    $0x18,%esp
}
  80217e:	c9                   	leave  
  80217f:	c3                   	ret    

00802180 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802180:	55                   	push   %ebp
  802181:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802183:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802186:	8b 55 0c             	mov    0xc(%ebp),%edx
  802189:	8b 45 08             	mov    0x8(%ebp),%eax
  80218c:	6a 00                	push   $0x0
  80218e:	6a 00                	push   $0x0
  802190:	51                   	push   %ecx
  802191:	52                   	push   %edx
  802192:	50                   	push   %eax
  802193:	6a 1d                	push   $0x1d
  802195:	e8 dd fc ff ff       	call   801e77 <syscall>
  80219a:	83 c4 18             	add    $0x18,%esp
}
  80219d:	c9                   	leave  
  80219e:	c3                   	ret    

0080219f <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80219f:	55                   	push   %ebp
  8021a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8021a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a8:	6a 00                	push   $0x0
  8021aa:	6a 00                	push   $0x0
  8021ac:	6a 00                	push   $0x0
  8021ae:	52                   	push   %edx
  8021af:	50                   	push   %eax
  8021b0:	6a 1e                	push   $0x1e
  8021b2:	e8 c0 fc ff ff       	call   801e77 <syscall>
  8021b7:	83 c4 18             	add    $0x18,%esp
}
  8021ba:	c9                   	leave  
  8021bb:	c3                   	ret    

008021bc <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8021bc:	55                   	push   %ebp
  8021bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8021bf:	6a 00                	push   $0x0
  8021c1:	6a 00                	push   $0x0
  8021c3:	6a 00                	push   $0x0
  8021c5:	6a 00                	push   $0x0
  8021c7:	6a 00                	push   $0x0
  8021c9:	6a 1f                	push   $0x1f
  8021cb:	e8 a7 fc ff ff       	call   801e77 <syscall>
  8021d0:	83 c4 18             	add    $0x18,%esp
}
  8021d3:	c9                   	leave  
  8021d4:	c3                   	ret    

008021d5 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8021d5:	55                   	push   %ebp
  8021d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8021d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021db:	6a 00                	push   $0x0
  8021dd:	ff 75 14             	pushl  0x14(%ebp)
  8021e0:	ff 75 10             	pushl  0x10(%ebp)
  8021e3:	ff 75 0c             	pushl  0xc(%ebp)
  8021e6:	50                   	push   %eax
  8021e7:	6a 20                	push   $0x20
  8021e9:	e8 89 fc ff ff       	call   801e77 <syscall>
  8021ee:	83 c4 18             	add    $0x18,%esp
}
  8021f1:	c9                   	leave  
  8021f2:	c3                   	ret    

008021f3 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8021f3:	55                   	push   %ebp
  8021f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8021f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f9:	6a 00                	push   $0x0
  8021fb:	6a 00                	push   $0x0
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 00                	push   $0x0
  802201:	50                   	push   %eax
  802202:	6a 21                	push   $0x21
  802204:	e8 6e fc ff ff       	call   801e77 <syscall>
  802209:	83 c4 18             	add    $0x18,%esp
}
  80220c:	90                   	nop
  80220d:	c9                   	leave  
  80220e:	c3                   	ret    

0080220f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80220f:	55                   	push   %ebp
  802210:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802212:	8b 45 08             	mov    0x8(%ebp),%eax
  802215:	6a 00                	push   $0x0
  802217:	6a 00                	push   $0x0
  802219:	6a 00                	push   $0x0
  80221b:	6a 00                	push   $0x0
  80221d:	50                   	push   %eax
  80221e:	6a 22                	push   $0x22
  802220:	e8 52 fc ff ff       	call   801e77 <syscall>
  802225:	83 c4 18             	add    $0x18,%esp
}
  802228:	c9                   	leave  
  802229:	c3                   	ret    

0080222a <sys_getenvid>:

int32 sys_getenvid(void)
{
  80222a:	55                   	push   %ebp
  80222b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80222d:	6a 00                	push   $0x0
  80222f:	6a 00                	push   $0x0
  802231:	6a 00                	push   $0x0
  802233:	6a 00                	push   $0x0
  802235:	6a 00                	push   $0x0
  802237:	6a 02                	push   $0x2
  802239:	e8 39 fc ff ff       	call   801e77 <syscall>
  80223e:	83 c4 18             	add    $0x18,%esp
}
  802241:	c9                   	leave  
  802242:	c3                   	ret    

00802243 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802243:	55                   	push   %ebp
  802244:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802246:	6a 00                	push   $0x0
  802248:	6a 00                	push   $0x0
  80224a:	6a 00                	push   $0x0
  80224c:	6a 00                	push   $0x0
  80224e:	6a 00                	push   $0x0
  802250:	6a 03                	push   $0x3
  802252:	e8 20 fc ff ff       	call   801e77 <syscall>
  802257:	83 c4 18             	add    $0x18,%esp
}
  80225a:	c9                   	leave  
  80225b:	c3                   	ret    

0080225c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80225c:	55                   	push   %ebp
  80225d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80225f:	6a 00                	push   $0x0
  802261:	6a 00                	push   $0x0
  802263:	6a 00                	push   $0x0
  802265:	6a 00                	push   $0x0
  802267:	6a 00                	push   $0x0
  802269:	6a 04                	push   $0x4
  80226b:	e8 07 fc ff ff       	call   801e77 <syscall>
  802270:	83 c4 18             	add    $0x18,%esp
}
  802273:	c9                   	leave  
  802274:	c3                   	ret    

00802275 <sys_exit_env>:


void sys_exit_env(void)
{
  802275:	55                   	push   %ebp
  802276:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802278:	6a 00                	push   $0x0
  80227a:	6a 00                	push   $0x0
  80227c:	6a 00                	push   $0x0
  80227e:	6a 00                	push   $0x0
  802280:	6a 00                	push   $0x0
  802282:	6a 23                	push   $0x23
  802284:	e8 ee fb ff ff       	call   801e77 <syscall>
  802289:	83 c4 18             	add    $0x18,%esp
}
  80228c:	90                   	nop
  80228d:	c9                   	leave  
  80228e:	c3                   	ret    

0080228f <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80228f:	55                   	push   %ebp
  802290:	89 e5                	mov    %esp,%ebp
  802292:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802295:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802298:	8d 50 04             	lea    0x4(%eax),%edx
  80229b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80229e:	6a 00                	push   $0x0
  8022a0:	6a 00                	push   $0x0
  8022a2:	6a 00                	push   $0x0
  8022a4:	52                   	push   %edx
  8022a5:	50                   	push   %eax
  8022a6:	6a 24                	push   $0x24
  8022a8:	e8 ca fb ff ff       	call   801e77 <syscall>
  8022ad:	83 c4 18             	add    $0x18,%esp
	return result;
  8022b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022b6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8022b9:	89 01                	mov    %eax,(%ecx)
  8022bb:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8022be:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c1:	c9                   	leave  
  8022c2:	c2 04 00             	ret    $0x4

008022c5 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8022c5:	55                   	push   %ebp
  8022c6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8022c8:	6a 00                	push   $0x0
  8022ca:	6a 00                	push   $0x0
  8022cc:	ff 75 10             	pushl  0x10(%ebp)
  8022cf:	ff 75 0c             	pushl  0xc(%ebp)
  8022d2:	ff 75 08             	pushl  0x8(%ebp)
  8022d5:	6a 12                	push   $0x12
  8022d7:	e8 9b fb ff ff       	call   801e77 <syscall>
  8022dc:	83 c4 18             	add    $0x18,%esp
	return ;
  8022df:	90                   	nop
}
  8022e0:	c9                   	leave  
  8022e1:	c3                   	ret    

008022e2 <sys_rcr2>:
uint32 sys_rcr2()
{
  8022e2:	55                   	push   %ebp
  8022e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8022e5:	6a 00                	push   $0x0
  8022e7:	6a 00                	push   $0x0
  8022e9:	6a 00                	push   $0x0
  8022eb:	6a 00                	push   $0x0
  8022ed:	6a 00                	push   $0x0
  8022ef:	6a 25                	push   $0x25
  8022f1:	e8 81 fb ff ff       	call   801e77 <syscall>
  8022f6:	83 c4 18             	add    $0x18,%esp
}
  8022f9:	c9                   	leave  
  8022fa:	c3                   	ret    

008022fb <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8022fb:	55                   	push   %ebp
  8022fc:	89 e5                	mov    %esp,%ebp
  8022fe:	83 ec 04             	sub    $0x4,%esp
  802301:	8b 45 08             	mov    0x8(%ebp),%eax
  802304:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802307:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80230b:	6a 00                	push   $0x0
  80230d:	6a 00                	push   $0x0
  80230f:	6a 00                	push   $0x0
  802311:	6a 00                	push   $0x0
  802313:	50                   	push   %eax
  802314:	6a 26                	push   $0x26
  802316:	e8 5c fb ff ff       	call   801e77 <syscall>
  80231b:	83 c4 18             	add    $0x18,%esp
	return ;
  80231e:	90                   	nop
}
  80231f:	c9                   	leave  
  802320:	c3                   	ret    

00802321 <rsttst>:
void rsttst()
{
  802321:	55                   	push   %ebp
  802322:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802324:	6a 00                	push   $0x0
  802326:	6a 00                	push   $0x0
  802328:	6a 00                	push   $0x0
  80232a:	6a 00                	push   $0x0
  80232c:	6a 00                	push   $0x0
  80232e:	6a 28                	push   $0x28
  802330:	e8 42 fb ff ff       	call   801e77 <syscall>
  802335:	83 c4 18             	add    $0x18,%esp
	return ;
  802338:	90                   	nop
}
  802339:	c9                   	leave  
  80233a:	c3                   	ret    

0080233b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80233b:	55                   	push   %ebp
  80233c:	89 e5                	mov    %esp,%ebp
  80233e:	83 ec 04             	sub    $0x4,%esp
  802341:	8b 45 14             	mov    0x14(%ebp),%eax
  802344:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802347:	8b 55 18             	mov    0x18(%ebp),%edx
  80234a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80234e:	52                   	push   %edx
  80234f:	50                   	push   %eax
  802350:	ff 75 10             	pushl  0x10(%ebp)
  802353:	ff 75 0c             	pushl  0xc(%ebp)
  802356:	ff 75 08             	pushl  0x8(%ebp)
  802359:	6a 27                	push   $0x27
  80235b:	e8 17 fb ff ff       	call   801e77 <syscall>
  802360:	83 c4 18             	add    $0x18,%esp
	return ;
  802363:	90                   	nop
}
  802364:	c9                   	leave  
  802365:	c3                   	ret    

00802366 <chktst>:
void chktst(uint32 n)
{
  802366:	55                   	push   %ebp
  802367:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802369:	6a 00                	push   $0x0
  80236b:	6a 00                	push   $0x0
  80236d:	6a 00                	push   $0x0
  80236f:	6a 00                	push   $0x0
  802371:	ff 75 08             	pushl  0x8(%ebp)
  802374:	6a 29                	push   $0x29
  802376:	e8 fc fa ff ff       	call   801e77 <syscall>
  80237b:	83 c4 18             	add    $0x18,%esp
	return ;
  80237e:	90                   	nop
}
  80237f:	c9                   	leave  
  802380:	c3                   	ret    

00802381 <inctst>:

void inctst()
{
  802381:	55                   	push   %ebp
  802382:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802384:	6a 00                	push   $0x0
  802386:	6a 00                	push   $0x0
  802388:	6a 00                	push   $0x0
  80238a:	6a 00                	push   $0x0
  80238c:	6a 00                	push   $0x0
  80238e:	6a 2a                	push   $0x2a
  802390:	e8 e2 fa ff ff       	call   801e77 <syscall>
  802395:	83 c4 18             	add    $0x18,%esp
	return ;
  802398:	90                   	nop
}
  802399:	c9                   	leave  
  80239a:	c3                   	ret    

0080239b <gettst>:
uint32 gettst()
{
  80239b:	55                   	push   %ebp
  80239c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80239e:	6a 00                	push   $0x0
  8023a0:	6a 00                	push   $0x0
  8023a2:	6a 00                	push   $0x0
  8023a4:	6a 00                	push   $0x0
  8023a6:	6a 00                	push   $0x0
  8023a8:	6a 2b                	push   $0x2b
  8023aa:	e8 c8 fa ff ff       	call   801e77 <syscall>
  8023af:	83 c4 18             	add    $0x18,%esp
}
  8023b2:	c9                   	leave  
  8023b3:	c3                   	ret    

008023b4 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8023b4:	55                   	push   %ebp
  8023b5:	89 e5                	mov    %esp,%ebp
  8023b7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023ba:	6a 00                	push   $0x0
  8023bc:	6a 00                	push   $0x0
  8023be:	6a 00                	push   $0x0
  8023c0:	6a 00                	push   $0x0
  8023c2:	6a 00                	push   $0x0
  8023c4:	6a 2c                	push   $0x2c
  8023c6:	e8 ac fa ff ff       	call   801e77 <syscall>
  8023cb:	83 c4 18             	add    $0x18,%esp
  8023ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8023d1:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8023d5:	75 07                	jne    8023de <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8023d7:	b8 01 00 00 00       	mov    $0x1,%eax
  8023dc:	eb 05                	jmp    8023e3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8023de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023e3:	c9                   	leave  
  8023e4:	c3                   	ret    

008023e5 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8023e5:	55                   	push   %ebp
  8023e6:	89 e5                	mov    %esp,%ebp
  8023e8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023eb:	6a 00                	push   $0x0
  8023ed:	6a 00                	push   $0x0
  8023ef:	6a 00                	push   $0x0
  8023f1:	6a 00                	push   $0x0
  8023f3:	6a 00                	push   $0x0
  8023f5:	6a 2c                	push   $0x2c
  8023f7:	e8 7b fa ff ff       	call   801e77 <syscall>
  8023fc:	83 c4 18             	add    $0x18,%esp
  8023ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802402:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802406:	75 07                	jne    80240f <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802408:	b8 01 00 00 00       	mov    $0x1,%eax
  80240d:	eb 05                	jmp    802414 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80240f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802414:	c9                   	leave  
  802415:	c3                   	ret    

00802416 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802416:	55                   	push   %ebp
  802417:	89 e5                	mov    %esp,%ebp
  802419:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80241c:	6a 00                	push   $0x0
  80241e:	6a 00                	push   $0x0
  802420:	6a 00                	push   $0x0
  802422:	6a 00                	push   $0x0
  802424:	6a 00                	push   $0x0
  802426:	6a 2c                	push   $0x2c
  802428:	e8 4a fa ff ff       	call   801e77 <syscall>
  80242d:	83 c4 18             	add    $0x18,%esp
  802430:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802433:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802437:	75 07                	jne    802440 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802439:	b8 01 00 00 00       	mov    $0x1,%eax
  80243e:	eb 05                	jmp    802445 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802440:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802445:	c9                   	leave  
  802446:	c3                   	ret    

00802447 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802447:	55                   	push   %ebp
  802448:	89 e5                	mov    %esp,%ebp
  80244a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80244d:	6a 00                	push   $0x0
  80244f:	6a 00                	push   $0x0
  802451:	6a 00                	push   $0x0
  802453:	6a 00                	push   $0x0
  802455:	6a 00                	push   $0x0
  802457:	6a 2c                	push   $0x2c
  802459:	e8 19 fa ff ff       	call   801e77 <syscall>
  80245e:	83 c4 18             	add    $0x18,%esp
  802461:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802464:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802468:	75 07                	jne    802471 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80246a:	b8 01 00 00 00       	mov    $0x1,%eax
  80246f:	eb 05                	jmp    802476 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802471:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802476:	c9                   	leave  
  802477:	c3                   	ret    

00802478 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802478:	55                   	push   %ebp
  802479:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80247b:	6a 00                	push   $0x0
  80247d:	6a 00                	push   $0x0
  80247f:	6a 00                	push   $0x0
  802481:	6a 00                	push   $0x0
  802483:	ff 75 08             	pushl  0x8(%ebp)
  802486:	6a 2d                	push   $0x2d
  802488:	e8 ea f9 ff ff       	call   801e77 <syscall>
  80248d:	83 c4 18             	add    $0x18,%esp
	return ;
  802490:	90                   	nop
}
  802491:	c9                   	leave  
  802492:	c3                   	ret    

00802493 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802493:	55                   	push   %ebp
  802494:	89 e5                	mov    %esp,%ebp
  802496:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802497:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80249a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80249d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a3:	6a 00                	push   $0x0
  8024a5:	53                   	push   %ebx
  8024a6:	51                   	push   %ecx
  8024a7:	52                   	push   %edx
  8024a8:	50                   	push   %eax
  8024a9:	6a 2e                	push   $0x2e
  8024ab:	e8 c7 f9 ff ff       	call   801e77 <syscall>
  8024b0:	83 c4 18             	add    $0x18,%esp
}
  8024b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024b6:	c9                   	leave  
  8024b7:	c3                   	ret    

008024b8 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8024b8:	55                   	push   %ebp
  8024b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8024bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024be:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c1:	6a 00                	push   $0x0
  8024c3:	6a 00                	push   $0x0
  8024c5:	6a 00                	push   $0x0
  8024c7:	52                   	push   %edx
  8024c8:	50                   	push   %eax
  8024c9:	6a 2f                	push   $0x2f
  8024cb:	e8 a7 f9 ff ff       	call   801e77 <syscall>
  8024d0:	83 c4 18             	add    $0x18,%esp
}
  8024d3:	c9                   	leave  
  8024d4:	c3                   	ret    

008024d5 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8024d5:	55                   	push   %ebp
  8024d6:	89 e5                	mov    %esp,%ebp
  8024d8:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8024db:	83 ec 0c             	sub    $0xc,%esp
  8024de:	68 8c 46 80 00       	push   $0x80468c
  8024e3:	e8 cd e6 ff ff       	call   800bb5 <cprintf>
  8024e8:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8024eb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8024f2:	83 ec 0c             	sub    $0xc,%esp
  8024f5:	68 b8 46 80 00       	push   $0x8046b8
  8024fa:	e8 b6 e6 ff ff       	call   800bb5 <cprintf>
  8024ff:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802502:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802506:	a1 38 51 80 00       	mov    0x805138,%eax
  80250b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80250e:	eb 56                	jmp    802566 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802510:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802514:	74 1c                	je     802532 <print_mem_block_lists+0x5d>
  802516:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802519:	8b 50 08             	mov    0x8(%eax),%edx
  80251c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80251f:	8b 48 08             	mov    0x8(%eax),%ecx
  802522:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802525:	8b 40 0c             	mov    0xc(%eax),%eax
  802528:	01 c8                	add    %ecx,%eax
  80252a:	39 c2                	cmp    %eax,%edx
  80252c:	73 04                	jae    802532 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80252e:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802532:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802535:	8b 50 08             	mov    0x8(%eax),%edx
  802538:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253b:	8b 40 0c             	mov    0xc(%eax),%eax
  80253e:	01 c2                	add    %eax,%edx
  802540:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802543:	8b 40 08             	mov    0x8(%eax),%eax
  802546:	83 ec 04             	sub    $0x4,%esp
  802549:	52                   	push   %edx
  80254a:	50                   	push   %eax
  80254b:	68 cd 46 80 00       	push   $0x8046cd
  802550:	e8 60 e6 ff ff       	call   800bb5 <cprintf>
  802555:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802558:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80255e:	a1 40 51 80 00       	mov    0x805140,%eax
  802563:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802566:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80256a:	74 07                	je     802573 <print_mem_block_lists+0x9e>
  80256c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256f:	8b 00                	mov    (%eax),%eax
  802571:	eb 05                	jmp    802578 <print_mem_block_lists+0xa3>
  802573:	b8 00 00 00 00       	mov    $0x0,%eax
  802578:	a3 40 51 80 00       	mov    %eax,0x805140
  80257d:	a1 40 51 80 00       	mov    0x805140,%eax
  802582:	85 c0                	test   %eax,%eax
  802584:	75 8a                	jne    802510 <print_mem_block_lists+0x3b>
  802586:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80258a:	75 84                	jne    802510 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80258c:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802590:	75 10                	jne    8025a2 <print_mem_block_lists+0xcd>
  802592:	83 ec 0c             	sub    $0xc,%esp
  802595:	68 dc 46 80 00       	push   $0x8046dc
  80259a:	e8 16 e6 ff ff       	call   800bb5 <cprintf>
  80259f:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8025a2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8025a9:	83 ec 0c             	sub    $0xc,%esp
  8025ac:	68 00 47 80 00       	push   $0x804700
  8025b1:	e8 ff e5 ff ff       	call   800bb5 <cprintf>
  8025b6:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8025b9:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8025bd:	a1 40 50 80 00       	mov    0x805040,%eax
  8025c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025c5:	eb 56                	jmp    80261d <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8025c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025cb:	74 1c                	je     8025e9 <print_mem_block_lists+0x114>
  8025cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d0:	8b 50 08             	mov    0x8(%eax),%edx
  8025d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d6:	8b 48 08             	mov    0x8(%eax),%ecx
  8025d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8025df:	01 c8                	add    %ecx,%eax
  8025e1:	39 c2                	cmp    %eax,%edx
  8025e3:	73 04                	jae    8025e9 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8025e5:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8025e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ec:	8b 50 08             	mov    0x8(%eax),%edx
  8025ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8025f5:	01 c2                	add    %eax,%edx
  8025f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fa:	8b 40 08             	mov    0x8(%eax),%eax
  8025fd:	83 ec 04             	sub    $0x4,%esp
  802600:	52                   	push   %edx
  802601:	50                   	push   %eax
  802602:	68 cd 46 80 00       	push   $0x8046cd
  802607:	e8 a9 e5 ff ff       	call   800bb5 <cprintf>
  80260c:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80260f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802612:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802615:	a1 48 50 80 00       	mov    0x805048,%eax
  80261a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80261d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802621:	74 07                	je     80262a <print_mem_block_lists+0x155>
  802623:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802626:	8b 00                	mov    (%eax),%eax
  802628:	eb 05                	jmp    80262f <print_mem_block_lists+0x15a>
  80262a:	b8 00 00 00 00       	mov    $0x0,%eax
  80262f:	a3 48 50 80 00       	mov    %eax,0x805048
  802634:	a1 48 50 80 00       	mov    0x805048,%eax
  802639:	85 c0                	test   %eax,%eax
  80263b:	75 8a                	jne    8025c7 <print_mem_block_lists+0xf2>
  80263d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802641:	75 84                	jne    8025c7 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802643:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802647:	75 10                	jne    802659 <print_mem_block_lists+0x184>
  802649:	83 ec 0c             	sub    $0xc,%esp
  80264c:	68 18 47 80 00       	push   $0x804718
  802651:	e8 5f e5 ff ff       	call   800bb5 <cprintf>
  802656:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802659:	83 ec 0c             	sub    $0xc,%esp
  80265c:	68 8c 46 80 00       	push   $0x80468c
  802661:	e8 4f e5 ff ff       	call   800bb5 <cprintf>
  802666:	83 c4 10             	add    $0x10,%esp

}
  802669:	90                   	nop
  80266a:	c9                   	leave  
  80266b:	c3                   	ret    

0080266c <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80266c:	55                   	push   %ebp
  80266d:	89 e5                	mov    %esp,%ebp
  80266f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802672:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802679:	00 00 00 
  80267c:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802683:	00 00 00 
  802686:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80268d:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802690:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802697:	e9 9e 00 00 00       	jmp    80273a <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  80269c:	a1 50 50 80 00       	mov    0x805050,%eax
  8026a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026a4:	c1 e2 04             	shl    $0x4,%edx
  8026a7:	01 d0                	add    %edx,%eax
  8026a9:	85 c0                	test   %eax,%eax
  8026ab:	75 14                	jne    8026c1 <initialize_MemBlocksList+0x55>
  8026ad:	83 ec 04             	sub    $0x4,%esp
  8026b0:	68 40 47 80 00       	push   $0x804740
  8026b5:	6a 46                	push   $0x46
  8026b7:	68 63 47 80 00       	push   $0x804763
  8026bc:	e8 40 e2 ff ff       	call   800901 <_panic>
  8026c1:	a1 50 50 80 00       	mov    0x805050,%eax
  8026c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026c9:	c1 e2 04             	shl    $0x4,%edx
  8026cc:	01 d0                	add    %edx,%eax
  8026ce:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8026d4:	89 10                	mov    %edx,(%eax)
  8026d6:	8b 00                	mov    (%eax),%eax
  8026d8:	85 c0                	test   %eax,%eax
  8026da:	74 18                	je     8026f4 <initialize_MemBlocksList+0x88>
  8026dc:	a1 48 51 80 00       	mov    0x805148,%eax
  8026e1:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8026e7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8026ea:	c1 e1 04             	shl    $0x4,%ecx
  8026ed:	01 ca                	add    %ecx,%edx
  8026ef:	89 50 04             	mov    %edx,0x4(%eax)
  8026f2:	eb 12                	jmp    802706 <initialize_MemBlocksList+0x9a>
  8026f4:	a1 50 50 80 00       	mov    0x805050,%eax
  8026f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026fc:	c1 e2 04             	shl    $0x4,%edx
  8026ff:	01 d0                	add    %edx,%eax
  802701:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802706:	a1 50 50 80 00       	mov    0x805050,%eax
  80270b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80270e:	c1 e2 04             	shl    $0x4,%edx
  802711:	01 d0                	add    %edx,%eax
  802713:	a3 48 51 80 00       	mov    %eax,0x805148
  802718:	a1 50 50 80 00       	mov    0x805050,%eax
  80271d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802720:	c1 e2 04             	shl    $0x4,%edx
  802723:	01 d0                	add    %edx,%eax
  802725:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80272c:	a1 54 51 80 00       	mov    0x805154,%eax
  802731:	40                   	inc    %eax
  802732:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802737:	ff 45 f4             	incl   -0xc(%ebp)
  80273a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802740:	0f 82 56 ff ff ff    	jb     80269c <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802746:	90                   	nop
  802747:	c9                   	leave  
  802748:	c3                   	ret    

00802749 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802749:	55                   	push   %ebp
  80274a:	89 e5                	mov    %esp,%ebp
  80274c:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80274f:	8b 45 08             	mov    0x8(%ebp),%eax
  802752:	8b 00                	mov    (%eax),%eax
  802754:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802757:	eb 19                	jmp    802772 <find_block+0x29>
	{
		if(va==point->sva)
  802759:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80275c:	8b 40 08             	mov    0x8(%eax),%eax
  80275f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802762:	75 05                	jne    802769 <find_block+0x20>
		   return point;
  802764:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802767:	eb 36                	jmp    80279f <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802769:	8b 45 08             	mov    0x8(%ebp),%eax
  80276c:	8b 40 08             	mov    0x8(%eax),%eax
  80276f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802772:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802776:	74 07                	je     80277f <find_block+0x36>
  802778:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80277b:	8b 00                	mov    (%eax),%eax
  80277d:	eb 05                	jmp    802784 <find_block+0x3b>
  80277f:	b8 00 00 00 00       	mov    $0x0,%eax
  802784:	8b 55 08             	mov    0x8(%ebp),%edx
  802787:	89 42 08             	mov    %eax,0x8(%edx)
  80278a:	8b 45 08             	mov    0x8(%ebp),%eax
  80278d:	8b 40 08             	mov    0x8(%eax),%eax
  802790:	85 c0                	test   %eax,%eax
  802792:	75 c5                	jne    802759 <find_block+0x10>
  802794:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802798:	75 bf                	jne    802759 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  80279a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80279f:	c9                   	leave  
  8027a0:	c3                   	ret    

008027a1 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8027a1:	55                   	push   %ebp
  8027a2:	89 e5                	mov    %esp,%ebp
  8027a4:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8027a7:	a1 40 50 80 00       	mov    0x805040,%eax
  8027ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8027af:	a1 44 50 80 00       	mov    0x805044,%eax
  8027b4:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8027b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ba:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8027bd:	74 24                	je     8027e3 <insert_sorted_allocList+0x42>
  8027bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c2:	8b 50 08             	mov    0x8(%eax),%edx
  8027c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c8:	8b 40 08             	mov    0x8(%eax),%eax
  8027cb:	39 c2                	cmp    %eax,%edx
  8027cd:	76 14                	jbe    8027e3 <insert_sorted_allocList+0x42>
  8027cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d2:	8b 50 08             	mov    0x8(%eax),%edx
  8027d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027d8:	8b 40 08             	mov    0x8(%eax),%eax
  8027db:	39 c2                	cmp    %eax,%edx
  8027dd:	0f 82 60 01 00 00    	jb     802943 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8027e3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027e7:	75 65                	jne    80284e <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8027e9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027ed:	75 14                	jne    802803 <insert_sorted_allocList+0x62>
  8027ef:	83 ec 04             	sub    $0x4,%esp
  8027f2:	68 40 47 80 00       	push   $0x804740
  8027f7:	6a 6b                	push   $0x6b
  8027f9:	68 63 47 80 00       	push   $0x804763
  8027fe:	e8 fe e0 ff ff       	call   800901 <_panic>
  802803:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802809:	8b 45 08             	mov    0x8(%ebp),%eax
  80280c:	89 10                	mov    %edx,(%eax)
  80280e:	8b 45 08             	mov    0x8(%ebp),%eax
  802811:	8b 00                	mov    (%eax),%eax
  802813:	85 c0                	test   %eax,%eax
  802815:	74 0d                	je     802824 <insert_sorted_allocList+0x83>
  802817:	a1 40 50 80 00       	mov    0x805040,%eax
  80281c:	8b 55 08             	mov    0x8(%ebp),%edx
  80281f:	89 50 04             	mov    %edx,0x4(%eax)
  802822:	eb 08                	jmp    80282c <insert_sorted_allocList+0x8b>
  802824:	8b 45 08             	mov    0x8(%ebp),%eax
  802827:	a3 44 50 80 00       	mov    %eax,0x805044
  80282c:	8b 45 08             	mov    0x8(%ebp),%eax
  80282f:	a3 40 50 80 00       	mov    %eax,0x805040
  802834:	8b 45 08             	mov    0x8(%ebp),%eax
  802837:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80283e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802843:	40                   	inc    %eax
  802844:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802849:	e9 dc 01 00 00       	jmp    802a2a <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80284e:	8b 45 08             	mov    0x8(%ebp),%eax
  802851:	8b 50 08             	mov    0x8(%eax),%edx
  802854:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802857:	8b 40 08             	mov    0x8(%eax),%eax
  80285a:	39 c2                	cmp    %eax,%edx
  80285c:	77 6c                	ja     8028ca <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80285e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802862:	74 06                	je     80286a <insert_sorted_allocList+0xc9>
  802864:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802868:	75 14                	jne    80287e <insert_sorted_allocList+0xdd>
  80286a:	83 ec 04             	sub    $0x4,%esp
  80286d:	68 7c 47 80 00       	push   $0x80477c
  802872:	6a 6f                	push   $0x6f
  802874:	68 63 47 80 00       	push   $0x804763
  802879:	e8 83 e0 ff ff       	call   800901 <_panic>
  80287e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802881:	8b 50 04             	mov    0x4(%eax),%edx
  802884:	8b 45 08             	mov    0x8(%ebp),%eax
  802887:	89 50 04             	mov    %edx,0x4(%eax)
  80288a:	8b 45 08             	mov    0x8(%ebp),%eax
  80288d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802890:	89 10                	mov    %edx,(%eax)
  802892:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802895:	8b 40 04             	mov    0x4(%eax),%eax
  802898:	85 c0                	test   %eax,%eax
  80289a:	74 0d                	je     8028a9 <insert_sorted_allocList+0x108>
  80289c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80289f:	8b 40 04             	mov    0x4(%eax),%eax
  8028a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8028a5:	89 10                	mov    %edx,(%eax)
  8028a7:	eb 08                	jmp    8028b1 <insert_sorted_allocList+0x110>
  8028a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ac:	a3 40 50 80 00       	mov    %eax,0x805040
  8028b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8028b7:	89 50 04             	mov    %edx,0x4(%eax)
  8028ba:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8028bf:	40                   	inc    %eax
  8028c0:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8028c5:	e9 60 01 00 00       	jmp    802a2a <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8028ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8028cd:	8b 50 08             	mov    0x8(%eax),%edx
  8028d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028d3:	8b 40 08             	mov    0x8(%eax),%eax
  8028d6:	39 c2                	cmp    %eax,%edx
  8028d8:	0f 82 4c 01 00 00    	jb     802a2a <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8028de:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028e2:	75 14                	jne    8028f8 <insert_sorted_allocList+0x157>
  8028e4:	83 ec 04             	sub    $0x4,%esp
  8028e7:	68 b4 47 80 00       	push   $0x8047b4
  8028ec:	6a 73                	push   $0x73
  8028ee:	68 63 47 80 00       	push   $0x804763
  8028f3:	e8 09 e0 ff ff       	call   800901 <_panic>
  8028f8:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8028fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802901:	89 50 04             	mov    %edx,0x4(%eax)
  802904:	8b 45 08             	mov    0x8(%ebp),%eax
  802907:	8b 40 04             	mov    0x4(%eax),%eax
  80290a:	85 c0                	test   %eax,%eax
  80290c:	74 0c                	je     80291a <insert_sorted_allocList+0x179>
  80290e:	a1 44 50 80 00       	mov    0x805044,%eax
  802913:	8b 55 08             	mov    0x8(%ebp),%edx
  802916:	89 10                	mov    %edx,(%eax)
  802918:	eb 08                	jmp    802922 <insert_sorted_allocList+0x181>
  80291a:	8b 45 08             	mov    0x8(%ebp),%eax
  80291d:	a3 40 50 80 00       	mov    %eax,0x805040
  802922:	8b 45 08             	mov    0x8(%ebp),%eax
  802925:	a3 44 50 80 00       	mov    %eax,0x805044
  80292a:	8b 45 08             	mov    0x8(%ebp),%eax
  80292d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802933:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802938:	40                   	inc    %eax
  802939:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80293e:	e9 e7 00 00 00       	jmp    802a2a <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802943:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802946:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802949:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802950:	a1 40 50 80 00       	mov    0x805040,%eax
  802955:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802958:	e9 9d 00 00 00       	jmp    8029fa <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80295d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802960:	8b 00                	mov    (%eax),%eax
  802962:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802965:	8b 45 08             	mov    0x8(%ebp),%eax
  802968:	8b 50 08             	mov    0x8(%eax),%edx
  80296b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296e:	8b 40 08             	mov    0x8(%eax),%eax
  802971:	39 c2                	cmp    %eax,%edx
  802973:	76 7d                	jbe    8029f2 <insert_sorted_allocList+0x251>
  802975:	8b 45 08             	mov    0x8(%ebp),%eax
  802978:	8b 50 08             	mov    0x8(%eax),%edx
  80297b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80297e:	8b 40 08             	mov    0x8(%eax),%eax
  802981:	39 c2                	cmp    %eax,%edx
  802983:	73 6d                	jae    8029f2 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802985:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802989:	74 06                	je     802991 <insert_sorted_allocList+0x1f0>
  80298b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80298f:	75 14                	jne    8029a5 <insert_sorted_allocList+0x204>
  802991:	83 ec 04             	sub    $0x4,%esp
  802994:	68 d8 47 80 00       	push   $0x8047d8
  802999:	6a 7f                	push   $0x7f
  80299b:	68 63 47 80 00       	push   $0x804763
  8029a0:	e8 5c df ff ff       	call   800901 <_panic>
  8029a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a8:	8b 10                	mov    (%eax),%edx
  8029aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ad:	89 10                	mov    %edx,(%eax)
  8029af:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b2:	8b 00                	mov    (%eax),%eax
  8029b4:	85 c0                	test   %eax,%eax
  8029b6:	74 0b                	je     8029c3 <insert_sorted_allocList+0x222>
  8029b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bb:	8b 00                	mov    (%eax),%eax
  8029bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8029c0:	89 50 04             	mov    %edx,0x4(%eax)
  8029c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8029c9:	89 10                	mov    %edx,(%eax)
  8029cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029d1:	89 50 04             	mov    %edx,0x4(%eax)
  8029d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d7:	8b 00                	mov    (%eax),%eax
  8029d9:	85 c0                	test   %eax,%eax
  8029db:	75 08                	jne    8029e5 <insert_sorted_allocList+0x244>
  8029dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e0:	a3 44 50 80 00       	mov    %eax,0x805044
  8029e5:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029ea:	40                   	inc    %eax
  8029eb:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8029f0:	eb 39                	jmp    802a2b <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8029f2:	a1 48 50 80 00       	mov    0x805048,%eax
  8029f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029fe:	74 07                	je     802a07 <insert_sorted_allocList+0x266>
  802a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a03:	8b 00                	mov    (%eax),%eax
  802a05:	eb 05                	jmp    802a0c <insert_sorted_allocList+0x26b>
  802a07:	b8 00 00 00 00       	mov    $0x0,%eax
  802a0c:	a3 48 50 80 00       	mov    %eax,0x805048
  802a11:	a1 48 50 80 00       	mov    0x805048,%eax
  802a16:	85 c0                	test   %eax,%eax
  802a18:	0f 85 3f ff ff ff    	jne    80295d <insert_sorted_allocList+0x1bc>
  802a1e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a22:	0f 85 35 ff ff ff    	jne    80295d <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802a28:	eb 01                	jmp    802a2b <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802a2a:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802a2b:	90                   	nop
  802a2c:	c9                   	leave  
  802a2d:	c3                   	ret    

00802a2e <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802a2e:	55                   	push   %ebp
  802a2f:	89 e5                	mov    %esp,%ebp
  802a31:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802a34:	a1 38 51 80 00       	mov    0x805138,%eax
  802a39:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a3c:	e9 85 01 00 00       	jmp    802bc6 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802a41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a44:	8b 40 0c             	mov    0xc(%eax),%eax
  802a47:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a4a:	0f 82 6e 01 00 00    	jb     802bbe <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a53:	8b 40 0c             	mov    0xc(%eax),%eax
  802a56:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a59:	0f 85 8a 00 00 00    	jne    802ae9 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802a5f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a63:	75 17                	jne    802a7c <alloc_block_FF+0x4e>
  802a65:	83 ec 04             	sub    $0x4,%esp
  802a68:	68 0c 48 80 00       	push   $0x80480c
  802a6d:	68 93 00 00 00       	push   $0x93
  802a72:	68 63 47 80 00       	push   $0x804763
  802a77:	e8 85 de ff ff       	call   800901 <_panic>
  802a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7f:	8b 00                	mov    (%eax),%eax
  802a81:	85 c0                	test   %eax,%eax
  802a83:	74 10                	je     802a95 <alloc_block_FF+0x67>
  802a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a88:	8b 00                	mov    (%eax),%eax
  802a8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a8d:	8b 52 04             	mov    0x4(%edx),%edx
  802a90:	89 50 04             	mov    %edx,0x4(%eax)
  802a93:	eb 0b                	jmp    802aa0 <alloc_block_FF+0x72>
  802a95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a98:	8b 40 04             	mov    0x4(%eax),%eax
  802a9b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa3:	8b 40 04             	mov    0x4(%eax),%eax
  802aa6:	85 c0                	test   %eax,%eax
  802aa8:	74 0f                	je     802ab9 <alloc_block_FF+0x8b>
  802aaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aad:	8b 40 04             	mov    0x4(%eax),%eax
  802ab0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ab3:	8b 12                	mov    (%edx),%edx
  802ab5:	89 10                	mov    %edx,(%eax)
  802ab7:	eb 0a                	jmp    802ac3 <alloc_block_FF+0x95>
  802ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abc:	8b 00                	mov    (%eax),%eax
  802abe:	a3 38 51 80 00       	mov    %eax,0x805138
  802ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ad6:	a1 44 51 80 00       	mov    0x805144,%eax
  802adb:	48                   	dec    %eax
  802adc:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae4:	e9 10 01 00 00       	jmp    802bf9 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aec:	8b 40 0c             	mov    0xc(%eax),%eax
  802aef:	3b 45 08             	cmp    0x8(%ebp),%eax
  802af2:	0f 86 c6 00 00 00    	jbe    802bbe <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802af8:	a1 48 51 80 00       	mov    0x805148,%eax
  802afd:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b03:	8b 50 08             	mov    0x8(%eax),%edx
  802b06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b09:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802b0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b0f:	8b 55 08             	mov    0x8(%ebp),%edx
  802b12:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b15:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b19:	75 17                	jne    802b32 <alloc_block_FF+0x104>
  802b1b:	83 ec 04             	sub    $0x4,%esp
  802b1e:	68 0c 48 80 00       	push   $0x80480c
  802b23:	68 9b 00 00 00       	push   $0x9b
  802b28:	68 63 47 80 00       	push   $0x804763
  802b2d:	e8 cf dd ff ff       	call   800901 <_panic>
  802b32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b35:	8b 00                	mov    (%eax),%eax
  802b37:	85 c0                	test   %eax,%eax
  802b39:	74 10                	je     802b4b <alloc_block_FF+0x11d>
  802b3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b3e:	8b 00                	mov    (%eax),%eax
  802b40:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b43:	8b 52 04             	mov    0x4(%edx),%edx
  802b46:	89 50 04             	mov    %edx,0x4(%eax)
  802b49:	eb 0b                	jmp    802b56 <alloc_block_FF+0x128>
  802b4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b4e:	8b 40 04             	mov    0x4(%eax),%eax
  802b51:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b59:	8b 40 04             	mov    0x4(%eax),%eax
  802b5c:	85 c0                	test   %eax,%eax
  802b5e:	74 0f                	je     802b6f <alloc_block_FF+0x141>
  802b60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b63:	8b 40 04             	mov    0x4(%eax),%eax
  802b66:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b69:	8b 12                	mov    (%edx),%edx
  802b6b:	89 10                	mov    %edx,(%eax)
  802b6d:	eb 0a                	jmp    802b79 <alloc_block_FF+0x14b>
  802b6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b72:	8b 00                	mov    (%eax),%eax
  802b74:	a3 48 51 80 00       	mov    %eax,0x805148
  802b79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b7c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b85:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b8c:	a1 54 51 80 00       	mov    0x805154,%eax
  802b91:	48                   	dec    %eax
  802b92:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802b97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9a:	8b 50 08             	mov    0x8(%eax),%edx
  802b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba0:	01 c2                	add    %eax,%edx
  802ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba5:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802ba8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bab:	8b 40 0c             	mov    0xc(%eax),%eax
  802bae:	2b 45 08             	sub    0x8(%ebp),%eax
  802bb1:	89 c2                	mov    %eax,%edx
  802bb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb6:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802bb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bbc:	eb 3b                	jmp    802bf9 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802bbe:	a1 40 51 80 00       	mov    0x805140,%eax
  802bc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bc6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bca:	74 07                	je     802bd3 <alloc_block_FF+0x1a5>
  802bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcf:	8b 00                	mov    (%eax),%eax
  802bd1:	eb 05                	jmp    802bd8 <alloc_block_FF+0x1aa>
  802bd3:	b8 00 00 00 00       	mov    $0x0,%eax
  802bd8:	a3 40 51 80 00       	mov    %eax,0x805140
  802bdd:	a1 40 51 80 00       	mov    0x805140,%eax
  802be2:	85 c0                	test   %eax,%eax
  802be4:	0f 85 57 fe ff ff    	jne    802a41 <alloc_block_FF+0x13>
  802bea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bee:	0f 85 4d fe ff ff    	jne    802a41 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802bf4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bf9:	c9                   	leave  
  802bfa:	c3                   	ret    

00802bfb <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802bfb:	55                   	push   %ebp
  802bfc:	89 e5                	mov    %esp,%ebp
  802bfe:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802c01:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802c08:	a1 38 51 80 00       	mov    0x805138,%eax
  802c0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c10:	e9 df 00 00 00       	jmp    802cf4 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802c15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c18:	8b 40 0c             	mov    0xc(%eax),%eax
  802c1b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c1e:	0f 82 c8 00 00 00    	jb     802cec <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802c24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c27:	8b 40 0c             	mov    0xc(%eax),%eax
  802c2a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c2d:	0f 85 8a 00 00 00    	jne    802cbd <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802c33:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c37:	75 17                	jne    802c50 <alloc_block_BF+0x55>
  802c39:	83 ec 04             	sub    $0x4,%esp
  802c3c:	68 0c 48 80 00       	push   $0x80480c
  802c41:	68 b7 00 00 00       	push   $0xb7
  802c46:	68 63 47 80 00       	push   $0x804763
  802c4b:	e8 b1 dc ff ff       	call   800901 <_panic>
  802c50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c53:	8b 00                	mov    (%eax),%eax
  802c55:	85 c0                	test   %eax,%eax
  802c57:	74 10                	je     802c69 <alloc_block_BF+0x6e>
  802c59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5c:	8b 00                	mov    (%eax),%eax
  802c5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c61:	8b 52 04             	mov    0x4(%edx),%edx
  802c64:	89 50 04             	mov    %edx,0x4(%eax)
  802c67:	eb 0b                	jmp    802c74 <alloc_block_BF+0x79>
  802c69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6c:	8b 40 04             	mov    0x4(%eax),%eax
  802c6f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c77:	8b 40 04             	mov    0x4(%eax),%eax
  802c7a:	85 c0                	test   %eax,%eax
  802c7c:	74 0f                	je     802c8d <alloc_block_BF+0x92>
  802c7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c81:	8b 40 04             	mov    0x4(%eax),%eax
  802c84:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c87:	8b 12                	mov    (%edx),%edx
  802c89:	89 10                	mov    %edx,(%eax)
  802c8b:	eb 0a                	jmp    802c97 <alloc_block_BF+0x9c>
  802c8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c90:	8b 00                	mov    (%eax),%eax
  802c92:	a3 38 51 80 00       	mov    %eax,0x805138
  802c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ca0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802caa:	a1 44 51 80 00       	mov    0x805144,%eax
  802caf:	48                   	dec    %eax
  802cb0:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802cb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb8:	e9 4d 01 00 00       	jmp    802e0a <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802cbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc0:	8b 40 0c             	mov    0xc(%eax),%eax
  802cc3:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cc6:	76 24                	jbe    802cec <alloc_block_BF+0xf1>
  802cc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccb:	8b 40 0c             	mov    0xc(%eax),%eax
  802cce:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802cd1:	73 19                	jae    802cec <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802cd3:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802cda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdd:	8b 40 0c             	mov    0xc(%eax),%eax
  802ce0:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802ce3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce6:	8b 40 08             	mov    0x8(%eax),%eax
  802ce9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802cec:	a1 40 51 80 00       	mov    0x805140,%eax
  802cf1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cf4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cf8:	74 07                	je     802d01 <alloc_block_BF+0x106>
  802cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfd:	8b 00                	mov    (%eax),%eax
  802cff:	eb 05                	jmp    802d06 <alloc_block_BF+0x10b>
  802d01:	b8 00 00 00 00       	mov    $0x0,%eax
  802d06:	a3 40 51 80 00       	mov    %eax,0x805140
  802d0b:	a1 40 51 80 00       	mov    0x805140,%eax
  802d10:	85 c0                	test   %eax,%eax
  802d12:	0f 85 fd fe ff ff    	jne    802c15 <alloc_block_BF+0x1a>
  802d18:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d1c:	0f 85 f3 fe ff ff    	jne    802c15 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802d22:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d26:	0f 84 d9 00 00 00    	je     802e05 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d2c:	a1 48 51 80 00       	mov    0x805148,%eax
  802d31:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802d34:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d37:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d3a:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802d3d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d40:	8b 55 08             	mov    0x8(%ebp),%edx
  802d43:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802d46:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802d4a:	75 17                	jne    802d63 <alloc_block_BF+0x168>
  802d4c:	83 ec 04             	sub    $0x4,%esp
  802d4f:	68 0c 48 80 00       	push   $0x80480c
  802d54:	68 c7 00 00 00       	push   $0xc7
  802d59:	68 63 47 80 00       	push   $0x804763
  802d5e:	e8 9e db ff ff       	call   800901 <_panic>
  802d63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d66:	8b 00                	mov    (%eax),%eax
  802d68:	85 c0                	test   %eax,%eax
  802d6a:	74 10                	je     802d7c <alloc_block_BF+0x181>
  802d6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d6f:	8b 00                	mov    (%eax),%eax
  802d71:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d74:	8b 52 04             	mov    0x4(%edx),%edx
  802d77:	89 50 04             	mov    %edx,0x4(%eax)
  802d7a:	eb 0b                	jmp    802d87 <alloc_block_BF+0x18c>
  802d7c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d7f:	8b 40 04             	mov    0x4(%eax),%eax
  802d82:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d8a:	8b 40 04             	mov    0x4(%eax),%eax
  802d8d:	85 c0                	test   %eax,%eax
  802d8f:	74 0f                	je     802da0 <alloc_block_BF+0x1a5>
  802d91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d94:	8b 40 04             	mov    0x4(%eax),%eax
  802d97:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d9a:	8b 12                	mov    (%edx),%edx
  802d9c:	89 10                	mov    %edx,(%eax)
  802d9e:	eb 0a                	jmp    802daa <alloc_block_BF+0x1af>
  802da0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802da3:	8b 00                	mov    (%eax),%eax
  802da5:	a3 48 51 80 00       	mov    %eax,0x805148
  802daa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802db3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802db6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dbd:	a1 54 51 80 00       	mov    0x805154,%eax
  802dc2:	48                   	dec    %eax
  802dc3:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802dc8:	83 ec 08             	sub    $0x8,%esp
  802dcb:	ff 75 ec             	pushl  -0x14(%ebp)
  802dce:	68 38 51 80 00       	push   $0x805138
  802dd3:	e8 71 f9 ff ff       	call   802749 <find_block>
  802dd8:	83 c4 10             	add    $0x10,%esp
  802ddb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802dde:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802de1:	8b 50 08             	mov    0x8(%eax),%edx
  802de4:	8b 45 08             	mov    0x8(%ebp),%eax
  802de7:	01 c2                	add    %eax,%edx
  802de9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dec:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802def:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802df2:	8b 40 0c             	mov    0xc(%eax),%eax
  802df5:	2b 45 08             	sub    0x8(%ebp),%eax
  802df8:	89 c2                	mov    %eax,%edx
  802dfa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dfd:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802e00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e03:	eb 05                	jmp    802e0a <alloc_block_BF+0x20f>
	}
	return NULL;
  802e05:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e0a:	c9                   	leave  
  802e0b:	c3                   	ret    

00802e0c <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802e0c:	55                   	push   %ebp
  802e0d:	89 e5                	mov    %esp,%ebp
  802e0f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802e12:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e17:	85 c0                	test   %eax,%eax
  802e19:	0f 85 de 01 00 00    	jne    802ffd <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802e1f:	a1 38 51 80 00       	mov    0x805138,%eax
  802e24:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e27:	e9 9e 01 00 00       	jmp    802fca <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802e2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2f:	8b 40 0c             	mov    0xc(%eax),%eax
  802e32:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e35:	0f 82 87 01 00 00    	jb     802fc2 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802e3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3e:	8b 40 0c             	mov    0xc(%eax),%eax
  802e41:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e44:	0f 85 95 00 00 00    	jne    802edf <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802e4a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e4e:	75 17                	jne    802e67 <alloc_block_NF+0x5b>
  802e50:	83 ec 04             	sub    $0x4,%esp
  802e53:	68 0c 48 80 00       	push   $0x80480c
  802e58:	68 e0 00 00 00       	push   $0xe0
  802e5d:	68 63 47 80 00       	push   $0x804763
  802e62:	e8 9a da ff ff       	call   800901 <_panic>
  802e67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6a:	8b 00                	mov    (%eax),%eax
  802e6c:	85 c0                	test   %eax,%eax
  802e6e:	74 10                	je     802e80 <alloc_block_NF+0x74>
  802e70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e73:	8b 00                	mov    (%eax),%eax
  802e75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e78:	8b 52 04             	mov    0x4(%edx),%edx
  802e7b:	89 50 04             	mov    %edx,0x4(%eax)
  802e7e:	eb 0b                	jmp    802e8b <alloc_block_NF+0x7f>
  802e80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e83:	8b 40 04             	mov    0x4(%eax),%eax
  802e86:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8e:	8b 40 04             	mov    0x4(%eax),%eax
  802e91:	85 c0                	test   %eax,%eax
  802e93:	74 0f                	je     802ea4 <alloc_block_NF+0x98>
  802e95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e98:	8b 40 04             	mov    0x4(%eax),%eax
  802e9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e9e:	8b 12                	mov    (%edx),%edx
  802ea0:	89 10                	mov    %edx,(%eax)
  802ea2:	eb 0a                	jmp    802eae <alloc_block_NF+0xa2>
  802ea4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea7:	8b 00                	mov    (%eax),%eax
  802ea9:	a3 38 51 80 00       	mov    %eax,0x805138
  802eae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ec1:	a1 44 51 80 00       	mov    0x805144,%eax
  802ec6:	48                   	dec    %eax
  802ec7:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802ecc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecf:	8b 40 08             	mov    0x8(%eax),%eax
  802ed2:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   return  point;
  802ed7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eda:	e9 f8 04 00 00       	jmp    8033d7 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802edf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee2:	8b 40 0c             	mov    0xc(%eax),%eax
  802ee5:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ee8:	0f 86 d4 00 00 00    	jbe    802fc2 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802eee:	a1 48 51 80 00       	mov    0x805148,%eax
  802ef3:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802ef6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef9:	8b 50 08             	mov    0x8(%eax),%edx
  802efc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eff:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802f02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f05:	8b 55 08             	mov    0x8(%ebp),%edx
  802f08:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802f0b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f0f:	75 17                	jne    802f28 <alloc_block_NF+0x11c>
  802f11:	83 ec 04             	sub    $0x4,%esp
  802f14:	68 0c 48 80 00       	push   $0x80480c
  802f19:	68 e9 00 00 00       	push   $0xe9
  802f1e:	68 63 47 80 00       	push   $0x804763
  802f23:	e8 d9 d9 ff ff       	call   800901 <_panic>
  802f28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f2b:	8b 00                	mov    (%eax),%eax
  802f2d:	85 c0                	test   %eax,%eax
  802f2f:	74 10                	je     802f41 <alloc_block_NF+0x135>
  802f31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f34:	8b 00                	mov    (%eax),%eax
  802f36:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f39:	8b 52 04             	mov    0x4(%edx),%edx
  802f3c:	89 50 04             	mov    %edx,0x4(%eax)
  802f3f:	eb 0b                	jmp    802f4c <alloc_block_NF+0x140>
  802f41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f44:	8b 40 04             	mov    0x4(%eax),%eax
  802f47:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f4f:	8b 40 04             	mov    0x4(%eax),%eax
  802f52:	85 c0                	test   %eax,%eax
  802f54:	74 0f                	je     802f65 <alloc_block_NF+0x159>
  802f56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f59:	8b 40 04             	mov    0x4(%eax),%eax
  802f5c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f5f:	8b 12                	mov    (%edx),%edx
  802f61:	89 10                	mov    %edx,(%eax)
  802f63:	eb 0a                	jmp    802f6f <alloc_block_NF+0x163>
  802f65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f68:	8b 00                	mov    (%eax),%eax
  802f6a:	a3 48 51 80 00       	mov    %eax,0x805148
  802f6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f72:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f7b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f82:	a1 54 51 80 00       	mov    0x805154,%eax
  802f87:	48                   	dec    %eax
  802f88:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802f8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f90:	8b 40 08             	mov    0x8(%eax),%eax
  802f93:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   point->sva += size;
  802f98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9b:	8b 50 08             	mov    0x8(%eax),%edx
  802f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa1:	01 c2                	add    %eax,%edx
  802fa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa6:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802fa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fac:	8b 40 0c             	mov    0xc(%eax),%eax
  802faf:	2b 45 08             	sub    0x8(%ebp),%eax
  802fb2:	89 c2                	mov    %eax,%edx
  802fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb7:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802fba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fbd:	e9 15 04 00 00       	jmp    8033d7 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802fc2:	a1 40 51 80 00       	mov    0x805140,%eax
  802fc7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fce:	74 07                	je     802fd7 <alloc_block_NF+0x1cb>
  802fd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd3:	8b 00                	mov    (%eax),%eax
  802fd5:	eb 05                	jmp    802fdc <alloc_block_NF+0x1d0>
  802fd7:	b8 00 00 00 00       	mov    $0x0,%eax
  802fdc:	a3 40 51 80 00       	mov    %eax,0x805140
  802fe1:	a1 40 51 80 00       	mov    0x805140,%eax
  802fe6:	85 c0                	test   %eax,%eax
  802fe8:	0f 85 3e fe ff ff    	jne    802e2c <alloc_block_NF+0x20>
  802fee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ff2:	0f 85 34 fe ff ff    	jne    802e2c <alloc_block_NF+0x20>
  802ff8:	e9 d5 03 00 00       	jmp    8033d2 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802ffd:	a1 38 51 80 00       	mov    0x805138,%eax
  803002:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803005:	e9 b1 01 00 00       	jmp    8031bb <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  80300a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300d:	8b 50 08             	mov    0x8(%eax),%edx
  803010:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803015:	39 c2                	cmp    %eax,%edx
  803017:	0f 82 96 01 00 00    	jb     8031b3 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  80301d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803020:	8b 40 0c             	mov    0xc(%eax),%eax
  803023:	3b 45 08             	cmp    0x8(%ebp),%eax
  803026:	0f 82 87 01 00 00    	jb     8031b3 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  80302c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302f:	8b 40 0c             	mov    0xc(%eax),%eax
  803032:	3b 45 08             	cmp    0x8(%ebp),%eax
  803035:	0f 85 95 00 00 00    	jne    8030d0 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80303b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80303f:	75 17                	jne    803058 <alloc_block_NF+0x24c>
  803041:	83 ec 04             	sub    $0x4,%esp
  803044:	68 0c 48 80 00       	push   $0x80480c
  803049:	68 fc 00 00 00       	push   $0xfc
  80304e:	68 63 47 80 00       	push   $0x804763
  803053:	e8 a9 d8 ff ff       	call   800901 <_panic>
  803058:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305b:	8b 00                	mov    (%eax),%eax
  80305d:	85 c0                	test   %eax,%eax
  80305f:	74 10                	je     803071 <alloc_block_NF+0x265>
  803061:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803064:	8b 00                	mov    (%eax),%eax
  803066:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803069:	8b 52 04             	mov    0x4(%edx),%edx
  80306c:	89 50 04             	mov    %edx,0x4(%eax)
  80306f:	eb 0b                	jmp    80307c <alloc_block_NF+0x270>
  803071:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803074:	8b 40 04             	mov    0x4(%eax),%eax
  803077:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80307c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307f:	8b 40 04             	mov    0x4(%eax),%eax
  803082:	85 c0                	test   %eax,%eax
  803084:	74 0f                	je     803095 <alloc_block_NF+0x289>
  803086:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803089:	8b 40 04             	mov    0x4(%eax),%eax
  80308c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80308f:	8b 12                	mov    (%edx),%edx
  803091:	89 10                	mov    %edx,(%eax)
  803093:	eb 0a                	jmp    80309f <alloc_block_NF+0x293>
  803095:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803098:	8b 00                	mov    (%eax),%eax
  80309a:	a3 38 51 80 00       	mov    %eax,0x805138
  80309f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030b2:	a1 44 51 80 00       	mov    0x805144,%eax
  8030b7:	48                   	dec    %eax
  8030b8:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8030bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c0:	8b 40 08             	mov    0x8(%eax),%eax
  8030c3:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  8030c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030cb:	e9 07 03 00 00       	jmp    8033d7 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8030d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8030d6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030d9:	0f 86 d4 00 00 00    	jbe    8031b3 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8030df:	a1 48 51 80 00       	mov    0x805148,%eax
  8030e4:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8030e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ea:	8b 50 08             	mov    0x8(%eax),%edx
  8030ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f0:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8030f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8030f9:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8030fc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803100:	75 17                	jne    803119 <alloc_block_NF+0x30d>
  803102:	83 ec 04             	sub    $0x4,%esp
  803105:	68 0c 48 80 00       	push   $0x80480c
  80310a:	68 04 01 00 00       	push   $0x104
  80310f:	68 63 47 80 00       	push   $0x804763
  803114:	e8 e8 d7 ff ff       	call   800901 <_panic>
  803119:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80311c:	8b 00                	mov    (%eax),%eax
  80311e:	85 c0                	test   %eax,%eax
  803120:	74 10                	je     803132 <alloc_block_NF+0x326>
  803122:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803125:	8b 00                	mov    (%eax),%eax
  803127:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80312a:	8b 52 04             	mov    0x4(%edx),%edx
  80312d:	89 50 04             	mov    %edx,0x4(%eax)
  803130:	eb 0b                	jmp    80313d <alloc_block_NF+0x331>
  803132:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803135:	8b 40 04             	mov    0x4(%eax),%eax
  803138:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80313d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803140:	8b 40 04             	mov    0x4(%eax),%eax
  803143:	85 c0                	test   %eax,%eax
  803145:	74 0f                	je     803156 <alloc_block_NF+0x34a>
  803147:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80314a:	8b 40 04             	mov    0x4(%eax),%eax
  80314d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803150:	8b 12                	mov    (%edx),%edx
  803152:	89 10                	mov    %edx,(%eax)
  803154:	eb 0a                	jmp    803160 <alloc_block_NF+0x354>
  803156:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803159:	8b 00                	mov    (%eax),%eax
  80315b:	a3 48 51 80 00       	mov    %eax,0x805148
  803160:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803163:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803169:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80316c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803173:	a1 54 51 80 00       	mov    0x805154,%eax
  803178:	48                   	dec    %eax
  803179:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  80317e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803181:	8b 40 08             	mov    0x8(%eax),%eax
  803184:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  803189:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318c:	8b 50 08             	mov    0x8(%eax),%edx
  80318f:	8b 45 08             	mov    0x8(%ebp),%eax
  803192:	01 c2                	add    %eax,%edx
  803194:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803197:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80319a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319d:	8b 40 0c             	mov    0xc(%eax),%eax
  8031a0:	2b 45 08             	sub    0x8(%ebp),%eax
  8031a3:	89 c2                	mov    %eax,%edx
  8031a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a8:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8031ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ae:	e9 24 02 00 00       	jmp    8033d7 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8031b3:	a1 40 51 80 00       	mov    0x805140,%eax
  8031b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031bf:	74 07                	je     8031c8 <alloc_block_NF+0x3bc>
  8031c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c4:	8b 00                	mov    (%eax),%eax
  8031c6:	eb 05                	jmp    8031cd <alloc_block_NF+0x3c1>
  8031c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8031cd:	a3 40 51 80 00       	mov    %eax,0x805140
  8031d2:	a1 40 51 80 00       	mov    0x805140,%eax
  8031d7:	85 c0                	test   %eax,%eax
  8031d9:	0f 85 2b fe ff ff    	jne    80300a <alloc_block_NF+0x1fe>
  8031df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031e3:	0f 85 21 fe ff ff    	jne    80300a <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8031e9:	a1 38 51 80 00       	mov    0x805138,%eax
  8031ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031f1:	e9 ae 01 00 00       	jmp    8033a4 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8031f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f9:	8b 50 08             	mov    0x8(%eax),%edx
  8031fc:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803201:	39 c2                	cmp    %eax,%edx
  803203:	0f 83 93 01 00 00    	jae    80339c <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  803209:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320c:	8b 40 0c             	mov    0xc(%eax),%eax
  80320f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803212:	0f 82 84 01 00 00    	jb     80339c <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  803218:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80321b:	8b 40 0c             	mov    0xc(%eax),%eax
  80321e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803221:	0f 85 95 00 00 00    	jne    8032bc <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803227:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80322b:	75 17                	jne    803244 <alloc_block_NF+0x438>
  80322d:	83 ec 04             	sub    $0x4,%esp
  803230:	68 0c 48 80 00       	push   $0x80480c
  803235:	68 14 01 00 00       	push   $0x114
  80323a:	68 63 47 80 00       	push   $0x804763
  80323f:	e8 bd d6 ff ff       	call   800901 <_panic>
  803244:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803247:	8b 00                	mov    (%eax),%eax
  803249:	85 c0                	test   %eax,%eax
  80324b:	74 10                	je     80325d <alloc_block_NF+0x451>
  80324d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803250:	8b 00                	mov    (%eax),%eax
  803252:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803255:	8b 52 04             	mov    0x4(%edx),%edx
  803258:	89 50 04             	mov    %edx,0x4(%eax)
  80325b:	eb 0b                	jmp    803268 <alloc_block_NF+0x45c>
  80325d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803260:	8b 40 04             	mov    0x4(%eax),%eax
  803263:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803268:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326b:	8b 40 04             	mov    0x4(%eax),%eax
  80326e:	85 c0                	test   %eax,%eax
  803270:	74 0f                	je     803281 <alloc_block_NF+0x475>
  803272:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803275:	8b 40 04             	mov    0x4(%eax),%eax
  803278:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80327b:	8b 12                	mov    (%edx),%edx
  80327d:	89 10                	mov    %edx,(%eax)
  80327f:	eb 0a                	jmp    80328b <alloc_block_NF+0x47f>
  803281:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803284:	8b 00                	mov    (%eax),%eax
  803286:	a3 38 51 80 00       	mov    %eax,0x805138
  80328b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803294:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803297:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80329e:	a1 44 51 80 00       	mov    0x805144,%eax
  8032a3:	48                   	dec    %eax
  8032a4:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8032a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ac:	8b 40 08             	mov    0x8(%eax),%eax
  8032af:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  8032b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b7:	e9 1b 01 00 00       	jmp    8033d7 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8032bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8032c2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032c5:	0f 86 d1 00 00 00    	jbe    80339c <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8032cb:	a1 48 51 80 00       	mov    0x805148,%eax
  8032d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  8032d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d6:	8b 50 08             	mov    0x8(%eax),%edx
  8032d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032dc:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8032df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8032e5:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8032e8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8032ec:	75 17                	jne    803305 <alloc_block_NF+0x4f9>
  8032ee:	83 ec 04             	sub    $0x4,%esp
  8032f1:	68 0c 48 80 00       	push   $0x80480c
  8032f6:	68 1c 01 00 00       	push   $0x11c
  8032fb:	68 63 47 80 00       	push   $0x804763
  803300:	e8 fc d5 ff ff       	call   800901 <_panic>
  803305:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803308:	8b 00                	mov    (%eax),%eax
  80330a:	85 c0                	test   %eax,%eax
  80330c:	74 10                	je     80331e <alloc_block_NF+0x512>
  80330e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803311:	8b 00                	mov    (%eax),%eax
  803313:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803316:	8b 52 04             	mov    0x4(%edx),%edx
  803319:	89 50 04             	mov    %edx,0x4(%eax)
  80331c:	eb 0b                	jmp    803329 <alloc_block_NF+0x51d>
  80331e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803321:	8b 40 04             	mov    0x4(%eax),%eax
  803324:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803329:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80332c:	8b 40 04             	mov    0x4(%eax),%eax
  80332f:	85 c0                	test   %eax,%eax
  803331:	74 0f                	je     803342 <alloc_block_NF+0x536>
  803333:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803336:	8b 40 04             	mov    0x4(%eax),%eax
  803339:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80333c:	8b 12                	mov    (%edx),%edx
  80333e:	89 10                	mov    %edx,(%eax)
  803340:	eb 0a                	jmp    80334c <alloc_block_NF+0x540>
  803342:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803345:	8b 00                	mov    (%eax),%eax
  803347:	a3 48 51 80 00       	mov    %eax,0x805148
  80334c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80334f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803355:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803358:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80335f:	a1 54 51 80 00       	mov    0x805154,%eax
  803364:	48                   	dec    %eax
  803365:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  80336a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80336d:	8b 40 08             	mov    0x8(%eax),%eax
  803370:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  803375:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803378:	8b 50 08             	mov    0x8(%eax),%edx
  80337b:	8b 45 08             	mov    0x8(%ebp),%eax
  80337e:	01 c2                	add    %eax,%edx
  803380:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803383:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803386:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803389:	8b 40 0c             	mov    0xc(%eax),%eax
  80338c:	2b 45 08             	sub    0x8(%ebp),%eax
  80338f:	89 c2                	mov    %eax,%edx
  803391:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803394:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803397:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80339a:	eb 3b                	jmp    8033d7 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  80339c:	a1 40 51 80 00       	mov    0x805140,%eax
  8033a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033a8:	74 07                	je     8033b1 <alloc_block_NF+0x5a5>
  8033aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ad:	8b 00                	mov    (%eax),%eax
  8033af:	eb 05                	jmp    8033b6 <alloc_block_NF+0x5aa>
  8033b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8033b6:	a3 40 51 80 00       	mov    %eax,0x805140
  8033bb:	a1 40 51 80 00       	mov    0x805140,%eax
  8033c0:	85 c0                	test   %eax,%eax
  8033c2:	0f 85 2e fe ff ff    	jne    8031f6 <alloc_block_NF+0x3ea>
  8033c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033cc:	0f 85 24 fe ff ff    	jne    8031f6 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  8033d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033d7:	c9                   	leave  
  8033d8:	c3                   	ret    

008033d9 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8033d9:	55                   	push   %ebp
  8033da:	89 e5                	mov    %esp,%ebp
  8033dc:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  8033df:	a1 38 51 80 00       	mov    0x805138,%eax
  8033e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  8033e7:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8033ec:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  8033ef:	a1 38 51 80 00       	mov    0x805138,%eax
  8033f4:	85 c0                	test   %eax,%eax
  8033f6:	74 14                	je     80340c <insert_sorted_with_merge_freeList+0x33>
  8033f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fb:	8b 50 08             	mov    0x8(%eax),%edx
  8033fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803401:	8b 40 08             	mov    0x8(%eax),%eax
  803404:	39 c2                	cmp    %eax,%edx
  803406:	0f 87 9b 01 00 00    	ja     8035a7 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  80340c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803410:	75 17                	jne    803429 <insert_sorted_with_merge_freeList+0x50>
  803412:	83 ec 04             	sub    $0x4,%esp
  803415:	68 40 47 80 00       	push   $0x804740
  80341a:	68 38 01 00 00       	push   $0x138
  80341f:	68 63 47 80 00       	push   $0x804763
  803424:	e8 d8 d4 ff ff       	call   800901 <_panic>
  803429:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80342f:	8b 45 08             	mov    0x8(%ebp),%eax
  803432:	89 10                	mov    %edx,(%eax)
  803434:	8b 45 08             	mov    0x8(%ebp),%eax
  803437:	8b 00                	mov    (%eax),%eax
  803439:	85 c0                	test   %eax,%eax
  80343b:	74 0d                	je     80344a <insert_sorted_with_merge_freeList+0x71>
  80343d:	a1 38 51 80 00       	mov    0x805138,%eax
  803442:	8b 55 08             	mov    0x8(%ebp),%edx
  803445:	89 50 04             	mov    %edx,0x4(%eax)
  803448:	eb 08                	jmp    803452 <insert_sorted_with_merge_freeList+0x79>
  80344a:	8b 45 08             	mov    0x8(%ebp),%eax
  80344d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803452:	8b 45 08             	mov    0x8(%ebp),%eax
  803455:	a3 38 51 80 00       	mov    %eax,0x805138
  80345a:	8b 45 08             	mov    0x8(%ebp),%eax
  80345d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803464:	a1 44 51 80 00       	mov    0x805144,%eax
  803469:	40                   	inc    %eax
  80346a:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80346f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803473:	0f 84 a8 06 00 00    	je     803b21 <insert_sorted_with_merge_freeList+0x748>
  803479:	8b 45 08             	mov    0x8(%ebp),%eax
  80347c:	8b 50 08             	mov    0x8(%eax),%edx
  80347f:	8b 45 08             	mov    0x8(%ebp),%eax
  803482:	8b 40 0c             	mov    0xc(%eax),%eax
  803485:	01 c2                	add    %eax,%edx
  803487:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80348a:	8b 40 08             	mov    0x8(%eax),%eax
  80348d:	39 c2                	cmp    %eax,%edx
  80348f:	0f 85 8c 06 00 00    	jne    803b21 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  803495:	8b 45 08             	mov    0x8(%ebp),%eax
  803498:	8b 50 0c             	mov    0xc(%eax),%edx
  80349b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80349e:	8b 40 0c             	mov    0xc(%eax),%eax
  8034a1:	01 c2                	add    %eax,%edx
  8034a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a6:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  8034a9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8034ad:	75 17                	jne    8034c6 <insert_sorted_with_merge_freeList+0xed>
  8034af:	83 ec 04             	sub    $0x4,%esp
  8034b2:	68 0c 48 80 00       	push   $0x80480c
  8034b7:	68 3c 01 00 00       	push   $0x13c
  8034bc:	68 63 47 80 00       	push   $0x804763
  8034c1:	e8 3b d4 ff ff       	call   800901 <_panic>
  8034c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034c9:	8b 00                	mov    (%eax),%eax
  8034cb:	85 c0                	test   %eax,%eax
  8034cd:	74 10                	je     8034df <insert_sorted_with_merge_freeList+0x106>
  8034cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034d2:	8b 00                	mov    (%eax),%eax
  8034d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034d7:	8b 52 04             	mov    0x4(%edx),%edx
  8034da:	89 50 04             	mov    %edx,0x4(%eax)
  8034dd:	eb 0b                	jmp    8034ea <insert_sorted_with_merge_freeList+0x111>
  8034df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034e2:	8b 40 04             	mov    0x4(%eax),%eax
  8034e5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034ed:	8b 40 04             	mov    0x4(%eax),%eax
  8034f0:	85 c0                	test   %eax,%eax
  8034f2:	74 0f                	je     803503 <insert_sorted_with_merge_freeList+0x12a>
  8034f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034f7:	8b 40 04             	mov    0x4(%eax),%eax
  8034fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034fd:	8b 12                	mov    (%edx),%edx
  8034ff:	89 10                	mov    %edx,(%eax)
  803501:	eb 0a                	jmp    80350d <insert_sorted_with_merge_freeList+0x134>
  803503:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803506:	8b 00                	mov    (%eax),%eax
  803508:	a3 38 51 80 00       	mov    %eax,0x805138
  80350d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803510:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803516:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803519:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803520:	a1 44 51 80 00       	mov    0x805144,%eax
  803525:	48                   	dec    %eax
  803526:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  80352b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80352e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803535:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803538:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  80353f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803543:	75 17                	jne    80355c <insert_sorted_with_merge_freeList+0x183>
  803545:	83 ec 04             	sub    $0x4,%esp
  803548:	68 40 47 80 00       	push   $0x804740
  80354d:	68 3f 01 00 00       	push   $0x13f
  803552:	68 63 47 80 00       	push   $0x804763
  803557:	e8 a5 d3 ff ff       	call   800901 <_panic>
  80355c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803562:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803565:	89 10                	mov    %edx,(%eax)
  803567:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80356a:	8b 00                	mov    (%eax),%eax
  80356c:	85 c0                	test   %eax,%eax
  80356e:	74 0d                	je     80357d <insert_sorted_with_merge_freeList+0x1a4>
  803570:	a1 48 51 80 00       	mov    0x805148,%eax
  803575:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803578:	89 50 04             	mov    %edx,0x4(%eax)
  80357b:	eb 08                	jmp    803585 <insert_sorted_with_merge_freeList+0x1ac>
  80357d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803580:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803585:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803588:	a3 48 51 80 00       	mov    %eax,0x805148
  80358d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803590:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803597:	a1 54 51 80 00       	mov    0x805154,%eax
  80359c:	40                   	inc    %eax
  80359d:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8035a2:	e9 7a 05 00 00       	jmp    803b21 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  8035a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035aa:	8b 50 08             	mov    0x8(%eax),%edx
  8035ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035b0:	8b 40 08             	mov    0x8(%eax),%eax
  8035b3:	39 c2                	cmp    %eax,%edx
  8035b5:	0f 82 14 01 00 00    	jb     8036cf <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8035bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035be:	8b 50 08             	mov    0x8(%eax),%edx
  8035c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8035c7:	01 c2                	add    %eax,%edx
  8035c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8035cc:	8b 40 08             	mov    0x8(%eax),%eax
  8035cf:	39 c2                	cmp    %eax,%edx
  8035d1:	0f 85 90 00 00 00    	jne    803667 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8035d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035da:	8b 50 0c             	mov    0xc(%eax),%edx
  8035dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8035e3:	01 c2                	add    %eax,%edx
  8035e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035e8:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  8035eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ee:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8035f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8035ff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803603:	75 17                	jne    80361c <insert_sorted_with_merge_freeList+0x243>
  803605:	83 ec 04             	sub    $0x4,%esp
  803608:	68 40 47 80 00       	push   $0x804740
  80360d:	68 49 01 00 00       	push   $0x149
  803612:	68 63 47 80 00       	push   $0x804763
  803617:	e8 e5 d2 ff ff       	call   800901 <_panic>
  80361c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803622:	8b 45 08             	mov    0x8(%ebp),%eax
  803625:	89 10                	mov    %edx,(%eax)
  803627:	8b 45 08             	mov    0x8(%ebp),%eax
  80362a:	8b 00                	mov    (%eax),%eax
  80362c:	85 c0                	test   %eax,%eax
  80362e:	74 0d                	je     80363d <insert_sorted_with_merge_freeList+0x264>
  803630:	a1 48 51 80 00       	mov    0x805148,%eax
  803635:	8b 55 08             	mov    0x8(%ebp),%edx
  803638:	89 50 04             	mov    %edx,0x4(%eax)
  80363b:	eb 08                	jmp    803645 <insert_sorted_with_merge_freeList+0x26c>
  80363d:	8b 45 08             	mov    0x8(%ebp),%eax
  803640:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803645:	8b 45 08             	mov    0x8(%ebp),%eax
  803648:	a3 48 51 80 00       	mov    %eax,0x805148
  80364d:	8b 45 08             	mov    0x8(%ebp),%eax
  803650:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803657:	a1 54 51 80 00       	mov    0x805154,%eax
  80365c:	40                   	inc    %eax
  80365d:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803662:	e9 bb 04 00 00       	jmp    803b22 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803667:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80366b:	75 17                	jne    803684 <insert_sorted_with_merge_freeList+0x2ab>
  80366d:	83 ec 04             	sub    $0x4,%esp
  803670:	68 b4 47 80 00       	push   $0x8047b4
  803675:	68 4c 01 00 00       	push   $0x14c
  80367a:	68 63 47 80 00       	push   $0x804763
  80367f:	e8 7d d2 ff ff       	call   800901 <_panic>
  803684:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80368a:	8b 45 08             	mov    0x8(%ebp),%eax
  80368d:	89 50 04             	mov    %edx,0x4(%eax)
  803690:	8b 45 08             	mov    0x8(%ebp),%eax
  803693:	8b 40 04             	mov    0x4(%eax),%eax
  803696:	85 c0                	test   %eax,%eax
  803698:	74 0c                	je     8036a6 <insert_sorted_with_merge_freeList+0x2cd>
  80369a:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80369f:	8b 55 08             	mov    0x8(%ebp),%edx
  8036a2:	89 10                	mov    %edx,(%eax)
  8036a4:	eb 08                	jmp    8036ae <insert_sorted_with_merge_freeList+0x2d5>
  8036a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a9:	a3 38 51 80 00       	mov    %eax,0x805138
  8036ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8036b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036bf:	a1 44 51 80 00       	mov    0x805144,%eax
  8036c4:	40                   	inc    %eax
  8036c5:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8036ca:	e9 53 04 00 00       	jmp    803b22 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8036cf:	a1 38 51 80 00       	mov    0x805138,%eax
  8036d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036d7:	e9 15 04 00 00       	jmp    803af1 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8036dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036df:	8b 00                	mov    (%eax),%eax
  8036e1:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8036e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e7:	8b 50 08             	mov    0x8(%eax),%edx
  8036ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ed:	8b 40 08             	mov    0x8(%eax),%eax
  8036f0:	39 c2                	cmp    %eax,%edx
  8036f2:	0f 86 f1 03 00 00    	jbe    803ae9 <insert_sorted_with_merge_freeList+0x710>
  8036f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036fb:	8b 50 08             	mov    0x8(%eax),%edx
  8036fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803701:	8b 40 08             	mov    0x8(%eax),%eax
  803704:	39 c2                	cmp    %eax,%edx
  803706:	0f 83 dd 03 00 00    	jae    803ae9 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  80370c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80370f:	8b 50 08             	mov    0x8(%eax),%edx
  803712:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803715:	8b 40 0c             	mov    0xc(%eax),%eax
  803718:	01 c2                	add    %eax,%edx
  80371a:	8b 45 08             	mov    0x8(%ebp),%eax
  80371d:	8b 40 08             	mov    0x8(%eax),%eax
  803720:	39 c2                	cmp    %eax,%edx
  803722:	0f 85 b9 01 00 00    	jne    8038e1 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803728:	8b 45 08             	mov    0x8(%ebp),%eax
  80372b:	8b 50 08             	mov    0x8(%eax),%edx
  80372e:	8b 45 08             	mov    0x8(%ebp),%eax
  803731:	8b 40 0c             	mov    0xc(%eax),%eax
  803734:	01 c2                	add    %eax,%edx
  803736:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803739:	8b 40 08             	mov    0x8(%eax),%eax
  80373c:	39 c2                	cmp    %eax,%edx
  80373e:	0f 85 0d 01 00 00    	jne    803851 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803744:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803747:	8b 50 0c             	mov    0xc(%eax),%edx
  80374a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80374d:	8b 40 0c             	mov    0xc(%eax),%eax
  803750:	01 c2                	add    %eax,%edx
  803752:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803755:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803758:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80375c:	75 17                	jne    803775 <insert_sorted_with_merge_freeList+0x39c>
  80375e:	83 ec 04             	sub    $0x4,%esp
  803761:	68 0c 48 80 00       	push   $0x80480c
  803766:	68 5c 01 00 00       	push   $0x15c
  80376b:	68 63 47 80 00       	push   $0x804763
  803770:	e8 8c d1 ff ff       	call   800901 <_panic>
  803775:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803778:	8b 00                	mov    (%eax),%eax
  80377a:	85 c0                	test   %eax,%eax
  80377c:	74 10                	je     80378e <insert_sorted_with_merge_freeList+0x3b5>
  80377e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803781:	8b 00                	mov    (%eax),%eax
  803783:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803786:	8b 52 04             	mov    0x4(%edx),%edx
  803789:	89 50 04             	mov    %edx,0x4(%eax)
  80378c:	eb 0b                	jmp    803799 <insert_sorted_with_merge_freeList+0x3c0>
  80378e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803791:	8b 40 04             	mov    0x4(%eax),%eax
  803794:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803799:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80379c:	8b 40 04             	mov    0x4(%eax),%eax
  80379f:	85 c0                	test   %eax,%eax
  8037a1:	74 0f                	je     8037b2 <insert_sorted_with_merge_freeList+0x3d9>
  8037a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037a6:	8b 40 04             	mov    0x4(%eax),%eax
  8037a9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037ac:	8b 12                	mov    (%edx),%edx
  8037ae:	89 10                	mov    %edx,(%eax)
  8037b0:	eb 0a                	jmp    8037bc <insert_sorted_with_merge_freeList+0x3e3>
  8037b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037b5:	8b 00                	mov    (%eax),%eax
  8037b7:	a3 38 51 80 00       	mov    %eax,0x805138
  8037bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037c8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037cf:	a1 44 51 80 00       	mov    0x805144,%eax
  8037d4:	48                   	dec    %eax
  8037d5:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8037da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037dd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8037e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037e7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8037ee:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8037f2:	75 17                	jne    80380b <insert_sorted_with_merge_freeList+0x432>
  8037f4:	83 ec 04             	sub    $0x4,%esp
  8037f7:	68 40 47 80 00       	push   $0x804740
  8037fc:	68 5f 01 00 00       	push   $0x15f
  803801:	68 63 47 80 00       	push   $0x804763
  803806:	e8 f6 d0 ff ff       	call   800901 <_panic>
  80380b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803811:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803814:	89 10                	mov    %edx,(%eax)
  803816:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803819:	8b 00                	mov    (%eax),%eax
  80381b:	85 c0                	test   %eax,%eax
  80381d:	74 0d                	je     80382c <insert_sorted_with_merge_freeList+0x453>
  80381f:	a1 48 51 80 00       	mov    0x805148,%eax
  803824:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803827:	89 50 04             	mov    %edx,0x4(%eax)
  80382a:	eb 08                	jmp    803834 <insert_sorted_with_merge_freeList+0x45b>
  80382c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80382f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803834:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803837:	a3 48 51 80 00       	mov    %eax,0x805148
  80383c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80383f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803846:	a1 54 51 80 00       	mov    0x805154,%eax
  80384b:	40                   	inc    %eax
  80384c:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803851:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803854:	8b 50 0c             	mov    0xc(%eax),%edx
  803857:	8b 45 08             	mov    0x8(%ebp),%eax
  80385a:	8b 40 0c             	mov    0xc(%eax),%eax
  80385d:	01 c2                	add    %eax,%edx
  80385f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803862:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803865:	8b 45 08             	mov    0x8(%ebp),%eax
  803868:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80386f:	8b 45 08             	mov    0x8(%ebp),%eax
  803872:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803879:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80387d:	75 17                	jne    803896 <insert_sorted_with_merge_freeList+0x4bd>
  80387f:	83 ec 04             	sub    $0x4,%esp
  803882:	68 40 47 80 00       	push   $0x804740
  803887:	68 64 01 00 00       	push   $0x164
  80388c:	68 63 47 80 00       	push   $0x804763
  803891:	e8 6b d0 ff ff       	call   800901 <_panic>
  803896:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80389c:	8b 45 08             	mov    0x8(%ebp),%eax
  80389f:	89 10                	mov    %edx,(%eax)
  8038a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a4:	8b 00                	mov    (%eax),%eax
  8038a6:	85 c0                	test   %eax,%eax
  8038a8:	74 0d                	je     8038b7 <insert_sorted_with_merge_freeList+0x4de>
  8038aa:	a1 48 51 80 00       	mov    0x805148,%eax
  8038af:	8b 55 08             	mov    0x8(%ebp),%edx
  8038b2:	89 50 04             	mov    %edx,0x4(%eax)
  8038b5:	eb 08                	jmp    8038bf <insert_sorted_with_merge_freeList+0x4e6>
  8038b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ba:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8038bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c2:	a3 48 51 80 00       	mov    %eax,0x805148
  8038c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038d1:	a1 54 51 80 00       	mov    0x805154,%eax
  8038d6:	40                   	inc    %eax
  8038d7:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8038dc:	e9 41 02 00 00       	jmp    803b22 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8038e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e4:	8b 50 08             	mov    0x8(%eax),%edx
  8038e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8038ed:	01 c2                	add    %eax,%edx
  8038ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038f2:	8b 40 08             	mov    0x8(%eax),%eax
  8038f5:	39 c2                	cmp    %eax,%edx
  8038f7:	0f 85 7c 01 00 00    	jne    803a79 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8038fd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803901:	74 06                	je     803909 <insert_sorted_with_merge_freeList+0x530>
  803903:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803907:	75 17                	jne    803920 <insert_sorted_with_merge_freeList+0x547>
  803909:	83 ec 04             	sub    $0x4,%esp
  80390c:	68 7c 47 80 00       	push   $0x80477c
  803911:	68 69 01 00 00       	push   $0x169
  803916:	68 63 47 80 00       	push   $0x804763
  80391b:	e8 e1 cf ff ff       	call   800901 <_panic>
  803920:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803923:	8b 50 04             	mov    0x4(%eax),%edx
  803926:	8b 45 08             	mov    0x8(%ebp),%eax
  803929:	89 50 04             	mov    %edx,0x4(%eax)
  80392c:	8b 45 08             	mov    0x8(%ebp),%eax
  80392f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803932:	89 10                	mov    %edx,(%eax)
  803934:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803937:	8b 40 04             	mov    0x4(%eax),%eax
  80393a:	85 c0                	test   %eax,%eax
  80393c:	74 0d                	je     80394b <insert_sorted_with_merge_freeList+0x572>
  80393e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803941:	8b 40 04             	mov    0x4(%eax),%eax
  803944:	8b 55 08             	mov    0x8(%ebp),%edx
  803947:	89 10                	mov    %edx,(%eax)
  803949:	eb 08                	jmp    803953 <insert_sorted_with_merge_freeList+0x57a>
  80394b:	8b 45 08             	mov    0x8(%ebp),%eax
  80394e:	a3 38 51 80 00       	mov    %eax,0x805138
  803953:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803956:	8b 55 08             	mov    0x8(%ebp),%edx
  803959:	89 50 04             	mov    %edx,0x4(%eax)
  80395c:	a1 44 51 80 00       	mov    0x805144,%eax
  803961:	40                   	inc    %eax
  803962:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803967:	8b 45 08             	mov    0x8(%ebp),%eax
  80396a:	8b 50 0c             	mov    0xc(%eax),%edx
  80396d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803970:	8b 40 0c             	mov    0xc(%eax),%eax
  803973:	01 c2                	add    %eax,%edx
  803975:	8b 45 08             	mov    0x8(%ebp),%eax
  803978:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80397b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80397f:	75 17                	jne    803998 <insert_sorted_with_merge_freeList+0x5bf>
  803981:	83 ec 04             	sub    $0x4,%esp
  803984:	68 0c 48 80 00       	push   $0x80480c
  803989:	68 6b 01 00 00       	push   $0x16b
  80398e:	68 63 47 80 00       	push   $0x804763
  803993:	e8 69 cf ff ff       	call   800901 <_panic>
  803998:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80399b:	8b 00                	mov    (%eax),%eax
  80399d:	85 c0                	test   %eax,%eax
  80399f:	74 10                	je     8039b1 <insert_sorted_with_merge_freeList+0x5d8>
  8039a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039a4:	8b 00                	mov    (%eax),%eax
  8039a6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039a9:	8b 52 04             	mov    0x4(%edx),%edx
  8039ac:	89 50 04             	mov    %edx,0x4(%eax)
  8039af:	eb 0b                	jmp    8039bc <insert_sorted_with_merge_freeList+0x5e3>
  8039b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039b4:	8b 40 04             	mov    0x4(%eax),%eax
  8039b7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8039bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039bf:	8b 40 04             	mov    0x4(%eax),%eax
  8039c2:	85 c0                	test   %eax,%eax
  8039c4:	74 0f                	je     8039d5 <insert_sorted_with_merge_freeList+0x5fc>
  8039c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039c9:	8b 40 04             	mov    0x4(%eax),%eax
  8039cc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039cf:	8b 12                	mov    (%edx),%edx
  8039d1:	89 10                	mov    %edx,(%eax)
  8039d3:	eb 0a                	jmp    8039df <insert_sorted_with_merge_freeList+0x606>
  8039d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039d8:	8b 00                	mov    (%eax),%eax
  8039da:	a3 38 51 80 00       	mov    %eax,0x805138
  8039df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039eb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039f2:	a1 44 51 80 00       	mov    0x805144,%eax
  8039f7:	48                   	dec    %eax
  8039f8:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8039fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a00:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803a07:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a0a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803a11:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803a15:	75 17                	jne    803a2e <insert_sorted_with_merge_freeList+0x655>
  803a17:	83 ec 04             	sub    $0x4,%esp
  803a1a:	68 40 47 80 00       	push   $0x804740
  803a1f:	68 6e 01 00 00       	push   $0x16e
  803a24:	68 63 47 80 00       	push   $0x804763
  803a29:	e8 d3 ce ff ff       	call   800901 <_panic>
  803a2e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a34:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a37:	89 10                	mov    %edx,(%eax)
  803a39:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a3c:	8b 00                	mov    (%eax),%eax
  803a3e:	85 c0                	test   %eax,%eax
  803a40:	74 0d                	je     803a4f <insert_sorted_with_merge_freeList+0x676>
  803a42:	a1 48 51 80 00       	mov    0x805148,%eax
  803a47:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a4a:	89 50 04             	mov    %edx,0x4(%eax)
  803a4d:	eb 08                	jmp    803a57 <insert_sorted_with_merge_freeList+0x67e>
  803a4f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a52:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803a57:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a5a:	a3 48 51 80 00       	mov    %eax,0x805148
  803a5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a62:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a69:	a1 54 51 80 00       	mov    0x805154,%eax
  803a6e:	40                   	inc    %eax
  803a6f:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803a74:	e9 a9 00 00 00       	jmp    803b22 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803a79:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a7d:	74 06                	je     803a85 <insert_sorted_with_merge_freeList+0x6ac>
  803a7f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a83:	75 17                	jne    803a9c <insert_sorted_with_merge_freeList+0x6c3>
  803a85:	83 ec 04             	sub    $0x4,%esp
  803a88:	68 d8 47 80 00       	push   $0x8047d8
  803a8d:	68 73 01 00 00       	push   $0x173
  803a92:	68 63 47 80 00       	push   $0x804763
  803a97:	e8 65 ce ff ff       	call   800901 <_panic>
  803a9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a9f:	8b 10                	mov    (%eax),%edx
  803aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  803aa4:	89 10                	mov    %edx,(%eax)
  803aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  803aa9:	8b 00                	mov    (%eax),%eax
  803aab:	85 c0                	test   %eax,%eax
  803aad:	74 0b                	je     803aba <insert_sorted_with_merge_freeList+0x6e1>
  803aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ab2:	8b 00                	mov    (%eax),%eax
  803ab4:	8b 55 08             	mov    0x8(%ebp),%edx
  803ab7:	89 50 04             	mov    %edx,0x4(%eax)
  803aba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803abd:	8b 55 08             	mov    0x8(%ebp),%edx
  803ac0:	89 10                	mov    %edx,(%eax)
  803ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  803ac5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ac8:	89 50 04             	mov    %edx,0x4(%eax)
  803acb:	8b 45 08             	mov    0x8(%ebp),%eax
  803ace:	8b 00                	mov    (%eax),%eax
  803ad0:	85 c0                	test   %eax,%eax
  803ad2:	75 08                	jne    803adc <insert_sorted_with_merge_freeList+0x703>
  803ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  803ad7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803adc:	a1 44 51 80 00       	mov    0x805144,%eax
  803ae1:	40                   	inc    %eax
  803ae2:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803ae7:	eb 39                	jmp    803b22 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803ae9:	a1 40 51 80 00       	mov    0x805140,%eax
  803aee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803af1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803af5:	74 07                	je     803afe <insert_sorted_with_merge_freeList+0x725>
  803af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803afa:	8b 00                	mov    (%eax),%eax
  803afc:	eb 05                	jmp    803b03 <insert_sorted_with_merge_freeList+0x72a>
  803afe:	b8 00 00 00 00       	mov    $0x0,%eax
  803b03:	a3 40 51 80 00       	mov    %eax,0x805140
  803b08:	a1 40 51 80 00       	mov    0x805140,%eax
  803b0d:	85 c0                	test   %eax,%eax
  803b0f:	0f 85 c7 fb ff ff    	jne    8036dc <insert_sorted_with_merge_freeList+0x303>
  803b15:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b19:	0f 85 bd fb ff ff    	jne    8036dc <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803b1f:	eb 01                	jmp    803b22 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803b21:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803b22:	90                   	nop
  803b23:	c9                   	leave  
  803b24:	c3                   	ret    
  803b25:	66 90                	xchg   %ax,%ax
  803b27:	90                   	nop

00803b28 <__udivdi3>:
  803b28:	55                   	push   %ebp
  803b29:	57                   	push   %edi
  803b2a:	56                   	push   %esi
  803b2b:	53                   	push   %ebx
  803b2c:	83 ec 1c             	sub    $0x1c,%esp
  803b2f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803b33:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b37:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b3b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b3f:	89 ca                	mov    %ecx,%edx
  803b41:	89 f8                	mov    %edi,%eax
  803b43:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803b47:	85 f6                	test   %esi,%esi
  803b49:	75 2d                	jne    803b78 <__udivdi3+0x50>
  803b4b:	39 cf                	cmp    %ecx,%edi
  803b4d:	77 65                	ja     803bb4 <__udivdi3+0x8c>
  803b4f:	89 fd                	mov    %edi,%ebp
  803b51:	85 ff                	test   %edi,%edi
  803b53:	75 0b                	jne    803b60 <__udivdi3+0x38>
  803b55:	b8 01 00 00 00       	mov    $0x1,%eax
  803b5a:	31 d2                	xor    %edx,%edx
  803b5c:	f7 f7                	div    %edi
  803b5e:	89 c5                	mov    %eax,%ebp
  803b60:	31 d2                	xor    %edx,%edx
  803b62:	89 c8                	mov    %ecx,%eax
  803b64:	f7 f5                	div    %ebp
  803b66:	89 c1                	mov    %eax,%ecx
  803b68:	89 d8                	mov    %ebx,%eax
  803b6a:	f7 f5                	div    %ebp
  803b6c:	89 cf                	mov    %ecx,%edi
  803b6e:	89 fa                	mov    %edi,%edx
  803b70:	83 c4 1c             	add    $0x1c,%esp
  803b73:	5b                   	pop    %ebx
  803b74:	5e                   	pop    %esi
  803b75:	5f                   	pop    %edi
  803b76:	5d                   	pop    %ebp
  803b77:	c3                   	ret    
  803b78:	39 ce                	cmp    %ecx,%esi
  803b7a:	77 28                	ja     803ba4 <__udivdi3+0x7c>
  803b7c:	0f bd fe             	bsr    %esi,%edi
  803b7f:	83 f7 1f             	xor    $0x1f,%edi
  803b82:	75 40                	jne    803bc4 <__udivdi3+0x9c>
  803b84:	39 ce                	cmp    %ecx,%esi
  803b86:	72 0a                	jb     803b92 <__udivdi3+0x6a>
  803b88:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803b8c:	0f 87 9e 00 00 00    	ja     803c30 <__udivdi3+0x108>
  803b92:	b8 01 00 00 00       	mov    $0x1,%eax
  803b97:	89 fa                	mov    %edi,%edx
  803b99:	83 c4 1c             	add    $0x1c,%esp
  803b9c:	5b                   	pop    %ebx
  803b9d:	5e                   	pop    %esi
  803b9e:	5f                   	pop    %edi
  803b9f:	5d                   	pop    %ebp
  803ba0:	c3                   	ret    
  803ba1:	8d 76 00             	lea    0x0(%esi),%esi
  803ba4:	31 ff                	xor    %edi,%edi
  803ba6:	31 c0                	xor    %eax,%eax
  803ba8:	89 fa                	mov    %edi,%edx
  803baa:	83 c4 1c             	add    $0x1c,%esp
  803bad:	5b                   	pop    %ebx
  803bae:	5e                   	pop    %esi
  803baf:	5f                   	pop    %edi
  803bb0:	5d                   	pop    %ebp
  803bb1:	c3                   	ret    
  803bb2:	66 90                	xchg   %ax,%ax
  803bb4:	89 d8                	mov    %ebx,%eax
  803bb6:	f7 f7                	div    %edi
  803bb8:	31 ff                	xor    %edi,%edi
  803bba:	89 fa                	mov    %edi,%edx
  803bbc:	83 c4 1c             	add    $0x1c,%esp
  803bbf:	5b                   	pop    %ebx
  803bc0:	5e                   	pop    %esi
  803bc1:	5f                   	pop    %edi
  803bc2:	5d                   	pop    %ebp
  803bc3:	c3                   	ret    
  803bc4:	bd 20 00 00 00       	mov    $0x20,%ebp
  803bc9:	89 eb                	mov    %ebp,%ebx
  803bcb:	29 fb                	sub    %edi,%ebx
  803bcd:	89 f9                	mov    %edi,%ecx
  803bcf:	d3 e6                	shl    %cl,%esi
  803bd1:	89 c5                	mov    %eax,%ebp
  803bd3:	88 d9                	mov    %bl,%cl
  803bd5:	d3 ed                	shr    %cl,%ebp
  803bd7:	89 e9                	mov    %ebp,%ecx
  803bd9:	09 f1                	or     %esi,%ecx
  803bdb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803bdf:	89 f9                	mov    %edi,%ecx
  803be1:	d3 e0                	shl    %cl,%eax
  803be3:	89 c5                	mov    %eax,%ebp
  803be5:	89 d6                	mov    %edx,%esi
  803be7:	88 d9                	mov    %bl,%cl
  803be9:	d3 ee                	shr    %cl,%esi
  803beb:	89 f9                	mov    %edi,%ecx
  803bed:	d3 e2                	shl    %cl,%edx
  803bef:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bf3:	88 d9                	mov    %bl,%cl
  803bf5:	d3 e8                	shr    %cl,%eax
  803bf7:	09 c2                	or     %eax,%edx
  803bf9:	89 d0                	mov    %edx,%eax
  803bfb:	89 f2                	mov    %esi,%edx
  803bfd:	f7 74 24 0c          	divl   0xc(%esp)
  803c01:	89 d6                	mov    %edx,%esi
  803c03:	89 c3                	mov    %eax,%ebx
  803c05:	f7 e5                	mul    %ebp
  803c07:	39 d6                	cmp    %edx,%esi
  803c09:	72 19                	jb     803c24 <__udivdi3+0xfc>
  803c0b:	74 0b                	je     803c18 <__udivdi3+0xf0>
  803c0d:	89 d8                	mov    %ebx,%eax
  803c0f:	31 ff                	xor    %edi,%edi
  803c11:	e9 58 ff ff ff       	jmp    803b6e <__udivdi3+0x46>
  803c16:	66 90                	xchg   %ax,%ax
  803c18:	8b 54 24 08          	mov    0x8(%esp),%edx
  803c1c:	89 f9                	mov    %edi,%ecx
  803c1e:	d3 e2                	shl    %cl,%edx
  803c20:	39 c2                	cmp    %eax,%edx
  803c22:	73 e9                	jae    803c0d <__udivdi3+0xe5>
  803c24:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803c27:	31 ff                	xor    %edi,%edi
  803c29:	e9 40 ff ff ff       	jmp    803b6e <__udivdi3+0x46>
  803c2e:	66 90                	xchg   %ax,%ax
  803c30:	31 c0                	xor    %eax,%eax
  803c32:	e9 37 ff ff ff       	jmp    803b6e <__udivdi3+0x46>
  803c37:	90                   	nop

00803c38 <__umoddi3>:
  803c38:	55                   	push   %ebp
  803c39:	57                   	push   %edi
  803c3a:	56                   	push   %esi
  803c3b:	53                   	push   %ebx
  803c3c:	83 ec 1c             	sub    $0x1c,%esp
  803c3f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803c43:	8b 74 24 34          	mov    0x34(%esp),%esi
  803c47:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c4b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c4f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c53:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c57:	89 f3                	mov    %esi,%ebx
  803c59:	89 fa                	mov    %edi,%edx
  803c5b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c5f:	89 34 24             	mov    %esi,(%esp)
  803c62:	85 c0                	test   %eax,%eax
  803c64:	75 1a                	jne    803c80 <__umoddi3+0x48>
  803c66:	39 f7                	cmp    %esi,%edi
  803c68:	0f 86 a2 00 00 00    	jbe    803d10 <__umoddi3+0xd8>
  803c6e:	89 c8                	mov    %ecx,%eax
  803c70:	89 f2                	mov    %esi,%edx
  803c72:	f7 f7                	div    %edi
  803c74:	89 d0                	mov    %edx,%eax
  803c76:	31 d2                	xor    %edx,%edx
  803c78:	83 c4 1c             	add    $0x1c,%esp
  803c7b:	5b                   	pop    %ebx
  803c7c:	5e                   	pop    %esi
  803c7d:	5f                   	pop    %edi
  803c7e:	5d                   	pop    %ebp
  803c7f:	c3                   	ret    
  803c80:	39 f0                	cmp    %esi,%eax
  803c82:	0f 87 ac 00 00 00    	ja     803d34 <__umoddi3+0xfc>
  803c88:	0f bd e8             	bsr    %eax,%ebp
  803c8b:	83 f5 1f             	xor    $0x1f,%ebp
  803c8e:	0f 84 ac 00 00 00    	je     803d40 <__umoddi3+0x108>
  803c94:	bf 20 00 00 00       	mov    $0x20,%edi
  803c99:	29 ef                	sub    %ebp,%edi
  803c9b:	89 fe                	mov    %edi,%esi
  803c9d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803ca1:	89 e9                	mov    %ebp,%ecx
  803ca3:	d3 e0                	shl    %cl,%eax
  803ca5:	89 d7                	mov    %edx,%edi
  803ca7:	89 f1                	mov    %esi,%ecx
  803ca9:	d3 ef                	shr    %cl,%edi
  803cab:	09 c7                	or     %eax,%edi
  803cad:	89 e9                	mov    %ebp,%ecx
  803caf:	d3 e2                	shl    %cl,%edx
  803cb1:	89 14 24             	mov    %edx,(%esp)
  803cb4:	89 d8                	mov    %ebx,%eax
  803cb6:	d3 e0                	shl    %cl,%eax
  803cb8:	89 c2                	mov    %eax,%edx
  803cba:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cbe:	d3 e0                	shl    %cl,%eax
  803cc0:	89 44 24 04          	mov    %eax,0x4(%esp)
  803cc4:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cc8:	89 f1                	mov    %esi,%ecx
  803cca:	d3 e8                	shr    %cl,%eax
  803ccc:	09 d0                	or     %edx,%eax
  803cce:	d3 eb                	shr    %cl,%ebx
  803cd0:	89 da                	mov    %ebx,%edx
  803cd2:	f7 f7                	div    %edi
  803cd4:	89 d3                	mov    %edx,%ebx
  803cd6:	f7 24 24             	mull   (%esp)
  803cd9:	89 c6                	mov    %eax,%esi
  803cdb:	89 d1                	mov    %edx,%ecx
  803cdd:	39 d3                	cmp    %edx,%ebx
  803cdf:	0f 82 87 00 00 00    	jb     803d6c <__umoddi3+0x134>
  803ce5:	0f 84 91 00 00 00    	je     803d7c <__umoddi3+0x144>
  803ceb:	8b 54 24 04          	mov    0x4(%esp),%edx
  803cef:	29 f2                	sub    %esi,%edx
  803cf1:	19 cb                	sbb    %ecx,%ebx
  803cf3:	89 d8                	mov    %ebx,%eax
  803cf5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803cf9:	d3 e0                	shl    %cl,%eax
  803cfb:	89 e9                	mov    %ebp,%ecx
  803cfd:	d3 ea                	shr    %cl,%edx
  803cff:	09 d0                	or     %edx,%eax
  803d01:	89 e9                	mov    %ebp,%ecx
  803d03:	d3 eb                	shr    %cl,%ebx
  803d05:	89 da                	mov    %ebx,%edx
  803d07:	83 c4 1c             	add    $0x1c,%esp
  803d0a:	5b                   	pop    %ebx
  803d0b:	5e                   	pop    %esi
  803d0c:	5f                   	pop    %edi
  803d0d:	5d                   	pop    %ebp
  803d0e:	c3                   	ret    
  803d0f:	90                   	nop
  803d10:	89 fd                	mov    %edi,%ebp
  803d12:	85 ff                	test   %edi,%edi
  803d14:	75 0b                	jne    803d21 <__umoddi3+0xe9>
  803d16:	b8 01 00 00 00       	mov    $0x1,%eax
  803d1b:	31 d2                	xor    %edx,%edx
  803d1d:	f7 f7                	div    %edi
  803d1f:	89 c5                	mov    %eax,%ebp
  803d21:	89 f0                	mov    %esi,%eax
  803d23:	31 d2                	xor    %edx,%edx
  803d25:	f7 f5                	div    %ebp
  803d27:	89 c8                	mov    %ecx,%eax
  803d29:	f7 f5                	div    %ebp
  803d2b:	89 d0                	mov    %edx,%eax
  803d2d:	e9 44 ff ff ff       	jmp    803c76 <__umoddi3+0x3e>
  803d32:	66 90                	xchg   %ax,%ax
  803d34:	89 c8                	mov    %ecx,%eax
  803d36:	89 f2                	mov    %esi,%edx
  803d38:	83 c4 1c             	add    $0x1c,%esp
  803d3b:	5b                   	pop    %ebx
  803d3c:	5e                   	pop    %esi
  803d3d:	5f                   	pop    %edi
  803d3e:	5d                   	pop    %ebp
  803d3f:	c3                   	ret    
  803d40:	3b 04 24             	cmp    (%esp),%eax
  803d43:	72 06                	jb     803d4b <__umoddi3+0x113>
  803d45:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803d49:	77 0f                	ja     803d5a <__umoddi3+0x122>
  803d4b:	89 f2                	mov    %esi,%edx
  803d4d:	29 f9                	sub    %edi,%ecx
  803d4f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d53:	89 14 24             	mov    %edx,(%esp)
  803d56:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d5a:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d5e:	8b 14 24             	mov    (%esp),%edx
  803d61:	83 c4 1c             	add    $0x1c,%esp
  803d64:	5b                   	pop    %ebx
  803d65:	5e                   	pop    %esi
  803d66:	5f                   	pop    %edi
  803d67:	5d                   	pop    %ebp
  803d68:	c3                   	ret    
  803d69:	8d 76 00             	lea    0x0(%esi),%esi
  803d6c:	2b 04 24             	sub    (%esp),%eax
  803d6f:	19 fa                	sbb    %edi,%edx
  803d71:	89 d1                	mov    %edx,%ecx
  803d73:	89 c6                	mov    %eax,%esi
  803d75:	e9 71 ff ff ff       	jmp    803ceb <__umoddi3+0xb3>
  803d7a:	66 90                	xchg   %ax,%ax
  803d7c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803d80:	72 ea                	jb     803d6c <__umoddi3+0x134>
  803d82:	89 d9                	mov    %ebx,%ecx
  803d84:	e9 62 ff ff ff       	jmp    803ceb <__umoddi3+0xb3>
