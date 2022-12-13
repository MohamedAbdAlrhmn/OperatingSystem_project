
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
  800041:	e8 bf 20 00 00       	call   802105 <sys_disable_interrupt>

		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 40 3e 80 00       	push   $0x803e40
  80004e:	e8 62 0b 00 00       	call   800bb5 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 42 3e 80 00       	push   $0x803e42
  80005e:	e8 52 0b 00 00       	call   800bb5 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 58 3e 80 00       	push   $0x803e58
  80006e:	e8 42 0b 00 00       	call   800bb5 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 42 3e 80 00       	push   $0x803e42
  80007e:	e8 32 0b 00 00       	call   800bb5 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 40 3e 80 00       	push   $0x803e40
  80008e:	e8 22 0b 00 00       	call   800bb5 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 70 3e 80 00       	push   $0x803e70
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
  8000de:	68 90 3e 80 00       	push   $0x803e90
  8000e3:	e8 cd 0a 00 00       	call   800bb5 <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 b2 3e 80 00       	push   $0x803eb2
  8000f3:	e8 bd 0a 00 00       	call   800bb5 <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 c0 3e 80 00       	push   $0x803ec0
  800103:	e8 ad 0a 00 00       	call   800bb5 <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 cf 3e 80 00       	push   $0x803ecf
  800113:	e8 9d 0a 00 00       	call   800bb5 <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 df 3e 80 00       	push   $0x803edf
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
  800162:	e8 b8 1f 00 00       	call   80211f <sys_enable_interrupt>

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
  8001d7:	e8 29 1f 00 00       	call   802105 <sys_disable_interrupt>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	68 e8 3e 80 00       	push   $0x803ee8
  8001e4:	e8 cc 09 00 00       	call   800bb5 <cprintf>
  8001e9:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001ec:	e8 2e 1f 00 00       	call   80211f <sys_enable_interrupt>

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
  80020e:	68 1c 3f 80 00       	push   $0x803f1c
  800213:	6a 4a                	push   $0x4a
  800215:	68 3e 3f 80 00       	push   $0x803f3e
  80021a:	e8 e2 06 00 00       	call   800901 <_panic>
		else
		{
			sys_disable_interrupt();
  80021f:	e8 e1 1e 00 00       	call   802105 <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	68 5c 3f 80 00       	push   $0x803f5c
  80022c:	e8 84 09 00 00       	call   800bb5 <cprintf>
  800231:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	68 90 3f 80 00       	push   $0x803f90
  80023c:	e8 74 09 00 00       	call   800bb5 <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 c4 3f 80 00       	push   $0x803fc4
  80024c:	e8 64 09 00 00       	call   800bb5 <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800254:	e8 c6 1e 00 00       	call   80211f <sys_enable_interrupt>
		}

		free(Elements) ;
  800259:	83 ec 0c             	sub    $0xc,%esp
  80025c:	ff 75 ec             	pushl  -0x14(%ebp)
  80025f:	e8 5a 1b 00 00       	call   801dbe <free>
  800264:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  800267:	e8 99 1e 00 00       	call   802105 <sys_disable_interrupt>
			Chose = 0 ;
  80026c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800270:	eb 42                	jmp    8002b4 <_main+0x27c>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800272:	83 ec 0c             	sub    $0xc,%esp
  800275:	68 f6 3f 80 00       	push   $0x803ff6
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
  8002c0:	e8 5a 1e 00 00       	call   80211f <sys_enable_interrupt>

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
  800454:	68 40 3e 80 00       	push   $0x803e40
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
  800476:	68 14 40 80 00       	push   $0x804014
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
  8004a4:	68 19 40 80 00       	push   $0x804019
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
  800739:	e8 fb 19 00 00       	call   802139 <sys_cputc>
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
  80074a:	e8 b6 19 00 00       	call   802105 <sys_disable_interrupt>
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
  80075d:	e8 d7 19 00 00       	call   802139 <sys_cputc>
  800762:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800765:	e8 b5 19 00 00       	call   80211f <sys_enable_interrupt>
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
  80077c:	e8 ff 17 00 00       	call   801f80 <sys_cgetc>
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
  800795:	e8 6b 19 00 00       	call   802105 <sys_disable_interrupt>
	int c=0;
  80079a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8007a1:	eb 08                	jmp    8007ab <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  8007a3:	e8 d8 17 00 00       	call   801f80 <sys_cgetc>
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
  8007b1:	e8 69 19 00 00       	call   80211f <sys_enable_interrupt>
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
  8007cb:	e8 28 1b 00 00       	call   8022f8 <sys_getenvindex>
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
  800836:	e8 ca 18 00 00       	call   802105 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80083b:	83 ec 0c             	sub    $0xc,%esp
  80083e:	68 38 40 80 00       	push   $0x804038
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
  800866:	68 60 40 80 00       	push   $0x804060
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
  800897:	68 88 40 80 00       	push   $0x804088
  80089c:	e8 14 03 00 00       	call   800bb5 <cprintf>
  8008a1:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8008a4:	a1 24 50 80 00       	mov    0x805024,%eax
  8008a9:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8008af:	83 ec 08             	sub    $0x8,%esp
  8008b2:	50                   	push   %eax
  8008b3:	68 e0 40 80 00       	push   $0x8040e0
  8008b8:	e8 f8 02 00 00       	call   800bb5 <cprintf>
  8008bd:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8008c0:	83 ec 0c             	sub    $0xc,%esp
  8008c3:	68 38 40 80 00       	push   $0x804038
  8008c8:	e8 e8 02 00 00       	call   800bb5 <cprintf>
  8008cd:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8008d0:	e8 4a 18 00 00       	call   80211f <sys_enable_interrupt>

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
  8008e8:	e8 d7 19 00 00       	call   8022c4 <sys_destroy_env>
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
  8008f9:	e8 2c 1a 00 00       	call   80232a <sys_exit_env>
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
  800922:	68 f4 40 80 00       	push   $0x8040f4
  800927:	e8 89 02 00 00       	call   800bb5 <cprintf>
  80092c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80092f:	a1 00 50 80 00       	mov    0x805000,%eax
  800934:	ff 75 0c             	pushl  0xc(%ebp)
  800937:	ff 75 08             	pushl  0x8(%ebp)
  80093a:	50                   	push   %eax
  80093b:	68 f9 40 80 00       	push   $0x8040f9
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
  80095f:	68 15 41 80 00       	push   $0x804115
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
  80098b:	68 18 41 80 00       	push   $0x804118
  800990:	6a 26                	push   $0x26
  800992:	68 64 41 80 00       	push   $0x804164
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
  800a5d:	68 70 41 80 00       	push   $0x804170
  800a62:	6a 3a                	push   $0x3a
  800a64:	68 64 41 80 00       	push   $0x804164
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
  800acd:	68 c4 41 80 00       	push   $0x8041c4
  800ad2:	6a 44                	push   $0x44
  800ad4:	68 64 41 80 00       	push   $0x804164
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
  800b27:	e8 2b 14 00 00       	call   801f57 <sys_cputs>
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
  800b9e:	e8 b4 13 00 00       	call   801f57 <sys_cputs>
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
  800be8:	e8 18 15 00 00       	call   802105 <sys_disable_interrupt>
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
  800c08:	e8 12 15 00 00       	call   80211f <sys_enable_interrupt>
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
  800c52:	e8 85 2f 00 00       	call   803bdc <__udivdi3>
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
  800ca2:	e8 45 30 00 00       	call   803cec <__umoddi3>
  800ca7:	83 c4 10             	add    $0x10,%esp
  800caa:	05 34 44 80 00       	add    $0x804434,%eax
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
  800dfd:	8b 04 85 58 44 80 00 	mov    0x804458(,%eax,4),%eax
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
  800ede:	8b 34 9d a0 42 80 00 	mov    0x8042a0(,%ebx,4),%esi
  800ee5:	85 f6                	test   %esi,%esi
  800ee7:	75 19                	jne    800f02 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ee9:	53                   	push   %ebx
  800eea:	68 45 44 80 00       	push   $0x804445
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
  800f03:	68 4e 44 80 00       	push   $0x80444e
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
  800f30:	be 51 44 80 00       	mov    $0x804451,%esi
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
  801249:	68 b0 45 80 00       	push   $0x8045b0
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
  80128b:	68 b3 45 80 00       	push   $0x8045b3
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
  80133b:	e8 c5 0d 00 00       	call   802105 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  801340:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801344:	74 13                	je     801359 <atomic_readline+0x24>
		cprintf("%s", prompt);
  801346:	83 ec 08             	sub    $0x8,%esp
  801349:	ff 75 08             	pushl  0x8(%ebp)
  80134c:	68 b0 45 80 00       	push   $0x8045b0
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
  80138a:	68 b3 45 80 00       	push   $0x8045b3
  80138f:	e8 21 f8 ff ff       	call   800bb5 <cprintf>
  801394:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801397:	e8 83 0d 00 00       	call   80211f <sys_enable_interrupt>
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
  80142f:	e8 eb 0c 00 00       	call   80211f <sys_enable_interrupt>
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
  801b5c:	68 c4 45 80 00       	push   $0x8045c4
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
  801c2c:	e8 6a 04 00 00       	call   80209b <sys_allocate_chunk>
  801c31:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801c34:	a1 20 51 80 00       	mov    0x805120,%eax
  801c39:	83 ec 0c             	sub    $0xc,%esp
  801c3c:	50                   	push   %eax
  801c3d:	e8 df 0a 00 00       	call   802721 <initialize_MemBlocksList>
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
  801c6a:	68 e9 45 80 00       	push   $0x8045e9
  801c6f:	6a 33                	push   $0x33
  801c71:	68 07 46 80 00       	push   $0x804607
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
  801ce9:	68 14 46 80 00       	push   $0x804614
  801cee:	6a 34                	push   $0x34
  801cf0:	68 07 46 80 00       	push   $0x804607
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
  801d81:	e8 e3 06 00 00       	call   802469 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d86:	85 c0                	test   %eax,%eax
  801d88:	74 11                	je     801d9b <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801d8a:	83 ec 0c             	sub    $0xc,%esp
  801d8d:	ff 75 e8             	pushl  -0x18(%ebp)
  801d90:	e8 4e 0d 00 00       	call   802ae3 <alloc_block_FF>
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
  801da7:	e8 aa 0a 00 00       	call   802856 <insert_sorted_allocList>
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
  801dc1:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801dc4:	83 ec 04             	sub    $0x4,%esp
  801dc7:	68 38 46 80 00       	push   $0x804638
  801dcc:	6a 6f                	push   $0x6f
  801dce:	68 07 46 80 00       	push   $0x804607
  801dd3:	e8 29 eb ff ff       	call   800901 <_panic>

00801dd8 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801dd8:	55                   	push   %ebp
  801dd9:	89 e5                	mov    %esp,%ebp
  801ddb:	83 ec 38             	sub    $0x38,%esp
  801dde:	8b 45 10             	mov    0x10(%ebp),%eax
  801de1:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801de4:	e8 5c fd ff ff       	call   801b45 <InitializeUHeap>
	if (size == 0) return NULL ;
  801de9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ded:	75 07                	jne    801df6 <smalloc+0x1e>
  801def:	b8 00 00 00 00       	mov    $0x0,%eax
  801df4:	eb 7c                	jmp    801e72 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801df6:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801dfd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e03:	01 d0                	add    %edx,%eax
  801e05:	48                   	dec    %eax
  801e06:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801e09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e0c:	ba 00 00 00 00       	mov    $0x0,%edx
  801e11:	f7 75 f0             	divl   -0x10(%ebp)
  801e14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e17:	29 d0                	sub    %edx,%eax
  801e19:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801e1c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801e23:	e8 41 06 00 00       	call   802469 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801e28:	85 c0                	test   %eax,%eax
  801e2a:	74 11                	je     801e3d <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  801e2c:	83 ec 0c             	sub    $0xc,%esp
  801e2f:	ff 75 e8             	pushl  -0x18(%ebp)
  801e32:	e8 ac 0c 00 00       	call   802ae3 <alloc_block_FF>
  801e37:	83 c4 10             	add    $0x10,%esp
  801e3a:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801e3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e41:	74 2a                	je     801e6d <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801e43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e46:	8b 40 08             	mov    0x8(%eax),%eax
  801e49:	89 c2                	mov    %eax,%edx
  801e4b:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801e4f:	52                   	push   %edx
  801e50:	50                   	push   %eax
  801e51:	ff 75 0c             	pushl  0xc(%ebp)
  801e54:	ff 75 08             	pushl  0x8(%ebp)
  801e57:	e8 92 03 00 00       	call   8021ee <sys_createSharedObject>
  801e5c:	83 c4 10             	add    $0x10,%esp
  801e5f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  801e62:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  801e66:	74 05                	je     801e6d <smalloc+0x95>
			return (void*)virtual_address;
  801e68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e6b:	eb 05                	jmp    801e72 <smalloc+0x9a>
	}
	return NULL;
  801e6d:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801e72:	c9                   	leave  
  801e73:	c3                   	ret    

00801e74 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801e74:	55                   	push   %ebp
  801e75:	89 e5                	mov    %esp,%ebp
  801e77:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e7a:	e8 c6 fc ff ff       	call   801b45 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801e7f:	83 ec 04             	sub    $0x4,%esp
  801e82:	68 5c 46 80 00       	push   $0x80465c
  801e87:	68 b0 00 00 00       	push   $0xb0
  801e8c:	68 07 46 80 00       	push   $0x804607
  801e91:	e8 6b ea ff ff       	call   800901 <_panic>

00801e96 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801e96:	55                   	push   %ebp
  801e97:	89 e5                	mov    %esp,%ebp
  801e99:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e9c:	e8 a4 fc ff ff       	call   801b45 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801ea1:	83 ec 04             	sub    $0x4,%esp
  801ea4:	68 80 46 80 00       	push   $0x804680
  801ea9:	68 f4 00 00 00       	push   $0xf4
  801eae:	68 07 46 80 00       	push   $0x804607
  801eb3:	e8 49 ea ff ff       	call   800901 <_panic>

00801eb8 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801eb8:	55                   	push   %ebp
  801eb9:	89 e5                	mov    %esp,%ebp
  801ebb:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801ebe:	83 ec 04             	sub    $0x4,%esp
  801ec1:	68 a8 46 80 00       	push   $0x8046a8
  801ec6:	68 08 01 00 00       	push   $0x108
  801ecb:	68 07 46 80 00       	push   $0x804607
  801ed0:	e8 2c ea ff ff       	call   800901 <_panic>

00801ed5 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801ed5:	55                   	push   %ebp
  801ed6:	89 e5                	mov    %esp,%ebp
  801ed8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801edb:	83 ec 04             	sub    $0x4,%esp
  801ede:	68 cc 46 80 00       	push   $0x8046cc
  801ee3:	68 13 01 00 00       	push   $0x113
  801ee8:	68 07 46 80 00       	push   $0x804607
  801eed:	e8 0f ea ff ff       	call   800901 <_panic>

00801ef2 <shrink>:

}
void shrink(uint32 newSize)
{
  801ef2:	55                   	push   %ebp
  801ef3:	89 e5                	mov    %esp,%ebp
  801ef5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ef8:	83 ec 04             	sub    $0x4,%esp
  801efb:	68 cc 46 80 00       	push   $0x8046cc
  801f00:	68 18 01 00 00       	push   $0x118
  801f05:	68 07 46 80 00       	push   $0x804607
  801f0a:	e8 f2 e9 ff ff       	call   800901 <_panic>

00801f0f <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801f0f:	55                   	push   %ebp
  801f10:	89 e5                	mov    %esp,%ebp
  801f12:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f15:	83 ec 04             	sub    $0x4,%esp
  801f18:	68 cc 46 80 00       	push   $0x8046cc
  801f1d:	68 1d 01 00 00       	push   $0x11d
  801f22:	68 07 46 80 00       	push   $0x804607
  801f27:	e8 d5 e9 ff ff       	call   800901 <_panic>

00801f2c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801f2c:	55                   	push   %ebp
  801f2d:	89 e5                	mov    %esp,%ebp
  801f2f:	57                   	push   %edi
  801f30:	56                   	push   %esi
  801f31:	53                   	push   %ebx
  801f32:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801f35:	8b 45 08             	mov    0x8(%ebp),%eax
  801f38:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f3b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f3e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f41:	8b 7d 18             	mov    0x18(%ebp),%edi
  801f44:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801f47:	cd 30                	int    $0x30
  801f49:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801f4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f4f:	83 c4 10             	add    $0x10,%esp
  801f52:	5b                   	pop    %ebx
  801f53:	5e                   	pop    %esi
  801f54:	5f                   	pop    %edi
  801f55:	5d                   	pop    %ebp
  801f56:	c3                   	ret    

00801f57 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801f57:	55                   	push   %ebp
  801f58:	89 e5                	mov    %esp,%ebp
  801f5a:	83 ec 04             	sub    $0x4,%esp
  801f5d:	8b 45 10             	mov    0x10(%ebp),%eax
  801f60:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801f63:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f67:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 00                	push   $0x0
  801f6e:	52                   	push   %edx
  801f6f:	ff 75 0c             	pushl  0xc(%ebp)
  801f72:	50                   	push   %eax
  801f73:	6a 00                	push   $0x0
  801f75:	e8 b2 ff ff ff       	call   801f2c <syscall>
  801f7a:	83 c4 18             	add    $0x18,%esp
}
  801f7d:	90                   	nop
  801f7e:	c9                   	leave  
  801f7f:	c3                   	ret    

00801f80 <sys_cgetc>:

int
sys_cgetc(void)
{
  801f80:	55                   	push   %ebp
  801f81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801f83:	6a 00                	push   $0x0
  801f85:	6a 00                	push   $0x0
  801f87:	6a 00                	push   $0x0
  801f89:	6a 00                	push   $0x0
  801f8b:	6a 00                	push   $0x0
  801f8d:	6a 01                	push   $0x1
  801f8f:	e8 98 ff ff ff       	call   801f2c <syscall>
  801f94:	83 c4 18             	add    $0x18,%esp
}
  801f97:	c9                   	leave  
  801f98:	c3                   	ret    

