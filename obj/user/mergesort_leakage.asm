
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
  800041:	e8 6d 20 00 00       	call   8020b3 <sys_disable_interrupt>

		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 00 3e 80 00       	push   $0x803e00
  80004e:	e8 38 0b 00 00       	call   800b8b <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 02 3e 80 00       	push   $0x803e02
  80005e:	e8 28 0b 00 00       	call   800b8b <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 18 3e 80 00       	push   $0x803e18
  80006e:	e8 18 0b 00 00       	call   800b8b <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 02 3e 80 00       	push   $0x803e02
  80007e:	e8 08 0b 00 00       	call   800b8b <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 00 3e 80 00       	push   $0x803e00
  80008e:	e8 f8 0a 00 00       	call   800b8b <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 30 3e 80 00       	push   $0x803e30
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
  8000de:	68 50 3e 80 00       	push   $0x803e50
  8000e3:	e8 a3 0a 00 00       	call   800b8b <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 72 3e 80 00       	push   $0x803e72
  8000f3:	e8 93 0a 00 00       	call   800b8b <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 80 3e 80 00       	push   $0x803e80
  800103:	e8 83 0a 00 00       	call   800b8b <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 8f 3e 80 00       	push   $0x803e8f
  800113:	e8 73 0a 00 00       	call   800b8b <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 9f 3e 80 00       	push   $0x803e9f
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
  800162:	e8 66 1f 00 00       	call   8020cd <sys_enable_interrupt>

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
  8001d7:	e8 d7 1e 00 00       	call   8020b3 <sys_disable_interrupt>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	68 a8 3e 80 00       	push   $0x803ea8
  8001e4:	e8 a2 09 00 00       	call   800b8b <cprintf>
  8001e9:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001ec:	e8 dc 1e 00 00       	call   8020cd <sys_enable_interrupt>

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
  80020e:	68 dc 3e 80 00       	push   $0x803edc
  800213:	6a 4a                	push   $0x4a
  800215:	68 fe 3e 80 00       	push   $0x803efe
  80021a:	e8 b8 06 00 00       	call   8008d7 <_panic>
		else
		{
			sys_disable_interrupt();
  80021f:	e8 8f 1e 00 00       	call   8020b3 <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	68 18 3f 80 00       	push   $0x803f18
  80022c:	e8 5a 09 00 00       	call   800b8b <cprintf>
  800231:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	68 4c 3f 80 00       	push   $0x803f4c
  80023c:	e8 4a 09 00 00       	call   800b8b <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 80 3f 80 00       	push   $0x803f80
  80024c:	e8 3a 09 00 00       	call   800b8b <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800254:	e8 74 1e 00 00       	call   8020cd <sys_enable_interrupt>
		}

		//free(Elements) ;

		sys_disable_interrupt();
  800259:	e8 55 1e 00 00       	call   8020b3 <sys_disable_interrupt>
			Chose = 0 ;
  80025e:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800262:	eb 42                	jmp    8002a6 <_main+0x26e>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800264:	83 ec 0c             	sub    $0xc,%esp
  800267:	68 b2 3f 80 00       	push   $0x803fb2
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
  8002b2:	e8 16 1e 00 00       	call   8020cd <sys_enable_interrupt>

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
  800446:	68 00 3e 80 00       	push   $0x803e00
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
  800468:	68 d0 3f 80 00       	push   $0x803fd0
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
  800496:	68 d5 3f 80 00       	push   $0x803fd5
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
  80070f:	e8 d3 19 00 00       	call   8020e7 <sys_cputc>
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
  800720:	e8 8e 19 00 00       	call   8020b3 <sys_disable_interrupt>
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
  800733:	e8 af 19 00 00       	call   8020e7 <sys_cputc>
  800738:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80073b:	e8 8d 19 00 00       	call   8020cd <sys_enable_interrupt>
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
  800752:	e8 d7 17 00 00       	call   801f2e <sys_cgetc>
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
  80076b:	e8 43 19 00 00       	call   8020b3 <sys_disable_interrupt>
	int c=0;
  800770:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800777:	eb 08                	jmp    800781 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800779:	e8 b0 17 00 00       	call   801f2e <sys_cgetc>
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
  800787:	e8 41 19 00 00       	call   8020cd <sys_enable_interrupt>
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
  8007a1:	e8 00 1b 00 00       	call   8022a6 <sys_getenvindex>
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
  80080c:	e8 a2 18 00 00       	call   8020b3 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800811:	83 ec 0c             	sub    $0xc,%esp
  800814:	68 f4 3f 80 00       	push   $0x803ff4
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
  80083c:	68 1c 40 80 00       	push   $0x80401c
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
  80086d:	68 44 40 80 00       	push   $0x804044
  800872:	e8 14 03 00 00       	call   800b8b <cprintf>
  800877:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80087a:	a1 24 50 80 00       	mov    0x805024,%eax
  80087f:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800885:	83 ec 08             	sub    $0x8,%esp
  800888:	50                   	push   %eax
  800889:	68 9c 40 80 00       	push   $0x80409c
  80088e:	e8 f8 02 00 00       	call   800b8b <cprintf>
  800893:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800896:	83 ec 0c             	sub    $0xc,%esp
  800899:	68 f4 3f 80 00       	push   $0x803ff4
  80089e:	e8 e8 02 00 00       	call   800b8b <cprintf>
  8008a3:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8008a6:	e8 22 18 00 00       	call   8020cd <sys_enable_interrupt>

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
  8008be:	e8 af 19 00 00       	call   802272 <sys_destroy_env>
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
  8008cf:	e8 04 1a 00 00       	call   8022d8 <sys_exit_env>
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
  8008f8:	68 b0 40 80 00       	push   $0x8040b0
  8008fd:	e8 89 02 00 00       	call   800b8b <cprintf>
  800902:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800905:	a1 00 50 80 00       	mov    0x805000,%eax
  80090a:	ff 75 0c             	pushl  0xc(%ebp)
  80090d:	ff 75 08             	pushl  0x8(%ebp)
  800910:	50                   	push   %eax
  800911:	68 b5 40 80 00       	push   $0x8040b5
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
  800935:	68 d1 40 80 00       	push   $0x8040d1
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
  800961:	68 d4 40 80 00       	push   $0x8040d4
  800966:	6a 26                	push   $0x26
  800968:	68 20 41 80 00       	push   $0x804120
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
  800a33:	68 2c 41 80 00       	push   $0x80412c
  800a38:	6a 3a                	push   $0x3a
  800a3a:	68 20 41 80 00       	push   $0x804120
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
  800aa3:	68 80 41 80 00       	push   $0x804180
  800aa8:	6a 44                	push   $0x44
  800aaa:	68 20 41 80 00       	push   $0x804120
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
  800afd:	e8 03 14 00 00       	call   801f05 <sys_cputs>
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
  800b74:	e8 8c 13 00 00       	call   801f05 <sys_cputs>
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
  800bbe:	e8 f0 14 00 00       	call   8020b3 <sys_disable_interrupt>
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
  800bde:	e8 ea 14 00 00       	call   8020cd <sys_enable_interrupt>
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
  800c28:	e8 5b 2f 00 00       	call   803b88 <__udivdi3>
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
  800c78:	e8 1b 30 00 00       	call   803c98 <__umoddi3>
  800c7d:	83 c4 10             	add    $0x10,%esp
  800c80:	05 f4 43 80 00       	add    $0x8043f4,%eax
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
  800dd3:	8b 04 85 18 44 80 00 	mov    0x804418(,%eax,4),%eax
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
  800eb4:	8b 34 9d 60 42 80 00 	mov    0x804260(,%ebx,4),%esi
  800ebb:	85 f6                	test   %esi,%esi
  800ebd:	75 19                	jne    800ed8 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ebf:	53                   	push   %ebx
  800ec0:	68 05 44 80 00       	push   $0x804405
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
  800ed9:	68 0e 44 80 00       	push   $0x80440e
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
  800f06:	be 11 44 80 00       	mov    $0x804411,%esi
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
  80121f:	68 70 45 80 00       	push   $0x804570
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
  801261:	68 73 45 80 00       	push   $0x804573
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
  801311:	e8 9d 0d 00 00       	call   8020b3 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  801316:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80131a:	74 13                	je     80132f <atomic_readline+0x24>
		cprintf("%s", prompt);
  80131c:	83 ec 08             	sub    $0x8,%esp
  80131f:	ff 75 08             	pushl  0x8(%ebp)
  801322:	68 70 45 80 00       	push   $0x804570
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
  801360:	68 73 45 80 00       	push   $0x804573
  801365:	e8 21 f8 ff ff       	call   800b8b <cprintf>
  80136a:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  80136d:	e8 5b 0d 00 00       	call   8020cd <sys_enable_interrupt>
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
  801405:	e8 c3 0c 00 00       	call   8020cd <sys_enable_interrupt>
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
  801b32:	68 84 45 80 00       	push   $0x804584
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
  801c02:	e8 42 04 00 00       	call   802049 <sys_allocate_chunk>
  801c07:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801c0a:	a1 20 51 80 00       	mov    0x805120,%eax
  801c0f:	83 ec 0c             	sub    $0xc,%esp
  801c12:	50                   	push   %eax
  801c13:	e8 b7 0a 00 00       	call   8026cf <initialize_MemBlocksList>
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
  801c40:	68 a9 45 80 00       	push   $0x8045a9
  801c45:	6a 33                	push   $0x33
  801c47:	68 c7 45 80 00       	push   $0x8045c7
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
  801cbf:	68 d4 45 80 00       	push   $0x8045d4
  801cc4:	6a 34                	push   $0x34
  801cc6:	68 c7 45 80 00       	push   $0x8045c7
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
  801d34:	68 f8 45 80 00       	push   $0x8045f8
  801d39:	6a 46                	push   $0x46
  801d3b:	68 c7 45 80 00       	push   $0x8045c7
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
  801d50:	68 20 46 80 00       	push   $0x804620
  801d55:	6a 61                	push   $0x61
  801d57:	68 c7 45 80 00       	push   $0x8045c7
  801d5c:	e8 76 eb ff ff       	call   8008d7 <_panic>

00801d61 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801d61:	55                   	push   %ebp
  801d62:	89 e5                	mov    %esp,%ebp
  801d64:	83 ec 38             	sub    $0x38,%esp
  801d67:	8b 45 10             	mov    0x10(%ebp),%eax
  801d6a:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d6d:	e8 a9 fd ff ff       	call   801b1b <InitializeUHeap>
	if (size == 0) return NULL ;
  801d72:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d76:	75 0a                	jne    801d82 <smalloc+0x21>
  801d78:	b8 00 00 00 00       	mov    $0x0,%eax
  801d7d:	e9 9e 00 00 00       	jmp    801e20 <smalloc+0xbf>
	//3-If the Kernel successfully creates the shared variable, return its virtual address
	//4-Else, return NULL



	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801d82:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801d89:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d8f:	01 d0                	add    %edx,%eax
  801d91:	48                   	dec    %eax
  801d92:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801d95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d98:	ba 00 00 00 00       	mov    $0x0,%edx
  801d9d:	f7 75 f0             	divl   -0x10(%ebp)
  801da0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801da3:	29 d0                	sub    %edx,%eax
  801da5:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801da8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801daf:	e8 63 06 00 00       	call   802417 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801db4:	85 c0                	test   %eax,%eax
  801db6:	74 11                	je     801dc9 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801db8:	83 ec 0c             	sub    $0xc,%esp
  801dbb:	ff 75 e8             	pushl  -0x18(%ebp)
  801dbe:	e8 ce 0c 00 00       	call   802a91 <alloc_block_FF>
  801dc3:	83 c4 10             	add    $0x10,%esp
  801dc6:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801dc9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dcd:	74 4c                	je     801e1b <smalloc+0xba>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd2:	8b 40 08             	mov    0x8(%eax),%eax
  801dd5:	89 c2                	mov    %eax,%edx
  801dd7:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801ddb:	52                   	push   %edx
  801ddc:	50                   	push   %eax
  801ddd:	ff 75 0c             	pushl  0xc(%ebp)
  801de0:	ff 75 08             	pushl  0x8(%ebp)
  801de3:	e8 b4 03 00 00       	call   80219c <sys_createSharedObject>
  801de8:	83 c4 10             	add    $0x10,%esp
  801deb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("Output is :  %d \n" , result);
  801dee:	83 ec 08             	sub    $0x8,%esp
  801df1:	ff 75 e0             	pushl  -0x20(%ebp)
  801df4:	68 43 46 80 00       	push   $0x804643
  801df9:	e8 8d ed ff ff       	call   800b8b <cprintf>
  801dfe:	83 c4 10             	add    $0x10,%esp
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801e01:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801e05:	74 14                	je     801e1b <smalloc+0xba>
  801e07:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801e0b:	74 0e                	je     801e1b <smalloc+0xba>
  801e0d:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801e11:	74 08                	je     801e1b <smalloc+0xba>
			return (void*) mem_block->sva;
  801e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e16:	8b 40 08             	mov    0x8(%eax),%eax
  801e19:	eb 05                	jmp    801e20 <smalloc+0xbf>
	}
	return NULL;
  801e1b:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801e20:	c9                   	leave  
  801e21:	c3                   	ret    

00801e22 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801e22:	55                   	push   %ebp
  801e23:	89 e5                	mov    %esp,%ebp
  801e25:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e28:	e8 ee fc ff ff       	call   801b1b <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801e2d:	83 ec 04             	sub    $0x4,%esp
  801e30:	68 58 46 80 00       	push   $0x804658
  801e35:	68 ab 00 00 00       	push   $0xab
  801e3a:	68 c7 45 80 00       	push   $0x8045c7
  801e3f:	e8 93 ea ff ff       	call   8008d7 <_panic>

00801e44 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801e44:	55                   	push   %ebp
  801e45:	89 e5                	mov    %esp,%ebp
  801e47:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e4a:	e8 cc fc ff ff       	call   801b1b <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801e4f:	83 ec 04             	sub    $0x4,%esp
  801e52:	68 7c 46 80 00       	push   $0x80467c
  801e57:	68 ef 00 00 00       	push   $0xef
  801e5c:	68 c7 45 80 00       	push   $0x8045c7
  801e61:	e8 71 ea ff ff       	call   8008d7 <_panic>

00801e66 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801e66:	55                   	push   %ebp
  801e67:	89 e5                	mov    %esp,%ebp
  801e69:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801e6c:	83 ec 04             	sub    $0x4,%esp
  801e6f:	68 a4 46 80 00       	push   $0x8046a4
  801e74:	68 03 01 00 00       	push   $0x103
  801e79:	68 c7 45 80 00       	push   $0x8045c7
  801e7e:	e8 54 ea ff ff       	call   8008d7 <_panic>

00801e83 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801e83:	55                   	push   %ebp
  801e84:	89 e5                	mov    %esp,%ebp
  801e86:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e89:	83 ec 04             	sub    $0x4,%esp
  801e8c:	68 c8 46 80 00       	push   $0x8046c8
  801e91:	68 0e 01 00 00       	push   $0x10e
  801e96:	68 c7 45 80 00       	push   $0x8045c7
  801e9b:	e8 37 ea ff ff       	call   8008d7 <_panic>

00801ea0 <shrink>:

}
void shrink(uint32 newSize)
{
  801ea0:	55                   	push   %ebp
  801ea1:	89 e5                	mov    %esp,%ebp
  801ea3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ea6:	83 ec 04             	sub    $0x4,%esp
  801ea9:	68 c8 46 80 00       	push   $0x8046c8
  801eae:	68 13 01 00 00       	push   $0x113
  801eb3:	68 c7 45 80 00       	push   $0x8045c7
  801eb8:	e8 1a ea ff ff       	call   8008d7 <_panic>

00801ebd <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801ebd:	55                   	push   %ebp
  801ebe:	89 e5                	mov    %esp,%ebp
  801ec0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ec3:	83 ec 04             	sub    $0x4,%esp
  801ec6:	68 c8 46 80 00       	push   $0x8046c8
  801ecb:	68 18 01 00 00       	push   $0x118
  801ed0:	68 c7 45 80 00       	push   $0x8045c7
  801ed5:	e8 fd e9 ff ff       	call   8008d7 <_panic>

00801eda <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801eda:	55                   	push   %ebp
  801edb:	89 e5                	mov    %esp,%ebp
  801edd:	57                   	push   %edi
  801ede:	56                   	push   %esi
  801edf:	53                   	push   %ebx
  801ee0:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801eec:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801eef:	8b 7d 18             	mov    0x18(%ebp),%edi
  801ef2:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801ef5:	cd 30                	int    $0x30
  801ef7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801efa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801efd:	83 c4 10             	add    $0x10,%esp
  801f00:	5b                   	pop    %ebx
  801f01:	5e                   	pop    %esi
  801f02:	5f                   	pop    %edi
  801f03:	5d                   	pop    %ebp
  801f04:	c3                   	ret    

00801f05 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801f05:	55                   	push   %ebp
  801f06:	89 e5                	mov    %esp,%ebp
  801f08:	83 ec 04             	sub    $0x4,%esp
  801f0b:	8b 45 10             	mov    0x10(%ebp),%eax
  801f0e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801f11:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f15:	8b 45 08             	mov    0x8(%ebp),%eax
  801f18:	6a 00                	push   $0x0
  801f1a:	6a 00                	push   $0x0
  801f1c:	52                   	push   %edx
  801f1d:	ff 75 0c             	pushl  0xc(%ebp)
  801f20:	50                   	push   %eax
  801f21:	6a 00                	push   $0x0
  801f23:	e8 b2 ff ff ff       	call   801eda <syscall>
  801f28:	83 c4 18             	add    $0x18,%esp
}
  801f2b:	90                   	nop
  801f2c:	c9                   	leave  
  801f2d:	c3                   	ret    

00801f2e <sys_cgetc>:

int
sys_cgetc(void)
{
  801f2e:	55                   	push   %ebp
  801f2f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801f31:	6a 00                	push   $0x0
  801f33:	6a 00                	push   $0x0
  801f35:	6a 00                	push   $0x0
  801f37:	6a 00                	push   $0x0
  801f39:	6a 00                	push   $0x0
  801f3b:	6a 01                	push   $0x1
  801f3d:	e8 98 ff ff ff       	call   801eda <syscall>
  801f42:	83 c4 18             	add    $0x18,%esp
}
  801f45:	c9                   	leave  
  801f46:	c3                   	ret    

