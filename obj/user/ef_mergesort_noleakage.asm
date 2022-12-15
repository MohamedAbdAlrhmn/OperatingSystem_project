
obj/user/ef_mergesort_noleakage:     file format elf32-i386


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
  800031:	e8 81 07 00 00       	call   8007b7 <libmain>
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
  800041:	e8 3d 1f 00 00       	call   801f83 <sys_disable_interrupt>

		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 c0 3c 80 00       	push   $0x803cc0
  80004e:	e8 54 0b 00 00       	call   800ba7 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 c2 3c 80 00       	push   $0x803cc2
  80005e:	e8 44 0b 00 00       	call   800ba7 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 d8 3c 80 00       	push   $0x803cd8
  80006e:	e8 34 0b 00 00       	call   800ba7 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 c2 3c 80 00       	push   $0x803cc2
  80007e:	e8 24 0b 00 00       	call   800ba7 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 c0 3c 80 00       	push   $0x803cc0
  80008e:	e8 14 0b 00 00       	call   800ba7 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
		//readline("Enter the number of elements: ", Line);
		cprintf("Enter the number of elements: ");
  800096:	83 ec 0c             	sub    $0xc,%esp
  800099:	68 f0 3c 80 00       	push   $0x803cf0
  80009e:	e8 04 0b 00 00       	call   800ba7 <cprintf>
  8000a3:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = 2000 ;
  8000a6:	c7 45 f0 d0 07 00 00 	movl   $0x7d0,-0x10(%ebp)
		cprintf("%d\n", NumOfElements) ;
  8000ad:	83 ec 08             	sub    $0x8,%esp
  8000b0:	ff 75 f0             	pushl  -0x10(%ebp)
  8000b3:	68 0f 3d 80 00       	push   $0x803d0f
  8000b8:	e8 ea 0a 00 00       	call   800ba7 <cprintf>
  8000bd:	83 c4 10             	add    $0x10,%esp

		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c3:	c1 e0 02             	shl    $0x2,%eax
  8000c6:	83 ec 0c             	sub    $0xc,%esp
  8000c9:	50                   	push   %eax
  8000ca:	e8 60 1a 00 00       	call   801b2f <malloc>
  8000cf:	83 c4 10             	add    $0x10,%esp
  8000d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000d5:	83 ec 0c             	sub    $0xc,%esp
  8000d8:	68 14 3d 80 00       	push   $0x803d14
  8000dd:	e8 c5 0a 00 00       	call   800ba7 <cprintf>
  8000e2:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	68 36 3d 80 00       	push   $0x803d36
  8000ed:	e8 b5 0a 00 00       	call   800ba7 <cprintf>
  8000f2:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000f5:	83 ec 0c             	sub    $0xc,%esp
  8000f8:	68 44 3d 80 00       	push   $0x803d44
  8000fd:	e8 a5 0a 00 00       	call   800ba7 <cprintf>
  800102:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  800105:	83 ec 0c             	sub    $0xc,%esp
  800108:	68 53 3d 80 00       	push   $0x803d53
  80010d:	e8 95 0a 00 00       	call   800ba7 <cprintf>
  800112:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800115:	83 ec 0c             	sub    $0xc,%esp
  800118:	68 63 3d 80 00       	push   $0x803d63
  80011d:	e8 85 0a 00 00       	call   800ba7 <cprintf>
  800122:	83 c4 10             	add    $0x10,%esp
			//Chose = getchar() ;
			Chose = 'a';
  800125:	c6 45 f7 61          	movb   $0x61,-0x9(%ebp)
			cputchar(Chose);
  800129:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80012d:	83 ec 0c             	sub    $0xc,%esp
  800130:	50                   	push   %eax
  800131:	e8 e1 05 00 00       	call   800717 <cputchar>
  800136:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800139:	83 ec 0c             	sub    $0xc,%esp
  80013c:	6a 0a                	push   $0xa
  80013e:	e8 d4 05 00 00       	call   800717 <cputchar>
  800143:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800146:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  80014a:	74 0c                	je     800158 <_main+0x120>
  80014c:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  800150:	74 06                	je     800158 <_main+0x120>
  800152:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800156:	75 bd                	jne    800115 <_main+0xdd>

		//2012: lock the interrupt
		sys_enable_interrupt();
  800158:	e8 40 1e 00 00       	call   801f9d <sys_enable_interrupt>

		int  i ;
		switch (Chose)
  80015d:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800161:	83 f8 62             	cmp    $0x62,%eax
  800164:	74 1d                	je     800183 <_main+0x14b>
  800166:	83 f8 63             	cmp    $0x63,%eax
  800169:	74 2b                	je     800196 <_main+0x15e>
  80016b:	83 f8 61             	cmp    $0x61,%eax
  80016e:	75 39                	jne    8001a9 <_main+0x171>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  800170:	83 ec 08             	sub    $0x8,%esp
  800173:	ff 75 f0             	pushl  -0x10(%ebp)
  800176:	ff 75 ec             	pushl  -0x14(%ebp)
  800179:	e8 f0 01 00 00       	call   80036e <InitializeAscending>
  80017e:	83 c4 10             	add    $0x10,%esp
			break ;
  800181:	eb 37                	jmp    8001ba <_main+0x182>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  800183:	83 ec 08             	sub    $0x8,%esp
  800186:	ff 75 f0             	pushl  -0x10(%ebp)
  800189:	ff 75 ec             	pushl  -0x14(%ebp)
  80018c:	e8 0e 02 00 00       	call   80039f <InitializeDescending>
  800191:	83 c4 10             	add    $0x10,%esp
			break ;
  800194:	eb 24                	jmp    8001ba <_main+0x182>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  800196:	83 ec 08             	sub    $0x8,%esp
  800199:	ff 75 f0             	pushl  -0x10(%ebp)
  80019c:	ff 75 ec             	pushl  -0x14(%ebp)
  80019f:	e8 30 02 00 00       	call   8003d4 <InitializeSemiRandom>
  8001a4:	83 c4 10             	add    $0x10,%esp
			break ;
  8001a7:	eb 11                	jmp    8001ba <_main+0x182>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001a9:	83 ec 08             	sub    $0x8,%esp
  8001ac:	ff 75 f0             	pushl  -0x10(%ebp)
  8001af:	ff 75 ec             	pushl  -0x14(%ebp)
  8001b2:	e8 1d 02 00 00       	call   8003d4 <InitializeSemiRandom>
  8001b7:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001ba:	83 ec 04             	sub    $0x4,%esp
  8001bd:	ff 75 f0             	pushl  -0x10(%ebp)
  8001c0:	6a 01                	push   $0x1
  8001c2:	ff 75 ec             	pushl  -0x14(%ebp)
  8001c5:	e8 dc 02 00 00       	call   8004a6 <MSort>
  8001ca:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  8001cd:	e8 b1 1d 00 00       	call   801f83 <sys_disable_interrupt>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001d2:	83 ec 0c             	sub    $0xc,%esp
  8001d5:	68 6c 3d 80 00       	push   $0x803d6c
  8001da:	e8 c8 09 00 00       	call   800ba7 <cprintf>
  8001df:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001e2:	e8 b6 1d 00 00       	call   801f9d <sys_enable_interrupt>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001e7:	83 ec 08             	sub    $0x8,%esp
  8001ea:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ed:	ff 75 ec             	pushl  -0x14(%ebp)
  8001f0:	e8 cf 00 00 00       	call   8002c4 <CheckSorted>
  8001f5:	83 c4 10             	add    $0x10,%esp
  8001f8:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001fb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8001ff:	75 14                	jne    800215 <_main+0x1dd>
  800201:	83 ec 04             	sub    $0x4,%esp
  800204:	68 a0 3d 80 00       	push   $0x803da0
  800209:	6a 4e                	push   $0x4e
  80020b:	68 c2 3d 80 00       	push   $0x803dc2
  800210:	e8 de 06 00 00       	call   8008f3 <_panic>
		else
		{
			sys_disable_interrupt();
  800215:	e8 69 1d 00 00       	call   801f83 <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  80021a:	83 ec 0c             	sub    $0xc,%esp
  80021d:	68 e0 3d 80 00       	push   $0x803de0
  800222:	e8 80 09 00 00       	call   800ba7 <cprintf>
  800227:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  80022a:	83 ec 0c             	sub    $0xc,%esp
  80022d:	68 14 3e 80 00       	push   $0x803e14
  800232:	e8 70 09 00 00       	call   800ba7 <cprintf>
  800237:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  80023a:	83 ec 0c             	sub    $0xc,%esp
  80023d:	68 48 3e 80 00       	push   $0x803e48
  800242:	e8 60 09 00 00       	call   800ba7 <cprintf>
  800247:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  80024a:	e8 4e 1d 00 00       	call   801f9d <sys_enable_interrupt>
		}

		free(Elements) ;
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	ff 75 ec             	pushl  -0x14(%ebp)
  800255:	e8 50 19 00 00       	call   801baa <free>
  80025a:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  80025d:	e8 21 1d 00 00       	call   801f83 <sys_disable_interrupt>
			Chose = 0 ;
  800262:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800266:	eb 3e                	jmp    8002a6 <_main+0x26e>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800268:	83 ec 0c             	sub    $0xc,%esp
  80026b:	68 7a 3e 80 00       	push   $0x803e7a
  800270:	e8 32 09 00 00       	call   800ba7 <cprintf>
  800275:	83 c4 10             	add    $0x10,%esp
				Chose = 'n' ;
  800278:	c6 45 f7 6e          	movb   $0x6e,-0x9(%ebp)
				cputchar(Chose);
  80027c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800280:	83 ec 0c             	sub    $0xc,%esp
  800283:	50                   	push   %eax
  800284:	e8 8e 04 00 00       	call   800717 <cputchar>
  800289:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	6a 0a                	push   $0xa
  800291:	e8 81 04 00 00       	call   800717 <cputchar>
  800296:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800299:	83 ec 0c             	sub    $0xc,%esp
  80029c:	6a 0a                	push   $0xa
  80029e:	e8 74 04 00 00       	call   800717 <cputchar>
  8002a3:	83 c4 10             	add    $0x10,%esp

		free(Elements) ;

		sys_disable_interrupt();
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002a6:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002aa:	74 06                	je     8002b2 <_main+0x27a>
  8002ac:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002b0:	75 b6                	jne    800268 <_main+0x230>
				Chose = 'n' ;
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		sys_enable_interrupt();
  8002b2:	e8 e6 1c 00 00       	call   801f9d <sys_enable_interrupt>

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
  800446:	68 c0 3c 80 00       	push   $0x803cc0
  80044b:	e8 57 07 00 00       	call   800ba7 <cprintf>
  800450:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800456:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80045d:	8b 45 08             	mov    0x8(%ebp),%eax
  800460:	01 d0                	add    %edx,%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	83 ec 08             	sub    $0x8,%esp
  800467:	50                   	push   %eax
  800468:	68 98 3e 80 00       	push   $0x803e98
  80046d:	e8 35 07 00 00       	call   800ba7 <cprintf>
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
  800496:	68 0f 3d 80 00       	push   $0x803d0f
  80049b:	e8 07 07 00 00       	call   800ba7 <cprintf>
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
  80053c:	e8 ee 15 00 00       	call   801b2f <malloc>
  800541:	83 c4 10             	add    $0x10,%esp
  800544:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  800547:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80054a:	c1 e0 02             	shl    $0x2,%eax
  80054d:	83 ec 0c             	sub    $0xc,%esp
  800550:	50                   	push   %eax
  800551:	e8 d9 15 00 00       	call   801b2f <malloc>
  800556:	83 c4 10             	add    $0x10,%esp
  800559:	89 45 d4             	mov    %eax,-0x2c(%ebp)

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
	int* Left = malloc(sizeof(int) * leftCapacity);

	int* Right = malloc(sizeof(int) * rightCapacity);

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

	free(Left);
  8006f8:	83 ec 0c             	sub    $0xc,%esp
  8006fb:	ff 75 d8             	pushl  -0x28(%ebp)
  8006fe:	e8 a7 14 00 00       	call   801baa <free>
  800703:	83 c4 10             	add    $0x10,%esp
	free(Right);
  800706:	83 ec 0c             	sub    $0xc,%esp
  800709:	ff 75 d4             	pushl  -0x2c(%ebp)
  80070c:	e8 99 14 00 00       	call   801baa <free>
  800711:	83 c4 10             	add    $0x10,%esp

}
  800714:	90                   	nop
  800715:	c9                   	leave  
  800716:	c3                   	ret    

00800717 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800717:	55                   	push   %ebp
  800718:	89 e5                	mov    %esp,%ebp
  80071a:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  80071d:	8b 45 08             	mov    0x8(%ebp),%eax
  800720:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800723:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800727:	83 ec 0c             	sub    $0xc,%esp
  80072a:	50                   	push   %eax
  80072b:	e8 87 18 00 00       	call   801fb7 <sys_cputc>
  800730:	83 c4 10             	add    $0x10,%esp
}
  800733:	90                   	nop
  800734:	c9                   	leave  
  800735:	c3                   	ret    

00800736 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  800736:	55                   	push   %ebp
  800737:	89 e5                	mov    %esp,%ebp
  800739:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80073c:	e8 42 18 00 00       	call   801f83 <sys_disable_interrupt>
	char c = ch;
  800741:	8b 45 08             	mov    0x8(%ebp),%eax
  800744:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800747:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80074b:	83 ec 0c             	sub    $0xc,%esp
  80074e:	50                   	push   %eax
  80074f:	e8 63 18 00 00       	call   801fb7 <sys_cputc>
  800754:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800757:	e8 41 18 00 00       	call   801f9d <sys_enable_interrupt>
}
  80075c:	90                   	nop
  80075d:	c9                   	leave  
  80075e:	c3                   	ret    

0080075f <getchar>:

