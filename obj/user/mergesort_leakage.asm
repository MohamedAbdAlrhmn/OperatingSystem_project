
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
  800041:	e8 95 20 00 00       	call   8020db <sys_disable_interrupt>

		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 20 3e 80 00       	push   $0x803e20
  80004e:	e8 38 0b 00 00       	call   800b8b <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 22 3e 80 00       	push   $0x803e22
  80005e:	e8 28 0b 00 00       	call   800b8b <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 38 3e 80 00       	push   $0x803e38
  80006e:	e8 18 0b 00 00       	call   800b8b <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 22 3e 80 00       	push   $0x803e22
  80007e:	e8 08 0b 00 00       	call   800b8b <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 20 3e 80 00       	push   $0x803e20
  80008e:	e8 f8 0a 00 00       	call   800b8b <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 50 3e 80 00       	push   $0x803e50
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
  8000de:	68 70 3e 80 00       	push   $0x803e70
  8000e3:	e8 a3 0a 00 00       	call   800b8b <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 92 3e 80 00       	push   $0x803e92
  8000f3:	e8 93 0a 00 00       	call   800b8b <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 a0 3e 80 00       	push   $0x803ea0
  800103:	e8 83 0a 00 00       	call   800b8b <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 af 3e 80 00       	push   $0x803eaf
  800113:	e8 73 0a 00 00       	call   800b8b <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 bf 3e 80 00       	push   $0x803ebf
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
  800162:	e8 8e 1f 00 00       	call   8020f5 <sys_enable_interrupt>

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
  8001d7:	e8 ff 1e 00 00       	call   8020db <sys_disable_interrupt>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	68 c8 3e 80 00       	push   $0x803ec8
  8001e4:	e8 a2 09 00 00       	call   800b8b <cprintf>
  8001e9:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001ec:	e8 04 1f 00 00       	call   8020f5 <sys_enable_interrupt>

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
  80020e:	68 fc 3e 80 00       	push   $0x803efc
  800213:	6a 4a                	push   $0x4a
  800215:	68 1e 3f 80 00       	push   $0x803f1e
  80021a:	e8 b8 06 00 00       	call   8008d7 <_panic>
		else
		{
			sys_disable_interrupt();
  80021f:	e8 b7 1e 00 00       	call   8020db <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	68 38 3f 80 00       	push   $0x803f38
  80022c:	e8 5a 09 00 00       	call   800b8b <cprintf>
  800231:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	68 6c 3f 80 00       	push   $0x803f6c
  80023c:	e8 4a 09 00 00       	call   800b8b <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 a0 3f 80 00       	push   $0x803fa0
  80024c:	e8 3a 09 00 00       	call   800b8b <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800254:	e8 9c 1e 00 00       	call   8020f5 <sys_enable_interrupt>
		}

		//free(Elements) ;

		sys_disable_interrupt();
  800259:	e8 7d 1e 00 00       	call   8020db <sys_disable_interrupt>
			Chose = 0 ;
  80025e:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800262:	eb 42                	jmp    8002a6 <_main+0x26e>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800264:	83 ec 0c             	sub    $0xc,%esp
  800267:	68 d2 3f 80 00       	push   $0x803fd2
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
  8002b2:	e8 3e 1e 00 00       	call   8020f5 <sys_enable_interrupt>

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
  800446:	68 20 3e 80 00       	push   $0x803e20
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
  800468:	68 f0 3f 80 00       	push   $0x803ff0
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
  800496:	68 f5 3f 80 00       	push   $0x803ff5
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
  80070f:	e8 fb 19 00 00       	call   80210f <sys_cputc>
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
  800720:	e8 b6 19 00 00       	call   8020db <sys_disable_interrupt>
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
  800733:	e8 d7 19 00 00       	call   80210f <sys_cputc>
  800738:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80073b:	e8 b5 19 00 00       	call   8020f5 <sys_enable_interrupt>
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
  800752:	e8 ff 17 00 00       	call   801f56 <sys_cgetc>
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
  80076b:	e8 6b 19 00 00       	call   8020db <sys_disable_interrupt>
	int c=0;
  800770:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800777:	eb 08                	jmp    800781 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800779:	e8 d8 17 00 00       	call   801f56 <sys_cgetc>
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
  800787:	e8 69 19 00 00       	call   8020f5 <sys_enable_interrupt>
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
  8007a1:	e8 28 1b 00 00       	call   8022ce <sys_getenvindex>
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
  80080c:	e8 ca 18 00 00       	call   8020db <sys_disable_interrupt>
	cprintf("**************************************\n");
  800811:	83 ec 0c             	sub    $0xc,%esp
  800814:	68 14 40 80 00       	push   $0x804014
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
  80083c:	68 3c 40 80 00       	push   $0x80403c
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
  80086d:	68 64 40 80 00       	push   $0x804064
  800872:	e8 14 03 00 00       	call   800b8b <cprintf>
  800877:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80087a:	a1 24 50 80 00       	mov    0x805024,%eax
  80087f:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800885:	83 ec 08             	sub    $0x8,%esp
  800888:	50                   	push   %eax
  800889:	68 bc 40 80 00       	push   $0x8040bc
  80088e:	e8 f8 02 00 00       	call   800b8b <cprintf>
  800893:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800896:	83 ec 0c             	sub    $0xc,%esp
  800899:	68 14 40 80 00       	push   $0x804014
  80089e:	e8 e8 02 00 00       	call   800b8b <cprintf>
  8008a3:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8008a6:	e8 4a 18 00 00       	call   8020f5 <sys_enable_interrupt>

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
  8008be:	e8 d7 19 00 00       	call   80229a <sys_destroy_env>
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
  8008cf:	e8 2c 1a 00 00       	call   802300 <sys_exit_env>
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
  8008f8:	68 d0 40 80 00       	push   $0x8040d0
  8008fd:	e8 89 02 00 00       	call   800b8b <cprintf>
  800902:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800905:	a1 00 50 80 00       	mov    0x805000,%eax
  80090a:	ff 75 0c             	pushl  0xc(%ebp)
  80090d:	ff 75 08             	pushl  0x8(%ebp)
  800910:	50                   	push   %eax
  800911:	68 d5 40 80 00       	push   $0x8040d5
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
  800935:	68 f1 40 80 00       	push   $0x8040f1
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
  800961:	68 f4 40 80 00       	push   $0x8040f4
  800966:	6a 26                	push   $0x26
  800968:	68 40 41 80 00       	push   $0x804140
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
  800a33:	68 4c 41 80 00       	push   $0x80414c
  800a38:	6a 3a                	push   $0x3a
  800a3a:	68 40 41 80 00       	push   $0x804140
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
  800aa3:	68 a0 41 80 00       	push   $0x8041a0
  800aa8:	6a 44                	push   $0x44
  800aaa:	68 40 41 80 00       	push   $0x804140
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
  800afd:	e8 2b 14 00 00       	call   801f2d <sys_cputs>
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
  800b74:	e8 b4 13 00 00       	call   801f2d <sys_cputs>
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
  800bbe:	e8 18 15 00 00       	call   8020db <sys_disable_interrupt>
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
  800bde:	e8 12 15 00 00       	call   8020f5 <sys_enable_interrupt>
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
  800c28:	e8 83 2f 00 00       	call   803bb0 <__udivdi3>
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
  800c78:	e8 43 30 00 00       	call   803cc0 <__umoddi3>
  800c7d:	83 c4 10             	add    $0x10,%esp
  800c80:	05 14 44 80 00       	add    $0x804414,%eax
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
  800dd3:	8b 04 85 38 44 80 00 	mov    0x804438(,%eax,4),%eax
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
  800eb4:	8b 34 9d 80 42 80 00 	mov    0x804280(,%ebx,4),%esi
  800ebb:	85 f6                	test   %esi,%esi
  800ebd:	75 19                	jne    800ed8 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ebf:	53                   	push   %ebx
  800ec0:	68 25 44 80 00       	push   $0x804425
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
  800ed9:	68 2e 44 80 00       	push   $0x80442e
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
  800f06:	be 31 44 80 00       	mov    $0x804431,%esi
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
  80121f:	68 90 45 80 00       	push   $0x804590
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
  801261:	68 93 45 80 00       	push   $0x804593
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
  801311:	e8 c5 0d 00 00       	call   8020db <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  801316:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80131a:	74 13                	je     80132f <atomic_readline+0x24>
		cprintf("%s", prompt);
  80131c:	83 ec 08             	sub    $0x8,%esp
  80131f:	ff 75 08             	pushl  0x8(%ebp)
  801322:	68 90 45 80 00       	push   $0x804590
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
  801360:	68 93 45 80 00       	push   $0x804593
  801365:	e8 21 f8 ff ff       	call   800b8b <cprintf>
  80136a:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  80136d:	e8 83 0d 00 00       	call   8020f5 <sys_enable_interrupt>
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
  801405:	e8 eb 0c 00 00       	call   8020f5 <sys_enable_interrupt>
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
  801b32:	68 a4 45 80 00       	push   $0x8045a4
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
  801c02:	e8 6a 04 00 00       	call   802071 <sys_allocate_chunk>
  801c07:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801c0a:	a1 20 51 80 00       	mov    0x805120,%eax
  801c0f:	83 ec 0c             	sub    $0xc,%esp
  801c12:	50                   	push   %eax
  801c13:	e8 df 0a 00 00       	call   8026f7 <initialize_MemBlocksList>
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
  801c40:	68 c9 45 80 00       	push   $0x8045c9
  801c45:	6a 33                	push   $0x33
  801c47:	68 e7 45 80 00       	push   $0x8045e7
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
  801cbf:	68 f4 45 80 00       	push   $0x8045f4
  801cc4:	6a 34                	push   $0x34
  801cc6:	68 e7 45 80 00       	push   $0x8045e7
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
  801d57:	e8 e3 06 00 00       	call   80243f <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d5c:	85 c0                	test   %eax,%eax
  801d5e:	74 11                	je     801d71 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801d60:	83 ec 0c             	sub    $0xc,%esp
  801d63:	ff 75 e8             	pushl  -0x18(%ebp)
  801d66:	e8 4e 0d 00 00       	call   802ab9 <alloc_block_FF>
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
  801d7d:	e8 aa 0a 00 00       	call   80282c <insert_sorted_allocList>
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
  801d97:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801d9a:	83 ec 04             	sub    $0x4,%esp
  801d9d:	68 18 46 80 00       	push   $0x804618
  801da2:	6a 6f                	push   $0x6f
  801da4:	68 e7 45 80 00       	push   $0x8045e7
  801da9:	e8 29 eb ff ff       	call   8008d7 <_panic>

00801dae <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801dae:	55                   	push   %ebp
  801daf:	89 e5                	mov    %esp,%ebp
  801db1:	83 ec 38             	sub    $0x38,%esp
  801db4:	8b 45 10             	mov    0x10(%ebp),%eax
  801db7:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801dba:	e8 5c fd ff ff       	call   801b1b <InitializeUHeap>
	if (size == 0) return NULL ;
  801dbf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801dc3:	75 07                	jne    801dcc <smalloc+0x1e>
  801dc5:	b8 00 00 00 00       	mov    $0x0,%eax
  801dca:	eb 7c                	jmp    801e48 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801dcc:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801dd3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dd9:	01 d0                	add    %edx,%eax
  801ddb:	48                   	dec    %eax
  801ddc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ddf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801de2:	ba 00 00 00 00       	mov    $0x0,%edx
  801de7:	f7 75 f0             	divl   -0x10(%ebp)
  801dea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ded:	29 d0                	sub    %edx,%eax
  801def:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801df2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801df9:	e8 41 06 00 00       	call   80243f <sys_isUHeapPlacementStrategyFIRSTFIT>
  801dfe:	85 c0                	test   %eax,%eax
  801e00:	74 11                	je     801e13 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  801e02:	83 ec 0c             	sub    $0xc,%esp
  801e05:	ff 75 e8             	pushl  -0x18(%ebp)
  801e08:	e8 ac 0c 00 00       	call   802ab9 <alloc_block_FF>
  801e0d:	83 c4 10             	add    $0x10,%esp
  801e10:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801e13:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e17:	74 2a                	je     801e43 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801e19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e1c:	8b 40 08             	mov    0x8(%eax),%eax
  801e1f:	89 c2                	mov    %eax,%edx
  801e21:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801e25:	52                   	push   %edx
  801e26:	50                   	push   %eax
  801e27:	ff 75 0c             	pushl  0xc(%ebp)
  801e2a:	ff 75 08             	pushl  0x8(%ebp)
  801e2d:	e8 92 03 00 00       	call   8021c4 <sys_createSharedObject>
  801e32:	83 c4 10             	add    $0x10,%esp
  801e35:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  801e38:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  801e3c:	74 05                	je     801e43 <smalloc+0x95>
			return (void*)virtual_address;
  801e3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e41:	eb 05                	jmp    801e48 <smalloc+0x9a>
	}
	return NULL;
  801e43:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801e48:	c9                   	leave  
  801e49:	c3                   	ret    

00801e4a <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801e4a:	55                   	push   %ebp
  801e4b:	89 e5                	mov    %esp,%ebp
  801e4d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e50:	e8 c6 fc ff ff       	call   801b1b <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801e55:	83 ec 04             	sub    $0x4,%esp
  801e58:	68 3c 46 80 00       	push   $0x80463c
  801e5d:	68 b0 00 00 00       	push   $0xb0
  801e62:	68 e7 45 80 00       	push   $0x8045e7
  801e67:	e8 6b ea ff ff       	call   8008d7 <_panic>

00801e6c <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801e6c:	55                   	push   %ebp
  801e6d:	89 e5                	mov    %esp,%ebp
  801e6f:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e72:	e8 a4 fc ff ff       	call   801b1b <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801e77:	83 ec 04             	sub    $0x4,%esp
  801e7a:	68 60 46 80 00       	push   $0x804660
  801e7f:	68 f4 00 00 00       	push   $0xf4
  801e84:	68 e7 45 80 00       	push   $0x8045e7
  801e89:	e8 49 ea ff ff       	call   8008d7 <_panic>

00801e8e <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801e8e:	55                   	push   %ebp
  801e8f:	89 e5                	mov    %esp,%ebp
  801e91:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801e94:	83 ec 04             	sub    $0x4,%esp
  801e97:	68 88 46 80 00       	push   $0x804688
  801e9c:	68 08 01 00 00       	push   $0x108
  801ea1:	68 e7 45 80 00       	push   $0x8045e7
  801ea6:	e8 2c ea ff ff       	call   8008d7 <_panic>

00801eab <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801eab:	55                   	push   %ebp
  801eac:	89 e5                	mov    %esp,%ebp
  801eae:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801eb1:	83 ec 04             	sub    $0x4,%esp
  801eb4:	68 ac 46 80 00       	push   $0x8046ac
  801eb9:	68 13 01 00 00       	push   $0x113
  801ebe:	68 e7 45 80 00       	push   $0x8045e7
  801ec3:	e8 0f ea ff ff       	call   8008d7 <_panic>

00801ec8 <shrink>:

}
void shrink(uint32 newSize)
{
  801ec8:	55                   	push   %ebp
  801ec9:	89 e5                	mov    %esp,%ebp
  801ecb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ece:	83 ec 04             	sub    $0x4,%esp
  801ed1:	68 ac 46 80 00       	push   $0x8046ac
  801ed6:	68 18 01 00 00       	push   $0x118
  801edb:	68 e7 45 80 00       	push   $0x8045e7
  801ee0:	e8 f2 e9 ff ff       	call   8008d7 <_panic>

00801ee5 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801ee5:	55                   	push   %ebp
  801ee6:	89 e5                	mov    %esp,%ebp
  801ee8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801eeb:	83 ec 04             	sub    $0x4,%esp
  801eee:	68 ac 46 80 00       	push   $0x8046ac
  801ef3:	68 1d 01 00 00       	push   $0x11d
  801ef8:	68 e7 45 80 00       	push   $0x8045e7
  801efd:	e8 d5 e9 ff ff       	call   8008d7 <_panic>

00801f02 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801f02:	55                   	push   %ebp
  801f03:	89 e5                	mov    %esp,%ebp
  801f05:	57                   	push   %edi
  801f06:	56                   	push   %esi
  801f07:	53                   	push   %ebx
  801f08:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f11:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f14:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f17:	8b 7d 18             	mov    0x18(%ebp),%edi
  801f1a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801f1d:	cd 30                	int    $0x30
  801f1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801f22:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f25:	83 c4 10             	add    $0x10,%esp
  801f28:	5b                   	pop    %ebx
  801f29:	5e                   	pop    %esi
  801f2a:	5f                   	pop    %edi
  801f2b:	5d                   	pop    %ebp
  801f2c:	c3                   	ret    

00801f2d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801f2d:	55                   	push   %ebp
  801f2e:	89 e5                	mov    %esp,%ebp
  801f30:	83 ec 04             	sub    $0x4,%esp
  801f33:	8b 45 10             	mov    0x10(%ebp),%eax
  801f36:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801f39:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f40:	6a 00                	push   $0x0
  801f42:	6a 00                	push   $0x0
  801f44:	52                   	push   %edx
  801f45:	ff 75 0c             	pushl  0xc(%ebp)
  801f48:	50                   	push   %eax
  801f49:	6a 00                	push   $0x0
  801f4b:	e8 b2 ff ff ff       	call   801f02 <syscall>
  801f50:	83 c4 18             	add    $0x18,%esp
}
  801f53:	90                   	nop
  801f54:	c9                   	leave  
  801f55:	c3                   	ret    

00801f56 <sys_cgetc>:

int
sys_cgetc(void)
{
  801f56:	55                   	push   %ebp
  801f57:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801f59:	6a 00                	push   $0x0
  801f5b:	6a 00                	push   $0x0
  801f5d:	6a 00                	push   $0x0
  801f5f:	6a 00                	push   $0x0
  801f61:	6a 00                	push   $0x0
  801f63:	6a 01                	push   $0x1
  801f65:	e8 98 ff ff ff       	call   801f02 <syscall>
  801f6a:	83 c4 18             	add    $0x18,%esp
}
  801f6d:	c9                   	leave  
  801f6e:	c3                   	ret    

