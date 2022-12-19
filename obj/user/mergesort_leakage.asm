
obj/user/mergesort_leakage:     file format elf32-i386


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
  800031:	e8 65 07 00 00       	call   80079b <libmain>
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
  800041:	e8 dd 21 00 00       	call   802223 <sys_disable_interrupt>

		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 60 3f 80 00       	push   $0x803f60
  80004e:	e8 38 0b 00 00       	call   800b8b <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 62 3f 80 00       	push   $0x803f62
  80005e:	e8 28 0b 00 00       	call   800b8b <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 78 3f 80 00       	push   $0x803f78
  80006e:	e8 18 0b 00 00       	call   800b8b <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 62 3f 80 00       	push   $0x803f62
  80007e:	e8 08 0b 00 00       	call   800b8b <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 60 3f 80 00       	push   $0x803f60
  80008e:	e8 f8 0a 00 00       	call   800b8b <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 90 3f 80 00       	push   $0x803f90
  8000a5:	e8 63 11 00 00       	call   80120d <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 b3 16 00 00       	call   801773 <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 44 1c 00 00       	call   801d19 <malloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	68 b0 3f 80 00       	push   $0x803fb0
  8000e3:	e8 a3 0a 00 00       	call   800b8b <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 d2 3f 80 00       	push   $0x803fd2
  8000f3:	e8 93 0a 00 00       	call   800b8b <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 e0 3f 80 00       	push   $0x803fe0
  800103:	e8 83 0a 00 00       	call   800b8b <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 ef 3f 80 00       	push   $0x803fef
  800113:	e8 73 0a 00 00       	call   800b8b <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 ff 3f 80 00       	push   $0x803fff
  800123:	e8 63 0a 00 00       	call   800b8b <cprintf>
  800128:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80012b:	e8 13 06 00 00       	call   800743 <getchar>
  800130:	88 45 f7             	mov    %al,-0x9(%ebp)
			cputchar(Chose);
  800133:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	50                   	push   %eax
  80013b:	e8 bb 05 00 00       	call   8006fb <cputchar>
  800140:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	6a 0a                	push   $0xa
  800148:	e8 ae 05 00 00       	call   8006fb <cputchar>
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
  800162:	e8 d6 20 00 00       	call   80223d <sys_enable_interrupt>

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
  800183:	e8 e6 01 00 00       	call   80036e <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f0             	pushl  -0x10(%ebp)
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	e8 04 02 00 00       	call   80039f <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a9:	e8 26 02 00 00       	call   8003d4 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 13 02 00 00       	call   8003d4 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001c4:	83 ec 04             	sub    $0x4,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	6a 01                	push   $0x1
  8001cc:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cf:	e8 d2 02 00 00       	call   8004a6 <MSort>
  8001d4:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  8001d7:	e8 47 20 00 00       	call   802223 <sys_disable_interrupt>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	68 08 40 80 00       	push   $0x804008
  8001e4:	e8 a2 09 00 00       	call   800b8b <cprintf>
  8001e9:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001ec:	e8 4c 20 00 00       	call   80223d <sys_enable_interrupt>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001f1:	83 ec 08             	sub    $0x8,%esp
  8001f4:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001fa:	e8 c5 00 00 00       	call   8002c4 <CheckSorted>
  8001ff:	83 c4 10             	add    $0x10,%esp
  800202:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800205:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800209:	75 14                	jne    80021f <_main+0x1e7>
  80020b:	83 ec 04             	sub    $0x4,%esp
  80020e:	68 3c 40 80 00       	push   $0x80403c
  800213:	6a 4a                	push   $0x4a
  800215:	68 5e 40 80 00       	push   $0x80405e
  80021a:	e8 b8 06 00 00       	call   8008d7 <_panic>
		else
		{
			sys_disable_interrupt();
  80021f:	e8 ff 1f 00 00       	call   802223 <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	68 78 40 80 00       	push   $0x804078
  80022c:	e8 5a 09 00 00       	call   800b8b <cprintf>
  800231:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	68 ac 40 80 00       	push   $0x8040ac
  80023c:	e8 4a 09 00 00       	call   800b8b <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 e0 40 80 00       	push   $0x8040e0
  80024c:	e8 3a 09 00 00       	call   800b8b <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800254:	e8 e4 1f 00 00       	call   80223d <sys_enable_interrupt>
		}

		//free(Elements) ;

		sys_disable_interrupt();
  800259:	e8 c5 1f 00 00       	call   802223 <sys_disable_interrupt>
			Chose = 0 ;
  80025e:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800262:	eb 42                	jmp    8002a6 <_main+0x26e>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800264:	83 ec 0c             	sub    $0xc,%esp
  800267:	68 12 41 80 00       	push   $0x804112
  80026c:	e8 1a 09 00 00       	call   800b8b <cprintf>
  800271:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800274:	e8 ca 04 00 00       	call   800743 <getchar>
  800279:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  80027c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800280:	83 ec 0c             	sub    $0xc,%esp
  800283:	50                   	push   %eax
  800284:	e8 72 04 00 00       	call   8006fb <cputchar>
  800289:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	6a 0a                	push   $0xa
  800291:	e8 65 04 00 00       	call   8006fb <cputchar>
  800296:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800299:	83 ec 0c             	sub    $0xc,%esp
  80029c:	6a 0a                	push   $0xa
  80029e:	e8 58 04 00 00       	call   8006fb <cputchar>
  8002a3:	83 c4 10             	add    $0x10,%esp

		//free(Elements) ;

		sys_disable_interrupt();
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002a6:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002aa:	74 06                	je     8002b2 <_main+0x27a>
  8002ac:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002b0:	75 b2                	jne    800264 <_main+0x22c>
				Chose = getchar() ;
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		sys_enable_interrupt();
  8002b2:	e8 86 1f 00 00       	call   80223d <sys_enable_interrupt>

	} while (Chose == 'y');
  8002b7:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002bb:	0f 84 80 fd ff ff    	je     800041 <_main+0x9>

}
  8002c1:	90                   	nop
  8002c2:	c9                   	leave  
  8002c3:	c3                   	ret    

008002c4 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8002c4:	55                   	push   %ebp
  8002c5:	89 e5                	mov    %esp,%ebp
  8002c7:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8002ca:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8002d1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8002d8:	eb 33                	jmp    80030d <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8002da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e7:	01 d0                	add    %edx,%eax
  8002e9:	8b 10                	mov    (%eax),%edx
  8002eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002ee:	40                   	inc    %eax
  8002ef:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f9:	01 c8                	add    %ecx,%eax
  8002fb:	8b 00                	mov    (%eax),%eax
  8002fd:	39 c2                	cmp    %eax,%edx
  8002ff:	7e 09                	jle    80030a <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800301:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800308:	eb 0c                	jmp    800316 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80030a:	ff 45 f8             	incl   -0x8(%ebp)
  80030d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800310:	48                   	dec    %eax
  800311:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800314:	7f c4                	jg     8002da <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800316:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800319:	c9                   	leave  
  80031a:	c3                   	ret    

0080031b <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80031b:	55                   	push   %ebp
  80031c:	89 e5                	mov    %esp,%ebp
  80031e:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800321:	8b 45 0c             	mov    0xc(%ebp),%eax
  800324:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80032b:	8b 45 08             	mov    0x8(%ebp),%eax
  80032e:	01 d0                	add    %edx,%eax
  800330:	8b 00                	mov    (%eax),%eax
  800332:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800335:	8b 45 0c             	mov    0xc(%ebp),%eax
  800338:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80033f:	8b 45 08             	mov    0x8(%ebp),%eax
  800342:	01 c2                	add    %eax,%edx
  800344:	8b 45 10             	mov    0x10(%ebp),%eax
  800347:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80034e:	8b 45 08             	mov    0x8(%ebp),%eax
  800351:	01 c8                	add    %ecx,%eax
  800353:	8b 00                	mov    (%eax),%eax
  800355:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800357:	8b 45 10             	mov    0x10(%ebp),%eax
  80035a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800361:	8b 45 08             	mov    0x8(%ebp),%eax
  800364:	01 c2                	add    %eax,%edx
  800366:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800369:	89 02                	mov    %eax,(%edx)
}
  80036b:	90                   	nop
  80036c:	c9                   	leave  
  80036d:	c3                   	ret    

0080036e <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80036e:	55                   	push   %ebp
  80036f:	89 e5                	mov    %esp,%ebp
  800371:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800374:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80037b:	eb 17                	jmp    800394 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80037d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800380:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800387:	8b 45 08             	mov    0x8(%ebp),%eax
  80038a:	01 c2                	add    %eax,%edx
  80038c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80038f:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800391:	ff 45 fc             	incl   -0x4(%ebp)
  800394:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800397:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80039a:	7c e1                	jl     80037d <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  80039c:	90                   	nop
  80039d:	c9                   	leave  
  80039e:	c3                   	ret    

0080039f <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  80039f:	55                   	push   %ebp
  8003a0:	89 e5                	mov    %esp,%ebp
  8003a2:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003ac:	eb 1b                	jmp    8003c9 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8003ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bb:	01 c2                	add    %eax,%edx
  8003bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c0:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8003c3:	48                   	dec    %eax
  8003c4:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003c6:	ff 45 fc             	incl   -0x4(%ebp)
  8003c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003cc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003cf:	7c dd                	jl     8003ae <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8003d1:	90                   	nop
  8003d2:	c9                   	leave  
  8003d3:	c3                   	ret    

008003d4 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8003d4:	55                   	push   %ebp
  8003d5:	89 e5                	mov    %esp,%ebp
  8003d7:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8003da:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003dd:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8003e2:	f7 e9                	imul   %ecx
  8003e4:	c1 f9 1f             	sar    $0x1f,%ecx
  8003e7:	89 d0                	mov    %edx,%eax
  8003e9:	29 c8                	sub    %ecx,%eax
  8003eb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8003ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003f5:	eb 1e                	jmp    800415 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  8003f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800401:	8b 45 08             	mov    0x8(%ebp),%eax
  800404:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800407:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80040a:	99                   	cltd   
  80040b:	f7 7d f8             	idivl  -0x8(%ebp)
  80040e:	89 d0                	mov    %edx,%eax
  800410:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800412:	ff 45 fc             	incl   -0x4(%ebp)
  800415:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800418:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80041b:	7c da                	jl     8003f7 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  80041d:	90                   	nop
  80041e:	c9                   	leave  
  80041f:	c3                   	ret    

00800420 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800420:	55                   	push   %ebp
  800421:	89 e5                	mov    %esp,%ebp
  800423:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800426:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80042d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800434:	eb 42                	jmp    800478 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800436:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800439:	99                   	cltd   
  80043a:	f7 7d f0             	idivl  -0x10(%ebp)
  80043d:	89 d0                	mov    %edx,%eax
  80043f:	85 c0                	test   %eax,%eax
  800441:	75 10                	jne    800453 <PrintElements+0x33>
			cprintf("\n");
  800443:	83 ec 0c             	sub    $0xc,%esp
  800446:	68 60 3f 80 00       	push   $0x803f60
  80044b:	e8 3b 07 00 00       	call   800b8b <cprintf>
  800450:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800456:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80045d:	8b 45 08             	mov    0x8(%ebp),%eax
  800460:	01 d0                	add    %edx,%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	83 ec 08             	sub    $0x8,%esp
  800467:	50                   	push   %eax
  800468:	68 30 41 80 00       	push   $0x804130
  80046d:	e8 19 07 00 00       	call   800b8b <cprintf>
  800472:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800475:	ff 45 f4             	incl   -0xc(%ebp)
  800478:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047b:	48                   	dec    %eax
  80047c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80047f:	7f b5                	jg     800436 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800484:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80048b:	8b 45 08             	mov    0x8(%ebp),%eax
  80048e:	01 d0                	add    %edx,%eax
  800490:	8b 00                	mov    (%eax),%eax
  800492:	83 ec 08             	sub    $0x8,%esp
  800495:	50                   	push   %eax
  800496:	68 35 41 80 00       	push   $0x804135
  80049b:	e8 eb 06 00 00       	call   800b8b <cprintf>
  8004a0:	83 c4 10             	add    $0x10,%esp

}
  8004a3:	90                   	nop
  8004a4:	c9                   	leave  
  8004a5:	c3                   	ret    

008004a6 <MSort>:


void MSort(int* A, int p, int r)
{
  8004a6:	55                   	push   %ebp
  8004a7:	89 e5                	mov    %esp,%ebp
  8004a9:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  8004ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004af:	3b 45 10             	cmp    0x10(%ebp),%eax
  8004b2:	7d 54                	jge    800508 <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  8004b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ba:	01 d0                	add    %edx,%eax
  8004bc:	89 c2                	mov    %eax,%edx
  8004be:	c1 ea 1f             	shr    $0x1f,%edx
  8004c1:	01 d0                	add    %edx,%eax
  8004c3:	d1 f8                	sar    %eax
  8004c5:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  8004c8:	83 ec 04             	sub    $0x4,%esp
  8004cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8004ce:	ff 75 0c             	pushl  0xc(%ebp)
  8004d1:	ff 75 08             	pushl  0x8(%ebp)
  8004d4:	e8 cd ff ff ff       	call   8004a6 <MSort>
  8004d9:	83 c4 10             	add    $0x10,%esp

	MSort(A, q + 1, r);
  8004dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004df:	40                   	inc    %eax
  8004e0:	83 ec 04             	sub    $0x4,%esp
  8004e3:	ff 75 10             	pushl  0x10(%ebp)
  8004e6:	50                   	push   %eax
  8004e7:	ff 75 08             	pushl  0x8(%ebp)
  8004ea:	e8 b7 ff ff ff       	call   8004a6 <MSort>
  8004ef:	83 c4 10             	add    $0x10,%esp

	Merge(A, p, q, r);
  8004f2:	ff 75 10             	pushl  0x10(%ebp)
  8004f5:	ff 75 f4             	pushl  -0xc(%ebp)
  8004f8:	ff 75 0c             	pushl  0xc(%ebp)
  8004fb:	ff 75 08             	pushl  0x8(%ebp)
  8004fe:	e8 08 00 00 00       	call   80050b <Merge>
  800503:	83 c4 10             	add    $0x10,%esp
  800506:	eb 01                	jmp    800509 <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  800508:	90                   	nop

	MSort(A, q + 1, r);

	Merge(A, p, q, r);

}
  800509:	c9                   	leave  
  80050a:	c3                   	ret    

0080050b <Merge>:

void Merge(int* A, int p, int q, int r)
{
  80050b:	55                   	push   %ebp
  80050c:	89 e5                	mov    %esp,%ebp
  80050e:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  800511:	8b 45 10             	mov    0x10(%ebp),%eax
  800514:	2b 45 0c             	sub    0xc(%ebp),%eax
  800517:	40                   	inc    %eax
  800518:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  80051b:	8b 45 14             	mov    0x14(%ebp),%eax
  80051e:	2b 45 10             	sub    0x10(%ebp),%eax
  800521:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  800524:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  80052b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int* Left = malloc(sizeof(int) * leftCapacity);
  800532:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800535:	c1 e0 02             	shl    $0x2,%eax
  800538:	83 ec 0c             	sub    $0xc,%esp
  80053b:	50                   	push   %eax
  80053c:	e8 d8 17 00 00       	call   801d19 <malloc>
  800541:	83 c4 10             	add    $0x10,%esp
  800544:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  800547:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80054a:	c1 e0 02             	shl    $0x2,%eax
  80054d:	83 ec 0c             	sub    $0xc,%esp
  800550:	50                   	push   %eax
  800551:	e8 c3 17 00 00       	call   801d19 <malloc>
  800556:	83 c4 10             	add    $0x10,%esp
  800559:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//	int Left[5000] ;
	//	int Right[5000] ;

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  80055c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800563:	eb 2f                	jmp    800594 <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  800565:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800568:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80056f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800572:	01 c2                	add    %eax,%edx
  800574:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800577:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80057a:	01 c8                	add    %ecx,%eax
  80057c:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800581:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800588:	8b 45 08             	mov    0x8(%ebp),%eax
  80058b:	01 c8                	add    %ecx,%eax
  80058d:	8b 00                	mov    (%eax),%eax
  80058f:	89 02                	mov    %eax,(%edx)

	//	int Left[5000] ;
	//	int Right[5000] ;

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  800591:	ff 45 ec             	incl   -0x14(%ebp)
  800594:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800597:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80059a:	7c c9                	jl     800565 <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  80059c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005a3:	eb 2a                	jmp    8005cf <Merge+0xc4>
	{
		Right[j] = A[q + j];
  8005a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005a8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005af:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005b2:	01 c2                	add    %eax,%edx
  8005b4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005ba:	01 c8                	add    %ecx,%eax
  8005bc:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c6:	01 c8                	add    %ecx,%eax
  8005c8:	8b 00                	mov    (%eax),%eax
  8005ca:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005cc:	ff 45 e8             	incl   -0x18(%ebp)
  8005cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005d2:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005d5:	7c ce                	jl     8005a5 <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8005d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005dd:	e9 0a 01 00 00       	jmp    8006ec <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  8005e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005e5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005e8:	0f 8d 95 00 00 00    	jge    800683 <Merge+0x178>
  8005ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005f1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005f4:	0f 8d 89 00 00 00    	jge    800683 <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8005fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005fd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800604:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800607:	01 d0                	add    %edx,%eax
  800609:	8b 10                	mov    (%eax),%edx
  80060b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80060e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800615:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800618:	01 c8                	add    %ecx,%eax
  80061a:	8b 00                	mov    (%eax),%eax
  80061c:	39 c2                	cmp    %eax,%edx
  80061e:	7d 33                	jge    800653 <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  800620:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800623:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800628:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80062f:	8b 45 08             	mov    0x8(%ebp),%eax
  800632:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800638:	8d 50 01             	lea    0x1(%eax),%edx
  80063b:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80063e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800645:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800648:	01 d0                	add    %edx,%eax
  80064a:	8b 00                	mov    (%eax),%eax
  80064c:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80064e:	e9 96 00 00 00       	jmp    8006e9 <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  800653:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800656:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80065b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800662:	8b 45 08             	mov    0x8(%ebp),%eax
  800665:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800668:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80066b:	8d 50 01             	lea    0x1(%eax),%edx
  80066e:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800671:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800678:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80067b:	01 d0                	add    %edx,%eax
  80067d:	8b 00                	mov    (%eax),%eax
  80067f:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800681:	eb 66                	jmp    8006e9 <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  800683:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800686:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800689:	7d 30                	jge    8006bb <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  80068b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80068e:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800693:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80069a:	8b 45 08             	mov    0x8(%ebp),%eax
  80069d:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006a3:	8d 50 01             	lea    0x1(%eax),%edx
  8006a6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8006a9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006b0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006b3:	01 d0                	add    %edx,%eax
  8006b5:	8b 00                	mov    (%eax),%eax
  8006b7:	89 01                	mov    %eax,(%ecx)
  8006b9:	eb 2e                	jmp    8006e9 <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  8006bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006be:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cd:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006d3:	8d 50 01             	lea    0x1(%eax),%edx
  8006d6:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8006d9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006e0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006e3:	01 d0                	add    %edx,%eax
  8006e5:	8b 00                	mov    (%eax),%eax
  8006e7:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8006e9:	ff 45 e4             	incl   -0x1c(%ebp)
  8006ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006ef:	3b 45 14             	cmp    0x14(%ebp),%eax
  8006f2:	0f 8e ea fe ff ff    	jle    8005e2 <Merge+0xd7>
		{
			A[k - 1] = Right[rightIndex++];
		}
	}

}
  8006f8:	90                   	nop
  8006f9:	c9                   	leave  
  8006fa:	c3                   	ret    

008006fb <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8006fb:	55                   	push   %ebp
  8006fc:	89 e5                	mov    %esp,%ebp
  8006fe:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  800701:	8b 45 08             	mov    0x8(%ebp),%eax
  800704:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800707:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80070b:	83 ec 0c             	sub    $0xc,%esp
  80070e:	50                   	push   %eax
  80070f:	e8 43 1b 00 00       	call   802257 <sys_cputc>
  800714:	83 c4 10             	add    $0x10,%esp
}
  800717:	90                   	nop
  800718:	c9                   	leave  
  800719:	c3                   	ret    

0080071a <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  80071a:	55                   	push   %ebp
  80071b:	89 e5                	mov    %esp,%ebp
  80071d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800720:	e8 fe 1a 00 00       	call   802223 <sys_disable_interrupt>
	char c = ch;
  800725:	8b 45 08             	mov    0x8(%ebp),%eax
  800728:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  80072b:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80072f:	83 ec 0c             	sub    $0xc,%esp
  800732:	50                   	push   %eax
  800733:	e8 1f 1b 00 00       	call   802257 <sys_cputc>
  800738:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80073b:	e8 fd 1a 00 00       	call   80223d <sys_enable_interrupt>
}
  800740:	90                   	nop
  800741:	c9                   	leave  
  800742:	c3                   	ret    

00800743 <getchar>:

