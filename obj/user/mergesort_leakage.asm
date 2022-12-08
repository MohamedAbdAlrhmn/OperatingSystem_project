
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
  800041:	e8 e0 1f 00 00       	call   802026 <sys_disable_interrupt>

		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 60 3d 80 00       	push   $0x803d60
  80004e:	e8 38 0b 00 00       	call   800b8b <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 62 3d 80 00       	push   $0x803d62
  80005e:	e8 28 0b 00 00       	call   800b8b <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 78 3d 80 00       	push   $0x803d78
  80006e:	e8 18 0b 00 00       	call   800b8b <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 62 3d 80 00       	push   $0x803d62
  80007e:	e8 08 0b 00 00       	call   800b8b <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 60 3d 80 00       	push   $0x803d60
  80008e:	e8 f8 0a 00 00       	call   800b8b <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 90 3d 80 00       	push   $0x803d90
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
  8000de:	68 b0 3d 80 00       	push   $0x803db0
  8000e3:	e8 a3 0a 00 00       	call   800b8b <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 d2 3d 80 00       	push   $0x803dd2
  8000f3:	e8 93 0a 00 00       	call   800b8b <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 e0 3d 80 00       	push   $0x803de0
  800103:	e8 83 0a 00 00       	call   800b8b <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 ef 3d 80 00       	push   $0x803def
  800113:	e8 73 0a 00 00       	call   800b8b <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 ff 3d 80 00       	push   $0x803dff
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
  800162:	e8 d9 1e 00 00       	call   802040 <sys_enable_interrupt>

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
  8001d7:	e8 4a 1e 00 00       	call   802026 <sys_disable_interrupt>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	68 08 3e 80 00       	push   $0x803e08
  8001e4:	e8 a2 09 00 00       	call   800b8b <cprintf>
  8001e9:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001ec:	e8 4f 1e 00 00       	call   802040 <sys_enable_interrupt>

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
  80020e:	68 3c 3e 80 00       	push   $0x803e3c
  800213:	6a 4a                	push   $0x4a
  800215:	68 5e 3e 80 00       	push   $0x803e5e
  80021a:	e8 b8 06 00 00       	call   8008d7 <_panic>
		else
		{
			sys_disable_interrupt();
  80021f:	e8 02 1e 00 00       	call   802026 <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	68 78 3e 80 00       	push   $0x803e78
  80022c:	e8 5a 09 00 00       	call   800b8b <cprintf>
  800231:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	68 ac 3e 80 00       	push   $0x803eac
  80023c:	e8 4a 09 00 00       	call   800b8b <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 e0 3e 80 00       	push   $0x803ee0
  80024c:	e8 3a 09 00 00       	call   800b8b <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800254:	e8 e7 1d 00 00       	call   802040 <sys_enable_interrupt>
		}

		//free(Elements) ;

		sys_disable_interrupt();
  800259:	e8 c8 1d 00 00       	call   802026 <sys_disable_interrupt>
			Chose = 0 ;
  80025e:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800262:	eb 42                	jmp    8002a6 <_main+0x26e>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800264:	83 ec 0c             	sub    $0xc,%esp
  800267:	68 12 3f 80 00       	push   $0x803f12
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
  8002b2:	e8 89 1d 00 00       	call   802040 <sys_enable_interrupt>

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
  800446:	68 60 3d 80 00       	push   $0x803d60
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
  800468:	68 30 3f 80 00       	push   $0x803f30
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
  800496:	68 35 3f 80 00       	push   $0x803f35
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
  80070f:	e8 46 19 00 00       	call   80205a <sys_cputc>
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
  800720:	e8 01 19 00 00       	call   802026 <sys_disable_interrupt>
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
  800733:	e8 22 19 00 00       	call   80205a <sys_cputc>
  800738:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80073b:	e8 00 19 00 00       	call   802040 <sys_enable_interrupt>
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
  800752:	e8 4a 17 00 00       	call   801ea1 <sys_cgetc>
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
  80076b:	e8 b6 18 00 00       	call   802026 <sys_disable_interrupt>
	int c=0;
  800770:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800777:	eb 08                	jmp    800781 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800779:	e8 23 17 00 00       	call   801ea1 <sys_cgetc>
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
  800787:	e8 b4 18 00 00       	call   802040 <sys_enable_interrupt>
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
  8007a1:	e8 73 1a 00 00       	call   802219 <sys_getenvindex>
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
  80080c:	e8 15 18 00 00       	call   802026 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800811:	83 ec 0c             	sub    $0xc,%esp
  800814:	68 54 3f 80 00       	push   $0x803f54
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
  80083c:	68 7c 3f 80 00       	push   $0x803f7c
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
  80086d:	68 a4 3f 80 00       	push   $0x803fa4
  800872:	e8 14 03 00 00       	call   800b8b <cprintf>
  800877:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80087a:	a1 24 50 80 00       	mov    0x805024,%eax
  80087f:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800885:	83 ec 08             	sub    $0x8,%esp
  800888:	50                   	push   %eax
  800889:	68 fc 3f 80 00       	push   $0x803ffc
  80088e:	e8 f8 02 00 00       	call   800b8b <cprintf>
  800893:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800896:	83 ec 0c             	sub    $0xc,%esp
  800899:	68 54 3f 80 00       	push   $0x803f54
  80089e:	e8 e8 02 00 00       	call   800b8b <cprintf>
  8008a3:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8008a6:	e8 95 17 00 00       	call   802040 <sys_enable_interrupt>

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
  8008be:	e8 22 19 00 00       	call   8021e5 <sys_destroy_env>
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
  8008cf:	e8 77 19 00 00       	call   80224b <sys_exit_env>
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
  8008f8:	68 10 40 80 00       	push   $0x804010
  8008fd:	e8 89 02 00 00       	call   800b8b <cprintf>
  800902:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800905:	a1 00 50 80 00       	mov    0x805000,%eax
  80090a:	ff 75 0c             	pushl  0xc(%ebp)
  80090d:	ff 75 08             	pushl  0x8(%ebp)
  800910:	50                   	push   %eax
  800911:	68 15 40 80 00       	push   $0x804015
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
  800935:	68 31 40 80 00       	push   $0x804031
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
  800961:	68 34 40 80 00       	push   $0x804034
  800966:	6a 26                	push   $0x26
  800968:	68 80 40 80 00       	push   $0x804080
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
  800a33:	68 8c 40 80 00       	push   $0x80408c
  800a38:	6a 3a                	push   $0x3a
  800a3a:	68 80 40 80 00       	push   $0x804080
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
  800aa3:	68 e0 40 80 00       	push   $0x8040e0
  800aa8:	6a 44                	push   $0x44
  800aaa:	68 80 40 80 00       	push   $0x804080
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
  800afd:	e8 76 13 00 00       	call   801e78 <sys_cputs>
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
  800b74:	e8 ff 12 00 00       	call   801e78 <sys_cputs>
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
  800bbe:	e8 63 14 00 00       	call   802026 <sys_disable_interrupt>
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
  800bde:	e8 5d 14 00 00       	call   802040 <sys_enable_interrupt>
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
  800c28:	e8 cf 2e 00 00       	call   803afc <__udivdi3>
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
  800c78:	e8 8f 2f 00 00       	call   803c0c <__umoddi3>
  800c7d:	83 c4 10             	add    $0x10,%esp
  800c80:	05 54 43 80 00       	add    $0x804354,%eax
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
  800dd3:	8b 04 85 78 43 80 00 	mov    0x804378(,%eax,4),%eax
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
  800eb4:	8b 34 9d c0 41 80 00 	mov    0x8041c0(,%ebx,4),%esi
  800ebb:	85 f6                	test   %esi,%esi
  800ebd:	75 19                	jne    800ed8 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ebf:	53                   	push   %ebx
  800ec0:	68 65 43 80 00       	push   $0x804365
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
  800ed9:	68 6e 43 80 00       	push   $0x80436e
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
  800f06:	be 71 43 80 00       	mov    $0x804371,%esi
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
  80121f:	68 d0 44 80 00       	push   $0x8044d0
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
  801261:	68 d3 44 80 00       	push   $0x8044d3
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
  801311:	e8 10 0d 00 00       	call   802026 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  801316:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80131a:	74 13                	je     80132f <atomic_readline+0x24>
		cprintf("%s", prompt);
  80131c:	83 ec 08             	sub    $0x8,%esp
  80131f:	ff 75 08             	pushl  0x8(%ebp)
  801322:	68 d0 44 80 00       	push   $0x8044d0
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
  801360:	68 d3 44 80 00       	push   $0x8044d3
  801365:	e8 21 f8 ff ff       	call   800b8b <cprintf>
  80136a:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  80136d:	e8 ce 0c 00 00       	call   802040 <sys_enable_interrupt>
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
  801405:	e8 36 0c 00 00       	call   802040 <sys_enable_interrupt>
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
  801b32:	68 e4 44 80 00       	push   $0x8044e4
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
  801c02:	e8 b5 03 00 00       	call   801fbc <sys_allocate_chunk>
  801c07:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801c0a:	a1 20 51 80 00       	mov    0x805120,%eax
  801c0f:	83 ec 0c             	sub    $0xc,%esp
  801c12:	50                   	push   %eax
  801c13:	e8 2a 0a 00 00       	call   802642 <initialize_MemBlocksList>
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
  801c40:	68 09 45 80 00       	push   $0x804509
  801c45:	6a 33                	push   $0x33
  801c47:	68 27 45 80 00       	push   $0x804527
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
  801cbf:	68 34 45 80 00       	push   $0x804534
  801cc4:	6a 34                	push   $0x34
  801cc6:	68 27 45 80 00       	push   $0x804527
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
  801d1c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d1f:	e8 f7 fd ff ff       	call   801b1b <InitializeUHeap>
	if (size == 0) return NULL ;
  801d24:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d28:	75 07                	jne    801d31 <malloc+0x18>
  801d2a:	b8 00 00 00 00       	mov    $0x0,%eax
  801d2f:	eb 14                	jmp    801d45 <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801d31:	83 ec 04             	sub    $0x4,%esp
  801d34:	68 58 45 80 00       	push   $0x804558
  801d39:	6a 46                	push   $0x46
  801d3b:	68 27 45 80 00       	push   $0x804527
  801d40:	e8 92 eb ff ff       	call   8008d7 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801d45:	c9                   	leave  
  801d46:	c3                   	ret    

00801d47 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801d47:	55                   	push   %ebp
  801d48:	89 e5                	mov    %esp,%ebp
  801d4a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801d4d:	83 ec 04             	sub    $0x4,%esp
  801d50:	68 80 45 80 00       	push   $0x804580
  801d55:	6a 61                	push   $0x61
  801d57:	68 27 45 80 00       	push   $0x804527
  801d5c:	e8 76 eb ff ff       	call   8008d7 <_panic>

00801d61 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801d61:	55                   	push   %ebp
  801d62:	89 e5                	mov    %esp,%ebp
  801d64:	83 ec 18             	sub    $0x18,%esp
  801d67:	8b 45 10             	mov    0x10(%ebp),%eax
  801d6a:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d6d:	e8 a9 fd ff ff       	call   801b1b <InitializeUHeap>
	if (size == 0) return NULL ;
  801d72:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d76:	75 07                	jne    801d7f <smalloc+0x1e>
  801d78:	b8 00 00 00 00       	mov    $0x0,%eax
  801d7d:	eb 14                	jmp    801d93 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801d7f:	83 ec 04             	sub    $0x4,%esp
  801d82:	68 a4 45 80 00       	push   $0x8045a4
  801d87:	6a 76                	push   $0x76
  801d89:	68 27 45 80 00       	push   $0x804527
  801d8e:	e8 44 eb ff ff       	call   8008d7 <_panic>

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801d93:	c9                   	leave  
  801d94:	c3                   	ret    

00801d95 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801d95:	55                   	push   %ebp
  801d96:	89 e5                	mov    %esp,%ebp
  801d98:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d9b:	e8 7b fd ff ff       	call   801b1b <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801da0:	83 ec 04             	sub    $0x4,%esp
  801da3:	68 cc 45 80 00       	push   $0x8045cc
  801da8:	68 93 00 00 00       	push   $0x93
  801dad:	68 27 45 80 00       	push   $0x804527
  801db2:	e8 20 eb ff ff       	call   8008d7 <_panic>

00801db7 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801db7:	55                   	push   %ebp
  801db8:	89 e5                	mov    %esp,%ebp
  801dba:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801dbd:	e8 59 fd ff ff       	call   801b1b <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801dc2:	83 ec 04             	sub    $0x4,%esp
  801dc5:	68 f0 45 80 00       	push   $0x8045f0
  801dca:	68 c5 00 00 00       	push   $0xc5
  801dcf:	68 27 45 80 00       	push   $0x804527
  801dd4:	e8 fe ea ff ff       	call   8008d7 <_panic>

00801dd9 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801dd9:	55                   	push   %ebp
  801dda:	89 e5                	mov    %esp,%ebp
  801ddc:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801ddf:	83 ec 04             	sub    $0x4,%esp
  801de2:	68 18 46 80 00       	push   $0x804618
  801de7:	68 d9 00 00 00       	push   $0xd9
  801dec:	68 27 45 80 00       	push   $0x804527
  801df1:	e8 e1 ea ff ff       	call   8008d7 <_panic>

00801df6 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801df6:	55                   	push   %ebp
  801df7:	89 e5                	mov    %esp,%ebp
  801df9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801dfc:	83 ec 04             	sub    $0x4,%esp
  801dff:	68 3c 46 80 00       	push   $0x80463c
  801e04:	68 e4 00 00 00       	push   $0xe4
  801e09:	68 27 45 80 00       	push   $0x804527
  801e0e:	e8 c4 ea ff ff       	call   8008d7 <_panic>

00801e13 <shrink>:

}
void shrink(uint32 newSize)
{
  801e13:	55                   	push   %ebp
  801e14:	89 e5                	mov    %esp,%ebp
  801e16:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e19:	83 ec 04             	sub    $0x4,%esp
  801e1c:	68 3c 46 80 00       	push   $0x80463c
  801e21:	68 e9 00 00 00       	push   $0xe9
  801e26:	68 27 45 80 00       	push   $0x804527
  801e2b:	e8 a7 ea ff ff       	call   8008d7 <_panic>

00801e30 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801e30:	55                   	push   %ebp
  801e31:	89 e5                	mov    %esp,%ebp
  801e33:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e36:	83 ec 04             	sub    $0x4,%esp
  801e39:	68 3c 46 80 00       	push   $0x80463c
  801e3e:	68 ee 00 00 00       	push   $0xee
  801e43:	68 27 45 80 00       	push   $0x804527
  801e48:	e8 8a ea ff ff       	call   8008d7 <_panic>

00801e4d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801e4d:	55                   	push   %ebp
  801e4e:	89 e5                	mov    %esp,%ebp
  801e50:	57                   	push   %edi
  801e51:	56                   	push   %esi
  801e52:	53                   	push   %ebx
  801e53:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801e56:	8b 45 08             	mov    0x8(%ebp),%eax
  801e59:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e5c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e5f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e62:	8b 7d 18             	mov    0x18(%ebp),%edi
  801e65:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801e68:	cd 30                	int    $0x30
  801e6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801e6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801e70:	83 c4 10             	add    $0x10,%esp
  801e73:	5b                   	pop    %ebx
  801e74:	5e                   	pop    %esi
  801e75:	5f                   	pop    %edi
  801e76:	5d                   	pop    %ebp
  801e77:	c3                   	ret    

00801e78 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801e78:	55                   	push   %ebp
  801e79:	89 e5                	mov    %esp,%ebp
  801e7b:	83 ec 04             	sub    $0x4,%esp
  801e7e:	8b 45 10             	mov    0x10(%ebp),%eax
  801e81:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801e84:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e88:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8b:	6a 00                	push   $0x0
  801e8d:	6a 00                	push   $0x0
  801e8f:	52                   	push   %edx
  801e90:	ff 75 0c             	pushl  0xc(%ebp)
  801e93:	50                   	push   %eax
  801e94:	6a 00                	push   $0x0
  801e96:	e8 b2 ff ff ff       	call   801e4d <syscall>
  801e9b:	83 c4 18             	add    $0x18,%esp
}
  801e9e:	90                   	nop
  801e9f:	c9                   	leave  
  801ea0:	c3                   	ret    

00801ea1 <sys_cgetc>:

int
sys_cgetc(void)
{
  801ea1:	55                   	push   %ebp
  801ea2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801ea4:	6a 00                	push   $0x0
  801ea6:	6a 00                	push   $0x0
  801ea8:	6a 00                	push   $0x0
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 00                	push   $0x0
  801eae:	6a 01                	push   $0x1
  801eb0:	e8 98 ff ff ff       	call   801e4d <syscall>
  801eb5:	83 c4 18             	add    $0x18,%esp
}
  801eb8:	c9                   	leave  
  801eb9:	c3                   	ret    

00801eba <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801eba:	55                   	push   %ebp
  801ebb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801ebd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec3:	6a 00                	push   $0x0
  801ec5:	6a 00                	push   $0x0
  801ec7:	6a 00                	push   $0x0
  801ec9:	52                   	push   %edx
  801eca:	50                   	push   %eax
  801ecb:	6a 05                	push   $0x5
  801ecd:	e8 7b ff ff ff       	call   801e4d <syscall>
  801ed2:	83 c4 18             	add    $0x18,%esp
}
  801ed5:	c9                   	leave  
  801ed6:	c3                   	ret    