00801f6f <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801f6f:	55                   	push   %ebp
  801f70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801f72:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f75:	8b 45 08             	mov    0x8(%ebp),%eax
  801f78:	6a 00                	push   $0x0
  801f7a:	6a 00                	push   $0x0
  801f7c:	6a 00                	push   $0x0
  801f7e:	52                   	push   %edx
  801f7f:	50                   	push   %eax
  801f80:	6a 05                	push   $0x5
  801f82:	e8 7b ff ff ff       	call   801f02 <syscall>
  801f87:	83 c4 18             	add    $0x18,%esp
}
  801f8a:	c9                   	leave  
  801f8b:	c3                   	ret    

00801f8c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801f8c:	55                   	push   %ebp
  801f8d:	89 e5                	mov    %esp,%ebp
  801f8f:	56                   	push   %esi
  801f90:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801f91:	8b 75 18             	mov    0x18(%ebp),%esi
  801f94:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f97:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa0:	56                   	push   %esi
  801fa1:	53                   	push   %ebx
  801fa2:	51                   	push   %ecx
  801fa3:	52                   	push   %edx
  801fa4:	50                   	push   %eax
  801fa5:	6a 06                	push   $0x6
  801fa7:	e8 56 ff ff ff       	call   801f02 <syscall>
  801fac:	83 c4 18             	add    $0x18,%esp
}
  801faf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fb2:	5b                   	pop    %ebx
  801fb3:	5e                   	pop    %esi
  801fb4:	5d                   	pop    %ebp
  801fb5:	c3                   	ret    

00801fb6 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801fb6:	55                   	push   %ebp
  801fb7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801fb9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbf:	6a 00                	push   $0x0
  801fc1:	6a 00                	push   $0x0
  801fc3:	6a 00                	push   $0x0
  801fc5:	52                   	push   %edx
  801fc6:	50                   	push   %eax
  801fc7:	6a 07                	push   $0x7
  801fc9:	e8 34 ff ff ff       	call   801f02 <syscall>
  801fce:	83 c4 18             	add    $0x18,%esp
}
  801fd1:	c9                   	leave  
  801fd2:	c3                   	ret    

00801fd3 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801fd3:	55                   	push   %ebp
  801fd4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801fd6:	6a 00                	push   $0x0
  801fd8:	6a 00                	push   $0x0
  801fda:	6a 00                	push   $0x0
  801fdc:	ff 75 0c             	pushl  0xc(%ebp)
  801fdf:	ff 75 08             	pushl  0x8(%ebp)
  801fe2:	6a 08                	push   $0x8
  801fe4:	e8 19 ff ff ff       	call   801f02 <syscall>
  801fe9:	83 c4 18             	add    $0x18,%esp
}
  801fec:	c9                   	leave  
  801fed:	c3                   	ret    

00801fee <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801fee:	55                   	push   %ebp
  801fef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801ff1:	6a 00                	push   $0x0
  801ff3:	6a 00                	push   $0x0
  801ff5:	6a 00                	push   $0x0
  801ff7:	6a 00                	push   $0x0
  801ff9:	6a 00                	push   $0x0
  801ffb:	6a 09                	push   $0x9
  801ffd:	e8 00 ff ff ff       	call   801f02 <syscall>
  802002:	83 c4 18             	add    $0x18,%esp
}
  802005:	c9                   	leave  
  802006:	c3                   	ret    

00802007 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802007:	55                   	push   %ebp
  802008:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80200a:	6a 00                	push   $0x0
  80200c:	6a 00                	push   $0x0
  80200e:	6a 00                	push   $0x0
  802010:	6a 00                	push   $0x0
  802012:	6a 00                	push   $0x0
  802014:	6a 0a                	push   $0xa
  802016:	e8 e7 fe ff ff       	call   801f02 <syscall>
  80201b:	83 c4 18             	add    $0x18,%esp
}
  80201e:	c9                   	leave  
  80201f:	c3                   	ret    

00802020 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802020:	55                   	push   %ebp
  802021:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802023:	6a 00                	push   $0x0
  802025:	6a 00                	push   $0x0
  802027:	6a 00                	push   $0x0
  802029:	6a 00                	push   $0x0
  80202b:	6a 00                	push   $0x0
  80202d:	6a 0b                	push   $0xb
  80202f:	e8 ce fe ff ff       	call   801f02 <syscall>
  802034:	83 c4 18             	add    $0x18,%esp
}
  802037:	c9                   	leave  
  802038:	c3                   	ret    

00802039 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802039:	55                   	push   %ebp
  80203a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80203c:	6a 00                	push   $0x0
  80203e:	6a 00                	push   $0x0
  802040:	6a 00                	push   $0x0
  802042:	ff 75 0c             	pushl  0xc(%ebp)
  802045:	ff 75 08             	pushl  0x8(%ebp)
  802048:	6a 0f                	push   $0xf
  80204a:	e8 b3 fe ff ff       	call   801f02 <syscall>
  80204f:	83 c4 18             	add    $0x18,%esp
	return;
  802052:	90                   	nop
}
  802053:	c9                   	leave  
  802054:	c3                   	ret    

00802055 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802055:	55                   	push   %ebp
  802056:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802058:	6a 00                	push   $0x0
  80205a:	6a 00                	push   $0x0
  80205c:	6a 00                	push   $0x0
  80205e:	ff 75 0c             	pushl  0xc(%ebp)
  802061:	ff 75 08             	pushl  0x8(%ebp)
  802064:	6a 10                	push   $0x10
  802066:	e8 97 fe ff ff       	call   801f02 <syscall>
  80206b:	83 c4 18             	add    $0x18,%esp
	return ;
  80206e:	90                   	nop
}
  80206f:	c9                   	leave  
  802070:	c3                   	ret    

00802071 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802071:	55                   	push   %ebp
  802072:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802074:	6a 00                	push   $0x0
  802076:	6a 00                	push   $0x0
  802078:	ff 75 10             	pushl  0x10(%ebp)
  80207b:	ff 75 0c             	pushl  0xc(%ebp)
  80207e:	ff 75 08             	pushl  0x8(%ebp)
  802081:	6a 11                	push   $0x11
  802083:	e8 7a fe ff ff       	call   801f02 <syscall>
  802088:	83 c4 18             	add    $0x18,%esp
	return ;
  80208b:	90                   	nop
}
  80208c:	c9                   	leave  
  80208d:	c3                   	ret    

0080208e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80208e:	55                   	push   %ebp
  80208f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802091:	6a 00                	push   $0x0
  802093:	6a 00                	push   $0x0
  802095:	6a 00                	push   $0x0
  802097:	6a 00                	push   $0x0
  802099:	6a 00                	push   $0x0
  80209b:	6a 0c                	push   $0xc
  80209d:	e8 60 fe ff ff       	call   801f02 <syscall>
  8020a2:	83 c4 18             	add    $0x18,%esp
}
  8020a5:	c9                   	leave  
  8020a6:	c3                   	ret    

008020a7 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8020a7:	55                   	push   %ebp
  8020a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8020aa:	6a 00                	push   $0x0
  8020ac:	6a 00                	push   $0x0
  8020ae:	6a 00                	push   $0x0
  8020b0:	6a 00                	push   $0x0
  8020b2:	ff 75 08             	pushl  0x8(%ebp)
  8020b5:	6a 0d                	push   $0xd
  8020b7:	e8 46 fe ff ff       	call   801f02 <syscall>
  8020bc:	83 c4 18             	add    $0x18,%esp
}
  8020bf:	c9                   	leave  
  8020c0:	c3                   	ret    

008020c1 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8020c1:	55                   	push   %ebp
  8020c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8020c4:	6a 00                	push   $0x0
  8020c6:	6a 00                	push   $0x0
  8020c8:	6a 00                	push   $0x0
  8020ca:	6a 00                	push   $0x0
  8020cc:	6a 00                	push   $0x0
  8020ce:	6a 0e                	push   $0xe
  8020d0:	e8 2d fe ff ff       	call   801f02 <syscall>
  8020d5:	83 c4 18             	add    $0x18,%esp
}
  8020d8:	90                   	nop
  8020d9:	c9                   	leave  
  8020da:	c3                   	ret    

008020db <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8020db:	55                   	push   %ebp
  8020dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8020de:	6a 00                	push   $0x0
  8020e0:	6a 00                	push   $0x0
  8020e2:	6a 00                	push   $0x0
  8020e4:	6a 00                	push   $0x0
  8020e6:	6a 00                	push   $0x0
  8020e8:	6a 13                	push   $0x13
  8020ea:	e8 13 fe ff ff       	call   801f02 <syscall>
  8020ef:	83 c4 18             	add    $0x18,%esp
}
  8020f2:	90                   	nop
  8020f3:	c9                   	leave  
  8020f4:	c3                   	ret    

008020f5 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8020f5:	55                   	push   %ebp
  8020f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8020f8:	6a 00                	push   $0x0
  8020fa:	6a 00                	push   $0x0
  8020fc:	6a 00                	push   $0x0
  8020fe:	6a 00                	push   $0x0
  802100:	6a 00                	push   $0x0
  802102:	6a 14                	push   $0x14
  802104:	e8 f9 fd ff ff       	call   801f02 <syscall>
  802109:	83 c4 18             	add    $0x18,%esp
}
  80210c:	90                   	nop
  80210d:	c9                   	leave  
  80210e:	c3                   	ret    

0080210f <sys_cputc>:


void
sys_cputc(const char c)
{
  80210f:	55                   	push   %ebp
  802110:	89 e5                	mov    %esp,%ebp
  802112:	83 ec 04             	sub    $0x4,%esp
  802115:	8b 45 08             	mov    0x8(%ebp),%eax
  802118:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80211b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80211f:	6a 00                	push   $0x0
  802121:	6a 00                	push   $0x0
  802123:	6a 00                	push   $0x0
  802125:	6a 00                	push   $0x0
  802127:	50                   	push   %eax
  802128:	6a 15                	push   $0x15
  80212a:	e8 d3 fd ff ff       	call   801f02 <syscall>
  80212f:	83 c4 18             	add    $0x18,%esp
}
  802132:	90                   	nop
  802133:	c9                   	leave  
  802134:	c3                   	ret    

00802135 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802135:	55                   	push   %ebp
  802136:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802138:	6a 00                	push   $0x0
  80213a:	6a 00                	push   $0x0
  80213c:	6a 00                	push   $0x0
  80213e:	6a 00                	push   $0x0
  802140:	6a 00                	push   $0x0
  802142:	6a 16                	push   $0x16
  802144:	e8 b9 fd ff ff       	call   801f02 <syscall>
  802149:	83 c4 18             	add    $0x18,%esp
}
  80214c:	90                   	nop
  80214d:	c9                   	leave  
  80214e:	c3                   	ret    

0080214f <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80214f:	55                   	push   %ebp
  802150:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802152:	8b 45 08             	mov    0x8(%ebp),%eax
  802155:	6a 00                	push   $0x0
  802157:	6a 00                	push   $0x0
  802159:	6a 00                	push   $0x0
  80215b:	ff 75 0c             	pushl  0xc(%ebp)
  80215e:	50                   	push   %eax
  80215f:	6a 17                	push   $0x17
  802161:	e8 9c fd ff ff       	call   801f02 <syscall>
  802166:	83 c4 18             	add    $0x18,%esp
}
  802169:	c9                   	leave  
  80216a:	c3                   	ret    

0080216b <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80216b:	55                   	push   %ebp
  80216c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80216e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802171:	8b 45 08             	mov    0x8(%ebp),%eax
  802174:	6a 00                	push   $0x0
  802176:	6a 00                	push   $0x0
  802178:	6a 00                	push   $0x0
  80217a:	52                   	push   %edx
  80217b:	50                   	push   %eax
  80217c:	6a 1a                	push   $0x1a
  80217e:	e8 7f fd ff ff       	call   801f02 <syscall>
  802183:	83 c4 18             	add    $0x18,%esp
}
  802186:	c9                   	leave  
  802187:	c3                   	ret    

00802188 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802188:	55                   	push   %ebp
  802189:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80218b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80218e:	8b 45 08             	mov    0x8(%ebp),%eax
  802191:	6a 00                	push   $0x0
  802193:	6a 00                	push   $0x0
  802195:	6a 00                	push   $0x0
  802197:	52                   	push   %edx
  802198:	50                   	push   %eax
  802199:	6a 18                	push   $0x18
  80219b:	e8 62 fd ff ff       	call   801f02 <syscall>
  8021a0:	83 c4 18             	add    $0x18,%esp
}
  8021a3:	90                   	nop
  8021a4:	c9                   	leave  
  8021a5:	c3                   	ret    

008021a6 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8021a6:	55                   	push   %ebp
  8021a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8021a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8021af:	6a 00                	push   $0x0
  8021b1:	6a 00                	push   $0x0
  8021b3:	6a 00                	push   $0x0
  8021b5:	52                   	push   %edx
  8021b6:	50                   	push   %eax
  8021b7:	6a 19                	push   $0x19
  8021b9:	e8 44 fd ff ff       	call   801f02 <syscall>
  8021be:	83 c4 18             	add    $0x18,%esp
}
  8021c1:	90                   	nop
  8021c2:	c9                   	leave  
  8021c3:	c3                   	ret    

008021c4 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8021c4:	55                   	push   %ebp
  8021c5:	89 e5                	mov    %esp,%ebp
  8021c7:	83 ec 04             	sub    $0x4,%esp
  8021ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8021cd:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8021d0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8021d3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8021d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021da:	6a 00                	push   $0x0
  8021dc:	51                   	push   %ecx
  8021dd:	52                   	push   %edx
  8021de:	ff 75 0c             	pushl  0xc(%ebp)
  8021e1:	50                   	push   %eax
  8021e2:	6a 1b                	push   $0x1b
  8021e4:	e8 19 fd ff ff       	call   801f02 <syscall>
  8021e9:	83 c4 18             	add    $0x18,%esp
}
  8021ec:	c9                   	leave  
  8021ed:	c3                   	ret    

008021ee <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8021ee:	55                   	push   %ebp
  8021ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8021f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f7:	6a 00                	push   $0x0
  8021f9:	6a 00                	push   $0x0
  8021fb:	6a 00                	push   $0x0
  8021fd:	52                   	push   %edx
  8021fe:	50                   	push   %eax
  8021ff:	6a 1c                	push   $0x1c
  802201:	e8 fc fc ff ff       	call   801f02 <syscall>
  802206:	83 c4 18             	add    $0x18,%esp
}
  802209:	c9                   	leave  
  80220a:	c3                   	ret    

0080220b <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80220b:	55                   	push   %ebp
  80220c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80220e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802211:	8b 55 0c             	mov    0xc(%ebp),%edx
  802214:	8b 45 08             	mov    0x8(%ebp),%eax
  802217:	6a 00                	push   $0x0
  802219:	6a 00                	push   $0x0
  80221b:	51                   	push   %ecx
  80221c:	52                   	push   %edx
  80221d:	50                   	push   %eax
  80221e:	6a 1d                	push   $0x1d
  802220:	e8 dd fc ff ff       	call   801f02 <syscall>
  802225:	83 c4 18             	add    $0x18,%esp
}
  802228:	c9                   	leave  
  802229:	c3                   	ret    

0080222a <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80222a:	55                   	push   %ebp
  80222b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80222d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802230:	8b 45 08             	mov    0x8(%ebp),%eax
  802233:	6a 00                	push   $0x0
  802235:	6a 00                	push   $0x0
  802237:	6a 00                	push   $0x0
  802239:	52                   	push   %edx
  80223a:	50                   	push   %eax
  80223b:	6a 1e                	push   $0x1e
  80223d:	e8 c0 fc ff ff       	call   801f02 <syscall>
  802242:	83 c4 18             	add    $0x18,%esp
}
  802245:	c9                   	leave  
  802246:	c3                   	ret    

00802247 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802247:	55                   	push   %ebp
  802248:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80224a:	6a 00                	push   $0x0
  80224c:	6a 00                	push   $0x0
  80224e:	6a 00                	push   $0x0
  802250:	6a 00                	push   $0x0
  802252:	6a 00                	push   $0x0
  802254:	6a 1f                	push   $0x1f
  802256:	e8 a7 fc ff ff       	call   801f02 <syscall>
  80225b:	83 c4 18             	add    $0x18,%esp
}
  80225e:	c9                   	leave  
  80225f:	c3                   	ret    

00802260 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802260:	55                   	push   %ebp
  802261:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802263:	8b 45 08             	mov    0x8(%ebp),%eax
  802266:	6a 00                	push   $0x0
  802268:	ff 75 14             	pushl  0x14(%ebp)
  80226b:	ff 75 10             	pushl  0x10(%ebp)
  80226e:	ff 75 0c             	pushl  0xc(%ebp)
  802271:	50                   	push   %eax
  802272:	6a 20                	push   $0x20
  802274:	e8 89 fc ff ff       	call   801f02 <syscall>
  802279:	83 c4 18             	add    $0x18,%esp
}
  80227c:	c9                   	leave  
  80227d:	c3                   	ret    

0080227e <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80227e:	55                   	push   %ebp
  80227f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802281:	8b 45 08             	mov    0x8(%ebp),%eax
  802284:	6a 00                	push   $0x0
  802286:	6a 00                	push   $0x0
  802288:	6a 00                	push   $0x0
  80228a:	6a 00                	push   $0x0
  80228c:	50                   	push   %eax
  80228d:	6a 21                	push   $0x21
  80228f:	e8 6e fc ff ff       	call   801f02 <syscall>
  802294:	83 c4 18             	add    $0x18,%esp
}
  802297:	90                   	nop
  802298:	c9                   	leave  
  802299:	c3                   	ret    