int
getchar(void)
{
  800743:	55                   	push   %ebp
  800744:	89 e5                	mov    %esp,%ebp
  800746:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800749:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800750:	eb 08                	jmp    80075a <getchar+0x17>
	{
		c = sys_cgetc();
  800752:	e8 47 19 00 00       	call   80209e <sys_cgetc>
  800757:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  80075a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80075e:	74 f2                	je     800752 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  800760:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800763:	c9                   	leave  
  800764:	c3                   	ret    

00800765 <atomic_getchar>:

int
atomic_getchar(void)
{
  800765:	55                   	push   %ebp
  800766:	89 e5                	mov    %esp,%ebp
  800768:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80076b:	e8 b3 1a 00 00       	call   802223 <sys_disable_interrupt>
	int c=0;
  800770:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800777:	eb 08                	jmp    800781 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800779:	e8 20 19 00 00       	call   80209e <sys_cgetc>
  80077e:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  800781:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800785:	74 f2                	je     800779 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  800787:	e8 b1 1a 00 00       	call   80223d <sys_enable_interrupt>
	return c;
  80078c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80078f:	c9                   	leave  
  800790:	c3                   	ret    

00800791 <iscons>:

int iscons(int fdnum)
{
  800791:	55                   	push   %ebp
  800792:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800794:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800799:	5d                   	pop    %ebp
  80079a:	c3                   	ret    

0080079b <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80079b:	55                   	push   %ebp
  80079c:	89 e5                	mov    %esp,%ebp
  80079e:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8007a1:	e8 70 1c 00 00       	call   802416 <sys_getenvindex>
  8007a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8007a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007ac:	89 d0                	mov    %edx,%eax
  8007ae:	c1 e0 03             	shl    $0x3,%eax
  8007b1:	01 d0                	add    %edx,%eax
  8007b3:	01 c0                	add    %eax,%eax
  8007b5:	01 d0                	add    %edx,%eax
  8007b7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007be:	01 d0                	add    %edx,%eax
  8007c0:	c1 e0 04             	shl    $0x4,%eax
  8007c3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8007c8:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8007cd:	a1 24 50 80 00       	mov    0x805024,%eax
  8007d2:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8007d8:	84 c0                	test   %al,%al
  8007da:	74 0f                	je     8007eb <libmain+0x50>
		binaryname = myEnv->prog_name;
  8007dc:	a1 24 50 80 00       	mov    0x805024,%eax
  8007e1:	05 5c 05 00 00       	add    $0x55c,%eax
  8007e6:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8007eb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8007ef:	7e 0a                	jle    8007fb <libmain+0x60>
		binaryname = argv[0];
  8007f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007f4:	8b 00                	mov    (%eax),%eax
  8007f6:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8007fb:	83 ec 08             	sub    $0x8,%esp
  8007fe:	ff 75 0c             	pushl  0xc(%ebp)
  800801:	ff 75 08             	pushl  0x8(%ebp)
  800804:	e8 2f f8 ff ff       	call   800038 <_main>
  800809:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80080c:	e8 12 1a 00 00       	call   802223 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800811:	83 ec 0c             	sub    $0xc,%esp
  800814:	68 54 41 80 00       	push   $0x804154
  800819:	e8 6d 03 00 00       	call   800b8b <cprintf>
  80081e:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800821:	a1 24 50 80 00       	mov    0x805024,%eax
  800826:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80082c:	a1 24 50 80 00       	mov    0x805024,%eax
  800831:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800837:	83 ec 04             	sub    $0x4,%esp
  80083a:	52                   	push   %edx
  80083b:	50                   	push   %eax
  80083c:	68 7c 41 80 00       	push   $0x80417c
  800841:	e8 45 03 00 00       	call   800b8b <cprintf>
  800846:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800849:	a1 24 50 80 00       	mov    0x805024,%eax
  80084e:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800854:	a1 24 50 80 00       	mov    0x805024,%eax
  800859:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80085f:	a1 24 50 80 00       	mov    0x805024,%eax
  800864:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80086a:	51                   	push   %ecx
  80086b:	52                   	push   %edx
  80086c:	50                   	push   %eax
  80086d:	68 a4 41 80 00       	push   $0x8041a4
  800872:	e8 14 03 00 00       	call   800b8b <cprintf>
  800877:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80087a:	a1 24 50 80 00       	mov    0x805024,%eax
  80087f:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800885:	83 ec 08             	sub    $0x8,%esp
  800888:	50                   	push   %eax
  800889:	68 fc 41 80 00       	push   $0x8041fc
  80088e:	e8 f8 02 00 00       	call   800b8b <cprintf>
  800893:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800896:	83 ec 0c             	sub    $0xc,%esp
  800899:	68 54 41 80 00       	push   $0x804154
  80089e:	e8 e8 02 00 00       	call   800b8b <cprintf>
  8008a3:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8008a6:	e8 92 19 00 00       	call   80223d <sys_enable_interrupt>

	// exit gracefully
	exit();
  8008ab:	e8 19 00 00 00       	call   8008c9 <exit>
}
  8008b0:	90                   	nop
  8008b1:	c9                   	leave  
  8008b2:	c3                   	ret    

008008b3 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8008b3:	55                   	push   %ebp
  8008b4:	89 e5                	mov    %esp,%ebp
  8008b6:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8008b9:	83 ec 0c             	sub    $0xc,%esp
  8008bc:	6a 00                	push   $0x0
  8008be:	e8 1f 1b 00 00       	call   8023e2 <sys_destroy_env>
  8008c3:	83 c4 10             	add    $0x10,%esp
}
  8008c6:	90                   	nop
  8008c7:	c9                   	leave  
  8008c8:	c3                   	ret    

008008c9 <exit>:

void
exit(void)
{
  8008c9:	55                   	push   %ebp
  8008ca:	89 e5                	mov    %esp,%ebp
  8008cc:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8008cf:	e8 74 1b 00 00       	call   802448 <sys_exit_env>
}
  8008d4:	90                   	nop
  8008d5:	c9                   	leave  
  8008d6:	c3                   	ret    

008008d7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8008d7:	55                   	push   %ebp
  8008d8:	89 e5                	mov    %esp,%ebp
  8008da:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8008dd:	8d 45 10             	lea    0x10(%ebp),%eax
  8008e0:	83 c0 04             	add    $0x4,%eax
  8008e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8008e6:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8008eb:	85 c0                	test   %eax,%eax
  8008ed:	74 16                	je     800905 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8008ef:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8008f4:	83 ec 08             	sub    $0x8,%esp
  8008f7:	50                   	push   %eax
  8008f8:	68 10 42 80 00       	push   $0x804210
  8008fd:	e8 89 02 00 00       	call   800b8b <cprintf>
  800902:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800905:	a1 00 50 80 00       	mov    0x805000,%eax
  80090a:	ff 75 0c             	pushl  0xc(%ebp)
  80090d:	ff 75 08             	pushl  0x8(%ebp)
  800910:	50                   	push   %eax
  800911:	68 15 42 80 00       	push   $0x804215
  800916:	e8 70 02 00 00       	call   800b8b <cprintf>
  80091b:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80091e:	8b 45 10             	mov    0x10(%ebp),%eax
  800921:	83 ec 08             	sub    $0x8,%esp
  800924:	ff 75 f4             	pushl  -0xc(%ebp)
  800927:	50                   	push   %eax
  800928:	e8 f3 01 00 00       	call   800b20 <vcprintf>
  80092d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800930:	83 ec 08             	sub    $0x8,%esp
  800933:	6a 00                	push   $0x0
  800935:	68 31 42 80 00       	push   $0x804231
  80093a:	e8 e1 01 00 00       	call   800b20 <vcprintf>
  80093f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800942:	e8 82 ff ff ff       	call   8008c9 <exit>

	// should not return here
	while (1) ;
  800947:	eb fe                	jmp    800947 <_panic+0x70>

00800949 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800949:	55                   	push   %ebp
  80094a:	89 e5                	mov    %esp,%ebp
  80094c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80094f:	a1 24 50 80 00       	mov    0x805024,%eax
  800954:	8b 50 74             	mov    0x74(%eax),%edx
  800957:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095a:	39 c2                	cmp    %eax,%edx
  80095c:	74 14                	je     800972 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80095e:	83 ec 04             	sub    $0x4,%esp
  800961:	68 34 42 80 00       	push   $0x804234
  800966:	6a 26                	push   $0x26
  800968:	68 80 42 80 00       	push   $0x804280
  80096d:	e8 65 ff ff ff       	call   8008d7 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800972:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800979:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800980:	e9 c2 00 00 00       	jmp    800a47 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800985:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800988:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80098f:	8b 45 08             	mov    0x8(%ebp),%eax
  800992:	01 d0                	add    %edx,%eax
  800994:	8b 00                	mov    (%eax),%eax
  800996:	85 c0                	test   %eax,%eax
  800998:	75 08                	jne    8009a2 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80099a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80099d:	e9 a2 00 00 00       	jmp    800a44 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8009a2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009a9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8009b0:	eb 69                	jmp    800a1b <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8009b2:	a1 24 50 80 00       	mov    0x805024,%eax
  8009b7:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8009bd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009c0:	89 d0                	mov    %edx,%eax
  8009c2:	01 c0                	add    %eax,%eax
  8009c4:	01 d0                	add    %edx,%eax
  8009c6:	c1 e0 03             	shl    $0x3,%eax
  8009c9:	01 c8                	add    %ecx,%eax
  8009cb:	8a 40 04             	mov    0x4(%eax),%al
  8009ce:	84 c0                	test   %al,%al
  8009d0:	75 46                	jne    800a18 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009d2:	a1 24 50 80 00       	mov    0x805024,%eax
  8009d7:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8009dd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009e0:	89 d0                	mov    %edx,%eax
  8009e2:	01 c0                	add    %eax,%eax
  8009e4:	01 d0                	add    %edx,%eax
  8009e6:	c1 e0 03             	shl    $0x3,%eax
  8009e9:	01 c8                	add    %ecx,%eax
  8009eb:	8b 00                	mov    (%eax),%eax
  8009ed:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8009f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8009f3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8009f8:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8009fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009fd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a04:	8b 45 08             	mov    0x8(%ebp),%eax
  800a07:	01 c8                	add    %ecx,%eax
  800a09:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a0b:	39 c2                	cmp    %eax,%edx
  800a0d:	75 09                	jne    800a18 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800a0f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a16:	eb 12                	jmp    800a2a <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a18:	ff 45 e8             	incl   -0x18(%ebp)
  800a1b:	a1 24 50 80 00       	mov    0x805024,%eax
  800a20:	8b 50 74             	mov    0x74(%eax),%edx
  800a23:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a26:	39 c2                	cmp    %eax,%edx
  800a28:	77 88                	ja     8009b2 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a2a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a2e:	75 14                	jne    800a44 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800a30:	83 ec 04             	sub    $0x4,%esp
  800a33:	68 8c 42 80 00       	push   $0x80428c
  800a38:	6a 3a                	push   $0x3a
  800a3a:	68 80 42 80 00       	push   $0x804280
  800a3f:	e8 93 fe ff ff       	call   8008d7 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a44:	ff 45 f0             	incl   -0x10(%ebp)
  800a47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a4a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a4d:	0f 8c 32 ff ff ff    	jl     800985 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a53:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a5a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a61:	eb 26                	jmp    800a89 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a63:	a1 24 50 80 00       	mov    0x805024,%eax
  800a68:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800a6e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a71:	89 d0                	mov    %edx,%eax
  800a73:	01 c0                	add    %eax,%eax
  800a75:	01 d0                	add    %edx,%eax
  800a77:	c1 e0 03             	shl    $0x3,%eax
  800a7a:	01 c8                	add    %ecx,%eax
  800a7c:	8a 40 04             	mov    0x4(%eax),%al
  800a7f:	3c 01                	cmp    $0x1,%al
  800a81:	75 03                	jne    800a86 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800a83:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a86:	ff 45 e0             	incl   -0x20(%ebp)
  800a89:	a1 24 50 80 00       	mov    0x805024,%eax
  800a8e:	8b 50 74             	mov    0x74(%eax),%edx
  800a91:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a94:	39 c2                	cmp    %eax,%edx
  800a96:	77 cb                	ja     800a63 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800a98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a9b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800a9e:	74 14                	je     800ab4 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800aa0:	83 ec 04             	sub    $0x4,%esp
  800aa3:	68 e0 42 80 00       	push   $0x8042e0
  800aa8:	6a 44                	push   $0x44
  800aaa:	68 80 42 80 00       	push   $0x804280
  800aaf:	e8 23 fe ff ff       	call   8008d7 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800ab4:	90                   	nop
  800ab5:	c9                   	leave  
  800ab6:	c3                   	ret    

00800ab7 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800ab7:	55                   	push   %ebp
  800ab8:	89 e5                	mov    %esp,%ebp
  800aba:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800abd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac0:	8b 00                	mov    (%eax),%eax
  800ac2:	8d 48 01             	lea    0x1(%eax),%ecx
  800ac5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ac8:	89 0a                	mov    %ecx,(%edx)
  800aca:	8b 55 08             	mov    0x8(%ebp),%edx
  800acd:	88 d1                	mov    %dl,%cl
  800acf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ad2:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800ad6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad9:	8b 00                	mov    (%eax),%eax
  800adb:	3d ff 00 00 00       	cmp    $0xff,%eax
  800ae0:	75 2c                	jne    800b0e <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800ae2:	a0 28 50 80 00       	mov    0x805028,%al
  800ae7:	0f b6 c0             	movzbl %al,%eax
  800aea:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aed:	8b 12                	mov    (%edx),%edx
  800aef:	89 d1                	mov    %edx,%ecx
  800af1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800af4:	83 c2 08             	add    $0x8,%edx
  800af7:	83 ec 04             	sub    $0x4,%esp
  800afa:	50                   	push   %eax
  800afb:	51                   	push   %ecx
  800afc:	52                   	push   %edx
  800afd:	e8 73 15 00 00       	call   802075 <sys_cputs>
  800b02:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b08:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b11:	8b 40 04             	mov    0x4(%eax),%eax
  800b14:	8d 50 01             	lea    0x1(%eax),%edx
  800b17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1a:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b1d:	90                   	nop
  800b1e:	c9                   	leave  
  800b1f:	c3                   	ret    

00800b20 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b20:	55                   	push   %ebp
  800b21:	89 e5                	mov    %esp,%ebp
  800b23:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b29:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b30:	00 00 00 
	b.cnt = 0;
  800b33:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b3a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b3d:	ff 75 0c             	pushl  0xc(%ebp)
  800b40:	ff 75 08             	pushl  0x8(%ebp)
  800b43:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b49:	50                   	push   %eax
  800b4a:	68 b7 0a 80 00       	push   $0x800ab7
  800b4f:	e8 11 02 00 00       	call   800d65 <vprintfmt>
  800b54:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800b57:	a0 28 50 80 00       	mov    0x805028,%al
  800b5c:	0f b6 c0             	movzbl %al,%eax
  800b5f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800b65:	83 ec 04             	sub    $0x4,%esp
  800b68:	50                   	push   %eax
  800b69:	52                   	push   %edx
  800b6a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b70:	83 c0 08             	add    $0x8,%eax
  800b73:	50                   	push   %eax
  800b74:	e8 fc 14 00 00       	call   802075 <sys_cputs>
  800b79:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800b7c:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800b83:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800b89:	c9                   	leave  
  800b8a:	c3                   	ret    

00800b8b <cprintf>:

int cprintf(const char *fmt, ...) {
  800b8b:	55                   	push   %ebp
  800b8c:	89 e5                	mov    %esp,%ebp
  800b8e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800b91:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800b98:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba1:	83 ec 08             	sub    $0x8,%esp
  800ba4:	ff 75 f4             	pushl  -0xc(%ebp)
  800ba7:	50                   	push   %eax
  800ba8:	e8 73 ff ff ff       	call   800b20 <vcprintf>
  800bad:	83 c4 10             	add    $0x10,%esp
  800bb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800bb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bb6:	c9                   	leave  
  800bb7:	c3                   	ret    

00800bb8 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800bb8:	55                   	push   %ebp
  800bb9:	89 e5                	mov    %esp,%ebp
  800bbb:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800bbe:	e8 60 16 00 00       	call   802223 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800bc3:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcc:	83 ec 08             	sub    $0x8,%esp
  800bcf:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd2:	50                   	push   %eax
  800bd3:	e8 48 ff ff ff       	call   800b20 <vcprintf>
  800bd8:	83 c4 10             	add    $0x10,%esp
  800bdb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800bde:	e8 5a 16 00 00       	call   80223d <sys_enable_interrupt>
	return cnt;
  800be3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800be6:	c9                   	leave  
  800be7:	c3                   	ret    

00800be8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800be8:	55                   	push   %ebp
  800be9:	89 e5                	mov    %esp,%ebp
  800beb:	53                   	push   %ebx
  800bec:	83 ec 14             	sub    $0x14,%esp
  800bef:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bf5:	8b 45 14             	mov    0x14(%ebp),%eax
  800bf8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800bfb:	8b 45 18             	mov    0x18(%ebp),%eax
  800bfe:	ba 00 00 00 00       	mov    $0x0,%edx
  800c03:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c06:	77 55                	ja     800c5d <printnum+0x75>
  800c08:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c0b:	72 05                	jb     800c12 <printnum+0x2a>
  800c0d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c10:	77 4b                	ja     800c5d <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c12:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800c15:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800c18:	8b 45 18             	mov    0x18(%ebp),%eax
  800c1b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c20:	52                   	push   %edx
  800c21:	50                   	push   %eax
  800c22:	ff 75 f4             	pushl  -0xc(%ebp)
  800c25:	ff 75 f0             	pushl  -0x10(%ebp)
  800c28:	e8 cb 30 00 00       	call   803cf8 <__udivdi3>
  800c2d:	83 c4 10             	add    $0x10,%esp
  800c30:	83 ec 04             	sub    $0x4,%esp
  800c33:	ff 75 20             	pushl  0x20(%ebp)
  800c36:	53                   	push   %ebx
  800c37:	ff 75 18             	pushl  0x18(%ebp)
  800c3a:	52                   	push   %edx
  800c3b:	50                   	push   %eax
  800c3c:	ff 75 0c             	pushl  0xc(%ebp)
  800c3f:	ff 75 08             	pushl  0x8(%ebp)
  800c42:	e8 a1 ff ff ff       	call   800be8 <printnum>
  800c47:	83 c4 20             	add    $0x20,%esp
  800c4a:	eb 1a                	jmp    800c66 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c4c:	83 ec 08             	sub    $0x8,%esp
  800c4f:	ff 75 0c             	pushl  0xc(%ebp)
  800c52:	ff 75 20             	pushl  0x20(%ebp)
  800c55:	8b 45 08             	mov    0x8(%ebp),%eax
  800c58:	ff d0                	call   *%eax
  800c5a:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c5d:	ff 4d 1c             	decl   0x1c(%ebp)
  800c60:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c64:	7f e6                	jg     800c4c <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c66:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c69:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c74:	53                   	push   %ebx
  800c75:	51                   	push   %ecx
  800c76:	52                   	push   %edx
  800c77:	50                   	push   %eax
  800c78:	e8 8b 31 00 00       	call   803e08 <__umoddi3>
  800c7d:	83 c4 10             	add    $0x10,%esp
  800c80:	05 54 45 80 00       	add    $0x804554,%eax
  800c85:	8a 00                	mov    (%eax),%al
  800c87:	0f be c0             	movsbl %al,%eax
  800c8a:	83 ec 08             	sub    $0x8,%esp
  800c8d:	ff 75 0c             	pushl  0xc(%ebp)
  800c90:	50                   	push   %eax
  800c91:	8b 45 08             	mov    0x8(%ebp),%eax
  800c94:	ff d0                	call   *%eax
  800c96:	83 c4 10             	add    $0x10,%esp
}
  800c99:	90                   	nop
  800c9a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c9d:	c9                   	leave  
  800c9e:	c3                   	ret    

00800c9f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800c9f:	55                   	push   %ebp
  800ca0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ca2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ca6:	7e 1c                	jle    800cc4 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cab:	8b 00                	mov    (%eax),%eax
  800cad:	8d 50 08             	lea    0x8(%eax),%edx
  800cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb3:	89 10                	mov    %edx,(%eax)
  800cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb8:	8b 00                	mov    (%eax),%eax
  800cba:	83 e8 08             	sub    $0x8,%eax
  800cbd:	8b 50 04             	mov    0x4(%eax),%edx
  800cc0:	8b 00                	mov    (%eax),%eax
  800cc2:	eb 40                	jmp    800d04 <getuint+0x65>
	else if (lflag)
  800cc4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cc8:	74 1e                	je     800ce8 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800cca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccd:	8b 00                	mov    (%eax),%eax
  800ccf:	8d 50 04             	lea    0x4(%eax),%edx
  800cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd5:	89 10                	mov    %edx,(%eax)
  800cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cda:	8b 00                	mov    (%eax),%eax
  800cdc:	83 e8 04             	sub    $0x4,%eax
  800cdf:	8b 00                	mov    (%eax),%eax
  800ce1:	ba 00 00 00 00       	mov    $0x0,%edx
  800ce6:	eb 1c                	jmp    800d04 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ceb:	8b 00                	mov    (%eax),%eax
  800ced:	8d 50 04             	lea    0x4(%eax),%edx
  800cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf3:	89 10                	mov    %edx,(%eax)
  800cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf8:	8b 00                	mov    (%eax),%eax
  800cfa:	83 e8 04             	sub    $0x4,%eax
  800cfd:	8b 00                	mov    (%eax),%eax
  800cff:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800d04:	5d                   	pop    %ebp
  800d05:	c3                   	ret    

00800d06 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800d06:	55                   	push   %ebp
  800d07:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d09:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d0d:	7e 1c                	jle    800d2b <getint+0x25>
		return va_arg(*ap, long long);
  800d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d12:	8b 00                	mov    (%eax),%eax
  800d14:	8d 50 08             	lea    0x8(%eax),%edx
  800d17:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1a:	89 10                	mov    %edx,(%eax)
  800d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1f:	8b 00                	mov    (%eax),%eax
  800d21:	83 e8 08             	sub    $0x8,%eax
  800d24:	8b 50 04             	mov    0x4(%eax),%edx
  800d27:	8b 00                	mov    (%eax),%eax
  800d29:	eb 38                	jmp    800d63 <getint+0x5d>
	else if (lflag)
  800d2b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d2f:	74 1a                	je     800d4b <getint+0x45>
		return va_arg(*ap, long);
  800d31:	8b 45 08             	mov    0x8(%ebp),%eax
  800d34:	8b 00                	mov    (%eax),%eax
  800d36:	8d 50 04             	lea    0x4(%eax),%edx
  800d39:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3c:	89 10                	mov    %edx,(%eax)
  800d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d41:	8b 00                	mov    (%eax),%eax
  800d43:	83 e8 04             	sub    $0x4,%eax
  800d46:	8b 00                	mov    (%eax),%eax
  800d48:	99                   	cltd   
  800d49:	eb 18                	jmp    800d63 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4e:	8b 00                	mov    (%eax),%eax
  800d50:	8d 50 04             	lea    0x4(%eax),%edx
  800d53:	8b 45 08             	mov    0x8(%ebp),%eax
  800d56:	89 10                	mov    %edx,(%eax)
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5b:	8b 00                	mov    (%eax),%eax
  800d5d:	83 e8 04             	sub    $0x4,%eax
  800d60:	8b 00                	mov    (%eax),%eax
  800d62:	99                   	cltd   
}
  800d63:	5d                   	pop    %ebp
  800d64:	c3                   	ret    

00800d65 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d65:	55                   	push   %ebp
  800d66:	89 e5                	mov    %esp,%ebp
  800d68:	56                   	push   %esi
  800d69:	53                   	push   %ebx
  800d6a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d6d:	eb 17                	jmp    800d86 <vprintfmt+0x21>
			if (ch == '\0')
  800d6f:	85 db                	test   %ebx,%ebx
  800d71:	0f 84 af 03 00 00    	je     801126 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800d77:	83 ec 08             	sub    $0x8,%esp
  800d7a:	ff 75 0c             	pushl  0xc(%ebp)
  800d7d:	53                   	push   %ebx
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d81:	ff d0                	call   *%eax
  800d83:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d86:	8b 45 10             	mov    0x10(%ebp),%eax
  800d89:	8d 50 01             	lea    0x1(%eax),%edx
  800d8c:	89 55 10             	mov    %edx,0x10(%ebp)
  800d8f:	8a 00                	mov    (%eax),%al
  800d91:	0f b6 d8             	movzbl %al,%ebx
  800d94:	83 fb 25             	cmp    $0x25,%ebx
  800d97:	75 d6                	jne    800d6f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800d99:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800d9d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800da4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800dab:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800db2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800db9:	8b 45 10             	mov    0x10(%ebp),%eax
  800dbc:	8d 50 01             	lea    0x1(%eax),%edx
  800dbf:	89 55 10             	mov    %edx,0x10(%ebp)
  800dc2:	8a 00                	mov    (%eax),%al
  800dc4:	0f b6 d8             	movzbl %al,%ebx
  800dc7:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800dca:	83 f8 55             	cmp    $0x55,%eax
  800dcd:	0f 87 2b 03 00 00    	ja     8010fe <vprintfmt+0x399>
  800dd3:	8b 04 85 78 45 80 00 	mov    0x804578(,%eax,4),%eax
  800dda:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800ddc:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800de0:	eb d7                	jmp    800db9 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800de2:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800de6:	eb d1                	jmp    800db9 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800de8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800def:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800df2:	89 d0                	mov    %edx,%eax
  800df4:	c1 e0 02             	shl    $0x2,%eax
  800df7:	01 d0                	add    %edx,%eax
  800df9:	01 c0                	add    %eax,%eax
  800dfb:	01 d8                	add    %ebx,%eax
  800dfd:	83 e8 30             	sub    $0x30,%eax
  800e00:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800e03:	8b 45 10             	mov    0x10(%ebp),%eax
  800e06:	8a 00                	mov    (%eax),%al
  800e08:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e0b:	83 fb 2f             	cmp    $0x2f,%ebx
  800e0e:	7e 3e                	jle    800e4e <vprintfmt+0xe9>
  800e10:	83 fb 39             	cmp    $0x39,%ebx
  800e13:	7f 39                	jg     800e4e <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e15:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800e18:	eb d5                	jmp    800def <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800e1a:	8b 45 14             	mov    0x14(%ebp),%eax
  800e1d:	83 c0 04             	add    $0x4,%eax
  800e20:	89 45 14             	mov    %eax,0x14(%ebp)
  800e23:	8b 45 14             	mov    0x14(%ebp),%eax
  800e26:	83 e8 04             	sub    $0x4,%eax
  800e29:	8b 00                	mov    (%eax),%eax
  800e2b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800e2e:	eb 1f                	jmp    800e4f <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800e30:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e34:	79 83                	jns    800db9 <vprintfmt+0x54>
				width = 0;
  800e36:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800e3d:	e9 77 ff ff ff       	jmp    800db9 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e42:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e49:	e9 6b ff ff ff       	jmp    800db9 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e4e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e4f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e53:	0f 89 60 ff ff ff    	jns    800db9 <vprintfmt+0x54>
				width = precision, precision = -1;
  800e59:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e5c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e5f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e66:	e9 4e ff ff ff       	jmp    800db9 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e6b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800e6e:	e9 46 ff ff ff       	jmp    800db9 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800e73:	8b 45 14             	mov    0x14(%ebp),%eax
  800e76:	83 c0 04             	add    $0x4,%eax
  800e79:	89 45 14             	mov    %eax,0x14(%ebp)
  800e7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800e7f:	83 e8 04             	sub    $0x4,%eax
  800e82:	8b 00                	mov    (%eax),%eax
  800e84:	83 ec 08             	sub    $0x8,%esp
  800e87:	ff 75 0c             	pushl  0xc(%ebp)
  800e8a:	50                   	push   %eax
  800e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8e:	ff d0                	call   *%eax
  800e90:	83 c4 10             	add    $0x10,%esp
			break;
  800e93:	e9 89 02 00 00       	jmp    801121 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800e98:	8b 45 14             	mov    0x14(%ebp),%eax
  800e9b:	83 c0 04             	add    $0x4,%eax
  800e9e:	89 45 14             	mov    %eax,0x14(%ebp)
  800ea1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ea4:	83 e8 04             	sub    $0x4,%eax
  800ea7:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ea9:	85 db                	test   %ebx,%ebx
  800eab:	79 02                	jns    800eaf <vprintfmt+0x14a>
				err = -err;
  800ead:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800eaf:	83 fb 64             	cmp    $0x64,%ebx
  800eb2:	7f 0b                	jg     800ebf <vprintfmt+0x15a>
  800eb4:	8b 34 9d c0 43 80 00 	mov    0x8043c0(,%ebx,4),%esi
  800ebb:	85 f6                	test   %esi,%esi
  800ebd:	75 19                	jne    800ed8 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ebf:	53                   	push   %ebx
  800ec0:	68 65 45 80 00       	push   $0x804565
  800ec5:	ff 75 0c             	pushl  0xc(%ebp)
  800ec8:	ff 75 08             	pushl  0x8(%ebp)
  800ecb:	e8 5e 02 00 00       	call   80112e <printfmt>
  800ed0:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ed3:	e9 49 02 00 00       	jmp    801121 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ed8:	56                   	push   %esi
  800ed9:	68 6e 45 80 00       	push   $0x80456e
  800ede:	ff 75 0c             	pushl  0xc(%ebp)
  800ee1:	ff 75 08             	pushl  0x8(%ebp)
  800ee4:	e8 45 02 00 00       	call   80112e <printfmt>
  800ee9:	83 c4 10             	add    $0x10,%esp
			break;
  800eec:	e9 30 02 00 00       	jmp    801121 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ef1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ef4:	83 c0 04             	add    $0x4,%eax
  800ef7:	89 45 14             	mov    %eax,0x14(%ebp)
  800efa:	8b 45 14             	mov    0x14(%ebp),%eax
  800efd:	83 e8 04             	sub    $0x4,%eax
  800f00:	8b 30                	mov    (%eax),%esi
  800f02:	85 f6                	test   %esi,%esi
  800f04:	75 05                	jne    800f0b <vprintfmt+0x1a6>
				p = "(null)";
  800f06:	be 71 45 80 00       	mov    $0x804571,%esi
			if (width > 0 && padc != '-')
  800f0b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f0f:	7e 6d                	jle    800f7e <vprintfmt+0x219>
  800f11:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800f15:	74 67                	je     800f7e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800f17:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f1a:	83 ec 08             	sub    $0x8,%esp
  800f1d:	50                   	push   %eax
  800f1e:	56                   	push   %esi
  800f1f:	e8 12 05 00 00       	call   801436 <strnlen>
  800f24:	83 c4 10             	add    $0x10,%esp
  800f27:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800f2a:	eb 16                	jmp    800f42 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800f2c:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800f30:	83 ec 08             	sub    $0x8,%esp
  800f33:	ff 75 0c             	pushl  0xc(%ebp)
  800f36:	50                   	push   %eax
  800f37:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3a:	ff d0                	call   *%eax
  800f3c:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f3f:	ff 4d e4             	decl   -0x1c(%ebp)
  800f42:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f46:	7f e4                	jg     800f2c <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f48:	eb 34                	jmp    800f7e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f4a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f4e:	74 1c                	je     800f6c <vprintfmt+0x207>
  800f50:	83 fb 1f             	cmp    $0x1f,%ebx
  800f53:	7e 05                	jle    800f5a <vprintfmt+0x1f5>
  800f55:	83 fb 7e             	cmp    $0x7e,%ebx
  800f58:	7e 12                	jle    800f6c <vprintfmt+0x207>
					putch('?', putdat);
  800f5a:	83 ec 08             	sub    $0x8,%esp
  800f5d:	ff 75 0c             	pushl  0xc(%ebp)
  800f60:	6a 3f                	push   $0x3f
  800f62:	8b 45 08             	mov    0x8(%ebp),%eax
  800f65:	ff d0                	call   *%eax
  800f67:	83 c4 10             	add    $0x10,%esp
  800f6a:	eb 0f                	jmp    800f7b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800f6c:	83 ec 08             	sub    $0x8,%esp
  800f6f:	ff 75 0c             	pushl  0xc(%ebp)
  800f72:	53                   	push   %ebx
  800f73:	8b 45 08             	mov    0x8(%ebp),%eax
  800f76:	ff d0                	call   *%eax
  800f78:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f7b:	ff 4d e4             	decl   -0x1c(%ebp)
  800f7e:	89 f0                	mov    %esi,%eax
  800f80:	8d 70 01             	lea    0x1(%eax),%esi
  800f83:	8a 00                	mov    (%eax),%al
  800f85:	0f be d8             	movsbl %al,%ebx
  800f88:	85 db                	test   %ebx,%ebx
  800f8a:	74 24                	je     800fb0 <vprintfmt+0x24b>
  800f8c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f90:	78 b8                	js     800f4a <vprintfmt+0x1e5>
  800f92:	ff 4d e0             	decl   -0x20(%ebp)
  800f95:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f99:	79 af                	jns    800f4a <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f9b:	eb 13                	jmp    800fb0 <vprintfmt+0x24b>
				putch(' ', putdat);
  800f9d:	83 ec 08             	sub    $0x8,%esp
  800fa0:	ff 75 0c             	pushl  0xc(%ebp)
  800fa3:	6a 20                	push   $0x20
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	ff d0                	call   *%eax
  800faa:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fad:	ff 4d e4             	decl   -0x1c(%ebp)
  800fb0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fb4:	7f e7                	jg     800f9d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800fb6:	e9 66 01 00 00       	jmp    801121 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800fbb:	83 ec 08             	sub    $0x8,%esp
  800fbe:	ff 75 e8             	pushl  -0x18(%ebp)
  800fc1:	8d 45 14             	lea    0x14(%ebp),%eax
  800fc4:	50                   	push   %eax
  800fc5:	e8 3c fd ff ff       	call   800d06 <getint>
  800fca:	83 c4 10             	add    $0x10,%esp
  800fcd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fd0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800fd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fd6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fd9:	85 d2                	test   %edx,%edx
  800fdb:	79 23                	jns    801000 <vprintfmt+0x29b>
				putch('-', putdat);
  800fdd:	83 ec 08             	sub    $0x8,%esp
  800fe0:	ff 75 0c             	pushl  0xc(%ebp)
  800fe3:	6a 2d                	push   $0x2d
  800fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe8:	ff d0                	call   *%eax
  800fea:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800fed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ff0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ff3:	f7 d8                	neg    %eax
  800ff5:	83 d2 00             	adc    $0x0,%edx
  800ff8:	f7 da                	neg    %edx
  800ffa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ffd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801000:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801007:	e9 bc 00 00 00       	jmp    8010c8 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80100c:	83 ec 08             	sub    $0x8,%esp
  80100f:	ff 75 e8             	pushl  -0x18(%ebp)
  801012:	8d 45 14             	lea    0x14(%ebp),%eax
  801015:	50                   	push   %eax
  801016:	e8 84 fc ff ff       	call   800c9f <getuint>
  80101b:	83 c4 10             	add    $0x10,%esp
  80101e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801021:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801024:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80102b:	e9 98 00 00 00       	jmp    8010c8 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801030:	83 ec 08             	sub    $0x8,%esp
  801033:	ff 75 0c             	pushl  0xc(%ebp)
  801036:	6a 58                	push   $0x58
  801038:	8b 45 08             	mov    0x8(%ebp),%eax
  80103b:	ff d0                	call   *%eax
  80103d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801040:	83 ec 08             	sub    $0x8,%esp
  801043:	ff 75 0c             	pushl  0xc(%ebp)
  801046:	6a 58                	push   $0x58
  801048:	8b 45 08             	mov    0x8(%ebp),%eax
  80104b:	ff d0                	call   *%eax
  80104d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801050:	83 ec 08             	sub    $0x8,%esp
  801053:	ff 75 0c             	pushl  0xc(%ebp)
  801056:	6a 58                	push   $0x58
  801058:	8b 45 08             	mov    0x8(%ebp),%eax
  80105b:	ff d0                	call   *%eax
  80105d:	83 c4 10             	add    $0x10,%esp
			break;
  801060:	e9 bc 00 00 00       	jmp    801121 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801065:	83 ec 08             	sub    $0x8,%esp
  801068:	ff 75 0c             	pushl  0xc(%ebp)
  80106b:	6a 30                	push   $0x30
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
  801070:	ff d0                	call   *%eax
  801072:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801075:	83 ec 08             	sub    $0x8,%esp
  801078:	ff 75 0c             	pushl  0xc(%ebp)
  80107b:	6a 78                	push   $0x78
  80107d:	8b 45 08             	mov    0x8(%ebp),%eax
  801080:	ff d0                	call   *%eax
  801082:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801085:	8b 45 14             	mov    0x14(%ebp),%eax
  801088:	83 c0 04             	add    $0x4,%eax
  80108b:	89 45 14             	mov    %eax,0x14(%ebp)
  80108e:	8b 45 14             	mov    0x14(%ebp),%eax
  801091:	83 e8 04             	sub    $0x4,%eax
  801094:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801096:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801099:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8010a0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8010a7:	eb 1f                	jmp    8010c8 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8010a9:	83 ec 08             	sub    $0x8,%esp
  8010ac:	ff 75 e8             	pushl  -0x18(%ebp)
  8010af:	8d 45 14             	lea    0x14(%ebp),%eax
  8010b2:	50                   	push   %eax
  8010b3:	e8 e7 fb ff ff       	call   800c9f <getuint>
  8010b8:	83 c4 10             	add    $0x10,%esp
  8010bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010be:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8010c1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8010c8:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8010cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010cf:	83 ec 04             	sub    $0x4,%esp
  8010d2:	52                   	push   %edx
  8010d3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010d6:	50                   	push   %eax
  8010d7:	ff 75 f4             	pushl  -0xc(%ebp)
  8010da:	ff 75 f0             	pushl  -0x10(%ebp)
  8010dd:	ff 75 0c             	pushl  0xc(%ebp)
  8010e0:	ff 75 08             	pushl  0x8(%ebp)
  8010e3:	e8 00 fb ff ff       	call   800be8 <printnum>
  8010e8:	83 c4 20             	add    $0x20,%esp
			break;
  8010eb:	eb 34                	jmp    801121 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8010ed:	83 ec 08             	sub    $0x8,%esp
  8010f0:	ff 75 0c             	pushl  0xc(%ebp)
  8010f3:	53                   	push   %ebx
  8010f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f7:	ff d0                	call   *%eax
  8010f9:	83 c4 10             	add    $0x10,%esp
			break;
  8010fc:	eb 23                	jmp    801121 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8010fe:	83 ec 08             	sub    $0x8,%esp
  801101:	ff 75 0c             	pushl  0xc(%ebp)
  801104:	6a 25                	push   $0x25
  801106:	8b 45 08             	mov    0x8(%ebp),%eax
  801109:	ff d0                	call   *%eax
  80110b:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80110e:	ff 4d 10             	decl   0x10(%ebp)
  801111:	eb 03                	jmp    801116 <vprintfmt+0x3b1>
  801113:	ff 4d 10             	decl   0x10(%ebp)
  801116:	8b 45 10             	mov    0x10(%ebp),%eax
  801119:	48                   	dec    %eax
  80111a:	8a 00                	mov    (%eax),%al
  80111c:	3c 25                	cmp    $0x25,%al
  80111e:	75 f3                	jne    801113 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801120:	90                   	nop
		}
	}
  801121:	e9 47 fc ff ff       	jmp    800d6d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801126:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801127:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80112a:	5b                   	pop    %ebx
  80112b:	5e                   	pop    %esi
  80112c:	5d                   	pop    %ebp
  80112d:	c3                   	ret    

0080112e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80112e:	55                   	push   %ebp
  80112f:	89 e5                	mov    %esp,%ebp
  801131:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801134:	8d 45 10             	lea    0x10(%ebp),%eax
  801137:	83 c0 04             	add    $0x4,%eax
  80113a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80113d:	8b 45 10             	mov    0x10(%ebp),%eax
  801140:	ff 75 f4             	pushl  -0xc(%ebp)
  801143:	50                   	push   %eax
  801144:	ff 75 0c             	pushl  0xc(%ebp)
  801147:	ff 75 08             	pushl  0x8(%ebp)
  80114a:	e8 16 fc ff ff       	call   800d65 <vprintfmt>
  80114f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801152:	90                   	nop
  801153:	c9                   	leave  
  801154:	c3                   	ret    

00801155 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801155:	55                   	push   %ebp
  801156:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801158:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115b:	8b 40 08             	mov    0x8(%eax),%eax
  80115e:	8d 50 01             	lea    0x1(%eax),%edx
  801161:	8b 45 0c             	mov    0xc(%ebp),%eax
  801164:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801167:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116a:	8b 10                	mov    (%eax),%edx
  80116c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116f:	8b 40 04             	mov    0x4(%eax),%eax
  801172:	39 c2                	cmp    %eax,%edx
  801174:	73 12                	jae    801188 <sprintputch+0x33>
		*b->buf++ = ch;
  801176:	8b 45 0c             	mov    0xc(%ebp),%eax
  801179:	8b 00                	mov    (%eax),%eax
  80117b:	8d 48 01             	lea    0x1(%eax),%ecx
  80117e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801181:	89 0a                	mov    %ecx,(%edx)
  801183:	8b 55 08             	mov    0x8(%ebp),%edx
  801186:	88 10                	mov    %dl,(%eax)
}
  801188:	90                   	nop
  801189:	5d                   	pop    %ebp
  80118a:	c3                   	ret    