00801ed7 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801ed7:	55                   	push   %ebp
  801ed8:	89 e5                	mov    %esp,%ebp
  801eda:	56                   	push   %esi
  801edb:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801edc:	8b 75 18             	mov    0x18(%ebp),%esi
  801edf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ee2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ee5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  801eeb:	56                   	push   %esi
  801eec:	53                   	push   %ebx
  801eed:	51                   	push   %ecx
  801eee:	52                   	push   %edx
  801eef:	50                   	push   %eax
  801ef0:	6a 06                	push   $0x6
  801ef2:	e8 56 ff ff ff       	call   801e4d <syscall>
  801ef7:	83 c4 18             	add    $0x18,%esp
}
  801efa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801efd:	5b                   	pop    %ebx
  801efe:	5e                   	pop    %esi
  801eff:	5d                   	pop    %ebp
  801f00:	c3                   	ret    

00801f01 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801f01:	55                   	push   %ebp
  801f02:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801f04:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f07:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0a:	6a 00                	push   $0x0
  801f0c:	6a 00                	push   $0x0
  801f0e:	6a 00                	push   $0x0
  801f10:	52                   	push   %edx
  801f11:	50                   	push   %eax
  801f12:	6a 07                	push   $0x7
  801f14:	e8 34 ff ff ff       	call   801e4d <syscall>
  801f19:	83 c4 18             	add    $0x18,%esp
}
  801f1c:	c9                   	leave  
  801f1d:	c3                   	ret    

00801f1e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801f1e:	55                   	push   %ebp
  801f1f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801f21:	6a 00                	push   $0x0
  801f23:	6a 00                	push   $0x0
  801f25:	6a 00                	push   $0x0
  801f27:	ff 75 0c             	pushl  0xc(%ebp)
  801f2a:	ff 75 08             	pushl  0x8(%ebp)
  801f2d:	6a 08                	push   $0x8
  801f2f:	e8 19 ff ff ff       	call   801e4d <syscall>
  801f34:	83 c4 18             	add    $0x18,%esp
}
  801f37:	c9                   	leave  
  801f38:	c3                   	ret    

00801f39 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801f39:	55                   	push   %ebp
  801f3a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801f3c:	6a 00                	push   $0x0
  801f3e:	6a 00                	push   $0x0
  801f40:	6a 00                	push   $0x0
  801f42:	6a 00                	push   $0x0
  801f44:	6a 00                	push   $0x0
  801f46:	6a 09                	push   $0x9
  801f48:	e8 00 ff ff ff       	call   801e4d <syscall>
  801f4d:	83 c4 18             	add    $0x18,%esp
}
  801f50:	c9                   	leave  
  801f51:	c3                   	ret    

00801f52 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801f52:	55                   	push   %ebp
  801f53:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801f55:	6a 00                	push   $0x0
  801f57:	6a 00                	push   $0x0
  801f59:	6a 00                	push   $0x0
  801f5b:	6a 00                	push   $0x0
  801f5d:	6a 00                	push   $0x0
  801f5f:	6a 0a                	push   $0xa
  801f61:	e8 e7 fe ff ff       	call   801e4d <syscall>
  801f66:	83 c4 18             	add    $0x18,%esp
}
  801f69:	c9                   	leave  
  801f6a:	c3                   	ret    

00801f6b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801f6b:	55                   	push   %ebp
  801f6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801f6e:	6a 00                	push   $0x0
  801f70:	6a 00                	push   $0x0
  801f72:	6a 00                	push   $0x0
  801f74:	6a 00                	push   $0x0
  801f76:	6a 00                	push   $0x0
  801f78:	6a 0b                	push   $0xb
  801f7a:	e8 ce fe ff ff       	call   801e4d <syscall>
  801f7f:	83 c4 18             	add    $0x18,%esp
}
  801f82:	c9                   	leave  
  801f83:	c3                   	ret    

00801f84 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801f84:	55                   	push   %ebp
  801f85:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801f87:	6a 00                	push   $0x0
  801f89:	6a 00                	push   $0x0
  801f8b:	6a 00                	push   $0x0
  801f8d:	ff 75 0c             	pushl  0xc(%ebp)
  801f90:	ff 75 08             	pushl  0x8(%ebp)
  801f93:	6a 0f                	push   $0xf
  801f95:	e8 b3 fe ff ff       	call   801e4d <syscall>
  801f9a:	83 c4 18             	add    $0x18,%esp
	return;
  801f9d:	90                   	nop
}
  801f9e:	c9                   	leave  
  801f9f:	c3                   	ret    

00801fa0 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801fa0:	55                   	push   %ebp
  801fa1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801fa3:	6a 00                	push   $0x0
  801fa5:	6a 00                	push   $0x0
  801fa7:	6a 00                	push   $0x0
  801fa9:	ff 75 0c             	pushl  0xc(%ebp)
  801fac:	ff 75 08             	pushl  0x8(%ebp)
  801faf:	6a 10                	push   $0x10
  801fb1:	e8 97 fe ff ff       	call   801e4d <syscall>
  801fb6:	83 c4 18             	add    $0x18,%esp
	return ;
  801fb9:	90                   	nop
}
  801fba:	c9                   	leave  
  801fbb:	c3                   	ret    

00801fbc <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801fbc:	55                   	push   %ebp
  801fbd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801fbf:	6a 00                	push   $0x0
  801fc1:	6a 00                	push   $0x0
  801fc3:	ff 75 10             	pushl  0x10(%ebp)
  801fc6:	ff 75 0c             	pushl  0xc(%ebp)
  801fc9:	ff 75 08             	pushl  0x8(%ebp)
  801fcc:	6a 11                	push   $0x11
  801fce:	e8 7a fe ff ff       	call   801e4d <syscall>
  801fd3:	83 c4 18             	add    $0x18,%esp
	return ;
  801fd6:	90                   	nop
}
  801fd7:	c9                   	leave  
  801fd8:	c3                   	ret    

00801fd9 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801fd9:	55                   	push   %ebp
  801fda:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801fdc:	6a 00                	push   $0x0
  801fde:	6a 00                	push   $0x0
  801fe0:	6a 00                	push   $0x0
  801fe2:	6a 00                	push   $0x0
  801fe4:	6a 00                	push   $0x0
  801fe6:	6a 0c                	push   $0xc
  801fe8:	e8 60 fe ff ff       	call   801e4d <syscall>
  801fed:	83 c4 18             	add    $0x18,%esp
}
  801ff0:	c9                   	leave  
  801ff1:	c3                   	ret    

00801ff2 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ff2:	55                   	push   %ebp
  801ff3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ff5:	6a 00                	push   $0x0
  801ff7:	6a 00                	push   $0x0
  801ff9:	6a 00                	push   $0x0
  801ffb:	6a 00                	push   $0x0
  801ffd:	ff 75 08             	pushl  0x8(%ebp)
  802000:	6a 0d                	push   $0xd
  802002:	e8 46 fe ff ff       	call   801e4d <syscall>
  802007:	83 c4 18             	add    $0x18,%esp
}
  80200a:	c9                   	leave  
  80200b:	c3                   	ret    

0080200c <sys_scarce_memory>:

void sys_scarce_memory()
{
  80200c:	55                   	push   %ebp
  80200d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80200f:	6a 00                	push   $0x0
  802011:	6a 00                	push   $0x0
  802013:	6a 00                	push   $0x0
  802015:	6a 00                	push   $0x0
  802017:	6a 00                	push   $0x0
  802019:	6a 0e                	push   $0xe
  80201b:	e8 2d fe ff ff       	call   801e4d <syscall>
  802020:	83 c4 18             	add    $0x18,%esp
}
  802023:	90                   	nop
  802024:	c9                   	leave  
  802025:	c3                   	ret    

00802026 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802026:	55                   	push   %ebp
  802027:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802029:	6a 00                	push   $0x0
  80202b:	6a 00                	push   $0x0
  80202d:	6a 00                	push   $0x0
  80202f:	6a 00                	push   $0x0
  802031:	6a 00                	push   $0x0
  802033:	6a 13                	push   $0x13
  802035:	e8 13 fe ff ff       	call   801e4d <syscall>
  80203a:	83 c4 18             	add    $0x18,%esp
}
  80203d:	90                   	nop
  80203e:	c9                   	leave  
  80203f:	c3                   	ret    

00802040 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802040:	55                   	push   %ebp
  802041:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802043:	6a 00                	push   $0x0
  802045:	6a 00                	push   $0x0
  802047:	6a 00                	push   $0x0
  802049:	6a 00                	push   $0x0
  80204b:	6a 00                	push   $0x0
  80204d:	6a 14                	push   $0x14
  80204f:	e8 f9 fd ff ff       	call   801e4d <syscall>
  802054:	83 c4 18             	add    $0x18,%esp
}
  802057:	90                   	nop
  802058:	c9                   	leave  
  802059:	c3                   	ret    

0080205a <sys_cputc>:


void
sys_cputc(const char c)
{
  80205a:	55                   	push   %ebp
  80205b:	89 e5                	mov    %esp,%ebp
  80205d:	83 ec 04             	sub    $0x4,%esp
  802060:	8b 45 08             	mov    0x8(%ebp),%eax
  802063:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802066:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80206a:	6a 00                	push   $0x0
  80206c:	6a 00                	push   $0x0
  80206e:	6a 00                	push   $0x0
  802070:	6a 00                	push   $0x0
  802072:	50                   	push   %eax
  802073:	6a 15                	push   $0x15
  802075:	e8 d3 fd ff ff       	call   801e4d <syscall>
  80207a:	83 c4 18             	add    $0x18,%esp
}
  80207d:	90                   	nop
  80207e:	c9                   	leave  
  80207f:	c3                   	ret    

00802080 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802080:	55                   	push   %ebp
  802081:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802083:	6a 00                	push   $0x0
  802085:	6a 00                	push   $0x0
  802087:	6a 00                	push   $0x0
  802089:	6a 00                	push   $0x0
  80208b:	6a 00                	push   $0x0
  80208d:	6a 16                	push   $0x16
  80208f:	e8 b9 fd ff ff       	call   801e4d <syscall>
  802094:	83 c4 18             	add    $0x18,%esp
}
  802097:	90                   	nop
  802098:	c9                   	leave  
  802099:	c3                   	ret    

0080209a <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80209a:	55                   	push   %ebp
  80209b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80209d:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a0:	6a 00                	push   $0x0
  8020a2:	6a 00                	push   $0x0
  8020a4:	6a 00                	push   $0x0
  8020a6:	ff 75 0c             	pushl  0xc(%ebp)
  8020a9:	50                   	push   %eax
  8020aa:	6a 17                	push   $0x17
  8020ac:	e8 9c fd ff ff       	call   801e4d <syscall>
  8020b1:	83 c4 18             	add    $0x18,%esp
}
  8020b4:	c9                   	leave  
  8020b5:	c3                   	ret    

008020b6 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8020b6:	55                   	push   %ebp
  8020b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8020b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bf:	6a 00                	push   $0x0
  8020c1:	6a 00                	push   $0x0
  8020c3:	6a 00                	push   $0x0
  8020c5:	52                   	push   %edx
  8020c6:	50                   	push   %eax
  8020c7:	6a 1a                	push   $0x1a
  8020c9:	e8 7f fd ff ff       	call   801e4d <syscall>
  8020ce:	83 c4 18             	add    $0x18,%esp
}
  8020d1:	c9                   	leave  
  8020d2:	c3                   	ret    

008020d3 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8020d3:	55                   	push   %ebp
  8020d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8020d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020dc:	6a 00                	push   $0x0
  8020de:	6a 00                	push   $0x0
  8020e0:	6a 00                	push   $0x0
  8020e2:	52                   	push   %edx
  8020e3:	50                   	push   %eax
  8020e4:	6a 18                	push   $0x18
  8020e6:	e8 62 fd ff ff       	call   801e4d <syscall>
  8020eb:	83 c4 18             	add    $0x18,%esp
}
  8020ee:	90                   	nop
  8020ef:	c9                   	leave  
  8020f0:	c3                   	ret    

008020f1 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8020f1:	55                   	push   %ebp
  8020f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8020f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fa:	6a 00                	push   $0x0
  8020fc:	6a 00                	push   $0x0
  8020fe:	6a 00                	push   $0x0
  802100:	52                   	push   %edx
  802101:	50                   	push   %eax
  802102:	6a 19                	push   $0x19
  802104:	e8 44 fd ff ff       	call   801e4d <syscall>
  802109:	83 c4 18             	add    $0x18,%esp
}
  80210c:	90                   	nop
  80210d:	c9                   	leave  
  80210e:	c3                   	ret    

0080210f <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80210f:	55                   	push   %ebp
  802110:	89 e5                	mov    %esp,%ebp
  802112:	83 ec 04             	sub    $0x4,%esp
  802115:	8b 45 10             	mov    0x10(%ebp),%eax
  802118:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80211b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80211e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802122:	8b 45 08             	mov    0x8(%ebp),%eax
  802125:	6a 00                	push   $0x0
  802127:	51                   	push   %ecx
  802128:	52                   	push   %edx
  802129:	ff 75 0c             	pushl  0xc(%ebp)
  80212c:	50                   	push   %eax
  80212d:	6a 1b                	push   $0x1b
  80212f:	e8 19 fd ff ff       	call   801e4d <syscall>
  802134:	83 c4 18             	add    $0x18,%esp
}
  802137:	c9                   	leave  
  802138:	c3                   	ret    

00802139 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802139:	55                   	push   %ebp
  80213a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80213c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80213f:	8b 45 08             	mov    0x8(%ebp),%eax
  802142:	6a 00                	push   $0x0
  802144:	6a 00                	push   $0x0
  802146:	6a 00                	push   $0x0
  802148:	52                   	push   %edx
  802149:	50                   	push   %eax
  80214a:	6a 1c                	push   $0x1c
  80214c:	e8 fc fc ff ff       	call   801e4d <syscall>
  802151:	83 c4 18             	add    $0x18,%esp
}
  802154:	c9                   	leave  
  802155:	c3                   	ret    

00802156 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802156:	55                   	push   %ebp
  802157:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802159:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80215c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80215f:	8b 45 08             	mov    0x8(%ebp),%eax
  802162:	6a 00                	push   $0x0
  802164:	6a 00                	push   $0x0
  802166:	51                   	push   %ecx
  802167:	52                   	push   %edx
  802168:	50                   	push   %eax
  802169:	6a 1d                	push   $0x1d
  80216b:	e8 dd fc ff ff       	call   801e4d <syscall>
  802170:	83 c4 18             	add    $0x18,%esp
}
  802173:	c9                   	leave  
  802174:	c3                   	ret    

00802175 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802175:	55                   	push   %ebp
  802176:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802178:	8b 55 0c             	mov    0xc(%ebp),%edx
  80217b:	8b 45 08             	mov    0x8(%ebp),%eax
  80217e:	6a 00                	push   $0x0
  802180:	6a 00                	push   $0x0
  802182:	6a 00                	push   $0x0
  802184:	52                   	push   %edx
  802185:	50                   	push   %eax
  802186:	6a 1e                	push   $0x1e
  802188:	e8 c0 fc ff ff       	call   801e4d <syscall>
  80218d:	83 c4 18             	add    $0x18,%esp
}
  802190:	c9                   	leave  
  802191:	c3                   	ret    

00802192 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802192:	55                   	push   %ebp
  802193:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802195:	6a 00                	push   $0x0
  802197:	6a 00                	push   $0x0
  802199:	6a 00                	push   $0x0
  80219b:	6a 00                	push   $0x0
  80219d:	6a 00                	push   $0x0
  80219f:	6a 1f                	push   $0x1f
  8021a1:	e8 a7 fc ff ff       	call   801e4d <syscall>
  8021a6:	83 c4 18             	add    $0x18,%esp
}
  8021a9:	c9                   	leave  
  8021aa:	c3                   	ret    

008021ab <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8021ab:	55                   	push   %ebp
  8021ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8021ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b1:	6a 00                	push   $0x0
  8021b3:	ff 75 14             	pushl  0x14(%ebp)
  8021b6:	ff 75 10             	pushl  0x10(%ebp)
  8021b9:	ff 75 0c             	pushl  0xc(%ebp)
  8021bc:	50                   	push   %eax
  8021bd:	6a 20                	push   $0x20
  8021bf:	e8 89 fc ff ff       	call   801e4d <syscall>
  8021c4:	83 c4 18             	add    $0x18,%esp
}
  8021c7:	c9                   	leave  
  8021c8:	c3                   	ret    

008021c9 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8021c9:	55                   	push   %ebp
  8021ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8021cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cf:	6a 00                	push   $0x0
  8021d1:	6a 00                	push   $0x0
  8021d3:	6a 00                	push   $0x0
  8021d5:	6a 00                	push   $0x0
  8021d7:	50                   	push   %eax
  8021d8:	6a 21                	push   $0x21
  8021da:	e8 6e fc ff ff       	call   801e4d <syscall>
  8021df:	83 c4 18             	add    $0x18,%esp
}
  8021e2:	90                   	nop
  8021e3:	c9                   	leave  
  8021e4:	c3                   	ret    

008021e5 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8021e5:	55                   	push   %ebp
  8021e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8021e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021eb:	6a 00                	push   $0x0
  8021ed:	6a 00                	push   $0x0
  8021ef:	6a 00                	push   $0x0
  8021f1:	6a 00                	push   $0x0
  8021f3:	50                   	push   %eax
  8021f4:	6a 22                	push   $0x22
  8021f6:	e8 52 fc ff ff       	call   801e4d <syscall>
  8021fb:	83 c4 18             	add    $0x18,%esp
}
  8021fe:	c9                   	leave  
  8021ff:	c3                   	ret    

00802200 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802200:	55                   	push   %ebp
  802201:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802203:	6a 00                	push   $0x0
  802205:	6a 00                	push   $0x0
  802207:	6a 00                	push   $0x0
  802209:	6a 00                	push   $0x0
  80220b:	6a 00                	push   $0x0
  80220d:	6a 02                	push   $0x2
  80220f:	e8 39 fc ff ff       	call   801e4d <syscall>
  802214:	83 c4 18             	add    $0x18,%esp
}
  802217:	c9                   	leave  
  802218:	c3                   	ret    

