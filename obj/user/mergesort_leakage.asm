
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
  800041:	e8 48 20 00 00       	call   80208e <sys_disable_interrupt>

		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 e0 3d 80 00       	push   $0x803de0
  80004e:	e8 38 0b 00 00       	call   800b8b <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 e2 3d 80 00       	push   $0x803de2
  80005e:	e8 28 0b 00 00       	call   800b8b <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 f8 3d 80 00       	push   $0x803df8
  80006e:	e8 18 0b 00 00       	call   800b8b <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 e2 3d 80 00       	push   $0x803de2
  80007e:	e8 08 0b 00 00       	call   800b8b <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 e0 3d 80 00       	push   $0x803de0
  80008e:	e8 f8 0a 00 00       	call   800b8b <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 10 3e 80 00       	push   $0x803e10
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
  8000de:	68 30 3e 80 00       	push   $0x803e30
  8000e3:	e8 a3 0a 00 00       	call   800b8b <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 52 3e 80 00       	push   $0x803e52
  8000f3:	e8 93 0a 00 00       	call   800b8b <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 60 3e 80 00       	push   $0x803e60
  800103:	e8 83 0a 00 00       	call   800b8b <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 6f 3e 80 00       	push   $0x803e6f
  800113:	e8 73 0a 00 00       	call   800b8b <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 7f 3e 80 00       	push   $0x803e7f
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
  800162:	e8 41 1f 00 00       	call   8020a8 <sys_enable_interrupt>

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
  8001d7:	e8 b2 1e 00 00       	call   80208e <sys_disable_interrupt>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	68 88 3e 80 00       	push   $0x803e88
  8001e4:	e8 a2 09 00 00       	call   800b8b <cprintf>
  8001e9:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001ec:	e8 b7 1e 00 00       	call   8020a8 <sys_enable_interrupt>

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
  80020e:	68 bc 3e 80 00       	push   $0x803ebc
  800213:	6a 4a                	push   $0x4a
  800215:	68 de 3e 80 00       	push   $0x803ede
  80021a:	e8 b8 06 00 00       	call   8008d7 <_panic>
		else
		{
			sys_disable_interrupt();
  80021f:	e8 6a 1e 00 00       	call   80208e <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	68 f8 3e 80 00       	push   $0x803ef8
  80022c:	e8 5a 09 00 00       	call   800b8b <cprintf>
  800231:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	68 2c 3f 80 00       	push   $0x803f2c
  80023c:	e8 4a 09 00 00       	call   800b8b <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 60 3f 80 00       	push   $0x803f60
  80024c:	e8 3a 09 00 00       	call   800b8b <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800254:	e8 4f 1e 00 00       	call   8020a8 <sys_enable_interrupt>
		}

		//free(Elements) ;

		sys_disable_interrupt();
  800259:	e8 30 1e 00 00       	call   80208e <sys_disable_interrupt>
			Chose = 0 ;
  80025e:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800262:	eb 42                	jmp    8002a6 <_main+0x26e>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800264:	83 ec 0c             	sub    $0xc,%esp
  800267:	68 92 3f 80 00       	push   $0x803f92
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
  8002b2:	e8 f1 1d 00 00       	call   8020a8 <sys_enable_interrupt>

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
  800446:	68 e0 3d 80 00       	push   $0x803de0
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
  800468:	68 b0 3f 80 00       	push   $0x803fb0
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
  800496:	68 b5 3f 80 00       	push   $0x803fb5
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
  80070f:	e8 ae 19 00 00       	call   8020c2 <sys_cputc>
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
  800720:	e8 69 19 00 00       	call   80208e <sys_disable_interrupt>
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
  800733:	e8 8a 19 00 00       	call   8020c2 <sys_cputc>
  800738:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80073b:	e8 68 19 00 00       	call   8020a8 <sys_enable_interrupt>
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
  800752:	e8 b2 17 00 00       	call   801f09 <sys_cgetc>
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
  80076b:	e8 1e 19 00 00       	call   80208e <sys_disable_interrupt>
	int c=0;
  800770:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800777:	eb 08                	jmp    800781 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800779:	e8 8b 17 00 00       	call   801f09 <sys_cgetc>
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
  800787:	e8 1c 19 00 00       	call   8020a8 <sys_enable_interrupt>
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
  8007a1:	e8 db 1a 00 00       	call   802281 <sys_getenvindex>
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
  80080c:	e8 7d 18 00 00       	call   80208e <sys_disable_interrupt>
	cprintf("**************************************\n");
  800811:	83 ec 0c             	sub    $0xc,%esp
  800814:	68 d4 3f 80 00       	push   $0x803fd4
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
  80083c:	68 fc 3f 80 00       	push   $0x803ffc
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
  80086d:	68 24 40 80 00       	push   $0x804024
  800872:	e8 14 03 00 00       	call   800b8b <cprintf>
  800877:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80087a:	a1 24 50 80 00       	mov    0x805024,%eax
  80087f:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800885:	83 ec 08             	sub    $0x8,%esp
  800888:	50                   	push   %eax
  800889:	68 7c 40 80 00       	push   $0x80407c
  80088e:	e8 f8 02 00 00       	call   800b8b <cprintf>
  800893:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800896:	83 ec 0c             	sub    $0xc,%esp
  800899:	68 d4 3f 80 00       	push   $0x803fd4
  80089e:	e8 e8 02 00 00       	call   800b8b <cprintf>
  8008a3:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8008a6:	e8 fd 17 00 00       	call   8020a8 <sys_enable_interrupt>

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
  8008be:	e8 8a 19 00 00       	call   80224d <sys_destroy_env>
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
  8008cf:	e8 df 19 00 00       	call   8022b3 <sys_exit_env>
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
  8008f8:	68 90 40 80 00       	push   $0x804090
  8008fd:	e8 89 02 00 00       	call   800b8b <cprintf>
  800902:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800905:	a1 00 50 80 00       	mov    0x805000,%eax
  80090a:	ff 75 0c             	pushl  0xc(%ebp)
  80090d:	ff 75 08             	pushl  0x8(%ebp)
  800910:	50                   	push   %eax
  800911:	68 95 40 80 00       	push   $0x804095
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
  800935:	68 b1 40 80 00       	push   $0x8040b1
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
  800961:	68 b4 40 80 00       	push   $0x8040b4
  800966:	6a 26                	push   $0x26
  800968:	68 00 41 80 00       	push   $0x804100
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
  800a33:	68 0c 41 80 00       	push   $0x80410c
  800a38:	6a 3a                	push   $0x3a
  800a3a:	68 00 41 80 00       	push   $0x804100
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
  800aa3:	68 60 41 80 00       	push   $0x804160
  800aa8:	6a 44                	push   $0x44
  800aaa:	68 00 41 80 00       	push   $0x804100
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
  800afd:	e8 de 13 00 00       	call   801ee0 <sys_cputs>
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
  800b74:	e8 67 13 00 00       	call   801ee0 <sys_cputs>
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
  800bbe:	e8 cb 14 00 00       	call   80208e <sys_disable_interrupt>
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
  800bde:	e8 c5 14 00 00       	call   8020a8 <sys_enable_interrupt>
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
  800c28:	e8 37 2f 00 00       	call   803b64 <__udivdi3>
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
  800c78:	e8 f7 2f 00 00       	call   803c74 <__umoddi3>
  800c7d:	83 c4 10             	add    $0x10,%esp
  800c80:	05 d4 43 80 00       	add    $0x8043d4,%eax
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
  800dd3:	8b 04 85 f8 43 80 00 	mov    0x8043f8(,%eax,4),%eax
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
  800eb4:	8b 34 9d 40 42 80 00 	mov    0x804240(,%ebx,4),%esi
  800ebb:	85 f6                	test   %esi,%esi
  800ebd:	75 19                	jne    800ed8 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ebf:	53                   	push   %ebx
  800ec0:	68 e5 43 80 00       	push   $0x8043e5
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
  800ed9:	68 ee 43 80 00       	push   $0x8043ee
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
  800f06:	be f1 43 80 00       	mov    $0x8043f1,%esi
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
  80121f:	68 50 45 80 00       	push   $0x804550
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
  801261:	68 53 45 80 00       	push   $0x804553
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
  801311:	e8 78 0d 00 00       	call   80208e <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  801316:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80131a:	74 13                	je     80132f <atomic_readline+0x24>
		cprintf("%s", prompt);
  80131c:	83 ec 08             	sub    $0x8,%esp
  80131f:	ff 75 08             	pushl  0x8(%ebp)
  801322:	68 50 45 80 00       	push   $0x804550
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
  801360:	68 53 45 80 00       	push   $0x804553
  801365:	e8 21 f8 ff ff       	call   800b8b <cprintf>
  80136a:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  80136d:	e8 36 0d 00 00       	call   8020a8 <sys_enable_interrupt>
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
  801405:	e8 9e 0c 00 00       	call   8020a8 <sys_enable_interrupt>
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
  801b32:	68 64 45 80 00       	push   $0x804564
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
  801c02:	e8 1d 04 00 00       	call   802024 <sys_allocate_chunk>
  801c07:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801c0a:	a1 20 51 80 00       	mov    0x805120,%eax
  801c0f:	83 ec 0c             	sub    $0xc,%esp
  801c12:	50                   	push   %eax
  801c13:	e8 92 0a 00 00       	call   8026aa <initialize_MemBlocksList>
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
  801c40:	68 89 45 80 00       	push   $0x804589
  801c45:	6a 33                	push   $0x33
  801c47:	68 a7 45 80 00       	push   $0x8045a7
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
  801cbf:	68 b4 45 80 00       	push   $0x8045b4
  801cc4:	6a 34                	push   $0x34
  801cc6:	68 a7 45 80 00       	push   $0x8045a7
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
  801d34:	68 d8 45 80 00       	push   $0x8045d8
  801d39:	6a 46                	push   $0x46
  801d3b:	68 a7 45 80 00       	push   $0x8045a7
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
  801d50:	68 00 46 80 00       	push   $0x804600
  801d55:	6a 61                	push   $0x61
  801d57:	68 a7 45 80 00       	push   $0x8045a7
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
  801d76:	75 07                	jne    801d7f <smalloc+0x1e>
  801d78:	b8 00 00 00 00       	mov    $0x0,%eax
  801d7d:	eb 7c                	jmp    801dfb <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801d7f:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801d86:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d8c:	01 d0                	add    %edx,%eax
  801d8e:	48                   	dec    %eax
  801d8f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801d92:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d95:	ba 00 00 00 00       	mov    $0x0,%edx
  801d9a:	f7 75 f0             	divl   -0x10(%ebp)
  801d9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801da0:	29 d0                	sub    %edx,%eax
  801da2:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801da5:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801dac:	e8 41 06 00 00       	call   8023f2 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801db1:	85 c0                	test   %eax,%eax
  801db3:	74 11                	je     801dc6 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  801db5:	83 ec 0c             	sub    $0xc,%esp
  801db8:	ff 75 e8             	pushl  -0x18(%ebp)
  801dbb:	e8 ac 0c 00 00       	call   802a6c <alloc_block_FF>
  801dc0:	83 c4 10             	add    $0x10,%esp
  801dc3:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801dc6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dca:	74 2a                	je     801df6 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801dcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dcf:	8b 40 08             	mov    0x8(%eax),%eax
  801dd2:	89 c2                	mov    %eax,%edx
  801dd4:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801dd8:	52                   	push   %edx
  801dd9:	50                   	push   %eax
  801dda:	ff 75 0c             	pushl  0xc(%ebp)
  801ddd:	ff 75 08             	pushl  0x8(%ebp)
  801de0:	e8 92 03 00 00       	call   802177 <sys_createSharedObject>
  801de5:	83 c4 10             	add    $0x10,%esp
  801de8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  801deb:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  801def:	74 05                	je     801df6 <smalloc+0x95>
			return (void*)virtual_address;
  801df1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801df4:	eb 05                	jmp    801dfb <smalloc+0x9a>
	}
	return NULL;
  801df6:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801dfb:	c9                   	leave  
  801dfc:	c3                   	ret    

00801dfd <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801dfd:	55                   	push   %ebp
  801dfe:	89 e5                	mov    %esp,%ebp
  801e00:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e03:	e8 13 fd ff ff       	call   801b1b <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801e08:	83 ec 04             	sub    $0x4,%esp
  801e0b:	68 24 46 80 00       	push   $0x804624
  801e10:	68 a2 00 00 00       	push   $0xa2
  801e15:	68 a7 45 80 00       	push   $0x8045a7
  801e1a:	e8 b8 ea ff ff       	call   8008d7 <_panic>

00801e1f <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801e1f:	55                   	push   %ebp
  801e20:	89 e5                	mov    %esp,%ebp
  801e22:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e25:	e8 f1 fc ff ff       	call   801b1b <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801e2a:	83 ec 04             	sub    $0x4,%esp
  801e2d:	68 48 46 80 00       	push   $0x804648
  801e32:	68 e6 00 00 00       	push   $0xe6
  801e37:	68 a7 45 80 00       	push   $0x8045a7
  801e3c:	e8 96 ea ff ff       	call   8008d7 <_panic>

00801e41 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801e41:	55                   	push   %ebp
  801e42:	89 e5                	mov    %esp,%ebp
  801e44:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801e47:	83 ec 04             	sub    $0x4,%esp
  801e4a:	68 70 46 80 00       	push   $0x804670
  801e4f:	68 fa 00 00 00       	push   $0xfa
  801e54:	68 a7 45 80 00       	push   $0x8045a7
  801e59:	e8 79 ea ff ff       	call   8008d7 <_panic>

00801e5e <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801e5e:	55                   	push   %ebp
  801e5f:	89 e5                	mov    %esp,%ebp
  801e61:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e64:	83 ec 04             	sub    $0x4,%esp
  801e67:	68 94 46 80 00       	push   $0x804694
  801e6c:	68 05 01 00 00       	push   $0x105
  801e71:	68 a7 45 80 00       	push   $0x8045a7
  801e76:	e8 5c ea ff ff       	call   8008d7 <_panic>

00801e7b <shrink>:

}
void shrink(uint32 newSize)
{
  801e7b:	55                   	push   %ebp
  801e7c:	89 e5                	mov    %esp,%ebp
  801e7e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e81:	83 ec 04             	sub    $0x4,%esp
  801e84:	68 94 46 80 00       	push   $0x804694
  801e89:	68 0a 01 00 00       	push   $0x10a
  801e8e:	68 a7 45 80 00       	push   $0x8045a7
  801e93:	e8 3f ea ff ff       	call   8008d7 <_panic>

00801e98 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801e98:	55                   	push   %ebp
  801e99:	89 e5                	mov    %esp,%ebp
  801e9b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e9e:	83 ec 04             	sub    $0x4,%esp
  801ea1:	68 94 46 80 00       	push   $0x804694
  801ea6:	68 0f 01 00 00       	push   $0x10f
  801eab:	68 a7 45 80 00       	push   $0x8045a7
  801eb0:	e8 22 ea ff ff       	call   8008d7 <_panic>

00801eb5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801eb5:	55                   	push   %ebp
  801eb6:	89 e5                	mov    %esp,%ebp
  801eb8:	57                   	push   %edi
  801eb9:	56                   	push   %esi
  801eba:	53                   	push   %ebx
  801ebb:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ec4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ec7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801eca:	8b 7d 18             	mov    0x18(%ebp),%edi
  801ecd:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801ed0:	cd 30                	int    $0x30
  801ed2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801ed5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ed8:	83 c4 10             	add    $0x10,%esp
  801edb:	5b                   	pop    %ebx
  801edc:	5e                   	pop    %esi
  801edd:	5f                   	pop    %edi
  801ede:	5d                   	pop    %ebp
  801edf:	c3                   	ret    

00801ee0 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801ee0:	55                   	push   %ebp
  801ee1:	89 e5                	mov    %esp,%ebp
  801ee3:	83 ec 04             	sub    $0x4,%esp
  801ee6:	8b 45 10             	mov    0x10(%ebp),%eax
  801ee9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801eec:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef3:	6a 00                	push   $0x0
  801ef5:	6a 00                	push   $0x0
  801ef7:	52                   	push   %edx
  801ef8:	ff 75 0c             	pushl  0xc(%ebp)
  801efb:	50                   	push   %eax
  801efc:	6a 00                	push   $0x0
  801efe:	e8 b2 ff ff ff       	call   801eb5 <syscall>
  801f03:	83 c4 18             	add    $0x18,%esp
}
  801f06:	90                   	nop
  801f07:	c9                   	leave  
  801f08:	c3                   	ret    

00801f09 <sys_cgetc>:

int
sys_cgetc(void)
{
  801f09:	55                   	push   %ebp
  801f0a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801f0c:	6a 00                	push   $0x0
  801f0e:	6a 00                	push   $0x0
  801f10:	6a 00                	push   $0x0
  801f12:	6a 00                	push   $0x0
  801f14:	6a 00                	push   $0x0
  801f16:	6a 01                	push   $0x1
  801f18:	e8 98 ff ff ff       	call   801eb5 <syscall>
  801f1d:	83 c4 18             	add    $0x18,%esp
}
  801f20:	c9                   	leave  
  801f21:	c3                   	ret    

00801f22 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801f22:	55                   	push   %ebp
  801f23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801f25:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f28:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2b:	6a 00                	push   $0x0
  801f2d:	6a 00                	push   $0x0
  801f2f:	6a 00                	push   $0x0
  801f31:	52                   	push   %edx
  801f32:	50                   	push   %eax
  801f33:	6a 05                	push   $0x5
  801f35:	e8 7b ff ff ff       	call   801eb5 <syscall>
  801f3a:	83 c4 18             	add    $0x18,%esp
}
  801f3d:	c9                   	leave  
  801f3e:	c3                   	ret    