0080118b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80118b:	55                   	push   %ebp
  80118c:	89 e5                	mov    %esp,%ebp
  80118e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801191:	8b 45 08             	mov    0x8(%ebp),%eax
  801194:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801197:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80119d:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a0:	01 d0                	add    %edx,%eax
  8011a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8011ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011b0:	74 06                	je     8011b8 <vsnprintf+0x2d>
  8011b2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011b6:	7f 07                	jg     8011bf <vsnprintf+0x34>
		return -E_INVAL;
  8011b8:	b8 03 00 00 00       	mov    $0x3,%eax
  8011bd:	eb 20                	jmp    8011df <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8011bf:	ff 75 14             	pushl  0x14(%ebp)
  8011c2:	ff 75 10             	pushl  0x10(%ebp)
  8011c5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8011c8:	50                   	push   %eax
  8011c9:	68 55 11 80 00       	push   $0x801155
  8011ce:	e8 92 fb ff ff       	call   800d65 <vprintfmt>
  8011d3:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8011d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011d9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8011dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8011df:	c9                   	leave  
  8011e0:	c3                   	ret    

008011e1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011e1:	55                   	push   %ebp
  8011e2:	89 e5                	mov    %esp,%ebp
  8011e4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8011e7:	8d 45 10             	lea    0x10(%ebp),%eax
  8011ea:	83 c0 04             	add    $0x4,%eax
  8011ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8011f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8011f6:	50                   	push   %eax
  8011f7:	ff 75 0c             	pushl  0xc(%ebp)
  8011fa:	ff 75 08             	pushl  0x8(%ebp)
  8011fd:	e8 89 ff ff ff       	call   80118b <vsnprintf>
  801202:	83 c4 10             	add    $0x10,%esp
  801205:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801208:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80120b:	c9                   	leave  
  80120c:	c3                   	ret    

0080120d <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  80120d:	55                   	push   %ebp
  80120e:	89 e5                	mov    %esp,%ebp
  801210:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  801213:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801217:	74 13                	je     80122c <readline+0x1f>
		cprintf("%s", prompt);
  801219:	83 ec 08             	sub    $0x8,%esp
  80121c:	ff 75 08             	pushl  0x8(%ebp)
  80121f:	68 d0 46 80 00       	push   $0x8046d0
  801224:	e8 62 f9 ff ff       	call   800b8b <cprintf>
  801229:	83 c4 10             	add    $0x10,%esp

	i = 0;
  80122c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801233:	83 ec 0c             	sub    $0xc,%esp
  801236:	6a 00                	push   $0x0
  801238:	e8 54 f5 ff ff       	call   800791 <iscons>
  80123d:	83 c4 10             	add    $0x10,%esp
  801240:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801243:	e8 fb f4 ff ff       	call   800743 <getchar>
  801248:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  80124b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80124f:	79 22                	jns    801273 <readline+0x66>
			if (c != -E_EOF)
  801251:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801255:	0f 84 ad 00 00 00    	je     801308 <readline+0xfb>
				cprintf("read error: %e\n", c);
  80125b:	83 ec 08             	sub    $0x8,%esp
  80125e:	ff 75 ec             	pushl  -0x14(%ebp)
  801261:	68 d3 46 80 00       	push   $0x8046d3
  801266:	e8 20 f9 ff ff       	call   800b8b <cprintf>
  80126b:	83 c4 10             	add    $0x10,%esp
			return;
  80126e:	e9 95 00 00 00       	jmp    801308 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801273:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801277:	7e 34                	jle    8012ad <readline+0xa0>
  801279:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801280:	7f 2b                	jg     8012ad <readline+0xa0>
			if (echoing)
  801282:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801286:	74 0e                	je     801296 <readline+0x89>
				cputchar(c);
  801288:	83 ec 0c             	sub    $0xc,%esp
  80128b:	ff 75 ec             	pushl  -0x14(%ebp)
  80128e:	e8 68 f4 ff ff       	call   8006fb <cputchar>
  801293:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801296:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801299:	8d 50 01             	lea    0x1(%eax),%edx
  80129c:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80129f:	89 c2                	mov    %eax,%edx
  8012a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a4:	01 d0                	add    %edx,%eax
  8012a6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012a9:	88 10                	mov    %dl,(%eax)
  8012ab:	eb 56                	jmp    801303 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  8012ad:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8012b1:	75 1f                	jne    8012d2 <readline+0xc5>
  8012b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8012b7:	7e 19                	jle    8012d2 <readline+0xc5>
			if (echoing)
  8012b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012bd:	74 0e                	je     8012cd <readline+0xc0>
				cputchar(c);
  8012bf:	83 ec 0c             	sub    $0xc,%esp
  8012c2:	ff 75 ec             	pushl  -0x14(%ebp)
  8012c5:	e8 31 f4 ff ff       	call   8006fb <cputchar>
  8012ca:	83 c4 10             	add    $0x10,%esp

			i--;
  8012cd:	ff 4d f4             	decl   -0xc(%ebp)
  8012d0:	eb 31                	jmp    801303 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  8012d2:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8012d6:	74 0a                	je     8012e2 <readline+0xd5>
  8012d8:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8012dc:	0f 85 61 ff ff ff    	jne    801243 <readline+0x36>
			if (echoing)
  8012e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012e6:	74 0e                	je     8012f6 <readline+0xe9>
				cputchar(c);
  8012e8:	83 ec 0c             	sub    $0xc,%esp
  8012eb:	ff 75 ec             	pushl  -0x14(%ebp)
  8012ee:	e8 08 f4 ff ff       	call   8006fb <cputchar>
  8012f3:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8012f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fc:	01 d0                	add    %edx,%eax
  8012fe:	c6 00 00             	movb   $0x0,(%eax)
			return;
  801301:	eb 06                	jmp    801309 <readline+0xfc>
		}
	}
  801303:	e9 3b ff ff ff       	jmp    801243 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  801308:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  801309:	c9                   	leave  
  80130a:	c3                   	ret    

0080130b <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  80130b:	55                   	push   %ebp
  80130c:	89 e5                	mov    %esp,%ebp
  80130e:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801311:	e8 0d 0f 00 00       	call   802223 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  801316:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80131a:	74 13                	je     80132f <atomic_readline+0x24>
		cprintf("%s", prompt);
  80131c:	83 ec 08             	sub    $0x8,%esp
  80131f:	ff 75 08             	pushl  0x8(%ebp)
  801322:	68 d0 46 80 00       	push   $0x8046d0
  801327:	e8 5f f8 ff ff       	call   800b8b <cprintf>
  80132c:	83 c4 10             	add    $0x10,%esp

	i = 0;
  80132f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801336:	83 ec 0c             	sub    $0xc,%esp
  801339:	6a 00                	push   $0x0
  80133b:	e8 51 f4 ff ff       	call   800791 <iscons>
  801340:	83 c4 10             	add    $0x10,%esp
  801343:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801346:	e8 f8 f3 ff ff       	call   800743 <getchar>
  80134b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  80134e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801352:	79 23                	jns    801377 <atomic_readline+0x6c>
			if (c != -E_EOF)
  801354:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801358:	74 13                	je     80136d <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  80135a:	83 ec 08             	sub    $0x8,%esp
  80135d:	ff 75 ec             	pushl  -0x14(%ebp)
  801360:	68 d3 46 80 00       	push   $0x8046d3
  801365:	e8 21 f8 ff ff       	call   800b8b <cprintf>
  80136a:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  80136d:	e8 cb 0e 00 00       	call   80223d <sys_enable_interrupt>
			return;
  801372:	e9 9a 00 00 00       	jmp    801411 <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801377:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  80137b:	7e 34                	jle    8013b1 <atomic_readline+0xa6>
  80137d:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801384:	7f 2b                	jg     8013b1 <atomic_readline+0xa6>
			if (echoing)
  801386:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80138a:	74 0e                	je     80139a <atomic_readline+0x8f>
				cputchar(c);
  80138c:	83 ec 0c             	sub    $0xc,%esp
  80138f:	ff 75 ec             	pushl  -0x14(%ebp)
  801392:	e8 64 f3 ff ff       	call   8006fb <cputchar>
  801397:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  80139a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80139d:	8d 50 01             	lea    0x1(%eax),%edx
  8013a0:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8013a3:	89 c2                	mov    %eax,%edx
  8013a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a8:	01 d0                	add    %edx,%eax
  8013aa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013ad:	88 10                	mov    %dl,(%eax)
  8013af:	eb 5b                	jmp    80140c <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  8013b1:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8013b5:	75 1f                	jne    8013d6 <atomic_readline+0xcb>
  8013b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8013bb:	7e 19                	jle    8013d6 <atomic_readline+0xcb>
			if (echoing)
  8013bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013c1:	74 0e                	je     8013d1 <atomic_readline+0xc6>
				cputchar(c);
  8013c3:	83 ec 0c             	sub    $0xc,%esp
  8013c6:	ff 75 ec             	pushl  -0x14(%ebp)
  8013c9:	e8 2d f3 ff ff       	call   8006fb <cputchar>
  8013ce:	83 c4 10             	add    $0x10,%esp
			i--;
  8013d1:	ff 4d f4             	decl   -0xc(%ebp)
  8013d4:	eb 36                	jmp    80140c <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  8013d6:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8013da:	74 0a                	je     8013e6 <atomic_readline+0xdb>
  8013dc:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8013e0:	0f 85 60 ff ff ff    	jne    801346 <atomic_readline+0x3b>
			if (echoing)
  8013e6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013ea:	74 0e                	je     8013fa <atomic_readline+0xef>
				cputchar(c);
  8013ec:	83 ec 0c             	sub    $0xc,%esp
  8013ef:	ff 75 ec             	pushl  -0x14(%ebp)
  8013f2:	e8 04 f3 ff ff       	call   8006fb <cputchar>
  8013f7:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  8013fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801400:	01 d0                	add    %edx,%eax
  801402:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  801405:	e8 33 0e 00 00       	call   80223d <sys_enable_interrupt>
			return;
  80140a:	eb 05                	jmp    801411 <atomic_readline+0x106>
		}
	}
  80140c:	e9 35 ff ff ff       	jmp    801346 <atomic_readline+0x3b>
}
  801411:	c9                   	leave  
  801412:	c3                   	ret    

00801413 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801413:	55                   	push   %ebp
  801414:	89 e5                	mov    %esp,%ebp
  801416:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801419:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801420:	eb 06                	jmp    801428 <strlen+0x15>
		n++;
  801422:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801425:	ff 45 08             	incl   0x8(%ebp)
  801428:	8b 45 08             	mov    0x8(%ebp),%eax
  80142b:	8a 00                	mov    (%eax),%al
  80142d:	84 c0                	test   %al,%al
  80142f:	75 f1                	jne    801422 <strlen+0xf>
		n++;
	return n;
  801431:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801434:	c9                   	leave  
  801435:	c3                   	ret    

00801436 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801436:	55                   	push   %ebp
  801437:	89 e5                	mov    %esp,%ebp
  801439:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80143c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801443:	eb 09                	jmp    80144e <strnlen+0x18>
		n++;
  801445:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801448:	ff 45 08             	incl   0x8(%ebp)
  80144b:	ff 4d 0c             	decl   0xc(%ebp)
  80144e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801452:	74 09                	je     80145d <strnlen+0x27>
  801454:	8b 45 08             	mov    0x8(%ebp),%eax
  801457:	8a 00                	mov    (%eax),%al
  801459:	84 c0                	test   %al,%al
  80145b:	75 e8                	jne    801445 <strnlen+0xf>
		n++;
	return n;
  80145d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801460:	c9                   	leave  
  801461:	c3                   	ret    

00801462 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801462:	55                   	push   %ebp
  801463:	89 e5                	mov    %esp,%ebp
  801465:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801468:	8b 45 08             	mov    0x8(%ebp),%eax
  80146b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80146e:	90                   	nop
  80146f:	8b 45 08             	mov    0x8(%ebp),%eax
  801472:	8d 50 01             	lea    0x1(%eax),%edx
  801475:	89 55 08             	mov    %edx,0x8(%ebp)
  801478:	8b 55 0c             	mov    0xc(%ebp),%edx
  80147b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80147e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801481:	8a 12                	mov    (%edx),%dl
  801483:	88 10                	mov    %dl,(%eax)
  801485:	8a 00                	mov    (%eax),%al
  801487:	84 c0                	test   %al,%al
  801489:	75 e4                	jne    80146f <strcpy+0xd>
		/* do nothing */;
	return ret;
  80148b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80148e:	c9                   	leave  
  80148f:	c3                   	ret    

00801490 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801490:	55                   	push   %ebp
  801491:	89 e5                	mov    %esp,%ebp
  801493:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801496:	8b 45 08             	mov    0x8(%ebp),%eax
  801499:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80149c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014a3:	eb 1f                	jmp    8014c4 <strncpy+0x34>
		*dst++ = *src;
  8014a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a8:	8d 50 01             	lea    0x1(%eax),%edx
  8014ab:	89 55 08             	mov    %edx,0x8(%ebp)
  8014ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014b1:	8a 12                	mov    (%edx),%dl
  8014b3:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8014b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b8:	8a 00                	mov    (%eax),%al
  8014ba:	84 c0                	test   %al,%al
  8014bc:	74 03                	je     8014c1 <strncpy+0x31>
			src++;
  8014be:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8014c1:	ff 45 fc             	incl   -0x4(%ebp)
  8014c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014c7:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014ca:	72 d9                	jb     8014a5 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8014cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014cf:	c9                   	leave  
  8014d0:	c3                   	ret    

008014d1 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8014d1:	55                   	push   %ebp
  8014d2:	89 e5                	mov    %esp,%ebp
  8014d4:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8014d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014da:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8014dd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014e1:	74 30                	je     801513 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8014e3:	eb 16                	jmp    8014fb <strlcpy+0x2a>
			*dst++ = *src++;
  8014e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e8:	8d 50 01             	lea    0x1(%eax),%edx
  8014eb:	89 55 08             	mov    %edx,0x8(%ebp)
  8014ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014f1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014f4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8014f7:	8a 12                	mov    (%edx),%dl
  8014f9:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8014fb:	ff 4d 10             	decl   0x10(%ebp)
  8014fe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801502:	74 09                	je     80150d <strlcpy+0x3c>
  801504:	8b 45 0c             	mov    0xc(%ebp),%eax
  801507:	8a 00                	mov    (%eax),%al
  801509:	84 c0                	test   %al,%al
  80150b:	75 d8                	jne    8014e5 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80150d:	8b 45 08             	mov    0x8(%ebp),%eax
  801510:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801513:	8b 55 08             	mov    0x8(%ebp),%edx
  801516:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801519:	29 c2                	sub    %eax,%edx
  80151b:	89 d0                	mov    %edx,%eax
}
  80151d:	c9                   	leave  
  80151e:	c3                   	ret    

0080151f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80151f:	55                   	push   %ebp
  801520:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801522:	eb 06                	jmp    80152a <strcmp+0xb>
		p++, q++;
  801524:	ff 45 08             	incl   0x8(%ebp)
  801527:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80152a:	8b 45 08             	mov    0x8(%ebp),%eax
  80152d:	8a 00                	mov    (%eax),%al
  80152f:	84 c0                	test   %al,%al
  801531:	74 0e                	je     801541 <strcmp+0x22>
  801533:	8b 45 08             	mov    0x8(%ebp),%eax
  801536:	8a 10                	mov    (%eax),%dl
  801538:	8b 45 0c             	mov    0xc(%ebp),%eax
  80153b:	8a 00                	mov    (%eax),%al
  80153d:	38 c2                	cmp    %al,%dl
  80153f:	74 e3                	je     801524 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801541:	8b 45 08             	mov    0x8(%ebp),%eax
  801544:	8a 00                	mov    (%eax),%al
  801546:	0f b6 d0             	movzbl %al,%edx
  801549:	8b 45 0c             	mov    0xc(%ebp),%eax
  80154c:	8a 00                	mov    (%eax),%al
  80154e:	0f b6 c0             	movzbl %al,%eax
  801551:	29 c2                	sub    %eax,%edx
  801553:	89 d0                	mov    %edx,%eax
}
  801555:	5d                   	pop    %ebp
  801556:	c3                   	ret    

00801557 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801557:	55                   	push   %ebp
  801558:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80155a:	eb 09                	jmp    801565 <strncmp+0xe>
		n--, p++, q++;
  80155c:	ff 4d 10             	decl   0x10(%ebp)
  80155f:	ff 45 08             	incl   0x8(%ebp)
  801562:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801565:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801569:	74 17                	je     801582 <strncmp+0x2b>
  80156b:	8b 45 08             	mov    0x8(%ebp),%eax
  80156e:	8a 00                	mov    (%eax),%al
  801570:	84 c0                	test   %al,%al
  801572:	74 0e                	je     801582 <strncmp+0x2b>
  801574:	8b 45 08             	mov    0x8(%ebp),%eax
  801577:	8a 10                	mov    (%eax),%dl
  801579:	8b 45 0c             	mov    0xc(%ebp),%eax
  80157c:	8a 00                	mov    (%eax),%al
  80157e:	38 c2                	cmp    %al,%dl
  801580:	74 da                	je     80155c <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801582:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801586:	75 07                	jne    80158f <strncmp+0x38>
		return 0;
  801588:	b8 00 00 00 00       	mov    $0x0,%eax
  80158d:	eb 14                	jmp    8015a3 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80158f:	8b 45 08             	mov    0x8(%ebp),%eax
  801592:	8a 00                	mov    (%eax),%al
  801594:	0f b6 d0             	movzbl %al,%edx
  801597:	8b 45 0c             	mov    0xc(%ebp),%eax
  80159a:	8a 00                	mov    (%eax),%al
  80159c:	0f b6 c0             	movzbl %al,%eax
  80159f:	29 c2                	sub    %eax,%edx
  8015a1:	89 d0                	mov    %edx,%eax
}
  8015a3:	5d                   	pop    %ebp
  8015a4:	c3                   	ret    

008015a5 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8015a5:	55                   	push   %ebp
  8015a6:	89 e5                	mov    %esp,%ebp
  8015a8:	83 ec 04             	sub    $0x4,%esp
  8015ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ae:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015b1:	eb 12                	jmp    8015c5 <strchr+0x20>
		if (*s == c)
  8015b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b6:	8a 00                	mov    (%eax),%al
  8015b8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015bb:	75 05                	jne    8015c2 <strchr+0x1d>
			return (char *) s;
  8015bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c0:	eb 11                	jmp    8015d3 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8015c2:	ff 45 08             	incl   0x8(%ebp)
  8015c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c8:	8a 00                	mov    (%eax),%al
  8015ca:	84 c0                	test   %al,%al
  8015cc:	75 e5                	jne    8015b3 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8015ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015d3:	c9                   	leave  
  8015d4:	c3                   	ret    

008015d5 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8015d5:	55                   	push   %ebp
  8015d6:	89 e5                	mov    %esp,%ebp
  8015d8:	83 ec 04             	sub    $0x4,%esp
  8015db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015de:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015e1:	eb 0d                	jmp    8015f0 <strfind+0x1b>
		if (*s == c)
  8015e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e6:	8a 00                	mov    (%eax),%al
  8015e8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015eb:	74 0e                	je     8015fb <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8015ed:	ff 45 08             	incl   0x8(%ebp)
  8015f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f3:	8a 00                	mov    (%eax),%al
  8015f5:	84 c0                	test   %al,%al
  8015f7:	75 ea                	jne    8015e3 <strfind+0xe>
  8015f9:	eb 01                	jmp    8015fc <strfind+0x27>
		if (*s == c)
			break;
  8015fb:	90                   	nop
	return (char *) s;
  8015fc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015ff:	c9                   	leave  
  801600:	c3                   	ret    

00801601 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801601:	55                   	push   %ebp
  801602:	89 e5                	mov    %esp,%ebp
  801604:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801607:	8b 45 08             	mov    0x8(%ebp),%eax
  80160a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80160d:	8b 45 10             	mov    0x10(%ebp),%eax
  801610:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801613:	eb 0e                	jmp    801623 <memset+0x22>
		*p++ = c;
  801615:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801618:	8d 50 01             	lea    0x1(%eax),%edx
  80161b:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80161e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801621:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801623:	ff 4d f8             	decl   -0x8(%ebp)
  801626:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80162a:	79 e9                	jns    801615 <memset+0x14>
		*p++ = c;

	return v;
  80162c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80162f:	c9                   	leave  
  801630:	c3                   	ret    

00801631 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801631:	55                   	push   %ebp
  801632:	89 e5                	mov    %esp,%ebp
  801634:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801637:	8b 45 0c             	mov    0xc(%ebp),%eax
  80163a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80163d:	8b 45 08             	mov    0x8(%ebp),%eax
  801640:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801643:	eb 16                	jmp    80165b <memcpy+0x2a>
		*d++ = *s++;
  801645:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801648:	8d 50 01             	lea    0x1(%eax),%edx
  80164b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80164e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801651:	8d 4a 01             	lea    0x1(%edx),%ecx
  801654:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801657:	8a 12                	mov    (%edx),%dl
  801659:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80165b:	8b 45 10             	mov    0x10(%ebp),%eax
  80165e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801661:	89 55 10             	mov    %edx,0x10(%ebp)
  801664:	85 c0                	test   %eax,%eax
  801666:	75 dd                	jne    801645 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801668:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80166b:	c9                   	leave  
  80166c:	c3                   	ret    

0080166d <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80166d:	55                   	push   %ebp
  80166e:	89 e5                	mov    %esp,%ebp
  801670:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801673:	8b 45 0c             	mov    0xc(%ebp),%eax
  801676:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801679:	8b 45 08             	mov    0x8(%ebp),%eax
  80167c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80167f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801682:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801685:	73 50                	jae    8016d7 <memmove+0x6a>
  801687:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80168a:	8b 45 10             	mov    0x10(%ebp),%eax
  80168d:	01 d0                	add    %edx,%eax
  80168f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801692:	76 43                	jbe    8016d7 <memmove+0x6a>
		s += n;
  801694:	8b 45 10             	mov    0x10(%ebp),%eax
  801697:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80169a:	8b 45 10             	mov    0x10(%ebp),%eax
  80169d:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8016a0:	eb 10                	jmp    8016b2 <memmove+0x45>
			*--d = *--s;
  8016a2:	ff 4d f8             	decl   -0x8(%ebp)
  8016a5:	ff 4d fc             	decl   -0x4(%ebp)
  8016a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016ab:	8a 10                	mov    (%eax),%dl
  8016ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016b0:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8016b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016b8:	89 55 10             	mov    %edx,0x10(%ebp)
  8016bb:	85 c0                	test   %eax,%eax
  8016bd:	75 e3                	jne    8016a2 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8016bf:	eb 23                	jmp    8016e4 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8016c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016c4:	8d 50 01             	lea    0x1(%eax),%edx
  8016c7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016cd:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016d0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8016d3:	8a 12                	mov    (%edx),%dl
  8016d5:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8016d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8016da:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016dd:	89 55 10             	mov    %edx,0x10(%ebp)
  8016e0:	85 c0                	test   %eax,%eax
  8016e2:	75 dd                	jne    8016c1 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8016e4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016e7:	c9                   	leave  
  8016e8:	c3                   	ret    

008016e9 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8016e9:	55                   	push   %ebp
  8016ea:	89 e5                	mov    %esp,%ebp
  8016ec:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8016ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8016f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f8:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8016fb:	eb 2a                	jmp    801727 <memcmp+0x3e>
		if (*s1 != *s2)
  8016fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801700:	8a 10                	mov    (%eax),%dl
  801702:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801705:	8a 00                	mov    (%eax),%al
  801707:	38 c2                	cmp    %al,%dl
  801709:	74 16                	je     801721 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80170b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80170e:	8a 00                	mov    (%eax),%al
  801710:	0f b6 d0             	movzbl %al,%edx
  801713:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801716:	8a 00                	mov    (%eax),%al
  801718:	0f b6 c0             	movzbl %al,%eax
  80171b:	29 c2                	sub    %eax,%edx
  80171d:	89 d0                	mov    %edx,%eax
  80171f:	eb 18                	jmp    801739 <memcmp+0x50>
		s1++, s2++;
  801721:	ff 45 fc             	incl   -0x4(%ebp)
  801724:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801727:	8b 45 10             	mov    0x10(%ebp),%eax
  80172a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80172d:	89 55 10             	mov    %edx,0x10(%ebp)
  801730:	85 c0                	test   %eax,%eax
  801732:	75 c9                	jne    8016fd <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801734:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801739:	c9                   	leave  
  80173a:	c3                   	ret    

0080173b <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80173b:	55                   	push   %ebp
  80173c:	89 e5                	mov    %esp,%ebp
  80173e:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801741:	8b 55 08             	mov    0x8(%ebp),%edx
  801744:	8b 45 10             	mov    0x10(%ebp),%eax
  801747:	01 d0                	add    %edx,%eax
  801749:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80174c:	eb 15                	jmp    801763 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80174e:	8b 45 08             	mov    0x8(%ebp),%eax
  801751:	8a 00                	mov    (%eax),%al
  801753:	0f b6 d0             	movzbl %al,%edx
  801756:	8b 45 0c             	mov    0xc(%ebp),%eax
  801759:	0f b6 c0             	movzbl %al,%eax
  80175c:	39 c2                	cmp    %eax,%edx
  80175e:	74 0d                	je     80176d <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801760:	ff 45 08             	incl   0x8(%ebp)
  801763:	8b 45 08             	mov    0x8(%ebp),%eax
  801766:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801769:	72 e3                	jb     80174e <memfind+0x13>
  80176b:	eb 01                	jmp    80176e <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80176d:	90                   	nop
	return (void *) s;
  80176e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801771:	c9                   	leave  
  801772:	c3                   	ret    

00801773 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801773:	55                   	push   %ebp
  801774:	89 e5                	mov    %esp,%ebp
  801776:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801779:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801780:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801787:	eb 03                	jmp    80178c <strtol+0x19>
		s++;
  801789:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80178c:	8b 45 08             	mov    0x8(%ebp),%eax
  80178f:	8a 00                	mov    (%eax),%al
  801791:	3c 20                	cmp    $0x20,%al
  801793:	74 f4                	je     801789 <strtol+0x16>
  801795:	8b 45 08             	mov    0x8(%ebp),%eax
  801798:	8a 00                	mov    (%eax),%al
  80179a:	3c 09                	cmp    $0x9,%al
  80179c:	74 eb                	je     801789 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80179e:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a1:	8a 00                	mov    (%eax),%al
  8017a3:	3c 2b                	cmp    $0x2b,%al
  8017a5:	75 05                	jne    8017ac <strtol+0x39>
		s++;
  8017a7:	ff 45 08             	incl   0x8(%ebp)
  8017aa:	eb 13                	jmp    8017bf <strtol+0x4c>
	else if (*s == '-')
  8017ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8017af:	8a 00                	mov    (%eax),%al
  8017b1:	3c 2d                	cmp    $0x2d,%al
  8017b3:	75 0a                	jne    8017bf <strtol+0x4c>
		s++, neg = 1;
  8017b5:	ff 45 08             	incl   0x8(%ebp)
  8017b8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017bf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017c3:	74 06                	je     8017cb <strtol+0x58>
  8017c5:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8017c9:	75 20                	jne    8017eb <strtol+0x78>
  8017cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ce:	8a 00                	mov    (%eax),%al
  8017d0:	3c 30                	cmp    $0x30,%al
  8017d2:	75 17                	jne    8017eb <strtol+0x78>
  8017d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d7:	40                   	inc    %eax
  8017d8:	8a 00                	mov    (%eax),%al
  8017da:	3c 78                	cmp    $0x78,%al
  8017dc:	75 0d                	jne    8017eb <strtol+0x78>
		s += 2, base = 16;
  8017de:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8017e2:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8017e9:	eb 28                	jmp    801813 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8017eb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017ef:	75 15                	jne    801806 <strtol+0x93>
  8017f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f4:	8a 00                	mov    (%eax),%al
  8017f6:	3c 30                	cmp    $0x30,%al
  8017f8:	75 0c                	jne    801806 <strtol+0x93>
		s++, base = 8;
  8017fa:	ff 45 08             	incl   0x8(%ebp)
  8017fd:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801804:	eb 0d                	jmp    801813 <strtol+0xa0>
	else if (base == 0)
  801806:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80180a:	75 07                	jne    801813 <strtol+0xa0>
		base = 10;
  80180c:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801813:	8b 45 08             	mov    0x8(%ebp),%eax
  801816:	8a 00                	mov    (%eax),%al
  801818:	3c 2f                	cmp    $0x2f,%al
  80181a:	7e 19                	jle    801835 <strtol+0xc2>
  80181c:	8b 45 08             	mov    0x8(%ebp),%eax
  80181f:	8a 00                	mov    (%eax),%al
  801821:	3c 39                	cmp    $0x39,%al
  801823:	7f 10                	jg     801835 <strtol+0xc2>
			dig = *s - '0';
  801825:	8b 45 08             	mov    0x8(%ebp),%eax
  801828:	8a 00                	mov    (%eax),%al
  80182a:	0f be c0             	movsbl %al,%eax
  80182d:	83 e8 30             	sub    $0x30,%eax
  801830:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801833:	eb 42                	jmp    801877 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801835:	8b 45 08             	mov    0x8(%ebp),%eax
  801838:	8a 00                	mov    (%eax),%al
  80183a:	3c 60                	cmp    $0x60,%al
  80183c:	7e 19                	jle    801857 <strtol+0xe4>
  80183e:	8b 45 08             	mov    0x8(%ebp),%eax
  801841:	8a 00                	mov    (%eax),%al
  801843:	3c 7a                	cmp    $0x7a,%al
  801845:	7f 10                	jg     801857 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801847:	8b 45 08             	mov    0x8(%ebp),%eax
  80184a:	8a 00                	mov    (%eax),%al
  80184c:	0f be c0             	movsbl %al,%eax
  80184f:	83 e8 57             	sub    $0x57,%eax
  801852:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801855:	eb 20                	jmp    801877 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801857:	8b 45 08             	mov    0x8(%ebp),%eax
  80185a:	8a 00                	mov    (%eax),%al
  80185c:	3c 40                	cmp    $0x40,%al
  80185e:	7e 39                	jle    801899 <strtol+0x126>
  801860:	8b 45 08             	mov    0x8(%ebp),%eax
  801863:	8a 00                	mov    (%eax),%al
  801865:	3c 5a                	cmp    $0x5a,%al
  801867:	7f 30                	jg     801899 <strtol+0x126>
			dig = *s - 'A' + 10;
  801869:	8b 45 08             	mov    0x8(%ebp),%eax
  80186c:	8a 00                	mov    (%eax),%al
  80186e:	0f be c0             	movsbl %al,%eax
  801871:	83 e8 37             	sub    $0x37,%eax
  801874:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801877:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80187a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80187d:	7d 19                	jge    801898 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80187f:	ff 45 08             	incl   0x8(%ebp)
  801882:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801885:	0f af 45 10          	imul   0x10(%ebp),%eax
  801889:	89 c2                	mov    %eax,%edx
  80188b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80188e:	01 d0                	add    %edx,%eax
  801890:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801893:	e9 7b ff ff ff       	jmp    801813 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801898:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801899:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80189d:	74 08                	je     8018a7 <strtol+0x134>
		*endptr = (char *) s;
  80189f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8018a5:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8018a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018ab:	74 07                	je     8018b4 <strtol+0x141>
  8018ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018b0:	f7 d8                	neg    %eax
  8018b2:	eb 03                	jmp    8018b7 <strtol+0x144>
  8018b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8018b7:	c9                   	leave  
  8018b8:	c3                   	ret    