00801f99 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801f99:	55                   	push   %ebp
  801f9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801f9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa2:	6a 00                	push   $0x0
  801fa4:	6a 00                	push   $0x0
  801fa6:	6a 00                	push   $0x0
  801fa8:	52                   	push   %edx
  801fa9:	50                   	push   %eax
  801faa:	6a 05                	push   $0x5
  801fac:	e8 7b ff ff ff       	call   801f2c <syscall>
  801fb1:	83 c4 18             	add    $0x18,%esp
}
  801fb4:	c9                   	leave  
  801fb5:	c3                   	ret    

00801fb6 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801fb6:	55                   	push   %ebp
  801fb7:	89 e5                	mov    %esp,%ebp
  801fb9:	56                   	push   %esi
  801fba:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801fbb:	8b 75 18             	mov    0x18(%ebp),%esi
  801fbe:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fc1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fc4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fca:	56                   	push   %esi
  801fcb:	53                   	push   %ebx
  801fcc:	51                   	push   %ecx
  801fcd:	52                   	push   %edx
  801fce:	50                   	push   %eax
  801fcf:	6a 06                	push   $0x6
  801fd1:	e8 56 ff ff ff       	call   801f2c <syscall>
  801fd6:	83 c4 18             	add    $0x18,%esp
}
  801fd9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fdc:	5b                   	pop    %ebx
  801fdd:	5e                   	pop    %esi
  801fde:	5d                   	pop    %ebp
  801fdf:	c3                   	ret    

00801fe0 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801fe0:	55                   	push   %ebp
  801fe1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801fe3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe9:	6a 00                	push   $0x0
  801feb:	6a 00                	push   $0x0
  801fed:	6a 00                	push   $0x0
  801fef:	52                   	push   %edx
  801ff0:	50                   	push   %eax
  801ff1:	6a 07                	push   $0x7
  801ff3:	e8 34 ff ff ff       	call   801f2c <syscall>
  801ff8:	83 c4 18             	add    $0x18,%esp
}
  801ffb:	c9                   	leave  
  801ffc:	c3                   	ret    

00801ffd <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801ffd:	55                   	push   %ebp
  801ffe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802000:	6a 00                	push   $0x0
  802002:	6a 00                	push   $0x0
  802004:	6a 00                	push   $0x0
  802006:	ff 75 0c             	pushl  0xc(%ebp)
  802009:	ff 75 08             	pushl  0x8(%ebp)
  80200c:	6a 08                	push   $0x8
  80200e:	e8 19 ff ff ff       	call   801f2c <syscall>
  802013:	83 c4 18             	add    $0x18,%esp
}
  802016:	c9                   	leave  
  802017:	c3                   	ret    

00802018 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802018:	55                   	push   %ebp
  802019:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80201b:	6a 00                	push   $0x0
  80201d:	6a 00                	push   $0x0
  80201f:	6a 00                	push   $0x0
  802021:	6a 00                	push   $0x0
  802023:	6a 00                	push   $0x0
  802025:	6a 09                	push   $0x9
  802027:	e8 00 ff ff ff       	call   801f2c <syscall>
  80202c:	83 c4 18             	add    $0x18,%esp
}
  80202f:	c9                   	leave  
  802030:	c3                   	ret    

00802031 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802031:	55                   	push   %ebp
  802032:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802034:	6a 00                	push   $0x0
  802036:	6a 00                	push   $0x0
  802038:	6a 00                	push   $0x0
  80203a:	6a 00                	push   $0x0
  80203c:	6a 00                	push   $0x0
  80203e:	6a 0a                	push   $0xa
  802040:	e8 e7 fe ff ff       	call   801f2c <syscall>
  802045:	83 c4 18             	add    $0x18,%esp
}
  802048:	c9                   	leave  
  802049:	c3                   	ret    

0080204a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80204a:	55                   	push   %ebp
  80204b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80204d:	6a 00                	push   $0x0
  80204f:	6a 00                	push   $0x0
  802051:	6a 00                	push   $0x0
  802053:	6a 00                	push   $0x0
  802055:	6a 00                	push   $0x0
  802057:	6a 0b                	push   $0xb
  802059:	e8 ce fe ff ff       	call   801f2c <syscall>
  80205e:	83 c4 18             	add    $0x18,%esp
}
  802061:	c9                   	leave  
  802062:	c3                   	ret    

00802063 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802063:	55                   	push   %ebp
  802064:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802066:	6a 00                	push   $0x0
  802068:	6a 00                	push   $0x0
  80206a:	6a 00                	push   $0x0
  80206c:	ff 75 0c             	pushl  0xc(%ebp)
  80206f:	ff 75 08             	pushl  0x8(%ebp)
  802072:	6a 0f                	push   $0xf
  802074:	e8 b3 fe ff ff       	call   801f2c <syscall>
  802079:	83 c4 18             	add    $0x18,%esp
	return;
  80207c:	90                   	nop
}
  80207d:	c9                   	leave  
  80207e:	c3                   	ret    

0080207f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80207f:	55                   	push   %ebp
  802080:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802082:	6a 00                	push   $0x0
  802084:	6a 00                	push   $0x0
  802086:	6a 00                	push   $0x0
  802088:	ff 75 0c             	pushl  0xc(%ebp)
  80208b:	ff 75 08             	pushl  0x8(%ebp)
  80208e:	6a 10                	push   $0x10
  802090:	e8 97 fe ff ff       	call   801f2c <syscall>
  802095:	83 c4 18             	add    $0x18,%esp
	return ;
  802098:	90                   	nop
}
  802099:	c9                   	leave  
  80209a:	c3                   	ret    

0080209b <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80209b:	55                   	push   %ebp
  80209c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80209e:	6a 00                	push   $0x0
  8020a0:	6a 00                	push   $0x0
  8020a2:	ff 75 10             	pushl  0x10(%ebp)
  8020a5:	ff 75 0c             	pushl  0xc(%ebp)
  8020a8:	ff 75 08             	pushl  0x8(%ebp)
  8020ab:	6a 11                	push   $0x11
  8020ad:	e8 7a fe ff ff       	call   801f2c <syscall>
  8020b2:	83 c4 18             	add    $0x18,%esp
	return ;
  8020b5:	90                   	nop
}
  8020b6:	c9                   	leave  
  8020b7:	c3                   	ret    

008020b8 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8020b8:	55                   	push   %ebp
  8020b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8020bb:	6a 00                	push   $0x0
  8020bd:	6a 00                	push   $0x0
  8020bf:	6a 00                	push   $0x0
  8020c1:	6a 00                	push   $0x0
  8020c3:	6a 00                	push   $0x0
  8020c5:	6a 0c                	push   $0xc
  8020c7:	e8 60 fe ff ff       	call   801f2c <syscall>
  8020cc:	83 c4 18             	add    $0x18,%esp
}
  8020cf:	c9                   	leave  
  8020d0:	c3                   	ret    

008020d1 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8020d1:	55                   	push   %ebp
  8020d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8020d4:	6a 00                	push   $0x0
  8020d6:	6a 00                	push   $0x0
  8020d8:	6a 00                	push   $0x0
  8020da:	6a 00                	push   $0x0
  8020dc:	ff 75 08             	pushl  0x8(%ebp)
  8020df:	6a 0d                	push   $0xd
  8020e1:	e8 46 fe ff ff       	call   801f2c <syscall>
  8020e6:	83 c4 18             	add    $0x18,%esp
}
  8020e9:	c9                   	leave  
  8020ea:	c3                   	ret    

008020eb <sys_scarce_memory>:

void sys_scarce_memory()
{
  8020eb:	55                   	push   %ebp
  8020ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8020ee:	6a 00                	push   $0x0
  8020f0:	6a 00                	push   $0x0
  8020f2:	6a 00                	push   $0x0
  8020f4:	6a 00                	push   $0x0
  8020f6:	6a 00                	push   $0x0
  8020f8:	6a 0e                	push   $0xe
  8020fa:	e8 2d fe ff ff       	call   801f2c <syscall>
  8020ff:	83 c4 18             	add    $0x18,%esp
}
  802102:	90                   	nop
  802103:	c9                   	leave  
  802104:	c3                   	ret    

00802105 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802105:	55                   	push   %ebp
  802106:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802108:	6a 00                	push   $0x0
  80210a:	6a 00                	push   $0x0
  80210c:	6a 00                	push   $0x0
  80210e:	6a 00                	push   $0x0
  802110:	6a 00                	push   $0x0
  802112:	6a 13                	push   $0x13
  802114:	e8 13 fe ff ff       	call   801f2c <syscall>
  802119:	83 c4 18             	add    $0x18,%esp
}
  80211c:	90                   	nop
  80211d:	c9                   	leave  
  80211e:	c3                   	ret    

0080211f <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80211f:	55                   	push   %ebp
  802120:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802122:	6a 00                	push   $0x0
  802124:	6a 00                	push   $0x0
  802126:	6a 00                	push   $0x0
  802128:	6a 00                	push   $0x0
  80212a:	6a 00                	push   $0x0
  80212c:	6a 14                	push   $0x14
  80212e:	e8 f9 fd ff ff       	call   801f2c <syscall>
  802133:	83 c4 18             	add    $0x18,%esp
}
  802136:	90                   	nop
  802137:	c9                   	leave  
  802138:	c3                   	ret    

00802139 <sys_cputc>:


void
sys_cputc(const char c)
{
  802139:	55                   	push   %ebp
  80213a:	89 e5                	mov    %esp,%ebp
  80213c:	83 ec 04             	sub    $0x4,%esp
  80213f:	8b 45 08             	mov    0x8(%ebp),%eax
  802142:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802145:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802149:	6a 00                	push   $0x0
  80214b:	6a 00                	push   $0x0
  80214d:	6a 00                	push   $0x0
  80214f:	6a 00                	push   $0x0
  802151:	50                   	push   %eax
  802152:	6a 15                	push   $0x15
  802154:	e8 d3 fd ff ff       	call   801f2c <syscall>
  802159:	83 c4 18             	add    $0x18,%esp
}
  80215c:	90                   	nop
  80215d:	c9                   	leave  
  80215e:	c3                   	ret    

0080215f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80215f:	55                   	push   %ebp
  802160:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802162:	6a 00                	push   $0x0
  802164:	6a 00                	push   $0x0
  802166:	6a 00                	push   $0x0
  802168:	6a 00                	push   $0x0
  80216a:	6a 00                	push   $0x0
  80216c:	6a 16                	push   $0x16
  80216e:	e8 b9 fd ff ff       	call   801f2c <syscall>
  802173:	83 c4 18             	add    $0x18,%esp
}
  802176:	90                   	nop
  802177:	c9                   	leave  
  802178:	c3                   	ret    

00802179 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802179:	55                   	push   %ebp
  80217a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80217c:	8b 45 08             	mov    0x8(%ebp),%eax
  80217f:	6a 00                	push   $0x0
  802181:	6a 00                	push   $0x0
  802183:	6a 00                	push   $0x0
  802185:	ff 75 0c             	pushl  0xc(%ebp)
  802188:	50                   	push   %eax
  802189:	6a 17                	push   $0x17
  80218b:	e8 9c fd ff ff       	call   801f2c <syscall>
  802190:	83 c4 18             	add    $0x18,%esp
}
  802193:	c9                   	leave  
  802194:	c3                   	ret    

00802195 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802195:	55                   	push   %ebp
  802196:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802198:	8b 55 0c             	mov    0xc(%ebp),%edx
  80219b:	8b 45 08             	mov    0x8(%ebp),%eax
  80219e:	6a 00                	push   $0x0
  8021a0:	6a 00                	push   $0x0
  8021a2:	6a 00                	push   $0x0
  8021a4:	52                   	push   %edx
  8021a5:	50                   	push   %eax
  8021a6:	6a 1a                	push   $0x1a
  8021a8:	e8 7f fd ff ff       	call   801f2c <syscall>
  8021ad:	83 c4 18             	add    $0x18,%esp
}
  8021b0:	c9                   	leave  
  8021b1:	c3                   	ret    

008021b2 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8021b2:	55                   	push   %ebp
  8021b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8021b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bb:	6a 00                	push   $0x0
  8021bd:	6a 00                	push   $0x0
  8021bf:	6a 00                	push   $0x0
  8021c1:	52                   	push   %edx
  8021c2:	50                   	push   %eax
  8021c3:	6a 18                	push   $0x18
  8021c5:	e8 62 fd ff ff       	call   801f2c <syscall>
  8021ca:	83 c4 18             	add    $0x18,%esp
}
  8021cd:	90                   	nop
  8021ce:	c9                   	leave  
  8021cf:	c3                   	ret    

008021d0 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8021d0:	55                   	push   %ebp
  8021d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8021d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d9:	6a 00                	push   $0x0
  8021db:	6a 00                	push   $0x0
  8021dd:	6a 00                	push   $0x0
  8021df:	52                   	push   %edx
  8021e0:	50                   	push   %eax
  8021e1:	6a 19                	push   $0x19
  8021e3:	e8 44 fd ff ff       	call   801f2c <syscall>
  8021e8:	83 c4 18             	add    $0x18,%esp
}
  8021eb:	90                   	nop
  8021ec:	c9                   	leave  
  8021ed:	c3                   	ret    

008021ee <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8021ee:	55                   	push   %ebp
  8021ef:	89 e5                	mov    %esp,%ebp
  8021f1:	83 ec 04             	sub    $0x4,%esp
  8021f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8021f7:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8021fa:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8021fd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802201:	8b 45 08             	mov    0x8(%ebp),%eax
  802204:	6a 00                	push   $0x0
  802206:	51                   	push   %ecx
  802207:	52                   	push   %edx
  802208:	ff 75 0c             	pushl  0xc(%ebp)
  80220b:	50                   	push   %eax
  80220c:	6a 1b                	push   $0x1b
  80220e:	e8 19 fd ff ff       	call   801f2c <syscall>
  802213:	83 c4 18             	add    $0x18,%esp
}
  802216:	c9                   	leave  
  802217:	c3                   	ret    

00802218 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802218:	55                   	push   %ebp
  802219:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80221b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80221e:	8b 45 08             	mov    0x8(%ebp),%eax
  802221:	6a 00                	push   $0x0
  802223:	6a 00                	push   $0x0
  802225:	6a 00                	push   $0x0
  802227:	52                   	push   %edx
  802228:	50                   	push   %eax
  802229:	6a 1c                	push   $0x1c
  80222b:	e8 fc fc ff ff       	call   801f2c <syscall>
  802230:	83 c4 18             	add    $0x18,%esp
}
  802233:	c9                   	leave  
  802234:	c3                   	ret    

00802235 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802235:	55                   	push   %ebp
  802236:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802238:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80223b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80223e:	8b 45 08             	mov    0x8(%ebp),%eax
  802241:	6a 00                	push   $0x0
  802243:	6a 00                	push   $0x0
  802245:	51                   	push   %ecx
  802246:	52                   	push   %edx
  802247:	50                   	push   %eax
  802248:	6a 1d                	push   $0x1d
  80224a:	e8 dd fc ff ff       	call   801f2c <syscall>
  80224f:	83 c4 18             	add    $0x18,%esp
}
  802252:	c9                   	leave  
  802253:	c3                   	ret    

00802254 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802254:	55                   	push   %ebp
  802255:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802257:	8b 55 0c             	mov    0xc(%ebp),%edx
  80225a:	8b 45 08             	mov    0x8(%ebp),%eax
  80225d:	6a 00                	push   $0x0
  80225f:	6a 00                	push   $0x0
  802261:	6a 00                	push   $0x0
  802263:	52                   	push   %edx
  802264:	50                   	push   %eax
  802265:	6a 1e                	push   $0x1e
  802267:	e8 c0 fc ff ff       	call   801f2c <syscall>
  80226c:	83 c4 18             	add    $0x18,%esp
}
  80226f:	c9                   	leave  
  802270:	c3                   	ret    

00802271 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802271:	55                   	push   %ebp
  802272:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802274:	6a 00                	push   $0x0
  802276:	6a 00                	push   $0x0
  802278:	6a 00                	push   $0x0
  80227a:	6a 00                	push   $0x0
  80227c:	6a 00                	push   $0x0
  80227e:	6a 1f                	push   $0x1f
  802280:	e8 a7 fc ff ff       	call   801f2c <syscall>
  802285:	83 c4 18             	add    $0x18,%esp
}
  802288:	c9                   	leave  
  802289:	c3                   	ret    

0080228a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80228a:	55                   	push   %ebp
  80228b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80228d:	8b 45 08             	mov    0x8(%ebp),%eax
  802290:	6a 00                	push   $0x0
  802292:	ff 75 14             	pushl  0x14(%ebp)
  802295:	ff 75 10             	pushl  0x10(%ebp)
  802298:	ff 75 0c             	pushl  0xc(%ebp)
  80229b:	50                   	push   %eax
  80229c:	6a 20                	push   $0x20
  80229e:	e8 89 fc ff ff       	call   801f2c <syscall>
  8022a3:	83 c4 18             	add    $0x18,%esp
}
  8022a6:	c9                   	leave  
  8022a7:	c3                   	ret    

008022a8 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8022a8:	55                   	push   %ebp
  8022a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8022ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ae:	6a 00                	push   $0x0
  8022b0:	6a 00                	push   $0x0
  8022b2:	6a 00                	push   $0x0
  8022b4:	6a 00                	push   $0x0
  8022b6:	50                   	push   %eax
  8022b7:	6a 21                	push   $0x21
  8022b9:	e8 6e fc ff ff       	call   801f2c <syscall>
  8022be:	83 c4 18             	add    $0x18,%esp
}
  8022c1:	90                   	nop
  8022c2:	c9                   	leave  
  8022c3:	c3                   	ret    

