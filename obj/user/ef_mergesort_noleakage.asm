
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
  800041:	e8 5e 1e 00 00       	call   801ea4 <sys_disable_interrupt>

		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 e0 3b 80 00       	push   $0x803be0
  80004e:	e8 54 0b 00 00       	call   800ba7 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 e2 3b 80 00       	push   $0x803be2
  80005e:	e8 44 0b 00 00       	call   800ba7 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 f8 3b 80 00       	push   $0x803bf8
  80006e:	e8 34 0b 00 00       	call   800ba7 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 e2 3b 80 00       	push   $0x803be2
  80007e:	e8 24 0b 00 00       	call   800ba7 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 e0 3b 80 00       	push   $0x803be0
  80008e:	e8 14 0b 00 00       	call   800ba7 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
		//readline("Enter the number of elements: ", Line);
		cprintf("Enter the number of elements: ");
  800096:	83 ec 0c             	sub    $0xc,%esp
  800099:	68 10 3c 80 00       	push   $0x803c10
  80009e:	e8 04 0b 00 00       	call   800ba7 <cprintf>
  8000a3:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = 2000 ;
  8000a6:	c7 45 f0 d0 07 00 00 	movl   $0x7d0,-0x10(%ebp)
		cprintf("%d\n", NumOfElements) ;
  8000ad:	83 ec 08             	sub    $0x8,%esp
  8000b0:	ff 75 f0             	pushl  -0x10(%ebp)
  8000b3:	68 2f 3c 80 00       	push   $0x803c2f
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
  8000d8:	68 34 3c 80 00       	push   $0x803c34
  8000dd:	e8 c5 0a 00 00       	call   800ba7 <cprintf>
  8000e2:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	68 56 3c 80 00       	push   $0x803c56
  8000ed:	e8 b5 0a 00 00       	call   800ba7 <cprintf>
  8000f2:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000f5:	83 ec 0c             	sub    $0xc,%esp
  8000f8:	68 64 3c 80 00       	push   $0x803c64
  8000fd:	e8 a5 0a 00 00       	call   800ba7 <cprintf>
  800102:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  800105:	83 ec 0c             	sub    $0xc,%esp
  800108:	68 73 3c 80 00       	push   $0x803c73
  80010d:	e8 95 0a 00 00       	call   800ba7 <cprintf>
  800112:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800115:	83 ec 0c             	sub    $0xc,%esp
  800118:	68 83 3c 80 00       	push   $0x803c83
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
  800158:	e8 61 1d 00 00       	call   801ebe <sys_enable_interrupt>

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
  8001cd:	e8 d2 1c 00 00       	call   801ea4 <sys_disable_interrupt>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001d2:	83 ec 0c             	sub    $0xc,%esp
  8001d5:	68 8c 3c 80 00       	push   $0x803c8c
  8001da:	e8 c8 09 00 00       	call   800ba7 <cprintf>
  8001df:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001e2:	e8 d7 1c 00 00       	call   801ebe <sys_enable_interrupt>

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
  800204:	68 c0 3c 80 00       	push   $0x803cc0
  800209:	6a 4e                	push   $0x4e
  80020b:	68 e2 3c 80 00       	push   $0x803ce2
  800210:	e8 de 06 00 00       	call   8008f3 <_panic>
		else
		{
			sys_disable_interrupt();
  800215:	e8 8a 1c 00 00       	call   801ea4 <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  80021a:	83 ec 0c             	sub    $0xc,%esp
  80021d:	68 00 3d 80 00       	push   $0x803d00
  800222:	e8 80 09 00 00       	call   800ba7 <cprintf>
  800227:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  80022a:	83 ec 0c             	sub    $0xc,%esp
  80022d:	68 34 3d 80 00       	push   $0x803d34
  800232:	e8 70 09 00 00       	call   800ba7 <cprintf>
  800237:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  80023a:	83 ec 0c             	sub    $0xc,%esp
  80023d:	68 68 3d 80 00       	push   $0x803d68
  800242:	e8 60 09 00 00       	call   800ba7 <cprintf>
  800247:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  80024a:	e8 6f 1c 00 00       	call   801ebe <sys_enable_interrupt>
		}

		free(Elements) ;
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	ff 75 ec             	pushl  -0x14(%ebp)
  800255:	e8 03 19 00 00       	call   801b5d <free>
  80025a:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  80025d:	e8 42 1c 00 00       	call   801ea4 <sys_disable_interrupt>
			Chose = 0 ;
  800262:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800266:	eb 3e                	jmp    8002a6 <_main+0x26e>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800268:	83 ec 0c             	sub    $0xc,%esp
  80026b:	68 9a 3d 80 00       	push   $0x803d9a
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
  8002b2:	e8 07 1c 00 00       	call   801ebe <sys_enable_interrupt>

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
  800446:	68 e0 3b 80 00       	push   $0x803be0
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
  800468:	68 b8 3d 80 00       	push   $0x803db8
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
  800496:	68 2f 3c 80 00       	push   $0x803c2f
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
  8006fe:	e8 5a 14 00 00       	call   801b5d <free>
  800703:	83 c4 10             	add    $0x10,%esp
	free(Right);
  800706:	83 ec 0c             	sub    $0xc,%esp
  800709:	ff 75 d4             	pushl  -0x2c(%ebp)
  80070c:	e8 4c 14 00 00       	call   801b5d <free>
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
  80072b:	e8 a8 17 00 00       	call   801ed8 <sys_cputc>
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
  80073c:	e8 63 17 00 00       	call   801ea4 <sys_disable_interrupt>
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
  80074f:	e8 84 17 00 00       	call   801ed8 <sys_cputc>
  800754:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800757:	e8 62 17 00 00       	call   801ebe <sys_enable_interrupt>
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
  80076e:	e8 ac 15 00 00       	call   801d1f <sys_cgetc>
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
  800787:	e8 18 17 00 00       	call   801ea4 <sys_disable_interrupt>
	int c=0;
  80078c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800793:	eb 08                	jmp    80079d <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800795:	e8 85 15 00 00       	call   801d1f <sys_cgetc>
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
  8007a3:	e8 16 17 00 00       	call   801ebe <sys_enable_interrupt>
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
  8007bd:	e8 d5 18 00 00       	call   802097 <sys_getenvindex>
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
  800828:	e8 77 16 00 00       	call   801ea4 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80082d:	83 ec 0c             	sub    $0xc,%esp
  800830:	68 d8 3d 80 00       	push   $0x803dd8
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
  800858:	68 00 3e 80 00       	push   $0x803e00
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
  800889:	68 28 3e 80 00       	push   $0x803e28
  80088e:	e8 14 03 00 00       	call   800ba7 <cprintf>
  800893:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800896:	a1 24 50 80 00       	mov    0x805024,%eax
  80089b:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8008a1:	83 ec 08             	sub    $0x8,%esp
  8008a4:	50                   	push   %eax
  8008a5:	68 80 3e 80 00       	push   $0x803e80
  8008aa:	e8 f8 02 00 00       	call   800ba7 <cprintf>
  8008af:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8008b2:	83 ec 0c             	sub    $0xc,%esp
  8008b5:	68 d8 3d 80 00       	push   $0x803dd8
  8008ba:	e8 e8 02 00 00       	call   800ba7 <cprintf>
  8008bf:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8008c2:	e8 f7 15 00 00       	call   801ebe <sys_enable_interrupt>

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
  8008da:	e8 84 17 00 00       	call   802063 <sys_destroy_env>
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
  8008eb:	e8 d9 17 00 00       	call   8020c9 <sys_exit_env>
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
  800914:	68 94 3e 80 00       	push   $0x803e94
  800919:	e8 89 02 00 00       	call   800ba7 <cprintf>
  80091e:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800921:	a1 00 50 80 00       	mov    0x805000,%eax
  800926:	ff 75 0c             	pushl  0xc(%ebp)
  800929:	ff 75 08             	pushl  0x8(%ebp)
  80092c:	50                   	push   %eax
  80092d:	68 99 3e 80 00       	push   $0x803e99
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
  800951:	68 b5 3e 80 00       	push   $0x803eb5
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
  80097d:	68 b8 3e 80 00       	push   $0x803eb8
  800982:	6a 26                	push   $0x26
  800984:	68 04 3f 80 00       	push   $0x803f04
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
  800a4f:	68 10 3f 80 00       	push   $0x803f10
  800a54:	6a 3a                	push   $0x3a
  800a56:	68 04 3f 80 00       	push   $0x803f04
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
  800abf:	68 64 3f 80 00       	push   $0x803f64
  800ac4:	6a 44                	push   $0x44
  800ac6:	68 04 3f 80 00       	push   $0x803f04
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
  800b19:	e8 d8 11 00 00       	call   801cf6 <sys_cputs>
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
  800b90:	e8 61 11 00 00       	call   801cf6 <sys_cputs>
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
  800bda:	e8 c5 12 00 00       	call   801ea4 <sys_disable_interrupt>
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
  800bfa:	e8 bf 12 00 00       	call   801ebe <sys_enable_interrupt>
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
  800c44:	e8 33 2d 00 00       	call   80397c <__udivdi3>
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
  800c94:	e8 f3 2d 00 00       	call   803a8c <__umoddi3>
  800c99:	83 c4 10             	add    $0x10,%esp
  800c9c:	05 d4 41 80 00       	add    $0x8041d4,%eax
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
  800def:	8b 04 85 f8 41 80 00 	mov    0x8041f8(,%eax,4),%eax
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
  800ed0:	8b 34 9d 40 40 80 00 	mov    0x804040(,%ebx,4),%esi
  800ed7:	85 f6                	test   %esi,%esi
  800ed9:	75 19                	jne    800ef4 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800edb:	53                   	push   %ebx
  800edc:	68 e5 41 80 00       	push   $0x8041e5
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
  800ef5:	68 ee 41 80 00       	push   $0x8041ee
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
  800f22:	be f1 41 80 00       	mov    $0x8041f1,%esi
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
  801948:	68 50 43 80 00       	push   $0x804350
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
  801a18:	e8 1d 04 00 00       	call   801e3a <sys_allocate_chunk>
  801a1d:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801a20:	a1 20 51 80 00       	mov    0x805120,%eax
  801a25:	83 ec 0c             	sub    $0xc,%esp
  801a28:	50                   	push   %eax
  801a29:	e8 92 0a 00 00       	call   8024c0 <initialize_MemBlocksList>
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
  801a56:	68 75 43 80 00       	push   $0x804375
  801a5b:	6a 33                	push   $0x33
  801a5d:	68 93 43 80 00       	push   $0x804393
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
  801ad5:	68 a0 43 80 00       	push   $0x8043a0
  801ada:	6a 34                	push   $0x34
  801adc:	68 93 43 80 00       	push   $0x804393
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
  801b32:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b35:	e8 f7 fd ff ff       	call   801931 <InitializeUHeap>
	if (size == 0) return NULL ;
  801b3a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b3e:	75 07                	jne    801b47 <malloc+0x18>
  801b40:	b8 00 00 00 00       	mov    $0x0,%eax
  801b45:	eb 14                	jmp    801b5b <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801b47:	83 ec 04             	sub    $0x4,%esp
  801b4a:	68 c4 43 80 00       	push   $0x8043c4
  801b4f:	6a 46                	push   $0x46
  801b51:	68 93 43 80 00       	push   $0x804393
  801b56:	e8 98 ed ff ff       	call   8008f3 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801b5b:	c9                   	leave  
  801b5c:	c3                   	ret    

00801b5d <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801b5d:	55                   	push   %ebp
  801b5e:	89 e5                	mov    %esp,%ebp
  801b60:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801b63:	83 ec 04             	sub    $0x4,%esp
  801b66:	68 ec 43 80 00       	push   $0x8043ec
  801b6b:	6a 61                	push   $0x61
  801b6d:	68 93 43 80 00       	push   $0x804393
  801b72:	e8 7c ed ff ff       	call   8008f3 <_panic>

00801b77 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801b77:	55                   	push   %ebp
  801b78:	89 e5                	mov    %esp,%ebp
  801b7a:	83 ec 38             	sub    $0x38,%esp
  801b7d:	8b 45 10             	mov    0x10(%ebp),%eax
  801b80:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b83:	e8 a9 fd ff ff       	call   801931 <InitializeUHeap>
	if (size == 0) return NULL ;
  801b88:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b8c:	75 07                	jne    801b95 <smalloc+0x1e>
  801b8e:	b8 00 00 00 00       	mov    $0x0,%eax
  801b93:	eb 7c                	jmp    801c11 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801b95:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801b9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ba2:	01 d0                	add    %edx,%eax
  801ba4:	48                   	dec    %eax
  801ba5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ba8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bab:	ba 00 00 00 00       	mov    $0x0,%edx
  801bb0:	f7 75 f0             	divl   -0x10(%ebp)
  801bb3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bb6:	29 d0                	sub    %edx,%eax
  801bb8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801bbb:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801bc2:	e8 41 06 00 00       	call   802208 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801bc7:	85 c0                	test   %eax,%eax
  801bc9:	74 11                	je     801bdc <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  801bcb:	83 ec 0c             	sub    $0xc,%esp
  801bce:	ff 75 e8             	pushl  -0x18(%ebp)
  801bd1:	e8 ac 0c 00 00       	call   802882 <alloc_block_FF>
  801bd6:	83 c4 10             	add    $0x10,%esp
  801bd9:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801bdc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801be0:	74 2a                	je     801c0c <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801be2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be5:	8b 40 08             	mov    0x8(%eax),%eax
  801be8:	89 c2                	mov    %eax,%edx
  801bea:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801bee:	52                   	push   %edx
  801bef:	50                   	push   %eax
  801bf0:	ff 75 0c             	pushl  0xc(%ebp)
  801bf3:	ff 75 08             	pushl  0x8(%ebp)
  801bf6:	e8 92 03 00 00       	call   801f8d <sys_createSharedObject>
  801bfb:	83 c4 10             	add    $0x10,%esp
  801bfe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  801c01:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  801c05:	74 05                	je     801c0c <smalloc+0x95>
			return (void*)virtual_address;
  801c07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c0a:	eb 05                	jmp    801c11 <smalloc+0x9a>
	}
	return NULL;
  801c0c:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801c11:	c9                   	leave  
  801c12:	c3                   	ret    

00801c13 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801c13:	55                   	push   %ebp
  801c14:	89 e5                	mov    %esp,%ebp
  801c16:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c19:	e8 13 fd ff ff       	call   801931 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801c1e:	83 ec 04             	sub    $0x4,%esp
  801c21:	68 10 44 80 00       	push   $0x804410
  801c26:	68 a2 00 00 00       	push   $0xa2
  801c2b:	68 93 43 80 00       	push   $0x804393
  801c30:	e8 be ec ff ff       	call   8008f3 <_panic>

00801c35 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801c35:	55                   	push   %ebp
  801c36:	89 e5                	mov    %esp,%ebp
  801c38:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c3b:	e8 f1 fc ff ff       	call   801931 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801c40:	83 ec 04             	sub    $0x4,%esp
  801c43:	68 34 44 80 00       	push   $0x804434
  801c48:	68 e6 00 00 00       	push   $0xe6
  801c4d:	68 93 43 80 00       	push   $0x804393
  801c52:	e8 9c ec ff ff       	call   8008f3 <_panic>

00801c57 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801c57:	55                   	push   %ebp
  801c58:	89 e5                	mov    %esp,%ebp
  801c5a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801c5d:	83 ec 04             	sub    $0x4,%esp
  801c60:	68 5c 44 80 00       	push   $0x80445c
  801c65:	68 fa 00 00 00       	push   $0xfa
  801c6a:	68 93 43 80 00       	push   $0x804393
  801c6f:	e8 7f ec ff ff       	call   8008f3 <_panic>

00801c74 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801c74:	55                   	push   %ebp
  801c75:	89 e5                	mov    %esp,%ebp
  801c77:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c7a:	83 ec 04             	sub    $0x4,%esp
  801c7d:	68 80 44 80 00       	push   $0x804480
  801c82:	68 05 01 00 00       	push   $0x105
  801c87:	68 93 43 80 00       	push   $0x804393
  801c8c:	e8 62 ec ff ff       	call   8008f3 <_panic>

00801c91 <shrink>:

}
void shrink(uint32 newSize)
{
  801c91:	55                   	push   %ebp
  801c92:	89 e5                	mov    %esp,%ebp
  801c94:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c97:	83 ec 04             	sub    $0x4,%esp
  801c9a:	68 80 44 80 00       	push   $0x804480
  801c9f:	68 0a 01 00 00       	push   $0x10a
  801ca4:	68 93 43 80 00       	push   $0x804393
  801ca9:	e8 45 ec ff ff       	call   8008f3 <_panic>

00801cae <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801cae:	55                   	push   %ebp
  801caf:	89 e5                	mov    %esp,%ebp
  801cb1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801cb4:	83 ec 04             	sub    $0x4,%esp
  801cb7:	68 80 44 80 00       	push   $0x804480
  801cbc:	68 0f 01 00 00       	push   $0x10f
  801cc1:	68 93 43 80 00       	push   $0x804393
  801cc6:	e8 28 ec ff ff       	call   8008f3 <_panic>

00801ccb <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801ccb:	55                   	push   %ebp
  801ccc:	89 e5                	mov    %esp,%ebp
  801cce:	57                   	push   %edi
  801ccf:	56                   	push   %esi
  801cd0:	53                   	push   %ebx
  801cd1:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cda:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cdd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ce0:	8b 7d 18             	mov    0x18(%ebp),%edi
  801ce3:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801ce6:	cd 30                	int    $0x30
  801ce8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801ceb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801cee:	83 c4 10             	add    $0x10,%esp
  801cf1:	5b                   	pop    %ebx
  801cf2:	5e                   	pop    %esi
  801cf3:	5f                   	pop    %edi
  801cf4:	5d                   	pop    %ebp
  801cf5:	c3                   	ret    

00801cf6 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801cf6:	55                   	push   %ebp
  801cf7:	89 e5                	mov    %esp,%ebp
  801cf9:	83 ec 04             	sub    $0x4,%esp
  801cfc:	8b 45 10             	mov    0x10(%ebp),%eax
  801cff:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801d02:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d06:	8b 45 08             	mov    0x8(%ebp),%eax
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 00                	push   $0x0
  801d0d:	52                   	push   %edx
  801d0e:	ff 75 0c             	pushl  0xc(%ebp)
  801d11:	50                   	push   %eax
  801d12:	6a 00                	push   $0x0
  801d14:	e8 b2 ff ff ff       	call   801ccb <syscall>
  801d19:	83 c4 18             	add    $0x18,%esp
}
  801d1c:	90                   	nop
  801d1d:	c9                   	leave  
  801d1e:	c3                   	ret    