00802219 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802219:	55                   	push   %ebp
  80221a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80221c:	6a 00                	push   $0x0
  80221e:	6a 00                	push   $0x0
  802220:	6a 00                	push   $0x0
  802222:	6a 00                	push   $0x0
  802224:	6a 00                	push   $0x0
  802226:	6a 03                	push   $0x3
  802228:	e8 20 fc ff ff       	call   801e4d <syscall>
  80222d:	83 c4 18             	add    $0x18,%esp
}
  802230:	c9                   	leave  
  802231:	c3                   	ret    

00802232 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802232:	55                   	push   %ebp
  802233:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802235:	6a 00                	push   $0x0
  802237:	6a 00                	push   $0x0
  802239:	6a 00                	push   $0x0
  80223b:	6a 00                	push   $0x0
  80223d:	6a 00                	push   $0x0
  80223f:	6a 04                	push   $0x4
  802241:	e8 07 fc ff ff       	call   801e4d <syscall>
  802246:	83 c4 18             	add    $0x18,%esp
}
  802249:	c9                   	leave  
  80224a:	c3                   	ret    

0080224b <sys_exit_env>:


void sys_exit_env(void)
{
  80224b:	55                   	push   %ebp
  80224c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80224e:	6a 00                	push   $0x0
  802250:	6a 00                	push   $0x0
  802252:	6a 00                	push   $0x0
  802254:	6a 00                	push   $0x0
  802256:	6a 00                	push   $0x0
  802258:	6a 23                	push   $0x23
  80225a:	e8 ee fb ff ff       	call   801e4d <syscall>
  80225f:	83 c4 18             	add    $0x18,%esp
}
  802262:	90                   	nop
  802263:	c9                   	leave  
  802264:	c3                   	ret    

00802265 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802265:	55                   	push   %ebp
  802266:	89 e5                	mov    %esp,%ebp
  802268:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80226b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80226e:	8d 50 04             	lea    0x4(%eax),%edx
  802271:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802274:	6a 00                	push   $0x0
  802276:	6a 00                	push   $0x0
  802278:	6a 00                	push   $0x0
  80227a:	52                   	push   %edx
  80227b:	50                   	push   %eax
  80227c:	6a 24                	push   $0x24
  80227e:	e8 ca fb ff ff       	call   801e4d <syscall>
  802283:	83 c4 18             	add    $0x18,%esp
	return result;
  802286:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802289:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80228c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80228f:	89 01                	mov    %eax,(%ecx)
  802291:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802294:	8b 45 08             	mov    0x8(%ebp),%eax
  802297:	c9                   	leave  
  802298:	c2 04 00             	ret    $0x4

0080229b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80229b:	55                   	push   %ebp
  80229c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80229e:	6a 00                	push   $0x0
  8022a0:	6a 00                	push   $0x0
  8022a2:	ff 75 10             	pushl  0x10(%ebp)
  8022a5:	ff 75 0c             	pushl  0xc(%ebp)
  8022a8:	ff 75 08             	pushl  0x8(%ebp)
  8022ab:	6a 12                	push   $0x12
  8022ad:	e8 9b fb ff ff       	call   801e4d <syscall>
  8022b2:	83 c4 18             	add    $0x18,%esp
	return ;
  8022b5:	90                   	nop
}
  8022b6:	c9                   	leave  
  8022b7:	c3                   	ret    

008022b8 <sys_rcr2>:
uint32 sys_rcr2()
{
  8022b8:	55                   	push   %ebp
  8022b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8022bb:	6a 00                	push   $0x0
  8022bd:	6a 00                	push   $0x0
  8022bf:	6a 00                	push   $0x0
  8022c1:	6a 00                	push   $0x0
  8022c3:	6a 00                	push   $0x0
  8022c5:	6a 25                	push   $0x25
  8022c7:	e8 81 fb ff ff       	call   801e4d <syscall>
  8022cc:	83 c4 18             	add    $0x18,%esp
}
  8022cf:	c9                   	leave  
  8022d0:	c3                   	ret    

008022d1 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8022d1:	55                   	push   %ebp
  8022d2:	89 e5                	mov    %esp,%ebp
  8022d4:	83 ec 04             	sub    $0x4,%esp
  8022d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022da:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8022dd:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8022e1:	6a 00                	push   $0x0
  8022e3:	6a 00                	push   $0x0
  8022e5:	6a 00                	push   $0x0
  8022e7:	6a 00                	push   $0x0
  8022e9:	50                   	push   %eax
  8022ea:	6a 26                	push   $0x26
  8022ec:	e8 5c fb ff ff       	call   801e4d <syscall>
  8022f1:	83 c4 18             	add    $0x18,%esp
	return ;
  8022f4:	90                   	nop
}
  8022f5:	c9                   	leave  
  8022f6:	c3                   	ret    

008022f7 <rsttst>:
void rsttst()
{
  8022f7:	55                   	push   %ebp
  8022f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8022fa:	6a 00                	push   $0x0
  8022fc:	6a 00                	push   $0x0
  8022fe:	6a 00                	push   $0x0
  802300:	6a 00                	push   $0x0
  802302:	6a 00                	push   $0x0
  802304:	6a 28                	push   $0x28
  802306:	e8 42 fb ff ff       	call   801e4d <syscall>
  80230b:	83 c4 18             	add    $0x18,%esp
	return ;
  80230e:	90                   	nop
}
  80230f:	c9                   	leave  
  802310:	c3                   	ret    

00802311 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802311:	55                   	push   %ebp
  802312:	89 e5                	mov    %esp,%ebp
  802314:	83 ec 04             	sub    $0x4,%esp
  802317:	8b 45 14             	mov    0x14(%ebp),%eax
  80231a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80231d:	8b 55 18             	mov    0x18(%ebp),%edx
  802320:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802324:	52                   	push   %edx
  802325:	50                   	push   %eax
  802326:	ff 75 10             	pushl  0x10(%ebp)
  802329:	ff 75 0c             	pushl  0xc(%ebp)
  80232c:	ff 75 08             	pushl  0x8(%ebp)
  80232f:	6a 27                	push   $0x27
  802331:	e8 17 fb ff ff       	call   801e4d <syscall>
  802336:	83 c4 18             	add    $0x18,%esp
	return ;
  802339:	90                   	nop
}
  80233a:	c9                   	leave  
  80233b:	c3                   	ret    

0080233c <chktst>:
void chktst(uint32 n)
{
  80233c:	55                   	push   %ebp
  80233d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80233f:	6a 00                	push   $0x0
  802341:	6a 00                	push   $0x0
  802343:	6a 00                	push   $0x0
  802345:	6a 00                	push   $0x0
  802347:	ff 75 08             	pushl  0x8(%ebp)
  80234a:	6a 29                	push   $0x29
  80234c:	e8 fc fa ff ff       	call   801e4d <syscall>
  802351:	83 c4 18             	add    $0x18,%esp
	return ;
  802354:	90                   	nop
}
  802355:	c9                   	leave  
  802356:	c3                   	ret    

00802357 <inctst>:

void inctst()
{
  802357:	55                   	push   %ebp
  802358:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80235a:	6a 00                	push   $0x0
  80235c:	6a 00                	push   $0x0
  80235e:	6a 00                	push   $0x0
  802360:	6a 00                	push   $0x0
  802362:	6a 00                	push   $0x0
  802364:	6a 2a                	push   $0x2a
  802366:	e8 e2 fa ff ff       	call   801e4d <syscall>
  80236b:	83 c4 18             	add    $0x18,%esp
	return ;
  80236e:	90                   	nop
}
  80236f:	c9                   	leave  
  802370:	c3                   	ret    

00802371 <gettst>:
uint32 gettst()
{
  802371:	55                   	push   %ebp
  802372:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802374:	6a 00                	push   $0x0
  802376:	6a 00                	push   $0x0
  802378:	6a 00                	push   $0x0
  80237a:	6a 00                	push   $0x0
  80237c:	6a 00                	push   $0x0
  80237e:	6a 2b                	push   $0x2b
  802380:	e8 c8 fa ff ff       	call   801e4d <syscall>
  802385:	83 c4 18             	add    $0x18,%esp
}
  802388:	c9                   	leave  
  802389:	c3                   	ret    

0080238a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80238a:	55                   	push   %ebp
  80238b:	89 e5                	mov    %esp,%ebp
  80238d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802390:	6a 00                	push   $0x0
  802392:	6a 00                	push   $0x0
  802394:	6a 00                	push   $0x0
  802396:	6a 00                	push   $0x0
  802398:	6a 00                	push   $0x0
  80239a:	6a 2c                	push   $0x2c
  80239c:	e8 ac fa ff ff       	call   801e4d <syscall>
  8023a1:	83 c4 18             	add    $0x18,%esp
  8023a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8023a7:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8023ab:	75 07                	jne    8023b4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8023ad:	b8 01 00 00 00       	mov    $0x1,%eax
  8023b2:	eb 05                	jmp    8023b9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8023b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023b9:	c9                   	leave  
  8023ba:	c3                   	ret    

008023bb <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8023bb:	55                   	push   %ebp
  8023bc:	89 e5                	mov    %esp,%ebp
  8023be:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023c1:	6a 00                	push   $0x0
  8023c3:	6a 00                	push   $0x0
  8023c5:	6a 00                	push   $0x0
  8023c7:	6a 00                	push   $0x0
  8023c9:	6a 00                	push   $0x0
  8023cb:	6a 2c                	push   $0x2c
  8023cd:	e8 7b fa ff ff       	call   801e4d <syscall>
  8023d2:	83 c4 18             	add    $0x18,%esp
  8023d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8023d8:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8023dc:	75 07                	jne    8023e5 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8023de:	b8 01 00 00 00       	mov    $0x1,%eax
  8023e3:	eb 05                	jmp    8023ea <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8023e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023ea:	c9                   	leave  
  8023eb:	c3                   	ret    

008023ec <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8023ec:	55                   	push   %ebp
  8023ed:	89 e5                	mov    %esp,%ebp
  8023ef:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023f2:	6a 00                	push   $0x0
  8023f4:	6a 00                	push   $0x0
  8023f6:	6a 00                	push   $0x0
  8023f8:	6a 00                	push   $0x0
  8023fa:	6a 00                	push   $0x0
  8023fc:	6a 2c                	push   $0x2c
  8023fe:	e8 4a fa ff ff       	call   801e4d <syscall>
  802403:	83 c4 18             	add    $0x18,%esp
  802406:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802409:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80240d:	75 07                	jne    802416 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80240f:	b8 01 00 00 00       	mov    $0x1,%eax
  802414:	eb 05                	jmp    80241b <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802416:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80241b:	c9                   	leave  
  80241c:	c3                   	ret    

0080241d <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80241d:	55                   	push   %ebp
  80241e:	89 e5                	mov    %esp,%ebp
  802420:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802423:	6a 00                	push   $0x0
  802425:	6a 00                	push   $0x0
  802427:	6a 00                	push   $0x0
  802429:	6a 00                	push   $0x0
  80242b:	6a 00                	push   $0x0
  80242d:	6a 2c                	push   $0x2c
  80242f:	e8 19 fa ff ff       	call   801e4d <syscall>
  802434:	83 c4 18             	add    $0x18,%esp
  802437:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80243a:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80243e:	75 07                	jne    802447 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802440:	b8 01 00 00 00       	mov    $0x1,%eax
  802445:	eb 05                	jmp    80244c <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802447:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80244c:	c9                   	leave  
  80244d:	c3                   	ret    

0080244e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80244e:	55                   	push   %ebp
  80244f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802451:	6a 00                	push   $0x0
  802453:	6a 00                	push   $0x0
  802455:	6a 00                	push   $0x0
  802457:	6a 00                	push   $0x0
  802459:	ff 75 08             	pushl  0x8(%ebp)
  80245c:	6a 2d                	push   $0x2d
  80245e:	e8 ea f9 ff ff       	call   801e4d <syscall>
  802463:	83 c4 18             	add    $0x18,%esp
	return ;
  802466:	90                   	nop
}
  802467:	c9                   	leave  
  802468:	c3                   	ret    

00802469 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802469:	55                   	push   %ebp
  80246a:	89 e5                	mov    %esp,%ebp
  80246c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80246d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802470:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802473:	8b 55 0c             	mov    0xc(%ebp),%edx
  802476:	8b 45 08             	mov    0x8(%ebp),%eax
  802479:	6a 00                	push   $0x0
  80247b:	53                   	push   %ebx
  80247c:	51                   	push   %ecx
  80247d:	52                   	push   %edx
  80247e:	50                   	push   %eax
  80247f:	6a 2e                	push   $0x2e
  802481:	e8 c7 f9 ff ff       	call   801e4d <syscall>
  802486:	83 c4 18             	add    $0x18,%esp
}
  802489:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80248c:	c9                   	leave  
  80248d:	c3                   	ret    

0080248e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80248e:	55                   	push   %ebp
  80248f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802491:	8b 55 0c             	mov    0xc(%ebp),%edx
  802494:	8b 45 08             	mov    0x8(%ebp),%eax
  802497:	6a 00                	push   $0x0
  802499:	6a 00                	push   $0x0
  80249b:	6a 00                	push   $0x0
  80249d:	52                   	push   %edx
  80249e:	50                   	push   %eax
  80249f:	6a 2f                	push   $0x2f
  8024a1:	e8 a7 f9 ff ff       	call   801e4d <syscall>
  8024a6:	83 c4 18             	add    $0x18,%esp
}
  8024a9:	c9                   	leave  
  8024aa:	c3                   	ret    

008024ab <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8024ab:	55                   	push   %ebp
  8024ac:	89 e5                	mov    %esp,%ebp
  8024ae:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8024b1:	83 ec 0c             	sub    $0xc,%esp
  8024b4:	68 4c 46 80 00       	push   $0x80464c
  8024b9:	e8 cd e6 ff ff       	call   800b8b <cprintf>
  8024be:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8024c1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8024c8:	83 ec 0c             	sub    $0xc,%esp
  8024cb:	68 78 46 80 00       	push   $0x804678
  8024d0:	e8 b6 e6 ff ff       	call   800b8b <cprintf>
  8024d5:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8024d8:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8024dc:	a1 38 51 80 00       	mov    0x805138,%eax
  8024e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024e4:	eb 56                	jmp    80253c <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8024e6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024ea:	74 1c                	je     802508 <print_mem_block_lists+0x5d>
  8024ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ef:	8b 50 08             	mov    0x8(%eax),%edx
  8024f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f5:	8b 48 08             	mov    0x8(%eax),%ecx
  8024f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024fb:	8b 40 0c             	mov    0xc(%eax),%eax
  8024fe:	01 c8                	add    %ecx,%eax
  802500:	39 c2                	cmp    %eax,%edx
  802502:	73 04                	jae    802508 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802504:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802508:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250b:	8b 50 08             	mov    0x8(%eax),%edx
  80250e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802511:	8b 40 0c             	mov    0xc(%eax),%eax
  802514:	01 c2                	add    %eax,%edx
  802516:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802519:	8b 40 08             	mov    0x8(%eax),%eax
  80251c:	83 ec 04             	sub    $0x4,%esp
  80251f:	52                   	push   %edx
  802520:	50                   	push   %eax
  802521:	68 8d 46 80 00       	push   $0x80468d
  802526:	e8 60 e6 ff ff       	call   800b8b <cprintf>
  80252b:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80252e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802531:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802534:	a1 40 51 80 00       	mov    0x805140,%eax
  802539:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80253c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802540:	74 07                	je     802549 <print_mem_block_lists+0x9e>
  802542:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802545:	8b 00                	mov    (%eax),%eax
  802547:	eb 05                	jmp    80254e <print_mem_block_lists+0xa3>
  802549:	b8 00 00 00 00       	mov    $0x0,%eax
  80254e:	a3 40 51 80 00       	mov    %eax,0x805140
  802553:	a1 40 51 80 00       	mov    0x805140,%eax
  802558:	85 c0                	test   %eax,%eax
  80255a:	75 8a                	jne    8024e6 <print_mem_block_lists+0x3b>
  80255c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802560:	75 84                	jne    8024e6 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802562:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802566:	75 10                	jne    802578 <print_mem_block_lists+0xcd>
  802568:	83 ec 0c             	sub    $0xc,%esp
  80256b:	68 9c 46 80 00       	push   $0x80469c
  802570:	e8 16 e6 ff ff       	call   800b8b <cprintf>
  802575:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802578:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80257f:	83 ec 0c             	sub    $0xc,%esp
  802582:	68 c0 46 80 00       	push   $0x8046c0
  802587:	e8 ff e5 ff ff       	call   800b8b <cprintf>
  80258c:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80258f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802593:	a1 40 50 80 00       	mov    0x805040,%eax
  802598:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80259b:	eb 56                	jmp    8025f3 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80259d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025a1:	74 1c                	je     8025bf <print_mem_block_lists+0x114>
  8025a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a6:	8b 50 08             	mov    0x8(%eax),%edx
  8025a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ac:	8b 48 08             	mov    0x8(%eax),%ecx
  8025af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8025b5:	01 c8                	add    %ecx,%eax
  8025b7:	39 c2                	cmp    %eax,%edx
  8025b9:	73 04                	jae    8025bf <print_mem_block_lists+0x114>
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
  8025d8:	68 8d 46 80 00       	push   $0x80468d
  8025dd:	e8 a9 e5 ff ff       	call   800b8b <cprintf>
  8025e2:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8025e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8025eb:	a1 48 50 80 00       	mov    0x805048,%eax
  8025f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025f7:	74 07                	je     802600 <print_mem_block_lists+0x155>
  8025f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fc:	8b 00                	mov    (%eax),%eax
  8025fe:	eb 05                	jmp    802605 <print_mem_block_lists+0x15a>
  802600:	b8 00 00 00 00       	mov    $0x0,%eax
  802605:	a3 48 50 80 00       	mov    %eax,0x805048
  80260a:	a1 48 50 80 00       	mov    0x805048,%eax
  80260f:	85 c0                	test   %eax,%eax
  802611:	75 8a                	jne    80259d <print_mem_block_lists+0xf2>
  802613:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802617:	75 84                	jne    80259d <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802619:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80261d:	75 10                	jne    80262f <print_mem_block_lists+0x184>
  80261f:	83 ec 0c             	sub    $0xc,%esp
  802622:	68 d8 46 80 00       	push   $0x8046d8
  802627:	e8 5f e5 ff ff       	call   800b8b <cprintf>
  80262c:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80262f:	83 ec 0c             	sub    $0xc,%esp
  802632:	68 4c 46 80 00       	push   $0x80464c
  802637:	e8 4f e5 ff ff       	call   800b8b <cprintf>
  80263c:	83 c4 10             	add    $0x10,%esp

}
  80263f:	90                   	nop
  802640:	c9                   	leave  
  802641:	c3                   	ret    