int
getchar(void)
{
  80075f:	55                   	push   %ebp
  800760:	89 e5                	mov    %esp,%ebp
  800762:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800765:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80076c:	eb 08                	jmp    800776 <getchar+0x17>
	{
		c = sys_cgetc();
  80076e:	e8 8b 16 00 00       	call   801dfe <sys_cgetc>
  800773:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800776:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80077a:	74 f2                	je     80076e <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  80077c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80077f:	c9                   	leave  
  800780:	c3                   	ret    

00800781 <atomic_getchar>:

int
atomic_getchar(void)
{
  800781:	55                   	push   %ebp
  800782:	89 e5                	mov    %esp,%ebp
  800784:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800787:	e8 f7 17 00 00       	call   801f83 <sys_disable_interrupt>
	int c=0;
  80078c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800793:	eb 08                	jmp    80079d <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800795:	e8 64 16 00 00       	call   801dfe <sys_cgetc>
  80079a:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  80079d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8007a1:	74 f2                	je     800795 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  8007a3:	e8 f5 17 00 00       	call   801f9d <sys_enable_interrupt>
	return c;
  8007a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8007ab:	c9                   	leave  
  8007ac:	c3                   	ret    

008007ad <iscons>:

int iscons(int fdnum)
{
  8007ad:	55                   	push   %ebp
  8007ae:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8007b0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8007b5:	5d                   	pop    %ebp
  8007b6:	c3                   	ret    

008007b7 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8007b7:	55                   	push   %ebp
  8007b8:	89 e5                	mov    %esp,%ebp
  8007ba:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8007bd:	e8 b4 19 00 00       	call   802176 <sys_getenvindex>
  8007c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8007c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007c8:	89 d0                	mov    %edx,%eax
  8007ca:	c1 e0 03             	shl    $0x3,%eax
  8007cd:	01 d0                	add    %edx,%eax
  8007cf:	01 c0                	add    %eax,%eax
  8007d1:	01 d0                	add    %edx,%eax
  8007d3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007da:	01 d0                	add    %edx,%eax
  8007dc:	c1 e0 04             	shl    $0x4,%eax
  8007df:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8007e4:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8007e9:	a1 24 50 80 00       	mov    0x805024,%eax
  8007ee:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8007f4:	84 c0                	test   %al,%al
  8007f6:	74 0f                	je     800807 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8007f8:	a1 24 50 80 00       	mov    0x805024,%eax
  8007fd:	05 5c 05 00 00       	add    $0x55c,%eax
  800802:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800807:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80080b:	7e 0a                	jle    800817 <libmain+0x60>
		binaryname = argv[0];
  80080d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800810:	8b 00                	mov    (%eax),%eax
  800812:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800817:	83 ec 08             	sub    $0x8,%esp
  80081a:	ff 75 0c             	pushl  0xc(%ebp)
  80081d:	ff 75 08             	pushl  0x8(%ebp)
  800820:	e8 13 f8 ff ff       	call   800038 <_main>
  800825:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800828:	e8 56 17 00 00       	call   801f83 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80082d:	83 ec 0c             	sub    $0xc,%esp
  800830:	68 b8 3e 80 00       	push   $0x803eb8
  800835:	e8 6d 03 00 00       	call   800ba7 <cprintf>
  80083a:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80083d:	a1 24 50 80 00       	mov    0x805024,%eax
  800842:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800848:	a1 24 50 80 00       	mov    0x805024,%eax
  80084d:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800853:	83 ec 04             	sub    $0x4,%esp
  800856:	52                   	push   %edx
  800857:	50                   	push   %eax
  800858:	68 e0 3e 80 00       	push   $0x803ee0
  80085d:	e8 45 03 00 00       	call   800ba7 <cprintf>
  800862:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800865:	a1 24 50 80 00       	mov    0x805024,%eax
  80086a:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800870:	a1 24 50 80 00       	mov    0x805024,%eax
  800875:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80087b:	a1 24 50 80 00       	mov    0x805024,%eax
  800880:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800886:	51                   	push   %ecx
  800887:	52                   	push   %edx
  800888:	50                   	push   %eax
  800889:	68 08 3f 80 00       	push   $0x803f08
  80088e:	e8 14 03 00 00       	call   800ba7 <cprintf>
  800893:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800896:	a1 24 50 80 00       	mov    0x805024,%eax
  80089b:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8008a1:	83 ec 08             	sub    $0x8,%esp
  8008a4:	50                   	push   %eax
  8008a5:	68 60 3f 80 00       	push   $0x803f60
  8008aa:	e8 f8 02 00 00       	call   800ba7 <cprintf>
  8008af:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8008b2:	83 ec 0c             	sub    $0xc,%esp
  8008b5:	68 b8 3e 80 00       	push   $0x803eb8
  8008ba:	e8 e8 02 00 00       	call   800ba7 <cprintf>
  8008bf:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8008c2:	e8 d6 16 00 00       	call   801f9d <sys_enable_interrupt>

	// exit gracefully
	exit();
  8008c7:	e8 19 00 00 00       	call   8008e5 <exit>
}
  8008cc:	90                   	nop
  8008cd:	c9                   	leave  
  8008ce:	c3                   	ret    

008008cf <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8008cf:	55                   	push   %ebp
  8008d0:	89 e5                	mov    %esp,%ebp
  8008d2:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8008d5:	83 ec 0c             	sub    $0xc,%esp
  8008d8:	6a 00                	push   $0x0
  8008da:	e8 63 18 00 00       	call   802142 <sys_destroy_env>
  8008df:	83 c4 10             	add    $0x10,%esp
}
  8008e2:	90                   	nop
  8008e3:	c9                   	leave  
  8008e4:	c3                   	ret    

008008e5 <exit>:

void
exit(void)
{
  8008e5:	55                   	push   %ebp
  8008e6:	89 e5                	mov    %esp,%ebp
  8008e8:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8008eb:	e8 b8 18 00 00       	call   8021a8 <sys_exit_env>
}
  8008f0:	90                   	nop
  8008f1:	c9                   	leave  
  8008f2:	c3                   	ret    

008008f3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8008f3:	55                   	push   %ebp
  8008f4:	89 e5                	mov    %esp,%ebp
  8008f6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8008f9:	8d 45 10             	lea    0x10(%ebp),%eax
  8008fc:	83 c0 04             	add    $0x4,%eax
  8008ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800902:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800907:	85 c0                	test   %eax,%eax
  800909:	74 16                	je     800921 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80090b:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800910:	83 ec 08             	sub    $0x8,%esp
  800913:	50                   	push   %eax
  800914:	68 74 3f 80 00       	push   $0x803f74
  800919:	e8 89 02 00 00       	call   800ba7 <cprintf>
  80091e:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800921:	a1 00 50 80 00       	mov    0x805000,%eax
  800926:	ff 75 0c             	pushl  0xc(%ebp)
  800929:	ff 75 08             	pushl  0x8(%ebp)
  80092c:	50                   	push   %eax
  80092d:	68 79 3f 80 00       	push   $0x803f79
  800932:	e8 70 02 00 00       	call   800ba7 <cprintf>
  800937:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80093a:	8b 45 10             	mov    0x10(%ebp),%eax
  80093d:	83 ec 08             	sub    $0x8,%esp
  800940:	ff 75 f4             	pushl  -0xc(%ebp)
  800943:	50                   	push   %eax
  800944:	e8 f3 01 00 00       	call   800b3c <vcprintf>
  800949:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80094c:	83 ec 08             	sub    $0x8,%esp
  80094f:	6a 00                	push   $0x0
  800951:	68 95 3f 80 00       	push   $0x803f95
  800956:	e8 e1 01 00 00       	call   800b3c <vcprintf>
  80095b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80095e:	e8 82 ff ff ff       	call   8008e5 <exit>

	// should not return here
	while (1) ;
  800963:	eb fe                	jmp    800963 <_panic+0x70>

00800965 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800965:	55                   	push   %ebp
  800966:	89 e5                	mov    %esp,%ebp
  800968:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80096b:	a1 24 50 80 00       	mov    0x805024,%eax
  800970:	8b 50 74             	mov    0x74(%eax),%edx
  800973:	8b 45 0c             	mov    0xc(%ebp),%eax
  800976:	39 c2                	cmp    %eax,%edx
  800978:	74 14                	je     80098e <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80097a:	83 ec 04             	sub    $0x4,%esp
  80097d:	68 98 3f 80 00       	push   $0x803f98
  800982:	6a 26                	push   $0x26
  800984:	68 e4 3f 80 00       	push   $0x803fe4
  800989:	e8 65 ff ff ff       	call   8008f3 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80098e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800995:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80099c:	e9 c2 00 00 00       	jmp    800a63 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8009a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009a4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ae:	01 d0                	add    %edx,%eax
  8009b0:	8b 00                	mov    (%eax),%eax
  8009b2:	85 c0                	test   %eax,%eax
  8009b4:	75 08                	jne    8009be <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8009b6:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8009b9:	e9 a2 00 00 00       	jmp    800a60 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8009be:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009c5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8009cc:	eb 69                	jmp    800a37 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8009ce:	a1 24 50 80 00       	mov    0x805024,%eax
  8009d3:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8009d9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009dc:	89 d0                	mov    %edx,%eax
  8009de:	01 c0                	add    %eax,%eax
  8009e0:	01 d0                	add    %edx,%eax
  8009e2:	c1 e0 03             	shl    $0x3,%eax
  8009e5:	01 c8                	add    %ecx,%eax
  8009e7:	8a 40 04             	mov    0x4(%eax),%al
  8009ea:	84 c0                	test   %al,%al
  8009ec:	75 46                	jne    800a34 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009ee:	a1 24 50 80 00       	mov    0x805024,%eax
  8009f3:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8009f9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009fc:	89 d0                	mov    %edx,%eax
  8009fe:	01 c0                	add    %eax,%eax
  800a00:	01 d0                	add    %edx,%eax
  800a02:	c1 e0 03             	shl    $0x3,%eax
  800a05:	01 c8                	add    %ecx,%eax
  800a07:	8b 00                	mov    (%eax),%eax
  800a09:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a0c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a0f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a14:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800a16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a19:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a20:	8b 45 08             	mov    0x8(%ebp),%eax
  800a23:	01 c8                	add    %ecx,%eax
  800a25:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a27:	39 c2                	cmp    %eax,%edx
  800a29:	75 09                	jne    800a34 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800a2b:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a32:	eb 12                	jmp    800a46 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a34:	ff 45 e8             	incl   -0x18(%ebp)
  800a37:	a1 24 50 80 00       	mov    0x805024,%eax
  800a3c:	8b 50 74             	mov    0x74(%eax),%edx
  800a3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a42:	39 c2                	cmp    %eax,%edx
  800a44:	77 88                	ja     8009ce <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a46:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a4a:	75 14                	jne    800a60 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800a4c:	83 ec 04             	sub    $0x4,%esp
  800a4f:	68 f0 3f 80 00       	push   $0x803ff0
  800a54:	6a 3a                	push   $0x3a
  800a56:	68 e4 3f 80 00       	push   $0x803fe4
  800a5b:	e8 93 fe ff ff       	call   8008f3 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a60:	ff 45 f0             	incl   -0x10(%ebp)
  800a63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a66:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a69:	0f 8c 32 ff ff ff    	jl     8009a1 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a6f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a76:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a7d:	eb 26                	jmp    800aa5 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a7f:	a1 24 50 80 00       	mov    0x805024,%eax
  800a84:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800a8a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a8d:	89 d0                	mov    %edx,%eax
  800a8f:	01 c0                	add    %eax,%eax
  800a91:	01 d0                	add    %edx,%eax
  800a93:	c1 e0 03             	shl    $0x3,%eax
  800a96:	01 c8                	add    %ecx,%eax
  800a98:	8a 40 04             	mov    0x4(%eax),%al
  800a9b:	3c 01                	cmp    $0x1,%al
  800a9d:	75 03                	jne    800aa2 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800a9f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800aa2:	ff 45 e0             	incl   -0x20(%ebp)
  800aa5:	a1 24 50 80 00       	mov    0x805024,%eax
  800aaa:	8b 50 74             	mov    0x74(%eax),%edx
  800aad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ab0:	39 c2                	cmp    %eax,%edx
  800ab2:	77 cb                	ja     800a7f <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ab7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800aba:	74 14                	je     800ad0 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800abc:	83 ec 04             	sub    $0x4,%esp
  800abf:	68 44 40 80 00       	push   $0x804044
  800ac4:	6a 44                	push   $0x44
  800ac6:	68 e4 3f 80 00       	push   $0x803fe4
  800acb:	e8 23 fe ff ff       	call   8008f3 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800ad0:	90                   	nop
  800ad1:	c9                   	leave  
  800ad2:	c3                   	ret    

00800ad3 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800ad3:	55                   	push   %ebp
  800ad4:	89 e5                	mov    %esp,%ebp
  800ad6:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800ad9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800adc:	8b 00                	mov    (%eax),%eax
  800ade:	8d 48 01             	lea    0x1(%eax),%ecx
  800ae1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ae4:	89 0a                	mov    %ecx,(%edx)
  800ae6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ae9:	88 d1                	mov    %dl,%cl
  800aeb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aee:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800af2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af5:	8b 00                	mov    (%eax),%eax
  800af7:	3d ff 00 00 00       	cmp    $0xff,%eax
  800afc:	75 2c                	jne    800b2a <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800afe:	a0 28 50 80 00       	mov    0x805028,%al
  800b03:	0f b6 c0             	movzbl %al,%eax
  800b06:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b09:	8b 12                	mov    (%edx),%edx
  800b0b:	89 d1                	mov    %edx,%ecx
  800b0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b10:	83 c2 08             	add    $0x8,%edx
  800b13:	83 ec 04             	sub    $0x4,%esp
  800b16:	50                   	push   %eax
  800b17:	51                   	push   %ecx
  800b18:	52                   	push   %edx
  800b19:	e8 b7 12 00 00       	call   801dd5 <sys_cputs>
  800b1e:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b24:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2d:	8b 40 04             	mov    0x4(%eax),%eax
  800b30:	8d 50 01             	lea    0x1(%eax),%edx
  800b33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b36:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b39:	90                   	nop
  800b3a:	c9                   	leave  
  800b3b:	c3                   	ret    

00800b3c <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b3c:	55                   	push   %ebp
  800b3d:	89 e5                	mov    %esp,%ebp
  800b3f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b45:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b4c:	00 00 00 
	b.cnt = 0;
  800b4f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b56:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b59:	ff 75 0c             	pushl  0xc(%ebp)
  800b5c:	ff 75 08             	pushl  0x8(%ebp)
  800b5f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b65:	50                   	push   %eax
  800b66:	68 d3 0a 80 00       	push   $0x800ad3
  800b6b:	e8 11 02 00 00       	call   800d81 <vprintfmt>
  800b70:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800b73:	a0 28 50 80 00       	mov    0x805028,%al
  800b78:	0f b6 c0             	movzbl %al,%eax
  800b7b:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800b81:	83 ec 04             	sub    $0x4,%esp
  800b84:	50                   	push   %eax
  800b85:	52                   	push   %edx
  800b86:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b8c:	83 c0 08             	add    $0x8,%eax
  800b8f:	50                   	push   %eax
  800b90:	e8 40 12 00 00       	call   801dd5 <sys_cputs>
  800b95:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800b98:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800b9f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800ba5:	c9                   	leave  
  800ba6:	c3                   	ret    

00800ba7 <cprintf>:

int cprintf(const char *fmt, ...) {
  800ba7:	55                   	push   %ebp
  800ba8:	89 e5                	mov    %esp,%ebp
  800baa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800bad:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800bb4:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bba:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbd:	83 ec 08             	sub    $0x8,%esp
  800bc0:	ff 75 f4             	pushl  -0xc(%ebp)
  800bc3:	50                   	push   %eax
  800bc4:	e8 73 ff ff ff       	call   800b3c <vcprintf>
  800bc9:	83 c4 10             	add    $0x10,%esp
  800bcc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800bcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bd2:	c9                   	leave  
  800bd3:	c3                   	ret    

00800bd4 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800bd4:	55                   	push   %ebp
  800bd5:	89 e5                	mov    %esp,%ebp
  800bd7:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800bda:	e8 a4 13 00 00       	call   801f83 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800bdf:	8d 45 0c             	lea    0xc(%ebp),%eax
  800be2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800be5:	8b 45 08             	mov    0x8(%ebp),%eax
  800be8:	83 ec 08             	sub    $0x8,%esp
  800beb:	ff 75 f4             	pushl  -0xc(%ebp)
  800bee:	50                   	push   %eax
  800bef:	e8 48 ff ff ff       	call   800b3c <vcprintf>
  800bf4:	83 c4 10             	add    $0x10,%esp
  800bf7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800bfa:	e8 9e 13 00 00       	call   801f9d <sys_enable_interrupt>
	return cnt;
  800bff:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c02:	c9                   	leave  
  800c03:	c3                   	ret    

00800c04 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c04:	55                   	push   %ebp
  800c05:	89 e5                	mov    %esp,%ebp
  800c07:	53                   	push   %ebx
  800c08:	83 ec 14             	sub    $0x14,%esp
  800c0b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c11:	8b 45 14             	mov    0x14(%ebp),%eax
  800c14:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c17:	8b 45 18             	mov    0x18(%ebp),%eax
  800c1a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c1f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c22:	77 55                	ja     800c79 <printnum+0x75>
  800c24:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c27:	72 05                	jb     800c2e <printnum+0x2a>
  800c29:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c2c:	77 4b                	ja     800c79 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c2e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800c31:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800c34:	8b 45 18             	mov    0x18(%ebp),%eax
  800c37:	ba 00 00 00 00       	mov    $0x0,%edx
  800c3c:	52                   	push   %edx
  800c3d:	50                   	push   %eax
  800c3e:	ff 75 f4             	pushl  -0xc(%ebp)
  800c41:	ff 75 f0             	pushl  -0x10(%ebp)
  800c44:	e8 0f 2e 00 00       	call   803a58 <__udivdi3>
  800c49:	83 c4 10             	add    $0x10,%esp
  800c4c:	83 ec 04             	sub    $0x4,%esp
  800c4f:	ff 75 20             	pushl  0x20(%ebp)
  800c52:	53                   	push   %ebx
  800c53:	ff 75 18             	pushl  0x18(%ebp)
  800c56:	52                   	push   %edx
  800c57:	50                   	push   %eax
  800c58:	ff 75 0c             	pushl  0xc(%ebp)
  800c5b:	ff 75 08             	pushl  0x8(%ebp)
  800c5e:	e8 a1 ff ff ff       	call   800c04 <printnum>
  800c63:	83 c4 20             	add    $0x20,%esp
  800c66:	eb 1a                	jmp    800c82 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c68:	83 ec 08             	sub    $0x8,%esp
  800c6b:	ff 75 0c             	pushl  0xc(%ebp)
  800c6e:	ff 75 20             	pushl  0x20(%ebp)
  800c71:	8b 45 08             	mov    0x8(%ebp),%eax
  800c74:	ff d0                	call   *%eax
  800c76:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c79:	ff 4d 1c             	decl   0x1c(%ebp)
  800c7c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c80:	7f e6                	jg     800c68 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c82:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c85:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c90:	53                   	push   %ebx
  800c91:	51                   	push   %ecx
  800c92:	52                   	push   %edx
  800c93:	50                   	push   %eax
  800c94:	e8 cf 2e 00 00       	call   803b68 <__umoddi3>
  800c99:	83 c4 10             	add    $0x10,%esp
  800c9c:	05 b4 42 80 00       	add    $0x8042b4,%eax
  800ca1:	8a 00                	mov    (%eax),%al
  800ca3:	0f be c0             	movsbl %al,%eax
  800ca6:	83 ec 08             	sub    $0x8,%esp
  800ca9:	ff 75 0c             	pushl  0xc(%ebp)
  800cac:	50                   	push   %eax
  800cad:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb0:	ff d0                	call   *%eax
  800cb2:	83 c4 10             	add    $0x10,%esp
}
  800cb5:	90                   	nop
  800cb6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800cb9:	c9                   	leave  
  800cba:	c3                   	ret    

00800cbb <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800cbb:	55                   	push   %ebp
  800cbc:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800cbe:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800cc2:	7e 1c                	jle    800ce0 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc7:	8b 00                	mov    (%eax),%eax
  800cc9:	8d 50 08             	lea    0x8(%eax),%edx
  800ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccf:	89 10                	mov    %edx,(%eax)
  800cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd4:	8b 00                	mov    (%eax),%eax
  800cd6:	83 e8 08             	sub    $0x8,%eax
  800cd9:	8b 50 04             	mov    0x4(%eax),%edx
  800cdc:	8b 00                	mov    (%eax),%eax
  800cde:	eb 40                	jmp    800d20 <getuint+0x65>
	else if (lflag)
  800ce0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ce4:	74 1e                	je     800d04 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce9:	8b 00                	mov    (%eax),%eax
  800ceb:	8d 50 04             	lea    0x4(%eax),%edx
  800cee:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf1:	89 10                	mov    %edx,(%eax)
  800cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf6:	8b 00                	mov    (%eax),%eax
  800cf8:	83 e8 04             	sub    $0x4,%eax
  800cfb:	8b 00                	mov    (%eax),%eax
  800cfd:	ba 00 00 00 00       	mov    $0x0,%edx
  800d02:	eb 1c                	jmp    800d20 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800d04:	8b 45 08             	mov    0x8(%ebp),%eax
  800d07:	8b 00                	mov    (%eax),%eax
  800d09:	8d 50 04             	lea    0x4(%eax),%edx
  800d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0f:	89 10                	mov    %edx,(%eax)
  800d11:	8b 45 08             	mov    0x8(%ebp),%eax
  800d14:	8b 00                	mov    (%eax),%eax
  800d16:	83 e8 04             	sub    $0x4,%eax
  800d19:	8b 00                	mov    (%eax),%eax
  800d1b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800d20:	5d                   	pop    %ebp
  800d21:	c3                   	ret    

00800d22 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800d22:	55                   	push   %ebp
  800d23:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d25:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d29:	7e 1c                	jle    800d47 <getint+0x25>
		return va_arg(*ap, long long);
  800d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2e:	8b 00                	mov    (%eax),%eax
  800d30:	8d 50 08             	lea    0x8(%eax),%edx
  800d33:	8b 45 08             	mov    0x8(%ebp),%eax
  800d36:	89 10                	mov    %edx,(%eax)
  800d38:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3b:	8b 00                	mov    (%eax),%eax
  800d3d:	83 e8 08             	sub    $0x8,%eax
  800d40:	8b 50 04             	mov    0x4(%eax),%edx
  800d43:	8b 00                	mov    (%eax),%eax
  800d45:	eb 38                	jmp    800d7f <getint+0x5d>
	else if (lflag)
  800d47:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d4b:	74 1a                	je     800d67 <getint+0x45>
		return va_arg(*ap, long);
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	8b 00                	mov    (%eax),%eax
  800d52:	8d 50 04             	lea    0x4(%eax),%edx
  800d55:	8b 45 08             	mov    0x8(%ebp),%eax
  800d58:	89 10                	mov    %edx,(%eax)
  800d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5d:	8b 00                	mov    (%eax),%eax
  800d5f:	83 e8 04             	sub    $0x4,%eax
  800d62:	8b 00                	mov    (%eax),%eax
  800d64:	99                   	cltd   
  800d65:	eb 18                	jmp    800d7f <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d67:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6a:	8b 00                	mov    (%eax),%eax
  800d6c:	8d 50 04             	lea    0x4(%eax),%edx
  800d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d72:	89 10                	mov    %edx,(%eax)
  800d74:	8b 45 08             	mov    0x8(%ebp),%eax
  800d77:	8b 00                	mov    (%eax),%eax
  800d79:	83 e8 04             	sub    $0x4,%eax
  800d7c:	8b 00                	mov    (%eax),%eax
  800d7e:	99                   	cltd   
}
  800d7f:	5d                   	pop    %ebp
  800d80:	c3                   	ret    

00800d81 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d81:	55                   	push   %ebp
  800d82:	89 e5                	mov    %esp,%ebp
  800d84:	56                   	push   %esi
  800d85:	53                   	push   %ebx
  800d86:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d89:	eb 17                	jmp    800da2 <vprintfmt+0x21>
			if (ch == '\0')
  800d8b:	85 db                	test   %ebx,%ebx
  800d8d:	0f 84 af 03 00 00    	je     801142 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800d93:	83 ec 08             	sub    $0x8,%esp
  800d96:	ff 75 0c             	pushl  0xc(%ebp)
  800d99:	53                   	push   %ebx
  800d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9d:	ff d0                	call   *%eax
  800d9f:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800da2:	8b 45 10             	mov    0x10(%ebp),%eax
  800da5:	8d 50 01             	lea    0x1(%eax),%edx
  800da8:	89 55 10             	mov    %edx,0x10(%ebp)
  800dab:	8a 00                	mov    (%eax),%al
  800dad:	0f b6 d8             	movzbl %al,%ebx
  800db0:	83 fb 25             	cmp    $0x25,%ebx
  800db3:	75 d6                	jne    800d8b <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800db5:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800db9:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800dc0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800dc7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800dce:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800dd5:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd8:	8d 50 01             	lea    0x1(%eax),%edx
  800ddb:	89 55 10             	mov    %edx,0x10(%ebp)
  800dde:	8a 00                	mov    (%eax),%al
  800de0:	0f b6 d8             	movzbl %al,%ebx
  800de3:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800de6:	83 f8 55             	cmp    $0x55,%eax
  800de9:	0f 87 2b 03 00 00    	ja     80111a <vprintfmt+0x399>
  800def:	8b 04 85 d8 42 80 00 	mov    0x8042d8(,%eax,4),%eax
  800df6:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800df8:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800dfc:	eb d7                	jmp    800dd5 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800dfe:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800e02:	eb d1                	jmp    800dd5 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e04:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800e0b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e0e:	89 d0                	mov    %edx,%eax
  800e10:	c1 e0 02             	shl    $0x2,%eax
  800e13:	01 d0                	add    %edx,%eax
  800e15:	01 c0                	add    %eax,%eax
  800e17:	01 d8                	add    %ebx,%eax
  800e19:	83 e8 30             	sub    $0x30,%eax
  800e1c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800e1f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e22:	8a 00                	mov    (%eax),%al
  800e24:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e27:	83 fb 2f             	cmp    $0x2f,%ebx
  800e2a:	7e 3e                	jle    800e6a <vprintfmt+0xe9>
  800e2c:	83 fb 39             	cmp    $0x39,%ebx
  800e2f:	7f 39                	jg     800e6a <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e31:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800e34:	eb d5                	jmp    800e0b <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800e36:	8b 45 14             	mov    0x14(%ebp),%eax
  800e39:	83 c0 04             	add    $0x4,%eax
  800e3c:	89 45 14             	mov    %eax,0x14(%ebp)
  800e3f:	8b 45 14             	mov    0x14(%ebp),%eax
  800e42:	83 e8 04             	sub    $0x4,%eax
  800e45:	8b 00                	mov    (%eax),%eax
  800e47:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800e4a:	eb 1f                	jmp    800e6b <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800e4c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e50:	79 83                	jns    800dd5 <vprintfmt+0x54>
				width = 0;
  800e52:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800e59:	e9 77 ff ff ff       	jmp    800dd5 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e5e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e65:	e9 6b ff ff ff       	jmp    800dd5 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e6a:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e6b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e6f:	0f 89 60 ff ff ff    	jns    800dd5 <vprintfmt+0x54>
				width = precision, precision = -1;
  800e75:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e78:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e7b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e82:	e9 4e ff ff ff       	jmp    800dd5 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e87:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800e8a:	e9 46 ff ff ff       	jmp    800dd5 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800e8f:	8b 45 14             	mov    0x14(%ebp),%eax
  800e92:	83 c0 04             	add    $0x4,%eax
  800e95:	89 45 14             	mov    %eax,0x14(%ebp)
  800e98:	8b 45 14             	mov    0x14(%ebp),%eax
  800e9b:	83 e8 04             	sub    $0x4,%eax
  800e9e:	8b 00                	mov    (%eax),%eax
  800ea0:	83 ec 08             	sub    $0x8,%esp
  800ea3:	ff 75 0c             	pushl  0xc(%ebp)
  800ea6:	50                   	push   %eax
  800ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eaa:	ff d0                	call   *%eax
  800eac:	83 c4 10             	add    $0x10,%esp
			break;
  800eaf:	e9 89 02 00 00       	jmp    80113d <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800eb4:	8b 45 14             	mov    0x14(%ebp),%eax
  800eb7:	83 c0 04             	add    $0x4,%eax
  800eba:	89 45 14             	mov    %eax,0x14(%ebp)
  800ebd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec0:	83 e8 04             	sub    $0x4,%eax
  800ec3:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ec5:	85 db                	test   %ebx,%ebx
  800ec7:	79 02                	jns    800ecb <vprintfmt+0x14a>
				err = -err;
  800ec9:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ecb:	83 fb 64             	cmp    $0x64,%ebx
  800ece:	7f 0b                	jg     800edb <vprintfmt+0x15a>
  800ed0:	8b 34 9d 20 41 80 00 	mov    0x804120(,%ebx,4),%esi
  800ed7:	85 f6                	test   %esi,%esi
  800ed9:	75 19                	jne    800ef4 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800edb:	53                   	push   %ebx
  800edc:	68 c5 42 80 00       	push   $0x8042c5
  800ee1:	ff 75 0c             	pushl  0xc(%ebp)
  800ee4:	ff 75 08             	pushl  0x8(%ebp)
  800ee7:	e8 5e 02 00 00       	call   80114a <printfmt>
  800eec:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800eef:	e9 49 02 00 00       	jmp    80113d <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ef4:	56                   	push   %esi
  800ef5:	68 ce 42 80 00       	push   $0x8042ce
  800efa:	ff 75 0c             	pushl  0xc(%ebp)
  800efd:	ff 75 08             	pushl  0x8(%ebp)
  800f00:	e8 45 02 00 00       	call   80114a <printfmt>
  800f05:	83 c4 10             	add    $0x10,%esp
			break;
  800f08:	e9 30 02 00 00       	jmp    80113d <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800f0d:	8b 45 14             	mov    0x14(%ebp),%eax
  800f10:	83 c0 04             	add    $0x4,%eax
  800f13:	89 45 14             	mov    %eax,0x14(%ebp)
  800f16:	8b 45 14             	mov    0x14(%ebp),%eax
  800f19:	83 e8 04             	sub    $0x4,%eax
  800f1c:	8b 30                	mov    (%eax),%esi
  800f1e:	85 f6                	test   %esi,%esi
  800f20:	75 05                	jne    800f27 <vprintfmt+0x1a6>
				p = "(null)";
  800f22:	be d1 42 80 00       	mov    $0x8042d1,%esi
			if (width > 0 && padc != '-')
  800f27:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f2b:	7e 6d                	jle    800f9a <vprintfmt+0x219>
  800f2d:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800f31:	74 67                	je     800f9a <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800f33:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f36:	83 ec 08             	sub    $0x8,%esp
  800f39:	50                   	push   %eax
  800f3a:	56                   	push   %esi
  800f3b:	e8 0c 03 00 00       	call   80124c <strnlen>
  800f40:	83 c4 10             	add    $0x10,%esp
  800f43:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800f46:	eb 16                	jmp    800f5e <vprintfmt+0x1dd>
					putch(padc, putdat);
  800f48:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800f4c:	83 ec 08             	sub    $0x8,%esp
  800f4f:	ff 75 0c             	pushl  0xc(%ebp)
  800f52:	50                   	push   %eax
  800f53:	8b 45 08             	mov    0x8(%ebp),%eax
  800f56:	ff d0                	call   *%eax
  800f58:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f5b:	ff 4d e4             	decl   -0x1c(%ebp)
  800f5e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f62:	7f e4                	jg     800f48 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f64:	eb 34                	jmp    800f9a <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f66:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f6a:	74 1c                	je     800f88 <vprintfmt+0x207>
  800f6c:	83 fb 1f             	cmp    $0x1f,%ebx
  800f6f:	7e 05                	jle    800f76 <vprintfmt+0x1f5>
  800f71:	83 fb 7e             	cmp    $0x7e,%ebx
  800f74:	7e 12                	jle    800f88 <vprintfmt+0x207>
					putch('?', putdat);
  800f76:	83 ec 08             	sub    $0x8,%esp
  800f79:	ff 75 0c             	pushl  0xc(%ebp)
  800f7c:	6a 3f                	push   $0x3f
  800f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f81:	ff d0                	call   *%eax
  800f83:	83 c4 10             	add    $0x10,%esp
  800f86:	eb 0f                	jmp    800f97 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800f88:	83 ec 08             	sub    $0x8,%esp
  800f8b:	ff 75 0c             	pushl  0xc(%ebp)
  800f8e:	53                   	push   %ebx
  800f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f92:	ff d0                	call   *%eax
  800f94:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f97:	ff 4d e4             	decl   -0x1c(%ebp)
  800f9a:	89 f0                	mov    %esi,%eax
  800f9c:	8d 70 01             	lea    0x1(%eax),%esi
  800f9f:	8a 00                	mov    (%eax),%al
  800fa1:	0f be d8             	movsbl %al,%ebx
  800fa4:	85 db                	test   %ebx,%ebx
  800fa6:	74 24                	je     800fcc <vprintfmt+0x24b>
  800fa8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fac:	78 b8                	js     800f66 <vprintfmt+0x1e5>
  800fae:	ff 4d e0             	decl   -0x20(%ebp)
  800fb1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fb5:	79 af                	jns    800f66 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fb7:	eb 13                	jmp    800fcc <vprintfmt+0x24b>
				putch(' ', putdat);
  800fb9:	83 ec 08             	sub    $0x8,%esp
  800fbc:	ff 75 0c             	pushl  0xc(%ebp)
  800fbf:	6a 20                	push   $0x20
  800fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc4:	ff d0                	call   *%eax
  800fc6:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fc9:	ff 4d e4             	decl   -0x1c(%ebp)
  800fcc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fd0:	7f e7                	jg     800fb9 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800fd2:	e9 66 01 00 00       	jmp    80113d <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800fd7:	83 ec 08             	sub    $0x8,%esp
  800fda:	ff 75 e8             	pushl  -0x18(%ebp)
  800fdd:	8d 45 14             	lea    0x14(%ebp),%eax
  800fe0:	50                   	push   %eax
  800fe1:	e8 3c fd ff ff       	call   800d22 <getint>
  800fe6:	83 c4 10             	add    $0x10,%esp
  800fe9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fec:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800fef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ff2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ff5:	85 d2                	test   %edx,%edx
  800ff7:	79 23                	jns    80101c <vprintfmt+0x29b>
				putch('-', putdat);
  800ff9:	83 ec 08             	sub    $0x8,%esp
  800ffc:	ff 75 0c             	pushl  0xc(%ebp)
  800fff:	6a 2d                	push   $0x2d
  801001:	8b 45 08             	mov    0x8(%ebp),%eax
  801004:	ff d0                	call   *%eax
  801006:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801009:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80100c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80100f:	f7 d8                	neg    %eax
  801011:	83 d2 00             	adc    $0x0,%edx
  801014:	f7 da                	neg    %edx
  801016:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801019:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80101c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801023:	e9 bc 00 00 00       	jmp    8010e4 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801028:	83 ec 08             	sub    $0x8,%esp
  80102b:	ff 75 e8             	pushl  -0x18(%ebp)
  80102e:	8d 45 14             	lea    0x14(%ebp),%eax
  801031:	50                   	push   %eax
  801032:	e8 84 fc ff ff       	call   800cbb <getuint>
  801037:	83 c4 10             	add    $0x10,%esp
  80103a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80103d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801040:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801047:	e9 98 00 00 00       	jmp    8010e4 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80104c:	83 ec 08             	sub    $0x8,%esp
  80104f:	ff 75 0c             	pushl  0xc(%ebp)
  801052:	6a 58                	push   $0x58
  801054:	8b 45 08             	mov    0x8(%ebp),%eax
  801057:	ff d0                	call   *%eax
  801059:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80105c:	83 ec 08             	sub    $0x8,%esp
  80105f:	ff 75 0c             	pushl  0xc(%ebp)
  801062:	6a 58                	push   $0x58
  801064:	8b 45 08             	mov    0x8(%ebp),%eax
  801067:	ff d0                	call   *%eax
  801069:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80106c:	83 ec 08             	sub    $0x8,%esp
  80106f:	ff 75 0c             	pushl  0xc(%ebp)
  801072:	6a 58                	push   $0x58
  801074:	8b 45 08             	mov    0x8(%ebp),%eax
  801077:	ff d0                	call   *%eax
  801079:	83 c4 10             	add    $0x10,%esp
			break;
  80107c:	e9 bc 00 00 00       	jmp    80113d <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801081:	83 ec 08             	sub    $0x8,%esp
  801084:	ff 75 0c             	pushl  0xc(%ebp)
  801087:	6a 30                	push   $0x30
  801089:	8b 45 08             	mov    0x8(%ebp),%eax
  80108c:	ff d0                	call   *%eax
  80108e:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801091:	83 ec 08             	sub    $0x8,%esp
  801094:	ff 75 0c             	pushl  0xc(%ebp)
  801097:	6a 78                	push   $0x78
  801099:	8b 45 08             	mov    0x8(%ebp),%eax
  80109c:	ff d0                	call   *%eax
  80109e:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8010a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8010a4:	83 c0 04             	add    $0x4,%eax
  8010a7:	89 45 14             	mov    %eax,0x14(%ebp)
  8010aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8010ad:	83 e8 04             	sub    $0x4,%eax
  8010b0:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8010b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8010bc:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8010c3:	eb 1f                	jmp    8010e4 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8010c5:	83 ec 08             	sub    $0x8,%esp
  8010c8:	ff 75 e8             	pushl  -0x18(%ebp)
  8010cb:	8d 45 14             	lea    0x14(%ebp),%eax
  8010ce:	50                   	push   %eax
  8010cf:	e8 e7 fb ff ff       	call   800cbb <getuint>
  8010d4:	83 c4 10             	add    $0x10,%esp
  8010d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010da:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8010dd:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8010e4:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8010e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010eb:	83 ec 04             	sub    $0x4,%esp
  8010ee:	52                   	push   %edx
  8010ef:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010f2:	50                   	push   %eax
  8010f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8010f6:	ff 75 f0             	pushl  -0x10(%ebp)
  8010f9:	ff 75 0c             	pushl  0xc(%ebp)
  8010fc:	ff 75 08             	pushl  0x8(%ebp)
  8010ff:	e8 00 fb ff ff       	call   800c04 <printnum>
  801104:	83 c4 20             	add    $0x20,%esp
			break;
  801107:	eb 34                	jmp    80113d <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801109:	83 ec 08             	sub    $0x8,%esp
  80110c:	ff 75 0c             	pushl  0xc(%ebp)
  80110f:	53                   	push   %ebx
  801110:	8b 45 08             	mov    0x8(%ebp),%eax
  801113:	ff d0                	call   *%eax
  801115:	83 c4 10             	add    $0x10,%esp
			break;
  801118:	eb 23                	jmp    80113d <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80111a:	83 ec 08             	sub    $0x8,%esp
  80111d:	ff 75 0c             	pushl  0xc(%ebp)
  801120:	6a 25                	push   $0x25
  801122:	8b 45 08             	mov    0x8(%ebp),%eax
  801125:	ff d0                	call   *%eax
  801127:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80112a:	ff 4d 10             	decl   0x10(%ebp)
  80112d:	eb 03                	jmp    801132 <vprintfmt+0x3b1>
  80112f:	ff 4d 10             	decl   0x10(%ebp)
  801132:	8b 45 10             	mov    0x10(%ebp),%eax
  801135:	48                   	dec    %eax
  801136:	8a 00                	mov    (%eax),%al
  801138:	3c 25                	cmp    $0x25,%al
  80113a:	75 f3                	jne    80112f <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80113c:	90                   	nop
		}
	}
  80113d:	e9 47 fc ff ff       	jmp    800d89 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801142:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801143:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801146:	5b                   	pop    %ebx
  801147:	5e                   	pop    %esi
  801148:	5d                   	pop    %ebp
  801149:	c3                   	ret    

0080114a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80114a:	55                   	push   %ebp
  80114b:	89 e5                	mov    %esp,%ebp
  80114d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801150:	8d 45 10             	lea    0x10(%ebp),%eax
  801153:	83 c0 04             	add    $0x4,%eax
  801156:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801159:	8b 45 10             	mov    0x10(%ebp),%eax
  80115c:	ff 75 f4             	pushl  -0xc(%ebp)
  80115f:	50                   	push   %eax
  801160:	ff 75 0c             	pushl  0xc(%ebp)
  801163:	ff 75 08             	pushl  0x8(%ebp)
  801166:	e8 16 fc ff ff       	call   800d81 <vprintfmt>
  80116b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80116e:	90                   	nop
  80116f:	c9                   	leave  
  801170:	c3                   	ret    

00801171 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801171:	55                   	push   %ebp
  801172:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801174:	8b 45 0c             	mov    0xc(%ebp),%eax
  801177:	8b 40 08             	mov    0x8(%eax),%eax
  80117a:	8d 50 01             	lea    0x1(%eax),%edx
  80117d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801180:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801183:	8b 45 0c             	mov    0xc(%ebp),%eax
  801186:	8b 10                	mov    (%eax),%edx
  801188:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118b:	8b 40 04             	mov    0x4(%eax),%eax
  80118e:	39 c2                	cmp    %eax,%edx
  801190:	73 12                	jae    8011a4 <sprintputch+0x33>
		*b->buf++ = ch;
  801192:	8b 45 0c             	mov    0xc(%ebp),%eax
  801195:	8b 00                	mov    (%eax),%eax
  801197:	8d 48 01             	lea    0x1(%eax),%ecx
  80119a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80119d:	89 0a                	mov    %ecx,(%edx)
  80119f:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a2:	88 10                	mov    %dl,(%eax)
}
  8011a4:	90                   	nop
  8011a5:	5d                   	pop    %ebp
  8011a6:	c3                   	ret    

008011a7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8011a7:	55                   	push   %ebp
  8011a8:	89 e5                	mov    %esp,%ebp
  8011aa:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8011ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8011b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bc:	01 d0                	add    %edx,%eax
  8011be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8011c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011cc:	74 06                	je     8011d4 <vsnprintf+0x2d>
  8011ce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011d2:	7f 07                	jg     8011db <vsnprintf+0x34>
		return -E_INVAL;
  8011d4:	b8 03 00 00 00       	mov    $0x3,%eax
  8011d9:	eb 20                	jmp    8011fb <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8011db:	ff 75 14             	pushl  0x14(%ebp)
  8011de:	ff 75 10             	pushl  0x10(%ebp)
  8011e1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8011e4:	50                   	push   %eax
  8011e5:	68 71 11 80 00       	push   $0x801171
  8011ea:	e8 92 fb ff ff       	call   800d81 <vprintfmt>
  8011ef:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8011f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011f5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8011f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8011fb:	c9                   	leave  
  8011fc:	c3                   	ret    

008011fd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011fd:	55                   	push   %ebp
  8011fe:	89 e5                	mov    %esp,%ebp
  801200:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801203:	8d 45 10             	lea    0x10(%ebp),%eax
  801206:	83 c0 04             	add    $0x4,%eax
  801209:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80120c:	8b 45 10             	mov    0x10(%ebp),%eax
  80120f:	ff 75 f4             	pushl  -0xc(%ebp)
  801212:	50                   	push   %eax
  801213:	ff 75 0c             	pushl  0xc(%ebp)
  801216:	ff 75 08             	pushl  0x8(%ebp)
  801219:	e8 89 ff ff ff       	call   8011a7 <vsnprintf>
  80121e:	83 c4 10             	add    $0x10,%esp
  801221:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801224:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801227:	c9                   	leave  
  801228:	c3                   	ret    