00801d1f <sys_cgetc>:

int
sys_cgetc(void)
{
  801d1f:	55                   	push   %ebp
  801d20:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801d22:	6a 00                	push   $0x0
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 01                	push   $0x1
  801d2e:	e8 98 ff ff ff       	call   801ccb <syscall>
  801d33:	83 c4 18             	add    $0x18,%esp
}
  801d36:	c9                   	leave  
  801d37:	c3                   	ret    

00801d38 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801d38:	55                   	push   %ebp
  801d39:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801d3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	52                   	push   %edx
  801d48:	50                   	push   %eax
  801d49:	6a 05                	push   $0x5
  801d4b:	e8 7b ff ff ff       	call   801ccb <syscall>
  801d50:	83 c4 18             	add    $0x18,%esp
}
  801d53:	c9                   	leave  
  801d54:	c3                   	ret    

00801d55 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801d55:	55                   	push   %ebp
  801d56:	89 e5                	mov    %esp,%ebp
  801d58:	56                   	push   %esi
  801d59:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801d5a:	8b 75 18             	mov    0x18(%ebp),%esi
  801d5d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d60:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d63:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d66:	8b 45 08             	mov    0x8(%ebp),%eax
  801d69:	56                   	push   %esi
  801d6a:	53                   	push   %ebx
  801d6b:	51                   	push   %ecx
  801d6c:	52                   	push   %edx
  801d6d:	50                   	push   %eax
  801d6e:	6a 06                	push   $0x6
  801d70:	e8 56 ff ff ff       	call   801ccb <syscall>
  801d75:	83 c4 18             	add    $0x18,%esp
}
  801d78:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d7b:	5b                   	pop    %ebx
  801d7c:	5e                   	pop    %esi
  801d7d:	5d                   	pop    %ebp
  801d7e:	c3                   	ret    

00801d7f <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801d7f:	55                   	push   %ebp
  801d80:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801d82:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d85:	8b 45 08             	mov    0x8(%ebp),%eax
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 00                	push   $0x0
  801d8e:	52                   	push   %edx
  801d8f:	50                   	push   %eax
  801d90:	6a 07                	push   $0x7
  801d92:	e8 34 ff ff ff       	call   801ccb <syscall>
  801d97:	83 c4 18             	add    $0x18,%esp
}
  801d9a:	c9                   	leave  
  801d9b:	c3                   	ret    

00801d9c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801d9c:	55                   	push   %ebp
  801d9d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 00                	push   $0x0
  801da3:	6a 00                	push   $0x0
  801da5:	ff 75 0c             	pushl  0xc(%ebp)
  801da8:	ff 75 08             	pushl  0x8(%ebp)
  801dab:	6a 08                	push   $0x8
  801dad:	e8 19 ff ff ff       	call   801ccb <syscall>
  801db2:	83 c4 18             	add    $0x18,%esp
}
  801db5:	c9                   	leave  
  801db6:	c3                   	ret    

00801db7 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801db7:	55                   	push   %ebp
  801db8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801dba:	6a 00                	push   $0x0
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 09                	push   $0x9
  801dc6:	e8 00 ff ff ff       	call   801ccb <syscall>
  801dcb:	83 c4 18             	add    $0x18,%esp
}
  801dce:	c9                   	leave  
  801dcf:	c3                   	ret    

00801dd0 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801dd0:	55                   	push   %ebp
  801dd1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 0a                	push   $0xa
  801ddf:	e8 e7 fe ff ff       	call   801ccb <syscall>
  801de4:	83 c4 18             	add    $0x18,%esp
}
  801de7:	c9                   	leave  
  801de8:	c3                   	ret    

00801de9 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801de9:	55                   	push   %ebp
  801dea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 0b                	push   $0xb
  801df8:	e8 ce fe ff ff       	call   801ccb <syscall>
  801dfd:	83 c4 18             	add    $0x18,%esp
}
  801e00:	c9                   	leave  
  801e01:	c3                   	ret    

00801e02 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801e02:	55                   	push   %ebp
  801e03:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801e05:	6a 00                	push   $0x0
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	ff 75 0c             	pushl  0xc(%ebp)
  801e0e:	ff 75 08             	pushl  0x8(%ebp)
  801e11:	6a 0f                	push   $0xf
  801e13:	e8 b3 fe ff ff       	call   801ccb <syscall>
  801e18:	83 c4 18             	add    $0x18,%esp
	return;
  801e1b:	90                   	nop
}
  801e1c:	c9                   	leave  
  801e1d:	c3                   	ret    

00801e1e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801e1e:	55                   	push   %ebp
  801e1f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801e21:	6a 00                	push   $0x0
  801e23:	6a 00                	push   $0x0
  801e25:	6a 00                	push   $0x0
  801e27:	ff 75 0c             	pushl  0xc(%ebp)
  801e2a:	ff 75 08             	pushl  0x8(%ebp)
  801e2d:	6a 10                	push   $0x10
  801e2f:	e8 97 fe ff ff       	call   801ccb <syscall>
  801e34:	83 c4 18             	add    $0x18,%esp
	return ;
  801e37:	90                   	nop
}
  801e38:	c9                   	leave  
  801e39:	c3                   	ret    

00801e3a <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e3a:	55                   	push   %ebp
  801e3b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	ff 75 10             	pushl  0x10(%ebp)
  801e44:	ff 75 0c             	pushl  0xc(%ebp)
  801e47:	ff 75 08             	pushl  0x8(%ebp)
  801e4a:	6a 11                	push   $0x11
  801e4c:	e8 7a fe ff ff       	call   801ccb <syscall>
  801e51:	83 c4 18             	add    $0x18,%esp
	return ;
  801e54:	90                   	nop
}
  801e55:	c9                   	leave  
  801e56:	c3                   	ret    

00801e57 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801e57:	55                   	push   %ebp
  801e58:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801e5a:	6a 00                	push   $0x0
  801e5c:	6a 00                	push   $0x0
  801e5e:	6a 00                	push   $0x0
  801e60:	6a 00                	push   $0x0
  801e62:	6a 00                	push   $0x0
  801e64:	6a 0c                	push   $0xc
  801e66:	e8 60 fe ff ff       	call   801ccb <syscall>
  801e6b:	83 c4 18             	add    $0x18,%esp
}
  801e6e:	c9                   	leave  
  801e6f:	c3                   	ret    

00801e70 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801e70:	55                   	push   %ebp
  801e71:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801e73:	6a 00                	push   $0x0
  801e75:	6a 00                	push   $0x0
  801e77:	6a 00                	push   $0x0
  801e79:	6a 00                	push   $0x0
  801e7b:	ff 75 08             	pushl  0x8(%ebp)
  801e7e:	6a 0d                	push   $0xd
  801e80:	e8 46 fe ff ff       	call   801ccb <syscall>
  801e85:	83 c4 18             	add    $0x18,%esp
}
  801e88:	c9                   	leave  
  801e89:	c3                   	ret    

00801e8a <sys_scarce_memory>:

void sys_scarce_memory()
{
  801e8a:	55                   	push   %ebp
  801e8b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801e8d:	6a 00                	push   $0x0
  801e8f:	6a 00                	push   $0x0
  801e91:	6a 00                	push   $0x0
  801e93:	6a 00                	push   $0x0
  801e95:	6a 00                	push   $0x0
  801e97:	6a 0e                	push   $0xe
  801e99:	e8 2d fe ff ff       	call   801ccb <syscall>
  801e9e:	83 c4 18             	add    $0x18,%esp
}
  801ea1:	90                   	nop
  801ea2:	c9                   	leave  
  801ea3:	c3                   	ret    

00801ea4 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801ea4:	55                   	push   %ebp
  801ea5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801ea7:	6a 00                	push   $0x0
  801ea9:	6a 00                	push   $0x0
  801eab:	6a 00                	push   $0x0
  801ead:	6a 00                	push   $0x0
  801eaf:	6a 00                	push   $0x0
  801eb1:	6a 13                	push   $0x13
  801eb3:	e8 13 fe ff ff       	call   801ccb <syscall>
  801eb8:	83 c4 18             	add    $0x18,%esp
}
  801ebb:	90                   	nop
  801ebc:	c9                   	leave  
  801ebd:	c3                   	ret    

00801ebe <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801ebe:	55                   	push   %ebp
  801ebf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801ec1:	6a 00                	push   $0x0
  801ec3:	6a 00                	push   $0x0
  801ec5:	6a 00                	push   $0x0
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 00                	push   $0x0
  801ecb:	6a 14                	push   $0x14
  801ecd:	e8 f9 fd ff ff       	call   801ccb <syscall>
  801ed2:	83 c4 18             	add    $0x18,%esp
}
  801ed5:	90                   	nop
  801ed6:	c9                   	leave  
  801ed7:	c3                   	ret    

00801ed8 <sys_cputc>:


void
sys_cputc(const char c)
{
  801ed8:	55                   	push   %ebp
  801ed9:	89 e5                	mov    %esp,%ebp
  801edb:	83 ec 04             	sub    $0x4,%esp
  801ede:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ee4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 00                	push   $0x0
  801eec:	6a 00                	push   $0x0
  801eee:	6a 00                	push   $0x0
  801ef0:	50                   	push   %eax
  801ef1:	6a 15                	push   $0x15
  801ef3:	e8 d3 fd ff ff       	call   801ccb <syscall>
  801ef8:	83 c4 18             	add    $0x18,%esp
}
  801efb:	90                   	nop
  801efc:	c9                   	leave  
  801efd:	c3                   	ret    

00801efe <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801efe:	55                   	push   %ebp
  801eff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801f01:	6a 00                	push   $0x0
  801f03:	6a 00                	push   $0x0
  801f05:	6a 00                	push   $0x0
  801f07:	6a 00                	push   $0x0
  801f09:	6a 00                	push   $0x0
  801f0b:	6a 16                	push   $0x16
  801f0d:	e8 b9 fd ff ff       	call   801ccb <syscall>
  801f12:	83 c4 18             	add    $0x18,%esp
}
  801f15:	90                   	nop
  801f16:	c9                   	leave  
  801f17:	c3                   	ret    

00801f18 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801f18:	55                   	push   %ebp
  801f19:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1e:	6a 00                	push   $0x0
  801f20:	6a 00                	push   $0x0
  801f22:	6a 00                	push   $0x0
  801f24:	ff 75 0c             	pushl  0xc(%ebp)
  801f27:	50                   	push   %eax
  801f28:	6a 17                	push   $0x17
  801f2a:	e8 9c fd ff ff       	call   801ccb <syscall>
  801f2f:	83 c4 18             	add    $0x18,%esp
}
  801f32:	c9                   	leave  
  801f33:	c3                   	ret    

00801f34 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801f34:	55                   	push   %ebp
  801f35:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f37:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3d:	6a 00                	push   $0x0
  801f3f:	6a 00                	push   $0x0
  801f41:	6a 00                	push   $0x0
  801f43:	52                   	push   %edx
  801f44:	50                   	push   %eax
  801f45:	6a 1a                	push   $0x1a
  801f47:	e8 7f fd ff ff       	call   801ccb <syscall>
  801f4c:	83 c4 18             	add    $0x18,%esp
}
  801f4f:	c9                   	leave  
  801f50:	c3                   	ret    

00801f51 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f51:	55                   	push   %ebp
  801f52:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f54:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f57:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5a:	6a 00                	push   $0x0
  801f5c:	6a 00                	push   $0x0
  801f5e:	6a 00                	push   $0x0
  801f60:	52                   	push   %edx
  801f61:	50                   	push   %eax
  801f62:	6a 18                	push   $0x18
  801f64:	e8 62 fd ff ff       	call   801ccb <syscall>
  801f69:	83 c4 18             	add    $0x18,%esp
}
  801f6c:	90                   	nop
  801f6d:	c9                   	leave  
  801f6e:	c3                   	ret    

00801f6f <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f6f:	55                   	push   %ebp
  801f70:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f72:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f75:	8b 45 08             	mov    0x8(%ebp),%eax
  801f78:	6a 00                	push   $0x0
  801f7a:	6a 00                	push   $0x0
  801f7c:	6a 00                	push   $0x0
  801f7e:	52                   	push   %edx
  801f7f:	50                   	push   %eax
  801f80:	6a 19                	push   $0x19
  801f82:	e8 44 fd ff ff       	call   801ccb <syscall>
  801f87:	83 c4 18             	add    $0x18,%esp
}
  801f8a:	90                   	nop
  801f8b:	c9                   	leave  
  801f8c:	c3                   	ret    

00801f8d <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801f8d:	55                   	push   %ebp
  801f8e:	89 e5                	mov    %esp,%ebp
  801f90:	83 ec 04             	sub    $0x4,%esp
  801f93:	8b 45 10             	mov    0x10(%ebp),%eax
  801f96:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801f99:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f9c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa3:	6a 00                	push   $0x0
  801fa5:	51                   	push   %ecx
  801fa6:	52                   	push   %edx
  801fa7:	ff 75 0c             	pushl  0xc(%ebp)
  801faa:	50                   	push   %eax
  801fab:	6a 1b                	push   $0x1b
  801fad:	e8 19 fd ff ff       	call   801ccb <syscall>
  801fb2:	83 c4 18             	add    $0x18,%esp
}
  801fb5:	c9                   	leave  
  801fb6:	c3                   	ret    

00801fb7 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801fb7:	55                   	push   %ebp
  801fb8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801fba:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc0:	6a 00                	push   $0x0
  801fc2:	6a 00                	push   $0x0
  801fc4:	6a 00                	push   $0x0
  801fc6:	52                   	push   %edx
  801fc7:	50                   	push   %eax
  801fc8:	6a 1c                	push   $0x1c
  801fca:	e8 fc fc ff ff       	call   801ccb <syscall>
  801fcf:	83 c4 18             	add    $0x18,%esp
}
  801fd2:	c9                   	leave  
  801fd3:	c3                   	ret    

00801fd4 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801fd4:	55                   	push   %ebp
  801fd5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801fd7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fda:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe0:	6a 00                	push   $0x0
  801fe2:	6a 00                	push   $0x0
  801fe4:	51                   	push   %ecx
  801fe5:	52                   	push   %edx
  801fe6:	50                   	push   %eax
  801fe7:	6a 1d                	push   $0x1d
  801fe9:	e8 dd fc ff ff       	call   801ccb <syscall>
  801fee:	83 c4 18             	add    $0x18,%esp
}
  801ff1:	c9                   	leave  
  801ff2:	c3                   	ret    

00801ff3 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801ff3:	55                   	push   %ebp
  801ff4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801ff6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffc:	6a 00                	push   $0x0
  801ffe:	6a 00                	push   $0x0
  802000:	6a 00                	push   $0x0
  802002:	52                   	push   %edx
  802003:	50                   	push   %eax
  802004:	6a 1e                	push   $0x1e
  802006:	e8 c0 fc ff ff       	call   801ccb <syscall>
  80200b:	83 c4 18             	add    $0x18,%esp
}
  80200e:	c9                   	leave  
  80200f:	c3                   	ret    

00802010 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802010:	55                   	push   %ebp
  802011:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802013:	6a 00                	push   $0x0
  802015:	6a 00                	push   $0x0
  802017:	6a 00                	push   $0x0
  802019:	6a 00                	push   $0x0
  80201b:	6a 00                	push   $0x0
  80201d:	6a 1f                	push   $0x1f
  80201f:	e8 a7 fc ff ff       	call   801ccb <syscall>
  802024:	83 c4 18             	add    $0x18,%esp
}
  802027:	c9                   	leave  
  802028:	c3                   	ret    

00802029 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802029:	55                   	push   %ebp
  80202a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80202c:	8b 45 08             	mov    0x8(%ebp),%eax
  80202f:	6a 00                	push   $0x0
  802031:	ff 75 14             	pushl  0x14(%ebp)
  802034:	ff 75 10             	pushl  0x10(%ebp)
  802037:	ff 75 0c             	pushl  0xc(%ebp)
  80203a:	50                   	push   %eax
  80203b:	6a 20                	push   $0x20
  80203d:	e8 89 fc ff ff       	call   801ccb <syscall>
  802042:	83 c4 18             	add    $0x18,%esp
}
  802045:	c9                   	leave  
  802046:	c3                   	ret    

00802047 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802047:	55                   	push   %ebp
  802048:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80204a:	8b 45 08             	mov    0x8(%ebp),%eax
  80204d:	6a 00                	push   $0x0
  80204f:	6a 00                	push   $0x0
  802051:	6a 00                	push   $0x0
  802053:	6a 00                	push   $0x0
  802055:	50                   	push   %eax
  802056:	6a 21                	push   $0x21
  802058:	e8 6e fc ff ff       	call   801ccb <syscall>
  80205d:	83 c4 18             	add    $0x18,%esp
}
  802060:	90                   	nop
  802061:	c9                   	leave  
  802062:	c3                   	ret    

00802063 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802063:	55                   	push   %ebp
  802064:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802066:	8b 45 08             	mov    0x8(%ebp),%eax
  802069:	6a 00                	push   $0x0
  80206b:	6a 00                	push   $0x0
  80206d:	6a 00                	push   $0x0
  80206f:	6a 00                	push   $0x0
  802071:	50                   	push   %eax
  802072:	6a 22                	push   $0x22
  802074:	e8 52 fc ff ff       	call   801ccb <syscall>
  802079:	83 c4 18             	add    $0x18,%esp
}
  80207c:	c9                   	leave  
  80207d:	c3                   	ret    