00802642 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802642:	55                   	push   %ebp
  802643:	89 e5                	mov    %esp,%ebp
  802645:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802648:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80264f:	00 00 00 
  802652:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802659:	00 00 00 
  80265c:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802663:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802666:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80266d:	e9 9e 00 00 00       	jmp    802710 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802672:	a1 50 50 80 00       	mov    0x805050,%eax
  802677:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80267a:	c1 e2 04             	shl    $0x4,%edx
  80267d:	01 d0                	add    %edx,%eax
  80267f:	85 c0                	test   %eax,%eax
  802681:	75 14                	jne    802697 <initialize_MemBlocksList+0x55>
  802683:	83 ec 04             	sub    $0x4,%esp
  802686:	68 00 47 80 00       	push   $0x804700
  80268b:	6a 46                	push   $0x46
  80268d:	68 23 47 80 00       	push   $0x804723
  802692:	e8 40 e2 ff ff       	call   8008d7 <_panic>
  802697:	a1 50 50 80 00       	mov    0x805050,%eax
  80269c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80269f:	c1 e2 04             	shl    $0x4,%edx
  8026a2:	01 d0                	add    %edx,%eax
  8026a4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8026aa:	89 10                	mov    %edx,(%eax)
  8026ac:	8b 00                	mov    (%eax),%eax
  8026ae:	85 c0                	test   %eax,%eax
  8026b0:	74 18                	je     8026ca <initialize_MemBlocksList+0x88>
  8026b2:	a1 48 51 80 00       	mov    0x805148,%eax
  8026b7:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8026bd:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8026c0:	c1 e1 04             	shl    $0x4,%ecx
  8026c3:	01 ca                	add    %ecx,%edx
  8026c5:	89 50 04             	mov    %edx,0x4(%eax)
  8026c8:	eb 12                	jmp    8026dc <initialize_MemBlocksList+0x9a>
  8026ca:	a1 50 50 80 00       	mov    0x805050,%eax
  8026cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026d2:	c1 e2 04             	shl    $0x4,%edx
  8026d5:	01 d0                	add    %edx,%eax
  8026d7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8026dc:	a1 50 50 80 00       	mov    0x805050,%eax
  8026e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026e4:	c1 e2 04             	shl    $0x4,%edx
  8026e7:	01 d0                	add    %edx,%eax
  8026e9:	a3 48 51 80 00       	mov    %eax,0x805148
  8026ee:	a1 50 50 80 00       	mov    0x805050,%eax
  8026f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026f6:	c1 e2 04             	shl    $0x4,%edx
  8026f9:	01 d0                	add    %edx,%eax
  8026fb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802702:	a1 54 51 80 00       	mov    0x805154,%eax
  802707:	40                   	inc    %eax
  802708:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  80270d:	ff 45 f4             	incl   -0xc(%ebp)
  802710:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802713:	3b 45 08             	cmp    0x8(%ebp),%eax
  802716:	0f 82 56 ff ff ff    	jb     802672 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  80271c:	90                   	nop
  80271d:	c9                   	leave  
  80271e:	c3                   	ret    

0080271f <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80271f:	55                   	push   %ebp
  802720:	89 e5                	mov    %esp,%ebp
  802722:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802725:	8b 45 08             	mov    0x8(%ebp),%eax
  802728:	8b 00                	mov    (%eax),%eax
  80272a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80272d:	eb 19                	jmp    802748 <find_block+0x29>
	{
		if(va==point->sva)
  80272f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802732:	8b 40 08             	mov    0x8(%eax),%eax
  802735:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802738:	75 05                	jne    80273f <find_block+0x20>
		   return point;
  80273a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80273d:	eb 36                	jmp    802775 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80273f:	8b 45 08             	mov    0x8(%ebp),%eax
  802742:	8b 40 08             	mov    0x8(%eax),%eax
  802745:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802748:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80274c:	74 07                	je     802755 <find_block+0x36>
  80274e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802751:	8b 00                	mov    (%eax),%eax
  802753:	eb 05                	jmp    80275a <find_block+0x3b>
  802755:	b8 00 00 00 00       	mov    $0x0,%eax
  80275a:	8b 55 08             	mov    0x8(%ebp),%edx
  80275d:	89 42 08             	mov    %eax,0x8(%edx)
  802760:	8b 45 08             	mov    0x8(%ebp),%eax
  802763:	8b 40 08             	mov    0x8(%eax),%eax
  802766:	85 c0                	test   %eax,%eax
  802768:	75 c5                	jne    80272f <find_block+0x10>
  80276a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80276e:	75 bf                	jne    80272f <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802770:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802775:	c9                   	leave  
  802776:	c3                   	ret    

00802777 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802777:	55                   	push   %ebp
  802778:	89 e5                	mov    %esp,%ebp
  80277a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80277d:	a1 40 50 80 00       	mov    0x805040,%eax
  802782:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802785:	a1 44 50 80 00       	mov    0x805044,%eax
  80278a:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80278d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802790:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802793:	74 24                	je     8027b9 <insert_sorted_allocList+0x42>
  802795:	8b 45 08             	mov    0x8(%ebp),%eax
  802798:	8b 50 08             	mov    0x8(%eax),%edx
  80279b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80279e:	8b 40 08             	mov    0x8(%eax),%eax
  8027a1:	39 c2                	cmp    %eax,%edx
  8027a3:	76 14                	jbe    8027b9 <insert_sorted_allocList+0x42>
  8027a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a8:	8b 50 08             	mov    0x8(%eax),%edx
  8027ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ae:	8b 40 08             	mov    0x8(%eax),%eax
  8027b1:	39 c2                	cmp    %eax,%edx
  8027b3:	0f 82 60 01 00 00    	jb     802919 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8027b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027bd:	75 65                	jne    802824 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8027bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027c3:	75 14                	jne    8027d9 <insert_sorted_allocList+0x62>
  8027c5:	83 ec 04             	sub    $0x4,%esp
  8027c8:	68 00 47 80 00       	push   $0x804700
  8027cd:	6a 6b                	push   $0x6b
  8027cf:	68 23 47 80 00       	push   $0x804723
  8027d4:	e8 fe e0 ff ff       	call   8008d7 <_panic>
  8027d9:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8027df:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e2:	89 10                	mov    %edx,(%eax)
  8027e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e7:	8b 00                	mov    (%eax),%eax
  8027e9:	85 c0                	test   %eax,%eax
  8027eb:	74 0d                	je     8027fa <insert_sorted_allocList+0x83>
  8027ed:	a1 40 50 80 00       	mov    0x805040,%eax
  8027f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8027f5:	89 50 04             	mov    %edx,0x4(%eax)
  8027f8:	eb 08                	jmp    802802 <insert_sorted_allocList+0x8b>
  8027fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fd:	a3 44 50 80 00       	mov    %eax,0x805044
  802802:	8b 45 08             	mov    0x8(%ebp),%eax
  802805:	a3 40 50 80 00       	mov    %eax,0x805040
  80280a:	8b 45 08             	mov    0x8(%ebp),%eax
  80280d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802814:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802819:	40                   	inc    %eax
  80281a:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80281f:	e9 dc 01 00 00       	jmp    802a00 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802824:	8b 45 08             	mov    0x8(%ebp),%eax
  802827:	8b 50 08             	mov    0x8(%eax),%edx
  80282a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80282d:	8b 40 08             	mov    0x8(%eax),%eax
  802830:	39 c2                	cmp    %eax,%edx
  802832:	77 6c                	ja     8028a0 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802834:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802838:	74 06                	je     802840 <insert_sorted_allocList+0xc9>
  80283a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80283e:	75 14                	jne    802854 <insert_sorted_allocList+0xdd>
  802840:	83 ec 04             	sub    $0x4,%esp
  802843:	68 3c 47 80 00       	push   $0x80473c
  802848:	6a 6f                	push   $0x6f
  80284a:	68 23 47 80 00       	push   $0x804723
  80284f:	e8 83 e0 ff ff       	call   8008d7 <_panic>
  802854:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802857:	8b 50 04             	mov    0x4(%eax),%edx
  80285a:	8b 45 08             	mov    0x8(%ebp),%eax
  80285d:	89 50 04             	mov    %edx,0x4(%eax)
  802860:	8b 45 08             	mov    0x8(%ebp),%eax
  802863:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802866:	89 10                	mov    %edx,(%eax)
  802868:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80286b:	8b 40 04             	mov    0x4(%eax),%eax
  80286e:	85 c0                	test   %eax,%eax
  802870:	74 0d                	je     80287f <insert_sorted_allocList+0x108>
  802872:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802875:	8b 40 04             	mov    0x4(%eax),%eax
  802878:	8b 55 08             	mov    0x8(%ebp),%edx
  80287b:	89 10                	mov    %edx,(%eax)
  80287d:	eb 08                	jmp    802887 <insert_sorted_allocList+0x110>
  80287f:	8b 45 08             	mov    0x8(%ebp),%eax
  802882:	a3 40 50 80 00       	mov    %eax,0x805040
  802887:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80288a:	8b 55 08             	mov    0x8(%ebp),%edx
  80288d:	89 50 04             	mov    %edx,0x4(%eax)
  802890:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802895:	40                   	inc    %eax
  802896:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80289b:	e9 60 01 00 00       	jmp    802a00 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8028a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a3:	8b 50 08             	mov    0x8(%eax),%edx
  8028a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028a9:	8b 40 08             	mov    0x8(%eax),%eax
  8028ac:	39 c2                	cmp    %eax,%edx
  8028ae:	0f 82 4c 01 00 00    	jb     802a00 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8028b4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028b8:	75 14                	jne    8028ce <insert_sorted_allocList+0x157>
  8028ba:	83 ec 04             	sub    $0x4,%esp
  8028bd:	68 74 47 80 00       	push   $0x804774
  8028c2:	6a 73                	push   $0x73
  8028c4:	68 23 47 80 00       	push   $0x804723
  8028c9:	e8 09 e0 ff ff       	call   8008d7 <_panic>
  8028ce:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8028d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d7:	89 50 04             	mov    %edx,0x4(%eax)
  8028da:	8b 45 08             	mov    0x8(%ebp),%eax
  8028dd:	8b 40 04             	mov    0x4(%eax),%eax
  8028e0:	85 c0                	test   %eax,%eax
  8028e2:	74 0c                	je     8028f0 <insert_sorted_allocList+0x179>
  8028e4:	a1 44 50 80 00       	mov    0x805044,%eax
  8028e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8028ec:	89 10                	mov    %edx,(%eax)
  8028ee:	eb 08                	jmp    8028f8 <insert_sorted_allocList+0x181>
  8028f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f3:	a3 40 50 80 00       	mov    %eax,0x805040
  8028f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fb:	a3 44 50 80 00       	mov    %eax,0x805044
  802900:	8b 45 08             	mov    0x8(%ebp),%eax
  802903:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802909:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80290e:	40                   	inc    %eax
  80290f:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802914:	e9 e7 00 00 00       	jmp    802a00 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802919:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80291c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80291f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802926:	a1 40 50 80 00       	mov    0x805040,%eax
  80292b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80292e:	e9 9d 00 00 00       	jmp    8029d0 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802933:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802936:	8b 00                	mov    (%eax),%eax
  802938:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80293b:	8b 45 08             	mov    0x8(%ebp),%eax
  80293e:	8b 50 08             	mov    0x8(%eax),%edx
  802941:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802944:	8b 40 08             	mov    0x8(%eax),%eax
  802947:	39 c2                	cmp    %eax,%edx
  802949:	76 7d                	jbe    8029c8 <insert_sorted_allocList+0x251>
  80294b:	8b 45 08             	mov    0x8(%ebp),%eax
  80294e:	8b 50 08             	mov    0x8(%eax),%edx
  802951:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802954:	8b 40 08             	mov    0x8(%eax),%eax
  802957:	39 c2                	cmp    %eax,%edx
  802959:	73 6d                	jae    8029c8 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80295b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80295f:	74 06                	je     802967 <insert_sorted_allocList+0x1f0>
  802961:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802965:	75 14                	jne    80297b <insert_sorted_allocList+0x204>
  802967:	83 ec 04             	sub    $0x4,%esp
  80296a:	68 98 47 80 00       	push   $0x804798
  80296f:	6a 7f                	push   $0x7f
  802971:	68 23 47 80 00       	push   $0x804723
  802976:	e8 5c df ff ff       	call   8008d7 <_panic>
  80297b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297e:	8b 10                	mov    (%eax),%edx
  802980:	8b 45 08             	mov    0x8(%ebp),%eax
  802983:	89 10                	mov    %edx,(%eax)
  802985:	8b 45 08             	mov    0x8(%ebp),%eax
  802988:	8b 00                	mov    (%eax),%eax
  80298a:	85 c0                	test   %eax,%eax
  80298c:	74 0b                	je     802999 <insert_sorted_allocList+0x222>
  80298e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802991:	8b 00                	mov    (%eax),%eax
  802993:	8b 55 08             	mov    0x8(%ebp),%edx
  802996:	89 50 04             	mov    %edx,0x4(%eax)
  802999:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299c:	8b 55 08             	mov    0x8(%ebp),%edx
  80299f:	89 10                	mov    %edx,(%eax)
  8029a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029a7:	89 50 04             	mov    %edx,0x4(%eax)
  8029aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ad:	8b 00                	mov    (%eax),%eax
  8029af:	85 c0                	test   %eax,%eax
  8029b1:	75 08                	jne    8029bb <insert_sorted_allocList+0x244>
  8029b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b6:	a3 44 50 80 00       	mov    %eax,0x805044
  8029bb:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029c0:	40                   	inc    %eax
  8029c1:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8029c6:	eb 39                	jmp    802a01 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8029c8:	a1 48 50 80 00       	mov    0x805048,%eax
  8029cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029d4:	74 07                	je     8029dd <insert_sorted_allocList+0x266>
  8029d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d9:	8b 00                	mov    (%eax),%eax
  8029db:	eb 05                	jmp    8029e2 <insert_sorted_allocList+0x26b>
  8029dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8029e2:	a3 48 50 80 00       	mov    %eax,0x805048
  8029e7:	a1 48 50 80 00       	mov    0x805048,%eax
  8029ec:	85 c0                	test   %eax,%eax
  8029ee:	0f 85 3f ff ff ff    	jne    802933 <insert_sorted_allocList+0x1bc>
  8029f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029f8:	0f 85 35 ff ff ff    	jne    802933 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8029fe:	eb 01                	jmp    802a01 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802a00:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802a01:	90                   	nop
  802a02:	c9                   	leave  
  802a03:	c3                   	ret    

00802a04 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802a04:	55                   	push   %ebp
  802a05:	89 e5                	mov    %esp,%ebp
  802a07:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802a0a:	a1 38 51 80 00       	mov    0x805138,%eax
  802a0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a12:	e9 85 01 00 00       	jmp    802b9c <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1a:	8b 40 0c             	mov    0xc(%eax),%eax
  802a1d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a20:	0f 82 6e 01 00 00    	jb     802b94 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802a26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a29:	8b 40 0c             	mov    0xc(%eax),%eax
  802a2c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a2f:	0f 85 8a 00 00 00    	jne    802abf <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802a35:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a39:	75 17                	jne    802a52 <alloc_block_FF+0x4e>
  802a3b:	83 ec 04             	sub    $0x4,%esp
  802a3e:	68 cc 47 80 00       	push   $0x8047cc
  802a43:	68 93 00 00 00       	push   $0x93
  802a48:	68 23 47 80 00       	push   $0x804723
  802a4d:	e8 85 de ff ff       	call   8008d7 <_panic>
  802a52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a55:	8b 00                	mov    (%eax),%eax
  802a57:	85 c0                	test   %eax,%eax
  802a59:	74 10                	je     802a6b <alloc_block_FF+0x67>
  802a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5e:	8b 00                	mov    (%eax),%eax
  802a60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a63:	8b 52 04             	mov    0x4(%edx),%edx
  802a66:	89 50 04             	mov    %edx,0x4(%eax)
  802a69:	eb 0b                	jmp    802a76 <alloc_block_FF+0x72>
  802a6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6e:	8b 40 04             	mov    0x4(%eax),%eax
  802a71:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a79:	8b 40 04             	mov    0x4(%eax),%eax
  802a7c:	85 c0                	test   %eax,%eax
  802a7e:	74 0f                	je     802a8f <alloc_block_FF+0x8b>
  802a80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a83:	8b 40 04             	mov    0x4(%eax),%eax
  802a86:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a89:	8b 12                	mov    (%edx),%edx
  802a8b:	89 10                	mov    %edx,(%eax)
  802a8d:	eb 0a                	jmp    802a99 <alloc_block_FF+0x95>
  802a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a92:	8b 00                	mov    (%eax),%eax
  802a94:	a3 38 51 80 00       	mov    %eax,0x805138
  802a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aac:	a1 44 51 80 00       	mov    0x805144,%eax
  802ab1:	48                   	dec    %eax
  802ab2:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aba:	e9 10 01 00 00       	jmp    802bcf <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac2:	8b 40 0c             	mov    0xc(%eax),%eax
  802ac5:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ac8:	0f 86 c6 00 00 00    	jbe    802b94 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802ace:	a1 48 51 80 00       	mov    0x805148,%eax
  802ad3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad9:	8b 50 08             	mov    0x8(%eax),%edx
  802adc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802adf:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802ae2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae5:	8b 55 08             	mov    0x8(%ebp),%edx
  802ae8:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802aeb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802aef:	75 17                	jne    802b08 <alloc_block_FF+0x104>
  802af1:	83 ec 04             	sub    $0x4,%esp
  802af4:	68 cc 47 80 00       	push   $0x8047cc
  802af9:	68 9b 00 00 00       	push   $0x9b
  802afe:	68 23 47 80 00       	push   $0x804723
  802b03:	e8 cf dd ff ff       	call   8008d7 <_panic>
  802b08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b0b:	8b 00                	mov    (%eax),%eax
  802b0d:	85 c0                	test   %eax,%eax
  802b0f:	74 10                	je     802b21 <alloc_block_FF+0x11d>
  802b11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b14:	8b 00                	mov    (%eax),%eax
  802b16:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b19:	8b 52 04             	mov    0x4(%edx),%edx
  802b1c:	89 50 04             	mov    %edx,0x4(%eax)
  802b1f:	eb 0b                	jmp    802b2c <alloc_block_FF+0x128>
  802b21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b24:	8b 40 04             	mov    0x4(%eax),%eax
  802b27:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2f:	8b 40 04             	mov    0x4(%eax),%eax
  802b32:	85 c0                	test   %eax,%eax
  802b34:	74 0f                	je     802b45 <alloc_block_FF+0x141>
  802b36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b39:	8b 40 04             	mov    0x4(%eax),%eax
  802b3c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b3f:	8b 12                	mov    (%edx),%edx
  802b41:	89 10                	mov    %edx,(%eax)
  802b43:	eb 0a                	jmp    802b4f <alloc_block_FF+0x14b>
  802b45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b48:	8b 00                	mov    (%eax),%eax
  802b4a:	a3 48 51 80 00       	mov    %eax,0x805148
  802b4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b52:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b5b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b62:	a1 54 51 80 00       	mov    0x805154,%eax
  802b67:	48                   	dec    %eax
  802b68:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802b6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b70:	8b 50 08             	mov    0x8(%eax),%edx
  802b73:	8b 45 08             	mov    0x8(%ebp),%eax
  802b76:	01 c2                	add    %eax,%edx
  802b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7b:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b81:	8b 40 0c             	mov    0xc(%eax),%eax
  802b84:	2b 45 08             	sub    0x8(%ebp),%eax
  802b87:	89 c2                	mov    %eax,%edx
  802b89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8c:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802b8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b92:	eb 3b                	jmp    802bcf <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802b94:	a1 40 51 80 00       	mov    0x805140,%eax
  802b99:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b9c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ba0:	74 07                	je     802ba9 <alloc_block_FF+0x1a5>
  802ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba5:	8b 00                	mov    (%eax),%eax
  802ba7:	eb 05                	jmp    802bae <alloc_block_FF+0x1aa>
  802ba9:	b8 00 00 00 00       	mov    $0x0,%eax
  802bae:	a3 40 51 80 00       	mov    %eax,0x805140
  802bb3:	a1 40 51 80 00       	mov    0x805140,%eax
  802bb8:	85 c0                	test   %eax,%eax
  802bba:	0f 85 57 fe ff ff    	jne    802a17 <alloc_block_FF+0x13>
  802bc0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bc4:	0f 85 4d fe ff ff    	jne    802a17 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802bca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bcf:	c9                   	leave  
  802bd0:	c3                   	ret    

00802bd1 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802bd1:	55                   	push   %ebp
  802bd2:	89 e5                	mov    %esp,%ebp
  802bd4:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802bd7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802bde:	a1 38 51 80 00       	mov    0x805138,%eax
  802be3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802be6:	e9 df 00 00 00       	jmp    802cca <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802beb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bee:	8b 40 0c             	mov    0xc(%eax),%eax
  802bf1:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bf4:	0f 82 c8 00 00 00    	jb     802cc2 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfd:	8b 40 0c             	mov    0xc(%eax),%eax
  802c00:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c03:	0f 85 8a 00 00 00    	jne    802c93 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802c09:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c0d:	75 17                	jne    802c26 <alloc_block_BF+0x55>
  802c0f:	83 ec 04             	sub    $0x4,%esp
  802c12:	68 cc 47 80 00       	push   $0x8047cc
  802c17:	68 b7 00 00 00       	push   $0xb7
  802c1c:	68 23 47 80 00       	push   $0x804723
  802c21:	e8 b1 dc ff ff       	call   8008d7 <_panic>
  802c26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c29:	8b 00                	mov    (%eax),%eax
  802c2b:	85 c0                	test   %eax,%eax
  802c2d:	74 10                	je     802c3f <alloc_block_BF+0x6e>
  802c2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c32:	8b 00                	mov    (%eax),%eax
  802c34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c37:	8b 52 04             	mov    0x4(%edx),%edx
  802c3a:	89 50 04             	mov    %edx,0x4(%eax)
  802c3d:	eb 0b                	jmp    802c4a <alloc_block_BF+0x79>
  802c3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c42:	8b 40 04             	mov    0x4(%eax),%eax
  802c45:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4d:	8b 40 04             	mov    0x4(%eax),%eax
  802c50:	85 c0                	test   %eax,%eax
  802c52:	74 0f                	je     802c63 <alloc_block_BF+0x92>
  802c54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c57:	8b 40 04             	mov    0x4(%eax),%eax
  802c5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c5d:	8b 12                	mov    (%edx),%edx
  802c5f:	89 10                	mov    %edx,(%eax)
  802c61:	eb 0a                	jmp    802c6d <alloc_block_BF+0x9c>
  802c63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c66:	8b 00                	mov    (%eax),%eax
  802c68:	a3 38 51 80 00       	mov    %eax,0x805138
  802c6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c70:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c79:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c80:	a1 44 51 80 00       	mov    0x805144,%eax
  802c85:	48                   	dec    %eax
  802c86:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802c8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8e:	e9 4d 01 00 00       	jmp    802de0 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c96:	8b 40 0c             	mov    0xc(%eax),%eax
  802c99:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c9c:	76 24                	jbe    802cc2 <alloc_block_BF+0xf1>
  802c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ca4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802ca7:	73 19                	jae    802cc2 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802ca9:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb3:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb6:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802cb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbc:	8b 40 08             	mov    0x8(%eax),%eax
  802cbf:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802cc2:	a1 40 51 80 00       	mov    0x805140,%eax
  802cc7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cce:	74 07                	je     802cd7 <alloc_block_BF+0x106>
  802cd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd3:	8b 00                	mov    (%eax),%eax
  802cd5:	eb 05                	jmp    802cdc <alloc_block_BF+0x10b>
  802cd7:	b8 00 00 00 00       	mov    $0x0,%eax
  802cdc:	a3 40 51 80 00       	mov    %eax,0x805140
  802ce1:	a1 40 51 80 00       	mov    0x805140,%eax
  802ce6:	85 c0                	test   %eax,%eax
  802ce8:	0f 85 fd fe ff ff    	jne    802beb <alloc_block_BF+0x1a>
  802cee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cf2:	0f 85 f3 fe ff ff    	jne    802beb <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802cf8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802cfc:	0f 84 d9 00 00 00    	je     802ddb <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d02:	a1 48 51 80 00       	mov    0x805148,%eax
  802d07:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802d0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d0d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d10:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802d13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d16:	8b 55 08             	mov    0x8(%ebp),%edx
  802d19:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802d1c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802d20:	75 17                	jne    802d39 <alloc_block_BF+0x168>
  802d22:	83 ec 04             	sub    $0x4,%esp
  802d25:	68 cc 47 80 00       	push   $0x8047cc
  802d2a:	68 c7 00 00 00       	push   $0xc7
  802d2f:	68 23 47 80 00       	push   $0x804723
  802d34:	e8 9e db ff ff       	call   8008d7 <_panic>
  802d39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d3c:	8b 00                	mov    (%eax),%eax
  802d3e:	85 c0                	test   %eax,%eax
  802d40:	74 10                	je     802d52 <alloc_block_BF+0x181>
  802d42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d45:	8b 00                	mov    (%eax),%eax
  802d47:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d4a:	8b 52 04             	mov    0x4(%edx),%edx
  802d4d:	89 50 04             	mov    %edx,0x4(%eax)
  802d50:	eb 0b                	jmp    802d5d <alloc_block_BF+0x18c>
  802d52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d55:	8b 40 04             	mov    0x4(%eax),%eax
  802d58:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d60:	8b 40 04             	mov    0x4(%eax),%eax
  802d63:	85 c0                	test   %eax,%eax
  802d65:	74 0f                	je     802d76 <alloc_block_BF+0x1a5>
  802d67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d6a:	8b 40 04             	mov    0x4(%eax),%eax
  802d6d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d70:	8b 12                	mov    (%edx),%edx
  802d72:	89 10                	mov    %edx,(%eax)
  802d74:	eb 0a                	jmp    802d80 <alloc_block_BF+0x1af>
  802d76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d79:	8b 00                	mov    (%eax),%eax
  802d7b:	a3 48 51 80 00       	mov    %eax,0x805148
  802d80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d83:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d8c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d93:	a1 54 51 80 00       	mov    0x805154,%eax
  802d98:	48                   	dec    %eax
  802d99:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802d9e:	83 ec 08             	sub    $0x8,%esp
  802da1:	ff 75 ec             	pushl  -0x14(%ebp)
  802da4:	68 38 51 80 00       	push   $0x805138
  802da9:	e8 71 f9 ff ff       	call   80271f <find_block>
  802dae:	83 c4 10             	add    $0x10,%esp
  802db1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802db4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802db7:	8b 50 08             	mov    0x8(%eax),%edx
  802dba:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbd:	01 c2                	add    %eax,%edx
  802dbf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dc2:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802dc5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dc8:	8b 40 0c             	mov    0xc(%eax),%eax
  802dcb:	2b 45 08             	sub    0x8(%ebp),%eax
  802dce:	89 c2                	mov    %eax,%edx
  802dd0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dd3:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802dd6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dd9:	eb 05                	jmp    802de0 <alloc_block_BF+0x20f>
	}
	return NULL;
  802ddb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802de0:	c9                   	leave  
  802de1:	c3                   	ret    