0080229a <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80229a:	55                   	push   %ebp
  80229b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80229d:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a0:	6a 00                	push   $0x0
  8022a2:	6a 00                	push   $0x0
  8022a4:	6a 00                	push   $0x0
  8022a6:	6a 00                	push   $0x0
  8022a8:	50                   	push   %eax
  8022a9:	6a 22                	push   $0x22
  8022ab:	e8 52 fc ff ff       	call   801f02 <syscall>
  8022b0:	83 c4 18             	add    $0x18,%esp
}
  8022b3:	c9                   	leave  
  8022b4:	c3                   	ret    

008022b5 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8022b5:	55                   	push   %ebp
  8022b6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8022b8:	6a 00                	push   $0x0
  8022ba:	6a 00                	push   $0x0
  8022bc:	6a 00                	push   $0x0
  8022be:	6a 00                	push   $0x0
  8022c0:	6a 00                	push   $0x0
  8022c2:	6a 02                	push   $0x2
  8022c4:	e8 39 fc ff ff       	call   801f02 <syscall>
  8022c9:	83 c4 18             	add    $0x18,%esp
}
  8022cc:	c9                   	leave  
  8022cd:	c3                   	ret    

008022ce <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8022ce:	55                   	push   %ebp
  8022cf:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8022d1:	6a 00                	push   $0x0
  8022d3:	6a 00                	push   $0x0
  8022d5:	6a 00                	push   $0x0
  8022d7:	6a 00                	push   $0x0
  8022d9:	6a 00                	push   $0x0
  8022db:	6a 03                	push   $0x3
  8022dd:	e8 20 fc ff ff       	call   801f02 <syscall>
  8022e2:	83 c4 18             	add    $0x18,%esp
}
  8022e5:	c9                   	leave  
  8022e6:	c3                   	ret    

008022e7 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8022e7:	55                   	push   %ebp
  8022e8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8022ea:	6a 00                	push   $0x0
  8022ec:	6a 00                	push   $0x0
  8022ee:	6a 00                	push   $0x0
  8022f0:	6a 00                	push   $0x0
  8022f2:	6a 00                	push   $0x0
  8022f4:	6a 04                	push   $0x4
  8022f6:	e8 07 fc ff ff       	call   801f02 <syscall>
  8022fb:	83 c4 18             	add    $0x18,%esp
}
  8022fe:	c9                   	leave  
  8022ff:	c3                   	ret    

00802300 <sys_exit_env>:


void sys_exit_env(void)
{
  802300:	55                   	push   %ebp
  802301:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802303:	6a 00                	push   $0x0
  802305:	6a 00                	push   $0x0
  802307:	6a 00                	push   $0x0
  802309:	6a 00                	push   $0x0
  80230b:	6a 00                	push   $0x0
  80230d:	6a 23                	push   $0x23
  80230f:	e8 ee fb ff ff       	call   801f02 <syscall>
  802314:	83 c4 18             	add    $0x18,%esp
}
  802317:	90                   	nop
  802318:	c9                   	leave  
  802319:	c3                   	ret    

0080231a <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80231a:	55                   	push   %ebp
  80231b:	89 e5                	mov    %esp,%ebp
  80231d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802320:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802323:	8d 50 04             	lea    0x4(%eax),%edx
  802326:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802329:	6a 00                	push   $0x0
  80232b:	6a 00                	push   $0x0
  80232d:	6a 00                	push   $0x0
  80232f:	52                   	push   %edx
  802330:	50                   	push   %eax
  802331:	6a 24                	push   $0x24
  802333:	e8 ca fb ff ff       	call   801f02 <syscall>
  802338:	83 c4 18             	add    $0x18,%esp
	return result;
  80233b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80233e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802341:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802344:	89 01                	mov    %eax,(%ecx)
  802346:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802349:	8b 45 08             	mov    0x8(%ebp),%eax
  80234c:	c9                   	leave  
  80234d:	c2 04 00             	ret    $0x4

00802350 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802350:	55                   	push   %ebp
  802351:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802353:	6a 00                	push   $0x0
  802355:	6a 00                	push   $0x0
  802357:	ff 75 10             	pushl  0x10(%ebp)
  80235a:	ff 75 0c             	pushl  0xc(%ebp)
  80235d:	ff 75 08             	pushl  0x8(%ebp)
  802360:	6a 12                	push   $0x12
  802362:	e8 9b fb ff ff       	call   801f02 <syscall>
  802367:	83 c4 18             	add    $0x18,%esp
	return ;
  80236a:	90                   	nop
}
  80236b:	c9                   	leave  
  80236c:	c3                   	ret    

0080236d <sys_rcr2>:
uint32 sys_rcr2()
{
  80236d:	55                   	push   %ebp
  80236e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802370:	6a 00                	push   $0x0
  802372:	6a 00                	push   $0x0
  802374:	6a 00                	push   $0x0
  802376:	6a 00                	push   $0x0
  802378:	6a 00                	push   $0x0
  80237a:	6a 25                	push   $0x25
  80237c:	e8 81 fb ff ff       	call   801f02 <syscall>
  802381:	83 c4 18             	add    $0x18,%esp
}
  802384:	c9                   	leave  
  802385:	c3                   	ret    

00802386 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802386:	55                   	push   %ebp
  802387:	89 e5                	mov    %esp,%ebp
  802389:	83 ec 04             	sub    $0x4,%esp
  80238c:	8b 45 08             	mov    0x8(%ebp),%eax
  80238f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802392:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802396:	6a 00                	push   $0x0
  802398:	6a 00                	push   $0x0
  80239a:	6a 00                	push   $0x0
  80239c:	6a 00                	push   $0x0
  80239e:	50                   	push   %eax
  80239f:	6a 26                	push   $0x26
  8023a1:	e8 5c fb ff ff       	call   801f02 <syscall>
  8023a6:	83 c4 18             	add    $0x18,%esp
	return ;
  8023a9:	90                   	nop
}
  8023aa:	c9                   	leave  
  8023ab:	c3                   	ret    

008023ac <rsttst>:
void rsttst()
{
  8023ac:	55                   	push   %ebp
  8023ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8023af:	6a 00                	push   $0x0
  8023b1:	6a 00                	push   $0x0
  8023b3:	6a 00                	push   $0x0
  8023b5:	6a 00                	push   $0x0
  8023b7:	6a 00                	push   $0x0
  8023b9:	6a 28                	push   $0x28
  8023bb:	e8 42 fb ff ff       	call   801f02 <syscall>
  8023c0:	83 c4 18             	add    $0x18,%esp
	return ;
  8023c3:	90                   	nop
}
  8023c4:	c9                   	leave  
  8023c5:	c3                   	ret    

008023c6 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8023c6:	55                   	push   %ebp
  8023c7:	89 e5                	mov    %esp,%ebp
  8023c9:	83 ec 04             	sub    $0x4,%esp
  8023cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8023cf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8023d2:	8b 55 18             	mov    0x18(%ebp),%edx
  8023d5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8023d9:	52                   	push   %edx
  8023da:	50                   	push   %eax
  8023db:	ff 75 10             	pushl  0x10(%ebp)
  8023de:	ff 75 0c             	pushl  0xc(%ebp)
  8023e1:	ff 75 08             	pushl  0x8(%ebp)
  8023e4:	6a 27                	push   $0x27
  8023e6:	e8 17 fb ff ff       	call   801f02 <syscall>
  8023eb:	83 c4 18             	add    $0x18,%esp
	return ;
  8023ee:	90                   	nop
}
  8023ef:	c9                   	leave  
  8023f0:	c3                   	ret    

008023f1 <chktst>:
void chktst(uint32 n)
{
  8023f1:	55                   	push   %ebp
  8023f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8023f4:	6a 00                	push   $0x0
  8023f6:	6a 00                	push   $0x0
  8023f8:	6a 00                	push   $0x0
  8023fa:	6a 00                	push   $0x0
  8023fc:	ff 75 08             	pushl  0x8(%ebp)
  8023ff:	6a 29                	push   $0x29
  802401:	e8 fc fa ff ff       	call   801f02 <syscall>
  802406:	83 c4 18             	add    $0x18,%esp
	return ;
  802409:	90                   	nop
}
  80240a:	c9                   	leave  
  80240b:	c3                   	ret    

0080240c <inctst>:

void inctst()
{
  80240c:	55                   	push   %ebp
  80240d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80240f:	6a 00                	push   $0x0
  802411:	6a 00                	push   $0x0
  802413:	6a 00                	push   $0x0
  802415:	6a 00                	push   $0x0
  802417:	6a 00                	push   $0x0
  802419:	6a 2a                	push   $0x2a
  80241b:	e8 e2 fa ff ff       	call   801f02 <syscall>
  802420:	83 c4 18             	add    $0x18,%esp
	return ;
  802423:	90                   	nop
}
  802424:	c9                   	leave  
  802425:	c3                   	ret    

00802426 <gettst>:
uint32 gettst()
{
  802426:	55                   	push   %ebp
  802427:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802429:	6a 00                	push   $0x0
  80242b:	6a 00                	push   $0x0
  80242d:	6a 00                	push   $0x0
  80242f:	6a 00                	push   $0x0
  802431:	6a 00                	push   $0x0
  802433:	6a 2b                	push   $0x2b
  802435:	e8 c8 fa ff ff       	call   801f02 <syscall>
  80243a:	83 c4 18             	add    $0x18,%esp
}
  80243d:	c9                   	leave  
  80243e:	c3                   	ret    

0080243f <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80243f:	55                   	push   %ebp
  802440:	89 e5                	mov    %esp,%ebp
  802442:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802445:	6a 00                	push   $0x0
  802447:	6a 00                	push   $0x0
  802449:	6a 00                	push   $0x0
  80244b:	6a 00                	push   $0x0
  80244d:	6a 00                	push   $0x0
  80244f:	6a 2c                	push   $0x2c
  802451:	e8 ac fa ff ff       	call   801f02 <syscall>
  802456:	83 c4 18             	add    $0x18,%esp
  802459:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80245c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802460:	75 07                	jne    802469 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802462:	b8 01 00 00 00       	mov    $0x1,%eax
  802467:	eb 05                	jmp    80246e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802469:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80246e:	c9                   	leave  
  80246f:	c3                   	ret    

00802470 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802470:	55                   	push   %ebp
  802471:	89 e5                	mov    %esp,%ebp
  802473:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802476:	6a 00                	push   $0x0
  802478:	6a 00                	push   $0x0
  80247a:	6a 00                	push   $0x0
  80247c:	6a 00                	push   $0x0
  80247e:	6a 00                	push   $0x0
  802480:	6a 2c                	push   $0x2c
  802482:	e8 7b fa ff ff       	call   801f02 <syscall>
  802487:	83 c4 18             	add    $0x18,%esp
  80248a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80248d:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802491:	75 07                	jne    80249a <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802493:	b8 01 00 00 00       	mov    $0x1,%eax
  802498:	eb 05                	jmp    80249f <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80249a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80249f:	c9                   	leave  
  8024a0:	c3                   	ret    

008024a1 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8024a1:	55                   	push   %ebp
  8024a2:	89 e5                	mov    %esp,%ebp
  8024a4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024a7:	6a 00                	push   $0x0
  8024a9:	6a 00                	push   $0x0
  8024ab:	6a 00                	push   $0x0
  8024ad:	6a 00                	push   $0x0
  8024af:	6a 00                	push   $0x0
  8024b1:	6a 2c                	push   $0x2c
  8024b3:	e8 4a fa ff ff       	call   801f02 <syscall>
  8024b8:	83 c4 18             	add    $0x18,%esp
  8024bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8024be:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8024c2:	75 07                	jne    8024cb <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8024c4:	b8 01 00 00 00       	mov    $0x1,%eax
  8024c9:	eb 05                	jmp    8024d0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8024cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024d0:	c9                   	leave  
  8024d1:	c3                   	ret    

008024d2 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8024d2:	55                   	push   %ebp
  8024d3:	89 e5                	mov    %esp,%ebp
  8024d5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024d8:	6a 00                	push   $0x0
  8024da:	6a 00                	push   $0x0
  8024dc:	6a 00                	push   $0x0
  8024de:	6a 00                	push   $0x0
  8024e0:	6a 00                	push   $0x0
  8024e2:	6a 2c                	push   $0x2c
  8024e4:	e8 19 fa ff ff       	call   801f02 <syscall>
  8024e9:	83 c4 18             	add    $0x18,%esp
  8024ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8024ef:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8024f3:	75 07                	jne    8024fc <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8024f5:	b8 01 00 00 00       	mov    $0x1,%eax
  8024fa:	eb 05                	jmp    802501 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8024fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802501:	c9                   	leave  
  802502:	c3                   	ret    

00802503 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802503:	55                   	push   %ebp
  802504:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802506:	6a 00                	push   $0x0
  802508:	6a 00                	push   $0x0
  80250a:	6a 00                	push   $0x0
  80250c:	6a 00                	push   $0x0
  80250e:	ff 75 08             	pushl  0x8(%ebp)
  802511:	6a 2d                	push   $0x2d
  802513:	e8 ea f9 ff ff       	call   801f02 <syscall>
  802518:	83 c4 18             	add    $0x18,%esp
	return ;
  80251b:	90                   	nop
}
  80251c:	c9                   	leave  
  80251d:	c3                   	ret    

0080251e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80251e:	55                   	push   %ebp
  80251f:	89 e5                	mov    %esp,%ebp
  802521:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802522:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802525:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802528:	8b 55 0c             	mov    0xc(%ebp),%edx
  80252b:	8b 45 08             	mov    0x8(%ebp),%eax
  80252e:	6a 00                	push   $0x0
  802530:	53                   	push   %ebx
  802531:	51                   	push   %ecx
  802532:	52                   	push   %edx
  802533:	50                   	push   %eax
  802534:	6a 2e                	push   $0x2e
  802536:	e8 c7 f9 ff ff       	call   801f02 <syscall>
  80253b:	83 c4 18             	add    $0x18,%esp
}
  80253e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802541:	c9                   	leave  
  802542:	c3                   	ret    

00802543 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802543:	55                   	push   %ebp
  802544:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802546:	8b 55 0c             	mov    0xc(%ebp),%edx
  802549:	8b 45 08             	mov    0x8(%ebp),%eax
  80254c:	6a 00                	push   $0x0
  80254e:	6a 00                	push   $0x0
  802550:	6a 00                	push   $0x0
  802552:	52                   	push   %edx
  802553:	50                   	push   %eax
  802554:	6a 2f                	push   $0x2f
  802556:	e8 a7 f9 ff ff       	call   801f02 <syscall>
  80255b:	83 c4 18             	add    $0x18,%esp
}
  80255e:	c9                   	leave  
  80255f:	c3                   	ret    

00802560 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802560:	55                   	push   %ebp
  802561:	89 e5                	mov    %esp,%ebp
  802563:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802566:	83 ec 0c             	sub    $0xc,%esp
  802569:	68 bc 46 80 00       	push   $0x8046bc
  80256e:	e8 18 e6 ff ff       	call   800b8b <cprintf>
  802573:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802576:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80257d:	83 ec 0c             	sub    $0xc,%esp
  802580:	68 e8 46 80 00       	push   $0x8046e8
  802585:	e8 01 e6 ff ff       	call   800b8b <cprintf>
  80258a:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80258d:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802591:	a1 38 51 80 00       	mov    0x805138,%eax
  802596:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802599:	eb 56                	jmp    8025f1 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80259b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80259f:	74 1c                	je     8025bd <print_mem_block_lists+0x5d>
  8025a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a4:	8b 50 08             	mov    0x8(%eax),%edx
  8025a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025aa:	8b 48 08             	mov    0x8(%eax),%ecx
  8025ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8025b3:	01 c8                	add    %ecx,%eax
  8025b5:	39 c2                	cmp    %eax,%edx
  8025b7:	73 04                	jae    8025bd <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8025b9:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8025bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c0:	8b 50 08             	mov    0x8(%eax),%edx
  8025c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8025c9:	01 c2                	add    %eax,%edx
  8025cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ce:	8b 40 08             	mov    0x8(%eax),%eax
  8025d1:	83 ec 04             	sub    $0x4,%esp
  8025d4:	52                   	push   %edx
  8025d5:	50                   	push   %eax
  8025d6:	68 fd 46 80 00       	push   $0x8046fd
  8025db:	e8 ab e5 ff ff       	call   800b8b <cprintf>
  8025e0:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8025e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8025e9:	a1 40 51 80 00       	mov    0x805140,%eax
  8025ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025f5:	74 07                	je     8025fe <print_mem_block_lists+0x9e>
  8025f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fa:	8b 00                	mov    (%eax),%eax
  8025fc:	eb 05                	jmp    802603 <print_mem_block_lists+0xa3>
  8025fe:	b8 00 00 00 00       	mov    $0x0,%eax
  802603:	a3 40 51 80 00       	mov    %eax,0x805140
  802608:	a1 40 51 80 00       	mov    0x805140,%eax
  80260d:	85 c0                	test   %eax,%eax
  80260f:	75 8a                	jne    80259b <print_mem_block_lists+0x3b>
  802611:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802615:	75 84                	jne    80259b <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802617:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80261b:	75 10                	jne    80262d <print_mem_block_lists+0xcd>
  80261d:	83 ec 0c             	sub    $0xc,%esp
  802620:	68 0c 47 80 00       	push   $0x80470c
  802625:	e8 61 e5 ff ff       	call   800b8b <cprintf>
  80262a:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80262d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802634:	83 ec 0c             	sub    $0xc,%esp
  802637:	68 30 47 80 00       	push   $0x804730
  80263c:	e8 4a e5 ff ff       	call   800b8b <cprintf>
  802641:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802644:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802648:	a1 40 50 80 00       	mov    0x805040,%eax
  80264d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802650:	eb 56                	jmp    8026a8 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802652:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802656:	74 1c                	je     802674 <print_mem_block_lists+0x114>
  802658:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265b:	8b 50 08             	mov    0x8(%eax),%edx
  80265e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802661:	8b 48 08             	mov    0x8(%eax),%ecx
  802664:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802667:	8b 40 0c             	mov    0xc(%eax),%eax
  80266a:	01 c8                	add    %ecx,%eax
  80266c:	39 c2                	cmp    %eax,%edx
  80266e:	73 04                	jae    802674 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802670:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802674:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802677:	8b 50 08             	mov    0x8(%eax),%edx
  80267a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267d:	8b 40 0c             	mov    0xc(%eax),%eax
  802680:	01 c2                	add    %eax,%edx
  802682:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802685:	8b 40 08             	mov    0x8(%eax),%eax
  802688:	83 ec 04             	sub    $0x4,%esp
  80268b:	52                   	push   %edx
  80268c:	50                   	push   %eax
  80268d:	68 fd 46 80 00       	push   $0x8046fd
  802692:	e8 f4 e4 ff ff       	call   800b8b <cprintf>
  802697:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80269a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8026a0:	a1 48 50 80 00       	mov    0x805048,%eax
  8026a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ac:	74 07                	je     8026b5 <print_mem_block_lists+0x155>
  8026ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b1:	8b 00                	mov    (%eax),%eax
  8026b3:	eb 05                	jmp    8026ba <print_mem_block_lists+0x15a>
  8026b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ba:	a3 48 50 80 00       	mov    %eax,0x805048
  8026bf:	a1 48 50 80 00       	mov    0x805048,%eax
  8026c4:	85 c0                	test   %eax,%eax
  8026c6:	75 8a                	jne    802652 <print_mem_block_lists+0xf2>
  8026c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026cc:	75 84                	jne    802652 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8026ce:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8026d2:	75 10                	jne    8026e4 <print_mem_block_lists+0x184>
  8026d4:	83 ec 0c             	sub    $0xc,%esp
  8026d7:	68 48 47 80 00       	push   $0x804748
  8026dc:	e8 aa e4 ff ff       	call   800b8b <cprintf>
  8026e1:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8026e4:	83 ec 0c             	sub    $0xc,%esp
  8026e7:	68 bc 46 80 00       	push   $0x8046bc
  8026ec:	e8 9a e4 ff ff       	call   800b8b <cprintf>
  8026f1:	83 c4 10             	add    $0x10,%esp

}
  8026f4:	90                   	nop
  8026f5:	c9                   	leave  
  8026f6:	c3                   	ret    