0080207e <sys_getenvid>:

int32 sys_getenvid(void)
{
  80207e:	55                   	push   %ebp
  80207f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802081:	6a 00                	push   $0x0
  802083:	6a 00                	push   $0x0
  802085:	6a 00                	push   $0x0
  802087:	6a 00                	push   $0x0
  802089:	6a 00                	push   $0x0
  80208b:	6a 02                	push   $0x2
  80208d:	e8 39 fc ff ff       	call   801ccb <syscall>
  802092:	83 c4 18             	add    $0x18,%esp
}
  802095:	c9                   	leave  
  802096:	c3                   	ret    

00802097 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802097:	55                   	push   %ebp
  802098:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80209a:	6a 00                	push   $0x0
  80209c:	6a 00                	push   $0x0
  80209e:	6a 00                	push   $0x0
  8020a0:	6a 00                	push   $0x0
  8020a2:	6a 00                	push   $0x0
  8020a4:	6a 03                	push   $0x3
  8020a6:	e8 20 fc ff ff       	call   801ccb <syscall>
  8020ab:	83 c4 18             	add    $0x18,%esp
}
  8020ae:	c9                   	leave  
  8020af:	c3                   	ret    

008020b0 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8020b0:	55                   	push   %ebp
  8020b1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8020b3:	6a 00                	push   $0x0
  8020b5:	6a 00                	push   $0x0
  8020b7:	6a 00                	push   $0x0
  8020b9:	6a 00                	push   $0x0
  8020bb:	6a 00                	push   $0x0
  8020bd:	6a 04                	push   $0x4
  8020bf:	e8 07 fc ff ff       	call   801ccb <syscall>
  8020c4:	83 c4 18             	add    $0x18,%esp
}
  8020c7:	c9                   	leave  
  8020c8:	c3                   	ret    

008020c9 <sys_exit_env>:


void sys_exit_env(void)
{
  8020c9:	55                   	push   %ebp
  8020ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8020cc:	6a 00                	push   $0x0
  8020ce:	6a 00                	push   $0x0
  8020d0:	6a 00                	push   $0x0
  8020d2:	6a 00                	push   $0x0
  8020d4:	6a 00                	push   $0x0
  8020d6:	6a 23                	push   $0x23
  8020d8:	e8 ee fb ff ff       	call   801ccb <syscall>
  8020dd:	83 c4 18             	add    $0x18,%esp
}
  8020e0:	90                   	nop
  8020e1:	c9                   	leave  
  8020e2:	c3                   	ret    

008020e3 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8020e3:	55                   	push   %ebp
  8020e4:	89 e5                	mov    %esp,%ebp
  8020e6:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8020e9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020ec:	8d 50 04             	lea    0x4(%eax),%edx
  8020ef:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020f2:	6a 00                	push   $0x0
  8020f4:	6a 00                	push   $0x0
  8020f6:	6a 00                	push   $0x0
  8020f8:	52                   	push   %edx
  8020f9:	50                   	push   %eax
  8020fa:	6a 24                	push   $0x24
  8020fc:	e8 ca fb ff ff       	call   801ccb <syscall>
  802101:	83 c4 18             	add    $0x18,%esp
	return result;
  802104:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802107:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80210a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80210d:	89 01                	mov    %eax,(%ecx)
  80210f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802112:	8b 45 08             	mov    0x8(%ebp),%eax
  802115:	c9                   	leave  
  802116:	c2 04 00             	ret    $0x4

00802119 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802119:	55                   	push   %ebp
  80211a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80211c:	6a 00                	push   $0x0
  80211e:	6a 00                	push   $0x0
  802120:	ff 75 10             	pushl  0x10(%ebp)
  802123:	ff 75 0c             	pushl  0xc(%ebp)
  802126:	ff 75 08             	pushl  0x8(%ebp)
  802129:	6a 12                	push   $0x12
  80212b:	e8 9b fb ff ff       	call   801ccb <syscall>
  802130:	83 c4 18             	add    $0x18,%esp
	return ;
  802133:	90                   	nop
}
  802134:	c9                   	leave  
  802135:	c3                   	ret    

00802136 <sys_rcr2>:
uint32 sys_rcr2()
{
  802136:	55                   	push   %ebp
  802137:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802139:	6a 00                	push   $0x0
  80213b:	6a 00                	push   $0x0
  80213d:	6a 00                	push   $0x0
  80213f:	6a 00                	push   $0x0
  802141:	6a 00                	push   $0x0
  802143:	6a 25                	push   $0x25
  802145:	e8 81 fb ff ff       	call   801ccb <syscall>
  80214a:	83 c4 18             	add    $0x18,%esp
}
  80214d:	c9                   	leave  
  80214e:	c3                   	ret    

0080214f <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80214f:	55                   	push   %ebp
  802150:	89 e5                	mov    %esp,%ebp
  802152:	83 ec 04             	sub    $0x4,%esp
  802155:	8b 45 08             	mov    0x8(%ebp),%eax
  802158:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80215b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80215f:	6a 00                	push   $0x0
  802161:	6a 00                	push   $0x0
  802163:	6a 00                	push   $0x0
  802165:	6a 00                	push   $0x0
  802167:	50                   	push   %eax
  802168:	6a 26                	push   $0x26
  80216a:	e8 5c fb ff ff       	call   801ccb <syscall>
  80216f:	83 c4 18             	add    $0x18,%esp
	return ;
  802172:	90                   	nop
}
  802173:	c9                   	leave  
  802174:	c3                   	ret    

00802175 <rsttst>:
void rsttst()
{
  802175:	55                   	push   %ebp
  802176:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802178:	6a 00                	push   $0x0
  80217a:	6a 00                	push   $0x0
  80217c:	6a 00                	push   $0x0
  80217e:	6a 00                	push   $0x0
  802180:	6a 00                	push   $0x0
  802182:	6a 28                	push   $0x28
  802184:	e8 42 fb ff ff       	call   801ccb <syscall>
  802189:	83 c4 18             	add    $0x18,%esp
	return ;
  80218c:	90                   	nop
}
  80218d:	c9                   	leave  
  80218e:	c3                   	ret    

0080218f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80218f:	55                   	push   %ebp
  802190:	89 e5                	mov    %esp,%ebp
  802192:	83 ec 04             	sub    $0x4,%esp
  802195:	8b 45 14             	mov    0x14(%ebp),%eax
  802198:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80219b:	8b 55 18             	mov    0x18(%ebp),%edx
  80219e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8021a2:	52                   	push   %edx
  8021a3:	50                   	push   %eax
  8021a4:	ff 75 10             	pushl  0x10(%ebp)
  8021a7:	ff 75 0c             	pushl  0xc(%ebp)
  8021aa:	ff 75 08             	pushl  0x8(%ebp)
  8021ad:	6a 27                	push   $0x27
  8021af:	e8 17 fb ff ff       	call   801ccb <syscall>
  8021b4:	83 c4 18             	add    $0x18,%esp
	return ;
  8021b7:	90                   	nop
}
  8021b8:	c9                   	leave  
  8021b9:	c3                   	ret    

008021ba <chktst>:
void chktst(uint32 n)
{
  8021ba:	55                   	push   %ebp
  8021bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8021bd:	6a 00                	push   $0x0
  8021bf:	6a 00                	push   $0x0
  8021c1:	6a 00                	push   $0x0
  8021c3:	6a 00                	push   $0x0
  8021c5:	ff 75 08             	pushl  0x8(%ebp)
  8021c8:	6a 29                	push   $0x29
  8021ca:	e8 fc fa ff ff       	call   801ccb <syscall>
  8021cf:	83 c4 18             	add    $0x18,%esp
	return ;
  8021d2:	90                   	nop
}
  8021d3:	c9                   	leave  
  8021d4:	c3                   	ret    

008021d5 <inctst>:

void inctst()
{
  8021d5:	55                   	push   %ebp
  8021d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8021d8:	6a 00                	push   $0x0
  8021da:	6a 00                	push   $0x0
  8021dc:	6a 00                	push   $0x0
  8021de:	6a 00                	push   $0x0
  8021e0:	6a 00                	push   $0x0
  8021e2:	6a 2a                	push   $0x2a
  8021e4:	e8 e2 fa ff ff       	call   801ccb <syscall>
  8021e9:	83 c4 18             	add    $0x18,%esp
	return ;
  8021ec:	90                   	nop
}
  8021ed:	c9                   	leave  
  8021ee:	c3                   	ret    

008021ef <gettst>:
uint32 gettst()
{
  8021ef:	55                   	push   %ebp
  8021f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8021f2:	6a 00                	push   $0x0
  8021f4:	6a 00                	push   $0x0
  8021f6:	6a 00                	push   $0x0
  8021f8:	6a 00                	push   $0x0
  8021fa:	6a 00                	push   $0x0
  8021fc:	6a 2b                	push   $0x2b
  8021fe:	e8 c8 fa ff ff       	call   801ccb <syscall>
  802203:	83 c4 18             	add    $0x18,%esp
}
  802206:	c9                   	leave  
  802207:	c3                   	ret    

00802208 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802208:	55                   	push   %ebp
  802209:	89 e5                	mov    %esp,%ebp
  80220b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80220e:	6a 00                	push   $0x0
  802210:	6a 00                	push   $0x0
  802212:	6a 00                	push   $0x0
  802214:	6a 00                	push   $0x0
  802216:	6a 00                	push   $0x0
  802218:	6a 2c                	push   $0x2c
  80221a:	e8 ac fa ff ff       	call   801ccb <syscall>
  80221f:	83 c4 18             	add    $0x18,%esp
  802222:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802225:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802229:	75 07                	jne    802232 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80222b:	b8 01 00 00 00       	mov    $0x1,%eax
  802230:	eb 05                	jmp    802237 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802232:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802237:	c9                   	leave  
  802238:	c3                   	ret    

00802239 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802239:	55                   	push   %ebp
  80223a:	89 e5                	mov    %esp,%ebp
  80223c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80223f:	6a 00                	push   $0x0
  802241:	6a 00                	push   $0x0
  802243:	6a 00                	push   $0x0
  802245:	6a 00                	push   $0x0
  802247:	6a 00                	push   $0x0
  802249:	6a 2c                	push   $0x2c
  80224b:	e8 7b fa ff ff       	call   801ccb <syscall>
  802250:	83 c4 18             	add    $0x18,%esp
  802253:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802256:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80225a:	75 07                	jne    802263 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80225c:	b8 01 00 00 00       	mov    $0x1,%eax
  802261:	eb 05                	jmp    802268 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802263:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802268:	c9                   	leave  
  802269:	c3                   	ret    

0080226a <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80226a:	55                   	push   %ebp
  80226b:	89 e5                	mov    %esp,%ebp
  80226d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802270:	6a 00                	push   $0x0
  802272:	6a 00                	push   $0x0
  802274:	6a 00                	push   $0x0
  802276:	6a 00                	push   $0x0
  802278:	6a 00                	push   $0x0
  80227a:	6a 2c                	push   $0x2c
  80227c:	e8 4a fa ff ff       	call   801ccb <syscall>
  802281:	83 c4 18             	add    $0x18,%esp
  802284:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802287:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80228b:	75 07                	jne    802294 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80228d:	b8 01 00 00 00       	mov    $0x1,%eax
  802292:	eb 05                	jmp    802299 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802294:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802299:	c9                   	leave  
  80229a:	c3                   	ret    

0080229b <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80229b:	55                   	push   %ebp
  80229c:	89 e5                	mov    %esp,%ebp
  80229e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022a1:	6a 00                	push   $0x0
  8022a3:	6a 00                	push   $0x0
  8022a5:	6a 00                	push   $0x0
  8022a7:	6a 00                	push   $0x0
  8022a9:	6a 00                	push   $0x0
  8022ab:	6a 2c                	push   $0x2c
  8022ad:	e8 19 fa ff ff       	call   801ccb <syscall>
  8022b2:	83 c4 18             	add    $0x18,%esp
  8022b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8022b8:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8022bc:	75 07                	jne    8022c5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8022be:	b8 01 00 00 00       	mov    $0x1,%eax
  8022c3:	eb 05                	jmp    8022ca <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8022c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022ca:	c9                   	leave  
  8022cb:	c3                   	ret    

008022cc <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8022cc:	55                   	push   %ebp
  8022cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8022cf:	6a 00                	push   $0x0
  8022d1:	6a 00                	push   $0x0
  8022d3:	6a 00                	push   $0x0
  8022d5:	6a 00                	push   $0x0
  8022d7:	ff 75 08             	pushl  0x8(%ebp)
  8022da:	6a 2d                	push   $0x2d
  8022dc:	e8 ea f9 ff ff       	call   801ccb <syscall>
  8022e1:	83 c4 18             	add    $0x18,%esp
	return ;
  8022e4:	90                   	nop
}
  8022e5:	c9                   	leave  
  8022e6:	c3                   	ret    

008022e7 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8022e7:	55                   	push   %ebp
  8022e8:	89 e5                	mov    %esp,%ebp
  8022ea:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8022eb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022ee:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f7:	6a 00                	push   $0x0
  8022f9:	53                   	push   %ebx
  8022fa:	51                   	push   %ecx
  8022fb:	52                   	push   %edx
  8022fc:	50                   	push   %eax
  8022fd:	6a 2e                	push   $0x2e
  8022ff:	e8 c7 f9 ff ff       	call   801ccb <syscall>
  802304:	83 c4 18             	add    $0x18,%esp
}
  802307:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80230a:	c9                   	leave  
  80230b:	c3                   	ret    

0080230c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80230c:	55                   	push   %ebp
  80230d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80230f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802312:	8b 45 08             	mov    0x8(%ebp),%eax
  802315:	6a 00                	push   $0x0
  802317:	6a 00                	push   $0x0
  802319:	6a 00                	push   $0x0
  80231b:	52                   	push   %edx
  80231c:	50                   	push   %eax
  80231d:	6a 2f                	push   $0x2f
  80231f:	e8 a7 f9 ff ff       	call   801ccb <syscall>
  802324:	83 c4 18             	add    $0x18,%esp
}
  802327:	c9                   	leave  
  802328:	c3                   	ret    

00802329 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802329:	55                   	push   %ebp
  80232a:	89 e5                	mov    %esp,%ebp
  80232c:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80232f:	83 ec 0c             	sub    $0xc,%esp
  802332:	68 90 44 80 00       	push   $0x804490
  802337:	e8 6b e8 ff ff       	call   800ba7 <cprintf>
  80233c:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80233f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802346:	83 ec 0c             	sub    $0xc,%esp
  802349:	68 bc 44 80 00       	push   $0x8044bc
  80234e:	e8 54 e8 ff ff       	call   800ba7 <cprintf>
  802353:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802356:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80235a:	a1 38 51 80 00       	mov    0x805138,%eax
  80235f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802362:	eb 56                	jmp    8023ba <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802364:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802368:	74 1c                	je     802386 <print_mem_block_lists+0x5d>
  80236a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236d:	8b 50 08             	mov    0x8(%eax),%edx
  802370:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802373:	8b 48 08             	mov    0x8(%eax),%ecx
  802376:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802379:	8b 40 0c             	mov    0xc(%eax),%eax
  80237c:	01 c8                	add    %ecx,%eax
  80237e:	39 c2                	cmp    %eax,%edx
  802380:	73 04                	jae    802386 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802382:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802386:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802389:	8b 50 08             	mov    0x8(%eax),%edx
  80238c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238f:	8b 40 0c             	mov    0xc(%eax),%eax
  802392:	01 c2                	add    %eax,%edx
  802394:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802397:	8b 40 08             	mov    0x8(%eax),%eax
  80239a:	83 ec 04             	sub    $0x4,%esp
  80239d:	52                   	push   %edx
  80239e:	50                   	push   %eax
  80239f:	68 d1 44 80 00       	push   $0x8044d1
  8023a4:	e8 fe e7 ff ff       	call   800ba7 <cprintf>
  8023a9:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8023ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023af:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8023b2:	a1 40 51 80 00       	mov    0x805140,%eax
  8023b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023be:	74 07                	je     8023c7 <print_mem_block_lists+0x9e>
  8023c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c3:	8b 00                	mov    (%eax),%eax
  8023c5:	eb 05                	jmp    8023cc <print_mem_block_lists+0xa3>
  8023c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8023cc:	a3 40 51 80 00       	mov    %eax,0x805140
  8023d1:	a1 40 51 80 00       	mov    0x805140,%eax
  8023d6:	85 c0                	test   %eax,%eax
  8023d8:	75 8a                	jne    802364 <print_mem_block_lists+0x3b>
  8023da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023de:	75 84                	jne    802364 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8023e0:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8023e4:	75 10                	jne    8023f6 <print_mem_block_lists+0xcd>
  8023e6:	83 ec 0c             	sub    $0xc,%esp
  8023e9:	68 e0 44 80 00       	push   $0x8044e0
  8023ee:	e8 b4 e7 ff ff       	call   800ba7 <cprintf>
  8023f3:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8023f6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8023fd:	83 ec 0c             	sub    $0xc,%esp
  802400:	68 04 45 80 00       	push   $0x804504
  802405:	e8 9d e7 ff ff       	call   800ba7 <cprintf>
  80240a:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80240d:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802411:	a1 40 50 80 00       	mov    0x805040,%eax
  802416:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802419:	eb 56                	jmp    802471 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80241b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80241f:	74 1c                	je     80243d <print_mem_block_lists+0x114>
  802421:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802424:	8b 50 08             	mov    0x8(%eax),%edx
  802427:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80242a:	8b 48 08             	mov    0x8(%eax),%ecx
  80242d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802430:	8b 40 0c             	mov    0xc(%eax),%eax
  802433:	01 c8                	add    %ecx,%eax
  802435:	39 c2                	cmp    %eax,%edx
  802437:	73 04                	jae    80243d <print_mem_block_lists+0x114>
			sorted = 0 ;
  802439:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80243d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802440:	8b 50 08             	mov    0x8(%eax),%edx
  802443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802446:	8b 40 0c             	mov    0xc(%eax),%eax
  802449:	01 c2                	add    %eax,%edx
  80244b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244e:	8b 40 08             	mov    0x8(%eax),%eax
  802451:	83 ec 04             	sub    $0x4,%esp
  802454:	52                   	push   %edx
  802455:	50                   	push   %eax
  802456:	68 d1 44 80 00       	push   $0x8044d1
  80245b:	e8 47 e7 ff ff       	call   800ba7 <cprintf>
  802460:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802463:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802466:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802469:	a1 48 50 80 00       	mov    0x805048,%eax
  80246e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802471:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802475:	74 07                	je     80247e <print_mem_block_lists+0x155>
  802477:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247a:	8b 00                	mov    (%eax),%eax
  80247c:	eb 05                	jmp    802483 <print_mem_block_lists+0x15a>
  80247e:	b8 00 00 00 00       	mov    $0x0,%eax
  802483:	a3 48 50 80 00       	mov    %eax,0x805048
  802488:	a1 48 50 80 00       	mov    0x805048,%eax
  80248d:	85 c0                	test   %eax,%eax
  80248f:	75 8a                	jne    80241b <print_mem_block_lists+0xf2>
  802491:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802495:	75 84                	jne    80241b <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802497:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80249b:	75 10                	jne    8024ad <print_mem_block_lists+0x184>
  80249d:	83 ec 0c             	sub    $0xc,%esp
  8024a0:	68 1c 45 80 00       	push   $0x80451c
  8024a5:	e8 fd e6 ff ff       	call   800ba7 <cprintf>
  8024aa:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8024ad:	83 ec 0c             	sub    $0xc,%esp
  8024b0:	68 90 44 80 00       	push   $0x804490
  8024b5:	e8 ed e6 ff ff       	call   800ba7 <cprintf>
  8024ba:	83 c4 10             	add    $0x10,%esp

}
  8024bd:	90                   	nop
  8024be:	c9                   	leave  
  8024bf:	c3                   	ret    