00802de2 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802de2:	55                   	push   %ebp
  802de3:	89 e5                	mov    %esp,%ebp
  802de5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802de8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802ded:	85 c0                	test   %eax,%eax
  802def:	0f 85 de 01 00 00    	jne    802fd3 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802df5:	a1 38 51 80 00       	mov    0x805138,%eax
  802dfa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dfd:	e9 9e 01 00 00       	jmp    802fa0 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802e02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e05:	8b 40 0c             	mov    0xc(%eax),%eax
  802e08:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e0b:	0f 82 87 01 00 00    	jb     802f98 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802e11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e14:	8b 40 0c             	mov    0xc(%eax),%eax
  802e17:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e1a:	0f 85 95 00 00 00    	jne    802eb5 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802e20:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e24:	75 17                	jne    802e3d <alloc_block_NF+0x5b>
  802e26:	83 ec 04             	sub    $0x4,%esp
  802e29:	68 cc 47 80 00       	push   $0x8047cc
  802e2e:	68 e0 00 00 00       	push   $0xe0
  802e33:	68 23 47 80 00       	push   $0x804723
  802e38:	e8 9a da ff ff       	call   8008d7 <_panic>
  802e3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e40:	8b 00                	mov    (%eax),%eax
  802e42:	85 c0                	test   %eax,%eax
  802e44:	74 10                	je     802e56 <alloc_block_NF+0x74>
  802e46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e49:	8b 00                	mov    (%eax),%eax
  802e4b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e4e:	8b 52 04             	mov    0x4(%edx),%edx
  802e51:	89 50 04             	mov    %edx,0x4(%eax)
  802e54:	eb 0b                	jmp    802e61 <alloc_block_NF+0x7f>
  802e56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e59:	8b 40 04             	mov    0x4(%eax),%eax
  802e5c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e64:	8b 40 04             	mov    0x4(%eax),%eax
  802e67:	85 c0                	test   %eax,%eax
  802e69:	74 0f                	je     802e7a <alloc_block_NF+0x98>
  802e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6e:	8b 40 04             	mov    0x4(%eax),%eax
  802e71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e74:	8b 12                	mov    (%edx),%edx
  802e76:	89 10                	mov    %edx,(%eax)
  802e78:	eb 0a                	jmp    802e84 <alloc_block_NF+0xa2>
  802e7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7d:	8b 00                	mov    (%eax),%eax
  802e7f:	a3 38 51 80 00       	mov    %eax,0x805138
  802e84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e87:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e90:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e97:	a1 44 51 80 00       	mov    0x805144,%eax
  802e9c:	48                   	dec    %eax
  802e9d:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802ea2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea5:	8b 40 08             	mov    0x8(%eax),%eax
  802ea8:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   return  point;
  802ead:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb0:	e9 f8 04 00 00       	jmp    8033ad <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802eb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb8:	8b 40 0c             	mov    0xc(%eax),%eax
  802ebb:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ebe:	0f 86 d4 00 00 00    	jbe    802f98 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802ec4:	a1 48 51 80 00       	mov    0x805148,%eax
  802ec9:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802ecc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecf:	8b 50 08             	mov    0x8(%eax),%edx
  802ed2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed5:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802ed8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802edb:	8b 55 08             	mov    0x8(%ebp),%edx
  802ede:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802ee1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ee5:	75 17                	jne    802efe <alloc_block_NF+0x11c>
  802ee7:	83 ec 04             	sub    $0x4,%esp
  802eea:	68 cc 47 80 00       	push   $0x8047cc
  802eef:	68 e9 00 00 00       	push   $0xe9
  802ef4:	68 23 47 80 00       	push   $0x804723
  802ef9:	e8 d9 d9 ff ff       	call   8008d7 <_panic>
  802efe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f01:	8b 00                	mov    (%eax),%eax
  802f03:	85 c0                	test   %eax,%eax
  802f05:	74 10                	je     802f17 <alloc_block_NF+0x135>
  802f07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f0a:	8b 00                	mov    (%eax),%eax
  802f0c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f0f:	8b 52 04             	mov    0x4(%edx),%edx
  802f12:	89 50 04             	mov    %edx,0x4(%eax)
  802f15:	eb 0b                	jmp    802f22 <alloc_block_NF+0x140>
  802f17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f1a:	8b 40 04             	mov    0x4(%eax),%eax
  802f1d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f25:	8b 40 04             	mov    0x4(%eax),%eax
  802f28:	85 c0                	test   %eax,%eax
  802f2a:	74 0f                	je     802f3b <alloc_block_NF+0x159>
  802f2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f2f:	8b 40 04             	mov    0x4(%eax),%eax
  802f32:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f35:	8b 12                	mov    (%edx),%edx
  802f37:	89 10                	mov    %edx,(%eax)
  802f39:	eb 0a                	jmp    802f45 <alloc_block_NF+0x163>
  802f3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f3e:	8b 00                	mov    (%eax),%eax
  802f40:	a3 48 51 80 00       	mov    %eax,0x805148
  802f45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f48:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f51:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f58:	a1 54 51 80 00       	mov    0x805154,%eax
  802f5d:	48                   	dec    %eax
  802f5e:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802f63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f66:	8b 40 08             	mov    0x8(%eax),%eax
  802f69:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   point->sva += size;
  802f6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f71:	8b 50 08             	mov    0x8(%eax),%edx
  802f74:	8b 45 08             	mov    0x8(%ebp),%eax
  802f77:	01 c2                	add    %eax,%edx
  802f79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7c:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802f7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f82:	8b 40 0c             	mov    0xc(%eax),%eax
  802f85:	2b 45 08             	sub    0x8(%ebp),%eax
  802f88:	89 c2                	mov    %eax,%edx
  802f8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8d:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802f90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f93:	e9 15 04 00 00       	jmp    8033ad <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802f98:	a1 40 51 80 00       	mov    0x805140,%eax
  802f9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fa0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fa4:	74 07                	je     802fad <alloc_block_NF+0x1cb>
  802fa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa9:	8b 00                	mov    (%eax),%eax
  802fab:	eb 05                	jmp    802fb2 <alloc_block_NF+0x1d0>
  802fad:	b8 00 00 00 00       	mov    $0x0,%eax
  802fb2:	a3 40 51 80 00       	mov    %eax,0x805140
  802fb7:	a1 40 51 80 00       	mov    0x805140,%eax
  802fbc:	85 c0                	test   %eax,%eax
  802fbe:	0f 85 3e fe ff ff    	jne    802e02 <alloc_block_NF+0x20>
  802fc4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fc8:	0f 85 34 fe ff ff    	jne    802e02 <alloc_block_NF+0x20>
  802fce:	e9 d5 03 00 00       	jmp    8033a8 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802fd3:	a1 38 51 80 00       	mov    0x805138,%eax
  802fd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fdb:	e9 b1 01 00 00       	jmp    803191 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802fe0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe3:	8b 50 08             	mov    0x8(%eax),%edx
  802fe6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802feb:	39 c2                	cmp    %eax,%edx
  802fed:	0f 82 96 01 00 00    	jb     803189 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802ff3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ff9:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ffc:	0f 82 87 01 00 00    	jb     803189 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  803002:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803005:	8b 40 0c             	mov    0xc(%eax),%eax
  803008:	3b 45 08             	cmp    0x8(%ebp),%eax
  80300b:	0f 85 95 00 00 00    	jne    8030a6 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803011:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803015:	75 17                	jne    80302e <alloc_block_NF+0x24c>
  803017:	83 ec 04             	sub    $0x4,%esp
  80301a:	68 cc 47 80 00       	push   $0x8047cc
  80301f:	68 fc 00 00 00       	push   $0xfc
  803024:	68 23 47 80 00       	push   $0x804723
  803029:	e8 a9 d8 ff ff       	call   8008d7 <_panic>
  80302e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803031:	8b 00                	mov    (%eax),%eax
  803033:	85 c0                	test   %eax,%eax
  803035:	74 10                	je     803047 <alloc_block_NF+0x265>
  803037:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303a:	8b 00                	mov    (%eax),%eax
  80303c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80303f:	8b 52 04             	mov    0x4(%edx),%edx
  803042:	89 50 04             	mov    %edx,0x4(%eax)
  803045:	eb 0b                	jmp    803052 <alloc_block_NF+0x270>
  803047:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304a:	8b 40 04             	mov    0x4(%eax),%eax
  80304d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803052:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803055:	8b 40 04             	mov    0x4(%eax),%eax
  803058:	85 c0                	test   %eax,%eax
  80305a:	74 0f                	je     80306b <alloc_block_NF+0x289>
  80305c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305f:	8b 40 04             	mov    0x4(%eax),%eax
  803062:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803065:	8b 12                	mov    (%edx),%edx
  803067:	89 10                	mov    %edx,(%eax)
  803069:	eb 0a                	jmp    803075 <alloc_block_NF+0x293>
  80306b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306e:	8b 00                	mov    (%eax),%eax
  803070:	a3 38 51 80 00       	mov    %eax,0x805138
  803075:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803078:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80307e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803081:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803088:	a1 44 51 80 00       	mov    0x805144,%eax
  80308d:	48                   	dec    %eax
  80308e:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803093:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803096:	8b 40 08             	mov    0x8(%eax),%eax
  803099:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  80309e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a1:	e9 07 03 00 00       	jmp    8033ad <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8030a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8030ac:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030af:	0f 86 d4 00 00 00    	jbe    803189 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8030b5:	a1 48 51 80 00       	mov    0x805148,%eax
  8030ba:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8030bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c0:	8b 50 08             	mov    0x8(%eax),%edx
  8030c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c6:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8030c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8030cf:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8030d2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030d6:	75 17                	jne    8030ef <alloc_block_NF+0x30d>
  8030d8:	83 ec 04             	sub    $0x4,%esp
  8030db:	68 cc 47 80 00       	push   $0x8047cc
  8030e0:	68 04 01 00 00       	push   $0x104
  8030e5:	68 23 47 80 00       	push   $0x804723
  8030ea:	e8 e8 d7 ff ff       	call   8008d7 <_panic>
  8030ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f2:	8b 00                	mov    (%eax),%eax
  8030f4:	85 c0                	test   %eax,%eax
  8030f6:	74 10                	je     803108 <alloc_block_NF+0x326>
  8030f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030fb:	8b 00                	mov    (%eax),%eax
  8030fd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803100:	8b 52 04             	mov    0x4(%edx),%edx
  803103:	89 50 04             	mov    %edx,0x4(%eax)
  803106:	eb 0b                	jmp    803113 <alloc_block_NF+0x331>
  803108:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80310b:	8b 40 04             	mov    0x4(%eax),%eax
  80310e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803113:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803116:	8b 40 04             	mov    0x4(%eax),%eax
  803119:	85 c0                	test   %eax,%eax
  80311b:	74 0f                	je     80312c <alloc_block_NF+0x34a>
  80311d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803120:	8b 40 04             	mov    0x4(%eax),%eax
  803123:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803126:	8b 12                	mov    (%edx),%edx
  803128:	89 10                	mov    %edx,(%eax)
  80312a:	eb 0a                	jmp    803136 <alloc_block_NF+0x354>
  80312c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80312f:	8b 00                	mov    (%eax),%eax
  803131:	a3 48 51 80 00       	mov    %eax,0x805148
  803136:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803139:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80313f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803142:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803149:	a1 54 51 80 00       	mov    0x805154,%eax
  80314e:	48                   	dec    %eax
  80314f:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803154:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803157:	8b 40 08             	mov    0x8(%eax),%eax
  80315a:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  80315f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803162:	8b 50 08             	mov    0x8(%eax),%edx
  803165:	8b 45 08             	mov    0x8(%ebp),%eax
  803168:	01 c2                	add    %eax,%edx
  80316a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316d:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803170:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803173:	8b 40 0c             	mov    0xc(%eax),%eax
  803176:	2b 45 08             	sub    0x8(%ebp),%eax
  803179:	89 c2                	mov    %eax,%edx
  80317b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317e:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803181:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803184:	e9 24 02 00 00       	jmp    8033ad <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803189:	a1 40 51 80 00       	mov    0x805140,%eax
  80318e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803191:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803195:	74 07                	je     80319e <alloc_block_NF+0x3bc>
  803197:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319a:	8b 00                	mov    (%eax),%eax
  80319c:	eb 05                	jmp    8031a3 <alloc_block_NF+0x3c1>
  80319e:	b8 00 00 00 00       	mov    $0x0,%eax
  8031a3:	a3 40 51 80 00       	mov    %eax,0x805140
  8031a8:	a1 40 51 80 00       	mov    0x805140,%eax
  8031ad:	85 c0                	test   %eax,%eax
  8031af:	0f 85 2b fe ff ff    	jne    802fe0 <alloc_block_NF+0x1fe>
  8031b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031b9:	0f 85 21 fe ff ff    	jne    802fe0 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8031bf:	a1 38 51 80 00       	mov    0x805138,%eax
  8031c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031c7:	e9 ae 01 00 00       	jmp    80337a <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8031cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031cf:	8b 50 08             	mov    0x8(%eax),%edx
  8031d2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031d7:	39 c2                	cmp    %eax,%edx
  8031d9:	0f 83 93 01 00 00    	jae    803372 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  8031df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8031e5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031e8:	0f 82 84 01 00 00    	jb     803372 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  8031ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8031f4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031f7:	0f 85 95 00 00 00    	jne    803292 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8031fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803201:	75 17                	jne    80321a <alloc_block_NF+0x438>
  803203:	83 ec 04             	sub    $0x4,%esp
  803206:	68 cc 47 80 00       	push   $0x8047cc
  80320b:	68 14 01 00 00       	push   $0x114
  803210:	68 23 47 80 00       	push   $0x804723
  803215:	e8 bd d6 ff ff       	call   8008d7 <_panic>
  80321a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80321d:	8b 00                	mov    (%eax),%eax
  80321f:	85 c0                	test   %eax,%eax
  803221:	74 10                	je     803233 <alloc_block_NF+0x451>
  803223:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803226:	8b 00                	mov    (%eax),%eax
  803228:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80322b:	8b 52 04             	mov    0x4(%edx),%edx
  80322e:	89 50 04             	mov    %edx,0x4(%eax)
  803231:	eb 0b                	jmp    80323e <alloc_block_NF+0x45c>
  803233:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803236:	8b 40 04             	mov    0x4(%eax),%eax
  803239:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80323e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803241:	8b 40 04             	mov    0x4(%eax),%eax
  803244:	85 c0                	test   %eax,%eax
  803246:	74 0f                	je     803257 <alloc_block_NF+0x475>
  803248:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324b:	8b 40 04             	mov    0x4(%eax),%eax
  80324e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803251:	8b 12                	mov    (%edx),%edx
  803253:	89 10                	mov    %edx,(%eax)
  803255:	eb 0a                	jmp    803261 <alloc_block_NF+0x47f>
  803257:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325a:	8b 00                	mov    (%eax),%eax
  80325c:	a3 38 51 80 00       	mov    %eax,0x805138
  803261:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803264:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80326a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803274:	a1 44 51 80 00       	mov    0x805144,%eax
  803279:	48                   	dec    %eax
  80327a:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  80327f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803282:	8b 40 08             	mov    0x8(%eax),%eax
  803285:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  80328a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328d:	e9 1b 01 00 00       	jmp    8033ad <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803292:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803295:	8b 40 0c             	mov    0xc(%eax),%eax
  803298:	3b 45 08             	cmp    0x8(%ebp),%eax
  80329b:	0f 86 d1 00 00 00    	jbe    803372 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8032a1:	a1 48 51 80 00       	mov    0x805148,%eax
  8032a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  8032a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ac:	8b 50 08             	mov    0x8(%eax),%edx
  8032af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032b2:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8032b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8032bb:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8032be:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8032c2:	75 17                	jne    8032db <alloc_block_NF+0x4f9>
  8032c4:	83 ec 04             	sub    $0x4,%esp
  8032c7:	68 cc 47 80 00       	push   $0x8047cc
  8032cc:	68 1c 01 00 00       	push   $0x11c
  8032d1:	68 23 47 80 00       	push   $0x804723
  8032d6:	e8 fc d5 ff ff       	call   8008d7 <_panic>
  8032db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032de:	8b 00                	mov    (%eax),%eax
  8032e0:	85 c0                	test   %eax,%eax
  8032e2:	74 10                	je     8032f4 <alloc_block_NF+0x512>
  8032e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032e7:	8b 00                	mov    (%eax),%eax
  8032e9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8032ec:	8b 52 04             	mov    0x4(%edx),%edx
  8032ef:	89 50 04             	mov    %edx,0x4(%eax)
  8032f2:	eb 0b                	jmp    8032ff <alloc_block_NF+0x51d>
  8032f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032f7:	8b 40 04             	mov    0x4(%eax),%eax
  8032fa:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803302:	8b 40 04             	mov    0x4(%eax),%eax
  803305:	85 c0                	test   %eax,%eax
  803307:	74 0f                	je     803318 <alloc_block_NF+0x536>
  803309:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80330c:	8b 40 04             	mov    0x4(%eax),%eax
  80330f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803312:	8b 12                	mov    (%edx),%edx
  803314:	89 10                	mov    %edx,(%eax)
  803316:	eb 0a                	jmp    803322 <alloc_block_NF+0x540>
  803318:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80331b:	8b 00                	mov    (%eax),%eax
  80331d:	a3 48 51 80 00       	mov    %eax,0x805148
  803322:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803325:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80332b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80332e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803335:	a1 54 51 80 00       	mov    0x805154,%eax
  80333a:	48                   	dec    %eax
  80333b:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803340:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803343:	8b 40 08             	mov    0x8(%eax),%eax
  803346:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  80334b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80334e:	8b 50 08             	mov    0x8(%eax),%edx
  803351:	8b 45 08             	mov    0x8(%ebp),%eax
  803354:	01 c2                	add    %eax,%edx
  803356:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803359:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80335c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335f:	8b 40 0c             	mov    0xc(%eax),%eax
  803362:	2b 45 08             	sub    0x8(%ebp),%eax
  803365:	89 c2                	mov    %eax,%edx
  803367:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336a:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  80336d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803370:	eb 3b                	jmp    8033ad <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803372:	a1 40 51 80 00       	mov    0x805140,%eax
  803377:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80337a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80337e:	74 07                	je     803387 <alloc_block_NF+0x5a5>
  803380:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803383:	8b 00                	mov    (%eax),%eax
  803385:	eb 05                	jmp    80338c <alloc_block_NF+0x5aa>
  803387:	b8 00 00 00 00       	mov    $0x0,%eax
  80338c:	a3 40 51 80 00       	mov    %eax,0x805140
  803391:	a1 40 51 80 00       	mov    0x805140,%eax
  803396:	85 c0                	test   %eax,%eax
  803398:	0f 85 2e fe ff ff    	jne    8031cc <alloc_block_NF+0x3ea>
  80339e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033a2:	0f 85 24 fe ff ff    	jne    8031cc <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  8033a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033ad:	c9                   	leave  
  8033ae:	c3                   	ret    

