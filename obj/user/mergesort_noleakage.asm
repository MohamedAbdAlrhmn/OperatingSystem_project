
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
  800041:	e8 97 20 00 00       	call   8020dd <sys_disable_interrupt>

		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 20 3e 80 00       	push   $0x803e20
  80004e:	e8 62 0b 00 00       	call   800bb5 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 22 3e 80 00       	push   $0x803e22
  80005e:	e8 52 0b 00 00       	call   800bb5 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 38 3e 80 00       	push   $0x803e38
  80006e:	e8 42 0b 00 00       	call   800bb5 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 22 3e 80 00       	push   $0x803e22
  80007e:	e8 32 0b 00 00       	call   800bb5 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 20 3e 80 00       	push   $0x803e20
  80008e:	e8 22 0b 00 00       	call   800bb5 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 50 3e 80 00       	push   $0x803e50
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
  8000de:	68 70 3e 80 00       	push   $0x803e70
  8000e3:	e8 cd 0a 00 00       	call   800bb5 <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 92 3e 80 00       	push   $0x803e92
  8000f3:	e8 bd 0a 00 00       	call   800bb5 <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 a0 3e 80 00       	push   $0x803ea0
  800103:	e8 ad 0a 00 00       	call   800bb5 <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 af 3e 80 00       	push   $0x803eaf
  800113:	e8 9d 0a 00 00       	call   800bb5 <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 bf 3e 80 00       	push   $0x803ebf
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
  800162:	e8 90 1f 00 00       	call   8020f7 <sys_enable_interrupt>

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
  8001d7:	e8 01 1f 00 00       	call   8020dd <sys_disable_interrupt>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	68 c8 3e 80 00       	push   $0x803ec8
  8001e4:	e8 cc 09 00 00       	call   800bb5 <cprintf>
  8001e9:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001ec:	e8 06 1f 00 00       	call   8020f7 <sys_enable_interrupt>

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
  80020e:	68 fc 3e 80 00       	push   $0x803efc
  800213:	6a 4a                	push   $0x4a
  800215:	68 1e 3f 80 00       	push   $0x803f1e
  80021a:	e8 e2 06 00 00       	call   800901 <_panic>
		else
		{
			sys_disable_interrupt();
  80021f:	e8 b9 1e 00 00       	call   8020dd <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	68 3c 3f 80 00       	push   $0x803f3c
  80022c:	e8 84 09 00 00       	call   800bb5 <cprintf>
  800231:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	68 70 3f 80 00       	push   $0x803f70
  80023c:	e8 74 09 00 00       	call   800bb5 <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 a4 3f 80 00       	push   $0x803fa4
  80024c:	e8 64 09 00 00       	call   800bb5 <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800254:	e8 9e 1e 00 00       	call   8020f7 <sys_enable_interrupt>
		}

		free(Elements) ;
  800259:	83 ec 0c             	sub    $0xc,%esp
  80025c:	ff 75 ec             	pushl  -0x14(%ebp)
  80025f:	e8 0d 1b 00 00       	call   801d71 <free>
  800264:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  800267:	e8 71 1e 00 00       	call   8020dd <sys_disable_interrupt>
			Chose = 0 ;
  80026c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800270:	eb 42                	jmp    8002b4 <_main+0x27c>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800272:	83 ec 0c             	sub    $0xc,%esp
  800275:	68 d6 3f 80 00       	push   $0x803fd6
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
  8002c0:	e8 32 1e 00 00       	call   8020f7 <sys_enable_interrupt>

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
  800454:	68 20 3e 80 00       	push   $0x803e20
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
  800476:	68 f4 3f 80 00       	push   $0x803ff4
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
  8004a4:	68 f9 3f 80 00       	push   $0x803ff9
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
  800739:	e8 d3 19 00 00       	call   802111 <sys_cputc>
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
  80074a:	e8 8e 19 00 00       	call   8020dd <sys_disable_interrupt>
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
  80075d:	e8 af 19 00 00       	call   802111 <sys_cputc>
  800762:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800765:	e8 8d 19 00 00       	call   8020f7 <sys_enable_interrupt>
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
  80077c:	e8 d7 17 00 00       	call   801f58 <sys_cgetc>
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
  800795:	e8 43 19 00 00       	call   8020dd <sys_disable_interrupt>
	int c=0;
  80079a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8007a1:	eb 08                	jmp    8007ab <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  8007a3:	e8 b0 17 00 00       	call   801f58 <sys_cgetc>
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
  8007b1:	e8 41 19 00 00       	call   8020f7 <sys_enable_interrupt>
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
  8007cb:	e8 00 1b 00 00       	call   8022d0 <sys_getenvindex>
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
  800836:	e8 a2 18 00 00       	call   8020dd <sys_disable_interrupt>
	cprintf("**************************************\n");
  80083b:	83 ec 0c             	sub    $0xc,%esp
  80083e:	68 18 40 80 00       	push   $0x804018
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
  800866:	68 40 40 80 00       	push   $0x804040
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
  800897:	68 68 40 80 00       	push   $0x804068
  80089c:	e8 14 03 00 00       	call   800bb5 <cprintf>
  8008a1:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8008a4:	a1 24 50 80 00       	mov    0x805024,%eax
  8008a9:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8008af:	83 ec 08             	sub    $0x8,%esp
  8008b2:	50                   	push   %eax
  8008b3:	68 c0 40 80 00       	push   $0x8040c0
  8008b8:	e8 f8 02 00 00       	call   800bb5 <cprintf>
  8008bd:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8008c0:	83 ec 0c             	sub    $0xc,%esp
  8008c3:	68 18 40 80 00       	push   $0x804018
  8008c8:	e8 e8 02 00 00       	call   800bb5 <cprintf>
  8008cd:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8008d0:	e8 22 18 00 00       	call   8020f7 <sys_enable_interrupt>

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
  8008e8:	e8 af 19 00 00       	call   80229c <sys_destroy_env>
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
  8008f9:	e8 04 1a 00 00       	call   802302 <sys_exit_env>
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
  800922:	68 d4 40 80 00       	push   $0x8040d4
  800927:	e8 89 02 00 00       	call   800bb5 <cprintf>
  80092c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80092f:	a1 00 50 80 00       	mov    0x805000,%eax
  800934:	ff 75 0c             	pushl  0xc(%ebp)
  800937:	ff 75 08             	pushl  0x8(%ebp)
  80093a:	50                   	push   %eax
  80093b:	68 d9 40 80 00       	push   $0x8040d9
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
  80095f:	68 f5 40 80 00       	push   $0x8040f5
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
  80098b:	68 f8 40 80 00       	push   $0x8040f8
  800990:	6a 26                	push   $0x26
  800992:	68 44 41 80 00       	push   $0x804144
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
  800a5d:	68 50 41 80 00       	push   $0x804150
  800a62:	6a 3a                	push   $0x3a
  800a64:	68 44 41 80 00       	push   $0x804144
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
  800acd:	68 a4 41 80 00       	push   $0x8041a4
  800ad2:	6a 44                	push   $0x44
  800ad4:	68 44 41 80 00       	push   $0x804144
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
  800b27:	e8 03 14 00 00       	call   801f2f <sys_cputs>
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
  800b9e:	e8 8c 13 00 00       	call   801f2f <sys_cputs>
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
  800be8:	e8 f0 14 00 00       	call   8020dd <sys_disable_interrupt>
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
  800c08:	e8 ea 14 00 00       	call   8020f7 <sys_enable_interrupt>
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
  800c52:	e8 5d 2f 00 00       	call   803bb4 <__udivdi3>
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
  800ca2:	e8 1d 30 00 00       	call   803cc4 <__umoddi3>
  800ca7:	83 c4 10             	add    $0x10,%esp
  800caa:	05 14 44 80 00       	add    $0x804414,%eax
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
  800dfd:	8b 04 85 38 44 80 00 	mov    0x804438(,%eax,4),%eax
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
  800ede:	8b 34 9d 80 42 80 00 	mov    0x804280(,%ebx,4),%esi
  800ee5:	85 f6                	test   %esi,%esi
  800ee7:	75 19                	jne    800f02 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ee9:	53                   	push   %ebx
  800eea:	68 25 44 80 00       	push   $0x804425
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
  800f03:	68 2e 44 80 00       	push   $0x80442e
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
  800f30:	be 31 44 80 00       	mov    $0x804431,%esi
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
  801249:	68 90 45 80 00       	push   $0x804590
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
  80128b:	68 93 45 80 00       	push   $0x804593
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
  80133b:	e8 9d 0d 00 00       	call   8020dd <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  801340:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801344:	74 13                	je     801359 <atomic_readline+0x24>
		cprintf("%s", prompt);
  801346:	83 ec 08             	sub    $0x8,%esp
  801349:	ff 75 08             	pushl  0x8(%ebp)
  80134c:	68 90 45 80 00       	push   $0x804590
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
  80138a:	68 93 45 80 00       	push   $0x804593
  80138f:	e8 21 f8 ff ff       	call   800bb5 <cprintf>
  801394:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801397:	e8 5b 0d 00 00       	call   8020f7 <sys_enable_interrupt>
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
  80142f:	e8 c3 0c 00 00       	call   8020f7 <sys_enable_interrupt>
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
  801b5c:	68 a4 45 80 00       	push   $0x8045a4
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
  801c2c:	e8 42 04 00 00       	call   802073 <sys_allocate_chunk>
  801c31:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801c34:	a1 20 51 80 00       	mov    0x805120,%eax
  801c39:	83 ec 0c             	sub    $0xc,%esp
  801c3c:	50                   	push   %eax
  801c3d:	e8 b7 0a 00 00       	call   8026f9 <initialize_MemBlocksList>
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
  801c6a:	68 c9 45 80 00       	push   $0x8045c9
  801c6f:	6a 33                	push   $0x33
  801c71:	68 e7 45 80 00       	push   $0x8045e7
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
  801ce9:	68 f4 45 80 00       	push   $0x8045f4
  801cee:	6a 34                	push   $0x34
  801cf0:	68 e7 45 80 00       	push   $0x8045e7
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
  801d5e:	68 18 46 80 00       	push   $0x804618
  801d63:	6a 46                	push   $0x46
  801d65:	68 e7 45 80 00       	push   $0x8045e7
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
  801d7a:	68 40 46 80 00       	push   $0x804640
  801d7f:	6a 61                	push   $0x61
  801d81:	68 e7 45 80 00       	push   $0x8045e7
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
  801da0:	75 0a                	jne    801dac <smalloc+0x21>
  801da2:	b8 00 00 00 00       	mov    $0x0,%eax
  801da7:	e9 9e 00 00 00       	jmp    801e4a <smalloc+0xbf>
	//3-If the Kernel successfully creates the shared variable, return its virtual address
	//4-Else, return NULL



	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801dac:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801db3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801db6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801db9:	01 d0                	add    %edx,%eax
  801dbb:	48                   	dec    %eax
  801dbc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801dbf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dc2:	ba 00 00 00 00       	mov    $0x0,%edx
  801dc7:	f7 75 f0             	divl   -0x10(%ebp)
  801dca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dcd:	29 d0                	sub    %edx,%eax
  801dcf:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801dd2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801dd9:	e8 63 06 00 00       	call   802441 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801dde:	85 c0                	test   %eax,%eax
  801de0:	74 11                	je     801df3 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801de2:	83 ec 0c             	sub    $0xc,%esp
  801de5:	ff 75 e8             	pushl  -0x18(%ebp)
  801de8:	e8 ce 0c 00 00       	call   802abb <alloc_block_FF>
  801ded:	83 c4 10             	add    $0x10,%esp
  801df0:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801df3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801df7:	74 4c                	je     801e45 <smalloc+0xba>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801df9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dfc:	8b 40 08             	mov    0x8(%eax),%eax
  801dff:	89 c2                	mov    %eax,%edx
  801e01:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801e05:	52                   	push   %edx
  801e06:	50                   	push   %eax
  801e07:	ff 75 0c             	pushl  0xc(%ebp)
  801e0a:	ff 75 08             	pushl  0x8(%ebp)
  801e0d:	e8 b4 03 00 00       	call   8021c6 <sys_createSharedObject>
  801e12:	83 c4 10             	add    $0x10,%esp
  801e15:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("Output is :  %d \n" , result);
  801e18:	83 ec 08             	sub    $0x8,%esp
  801e1b:	ff 75 e0             	pushl  -0x20(%ebp)
  801e1e:	68 63 46 80 00       	push   $0x804663
  801e23:	e8 8d ed ff ff       	call   800bb5 <cprintf>
  801e28:	83 c4 10             	add    $0x10,%esp
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801e2b:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801e2f:	74 14                	je     801e45 <smalloc+0xba>
  801e31:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801e35:	74 0e                	je     801e45 <smalloc+0xba>
  801e37:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801e3b:	74 08                	je     801e45 <smalloc+0xba>
			return (void*) mem_block->sva;
  801e3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e40:	8b 40 08             	mov    0x8(%eax),%eax
  801e43:	eb 05                	jmp    801e4a <smalloc+0xbf>
	}
	return NULL;
  801e45:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801e4a:	c9                   	leave  
  801e4b:	c3                   	ret    

00801e4c <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801e4c:	55                   	push   %ebp
  801e4d:	89 e5                	mov    %esp,%ebp
  801e4f:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e52:	e8 ee fc ff ff       	call   801b45 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801e57:	83 ec 04             	sub    $0x4,%esp
  801e5a:	68 78 46 80 00       	push   $0x804678
  801e5f:	68 ab 00 00 00       	push   $0xab
  801e64:	68 e7 45 80 00       	push   $0x8045e7
  801e69:	e8 93 ea ff ff       	call   800901 <_panic>

00801e6e <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801e6e:	55                   	push   %ebp
  801e6f:	89 e5                	mov    %esp,%ebp
  801e71:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e74:	e8 cc fc ff ff       	call   801b45 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801e79:	83 ec 04             	sub    $0x4,%esp
  801e7c:	68 9c 46 80 00       	push   $0x80469c
  801e81:	68 ef 00 00 00       	push   $0xef
  801e86:	68 e7 45 80 00       	push   $0x8045e7
  801e8b:	e8 71 ea ff ff       	call   800901 <_panic>

00801e90 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801e90:	55                   	push   %ebp
  801e91:	89 e5                	mov    %esp,%ebp
  801e93:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801e96:	83 ec 04             	sub    $0x4,%esp
  801e99:	68 c4 46 80 00       	push   $0x8046c4
  801e9e:	68 03 01 00 00       	push   $0x103
  801ea3:	68 e7 45 80 00       	push   $0x8045e7
  801ea8:	e8 54 ea ff ff       	call   800901 <_panic>

00801ead <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801ead:	55                   	push   %ebp
  801eae:	89 e5                	mov    %esp,%ebp
  801eb0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801eb3:	83 ec 04             	sub    $0x4,%esp
  801eb6:	68 e8 46 80 00       	push   $0x8046e8
  801ebb:	68 0e 01 00 00       	push   $0x10e
  801ec0:	68 e7 45 80 00       	push   $0x8045e7
  801ec5:	e8 37 ea ff ff       	call   800901 <_panic>

00801eca <shrink>:

}
void shrink(uint32 newSize)
{
  801eca:	55                   	push   %ebp
  801ecb:	89 e5                	mov    %esp,%ebp
  801ecd:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ed0:	83 ec 04             	sub    $0x4,%esp
  801ed3:	68 e8 46 80 00       	push   $0x8046e8
  801ed8:	68 13 01 00 00       	push   $0x113
  801edd:	68 e7 45 80 00       	push   $0x8045e7
  801ee2:	e8 1a ea ff ff       	call   800901 <_panic>

00801ee7 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801ee7:	55                   	push   %ebp
  801ee8:	89 e5                	mov    %esp,%ebp
  801eea:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801eed:	83 ec 04             	sub    $0x4,%esp
  801ef0:	68 e8 46 80 00       	push   $0x8046e8
  801ef5:	68 18 01 00 00       	push   $0x118
  801efa:	68 e7 45 80 00       	push   $0x8045e7
  801eff:	e8 fd e9 ff ff       	call   800901 <_panic>

00801f04 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801f04:	55                   	push   %ebp
  801f05:	89 e5                	mov    %esp,%ebp
  801f07:	57                   	push   %edi
  801f08:	56                   	push   %esi
  801f09:	53                   	push   %ebx
  801f0a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f10:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f13:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f16:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f19:	8b 7d 18             	mov    0x18(%ebp),%edi
  801f1c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801f1f:	cd 30                	int    $0x30
  801f21:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801f24:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f27:	83 c4 10             	add    $0x10,%esp
  801f2a:	5b                   	pop    %ebx
  801f2b:	5e                   	pop    %esi
  801f2c:	5f                   	pop    %edi
  801f2d:	5d                   	pop    %ebp
  801f2e:	c3                   	ret    

00801f2f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801f2f:	55                   	push   %ebp
  801f30:	89 e5                	mov    %esp,%ebp
  801f32:	83 ec 04             	sub    $0x4,%esp
  801f35:	8b 45 10             	mov    0x10(%ebp),%eax
  801f38:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801f3b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f42:	6a 00                	push   $0x0
  801f44:	6a 00                	push   $0x0
  801f46:	52                   	push   %edx
  801f47:	ff 75 0c             	pushl  0xc(%ebp)
  801f4a:	50                   	push   %eax
  801f4b:	6a 00                	push   $0x0
  801f4d:	e8 b2 ff ff ff       	call   801f04 <syscall>
  801f52:	83 c4 18             	add    $0x18,%esp
}
  801f55:	90                   	nop
  801f56:	c9                   	leave  
  801f57:	c3                   	ret    

00801f58 <sys_cgetc>:

int
sys_cgetc(void)
{
  801f58:	55                   	push   %ebp
  801f59:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801f5b:	6a 00                	push   $0x0
  801f5d:	6a 00                	push   $0x0
  801f5f:	6a 00                	push   $0x0
  801f61:	6a 00                	push   $0x0
  801f63:	6a 00                	push   $0x0
  801f65:	6a 01                	push   $0x1
  801f67:	e8 98 ff ff ff       	call   801f04 <syscall>
  801f6c:	83 c4 18             	add    $0x18,%esp
}
  801f6f:	c9                   	leave  
  801f70:	c3                   	ret    