00801f47 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801f47:	55                   	push   %ebp
  801f48:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801f4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f50:	6a 00                	push   $0x0
  801f52:	6a 00                	push   $0x0
  801f54:	6a 00                	push   $0x0
  801f56:	52                   	push   %edx
  801f57:	50                   	push   %eax
  801f58:	6a 05                	push   $0x5
  801f5a:	e8 7b ff ff ff       	call   801eda <syscall>
  801f5f:	83 c4 18             	add    $0x18,%esp
}
  801f62:	c9                   	leave  
  801f63:	c3                   	ret    

00801f64 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801f64:	55                   	push   %ebp
  801f65:	89 e5                	mov    %esp,%ebp
  801f67:	56                   	push   %esi
  801f68:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801f69:	8b 75 18             	mov    0x18(%ebp),%esi
  801f6c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f6f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f72:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f75:	8b 45 08             	mov    0x8(%ebp),%eax
  801f78:	56                   	push   %esi
  801f79:	53                   	push   %ebx
  801f7a:	51                   	push   %ecx
  801f7b:	52                   	push   %edx
  801f7c:	50                   	push   %eax
  801f7d:	6a 06                	push   $0x6
  801f7f:	e8 56 ff ff ff       	call   801eda <syscall>
  801f84:	83 c4 18             	add    $0x18,%esp
}
  801f87:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f8a:	5b                   	pop    %ebx
  801f8b:	5e                   	pop    %esi
  801f8c:	5d                   	pop    %ebp
  801f8d:	c3                   	ret    

00801f8e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801f8e:	55                   	push   %ebp
  801f8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801f91:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f94:	8b 45 08             	mov    0x8(%ebp),%eax
  801f97:	6a 00                	push   $0x0
  801f99:	6a 00                	push   $0x0
  801f9b:	6a 00                	push   $0x0
  801f9d:	52                   	push   %edx
  801f9e:	50                   	push   %eax
  801f9f:	6a 07                	push   $0x7
  801fa1:	e8 34 ff ff ff       	call   801eda <syscall>
  801fa6:	83 c4 18             	add    $0x18,%esp
}
  801fa9:	c9                   	leave  
  801faa:	c3                   	ret    

00801fab <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801fab:	55                   	push   %ebp
  801fac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801fae:	6a 00                	push   $0x0
  801fb0:	6a 00                	push   $0x0
  801fb2:	6a 00                	push   $0x0
  801fb4:	ff 75 0c             	pushl  0xc(%ebp)
  801fb7:	ff 75 08             	pushl  0x8(%ebp)
  801fba:	6a 08                	push   $0x8
  801fbc:	e8 19 ff ff ff       	call   801eda <syscall>
  801fc1:	83 c4 18             	add    $0x18,%esp
}
  801fc4:	c9                   	leave  
  801fc5:	c3                   	ret    

00801fc6 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801fc6:	55                   	push   %ebp
  801fc7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801fc9:	6a 00                	push   $0x0
  801fcb:	6a 00                	push   $0x0
  801fcd:	6a 00                	push   $0x0
  801fcf:	6a 00                	push   $0x0
  801fd1:	6a 00                	push   $0x0
  801fd3:	6a 09                	push   $0x9
  801fd5:	e8 00 ff ff ff       	call   801eda <syscall>
  801fda:	83 c4 18             	add    $0x18,%esp
}
  801fdd:	c9                   	leave  
  801fde:	c3                   	ret    

00801fdf <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801fdf:	55                   	push   %ebp
  801fe0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801fe2:	6a 00                	push   $0x0
  801fe4:	6a 00                	push   $0x0
  801fe6:	6a 00                	push   $0x0
  801fe8:	6a 00                	push   $0x0
  801fea:	6a 00                	push   $0x0
  801fec:	6a 0a                	push   $0xa
  801fee:	e8 e7 fe ff ff       	call   801eda <syscall>
  801ff3:	83 c4 18             	add    $0x18,%esp
}
  801ff6:	c9                   	leave  
  801ff7:	c3                   	ret    

00801ff8 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801ff8:	55                   	push   %ebp
  801ff9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801ffb:	6a 00                	push   $0x0
  801ffd:	6a 00                	push   $0x0
  801fff:	6a 00                	push   $0x0
  802001:	6a 00                	push   $0x0
  802003:	6a 00                	push   $0x0
  802005:	6a 0b                	push   $0xb
  802007:	e8 ce fe ff ff       	call   801eda <syscall>
  80200c:	83 c4 18             	add    $0x18,%esp
}
  80200f:	c9                   	leave  
  802010:	c3                   	ret    

00802011 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802011:	55                   	push   %ebp
  802012:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802014:	6a 00                	push   $0x0
  802016:	6a 00                	push   $0x0
  802018:	6a 00                	push   $0x0
  80201a:	ff 75 0c             	pushl  0xc(%ebp)
  80201d:	ff 75 08             	pushl  0x8(%ebp)
  802020:	6a 0f                	push   $0xf
  802022:	e8 b3 fe ff ff       	call   801eda <syscall>
  802027:	83 c4 18             	add    $0x18,%esp
	return;
  80202a:	90                   	nop
}
  80202b:	c9                   	leave  
  80202c:	c3                   	ret    

0080202d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80202d:	55                   	push   %ebp
  80202e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802030:	6a 00                	push   $0x0
  802032:	6a 00                	push   $0x0
  802034:	6a 00                	push   $0x0
  802036:	ff 75 0c             	pushl  0xc(%ebp)
  802039:	ff 75 08             	pushl  0x8(%ebp)
  80203c:	6a 10                	push   $0x10
  80203e:	e8 97 fe ff ff       	call   801eda <syscall>
  802043:	83 c4 18             	add    $0x18,%esp
	return ;
  802046:	90                   	nop
}
  802047:	c9                   	leave  
  802048:	c3                   	ret    

00802049 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802049:	55                   	push   %ebp
  80204a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80204c:	6a 00                	push   $0x0
  80204e:	6a 00                	push   $0x0
  802050:	ff 75 10             	pushl  0x10(%ebp)
  802053:	ff 75 0c             	pushl  0xc(%ebp)
  802056:	ff 75 08             	pushl  0x8(%ebp)
  802059:	6a 11                	push   $0x11
  80205b:	e8 7a fe ff ff       	call   801eda <syscall>
  802060:	83 c4 18             	add    $0x18,%esp
	return ;
  802063:	90                   	nop
}
  802064:	c9                   	leave  
  802065:	c3                   	ret    

00802066 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802066:	55                   	push   %ebp
  802067:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802069:	6a 00                	push   $0x0
  80206b:	6a 00                	push   $0x0
  80206d:	6a 00                	push   $0x0
  80206f:	6a 00                	push   $0x0
  802071:	6a 00                	push   $0x0
  802073:	6a 0c                	push   $0xc
  802075:	e8 60 fe ff ff       	call   801eda <syscall>
  80207a:	83 c4 18             	add    $0x18,%esp
}
  80207d:	c9                   	leave  
  80207e:	c3                   	ret    

0080207f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80207f:	55                   	push   %ebp
  802080:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802082:	6a 00                	push   $0x0
  802084:	6a 00                	push   $0x0
  802086:	6a 00                	push   $0x0
  802088:	6a 00                	push   $0x0
  80208a:	ff 75 08             	pushl  0x8(%ebp)
  80208d:	6a 0d                	push   $0xd
  80208f:	e8 46 fe ff ff       	call   801eda <syscall>
  802094:	83 c4 18             	add    $0x18,%esp
}
  802097:	c9                   	leave  
  802098:	c3                   	ret    

00802099 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802099:	55                   	push   %ebp
  80209a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80209c:	6a 00                	push   $0x0
  80209e:	6a 00                	push   $0x0
  8020a0:	6a 00                	push   $0x0
  8020a2:	6a 00                	push   $0x0
  8020a4:	6a 00                	push   $0x0
  8020a6:	6a 0e                	push   $0xe
  8020a8:	e8 2d fe ff ff       	call   801eda <syscall>
  8020ad:	83 c4 18             	add    $0x18,%esp
}
  8020b0:	90                   	nop
  8020b1:	c9                   	leave  
  8020b2:	c3                   	ret    

008020b3 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8020b3:	55                   	push   %ebp
  8020b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8020b6:	6a 00                	push   $0x0
  8020b8:	6a 00                	push   $0x0
  8020ba:	6a 00                	push   $0x0
  8020bc:	6a 00                	push   $0x0
  8020be:	6a 00                	push   $0x0
  8020c0:	6a 13                	push   $0x13
  8020c2:	e8 13 fe ff ff       	call   801eda <syscall>
  8020c7:	83 c4 18             	add    $0x18,%esp
}
  8020ca:	90                   	nop
  8020cb:	c9                   	leave  
  8020cc:	c3                   	ret    

008020cd <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8020cd:	55                   	push   %ebp
  8020ce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8020d0:	6a 00                	push   $0x0
  8020d2:	6a 00                	push   $0x0
  8020d4:	6a 00                	push   $0x0
  8020d6:	6a 00                	push   $0x0
  8020d8:	6a 00                	push   $0x0
  8020da:	6a 14                	push   $0x14
  8020dc:	e8 f9 fd ff ff       	call   801eda <syscall>
  8020e1:	83 c4 18             	add    $0x18,%esp
}
  8020e4:	90                   	nop
  8020e5:	c9                   	leave  
  8020e6:	c3                   	ret    

008020e7 <sys_cputc>:


void
sys_cputc(const char c)
{
  8020e7:	55                   	push   %ebp
  8020e8:	89 e5                	mov    %esp,%ebp
  8020ea:	83 ec 04             	sub    $0x4,%esp
  8020ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8020f3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020f7:	6a 00                	push   $0x0
  8020f9:	6a 00                	push   $0x0
  8020fb:	6a 00                	push   $0x0
  8020fd:	6a 00                	push   $0x0
  8020ff:	50                   	push   %eax
  802100:	6a 15                	push   $0x15
  802102:	e8 d3 fd ff ff       	call   801eda <syscall>
  802107:	83 c4 18             	add    $0x18,%esp
}
  80210a:	90                   	nop
  80210b:	c9                   	leave  
  80210c:	c3                   	ret    

0080210d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80210d:	55                   	push   %ebp
  80210e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802110:	6a 00                	push   $0x0
  802112:	6a 00                	push   $0x0
  802114:	6a 00                	push   $0x0
  802116:	6a 00                	push   $0x0
  802118:	6a 00                	push   $0x0
  80211a:	6a 16                	push   $0x16
  80211c:	e8 b9 fd ff ff       	call   801eda <syscall>
  802121:	83 c4 18             	add    $0x18,%esp
}
  802124:	90                   	nop
  802125:	c9                   	leave  
  802126:	c3                   	ret    

00802127 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802127:	55                   	push   %ebp
  802128:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80212a:	8b 45 08             	mov    0x8(%ebp),%eax
  80212d:	6a 00                	push   $0x0
  80212f:	6a 00                	push   $0x0
  802131:	6a 00                	push   $0x0
  802133:	ff 75 0c             	pushl  0xc(%ebp)
  802136:	50                   	push   %eax
  802137:	6a 17                	push   $0x17
  802139:	e8 9c fd ff ff       	call   801eda <syscall>
  80213e:	83 c4 18             	add    $0x18,%esp
}
  802141:	c9                   	leave  
  802142:	c3                   	ret    

00802143 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802143:	55                   	push   %ebp
  802144:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802146:	8b 55 0c             	mov    0xc(%ebp),%edx
  802149:	8b 45 08             	mov    0x8(%ebp),%eax
  80214c:	6a 00                	push   $0x0
  80214e:	6a 00                	push   $0x0
  802150:	6a 00                	push   $0x0
  802152:	52                   	push   %edx
  802153:	50                   	push   %eax
  802154:	6a 1a                	push   $0x1a
  802156:	e8 7f fd ff ff       	call   801eda <syscall>
  80215b:	83 c4 18             	add    $0x18,%esp
}
  80215e:	c9                   	leave  
  80215f:	c3                   	ret    

00802160 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802160:	55                   	push   %ebp
  802161:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802163:	8b 55 0c             	mov    0xc(%ebp),%edx
  802166:	8b 45 08             	mov    0x8(%ebp),%eax
  802169:	6a 00                	push   $0x0
  80216b:	6a 00                	push   $0x0
  80216d:	6a 00                	push   $0x0
  80216f:	52                   	push   %edx
  802170:	50                   	push   %eax
  802171:	6a 18                	push   $0x18
  802173:	e8 62 fd ff ff       	call   801eda <syscall>
  802178:	83 c4 18             	add    $0x18,%esp
}
  80217b:	90                   	nop
  80217c:	c9                   	leave  
  80217d:	c3                   	ret    

0080217e <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80217e:	55                   	push   %ebp
  80217f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802181:	8b 55 0c             	mov    0xc(%ebp),%edx
  802184:	8b 45 08             	mov    0x8(%ebp),%eax
  802187:	6a 00                	push   $0x0
  802189:	6a 00                	push   $0x0
  80218b:	6a 00                	push   $0x0
  80218d:	52                   	push   %edx
  80218e:	50                   	push   %eax
  80218f:	6a 19                	push   $0x19
  802191:	e8 44 fd ff ff       	call   801eda <syscall>
  802196:	83 c4 18             	add    $0x18,%esp
}
  802199:	90                   	nop
  80219a:	c9                   	leave  
  80219b:	c3                   	ret    

0080219c <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80219c:	55                   	push   %ebp
  80219d:	89 e5                	mov    %esp,%ebp
  80219f:	83 ec 04             	sub    $0x4,%esp
  8021a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8021a5:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8021a8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8021ab:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8021af:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b2:	6a 00                	push   $0x0
  8021b4:	51                   	push   %ecx
  8021b5:	52                   	push   %edx
  8021b6:	ff 75 0c             	pushl  0xc(%ebp)
  8021b9:	50                   	push   %eax
  8021ba:	6a 1b                	push   $0x1b
  8021bc:	e8 19 fd ff ff       	call   801eda <syscall>
  8021c1:	83 c4 18             	add    $0x18,%esp
}
  8021c4:	c9                   	leave  
  8021c5:	c3                   	ret    

008021c6 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8021c6:	55                   	push   %ebp
  8021c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8021c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cf:	6a 00                	push   $0x0
  8021d1:	6a 00                	push   $0x0
  8021d3:	6a 00                	push   $0x0
  8021d5:	52                   	push   %edx
  8021d6:	50                   	push   %eax
  8021d7:	6a 1c                	push   $0x1c
  8021d9:	e8 fc fc ff ff       	call   801eda <syscall>
  8021de:	83 c4 18             	add    $0x18,%esp
}
  8021e1:	c9                   	leave  
  8021e2:	c3                   	ret    

008021e3 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8021e3:	55                   	push   %ebp
  8021e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8021e6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ef:	6a 00                	push   $0x0
  8021f1:	6a 00                	push   $0x0
  8021f3:	51                   	push   %ecx
  8021f4:	52                   	push   %edx
  8021f5:	50                   	push   %eax
  8021f6:	6a 1d                	push   $0x1d
  8021f8:	e8 dd fc ff ff       	call   801eda <syscall>
  8021fd:	83 c4 18             	add    $0x18,%esp
}
  802200:	c9                   	leave  
  802201:	c3                   	ret    

00802202 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802202:	55                   	push   %ebp
  802203:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802205:	8b 55 0c             	mov    0xc(%ebp),%edx
  802208:	8b 45 08             	mov    0x8(%ebp),%eax
  80220b:	6a 00                	push   $0x0
  80220d:	6a 00                	push   $0x0
  80220f:	6a 00                	push   $0x0
  802211:	52                   	push   %edx
  802212:	50                   	push   %eax
  802213:	6a 1e                	push   $0x1e
  802215:	e8 c0 fc ff ff       	call   801eda <syscall>
  80221a:	83 c4 18             	add    $0x18,%esp
}
  80221d:	c9                   	leave  
  80221e:	c3                   	ret    

0080221f <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80221f:	55                   	push   %ebp
  802220:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802222:	6a 00                	push   $0x0
  802224:	6a 00                	push   $0x0
  802226:	6a 00                	push   $0x0
  802228:	6a 00                	push   $0x0
  80222a:	6a 00                	push   $0x0
  80222c:	6a 1f                	push   $0x1f
  80222e:	e8 a7 fc ff ff       	call   801eda <syscall>
  802233:	83 c4 18             	add    $0x18,%esp
}
  802236:	c9                   	leave  
  802237:	c3                   	ret    

00802238 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802238:	55                   	push   %ebp
  802239:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80223b:	8b 45 08             	mov    0x8(%ebp),%eax
  80223e:	6a 00                	push   $0x0
  802240:	ff 75 14             	pushl  0x14(%ebp)
  802243:	ff 75 10             	pushl  0x10(%ebp)
  802246:	ff 75 0c             	pushl  0xc(%ebp)
  802249:	50                   	push   %eax
  80224a:	6a 20                	push   $0x20
  80224c:	e8 89 fc ff ff       	call   801eda <syscall>
  802251:	83 c4 18             	add    $0x18,%esp
}
  802254:	c9                   	leave  
  802255:	c3                   	ret    

00802256 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802256:	55                   	push   %ebp
  802257:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802259:	8b 45 08             	mov    0x8(%ebp),%eax
  80225c:	6a 00                	push   $0x0
  80225e:	6a 00                	push   $0x0
  802260:	6a 00                	push   $0x0
  802262:	6a 00                	push   $0x0
  802264:	50                   	push   %eax
  802265:	6a 21                	push   $0x21
  802267:	e8 6e fc ff ff       	call   801eda <syscall>
  80226c:	83 c4 18             	add    $0x18,%esp
}
  80226f:	90                   	nop
  802270:	c9                   	leave  
  802271:	c3                   	ret    