008024c0 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8024c0:	55                   	push   %ebp
  8024c1:	89 e5                	mov    %esp,%ebp
  8024c3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8024c6:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8024cd:	00 00 00 
  8024d0:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8024d7:	00 00 00 
  8024da:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8024e1:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8024e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8024eb:	e9 9e 00 00 00       	jmp    80258e <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8024f0:	a1 50 50 80 00       	mov    0x805050,%eax
  8024f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024f8:	c1 e2 04             	shl    $0x4,%edx
  8024fb:	01 d0                	add    %edx,%eax
  8024fd:	85 c0                	test   %eax,%eax
  8024ff:	75 14                	jne    802515 <initialize_MemBlocksList+0x55>
  802501:	83 ec 04             	sub    $0x4,%esp
  802504:	68 44 45 80 00       	push   $0x804544
  802509:	6a 46                	push   $0x46
  80250b:	68 67 45 80 00       	push   $0x804567
  802510:	e8 de e3 ff ff       	call   8008f3 <_panic>
  802515:	a1 50 50 80 00       	mov    0x805050,%eax
  80251a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80251d:	c1 e2 04             	shl    $0x4,%edx
  802520:	01 d0                	add    %edx,%eax
  802522:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802528:	89 10                	mov    %edx,(%eax)
  80252a:	8b 00                	mov    (%eax),%eax
  80252c:	85 c0                	test   %eax,%eax
  80252e:	74 18                	je     802548 <initialize_MemBlocksList+0x88>
  802530:	a1 48 51 80 00       	mov    0x805148,%eax
  802535:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80253b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80253e:	c1 e1 04             	shl    $0x4,%ecx
  802541:	01 ca                	add    %ecx,%edx
  802543:	89 50 04             	mov    %edx,0x4(%eax)
  802546:	eb 12                	jmp    80255a <initialize_MemBlocksList+0x9a>
  802548:	a1 50 50 80 00       	mov    0x805050,%eax
  80254d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802550:	c1 e2 04             	shl    $0x4,%edx
  802553:	01 d0                	add    %edx,%eax
  802555:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80255a:	a1 50 50 80 00       	mov    0x805050,%eax
  80255f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802562:	c1 e2 04             	shl    $0x4,%edx
  802565:	01 d0                	add    %edx,%eax
  802567:	a3 48 51 80 00       	mov    %eax,0x805148
  80256c:	a1 50 50 80 00       	mov    0x805050,%eax
  802571:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802574:	c1 e2 04             	shl    $0x4,%edx
  802577:	01 d0                	add    %edx,%eax
  802579:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802580:	a1 54 51 80 00       	mov    0x805154,%eax
  802585:	40                   	inc    %eax
  802586:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  80258b:	ff 45 f4             	incl   -0xc(%ebp)
  80258e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802591:	3b 45 08             	cmp    0x8(%ebp),%eax
  802594:	0f 82 56 ff ff ff    	jb     8024f0 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  80259a:	90                   	nop
  80259b:	c9                   	leave  
  80259c:	c3                   	ret    

0080259d <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80259d:	55                   	push   %ebp
  80259e:	89 e5                	mov    %esp,%ebp
  8025a0:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8025a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a6:	8b 00                	mov    (%eax),%eax
  8025a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8025ab:	eb 19                	jmp    8025c6 <find_block+0x29>
	{
		if(va==point->sva)
  8025ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025b0:	8b 40 08             	mov    0x8(%eax),%eax
  8025b3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8025b6:	75 05                	jne    8025bd <find_block+0x20>
		   return point;
  8025b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025bb:	eb 36                	jmp    8025f3 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8025bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c0:	8b 40 08             	mov    0x8(%eax),%eax
  8025c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8025c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8025ca:	74 07                	je     8025d3 <find_block+0x36>
  8025cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025cf:	8b 00                	mov    (%eax),%eax
  8025d1:	eb 05                	jmp    8025d8 <find_block+0x3b>
  8025d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8025d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8025db:	89 42 08             	mov    %eax,0x8(%edx)
  8025de:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e1:	8b 40 08             	mov    0x8(%eax),%eax
  8025e4:	85 c0                	test   %eax,%eax
  8025e6:	75 c5                	jne    8025ad <find_block+0x10>
  8025e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8025ec:	75 bf                	jne    8025ad <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8025ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025f3:	c9                   	leave  
  8025f4:	c3                   	ret    

008025f5 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8025f5:	55                   	push   %ebp
  8025f6:	89 e5                	mov    %esp,%ebp
  8025f8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8025fb:	a1 40 50 80 00       	mov    0x805040,%eax
  802600:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802603:	a1 44 50 80 00       	mov    0x805044,%eax
  802608:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80260b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80260e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802611:	74 24                	je     802637 <insert_sorted_allocList+0x42>
  802613:	8b 45 08             	mov    0x8(%ebp),%eax
  802616:	8b 50 08             	mov    0x8(%eax),%edx
  802619:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80261c:	8b 40 08             	mov    0x8(%eax),%eax
  80261f:	39 c2                	cmp    %eax,%edx
  802621:	76 14                	jbe    802637 <insert_sorted_allocList+0x42>
  802623:	8b 45 08             	mov    0x8(%ebp),%eax
  802626:	8b 50 08             	mov    0x8(%eax),%edx
  802629:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80262c:	8b 40 08             	mov    0x8(%eax),%eax
  80262f:	39 c2                	cmp    %eax,%edx
  802631:	0f 82 60 01 00 00    	jb     802797 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802637:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80263b:	75 65                	jne    8026a2 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80263d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802641:	75 14                	jne    802657 <insert_sorted_allocList+0x62>
  802643:	83 ec 04             	sub    $0x4,%esp
  802646:	68 44 45 80 00       	push   $0x804544
  80264b:	6a 6b                	push   $0x6b
  80264d:	68 67 45 80 00       	push   $0x804567
  802652:	e8 9c e2 ff ff       	call   8008f3 <_panic>
  802657:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80265d:	8b 45 08             	mov    0x8(%ebp),%eax
  802660:	89 10                	mov    %edx,(%eax)
  802662:	8b 45 08             	mov    0x8(%ebp),%eax
  802665:	8b 00                	mov    (%eax),%eax
  802667:	85 c0                	test   %eax,%eax
  802669:	74 0d                	je     802678 <insert_sorted_allocList+0x83>
  80266b:	a1 40 50 80 00       	mov    0x805040,%eax
  802670:	8b 55 08             	mov    0x8(%ebp),%edx
  802673:	89 50 04             	mov    %edx,0x4(%eax)
  802676:	eb 08                	jmp    802680 <insert_sorted_allocList+0x8b>
  802678:	8b 45 08             	mov    0x8(%ebp),%eax
  80267b:	a3 44 50 80 00       	mov    %eax,0x805044
  802680:	8b 45 08             	mov    0x8(%ebp),%eax
  802683:	a3 40 50 80 00       	mov    %eax,0x805040
  802688:	8b 45 08             	mov    0x8(%ebp),%eax
  80268b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802692:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802697:	40                   	inc    %eax
  802698:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80269d:	e9 dc 01 00 00       	jmp    80287e <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8026a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a5:	8b 50 08             	mov    0x8(%eax),%edx
  8026a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ab:	8b 40 08             	mov    0x8(%eax),%eax
  8026ae:	39 c2                	cmp    %eax,%edx
  8026b0:	77 6c                	ja     80271e <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8026b2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026b6:	74 06                	je     8026be <insert_sorted_allocList+0xc9>
  8026b8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026bc:	75 14                	jne    8026d2 <insert_sorted_allocList+0xdd>
  8026be:	83 ec 04             	sub    $0x4,%esp
  8026c1:	68 80 45 80 00       	push   $0x804580
  8026c6:	6a 6f                	push   $0x6f
  8026c8:	68 67 45 80 00       	push   $0x804567
  8026cd:	e8 21 e2 ff ff       	call   8008f3 <_panic>
  8026d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026d5:	8b 50 04             	mov    0x4(%eax),%edx
  8026d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026db:	89 50 04             	mov    %edx,0x4(%eax)
  8026de:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026e4:	89 10                	mov    %edx,(%eax)
  8026e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e9:	8b 40 04             	mov    0x4(%eax),%eax
  8026ec:	85 c0                	test   %eax,%eax
  8026ee:	74 0d                	je     8026fd <insert_sorted_allocList+0x108>
  8026f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026f3:	8b 40 04             	mov    0x4(%eax),%eax
  8026f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8026f9:	89 10                	mov    %edx,(%eax)
  8026fb:	eb 08                	jmp    802705 <insert_sorted_allocList+0x110>
  8026fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802700:	a3 40 50 80 00       	mov    %eax,0x805040
  802705:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802708:	8b 55 08             	mov    0x8(%ebp),%edx
  80270b:	89 50 04             	mov    %edx,0x4(%eax)
  80270e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802713:	40                   	inc    %eax
  802714:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802719:	e9 60 01 00 00       	jmp    80287e <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80271e:	8b 45 08             	mov    0x8(%ebp),%eax
  802721:	8b 50 08             	mov    0x8(%eax),%edx
  802724:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802727:	8b 40 08             	mov    0x8(%eax),%eax
  80272a:	39 c2                	cmp    %eax,%edx
  80272c:	0f 82 4c 01 00 00    	jb     80287e <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802732:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802736:	75 14                	jne    80274c <insert_sorted_allocList+0x157>
  802738:	83 ec 04             	sub    $0x4,%esp
  80273b:	68 b8 45 80 00       	push   $0x8045b8
  802740:	6a 73                	push   $0x73
  802742:	68 67 45 80 00       	push   $0x804567
  802747:	e8 a7 e1 ff ff       	call   8008f3 <_panic>
  80274c:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802752:	8b 45 08             	mov    0x8(%ebp),%eax
  802755:	89 50 04             	mov    %edx,0x4(%eax)
  802758:	8b 45 08             	mov    0x8(%ebp),%eax
  80275b:	8b 40 04             	mov    0x4(%eax),%eax
  80275e:	85 c0                	test   %eax,%eax
  802760:	74 0c                	je     80276e <insert_sorted_allocList+0x179>
  802762:	a1 44 50 80 00       	mov    0x805044,%eax
  802767:	8b 55 08             	mov    0x8(%ebp),%edx
  80276a:	89 10                	mov    %edx,(%eax)
  80276c:	eb 08                	jmp    802776 <insert_sorted_allocList+0x181>
  80276e:	8b 45 08             	mov    0x8(%ebp),%eax
  802771:	a3 40 50 80 00       	mov    %eax,0x805040
  802776:	8b 45 08             	mov    0x8(%ebp),%eax
  802779:	a3 44 50 80 00       	mov    %eax,0x805044
  80277e:	8b 45 08             	mov    0x8(%ebp),%eax
  802781:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802787:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80278c:	40                   	inc    %eax
  80278d:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802792:	e9 e7 00 00 00       	jmp    80287e <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802797:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80279a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80279d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8027a4:	a1 40 50 80 00       	mov    0x805040,%eax
  8027a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027ac:	e9 9d 00 00 00       	jmp    80284e <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8027b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b4:	8b 00                	mov    (%eax),%eax
  8027b6:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8027b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027bc:	8b 50 08             	mov    0x8(%eax),%edx
  8027bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c2:	8b 40 08             	mov    0x8(%eax),%eax
  8027c5:	39 c2                	cmp    %eax,%edx
  8027c7:	76 7d                	jbe    802846 <insert_sorted_allocList+0x251>
  8027c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027cc:	8b 50 08             	mov    0x8(%eax),%edx
  8027cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027d2:	8b 40 08             	mov    0x8(%eax),%eax
  8027d5:	39 c2                	cmp    %eax,%edx
  8027d7:	73 6d                	jae    802846 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8027d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027dd:	74 06                	je     8027e5 <insert_sorted_allocList+0x1f0>
  8027df:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027e3:	75 14                	jne    8027f9 <insert_sorted_allocList+0x204>
  8027e5:	83 ec 04             	sub    $0x4,%esp
  8027e8:	68 dc 45 80 00       	push   $0x8045dc
  8027ed:	6a 7f                	push   $0x7f
  8027ef:	68 67 45 80 00       	push   $0x804567
  8027f4:	e8 fa e0 ff ff       	call   8008f3 <_panic>
  8027f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fc:	8b 10                	mov    (%eax),%edx
  8027fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802801:	89 10                	mov    %edx,(%eax)
  802803:	8b 45 08             	mov    0x8(%ebp),%eax
  802806:	8b 00                	mov    (%eax),%eax
  802808:	85 c0                	test   %eax,%eax
  80280a:	74 0b                	je     802817 <insert_sorted_allocList+0x222>
  80280c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280f:	8b 00                	mov    (%eax),%eax
  802811:	8b 55 08             	mov    0x8(%ebp),%edx
  802814:	89 50 04             	mov    %edx,0x4(%eax)
  802817:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281a:	8b 55 08             	mov    0x8(%ebp),%edx
  80281d:	89 10                	mov    %edx,(%eax)
  80281f:	8b 45 08             	mov    0x8(%ebp),%eax
  802822:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802825:	89 50 04             	mov    %edx,0x4(%eax)
  802828:	8b 45 08             	mov    0x8(%ebp),%eax
  80282b:	8b 00                	mov    (%eax),%eax
  80282d:	85 c0                	test   %eax,%eax
  80282f:	75 08                	jne    802839 <insert_sorted_allocList+0x244>
  802831:	8b 45 08             	mov    0x8(%ebp),%eax
  802834:	a3 44 50 80 00       	mov    %eax,0x805044
  802839:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80283e:	40                   	inc    %eax
  80283f:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802844:	eb 39                	jmp    80287f <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802846:	a1 48 50 80 00       	mov    0x805048,%eax
  80284b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80284e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802852:	74 07                	je     80285b <insert_sorted_allocList+0x266>
  802854:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802857:	8b 00                	mov    (%eax),%eax
  802859:	eb 05                	jmp    802860 <insert_sorted_allocList+0x26b>
  80285b:	b8 00 00 00 00       	mov    $0x0,%eax
  802860:	a3 48 50 80 00       	mov    %eax,0x805048
  802865:	a1 48 50 80 00       	mov    0x805048,%eax
  80286a:	85 c0                	test   %eax,%eax
  80286c:	0f 85 3f ff ff ff    	jne    8027b1 <insert_sorted_allocList+0x1bc>
  802872:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802876:	0f 85 35 ff ff ff    	jne    8027b1 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80287c:	eb 01                	jmp    80287f <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80287e:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80287f:	90                   	nop
  802880:	c9                   	leave  
  802881:	c3                   	ret    

00802882 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802882:	55                   	push   %ebp
  802883:	89 e5                	mov    %esp,%ebp
  802885:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802888:	a1 38 51 80 00       	mov    0x805138,%eax
  80288d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802890:	e9 85 01 00 00       	jmp    802a1a <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802895:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802898:	8b 40 0c             	mov    0xc(%eax),%eax
  80289b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80289e:	0f 82 6e 01 00 00    	jb     802a12 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8028a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8028aa:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028ad:	0f 85 8a 00 00 00    	jne    80293d <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8028b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028b7:	75 17                	jne    8028d0 <alloc_block_FF+0x4e>
  8028b9:	83 ec 04             	sub    $0x4,%esp
  8028bc:	68 10 46 80 00       	push   $0x804610
  8028c1:	68 93 00 00 00       	push   $0x93
  8028c6:	68 67 45 80 00       	push   $0x804567
  8028cb:	e8 23 e0 ff ff       	call   8008f3 <_panic>
  8028d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d3:	8b 00                	mov    (%eax),%eax
  8028d5:	85 c0                	test   %eax,%eax
  8028d7:	74 10                	je     8028e9 <alloc_block_FF+0x67>
  8028d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028dc:	8b 00                	mov    (%eax),%eax
  8028de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028e1:	8b 52 04             	mov    0x4(%edx),%edx
  8028e4:	89 50 04             	mov    %edx,0x4(%eax)
  8028e7:	eb 0b                	jmp    8028f4 <alloc_block_FF+0x72>
  8028e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ec:	8b 40 04             	mov    0x4(%eax),%eax
  8028ef:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8028f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f7:	8b 40 04             	mov    0x4(%eax),%eax
  8028fa:	85 c0                	test   %eax,%eax
  8028fc:	74 0f                	je     80290d <alloc_block_FF+0x8b>
  8028fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802901:	8b 40 04             	mov    0x4(%eax),%eax
  802904:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802907:	8b 12                	mov    (%edx),%edx
  802909:	89 10                	mov    %edx,(%eax)
  80290b:	eb 0a                	jmp    802917 <alloc_block_FF+0x95>
  80290d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802910:	8b 00                	mov    (%eax),%eax
  802912:	a3 38 51 80 00       	mov    %eax,0x805138
  802917:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802920:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802923:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80292a:	a1 44 51 80 00       	mov    0x805144,%eax
  80292f:	48                   	dec    %eax
  802930:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802935:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802938:	e9 10 01 00 00       	jmp    802a4d <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  80293d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802940:	8b 40 0c             	mov    0xc(%eax),%eax
  802943:	3b 45 08             	cmp    0x8(%ebp),%eax
  802946:	0f 86 c6 00 00 00    	jbe    802a12 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80294c:	a1 48 51 80 00       	mov    0x805148,%eax
  802951:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802954:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802957:	8b 50 08             	mov    0x8(%eax),%edx
  80295a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80295d:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802960:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802963:	8b 55 08             	mov    0x8(%ebp),%edx
  802966:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802969:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80296d:	75 17                	jne    802986 <alloc_block_FF+0x104>
  80296f:	83 ec 04             	sub    $0x4,%esp
  802972:	68 10 46 80 00       	push   $0x804610
  802977:	68 9b 00 00 00       	push   $0x9b
  80297c:	68 67 45 80 00       	push   $0x804567
  802981:	e8 6d df ff ff       	call   8008f3 <_panic>
  802986:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802989:	8b 00                	mov    (%eax),%eax
  80298b:	85 c0                	test   %eax,%eax
  80298d:	74 10                	je     80299f <alloc_block_FF+0x11d>
  80298f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802992:	8b 00                	mov    (%eax),%eax
  802994:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802997:	8b 52 04             	mov    0x4(%edx),%edx
  80299a:	89 50 04             	mov    %edx,0x4(%eax)
  80299d:	eb 0b                	jmp    8029aa <alloc_block_FF+0x128>
  80299f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a2:	8b 40 04             	mov    0x4(%eax),%eax
  8029a5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ad:	8b 40 04             	mov    0x4(%eax),%eax
  8029b0:	85 c0                	test   %eax,%eax
  8029b2:	74 0f                	je     8029c3 <alloc_block_FF+0x141>
  8029b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b7:	8b 40 04             	mov    0x4(%eax),%eax
  8029ba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029bd:	8b 12                	mov    (%edx),%edx
  8029bf:	89 10                	mov    %edx,(%eax)
  8029c1:	eb 0a                	jmp    8029cd <alloc_block_FF+0x14b>
  8029c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c6:	8b 00                	mov    (%eax),%eax
  8029c8:	a3 48 51 80 00       	mov    %eax,0x805148
  8029cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029e0:	a1 54 51 80 00       	mov    0x805154,%eax
  8029e5:	48                   	dec    %eax
  8029e6:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8029eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ee:	8b 50 08             	mov    0x8(%eax),%edx
  8029f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f4:	01 c2                	add    %eax,%edx
  8029f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f9:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8029fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ff:	8b 40 0c             	mov    0xc(%eax),%eax
  802a02:	2b 45 08             	sub    0x8(%ebp),%eax
  802a05:	89 c2                	mov    %eax,%edx
  802a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0a:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802a0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a10:	eb 3b                	jmp    802a4d <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802a12:	a1 40 51 80 00       	mov    0x805140,%eax
  802a17:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a1a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a1e:	74 07                	je     802a27 <alloc_block_FF+0x1a5>
  802a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a23:	8b 00                	mov    (%eax),%eax
  802a25:	eb 05                	jmp    802a2c <alloc_block_FF+0x1aa>
  802a27:	b8 00 00 00 00       	mov    $0x0,%eax
  802a2c:	a3 40 51 80 00       	mov    %eax,0x805140
  802a31:	a1 40 51 80 00       	mov    0x805140,%eax
  802a36:	85 c0                	test   %eax,%eax
  802a38:	0f 85 57 fe ff ff    	jne    802895 <alloc_block_FF+0x13>
  802a3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a42:	0f 85 4d fe ff ff    	jne    802895 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802a48:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a4d:	c9                   	leave  
  802a4e:	c3                   	ret    

00802a4f <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802a4f:	55                   	push   %ebp
  802a50:	89 e5                	mov    %esp,%ebp
  802a52:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802a55:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802a5c:	a1 38 51 80 00       	mov    0x805138,%eax
  802a61:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a64:	e9 df 00 00 00       	jmp    802b48 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6c:	8b 40 0c             	mov    0xc(%eax),%eax
  802a6f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a72:	0f 82 c8 00 00 00    	jb     802b40 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7b:	8b 40 0c             	mov    0xc(%eax),%eax
  802a7e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a81:	0f 85 8a 00 00 00    	jne    802b11 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802a87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a8b:	75 17                	jne    802aa4 <alloc_block_BF+0x55>
  802a8d:	83 ec 04             	sub    $0x4,%esp
  802a90:	68 10 46 80 00       	push   $0x804610
  802a95:	68 b7 00 00 00       	push   $0xb7
  802a9a:	68 67 45 80 00       	push   $0x804567
  802a9f:	e8 4f de ff ff       	call   8008f3 <_panic>
  802aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa7:	8b 00                	mov    (%eax),%eax
  802aa9:	85 c0                	test   %eax,%eax
  802aab:	74 10                	je     802abd <alloc_block_BF+0x6e>
  802aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab0:	8b 00                	mov    (%eax),%eax
  802ab2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ab5:	8b 52 04             	mov    0x4(%edx),%edx
  802ab8:	89 50 04             	mov    %edx,0x4(%eax)
  802abb:	eb 0b                	jmp    802ac8 <alloc_block_BF+0x79>
  802abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac0:	8b 40 04             	mov    0x4(%eax),%eax
  802ac3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ac8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acb:	8b 40 04             	mov    0x4(%eax),%eax
  802ace:	85 c0                	test   %eax,%eax
  802ad0:	74 0f                	je     802ae1 <alloc_block_BF+0x92>
  802ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad5:	8b 40 04             	mov    0x4(%eax),%eax
  802ad8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802adb:	8b 12                	mov    (%edx),%edx
  802add:	89 10                	mov    %edx,(%eax)
  802adf:	eb 0a                	jmp    802aeb <alloc_block_BF+0x9c>
  802ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae4:	8b 00                	mov    (%eax),%eax
  802ae6:	a3 38 51 80 00       	mov    %eax,0x805138
  802aeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802afe:	a1 44 51 80 00       	mov    0x805144,%eax
  802b03:	48                   	dec    %eax
  802b04:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0c:	e9 4d 01 00 00       	jmp    802c5e <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802b11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b14:	8b 40 0c             	mov    0xc(%eax),%eax
  802b17:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b1a:	76 24                	jbe    802b40 <alloc_block_BF+0xf1>
  802b1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1f:	8b 40 0c             	mov    0xc(%eax),%eax
  802b22:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802b25:	73 19                	jae    802b40 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802b27:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b31:	8b 40 0c             	mov    0xc(%eax),%eax
  802b34:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802b37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3a:	8b 40 08             	mov    0x8(%eax),%eax
  802b3d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802b40:	a1 40 51 80 00       	mov    0x805140,%eax
  802b45:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b48:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b4c:	74 07                	je     802b55 <alloc_block_BF+0x106>
  802b4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b51:	8b 00                	mov    (%eax),%eax
  802b53:	eb 05                	jmp    802b5a <alloc_block_BF+0x10b>
  802b55:	b8 00 00 00 00       	mov    $0x0,%eax
  802b5a:	a3 40 51 80 00       	mov    %eax,0x805140
  802b5f:	a1 40 51 80 00       	mov    0x805140,%eax
  802b64:	85 c0                	test   %eax,%eax
  802b66:	0f 85 fd fe ff ff    	jne    802a69 <alloc_block_BF+0x1a>
  802b6c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b70:	0f 85 f3 fe ff ff    	jne    802a69 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802b76:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b7a:	0f 84 d9 00 00 00    	je     802c59 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b80:	a1 48 51 80 00       	mov    0x805148,%eax
  802b85:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802b88:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b8b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b8e:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802b91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b94:	8b 55 08             	mov    0x8(%ebp),%edx
  802b97:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802b9a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802b9e:	75 17                	jne    802bb7 <alloc_block_BF+0x168>
  802ba0:	83 ec 04             	sub    $0x4,%esp
  802ba3:	68 10 46 80 00       	push   $0x804610
  802ba8:	68 c7 00 00 00       	push   $0xc7
  802bad:	68 67 45 80 00       	push   $0x804567
  802bb2:	e8 3c dd ff ff       	call   8008f3 <_panic>
  802bb7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bba:	8b 00                	mov    (%eax),%eax
  802bbc:	85 c0                	test   %eax,%eax
  802bbe:	74 10                	je     802bd0 <alloc_block_BF+0x181>
  802bc0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bc3:	8b 00                	mov    (%eax),%eax
  802bc5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802bc8:	8b 52 04             	mov    0x4(%edx),%edx
  802bcb:	89 50 04             	mov    %edx,0x4(%eax)
  802bce:	eb 0b                	jmp    802bdb <alloc_block_BF+0x18c>
  802bd0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bd3:	8b 40 04             	mov    0x4(%eax),%eax
  802bd6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802bdb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bde:	8b 40 04             	mov    0x4(%eax),%eax
  802be1:	85 c0                	test   %eax,%eax
  802be3:	74 0f                	je     802bf4 <alloc_block_BF+0x1a5>
  802be5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802be8:	8b 40 04             	mov    0x4(%eax),%eax
  802beb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802bee:	8b 12                	mov    (%edx),%edx
  802bf0:	89 10                	mov    %edx,(%eax)
  802bf2:	eb 0a                	jmp    802bfe <alloc_block_BF+0x1af>
  802bf4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bf7:	8b 00                	mov    (%eax),%eax
  802bf9:	a3 48 51 80 00       	mov    %eax,0x805148
  802bfe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c01:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c0a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c11:	a1 54 51 80 00       	mov    0x805154,%eax
  802c16:	48                   	dec    %eax
  802c17:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802c1c:	83 ec 08             	sub    $0x8,%esp
  802c1f:	ff 75 ec             	pushl  -0x14(%ebp)
  802c22:	68 38 51 80 00       	push   $0x805138
  802c27:	e8 71 f9 ff ff       	call   80259d <find_block>
  802c2c:	83 c4 10             	add    $0x10,%esp
  802c2f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802c32:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c35:	8b 50 08             	mov    0x8(%eax),%edx
  802c38:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3b:	01 c2                	add    %eax,%edx
  802c3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c40:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802c43:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c46:	8b 40 0c             	mov    0xc(%eax),%eax
  802c49:	2b 45 08             	sub    0x8(%ebp),%eax
  802c4c:	89 c2                	mov    %eax,%edx
  802c4e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c51:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802c54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c57:	eb 05                	jmp    802c5e <alloc_block_BF+0x20f>
	}
	return NULL;
  802c59:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c5e:	c9                   	leave  
  802c5f:	c3                   	ret    