00801f71 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801f71:	55                   	push   %ebp
  801f72:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801f74:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f77:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7a:	6a 00                	push   $0x0
  801f7c:	6a 00                	push   $0x0
  801f7e:	6a 00                	push   $0x0
  801f80:	52                   	push   %edx
  801f81:	50                   	push   %eax
  801f82:	6a 05                	push   $0x5
  801f84:	e8 7b ff ff ff       	call   801f04 <syscall>
  801f89:	83 c4 18             	add    $0x18,%esp
}
  801f8c:	c9                   	leave  
  801f8d:	c3                   	ret    

00801f8e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801f8e:	55                   	push   %ebp
  801f8f:	89 e5                	mov    %esp,%ebp
  801f91:	56                   	push   %esi
  801f92:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801f93:	8b 75 18             	mov    0x18(%ebp),%esi
  801f96:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f99:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa2:	56                   	push   %esi
  801fa3:	53                   	push   %ebx
  801fa4:	51                   	push   %ecx
  801fa5:	52                   	push   %edx
  801fa6:	50                   	push   %eax
  801fa7:	6a 06                	push   $0x6
  801fa9:	e8 56 ff ff ff       	call   801f04 <syscall>
  801fae:	83 c4 18             	add    $0x18,%esp
}
  801fb1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fb4:	5b                   	pop    %ebx
  801fb5:	5e                   	pop    %esi
  801fb6:	5d                   	pop    %ebp
  801fb7:	c3                   	ret    

00801fb8 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801fb8:	55                   	push   %ebp
  801fb9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801fbb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc1:	6a 00                	push   $0x0
  801fc3:	6a 00                	push   $0x0
  801fc5:	6a 00                	push   $0x0
  801fc7:	52                   	push   %edx
  801fc8:	50                   	push   %eax
  801fc9:	6a 07                	push   $0x7
  801fcb:	e8 34 ff ff ff       	call   801f04 <syscall>
  801fd0:	83 c4 18             	add    $0x18,%esp
}
  801fd3:	c9                   	leave  
  801fd4:	c3                   	ret    

00801fd5 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801fd5:	55                   	push   %ebp
  801fd6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801fd8:	6a 00                	push   $0x0
  801fda:	6a 00                	push   $0x0
  801fdc:	6a 00                	push   $0x0
  801fde:	ff 75 0c             	pushl  0xc(%ebp)
  801fe1:	ff 75 08             	pushl  0x8(%ebp)
  801fe4:	6a 08                	push   $0x8
  801fe6:	e8 19 ff ff ff       	call   801f04 <syscall>
  801feb:	83 c4 18             	add    $0x18,%esp
}
  801fee:	c9                   	leave  
  801fef:	c3                   	ret    

00801ff0 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801ff0:	55                   	push   %ebp
  801ff1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801ff3:	6a 00                	push   $0x0
  801ff5:	6a 00                	push   $0x0
  801ff7:	6a 00                	push   $0x0
  801ff9:	6a 00                	push   $0x0
  801ffb:	6a 00                	push   $0x0
  801ffd:	6a 09                	push   $0x9
  801fff:	e8 00 ff ff ff       	call   801f04 <syscall>
  802004:	83 c4 18             	add    $0x18,%esp
}
  802007:	c9                   	leave  
  802008:	c3                   	ret    

00802009 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802009:	55                   	push   %ebp
  80200a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80200c:	6a 00                	push   $0x0
  80200e:	6a 00                	push   $0x0
  802010:	6a 00                	push   $0x0
  802012:	6a 00                	push   $0x0
  802014:	6a 00                	push   $0x0
  802016:	6a 0a                	push   $0xa
  802018:	e8 e7 fe ff ff       	call   801f04 <syscall>
  80201d:	83 c4 18             	add    $0x18,%esp
}
  802020:	c9                   	leave  
  802021:	c3                   	ret    

00802022 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802022:	55                   	push   %ebp
  802023:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802025:	6a 00                	push   $0x0
  802027:	6a 00                	push   $0x0
  802029:	6a 00                	push   $0x0
  80202b:	6a 00                	push   $0x0
  80202d:	6a 00                	push   $0x0
  80202f:	6a 0b                	push   $0xb
  802031:	e8 ce fe ff ff       	call   801f04 <syscall>
  802036:	83 c4 18             	add    $0x18,%esp
}
  802039:	c9                   	leave  
  80203a:	c3                   	ret    

0080203b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80203b:	55                   	push   %ebp
  80203c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80203e:	6a 00                	push   $0x0
  802040:	6a 00                	push   $0x0
  802042:	6a 00                	push   $0x0
  802044:	ff 75 0c             	pushl  0xc(%ebp)
  802047:	ff 75 08             	pushl  0x8(%ebp)
  80204a:	6a 0f                	push   $0xf
  80204c:	e8 b3 fe ff ff       	call   801f04 <syscall>
  802051:	83 c4 18             	add    $0x18,%esp
	return;
  802054:	90                   	nop
}
  802055:	c9                   	leave  
  802056:	c3                   	ret    

00802057 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802057:	55                   	push   %ebp
  802058:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80205a:	6a 00                	push   $0x0
  80205c:	6a 00                	push   $0x0
  80205e:	6a 00                	push   $0x0
  802060:	ff 75 0c             	pushl  0xc(%ebp)
  802063:	ff 75 08             	pushl  0x8(%ebp)
  802066:	6a 10                	push   $0x10
  802068:	e8 97 fe ff ff       	call   801f04 <syscall>
  80206d:	83 c4 18             	add    $0x18,%esp
	return ;
  802070:	90                   	nop
}
  802071:	c9                   	leave  
  802072:	c3                   	ret    

00802073 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802073:	55                   	push   %ebp
  802074:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802076:	6a 00                	push   $0x0
  802078:	6a 00                	push   $0x0
  80207a:	ff 75 10             	pushl  0x10(%ebp)
  80207d:	ff 75 0c             	pushl  0xc(%ebp)
  802080:	ff 75 08             	pushl  0x8(%ebp)
  802083:	6a 11                	push   $0x11
  802085:	e8 7a fe ff ff       	call   801f04 <syscall>
  80208a:	83 c4 18             	add    $0x18,%esp
	return ;
  80208d:	90                   	nop
}
  80208e:	c9                   	leave  
  80208f:	c3                   	ret    

00802090 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802090:	55                   	push   %ebp
  802091:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802093:	6a 00                	push   $0x0
  802095:	6a 00                	push   $0x0
  802097:	6a 00                	push   $0x0
  802099:	6a 00                	push   $0x0
  80209b:	6a 00                	push   $0x0
  80209d:	6a 0c                	push   $0xc
  80209f:	e8 60 fe ff ff       	call   801f04 <syscall>
  8020a4:	83 c4 18             	add    $0x18,%esp
}
  8020a7:	c9                   	leave  
  8020a8:	c3                   	ret    

008020a9 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8020a9:	55                   	push   %ebp
  8020aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8020ac:	6a 00                	push   $0x0
  8020ae:	6a 00                	push   $0x0
  8020b0:	6a 00                	push   $0x0
  8020b2:	6a 00                	push   $0x0
  8020b4:	ff 75 08             	pushl  0x8(%ebp)
  8020b7:	6a 0d                	push   $0xd
  8020b9:	e8 46 fe ff ff       	call   801f04 <syscall>
  8020be:	83 c4 18             	add    $0x18,%esp
}
  8020c1:	c9                   	leave  
  8020c2:	c3                   	ret    

008020c3 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8020c3:	55                   	push   %ebp
  8020c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8020c6:	6a 00                	push   $0x0
  8020c8:	6a 00                	push   $0x0
  8020ca:	6a 00                	push   $0x0
  8020cc:	6a 00                	push   $0x0
  8020ce:	6a 00                	push   $0x0
  8020d0:	6a 0e                	push   $0xe
  8020d2:	e8 2d fe ff ff       	call   801f04 <syscall>
  8020d7:	83 c4 18             	add    $0x18,%esp
}
  8020da:	90                   	nop
  8020db:	c9                   	leave  
  8020dc:	c3                   	ret    

008020dd <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8020dd:	55                   	push   %ebp
  8020de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8020e0:	6a 00                	push   $0x0
  8020e2:	6a 00                	push   $0x0
  8020e4:	6a 00                	push   $0x0
  8020e6:	6a 00                	push   $0x0
  8020e8:	6a 00                	push   $0x0
  8020ea:	6a 13                	push   $0x13
  8020ec:	e8 13 fe ff ff       	call   801f04 <syscall>
  8020f1:	83 c4 18             	add    $0x18,%esp
}
  8020f4:	90                   	nop
  8020f5:	c9                   	leave  
  8020f6:	c3                   	ret    

008020f7 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8020f7:	55                   	push   %ebp
  8020f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8020fa:	6a 00                	push   $0x0
  8020fc:	6a 00                	push   $0x0
  8020fe:	6a 00                	push   $0x0
  802100:	6a 00                	push   $0x0
  802102:	6a 00                	push   $0x0
  802104:	6a 14                	push   $0x14
  802106:	e8 f9 fd ff ff       	call   801f04 <syscall>
  80210b:	83 c4 18             	add    $0x18,%esp
}
  80210e:	90                   	nop
  80210f:	c9                   	leave  
  802110:	c3                   	ret    

00802111 <sys_cputc>:


void
sys_cputc(const char c)
{
  802111:	55                   	push   %ebp
  802112:	89 e5                	mov    %esp,%ebp
  802114:	83 ec 04             	sub    $0x4,%esp
  802117:	8b 45 08             	mov    0x8(%ebp),%eax
  80211a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80211d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802121:	6a 00                	push   $0x0
  802123:	6a 00                	push   $0x0
  802125:	6a 00                	push   $0x0
  802127:	6a 00                	push   $0x0
  802129:	50                   	push   %eax
  80212a:	6a 15                	push   $0x15
  80212c:	e8 d3 fd ff ff       	call   801f04 <syscall>
  802131:	83 c4 18             	add    $0x18,%esp
}
  802134:	90                   	nop
  802135:	c9                   	leave  
  802136:	c3                   	ret    

00802137 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802137:	55                   	push   %ebp
  802138:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80213a:	6a 00                	push   $0x0
  80213c:	6a 00                	push   $0x0
  80213e:	6a 00                	push   $0x0
  802140:	6a 00                	push   $0x0
  802142:	6a 00                	push   $0x0
  802144:	6a 16                	push   $0x16
  802146:	e8 b9 fd ff ff       	call   801f04 <syscall>
  80214b:	83 c4 18             	add    $0x18,%esp
}
  80214e:	90                   	nop
  80214f:	c9                   	leave  
  802150:	c3                   	ret    

00802151 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802151:	55                   	push   %ebp
  802152:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802154:	8b 45 08             	mov    0x8(%ebp),%eax
  802157:	6a 00                	push   $0x0
  802159:	6a 00                	push   $0x0
  80215b:	6a 00                	push   $0x0
  80215d:	ff 75 0c             	pushl  0xc(%ebp)
  802160:	50                   	push   %eax
  802161:	6a 17                	push   $0x17
  802163:	e8 9c fd ff ff       	call   801f04 <syscall>
  802168:	83 c4 18             	add    $0x18,%esp
}
  80216b:	c9                   	leave  
  80216c:	c3                   	ret    

0080216d <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80216d:	55                   	push   %ebp
  80216e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802170:	8b 55 0c             	mov    0xc(%ebp),%edx
  802173:	8b 45 08             	mov    0x8(%ebp),%eax
  802176:	6a 00                	push   $0x0
  802178:	6a 00                	push   $0x0
  80217a:	6a 00                	push   $0x0
  80217c:	52                   	push   %edx
  80217d:	50                   	push   %eax
  80217e:	6a 1a                	push   $0x1a
  802180:	e8 7f fd ff ff       	call   801f04 <syscall>
  802185:	83 c4 18             	add    $0x18,%esp
}
  802188:	c9                   	leave  
  802189:	c3                   	ret    

0080218a <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80218a:	55                   	push   %ebp
  80218b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80218d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802190:	8b 45 08             	mov    0x8(%ebp),%eax
  802193:	6a 00                	push   $0x0
  802195:	6a 00                	push   $0x0
  802197:	6a 00                	push   $0x0
  802199:	52                   	push   %edx
  80219a:	50                   	push   %eax
  80219b:	6a 18                	push   $0x18
  80219d:	e8 62 fd ff ff       	call   801f04 <syscall>
  8021a2:	83 c4 18             	add    $0x18,%esp
}
  8021a5:	90                   	nop
  8021a6:	c9                   	leave  
  8021a7:	c3                   	ret    

008021a8 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8021a8:	55                   	push   %ebp
  8021a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8021ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b1:	6a 00                	push   $0x0
  8021b3:	6a 00                	push   $0x0
  8021b5:	6a 00                	push   $0x0
  8021b7:	52                   	push   %edx
  8021b8:	50                   	push   %eax
  8021b9:	6a 19                	push   $0x19
  8021bb:	e8 44 fd ff ff       	call   801f04 <syscall>
  8021c0:	83 c4 18             	add    $0x18,%esp
}
  8021c3:	90                   	nop
  8021c4:	c9                   	leave  
  8021c5:	c3                   	ret    

008021c6 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8021c6:	55                   	push   %ebp
  8021c7:	89 e5                	mov    %esp,%ebp
  8021c9:	83 ec 04             	sub    $0x4,%esp
  8021cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8021cf:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8021d2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8021d5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8021d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021dc:	6a 00                	push   $0x0
  8021de:	51                   	push   %ecx
  8021df:	52                   	push   %edx
  8021e0:	ff 75 0c             	pushl  0xc(%ebp)
  8021e3:	50                   	push   %eax
  8021e4:	6a 1b                	push   $0x1b
  8021e6:	e8 19 fd ff ff       	call   801f04 <syscall>
  8021eb:	83 c4 18             	add    $0x18,%esp
}
  8021ee:	c9                   	leave  
  8021ef:	c3                   	ret    

008021f0 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8021f0:	55                   	push   %ebp
  8021f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8021f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f9:	6a 00                	push   $0x0
  8021fb:	6a 00                	push   $0x0
  8021fd:	6a 00                	push   $0x0
  8021ff:	52                   	push   %edx
  802200:	50                   	push   %eax
  802201:	6a 1c                	push   $0x1c
  802203:	e8 fc fc ff ff       	call   801f04 <syscall>
  802208:	83 c4 18             	add    $0x18,%esp
}
  80220b:	c9                   	leave  
  80220c:	c3                   	ret    

0080220d <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80220d:	55                   	push   %ebp
  80220e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802210:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802213:	8b 55 0c             	mov    0xc(%ebp),%edx
  802216:	8b 45 08             	mov    0x8(%ebp),%eax
  802219:	6a 00                	push   $0x0
  80221b:	6a 00                	push   $0x0
  80221d:	51                   	push   %ecx
  80221e:	52                   	push   %edx
  80221f:	50                   	push   %eax
  802220:	6a 1d                	push   $0x1d
  802222:	e8 dd fc ff ff       	call   801f04 <syscall>
  802227:	83 c4 18             	add    $0x18,%esp
}
  80222a:	c9                   	leave  
  80222b:	c3                   	ret    

0080222c <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80222c:	55                   	push   %ebp
  80222d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80222f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802232:	8b 45 08             	mov    0x8(%ebp),%eax
  802235:	6a 00                	push   $0x0
  802237:	6a 00                	push   $0x0
  802239:	6a 00                	push   $0x0
  80223b:	52                   	push   %edx
  80223c:	50                   	push   %eax
  80223d:	6a 1e                	push   $0x1e
  80223f:	e8 c0 fc ff ff       	call   801f04 <syscall>
  802244:	83 c4 18             	add    $0x18,%esp
}
  802247:	c9                   	leave  
  802248:	c3                   	ret    

00802249 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802249:	55                   	push   %ebp
  80224a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80224c:	6a 00                	push   $0x0
  80224e:	6a 00                	push   $0x0
  802250:	6a 00                	push   $0x0
  802252:	6a 00                	push   $0x0
  802254:	6a 00                	push   $0x0
  802256:	6a 1f                	push   $0x1f
  802258:	e8 a7 fc ff ff       	call   801f04 <syscall>
  80225d:	83 c4 18             	add    $0x18,%esp
}
  802260:	c9                   	leave  
  802261:	c3                   	ret    

00802262 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802262:	55                   	push   %ebp
  802263:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802265:	8b 45 08             	mov    0x8(%ebp),%eax
  802268:	6a 00                	push   $0x0
  80226a:	ff 75 14             	pushl  0x14(%ebp)
  80226d:	ff 75 10             	pushl  0x10(%ebp)
  802270:	ff 75 0c             	pushl  0xc(%ebp)
  802273:	50                   	push   %eax
  802274:	6a 20                	push   $0x20
  802276:	e8 89 fc ff ff       	call   801f04 <syscall>
  80227b:	83 c4 18             	add    $0x18,%esp
}
  80227e:	c9                   	leave  
  80227f:	c3                   	ret    

00802280 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802280:	55                   	push   %ebp
  802281:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802283:	8b 45 08             	mov    0x8(%ebp),%eax
  802286:	6a 00                	push   $0x0
  802288:	6a 00                	push   $0x0
  80228a:	6a 00                	push   $0x0
  80228c:	6a 00                	push   $0x0
  80228e:	50                   	push   %eax
  80228f:	6a 21                	push   $0x21
  802291:	e8 6e fc ff ff       	call   801f04 <syscall>
  802296:	83 c4 18             	add    $0x18,%esp
}
  802299:	90                   	nop
  80229a:	c9                   	leave  
  80229b:	c3                   	ret    