00802272 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802272:	55                   	push   %ebp
  802273:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802275:	8b 45 08             	mov    0x8(%ebp),%eax
  802278:	6a 00                	push   $0x0
  80227a:	6a 00                	push   $0x0
  80227c:	6a 00                	push   $0x0
  80227e:	6a 00                	push   $0x0
  802280:	50                   	push   %eax
  802281:	6a 22                	push   $0x22
  802283:	e8 52 fc ff ff       	call   801eda <syscall>
  802288:	83 c4 18             	add    $0x18,%esp
}
  80228b:	c9                   	leave  
  80228c:	c3                   	ret    

0080228d <sys_getenvid>:

int32 sys_getenvid(void)
{
  80228d:	55                   	push   %ebp
  80228e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802290:	6a 00                	push   $0x0
  802292:	6a 00                	push   $0x0
  802294:	6a 00                	push   $0x0
  802296:	6a 00                	push   $0x0
  802298:	6a 00                	push   $0x0
  80229a:	6a 02                	push   $0x2
  80229c:	e8 39 fc ff ff       	call   801eda <syscall>
  8022a1:	83 c4 18             	add    $0x18,%esp
}
  8022a4:	c9                   	leave  
  8022a5:	c3                   	ret    

008022a6 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8022a6:	55                   	push   %ebp
  8022a7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8022a9:	6a 00                	push   $0x0
  8022ab:	6a 00                	push   $0x0
  8022ad:	6a 00                	push   $0x0
  8022af:	6a 00                	push   $0x0
  8022b1:	6a 00                	push   $0x0
  8022b3:	6a 03                	push   $0x3
  8022b5:	e8 20 fc ff ff       	call   801eda <syscall>
  8022ba:	83 c4 18             	add    $0x18,%esp
}
  8022bd:	c9                   	leave  
  8022be:	c3                   	ret    

008022bf <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8022bf:	55                   	push   %ebp
  8022c0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8022c2:	6a 00                	push   $0x0
  8022c4:	6a 00                	push   $0x0
  8022c6:	6a 00                	push   $0x0
  8022c8:	6a 00                	push   $0x0
  8022ca:	6a 00                	push   $0x0
  8022cc:	6a 04                	push   $0x4
  8022ce:	e8 07 fc ff ff       	call   801eda <syscall>
  8022d3:	83 c4 18             	add    $0x18,%esp
}
  8022d6:	c9                   	leave  
  8022d7:	c3                   	ret    

008022d8 <sys_exit_env>:


void sys_exit_env(void)
{
  8022d8:	55                   	push   %ebp
  8022d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8022db:	6a 00                	push   $0x0
  8022dd:	6a 00                	push   $0x0
  8022df:	6a 00                	push   $0x0
  8022e1:	6a 00                	push   $0x0
  8022e3:	6a 00                	push   $0x0
  8022e5:	6a 23                	push   $0x23
  8022e7:	e8 ee fb ff ff       	call   801eda <syscall>
  8022ec:	83 c4 18             	add    $0x18,%esp
}
  8022ef:	90                   	nop
  8022f0:	c9                   	leave  
  8022f1:	c3                   	ret    

008022f2 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8022f2:	55                   	push   %ebp
  8022f3:	89 e5                	mov    %esp,%ebp
  8022f5:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8022f8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022fb:	8d 50 04             	lea    0x4(%eax),%edx
  8022fe:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802301:	6a 00                	push   $0x0
  802303:	6a 00                	push   $0x0
  802305:	6a 00                	push   $0x0
  802307:	52                   	push   %edx
  802308:	50                   	push   %eax
  802309:	6a 24                	push   $0x24
  80230b:	e8 ca fb ff ff       	call   801eda <syscall>
  802310:	83 c4 18             	add    $0x18,%esp
	return result;
  802313:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802316:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802319:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80231c:	89 01                	mov    %eax,(%ecx)
  80231e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802321:	8b 45 08             	mov    0x8(%ebp),%eax
  802324:	c9                   	leave  
  802325:	c2 04 00             	ret    $0x4

00802328 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802328:	55                   	push   %ebp
  802329:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80232b:	6a 00                	push   $0x0
  80232d:	6a 00                	push   $0x0
  80232f:	ff 75 10             	pushl  0x10(%ebp)
  802332:	ff 75 0c             	pushl  0xc(%ebp)
  802335:	ff 75 08             	pushl  0x8(%ebp)
  802338:	6a 12                	push   $0x12
  80233a:	e8 9b fb ff ff       	call   801eda <syscall>
  80233f:	83 c4 18             	add    $0x18,%esp
	return ;
  802342:	90                   	nop
}
  802343:	c9                   	leave  
  802344:	c3                   	ret    

00802345 <sys_rcr2>:
uint32 sys_rcr2()
{
  802345:	55                   	push   %ebp
  802346:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802348:	6a 00                	push   $0x0
  80234a:	6a 00                	push   $0x0
  80234c:	6a 00                	push   $0x0
  80234e:	6a 00                	push   $0x0
  802350:	6a 00                	push   $0x0
  802352:	6a 25                	push   $0x25
  802354:	e8 81 fb ff ff       	call   801eda <syscall>
  802359:	83 c4 18             	add    $0x18,%esp
}
  80235c:	c9                   	leave  
  80235d:	c3                   	ret    

0080235e <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80235e:	55                   	push   %ebp
  80235f:	89 e5                	mov    %esp,%ebp
  802361:	83 ec 04             	sub    $0x4,%esp
  802364:	8b 45 08             	mov    0x8(%ebp),%eax
  802367:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80236a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80236e:	6a 00                	push   $0x0
  802370:	6a 00                	push   $0x0
  802372:	6a 00                	push   $0x0
  802374:	6a 00                	push   $0x0
  802376:	50                   	push   %eax
  802377:	6a 26                	push   $0x26
  802379:	e8 5c fb ff ff       	call   801eda <syscall>
  80237e:	83 c4 18             	add    $0x18,%esp
	return ;
  802381:	90                   	nop
}
  802382:	c9                   	leave  
  802383:	c3                   	ret    

00802384 <rsttst>:
void rsttst()
{
  802384:	55                   	push   %ebp
  802385:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802387:	6a 00                	push   $0x0
  802389:	6a 00                	push   $0x0
  80238b:	6a 00                	push   $0x0
  80238d:	6a 00                	push   $0x0
  80238f:	6a 00                	push   $0x0
  802391:	6a 28                	push   $0x28
  802393:	e8 42 fb ff ff       	call   801eda <syscall>
  802398:	83 c4 18             	add    $0x18,%esp
	return ;
  80239b:	90                   	nop
}
  80239c:	c9                   	leave  
  80239d:	c3                   	ret    

0080239e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80239e:	55                   	push   %ebp
  80239f:	89 e5                	mov    %esp,%ebp
  8023a1:	83 ec 04             	sub    $0x4,%esp
  8023a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8023a7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8023aa:	8b 55 18             	mov    0x18(%ebp),%edx
  8023ad:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8023b1:	52                   	push   %edx
  8023b2:	50                   	push   %eax
  8023b3:	ff 75 10             	pushl  0x10(%ebp)
  8023b6:	ff 75 0c             	pushl  0xc(%ebp)
  8023b9:	ff 75 08             	pushl  0x8(%ebp)
  8023bc:	6a 27                	push   $0x27
  8023be:	e8 17 fb ff ff       	call   801eda <syscall>
  8023c3:	83 c4 18             	add    $0x18,%esp
	return ;
  8023c6:	90                   	nop
}
  8023c7:	c9                   	leave  
  8023c8:	c3                   	ret    

008023c9 <chktst>:
void chktst(uint32 n)
{
  8023c9:	55                   	push   %ebp
  8023ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8023cc:	6a 00                	push   $0x0
  8023ce:	6a 00                	push   $0x0
  8023d0:	6a 00                	push   $0x0
  8023d2:	6a 00                	push   $0x0
  8023d4:	ff 75 08             	pushl  0x8(%ebp)
  8023d7:	6a 29                	push   $0x29
  8023d9:	e8 fc fa ff ff       	call   801eda <syscall>
  8023de:	83 c4 18             	add    $0x18,%esp
	return ;
  8023e1:	90                   	nop
}
  8023e2:	c9                   	leave  
  8023e3:	c3                   	ret    

008023e4 <inctst>:

void inctst()
{
  8023e4:	55                   	push   %ebp
  8023e5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8023e7:	6a 00                	push   $0x0
  8023e9:	6a 00                	push   $0x0
  8023eb:	6a 00                	push   $0x0
  8023ed:	6a 00                	push   $0x0
  8023ef:	6a 00                	push   $0x0
  8023f1:	6a 2a                	push   $0x2a
  8023f3:	e8 e2 fa ff ff       	call   801eda <syscall>
  8023f8:	83 c4 18             	add    $0x18,%esp
	return ;
  8023fb:	90                   	nop
}
  8023fc:	c9                   	leave  
  8023fd:	c3                   	ret    

008023fe <gettst>:
uint32 gettst()
{
  8023fe:	55                   	push   %ebp
  8023ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802401:	6a 00                	push   $0x0
  802403:	6a 00                	push   $0x0
  802405:	6a 00                	push   $0x0
  802407:	6a 00                	push   $0x0
  802409:	6a 00                	push   $0x0
  80240b:	6a 2b                	push   $0x2b
  80240d:	e8 c8 fa ff ff       	call   801eda <syscall>
  802412:	83 c4 18             	add    $0x18,%esp
}
  802415:	c9                   	leave  
  802416:	c3                   	ret    

00802417 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802417:	55                   	push   %ebp
  802418:	89 e5                	mov    %esp,%ebp
  80241a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80241d:	6a 00                	push   $0x0
  80241f:	6a 00                	push   $0x0
  802421:	6a 00                	push   $0x0
  802423:	6a 00                	push   $0x0
  802425:	6a 00                	push   $0x0
  802427:	6a 2c                	push   $0x2c
  802429:	e8 ac fa ff ff       	call   801eda <syscall>
  80242e:	83 c4 18             	add    $0x18,%esp
  802431:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802434:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802438:	75 07                	jne    802441 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80243a:	b8 01 00 00 00       	mov    $0x1,%eax
  80243f:	eb 05                	jmp    802446 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802441:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802446:	c9                   	leave  
  802447:	c3                   	ret    

00802448 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802448:	55                   	push   %ebp
  802449:	89 e5                	mov    %esp,%ebp
  80244b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80244e:	6a 00                	push   $0x0
  802450:	6a 00                	push   $0x0
  802452:	6a 00                	push   $0x0
  802454:	6a 00                	push   $0x0
  802456:	6a 00                	push   $0x0
  802458:	6a 2c                	push   $0x2c
  80245a:	e8 7b fa ff ff       	call   801eda <syscall>
  80245f:	83 c4 18             	add    $0x18,%esp
  802462:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802465:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802469:	75 07                	jne    802472 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80246b:	b8 01 00 00 00       	mov    $0x1,%eax
  802470:	eb 05                	jmp    802477 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802472:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802477:	c9                   	leave  
  802478:	c3                   	ret    

00802479 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802479:	55                   	push   %ebp
  80247a:	89 e5                	mov    %esp,%ebp
  80247c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80247f:	6a 00                	push   $0x0
  802481:	6a 00                	push   $0x0
  802483:	6a 00                	push   $0x0
  802485:	6a 00                	push   $0x0
  802487:	6a 00                	push   $0x0
  802489:	6a 2c                	push   $0x2c
  80248b:	e8 4a fa ff ff       	call   801eda <syscall>
  802490:	83 c4 18             	add    $0x18,%esp
  802493:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802496:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80249a:	75 07                	jne    8024a3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80249c:	b8 01 00 00 00       	mov    $0x1,%eax
  8024a1:	eb 05                	jmp    8024a8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8024a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024a8:	c9                   	leave  
  8024a9:	c3                   	ret    

008024aa <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8024aa:	55                   	push   %ebp
  8024ab:	89 e5                	mov    %esp,%ebp
  8024ad:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024b0:	6a 00                	push   $0x0
  8024b2:	6a 00                	push   $0x0
  8024b4:	6a 00                	push   $0x0
  8024b6:	6a 00                	push   $0x0
  8024b8:	6a 00                	push   $0x0
  8024ba:	6a 2c                	push   $0x2c
  8024bc:	e8 19 fa ff ff       	call   801eda <syscall>
  8024c1:	83 c4 18             	add    $0x18,%esp
  8024c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8024c7:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8024cb:	75 07                	jne    8024d4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8024cd:	b8 01 00 00 00       	mov    $0x1,%eax
  8024d2:	eb 05                	jmp    8024d9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8024d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024d9:	c9                   	leave  
  8024da:	c3                   	ret    

008024db <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8024db:	55                   	push   %ebp
  8024dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8024de:	6a 00                	push   $0x0
  8024e0:	6a 00                	push   $0x0
  8024e2:	6a 00                	push   $0x0
  8024e4:	6a 00                	push   $0x0
  8024e6:	ff 75 08             	pushl  0x8(%ebp)
  8024e9:	6a 2d                	push   $0x2d
  8024eb:	e8 ea f9 ff ff       	call   801eda <syscall>
  8024f0:	83 c4 18             	add    $0x18,%esp
	return ;
  8024f3:	90                   	nop
}
  8024f4:	c9                   	leave  
  8024f5:	c3                   	ret    

008024f6 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8024f6:	55                   	push   %ebp
  8024f7:	89 e5                	mov    %esp,%ebp
  8024f9:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8024fa:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8024fd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802500:	8b 55 0c             	mov    0xc(%ebp),%edx
  802503:	8b 45 08             	mov    0x8(%ebp),%eax
  802506:	6a 00                	push   $0x0
  802508:	53                   	push   %ebx
  802509:	51                   	push   %ecx
  80250a:	52                   	push   %edx
  80250b:	50                   	push   %eax
  80250c:	6a 2e                	push   $0x2e
  80250e:	e8 c7 f9 ff ff       	call   801eda <syscall>
  802513:	83 c4 18             	add    $0x18,%esp
}
  802516:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802519:	c9                   	leave  
  80251a:	c3                   	ret    

0080251b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80251b:	55                   	push   %ebp
  80251c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80251e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802521:	8b 45 08             	mov    0x8(%ebp),%eax
  802524:	6a 00                	push   $0x0
  802526:	6a 00                	push   $0x0
  802528:	6a 00                	push   $0x0
  80252a:	52                   	push   %edx
  80252b:	50                   	push   %eax
  80252c:	6a 2f                	push   $0x2f
  80252e:	e8 a7 f9 ff ff       	call   801eda <syscall>
  802533:	83 c4 18             	add    $0x18,%esp
}
  802536:	c9                   	leave  
  802537:	c3                   	ret    

00802538 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802538:	55                   	push   %ebp
  802539:	89 e5                	mov    %esp,%ebp
  80253b:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80253e:	83 ec 0c             	sub    $0xc,%esp
  802541:	68 d8 46 80 00       	push   $0x8046d8
  802546:	e8 40 e6 ff ff       	call   800b8b <cprintf>
  80254b:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80254e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802555:	83 ec 0c             	sub    $0xc,%esp
  802558:	68 04 47 80 00       	push   $0x804704
  80255d:	e8 29 e6 ff ff       	call   800b8b <cprintf>
  802562:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802565:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802569:	a1 38 51 80 00       	mov    0x805138,%eax
  80256e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802571:	eb 56                	jmp    8025c9 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802573:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802577:	74 1c                	je     802595 <print_mem_block_lists+0x5d>
  802579:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257c:	8b 50 08             	mov    0x8(%eax),%edx
  80257f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802582:	8b 48 08             	mov    0x8(%eax),%ecx
  802585:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802588:	8b 40 0c             	mov    0xc(%eax),%eax
  80258b:	01 c8                	add    %ecx,%eax
  80258d:	39 c2                	cmp    %eax,%edx
  80258f:	73 04                	jae    802595 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802591:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802595:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802598:	8b 50 08             	mov    0x8(%eax),%edx
  80259b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259e:	8b 40 0c             	mov    0xc(%eax),%eax
  8025a1:	01 c2                	add    %eax,%edx
  8025a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a6:	8b 40 08             	mov    0x8(%eax),%eax
  8025a9:	83 ec 04             	sub    $0x4,%esp
  8025ac:	52                   	push   %edx
  8025ad:	50                   	push   %eax
  8025ae:	68 19 47 80 00       	push   $0x804719
  8025b3:	e8 d3 e5 ff ff       	call   800b8b <cprintf>
  8025b8:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8025bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025be:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8025c1:	a1 40 51 80 00       	mov    0x805140,%eax
  8025c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025cd:	74 07                	je     8025d6 <print_mem_block_lists+0x9e>
  8025cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d2:	8b 00                	mov    (%eax),%eax
  8025d4:	eb 05                	jmp    8025db <print_mem_block_lists+0xa3>
  8025d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8025db:	a3 40 51 80 00       	mov    %eax,0x805140
  8025e0:	a1 40 51 80 00       	mov    0x805140,%eax
  8025e5:	85 c0                	test   %eax,%eax
  8025e7:	75 8a                	jne    802573 <print_mem_block_lists+0x3b>
  8025e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ed:	75 84                	jne    802573 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8025ef:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8025f3:	75 10                	jne    802605 <print_mem_block_lists+0xcd>
  8025f5:	83 ec 0c             	sub    $0xc,%esp
  8025f8:	68 28 47 80 00       	push   $0x804728
  8025fd:	e8 89 e5 ff ff       	call   800b8b <cprintf>
  802602:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802605:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80260c:	83 ec 0c             	sub    $0xc,%esp
  80260f:	68 4c 47 80 00       	push   $0x80474c
  802614:	e8 72 e5 ff ff       	call   800b8b <cprintf>
  802619:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80261c:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802620:	a1 40 50 80 00       	mov    0x805040,%eax
  802625:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802628:	eb 56                	jmp    802680 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80262a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80262e:	74 1c                	je     80264c <print_mem_block_lists+0x114>
  802630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802633:	8b 50 08             	mov    0x8(%eax),%edx
  802636:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802639:	8b 48 08             	mov    0x8(%eax),%ecx
  80263c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80263f:	8b 40 0c             	mov    0xc(%eax),%eax
  802642:	01 c8                	add    %ecx,%eax
  802644:	39 c2                	cmp    %eax,%edx
  802646:	73 04                	jae    80264c <print_mem_block_lists+0x114>
			sorted = 0 ;
  802648:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80264c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264f:	8b 50 08             	mov    0x8(%eax),%edx
  802652:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802655:	8b 40 0c             	mov    0xc(%eax),%eax
  802658:	01 c2                	add    %eax,%edx
  80265a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265d:	8b 40 08             	mov    0x8(%eax),%eax
  802660:	83 ec 04             	sub    $0x4,%esp
  802663:	52                   	push   %edx
  802664:	50                   	push   %eax
  802665:	68 19 47 80 00       	push   $0x804719
  80266a:	e8 1c e5 ff ff       	call   800b8b <cprintf>
  80266f:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802672:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802675:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802678:	a1 48 50 80 00       	mov    0x805048,%eax
  80267d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802680:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802684:	74 07                	je     80268d <print_mem_block_lists+0x155>
  802686:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802689:	8b 00                	mov    (%eax),%eax
  80268b:	eb 05                	jmp    802692 <print_mem_block_lists+0x15a>
  80268d:	b8 00 00 00 00       	mov    $0x0,%eax
  802692:	a3 48 50 80 00       	mov    %eax,0x805048
  802697:	a1 48 50 80 00       	mov    0x805048,%eax
  80269c:	85 c0                	test   %eax,%eax
  80269e:	75 8a                	jne    80262a <print_mem_block_lists+0xf2>
  8026a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026a4:	75 84                	jne    80262a <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8026a6:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8026aa:	75 10                	jne    8026bc <print_mem_block_lists+0x184>
  8026ac:	83 ec 0c             	sub    $0xc,%esp
  8026af:	68 64 47 80 00       	push   $0x804764
  8026b4:	e8 d2 e4 ff ff       	call   800b8b <cprintf>
  8026b9:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8026bc:	83 ec 0c             	sub    $0xc,%esp
  8026bf:	68 d8 46 80 00       	push   $0x8046d8
  8026c4:	e8 c2 e4 ff ff       	call   800b8b <cprintf>
  8026c9:	83 c4 10             	add    $0x10,%esp

}
  8026cc:	90                   	nop
  8026cd:	c9                   	leave  
  8026ce:	c3                   	ret    