00801229 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801229:	55                   	push   %ebp
  80122a:	89 e5                	mov    %esp,%ebp
  80122c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80122f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801236:	eb 06                	jmp    80123e <strlen+0x15>
		n++;
  801238:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80123b:	ff 45 08             	incl   0x8(%ebp)
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
  801241:	8a 00                	mov    (%eax),%al
  801243:	84 c0                	test   %al,%al
  801245:	75 f1                	jne    801238 <strlen+0xf>
		n++;
	return n;
  801247:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80124a:	c9                   	leave  
  80124b:	c3                   	ret    

0080124c <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80124c:	55                   	push   %ebp
  80124d:	89 e5                	mov    %esp,%ebp
  80124f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801252:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801259:	eb 09                	jmp    801264 <strnlen+0x18>
		n++;
  80125b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80125e:	ff 45 08             	incl   0x8(%ebp)
  801261:	ff 4d 0c             	decl   0xc(%ebp)
  801264:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801268:	74 09                	je     801273 <strnlen+0x27>
  80126a:	8b 45 08             	mov    0x8(%ebp),%eax
  80126d:	8a 00                	mov    (%eax),%al
  80126f:	84 c0                	test   %al,%al
  801271:	75 e8                	jne    80125b <strnlen+0xf>
		n++;
	return n;
  801273:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801276:	c9                   	leave  
  801277:	c3                   	ret    

00801278 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801278:	55                   	push   %ebp
  801279:	89 e5                	mov    %esp,%ebp
  80127b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80127e:	8b 45 08             	mov    0x8(%ebp),%eax
  801281:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801284:	90                   	nop
  801285:	8b 45 08             	mov    0x8(%ebp),%eax
  801288:	8d 50 01             	lea    0x1(%eax),%edx
  80128b:	89 55 08             	mov    %edx,0x8(%ebp)
  80128e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801291:	8d 4a 01             	lea    0x1(%edx),%ecx
  801294:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801297:	8a 12                	mov    (%edx),%dl
  801299:	88 10                	mov    %dl,(%eax)
  80129b:	8a 00                	mov    (%eax),%al
  80129d:	84 c0                	test   %al,%al
  80129f:	75 e4                	jne    801285 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8012a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012a4:	c9                   	leave  
  8012a5:	c3                   	ret    

008012a6 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8012a6:	55                   	push   %ebp
  8012a7:	89 e5                	mov    %esp,%ebp
  8012a9:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8012ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8012af:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8012b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012b9:	eb 1f                	jmp    8012da <strncpy+0x34>
		*dst++ = *src;
  8012bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012be:	8d 50 01             	lea    0x1(%eax),%edx
  8012c1:	89 55 08             	mov    %edx,0x8(%ebp)
  8012c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012c7:	8a 12                	mov    (%edx),%dl
  8012c9:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8012cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ce:	8a 00                	mov    (%eax),%al
  8012d0:	84 c0                	test   %al,%al
  8012d2:	74 03                	je     8012d7 <strncpy+0x31>
			src++;
  8012d4:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012d7:	ff 45 fc             	incl   -0x4(%ebp)
  8012da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012dd:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012e0:	72 d9                	jb     8012bb <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8012e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012e5:	c9                   	leave  
  8012e6:	c3                   	ret    

008012e7 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8012e7:	55                   	push   %ebp
  8012e8:	89 e5                	mov    %esp,%ebp
  8012ea:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8012ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8012f3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012f7:	74 30                	je     801329 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8012f9:	eb 16                	jmp    801311 <strlcpy+0x2a>
			*dst++ = *src++;
  8012fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fe:	8d 50 01             	lea    0x1(%eax),%edx
  801301:	89 55 08             	mov    %edx,0x8(%ebp)
  801304:	8b 55 0c             	mov    0xc(%ebp),%edx
  801307:	8d 4a 01             	lea    0x1(%edx),%ecx
  80130a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80130d:	8a 12                	mov    (%edx),%dl
  80130f:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801311:	ff 4d 10             	decl   0x10(%ebp)
  801314:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801318:	74 09                	je     801323 <strlcpy+0x3c>
  80131a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131d:	8a 00                	mov    (%eax),%al
  80131f:	84 c0                	test   %al,%al
  801321:	75 d8                	jne    8012fb <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801323:	8b 45 08             	mov    0x8(%ebp),%eax
  801326:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801329:	8b 55 08             	mov    0x8(%ebp),%edx
  80132c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80132f:	29 c2                	sub    %eax,%edx
  801331:	89 d0                	mov    %edx,%eax
}
  801333:	c9                   	leave  
  801334:	c3                   	ret    

00801335 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801335:	55                   	push   %ebp
  801336:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801338:	eb 06                	jmp    801340 <strcmp+0xb>
		p++, q++;
  80133a:	ff 45 08             	incl   0x8(%ebp)
  80133d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801340:	8b 45 08             	mov    0x8(%ebp),%eax
  801343:	8a 00                	mov    (%eax),%al
  801345:	84 c0                	test   %al,%al
  801347:	74 0e                	je     801357 <strcmp+0x22>
  801349:	8b 45 08             	mov    0x8(%ebp),%eax
  80134c:	8a 10                	mov    (%eax),%dl
  80134e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801351:	8a 00                	mov    (%eax),%al
  801353:	38 c2                	cmp    %al,%dl
  801355:	74 e3                	je     80133a <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801357:	8b 45 08             	mov    0x8(%ebp),%eax
  80135a:	8a 00                	mov    (%eax),%al
  80135c:	0f b6 d0             	movzbl %al,%edx
  80135f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801362:	8a 00                	mov    (%eax),%al
  801364:	0f b6 c0             	movzbl %al,%eax
  801367:	29 c2                	sub    %eax,%edx
  801369:	89 d0                	mov    %edx,%eax
}
  80136b:	5d                   	pop    %ebp
  80136c:	c3                   	ret    

0080136d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80136d:	55                   	push   %ebp
  80136e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801370:	eb 09                	jmp    80137b <strncmp+0xe>
		n--, p++, q++;
  801372:	ff 4d 10             	decl   0x10(%ebp)
  801375:	ff 45 08             	incl   0x8(%ebp)
  801378:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80137b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80137f:	74 17                	je     801398 <strncmp+0x2b>
  801381:	8b 45 08             	mov    0x8(%ebp),%eax
  801384:	8a 00                	mov    (%eax),%al
  801386:	84 c0                	test   %al,%al
  801388:	74 0e                	je     801398 <strncmp+0x2b>
  80138a:	8b 45 08             	mov    0x8(%ebp),%eax
  80138d:	8a 10                	mov    (%eax),%dl
  80138f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801392:	8a 00                	mov    (%eax),%al
  801394:	38 c2                	cmp    %al,%dl
  801396:	74 da                	je     801372 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801398:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80139c:	75 07                	jne    8013a5 <strncmp+0x38>
		return 0;
  80139e:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a3:	eb 14                	jmp    8013b9 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8013a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a8:	8a 00                	mov    (%eax),%al
  8013aa:	0f b6 d0             	movzbl %al,%edx
  8013ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b0:	8a 00                	mov    (%eax),%al
  8013b2:	0f b6 c0             	movzbl %al,%eax
  8013b5:	29 c2                	sub    %eax,%edx
  8013b7:	89 d0                	mov    %edx,%eax
}
  8013b9:	5d                   	pop    %ebp
  8013ba:	c3                   	ret    

008013bb <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8013bb:	55                   	push   %ebp
  8013bc:	89 e5                	mov    %esp,%ebp
  8013be:	83 ec 04             	sub    $0x4,%esp
  8013c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8013c7:	eb 12                	jmp    8013db <strchr+0x20>
		if (*s == c)
  8013c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cc:	8a 00                	mov    (%eax),%al
  8013ce:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8013d1:	75 05                	jne    8013d8 <strchr+0x1d>
			return (char *) s;
  8013d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d6:	eb 11                	jmp    8013e9 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8013d8:	ff 45 08             	incl   0x8(%ebp)
  8013db:	8b 45 08             	mov    0x8(%ebp),%eax
  8013de:	8a 00                	mov    (%eax),%al
  8013e0:	84 c0                	test   %al,%al
  8013e2:	75 e5                	jne    8013c9 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8013e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013e9:	c9                   	leave  
  8013ea:	c3                   	ret    

008013eb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8013eb:	55                   	push   %ebp
  8013ec:	89 e5                	mov    %esp,%ebp
  8013ee:	83 ec 04             	sub    $0x4,%esp
  8013f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8013f7:	eb 0d                	jmp    801406 <strfind+0x1b>
		if (*s == c)
  8013f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fc:	8a 00                	mov    (%eax),%al
  8013fe:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801401:	74 0e                	je     801411 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801403:	ff 45 08             	incl   0x8(%ebp)
  801406:	8b 45 08             	mov    0x8(%ebp),%eax
  801409:	8a 00                	mov    (%eax),%al
  80140b:	84 c0                	test   %al,%al
  80140d:	75 ea                	jne    8013f9 <strfind+0xe>
  80140f:	eb 01                	jmp    801412 <strfind+0x27>
		if (*s == c)
			break;
  801411:	90                   	nop
	return (char *) s;
  801412:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801415:	c9                   	leave  
  801416:	c3                   	ret    

00801417 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801417:	55                   	push   %ebp
  801418:	89 e5                	mov    %esp,%ebp
  80141a:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80141d:	8b 45 08             	mov    0x8(%ebp),%eax
  801420:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801423:	8b 45 10             	mov    0x10(%ebp),%eax
  801426:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801429:	eb 0e                	jmp    801439 <memset+0x22>
		*p++ = c;
  80142b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80142e:	8d 50 01             	lea    0x1(%eax),%edx
  801431:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801434:	8b 55 0c             	mov    0xc(%ebp),%edx
  801437:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801439:	ff 4d f8             	decl   -0x8(%ebp)
  80143c:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801440:	79 e9                	jns    80142b <memset+0x14>
		*p++ = c;

	return v;
  801442:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801445:	c9                   	leave  
  801446:	c3                   	ret    

00801447 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801447:	55                   	push   %ebp
  801448:	89 e5                	mov    %esp,%ebp
  80144a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80144d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801450:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801453:	8b 45 08             	mov    0x8(%ebp),%eax
  801456:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801459:	eb 16                	jmp    801471 <memcpy+0x2a>
		*d++ = *s++;
  80145b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80145e:	8d 50 01             	lea    0x1(%eax),%edx
  801461:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801464:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801467:	8d 4a 01             	lea    0x1(%edx),%ecx
  80146a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80146d:	8a 12                	mov    (%edx),%dl
  80146f:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801471:	8b 45 10             	mov    0x10(%ebp),%eax
  801474:	8d 50 ff             	lea    -0x1(%eax),%edx
  801477:	89 55 10             	mov    %edx,0x10(%ebp)
  80147a:	85 c0                	test   %eax,%eax
  80147c:	75 dd                	jne    80145b <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80147e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801481:	c9                   	leave  
  801482:	c3                   	ret    

00801483 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801483:	55                   	push   %ebp
  801484:	89 e5                	mov    %esp,%ebp
  801486:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801489:	8b 45 0c             	mov    0xc(%ebp),%eax
  80148c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80148f:	8b 45 08             	mov    0x8(%ebp),%eax
  801492:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801495:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801498:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80149b:	73 50                	jae    8014ed <memmove+0x6a>
  80149d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a3:	01 d0                	add    %edx,%eax
  8014a5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8014a8:	76 43                	jbe    8014ed <memmove+0x6a>
		s += n;
  8014aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ad:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8014b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b3:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8014b6:	eb 10                	jmp    8014c8 <memmove+0x45>
			*--d = *--s;
  8014b8:	ff 4d f8             	decl   -0x8(%ebp)
  8014bb:	ff 4d fc             	decl   -0x4(%ebp)
  8014be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014c1:	8a 10                	mov    (%eax),%dl
  8014c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014c6:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8014c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8014cb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014ce:	89 55 10             	mov    %edx,0x10(%ebp)
  8014d1:	85 c0                	test   %eax,%eax
  8014d3:	75 e3                	jne    8014b8 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8014d5:	eb 23                	jmp    8014fa <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8014d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014da:	8d 50 01             	lea    0x1(%eax),%edx
  8014dd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014e3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014e6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8014e9:	8a 12                	mov    (%edx),%dl
  8014eb:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8014ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014f3:	89 55 10             	mov    %edx,0x10(%ebp)
  8014f6:	85 c0                	test   %eax,%eax
  8014f8:	75 dd                	jne    8014d7 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8014fa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014fd:	c9                   	leave  
  8014fe:	c3                   	ret    

008014ff <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8014ff:	55                   	push   %ebp
  801500:	89 e5                	mov    %esp,%ebp
  801502:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801505:	8b 45 08             	mov    0x8(%ebp),%eax
  801508:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80150b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150e:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801511:	eb 2a                	jmp    80153d <memcmp+0x3e>
		if (*s1 != *s2)
  801513:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801516:	8a 10                	mov    (%eax),%dl
  801518:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80151b:	8a 00                	mov    (%eax),%al
  80151d:	38 c2                	cmp    %al,%dl
  80151f:	74 16                	je     801537 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801521:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801524:	8a 00                	mov    (%eax),%al
  801526:	0f b6 d0             	movzbl %al,%edx
  801529:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80152c:	8a 00                	mov    (%eax),%al
  80152e:	0f b6 c0             	movzbl %al,%eax
  801531:	29 c2                	sub    %eax,%edx
  801533:	89 d0                	mov    %edx,%eax
  801535:	eb 18                	jmp    80154f <memcmp+0x50>
		s1++, s2++;
  801537:	ff 45 fc             	incl   -0x4(%ebp)
  80153a:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80153d:	8b 45 10             	mov    0x10(%ebp),%eax
  801540:	8d 50 ff             	lea    -0x1(%eax),%edx
  801543:	89 55 10             	mov    %edx,0x10(%ebp)
  801546:	85 c0                	test   %eax,%eax
  801548:	75 c9                	jne    801513 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80154a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80154f:	c9                   	leave  
  801550:	c3                   	ret    

00801551 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801551:	55                   	push   %ebp
  801552:	89 e5                	mov    %esp,%ebp
  801554:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801557:	8b 55 08             	mov    0x8(%ebp),%edx
  80155a:	8b 45 10             	mov    0x10(%ebp),%eax
  80155d:	01 d0                	add    %edx,%eax
  80155f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801562:	eb 15                	jmp    801579 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801564:	8b 45 08             	mov    0x8(%ebp),%eax
  801567:	8a 00                	mov    (%eax),%al
  801569:	0f b6 d0             	movzbl %al,%edx
  80156c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156f:	0f b6 c0             	movzbl %al,%eax
  801572:	39 c2                	cmp    %eax,%edx
  801574:	74 0d                	je     801583 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801576:	ff 45 08             	incl   0x8(%ebp)
  801579:	8b 45 08             	mov    0x8(%ebp),%eax
  80157c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80157f:	72 e3                	jb     801564 <memfind+0x13>
  801581:	eb 01                	jmp    801584 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801583:	90                   	nop
	return (void *) s;
  801584:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801587:	c9                   	leave  
  801588:	c3                   	ret    

00801589 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801589:	55                   	push   %ebp
  80158a:	89 e5                	mov    %esp,%ebp
  80158c:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80158f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801596:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80159d:	eb 03                	jmp    8015a2 <strtol+0x19>
		s++;
  80159f:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a5:	8a 00                	mov    (%eax),%al
  8015a7:	3c 20                	cmp    $0x20,%al
  8015a9:	74 f4                	je     80159f <strtol+0x16>
  8015ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ae:	8a 00                	mov    (%eax),%al
  8015b0:	3c 09                	cmp    $0x9,%al
  8015b2:	74 eb                	je     80159f <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b7:	8a 00                	mov    (%eax),%al
  8015b9:	3c 2b                	cmp    $0x2b,%al
  8015bb:	75 05                	jne    8015c2 <strtol+0x39>
		s++;
  8015bd:	ff 45 08             	incl   0x8(%ebp)
  8015c0:	eb 13                	jmp    8015d5 <strtol+0x4c>
	else if (*s == '-')
  8015c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c5:	8a 00                	mov    (%eax),%al
  8015c7:	3c 2d                	cmp    $0x2d,%al
  8015c9:	75 0a                	jne    8015d5 <strtol+0x4c>
		s++, neg = 1;
  8015cb:	ff 45 08             	incl   0x8(%ebp)
  8015ce:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015d5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015d9:	74 06                	je     8015e1 <strtol+0x58>
  8015db:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8015df:	75 20                	jne    801601 <strtol+0x78>
  8015e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e4:	8a 00                	mov    (%eax),%al
  8015e6:	3c 30                	cmp    $0x30,%al
  8015e8:	75 17                	jne    801601 <strtol+0x78>
  8015ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ed:	40                   	inc    %eax
  8015ee:	8a 00                	mov    (%eax),%al
  8015f0:	3c 78                	cmp    $0x78,%al
  8015f2:	75 0d                	jne    801601 <strtol+0x78>
		s += 2, base = 16;
  8015f4:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8015f8:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8015ff:	eb 28                	jmp    801629 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801601:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801605:	75 15                	jne    80161c <strtol+0x93>
  801607:	8b 45 08             	mov    0x8(%ebp),%eax
  80160a:	8a 00                	mov    (%eax),%al
  80160c:	3c 30                	cmp    $0x30,%al
  80160e:	75 0c                	jne    80161c <strtol+0x93>
		s++, base = 8;
  801610:	ff 45 08             	incl   0x8(%ebp)
  801613:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80161a:	eb 0d                	jmp    801629 <strtol+0xa0>
	else if (base == 0)
  80161c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801620:	75 07                	jne    801629 <strtol+0xa0>
		base = 10;
  801622:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801629:	8b 45 08             	mov    0x8(%ebp),%eax
  80162c:	8a 00                	mov    (%eax),%al
  80162e:	3c 2f                	cmp    $0x2f,%al
  801630:	7e 19                	jle    80164b <strtol+0xc2>
  801632:	8b 45 08             	mov    0x8(%ebp),%eax
  801635:	8a 00                	mov    (%eax),%al
  801637:	3c 39                	cmp    $0x39,%al
  801639:	7f 10                	jg     80164b <strtol+0xc2>
			dig = *s - '0';
  80163b:	8b 45 08             	mov    0x8(%ebp),%eax
  80163e:	8a 00                	mov    (%eax),%al
  801640:	0f be c0             	movsbl %al,%eax
  801643:	83 e8 30             	sub    $0x30,%eax
  801646:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801649:	eb 42                	jmp    80168d <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80164b:	8b 45 08             	mov    0x8(%ebp),%eax
  80164e:	8a 00                	mov    (%eax),%al
  801650:	3c 60                	cmp    $0x60,%al
  801652:	7e 19                	jle    80166d <strtol+0xe4>
  801654:	8b 45 08             	mov    0x8(%ebp),%eax
  801657:	8a 00                	mov    (%eax),%al
  801659:	3c 7a                	cmp    $0x7a,%al
  80165b:	7f 10                	jg     80166d <strtol+0xe4>
			dig = *s - 'a' + 10;
  80165d:	8b 45 08             	mov    0x8(%ebp),%eax
  801660:	8a 00                	mov    (%eax),%al
  801662:	0f be c0             	movsbl %al,%eax
  801665:	83 e8 57             	sub    $0x57,%eax
  801668:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80166b:	eb 20                	jmp    80168d <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80166d:	8b 45 08             	mov    0x8(%ebp),%eax
  801670:	8a 00                	mov    (%eax),%al
  801672:	3c 40                	cmp    $0x40,%al
  801674:	7e 39                	jle    8016af <strtol+0x126>
  801676:	8b 45 08             	mov    0x8(%ebp),%eax
  801679:	8a 00                	mov    (%eax),%al
  80167b:	3c 5a                	cmp    $0x5a,%al
  80167d:	7f 30                	jg     8016af <strtol+0x126>
			dig = *s - 'A' + 10;
  80167f:	8b 45 08             	mov    0x8(%ebp),%eax
  801682:	8a 00                	mov    (%eax),%al
  801684:	0f be c0             	movsbl %al,%eax
  801687:	83 e8 37             	sub    $0x37,%eax
  80168a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80168d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801690:	3b 45 10             	cmp    0x10(%ebp),%eax
  801693:	7d 19                	jge    8016ae <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801695:	ff 45 08             	incl   0x8(%ebp)
  801698:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80169b:	0f af 45 10          	imul   0x10(%ebp),%eax
  80169f:	89 c2                	mov    %eax,%edx
  8016a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a4:	01 d0                	add    %edx,%eax
  8016a6:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8016a9:	e9 7b ff ff ff       	jmp    801629 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8016ae:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8016af:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016b3:	74 08                	je     8016bd <strtol+0x134>
		*endptr = (char *) s;
  8016b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8016bb:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8016bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8016c1:	74 07                	je     8016ca <strtol+0x141>
  8016c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016c6:	f7 d8                	neg    %eax
  8016c8:	eb 03                	jmp    8016cd <strtol+0x144>
  8016ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8016cd:	c9                   	leave  
  8016ce:	c3                   	ret    

008016cf <ltostr>:

void
ltostr(long value, char *str)
{
  8016cf:	55                   	push   %ebp
  8016d0:	89 e5                	mov    %esp,%ebp
  8016d2:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8016d5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8016dc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8016e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016e7:	79 13                	jns    8016fc <ltostr+0x2d>
	{
		neg = 1;
  8016e9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8016f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f3:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8016f6:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8016f9:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8016fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ff:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801704:	99                   	cltd   
  801705:	f7 f9                	idiv   %ecx
  801707:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80170a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80170d:	8d 50 01             	lea    0x1(%eax),%edx
  801710:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801713:	89 c2                	mov    %eax,%edx
  801715:	8b 45 0c             	mov    0xc(%ebp),%eax
  801718:	01 d0                	add    %edx,%eax
  80171a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80171d:	83 c2 30             	add    $0x30,%edx
  801720:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801722:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801725:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80172a:	f7 e9                	imul   %ecx
  80172c:	c1 fa 02             	sar    $0x2,%edx
  80172f:	89 c8                	mov    %ecx,%eax
  801731:	c1 f8 1f             	sar    $0x1f,%eax
  801734:	29 c2                	sub    %eax,%edx
  801736:	89 d0                	mov    %edx,%eax
  801738:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80173b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80173e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801743:	f7 e9                	imul   %ecx
  801745:	c1 fa 02             	sar    $0x2,%edx
  801748:	89 c8                	mov    %ecx,%eax
  80174a:	c1 f8 1f             	sar    $0x1f,%eax
  80174d:	29 c2                	sub    %eax,%edx
  80174f:	89 d0                	mov    %edx,%eax
  801751:	c1 e0 02             	shl    $0x2,%eax
  801754:	01 d0                	add    %edx,%eax
  801756:	01 c0                	add    %eax,%eax
  801758:	29 c1                	sub    %eax,%ecx
  80175a:	89 ca                	mov    %ecx,%edx
  80175c:	85 d2                	test   %edx,%edx
  80175e:	75 9c                	jne    8016fc <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801760:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801767:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80176a:	48                   	dec    %eax
  80176b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80176e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801772:	74 3d                	je     8017b1 <ltostr+0xe2>
		start = 1 ;
  801774:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80177b:	eb 34                	jmp    8017b1 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80177d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801780:	8b 45 0c             	mov    0xc(%ebp),%eax
  801783:	01 d0                	add    %edx,%eax
  801785:	8a 00                	mov    (%eax),%al
  801787:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80178a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80178d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801790:	01 c2                	add    %eax,%edx
  801792:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801795:	8b 45 0c             	mov    0xc(%ebp),%eax
  801798:	01 c8                	add    %ecx,%eax
  80179a:	8a 00                	mov    (%eax),%al
  80179c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80179e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a4:	01 c2                	add    %eax,%edx
  8017a6:	8a 45 eb             	mov    -0x15(%ebp),%al
  8017a9:	88 02                	mov    %al,(%edx)
		start++ ;
  8017ab:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8017ae:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8017b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017b4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8017b7:	7c c4                	jl     80177d <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8017b9:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8017bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017bf:	01 d0                	add    %edx,%eax
  8017c1:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8017c4:	90                   	nop
  8017c5:	c9                   	leave  
  8017c6:	c3                   	ret    

008017c7 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8017c7:	55                   	push   %ebp
  8017c8:	89 e5                	mov    %esp,%ebp
  8017ca:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8017cd:	ff 75 08             	pushl  0x8(%ebp)
  8017d0:	e8 54 fa ff ff       	call   801229 <strlen>
  8017d5:	83 c4 04             	add    $0x4,%esp
  8017d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8017db:	ff 75 0c             	pushl  0xc(%ebp)
  8017de:	e8 46 fa ff ff       	call   801229 <strlen>
  8017e3:	83 c4 04             	add    $0x4,%esp
  8017e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8017e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8017f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8017f7:	eb 17                	jmp    801810 <strcconcat+0x49>
		final[s] = str1[s] ;
  8017f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ff:	01 c2                	add    %eax,%edx
  801801:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801804:	8b 45 08             	mov    0x8(%ebp),%eax
  801807:	01 c8                	add    %ecx,%eax
  801809:	8a 00                	mov    (%eax),%al
  80180b:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80180d:	ff 45 fc             	incl   -0x4(%ebp)
  801810:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801813:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801816:	7c e1                	jl     8017f9 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801818:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80181f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801826:	eb 1f                	jmp    801847 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801828:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80182b:	8d 50 01             	lea    0x1(%eax),%edx
  80182e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801831:	89 c2                	mov    %eax,%edx
  801833:	8b 45 10             	mov    0x10(%ebp),%eax
  801836:	01 c2                	add    %eax,%edx
  801838:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80183b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80183e:	01 c8                	add    %ecx,%eax
  801840:	8a 00                	mov    (%eax),%al
  801842:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801844:	ff 45 f8             	incl   -0x8(%ebp)
  801847:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80184a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80184d:	7c d9                	jl     801828 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80184f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801852:	8b 45 10             	mov    0x10(%ebp),%eax
  801855:	01 d0                	add    %edx,%eax
  801857:	c6 00 00             	movb   $0x0,(%eax)
}
  80185a:	90                   	nop
  80185b:	c9                   	leave  
  80185c:	c3                   	ret    

0080185d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80185d:	55                   	push   %ebp
  80185e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801860:	8b 45 14             	mov    0x14(%ebp),%eax
  801863:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801869:	8b 45 14             	mov    0x14(%ebp),%eax
  80186c:	8b 00                	mov    (%eax),%eax
  80186e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801875:	8b 45 10             	mov    0x10(%ebp),%eax
  801878:	01 d0                	add    %edx,%eax
  80187a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801880:	eb 0c                	jmp    80188e <strsplit+0x31>
			*string++ = 0;
  801882:	8b 45 08             	mov    0x8(%ebp),%eax
  801885:	8d 50 01             	lea    0x1(%eax),%edx
  801888:	89 55 08             	mov    %edx,0x8(%ebp)
  80188b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80188e:	8b 45 08             	mov    0x8(%ebp),%eax
  801891:	8a 00                	mov    (%eax),%al
  801893:	84 c0                	test   %al,%al
  801895:	74 18                	je     8018af <strsplit+0x52>
  801897:	8b 45 08             	mov    0x8(%ebp),%eax
  80189a:	8a 00                	mov    (%eax),%al
  80189c:	0f be c0             	movsbl %al,%eax
  80189f:	50                   	push   %eax
  8018a0:	ff 75 0c             	pushl  0xc(%ebp)
  8018a3:	e8 13 fb ff ff       	call   8013bb <strchr>
  8018a8:	83 c4 08             	add    $0x8,%esp
  8018ab:	85 c0                	test   %eax,%eax
  8018ad:	75 d3                	jne    801882 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8018af:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b2:	8a 00                	mov    (%eax),%al
  8018b4:	84 c0                	test   %al,%al
  8018b6:	74 5a                	je     801912 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8018b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8018bb:	8b 00                	mov    (%eax),%eax
  8018bd:	83 f8 0f             	cmp    $0xf,%eax
  8018c0:	75 07                	jne    8018c9 <strsplit+0x6c>
		{
			return 0;
  8018c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8018c7:	eb 66                	jmp    80192f <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8018c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8018cc:	8b 00                	mov    (%eax),%eax
  8018ce:	8d 48 01             	lea    0x1(%eax),%ecx
  8018d1:	8b 55 14             	mov    0x14(%ebp),%edx
  8018d4:	89 0a                	mov    %ecx,(%edx)
  8018d6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e0:	01 c2                	add    %eax,%edx
  8018e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e5:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8018e7:	eb 03                	jmp    8018ec <strsplit+0x8f>
			string++;
  8018e9:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8018ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ef:	8a 00                	mov    (%eax),%al
  8018f1:	84 c0                	test   %al,%al
  8018f3:	74 8b                	je     801880 <strsplit+0x23>
  8018f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f8:	8a 00                	mov    (%eax),%al
  8018fa:	0f be c0             	movsbl %al,%eax
  8018fd:	50                   	push   %eax
  8018fe:	ff 75 0c             	pushl  0xc(%ebp)
  801901:	e8 b5 fa ff ff       	call   8013bb <strchr>
  801906:	83 c4 08             	add    $0x8,%esp
  801909:	85 c0                	test   %eax,%eax
  80190b:	74 dc                	je     8018e9 <strsplit+0x8c>
			string++;
	}
  80190d:	e9 6e ff ff ff       	jmp    801880 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801912:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801913:	8b 45 14             	mov    0x14(%ebp),%eax
  801916:	8b 00                	mov    (%eax),%eax
  801918:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80191f:	8b 45 10             	mov    0x10(%ebp),%eax
  801922:	01 d0                	add    %edx,%eax
  801924:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80192a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80192f:	c9                   	leave  
  801930:	c3                   	ret    

00801931 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801931:	55                   	push   %ebp
  801932:	89 e5                	mov    %esp,%ebp
  801934:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801937:	a1 04 50 80 00       	mov    0x805004,%eax
  80193c:	85 c0                	test   %eax,%eax
  80193e:	74 1f                	je     80195f <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801940:	e8 1d 00 00 00       	call   801962 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801945:	83 ec 0c             	sub    $0xc,%esp
  801948:	68 30 44 80 00       	push   $0x804430
  80194d:	e8 55 f2 ff ff       	call   800ba7 <cprintf>
  801952:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801955:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  80195c:	00 00 00 
	}
}
  80195f:	90                   	nop
  801960:	c9                   	leave  
  801961:	c3                   	ret    