008026f7 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8026f7:	55                   	push   %ebp
  8026f8:	89 e5                	mov    %esp,%ebp
  8026fa:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8026fd:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802704:	00 00 00 
  802707:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80270e:	00 00 00 
  802711:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802718:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  80271b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802722:	e9 9e 00 00 00       	jmp    8027c5 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802727:	a1 50 50 80 00       	mov    0x805050,%eax
  80272c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80272f:	c1 e2 04             	shl    $0x4,%edx
  802732:	01 d0                	add    %edx,%eax
  802734:	85 c0                	test   %eax,%eax
  802736:	75 14                	jne    80274c <initialize_MemBlocksList+0x55>
  802738:	83 ec 04             	sub    $0x4,%esp
  80273b:	68 70 47 80 00       	push   $0x804770
  802740:	6a 46                	push   $0x46
  802742:	68 93 47 80 00       	push   $0x804793
  802747:	e8 8b e1 ff ff       	call   8008d7 <_panic>
  80274c:	a1 50 50 80 00       	mov    0x805050,%eax
  802751:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802754:	c1 e2 04             	shl    $0x4,%edx
  802757:	01 d0                	add    %edx,%eax
  802759:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80275f:	89 10                	mov    %edx,(%eax)
  802761:	8b 00                	mov    (%eax),%eax
  802763:	85 c0                	test   %eax,%eax
  802765:	74 18                	je     80277f <initialize_MemBlocksList+0x88>
  802767:	a1 48 51 80 00       	mov    0x805148,%eax
  80276c:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802772:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802775:	c1 e1 04             	shl    $0x4,%ecx
  802778:	01 ca                	add    %ecx,%edx
  80277a:	89 50 04             	mov    %edx,0x4(%eax)
  80277d:	eb 12                	jmp    802791 <initialize_MemBlocksList+0x9a>
  80277f:	a1 50 50 80 00       	mov    0x805050,%eax
  802784:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802787:	c1 e2 04             	shl    $0x4,%edx
  80278a:	01 d0                	add    %edx,%eax
  80278c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802791:	a1 50 50 80 00       	mov    0x805050,%eax
  802796:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802799:	c1 e2 04             	shl    $0x4,%edx
  80279c:	01 d0                	add    %edx,%eax
  80279e:	a3 48 51 80 00       	mov    %eax,0x805148
  8027a3:	a1 50 50 80 00       	mov    0x805050,%eax
  8027a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027ab:	c1 e2 04             	shl    $0x4,%edx
  8027ae:	01 d0                	add    %edx,%eax
  8027b0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027b7:	a1 54 51 80 00       	mov    0x805154,%eax
  8027bc:	40                   	inc    %eax
  8027bd:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8027c2:	ff 45 f4             	incl   -0xc(%ebp)
  8027c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027cb:	0f 82 56 ff ff ff    	jb     802727 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8027d1:	90                   	nop
  8027d2:	c9                   	leave  
  8027d3:	c3                   	ret    

008027d4 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8027d4:	55                   	push   %ebp
  8027d5:	89 e5                	mov    %esp,%ebp
  8027d7:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8027da:	8b 45 08             	mov    0x8(%ebp),%eax
  8027dd:	8b 00                	mov    (%eax),%eax
  8027df:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8027e2:	eb 19                	jmp    8027fd <find_block+0x29>
	{
		if(va==point->sva)
  8027e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027e7:	8b 40 08             	mov    0x8(%eax),%eax
  8027ea:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8027ed:	75 05                	jne    8027f4 <find_block+0x20>
		   return point;
  8027ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027f2:	eb 36                	jmp    80282a <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8027f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f7:	8b 40 08             	mov    0x8(%eax),%eax
  8027fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8027fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802801:	74 07                	je     80280a <find_block+0x36>
  802803:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802806:	8b 00                	mov    (%eax),%eax
  802808:	eb 05                	jmp    80280f <find_block+0x3b>
  80280a:	b8 00 00 00 00       	mov    $0x0,%eax
  80280f:	8b 55 08             	mov    0x8(%ebp),%edx
  802812:	89 42 08             	mov    %eax,0x8(%edx)
  802815:	8b 45 08             	mov    0x8(%ebp),%eax
  802818:	8b 40 08             	mov    0x8(%eax),%eax
  80281b:	85 c0                	test   %eax,%eax
  80281d:	75 c5                	jne    8027e4 <find_block+0x10>
  80281f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802823:	75 bf                	jne    8027e4 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802825:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80282a:	c9                   	leave  
  80282b:	c3                   	ret    

0080282c <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80282c:	55                   	push   %ebp
  80282d:	89 e5                	mov    %esp,%ebp
  80282f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802832:	a1 40 50 80 00       	mov    0x805040,%eax
  802837:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  80283a:	a1 44 50 80 00       	mov    0x805044,%eax
  80283f:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802842:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802845:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802848:	74 24                	je     80286e <insert_sorted_allocList+0x42>
  80284a:	8b 45 08             	mov    0x8(%ebp),%eax
  80284d:	8b 50 08             	mov    0x8(%eax),%edx
  802850:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802853:	8b 40 08             	mov    0x8(%eax),%eax
  802856:	39 c2                	cmp    %eax,%edx
  802858:	76 14                	jbe    80286e <insert_sorted_allocList+0x42>
  80285a:	8b 45 08             	mov    0x8(%ebp),%eax
  80285d:	8b 50 08             	mov    0x8(%eax),%edx
  802860:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802863:	8b 40 08             	mov    0x8(%eax),%eax
  802866:	39 c2                	cmp    %eax,%edx
  802868:	0f 82 60 01 00 00    	jb     8029ce <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  80286e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802872:	75 65                	jne    8028d9 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802874:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802878:	75 14                	jne    80288e <insert_sorted_allocList+0x62>
  80287a:	83 ec 04             	sub    $0x4,%esp
  80287d:	68 70 47 80 00       	push   $0x804770
  802882:	6a 6b                	push   $0x6b
  802884:	68 93 47 80 00       	push   $0x804793
  802889:	e8 49 e0 ff ff       	call   8008d7 <_panic>
  80288e:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802894:	8b 45 08             	mov    0x8(%ebp),%eax
  802897:	89 10                	mov    %edx,(%eax)
  802899:	8b 45 08             	mov    0x8(%ebp),%eax
  80289c:	8b 00                	mov    (%eax),%eax
  80289e:	85 c0                	test   %eax,%eax
  8028a0:	74 0d                	je     8028af <insert_sorted_allocList+0x83>
  8028a2:	a1 40 50 80 00       	mov    0x805040,%eax
  8028a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8028aa:	89 50 04             	mov    %edx,0x4(%eax)
  8028ad:	eb 08                	jmp    8028b7 <insert_sorted_allocList+0x8b>
  8028af:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b2:	a3 44 50 80 00       	mov    %eax,0x805044
  8028b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ba:	a3 40 50 80 00       	mov    %eax,0x805040
  8028bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028c9:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8028ce:	40                   	inc    %eax
  8028cf:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8028d4:	e9 dc 01 00 00       	jmp    802ab5 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8028d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028dc:	8b 50 08             	mov    0x8(%eax),%edx
  8028df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e2:	8b 40 08             	mov    0x8(%eax),%eax
  8028e5:	39 c2                	cmp    %eax,%edx
  8028e7:	77 6c                	ja     802955 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8028e9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028ed:	74 06                	je     8028f5 <insert_sorted_allocList+0xc9>
  8028ef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028f3:	75 14                	jne    802909 <insert_sorted_allocList+0xdd>
  8028f5:	83 ec 04             	sub    $0x4,%esp
  8028f8:	68 ac 47 80 00       	push   $0x8047ac
  8028fd:	6a 6f                	push   $0x6f
  8028ff:	68 93 47 80 00       	push   $0x804793
  802904:	e8 ce df ff ff       	call   8008d7 <_panic>
  802909:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80290c:	8b 50 04             	mov    0x4(%eax),%edx
  80290f:	8b 45 08             	mov    0x8(%ebp),%eax
  802912:	89 50 04             	mov    %edx,0x4(%eax)
  802915:	8b 45 08             	mov    0x8(%ebp),%eax
  802918:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80291b:	89 10                	mov    %edx,(%eax)
  80291d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802920:	8b 40 04             	mov    0x4(%eax),%eax
  802923:	85 c0                	test   %eax,%eax
  802925:	74 0d                	je     802934 <insert_sorted_allocList+0x108>
  802927:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80292a:	8b 40 04             	mov    0x4(%eax),%eax
  80292d:	8b 55 08             	mov    0x8(%ebp),%edx
  802930:	89 10                	mov    %edx,(%eax)
  802932:	eb 08                	jmp    80293c <insert_sorted_allocList+0x110>
  802934:	8b 45 08             	mov    0x8(%ebp),%eax
  802937:	a3 40 50 80 00       	mov    %eax,0x805040
  80293c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293f:	8b 55 08             	mov    0x8(%ebp),%edx
  802942:	89 50 04             	mov    %edx,0x4(%eax)
  802945:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80294a:	40                   	inc    %eax
  80294b:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802950:	e9 60 01 00 00       	jmp    802ab5 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802955:	8b 45 08             	mov    0x8(%ebp),%eax
  802958:	8b 50 08             	mov    0x8(%eax),%edx
  80295b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80295e:	8b 40 08             	mov    0x8(%eax),%eax
  802961:	39 c2                	cmp    %eax,%edx
  802963:	0f 82 4c 01 00 00    	jb     802ab5 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802969:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80296d:	75 14                	jne    802983 <insert_sorted_allocList+0x157>
  80296f:	83 ec 04             	sub    $0x4,%esp
  802972:	68 e4 47 80 00       	push   $0x8047e4
  802977:	6a 73                	push   $0x73
  802979:	68 93 47 80 00       	push   $0x804793
  80297e:	e8 54 df ff ff       	call   8008d7 <_panic>
  802983:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802989:	8b 45 08             	mov    0x8(%ebp),%eax
  80298c:	89 50 04             	mov    %edx,0x4(%eax)
  80298f:	8b 45 08             	mov    0x8(%ebp),%eax
  802992:	8b 40 04             	mov    0x4(%eax),%eax
  802995:	85 c0                	test   %eax,%eax
  802997:	74 0c                	je     8029a5 <insert_sorted_allocList+0x179>
  802999:	a1 44 50 80 00       	mov    0x805044,%eax
  80299e:	8b 55 08             	mov    0x8(%ebp),%edx
  8029a1:	89 10                	mov    %edx,(%eax)
  8029a3:	eb 08                	jmp    8029ad <insert_sorted_allocList+0x181>
  8029a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a8:	a3 40 50 80 00       	mov    %eax,0x805040
  8029ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b0:	a3 44 50 80 00       	mov    %eax,0x805044
  8029b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029be:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029c3:	40                   	inc    %eax
  8029c4:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8029c9:	e9 e7 00 00 00       	jmp    802ab5 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8029ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8029d4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8029db:	a1 40 50 80 00       	mov    0x805040,%eax
  8029e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029e3:	e9 9d 00 00 00       	jmp    802a85 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8029e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029eb:	8b 00                	mov    (%eax),%eax
  8029ed:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8029f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f3:	8b 50 08             	mov    0x8(%eax),%edx
  8029f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f9:	8b 40 08             	mov    0x8(%eax),%eax
  8029fc:	39 c2                	cmp    %eax,%edx
  8029fe:	76 7d                	jbe    802a7d <insert_sorted_allocList+0x251>
  802a00:	8b 45 08             	mov    0x8(%ebp),%eax
  802a03:	8b 50 08             	mov    0x8(%eax),%edx
  802a06:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a09:	8b 40 08             	mov    0x8(%eax),%eax
  802a0c:	39 c2                	cmp    %eax,%edx
  802a0e:	73 6d                	jae    802a7d <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802a10:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a14:	74 06                	je     802a1c <insert_sorted_allocList+0x1f0>
  802a16:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a1a:	75 14                	jne    802a30 <insert_sorted_allocList+0x204>
  802a1c:	83 ec 04             	sub    $0x4,%esp
  802a1f:	68 08 48 80 00       	push   $0x804808
  802a24:	6a 7f                	push   $0x7f
  802a26:	68 93 47 80 00       	push   $0x804793
  802a2b:	e8 a7 de ff ff       	call   8008d7 <_panic>
  802a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a33:	8b 10                	mov    (%eax),%edx
  802a35:	8b 45 08             	mov    0x8(%ebp),%eax
  802a38:	89 10                	mov    %edx,(%eax)
  802a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3d:	8b 00                	mov    (%eax),%eax
  802a3f:	85 c0                	test   %eax,%eax
  802a41:	74 0b                	je     802a4e <insert_sorted_allocList+0x222>
  802a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a46:	8b 00                	mov    (%eax),%eax
  802a48:	8b 55 08             	mov    0x8(%ebp),%edx
  802a4b:	89 50 04             	mov    %edx,0x4(%eax)
  802a4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a51:	8b 55 08             	mov    0x8(%ebp),%edx
  802a54:	89 10                	mov    %edx,(%eax)
  802a56:	8b 45 08             	mov    0x8(%ebp),%eax
  802a59:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a5c:	89 50 04             	mov    %edx,0x4(%eax)
  802a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a62:	8b 00                	mov    (%eax),%eax
  802a64:	85 c0                	test   %eax,%eax
  802a66:	75 08                	jne    802a70 <insert_sorted_allocList+0x244>
  802a68:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6b:	a3 44 50 80 00       	mov    %eax,0x805044
  802a70:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a75:	40                   	inc    %eax
  802a76:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802a7b:	eb 39                	jmp    802ab6 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802a7d:	a1 48 50 80 00       	mov    0x805048,%eax
  802a82:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a85:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a89:	74 07                	je     802a92 <insert_sorted_allocList+0x266>
  802a8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8e:	8b 00                	mov    (%eax),%eax
  802a90:	eb 05                	jmp    802a97 <insert_sorted_allocList+0x26b>
  802a92:	b8 00 00 00 00       	mov    $0x0,%eax
  802a97:	a3 48 50 80 00       	mov    %eax,0x805048
  802a9c:	a1 48 50 80 00       	mov    0x805048,%eax
  802aa1:	85 c0                	test   %eax,%eax
  802aa3:	0f 85 3f ff ff ff    	jne    8029e8 <insert_sorted_allocList+0x1bc>
  802aa9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aad:	0f 85 35 ff ff ff    	jne    8029e8 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802ab3:	eb 01                	jmp    802ab6 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802ab5:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802ab6:	90                   	nop
  802ab7:	c9                   	leave  
  802ab8:	c3                   	ret    

00802ab9 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802ab9:	55                   	push   %ebp
  802aba:	89 e5                	mov    %esp,%ebp
  802abc:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802abf:	a1 38 51 80 00       	mov    0x805138,%eax
  802ac4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ac7:	e9 85 01 00 00       	jmp    802c51 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acf:	8b 40 0c             	mov    0xc(%eax),%eax
  802ad2:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ad5:	0f 82 6e 01 00 00    	jb     802c49 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ade:	8b 40 0c             	mov    0xc(%eax),%eax
  802ae1:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ae4:	0f 85 8a 00 00 00    	jne    802b74 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802aea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aee:	75 17                	jne    802b07 <alloc_block_FF+0x4e>
  802af0:	83 ec 04             	sub    $0x4,%esp
  802af3:	68 3c 48 80 00       	push   $0x80483c
  802af8:	68 93 00 00 00       	push   $0x93
  802afd:	68 93 47 80 00       	push   $0x804793
  802b02:	e8 d0 dd ff ff       	call   8008d7 <_panic>
  802b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0a:	8b 00                	mov    (%eax),%eax
  802b0c:	85 c0                	test   %eax,%eax
  802b0e:	74 10                	je     802b20 <alloc_block_FF+0x67>
  802b10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b13:	8b 00                	mov    (%eax),%eax
  802b15:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b18:	8b 52 04             	mov    0x4(%edx),%edx
  802b1b:	89 50 04             	mov    %edx,0x4(%eax)
  802b1e:	eb 0b                	jmp    802b2b <alloc_block_FF+0x72>
  802b20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b23:	8b 40 04             	mov    0x4(%eax),%eax
  802b26:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2e:	8b 40 04             	mov    0x4(%eax),%eax
  802b31:	85 c0                	test   %eax,%eax
  802b33:	74 0f                	je     802b44 <alloc_block_FF+0x8b>
  802b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b38:	8b 40 04             	mov    0x4(%eax),%eax
  802b3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b3e:	8b 12                	mov    (%edx),%edx
  802b40:	89 10                	mov    %edx,(%eax)
  802b42:	eb 0a                	jmp    802b4e <alloc_block_FF+0x95>
  802b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b47:	8b 00                	mov    (%eax),%eax
  802b49:	a3 38 51 80 00       	mov    %eax,0x805138
  802b4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b51:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b61:	a1 44 51 80 00       	mov    0x805144,%eax
  802b66:	48                   	dec    %eax
  802b67:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802b6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6f:	e9 10 01 00 00       	jmp    802c84 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802b74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b77:	8b 40 0c             	mov    0xc(%eax),%eax
  802b7a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b7d:	0f 86 c6 00 00 00    	jbe    802c49 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b83:	a1 48 51 80 00       	mov    0x805148,%eax
  802b88:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8e:	8b 50 08             	mov    0x8(%eax),%edx
  802b91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b94:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802b97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b9a:	8b 55 08             	mov    0x8(%ebp),%edx
  802b9d:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802ba0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ba4:	75 17                	jne    802bbd <alloc_block_FF+0x104>
  802ba6:	83 ec 04             	sub    $0x4,%esp
  802ba9:	68 3c 48 80 00       	push   $0x80483c
  802bae:	68 9b 00 00 00       	push   $0x9b
  802bb3:	68 93 47 80 00       	push   $0x804793
  802bb8:	e8 1a dd ff ff       	call   8008d7 <_panic>
  802bbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc0:	8b 00                	mov    (%eax),%eax
  802bc2:	85 c0                	test   %eax,%eax
  802bc4:	74 10                	je     802bd6 <alloc_block_FF+0x11d>
  802bc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc9:	8b 00                	mov    (%eax),%eax
  802bcb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bce:	8b 52 04             	mov    0x4(%edx),%edx
  802bd1:	89 50 04             	mov    %edx,0x4(%eax)
  802bd4:	eb 0b                	jmp    802be1 <alloc_block_FF+0x128>
  802bd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd9:	8b 40 04             	mov    0x4(%eax),%eax
  802bdc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802be1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be4:	8b 40 04             	mov    0x4(%eax),%eax
  802be7:	85 c0                	test   %eax,%eax
  802be9:	74 0f                	je     802bfa <alloc_block_FF+0x141>
  802beb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bee:	8b 40 04             	mov    0x4(%eax),%eax
  802bf1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bf4:	8b 12                	mov    (%edx),%edx
  802bf6:	89 10                	mov    %edx,(%eax)
  802bf8:	eb 0a                	jmp    802c04 <alloc_block_FF+0x14b>
  802bfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bfd:	8b 00                	mov    (%eax),%eax
  802bff:	a3 48 51 80 00       	mov    %eax,0x805148
  802c04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c07:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c10:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c17:	a1 54 51 80 00       	mov    0x805154,%eax
  802c1c:	48                   	dec    %eax
  802c1d:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802c22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c25:	8b 50 08             	mov    0x8(%eax),%edx
  802c28:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2b:	01 c2                	add    %eax,%edx
  802c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c30:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802c33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c36:	8b 40 0c             	mov    0xc(%eax),%eax
  802c39:	2b 45 08             	sub    0x8(%ebp),%eax
  802c3c:	89 c2                	mov    %eax,%edx
  802c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c41:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802c44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c47:	eb 3b                	jmp    802c84 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802c49:	a1 40 51 80 00       	mov    0x805140,%eax
  802c4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c51:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c55:	74 07                	je     802c5e <alloc_block_FF+0x1a5>
  802c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5a:	8b 00                	mov    (%eax),%eax
  802c5c:	eb 05                	jmp    802c63 <alloc_block_FF+0x1aa>
  802c5e:	b8 00 00 00 00       	mov    $0x0,%eax
  802c63:	a3 40 51 80 00       	mov    %eax,0x805140
  802c68:	a1 40 51 80 00       	mov    0x805140,%eax
  802c6d:	85 c0                	test   %eax,%eax
  802c6f:	0f 85 57 fe ff ff    	jne    802acc <alloc_block_FF+0x13>
  802c75:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c79:	0f 85 4d fe ff ff    	jne    802acc <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802c7f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c84:	c9                   	leave  
  802c85:	c3                   	ret    

00802c86 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802c86:	55                   	push   %ebp
  802c87:	89 e5                	mov    %esp,%ebp
  802c89:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802c8c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802c93:	a1 38 51 80 00       	mov    0x805138,%eax
  802c98:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c9b:	e9 df 00 00 00       	jmp    802d7f <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802ca0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca3:	8b 40 0c             	mov    0xc(%eax),%eax
  802ca6:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ca9:	0f 82 c8 00 00 00    	jb     802d77 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802caf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb2:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb5:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cb8:	0f 85 8a 00 00 00    	jne    802d48 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802cbe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cc2:	75 17                	jne    802cdb <alloc_block_BF+0x55>
  802cc4:	83 ec 04             	sub    $0x4,%esp
  802cc7:	68 3c 48 80 00       	push   $0x80483c
  802ccc:	68 b7 00 00 00       	push   $0xb7
  802cd1:	68 93 47 80 00       	push   $0x804793
  802cd6:	e8 fc db ff ff       	call   8008d7 <_panic>
  802cdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cde:	8b 00                	mov    (%eax),%eax
  802ce0:	85 c0                	test   %eax,%eax
  802ce2:	74 10                	je     802cf4 <alloc_block_BF+0x6e>
  802ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce7:	8b 00                	mov    (%eax),%eax
  802ce9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cec:	8b 52 04             	mov    0x4(%edx),%edx
  802cef:	89 50 04             	mov    %edx,0x4(%eax)
  802cf2:	eb 0b                	jmp    802cff <alloc_block_BF+0x79>
  802cf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf7:	8b 40 04             	mov    0x4(%eax),%eax
  802cfa:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d02:	8b 40 04             	mov    0x4(%eax),%eax
  802d05:	85 c0                	test   %eax,%eax
  802d07:	74 0f                	je     802d18 <alloc_block_BF+0x92>
  802d09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0c:	8b 40 04             	mov    0x4(%eax),%eax
  802d0f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d12:	8b 12                	mov    (%edx),%edx
  802d14:	89 10                	mov    %edx,(%eax)
  802d16:	eb 0a                	jmp    802d22 <alloc_block_BF+0x9c>
  802d18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1b:	8b 00                	mov    (%eax),%eax
  802d1d:	a3 38 51 80 00       	mov    %eax,0x805138
  802d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d25:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d35:	a1 44 51 80 00       	mov    0x805144,%eax
  802d3a:	48                   	dec    %eax
  802d3b:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802d40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d43:	e9 4d 01 00 00       	jmp    802e95 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802d48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4b:	8b 40 0c             	mov    0xc(%eax),%eax
  802d4e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d51:	76 24                	jbe    802d77 <alloc_block_BF+0xf1>
  802d53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d56:	8b 40 0c             	mov    0xc(%eax),%eax
  802d59:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802d5c:	73 19                	jae    802d77 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802d5e:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802d65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d68:	8b 40 0c             	mov    0xc(%eax),%eax
  802d6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802d6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d71:	8b 40 08             	mov    0x8(%eax),%eax
  802d74:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802d77:	a1 40 51 80 00       	mov    0x805140,%eax
  802d7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d7f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d83:	74 07                	je     802d8c <alloc_block_BF+0x106>
  802d85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d88:	8b 00                	mov    (%eax),%eax
  802d8a:	eb 05                	jmp    802d91 <alloc_block_BF+0x10b>
  802d8c:	b8 00 00 00 00       	mov    $0x0,%eax
  802d91:	a3 40 51 80 00       	mov    %eax,0x805140
  802d96:	a1 40 51 80 00       	mov    0x805140,%eax
  802d9b:	85 c0                	test   %eax,%eax
  802d9d:	0f 85 fd fe ff ff    	jne    802ca0 <alloc_block_BF+0x1a>
  802da3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802da7:	0f 85 f3 fe ff ff    	jne    802ca0 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802dad:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802db1:	0f 84 d9 00 00 00    	je     802e90 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802db7:	a1 48 51 80 00       	mov    0x805148,%eax
  802dbc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802dbf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dc2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802dc5:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802dc8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dcb:	8b 55 08             	mov    0x8(%ebp),%edx
  802dce:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802dd1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802dd5:	75 17                	jne    802dee <alloc_block_BF+0x168>
  802dd7:	83 ec 04             	sub    $0x4,%esp
  802dda:	68 3c 48 80 00       	push   $0x80483c
  802ddf:	68 c7 00 00 00       	push   $0xc7
  802de4:	68 93 47 80 00       	push   $0x804793
  802de9:	e8 e9 da ff ff       	call   8008d7 <_panic>
  802dee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802df1:	8b 00                	mov    (%eax),%eax
  802df3:	85 c0                	test   %eax,%eax
  802df5:	74 10                	je     802e07 <alloc_block_BF+0x181>
  802df7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dfa:	8b 00                	mov    (%eax),%eax
  802dfc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802dff:	8b 52 04             	mov    0x4(%edx),%edx
  802e02:	89 50 04             	mov    %edx,0x4(%eax)
  802e05:	eb 0b                	jmp    802e12 <alloc_block_BF+0x18c>
  802e07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e0a:	8b 40 04             	mov    0x4(%eax),%eax
  802e0d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e12:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e15:	8b 40 04             	mov    0x4(%eax),%eax
  802e18:	85 c0                	test   %eax,%eax
  802e1a:	74 0f                	je     802e2b <alloc_block_BF+0x1a5>
  802e1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e1f:	8b 40 04             	mov    0x4(%eax),%eax
  802e22:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e25:	8b 12                	mov    (%edx),%edx
  802e27:	89 10                	mov    %edx,(%eax)
  802e29:	eb 0a                	jmp    802e35 <alloc_block_BF+0x1af>
  802e2b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e2e:	8b 00                	mov    (%eax),%eax
  802e30:	a3 48 51 80 00       	mov    %eax,0x805148
  802e35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e38:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e41:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e48:	a1 54 51 80 00       	mov    0x805154,%eax
  802e4d:	48                   	dec    %eax
  802e4e:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802e53:	83 ec 08             	sub    $0x8,%esp
  802e56:	ff 75 ec             	pushl  -0x14(%ebp)
  802e59:	68 38 51 80 00       	push   $0x805138
  802e5e:	e8 71 f9 ff ff       	call   8027d4 <find_block>
  802e63:	83 c4 10             	add    $0x10,%esp
  802e66:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802e69:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e6c:	8b 50 08             	mov    0x8(%eax),%edx
  802e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e72:	01 c2                	add    %eax,%edx
  802e74:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e77:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802e7a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e7d:	8b 40 0c             	mov    0xc(%eax),%eax
  802e80:	2b 45 08             	sub    0x8(%ebp),%eax
  802e83:	89 c2                	mov    %eax,%edx
  802e85:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e88:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802e8b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e8e:	eb 05                	jmp    802e95 <alloc_block_BF+0x20f>
	}
	return NULL;
  802e90:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e95:	c9                   	leave  
  802e96:	c3                   	ret    