00801f3f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801f3f:	55                   	push   %ebp
  801f40:	89 e5                	mov    %esp,%ebp
  801f42:	56                   	push   %esi
  801f43:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801f44:	8b 75 18             	mov    0x18(%ebp),%esi
  801f47:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f4a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f50:	8b 45 08             	mov    0x8(%ebp),%eax
  801f53:	56                   	push   %esi
  801f54:	53                   	push   %ebx
  801f55:	51                   	push   %ecx
  801f56:	52                   	push   %edx
  801f57:	50                   	push   %eax
  801f58:	6a 06                	push   $0x6
  801f5a:	e8 56 ff ff ff       	call   801eb5 <syscall>
  801f5f:	83 c4 18             	add    $0x18,%esp
}
  801f62:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f65:	5b                   	pop    %ebx
  801f66:	5e                   	pop    %esi
  801f67:	5d                   	pop    %ebp
  801f68:	c3                   	ret    

00801f69 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801f69:	55                   	push   %ebp
  801f6a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801f6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f72:	6a 00                	push   $0x0
  801f74:	6a 00                	push   $0x0
  801f76:	6a 00                	push   $0x0
  801f78:	52                   	push   %edx
  801f79:	50                   	push   %eax
  801f7a:	6a 07                	push   $0x7
  801f7c:	e8 34 ff ff ff       	call   801eb5 <syscall>
  801f81:	83 c4 18             	add    $0x18,%esp
}
  801f84:	c9                   	leave  
  801f85:	c3                   	ret    

00801f86 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801f86:	55                   	push   %ebp
  801f87:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801f89:	6a 00                	push   $0x0
  801f8b:	6a 00                	push   $0x0
  801f8d:	6a 00                	push   $0x0
  801f8f:	ff 75 0c             	pushl  0xc(%ebp)
  801f92:	ff 75 08             	pushl  0x8(%ebp)
  801f95:	6a 08                	push   $0x8
  801f97:	e8 19 ff ff ff       	call   801eb5 <syscall>
  801f9c:	83 c4 18             	add    $0x18,%esp
}
  801f9f:	c9                   	leave  
  801fa0:	c3                   	ret    

00801fa1 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801fa1:	55                   	push   %ebp
  801fa2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801fa4:	6a 00                	push   $0x0
  801fa6:	6a 00                	push   $0x0
  801fa8:	6a 00                	push   $0x0
  801faa:	6a 00                	push   $0x0
  801fac:	6a 00                	push   $0x0
  801fae:	6a 09                	push   $0x9
  801fb0:	e8 00 ff ff ff       	call   801eb5 <syscall>
  801fb5:	83 c4 18             	add    $0x18,%esp
}
  801fb8:	c9                   	leave  
  801fb9:	c3                   	ret    

00801fba <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801fba:	55                   	push   %ebp
  801fbb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801fbd:	6a 00                	push   $0x0
  801fbf:	6a 00                	push   $0x0
  801fc1:	6a 00                	push   $0x0
  801fc3:	6a 00                	push   $0x0
  801fc5:	6a 00                	push   $0x0
  801fc7:	6a 0a                	push   $0xa
  801fc9:	e8 e7 fe ff ff       	call   801eb5 <syscall>
  801fce:	83 c4 18             	add    $0x18,%esp
}
  801fd1:	c9                   	leave  
  801fd2:	c3                   	ret    

00801fd3 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801fd3:	55                   	push   %ebp
  801fd4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801fd6:	6a 00                	push   $0x0
  801fd8:	6a 00                	push   $0x0
  801fda:	6a 00                	push   $0x0
  801fdc:	6a 00                	push   $0x0
  801fde:	6a 00                	push   $0x0
  801fe0:	6a 0b                	push   $0xb
  801fe2:	e8 ce fe ff ff       	call   801eb5 <syscall>
  801fe7:	83 c4 18             	add    $0x18,%esp
}
  801fea:	c9                   	leave  
  801feb:	c3                   	ret    

00801fec <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801fec:	55                   	push   %ebp
  801fed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801fef:	6a 00                	push   $0x0
  801ff1:	6a 00                	push   $0x0
  801ff3:	6a 00                	push   $0x0
  801ff5:	ff 75 0c             	pushl  0xc(%ebp)
  801ff8:	ff 75 08             	pushl  0x8(%ebp)
  801ffb:	6a 0f                	push   $0xf
  801ffd:	e8 b3 fe ff ff       	call   801eb5 <syscall>
  802002:	83 c4 18             	add    $0x18,%esp
	return;
  802005:	90                   	nop
}
  802006:	c9                   	leave  
  802007:	c3                   	ret    

00802008 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802008:	55                   	push   %ebp
  802009:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80200b:	6a 00                	push   $0x0
  80200d:	6a 00                	push   $0x0
  80200f:	6a 00                	push   $0x0
  802011:	ff 75 0c             	pushl  0xc(%ebp)
  802014:	ff 75 08             	pushl  0x8(%ebp)
  802017:	6a 10                	push   $0x10
  802019:	e8 97 fe ff ff       	call   801eb5 <syscall>
  80201e:	83 c4 18             	add    $0x18,%esp
	return ;
  802021:	90                   	nop
}
  802022:	c9                   	leave  
  802023:	c3                   	ret    

00802024 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802024:	55                   	push   %ebp
  802025:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802027:	6a 00                	push   $0x0
  802029:	6a 00                	push   $0x0
  80202b:	ff 75 10             	pushl  0x10(%ebp)
  80202e:	ff 75 0c             	pushl  0xc(%ebp)
  802031:	ff 75 08             	pushl  0x8(%ebp)
  802034:	6a 11                	push   $0x11
  802036:	e8 7a fe ff ff       	call   801eb5 <syscall>
  80203b:	83 c4 18             	add    $0x18,%esp
	return ;
  80203e:	90                   	nop
}
  80203f:	c9                   	leave  
  802040:	c3                   	ret    

00802041 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802041:	55                   	push   %ebp
  802042:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802044:	6a 00                	push   $0x0
  802046:	6a 00                	push   $0x0
  802048:	6a 00                	push   $0x0
  80204a:	6a 00                	push   $0x0
  80204c:	6a 00                	push   $0x0
  80204e:	6a 0c                	push   $0xc
  802050:	e8 60 fe ff ff       	call   801eb5 <syscall>
  802055:	83 c4 18             	add    $0x18,%esp
}
  802058:	c9                   	leave  
  802059:	c3                   	ret    

0080205a <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80205a:	55                   	push   %ebp
  80205b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80205d:	6a 00                	push   $0x0
  80205f:	6a 00                	push   $0x0
  802061:	6a 00                	push   $0x0
  802063:	6a 00                	push   $0x0
  802065:	ff 75 08             	pushl  0x8(%ebp)
  802068:	6a 0d                	push   $0xd
  80206a:	e8 46 fe ff ff       	call   801eb5 <syscall>
  80206f:	83 c4 18             	add    $0x18,%esp
}
  802072:	c9                   	leave  
  802073:	c3                   	ret    

00802074 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802074:	55                   	push   %ebp
  802075:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802077:	6a 00                	push   $0x0
  802079:	6a 00                	push   $0x0
  80207b:	6a 00                	push   $0x0
  80207d:	6a 00                	push   $0x0
  80207f:	6a 00                	push   $0x0
  802081:	6a 0e                	push   $0xe
  802083:	e8 2d fe ff ff       	call   801eb5 <syscall>
  802088:	83 c4 18             	add    $0x18,%esp
}
  80208b:	90                   	nop
  80208c:	c9                   	leave  
  80208d:	c3                   	ret    

0080208e <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80208e:	55                   	push   %ebp
  80208f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802091:	6a 00                	push   $0x0
  802093:	6a 00                	push   $0x0
  802095:	6a 00                	push   $0x0
  802097:	6a 00                	push   $0x0
  802099:	6a 00                	push   $0x0
  80209b:	6a 13                	push   $0x13
  80209d:	e8 13 fe ff ff       	call   801eb5 <syscall>
  8020a2:	83 c4 18             	add    $0x18,%esp
}
  8020a5:	90                   	nop
  8020a6:	c9                   	leave  
  8020a7:	c3                   	ret    

008020a8 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8020a8:	55                   	push   %ebp
  8020a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8020ab:	6a 00                	push   $0x0
  8020ad:	6a 00                	push   $0x0
  8020af:	6a 00                	push   $0x0
  8020b1:	6a 00                	push   $0x0
  8020b3:	6a 00                	push   $0x0
  8020b5:	6a 14                	push   $0x14
  8020b7:	e8 f9 fd ff ff       	call   801eb5 <syscall>
  8020bc:	83 c4 18             	add    $0x18,%esp
}
  8020bf:	90                   	nop
  8020c0:	c9                   	leave  
  8020c1:	c3                   	ret    

008020c2 <sys_cputc>:


void
sys_cputc(const char c)
{
  8020c2:	55                   	push   %ebp
  8020c3:	89 e5                	mov    %esp,%ebp
  8020c5:	83 ec 04             	sub    $0x4,%esp
  8020c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8020ce:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020d2:	6a 00                	push   $0x0
  8020d4:	6a 00                	push   $0x0
  8020d6:	6a 00                	push   $0x0
  8020d8:	6a 00                	push   $0x0
  8020da:	50                   	push   %eax
  8020db:	6a 15                	push   $0x15
  8020dd:	e8 d3 fd ff ff       	call   801eb5 <syscall>
  8020e2:	83 c4 18             	add    $0x18,%esp
}
  8020e5:	90                   	nop
  8020e6:	c9                   	leave  
  8020e7:	c3                   	ret    

008020e8 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8020e8:	55                   	push   %ebp
  8020e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8020eb:	6a 00                	push   $0x0
  8020ed:	6a 00                	push   $0x0
  8020ef:	6a 00                	push   $0x0
  8020f1:	6a 00                	push   $0x0
  8020f3:	6a 00                	push   $0x0
  8020f5:	6a 16                	push   $0x16
  8020f7:	e8 b9 fd ff ff       	call   801eb5 <syscall>
  8020fc:	83 c4 18             	add    $0x18,%esp
}
  8020ff:	90                   	nop
  802100:	c9                   	leave  
  802101:	c3                   	ret    

00802102 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802102:	55                   	push   %ebp
  802103:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802105:	8b 45 08             	mov    0x8(%ebp),%eax
  802108:	6a 00                	push   $0x0
  80210a:	6a 00                	push   $0x0
  80210c:	6a 00                	push   $0x0
  80210e:	ff 75 0c             	pushl  0xc(%ebp)
  802111:	50                   	push   %eax
  802112:	6a 17                	push   $0x17
  802114:	e8 9c fd ff ff       	call   801eb5 <syscall>
  802119:	83 c4 18             	add    $0x18,%esp
}
  80211c:	c9                   	leave  
  80211d:	c3                   	ret    

0080211e <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80211e:	55                   	push   %ebp
  80211f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802121:	8b 55 0c             	mov    0xc(%ebp),%edx
  802124:	8b 45 08             	mov    0x8(%ebp),%eax
  802127:	6a 00                	push   $0x0
  802129:	6a 00                	push   $0x0
  80212b:	6a 00                	push   $0x0
  80212d:	52                   	push   %edx
  80212e:	50                   	push   %eax
  80212f:	6a 1a                	push   $0x1a
  802131:	e8 7f fd ff ff       	call   801eb5 <syscall>
  802136:	83 c4 18             	add    $0x18,%esp
}
  802139:	c9                   	leave  
  80213a:	c3                   	ret    

0080213b <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80213b:	55                   	push   %ebp
  80213c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80213e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802141:	8b 45 08             	mov    0x8(%ebp),%eax
  802144:	6a 00                	push   $0x0
  802146:	6a 00                	push   $0x0
  802148:	6a 00                	push   $0x0
  80214a:	52                   	push   %edx
  80214b:	50                   	push   %eax
  80214c:	6a 18                	push   $0x18
  80214e:	e8 62 fd ff ff       	call   801eb5 <syscall>
  802153:	83 c4 18             	add    $0x18,%esp
}
  802156:	90                   	nop
  802157:	c9                   	leave  
  802158:	c3                   	ret    

00802159 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802159:	55                   	push   %ebp
  80215a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80215c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80215f:	8b 45 08             	mov    0x8(%ebp),%eax
  802162:	6a 00                	push   $0x0
  802164:	6a 00                	push   $0x0
  802166:	6a 00                	push   $0x0
  802168:	52                   	push   %edx
  802169:	50                   	push   %eax
  80216a:	6a 19                	push   $0x19
  80216c:	e8 44 fd ff ff       	call   801eb5 <syscall>
  802171:	83 c4 18             	add    $0x18,%esp
}
  802174:	90                   	nop
  802175:	c9                   	leave  
  802176:	c3                   	ret    

00802177 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802177:	55                   	push   %ebp
  802178:	89 e5                	mov    %esp,%ebp
  80217a:	83 ec 04             	sub    $0x4,%esp
  80217d:	8b 45 10             	mov    0x10(%ebp),%eax
  802180:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802183:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802186:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80218a:	8b 45 08             	mov    0x8(%ebp),%eax
  80218d:	6a 00                	push   $0x0
  80218f:	51                   	push   %ecx
  802190:	52                   	push   %edx
  802191:	ff 75 0c             	pushl  0xc(%ebp)
  802194:	50                   	push   %eax
  802195:	6a 1b                	push   $0x1b
  802197:	e8 19 fd ff ff       	call   801eb5 <syscall>
  80219c:	83 c4 18             	add    $0x18,%esp
}
  80219f:	c9                   	leave  
  8021a0:	c3                   	ret    

008021a1 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8021a1:	55                   	push   %ebp
  8021a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8021a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021aa:	6a 00                	push   $0x0
  8021ac:	6a 00                	push   $0x0
  8021ae:	6a 00                	push   $0x0
  8021b0:	52                   	push   %edx
  8021b1:	50                   	push   %eax
  8021b2:	6a 1c                	push   $0x1c
  8021b4:	e8 fc fc ff ff       	call   801eb5 <syscall>
  8021b9:	83 c4 18             	add    $0x18,%esp
}
  8021bc:	c9                   	leave  
  8021bd:	c3                   	ret    

008021be <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8021be:	55                   	push   %ebp
  8021bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8021c1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ca:	6a 00                	push   $0x0
  8021cc:	6a 00                	push   $0x0
  8021ce:	51                   	push   %ecx
  8021cf:	52                   	push   %edx
  8021d0:	50                   	push   %eax
  8021d1:	6a 1d                	push   $0x1d
  8021d3:	e8 dd fc ff ff       	call   801eb5 <syscall>
  8021d8:	83 c4 18             	add    $0x18,%esp
}
  8021db:	c9                   	leave  
  8021dc:	c3                   	ret    

008021dd <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8021dd:	55                   	push   %ebp
  8021de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8021e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e6:	6a 00                	push   $0x0
  8021e8:	6a 00                	push   $0x0
  8021ea:	6a 00                	push   $0x0
  8021ec:	52                   	push   %edx
  8021ed:	50                   	push   %eax
  8021ee:	6a 1e                	push   $0x1e
  8021f0:	e8 c0 fc ff ff       	call   801eb5 <syscall>
  8021f5:	83 c4 18             	add    $0x18,%esp
}
  8021f8:	c9                   	leave  
  8021f9:	c3                   	ret    

008021fa <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8021fa:	55                   	push   %ebp
  8021fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 00                	push   $0x0
  802201:	6a 00                	push   $0x0
  802203:	6a 00                	push   $0x0
  802205:	6a 00                	push   $0x0
  802207:	6a 1f                	push   $0x1f
  802209:	e8 a7 fc ff ff       	call   801eb5 <syscall>
  80220e:	83 c4 18             	add    $0x18,%esp
}
  802211:	c9                   	leave  
  802212:	c3                   	ret    

00802213 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802213:	55                   	push   %ebp
  802214:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802216:	8b 45 08             	mov    0x8(%ebp),%eax
  802219:	6a 00                	push   $0x0
  80221b:	ff 75 14             	pushl  0x14(%ebp)
  80221e:	ff 75 10             	pushl  0x10(%ebp)
  802221:	ff 75 0c             	pushl  0xc(%ebp)
  802224:	50                   	push   %eax
  802225:	6a 20                	push   $0x20
  802227:	e8 89 fc ff ff       	call   801eb5 <syscall>
  80222c:	83 c4 18             	add    $0x18,%esp
}
  80222f:	c9                   	leave  
  802230:	c3                   	ret    

00802231 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802231:	55                   	push   %ebp
  802232:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802234:	8b 45 08             	mov    0x8(%ebp),%eax
  802237:	6a 00                	push   $0x0
  802239:	6a 00                	push   $0x0
  80223b:	6a 00                	push   $0x0
  80223d:	6a 00                	push   $0x0
  80223f:	50                   	push   %eax
  802240:	6a 21                	push   $0x21
  802242:	e8 6e fc ff ff       	call   801eb5 <syscall>
  802247:	83 c4 18             	add    $0x18,%esp
}
  80224a:	90                   	nop
  80224b:	c9                   	leave  
  80224c:	c3                   	ret    

0080224d <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80224d:	55                   	push   %ebp
  80224e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802250:	8b 45 08             	mov    0x8(%ebp),%eax
  802253:	6a 00                	push   $0x0
  802255:	6a 00                	push   $0x0
  802257:	6a 00                	push   $0x0
  802259:	6a 00                	push   $0x0
  80225b:	50                   	push   %eax
  80225c:	6a 22                	push   $0x22
  80225e:	e8 52 fc ff ff       	call   801eb5 <syscall>
  802263:	83 c4 18             	add    $0x18,%esp
}
  802266:	c9                   	leave  
  802267:	c3                   	ret    