00801962 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801962:	55                   	push   %ebp
  801963:	89 e5                	mov    %esp,%ebp
  801965:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  801968:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  80196f:	00 00 00 
  801972:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801979:	00 00 00 
  80197c:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801983:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801986:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  80198d:	00 00 00 
  801990:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801997:	00 00 00 
  80199a:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  8019a1:	00 00 00 
	uint32 arr_size = 0;
  8019a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  8019ab:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  8019b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019b5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8019ba:	2d 00 10 00 00       	sub    $0x1000,%eax
  8019bf:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  8019c4:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  8019cb:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  8019ce:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8019d5:	a1 20 51 80 00       	mov    0x805120,%eax
  8019da:	c1 e0 04             	shl    $0x4,%eax
  8019dd:	89 c2                	mov    %eax,%edx
  8019df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019e2:	01 d0                	add    %edx,%eax
  8019e4:	48                   	dec    %eax
  8019e5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8019e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8019f0:	f7 75 ec             	divl   -0x14(%ebp)
  8019f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019f6:	29 d0                	sub    %edx,%eax
  8019f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  8019fb:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801a02:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a05:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a0a:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a0f:	83 ec 04             	sub    $0x4,%esp
  801a12:	6a 06                	push   $0x6
  801a14:	ff 75 f4             	pushl  -0xc(%ebp)
  801a17:	50                   	push   %eax
  801a18:	e8 fc 04 00 00       	call   801f19 <sys_allocate_chunk>
  801a1d:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801a20:	a1 20 51 80 00       	mov    0x805120,%eax
  801a25:	83 ec 0c             	sub    $0xc,%esp
  801a28:	50                   	push   %eax
  801a29:	e8 71 0b 00 00       	call   80259f <initialize_MemBlocksList>
  801a2e:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  801a31:	a1 48 51 80 00       	mov    0x805148,%eax
  801a36:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  801a39:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a3c:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  801a43:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a46:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  801a4d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801a51:	75 14                	jne    801a67 <initialize_dyn_block_system+0x105>
  801a53:	83 ec 04             	sub    $0x4,%esp
  801a56:	68 55 44 80 00       	push   $0x804455
  801a5b:	6a 33                	push   $0x33
  801a5d:	68 73 44 80 00       	push   $0x804473
  801a62:	e8 8c ee ff ff       	call   8008f3 <_panic>
  801a67:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a6a:	8b 00                	mov    (%eax),%eax
  801a6c:	85 c0                	test   %eax,%eax
  801a6e:	74 10                	je     801a80 <initialize_dyn_block_system+0x11e>
  801a70:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a73:	8b 00                	mov    (%eax),%eax
  801a75:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a78:	8b 52 04             	mov    0x4(%edx),%edx
  801a7b:	89 50 04             	mov    %edx,0x4(%eax)
  801a7e:	eb 0b                	jmp    801a8b <initialize_dyn_block_system+0x129>
  801a80:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a83:	8b 40 04             	mov    0x4(%eax),%eax
  801a86:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801a8b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a8e:	8b 40 04             	mov    0x4(%eax),%eax
  801a91:	85 c0                	test   %eax,%eax
  801a93:	74 0f                	je     801aa4 <initialize_dyn_block_system+0x142>
  801a95:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a98:	8b 40 04             	mov    0x4(%eax),%eax
  801a9b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a9e:	8b 12                	mov    (%edx),%edx
  801aa0:	89 10                	mov    %edx,(%eax)
  801aa2:	eb 0a                	jmp    801aae <initialize_dyn_block_system+0x14c>
  801aa4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801aa7:	8b 00                	mov    (%eax),%eax
  801aa9:	a3 48 51 80 00       	mov    %eax,0x805148
  801aae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ab1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ab7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801aba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ac1:	a1 54 51 80 00       	mov    0x805154,%eax
  801ac6:	48                   	dec    %eax
  801ac7:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  801acc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ad0:	75 14                	jne    801ae6 <initialize_dyn_block_system+0x184>
  801ad2:	83 ec 04             	sub    $0x4,%esp
  801ad5:	68 80 44 80 00       	push   $0x804480
  801ada:	6a 34                	push   $0x34
  801adc:	68 73 44 80 00       	push   $0x804473
  801ae1:	e8 0d ee ff ff       	call   8008f3 <_panic>
  801ae6:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801aec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801aef:	89 10                	mov    %edx,(%eax)
  801af1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801af4:	8b 00                	mov    (%eax),%eax
  801af6:	85 c0                	test   %eax,%eax
  801af8:	74 0d                	je     801b07 <initialize_dyn_block_system+0x1a5>
  801afa:	a1 38 51 80 00       	mov    0x805138,%eax
  801aff:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b02:	89 50 04             	mov    %edx,0x4(%eax)
  801b05:	eb 08                	jmp    801b0f <initialize_dyn_block_system+0x1ad>
  801b07:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b0a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801b0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b12:	a3 38 51 80 00       	mov    %eax,0x805138
  801b17:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b1a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801b21:	a1 44 51 80 00       	mov    0x805144,%eax
  801b26:	40                   	inc    %eax
  801b27:	a3 44 51 80 00       	mov    %eax,0x805144
}
  801b2c:	90                   	nop
  801b2d:	c9                   	leave  
  801b2e:	c3                   	ret    

00801b2f <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801b2f:	55                   	push   %ebp
  801b30:	89 e5                	mov    %esp,%ebp
  801b32:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b35:	e8 f7 fd ff ff       	call   801931 <InitializeUHeap>
	if (size == 0) return NULL ;
  801b3a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b3e:	75 07                	jne    801b47 <malloc+0x18>
  801b40:	b8 00 00 00 00       	mov    $0x0,%eax
  801b45:	eb 61                	jmp    801ba8 <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  801b47:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801b4e:	8b 55 08             	mov    0x8(%ebp),%edx
  801b51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b54:	01 d0                	add    %edx,%eax
  801b56:	48                   	dec    %eax
  801b57:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801b5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b5d:	ba 00 00 00 00       	mov    $0x0,%edx
  801b62:	f7 75 f0             	divl   -0x10(%ebp)
  801b65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b68:	29 d0                	sub    %edx,%eax
  801b6a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801b6d:	e8 75 07 00 00       	call   8022e7 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b72:	85 c0                	test   %eax,%eax
  801b74:	74 11                	je     801b87 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801b76:	83 ec 0c             	sub    $0xc,%esp
  801b79:	ff 75 e8             	pushl  -0x18(%ebp)
  801b7c:	e8 e0 0d 00 00       	call   802961 <alloc_block_FF>
  801b81:	83 c4 10             	add    $0x10,%esp
  801b84:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  801b87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b8b:	74 16                	je     801ba3 <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  801b8d:	83 ec 0c             	sub    $0xc,%esp
  801b90:	ff 75 f4             	pushl  -0xc(%ebp)
  801b93:	e8 3c 0b 00 00       	call   8026d4 <insert_sorted_allocList>
  801b98:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  801b9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b9e:	8b 40 08             	mov    0x8(%eax),%eax
  801ba1:	eb 05                	jmp    801ba8 <malloc+0x79>
	}

    return NULL;
  801ba3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ba8:	c9                   	leave  
  801ba9:	c3                   	ret    

00801baa <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801baa:	55                   	push   %ebp
  801bab:	89 e5                	mov    %esp,%ebp
  801bad:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801bb0:	83 ec 04             	sub    $0x4,%esp
  801bb3:	68 a4 44 80 00       	push   $0x8044a4
  801bb8:	6a 6f                	push   $0x6f
  801bba:	68 73 44 80 00       	push   $0x804473
  801bbf:	e8 2f ed ff ff       	call   8008f3 <_panic>

00801bc4 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801bc4:	55                   	push   %ebp
  801bc5:	89 e5                	mov    %esp,%ebp
  801bc7:	83 ec 38             	sub    $0x38,%esp
  801bca:	8b 45 10             	mov    0x10(%ebp),%eax
  801bcd:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801bd0:	e8 5c fd ff ff       	call   801931 <InitializeUHeap>
	if (size == 0) return NULL ;
  801bd5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801bd9:	75 0a                	jne    801be5 <smalloc+0x21>
  801bdb:	b8 00 00 00 00       	mov    $0x0,%eax
  801be0:	e9 8b 00 00 00       	jmp    801c70 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801be5:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801bec:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bf2:	01 d0                	add    %edx,%eax
  801bf4:	48                   	dec    %eax
  801bf5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801bf8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bfb:	ba 00 00 00 00       	mov    $0x0,%edx
  801c00:	f7 75 f0             	divl   -0x10(%ebp)
  801c03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c06:	29 d0                	sub    %edx,%eax
  801c08:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801c0b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801c12:	e8 d0 06 00 00       	call   8022e7 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801c17:	85 c0                	test   %eax,%eax
  801c19:	74 11                	je     801c2c <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801c1b:	83 ec 0c             	sub    $0xc,%esp
  801c1e:	ff 75 e8             	pushl  -0x18(%ebp)
  801c21:	e8 3b 0d 00 00       	call   802961 <alloc_block_FF>
  801c26:	83 c4 10             	add    $0x10,%esp
  801c29:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  801c2c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c30:	74 39                	je     801c6b <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801c32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c35:	8b 40 08             	mov    0x8(%eax),%eax
  801c38:	89 c2                	mov    %eax,%edx
  801c3a:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801c3e:	52                   	push   %edx
  801c3f:	50                   	push   %eax
  801c40:	ff 75 0c             	pushl  0xc(%ebp)
  801c43:	ff 75 08             	pushl  0x8(%ebp)
  801c46:	e8 21 04 00 00       	call   80206c <sys_createSharedObject>
  801c4b:	83 c4 10             	add    $0x10,%esp
  801c4e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801c51:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801c55:	74 14                	je     801c6b <smalloc+0xa7>
  801c57:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801c5b:	74 0e                	je     801c6b <smalloc+0xa7>
  801c5d:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801c61:	74 08                	je     801c6b <smalloc+0xa7>
			return (void*) mem_block->sva;
  801c63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c66:	8b 40 08             	mov    0x8(%eax),%eax
  801c69:	eb 05                	jmp    801c70 <smalloc+0xac>
	}
	return NULL;
  801c6b:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801c70:	c9                   	leave  
  801c71:	c3                   	ret    

00801c72 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801c72:	55                   	push   %ebp
  801c73:	89 e5                	mov    %esp,%ebp
  801c75:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c78:	e8 b4 fc ff ff       	call   801931 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801c7d:	83 ec 08             	sub    $0x8,%esp
  801c80:	ff 75 0c             	pushl  0xc(%ebp)
  801c83:	ff 75 08             	pushl  0x8(%ebp)
  801c86:	e8 0b 04 00 00       	call   802096 <sys_getSizeOfSharedObject>
  801c8b:	83 c4 10             	add    $0x10,%esp
  801c8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  801c91:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  801c95:	74 76                	je     801d0d <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801c97:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801c9e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ca1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ca4:	01 d0                	add    %edx,%eax
  801ca6:	48                   	dec    %eax
  801ca7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801caa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801cad:	ba 00 00 00 00       	mov    $0x0,%edx
  801cb2:	f7 75 ec             	divl   -0x14(%ebp)
  801cb5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801cb8:	29 d0                	sub    %edx,%eax
  801cba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801cbd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801cc4:	e8 1e 06 00 00       	call   8022e7 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801cc9:	85 c0                	test   %eax,%eax
  801ccb:	74 11                	je     801cde <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801ccd:	83 ec 0c             	sub    $0xc,%esp
  801cd0:	ff 75 e4             	pushl  -0x1c(%ebp)
  801cd3:	e8 89 0c 00 00       	call   802961 <alloc_block_FF>
  801cd8:	83 c4 10             	add    $0x10,%esp
  801cdb:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  801cde:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ce2:	74 29                	je     801d0d <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ce7:	8b 40 08             	mov    0x8(%eax),%eax
  801cea:	83 ec 04             	sub    $0x4,%esp
  801ced:	50                   	push   %eax
  801cee:	ff 75 0c             	pushl  0xc(%ebp)
  801cf1:	ff 75 08             	pushl  0x8(%ebp)
  801cf4:	e8 ba 03 00 00       	call   8020b3 <sys_getSharedObject>
  801cf9:	83 c4 10             	add    $0x10,%esp
  801cfc:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  801cff:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  801d03:	74 08                	je     801d0d <sget+0x9b>
				return (void *)mem_block->sva;
  801d05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d08:	8b 40 08             	mov    0x8(%eax),%eax
  801d0b:	eb 05                	jmp    801d12 <sget+0xa0>
		}
	}
	return NULL;
  801d0d:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801d12:	c9                   	leave  
  801d13:	c3                   	ret    

00801d14 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801d14:	55                   	push   %ebp
  801d15:	89 e5                	mov    %esp,%ebp
  801d17:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d1a:	e8 12 fc ff ff       	call   801931 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801d1f:	83 ec 04             	sub    $0x4,%esp
  801d22:	68 c8 44 80 00       	push   $0x8044c8
  801d27:	68 f1 00 00 00       	push   $0xf1
  801d2c:	68 73 44 80 00       	push   $0x804473
  801d31:	e8 bd eb ff ff       	call   8008f3 <_panic>

00801d36 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801d36:	55                   	push   %ebp
  801d37:	89 e5                	mov    %esp,%ebp
  801d39:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801d3c:	83 ec 04             	sub    $0x4,%esp
  801d3f:	68 f0 44 80 00       	push   $0x8044f0
  801d44:	68 05 01 00 00       	push   $0x105
  801d49:	68 73 44 80 00       	push   $0x804473
  801d4e:	e8 a0 eb ff ff       	call   8008f3 <_panic>

00801d53 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801d53:	55                   	push   %ebp
  801d54:	89 e5                	mov    %esp,%ebp
  801d56:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d59:	83 ec 04             	sub    $0x4,%esp
  801d5c:	68 14 45 80 00       	push   $0x804514
  801d61:	68 10 01 00 00       	push   $0x110
  801d66:	68 73 44 80 00       	push   $0x804473
  801d6b:	e8 83 eb ff ff       	call   8008f3 <_panic>

00801d70 <shrink>:

}
void shrink(uint32 newSize)
{
  801d70:	55                   	push   %ebp
  801d71:	89 e5                	mov    %esp,%ebp
  801d73:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d76:	83 ec 04             	sub    $0x4,%esp
  801d79:	68 14 45 80 00       	push   $0x804514
  801d7e:	68 15 01 00 00       	push   $0x115
  801d83:	68 73 44 80 00       	push   $0x804473
  801d88:	e8 66 eb ff ff       	call   8008f3 <_panic>

00801d8d <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801d8d:	55                   	push   %ebp
  801d8e:	89 e5                	mov    %esp,%ebp
  801d90:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d93:	83 ec 04             	sub    $0x4,%esp
  801d96:	68 14 45 80 00       	push   $0x804514
  801d9b:	68 1a 01 00 00       	push   $0x11a
  801da0:	68 73 44 80 00       	push   $0x804473
  801da5:	e8 49 eb ff ff       	call   8008f3 <_panic>

00801daa <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801daa:	55                   	push   %ebp
  801dab:	89 e5                	mov    %esp,%ebp
  801dad:	57                   	push   %edi
  801dae:	56                   	push   %esi
  801daf:	53                   	push   %ebx
  801db0:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801db3:	8b 45 08             	mov    0x8(%ebp),%eax
  801db6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801db9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dbc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801dbf:	8b 7d 18             	mov    0x18(%ebp),%edi
  801dc2:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801dc5:	cd 30                	int    $0x30
  801dc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801dca:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801dcd:	83 c4 10             	add    $0x10,%esp
  801dd0:	5b                   	pop    %ebx
  801dd1:	5e                   	pop    %esi
  801dd2:	5f                   	pop    %edi
  801dd3:	5d                   	pop    %ebp
  801dd4:	c3                   	ret    

00801dd5 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801dd5:	55                   	push   %ebp
  801dd6:	89 e5                	mov    %esp,%ebp
  801dd8:	83 ec 04             	sub    $0x4,%esp
  801ddb:	8b 45 10             	mov    0x10(%ebp),%eax
  801dde:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801de1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801de5:	8b 45 08             	mov    0x8(%ebp),%eax
  801de8:	6a 00                	push   $0x0
  801dea:	6a 00                	push   $0x0
  801dec:	52                   	push   %edx
  801ded:	ff 75 0c             	pushl  0xc(%ebp)
  801df0:	50                   	push   %eax
  801df1:	6a 00                	push   $0x0
  801df3:	e8 b2 ff ff ff       	call   801daa <syscall>
  801df8:	83 c4 18             	add    $0x18,%esp
}
  801dfb:	90                   	nop
  801dfc:	c9                   	leave  
  801dfd:	c3                   	ret    

00801dfe <sys_cgetc>:

int
sys_cgetc(void)
{
  801dfe:	55                   	push   %ebp
  801dff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801e01:	6a 00                	push   $0x0
  801e03:	6a 00                	push   $0x0
  801e05:	6a 00                	push   $0x0
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 01                	push   $0x1
  801e0d:	e8 98 ff ff ff       	call   801daa <syscall>
  801e12:	83 c4 18             	add    $0x18,%esp
}
  801e15:	c9                   	leave  
  801e16:	c3                   	ret    

00801e17 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801e17:	55                   	push   %ebp
  801e18:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801e1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	52                   	push   %edx
  801e27:	50                   	push   %eax
  801e28:	6a 05                	push   $0x5
  801e2a:	e8 7b ff ff ff       	call   801daa <syscall>
  801e2f:	83 c4 18             	add    $0x18,%esp
}
  801e32:	c9                   	leave  
  801e33:	c3                   	ret    

00801e34 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801e34:	55                   	push   %ebp
  801e35:	89 e5                	mov    %esp,%ebp
  801e37:	56                   	push   %esi
  801e38:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801e39:	8b 75 18             	mov    0x18(%ebp),%esi
  801e3c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e3f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e42:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e45:	8b 45 08             	mov    0x8(%ebp),%eax
  801e48:	56                   	push   %esi
  801e49:	53                   	push   %ebx
  801e4a:	51                   	push   %ecx
  801e4b:	52                   	push   %edx
  801e4c:	50                   	push   %eax
  801e4d:	6a 06                	push   $0x6
  801e4f:	e8 56 ff ff ff       	call   801daa <syscall>
  801e54:	83 c4 18             	add    $0x18,%esp
}
  801e57:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e5a:	5b                   	pop    %ebx
  801e5b:	5e                   	pop    %esi
  801e5c:	5d                   	pop    %ebp
  801e5d:	c3                   	ret    

00801e5e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801e5e:	55                   	push   %ebp
  801e5f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801e61:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e64:	8b 45 08             	mov    0x8(%ebp),%eax
  801e67:	6a 00                	push   $0x0
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 00                	push   $0x0
  801e6d:	52                   	push   %edx
  801e6e:	50                   	push   %eax
  801e6f:	6a 07                	push   $0x7
  801e71:	e8 34 ff ff ff       	call   801daa <syscall>
  801e76:	83 c4 18             	add    $0x18,%esp
}
  801e79:	c9                   	leave  
  801e7a:	c3                   	ret    

00801e7b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801e7b:	55                   	push   %ebp
  801e7c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 00                	push   $0x0
  801e82:	6a 00                	push   $0x0
  801e84:	ff 75 0c             	pushl  0xc(%ebp)
  801e87:	ff 75 08             	pushl  0x8(%ebp)
  801e8a:	6a 08                	push   $0x8
  801e8c:	e8 19 ff ff ff       	call   801daa <syscall>
  801e91:	83 c4 18             	add    $0x18,%esp
}
  801e94:	c9                   	leave  
  801e95:	c3                   	ret    

00801e96 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801e96:	55                   	push   %ebp
  801e97:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 09                	push   $0x9
  801ea5:	e8 00 ff ff ff       	call   801daa <syscall>
  801eaa:	83 c4 18             	add    $0x18,%esp
}
  801ead:	c9                   	leave  
  801eae:	c3                   	ret    

00801eaf <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801eaf:	55                   	push   %ebp
  801eb0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 00                	push   $0x0
  801eba:	6a 00                	push   $0x0
  801ebc:	6a 0a                	push   $0xa
  801ebe:	e8 e7 fe ff ff       	call   801daa <syscall>
  801ec3:	83 c4 18             	add    $0x18,%esp
}
  801ec6:	c9                   	leave  
  801ec7:	c3                   	ret    

00801ec8 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801ec8:	55                   	push   %ebp
  801ec9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801ecb:	6a 00                	push   $0x0
  801ecd:	6a 00                	push   $0x0
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 00                	push   $0x0
  801ed5:	6a 0b                	push   $0xb
  801ed7:	e8 ce fe ff ff       	call   801daa <syscall>
  801edc:	83 c4 18             	add    $0x18,%esp
}
  801edf:	c9                   	leave  
  801ee0:	c3                   	ret    

00801ee1 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801ee1:	55                   	push   %ebp
  801ee2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801ee4:	6a 00                	push   $0x0
  801ee6:	6a 00                	push   $0x0
  801ee8:	6a 00                	push   $0x0
  801eea:	ff 75 0c             	pushl  0xc(%ebp)
  801eed:	ff 75 08             	pushl  0x8(%ebp)
  801ef0:	6a 0f                	push   $0xf
  801ef2:	e8 b3 fe ff ff       	call   801daa <syscall>
  801ef7:	83 c4 18             	add    $0x18,%esp
	return;
  801efa:	90                   	nop
}
  801efb:	c9                   	leave  
  801efc:	c3                   	ret    

00801efd <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801efd:	55                   	push   %ebp
  801efe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801f00:	6a 00                	push   $0x0
  801f02:	6a 00                	push   $0x0
  801f04:	6a 00                	push   $0x0
  801f06:	ff 75 0c             	pushl  0xc(%ebp)
  801f09:	ff 75 08             	pushl  0x8(%ebp)
  801f0c:	6a 10                	push   $0x10
  801f0e:	e8 97 fe ff ff       	call   801daa <syscall>
  801f13:	83 c4 18             	add    $0x18,%esp
	return ;
  801f16:	90                   	nop
}
  801f17:	c9                   	leave  
  801f18:	c3                   	ret    

00801f19 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801f19:	55                   	push   %ebp
  801f1a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801f1c:	6a 00                	push   $0x0
  801f1e:	6a 00                	push   $0x0
  801f20:	ff 75 10             	pushl  0x10(%ebp)
  801f23:	ff 75 0c             	pushl  0xc(%ebp)
  801f26:	ff 75 08             	pushl  0x8(%ebp)
  801f29:	6a 11                	push   $0x11
  801f2b:	e8 7a fe ff ff       	call   801daa <syscall>
  801f30:	83 c4 18             	add    $0x18,%esp
	return ;
  801f33:	90                   	nop
}
  801f34:	c9                   	leave  
  801f35:	c3                   	ret    

00801f36 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801f36:	55                   	push   %ebp
  801f37:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801f39:	6a 00                	push   $0x0
  801f3b:	6a 00                	push   $0x0
  801f3d:	6a 00                	push   $0x0
  801f3f:	6a 00                	push   $0x0
  801f41:	6a 00                	push   $0x0
  801f43:	6a 0c                	push   $0xc
  801f45:	e8 60 fe ff ff       	call   801daa <syscall>
  801f4a:	83 c4 18             	add    $0x18,%esp
}
  801f4d:	c9                   	leave  
  801f4e:	c3                   	ret    

00801f4f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801f4f:	55                   	push   %ebp
  801f50:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801f52:	6a 00                	push   $0x0
  801f54:	6a 00                	push   $0x0
  801f56:	6a 00                	push   $0x0
  801f58:	6a 00                	push   $0x0
  801f5a:	ff 75 08             	pushl  0x8(%ebp)
  801f5d:	6a 0d                	push   $0xd
  801f5f:	e8 46 fe ff ff       	call   801daa <syscall>
  801f64:	83 c4 18             	add    $0x18,%esp
}
  801f67:	c9                   	leave  
  801f68:	c3                   	ret    

00801f69 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801f69:	55                   	push   %ebp
  801f6a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801f6c:	6a 00                	push   $0x0
  801f6e:	6a 00                	push   $0x0
  801f70:	6a 00                	push   $0x0
  801f72:	6a 00                	push   $0x0
  801f74:	6a 00                	push   $0x0
  801f76:	6a 0e                	push   $0xe
  801f78:	e8 2d fe ff ff       	call   801daa <syscall>
  801f7d:	83 c4 18             	add    $0x18,%esp
}
  801f80:	90                   	nop
  801f81:	c9                   	leave  
  801f82:	c3                   	ret    

00801f83 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801f83:	55                   	push   %ebp
  801f84:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801f86:	6a 00                	push   $0x0
  801f88:	6a 00                	push   $0x0
  801f8a:	6a 00                	push   $0x0
  801f8c:	6a 00                	push   $0x0
  801f8e:	6a 00                	push   $0x0
  801f90:	6a 13                	push   $0x13
  801f92:	e8 13 fe ff ff       	call   801daa <syscall>
  801f97:	83 c4 18             	add    $0x18,%esp
}
  801f9a:	90                   	nop
  801f9b:	c9                   	leave  
  801f9c:	c3                   	ret    

00801f9d <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801f9d:	55                   	push   %ebp
  801f9e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801fa0:	6a 00                	push   $0x0
  801fa2:	6a 00                	push   $0x0
  801fa4:	6a 00                	push   $0x0
  801fa6:	6a 00                	push   $0x0
  801fa8:	6a 00                	push   $0x0
  801faa:	6a 14                	push   $0x14
  801fac:	e8 f9 fd ff ff       	call   801daa <syscall>
  801fb1:	83 c4 18             	add    $0x18,%esp
}
  801fb4:	90                   	nop
  801fb5:	c9                   	leave  
  801fb6:	c3                   	ret    

00801fb7 <sys_cputc>:


void
sys_cputc(const char c)
{
  801fb7:	55                   	push   %ebp
  801fb8:	89 e5                	mov    %esp,%ebp
  801fba:	83 ec 04             	sub    $0x4,%esp
  801fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801fc3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801fc7:	6a 00                	push   $0x0
  801fc9:	6a 00                	push   $0x0
  801fcb:	6a 00                	push   $0x0
  801fcd:	6a 00                	push   $0x0
  801fcf:	50                   	push   %eax
  801fd0:	6a 15                	push   $0x15
  801fd2:	e8 d3 fd ff ff       	call   801daa <syscall>
  801fd7:	83 c4 18             	add    $0x18,%esp
}
  801fda:	90                   	nop
  801fdb:	c9                   	leave  
  801fdc:	c3                   	ret    