008022c4 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8022c4:	55                   	push   %ebp
  8022c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8022c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ca:	6a 00                	push   $0x0
  8022cc:	6a 00                	push   $0x0
  8022ce:	6a 00                	push   $0x0
  8022d0:	6a 00                	push   $0x0
  8022d2:	50                   	push   %eax
  8022d3:	6a 22                	push   $0x22
  8022d5:	e8 52 fc ff ff       	call   801f2c <syscall>
  8022da:	83 c4 18             	add    $0x18,%esp
}
  8022dd:	c9                   	leave  
  8022de:	c3                   	ret    

008022df <sys_getenvid>:

int32 sys_getenvid(void)
{
  8022df:	55                   	push   %ebp
  8022e0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8022e2:	6a 00                	push   $0x0
  8022e4:	6a 00                	push   $0x0
  8022e6:	6a 00                	push   $0x0
  8022e8:	6a 00                	push   $0x0
  8022ea:	6a 00                	push   $0x0
  8022ec:	6a 02                	push   $0x2
  8022ee:	e8 39 fc ff ff       	call   801f2c <syscall>
  8022f3:	83 c4 18             	add    $0x18,%esp
}
  8022f6:	c9                   	leave  
  8022f7:	c3                   	ret    

008022f8 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8022f8:	55                   	push   %ebp
  8022f9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8022fb:	6a 00                	push   $0x0
  8022fd:	6a 00                	push   $0x0
  8022ff:	6a 00                	push   $0x0
  802301:	6a 00                	push   $0x0
  802303:	6a 00                	push   $0x0
  802305:	6a 03                	push   $0x3
  802307:	e8 20 fc ff ff       	call   801f2c <syscall>
  80230c:	83 c4 18             	add    $0x18,%esp
}
  80230f:	c9                   	leave  
  802310:	c3                   	ret    

00802311 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802311:	55                   	push   %ebp
  802312:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802314:	6a 00                	push   $0x0
  802316:	6a 00                	push   $0x0
  802318:	6a 00                	push   $0x0
  80231a:	6a 00                	push   $0x0
  80231c:	6a 00                	push   $0x0
  80231e:	6a 04                	push   $0x4
  802320:	e8 07 fc ff ff       	call   801f2c <syscall>
  802325:	83 c4 18             	add    $0x18,%esp
}
  802328:	c9                   	leave  
  802329:	c3                   	ret    

0080232a <sys_exit_env>:


void sys_exit_env(void)
{
  80232a:	55                   	push   %ebp
  80232b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80232d:	6a 00                	push   $0x0
  80232f:	6a 00                	push   $0x0
  802331:	6a 00                	push   $0x0
  802333:	6a 00                	push   $0x0
  802335:	6a 00                	push   $0x0
  802337:	6a 23                	push   $0x23
  802339:	e8 ee fb ff ff       	call   801f2c <syscall>
  80233e:	83 c4 18             	add    $0x18,%esp
}
  802341:	90                   	nop
  802342:	c9                   	leave  
  802343:	c3                   	ret    

00802344 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802344:	55                   	push   %ebp
  802345:	89 e5                	mov    %esp,%ebp
  802347:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80234a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80234d:	8d 50 04             	lea    0x4(%eax),%edx
  802350:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802353:	6a 00                	push   $0x0
  802355:	6a 00                	push   $0x0
  802357:	6a 00                	push   $0x0
  802359:	52                   	push   %edx
  80235a:	50                   	push   %eax
  80235b:	6a 24                	push   $0x24
  80235d:	e8 ca fb ff ff       	call   801f2c <syscall>
  802362:	83 c4 18             	add    $0x18,%esp
	return result;
  802365:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802368:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80236b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80236e:	89 01                	mov    %eax,(%ecx)
  802370:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802373:	8b 45 08             	mov    0x8(%ebp),%eax
  802376:	c9                   	leave  
  802377:	c2 04 00             	ret    $0x4

0080237a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80237a:	55                   	push   %ebp
  80237b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80237d:	6a 00                	push   $0x0
  80237f:	6a 00                	push   $0x0
  802381:	ff 75 10             	pushl  0x10(%ebp)
  802384:	ff 75 0c             	pushl  0xc(%ebp)
  802387:	ff 75 08             	pushl  0x8(%ebp)
  80238a:	6a 12                	push   $0x12
  80238c:	e8 9b fb ff ff       	call   801f2c <syscall>
  802391:	83 c4 18             	add    $0x18,%esp
	return ;
  802394:	90                   	nop
}
  802395:	c9                   	leave  
  802396:	c3                   	ret    

00802397 <sys_rcr2>:
uint32 sys_rcr2()
{
  802397:	55                   	push   %ebp
  802398:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80239a:	6a 00                	push   $0x0
  80239c:	6a 00                	push   $0x0
  80239e:	6a 00                	push   $0x0
  8023a0:	6a 00                	push   $0x0
  8023a2:	6a 00                	push   $0x0
  8023a4:	6a 25                	push   $0x25
  8023a6:	e8 81 fb ff ff       	call   801f2c <syscall>
  8023ab:	83 c4 18             	add    $0x18,%esp
}
  8023ae:	c9                   	leave  
  8023af:	c3                   	ret    

008023b0 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8023b0:	55                   	push   %ebp
  8023b1:	89 e5                	mov    %esp,%ebp
  8023b3:	83 ec 04             	sub    $0x4,%esp
  8023b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8023bc:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8023c0:	6a 00                	push   $0x0
  8023c2:	6a 00                	push   $0x0
  8023c4:	6a 00                	push   $0x0
  8023c6:	6a 00                	push   $0x0
  8023c8:	50                   	push   %eax
  8023c9:	6a 26                	push   $0x26
  8023cb:	e8 5c fb ff ff       	call   801f2c <syscall>
  8023d0:	83 c4 18             	add    $0x18,%esp
	return ;
  8023d3:	90                   	nop
}
  8023d4:	c9                   	leave  
  8023d5:	c3                   	ret    

008023d6 <rsttst>:
void rsttst()
{
  8023d6:	55                   	push   %ebp
  8023d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8023d9:	6a 00                	push   $0x0
  8023db:	6a 00                	push   $0x0
  8023dd:	6a 00                	push   $0x0
  8023df:	6a 00                	push   $0x0
  8023e1:	6a 00                	push   $0x0
  8023e3:	6a 28                	push   $0x28
  8023e5:	e8 42 fb ff ff       	call   801f2c <syscall>
  8023ea:	83 c4 18             	add    $0x18,%esp
	return ;
  8023ed:	90                   	nop
}
  8023ee:	c9                   	leave  
  8023ef:	c3                   	ret    

008023f0 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8023f0:	55                   	push   %ebp
  8023f1:	89 e5                	mov    %esp,%ebp
  8023f3:	83 ec 04             	sub    $0x4,%esp
  8023f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8023f9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8023fc:	8b 55 18             	mov    0x18(%ebp),%edx
  8023ff:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802403:	52                   	push   %edx
  802404:	50                   	push   %eax
  802405:	ff 75 10             	pushl  0x10(%ebp)
  802408:	ff 75 0c             	pushl  0xc(%ebp)
  80240b:	ff 75 08             	pushl  0x8(%ebp)
  80240e:	6a 27                	push   $0x27
  802410:	e8 17 fb ff ff       	call   801f2c <syscall>
  802415:	83 c4 18             	add    $0x18,%esp
	return ;
  802418:	90                   	nop
}
  802419:	c9                   	leave  
  80241a:	c3                   	ret    

0080241b <chktst>:
void chktst(uint32 n)
{
  80241b:	55                   	push   %ebp
  80241c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80241e:	6a 00                	push   $0x0
  802420:	6a 00                	push   $0x0
  802422:	6a 00                	push   $0x0
  802424:	6a 00                	push   $0x0
  802426:	ff 75 08             	pushl  0x8(%ebp)
  802429:	6a 29                	push   $0x29
  80242b:	e8 fc fa ff ff       	call   801f2c <syscall>
  802430:	83 c4 18             	add    $0x18,%esp
	return ;
  802433:	90                   	nop
}
  802434:	c9                   	leave  
  802435:	c3                   	ret    

00802436 <inctst>:

void inctst()
{
  802436:	55                   	push   %ebp
  802437:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802439:	6a 00                	push   $0x0
  80243b:	6a 00                	push   $0x0
  80243d:	6a 00                	push   $0x0
  80243f:	6a 00                	push   $0x0
  802441:	6a 00                	push   $0x0
  802443:	6a 2a                	push   $0x2a
  802445:	e8 e2 fa ff ff       	call   801f2c <syscall>
  80244a:	83 c4 18             	add    $0x18,%esp
	return ;
  80244d:	90                   	nop
}
  80244e:	c9                   	leave  
  80244f:	c3                   	ret    

00802450 <gettst>:
uint32 gettst()
{
  802450:	55                   	push   %ebp
  802451:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802453:	6a 00                	push   $0x0
  802455:	6a 00                	push   $0x0
  802457:	6a 00                	push   $0x0
  802459:	6a 00                	push   $0x0
  80245b:	6a 00                	push   $0x0
  80245d:	6a 2b                	push   $0x2b
  80245f:	e8 c8 fa ff ff       	call   801f2c <syscall>
  802464:	83 c4 18             	add    $0x18,%esp
}
  802467:	c9                   	leave  
  802468:	c3                   	ret    

00802469 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
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
  80247b:	e8 ac fa ff ff       	call   801f2c <syscall>
  802480:	83 c4 18             	add    $0x18,%esp
  802483:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802486:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80248a:	75 07                	jne    802493 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80248c:	b8 01 00 00 00       	mov    $0x1,%eax
  802491:	eb 05                	jmp    802498 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802493:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802498:	c9                   	leave  
  802499:	c3                   	ret    

0080249a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80249a:	55                   	push   %ebp
  80249b:	89 e5                	mov    %esp,%ebp
  80249d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024a0:	6a 00                	push   $0x0
  8024a2:	6a 00                	push   $0x0
  8024a4:	6a 00                	push   $0x0
  8024a6:	6a 00                	push   $0x0
  8024a8:	6a 00                	push   $0x0
  8024aa:	6a 2c                	push   $0x2c
  8024ac:	e8 7b fa ff ff       	call   801f2c <syscall>
  8024b1:	83 c4 18             	add    $0x18,%esp
  8024b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8024b7:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8024bb:	75 07                	jne    8024c4 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8024bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8024c2:	eb 05                	jmp    8024c9 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8024c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024c9:	c9                   	leave  
  8024ca:	c3                   	ret    

008024cb <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8024cb:	55                   	push   %ebp
  8024cc:	89 e5                	mov    %esp,%ebp
  8024ce:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024d1:	6a 00                	push   $0x0
  8024d3:	6a 00                	push   $0x0
  8024d5:	6a 00                	push   $0x0
  8024d7:	6a 00                	push   $0x0
  8024d9:	6a 00                	push   $0x0
  8024db:	6a 2c                	push   $0x2c
  8024dd:	e8 4a fa ff ff       	call   801f2c <syscall>
  8024e2:	83 c4 18             	add    $0x18,%esp
  8024e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8024e8:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8024ec:	75 07                	jne    8024f5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8024ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8024f3:	eb 05                	jmp    8024fa <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8024f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024fa:	c9                   	leave  
  8024fb:	c3                   	ret    

008024fc <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8024fc:	55                   	push   %ebp
  8024fd:	89 e5                	mov    %esp,%ebp
  8024ff:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802502:	6a 00                	push   $0x0
  802504:	6a 00                	push   $0x0
  802506:	6a 00                	push   $0x0
  802508:	6a 00                	push   $0x0
  80250a:	6a 00                	push   $0x0
  80250c:	6a 2c                	push   $0x2c
  80250e:	e8 19 fa ff ff       	call   801f2c <syscall>
  802513:	83 c4 18             	add    $0x18,%esp
  802516:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802519:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80251d:	75 07                	jne    802526 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80251f:	b8 01 00 00 00       	mov    $0x1,%eax
  802524:	eb 05                	jmp    80252b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802526:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80252b:	c9                   	leave  
  80252c:	c3                   	ret    

0080252d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80252d:	55                   	push   %ebp
  80252e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802530:	6a 00                	push   $0x0
  802532:	6a 00                	push   $0x0
  802534:	6a 00                	push   $0x0
  802536:	6a 00                	push   $0x0
  802538:	ff 75 08             	pushl  0x8(%ebp)
  80253b:	6a 2d                	push   $0x2d
  80253d:	e8 ea f9 ff ff       	call   801f2c <syscall>
  802542:	83 c4 18             	add    $0x18,%esp
	return ;
  802545:	90                   	nop
}
  802546:	c9                   	leave  
  802547:	c3                   	ret    

00802548 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802548:	55                   	push   %ebp
  802549:	89 e5                	mov    %esp,%ebp
  80254b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80254c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80254f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802552:	8b 55 0c             	mov    0xc(%ebp),%edx
  802555:	8b 45 08             	mov    0x8(%ebp),%eax
  802558:	6a 00                	push   $0x0
  80255a:	53                   	push   %ebx
  80255b:	51                   	push   %ecx
  80255c:	52                   	push   %edx
  80255d:	50                   	push   %eax
  80255e:	6a 2e                	push   $0x2e
  802560:	e8 c7 f9 ff ff       	call   801f2c <syscall>
  802565:	83 c4 18             	add    $0x18,%esp
}
  802568:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80256b:	c9                   	leave  
  80256c:	c3                   	ret    

0080256d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80256d:	55                   	push   %ebp
  80256e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802570:	8b 55 0c             	mov    0xc(%ebp),%edx
  802573:	8b 45 08             	mov    0x8(%ebp),%eax
  802576:	6a 00                	push   $0x0
  802578:	6a 00                	push   $0x0
  80257a:	6a 00                	push   $0x0
  80257c:	52                   	push   %edx
  80257d:	50                   	push   %eax
  80257e:	6a 2f                	push   $0x2f
  802580:	e8 a7 f9 ff ff       	call   801f2c <syscall>
  802585:	83 c4 18             	add    $0x18,%esp
}
  802588:	c9                   	leave  
  802589:	c3                   	ret    

0080258a <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80258a:	55                   	push   %ebp
  80258b:	89 e5                	mov    %esp,%ebp
  80258d:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802590:	83 ec 0c             	sub    $0xc,%esp
  802593:	68 dc 46 80 00       	push   $0x8046dc
  802598:	e8 18 e6 ff ff       	call   800bb5 <cprintf>
  80259d:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8025a0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8025a7:	83 ec 0c             	sub    $0xc,%esp
  8025aa:	68 08 47 80 00       	push   $0x804708
  8025af:	e8 01 e6 ff ff       	call   800bb5 <cprintf>
  8025b4:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8025b7:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8025bb:	a1 38 51 80 00       	mov    0x805138,%eax
  8025c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025c3:	eb 56                	jmp    80261b <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8025c5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025c9:	74 1c                	je     8025e7 <print_mem_block_lists+0x5d>
  8025cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ce:	8b 50 08             	mov    0x8(%eax),%edx
  8025d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d4:	8b 48 08             	mov    0x8(%eax),%ecx
  8025d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025da:	8b 40 0c             	mov    0xc(%eax),%eax
  8025dd:	01 c8                	add    %ecx,%eax
  8025df:	39 c2                	cmp    %eax,%edx
  8025e1:	73 04                	jae    8025e7 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8025e3:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8025e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ea:	8b 50 08             	mov    0x8(%eax),%edx
  8025ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8025f3:	01 c2                	add    %eax,%edx
  8025f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f8:	8b 40 08             	mov    0x8(%eax),%eax
  8025fb:	83 ec 04             	sub    $0x4,%esp
  8025fe:	52                   	push   %edx
  8025ff:	50                   	push   %eax
  802600:	68 1d 47 80 00       	push   $0x80471d
  802605:	e8 ab e5 ff ff       	call   800bb5 <cprintf>
  80260a:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80260d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802610:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802613:	a1 40 51 80 00       	mov    0x805140,%eax
  802618:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80261b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80261f:	74 07                	je     802628 <print_mem_block_lists+0x9e>
  802621:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802624:	8b 00                	mov    (%eax),%eax
  802626:	eb 05                	jmp    80262d <print_mem_block_lists+0xa3>
  802628:	b8 00 00 00 00       	mov    $0x0,%eax
  80262d:	a3 40 51 80 00       	mov    %eax,0x805140
  802632:	a1 40 51 80 00       	mov    0x805140,%eax
  802637:	85 c0                	test   %eax,%eax
  802639:	75 8a                	jne    8025c5 <print_mem_block_lists+0x3b>
  80263b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80263f:	75 84                	jne    8025c5 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802641:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802645:	75 10                	jne    802657 <print_mem_block_lists+0xcd>
  802647:	83 ec 0c             	sub    $0xc,%esp
  80264a:	68 2c 47 80 00       	push   $0x80472c
  80264f:	e8 61 e5 ff ff       	call   800bb5 <cprintf>
  802654:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802657:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80265e:	83 ec 0c             	sub    $0xc,%esp
  802661:	68 50 47 80 00       	push   $0x804750
  802666:	e8 4a e5 ff ff       	call   800bb5 <cprintf>
  80266b:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80266e:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802672:	a1 40 50 80 00       	mov    0x805040,%eax
  802677:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80267a:	eb 56                	jmp    8026d2 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80267c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802680:	74 1c                	je     80269e <print_mem_block_lists+0x114>
  802682:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802685:	8b 50 08             	mov    0x8(%eax),%edx
  802688:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80268b:	8b 48 08             	mov    0x8(%eax),%ecx
  80268e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802691:	8b 40 0c             	mov    0xc(%eax),%eax
  802694:	01 c8                	add    %ecx,%eax
  802696:	39 c2                	cmp    %eax,%edx
  802698:	73 04                	jae    80269e <print_mem_block_lists+0x114>
			sorted = 0 ;
  80269a:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80269e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a1:	8b 50 08             	mov    0x8(%eax),%edx
  8026a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8026aa:	01 c2                	add    %eax,%edx
  8026ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026af:	8b 40 08             	mov    0x8(%eax),%eax
  8026b2:	83 ec 04             	sub    $0x4,%esp
  8026b5:	52                   	push   %edx
  8026b6:	50                   	push   %eax
  8026b7:	68 1d 47 80 00       	push   $0x80471d
  8026bc:	e8 f4 e4 ff ff       	call   800bb5 <cprintf>
  8026c1:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8026c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8026ca:	a1 48 50 80 00       	mov    0x805048,%eax
  8026cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026d6:	74 07                	je     8026df <print_mem_block_lists+0x155>
  8026d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026db:	8b 00                	mov    (%eax),%eax
  8026dd:	eb 05                	jmp    8026e4 <print_mem_block_lists+0x15a>
  8026df:	b8 00 00 00 00       	mov    $0x0,%eax
  8026e4:	a3 48 50 80 00       	mov    %eax,0x805048
  8026e9:	a1 48 50 80 00       	mov    0x805048,%eax
  8026ee:	85 c0                	test   %eax,%eax
  8026f0:	75 8a                	jne    80267c <print_mem_block_lists+0xf2>
  8026f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026f6:	75 84                	jne    80267c <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8026f8:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8026fc:	75 10                	jne    80270e <print_mem_block_lists+0x184>
  8026fe:	83 ec 0c             	sub    $0xc,%esp
  802701:	68 68 47 80 00       	push   $0x804768
  802706:	e8 aa e4 ff ff       	call   800bb5 <cprintf>
  80270b:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80270e:	83 ec 0c             	sub    $0xc,%esp
  802711:	68 dc 46 80 00       	push   $0x8046dc
  802716:	e8 9a e4 ff ff       	call   800bb5 <cprintf>
  80271b:	83 c4 10             	add    $0x10,%esp

}
  80271e:	90                   	nop
  80271f:	c9                   	leave  
  802720:	c3                   	ret    