00802268 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802268:	55                   	push   %ebp
  802269:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80226b:	6a 00                	push   $0x0
  80226d:	6a 00                	push   $0x0
  80226f:	6a 00                	push   $0x0
  802271:	6a 00                	push   $0x0
  802273:	6a 00                	push   $0x0
  802275:	6a 02                	push   $0x2
  802277:	e8 39 fc ff ff       	call   801eb5 <syscall>
  80227c:	83 c4 18             	add    $0x18,%esp
}
  80227f:	c9                   	leave  
  802280:	c3                   	ret    

00802281 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802281:	55                   	push   %ebp
  802282:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802284:	6a 00                	push   $0x0
  802286:	6a 00                	push   $0x0
  802288:	6a 00                	push   $0x0
  80228a:	6a 00                	push   $0x0
  80228c:	6a 00                	push   $0x0
  80228e:	6a 03                	push   $0x3
  802290:	e8 20 fc ff ff       	call   801eb5 <syscall>
  802295:	83 c4 18             	add    $0x18,%esp
}
  802298:	c9                   	leave  
  802299:	c3                   	ret    

0080229a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80229a:	55                   	push   %ebp
  80229b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80229d:	6a 00                	push   $0x0
  80229f:	6a 00                	push   $0x0
  8022a1:	6a 00                	push   $0x0
  8022a3:	6a 00                	push   $0x0
  8022a5:	6a 00                	push   $0x0
  8022a7:	6a 04                	push   $0x4
  8022a9:	e8 07 fc ff ff       	call   801eb5 <syscall>
  8022ae:	83 c4 18             	add    $0x18,%esp
}
  8022b1:	c9                   	leave  
  8022b2:	c3                   	ret    

008022b3 <sys_exit_env>:


void sys_exit_env(void)
{
  8022b3:	55                   	push   %ebp
  8022b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8022b6:	6a 00                	push   $0x0
  8022b8:	6a 00                	push   $0x0
  8022ba:	6a 00                	push   $0x0
  8022bc:	6a 00                	push   $0x0
  8022be:	6a 00                	push   $0x0
  8022c0:	6a 23                	push   $0x23
  8022c2:	e8 ee fb ff ff       	call   801eb5 <syscall>
  8022c7:	83 c4 18             	add    $0x18,%esp
}
  8022ca:	90                   	nop
  8022cb:	c9                   	leave  
  8022cc:	c3                   	ret    

008022cd <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8022cd:	55                   	push   %ebp
  8022ce:	89 e5                	mov    %esp,%ebp
  8022d0:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8022d3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022d6:	8d 50 04             	lea    0x4(%eax),%edx
  8022d9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022dc:	6a 00                	push   $0x0
  8022de:	6a 00                	push   $0x0
  8022e0:	6a 00                	push   $0x0
  8022e2:	52                   	push   %edx
  8022e3:	50                   	push   %eax
  8022e4:	6a 24                	push   $0x24
  8022e6:	e8 ca fb ff ff       	call   801eb5 <syscall>
  8022eb:	83 c4 18             	add    $0x18,%esp
	return result;
  8022ee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022f4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8022f7:	89 01                	mov    %eax,(%ecx)
  8022f9:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8022fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ff:	c9                   	leave  
  802300:	c2 04 00             	ret    $0x4

00802303 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802303:	55                   	push   %ebp
  802304:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802306:	6a 00                	push   $0x0
  802308:	6a 00                	push   $0x0
  80230a:	ff 75 10             	pushl  0x10(%ebp)
  80230d:	ff 75 0c             	pushl  0xc(%ebp)
  802310:	ff 75 08             	pushl  0x8(%ebp)
  802313:	6a 12                	push   $0x12
  802315:	e8 9b fb ff ff       	call   801eb5 <syscall>
  80231a:	83 c4 18             	add    $0x18,%esp
	return ;
  80231d:	90                   	nop
}
  80231e:	c9                   	leave  
  80231f:	c3                   	ret    

00802320 <sys_rcr2>:
uint32 sys_rcr2()
{
  802320:	55                   	push   %ebp
  802321:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802323:	6a 00                	push   $0x0
  802325:	6a 00                	push   $0x0
  802327:	6a 00                	push   $0x0
  802329:	6a 00                	push   $0x0
  80232b:	6a 00                	push   $0x0
  80232d:	6a 25                	push   $0x25
  80232f:	e8 81 fb ff ff       	call   801eb5 <syscall>
  802334:	83 c4 18             	add    $0x18,%esp
}
  802337:	c9                   	leave  
  802338:	c3                   	ret    

00802339 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802339:	55                   	push   %ebp
  80233a:	89 e5                	mov    %esp,%ebp
  80233c:	83 ec 04             	sub    $0x4,%esp
  80233f:	8b 45 08             	mov    0x8(%ebp),%eax
  802342:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802345:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802349:	6a 00                	push   $0x0
  80234b:	6a 00                	push   $0x0
  80234d:	6a 00                	push   $0x0
  80234f:	6a 00                	push   $0x0
  802351:	50                   	push   %eax
  802352:	6a 26                	push   $0x26
  802354:	e8 5c fb ff ff       	call   801eb5 <syscall>
  802359:	83 c4 18             	add    $0x18,%esp
	return ;
  80235c:	90                   	nop
}
  80235d:	c9                   	leave  
  80235e:	c3                   	ret    

0080235f <rsttst>:
void rsttst()
{
  80235f:	55                   	push   %ebp
  802360:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802362:	6a 00                	push   $0x0
  802364:	6a 00                	push   $0x0
  802366:	6a 00                	push   $0x0
  802368:	6a 00                	push   $0x0
  80236a:	6a 00                	push   $0x0
  80236c:	6a 28                	push   $0x28
  80236e:	e8 42 fb ff ff       	call   801eb5 <syscall>
  802373:	83 c4 18             	add    $0x18,%esp
	return ;
  802376:	90                   	nop
}
  802377:	c9                   	leave  
  802378:	c3                   	ret    

00802379 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802379:	55                   	push   %ebp
  80237a:	89 e5                	mov    %esp,%ebp
  80237c:	83 ec 04             	sub    $0x4,%esp
  80237f:	8b 45 14             	mov    0x14(%ebp),%eax
  802382:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802385:	8b 55 18             	mov    0x18(%ebp),%edx
  802388:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80238c:	52                   	push   %edx
  80238d:	50                   	push   %eax
  80238e:	ff 75 10             	pushl  0x10(%ebp)
  802391:	ff 75 0c             	pushl  0xc(%ebp)
  802394:	ff 75 08             	pushl  0x8(%ebp)
  802397:	6a 27                	push   $0x27
  802399:	e8 17 fb ff ff       	call   801eb5 <syscall>
  80239e:	83 c4 18             	add    $0x18,%esp
	return ;
  8023a1:	90                   	nop
}
  8023a2:	c9                   	leave  
  8023a3:	c3                   	ret    

008023a4 <chktst>:
void chktst(uint32 n)
{
  8023a4:	55                   	push   %ebp
  8023a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8023a7:	6a 00                	push   $0x0
  8023a9:	6a 00                	push   $0x0
  8023ab:	6a 00                	push   $0x0
  8023ad:	6a 00                	push   $0x0
  8023af:	ff 75 08             	pushl  0x8(%ebp)
  8023b2:	6a 29                	push   $0x29
  8023b4:	e8 fc fa ff ff       	call   801eb5 <syscall>
  8023b9:	83 c4 18             	add    $0x18,%esp
	return ;
  8023bc:	90                   	nop
}
  8023bd:	c9                   	leave  
  8023be:	c3                   	ret    

008023bf <inctst>:

void inctst()
{
  8023bf:	55                   	push   %ebp
  8023c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8023c2:	6a 00                	push   $0x0
  8023c4:	6a 00                	push   $0x0
  8023c6:	6a 00                	push   $0x0
  8023c8:	6a 00                	push   $0x0
  8023ca:	6a 00                	push   $0x0
  8023cc:	6a 2a                	push   $0x2a
  8023ce:	e8 e2 fa ff ff       	call   801eb5 <syscall>
  8023d3:	83 c4 18             	add    $0x18,%esp
	return ;
  8023d6:	90                   	nop
}
  8023d7:	c9                   	leave  
  8023d8:	c3                   	ret    

008023d9 <gettst>:
uint32 gettst()
{
  8023d9:	55                   	push   %ebp
  8023da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8023dc:	6a 00                	push   $0x0
  8023de:	6a 00                	push   $0x0
  8023e0:	6a 00                	push   $0x0
  8023e2:	6a 00                	push   $0x0
  8023e4:	6a 00                	push   $0x0
  8023e6:	6a 2b                	push   $0x2b
  8023e8:	e8 c8 fa ff ff       	call   801eb5 <syscall>
  8023ed:	83 c4 18             	add    $0x18,%esp
}
  8023f0:	c9                   	leave  
  8023f1:	c3                   	ret    

008023f2 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8023f2:	55                   	push   %ebp
  8023f3:	89 e5                	mov    %esp,%ebp
  8023f5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023f8:	6a 00                	push   $0x0
  8023fa:	6a 00                	push   $0x0
  8023fc:	6a 00                	push   $0x0
  8023fe:	6a 00                	push   $0x0
  802400:	6a 00                	push   $0x0
  802402:	6a 2c                	push   $0x2c
  802404:	e8 ac fa ff ff       	call   801eb5 <syscall>
  802409:	83 c4 18             	add    $0x18,%esp
  80240c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80240f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802413:	75 07                	jne    80241c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802415:	b8 01 00 00 00       	mov    $0x1,%eax
  80241a:	eb 05                	jmp    802421 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80241c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802421:	c9                   	leave  
  802422:	c3                   	ret    

00802423 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802423:	55                   	push   %ebp
  802424:	89 e5                	mov    %esp,%ebp
  802426:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802429:	6a 00                	push   $0x0
  80242b:	6a 00                	push   $0x0
  80242d:	6a 00                	push   $0x0
  80242f:	6a 00                	push   $0x0
  802431:	6a 00                	push   $0x0
  802433:	6a 2c                	push   $0x2c
  802435:	e8 7b fa ff ff       	call   801eb5 <syscall>
  80243a:	83 c4 18             	add    $0x18,%esp
  80243d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802440:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802444:	75 07                	jne    80244d <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802446:	b8 01 00 00 00       	mov    $0x1,%eax
  80244b:	eb 05                	jmp    802452 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80244d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802452:	c9                   	leave  
  802453:	c3                   	ret    

00802454 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802454:	55                   	push   %ebp
  802455:	89 e5                	mov    %esp,%ebp
  802457:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80245a:	6a 00                	push   $0x0
  80245c:	6a 00                	push   $0x0
  80245e:	6a 00                	push   $0x0
  802460:	6a 00                	push   $0x0
  802462:	6a 00                	push   $0x0
  802464:	6a 2c                	push   $0x2c
  802466:	e8 4a fa ff ff       	call   801eb5 <syscall>
  80246b:	83 c4 18             	add    $0x18,%esp
  80246e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802471:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802475:	75 07                	jne    80247e <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802477:	b8 01 00 00 00       	mov    $0x1,%eax
  80247c:	eb 05                	jmp    802483 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80247e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802483:	c9                   	leave  
  802484:	c3                   	ret    

00802485 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802485:	55                   	push   %ebp
  802486:	89 e5                	mov    %esp,%ebp
  802488:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80248b:	6a 00                	push   $0x0
  80248d:	6a 00                	push   $0x0
  80248f:	6a 00                	push   $0x0
  802491:	6a 00                	push   $0x0
  802493:	6a 00                	push   $0x0
  802495:	6a 2c                	push   $0x2c
  802497:	e8 19 fa ff ff       	call   801eb5 <syscall>
  80249c:	83 c4 18             	add    $0x18,%esp
  80249f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8024a2:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8024a6:	75 07                	jne    8024af <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8024a8:	b8 01 00 00 00       	mov    $0x1,%eax
  8024ad:	eb 05                	jmp    8024b4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8024af:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024b4:	c9                   	leave  
  8024b5:	c3                   	ret    

008024b6 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8024b6:	55                   	push   %ebp
  8024b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8024b9:	6a 00                	push   $0x0
  8024bb:	6a 00                	push   $0x0
  8024bd:	6a 00                	push   $0x0
  8024bf:	6a 00                	push   $0x0
  8024c1:	ff 75 08             	pushl  0x8(%ebp)
  8024c4:	6a 2d                	push   $0x2d
  8024c6:	e8 ea f9 ff ff       	call   801eb5 <syscall>
  8024cb:	83 c4 18             	add    $0x18,%esp
	return ;
  8024ce:	90                   	nop
}
  8024cf:	c9                   	leave  
  8024d0:	c3                   	ret    

008024d1 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8024d1:	55                   	push   %ebp
  8024d2:	89 e5                	mov    %esp,%ebp
  8024d4:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8024d5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8024d8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024de:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e1:	6a 00                	push   $0x0
  8024e3:	53                   	push   %ebx
  8024e4:	51                   	push   %ecx
  8024e5:	52                   	push   %edx
  8024e6:	50                   	push   %eax
  8024e7:	6a 2e                	push   $0x2e
  8024e9:	e8 c7 f9 ff ff       	call   801eb5 <syscall>
  8024ee:	83 c4 18             	add    $0x18,%esp
}
  8024f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024f4:	c9                   	leave  
  8024f5:	c3                   	ret    

008024f6 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8024f6:	55                   	push   %ebp
  8024f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8024f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ff:	6a 00                	push   $0x0
  802501:	6a 00                	push   $0x0
  802503:	6a 00                	push   $0x0
  802505:	52                   	push   %edx
  802506:	50                   	push   %eax
  802507:	6a 2f                	push   $0x2f
  802509:	e8 a7 f9 ff ff       	call   801eb5 <syscall>
  80250e:	83 c4 18             	add    $0x18,%esp
}
  802511:	c9                   	leave  
  802512:	c3                   	ret    

00802513 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802513:	55                   	push   %ebp
  802514:	89 e5                	mov    %esp,%ebp
  802516:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802519:	83 ec 0c             	sub    $0xc,%esp
  80251c:	68 a4 46 80 00       	push   $0x8046a4
  802521:	e8 65 e6 ff ff       	call   800b8b <cprintf>
  802526:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802529:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802530:	83 ec 0c             	sub    $0xc,%esp
  802533:	68 d0 46 80 00       	push   $0x8046d0
  802538:	e8 4e e6 ff ff       	call   800b8b <cprintf>
  80253d:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802540:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802544:	a1 38 51 80 00       	mov    0x805138,%eax
  802549:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80254c:	eb 56                	jmp    8025a4 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80254e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802552:	74 1c                	je     802570 <print_mem_block_lists+0x5d>
  802554:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802557:	8b 50 08             	mov    0x8(%eax),%edx
  80255a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80255d:	8b 48 08             	mov    0x8(%eax),%ecx
  802560:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802563:	8b 40 0c             	mov    0xc(%eax),%eax
  802566:	01 c8                	add    %ecx,%eax
  802568:	39 c2                	cmp    %eax,%edx
  80256a:	73 04                	jae    802570 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80256c:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802573:	8b 50 08             	mov    0x8(%eax),%edx
  802576:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802579:	8b 40 0c             	mov    0xc(%eax),%eax
  80257c:	01 c2                	add    %eax,%edx
  80257e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802581:	8b 40 08             	mov    0x8(%eax),%eax
  802584:	83 ec 04             	sub    $0x4,%esp
  802587:	52                   	push   %edx
  802588:	50                   	push   %eax
  802589:	68 e5 46 80 00       	push   $0x8046e5
  80258e:	e8 f8 e5 ff ff       	call   800b8b <cprintf>
  802593:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802596:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802599:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80259c:	a1 40 51 80 00       	mov    0x805140,%eax
  8025a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025a8:	74 07                	je     8025b1 <print_mem_block_lists+0x9e>
  8025aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ad:	8b 00                	mov    (%eax),%eax
  8025af:	eb 05                	jmp    8025b6 <print_mem_block_lists+0xa3>
  8025b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8025b6:	a3 40 51 80 00       	mov    %eax,0x805140
  8025bb:	a1 40 51 80 00       	mov    0x805140,%eax
  8025c0:	85 c0                	test   %eax,%eax
  8025c2:	75 8a                	jne    80254e <print_mem_block_lists+0x3b>
  8025c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025c8:	75 84                	jne    80254e <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8025ca:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8025ce:	75 10                	jne    8025e0 <print_mem_block_lists+0xcd>
  8025d0:	83 ec 0c             	sub    $0xc,%esp
  8025d3:	68 f4 46 80 00       	push   $0x8046f4
  8025d8:	e8 ae e5 ff ff       	call   800b8b <cprintf>
  8025dd:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8025e0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8025e7:	83 ec 0c             	sub    $0xc,%esp
  8025ea:	68 18 47 80 00       	push   $0x804718
  8025ef:	e8 97 e5 ff ff       	call   800b8b <cprintf>
  8025f4:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8025f7:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8025fb:	a1 40 50 80 00       	mov    0x805040,%eax
  802600:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802603:	eb 56                	jmp    80265b <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802605:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802609:	74 1c                	je     802627 <print_mem_block_lists+0x114>
  80260b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260e:	8b 50 08             	mov    0x8(%eax),%edx
  802611:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802614:	8b 48 08             	mov    0x8(%eax),%ecx
  802617:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80261a:	8b 40 0c             	mov    0xc(%eax),%eax
  80261d:	01 c8                	add    %ecx,%eax
  80261f:	39 c2                	cmp    %eax,%edx
  802621:	73 04                	jae    802627 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802623:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802627:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262a:	8b 50 08             	mov    0x8(%eax),%edx
  80262d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802630:	8b 40 0c             	mov    0xc(%eax),%eax
  802633:	01 c2                	add    %eax,%edx
  802635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802638:	8b 40 08             	mov    0x8(%eax),%eax
  80263b:	83 ec 04             	sub    $0x4,%esp
  80263e:	52                   	push   %edx
  80263f:	50                   	push   %eax
  802640:	68 e5 46 80 00       	push   $0x8046e5
  802645:	e8 41 e5 ff ff       	call   800b8b <cprintf>
  80264a:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80264d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802650:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802653:	a1 48 50 80 00       	mov    0x805048,%eax
  802658:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80265b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80265f:	74 07                	je     802668 <print_mem_block_lists+0x155>
  802661:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802664:	8b 00                	mov    (%eax),%eax
  802666:	eb 05                	jmp    80266d <print_mem_block_lists+0x15a>
  802668:	b8 00 00 00 00       	mov    $0x0,%eax
  80266d:	a3 48 50 80 00       	mov    %eax,0x805048
  802672:	a1 48 50 80 00       	mov    0x805048,%eax
  802677:	85 c0                	test   %eax,%eax
  802679:	75 8a                	jne    802605 <print_mem_block_lists+0xf2>
  80267b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80267f:	75 84                	jne    802605 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802681:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802685:	75 10                	jne    802697 <print_mem_block_lists+0x184>
  802687:	83 ec 0c             	sub    $0xc,%esp
  80268a:	68 30 47 80 00       	push   $0x804730
  80268f:	e8 f7 e4 ff ff       	call   800b8b <cprintf>
  802694:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802697:	83 ec 0c             	sub    $0xc,%esp
  80269a:	68 a4 46 80 00       	push   $0x8046a4
  80269f:	e8 e7 e4 ff ff       	call   800b8b <cprintf>
  8026a4:	83 c4 10             	add    $0x10,%esp

}
  8026a7:	90                   	nop
  8026a8:	c9                   	leave  
  8026a9:	c3                   	ret    