008026cf <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8026cf:	55                   	push   %ebp
  8026d0:	89 e5                	mov    %esp,%ebp
  8026d2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8026d5:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8026dc:	00 00 00 
  8026df:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8026e6:	00 00 00 
  8026e9:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8026f0:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8026f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8026fa:	e9 9e 00 00 00       	jmp    80279d <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8026ff:	a1 50 50 80 00       	mov    0x805050,%eax
  802704:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802707:	c1 e2 04             	shl    $0x4,%edx
  80270a:	01 d0                	add    %edx,%eax
  80270c:	85 c0                	test   %eax,%eax
  80270e:	75 14                	jne    802724 <initialize_MemBlocksList+0x55>
  802710:	83 ec 04             	sub    $0x4,%esp
  802713:	68 8c 47 80 00       	push   $0x80478c
  802718:	6a 46                	push   $0x46
  80271a:	68 af 47 80 00       	push   $0x8047af
  80271f:	e8 b3 e1 ff ff       	call   8008d7 <_panic>
  802724:	a1 50 50 80 00       	mov    0x805050,%eax
  802729:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80272c:	c1 e2 04             	shl    $0x4,%edx
  80272f:	01 d0                	add    %edx,%eax
  802731:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802737:	89 10                	mov    %edx,(%eax)
  802739:	8b 00                	mov    (%eax),%eax
  80273b:	85 c0                	test   %eax,%eax
  80273d:	74 18                	je     802757 <initialize_MemBlocksList+0x88>
  80273f:	a1 48 51 80 00       	mov    0x805148,%eax
  802744:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80274a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80274d:	c1 e1 04             	shl    $0x4,%ecx
  802750:	01 ca                	add    %ecx,%edx
  802752:	89 50 04             	mov    %edx,0x4(%eax)
  802755:	eb 12                	jmp    802769 <initialize_MemBlocksList+0x9a>
  802757:	a1 50 50 80 00       	mov    0x805050,%eax
  80275c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80275f:	c1 e2 04             	shl    $0x4,%edx
  802762:	01 d0                	add    %edx,%eax
  802764:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802769:	a1 50 50 80 00       	mov    0x805050,%eax
  80276e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802771:	c1 e2 04             	shl    $0x4,%edx
  802774:	01 d0                	add    %edx,%eax
  802776:	a3 48 51 80 00       	mov    %eax,0x805148
  80277b:	a1 50 50 80 00       	mov    0x805050,%eax
  802780:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802783:	c1 e2 04             	shl    $0x4,%edx
  802786:	01 d0                	add    %edx,%eax
  802788:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80278f:	a1 54 51 80 00       	mov    0x805154,%eax
  802794:	40                   	inc    %eax
  802795:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  80279a:	ff 45 f4             	incl   -0xc(%ebp)
  80279d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027a3:	0f 82 56 ff ff ff    	jb     8026ff <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8027a9:	90                   	nop
  8027aa:	c9                   	leave  
  8027ab:	c3                   	ret    

008027ac <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8027ac:	55                   	push   %ebp
  8027ad:	89 e5                	mov    %esp,%ebp
  8027af:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8027b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b5:	8b 00                	mov    (%eax),%eax
  8027b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8027ba:	eb 19                	jmp    8027d5 <find_block+0x29>
	{
		if(va==point->sva)
  8027bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027bf:	8b 40 08             	mov    0x8(%eax),%eax
  8027c2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8027c5:	75 05                	jne    8027cc <find_block+0x20>
		   return point;
  8027c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027ca:	eb 36                	jmp    802802 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8027cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027cf:	8b 40 08             	mov    0x8(%eax),%eax
  8027d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8027d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8027d9:	74 07                	je     8027e2 <find_block+0x36>
  8027db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027de:	8b 00                	mov    (%eax),%eax
  8027e0:	eb 05                	jmp    8027e7 <find_block+0x3b>
  8027e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8027e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8027ea:	89 42 08             	mov    %eax,0x8(%edx)
  8027ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f0:	8b 40 08             	mov    0x8(%eax),%eax
  8027f3:	85 c0                	test   %eax,%eax
  8027f5:	75 c5                	jne    8027bc <find_block+0x10>
  8027f7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8027fb:	75 bf                	jne    8027bc <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8027fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802802:	c9                   	leave  
  802803:	c3                   	ret    

00802804 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802804:	55                   	push   %ebp
  802805:	89 e5                	mov    %esp,%ebp
  802807:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80280a:	a1 40 50 80 00       	mov    0x805040,%eax
  80280f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802812:	a1 44 50 80 00       	mov    0x805044,%eax
  802817:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80281a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80281d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802820:	74 24                	je     802846 <insert_sorted_allocList+0x42>
  802822:	8b 45 08             	mov    0x8(%ebp),%eax
  802825:	8b 50 08             	mov    0x8(%eax),%edx
  802828:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80282b:	8b 40 08             	mov    0x8(%eax),%eax
  80282e:	39 c2                	cmp    %eax,%edx
  802830:	76 14                	jbe    802846 <insert_sorted_allocList+0x42>
  802832:	8b 45 08             	mov    0x8(%ebp),%eax
  802835:	8b 50 08             	mov    0x8(%eax),%edx
  802838:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80283b:	8b 40 08             	mov    0x8(%eax),%eax
  80283e:	39 c2                	cmp    %eax,%edx
  802840:	0f 82 60 01 00 00    	jb     8029a6 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802846:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80284a:	75 65                	jne    8028b1 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80284c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802850:	75 14                	jne    802866 <insert_sorted_allocList+0x62>
  802852:	83 ec 04             	sub    $0x4,%esp
  802855:	68 8c 47 80 00       	push   $0x80478c
  80285a:	6a 6b                	push   $0x6b
  80285c:	68 af 47 80 00       	push   $0x8047af
  802861:	e8 71 e0 ff ff       	call   8008d7 <_panic>
  802866:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80286c:	8b 45 08             	mov    0x8(%ebp),%eax
  80286f:	89 10                	mov    %edx,(%eax)
  802871:	8b 45 08             	mov    0x8(%ebp),%eax
  802874:	8b 00                	mov    (%eax),%eax
  802876:	85 c0                	test   %eax,%eax
  802878:	74 0d                	je     802887 <insert_sorted_allocList+0x83>
  80287a:	a1 40 50 80 00       	mov    0x805040,%eax
  80287f:	8b 55 08             	mov    0x8(%ebp),%edx
  802882:	89 50 04             	mov    %edx,0x4(%eax)
  802885:	eb 08                	jmp    80288f <insert_sorted_allocList+0x8b>
  802887:	8b 45 08             	mov    0x8(%ebp),%eax
  80288a:	a3 44 50 80 00       	mov    %eax,0x805044
  80288f:	8b 45 08             	mov    0x8(%ebp),%eax
  802892:	a3 40 50 80 00       	mov    %eax,0x805040
  802897:	8b 45 08             	mov    0x8(%ebp),%eax
  80289a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028a1:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8028a6:	40                   	inc    %eax
  8028a7:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8028ac:	e9 dc 01 00 00       	jmp    802a8d <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8028b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b4:	8b 50 08             	mov    0x8(%eax),%edx
  8028b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ba:	8b 40 08             	mov    0x8(%eax),%eax
  8028bd:	39 c2                	cmp    %eax,%edx
  8028bf:	77 6c                	ja     80292d <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8028c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028c5:	74 06                	je     8028cd <insert_sorted_allocList+0xc9>
  8028c7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028cb:	75 14                	jne    8028e1 <insert_sorted_allocList+0xdd>
  8028cd:	83 ec 04             	sub    $0x4,%esp
  8028d0:	68 c8 47 80 00       	push   $0x8047c8
  8028d5:	6a 6f                	push   $0x6f
  8028d7:	68 af 47 80 00       	push   $0x8047af
  8028dc:	e8 f6 df ff ff       	call   8008d7 <_panic>
  8028e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e4:	8b 50 04             	mov    0x4(%eax),%edx
  8028e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ea:	89 50 04             	mov    %edx,0x4(%eax)
  8028ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028f3:	89 10                	mov    %edx,(%eax)
  8028f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f8:	8b 40 04             	mov    0x4(%eax),%eax
  8028fb:	85 c0                	test   %eax,%eax
  8028fd:	74 0d                	je     80290c <insert_sorted_allocList+0x108>
  8028ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802902:	8b 40 04             	mov    0x4(%eax),%eax
  802905:	8b 55 08             	mov    0x8(%ebp),%edx
  802908:	89 10                	mov    %edx,(%eax)
  80290a:	eb 08                	jmp    802914 <insert_sorted_allocList+0x110>
  80290c:	8b 45 08             	mov    0x8(%ebp),%eax
  80290f:	a3 40 50 80 00       	mov    %eax,0x805040
  802914:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802917:	8b 55 08             	mov    0x8(%ebp),%edx
  80291a:	89 50 04             	mov    %edx,0x4(%eax)
  80291d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802922:	40                   	inc    %eax
  802923:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802928:	e9 60 01 00 00       	jmp    802a8d <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80292d:	8b 45 08             	mov    0x8(%ebp),%eax
  802930:	8b 50 08             	mov    0x8(%eax),%edx
  802933:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802936:	8b 40 08             	mov    0x8(%eax),%eax
  802939:	39 c2                	cmp    %eax,%edx
  80293b:	0f 82 4c 01 00 00    	jb     802a8d <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802941:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802945:	75 14                	jne    80295b <insert_sorted_allocList+0x157>
  802947:	83 ec 04             	sub    $0x4,%esp
  80294a:	68 00 48 80 00       	push   $0x804800
  80294f:	6a 73                	push   $0x73
  802951:	68 af 47 80 00       	push   $0x8047af
  802956:	e8 7c df ff ff       	call   8008d7 <_panic>
  80295b:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802961:	8b 45 08             	mov    0x8(%ebp),%eax
  802964:	89 50 04             	mov    %edx,0x4(%eax)
  802967:	8b 45 08             	mov    0x8(%ebp),%eax
  80296a:	8b 40 04             	mov    0x4(%eax),%eax
  80296d:	85 c0                	test   %eax,%eax
  80296f:	74 0c                	je     80297d <insert_sorted_allocList+0x179>
  802971:	a1 44 50 80 00       	mov    0x805044,%eax
  802976:	8b 55 08             	mov    0x8(%ebp),%edx
  802979:	89 10                	mov    %edx,(%eax)
  80297b:	eb 08                	jmp    802985 <insert_sorted_allocList+0x181>
  80297d:	8b 45 08             	mov    0x8(%ebp),%eax
  802980:	a3 40 50 80 00       	mov    %eax,0x805040
  802985:	8b 45 08             	mov    0x8(%ebp),%eax
  802988:	a3 44 50 80 00       	mov    %eax,0x805044
  80298d:	8b 45 08             	mov    0x8(%ebp),%eax
  802990:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802996:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80299b:	40                   	inc    %eax
  80299c:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8029a1:	e9 e7 00 00 00       	jmp    802a8d <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8029a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8029ac:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8029b3:	a1 40 50 80 00       	mov    0x805040,%eax
  8029b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029bb:	e9 9d 00 00 00       	jmp    802a5d <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8029c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c3:	8b 00                	mov    (%eax),%eax
  8029c5:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8029c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cb:	8b 50 08             	mov    0x8(%eax),%edx
  8029ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d1:	8b 40 08             	mov    0x8(%eax),%eax
  8029d4:	39 c2                	cmp    %eax,%edx
  8029d6:	76 7d                	jbe    802a55 <insert_sorted_allocList+0x251>
  8029d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029db:	8b 50 08             	mov    0x8(%eax),%edx
  8029de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029e1:	8b 40 08             	mov    0x8(%eax),%eax
  8029e4:	39 c2                	cmp    %eax,%edx
  8029e6:	73 6d                	jae    802a55 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8029e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029ec:	74 06                	je     8029f4 <insert_sorted_allocList+0x1f0>
  8029ee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029f2:	75 14                	jne    802a08 <insert_sorted_allocList+0x204>
  8029f4:	83 ec 04             	sub    $0x4,%esp
  8029f7:	68 24 48 80 00       	push   $0x804824
  8029fc:	6a 7f                	push   $0x7f
  8029fe:	68 af 47 80 00       	push   $0x8047af
  802a03:	e8 cf de ff ff       	call   8008d7 <_panic>
  802a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0b:	8b 10                	mov    (%eax),%edx
  802a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a10:	89 10                	mov    %edx,(%eax)
  802a12:	8b 45 08             	mov    0x8(%ebp),%eax
  802a15:	8b 00                	mov    (%eax),%eax
  802a17:	85 c0                	test   %eax,%eax
  802a19:	74 0b                	je     802a26 <insert_sorted_allocList+0x222>
  802a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1e:	8b 00                	mov    (%eax),%eax
  802a20:	8b 55 08             	mov    0x8(%ebp),%edx
  802a23:	89 50 04             	mov    %edx,0x4(%eax)
  802a26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a29:	8b 55 08             	mov    0x8(%ebp),%edx
  802a2c:	89 10                	mov    %edx,(%eax)
  802a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a31:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a34:	89 50 04             	mov    %edx,0x4(%eax)
  802a37:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3a:	8b 00                	mov    (%eax),%eax
  802a3c:	85 c0                	test   %eax,%eax
  802a3e:	75 08                	jne    802a48 <insert_sorted_allocList+0x244>
  802a40:	8b 45 08             	mov    0x8(%ebp),%eax
  802a43:	a3 44 50 80 00       	mov    %eax,0x805044
  802a48:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a4d:	40                   	inc    %eax
  802a4e:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802a53:	eb 39                	jmp    802a8e <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802a55:	a1 48 50 80 00       	mov    0x805048,%eax
  802a5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a5d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a61:	74 07                	je     802a6a <insert_sorted_allocList+0x266>
  802a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a66:	8b 00                	mov    (%eax),%eax
  802a68:	eb 05                	jmp    802a6f <insert_sorted_allocList+0x26b>
  802a6a:	b8 00 00 00 00       	mov    $0x0,%eax
  802a6f:	a3 48 50 80 00       	mov    %eax,0x805048
  802a74:	a1 48 50 80 00       	mov    0x805048,%eax
  802a79:	85 c0                	test   %eax,%eax
  802a7b:	0f 85 3f ff ff ff    	jne    8029c0 <insert_sorted_allocList+0x1bc>
  802a81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a85:	0f 85 35 ff ff ff    	jne    8029c0 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802a8b:	eb 01                	jmp    802a8e <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802a8d:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802a8e:	90                   	nop
  802a8f:	c9                   	leave  
  802a90:	c3                   	ret    

00802a91 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802a91:	55                   	push   %ebp
  802a92:	89 e5                	mov    %esp,%ebp
  802a94:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802a97:	a1 38 51 80 00       	mov    0x805138,%eax
  802a9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a9f:	e9 85 01 00 00       	jmp    802c29 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa7:	8b 40 0c             	mov    0xc(%eax),%eax
  802aaa:	3b 45 08             	cmp    0x8(%ebp),%eax
  802aad:	0f 82 6e 01 00 00    	jb     802c21 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ab9:	3b 45 08             	cmp    0x8(%ebp),%eax
  802abc:	0f 85 8a 00 00 00    	jne    802b4c <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802ac2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ac6:	75 17                	jne    802adf <alloc_block_FF+0x4e>
  802ac8:	83 ec 04             	sub    $0x4,%esp
  802acb:	68 58 48 80 00       	push   $0x804858
  802ad0:	68 93 00 00 00       	push   $0x93
  802ad5:	68 af 47 80 00       	push   $0x8047af
  802ada:	e8 f8 dd ff ff       	call   8008d7 <_panic>
  802adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae2:	8b 00                	mov    (%eax),%eax
  802ae4:	85 c0                	test   %eax,%eax
  802ae6:	74 10                	je     802af8 <alloc_block_FF+0x67>
  802ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aeb:	8b 00                	mov    (%eax),%eax
  802aed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802af0:	8b 52 04             	mov    0x4(%edx),%edx
  802af3:	89 50 04             	mov    %edx,0x4(%eax)
  802af6:	eb 0b                	jmp    802b03 <alloc_block_FF+0x72>
  802af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afb:	8b 40 04             	mov    0x4(%eax),%eax
  802afe:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b06:	8b 40 04             	mov    0x4(%eax),%eax
  802b09:	85 c0                	test   %eax,%eax
  802b0b:	74 0f                	je     802b1c <alloc_block_FF+0x8b>
  802b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b10:	8b 40 04             	mov    0x4(%eax),%eax
  802b13:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b16:	8b 12                	mov    (%edx),%edx
  802b18:	89 10                	mov    %edx,(%eax)
  802b1a:	eb 0a                	jmp    802b26 <alloc_block_FF+0x95>
  802b1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1f:	8b 00                	mov    (%eax),%eax
  802b21:	a3 38 51 80 00       	mov    %eax,0x805138
  802b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b29:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b32:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b39:	a1 44 51 80 00       	mov    0x805144,%eax
  802b3e:	48                   	dec    %eax
  802b3f:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b47:	e9 10 01 00 00       	jmp    802c5c <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802b4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4f:	8b 40 0c             	mov    0xc(%eax),%eax
  802b52:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b55:	0f 86 c6 00 00 00    	jbe    802c21 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b5b:	a1 48 51 80 00       	mov    0x805148,%eax
  802b60:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b66:	8b 50 08             	mov    0x8(%eax),%edx
  802b69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b6c:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802b6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b72:	8b 55 08             	mov    0x8(%ebp),%edx
  802b75:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b78:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b7c:	75 17                	jne    802b95 <alloc_block_FF+0x104>
  802b7e:	83 ec 04             	sub    $0x4,%esp
  802b81:	68 58 48 80 00       	push   $0x804858
  802b86:	68 9b 00 00 00       	push   $0x9b
  802b8b:	68 af 47 80 00       	push   $0x8047af
  802b90:	e8 42 dd ff ff       	call   8008d7 <_panic>
  802b95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b98:	8b 00                	mov    (%eax),%eax
  802b9a:	85 c0                	test   %eax,%eax
  802b9c:	74 10                	je     802bae <alloc_block_FF+0x11d>
  802b9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba1:	8b 00                	mov    (%eax),%eax
  802ba3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ba6:	8b 52 04             	mov    0x4(%edx),%edx
  802ba9:	89 50 04             	mov    %edx,0x4(%eax)
  802bac:	eb 0b                	jmp    802bb9 <alloc_block_FF+0x128>
  802bae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb1:	8b 40 04             	mov    0x4(%eax),%eax
  802bb4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802bb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bbc:	8b 40 04             	mov    0x4(%eax),%eax
  802bbf:	85 c0                	test   %eax,%eax
  802bc1:	74 0f                	je     802bd2 <alloc_block_FF+0x141>
  802bc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc6:	8b 40 04             	mov    0x4(%eax),%eax
  802bc9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bcc:	8b 12                	mov    (%edx),%edx
  802bce:	89 10                	mov    %edx,(%eax)
  802bd0:	eb 0a                	jmp    802bdc <alloc_block_FF+0x14b>
  802bd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd5:	8b 00                	mov    (%eax),%eax
  802bd7:	a3 48 51 80 00       	mov    %eax,0x805148
  802bdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bdf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802be5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bef:	a1 54 51 80 00       	mov    0x805154,%eax
  802bf4:	48                   	dec    %eax
  802bf5:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfd:	8b 50 08             	mov    0x8(%eax),%edx
  802c00:	8b 45 08             	mov    0x8(%ebp),%eax
  802c03:	01 c2                	add    %eax,%edx
  802c05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c08:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802c0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0e:	8b 40 0c             	mov    0xc(%eax),%eax
  802c11:	2b 45 08             	sub    0x8(%ebp),%eax
  802c14:	89 c2                	mov    %eax,%edx
  802c16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c19:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802c1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c1f:	eb 3b                	jmp    802c5c <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802c21:	a1 40 51 80 00       	mov    0x805140,%eax
  802c26:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c29:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c2d:	74 07                	je     802c36 <alloc_block_FF+0x1a5>
  802c2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c32:	8b 00                	mov    (%eax),%eax
  802c34:	eb 05                	jmp    802c3b <alloc_block_FF+0x1aa>
  802c36:	b8 00 00 00 00       	mov    $0x0,%eax
  802c3b:	a3 40 51 80 00       	mov    %eax,0x805140
  802c40:	a1 40 51 80 00       	mov    0x805140,%eax
  802c45:	85 c0                	test   %eax,%eax
  802c47:	0f 85 57 fe ff ff    	jne    802aa4 <alloc_block_FF+0x13>
  802c4d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c51:	0f 85 4d fe ff ff    	jne    802aa4 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802c57:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c5c:	c9                   	leave  
  802c5d:	c3                   	ret    

00802c5e <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802c5e:	55                   	push   %ebp
  802c5f:	89 e5                	mov    %esp,%ebp
  802c61:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802c64:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802c6b:	a1 38 51 80 00       	mov    0x805138,%eax
  802c70:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c73:	e9 df 00 00 00       	jmp    802d57 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802c78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7b:	8b 40 0c             	mov    0xc(%eax),%eax
  802c7e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c81:	0f 82 c8 00 00 00    	jb     802d4f <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802c87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8a:	8b 40 0c             	mov    0xc(%eax),%eax
  802c8d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c90:	0f 85 8a 00 00 00    	jne    802d20 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802c96:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c9a:	75 17                	jne    802cb3 <alloc_block_BF+0x55>
  802c9c:	83 ec 04             	sub    $0x4,%esp
  802c9f:	68 58 48 80 00       	push   $0x804858
  802ca4:	68 b7 00 00 00       	push   $0xb7
  802ca9:	68 af 47 80 00       	push   $0x8047af
  802cae:	e8 24 dc ff ff       	call   8008d7 <_panic>
  802cb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb6:	8b 00                	mov    (%eax),%eax
  802cb8:	85 c0                	test   %eax,%eax
  802cba:	74 10                	je     802ccc <alloc_block_BF+0x6e>
  802cbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbf:	8b 00                	mov    (%eax),%eax
  802cc1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cc4:	8b 52 04             	mov    0x4(%edx),%edx
  802cc7:	89 50 04             	mov    %edx,0x4(%eax)
  802cca:	eb 0b                	jmp    802cd7 <alloc_block_BF+0x79>
  802ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccf:	8b 40 04             	mov    0x4(%eax),%eax
  802cd2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cda:	8b 40 04             	mov    0x4(%eax),%eax
  802cdd:	85 c0                	test   %eax,%eax
  802cdf:	74 0f                	je     802cf0 <alloc_block_BF+0x92>
  802ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce4:	8b 40 04             	mov    0x4(%eax),%eax
  802ce7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cea:	8b 12                	mov    (%edx),%edx
  802cec:	89 10                	mov    %edx,(%eax)
  802cee:	eb 0a                	jmp    802cfa <alloc_block_BF+0x9c>
  802cf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf3:	8b 00                	mov    (%eax),%eax
  802cf5:	a3 38 51 80 00       	mov    %eax,0x805138
  802cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d06:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d0d:	a1 44 51 80 00       	mov    0x805144,%eax
  802d12:	48                   	dec    %eax
  802d13:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802d18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1b:	e9 4d 01 00 00       	jmp    802e6d <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802d20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d23:	8b 40 0c             	mov    0xc(%eax),%eax
  802d26:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d29:	76 24                	jbe    802d4f <alloc_block_BF+0xf1>
  802d2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2e:	8b 40 0c             	mov    0xc(%eax),%eax
  802d31:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802d34:	73 19                	jae    802d4f <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802d36:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802d3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d40:	8b 40 0c             	mov    0xc(%eax),%eax
  802d43:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802d46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d49:	8b 40 08             	mov    0x8(%eax),%eax
  802d4c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802d4f:	a1 40 51 80 00       	mov    0x805140,%eax
  802d54:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d57:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d5b:	74 07                	je     802d64 <alloc_block_BF+0x106>
  802d5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d60:	8b 00                	mov    (%eax),%eax
  802d62:	eb 05                	jmp    802d69 <alloc_block_BF+0x10b>
  802d64:	b8 00 00 00 00       	mov    $0x0,%eax
  802d69:	a3 40 51 80 00       	mov    %eax,0x805140
  802d6e:	a1 40 51 80 00       	mov    0x805140,%eax
  802d73:	85 c0                	test   %eax,%eax
  802d75:	0f 85 fd fe ff ff    	jne    802c78 <alloc_block_BF+0x1a>
  802d7b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d7f:	0f 85 f3 fe ff ff    	jne    802c78 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802d85:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d89:	0f 84 d9 00 00 00    	je     802e68 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d8f:	a1 48 51 80 00       	mov    0x805148,%eax
  802d94:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802d97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d9a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d9d:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802da0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802da3:	8b 55 08             	mov    0x8(%ebp),%edx
  802da6:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802da9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802dad:	75 17                	jne    802dc6 <alloc_block_BF+0x168>
  802daf:	83 ec 04             	sub    $0x4,%esp
  802db2:	68 58 48 80 00       	push   $0x804858
  802db7:	68 c7 00 00 00       	push   $0xc7
  802dbc:	68 af 47 80 00       	push   $0x8047af
  802dc1:	e8 11 db ff ff       	call   8008d7 <_panic>
  802dc6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dc9:	8b 00                	mov    (%eax),%eax
  802dcb:	85 c0                	test   %eax,%eax
  802dcd:	74 10                	je     802ddf <alloc_block_BF+0x181>
  802dcf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dd2:	8b 00                	mov    (%eax),%eax
  802dd4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802dd7:	8b 52 04             	mov    0x4(%edx),%edx
  802dda:	89 50 04             	mov    %edx,0x4(%eax)
  802ddd:	eb 0b                	jmp    802dea <alloc_block_BF+0x18c>
  802ddf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802de2:	8b 40 04             	mov    0x4(%eax),%eax
  802de5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802dea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ded:	8b 40 04             	mov    0x4(%eax),%eax
  802df0:	85 c0                	test   %eax,%eax
  802df2:	74 0f                	je     802e03 <alloc_block_BF+0x1a5>
  802df4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802df7:	8b 40 04             	mov    0x4(%eax),%eax
  802dfa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802dfd:	8b 12                	mov    (%edx),%edx
  802dff:	89 10                	mov    %edx,(%eax)
  802e01:	eb 0a                	jmp    802e0d <alloc_block_BF+0x1af>
  802e03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e06:	8b 00                	mov    (%eax),%eax
  802e08:	a3 48 51 80 00       	mov    %eax,0x805148
  802e0d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e10:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e19:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e20:	a1 54 51 80 00       	mov    0x805154,%eax
  802e25:	48                   	dec    %eax
  802e26:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802e2b:	83 ec 08             	sub    $0x8,%esp
  802e2e:	ff 75 ec             	pushl  -0x14(%ebp)
  802e31:	68 38 51 80 00       	push   $0x805138
  802e36:	e8 71 f9 ff ff       	call   8027ac <find_block>
  802e3b:	83 c4 10             	add    $0x10,%esp
  802e3e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802e41:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e44:	8b 50 08             	mov    0x8(%eax),%edx
  802e47:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4a:	01 c2                	add    %eax,%edx
  802e4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e4f:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802e52:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e55:	8b 40 0c             	mov    0xc(%eax),%eax
  802e58:	2b 45 08             	sub    0x8(%ebp),%eax
  802e5b:	89 c2                	mov    %eax,%edx
  802e5d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e60:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802e63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e66:	eb 05                	jmp    802e6d <alloc_block_BF+0x20f>
	}
	return NULL;
  802e68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e6d:	c9                   	leave  
  802e6e:	c3                   	ret    