00801fdd <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801fdd:	55                   	push   %ebp
  801fde:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801fe0:	6a 00                	push   $0x0
  801fe2:	6a 00                	push   $0x0
  801fe4:	6a 00                	push   $0x0
  801fe6:	6a 00                	push   $0x0
  801fe8:	6a 00                	push   $0x0
  801fea:	6a 16                	push   $0x16
  801fec:	e8 b9 fd ff ff       	call   801daa <syscall>
  801ff1:	83 c4 18             	add    $0x18,%esp
}
  801ff4:	90                   	nop
  801ff5:	c9                   	leave  
  801ff6:	c3                   	ret    

00801ff7 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801ff7:	55                   	push   %ebp
  801ff8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffd:	6a 00                	push   $0x0
  801fff:	6a 00                	push   $0x0
  802001:	6a 00                	push   $0x0
  802003:	ff 75 0c             	pushl  0xc(%ebp)
  802006:	50                   	push   %eax
  802007:	6a 17                	push   $0x17
  802009:	e8 9c fd ff ff       	call   801daa <syscall>
  80200e:	83 c4 18             	add    $0x18,%esp
}
  802011:	c9                   	leave  
  802012:	c3                   	ret    

00802013 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802013:	55                   	push   %ebp
  802014:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802016:	8b 55 0c             	mov    0xc(%ebp),%edx
  802019:	8b 45 08             	mov    0x8(%ebp),%eax
  80201c:	6a 00                	push   $0x0
  80201e:	6a 00                	push   $0x0
  802020:	6a 00                	push   $0x0
  802022:	52                   	push   %edx
  802023:	50                   	push   %eax
  802024:	6a 1a                	push   $0x1a
  802026:	e8 7f fd ff ff       	call   801daa <syscall>
  80202b:	83 c4 18             	add    $0x18,%esp
}
  80202e:	c9                   	leave  
  80202f:	c3                   	ret    

00802030 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802030:	55                   	push   %ebp
  802031:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802033:	8b 55 0c             	mov    0xc(%ebp),%edx
  802036:	8b 45 08             	mov    0x8(%ebp),%eax
  802039:	6a 00                	push   $0x0
  80203b:	6a 00                	push   $0x0
  80203d:	6a 00                	push   $0x0
  80203f:	52                   	push   %edx
  802040:	50                   	push   %eax
  802041:	6a 18                	push   $0x18
  802043:	e8 62 fd ff ff       	call   801daa <syscall>
  802048:	83 c4 18             	add    $0x18,%esp
}
  80204b:	90                   	nop
  80204c:	c9                   	leave  
  80204d:	c3                   	ret    

0080204e <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80204e:	55                   	push   %ebp
  80204f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802051:	8b 55 0c             	mov    0xc(%ebp),%edx
  802054:	8b 45 08             	mov    0x8(%ebp),%eax
  802057:	6a 00                	push   $0x0
  802059:	6a 00                	push   $0x0
  80205b:	6a 00                	push   $0x0
  80205d:	52                   	push   %edx
  80205e:	50                   	push   %eax
  80205f:	6a 19                	push   $0x19
  802061:	e8 44 fd ff ff       	call   801daa <syscall>
  802066:	83 c4 18             	add    $0x18,%esp
}
  802069:	90                   	nop
  80206a:	c9                   	leave  
  80206b:	c3                   	ret    

0080206c <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80206c:	55                   	push   %ebp
  80206d:	89 e5                	mov    %esp,%ebp
  80206f:	83 ec 04             	sub    $0x4,%esp
  802072:	8b 45 10             	mov    0x10(%ebp),%eax
  802075:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802078:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80207b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80207f:	8b 45 08             	mov    0x8(%ebp),%eax
  802082:	6a 00                	push   $0x0
  802084:	51                   	push   %ecx
  802085:	52                   	push   %edx
  802086:	ff 75 0c             	pushl  0xc(%ebp)
  802089:	50                   	push   %eax
  80208a:	6a 1b                	push   $0x1b
  80208c:	e8 19 fd ff ff       	call   801daa <syscall>
  802091:	83 c4 18             	add    $0x18,%esp
}
  802094:	c9                   	leave  
  802095:	c3                   	ret    

00802096 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802096:	55                   	push   %ebp
  802097:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802099:	8b 55 0c             	mov    0xc(%ebp),%edx
  80209c:	8b 45 08             	mov    0x8(%ebp),%eax
  80209f:	6a 00                	push   $0x0
  8020a1:	6a 00                	push   $0x0
  8020a3:	6a 00                	push   $0x0
  8020a5:	52                   	push   %edx
  8020a6:	50                   	push   %eax
  8020a7:	6a 1c                	push   $0x1c
  8020a9:	e8 fc fc ff ff       	call   801daa <syscall>
  8020ae:	83 c4 18             	add    $0x18,%esp
}
  8020b1:	c9                   	leave  
  8020b2:	c3                   	ret    

008020b3 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8020b3:	55                   	push   %ebp
  8020b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8020b6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bf:	6a 00                	push   $0x0
  8020c1:	6a 00                	push   $0x0
  8020c3:	51                   	push   %ecx
  8020c4:	52                   	push   %edx
  8020c5:	50                   	push   %eax
  8020c6:	6a 1d                	push   $0x1d
  8020c8:	e8 dd fc ff ff       	call   801daa <syscall>
  8020cd:	83 c4 18             	add    $0x18,%esp
}
  8020d0:	c9                   	leave  
  8020d1:	c3                   	ret    

008020d2 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8020d2:	55                   	push   %ebp
  8020d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8020d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020db:	6a 00                	push   $0x0
  8020dd:	6a 00                	push   $0x0
  8020df:	6a 00                	push   $0x0
  8020e1:	52                   	push   %edx
  8020e2:	50                   	push   %eax
  8020e3:	6a 1e                	push   $0x1e
  8020e5:	e8 c0 fc ff ff       	call   801daa <syscall>
  8020ea:	83 c4 18             	add    $0x18,%esp
}
  8020ed:	c9                   	leave  
  8020ee:	c3                   	ret    

008020ef <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8020ef:	55                   	push   %ebp
  8020f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8020f2:	6a 00                	push   $0x0
  8020f4:	6a 00                	push   $0x0
  8020f6:	6a 00                	push   $0x0
  8020f8:	6a 00                	push   $0x0
  8020fa:	6a 00                	push   $0x0
  8020fc:	6a 1f                	push   $0x1f
  8020fe:	e8 a7 fc ff ff       	call   801daa <syscall>
  802103:	83 c4 18             	add    $0x18,%esp
}
  802106:	c9                   	leave  
  802107:	c3                   	ret    

00802108 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802108:	55                   	push   %ebp
  802109:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80210b:	8b 45 08             	mov    0x8(%ebp),%eax
  80210e:	6a 00                	push   $0x0
  802110:	ff 75 14             	pushl  0x14(%ebp)
  802113:	ff 75 10             	pushl  0x10(%ebp)
  802116:	ff 75 0c             	pushl  0xc(%ebp)
  802119:	50                   	push   %eax
  80211a:	6a 20                	push   $0x20
  80211c:	e8 89 fc ff ff       	call   801daa <syscall>
  802121:	83 c4 18             	add    $0x18,%esp
}
  802124:	c9                   	leave  
  802125:	c3                   	ret    

00802126 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802126:	55                   	push   %ebp
  802127:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802129:	8b 45 08             	mov    0x8(%ebp),%eax
  80212c:	6a 00                	push   $0x0
  80212e:	6a 00                	push   $0x0
  802130:	6a 00                	push   $0x0
  802132:	6a 00                	push   $0x0
  802134:	50                   	push   %eax
  802135:	6a 21                	push   $0x21
  802137:	e8 6e fc ff ff       	call   801daa <syscall>
  80213c:	83 c4 18             	add    $0x18,%esp
}
  80213f:	90                   	nop
  802140:	c9                   	leave  
  802141:	c3                   	ret    

00802142 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802142:	55                   	push   %ebp
  802143:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802145:	8b 45 08             	mov    0x8(%ebp),%eax
  802148:	6a 00                	push   $0x0
  80214a:	6a 00                	push   $0x0
  80214c:	6a 00                	push   $0x0
  80214e:	6a 00                	push   $0x0
  802150:	50                   	push   %eax
  802151:	6a 22                	push   $0x22
  802153:	e8 52 fc ff ff       	call   801daa <syscall>
  802158:	83 c4 18             	add    $0x18,%esp
}
  80215b:	c9                   	leave  
  80215c:	c3                   	ret    

0080215d <sys_getenvid>:

int32 sys_getenvid(void)
{
  80215d:	55                   	push   %ebp
  80215e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802160:	6a 00                	push   $0x0
  802162:	6a 00                	push   $0x0
  802164:	6a 00                	push   $0x0
  802166:	6a 00                	push   $0x0
  802168:	6a 00                	push   $0x0
  80216a:	6a 02                	push   $0x2
  80216c:	e8 39 fc ff ff       	call   801daa <syscall>
  802171:	83 c4 18             	add    $0x18,%esp
}
  802174:	c9                   	leave  
  802175:	c3                   	ret    

00802176 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802176:	55                   	push   %ebp
  802177:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802179:	6a 00                	push   $0x0
  80217b:	6a 00                	push   $0x0
  80217d:	6a 00                	push   $0x0
  80217f:	6a 00                	push   $0x0
  802181:	6a 00                	push   $0x0
  802183:	6a 03                	push   $0x3
  802185:	e8 20 fc ff ff       	call   801daa <syscall>
  80218a:	83 c4 18             	add    $0x18,%esp
}
  80218d:	c9                   	leave  
  80218e:	c3                   	ret    

0080218f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80218f:	55                   	push   %ebp
  802190:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802192:	6a 00                	push   $0x0
  802194:	6a 00                	push   $0x0
  802196:	6a 00                	push   $0x0
  802198:	6a 00                	push   $0x0
  80219a:	6a 00                	push   $0x0
  80219c:	6a 04                	push   $0x4
  80219e:	e8 07 fc ff ff       	call   801daa <syscall>
  8021a3:	83 c4 18             	add    $0x18,%esp
}
  8021a6:	c9                   	leave  
  8021a7:	c3                   	ret    

008021a8 <sys_exit_env>:


void sys_exit_env(void)
{
  8021a8:	55                   	push   %ebp
  8021a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8021ab:	6a 00                	push   $0x0
  8021ad:	6a 00                	push   $0x0
  8021af:	6a 00                	push   $0x0
  8021b1:	6a 00                	push   $0x0
  8021b3:	6a 00                	push   $0x0
  8021b5:	6a 23                	push   $0x23
  8021b7:	e8 ee fb ff ff       	call   801daa <syscall>
  8021bc:	83 c4 18             	add    $0x18,%esp
}
  8021bf:	90                   	nop
  8021c0:	c9                   	leave  
  8021c1:	c3                   	ret    

008021c2 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8021c2:	55                   	push   %ebp
  8021c3:	89 e5                	mov    %esp,%ebp
  8021c5:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8021c8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8021cb:	8d 50 04             	lea    0x4(%eax),%edx
  8021ce:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8021d1:	6a 00                	push   $0x0
  8021d3:	6a 00                	push   $0x0
  8021d5:	6a 00                	push   $0x0
  8021d7:	52                   	push   %edx
  8021d8:	50                   	push   %eax
  8021d9:	6a 24                	push   $0x24
  8021db:	e8 ca fb ff ff       	call   801daa <syscall>
  8021e0:	83 c4 18             	add    $0x18,%esp
	return result;
  8021e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021e9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8021ec:	89 01                	mov    %eax,(%ecx)
  8021ee:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8021f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f4:	c9                   	leave  
  8021f5:	c2 04 00             	ret    $0x4

008021f8 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8021f8:	55                   	push   %ebp
  8021f9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8021fb:	6a 00                	push   $0x0
  8021fd:	6a 00                	push   $0x0
  8021ff:	ff 75 10             	pushl  0x10(%ebp)
  802202:	ff 75 0c             	pushl  0xc(%ebp)
  802205:	ff 75 08             	pushl  0x8(%ebp)
  802208:	6a 12                	push   $0x12
  80220a:	e8 9b fb ff ff       	call   801daa <syscall>
  80220f:	83 c4 18             	add    $0x18,%esp
	return ;
  802212:	90                   	nop
}
  802213:	c9                   	leave  
  802214:	c3                   	ret    

00802215 <sys_rcr2>:
uint32 sys_rcr2()
{
  802215:	55                   	push   %ebp
  802216:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802218:	6a 00                	push   $0x0
  80221a:	6a 00                	push   $0x0
  80221c:	6a 00                	push   $0x0
  80221e:	6a 00                	push   $0x0
  802220:	6a 00                	push   $0x0
  802222:	6a 25                	push   $0x25
  802224:	e8 81 fb ff ff       	call   801daa <syscall>
  802229:	83 c4 18             	add    $0x18,%esp
}
  80222c:	c9                   	leave  
  80222d:	c3                   	ret    

0080222e <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80222e:	55                   	push   %ebp
  80222f:	89 e5                	mov    %esp,%ebp
  802231:	83 ec 04             	sub    $0x4,%esp
  802234:	8b 45 08             	mov    0x8(%ebp),%eax
  802237:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80223a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80223e:	6a 00                	push   $0x0
  802240:	6a 00                	push   $0x0
  802242:	6a 00                	push   $0x0
  802244:	6a 00                	push   $0x0
  802246:	50                   	push   %eax
  802247:	6a 26                	push   $0x26
  802249:	e8 5c fb ff ff       	call   801daa <syscall>
  80224e:	83 c4 18             	add    $0x18,%esp
	return ;
  802251:	90                   	nop
}
  802252:	c9                   	leave  
  802253:	c3                   	ret    

00802254 <rsttst>:
void rsttst()
{
  802254:	55                   	push   %ebp
  802255:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802257:	6a 00                	push   $0x0
  802259:	6a 00                	push   $0x0
  80225b:	6a 00                	push   $0x0
  80225d:	6a 00                	push   $0x0
  80225f:	6a 00                	push   $0x0
  802261:	6a 28                	push   $0x28
  802263:	e8 42 fb ff ff       	call   801daa <syscall>
  802268:	83 c4 18             	add    $0x18,%esp
	return ;
  80226b:	90                   	nop
}
  80226c:	c9                   	leave  
  80226d:	c3                   	ret    

0080226e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80226e:	55                   	push   %ebp
  80226f:	89 e5                	mov    %esp,%ebp
  802271:	83 ec 04             	sub    $0x4,%esp
  802274:	8b 45 14             	mov    0x14(%ebp),%eax
  802277:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80227a:	8b 55 18             	mov    0x18(%ebp),%edx
  80227d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802281:	52                   	push   %edx
  802282:	50                   	push   %eax
  802283:	ff 75 10             	pushl  0x10(%ebp)
  802286:	ff 75 0c             	pushl  0xc(%ebp)
  802289:	ff 75 08             	pushl  0x8(%ebp)
  80228c:	6a 27                	push   $0x27
  80228e:	e8 17 fb ff ff       	call   801daa <syscall>
  802293:	83 c4 18             	add    $0x18,%esp
	return ;
  802296:	90                   	nop
}
  802297:	c9                   	leave  
  802298:	c3                   	ret    

00802299 <chktst>:
void chktst(uint32 n)
{
  802299:	55                   	push   %ebp
  80229a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80229c:	6a 00                	push   $0x0
  80229e:	6a 00                	push   $0x0
  8022a0:	6a 00                	push   $0x0
  8022a2:	6a 00                	push   $0x0
  8022a4:	ff 75 08             	pushl  0x8(%ebp)
  8022a7:	6a 29                	push   $0x29
  8022a9:	e8 fc fa ff ff       	call   801daa <syscall>
  8022ae:	83 c4 18             	add    $0x18,%esp
	return ;
  8022b1:	90                   	nop
}
  8022b2:	c9                   	leave  
  8022b3:	c3                   	ret    

008022b4 <inctst>:

void inctst()
{
  8022b4:	55                   	push   %ebp
  8022b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8022b7:	6a 00                	push   $0x0
  8022b9:	6a 00                	push   $0x0
  8022bb:	6a 00                	push   $0x0
  8022bd:	6a 00                	push   $0x0
  8022bf:	6a 00                	push   $0x0
  8022c1:	6a 2a                	push   $0x2a
  8022c3:	e8 e2 fa ff ff       	call   801daa <syscall>
  8022c8:	83 c4 18             	add    $0x18,%esp
	return ;
  8022cb:	90                   	nop
}
  8022cc:	c9                   	leave  
  8022cd:	c3                   	ret    

008022ce <gettst>:
uint32 gettst()
{
  8022ce:	55                   	push   %ebp
  8022cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8022d1:	6a 00                	push   $0x0
  8022d3:	6a 00                	push   $0x0
  8022d5:	6a 00                	push   $0x0
  8022d7:	6a 00                	push   $0x0
  8022d9:	6a 00                	push   $0x0
  8022db:	6a 2b                	push   $0x2b
  8022dd:	e8 c8 fa ff ff       	call   801daa <syscall>
  8022e2:	83 c4 18             	add    $0x18,%esp
}
  8022e5:	c9                   	leave  
  8022e6:	c3                   	ret    

008022e7 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8022e7:	55                   	push   %ebp
  8022e8:	89 e5                	mov    %esp,%ebp
  8022ea:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022ed:	6a 00                	push   $0x0
  8022ef:	6a 00                	push   $0x0
  8022f1:	6a 00                	push   $0x0
  8022f3:	6a 00                	push   $0x0
  8022f5:	6a 00                	push   $0x0
  8022f7:	6a 2c                	push   $0x2c
  8022f9:	e8 ac fa ff ff       	call   801daa <syscall>
  8022fe:	83 c4 18             	add    $0x18,%esp
  802301:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802304:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802308:	75 07                	jne    802311 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80230a:	b8 01 00 00 00       	mov    $0x1,%eax
  80230f:	eb 05                	jmp    802316 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802311:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802316:	c9                   	leave  
  802317:	c3                   	ret    

00802318 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802318:	55                   	push   %ebp
  802319:	89 e5                	mov    %esp,%ebp
  80231b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80231e:	6a 00                	push   $0x0
  802320:	6a 00                	push   $0x0
  802322:	6a 00                	push   $0x0
  802324:	6a 00                	push   $0x0
  802326:	6a 00                	push   $0x0
  802328:	6a 2c                	push   $0x2c
  80232a:	e8 7b fa ff ff       	call   801daa <syscall>
  80232f:	83 c4 18             	add    $0x18,%esp
  802332:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802335:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802339:	75 07                	jne    802342 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80233b:	b8 01 00 00 00       	mov    $0x1,%eax
  802340:	eb 05                	jmp    802347 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802342:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802347:	c9                   	leave  
  802348:	c3                   	ret    

00802349 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802349:	55                   	push   %ebp
  80234a:	89 e5                	mov    %esp,%ebp
  80234c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80234f:	6a 00                	push   $0x0
  802351:	6a 00                	push   $0x0
  802353:	6a 00                	push   $0x0
  802355:	6a 00                	push   $0x0
  802357:	6a 00                	push   $0x0
  802359:	6a 2c                	push   $0x2c
  80235b:	e8 4a fa ff ff       	call   801daa <syscall>
  802360:	83 c4 18             	add    $0x18,%esp
  802363:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802366:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80236a:	75 07                	jne    802373 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80236c:	b8 01 00 00 00       	mov    $0x1,%eax
  802371:	eb 05                	jmp    802378 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802373:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802378:	c9                   	leave  
  802379:	c3                   	ret    

0080237a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80237a:	55                   	push   %ebp
  80237b:	89 e5                	mov    %esp,%ebp
  80237d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802380:	6a 00                	push   $0x0
  802382:	6a 00                	push   $0x0
  802384:	6a 00                	push   $0x0
  802386:	6a 00                	push   $0x0
  802388:	6a 00                	push   $0x0
  80238a:	6a 2c                	push   $0x2c
  80238c:	e8 19 fa ff ff       	call   801daa <syscall>
  802391:	83 c4 18             	add    $0x18,%esp
  802394:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802397:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80239b:	75 07                	jne    8023a4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80239d:	b8 01 00 00 00       	mov    $0x1,%eax
  8023a2:	eb 05                	jmp    8023a9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8023a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023a9:	c9                   	leave  
  8023aa:	c3                   	ret    

008023ab <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8023ab:	55                   	push   %ebp
  8023ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8023ae:	6a 00                	push   $0x0
  8023b0:	6a 00                	push   $0x0
  8023b2:	6a 00                	push   $0x0
  8023b4:	6a 00                	push   $0x0
  8023b6:	ff 75 08             	pushl  0x8(%ebp)
  8023b9:	6a 2d                	push   $0x2d
  8023bb:	e8 ea f9 ff ff       	call   801daa <syscall>
  8023c0:	83 c4 18             	add    $0x18,%esp
	return ;
  8023c3:	90                   	nop
}
  8023c4:	c9                   	leave  
  8023c5:	c3                   	ret    

008023c6 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8023c6:	55                   	push   %ebp
  8023c7:	89 e5                	mov    %esp,%ebp
  8023c9:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8023ca:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8023cd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8023d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d6:	6a 00                	push   $0x0
  8023d8:	53                   	push   %ebx
  8023d9:	51                   	push   %ecx
  8023da:	52                   	push   %edx
  8023db:	50                   	push   %eax
  8023dc:	6a 2e                	push   $0x2e
  8023de:	e8 c7 f9 ff ff       	call   801daa <syscall>
  8023e3:	83 c4 18             	add    $0x18,%esp
}
  8023e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023e9:	c9                   	leave  
  8023ea:	c3                   	ret    

008023eb <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8023eb:	55                   	push   %ebp
  8023ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8023ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f4:	6a 00                	push   $0x0
  8023f6:	6a 00                	push   $0x0
  8023f8:	6a 00                	push   $0x0
  8023fa:	52                   	push   %edx
  8023fb:	50                   	push   %eax
  8023fc:	6a 2f                	push   $0x2f
  8023fe:	e8 a7 f9 ff ff       	call   801daa <syscall>
  802403:	83 c4 18             	add    $0x18,%esp
}
  802406:	c9                   	leave  
  802407:	c3                   	ret    

00802408 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802408:	55                   	push   %ebp
  802409:	89 e5                	mov    %esp,%ebp
  80240b:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80240e:	83 ec 0c             	sub    $0xc,%esp
  802411:	68 24 45 80 00       	push   $0x804524
  802416:	e8 8c e7 ff ff       	call   800ba7 <cprintf>
  80241b:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80241e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802425:	83 ec 0c             	sub    $0xc,%esp
  802428:	68 50 45 80 00       	push   $0x804550
  80242d:	e8 75 e7 ff ff       	call   800ba7 <cprintf>
  802432:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802435:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802439:	a1 38 51 80 00       	mov    0x805138,%eax
  80243e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802441:	eb 56                	jmp    802499 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802443:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802447:	74 1c                	je     802465 <print_mem_block_lists+0x5d>
  802449:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244c:	8b 50 08             	mov    0x8(%eax),%edx
  80244f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802452:	8b 48 08             	mov    0x8(%eax),%ecx
  802455:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802458:	8b 40 0c             	mov    0xc(%eax),%eax
  80245b:	01 c8                	add    %ecx,%eax
  80245d:	39 c2                	cmp    %eax,%edx
  80245f:	73 04                	jae    802465 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802461:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802465:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802468:	8b 50 08             	mov    0x8(%eax),%edx
  80246b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246e:	8b 40 0c             	mov    0xc(%eax),%eax
  802471:	01 c2                	add    %eax,%edx
  802473:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802476:	8b 40 08             	mov    0x8(%eax),%eax
  802479:	83 ec 04             	sub    $0x4,%esp
  80247c:	52                   	push   %edx
  80247d:	50                   	push   %eax
  80247e:	68 65 45 80 00       	push   $0x804565
  802483:	e8 1f e7 ff ff       	call   800ba7 <cprintf>
  802488:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80248b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802491:	a1 40 51 80 00       	mov    0x805140,%eax
  802496:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802499:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80249d:	74 07                	je     8024a6 <print_mem_block_lists+0x9e>
  80249f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a2:	8b 00                	mov    (%eax),%eax
  8024a4:	eb 05                	jmp    8024ab <print_mem_block_lists+0xa3>
  8024a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8024ab:	a3 40 51 80 00       	mov    %eax,0x805140
  8024b0:	a1 40 51 80 00       	mov    0x805140,%eax
  8024b5:	85 c0                	test   %eax,%eax
  8024b7:	75 8a                	jne    802443 <print_mem_block_lists+0x3b>
  8024b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024bd:	75 84                	jne    802443 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8024bf:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8024c3:	75 10                	jne    8024d5 <print_mem_block_lists+0xcd>
  8024c5:	83 ec 0c             	sub    $0xc,%esp
  8024c8:	68 74 45 80 00       	push   $0x804574
  8024cd:	e8 d5 e6 ff ff       	call   800ba7 <cprintf>
  8024d2:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8024d5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8024dc:	83 ec 0c             	sub    $0xc,%esp
  8024df:	68 98 45 80 00       	push   $0x804598
  8024e4:	e8 be e6 ff ff       	call   800ba7 <cprintf>
  8024e9:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8024ec:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8024f0:	a1 40 50 80 00       	mov    0x805040,%eax
  8024f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024f8:	eb 56                	jmp    802550 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8024fa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024fe:	74 1c                	je     80251c <print_mem_block_lists+0x114>
  802500:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802503:	8b 50 08             	mov    0x8(%eax),%edx
  802506:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802509:	8b 48 08             	mov    0x8(%eax),%ecx
  80250c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80250f:	8b 40 0c             	mov    0xc(%eax),%eax
  802512:	01 c8                	add    %ecx,%eax
  802514:	39 c2                	cmp    %eax,%edx
  802516:	73 04                	jae    80251c <print_mem_block_lists+0x114>
			sorted = 0 ;
  802518:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80251c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251f:	8b 50 08             	mov    0x8(%eax),%edx
  802522:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802525:	8b 40 0c             	mov    0xc(%eax),%eax
  802528:	01 c2                	add    %eax,%edx
  80252a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252d:	8b 40 08             	mov    0x8(%eax),%eax
  802530:	83 ec 04             	sub    $0x4,%esp
  802533:	52                   	push   %edx
  802534:	50                   	push   %eax
  802535:	68 65 45 80 00       	push   $0x804565
  80253a:	e8 68 e6 ff ff       	call   800ba7 <cprintf>
  80253f:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802542:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802545:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802548:	a1 48 50 80 00       	mov    0x805048,%eax
  80254d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802550:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802554:	74 07                	je     80255d <print_mem_block_lists+0x155>
  802556:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802559:	8b 00                	mov    (%eax),%eax
  80255b:	eb 05                	jmp    802562 <print_mem_block_lists+0x15a>
  80255d:	b8 00 00 00 00       	mov    $0x0,%eax
  802562:	a3 48 50 80 00       	mov    %eax,0x805048
  802567:	a1 48 50 80 00       	mov    0x805048,%eax
  80256c:	85 c0                	test   %eax,%eax
  80256e:	75 8a                	jne    8024fa <print_mem_block_lists+0xf2>
  802570:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802574:	75 84                	jne    8024fa <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802576:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80257a:	75 10                	jne    80258c <print_mem_block_lists+0x184>
  80257c:	83 ec 0c             	sub    $0xc,%esp
  80257f:	68 b0 45 80 00       	push   $0x8045b0
  802584:	e8 1e e6 ff ff       	call   800ba7 <cprintf>
  802589:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80258c:	83 ec 0c             	sub    $0xc,%esp
  80258f:	68 24 45 80 00       	push   $0x804524
  802594:	e8 0e e6 ff ff       	call   800ba7 <cprintf>
  802599:	83 c4 10             	add    $0x10,%esp

}
  80259c:	90                   	nop
  80259d:	c9                   	leave  
  80259e:	c3                   	ret    