008018b9 <ltostr>:

void
ltostr(long value, char *str)
{
  8018b9:	55                   	push   %ebp
  8018ba:	89 e5                	mov    %esp,%ebp
  8018bc:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8018bf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8018c6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8018cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018d1:	79 13                	jns    8018e6 <ltostr+0x2d>
	{
		neg = 1;
  8018d3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8018da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018dd:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8018e0:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8018e3:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8018e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e9:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8018ee:	99                   	cltd   
  8018ef:	f7 f9                	idiv   %ecx
  8018f1:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8018f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018f7:	8d 50 01             	lea    0x1(%eax),%edx
  8018fa:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018fd:	89 c2                	mov    %eax,%edx
  8018ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801902:	01 d0                	add    %edx,%eax
  801904:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801907:	83 c2 30             	add    $0x30,%edx
  80190a:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80190c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80190f:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801914:	f7 e9                	imul   %ecx
  801916:	c1 fa 02             	sar    $0x2,%edx
  801919:	89 c8                	mov    %ecx,%eax
  80191b:	c1 f8 1f             	sar    $0x1f,%eax
  80191e:	29 c2                	sub    %eax,%edx
  801920:	89 d0                	mov    %edx,%eax
  801922:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801925:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801928:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80192d:	f7 e9                	imul   %ecx
  80192f:	c1 fa 02             	sar    $0x2,%edx
  801932:	89 c8                	mov    %ecx,%eax
  801934:	c1 f8 1f             	sar    $0x1f,%eax
  801937:	29 c2                	sub    %eax,%edx
  801939:	89 d0                	mov    %edx,%eax
  80193b:	c1 e0 02             	shl    $0x2,%eax
  80193e:	01 d0                	add    %edx,%eax
  801940:	01 c0                	add    %eax,%eax
  801942:	29 c1                	sub    %eax,%ecx
  801944:	89 ca                	mov    %ecx,%edx
  801946:	85 d2                	test   %edx,%edx
  801948:	75 9c                	jne    8018e6 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80194a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801951:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801954:	48                   	dec    %eax
  801955:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801958:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80195c:	74 3d                	je     80199b <ltostr+0xe2>
		start = 1 ;
  80195e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801965:	eb 34                	jmp    80199b <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801967:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80196a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80196d:	01 d0                	add    %edx,%eax
  80196f:	8a 00                	mov    (%eax),%al
  801971:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801974:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801977:	8b 45 0c             	mov    0xc(%ebp),%eax
  80197a:	01 c2                	add    %eax,%edx
  80197c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80197f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801982:	01 c8                	add    %ecx,%eax
  801984:	8a 00                	mov    (%eax),%al
  801986:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801988:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80198b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80198e:	01 c2                	add    %eax,%edx
  801990:	8a 45 eb             	mov    -0x15(%ebp),%al
  801993:	88 02                	mov    %al,(%edx)
		start++ ;
  801995:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801998:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80199b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80199e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019a1:	7c c4                	jl     801967 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8019a3:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8019a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a9:	01 d0                	add    %edx,%eax
  8019ab:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8019ae:	90                   	nop
  8019af:	c9                   	leave  
  8019b0:	c3                   	ret    

008019b1 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8019b1:	55                   	push   %ebp
  8019b2:	89 e5                	mov    %esp,%ebp
  8019b4:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8019b7:	ff 75 08             	pushl  0x8(%ebp)
  8019ba:	e8 54 fa ff ff       	call   801413 <strlen>
  8019bf:	83 c4 04             	add    $0x4,%esp
  8019c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8019c5:	ff 75 0c             	pushl  0xc(%ebp)
  8019c8:	e8 46 fa ff ff       	call   801413 <strlen>
  8019cd:	83 c4 04             	add    $0x4,%esp
  8019d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8019d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8019da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8019e1:	eb 17                	jmp    8019fa <strcconcat+0x49>
		final[s] = str1[s] ;
  8019e3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8019e9:	01 c2                	add    %eax,%edx
  8019eb:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8019ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f1:	01 c8                	add    %ecx,%eax
  8019f3:	8a 00                	mov    (%eax),%al
  8019f5:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8019f7:	ff 45 fc             	incl   -0x4(%ebp)
  8019fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019fd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801a00:	7c e1                	jl     8019e3 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801a02:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801a09:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801a10:	eb 1f                	jmp    801a31 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801a12:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a15:	8d 50 01             	lea    0x1(%eax),%edx
  801a18:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801a1b:	89 c2                	mov    %eax,%edx
  801a1d:	8b 45 10             	mov    0x10(%ebp),%eax
  801a20:	01 c2                	add    %eax,%edx
  801a22:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801a25:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a28:	01 c8                	add    %ecx,%eax
  801a2a:	8a 00                	mov    (%eax),%al
  801a2c:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801a2e:	ff 45 f8             	incl   -0x8(%ebp)
  801a31:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a34:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a37:	7c d9                	jl     801a12 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801a39:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a3c:	8b 45 10             	mov    0x10(%ebp),%eax
  801a3f:	01 d0                	add    %edx,%eax
  801a41:	c6 00 00             	movb   $0x0,(%eax)
}
  801a44:	90                   	nop
  801a45:	c9                   	leave  
  801a46:	c3                   	ret    

00801a47 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801a4a:	8b 45 14             	mov    0x14(%ebp),%eax
  801a4d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801a53:	8b 45 14             	mov    0x14(%ebp),%eax
  801a56:	8b 00                	mov    (%eax),%eax
  801a58:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a5f:	8b 45 10             	mov    0x10(%ebp),%eax
  801a62:	01 d0                	add    %edx,%eax
  801a64:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a6a:	eb 0c                	jmp    801a78 <strsplit+0x31>
			*string++ = 0;
  801a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6f:	8d 50 01             	lea    0x1(%eax),%edx
  801a72:	89 55 08             	mov    %edx,0x8(%ebp)
  801a75:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a78:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7b:	8a 00                	mov    (%eax),%al
  801a7d:	84 c0                	test   %al,%al
  801a7f:	74 18                	je     801a99 <strsplit+0x52>
  801a81:	8b 45 08             	mov    0x8(%ebp),%eax
  801a84:	8a 00                	mov    (%eax),%al
  801a86:	0f be c0             	movsbl %al,%eax
  801a89:	50                   	push   %eax
  801a8a:	ff 75 0c             	pushl  0xc(%ebp)
  801a8d:	e8 13 fb ff ff       	call   8015a5 <strchr>
  801a92:	83 c4 08             	add    $0x8,%esp
  801a95:	85 c0                	test   %eax,%eax
  801a97:	75 d3                	jne    801a6c <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a99:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9c:	8a 00                	mov    (%eax),%al
  801a9e:	84 c0                	test   %al,%al
  801aa0:	74 5a                	je     801afc <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801aa2:	8b 45 14             	mov    0x14(%ebp),%eax
  801aa5:	8b 00                	mov    (%eax),%eax
  801aa7:	83 f8 0f             	cmp    $0xf,%eax
  801aaa:	75 07                	jne    801ab3 <strsplit+0x6c>
		{
			return 0;
  801aac:	b8 00 00 00 00       	mov    $0x0,%eax
  801ab1:	eb 66                	jmp    801b19 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801ab3:	8b 45 14             	mov    0x14(%ebp),%eax
  801ab6:	8b 00                	mov    (%eax),%eax
  801ab8:	8d 48 01             	lea    0x1(%eax),%ecx
  801abb:	8b 55 14             	mov    0x14(%ebp),%edx
  801abe:	89 0a                	mov    %ecx,(%edx)
  801ac0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ac7:	8b 45 10             	mov    0x10(%ebp),%eax
  801aca:	01 c2                	add    %eax,%edx
  801acc:	8b 45 08             	mov    0x8(%ebp),%eax
  801acf:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ad1:	eb 03                	jmp    801ad6 <strsplit+0x8f>
			string++;
  801ad3:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad9:	8a 00                	mov    (%eax),%al
  801adb:	84 c0                	test   %al,%al
  801add:	74 8b                	je     801a6a <strsplit+0x23>
  801adf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae2:	8a 00                	mov    (%eax),%al
  801ae4:	0f be c0             	movsbl %al,%eax
  801ae7:	50                   	push   %eax
  801ae8:	ff 75 0c             	pushl  0xc(%ebp)
  801aeb:	e8 b5 fa ff ff       	call   8015a5 <strchr>
  801af0:	83 c4 08             	add    $0x8,%esp
  801af3:	85 c0                	test   %eax,%eax
  801af5:	74 dc                	je     801ad3 <strsplit+0x8c>
			string++;
	}
  801af7:	e9 6e ff ff ff       	jmp    801a6a <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801afc:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801afd:	8b 45 14             	mov    0x14(%ebp),%eax
  801b00:	8b 00                	mov    (%eax),%eax
  801b02:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b09:	8b 45 10             	mov    0x10(%ebp),%eax
  801b0c:	01 d0                	add    %edx,%eax
  801b0e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801b14:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801b19:	c9                   	leave  
  801b1a:	c3                   	ret    

00801b1b <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801b1b:	55                   	push   %ebp
  801b1c:	89 e5                	mov    %esp,%ebp
  801b1e:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801b21:	a1 04 50 80 00       	mov    0x805004,%eax
  801b26:	85 c0                	test   %eax,%eax
  801b28:	74 1f                	je     801b49 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801b2a:	e8 1d 00 00 00       	call   801b4c <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801b2f:	83 ec 0c             	sub    $0xc,%esp
  801b32:	68 e4 46 80 00       	push   $0x8046e4
  801b37:	e8 4f f0 ff ff       	call   800b8b <cprintf>
  801b3c:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801b3f:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801b46:	00 00 00 
	}
}
  801b49:	90                   	nop
  801b4a:	c9                   	leave  
  801b4b:	c3                   	ret    

00801b4c <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801b4c:	55                   	push   %ebp
  801b4d:	89 e5                	mov    %esp,%ebp
  801b4f:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  801b52:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801b59:	00 00 00 
  801b5c:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801b63:	00 00 00 
  801b66:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801b6d:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801b70:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801b77:	00 00 00 
  801b7a:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801b81:	00 00 00 
  801b84:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801b8b:	00 00 00 
	uint32 arr_size = 0;
  801b8e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  801b95:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801b9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b9f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801ba4:	2d 00 10 00 00       	sub    $0x1000,%eax
  801ba9:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  801bae:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801bb5:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  801bb8:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801bbf:	a1 20 51 80 00       	mov    0x805120,%eax
  801bc4:	c1 e0 04             	shl    $0x4,%eax
  801bc7:	89 c2                	mov    %eax,%edx
  801bc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bcc:	01 d0                	add    %edx,%eax
  801bce:	48                   	dec    %eax
  801bcf:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801bd2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bd5:	ba 00 00 00 00       	mov    $0x0,%edx
  801bda:	f7 75 ec             	divl   -0x14(%ebp)
  801bdd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801be0:	29 d0                	sub    %edx,%eax
  801be2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  801be5:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801bec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bef:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801bf4:	2d 00 10 00 00       	sub    $0x1000,%eax
  801bf9:	83 ec 04             	sub    $0x4,%esp
  801bfc:	6a 06                	push   $0x6
  801bfe:	ff 75 f4             	pushl  -0xc(%ebp)
  801c01:	50                   	push   %eax
  801c02:	e8 b2 05 00 00       	call   8021b9 <sys_allocate_chunk>
  801c07:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801c0a:	a1 20 51 80 00       	mov    0x805120,%eax
  801c0f:	83 ec 0c             	sub    $0xc,%esp
  801c12:	50                   	push   %eax
  801c13:	e8 27 0c 00 00       	call   80283f <initialize_MemBlocksList>
  801c18:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  801c1b:	a1 48 51 80 00       	mov    0x805148,%eax
  801c20:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  801c23:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c26:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  801c2d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c30:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  801c37:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c3b:	75 14                	jne    801c51 <initialize_dyn_block_system+0x105>
  801c3d:	83 ec 04             	sub    $0x4,%esp
  801c40:	68 09 47 80 00       	push   $0x804709
  801c45:	6a 33                	push   $0x33
  801c47:	68 27 47 80 00       	push   $0x804727
  801c4c:	e8 86 ec ff ff       	call   8008d7 <_panic>
  801c51:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c54:	8b 00                	mov    (%eax),%eax
  801c56:	85 c0                	test   %eax,%eax
  801c58:	74 10                	je     801c6a <initialize_dyn_block_system+0x11e>
  801c5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c5d:	8b 00                	mov    (%eax),%eax
  801c5f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c62:	8b 52 04             	mov    0x4(%edx),%edx
  801c65:	89 50 04             	mov    %edx,0x4(%eax)
  801c68:	eb 0b                	jmp    801c75 <initialize_dyn_block_system+0x129>
  801c6a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c6d:	8b 40 04             	mov    0x4(%eax),%eax
  801c70:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801c75:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c78:	8b 40 04             	mov    0x4(%eax),%eax
  801c7b:	85 c0                	test   %eax,%eax
  801c7d:	74 0f                	je     801c8e <initialize_dyn_block_system+0x142>
  801c7f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c82:	8b 40 04             	mov    0x4(%eax),%eax
  801c85:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c88:	8b 12                	mov    (%edx),%edx
  801c8a:	89 10                	mov    %edx,(%eax)
  801c8c:	eb 0a                	jmp    801c98 <initialize_dyn_block_system+0x14c>
  801c8e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c91:	8b 00                	mov    (%eax),%eax
  801c93:	a3 48 51 80 00       	mov    %eax,0x805148
  801c98:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c9b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ca1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ca4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801cab:	a1 54 51 80 00       	mov    0x805154,%eax
  801cb0:	48                   	dec    %eax
  801cb1:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  801cb6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801cba:	75 14                	jne    801cd0 <initialize_dyn_block_system+0x184>
  801cbc:	83 ec 04             	sub    $0x4,%esp
  801cbf:	68 34 47 80 00       	push   $0x804734
  801cc4:	6a 34                	push   $0x34
  801cc6:	68 27 47 80 00       	push   $0x804727
  801ccb:	e8 07 ec ff ff       	call   8008d7 <_panic>
  801cd0:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801cd6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cd9:	89 10                	mov    %edx,(%eax)
  801cdb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cde:	8b 00                	mov    (%eax),%eax
  801ce0:	85 c0                	test   %eax,%eax
  801ce2:	74 0d                	je     801cf1 <initialize_dyn_block_system+0x1a5>
  801ce4:	a1 38 51 80 00       	mov    0x805138,%eax
  801ce9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801cec:	89 50 04             	mov    %edx,0x4(%eax)
  801cef:	eb 08                	jmp    801cf9 <initialize_dyn_block_system+0x1ad>
  801cf1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cf4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801cf9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cfc:	a3 38 51 80 00       	mov    %eax,0x805138
  801d01:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d04:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801d0b:	a1 44 51 80 00       	mov    0x805144,%eax
  801d10:	40                   	inc    %eax
  801d11:	a3 44 51 80 00       	mov    %eax,0x805144
}
  801d16:	90                   	nop
  801d17:	c9                   	leave  
  801d18:	c3                   	ret    

00801d19 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801d19:	55                   	push   %ebp
  801d1a:	89 e5                	mov    %esp,%ebp
  801d1c:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d1f:	e8 f7 fd ff ff       	call   801b1b <InitializeUHeap>
	if (size == 0) return NULL ;
  801d24:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d28:	75 07                	jne    801d31 <malloc+0x18>
  801d2a:	b8 00 00 00 00       	mov    $0x0,%eax
  801d2f:	eb 61                	jmp    801d92 <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  801d31:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801d38:	8b 55 08             	mov    0x8(%ebp),%edx
  801d3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d3e:	01 d0                	add    %edx,%eax
  801d40:	48                   	dec    %eax
  801d41:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801d44:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d47:	ba 00 00 00 00       	mov    $0x0,%edx
  801d4c:	f7 75 f0             	divl   -0x10(%ebp)
  801d4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d52:	29 d0                	sub    %edx,%eax
  801d54:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801d57:	e8 2b 08 00 00       	call   802587 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d5c:	85 c0                	test   %eax,%eax
  801d5e:	74 11                	je     801d71 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801d60:	83 ec 0c             	sub    $0xc,%esp
  801d63:	ff 75 e8             	pushl  -0x18(%ebp)
  801d66:	e8 96 0e 00 00       	call   802c01 <alloc_block_FF>
  801d6b:	83 c4 10             	add    $0x10,%esp
  801d6e:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  801d71:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d75:	74 16                	je     801d8d <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  801d77:	83 ec 0c             	sub    $0xc,%esp
  801d7a:	ff 75 f4             	pushl  -0xc(%ebp)
  801d7d:	e8 f2 0b 00 00       	call   802974 <insert_sorted_allocList>
  801d82:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  801d85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d88:	8b 40 08             	mov    0x8(%eax),%eax
  801d8b:	eb 05                	jmp    801d92 <malloc+0x79>
	}

    return NULL;
  801d8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d92:	c9                   	leave  
  801d93:	c3                   	ret    

00801d94 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801d94:	55                   	push   %ebp
  801d95:	89 e5                	mov    %esp,%ebp
  801d97:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9d:	83 ec 08             	sub    $0x8,%esp
  801da0:	50                   	push   %eax
  801da1:	68 40 50 80 00       	push   $0x805040
  801da6:	e8 71 0b 00 00       	call   80291c <find_block>
  801dab:	83 c4 10             	add    $0x10,%esp
  801dae:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(free_block!=NULL)
  801db1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801db5:	0f 84 a6 00 00 00    	je     801e61 <free+0xcd>
	{
		sys_free_user_mem(free_block->sva,free_block->size);
  801dbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dbe:	8b 50 0c             	mov    0xc(%eax),%edx
  801dc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc4:	8b 40 08             	mov    0x8(%eax),%eax
  801dc7:	83 ec 08             	sub    $0x8,%esp
  801dca:	52                   	push   %edx
  801dcb:	50                   	push   %eax
  801dcc:	e8 b0 03 00 00       	call   802181 <sys_free_user_mem>
  801dd1:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,free_block);
  801dd4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dd8:	75 14                	jne    801dee <free+0x5a>
  801dda:	83 ec 04             	sub    $0x4,%esp
  801ddd:	68 09 47 80 00       	push   $0x804709
  801de2:	6a 74                	push   $0x74
  801de4:	68 27 47 80 00       	push   $0x804727
  801de9:	e8 e9 ea ff ff       	call   8008d7 <_panic>
  801dee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df1:	8b 00                	mov    (%eax),%eax
  801df3:	85 c0                	test   %eax,%eax
  801df5:	74 10                	je     801e07 <free+0x73>
  801df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dfa:	8b 00                	mov    (%eax),%eax
  801dfc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dff:	8b 52 04             	mov    0x4(%edx),%edx
  801e02:	89 50 04             	mov    %edx,0x4(%eax)
  801e05:	eb 0b                	jmp    801e12 <free+0x7e>
  801e07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e0a:	8b 40 04             	mov    0x4(%eax),%eax
  801e0d:	a3 44 50 80 00       	mov    %eax,0x805044
  801e12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e15:	8b 40 04             	mov    0x4(%eax),%eax
  801e18:	85 c0                	test   %eax,%eax
  801e1a:	74 0f                	je     801e2b <free+0x97>
  801e1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e1f:	8b 40 04             	mov    0x4(%eax),%eax
  801e22:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e25:	8b 12                	mov    (%edx),%edx
  801e27:	89 10                	mov    %edx,(%eax)
  801e29:	eb 0a                	jmp    801e35 <free+0xa1>
  801e2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e2e:	8b 00                	mov    (%eax),%eax
  801e30:	a3 40 50 80 00       	mov    %eax,0x805040
  801e35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e38:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e41:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e48:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801e4d:	48                   	dec    %eax
  801e4e:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(free_block);
  801e53:	83 ec 0c             	sub    $0xc,%esp
  801e56:	ff 75 f4             	pushl  -0xc(%ebp)
  801e59:	e8 4e 17 00 00       	call   8035ac <insert_sorted_with_merge_freeList>
  801e5e:	83 c4 10             	add    $0x10,%esp
	}

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801e61:	90                   	nop
  801e62:	c9                   	leave  
  801e63:	c3                   	ret    

00801e64 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801e64:	55                   	push   %ebp
  801e65:	89 e5                	mov    %esp,%ebp
  801e67:	83 ec 38             	sub    $0x38,%esp
  801e6a:	8b 45 10             	mov    0x10(%ebp),%eax
  801e6d:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e70:	e8 a6 fc ff ff       	call   801b1b <InitializeUHeap>
	if (size == 0) return NULL ;
  801e75:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e79:	75 0a                	jne    801e85 <smalloc+0x21>
  801e7b:	b8 00 00 00 00       	mov    $0x0,%eax
  801e80:	e9 8b 00 00 00       	jmp    801f10 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801e85:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801e8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e92:	01 d0                	add    %edx,%eax
  801e94:	48                   	dec    %eax
  801e95:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801e98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e9b:	ba 00 00 00 00       	mov    $0x0,%edx
  801ea0:	f7 75 f0             	divl   -0x10(%ebp)
  801ea3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ea6:	29 d0                	sub    %edx,%eax
  801ea8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801eab:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801eb2:	e8 d0 06 00 00       	call   802587 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801eb7:	85 c0                	test   %eax,%eax
  801eb9:	74 11                	je     801ecc <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801ebb:	83 ec 0c             	sub    $0xc,%esp
  801ebe:	ff 75 e8             	pushl  -0x18(%ebp)
  801ec1:	e8 3b 0d 00 00       	call   802c01 <alloc_block_FF>
  801ec6:	83 c4 10             	add    $0x10,%esp
  801ec9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  801ecc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ed0:	74 39                	je     801f0b <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed5:	8b 40 08             	mov    0x8(%eax),%eax
  801ed8:	89 c2                	mov    %eax,%edx
  801eda:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801ede:	52                   	push   %edx
  801edf:	50                   	push   %eax
  801ee0:	ff 75 0c             	pushl  0xc(%ebp)
  801ee3:	ff 75 08             	pushl  0x8(%ebp)
  801ee6:	e8 21 04 00 00       	call   80230c <sys_createSharedObject>
  801eeb:	83 c4 10             	add    $0x10,%esp
  801eee:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801ef1:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801ef5:	74 14                	je     801f0b <smalloc+0xa7>
  801ef7:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801efb:	74 0e                	je     801f0b <smalloc+0xa7>
  801efd:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801f01:	74 08                	je     801f0b <smalloc+0xa7>
			return (void*) mem_block->sva;
  801f03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f06:	8b 40 08             	mov    0x8(%eax),%eax
  801f09:	eb 05                	jmp    801f10 <smalloc+0xac>
	}
	return NULL;
  801f0b:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801f10:	c9                   	leave  
  801f11:	c3                   	ret    

00801f12 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801f12:	55                   	push   %ebp
  801f13:	89 e5                	mov    %esp,%ebp
  801f15:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f18:	e8 fe fb ff ff       	call   801b1b <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801f1d:	83 ec 08             	sub    $0x8,%esp
  801f20:	ff 75 0c             	pushl  0xc(%ebp)
  801f23:	ff 75 08             	pushl  0x8(%ebp)
  801f26:	e8 0b 04 00 00       	call   802336 <sys_getSizeOfSharedObject>
  801f2b:	83 c4 10             	add    $0x10,%esp
  801f2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  801f31:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  801f35:	74 76                	je     801fad <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801f37:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801f3e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f44:	01 d0                	add    %edx,%eax
  801f46:	48                   	dec    %eax
  801f47:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801f4a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f4d:	ba 00 00 00 00       	mov    $0x0,%edx
  801f52:	f7 75 ec             	divl   -0x14(%ebp)
  801f55:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f58:	29 d0                	sub    %edx,%eax
  801f5a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801f5d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801f64:	e8 1e 06 00 00       	call   802587 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801f69:	85 c0                	test   %eax,%eax
  801f6b:	74 11                	je     801f7e <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801f6d:	83 ec 0c             	sub    $0xc,%esp
  801f70:	ff 75 e4             	pushl  -0x1c(%ebp)
  801f73:	e8 89 0c 00 00       	call   802c01 <alloc_block_FF>
  801f78:	83 c4 10             	add    $0x10,%esp
  801f7b:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  801f7e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f82:	74 29                	je     801fad <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801f84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f87:	8b 40 08             	mov    0x8(%eax),%eax
  801f8a:	83 ec 04             	sub    $0x4,%esp
  801f8d:	50                   	push   %eax
  801f8e:	ff 75 0c             	pushl  0xc(%ebp)
  801f91:	ff 75 08             	pushl  0x8(%ebp)
  801f94:	e8 ba 03 00 00       	call   802353 <sys_getSharedObject>
  801f99:	83 c4 10             	add    $0x10,%esp
  801f9c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  801f9f:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  801fa3:	74 08                	je     801fad <sget+0x9b>
				return (void *)mem_block->sva;
  801fa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa8:	8b 40 08             	mov    0x8(%eax),%eax
  801fab:	eb 05                	jmp    801fb2 <sget+0xa0>
		}
	}
	return NULL;
  801fad:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801fb2:	c9                   	leave  
  801fb3:	c3                   	ret    

00801fb4 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801fb4:	55                   	push   %ebp
  801fb5:	89 e5                	mov    %esp,%ebp
  801fb7:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801fba:	e8 5c fb ff ff       	call   801b1b <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801fbf:	83 ec 04             	sub    $0x4,%esp
  801fc2:	68 58 47 80 00       	push   $0x804758
  801fc7:	68 f7 00 00 00       	push   $0xf7
  801fcc:	68 27 47 80 00       	push   $0x804727
  801fd1:	e8 01 e9 ff ff       	call   8008d7 <_panic>

00801fd6 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801fd6:	55                   	push   %ebp
  801fd7:	89 e5                	mov    %esp,%ebp
  801fd9:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801fdc:	83 ec 04             	sub    $0x4,%esp
  801fdf:	68 80 47 80 00       	push   $0x804780
  801fe4:	68 0b 01 00 00       	push   $0x10b
  801fe9:	68 27 47 80 00       	push   $0x804727
  801fee:	e8 e4 e8 ff ff       	call   8008d7 <_panic>

00801ff3 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801ff3:	55                   	push   %ebp
  801ff4:	89 e5                	mov    %esp,%ebp
  801ff6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ff9:	83 ec 04             	sub    $0x4,%esp
  801ffc:	68 a4 47 80 00       	push   $0x8047a4
  802001:	68 16 01 00 00       	push   $0x116
  802006:	68 27 47 80 00       	push   $0x804727
  80200b:	e8 c7 e8 ff ff       	call   8008d7 <_panic>

00802010 <shrink>:

}
void shrink(uint32 newSize)
{
  802010:	55                   	push   %ebp
  802011:	89 e5                	mov    %esp,%ebp
  802013:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802016:	83 ec 04             	sub    $0x4,%esp
  802019:	68 a4 47 80 00       	push   $0x8047a4
  80201e:	68 1b 01 00 00       	push   $0x11b
  802023:	68 27 47 80 00       	push   $0x804727
  802028:	e8 aa e8 ff ff       	call   8008d7 <_panic>

0080202d <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80202d:	55                   	push   %ebp
  80202e:	89 e5                	mov    %esp,%ebp
  802030:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802033:	83 ec 04             	sub    $0x4,%esp
  802036:	68 a4 47 80 00       	push   $0x8047a4
  80203b:	68 20 01 00 00       	push   $0x120
  802040:	68 27 47 80 00       	push   $0x804727
  802045:	e8 8d e8 ff ff       	call   8008d7 <_panic>

0080204a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80204a:	55                   	push   %ebp
  80204b:	89 e5                	mov    %esp,%ebp
  80204d:	57                   	push   %edi
  80204e:	56                   	push   %esi
  80204f:	53                   	push   %ebx
  802050:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802053:	8b 45 08             	mov    0x8(%ebp),%eax
  802056:	8b 55 0c             	mov    0xc(%ebp),%edx
  802059:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80205c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80205f:	8b 7d 18             	mov    0x18(%ebp),%edi
  802062:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802065:	cd 30                	int    $0x30
  802067:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80206a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80206d:	83 c4 10             	add    $0x10,%esp
  802070:	5b                   	pop    %ebx
  802071:	5e                   	pop    %esi
  802072:	5f                   	pop    %edi
  802073:	5d                   	pop    %ebp
  802074:	c3                   	ret    

00802075 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802075:	55                   	push   %ebp
  802076:	89 e5                	mov    %esp,%ebp
  802078:	83 ec 04             	sub    $0x4,%esp
  80207b:	8b 45 10             	mov    0x10(%ebp),%eax
  80207e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802081:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802085:	8b 45 08             	mov    0x8(%ebp),%eax
  802088:	6a 00                	push   $0x0
  80208a:	6a 00                	push   $0x0
  80208c:	52                   	push   %edx
  80208d:	ff 75 0c             	pushl  0xc(%ebp)
  802090:	50                   	push   %eax
  802091:	6a 00                	push   $0x0
  802093:	e8 b2 ff ff ff       	call   80204a <syscall>
  802098:	83 c4 18             	add    $0x18,%esp
}
  80209b:	90                   	nop
  80209c:	c9                   	leave  
  80209d:	c3                   	ret    

0080209e <sys_cgetc>:

int
sys_cgetc(void)
{
  80209e:	55                   	push   %ebp
  80209f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8020a1:	6a 00                	push   $0x0
  8020a3:	6a 00                	push   $0x0
  8020a5:	6a 00                	push   $0x0
  8020a7:	6a 00                	push   $0x0
  8020a9:	6a 00                	push   $0x0
  8020ab:	6a 01                	push   $0x1
  8020ad:	e8 98 ff ff ff       	call   80204a <syscall>
  8020b2:	83 c4 18             	add    $0x18,%esp
}
  8020b5:	c9                   	leave  
  8020b6:	c3                   	ret    

008020b7 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8020b7:	55                   	push   %ebp
  8020b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8020ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c0:	6a 00                	push   $0x0
  8020c2:	6a 00                	push   $0x0
  8020c4:	6a 00                	push   $0x0
  8020c6:	52                   	push   %edx
  8020c7:	50                   	push   %eax
  8020c8:	6a 05                	push   $0x5
  8020ca:	e8 7b ff ff ff       	call   80204a <syscall>
  8020cf:	83 c4 18             	add    $0x18,%esp
}
  8020d2:	c9                   	leave  
  8020d3:	c3                   	ret    