00802721 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802721:	55                   	push   %ebp
  802722:	89 e5                	mov    %esp,%ebp
  802724:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802727:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80272e:	00 00 00 
  802731:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802738:	00 00 00 
  80273b:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802742:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802745:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80274c:	e9 9e 00 00 00       	jmp    8027ef <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802751:	a1 50 50 80 00       	mov    0x805050,%eax
  802756:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802759:	c1 e2 04             	shl    $0x4,%edx
  80275c:	01 d0                	add    %edx,%eax
  80275e:	85 c0                	test   %eax,%eax
  802760:	75 14                	jne    802776 <initialize_MemBlocksList+0x55>
  802762:	83 ec 04             	sub    $0x4,%esp
  802765:	68 90 47 80 00       	push   $0x804790
  80276a:	6a 46                	push   $0x46
  80276c:	68 b3 47 80 00       	push   $0x8047b3
  802771:	e8 8b e1 ff ff       	call   800901 <_panic>
  802776:	a1 50 50 80 00       	mov    0x805050,%eax
  80277b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80277e:	c1 e2 04             	shl    $0x4,%edx
  802781:	01 d0                	add    %edx,%eax
  802783:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802789:	89 10                	mov    %edx,(%eax)
  80278b:	8b 00                	mov    (%eax),%eax
  80278d:	85 c0                	test   %eax,%eax
  80278f:	74 18                	je     8027a9 <initialize_MemBlocksList+0x88>
  802791:	a1 48 51 80 00       	mov    0x805148,%eax
  802796:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80279c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80279f:	c1 e1 04             	shl    $0x4,%ecx
  8027a2:	01 ca                	add    %ecx,%edx
  8027a4:	89 50 04             	mov    %edx,0x4(%eax)
  8027a7:	eb 12                	jmp    8027bb <initialize_MemBlocksList+0x9a>
  8027a9:	a1 50 50 80 00       	mov    0x805050,%eax
  8027ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027b1:	c1 e2 04             	shl    $0x4,%edx
  8027b4:	01 d0                	add    %edx,%eax
  8027b6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8027bb:	a1 50 50 80 00       	mov    0x805050,%eax
  8027c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027c3:	c1 e2 04             	shl    $0x4,%edx
  8027c6:	01 d0                	add    %edx,%eax
  8027c8:	a3 48 51 80 00       	mov    %eax,0x805148
  8027cd:	a1 50 50 80 00       	mov    0x805050,%eax
  8027d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027d5:	c1 e2 04             	shl    $0x4,%edx
  8027d8:	01 d0                	add    %edx,%eax
  8027da:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027e1:	a1 54 51 80 00       	mov    0x805154,%eax
  8027e6:	40                   	inc    %eax
  8027e7:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8027ec:	ff 45 f4             	incl   -0xc(%ebp)
  8027ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027f5:	0f 82 56 ff ff ff    	jb     802751 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8027fb:	90                   	nop
  8027fc:	c9                   	leave  
  8027fd:	c3                   	ret    

008027fe <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8027fe:	55                   	push   %ebp
  8027ff:	89 e5                	mov    %esp,%ebp
  802801:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802804:	8b 45 08             	mov    0x8(%ebp),%eax
  802807:	8b 00                	mov    (%eax),%eax
  802809:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80280c:	eb 19                	jmp    802827 <find_block+0x29>
	{
		if(va==point->sva)
  80280e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802811:	8b 40 08             	mov    0x8(%eax),%eax
  802814:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802817:	75 05                	jne    80281e <find_block+0x20>
		   return point;
  802819:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80281c:	eb 36                	jmp    802854 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80281e:	8b 45 08             	mov    0x8(%ebp),%eax
  802821:	8b 40 08             	mov    0x8(%eax),%eax
  802824:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802827:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80282b:	74 07                	je     802834 <find_block+0x36>
  80282d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802830:	8b 00                	mov    (%eax),%eax
  802832:	eb 05                	jmp    802839 <find_block+0x3b>
  802834:	b8 00 00 00 00       	mov    $0x0,%eax
  802839:	8b 55 08             	mov    0x8(%ebp),%edx
  80283c:	89 42 08             	mov    %eax,0x8(%edx)
  80283f:	8b 45 08             	mov    0x8(%ebp),%eax
  802842:	8b 40 08             	mov    0x8(%eax),%eax
  802845:	85 c0                	test   %eax,%eax
  802847:	75 c5                	jne    80280e <find_block+0x10>
  802849:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80284d:	75 bf                	jne    80280e <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  80284f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802854:	c9                   	leave  
  802855:	c3                   	ret    

00802856 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802856:	55                   	push   %ebp
  802857:	89 e5                	mov    %esp,%ebp
  802859:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80285c:	a1 40 50 80 00       	mov    0x805040,%eax
  802861:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802864:	a1 44 50 80 00       	mov    0x805044,%eax
  802869:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80286c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80286f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802872:	74 24                	je     802898 <insert_sorted_allocList+0x42>
  802874:	8b 45 08             	mov    0x8(%ebp),%eax
  802877:	8b 50 08             	mov    0x8(%eax),%edx
  80287a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80287d:	8b 40 08             	mov    0x8(%eax),%eax
  802880:	39 c2                	cmp    %eax,%edx
  802882:	76 14                	jbe    802898 <insert_sorted_allocList+0x42>
  802884:	8b 45 08             	mov    0x8(%ebp),%eax
  802887:	8b 50 08             	mov    0x8(%eax),%edx
  80288a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80288d:	8b 40 08             	mov    0x8(%eax),%eax
  802890:	39 c2                	cmp    %eax,%edx
  802892:	0f 82 60 01 00 00    	jb     8029f8 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802898:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80289c:	75 65                	jne    802903 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80289e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028a2:	75 14                	jne    8028b8 <insert_sorted_allocList+0x62>
  8028a4:	83 ec 04             	sub    $0x4,%esp
  8028a7:	68 90 47 80 00       	push   $0x804790
  8028ac:	6a 6b                	push   $0x6b
  8028ae:	68 b3 47 80 00       	push   $0x8047b3
  8028b3:	e8 49 e0 ff ff       	call   800901 <_panic>
  8028b8:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8028be:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c1:	89 10                	mov    %edx,(%eax)
  8028c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c6:	8b 00                	mov    (%eax),%eax
  8028c8:	85 c0                	test   %eax,%eax
  8028ca:	74 0d                	je     8028d9 <insert_sorted_allocList+0x83>
  8028cc:	a1 40 50 80 00       	mov    0x805040,%eax
  8028d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8028d4:	89 50 04             	mov    %edx,0x4(%eax)
  8028d7:	eb 08                	jmp    8028e1 <insert_sorted_allocList+0x8b>
  8028d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028dc:	a3 44 50 80 00       	mov    %eax,0x805044
  8028e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e4:	a3 40 50 80 00       	mov    %eax,0x805040
  8028e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028f3:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8028f8:	40                   	inc    %eax
  8028f9:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8028fe:	e9 dc 01 00 00       	jmp    802adf <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802903:	8b 45 08             	mov    0x8(%ebp),%eax
  802906:	8b 50 08             	mov    0x8(%eax),%edx
  802909:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80290c:	8b 40 08             	mov    0x8(%eax),%eax
  80290f:	39 c2                	cmp    %eax,%edx
  802911:	77 6c                	ja     80297f <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802913:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802917:	74 06                	je     80291f <insert_sorted_allocList+0xc9>
  802919:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80291d:	75 14                	jne    802933 <insert_sorted_allocList+0xdd>
  80291f:	83 ec 04             	sub    $0x4,%esp
  802922:	68 cc 47 80 00       	push   $0x8047cc
  802927:	6a 6f                	push   $0x6f
  802929:	68 b3 47 80 00       	push   $0x8047b3
  80292e:	e8 ce df ff ff       	call   800901 <_panic>
  802933:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802936:	8b 50 04             	mov    0x4(%eax),%edx
  802939:	8b 45 08             	mov    0x8(%ebp),%eax
  80293c:	89 50 04             	mov    %edx,0x4(%eax)
  80293f:	8b 45 08             	mov    0x8(%ebp),%eax
  802942:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802945:	89 10                	mov    %edx,(%eax)
  802947:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80294a:	8b 40 04             	mov    0x4(%eax),%eax
  80294d:	85 c0                	test   %eax,%eax
  80294f:	74 0d                	je     80295e <insert_sorted_allocList+0x108>
  802951:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802954:	8b 40 04             	mov    0x4(%eax),%eax
  802957:	8b 55 08             	mov    0x8(%ebp),%edx
  80295a:	89 10                	mov    %edx,(%eax)
  80295c:	eb 08                	jmp    802966 <insert_sorted_allocList+0x110>
  80295e:	8b 45 08             	mov    0x8(%ebp),%eax
  802961:	a3 40 50 80 00       	mov    %eax,0x805040
  802966:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802969:	8b 55 08             	mov    0x8(%ebp),%edx
  80296c:	89 50 04             	mov    %edx,0x4(%eax)
  80296f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802974:	40                   	inc    %eax
  802975:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80297a:	e9 60 01 00 00       	jmp    802adf <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80297f:	8b 45 08             	mov    0x8(%ebp),%eax
  802982:	8b 50 08             	mov    0x8(%eax),%edx
  802985:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802988:	8b 40 08             	mov    0x8(%eax),%eax
  80298b:	39 c2                	cmp    %eax,%edx
  80298d:	0f 82 4c 01 00 00    	jb     802adf <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802993:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802997:	75 14                	jne    8029ad <insert_sorted_allocList+0x157>
  802999:	83 ec 04             	sub    $0x4,%esp
  80299c:	68 04 48 80 00       	push   $0x804804
  8029a1:	6a 73                	push   $0x73
  8029a3:	68 b3 47 80 00       	push   $0x8047b3
  8029a8:	e8 54 df ff ff       	call   800901 <_panic>
  8029ad:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8029b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b6:	89 50 04             	mov    %edx,0x4(%eax)
  8029b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bc:	8b 40 04             	mov    0x4(%eax),%eax
  8029bf:	85 c0                	test   %eax,%eax
  8029c1:	74 0c                	je     8029cf <insert_sorted_allocList+0x179>
  8029c3:	a1 44 50 80 00       	mov    0x805044,%eax
  8029c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8029cb:	89 10                	mov    %edx,(%eax)
  8029cd:	eb 08                	jmp    8029d7 <insert_sorted_allocList+0x181>
  8029cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d2:	a3 40 50 80 00       	mov    %eax,0x805040
  8029d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029da:	a3 44 50 80 00       	mov    %eax,0x805044
  8029df:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029e8:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029ed:	40                   	inc    %eax
  8029ee:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8029f3:	e9 e7 00 00 00       	jmp    802adf <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8029f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8029fe:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802a05:	a1 40 50 80 00       	mov    0x805040,%eax
  802a0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a0d:	e9 9d 00 00 00       	jmp    802aaf <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a15:	8b 00                	mov    (%eax),%eax
  802a17:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1d:	8b 50 08             	mov    0x8(%eax),%edx
  802a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a23:	8b 40 08             	mov    0x8(%eax),%eax
  802a26:	39 c2                	cmp    %eax,%edx
  802a28:	76 7d                	jbe    802aa7 <insert_sorted_allocList+0x251>
  802a2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2d:	8b 50 08             	mov    0x8(%eax),%edx
  802a30:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a33:	8b 40 08             	mov    0x8(%eax),%eax
  802a36:	39 c2                	cmp    %eax,%edx
  802a38:	73 6d                	jae    802aa7 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802a3a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a3e:	74 06                	je     802a46 <insert_sorted_allocList+0x1f0>
  802a40:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a44:	75 14                	jne    802a5a <insert_sorted_allocList+0x204>
  802a46:	83 ec 04             	sub    $0x4,%esp
  802a49:	68 28 48 80 00       	push   $0x804828
  802a4e:	6a 7f                	push   $0x7f
  802a50:	68 b3 47 80 00       	push   $0x8047b3
  802a55:	e8 a7 de ff ff       	call   800901 <_panic>
  802a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5d:	8b 10                	mov    (%eax),%edx
  802a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a62:	89 10                	mov    %edx,(%eax)
  802a64:	8b 45 08             	mov    0x8(%ebp),%eax
  802a67:	8b 00                	mov    (%eax),%eax
  802a69:	85 c0                	test   %eax,%eax
  802a6b:	74 0b                	je     802a78 <insert_sorted_allocList+0x222>
  802a6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a70:	8b 00                	mov    (%eax),%eax
  802a72:	8b 55 08             	mov    0x8(%ebp),%edx
  802a75:	89 50 04             	mov    %edx,0x4(%eax)
  802a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7b:	8b 55 08             	mov    0x8(%ebp),%edx
  802a7e:	89 10                	mov    %edx,(%eax)
  802a80:	8b 45 08             	mov    0x8(%ebp),%eax
  802a83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a86:	89 50 04             	mov    %edx,0x4(%eax)
  802a89:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8c:	8b 00                	mov    (%eax),%eax
  802a8e:	85 c0                	test   %eax,%eax
  802a90:	75 08                	jne    802a9a <insert_sorted_allocList+0x244>
  802a92:	8b 45 08             	mov    0x8(%ebp),%eax
  802a95:	a3 44 50 80 00       	mov    %eax,0x805044
  802a9a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a9f:	40                   	inc    %eax
  802aa0:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802aa5:	eb 39                	jmp    802ae0 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802aa7:	a1 48 50 80 00       	mov    0x805048,%eax
  802aac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aaf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ab3:	74 07                	je     802abc <insert_sorted_allocList+0x266>
  802ab5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab8:	8b 00                	mov    (%eax),%eax
  802aba:	eb 05                	jmp    802ac1 <insert_sorted_allocList+0x26b>
  802abc:	b8 00 00 00 00       	mov    $0x0,%eax
  802ac1:	a3 48 50 80 00       	mov    %eax,0x805048
  802ac6:	a1 48 50 80 00       	mov    0x805048,%eax
  802acb:	85 c0                	test   %eax,%eax
  802acd:	0f 85 3f ff ff ff    	jne    802a12 <insert_sorted_allocList+0x1bc>
  802ad3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ad7:	0f 85 35 ff ff ff    	jne    802a12 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802add:	eb 01                	jmp    802ae0 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802adf:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802ae0:	90                   	nop
  802ae1:	c9                   	leave  
  802ae2:	c3                   	ret    

00802ae3 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802ae3:	55                   	push   %ebp
  802ae4:	89 e5                	mov    %esp,%ebp
  802ae6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802ae9:	a1 38 51 80 00       	mov    0x805138,%eax
  802aee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802af1:	e9 85 01 00 00       	jmp    802c7b <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802af6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af9:	8b 40 0c             	mov    0xc(%eax),%eax
  802afc:	3b 45 08             	cmp    0x8(%ebp),%eax
  802aff:	0f 82 6e 01 00 00    	jb     802c73 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802b05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b08:	8b 40 0c             	mov    0xc(%eax),%eax
  802b0b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b0e:	0f 85 8a 00 00 00    	jne    802b9e <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802b14:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b18:	75 17                	jne    802b31 <alloc_block_FF+0x4e>
  802b1a:	83 ec 04             	sub    $0x4,%esp
  802b1d:	68 5c 48 80 00       	push   $0x80485c
  802b22:	68 93 00 00 00       	push   $0x93
  802b27:	68 b3 47 80 00       	push   $0x8047b3
  802b2c:	e8 d0 dd ff ff       	call   800901 <_panic>
  802b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b34:	8b 00                	mov    (%eax),%eax
  802b36:	85 c0                	test   %eax,%eax
  802b38:	74 10                	je     802b4a <alloc_block_FF+0x67>
  802b3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3d:	8b 00                	mov    (%eax),%eax
  802b3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b42:	8b 52 04             	mov    0x4(%edx),%edx
  802b45:	89 50 04             	mov    %edx,0x4(%eax)
  802b48:	eb 0b                	jmp    802b55 <alloc_block_FF+0x72>
  802b4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4d:	8b 40 04             	mov    0x4(%eax),%eax
  802b50:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b58:	8b 40 04             	mov    0x4(%eax),%eax
  802b5b:	85 c0                	test   %eax,%eax
  802b5d:	74 0f                	je     802b6e <alloc_block_FF+0x8b>
  802b5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b62:	8b 40 04             	mov    0x4(%eax),%eax
  802b65:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b68:	8b 12                	mov    (%edx),%edx
  802b6a:	89 10                	mov    %edx,(%eax)
  802b6c:	eb 0a                	jmp    802b78 <alloc_block_FF+0x95>
  802b6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b71:	8b 00                	mov    (%eax),%eax
  802b73:	a3 38 51 80 00       	mov    %eax,0x805138
  802b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b84:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b8b:	a1 44 51 80 00       	mov    0x805144,%eax
  802b90:	48                   	dec    %eax
  802b91:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802b96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b99:	e9 10 01 00 00       	jmp    802cae <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802b9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ba4:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ba7:	0f 86 c6 00 00 00    	jbe    802c73 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802bad:	a1 48 51 80 00       	mov    0x805148,%eax
  802bb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802bb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb8:	8b 50 08             	mov    0x8(%eax),%edx
  802bbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bbe:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802bc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc4:	8b 55 08             	mov    0x8(%ebp),%edx
  802bc7:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802bca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bce:	75 17                	jne    802be7 <alloc_block_FF+0x104>
  802bd0:	83 ec 04             	sub    $0x4,%esp
  802bd3:	68 5c 48 80 00       	push   $0x80485c
  802bd8:	68 9b 00 00 00       	push   $0x9b
  802bdd:	68 b3 47 80 00       	push   $0x8047b3
  802be2:	e8 1a dd ff ff       	call   800901 <_panic>
  802be7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bea:	8b 00                	mov    (%eax),%eax
  802bec:	85 c0                	test   %eax,%eax
  802bee:	74 10                	je     802c00 <alloc_block_FF+0x11d>
  802bf0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf3:	8b 00                	mov    (%eax),%eax
  802bf5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bf8:	8b 52 04             	mov    0x4(%edx),%edx
  802bfb:	89 50 04             	mov    %edx,0x4(%eax)
  802bfe:	eb 0b                	jmp    802c0b <alloc_block_FF+0x128>
  802c00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c03:	8b 40 04             	mov    0x4(%eax),%eax
  802c06:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c0e:	8b 40 04             	mov    0x4(%eax),%eax
  802c11:	85 c0                	test   %eax,%eax
  802c13:	74 0f                	je     802c24 <alloc_block_FF+0x141>
  802c15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c18:	8b 40 04             	mov    0x4(%eax),%eax
  802c1b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c1e:	8b 12                	mov    (%edx),%edx
  802c20:	89 10                	mov    %edx,(%eax)
  802c22:	eb 0a                	jmp    802c2e <alloc_block_FF+0x14b>
  802c24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c27:	8b 00                	mov    (%eax),%eax
  802c29:	a3 48 51 80 00       	mov    %eax,0x805148
  802c2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c31:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c3a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c41:	a1 54 51 80 00       	mov    0x805154,%eax
  802c46:	48                   	dec    %eax
  802c47:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802c4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4f:	8b 50 08             	mov    0x8(%eax),%edx
  802c52:	8b 45 08             	mov    0x8(%ebp),%eax
  802c55:	01 c2                	add    %eax,%edx
  802c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5a:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802c5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c60:	8b 40 0c             	mov    0xc(%eax),%eax
  802c63:	2b 45 08             	sub    0x8(%ebp),%eax
  802c66:	89 c2                	mov    %eax,%edx
  802c68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6b:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802c6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c71:	eb 3b                	jmp    802cae <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802c73:	a1 40 51 80 00       	mov    0x805140,%eax
  802c78:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c7b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c7f:	74 07                	je     802c88 <alloc_block_FF+0x1a5>
  802c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c84:	8b 00                	mov    (%eax),%eax
  802c86:	eb 05                	jmp    802c8d <alloc_block_FF+0x1aa>
  802c88:	b8 00 00 00 00       	mov    $0x0,%eax
  802c8d:	a3 40 51 80 00       	mov    %eax,0x805140
  802c92:	a1 40 51 80 00       	mov    0x805140,%eax
  802c97:	85 c0                	test   %eax,%eax
  802c99:	0f 85 57 fe ff ff    	jne    802af6 <alloc_block_FF+0x13>
  802c9f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ca3:	0f 85 4d fe ff ff    	jne    802af6 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802ca9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cae:	c9                   	leave  
  802caf:	c3                   	ret    

00802cb0 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802cb0:	55                   	push   %ebp
  802cb1:	89 e5                	mov    %esp,%ebp
  802cb3:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802cb6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802cbd:	a1 38 51 80 00       	mov    0x805138,%eax
  802cc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cc5:	e9 df 00 00 00       	jmp    802da9 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802cca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccd:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd0:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cd3:	0f 82 c8 00 00 00    	jb     802da1 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802cd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdc:	8b 40 0c             	mov    0xc(%eax),%eax
  802cdf:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ce2:	0f 85 8a 00 00 00    	jne    802d72 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802ce8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cec:	75 17                	jne    802d05 <alloc_block_BF+0x55>
  802cee:	83 ec 04             	sub    $0x4,%esp
  802cf1:	68 5c 48 80 00       	push   $0x80485c
  802cf6:	68 b7 00 00 00       	push   $0xb7
  802cfb:	68 b3 47 80 00       	push   $0x8047b3
  802d00:	e8 fc db ff ff       	call   800901 <_panic>
  802d05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d08:	8b 00                	mov    (%eax),%eax
  802d0a:	85 c0                	test   %eax,%eax
  802d0c:	74 10                	je     802d1e <alloc_block_BF+0x6e>
  802d0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d11:	8b 00                	mov    (%eax),%eax
  802d13:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d16:	8b 52 04             	mov    0x4(%edx),%edx
  802d19:	89 50 04             	mov    %edx,0x4(%eax)
  802d1c:	eb 0b                	jmp    802d29 <alloc_block_BF+0x79>
  802d1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d21:	8b 40 04             	mov    0x4(%eax),%eax
  802d24:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2c:	8b 40 04             	mov    0x4(%eax),%eax
  802d2f:	85 c0                	test   %eax,%eax
  802d31:	74 0f                	je     802d42 <alloc_block_BF+0x92>
  802d33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d36:	8b 40 04             	mov    0x4(%eax),%eax
  802d39:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d3c:	8b 12                	mov    (%edx),%edx
  802d3e:	89 10                	mov    %edx,(%eax)
  802d40:	eb 0a                	jmp    802d4c <alloc_block_BF+0x9c>
  802d42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d45:	8b 00                	mov    (%eax),%eax
  802d47:	a3 38 51 80 00       	mov    %eax,0x805138
  802d4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d58:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d5f:	a1 44 51 80 00       	mov    0x805144,%eax
  802d64:	48                   	dec    %eax
  802d65:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802d6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6d:	e9 4d 01 00 00       	jmp    802ebf <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802d72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d75:	8b 40 0c             	mov    0xc(%eax),%eax
  802d78:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d7b:	76 24                	jbe    802da1 <alloc_block_BF+0xf1>
  802d7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d80:	8b 40 0c             	mov    0xc(%eax),%eax
  802d83:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802d86:	73 19                	jae    802da1 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802d88:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802d8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d92:	8b 40 0c             	mov    0xc(%eax),%eax
  802d95:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802d98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9b:	8b 40 08             	mov    0x8(%eax),%eax
  802d9e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802da1:	a1 40 51 80 00       	mov    0x805140,%eax
  802da6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802da9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dad:	74 07                	je     802db6 <alloc_block_BF+0x106>
  802daf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db2:	8b 00                	mov    (%eax),%eax
  802db4:	eb 05                	jmp    802dbb <alloc_block_BF+0x10b>
  802db6:	b8 00 00 00 00       	mov    $0x0,%eax
  802dbb:	a3 40 51 80 00       	mov    %eax,0x805140
  802dc0:	a1 40 51 80 00       	mov    0x805140,%eax
  802dc5:	85 c0                	test   %eax,%eax
  802dc7:	0f 85 fd fe ff ff    	jne    802cca <alloc_block_BF+0x1a>
  802dcd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dd1:	0f 85 f3 fe ff ff    	jne    802cca <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802dd7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ddb:	0f 84 d9 00 00 00    	je     802eba <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802de1:	a1 48 51 80 00       	mov    0x805148,%eax
  802de6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802de9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dec:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802def:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802df2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802df5:	8b 55 08             	mov    0x8(%ebp),%edx
  802df8:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802dfb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802dff:	75 17                	jne    802e18 <alloc_block_BF+0x168>
  802e01:	83 ec 04             	sub    $0x4,%esp
  802e04:	68 5c 48 80 00       	push   $0x80485c
  802e09:	68 c7 00 00 00       	push   $0xc7
  802e0e:	68 b3 47 80 00       	push   $0x8047b3
  802e13:	e8 e9 da ff ff       	call   800901 <_panic>
  802e18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e1b:	8b 00                	mov    (%eax),%eax
  802e1d:	85 c0                	test   %eax,%eax
  802e1f:	74 10                	je     802e31 <alloc_block_BF+0x181>
  802e21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e24:	8b 00                	mov    (%eax),%eax
  802e26:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e29:	8b 52 04             	mov    0x4(%edx),%edx
  802e2c:	89 50 04             	mov    %edx,0x4(%eax)
  802e2f:	eb 0b                	jmp    802e3c <alloc_block_BF+0x18c>
  802e31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e34:	8b 40 04             	mov    0x4(%eax),%eax
  802e37:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e3f:	8b 40 04             	mov    0x4(%eax),%eax
  802e42:	85 c0                	test   %eax,%eax
  802e44:	74 0f                	je     802e55 <alloc_block_BF+0x1a5>
  802e46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e49:	8b 40 04             	mov    0x4(%eax),%eax
  802e4c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e4f:	8b 12                	mov    (%edx),%edx
  802e51:	89 10                	mov    %edx,(%eax)
  802e53:	eb 0a                	jmp    802e5f <alloc_block_BF+0x1af>
  802e55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e58:	8b 00                	mov    (%eax),%eax
  802e5a:	a3 48 51 80 00       	mov    %eax,0x805148
  802e5f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e62:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e6b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e72:	a1 54 51 80 00       	mov    0x805154,%eax
  802e77:	48                   	dec    %eax
  802e78:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802e7d:	83 ec 08             	sub    $0x8,%esp
  802e80:	ff 75 ec             	pushl  -0x14(%ebp)
  802e83:	68 38 51 80 00       	push   $0x805138
  802e88:	e8 71 f9 ff ff       	call   8027fe <find_block>
  802e8d:	83 c4 10             	add    $0x10,%esp
  802e90:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802e93:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e96:	8b 50 08             	mov    0x8(%eax),%edx
  802e99:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9c:	01 c2                	add    %eax,%edx
  802e9e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ea1:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802ea4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ea7:	8b 40 0c             	mov    0xc(%eax),%eax
  802eaa:	2b 45 08             	sub    0x8(%ebp),%eax
  802ead:	89 c2                	mov    %eax,%edx
  802eaf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802eb2:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802eb5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802eb8:	eb 05                	jmp    802ebf <alloc_block_BF+0x20f>
	}
	return NULL;
  802eba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ebf:	c9                   	leave  
  802ec0:	c3                   	ret    