00802c60 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802c60:	55                   	push   %ebp
  802c61:	89 e5                	mov    %esp,%ebp
  802c63:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802c66:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802c6b:	85 c0                	test   %eax,%eax
  802c6d:	0f 85 de 01 00 00    	jne    802e51 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802c73:	a1 38 51 80 00       	mov    0x805138,%eax
  802c78:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c7b:	e9 9e 01 00 00       	jmp    802e1e <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802c80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c83:	8b 40 0c             	mov    0xc(%eax),%eax
  802c86:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c89:	0f 82 87 01 00 00    	jb     802e16 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802c8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c92:	8b 40 0c             	mov    0xc(%eax),%eax
  802c95:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c98:	0f 85 95 00 00 00    	jne    802d33 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802c9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ca2:	75 17                	jne    802cbb <alloc_block_NF+0x5b>
  802ca4:	83 ec 04             	sub    $0x4,%esp
  802ca7:	68 10 46 80 00       	push   $0x804610
  802cac:	68 e0 00 00 00       	push   $0xe0
  802cb1:	68 67 45 80 00       	push   $0x804567
  802cb6:	e8 38 dc ff ff       	call   8008f3 <_panic>
  802cbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbe:	8b 00                	mov    (%eax),%eax
  802cc0:	85 c0                	test   %eax,%eax
  802cc2:	74 10                	je     802cd4 <alloc_block_NF+0x74>
  802cc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc7:	8b 00                	mov    (%eax),%eax
  802cc9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ccc:	8b 52 04             	mov    0x4(%edx),%edx
  802ccf:	89 50 04             	mov    %edx,0x4(%eax)
  802cd2:	eb 0b                	jmp    802cdf <alloc_block_NF+0x7f>
  802cd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd7:	8b 40 04             	mov    0x4(%eax),%eax
  802cda:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce2:	8b 40 04             	mov    0x4(%eax),%eax
  802ce5:	85 c0                	test   %eax,%eax
  802ce7:	74 0f                	je     802cf8 <alloc_block_NF+0x98>
  802ce9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cec:	8b 40 04             	mov    0x4(%eax),%eax
  802cef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cf2:	8b 12                	mov    (%edx),%edx
  802cf4:	89 10                	mov    %edx,(%eax)
  802cf6:	eb 0a                	jmp    802d02 <alloc_block_NF+0xa2>
  802cf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfb:	8b 00                	mov    (%eax),%eax
  802cfd:	a3 38 51 80 00       	mov    %eax,0x805138
  802d02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d05:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d15:	a1 44 51 80 00       	mov    0x805144,%eax
  802d1a:	48                   	dec    %eax
  802d1b:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802d20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d23:	8b 40 08             	mov    0x8(%eax),%eax
  802d26:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   return  point;
  802d2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2e:	e9 f8 04 00 00       	jmp    80322b <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802d33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d36:	8b 40 0c             	mov    0xc(%eax),%eax
  802d39:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d3c:	0f 86 d4 00 00 00    	jbe    802e16 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d42:	a1 48 51 80 00       	mov    0x805148,%eax
  802d47:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802d4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4d:	8b 50 08             	mov    0x8(%eax),%edx
  802d50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d53:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802d56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d59:	8b 55 08             	mov    0x8(%ebp),%edx
  802d5c:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802d5f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d63:	75 17                	jne    802d7c <alloc_block_NF+0x11c>
  802d65:	83 ec 04             	sub    $0x4,%esp
  802d68:	68 10 46 80 00       	push   $0x804610
  802d6d:	68 e9 00 00 00       	push   $0xe9
  802d72:	68 67 45 80 00       	push   $0x804567
  802d77:	e8 77 db ff ff       	call   8008f3 <_panic>
  802d7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d7f:	8b 00                	mov    (%eax),%eax
  802d81:	85 c0                	test   %eax,%eax
  802d83:	74 10                	je     802d95 <alloc_block_NF+0x135>
  802d85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d88:	8b 00                	mov    (%eax),%eax
  802d8a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d8d:	8b 52 04             	mov    0x4(%edx),%edx
  802d90:	89 50 04             	mov    %edx,0x4(%eax)
  802d93:	eb 0b                	jmp    802da0 <alloc_block_NF+0x140>
  802d95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d98:	8b 40 04             	mov    0x4(%eax),%eax
  802d9b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802da0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da3:	8b 40 04             	mov    0x4(%eax),%eax
  802da6:	85 c0                	test   %eax,%eax
  802da8:	74 0f                	je     802db9 <alloc_block_NF+0x159>
  802daa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dad:	8b 40 04             	mov    0x4(%eax),%eax
  802db0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802db3:	8b 12                	mov    (%edx),%edx
  802db5:	89 10                	mov    %edx,(%eax)
  802db7:	eb 0a                	jmp    802dc3 <alloc_block_NF+0x163>
  802db9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dbc:	8b 00                	mov    (%eax),%eax
  802dbe:	a3 48 51 80 00       	mov    %eax,0x805148
  802dc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dcf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dd6:	a1 54 51 80 00       	mov    0x805154,%eax
  802ddb:	48                   	dec    %eax
  802ddc:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802de1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de4:	8b 40 08             	mov    0x8(%eax),%eax
  802de7:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   point->sva += size;
  802dec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802def:	8b 50 08             	mov    0x8(%eax),%edx
  802df2:	8b 45 08             	mov    0x8(%ebp),%eax
  802df5:	01 c2                	add    %eax,%edx
  802df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfa:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802dfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e00:	8b 40 0c             	mov    0xc(%eax),%eax
  802e03:	2b 45 08             	sub    0x8(%ebp),%eax
  802e06:	89 c2                	mov    %eax,%edx
  802e08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0b:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802e0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e11:	e9 15 04 00 00       	jmp    80322b <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802e16:	a1 40 51 80 00       	mov    0x805140,%eax
  802e1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e1e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e22:	74 07                	je     802e2b <alloc_block_NF+0x1cb>
  802e24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e27:	8b 00                	mov    (%eax),%eax
  802e29:	eb 05                	jmp    802e30 <alloc_block_NF+0x1d0>
  802e2b:	b8 00 00 00 00       	mov    $0x0,%eax
  802e30:	a3 40 51 80 00       	mov    %eax,0x805140
  802e35:	a1 40 51 80 00       	mov    0x805140,%eax
  802e3a:	85 c0                	test   %eax,%eax
  802e3c:	0f 85 3e fe ff ff    	jne    802c80 <alloc_block_NF+0x20>
  802e42:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e46:	0f 85 34 fe ff ff    	jne    802c80 <alloc_block_NF+0x20>
  802e4c:	e9 d5 03 00 00       	jmp    803226 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802e51:	a1 38 51 80 00       	mov    0x805138,%eax
  802e56:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e59:	e9 b1 01 00 00       	jmp    80300f <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802e5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e61:	8b 50 08             	mov    0x8(%eax),%edx
  802e64:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e69:	39 c2                	cmp    %eax,%edx
  802e6b:	0f 82 96 01 00 00    	jb     803007 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802e71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e74:	8b 40 0c             	mov    0xc(%eax),%eax
  802e77:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e7a:	0f 82 87 01 00 00    	jb     803007 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802e80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e83:	8b 40 0c             	mov    0xc(%eax),%eax
  802e86:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e89:	0f 85 95 00 00 00    	jne    802f24 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802e8f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e93:	75 17                	jne    802eac <alloc_block_NF+0x24c>
  802e95:	83 ec 04             	sub    $0x4,%esp
  802e98:	68 10 46 80 00       	push   $0x804610
  802e9d:	68 fc 00 00 00       	push   $0xfc
  802ea2:	68 67 45 80 00       	push   $0x804567
  802ea7:	e8 47 da ff ff       	call   8008f3 <_panic>
  802eac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eaf:	8b 00                	mov    (%eax),%eax
  802eb1:	85 c0                	test   %eax,%eax
  802eb3:	74 10                	je     802ec5 <alloc_block_NF+0x265>
  802eb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb8:	8b 00                	mov    (%eax),%eax
  802eba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ebd:	8b 52 04             	mov    0x4(%edx),%edx
  802ec0:	89 50 04             	mov    %edx,0x4(%eax)
  802ec3:	eb 0b                	jmp    802ed0 <alloc_block_NF+0x270>
  802ec5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec8:	8b 40 04             	mov    0x4(%eax),%eax
  802ecb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ed0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed3:	8b 40 04             	mov    0x4(%eax),%eax
  802ed6:	85 c0                	test   %eax,%eax
  802ed8:	74 0f                	je     802ee9 <alloc_block_NF+0x289>
  802eda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edd:	8b 40 04             	mov    0x4(%eax),%eax
  802ee0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ee3:	8b 12                	mov    (%edx),%edx
  802ee5:	89 10                	mov    %edx,(%eax)
  802ee7:	eb 0a                	jmp    802ef3 <alloc_block_NF+0x293>
  802ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eec:	8b 00                	mov    (%eax),%eax
  802eee:	a3 38 51 80 00       	mov    %eax,0x805138
  802ef3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802efc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f06:	a1 44 51 80 00       	mov    0x805144,%eax
  802f0b:	48                   	dec    %eax
  802f0c:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802f11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f14:	8b 40 08             	mov    0x8(%eax),%eax
  802f17:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  802f1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1f:	e9 07 03 00 00       	jmp    80322b <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802f24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f27:	8b 40 0c             	mov    0xc(%eax),%eax
  802f2a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f2d:	0f 86 d4 00 00 00    	jbe    803007 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802f33:	a1 48 51 80 00       	mov    0x805148,%eax
  802f38:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802f3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3e:	8b 50 08             	mov    0x8(%eax),%edx
  802f41:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f44:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802f47:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f4a:	8b 55 08             	mov    0x8(%ebp),%edx
  802f4d:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802f50:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f54:	75 17                	jne    802f6d <alloc_block_NF+0x30d>
  802f56:	83 ec 04             	sub    $0x4,%esp
  802f59:	68 10 46 80 00       	push   $0x804610
  802f5e:	68 04 01 00 00       	push   $0x104
  802f63:	68 67 45 80 00       	push   $0x804567
  802f68:	e8 86 d9 ff ff       	call   8008f3 <_panic>
  802f6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f70:	8b 00                	mov    (%eax),%eax
  802f72:	85 c0                	test   %eax,%eax
  802f74:	74 10                	je     802f86 <alloc_block_NF+0x326>
  802f76:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f79:	8b 00                	mov    (%eax),%eax
  802f7b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f7e:	8b 52 04             	mov    0x4(%edx),%edx
  802f81:	89 50 04             	mov    %edx,0x4(%eax)
  802f84:	eb 0b                	jmp    802f91 <alloc_block_NF+0x331>
  802f86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f89:	8b 40 04             	mov    0x4(%eax),%eax
  802f8c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f91:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f94:	8b 40 04             	mov    0x4(%eax),%eax
  802f97:	85 c0                	test   %eax,%eax
  802f99:	74 0f                	je     802faa <alloc_block_NF+0x34a>
  802f9b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f9e:	8b 40 04             	mov    0x4(%eax),%eax
  802fa1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fa4:	8b 12                	mov    (%edx),%edx
  802fa6:	89 10                	mov    %edx,(%eax)
  802fa8:	eb 0a                	jmp    802fb4 <alloc_block_NF+0x354>
  802faa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fad:	8b 00                	mov    (%eax),%eax
  802faf:	a3 48 51 80 00       	mov    %eax,0x805148
  802fb4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fbd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fc7:	a1 54 51 80 00       	mov    0x805154,%eax
  802fcc:	48                   	dec    %eax
  802fcd:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802fd2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fd5:	8b 40 08             	mov    0x8(%eax),%eax
  802fd8:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  802fdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe0:	8b 50 08             	mov    0x8(%eax),%edx
  802fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe6:	01 c2                	add    %eax,%edx
  802fe8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802feb:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802fee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ff4:	2b 45 08             	sub    0x8(%ebp),%eax
  802ff7:	89 c2                	mov    %eax,%edx
  802ff9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffc:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802fff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803002:	e9 24 02 00 00       	jmp    80322b <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803007:	a1 40 51 80 00       	mov    0x805140,%eax
  80300c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80300f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803013:	74 07                	je     80301c <alloc_block_NF+0x3bc>
  803015:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803018:	8b 00                	mov    (%eax),%eax
  80301a:	eb 05                	jmp    803021 <alloc_block_NF+0x3c1>
  80301c:	b8 00 00 00 00       	mov    $0x0,%eax
  803021:	a3 40 51 80 00       	mov    %eax,0x805140
  803026:	a1 40 51 80 00       	mov    0x805140,%eax
  80302b:	85 c0                	test   %eax,%eax
  80302d:	0f 85 2b fe ff ff    	jne    802e5e <alloc_block_NF+0x1fe>
  803033:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803037:	0f 85 21 fe ff ff    	jne    802e5e <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  80303d:	a1 38 51 80 00       	mov    0x805138,%eax
  803042:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803045:	e9 ae 01 00 00       	jmp    8031f8 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  80304a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304d:	8b 50 08             	mov    0x8(%eax),%edx
  803050:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803055:	39 c2                	cmp    %eax,%edx
  803057:	0f 83 93 01 00 00    	jae    8031f0 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  80305d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803060:	8b 40 0c             	mov    0xc(%eax),%eax
  803063:	3b 45 08             	cmp    0x8(%ebp),%eax
  803066:	0f 82 84 01 00 00    	jb     8031f0 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  80306c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306f:	8b 40 0c             	mov    0xc(%eax),%eax
  803072:	3b 45 08             	cmp    0x8(%ebp),%eax
  803075:	0f 85 95 00 00 00    	jne    803110 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80307b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80307f:	75 17                	jne    803098 <alloc_block_NF+0x438>
  803081:	83 ec 04             	sub    $0x4,%esp
  803084:	68 10 46 80 00       	push   $0x804610
  803089:	68 14 01 00 00       	push   $0x114
  80308e:	68 67 45 80 00       	push   $0x804567
  803093:	e8 5b d8 ff ff       	call   8008f3 <_panic>
  803098:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309b:	8b 00                	mov    (%eax),%eax
  80309d:	85 c0                	test   %eax,%eax
  80309f:	74 10                	je     8030b1 <alloc_block_NF+0x451>
  8030a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a4:	8b 00                	mov    (%eax),%eax
  8030a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030a9:	8b 52 04             	mov    0x4(%edx),%edx
  8030ac:	89 50 04             	mov    %edx,0x4(%eax)
  8030af:	eb 0b                	jmp    8030bc <alloc_block_NF+0x45c>
  8030b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b4:	8b 40 04             	mov    0x4(%eax),%eax
  8030b7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030bf:	8b 40 04             	mov    0x4(%eax),%eax
  8030c2:	85 c0                	test   %eax,%eax
  8030c4:	74 0f                	je     8030d5 <alloc_block_NF+0x475>
  8030c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c9:	8b 40 04             	mov    0x4(%eax),%eax
  8030cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030cf:	8b 12                	mov    (%edx),%edx
  8030d1:	89 10                	mov    %edx,(%eax)
  8030d3:	eb 0a                	jmp    8030df <alloc_block_NF+0x47f>
  8030d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d8:	8b 00                	mov    (%eax),%eax
  8030da:	a3 38 51 80 00       	mov    %eax,0x805138
  8030df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030eb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030f2:	a1 44 51 80 00       	mov    0x805144,%eax
  8030f7:	48                   	dec    %eax
  8030f8:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8030fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803100:	8b 40 08             	mov    0x8(%eax),%eax
  803103:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  803108:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310b:	e9 1b 01 00 00       	jmp    80322b <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803110:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803113:	8b 40 0c             	mov    0xc(%eax),%eax
  803116:	3b 45 08             	cmp    0x8(%ebp),%eax
  803119:	0f 86 d1 00 00 00    	jbe    8031f0 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80311f:	a1 48 51 80 00       	mov    0x805148,%eax
  803124:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  803127:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312a:	8b 50 08             	mov    0x8(%eax),%edx
  80312d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803130:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803133:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803136:	8b 55 08             	mov    0x8(%ebp),%edx
  803139:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80313c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803140:	75 17                	jne    803159 <alloc_block_NF+0x4f9>
  803142:	83 ec 04             	sub    $0x4,%esp
  803145:	68 10 46 80 00       	push   $0x804610
  80314a:	68 1c 01 00 00       	push   $0x11c
  80314f:	68 67 45 80 00       	push   $0x804567
  803154:	e8 9a d7 ff ff       	call   8008f3 <_panic>
  803159:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80315c:	8b 00                	mov    (%eax),%eax
  80315e:	85 c0                	test   %eax,%eax
  803160:	74 10                	je     803172 <alloc_block_NF+0x512>
  803162:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803165:	8b 00                	mov    (%eax),%eax
  803167:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80316a:	8b 52 04             	mov    0x4(%edx),%edx
  80316d:	89 50 04             	mov    %edx,0x4(%eax)
  803170:	eb 0b                	jmp    80317d <alloc_block_NF+0x51d>
  803172:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803175:	8b 40 04             	mov    0x4(%eax),%eax
  803178:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80317d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803180:	8b 40 04             	mov    0x4(%eax),%eax
  803183:	85 c0                	test   %eax,%eax
  803185:	74 0f                	je     803196 <alloc_block_NF+0x536>
  803187:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80318a:	8b 40 04             	mov    0x4(%eax),%eax
  80318d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803190:	8b 12                	mov    (%edx),%edx
  803192:	89 10                	mov    %edx,(%eax)
  803194:	eb 0a                	jmp    8031a0 <alloc_block_NF+0x540>
  803196:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803199:	8b 00                	mov    (%eax),%eax
  80319b:	a3 48 51 80 00       	mov    %eax,0x805148
  8031a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031ac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031b3:	a1 54 51 80 00       	mov    0x805154,%eax
  8031b8:	48                   	dec    %eax
  8031b9:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8031be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031c1:	8b 40 08             	mov    0x8(%eax),%eax
  8031c4:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  8031c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031cc:	8b 50 08             	mov    0x8(%eax),%edx
  8031cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d2:	01 c2                	add    %eax,%edx
  8031d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d7:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8031da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8031e0:	2b 45 08             	sub    0x8(%ebp),%eax
  8031e3:	89 c2                	mov    %eax,%edx
  8031e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e8:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8031eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031ee:	eb 3b                	jmp    80322b <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8031f0:	a1 40 51 80 00       	mov    0x805140,%eax
  8031f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031fc:	74 07                	je     803205 <alloc_block_NF+0x5a5>
  8031fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803201:	8b 00                	mov    (%eax),%eax
  803203:	eb 05                	jmp    80320a <alloc_block_NF+0x5aa>
  803205:	b8 00 00 00 00       	mov    $0x0,%eax
  80320a:	a3 40 51 80 00       	mov    %eax,0x805140
  80320f:	a1 40 51 80 00       	mov    0x805140,%eax
  803214:	85 c0                	test   %eax,%eax
  803216:	0f 85 2e fe ff ff    	jne    80304a <alloc_block_NF+0x3ea>
  80321c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803220:	0f 85 24 fe ff ff    	jne    80304a <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  803226:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80322b:	c9                   	leave  
  80322c:	c3                   	ret    