0080259f <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80259f:	55                   	push   %ebp
  8025a0:	89 e5                	mov    %esp,%ebp
  8025a2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8025a5:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8025ac:	00 00 00 
  8025af:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8025b6:	00 00 00 
  8025b9:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8025c0:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8025c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8025ca:	e9 9e 00 00 00       	jmp    80266d <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8025cf:	a1 50 50 80 00       	mov    0x805050,%eax
  8025d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025d7:	c1 e2 04             	shl    $0x4,%edx
  8025da:	01 d0                	add    %edx,%eax
  8025dc:	85 c0                	test   %eax,%eax
  8025de:	75 14                	jne    8025f4 <initialize_MemBlocksList+0x55>
  8025e0:	83 ec 04             	sub    $0x4,%esp
  8025e3:	68 d8 45 80 00       	push   $0x8045d8
  8025e8:	6a 46                	push   $0x46
  8025ea:	68 fb 45 80 00       	push   $0x8045fb
  8025ef:	e8 ff e2 ff ff       	call   8008f3 <_panic>
  8025f4:	a1 50 50 80 00       	mov    0x805050,%eax
  8025f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025fc:	c1 e2 04             	shl    $0x4,%edx
  8025ff:	01 d0                	add    %edx,%eax
  802601:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802607:	89 10                	mov    %edx,(%eax)
  802609:	8b 00                	mov    (%eax),%eax
  80260b:	85 c0                	test   %eax,%eax
  80260d:	74 18                	je     802627 <initialize_MemBlocksList+0x88>
  80260f:	a1 48 51 80 00       	mov    0x805148,%eax
  802614:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80261a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80261d:	c1 e1 04             	shl    $0x4,%ecx
  802620:	01 ca                	add    %ecx,%edx
  802622:	89 50 04             	mov    %edx,0x4(%eax)
  802625:	eb 12                	jmp    802639 <initialize_MemBlocksList+0x9a>
  802627:	a1 50 50 80 00       	mov    0x805050,%eax
  80262c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80262f:	c1 e2 04             	shl    $0x4,%edx
  802632:	01 d0                	add    %edx,%eax
  802634:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802639:	a1 50 50 80 00       	mov    0x805050,%eax
  80263e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802641:	c1 e2 04             	shl    $0x4,%edx
  802644:	01 d0                	add    %edx,%eax
  802646:	a3 48 51 80 00       	mov    %eax,0x805148
  80264b:	a1 50 50 80 00       	mov    0x805050,%eax
  802650:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802653:	c1 e2 04             	shl    $0x4,%edx
  802656:	01 d0                	add    %edx,%eax
  802658:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80265f:	a1 54 51 80 00       	mov    0x805154,%eax
  802664:	40                   	inc    %eax
  802665:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  80266a:	ff 45 f4             	incl   -0xc(%ebp)
  80266d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802670:	3b 45 08             	cmp    0x8(%ebp),%eax
  802673:	0f 82 56 ff ff ff    	jb     8025cf <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802679:	90                   	nop
  80267a:	c9                   	leave  
  80267b:	c3                   	ret    

0080267c <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80267c:	55                   	push   %ebp
  80267d:	89 e5                	mov    %esp,%ebp
  80267f:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802682:	8b 45 08             	mov    0x8(%ebp),%eax
  802685:	8b 00                	mov    (%eax),%eax
  802687:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80268a:	eb 19                	jmp    8026a5 <find_block+0x29>
	{
		if(va==point->sva)
  80268c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80268f:	8b 40 08             	mov    0x8(%eax),%eax
  802692:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802695:	75 05                	jne    80269c <find_block+0x20>
		   return point;
  802697:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80269a:	eb 36                	jmp    8026d2 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80269c:	8b 45 08             	mov    0x8(%ebp),%eax
  80269f:	8b 40 08             	mov    0x8(%eax),%eax
  8026a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8026a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8026a9:	74 07                	je     8026b2 <find_block+0x36>
  8026ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8026ae:	8b 00                	mov    (%eax),%eax
  8026b0:	eb 05                	jmp    8026b7 <find_block+0x3b>
  8026b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8026ba:	89 42 08             	mov    %eax,0x8(%edx)
  8026bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c0:	8b 40 08             	mov    0x8(%eax),%eax
  8026c3:	85 c0                	test   %eax,%eax
  8026c5:	75 c5                	jne    80268c <find_block+0x10>
  8026c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8026cb:	75 bf                	jne    80268c <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8026cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026d2:	c9                   	leave  
  8026d3:	c3                   	ret    

008026d4 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8026d4:	55                   	push   %ebp
  8026d5:	89 e5                	mov    %esp,%ebp
  8026d7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8026da:	a1 40 50 80 00       	mov    0x805040,%eax
  8026df:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8026e2:	a1 44 50 80 00       	mov    0x805044,%eax
  8026e7:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8026ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ed:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8026f0:	74 24                	je     802716 <insert_sorted_allocList+0x42>
  8026f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f5:	8b 50 08             	mov    0x8(%eax),%edx
  8026f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026fb:	8b 40 08             	mov    0x8(%eax),%eax
  8026fe:	39 c2                	cmp    %eax,%edx
  802700:	76 14                	jbe    802716 <insert_sorted_allocList+0x42>
  802702:	8b 45 08             	mov    0x8(%ebp),%eax
  802705:	8b 50 08             	mov    0x8(%eax),%edx
  802708:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80270b:	8b 40 08             	mov    0x8(%eax),%eax
  80270e:	39 c2                	cmp    %eax,%edx
  802710:	0f 82 60 01 00 00    	jb     802876 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802716:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80271a:	75 65                	jne    802781 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80271c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802720:	75 14                	jne    802736 <insert_sorted_allocList+0x62>
  802722:	83 ec 04             	sub    $0x4,%esp
  802725:	68 d8 45 80 00       	push   $0x8045d8
  80272a:	6a 6b                	push   $0x6b
  80272c:	68 fb 45 80 00       	push   $0x8045fb
  802731:	e8 bd e1 ff ff       	call   8008f3 <_panic>
  802736:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80273c:	8b 45 08             	mov    0x8(%ebp),%eax
  80273f:	89 10                	mov    %edx,(%eax)
  802741:	8b 45 08             	mov    0x8(%ebp),%eax
  802744:	8b 00                	mov    (%eax),%eax
  802746:	85 c0                	test   %eax,%eax
  802748:	74 0d                	je     802757 <insert_sorted_allocList+0x83>
  80274a:	a1 40 50 80 00       	mov    0x805040,%eax
  80274f:	8b 55 08             	mov    0x8(%ebp),%edx
  802752:	89 50 04             	mov    %edx,0x4(%eax)
  802755:	eb 08                	jmp    80275f <insert_sorted_allocList+0x8b>
  802757:	8b 45 08             	mov    0x8(%ebp),%eax
  80275a:	a3 44 50 80 00       	mov    %eax,0x805044
  80275f:	8b 45 08             	mov    0x8(%ebp),%eax
  802762:	a3 40 50 80 00       	mov    %eax,0x805040
  802767:	8b 45 08             	mov    0x8(%ebp),%eax
  80276a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802771:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802776:	40                   	inc    %eax
  802777:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80277c:	e9 dc 01 00 00       	jmp    80295d <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802781:	8b 45 08             	mov    0x8(%ebp),%eax
  802784:	8b 50 08             	mov    0x8(%eax),%edx
  802787:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80278a:	8b 40 08             	mov    0x8(%eax),%eax
  80278d:	39 c2                	cmp    %eax,%edx
  80278f:	77 6c                	ja     8027fd <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802791:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802795:	74 06                	je     80279d <insert_sorted_allocList+0xc9>
  802797:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80279b:	75 14                	jne    8027b1 <insert_sorted_allocList+0xdd>
  80279d:	83 ec 04             	sub    $0x4,%esp
  8027a0:	68 14 46 80 00       	push   $0x804614
  8027a5:	6a 6f                	push   $0x6f
  8027a7:	68 fb 45 80 00       	push   $0x8045fb
  8027ac:	e8 42 e1 ff ff       	call   8008f3 <_panic>
  8027b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b4:	8b 50 04             	mov    0x4(%eax),%edx
  8027b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ba:	89 50 04             	mov    %edx,0x4(%eax)
  8027bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027c3:	89 10                	mov    %edx,(%eax)
  8027c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c8:	8b 40 04             	mov    0x4(%eax),%eax
  8027cb:	85 c0                	test   %eax,%eax
  8027cd:	74 0d                	je     8027dc <insert_sorted_allocList+0x108>
  8027cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d2:	8b 40 04             	mov    0x4(%eax),%eax
  8027d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8027d8:	89 10                	mov    %edx,(%eax)
  8027da:	eb 08                	jmp    8027e4 <insert_sorted_allocList+0x110>
  8027dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027df:	a3 40 50 80 00       	mov    %eax,0x805040
  8027e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8027ea:	89 50 04             	mov    %edx,0x4(%eax)
  8027ed:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8027f2:	40                   	inc    %eax
  8027f3:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8027f8:	e9 60 01 00 00       	jmp    80295d <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8027fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802800:	8b 50 08             	mov    0x8(%eax),%edx
  802803:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802806:	8b 40 08             	mov    0x8(%eax),%eax
  802809:	39 c2                	cmp    %eax,%edx
  80280b:	0f 82 4c 01 00 00    	jb     80295d <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802811:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802815:	75 14                	jne    80282b <insert_sorted_allocList+0x157>
  802817:	83 ec 04             	sub    $0x4,%esp
  80281a:	68 4c 46 80 00       	push   $0x80464c
  80281f:	6a 73                	push   $0x73
  802821:	68 fb 45 80 00       	push   $0x8045fb
  802826:	e8 c8 e0 ff ff       	call   8008f3 <_panic>
  80282b:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802831:	8b 45 08             	mov    0x8(%ebp),%eax
  802834:	89 50 04             	mov    %edx,0x4(%eax)
  802837:	8b 45 08             	mov    0x8(%ebp),%eax
  80283a:	8b 40 04             	mov    0x4(%eax),%eax
  80283d:	85 c0                	test   %eax,%eax
  80283f:	74 0c                	je     80284d <insert_sorted_allocList+0x179>
  802841:	a1 44 50 80 00       	mov    0x805044,%eax
  802846:	8b 55 08             	mov    0x8(%ebp),%edx
  802849:	89 10                	mov    %edx,(%eax)
  80284b:	eb 08                	jmp    802855 <insert_sorted_allocList+0x181>
  80284d:	8b 45 08             	mov    0x8(%ebp),%eax
  802850:	a3 40 50 80 00       	mov    %eax,0x805040
  802855:	8b 45 08             	mov    0x8(%ebp),%eax
  802858:	a3 44 50 80 00       	mov    %eax,0x805044
  80285d:	8b 45 08             	mov    0x8(%ebp),%eax
  802860:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802866:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80286b:	40                   	inc    %eax
  80286c:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802871:	e9 e7 00 00 00       	jmp    80295d <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802876:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802879:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80287c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802883:	a1 40 50 80 00       	mov    0x805040,%eax
  802888:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80288b:	e9 9d 00 00 00       	jmp    80292d <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802890:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802893:	8b 00                	mov    (%eax),%eax
  802895:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802898:	8b 45 08             	mov    0x8(%ebp),%eax
  80289b:	8b 50 08             	mov    0x8(%eax),%edx
  80289e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a1:	8b 40 08             	mov    0x8(%eax),%eax
  8028a4:	39 c2                	cmp    %eax,%edx
  8028a6:	76 7d                	jbe    802925 <insert_sorted_allocList+0x251>
  8028a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ab:	8b 50 08             	mov    0x8(%eax),%edx
  8028ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028b1:	8b 40 08             	mov    0x8(%eax),%eax
  8028b4:	39 c2                	cmp    %eax,%edx
  8028b6:	73 6d                	jae    802925 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8028b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028bc:	74 06                	je     8028c4 <insert_sorted_allocList+0x1f0>
  8028be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028c2:	75 14                	jne    8028d8 <insert_sorted_allocList+0x204>
  8028c4:	83 ec 04             	sub    $0x4,%esp
  8028c7:	68 70 46 80 00       	push   $0x804670
  8028cc:	6a 7f                	push   $0x7f
  8028ce:	68 fb 45 80 00       	push   $0x8045fb
  8028d3:	e8 1b e0 ff ff       	call   8008f3 <_panic>
  8028d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028db:	8b 10                	mov    (%eax),%edx
  8028dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e0:	89 10                	mov    %edx,(%eax)
  8028e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e5:	8b 00                	mov    (%eax),%eax
  8028e7:	85 c0                	test   %eax,%eax
  8028e9:	74 0b                	je     8028f6 <insert_sorted_allocList+0x222>
  8028eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ee:	8b 00                	mov    (%eax),%eax
  8028f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8028f3:	89 50 04             	mov    %edx,0x4(%eax)
  8028f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8028fc:	89 10                	mov    %edx,(%eax)
  8028fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802901:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802904:	89 50 04             	mov    %edx,0x4(%eax)
  802907:	8b 45 08             	mov    0x8(%ebp),%eax
  80290a:	8b 00                	mov    (%eax),%eax
  80290c:	85 c0                	test   %eax,%eax
  80290e:	75 08                	jne    802918 <insert_sorted_allocList+0x244>
  802910:	8b 45 08             	mov    0x8(%ebp),%eax
  802913:	a3 44 50 80 00       	mov    %eax,0x805044
  802918:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80291d:	40                   	inc    %eax
  80291e:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802923:	eb 39                	jmp    80295e <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802925:	a1 48 50 80 00       	mov    0x805048,%eax
  80292a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80292d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802931:	74 07                	je     80293a <insert_sorted_allocList+0x266>
  802933:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802936:	8b 00                	mov    (%eax),%eax
  802938:	eb 05                	jmp    80293f <insert_sorted_allocList+0x26b>
  80293a:	b8 00 00 00 00       	mov    $0x0,%eax
  80293f:	a3 48 50 80 00       	mov    %eax,0x805048
  802944:	a1 48 50 80 00       	mov    0x805048,%eax
  802949:	85 c0                	test   %eax,%eax
  80294b:	0f 85 3f ff ff ff    	jne    802890 <insert_sorted_allocList+0x1bc>
  802951:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802955:	0f 85 35 ff ff ff    	jne    802890 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80295b:	eb 01                	jmp    80295e <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80295d:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80295e:	90                   	nop
  80295f:	c9                   	leave  
  802960:	c3                   	ret    

00802961 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802961:	55                   	push   %ebp
  802962:	89 e5                	mov    %esp,%ebp
  802964:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802967:	a1 38 51 80 00       	mov    0x805138,%eax
  80296c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80296f:	e9 85 01 00 00       	jmp    802af9 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802974:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802977:	8b 40 0c             	mov    0xc(%eax),%eax
  80297a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80297d:	0f 82 6e 01 00 00    	jb     802af1 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802983:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802986:	8b 40 0c             	mov    0xc(%eax),%eax
  802989:	3b 45 08             	cmp    0x8(%ebp),%eax
  80298c:	0f 85 8a 00 00 00    	jne    802a1c <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802992:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802996:	75 17                	jne    8029af <alloc_block_FF+0x4e>
  802998:	83 ec 04             	sub    $0x4,%esp
  80299b:	68 a4 46 80 00       	push   $0x8046a4
  8029a0:	68 93 00 00 00       	push   $0x93
  8029a5:	68 fb 45 80 00       	push   $0x8045fb
  8029aa:	e8 44 df ff ff       	call   8008f3 <_panic>
  8029af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b2:	8b 00                	mov    (%eax),%eax
  8029b4:	85 c0                	test   %eax,%eax
  8029b6:	74 10                	je     8029c8 <alloc_block_FF+0x67>
  8029b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bb:	8b 00                	mov    (%eax),%eax
  8029bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029c0:	8b 52 04             	mov    0x4(%edx),%edx
  8029c3:	89 50 04             	mov    %edx,0x4(%eax)
  8029c6:	eb 0b                	jmp    8029d3 <alloc_block_FF+0x72>
  8029c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cb:	8b 40 04             	mov    0x4(%eax),%eax
  8029ce:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8029d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d6:	8b 40 04             	mov    0x4(%eax),%eax
  8029d9:	85 c0                	test   %eax,%eax
  8029db:	74 0f                	je     8029ec <alloc_block_FF+0x8b>
  8029dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e0:	8b 40 04             	mov    0x4(%eax),%eax
  8029e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029e6:	8b 12                	mov    (%edx),%edx
  8029e8:	89 10                	mov    %edx,(%eax)
  8029ea:	eb 0a                	jmp    8029f6 <alloc_block_FF+0x95>
  8029ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ef:	8b 00                	mov    (%eax),%eax
  8029f1:	a3 38 51 80 00       	mov    %eax,0x805138
  8029f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a02:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a09:	a1 44 51 80 00       	mov    0x805144,%eax
  802a0e:	48                   	dec    %eax
  802a0f:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a17:	e9 10 01 00 00       	jmp    802b2c <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1f:	8b 40 0c             	mov    0xc(%eax),%eax
  802a22:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a25:	0f 86 c6 00 00 00    	jbe    802af1 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a2b:	a1 48 51 80 00       	mov    0x805148,%eax
  802a30:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a36:	8b 50 08             	mov    0x8(%eax),%edx
  802a39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a3c:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802a3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a42:	8b 55 08             	mov    0x8(%ebp),%edx
  802a45:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802a48:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a4c:	75 17                	jne    802a65 <alloc_block_FF+0x104>
  802a4e:	83 ec 04             	sub    $0x4,%esp
  802a51:	68 a4 46 80 00       	push   $0x8046a4
  802a56:	68 9b 00 00 00       	push   $0x9b
  802a5b:	68 fb 45 80 00       	push   $0x8045fb
  802a60:	e8 8e de ff ff       	call   8008f3 <_panic>
  802a65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a68:	8b 00                	mov    (%eax),%eax
  802a6a:	85 c0                	test   %eax,%eax
  802a6c:	74 10                	je     802a7e <alloc_block_FF+0x11d>
  802a6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a71:	8b 00                	mov    (%eax),%eax
  802a73:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a76:	8b 52 04             	mov    0x4(%edx),%edx
  802a79:	89 50 04             	mov    %edx,0x4(%eax)
  802a7c:	eb 0b                	jmp    802a89 <alloc_block_FF+0x128>
  802a7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a81:	8b 40 04             	mov    0x4(%eax),%eax
  802a84:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a8c:	8b 40 04             	mov    0x4(%eax),%eax
  802a8f:	85 c0                	test   %eax,%eax
  802a91:	74 0f                	je     802aa2 <alloc_block_FF+0x141>
  802a93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a96:	8b 40 04             	mov    0x4(%eax),%eax
  802a99:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a9c:	8b 12                	mov    (%edx),%edx
  802a9e:	89 10                	mov    %edx,(%eax)
  802aa0:	eb 0a                	jmp    802aac <alloc_block_FF+0x14b>
  802aa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa5:	8b 00                	mov    (%eax),%eax
  802aa7:	a3 48 51 80 00       	mov    %eax,0x805148
  802aac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aaf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ab5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802abf:	a1 54 51 80 00       	mov    0x805154,%eax
  802ac4:	48                   	dec    %eax
  802ac5:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acd:	8b 50 08             	mov    0x8(%eax),%edx
  802ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad3:	01 c2                	add    %eax,%edx
  802ad5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad8:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ade:	8b 40 0c             	mov    0xc(%eax),%eax
  802ae1:	2b 45 08             	sub    0x8(%ebp),%eax
  802ae4:	89 c2                	mov    %eax,%edx
  802ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae9:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802aec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aef:	eb 3b                	jmp    802b2c <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802af1:	a1 40 51 80 00       	mov    0x805140,%eax
  802af6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802af9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802afd:	74 07                	je     802b06 <alloc_block_FF+0x1a5>
  802aff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b02:	8b 00                	mov    (%eax),%eax
  802b04:	eb 05                	jmp    802b0b <alloc_block_FF+0x1aa>
  802b06:	b8 00 00 00 00       	mov    $0x0,%eax
  802b0b:	a3 40 51 80 00       	mov    %eax,0x805140
  802b10:	a1 40 51 80 00       	mov    0x805140,%eax
  802b15:	85 c0                	test   %eax,%eax
  802b17:	0f 85 57 fe ff ff    	jne    802974 <alloc_block_FF+0x13>
  802b1d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b21:	0f 85 4d fe ff ff    	jne    802974 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802b27:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b2c:	c9                   	leave  
  802b2d:	c3                   	ret    

00802b2e <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802b2e:	55                   	push   %ebp
  802b2f:	89 e5                	mov    %esp,%ebp
  802b31:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802b34:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802b3b:	a1 38 51 80 00       	mov    0x805138,%eax
  802b40:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b43:	e9 df 00 00 00       	jmp    802c27 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802b48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4b:	8b 40 0c             	mov    0xc(%eax),%eax
  802b4e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b51:	0f 82 c8 00 00 00    	jb     802c1f <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802b57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5a:	8b 40 0c             	mov    0xc(%eax),%eax
  802b5d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b60:	0f 85 8a 00 00 00    	jne    802bf0 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802b66:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b6a:	75 17                	jne    802b83 <alloc_block_BF+0x55>
  802b6c:	83 ec 04             	sub    $0x4,%esp
  802b6f:	68 a4 46 80 00       	push   $0x8046a4
  802b74:	68 b7 00 00 00       	push   $0xb7
  802b79:	68 fb 45 80 00       	push   $0x8045fb
  802b7e:	e8 70 dd ff ff       	call   8008f3 <_panic>
  802b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b86:	8b 00                	mov    (%eax),%eax
  802b88:	85 c0                	test   %eax,%eax
  802b8a:	74 10                	je     802b9c <alloc_block_BF+0x6e>
  802b8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8f:	8b 00                	mov    (%eax),%eax
  802b91:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b94:	8b 52 04             	mov    0x4(%edx),%edx
  802b97:	89 50 04             	mov    %edx,0x4(%eax)
  802b9a:	eb 0b                	jmp    802ba7 <alloc_block_BF+0x79>
  802b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9f:	8b 40 04             	mov    0x4(%eax),%eax
  802ba2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802baa:	8b 40 04             	mov    0x4(%eax),%eax
  802bad:	85 c0                	test   %eax,%eax
  802baf:	74 0f                	je     802bc0 <alloc_block_BF+0x92>
  802bb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb4:	8b 40 04             	mov    0x4(%eax),%eax
  802bb7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bba:	8b 12                	mov    (%edx),%edx
  802bbc:	89 10                	mov    %edx,(%eax)
  802bbe:	eb 0a                	jmp    802bca <alloc_block_BF+0x9c>
  802bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc3:	8b 00                	mov    (%eax),%eax
  802bc5:	a3 38 51 80 00       	mov    %eax,0x805138
  802bca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bdd:	a1 44 51 80 00       	mov    0x805144,%eax
  802be2:	48                   	dec    %eax
  802be3:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802be8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802beb:	e9 4d 01 00 00       	jmp    802d3d <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf3:	8b 40 0c             	mov    0xc(%eax),%eax
  802bf6:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bf9:	76 24                	jbe    802c1f <alloc_block_BF+0xf1>
  802bfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfe:	8b 40 0c             	mov    0xc(%eax),%eax
  802c01:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802c04:	73 19                	jae    802c1f <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802c06:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802c0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c10:	8b 40 0c             	mov    0xc(%eax),%eax
  802c13:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802c16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c19:	8b 40 08             	mov    0x8(%eax),%eax
  802c1c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802c1f:	a1 40 51 80 00       	mov    0x805140,%eax
  802c24:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c27:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c2b:	74 07                	je     802c34 <alloc_block_BF+0x106>
  802c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c30:	8b 00                	mov    (%eax),%eax
  802c32:	eb 05                	jmp    802c39 <alloc_block_BF+0x10b>
  802c34:	b8 00 00 00 00       	mov    $0x0,%eax
  802c39:	a3 40 51 80 00       	mov    %eax,0x805140
  802c3e:	a1 40 51 80 00       	mov    0x805140,%eax
  802c43:	85 c0                	test   %eax,%eax
  802c45:	0f 85 fd fe ff ff    	jne    802b48 <alloc_block_BF+0x1a>
  802c4b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c4f:	0f 85 f3 fe ff ff    	jne    802b48 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802c55:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802c59:	0f 84 d9 00 00 00    	je     802d38 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802c5f:	a1 48 51 80 00       	mov    0x805148,%eax
  802c64:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802c67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c6a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c6d:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802c70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c73:	8b 55 08             	mov    0x8(%ebp),%edx
  802c76:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802c79:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802c7d:	75 17                	jne    802c96 <alloc_block_BF+0x168>
  802c7f:	83 ec 04             	sub    $0x4,%esp
  802c82:	68 a4 46 80 00       	push   $0x8046a4
  802c87:	68 c7 00 00 00       	push   $0xc7
  802c8c:	68 fb 45 80 00       	push   $0x8045fb
  802c91:	e8 5d dc ff ff       	call   8008f3 <_panic>
  802c96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c99:	8b 00                	mov    (%eax),%eax
  802c9b:	85 c0                	test   %eax,%eax
  802c9d:	74 10                	je     802caf <alloc_block_BF+0x181>
  802c9f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ca2:	8b 00                	mov    (%eax),%eax
  802ca4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ca7:	8b 52 04             	mov    0x4(%edx),%edx
  802caa:	89 50 04             	mov    %edx,0x4(%eax)
  802cad:	eb 0b                	jmp    802cba <alloc_block_BF+0x18c>
  802caf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cb2:	8b 40 04             	mov    0x4(%eax),%eax
  802cb5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802cba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cbd:	8b 40 04             	mov    0x4(%eax),%eax
  802cc0:	85 c0                	test   %eax,%eax
  802cc2:	74 0f                	je     802cd3 <alloc_block_BF+0x1a5>
  802cc4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cc7:	8b 40 04             	mov    0x4(%eax),%eax
  802cca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ccd:	8b 12                	mov    (%edx),%edx
  802ccf:	89 10                	mov    %edx,(%eax)
  802cd1:	eb 0a                	jmp    802cdd <alloc_block_BF+0x1af>
  802cd3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cd6:	8b 00                	mov    (%eax),%eax
  802cd8:	a3 48 51 80 00       	mov    %eax,0x805148
  802cdd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ce0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ce6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ce9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cf0:	a1 54 51 80 00       	mov    0x805154,%eax
  802cf5:	48                   	dec    %eax
  802cf6:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802cfb:	83 ec 08             	sub    $0x8,%esp
  802cfe:	ff 75 ec             	pushl  -0x14(%ebp)
  802d01:	68 38 51 80 00       	push   $0x805138
  802d06:	e8 71 f9 ff ff       	call   80267c <find_block>
  802d0b:	83 c4 10             	add    $0x10,%esp
  802d0e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802d11:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d14:	8b 50 08             	mov    0x8(%eax),%edx
  802d17:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1a:	01 c2                	add    %eax,%edx
  802d1c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d1f:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802d22:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d25:	8b 40 0c             	mov    0xc(%eax),%eax
  802d28:	2b 45 08             	sub    0x8(%ebp),%eax
  802d2b:	89 c2                	mov    %eax,%edx
  802d2d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d30:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802d33:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d36:	eb 05                	jmp    802d3d <alloc_block_BF+0x20f>
	}
	return NULL;
  802d38:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d3d:	c9                   	leave  
  802d3e:	c3                   	ret    