00802e6f <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802e6f:	55                   	push   %ebp
  802e70:	89 e5                	mov    %esp,%ebp
  802e72:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802e75:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e7a:	85 c0                	test   %eax,%eax
  802e7c:	0f 85 de 01 00 00    	jne    803060 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802e82:	a1 38 51 80 00       	mov    0x805138,%eax
  802e87:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e8a:	e9 9e 01 00 00       	jmp    80302d <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802e8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e92:	8b 40 0c             	mov    0xc(%eax),%eax
  802e95:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e98:	0f 82 87 01 00 00    	jb     803025 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802e9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ea4:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ea7:	0f 85 95 00 00 00    	jne    802f42 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802ead:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eb1:	75 17                	jne    802eca <alloc_block_NF+0x5b>
  802eb3:	83 ec 04             	sub    $0x4,%esp
  802eb6:	68 58 48 80 00       	push   $0x804858
  802ebb:	68 e0 00 00 00       	push   $0xe0
  802ec0:	68 af 47 80 00       	push   $0x8047af
  802ec5:	e8 0d da ff ff       	call   8008d7 <_panic>
  802eca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecd:	8b 00                	mov    (%eax),%eax
  802ecf:	85 c0                	test   %eax,%eax
  802ed1:	74 10                	je     802ee3 <alloc_block_NF+0x74>
  802ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed6:	8b 00                	mov    (%eax),%eax
  802ed8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802edb:	8b 52 04             	mov    0x4(%edx),%edx
  802ede:	89 50 04             	mov    %edx,0x4(%eax)
  802ee1:	eb 0b                	jmp    802eee <alloc_block_NF+0x7f>
  802ee3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee6:	8b 40 04             	mov    0x4(%eax),%eax
  802ee9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef1:	8b 40 04             	mov    0x4(%eax),%eax
  802ef4:	85 c0                	test   %eax,%eax
  802ef6:	74 0f                	je     802f07 <alloc_block_NF+0x98>
  802ef8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efb:	8b 40 04             	mov    0x4(%eax),%eax
  802efe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f01:	8b 12                	mov    (%edx),%edx
  802f03:	89 10                	mov    %edx,(%eax)
  802f05:	eb 0a                	jmp    802f11 <alloc_block_NF+0xa2>
  802f07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0a:	8b 00                	mov    (%eax),%eax
  802f0c:	a3 38 51 80 00       	mov    %eax,0x805138
  802f11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f14:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f24:	a1 44 51 80 00       	mov    0x805144,%eax
  802f29:	48                   	dec    %eax
  802f2a:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802f2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f32:	8b 40 08             	mov    0x8(%eax),%eax
  802f35:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   return  point;
  802f3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3d:	e9 f8 04 00 00       	jmp    80343a <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802f42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f45:	8b 40 0c             	mov    0xc(%eax),%eax
  802f48:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f4b:	0f 86 d4 00 00 00    	jbe    803025 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802f51:	a1 48 51 80 00       	mov    0x805148,%eax
  802f56:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802f59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5c:	8b 50 08             	mov    0x8(%eax),%edx
  802f5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f62:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802f65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f68:	8b 55 08             	mov    0x8(%ebp),%edx
  802f6b:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802f6e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f72:	75 17                	jne    802f8b <alloc_block_NF+0x11c>
  802f74:	83 ec 04             	sub    $0x4,%esp
  802f77:	68 58 48 80 00       	push   $0x804858
  802f7c:	68 e9 00 00 00       	push   $0xe9
  802f81:	68 af 47 80 00       	push   $0x8047af
  802f86:	e8 4c d9 ff ff       	call   8008d7 <_panic>
  802f8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f8e:	8b 00                	mov    (%eax),%eax
  802f90:	85 c0                	test   %eax,%eax
  802f92:	74 10                	je     802fa4 <alloc_block_NF+0x135>
  802f94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f97:	8b 00                	mov    (%eax),%eax
  802f99:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f9c:	8b 52 04             	mov    0x4(%edx),%edx
  802f9f:	89 50 04             	mov    %edx,0x4(%eax)
  802fa2:	eb 0b                	jmp    802faf <alloc_block_NF+0x140>
  802fa4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fa7:	8b 40 04             	mov    0x4(%eax),%eax
  802faa:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802faf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb2:	8b 40 04             	mov    0x4(%eax),%eax
  802fb5:	85 c0                	test   %eax,%eax
  802fb7:	74 0f                	je     802fc8 <alloc_block_NF+0x159>
  802fb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fbc:	8b 40 04             	mov    0x4(%eax),%eax
  802fbf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fc2:	8b 12                	mov    (%edx),%edx
  802fc4:	89 10                	mov    %edx,(%eax)
  802fc6:	eb 0a                	jmp    802fd2 <alloc_block_NF+0x163>
  802fc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fcb:	8b 00                	mov    (%eax),%eax
  802fcd:	a3 48 51 80 00       	mov    %eax,0x805148
  802fd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fd5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fde:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fe5:	a1 54 51 80 00       	mov    0x805154,%eax
  802fea:	48                   	dec    %eax
  802feb:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802ff0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff3:	8b 40 08             	mov    0x8(%eax),%eax
  802ff6:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   point->sva += size;
  802ffb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffe:	8b 50 08             	mov    0x8(%eax),%edx
  803001:	8b 45 08             	mov    0x8(%ebp),%eax
  803004:	01 c2                	add    %eax,%edx
  803006:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803009:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  80300c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300f:	8b 40 0c             	mov    0xc(%eax),%eax
  803012:	2b 45 08             	sub    0x8(%ebp),%eax
  803015:	89 c2                	mov    %eax,%edx
  803017:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301a:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  80301d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803020:	e9 15 04 00 00       	jmp    80343a <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  803025:	a1 40 51 80 00       	mov    0x805140,%eax
  80302a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80302d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803031:	74 07                	je     80303a <alloc_block_NF+0x1cb>
  803033:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803036:	8b 00                	mov    (%eax),%eax
  803038:	eb 05                	jmp    80303f <alloc_block_NF+0x1d0>
  80303a:	b8 00 00 00 00       	mov    $0x0,%eax
  80303f:	a3 40 51 80 00       	mov    %eax,0x805140
  803044:	a1 40 51 80 00       	mov    0x805140,%eax
  803049:	85 c0                	test   %eax,%eax
  80304b:	0f 85 3e fe ff ff    	jne    802e8f <alloc_block_NF+0x20>
  803051:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803055:	0f 85 34 fe ff ff    	jne    802e8f <alloc_block_NF+0x20>
  80305b:	e9 d5 03 00 00       	jmp    803435 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803060:	a1 38 51 80 00       	mov    0x805138,%eax
  803065:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803068:	e9 b1 01 00 00       	jmp    80321e <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  80306d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803070:	8b 50 08             	mov    0x8(%eax),%edx
  803073:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803078:	39 c2                	cmp    %eax,%edx
  80307a:	0f 82 96 01 00 00    	jb     803216 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  803080:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803083:	8b 40 0c             	mov    0xc(%eax),%eax
  803086:	3b 45 08             	cmp    0x8(%ebp),%eax
  803089:	0f 82 87 01 00 00    	jb     803216 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  80308f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803092:	8b 40 0c             	mov    0xc(%eax),%eax
  803095:	3b 45 08             	cmp    0x8(%ebp),%eax
  803098:	0f 85 95 00 00 00    	jne    803133 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80309e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030a2:	75 17                	jne    8030bb <alloc_block_NF+0x24c>
  8030a4:	83 ec 04             	sub    $0x4,%esp
  8030a7:	68 58 48 80 00       	push   $0x804858
  8030ac:	68 fc 00 00 00       	push   $0xfc
  8030b1:	68 af 47 80 00       	push   $0x8047af
  8030b6:	e8 1c d8 ff ff       	call   8008d7 <_panic>
  8030bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030be:	8b 00                	mov    (%eax),%eax
  8030c0:	85 c0                	test   %eax,%eax
  8030c2:	74 10                	je     8030d4 <alloc_block_NF+0x265>
  8030c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c7:	8b 00                	mov    (%eax),%eax
  8030c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030cc:	8b 52 04             	mov    0x4(%edx),%edx
  8030cf:	89 50 04             	mov    %edx,0x4(%eax)
  8030d2:	eb 0b                	jmp    8030df <alloc_block_NF+0x270>
  8030d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d7:	8b 40 04             	mov    0x4(%eax),%eax
  8030da:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e2:	8b 40 04             	mov    0x4(%eax),%eax
  8030e5:	85 c0                	test   %eax,%eax
  8030e7:	74 0f                	je     8030f8 <alloc_block_NF+0x289>
  8030e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ec:	8b 40 04             	mov    0x4(%eax),%eax
  8030ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030f2:	8b 12                	mov    (%edx),%edx
  8030f4:	89 10                	mov    %edx,(%eax)
  8030f6:	eb 0a                	jmp    803102 <alloc_block_NF+0x293>
  8030f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fb:	8b 00                	mov    (%eax),%eax
  8030fd:	a3 38 51 80 00       	mov    %eax,0x805138
  803102:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803105:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80310b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803115:	a1 44 51 80 00       	mov    0x805144,%eax
  80311a:	48                   	dec    %eax
  80311b:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803120:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803123:	8b 40 08             	mov    0x8(%eax),%eax
  803126:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  80312b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312e:	e9 07 03 00 00       	jmp    80343a <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803133:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803136:	8b 40 0c             	mov    0xc(%eax),%eax
  803139:	3b 45 08             	cmp    0x8(%ebp),%eax
  80313c:	0f 86 d4 00 00 00    	jbe    803216 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803142:	a1 48 51 80 00       	mov    0x805148,%eax
  803147:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  80314a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314d:	8b 50 08             	mov    0x8(%eax),%edx
  803150:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803153:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803156:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803159:	8b 55 08             	mov    0x8(%ebp),%edx
  80315c:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80315f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803163:	75 17                	jne    80317c <alloc_block_NF+0x30d>
  803165:	83 ec 04             	sub    $0x4,%esp
  803168:	68 58 48 80 00       	push   $0x804858
  80316d:	68 04 01 00 00       	push   $0x104
  803172:	68 af 47 80 00       	push   $0x8047af
  803177:	e8 5b d7 ff ff       	call   8008d7 <_panic>
  80317c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80317f:	8b 00                	mov    (%eax),%eax
  803181:	85 c0                	test   %eax,%eax
  803183:	74 10                	je     803195 <alloc_block_NF+0x326>
  803185:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803188:	8b 00                	mov    (%eax),%eax
  80318a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80318d:	8b 52 04             	mov    0x4(%edx),%edx
  803190:	89 50 04             	mov    %edx,0x4(%eax)
  803193:	eb 0b                	jmp    8031a0 <alloc_block_NF+0x331>
  803195:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803198:	8b 40 04             	mov    0x4(%eax),%eax
  80319b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a3:	8b 40 04             	mov    0x4(%eax),%eax
  8031a6:	85 c0                	test   %eax,%eax
  8031a8:	74 0f                	je     8031b9 <alloc_block_NF+0x34a>
  8031aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ad:	8b 40 04             	mov    0x4(%eax),%eax
  8031b0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031b3:	8b 12                	mov    (%edx),%edx
  8031b5:	89 10                	mov    %edx,(%eax)
  8031b7:	eb 0a                	jmp    8031c3 <alloc_block_NF+0x354>
  8031b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031bc:	8b 00                	mov    (%eax),%eax
  8031be:	a3 48 51 80 00       	mov    %eax,0x805148
  8031c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031d6:	a1 54 51 80 00       	mov    0x805154,%eax
  8031db:	48                   	dec    %eax
  8031dc:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8031e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e4:	8b 40 08             	mov    0x8(%eax),%eax
  8031e7:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  8031ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ef:	8b 50 08             	mov    0x8(%eax),%edx
  8031f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f5:	01 c2                	add    %eax,%edx
  8031f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031fa:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8031fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803200:	8b 40 0c             	mov    0xc(%eax),%eax
  803203:	2b 45 08             	sub    0x8(%ebp),%eax
  803206:	89 c2                	mov    %eax,%edx
  803208:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320b:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  80320e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803211:	e9 24 02 00 00       	jmp    80343a <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803216:	a1 40 51 80 00       	mov    0x805140,%eax
  80321b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80321e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803222:	74 07                	je     80322b <alloc_block_NF+0x3bc>
  803224:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803227:	8b 00                	mov    (%eax),%eax
  803229:	eb 05                	jmp    803230 <alloc_block_NF+0x3c1>
  80322b:	b8 00 00 00 00       	mov    $0x0,%eax
  803230:	a3 40 51 80 00       	mov    %eax,0x805140
  803235:	a1 40 51 80 00       	mov    0x805140,%eax
  80323a:	85 c0                	test   %eax,%eax
  80323c:	0f 85 2b fe ff ff    	jne    80306d <alloc_block_NF+0x1fe>
  803242:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803246:	0f 85 21 fe ff ff    	jne    80306d <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  80324c:	a1 38 51 80 00       	mov    0x805138,%eax
  803251:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803254:	e9 ae 01 00 00       	jmp    803407 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  803259:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325c:	8b 50 08             	mov    0x8(%eax),%edx
  80325f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803264:	39 c2                	cmp    %eax,%edx
  803266:	0f 83 93 01 00 00    	jae    8033ff <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  80326c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326f:	8b 40 0c             	mov    0xc(%eax),%eax
  803272:	3b 45 08             	cmp    0x8(%ebp),%eax
  803275:	0f 82 84 01 00 00    	jb     8033ff <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  80327b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80327e:	8b 40 0c             	mov    0xc(%eax),%eax
  803281:	3b 45 08             	cmp    0x8(%ebp),%eax
  803284:	0f 85 95 00 00 00    	jne    80331f <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80328a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80328e:	75 17                	jne    8032a7 <alloc_block_NF+0x438>
  803290:	83 ec 04             	sub    $0x4,%esp
  803293:	68 58 48 80 00       	push   $0x804858
  803298:	68 14 01 00 00       	push   $0x114
  80329d:	68 af 47 80 00       	push   $0x8047af
  8032a2:	e8 30 d6 ff ff       	call   8008d7 <_panic>
  8032a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032aa:	8b 00                	mov    (%eax),%eax
  8032ac:	85 c0                	test   %eax,%eax
  8032ae:	74 10                	je     8032c0 <alloc_block_NF+0x451>
  8032b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b3:	8b 00                	mov    (%eax),%eax
  8032b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032b8:	8b 52 04             	mov    0x4(%edx),%edx
  8032bb:	89 50 04             	mov    %edx,0x4(%eax)
  8032be:	eb 0b                	jmp    8032cb <alloc_block_NF+0x45c>
  8032c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c3:	8b 40 04             	mov    0x4(%eax),%eax
  8032c6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ce:	8b 40 04             	mov    0x4(%eax),%eax
  8032d1:	85 c0                	test   %eax,%eax
  8032d3:	74 0f                	je     8032e4 <alloc_block_NF+0x475>
  8032d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d8:	8b 40 04             	mov    0x4(%eax),%eax
  8032db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032de:	8b 12                	mov    (%edx),%edx
  8032e0:	89 10                	mov    %edx,(%eax)
  8032e2:	eb 0a                	jmp    8032ee <alloc_block_NF+0x47f>
  8032e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e7:	8b 00                	mov    (%eax),%eax
  8032e9:	a3 38 51 80 00       	mov    %eax,0x805138
  8032ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803301:	a1 44 51 80 00       	mov    0x805144,%eax
  803306:	48                   	dec    %eax
  803307:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  80330c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80330f:	8b 40 08             	mov    0x8(%eax),%eax
  803312:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  803317:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80331a:	e9 1b 01 00 00       	jmp    80343a <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80331f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803322:	8b 40 0c             	mov    0xc(%eax),%eax
  803325:	3b 45 08             	cmp    0x8(%ebp),%eax
  803328:	0f 86 d1 00 00 00    	jbe    8033ff <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80332e:	a1 48 51 80 00       	mov    0x805148,%eax
  803333:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  803336:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803339:	8b 50 08             	mov    0x8(%eax),%edx
  80333c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80333f:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803342:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803345:	8b 55 08             	mov    0x8(%ebp),%edx
  803348:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80334b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80334f:	75 17                	jne    803368 <alloc_block_NF+0x4f9>
  803351:	83 ec 04             	sub    $0x4,%esp
  803354:	68 58 48 80 00       	push   $0x804858
  803359:	68 1c 01 00 00       	push   $0x11c
  80335e:	68 af 47 80 00       	push   $0x8047af
  803363:	e8 6f d5 ff ff       	call   8008d7 <_panic>
  803368:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80336b:	8b 00                	mov    (%eax),%eax
  80336d:	85 c0                	test   %eax,%eax
  80336f:	74 10                	je     803381 <alloc_block_NF+0x512>
  803371:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803374:	8b 00                	mov    (%eax),%eax
  803376:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803379:	8b 52 04             	mov    0x4(%edx),%edx
  80337c:	89 50 04             	mov    %edx,0x4(%eax)
  80337f:	eb 0b                	jmp    80338c <alloc_block_NF+0x51d>
  803381:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803384:	8b 40 04             	mov    0x4(%eax),%eax
  803387:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80338c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80338f:	8b 40 04             	mov    0x4(%eax),%eax
  803392:	85 c0                	test   %eax,%eax
  803394:	74 0f                	je     8033a5 <alloc_block_NF+0x536>
  803396:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803399:	8b 40 04             	mov    0x4(%eax),%eax
  80339c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80339f:	8b 12                	mov    (%edx),%edx
  8033a1:	89 10                	mov    %edx,(%eax)
  8033a3:	eb 0a                	jmp    8033af <alloc_block_NF+0x540>
  8033a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033a8:	8b 00                	mov    (%eax),%eax
  8033aa:	a3 48 51 80 00       	mov    %eax,0x805148
  8033af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033bb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033c2:	a1 54 51 80 00       	mov    0x805154,%eax
  8033c7:	48                   	dec    %eax
  8033c8:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8033cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033d0:	8b 40 08             	mov    0x8(%eax),%eax
  8033d3:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  8033d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033db:	8b 50 08             	mov    0x8(%eax),%edx
  8033de:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e1:	01 c2                	add    %eax,%edx
  8033e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e6:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8033e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8033ef:	2b 45 08             	sub    0x8(%ebp),%eax
  8033f2:	89 c2                	mov    %eax,%edx
  8033f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f7:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8033fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033fd:	eb 3b                	jmp    80343a <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8033ff:	a1 40 51 80 00       	mov    0x805140,%eax
  803404:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803407:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80340b:	74 07                	je     803414 <alloc_block_NF+0x5a5>
  80340d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803410:	8b 00                	mov    (%eax),%eax
  803412:	eb 05                	jmp    803419 <alloc_block_NF+0x5aa>
  803414:	b8 00 00 00 00       	mov    $0x0,%eax
  803419:	a3 40 51 80 00       	mov    %eax,0x805140
  80341e:	a1 40 51 80 00       	mov    0x805140,%eax
  803423:	85 c0                	test   %eax,%eax
  803425:	0f 85 2e fe ff ff    	jne    803259 <alloc_block_NF+0x3ea>
  80342b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80342f:	0f 85 24 fe ff ff    	jne    803259 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  803435:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80343a:	c9                   	leave  
  80343b:	c3                   	ret    