0080229c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80229c:	55                   	push   %ebp
  80229d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80229f:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a2:	6a 00                	push   $0x0
  8022a4:	6a 00                	push   $0x0
  8022a6:	6a 00                	push   $0x0
  8022a8:	6a 00                	push   $0x0
  8022aa:	50                   	push   %eax
  8022ab:	6a 22                	push   $0x22
  8022ad:	e8 52 fc ff ff       	call   801f04 <syscall>
  8022b2:	83 c4 18             	add    $0x18,%esp
}
  8022b5:	c9                   	leave  
  8022b6:	c3                   	ret    

008022b7 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8022b7:	55                   	push   %ebp
  8022b8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8022ba:	6a 00                	push   $0x0
  8022bc:	6a 00                	push   $0x0
  8022be:	6a 00                	push   $0x0
  8022c0:	6a 00                	push   $0x0
  8022c2:	6a 00                	push   $0x0
  8022c4:	6a 02                	push   $0x2
  8022c6:	e8 39 fc ff ff       	call   801f04 <syscall>
  8022cb:	83 c4 18             	add    $0x18,%esp
}
  8022ce:	c9                   	leave  
  8022cf:	c3                   	ret    

008022d0 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8022d0:	55                   	push   %ebp
  8022d1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8022d3:	6a 00                	push   $0x0
  8022d5:	6a 00                	push   $0x0
  8022d7:	6a 00                	push   $0x0
  8022d9:	6a 00                	push   $0x0
  8022db:	6a 00                	push   $0x0
  8022dd:	6a 03                	push   $0x3
  8022df:	e8 20 fc ff ff       	call   801f04 <syscall>
  8022e4:	83 c4 18             	add    $0x18,%esp
}
  8022e7:	c9                   	leave  
  8022e8:	c3                   	ret    

008022e9 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8022e9:	55                   	push   %ebp
  8022ea:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8022ec:	6a 00                	push   $0x0
  8022ee:	6a 00                	push   $0x0
  8022f0:	6a 00                	push   $0x0
  8022f2:	6a 00                	push   $0x0
  8022f4:	6a 00                	push   $0x0
  8022f6:	6a 04                	push   $0x4
  8022f8:	e8 07 fc ff ff       	call   801f04 <syscall>
  8022fd:	83 c4 18             	add    $0x18,%esp
}
  802300:	c9                   	leave  
  802301:	c3                   	ret    

00802302 <sys_exit_env>:


void sys_exit_env(void)
{
  802302:	55                   	push   %ebp
  802303:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802305:	6a 00                	push   $0x0
  802307:	6a 00                	push   $0x0
  802309:	6a 00                	push   $0x0
  80230b:	6a 00                	push   $0x0
  80230d:	6a 00                	push   $0x0
  80230f:	6a 23                	push   $0x23
  802311:	e8 ee fb ff ff       	call   801f04 <syscall>
  802316:	83 c4 18             	add    $0x18,%esp
}
  802319:	90                   	nop
  80231a:	c9                   	leave  
  80231b:	c3                   	ret    

0080231c <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80231c:	55                   	push   %ebp
  80231d:	89 e5                	mov    %esp,%ebp
  80231f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802322:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802325:	8d 50 04             	lea    0x4(%eax),%edx
  802328:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80232b:	6a 00                	push   $0x0
  80232d:	6a 00                	push   $0x0
  80232f:	6a 00                	push   $0x0
  802331:	52                   	push   %edx
  802332:	50                   	push   %eax
  802333:	6a 24                	push   $0x24
  802335:	e8 ca fb ff ff       	call   801f04 <syscall>
  80233a:	83 c4 18             	add    $0x18,%esp
	return result;
  80233d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802340:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802343:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802346:	89 01                	mov    %eax,(%ecx)
  802348:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80234b:	8b 45 08             	mov    0x8(%ebp),%eax
  80234e:	c9                   	leave  
  80234f:	c2 04 00             	ret    $0x4

00802352 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802352:	55                   	push   %ebp
  802353:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802355:	6a 00                	push   $0x0
  802357:	6a 00                	push   $0x0
  802359:	ff 75 10             	pushl  0x10(%ebp)
  80235c:	ff 75 0c             	pushl  0xc(%ebp)
  80235f:	ff 75 08             	pushl  0x8(%ebp)
  802362:	6a 12                	push   $0x12
  802364:	e8 9b fb ff ff       	call   801f04 <syscall>
  802369:	83 c4 18             	add    $0x18,%esp
	return ;
  80236c:	90                   	nop
}
  80236d:	c9                   	leave  
  80236e:	c3                   	ret    

0080236f <sys_rcr2>:
uint32 sys_rcr2()
{
  80236f:	55                   	push   %ebp
  802370:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802372:	6a 00                	push   $0x0
  802374:	6a 00                	push   $0x0
  802376:	6a 00                	push   $0x0
  802378:	6a 00                	push   $0x0
  80237a:	6a 00                	push   $0x0
  80237c:	6a 25                	push   $0x25
  80237e:	e8 81 fb ff ff       	call   801f04 <syscall>
  802383:	83 c4 18             	add    $0x18,%esp
}
  802386:	c9                   	leave  
  802387:	c3                   	ret    

00802388 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802388:	55                   	push   %ebp
  802389:	89 e5                	mov    %esp,%ebp
  80238b:	83 ec 04             	sub    $0x4,%esp
  80238e:	8b 45 08             	mov    0x8(%ebp),%eax
  802391:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802394:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802398:	6a 00                	push   $0x0
  80239a:	6a 00                	push   $0x0
  80239c:	6a 00                	push   $0x0
  80239e:	6a 00                	push   $0x0
  8023a0:	50                   	push   %eax
  8023a1:	6a 26                	push   $0x26
  8023a3:	e8 5c fb ff ff       	call   801f04 <syscall>
  8023a8:	83 c4 18             	add    $0x18,%esp
	return ;
  8023ab:	90                   	nop
}
  8023ac:	c9                   	leave  
  8023ad:	c3                   	ret    

008023ae <rsttst>:
void rsttst()
{
  8023ae:	55                   	push   %ebp
  8023af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8023b1:	6a 00                	push   $0x0
  8023b3:	6a 00                	push   $0x0
  8023b5:	6a 00                	push   $0x0
  8023b7:	6a 00                	push   $0x0
  8023b9:	6a 00                	push   $0x0
  8023bb:	6a 28                	push   $0x28
  8023bd:	e8 42 fb ff ff       	call   801f04 <syscall>
  8023c2:	83 c4 18             	add    $0x18,%esp
	return ;
  8023c5:	90                   	nop
}
  8023c6:	c9                   	leave  
  8023c7:	c3                   	ret    

008023c8 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8023c8:	55                   	push   %ebp
  8023c9:	89 e5                	mov    %esp,%ebp
  8023cb:	83 ec 04             	sub    $0x4,%esp
  8023ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8023d1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8023d4:	8b 55 18             	mov    0x18(%ebp),%edx
  8023d7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8023db:	52                   	push   %edx
  8023dc:	50                   	push   %eax
  8023dd:	ff 75 10             	pushl  0x10(%ebp)
  8023e0:	ff 75 0c             	pushl  0xc(%ebp)
  8023e3:	ff 75 08             	pushl  0x8(%ebp)
  8023e6:	6a 27                	push   $0x27
  8023e8:	e8 17 fb ff ff       	call   801f04 <syscall>
  8023ed:	83 c4 18             	add    $0x18,%esp
	return ;
  8023f0:	90                   	nop
}
  8023f1:	c9                   	leave  
  8023f2:	c3                   	ret    

008023f3 <chktst>:
void chktst(uint32 n)
{
  8023f3:	55                   	push   %ebp
  8023f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8023f6:	6a 00                	push   $0x0
  8023f8:	6a 00                	push   $0x0
  8023fa:	6a 00                	push   $0x0
  8023fc:	6a 00                	push   $0x0
  8023fe:	ff 75 08             	pushl  0x8(%ebp)
  802401:	6a 29                	push   $0x29
  802403:	e8 fc fa ff ff       	call   801f04 <syscall>
  802408:	83 c4 18             	add    $0x18,%esp
	return ;
  80240b:	90                   	nop
}
  80240c:	c9                   	leave  
  80240d:	c3                   	ret    

0080240e <inctst>:

void inctst()
{
  80240e:	55                   	push   %ebp
  80240f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802411:	6a 00                	push   $0x0
  802413:	6a 00                	push   $0x0
  802415:	6a 00                	push   $0x0
  802417:	6a 00                	push   $0x0
  802419:	6a 00                	push   $0x0
  80241b:	6a 2a                	push   $0x2a
  80241d:	e8 e2 fa ff ff       	call   801f04 <syscall>
  802422:	83 c4 18             	add    $0x18,%esp
	return ;
  802425:	90                   	nop
}
  802426:	c9                   	leave  
  802427:	c3                   	ret    

00802428 <gettst>:
uint32 gettst()
{
  802428:	55                   	push   %ebp
  802429:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80242b:	6a 00                	push   $0x0
  80242d:	6a 00                	push   $0x0
  80242f:	6a 00                	push   $0x0
  802431:	6a 00                	push   $0x0
  802433:	6a 00                	push   $0x0
  802435:	6a 2b                	push   $0x2b
  802437:	e8 c8 fa ff ff       	call   801f04 <syscall>
  80243c:	83 c4 18             	add    $0x18,%esp
}
  80243f:	c9                   	leave  
  802440:	c3                   	ret    

00802441 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802441:	55                   	push   %ebp
  802442:	89 e5                	mov    %esp,%ebp
  802444:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802447:	6a 00                	push   $0x0
  802449:	6a 00                	push   $0x0
  80244b:	6a 00                	push   $0x0
  80244d:	6a 00                	push   $0x0
  80244f:	6a 00                	push   $0x0
  802451:	6a 2c                	push   $0x2c
  802453:	e8 ac fa ff ff       	call   801f04 <syscall>
  802458:	83 c4 18             	add    $0x18,%esp
  80245b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80245e:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802462:	75 07                	jne    80246b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802464:	b8 01 00 00 00       	mov    $0x1,%eax
  802469:	eb 05                	jmp    802470 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80246b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802470:	c9                   	leave  
  802471:	c3                   	ret    

00802472 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802472:	55                   	push   %ebp
  802473:	89 e5                	mov    %esp,%ebp
  802475:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802478:	6a 00                	push   $0x0
  80247a:	6a 00                	push   $0x0
  80247c:	6a 00                	push   $0x0
  80247e:	6a 00                	push   $0x0
  802480:	6a 00                	push   $0x0
  802482:	6a 2c                	push   $0x2c
  802484:	e8 7b fa ff ff       	call   801f04 <syscall>
  802489:	83 c4 18             	add    $0x18,%esp
  80248c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80248f:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802493:	75 07                	jne    80249c <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802495:	b8 01 00 00 00       	mov    $0x1,%eax
  80249a:	eb 05                	jmp    8024a1 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80249c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024a1:	c9                   	leave  
  8024a2:	c3                   	ret    

008024a3 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8024a3:	55                   	push   %ebp
  8024a4:	89 e5                	mov    %esp,%ebp
  8024a6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024a9:	6a 00                	push   $0x0
  8024ab:	6a 00                	push   $0x0
  8024ad:	6a 00                	push   $0x0
  8024af:	6a 00                	push   $0x0
  8024b1:	6a 00                	push   $0x0
  8024b3:	6a 2c                	push   $0x2c
  8024b5:	e8 4a fa ff ff       	call   801f04 <syscall>
  8024ba:	83 c4 18             	add    $0x18,%esp
  8024bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8024c0:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8024c4:	75 07                	jne    8024cd <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8024c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8024cb:	eb 05                	jmp    8024d2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8024cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024d2:	c9                   	leave  
  8024d3:	c3                   	ret    

008024d4 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8024d4:	55                   	push   %ebp
  8024d5:	89 e5                	mov    %esp,%ebp
  8024d7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024da:	6a 00                	push   $0x0
  8024dc:	6a 00                	push   $0x0
  8024de:	6a 00                	push   $0x0
  8024e0:	6a 00                	push   $0x0
  8024e2:	6a 00                	push   $0x0
  8024e4:	6a 2c                	push   $0x2c
  8024e6:	e8 19 fa ff ff       	call   801f04 <syscall>
  8024eb:	83 c4 18             	add    $0x18,%esp
  8024ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8024f1:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8024f5:	75 07                	jne    8024fe <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8024f7:	b8 01 00 00 00       	mov    $0x1,%eax
  8024fc:	eb 05                	jmp    802503 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8024fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802503:	c9                   	leave  
  802504:	c3                   	ret    

00802505 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802505:	55                   	push   %ebp
  802506:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802508:	6a 00                	push   $0x0
  80250a:	6a 00                	push   $0x0
  80250c:	6a 00                	push   $0x0
  80250e:	6a 00                	push   $0x0
  802510:	ff 75 08             	pushl  0x8(%ebp)
  802513:	6a 2d                	push   $0x2d
  802515:	e8 ea f9 ff ff       	call   801f04 <syscall>
  80251a:	83 c4 18             	add    $0x18,%esp
	return ;
  80251d:	90                   	nop
}
  80251e:	c9                   	leave  
  80251f:	c3                   	ret    

00802520 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802520:	55                   	push   %ebp
  802521:	89 e5                	mov    %esp,%ebp
  802523:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802524:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802527:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80252a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80252d:	8b 45 08             	mov    0x8(%ebp),%eax
  802530:	6a 00                	push   $0x0
  802532:	53                   	push   %ebx
  802533:	51                   	push   %ecx
  802534:	52                   	push   %edx
  802535:	50                   	push   %eax
  802536:	6a 2e                	push   $0x2e
  802538:	e8 c7 f9 ff ff       	call   801f04 <syscall>
  80253d:	83 c4 18             	add    $0x18,%esp
}
  802540:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802543:	c9                   	leave  
  802544:	c3                   	ret    

00802545 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802545:	55                   	push   %ebp
  802546:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802548:	8b 55 0c             	mov    0xc(%ebp),%edx
  80254b:	8b 45 08             	mov    0x8(%ebp),%eax
  80254e:	6a 00                	push   $0x0
  802550:	6a 00                	push   $0x0
  802552:	6a 00                	push   $0x0
  802554:	52                   	push   %edx
  802555:	50                   	push   %eax
  802556:	6a 2f                	push   $0x2f
  802558:	e8 a7 f9 ff ff       	call   801f04 <syscall>
  80255d:	83 c4 18             	add    $0x18,%esp
}
  802560:	c9                   	leave  
  802561:	c3                   	ret    

00802562 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802562:	55                   	push   %ebp
  802563:	89 e5                	mov    %esp,%ebp
  802565:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802568:	83 ec 0c             	sub    $0xc,%esp
  80256b:	68 f8 46 80 00       	push   $0x8046f8
  802570:	e8 40 e6 ff ff       	call   800bb5 <cprintf>
  802575:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802578:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80257f:	83 ec 0c             	sub    $0xc,%esp
  802582:	68 24 47 80 00       	push   $0x804724
  802587:	e8 29 e6 ff ff       	call   800bb5 <cprintf>
  80258c:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80258f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802593:	a1 38 51 80 00       	mov    0x805138,%eax
  802598:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80259b:	eb 56                	jmp    8025f3 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80259d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025a1:	74 1c                	je     8025bf <print_mem_block_lists+0x5d>
  8025a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a6:	8b 50 08             	mov    0x8(%eax),%edx
  8025a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ac:	8b 48 08             	mov    0x8(%eax),%ecx
  8025af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8025b5:	01 c8                	add    %ecx,%eax
  8025b7:	39 c2                	cmp    %eax,%edx
  8025b9:	73 04                	jae    8025bf <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8025bb:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8025bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c2:	8b 50 08             	mov    0x8(%eax),%edx
  8025c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8025cb:	01 c2                	add    %eax,%edx
  8025cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d0:	8b 40 08             	mov    0x8(%eax),%eax
  8025d3:	83 ec 04             	sub    $0x4,%esp
  8025d6:	52                   	push   %edx
  8025d7:	50                   	push   %eax
  8025d8:	68 39 47 80 00       	push   $0x804739
  8025dd:	e8 d3 e5 ff ff       	call   800bb5 <cprintf>
  8025e2:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8025e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8025eb:	a1 40 51 80 00       	mov    0x805140,%eax
  8025f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025f7:	74 07                	je     802600 <print_mem_block_lists+0x9e>
  8025f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fc:	8b 00                	mov    (%eax),%eax
  8025fe:	eb 05                	jmp    802605 <print_mem_block_lists+0xa3>
  802600:	b8 00 00 00 00       	mov    $0x0,%eax
  802605:	a3 40 51 80 00       	mov    %eax,0x805140
  80260a:	a1 40 51 80 00       	mov    0x805140,%eax
  80260f:	85 c0                	test   %eax,%eax
  802611:	75 8a                	jne    80259d <print_mem_block_lists+0x3b>
  802613:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802617:	75 84                	jne    80259d <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802619:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80261d:	75 10                	jne    80262f <print_mem_block_lists+0xcd>
  80261f:	83 ec 0c             	sub    $0xc,%esp
  802622:	68 48 47 80 00       	push   $0x804748
  802627:	e8 89 e5 ff ff       	call   800bb5 <cprintf>
  80262c:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80262f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802636:	83 ec 0c             	sub    $0xc,%esp
  802639:	68 6c 47 80 00       	push   $0x80476c
  80263e:	e8 72 e5 ff ff       	call   800bb5 <cprintf>
  802643:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802646:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80264a:	a1 40 50 80 00       	mov    0x805040,%eax
  80264f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802652:	eb 56                	jmp    8026aa <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802654:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802658:	74 1c                	je     802676 <print_mem_block_lists+0x114>
  80265a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265d:	8b 50 08             	mov    0x8(%eax),%edx
  802660:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802663:	8b 48 08             	mov    0x8(%eax),%ecx
  802666:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802669:	8b 40 0c             	mov    0xc(%eax),%eax
  80266c:	01 c8                	add    %ecx,%eax
  80266e:	39 c2                	cmp    %eax,%edx
  802670:	73 04                	jae    802676 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802672:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802676:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802679:	8b 50 08             	mov    0x8(%eax),%edx
  80267c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267f:	8b 40 0c             	mov    0xc(%eax),%eax
  802682:	01 c2                	add    %eax,%edx
  802684:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802687:	8b 40 08             	mov    0x8(%eax),%eax
  80268a:	83 ec 04             	sub    $0x4,%esp
  80268d:	52                   	push   %edx
  80268e:	50                   	push   %eax
  80268f:	68 39 47 80 00       	push   $0x804739
  802694:	e8 1c e5 ff ff       	call   800bb5 <cprintf>
  802699:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80269c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8026a2:	a1 48 50 80 00       	mov    0x805048,%eax
  8026a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ae:	74 07                	je     8026b7 <print_mem_block_lists+0x155>
  8026b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b3:	8b 00                	mov    (%eax),%eax
  8026b5:	eb 05                	jmp    8026bc <print_mem_block_lists+0x15a>
  8026b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8026bc:	a3 48 50 80 00       	mov    %eax,0x805048
  8026c1:	a1 48 50 80 00       	mov    0x805048,%eax
  8026c6:	85 c0                	test   %eax,%eax
  8026c8:	75 8a                	jne    802654 <print_mem_block_lists+0xf2>
  8026ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ce:	75 84                	jne    802654 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8026d0:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8026d4:	75 10                	jne    8026e6 <print_mem_block_lists+0x184>
  8026d6:	83 ec 0c             	sub    $0xc,%esp
  8026d9:	68 84 47 80 00       	push   $0x804784
  8026de:	e8 d2 e4 ff ff       	call   800bb5 <cprintf>
  8026e3:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8026e6:	83 ec 0c             	sub    $0xc,%esp
  8026e9:	68 f8 46 80 00       	push   $0x8046f8
  8026ee:	e8 c2 e4 ff ff       	call   800bb5 <cprintf>
  8026f3:	83 c4 10             	add    $0x10,%esp

}
  8026f6:	90                   	nop
  8026f7:	c9                   	leave  
  8026f8:	c3                   	ret    