00802d3f <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802d3f:	55                   	push   %ebp
  802d40:	89 e5                	mov    %esp,%ebp
  802d42:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802d45:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802d4a:	85 c0                	test   %eax,%eax
  802d4c:	0f 85 de 01 00 00    	jne    802f30 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802d52:	a1 38 51 80 00       	mov    0x805138,%eax
  802d57:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d5a:	e9 9e 01 00 00       	jmp    802efd <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802d5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d62:	8b 40 0c             	mov    0xc(%eax),%eax
  802d65:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d68:	0f 82 87 01 00 00    	jb     802ef5 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802d6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d71:	8b 40 0c             	mov    0xc(%eax),%eax
  802d74:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d77:	0f 85 95 00 00 00    	jne    802e12 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802d7d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d81:	75 17                	jne    802d9a <alloc_block_NF+0x5b>
  802d83:	83 ec 04             	sub    $0x4,%esp
  802d86:	68 a4 46 80 00       	push   $0x8046a4
  802d8b:	68 e0 00 00 00       	push   $0xe0
  802d90:	68 fb 45 80 00       	push   $0x8045fb
  802d95:	e8 59 db ff ff       	call   8008f3 <_panic>
  802d9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9d:	8b 00                	mov    (%eax),%eax
  802d9f:	85 c0                	test   %eax,%eax
  802da1:	74 10                	je     802db3 <alloc_block_NF+0x74>
  802da3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da6:	8b 00                	mov    (%eax),%eax
  802da8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dab:	8b 52 04             	mov    0x4(%edx),%edx
  802dae:	89 50 04             	mov    %edx,0x4(%eax)
  802db1:	eb 0b                	jmp    802dbe <alloc_block_NF+0x7f>
  802db3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db6:	8b 40 04             	mov    0x4(%eax),%eax
  802db9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc1:	8b 40 04             	mov    0x4(%eax),%eax
  802dc4:	85 c0                	test   %eax,%eax
  802dc6:	74 0f                	je     802dd7 <alloc_block_NF+0x98>
  802dc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcb:	8b 40 04             	mov    0x4(%eax),%eax
  802dce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dd1:	8b 12                	mov    (%edx),%edx
  802dd3:	89 10                	mov    %edx,(%eax)
  802dd5:	eb 0a                	jmp    802de1 <alloc_block_NF+0xa2>
  802dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dda:	8b 00                	mov    (%eax),%eax
  802ddc:	a3 38 51 80 00       	mov    %eax,0x805138
  802de1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ded:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802df4:	a1 44 51 80 00       	mov    0x805144,%eax
  802df9:	48                   	dec    %eax
  802dfa:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802dff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e02:	8b 40 08             	mov    0x8(%eax),%eax
  802e05:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   return  point;
  802e0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0d:	e9 f8 04 00 00       	jmp    80330a <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802e12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e15:	8b 40 0c             	mov    0xc(%eax),%eax
  802e18:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e1b:	0f 86 d4 00 00 00    	jbe    802ef5 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802e21:	a1 48 51 80 00       	mov    0x805148,%eax
  802e26:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802e29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2c:	8b 50 08             	mov    0x8(%eax),%edx
  802e2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e32:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802e35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e38:	8b 55 08             	mov    0x8(%ebp),%edx
  802e3b:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802e3e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e42:	75 17                	jne    802e5b <alloc_block_NF+0x11c>
  802e44:	83 ec 04             	sub    $0x4,%esp
  802e47:	68 a4 46 80 00       	push   $0x8046a4
  802e4c:	68 e9 00 00 00       	push   $0xe9
  802e51:	68 fb 45 80 00       	push   $0x8045fb
  802e56:	e8 98 da ff ff       	call   8008f3 <_panic>
  802e5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e5e:	8b 00                	mov    (%eax),%eax
  802e60:	85 c0                	test   %eax,%eax
  802e62:	74 10                	je     802e74 <alloc_block_NF+0x135>
  802e64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e67:	8b 00                	mov    (%eax),%eax
  802e69:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e6c:	8b 52 04             	mov    0x4(%edx),%edx
  802e6f:	89 50 04             	mov    %edx,0x4(%eax)
  802e72:	eb 0b                	jmp    802e7f <alloc_block_NF+0x140>
  802e74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e77:	8b 40 04             	mov    0x4(%eax),%eax
  802e7a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e82:	8b 40 04             	mov    0x4(%eax),%eax
  802e85:	85 c0                	test   %eax,%eax
  802e87:	74 0f                	je     802e98 <alloc_block_NF+0x159>
  802e89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e8c:	8b 40 04             	mov    0x4(%eax),%eax
  802e8f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e92:	8b 12                	mov    (%edx),%edx
  802e94:	89 10                	mov    %edx,(%eax)
  802e96:	eb 0a                	jmp    802ea2 <alloc_block_NF+0x163>
  802e98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e9b:	8b 00                	mov    (%eax),%eax
  802e9d:	a3 48 51 80 00       	mov    %eax,0x805148
  802ea2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eb5:	a1 54 51 80 00       	mov    0x805154,%eax
  802eba:	48                   	dec    %eax
  802ebb:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802ec0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec3:	8b 40 08             	mov    0x8(%eax),%eax
  802ec6:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   point->sva += size;
  802ecb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ece:	8b 50 08             	mov    0x8(%eax),%edx
  802ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed4:	01 c2                	add    %eax,%edx
  802ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed9:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802edc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edf:	8b 40 0c             	mov    0xc(%eax),%eax
  802ee2:	2b 45 08             	sub    0x8(%ebp),%eax
  802ee5:	89 c2                	mov    %eax,%edx
  802ee7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eea:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802eed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef0:	e9 15 04 00 00       	jmp    80330a <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802ef5:	a1 40 51 80 00       	mov    0x805140,%eax
  802efa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802efd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f01:	74 07                	je     802f0a <alloc_block_NF+0x1cb>
  802f03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f06:	8b 00                	mov    (%eax),%eax
  802f08:	eb 05                	jmp    802f0f <alloc_block_NF+0x1d0>
  802f0a:	b8 00 00 00 00       	mov    $0x0,%eax
  802f0f:	a3 40 51 80 00       	mov    %eax,0x805140
  802f14:	a1 40 51 80 00       	mov    0x805140,%eax
  802f19:	85 c0                	test   %eax,%eax
  802f1b:	0f 85 3e fe ff ff    	jne    802d5f <alloc_block_NF+0x20>
  802f21:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f25:	0f 85 34 fe ff ff    	jne    802d5f <alloc_block_NF+0x20>
  802f2b:	e9 d5 03 00 00       	jmp    803305 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802f30:	a1 38 51 80 00       	mov    0x805138,%eax
  802f35:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f38:	e9 b1 01 00 00       	jmp    8030ee <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802f3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f40:	8b 50 08             	mov    0x8(%eax),%edx
  802f43:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802f48:	39 c2                	cmp    %eax,%edx
  802f4a:	0f 82 96 01 00 00    	jb     8030e6 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802f50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f53:	8b 40 0c             	mov    0xc(%eax),%eax
  802f56:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f59:	0f 82 87 01 00 00    	jb     8030e6 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802f5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f62:	8b 40 0c             	mov    0xc(%eax),%eax
  802f65:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f68:	0f 85 95 00 00 00    	jne    803003 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802f6e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f72:	75 17                	jne    802f8b <alloc_block_NF+0x24c>
  802f74:	83 ec 04             	sub    $0x4,%esp
  802f77:	68 a4 46 80 00       	push   $0x8046a4
  802f7c:	68 fc 00 00 00       	push   $0xfc
  802f81:	68 fb 45 80 00       	push   $0x8045fb
  802f86:	e8 68 d9 ff ff       	call   8008f3 <_panic>
  802f8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8e:	8b 00                	mov    (%eax),%eax
  802f90:	85 c0                	test   %eax,%eax
  802f92:	74 10                	je     802fa4 <alloc_block_NF+0x265>
  802f94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f97:	8b 00                	mov    (%eax),%eax
  802f99:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f9c:	8b 52 04             	mov    0x4(%edx),%edx
  802f9f:	89 50 04             	mov    %edx,0x4(%eax)
  802fa2:	eb 0b                	jmp    802faf <alloc_block_NF+0x270>
  802fa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa7:	8b 40 04             	mov    0x4(%eax),%eax
  802faa:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802faf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb2:	8b 40 04             	mov    0x4(%eax),%eax
  802fb5:	85 c0                	test   %eax,%eax
  802fb7:	74 0f                	je     802fc8 <alloc_block_NF+0x289>
  802fb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbc:	8b 40 04             	mov    0x4(%eax),%eax
  802fbf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fc2:	8b 12                	mov    (%edx),%edx
  802fc4:	89 10                	mov    %edx,(%eax)
  802fc6:	eb 0a                	jmp    802fd2 <alloc_block_NF+0x293>
  802fc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fcb:	8b 00                	mov    (%eax),%eax
  802fcd:	a3 38 51 80 00       	mov    %eax,0x805138
  802fd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fde:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fe5:	a1 44 51 80 00       	mov    0x805144,%eax
  802fea:	48                   	dec    %eax
  802feb:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802ff0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff3:	8b 40 08             	mov    0x8(%eax),%eax
  802ff6:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  802ffb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffe:	e9 07 03 00 00       	jmp    80330a <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803003:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803006:	8b 40 0c             	mov    0xc(%eax),%eax
  803009:	3b 45 08             	cmp    0x8(%ebp),%eax
  80300c:	0f 86 d4 00 00 00    	jbe    8030e6 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803012:	a1 48 51 80 00       	mov    0x805148,%eax
  803017:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  80301a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301d:	8b 50 08             	mov    0x8(%eax),%edx
  803020:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803023:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803026:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803029:	8b 55 08             	mov    0x8(%ebp),%edx
  80302c:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80302f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803033:	75 17                	jne    80304c <alloc_block_NF+0x30d>
  803035:	83 ec 04             	sub    $0x4,%esp
  803038:	68 a4 46 80 00       	push   $0x8046a4
  80303d:	68 04 01 00 00       	push   $0x104
  803042:	68 fb 45 80 00       	push   $0x8045fb
  803047:	e8 a7 d8 ff ff       	call   8008f3 <_panic>
  80304c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80304f:	8b 00                	mov    (%eax),%eax
  803051:	85 c0                	test   %eax,%eax
  803053:	74 10                	je     803065 <alloc_block_NF+0x326>
  803055:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803058:	8b 00                	mov    (%eax),%eax
  80305a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80305d:	8b 52 04             	mov    0x4(%edx),%edx
  803060:	89 50 04             	mov    %edx,0x4(%eax)
  803063:	eb 0b                	jmp    803070 <alloc_block_NF+0x331>
  803065:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803068:	8b 40 04             	mov    0x4(%eax),%eax
  80306b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803070:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803073:	8b 40 04             	mov    0x4(%eax),%eax
  803076:	85 c0                	test   %eax,%eax
  803078:	74 0f                	je     803089 <alloc_block_NF+0x34a>
  80307a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80307d:	8b 40 04             	mov    0x4(%eax),%eax
  803080:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803083:	8b 12                	mov    (%edx),%edx
  803085:	89 10                	mov    %edx,(%eax)
  803087:	eb 0a                	jmp    803093 <alloc_block_NF+0x354>
  803089:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80308c:	8b 00                	mov    (%eax),%eax
  80308e:	a3 48 51 80 00       	mov    %eax,0x805148
  803093:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803096:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80309c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80309f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030a6:	a1 54 51 80 00       	mov    0x805154,%eax
  8030ab:	48                   	dec    %eax
  8030ac:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8030b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b4:	8b 40 08             	mov    0x8(%eax),%eax
  8030b7:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  8030bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030bf:	8b 50 08             	mov    0x8(%eax),%edx
  8030c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c5:	01 c2                	add    %eax,%edx
  8030c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ca:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8030cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8030d3:	2b 45 08             	sub    0x8(%ebp),%eax
  8030d6:	89 c2                	mov    %eax,%edx
  8030d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030db:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8030de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e1:	e9 24 02 00 00       	jmp    80330a <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8030e6:	a1 40 51 80 00       	mov    0x805140,%eax
  8030eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030f2:	74 07                	je     8030fb <alloc_block_NF+0x3bc>
  8030f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f7:	8b 00                	mov    (%eax),%eax
  8030f9:	eb 05                	jmp    803100 <alloc_block_NF+0x3c1>
  8030fb:	b8 00 00 00 00       	mov    $0x0,%eax
  803100:	a3 40 51 80 00       	mov    %eax,0x805140
  803105:	a1 40 51 80 00       	mov    0x805140,%eax
  80310a:	85 c0                	test   %eax,%eax
  80310c:	0f 85 2b fe ff ff    	jne    802f3d <alloc_block_NF+0x1fe>
  803112:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803116:	0f 85 21 fe ff ff    	jne    802f3d <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  80311c:	a1 38 51 80 00       	mov    0x805138,%eax
  803121:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803124:	e9 ae 01 00 00       	jmp    8032d7 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  803129:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312c:	8b 50 08             	mov    0x8(%eax),%edx
  80312f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803134:	39 c2                	cmp    %eax,%edx
  803136:	0f 83 93 01 00 00    	jae    8032cf <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  80313c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313f:	8b 40 0c             	mov    0xc(%eax),%eax
  803142:	3b 45 08             	cmp    0x8(%ebp),%eax
  803145:	0f 82 84 01 00 00    	jb     8032cf <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  80314b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314e:	8b 40 0c             	mov    0xc(%eax),%eax
  803151:	3b 45 08             	cmp    0x8(%ebp),%eax
  803154:	0f 85 95 00 00 00    	jne    8031ef <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80315a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80315e:	75 17                	jne    803177 <alloc_block_NF+0x438>
  803160:	83 ec 04             	sub    $0x4,%esp
  803163:	68 a4 46 80 00       	push   $0x8046a4
  803168:	68 14 01 00 00       	push   $0x114
  80316d:	68 fb 45 80 00       	push   $0x8045fb
  803172:	e8 7c d7 ff ff       	call   8008f3 <_panic>
  803177:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317a:	8b 00                	mov    (%eax),%eax
  80317c:	85 c0                	test   %eax,%eax
  80317e:	74 10                	je     803190 <alloc_block_NF+0x451>
  803180:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803183:	8b 00                	mov    (%eax),%eax
  803185:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803188:	8b 52 04             	mov    0x4(%edx),%edx
  80318b:	89 50 04             	mov    %edx,0x4(%eax)
  80318e:	eb 0b                	jmp    80319b <alloc_block_NF+0x45c>
  803190:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803193:	8b 40 04             	mov    0x4(%eax),%eax
  803196:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80319b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319e:	8b 40 04             	mov    0x4(%eax),%eax
  8031a1:	85 c0                	test   %eax,%eax
  8031a3:	74 0f                	je     8031b4 <alloc_block_NF+0x475>
  8031a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a8:	8b 40 04             	mov    0x4(%eax),%eax
  8031ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031ae:	8b 12                	mov    (%edx),%edx
  8031b0:	89 10                	mov    %edx,(%eax)
  8031b2:	eb 0a                	jmp    8031be <alloc_block_NF+0x47f>
  8031b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b7:	8b 00                	mov    (%eax),%eax
  8031b9:	a3 38 51 80 00       	mov    %eax,0x805138
  8031be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031d1:	a1 44 51 80 00       	mov    0x805144,%eax
  8031d6:	48                   	dec    %eax
  8031d7:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8031dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031df:	8b 40 08             	mov    0x8(%eax),%eax
  8031e2:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  8031e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ea:	e9 1b 01 00 00       	jmp    80330a <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8031ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8031f5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031f8:	0f 86 d1 00 00 00    	jbe    8032cf <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8031fe:	a1 48 51 80 00       	mov    0x805148,%eax
  803203:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  803206:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803209:	8b 50 08             	mov    0x8(%eax),%edx
  80320c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80320f:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803212:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803215:	8b 55 08             	mov    0x8(%ebp),%edx
  803218:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80321b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80321f:	75 17                	jne    803238 <alloc_block_NF+0x4f9>
  803221:	83 ec 04             	sub    $0x4,%esp
  803224:	68 a4 46 80 00       	push   $0x8046a4
  803229:	68 1c 01 00 00       	push   $0x11c
  80322e:	68 fb 45 80 00       	push   $0x8045fb
  803233:	e8 bb d6 ff ff       	call   8008f3 <_panic>
  803238:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80323b:	8b 00                	mov    (%eax),%eax
  80323d:	85 c0                	test   %eax,%eax
  80323f:	74 10                	je     803251 <alloc_block_NF+0x512>
  803241:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803244:	8b 00                	mov    (%eax),%eax
  803246:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803249:	8b 52 04             	mov    0x4(%edx),%edx
  80324c:	89 50 04             	mov    %edx,0x4(%eax)
  80324f:	eb 0b                	jmp    80325c <alloc_block_NF+0x51d>
  803251:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803254:	8b 40 04             	mov    0x4(%eax),%eax
  803257:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80325c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80325f:	8b 40 04             	mov    0x4(%eax),%eax
  803262:	85 c0                	test   %eax,%eax
  803264:	74 0f                	je     803275 <alloc_block_NF+0x536>
  803266:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803269:	8b 40 04             	mov    0x4(%eax),%eax
  80326c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80326f:	8b 12                	mov    (%edx),%edx
  803271:	89 10                	mov    %edx,(%eax)
  803273:	eb 0a                	jmp    80327f <alloc_block_NF+0x540>
  803275:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803278:	8b 00                	mov    (%eax),%eax
  80327a:	a3 48 51 80 00       	mov    %eax,0x805148
  80327f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803282:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803288:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80328b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803292:	a1 54 51 80 00       	mov    0x805154,%eax
  803297:	48                   	dec    %eax
  803298:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  80329d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032a0:	8b 40 08             	mov    0x8(%eax),%eax
  8032a3:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  8032a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ab:	8b 50 08             	mov    0x8(%eax),%edx
  8032ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b1:	01 c2                	add    %eax,%edx
  8032b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b6:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8032b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8032bf:	2b 45 08             	sub    0x8(%ebp),%eax
  8032c2:	89 c2                	mov    %eax,%edx
  8032c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c7:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8032ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032cd:	eb 3b                	jmp    80330a <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8032cf:	a1 40 51 80 00       	mov    0x805140,%eax
  8032d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032db:	74 07                	je     8032e4 <alloc_block_NF+0x5a5>
  8032dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e0:	8b 00                	mov    (%eax),%eax
  8032e2:	eb 05                	jmp    8032e9 <alloc_block_NF+0x5aa>
  8032e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8032e9:	a3 40 51 80 00       	mov    %eax,0x805140
  8032ee:	a1 40 51 80 00       	mov    0x805140,%eax
  8032f3:	85 c0                	test   %eax,%eax
  8032f5:	0f 85 2e fe ff ff    	jne    803129 <alloc_block_NF+0x3ea>
  8032fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032ff:	0f 85 24 fe ff ff    	jne    803129 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  803305:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80330a:	c9                   	leave  
  80330b:	c3                   	ret    