0080322d <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80322d:	55                   	push   %ebp
  80322e:	89 e5                	mov    %esp,%ebp
  803230:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  803233:	a1 38 51 80 00       	mov    0x805138,%eax
  803238:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  80323b:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803240:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  803243:	a1 38 51 80 00       	mov    0x805138,%eax
  803248:	85 c0                	test   %eax,%eax
  80324a:	74 14                	je     803260 <insert_sorted_with_merge_freeList+0x33>
  80324c:	8b 45 08             	mov    0x8(%ebp),%eax
  80324f:	8b 50 08             	mov    0x8(%eax),%edx
  803252:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803255:	8b 40 08             	mov    0x8(%eax),%eax
  803258:	39 c2                	cmp    %eax,%edx
  80325a:	0f 87 9b 01 00 00    	ja     8033fb <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  803260:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803264:	75 17                	jne    80327d <insert_sorted_with_merge_freeList+0x50>
  803266:	83 ec 04             	sub    $0x4,%esp
  803269:	68 44 45 80 00       	push   $0x804544
  80326e:	68 38 01 00 00       	push   $0x138
  803273:	68 67 45 80 00       	push   $0x804567
  803278:	e8 76 d6 ff ff       	call   8008f3 <_panic>
  80327d:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803283:	8b 45 08             	mov    0x8(%ebp),%eax
  803286:	89 10                	mov    %edx,(%eax)
  803288:	8b 45 08             	mov    0x8(%ebp),%eax
  80328b:	8b 00                	mov    (%eax),%eax
  80328d:	85 c0                	test   %eax,%eax
  80328f:	74 0d                	je     80329e <insert_sorted_with_merge_freeList+0x71>
  803291:	a1 38 51 80 00       	mov    0x805138,%eax
  803296:	8b 55 08             	mov    0x8(%ebp),%edx
  803299:	89 50 04             	mov    %edx,0x4(%eax)
  80329c:	eb 08                	jmp    8032a6 <insert_sorted_with_merge_freeList+0x79>
  80329e:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a9:	a3 38 51 80 00       	mov    %eax,0x805138
  8032ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032b8:	a1 44 51 80 00       	mov    0x805144,%eax
  8032bd:	40                   	inc    %eax
  8032be:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8032c3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8032c7:	0f 84 a8 06 00 00    	je     803975 <insert_sorted_with_merge_freeList+0x748>
  8032cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d0:	8b 50 08             	mov    0x8(%eax),%edx
  8032d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8032d9:	01 c2                	add    %eax,%edx
  8032db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032de:	8b 40 08             	mov    0x8(%eax),%eax
  8032e1:	39 c2                	cmp    %eax,%edx
  8032e3:	0f 85 8c 06 00 00    	jne    803975 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  8032e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ec:	8b 50 0c             	mov    0xc(%eax),%edx
  8032ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8032f5:	01 c2                	add    %eax,%edx
  8032f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fa:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  8032fd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803301:	75 17                	jne    80331a <insert_sorted_with_merge_freeList+0xed>
  803303:	83 ec 04             	sub    $0x4,%esp
  803306:	68 10 46 80 00       	push   $0x804610
  80330b:	68 3c 01 00 00       	push   $0x13c
  803310:	68 67 45 80 00       	push   $0x804567
  803315:	e8 d9 d5 ff ff       	call   8008f3 <_panic>
  80331a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80331d:	8b 00                	mov    (%eax),%eax
  80331f:	85 c0                	test   %eax,%eax
  803321:	74 10                	je     803333 <insert_sorted_with_merge_freeList+0x106>
  803323:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803326:	8b 00                	mov    (%eax),%eax
  803328:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80332b:	8b 52 04             	mov    0x4(%edx),%edx
  80332e:	89 50 04             	mov    %edx,0x4(%eax)
  803331:	eb 0b                	jmp    80333e <insert_sorted_with_merge_freeList+0x111>
  803333:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803336:	8b 40 04             	mov    0x4(%eax),%eax
  803339:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80333e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803341:	8b 40 04             	mov    0x4(%eax),%eax
  803344:	85 c0                	test   %eax,%eax
  803346:	74 0f                	je     803357 <insert_sorted_with_merge_freeList+0x12a>
  803348:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80334b:	8b 40 04             	mov    0x4(%eax),%eax
  80334e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803351:	8b 12                	mov    (%edx),%edx
  803353:	89 10                	mov    %edx,(%eax)
  803355:	eb 0a                	jmp    803361 <insert_sorted_with_merge_freeList+0x134>
  803357:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80335a:	8b 00                	mov    (%eax),%eax
  80335c:	a3 38 51 80 00       	mov    %eax,0x805138
  803361:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803364:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80336a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80336d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803374:	a1 44 51 80 00       	mov    0x805144,%eax
  803379:	48                   	dec    %eax
  80337a:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  80337f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803382:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803389:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80338c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803393:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803397:	75 17                	jne    8033b0 <insert_sorted_with_merge_freeList+0x183>
  803399:	83 ec 04             	sub    $0x4,%esp
  80339c:	68 44 45 80 00       	push   $0x804544
  8033a1:	68 3f 01 00 00       	push   $0x13f
  8033a6:	68 67 45 80 00       	push   $0x804567
  8033ab:	e8 43 d5 ff ff       	call   8008f3 <_panic>
  8033b0:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033b9:	89 10                	mov    %edx,(%eax)
  8033bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033be:	8b 00                	mov    (%eax),%eax
  8033c0:	85 c0                	test   %eax,%eax
  8033c2:	74 0d                	je     8033d1 <insert_sorted_with_merge_freeList+0x1a4>
  8033c4:	a1 48 51 80 00       	mov    0x805148,%eax
  8033c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033cc:	89 50 04             	mov    %edx,0x4(%eax)
  8033cf:	eb 08                	jmp    8033d9 <insert_sorted_with_merge_freeList+0x1ac>
  8033d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033d4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033dc:	a3 48 51 80 00       	mov    %eax,0x805148
  8033e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033e4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033eb:	a1 54 51 80 00       	mov    0x805154,%eax
  8033f0:	40                   	inc    %eax
  8033f1:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8033f6:	e9 7a 05 00 00       	jmp    803975 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  8033fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fe:	8b 50 08             	mov    0x8(%eax),%edx
  803401:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803404:	8b 40 08             	mov    0x8(%eax),%eax
  803407:	39 c2                	cmp    %eax,%edx
  803409:	0f 82 14 01 00 00    	jb     803523 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  80340f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803412:	8b 50 08             	mov    0x8(%eax),%edx
  803415:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803418:	8b 40 0c             	mov    0xc(%eax),%eax
  80341b:	01 c2                	add    %eax,%edx
  80341d:	8b 45 08             	mov    0x8(%ebp),%eax
  803420:	8b 40 08             	mov    0x8(%eax),%eax
  803423:	39 c2                	cmp    %eax,%edx
  803425:	0f 85 90 00 00 00    	jne    8034bb <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  80342b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80342e:	8b 50 0c             	mov    0xc(%eax),%edx
  803431:	8b 45 08             	mov    0x8(%ebp),%eax
  803434:	8b 40 0c             	mov    0xc(%eax),%eax
  803437:	01 c2                	add    %eax,%edx
  803439:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80343c:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  80343f:	8b 45 08             	mov    0x8(%ebp),%eax
  803442:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803449:	8b 45 08             	mov    0x8(%ebp),%eax
  80344c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803453:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803457:	75 17                	jne    803470 <insert_sorted_with_merge_freeList+0x243>
  803459:	83 ec 04             	sub    $0x4,%esp
  80345c:	68 44 45 80 00       	push   $0x804544
  803461:	68 49 01 00 00       	push   $0x149
  803466:	68 67 45 80 00       	push   $0x804567
  80346b:	e8 83 d4 ff ff       	call   8008f3 <_panic>
  803470:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803476:	8b 45 08             	mov    0x8(%ebp),%eax
  803479:	89 10                	mov    %edx,(%eax)
  80347b:	8b 45 08             	mov    0x8(%ebp),%eax
  80347e:	8b 00                	mov    (%eax),%eax
  803480:	85 c0                	test   %eax,%eax
  803482:	74 0d                	je     803491 <insert_sorted_with_merge_freeList+0x264>
  803484:	a1 48 51 80 00       	mov    0x805148,%eax
  803489:	8b 55 08             	mov    0x8(%ebp),%edx
  80348c:	89 50 04             	mov    %edx,0x4(%eax)
  80348f:	eb 08                	jmp    803499 <insert_sorted_with_merge_freeList+0x26c>
  803491:	8b 45 08             	mov    0x8(%ebp),%eax
  803494:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803499:	8b 45 08             	mov    0x8(%ebp),%eax
  80349c:	a3 48 51 80 00       	mov    %eax,0x805148
  8034a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034ab:	a1 54 51 80 00       	mov    0x805154,%eax
  8034b0:	40                   	inc    %eax
  8034b1:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8034b6:	e9 bb 04 00 00       	jmp    803976 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8034bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034bf:	75 17                	jne    8034d8 <insert_sorted_with_merge_freeList+0x2ab>
  8034c1:	83 ec 04             	sub    $0x4,%esp
  8034c4:	68 b8 45 80 00       	push   $0x8045b8
  8034c9:	68 4c 01 00 00       	push   $0x14c
  8034ce:	68 67 45 80 00       	push   $0x804567
  8034d3:	e8 1b d4 ff ff       	call   8008f3 <_panic>
  8034d8:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8034de:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e1:	89 50 04             	mov    %edx,0x4(%eax)
  8034e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e7:	8b 40 04             	mov    0x4(%eax),%eax
  8034ea:	85 c0                	test   %eax,%eax
  8034ec:	74 0c                	je     8034fa <insert_sorted_with_merge_freeList+0x2cd>
  8034ee:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8034f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8034f6:	89 10                	mov    %edx,(%eax)
  8034f8:	eb 08                	jmp    803502 <insert_sorted_with_merge_freeList+0x2d5>
  8034fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fd:	a3 38 51 80 00       	mov    %eax,0x805138
  803502:	8b 45 08             	mov    0x8(%ebp),%eax
  803505:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80350a:	8b 45 08             	mov    0x8(%ebp),%eax
  80350d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803513:	a1 44 51 80 00       	mov    0x805144,%eax
  803518:	40                   	inc    %eax
  803519:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80351e:	e9 53 04 00 00       	jmp    803976 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803523:	a1 38 51 80 00       	mov    0x805138,%eax
  803528:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80352b:	e9 15 04 00 00       	jmp    803945 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803530:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803533:	8b 00                	mov    (%eax),%eax
  803535:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803538:	8b 45 08             	mov    0x8(%ebp),%eax
  80353b:	8b 50 08             	mov    0x8(%eax),%edx
  80353e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803541:	8b 40 08             	mov    0x8(%eax),%eax
  803544:	39 c2                	cmp    %eax,%edx
  803546:	0f 86 f1 03 00 00    	jbe    80393d <insert_sorted_with_merge_freeList+0x710>
  80354c:	8b 45 08             	mov    0x8(%ebp),%eax
  80354f:	8b 50 08             	mov    0x8(%eax),%edx
  803552:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803555:	8b 40 08             	mov    0x8(%eax),%eax
  803558:	39 c2                	cmp    %eax,%edx
  80355a:	0f 83 dd 03 00 00    	jae    80393d <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803560:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803563:	8b 50 08             	mov    0x8(%eax),%edx
  803566:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803569:	8b 40 0c             	mov    0xc(%eax),%eax
  80356c:	01 c2                	add    %eax,%edx
  80356e:	8b 45 08             	mov    0x8(%ebp),%eax
  803571:	8b 40 08             	mov    0x8(%eax),%eax
  803574:	39 c2                	cmp    %eax,%edx
  803576:	0f 85 b9 01 00 00    	jne    803735 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80357c:	8b 45 08             	mov    0x8(%ebp),%eax
  80357f:	8b 50 08             	mov    0x8(%eax),%edx
  803582:	8b 45 08             	mov    0x8(%ebp),%eax
  803585:	8b 40 0c             	mov    0xc(%eax),%eax
  803588:	01 c2                	add    %eax,%edx
  80358a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80358d:	8b 40 08             	mov    0x8(%eax),%eax
  803590:	39 c2                	cmp    %eax,%edx
  803592:	0f 85 0d 01 00 00    	jne    8036a5 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803598:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80359b:	8b 50 0c             	mov    0xc(%eax),%edx
  80359e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035a1:	8b 40 0c             	mov    0xc(%eax),%eax
  8035a4:	01 c2                	add    %eax,%edx
  8035a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a9:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8035ac:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8035b0:	75 17                	jne    8035c9 <insert_sorted_with_merge_freeList+0x39c>
  8035b2:	83 ec 04             	sub    $0x4,%esp
  8035b5:	68 10 46 80 00       	push   $0x804610
  8035ba:	68 5c 01 00 00       	push   $0x15c
  8035bf:	68 67 45 80 00       	push   $0x804567
  8035c4:	e8 2a d3 ff ff       	call   8008f3 <_panic>
  8035c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035cc:	8b 00                	mov    (%eax),%eax
  8035ce:	85 c0                	test   %eax,%eax
  8035d0:	74 10                	je     8035e2 <insert_sorted_with_merge_freeList+0x3b5>
  8035d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035d5:	8b 00                	mov    (%eax),%eax
  8035d7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8035da:	8b 52 04             	mov    0x4(%edx),%edx
  8035dd:	89 50 04             	mov    %edx,0x4(%eax)
  8035e0:	eb 0b                	jmp    8035ed <insert_sorted_with_merge_freeList+0x3c0>
  8035e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035e5:	8b 40 04             	mov    0x4(%eax),%eax
  8035e8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8035ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035f0:	8b 40 04             	mov    0x4(%eax),%eax
  8035f3:	85 c0                	test   %eax,%eax
  8035f5:	74 0f                	je     803606 <insert_sorted_with_merge_freeList+0x3d9>
  8035f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035fa:	8b 40 04             	mov    0x4(%eax),%eax
  8035fd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803600:	8b 12                	mov    (%edx),%edx
  803602:	89 10                	mov    %edx,(%eax)
  803604:	eb 0a                	jmp    803610 <insert_sorted_with_merge_freeList+0x3e3>
  803606:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803609:	8b 00                	mov    (%eax),%eax
  80360b:	a3 38 51 80 00       	mov    %eax,0x805138
  803610:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803613:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803619:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80361c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803623:	a1 44 51 80 00       	mov    0x805144,%eax
  803628:	48                   	dec    %eax
  803629:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  80362e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803631:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803638:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80363b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803642:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803646:	75 17                	jne    80365f <insert_sorted_with_merge_freeList+0x432>
  803648:	83 ec 04             	sub    $0x4,%esp
  80364b:	68 44 45 80 00       	push   $0x804544
  803650:	68 5f 01 00 00       	push   $0x15f
  803655:	68 67 45 80 00       	push   $0x804567
  80365a:	e8 94 d2 ff ff       	call   8008f3 <_panic>
  80365f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803665:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803668:	89 10                	mov    %edx,(%eax)
  80366a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80366d:	8b 00                	mov    (%eax),%eax
  80366f:	85 c0                	test   %eax,%eax
  803671:	74 0d                	je     803680 <insert_sorted_with_merge_freeList+0x453>
  803673:	a1 48 51 80 00       	mov    0x805148,%eax
  803678:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80367b:	89 50 04             	mov    %edx,0x4(%eax)
  80367e:	eb 08                	jmp    803688 <insert_sorted_with_merge_freeList+0x45b>
  803680:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803683:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803688:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80368b:	a3 48 51 80 00       	mov    %eax,0x805148
  803690:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803693:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80369a:	a1 54 51 80 00       	mov    0x805154,%eax
  80369f:	40                   	inc    %eax
  8036a0:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8036a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a8:	8b 50 0c             	mov    0xc(%eax),%edx
  8036ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8036b1:	01 c2                	add    %eax,%edx
  8036b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b6:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8036b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8036bc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8036c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8036cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036d1:	75 17                	jne    8036ea <insert_sorted_with_merge_freeList+0x4bd>
  8036d3:	83 ec 04             	sub    $0x4,%esp
  8036d6:	68 44 45 80 00       	push   $0x804544
  8036db:	68 64 01 00 00       	push   $0x164
  8036e0:	68 67 45 80 00       	push   $0x804567
  8036e5:	e8 09 d2 ff ff       	call   8008f3 <_panic>
  8036ea:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8036f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f3:	89 10                	mov    %edx,(%eax)
  8036f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f8:	8b 00                	mov    (%eax),%eax
  8036fa:	85 c0                	test   %eax,%eax
  8036fc:	74 0d                	je     80370b <insert_sorted_with_merge_freeList+0x4de>
  8036fe:	a1 48 51 80 00       	mov    0x805148,%eax
  803703:	8b 55 08             	mov    0x8(%ebp),%edx
  803706:	89 50 04             	mov    %edx,0x4(%eax)
  803709:	eb 08                	jmp    803713 <insert_sorted_with_merge_freeList+0x4e6>
  80370b:	8b 45 08             	mov    0x8(%ebp),%eax
  80370e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803713:	8b 45 08             	mov    0x8(%ebp),%eax
  803716:	a3 48 51 80 00       	mov    %eax,0x805148
  80371b:	8b 45 08             	mov    0x8(%ebp),%eax
  80371e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803725:	a1 54 51 80 00       	mov    0x805154,%eax
  80372a:	40                   	inc    %eax
  80372b:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803730:	e9 41 02 00 00       	jmp    803976 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803735:	8b 45 08             	mov    0x8(%ebp),%eax
  803738:	8b 50 08             	mov    0x8(%eax),%edx
  80373b:	8b 45 08             	mov    0x8(%ebp),%eax
  80373e:	8b 40 0c             	mov    0xc(%eax),%eax
  803741:	01 c2                	add    %eax,%edx
  803743:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803746:	8b 40 08             	mov    0x8(%eax),%eax
  803749:	39 c2                	cmp    %eax,%edx
  80374b:	0f 85 7c 01 00 00    	jne    8038cd <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803751:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803755:	74 06                	je     80375d <insert_sorted_with_merge_freeList+0x530>
  803757:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80375b:	75 17                	jne    803774 <insert_sorted_with_merge_freeList+0x547>
  80375d:	83 ec 04             	sub    $0x4,%esp
  803760:	68 80 45 80 00       	push   $0x804580
  803765:	68 69 01 00 00       	push   $0x169
  80376a:	68 67 45 80 00       	push   $0x804567
  80376f:	e8 7f d1 ff ff       	call   8008f3 <_panic>
  803774:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803777:	8b 50 04             	mov    0x4(%eax),%edx
  80377a:	8b 45 08             	mov    0x8(%ebp),%eax
  80377d:	89 50 04             	mov    %edx,0x4(%eax)
  803780:	8b 45 08             	mov    0x8(%ebp),%eax
  803783:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803786:	89 10                	mov    %edx,(%eax)
  803788:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80378b:	8b 40 04             	mov    0x4(%eax),%eax
  80378e:	85 c0                	test   %eax,%eax
  803790:	74 0d                	je     80379f <insert_sorted_with_merge_freeList+0x572>
  803792:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803795:	8b 40 04             	mov    0x4(%eax),%eax
  803798:	8b 55 08             	mov    0x8(%ebp),%edx
  80379b:	89 10                	mov    %edx,(%eax)
  80379d:	eb 08                	jmp    8037a7 <insert_sorted_with_merge_freeList+0x57a>
  80379f:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a2:	a3 38 51 80 00       	mov    %eax,0x805138
  8037a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8037ad:	89 50 04             	mov    %edx,0x4(%eax)
  8037b0:	a1 44 51 80 00       	mov    0x805144,%eax
  8037b5:	40                   	inc    %eax
  8037b6:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8037bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8037be:	8b 50 0c             	mov    0xc(%eax),%edx
  8037c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8037c7:	01 c2                	add    %eax,%edx
  8037c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8037cc:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8037cf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8037d3:	75 17                	jne    8037ec <insert_sorted_with_merge_freeList+0x5bf>
  8037d5:	83 ec 04             	sub    $0x4,%esp
  8037d8:	68 10 46 80 00       	push   $0x804610
  8037dd:	68 6b 01 00 00       	push   $0x16b
  8037e2:	68 67 45 80 00       	push   $0x804567
  8037e7:	e8 07 d1 ff ff       	call   8008f3 <_panic>
  8037ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037ef:	8b 00                	mov    (%eax),%eax
  8037f1:	85 c0                	test   %eax,%eax
  8037f3:	74 10                	je     803805 <insert_sorted_with_merge_freeList+0x5d8>
  8037f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037f8:	8b 00                	mov    (%eax),%eax
  8037fa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037fd:	8b 52 04             	mov    0x4(%edx),%edx
  803800:	89 50 04             	mov    %edx,0x4(%eax)
  803803:	eb 0b                	jmp    803810 <insert_sorted_with_merge_freeList+0x5e3>
  803805:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803808:	8b 40 04             	mov    0x4(%eax),%eax
  80380b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803810:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803813:	8b 40 04             	mov    0x4(%eax),%eax
  803816:	85 c0                	test   %eax,%eax
  803818:	74 0f                	je     803829 <insert_sorted_with_merge_freeList+0x5fc>
  80381a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80381d:	8b 40 04             	mov    0x4(%eax),%eax
  803820:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803823:	8b 12                	mov    (%edx),%edx
  803825:	89 10                	mov    %edx,(%eax)
  803827:	eb 0a                	jmp    803833 <insert_sorted_with_merge_freeList+0x606>
  803829:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80382c:	8b 00                	mov    (%eax),%eax
  80382e:	a3 38 51 80 00       	mov    %eax,0x805138
  803833:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803836:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80383c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80383f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803846:	a1 44 51 80 00       	mov    0x805144,%eax
  80384b:	48                   	dec    %eax
  80384c:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803851:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803854:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80385b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80385e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803865:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803869:	75 17                	jne    803882 <insert_sorted_with_merge_freeList+0x655>
  80386b:	83 ec 04             	sub    $0x4,%esp
  80386e:	68 44 45 80 00       	push   $0x804544
  803873:	68 6e 01 00 00       	push   $0x16e
  803878:	68 67 45 80 00       	push   $0x804567
  80387d:	e8 71 d0 ff ff       	call   8008f3 <_panic>
  803882:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803888:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80388b:	89 10                	mov    %edx,(%eax)
  80388d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803890:	8b 00                	mov    (%eax),%eax
  803892:	85 c0                	test   %eax,%eax
  803894:	74 0d                	je     8038a3 <insert_sorted_with_merge_freeList+0x676>
  803896:	a1 48 51 80 00       	mov    0x805148,%eax
  80389b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80389e:	89 50 04             	mov    %edx,0x4(%eax)
  8038a1:	eb 08                	jmp    8038ab <insert_sorted_with_merge_freeList+0x67e>
  8038a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038a6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8038ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038ae:	a3 48 51 80 00       	mov    %eax,0x805148
  8038b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038b6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038bd:	a1 54 51 80 00       	mov    0x805154,%eax
  8038c2:	40                   	inc    %eax
  8038c3:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8038c8:	e9 a9 00 00 00       	jmp    803976 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8038cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038d1:	74 06                	je     8038d9 <insert_sorted_with_merge_freeList+0x6ac>
  8038d3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038d7:	75 17                	jne    8038f0 <insert_sorted_with_merge_freeList+0x6c3>
  8038d9:	83 ec 04             	sub    $0x4,%esp
  8038dc:	68 dc 45 80 00       	push   $0x8045dc
  8038e1:	68 73 01 00 00       	push   $0x173
  8038e6:	68 67 45 80 00       	push   $0x804567
  8038eb:	e8 03 d0 ff ff       	call   8008f3 <_panic>
  8038f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038f3:	8b 10                	mov    (%eax),%edx
  8038f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f8:	89 10                	mov    %edx,(%eax)
  8038fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8038fd:	8b 00                	mov    (%eax),%eax
  8038ff:	85 c0                	test   %eax,%eax
  803901:	74 0b                	je     80390e <insert_sorted_with_merge_freeList+0x6e1>
  803903:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803906:	8b 00                	mov    (%eax),%eax
  803908:	8b 55 08             	mov    0x8(%ebp),%edx
  80390b:	89 50 04             	mov    %edx,0x4(%eax)
  80390e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803911:	8b 55 08             	mov    0x8(%ebp),%edx
  803914:	89 10                	mov    %edx,(%eax)
  803916:	8b 45 08             	mov    0x8(%ebp),%eax
  803919:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80391c:	89 50 04             	mov    %edx,0x4(%eax)
  80391f:	8b 45 08             	mov    0x8(%ebp),%eax
  803922:	8b 00                	mov    (%eax),%eax
  803924:	85 c0                	test   %eax,%eax
  803926:	75 08                	jne    803930 <insert_sorted_with_merge_freeList+0x703>
  803928:	8b 45 08             	mov    0x8(%ebp),%eax
  80392b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803930:	a1 44 51 80 00       	mov    0x805144,%eax
  803935:	40                   	inc    %eax
  803936:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  80393b:	eb 39                	jmp    803976 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80393d:	a1 40 51 80 00       	mov    0x805140,%eax
  803942:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803945:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803949:	74 07                	je     803952 <insert_sorted_with_merge_freeList+0x725>
  80394b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80394e:	8b 00                	mov    (%eax),%eax
  803950:	eb 05                	jmp    803957 <insert_sorted_with_merge_freeList+0x72a>
  803952:	b8 00 00 00 00       	mov    $0x0,%eax
  803957:	a3 40 51 80 00       	mov    %eax,0x805140
  80395c:	a1 40 51 80 00       	mov    0x805140,%eax
  803961:	85 c0                	test   %eax,%eax
  803963:	0f 85 c7 fb ff ff    	jne    803530 <insert_sorted_with_merge_freeList+0x303>
  803969:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80396d:	0f 85 bd fb ff ff    	jne    803530 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803973:	eb 01                	jmp    803976 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803975:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803976:	90                   	nop
  803977:	c9                   	leave  
  803978:	c3                   	ret    
  803979:	66 90                	xchg   %ax,%ax
  80397b:	90                   	nop