0080343c <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80343c:	55                   	push   %ebp
  80343d:	89 e5                	mov    %esp,%ebp
  80343f:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  803442:	a1 38 51 80 00       	mov    0x805138,%eax
  803447:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  80344a:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80344f:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  803452:	a1 38 51 80 00       	mov    0x805138,%eax
  803457:	85 c0                	test   %eax,%eax
  803459:	74 14                	je     80346f <insert_sorted_with_merge_freeList+0x33>
  80345b:	8b 45 08             	mov    0x8(%ebp),%eax
  80345e:	8b 50 08             	mov    0x8(%eax),%edx
  803461:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803464:	8b 40 08             	mov    0x8(%eax),%eax
  803467:	39 c2                	cmp    %eax,%edx
  803469:	0f 87 9b 01 00 00    	ja     80360a <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  80346f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803473:	75 17                	jne    80348c <insert_sorted_with_merge_freeList+0x50>
  803475:	83 ec 04             	sub    $0x4,%esp
  803478:	68 8c 47 80 00       	push   $0x80478c
  80347d:	68 38 01 00 00       	push   $0x138
  803482:	68 af 47 80 00       	push   $0x8047af
  803487:	e8 4b d4 ff ff       	call   8008d7 <_panic>
  80348c:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803492:	8b 45 08             	mov    0x8(%ebp),%eax
  803495:	89 10                	mov    %edx,(%eax)
  803497:	8b 45 08             	mov    0x8(%ebp),%eax
  80349a:	8b 00                	mov    (%eax),%eax
  80349c:	85 c0                	test   %eax,%eax
  80349e:	74 0d                	je     8034ad <insert_sorted_with_merge_freeList+0x71>
  8034a0:	a1 38 51 80 00       	mov    0x805138,%eax
  8034a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8034a8:	89 50 04             	mov    %edx,0x4(%eax)
  8034ab:	eb 08                	jmp    8034b5 <insert_sorted_with_merge_freeList+0x79>
  8034ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b8:	a3 38 51 80 00       	mov    %eax,0x805138
  8034bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034c7:	a1 44 51 80 00       	mov    0x805144,%eax
  8034cc:	40                   	inc    %eax
  8034cd:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8034d2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8034d6:	0f 84 a8 06 00 00    	je     803b84 <insert_sorted_with_merge_freeList+0x748>
  8034dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8034df:	8b 50 08             	mov    0x8(%eax),%edx
  8034e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8034e8:	01 c2                	add    %eax,%edx
  8034ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034ed:	8b 40 08             	mov    0x8(%eax),%eax
  8034f0:	39 c2                	cmp    %eax,%edx
  8034f2:	0f 85 8c 06 00 00    	jne    803b84 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  8034f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fb:	8b 50 0c             	mov    0xc(%eax),%edx
  8034fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803501:	8b 40 0c             	mov    0xc(%eax),%eax
  803504:	01 c2                	add    %eax,%edx
  803506:	8b 45 08             	mov    0x8(%ebp),%eax
  803509:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  80350c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803510:	75 17                	jne    803529 <insert_sorted_with_merge_freeList+0xed>
  803512:	83 ec 04             	sub    $0x4,%esp
  803515:	68 58 48 80 00       	push   $0x804858
  80351a:	68 3c 01 00 00       	push   $0x13c
  80351f:	68 af 47 80 00       	push   $0x8047af
  803524:	e8 ae d3 ff ff       	call   8008d7 <_panic>
  803529:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80352c:	8b 00                	mov    (%eax),%eax
  80352e:	85 c0                	test   %eax,%eax
  803530:	74 10                	je     803542 <insert_sorted_with_merge_freeList+0x106>
  803532:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803535:	8b 00                	mov    (%eax),%eax
  803537:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80353a:	8b 52 04             	mov    0x4(%edx),%edx
  80353d:	89 50 04             	mov    %edx,0x4(%eax)
  803540:	eb 0b                	jmp    80354d <insert_sorted_with_merge_freeList+0x111>
  803542:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803545:	8b 40 04             	mov    0x4(%eax),%eax
  803548:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80354d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803550:	8b 40 04             	mov    0x4(%eax),%eax
  803553:	85 c0                	test   %eax,%eax
  803555:	74 0f                	je     803566 <insert_sorted_with_merge_freeList+0x12a>
  803557:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80355a:	8b 40 04             	mov    0x4(%eax),%eax
  80355d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803560:	8b 12                	mov    (%edx),%edx
  803562:	89 10                	mov    %edx,(%eax)
  803564:	eb 0a                	jmp    803570 <insert_sorted_with_merge_freeList+0x134>
  803566:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803569:	8b 00                	mov    (%eax),%eax
  80356b:	a3 38 51 80 00       	mov    %eax,0x805138
  803570:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803573:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803579:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80357c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803583:	a1 44 51 80 00       	mov    0x805144,%eax
  803588:	48                   	dec    %eax
  803589:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  80358e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803591:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803598:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80359b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  8035a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8035a6:	75 17                	jne    8035bf <insert_sorted_with_merge_freeList+0x183>
  8035a8:	83 ec 04             	sub    $0x4,%esp
  8035ab:	68 8c 47 80 00       	push   $0x80478c
  8035b0:	68 3f 01 00 00       	push   $0x13f
  8035b5:	68 af 47 80 00       	push   $0x8047af
  8035ba:	e8 18 d3 ff ff       	call   8008d7 <_panic>
  8035bf:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8035c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035c8:	89 10                	mov    %edx,(%eax)
  8035ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035cd:	8b 00                	mov    (%eax),%eax
  8035cf:	85 c0                	test   %eax,%eax
  8035d1:	74 0d                	je     8035e0 <insert_sorted_with_merge_freeList+0x1a4>
  8035d3:	a1 48 51 80 00       	mov    0x805148,%eax
  8035d8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035db:	89 50 04             	mov    %edx,0x4(%eax)
  8035de:	eb 08                	jmp    8035e8 <insert_sorted_with_merge_freeList+0x1ac>
  8035e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035e3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035eb:	a3 48 51 80 00       	mov    %eax,0x805148
  8035f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035fa:	a1 54 51 80 00       	mov    0x805154,%eax
  8035ff:	40                   	inc    %eax
  803600:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803605:	e9 7a 05 00 00       	jmp    803b84 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  80360a:	8b 45 08             	mov    0x8(%ebp),%eax
  80360d:	8b 50 08             	mov    0x8(%eax),%edx
  803610:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803613:	8b 40 08             	mov    0x8(%eax),%eax
  803616:	39 c2                	cmp    %eax,%edx
  803618:	0f 82 14 01 00 00    	jb     803732 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  80361e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803621:	8b 50 08             	mov    0x8(%eax),%edx
  803624:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803627:	8b 40 0c             	mov    0xc(%eax),%eax
  80362a:	01 c2                	add    %eax,%edx
  80362c:	8b 45 08             	mov    0x8(%ebp),%eax
  80362f:	8b 40 08             	mov    0x8(%eax),%eax
  803632:	39 c2                	cmp    %eax,%edx
  803634:	0f 85 90 00 00 00    	jne    8036ca <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  80363a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80363d:	8b 50 0c             	mov    0xc(%eax),%edx
  803640:	8b 45 08             	mov    0x8(%ebp),%eax
  803643:	8b 40 0c             	mov    0xc(%eax),%eax
  803646:	01 c2                	add    %eax,%edx
  803648:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80364b:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  80364e:	8b 45 08             	mov    0x8(%ebp),%eax
  803651:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803658:	8b 45 08             	mov    0x8(%ebp),%eax
  80365b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803662:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803666:	75 17                	jne    80367f <insert_sorted_with_merge_freeList+0x243>
  803668:	83 ec 04             	sub    $0x4,%esp
  80366b:	68 8c 47 80 00       	push   $0x80478c
  803670:	68 49 01 00 00       	push   $0x149
  803675:	68 af 47 80 00       	push   $0x8047af
  80367a:	e8 58 d2 ff ff       	call   8008d7 <_panic>
  80367f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803685:	8b 45 08             	mov    0x8(%ebp),%eax
  803688:	89 10                	mov    %edx,(%eax)
  80368a:	8b 45 08             	mov    0x8(%ebp),%eax
  80368d:	8b 00                	mov    (%eax),%eax
  80368f:	85 c0                	test   %eax,%eax
  803691:	74 0d                	je     8036a0 <insert_sorted_with_merge_freeList+0x264>
  803693:	a1 48 51 80 00       	mov    0x805148,%eax
  803698:	8b 55 08             	mov    0x8(%ebp),%edx
  80369b:	89 50 04             	mov    %edx,0x4(%eax)
  80369e:	eb 08                	jmp    8036a8 <insert_sorted_with_merge_freeList+0x26c>
  8036a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ab:	a3 48 51 80 00       	mov    %eax,0x805148
  8036b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036ba:	a1 54 51 80 00       	mov    0x805154,%eax
  8036bf:	40                   	inc    %eax
  8036c0:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8036c5:	e9 bb 04 00 00       	jmp    803b85 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8036ca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036ce:	75 17                	jne    8036e7 <insert_sorted_with_merge_freeList+0x2ab>
  8036d0:	83 ec 04             	sub    $0x4,%esp
  8036d3:	68 00 48 80 00       	push   $0x804800
  8036d8:	68 4c 01 00 00       	push   $0x14c
  8036dd:	68 af 47 80 00       	push   $0x8047af
  8036e2:	e8 f0 d1 ff ff       	call   8008d7 <_panic>
  8036e7:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8036ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f0:	89 50 04             	mov    %edx,0x4(%eax)
  8036f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f6:	8b 40 04             	mov    0x4(%eax),%eax
  8036f9:	85 c0                	test   %eax,%eax
  8036fb:	74 0c                	je     803709 <insert_sorted_with_merge_freeList+0x2cd>
  8036fd:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803702:	8b 55 08             	mov    0x8(%ebp),%edx
  803705:	89 10                	mov    %edx,(%eax)
  803707:	eb 08                	jmp    803711 <insert_sorted_with_merge_freeList+0x2d5>
  803709:	8b 45 08             	mov    0x8(%ebp),%eax
  80370c:	a3 38 51 80 00       	mov    %eax,0x805138
  803711:	8b 45 08             	mov    0x8(%ebp),%eax
  803714:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803719:	8b 45 08             	mov    0x8(%ebp),%eax
  80371c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803722:	a1 44 51 80 00       	mov    0x805144,%eax
  803727:	40                   	inc    %eax
  803728:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80372d:	e9 53 04 00 00       	jmp    803b85 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803732:	a1 38 51 80 00       	mov    0x805138,%eax
  803737:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80373a:	e9 15 04 00 00       	jmp    803b54 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  80373f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803742:	8b 00                	mov    (%eax),%eax
  803744:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803747:	8b 45 08             	mov    0x8(%ebp),%eax
  80374a:	8b 50 08             	mov    0x8(%eax),%edx
  80374d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803750:	8b 40 08             	mov    0x8(%eax),%eax
  803753:	39 c2                	cmp    %eax,%edx
  803755:	0f 86 f1 03 00 00    	jbe    803b4c <insert_sorted_with_merge_freeList+0x710>
  80375b:	8b 45 08             	mov    0x8(%ebp),%eax
  80375e:	8b 50 08             	mov    0x8(%eax),%edx
  803761:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803764:	8b 40 08             	mov    0x8(%eax),%eax
  803767:	39 c2                	cmp    %eax,%edx
  803769:	0f 83 dd 03 00 00    	jae    803b4c <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  80376f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803772:	8b 50 08             	mov    0x8(%eax),%edx
  803775:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803778:	8b 40 0c             	mov    0xc(%eax),%eax
  80377b:	01 c2                	add    %eax,%edx
  80377d:	8b 45 08             	mov    0x8(%ebp),%eax
  803780:	8b 40 08             	mov    0x8(%eax),%eax
  803783:	39 c2                	cmp    %eax,%edx
  803785:	0f 85 b9 01 00 00    	jne    803944 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80378b:	8b 45 08             	mov    0x8(%ebp),%eax
  80378e:	8b 50 08             	mov    0x8(%eax),%edx
  803791:	8b 45 08             	mov    0x8(%ebp),%eax
  803794:	8b 40 0c             	mov    0xc(%eax),%eax
  803797:	01 c2                	add    %eax,%edx
  803799:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80379c:	8b 40 08             	mov    0x8(%eax),%eax
  80379f:	39 c2                	cmp    %eax,%edx
  8037a1:	0f 85 0d 01 00 00    	jne    8038b4 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8037a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037aa:	8b 50 0c             	mov    0xc(%eax),%edx
  8037ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8037b3:	01 c2                	add    %eax,%edx
  8037b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b8:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8037bb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8037bf:	75 17                	jne    8037d8 <insert_sorted_with_merge_freeList+0x39c>
  8037c1:	83 ec 04             	sub    $0x4,%esp
  8037c4:	68 58 48 80 00       	push   $0x804858
  8037c9:	68 5c 01 00 00       	push   $0x15c
  8037ce:	68 af 47 80 00       	push   $0x8047af
  8037d3:	e8 ff d0 ff ff       	call   8008d7 <_panic>
  8037d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037db:	8b 00                	mov    (%eax),%eax
  8037dd:	85 c0                	test   %eax,%eax
  8037df:	74 10                	je     8037f1 <insert_sorted_with_merge_freeList+0x3b5>
  8037e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037e4:	8b 00                	mov    (%eax),%eax
  8037e6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037e9:	8b 52 04             	mov    0x4(%edx),%edx
  8037ec:	89 50 04             	mov    %edx,0x4(%eax)
  8037ef:	eb 0b                	jmp    8037fc <insert_sorted_with_merge_freeList+0x3c0>
  8037f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037f4:	8b 40 04             	mov    0x4(%eax),%eax
  8037f7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8037fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037ff:	8b 40 04             	mov    0x4(%eax),%eax
  803802:	85 c0                	test   %eax,%eax
  803804:	74 0f                	je     803815 <insert_sorted_with_merge_freeList+0x3d9>
  803806:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803809:	8b 40 04             	mov    0x4(%eax),%eax
  80380c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80380f:	8b 12                	mov    (%edx),%edx
  803811:	89 10                	mov    %edx,(%eax)
  803813:	eb 0a                	jmp    80381f <insert_sorted_with_merge_freeList+0x3e3>
  803815:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803818:	8b 00                	mov    (%eax),%eax
  80381a:	a3 38 51 80 00       	mov    %eax,0x805138
  80381f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803822:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803828:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80382b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803832:	a1 44 51 80 00       	mov    0x805144,%eax
  803837:	48                   	dec    %eax
  803838:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  80383d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803840:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803847:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80384a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803851:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803855:	75 17                	jne    80386e <insert_sorted_with_merge_freeList+0x432>
  803857:	83 ec 04             	sub    $0x4,%esp
  80385a:	68 8c 47 80 00       	push   $0x80478c
  80385f:	68 5f 01 00 00       	push   $0x15f
  803864:	68 af 47 80 00       	push   $0x8047af
  803869:	e8 69 d0 ff ff       	call   8008d7 <_panic>
  80386e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803874:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803877:	89 10                	mov    %edx,(%eax)
  803879:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80387c:	8b 00                	mov    (%eax),%eax
  80387e:	85 c0                	test   %eax,%eax
  803880:	74 0d                	je     80388f <insert_sorted_with_merge_freeList+0x453>
  803882:	a1 48 51 80 00       	mov    0x805148,%eax
  803887:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80388a:	89 50 04             	mov    %edx,0x4(%eax)
  80388d:	eb 08                	jmp    803897 <insert_sorted_with_merge_freeList+0x45b>
  80388f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803892:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803897:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80389a:	a3 48 51 80 00       	mov    %eax,0x805148
  80389f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038a2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038a9:	a1 54 51 80 00       	mov    0x805154,%eax
  8038ae:	40                   	inc    %eax
  8038af:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8038b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038b7:	8b 50 0c             	mov    0xc(%eax),%edx
  8038ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8038bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8038c0:	01 c2                	add    %eax,%edx
  8038c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038c5:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8038c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8038cb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8038d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8038dc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038e0:	75 17                	jne    8038f9 <insert_sorted_with_merge_freeList+0x4bd>
  8038e2:	83 ec 04             	sub    $0x4,%esp
  8038e5:	68 8c 47 80 00       	push   $0x80478c
  8038ea:	68 64 01 00 00       	push   $0x164
  8038ef:	68 af 47 80 00       	push   $0x8047af
  8038f4:	e8 de cf ff ff       	call   8008d7 <_panic>
  8038f9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8038ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803902:	89 10                	mov    %edx,(%eax)
  803904:	8b 45 08             	mov    0x8(%ebp),%eax
  803907:	8b 00                	mov    (%eax),%eax
  803909:	85 c0                	test   %eax,%eax
  80390b:	74 0d                	je     80391a <insert_sorted_with_merge_freeList+0x4de>
  80390d:	a1 48 51 80 00       	mov    0x805148,%eax
  803912:	8b 55 08             	mov    0x8(%ebp),%edx
  803915:	89 50 04             	mov    %edx,0x4(%eax)
  803918:	eb 08                	jmp    803922 <insert_sorted_with_merge_freeList+0x4e6>
  80391a:	8b 45 08             	mov    0x8(%ebp),%eax
  80391d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803922:	8b 45 08             	mov    0x8(%ebp),%eax
  803925:	a3 48 51 80 00       	mov    %eax,0x805148
  80392a:	8b 45 08             	mov    0x8(%ebp),%eax
  80392d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803934:	a1 54 51 80 00       	mov    0x805154,%eax
  803939:	40                   	inc    %eax
  80393a:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80393f:	e9 41 02 00 00       	jmp    803b85 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803944:	8b 45 08             	mov    0x8(%ebp),%eax
  803947:	8b 50 08             	mov    0x8(%eax),%edx
  80394a:	8b 45 08             	mov    0x8(%ebp),%eax
  80394d:	8b 40 0c             	mov    0xc(%eax),%eax
  803950:	01 c2                	add    %eax,%edx
  803952:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803955:	8b 40 08             	mov    0x8(%eax),%eax
  803958:	39 c2                	cmp    %eax,%edx
  80395a:	0f 85 7c 01 00 00    	jne    803adc <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803960:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803964:	74 06                	je     80396c <insert_sorted_with_merge_freeList+0x530>
  803966:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80396a:	75 17                	jne    803983 <insert_sorted_with_merge_freeList+0x547>
  80396c:	83 ec 04             	sub    $0x4,%esp
  80396f:	68 c8 47 80 00       	push   $0x8047c8
  803974:	68 69 01 00 00       	push   $0x169
  803979:	68 af 47 80 00       	push   $0x8047af
  80397e:	e8 54 cf ff ff       	call   8008d7 <_panic>
  803983:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803986:	8b 50 04             	mov    0x4(%eax),%edx
  803989:	8b 45 08             	mov    0x8(%ebp),%eax
  80398c:	89 50 04             	mov    %edx,0x4(%eax)
  80398f:	8b 45 08             	mov    0x8(%ebp),%eax
  803992:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803995:	89 10                	mov    %edx,(%eax)
  803997:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80399a:	8b 40 04             	mov    0x4(%eax),%eax
  80399d:	85 c0                	test   %eax,%eax
  80399f:	74 0d                	je     8039ae <insert_sorted_with_merge_freeList+0x572>
  8039a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039a4:	8b 40 04             	mov    0x4(%eax),%eax
  8039a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8039aa:	89 10                	mov    %edx,(%eax)
  8039ac:	eb 08                	jmp    8039b6 <insert_sorted_with_merge_freeList+0x57a>
  8039ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8039b1:	a3 38 51 80 00       	mov    %eax,0x805138
  8039b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8039bc:	89 50 04             	mov    %edx,0x4(%eax)
  8039bf:	a1 44 51 80 00       	mov    0x805144,%eax
  8039c4:	40                   	inc    %eax
  8039c5:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8039ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8039cd:	8b 50 0c             	mov    0xc(%eax),%edx
  8039d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8039d6:	01 c2                	add    %eax,%edx
  8039d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8039db:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8039de:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8039e2:	75 17                	jne    8039fb <insert_sorted_with_merge_freeList+0x5bf>
  8039e4:	83 ec 04             	sub    $0x4,%esp
  8039e7:	68 58 48 80 00       	push   $0x804858
  8039ec:	68 6b 01 00 00       	push   $0x16b
  8039f1:	68 af 47 80 00       	push   $0x8047af
  8039f6:	e8 dc ce ff ff       	call   8008d7 <_panic>
  8039fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039fe:	8b 00                	mov    (%eax),%eax
  803a00:	85 c0                	test   %eax,%eax
  803a02:	74 10                	je     803a14 <insert_sorted_with_merge_freeList+0x5d8>
  803a04:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a07:	8b 00                	mov    (%eax),%eax
  803a09:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a0c:	8b 52 04             	mov    0x4(%edx),%edx
  803a0f:	89 50 04             	mov    %edx,0x4(%eax)
  803a12:	eb 0b                	jmp    803a1f <insert_sorted_with_merge_freeList+0x5e3>
  803a14:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a17:	8b 40 04             	mov    0x4(%eax),%eax
  803a1a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803a1f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a22:	8b 40 04             	mov    0x4(%eax),%eax
  803a25:	85 c0                	test   %eax,%eax
  803a27:	74 0f                	je     803a38 <insert_sorted_with_merge_freeList+0x5fc>
  803a29:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a2c:	8b 40 04             	mov    0x4(%eax),%eax
  803a2f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a32:	8b 12                	mov    (%edx),%edx
  803a34:	89 10                	mov    %edx,(%eax)
  803a36:	eb 0a                	jmp    803a42 <insert_sorted_with_merge_freeList+0x606>
  803a38:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a3b:	8b 00                	mov    (%eax),%eax
  803a3d:	a3 38 51 80 00       	mov    %eax,0x805138
  803a42:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a45:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a4b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a4e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a55:	a1 44 51 80 00       	mov    0x805144,%eax
  803a5a:	48                   	dec    %eax
  803a5b:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803a60:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a63:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803a6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a6d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803a74:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803a78:	75 17                	jne    803a91 <insert_sorted_with_merge_freeList+0x655>
  803a7a:	83 ec 04             	sub    $0x4,%esp
  803a7d:	68 8c 47 80 00       	push   $0x80478c
  803a82:	68 6e 01 00 00       	push   $0x16e
  803a87:	68 af 47 80 00       	push   $0x8047af
  803a8c:	e8 46 ce ff ff       	call   8008d7 <_panic>
  803a91:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a97:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a9a:	89 10                	mov    %edx,(%eax)
  803a9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a9f:	8b 00                	mov    (%eax),%eax
  803aa1:	85 c0                	test   %eax,%eax
  803aa3:	74 0d                	je     803ab2 <insert_sorted_with_merge_freeList+0x676>
  803aa5:	a1 48 51 80 00       	mov    0x805148,%eax
  803aaa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803aad:	89 50 04             	mov    %edx,0x4(%eax)
  803ab0:	eb 08                	jmp    803aba <insert_sorted_with_merge_freeList+0x67e>
  803ab2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ab5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803aba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803abd:	a3 48 51 80 00       	mov    %eax,0x805148
  803ac2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ac5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803acc:	a1 54 51 80 00       	mov    0x805154,%eax
  803ad1:	40                   	inc    %eax
  803ad2:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803ad7:	e9 a9 00 00 00       	jmp    803b85 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803adc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ae0:	74 06                	je     803ae8 <insert_sorted_with_merge_freeList+0x6ac>
  803ae2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803ae6:	75 17                	jne    803aff <insert_sorted_with_merge_freeList+0x6c3>
  803ae8:	83 ec 04             	sub    $0x4,%esp
  803aeb:	68 24 48 80 00       	push   $0x804824
  803af0:	68 73 01 00 00       	push   $0x173
  803af5:	68 af 47 80 00       	push   $0x8047af
  803afa:	e8 d8 cd ff ff       	call   8008d7 <_panic>
  803aff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b02:	8b 10                	mov    (%eax),%edx
  803b04:	8b 45 08             	mov    0x8(%ebp),%eax
  803b07:	89 10                	mov    %edx,(%eax)
  803b09:	8b 45 08             	mov    0x8(%ebp),%eax
  803b0c:	8b 00                	mov    (%eax),%eax
  803b0e:	85 c0                	test   %eax,%eax
  803b10:	74 0b                	je     803b1d <insert_sorted_with_merge_freeList+0x6e1>
  803b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b15:	8b 00                	mov    (%eax),%eax
  803b17:	8b 55 08             	mov    0x8(%ebp),%edx
  803b1a:	89 50 04             	mov    %edx,0x4(%eax)
  803b1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b20:	8b 55 08             	mov    0x8(%ebp),%edx
  803b23:	89 10                	mov    %edx,(%eax)
  803b25:	8b 45 08             	mov    0x8(%ebp),%eax
  803b28:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b2b:	89 50 04             	mov    %edx,0x4(%eax)
  803b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  803b31:	8b 00                	mov    (%eax),%eax
  803b33:	85 c0                	test   %eax,%eax
  803b35:	75 08                	jne    803b3f <insert_sorted_with_merge_freeList+0x703>
  803b37:	8b 45 08             	mov    0x8(%ebp),%eax
  803b3a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803b3f:	a1 44 51 80 00       	mov    0x805144,%eax
  803b44:	40                   	inc    %eax
  803b45:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803b4a:	eb 39                	jmp    803b85 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803b4c:	a1 40 51 80 00       	mov    0x805140,%eax
  803b51:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803b54:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b58:	74 07                	je     803b61 <insert_sorted_with_merge_freeList+0x725>
  803b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b5d:	8b 00                	mov    (%eax),%eax
  803b5f:	eb 05                	jmp    803b66 <insert_sorted_with_merge_freeList+0x72a>
  803b61:	b8 00 00 00 00       	mov    $0x0,%eax
  803b66:	a3 40 51 80 00       	mov    %eax,0x805140
  803b6b:	a1 40 51 80 00       	mov    0x805140,%eax
  803b70:	85 c0                	test   %eax,%eax
  803b72:	0f 85 c7 fb ff ff    	jne    80373f <insert_sorted_with_merge_freeList+0x303>
  803b78:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b7c:	0f 85 bd fb ff ff    	jne    80373f <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803b82:	eb 01                	jmp    803b85 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803b84:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803b85:	90                   	nop
  803b86:	c9                   	leave  
  803b87:	c3                   	ret    