0080330c <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80330c:	55                   	push   %ebp
  80330d:	89 e5                	mov    %esp,%ebp
  80330f:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  803312:	a1 38 51 80 00       	mov    0x805138,%eax
  803317:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  80331a:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80331f:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  803322:	a1 38 51 80 00       	mov    0x805138,%eax
  803327:	85 c0                	test   %eax,%eax
  803329:	74 14                	je     80333f <insert_sorted_with_merge_freeList+0x33>
  80332b:	8b 45 08             	mov    0x8(%ebp),%eax
  80332e:	8b 50 08             	mov    0x8(%eax),%edx
  803331:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803334:	8b 40 08             	mov    0x8(%eax),%eax
  803337:	39 c2                	cmp    %eax,%edx
  803339:	0f 87 9b 01 00 00    	ja     8034da <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  80333f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803343:	75 17                	jne    80335c <insert_sorted_with_merge_freeList+0x50>
  803345:	83 ec 04             	sub    $0x4,%esp
  803348:	68 d8 45 80 00       	push   $0x8045d8
  80334d:	68 38 01 00 00       	push   $0x138
  803352:	68 fb 45 80 00       	push   $0x8045fb
  803357:	e8 97 d5 ff ff       	call   8008f3 <_panic>
  80335c:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803362:	8b 45 08             	mov    0x8(%ebp),%eax
  803365:	89 10                	mov    %edx,(%eax)
  803367:	8b 45 08             	mov    0x8(%ebp),%eax
  80336a:	8b 00                	mov    (%eax),%eax
  80336c:	85 c0                	test   %eax,%eax
  80336e:	74 0d                	je     80337d <insert_sorted_with_merge_freeList+0x71>
  803370:	a1 38 51 80 00       	mov    0x805138,%eax
  803375:	8b 55 08             	mov    0x8(%ebp),%edx
  803378:	89 50 04             	mov    %edx,0x4(%eax)
  80337b:	eb 08                	jmp    803385 <insert_sorted_with_merge_freeList+0x79>
  80337d:	8b 45 08             	mov    0x8(%ebp),%eax
  803380:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803385:	8b 45 08             	mov    0x8(%ebp),%eax
  803388:	a3 38 51 80 00       	mov    %eax,0x805138
  80338d:	8b 45 08             	mov    0x8(%ebp),%eax
  803390:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803397:	a1 44 51 80 00       	mov    0x805144,%eax
  80339c:	40                   	inc    %eax
  80339d:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8033a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033a6:	0f 84 a8 06 00 00    	je     803a54 <insert_sorted_with_merge_freeList+0x748>
  8033ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8033af:	8b 50 08             	mov    0x8(%eax),%edx
  8033b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8033b8:	01 c2                	add    %eax,%edx
  8033ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033bd:	8b 40 08             	mov    0x8(%eax),%eax
  8033c0:	39 c2                	cmp    %eax,%edx
  8033c2:	0f 85 8c 06 00 00    	jne    803a54 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  8033c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8033cb:	8b 50 0c             	mov    0xc(%eax),%edx
  8033ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8033d4:	01 c2                	add    %eax,%edx
  8033d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d9:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  8033dc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033e0:	75 17                	jne    8033f9 <insert_sorted_with_merge_freeList+0xed>
  8033e2:	83 ec 04             	sub    $0x4,%esp
  8033e5:	68 a4 46 80 00       	push   $0x8046a4
  8033ea:	68 3c 01 00 00       	push   $0x13c
  8033ef:	68 fb 45 80 00       	push   $0x8045fb
  8033f4:	e8 fa d4 ff ff       	call   8008f3 <_panic>
  8033f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033fc:	8b 00                	mov    (%eax),%eax
  8033fe:	85 c0                	test   %eax,%eax
  803400:	74 10                	je     803412 <insert_sorted_with_merge_freeList+0x106>
  803402:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803405:	8b 00                	mov    (%eax),%eax
  803407:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80340a:	8b 52 04             	mov    0x4(%edx),%edx
  80340d:	89 50 04             	mov    %edx,0x4(%eax)
  803410:	eb 0b                	jmp    80341d <insert_sorted_with_merge_freeList+0x111>
  803412:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803415:	8b 40 04             	mov    0x4(%eax),%eax
  803418:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80341d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803420:	8b 40 04             	mov    0x4(%eax),%eax
  803423:	85 c0                	test   %eax,%eax
  803425:	74 0f                	je     803436 <insert_sorted_with_merge_freeList+0x12a>
  803427:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80342a:	8b 40 04             	mov    0x4(%eax),%eax
  80342d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803430:	8b 12                	mov    (%edx),%edx
  803432:	89 10                	mov    %edx,(%eax)
  803434:	eb 0a                	jmp    803440 <insert_sorted_with_merge_freeList+0x134>
  803436:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803439:	8b 00                	mov    (%eax),%eax
  80343b:	a3 38 51 80 00       	mov    %eax,0x805138
  803440:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803443:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803449:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80344c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803453:	a1 44 51 80 00       	mov    0x805144,%eax
  803458:	48                   	dec    %eax
  803459:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  80345e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803461:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803468:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80346b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803472:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803476:	75 17                	jne    80348f <insert_sorted_with_merge_freeList+0x183>
  803478:	83 ec 04             	sub    $0x4,%esp
  80347b:	68 d8 45 80 00       	push   $0x8045d8
  803480:	68 3f 01 00 00       	push   $0x13f
  803485:	68 fb 45 80 00       	push   $0x8045fb
  80348a:	e8 64 d4 ff ff       	call   8008f3 <_panic>
  80348f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803495:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803498:	89 10                	mov    %edx,(%eax)
  80349a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80349d:	8b 00                	mov    (%eax),%eax
  80349f:	85 c0                	test   %eax,%eax
  8034a1:	74 0d                	je     8034b0 <insert_sorted_with_merge_freeList+0x1a4>
  8034a3:	a1 48 51 80 00       	mov    0x805148,%eax
  8034a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034ab:	89 50 04             	mov    %edx,0x4(%eax)
  8034ae:	eb 08                	jmp    8034b8 <insert_sorted_with_merge_freeList+0x1ac>
  8034b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034b3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034bb:	a3 48 51 80 00       	mov    %eax,0x805148
  8034c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034c3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034ca:	a1 54 51 80 00       	mov    0x805154,%eax
  8034cf:	40                   	inc    %eax
  8034d0:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8034d5:	e9 7a 05 00 00       	jmp    803a54 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  8034da:	8b 45 08             	mov    0x8(%ebp),%eax
  8034dd:	8b 50 08             	mov    0x8(%eax),%edx
  8034e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034e3:	8b 40 08             	mov    0x8(%eax),%eax
  8034e6:	39 c2                	cmp    %eax,%edx
  8034e8:	0f 82 14 01 00 00    	jb     803602 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8034ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034f1:	8b 50 08             	mov    0x8(%eax),%edx
  8034f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8034fa:	01 c2                	add    %eax,%edx
  8034fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ff:	8b 40 08             	mov    0x8(%eax),%eax
  803502:	39 c2                	cmp    %eax,%edx
  803504:	0f 85 90 00 00 00    	jne    80359a <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  80350a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80350d:	8b 50 0c             	mov    0xc(%eax),%edx
  803510:	8b 45 08             	mov    0x8(%ebp),%eax
  803513:	8b 40 0c             	mov    0xc(%eax),%eax
  803516:	01 c2                	add    %eax,%edx
  803518:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80351b:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  80351e:	8b 45 08             	mov    0x8(%ebp),%eax
  803521:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803528:	8b 45 08             	mov    0x8(%ebp),%eax
  80352b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803532:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803536:	75 17                	jne    80354f <insert_sorted_with_merge_freeList+0x243>
  803538:	83 ec 04             	sub    $0x4,%esp
  80353b:	68 d8 45 80 00       	push   $0x8045d8
  803540:	68 49 01 00 00       	push   $0x149
  803545:	68 fb 45 80 00       	push   $0x8045fb
  80354a:	e8 a4 d3 ff ff       	call   8008f3 <_panic>
  80354f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803555:	8b 45 08             	mov    0x8(%ebp),%eax
  803558:	89 10                	mov    %edx,(%eax)
  80355a:	8b 45 08             	mov    0x8(%ebp),%eax
  80355d:	8b 00                	mov    (%eax),%eax
  80355f:	85 c0                	test   %eax,%eax
  803561:	74 0d                	je     803570 <insert_sorted_with_merge_freeList+0x264>
  803563:	a1 48 51 80 00       	mov    0x805148,%eax
  803568:	8b 55 08             	mov    0x8(%ebp),%edx
  80356b:	89 50 04             	mov    %edx,0x4(%eax)
  80356e:	eb 08                	jmp    803578 <insert_sorted_with_merge_freeList+0x26c>
  803570:	8b 45 08             	mov    0x8(%ebp),%eax
  803573:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803578:	8b 45 08             	mov    0x8(%ebp),%eax
  80357b:	a3 48 51 80 00       	mov    %eax,0x805148
  803580:	8b 45 08             	mov    0x8(%ebp),%eax
  803583:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80358a:	a1 54 51 80 00       	mov    0x805154,%eax
  80358f:	40                   	inc    %eax
  803590:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803595:	e9 bb 04 00 00       	jmp    803a55 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  80359a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80359e:	75 17                	jne    8035b7 <insert_sorted_with_merge_freeList+0x2ab>
  8035a0:	83 ec 04             	sub    $0x4,%esp
  8035a3:	68 4c 46 80 00       	push   $0x80464c
  8035a8:	68 4c 01 00 00       	push   $0x14c
  8035ad:	68 fb 45 80 00       	push   $0x8045fb
  8035b2:	e8 3c d3 ff ff       	call   8008f3 <_panic>
  8035b7:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8035bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c0:	89 50 04             	mov    %edx,0x4(%eax)
  8035c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c6:	8b 40 04             	mov    0x4(%eax),%eax
  8035c9:	85 c0                	test   %eax,%eax
  8035cb:	74 0c                	je     8035d9 <insert_sorted_with_merge_freeList+0x2cd>
  8035cd:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8035d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8035d5:	89 10                	mov    %edx,(%eax)
  8035d7:	eb 08                	jmp    8035e1 <insert_sorted_with_merge_freeList+0x2d5>
  8035d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8035dc:	a3 38 51 80 00       	mov    %eax,0x805138
  8035e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8035e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035f2:	a1 44 51 80 00       	mov    0x805144,%eax
  8035f7:	40                   	inc    %eax
  8035f8:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8035fd:	e9 53 04 00 00       	jmp    803a55 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803602:	a1 38 51 80 00       	mov    0x805138,%eax
  803607:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80360a:	e9 15 04 00 00       	jmp    803a24 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  80360f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803612:	8b 00                	mov    (%eax),%eax
  803614:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803617:	8b 45 08             	mov    0x8(%ebp),%eax
  80361a:	8b 50 08             	mov    0x8(%eax),%edx
  80361d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803620:	8b 40 08             	mov    0x8(%eax),%eax
  803623:	39 c2                	cmp    %eax,%edx
  803625:	0f 86 f1 03 00 00    	jbe    803a1c <insert_sorted_with_merge_freeList+0x710>
  80362b:	8b 45 08             	mov    0x8(%ebp),%eax
  80362e:	8b 50 08             	mov    0x8(%eax),%edx
  803631:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803634:	8b 40 08             	mov    0x8(%eax),%eax
  803637:	39 c2                	cmp    %eax,%edx
  803639:	0f 83 dd 03 00 00    	jae    803a1c <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  80363f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803642:	8b 50 08             	mov    0x8(%eax),%edx
  803645:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803648:	8b 40 0c             	mov    0xc(%eax),%eax
  80364b:	01 c2                	add    %eax,%edx
  80364d:	8b 45 08             	mov    0x8(%ebp),%eax
  803650:	8b 40 08             	mov    0x8(%eax),%eax
  803653:	39 c2                	cmp    %eax,%edx
  803655:	0f 85 b9 01 00 00    	jne    803814 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80365b:	8b 45 08             	mov    0x8(%ebp),%eax
  80365e:	8b 50 08             	mov    0x8(%eax),%edx
  803661:	8b 45 08             	mov    0x8(%ebp),%eax
  803664:	8b 40 0c             	mov    0xc(%eax),%eax
  803667:	01 c2                	add    %eax,%edx
  803669:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80366c:	8b 40 08             	mov    0x8(%eax),%eax
  80366f:	39 c2                	cmp    %eax,%edx
  803671:	0f 85 0d 01 00 00    	jne    803784 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803677:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80367a:	8b 50 0c             	mov    0xc(%eax),%edx
  80367d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803680:	8b 40 0c             	mov    0xc(%eax),%eax
  803683:	01 c2                	add    %eax,%edx
  803685:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803688:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80368b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80368f:	75 17                	jne    8036a8 <insert_sorted_with_merge_freeList+0x39c>
  803691:	83 ec 04             	sub    $0x4,%esp
  803694:	68 a4 46 80 00       	push   $0x8046a4
  803699:	68 5c 01 00 00       	push   $0x15c
  80369e:	68 fb 45 80 00       	push   $0x8045fb
  8036a3:	e8 4b d2 ff ff       	call   8008f3 <_panic>
  8036a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036ab:	8b 00                	mov    (%eax),%eax
  8036ad:	85 c0                	test   %eax,%eax
  8036af:	74 10                	je     8036c1 <insert_sorted_with_merge_freeList+0x3b5>
  8036b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036b4:	8b 00                	mov    (%eax),%eax
  8036b6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036b9:	8b 52 04             	mov    0x4(%edx),%edx
  8036bc:	89 50 04             	mov    %edx,0x4(%eax)
  8036bf:	eb 0b                	jmp    8036cc <insert_sorted_with_merge_freeList+0x3c0>
  8036c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036c4:	8b 40 04             	mov    0x4(%eax),%eax
  8036c7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8036cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036cf:	8b 40 04             	mov    0x4(%eax),%eax
  8036d2:	85 c0                	test   %eax,%eax
  8036d4:	74 0f                	je     8036e5 <insert_sorted_with_merge_freeList+0x3d9>
  8036d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036d9:	8b 40 04             	mov    0x4(%eax),%eax
  8036dc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036df:	8b 12                	mov    (%edx),%edx
  8036e1:	89 10                	mov    %edx,(%eax)
  8036e3:	eb 0a                	jmp    8036ef <insert_sorted_with_merge_freeList+0x3e3>
  8036e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036e8:	8b 00                	mov    (%eax),%eax
  8036ea:	a3 38 51 80 00       	mov    %eax,0x805138
  8036ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036fb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803702:	a1 44 51 80 00       	mov    0x805144,%eax
  803707:	48                   	dec    %eax
  803708:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  80370d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803710:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803717:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80371a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803721:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803725:	75 17                	jne    80373e <insert_sorted_with_merge_freeList+0x432>
  803727:	83 ec 04             	sub    $0x4,%esp
  80372a:	68 d8 45 80 00       	push   $0x8045d8
  80372f:	68 5f 01 00 00       	push   $0x15f
  803734:	68 fb 45 80 00       	push   $0x8045fb
  803739:	e8 b5 d1 ff ff       	call   8008f3 <_panic>
  80373e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803744:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803747:	89 10                	mov    %edx,(%eax)
  803749:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80374c:	8b 00                	mov    (%eax),%eax
  80374e:	85 c0                	test   %eax,%eax
  803750:	74 0d                	je     80375f <insert_sorted_with_merge_freeList+0x453>
  803752:	a1 48 51 80 00       	mov    0x805148,%eax
  803757:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80375a:	89 50 04             	mov    %edx,0x4(%eax)
  80375d:	eb 08                	jmp    803767 <insert_sorted_with_merge_freeList+0x45b>
  80375f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803762:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803767:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80376a:	a3 48 51 80 00       	mov    %eax,0x805148
  80376f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803772:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803779:	a1 54 51 80 00       	mov    0x805154,%eax
  80377e:	40                   	inc    %eax
  80377f:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803784:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803787:	8b 50 0c             	mov    0xc(%eax),%edx
  80378a:	8b 45 08             	mov    0x8(%ebp),%eax
  80378d:	8b 40 0c             	mov    0xc(%eax),%eax
  803790:	01 c2                	add    %eax,%edx
  803792:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803795:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803798:	8b 45 08             	mov    0x8(%ebp),%eax
  80379b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8037a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8037ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037b0:	75 17                	jne    8037c9 <insert_sorted_with_merge_freeList+0x4bd>
  8037b2:	83 ec 04             	sub    $0x4,%esp
  8037b5:	68 d8 45 80 00       	push   $0x8045d8
  8037ba:	68 64 01 00 00       	push   $0x164
  8037bf:	68 fb 45 80 00       	push   $0x8045fb
  8037c4:	e8 2a d1 ff ff       	call   8008f3 <_panic>
  8037c9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8037cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d2:	89 10                	mov    %edx,(%eax)
  8037d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d7:	8b 00                	mov    (%eax),%eax
  8037d9:	85 c0                	test   %eax,%eax
  8037db:	74 0d                	je     8037ea <insert_sorted_with_merge_freeList+0x4de>
  8037dd:	a1 48 51 80 00       	mov    0x805148,%eax
  8037e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8037e5:	89 50 04             	mov    %edx,0x4(%eax)
  8037e8:	eb 08                	jmp    8037f2 <insert_sorted_with_merge_freeList+0x4e6>
  8037ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ed:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8037f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f5:	a3 48 51 80 00       	mov    %eax,0x805148
  8037fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8037fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803804:	a1 54 51 80 00       	mov    0x805154,%eax
  803809:	40                   	inc    %eax
  80380a:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80380f:	e9 41 02 00 00       	jmp    803a55 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803814:	8b 45 08             	mov    0x8(%ebp),%eax
  803817:	8b 50 08             	mov    0x8(%eax),%edx
  80381a:	8b 45 08             	mov    0x8(%ebp),%eax
  80381d:	8b 40 0c             	mov    0xc(%eax),%eax
  803820:	01 c2                	add    %eax,%edx
  803822:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803825:	8b 40 08             	mov    0x8(%eax),%eax
  803828:	39 c2                	cmp    %eax,%edx
  80382a:	0f 85 7c 01 00 00    	jne    8039ac <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803830:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803834:	74 06                	je     80383c <insert_sorted_with_merge_freeList+0x530>
  803836:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80383a:	75 17                	jne    803853 <insert_sorted_with_merge_freeList+0x547>
  80383c:	83 ec 04             	sub    $0x4,%esp
  80383f:	68 14 46 80 00       	push   $0x804614
  803844:	68 69 01 00 00       	push   $0x169
  803849:	68 fb 45 80 00       	push   $0x8045fb
  80384e:	e8 a0 d0 ff ff       	call   8008f3 <_panic>
  803853:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803856:	8b 50 04             	mov    0x4(%eax),%edx
  803859:	8b 45 08             	mov    0x8(%ebp),%eax
  80385c:	89 50 04             	mov    %edx,0x4(%eax)
  80385f:	8b 45 08             	mov    0x8(%ebp),%eax
  803862:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803865:	89 10                	mov    %edx,(%eax)
  803867:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80386a:	8b 40 04             	mov    0x4(%eax),%eax
  80386d:	85 c0                	test   %eax,%eax
  80386f:	74 0d                	je     80387e <insert_sorted_with_merge_freeList+0x572>
  803871:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803874:	8b 40 04             	mov    0x4(%eax),%eax
  803877:	8b 55 08             	mov    0x8(%ebp),%edx
  80387a:	89 10                	mov    %edx,(%eax)
  80387c:	eb 08                	jmp    803886 <insert_sorted_with_merge_freeList+0x57a>
  80387e:	8b 45 08             	mov    0x8(%ebp),%eax
  803881:	a3 38 51 80 00       	mov    %eax,0x805138
  803886:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803889:	8b 55 08             	mov    0x8(%ebp),%edx
  80388c:	89 50 04             	mov    %edx,0x4(%eax)
  80388f:	a1 44 51 80 00       	mov    0x805144,%eax
  803894:	40                   	inc    %eax
  803895:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  80389a:	8b 45 08             	mov    0x8(%ebp),%eax
  80389d:	8b 50 0c             	mov    0xc(%eax),%edx
  8038a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8038a6:	01 c2                	add    %eax,%edx
  8038a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ab:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8038ae:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8038b2:	75 17                	jne    8038cb <insert_sorted_with_merge_freeList+0x5bf>
  8038b4:	83 ec 04             	sub    $0x4,%esp
  8038b7:	68 a4 46 80 00       	push   $0x8046a4
  8038bc:	68 6b 01 00 00       	push   $0x16b
  8038c1:	68 fb 45 80 00       	push   $0x8045fb
  8038c6:	e8 28 d0 ff ff       	call   8008f3 <_panic>
  8038cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038ce:	8b 00                	mov    (%eax),%eax
  8038d0:	85 c0                	test   %eax,%eax
  8038d2:	74 10                	je     8038e4 <insert_sorted_with_merge_freeList+0x5d8>
  8038d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038d7:	8b 00                	mov    (%eax),%eax
  8038d9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038dc:	8b 52 04             	mov    0x4(%edx),%edx
  8038df:	89 50 04             	mov    %edx,0x4(%eax)
  8038e2:	eb 0b                	jmp    8038ef <insert_sorted_with_merge_freeList+0x5e3>
  8038e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038e7:	8b 40 04             	mov    0x4(%eax),%eax
  8038ea:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8038ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038f2:	8b 40 04             	mov    0x4(%eax),%eax
  8038f5:	85 c0                	test   %eax,%eax
  8038f7:	74 0f                	je     803908 <insert_sorted_with_merge_freeList+0x5fc>
  8038f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038fc:	8b 40 04             	mov    0x4(%eax),%eax
  8038ff:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803902:	8b 12                	mov    (%edx),%edx
  803904:	89 10                	mov    %edx,(%eax)
  803906:	eb 0a                	jmp    803912 <insert_sorted_with_merge_freeList+0x606>
  803908:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80390b:	8b 00                	mov    (%eax),%eax
  80390d:	a3 38 51 80 00       	mov    %eax,0x805138
  803912:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803915:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80391b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80391e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803925:	a1 44 51 80 00       	mov    0x805144,%eax
  80392a:	48                   	dec    %eax
  80392b:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803930:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803933:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80393a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80393d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803944:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803948:	75 17                	jne    803961 <insert_sorted_with_merge_freeList+0x655>
  80394a:	83 ec 04             	sub    $0x4,%esp
  80394d:	68 d8 45 80 00       	push   $0x8045d8
  803952:	68 6e 01 00 00       	push   $0x16e
  803957:	68 fb 45 80 00       	push   $0x8045fb
  80395c:	e8 92 cf ff ff       	call   8008f3 <_panic>
  803961:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803967:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80396a:	89 10                	mov    %edx,(%eax)
  80396c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80396f:	8b 00                	mov    (%eax),%eax
  803971:	85 c0                	test   %eax,%eax
  803973:	74 0d                	je     803982 <insert_sorted_with_merge_freeList+0x676>
  803975:	a1 48 51 80 00       	mov    0x805148,%eax
  80397a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80397d:	89 50 04             	mov    %edx,0x4(%eax)
  803980:	eb 08                	jmp    80398a <insert_sorted_with_merge_freeList+0x67e>
  803982:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803985:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80398a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80398d:	a3 48 51 80 00       	mov    %eax,0x805148
  803992:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803995:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80399c:	a1 54 51 80 00       	mov    0x805154,%eax
  8039a1:	40                   	inc    %eax
  8039a2:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8039a7:	e9 a9 00 00 00       	jmp    803a55 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8039ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039b0:	74 06                	je     8039b8 <insert_sorted_with_merge_freeList+0x6ac>
  8039b2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8039b6:	75 17                	jne    8039cf <insert_sorted_with_merge_freeList+0x6c3>
  8039b8:	83 ec 04             	sub    $0x4,%esp
  8039bb:	68 70 46 80 00       	push   $0x804670
  8039c0:	68 73 01 00 00       	push   $0x173
  8039c5:	68 fb 45 80 00       	push   $0x8045fb
  8039ca:	e8 24 cf ff ff       	call   8008f3 <_panic>
  8039cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039d2:	8b 10                	mov    (%eax),%edx
  8039d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8039d7:	89 10                	mov    %edx,(%eax)
  8039d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8039dc:	8b 00                	mov    (%eax),%eax
  8039de:	85 c0                	test   %eax,%eax
  8039e0:	74 0b                	je     8039ed <insert_sorted_with_merge_freeList+0x6e1>
  8039e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039e5:	8b 00                	mov    (%eax),%eax
  8039e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8039ea:	89 50 04             	mov    %edx,0x4(%eax)
  8039ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8039f3:	89 10                	mov    %edx,(%eax)
  8039f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8039f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8039fb:	89 50 04             	mov    %edx,0x4(%eax)
  8039fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803a01:	8b 00                	mov    (%eax),%eax
  803a03:	85 c0                	test   %eax,%eax
  803a05:	75 08                	jne    803a0f <insert_sorted_with_merge_freeList+0x703>
  803a07:	8b 45 08             	mov    0x8(%ebp),%eax
  803a0a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803a0f:	a1 44 51 80 00       	mov    0x805144,%eax
  803a14:	40                   	inc    %eax
  803a15:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803a1a:	eb 39                	jmp    803a55 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803a1c:	a1 40 51 80 00       	mov    0x805140,%eax
  803a21:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a24:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a28:	74 07                	je     803a31 <insert_sorted_with_merge_freeList+0x725>
  803a2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a2d:	8b 00                	mov    (%eax),%eax
  803a2f:	eb 05                	jmp    803a36 <insert_sorted_with_merge_freeList+0x72a>
  803a31:	b8 00 00 00 00       	mov    $0x0,%eax
  803a36:	a3 40 51 80 00       	mov    %eax,0x805140
  803a3b:	a1 40 51 80 00       	mov    0x805140,%eax
  803a40:	85 c0                	test   %eax,%eax
  803a42:	0f 85 c7 fb ff ff    	jne    80360f <insert_sorted_with_merge_freeList+0x303>
  803a48:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a4c:	0f 85 bd fb ff ff    	jne    80360f <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803a52:	eb 01                	jmp    803a55 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803a54:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803a55:	90                   	nop
  803a56:	c9                   	leave  
  803a57:	c3                   	ret    

00803a58 <__udivdi3>:
  803a58:	55                   	push   %ebp
  803a59:	57                   	push   %edi
  803a5a:	56                   	push   %esi
  803a5b:	53                   	push   %ebx
  803a5c:	83 ec 1c             	sub    $0x1c,%esp
  803a5f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803a63:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803a67:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a6b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803a6f:	89 ca                	mov    %ecx,%edx
  803a71:	89 f8                	mov    %edi,%eax
  803a73:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803a77:	85 f6                	test   %esi,%esi
  803a79:	75 2d                	jne    803aa8 <__udivdi3+0x50>
  803a7b:	39 cf                	cmp    %ecx,%edi
  803a7d:	77 65                	ja     803ae4 <__udivdi3+0x8c>
  803a7f:	89 fd                	mov    %edi,%ebp
  803a81:	85 ff                	test   %edi,%edi
  803a83:	75 0b                	jne    803a90 <__udivdi3+0x38>
  803a85:	b8 01 00 00 00       	mov    $0x1,%eax
  803a8a:	31 d2                	xor    %edx,%edx
  803a8c:	f7 f7                	div    %edi
  803a8e:	89 c5                	mov    %eax,%ebp
  803a90:	31 d2                	xor    %edx,%edx
  803a92:	89 c8                	mov    %ecx,%eax
  803a94:	f7 f5                	div    %ebp
  803a96:	89 c1                	mov    %eax,%ecx
  803a98:	89 d8                	mov    %ebx,%eax
  803a9a:	f7 f5                	div    %ebp
  803a9c:	89 cf                	mov    %ecx,%edi
  803a9e:	89 fa                	mov    %edi,%edx
  803aa0:	83 c4 1c             	add    $0x1c,%esp
  803aa3:	5b                   	pop    %ebx
  803aa4:	5e                   	pop    %esi
  803aa5:	5f                   	pop    %edi
  803aa6:	5d                   	pop    %ebp
  803aa7:	c3                   	ret    
  803aa8:	39 ce                	cmp    %ecx,%esi
  803aaa:	77 28                	ja     803ad4 <__udivdi3+0x7c>
  803aac:	0f bd fe             	bsr    %esi,%edi
  803aaf:	83 f7 1f             	xor    $0x1f,%edi
  803ab2:	75 40                	jne    803af4 <__udivdi3+0x9c>
  803ab4:	39 ce                	cmp    %ecx,%esi
  803ab6:	72 0a                	jb     803ac2 <__udivdi3+0x6a>
  803ab8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803abc:	0f 87 9e 00 00 00    	ja     803b60 <__udivdi3+0x108>
  803ac2:	b8 01 00 00 00       	mov    $0x1,%eax
  803ac7:	89 fa                	mov    %edi,%edx
  803ac9:	83 c4 1c             	add    $0x1c,%esp
  803acc:	5b                   	pop    %ebx
  803acd:	5e                   	pop    %esi
  803ace:	5f                   	pop    %edi
  803acf:	5d                   	pop    %ebp
  803ad0:	c3                   	ret    
  803ad1:	8d 76 00             	lea    0x0(%esi),%esi
  803ad4:	31 ff                	xor    %edi,%edi
  803ad6:	31 c0                	xor    %eax,%eax
  803ad8:	89 fa                	mov    %edi,%edx
  803ada:	83 c4 1c             	add    $0x1c,%esp
  803add:	5b                   	pop    %ebx
  803ade:	5e                   	pop    %esi
  803adf:	5f                   	pop    %edi
  803ae0:	5d                   	pop    %ebp
  803ae1:	c3                   	ret    
  803ae2:	66 90                	xchg   %ax,%ax
  803ae4:	89 d8                	mov    %ebx,%eax
  803ae6:	f7 f7                	div    %edi
  803ae8:	31 ff                	xor    %edi,%edi
  803aea:	89 fa                	mov    %edi,%edx
  803aec:	83 c4 1c             	add    $0x1c,%esp
  803aef:	5b                   	pop    %ebx
  803af0:	5e                   	pop    %esi
  803af1:	5f                   	pop    %edi
  803af2:	5d                   	pop    %ebp
  803af3:	c3                   	ret    
  803af4:	bd 20 00 00 00       	mov    $0x20,%ebp
  803af9:	89 eb                	mov    %ebp,%ebx
  803afb:	29 fb                	sub    %edi,%ebx
  803afd:	89 f9                	mov    %edi,%ecx
  803aff:	d3 e6                	shl    %cl,%esi
  803b01:	89 c5                	mov    %eax,%ebp
  803b03:	88 d9                	mov    %bl,%cl
  803b05:	d3 ed                	shr    %cl,%ebp
  803b07:	89 e9                	mov    %ebp,%ecx
  803b09:	09 f1                	or     %esi,%ecx
  803b0b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803b0f:	89 f9                	mov    %edi,%ecx
  803b11:	d3 e0                	shl    %cl,%eax
  803b13:	89 c5                	mov    %eax,%ebp
  803b15:	89 d6                	mov    %edx,%esi
  803b17:	88 d9                	mov    %bl,%cl
  803b19:	d3 ee                	shr    %cl,%esi
  803b1b:	89 f9                	mov    %edi,%ecx
  803b1d:	d3 e2                	shl    %cl,%edx
  803b1f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b23:	88 d9                	mov    %bl,%cl
  803b25:	d3 e8                	shr    %cl,%eax
  803b27:	09 c2                	or     %eax,%edx
  803b29:	89 d0                	mov    %edx,%eax
  803b2b:	89 f2                	mov    %esi,%edx
  803b2d:	f7 74 24 0c          	divl   0xc(%esp)
  803b31:	89 d6                	mov    %edx,%esi
  803b33:	89 c3                	mov    %eax,%ebx
  803b35:	f7 e5                	mul    %ebp
  803b37:	39 d6                	cmp    %edx,%esi
  803b39:	72 19                	jb     803b54 <__udivdi3+0xfc>
  803b3b:	74 0b                	je     803b48 <__udivdi3+0xf0>
  803b3d:	89 d8                	mov    %ebx,%eax
  803b3f:	31 ff                	xor    %edi,%edi
  803b41:	e9 58 ff ff ff       	jmp    803a9e <__udivdi3+0x46>
  803b46:	66 90                	xchg   %ax,%ax
  803b48:	8b 54 24 08          	mov    0x8(%esp),%edx
  803b4c:	89 f9                	mov    %edi,%ecx
  803b4e:	d3 e2                	shl    %cl,%edx
  803b50:	39 c2                	cmp    %eax,%edx
  803b52:	73 e9                	jae    803b3d <__udivdi3+0xe5>
  803b54:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803b57:	31 ff                	xor    %edi,%edi
  803b59:	e9 40 ff ff ff       	jmp    803a9e <__udivdi3+0x46>
  803b5e:	66 90                	xchg   %ax,%ax
  803b60:	31 c0                	xor    %eax,%eax
  803b62:	e9 37 ff ff ff       	jmp    803a9e <__udivdi3+0x46>
  803b67:	90                   	nop

00803b68 <__umoddi3>:
  803b68:	55                   	push   %ebp
  803b69:	57                   	push   %edi
  803b6a:	56                   	push   %esi
  803b6b:	53                   	push   %ebx
  803b6c:	83 ec 1c             	sub    $0x1c,%esp
  803b6f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803b73:	8b 74 24 34          	mov    0x34(%esp),%esi
  803b77:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b7b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803b7f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803b83:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803b87:	89 f3                	mov    %esi,%ebx
  803b89:	89 fa                	mov    %edi,%edx
  803b8b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b8f:	89 34 24             	mov    %esi,(%esp)
  803b92:	85 c0                	test   %eax,%eax
  803b94:	75 1a                	jne    803bb0 <__umoddi3+0x48>
  803b96:	39 f7                	cmp    %esi,%edi
  803b98:	0f 86 a2 00 00 00    	jbe    803c40 <__umoddi3+0xd8>
  803b9e:	89 c8                	mov    %ecx,%eax
  803ba0:	89 f2                	mov    %esi,%edx
  803ba2:	f7 f7                	div    %edi
  803ba4:	89 d0                	mov    %edx,%eax
  803ba6:	31 d2                	xor    %edx,%edx
  803ba8:	83 c4 1c             	add    $0x1c,%esp
  803bab:	5b                   	pop    %ebx
  803bac:	5e                   	pop    %esi
  803bad:	5f                   	pop    %edi
  803bae:	5d                   	pop    %ebp
  803baf:	c3                   	ret    
  803bb0:	39 f0                	cmp    %esi,%eax
  803bb2:	0f 87 ac 00 00 00    	ja     803c64 <__umoddi3+0xfc>
  803bb8:	0f bd e8             	bsr    %eax,%ebp
  803bbb:	83 f5 1f             	xor    $0x1f,%ebp
  803bbe:	0f 84 ac 00 00 00    	je     803c70 <__umoddi3+0x108>
  803bc4:	bf 20 00 00 00       	mov    $0x20,%edi
  803bc9:	29 ef                	sub    %ebp,%edi
  803bcb:	89 fe                	mov    %edi,%esi
  803bcd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803bd1:	89 e9                	mov    %ebp,%ecx
  803bd3:	d3 e0                	shl    %cl,%eax
  803bd5:	89 d7                	mov    %edx,%edi
  803bd7:	89 f1                	mov    %esi,%ecx
  803bd9:	d3 ef                	shr    %cl,%edi
  803bdb:	09 c7                	or     %eax,%edi
  803bdd:	89 e9                	mov    %ebp,%ecx
  803bdf:	d3 e2                	shl    %cl,%edx
  803be1:	89 14 24             	mov    %edx,(%esp)
  803be4:	89 d8                	mov    %ebx,%eax
  803be6:	d3 e0                	shl    %cl,%eax
  803be8:	89 c2                	mov    %eax,%edx
  803bea:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bee:	d3 e0                	shl    %cl,%eax
  803bf0:	89 44 24 04          	mov    %eax,0x4(%esp)
  803bf4:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bf8:	89 f1                	mov    %esi,%ecx
  803bfa:	d3 e8                	shr    %cl,%eax
  803bfc:	09 d0                	or     %edx,%eax
  803bfe:	d3 eb                	shr    %cl,%ebx
  803c00:	89 da                	mov    %ebx,%edx
  803c02:	f7 f7                	div    %edi
  803c04:	89 d3                	mov    %edx,%ebx
  803c06:	f7 24 24             	mull   (%esp)
  803c09:	89 c6                	mov    %eax,%esi
  803c0b:	89 d1                	mov    %edx,%ecx
  803c0d:	39 d3                	cmp    %edx,%ebx
  803c0f:	0f 82 87 00 00 00    	jb     803c9c <__umoddi3+0x134>
  803c15:	0f 84 91 00 00 00    	je     803cac <__umoddi3+0x144>
  803c1b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803c1f:	29 f2                	sub    %esi,%edx
  803c21:	19 cb                	sbb    %ecx,%ebx
  803c23:	89 d8                	mov    %ebx,%eax
  803c25:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803c29:	d3 e0                	shl    %cl,%eax
  803c2b:	89 e9                	mov    %ebp,%ecx
  803c2d:	d3 ea                	shr    %cl,%edx
  803c2f:	09 d0                	or     %edx,%eax
  803c31:	89 e9                	mov    %ebp,%ecx
  803c33:	d3 eb                	shr    %cl,%ebx
  803c35:	89 da                	mov    %ebx,%edx
  803c37:	83 c4 1c             	add    $0x1c,%esp
  803c3a:	5b                   	pop    %ebx
  803c3b:	5e                   	pop    %esi
  803c3c:	5f                   	pop    %edi
  803c3d:	5d                   	pop    %ebp
  803c3e:	c3                   	ret    
  803c3f:	90                   	nop
  803c40:	89 fd                	mov    %edi,%ebp
  803c42:	85 ff                	test   %edi,%edi
  803c44:	75 0b                	jne    803c51 <__umoddi3+0xe9>
  803c46:	b8 01 00 00 00       	mov    $0x1,%eax
  803c4b:	31 d2                	xor    %edx,%edx
  803c4d:	f7 f7                	div    %edi
  803c4f:	89 c5                	mov    %eax,%ebp
  803c51:	89 f0                	mov    %esi,%eax
  803c53:	31 d2                	xor    %edx,%edx
  803c55:	f7 f5                	div    %ebp
  803c57:	89 c8                	mov    %ecx,%eax
  803c59:	f7 f5                	div    %ebp
  803c5b:	89 d0                	mov    %edx,%eax
  803c5d:	e9 44 ff ff ff       	jmp    803ba6 <__umoddi3+0x3e>
  803c62:	66 90                	xchg   %ax,%ax
  803c64:	89 c8                	mov    %ecx,%eax
  803c66:	89 f2                	mov    %esi,%edx
  803c68:	83 c4 1c             	add    $0x1c,%esp
  803c6b:	5b                   	pop    %ebx
  803c6c:	5e                   	pop    %esi
  803c6d:	5f                   	pop    %edi
  803c6e:	5d                   	pop    %ebp
  803c6f:	c3                   	ret    
  803c70:	3b 04 24             	cmp    (%esp),%eax
  803c73:	72 06                	jb     803c7b <__umoddi3+0x113>
  803c75:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803c79:	77 0f                	ja     803c8a <__umoddi3+0x122>
  803c7b:	89 f2                	mov    %esi,%edx
  803c7d:	29 f9                	sub    %edi,%ecx
  803c7f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803c83:	89 14 24             	mov    %edx,(%esp)
  803c86:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c8a:	8b 44 24 04          	mov    0x4(%esp),%eax
  803c8e:	8b 14 24             	mov    (%esp),%edx
  803c91:	83 c4 1c             	add    $0x1c,%esp
  803c94:	5b                   	pop    %ebx
  803c95:	5e                   	pop    %esi
  803c96:	5f                   	pop    %edi
  803c97:	5d                   	pop    %ebp
  803c98:	c3                   	ret    
  803c99:	8d 76 00             	lea    0x0(%esi),%esi
  803c9c:	2b 04 24             	sub    (%esp),%eax
  803c9f:	19 fa                	sbb    %edi,%edx
  803ca1:	89 d1                	mov    %edx,%ecx
  803ca3:	89 c6                	mov    %eax,%esi
  803ca5:	e9 71 ff ff ff       	jmp    803c1b <__umoddi3+0xb3>
  803caa:	66 90                	xchg   %ax,%ax
  803cac:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803cb0:	72 ea                	jb     803c9c <__umoddi3+0x134>
  803cb2:	89 d9                	mov    %ebx,%ecx
  803cb4:	e9 62 ff ff ff       	jmp    803c1b <__umoddi3+0xb3>