0080397c <__udivdi3>:
  80397c:	55                   	push   %ebp
  80397d:	57                   	push   %edi
  80397e:	56                   	push   %esi
  80397f:	53                   	push   %ebx
  803980:	83 ec 1c             	sub    $0x1c,%esp
  803983:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803987:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80398b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80398f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803993:	89 ca                	mov    %ecx,%edx
  803995:	89 f8                	mov    %edi,%eax
  803997:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80399b:	85 f6                	test   %esi,%esi
  80399d:	75 2d                	jne    8039cc <__udivdi3+0x50>
  80399f:	39 cf                	cmp    %ecx,%edi
  8039a1:	77 65                	ja     803a08 <__udivdi3+0x8c>
  8039a3:	89 fd                	mov    %edi,%ebp
  8039a5:	85 ff                	test   %edi,%edi
  8039a7:	75 0b                	jne    8039b4 <__udivdi3+0x38>
  8039a9:	b8 01 00 00 00       	mov    $0x1,%eax
  8039ae:	31 d2                	xor    %edx,%edx
  8039b0:	f7 f7                	div    %edi
  8039b2:	89 c5                	mov    %eax,%ebp
  8039b4:	31 d2                	xor    %edx,%edx
  8039b6:	89 c8                	mov    %ecx,%eax
  8039b8:	f7 f5                	div    %ebp
  8039ba:	89 c1                	mov    %eax,%ecx
  8039bc:	89 d8                	mov    %ebx,%eax
  8039be:	f7 f5                	div    %ebp
  8039c0:	89 cf                	mov    %ecx,%edi
  8039c2:	89 fa                	mov    %edi,%edx
  8039c4:	83 c4 1c             	add    $0x1c,%esp
  8039c7:	5b                   	pop    %ebx
  8039c8:	5e                   	pop    %esi
  8039c9:	5f                   	pop    %edi
  8039ca:	5d                   	pop    %ebp
  8039cb:	c3                   	ret    
  8039cc:	39 ce                	cmp    %ecx,%esi
  8039ce:	77 28                	ja     8039f8 <__udivdi3+0x7c>
  8039d0:	0f bd fe             	bsr    %esi,%edi
  8039d3:	83 f7 1f             	xor    $0x1f,%edi
  8039d6:	75 40                	jne    803a18 <__udivdi3+0x9c>
  8039d8:	39 ce                	cmp    %ecx,%esi
  8039da:	72 0a                	jb     8039e6 <__udivdi3+0x6a>
  8039dc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8039e0:	0f 87 9e 00 00 00    	ja     803a84 <__udivdi3+0x108>
  8039e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8039eb:	89 fa                	mov    %edi,%edx
  8039ed:	83 c4 1c             	add    $0x1c,%esp
  8039f0:	5b                   	pop    %ebx
  8039f1:	5e                   	pop    %esi
  8039f2:	5f                   	pop    %edi
  8039f3:	5d                   	pop    %ebp
  8039f4:	c3                   	ret    
  8039f5:	8d 76 00             	lea    0x0(%esi),%esi
  8039f8:	31 ff                	xor    %edi,%edi
  8039fa:	31 c0                	xor    %eax,%eax
  8039fc:	89 fa                	mov    %edi,%edx
  8039fe:	83 c4 1c             	add    $0x1c,%esp
  803a01:	5b                   	pop    %ebx
  803a02:	5e                   	pop    %esi
  803a03:	5f                   	pop    %edi
  803a04:	5d                   	pop    %ebp
  803a05:	c3                   	ret    
  803a06:	66 90                	xchg   %ax,%ax
  803a08:	89 d8                	mov    %ebx,%eax
  803a0a:	f7 f7                	div    %edi
  803a0c:	31 ff                	xor    %edi,%edi
  803a0e:	89 fa                	mov    %edi,%edx
  803a10:	83 c4 1c             	add    $0x1c,%esp
  803a13:	5b                   	pop    %ebx
  803a14:	5e                   	pop    %esi
  803a15:	5f                   	pop    %edi
  803a16:	5d                   	pop    %ebp
  803a17:	c3                   	ret    
  803a18:	bd 20 00 00 00       	mov    $0x20,%ebp
  803a1d:	89 eb                	mov    %ebp,%ebx
  803a1f:	29 fb                	sub    %edi,%ebx
  803a21:	89 f9                	mov    %edi,%ecx
  803a23:	d3 e6                	shl    %cl,%esi
  803a25:	89 c5                	mov    %eax,%ebp
  803a27:	88 d9                	mov    %bl,%cl
  803a29:	d3 ed                	shr    %cl,%ebp
  803a2b:	89 e9                	mov    %ebp,%ecx
  803a2d:	09 f1                	or     %esi,%ecx
  803a2f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803a33:	89 f9                	mov    %edi,%ecx
  803a35:	d3 e0                	shl    %cl,%eax
  803a37:	89 c5                	mov    %eax,%ebp
  803a39:	89 d6                	mov    %edx,%esi
  803a3b:	88 d9                	mov    %bl,%cl
  803a3d:	d3 ee                	shr    %cl,%esi
  803a3f:	89 f9                	mov    %edi,%ecx
  803a41:	d3 e2                	shl    %cl,%edx
  803a43:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a47:	88 d9                	mov    %bl,%cl
  803a49:	d3 e8                	shr    %cl,%eax
  803a4b:	09 c2                	or     %eax,%edx
  803a4d:	89 d0                	mov    %edx,%eax
  803a4f:	89 f2                	mov    %esi,%edx
  803a51:	f7 74 24 0c          	divl   0xc(%esp)
  803a55:	89 d6                	mov    %edx,%esi
  803a57:	89 c3                	mov    %eax,%ebx
  803a59:	f7 e5                	mul    %ebp
  803a5b:	39 d6                	cmp    %edx,%esi
  803a5d:	72 19                	jb     803a78 <__udivdi3+0xfc>
  803a5f:	74 0b                	je     803a6c <__udivdi3+0xf0>
  803a61:	89 d8                	mov    %ebx,%eax
  803a63:	31 ff                	xor    %edi,%edi
  803a65:	e9 58 ff ff ff       	jmp    8039c2 <__udivdi3+0x46>
  803a6a:	66 90                	xchg   %ax,%ax
  803a6c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803a70:	89 f9                	mov    %edi,%ecx
  803a72:	d3 e2                	shl    %cl,%edx
  803a74:	39 c2                	cmp    %eax,%edx
  803a76:	73 e9                	jae    803a61 <__udivdi3+0xe5>
  803a78:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803a7b:	31 ff                	xor    %edi,%edi
  803a7d:	e9 40 ff ff ff       	jmp    8039c2 <__udivdi3+0x46>
  803a82:	66 90                	xchg   %ax,%ax
  803a84:	31 c0                	xor    %eax,%eax
  803a86:	e9 37 ff ff ff       	jmp    8039c2 <__udivdi3+0x46>
  803a8b:	90                   	nop