00802e97 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802e97:	55                   	push   %ebp
  802e98:	89 e5                	mov    %esp,%ebp
  802e9a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802e9d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802ea2:	85 c0                	test   %eax,%eax
  802ea4:	0f 85 de 01 00 00    	jne    803088 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802eaa:	a1 38 51 80 00       	mov    0x805138,%eax
  802eaf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802eb2:	e9 9e 01 00 00       	jmp    803055 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802eb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eba:	8b 40 0c             	mov    0xc(%eax),%eax
  802ebd:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ec0:	0f 82 87 01 00 00    	jb     80304d <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802ec6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec9:	8b 40 0c             	mov    0xc(%eax),%eax
  802ecc:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ecf:	0f 85 95 00 00 00    	jne    802f6a <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802ed5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ed9:	75 17                	jne    802ef2 <alloc_block_NF+0x5b>
  802edb:	83 ec 04             	sub    $0x4,%esp
  802ede:	68 3c 48 80 00       	push   $0x80483c
  802ee3:	68 e0 00 00 00       	push   $0xe0
  802ee8:	68 93 47 80 00       	push   $0x804793
  802eed:	e8 e5 d9 ff ff       	call   8008d7 <_panic>
  802ef2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef5:	8b 00                	mov    (%eax),%eax
  802ef7:	85 c0                	test   %eax,%eax
  802ef9:	74 10                	je     802f0b <alloc_block_NF+0x74>
  802efb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efe:	8b 00                	mov    (%eax),%eax
  802f00:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f03:	8b 52 04             	mov    0x4(%edx),%edx
  802f06:	89 50 04             	mov    %edx,0x4(%eax)
  802f09:	eb 0b                	jmp    802f16 <alloc_block_NF+0x7f>
  802f0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0e:	8b 40 04             	mov    0x4(%eax),%eax
  802f11:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f19:	8b 40 04             	mov    0x4(%eax),%eax
  802f1c:	85 c0                	test   %eax,%eax
  802f1e:	74 0f                	je     802f2f <alloc_block_NF+0x98>
  802f20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f23:	8b 40 04             	mov    0x4(%eax),%eax
  802f26:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f29:	8b 12                	mov    (%edx),%edx
  802f2b:	89 10                	mov    %edx,(%eax)
  802f2d:	eb 0a                	jmp    802f39 <alloc_block_NF+0xa2>
  802f2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f32:	8b 00                	mov    (%eax),%eax
  802f34:	a3 38 51 80 00       	mov    %eax,0x805138
  802f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f45:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f4c:	a1 44 51 80 00       	mov    0x805144,%eax
  802f51:	48                   	dec    %eax
  802f52:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802f57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5a:	8b 40 08             	mov    0x8(%eax),%eax
  802f5d:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   return  point;
  802f62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f65:	e9 f8 04 00 00       	jmp    803462 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802f6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6d:	8b 40 0c             	mov    0xc(%eax),%eax
  802f70:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f73:	0f 86 d4 00 00 00    	jbe    80304d <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802f79:	a1 48 51 80 00       	mov    0x805148,%eax
  802f7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802f81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f84:	8b 50 08             	mov    0x8(%eax),%edx
  802f87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f8a:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802f8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f90:	8b 55 08             	mov    0x8(%ebp),%edx
  802f93:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802f96:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f9a:	75 17                	jne    802fb3 <alloc_block_NF+0x11c>
  802f9c:	83 ec 04             	sub    $0x4,%esp
  802f9f:	68 3c 48 80 00       	push   $0x80483c
  802fa4:	68 e9 00 00 00       	push   $0xe9
  802fa9:	68 93 47 80 00       	push   $0x804793
  802fae:	e8 24 d9 ff ff       	call   8008d7 <_panic>
  802fb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb6:	8b 00                	mov    (%eax),%eax
  802fb8:	85 c0                	test   %eax,%eax
  802fba:	74 10                	je     802fcc <alloc_block_NF+0x135>
  802fbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fbf:	8b 00                	mov    (%eax),%eax
  802fc1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fc4:	8b 52 04             	mov    0x4(%edx),%edx
  802fc7:	89 50 04             	mov    %edx,0x4(%eax)
  802fca:	eb 0b                	jmp    802fd7 <alloc_block_NF+0x140>
  802fcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fcf:	8b 40 04             	mov    0x4(%eax),%eax
  802fd2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fda:	8b 40 04             	mov    0x4(%eax),%eax
  802fdd:	85 c0                	test   %eax,%eax
  802fdf:	74 0f                	je     802ff0 <alloc_block_NF+0x159>
  802fe1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe4:	8b 40 04             	mov    0x4(%eax),%eax
  802fe7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fea:	8b 12                	mov    (%edx),%edx
  802fec:	89 10                	mov    %edx,(%eax)
  802fee:	eb 0a                	jmp    802ffa <alloc_block_NF+0x163>
  802ff0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff3:	8b 00                	mov    (%eax),%eax
  802ff5:	a3 48 51 80 00       	mov    %eax,0x805148
  802ffa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ffd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803003:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803006:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80300d:	a1 54 51 80 00       	mov    0x805154,%eax
  803012:	48                   	dec    %eax
  803013:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  803018:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80301b:	8b 40 08             	mov    0x8(%eax),%eax
  80301e:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   point->sva += size;
  803023:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803026:	8b 50 08             	mov    0x8(%eax),%edx
  803029:	8b 45 08             	mov    0x8(%ebp),%eax
  80302c:	01 c2                	add    %eax,%edx
  80302e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803031:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  803034:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803037:	8b 40 0c             	mov    0xc(%eax),%eax
  80303a:	2b 45 08             	sub    0x8(%ebp),%eax
  80303d:	89 c2                	mov    %eax,%edx
  80303f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803042:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  803045:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803048:	e9 15 04 00 00       	jmp    803462 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80304d:	a1 40 51 80 00       	mov    0x805140,%eax
  803052:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803055:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803059:	74 07                	je     803062 <alloc_block_NF+0x1cb>
  80305b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305e:	8b 00                	mov    (%eax),%eax
  803060:	eb 05                	jmp    803067 <alloc_block_NF+0x1d0>
  803062:	b8 00 00 00 00       	mov    $0x0,%eax
  803067:	a3 40 51 80 00       	mov    %eax,0x805140
  80306c:	a1 40 51 80 00       	mov    0x805140,%eax
  803071:	85 c0                	test   %eax,%eax
  803073:	0f 85 3e fe ff ff    	jne    802eb7 <alloc_block_NF+0x20>
  803079:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80307d:	0f 85 34 fe ff ff    	jne    802eb7 <alloc_block_NF+0x20>
  803083:	e9 d5 03 00 00       	jmp    80345d <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803088:	a1 38 51 80 00       	mov    0x805138,%eax
  80308d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803090:	e9 b1 01 00 00       	jmp    803246 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  803095:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803098:	8b 50 08             	mov    0x8(%eax),%edx
  80309b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030a0:	39 c2                	cmp    %eax,%edx
  8030a2:	0f 82 96 01 00 00    	jb     80323e <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8030a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8030ae:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030b1:	0f 82 87 01 00 00    	jb     80323e <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8030b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8030bd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030c0:	0f 85 95 00 00 00    	jne    80315b <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8030c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030ca:	75 17                	jne    8030e3 <alloc_block_NF+0x24c>
  8030cc:	83 ec 04             	sub    $0x4,%esp
  8030cf:	68 3c 48 80 00       	push   $0x80483c
  8030d4:	68 fc 00 00 00       	push   $0xfc
  8030d9:	68 93 47 80 00       	push   $0x804793
  8030de:	e8 f4 d7 ff ff       	call   8008d7 <_panic>
  8030e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e6:	8b 00                	mov    (%eax),%eax
  8030e8:	85 c0                	test   %eax,%eax
  8030ea:	74 10                	je     8030fc <alloc_block_NF+0x265>
  8030ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ef:	8b 00                	mov    (%eax),%eax
  8030f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030f4:	8b 52 04             	mov    0x4(%edx),%edx
  8030f7:	89 50 04             	mov    %edx,0x4(%eax)
  8030fa:	eb 0b                	jmp    803107 <alloc_block_NF+0x270>
  8030fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ff:	8b 40 04             	mov    0x4(%eax),%eax
  803102:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803107:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310a:	8b 40 04             	mov    0x4(%eax),%eax
  80310d:	85 c0                	test   %eax,%eax
  80310f:	74 0f                	je     803120 <alloc_block_NF+0x289>
  803111:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803114:	8b 40 04             	mov    0x4(%eax),%eax
  803117:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80311a:	8b 12                	mov    (%edx),%edx
  80311c:	89 10                	mov    %edx,(%eax)
  80311e:	eb 0a                	jmp    80312a <alloc_block_NF+0x293>
  803120:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803123:	8b 00                	mov    (%eax),%eax
  803125:	a3 38 51 80 00       	mov    %eax,0x805138
  80312a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803133:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803136:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80313d:	a1 44 51 80 00       	mov    0x805144,%eax
  803142:	48                   	dec    %eax
  803143:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803148:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314b:	8b 40 08             	mov    0x8(%eax),%eax
  80314e:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  803153:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803156:	e9 07 03 00 00       	jmp    803462 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80315b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315e:	8b 40 0c             	mov    0xc(%eax),%eax
  803161:	3b 45 08             	cmp    0x8(%ebp),%eax
  803164:	0f 86 d4 00 00 00    	jbe    80323e <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80316a:	a1 48 51 80 00       	mov    0x805148,%eax
  80316f:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  803172:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803175:	8b 50 08             	mov    0x8(%eax),%edx
  803178:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80317b:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80317e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803181:	8b 55 08             	mov    0x8(%ebp),%edx
  803184:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803187:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80318b:	75 17                	jne    8031a4 <alloc_block_NF+0x30d>
  80318d:	83 ec 04             	sub    $0x4,%esp
  803190:	68 3c 48 80 00       	push   $0x80483c
  803195:	68 04 01 00 00       	push   $0x104
  80319a:	68 93 47 80 00       	push   $0x804793
  80319f:	e8 33 d7 ff ff       	call   8008d7 <_panic>
  8031a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a7:	8b 00                	mov    (%eax),%eax
  8031a9:	85 c0                	test   %eax,%eax
  8031ab:	74 10                	je     8031bd <alloc_block_NF+0x326>
  8031ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b0:	8b 00                	mov    (%eax),%eax
  8031b2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031b5:	8b 52 04             	mov    0x4(%edx),%edx
  8031b8:	89 50 04             	mov    %edx,0x4(%eax)
  8031bb:	eb 0b                	jmp    8031c8 <alloc_block_NF+0x331>
  8031bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c0:	8b 40 04             	mov    0x4(%eax),%eax
  8031c3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031cb:	8b 40 04             	mov    0x4(%eax),%eax
  8031ce:	85 c0                	test   %eax,%eax
  8031d0:	74 0f                	je     8031e1 <alloc_block_NF+0x34a>
  8031d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d5:	8b 40 04             	mov    0x4(%eax),%eax
  8031d8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031db:	8b 12                	mov    (%edx),%edx
  8031dd:	89 10                	mov    %edx,(%eax)
  8031df:	eb 0a                	jmp    8031eb <alloc_block_NF+0x354>
  8031e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e4:	8b 00                	mov    (%eax),%eax
  8031e6:	a3 48 51 80 00       	mov    %eax,0x805148
  8031eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031fe:	a1 54 51 80 00       	mov    0x805154,%eax
  803203:	48                   	dec    %eax
  803204:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803209:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80320c:	8b 40 08             	mov    0x8(%eax),%eax
  80320f:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  803214:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803217:	8b 50 08             	mov    0x8(%eax),%edx
  80321a:	8b 45 08             	mov    0x8(%ebp),%eax
  80321d:	01 c2                	add    %eax,%edx
  80321f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803222:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803225:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803228:	8b 40 0c             	mov    0xc(%eax),%eax
  80322b:	2b 45 08             	sub    0x8(%ebp),%eax
  80322e:	89 c2                	mov    %eax,%edx
  803230:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803233:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803236:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803239:	e9 24 02 00 00       	jmp    803462 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80323e:	a1 40 51 80 00       	mov    0x805140,%eax
  803243:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803246:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80324a:	74 07                	je     803253 <alloc_block_NF+0x3bc>
  80324c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324f:	8b 00                	mov    (%eax),%eax
  803251:	eb 05                	jmp    803258 <alloc_block_NF+0x3c1>
  803253:	b8 00 00 00 00       	mov    $0x0,%eax
  803258:	a3 40 51 80 00       	mov    %eax,0x805140
  80325d:	a1 40 51 80 00       	mov    0x805140,%eax
  803262:	85 c0                	test   %eax,%eax
  803264:	0f 85 2b fe ff ff    	jne    803095 <alloc_block_NF+0x1fe>
  80326a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80326e:	0f 85 21 fe ff ff    	jne    803095 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803274:	a1 38 51 80 00       	mov    0x805138,%eax
  803279:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80327c:	e9 ae 01 00 00       	jmp    80342f <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  803281:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803284:	8b 50 08             	mov    0x8(%eax),%edx
  803287:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80328c:	39 c2                	cmp    %eax,%edx
  80328e:	0f 83 93 01 00 00    	jae    803427 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  803294:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803297:	8b 40 0c             	mov    0xc(%eax),%eax
  80329a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80329d:	0f 82 84 01 00 00    	jb     803427 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  8032a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8032a9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032ac:	0f 85 95 00 00 00    	jne    803347 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8032b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032b6:	75 17                	jne    8032cf <alloc_block_NF+0x438>
  8032b8:	83 ec 04             	sub    $0x4,%esp
  8032bb:	68 3c 48 80 00       	push   $0x80483c
  8032c0:	68 14 01 00 00       	push   $0x114
  8032c5:	68 93 47 80 00       	push   $0x804793
  8032ca:	e8 08 d6 ff ff       	call   8008d7 <_panic>
  8032cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d2:	8b 00                	mov    (%eax),%eax
  8032d4:	85 c0                	test   %eax,%eax
  8032d6:	74 10                	je     8032e8 <alloc_block_NF+0x451>
  8032d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032db:	8b 00                	mov    (%eax),%eax
  8032dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032e0:	8b 52 04             	mov    0x4(%edx),%edx
  8032e3:	89 50 04             	mov    %edx,0x4(%eax)
  8032e6:	eb 0b                	jmp    8032f3 <alloc_block_NF+0x45c>
  8032e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032eb:	8b 40 04             	mov    0x4(%eax),%eax
  8032ee:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f6:	8b 40 04             	mov    0x4(%eax),%eax
  8032f9:	85 c0                	test   %eax,%eax
  8032fb:	74 0f                	je     80330c <alloc_block_NF+0x475>
  8032fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803300:	8b 40 04             	mov    0x4(%eax),%eax
  803303:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803306:	8b 12                	mov    (%edx),%edx
  803308:	89 10                	mov    %edx,(%eax)
  80330a:	eb 0a                	jmp    803316 <alloc_block_NF+0x47f>
  80330c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80330f:	8b 00                	mov    (%eax),%eax
  803311:	a3 38 51 80 00       	mov    %eax,0x805138
  803316:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803319:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80331f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803322:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803329:	a1 44 51 80 00       	mov    0x805144,%eax
  80332e:	48                   	dec    %eax
  80332f:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803334:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803337:	8b 40 08             	mov    0x8(%eax),%eax
  80333a:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  80333f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803342:	e9 1b 01 00 00       	jmp    803462 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803347:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80334a:	8b 40 0c             	mov    0xc(%eax),%eax
  80334d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803350:	0f 86 d1 00 00 00    	jbe    803427 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803356:	a1 48 51 80 00       	mov    0x805148,%eax
  80335b:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  80335e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803361:	8b 50 08             	mov    0x8(%eax),%edx
  803364:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803367:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80336a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80336d:	8b 55 08             	mov    0x8(%ebp),%edx
  803370:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803373:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803377:	75 17                	jne    803390 <alloc_block_NF+0x4f9>
  803379:	83 ec 04             	sub    $0x4,%esp
  80337c:	68 3c 48 80 00       	push   $0x80483c
  803381:	68 1c 01 00 00       	push   $0x11c
  803386:	68 93 47 80 00       	push   $0x804793
  80338b:	e8 47 d5 ff ff       	call   8008d7 <_panic>
  803390:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803393:	8b 00                	mov    (%eax),%eax
  803395:	85 c0                	test   %eax,%eax
  803397:	74 10                	je     8033a9 <alloc_block_NF+0x512>
  803399:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80339c:	8b 00                	mov    (%eax),%eax
  80339e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8033a1:	8b 52 04             	mov    0x4(%edx),%edx
  8033a4:	89 50 04             	mov    %edx,0x4(%eax)
  8033a7:	eb 0b                	jmp    8033b4 <alloc_block_NF+0x51d>
  8033a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033ac:	8b 40 04             	mov    0x4(%eax),%eax
  8033af:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033b7:	8b 40 04             	mov    0x4(%eax),%eax
  8033ba:	85 c0                	test   %eax,%eax
  8033bc:	74 0f                	je     8033cd <alloc_block_NF+0x536>
  8033be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033c1:	8b 40 04             	mov    0x4(%eax),%eax
  8033c4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8033c7:	8b 12                	mov    (%edx),%edx
  8033c9:	89 10                	mov    %edx,(%eax)
  8033cb:	eb 0a                	jmp    8033d7 <alloc_block_NF+0x540>
  8033cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033d0:	8b 00                	mov    (%eax),%eax
  8033d2:	a3 48 51 80 00       	mov    %eax,0x805148
  8033d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033ea:	a1 54 51 80 00       	mov    0x805154,%eax
  8033ef:	48                   	dec    %eax
  8033f0:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8033f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033f8:	8b 40 08             	mov    0x8(%eax),%eax
  8033fb:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  803400:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803403:	8b 50 08             	mov    0x8(%eax),%edx
  803406:	8b 45 08             	mov    0x8(%ebp),%eax
  803409:	01 c2                	add    %eax,%edx
  80340b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80340e:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803411:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803414:	8b 40 0c             	mov    0xc(%eax),%eax
  803417:	2b 45 08             	sub    0x8(%ebp),%eax
  80341a:	89 c2                	mov    %eax,%edx
  80341c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80341f:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803422:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803425:	eb 3b                	jmp    803462 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803427:	a1 40 51 80 00       	mov    0x805140,%eax
  80342c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80342f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803433:	74 07                	je     80343c <alloc_block_NF+0x5a5>
  803435:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803438:	8b 00                	mov    (%eax),%eax
  80343a:	eb 05                	jmp    803441 <alloc_block_NF+0x5aa>
  80343c:	b8 00 00 00 00       	mov    $0x0,%eax
  803441:	a3 40 51 80 00       	mov    %eax,0x805140
  803446:	a1 40 51 80 00       	mov    0x805140,%eax
  80344b:	85 c0                	test   %eax,%eax
  80344d:	0f 85 2e fe ff ff    	jne    803281 <alloc_block_NF+0x3ea>
  803453:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803457:	0f 85 24 fe ff ff    	jne    803281 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  80345d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803462:	c9                   	leave  
  803463:	c3                   	ret    