008020d4 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8020d4:	55                   	push   %ebp
  8020d5:	89 e5                	mov    %esp,%ebp
  8020d7:	56                   	push   %esi
  8020d8:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8020d9:	8b 75 18             	mov    0x18(%ebp),%esi
  8020dc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020df:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e8:	56                   	push   %esi
  8020e9:	53                   	push   %ebx
  8020ea:	51                   	push   %ecx
  8020eb:	52                   	push   %edx
  8020ec:	50                   	push   %eax
  8020ed:	6a 06                	push   $0x6
  8020ef:	e8 56 ff ff ff       	call   80204a <syscall>
  8020f4:	83 c4 18             	add    $0x18,%esp
}
  8020f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020fa:	5b                   	pop    %ebx
  8020fb:	5e                   	pop    %esi
  8020fc:	5d                   	pop    %ebp
  8020fd:	c3                   	ret    

008020fe <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8020fe:	55                   	push   %ebp
  8020ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802101:	8b 55 0c             	mov    0xc(%ebp),%edx
  802104:	8b 45 08             	mov    0x8(%ebp),%eax
  802107:	6a 00                	push   $0x0
  802109:	6a 00                	push   $0x0
  80210b:	6a 00                	push   $0x0
  80210d:	52                   	push   %edx
  80210e:	50                   	push   %eax
  80210f:	6a 07                	push   $0x7
  802111:	e8 34 ff ff ff       	call   80204a <syscall>
  802116:	83 c4 18             	add    $0x18,%esp
}
  802119:	c9                   	leave  
  80211a:	c3                   	ret    

0080211b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80211b:	55                   	push   %ebp
  80211c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80211e:	6a 00                	push   $0x0
  802120:	6a 00                	push   $0x0
  802122:	6a 00                	push   $0x0
  802124:	ff 75 0c             	pushl  0xc(%ebp)
  802127:	ff 75 08             	pushl  0x8(%ebp)
  80212a:	6a 08                	push   $0x8
  80212c:	e8 19 ff ff ff       	call   80204a <syscall>
  802131:	83 c4 18             	add    $0x18,%esp
}
  802134:	c9                   	leave  
  802135:	c3                   	ret    

00802136 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802136:	55                   	push   %ebp
  802137:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802139:	6a 00                	push   $0x0
  80213b:	6a 00                	push   $0x0
  80213d:	6a 00                	push   $0x0
  80213f:	6a 00                	push   $0x0
  802141:	6a 00                	push   $0x0
  802143:	6a 09                	push   $0x9
  802145:	e8 00 ff ff ff       	call   80204a <syscall>
  80214a:	83 c4 18             	add    $0x18,%esp
}
  80214d:	c9                   	leave  
  80214e:	c3                   	ret    

0080214f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80214f:	55                   	push   %ebp
  802150:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802152:	6a 00                	push   $0x0
  802154:	6a 00                	push   $0x0
  802156:	6a 00                	push   $0x0
  802158:	6a 00                	push   $0x0
  80215a:	6a 00                	push   $0x0
  80215c:	6a 0a                	push   $0xa
  80215e:	e8 e7 fe ff ff       	call   80204a <syscall>
  802163:	83 c4 18             	add    $0x18,%esp
}
  802166:	c9                   	leave  
  802167:	c3                   	ret    

00802168 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802168:	55                   	push   %ebp
  802169:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80216b:	6a 00                	push   $0x0
  80216d:	6a 00                	push   $0x0
  80216f:	6a 00                	push   $0x0
  802171:	6a 00                	push   $0x0
  802173:	6a 00                	push   $0x0
  802175:	6a 0b                	push   $0xb
  802177:	e8 ce fe ff ff       	call   80204a <syscall>
  80217c:	83 c4 18             	add    $0x18,%esp
}
  80217f:	c9                   	leave  
  802180:	c3                   	ret    

00802181 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802181:	55                   	push   %ebp
  802182:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802184:	6a 00                	push   $0x0
  802186:	6a 00                	push   $0x0
  802188:	6a 00                	push   $0x0
  80218a:	ff 75 0c             	pushl  0xc(%ebp)
  80218d:	ff 75 08             	pushl  0x8(%ebp)
  802190:	6a 0f                	push   $0xf
  802192:	e8 b3 fe ff ff       	call   80204a <syscall>
  802197:	83 c4 18             	add    $0x18,%esp
	return;
  80219a:	90                   	nop
}
  80219b:	c9                   	leave  
  80219c:	c3                   	ret    

0080219d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80219d:	55                   	push   %ebp
  80219e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8021a0:	6a 00                	push   $0x0
  8021a2:	6a 00                	push   $0x0
  8021a4:	6a 00                	push   $0x0
  8021a6:	ff 75 0c             	pushl  0xc(%ebp)
  8021a9:	ff 75 08             	pushl  0x8(%ebp)
  8021ac:	6a 10                	push   $0x10
  8021ae:	e8 97 fe ff ff       	call   80204a <syscall>
  8021b3:	83 c4 18             	add    $0x18,%esp
	return ;
  8021b6:	90                   	nop
}
  8021b7:	c9                   	leave  
  8021b8:	c3                   	ret    

008021b9 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8021b9:	55                   	push   %ebp
  8021ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8021bc:	6a 00                	push   $0x0
  8021be:	6a 00                	push   $0x0
  8021c0:	ff 75 10             	pushl  0x10(%ebp)
  8021c3:	ff 75 0c             	pushl  0xc(%ebp)
  8021c6:	ff 75 08             	pushl  0x8(%ebp)
  8021c9:	6a 11                	push   $0x11
  8021cb:	e8 7a fe ff ff       	call   80204a <syscall>
  8021d0:	83 c4 18             	add    $0x18,%esp
	return ;
  8021d3:	90                   	nop
}
  8021d4:	c9                   	leave  
  8021d5:	c3                   	ret    

008021d6 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8021d6:	55                   	push   %ebp
  8021d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8021d9:	6a 00                	push   $0x0
  8021db:	6a 00                	push   $0x0
  8021dd:	6a 00                	push   $0x0
  8021df:	6a 00                	push   $0x0
  8021e1:	6a 00                	push   $0x0
  8021e3:	6a 0c                	push   $0xc
  8021e5:	e8 60 fe ff ff       	call   80204a <syscall>
  8021ea:	83 c4 18             	add    $0x18,%esp
}
  8021ed:	c9                   	leave  
  8021ee:	c3                   	ret    

008021ef <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8021ef:	55                   	push   %ebp
  8021f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8021f2:	6a 00                	push   $0x0
  8021f4:	6a 00                	push   $0x0
  8021f6:	6a 00                	push   $0x0
  8021f8:	6a 00                	push   $0x0
  8021fa:	ff 75 08             	pushl  0x8(%ebp)
  8021fd:	6a 0d                	push   $0xd
  8021ff:	e8 46 fe ff ff       	call   80204a <syscall>
  802204:	83 c4 18             	add    $0x18,%esp
}
  802207:	c9                   	leave  
  802208:	c3                   	ret    

00802209 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802209:	55                   	push   %ebp
  80220a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80220c:	6a 00                	push   $0x0
  80220e:	6a 00                	push   $0x0
  802210:	6a 00                	push   $0x0
  802212:	6a 00                	push   $0x0
  802214:	6a 00                	push   $0x0
  802216:	6a 0e                	push   $0xe
  802218:	e8 2d fe ff ff       	call   80204a <syscall>
  80221d:	83 c4 18             	add    $0x18,%esp
}
  802220:	90                   	nop
  802221:	c9                   	leave  
  802222:	c3                   	ret    

00802223 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802223:	55                   	push   %ebp
  802224:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802226:	6a 00                	push   $0x0
  802228:	6a 00                	push   $0x0
  80222a:	6a 00                	push   $0x0
  80222c:	6a 00                	push   $0x0
  80222e:	6a 00                	push   $0x0
  802230:	6a 13                	push   $0x13
  802232:	e8 13 fe ff ff       	call   80204a <syscall>
  802237:	83 c4 18             	add    $0x18,%esp
}
  80223a:	90                   	nop
  80223b:	c9                   	leave  
  80223c:	c3                   	ret    

0080223d <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80223d:	55                   	push   %ebp
  80223e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802240:	6a 00                	push   $0x0
  802242:	6a 00                	push   $0x0
  802244:	6a 00                	push   $0x0
  802246:	6a 00                	push   $0x0
  802248:	6a 00                	push   $0x0
  80224a:	6a 14                	push   $0x14
  80224c:	e8 f9 fd ff ff       	call   80204a <syscall>
  802251:	83 c4 18             	add    $0x18,%esp
}
  802254:	90                   	nop
  802255:	c9                   	leave  
  802256:	c3                   	ret    

00802257 <sys_cputc>:


void
sys_cputc(const char c)
{
  802257:	55                   	push   %ebp
  802258:	89 e5                	mov    %esp,%ebp
  80225a:	83 ec 04             	sub    $0x4,%esp
  80225d:	8b 45 08             	mov    0x8(%ebp),%eax
  802260:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802263:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802267:	6a 00                	push   $0x0
  802269:	6a 00                	push   $0x0
  80226b:	6a 00                	push   $0x0
  80226d:	6a 00                	push   $0x0
  80226f:	50                   	push   %eax
  802270:	6a 15                	push   $0x15
  802272:	e8 d3 fd ff ff       	call   80204a <syscall>
  802277:	83 c4 18             	add    $0x18,%esp
}
  80227a:	90                   	nop
  80227b:	c9                   	leave  
  80227c:	c3                   	ret    

0080227d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80227d:	55                   	push   %ebp
  80227e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802280:	6a 00                	push   $0x0
  802282:	6a 00                	push   $0x0
  802284:	6a 00                	push   $0x0
  802286:	6a 00                	push   $0x0
  802288:	6a 00                	push   $0x0
  80228a:	6a 16                	push   $0x16
  80228c:	e8 b9 fd ff ff       	call   80204a <syscall>
  802291:	83 c4 18             	add    $0x18,%esp
}
  802294:	90                   	nop
  802295:	c9                   	leave  
  802296:	c3                   	ret    

00802297 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802297:	55                   	push   %ebp
  802298:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80229a:	8b 45 08             	mov    0x8(%ebp),%eax
  80229d:	6a 00                	push   $0x0
  80229f:	6a 00                	push   $0x0
  8022a1:	6a 00                	push   $0x0
  8022a3:	ff 75 0c             	pushl  0xc(%ebp)
  8022a6:	50                   	push   %eax
  8022a7:	6a 17                	push   $0x17
  8022a9:	e8 9c fd ff ff       	call   80204a <syscall>
  8022ae:	83 c4 18             	add    $0x18,%esp
}
  8022b1:	c9                   	leave  
  8022b2:	c3                   	ret    

008022b3 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8022b3:	55                   	push   %ebp
  8022b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bc:	6a 00                	push   $0x0
  8022be:	6a 00                	push   $0x0
  8022c0:	6a 00                	push   $0x0
  8022c2:	52                   	push   %edx
  8022c3:	50                   	push   %eax
  8022c4:	6a 1a                	push   $0x1a
  8022c6:	e8 7f fd ff ff       	call   80204a <syscall>
  8022cb:	83 c4 18             	add    $0x18,%esp
}
  8022ce:	c9                   	leave  
  8022cf:	c3                   	ret    

008022d0 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8022d0:	55                   	push   %ebp
  8022d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d9:	6a 00                	push   $0x0
  8022db:	6a 00                	push   $0x0
  8022dd:	6a 00                	push   $0x0
  8022df:	52                   	push   %edx
  8022e0:	50                   	push   %eax
  8022e1:	6a 18                	push   $0x18
  8022e3:	e8 62 fd ff ff       	call   80204a <syscall>
  8022e8:	83 c4 18             	add    $0x18,%esp
}
  8022eb:	90                   	nop
  8022ec:	c9                   	leave  
  8022ed:	c3                   	ret    

008022ee <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8022ee:	55                   	push   %ebp
  8022ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f7:	6a 00                	push   $0x0
  8022f9:	6a 00                	push   $0x0
  8022fb:	6a 00                	push   $0x0
  8022fd:	52                   	push   %edx
  8022fe:	50                   	push   %eax
  8022ff:	6a 19                	push   $0x19
  802301:	e8 44 fd ff ff       	call   80204a <syscall>
  802306:	83 c4 18             	add    $0x18,%esp
}
  802309:	90                   	nop
  80230a:	c9                   	leave  
  80230b:	c3                   	ret    

0080230c <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80230c:	55                   	push   %ebp
  80230d:	89 e5                	mov    %esp,%ebp
  80230f:	83 ec 04             	sub    $0x4,%esp
  802312:	8b 45 10             	mov    0x10(%ebp),%eax
  802315:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802318:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80231b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80231f:	8b 45 08             	mov    0x8(%ebp),%eax
  802322:	6a 00                	push   $0x0
  802324:	51                   	push   %ecx
  802325:	52                   	push   %edx
  802326:	ff 75 0c             	pushl  0xc(%ebp)
  802329:	50                   	push   %eax
  80232a:	6a 1b                	push   $0x1b
  80232c:	e8 19 fd ff ff       	call   80204a <syscall>
  802331:	83 c4 18             	add    $0x18,%esp
}
  802334:	c9                   	leave  
  802335:	c3                   	ret    

00802336 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802336:	55                   	push   %ebp
  802337:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802339:	8b 55 0c             	mov    0xc(%ebp),%edx
  80233c:	8b 45 08             	mov    0x8(%ebp),%eax
  80233f:	6a 00                	push   $0x0
  802341:	6a 00                	push   $0x0
  802343:	6a 00                	push   $0x0
  802345:	52                   	push   %edx
  802346:	50                   	push   %eax
  802347:	6a 1c                	push   $0x1c
  802349:	e8 fc fc ff ff       	call   80204a <syscall>
  80234e:	83 c4 18             	add    $0x18,%esp
}
  802351:	c9                   	leave  
  802352:	c3                   	ret    

00802353 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802353:	55                   	push   %ebp
  802354:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802356:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802359:	8b 55 0c             	mov    0xc(%ebp),%edx
  80235c:	8b 45 08             	mov    0x8(%ebp),%eax
  80235f:	6a 00                	push   $0x0
  802361:	6a 00                	push   $0x0
  802363:	51                   	push   %ecx
  802364:	52                   	push   %edx
  802365:	50                   	push   %eax
  802366:	6a 1d                	push   $0x1d
  802368:	e8 dd fc ff ff       	call   80204a <syscall>
  80236d:	83 c4 18             	add    $0x18,%esp
}
  802370:	c9                   	leave  
  802371:	c3                   	ret    

00802372 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802372:	55                   	push   %ebp
  802373:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802375:	8b 55 0c             	mov    0xc(%ebp),%edx
  802378:	8b 45 08             	mov    0x8(%ebp),%eax
  80237b:	6a 00                	push   $0x0
  80237d:	6a 00                	push   $0x0
  80237f:	6a 00                	push   $0x0
  802381:	52                   	push   %edx
  802382:	50                   	push   %eax
  802383:	6a 1e                	push   $0x1e
  802385:	e8 c0 fc ff ff       	call   80204a <syscall>
  80238a:	83 c4 18             	add    $0x18,%esp
}
  80238d:	c9                   	leave  
  80238e:	c3                   	ret    

0080238f <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80238f:	55                   	push   %ebp
  802390:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802392:	6a 00                	push   $0x0
  802394:	6a 00                	push   $0x0
  802396:	6a 00                	push   $0x0
  802398:	6a 00                	push   $0x0
  80239a:	6a 00                	push   $0x0
  80239c:	6a 1f                	push   $0x1f
  80239e:	e8 a7 fc ff ff       	call   80204a <syscall>
  8023a3:	83 c4 18             	add    $0x18,%esp
}
  8023a6:	c9                   	leave  
  8023a7:	c3                   	ret    

008023a8 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8023a8:	55                   	push   %ebp
  8023a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8023ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ae:	6a 00                	push   $0x0
  8023b0:	ff 75 14             	pushl  0x14(%ebp)
  8023b3:	ff 75 10             	pushl  0x10(%ebp)
  8023b6:	ff 75 0c             	pushl  0xc(%ebp)
  8023b9:	50                   	push   %eax
  8023ba:	6a 20                	push   $0x20
  8023bc:	e8 89 fc ff ff       	call   80204a <syscall>
  8023c1:	83 c4 18             	add    $0x18,%esp
}
  8023c4:	c9                   	leave  
  8023c5:	c3                   	ret    

008023c6 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8023c6:	55                   	push   %ebp
  8023c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8023c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cc:	6a 00                	push   $0x0
  8023ce:	6a 00                	push   $0x0
  8023d0:	6a 00                	push   $0x0
  8023d2:	6a 00                	push   $0x0
  8023d4:	50                   	push   %eax
  8023d5:	6a 21                	push   $0x21
  8023d7:	e8 6e fc ff ff       	call   80204a <syscall>
  8023dc:	83 c4 18             	add    $0x18,%esp
}
  8023df:	90                   	nop
  8023e0:	c9                   	leave  
  8023e1:	c3                   	ret    

008023e2 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8023e2:	55                   	push   %ebp
  8023e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8023e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e8:	6a 00                	push   $0x0
  8023ea:	6a 00                	push   $0x0
  8023ec:	6a 00                	push   $0x0
  8023ee:	6a 00                	push   $0x0
  8023f0:	50                   	push   %eax
  8023f1:	6a 22                	push   $0x22
  8023f3:	e8 52 fc ff ff       	call   80204a <syscall>
  8023f8:	83 c4 18             	add    $0x18,%esp
}
  8023fb:	c9                   	leave  
  8023fc:	c3                   	ret    

008023fd <sys_getenvid>:

int32 sys_getenvid(void)
{
  8023fd:	55                   	push   %ebp
  8023fe:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802400:	6a 00                	push   $0x0
  802402:	6a 00                	push   $0x0
  802404:	6a 00                	push   $0x0
  802406:	6a 00                	push   $0x0
  802408:	6a 00                	push   $0x0
  80240a:	6a 02                	push   $0x2
  80240c:	e8 39 fc ff ff       	call   80204a <syscall>
  802411:	83 c4 18             	add    $0x18,%esp
}
  802414:	c9                   	leave  
  802415:	c3                   	ret    

00802416 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802416:	55                   	push   %ebp
  802417:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802419:	6a 00                	push   $0x0
  80241b:	6a 00                	push   $0x0
  80241d:	6a 00                	push   $0x0
  80241f:	6a 00                	push   $0x0
  802421:	6a 00                	push   $0x0
  802423:	6a 03                	push   $0x3
  802425:	e8 20 fc ff ff       	call   80204a <syscall>
  80242a:	83 c4 18             	add    $0x18,%esp
}
  80242d:	c9                   	leave  
  80242e:	c3                   	ret    

0080242f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80242f:	55                   	push   %ebp
  802430:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802432:	6a 00                	push   $0x0
  802434:	6a 00                	push   $0x0
  802436:	6a 00                	push   $0x0
  802438:	6a 00                	push   $0x0
  80243a:	6a 00                	push   $0x0
  80243c:	6a 04                	push   $0x4
  80243e:	e8 07 fc ff ff       	call   80204a <syscall>
  802443:	83 c4 18             	add    $0x18,%esp
}
  802446:	c9                   	leave  
  802447:	c3                   	ret    

00802448 <sys_exit_env>:


void sys_exit_env(void)
{
  802448:	55                   	push   %ebp
  802449:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80244b:	6a 00                	push   $0x0
  80244d:	6a 00                	push   $0x0
  80244f:	6a 00                	push   $0x0
  802451:	6a 00                	push   $0x0
  802453:	6a 00                	push   $0x0
  802455:	6a 23                	push   $0x23
  802457:	e8 ee fb ff ff       	call   80204a <syscall>
  80245c:	83 c4 18             	add    $0x18,%esp
}
  80245f:	90                   	nop
  802460:	c9                   	leave  
  802461:	c3                   	ret    

00802462 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802462:	55                   	push   %ebp
  802463:	89 e5                	mov    %esp,%ebp
  802465:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802468:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80246b:	8d 50 04             	lea    0x4(%eax),%edx
  80246e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802471:	6a 00                	push   $0x0
  802473:	6a 00                	push   $0x0
  802475:	6a 00                	push   $0x0
  802477:	52                   	push   %edx
  802478:	50                   	push   %eax
  802479:	6a 24                	push   $0x24
  80247b:	e8 ca fb ff ff       	call   80204a <syscall>
  802480:	83 c4 18             	add    $0x18,%esp
	return result;
  802483:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802486:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802489:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80248c:	89 01                	mov    %eax,(%ecx)
  80248e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802491:	8b 45 08             	mov    0x8(%ebp),%eax
  802494:	c9                   	leave  
  802495:	c2 04 00             	ret    $0x4

00802498 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802498:	55                   	push   %ebp
  802499:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80249b:	6a 00                	push   $0x0
  80249d:	6a 00                	push   $0x0
  80249f:	ff 75 10             	pushl  0x10(%ebp)
  8024a2:	ff 75 0c             	pushl  0xc(%ebp)
  8024a5:	ff 75 08             	pushl  0x8(%ebp)
  8024a8:	6a 12                	push   $0x12
  8024aa:	e8 9b fb ff ff       	call   80204a <syscall>
  8024af:	83 c4 18             	add    $0x18,%esp
	return ;
  8024b2:	90                   	nop
}
  8024b3:	c9                   	leave  
  8024b4:	c3                   	ret    

008024b5 <sys_rcr2>:
uint32 sys_rcr2()
{
  8024b5:	55                   	push   %ebp
  8024b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8024b8:	6a 00                	push   $0x0
  8024ba:	6a 00                	push   $0x0
  8024bc:	6a 00                	push   $0x0
  8024be:	6a 00                	push   $0x0
  8024c0:	6a 00                	push   $0x0
  8024c2:	6a 25                	push   $0x25
  8024c4:	e8 81 fb ff ff       	call   80204a <syscall>
  8024c9:	83 c4 18             	add    $0x18,%esp
}
  8024cc:	c9                   	leave  
  8024cd:	c3                   	ret    

008024ce <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8024ce:	55                   	push   %ebp
  8024cf:	89 e5                	mov    %esp,%ebp
  8024d1:	83 ec 04             	sub    $0x4,%esp
  8024d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8024da:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8024de:	6a 00                	push   $0x0
  8024e0:	6a 00                	push   $0x0
  8024e2:	6a 00                	push   $0x0
  8024e4:	6a 00                	push   $0x0
  8024e6:	50                   	push   %eax
  8024e7:	6a 26                	push   $0x26
  8024e9:	e8 5c fb ff ff       	call   80204a <syscall>
  8024ee:	83 c4 18             	add    $0x18,%esp
	return ;
  8024f1:	90                   	nop
}
  8024f2:	c9                   	leave  
  8024f3:	c3                   	ret    

008024f4 <rsttst>:
void rsttst()
{
  8024f4:	55                   	push   %ebp
  8024f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8024f7:	6a 00                	push   $0x0
  8024f9:	6a 00                	push   $0x0
  8024fb:	6a 00                	push   $0x0
  8024fd:	6a 00                	push   $0x0
  8024ff:	6a 00                	push   $0x0
  802501:	6a 28                	push   $0x28
  802503:	e8 42 fb ff ff       	call   80204a <syscall>
  802508:	83 c4 18             	add    $0x18,%esp
	return ;
  80250b:	90                   	nop
}
  80250c:	c9                   	leave  
  80250d:	c3                   	ret    

0080250e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80250e:	55                   	push   %ebp
  80250f:	89 e5                	mov    %esp,%ebp
  802511:	83 ec 04             	sub    $0x4,%esp
  802514:	8b 45 14             	mov    0x14(%ebp),%eax
  802517:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80251a:	8b 55 18             	mov    0x18(%ebp),%edx
  80251d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802521:	52                   	push   %edx
  802522:	50                   	push   %eax
  802523:	ff 75 10             	pushl  0x10(%ebp)
  802526:	ff 75 0c             	pushl  0xc(%ebp)
  802529:	ff 75 08             	pushl  0x8(%ebp)
  80252c:	6a 27                	push   $0x27
  80252e:	e8 17 fb ff ff       	call   80204a <syscall>
  802533:	83 c4 18             	add    $0x18,%esp
	return ;
  802536:	90                   	nop
}
  802537:	c9                   	leave  
  802538:	c3                   	ret    

00802539 <chktst>:
void chktst(uint32 n)
{
  802539:	55                   	push   %ebp
  80253a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80253c:	6a 00                	push   $0x0
  80253e:	6a 00                	push   $0x0
  802540:	6a 00                	push   $0x0
  802542:	6a 00                	push   $0x0
  802544:	ff 75 08             	pushl  0x8(%ebp)
  802547:	6a 29                	push   $0x29
  802549:	e8 fc fa ff ff       	call   80204a <syscall>
  80254e:	83 c4 18             	add    $0x18,%esp
	return ;
  802551:	90                   	nop
}
  802552:	c9                   	leave  
  802553:	c3                   	ret    

00802554 <inctst>:

void inctst()
{
  802554:	55                   	push   %ebp
  802555:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802557:	6a 00                	push   $0x0
  802559:	6a 00                	push   $0x0
  80255b:	6a 00                	push   $0x0
  80255d:	6a 00                	push   $0x0
  80255f:	6a 00                	push   $0x0
  802561:	6a 2a                	push   $0x2a
  802563:	e8 e2 fa ff ff       	call   80204a <syscall>
  802568:	83 c4 18             	add    $0x18,%esp
	return ;
  80256b:	90                   	nop
}
  80256c:	c9                   	leave  
  80256d:	c3                   	ret    

0080256e <gettst>:
uint32 gettst()
{
  80256e:	55                   	push   %ebp
  80256f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802571:	6a 00                	push   $0x0
  802573:	6a 00                	push   $0x0
  802575:	6a 00                	push   $0x0
  802577:	6a 00                	push   $0x0
  802579:	6a 00                	push   $0x0
  80257b:	6a 2b                	push   $0x2b
  80257d:	e8 c8 fa ff ff       	call   80204a <syscall>
  802582:	83 c4 18             	add    $0x18,%esp
}
  802585:	c9                   	leave  
  802586:	c3                   	ret    

00802587 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802587:	55                   	push   %ebp
  802588:	89 e5                	mov    %esp,%ebp
  80258a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80258d:	6a 00                	push   $0x0
  80258f:	6a 00                	push   $0x0
  802591:	6a 00                	push   $0x0
  802593:	6a 00                	push   $0x0
  802595:	6a 00                	push   $0x0
  802597:	6a 2c                	push   $0x2c
  802599:	e8 ac fa ff ff       	call   80204a <syscall>
  80259e:	83 c4 18             	add    $0x18,%esp
  8025a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8025a4:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8025a8:	75 07                	jne    8025b1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8025aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8025af:	eb 05                	jmp    8025b6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8025b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025b6:	c9                   	leave  
  8025b7:	c3                   	ret    

008025b8 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8025b8:	55                   	push   %ebp
  8025b9:	89 e5                	mov    %esp,%ebp
  8025bb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025be:	6a 00                	push   $0x0
  8025c0:	6a 00                	push   $0x0
  8025c2:	6a 00                	push   $0x0
  8025c4:	6a 00                	push   $0x0
  8025c6:	6a 00                	push   $0x0
  8025c8:	6a 2c                	push   $0x2c
  8025ca:	e8 7b fa ff ff       	call   80204a <syscall>
  8025cf:	83 c4 18             	add    $0x18,%esp
  8025d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8025d5:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8025d9:	75 07                	jne    8025e2 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8025db:	b8 01 00 00 00       	mov    $0x1,%eax
  8025e0:	eb 05                	jmp    8025e7 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8025e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025e7:	c9                   	leave  
  8025e8:	c3                   	ret    

008025e9 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8025e9:	55                   	push   %ebp
  8025ea:	89 e5                	mov    %esp,%ebp
  8025ec:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025ef:	6a 00                	push   $0x0
  8025f1:	6a 00                	push   $0x0
  8025f3:	6a 00                	push   $0x0
  8025f5:	6a 00                	push   $0x0
  8025f7:	6a 00                	push   $0x0
  8025f9:	6a 2c                	push   $0x2c
  8025fb:	e8 4a fa ff ff       	call   80204a <syscall>
  802600:	83 c4 18             	add    $0x18,%esp
  802603:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802606:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80260a:	75 07                	jne    802613 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80260c:	b8 01 00 00 00       	mov    $0x1,%eax
  802611:	eb 05                	jmp    802618 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802613:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802618:	c9                   	leave  
  802619:	c3                   	ret    

0080261a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80261a:	55                   	push   %ebp
  80261b:	89 e5                	mov    %esp,%ebp
  80261d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802620:	6a 00                	push   $0x0
  802622:	6a 00                	push   $0x0
  802624:	6a 00                	push   $0x0
  802626:	6a 00                	push   $0x0
  802628:	6a 00                	push   $0x0
  80262a:	6a 2c                	push   $0x2c
  80262c:	e8 19 fa ff ff       	call   80204a <syscall>
  802631:	83 c4 18             	add    $0x18,%esp
  802634:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802637:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80263b:	75 07                	jne    802644 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80263d:	b8 01 00 00 00       	mov    $0x1,%eax
  802642:	eb 05                	jmp    802649 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802644:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802649:	c9                   	leave  
  80264a:	c3                   	ret    

0080264b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80264b:	55                   	push   %ebp
  80264c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80264e:	6a 00                	push   $0x0
  802650:	6a 00                	push   $0x0
  802652:	6a 00                	push   $0x0
  802654:	6a 00                	push   $0x0
  802656:	ff 75 08             	pushl  0x8(%ebp)
  802659:	6a 2d                	push   $0x2d
  80265b:	e8 ea f9 ff ff       	call   80204a <syscall>
  802660:	83 c4 18             	add    $0x18,%esp
	return ;
  802663:	90                   	nop
}
  802664:	c9                   	leave  
  802665:	c3                   	ret    

00802666 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802666:	55                   	push   %ebp
  802667:	89 e5                	mov    %esp,%ebp
  802669:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80266a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80266d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802670:	8b 55 0c             	mov    0xc(%ebp),%edx
  802673:	8b 45 08             	mov    0x8(%ebp),%eax
  802676:	6a 00                	push   $0x0
  802678:	53                   	push   %ebx
  802679:	51                   	push   %ecx
  80267a:	52                   	push   %edx
  80267b:	50                   	push   %eax
  80267c:	6a 2e                	push   $0x2e
  80267e:	e8 c7 f9 ff ff       	call   80204a <syscall>
  802683:	83 c4 18             	add    $0x18,%esp
}
  802686:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802689:	c9                   	leave  
  80268a:	c3                   	ret    

0080268b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80268b:	55                   	push   %ebp
  80268c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80268e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802691:	8b 45 08             	mov    0x8(%ebp),%eax
  802694:	6a 00                	push   $0x0
  802696:	6a 00                	push   $0x0
  802698:	6a 00                	push   $0x0
  80269a:	52                   	push   %edx
  80269b:	50                   	push   %eax
  80269c:	6a 2f                	push   $0x2f
  80269e:	e8 a7 f9 ff ff       	call   80204a <syscall>
  8026a3:	83 c4 18             	add    $0x18,%esp
}
  8026a6:	c9                   	leave  
  8026a7:	c3                   	ret    