008033af <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8033af:	55                   	push   %ebp
  8033b0:	89 e5                	mov    %esp,%ebp
  8033b2:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  8033b5:	a1 38 51 80 00       	mov    0x805138,%eax
  8033ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  8033bd:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8033c2:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  8033c5:	a1 38 51 80 00       	mov    0x805138,%eax
  8033ca:	85 c0                	test   %eax,%eax
  8033cc:	74 14                	je     8033e2 <insert_sorted_with_merge_freeList+0x33>
  8033ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d1:	8b 50 08             	mov    0x8(%eax),%edx
  8033d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033d7:	8b 40 08             	mov    0x8(%eax),%eax
  8033da:	39 c2                	cmp    %eax,%edx
  8033dc:	0f 87 9b 01 00 00    	ja     80357d <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  8033e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033e6:	75 17                	jne    8033ff <insert_sorted_with_merge_freeList+0x50>
  8033e8:	83 ec 04             	sub    $0x4,%esp
  8033eb:	68 00 47 80 00       	push   $0x804700
  8033f0:	68 38 01 00 00       	push   $0x138
  8033f5:	68 23 47 80 00       	push   $0x804723
  8033fa:	e8 d8 d4 ff ff       	call   8008d7 <_panic>
  8033ff:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803405:	8b 45 08             	mov    0x8(%ebp),%eax
  803408:	89 10                	mov    %edx,(%eax)
  80340a:	8b 45 08             	mov    0x8(%ebp),%eax
  80340d:	8b 00                	mov    (%eax),%eax
  80340f:	85 c0                	test   %eax,%eax
  803411:	74 0d                	je     803420 <insert_sorted_with_merge_freeList+0x71>
  803413:	a1 38 51 80 00       	mov    0x805138,%eax
  803418:	8b 55 08             	mov    0x8(%ebp),%edx
  80341b:	89 50 04             	mov    %edx,0x4(%eax)
  80341e:	eb 08                	jmp    803428 <insert_sorted_with_merge_freeList+0x79>
  803420:	8b 45 08             	mov    0x8(%ebp),%eax
  803423:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803428:	8b 45 08             	mov    0x8(%ebp),%eax
  80342b:	a3 38 51 80 00       	mov    %eax,0x805138
  803430:	8b 45 08             	mov    0x8(%ebp),%eax
  803433:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80343a:	a1 44 51 80 00       	mov    0x805144,%eax
  80343f:	40                   	inc    %eax
  803440:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803445:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803449:	0f 84 a8 06 00 00    	je     803af7 <insert_sorted_with_merge_freeList+0x748>
  80344f:	8b 45 08             	mov    0x8(%ebp),%eax
  803452:	8b 50 08             	mov    0x8(%eax),%edx
  803455:	8b 45 08             	mov    0x8(%ebp),%eax
  803458:	8b 40 0c             	mov    0xc(%eax),%eax
  80345b:	01 c2                	add    %eax,%edx
  80345d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803460:	8b 40 08             	mov    0x8(%eax),%eax
  803463:	39 c2                	cmp    %eax,%edx
  803465:	0f 85 8c 06 00 00    	jne    803af7 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  80346b:	8b 45 08             	mov    0x8(%ebp),%eax
  80346e:	8b 50 0c             	mov    0xc(%eax),%edx
  803471:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803474:	8b 40 0c             	mov    0xc(%eax),%eax
  803477:	01 c2                	add    %eax,%edx
  803479:	8b 45 08             	mov    0x8(%ebp),%eax
  80347c:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  80347f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803483:	75 17                	jne    80349c <insert_sorted_with_merge_freeList+0xed>
  803485:	83 ec 04             	sub    $0x4,%esp
  803488:	68 cc 47 80 00       	push   $0x8047cc
  80348d:	68 3c 01 00 00       	push   $0x13c
  803492:	68 23 47 80 00       	push   $0x804723
  803497:	e8 3b d4 ff ff       	call   8008d7 <_panic>
  80349c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80349f:	8b 00                	mov    (%eax),%eax
  8034a1:	85 c0                	test   %eax,%eax
  8034a3:	74 10                	je     8034b5 <insert_sorted_with_merge_freeList+0x106>
  8034a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034a8:	8b 00                	mov    (%eax),%eax
  8034aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034ad:	8b 52 04             	mov    0x4(%edx),%edx
  8034b0:	89 50 04             	mov    %edx,0x4(%eax)
  8034b3:	eb 0b                	jmp    8034c0 <insert_sorted_with_merge_freeList+0x111>
  8034b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034b8:	8b 40 04             	mov    0x4(%eax),%eax
  8034bb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034c3:	8b 40 04             	mov    0x4(%eax),%eax
  8034c6:	85 c0                	test   %eax,%eax
  8034c8:	74 0f                	je     8034d9 <insert_sorted_with_merge_freeList+0x12a>
  8034ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034cd:	8b 40 04             	mov    0x4(%eax),%eax
  8034d0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034d3:	8b 12                	mov    (%edx),%edx
  8034d5:	89 10                	mov    %edx,(%eax)
  8034d7:	eb 0a                	jmp    8034e3 <insert_sorted_with_merge_freeList+0x134>
  8034d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034dc:	8b 00                	mov    (%eax),%eax
  8034de:	a3 38 51 80 00       	mov    %eax,0x805138
  8034e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034ef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034f6:	a1 44 51 80 00       	mov    0x805144,%eax
  8034fb:	48                   	dec    %eax
  8034fc:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  803501:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803504:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  80350b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80350e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803515:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803519:	75 17                	jne    803532 <insert_sorted_with_merge_freeList+0x183>
  80351b:	83 ec 04             	sub    $0x4,%esp
  80351e:	68 00 47 80 00       	push   $0x804700
  803523:	68 3f 01 00 00       	push   $0x13f
  803528:	68 23 47 80 00       	push   $0x804723
  80352d:	e8 a5 d3 ff ff       	call   8008d7 <_panic>
  803532:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803538:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80353b:	89 10                	mov    %edx,(%eax)
  80353d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803540:	8b 00                	mov    (%eax),%eax
  803542:	85 c0                	test   %eax,%eax
  803544:	74 0d                	je     803553 <insert_sorted_with_merge_freeList+0x1a4>
  803546:	a1 48 51 80 00       	mov    0x805148,%eax
  80354b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80354e:	89 50 04             	mov    %edx,0x4(%eax)
  803551:	eb 08                	jmp    80355b <insert_sorted_with_merge_freeList+0x1ac>
  803553:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803556:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80355b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80355e:	a3 48 51 80 00       	mov    %eax,0x805148
  803563:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803566:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80356d:	a1 54 51 80 00       	mov    0x805154,%eax
  803572:	40                   	inc    %eax
  803573:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803578:	e9 7a 05 00 00       	jmp    803af7 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  80357d:	8b 45 08             	mov    0x8(%ebp),%eax
  803580:	8b 50 08             	mov    0x8(%eax),%edx
  803583:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803586:	8b 40 08             	mov    0x8(%eax),%eax
  803589:	39 c2                	cmp    %eax,%edx
  80358b:	0f 82 14 01 00 00    	jb     8036a5 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803591:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803594:	8b 50 08             	mov    0x8(%eax),%edx
  803597:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80359a:	8b 40 0c             	mov    0xc(%eax),%eax
  80359d:	01 c2                	add    %eax,%edx
  80359f:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a2:	8b 40 08             	mov    0x8(%eax),%eax
  8035a5:	39 c2                	cmp    %eax,%edx
  8035a7:	0f 85 90 00 00 00    	jne    80363d <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8035ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035b0:	8b 50 0c             	mov    0xc(%eax),%edx
  8035b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8035b9:	01 c2                	add    %eax,%edx
  8035bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035be:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  8035c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8035cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ce:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8035d5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035d9:	75 17                	jne    8035f2 <insert_sorted_with_merge_freeList+0x243>
  8035db:	83 ec 04             	sub    $0x4,%esp
  8035de:	68 00 47 80 00       	push   $0x804700
  8035e3:	68 49 01 00 00       	push   $0x149
  8035e8:	68 23 47 80 00       	push   $0x804723
  8035ed:	e8 e5 d2 ff ff       	call   8008d7 <_panic>
  8035f2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8035f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8035fb:	89 10                	mov    %edx,(%eax)
  8035fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803600:	8b 00                	mov    (%eax),%eax
  803602:	85 c0                	test   %eax,%eax
  803604:	74 0d                	je     803613 <insert_sorted_with_merge_freeList+0x264>
  803606:	a1 48 51 80 00       	mov    0x805148,%eax
  80360b:	8b 55 08             	mov    0x8(%ebp),%edx
  80360e:	89 50 04             	mov    %edx,0x4(%eax)
  803611:	eb 08                	jmp    80361b <insert_sorted_with_merge_freeList+0x26c>
  803613:	8b 45 08             	mov    0x8(%ebp),%eax
  803616:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80361b:	8b 45 08             	mov    0x8(%ebp),%eax
  80361e:	a3 48 51 80 00       	mov    %eax,0x805148
  803623:	8b 45 08             	mov    0x8(%ebp),%eax
  803626:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80362d:	a1 54 51 80 00       	mov    0x805154,%eax
  803632:	40                   	inc    %eax
  803633:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803638:	e9 bb 04 00 00       	jmp    803af8 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  80363d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803641:	75 17                	jne    80365a <insert_sorted_with_merge_freeList+0x2ab>
  803643:	83 ec 04             	sub    $0x4,%esp
  803646:	68 74 47 80 00       	push   $0x804774
  80364b:	68 4c 01 00 00       	push   $0x14c
  803650:	68 23 47 80 00       	push   $0x804723
  803655:	e8 7d d2 ff ff       	call   8008d7 <_panic>
  80365a:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803660:	8b 45 08             	mov    0x8(%ebp),%eax
  803663:	89 50 04             	mov    %edx,0x4(%eax)
  803666:	8b 45 08             	mov    0x8(%ebp),%eax
  803669:	8b 40 04             	mov    0x4(%eax),%eax
  80366c:	85 c0                	test   %eax,%eax
  80366e:	74 0c                	je     80367c <insert_sorted_with_merge_freeList+0x2cd>
  803670:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803675:	8b 55 08             	mov    0x8(%ebp),%edx
  803678:	89 10                	mov    %edx,(%eax)
  80367a:	eb 08                	jmp    803684 <insert_sorted_with_merge_freeList+0x2d5>
  80367c:	8b 45 08             	mov    0x8(%ebp),%eax
  80367f:	a3 38 51 80 00       	mov    %eax,0x805138
  803684:	8b 45 08             	mov    0x8(%ebp),%eax
  803687:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80368c:	8b 45 08             	mov    0x8(%ebp),%eax
  80368f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803695:	a1 44 51 80 00       	mov    0x805144,%eax
  80369a:	40                   	inc    %eax
  80369b:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8036a0:	e9 53 04 00 00       	jmp    803af8 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8036a5:	a1 38 51 80 00       	mov    0x805138,%eax
  8036aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036ad:	e9 15 04 00 00       	jmp    803ac7 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8036b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b5:	8b 00                	mov    (%eax),%eax
  8036b7:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8036ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8036bd:	8b 50 08             	mov    0x8(%eax),%edx
  8036c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c3:	8b 40 08             	mov    0x8(%eax),%eax
  8036c6:	39 c2                	cmp    %eax,%edx
  8036c8:	0f 86 f1 03 00 00    	jbe    803abf <insert_sorted_with_merge_freeList+0x710>
  8036ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d1:	8b 50 08             	mov    0x8(%eax),%edx
  8036d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036d7:	8b 40 08             	mov    0x8(%eax),%eax
  8036da:	39 c2                	cmp    %eax,%edx
  8036dc:	0f 83 dd 03 00 00    	jae    803abf <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8036e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e5:	8b 50 08             	mov    0x8(%eax),%edx
  8036e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036eb:	8b 40 0c             	mov    0xc(%eax),%eax
  8036ee:	01 c2                	add    %eax,%edx
  8036f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f3:	8b 40 08             	mov    0x8(%eax),%eax
  8036f6:	39 c2                	cmp    %eax,%edx
  8036f8:	0f 85 b9 01 00 00    	jne    8038b7 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8036fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803701:	8b 50 08             	mov    0x8(%eax),%edx
  803704:	8b 45 08             	mov    0x8(%ebp),%eax
  803707:	8b 40 0c             	mov    0xc(%eax),%eax
  80370a:	01 c2                	add    %eax,%edx
  80370c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80370f:	8b 40 08             	mov    0x8(%eax),%eax
  803712:	39 c2                	cmp    %eax,%edx
  803714:	0f 85 0d 01 00 00    	jne    803827 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  80371a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80371d:	8b 50 0c             	mov    0xc(%eax),%edx
  803720:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803723:	8b 40 0c             	mov    0xc(%eax),%eax
  803726:	01 c2                	add    %eax,%edx
  803728:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80372b:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80372e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803732:	75 17                	jne    80374b <insert_sorted_with_merge_freeList+0x39c>
  803734:	83 ec 04             	sub    $0x4,%esp
  803737:	68 cc 47 80 00       	push   $0x8047cc
  80373c:	68 5c 01 00 00       	push   $0x15c
  803741:	68 23 47 80 00       	push   $0x804723
  803746:	e8 8c d1 ff ff       	call   8008d7 <_panic>
  80374b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80374e:	8b 00                	mov    (%eax),%eax
  803750:	85 c0                	test   %eax,%eax
  803752:	74 10                	je     803764 <insert_sorted_with_merge_freeList+0x3b5>
  803754:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803757:	8b 00                	mov    (%eax),%eax
  803759:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80375c:	8b 52 04             	mov    0x4(%edx),%edx
  80375f:	89 50 04             	mov    %edx,0x4(%eax)
  803762:	eb 0b                	jmp    80376f <insert_sorted_with_merge_freeList+0x3c0>
  803764:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803767:	8b 40 04             	mov    0x4(%eax),%eax
  80376a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80376f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803772:	8b 40 04             	mov    0x4(%eax),%eax
  803775:	85 c0                	test   %eax,%eax
  803777:	74 0f                	je     803788 <insert_sorted_with_merge_freeList+0x3d9>
  803779:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80377c:	8b 40 04             	mov    0x4(%eax),%eax
  80377f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803782:	8b 12                	mov    (%edx),%edx
  803784:	89 10                	mov    %edx,(%eax)
  803786:	eb 0a                	jmp    803792 <insert_sorted_with_merge_freeList+0x3e3>
  803788:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80378b:	8b 00                	mov    (%eax),%eax
  80378d:	a3 38 51 80 00       	mov    %eax,0x805138
  803792:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803795:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80379b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80379e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037a5:	a1 44 51 80 00       	mov    0x805144,%eax
  8037aa:	48                   	dec    %eax
  8037ab:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8037b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037b3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8037ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037bd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8037c4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8037c8:	75 17                	jne    8037e1 <insert_sorted_with_merge_freeList+0x432>
  8037ca:	83 ec 04             	sub    $0x4,%esp
  8037cd:	68 00 47 80 00       	push   $0x804700
  8037d2:	68 5f 01 00 00       	push   $0x15f
  8037d7:	68 23 47 80 00       	push   $0x804723
  8037dc:	e8 f6 d0 ff ff       	call   8008d7 <_panic>
  8037e1:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8037e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037ea:	89 10                	mov    %edx,(%eax)
  8037ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037ef:	8b 00                	mov    (%eax),%eax
  8037f1:	85 c0                	test   %eax,%eax
  8037f3:	74 0d                	je     803802 <insert_sorted_with_merge_freeList+0x453>
  8037f5:	a1 48 51 80 00       	mov    0x805148,%eax
  8037fa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037fd:	89 50 04             	mov    %edx,0x4(%eax)
  803800:	eb 08                	jmp    80380a <insert_sorted_with_merge_freeList+0x45b>
  803802:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803805:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80380a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80380d:	a3 48 51 80 00       	mov    %eax,0x805148
  803812:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803815:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80381c:	a1 54 51 80 00       	mov    0x805154,%eax
  803821:	40                   	inc    %eax
  803822:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803827:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80382a:	8b 50 0c             	mov    0xc(%eax),%edx
  80382d:	8b 45 08             	mov    0x8(%ebp),%eax
  803830:	8b 40 0c             	mov    0xc(%eax),%eax
  803833:	01 c2                	add    %eax,%edx
  803835:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803838:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80383b:	8b 45 08             	mov    0x8(%ebp),%eax
  80383e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803845:	8b 45 08             	mov    0x8(%ebp),%eax
  803848:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80384f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803853:	75 17                	jne    80386c <insert_sorted_with_merge_freeList+0x4bd>
  803855:	83 ec 04             	sub    $0x4,%esp
  803858:	68 00 47 80 00       	push   $0x804700
  80385d:	68 64 01 00 00       	push   $0x164
  803862:	68 23 47 80 00       	push   $0x804723
  803867:	e8 6b d0 ff ff       	call   8008d7 <_panic>
  80386c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803872:	8b 45 08             	mov    0x8(%ebp),%eax
  803875:	89 10                	mov    %edx,(%eax)
  803877:	8b 45 08             	mov    0x8(%ebp),%eax
  80387a:	8b 00                	mov    (%eax),%eax
  80387c:	85 c0                	test   %eax,%eax
  80387e:	74 0d                	je     80388d <insert_sorted_with_merge_freeList+0x4de>
  803880:	a1 48 51 80 00       	mov    0x805148,%eax
  803885:	8b 55 08             	mov    0x8(%ebp),%edx
  803888:	89 50 04             	mov    %edx,0x4(%eax)
  80388b:	eb 08                	jmp    803895 <insert_sorted_with_merge_freeList+0x4e6>
  80388d:	8b 45 08             	mov    0x8(%ebp),%eax
  803890:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803895:	8b 45 08             	mov    0x8(%ebp),%eax
  803898:	a3 48 51 80 00       	mov    %eax,0x805148
  80389d:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038a7:	a1 54 51 80 00       	mov    0x805154,%eax
  8038ac:	40                   	inc    %eax
  8038ad:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8038b2:	e9 41 02 00 00       	jmp    803af8 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8038b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ba:	8b 50 08             	mov    0x8(%eax),%edx
  8038bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8038c3:	01 c2                	add    %eax,%edx
  8038c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038c8:	8b 40 08             	mov    0x8(%eax),%eax
  8038cb:	39 c2                	cmp    %eax,%edx
  8038cd:	0f 85 7c 01 00 00    	jne    803a4f <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8038d3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8038d7:	74 06                	je     8038df <insert_sorted_with_merge_freeList+0x530>
  8038d9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038dd:	75 17                	jne    8038f6 <insert_sorted_with_merge_freeList+0x547>
  8038df:	83 ec 04             	sub    $0x4,%esp
  8038e2:	68 3c 47 80 00       	push   $0x80473c
  8038e7:	68 69 01 00 00       	push   $0x169
  8038ec:	68 23 47 80 00       	push   $0x804723
  8038f1:	e8 e1 cf ff ff       	call   8008d7 <_panic>
  8038f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038f9:	8b 50 04             	mov    0x4(%eax),%edx
  8038fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ff:	89 50 04             	mov    %edx,0x4(%eax)
  803902:	8b 45 08             	mov    0x8(%ebp),%eax
  803905:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803908:	89 10                	mov    %edx,(%eax)
  80390a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80390d:	8b 40 04             	mov    0x4(%eax),%eax
  803910:	85 c0                	test   %eax,%eax
  803912:	74 0d                	je     803921 <insert_sorted_with_merge_freeList+0x572>
  803914:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803917:	8b 40 04             	mov    0x4(%eax),%eax
  80391a:	8b 55 08             	mov    0x8(%ebp),%edx
  80391d:	89 10                	mov    %edx,(%eax)
  80391f:	eb 08                	jmp    803929 <insert_sorted_with_merge_freeList+0x57a>
  803921:	8b 45 08             	mov    0x8(%ebp),%eax
  803924:	a3 38 51 80 00       	mov    %eax,0x805138
  803929:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80392c:	8b 55 08             	mov    0x8(%ebp),%edx
  80392f:	89 50 04             	mov    %edx,0x4(%eax)
  803932:	a1 44 51 80 00       	mov    0x805144,%eax
  803937:	40                   	inc    %eax
  803938:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  80393d:	8b 45 08             	mov    0x8(%ebp),%eax
  803940:	8b 50 0c             	mov    0xc(%eax),%edx
  803943:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803946:	8b 40 0c             	mov    0xc(%eax),%eax
  803949:	01 c2                	add    %eax,%edx
  80394b:	8b 45 08             	mov    0x8(%ebp),%eax
  80394e:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803951:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803955:	75 17                	jne    80396e <insert_sorted_with_merge_freeList+0x5bf>
  803957:	83 ec 04             	sub    $0x4,%esp
  80395a:	68 cc 47 80 00       	push   $0x8047cc
  80395f:	68 6b 01 00 00       	push   $0x16b
  803964:	68 23 47 80 00       	push   $0x804723
  803969:	e8 69 cf ff ff       	call   8008d7 <_panic>
  80396e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803971:	8b 00                	mov    (%eax),%eax
  803973:	85 c0                	test   %eax,%eax
  803975:	74 10                	je     803987 <insert_sorted_with_merge_freeList+0x5d8>
  803977:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80397a:	8b 00                	mov    (%eax),%eax
  80397c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80397f:	8b 52 04             	mov    0x4(%edx),%edx
  803982:	89 50 04             	mov    %edx,0x4(%eax)
  803985:	eb 0b                	jmp    803992 <insert_sorted_with_merge_freeList+0x5e3>
  803987:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80398a:	8b 40 04             	mov    0x4(%eax),%eax
  80398d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803992:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803995:	8b 40 04             	mov    0x4(%eax),%eax
  803998:	85 c0                	test   %eax,%eax
  80399a:	74 0f                	je     8039ab <insert_sorted_with_merge_freeList+0x5fc>
  80399c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80399f:	8b 40 04             	mov    0x4(%eax),%eax
  8039a2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039a5:	8b 12                	mov    (%edx),%edx
  8039a7:	89 10                	mov    %edx,(%eax)
  8039a9:	eb 0a                	jmp    8039b5 <insert_sorted_with_merge_freeList+0x606>
  8039ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039ae:	8b 00                	mov    (%eax),%eax
  8039b0:	a3 38 51 80 00       	mov    %eax,0x805138
  8039b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039c1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039c8:	a1 44 51 80 00       	mov    0x805144,%eax
  8039cd:	48                   	dec    %eax
  8039ce:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8039d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039d6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8039dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039e0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8039e7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8039eb:	75 17                	jne    803a04 <insert_sorted_with_merge_freeList+0x655>
  8039ed:	83 ec 04             	sub    $0x4,%esp
  8039f0:	68 00 47 80 00       	push   $0x804700
  8039f5:	68 6e 01 00 00       	push   $0x16e
  8039fa:	68 23 47 80 00       	push   $0x804723
  8039ff:	e8 d3 ce ff ff       	call   8008d7 <_panic>
  803a04:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a0a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a0d:	89 10                	mov    %edx,(%eax)
  803a0f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a12:	8b 00                	mov    (%eax),%eax
  803a14:	85 c0                	test   %eax,%eax
  803a16:	74 0d                	je     803a25 <insert_sorted_with_merge_freeList+0x676>
  803a18:	a1 48 51 80 00       	mov    0x805148,%eax
  803a1d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a20:	89 50 04             	mov    %edx,0x4(%eax)
  803a23:	eb 08                	jmp    803a2d <insert_sorted_with_merge_freeList+0x67e>
  803a25:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a28:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803a2d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a30:	a3 48 51 80 00       	mov    %eax,0x805148
  803a35:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a38:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a3f:	a1 54 51 80 00       	mov    0x805154,%eax
  803a44:	40                   	inc    %eax
  803a45:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803a4a:	e9 a9 00 00 00       	jmp    803af8 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803a4f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a53:	74 06                	je     803a5b <insert_sorted_with_merge_freeList+0x6ac>
  803a55:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a59:	75 17                	jne    803a72 <insert_sorted_with_merge_freeList+0x6c3>
  803a5b:	83 ec 04             	sub    $0x4,%esp
  803a5e:	68 98 47 80 00       	push   $0x804798
  803a63:	68 73 01 00 00       	push   $0x173
  803a68:	68 23 47 80 00       	push   $0x804723
  803a6d:	e8 65 ce ff ff       	call   8008d7 <_panic>
  803a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a75:	8b 10                	mov    (%eax),%edx
  803a77:	8b 45 08             	mov    0x8(%ebp),%eax
  803a7a:	89 10                	mov    %edx,(%eax)
  803a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  803a7f:	8b 00                	mov    (%eax),%eax
  803a81:	85 c0                	test   %eax,%eax
  803a83:	74 0b                	je     803a90 <insert_sorted_with_merge_freeList+0x6e1>
  803a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a88:	8b 00                	mov    (%eax),%eax
  803a8a:	8b 55 08             	mov    0x8(%ebp),%edx
  803a8d:	89 50 04             	mov    %edx,0x4(%eax)
  803a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a93:	8b 55 08             	mov    0x8(%ebp),%edx
  803a96:	89 10                	mov    %edx,(%eax)
  803a98:	8b 45 08             	mov    0x8(%ebp),%eax
  803a9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a9e:	89 50 04             	mov    %edx,0x4(%eax)
  803aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  803aa4:	8b 00                	mov    (%eax),%eax
  803aa6:	85 c0                	test   %eax,%eax
  803aa8:	75 08                	jne    803ab2 <insert_sorted_with_merge_freeList+0x703>
  803aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  803aad:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803ab2:	a1 44 51 80 00       	mov    0x805144,%eax
  803ab7:	40                   	inc    %eax
  803ab8:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803abd:	eb 39                	jmp    803af8 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803abf:	a1 40 51 80 00       	mov    0x805140,%eax
  803ac4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ac7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803acb:	74 07                	je     803ad4 <insert_sorted_with_merge_freeList+0x725>
  803acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ad0:	8b 00                	mov    (%eax),%eax
  803ad2:	eb 05                	jmp    803ad9 <insert_sorted_with_merge_freeList+0x72a>
  803ad4:	b8 00 00 00 00       	mov    $0x0,%eax
  803ad9:	a3 40 51 80 00       	mov    %eax,0x805140
  803ade:	a1 40 51 80 00       	mov    0x805140,%eax
  803ae3:	85 c0                	test   %eax,%eax
  803ae5:	0f 85 c7 fb ff ff    	jne    8036b2 <insert_sorted_with_merge_freeList+0x303>
  803aeb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803aef:	0f 85 bd fb ff ff    	jne    8036b2 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803af5:	eb 01                	jmp    803af8 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803af7:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803af8:	90                   	nop
  803af9:	c9                   	leave  
  803afa:	c3                   	ret    
  803afb:	90                   	nop