008026f9 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8026f9:	55                   	push   %ebp
  8026fa:	89 e5                	mov    %esp,%ebp
  8026fc:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8026ff:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802706:	00 00 00 
  802709:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802710:	00 00 00 
  802713:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80271a:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  80271d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802724:	e9 9e 00 00 00       	jmp    8027c7 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802729:	a1 50 50 80 00       	mov    0x805050,%eax
  80272e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802731:	c1 e2 04             	shl    $0x4,%edx
  802734:	01 d0                	add    %edx,%eax
  802736:	85 c0                	test   %eax,%eax
  802738:	75 14                	jne    80274e <initialize_MemBlocksList+0x55>
  80273a:	83 ec 04             	sub    $0x4,%esp
  80273d:	68 ac 47 80 00       	push   $0x8047ac
  802742:	6a 46                	push   $0x46
  802744:	68 cf 47 80 00       	push   $0x8047cf
  802749:	e8 b3 e1 ff ff       	call   800901 <_panic>
  80274e:	a1 50 50 80 00       	mov    0x805050,%eax
  802753:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802756:	c1 e2 04             	shl    $0x4,%edx
  802759:	01 d0                	add    %edx,%eax
  80275b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802761:	89 10                	mov    %edx,(%eax)
  802763:	8b 00                	mov    (%eax),%eax
  802765:	85 c0                	test   %eax,%eax
  802767:	74 18                	je     802781 <initialize_MemBlocksList+0x88>
  802769:	a1 48 51 80 00       	mov    0x805148,%eax
  80276e:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802774:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802777:	c1 e1 04             	shl    $0x4,%ecx
  80277a:	01 ca                	add    %ecx,%edx
  80277c:	89 50 04             	mov    %edx,0x4(%eax)
  80277f:	eb 12                	jmp    802793 <initialize_MemBlocksList+0x9a>
  802781:	a1 50 50 80 00       	mov    0x805050,%eax
  802786:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802789:	c1 e2 04             	shl    $0x4,%edx
  80278c:	01 d0                	add    %edx,%eax
  80278e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802793:	a1 50 50 80 00       	mov    0x805050,%eax
  802798:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80279b:	c1 e2 04             	shl    $0x4,%edx
  80279e:	01 d0                	add    %edx,%eax
  8027a0:	a3 48 51 80 00       	mov    %eax,0x805148
  8027a5:	a1 50 50 80 00       	mov    0x805050,%eax
  8027aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027ad:	c1 e2 04             	shl    $0x4,%edx
  8027b0:	01 d0                	add    %edx,%eax
  8027b2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027b9:	a1 54 51 80 00       	mov    0x805154,%eax
  8027be:	40                   	inc    %eax
  8027bf:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8027c4:	ff 45 f4             	incl   -0xc(%ebp)
  8027c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ca:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027cd:	0f 82 56 ff ff ff    	jb     802729 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8027d3:	90                   	nop
  8027d4:	c9                   	leave  
  8027d5:	c3                   	ret    

008027d6 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8027d6:	55                   	push   %ebp
  8027d7:	89 e5                	mov    %esp,%ebp
  8027d9:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8027dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027df:	8b 00                	mov    (%eax),%eax
  8027e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8027e4:	eb 19                	jmp    8027ff <find_block+0x29>
	{
		if(va==point->sva)
  8027e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027e9:	8b 40 08             	mov    0x8(%eax),%eax
  8027ec:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8027ef:	75 05                	jne    8027f6 <find_block+0x20>
		   return point;
  8027f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027f4:	eb 36                	jmp    80282c <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8027f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f9:	8b 40 08             	mov    0x8(%eax),%eax
  8027fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8027ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802803:	74 07                	je     80280c <find_block+0x36>
  802805:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802808:	8b 00                	mov    (%eax),%eax
  80280a:	eb 05                	jmp    802811 <find_block+0x3b>
  80280c:	b8 00 00 00 00       	mov    $0x0,%eax
  802811:	8b 55 08             	mov    0x8(%ebp),%edx
  802814:	89 42 08             	mov    %eax,0x8(%edx)
  802817:	8b 45 08             	mov    0x8(%ebp),%eax
  80281a:	8b 40 08             	mov    0x8(%eax),%eax
  80281d:	85 c0                	test   %eax,%eax
  80281f:	75 c5                	jne    8027e6 <find_block+0x10>
  802821:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802825:	75 bf                	jne    8027e6 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802827:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80282c:	c9                   	leave  
  80282d:	c3                   	ret    

0080282e <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80282e:	55                   	push   %ebp
  80282f:	89 e5                	mov    %esp,%ebp
  802831:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802834:	a1 40 50 80 00       	mov    0x805040,%eax
  802839:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  80283c:	a1 44 50 80 00       	mov    0x805044,%eax
  802841:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802844:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802847:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80284a:	74 24                	je     802870 <insert_sorted_allocList+0x42>
  80284c:	8b 45 08             	mov    0x8(%ebp),%eax
  80284f:	8b 50 08             	mov    0x8(%eax),%edx
  802852:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802855:	8b 40 08             	mov    0x8(%eax),%eax
  802858:	39 c2                	cmp    %eax,%edx
  80285a:	76 14                	jbe    802870 <insert_sorted_allocList+0x42>
  80285c:	8b 45 08             	mov    0x8(%ebp),%eax
  80285f:	8b 50 08             	mov    0x8(%eax),%edx
  802862:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802865:	8b 40 08             	mov    0x8(%eax),%eax
  802868:	39 c2                	cmp    %eax,%edx
  80286a:	0f 82 60 01 00 00    	jb     8029d0 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802870:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802874:	75 65                	jne    8028db <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802876:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80287a:	75 14                	jne    802890 <insert_sorted_allocList+0x62>
  80287c:	83 ec 04             	sub    $0x4,%esp
  80287f:	68 ac 47 80 00       	push   $0x8047ac
  802884:	6a 6b                	push   $0x6b
  802886:	68 cf 47 80 00       	push   $0x8047cf
  80288b:	e8 71 e0 ff ff       	call   800901 <_panic>
  802890:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802896:	8b 45 08             	mov    0x8(%ebp),%eax
  802899:	89 10                	mov    %edx,(%eax)
  80289b:	8b 45 08             	mov    0x8(%ebp),%eax
  80289e:	8b 00                	mov    (%eax),%eax
  8028a0:	85 c0                	test   %eax,%eax
  8028a2:	74 0d                	je     8028b1 <insert_sorted_allocList+0x83>
  8028a4:	a1 40 50 80 00       	mov    0x805040,%eax
  8028a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8028ac:	89 50 04             	mov    %edx,0x4(%eax)
  8028af:	eb 08                	jmp    8028b9 <insert_sorted_allocList+0x8b>
  8028b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b4:	a3 44 50 80 00       	mov    %eax,0x805044
  8028b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028bc:	a3 40 50 80 00       	mov    %eax,0x805040
  8028c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028cb:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8028d0:	40                   	inc    %eax
  8028d1:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8028d6:	e9 dc 01 00 00       	jmp    802ab7 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8028db:	8b 45 08             	mov    0x8(%ebp),%eax
  8028de:	8b 50 08             	mov    0x8(%eax),%edx
  8028e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e4:	8b 40 08             	mov    0x8(%eax),%eax
  8028e7:	39 c2                	cmp    %eax,%edx
  8028e9:	77 6c                	ja     802957 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8028eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028ef:	74 06                	je     8028f7 <insert_sorted_allocList+0xc9>
  8028f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028f5:	75 14                	jne    80290b <insert_sorted_allocList+0xdd>
  8028f7:	83 ec 04             	sub    $0x4,%esp
  8028fa:	68 e8 47 80 00       	push   $0x8047e8
  8028ff:	6a 6f                	push   $0x6f
  802901:	68 cf 47 80 00       	push   $0x8047cf
  802906:	e8 f6 df ff ff       	call   800901 <_panic>
  80290b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80290e:	8b 50 04             	mov    0x4(%eax),%edx
  802911:	8b 45 08             	mov    0x8(%ebp),%eax
  802914:	89 50 04             	mov    %edx,0x4(%eax)
  802917:	8b 45 08             	mov    0x8(%ebp),%eax
  80291a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80291d:	89 10                	mov    %edx,(%eax)
  80291f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802922:	8b 40 04             	mov    0x4(%eax),%eax
  802925:	85 c0                	test   %eax,%eax
  802927:	74 0d                	je     802936 <insert_sorted_allocList+0x108>
  802929:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80292c:	8b 40 04             	mov    0x4(%eax),%eax
  80292f:	8b 55 08             	mov    0x8(%ebp),%edx
  802932:	89 10                	mov    %edx,(%eax)
  802934:	eb 08                	jmp    80293e <insert_sorted_allocList+0x110>
  802936:	8b 45 08             	mov    0x8(%ebp),%eax
  802939:	a3 40 50 80 00       	mov    %eax,0x805040
  80293e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802941:	8b 55 08             	mov    0x8(%ebp),%edx
  802944:	89 50 04             	mov    %edx,0x4(%eax)
  802947:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80294c:	40                   	inc    %eax
  80294d:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802952:	e9 60 01 00 00       	jmp    802ab7 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802957:	8b 45 08             	mov    0x8(%ebp),%eax
  80295a:	8b 50 08             	mov    0x8(%eax),%edx
  80295d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802960:	8b 40 08             	mov    0x8(%eax),%eax
  802963:	39 c2                	cmp    %eax,%edx
  802965:	0f 82 4c 01 00 00    	jb     802ab7 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80296b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80296f:	75 14                	jne    802985 <insert_sorted_allocList+0x157>
  802971:	83 ec 04             	sub    $0x4,%esp
  802974:	68 20 48 80 00       	push   $0x804820
  802979:	6a 73                	push   $0x73
  80297b:	68 cf 47 80 00       	push   $0x8047cf
  802980:	e8 7c df ff ff       	call   800901 <_panic>
  802985:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80298b:	8b 45 08             	mov    0x8(%ebp),%eax
  80298e:	89 50 04             	mov    %edx,0x4(%eax)
  802991:	8b 45 08             	mov    0x8(%ebp),%eax
  802994:	8b 40 04             	mov    0x4(%eax),%eax
  802997:	85 c0                	test   %eax,%eax
  802999:	74 0c                	je     8029a7 <insert_sorted_allocList+0x179>
  80299b:	a1 44 50 80 00       	mov    0x805044,%eax
  8029a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8029a3:	89 10                	mov    %edx,(%eax)
  8029a5:	eb 08                	jmp    8029af <insert_sorted_allocList+0x181>
  8029a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029aa:	a3 40 50 80 00       	mov    %eax,0x805040
  8029af:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b2:	a3 44 50 80 00       	mov    %eax,0x805044
  8029b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029c0:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029c5:	40                   	inc    %eax
  8029c6:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8029cb:	e9 e7 00 00 00       	jmp    802ab7 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8029d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8029d6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8029dd:	a1 40 50 80 00       	mov    0x805040,%eax
  8029e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029e5:	e9 9d 00 00 00       	jmp    802a87 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8029ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ed:	8b 00                	mov    (%eax),%eax
  8029ef:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8029f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f5:	8b 50 08             	mov    0x8(%eax),%edx
  8029f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fb:	8b 40 08             	mov    0x8(%eax),%eax
  8029fe:	39 c2                	cmp    %eax,%edx
  802a00:	76 7d                	jbe    802a7f <insert_sorted_allocList+0x251>
  802a02:	8b 45 08             	mov    0x8(%ebp),%eax
  802a05:	8b 50 08             	mov    0x8(%eax),%edx
  802a08:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a0b:	8b 40 08             	mov    0x8(%eax),%eax
  802a0e:	39 c2                	cmp    %eax,%edx
  802a10:	73 6d                	jae    802a7f <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802a12:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a16:	74 06                	je     802a1e <insert_sorted_allocList+0x1f0>
  802a18:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a1c:	75 14                	jne    802a32 <insert_sorted_allocList+0x204>
  802a1e:	83 ec 04             	sub    $0x4,%esp
  802a21:	68 44 48 80 00       	push   $0x804844
  802a26:	6a 7f                	push   $0x7f
  802a28:	68 cf 47 80 00       	push   $0x8047cf
  802a2d:	e8 cf de ff ff       	call   800901 <_panic>
  802a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a35:	8b 10                	mov    (%eax),%edx
  802a37:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3a:	89 10                	mov    %edx,(%eax)
  802a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3f:	8b 00                	mov    (%eax),%eax
  802a41:	85 c0                	test   %eax,%eax
  802a43:	74 0b                	je     802a50 <insert_sorted_allocList+0x222>
  802a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a48:	8b 00                	mov    (%eax),%eax
  802a4a:	8b 55 08             	mov    0x8(%ebp),%edx
  802a4d:	89 50 04             	mov    %edx,0x4(%eax)
  802a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a53:	8b 55 08             	mov    0x8(%ebp),%edx
  802a56:	89 10                	mov    %edx,(%eax)
  802a58:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a5e:	89 50 04             	mov    %edx,0x4(%eax)
  802a61:	8b 45 08             	mov    0x8(%ebp),%eax
  802a64:	8b 00                	mov    (%eax),%eax
  802a66:	85 c0                	test   %eax,%eax
  802a68:	75 08                	jne    802a72 <insert_sorted_allocList+0x244>
  802a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6d:	a3 44 50 80 00       	mov    %eax,0x805044
  802a72:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a77:	40                   	inc    %eax
  802a78:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802a7d:	eb 39                	jmp    802ab8 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802a7f:	a1 48 50 80 00       	mov    0x805048,%eax
  802a84:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a8b:	74 07                	je     802a94 <insert_sorted_allocList+0x266>
  802a8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a90:	8b 00                	mov    (%eax),%eax
  802a92:	eb 05                	jmp    802a99 <insert_sorted_allocList+0x26b>
  802a94:	b8 00 00 00 00       	mov    $0x0,%eax
  802a99:	a3 48 50 80 00       	mov    %eax,0x805048
  802a9e:	a1 48 50 80 00       	mov    0x805048,%eax
  802aa3:	85 c0                	test   %eax,%eax
  802aa5:	0f 85 3f ff ff ff    	jne    8029ea <insert_sorted_allocList+0x1bc>
  802aab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aaf:	0f 85 35 ff ff ff    	jne    8029ea <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802ab5:	eb 01                	jmp    802ab8 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802ab7:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802ab8:	90                   	nop
  802ab9:	c9                   	leave  
  802aba:	c3                   	ret    

00802abb <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802abb:	55                   	push   %ebp
  802abc:	89 e5                	mov    %esp,%ebp
  802abe:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802ac1:	a1 38 51 80 00       	mov    0x805138,%eax
  802ac6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ac9:	e9 85 01 00 00       	jmp    802c53 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ad4:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ad7:	0f 82 6e 01 00 00    	jb     802c4b <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802add:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ae3:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ae6:	0f 85 8a 00 00 00    	jne    802b76 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802aec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802af0:	75 17                	jne    802b09 <alloc_block_FF+0x4e>
  802af2:	83 ec 04             	sub    $0x4,%esp
  802af5:	68 78 48 80 00       	push   $0x804878
  802afa:	68 93 00 00 00       	push   $0x93
  802aff:	68 cf 47 80 00       	push   $0x8047cf
  802b04:	e8 f8 dd ff ff       	call   800901 <_panic>
  802b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0c:	8b 00                	mov    (%eax),%eax
  802b0e:	85 c0                	test   %eax,%eax
  802b10:	74 10                	je     802b22 <alloc_block_FF+0x67>
  802b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b15:	8b 00                	mov    (%eax),%eax
  802b17:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b1a:	8b 52 04             	mov    0x4(%edx),%edx
  802b1d:	89 50 04             	mov    %edx,0x4(%eax)
  802b20:	eb 0b                	jmp    802b2d <alloc_block_FF+0x72>
  802b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b25:	8b 40 04             	mov    0x4(%eax),%eax
  802b28:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b30:	8b 40 04             	mov    0x4(%eax),%eax
  802b33:	85 c0                	test   %eax,%eax
  802b35:	74 0f                	je     802b46 <alloc_block_FF+0x8b>
  802b37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3a:	8b 40 04             	mov    0x4(%eax),%eax
  802b3d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b40:	8b 12                	mov    (%edx),%edx
  802b42:	89 10                	mov    %edx,(%eax)
  802b44:	eb 0a                	jmp    802b50 <alloc_block_FF+0x95>
  802b46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b49:	8b 00                	mov    (%eax),%eax
  802b4b:	a3 38 51 80 00       	mov    %eax,0x805138
  802b50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b53:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b63:	a1 44 51 80 00       	mov    0x805144,%eax
  802b68:	48                   	dec    %eax
  802b69:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802b6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b71:	e9 10 01 00 00       	jmp    802c86 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b79:	8b 40 0c             	mov    0xc(%eax),%eax
  802b7c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b7f:	0f 86 c6 00 00 00    	jbe    802c4b <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b85:	a1 48 51 80 00       	mov    0x805148,%eax
  802b8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b90:	8b 50 08             	mov    0x8(%eax),%edx
  802b93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b96:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802b99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b9c:	8b 55 08             	mov    0x8(%ebp),%edx
  802b9f:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802ba2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ba6:	75 17                	jne    802bbf <alloc_block_FF+0x104>
  802ba8:	83 ec 04             	sub    $0x4,%esp
  802bab:	68 78 48 80 00       	push   $0x804878
  802bb0:	68 9b 00 00 00       	push   $0x9b
  802bb5:	68 cf 47 80 00       	push   $0x8047cf
  802bba:	e8 42 dd ff ff       	call   800901 <_panic>
  802bbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc2:	8b 00                	mov    (%eax),%eax
  802bc4:	85 c0                	test   %eax,%eax
  802bc6:	74 10                	je     802bd8 <alloc_block_FF+0x11d>
  802bc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bcb:	8b 00                	mov    (%eax),%eax
  802bcd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bd0:	8b 52 04             	mov    0x4(%edx),%edx
  802bd3:	89 50 04             	mov    %edx,0x4(%eax)
  802bd6:	eb 0b                	jmp    802be3 <alloc_block_FF+0x128>
  802bd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bdb:	8b 40 04             	mov    0x4(%eax),%eax
  802bde:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802be3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be6:	8b 40 04             	mov    0x4(%eax),%eax
  802be9:	85 c0                	test   %eax,%eax
  802beb:	74 0f                	je     802bfc <alloc_block_FF+0x141>
  802bed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf0:	8b 40 04             	mov    0x4(%eax),%eax
  802bf3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bf6:	8b 12                	mov    (%edx),%edx
  802bf8:	89 10                	mov    %edx,(%eax)
  802bfa:	eb 0a                	jmp    802c06 <alloc_block_FF+0x14b>
  802bfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bff:	8b 00                	mov    (%eax),%eax
  802c01:	a3 48 51 80 00       	mov    %eax,0x805148
  802c06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c09:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c12:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c19:	a1 54 51 80 00       	mov    0x805154,%eax
  802c1e:	48                   	dec    %eax
  802c1f:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802c24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c27:	8b 50 08             	mov    0x8(%eax),%edx
  802c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2d:	01 c2                	add    %eax,%edx
  802c2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c32:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802c35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c38:	8b 40 0c             	mov    0xc(%eax),%eax
  802c3b:	2b 45 08             	sub    0x8(%ebp),%eax
  802c3e:	89 c2                	mov    %eax,%edx
  802c40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c43:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802c46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c49:	eb 3b                	jmp    802c86 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802c4b:	a1 40 51 80 00       	mov    0x805140,%eax
  802c50:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c53:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c57:	74 07                	je     802c60 <alloc_block_FF+0x1a5>
  802c59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5c:	8b 00                	mov    (%eax),%eax
  802c5e:	eb 05                	jmp    802c65 <alloc_block_FF+0x1aa>
  802c60:	b8 00 00 00 00       	mov    $0x0,%eax
  802c65:	a3 40 51 80 00       	mov    %eax,0x805140
  802c6a:	a1 40 51 80 00       	mov    0x805140,%eax
  802c6f:	85 c0                	test   %eax,%eax
  802c71:	0f 85 57 fe ff ff    	jne    802ace <alloc_block_FF+0x13>
  802c77:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c7b:	0f 85 4d fe ff ff    	jne    802ace <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802c81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c86:	c9                   	leave  
  802c87:	c3                   	ret    

00802c88 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802c88:	55                   	push   %ebp
  802c89:	89 e5                	mov    %esp,%ebp
  802c8b:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802c8e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802c95:	a1 38 51 80 00       	mov    0x805138,%eax
  802c9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c9d:	e9 df 00 00 00       	jmp    802d81 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ca8:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cab:	0f 82 c8 00 00 00    	jb     802d79 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802cb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb4:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb7:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cba:	0f 85 8a 00 00 00    	jne    802d4a <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802cc0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cc4:	75 17                	jne    802cdd <alloc_block_BF+0x55>
  802cc6:	83 ec 04             	sub    $0x4,%esp
  802cc9:	68 78 48 80 00       	push   $0x804878
  802cce:	68 b7 00 00 00       	push   $0xb7
  802cd3:	68 cf 47 80 00       	push   $0x8047cf
  802cd8:	e8 24 dc ff ff       	call   800901 <_panic>
  802cdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce0:	8b 00                	mov    (%eax),%eax
  802ce2:	85 c0                	test   %eax,%eax
  802ce4:	74 10                	je     802cf6 <alloc_block_BF+0x6e>
  802ce6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce9:	8b 00                	mov    (%eax),%eax
  802ceb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cee:	8b 52 04             	mov    0x4(%edx),%edx
  802cf1:	89 50 04             	mov    %edx,0x4(%eax)
  802cf4:	eb 0b                	jmp    802d01 <alloc_block_BF+0x79>
  802cf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf9:	8b 40 04             	mov    0x4(%eax),%eax
  802cfc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d04:	8b 40 04             	mov    0x4(%eax),%eax
  802d07:	85 c0                	test   %eax,%eax
  802d09:	74 0f                	je     802d1a <alloc_block_BF+0x92>
  802d0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0e:	8b 40 04             	mov    0x4(%eax),%eax
  802d11:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d14:	8b 12                	mov    (%edx),%edx
  802d16:	89 10                	mov    %edx,(%eax)
  802d18:	eb 0a                	jmp    802d24 <alloc_block_BF+0x9c>
  802d1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1d:	8b 00                	mov    (%eax),%eax
  802d1f:	a3 38 51 80 00       	mov    %eax,0x805138
  802d24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d27:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d30:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d37:	a1 44 51 80 00       	mov    0x805144,%eax
  802d3c:	48                   	dec    %eax
  802d3d:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802d42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d45:	e9 4d 01 00 00       	jmp    802e97 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802d4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4d:	8b 40 0c             	mov    0xc(%eax),%eax
  802d50:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d53:	76 24                	jbe    802d79 <alloc_block_BF+0xf1>
  802d55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d58:	8b 40 0c             	mov    0xc(%eax),%eax
  802d5b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802d5e:	73 19                	jae    802d79 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802d60:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802d67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6a:	8b 40 0c             	mov    0xc(%eax),%eax
  802d6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802d70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d73:	8b 40 08             	mov    0x8(%eax),%eax
  802d76:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802d79:	a1 40 51 80 00       	mov    0x805140,%eax
  802d7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d85:	74 07                	je     802d8e <alloc_block_BF+0x106>
  802d87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8a:	8b 00                	mov    (%eax),%eax
  802d8c:	eb 05                	jmp    802d93 <alloc_block_BF+0x10b>
  802d8e:	b8 00 00 00 00       	mov    $0x0,%eax
  802d93:	a3 40 51 80 00       	mov    %eax,0x805140
  802d98:	a1 40 51 80 00       	mov    0x805140,%eax
  802d9d:	85 c0                	test   %eax,%eax
  802d9f:	0f 85 fd fe ff ff    	jne    802ca2 <alloc_block_BF+0x1a>
  802da5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802da9:	0f 85 f3 fe ff ff    	jne    802ca2 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802daf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802db3:	0f 84 d9 00 00 00    	je     802e92 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802db9:	a1 48 51 80 00       	mov    0x805148,%eax
  802dbe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802dc1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dc4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802dc7:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802dca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dcd:	8b 55 08             	mov    0x8(%ebp),%edx
  802dd0:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802dd3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802dd7:	75 17                	jne    802df0 <alloc_block_BF+0x168>
  802dd9:	83 ec 04             	sub    $0x4,%esp
  802ddc:	68 78 48 80 00       	push   $0x804878
  802de1:	68 c7 00 00 00       	push   $0xc7
  802de6:	68 cf 47 80 00       	push   $0x8047cf
  802deb:	e8 11 db ff ff       	call   800901 <_panic>
  802df0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802df3:	8b 00                	mov    (%eax),%eax
  802df5:	85 c0                	test   %eax,%eax
  802df7:	74 10                	je     802e09 <alloc_block_BF+0x181>
  802df9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dfc:	8b 00                	mov    (%eax),%eax
  802dfe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e01:	8b 52 04             	mov    0x4(%edx),%edx
  802e04:	89 50 04             	mov    %edx,0x4(%eax)
  802e07:	eb 0b                	jmp    802e14 <alloc_block_BF+0x18c>
  802e09:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e0c:	8b 40 04             	mov    0x4(%eax),%eax
  802e0f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e17:	8b 40 04             	mov    0x4(%eax),%eax
  802e1a:	85 c0                	test   %eax,%eax
  802e1c:	74 0f                	je     802e2d <alloc_block_BF+0x1a5>
  802e1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e21:	8b 40 04             	mov    0x4(%eax),%eax
  802e24:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e27:	8b 12                	mov    (%edx),%edx
  802e29:	89 10                	mov    %edx,(%eax)
  802e2b:	eb 0a                	jmp    802e37 <alloc_block_BF+0x1af>
  802e2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e30:	8b 00                	mov    (%eax),%eax
  802e32:	a3 48 51 80 00       	mov    %eax,0x805148
  802e37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e3a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e43:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e4a:	a1 54 51 80 00       	mov    0x805154,%eax
  802e4f:	48                   	dec    %eax
  802e50:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802e55:	83 ec 08             	sub    $0x8,%esp
  802e58:	ff 75 ec             	pushl  -0x14(%ebp)
  802e5b:	68 38 51 80 00       	push   $0x805138
  802e60:	e8 71 f9 ff ff       	call   8027d6 <find_block>
  802e65:	83 c4 10             	add    $0x10,%esp
  802e68:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802e6b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e6e:	8b 50 08             	mov    0x8(%eax),%edx
  802e71:	8b 45 08             	mov    0x8(%ebp),%eax
  802e74:	01 c2                	add    %eax,%edx
  802e76:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e79:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802e7c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e7f:	8b 40 0c             	mov    0xc(%eax),%eax
  802e82:	2b 45 08             	sub    0x8(%ebp),%eax
  802e85:	89 c2                	mov    %eax,%edx
  802e87:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e8a:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802e8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e90:	eb 05                	jmp    802e97 <alloc_block_BF+0x20f>
	}
	return NULL;
  802e92:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e97:	c9                   	leave  
  802e98:	c3                   	ret    