008026a8 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8026a8:	55                   	push   %ebp
  8026a9:	89 e5                	mov    %esp,%ebp
  8026ab:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8026ae:	83 ec 0c             	sub    $0xc,%esp
  8026b1:	68 b4 47 80 00       	push   $0x8047b4
  8026b6:	e8 d0 e4 ff ff       	call   800b8b <cprintf>
  8026bb:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8026be:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8026c5:	83 ec 0c             	sub    $0xc,%esp
  8026c8:	68 e0 47 80 00       	push   $0x8047e0
  8026cd:	e8 b9 e4 ff ff       	call   800b8b <cprintf>
  8026d2:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8026d5:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8026d9:	a1 38 51 80 00       	mov    0x805138,%eax
  8026de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026e1:	eb 56                	jmp    802739 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8026e3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026e7:	74 1c                	je     802705 <print_mem_block_lists+0x5d>
  8026e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ec:	8b 50 08             	mov    0x8(%eax),%edx
  8026ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026f2:	8b 48 08             	mov    0x8(%eax),%ecx
  8026f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8026fb:	01 c8                	add    %ecx,%eax
  8026fd:	39 c2                	cmp    %eax,%edx
  8026ff:	73 04                	jae    802705 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802701:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802705:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802708:	8b 50 08             	mov    0x8(%eax),%edx
  80270b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270e:	8b 40 0c             	mov    0xc(%eax),%eax
  802711:	01 c2                	add    %eax,%edx
  802713:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802716:	8b 40 08             	mov    0x8(%eax),%eax
  802719:	83 ec 04             	sub    $0x4,%esp
  80271c:	52                   	push   %edx
  80271d:	50                   	push   %eax
  80271e:	68 f5 47 80 00       	push   $0x8047f5
  802723:	e8 63 e4 ff ff       	call   800b8b <cprintf>
  802728:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80272b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802731:	a1 40 51 80 00       	mov    0x805140,%eax
  802736:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802739:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80273d:	74 07                	je     802746 <print_mem_block_lists+0x9e>
  80273f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802742:	8b 00                	mov    (%eax),%eax
  802744:	eb 05                	jmp    80274b <print_mem_block_lists+0xa3>
  802746:	b8 00 00 00 00       	mov    $0x0,%eax
  80274b:	a3 40 51 80 00       	mov    %eax,0x805140
  802750:	a1 40 51 80 00       	mov    0x805140,%eax
  802755:	85 c0                	test   %eax,%eax
  802757:	75 8a                	jne    8026e3 <print_mem_block_lists+0x3b>
  802759:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80275d:	75 84                	jne    8026e3 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80275f:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802763:	75 10                	jne    802775 <print_mem_block_lists+0xcd>
  802765:	83 ec 0c             	sub    $0xc,%esp
  802768:	68 04 48 80 00       	push   $0x804804
  80276d:	e8 19 e4 ff ff       	call   800b8b <cprintf>
  802772:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802775:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80277c:	83 ec 0c             	sub    $0xc,%esp
  80277f:	68 28 48 80 00       	push   $0x804828
  802784:	e8 02 e4 ff ff       	call   800b8b <cprintf>
  802789:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80278c:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802790:	a1 40 50 80 00       	mov    0x805040,%eax
  802795:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802798:	eb 56                	jmp    8027f0 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80279a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80279e:	74 1c                	je     8027bc <print_mem_block_lists+0x114>
  8027a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a3:	8b 50 08             	mov    0x8(%eax),%edx
  8027a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a9:	8b 48 08             	mov    0x8(%eax),%ecx
  8027ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027af:	8b 40 0c             	mov    0xc(%eax),%eax
  8027b2:	01 c8                	add    %ecx,%eax
  8027b4:	39 c2                	cmp    %eax,%edx
  8027b6:	73 04                	jae    8027bc <print_mem_block_lists+0x114>
			sorted = 0 ;
  8027b8:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8027bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bf:	8b 50 08             	mov    0x8(%eax),%edx
  8027c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8027c8:	01 c2                	add    %eax,%edx
  8027ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cd:	8b 40 08             	mov    0x8(%eax),%eax
  8027d0:	83 ec 04             	sub    $0x4,%esp
  8027d3:	52                   	push   %edx
  8027d4:	50                   	push   %eax
  8027d5:	68 f5 47 80 00       	push   $0x8047f5
  8027da:	e8 ac e3 ff ff       	call   800b8b <cprintf>
  8027df:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8027e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8027e8:	a1 48 50 80 00       	mov    0x805048,%eax
  8027ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027f4:	74 07                	je     8027fd <print_mem_block_lists+0x155>
  8027f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f9:	8b 00                	mov    (%eax),%eax
  8027fb:	eb 05                	jmp    802802 <print_mem_block_lists+0x15a>
  8027fd:	b8 00 00 00 00       	mov    $0x0,%eax
  802802:	a3 48 50 80 00       	mov    %eax,0x805048
  802807:	a1 48 50 80 00       	mov    0x805048,%eax
  80280c:	85 c0                	test   %eax,%eax
  80280e:	75 8a                	jne    80279a <print_mem_block_lists+0xf2>
  802810:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802814:	75 84                	jne    80279a <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802816:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80281a:	75 10                	jne    80282c <print_mem_block_lists+0x184>
  80281c:	83 ec 0c             	sub    $0xc,%esp
  80281f:	68 40 48 80 00       	push   $0x804840
  802824:	e8 62 e3 ff ff       	call   800b8b <cprintf>
  802829:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80282c:	83 ec 0c             	sub    $0xc,%esp
  80282f:	68 b4 47 80 00       	push   $0x8047b4
  802834:	e8 52 e3 ff ff       	call   800b8b <cprintf>
  802839:	83 c4 10             	add    $0x10,%esp

}
  80283c:	90                   	nop
  80283d:	c9                   	leave  
  80283e:	c3                   	ret    

0080283f <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80283f:	55                   	push   %ebp
  802840:	89 e5                	mov    %esp,%ebp
  802842:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802845:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80284c:	00 00 00 
  80284f:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802856:	00 00 00 
  802859:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802860:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802863:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80286a:	e9 9e 00 00 00       	jmp    80290d <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  80286f:	a1 50 50 80 00       	mov    0x805050,%eax
  802874:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802877:	c1 e2 04             	shl    $0x4,%edx
  80287a:	01 d0                	add    %edx,%eax
  80287c:	85 c0                	test   %eax,%eax
  80287e:	75 14                	jne    802894 <initialize_MemBlocksList+0x55>
  802880:	83 ec 04             	sub    $0x4,%esp
  802883:	68 68 48 80 00       	push   $0x804868
  802888:	6a 46                	push   $0x46
  80288a:	68 8b 48 80 00       	push   $0x80488b
  80288f:	e8 43 e0 ff ff       	call   8008d7 <_panic>
  802894:	a1 50 50 80 00       	mov    0x805050,%eax
  802899:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80289c:	c1 e2 04             	shl    $0x4,%edx
  80289f:	01 d0                	add    %edx,%eax
  8028a1:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8028a7:	89 10                	mov    %edx,(%eax)
  8028a9:	8b 00                	mov    (%eax),%eax
  8028ab:	85 c0                	test   %eax,%eax
  8028ad:	74 18                	je     8028c7 <initialize_MemBlocksList+0x88>
  8028af:	a1 48 51 80 00       	mov    0x805148,%eax
  8028b4:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8028ba:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8028bd:	c1 e1 04             	shl    $0x4,%ecx
  8028c0:	01 ca                	add    %ecx,%edx
  8028c2:	89 50 04             	mov    %edx,0x4(%eax)
  8028c5:	eb 12                	jmp    8028d9 <initialize_MemBlocksList+0x9a>
  8028c7:	a1 50 50 80 00       	mov    0x805050,%eax
  8028cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028cf:	c1 e2 04             	shl    $0x4,%edx
  8028d2:	01 d0                	add    %edx,%eax
  8028d4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028d9:	a1 50 50 80 00       	mov    0x805050,%eax
  8028de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028e1:	c1 e2 04             	shl    $0x4,%edx
  8028e4:	01 d0                	add    %edx,%eax
  8028e6:	a3 48 51 80 00       	mov    %eax,0x805148
  8028eb:	a1 50 50 80 00       	mov    0x805050,%eax
  8028f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028f3:	c1 e2 04             	shl    $0x4,%edx
  8028f6:	01 d0                	add    %edx,%eax
  8028f8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028ff:	a1 54 51 80 00       	mov    0x805154,%eax
  802904:	40                   	inc    %eax
  802905:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  80290a:	ff 45 f4             	incl   -0xc(%ebp)
  80290d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802910:	3b 45 08             	cmp    0x8(%ebp),%eax
  802913:	0f 82 56 ff ff ff    	jb     80286f <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802919:	90                   	nop
  80291a:	c9                   	leave  
  80291b:	c3                   	ret    

0080291c <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80291c:	55                   	push   %ebp
  80291d:	89 e5                	mov    %esp,%ebp
  80291f:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802922:	8b 45 08             	mov    0x8(%ebp),%eax
  802925:	8b 00                	mov    (%eax),%eax
  802927:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80292a:	eb 19                	jmp    802945 <find_block+0x29>
	{
		if(va==point->sva)
  80292c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80292f:	8b 40 08             	mov    0x8(%eax),%eax
  802932:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802935:	75 05                	jne    80293c <find_block+0x20>
		   return point;
  802937:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80293a:	eb 36                	jmp    802972 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80293c:	8b 45 08             	mov    0x8(%ebp),%eax
  80293f:	8b 40 08             	mov    0x8(%eax),%eax
  802942:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802945:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802949:	74 07                	je     802952 <find_block+0x36>
  80294b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80294e:	8b 00                	mov    (%eax),%eax
  802950:	eb 05                	jmp    802957 <find_block+0x3b>
  802952:	b8 00 00 00 00       	mov    $0x0,%eax
  802957:	8b 55 08             	mov    0x8(%ebp),%edx
  80295a:	89 42 08             	mov    %eax,0x8(%edx)
  80295d:	8b 45 08             	mov    0x8(%ebp),%eax
  802960:	8b 40 08             	mov    0x8(%eax),%eax
  802963:	85 c0                	test   %eax,%eax
  802965:	75 c5                	jne    80292c <find_block+0x10>
  802967:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80296b:	75 bf                	jne    80292c <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  80296d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802972:	c9                   	leave  
  802973:	c3                   	ret    

00802974 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802974:	55                   	push   %ebp
  802975:	89 e5                	mov    %esp,%ebp
  802977:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80297a:	a1 40 50 80 00       	mov    0x805040,%eax
  80297f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802982:	a1 44 50 80 00       	mov    0x805044,%eax
  802987:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80298a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80298d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802990:	74 24                	je     8029b6 <insert_sorted_allocList+0x42>
  802992:	8b 45 08             	mov    0x8(%ebp),%eax
  802995:	8b 50 08             	mov    0x8(%eax),%edx
  802998:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80299b:	8b 40 08             	mov    0x8(%eax),%eax
  80299e:	39 c2                	cmp    %eax,%edx
  8029a0:	76 14                	jbe    8029b6 <insert_sorted_allocList+0x42>
  8029a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a5:	8b 50 08             	mov    0x8(%eax),%edx
  8029a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ab:	8b 40 08             	mov    0x8(%eax),%eax
  8029ae:	39 c2                	cmp    %eax,%edx
  8029b0:	0f 82 60 01 00 00    	jb     802b16 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8029b6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029ba:	75 65                	jne    802a21 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8029bc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029c0:	75 14                	jne    8029d6 <insert_sorted_allocList+0x62>
  8029c2:	83 ec 04             	sub    $0x4,%esp
  8029c5:	68 68 48 80 00       	push   $0x804868
  8029ca:	6a 6b                	push   $0x6b
  8029cc:	68 8b 48 80 00       	push   $0x80488b
  8029d1:	e8 01 df ff ff       	call   8008d7 <_panic>
  8029d6:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8029dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029df:	89 10                	mov    %edx,(%eax)
  8029e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e4:	8b 00                	mov    (%eax),%eax
  8029e6:	85 c0                	test   %eax,%eax
  8029e8:	74 0d                	je     8029f7 <insert_sorted_allocList+0x83>
  8029ea:	a1 40 50 80 00       	mov    0x805040,%eax
  8029ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8029f2:	89 50 04             	mov    %edx,0x4(%eax)
  8029f5:	eb 08                	jmp    8029ff <insert_sorted_allocList+0x8b>
  8029f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fa:	a3 44 50 80 00       	mov    %eax,0x805044
  8029ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802a02:	a3 40 50 80 00       	mov    %eax,0x805040
  802a07:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a11:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a16:	40                   	inc    %eax
  802a17:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802a1c:	e9 dc 01 00 00       	jmp    802bfd <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802a21:	8b 45 08             	mov    0x8(%ebp),%eax
  802a24:	8b 50 08             	mov    0x8(%eax),%edx
  802a27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a2a:	8b 40 08             	mov    0x8(%eax),%eax
  802a2d:	39 c2                	cmp    %eax,%edx
  802a2f:	77 6c                	ja     802a9d <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802a31:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a35:	74 06                	je     802a3d <insert_sorted_allocList+0xc9>
  802a37:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a3b:	75 14                	jne    802a51 <insert_sorted_allocList+0xdd>
  802a3d:	83 ec 04             	sub    $0x4,%esp
  802a40:	68 a4 48 80 00       	push   $0x8048a4
  802a45:	6a 6f                	push   $0x6f
  802a47:	68 8b 48 80 00       	push   $0x80488b
  802a4c:	e8 86 de ff ff       	call   8008d7 <_panic>
  802a51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a54:	8b 50 04             	mov    0x4(%eax),%edx
  802a57:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5a:	89 50 04             	mov    %edx,0x4(%eax)
  802a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a60:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a63:	89 10                	mov    %edx,(%eax)
  802a65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a68:	8b 40 04             	mov    0x4(%eax),%eax
  802a6b:	85 c0                	test   %eax,%eax
  802a6d:	74 0d                	je     802a7c <insert_sorted_allocList+0x108>
  802a6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a72:	8b 40 04             	mov    0x4(%eax),%eax
  802a75:	8b 55 08             	mov    0x8(%ebp),%edx
  802a78:	89 10                	mov    %edx,(%eax)
  802a7a:	eb 08                	jmp    802a84 <insert_sorted_allocList+0x110>
  802a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7f:	a3 40 50 80 00       	mov    %eax,0x805040
  802a84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a87:	8b 55 08             	mov    0x8(%ebp),%edx
  802a8a:	89 50 04             	mov    %edx,0x4(%eax)
  802a8d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a92:	40                   	inc    %eax
  802a93:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802a98:	e9 60 01 00 00       	jmp    802bfd <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa0:	8b 50 08             	mov    0x8(%eax),%edx
  802aa3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aa6:	8b 40 08             	mov    0x8(%eax),%eax
  802aa9:	39 c2                	cmp    %eax,%edx
  802aab:	0f 82 4c 01 00 00    	jb     802bfd <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802ab1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ab5:	75 14                	jne    802acb <insert_sorted_allocList+0x157>
  802ab7:	83 ec 04             	sub    $0x4,%esp
  802aba:	68 dc 48 80 00       	push   $0x8048dc
  802abf:	6a 73                	push   $0x73
  802ac1:	68 8b 48 80 00       	push   $0x80488b
  802ac6:	e8 0c de ff ff       	call   8008d7 <_panic>
  802acb:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad4:	89 50 04             	mov    %edx,0x4(%eax)
  802ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  802ada:	8b 40 04             	mov    0x4(%eax),%eax
  802add:	85 c0                	test   %eax,%eax
  802adf:	74 0c                	je     802aed <insert_sorted_allocList+0x179>
  802ae1:	a1 44 50 80 00       	mov    0x805044,%eax
  802ae6:	8b 55 08             	mov    0x8(%ebp),%edx
  802ae9:	89 10                	mov    %edx,(%eax)
  802aeb:	eb 08                	jmp    802af5 <insert_sorted_allocList+0x181>
  802aed:	8b 45 08             	mov    0x8(%ebp),%eax
  802af0:	a3 40 50 80 00       	mov    %eax,0x805040
  802af5:	8b 45 08             	mov    0x8(%ebp),%eax
  802af8:	a3 44 50 80 00       	mov    %eax,0x805044
  802afd:	8b 45 08             	mov    0x8(%ebp),%eax
  802b00:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b06:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b0b:	40                   	inc    %eax
  802b0c:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802b11:	e9 e7 00 00 00       	jmp    802bfd <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802b16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b19:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802b1c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802b23:	a1 40 50 80 00       	mov    0x805040,%eax
  802b28:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b2b:	e9 9d 00 00 00       	jmp    802bcd <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b33:	8b 00                	mov    (%eax),%eax
  802b35:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802b38:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3b:	8b 50 08             	mov    0x8(%eax),%edx
  802b3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b41:	8b 40 08             	mov    0x8(%eax),%eax
  802b44:	39 c2                	cmp    %eax,%edx
  802b46:	76 7d                	jbe    802bc5 <insert_sorted_allocList+0x251>
  802b48:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4b:	8b 50 08             	mov    0x8(%eax),%edx
  802b4e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b51:	8b 40 08             	mov    0x8(%eax),%eax
  802b54:	39 c2                	cmp    %eax,%edx
  802b56:	73 6d                	jae    802bc5 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802b58:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b5c:	74 06                	je     802b64 <insert_sorted_allocList+0x1f0>
  802b5e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b62:	75 14                	jne    802b78 <insert_sorted_allocList+0x204>
  802b64:	83 ec 04             	sub    $0x4,%esp
  802b67:	68 00 49 80 00       	push   $0x804900
  802b6c:	6a 7f                	push   $0x7f
  802b6e:	68 8b 48 80 00       	push   $0x80488b
  802b73:	e8 5f dd ff ff       	call   8008d7 <_panic>
  802b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7b:	8b 10                	mov    (%eax),%edx
  802b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b80:	89 10                	mov    %edx,(%eax)
  802b82:	8b 45 08             	mov    0x8(%ebp),%eax
  802b85:	8b 00                	mov    (%eax),%eax
  802b87:	85 c0                	test   %eax,%eax
  802b89:	74 0b                	je     802b96 <insert_sorted_allocList+0x222>
  802b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8e:	8b 00                	mov    (%eax),%eax
  802b90:	8b 55 08             	mov    0x8(%ebp),%edx
  802b93:	89 50 04             	mov    %edx,0x4(%eax)
  802b96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b99:	8b 55 08             	mov    0x8(%ebp),%edx
  802b9c:	89 10                	mov    %edx,(%eax)
  802b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ba4:	89 50 04             	mov    %edx,0x4(%eax)
  802ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  802baa:	8b 00                	mov    (%eax),%eax
  802bac:	85 c0                	test   %eax,%eax
  802bae:	75 08                	jne    802bb8 <insert_sorted_allocList+0x244>
  802bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb3:	a3 44 50 80 00       	mov    %eax,0x805044
  802bb8:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802bbd:	40                   	inc    %eax
  802bbe:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802bc3:	eb 39                	jmp    802bfe <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802bc5:	a1 48 50 80 00       	mov    0x805048,%eax
  802bca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bcd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bd1:	74 07                	je     802bda <insert_sorted_allocList+0x266>
  802bd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd6:	8b 00                	mov    (%eax),%eax
  802bd8:	eb 05                	jmp    802bdf <insert_sorted_allocList+0x26b>
  802bda:	b8 00 00 00 00       	mov    $0x0,%eax
  802bdf:	a3 48 50 80 00       	mov    %eax,0x805048
  802be4:	a1 48 50 80 00       	mov    0x805048,%eax
  802be9:	85 c0                	test   %eax,%eax
  802beb:	0f 85 3f ff ff ff    	jne    802b30 <insert_sorted_allocList+0x1bc>
  802bf1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bf5:	0f 85 35 ff ff ff    	jne    802b30 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802bfb:	eb 01                	jmp    802bfe <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802bfd:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802bfe:	90                   	nop
  802bff:	c9                   	leave  
  802c00:	c3                   	ret    

00802c01 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802c01:	55                   	push   %ebp
  802c02:	89 e5                	mov    %esp,%ebp
  802c04:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802c07:	a1 38 51 80 00       	mov    0x805138,%eax
  802c0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c0f:	e9 85 01 00 00       	jmp    802d99 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c17:	8b 40 0c             	mov    0xc(%eax),%eax
  802c1a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c1d:	0f 82 6e 01 00 00    	jb     802d91 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802c23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c26:	8b 40 0c             	mov    0xc(%eax),%eax
  802c29:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c2c:	0f 85 8a 00 00 00    	jne    802cbc <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802c32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c36:	75 17                	jne    802c4f <alloc_block_FF+0x4e>
  802c38:	83 ec 04             	sub    $0x4,%esp
  802c3b:	68 34 49 80 00       	push   $0x804934
  802c40:	68 93 00 00 00       	push   $0x93
  802c45:	68 8b 48 80 00       	push   $0x80488b
  802c4a:	e8 88 dc ff ff       	call   8008d7 <_panic>
  802c4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c52:	8b 00                	mov    (%eax),%eax
  802c54:	85 c0                	test   %eax,%eax
  802c56:	74 10                	je     802c68 <alloc_block_FF+0x67>
  802c58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5b:	8b 00                	mov    (%eax),%eax
  802c5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c60:	8b 52 04             	mov    0x4(%edx),%edx
  802c63:	89 50 04             	mov    %edx,0x4(%eax)
  802c66:	eb 0b                	jmp    802c73 <alloc_block_FF+0x72>
  802c68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6b:	8b 40 04             	mov    0x4(%eax),%eax
  802c6e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c76:	8b 40 04             	mov    0x4(%eax),%eax
  802c79:	85 c0                	test   %eax,%eax
  802c7b:	74 0f                	je     802c8c <alloc_block_FF+0x8b>
  802c7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c80:	8b 40 04             	mov    0x4(%eax),%eax
  802c83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c86:	8b 12                	mov    (%edx),%edx
  802c88:	89 10                	mov    %edx,(%eax)
  802c8a:	eb 0a                	jmp    802c96 <alloc_block_FF+0x95>
  802c8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8f:	8b 00                	mov    (%eax),%eax
  802c91:	a3 38 51 80 00       	mov    %eax,0x805138
  802c96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c99:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ca9:	a1 44 51 80 00       	mov    0x805144,%eax
  802cae:	48                   	dec    %eax
  802caf:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802cb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb7:	e9 10 01 00 00       	jmp    802dcc <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802cbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbf:	8b 40 0c             	mov    0xc(%eax),%eax
  802cc2:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cc5:	0f 86 c6 00 00 00    	jbe    802d91 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802ccb:	a1 48 51 80 00       	mov    0x805148,%eax
  802cd0:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802cd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd6:	8b 50 08             	mov    0x8(%eax),%edx
  802cd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cdc:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802cdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce2:	8b 55 08             	mov    0x8(%ebp),%edx
  802ce5:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802ce8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cec:	75 17                	jne    802d05 <alloc_block_FF+0x104>
  802cee:	83 ec 04             	sub    $0x4,%esp
  802cf1:	68 34 49 80 00       	push   $0x804934
  802cf6:	68 9b 00 00 00       	push   $0x9b
  802cfb:	68 8b 48 80 00       	push   $0x80488b
  802d00:	e8 d2 db ff ff       	call   8008d7 <_panic>
  802d05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d08:	8b 00                	mov    (%eax),%eax
  802d0a:	85 c0                	test   %eax,%eax
  802d0c:	74 10                	je     802d1e <alloc_block_FF+0x11d>
  802d0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d11:	8b 00                	mov    (%eax),%eax
  802d13:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d16:	8b 52 04             	mov    0x4(%edx),%edx
  802d19:	89 50 04             	mov    %edx,0x4(%eax)
  802d1c:	eb 0b                	jmp    802d29 <alloc_block_FF+0x128>
  802d1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d21:	8b 40 04             	mov    0x4(%eax),%eax
  802d24:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d2c:	8b 40 04             	mov    0x4(%eax),%eax
  802d2f:	85 c0                	test   %eax,%eax
  802d31:	74 0f                	je     802d42 <alloc_block_FF+0x141>
  802d33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d36:	8b 40 04             	mov    0x4(%eax),%eax
  802d39:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d3c:	8b 12                	mov    (%edx),%edx
  802d3e:	89 10                	mov    %edx,(%eax)
  802d40:	eb 0a                	jmp    802d4c <alloc_block_FF+0x14b>
  802d42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d45:	8b 00                	mov    (%eax),%eax
  802d47:	a3 48 51 80 00       	mov    %eax,0x805148
  802d4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d58:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d5f:	a1 54 51 80 00       	mov    0x805154,%eax
  802d64:	48                   	dec    %eax
  802d65:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802d6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6d:	8b 50 08             	mov    0x8(%eax),%edx
  802d70:	8b 45 08             	mov    0x8(%ebp),%eax
  802d73:	01 c2                	add    %eax,%edx
  802d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d78:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802d7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7e:	8b 40 0c             	mov    0xc(%eax),%eax
  802d81:	2b 45 08             	sub    0x8(%ebp),%eax
  802d84:	89 c2                	mov    %eax,%edx
  802d86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d89:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802d8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d8f:	eb 3b                	jmp    802dcc <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802d91:	a1 40 51 80 00       	mov    0x805140,%eax
  802d96:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d99:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d9d:	74 07                	je     802da6 <alloc_block_FF+0x1a5>
  802d9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da2:	8b 00                	mov    (%eax),%eax
  802da4:	eb 05                	jmp    802dab <alloc_block_FF+0x1aa>
  802da6:	b8 00 00 00 00       	mov    $0x0,%eax
  802dab:	a3 40 51 80 00       	mov    %eax,0x805140
  802db0:	a1 40 51 80 00       	mov    0x805140,%eax
  802db5:	85 c0                	test   %eax,%eax
  802db7:	0f 85 57 fe ff ff    	jne    802c14 <alloc_block_FF+0x13>
  802dbd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dc1:	0f 85 4d fe ff ff    	jne    802c14 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802dc7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802dcc:	c9                   	leave  
  802dcd:	c3                   	ret    

00802dce <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802dce:	55                   	push   %ebp
  802dcf:	89 e5                	mov    %esp,%ebp
  802dd1:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802dd4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802ddb:	a1 38 51 80 00       	mov    0x805138,%eax
  802de0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802de3:	e9 df 00 00 00       	jmp    802ec7 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802de8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802deb:	8b 40 0c             	mov    0xc(%eax),%eax
  802dee:	3b 45 08             	cmp    0x8(%ebp),%eax
  802df1:	0f 82 c8 00 00 00    	jb     802ebf <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfa:	8b 40 0c             	mov    0xc(%eax),%eax
  802dfd:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e00:	0f 85 8a 00 00 00    	jne    802e90 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802e06:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e0a:	75 17                	jne    802e23 <alloc_block_BF+0x55>
  802e0c:	83 ec 04             	sub    $0x4,%esp
  802e0f:	68 34 49 80 00       	push   $0x804934
  802e14:	68 b7 00 00 00       	push   $0xb7
  802e19:	68 8b 48 80 00       	push   $0x80488b
  802e1e:	e8 b4 da ff ff       	call   8008d7 <_panic>
  802e23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e26:	8b 00                	mov    (%eax),%eax
  802e28:	85 c0                	test   %eax,%eax
  802e2a:	74 10                	je     802e3c <alloc_block_BF+0x6e>
  802e2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2f:	8b 00                	mov    (%eax),%eax
  802e31:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e34:	8b 52 04             	mov    0x4(%edx),%edx
  802e37:	89 50 04             	mov    %edx,0x4(%eax)
  802e3a:	eb 0b                	jmp    802e47 <alloc_block_BF+0x79>
  802e3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3f:	8b 40 04             	mov    0x4(%eax),%eax
  802e42:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4a:	8b 40 04             	mov    0x4(%eax),%eax
  802e4d:	85 c0                	test   %eax,%eax
  802e4f:	74 0f                	je     802e60 <alloc_block_BF+0x92>
  802e51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e54:	8b 40 04             	mov    0x4(%eax),%eax
  802e57:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e5a:	8b 12                	mov    (%edx),%edx
  802e5c:	89 10                	mov    %edx,(%eax)
  802e5e:	eb 0a                	jmp    802e6a <alloc_block_BF+0x9c>
  802e60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e63:	8b 00                	mov    (%eax),%eax
  802e65:	a3 38 51 80 00       	mov    %eax,0x805138
  802e6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e76:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e7d:	a1 44 51 80 00       	mov    0x805144,%eax
  802e82:	48                   	dec    %eax
  802e83:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802e88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8b:	e9 4d 01 00 00       	jmp    802fdd <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802e90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e93:	8b 40 0c             	mov    0xc(%eax),%eax
  802e96:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e99:	76 24                	jbe    802ebf <alloc_block_BF+0xf1>
  802e9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9e:	8b 40 0c             	mov    0xc(%eax),%eax
  802ea1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802ea4:	73 19                	jae    802ebf <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802ea6:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802ead:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb0:	8b 40 0c             	mov    0xc(%eax),%eax
  802eb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802eb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb9:	8b 40 08             	mov    0x8(%eax),%eax
  802ebc:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802ebf:	a1 40 51 80 00       	mov    0x805140,%eax
  802ec4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ec7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ecb:	74 07                	je     802ed4 <alloc_block_BF+0x106>
  802ecd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed0:	8b 00                	mov    (%eax),%eax
  802ed2:	eb 05                	jmp    802ed9 <alloc_block_BF+0x10b>
  802ed4:	b8 00 00 00 00       	mov    $0x0,%eax
  802ed9:	a3 40 51 80 00       	mov    %eax,0x805140
  802ede:	a1 40 51 80 00       	mov    0x805140,%eax
  802ee3:	85 c0                	test   %eax,%eax
  802ee5:	0f 85 fd fe ff ff    	jne    802de8 <alloc_block_BF+0x1a>
  802eeb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eef:	0f 85 f3 fe ff ff    	jne    802de8 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802ef5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ef9:	0f 84 d9 00 00 00    	je     802fd8 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802eff:	a1 48 51 80 00       	mov    0x805148,%eax
  802f04:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802f07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f0a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f0d:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802f10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f13:	8b 55 08             	mov    0x8(%ebp),%edx
  802f16:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802f19:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802f1d:	75 17                	jne    802f36 <alloc_block_BF+0x168>
  802f1f:	83 ec 04             	sub    $0x4,%esp
  802f22:	68 34 49 80 00       	push   $0x804934
  802f27:	68 c7 00 00 00       	push   $0xc7
  802f2c:	68 8b 48 80 00       	push   $0x80488b
  802f31:	e8 a1 d9 ff ff       	call   8008d7 <_panic>
  802f36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f39:	8b 00                	mov    (%eax),%eax
  802f3b:	85 c0                	test   %eax,%eax
  802f3d:	74 10                	je     802f4f <alloc_block_BF+0x181>
  802f3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f42:	8b 00                	mov    (%eax),%eax
  802f44:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f47:	8b 52 04             	mov    0x4(%edx),%edx
  802f4a:	89 50 04             	mov    %edx,0x4(%eax)
  802f4d:	eb 0b                	jmp    802f5a <alloc_block_BF+0x18c>
  802f4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f52:	8b 40 04             	mov    0x4(%eax),%eax
  802f55:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f5d:	8b 40 04             	mov    0x4(%eax),%eax
  802f60:	85 c0                	test   %eax,%eax
  802f62:	74 0f                	je     802f73 <alloc_block_BF+0x1a5>
  802f64:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f67:	8b 40 04             	mov    0x4(%eax),%eax
  802f6a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f6d:	8b 12                	mov    (%edx),%edx
  802f6f:	89 10                	mov    %edx,(%eax)
  802f71:	eb 0a                	jmp    802f7d <alloc_block_BF+0x1af>
  802f73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f76:	8b 00                	mov    (%eax),%eax
  802f78:	a3 48 51 80 00       	mov    %eax,0x805148
  802f7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f80:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f89:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f90:	a1 54 51 80 00       	mov    0x805154,%eax
  802f95:	48                   	dec    %eax
  802f96:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802f9b:	83 ec 08             	sub    $0x8,%esp
  802f9e:	ff 75 ec             	pushl  -0x14(%ebp)
  802fa1:	68 38 51 80 00       	push   $0x805138
  802fa6:	e8 71 f9 ff ff       	call   80291c <find_block>
  802fab:	83 c4 10             	add    $0x10,%esp
  802fae:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802fb1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fb4:	8b 50 08             	mov    0x8(%eax),%edx
  802fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fba:	01 c2                	add    %eax,%edx
  802fbc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fbf:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802fc2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fc5:	8b 40 0c             	mov    0xc(%eax),%eax
  802fc8:	2b 45 08             	sub    0x8(%ebp),%eax
  802fcb:	89 c2                	mov    %eax,%edx
  802fcd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fd0:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802fd3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fd6:	eb 05                	jmp    802fdd <alloc_block_BF+0x20f>
	}
	return NULL;
  802fd8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802fdd:	c9                   	leave  
  802fde:	c3                   	ret    