008026aa <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8026aa:	55                   	push   %ebp
  8026ab:	89 e5                	mov    %esp,%ebp
  8026ad:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8026b0:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8026b7:	00 00 00 
  8026ba:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8026c1:	00 00 00 
  8026c4:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8026cb:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8026ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8026d5:	e9 9e 00 00 00       	jmp    802778 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8026da:	a1 50 50 80 00       	mov    0x805050,%eax
  8026df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026e2:	c1 e2 04             	shl    $0x4,%edx
  8026e5:	01 d0                	add    %edx,%eax
  8026e7:	85 c0                	test   %eax,%eax
  8026e9:	75 14                	jne    8026ff <initialize_MemBlocksList+0x55>
  8026eb:	83 ec 04             	sub    $0x4,%esp
  8026ee:	68 58 47 80 00       	push   $0x804758
  8026f3:	6a 46                	push   $0x46
  8026f5:	68 7b 47 80 00       	push   $0x80477b
  8026fa:	e8 d8 e1 ff ff       	call   8008d7 <_panic>
  8026ff:	a1 50 50 80 00       	mov    0x805050,%eax
  802704:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802707:	c1 e2 04             	shl    $0x4,%edx
  80270a:	01 d0                	add    %edx,%eax
  80270c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802712:	89 10                	mov    %edx,(%eax)
  802714:	8b 00                	mov    (%eax),%eax
  802716:	85 c0                	test   %eax,%eax
  802718:	74 18                	je     802732 <initialize_MemBlocksList+0x88>
  80271a:	a1 48 51 80 00       	mov    0x805148,%eax
  80271f:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802725:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802728:	c1 e1 04             	shl    $0x4,%ecx
  80272b:	01 ca                	add    %ecx,%edx
  80272d:	89 50 04             	mov    %edx,0x4(%eax)
  802730:	eb 12                	jmp    802744 <initialize_MemBlocksList+0x9a>
  802732:	a1 50 50 80 00       	mov    0x805050,%eax
  802737:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80273a:	c1 e2 04             	shl    $0x4,%edx
  80273d:	01 d0                	add    %edx,%eax
  80273f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802744:	a1 50 50 80 00       	mov    0x805050,%eax
  802749:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80274c:	c1 e2 04             	shl    $0x4,%edx
  80274f:	01 d0                	add    %edx,%eax
  802751:	a3 48 51 80 00       	mov    %eax,0x805148
  802756:	a1 50 50 80 00       	mov    0x805050,%eax
  80275b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80275e:	c1 e2 04             	shl    $0x4,%edx
  802761:	01 d0                	add    %edx,%eax
  802763:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80276a:	a1 54 51 80 00       	mov    0x805154,%eax
  80276f:	40                   	inc    %eax
  802770:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802775:	ff 45 f4             	incl   -0xc(%ebp)
  802778:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80277e:	0f 82 56 ff ff ff    	jb     8026da <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802784:	90                   	nop
  802785:	c9                   	leave  
  802786:	c3                   	ret    

00802787 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802787:	55                   	push   %ebp
  802788:	89 e5                	mov    %esp,%ebp
  80278a:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80278d:	8b 45 08             	mov    0x8(%ebp),%eax
  802790:	8b 00                	mov    (%eax),%eax
  802792:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802795:	eb 19                	jmp    8027b0 <find_block+0x29>
	{
		if(va==point->sva)
  802797:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80279a:	8b 40 08             	mov    0x8(%eax),%eax
  80279d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8027a0:	75 05                	jne    8027a7 <find_block+0x20>
		   return point;
  8027a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027a5:	eb 36                	jmp    8027dd <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8027a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027aa:	8b 40 08             	mov    0x8(%eax),%eax
  8027ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8027b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8027b4:	74 07                	je     8027bd <find_block+0x36>
  8027b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027b9:	8b 00                	mov    (%eax),%eax
  8027bb:	eb 05                	jmp    8027c2 <find_block+0x3b>
  8027bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8027c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8027c5:	89 42 08             	mov    %eax,0x8(%edx)
  8027c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027cb:	8b 40 08             	mov    0x8(%eax),%eax
  8027ce:	85 c0                	test   %eax,%eax
  8027d0:	75 c5                	jne    802797 <find_block+0x10>
  8027d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8027d6:	75 bf                	jne    802797 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8027d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027dd:	c9                   	leave  
  8027de:	c3                   	ret    

008027df <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8027df:	55                   	push   %ebp
  8027e0:	89 e5                	mov    %esp,%ebp
  8027e2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8027e5:	a1 40 50 80 00       	mov    0x805040,%eax
  8027ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8027ed:	a1 44 50 80 00       	mov    0x805044,%eax
  8027f2:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8027f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8027fb:	74 24                	je     802821 <insert_sorted_allocList+0x42>
  8027fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802800:	8b 50 08             	mov    0x8(%eax),%edx
  802803:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802806:	8b 40 08             	mov    0x8(%eax),%eax
  802809:	39 c2                	cmp    %eax,%edx
  80280b:	76 14                	jbe    802821 <insert_sorted_allocList+0x42>
  80280d:	8b 45 08             	mov    0x8(%ebp),%eax
  802810:	8b 50 08             	mov    0x8(%eax),%edx
  802813:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802816:	8b 40 08             	mov    0x8(%eax),%eax
  802819:	39 c2                	cmp    %eax,%edx
  80281b:	0f 82 60 01 00 00    	jb     802981 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802821:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802825:	75 65                	jne    80288c <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802827:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80282b:	75 14                	jne    802841 <insert_sorted_allocList+0x62>
  80282d:	83 ec 04             	sub    $0x4,%esp
  802830:	68 58 47 80 00       	push   $0x804758
  802835:	6a 6b                	push   $0x6b
  802837:	68 7b 47 80 00       	push   $0x80477b
  80283c:	e8 96 e0 ff ff       	call   8008d7 <_panic>
  802841:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802847:	8b 45 08             	mov    0x8(%ebp),%eax
  80284a:	89 10                	mov    %edx,(%eax)
  80284c:	8b 45 08             	mov    0x8(%ebp),%eax
  80284f:	8b 00                	mov    (%eax),%eax
  802851:	85 c0                	test   %eax,%eax
  802853:	74 0d                	je     802862 <insert_sorted_allocList+0x83>
  802855:	a1 40 50 80 00       	mov    0x805040,%eax
  80285a:	8b 55 08             	mov    0x8(%ebp),%edx
  80285d:	89 50 04             	mov    %edx,0x4(%eax)
  802860:	eb 08                	jmp    80286a <insert_sorted_allocList+0x8b>
  802862:	8b 45 08             	mov    0x8(%ebp),%eax
  802865:	a3 44 50 80 00       	mov    %eax,0x805044
  80286a:	8b 45 08             	mov    0x8(%ebp),%eax
  80286d:	a3 40 50 80 00       	mov    %eax,0x805040
  802872:	8b 45 08             	mov    0x8(%ebp),%eax
  802875:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80287c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802881:	40                   	inc    %eax
  802882:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802887:	e9 dc 01 00 00       	jmp    802a68 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80288c:	8b 45 08             	mov    0x8(%ebp),%eax
  80288f:	8b 50 08             	mov    0x8(%eax),%edx
  802892:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802895:	8b 40 08             	mov    0x8(%eax),%eax
  802898:	39 c2                	cmp    %eax,%edx
  80289a:	77 6c                	ja     802908 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80289c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028a0:	74 06                	je     8028a8 <insert_sorted_allocList+0xc9>
  8028a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028a6:	75 14                	jne    8028bc <insert_sorted_allocList+0xdd>
  8028a8:	83 ec 04             	sub    $0x4,%esp
  8028ab:	68 94 47 80 00       	push   $0x804794
  8028b0:	6a 6f                	push   $0x6f
  8028b2:	68 7b 47 80 00       	push   $0x80477b
  8028b7:	e8 1b e0 ff ff       	call   8008d7 <_panic>
  8028bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028bf:	8b 50 04             	mov    0x4(%eax),%edx
  8028c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c5:	89 50 04             	mov    %edx,0x4(%eax)
  8028c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028cb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028ce:	89 10                	mov    %edx,(%eax)
  8028d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d3:	8b 40 04             	mov    0x4(%eax),%eax
  8028d6:	85 c0                	test   %eax,%eax
  8028d8:	74 0d                	je     8028e7 <insert_sorted_allocList+0x108>
  8028da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028dd:	8b 40 04             	mov    0x4(%eax),%eax
  8028e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8028e3:	89 10                	mov    %edx,(%eax)
  8028e5:	eb 08                	jmp    8028ef <insert_sorted_allocList+0x110>
  8028e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ea:	a3 40 50 80 00       	mov    %eax,0x805040
  8028ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8028f5:	89 50 04             	mov    %edx,0x4(%eax)
  8028f8:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8028fd:	40                   	inc    %eax
  8028fe:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802903:	e9 60 01 00 00       	jmp    802a68 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802908:	8b 45 08             	mov    0x8(%ebp),%eax
  80290b:	8b 50 08             	mov    0x8(%eax),%edx
  80290e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802911:	8b 40 08             	mov    0x8(%eax),%eax
  802914:	39 c2                	cmp    %eax,%edx
  802916:	0f 82 4c 01 00 00    	jb     802a68 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80291c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802920:	75 14                	jne    802936 <insert_sorted_allocList+0x157>
  802922:	83 ec 04             	sub    $0x4,%esp
  802925:	68 cc 47 80 00       	push   $0x8047cc
  80292a:	6a 73                	push   $0x73
  80292c:	68 7b 47 80 00       	push   $0x80477b
  802931:	e8 a1 df ff ff       	call   8008d7 <_panic>
  802936:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80293c:	8b 45 08             	mov    0x8(%ebp),%eax
  80293f:	89 50 04             	mov    %edx,0x4(%eax)
  802942:	8b 45 08             	mov    0x8(%ebp),%eax
  802945:	8b 40 04             	mov    0x4(%eax),%eax
  802948:	85 c0                	test   %eax,%eax
  80294a:	74 0c                	je     802958 <insert_sorted_allocList+0x179>
  80294c:	a1 44 50 80 00       	mov    0x805044,%eax
  802951:	8b 55 08             	mov    0x8(%ebp),%edx
  802954:	89 10                	mov    %edx,(%eax)
  802956:	eb 08                	jmp    802960 <insert_sorted_allocList+0x181>
  802958:	8b 45 08             	mov    0x8(%ebp),%eax
  80295b:	a3 40 50 80 00       	mov    %eax,0x805040
  802960:	8b 45 08             	mov    0x8(%ebp),%eax
  802963:	a3 44 50 80 00       	mov    %eax,0x805044
  802968:	8b 45 08             	mov    0x8(%ebp),%eax
  80296b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802971:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802976:	40                   	inc    %eax
  802977:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80297c:	e9 e7 00 00 00       	jmp    802a68 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802981:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802984:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802987:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80298e:	a1 40 50 80 00       	mov    0x805040,%eax
  802993:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802996:	e9 9d 00 00 00       	jmp    802a38 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80299b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299e:	8b 00                	mov    (%eax),%eax
  8029a0:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8029a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a6:	8b 50 08             	mov    0x8(%eax),%edx
  8029a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ac:	8b 40 08             	mov    0x8(%eax),%eax
  8029af:	39 c2                	cmp    %eax,%edx
  8029b1:	76 7d                	jbe    802a30 <insert_sorted_allocList+0x251>
  8029b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b6:	8b 50 08             	mov    0x8(%eax),%edx
  8029b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029bc:	8b 40 08             	mov    0x8(%eax),%eax
  8029bf:	39 c2                	cmp    %eax,%edx
  8029c1:	73 6d                	jae    802a30 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8029c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029c7:	74 06                	je     8029cf <insert_sorted_allocList+0x1f0>
  8029c9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029cd:	75 14                	jne    8029e3 <insert_sorted_allocList+0x204>
  8029cf:	83 ec 04             	sub    $0x4,%esp
  8029d2:	68 f0 47 80 00       	push   $0x8047f0
  8029d7:	6a 7f                	push   $0x7f
  8029d9:	68 7b 47 80 00       	push   $0x80477b
  8029de:	e8 f4 de ff ff       	call   8008d7 <_panic>
  8029e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e6:	8b 10                	mov    (%eax),%edx
  8029e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029eb:	89 10                	mov    %edx,(%eax)
  8029ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f0:	8b 00                	mov    (%eax),%eax
  8029f2:	85 c0                	test   %eax,%eax
  8029f4:	74 0b                	je     802a01 <insert_sorted_allocList+0x222>
  8029f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f9:	8b 00                	mov    (%eax),%eax
  8029fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8029fe:	89 50 04             	mov    %edx,0x4(%eax)
  802a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a04:	8b 55 08             	mov    0x8(%ebp),%edx
  802a07:	89 10                	mov    %edx,(%eax)
  802a09:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a0f:	89 50 04             	mov    %edx,0x4(%eax)
  802a12:	8b 45 08             	mov    0x8(%ebp),%eax
  802a15:	8b 00                	mov    (%eax),%eax
  802a17:	85 c0                	test   %eax,%eax
  802a19:	75 08                	jne    802a23 <insert_sorted_allocList+0x244>
  802a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1e:	a3 44 50 80 00       	mov    %eax,0x805044
  802a23:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a28:	40                   	inc    %eax
  802a29:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802a2e:	eb 39                	jmp    802a69 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802a30:	a1 48 50 80 00       	mov    0x805048,%eax
  802a35:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a38:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a3c:	74 07                	je     802a45 <insert_sorted_allocList+0x266>
  802a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a41:	8b 00                	mov    (%eax),%eax
  802a43:	eb 05                	jmp    802a4a <insert_sorted_allocList+0x26b>
  802a45:	b8 00 00 00 00       	mov    $0x0,%eax
  802a4a:	a3 48 50 80 00       	mov    %eax,0x805048
  802a4f:	a1 48 50 80 00       	mov    0x805048,%eax
  802a54:	85 c0                	test   %eax,%eax
  802a56:	0f 85 3f ff ff ff    	jne    80299b <insert_sorted_allocList+0x1bc>
  802a5c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a60:	0f 85 35 ff ff ff    	jne    80299b <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802a66:	eb 01                	jmp    802a69 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802a68:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802a69:	90                   	nop
  802a6a:	c9                   	leave  
  802a6b:	c3                   	ret    

00802a6c <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802a6c:	55                   	push   %ebp
  802a6d:	89 e5                	mov    %esp,%ebp
  802a6f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802a72:	a1 38 51 80 00       	mov    0x805138,%eax
  802a77:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a7a:	e9 85 01 00 00       	jmp    802c04 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a82:	8b 40 0c             	mov    0xc(%eax),%eax
  802a85:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a88:	0f 82 6e 01 00 00    	jb     802bfc <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a91:	8b 40 0c             	mov    0xc(%eax),%eax
  802a94:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a97:	0f 85 8a 00 00 00    	jne    802b27 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802a9d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aa1:	75 17                	jne    802aba <alloc_block_FF+0x4e>
  802aa3:	83 ec 04             	sub    $0x4,%esp
  802aa6:	68 24 48 80 00       	push   $0x804824
  802aab:	68 93 00 00 00       	push   $0x93
  802ab0:	68 7b 47 80 00       	push   $0x80477b
  802ab5:	e8 1d de ff ff       	call   8008d7 <_panic>
  802aba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abd:	8b 00                	mov    (%eax),%eax
  802abf:	85 c0                	test   %eax,%eax
  802ac1:	74 10                	je     802ad3 <alloc_block_FF+0x67>
  802ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac6:	8b 00                	mov    (%eax),%eax
  802ac8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802acb:	8b 52 04             	mov    0x4(%edx),%edx
  802ace:	89 50 04             	mov    %edx,0x4(%eax)
  802ad1:	eb 0b                	jmp    802ade <alloc_block_FF+0x72>
  802ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad6:	8b 40 04             	mov    0x4(%eax),%eax
  802ad9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ade:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae1:	8b 40 04             	mov    0x4(%eax),%eax
  802ae4:	85 c0                	test   %eax,%eax
  802ae6:	74 0f                	je     802af7 <alloc_block_FF+0x8b>
  802ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aeb:	8b 40 04             	mov    0x4(%eax),%eax
  802aee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802af1:	8b 12                	mov    (%edx),%edx
  802af3:	89 10                	mov    %edx,(%eax)
  802af5:	eb 0a                	jmp    802b01 <alloc_block_FF+0x95>
  802af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afa:	8b 00                	mov    (%eax),%eax
  802afc:	a3 38 51 80 00       	mov    %eax,0x805138
  802b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b04:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b14:	a1 44 51 80 00       	mov    0x805144,%eax
  802b19:	48                   	dec    %eax
  802b1a:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b22:	e9 10 01 00 00       	jmp    802c37 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802b27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2a:	8b 40 0c             	mov    0xc(%eax),%eax
  802b2d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b30:	0f 86 c6 00 00 00    	jbe    802bfc <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b36:	a1 48 51 80 00       	mov    0x805148,%eax
  802b3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802b3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b41:	8b 50 08             	mov    0x8(%eax),%edx
  802b44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b47:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802b4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b4d:	8b 55 08             	mov    0x8(%ebp),%edx
  802b50:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b53:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b57:	75 17                	jne    802b70 <alloc_block_FF+0x104>
  802b59:	83 ec 04             	sub    $0x4,%esp
  802b5c:	68 24 48 80 00       	push   $0x804824
  802b61:	68 9b 00 00 00       	push   $0x9b
  802b66:	68 7b 47 80 00       	push   $0x80477b
  802b6b:	e8 67 dd ff ff       	call   8008d7 <_panic>
  802b70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b73:	8b 00                	mov    (%eax),%eax
  802b75:	85 c0                	test   %eax,%eax
  802b77:	74 10                	je     802b89 <alloc_block_FF+0x11d>
  802b79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b7c:	8b 00                	mov    (%eax),%eax
  802b7e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b81:	8b 52 04             	mov    0x4(%edx),%edx
  802b84:	89 50 04             	mov    %edx,0x4(%eax)
  802b87:	eb 0b                	jmp    802b94 <alloc_block_FF+0x128>
  802b89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b8c:	8b 40 04             	mov    0x4(%eax),%eax
  802b8f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b97:	8b 40 04             	mov    0x4(%eax),%eax
  802b9a:	85 c0                	test   %eax,%eax
  802b9c:	74 0f                	je     802bad <alloc_block_FF+0x141>
  802b9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba1:	8b 40 04             	mov    0x4(%eax),%eax
  802ba4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ba7:	8b 12                	mov    (%edx),%edx
  802ba9:	89 10                	mov    %edx,(%eax)
  802bab:	eb 0a                	jmp    802bb7 <alloc_block_FF+0x14b>
  802bad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb0:	8b 00                	mov    (%eax),%eax
  802bb2:	a3 48 51 80 00       	mov    %eax,0x805148
  802bb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bca:	a1 54 51 80 00       	mov    0x805154,%eax
  802bcf:	48                   	dec    %eax
  802bd0:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802bd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd8:	8b 50 08             	mov    0x8(%eax),%edx
  802bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bde:	01 c2                	add    %eax,%edx
  802be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be3:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be9:	8b 40 0c             	mov    0xc(%eax),%eax
  802bec:	2b 45 08             	sub    0x8(%ebp),%eax
  802bef:	89 c2                	mov    %eax,%edx
  802bf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf4:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802bf7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bfa:	eb 3b                	jmp    802c37 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802bfc:	a1 40 51 80 00       	mov    0x805140,%eax
  802c01:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c04:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c08:	74 07                	je     802c11 <alloc_block_FF+0x1a5>
  802c0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0d:	8b 00                	mov    (%eax),%eax
  802c0f:	eb 05                	jmp    802c16 <alloc_block_FF+0x1aa>
  802c11:	b8 00 00 00 00       	mov    $0x0,%eax
  802c16:	a3 40 51 80 00       	mov    %eax,0x805140
  802c1b:	a1 40 51 80 00       	mov    0x805140,%eax
  802c20:	85 c0                	test   %eax,%eax
  802c22:	0f 85 57 fe ff ff    	jne    802a7f <alloc_block_FF+0x13>
  802c28:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c2c:	0f 85 4d fe ff ff    	jne    802a7f <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802c32:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c37:	c9                   	leave  
  802c38:	c3                   	ret    

00802c39 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802c39:	55                   	push   %ebp
  802c3a:	89 e5                	mov    %esp,%ebp
  802c3c:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802c3f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802c46:	a1 38 51 80 00       	mov    0x805138,%eax
  802c4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c4e:	e9 df 00 00 00       	jmp    802d32 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802c53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c56:	8b 40 0c             	mov    0xc(%eax),%eax
  802c59:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c5c:	0f 82 c8 00 00 00    	jb     802d2a <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802c62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c65:	8b 40 0c             	mov    0xc(%eax),%eax
  802c68:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c6b:	0f 85 8a 00 00 00    	jne    802cfb <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802c71:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c75:	75 17                	jne    802c8e <alloc_block_BF+0x55>
  802c77:	83 ec 04             	sub    $0x4,%esp
  802c7a:	68 24 48 80 00       	push   $0x804824
  802c7f:	68 b7 00 00 00       	push   $0xb7
  802c84:	68 7b 47 80 00       	push   $0x80477b
  802c89:	e8 49 dc ff ff       	call   8008d7 <_panic>
  802c8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c91:	8b 00                	mov    (%eax),%eax
  802c93:	85 c0                	test   %eax,%eax
  802c95:	74 10                	je     802ca7 <alloc_block_BF+0x6e>
  802c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9a:	8b 00                	mov    (%eax),%eax
  802c9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c9f:	8b 52 04             	mov    0x4(%edx),%edx
  802ca2:	89 50 04             	mov    %edx,0x4(%eax)
  802ca5:	eb 0b                	jmp    802cb2 <alloc_block_BF+0x79>
  802ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802caa:	8b 40 04             	mov    0x4(%eax),%eax
  802cad:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb5:	8b 40 04             	mov    0x4(%eax),%eax
  802cb8:	85 c0                	test   %eax,%eax
  802cba:	74 0f                	je     802ccb <alloc_block_BF+0x92>
  802cbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbf:	8b 40 04             	mov    0x4(%eax),%eax
  802cc2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cc5:	8b 12                	mov    (%edx),%edx
  802cc7:	89 10                	mov    %edx,(%eax)
  802cc9:	eb 0a                	jmp    802cd5 <alloc_block_BF+0x9c>
  802ccb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cce:	8b 00                	mov    (%eax),%eax
  802cd0:	a3 38 51 80 00       	mov    %eax,0x805138
  802cd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ce8:	a1 44 51 80 00       	mov    0x805144,%eax
  802ced:	48                   	dec    %eax
  802cee:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802cf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf6:	e9 4d 01 00 00       	jmp    802e48 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802cfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfe:	8b 40 0c             	mov    0xc(%eax),%eax
  802d01:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d04:	76 24                	jbe    802d2a <alloc_block_BF+0xf1>
  802d06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d09:	8b 40 0c             	mov    0xc(%eax),%eax
  802d0c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802d0f:	73 19                	jae    802d2a <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802d11:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802d18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1b:	8b 40 0c             	mov    0xc(%eax),%eax
  802d1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802d21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d24:	8b 40 08             	mov    0x8(%eax),%eax
  802d27:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802d2a:	a1 40 51 80 00       	mov    0x805140,%eax
  802d2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d36:	74 07                	je     802d3f <alloc_block_BF+0x106>
  802d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3b:	8b 00                	mov    (%eax),%eax
  802d3d:	eb 05                	jmp    802d44 <alloc_block_BF+0x10b>
  802d3f:	b8 00 00 00 00       	mov    $0x0,%eax
  802d44:	a3 40 51 80 00       	mov    %eax,0x805140
  802d49:	a1 40 51 80 00       	mov    0x805140,%eax
  802d4e:	85 c0                	test   %eax,%eax
  802d50:	0f 85 fd fe ff ff    	jne    802c53 <alloc_block_BF+0x1a>
  802d56:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d5a:	0f 85 f3 fe ff ff    	jne    802c53 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802d60:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d64:	0f 84 d9 00 00 00    	je     802e43 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d6a:	a1 48 51 80 00       	mov    0x805148,%eax
  802d6f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802d72:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d75:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d78:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802d7b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d7e:	8b 55 08             	mov    0x8(%ebp),%edx
  802d81:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802d84:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802d88:	75 17                	jne    802da1 <alloc_block_BF+0x168>
  802d8a:	83 ec 04             	sub    $0x4,%esp
  802d8d:	68 24 48 80 00       	push   $0x804824
  802d92:	68 c7 00 00 00       	push   $0xc7
  802d97:	68 7b 47 80 00       	push   $0x80477b
  802d9c:	e8 36 db ff ff       	call   8008d7 <_panic>
  802da1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802da4:	8b 00                	mov    (%eax),%eax
  802da6:	85 c0                	test   %eax,%eax
  802da8:	74 10                	je     802dba <alloc_block_BF+0x181>
  802daa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dad:	8b 00                	mov    (%eax),%eax
  802daf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802db2:	8b 52 04             	mov    0x4(%edx),%edx
  802db5:	89 50 04             	mov    %edx,0x4(%eax)
  802db8:	eb 0b                	jmp    802dc5 <alloc_block_BF+0x18c>
  802dba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dbd:	8b 40 04             	mov    0x4(%eax),%eax
  802dc0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802dc5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dc8:	8b 40 04             	mov    0x4(%eax),%eax
  802dcb:	85 c0                	test   %eax,%eax
  802dcd:	74 0f                	je     802dde <alloc_block_BF+0x1a5>
  802dcf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dd2:	8b 40 04             	mov    0x4(%eax),%eax
  802dd5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802dd8:	8b 12                	mov    (%edx),%edx
  802dda:	89 10                	mov    %edx,(%eax)
  802ddc:	eb 0a                	jmp    802de8 <alloc_block_BF+0x1af>
  802dde:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802de1:	8b 00                	mov    (%eax),%eax
  802de3:	a3 48 51 80 00       	mov    %eax,0x805148
  802de8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802deb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802df1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802df4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dfb:	a1 54 51 80 00       	mov    0x805154,%eax
  802e00:	48                   	dec    %eax
  802e01:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802e06:	83 ec 08             	sub    $0x8,%esp
  802e09:	ff 75 ec             	pushl  -0x14(%ebp)
  802e0c:	68 38 51 80 00       	push   $0x805138
  802e11:	e8 71 f9 ff ff       	call   802787 <find_block>
  802e16:	83 c4 10             	add    $0x10,%esp
  802e19:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802e1c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e1f:	8b 50 08             	mov    0x8(%eax),%edx
  802e22:	8b 45 08             	mov    0x8(%ebp),%eax
  802e25:	01 c2                	add    %eax,%edx
  802e27:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e2a:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802e2d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e30:	8b 40 0c             	mov    0xc(%eax),%eax
  802e33:	2b 45 08             	sub    0x8(%ebp),%eax
  802e36:	89 c2                	mov    %eax,%edx
  802e38:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e3b:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802e3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e41:	eb 05                	jmp    802e48 <alloc_block_BF+0x20f>
	}
	return NULL;
  802e43:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e48:	c9                   	leave  
  802e49:	c3                   	ret    