00802e99 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802e99:	55                   	push   %ebp
  802e9a:	89 e5                	mov    %esp,%ebp
  802e9c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802e9f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802ea4:	85 c0                	test   %eax,%eax
  802ea6:	0f 85 de 01 00 00    	jne    80308a <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802eac:	a1 38 51 80 00       	mov    0x805138,%eax
  802eb1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802eb4:	e9 9e 01 00 00       	jmp    803057 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802eb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebc:	8b 40 0c             	mov    0xc(%eax),%eax
  802ebf:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ec2:	0f 82 87 01 00 00    	jb     80304f <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802ec8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecb:	8b 40 0c             	mov    0xc(%eax),%eax
  802ece:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ed1:	0f 85 95 00 00 00    	jne    802f6c <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802ed7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802edb:	75 17                	jne    802ef4 <alloc_block_NF+0x5b>
  802edd:	83 ec 04             	sub    $0x4,%esp
  802ee0:	68 78 48 80 00       	push   $0x804878
  802ee5:	68 e0 00 00 00       	push   $0xe0
  802eea:	68 cf 47 80 00       	push   $0x8047cf
  802eef:	e8 0d da ff ff       	call   800901 <_panic>
  802ef4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef7:	8b 00                	mov    (%eax),%eax
  802ef9:	85 c0                	test   %eax,%eax
  802efb:	74 10                	je     802f0d <alloc_block_NF+0x74>
  802efd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f00:	8b 00                	mov    (%eax),%eax
  802f02:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f05:	8b 52 04             	mov    0x4(%edx),%edx
  802f08:	89 50 04             	mov    %edx,0x4(%eax)
  802f0b:	eb 0b                	jmp    802f18 <alloc_block_NF+0x7f>
  802f0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f10:	8b 40 04             	mov    0x4(%eax),%eax
  802f13:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1b:	8b 40 04             	mov    0x4(%eax),%eax
  802f1e:	85 c0                	test   %eax,%eax
  802f20:	74 0f                	je     802f31 <alloc_block_NF+0x98>
  802f22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f25:	8b 40 04             	mov    0x4(%eax),%eax
  802f28:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f2b:	8b 12                	mov    (%edx),%edx
  802f2d:	89 10                	mov    %edx,(%eax)
  802f2f:	eb 0a                	jmp    802f3b <alloc_block_NF+0xa2>
  802f31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f34:	8b 00                	mov    (%eax),%eax
  802f36:	a3 38 51 80 00       	mov    %eax,0x805138
  802f3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f47:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f4e:	a1 44 51 80 00       	mov    0x805144,%eax
  802f53:	48                   	dec    %eax
  802f54:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802f59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5c:	8b 40 08             	mov    0x8(%eax),%eax
  802f5f:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   return  point;
  802f64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f67:	e9 f8 04 00 00       	jmp    803464 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802f6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6f:	8b 40 0c             	mov    0xc(%eax),%eax
  802f72:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f75:	0f 86 d4 00 00 00    	jbe    80304f <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802f7b:	a1 48 51 80 00       	mov    0x805148,%eax
  802f80:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802f83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f86:	8b 50 08             	mov    0x8(%eax),%edx
  802f89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f8c:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802f8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f92:	8b 55 08             	mov    0x8(%ebp),%edx
  802f95:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802f98:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f9c:	75 17                	jne    802fb5 <alloc_block_NF+0x11c>
  802f9e:	83 ec 04             	sub    $0x4,%esp
  802fa1:	68 78 48 80 00       	push   $0x804878
  802fa6:	68 e9 00 00 00       	push   $0xe9
  802fab:	68 cf 47 80 00       	push   $0x8047cf
  802fb0:	e8 4c d9 ff ff       	call   800901 <_panic>
  802fb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb8:	8b 00                	mov    (%eax),%eax
  802fba:	85 c0                	test   %eax,%eax
  802fbc:	74 10                	je     802fce <alloc_block_NF+0x135>
  802fbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc1:	8b 00                	mov    (%eax),%eax
  802fc3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fc6:	8b 52 04             	mov    0x4(%edx),%edx
  802fc9:	89 50 04             	mov    %edx,0x4(%eax)
  802fcc:	eb 0b                	jmp    802fd9 <alloc_block_NF+0x140>
  802fce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fd1:	8b 40 04             	mov    0x4(%eax),%eax
  802fd4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fdc:	8b 40 04             	mov    0x4(%eax),%eax
  802fdf:	85 c0                	test   %eax,%eax
  802fe1:	74 0f                	je     802ff2 <alloc_block_NF+0x159>
  802fe3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe6:	8b 40 04             	mov    0x4(%eax),%eax
  802fe9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fec:	8b 12                	mov    (%edx),%edx
  802fee:	89 10                	mov    %edx,(%eax)
  802ff0:	eb 0a                	jmp    802ffc <alloc_block_NF+0x163>
  802ff2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff5:	8b 00                	mov    (%eax),%eax
  802ff7:	a3 48 51 80 00       	mov    %eax,0x805148
  802ffc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803005:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803008:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80300f:	a1 54 51 80 00       	mov    0x805154,%eax
  803014:	48                   	dec    %eax
  803015:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  80301a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80301d:	8b 40 08             	mov    0x8(%eax),%eax
  803020:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   point->sva += size;
  803025:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803028:	8b 50 08             	mov    0x8(%eax),%edx
  80302b:	8b 45 08             	mov    0x8(%ebp),%eax
  80302e:	01 c2                	add    %eax,%edx
  803030:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803033:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  803036:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803039:	8b 40 0c             	mov    0xc(%eax),%eax
  80303c:	2b 45 08             	sub    0x8(%ebp),%eax
  80303f:	89 c2                	mov    %eax,%edx
  803041:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803044:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  803047:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80304a:	e9 15 04 00 00       	jmp    803464 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80304f:	a1 40 51 80 00       	mov    0x805140,%eax
  803054:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803057:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80305b:	74 07                	je     803064 <alloc_block_NF+0x1cb>
  80305d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803060:	8b 00                	mov    (%eax),%eax
  803062:	eb 05                	jmp    803069 <alloc_block_NF+0x1d0>
  803064:	b8 00 00 00 00       	mov    $0x0,%eax
  803069:	a3 40 51 80 00       	mov    %eax,0x805140
  80306e:	a1 40 51 80 00       	mov    0x805140,%eax
  803073:	85 c0                	test   %eax,%eax
  803075:	0f 85 3e fe ff ff    	jne    802eb9 <alloc_block_NF+0x20>
  80307b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80307f:	0f 85 34 fe ff ff    	jne    802eb9 <alloc_block_NF+0x20>
  803085:	e9 d5 03 00 00       	jmp    80345f <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80308a:	a1 38 51 80 00       	mov    0x805138,%eax
  80308f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803092:	e9 b1 01 00 00       	jmp    803248 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  803097:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309a:	8b 50 08             	mov    0x8(%eax),%edx
  80309d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030a2:	39 c2                	cmp    %eax,%edx
  8030a4:	0f 82 96 01 00 00    	jb     803240 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8030aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ad:	8b 40 0c             	mov    0xc(%eax),%eax
  8030b0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030b3:	0f 82 87 01 00 00    	jb     803240 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8030b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8030bf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030c2:	0f 85 95 00 00 00    	jne    80315d <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8030c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030cc:	75 17                	jne    8030e5 <alloc_block_NF+0x24c>
  8030ce:	83 ec 04             	sub    $0x4,%esp
  8030d1:	68 78 48 80 00       	push   $0x804878
  8030d6:	68 fc 00 00 00       	push   $0xfc
  8030db:	68 cf 47 80 00       	push   $0x8047cf
  8030e0:	e8 1c d8 ff ff       	call   800901 <_panic>
  8030e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e8:	8b 00                	mov    (%eax),%eax
  8030ea:	85 c0                	test   %eax,%eax
  8030ec:	74 10                	je     8030fe <alloc_block_NF+0x265>
  8030ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f1:	8b 00                	mov    (%eax),%eax
  8030f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030f6:	8b 52 04             	mov    0x4(%edx),%edx
  8030f9:	89 50 04             	mov    %edx,0x4(%eax)
  8030fc:	eb 0b                	jmp    803109 <alloc_block_NF+0x270>
  8030fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803101:	8b 40 04             	mov    0x4(%eax),%eax
  803104:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803109:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310c:	8b 40 04             	mov    0x4(%eax),%eax
  80310f:	85 c0                	test   %eax,%eax
  803111:	74 0f                	je     803122 <alloc_block_NF+0x289>
  803113:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803116:	8b 40 04             	mov    0x4(%eax),%eax
  803119:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80311c:	8b 12                	mov    (%edx),%edx
  80311e:	89 10                	mov    %edx,(%eax)
  803120:	eb 0a                	jmp    80312c <alloc_block_NF+0x293>
  803122:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803125:	8b 00                	mov    (%eax),%eax
  803127:	a3 38 51 80 00       	mov    %eax,0x805138
  80312c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803135:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803138:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80313f:	a1 44 51 80 00       	mov    0x805144,%eax
  803144:	48                   	dec    %eax
  803145:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  80314a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314d:	8b 40 08             	mov    0x8(%eax),%eax
  803150:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  803155:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803158:	e9 07 03 00 00       	jmp    803464 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80315d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803160:	8b 40 0c             	mov    0xc(%eax),%eax
  803163:	3b 45 08             	cmp    0x8(%ebp),%eax
  803166:	0f 86 d4 00 00 00    	jbe    803240 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80316c:	a1 48 51 80 00       	mov    0x805148,%eax
  803171:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  803174:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803177:	8b 50 08             	mov    0x8(%eax),%edx
  80317a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80317d:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803180:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803183:	8b 55 08             	mov    0x8(%ebp),%edx
  803186:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803189:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80318d:	75 17                	jne    8031a6 <alloc_block_NF+0x30d>
  80318f:	83 ec 04             	sub    $0x4,%esp
  803192:	68 78 48 80 00       	push   $0x804878
  803197:	68 04 01 00 00       	push   $0x104
  80319c:	68 cf 47 80 00       	push   $0x8047cf
  8031a1:	e8 5b d7 ff ff       	call   800901 <_panic>
  8031a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a9:	8b 00                	mov    (%eax),%eax
  8031ab:	85 c0                	test   %eax,%eax
  8031ad:	74 10                	je     8031bf <alloc_block_NF+0x326>
  8031af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b2:	8b 00                	mov    (%eax),%eax
  8031b4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031b7:	8b 52 04             	mov    0x4(%edx),%edx
  8031ba:	89 50 04             	mov    %edx,0x4(%eax)
  8031bd:	eb 0b                	jmp    8031ca <alloc_block_NF+0x331>
  8031bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c2:	8b 40 04             	mov    0x4(%eax),%eax
  8031c5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031cd:	8b 40 04             	mov    0x4(%eax),%eax
  8031d0:	85 c0                	test   %eax,%eax
  8031d2:	74 0f                	je     8031e3 <alloc_block_NF+0x34a>
  8031d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d7:	8b 40 04             	mov    0x4(%eax),%eax
  8031da:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031dd:	8b 12                	mov    (%edx),%edx
  8031df:	89 10                	mov    %edx,(%eax)
  8031e1:	eb 0a                	jmp    8031ed <alloc_block_NF+0x354>
  8031e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e6:	8b 00                	mov    (%eax),%eax
  8031e8:	a3 48 51 80 00       	mov    %eax,0x805148
  8031ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803200:	a1 54 51 80 00       	mov    0x805154,%eax
  803205:	48                   	dec    %eax
  803206:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  80320b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80320e:	8b 40 08             	mov    0x8(%eax),%eax
  803211:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  803216:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803219:	8b 50 08             	mov    0x8(%eax),%edx
  80321c:	8b 45 08             	mov    0x8(%ebp),%eax
  80321f:	01 c2                	add    %eax,%edx
  803221:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803224:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803227:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322a:	8b 40 0c             	mov    0xc(%eax),%eax
  80322d:	2b 45 08             	sub    0x8(%ebp),%eax
  803230:	89 c2                	mov    %eax,%edx
  803232:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803235:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803238:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80323b:	e9 24 02 00 00       	jmp    803464 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803240:	a1 40 51 80 00       	mov    0x805140,%eax
  803245:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803248:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80324c:	74 07                	je     803255 <alloc_block_NF+0x3bc>
  80324e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803251:	8b 00                	mov    (%eax),%eax
  803253:	eb 05                	jmp    80325a <alloc_block_NF+0x3c1>
  803255:	b8 00 00 00 00       	mov    $0x0,%eax
  80325a:	a3 40 51 80 00       	mov    %eax,0x805140
  80325f:	a1 40 51 80 00       	mov    0x805140,%eax
  803264:	85 c0                	test   %eax,%eax
  803266:	0f 85 2b fe ff ff    	jne    803097 <alloc_block_NF+0x1fe>
  80326c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803270:	0f 85 21 fe ff ff    	jne    803097 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803276:	a1 38 51 80 00       	mov    0x805138,%eax
  80327b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80327e:	e9 ae 01 00 00       	jmp    803431 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  803283:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803286:	8b 50 08             	mov    0x8(%eax),%edx
  803289:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80328e:	39 c2                	cmp    %eax,%edx
  803290:	0f 83 93 01 00 00    	jae    803429 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  803296:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803299:	8b 40 0c             	mov    0xc(%eax),%eax
  80329c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80329f:	0f 82 84 01 00 00    	jb     803429 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  8032a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a8:	8b 40 0c             	mov    0xc(%eax),%eax
  8032ab:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032ae:	0f 85 95 00 00 00    	jne    803349 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8032b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032b8:	75 17                	jne    8032d1 <alloc_block_NF+0x438>
  8032ba:	83 ec 04             	sub    $0x4,%esp
  8032bd:	68 78 48 80 00       	push   $0x804878
  8032c2:	68 14 01 00 00       	push   $0x114
  8032c7:	68 cf 47 80 00       	push   $0x8047cf
  8032cc:	e8 30 d6 ff ff       	call   800901 <_panic>
  8032d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d4:	8b 00                	mov    (%eax),%eax
  8032d6:	85 c0                	test   %eax,%eax
  8032d8:	74 10                	je     8032ea <alloc_block_NF+0x451>
  8032da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032dd:	8b 00                	mov    (%eax),%eax
  8032df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032e2:	8b 52 04             	mov    0x4(%edx),%edx
  8032e5:	89 50 04             	mov    %edx,0x4(%eax)
  8032e8:	eb 0b                	jmp    8032f5 <alloc_block_NF+0x45c>
  8032ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ed:	8b 40 04             	mov    0x4(%eax),%eax
  8032f0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f8:	8b 40 04             	mov    0x4(%eax),%eax
  8032fb:	85 c0                	test   %eax,%eax
  8032fd:	74 0f                	je     80330e <alloc_block_NF+0x475>
  8032ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803302:	8b 40 04             	mov    0x4(%eax),%eax
  803305:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803308:	8b 12                	mov    (%edx),%edx
  80330a:	89 10                	mov    %edx,(%eax)
  80330c:	eb 0a                	jmp    803318 <alloc_block_NF+0x47f>
  80330e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803311:	8b 00                	mov    (%eax),%eax
  803313:	a3 38 51 80 00       	mov    %eax,0x805138
  803318:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80331b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803321:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803324:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80332b:	a1 44 51 80 00       	mov    0x805144,%eax
  803330:	48                   	dec    %eax
  803331:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803336:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803339:	8b 40 08             	mov    0x8(%eax),%eax
  80333c:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  803341:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803344:	e9 1b 01 00 00       	jmp    803464 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803349:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80334c:	8b 40 0c             	mov    0xc(%eax),%eax
  80334f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803352:	0f 86 d1 00 00 00    	jbe    803429 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803358:	a1 48 51 80 00       	mov    0x805148,%eax
  80335d:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  803360:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803363:	8b 50 08             	mov    0x8(%eax),%edx
  803366:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803369:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80336c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80336f:	8b 55 08             	mov    0x8(%ebp),%edx
  803372:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803375:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803379:	75 17                	jne    803392 <alloc_block_NF+0x4f9>
  80337b:	83 ec 04             	sub    $0x4,%esp
  80337e:	68 78 48 80 00       	push   $0x804878
  803383:	68 1c 01 00 00       	push   $0x11c
  803388:	68 cf 47 80 00       	push   $0x8047cf
  80338d:	e8 6f d5 ff ff       	call   800901 <_panic>
  803392:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803395:	8b 00                	mov    (%eax),%eax
  803397:	85 c0                	test   %eax,%eax
  803399:	74 10                	je     8033ab <alloc_block_NF+0x512>
  80339b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80339e:	8b 00                	mov    (%eax),%eax
  8033a0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8033a3:	8b 52 04             	mov    0x4(%edx),%edx
  8033a6:	89 50 04             	mov    %edx,0x4(%eax)
  8033a9:	eb 0b                	jmp    8033b6 <alloc_block_NF+0x51d>
  8033ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033ae:	8b 40 04             	mov    0x4(%eax),%eax
  8033b1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033b9:	8b 40 04             	mov    0x4(%eax),%eax
  8033bc:	85 c0                	test   %eax,%eax
  8033be:	74 0f                	je     8033cf <alloc_block_NF+0x536>
  8033c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033c3:	8b 40 04             	mov    0x4(%eax),%eax
  8033c6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8033c9:	8b 12                	mov    (%edx),%edx
  8033cb:	89 10                	mov    %edx,(%eax)
  8033cd:	eb 0a                	jmp    8033d9 <alloc_block_NF+0x540>
  8033cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033d2:	8b 00                	mov    (%eax),%eax
  8033d4:	a3 48 51 80 00       	mov    %eax,0x805148
  8033d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033ec:	a1 54 51 80 00       	mov    0x805154,%eax
  8033f1:	48                   	dec    %eax
  8033f2:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8033f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033fa:	8b 40 08             	mov    0x8(%eax),%eax
  8033fd:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  803402:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803405:	8b 50 08             	mov    0x8(%eax),%edx
  803408:	8b 45 08             	mov    0x8(%ebp),%eax
  80340b:	01 c2                	add    %eax,%edx
  80340d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803410:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803413:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803416:	8b 40 0c             	mov    0xc(%eax),%eax
  803419:	2b 45 08             	sub    0x8(%ebp),%eax
  80341c:	89 c2                	mov    %eax,%edx
  80341e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803421:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803424:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803427:	eb 3b                	jmp    803464 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803429:	a1 40 51 80 00       	mov    0x805140,%eax
  80342e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803431:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803435:	74 07                	je     80343e <alloc_block_NF+0x5a5>
  803437:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343a:	8b 00                	mov    (%eax),%eax
  80343c:	eb 05                	jmp    803443 <alloc_block_NF+0x5aa>
  80343e:	b8 00 00 00 00       	mov    $0x0,%eax
  803443:	a3 40 51 80 00       	mov    %eax,0x805140
  803448:	a1 40 51 80 00       	mov    0x805140,%eax
  80344d:	85 c0                	test   %eax,%eax
  80344f:	0f 85 2e fe ff ff    	jne    803283 <alloc_block_NF+0x3ea>
  803455:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803459:	0f 85 24 fe ff ff    	jne    803283 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  80345f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803464:	c9                   	leave  
  803465:	c3                   	ret    