00803afc <__udivdi3>:
  803afc:	55                   	push   %ebp
  803afd:	57                   	push   %edi
  803afe:	56                   	push   %esi
  803aff:	53                   	push   %ebx
  803b00:	83 ec 1c             	sub    $0x1c,%esp
  803b03:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803b07:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b0b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b0f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b13:	89 ca                	mov    %ecx,%edx
  803b15:	89 f8                	mov    %edi,%eax
  803b17:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803b1b:	85 f6                	test   %esi,%esi
  803b1d:	75 2d                	jne    803b4c <__udivdi3+0x50>
  803b1f:	39 cf                	cmp    %ecx,%edi
  803b21:	77 65                	ja     803b88 <__udivdi3+0x8c>
  803b23:	89 fd                	mov    %edi,%ebp
  803b25:	85 ff                	test   %edi,%edi
  803b27:	75 0b                	jne    803b34 <__udivdi3+0x38>
  803b29:	b8 01 00 00 00       	mov    $0x1,%eax
  803b2e:	31 d2                	xor    %edx,%edx
  803b30:	f7 f7                	div    %edi
  803b32:	89 c5                	mov    %eax,%ebp
  803b34:	31 d2                	xor    %edx,%edx
  803b36:	89 c8                	mov    %ecx,%eax
  803b38:	f7 f5                	div    %ebp
  803b3a:	89 c1                	mov    %eax,%ecx
  803b3c:	89 d8                	mov    %ebx,%eax
  803b3e:	f7 f5                	div    %ebp
  803b40:	89 cf                	mov    %ecx,%edi
  803b42:	89 fa                	mov    %edi,%edx
  803b44:	83 c4 1c             	add    $0x1c,%esp
  803b47:	5b                   	pop    %ebx
  803b48:	5e                   	pop    %esi
  803b49:	5f                   	pop    %edi
  803b4a:	5d                   	pop    %ebp
  803b4b:	c3                   	ret    
  803b4c:	39 ce                	cmp    %ecx,%esi
  803b4e:	77 28                	ja     803b78 <__udivdi3+0x7c>
  803b50:	0f bd fe             	bsr    %esi,%edi
  803b53:	83 f7 1f             	xor    $0x1f,%edi
  803b56:	75 40                	jne    803b98 <__udivdi3+0x9c>
  803b58:	39 ce                	cmp    %ecx,%esi
  803b5a:	72 0a                	jb     803b66 <__udivdi3+0x6a>
  803b5c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803b60:	0f 87 9e 00 00 00    	ja     803c04 <__udivdi3+0x108>
  803b66:	b8 01 00 00 00       	mov    $0x1,%eax
  803b6b:	89 fa                	mov    %edi,%edx
  803b6d:	83 c4 1c             	add    $0x1c,%esp
  803b70:	5b                   	pop    %ebx
  803b71:	5e                   	pop    %esi
  803b72:	5f                   	pop    %edi
  803b73:	5d                   	pop    %ebp
  803b74:	c3                   	ret    
  803b75:	8d 76 00             	lea    0x0(%esi),%esi
  803b78:	31 ff                	xor    %edi,%edi
  803b7a:	31 c0                	xor    %eax,%eax
  803b7c:	89 fa                	mov    %edi,%edx
  803b7e:	83 c4 1c             	add    $0x1c,%esp
  803b81:	5b                   	pop    %ebx
  803b82:	5e                   	pop    %esi
  803b83:	5f                   	pop    %edi
  803b84:	5d                   	pop    %ebp
  803b85:	c3                   	ret    
  803b86:	66 90                	xchg   %ax,%ax
  803b88:	89 d8                	mov    %ebx,%eax
  803b8a:	f7 f7                	div    %edi
  803b8c:	31 ff                	xor    %edi,%edi
  803b8e:	89 fa                	mov    %edi,%edx
  803b90:	83 c4 1c             	add    $0x1c,%esp
  803b93:	5b                   	pop    %ebx
  803b94:	5e                   	pop    %esi
  803b95:	5f                   	pop    %edi
  803b96:	5d                   	pop    %ebp
  803b97:	c3                   	ret    
  803b98:	bd 20 00 00 00       	mov    $0x20,%ebp
  803b9d:	89 eb                	mov    %ebp,%ebx
  803b9f:	29 fb                	sub    %edi,%ebx
  803ba1:	89 f9                	mov    %edi,%ecx
  803ba3:	d3 e6                	shl    %cl,%esi
  803ba5:	89 c5                	mov    %eax,%ebp
  803ba7:	88 d9                	mov    %bl,%cl
  803ba9:	d3 ed                	shr    %cl,%ebp
  803bab:	89 e9                	mov    %ebp,%ecx
  803bad:	09 f1                	or     %esi,%ecx
  803baf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803bb3:	89 f9                	mov    %edi,%ecx
  803bb5:	d3 e0                	shl    %cl,%eax
  803bb7:	89 c5                	mov    %eax,%ebp
  803bb9:	89 d6                	mov    %edx,%esi
  803bbb:	88 d9                	mov    %bl,%cl
  803bbd:	d3 ee                	shr    %cl,%esi
  803bbf:	89 f9                	mov    %edi,%ecx
  803bc1:	d3 e2                	shl    %cl,%edx
  803bc3:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bc7:	88 d9                	mov    %bl,%cl
  803bc9:	d3 e8                	shr    %cl,%eax
  803bcb:	09 c2                	or     %eax,%edx
  803bcd:	89 d0                	mov    %edx,%eax
  803bcf:	89 f2                	mov    %esi,%edx
  803bd1:	f7 74 24 0c          	divl   0xc(%esp)
  803bd5:	89 d6                	mov    %edx,%esi
  803bd7:	89 c3                	mov    %eax,%ebx
  803bd9:	f7 e5                	mul    %ebp
  803bdb:	39 d6                	cmp    %edx,%esi
  803bdd:	72 19                	jb     803bf8 <__udivdi3+0xfc>
  803bdf:	74 0b                	je     803bec <__udivdi3+0xf0>
  803be1:	89 d8                	mov    %ebx,%eax
  803be3:	31 ff                	xor    %edi,%edi
  803be5:	e9 58 ff ff ff       	jmp    803b42 <__udivdi3+0x46>
  803bea:	66 90                	xchg   %ax,%ax
  803bec:	8b 54 24 08          	mov    0x8(%esp),%edx
  803bf0:	89 f9                	mov    %edi,%ecx
  803bf2:	d3 e2                	shl    %cl,%edx
  803bf4:	39 c2                	cmp    %eax,%edx
  803bf6:	73 e9                	jae    803be1 <__udivdi3+0xe5>
  803bf8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803bfb:	31 ff                	xor    %edi,%edi
  803bfd:	e9 40 ff ff ff       	jmp    803b42 <__udivdi3+0x46>
  803c02:	66 90                	xchg   %ax,%ax
  803c04:	31 c0                	xor    %eax,%eax
  803c06:	e9 37 ff ff ff       	jmp    803b42 <__udivdi3+0x46>
  803c0b:	90                   	nop