00802e4a <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802e4a:	55                   	push   %ebp
  802e4b:	89 e5                	mov    %esp,%ebp
  802e4d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802e50:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e55:	85 c0                	test   %eax,%eax
  802e57:	0f 85 de 01 00 00    	jne    80303b <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802e5d:	a1 38 51 80 00       	mov    0x805138,%eax
  802e62:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e65:	e9 9e 01 00 00       	jmp    803008 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802e6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6d:	8b 40 0c             	mov    0xc(%eax),%eax
  802e70:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e73:	0f 82 87 01 00 00    	jb     803000 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802e79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e7f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e82:	0f 85 95 00 00 00    	jne    802f1d <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802e88:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e8c:	75 17                	jne    802ea5 <alloc_block_NF+0x5b>
  802e8e:	83 ec 04             	sub    $0x4,%esp
  802e91:	68 24 48 80 00       	push   $0x804824
  802e96:	68 e0 00 00 00       	push   $0xe0
  802e9b:	68 7b 47 80 00       	push   $0x80477b
  802ea0:	e8 32 da ff ff       	call   8008d7 <_panic>
  802ea5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea8:	8b 00                	mov    (%eax),%eax
  802eaa:	85 c0                	test   %eax,%eax
  802eac:	74 10                	je     802ebe <alloc_block_NF+0x74>
  802eae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb1:	8b 00                	mov    (%eax),%eax
  802eb3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802eb6:	8b 52 04             	mov    0x4(%edx),%edx
  802eb9:	89 50 04             	mov    %edx,0x4(%eax)
  802ebc:	eb 0b                	jmp    802ec9 <alloc_block_NF+0x7f>
  802ebe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec1:	8b 40 04             	mov    0x4(%eax),%eax
  802ec4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ec9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecc:	8b 40 04             	mov    0x4(%eax),%eax
  802ecf:	85 c0                	test   %eax,%eax
  802ed1:	74 0f                	je     802ee2 <alloc_block_NF+0x98>
  802ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed6:	8b 40 04             	mov    0x4(%eax),%eax
  802ed9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802edc:	8b 12                	mov    (%edx),%edx
  802ede:	89 10                	mov    %edx,(%eax)
  802ee0:	eb 0a                	jmp    802eec <alloc_block_NF+0xa2>
  802ee2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee5:	8b 00                	mov    (%eax),%eax
  802ee7:	a3 38 51 80 00       	mov    %eax,0x805138
  802eec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ef5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eff:	a1 44 51 80 00       	mov    0x805144,%eax
  802f04:	48                   	dec    %eax
  802f05:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802f0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0d:	8b 40 08             	mov    0x8(%eax),%eax
  802f10:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   return  point;
  802f15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f18:	e9 f8 04 00 00       	jmp    803415 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f20:	8b 40 0c             	mov    0xc(%eax),%eax
  802f23:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f26:	0f 86 d4 00 00 00    	jbe    803000 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802f2c:	a1 48 51 80 00       	mov    0x805148,%eax
  802f31:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802f34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f37:	8b 50 08             	mov    0x8(%eax),%edx
  802f3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f3d:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802f40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f43:	8b 55 08             	mov    0x8(%ebp),%edx
  802f46:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802f49:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f4d:	75 17                	jne    802f66 <alloc_block_NF+0x11c>
  802f4f:	83 ec 04             	sub    $0x4,%esp
  802f52:	68 24 48 80 00       	push   $0x804824
  802f57:	68 e9 00 00 00       	push   $0xe9
  802f5c:	68 7b 47 80 00       	push   $0x80477b
  802f61:	e8 71 d9 ff ff       	call   8008d7 <_panic>
  802f66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f69:	8b 00                	mov    (%eax),%eax
  802f6b:	85 c0                	test   %eax,%eax
  802f6d:	74 10                	je     802f7f <alloc_block_NF+0x135>
  802f6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f72:	8b 00                	mov    (%eax),%eax
  802f74:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f77:	8b 52 04             	mov    0x4(%edx),%edx
  802f7a:	89 50 04             	mov    %edx,0x4(%eax)
  802f7d:	eb 0b                	jmp    802f8a <alloc_block_NF+0x140>
  802f7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f82:	8b 40 04             	mov    0x4(%eax),%eax
  802f85:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f8d:	8b 40 04             	mov    0x4(%eax),%eax
  802f90:	85 c0                	test   %eax,%eax
  802f92:	74 0f                	je     802fa3 <alloc_block_NF+0x159>
  802f94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f97:	8b 40 04             	mov    0x4(%eax),%eax
  802f9a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f9d:	8b 12                	mov    (%edx),%edx
  802f9f:	89 10                	mov    %edx,(%eax)
  802fa1:	eb 0a                	jmp    802fad <alloc_block_NF+0x163>
  802fa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fa6:	8b 00                	mov    (%eax),%eax
  802fa8:	a3 48 51 80 00       	mov    %eax,0x805148
  802fad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fc0:	a1 54 51 80 00       	mov    0x805154,%eax
  802fc5:	48                   	dec    %eax
  802fc6:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802fcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fce:	8b 40 08             	mov    0x8(%eax),%eax
  802fd1:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   point->sva += size;
  802fd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd9:	8b 50 08             	mov    0x8(%eax),%edx
  802fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdf:	01 c2                	add    %eax,%edx
  802fe1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe4:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802fe7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fea:	8b 40 0c             	mov    0xc(%eax),%eax
  802fed:	2b 45 08             	sub    0x8(%ebp),%eax
  802ff0:	89 c2                	mov    %eax,%edx
  802ff2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff5:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802ff8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ffb:	e9 15 04 00 00       	jmp    803415 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  803000:	a1 40 51 80 00       	mov    0x805140,%eax
  803005:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803008:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80300c:	74 07                	je     803015 <alloc_block_NF+0x1cb>
  80300e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803011:	8b 00                	mov    (%eax),%eax
  803013:	eb 05                	jmp    80301a <alloc_block_NF+0x1d0>
  803015:	b8 00 00 00 00       	mov    $0x0,%eax
  80301a:	a3 40 51 80 00       	mov    %eax,0x805140
  80301f:	a1 40 51 80 00       	mov    0x805140,%eax
  803024:	85 c0                	test   %eax,%eax
  803026:	0f 85 3e fe ff ff    	jne    802e6a <alloc_block_NF+0x20>
  80302c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803030:	0f 85 34 fe ff ff    	jne    802e6a <alloc_block_NF+0x20>
  803036:	e9 d5 03 00 00       	jmp    803410 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80303b:	a1 38 51 80 00       	mov    0x805138,%eax
  803040:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803043:	e9 b1 01 00 00       	jmp    8031f9 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  803048:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304b:	8b 50 08             	mov    0x8(%eax),%edx
  80304e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803053:	39 c2                	cmp    %eax,%edx
  803055:	0f 82 96 01 00 00    	jb     8031f1 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  80305b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305e:	8b 40 0c             	mov    0xc(%eax),%eax
  803061:	3b 45 08             	cmp    0x8(%ebp),%eax
  803064:	0f 82 87 01 00 00    	jb     8031f1 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  80306a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306d:	8b 40 0c             	mov    0xc(%eax),%eax
  803070:	3b 45 08             	cmp    0x8(%ebp),%eax
  803073:	0f 85 95 00 00 00    	jne    80310e <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803079:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80307d:	75 17                	jne    803096 <alloc_block_NF+0x24c>
  80307f:	83 ec 04             	sub    $0x4,%esp
  803082:	68 24 48 80 00       	push   $0x804824
  803087:	68 fc 00 00 00       	push   $0xfc
  80308c:	68 7b 47 80 00       	push   $0x80477b
  803091:	e8 41 d8 ff ff       	call   8008d7 <_panic>
  803096:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803099:	8b 00                	mov    (%eax),%eax
  80309b:	85 c0                	test   %eax,%eax
  80309d:	74 10                	je     8030af <alloc_block_NF+0x265>
  80309f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a2:	8b 00                	mov    (%eax),%eax
  8030a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030a7:	8b 52 04             	mov    0x4(%edx),%edx
  8030aa:	89 50 04             	mov    %edx,0x4(%eax)
  8030ad:	eb 0b                	jmp    8030ba <alloc_block_NF+0x270>
  8030af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b2:	8b 40 04             	mov    0x4(%eax),%eax
  8030b5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030bd:	8b 40 04             	mov    0x4(%eax),%eax
  8030c0:	85 c0                	test   %eax,%eax
  8030c2:	74 0f                	je     8030d3 <alloc_block_NF+0x289>
  8030c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c7:	8b 40 04             	mov    0x4(%eax),%eax
  8030ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030cd:	8b 12                	mov    (%edx),%edx
  8030cf:	89 10                	mov    %edx,(%eax)
  8030d1:	eb 0a                	jmp    8030dd <alloc_block_NF+0x293>
  8030d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d6:	8b 00                	mov    (%eax),%eax
  8030d8:	a3 38 51 80 00       	mov    %eax,0x805138
  8030dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030f0:	a1 44 51 80 00       	mov    0x805144,%eax
  8030f5:	48                   	dec    %eax
  8030f6:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8030fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fe:	8b 40 08             	mov    0x8(%eax),%eax
  803101:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  803106:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803109:	e9 07 03 00 00       	jmp    803415 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80310e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803111:	8b 40 0c             	mov    0xc(%eax),%eax
  803114:	3b 45 08             	cmp    0x8(%ebp),%eax
  803117:	0f 86 d4 00 00 00    	jbe    8031f1 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80311d:	a1 48 51 80 00       	mov    0x805148,%eax
  803122:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  803125:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803128:	8b 50 08             	mov    0x8(%eax),%edx
  80312b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80312e:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803131:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803134:	8b 55 08             	mov    0x8(%ebp),%edx
  803137:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80313a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80313e:	75 17                	jne    803157 <alloc_block_NF+0x30d>
  803140:	83 ec 04             	sub    $0x4,%esp
  803143:	68 24 48 80 00       	push   $0x804824
  803148:	68 04 01 00 00       	push   $0x104
  80314d:	68 7b 47 80 00       	push   $0x80477b
  803152:	e8 80 d7 ff ff       	call   8008d7 <_panic>
  803157:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80315a:	8b 00                	mov    (%eax),%eax
  80315c:	85 c0                	test   %eax,%eax
  80315e:	74 10                	je     803170 <alloc_block_NF+0x326>
  803160:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803163:	8b 00                	mov    (%eax),%eax
  803165:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803168:	8b 52 04             	mov    0x4(%edx),%edx
  80316b:	89 50 04             	mov    %edx,0x4(%eax)
  80316e:	eb 0b                	jmp    80317b <alloc_block_NF+0x331>
  803170:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803173:	8b 40 04             	mov    0x4(%eax),%eax
  803176:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80317b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80317e:	8b 40 04             	mov    0x4(%eax),%eax
  803181:	85 c0                	test   %eax,%eax
  803183:	74 0f                	je     803194 <alloc_block_NF+0x34a>
  803185:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803188:	8b 40 04             	mov    0x4(%eax),%eax
  80318b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80318e:	8b 12                	mov    (%edx),%edx
  803190:	89 10                	mov    %edx,(%eax)
  803192:	eb 0a                	jmp    80319e <alloc_block_NF+0x354>
  803194:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803197:	8b 00                	mov    (%eax),%eax
  803199:	a3 48 51 80 00       	mov    %eax,0x805148
  80319e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031aa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031b1:	a1 54 51 80 00       	mov    0x805154,%eax
  8031b6:	48                   	dec    %eax
  8031b7:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8031bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031bf:	8b 40 08             	mov    0x8(%eax),%eax
  8031c2:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  8031c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ca:	8b 50 08             	mov    0x8(%eax),%edx
  8031cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d0:	01 c2                	add    %eax,%edx
  8031d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d5:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8031d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031db:	8b 40 0c             	mov    0xc(%eax),%eax
  8031de:	2b 45 08             	sub    0x8(%ebp),%eax
  8031e1:	89 c2                	mov    %eax,%edx
  8031e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e6:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8031e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ec:	e9 24 02 00 00       	jmp    803415 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8031f1:	a1 40 51 80 00       	mov    0x805140,%eax
  8031f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031fd:	74 07                	je     803206 <alloc_block_NF+0x3bc>
  8031ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803202:	8b 00                	mov    (%eax),%eax
  803204:	eb 05                	jmp    80320b <alloc_block_NF+0x3c1>
  803206:	b8 00 00 00 00       	mov    $0x0,%eax
  80320b:	a3 40 51 80 00       	mov    %eax,0x805140
  803210:	a1 40 51 80 00       	mov    0x805140,%eax
  803215:	85 c0                	test   %eax,%eax
  803217:	0f 85 2b fe ff ff    	jne    803048 <alloc_block_NF+0x1fe>
  80321d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803221:	0f 85 21 fe ff ff    	jne    803048 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803227:	a1 38 51 80 00       	mov    0x805138,%eax
  80322c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80322f:	e9 ae 01 00 00       	jmp    8033e2 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  803234:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803237:	8b 50 08             	mov    0x8(%eax),%edx
  80323a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80323f:	39 c2                	cmp    %eax,%edx
  803241:	0f 83 93 01 00 00    	jae    8033da <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  803247:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324a:	8b 40 0c             	mov    0xc(%eax),%eax
  80324d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803250:	0f 82 84 01 00 00    	jb     8033da <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  803256:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803259:	8b 40 0c             	mov    0xc(%eax),%eax
  80325c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80325f:	0f 85 95 00 00 00    	jne    8032fa <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803265:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803269:	75 17                	jne    803282 <alloc_block_NF+0x438>
  80326b:	83 ec 04             	sub    $0x4,%esp
  80326e:	68 24 48 80 00       	push   $0x804824
  803273:	68 14 01 00 00       	push   $0x114
  803278:	68 7b 47 80 00       	push   $0x80477b
  80327d:	e8 55 d6 ff ff       	call   8008d7 <_panic>
  803282:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803285:	8b 00                	mov    (%eax),%eax
  803287:	85 c0                	test   %eax,%eax
  803289:	74 10                	je     80329b <alloc_block_NF+0x451>
  80328b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328e:	8b 00                	mov    (%eax),%eax
  803290:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803293:	8b 52 04             	mov    0x4(%edx),%edx
  803296:	89 50 04             	mov    %edx,0x4(%eax)
  803299:	eb 0b                	jmp    8032a6 <alloc_block_NF+0x45c>
  80329b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80329e:	8b 40 04             	mov    0x4(%eax),%eax
  8032a1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a9:	8b 40 04             	mov    0x4(%eax),%eax
  8032ac:	85 c0                	test   %eax,%eax
  8032ae:	74 0f                	je     8032bf <alloc_block_NF+0x475>
  8032b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b3:	8b 40 04             	mov    0x4(%eax),%eax
  8032b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032b9:	8b 12                	mov    (%edx),%edx
  8032bb:	89 10                	mov    %edx,(%eax)
  8032bd:	eb 0a                	jmp    8032c9 <alloc_block_NF+0x47f>
  8032bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c2:	8b 00                	mov    (%eax),%eax
  8032c4:	a3 38 51 80 00       	mov    %eax,0x805138
  8032c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032dc:	a1 44 51 80 00       	mov    0x805144,%eax
  8032e1:	48                   	dec    %eax
  8032e2:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8032e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ea:	8b 40 08             	mov    0x8(%eax),%eax
  8032ed:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  8032f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f5:	e9 1b 01 00 00       	jmp    803415 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8032fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032fd:	8b 40 0c             	mov    0xc(%eax),%eax
  803300:	3b 45 08             	cmp    0x8(%ebp),%eax
  803303:	0f 86 d1 00 00 00    	jbe    8033da <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803309:	a1 48 51 80 00       	mov    0x805148,%eax
  80330e:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  803311:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803314:	8b 50 08             	mov    0x8(%eax),%edx
  803317:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80331a:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80331d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803320:	8b 55 08             	mov    0x8(%ebp),%edx
  803323:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803326:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80332a:	75 17                	jne    803343 <alloc_block_NF+0x4f9>
  80332c:	83 ec 04             	sub    $0x4,%esp
  80332f:	68 24 48 80 00       	push   $0x804824
  803334:	68 1c 01 00 00       	push   $0x11c
  803339:	68 7b 47 80 00       	push   $0x80477b
  80333e:	e8 94 d5 ff ff       	call   8008d7 <_panic>
  803343:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803346:	8b 00                	mov    (%eax),%eax
  803348:	85 c0                	test   %eax,%eax
  80334a:	74 10                	je     80335c <alloc_block_NF+0x512>
  80334c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80334f:	8b 00                	mov    (%eax),%eax
  803351:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803354:	8b 52 04             	mov    0x4(%edx),%edx
  803357:	89 50 04             	mov    %edx,0x4(%eax)
  80335a:	eb 0b                	jmp    803367 <alloc_block_NF+0x51d>
  80335c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80335f:	8b 40 04             	mov    0x4(%eax),%eax
  803362:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803367:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80336a:	8b 40 04             	mov    0x4(%eax),%eax
  80336d:	85 c0                	test   %eax,%eax
  80336f:	74 0f                	je     803380 <alloc_block_NF+0x536>
  803371:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803374:	8b 40 04             	mov    0x4(%eax),%eax
  803377:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80337a:	8b 12                	mov    (%edx),%edx
  80337c:	89 10                	mov    %edx,(%eax)
  80337e:	eb 0a                	jmp    80338a <alloc_block_NF+0x540>
  803380:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803383:	8b 00                	mov    (%eax),%eax
  803385:	a3 48 51 80 00       	mov    %eax,0x805148
  80338a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80338d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803393:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803396:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80339d:	a1 54 51 80 00       	mov    0x805154,%eax
  8033a2:	48                   	dec    %eax
  8033a3:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8033a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033ab:	8b 40 08             	mov    0x8(%eax),%eax
  8033ae:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  8033b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b6:	8b 50 08             	mov    0x8(%eax),%edx
  8033b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033bc:	01 c2                	add    %eax,%edx
  8033be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c1:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8033c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8033ca:	2b 45 08             	sub    0x8(%ebp),%eax
  8033cd:	89 c2                	mov    %eax,%edx
  8033cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d2:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8033d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033d8:	eb 3b                	jmp    803415 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8033da:	a1 40 51 80 00       	mov    0x805140,%eax
  8033df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033e6:	74 07                	je     8033ef <alloc_block_NF+0x5a5>
  8033e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033eb:	8b 00                	mov    (%eax),%eax
  8033ed:	eb 05                	jmp    8033f4 <alloc_block_NF+0x5aa>
  8033ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8033f4:	a3 40 51 80 00       	mov    %eax,0x805140
  8033f9:	a1 40 51 80 00       	mov    0x805140,%eax
  8033fe:	85 c0                	test   %eax,%eax
  803400:	0f 85 2e fe ff ff    	jne    803234 <alloc_block_NF+0x3ea>
  803406:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80340a:	0f 85 24 fe ff ff    	jne    803234 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  803410:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803415:	c9                   	leave  
  803416:	c3                   	ret    