00803466 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803466:	55                   	push   %ebp
  803467:	89 e5                	mov    %esp,%ebp
  803469:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  80346c:	a1 38 51 80 00       	mov    0x805138,%eax
  803471:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  803474:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803479:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  80347c:	a1 38 51 80 00       	mov    0x805138,%eax
  803481:	85 c0                	test   %eax,%eax
  803483:	74 14                	je     803499 <insert_sorted_with_merge_freeList+0x33>
  803485:	8b 45 08             	mov    0x8(%ebp),%eax
  803488:	8b 50 08             	mov    0x8(%eax),%edx
  80348b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80348e:	8b 40 08             	mov    0x8(%eax),%eax
  803491:	39 c2                	cmp    %eax,%edx
  803493:	0f 87 9b 01 00 00    	ja     803634 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  803499:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80349d:	75 17                	jne    8034b6 <insert_sorted_with_merge_freeList+0x50>
  80349f:	83 ec 04             	sub    $0x4,%esp
  8034a2:	68 ac 47 80 00       	push   $0x8047ac
  8034a7:	68 38 01 00 00       	push   $0x138
  8034ac:	68 cf 47 80 00       	push   $0x8047cf
  8034b1:	e8 4b d4 ff ff       	call   800901 <_panic>
  8034b6:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8034bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8034bf:	89 10                	mov    %edx,(%eax)
  8034c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c4:	8b 00                	mov    (%eax),%eax
  8034c6:	85 c0                	test   %eax,%eax
  8034c8:	74 0d                	je     8034d7 <insert_sorted_with_merge_freeList+0x71>
  8034ca:	a1 38 51 80 00       	mov    0x805138,%eax
  8034cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8034d2:	89 50 04             	mov    %edx,0x4(%eax)
  8034d5:	eb 08                	jmp    8034df <insert_sorted_with_merge_freeList+0x79>
  8034d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034da:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034df:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e2:	a3 38 51 80 00       	mov    %eax,0x805138
  8034e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034f1:	a1 44 51 80 00       	mov    0x805144,%eax
  8034f6:	40                   	inc    %eax
  8034f7:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8034fc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803500:	0f 84 a8 06 00 00    	je     803bae <insert_sorted_with_merge_freeList+0x748>
  803506:	8b 45 08             	mov    0x8(%ebp),%eax
  803509:	8b 50 08             	mov    0x8(%eax),%edx
  80350c:	8b 45 08             	mov    0x8(%ebp),%eax
  80350f:	8b 40 0c             	mov    0xc(%eax),%eax
  803512:	01 c2                	add    %eax,%edx
  803514:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803517:	8b 40 08             	mov    0x8(%eax),%eax
  80351a:	39 c2                	cmp    %eax,%edx
  80351c:	0f 85 8c 06 00 00    	jne    803bae <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  803522:	8b 45 08             	mov    0x8(%ebp),%eax
  803525:	8b 50 0c             	mov    0xc(%eax),%edx
  803528:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80352b:	8b 40 0c             	mov    0xc(%eax),%eax
  80352e:	01 c2                	add    %eax,%edx
  803530:	8b 45 08             	mov    0x8(%ebp),%eax
  803533:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803536:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80353a:	75 17                	jne    803553 <insert_sorted_with_merge_freeList+0xed>
  80353c:	83 ec 04             	sub    $0x4,%esp
  80353f:	68 78 48 80 00       	push   $0x804878
  803544:	68 3c 01 00 00       	push   $0x13c
  803549:	68 cf 47 80 00       	push   $0x8047cf
  80354e:	e8 ae d3 ff ff       	call   800901 <_panic>
  803553:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803556:	8b 00                	mov    (%eax),%eax
  803558:	85 c0                	test   %eax,%eax
  80355a:	74 10                	je     80356c <insert_sorted_with_merge_freeList+0x106>
  80355c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80355f:	8b 00                	mov    (%eax),%eax
  803561:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803564:	8b 52 04             	mov    0x4(%edx),%edx
  803567:	89 50 04             	mov    %edx,0x4(%eax)
  80356a:	eb 0b                	jmp    803577 <insert_sorted_with_merge_freeList+0x111>
  80356c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80356f:	8b 40 04             	mov    0x4(%eax),%eax
  803572:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803577:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80357a:	8b 40 04             	mov    0x4(%eax),%eax
  80357d:	85 c0                	test   %eax,%eax
  80357f:	74 0f                	je     803590 <insert_sorted_with_merge_freeList+0x12a>
  803581:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803584:	8b 40 04             	mov    0x4(%eax),%eax
  803587:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80358a:	8b 12                	mov    (%edx),%edx
  80358c:	89 10                	mov    %edx,(%eax)
  80358e:	eb 0a                	jmp    80359a <insert_sorted_with_merge_freeList+0x134>
  803590:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803593:	8b 00                	mov    (%eax),%eax
  803595:	a3 38 51 80 00       	mov    %eax,0x805138
  80359a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80359d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035a6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035ad:	a1 44 51 80 00       	mov    0x805144,%eax
  8035b2:	48                   	dec    %eax
  8035b3:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  8035b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035bb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  8035c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035c5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  8035cc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8035d0:	75 17                	jne    8035e9 <insert_sorted_with_merge_freeList+0x183>
  8035d2:	83 ec 04             	sub    $0x4,%esp
  8035d5:	68 ac 47 80 00       	push   $0x8047ac
  8035da:	68 3f 01 00 00       	push   $0x13f
  8035df:	68 cf 47 80 00       	push   $0x8047cf
  8035e4:	e8 18 d3 ff ff       	call   800901 <_panic>
  8035e9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8035ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035f2:	89 10                	mov    %edx,(%eax)
  8035f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035f7:	8b 00                	mov    (%eax),%eax
  8035f9:	85 c0                	test   %eax,%eax
  8035fb:	74 0d                	je     80360a <insert_sorted_with_merge_freeList+0x1a4>
  8035fd:	a1 48 51 80 00       	mov    0x805148,%eax
  803602:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803605:	89 50 04             	mov    %edx,0x4(%eax)
  803608:	eb 08                	jmp    803612 <insert_sorted_with_merge_freeList+0x1ac>
  80360a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80360d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803612:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803615:	a3 48 51 80 00       	mov    %eax,0x805148
  80361a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80361d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803624:	a1 54 51 80 00       	mov    0x805154,%eax
  803629:	40                   	inc    %eax
  80362a:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80362f:	e9 7a 05 00 00       	jmp    803bae <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803634:	8b 45 08             	mov    0x8(%ebp),%eax
  803637:	8b 50 08             	mov    0x8(%eax),%edx
  80363a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80363d:	8b 40 08             	mov    0x8(%eax),%eax
  803640:	39 c2                	cmp    %eax,%edx
  803642:	0f 82 14 01 00 00    	jb     80375c <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803648:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80364b:	8b 50 08             	mov    0x8(%eax),%edx
  80364e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803651:	8b 40 0c             	mov    0xc(%eax),%eax
  803654:	01 c2                	add    %eax,%edx
  803656:	8b 45 08             	mov    0x8(%ebp),%eax
  803659:	8b 40 08             	mov    0x8(%eax),%eax
  80365c:	39 c2                	cmp    %eax,%edx
  80365e:	0f 85 90 00 00 00    	jne    8036f4 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803664:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803667:	8b 50 0c             	mov    0xc(%eax),%edx
  80366a:	8b 45 08             	mov    0x8(%ebp),%eax
  80366d:	8b 40 0c             	mov    0xc(%eax),%eax
  803670:	01 c2                	add    %eax,%edx
  803672:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803675:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803678:	8b 45 08             	mov    0x8(%ebp),%eax
  80367b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803682:	8b 45 08             	mov    0x8(%ebp),%eax
  803685:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80368c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803690:	75 17                	jne    8036a9 <insert_sorted_with_merge_freeList+0x243>
  803692:	83 ec 04             	sub    $0x4,%esp
  803695:	68 ac 47 80 00       	push   $0x8047ac
  80369a:	68 49 01 00 00       	push   $0x149
  80369f:	68 cf 47 80 00       	push   $0x8047cf
  8036a4:	e8 58 d2 ff ff       	call   800901 <_panic>
  8036a9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8036af:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b2:	89 10                	mov    %edx,(%eax)
  8036b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b7:	8b 00                	mov    (%eax),%eax
  8036b9:	85 c0                	test   %eax,%eax
  8036bb:	74 0d                	je     8036ca <insert_sorted_with_merge_freeList+0x264>
  8036bd:	a1 48 51 80 00       	mov    0x805148,%eax
  8036c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8036c5:	89 50 04             	mov    %edx,0x4(%eax)
  8036c8:	eb 08                	jmp    8036d2 <insert_sorted_with_merge_freeList+0x26c>
  8036ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8036cd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d5:	a3 48 51 80 00       	mov    %eax,0x805148
  8036da:	8b 45 08             	mov    0x8(%ebp),%eax
  8036dd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036e4:	a1 54 51 80 00       	mov    0x805154,%eax
  8036e9:	40                   	inc    %eax
  8036ea:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8036ef:	e9 bb 04 00 00       	jmp    803baf <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8036f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036f8:	75 17                	jne    803711 <insert_sorted_with_merge_freeList+0x2ab>
  8036fa:	83 ec 04             	sub    $0x4,%esp
  8036fd:	68 20 48 80 00       	push   $0x804820
  803702:	68 4c 01 00 00       	push   $0x14c
  803707:	68 cf 47 80 00       	push   $0x8047cf
  80370c:	e8 f0 d1 ff ff       	call   800901 <_panic>
  803711:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803717:	8b 45 08             	mov    0x8(%ebp),%eax
  80371a:	89 50 04             	mov    %edx,0x4(%eax)
  80371d:	8b 45 08             	mov    0x8(%ebp),%eax
  803720:	8b 40 04             	mov    0x4(%eax),%eax
  803723:	85 c0                	test   %eax,%eax
  803725:	74 0c                	je     803733 <insert_sorted_with_merge_freeList+0x2cd>
  803727:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80372c:	8b 55 08             	mov    0x8(%ebp),%edx
  80372f:	89 10                	mov    %edx,(%eax)
  803731:	eb 08                	jmp    80373b <insert_sorted_with_merge_freeList+0x2d5>
  803733:	8b 45 08             	mov    0x8(%ebp),%eax
  803736:	a3 38 51 80 00       	mov    %eax,0x805138
  80373b:	8b 45 08             	mov    0x8(%ebp),%eax
  80373e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803743:	8b 45 08             	mov    0x8(%ebp),%eax
  803746:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80374c:	a1 44 51 80 00       	mov    0x805144,%eax
  803751:	40                   	inc    %eax
  803752:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803757:	e9 53 04 00 00       	jmp    803baf <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80375c:	a1 38 51 80 00       	mov    0x805138,%eax
  803761:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803764:	e9 15 04 00 00       	jmp    803b7e <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803769:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80376c:	8b 00                	mov    (%eax),%eax
  80376e:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803771:	8b 45 08             	mov    0x8(%ebp),%eax
  803774:	8b 50 08             	mov    0x8(%eax),%edx
  803777:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80377a:	8b 40 08             	mov    0x8(%eax),%eax
  80377d:	39 c2                	cmp    %eax,%edx
  80377f:	0f 86 f1 03 00 00    	jbe    803b76 <insert_sorted_with_merge_freeList+0x710>
  803785:	8b 45 08             	mov    0x8(%ebp),%eax
  803788:	8b 50 08             	mov    0x8(%eax),%edx
  80378b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80378e:	8b 40 08             	mov    0x8(%eax),%eax
  803791:	39 c2                	cmp    %eax,%edx
  803793:	0f 83 dd 03 00 00    	jae    803b76 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803799:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80379c:	8b 50 08             	mov    0x8(%eax),%edx
  80379f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8037a5:	01 c2                	add    %eax,%edx
  8037a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8037aa:	8b 40 08             	mov    0x8(%eax),%eax
  8037ad:	39 c2                	cmp    %eax,%edx
  8037af:	0f 85 b9 01 00 00    	jne    80396e <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8037b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b8:	8b 50 08             	mov    0x8(%eax),%edx
  8037bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8037be:	8b 40 0c             	mov    0xc(%eax),%eax
  8037c1:	01 c2                	add    %eax,%edx
  8037c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037c6:	8b 40 08             	mov    0x8(%eax),%eax
  8037c9:	39 c2                	cmp    %eax,%edx
  8037cb:	0f 85 0d 01 00 00    	jne    8038de <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8037d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037d4:	8b 50 0c             	mov    0xc(%eax),%edx
  8037d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037da:	8b 40 0c             	mov    0xc(%eax),%eax
  8037dd:	01 c2                	add    %eax,%edx
  8037df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037e2:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8037e5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8037e9:	75 17                	jne    803802 <insert_sorted_with_merge_freeList+0x39c>
  8037eb:	83 ec 04             	sub    $0x4,%esp
  8037ee:	68 78 48 80 00       	push   $0x804878
  8037f3:	68 5c 01 00 00       	push   $0x15c
  8037f8:	68 cf 47 80 00       	push   $0x8047cf
  8037fd:	e8 ff d0 ff ff       	call   800901 <_panic>
  803802:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803805:	8b 00                	mov    (%eax),%eax
  803807:	85 c0                	test   %eax,%eax
  803809:	74 10                	je     80381b <insert_sorted_with_merge_freeList+0x3b5>
  80380b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80380e:	8b 00                	mov    (%eax),%eax
  803810:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803813:	8b 52 04             	mov    0x4(%edx),%edx
  803816:	89 50 04             	mov    %edx,0x4(%eax)
  803819:	eb 0b                	jmp    803826 <insert_sorted_with_merge_freeList+0x3c0>
  80381b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80381e:	8b 40 04             	mov    0x4(%eax),%eax
  803821:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803826:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803829:	8b 40 04             	mov    0x4(%eax),%eax
  80382c:	85 c0                	test   %eax,%eax
  80382e:	74 0f                	je     80383f <insert_sorted_with_merge_freeList+0x3d9>
  803830:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803833:	8b 40 04             	mov    0x4(%eax),%eax
  803836:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803839:	8b 12                	mov    (%edx),%edx
  80383b:	89 10                	mov    %edx,(%eax)
  80383d:	eb 0a                	jmp    803849 <insert_sorted_with_merge_freeList+0x3e3>
  80383f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803842:	8b 00                	mov    (%eax),%eax
  803844:	a3 38 51 80 00       	mov    %eax,0x805138
  803849:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80384c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803852:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803855:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80385c:	a1 44 51 80 00       	mov    0x805144,%eax
  803861:	48                   	dec    %eax
  803862:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803867:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80386a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803871:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803874:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80387b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80387f:	75 17                	jne    803898 <insert_sorted_with_merge_freeList+0x432>
  803881:	83 ec 04             	sub    $0x4,%esp
  803884:	68 ac 47 80 00       	push   $0x8047ac
  803889:	68 5f 01 00 00       	push   $0x15f
  80388e:	68 cf 47 80 00       	push   $0x8047cf
  803893:	e8 69 d0 ff ff       	call   800901 <_panic>
  803898:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80389e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038a1:	89 10                	mov    %edx,(%eax)
  8038a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038a6:	8b 00                	mov    (%eax),%eax
  8038a8:	85 c0                	test   %eax,%eax
  8038aa:	74 0d                	je     8038b9 <insert_sorted_with_merge_freeList+0x453>
  8038ac:	a1 48 51 80 00       	mov    0x805148,%eax
  8038b1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038b4:	89 50 04             	mov    %edx,0x4(%eax)
  8038b7:	eb 08                	jmp    8038c1 <insert_sorted_with_merge_freeList+0x45b>
  8038b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038bc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8038c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038c4:	a3 48 51 80 00       	mov    %eax,0x805148
  8038c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038cc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038d3:	a1 54 51 80 00       	mov    0x805154,%eax
  8038d8:	40                   	inc    %eax
  8038d9:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8038de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038e1:	8b 50 0c             	mov    0xc(%eax),%edx
  8038e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8038ea:	01 c2                	add    %eax,%edx
  8038ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038ef:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8038f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8038fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ff:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803906:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80390a:	75 17                	jne    803923 <insert_sorted_with_merge_freeList+0x4bd>
  80390c:	83 ec 04             	sub    $0x4,%esp
  80390f:	68 ac 47 80 00       	push   $0x8047ac
  803914:	68 64 01 00 00       	push   $0x164
  803919:	68 cf 47 80 00       	push   $0x8047cf
  80391e:	e8 de cf ff ff       	call   800901 <_panic>
  803923:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803929:	8b 45 08             	mov    0x8(%ebp),%eax
  80392c:	89 10                	mov    %edx,(%eax)
  80392e:	8b 45 08             	mov    0x8(%ebp),%eax
  803931:	8b 00                	mov    (%eax),%eax
  803933:	85 c0                	test   %eax,%eax
  803935:	74 0d                	je     803944 <insert_sorted_with_merge_freeList+0x4de>
  803937:	a1 48 51 80 00       	mov    0x805148,%eax
  80393c:	8b 55 08             	mov    0x8(%ebp),%edx
  80393f:	89 50 04             	mov    %edx,0x4(%eax)
  803942:	eb 08                	jmp    80394c <insert_sorted_with_merge_freeList+0x4e6>
  803944:	8b 45 08             	mov    0x8(%ebp),%eax
  803947:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80394c:	8b 45 08             	mov    0x8(%ebp),%eax
  80394f:	a3 48 51 80 00       	mov    %eax,0x805148
  803954:	8b 45 08             	mov    0x8(%ebp),%eax
  803957:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80395e:	a1 54 51 80 00       	mov    0x805154,%eax
  803963:	40                   	inc    %eax
  803964:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803969:	e9 41 02 00 00       	jmp    803baf <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80396e:	8b 45 08             	mov    0x8(%ebp),%eax
  803971:	8b 50 08             	mov    0x8(%eax),%edx
  803974:	8b 45 08             	mov    0x8(%ebp),%eax
  803977:	8b 40 0c             	mov    0xc(%eax),%eax
  80397a:	01 c2                	add    %eax,%edx
  80397c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80397f:	8b 40 08             	mov    0x8(%eax),%eax
  803982:	39 c2                	cmp    %eax,%edx
  803984:	0f 85 7c 01 00 00    	jne    803b06 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80398a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80398e:	74 06                	je     803996 <insert_sorted_with_merge_freeList+0x530>
  803990:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803994:	75 17                	jne    8039ad <insert_sorted_with_merge_freeList+0x547>
  803996:	83 ec 04             	sub    $0x4,%esp
  803999:	68 e8 47 80 00       	push   $0x8047e8
  80399e:	68 69 01 00 00       	push   $0x169
  8039a3:	68 cf 47 80 00       	push   $0x8047cf
  8039a8:	e8 54 cf ff ff       	call   800901 <_panic>
  8039ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039b0:	8b 50 04             	mov    0x4(%eax),%edx
  8039b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8039b6:	89 50 04             	mov    %edx,0x4(%eax)
  8039b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8039bc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039bf:	89 10                	mov    %edx,(%eax)
  8039c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039c4:	8b 40 04             	mov    0x4(%eax),%eax
  8039c7:	85 c0                	test   %eax,%eax
  8039c9:	74 0d                	je     8039d8 <insert_sorted_with_merge_freeList+0x572>
  8039cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039ce:	8b 40 04             	mov    0x4(%eax),%eax
  8039d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8039d4:	89 10                	mov    %edx,(%eax)
  8039d6:	eb 08                	jmp    8039e0 <insert_sorted_with_merge_freeList+0x57a>
  8039d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8039db:	a3 38 51 80 00       	mov    %eax,0x805138
  8039e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8039e6:	89 50 04             	mov    %edx,0x4(%eax)
  8039e9:	a1 44 51 80 00       	mov    0x805144,%eax
  8039ee:	40                   	inc    %eax
  8039ef:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8039f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8039f7:	8b 50 0c             	mov    0xc(%eax),%edx
  8039fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039fd:	8b 40 0c             	mov    0xc(%eax),%eax
  803a00:	01 c2                	add    %eax,%edx
  803a02:	8b 45 08             	mov    0x8(%ebp),%eax
  803a05:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803a08:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803a0c:	75 17                	jne    803a25 <insert_sorted_with_merge_freeList+0x5bf>
  803a0e:	83 ec 04             	sub    $0x4,%esp
  803a11:	68 78 48 80 00       	push   $0x804878
  803a16:	68 6b 01 00 00       	push   $0x16b
  803a1b:	68 cf 47 80 00       	push   $0x8047cf
  803a20:	e8 dc ce ff ff       	call   800901 <_panic>
  803a25:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a28:	8b 00                	mov    (%eax),%eax
  803a2a:	85 c0                	test   %eax,%eax
  803a2c:	74 10                	je     803a3e <insert_sorted_with_merge_freeList+0x5d8>
  803a2e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a31:	8b 00                	mov    (%eax),%eax
  803a33:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a36:	8b 52 04             	mov    0x4(%edx),%edx
  803a39:	89 50 04             	mov    %edx,0x4(%eax)
  803a3c:	eb 0b                	jmp    803a49 <insert_sorted_with_merge_freeList+0x5e3>
  803a3e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a41:	8b 40 04             	mov    0x4(%eax),%eax
  803a44:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803a49:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a4c:	8b 40 04             	mov    0x4(%eax),%eax
  803a4f:	85 c0                	test   %eax,%eax
  803a51:	74 0f                	je     803a62 <insert_sorted_with_merge_freeList+0x5fc>
  803a53:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a56:	8b 40 04             	mov    0x4(%eax),%eax
  803a59:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a5c:	8b 12                	mov    (%edx),%edx
  803a5e:	89 10                	mov    %edx,(%eax)
  803a60:	eb 0a                	jmp    803a6c <insert_sorted_with_merge_freeList+0x606>
  803a62:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a65:	8b 00                	mov    (%eax),%eax
  803a67:	a3 38 51 80 00       	mov    %eax,0x805138
  803a6c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a6f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a75:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a78:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a7f:	a1 44 51 80 00       	mov    0x805144,%eax
  803a84:	48                   	dec    %eax
  803a85:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803a8a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a8d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803a94:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a97:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803a9e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803aa2:	75 17                	jne    803abb <insert_sorted_with_merge_freeList+0x655>
  803aa4:	83 ec 04             	sub    $0x4,%esp
  803aa7:	68 ac 47 80 00       	push   $0x8047ac
  803aac:	68 6e 01 00 00       	push   $0x16e
  803ab1:	68 cf 47 80 00       	push   $0x8047cf
  803ab6:	e8 46 ce ff ff       	call   800901 <_panic>
  803abb:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803ac1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ac4:	89 10                	mov    %edx,(%eax)
  803ac6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ac9:	8b 00                	mov    (%eax),%eax
  803acb:	85 c0                	test   %eax,%eax
  803acd:	74 0d                	je     803adc <insert_sorted_with_merge_freeList+0x676>
  803acf:	a1 48 51 80 00       	mov    0x805148,%eax
  803ad4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803ad7:	89 50 04             	mov    %edx,0x4(%eax)
  803ada:	eb 08                	jmp    803ae4 <insert_sorted_with_merge_freeList+0x67e>
  803adc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803adf:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803ae4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ae7:	a3 48 51 80 00       	mov    %eax,0x805148
  803aec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803aef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803af6:	a1 54 51 80 00       	mov    0x805154,%eax
  803afb:	40                   	inc    %eax
  803afc:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803b01:	e9 a9 00 00 00       	jmp    803baf <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803b06:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b0a:	74 06                	je     803b12 <insert_sorted_with_merge_freeList+0x6ac>
  803b0c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b10:	75 17                	jne    803b29 <insert_sorted_with_merge_freeList+0x6c3>
  803b12:	83 ec 04             	sub    $0x4,%esp
  803b15:	68 44 48 80 00       	push   $0x804844
  803b1a:	68 73 01 00 00       	push   $0x173
  803b1f:	68 cf 47 80 00       	push   $0x8047cf
  803b24:	e8 d8 cd ff ff       	call   800901 <_panic>
  803b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b2c:	8b 10                	mov    (%eax),%edx
  803b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  803b31:	89 10                	mov    %edx,(%eax)
  803b33:	8b 45 08             	mov    0x8(%ebp),%eax
  803b36:	8b 00                	mov    (%eax),%eax
  803b38:	85 c0                	test   %eax,%eax
  803b3a:	74 0b                	je     803b47 <insert_sorted_with_merge_freeList+0x6e1>
  803b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b3f:	8b 00                	mov    (%eax),%eax
  803b41:	8b 55 08             	mov    0x8(%ebp),%edx
  803b44:	89 50 04             	mov    %edx,0x4(%eax)
  803b47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b4a:	8b 55 08             	mov    0x8(%ebp),%edx
  803b4d:	89 10                	mov    %edx,(%eax)
  803b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  803b52:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b55:	89 50 04             	mov    %edx,0x4(%eax)
  803b58:	8b 45 08             	mov    0x8(%ebp),%eax
  803b5b:	8b 00                	mov    (%eax),%eax
  803b5d:	85 c0                	test   %eax,%eax
  803b5f:	75 08                	jne    803b69 <insert_sorted_with_merge_freeList+0x703>
  803b61:	8b 45 08             	mov    0x8(%ebp),%eax
  803b64:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803b69:	a1 44 51 80 00       	mov    0x805144,%eax
  803b6e:	40                   	inc    %eax
  803b6f:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803b74:	eb 39                	jmp    803baf <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803b76:	a1 40 51 80 00       	mov    0x805140,%eax
  803b7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803b7e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b82:	74 07                	je     803b8b <insert_sorted_with_merge_freeList+0x725>
  803b84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b87:	8b 00                	mov    (%eax),%eax
  803b89:	eb 05                	jmp    803b90 <insert_sorted_with_merge_freeList+0x72a>
  803b8b:	b8 00 00 00 00       	mov    $0x0,%eax
  803b90:	a3 40 51 80 00       	mov    %eax,0x805140
  803b95:	a1 40 51 80 00       	mov    0x805140,%eax
  803b9a:	85 c0                	test   %eax,%eax
  803b9c:	0f 85 c7 fb ff ff    	jne    803769 <insert_sorted_with_merge_freeList+0x303>
  803ba2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ba6:	0f 85 bd fb ff ff    	jne    803769 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803bac:	eb 01                	jmp    803baf <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803bae:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803baf:	90                   	nop
  803bb0:	c9                   	leave  
  803bb1:	c3                   	ret    
  803bb2:	66 90                	xchg   %ax,%ax