00802ec1 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802ec1:	55                   	push   %ebp
  802ec2:	89 e5                	mov    %esp,%ebp
  802ec4:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802ec7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802ecc:	85 c0                	test   %eax,%eax
  802ece:	0f 85 de 01 00 00    	jne    8030b2 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802ed4:	a1 38 51 80 00       	mov    0x805138,%eax
  802ed9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802edc:	e9 9e 01 00 00       	jmp    80307f <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802ee1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee4:	8b 40 0c             	mov    0xc(%eax),%eax
  802ee7:	3b 45 08             	cmp    0x8(%ebp),%eax
  802eea:	0f 82 87 01 00 00    	jb     803077 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802ef0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef3:	8b 40 0c             	mov    0xc(%eax),%eax
  802ef6:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ef9:	0f 85 95 00 00 00    	jne    802f94 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802eff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f03:	75 17                	jne    802f1c <alloc_block_NF+0x5b>
  802f05:	83 ec 04             	sub    $0x4,%esp
  802f08:	68 5c 48 80 00       	push   $0x80485c
  802f0d:	68 e0 00 00 00       	push   $0xe0
  802f12:	68 b3 47 80 00       	push   $0x8047b3
  802f17:	e8 e5 d9 ff ff       	call   800901 <_panic>
  802f1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1f:	8b 00                	mov    (%eax),%eax
  802f21:	85 c0                	test   %eax,%eax
  802f23:	74 10                	je     802f35 <alloc_block_NF+0x74>
  802f25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f28:	8b 00                	mov    (%eax),%eax
  802f2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f2d:	8b 52 04             	mov    0x4(%edx),%edx
  802f30:	89 50 04             	mov    %edx,0x4(%eax)
  802f33:	eb 0b                	jmp    802f40 <alloc_block_NF+0x7f>
  802f35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f38:	8b 40 04             	mov    0x4(%eax),%eax
  802f3b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f43:	8b 40 04             	mov    0x4(%eax),%eax
  802f46:	85 c0                	test   %eax,%eax
  802f48:	74 0f                	je     802f59 <alloc_block_NF+0x98>
  802f4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4d:	8b 40 04             	mov    0x4(%eax),%eax
  802f50:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f53:	8b 12                	mov    (%edx),%edx
  802f55:	89 10                	mov    %edx,(%eax)
  802f57:	eb 0a                	jmp    802f63 <alloc_block_NF+0xa2>
  802f59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5c:	8b 00                	mov    (%eax),%eax
  802f5e:	a3 38 51 80 00       	mov    %eax,0x805138
  802f63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f66:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f76:	a1 44 51 80 00       	mov    0x805144,%eax
  802f7b:	48                   	dec    %eax
  802f7c:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802f81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f84:	8b 40 08             	mov    0x8(%eax),%eax
  802f87:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   return  point;
  802f8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8f:	e9 f8 04 00 00       	jmp    80348c <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802f94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f97:	8b 40 0c             	mov    0xc(%eax),%eax
  802f9a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f9d:	0f 86 d4 00 00 00    	jbe    803077 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802fa3:	a1 48 51 80 00       	mov    0x805148,%eax
  802fa8:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802fab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fae:	8b 50 08             	mov    0x8(%eax),%edx
  802fb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb4:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802fb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fba:	8b 55 08             	mov    0x8(%ebp),%edx
  802fbd:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802fc0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fc4:	75 17                	jne    802fdd <alloc_block_NF+0x11c>
  802fc6:	83 ec 04             	sub    $0x4,%esp
  802fc9:	68 5c 48 80 00       	push   $0x80485c
  802fce:	68 e9 00 00 00       	push   $0xe9
  802fd3:	68 b3 47 80 00       	push   $0x8047b3
  802fd8:	e8 24 d9 ff ff       	call   800901 <_panic>
  802fdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe0:	8b 00                	mov    (%eax),%eax
  802fe2:	85 c0                	test   %eax,%eax
  802fe4:	74 10                	je     802ff6 <alloc_block_NF+0x135>
  802fe6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe9:	8b 00                	mov    (%eax),%eax
  802feb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fee:	8b 52 04             	mov    0x4(%edx),%edx
  802ff1:	89 50 04             	mov    %edx,0x4(%eax)
  802ff4:	eb 0b                	jmp    803001 <alloc_block_NF+0x140>
  802ff6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff9:	8b 40 04             	mov    0x4(%eax),%eax
  802ffc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803001:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803004:	8b 40 04             	mov    0x4(%eax),%eax
  803007:	85 c0                	test   %eax,%eax
  803009:	74 0f                	je     80301a <alloc_block_NF+0x159>
  80300b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80300e:	8b 40 04             	mov    0x4(%eax),%eax
  803011:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803014:	8b 12                	mov    (%edx),%edx
  803016:	89 10                	mov    %edx,(%eax)
  803018:	eb 0a                	jmp    803024 <alloc_block_NF+0x163>
  80301a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80301d:	8b 00                	mov    (%eax),%eax
  80301f:	a3 48 51 80 00       	mov    %eax,0x805148
  803024:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803027:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80302d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803030:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803037:	a1 54 51 80 00       	mov    0x805154,%eax
  80303c:	48                   	dec    %eax
  80303d:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  803042:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803045:	8b 40 08             	mov    0x8(%eax),%eax
  803048:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   point->sva += size;
  80304d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803050:	8b 50 08             	mov    0x8(%eax),%edx
  803053:	8b 45 08             	mov    0x8(%ebp),%eax
  803056:	01 c2                	add    %eax,%edx
  803058:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305b:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  80305e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803061:	8b 40 0c             	mov    0xc(%eax),%eax
  803064:	2b 45 08             	sub    0x8(%ebp),%eax
  803067:	89 c2                	mov    %eax,%edx
  803069:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306c:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  80306f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803072:	e9 15 04 00 00       	jmp    80348c <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  803077:	a1 40 51 80 00       	mov    0x805140,%eax
  80307c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80307f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803083:	74 07                	je     80308c <alloc_block_NF+0x1cb>
  803085:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803088:	8b 00                	mov    (%eax),%eax
  80308a:	eb 05                	jmp    803091 <alloc_block_NF+0x1d0>
  80308c:	b8 00 00 00 00       	mov    $0x0,%eax
  803091:	a3 40 51 80 00       	mov    %eax,0x805140
  803096:	a1 40 51 80 00       	mov    0x805140,%eax
  80309b:	85 c0                	test   %eax,%eax
  80309d:	0f 85 3e fe ff ff    	jne    802ee1 <alloc_block_NF+0x20>
  8030a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030a7:	0f 85 34 fe ff ff    	jne    802ee1 <alloc_block_NF+0x20>
  8030ad:	e9 d5 03 00 00       	jmp    803487 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8030b2:	a1 38 51 80 00       	mov    0x805138,%eax
  8030b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030ba:	e9 b1 01 00 00       	jmp    803270 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8030bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c2:	8b 50 08             	mov    0x8(%eax),%edx
  8030c5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030ca:	39 c2                	cmp    %eax,%edx
  8030cc:	0f 82 96 01 00 00    	jb     803268 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8030d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8030d8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030db:	0f 82 87 01 00 00    	jb     803268 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8030e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8030e7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030ea:	0f 85 95 00 00 00    	jne    803185 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8030f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030f4:	75 17                	jne    80310d <alloc_block_NF+0x24c>
  8030f6:	83 ec 04             	sub    $0x4,%esp
  8030f9:	68 5c 48 80 00       	push   $0x80485c
  8030fe:	68 fc 00 00 00       	push   $0xfc
  803103:	68 b3 47 80 00       	push   $0x8047b3
  803108:	e8 f4 d7 ff ff       	call   800901 <_panic>
  80310d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803110:	8b 00                	mov    (%eax),%eax
  803112:	85 c0                	test   %eax,%eax
  803114:	74 10                	je     803126 <alloc_block_NF+0x265>
  803116:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803119:	8b 00                	mov    (%eax),%eax
  80311b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80311e:	8b 52 04             	mov    0x4(%edx),%edx
  803121:	89 50 04             	mov    %edx,0x4(%eax)
  803124:	eb 0b                	jmp    803131 <alloc_block_NF+0x270>
  803126:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803129:	8b 40 04             	mov    0x4(%eax),%eax
  80312c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803131:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803134:	8b 40 04             	mov    0x4(%eax),%eax
  803137:	85 c0                	test   %eax,%eax
  803139:	74 0f                	je     80314a <alloc_block_NF+0x289>
  80313b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313e:	8b 40 04             	mov    0x4(%eax),%eax
  803141:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803144:	8b 12                	mov    (%edx),%edx
  803146:	89 10                	mov    %edx,(%eax)
  803148:	eb 0a                	jmp    803154 <alloc_block_NF+0x293>
  80314a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314d:	8b 00                	mov    (%eax),%eax
  80314f:	a3 38 51 80 00       	mov    %eax,0x805138
  803154:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803157:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80315d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803160:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803167:	a1 44 51 80 00       	mov    0x805144,%eax
  80316c:	48                   	dec    %eax
  80316d:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803172:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803175:	8b 40 08             	mov    0x8(%eax),%eax
  803178:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  80317d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803180:	e9 07 03 00 00       	jmp    80348c <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803185:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803188:	8b 40 0c             	mov    0xc(%eax),%eax
  80318b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80318e:	0f 86 d4 00 00 00    	jbe    803268 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803194:	a1 48 51 80 00       	mov    0x805148,%eax
  803199:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  80319c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319f:	8b 50 08             	mov    0x8(%eax),%edx
  8031a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a5:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8031a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8031ae:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8031b1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031b5:	75 17                	jne    8031ce <alloc_block_NF+0x30d>
  8031b7:	83 ec 04             	sub    $0x4,%esp
  8031ba:	68 5c 48 80 00       	push   $0x80485c
  8031bf:	68 04 01 00 00       	push   $0x104
  8031c4:	68 b3 47 80 00       	push   $0x8047b3
  8031c9:	e8 33 d7 ff ff       	call   800901 <_panic>
  8031ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d1:	8b 00                	mov    (%eax),%eax
  8031d3:	85 c0                	test   %eax,%eax
  8031d5:	74 10                	je     8031e7 <alloc_block_NF+0x326>
  8031d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031da:	8b 00                	mov    (%eax),%eax
  8031dc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031df:	8b 52 04             	mov    0x4(%edx),%edx
  8031e2:	89 50 04             	mov    %edx,0x4(%eax)
  8031e5:	eb 0b                	jmp    8031f2 <alloc_block_NF+0x331>
  8031e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ea:	8b 40 04             	mov    0x4(%eax),%eax
  8031ed:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f5:	8b 40 04             	mov    0x4(%eax),%eax
  8031f8:	85 c0                	test   %eax,%eax
  8031fa:	74 0f                	je     80320b <alloc_block_NF+0x34a>
  8031fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ff:	8b 40 04             	mov    0x4(%eax),%eax
  803202:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803205:	8b 12                	mov    (%edx),%edx
  803207:	89 10                	mov    %edx,(%eax)
  803209:	eb 0a                	jmp    803215 <alloc_block_NF+0x354>
  80320b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80320e:	8b 00                	mov    (%eax),%eax
  803210:	a3 48 51 80 00       	mov    %eax,0x805148
  803215:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803218:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80321e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803221:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803228:	a1 54 51 80 00       	mov    0x805154,%eax
  80322d:	48                   	dec    %eax
  80322e:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803233:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803236:	8b 40 08             	mov    0x8(%eax),%eax
  803239:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  80323e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803241:	8b 50 08             	mov    0x8(%eax),%edx
  803244:	8b 45 08             	mov    0x8(%ebp),%eax
  803247:	01 c2                	add    %eax,%edx
  803249:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324c:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80324f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803252:	8b 40 0c             	mov    0xc(%eax),%eax
  803255:	2b 45 08             	sub    0x8(%ebp),%eax
  803258:	89 c2                	mov    %eax,%edx
  80325a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325d:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803260:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803263:	e9 24 02 00 00       	jmp    80348c <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803268:	a1 40 51 80 00       	mov    0x805140,%eax
  80326d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803270:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803274:	74 07                	je     80327d <alloc_block_NF+0x3bc>
  803276:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803279:	8b 00                	mov    (%eax),%eax
  80327b:	eb 05                	jmp    803282 <alloc_block_NF+0x3c1>
  80327d:	b8 00 00 00 00       	mov    $0x0,%eax
  803282:	a3 40 51 80 00       	mov    %eax,0x805140
  803287:	a1 40 51 80 00       	mov    0x805140,%eax
  80328c:	85 c0                	test   %eax,%eax
  80328e:	0f 85 2b fe ff ff    	jne    8030bf <alloc_block_NF+0x1fe>
  803294:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803298:	0f 85 21 fe ff ff    	jne    8030bf <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  80329e:	a1 38 51 80 00       	mov    0x805138,%eax
  8032a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032a6:	e9 ae 01 00 00       	jmp    803459 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8032ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ae:	8b 50 08             	mov    0x8(%eax),%edx
  8032b1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032b6:	39 c2                	cmp    %eax,%edx
  8032b8:	0f 83 93 01 00 00    	jae    803451 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  8032be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8032c4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032c7:	0f 82 84 01 00 00    	jb     803451 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  8032cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8032d3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032d6:	0f 85 95 00 00 00    	jne    803371 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8032dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032e0:	75 17                	jne    8032f9 <alloc_block_NF+0x438>
  8032e2:	83 ec 04             	sub    $0x4,%esp
  8032e5:	68 5c 48 80 00       	push   $0x80485c
  8032ea:	68 14 01 00 00       	push   $0x114
  8032ef:	68 b3 47 80 00       	push   $0x8047b3
  8032f4:	e8 08 d6 ff ff       	call   800901 <_panic>
  8032f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032fc:	8b 00                	mov    (%eax),%eax
  8032fe:	85 c0                	test   %eax,%eax
  803300:	74 10                	je     803312 <alloc_block_NF+0x451>
  803302:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803305:	8b 00                	mov    (%eax),%eax
  803307:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80330a:	8b 52 04             	mov    0x4(%edx),%edx
  80330d:	89 50 04             	mov    %edx,0x4(%eax)
  803310:	eb 0b                	jmp    80331d <alloc_block_NF+0x45c>
  803312:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803315:	8b 40 04             	mov    0x4(%eax),%eax
  803318:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80331d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803320:	8b 40 04             	mov    0x4(%eax),%eax
  803323:	85 c0                	test   %eax,%eax
  803325:	74 0f                	je     803336 <alloc_block_NF+0x475>
  803327:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80332a:	8b 40 04             	mov    0x4(%eax),%eax
  80332d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803330:	8b 12                	mov    (%edx),%edx
  803332:	89 10                	mov    %edx,(%eax)
  803334:	eb 0a                	jmp    803340 <alloc_block_NF+0x47f>
  803336:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803339:	8b 00                	mov    (%eax),%eax
  80333b:	a3 38 51 80 00       	mov    %eax,0x805138
  803340:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803343:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803349:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80334c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803353:	a1 44 51 80 00       	mov    0x805144,%eax
  803358:	48                   	dec    %eax
  803359:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  80335e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803361:	8b 40 08             	mov    0x8(%eax),%eax
  803364:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  803369:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336c:	e9 1b 01 00 00       	jmp    80348c <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803371:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803374:	8b 40 0c             	mov    0xc(%eax),%eax
  803377:	3b 45 08             	cmp    0x8(%ebp),%eax
  80337a:	0f 86 d1 00 00 00    	jbe    803451 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803380:	a1 48 51 80 00       	mov    0x805148,%eax
  803385:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  803388:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80338b:	8b 50 08             	mov    0x8(%eax),%edx
  80338e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803391:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803394:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803397:	8b 55 08             	mov    0x8(%ebp),%edx
  80339a:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80339d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8033a1:	75 17                	jne    8033ba <alloc_block_NF+0x4f9>
  8033a3:	83 ec 04             	sub    $0x4,%esp
  8033a6:	68 5c 48 80 00       	push   $0x80485c
  8033ab:	68 1c 01 00 00       	push   $0x11c
  8033b0:	68 b3 47 80 00       	push   $0x8047b3
  8033b5:	e8 47 d5 ff ff       	call   800901 <_panic>
  8033ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033bd:	8b 00                	mov    (%eax),%eax
  8033bf:	85 c0                	test   %eax,%eax
  8033c1:	74 10                	je     8033d3 <alloc_block_NF+0x512>
  8033c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033c6:	8b 00                	mov    (%eax),%eax
  8033c8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8033cb:	8b 52 04             	mov    0x4(%edx),%edx
  8033ce:	89 50 04             	mov    %edx,0x4(%eax)
  8033d1:	eb 0b                	jmp    8033de <alloc_block_NF+0x51d>
  8033d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033d6:	8b 40 04             	mov    0x4(%eax),%eax
  8033d9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033e1:	8b 40 04             	mov    0x4(%eax),%eax
  8033e4:	85 c0                	test   %eax,%eax
  8033e6:	74 0f                	je     8033f7 <alloc_block_NF+0x536>
  8033e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033eb:	8b 40 04             	mov    0x4(%eax),%eax
  8033ee:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8033f1:	8b 12                	mov    (%edx),%edx
  8033f3:	89 10                	mov    %edx,(%eax)
  8033f5:	eb 0a                	jmp    803401 <alloc_block_NF+0x540>
  8033f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033fa:	8b 00                	mov    (%eax),%eax
  8033fc:	a3 48 51 80 00       	mov    %eax,0x805148
  803401:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803404:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80340a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80340d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803414:	a1 54 51 80 00       	mov    0x805154,%eax
  803419:	48                   	dec    %eax
  80341a:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  80341f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803422:	8b 40 08             	mov    0x8(%eax),%eax
  803425:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  80342a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80342d:	8b 50 08             	mov    0x8(%eax),%edx
  803430:	8b 45 08             	mov    0x8(%ebp),%eax
  803433:	01 c2                	add    %eax,%edx
  803435:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803438:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80343b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343e:	8b 40 0c             	mov    0xc(%eax),%eax
  803441:	2b 45 08             	sub    0x8(%ebp),%eax
  803444:	89 c2                	mov    %eax,%edx
  803446:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803449:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  80344c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80344f:	eb 3b                	jmp    80348c <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803451:	a1 40 51 80 00       	mov    0x805140,%eax
  803456:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803459:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80345d:	74 07                	je     803466 <alloc_block_NF+0x5a5>
  80345f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803462:	8b 00                	mov    (%eax),%eax
  803464:	eb 05                	jmp    80346b <alloc_block_NF+0x5aa>
  803466:	b8 00 00 00 00       	mov    $0x0,%eax
  80346b:	a3 40 51 80 00       	mov    %eax,0x805140
  803470:	a1 40 51 80 00       	mov    0x805140,%eax
  803475:	85 c0                	test   %eax,%eax
  803477:	0f 85 2e fe ff ff    	jne    8032ab <alloc_block_NF+0x3ea>
  80347d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803481:	0f 85 24 fe ff ff    	jne    8032ab <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  803487:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80348c:	c9                   	leave  
  80348d:	c3                   	ret    