00803464 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803464:	55                   	push   %ebp
  803465:	89 e5                	mov    %esp,%ebp
  803467:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  80346a:	a1 38 51 80 00       	mov    0x805138,%eax
  80346f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  803472:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803477:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  80347a:	a1 38 51 80 00       	mov    0x805138,%eax
  80347f:	85 c0                	test   %eax,%eax
  803481:	74 14                	je     803497 <insert_sorted_with_merge_freeList+0x33>
  803483:	8b 45 08             	mov    0x8(%ebp),%eax
  803486:	8b 50 08             	mov    0x8(%eax),%edx
  803489:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80348c:	8b 40 08             	mov    0x8(%eax),%eax
  80348f:	39 c2                	cmp    %eax,%edx
  803491:	0f 87 9b 01 00 00    	ja     803632 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  803497:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80349b:	75 17                	jne    8034b4 <insert_sorted_with_merge_freeList+0x50>
  80349d:	83 ec 04             	sub    $0x4,%esp
  8034a0:	68 70 47 80 00       	push   $0x804770
  8034a5:	68 38 01 00 00       	push   $0x138
  8034aa:	68 93 47 80 00       	push   $0x804793
  8034af:	e8 23 d4 ff ff       	call   8008d7 <_panic>
  8034b4:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8034ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8034bd:	89 10                	mov    %edx,(%eax)
  8034bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c2:	8b 00                	mov    (%eax),%eax
  8034c4:	85 c0                	test   %eax,%eax
  8034c6:	74 0d                	je     8034d5 <insert_sorted_with_merge_freeList+0x71>
  8034c8:	a1 38 51 80 00       	mov    0x805138,%eax
  8034cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8034d0:	89 50 04             	mov    %edx,0x4(%eax)
  8034d3:	eb 08                	jmp    8034dd <insert_sorted_with_merge_freeList+0x79>
  8034d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e0:	a3 38 51 80 00       	mov    %eax,0x805138
  8034e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034ef:	a1 44 51 80 00       	mov    0x805144,%eax
  8034f4:	40                   	inc    %eax
  8034f5:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8034fa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8034fe:	0f 84 a8 06 00 00    	je     803bac <insert_sorted_with_merge_freeList+0x748>
  803504:	8b 45 08             	mov    0x8(%ebp),%eax
  803507:	8b 50 08             	mov    0x8(%eax),%edx
  80350a:	8b 45 08             	mov    0x8(%ebp),%eax
  80350d:	8b 40 0c             	mov    0xc(%eax),%eax
  803510:	01 c2                	add    %eax,%edx
  803512:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803515:	8b 40 08             	mov    0x8(%eax),%eax
  803518:	39 c2                	cmp    %eax,%edx
  80351a:	0f 85 8c 06 00 00    	jne    803bac <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  803520:	8b 45 08             	mov    0x8(%ebp),%eax
  803523:	8b 50 0c             	mov    0xc(%eax),%edx
  803526:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803529:	8b 40 0c             	mov    0xc(%eax),%eax
  80352c:	01 c2                	add    %eax,%edx
  80352e:	8b 45 08             	mov    0x8(%ebp),%eax
  803531:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803534:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803538:	75 17                	jne    803551 <insert_sorted_with_merge_freeList+0xed>
  80353a:	83 ec 04             	sub    $0x4,%esp
  80353d:	68 3c 48 80 00       	push   $0x80483c
  803542:	68 3c 01 00 00       	push   $0x13c
  803547:	68 93 47 80 00       	push   $0x804793
  80354c:	e8 86 d3 ff ff       	call   8008d7 <_panic>
  803551:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803554:	8b 00                	mov    (%eax),%eax
  803556:	85 c0                	test   %eax,%eax
  803558:	74 10                	je     80356a <insert_sorted_with_merge_freeList+0x106>
  80355a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80355d:	8b 00                	mov    (%eax),%eax
  80355f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803562:	8b 52 04             	mov    0x4(%edx),%edx
  803565:	89 50 04             	mov    %edx,0x4(%eax)
  803568:	eb 0b                	jmp    803575 <insert_sorted_with_merge_freeList+0x111>
  80356a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80356d:	8b 40 04             	mov    0x4(%eax),%eax
  803570:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803575:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803578:	8b 40 04             	mov    0x4(%eax),%eax
  80357b:	85 c0                	test   %eax,%eax
  80357d:	74 0f                	je     80358e <insert_sorted_with_merge_freeList+0x12a>
  80357f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803582:	8b 40 04             	mov    0x4(%eax),%eax
  803585:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803588:	8b 12                	mov    (%edx),%edx
  80358a:	89 10                	mov    %edx,(%eax)
  80358c:	eb 0a                	jmp    803598 <insert_sorted_with_merge_freeList+0x134>
  80358e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803591:	8b 00                	mov    (%eax),%eax
  803593:	a3 38 51 80 00       	mov    %eax,0x805138
  803598:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80359b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035a4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035ab:	a1 44 51 80 00       	mov    0x805144,%eax
  8035b0:	48                   	dec    %eax
  8035b1:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  8035b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035b9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  8035c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035c3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  8035ca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8035ce:	75 17                	jne    8035e7 <insert_sorted_with_merge_freeList+0x183>
  8035d0:	83 ec 04             	sub    $0x4,%esp
  8035d3:	68 70 47 80 00       	push   $0x804770
  8035d8:	68 3f 01 00 00       	push   $0x13f
  8035dd:	68 93 47 80 00       	push   $0x804793
  8035e2:	e8 f0 d2 ff ff       	call   8008d7 <_panic>
  8035e7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8035ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035f0:	89 10                	mov    %edx,(%eax)
  8035f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035f5:	8b 00                	mov    (%eax),%eax
  8035f7:	85 c0                	test   %eax,%eax
  8035f9:	74 0d                	je     803608 <insert_sorted_with_merge_freeList+0x1a4>
  8035fb:	a1 48 51 80 00       	mov    0x805148,%eax
  803600:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803603:	89 50 04             	mov    %edx,0x4(%eax)
  803606:	eb 08                	jmp    803610 <insert_sorted_with_merge_freeList+0x1ac>
  803608:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80360b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803610:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803613:	a3 48 51 80 00       	mov    %eax,0x805148
  803618:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80361b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803622:	a1 54 51 80 00       	mov    0x805154,%eax
  803627:	40                   	inc    %eax
  803628:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80362d:	e9 7a 05 00 00       	jmp    803bac <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803632:	8b 45 08             	mov    0x8(%ebp),%eax
  803635:	8b 50 08             	mov    0x8(%eax),%edx
  803638:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80363b:	8b 40 08             	mov    0x8(%eax),%eax
  80363e:	39 c2                	cmp    %eax,%edx
  803640:	0f 82 14 01 00 00    	jb     80375a <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803646:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803649:	8b 50 08             	mov    0x8(%eax),%edx
  80364c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80364f:	8b 40 0c             	mov    0xc(%eax),%eax
  803652:	01 c2                	add    %eax,%edx
  803654:	8b 45 08             	mov    0x8(%ebp),%eax
  803657:	8b 40 08             	mov    0x8(%eax),%eax
  80365a:	39 c2                	cmp    %eax,%edx
  80365c:	0f 85 90 00 00 00    	jne    8036f2 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803662:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803665:	8b 50 0c             	mov    0xc(%eax),%edx
  803668:	8b 45 08             	mov    0x8(%ebp),%eax
  80366b:	8b 40 0c             	mov    0xc(%eax),%eax
  80366e:	01 c2                	add    %eax,%edx
  803670:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803673:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803676:	8b 45 08             	mov    0x8(%ebp),%eax
  803679:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803680:	8b 45 08             	mov    0x8(%ebp),%eax
  803683:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80368a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80368e:	75 17                	jne    8036a7 <insert_sorted_with_merge_freeList+0x243>
  803690:	83 ec 04             	sub    $0x4,%esp
  803693:	68 70 47 80 00       	push   $0x804770
  803698:	68 49 01 00 00       	push   $0x149
  80369d:	68 93 47 80 00       	push   $0x804793
  8036a2:	e8 30 d2 ff ff       	call   8008d7 <_panic>
  8036a7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8036ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b0:	89 10                	mov    %edx,(%eax)
  8036b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b5:	8b 00                	mov    (%eax),%eax
  8036b7:	85 c0                	test   %eax,%eax
  8036b9:	74 0d                	je     8036c8 <insert_sorted_with_merge_freeList+0x264>
  8036bb:	a1 48 51 80 00       	mov    0x805148,%eax
  8036c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8036c3:	89 50 04             	mov    %edx,0x4(%eax)
  8036c6:	eb 08                	jmp    8036d0 <insert_sorted_with_merge_freeList+0x26c>
  8036c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036cb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d3:	a3 48 51 80 00       	mov    %eax,0x805148
  8036d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036db:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036e2:	a1 54 51 80 00       	mov    0x805154,%eax
  8036e7:	40                   	inc    %eax
  8036e8:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8036ed:	e9 bb 04 00 00       	jmp    803bad <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8036f2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036f6:	75 17                	jne    80370f <insert_sorted_with_merge_freeList+0x2ab>
  8036f8:	83 ec 04             	sub    $0x4,%esp
  8036fb:	68 e4 47 80 00       	push   $0x8047e4
  803700:	68 4c 01 00 00       	push   $0x14c
  803705:	68 93 47 80 00       	push   $0x804793
  80370a:	e8 c8 d1 ff ff       	call   8008d7 <_panic>
  80370f:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803715:	8b 45 08             	mov    0x8(%ebp),%eax
  803718:	89 50 04             	mov    %edx,0x4(%eax)
  80371b:	8b 45 08             	mov    0x8(%ebp),%eax
  80371e:	8b 40 04             	mov    0x4(%eax),%eax
  803721:	85 c0                	test   %eax,%eax
  803723:	74 0c                	je     803731 <insert_sorted_with_merge_freeList+0x2cd>
  803725:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80372a:	8b 55 08             	mov    0x8(%ebp),%edx
  80372d:	89 10                	mov    %edx,(%eax)
  80372f:	eb 08                	jmp    803739 <insert_sorted_with_merge_freeList+0x2d5>
  803731:	8b 45 08             	mov    0x8(%ebp),%eax
  803734:	a3 38 51 80 00       	mov    %eax,0x805138
  803739:	8b 45 08             	mov    0x8(%ebp),%eax
  80373c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803741:	8b 45 08             	mov    0x8(%ebp),%eax
  803744:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80374a:	a1 44 51 80 00       	mov    0x805144,%eax
  80374f:	40                   	inc    %eax
  803750:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803755:	e9 53 04 00 00       	jmp    803bad <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80375a:	a1 38 51 80 00       	mov    0x805138,%eax
  80375f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803762:	e9 15 04 00 00       	jmp    803b7c <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803767:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80376a:	8b 00                	mov    (%eax),%eax
  80376c:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  80376f:	8b 45 08             	mov    0x8(%ebp),%eax
  803772:	8b 50 08             	mov    0x8(%eax),%edx
  803775:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803778:	8b 40 08             	mov    0x8(%eax),%eax
  80377b:	39 c2                	cmp    %eax,%edx
  80377d:	0f 86 f1 03 00 00    	jbe    803b74 <insert_sorted_with_merge_freeList+0x710>
  803783:	8b 45 08             	mov    0x8(%ebp),%eax
  803786:	8b 50 08             	mov    0x8(%eax),%edx
  803789:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80378c:	8b 40 08             	mov    0x8(%eax),%eax
  80378f:	39 c2                	cmp    %eax,%edx
  803791:	0f 83 dd 03 00 00    	jae    803b74 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803797:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80379a:	8b 50 08             	mov    0x8(%eax),%edx
  80379d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037a0:	8b 40 0c             	mov    0xc(%eax),%eax
  8037a3:	01 c2                	add    %eax,%edx
  8037a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a8:	8b 40 08             	mov    0x8(%eax),%eax
  8037ab:	39 c2                	cmp    %eax,%edx
  8037ad:	0f 85 b9 01 00 00    	jne    80396c <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8037b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b6:	8b 50 08             	mov    0x8(%eax),%edx
  8037b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8037bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8037bf:	01 c2                	add    %eax,%edx
  8037c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037c4:	8b 40 08             	mov    0x8(%eax),%eax
  8037c7:	39 c2                	cmp    %eax,%edx
  8037c9:	0f 85 0d 01 00 00    	jne    8038dc <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8037cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037d2:	8b 50 0c             	mov    0xc(%eax),%edx
  8037d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8037db:	01 c2                	add    %eax,%edx
  8037dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037e0:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8037e3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8037e7:	75 17                	jne    803800 <insert_sorted_with_merge_freeList+0x39c>
  8037e9:	83 ec 04             	sub    $0x4,%esp
  8037ec:	68 3c 48 80 00       	push   $0x80483c
  8037f1:	68 5c 01 00 00       	push   $0x15c
  8037f6:	68 93 47 80 00       	push   $0x804793
  8037fb:	e8 d7 d0 ff ff       	call   8008d7 <_panic>
  803800:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803803:	8b 00                	mov    (%eax),%eax
  803805:	85 c0                	test   %eax,%eax
  803807:	74 10                	je     803819 <insert_sorted_with_merge_freeList+0x3b5>
  803809:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80380c:	8b 00                	mov    (%eax),%eax
  80380e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803811:	8b 52 04             	mov    0x4(%edx),%edx
  803814:	89 50 04             	mov    %edx,0x4(%eax)
  803817:	eb 0b                	jmp    803824 <insert_sorted_with_merge_freeList+0x3c0>
  803819:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80381c:	8b 40 04             	mov    0x4(%eax),%eax
  80381f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803824:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803827:	8b 40 04             	mov    0x4(%eax),%eax
  80382a:	85 c0                	test   %eax,%eax
  80382c:	74 0f                	je     80383d <insert_sorted_with_merge_freeList+0x3d9>
  80382e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803831:	8b 40 04             	mov    0x4(%eax),%eax
  803834:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803837:	8b 12                	mov    (%edx),%edx
  803839:	89 10                	mov    %edx,(%eax)
  80383b:	eb 0a                	jmp    803847 <insert_sorted_with_merge_freeList+0x3e3>
  80383d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803840:	8b 00                	mov    (%eax),%eax
  803842:	a3 38 51 80 00       	mov    %eax,0x805138
  803847:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80384a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803850:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803853:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80385a:	a1 44 51 80 00       	mov    0x805144,%eax
  80385f:	48                   	dec    %eax
  803860:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803865:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803868:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  80386f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803872:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803879:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80387d:	75 17                	jne    803896 <insert_sorted_with_merge_freeList+0x432>
  80387f:	83 ec 04             	sub    $0x4,%esp
  803882:	68 70 47 80 00       	push   $0x804770
  803887:	68 5f 01 00 00       	push   $0x15f
  80388c:	68 93 47 80 00       	push   $0x804793
  803891:	e8 41 d0 ff ff       	call   8008d7 <_panic>
  803896:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80389c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80389f:	89 10                	mov    %edx,(%eax)
  8038a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038a4:	8b 00                	mov    (%eax),%eax
  8038a6:	85 c0                	test   %eax,%eax
  8038a8:	74 0d                	je     8038b7 <insert_sorted_with_merge_freeList+0x453>
  8038aa:	a1 48 51 80 00       	mov    0x805148,%eax
  8038af:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038b2:	89 50 04             	mov    %edx,0x4(%eax)
  8038b5:	eb 08                	jmp    8038bf <insert_sorted_with_merge_freeList+0x45b>
  8038b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038ba:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8038bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038c2:	a3 48 51 80 00       	mov    %eax,0x805148
  8038c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038ca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038d1:	a1 54 51 80 00       	mov    0x805154,%eax
  8038d6:	40                   	inc    %eax
  8038d7:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8038dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038df:	8b 50 0c             	mov    0xc(%eax),%edx
  8038e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8038e8:	01 c2                	add    %eax,%edx
  8038ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038ed:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8038f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8038fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8038fd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803904:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803908:	75 17                	jne    803921 <insert_sorted_with_merge_freeList+0x4bd>
  80390a:	83 ec 04             	sub    $0x4,%esp
  80390d:	68 70 47 80 00       	push   $0x804770
  803912:	68 64 01 00 00       	push   $0x164
  803917:	68 93 47 80 00       	push   $0x804793
  80391c:	e8 b6 cf ff ff       	call   8008d7 <_panic>
  803921:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803927:	8b 45 08             	mov    0x8(%ebp),%eax
  80392a:	89 10                	mov    %edx,(%eax)
  80392c:	8b 45 08             	mov    0x8(%ebp),%eax
  80392f:	8b 00                	mov    (%eax),%eax
  803931:	85 c0                	test   %eax,%eax
  803933:	74 0d                	je     803942 <insert_sorted_with_merge_freeList+0x4de>
  803935:	a1 48 51 80 00       	mov    0x805148,%eax
  80393a:	8b 55 08             	mov    0x8(%ebp),%edx
  80393d:	89 50 04             	mov    %edx,0x4(%eax)
  803940:	eb 08                	jmp    80394a <insert_sorted_with_merge_freeList+0x4e6>
  803942:	8b 45 08             	mov    0x8(%ebp),%eax
  803945:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80394a:	8b 45 08             	mov    0x8(%ebp),%eax
  80394d:	a3 48 51 80 00       	mov    %eax,0x805148
  803952:	8b 45 08             	mov    0x8(%ebp),%eax
  803955:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80395c:	a1 54 51 80 00       	mov    0x805154,%eax
  803961:	40                   	inc    %eax
  803962:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803967:	e9 41 02 00 00       	jmp    803bad <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80396c:	8b 45 08             	mov    0x8(%ebp),%eax
  80396f:	8b 50 08             	mov    0x8(%eax),%edx
  803972:	8b 45 08             	mov    0x8(%ebp),%eax
  803975:	8b 40 0c             	mov    0xc(%eax),%eax
  803978:	01 c2                	add    %eax,%edx
  80397a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80397d:	8b 40 08             	mov    0x8(%eax),%eax
  803980:	39 c2                	cmp    %eax,%edx
  803982:	0f 85 7c 01 00 00    	jne    803b04 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803988:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80398c:	74 06                	je     803994 <insert_sorted_with_merge_freeList+0x530>
  80398e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803992:	75 17                	jne    8039ab <insert_sorted_with_merge_freeList+0x547>
  803994:	83 ec 04             	sub    $0x4,%esp
  803997:	68 ac 47 80 00       	push   $0x8047ac
  80399c:	68 69 01 00 00       	push   $0x169
  8039a1:	68 93 47 80 00       	push   $0x804793
  8039a6:	e8 2c cf ff ff       	call   8008d7 <_panic>
  8039ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039ae:	8b 50 04             	mov    0x4(%eax),%edx
  8039b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8039b4:	89 50 04             	mov    %edx,0x4(%eax)
  8039b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ba:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039bd:	89 10                	mov    %edx,(%eax)
  8039bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039c2:	8b 40 04             	mov    0x4(%eax),%eax
  8039c5:	85 c0                	test   %eax,%eax
  8039c7:	74 0d                	je     8039d6 <insert_sorted_with_merge_freeList+0x572>
  8039c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039cc:	8b 40 04             	mov    0x4(%eax),%eax
  8039cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8039d2:	89 10                	mov    %edx,(%eax)
  8039d4:	eb 08                	jmp    8039de <insert_sorted_with_merge_freeList+0x57a>
  8039d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8039d9:	a3 38 51 80 00       	mov    %eax,0x805138
  8039de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8039e4:	89 50 04             	mov    %edx,0x4(%eax)
  8039e7:	a1 44 51 80 00       	mov    0x805144,%eax
  8039ec:	40                   	inc    %eax
  8039ed:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8039f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8039f5:	8b 50 0c             	mov    0xc(%eax),%edx
  8039f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039fb:	8b 40 0c             	mov    0xc(%eax),%eax
  8039fe:	01 c2                	add    %eax,%edx
  803a00:	8b 45 08             	mov    0x8(%ebp),%eax
  803a03:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803a06:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803a0a:	75 17                	jne    803a23 <insert_sorted_with_merge_freeList+0x5bf>
  803a0c:	83 ec 04             	sub    $0x4,%esp
  803a0f:	68 3c 48 80 00       	push   $0x80483c
  803a14:	68 6b 01 00 00       	push   $0x16b
  803a19:	68 93 47 80 00       	push   $0x804793
  803a1e:	e8 b4 ce ff ff       	call   8008d7 <_panic>
  803a23:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a26:	8b 00                	mov    (%eax),%eax
  803a28:	85 c0                	test   %eax,%eax
  803a2a:	74 10                	je     803a3c <insert_sorted_with_merge_freeList+0x5d8>
  803a2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a2f:	8b 00                	mov    (%eax),%eax
  803a31:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a34:	8b 52 04             	mov    0x4(%edx),%edx
  803a37:	89 50 04             	mov    %edx,0x4(%eax)
  803a3a:	eb 0b                	jmp    803a47 <insert_sorted_with_merge_freeList+0x5e3>
  803a3c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a3f:	8b 40 04             	mov    0x4(%eax),%eax
  803a42:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803a47:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a4a:	8b 40 04             	mov    0x4(%eax),%eax
  803a4d:	85 c0                	test   %eax,%eax
  803a4f:	74 0f                	je     803a60 <insert_sorted_with_merge_freeList+0x5fc>
  803a51:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a54:	8b 40 04             	mov    0x4(%eax),%eax
  803a57:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a5a:	8b 12                	mov    (%edx),%edx
  803a5c:	89 10                	mov    %edx,(%eax)
  803a5e:	eb 0a                	jmp    803a6a <insert_sorted_with_merge_freeList+0x606>
  803a60:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a63:	8b 00                	mov    (%eax),%eax
  803a65:	a3 38 51 80 00       	mov    %eax,0x805138
  803a6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a6d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a73:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a76:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a7d:	a1 44 51 80 00       	mov    0x805144,%eax
  803a82:	48                   	dec    %eax
  803a83:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803a88:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a8b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803a92:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a95:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803a9c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803aa0:	75 17                	jne    803ab9 <insert_sorted_with_merge_freeList+0x655>
  803aa2:	83 ec 04             	sub    $0x4,%esp
  803aa5:	68 70 47 80 00       	push   $0x804770
  803aaa:	68 6e 01 00 00       	push   $0x16e
  803aaf:	68 93 47 80 00       	push   $0x804793
  803ab4:	e8 1e ce ff ff       	call   8008d7 <_panic>
  803ab9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803abf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ac2:	89 10                	mov    %edx,(%eax)
  803ac4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ac7:	8b 00                	mov    (%eax),%eax
  803ac9:	85 c0                	test   %eax,%eax
  803acb:	74 0d                	je     803ada <insert_sorted_with_merge_freeList+0x676>
  803acd:	a1 48 51 80 00       	mov    0x805148,%eax
  803ad2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803ad5:	89 50 04             	mov    %edx,0x4(%eax)
  803ad8:	eb 08                	jmp    803ae2 <insert_sorted_with_merge_freeList+0x67e>
  803ada:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803add:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803ae2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ae5:	a3 48 51 80 00       	mov    %eax,0x805148
  803aea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803aed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803af4:	a1 54 51 80 00       	mov    0x805154,%eax
  803af9:	40                   	inc    %eax
  803afa:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803aff:	e9 a9 00 00 00       	jmp    803bad <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803b04:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b08:	74 06                	je     803b10 <insert_sorted_with_merge_freeList+0x6ac>
  803b0a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b0e:	75 17                	jne    803b27 <insert_sorted_with_merge_freeList+0x6c3>
  803b10:	83 ec 04             	sub    $0x4,%esp
  803b13:	68 08 48 80 00       	push   $0x804808
  803b18:	68 73 01 00 00       	push   $0x173
  803b1d:	68 93 47 80 00       	push   $0x804793
  803b22:	e8 b0 cd ff ff       	call   8008d7 <_panic>
  803b27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b2a:	8b 10                	mov    (%eax),%edx
  803b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  803b2f:	89 10                	mov    %edx,(%eax)
  803b31:	8b 45 08             	mov    0x8(%ebp),%eax
  803b34:	8b 00                	mov    (%eax),%eax
  803b36:	85 c0                	test   %eax,%eax
  803b38:	74 0b                	je     803b45 <insert_sorted_with_merge_freeList+0x6e1>
  803b3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b3d:	8b 00                	mov    (%eax),%eax
  803b3f:	8b 55 08             	mov    0x8(%ebp),%edx
  803b42:	89 50 04             	mov    %edx,0x4(%eax)
  803b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b48:	8b 55 08             	mov    0x8(%ebp),%edx
  803b4b:	89 10                	mov    %edx,(%eax)
  803b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  803b50:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b53:	89 50 04             	mov    %edx,0x4(%eax)
  803b56:	8b 45 08             	mov    0x8(%ebp),%eax
  803b59:	8b 00                	mov    (%eax),%eax
  803b5b:	85 c0                	test   %eax,%eax
  803b5d:	75 08                	jne    803b67 <insert_sorted_with_merge_freeList+0x703>
  803b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  803b62:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803b67:	a1 44 51 80 00       	mov    0x805144,%eax
  803b6c:	40                   	inc    %eax
  803b6d:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803b72:	eb 39                	jmp    803bad <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803b74:	a1 40 51 80 00       	mov    0x805140,%eax
  803b79:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803b7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b80:	74 07                	je     803b89 <insert_sorted_with_merge_freeList+0x725>
  803b82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b85:	8b 00                	mov    (%eax),%eax
  803b87:	eb 05                	jmp    803b8e <insert_sorted_with_merge_freeList+0x72a>
  803b89:	b8 00 00 00 00       	mov    $0x0,%eax
  803b8e:	a3 40 51 80 00       	mov    %eax,0x805140
  803b93:	a1 40 51 80 00       	mov    0x805140,%eax
  803b98:	85 c0                	test   %eax,%eax
  803b9a:	0f 85 c7 fb ff ff    	jne    803767 <insert_sorted_with_merge_freeList+0x303>
  803ba0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ba4:	0f 85 bd fb ff ff    	jne    803767 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803baa:	eb 01                	jmp    803bad <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803bac:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803bad:	90                   	nop
  803bae:	c9                   	leave  
  803baf:	c3                   	ret    