00803c0c <__umoddi3>:
  803c0c:	55                   	push   %ebp
  803c0d:	57                   	push   %edi
  803c0e:	56                   	push   %esi
  803c0f:	53                   	push   %ebx
  803c10:	83 ec 1c             	sub    $0x1c,%esp
  803c13:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803c17:	8b 74 24 34          	mov    0x34(%esp),%esi
  803c1b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c1f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c23:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c27:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c2b:	89 f3                	mov    %esi,%ebx
  803c2d:	89 fa                	mov    %edi,%edx
  803c2f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c33:	89 34 24             	mov    %esi,(%esp)
  803c36:	85 c0                	test   %eax,%eax
  803c38:	75 1a                	jne    803c54 <__umoddi3+0x48>
  803c3a:	39 f7                	cmp    %esi,%edi
  803c3c:	0f 86 a2 00 00 00    	jbe    803ce4 <__umoddi3+0xd8>
  803c42:	89 c8                	mov    %ecx,%eax
  803c44:	89 f2                	mov    %esi,%edx
  803c46:	f7 f7                	div    %edi
  803c48:	89 d0                	mov    %edx,%eax
  803c4a:	31 d2                	xor    %edx,%edx
  803c4c:	83 c4 1c             	add    $0x1c,%esp
  803c4f:	5b                   	pop    %ebx
  803c50:	5e                   	pop    %esi
  803c51:	5f                   	pop    %edi
  803c52:	5d                   	pop    %ebp
  803c53:	c3                   	ret    
  803c54:	39 f0                	cmp    %esi,%eax
  803c56:	0f 87 ac 00 00 00    	ja     803d08 <__umoddi3+0xfc>
  803c5c:	0f bd e8             	bsr    %eax,%ebp
  803c5f:	83 f5 1f             	xor    $0x1f,%ebp
  803c62:	0f 84 ac 00 00 00    	je     803d14 <__umoddi3+0x108>
  803c68:	bf 20 00 00 00       	mov    $0x20,%edi
  803c6d:	29 ef                	sub    %ebp,%edi
  803c6f:	89 fe                	mov    %edi,%esi
  803c71:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803c75:	89 e9                	mov    %ebp,%ecx
  803c77:	d3 e0                	shl    %cl,%eax
  803c79:	89 d7                	mov    %edx,%edi
  803c7b:	89 f1                	mov    %esi,%ecx
  803c7d:	d3 ef                	shr    %cl,%edi
  803c7f:	09 c7                	or     %eax,%edi
  803c81:	89 e9                	mov    %ebp,%ecx
  803c83:	d3 e2                	shl    %cl,%edx
  803c85:	89 14 24             	mov    %edx,(%esp)
  803c88:	89 d8                	mov    %ebx,%eax
  803c8a:	d3 e0                	shl    %cl,%eax
  803c8c:	89 c2                	mov    %eax,%edx
  803c8e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c92:	d3 e0                	shl    %cl,%eax
  803c94:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c98:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c9c:	89 f1                	mov    %esi,%ecx
  803c9e:	d3 e8                	shr    %cl,%eax
  803ca0:	09 d0                	or     %edx,%eax
  803ca2:	d3 eb                	shr    %cl,%ebx
  803ca4:	89 da                	mov    %ebx,%edx
  803ca6:	f7 f7                	div    %edi
  803ca8:	89 d3                	mov    %edx,%ebx
  803caa:	f7 24 24             	mull   (%esp)
  803cad:	89 c6                	mov    %eax,%esi
  803caf:	89 d1                	mov    %edx,%ecx
  803cb1:	39 d3                	cmp    %edx,%ebx
  803cb3:	0f 82 87 00 00 00    	jb     803d40 <__umoddi3+0x134>
  803cb9:	0f 84 91 00 00 00    	je     803d50 <__umoddi3+0x144>
  803cbf:	8b 54 24 04          	mov    0x4(%esp),%edx
  803cc3:	29 f2                	sub    %esi,%edx
  803cc5:	19 cb                	sbb    %ecx,%ebx
  803cc7:	89 d8                	mov    %ebx,%eax
  803cc9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803ccd:	d3 e0                	shl    %cl,%eax
  803ccf:	89 e9                	mov    %ebp,%ecx
  803cd1:	d3 ea                	shr    %cl,%edx
  803cd3:	09 d0                	or     %edx,%eax
  803cd5:	89 e9                	mov    %ebp,%ecx
  803cd7:	d3 eb                	shr    %cl,%ebx
  803cd9:	89 da                	mov    %ebx,%edx
  803cdb:	83 c4 1c             	add    $0x1c,%esp
  803cde:	5b                   	pop    %ebx
  803cdf:	5e                   	pop    %esi
  803ce0:	5f                   	pop    %edi
  803ce1:	5d                   	pop    %ebp
  803ce2:	c3                   	ret    
  803ce3:	90                   	nop
  803ce4:	89 fd                	mov    %edi,%ebp
  803ce6:	85 ff                	test   %edi,%edi
  803ce8:	75 0b                	jne    803cf5 <__umoddi3+0xe9>
  803cea:	b8 01 00 00 00       	mov    $0x1,%eax
  803cef:	31 d2                	xor    %edx,%edx
  803cf1:	f7 f7                	div    %edi
  803cf3:	89 c5                	mov    %eax,%ebp
  803cf5:	89 f0                	mov    %esi,%eax
  803cf7:	31 d2                	xor    %edx,%edx
  803cf9:	f7 f5                	div    %ebp
  803cfb:	89 c8                	mov    %ecx,%eax
  803cfd:	f7 f5                	div    %ebp
  803cff:	89 d0                	mov    %edx,%eax
  803d01:	e9 44 ff ff ff       	jmp    803c4a <__umoddi3+0x3e>
  803d06:	66 90                	xchg   %ax,%ax
  803d08:	89 c8                	mov    %ecx,%eax
  803d0a:	89 f2                	mov    %esi,%edx
  803d0c:	83 c4 1c             	add    $0x1c,%esp
  803d0f:	5b                   	pop    %ebx
  803d10:	5e                   	pop    %esi
  803d11:	5f                   	pop    %edi
  803d12:	5d                   	pop    %ebp
  803d13:	c3                   	ret    
  803d14:	3b 04 24             	cmp    (%esp),%eax
  803d17:	72 06                	jb     803d1f <__umoddi3+0x113>
  803d19:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803d1d:	77 0f                	ja     803d2e <__umoddi3+0x122>
  803d1f:	89 f2                	mov    %esi,%edx
  803d21:	29 f9                	sub    %edi,%ecx
  803d23:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d27:	89 14 24             	mov    %edx,(%esp)
  803d2a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d2e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d32:	8b 14 24             	mov    (%esp),%edx
  803d35:	83 c4 1c             	add    $0x1c,%esp
  803d38:	5b                   	pop    %ebx
  803d39:	5e                   	pop    %esi
  803d3a:	5f                   	pop    %edi
  803d3b:	5d                   	pop    %ebp
  803d3c:	c3                   	ret    
  803d3d:	8d 76 00             	lea    0x0(%esi),%esi
  803d40:	2b 04 24             	sub    (%esp),%eax
  803d43:	19 fa                	sbb    %edi,%edx
  803d45:	89 d1                	mov    %edx,%ecx
  803d47:	89 c6                	mov    %eax,%esi
  803d49:	e9 71 ff ff ff       	jmp    803cbf <__umoddi3+0xb3>
  803d4e:	66 90                	xchg   %ax,%ax
  803d50:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803d54:	72 ea                	jb     803d40 <__umoddi3+0x134>
  803d56:	89 d9                	mov    %ebx,%ecx
  803d58:	e9 62 ff ff ff       	jmp    803cbf <__umoddi3+0xb3>