00803a8c <__umoddi3>:
  803a8c:	55                   	push   %ebp
  803a8d:	57                   	push   %edi
  803a8e:	56                   	push   %esi
  803a8f:	53                   	push   %ebx
  803a90:	83 ec 1c             	sub    $0x1c,%esp
  803a93:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803a97:	8b 74 24 34          	mov    0x34(%esp),%esi
  803a9b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a9f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803aa3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803aa7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803aab:	89 f3                	mov    %esi,%ebx
  803aad:	89 fa                	mov    %edi,%edx
  803aaf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ab3:	89 34 24             	mov    %esi,(%esp)
  803ab6:	85 c0                	test   %eax,%eax
  803ab8:	75 1a                	jne    803ad4 <__umoddi3+0x48>
  803aba:	39 f7                	cmp    %esi,%edi
  803abc:	0f 86 a2 00 00 00    	jbe    803b64 <__umoddi3+0xd8>
  803ac2:	89 c8                	mov    %ecx,%eax
  803ac4:	89 f2                	mov    %esi,%edx
  803ac6:	f7 f7                	div    %edi
  803ac8:	89 d0                	mov    %edx,%eax
  803aca:	31 d2                	xor    %edx,%edx
  803acc:	83 c4 1c             	add    $0x1c,%esp
  803acf:	5b                   	pop    %ebx
  803ad0:	5e                   	pop    %esi
  803ad1:	5f                   	pop    %edi
  803ad2:	5d                   	pop    %ebp
  803ad3:	c3                   	ret    
  803ad4:	39 f0                	cmp    %esi,%eax
  803ad6:	0f 87 ac 00 00 00    	ja     803b88 <__umoddi3+0xfc>
  803adc:	0f bd e8             	bsr    %eax,%ebp
  803adf:	83 f5 1f             	xor    $0x1f,%ebp
  803ae2:	0f 84 ac 00 00 00    	je     803b94 <__umoddi3+0x108>
  803ae8:	bf 20 00 00 00       	mov    $0x20,%edi
  803aed:	29 ef                	sub    %ebp,%edi
  803aef:	89 fe                	mov    %edi,%esi
  803af1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803af5:	89 e9                	mov    %ebp,%ecx
  803af7:	d3 e0                	shl    %cl,%eax
  803af9:	89 d7                	mov    %edx,%edi
  803afb:	89 f1                	mov    %esi,%ecx
  803afd:	d3 ef                	shr    %cl,%edi
  803aff:	09 c7                	or     %eax,%edi
  803b01:	89 e9                	mov    %ebp,%ecx
  803b03:	d3 e2                	shl    %cl,%edx
  803b05:	89 14 24             	mov    %edx,(%esp)
  803b08:	89 d8                	mov    %ebx,%eax
  803b0a:	d3 e0                	shl    %cl,%eax
  803b0c:	89 c2                	mov    %eax,%edx
  803b0e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b12:	d3 e0                	shl    %cl,%eax
  803b14:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b18:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b1c:	89 f1                	mov    %esi,%ecx
  803b1e:	d3 e8                	shr    %cl,%eax
  803b20:	09 d0                	or     %edx,%eax
  803b22:	d3 eb                	shr    %cl,%ebx
  803b24:	89 da                	mov    %ebx,%edx
  803b26:	f7 f7                	div    %edi
  803b28:	89 d3                	mov    %edx,%ebx
  803b2a:	f7 24 24             	mull   (%esp)
  803b2d:	89 c6                	mov    %eax,%esi
  803b2f:	89 d1                	mov    %edx,%ecx
  803b31:	39 d3                	cmp    %edx,%ebx
  803b33:	0f 82 87 00 00 00    	jb     803bc0 <__umoddi3+0x134>
  803b39:	0f 84 91 00 00 00    	je     803bd0 <__umoddi3+0x144>
  803b3f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803b43:	29 f2                	sub    %esi,%edx
  803b45:	19 cb                	sbb    %ecx,%ebx
  803b47:	89 d8                	mov    %ebx,%eax
  803b49:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803b4d:	d3 e0                	shl    %cl,%eax
  803b4f:	89 e9                	mov    %ebp,%ecx
  803b51:	d3 ea                	shr    %cl,%edx
  803b53:	09 d0                	or     %edx,%eax
  803b55:	89 e9                	mov    %ebp,%ecx
  803b57:	d3 eb                	shr    %cl,%ebx
  803b59:	89 da                	mov    %ebx,%edx
  803b5b:	83 c4 1c             	add    $0x1c,%esp
  803b5e:	5b                   	pop    %ebx
  803b5f:	5e                   	pop    %esi
  803b60:	5f                   	pop    %edi
  803b61:	5d                   	pop    %ebp
  803b62:	c3                   	ret    
  803b63:	90                   	nop
  803b64:	89 fd                	mov    %edi,%ebp
  803b66:	85 ff                	test   %edi,%edi
  803b68:	75 0b                	jne    803b75 <__umoddi3+0xe9>
  803b6a:	b8 01 00 00 00       	mov    $0x1,%eax
  803b6f:	31 d2                	xor    %edx,%edx
  803b71:	f7 f7                	div    %edi
  803b73:	89 c5                	mov    %eax,%ebp
  803b75:	89 f0                	mov    %esi,%eax
  803b77:	31 d2                	xor    %edx,%edx
  803b79:	f7 f5                	div    %ebp
  803b7b:	89 c8                	mov    %ecx,%eax
  803b7d:	f7 f5                	div    %ebp
  803b7f:	89 d0                	mov    %edx,%eax
  803b81:	e9 44 ff ff ff       	jmp    803aca <__umoddi3+0x3e>
  803b86:	66 90                	xchg   %ax,%ax
  803b88:	89 c8                	mov    %ecx,%eax
  803b8a:	89 f2                	mov    %esi,%edx
  803b8c:	83 c4 1c             	add    $0x1c,%esp
  803b8f:	5b                   	pop    %ebx
  803b90:	5e                   	pop    %esi
  803b91:	5f                   	pop    %edi
  803b92:	5d                   	pop    %ebp
  803b93:	c3                   	ret    
  803b94:	3b 04 24             	cmp    (%esp),%eax
  803b97:	72 06                	jb     803b9f <__umoddi3+0x113>
  803b99:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803b9d:	77 0f                	ja     803bae <__umoddi3+0x122>
  803b9f:	89 f2                	mov    %esi,%edx
  803ba1:	29 f9                	sub    %edi,%ecx
  803ba3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803ba7:	89 14 24             	mov    %edx,(%esp)
  803baa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803bae:	8b 44 24 04          	mov    0x4(%esp),%eax
  803bb2:	8b 14 24             	mov    (%esp),%edx
  803bb5:	83 c4 1c             	add    $0x1c,%esp
  803bb8:	5b                   	pop    %ebx
  803bb9:	5e                   	pop    %esi
  803bba:	5f                   	pop    %edi
  803bbb:	5d                   	pop    %ebp
  803bbc:	c3                   	ret    
  803bbd:	8d 76 00             	lea    0x0(%esi),%esi
  803bc0:	2b 04 24             	sub    (%esp),%eax
  803bc3:	19 fa                	sbb    %edi,%edx
  803bc5:	89 d1                	mov    %edx,%ecx
  803bc7:	89 c6                	mov    %eax,%esi
  803bc9:	e9 71 ff ff ff       	jmp    803b3f <__umoddi3+0xb3>
  803bce:	66 90                	xchg   %ax,%ax
  803bd0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803bd4:	72 ea                	jb     803bc0 <__umoddi3+0x134>
  803bd6:	89 d9                	mov    %ebx,%ecx
  803bd8:	e9 62 ff ff ff       	jmp    803b3f <__umoddi3+0xb3>