00803bb0 <__udivdi3>:
  803bb0:	55                   	push   %ebp
  803bb1:	57                   	push   %edi
  803bb2:	56                   	push   %esi
  803bb3:	53                   	push   %ebx
  803bb4:	83 ec 1c             	sub    $0x1c,%esp
  803bb7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803bbb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803bbf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803bc3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803bc7:	89 ca                	mov    %ecx,%edx
  803bc9:	89 f8                	mov    %edi,%eax
  803bcb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803bcf:	85 f6                	test   %esi,%esi
  803bd1:	75 2d                	jne    803c00 <__udivdi3+0x50>
  803bd3:	39 cf                	cmp    %ecx,%edi
  803bd5:	77 65                	ja     803c3c <__udivdi3+0x8c>
  803bd7:	89 fd                	mov    %edi,%ebp
  803bd9:	85 ff                	test   %edi,%edi
  803bdb:	75 0b                	jne    803be8 <__udivdi3+0x38>
  803bdd:	b8 01 00 00 00       	mov    $0x1,%eax
  803be2:	31 d2                	xor    %edx,%edx
  803be4:	f7 f7                	div    %edi
  803be6:	89 c5                	mov    %eax,%ebp
  803be8:	31 d2                	xor    %edx,%edx
  803bea:	89 c8                	mov    %ecx,%eax
  803bec:	f7 f5                	div    %ebp
  803bee:	89 c1                	mov    %eax,%ecx
  803bf0:	89 d8                	mov    %ebx,%eax
  803bf2:	f7 f5                	div    %ebp
  803bf4:	89 cf                	mov    %ecx,%edi
  803bf6:	89 fa                	mov    %edi,%edx
  803bf8:	83 c4 1c             	add    $0x1c,%esp
  803bfb:	5b                   	pop    %ebx
  803bfc:	5e                   	pop    %esi
  803bfd:	5f                   	pop    %edi
  803bfe:	5d                   	pop    %ebp
  803bff:	c3                   	ret    
  803c00:	39 ce                	cmp    %ecx,%esi
  803c02:	77 28                	ja     803c2c <__udivdi3+0x7c>
  803c04:	0f bd fe             	bsr    %esi,%edi
  803c07:	83 f7 1f             	xor    $0x1f,%edi
  803c0a:	75 40                	jne    803c4c <__udivdi3+0x9c>
  803c0c:	39 ce                	cmp    %ecx,%esi
  803c0e:	72 0a                	jb     803c1a <__udivdi3+0x6a>
  803c10:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803c14:	0f 87 9e 00 00 00    	ja     803cb8 <__udivdi3+0x108>
  803c1a:	b8 01 00 00 00       	mov    $0x1,%eax
  803c1f:	89 fa                	mov    %edi,%edx
  803c21:	83 c4 1c             	add    $0x1c,%esp
  803c24:	5b                   	pop    %ebx
  803c25:	5e                   	pop    %esi
  803c26:	5f                   	pop    %edi
  803c27:	5d                   	pop    %ebp
  803c28:	c3                   	ret    
  803c29:	8d 76 00             	lea    0x0(%esi),%esi
  803c2c:	31 ff                	xor    %edi,%edi
  803c2e:	31 c0                	xor    %eax,%eax
  803c30:	89 fa                	mov    %edi,%edx
  803c32:	83 c4 1c             	add    $0x1c,%esp
  803c35:	5b                   	pop    %ebx
  803c36:	5e                   	pop    %esi
  803c37:	5f                   	pop    %edi
  803c38:	5d                   	pop    %ebp
  803c39:	c3                   	ret    
  803c3a:	66 90                	xchg   %ax,%ax
  803c3c:	89 d8                	mov    %ebx,%eax
  803c3e:	f7 f7                	div    %edi
  803c40:	31 ff                	xor    %edi,%edi
  803c42:	89 fa                	mov    %edi,%edx
  803c44:	83 c4 1c             	add    $0x1c,%esp
  803c47:	5b                   	pop    %ebx
  803c48:	5e                   	pop    %esi
  803c49:	5f                   	pop    %edi
  803c4a:	5d                   	pop    %ebp
  803c4b:	c3                   	ret    
  803c4c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803c51:	89 eb                	mov    %ebp,%ebx
  803c53:	29 fb                	sub    %edi,%ebx
  803c55:	89 f9                	mov    %edi,%ecx
  803c57:	d3 e6                	shl    %cl,%esi
  803c59:	89 c5                	mov    %eax,%ebp
  803c5b:	88 d9                	mov    %bl,%cl
  803c5d:	d3 ed                	shr    %cl,%ebp
  803c5f:	89 e9                	mov    %ebp,%ecx
  803c61:	09 f1                	or     %esi,%ecx
  803c63:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803c67:	89 f9                	mov    %edi,%ecx
  803c69:	d3 e0                	shl    %cl,%eax
  803c6b:	89 c5                	mov    %eax,%ebp
  803c6d:	89 d6                	mov    %edx,%esi
  803c6f:	88 d9                	mov    %bl,%cl
  803c71:	d3 ee                	shr    %cl,%esi
  803c73:	89 f9                	mov    %edi,%ecx
  803c75:	d3 e2                	shl    %cl,%edx
  803c77:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c7b:	88 d9                	mov    %bl,%cl
  803c7d:	d3 e8                	shr    %cl,%eax
  803c7f:	09 c2                	or     %eax,%edx
  803c81:	89 d0                	mov    %edx,%eax
  803c83:	89 f2                	mov    %esi,%edx
  803c85:	f7 74 24 0c          	divl   0xc(%esp)
  803c89:	89 d6                	mov    %edx,%esi
  803c8b:	89 c3                	mov    %eax,%ebx
  803c8d:	f7 e5                	mul    %ebp
  803c8f:	39 d6                	cmp    %edx,%esi
  803c91:	72 19                	jb     803cac <__udivdi3+0xfc>
  803c93:	74 0b                	je     803ca0 <__udivdi3+0xf0>
  803c95:	89 d8                	mov    %ebx,%eax
  803c97:	31 ff                	xor    %edi,%edi
  803c99:	e9 58 ff ff ff       	jmp    803bf6 <__udivdi3+0x46>
  803c9e:	66 90                	xchg   %ax,%ax
  803ca0:	8b 54 24 08          	mov    0x8(%esp),%edx
  803ca4:	89 f9                	mov    %edi,%ecx
  803ca6:	d3 e2                	shl    %cl,%edx
  803ca8:	39 c2                	cmp    %eax,%edx
  803caa:	73 e9                	jae    803c95 <__udivdi3+0xe5>
  803cac:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803caf:	31 ff                	xor    %edi,%edi
  803cb1:	e9 40 ff ff ff       	jmp    803bf6 <__udivdi3+0x46>
  803cb6:	66 90                	xchg   %ax,%ax
  803cb8:	31 c0                	xor    %eax,%eax
  803cba:	e9 37 ff ff ff       	jmp    803bf6 <__udivdi3+0x46>
  803cbf:	90                   	nop