0080348e <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80348e:	55                   	push   %ebp
  80348f:	89 e5                	mov    %esp,%ebp
  803491:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  803494:	a1 38 51 80 00       	mov    0x805138,%eax
  803499:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  80349c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8034a1:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  8034a4:	a1 38 51 80 00       	mov    0x805138,%eax
  8034a9:	85 c0                	test   %eax,%eax
  8034ab:	74 14                	je     8034c1 <insert_sorted_with_merge_freeList+0x33>
  8034ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b0:	8b 50 08             	mov    0x8(%eax),%edx
  8034b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034b6:	8b 40 08             	mov    0x8(%eax),%eax
  8034b9:	39 c2                	cmp    %eax,%edx
  8034bb:	0f 87 9b 01 00 00    	ja     80365c <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  8034c1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034c5:	75 17                	jne    8034de <insert_sorted_with_merge_freeList+0x50>
  8034c7:	83 ec 04             	sub    $0x4,%esp
  8034ca:	68 90 47 80 00       	push   $0x804790
  8034cf:	68 38 01 00 00       	push   $0x138
  8034d4:	68 b3 47 80 00       	push   $0x8047b3
  8034d9:	e8 23 d4 ff ff       	call   800901 <_panic>
  8034de:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8034e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e7:	89 10                	mov    %edx,(%eax)
  8034e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ec:	8b 00                	mov    (%eax),%eax
  8034ee:	85 c0                	test   %eax,%eax
  8034f0:	74 0d                	je     8034ff <insert_sorted_with_merge_freeList+0x71>
  8034f2:	a1 38 51 80 00       	mov    0x805138,%eax
  8034f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8034fa:	89 50 04             	mov    %edx,0x4(%eax)
  8034fd:	eb 08                	jmp    803507 <insert_sorted_with_merge_freeList+0x79>
  8034ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803502:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803507:	8b 45 08             	mov    0x8(%ebp),%eax
  80350a:	a3 38 51 80 00       	mov    %eax,0x805138
  80350f:	8b 45 08             	mov    0x8(%ebp),%eax
  803512:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803519:	a1 44 51 80 00       	mov    0x805144,%eax
  80351e:	40                   	inc    %eax
  80351f:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803524:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803528:	0f 84 a8 06 00 00    	je     803bd6 <insert_sorted_with_merge_freeList+0x748>
  80352e:	8b 45 08             	mov    0x8(%ebp),%eax
  803531:	8b 50 08             	mov    0x8(%eax),%edx
  803534:	8b 45 08             	mov    0x8(%ebp),%eax
  803537:	8b 40 0c             	mov    0xc(%eax),%eax
  80353a:	01 c2                	add    %eax,%edx
  80353c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80353f:	8b 40 08             	mov    0x8(%eax),%eax
  803542:	39 c2                	cmp    %eax,%edx
  803544:	0f 85 8c 06 00 00    	jne    803bd6 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  80354a:	8b 45 08             	mov    0x8(%ebp),%eax
  80354d:	8b 50 0c             	mov    0xc(%eax),%edx
  803550:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803553:	8b 40 0c             	mov    0xc(%eax),%eax
  803556:	01 c2                	add    %eax,%edx
  803558:	8b 45 08             	mov    0x8(%ebp),%eax
  80355b:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  80355e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803562:	75 17                	jne    80357b <insert_sorted_with_merge_freeList+0xed>
  803564:	83 ec 04             	sub    $0x4,%esp
  803567:	68 5c 48 80 00       	push   $0x80485c
  80356c:	68 3c 01 00 00       	push   $0x13c
  803571:	68 b3 47 80 00       	push   $0x8047b3
  803576:	e8 86 d3 ff ff       	call   800901 <_panic>
  80357b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80357e:	8b 00                	mov    (%eax),%eax
  803580:	85 c0                	test   %eax,%eax
  803582:	74 10                	je     803594 <insert_sorted_with_merge_freeList+0x106>
  803584:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803587:	8b 00                	mov    (%eax),%eax
  803589:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80358c:	8b 52 04             	mov    0x4(%edx),%edx
  80358f:	89 50 04             	mov    %edx,0x4(%eax)
  803592:	eb 0b                	jmp    80359f <insert_sorted_with_merge_freeList+0x111>
  803594:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803597:	8b 40 04             	mov    0x4(%eax),%eax
  80359a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80359f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035a2:	8b 40 04             	mov    0x4(%eax),%eax
  8035a5:	85 c0                	test   %eax,%eax
  8035a7:	74 0f                	je     8035b8 <insert_sorted_with_merge_freeList+0x12a>
  8035a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035ac:	8b 40 04             	mov    0x4(%eax),%eax
  8035af:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035b2:	8b 12                	mov    (%edx),%edx
  8035b4:	89 10                	mov    %edx,(%eax)
  8035b6:	eb 0a                	jmp    8035c2 <insert_sorted_with_merge_freeList+0x134>
  8035b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035bb:	8b 00                	mov    (%eax),%eax
  8035bd:	a3 38 51 80 00       	mov    %eax,0x805138
  8035c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035ce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035d5:	a1 44 51 80 00       	mov    0x805144,%eax
  8035da:	48                   	dec    %eax
  8035db:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  8035e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035e3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  8035ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035ed:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  8035f4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8035f8:	75 17                	jne    803611 <insert_sorted_with_merge_freeList+0x183>
  8035fa:	83 ec 04             	sub    $0x4,%esp
  8035fd:	68 90 47 80 00       	push   $0x804790
  803602:	68 3f 01 00 00       	push   $0x13f
  803607:	68 b3 47 80 00       	push   $0x8047b3
  80360c:	e8 f0 d2 ff ff       	call   800901 <_panic>
  803611:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803617:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80361a:	89 10                	mov    %edx,(%eax)
  80361c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80361f:	8b 00                	mov    (%eax),%eax
  803621:	85 c0                	test   %eax,%eax
  803623:	74 0d                	je     803632 <insert_sorted_with_merge_freeList+0x1a4>
  803625:	a1 48 51 80 00       	mov    0x805148,%eax
  80362a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80362d:	89 50 04             	mov    %edx,0x4(%eax)
  803630:	eb 08                	jmp    80363a <insert_sorted_with_merge_freeList+0x1ac>
  803632:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803635:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80363a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80363d:	a3 48 51 80 00       	mov    %eax,0x805148
  803642:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803645:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80364c:	a1 54 51 80 00       	mov    0x805154,%eax
  803651:	40                   	inc    %eax
  803652:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803657:	e9 7a 05 00 00       	jmp    803bd6 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  80365c:	8b 45 08             	mov    0x8(%ebp),%eax
  80365f:	8b 50 08             	mov    0x8(%eax),%edx
  803662:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803665:	8b 40 08             	mov    0x8(%eax),%eax
  803668:	39 c2                	cmp    %eax,%edx
  80366a:	0f 82 14 01 00 00    	jb     803784 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803670:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803673:	8b 50 08             	mov    0x8(%eax),%edx
  803676:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803679:	8b 40 0c             	mov    0xc(%eax),%eax
  80367c:	01 c2                	add    %eax,%edx
  80367e:	8b 45 08             	mov    0x8(%ebp),%eax
  803681:	8b 40 08             	mov    0x8(%eax),%eax
  803684:	39 c2                	cmp    %eax,%edx
  803686:	0f 85 90 00 00 00    	jne    80371c <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  80368c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80368f:	8b 50 0c             	mov    0xc(%eax),%edx
  803692:	8b 45 08             	mov    0x8(%ebp),%eax
  803695:	8b 40 0c             	mov    0xc(%eax),%eax
  803698:	01 c2                	add    %eax,%edx
  80369a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80369d:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  8036a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8036aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ad:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8036b4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036b8:	75 17                	jne    8036d1 <insert_sorted_with_merge_freeList+0x243>
  8036ba:	83 ec 04             	sub    $0x4,%esp
  8036bd:	68 90 47 80 00       	push   $0x804790
  8036c2:	68 49 01 00 00       	push   $0x149
  8036c7:	68 b3 47 80 00       	push   $0x8047b3
  8036cc:	e8 30 d2 ff ff       	call   800901 <_panic>
  8036d1:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8036d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8036da:	89 10                	mov    %edx,(%eax)
  8036dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8036df:	8b 00                	mov    (%eax),%eax
  8036e1:	85 c0                	test   %eax,%eax
  8036e3:	74 0d                	je     8036f2 <insert_sorted_with_merge_freeList+0x264>
  8036e5:	a1 48 51 80 00       	mov    0x805148,%eax
  8036ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8036ed:	89 50 04             	mov    %edx,0x4(%eax)
  8036f0:	eb 08                	jmp    8036fa <insert_sorted_with_merge_freeList+0x26c>
  8036f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8036fd:	a3 48 51 80 00       	mov    %eax,0x805148
  803702:	8b 45 08             	mov    0x8(%ebp),%eax
  803705:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80370c:	a1 54 51 80 00       	mov    0x805154,%eax
  803711:	40                   	inc    %eax
  803712:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803717:	e9 bb 04 00 00       	jmp    803bd7 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  80371c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803720:	75 17                	jne    803739 <insert_sorted_with_merge_freeList+0x2ab>
  803722:	83 ec 04             	sub    $0x4,%esp
  803725:	68 04 48 80 00       	push   $0x804804
  80372a:	68 4c 01 00 00       	push   $0x14c
  80372f:	68 b3 47 80 00       	push   $0x8047b3
  803734:	e8 c8 d1 ff ff       	call   800901 <_panic>
  803739:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80373f:	8b 45 08             	mov    0x8(%ebp),%eax
  803742:	89 50 04             	mov    %edx,0x4(%eax)
  803745:	8b 45 08             	mov    0x8(%ebp),%eax
  803748:	8b 40 04             	mov    0x4(%eax),%eax
  80374b:	85 c0                	test   %eax,%eax
  80374d:	74 0c                	je     80375b <insert_sorted_with_merge_freeList+0x2cd>
  80374f:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803754:	8b 55 08             	mov    0x8(%ebp),%edx
  803757:	89 10                	mov    %edx,(%eax)
  803759:	eb 08                	jmp    803763 <insert_sorted_with_merge_freeList+0x2d5>
  80375b:	8b 45 08             	mov    0x8(%ebp),%eax
  80375e:	a3 38 51 80 00       	mov    %eax,0x805138
  803763:	8b 45 08             	mov    0x8(%ebp),%eax
  803766:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80376b:	8b 45 08             	mov    0x8(%ebp),%eax
  80376e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803774:	a1 44 51 80 00       	mov    0x805144,%eax
  803779:	40                   	inc    %eax
  80377a:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80377f:	e9 53 04 00 00       	jmp    803bd7 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803784:	a1 38 51 80 00       	mov    0x805138,%eax
  803789:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80378c:	e9 15 04 00 00       	jmp    803ba6 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803791:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803794:	8b 00                	mov    (%eax),%eax
  803796:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803799:	8b 45 08             	mov    0x8(%ebp),%eax
  80379c:	8b 50 08             	mov    0x8(%eax),%edx
  80379f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037a2:	8b 40 08             	mov    0x8(%eax),%eax
  8037a5:	39 c2                	cmp    %eax,%edx
  8037a7:	0f 86 f1 03 00 00    	jbe    803b9e <insert_sorted_with_merge_freeList+0x710>
  8037ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b0:	8b 50 08             	mov    0x8(%eax),%edx
  8037b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037b6:	8b 40 08             	mov    0x8(%eax),%eax
  8037b9:	39 c2                	cmp    %eax,%edx
  8037bb:	0f 83 dd 03 00 00    	jae    803b9e <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8037c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037c4:	8b 50 08             	mov    0x8(%eax),%edx
  8037c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8037cd:	01 c2                	add    %eax,%edx
  8037cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d2:	8b 40 08             	mov    0x8(%eax),%eax
  8037d5:	39 c2                	cmp    %eax,%edx
  8037d7:	0f 85 b9 01 00 00    	jne    803996 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8037dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e0:	8b 50 08             	mov    0x8(%eax),%edx
  8037e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e6:	8b 40 0c             	mov    0xc(%eax),%eax
  8037e9:	01 c2                	add    %eax,%edx
  8037eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037ee:	8b 40 08             	mov    0x8(%eax),%eax
  8037f1:	39 c2                	cmp    %eax,%edx
  8037f3:	0f 85 0d 01 00 00    	jne    803906 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8037f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037fc:	8b 50 0c             	mov    0xc(%eax),%edx
  8037ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803802:	8b 40 0c             	mov    0xc(%eax),%eax
  803805:	01 c2                	add    %eax,%edx
  803807:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80380a:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80380d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803811:	75 17                	jne    80382a <insert_sorted_with_merge_freeList+0x39c>
  803813:	83 ec 04             	sub    $0x4,%esp
  803816:	68 5c 48 80 00       	push   $0x80485c
  80381b:	68 5c 01 00 00       	push   $0x15c
  803820:	68 b3 47 80 00       	push   $0x8047b3
  803825:	e8 d7 d0 ff ff       	call   800901 <_panic>
  80382a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80382d:	8b 00                	mov    (%eax),%eax
  80382f:	85 c0                	test   %eax,%eax
  803831:	74 10                	je     803843 <insert_sorted_with_merge_freeList+0x3b5>
  803833:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803836:	8b 00                	mov    (%eax),%eax
  803838:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80383b:	8b 52 04             	mov    0x4(%edx),%edx
  80383e:	89 50 04             	mov    %edx,0x4(%eax)
  803841:	eb 0b                	jmp    80384e <insert_sorted_with_merge_freeList+0x3c0>
  803843:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803846:	8b 40 04             	mov    0x4(%eax),%eax
  803849:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80384e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803851:	8b 40 04             	mov    0x4(%eax),%eax
  803854:	85 c0                	test   %eax,%eax
  803856:	74 0f                	je     803867 <insert_sorted_with_merge_freeList+0x3d9>
  803858:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80385b:	8b 40 04             	mov    0x4(%eax),%eax
  80385e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803861:	8b 12                	mov    (%edx),%edx
  803863:	89 10                	mov    %edx,(%eax)
  803865:	eb 0a                	jmp    803871 <insert_sorted_with_merge_freeList+0x3e3>
  803867:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80386a:	8b 00                	mov    (%eax),%eax
  80386c:	a3 38 51 80 00       	mov    %eax,0x805138
  803871:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803874:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80387a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80387d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803884:	a1 44 51 80 00       	mov    0x805144,%eax
  803889:	48                   	dec    %eax
  80388a:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  80388f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803892:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803899:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80389c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8038a3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8038a7:	75 17                	jne    8038c0 <insert_sorted_with_merge_freeList+0x432>
  8038a9:	83 ec 04             	sub    $0x4,%esp
  8038ac:	68 90 47 80 00       	push   $0x804790
  8038b1:	68 5f 01 00 00       	push   $0x15f
  8038b6:	68 b3 47 80 00       	push   $0x8047b3
  8038bb:	e8 41 d0 ff ff       	call   800901 <_panic>
  8038c0:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8038c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038c9:	89 10                	mov    %edx,(%eax)
  8038cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038ce:	8b 00                	mov    (%eax),%eax
  8038d0:	85 c0                	test   %eax,%eax
  8038d2:	74 0d                	je     8038e1 <insert_sorted_with_merge_freeList+0x453>
  8038d4:	a1 48 51 80 00       	mov    0x805148,%eax
  8038d9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038dc:	89 50 04             	mov    %edx,0x4(%eax)
  8038df:	eb 08                	jmp    8038e9 <insert_sorted_with_merge_freeList+0x45b>
  8038e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038e4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8038e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038ec:	a3 48 51 80 00       	mov    %eax,0x805148
  8038f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038f4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038fb:	a1 54 51 80 00       	mov    0x805154,%eax
  803900:	40                   	inc    %eax
  803901:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803906:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803909:	8b 50 0c             	mov    0xc(%eax),%edx
  80390c:	8b 45 08             	mov    0x8(%ebp),%eax
  80390f:	8b 40 0c             	mov    0xc(%eax),%eax
  803912:	01 c2                	add    %eax,%edx
  803914:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803917:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80391a:	8b 45 08             	mov    0x8(%ebp),%eax
  80391d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803924:	8b 45 08             	mov    0x8(%ebp),%eax
  803927:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80392e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803932:	75 17                	jne    80394b <insert_sorted_with_merge_freeList+0x4bd>
  803934:	83 ec 04             	sub    $0x4,%esp
  803937:	68 90 47 80 00       	push   $0x804790
  80393c:	68 64 01 00 00       	push   $0x164
  803941:	68 b3 47 80 00       	push   $0x8047b3
  803946:	e8 b6 cf ff ff       	call   800901 <_panic>
  80394b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803951:	8b 45 08             	mov    0x8(%ebp),%eax
  803954:	89 10                	mov    %edx,(%eax)
  803956:	8b 45 08             	mov    0x8(%ebp),%eax
  803959:	8b 00                	mov    (%eax),%eax
  80395b:	85 c0                	test   %eax,%eax
  80395d:	74 0d                	je     80396c <insert_sorted_with_merge_freeList+0x4de>
  80395f:	a1 48 51 80 00       	mov    0x805148,%eax
  803964:	8b 55 08             	mov    0x8(%ebp),%edx
  803967:	89 50 04             	mov    %edx,0x4(%eax)
  80396a:	eb 08                	jmp    803974 <insert_sorted_with_merge_freeList+0x4e6>
  80396c:	8b 45 08             	mov    0x8(%ebp),%eax
  80396f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803974:	8b 45 08             	mov    0x8(%ebp),%eax
  803977:	a3 48 51 80 00       	mov    %eax,0x805148
  80397c:	8b 45 08             	mov    0x8(%ebp),%eax
  80397f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803986:	a1 54 51 80 00       	mov    0x805154,%eax
  80398b:	40                   	inc    %eax
  80398c:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803991:	e9 41 02 00 00       	jmp    803bd7 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803996:	8b 45 08             	mov    0x8(%ebp),%eax
  803999:	8b 50 08             	mov    0x8(%eax),%edx
  80399c:	8b 45 08             	mov    0x8(%ebp),%eax
  80399f:	8b 40 0c             	mov    0xc(%eax),%eax
  8039a2:	01 c2                	add    %eax,%edx
  8039a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039a7:	8b 40 08             	mov    0x8(%eax),%eax
  8039aa:	39 c2                	cmp    %eax,%edx
  8039ac:	0f 85 7c 01 00 00    	jne    803b2e <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8039b2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8039b6:	74 06                	je     8039be <insert_sorted_with_merge_freeList+0x530>
  8039b8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8039bc:	75 17                	jne    8039d5 <insert_sorted_with_merge_freeList+0x547>
  8039be:	83 ec 04             	sub    $0x4,%esp
  8039c1:	68 cc 47 80 00       	push   $0x8047cc
  8039c6:	68 69 01 00 00       	push   $0x169
  8039cb:	68 b3 47 80 00       	push   $0x8047b3
  8039d0:	e8 2c cf ff ff       	call   800901 <_panic>
  8039d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039d8:	8b 50 04             	mov    0x4(%eax),%edx
  8039db:	8b 45 08             	mov    0x8(%ebp),%eax
  8039de:	89 50 04             	mov    %edx,0x4(%eax)
  8039e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8039e4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039e7:	89 10                	mov    %edx,(%eax)
  8039e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039ec:	8b 40 04             	mov    0x4(%eax),%eax
  8039ef:	85 c0                	test   %eax,%eax
  8039f1:	74 0d                	je     803a00 <insert_sorted_with_merge_freeList+0x572>
  8039f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039f6:	8b 40 04             	mov    0x4(%eax),%eax
  8039f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8039fc:	89 10                	mov    %edx,(%eax)
  8039fe:	eb 08                	jmp    803a08 <insert_sorted_with_merge_freeList+0x57a>
  803a00:	8b 45 08             	mov    0x8(%ebp),%eax
  803a03:	a3 38 51 80 00       	mov    %eax,0x805138
  803a08:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a0b:	8b 55 08             	mov    0x8(%ebp),%edx
  803a0e:	89 50 04             	mov    %edx,0x4(%eax)
  803a11:	a1 44 51 80 00       	mov    0x805144,%eax
  803a16:	40                   	inc    %eax
  803a17:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  803a1f:	8b 50 0c             	mov    0xc(%eax),%edx
  803a22:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a25:	8b 40 0c             	mov    0xc(%eax),%eax
  803a28:	01 c2                	add    %eax,%edx
  803a2a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a2d:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803a30:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803a34:	75 17                	jne    803a4d <insert_sorted_with_merge_freeList+0x5bf>
  803a36:	83 ec 04             	sub    $0x4,%esp
  803a39:	68 5c 48 80 00       	push   $0x80485c
  803a3e:	68 6b 01 00 00       	push   $0x16b
  803a43:	68 b3 47 80 00       	push   $0x8047b3
  803a48:	e8 b4 ce ff ff       	call   800901 <_panic>
  803a4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a50:	8b 00                	mov    (%eax),%eax
  803a52:	85 c0                	test   %eax,%eax
  803a54:	74 10                	je     803a66 <insert_sorted_with_merge_freeList+0x5d8>
  803a56:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a59:	8b 00                	mov    (%eax),%eax
  803a5b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a5e:	8b 52 04             	mov    0x4(%edx),%edx
  803a61:	89 50 04             	mov    %edx,0x4(%eax)
  803a64:	eb 0b                	jmp    803a71 <insert_sorted_with_merge_freeList+0x5e3>
  803a66:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a69:	8b 40 04             	mov    0x4(%eax),%eax
  803a6c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803a71:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a74:	8b 40 04             	mov    0x4(%eax),%eax
  803a77:	85 c0                	test   %eax,%eax
  803a79:	74 0f                	je     803a8a <insert_sorted_with_merge_freeList+0x5fc>
  803a7b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a7e:	8b 40 04             	mov    0x4(%eax),%eax
  803a81:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a84:	8b 12                	mov    (%edx),%edx
  803a86:	89 10                	mov    %edx,(%eax)
  803a88:	eb 0a                	jmp    803a94 <insert_sorted_with_merge_freeList+0x606>
  803a8a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a8d:	8b 00                	mov    (%eax),%eax
  803a8f:	a3 38 51 80 00       	mov    %eax,0x805138
  803a94:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a97:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803aa0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803aa7:	a1 44 51 80 00       	mov    0x805144,%eax
  803aac:	48                   	dec    %eax
  803aad:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803ab2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ab5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803abc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803abf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803ac6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803aca:	75 17                	jne    803ae3 <insert_sorted_with_merge_freeList+0x655>
  803acc:	83 ec 04             	sub    $0x4,%esp
  803acf:	68 90 47 80 00       	push   $0x804790
  803ad4:	68 6e 01 00 00       	push   $0x16e
  803ad9:	68 b3 47 80 00       	push   $0x8047b3
  803ade:	e8 1e ce ff ff       	call   800901 <_panic>
  803ae3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803ae9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803aec:	89 10                	mov    %edx,(%eax)
  803aee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803af1:	8b 00                	mov    (%eax),%eax
  803af3:	85 c0                	test   %eax,%eax
  803af5:	74 0d                	je     803b04 <insert_sorted_with_merge_freeList+0x676>
  803af7:	a1 48 51 80 00       	mov    0x805148,%eax
  803afc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803aff:	89 50 04             	mov    %edx,0x4(%eax)
  803b02:	eb 08                	jmp    803b0c <insert_sorted_with_merge_freeList+0x67e>
  803b04:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b07:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803b0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b0f:	a3 48 51 80 00       	mov    %eax,0x805148
  803b14:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b17:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b1e:	a1 54 51 80 00       	mov    0x805154,%eax
  803b23:	40                   	inc    %eax
  803b24:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803b29:	e9 a9 00 00 00       	jmp    803bd7 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803b2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b32:	74 06                	je     803b3a <insert_sorted_with_merge_freeList+0x6ac>
  803b34:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b38:	75 17                	jne    803b51 <insert_sorted_with_merge_freeList+0x6c3>
  803b3a:	83 ec 04             	sub    $0x4,%esp
  803b3d:	68 28 48 80 00       	push   $0x804828
  803b42:	68 73 01 00 00       	push   $0x173
  803b47:	68 b3 47 80 00       	push   $0x8047b3
  803b4c:	e8 b0 cd ff ff       	call   800901 <_panic>
  803b51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b54:	8b 10                	mov    (%eax),%edx
  803b56:	8b 45 08             	mov    0x8(%ebp),%eax
  803b59:	89 10                	mov    %edx,(%eax)
  803b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  803b5e:	8b 00                	mov    (%eax),%eax
  803b60:	85 c0                	test   %eax,%eax
  803b62:	74 0b                	je     803b6f <insert_sorted_with_merge_freeList+0x6e1>
  803b64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b67:	8b 00                	mov    (%eax),%eax
  803b69:	8b 55 08             	mov    0x8(%ebp),%edx
  803b6c:	89 50 04             	mov    %edx,0x4(%eax)
  803b6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b72:	8b 55 08             	mov    0x8(%ebp),%edx
  803b75:	89 10                	mov    %edx,(%eax)
  803b77:	8b 45 08             	mov    0x8(%ebp),%eax
  803b7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b7d:	89 50 04             	mov    %edx,0x4(%eax)
  803b80:	8b 45 08             	mov    0x8(%ebp),%eax
  803b83:	8b 00                	mov    (%eax),%eax
  803b85:	85 c0                	test   %eax,%eax
  803b87:	75 08                	jne    803b91 <insert_sorted_with_merge_freeList+0x703>
  803b89:	8b 45 08             	mov    0x8(%ebp),%eax
  803b8c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803b91:	a1 44 51 80 00       	mov    0x805144,%eax
  803b96:	40                   	inc    %eax
  803b97:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803b9c:	eb 39                	jmp    803bd7 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803b9e:	a1 40 51 80 00       	mov    0x805140,%eax
  803ba3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ba6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803baa:	74 07                	je     803bb3 <insert_sorted_with_merge_freeList+0x725>
  803bac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803baf:	8b 00                	mov    (%eax),%eax
  803bb1:	eb 05                	jmp    803bb8 <insert_sorted_with_merge_freeList+0x72a>
  803bb3:	b8 00 00 00 00       	mov    $0x0,%eax
  803bb8:	a3 40 51 80 00       	mov    %eax,0x805140
  803bbd:	a1 40 51 80 00       	mov    0x805140,%eax
  803bc2:	85 c0                	test   %eax,%eax
  803bc4:	0f 85 c7 fb ff ff    	jne    803791 <insert_sorted_with_merge_freeList+0x303>
  803bca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803bce:	0f 85 bd fb ff ff    	jne    803791 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803bd4:	eb 01                	jmp    803bd7 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803bd6:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803bd7:	90                   	nop
  803bd8:	c9                   	leave  
  803bd9:	c3                   	ret    
  803bda:	66 90                	xchg   %ax,%ax