00802fdf <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802fdf:	55                   	push   %ebp
  802fe0:	89 e5                	mov    %esp,%ebp
  802fe2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802fe5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802fea:	85 c0                	test   %eax,%eax
  802fec:	0f 85 de 01 00 00    	jne    8031d0 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802ff2:	a1 38 51 80 00       	mov    0x805138,%eax
  802ff7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ffa:	e9 9e 01 00 00       	jmp    80319d <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802fff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803002:	8b 40 0c             	mov    0xc(%eax),%eax
  803005:	3b 45 08             	cmp    0x8(%ebp),%eax
  803008:	0f 82 87 01 00 00    	jb     803195 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  80300e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803011:	8b 40 0c             	mov    0xc(%eax),%eax
  803014:	3b 45 08             	cmp    0x8(%ebp),%eax
  803017:	0f 85 95 00 00 00    	jne    8030b2 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  80301d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803021:	75 17                	jne    80303a <alloc_block_NF+0x5b>
  803023:	83 ec 04             	sub    $0x4,%esp
  803026:	68 34 49 80 00       	push   $0x804934
  80302b:	68 e0 00 00 00       	push   $0xe0
  803030:	68 8b 48 80 00       	push   $0x80488b
  803035:	e8 9d d8 ff ff       	call   8008d7 <_panic>
  80303a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303d:	8b 00                	mov    (%eax),%eax
  80303f:	85 c0                	test   %eax,%eax
  803041:	74 10                	je     803053 <alloc_block_NF+0x74>
  803043:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803046:	8b 00                	mov    (%eax),%eax
  803048:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80304b:	8b 52 04             	mov    0x4(%edx),%edx
  80304e:	89 50 04             	mov    %edx,0x4(%eax)
  803051:	eb 0b                	jmp    80305e <alloc_block_NF+0x7f>
  803053:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803056:	8b 40 04             	mov    0x4(%eax),%eax
  803059:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80305e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803061:	8b 40 04             	mov    0x4(%eax),%eax
  803064:	85 c0                	test   %eax,%eax
  803066:	74 0f                	je     803077 <alloc_block_NF+0x98>
  803068:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306b:	8b 40 04             	mov    0x4(%eax),%eax
  80306e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803071:	8b 12                	mov    (%edx),%edx
  803073:	89 10                	mov    %edx,(%eax)
  803075:	eb 0a                	jmp    803081 <alloc_block_NF+0xa2>
  803077:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307a:	8b 00                	mov    (%eax),%eax
  80307c:	a3 38 51 80 00       	mov    %eax,0x805138
  803081:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803084:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80308a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803094:	a1 44 51 80 00       	mov    0x805144,%eax
  803099:	48                   	dec    %eax
  80309a:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  80309f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a2:	8b 40 08             	mov    0x8(%eax),%eax
  8030a5:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   return  point;
  8030aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ad:	e9 f8 04 00 00       	jmp    8035aa <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8030b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8030b8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030bb:	0f 86 d4 00 00 00    	jbe    803195 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8030c1:	a1 48 51 80 00       	mov    0x805148,%eax
  8030c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8030c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030cc:	8b 50 08             	mov    0x8(%eax),%edx
  8030cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030d2:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8030d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8030db:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8030de:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030e2:	75 17                	jne    8030fb <alloc_block_NF+0x11c>
  8030e4:	83 ec 04             	sub    $0x4,%esp
  8030e7:	68 34 49 80 00       	push   $0x804934
  8030ec:	68 e9 00 00 00       	push   $0xe9
  8030f1:	68 8b 48 80 00       	push   $0x80488b
  8030f6:	e8 dc d7 ff ff       	call   8008d7 <_panic>
  8030fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030fe:	8b 00                	mov    (%eax),%eax
  803100:	85 c0                	test   %eax,%eax
  803102:	74 10                	je     803114 <alloc_block_NF+0x135>
  803104:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803107:	8b 00                	mov    (%eax),%eax
  803109:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80310c:	8b 52 04             	mov    0x4(%edx),%edx
  80310f:	89 50 04             	mov    %edx,0x4(%eax)
  803112:	eb 0b                	jmp    80311f <alloc_block_NF+0x140>
  803114:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803117:	8b 40 04             	mov    0x4(%eax),%eax
  80311a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80311f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803122:	8b 40 04             	mov    0x4(%eax),%eax
  803125:	85 c0                	test   %eax,%eax
  803127:	74 0f                	je     803138 <alloc_block_NF+0x159>
  803129:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80312c:	8b 40 04             	mov    0x4(%eax),%eax
  80312f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803132:	8b 12                	mov    (%edx),%edx
  803134:	89 10                	mov    %edx,(%eax)
  803136:	eb 0a                	jmp    803142 <alloc_block_NF+0x163>
  803138:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80313b:	8b 00                	mov    (%eax),%eax
  80313d:	a3 48 51 80 00       	mov    %eax,0x805148
  803142:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803145:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80314b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80314e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803155:	a1 54 51 80 00       	mov    0x805154,%eax
  80315a:	48                   	dec    %eax
  80315b:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  803160:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803163:	8b 40 08             	mov    0x8(%eax),%eax
  803166:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   point->sva += size;
  80316b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316e:	8b 50 08             	mov    0x8(%eax),%edx
  803171:	8b 45 08             	mov    0x8(%ebp),%eax
  803174:	01 c2                	add    %eax,%edx
  803176:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803179:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  80317c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317f:	8b 40 0c             	mov    0xc(%eax),%eax
  803182:	2b 45 08             	sub    0x8(%ebp),%eax
  803185:	89 c2                	mov    %eax,%edx
  803187:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318a:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  80318d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803190:	e9 15 04 00 00       	jmp    8035aa <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  803195:	a1 40 51 80 00       	mov    0x805140,%eax
  80319a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80319d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031a1:	74 07                	je     8031aa <alloc_block_NF+0x1cb>
  8031a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a6:	8b 00                	mov    (%eax),%eax
  8031a8:	eb 05                	jmp    8031af <alloc_block_NF+0x1d0>
  8031aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8031af:	a3 40 51 80 00       	mov    %eax,0x805140
  8031b4:	a1 40 51 80 00       	mov    0x805140,%eax
  8031b9:	85 c0                	test   %eax,%eax
  8031bb:	0f 85 3e fe ff ff    	jne    802fff <alloc_block_NF+0x20>
  8031c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031c5:	0f 85 34 fe ff ff    	jne    802fff <alloc_block_NF+0x20>
  8031cb:	e9 d5 03 00 00       	jmp    8035a5 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8031d0:	a1 38 51 80 00       	mov    0x805138,%eax
  8031d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031d8:	e9 b1 01 00 00       	jmp    80338e <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8031dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e0:	8b 50 08             	mov    0x8(%eax),%edx
  8031e3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031e8:	39 c2                	cmp    %eax,%edx
  8031ea:	0f 82 96 01 00 00    	jb     803386 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8031f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8031f6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031f9:	0f 82 87 01 00 00    	jb     803386 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8031ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803202:	8b 40 0c             	mov    0xc(%eax),%eax
  803205:	3b 45 08             	cmp    0x8(%ebp),%eax
  803208:	0f 85 95 00 00 00    	jne    8032a3 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80320e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803212:	75 17                	jne    80322b <alloc_block_NF+0x24c>
  803214:	83 ec 04             	sub    $0x4,%esp
  803217:	68 34 49 80 00       	push   $0x804934
  80321c:	68 fc 00 00 00       	push   $0xfc
  803221:	68 8b 48 80 00       	push   $0x80488b
  803226:	e8 ac d6 ff ff       	call   8008d7 <_panic>
  80322b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322e:	8b 00                	mov    (%eax),%eax
  803230:	85 c0                	test   %eax,%eax
  803232:	74 10                	je     803244 <alloc_block_NF+0x265>
  803234:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803237:	8b 00                	mov    (%eax),%eax
  803239:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80323c:	8b 52 04             	mov    0x4(%edx),%edx
  80323f:	89 50 04             	mov    %edx,0x4(%eax)
  803242:	eb 0b                	jmp    80324f <alloc_block_NF+0x270>
  803244:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803247:	8b 40 04             	mov    0x4(%eax),%eax
  80324a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80324f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803252:	8b 40 04             	mov    0x4(%eax),%eax
  803255:	85 c0                	test   %eax,%eax
  803257:	74 0f                	je     803268 <alloc_block_NF+0x289>
  803259:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325c:	8b 40 04             	mov    0x4(%eax),%eax
  80325f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803262:	8b 12                	mov    (%edx),%edx
  803264:	89 10                	mov    %edx,(%eax)
  803266:	eb 0a                	jmp    803272 <alloc_block_NF+0x293>
  803268:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326b:	8b 00                	mov    (%eax),%eax
  80326d:	a3 38 51 80 00       	mov    %eax,0x805138
  803272:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803275:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80327b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80327e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803285:	a1 44 51 80 00       	mov    0x805144,%eax
  80328a:	48                   	dec    %eax
  80328b:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803290:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803293:	8b 40 08             	mov    0x8(%eax),%eax
  803296:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  80329b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80329e:	e9 07 03 00 00       	jmp    8035aa <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8032a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8032a9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032ac:	0f 86 d4 00 00 00    	jbe    803386 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8032b2:	a1 48 51 80 00       	mov    0x805148,%eax
  8032b7:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8032ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032bd:	8b 50 08             	mov    0x8(%eax),%edx
  8032c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c3:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8032c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8032cc:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8032cf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032d3:	75 17                	jne    8032ec <alloc_block_NF+0x30d>
  8032d5:	83 ec 04             	sub    $0x4,%esp
  8032d8:	68 34 49 80 00       	push   $0x804934
  8032dd:	68 04 01 00 00       	push   $0x104
  8032e2:	68 8b 48 80 00       	push   $0x80488b
  8032e7:	e8 eb d5 ff ff       	call   8008d7 <_panic>
  8032ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ef:	8b 00                	mov    (%eax),%eax
  8032f1:	85 c0                	test   %eax,%eax
  8032f3:	74 10                	je     803305 <alloc_block_NF+0x326>
  8032f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f8:	8b 00                	mov    (%eax),%eax
  8032fa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032fd:	8b 52 04             	mov    0x4(%edx),%edx
  803300:	89 50 04             	mov    %edx,0x4(%eax)
  803303:	eb 0b                	jmp    803310 <alloc_block_NF+0x331>
  803305:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803308:	8b 40 04             	mov    0x4(%eax),%eax
  80330b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803310:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803313:	8b 40 04             	mov    0x4(%eax),%eax
  803316:	85 c0                	test   %eax,%eax
  803318:	74 0f                	je     803329 <alloc_block_NF+0x34a>
  80331a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80331d:	8b 40 04             	mov    0x4(%eax),%eax
  803320:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803323:	8b 12                	mov    (%edx),%edx
  803325:	89 10                	mov    %edx,(%eax)
  803327:	eb 0a                	jmp    803333 <alloc_block_NF+0x354>
  803329:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80332c:	8b 00                	mov    (%eax),%eax
  80332e:	a3 48 51 80 00       	mov    %eax,0x805148
  803333:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803336:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80333c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80333f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803346:	a1 54 51 80 00       	mov    0x805154,%eax
  80334b:	48                   	dec    %eax
  80334c:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803351:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803354:	8b 40 08             	mov    0x8(%eax),%eax
  803357:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  80335c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335f:	8b 50 08             	mov    0x8(%eax),%edx
  803362:	8b 45 08             	mov    0x8(%ebp),%eax
  803365:	01 c2                	add    %eax,%edx
  803367:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336a:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80336d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803370:	8b 40 0c             	mov    0xc(%eax),%eax
  803373:	2b 45 08             	sub    0x8(%ebp),%eax
  803376:	89 c2                	mov    %eax,%edx
  803378:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80337b:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  80337e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803381:	e9 24 02 00 00       	jmp    8035aa <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803386:	a1 40 51 80 00       	mov    0x805140,%eax
  80338b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80338e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803392:	74 07                	je     80339b <alloc_block_NF+0x3bc>
  803394:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803397:	8b 00                	mov    (%eax),%eax
  803399:	eb 05                	jmp    8033a0 <alloc_block_NF+0x3c1>
  80339b:	b8 00 00 00 00       	mov    $0x0,%eax
  8033a0:	a3 40 51 80 00       	mov    %eax,0x805140
  8033a5:	a1 40 51 80 00       	mov    0x805140,%eax
  8033aa:	85 c0                	test   %eax,%eax
  8033ac:	0f 85 2b fe ff ff    	jne    8031dd <alloc_block_NF+0x1fe>
  8033b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033b6:	0f 85 21 fe ff ff    	jne    8031dd <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8033bc:	a1 38 51 80 00       	mov    0x805138,%eax
  8033c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033c4:	e9 ae 01 00 00       	jmp    803577 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8033c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033cc:	8b 50 08             	mov    0x8(%eax),%edx
  8033cf:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8033d4:	39 c2                	cmp    %eax,%edx
  8033d6:	0f 83 93 01 00 00    	jae    80356f <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  8033dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033df:	8b 40 0c             	mov    0xc(%eax),%eax
  8033e2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033e5:	0f 82 84 01 00 00    	jb     80356f <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  8033eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8033f1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033f4:	0f 85 95 00 00 00    	jne    80348f <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8033fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033fe:	75 17                	jne    803417 <alloc_block_NF+0x438>
  803400:	83 ec 04             	sub    $0x4,%esp
  803403:	68 34 49 80 00       	push   $0x804934
  803408:	68 14 01 00 00       	push   $0x114
  80340d:	68 8b 48 80 00       	push   $0x80488b
  803412:	e8 c0 d4 ff ff       	call   8008d7 <_panic>
  803417:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80341a:	8b 00                	mov    (%eax),%eax
  80341c:	85 c0                	test   %eax,%eax
  80341e:	74 10                	je     803430 <alloc_block_NF+0x451>
  803420:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803423:	8b 00                	mov    (%eax),%eax
  803425:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803428:	8b 52 04             	mov    0x4(%edx),%edx
  80342b:	89 50 04             	mov    %edx,0x4(%eax)
  80342e:	eb 0b                	jmp    80343b <alloc_block_NF+0x45c>
  803430:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803433:	8b 40 04             	mov    0x4(%eax),%eax
  803436:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80343b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343e:	8b 40 04             	mov    0x4(%eax),%eax
  803441:	85 c0                	test   %eax,%eax
  803443:	74 0f                	je     803454 <alloc_block_NF+0x475>
  803445:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803448:	8b 40 04             	mov    0x4(%eax),%eax
  80344b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80344e:	8b 12                	mov    (%edx),%edx
  803450:	89 10                	mov    %edx,(%eax)
  803452:	eb 0a                	jmp    80345e <alloc_block_NF+0x47f>
  803454:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803457:	8b 00                	mov    (%eax),%eax
  803459:	a3 38 51 80 00       	mov    %eax,0x805138
  80345e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803461:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803467:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80346a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803471:	a1 44 51 80 00       	mov    0x805144,%eax
  803476:	48                   	dec    %eax
  803477:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  80347c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80347f:	8b 40 08             	mov    0x8(%eax),%eax
  803482:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  803487:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80348a:	e9 1b 01 00 00       	jmp    8035aa <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80348f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803492:	8b 40 0c             	mov    0xc(%eax),%eax
  803495:	3b 45 08             	cmp    0x8(%ebp),%eax
  803498:	0f 86 d1 00 00 00    	jbe    80356f <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80349e:	a1 48 51 80 00       	mov    0x805148,%eax
  8034a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  8034a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a9:	8b 50 08             	mov    0x8(%eax),%edx
  8034ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034af:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8034b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8034b8:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8034bb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8034bf:	75 17                	jne    8034d8 <alloc_block_NF+0x4f9>
  8034c1:	83 ec 04             	sub    $0x4,%esp
  8034c4:	68 34 49 80 00       	push   $0x804934
  8034c9:	68 1c 01 00 00       	push   $0x11c
  8034ce:	68 8b 48 80 00       	push   $0x80488b
  8034d3:	e8 ff d3 ff ff       	call   8008d7 <_panic>
  8034d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034db:	8b 00                	mov    (%eax),%eax
  8034dd:	85 c0                	test   %eax,%eax
  8034df:	74 10                	je     8034f1 <alloc_block_NF+0x512>
  8034e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034e4:	8b 00                	mov    (%eax),%eax
  8034e6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8034e9:	8b 52 04             	mov    0x4(%edx),%edx
  8034ec:	89 50 04             	mov    %edx,0x4(%eax)
  8034ef:	eb 0b                	jmp    8034fc <alloc_block_NF+0x51d>
  8034f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034f4:	8b 40 04             	mov    0x4(%eax),%eax
  8034f7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034ff:	8b 40 04             	mov    0x4(%eax),%eax
  803502:	85 c0                	test   %eax,%eax
  803504:	74 0f                	je     803515 <alloc_block_NF+0x536>
  803506:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803509:	8b 40 04             	mov    0x4(%eax),%eax
  80350c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80350f:	8b 12                	mov    (%edx),%edx
  803511:	89 10                	mov    %edx,(%eax)
  803513:	eb 0a                	jmp    80351f <alloc_block_NF+0x540>
  803515:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803518:	8b 00                	mov    (%eax),%eax
  80351a:	a3 48 51 80 00       	mov    %eax,0x805148
  80351f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803522:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803528:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80352b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803532:	a1 54 51 80 00       	mov    0x805154,%eax
  803537:	48                   	dec    %eax
  803538:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  80353d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803540:	8b 40 08             	mov    0x8(%eax),%eax
  803543:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  803548:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80354b:	8b 50 08             	mov    0x8(%eax),%edx
  80354e:	8b 45 08             	mov    0x8(%ebp),%eax
  803551:	01 c2                	add    %eax,%edx
  803553:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803556:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803559:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80355c:	8b 40 0c             	mov    0xc(%eax),%eax
  80355f:	2b 45 08             	sub    0x8(%ebp),%eax
  803562:	89 c2                	mov    %eax,%edx
  803564:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803567:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  80356a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80356d:	eb 3b                	jmp    8035aa <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  80356f:	a1 40 51 80 00       	mov    0x805140,%eax
  803574:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803577:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80357b:	74 07                	je     803584 <alloc_block_NF+0x5a5>
  80357d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803580:	8b 00                	mov    (%eax),%eax
  803582:	eb 05                	jmp    803589 <alloc_block_NF+0x5aa>
  803584:	b8 00 00 00 00       	mov    $0x0,%eax
  803589:	a3 40 51 80 00       	mov    %eax,0x805140
  80358e:	a1 40 51 80 00       	mov    0x805140,%eax
  803593:	85 c0                	test   %eax,%eax
  803595:	0f 85 2e fe ff ff    	jne    8033c9 <alloc_block_NF+0x3ea>
  80359b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80359f:	0f 85 24 fe ff ff    	jne    8033c9 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  8035a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8035aa:	c9                   	leave  
  8035ab:	c3                   	ret    