00803cc0 <__umoddi3>:
  803cc0:	55                   	push   %ebp
  803cc1:	57                   	push   %edi
  803cc2:	56                   	push   %esi
  803cc3:	53                   	push   %ebx
  803cc4:	83 ec 1c             	sub    $0x1c,%esp
  803cc7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803ccb:	8b 74 24 34          	mov    0x34(%esp),%esi
  803ccf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803cd3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803cd7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803cdb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803cdf:	89 f3                	mov    %esi,%ebx
  803ce1:	89 fa                	mov    %edi,%edx
  803ce3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ce7:	89 34 24             	mov    %esi,(%esp)
  803cea:	85 c0                	test   %eax,%eax
  803cec:	75 1a                	jne    803d08 <__umoddi3+0x48>
  803cee:	39 f7                	cmp    %esi,%edi
  803cf0:	0f 86 a2 00 00 00    	jbe    803d98 <__umoddi3+0xd8>
  803cf6:	89 c8                	mov    %ecx,%eax
  803cf8:	89 f2                	mov    %esi,%edx
  803cfa:	f7 f7                	div    %edi
  803cfc:	89 d0                	mov    %edx,%eax
  803cfe:	31 d2                	xor    %edx,%edx
  803d00:	83 c4 1c             	add    $0x1c,%esp
  803d03:	5b                   	pop    %ebx
  803d04:	5e                   	pop    %esi
  803d05:	5f                   	pop    %edi
  803d06:	5d                   	pop    %ebp
  803d07:	c3                   	ret    
  803d08:	39 f0                	cmp    %esi,%eax
  803d0a:	0f 87 ac 00 00 00    	ja     803dbc <__umoddi3+0xfc>
  803d10:	0f bd e8             	bsr    %eax,%ebp
  803d13:	83 f5 1f             	xor    $0x1f,%ebp
  803d16:	0f 84 ac 00 00 00    	je     803dc8 <__umoddi3+0x108>
  803d1c:	bf 20 00 00 00       	mov    $0x20,%edi
  803d21:	29 ef                	sub    %ebp,%edi
  803d23:	89 fe                	mov    %edi,%esi
  803d25:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803d29:	89 e9                	mov    %ebp,%ecx
  803d2b:	d3 e0                	shl    %cl,%eax
  803d2d:	89 d7                	mov    %edx,%edi
  803d2f:	89 f1                	mov    %esi,%ecx
  803d31:	d3 ef                	shr    %cl,%edi
  803d33:	09 c7                	or     %eax,%edi
  803d35:	89 e9                	mov    %ebp,%ecx
  803d37:	d3 e2                	shl    %cl,%edx
  803d39:	89 14 24             	mov    %edx,(%esp)
  803d3c:	89 d8                	mov    %ebx,%eax
  803d3e:	d3 e0                	shl    %cl,%eax
  803d40:	89 c2                	mov    %eax,%edx
  803d42:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d46:	d3 e0                	shl    %cl,%eax
  803d48:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d4c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d50:	89 f1                	mov    %esi,%ecx
  803d52:	d3 e8                	shr    %cl,%eax
  803d54:	09 d0                	or     %edx,%eax
  803d56:	d3 eb                	shr    %cl,%ebx
  803d58:	89 da                	mov    %ebx,%edx
  803d5a:	f7 f7                	div    %edi
  803d5c:	89 d3                	mov    %edx,%ebx
  803d5e:	f7 24 24             	mull   (%esp)
  803d61:	89 c6                	mov    %eax,%esi
  803d63:	89 d1                	mov    %edx,%ecx
  803d65:	39 d3                	cmp    %edx,%ebx
  803d67:	0f 82 87 00 00 00    	jb     803df4 <__umoddi3+0x134>
  803d6d:	0f 84 91 00 00 00    	je     803e04 <__umoddi3+0x144>
  803d73:	8b 54 24 04          	mov    0x4(%esp),%edx
  803d77:	29 f2                	sub    %esi,%edx
  803d79:	19 cb                	sbb    %ecx,%ebx
  803d7b:	89 d8                	mov    %ebx,%eax
  803d7d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803d81:	d3 e0                	shl    %cl,%eax
  803d83:	89 e9                	mov    %ebp,%ecx
  803d85:	d3 ea                	shr    %cl,%edx
  803d87:	09 d0                	or     %edx,%eax
  803d89:	89 e9                	mov    %ebp,%ecx
  803d8b:	d3 eb                	shr    %cl,%ebx
  803d8d:	89 da                	mov    %ebx,%edx
  803d8f:	83 c4 1c             	add    $0x1c,%esp
  803d92:	5b                   	pop    %ebx
  803d93:	5e                   	pop    %esi
  803d94:	5f                   	pop    %edi
  803d95:	5d                   	pop    %ebp
  803d96:	c3                   	ret    
  803d97:	90                   	nop
  803d98:	89 fd                	mov    %edi,%ebp
  803d9a:	85 ff                	test   %edi,%edi
  803d9c:	75 0b                	jne    803da9 <__umoddi3+0xe9>
  803d9e:	b8 01 00 00 00       	mov    $0x1,%eax
  803da3:	31 d2                	xor    %edx,%edx
  803da5:	f7 f7                	div    %edi
  803da7:	89 c5                	mov    %eax,%ebp
  803da9:	89 f0                	mov    %esi,%eax
  803dab:	31 d2                	xor    %edx,%edx
  803dad:	f7 f5                	div    %ebp
  803daf:	89 c8                	mov    %ecx,%eax
  803db1:	f7 f5                	div    %ebp
  803db3:	89 d0                	mov    %edx,%eax
  803db5:	e9 44 ff ff ff       	jmp    803cfe <__umoddi3+0x3e>
  803dba:	66 90                	xchg   %ax,%ax
  803dbc:	89 c8                	mov    %ecx,%eax
  803dbe:	89 f2                	mov    %esi,%edx
  803dc0:	83 c4 1c             	add    $0x1c,%esp
  803dc3:	5b                   	pop    %ebx
  803dc4:	5e                   	pop    %esi
  803dc5:	5f                   	pop    %edi
  803dc6:	5d                   	pop    %ebp
  803dc7:	c3                   	ret    
  803dc8:	3b 04 24             	cmp    (%esp),%eax
  803dcb:	72 06                	jb     803dd3 <__umoddi3+0x113>
  803dcd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803dd1:	77 0f                	ja     803de2 <__umoddi3+0x122>
  803dd3:	89 f2                	mov    %esi,%edx
  803dd5:	29 f9                	sub    %edi,%ecx
  803dd7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803ddb:	89 14 24             	mov    %edx,(%esp)
  803dde:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803de2:	8b 44 24 04          	mov    0x4(%esp),%eax
  803de6:	8b 14 24             	mov    (%esp),%edx
  803de9:	83 c4 1c             	add    $0x1c,%esp
  803dec:	5b                   	pop    %ebx
  803ded:	5e                   	pop    %esi
  803dee:	5f                   	pop    %edi
  803def:	5d                   	pop    %ebp
  803df0:	c3                   	ret    
  803df1:	8d 76 00             	lea    0x0(%esi),%esi
  803df4:	2b 04 24             	sub    (%esp),%eax
  803df7:	19 fa                	sbb    %edi,%edx
  803df9:	89 d1                	mov    %edx,%ecx
  803dfb:	89 c6                	mov    %eax,%esi
  803dfd:	e9 71 ff ff ff       	jmp    803d73 <__umoddi3+0xb3>
  803e02:	66 90                	xchg   %ax,%ax
  803e04:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803e08:	72 ea                	jb     803df4 <__umoddi3+0x134>
  803e0a:	89 d9                	mov    %ebx,%ecx
  803e0c:	e9 62 ff ff ff       	jmp    803d73 <__umoddi3+0xb3>