00803bb4 <__udivdi3>:
  803bb4:	55                   	push   %ebp
  803bb5:	57                   	push   %edi
  803bb6:	56                   	push   %esi
  803bb7:	53                   	push   %ebx
  803bb8:	83 ec 1c             	sub    $0x1c,%esp
  803bbb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803bbf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803bc3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803bc7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803bcb:	89 ca                	mov    %ecx,%edx
  803bcd:	89 f8                	mov    %edi,%eax
  803bcf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803bd3:	85 f6                	test   %esi,%esi
  803bd5:	75 2d                	jne    803c04 <__udivdi3+0x50>
  803bd7:	39 cf                	cmp    %ecx,%edi
  803bd9:	77 65                	ja     803c40 <__udivdi3+0x8c>
  803bdb:	89 fd                	mov    %edi,%ebp
  803bdd:	85 ff                	test   %edi,%edi
  803bdf:	75 0b                	jne    803bec <__udivdi3+0x38>
  803be1:	b8 01 00 00 00       	mov    $0x1,%eax
  803be6:	31 d2                	xor    %edx,%edx
  803be8:	f7 f7                	div    %edi
  803bea:	89 c5                	mov    %eax,%ebp
  803bec:	31 d2                	xor    %edx,%edx
  803bee:	89 c8                	mov    %ecx,%eax
  803bf0:	f7 f5                	div    %ebp
  803bf2:	89 c1                	mov    %eax,%ecx
  803bf4:	89 d8                	mov    %ebx,%eax
  803bf6:	f7 f5                	div    %ebp
  803bf8:	89 cf                	mov    %ecx,%edi
  803bfa:	89 fa                	mov    %edi,%edx
  803bfc:	83 c4 1c             	add    $0x1c,%esp
  803bff:	5b                   	pop    %ebx
  803c00:	5e                   	pop    %esi
  803c01:	5f                   	pop    %edi
  803c02:	5d                   	pop    %ebp
  803c03:	c3                   	ret    
  803c04:	39 ce                	cmp    %ecx,%esi
  803c06:	77 28                	ja     803c30 <__udivdi3+0x7c>
  803c08:	0f bd fe             	bsr    %esi,%edi
  803c0b:	83 f7 1f             	xor    $0x1f,%edi
  803c0e:	75 40                	jne    803c50 <__udivdi3+0x9c>
  803c10:	39 ce                	cmp    %ecx,%esi
  803c12:	72 0a                	jb     803c1e <__udivdi3+0x6a>
  803c14:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803c18:	0f 87 9e 00 00 00    	ja     803cbc <__udivdi3+0x108>
  803c1e:	b8 01 00 00 00       	mov    $0x1,%eax
  803c23:	89 fa                	mov    %edi,%edx
  803c25:	83 c4 1c             	add    $0x1c,%esp
  803c28:	5b                   	pop    %ebx
  803c29:	5e                   	pop    %esi
  803c2a:	5f                   	pop    %edi
  803c2b:	5d                   	pop    %ebp
  803c2c:	c3                   	ret    
  803c2d:	8d 76 00             	lea    0x0(%esi),%esi
  803c30:	31 ff                	xor    %edi,%edi
  803c32:	31 c0                	xor    %eax,%eax
  803c34:	89 fa                	mov    %edi,%edx
  803c36:	83 c4 1c             	add    $0x1c,%esp
  803c39:	5b                   	pop    %ebx
  803c3a:	5e                   	pop    %esi
  803c3b:	5f                   	pop    %edi
  803c3c:	5d                   	pop    %ebp
  803c3d:	c3                   	ret    
  803c3e:	66 90                	xchg   %ax,%ax
  803c40:	89 d8                	mov    %ebx,%eax
  803c42:	f7 f7                	div    %edi
  803c44:	31 ff                	xor    %edi,%edi
  803c46:	89 fa                	mov    %edi,%edx
  803c48:	83 c4 1c             	add    $0x1c,%esp
  803c4b:	5b                   	pop    %ebx
  803c4c:	5e                   	pop    %esi
  803c4d:	5f                   	pop    %edi
  803c4e:	5d                   	pop    %ebp
  803c4f:	c3                   	ret    
  803c50:	bd 20 00 00 00       	mov    $0x20,%ebp
  803c55:	89 eb                	mov    %ebp,%ebx
  803c57:	29 fb                	sub    %edi,%ebx
  803c59:	89 f9                	mov    %edi,%ecx
  803c5b:	d3 e6                	shl    %cl,%esi
  803c5d:	89 c5                	mov    %eax,%ebp
  803c5f:	88 d9                	mov    %bl,%cl
  803c61:	d3 ed                	shr    %cl,%ebp
  803c63:	89 e9                	mov    %ebp,%ecx
  803c65:	09 f1                	or     %esi,%ecx
  803c67:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803c6b:	89 f9                	mov    %edi,%ecx
  803c6d:	d3 e0                	shl    %cl,%eax
  803c6f:	89 c5                	mov    %eax,%ebp
  803c71:	89 d6                	mov    %edx,%esi
  803c73:	88 d9                	mov    %bl,%cl
  803c75:	d3 ee                	shr    %cl,%esi
  803c77:	89 f9                	mov    %edi,%ecx
  803c79:	d3 e2                	shl    %cl,%edx
  803c7b:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c7f:	88 d9                	mov    %bl,%cl
  803c81:	d3 e8                	shr    %cl,%eax
  803c83:	09 c2                	or     %eax,%edx
  803c85:	89 d0                	mov    %edx,%eax
  803c87:	89 f2                	mov    %esi,%edx
  803c89:	f7 74 24 0c          	divl   0xc(%esp)
  803c8d:	89 d6                	mov    %edx,%esi
  803c8f:	89 c3                	mov    %eax,%ebx
  803c91:	f7 e5                	mul    %ebp
  803c93:	39 d6                	cmp    %edx,%esi
  803c95:	72 19                	jb     803cb0 <__udivdi3+0xfc>
  803c97:	74 0b                	je     803ca4 <__udivdi3+0xf0>
  803c99:	89 d8                	mov    %ebx,%eax
  803c9b:	31 ff                	xor    %edi,%edi
  803c9d:	e9 58 ff ff ff       	jmp    803bfa <__udivdi3+0x46>
  803ca2:	66 90                	xchg   %ax,%ax
  803ca4:	8b 54 24 08          	mov    0x8(%esp),%edx
  803ca8:	89 f9                	mov    %edi,%ecx
  803caa:	d3 e2                	shl    %cl,%edx
  803cac:	39 c2                	cmp    %eax,%edx
  803cae:	73 e9                	jae    803c99 <__udivdi3+0xe5>
  803cb0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803cb3:	31 ff                	xor    %edi,%edi
  803cb5:	e9 40 ff ff ff       	jmp    803bfa <__udivdi3+0x46>
  803cba:	66 90                	xchg   %ax,%ax
  803cbc:	31 c0                	xor    %eax,%eax
  803cbe:	e9 37 ff ff ff       	jmp    803bfa <__udivdi3+0x46>
  803cc3:	90                   	nop