00803417 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803417:	55                   	push   %ebp
  803418:	89 e5                	mov    %esp,%ebp
  80341a:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  80341d:	a1 38 51 80 00       	mov    0x805138,%eax
  803422:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  803425:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80342a:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  80342d:	a1 38 51 80 00       	mov    0x805138,%eax
  803432:	85 c0                	test   %eax,%eax
  803434:	74 14                	je     80344a <insert_sorted_with_merge_freeList+0x33>
  803436:	8b 45 08             	mov    0x8(%ebp),%eax
  803439:	8b 50 08             	mov    0x8(%eax),%edx
  80343c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80343f:	8b 40 08             	mov    0x8(%eax),%eax
  803442:	39 c2                	cmp    %eax,%edx
  803444:	0f 87 9b 01 00 00    	ja     8035e5 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  80344a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80344e:	75 17                	jne    803467 <insert_sorted_with_merge_freeList+0x50>
  803450:	83 ec 04             	sub    $0x4,%esp
  803453:	68 58 47 80 00       	push   $0x804758
  803458:	68 38 01 00 00       	push   $0x138
  80345d:	68 7b 47 80 00       	push   $0x80477b
  803462:	e8 70 d4 ff ff       	call   8008d7 <_panic>
  803467:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80346d:	8b 45 08             	mov    0x8(%ebp),%eax
  803470:	89 10                	mov    %edx,(%eax)
  803472:	8b 45 08             	mov    0x8(%ebp),%eax
  803475:	8b 00                	mov    (%eax),%eax
  803477:	85 c0                	test   %eax,%eax
  803479:	74 0d                	je     803488 <insert_sorted_with_merge_freeList+0x71>
  80347b:	a1 38 51 80 00       	mov    0x805138,%eax
  803480:	8b 55 08             	mov    0x8(%ebp),%edx
  803483:	89 50 04             	mov    %edx,0x4(%eax)
  803486:	eb 08                	jmp    803490 <insert_sorted_with_merge_freeList+0x79>
  803488:	8b 45 08             	mov    0x8(%ebp),%eax
  80348b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803490:	8b 45 08             	mov    0x8(%ebp),%eax
  803493:	a3 38 51 80 00       	mov    %eax,0x805138
  803498:	8b 45 08             	mov    0x8(%ebp),%eax
  80349b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034a2:	a1 44 51 80 00       	mov    0x805144,%eax
  8034a7:	40                   	inc    %eax
  8034a8:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8034ad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8034b1:	0f 84 a8 06 00 00    	je     803b5f <insert_sorted_with_merge_freeList+0x748>
  8034b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ba:	8b 50 08             	mov    0x8(%eax),%edx
  8034bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8034c3:	01 c2                	add    %eax,%edx
  8034c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034c8:	8b 40 08             	mov    0x8(%eax),%eax
  8034cb:	39 c2                	cmp    %eax,%edx
  8034cd:	0f 85 8c 06 00 00    	jne    803b5f <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  8034d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d6:	8b 50 0c             	mov    0xc(%eax),%edx
  8034d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8034df:	01 c2                	add    %eax,%edx
  8034e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e4:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  8034e7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8034eb:	75 17                	jne    803504 <insert_sorted_with_merge_freeList+0xed>
  8034ed:	83 ec 04             	sub    $0x4,%esp
  8034f0:	68 24 48 80 00       	push   $0x804824
  8034f5:	68 3c 01 00 00       	push   $0x13c
  8034fa:	68 7b 47 80 00       	push   $0x80477b
  8034ff:	e8 d3 d3 ff ff       	call   8008d7 <_panic>
  803504:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803507:	8b 00                	mov    (%eax),%eax
  803509:	85 c0                	test   %eax,%eax
  80350b:	74 10                	je     80351d <insert_sorted_with_merge_freeList+0x106>
  80350d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803510:	8b 00                	mov    (%eax),%eax
  803512:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803515:	8b 52 04             	mov    0x4(%edx),%edx
  803518:	89 50 04             	mov    %edx,0x4(%eax)
  80351b:	eb 0b                	jmp    803528 <insert_sorted_with_merge_freeList+0x111>
  80351d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803520:	8b 40 04             	mov    0x4(%eax),%eax
  803523:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803528:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80352b:	8b 40 04             	mov    0x4(%eax),%eax
  80352e:	85 c0                	test   %eax,%eax
  803530:	74 0f                	je     803541 <insert_sorted_with_merge_freeList+0x12a>
  803532:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803535:	8b 40 04             	mov    0x4(%eax),%eax
  803538:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80353b:	8b 12                	mov    (%edx),%edx
  80353d:	89 10                	mov    %edx,(%eax)
  80353f:	eb 0a                	jmp    80354b <insert_sorted_with_merge_freeList+0x134>
  803541:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803544:	8b 00                	mov    (%eax),%eax
  803546:	a3 38 51 80 00       	mov    %eax,0x805138
  80354b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80354e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803554:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803557:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80355e:	a1 44 51 80 00       	mov    0x805144,%eax
  803563:	48                   	dec    %eax
  803564:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  803569:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80356c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803573:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803576:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  80357d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803581:	75 17                	jne    80359a <insert_sorted_with_merge_freeList+0x183>
  803583:	83 ec 04             	sub    $0x4,%esp
  803586:	68 58 47 80 00       	push   $0x804758
  80358b:	68 3f 01 00 00       	push   $0x13f
  803590:	68 7b 47 80 00       	push   $0x80477b
  803595:	e8 3d d3 ff ff       	call   8008d7 <_panic>
  80359a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8035a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035a3:	89 10                	mov    %edx,(%eax)
  8035a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035a8:	8b 00                	mov    (%eax),%eax
  8035aa:	85 c0                	test   %eax,%eax
  8035ac:	74 0d                	je     8035bb <insert_sorted_with_merge_freeList+0x1a4>
  8035ae:	a1 48 51 80 00       	mov    0x805148,%eax
  8035b3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035b6:	89 50 04             	mov    %edx,0x4(%eax)
  8035b9:	eb 08                	jmp    8035c3 <insert_sorted_with_merge_freeList+0x1ac>
  8035bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035be:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035c6:	a3 48 51 80 00       	mov    %eax,0x805148
  8035cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035ce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035d5:	a1 54 51 80 00       	mov    0x805154,%eax
  8035da:	40                   	inc    %eax
  8035db:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8035e0:	e9 7a 05 00 00       	jmp    803b5f <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  8035e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e8:	8b 50 08             	mov    0x8(%eax),%edx
  8035eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035ee:	8b 40 08             	mov    0x8(%eax),%eax
  8035f1:	39 c2                	cmp    %eax,%edx
  8035f3:	0f 82 14 01 00 00    	jb     80370d <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8035f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035fc:	8b 50 08             	mov    0x8(%eax),%edx
  8035ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803602:	8b 40 0c             	mov    0xc(%eax),%eax
  803605:	01 c2                	add    %eax,%edx
  803607:	8b 45 08             	mov    0x8(%ebp),%eax
  80360a:	8b 40 08             	mov    0x8(%eax),%eax
  80360d:	39 c2                	cmp    %eax,%edx
  80360f:	0f 85 90 00 00 00    	jne    8036a5 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803615:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803618:	8b 50 0c             	mov    0xc(%eax),%edx
  80361b:	8b 45 08             	mov    0x8(%ebp),%eax
  80361e:	8b 40 0c             	mov    0xc(%eax),%eax
  803621:	01 c2                	add    %eax,%edx
  803623:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803626:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803629:	8b 45 08             	mov    0x8(%ebp),%eax
  80362c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803633:	8b 45 08             	mov    0x8(%ebp),%eax
  803636:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80363d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803641:	75 17                	jne    80365a <insert_sorted_with_merge_freeList+0x243>
  803643:	83 ec 04             	sub    $0x4,%esp
  803646:	68 58 47 80 00       	push   $0x804758
  80364b:	68 49 01 00 00       	push   $0x149
  803650:	68 7b 47 80 00       	push   $0x80477b
  803655:	e8 7d d2 ff ff       	call   8008d7 <_panic>
  80365a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803660:	8b 45 08             	mov    0x8(%ebp),%eax
  803663:	89 10                	mov    %edx,(%eax)
  803665:	8b 45 08             	mov    0x8(%ebp),%eax
  803668:	8b 00                	mov    (%eax),%eax
  80366a:	85 c0                	test   %eax,%eax
  80366c:	74 0d                	je     80367b <insert_sorted_with_merge_freeList+0x264>
  80366e:	a1 48 51 80 00       	mov    0x805148,%eax
  803673:	8b 55 08             	mov    0x8(%ebp),%edx
  803676:	89 50 04             	mov    %edx,0x4(%eax)
  803679:	eb 08                	jmp    803683 <insert_sorted_with_merge_freeList+0x26c>
  80367b:	8b 45 08             	mov    0x8(%ebp),%eax
  80367e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803683:	8b 45 08             	mov    0x8(%ebp),%eax
  803686:	a3 48 51 80 00       	mov    %eax,0x805148
  80368b:	8b 45 08             	mov    0x8(%ebp),%eax
  80368e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803695:	a1 54 51 80 00       	mov    0x805154,%eax
  80369a:	40                   	inc    %eax
  80369b:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8036a0:	e9 bb 04 00 00       	jmp    803b60 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8036a5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036a9:	75 17                	jne    8036c2 <insert_sorted_with_merge_freeList+0x2ab>
  8036ab:	83 ec 04             	sub    $0x4,%esp
  8036ae:	68 cc 47 80 00       	push   $0x8047cc
  8036b3:	68 4c 01 00 00       	push   $0x14c
  8036b8:	68 7b 47 80 00       	push   $0x80477b
  8036bd:	e8 15 d2 ff ff       	call   8008d7 <_panic>
  8036c2:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8036c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036cb:	89 50 04             	mov    %edx,0x4(%eax)
  8036ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d1:	8b 40 04             	mov    0x4(%eax),%eax
  8036d4:	85 c0                	test   %eax,%eax
  8036d6:	74 0c                	je     8036e4 <insert_sorted_with_merge_freeList+0x2cd>
  8036d8:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8036dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8036e0:	89 10                	mov    %edx,(%eax)
  8036e2:	eb 08                	jmp    8036ec <insert_sorted_with_merge_freeList+0x2d5>
  8036e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e7:	a3 38 51 80 00       	mov    %eax,0x805138
  8036ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ef:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8036f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036fd:	a1 44 51 80 00       	mov    0x805144,%eax
  803702:	40                   	inc    %eax
  803703:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803708:	e9 53 04 00 00       	jmp    803b60 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80370d:	a1 38 51 80 00       	mov    0x805138,%eax
  803712:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803715:	e9 15 04 00 00       	jmp    803b2f <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  80371a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80371d:	8b 00                	mov    (%eax),%eax
  80371f:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803722:	8b 45 08             	mov    0x8(%ebp),%eax
  803725:	8b 50 08             	mov    0x8(%eax),%edx
  803728:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80372b:	8b 40 08             	mov    0x8(%eax),%eax
  80372e:	39 c2                	cmp    %eax,%edx
  803730:	0f 86 f1 03 00 00    	jbe    803b27 <insert_sorted_with_merge_freeList+0x710>
  803736:	8b 45 08             	mov    0x8(%ebp),%eax
  803739:	8b 50 08             	mov    0x8(%eax),%edx
  80373c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80373f:	8b 40 08             	mov    0x8(%eax),%eax
  803742:	39 c2                	cmp    %eax,%edx
  803744:	0f 83 dd 03 00 00    	jae    803b27 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  80374a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80374d:	8b 50 08             	mov    0x8(%eax),%edx
  803750:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803753:	8b 40 0c             	mov    0xc(%eax),%eax
  803756:	01 c2                	add    %eax,%edx
  803758:	8b 45 08             	mov    0x8(%ebp),%eax
  80375b:	8b 40 08             	mov    0x8(%eax),%eax
  80375e:	39 c2                	cmp    %eax,%edx
  803760:	0f 85 b9 01 00 00    	jne    80391f <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803766:	8b 45 08             	mov    0x8(%ebp),%eax
  803769:	8b 50 08             	mov    0x8(%eax),%edx
  80376c:	8b 45 08             	mov    0x8(%ebp),%eax
  80376f:	8b 40 0c             	mov    0xc(%eax),%eax
  803772:	01 c2                	add    %eax,%edx
  803774:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803777:	8b 40 08             	mov    0x8(%eax),%eax
  80377a:	39 c2                	cmp    %eax,%edx
  80377c:	0f 85 0d 01 00 00    	jne    80388f <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803782:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803785:	8b 50 0c             	mov    0xc(%eax),%edx
  803788:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80378b:	8b 40 0c             	mov    0xc(%eax),%eax
  80378e:	01 c2                	add    %eax,%edx
  803790:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803793:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803796:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80379a:	75 17                	jne    8037b3 <insert_sorted_with_merge_freeList+0x39c>
  80379c:	83 ec 04             	sub    $0x4,%esp
  80379f:	68 24 48 80 00       	push   $0x804824
  8037a4:	68 5c 01 00 00       	push   $0x15c
  8037a9:	68 7b 47 80 00       	push   $0x80477b
  8037ae:	e8 24 d1 ff ff       	call   8008d7 <_panic>
  8037b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037b6:	8b 00                	mov    (%eax),%eax
  8037b8:	85 c0                	test   %eax,%eax
  8037ba:	74 10                	je     8037cc <insert_sorted_with_merge_freeList+0x3b5>
  8037bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037bf:	8b 00                	mov    (%eax),%eax
  8037c1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037c4:	8b 52 04             	mov    0x4(%edx),%edx
  8037c7:	89 50 04             	mov    %edx,0x4(%eax)
  8037ca:	eb 0b                	jmp    8037d7 <insert_sorted_with_merge_freeList+0x3c0>
  8037cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037cf:	8b 40 04             	mov    0x4(%eax),%eax
  8037d2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8037d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037da:	8b 40 04             	mov    0x4(%eax),%eax
  8037dd:	85 c0                	test   %eax,%eax
  8037df:	74 0f                	je     8037f0 <insert_sorted_with_merge_freeList+0x3d9>
  8037e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037e4:	8b 40 04             	mov    0x4(%eax),%eax
  8037e7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037ea:	8b 12                	mov    (%edx),%edx
  8037ec:	89 10                	mov    %edx,(%eax)
  8037ee:	eb 0a                	jmp    8037fa <insert_sorted_with_merge_freeList+0x3e3>
  8037f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037f3:	8b 00                	mov    (%eax),%eax
  8037f5:	a3 38 51 80 00       	mov    %eax,0x805138
  8037fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037fd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803803:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803806:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80380d:	a1 44 51 80 00       	mov    0x805144,%eax
  803812:	48                   	dec    %eax
  803813:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803818:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80381b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803822:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803825:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80382c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803830:	75 17                	jne    803849 <insert_sorted_with_merge_freeList+0x432>
  803832:	83 ec 04             	sub    $0x4,%esp
  803835:	68 58 47 80 00       	push   $0x804758
  80383a:	68 5f 01 00 00       	push   $0x15f
  80383f:	68 7b 47 80 00       	push   $0x80477b
  803844:	e8 8e d0 ff ff       	call   8008d7 <_panic>
  803849:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80384f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803852:	89 10                	mov    %edx,(%eax)
  803854:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803857:	8b 00                	mov    (%eax),%eax
  803859:	85 c0                	test   %eax,%eax
  80385b:	74 0d                	je     80386a <insert_sorted_with_merge_freeList+0x453>
  80385d:	a1 48 51 80 00       	mov    0x805148,%eax
  803862:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803865:	89 50 04             	mov    %edx,0x4(%eax)
  803868:	eb 08                	jmp    803872 <insert_sorted_with_merge_freeList+0x45b>
  80386a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80386d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803872:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803875:	a3 48 51 80 00       	mov    %eax,0x805148
  80387a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80387d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803884:	a1 54 51 80 00       	mov    0x805154,%eax
  803889:	40                   	inc    %eax
  80388a:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  80388f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803892:	8b 50 0c             	mov    0xc(%eax),%edx
  803895:	8b 45 08             	mov    0x8(%ebp),%eax
  803898:	8b 40 0c             	mov    0xc(%eax),%eax
  80389b:	01 c2                	add    %eax,%edx
  80389d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038a0:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8038a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8038ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8038b7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038bb:	75 17                	jne    8038d4 <insert_sorted_with_merge_freeList+0x4bd>
  8038bd:	83 ec 04             	sub    $0x4,%esp
  8038c0:	68 58 47 80 00       	push   $0x804758
  8038c5:	68 64 01 00 00       	push   $0x164
  8038ca:	68 7b 47 80 00       	push   $0x80477b
  8038cf:	e8 03 d0 ff ff       	call   8008d7 <_panic>
  8038d4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8038da:	8b 45 08             	mov    0x8(%ebp),%eax
  8038dd:	89 10                	mov    %edx,(%eax)
  8038df:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e2:	8b 00                	mov    (%eax),%eax
  8038e4:	85 c0                	test   %eax,%eax
  8038e6:	74 0d                	je     8038f5 <insert_sorted_with_merge_freeList+0x4de>
  8038e8:	a1 48 51 80 00       	mov    0x805148,%eax
  8038ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8038f0:	89 50 04             	mov    %edx,0x4(%eax)
  8038f3:	eb 08                	jmp    8038fd <insert_sorted_with_merge_freeList+0x4e6>
  8038f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8038fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803900:	a3 48 51 80 00       	mov    %eax,0x805148
  803905:	8b 45 08             	mov    0x8(%ebp),%eax
  803908:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80390f:	a1 54 51 80 00       	mov    0x805154,%eax
  803914:	40                   	inc    %eax
  803915:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80391a:	e9 41 02 00 00       	jmp    803b60 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80391f:	8b 45 08             	mov    0x8(%ebp),%eax
  803922:	8b 50 08             	mov    0x8(%eax),%edx
  803925:	8b 45 08             	mov    0x8(%ebp),%eax
  803928:	8b 40 0c             	mov    0xc(%eax),%eax
  80392b:	01 c2                	add    %eax,%edx
  80392d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803930:	8b 40 08             	mov    0x8(%eax),%eax
  803933:	39 c2                	cmp    %eax,%edx
  803935:	0f 85 7c 01 00 00    	jne    803ab7 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80393b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80393f:	74 06                	je     803947 <insert_sorted_with_merge_freeList+0x530>
  803941:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803945:	75 17                	jne    80395e <insert_sorted_with_merge_freeList+0x547>
  803947:	83 ec 04             	sub    $0x4,%esp
  80394a:	68 94 47 80 00       	push   $0x804794
  80394f:	68 69 01 00 00       	push   $0x169
  803954:	68 7b 47 80 00       	push   $0x80477b
  803959:	e8 79 cf ff ff       	call   8008d7 <_panic>
  80395e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803961:	8b 50 04             	mov    0x4(%eax),%edx
  803964:	8b 45 08             	mov    0x8(%ebp),%eax
  803967:	89 50 04             	mov    %edx,0x4(%eax)
  80396a:	8b 45 08             	mov    0x8(%ebp),%eax
  80396d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803970:	89 10                	mov    %edx,(%eax)
  803972:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803975:	8b 40 04             	mov    0x4(%eax),%eax
  803978:	85 c0                	test   %eax,%eax
  80397a:	74 0d                	je     803989 <insert_sorted_with_merge_freeList+0x572>
  80397c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80397f:	8b 40 04             	mov    0x4(%eax),%eax
  803982:	8b 55 08             	mov    0x8(%ebp),%edx
  803985:	89 10                	mov    %edx,(%eax)
  803987:	eb 08                	jmp    803991 <insert_sorted_with_merge_freeList+0x57a>
  803989:	8b 45 08             	mov    0x8(%ebp),%eax
  80398c:	a3 38 51 80 00       	mov    %eax,0x805138
  803991:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803994:	8b 55 08             	mov    0x8(%ebp),%edx
  803997:	89 50 04             	mov    %edx,0x4(%eax)
  80399a:	a1 44 51 80 00       	mov    0x805144,%eax
  80399f:	40                   	inc    %eax
  8039a0:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8039a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8039a8:	8b 50 0c             	mov    0xc(%eax),%edx
  8039ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8039b1:	01 c2                	add    %eax,%edx
  8039b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8039b6:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8039b9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8039bd:	75 17                	jne    8039d6 <insert_sorted_with_merge_freeList+0x5bf>
  8039bf:	83 ec 04             	sub    $0x4,%esp
  8039c2:	68 24 48 80 00       	push   $0x804824
  8039c7:	68 6b 01 00 00       	push   $0x16b
  8039cc:	68 7b 47 80 00       	push   $0x80477b
  8039d1:	e8 01 cf ff ff       	call   8008d7 <_panic>
  8039d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039d9:	8b 00                	mov    (%eax),%eax
  8039db:	85 c0                	test   %eax,%eax
  8039dd:	74 10                	je     8039ef <insert_sorted_with_merge_freeList+0x5d8>
  8039df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039e2:	8b 00                	mov    (%eax),%eax
  8039e4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039e7:	8b 52 04             	mov    0x4(%edx),%edx
  8039ea:	89 50 04             	mov    %edx,0x4(%eax)
  8039ed:	eb 0b                	jmp    8039fa <insert_sorted_with_merge_freeList+0x5e3>
  8039ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039f2:	8b 40 04             	mov    0x4(%eax),%eax
  8039f5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8039fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039fd:	8b 40 04             	mov    0x4(%eax),%eax
  803a00:	85 c0                	test   %eax,%eax
  803a02:	74 0f                	je     803a13 <insert_sorted_with_merge_freeList+0x5fc>
  803a04:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a07:	8b 40 04             	mov    0x4(%eax),%eax
  803a0a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a0d:	8b 12                	mov    (%edx),%edx
  803a0f:	89 10                	mov    %edx,(%eax)
  803a11:	eb 0a                	jmp    803a1d <insert_sorted_with_merge_freeList+0x606>
  803a13:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a16:	8b 00                	mov    (%eax),%eax
  803a18:	a3 38 51 80 00       	mov    %eax,0x805138
  803a1d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a20:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a26:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a29:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a30:	a1 44 51 80 00       	mov    0x805144,%eax
  803a35:	48                   	dec    %eax
  803a36:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803a3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a3e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803a45:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a48:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803a4f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803a53:	75 17                	jne    803a6c <insert_sorted_with_merge_freeList+0x655>
  803a55:	83 ec 04             	sub    $0x4,%esp
  803a58:	68 58 47 80 00       	push   $0x804758
  803a5d:	68 6e 01 00 00       	push   $0x16e
  803a62:	68 7b 47 80 00       	push   $0x80477b
  803a67:	e8 6b ce ff ff       	call   8008d7 <_panic>
  803a6c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a72:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a75:	89 10                	mov    %edx,(%eax)
  803a77:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a7a:	8b 00                	mov    (%eax),%eax
  803a7c:	85 c0                	test   %eax,%eax
  803a7e:	74 0d                	je     803a8d <insert_sorted_with_merge_freeList+0x676>
  803a80:	a1 48 51 80 00       	mov    0x805148,%eax
  803a85:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a88:	89 50 04             	mov    %edx,0x4(%eax)
  803a8b:	eb 08                	jmp    803a95 <insert_sorted_with_merge_freeList+0x67e>
  803a8d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a90:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803a95:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a98:	a3 48 51 80 00       	mov    %eax,0x805148
  803a9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803aa0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803aa7:	a1 54 51 80 00       	mov    0x805154,%eax
  803aac:	40                   	inc    %eax
  803aad:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803ab2:	e9 a9 00 00 00       	jmp    803b60 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803ab7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803abb:	74 06                	je     803ac3 <insert_sorted_with_merge_freeList+0x6ac>
  803abd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803ac1:	75 17                	jne    803ada <insert_sorted_with_merge_freeList+0x6c3>
  803ac3:	83 ec 04             	sub    $0x4,%esp
  803ac6:	68 f0 47 80 00       	push   $0x8047f0
  803acb:	68 73 01 00 00       	push   $0x173
  803ad0:	68 7b 47 80 00       	push   $0x80477b
  803ad5:	e8 fd cd ff ff       	call   8008d7 <_panic>
  803ada:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803add:	8b 10                	mov    (%eax),%edx
  803adf:	8b 45 08             	mov    0x8(%ebp),%eax
  803ae2:	89 10                	mov    %edx,(%eax)
  803ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  803ae7:	8b 00                	mov    (%eax),%eax
  803ae9:	85 c0                	test   %eax,%eax
  803aeb:	74 0b                	je     803af8 <insert_sorted_with_merge_freeList+0x6e1>
  803aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803af0:	8b 00                	mov    (%eax),%eax
  803af2:	8b 55 08             	mov    0x8(%ebp),%edx
  803af5:	89 50 04             	mov    %edx,0x4(%eax)
  803af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803afb:	8b 55 08             	mov    0x8(%ebp),%edx
  803afe:	89 10                	mov    %edx,(%eax)
  803b00:	8b 45 08             	mov    0x8(%ebp),%eax
  803b03:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b06:	89 50 04             	mov    %edx,0x4(%eax)
  803b09:	8b 45 08             	mov    0x8(%ebp),%eax
  803b0c:	8b 00                	mov    (%eax),%eax
  803b0e:	85 c0                	test   %eax,%eax
  803b10:	75 08                	jne    803b1a <insert_sorted_with_merge_freeList+0x703>
  803b12:	8b 45 08             	mov    0x8(%ebp),%eax
  803b15:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803b1a:	a1 44 51 80 00       	mov    0x805144,%eax
  803b1f:	40                   	inc    %eax
  803b20:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803b25:	eb 39                	jmp    803b60 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803b27:	a1 40 51 80 00       	mov    0x805140,%eax
  803b2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803b2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b33:	74 07                	je     803b3c <insert_sorted_with_merge_freeList+0x725>
  803b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b38:	8b 00                	mov    (%eax),%eax
  803b3a:	eb 05                	jmp    803b41 <insert_sorted_with_merge_freeList+0x72a>
  803b3c:	b8 00 00 00 00       	mov    $0x0,%eax
  803b41:	a3 40 51 80 00       	mov    %eax,0x805140
  803b46:	a1 40 51 80 00       	mov    0x805140,%eax
  803b4b:	85 c0                	test   %eax,%eax
  803b4d:	0f 85 c7 fb ff ff    	jne    80371a <insert_sorted_with_merge_freeList+0x303>
  803b53:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b57:	0f 85 bd fb ff ff    	jne    80371a <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803b5d:	eb 01                	jmp    803b60 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803b5f:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803b60:	90                   	nop
  803b61:	c9                   	leave  
  803b62:	c3                   	ret    
  803b63:	90                   	nop