008035ac <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8035ac:	55                   	push   %ebp
  8035ad:	89 e5                	mov    %esp,%ebp
  8035af:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  8035b2:	a1 38 51 80 00       	mov    0x805138,%eax
  8035b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  8035ba:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8035bf:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  8035c2:	a1 38 51 80 00       	mov    0x805138,%eax
  8035c7:	85 c0                	test   %eax,%eax
  8035c9:	74 14                	je     8035df <insert_sorted_with_merge_freeList+0x33>
  8035cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ce:	8b 50 08             	mov    0x8(%eax),%edx
  8035d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035d4:	8b 40 08             	mov    0x8(%eax),%eax
  8035d7:	39 c2                	cmp    %eax,%edx
  8035d9:	0f 87 9b 01 00 00    	ja     80377a <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  8035df:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035e3:	75 17                	jne    8035fc <insert_sorted_with_merge_freeList+0x50>
  8035e5:	83 ec 04             	sub    $0x4,%esp
  8035e8:	68 68 48 80 00       	push   $0x804868
  8035ed:	68 38 01 00 00       	push   $0x138
  8035f2:	68 8b 48 80 00       	push   $0x80488b
  8035f7:	e8 db d2 ff ff       	call   8008d7 <_panic>
  8035fc:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803602:	8b 45 08             	mov    0x8(%ebp),%eax
  803605:	89 10                	mov    %edx,(%eax)
  803607:	8b 45 08             	mov    0x8(%ebp),%eax
  80360a:	8b 00                	mov    (%eax),%eax
  80360c:	85 c0                	test   %eax,%eax
  80360e:	74 0d                	je     80361d <insert_sorted_with_merge_freeList+0x71>
  803610:	a1 38 51 80 00       	mov    0x805138,%eax
  803615:	8b 55 08             	mov    0x8(%ebp),%edx
  803618:	89 50 04             	mov    %edx,0x4(%eax)
  80361b:	eb 08                	jmp    803625 <insert_sorted_with_merge_freeList+0x79>
  80361d:	8b 45 08             	mov    0x8(%ebp),%eax
  803620:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803625:	8b 45 08             	mov    0x8(%ebp),%eax
  803628:	a3 38 51 80 00       	mov    %eax,0x805138
  80362d:	8b 45 08             	mov    0x8(%ebp),%eax
  803630:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803637:	a1 44 51 80 00       	mov    0x805144,%eax
  80363c:	40                   	inc    %eax
  80363d:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803642:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803646:	0f 84 a8 06 00 00    	je     803cf4 <insert_sorted_with_merge_freeList+0x748>
  80364c:	8b 45 08             	mov    0x8(%ebp),%eax
  80364f:	8b 50 08             	mov    0x8(%eax),%edx
  803652:	8b 45 08             	mov    0x8(%ebp),%eax
  803655:	8b 40 0c             	mov    0xc(%eax),%eax
  803658:	01 c2                	add    %eax,%edx
  80365a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80365d:	8b 40 08             	mov    0x8(%eax),%eax
  803660:	39 c2                	cmp    %eax,%edx
  803662:	0f 85 8c 06 00 00    	jne    803cf4 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  803668:	8b 45 08             	mov    0x8(%ebp),%eax
  80366b:	8b 50 0c             	mov    0xc(%eax),%edx
  80366e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803671:	8b 40 0c             	mov    0xc(%eax),%eax
  803674:	01 c2                	add    %eax,%edx
  803676:	8b 45 08             	mov    0x8(%ebp),%eax
  803679:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  80367c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803680:	75 17                	jne    803699 <insert_sorted_with_merge_freeList+0xed>
  803682:	83 ec 04             	sub    $0x4,%esp
  803685:	68 34 49 80 00       	push   $0x804934
  80368a:	68 3c 01 00 00       	push   $0x13c
  80368f:	68 8b 48 80 00       	push   $0x80488b
  803694:	e8 3e d2 ff ff       	call   8008d7 <_panic>
  803699:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80369c:	8b 00                	mov    (%eax),%eax
  80369e:	85 c0                	test   %eax,%eax
  8036a0:	74 10                	je     8036b2 <insert_sorted_with_merge_freeList+0x106>
  8036a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036a5:	8b 00                	mov    (%eax),%eax
  8036a7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036aa:	8b 52 04             	mov    0x4(%edx),%edx
  8036ad:	89 50 04             	mov    %edx,0x4(%eax)
  8036b0:	eb 0b                	jmp    8036bd <insert_sorted_with_merge_freeList+0x111>
  8036b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036b5:	8b 40 04             	mov    0x4(%eax),%eax
  8036b8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8036bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036c0:	8b 40 04             	mov    0x4(%eax),%eax
  8036c3:	85 c0                	test   %eax,%eax
  8036c5:	74 0f                	je     8036d6 <insert_sorted_with_merge_freeList+0x12a>
  8036c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036ca:	8b 40 04             	mov    0x4(%eax),%eax
  8036cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036d0:	8b 12                	mov    (%edx),%edx
  8036d2:	89 10                	mov    %edx,(%eax)
  8036d4:	eb 0a                	jmp    8036e0 <insert_sorted_with_merge_freeList+0x134>
  8036d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036d9:	8b 00                	mov    (%eax),%eax
  8036db:	a3 38 51 80 00       	mov    %eax,0x805138
  8036e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036ec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036f3:	a1 44 51 80 00       	mov    0x805144,%eax
  8036f8:	48                   	dec    %eax
  8036f9:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  8036fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803701:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803708:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80370b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803712:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803716:	75 17                	jne    80372f <insert_sorted_with_merge_freeList+0x183>
  803718:	83 ec 04             	sub    $0x4,%esp
  80371b:	68 68 48 80 00       	push   $0x804868
  803720:	68 3f 01 00 00       	push   $0x13f
  803725:	68 8b 48 80 00       	push   $0x80488b
  80372a:	e8 a8 d1 ff ff       	call   8008d7 <_panic>
  80372f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803735:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803738:	89 10                	mov    %edx,(%eax)
  80373a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80373d:	8b 00                	mov    (%eax),%eax
  80373f:	85 c0                	test   %eax,%eax
  803741:	74 0d                	je     803750 <insert_sorted_with_merge_freeList+0x1a4>
  803743:	a1 48 51 80 00       	mov    0x805148,%eax
  803748:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80374b:	89 50 04             	mov    %edx,0x4(%eax)
  80374e:	eb 08                	jmp    803758 <insert_sorted_with_merge_freeList+0x1ac>
  803750:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803753:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803758:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80375b:	a3 48 51 80 00       	mov    %eax,0x805148
  803760:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803763:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80376a:	a1 54 51 80 00       	mov    0x805154,%eax
  80376f:	40                   	inc    %eax
  803770:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803775:	e9 7a 05 00 00       	jmp    803cf4 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  80377a:	8b 45 08             	mov    0x8(%ebp),%eax
  80377d:	8b 50 08             	mov    0x8(%eax),%edx
  803780:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803783:	8b 40 08             	mov    0x8(%eax),%eax
  803786:	39 c2                	cmp    %eax,%edx
  803788:	0f 82 14 01 00 00    	jb     8038a2 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  80378e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803791:	8b 50 08             	mov    0x8(%eax),%edx
  803794:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803797:	8b 40 0c             	mov    0xc(%eax),%eax
  80379a:	01 c2                	add    %eax,%edx
  80379c:	8b 45 08             	mov    0x8(%ebp),%eax
  80379f:	8b 40 08             	mov    0x8(%eax),%eax
  8037a2:	39 c2                	cmp    %eax,%edx
  8037a4:	0f 85 90 00 00 00    	jne    80383a <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8037aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037ad:	8b 50 0c             	mov    0xc(%eax),%edx
  8037b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8037b6:	01 c2                	add    %eax,%edx
  8037b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037bb:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  8037be:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8037c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8037cb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8037d2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037d6:	75 17                	jne    8037ef <insert_sorted_with_merge_freeList+0x243>
  8037d8:	83 ec 04             	sub    $0x4,%esp
  8037db:	68 68 48 80 00       	push   $0x804868
  8037e0:	68 49 01 00 00       	push   $0x149
  8037e5:	68 8b 48 80 00       	push   $0x80488b
  8037ea:	e8 e8 d0 ff ff       	call   8008d7 <_panic>
  8037ef:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8037f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f8:	89 10                	mov    %edx,(%eax)
  8037fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8037fd:	8b 00                	mov    (%eax),%eax
  8037ff:	85 c0                	test   %eax,%eax
  803801:	74 0d                	je     803810 <insert_sorted_with_merge_freeList+0x264>
  803803:	a1 48 51 80 00       	mov    0x805148,%eax
  803808:	8b 55 08             	mov    0x8(%ebp),%edx
  80380b:	89 50 04             	mov    %edx,0x4(%eax)
  80380e:	eb 08                	jmp    803818 <insert_sorted_with_merge_freeList+0x26c>
  803810:	8b 45 08             	mov    0x8(%ebp),%eax
  803813:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803818:	8b 45 08             	mov    0x8(%ebp),%eax
  80381b:	a3 48 51 80 00       	mov    %eax,0x805148
  803820:	8b 45 08             	mov    0x8(%ebp),%eax
  803823:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80382a:	a1 54 51 80 00       	mov    0x805154,%eax
  80382f:	40                   	inc    %eax
  803830:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803835:	e9 bb 04 00 00       	jmp    803cf5 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  80383a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80383e:	75 17                	jne    803857 <insert_sorted_with_merge_freeList+0x2ab>
  803840:	83 ec 04             	sub    $0x4,%esp
  803843:	68 dc 48 80 00       	push   $0x8048dc
  803848:	68 4c 01 00 00       	push   $0x14c
  80384d:	68 8b 48 80 00       	push   $0x80488b
  803852:	e8 80 d0 ff ff       	call   8008d7 <_panic>
  803857:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80385d:	8b 45 08             	mov    0x8(%ebp),%eax
  803860:	89 50 04             	mov    %edx,0x4(%eax)
  803863:	8b 45 08             	mov    0x8(%ebp),%eax
  803866:	8b 40 04             	mov    0x4(%eax),%eax
  803869:	85 c0                	test   %eax,%eax
  80386b:	74 0c                	je     803879 <insert_sorted_with_merge_freeList+0x2cd>
  80386d:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803872:	8b 55 08             	mov    0x8(%ebp),%edx
  803875:	89 10                	mov    %edx,(%eax)
  803877:	eb 08                	jmp    803881 <insert_sorted_with_merge_freeList+0x2d5>
  803879:	8b 45 08             	mov    0x8(%ebp),%eax
  80387c:	a3 38 51 80 00       	mov    %eax,0x805138
  803881:	8b 45 08             	mov    0x8(%ebp),%eax
  803884:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803889:	8b 45 08             	mov    0x8(%ebp),%eax
  80388c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803892:	a1 44 51 80 00       	mov    0x805144,%eax
  803897:	40                   	inc    %eax
  803898:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80389d:	e9 53 04 00 00       	jmp    803cf5 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8038a2:	a1 38 51 80 00       	mov    0x805138,%eax
  8038a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8038aa:	e9 15 04 00 00       	jmp    803cc4 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8038af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038b2:	8b 00                	mov    (%eax),%eax
  8038b4:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8038b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ba:	8b 50 08             	mov    0x8(%eax),%edx
  8038bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038c0:	8b 40 08             	mov    0x8(%eax),%eax
  8038c3:	39 c2                	cmp    %eax,%edx
  8038c5:	0f 86 f1 03 00 00    	jbe    803cbc <insert_sorted_with_merge_freeList+0x710>
  8038cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ce:	8b 50 08             	mov    0x8(%eax),%edx
  8038d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038d4:	8b 40 08             	mov    0x8(%eax),%eax
  8038d7:	39 c2                	cmp    %eax,%edx
  8038d9:	0f 83 dd 03 00 00    	jae    803cbc <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8038df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038e2:	8b 50 08             	mov    0x8(%eax),%edx
  8038e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8038eb:	01 c2                	add    %eax,%edx
  8038ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f0:	8b 40 08             	mov    0x8(%eax),%eax
  8038f3:	39 c2                	cmp    %eax,%edx
  8038f5:	0f 85 b9 01 00 00    	jne    803ab4 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8038fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8038fe:	8b 50 08             	mov    0x8(%eax),%edx
  803901:	8b 45 08             	mov    0x8(%ebp),%eax
  803904:	8b 40 0c             	mov    0xc(%eax),%eax
  803907:	01 c2                	add    %eax,%edx
  803909:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80390c:	8b 40 08             	mov    0x8(%eax),%eax
  80390f:	39 c2                	cmp    %eax,%edx
  803911:	0f 85 0d 01 00 00    	jne    803a24 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803917:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80391a:	8b 50 0c             	mov    0xc(%eax),%edx
  80391d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803920:	8b 40 0c             	mov    0xc(%eax),%eax
  803923:	01 c2                	add    %eax,%edx
  803925:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803928:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80392b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80392f:	75 17                	jne    803948 <insert_sorted_with_merge_freeList+0x39c>
  803931:	83 ec 04             	sub    $0x4,%esp
  803934:	68 34 49 80 00       	push   $0x804934
  803939:	68 5c 01 00 00       	push   $0x15c
  80393e:	68 8b 48 80 00       	push   $0x80488b
  803943:	e8 8f cf ff ff       	call   8008d7 <_panic>
  803948:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80394b:	8b 00                	mov    (%eax),%eax
  80394d:	85 c0                	test   %eax,%eax
  80394f:	74 10                	je     803961 <insert_sorted_with_merge_freeList+0x3b5>
  803951:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803954:	8b 00                	mov    (%eax),%eax
  803956:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803959:	8b 52 04             	mov    0x4(%edx),%edx
  80395c:	89 50 04             	mov    %edx,0x4(%eax)
  80395f:	eb 0b                	jmp    80396c <insert_sorted_with_merge_freeList+0x3c0>
  803961:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803964:	8b 40 04             	mov    0x4(%eax),%eax
  803967:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80396c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80396f:	8b 40 04             	mov    0x4(%eax),%eax
  803972:	85 c0                	test   %eax,%eax
  803974:	74 0f                	je     803985 <insert_sorted_with_merge_freeList+0x3d9>
  803976:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803979:	8b 40 04             	mov    0x4(%eax),%eax
  80397c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80397f:	8b 12                	mov    (%edx),%edx
  803981:	89 10                	mov    %edx,(%eax)
  803983:	eb 0a                	jmp    80398f <insert_sorted_with_merge_freeList+0x3e3>
  803985:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803988:	8b 00                	mov    (%eax),%eax
  80398a:	a3 38 51 80 00       	mov    %eax,0x805138
  80398f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803992:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803998:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80399b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039a2:	a1 44 51 80 00       	mov    0x805144,%eax
  8039a7:	48                   	dec    %eax
  8039a8:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8039ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039b0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8039b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039ba:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8039c1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8039c5:	75 17                	jne    8039de <insert_sorted_with_merge_freeList+0x432>
  8039c7:	83 ec 04             	sub    $0x4,%esp
  8039ca:	68 68 48 80 00       	push   $0x804868
  8039cf:	68 5f 01 00 00       	push   $0x15f
  8039d4:	68 8b 48 80 00       	push   $0x80488b
  8039d9:	e8 f9 ce ff ff       	call   8008d7 <_panic>
  8039de:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8039e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039e7:	89 10                	mov    %edx,(%eax)
  8039e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039ec:	8b 00                	mov    (%eax),%eax
  8039ee:	85 c0                	test   %eax,%eax
  8039f0:	74 0d                	je     8039ff <insert_sorted_with_merge_freeList+0x453>
  8039f2:	a1 48 51 80 00       	mov    0x805148,%eax
  8039f7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039fa:	89 50 04             	mov    %edx,0x4(%eax)
  8039fd:	eb 08                	jmp    803a07 <insert_sorted_with_merge_freeList+0x45b>
  8039ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a02:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803a07:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a0a:	a3 48 51 80 00       	mov    %eax,0x805148
  803a0f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a12:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a19:	a1 54 51 80 00       	mov    0x805154,%eax
  803a1e:	40                   	inc    %eax
  803a1f:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a27:	8b 50 0c             	mov    0xc(%eax),%edx
  803a2a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a2d:	8b 40 0c             	mov    0xc(%eax),%eax
  803a30:	01 c2                	add    %eax,%edx
  803a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a35:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803a38:	8b 45 08             	mov    0x8(%ebp),%eax
  803a3b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803a42:	8b 45 08             	mov    0x8(%ebp),%eax
  803a45:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803a4c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a50:	75 17                	jne    803a69 <insert_sorted_with_merge_freeList+0x4bd>
  803a52:	83 ec 04             	sub    $0x4,%esp
  803a55:	68 68 48 80 00       	push   $0x804868
  803a5a:	68 64 01 00 00       	push   $0x164
  803a5f:	68 8b 48 80 00       	push   $0x80488b
  803a64:	e8 6e ce ff ff       	call   8008d7 <_panic>
  803a69:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  803a72:	89 10                	mov    %edx,(%eax)
  803a74:	8b 45 08             	mov    0x8(%ebp),%eax
  803a77:	8b 00                	mov    (%eax),%eax
  803a79:	85 c0                	test   %eax,%eax
  803a7b:	74 0d                	je     803a8a <insert_sorted_with_merge_freeList+0x4de>
  803a7d:	a1 48 51 80 00       	mov    0x805148,%eax
  803a82:	8b 55 08             	mov    0x8(%ebp),%edx
  803a85:	89 50 04             	mov    %edx,0x4(%eax)
  803a88:	eb 08                	jmp    803a92 <insert_sorted_with_merge_freeList+0x4e6>
  803a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a8d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803a92:	8b 45 08             	mov    0x8(%ebp),%eax
  803a95:	a3 48 51 80 00       	mov    %eax,0x805148
  803a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a9d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803aa4:	a1 54 51 80 00       	mov    0x805154,%eax
  803aa9:	40                   	inc    %eax
  803aaa:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803aaf:	e9 41 02 00 00       	jmp    803cf5 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  803ab7:	8b 50 08             	mov    0x8(%eax),%edx
  803aba:	8b 45 08             	mov    0x8(%ebp),%eax
  803abd:	8b 40 0c             	mov    0xc(%eax),%eax
  803ac0:	01 c2                	add    %eax,%edx
  803ac2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ac5:	8b 40 08             	mov    0x8(%eax),%eax
  803ac8:	39 c2                	cmp    %eax,%edx
  803aca:	0f 85 7c 01 00 00    	jne    803c4c <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803ad0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803ad4:	74 06                	je     803adc <insert_sorted_with_merge_freeList+0x530>
  803ad6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803ada:	75 17                	jne    803af3 <insert_sorted_with_merge_freeList+0x547>
  803adc:	83 ec 04             	sub    $0x4,%esp
  803adf:	68 a4 48 80 00       	push   $0x8048a4
  803ae4:	68 69 01 00 00       	push   $0x169
  803ae9:	68 8b 48 80 00       	push   $0x80488b
  803aee:	e8 e4 cd ff ff       	call   8008d7 <_panic>
  803af3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803af6:	8b 50 04             	mov    0x4(%eax),%edx
  803af9:	8b 45 08             	mov    0x8(%ebp),%eax
  803afc:	89 50 04             	mov    %edx,0x4(%eax)
  803aff:	8b 45 08             	mov    0x8(%ebp),%eax
  803b02:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b05:	89 10                	mov    %edx,(%eax)
  803b07:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b0a:	8b 40 04             	mov    0x4(%eax),%eax
  803b0d:	85 c0                	test   %eax,%eax
  803b0f:	74 0d                	je     803b1e <insert_sorted_with_merge_freeList+0x572>
  803b11:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b14:	8b 40 04             	mov    0x4(%eax),%eax
  803b17:	8b 55 08             	mov    0x8(%ebp),%edx
  803b1a:	89 10                	mov    %edx,(%eax)
  803b1c:	eb 08                	jmp    803b26 <insert_sorted_with_merge_freeList+0x57a>
  803b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  803b21:	a3 38 51 80 00       	mov    %eax,0x805138
  803b26:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b29:	8b 55 08             	mov    0x8(%ebp),%edx
  803b2c:	89 50 04             	mov    %edx,0x4(%eax)
  803b2f:	a1 44 51 80 00       	mov    0x805144,%eax
  803b34:	40                   	inc    %eax
  803b35:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  803b3d:	8b 50 0c             	mov    0xc(%eax),%edx
  803b40:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b43:	8b 40 0c             	mov    0xc(%eax),%eax
  803b46:	01 c2                	add    %eax,%edx
  803b48:	8b 45 08             	mov    0x8(%ebp),%eax
  803b4b:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803b4e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803b52:	75 17                	jne    803b6b <insert_sorted_with_merge_freeList+0x5bf>
  803b54:	83 ec 04             	sub    $0x4,%esp
  803b57:	68 34 49 80 00       	push   $0x804934
  803b5c:	68 6b 01 00 00       	push   $0x16b
  803b61:	68 8b 48 80 00       	push   $0x80488b
  803b66:	e8 6c cd ff ff       	call   8008d7 <_panic>
  803b6b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b6e:	8b 00                	mov    (%eax),%eax
  803b70:	85 c0                	test   %eax,%eax
  803b72:	74 10                	je     803b84 <insert_sorted_with_merge_freeList+0x5d8>
  803b74:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b77:	8b 00                	mov    (%eax),%eax
  803b79:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b7c:	8b 52 04             	mov    0x4(%edx),%edx
  803b7f:	89 50 04             	mov    %edx,0x4(%eax)
  803b82:	eb 0b                	jmp    803b8f <insert_sorted_with_merge_freeList+0x5e3>
  803b84:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b87:	8b 40 04             	mov    0x4(%eax),%eax
  803b8a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803b8f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b92:	8b 40 04             	mov    0x4(%eax),%eax
  803b95:	85 c0                	test   %eax,%eax
  803b97:	74 0f                	je     803ba8 <insert_sorted_with_merge_freeList+0x5fc>
  803b99:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b9c:	8b 40 04             	mov    0x4(%eax),%eax
  803b9f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803ba2:	8b 12                	mov    (%edx),%edx
  803ba4:	89 10                	mov    %edx,(%eax)
  803ba6:	eb 0a                	jmp    803bb2 <insert_sorted_with_merge_freeList+0x606>
  803ba8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bab:	8b 00                	mov    (%eax),%eax
  803bad:	a3 38 51 80 00       	mov    %eax,0x805138
  803bb2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bb5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803bbb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bbe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bc5:	a1 44 51 80 00       	mov    0x805144,%eax
  803bca:	48                   	dec    %eax
  803bcb:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803bd0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bd3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803bda:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bdd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803be4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803be8:	75 17                	jne    803c01 <insert_sorted_with_merge_freeList+0x655>
  803bea:	83 ec 04             	sub    $0x4,%esp
  803bed:	68 68 48 80 00       	push   $0x804868
  803bf2:	68 6e 01 00 00       	push   $0x16e
  803bf7:	68 8b 48 80 00       	push   $0x80488b
  803bfc:	e8 d6 cc ff ff       	call   8008d7 <_panic>
  803c01:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803c07:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c0a:	89 10                	mov    %edx,(%eax)
  803c0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c0f:	8b 00                	mov    (%eax),%eax
  803c11:	85 c0                	test   %eax,%eax
  803c13:	74 0d                	je     803c22 <insert_sorted_with_merge_freeList+0x676>
  803c15:	a1 48 51 80 00       	mov    0x805148,%eax
  803c1a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c1d:	89 50 04             	mov    %edx,0x4(%eax)
  803c20:	eb 08                	jmp    803c2a <insert_sorted_with_merge_freeList+0x67e>
  803c22:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c25:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803c2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c2d:	a3 48 51 80 00       	mov    %eax,0x805148
  803c32:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c35:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c3c:	a1 54 51 80 00       	mov    0x805154,%eax
  803c41:	40                   	inc    %eax
  803c42:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803c47:	e9 a9 00 00 00       	jmp    803cf5 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803c4c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c50:	74 06                	je     803c58 <insert_sorted_with_merge_freeList+0x6ac>
  803c52:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c56:	75 17                	jne    803c6f <insert_sorted_with_merge_freeList+0x6c3>
  803c58:	83 ec 04             	sub    $0x4,%esp
  803c5b:	68 00 49 80 00       	push   $0x804900
  803c60:	68 73 01 00 00       	push   $0x173
  803c65:	68 8b 48 80 00       	push   $0x80488b
  803c6a:	e8 68 cc ff ff       	call   8008d7 <_panic>
  803c6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c72:	8b 10                	mov    (%eax),%edx
  803c74:	8b 45 08             	mov    0x8(%ebp),%eax
  803c77:	89 10                	mov    %edx,(%eax)
  803c79:	8b 45 08             	mov    0x8(%ebp),%eax
  803c7c:	8b 00                	mov    (%eax),%eax
  803c7e:	85 c0                	test   %eax,%eax
  803c80:	74 0b                	je     803c8d <insert_sorted_with_merge_freeList+0x6e1>
  803c82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c85:	8b 00                	mov    (%eax),%eax
  803c87:	8b 55 08             	mov    0x8(%ebp),%edx
  803c8a:	89 50 04             	mov    %edx,0x4(%eax)
  803c8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c90:	8b 55 08             	mov    0x8(%ebp),%edx
  803c93:	89 10                	mov    %edx,(%eax)
  803c95:	8b 45 08             	mov    0x8(%ebp),%eax
  803c98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803c9b:	89 50 04             	mov    %edx,0x4(%eax)
  803c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  803ca1:	8b 00                	mov    (%eax),%eax
  803ca3:	85 c0                	test   %eax,%eax
  803ca5:	75 08                	jne    803caf <insert_sorted_with_merge_freeList+0x703>
  803ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  803caa:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803caf:	a1 44 51 80 00       	mov    0x805144,%eax
  803cb4:	40                   	inc    %eax
  803cb5:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803cba:	eb 39                	jmp    803cf5 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803cbc:	a1 40 51 80 00       	mov    0x805140,%eax
  803cc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803cc4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803cc8:	74 07                	je     803cd1 <insert_sorted_with_merge_freeList+0x725>
  803cca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ccd:	8b 00                	mov    (%eax),%eax
  803ccf:	eb 05                	jmp    803cd6 <insert_sorted_with_merge_freeList+0x72a>
  803cd1:	b8 00 00 00 00       	mov    $0x0,%eax
  803cd6:	a3 40 51 80 00       	mov    %eax,0x805140
  803cdb:	a1 40 51 80 00       	mov    0x805140,%eax
  803ce0:	85 c0                	test   %eax,%eax
  803ce2:	0f 85 c7 fb ff ff    	jne    8038af <insert_sorted_with_merge_freeList+0x303>
  803ce8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803cec:	0f 85 bd fb ff ff    	jne    8038af <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803cf2:	eb 01                	jmp    803cf5 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803cf4:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803cf5:	90                   	nop
  803cf6:	c9                   	leave  
  803cf7:	c3                   	ret    

00803cf8 <__udivdi3>:
  803cf8:	55                   	push   %ebp
  803cf9:	57                   	push   %edi
  803cfa:	56                   	push   %esi
  803cfb:	53                   	push   %ebx
  803cfc:	83 ec 1c             	sub    $0x1c,%esp
  803cff:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803d03:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803d07:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803d0b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803d0f:	89 ca                	mov    %ecx,%edx
  803d11:	89 f8                	mov    %edi,%eax
  803d13:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803d17:	85 f6                	test   %esi,%esi
  803d19:	75 2d                	jne    803d48 <__udivdi3+0x50>
  803d1b:	39 cf                	cmp    %ecx,%edi
  803d1d:	77 65                	ja     803d84 <__udivdi3+0x8c>
  803d1f:	89 fd                	mov    %edi,%ebp
  803d21:	85 ff                	test   %edi,%edi
  803d23:	75 0b                	jne    803d30 <__udivdi3+0x38>
  803d25:	b8 01 00 00 00       	mov    $0x1,%eax
  803d2a:	31 d2                	xor    %edx,%edx
  803d2c:	f7 f7                	div    %edi
  803d2e:	89 c5                	mov    %eax,%ebp
  803d30:	31 d2                	xor    %edx,%edx
  803d32:	89 c8                	mov    %ecx,%eax
  803d34:	f7 f5                	div    %ebp
  803d36:	89 c1                	mov    %eax,%ecx
  803d38:	89 d8                	mov    %ebx,%eax
  803d3a:	f7 f5                	div    %ebp
  803d3c:	89 cf                	mov    %ecx,%edi
  803d3e:	89 fa                	mov    %edi,%edx
  803d40:	83 c4 1c             	add    $0x1c,%esp
  803d43:	5b                   	pop    %ebx
  803d44:	5e                   	pop    %esi
  803d45:	5f                   	pop    %edi
  803d46:	5d                   	pop    %ebp
  803d47:	c3                   	ret    
  803d48:	39 ce                	cmp    %ecx,%esi
  803d4a:	77 28                	ja     803d74 <__udivdi3+0x7c>
  803d4c:	0f bd fe             	bsr    %esi,%edi
  803d4f:	83 f7 1f             	xor    $0x1f,%edi
  803d52:	75 40                	jne    803d94 <__udivdi3+0x9c>
  803d54:	39 ce                	cmp    %ecx,%esi
  803d56:	72 0a                	jb     803d62 <__udivdi3+0x6a>
  803d58:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803d5c:	0f 87 9e 00 00 00    	ja     803e00 <__udivdi3+0x108>
  803d62:	b8 01 00 00 00       	mov    $0x1,%eax
  803d67:	89 fa                	mov    %edi,%edx
  803d69:	83 c4 1c             	add    $0x1c,%esp
  803d6c:	5b                   	pop    %ebx
  803d6d:	5e                   	pop    %esi
  803d6e:	5f                   	pop    %edi
  803d6f:	5d                   	pop    %ebp
  803d70:	c3                   	ret    
  803d71:	8d 76 00             	lea    0x0(%esi),%esi
  803d74:	31 ff                	xor    %edi,%edi
  803d76:	31 c0                	xor    %eax,%eax
  803d78:	89 fa                	mov    %edi,%edx
  803d7a:	83 c4 1c             	add    $0x1c,%esp
  803d7d:	5b                   	pop    %ebx
  803d7e:	5e                   	pop    %esi
  803d7f:	5f                   	pop    %edi
  803d80:	5d                   	pop    %ebp
  803d81:	c3                   	ret    
  803d82:	66 90                	xchg   %ax,%ax
  803d84:	89 d8                	mov    %ebx,%eax
  803d86:	f7 f7                	div    %edi
  803d88:	31 ff                	xor    %edi,%edi
  803d8a:	89 fa                	mov    %edi,%edx
  803d8c:	83 c4 1c             	add    $0x1c,%esp
  803d8f:	5b                   	pop    %ebx
  803d90:	5e                   	pop    %esi
  803d91:	5f                   	pop    %edi
  803d92:	5d                   	pop    %ebp
  803d93:	c3                   	ret    
  803d94:	bd 20 00 00 00       	mov    $0x20,%ebp
  803d99:	89 eb                	mov    %ebp,%ebx
  803d9b:	29 fb                	sub    %edi,%ebx
  803d9d:	89 f9                	mov    %edi,%ecx
  803d9f:	d3 e6                	shl    %cl,%esi
  803da1:	89 c5                	mov    %eax,%ebp
  803da3:	88 d9                	mov    %bl,%cl
  803da5:	d3 ed                	shr    %cl,%ebp
  803da7:	89 e9                	mov    %ebp,%ecx
  803da9:	09 f1                	or     %esi,%ecx
  803dab:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803daf:	89 f9                	mov    %edi,%ecx
  803db1:	d3 e0                	shl    %cl,%eax
  803db3:	89 c5                	mov    %eax,%ebp
  803db5:	89 d6                	mov    %edx,%esi
  803db7:	88 d9                	mov    %bl,%cl
  803db9:	d3 ee                	shr    %cl,%esi
  803dbb:	89 f9                	mov    %edi,%ecx
  803dbd:	d3 e2                	shl    %cl,%edx
  803dbf:	8b 44 24 08          	mov    0x8(%esp),%eax
  803dc3:	88 d9                	mov    %bl,%cl
  803dc5:	d3 e8                	shr    %cl,%eax
  803dc7:	09 c2                	or     %eax,%edx
  803dc9:	89 d0                	mov    %edx,%eax
  803dcb:	89 f2                	mov    %esi,%edx
  803dcd:	f7 74 24 0c          	divl   0xc(%esp)
  803dd1:	89 d6                	mov    %edx,%esi
  803dd3:	89 c3                	mov    %eax,%ebx
  803dd5:	f7 e5                	mul    %ebp
  803dd7:	39 d6                	cmp    %edx,%esi
  803dd9:	72 19                	jb     803df4 <__udivdi3+0xfc>
  803ddb:	74 0b                	je     803de8 <__udivdi3+0xf0>
  803ddd:	89 d8                	mov    %ebx,%eax
  803ddf:	31 ff                	xor    %edi,%edi
  803de1:	e9 58 ff ff ff       	jmp    803d3e <__udivdi3+0x46>
  803de6:	66 90                	xchg   %ax,%ax
  803de8:	8b 54 24 08          	mov    0x8(%esp),%edx
  803dec:	89 f9                	mov    %edi,%ecx
  803dee:	d3 e2                	shl    %cl,%edx
  803df0:	39 c2                	cmp    %eax,%edx
  803df2:	73 e9                	jae    803ddd <__udivdi3+0xe5>
  803df4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803df7:	31 ff                	xor    %edi,%edi
  803df9:	e9 40 ff ff ff       	jmp    803d3e <__udivdi3+0x46>
  803dfe:	66 90                	xchg   %ax,%ax
  803e00:	31 c0                	xor    %eax,%eax
  803e02:	e9 37 ff ff ff       	jmp    803d3e <__udivdi3+0x46>
  803e07:	90                   	nop

00803e08 <__umoddi3>:
  803e08:	55                   	push   %ebp
  803e09:	57                   	push   %edi
  803e0a:	56                   	push   %esi
  803e0b:	53                   	push   %ebx
  803e0c:	83 ec 1c             	sub    $0x1c,%esp
  803e0f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803e13:	8b 74 24 34          	mov    0x34(%esp),%esi
  803e17:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803e1b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803e1f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803e23:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803e27:	89 f3                	mov    %esi,%ebx
  803e29:	89 fa                	mov    %edi,%edx
  803e2b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803e2f:	89 34 24             	mov    %esi,(%esp)
  803e32:	85 c0                	test   %eax,%eax
  803e34:	75 1a                	jne    803e50 <__umoddi3+0x48>
  803e36:	39 f7                	cmp    %esi,%edi
  803e38:	0f 86 a2 00 00 00    	jbe    803ee0 <__umoddi3+0xd8>
  803e3e:	89 c8                	mov    %ecx,%eax
  803e40:	89 f2                	mov    %esi,%edx
  803e42:	f7 f7                	div    %edi
  803e44:	89 d0                	mov    %edx,%eax
  803e46:	31 d2                	xor    %edx,%edx
  803e48:	83 c4 1c             	add    $0x1c,%esp
  803e4b:	5b                   	pop    %ebx
  803e4c:	5e                   	pop    %esi
  803e4d:	5f                   	pop    %edi
  803e4e:	5d                   	pop    %ebp
  803e4f:	c3                   	ret    
  803e50:	39 f0                	cmp    %esi,%eax
  803e52:	0f 87 ac 00 00 00    	ja     803f04 <__umoddi3+0xfc>
  803e58:	0f bd e8             	bsr    %eax,%ebp
  803e5b:	83 f5 1f             	xor    $0x1f,%ebp
  803e5e:	0f 84 ac 00 00 00    	je     803f10 <__umoddi3+0x108>
  803e64:	bf 20 00 00 00       	mov    $0x20,%edi
  803e69:	29 ef                	sub    %ebp,%edi
  803e6b:	89 fe                	mov    %edi,%esi
  803e6d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803e71:	89 e9                	mov    %ebp,%ecx
  803e73:	d3 e0                	shl    %cl,%eax
  803e75:	89 d7                	mov    %edx,%edi
  803e77:	89 f1                	mov    %esi,%ecx
  803e79:	d3 ef                	shr    %cl,%edi
  803e7b:	09 c7                	or     %eax,%edi
  803e7d:	89 e9                	mov    %ebp,%ecx
  803e7f:	d3 e2                	shl    %cl,%edx
  803e81:	89 14 24             	mov    %edx,(%esp)
  803e84:	89 d8                	mov    %ebx,%eax
  803e86:	d3 e0                	shl    %cl,%eax
  803e88:	89 c2                	mov    %eax,%edx
  803e8a:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e8e:	d3 e0                	shl    %cl,%eax
  803e90:	89 44 24 04          	mov    %eax,0x4(%esp)
  803e94:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e98:	89 f1                	mov    %esi,%ecx
  803e9a:	d3 e8                	shr    %cl,%eax
  803e9c:	09 d0                	or     %edx,%eax
  803e9e:	d3 eb                	shr    %cl,%ebx
  803ea0:	89 da                	mov    %ebx,%edx
  803ea2:	f7 f7                	div    %edi
  803ea4:	89 d3                	mov    %edx,%ebx
  803ea6:	f7 24 24             	mull   (%esp)
  803ea9:	89 c6                	mov    %eax,%esi
  803eab:	89 d1                	mov    %edx,%ecx
  803ead:	39 d3                	cmp    %edx,%ebx
  803eaf:	0f 82 87 00 00 00    	jb     803f3c <__umoddi3+0x134>
  803eb5:	0f 84 91 00 00 00    	je     803f4c <__umoddi3+0x144>
  803ebb:	8b 54 24 04          	mov    0x4(%esp),%edx
  803ebf:	29 f2                	sub    %esi,%edx
  803ec1:	19 cb                	sbb    %ecx,%ebx
  803ec3:	89 d8                	mov    %ebx,%eax
  803ec5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803ec9:	d3 e0                	shl    %cl,%eax
  803ecb:	89 e9                	mov    %ebp,%ecx
  803ecd:	d3 ea                	shr    %cl,%edx
  803ecf:	09 d0                	or     %edx,%eax
  803ed1:	89 e9                	mov    %ebp,%ecx
  803ed3:	d3 eb                	shr    %cl,%ebx
  803ed5:	89 da                	mov    %ebx,%edx
  803ed7:	83 c4 1c             	add    $0x1c,%esp
  803eda:	5b                   	pop    %ebx
  803edb:	5e                   	pop    %esi
  803edc:	5f                   	pop    %edi
  803edd:	5d                   	pop    %ebp
  803ede:	c3                   	ret    
  803edf:	90                   	nop
  803ee0:	89 fd                	mov    %edi,%ebp
  803ee2:	85 ff                	test   %edi,%edi
  803ee4:	75 0b                	jne    803ef1 <__umoddi3+0xe9>
  803ee6:	b8 01 00 00 00       	mov    $0x1,%eax
  803eeb:	31 d2                	xor    %edx,%edx
  803eed:	f7 f7                	div    %edi
  803eef:	89 c5                	mov    %eax,%ebp
  803ef1:	89 f0                	mov    %esi,%eax
  803ef3:	31 d2                	xor    %edx,%edx
  803ef5:	f7 f5                	div    %ebp
  803ef7:	89 c8                	mov    %ecx,%eax
  803ef9:	f7 f5                	div    %ebp
  803efb:	89 d0                	mov    %edx,%eax
  803efd:	e9 44 ff ff ff       	jmp    803e46 <__umoddi3+0x3e>
  803f02:	66 90                	xchg   %ax,%ax
  803f04:	89 c8                	mov    %ecx,%eax
  803f06:	89 f2                	mov    %esi,%edx
  803f08:	83 c4 1c             	add    $0x1c,%esp
  803f0b:	5b                   	pop    %ebx
  803f0c:	5e                   	pop    %esi
  803f0d:	5f                   	pop    %edi
  803f0e:	5d                   	pop    %ebp
  803f0f:	c3                   	ret    
  803f10:	3b 04 24             	cmp    (%esp),%eax
  803f13:	72 06                	jb     803f1b <__umoddi3+0x113>
  803f15:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803f19:	77 0f                	ja     803f2a <__umoddi3+0x122>
  803f1b:	89 f2                	mov    %esi,%edx
  803f1d:	29 f9                	sub    %edi,%ecx
  803f1f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803f23:	89 14 24             	mov    %edx,(%esp)
  803f26:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803f2a:	8b 44 24 04          	mov    0x4(%esp),%eax
  803f2e:	8b 14 24             	mov    (%esp),%edx
  803f31:	83 c4 1c             	add    $0x1c,%esp
  803f34:	5b                   	pop    %ebx
  803f35:	5e                   	pop    %esi
  803f36:	5f                   	pop    %edi
  803f37:	5d                   	pop    %ebp
  803f38:	c3                   	ret    
  803f39:	8d 76 00             	lea    0x0(%esi),%esi
  803f3c:	2b 04 24             	sub    (%esp),%eax
  803f3f:	19 fa                	sbb    %edi,%edx
  803f41:	89 d1                	mov    %edx,%ecx
  803f43:	89 c6                	mov    %eax,%esi
  803f45:	e9 71 ff ff ff       	jmp    803ebb <__umoddi3+0xb3>
  803f4a:	66 90                	xchg   %ax,%ax
  803f4c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803f50:	72 ea                	jb     803f3c <__umoddi3+0x134>
  803f52:	89 d9                	mov    %ebx,%ecx
  803f54:	e9 62 ff ff ff       	jmp    803ebb <__umoddi3+0xb3>