00803cc4 <__umoddi3>:
  803cc4:	55                   	push   %ebp
  803cc5:	57                   	push   %edi
  803cc6:	56                   	push   %esi
  803cc7:	53                   	push   %ebx
  803cc8:	83 ec 1c             	sub    $0x1c,%esp
  803ccb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803ccf:	8b 74 24 34          	mov    0x34(%esp),%esi
  803cd3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803cd7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803cdb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803cdf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803ce3:	89 f3                	mov    %esi,%ebx
  803ce5:	89 fa                	mov    %edi,%edx
  803ce7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ceb:	89 34 24             	mov    %esi,(%esp)
  803cee:	85 c0                	test   %eax,%eax
  803cf0:	75 1a                	jne    803d0c <__umoddi3+0x48>
  803cf2:	39 f7                	cmp    %esi,%edi
  803cf4:	0f 86 a2 00 00 00    	jbe    803d9c <__umoddi3+0xd8>
  803cfa:	89 c8                	mov    %ecx,%eax
  803cfc:	89 f2                	mov    %esi,%edx
  803cfe:	f7 f7                	div    %edi
  803d00:	89 d0                	mov    %edx,%eax
  803d02:	31 d2                	xor    %edx,%edx
  803d04:	83 c4 1c             	add    $0x1c,%esp
  803d07:	5b                   	pop    %ebx
  803d08:	5e                   	pop    %esi
  803d09:	5f                   	pop    %edi
  803d0a:	5d                   	pop    %ebp
  803d0b:	c3                   	ret    
  803d0c:	39 f0                	cmp    %esi,%eax
  803d0e:	0f 87 ac 00 00 00    	ja     803dc0 <__umoddi3+0xfc>
  803d14:	0f bd e8             	bsr    %eax,%ebp
  803d17:	83 f5 1f             	xor    $0x1f,%ebp
  803d1a:	0f 84 ac 00 00 00    	je     803dcc <__umoddi3+0x108>
  803d20:	bf 20 00 00 00       	mov    $0x20,%edi
  803d25:	29 ef                	sub    %ebp,%edi
  803d27:	89 fe                	mov    %edi,%esi
  803d29:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803d2d:	89 e9                	mov    %ebp,%ecx
  803d2f:	d3 e0                	shl    %cl,%eax
  803d31:	89 d7                	mov    %edx,%edi
  803d33:	89 f1                	mov    %esi,%ecx
  803d35:	d3 ef                	shr    %cl,%edi
  803d37:	09 c7                	or     %eax,%edi
  803d39:	89 e9                	mov    %ebp,%ecx
  803d3b:	d3 e2                	shl    %cl,%edx
  803d3d:	89 14 24             	mov    %edx,(%esp)
  803d40:	89 d8                	mov    %ebx,%eax
  803d42:	d3 e0                	shl    %cl,%eax
  803d44:	89 c2                	mov    %eax,%edx
  803d46:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d4a:	d3 e0                	shl    %cl,%eax
  803d4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d50:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d54:	89 f1                	mov    %esi,%ecx
  803d56:	d3 e8                	shr    %cl,%eax
  803d58:	09 d0                	or     %edx,%eax
  803d5a:	d3 eb                	shr    %cl,%ebx
  803d5c:	89 da                	mov    %ebx,%edx
  803d5e:	f7 f7                	div    %edi
  803d60:	89 d3                	mov    %edx,%ebx
  803d62:	f7 24 24             	mull   (%esp)
  803d65:	89 c6                	mov    %eax,%esi
  803d67:	89 d1                	mov    %edx,%ecx
  803d69:	39 d3                	cmp    %edx,%ebx
  803d6b:	0f 82 87 00 00 00    	jb     803df8 <__umoddi3+0x134>
  803d71:	0f 84 91 00 00 00    	je     803e08 <__umoddi3+0x144>
  803d77:	8b 54 24 04          	mov    0x4(%esp),%edx
  803d7b:	29 f2                	sub    %esi,%edx
  803d7d:	19 cb                	sbb    %ecx,%ebx
  803d7f:	89 d8                	mov    %ebx,%eax
  803d81:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803d85:	d3 e0                	shl    %cl,%eax
  803d87:	89 e9                	mov    %ebp,%ecx
  803d89:	d3 ea                	shr    %cl,%edx
  803d8b:	09 d0                	or     %edx,%eax
  803d8d:	89 e9                	mov    %ebp,%ecx
  803d8f:	d3 eb                	shr    %cl,%ebx
  803d91:	89 da                	mov    %ebx,%edx
  803d93:	83 c4 1c             	add    $0x1c,%esp
  803d96:	5b                   	pop    %ebx
  803d97:	5e                   	pop    %esi
  803d98:	5f                   	pop    %edi
  803d99:	5d                   	pop    %ebp
  803d9a:	c3                   	ret    
  803d9b:	90                   	nop
  803d9c:	89 fd                	mov    %edi,%ebp
  803d9e:	85 ff                	test   %edi,%edi
  803da0:	75 0b                	jne    803dad <__umoddi3+0xe9>
  803da2:	b8 01 00 00 00       	mov    $0x1,%eax
  803da7:	31 d2                	xor    %edx,%edx
  803da9:	f7 f7                	div    %edi
  803dab:	89 c5                	mov    %eax,%ebp
  803dad:	89 f0                	mov    %esi,%eax
  803daf:	31 d2                	xor    %edx,%edx
  803db1:	f7 f5                	div    %ebp
  803db3:	89 c8                	mov    %ecx,%eax
  803db5:	f7 f5                	div    %ebp
  803db7:	89 d0                	mov    %edx,%eax
  803db9:	e9 44 ff ff ff       	jmp    803d02 <__umoddi3+0x3e>
  803dbe:	66 90                	xchg   %ax,%ax
  803dc0:	89 c8                	mov    %ecx,%eax
  803dc2:	89 f2                	mov    %esi,%edx
  803dc4:	83 c4 1c             	add    $0x1c,%esp
  803dc7:	5b                   	pop    %ebx
  803dc8:	5e                   	pop    %esi
  803dc9:	5f                   	pop    %edi
  803dca:	5d                   	pop    %ebp
  803dcb:	c3                   	ret    
  803dcc:	3b 04 24             	cmp    (%esp),%eax
  803dcf:	72 06                	jb     803dd7 <__umoddi3+0x113>
  803dd1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803dd5:	77 0f                	ja     803de6 <__umoddi3+0x122>
  803dd7:	89 f2                	mov    %esi,%edx
  803dd9:	29 f9                	sub    %edi,%ecx
  803ddb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803ddf:	89 14 24             	mov    %edx,(%esp)
  803de2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803de6:	8b 44 24 04          	mov    0x4(%esp),%eax
  803dea:	8b 14 24             	mov    (%esp),%edx
  803ded:	83 c4 1c             	add    $0x1c,%esp
  803df0:	5b                   	pop    %ebx
  803df1:	5e                   	pop    %esi
  803df2:	5f                   	pop    %edi
  803df3:	5d                   	pop    %ebp
  803df4:	c3                   	ret    
  803df5:	8d 76 00             	lea    0x0(%esi),%esi
  803df8:	2b 04 24             	sub    (%esp),%eax
  803dfb:	19 fa                	sbb    %edi,%edx
  803dfd:	89 d1                	mov    %edx,%ecx
  803dff:	89 c6                	mov    %eax,%esi
  803e01:	e9 71 ff ff ff       	jmp    803d77 <__umoddi3+0xb3>
  803e06:	66 90                	xchg   %ax,%ax
  803e08:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803e0c:	72 ea                	jb     803df8 <__umoddi3+0x134>
  803e0e:	89 d9                	mov    %ebx,%ecx
  803e10:	e9 62 ff ff ff       	jmp    803d77 <__umoddi3+0xb3>