00803b64 <__udivdi3>:
  803b64:	55                   	push   %ebp
  803b65:	57                   	push   %edi
  803b66:	56                   	push   %esi
  803b67:	53                   	push   %ebx
  803b68:	83 ec 1c             	sub    $0x1c,%esp
  803b6b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803b6f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b73:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b77:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b7b:	89 ca                	mov    %ecx,%edx
  803b7d:	89 f8                	mov    %edi,%eax
  803b7f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803b83:	85 f6                	test   %esi,%esi
  803b85:	75 2d                	jne    803bb4 <__udivdi3+0x50>
  803b87:	39 cf                	cmp    %ecx,%edi
  803b89:	77 65                	ja     803bf0 <__udivdi3+0x8c>
  803b8b:	89 fd                	mov    %edi,%ebp
  803b8d:	85 ff                	test   %edi,%edi
  803b8f:	75 0b                	jne    803b9c <__udivdi3+0x38>
  803b91:	b8 01 00 00 00       	mov    $0x1,%eax
  803b96:	31 d2                	xor    %edx,%edx
  803b98:	f7 f7                	div    %edi
  803b9a:	89 c5                	mov    %eax,%ebp
  803b9c:	31 d2                	xor    %edx,%edx
  803b9e:	89 c8                	mov    %ecx,%eax
  803ba0:	f7 f5                	div    %ebp
  803ba2:	89 c1                	mov    %eax,%ecx
  803ba4:	89 d8                	mov    %ebx,%eax
  803ba6:	f7 f5                	div    %ebp
  803ba8:	89 cf                	mov    %ecx,%edi
  803baa:	89 fa                	mov    %edi,%edx
  803bac:	83 c4 1c             	add    $0x1c,%esp
  803baf:	5b                   	pop    %ebx
  803bb0:	5e                   	pop    %esi
  803bb1:	5f                   	pop    %edi
  803bb2:	5d                   	pop    %ebp
  803bb3:	c3                   	ret    
  803bb4:	39 ce                	cmp    %ecx,%esi
  803bb6:	77 28                	ja     803be0 <__udivdi3+0x7c>
  803bb8:	0f bd fe             	bsr    %esi,%edi
  803bbb:	83 f7 1f             	xor    $0x1f,%edi
  803bbe:	75 40                	jne    803c00 <__udivdi3+0x9c>
  803bc0:	39 ce                	cmp    %ecx,%esi
  803bc2:	72 0a                	jb     803bce <__udivdi3+0x6a>
  803bc4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803bc8:	0f 87 9e 00 00 00    	ja     803c6c <__udivdi3+0x108>
  803bce:	b8 01 00 00 00       	mov    $0x1,%eax
  803bd3:	89 fa                	mov    %edi,%edx
  803bd5:	83 c4 1c             	add    $0x1c,%esp
  803bd8:	5b                   	pop    %ebx
  803bd9:	5e                   	pop    %esi
  803bda:	5f                   	pop    %edi
  803bdb:	5d                   	pop    %ebp
  803bdc:	c3                   	ret    
  803bdd:	8d 76 00             	lea    0x0(%esi),%esi
  803be0:	31 ff                	xor    %edi,%edi
  803be2:	31 c0                	xor    %eax,%eax
  803be4:	89 fa                	mov    %edi,%edx
  803be6:	83 c4 1c             	add    $0x1c,%esp
  803be9:	5b                   	pop    %ebx
  803bea:	5e                   	pop    %esi
  803beb:	5f                   	pop    %edi
  803bec:	5d                   	pop    %ebp
  803bed:	c3                   	ret    
  803bee:	66 90                	xchg   %ax,%ax
  803bf0:	89 d8                	mov    %ebx,%eax
  803bf2:	f7 f7                	div    %edi
  803bf4:	31 ff                	xor    %edi,%edi
  803bf6:	89 fa                	mov    %edi,%edx
  803bf8:	83 c4 1c             	add    $0x1c,%esp
  803bfb:	5b                   	pop    %ebx
  803bfc:	5e                   	pop    %esi
  803bfd:	5f                   	pop    %edi
  803bfe:	5d                   	pop    %ebp
  803bff:	c3                   	ret    
  803c00:	bd 20 00 00 00       	mov    $0x20,%ebp
  803c05:	89 eb                	mov    %ebp,%ebx
  803c07:	29 fb                	sub    %edi,%ebx
  803c09:	89 f9                	mov    %edi,%ecx
  803c0b:	d3 e6                	shl    %cl,%esi
  803c0d:	89 c5                	mov    %eax,%ebp
  803c0f:	88 d9                	mov    %bl,%cl
  803c11:	d3 ed                	shr    %cl,%ebp
  803c13:	89 e9                	mov    %ebp,%ecx
  803c15:	09 f1                	or     %esi,%ecx
  803c17:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803c1b:	89 f9                	mov    %edi,%ecx
  803c1d:	d3 e0                	shl    %cl,%eax
  803c1f:	89 c5                	mov    %eax,%ebp
  803c21:	89 d6                	mov    %edx,%esi
  803c23:	88 d9                	mov    %bl,%cl
  803c25:	d3 ee                	shr    %cl,%esi
  803c27:	89 f9                	mov    %edi,%ecx
  803c29:	d3 e2                	shl    %cl,%edx
  803c2b:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c2f:	88 d9                	mov    %bl,%cl
  803c31:	d3 e8                	shr    %cl,%eax
  803c33:	09 c2                	or     %eax,%edx
  803c35:	89 d0                	mov    %edx,%eax
  803c37:	89 f2                	mov    %esi,%edx
  803c39:	f7 74 24 0c          	divl   0xc(%esp)
  803c3d:	89 d6                	mov    %edx,%esi
  803c3f:	89 c3                	mov    %eax,%ebx
  803c41:	f7 e5                	mul    %ebp
  803c43:	39 d6                	cmp    %edx,%esi
  803c45:	72 19                	jb     803c60 <__udivdi3+0xfc>
  803c47:	74 0b                	je     803c54 <__udivdi3+0xf0>
  803c49:	89 d8                	mov    %ebx,%eax
  803c4b:	31 ff                	xor    %edi,%edi
  803c4d:	e9 58 ff ff ff       	jmp    803baa <__udivdi3+0x46>
  803c52:	66 90                	xchg   %ax,%ax
  803c54:	8b 54 24 08          	mov    0x8(%esp),%edx
  803c58:	89 f9                	mov    %edi,%ecx
  803c5a:	d3 e2                	shl    %cl,%edx
  803c5c:	39 c2                	cmp    %eax,%edx
  803c5e:	73 e9                	jae    803c49 <__udivdi3+0xe5>
  803c60:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803c63:	31 ff                	xor    %edi,%edi
  803c65:	e9 40 ff ff ff       	jmp    803baa <__udivdi3+0x46>
  803c6a:	66 90                	xchg   %ax,%ax
  803c6c:	31 c0                	xor    %eax,%eax
  803c6e:	e9 37 ff ff ff       	jmp    803baa <__udivdi3+0x46>
  803c73:	90                   	nop