00803bdc <__udivdi3>:
  803bdc:	55                   	push   %ebp
  803bdd:	57                   	push   %edi
  803bde:	56                   	push   %esi
  803bdf:	53                   	push   %ebx
  803be0:	83 ec 1c             	sub    $0x1c,%esp
  803be3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803be7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803beb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803bef:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803bf3:	89 ca                	mov    %ecx,%edx
  803bf5:	89 f8                	mov    %edi,%eax
  803bf7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803bfb:	85 f6                	test   %esi,%esi
  803bfd:	75 2d                	jne    803c2c <__udivdi3+0x50>
  803bff:	39 cf                	cmp    %ecx,%edi
  803c01:	77 65                	ja     803c68 <__udivdi3+0x8c>
  803c03:	89 fd                	mov    %edi,%ebp
  803c05:	85 ff                	test   %edi,%edi
  803c07:	75 0b                	jne    803c14 <__udivdi3+0x38>
  803c09:	b8 01 00 00 00       	mov    $0x1,%eax
  803c0e:	31 d2                	xor    %edx,%edx
  803c10:	f7 f7                	div    %edi
  803c12:	89 c5                	mov    %eax,%ebp
  803c14:	31 d2                	xor    %edx,%edx
  803c16:	89 c8                	mov    %ecx,%eax
  803c18:	f7 f5                	div    %ebp
  803c1a:	89 c1                	mov    %eax,%ecx
  803c1c:	89 d8                	mov    %ebx,%eax
  803c1e:	f7 f5                	div    %ebp
  803c20:	89 cf                	mov    %ecx,%edi
  803c22:	89 fa                	mov    %edi,%edx
  803c24:	83 c4 1c             	add    $0x1c,%esp
  803c27:	5b                   	pop    %ebx
  803c28:	5e                   	pop    %esi
  803c29:	5f                   	pop    %edi
  803c2a:	5d                   	pop    %ebp
  803c2b:	c3                   	ret    
  803c2c:	39 ce                	cmp    %ecx,%esi
  803c2e:	77 28                	ja     803c58 <__udivdi3+0x7c>
  803c30:	0f bd fe             	bsr    %esi,%edi
  803c33:	83 f7 1f             	xor    $0x1f,%edi
  803c36:	75 40                	jne    803c78 <__udivdi3+0x9c>
  803c38:	39 ce                	cmp    %ecx,%esi
  803c3a:	72 0a                	jb     803c46 <__udivdi3+0x6a>
  803c3c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803c40:	0f 87 9e 00 00 00    	ja     803ce4 <__udivdi3+0x108>
  803c46:	b8 01 00 00 00       	mov    $0x1,%eax
  803c4b:	89 fa                	mov    %edi,%edx
  803c4d:	83 c4 1c             	add    $0x1c,%esp
  803c50:	5b                   	pop    %ebx
  803c51:	5e                   	pop    %esi
  803c52:	5f                   	pop    %edi
  803c53:	5d                   	pop    %ebp
  803c54:	c3                   	ret    
  803c55:	8d 76 00             	lea    0x0(%esi),%esi
  803c58:	31 ff                	xor    %edi,%edi
  803c5a:	31 c0                	xor    %eax,%eax
  803c5c:	89 fa                	mov    %edi,%edx
  803c5e:	83 c4 1c             	add    $0x1c,%esp
  803c61:	5b                   	pop    %ebx
  803c62:	5e                   	pop    %esi
  803c63:	5f                   	pop    %edi
  803c64:	5d                   	pop    %ebp
  803c65:	c3                   	ret    
  803c66:	66 90                	xchg   %ax,%ax
  803c68:	89 d8                	mov    %ebx,%eax
  803c6a:	f7 f7                	div    %edi
  803c6c:	31 ff                	xor    %edi,%edi
  803c6e:	89 fa                	mov    %edi,%edx
  803c70:	83 c4 1c             	add    $0x1c,%esp
  803c73:	5b                   	pop    %ebx
  803c74:	5e                   	pop    %esi
  803c75:	5f                   	pop    %edi
  803c76:	5d                   	pop    %ebp
  803c77:	c3                   	ret    
  803c78:	bd 20 00 00 00       	mov    $0x20,%ebp
  803c7d:	89 eb                	mov    %ebp,%ebx
  803c7f:	29 fb                	sub    %edi,%ebx
  803c81:	89 f9                	mov    %edi,%ecx
  803c83:	d3 e6                	shl    %cl,%esi
  803c85:	89 c5                	mov    %eax,%ebp
  803c87:	88 d9                	mov    %bl,%cl
  803c89:	d3 ed                	shr    %cl,%ebp
  803c8b:	89 e9                	mov    %ebp,%ecx
  803c8d:	09 f1                	or     %esi,%ecx
  803c8f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803c93:	89 f9                	mov    %edi,%ecx
  803c95:	d3 e0                	shl    %cl,%eax
  803c97:	89 c5                	mov    %eax,%ebp
  803c99:	89 d6                	mov    %edx,%esi
  803c9b:	88 d9                	mov    %bl,%cl
  803c9d:	d3 ee                	shr    %cl,%esi
  803c9f:	89 f9                	mov    %edi,%ecx
  803ca1:	d3 e2                	shl    %cl,%edx
  803ca3:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ca7:	88 d9                	mov    %bl,%cl
  803ca9:	d3 e8                	shr    %cl,%eax
  803cab:	09 c2                	or     %eax,%edx
  803cad:	89 d0                	mov    %edx,%eax
  803caf:	89 f2                	mov    %esi,%edx
  803cb1:	f7 74 24 0c          	divl   0xc(%esp)
  803cb5:	89 d6                	mov    %edx,%esi
  803cb7:	89 c3                	mov    %eax,%ebx
  803cb9:	f7 e5                	mul    %ebp
  803cbb:	39 d6                	cmp    %edx,%esi
  803cbd:	72 19                	jb     803cd8 <__udivdi3+0xfc>
  803cbf:	74 0b                	je     803ccc <__udivdi3+0xf0>
  803cc1:	89 d8                	mov    %ebx,%eax
  803cc3:	31 ff                	xor    %edi,%edi
  803cc5:	e9 58 ff ff ff       	jmp    803c22 <__udivdi3+0x46>
  803cca:	66 90                	xchg   %ax,%ax
  803ccc:	8b 54 24 08          	mov    0x8(%esp),%edx
  803cd0:	89 f9                	mov    %edi,%ecx
  803cd2:	d3 e2                	shl    %cl,%edx
  803cd4:	39 c2                	cmp    %eax,%edx
  803cd6:	73 e9                	jae    803cc1 <__udivdi3+0xe5>
  803cd8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803cdb:	31 ff                	xor    %edi,%edi
  803cdd:	e9 40 ff ff ff       	jmp    803c22 <__udivdi3+0x46>
  803ce2:	66 90                	xchg   %ax,%ax
  803ce4:	31 c0                	xor    %eax,%eax
  803ce6:	e9 37 ff ff ff       	jmp    803c22 <__udivdi3+0x46>
  803ceb:	90                   	nop