00803b88 <__udivdi3>:
  803b88:	55                   	push   %ebp
  803b89:	57                   	push   %edi
  803b8a:	56                   	push   %esi
  803b8b:	53                   	push   %ebx
  803b8c:	83 ec 1c             	sub    $0x1c,%esp
  803b8f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803b93:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b97:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b9b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b9f:	89 ca                	mov    %ecx,%edx
  803ba1:	89 f8                	mov    %edi,%eax
  803ba3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803ba7:	85 f6                	test   %esi,%esi
  803ba9:	75 2d                	jne    803bd8 <__udivdi3+0x50>
  803bab:	39 cf                	cmp    %ecx,%edi
  803bad:	77 65                	ja     803c14 <__udivdi3+0x8c>
  803baf:	89 fd                	mov    %edi,%ebp
  803bb1:	85 ff                	test   %edi,%edi
  803bb3:	75 0b                	jne    803bc0 <__udivdi3+0x38>
  803bb5:	b8 01 00 00 00       	mov    $0x1,%eax
  803bba:	31 d2                	xor    %edx,%edx
  803bbc:	f7 f7                	div    %edi
  803bbe:	89 c5                	mov    %eax,%ebp
  803bc0:	31 d2                	xor    %edx,%edx
  803bc2:	89 c8                	mov    %ecx,%eax
  803bc4:	f7 f5                	div    %ebp
  803bc6:	89 c1                	mov    %eax,%ecx
  803bc8:	89 d8                	mov    %ebx,%eax
  803bca:	f7 f5                	div    %ebp
  803bcc:	89 cf                	mov    %ecx,%edi
  803bce:	89 fa                	mov    %edi,%edx
  803bd0:	83 c4 1c             	add    $0x1c,%esp
  803bd3:	5b                   	pop    %ebx
  803bd4:	5e                   	pop    %esi
  803bd5:	5f                   	pop    %edi
  803bd6:	5d                   	pop    %ebp
  803bd7:	c3                   	ret    
  803bd8:	39 ce                	cmp    %ecx,%esi
  803bda:	77 28                	ja     803c04 <__udivdi3+0x7c>
  803bdc:	0f bd fe             	bsr    %esi,%edi
  803bdf:	83 f7 1f             	xor    $0x1f,%edi
  803be2:	75 40                	jne    803c24 <__udivdi3+0x9c>
  803be4:	39 ce                	cmp    %ecx,%esi
  803be6:	72 0a                	jb     803bf2 <__udivdi3+0x6a>
  803be8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803bec:	0f 87 9e 00 00 00    	ja     803c90 <__udivdi3+0x108>
  803bf2:	b8 01 00 00 00       	mov    $0x1,%eax
  803bf7:	89 fa                	mov    %edi,%edx
  803bf9:	83 c4 1c             	add    $0x1c,%esp
  803bfc:	5b                   	pop    %ebx
  803bfd:	5e                   	pop    %esi
  803bfe:	5f                   	pop    %edi
  803bff:	5d                   	pop    %ebp
  803c00:	c3                   	ret    
  803c01:	8d 76 00             	lea    0x0(%esi),%esi
  803c04:	31 ff                	xor    %edi,%edi
  803c06:	31 c0                	xor    %eax,%eax
  803c08:	89 fa                	mov    %edi,%edx
  803c0a:	83 c4 1c             	add    $0x1c,%esp
  803c0d:	5b                   	pop    %ebx
  803c0e:	5e                   	pop    %esi
  803c0f:	5f                   	pop    %edi
  803c10:	5d                   	pop    %ebp
  803c11:	c3                   	ret    
  803c12:	66 90                	xchg   %ax,%ax
  803c14:	89 d8                	mov    %ebx,%eax
  803c16:	f7 f7                	div    %edi
  803c18:	31 ff                	xor    %edi,%edi
  803c1a:	89 fa                	mov    %edi,%edx
  803c1c:	83 c4 1c             	add    $0x1c,%esp
  803c1f:	5b                   	pop    %ebx
  803c20:	5e                   	pop    %esi
  803c21:	5f                   	pop    %edi
  803c22:	5d                   	pop    %ebp
  803c23:	c3                   	ret    
  803c24:	bd 20 00 00 00       	mov    $0x20,%ebp
  803c29:	89 eb                	mov    %ebp,%ebx
  803c2b:	29 fb                	sub    %edi,%ebx
  803c2d:	89 f9                	mov    %edi,%ecx
  803c2f:	d3 e6                	shl    %cl,%esi
  803c31:	89 c5                	mov    %eax,%ebp
  803c33:	88 d9                	mov    %bl,%cl
  803c35:	d3 ed                	shr    %cl,%ebp
  803c37:	89 e9                	mov    %ebp,%ecx
  803c39:	09 f1                	or     %esi,%ecx
  803c3b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803c3f:	89 f9                	mov    %edi,%ecx
  803c41:	d3 e0                	shl    %cl,%eax
  803c43:	89 c5                	mov    %eax,%ebp
  803c45:	89 d6                	mov    %edx,%esi
  803c47:	88 d9                	mov    %bl,%cl
  803c49:	d3 ee                	shr    %cl,%esi
  803c4b:	89 f9                	mov    %edi,%ecx
  803c4d:	d3 e2                	shl    %cl,%edx
  803c4f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c53:	88 d9                	mov    %bl,%cl
  803c55:	d3 e8                	shr    %cl,%eax
  803c57:	09 c2                	or     %eax,%edx
  803c59:	89 d0                	mov    %edx,%eax
  803c5b:	89 f2                	mov    %esi,%edx
  803c5d:	f7 74 24 0c          	divl   0xc(%esp)
  803c61:	89 d6                	mov    %edx,%esi
  803c63:	89 c3                	mov    %eax,%ebx
  803c65:	f7 e5                	mul    %ebp
  803c67:	39 d6                	cmp    %edx,%esi
  803c69:	72 19                	jb     803c84 <__udivdi3+0xfc>
  803c6b:	74 0b                	je     803c78 <__udivdi3+0xf0>
  803c6d:	89 d8                	mov    %ebx,%eax
  803c6f:	31 ff                	xor    %edi,%edi
  803c71:	e9 58 ff ff ff       	jmp    803bce <__udivdi3+0x46>
  803c76:	66 90                	xchg   %ax,%ax
  803c78:	8b 54 24 08          	mov    0x8(%esp),%edx
  803c7c:	89 f9                	mov    %edi,%ecx
  803c7e:	d3 e2                	shl    %cl,%edx
  803c80:	39 c2                	cmp    %eax,%edx
  803c82:	73 e9                	jae    803c6d <__udivdi3+0xe5>
  803c84:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803c87:	31 ff                	xor    %edi,%edi
  803c89:	e9 40 ff ff ff       	jmp    803bce <__udivdi3+0x46>
  803c8e:	66 90                	xchg   %ax,%ax
  803c90:	31 c0                	xor    %eax,%eax
  803c92:	e9 37 ff ff ff       	jmp    803bce <__udivdi3+0x46>
  803c97:	90                   	nop