00803c74 <__umoddi3>:
  803c74:	55                   	push   %ebp
  803c75:	57                   	push   %edi
  803c76:	56                   	push   %esi
  803c77:	53                   	push   %ebx
  803c78:	83 ec 1c             	sub    $0x1c,%esp
  803c7b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803c7f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803c83:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c87:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c8b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c8f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c93:	89 f3                	mov    %esi,%ebx
  803c95:	89 fa                	mov    %edi,%edx
  803c97:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c9b:	89 34 24             	mov    %esi,(%esp)
  803c9e:	85 c0                	test   %eax,%eax
  803ca0:	75 1a                	jne    803cbc <__umoddi3+0x48>
  803ca2:	39 f7                	cmp    %esi,%edi
  803ca4:	0f 86 a2 00 00 00    	jbe    803d4c <__umoddi3+0xd8>
  803caa:	89 c8                	mov    %ecx,%eax
  803cac:	89 f2                	mov    %esi,%edx
  803cae:	f7 f7                	div    %edi
  803cb0:	89 d0                	mov    %edx,%eax
  803cb2:	31 d2                	xor    %edx,%edx
  803cb4:	83 c4 1c             	add    $0x1c,%esp
  803cb7:	5b                   	pop    %ebx
  803cb8:	5e                   	pop    %esi
  803cb9:	5f                   	pop    %edi
  803cba:	5d                   	pop    %ebp
  803cbb:	c3                   	ret    
  803cbc:	39 f0                	cmp    %esi,%eax
  803cbe:	0f 87 ac 00 00 00    	ja     803d70 <__umoddi3+0xfc>
  803cc4:	0f bd e8             	bsr    %eax,%ebp
  803cc7:	83 f5 1f             	xor    $0x1f,%ebp
  803cca:	0f 84 ac 00 00 00    	je     803d7c <__umoddi3+0x108>
  803cd0:	bf 20 00 00 00       	mov    $0x20,%edi
  803cd5:	29 ef                	sub    %ebp,%edi
  803cd7:	89 fe                	mov    %edi,%esi
  803cd9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803cdd:	89 e9                	mov    %ebp,%ecx
  803cdf:	d3 e0                	shl    %cl,%eax
  803ce1:	89 d7                	mov    %edx,%edi
  803ce3:	89 f1                	mov    %esi,%ecx
  803ce5:	d3 ef                	shr    %cl,%edi
  803ce7:	09 c7                	or     %eax,%edi
  803ce9:	89 e9                	mov    %ebp,%ecx
  803ceb:	d3 e2                	shl    %cl,%edx
  803ced:	89 14 24             	mov    %edx,(%esp)
  803cf0:	89 d8                	mov    %ebx,%eax
  803cf2:	d3 e0                	shl    %cl,%eax
  803cf4:	89 c2                	mov    %eax,%edx
  803cf6:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cfa:	d3 e0                	shl    %cl,%eax
  803cfc:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d00:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d04:	89 f1                	mov    %esi,%ecx
  803d06:	d3 e8                	shr    %cl,%eax
  803d08:	09 d0                	or     %edx,%eax
  803d0a:	d3 eb                	shr    %cl,%ebx
  803d0c:	89 da                	mov    %ebx,%edx
  803d0e:	f7 f7                	div    %edi
  803d10:	89 d3                	mov    %edx,%ebx
  803d12:	f7 24 24             	mull   (%esp)
  803d15:	89 c6                	mov    %eax,%esi
  803d17:	89 d1                	mov    %edx,%ecx
  803d19:	39 d3                	cmp    %edx,%ebx
  803d1b:	0f 82 87 00 00 00    	jb     803da8 <__umoddi3+0x134>
  803d21:	0f 84 91 00 00 00    	je     803db8 <__umoddi3+0x144>
  803d27:	8b 54 24 04          	mov    0x4(%esp),%edx
  803d2b:	29 f2                	sub    %esi,%edx
  803d2d:	19 cb                	sbb    %ecx,%ebx
  803d2f:	89 d8                	mov    %ebx,%eax
  803d31:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803d35:	d3 e0                	shl    %cl,%eax
  803d37:	89 e9                	mov    %ebp,%ecx
  803d39:	d3 ea                	shr    %cl,%edx
  803d3b:	09 d0                	or     %edx,%eax
  803d3d:	89 e9                	mov    %ebp,%ecx
  803d3f:	d3 eb                	shr    %cl,%ebx
  803d41:	89 da                	mov    %ebx,%edx
  803d43:	83 c4 1c             	add    $0x1c,%esp
  803d46:	5b                   	pop    %ebx
  803d47:	5e                   	pop    %esi
  803d48:	5f                   	pop    %edi
  803d49:	5d                   	pop    %ebp
  803d4a:	c3                   	ret    
  803d4b:	90                   	nop
  803d4c:	89 fd                	mov    %edi,%ebp
  803d4e:	85 ff                	test   %edi,%edi
  803d50:	75 0b                	jne    803d5d <__umoddi3+0xe9>
  803d52:	b8 01 00 00 00       	mov    $0x1,%eax
  803d57:	31 d2                	xor    %edx,%edx
  803d59:	f7 f7                	div    %edi
  803d5b:	89 c5                	mov    %eax,%ebp
  803d5d:	89 f0                	mov    %esi,%eax
  803d5f:	31 d2                	xor    %edx,%edx
  803d61:	f7 f5                	div    %ebp
  803d63:	89 c8                	mov    %ecx,%eax
  803d65:	f7 f5                	div    %ebp
  803d67:	89 d0                	mov    %edx,%eax
  803d69:	e9 44 ff ff ff       	jmp    803cb2 <__umoddi3+0x3e>
  803d6e:	66 90                	xchg   %ax,%ax
  803d70:	89 c8                	mov    %ecx,%eax
  803d72:	89 f2                	mov    %esi,%edx
  803d74:	83 c4 1c             	add    $0x1c,%esp
  803d77:	5b                   	pop    %ebx
  803d78:	5e                   	pop    %esi
  803d79:	5f                   	pop    %edi
  803d7a:	5d                   	pop    %ebp
  803d7b:	c3                   	ret    
  803d7c:	3b 04 24             	cmp    (%esp),%eax
  803d7f:	72 06                	jb     803d87 <__umoddi3+0x113>
  803d81:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803d85:	77 0f                	ja     803d96 <__umoddi3+0x122>
  803d87:	89 f2                	mov    %esi,%edx
  803d89:	29 f9                	sub    %edi,%ecx
  803d8b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d8f:	89 14 24             	mov    %edx,(%esp)
  803d92:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d96:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d9a:	8b 14 24             	mov    (%esp),%edx
  803d9d:	83 c4 1c             	add    $0x1c,%esp
  803da0:	5b                   	pop    %ebx
  803da1:	5e                   	pop    %esi
  803da2:	5f                   	pop    %edi
  803da3:	5d                   	pop    %ebp
  803da4:	c3                   	ret    
  803da5:	8d 76 00             	lea    0x0(%esi),%esi
  803da8:	2b 04 24             	sub    (%esp),%eax
  803dab:	19 fa                	sbb    %edi,%edx
  803dad:	89 d1                	mov    %edx,%ecx
  803daf:	89 c6                	mov    %eax,%esi
  803db1:	e9 71 ff ff ff       	jmp    803d27 <__umoddi3+0xb3>
  803db6:	66 90                	xchg   %ax,%ax
  803db8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803dbc:	72 ea                	jb     803da8 <__umoddi3+0x134>
  803dbe:	89 d9                	mov    %ebx,%ecx
  803dc0:	e9 62 ff ff ff       	jmp    803d27 <__umoddi3+0xb3>