00803cec <__umoddi3>:
  803cec:	55                   	push   %ebp
  803ced:	57                   	push   %edi
  803cee:	56                   	push   %esi
  803cef:	53                   	push   %ebx
  803cf0:	83 ec 1c             	sub    $0x1c,%esp
  803cf3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803cf7:	8b 74 24 34          	mov    0x34(%esp),%esi
  803cfb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803cff:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803d03:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803d07:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803d0b:	89 f3                	mov    %esi,%ebx
  803d0d:	89 fa                	mov    %edi,%edx
  803d0f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d13:	89 34 24             	mov    %esi,(%esp)
  803d16:	85 c0                	test   %eax,%eax
  803d18:	75 1a                	jne    803d34 <__umoddi3+0x48>
  803d1a:	39 f7                	cmp    %esi,%edi
  803d1c:	0f 86 a2 00 00 00    	jbe    803dc4 <__umoddi3+0xd8>
  803d22:	89 c8                	mov    %ecx,%eax
  803d24:	89 f2                	mov    %esi,%edx
  803d26:	f7 f7                	div    %edi
  803d28:	89 d0                	mov    %edx,%eax
  803d2a:	31 d2                	xor    %edx,%edx
  803d2c:	83 c4 1c             	add    $0x1c,%esp
  803d2f:	5b                   	pop    %ebx
  803d30:	5e                   	pop    %esi
  803d31:	5f                   	pop    %edi
  803d32:	5d                   	pop    %ebp
  803d33:	c3                   	ret    
  803d34:	39 f0                	cmp    %esi,%eax
  803d36:	0f 87 ac 00 00 00    	ja     803de8 <__umoddi3+0xfc>
  803d3c:	0f bd e8             	bsr    %eax,%ebp
  803d3f:	83 f5 1f             	xor    $0x1f,%ebp
  803d42:	0f 84 ac 00 00 00    	je     803df4 <__umoddi3+0x108>
  803d48:	bf 20 00 00 00       	mov    $0x20,%edi
  803d4d:	29 ef                	sub    %ebp,%edi
  803d4f:	89 fe                	mov    %edi,%esi
  803d51:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803d55:	89 e9                	mov    %ebp,%ecx
  803d57:	d3 e0                	shl    %cl,%eax
  803d59:	89 d7                	mov    %edx,%edi
  803d5b:	89 f1                	mov    %esi,%ecx
  803d5d:	d3 ef                	shr    %cl,%edi
  803d5f:	09 c7                	or     %eax,%edi
  803d61:	89 e9                	mov    %ebp,%ecx
  803d63:	d3 e2                	shl    %cl,%edx
  803d65:	89 14 24             	mov    %edx,(%esp)
  803d68:	89 d8                	mov    %ebx,%eax
  803d6a:	d3 e0                	shl    %cl,%eax
  803d6c:	89 c2                	mov    %eax,%edx
  803d6e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d72:	d3 e0                	shl    %cl,%eax
  803d74:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d78:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d7c:	89 f1                	mov    %esi,%ecx
  803d7e:	d3 e8                	shr    %cl,%eax
  803d80:	09 d0                	or     %edx,%eax
  803d82:	d3 eb                	shr    %cl,%ebx
  803d84:	89 da                	mov    %ebx,%edx
  803d86:	f7 f7                	div    %edi
  803d88:	89 d3                	mov    %edx,%ebx
  803d8a:	f7 24 24             	mull   (%esp)
  803d8d:	89 c6                	mov    %eax,%esi
  803d8f:	89 d1                	mov    %edx,%ecx
  803d91:	39 d3                	cmp    %edx,%ebx
  803d93:	0f 82 87 00 00 00    	jb     803e20 <__umoddi3+0x134>
  803d99:	0f 84 91 00 00 00    	je     803e30 <__umoddi3+0x144>
  803d9f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803da3:	29 f2                	sub    %esi,%edx
  803da5:	19 cb                	sbb    %ecx,%ebx
  803da7:	89 d8                	mov    %ebx,%eax
  803da9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803dad:	d3 e0                	shl    %cl,%eax
  803daf:	89 e9                	mov    %ebp,%ecx
  803db1:	d3 ea                	shr    %cl,%edx
  803db3:	09 d0                	or     %edx,%eax
  803db5:	89 e9                	mov    %ebp,%ecx
  803db7:	d3 eb                	shr    %cl,%ebx
  803db9:	89 da                	mov    %ebx,%edx
  803dbb:	83 c4 1c             	add    $0x1c,%esp
  803dbe:	5b                   	pop    %ebx
  803dbf:	5e                   	pop    %esi
  803dc0:	5f                   	pop    %edi
  803dc1:	5d                   	pop    %ebp
  803dc2:	c3                   	ret    
  803dc3:	90                   	nop
  803dc4:	89 fd                	mov    %edi,%ebp
  803dc6:	85 ff                	test   %edi,%edi
  803dc8:	75 0b                	jne    803dd5 <__umoddi3+0xe9>
  803dca:	b8 01 00 00 00       	mov    $0x1,%eax
  803dcf:	31 d2                	xor    %edx,%edx
  803dd1:	f7 f7                	div    %edi
  803dd3:	89 c5                	mov    %eax,%ebp
  803dd5:	89 f0                	mov    %esi,%eax
  803dd7:	31 d2                	xor    %edx,%edx
  803dd9:	f7 f5                	div    %ebp
  803ddb:	89 c8                	mov    %ecx,%eax
  803ddd:	f7 f5                	div    %ebp
  803ddf:	89 d0                	mov    %edx,%eax
  803de1:	e9 44 ff ff ff       	jmp    803d2a <__umoddi3+0x3e>
  803de6:	66 90                	xchg   %ax,%ax
  803de8:	89 c8                	mov    %ecx,%eax
  803dea:	89 f2                	mov    %esi,%edx
  803dec:	83 c4 1c             	add    $0x1c,%esp
  803def:	5b                   	pop    %ebx
  803df0:	5e                   	pop    %esi
  803df1:	5f                   	pop    %edi
  803df2:	5d                   	pop    %ebp
  803df3:	c3                   	ret    
  803df4:	3b 04 24             	cmp    (%esp),%eax
  803df7:	72 06                	jb     803dff <__umoddi3+0x113>
  803df9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803dfd:	77 0f                	ja     803e0e <__umoddi3+0x122>
  803dff:	89 f2                	mov    %esi,%edx
  803e01:	29 f9                	sub    %edi,%ecx
  803e03:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803e07:	89 14 24             	mov    %edx,(%esp)
  803e0a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803e0e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803e12:	8b 14 24             	mov    (%esp),%edx
  803e15:	83 c4 1c             	add    $0x1c,%esp
  803e18:	5b                   	pop    %ebx
  803e19:	5e                   	pop    %esi
  803e1a:	5f                   	pop    %edi
  803e1b:	5d                   	pop    %ebp
  803e1c:	c3                   	ret    
  803e1d:	8d 76 00             	lea    0x0(%esi),%esi
  803e20:	2b 04 24             	sub    (%esp),%eax
  803e23:	19 fa                	sbb    %edi,%edx
  803e25:	89 d1                	mov    %edx,%ecx
  803e27:	89 c6                	mov    %eax,%esi
  803e29:	e9 71 ff ff ff       	jmp    803d9f <__umoddi3+0xb3>
  803e2e:	66 90                	xchg   %ax,%ax
  803e30:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803e34:	72 ea                	jb     803e20 <__umoddi3+0x134>
  803e36:	89 d9                	mov    %ebx,%ecx
  803e38:	e9 62 ff ff ff       	jmp    803d9f <__umoddi3+0xb3>