00803c98 <__umoddi3>:
  803c98:	55                   	push   %ebp
  803c99:	57                   	push   %edi
  803c9a:	56                   	push   %esi
  803c9b:	53                   	push   %ebx
  803c9c:	83 ec 1c             	sub    $0x1c,%esp
  803c9f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803ca3:	8b 74 24 34          	mov    0x34(%esp),%esi
  803ca7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803cab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803caf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803cb3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803cb7:	89 f3                	mov    %esi,%ebx
  803cb9:	89 fa                	mov    %edi,%edx
  803cbb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803cbf:	89 34 24             	mov    %esi,(%esp)
  803cc2:	85 c0                	test   %eax,%eax
  803cc4:	75 1a                	jne    803ce0 <__umoddi3+0x48>
  803cc6:	39 f7                	cmp    %esi,%edi
  803cc8:	0f 86 a2 00 00 00    	jbe    803d70 <__umoddi3+0xd8>
  803cce:	89 c8                	mov    %ecx,%eax
  803cd0:	89 f2                	mov    %esi,%edx
  803cd2:	f7 f7                	div    %edi
  803cd4:	89 d0                	mov    %edx,%eax
  803cd6:	31 d2                	xor    %edx,%edx
  803cd8:	83 c4 1c             	add    $0x1c,%esp
  803cdb:	5b                   	pop    %ebx
  803cdc:	5e                   	pop    %esi
  803cdd:	5f                   	pop    %edi
  803cde:	5d                   	pop    %ebp
  803cdf:	c3                   	ret    
  803ce0:	39 f0                	cmp    %esi,%eax
  803ce2:	0f 87 ac 00 00 00    	ja     803d94 <__umoddi3+0xfc>
  803ce8:	0f bd e8             	bsr    %eax,%ebp
  803ceb:	83 f5 1f             	xor    $0x1f,%ebp
  803cee:	0f 84 ac 00 00 00    	je     803da0 <__umoddi3+0x108>
  803cf4:	bf 20 00 00 00       	mov    $0x20,%edi
  803cf9:	29 ef                	sub    %ebp,%edi
  803cfb:	89 fe                	mov    %edi,%esi
  803cfd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803d01:	89 e9                	mov    %ebp,%ecx
  803d03:	d3 e0                	shl    %cl,%eax
  803d05:	89 d7                	mov    %edx,%edi
  803d07:	89 f1                	mov    %esi,%ecx
  803d09:	d3 ef                	shr    %cl,%edi
  803d0b:	09 c7                	or     %eax,%edi
  803d0d:	89 e9                	mov    %ebp,%ecx
  803d0f:	d3 e2                	shl    %cl,%edx
  803d11:	89 14 24             	mov    %edx,(%esp)
  803d14:	89 d8                	mov    %ebx,%eax
  803d16:	d3 e0                	shl    %cl,%eax
  803d18:	89 c2                	mov    %eax,%edx
  803d1a:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d1e:	d3 e0                	shl    %cl,%eax
  803d20:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d24:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d28:	89 f1                	mov    %esi,%ecx
  803d2a:	d3 e8                	shr    %cl,%eax
  803d2c:	09 d0                	or     %edx,%eax
  803d2e:	d3 eb                	shr    %cl,%ebx
  803d30:	89 da                	mov    %ebx,%edx
  803d32:	f7 f7                	div    %edi
  803d34:	89 d3                	mov    %edx,%ebx
  803d36:	f7 24 24             	mull   (%esp)
  803d39:	89 c6                	mov    %eax,%esi
  803d3b:	89 d1                	mov    %edx,%ecx
  803d3d:	39 d3                	cmp    %edx,%ebx
  803d3f:	0f 82 87 00 00 00    	jb     803dcc <__umoddi3+0x134>
  803d45:	0f 84 91 00 00 00    	je     803ddc <__umoddi3+0x144>
  803d4b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803d4f:	29 f2                	sub    %esi,%edx
  803d51:	19 cb                	sbb    %ecx,%ebx
  803d53:	89 d8                	mov    %ebx,%eax
  803d55:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803d59:	d3 e0                	shl    %cl,%eax
  803d5b:	89 e9                	mov    %ebp,%ecx
  803d5d:	d3 ea                	shr    %cl,%edx
  803d5f:	09 d0                	or     %edx,%eax
  803d61:	89 e9                	mov    %ebp,%ecx
  803d63:	d3 eb                	shr    %cl,%ebx
  803d65:	89 da                	mov    %ebx,%edx
  803d67:	83 c4 1c             	add    $0x1c,%esp
  803d6a:	5b                   	pop    %ebx
  803d6b:	5e                   	pop    %esi
  803d6c:	5f                   	pop    %edi
  803d6d:	5d                   	pop    %ebp
  803d6e:	c3                   	ret    
  803d6f:	90                   	nop
  803d70:	89 fd                	mov    %edi,%ebp
  803d72:	85 ff                	test   %edi,%edi
  803d74:	75 0b                	jne    803d81 <__umoddi3+0xe9>
  803d76:	b8 01 00 00 00       	mov    $0x1,%eax
  803d7b:	31 d2                	xor    %edx,%edx
  803d7d:	f7 f7                	div    %edi
  803d7f:	89 c5                	mov    %eax,%ebp
  803d81:	89 f0                	mov    %esi,%eax
  803d83:	31 d2                	xor    %edx,%edx
  803d85:	f7 f5                	div    %ebp
  803d87:	89 c8                	mov    %ecx,%eax
  803d89:	f7 f5                	div    %ebp
  803d8b:	89 d0                	mov    %edx,%eax
  803d8d:	e9 44 ff ff ff       	jmp    803cd6 <__umoddi3+0x3e>
  803d92:	66 90                	xchg   %ax,%ax
  803d94:	89 c8                	mov    %ecx,%eax
  803d96:	89 f2                	mov    %esi,%edx
  803d98:	83 c4 1c             	add    $0x1c,%esp
  803d9b:	5b                   	pop    %ebx
  803d9c:	5e                   	pop    %esi
  803d9d:	5f                   	pop    %edi
  803d9e:	5d                   	pop    %ebp
  803d9f:	c3                   	ret    
  803da0:	3b 04 24             	cmp    (%esp),%eax
  803da3:	72 06                	jb     803dab <__umoddi3+0x113>
  803da5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803da9:	77 0f                	ja     803dba <__umoddi3+0x122>
  803dab:	89 f2                	mov    %esi,%edx
  803dad:	29 f9                	sub    %edi,%ecx
  803daf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803db3:	89 14 24             	mov    %edx,(%esp)
  803db6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803dba:	8b 44 24 04          	mov    0x4(%esp),%eax
  803dbe:	8b 14 24             	mov    (%esp),%edx
  803dc1:	83 c4 1c             	add    $0x1c,%esp
  803dc4:	5b                   	pop    %ebx
  803dc5:	5e                   	pop    %esi
  803dc6:	5f                   	pop    %edi
  803dc7:	5d                   	pop    %ebp
  803dc8:	c3                   	ret    
  803dc9:	8d 76 00             	lea    0x0(%esi),%esi
  803dcc:	2b 04 24             	sub    (%esp),%eax
  803dcf:	19 fa                	sbb    %edi,%edx
  803dd1:	89 d1                	mov    %edx,%ecx
  803dd3:	89 c6                	mov    %eax,%esi
  803dd5:	e9 71 ff ff ff       	jmp    803d4b <__umoddi3+0xb3>
  803dda:	66 90                	xchg   %ax,%ax
  803ddc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803de0:	72 ea                	jb     803dcc <__umoddi3+0x134>
  803de2:	89 d9                	mov    %ebx,%ecx
  803de4:	e9 62 ff ff ff       	jmp    803d4b <__umoddi3+0xb3>
