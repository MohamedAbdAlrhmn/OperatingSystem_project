
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
  800041:	e8 f6 1d 00 00       	call   801e3c <sys_disable_interrupt>

		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 80 3b 80 00       	push   $0x803b80
  80004e:	e8 54 0b 00 00       	call   800ba7 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 82 3b 80 00       	push   $0x803b82
  80005e:	e8 44 0b 00 00       	call   800ba7 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 98 3b 80 00       	push   $0x803b98
  80006e:	e8 34 0b 00 00       	call   800ba7 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 82 3b 80 00       	push   $0x803b82
  80007e:	e8 24 0b 00 00       	call   800ba7 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 80 3b 80 00       	push   $0x803b80
  80008e:	e8 14 0b 00 00       	call   800ba7 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
		//readline("Enter the number of elements: ", Line);
		cprintf("Enter the number of elements: ");
  800096:	83 ec 0c             	sub    $0xc,%esp
  800099:	68 b0 3b 80 00       	push   $0x803bb0
  80009e:	e8 04 0b 00 00       	call   800ba7 <cprintf>
  8000a3:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = 2000 ;
  8000a6:	c7 45 f0 d0 07 00 00 	movl   $0x7d0,-0x10(%ebp)
		cprintf("%d\n", NumOfElements) ;
  8000ad:	83 ec 08             	sub    $0x8,%esp
  8000b0:	ff 75 f0             	pushl  -0x10(%ebp)
  8000b3:	68 cf 3b 80 00       	push   $0x803bcf
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
  8000d8:	68 d4 3b 80 00       	push   $0x803bd4
  8000dd:	e8 c5 0a 00 00       	call   800ba7 <cprintf>
  8000e2:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	68 f6 3b 80 00       	push   $0x803bf6
  8000ed:	e8 b5 0a 00 00       	call   800ba7 <cprintf>
  8000f2:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000f5:	83 ec 0c             	sub    $0xc,%esp
  8000f8:	68 04 3c 80 00       	push   $0x803c04
  8000fd:	e8 a5 0a 00 00       	call   800ba7 <cprintf>
  800102:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  800105:	83 ec 0c             	sub    $0xc,%esp
  800108:	68 13 3c 80 00       	push   $0x803c13
  80010d:	e8 95 0a 00 00       	call   800ba7 <cprintf>
  800112:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800115:	83 ec 0c             	sub    $0xc,%esp
  800118:	68 23 3c 80 00       	push   $0x803c23
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
  800158:	e8 f9 1c 00 00       	call   801e56 <sys_enable_interrupt>

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
  8001cd:	e8 6a 1c 00 00       	call   801e3c <sys_disable_interrupt>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001d2:	83 ec 0c             	sub    $0xc,%esp
  8001d5:	68 2c 3c 80 00       	push   $0x803c2c
  8001da:	e8 c8 09 00 00       	call   800ba7 <cprintf>
  8001df:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001e2:	e8 6f 1c 00 00       	call   801e56 <sys_enable_interrupt>

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
  800204:	68 60 3c 80 00       	push   $0x803c60
  800209:	6a 4e                	push   $0x4e
  80020b:	68 82 3c 80 00       	push   $0x803c82
  800210:	e8 de 06 00 00       	call   8008f3 <_panic>
		else
		{
			sys_disable_interrupt();
  800215:	e8 22 1c 00 00       	call   801e3c <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  80021a:	83 ec 0c             	sub    $0xc,%esp
  80021d:	68 a0 3c 80 00       	push   $0x803ca0
  800222:	e8 80 09 00 00       	call   800ba7 <cprintf>
  800227:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  80022a:	83 ec 0c             	sub    $0xc,%esp
  80022d:	68 d4 3c 80 00       	push   $0x803cd4
  800232:	e8 70 09 00 00       	call   800ba7 <cprintf>
  800237:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  80023a:	83 ec 0c             	sub    $0xc,%esp
  80023d:	68 08 3d 80 00       	push   $0x803d08
  800242:	e8 60 09 00 00       	call   800ba7 <cprintf>
  800247:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  80024a:	e8 07 1c 00 00       	call   801e56 <sys_enable_interrupt>
		}

		free(Elements) ;
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	ff 75 ec             	pushl  -0x14(%ebp)
  800255:	e8 03 19 00 00       	call   801b5d <free>
  80025a:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  80025d:	e8 da 1b 00 00       	call   801e3c <sys_disable_interrupt>
			Chose = 0 ;
  800262:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800266:	eb 3e                	jmp    8002a6 <_main+0x26e>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800268:	83 ec 0c             	sub    $0xc,%esp
  80026b:	68 3a 3d 80 00       	push   $0x803d3a
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
  8002b2:	e8 9f 1b 00 00       	call   801e56 <sys_enable_interrupt>

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
  800446:	68 80 3b 80 00       	push   $0x803b80
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
  800468:	68 58 3d 80 00       	push   $0x803d58
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
  800496:	68 cf 3b 80 00       	push   $0x803bcf
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
  80072b:	e8 40 17 00 00       	call   801e70 <sys_cputc>
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
  80073c:	e8 fb 16 00 00       	call   801e3c <sys_disable_interrupt>
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
  80074f:	e8 1c 17 00 00       	call   801e70 <sys_cputc>
  800754:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800757:	e8 fa 16 00 00       	call   801e56 <sys_enable_interrupt>
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
  80076e:	e8 44 15 00 00       	call   801cb7 <sys_cgetc>
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
  800787:	e8 b0 16 00 00       	call   801e3c <sys_disable_interrupt>
	int c=0;
  80078c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800793:	eb 08                	jmp    80079d <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800795:	e8 1d 15 00 00       	call   801cb7 <sys_cgetc>
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
  8007a3:	e8 ae 16 00 00       	call   801e56 <sys_enable_interrupt>
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
  8007bd:	e8 6d 18 00 00       	call   80202f <sys_getenvindex>
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
  800828:	e8 0f 16 00 00       	call   801e3c <sys_disable_interrupt>
	cprintf("**************************************\n");
  80082d:	83 ec 0c             	sub    $0xc,%esp
  800830:	68 78 3d 80 00       	push   $0x803d78
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
  800858:	68 a0 3d 80 00       	push   $0x803da0
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
  800889:	68 c8 3d 80 00       	push   $0x803dc8
  80088e:	e8 14 03 00 00       	call   800ba7 <cprintf>
  800893:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800896:	a1 24 50 80 00       	mov    0x805024,%eax
  80089b:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8008a1:	83 ec 08             	sub    $0x8,%esp
  8008a4:	50                   	push   %eax
  8008a5:	68 20 3e 80 00       	push   $0x803e20
  8008aa:	e8 f8 02 00 00       	call   800ba7 <cprintf>
  8008af:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8008b2:	83 ec 0c             	sub    $0xc,%esp
  8008b5:	68 78 3d 80 00       	push   $0x803d78
  8008ba:	e8 e8 02 00 00       	call   800ba7 <cprintf>
  8008bf:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8008c2:	e8 8f 15 00 00       	call   801e56 <sys_enable_interrupt>

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
  8008da:	e8 1c 17 00 00       	call   801ffb <sys_destroy_env>
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
  8008eb:	e8 71 17 00 00       	call   802061 <sys_exit_env>
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
  800914:	68 34 3e 80 00       	push   $0x803e34
  800919:	e8 89 02 00 00       	call   800ba7 <cprintf>
  80091e:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800921:	a1 00 50 80 00       	mov    0x805000,%eax
  800926:	ff 75 0c             	pushl  0xc(%ebp)
  800929:	ff 75 08             	pushl  0x8(%ebp)
  80092c:	50                   	push   %eax
  80092d:	68 39 3e 80 00       	push   $0x803e39
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
  800951:	68 55 3e 80 00       	push   $0x803e55
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
  80097d:	68 58 3e 80 00       	push   $0x803e58
  800982:	6a 26                	push   $0x26
  800984:	68 a4 3e 80 00       	push   $0x803ea4
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
  800a4f:	68 b0 3e 80 00       	push   $0x803eb0
  800a54:	6a 3a                	push   $0x3a
  800a56:	68 a4 3e 80 00       	push   $0x803ea4
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
  800abf:	68 04 3f 80 00       	push   $0x803f04
  800ac4:	6a 44                	push   $0x44
  800ac6:	68 a4 3e 80 00       	push   $0x803ea4
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
  800b19:	e8 70 11 00 00       	call   801c8e <sys_cputs>
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
  800b90:	e8 f9 10 00 00       	call   801c8e <sys_cputs>
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
  800bda:	e8 5d 12 00 00       	call   801e3c <sys_disable_interrupt>
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
  800bfa:	e8 57 12 00 00       	call   801e56 <sys_enable_interrupt>
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
  800c44:	e8 cb 2c 00 00       	call   803914 <__udivdi3>
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
  800c94:	e8 8b 2d 00 00       	call   803a24 <__umoddi3>
  800c99:	83 c4 10             	add    $0x10,%esp
  800c9c:	05 74 41 80 00       	add    $0x804174,%eax
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
  800def:	8b 04 85 98 41 80 00 	mov    0x804198(,%eax,4),%eax
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
  800ed0:	8b 34 9d e0 3f 80 00 	mov    0x803fe0(,%ebx,4),%esi
  800ed7:	85 f6                	test   %esi,%esi
  800ed9:	75 19                	jne    800ef4 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800edb:	53                   	push   %ebx
  800edc:	68 85 41 80 00       	push   $0x804185
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
  800ef5:	68 8e 41 80 00       	push   $0x80418e
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
  800f22:	be 91 41 80 00       	mov    $0x804191,%esi
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
  801948:	68 f0 42 80 00       	push   $0x8042f0
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
  801a18:	e8 b5 03 00 00       	call   801dd2 <sys_allocate_chunk>
  801a1d:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801a20:	a1 20 51 80 00       	mov    0x805120,%eax
  801a25:	83 ec 0c             	sub    $0xc,%esp
  801a28:	50                   	push   %eax
  801a29:	e8 2a 0a 00 00       	call   802458 <initialize_MemBlocksList>
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
  801a56:	68 15 43 80 00       	push   $0x804315
  801a5b:	6a 33                	push   $0x33
  801a5d:	68 33 43 80 00       	push   $0x804333
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
  801ad5:	68 40 43 80 00       	push   $0x804340
  801ada:	6a 34                	push   $0x34
  801adc:	68 33 43 80 00       	push   $0x804333
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
  801b4a:	68 64 43 80 00       	push   $0x804364
  801b4f:	6a 46                	push   $0x46
  801b51:	68 33 43 80 00       	push   $0x804333
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
  801b66:	68 8c 43 80 00       	push   $0x80438c
  801b6b:	6a 61                	push   $0x61
  801b6d:	68 33 43 80 00       	push   $0x804333
  801b72:	e8 7c ed ff ff       	call   8008f3 <_panic>

00801b77 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801b77:	55                   	push   %ebp
  801b78:	89 e5                	mov    %esp,%ebp
  801b7a:	83 ec 18             	sub    $0x18,%esp
  801b7d:	8b 45 10             	mov    0x10(%ebp),%eax
  801b80:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b83:	e8 a9 fd ff ff       	call   801931 <InitializeUHeap>
	if (size == 0) return NULL ;
  801b88:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b8c:	75 07                	jne    801b95 <smalloc+0x1e>
  801b8e:	b8 00 00 00 00       	mov    $0x0,%eax
  801b93:	eb 14                	jmp    801ba9 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801b95:	83 ec 04             	sub    $0x4,%esp
  801b98:	68 b0 43 80 00       	push   $0x8043b0
  801b9d:	6a 76                	push   $0x76
  801b9f:	68 33 43 80 00       	push   $0x804333
  801ba4:	e8 4a ed ff ff       	call   8008f3 <_panic>

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801ba9:	c9                   	leave  
  801baa:	c3                   	ret    

00801bab <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801bab:	55                   	push   %ebp
  801bac:	89 e5                	mov    %esp,%ebp
  801bae:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801bb1:	e8 7b fd ff ff       	call   801931 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801bb6:	83 ec 04             	sub    $0x4,%esp
  801bb9:	68 d8 43 80 00       	push   $0x8043d8
  801bbe:	68 93 00 00 00       	push   $0x93
  801bc3:	68 33 43 80 00       	push   $0x804333
  801bc8:	e8 26 ed ff ff       	call   8008f3 <_panic>

00801bcd <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801bcd:	55                   	push   %ebp
  801bce:	89 e5                	mov    %esp,%ebp
  801bd0:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801bd3:	e8 59 fd ff ff       	call   801931 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801bd8:	83 ec 04             	sub    $0x4,%esp
  801bdb:	68 fc 43 80 00       	push   $0x8043fc
  801be0:	68 c5 00 00 00       	push   $0xc5
  801be5:	68 33 43 80 00       	push   $0x804333
  801bea:	e8 04 ed ff ff       	call   8008f3 <_panic>

00801bef <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801bef:	55                   	push   %ebp
  801bf0:	89 e5                	mov    %esp,%ebp
  801bf2:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801bf5:	83 ec 04             	sub    $0x4,%esp
  801bf8:	68 24 44 80 00       	push   $0x804424
  801bfd:	68 d9 00 00 00       	push   $0xd9
  801c02:	68 33 43 80 00       	push   $0x804333
  801c07:	e8 e7 ec ff ff       	call   8008f3 <_panic>

00801c0c <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801c0c:	55                   	push   %ebp
  801c0d:	89 e5                	mov    %esp,%ebp
  801c0f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c12:	83 ec 04             	sub    $0x4,%esp
  801c15:	68 48 44 80 00       	push   $0x804448
  801c1a:	68 e4 00 00 00       	push   $0xe4
  801c1f:	68 33 43 80 00       	push   $0x804333
  801c24:	e8 ca ec ff ff       	call   8008f3 <_panic>

00801c29 <shrink>:

}
void shrink(uint32 newSize)
{
  801c29:	55                   	push   %ebp
  801c2a:	89 e5                	mov    %esp,%ebp
  801c2c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c2f:	83 ec 04             	sub    $0x4,%esp
  801c32:	68 48 44 80 00       	push   $0x804448
  801c37:	68 e9 00 00 00       	push   $0xe9
  801c3c:	68 33 43 80 00       	push   $0x804333
  801c41:	e8 ad ec ff ff       	call   8008f3 <_panic>

00801c46 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801c46:	55                   	push   %ebp
  801c47:	89 e5                	mov    %esp,%ebp
  801c49:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c4c:	83 ec 04             	sub    $0x4,%esp
  801c4f:	68 48 44 80 00       	push   $0x804448
  801c54:	68 ee 00 00 00       	push   $0xee
  801c59:	68 33 43 80 00       	push   $0x804333
  801c5e:	e8 90 ec ff ff       	call   8008f3 <_panic>

00801c63 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801c63:	55                   	push   %ebp
  801c64:	89 e5                	mov    %esp,%ebp
  801c66:	57                   	push   %edi
  801c67:	56                   	push   %esi
  801c68:	53                   	push   %ebx
  801c69:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c72:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c75:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c78:	8b 7d 18             	mov    0x18(%ebp),%edi
  801c7b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801c7e:	cd 30                	int    $0x30
  801c80:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801c83:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801c86:	83 c4 10             	add    $0x10,%esp
  801c89:	5b                   	pop    %ebx
  801c8a:	5e                   	pop    %esi
  801c8b:	5f                   	pop    %edi
  801c8c:	5d                   	pop    %ebp
  801c8d:	c3                   	ret    

00801c8e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801c8e:	55                   	push   %ebp
  801c8f:	89 e5                	mov    %esp,%ebp
  801c91:	83 ec 04             	sub    $0x4,%esp
  801c94:	8b 45 10             	mov    0x10(%ebp),%eax
  801c97:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801c9a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	52                   	push   %edx
  801ca6:	ff 75 0c             	pushl  0xc(%ebp)
  801ca9:	50                   	push   %eax
  801caa:	6a 00                	push   $0x0
  801cac:	e8 b2 ff ff ff       	call   801c63 <syscall>
  801cb1:	83 c4 18             	add    $0x18,%esp
}
  801cb4:	90                   	nop
  801cb5:	c9                   	leave  
  801cb6:	c3                   	ret    

00801cb7 <sys_cgetc>:

int
sys_cgetc(void)
{
  801cb7:	55                   	push   %ebp
  801cb8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 01                	push   $0x1
  801cc6:	e8 98 ff ff ff       	call   801c63 <syscall>
  801ccb:	83 c4 18             	add    $0x18,%esp
}
  801cce:	c9                   	leave  
  801ccf:	c3                   	ret    

00801cd0 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801cd0:	55                   	push   %ebp
  801cd1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801cd3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd9:	6a 00                	push   $0x0
  801cdb:	6a 00                	push   $0x0
  801cdd:	6a 00                	push   $0x0
  801cdf:	52                   	push   %edx
  801ce0:	50                   	push   %eax
  801ce1:	6a 05                	push   $0x5
  801ce3:	e8 7b ff ff ff       	call   801c63 <syscall>
  801ce8:	83 c4 18             	add    $0x18,%esp
}
  801ceb:	c9                   	leave  
  801cec:	c3                   	ret    

00801ced <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801ced:	55                   	push   %ebp
  801cee:	89 e5                	mov    %esp,%ebp
  801cf0:	56                   	push   %esi
  801cf1:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801cf2:	8b 75 18             	mov    0x18(%ebp),%esi
  801cf5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cf8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cfb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  801d01:	56                   	push   %esi
  801d02:	53                   	push   %ebx
  801d03:	51                   	push   %ecx
  801d04:	52                   	push   %edx
  801d05:	50                   	push   %eax
  801d06:	6a 06                	push   $0x6
  801d08:	e8 56 ff ff ff       	call   801c63 <syscall>
  801d0d:	83 c4 18             	add    $0x18,%esp
}
  801d10:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d13:	5b                   	pop    %ebx
  801d14:	5e                   	pop    %esi
  801d15:	5d                   	pop    %ebp
  801d16:	c3                   	ret    

00801d17 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801d17:	55                   	push   %ebp
  801d18:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801d1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	6a 00                	push   $0x0
  801d26:	52                   	push   %edx
  801d27:	50                   	push   %eax
  801d28:	6a 07                	push   $0x7
  801d2a:	e8 34 ff ff ff       	call   801c63 <syscall>
  801d2f:	83 c4 18             	add    $0x18,%esp
}
  801d32:	c9                   	leave  
  801d33:	c3                   	ret    

00801d34 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801d34:	55                   	push   %ebp
  801d35:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801d37:	6a 00                	push   $0x0
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 00                	push   $0x0
  801d3d:	ff 75 0c             	pushl  0xc(%ebp)
  801d40:	ff 75 08             	pushl  0x8(%ebp)
  801d43:	6a 08                	push   $0x8
  801d45:	e8 19 ff ff ff       	call   801c63 <syscall>
  801d4a:	83 c4 18             	add    $0x18,%esp
}
  801d4d:	c9                   	leave  
  801d4e:	c3                   	ret    

00801d4f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801d4f:	55                   	push   %ebp
  801d50:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 09                	push   $0x9
  801d5e:	e8 00 ff ff ff       	call   801c63 <syscall>
  801d63:	83 c4 18             	add    $0x18,%esp
}
  801d66:	c9                   	leave  
  801d67:	c3                   	ret    

00801d68 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801d68:	55                   	push   %ebp
  801d69:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 0a                	push   $0xa
  801d77:	e8 e7 fe ff ff       	call   801c63 <syscall>
  801d7c:	83 c4 18             	add    $0x18,%esp
}
  801d7f:	c9                   	leave  
  801d80:	c3                   	ret    

00801d81 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801d81:	55                   	push   %ebp
  801d82:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801d84:	6a 00                	push   $0x0
  801d86:	6a 00                	push   $0x0
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 0b                	push   $0xb
  801d90:	e8 ce fe ff ff       	call   801c63 <syscall>
  801d95:	83 c4 18             	add    $0x18,%esp
}
  801d98:	c9                   	leave  
  801d99:	c3                   	ret    

00801d9a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d9a:	55                   	push   %ebp
  801d9b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 00                	push   $0x0
  801da3:	ff 75 0c             	pushl  0xc(%ebp)
  801da6:	ff 75 08             	pushl  0x8(%ebp)
  801da9:	6a 0f                	push   $0xf
  801dab:	e8 b3 fe ff ff       	call   801c63 <syscall>
  801db0:	83 c4 18             	add    $0x18,%esp
	return;
  801db3:	90                   	nop
}
  801db4:	c9                   	leave  
  801db5:	c3                   	ret    

00801db6 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801db6:	55                   	push   %ebp
  801db7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	ff 75 0c             	pushl  0xc(%ebp)
  801dc2:	ff 75 08             	pushl  0x8(%ebp)
  801dc5:	6a 10                	push   $0x10
  801dc7:	e8 97 fe ff ff       	call   801c63 <syscall>
  801dcc:	83 c4 18             	add    $0x18,%esp
	return ;
  801dcf:	90                   	nop
}
  801dd0:	c9                   	leave  
  801dd1:	c3                   	ret    

00801dd2 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801dd2:	55                   	push   %ebp
  801dd3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	ff 75 10             	pushl  0x10(%ebp)
  801ddc:	ff 75 0c             	pushl  0xc(%ebp)
  801ddf:	ff 75 08             	pushl  0x8(%ebp)
  801de2:	6a 11                	push   $0x11
  801de4:	e8 7a fe ff ff       	call   801c63 <syscall>
  801de9:	83 c4 18             	add    $0x18,%esp
	return ;
  801dec:	90                   	nop
}
  801ded:	c9                   	leave  
  801dee:	c3                   	ret    

00801def <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801def:	55                   	push   %ebp
  801df0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 0c                	push   $0xc
  801dfe:	e8 60 fe ff ff       	call   801c63 <syscall>
  801e03:	83 c4 18             	add    $0x18,%esp
}
  801e06:	c9                   	leave  
  801e07:	c3                   	ret    

00801e08 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801e08:	55                   	push   %ebp
  801e09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	ff 75 08             	pushl  0x8(%ebp)
  801e16:	6a 0d                	push   $0xd
  801e18:	e8 46 fe ff ff       	call   801c63 <syscall>
  801e1d:	83 c4 18             	add    $0x18,%esp
}
  801e20:	c9                   	leave  
  801e21:	c3                   	ret    

00801e22 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801e22:	55                   	push   %ebp
  801e23:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801e25:	6a 00                	push   $0x0
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 0e                	push   $0xe
  801e31:	e8 2d fe ff ff       	call   801c63 <syscall>
  801e36:	83 c4 18             	add    $0x18,%esp
}
  801e39:	90                   	nop
  801e3a:	c9                   	leave  
  801e3b:	c3                   	ret    

00801e3c <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801e3c:	55                   	push   %ebp
  801e3d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 00                	push   $0x0
  801e43:	6a 00                	push   $0x0
  801e45:	6a 00                	push   $0x0
  801e47:	6a 00                	push   $0x0
  801e49:	6a 13                	push   $0x13
  801e4b:	e8 13 fe ff ff       	call   801c63 <syscall>
  801e50:	83 c4 18             	add    $0x18,%esp
}
  801e53:	90                   	nop
  801e54:	c9                   	leave  
  801e55:	c3                   	ret    

00801e56 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801e56:	55                   	push   %ebp
  801e57:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801e59:	6a 00                	push   $0x0
  801e5b:	6a 00                	push   $0x0
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 00                	push   $0x0
  801e63:	6a 14                	push   $0x14
  801e65:	e8 f9 fd ff ff       	call   801c63 <syscall>
  801e6a:	83 c4 18             	add    $0x18,%esp
}
  801e6d:	90                   	nop
  801e6e:	c9                   	leave  
  801e6f:	c3                   	ret    

00801e70 <sys_cputc>:


void
sys_cputc(const char c)
{
  801e70:	55                   	push   %ebp
  801e71:	89 e5                	mov    %esp,%ebp
  801e73:	83 ec 04             	sub    $0x4,%esp
  801e76:	8b 45 08             	mov    0x8(%ebp),%eax
  801e79:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801e7c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e80:	6a 00                	push   $0x0
  801e82:	6a 00                	push   $0x0
  801e84:	6a 00                	push   $0x0
  801e86:	6a 00                	push   $0x0
  801e88:	50                   	push   %eax
  801e89:	6a 15                	push   $0x15
  801e8b:	e8 d3 fd ff ff       	call   801c63 <syscall>
  801e90:	83 c4 18             	add    $0x18,%esp
}
  801e93:	90                   	nop
  801e94:	c9                   	leave  
  801e95:	c3                   	ret    

00801e96 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801e96:	55                   	push   %ebp
  801e97:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 16                	push   $0x16
  801ea5:	e8 b9 fd ff ff       	call   801c63 <syscall>
  801eaa:	83 c4 18             	add    $0x18,%esp
}
  801ead:	90                   	nop
  801eae:	c9                   	leave  
  801eaf:	c3                   	ret    

00801eb0 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801eb0:	55                   	push   %ebp
  801eb1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 00                	push   $0x0
  801eba:	6a 00                	push   $0x0
  801ebc:	ff 75 0c             	pushl  0xc(%ebp)
  801ebf:	50                   	push   %eax
  801ec0:	6a 17                	push   $0x17
  801ec2:	e8 9c fd ff ff       	call   801c63 <syscall>
  801ec7:	83 c4 18             	add    $0x18,%esp
}
  801eca:	c9                   	leave  
  801ecb:	c3                   	ret    

00801ecc <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801ecc:	55                   	push   %ebp
  801ecd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ecf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed5:	6a 00                	push   $0x0
  801ed7:	6a 00                	push   $0x0
  801ed9:	6a 00                	push   $0x0
  801edb:	52                   	push   %edx
  801edc:	50                   	push   %eax
  801edd:	6a 1a                	push   $0x1a
  801edf:	e8 7f fd ff ff       	call   801c63 <syscall>
  801ee4:	83 c4 18             	add    $0x18,%esp
}
  801ee7:	c9                   	leave  
  801ee8:	c3                   	ret    

00801ee9 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ee9:	55                   	push   %ebp
  801eea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801eec:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eef:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef2:	6a 00                	push   $0x0
  801ef4:	6a 00                	push   $0x0
  801ef6:	6a 00                	push   $0x0
  801ef8:	52                   	push   %edx
  801ef9:	50                   	push   %eax
  801efa:	6a 18                	push   $0x18
  801efc:	e8 62 fd ff ff       	call   801c63 <syscall>
  801f01:	83 c4 18             	add    $0x18,%esp
}
  801f04:	90                   	nop
  801f05:	c9                   	leave  
  801f06:	c3                   	ret    

00801f07 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f07:	55                   	push   %ebp
  801f08:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f10:	6a 00                	push   $0x0
  801f12:	6a 00                	push   $0x0
  801f14:	6a 00                	push   $0x0
  801f16:	52                   	push   %edx
  801f17:	50                   	push   %eax
  801f18:	6a 19                	push   $0x19
  801f1a:	e8 44 fd ff ff       	call   801c63 <syscall>
  801f1f:	83 c4 18             	add    $0x18,%esp
}
  801f22:	90                   	nop
  801f23:	c9                   	leave  
  801f24:	c3                   	ret    

00801f25 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801f25:	55                   	push   %ebp
  801f26:	89 e5                	mov    %esp,%ebp
  801f28:	83 ec 04             	sub    $0x4,%esp
  801f2b:	8b 45 10             	mov    0x10(%ebp),%eax
  801f2e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801f31:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f34:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f38:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3b:	6a 00                	push   $0x0
  801f3d:	51                   	push   %ecx
  801f3e:	52                   	push   %edx
  801f3f:	ff 75 0c             	pushl  0xc(%ebp)
  801f42:	50                   	push   %eax
  801f43:	6a 1b                	push   $0x1b
  801f45:	e8 19 fd ff ff       	call   801c63 <syscall>
  801f4a:	83 c4 18             	add    $0x18,%esp
}
  801f4d:	c9                   	leave  
  801f4e:	c3                   	ret    

00801f4f <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801f4f:	55                   	push   %ebp
  801f50:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801f52:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f55:	8b 45 08             	mov    0x8(%ebp),%eax
  801f58:	6a 00                	push   $0x0
  801f5a:	6a 00                	push   $0x0
  801f5c:	6a 00                	push   $0x0
  801f5e:	52                   	push   %edx
  801f5f:	50                   	push   %eax
  801f60:	6a 1c                	push   $0x1c
  801f62:	e8 fc fc ff ff       	call   801c63 <syscall>
  801f67:	83 c4 18             	add    $0x18,%esp
}
  801f6a:	c9                   	leave  
  801f6b:	c3                   	ret    

00801f6c <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801f6c:	55                   	push   %ebp
  801f6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801f6f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f72:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f75:	8b 45 08             	mov    0x8(%ebp),%eax
  801f78:	6a 00                	push   $0x0
  801f7a:	6a 00                	push   $0x0
  801f7c:	51                   	push   %ecx
  801f7d:	52                   	push   %edx
  801f7e:	50                   	push   %eax
  801f7f:	6a 1d                	push   $0x1d
  801f81:	e8 dd fc ff ff       	call   801c63 <syscall>
  801f86:	83 c4 18             	add    $0x18,%esp
}
  801f89:	c9                   	leave  
  801f8a:	c3                   	ret    

00801f8b <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801f8b:	55                   	push   %ebp
  801f8c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801f8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f91:	8b 45 08             	mov    0x8(%ebp),%eax
  801f94:	6a 00                	push   $0x0
  801f96:	6a 00                	push   $0x0
  801f98:	6a 00                	push   $0x0
  801f9a:	52                   	push   %edx
  801f9b:	50                   	push   %eax
  801f9c:	6a 1e                	push   $0x1e
  801f9e:	e8 c0 fc ff ff       	call   801c63 <syscall>
  801fa3:	83 c4 18             	add    $0x18,%esp
}
  801fa6:	c9                   	leave  
  801fa7:	c3                   	ret    

00801fa8 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801fa8:	55                   	push   %ebp
  801fa9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801fab:	6a 00                	push   $0x0
  801fad:	6a 00                	push   $0x0
  801faf:	6a 00                	push   $0x0
  801fb1:	6a 00                	push   $0x0
  801fb3:	6a 00                	push   $0x0
  801fb5:	6a 1f                	push   $0x1f
  801fb7:	e8 a7 fc ff ff       	call   801c63 <syscall>
  801fbc:	83 c4 18             	add    $0x18,%esp
}
  801fbf:	c9                   	leave  
  801fc0:	c3                   	ret    

00801fc1 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801fc1:	55                   	push   %ebp
  801fc2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc7:	6a 00                	push   $0x0
  801fc9:	ff 75 14             	pushl  0x14(%ebp)
  801fcc:	ff 75 10             	pushl  0x10(%ebp)
  801fcf:	ff 75 0c             	pushl  0xc(%ebp)
  801fd2:	50                   	push   %eax
  801fd3:	6a 20                	push   $0x20
  801fd5:	e8 89 fc ff ff       	call   801c63 <syscall>
  801fda:	83 c4 18             	add    $0x18,%esp
}
  801fdd:	c9                   	leave  
  801fde:	c3                   	ret    

00801fdf <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801fdf:	55                   	push   %ebp
  801fe0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe5:	6a 00                	push   $0x0
  801fe7:	6a 00                	push   $0x0
  801fe9:	6a 00                	push   $0x0
  801feb:	6a 00                	push   $0x0
  801fed:	50                   	push   %eax
  801fee:	6a 21                	push   $0x21
  801ff0:	e8 6e fc ff ff       	call   801c63 <syscall>
  801ff5:	83 c4 18             	add    $0x18,%esp
}
  801ff8:	90                   	nop
  801ff9:	c9                   	leave  
  801ffa:	c3                   	ret    

00801ffb <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ffb:	55                   	push   %ebp
  801ffc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  802001:	6a 00                	push   $0x0
  802003:	6a 00                	push   $0x0
  802005:	6a 00                	push   $0x0
  802007:	6a 00                	push   $0x0
  802009:	50                   	push   %eax
  80200a:	6a 22                	push   $0x22
  80200c:	e8 52 fc ff ff       	call   801c63 <syscall>
  802011:	83 c4 18             	add    $0x18,%esp
}
  802014:	c9                   	leave  
  802015:	c3                   	ret    

00802016 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802016:	55                   	push   %ebp
  802017:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802019:	6a 00                	push   $0x0
  80201b:	6a 00                	push   $0x0
  80201d:	6a 00                	push   $0x0
  80201f:	6a 00                	push   $0x0
  802021:	6a 00                	push   $0x0
  802023:	6a 02                	push   $0x2
  802025:	e8 39 fc ff ff       	call   801c63 <syscall>
  80202a:	83 c4 18             	add    $0x18,%esp
}
  80202d:	c9                   	leave  
  80202e:	c3                   	ret    

0080202f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80202f:	55                   	push   %ebp
  802030:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802032:	6a 00                	push   $0x0
  802034:	6a 00                	push   $0x0
  802036:	6a 00                	push   $0x0
  802038:	6a 00                	push   $0x0
  80203a:	6a 00                	push   $0x0
  80203c:	6a 03                	push   $0x3
  80203e:	e8 20 fc ff ff       	call   801c63 <syscall>
  802043:	83 c4 18             	add    $0x18,%esp
}
  802046:	c9                   	leave  
  802047:	c3                   	ret    

00802048 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802048:	55                   	push   %ebp
  802049:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80204b:	6a 00                	push   $0x0
  80204d:	6a 00                	push   $0x0
  80204f:	6a 00                	push   $0x0
  802051:	6a 00                	push   $0x0
  802053:	6a 00                	push   $0x0
  802055:	6a 04                	push   $0x4
  802057:	e8 07 fc ff ff       	call   801c63 <syscall>
  80205c:	83 c4 18             	add    $0x18,%esp
}
  80205f:	c9                   	leave  
  802060:	c3                   	ret    

00802061 <sys_exit_env>:


void sys_exit_env(void)
{
  802061:	55                   	push   %ebp
  802062:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802064:	6a 00                	push   $0x0
  802066:	6a 00                	push   $0x0
  802068:	6a 00                	push   $0x0
  80206a:	6a 00                	push   $0x0
  80206c:	6a 00                	push   $0x0
  80206e:	6a 23                	push   $0x23
  802070:	e8 ee fb ff ff       	call   801c63 <syscall>
  802075:	83 c4 18             	add    $0x18,%esp
}
  802078:	90                   	nop
  802079:	c9                   	leave  
  80207a:	c3                   	ret    

0080207b <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80207b:	55                   	push   %ebp
  80207c:	89 e5                	mov    %esp,%ebp
  80207e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802081:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802084:	8d 50 04             	lea    0x4(%eax),%edx
  802087:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80208a:	6a 00                	push   $0x0
  80208c:	6a 00                	push   $0x0
  80208e:	6a 00                	push   $0x0
  802090:	52                   	push   %edx
  802091:	50                   	push   %eax
  802092:	6a 24                	push   $0x24
  802094:	e8 ca fb ff ff       	call   801c63 <syscall>
  802099:	83 c4 18             	add    $0x18,%esp
	return result;
  80209c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80209f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020a2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8020a5:	89 01                	mov    %eax,(%ecx)
  8020a7:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8020aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ad:	c9                   	leave  
  8020ae:	c2 04 00             	ret    $0x4

008020b1 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8020b1:	55                   	push   %ebp
  8020b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8020b4:	6a 00                	push   $0x0
  8020b6:	6a 00                	push   $0x0
  8020b8:	ff 75 10             	pushl  0x10(%ebp)
  8020bb:	ff 75 0c             	pushl  0xc(%ebp)
  8020be:	ff 75 08             	pushl  0x8(%ebp)
  8020c1:	6a 12                	push   $0x12
  8020c3:	e8 9b fb ff ff       	call   801c63 <syscall>
  8020c8:	83 c4 18             	add    $0x18,%esp
	return ;
  8020cb:	90                   	nop
}
  8020cc:	c9                   	leave  
  8020cd:	c3                   	ret    

008020ce <sys_rcr2>:
uint32 sys_rcr2()
{
  8020ce:	55                   	push   %ebp
  8020cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8020d1:	6a 00                	push   $0x0
  8020d3:	6a 00                	push   $0x0
  8020d5:	6a 00                	push   $0x0
  8020d7:	6a 00                	push   $0x0
  8020d9:	6a 00                	push   $0x0
  8020db:	6a 25                	push   $0x25
  8020dd:	e8 81 fb ff ff       	call   801c63 <syscall>
  8020e2:	83 c4 18             	add    $0x18,%esp
}
  8020e5:	c9                   	leave  
  8020e6:	c3                   	ret    

008020e7 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8020e7:	55                   	push   %ebp
  8020e8:	89 e5                	mov    %esp,%ebp
  8020ea:	83 ec 04             	sub    $0x4,%esp
  8020ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8020f3:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8020f7:	6a 00                	push   $0x0
  8020f9:	6a 00                	push   $0x0
  8020fb:	6a 00                	push   $0x0
  8020fd:	6a 00                	push   $0x0
  8020ff:	50                   	push   %eax
  802100:	6a 26                	push   $0x26
  802102:	e8 5c fb ff ff       	call   801c63 <syscall>
  802107:	83 c4 18             	add    $0x18,%esp
	return ;
  80210a:	90                   	nop
}
  80210b:	c9                   	leave  
  80210c:	c3                   	ret    

0080210d <rsttst>:
void rsttst()
{
  80210d:	55                   	push   %ebp
  80210e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802110:	6a 00                	push   $0x0
  802112:	6a 00                	push   $0x0
  802114:	6a 00                	push   $0x0
  802116:	6a 00                	push   $0x0
  802118:	6a 00                	push   $0x0
  80211a:	6a 28                	push   $0x28
  80211c:	e8 42 fb ff ff       	call   801c63 <syscall>
  802121:	83 c4 18             	add    $0x18,%esp
	return ;
  802124:	90                   	nop
}
  802125:	c9                   	leave  
  802126:	c3                   	ret    

00802127 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802127:	55                   	push   %ebp
  802128:	89 e5                	mov    %esp,%ebp
  80212a:	83 ec 04             	sub    $0x4,%esp
  80212d:	8b 45 14             	mov    0x14(%ebp),%eax
  802130:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802133:	8b 55 18             	mov    0x18(%ebp),%edx
  802136:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80213a:	52                   	push   %edx
  80213b:	50                   	push   %eax
  80213c:	ff 75 10             	pushl  0x10(%ebp)
  80213f:	ff 75 0c             	pushl  0xc(%ebp)
  802142:	ff 75 08             	pushl  0x8(%ebp)
  802145:	6a 27                	push   $0x27
  802147:	e8 17 fb ff ff       	call   801c63 <syscall>
  80214c:	83 c4 18             	add    $0x18,%esp
	return ;
  80214f:	90                   	nop
}
  802150:	c9                   	leave  
  802151:	c3                   	ret    

00802152 <chktst>:
void chktst(uint32 n)
{
  802152:	55                   	push   %ebp
  802153:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802155:	6a 00                	push   $0x0
  802157:	6a 00                	push   $0x0
  802159:	6a 00                	push   $0x0
  80215b:	6a 00                	push   $0x0
  80215d:	ff 75 08             	pushl  0x8(%ebp)
  802160:	6a 29                	push   $0x29
  802162:	e8 fc fa ff ff       	call   801c63 <syscall>
  802167:	83 c4 18             	add    $0x18,%esp
	return ;
  80216a:	90                   	nop
}
  80216b:	c9                   	leave  
  80216c:	c3                   	ret    

0080216d <inctst>:

void inctst()
{
  80216d:	55                   	push   %ebp
  80216e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802170:	6a 00                	push   $0x0
  802172:	6a 00                	push   $0x0
  802174:	6a 00                	push   $0x0
  802176:	6a 00                	push   $0x0
  802178:	6a 00                	push   $0x0
  80217a:	6a 2a                	push   $0x2a
  80217c:	e8 e2 fa ff ff       	call   801c63 <syscall>
  802181:	83 c4 18             	add    $0x18,%esp
	return ;
  802184:	90                   	nop
}
  802185:	c9                   	leave  
  802186:	c3                   	ret    

00802187 <gettst>:
uint32 gettst()
{
  802187:	55                   	push   %ebp
  802188:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80218a:	6a 00                	push   $0x0
  80218c:	6a 00                	push   $0x0
  80218e:	6a 00                	push   $0x0
  802190:	6a 00                	push   $0x0
  802192:	6a 00                	push   $0x0
  802194:	6a 2b                	push   $0x2b
  802196:	e8 c8 fa ff ff       	call   801c63 <syscall>
  80219b:	83 c4 18             	add    $0x18,%esp
}
  80219e:	c9                   	leave  
  80219f:	c3                   	ret    

008021a0 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8021a0:	55                   	push   %ebp
  8021a1:	89 e5                	mov    %esp,%ebp
  8021a3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021a6:	6a 00                	push   $0x0
  8021a8:	6a 00                	push   $0x0
  8021aa:	6a 00                	push   $0x0
  8021ac:	6a 00                	push   $0x0
  8021ae:	6a 00                	push   $0x0
  8021b0:	6a 2c                	push   $0x2c
  8021b2:	e8 ac fa ff ff       	call   801c63 <syscall>
  8021b7:	83 c4 18             	add    $0x18,%esp
  8021ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8021bd:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8021c1:	75 07                	jne    8021ca <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8021c3:	b8 01 00 00 00       	mov    $0x1,%eax
  8021c8:	eb 05                	jmp    8021cf <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8021ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021cf:	c9                   	leave  
  8021d0:	c3                   	ret    

008021d1 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8021d1:	55                   	push   %ebp
  8021d2:	89 e5                	mov    %esp,%ebp
  8021d4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021d7:	6a 00                	push   $0x0
  8021d9:	6a 00                	push   $0x0
  8021db:	6a 00                	push   $0x0
  8021dd:	6a 00                	push   $0x0
  8021df:	6a 00                	push   $0x0
  8021e1:	6a 2c                	push   $0x2c
  8021e3:	e8 7b fa ff ff       	call   801c63 <syscall>
  8021e8:	83 c4 18             	add    $0x18,%esp
  8021eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8021ee:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8021f2:	75 07                	jne    8021fb <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8021f4:	b8 01 00 00 00       	mov    $0x1,%eax
  8021f9:	eb 05                	jmp    802200 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8021fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802200:	c9                   	leave  
  802201:	c3                   	ret    

00802202 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802202:	55                   	push   %ebp
  802203:	89 e5                	mov    %esp,%ebp
  802205:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802208:	6a 00                	push   $0x0
  80220a:	6a 00                	push   $0x0
  80220c:	6a 00                	push   $0x0
  80220e:	6a 00                	push   $0x0
  802210:	6a 00                	push   $0x0
  802212:	6a 2c                	push   $0x2c
  802214:	e8 4a fa ff ff       	call   801c63 <syscall>
  802219:	83 c4 18             	add    $0x18,%esp
  80221c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80221f:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802223:	75 07                	jne    80222c <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802225:	b8 01 00 00 00       	mov    $0x1,%eax
  80222a:	eb 05                	jmp    802231 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80222c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802231:	c9                   	leave  
  802232:	c3                   	ret    

00802233 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802233:	55                   	push   %ebp
  802234:	89 e5                	mov    %esp,%ebp
  802236:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802239:	6a 00                	push   $0x0
  80223b:	6a 00                	push   $0x0
  80223d:	6a 00                	push   $0x0
  80223f:	6a 00                	push   $0x0
  802241:	6a 00                	push   $0x0
  802243:	6a 2c                	push   $0x2c
  802245:	e8 19 fa ff ff       	call   801c63 <syscall>
  80224a:	83 c4 18             	add    $0x18,%esp
  80224d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802250:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802254:	75 07                	jne    80225d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802256:	b8 01 00 00 00       	mov    $0x1,%eax
  80225b:	eb 05                	jmp    802262 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80225d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802262:	c9                   	leave  
  802263:	c3                   	ret    

00802264 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802264:	55                   	push   %ebp
  802265:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802267:	6a 00                	push   $0x0
  802269:	6a 00                	push   $0x0
  80226b:	6a 00                	push   $0x0
  80226d:	6a 00                	push   $0x0
  80226f:	ff 75 08             	pushl  0x8(%ebp)
  802272:	6a 2d                	push   $0x2d
  802274:	e8 ea f9 ff ff       	call   801c63 <syscall>
  802279:	83 c4 18             	add    $0x18,%esp
	return ;
  80227c:	90                   	nop
}
  80227d:	c9                   	leave  
  80227e:	c3                   	ret    

0080227f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80227f:	55                   	push   %ebp
  802280:	89 e5                	mov    %esp,%ebp
  802282:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802283:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802286:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802289:	8b 55 0c             	mov    0xc(%ebp),%edx
  80228c:	8b 45 08             	mov    0x8(%ebp),%eax
  80228f:	6a 00                	push   $0x0
  802291:	53                   	push   %ebx
  802292:	51                   	push   %ecx
  802293:	52                   	push   %edx
  802294:	50                   	push   %eax
  802295:	6a 2e                	push   $0x2e
  802297:	e8 c7 f9 ff ff       	call   801c63 <syscall>
  80229c:	83 c4 18             	add    $0x18,%esp
}
  80229f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022a2:	c9                   	leave  
  8022a3:	c3                   	ret    

008022a4 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8022a4:	55                   	push   %ebp
  8022a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8022a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ad:	6a 00                	push   $0x0
  8022af:	6a 00                	push   $0x0
  8022b1:	6a 00                	push   $0x0
  8022b3:	52                   	push   %edx
  8022b4:	50                   	push   %eax
  8022b5:	6a 2f                	push   $0x2f
  8022b7:	e8 a7 f9 ff ff       	call   801c63 <syscall>
  8022bc:	83 c4 18             	add    $0x18,%esp
}
  8022bf:	c9                   	leave  
  8022c0:	c3                   	ret    

008022c1 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8022c1:	55                   	push   %ebp
  8022c2:	89 e5                	mov    %esp,%ebp
  8022c4:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8022c7:	83 ec 0c             	sub    $0xc,%esp
  8022ca:	68 58 44 80 00       	push   $0x804458
  8022cf:	e8 d3 e8 ff ff       	call   800ba7 <cprintf>
  8022d4:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8022d7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8022de:	83 ec 0c             	sub    $0xc,%esp
  8022e1:	68 84 44 80 00       	push   $0x804484
  8022e6:	e8 bc e8 ff ff       	call   800ba7 <cprintf>
  8022eb:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8022ee:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8022f2:	a1 38 51 80 00       	mov    0x805138,%eax
  8022f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022fa:	eb 56                	jmp    802352 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8022fc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802300:	74 1c                	je     80231e <print_mem_block_lists+0x5d>
  802302:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802305:	8b 50 08             	mov    0x8(%eax),%edx
  802308:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80230b:	8b 48 08             	mov    0x8(%eax),%ecx
  80230e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802311:	8b 40 0c             	mov    0xc(%eax),%eax
  802314:	01 c8                	add    %ecx,%eax
  802316:	39 c2                	cmp    %eax,%edx
  802318:	73 04                	jae    80231e <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80231a:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80231e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802321:	8b 50 08             	mov    0x8(%eax),%edx
  802324:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802327:	8b 40 0c             	mov    0xc(%eax),%eax
  80232a:	01 c2                	add    %eax,%edx
  80232c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232f:	8b 40 08             	mov    0x8(%eax),%eax
  802332:	83 ec 04             	sub    $0x4,%esp
  802335:	52                   	push   %edx
  802336:	50                   	push   %eax
  802337:	68 99 44 80 00       	push   $0x804499
  80233c:	e8 66 e8 ff ff       	call   800ba7 <cprintf>
  802341:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802344:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802347:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80234a:	a1 40 51 80 00       	mov    0x805140,%eax
  80234f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802352:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802356:	74 07                	je     80235f <print_mem_block_lists+0x9e>
  802358:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235b:	8b 00                	mov    (%eax),%eax
  80235d:	eb 05                	jmp    802364 <print_mem_block_lists+0xa3>
  80235f:	b8 00 00 00 00       	mov    $0x0,%eax
  802364:	a3 40 51 80 00       	mov    %eax,0x805140
  802369:	a1 40 51 80 00       	mov    0x805140,%eax
  80236e:	85 c0                	test   %eax,%eax
  802370:	75 8a                	jne    8022fc <print_mem_block_lists+0x3b>
  802372:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802376:	75 84                	jne    8022fc <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802378:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80237c:	75 10                	jne    80238e <print_mem_block_lists+0xcd>
  80237e:	83 ec 0c             	sub    $0xc,%esp
  802381:	68 a8 44 80 00       	push   $0x8044a8
  802386:	e8 1c e8 ff ff       	call   800ba7 <cprintf>
  80238b:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80238e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802395:	83 ec 0c             	sub    $0xc,%esp
  802398:	68 cc 44 80 00       	push   $0x8044cc
  80239d:	e8 05 e8 ff ff       	call   800ba7 <cprintf>
  8023a2:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8023a5:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8023a9:	a1 40 50 80 00       	mov    0x805040,%eax
  8023ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023b1:	eb 56                	jmp    802409 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8023b3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023b7:	74 1c                	je     8023d5 <print_mem_block_lists+0x114>
  8023b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bc:	8b 50 08             	mov    0x8(%eax),%edx
  8023bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c2:	8b 48 08             	mov    0x8(%eax),%ecx
  8023c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8023cb:	01 c8                	add    %ecx,%eax
  8023cd:	39 c2                	cmp    %eax,%edx
  8023cf:	73 04                	jae    8023d5 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8023d1:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8023d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d8:	8b 50 08             	mov    0x8(%eax),%edx
  8023db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023de:	8b 40 0c             	mov    0xc(%eax),%eax
  8023e1:	01 c2                	add    %eax,%edx
  8023e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e6:	8b 40 08             	mov    0x8(%eax),%eax
  8023e9:	83 ec 04             	sub    $0x4,%esp
  8023ec:	52                   	push   %edx
  8023ed:	50                   	push   %eax
  8023ee:	68 99 44 80 00       	push   $0x804499
  8023f3:	e8 af e7 ff ff       	call   800ba7 <cprintf>
  8023f8:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8023fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802401:	a1 48 50 80 00       	mov    0x805048,%eax
  802406:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802409:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80240d:	74 07                	je     802416 <print_mem_block_lists+0x155>
  80240f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802412:	8b 00                	mov    (%eax),%eax
  802414:	eb 05                	jmp    80241b <print_mem_block_lists+0x15a>
  802416:	b8 00 00 00 00       	mov    $0x0,%eax
  80241b:	a3 48 50 80 00       	mov    %eax,0x805048
  802420:	a1 48 50 80 00       	mov    0x805048,%eax
  802425:	85 c0                	test   %eax,%eax
  802427:	75 8a                	jne    8023b3 <print_mem_block_lists+0xf2>
  802429:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80242d:	75 84                	jne    8023b3 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80242f:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802433:	75 10                	jne    802445 <print_mem_block_lists+0x184>
  802435:	83 ec 0c             	sub    $0xc,%esp
  802438:	68 e4 44 80 00       	push   $0x8044e4
  80243d:	e8 65 e7 ff ff       	call   800ba7 <cprintf>
  802442:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802445:	83 ec 0c             	sub    $0xc,%esp
  802448:	68 58 44 80 00       	push   $0x804458
  80244d:	e8 55 e7 ff ff       	call   800ba7 <cprintf>
  802452:	83 c4 10             	add    $0x10,%esp

}
  802455:	90                   	nop
  802456:	c9                   	leave  
  802457:	c3                   	ret    

00802458 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802458:	55                   	push   %ebp
  802459:	89 e5                	mov    %esp,%ebp
  80245b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  80245e:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802465:	00 00 00 
  802468:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80246f:	00 00 00 
  802472:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802479:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  80247c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802483:	e9 9e 00 00 00       	jmp    802526 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802488:	a1 50 50 80 00       	mov    0x805050,%eax
  80248d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802490:	c1 e2 04             	shl    $0x4,%edx
  802493:	01 d0                	add    %edx,%eax
  802495:	85 c0                	test   %eax,%eax
  802497:	75 14                	jne    8024ad <initialize_MemBlocksList+0x55>
  802499:	83 ec 04             	sub    $0x4,%esp
  80249c:	68 0c 45 80 00       	push   $0x80450c
  8024a1:	6a 46                	push   $0x46
  8024a3:	68 2f 45 80 00       	push   $0x80452f
  8024a8:	e8 46 e4 ff ff       	call   8008f3 <_panic>
  8024ad:	a1 50 50 80 00       	mov    0x805050,%eax
  8024b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024b5:	c1 e2 04             	shl    $0x4,%edx
  8024b8:	01 d0                	add    %edx,%eax
  8024ba:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8024c0:	89 10                	mov    %edx,(%eax)
  8024c2:	8b 00                	mov    (%eax),%eax
  8024c4:	85 c0                	test   %eax,%eax
  8024c6:	74 18                	je     8024e0 <initialize_MemBlocksList+0x88>
  8024c8:	a1 48 51 80 00       	mov    0x805148,%eax
  8024cd:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8024d3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8024d6:	c1 e1 04             	shl    $0x4,%ecx
  8024d9:	01 ca                	add    %ecx,%edx
  8024db:	89 50 04             	mov    %edx,0x4(%eax)
  8024de:	eb 12                	jmp    8024f2 <initialize_MemBlocksList+0x9a>
  8024e0:	a1 50 50 80 00       	mov    0x805050,%eax
  8024e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024e8:	c1 e2 04             	shl    $0x4,%edx
  8024eb:	01 d0                	add    %edx,%eax
  8024ed:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8024f2:	a1 50 50 80 00       	mov    0x805050,%eax
  8024f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024fa:	c1 e2 04             	shl    $0x4,%edx
  8024fd:	01 d0                	add    %edx,%eax
  8024ff:	a3 48 51 80 00       	mov    %eax,0x805148
  802504:	a1 50 50 80 00       	mov    0x805050,%eax
  802509:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80250c:	c1 e2 04             	shl    $0x4,%edx
  80250f:	01 d0                	add    %edx,%eax
  802511:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802518:	a1 54 51 80 00       	mov    0x805154,%eax
  80251d:	40                   	inc    %eax
  80251e:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802523:	ff 45 f4             	incl   -0xc(%ebp)
  802526:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802529:	3b 45 08             	cmp    0x8(%ebp),%eax
  80252c:	0f 82 56 ff ff ff    	jb     802488 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802532:	90                   	nop
  802533:	c9                   	leave  
  802534:	c3                   	ret    

00802535 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802535:	55                   	push   %ebp
  802536:	89 e5                	mov    %esp,%ebp
  802538:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80253b:	8b 45 08             	mov    0x8(%ebp),%eax
  80253e:	8b 00                	mov    (%eax),%eax
  802540:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802543:	eb 19                	jmp    80255e <find_block+0x29>
	{
		if(va==point->sva)
  802545:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802548:	8b 40 08             	mov    0x8(%eax),%eax
  80254b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80254e:	75 05                	jne    802555 <find_block+0x20>
		   return point;
  802550:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802553:	eb 36                	jmp    80258b <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802555:	8b 45 08             	mov    0x8(%ebp),%eax
  802558:	8b 40 08             	mov    0x8(%eax),%eax
  80255b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80255e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802562:	74 07                	je     80256b <find_block+0x36>
  802564:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802567:	8b 00                	mov    (%eax),%eax
  802569:	eb 05                	jmp    802570 <find_block+0x3b>
  80256b:	b8 00 00 00 00       	mov    $0x0,%eax
  802570:	8b 55 08             	mov    0x8(%ebp),%edx
  802573:	89 42 08             	mov    %eax,0x8(%edx)
  802576:	8b 45 08             	mov    0x8(%ebp),%eax
  802579:	8b 40 08             	mov    0x8(%eax),%eax
  80257c:	85 c0                	test   %eax,%eax
  80257e:	75 c5                	jne    802545 <find_block+0x10>
  802580:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802584:	75 bf                	jne    802545 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802586:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80258b:	c9                   	leave  
  80258c:	c3                   	ret    

0080258d <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80258d:	55                   	push   %ebp
  80258e:	89 e5                	mov    %esp,%ebp
  802590:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802593:	a1 40 50 80 00       	mov    0x805040,%eax
  802598:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  80259b:	a1 44 50 80 00       	mov    0x805044,%eax
  8025a0:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8025a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8025a9:	74 24                	je     8025cf <insert_sorted_allocList+0x42>
  8025ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ae:	8b 50 08             	mov    0x8(%eax),%edx
  8025b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b4:	8b 40 08             	mov    0x8(%eax),%eax
  8025b7:	39 c2                	cmp    %eax,%edx
  8025b9:	76 14                	jbe    8025cf <insert_sorted_allocList+0x42>
  8025bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8025be:	8b 50 08             	mov    0x8(%eax),%edx
  8025c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025c4:	8b 40 08             	mov    0x8(%eax),%eax
  8025c7:	39 c2                	cmp    %eax,%edx
  8025c9:	0f 82 60 01 00 00    	jb     80272f <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8025cf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025d3:	75 65                	jne    80263a <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8025d5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025d9:	75 14                	jne    8025ef <insert_sorted_allocList+0x62>
  8025db:	83 ec 04             	sub    $0x4,%esp
  8025de:	68 0c 45 80 00       	push   $0x80450c
  8025e3:	6a 6b                	push   $0x6b
  8025e5:	68 2f 45 80 00       	push   $0x80452f
  8025ea:	e8 04 e3 ff ff       	call   8008f3 <_panic>
  8025ef:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8025f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f8:	89 10                	mov    %edx,(%eax)
  8025fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fd:	8b 00                	mov    (%eax),%eax
  8025ff:	85 c0                	test   %eax,%eax
  802601:	74 0d                	je     802610 <insert_sorted_allocList+0x83>
  802603:	a1 40 50 80 00       	mov    0x805040,%eax
  802608:	8b 55 08             	mov    0x8(%ebp),%edx
  80260b:	89 50 04             	mov    %edx,0x4(%eax)
  80260e:	eb 08                	jmp    802618 <insert_sorted_allocList+0x8b>
  802610:	8b 45 08             	mov    0x8(%ebp),%eax
  802613:	a3 44 50 80 00       	mov    %eax,0x805044
  802618:	8b 45 08             	mov    0x8(%ebp),%eax
  80261b:	a3 40 50 80 00       	mov    %eax,0x805040
  802620:	8b 45 08             	mov    0x8(%ebp),%eax
  802623:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80262a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80262f:	40                   	inc    %eax
  802630:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802635:	e9 dc 01 00 00       	jmp    802816 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80263a:	8b 45 08             	mov    0x8(%ebp),%eax
  80263d:	8b 50 08             	mov    0x8(%eax),%edx
  802640:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802643:	8b 40 08             	mov    0x8(%eax),%eax
  802646:	39 c2                	cmp    %eax,%edx
  802648:	77 6c                	ja     8026b6 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80264a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80264e:	74 06                	je     802656 <insert_sorted_allocList+0xc9>
  802650:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802654:	75 14                	jne    80266a <insert_sorted_allocList+0xdd>
  802656:	83 ec 04             	sub    $0x4,%esp
  802659:	68 48 45 80 00       	push   $0x804548
  80265e:	6a 6f                	push   $0x6f
  802660:	68 2f 45 80 00       	push   $0x80452f
  802665:	e8 89 e2 ff ff       	call   8008f3 <_panic>
  80266a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80266d:	8b 50 04             	mov    0x4(%eax),%edx
  802670:	8b 45 08             	mov    0x8(%ebp),%eax
  802673:	89 50 04             	mov    %edx,0x4(%eax)
  802676:	8b 45 08             	mov    0x8(%ebp),%eax
  802679:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80267c:	89 10                	mov    %edx,(%eax)
  80267e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802681:	8b 40 04             	mov    0x4(%eax),%eax
  802684:	85 c0                	test   %eax,%eax
  802686:	74 0d                	je     802695 <insert_sorted_allocList+0x108>
  802688:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80268b:	8b 40 04             	mov    0x4(%eax),%eax
  80268e:	8b 55 08             	mov    0x8(%ebp),%edx
  802691:	89 10                	mov    %edx,(%eax)
  802693:	eb 08                	jmp    80269d <insert_sorted_allocList+0x110>
  802695:	8b 45 08             	mov    0x8(%ebp),%eax
  802698:	a3 40 50 80 00       	mov    %eax,0x805040
  80269d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8026a3:	89 50 04             	mov    %edx,0x4(%eax)
  8026a6:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8026ab:	40                   	inc    %eax
  8026ac:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8026b1:	e9 60 01 00 00       	jmp    802816 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8026b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b9:	8b 50 08             	mov    0x8(%eax),%edx
  8026bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026bf:	8b 40 08             	mov    0x8(%eax),%eax
  8026c2:	39 c2                	cmp    %eax,%edx
  8026c4:	0f 82 4c 01 00 00    	jb     802816 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8026ca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026ce:	75 14                	jne    8026e4 <insert_sorted_allocList+0x157>
  8026d0:	83 ec 04             	sub    $0x4,%esp
  8026d3:	68 80 45 80 00       	push   $0x804580
  8026d8:	6a 73                	push   $0x73
  8026da:	68 2f 45 80 00       	push   $0x80452f
  8026df:	e8 0f e2 ff ff       	call   8008f3 <_panic>
  8026e4:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8026ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ed:	89 50 04             	mov    %edx,0x4(%eax)
  8026f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f3:	8b 40 04             	mov    0x4(%eax),%eax
  8026f6:	85 c0                	test   %eax,%eax
  8026f8:	74 0c                	je     802706 <insert_sorted_allocList+0x179>
  8026fa:	a1 44 50 80 00       	mov    0x805044,%eax
  8026ff:	8b 55 08             	mov    0x8(%ebp),%edx
  802702:	89 10                	mov    %edx,(%eax)
  802704:	eb 08                	jmp    80270e <insert_sorted_allocList+0x181>
  802706:	8b 45 08             	mov    0x8(%ebp),%eax
  802709:	a3 40 50 80 00       	mov    %eax,0x805040
  80270e:	8b 45 08             	mov    0x8(%ebp),%eax
  802711:	a3 44 50 80 00       	mov    %eax,0x805044
  802716:	8b 45 08             	mov    0x8(%ebp),%eax
  802719:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80271f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802724:	40                   	inc    %eax
  802725:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80272a:	e9 e7 00 00 00       	jmp    802816 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80272f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802732:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802735:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80273c:	a1 40 50 80 00       	mov    0x805040,%eax
  802741:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802744:	e9 9d 00 00 00       	jmp    8027e6 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802749:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274c:	8b 00                	mov    (%eax),%eax
  80274e:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802751:	8b 45 08             	mov    0x8(%ebp),%eax
  802754:	8b 50 08             	mov    0x8(%eax),%edx
  802757:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275a:	8b 40 08             	mov    0x8(%eax),%eax
  80275d:	39 c2                	cmp    %eax,%edx
  80275f:	76 7d                	jbe    8027de <insert_sorted_allocList+0x251>
  802761:	8b 45 08             	mov    0x8(%ebp),%eax
  802764:	8b 50 08             	mov    0x8(%eax),%edx
  802767:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80276a:	8b 40 08             	mov    0x8(%eax),%eax
  80276d:	39 c2                	cmp    %eax,%edx
  80276f:	73 6d                	jae    8027de <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802771:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802775:	74 06                	je     80277d <insert_sorted_allocList+0x1f0>
  802777:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80277b:	75 14                	jne    802791 <insert_sorted_allocList+0x204>
  80277d:	83 ec 04             	sub    $0x4,%esp
  802780:	68 a4 45 80 00       	push   $0x8045a4
  802785:	6a 7f                	push   $0x7f
  802787:	68 2f 45 80 00       	push   $0x80452f
  80278c:	e8 62 e1 ff ff       	call   8008f3 <_panic>
  802791:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802794:	8b 10                	mov    (%eax),%edx
  802796:	8b 45 08             	mov    0x8(%ebp),%eax
  802799:	89 10                	mov    %edx,(%eax)
  80279b:	8b 45 08             	mov    0x8(%ebp),%eax
  80279e:	8b 00                	mov    (%eax),%eax
  8027a0:	85 c0                	test   %eax,%eax
  8027a2:	74 0b                	je     8027af <insert_sorted_allocList+0x222>
  8027a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a7:	8b 00                	mov    (%eax),%eax
  8027a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8027ac:	89 50 04             	mov    %edx,0x4(%eax)
  8027af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8027b5:	89 10                	mov    %edx,(%eax)
  8027b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027bd:	89 50 04             	mov    %edx,0x4(%eax)
  8027c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c3:	8b 00                	mov    (%eax),%eax
  8027c5:	85 c0                	test   %eax,%eax
  8027c7:	75 08                	jne    8027d1 <insert_sorted_allocList+0x244>
  8027c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027cc:	a3 44 50 80 00       	mov    %eax,0x805044
  8027d1:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8027d6:	40                   	inc    %eax
  8027d7:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8027dc:	eb 39                	jmp    802817 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8027de:	a1 48 50 80 00       	mov    0x805048,%eax
  8027e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ea:	74 07                	je     8027f3 <insert_sorted_allocList+0x266>
  8027ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ef:	8b 00                	mov    (%eax),%eax
  8027f1:	eb 05                	jmp    8027f8 <insert_sorted_allocList+0x26b>
  8027f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8027f8:	a3 48 50 80 00       	mov    %eax,0x805048
  8027fd:	a1 48 50 80 00       	mov    0x805048,%eax
  802802:	85 c0                	test   %eax,%eax
  802804:	0f 85 3f ff ff ff    	jne    802749 <insert_sorted_allocList+0x1bc>
  80280a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80280e:	0f 85 35 ff ff ff    	jne    802749 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802814:	eb 01                	jmp    802817 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802816:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802817:	90                   	nop
  802818:	c9                   	leave  
  802819:	c3                   	ret    

0080281a <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80281a:	55                   	push   %ebp
  80281b:	89 e5                	mov    %esp,%ebp
  80281d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802820:	a1 38 51 80 00       	mov    0x805138,%eax
  802825:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802828:	e9 85 01 00 00       	jmp    8029b2 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  80282d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802830:	8b 40 0c             	mov    0xc(%eax),%eax
  802833:	3b 45 08             	cmp    0x8(%ebp),%eax
  802836:	0f 82 6e 01 00 00    	jb     8029aa <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80283c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283f:	8b 40 0c             	mov    0xc(%eax),%eax
  802842:	3b 45 08             	cmp    0x8(%ebp),%eax
  802845:	0f 85 8a 00 00 00    	jne    8028d5 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80284b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80284f:	75 17                	jne    802868 <alloc_block_FF+0x4e>
  802851:	83 ec 04             	sub    $0x4,%esp
  802854:	68 d8 45 80 00       	push   $0x8045d8
  802859:	68 93 00 00 00       	push   $0x93
  80285e:	68 2f 45 80 00       	push   $0x80452f
  802863:	e8 8b e0 ff ff       	call   8008f3 <_panic>
  802868:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286b:	8b 00                	mov    (%eax),%eax
  80286d:	85 c0                	test   %eax,%eax
  80286f:	74 10                	je     802881 <alloc_block_FF+0x67>
  802871:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802874:	8b 00                	mov    (%eax),%eax
  802876:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802879:	8b 52 04             	mov    0x4(%edx),%edx
  80287c:	89 50 04             	mov    %edx,0x4(%eax)
  80287f:	eb 0b                	jmp    80288c <alloc_block_FF+0x72>
  802881:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802884:	8b 40 04             	mov    0x4(%eax),%eax
  802887:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80288c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288f:	8b 40 04             	mov    0x4(%eax),%eax
  802892:	85 c0                	test   %eax,%eax
  802894:	74 0f                	je     8028a5 <alloc_block_FF+0x8b>
  802896:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802899:	8b 40 04             	mov    0x4(%eax),%eax
  80289c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80289f:	8b 12                	mov    (%edx),%edx
  8028a1:	89 10                	mov    %edx,(%eax)
  8028a3:	eb 0a                	jmp    8028af <alloc_block_FF+0x95>
  8028a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a8:	8b 00                	mov    (%eax),%eax
  8028aa:	a3 38 51 80 00       	mov    %eax,0x805138
  8028af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028c2:	a1 44 51 80 00       	mov    0x805144,%eax
  8028c7:	48                   	dec    %eax
  8028c8:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8028cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d0:	e9 10 01 00 00       	jmp    8029e5 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8028d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8028db:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028de:	0f 86 c6 00 00 00    	jbe    8029aa <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8028e4:	a1 48 51 80 00       	mov    0x805148,%eax
  8028e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8028ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ef:	8b 50 08             	mov    0x8(%eax),%edx
  8028f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f5:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8028f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8028fe:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802901:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802905:	75 17                	jne    80291e <alloc_block_FF+0x104>
  802907:	83 ec 04             	sub    $0x4,%esp
  80290a:	68 d8 45 80 00       	push   $0x8045d8
  80290f:	68 9b 00 00 00       	push   $0x9b
  802914:	68 2f 45 80 00       	push   $0x80452f
  802919:	e8 d5 df ff ff       	call   8008f3 <_panic>
  80291e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802921:	8b 00                	mov    (%eax),%eax
  802923:	85 c0                	test   %eax,%eax
  802925:	74 10                	je     802937 <alloc_block_FF+0x11d>
  802927:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80292a:	8b 00                	mov    (%eax),%eax
  80292c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80292f:	8b 52 04             	mov    0x4(%edx),%edx
  802932:	89 50 04             	mov    %edx,0x4(%eax)
  802935:	eb 0b                	jmp    802942 <alloc_block_FF+0x128>
  802937:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293a:	8b 40 04             	mov    0x4(%eax),%eax
  80293d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802942:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802945:	8b 40 04             	mov    0x4(%eax),%eax
  802948:	85 c0                	test   %eax,%eax
  80294a:	74 0f                	je     80295b <alloc_block_FF+0x141>
  80294c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80294f:	8b 40 04             	mov    0x4(%eax),%eax
  802952:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802955:	8b 12                	mov    (%edx),%edx
  802957:	89 10                	mov    %edx,(%eax)
  802959:	eb 0a                	jmp    802965 <alloc_block_FF+0x14b>
  80295b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80295e:	8b 00                	mov    (%eax),%eax
  802960:	a3 48 51 80 00       	mov    %eax,0x805148
  802965:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802968:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80296e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802971:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802978:	a1 54 51 80 00       	mov    0x805154,%eax
  80297d:	48                   	dec    %eax
  80297e:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802983:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802986:	8b 50 08             	mov    0x8(%eax),%edx
  802989:	8b 45 08             	mov    0x8(%ebp),%eax
  80298c:	01 c2                	add    %eax,%edx
  80298e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802991:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802994:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802997:	8b 40 0c             	mov    0xc(%eax),%eax
  80299a:	2b 45 08             	sub    0x8(%ebp),%eax
  80299d:	89 c2                	mov    %eax,%edx
  80299f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a2:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8029a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a8:	eb 3b                	jmp    8029e5 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8029aa:	a1 40 51 80 00       	mov    0x805140,%eax
  8029af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029b6:	74 07                	je     8029bf <alloc_block_FF+0x1a5>
  8029b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bb:	8b 00                	mov    (%eax),%eax
  8029bd:	eb 05                	jmp    8029c4 <alloc_block_FF+0x1aa>
  8029bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8029c4:	a3 40 51 80 00       	mov    %eax,0x805140
  8029c9:	a1 40 51 80 00       	mov    0x805140,%eax
  8029ce:	85 c0                	test   %eax,%eax
  8029d0:	0f 85 57 fe ff ff    	jne    80282d <alloc_block_FF+0x13>
  8029d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029da:	0f 85 4d fe ff ff    	jne    80282d <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8029e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029e5:	c9                   	leave  
  8029e6:	c3                   	ret    

008029e7 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8029e7:	55                   	push   %ebp
  8029e8:	89 e5                	mov    %esp,%ebp
  8029ea:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8029ed:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8029f4:	a1 38 51 80 00       	mov    0x805138,%eax
  8029f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029fc:	e9 df 00 00 00       	jmp    802ae0 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a04:	8b 40 0c             	mov    0xc(%eax),%eax
  802a07:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a0a:	0f 82 c8 00 00 00    	jb     802ad8 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a13:	8b 40 0c             	mov    0xc(%eax),%eax
  802a16:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a19:	0f 85 8a 00 00 00    	jne    802aa9 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802a1f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a23:	75 17                	jne    802a3c <alloc_block_BF+0x55>
  802a25:	83 ec 04             	sub    $0x4,%esp
  802a28:	68 d8 45 80 00       	push   $0x8045d8
  802a2d:	68 b7 00 00 00       	push   $0xb7
  802a32:	68 2f 45 80 00       	push   $0x80452f
  802a37:	e8 b7 de ff ff       	call   8008f3 <_panic>
  802a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3f:	8b 00                	mov    (%eax),%eax
  802a41:	85 c0                	test   %eax,%eax
  802a43:	74 10                	je     802a55 <alloc_block_BF+0x6e>
  802a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a48:	8b 00                	mov    (%eax),%eax
  802a4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a4d:	8b 52 04             	mov    0x4(%edx),%edx
  802a50:	89 50 04             	mov    %edx,0x4(%eax)
  802a53:	eb 0b                	jmp    802a60 <alloc_block_BF+0x79>
  802a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a58:	8b 40 04             	mov    0x4(%eax),%eax
  802a5b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a63:	8b 40 04             	mov    0x4(%eax),%eax
  802a66:	85 c0                	test   %eax,%eax
  802a68:	74 0f                	je     802a79 <alloc_block_BF+0x92>
  802a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6d:	8b 40 04             	mov    0x4(%eax),%eax
  802a70:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a73:	8b 12                	mov    (%edx),%edx
  802a75:	89 10                	mov    %edx,(%eax)
  802a77:	eb 0a                	jmp    802a83 <alloc_block_BF+0x9c>
  802a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7c:	8b 00                	mov    (%eax),%eax
  802a7e:	a3 38 51 80 00       	mov    %eax,0x805138
  802a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a86:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a96:	a1 44 51 80 00       	mov    0x805144,%eax
  802a9b:	48                   	dec    %eax
  802a9c:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802aa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa4:	e9 4d 01 00 00       	jmp    802bf6 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802aa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aac:	8b 40 0c             	mov    0xc(%eax),%eax
  802aaf:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ab2:	76 24                	jbe    802ad8 <alloc_block_BF+0xf1>
  802ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab7:	8b 40 0c             	mov    0xc(%eax),%eax
  802aba:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802abd:	73 19                	jae    802ad8 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802abf:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac9:	8b 40 0c             	mov    0xc(%eax),%eax
  802acc:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad2:	8b 40 08             	mov    0x8(%eax),%eax
  802ad5:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802ad8:	a1 40 51 80 00       	mov    0x805140,%eax
  802add:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ae0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ae4:	74 07                	je     802aed <alloc_block_BF+0x106>
  802ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae9:	8b 00                	mov    (%eax),%eax
  802aeb:	eb 05                	jmp    802af2 <alloc_block_BF+0x10b>
  802aed:	b8 00 00 00 00       	mov    $0x0,%eax
  802af2:	a3 40 51 80 00       	mov    %eax,0x805140
  802af7:	a1 40 51 80 00       	mov    0x805140,%eax
  802afc:	85 c0                	test   %eax,%eax
  802afe:	0f 85 fd fe ff ff    	jne    802a01 <alloc_block_BF+0x1a>
  802b04:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b08:	0f 85 f3 fe ff ff    	jne    802a01 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802b0e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b12:	0f 84 d9 00 00 00    	je     802bf1 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b18:	a1 48 51 80 00       	mov    0x805148,%eax
  802b1d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802b20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b23:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b26:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802b29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b2c:	8b 55 08             	mov    0x8(%ebp),%edx
  802b2f:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802b32:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802b36:	75 17                	jne    802b4f <alloc_block_BF+0x168>
  802b38:	83 ec 04             	sub    $0x4,%esp
  802b3b:	68 d8 45 80 00       	push   $0x8045d8
  802b40:	68 c7 00 00 00       	push   $0xc7
  802b45:	68 2f 45 80 00       	push   $0x80452f
  802b4a:	e8 a4 dd ff ff       	call   8008f3 <_panic>
  802b4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b52:	8b 00                	mov    (%eax),%eax
  802b54:	85 c0                	test   %eax,%eax
  802b56:	74 10                	je     802b68 <alloc_block_BF+0x181>
  802b58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b5b:	8b 00                	mov    (%eax),%eax
  802b5d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b60:	8b 52 04             	mov    0x4(%edx),%edx
  802b63:	89 50 04             	mov    %edx,0x4(%eax)
  802b66:	eb 0b                	jmp    802b73 <alloc_block_BF+0x18c>
  802b68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b6b:	8b 40 04             	mov    0x4(%eax),%eax
  802b6e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b76:	8b 40 04             	mov    0x4(%eax),%eax
  802b79:	85 c0                	test   %eax,%eax
  802b7b:	74 0f                	je     802b8c <alloc_block_BF+0x1a5>
  802b7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b80:	8b 40 04             	mov    0x4(%eax),%eax
  802b83:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b86:	8b 12                	mov    (%edx),%edx
  802b88:	89 10                	mov    %edx,(%eax)
  802b8a:	eb 0a                	jmp    802b96 <alloc_block_BF+0x1af>
  802b8c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b8f:	8b 00                	mov    (%eax),%eax
  802b91:	a3 48 51 80 00       	mov    %eax,0x805148
  802b96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b99:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b9f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ba2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ba9:	a1 54 51 80 00       	mov    0x805154,%eax
  802bae:	48                   	dec    %eax
  802baf:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802bb4:	83 ec 08             	sub    $0x8,%esp
  802bb7:	ff 75 ec             	pushl  -0x14(%ebp)
  802bba:	68 38 51 80 00       	push   $0x805138
  802bbf:	e8 71 f9 ff ff       	call   802535 <find_block>
  802bc4:	83 c4 10             	add    $0x10,%esp
  802bc7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802bca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bcd:	8b 50 08             	mov    0x8(%eax),%edx
  802bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd3:	01 c2                	add    %eax,%edx
  802bd5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bd8:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802bdb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bde:	8b 40 0c             	mov    0xc(%eax),%eax
  802be1:	2b 45 08             	sub    0x8(%ebp),%eax
  802be4:	89 c2                	mov    %eax,%edx
  802be6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802be9:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802bec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bef:	eb 05                	jmp    802bf6 <alloc_block_BF+0x20f>
	}
	return NULL;
  802bf1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bf6:	c9                   	leave  
  802bf7:	c3                   	ret    

00802bf8 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802bf8:	55                   	push   %ebp
  802bf9:	89 e5                	mov    %esp,%ebp
  802bfb:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802bfe:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802c03:	85 c0                	test   %eax,%eax
  802c05:	0f 85 de 01 00 00    	jne    802de9 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802c0b:	a1 38 51 80 00       	mov    0x805138,%eax
  802c10:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c13:	e9 9e 01 00 00       	jmp    802db6 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802c18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1b:	8b 40 0c             	mov    0xc(%eax),%eax
  802c1e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c21:	0f 82 87 01 00 00    	jb     802dae <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802c27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2a:	8b 40 0c             	mov    0xc(%eax),%eax
  802c2d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c30:	0f 85 95 00 00 00    	jne    802ccb <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802c36:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c3a:	75 17                	jne    802c53 <alloc_block_NF+0x5b>
  802c3c:	83 ec 04             	sub    $0x4,%esp
  802c3f:	68 d8 45 80 00       	push   $0x8045d8
  802c44:	68 e0 00 00 00       	push   $0xe0
  802c49:	68 2f 45 80 00       	push   $0x80452f
  802c4e:	e8 a0 dc ff ff       	call   8008f3 <_panic>
  802c53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c56:	8b 00                	mov    (%eax),%eax
  802c58:	85 c0                	test   %eax,%eax
  802c5a:	74 10                	je     802c6c <alloc_block_NF+0x74>
  802c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5f:	8b 00                	mov    (%eax),%eax
  802c61:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c64:	8b 52 04             	mov    0x4(%edx),%edx
  802c67:	89 50 04             	mov    %edx,0x4(%eax)
  802c6a:	eb 0b                	jmp    802c77 <alloc_block_NF+0x7f>
  802c6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6f:	8b 40 04             	mov    0x4(%eax),%eax
  802c72:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7a:	8b 40 04             	mov    0x4(%eax),%eax
  802c7d:	85 c0                	test   %eax,%eax
  802c7f:	74 0f                	je     802c90 <alloc_block_NF+0x98>
  802c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c84:	8b 40 04             	mov    0x4(%eax),%eax
  802c87:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c8a:	8b 12                	mov    (%edx),%edx
  802c8c:	89 10                	mov    %edx,(%eax)
  802c8e:	eb 0a                	jmp    802c9a <alloc_block_NF+0xa2>
  802c90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c93:	8b 00                	mov    (%eax),%eax
  802c95:	a3 38 51 80 00       	mov    %eax,0x805138
  802c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ca3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cad:	a1 44 51 80 00       	mov    0x805144,%eax
  802cb2:	48                   	dec    %eax
  802cb3:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbb:	8b 40 08             	mov    0x8(%eax),%eax
  802cbe:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   return  point;
  802cc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc6:	e9 f8 04 00 00       	jmp    8031c3 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802ccb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cce:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd1:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cd4:	0f 86 d4 00 00 00    	jbe    802dae <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802cda:	a1 48 51 80 00       	mov    0x805148,%eax
  802cdf:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce5:	8b 50 08             	mov    0x8(%eax),%edx
  802ce8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ceb:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802cee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf1:	8b 55 08             	mov    0x8(%ebp),%edx
  802cf4:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802cf7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cfb:	75 17                	jne    802d14 <alloc_block_NF+0x11c>
  802cfd:	83 ec 04             	sub    $0x4,%esp
  802d00:	68 d8 45 80 00       	push   $0x8045d8
  802d05:	68 e9 00 00 00       	push   $0xe9
  802d0a:	68 2f 45 80 00       	push   $0x80452f
  802d0f:	e8 df db ff ff       	call   8008f3 <_panic>
  802d14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d17:	8b 00                	mov    (%eax),%eax
  802d19:	85 c0                	test   %eax,%eax
  802d1b:	74 10                	je     802d2d <alloc_block_NF+0x135>
  802d1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d20:	8b 00                	mov    (%eax),%eax
  802d22:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d25:	8b 52 04             	mov    0x4(%edx),%edx
  802d28:	89 50 04             	mov    %edx,0x4(%eax)
  802d2b:	eb 0b                	jmp    802d38 <alloc_block_NF+0x140>
  802d2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d30:	8b 40 04             	mov    0x4(%eax),%eax
  802d33:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d3b:	8b 40 04             	mov    0x4(%eax),%eax
  802d3e:	85 c0                	test   %eax,%eax
  802d40:	74 0f                	je     802d51 <alloc_block_NF+0x159>
  802d42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d45:	8b 40 04             	mov    0x4(%eax),%eax
  802d48:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d4b:	8b 12                	mov    (%edx),%edx
  802d4d:	89 10                	mov    %edx,(%eax)
  802d4f:	eb 0a                	jmp    802d5b <alloc_block_NF+0x163>
  802d51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d54:	8b 00                	mov    (%eax),%eax
  802d56:	a3 48 51 80 00       	mov    %eax,0x805148
  802d5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d5e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d67:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d6e:	a1 54 51 80 00       	mov    0x805154,%eax
  802d73:	48                   	dec    %eax
  802d74:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802d79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d7c:	8b 40 08             	mov    0x8(%eax),%eax
  802d7f:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   point->sva += size;
  802d84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d87:	8b 50 08             	mov    0x8(%eax),%edx
  802d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8d:	01 c2                	add    %eax,%edx
  802d8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d92:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d98:	8b 40 0c             	mov    0xc(%eax),%eax
  802d9b:	2b 45 08             	sub    0x8(%ebp),%eax
  802d9e:	89 c2                	mov    %eax,%edx
  802da0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da3:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802da6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da9:	e9 15 04 00 00       	jmp    8031c3 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802dae:	a1 40 51 80 00       	mov    0x805140,%eax
  802db3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802db6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dba:	74 07                	je     802dc3 <alloc_block_NF+0x1cb>
  802dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbf:	8b 00                	mov    (%eax),%eax
  802dc1:	eb 05                	jmp    802dc8 <alloc_block_NF+0x1d0>
  802dc3:	b8 00 00 00 00       	mov    $0x0,%eax
  802dc8:	a3 40 51 80 00       	mov    %eax,0x805140
  802dcd:	a1 40 51 80 00       	mov    0x805140,%eax
  802dd2:	85 c0                	test   %eax,%eax
  802dd4:	0f 85 3e fe ff ff    	jne    802c18 <alloc_block_NF+0x20>
  802dda:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dde:	0f 85 34 fe ff ff    	jne    802c18 <alloc_block_NF+0x20>
  802de4:	e9 d5 03 00 00       	jmp    8031be <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802de9:	a1 38 51 80 00       	mov    0x805138,%eax
  802dee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802df1:	e9 b1 01 00 00       	jmp    802fa7 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802df6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df9:	8b 50 08             	mov    0x8(%eax),%edx
  802dfc:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e01:	39 c2                	cmp    %eax,%edx
  802e03:	0f 82 96 01 00 00    	jb     802f9f <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802e09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e0f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e12:	0f 82 87 01 00 00    	jb     802f9f <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802e18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e1e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e21:	0f 85 95 00 00 00    	jne    802ebc <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802e27:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e2b:	75 17                	jne    802e44 <alloc_block_NF+0x24c>
  802e2d:	83 ec 04             	sub    $0x4,%esp
  802e30:	68 d8 45 80 00       	push   $0x8045d8
  802e35:	68 fc 00 00 00       	push   $0xfc
  802e3a:	68 2f 45 80 00       	push   $0x80452f
  802e3f:	e8 af da ff ff       	call   8008f3 <_panic>
  802e44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e47:	8b 00                	mov    (%eax),%eax
  802e49:	85 c0                	test   %eax,%eax
  802e4b:	74 10                	je     802e5d <alloc_block_NF+0x265>
  802e4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e50:	8b 00                	mov    (%eax),%eax
  802e52:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e55:	8b 52 04             	mov    0x4(%edx),%edx
  802e58:	89 50 04             	mov    %edx,0x4(%eax)
  802e5b:	eb 0b                	jmp    802e68 <alloc_block_NF+0x270>
  802e5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e60:	8b 40 04             	mov    0x4(%eax),%eax
  802e63:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6b:	8b 40 04             	mov    0x4(%eax),%eax
  802e6e:	85 c0                	test   %eax,%eax
  802e70:	74 0f                	je     802e81 <alloc_block_NF+0x289>
  802e72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e75:	8b 40 04             	mov    0x4(%eax),%eax
  802e78:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e7b:	8b 12                	mov    (%edx),%edx
  802e7d:	89 10                	mov    %edx,(%eax)
  802e7f:	eb 0a                	jmp    802e8b <alloc_block_NF+0x293>
  802e81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e84:	8b 00                	mov    (%eax),%eax
  802e86:	a3 38 51 80 00       	mov    %eax,0x805138
  802e8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e97:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e9e:	a1 44 51 80 00       	mov    0x805144,%eax
  802ea3:	48                   	dec    %eax
  802ea4:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802ea9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eac:	8b 40 08             	mov    0x8(%eax),%eax
  802eaf:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  802eb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb7:	e9 07 03 00 00       	jmp    8031c3 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802ebc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebf:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec2:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ec5:	0f 86 d4 00 00 00    	jbe    802f9f <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802ecb:	a1 48 51 80 00       	mov    0x805148,%eax
  802ed0:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed6:	8b 50 08             	mov    0x8(%eax),%edx
  802ed9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802edc:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802edf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ee2:	8b 55 08             	mov    0x8(%ebp),%edx
  802ee5:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802ee8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802eec:	75 17                	jne    802f05 <alloc_block_NF+0x30d>
  802eee:	83 ec 04             	sub    $0x4,%esp
  802ef1:	68 d8 45 80 00       	push   $0x8045d8
  802ef6:	68 04 01 00 00       	push   $0x104
  802efb:	68 2f 45 80 00       	push   $0x80452f
  802f00:	e8 ee d9 ff ff       	call   8008f3 <_panic>
  802f05:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f08:	8b 00                	mov    (%eax),%eax
  802f0a:	85 c0                	test   %eax,%eax
  802f0c:	74 10                	je     802f1e <alloc_block_NF+0x326>
  802f0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f11:	8b 00                	mov    (%eax),%eax
  802f13:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f16:	8b 52 04             	mov    0x4(%edx),%edx
  802f19:	89 50 04             	mov    %edx,0x4(%eax)
  802f1c:	eb 0b                	jmp    802f29 <alloc_block_NF+0x331>
  802f1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f21:	8b 40 04             	mov    0x4(%eax),%eax
  802f24:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f29:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f2c:	8b 40 04             	mov    0x4(%eax),%eax
  802f2f:	85 c0                	test   %eax,%eax
  802f31:	74 0f                	je     802f42 <alloc_block_NF+0x34a>
  802f33:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f36:	8b 40 04             	mov    0x4(%eax),%eax
  802f39:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f3c:	8b 12                	mov    (%edx),%edx
  802f3e:	89 10                	mov    %edx,(%eax)
  802f40:	eb 0a                	jmp    802f4c <alloc_block_NF+0x354>
  802f42:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f45:	8b 00                	mov    (%eax),%eax
  802f47:	a3 48 51 80 00       	mov    %eax,0x805148
  802f4c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f4f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f55:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f58:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f5f:	a1 54 51 80 00       	mov    0x805154,%eax
  802f64:	48                   	dec    %eax
  802f65:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802f6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f6d:	8b 40 08             	mov    0x8(%eax),%eax
  802f70:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  802f75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f78:	8b 50 08             	mov    0x8(%eax),%edx
  802f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7e:	01 c2                	add    %eax,%edx
  802f80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f83:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802f86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f89:	8b 40 0c             	mov    0xc(%eax),%eax
  802f8c:	2b 45 08             	sub    0x8(%ebp),%eax
  802f8f:	89 c2                	mov    %eax,%edx
  802f91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f94:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802f97:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f9a:	e9 24 02 00 00       	jmp    8031c3 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802f9f:	a1 40 51 80 00       	mov    0x805140,%eax
  802fa4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fa7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fab:	74 07                	je     802fb4 <alloc_block_NF+0x3bc>
  802fad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb0:	8b 00                	mov    (%eax),%eax
  802fb2:	eb 05                	jmp    802fb9 <alloc_block_NF+0x3c1>
  802fb4:	b8 00 00 00 00       	mov    $0x0,%eax
  802fb9:	a3 40 51 80 00       	mov    %eax,0x805140
  802fbe:	a1 40 51 80 00       	mov    0x805140,%eax
  802fc3:	85 c0                	test   %eax,%eax
  802fc5:	0f 85 2b fe ff ff    	jne    802df6 <alloc_block_NF+0x1fe>
  802fcb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fcf:	0f 85 21 fe ff ff    	jne    802df6 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802fd5:	a1 38 51 80 00       	mov    0x805138,%eax
  802fda:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fdd:	e9 ae 01 00 00       	jmp    803190 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802fe2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe5:	8b 50 08             	mov    0x8(%eax),%edx
  802fe8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802fed:	39 c2                	cmp    %eax,%edx
  802fef:	0f 83 93 01 00 00    	jae    803188 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802ff5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff8:	8b 40 0c             	mov    0xc(%eax),%eax
  802ffb:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ffe:	0f 82 84 01 00 00    	jb     803188 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  803004:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803007:	8b 40 0c             	mov    0xc(%eax),%eax
  80300a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80300d:	0f 85 95 00 00 00    	jne    8030a8 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803013:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803017:	75 17                	jne    803030 <alloc_block_NF+0x438>
  803019:	83 ec 04             	sub    $0x4,%esp
  80301c:	68 d8 45 80 00       	push   $0x8045d8
  803021:	68 14 01 00 00       	push   $0x114
  803026:	68 2f 45 80 00       	push   $0x80452f
  80302b:	e8 c3 d8 ff ff       	call   8008f3 <_panic>
  803030:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803033:	8b 00                	mov    (%eax),%eax
  803035:	85 c0                	test   %eax,%eax
  803037:	74 10                	je     803049 <alloc_block_NF+0x451>
  803039:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303c:	8b 00                	mov    (%eax),%eax
  80303e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803041:	8b 52 04             	mov    0x4(%edx),%edx
  803044:	89 50 04             	mov    %edx,0x4(%eax)
  803047:	eb 0b                	jmp    803054 <alloc_block_NF+0x45c>
  803049:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304c:	8b 40 04             	mov    0x4(%eax),%eax
  80304f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803054:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803057:	8b 40 04             	mov    0x4(%eax),%eax
  80305a:	85 c0                	test   %eax,%eax
  80305c:	74 0f                	je     80306d <alloc_block_NF+0x475>
  80305e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803061:	8b 40 04             	mov    0x4(%eax),%eax
  803064:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803067:	8b 12                	mov    (%edx),%edx
  803069:	89 10                	mov    %edx,(%eax)
  80306b:	eb 0a                	jmp    803077 <alloc_block_NF+0x47f>
  80306d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803070:	8b 00                	mov    (%eax),%eax
  803072:	a3 38 51 80 00       	mov    %eax,0x805138
  803077:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803080:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803083:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80308a:	a1 44 51 80 00       	mov    0x805144,%eax
  80308f:	48                   	dec    %eax
  803090:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803095:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803098:	8b 40 08             	mov    0x8(%eax),%eax
  80309b:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  8030a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a3:	e9 1b 01 00 00       	jmp    8031c3 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8030a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8030ae:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030b1:	0f 86 d1 00 00 00    	jbe    803188 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8030b7:	a1 48 51 80 00       	mov    0x805148,%eax
  8030bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  8030bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c2:	8b 50 08             	mov    0x8(%eax),%edx
  8030c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030c8:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8030cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8030d1:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8030d4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8030d8:	75 17                	jne    8030f1 <alloc_block_NF+0x4f9>
  8030da:	83 ec 04             	sub    $0x4,%esp
  8030dd:	68 d8 45 80 00       	push   $0x8045d8
  8030e2:	68 1c 01 00 00       	push   $0x11c
  8030e7:	68 2f 45 80 00       	push   $0x80452f
  8030ec:	e8 02 d8 ff ff       	call   8008f3 <_panic>
  8030f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030f4:	8b 00                	mov    (%eax),%eax
  8030f6:	85 c0                	test   %eax,%eax
  8030f8:	74 10                	je     80310a <alloc_block_NF+0x512>
  8030fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030fd:	8b 00                	mov    (%eax),%eax
  8030ff:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803102:	8b 52 04             	mov    0x4(%edx),%edx
  803105:	89 50 04             	mov    %edx,0x4(%eax)
  803108:	eb 0b                	jmp    803115 <alloc_block_NF+0x51d>
  80310a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80310d:	8b 40 04             	mov    0x4(%eax),%eax
  803110:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803115:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803118:	8b 40 04             	mov    0x4(%eax),%eax
  80311b:	85 c0                	test   %eax,%eax
  80311d:	74 0f                	je     80312e <alloc_block_NF+0x536>
  80311f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803122:	8b 40 04             	mov    0x4(%eax),%eax
  803125:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803128:	8b 12                	mov    (%edx),%edx
  80312a:	89 10                	mov    %edx,(%eax)
  80312c:	eb 0a                	jmp    803138 <alloc_block_NF+0x540>
  80312e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803131:	8b 00                	mov    (%eax),%eax
  803133:	a3 48 51 80 00       	mov    %eax,0x805148
  803138:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80313b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803141:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803144:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80314b:	a1 54 51 80 00       	mov    0x805154,%eax
  803150:	48                   	dec    %eax
  803151:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803156:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803159:	8b 40 08             	mov    0x8(%eax),%eax
  80315c:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  803161:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803164:	8b 50 08             	mov    0x8(%eax),%edx
  803167:	8b 45 08             	mov    0x8(%ebp),%eax
  80316a:	01 c2                	add    %eax,%edx
  80316c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316f:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803172:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803175:	8b 40 0c             	mov    0xc(%eax),%eax
  803178:	2b 45 08             	sub    0x8(%ebp),%eax
  80317b:	89 c2                	mov    %eax,%edx
  80317d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803180:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803183:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803186:	eb 3b                	jmp    8031c3 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803188:	a1 40 51 80 00       	mov    0x805140,%eax
  80318d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803190:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803194:	74 07                	je     80319d <alloc_block_NF+0x5a5>
  803196:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803199:	8b 00                	mov    (%eax),%eax
  80319b:	eb 05                	jmp    8031a2 <alloc_block_NF+0x5aa>
  80319d:	b8 00 00 00 00       	mov    $0x0,%eax
  8031a2:	a3 40 51 80 00       	mov    %eax,0x805140
  8031a7:	a1 40 51 80 00       	mov    0x805140,%eax
  8031ac:	85 c0                	test   %eax,%eax
  8031ae:	0f 85 2e fe ff ff    	jne    802fe2 <alloc_block_NF+0x3ea>
  8031b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031b8:	0f 85 24 fe ff ff    	jne    802fe2 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  8031be:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031c3:	c9                   	leave  
  8031c4:	c3                   	ret    

008031c5 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8031c5:	55                   	push   %ebp
  8031c6:	89 e5                	mov    %esp,%ebp
  8031c8:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  8031cb:	a1 38 51 80 00       	mov    0x805138,%eax
  8031d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  8031d3:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8031d8:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  8031db:	a1 38 51 80 00       	mov    0x805138,%eax
  8031e0:	85 c0                	test   %eax,%eax
  8031e2:	74 14                	je     8031f8 <insert_sorted_with_merge_freeList+0x33>
  8031e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e7:	8b 50 08             	mov    0x8(%eax),%edx
  8031ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ed:	8b 40 08             	mov    0x8(%eax),%eax
  8031f0:	39 c2                	cmp    %eax,%edx
  8031f2:	0f 87 9b 01 00 00    	ja     803393 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  8031f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031fc:	75 17                	jne    803215 <insert_sorted_with_merge_freeList+0x50>
  8031fe:	83 ec 04             	sub    $0x4,%esp
  803201:	68 0c 45 80 00       	push   $0x80450c
  803206:	68 38 01 00 00       	push   $0x138
  80320b:	68 2f 45 80 00       	push   $0x80452f
  803210:	e8 de d6 ff ff       	call   8008f3 <_panic>
  803215:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80321b:	8b 45 08             	mov    0x8(%ebp),%eax
  80321e:	89 10                	mov    %edx,(%eax)
  803220:	8b 45 08             	mov    0x8(%ebp),%eax
  803223:	8b 00                	mov    (%eax),%eax
  803225:	85 c0                	test   %eax,%eax
  803227:	74 0d                	je     803236 <insert_sorted_with_merge_freeList+0x71>
  803229:	a1 38 51 80 00       	mov    0x805138,%eax
  80322e:	8b 55 08             	mov    0x8(%ebp),%edx
  803231:	89 50 04             	mov    %edx,0x4(%eax)
  803234:	eb 08                	jmp    80323e <insert_sorted_with_merge_freeList+0x79>
  803236:	8b 45 08             	mov    0x8(%ebp),%eax
  803239:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80323e:	8b 45 08             	mov    0x8(%ebp),%eax
  803241:	a3 38 51 80 00       	mov    %eax,0x805138
  803246:	8b 45 08             	mov    0x8(%ebp),%eax
  803249:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803250:	a1 44 51 80 00       	mov    0x805144,%eax
  803255:	40                   	inc    %eax
  803256:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80325b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80325f:	0f 84 a8 06 00 00    	je     80390d <insert_sorted_with_merge_freeList+0x748>
  803265:	8b 45 08             	mov    0x8(%ebp),%eax
  803268:	8b 50 08             	mov    0x8(%eax),%edx
  80326b:	8b 45 08             	mov    0x8(%ebp),%eax
  80326e:	8b 40 0c             	mov    0xc(%eax),%eax
  803271:	01 c2                	add    %eax,%edx
  803273:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803276:	8b 40 08             	mov    0x8(%eax),%eax
  803279:	39 c2                	cmp    %eax,%edx
  80327b:	0f 85 8c 06 00 00    	jne    80390d <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  803281:	8b 45 08             	mov    0x8(%ebp),%eax
  803284:	8b 50 0c             	mov    0xc(%eax),%edx
  803287:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80328a:	8b 40 0c             	mov    0xc(%eax),%eax
  80328d:	01 c2                	add    %eax,%edx
  80328f:	8b 45 08             	mov    0x8(%ebp),%eax
  803292:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803295:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803299:	75 17                	jne    8032b2 <insert_sorted_with_merge_freeList+0xed>
  80329b:	83 ec 04             	sub    $0x4,%esp
  80329e:	68 d8 45 80 00       	push   $0x8045d8
  8032a3:	68 3c 01 00 00       	push   $0x13c
  8032a8:	68 2f 45 80 00       	push   $0x80452f
  8032ad:	e8 41 d6 ff ff       	call   8008f3 <_panic>
  8032b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032b5:	8b 00                	mov    (%eax),%eax
  8032b7:	85 c0                	test   %eax,%eax
  8032b9:	74 10                	je     8032cb <insert_sorted_with_merge_freeList+0x106>
  8032bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032be:	8b 00                	mov    (%eax),%eax
  8032c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032c3:	8b 52 04             	mov    0x4(%edx),%edx
  8032c6:	89 50 04             	mov    %edx,0x4(%eax)
  8032c9:	eb 0b                	jmp    8032d6 <insert_sorted_with_merge_freeList+0x111>
  8032cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032ce:	8b 40 04             	mov    0x4(%eax),%eax
  8032d1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032d9:	8b 40 04             	mov    0x4(%eax),%eax
  8032dc:	85 c0                	test   %eax,%eax
  8032de:	74 0f                	je     8032ef <insert_sorted_with_merge_freeList+0x12a>
  8032e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032e3:	8b 40 04             	mov    0x4(%eax),%eax
  8032e6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032e9:	8b 12                	mov    (%edx),%edx
  8032eb:	89 10                	mov    %edx,(%eax)
  8032ed:	eb 0a                	jmp    8032f9 <insert_sorted_with_merge_freeList+0x134>
  8032ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032f2:	8b 00                	mov    (%eax),%eax
  8032f4:	a3 38 51 80 00       	mov    %eax,0x805138
  8032f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032fc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803302:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803305:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80330c:	a1 44 51 80 00       	mov    0x805144,%eax
  803311:	48                   	dec    %eax
  803312:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  803317:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80331a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803321:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803324:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  80332b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80332f:	75 17                	jne    803348 <insert_sorted_with_merge_freeList+0x183>
  803331:	83 ec 04             	sub    $0x4,%esp
  803334:	68 0c 45 80 00       	push   $0x80450c
  803339:	68 3f 01 00 00       	push   $0x13f
  80333e:	68 2f 45 80 00       	push   $0x80452f
  803343:	e8 ab d5 ff ff       	call   8008f3 <_panic>
  803348:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80334e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803351:	89 10                	mov    %edx,(%eax)
  803353:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803356:	8b 00                	mov    (%eax),%eax
  803358:	85 c0                	test   %eax,%eax
  80335a:	74 0d                	je     803369 <insert_sorted_with_merge_freeList+0x1a4>
  80335c:	a1 48 51 80 00       	mov    0x805148,%eax
  803361:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803364:	89 50 04             	mov    %edx,0x4(%eax)
  803367:	eb 08                	jmp    803371 <insert_sorted_with_merge_freeList+0x1ac>
  803369:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80336c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803371:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803374:	a3 48 51 80 00       	mov    %eax,0x805148
  803379:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80337c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803383:	a1 54 51 80 00       	mov    0x805154,%eax
  803388:	40                   	inc    %eax
  803389:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80338e:	e9 7a 05 00 00       	jmp    80390d <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803393:	8b 45 08             	mov    0x8(%ebp),%eax
  803396:	8b 50 08             	mov    0x8(%eax),%edx
  803399:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80339c:	8b 40 08             	mov    0x8(%eax),%eax
  80339f:	39 c2                	cmp    %eax,%edx
  8033a1:	0f 82 14 01 00 00    	jb     8034bb <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8033a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033aa:	8b 50 08             	mov    0x8(%eax),%edx
  8033ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8033b3:	01 c2                	add    %eax,%edx
  8033b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b8:	8b 40 08             	mov    0x8(%eax),%eax
  8033bb:	39 c2                	cmp    %eax,%edx
  8033bd:	0f 85 90 00 00 00    	jne    803453 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8033c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033c6:	8b 50 0c             	mov    0xc(%eax),%edx
  8033c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8033cf:	01 c2                	add    %eax,%edx
  8033d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033d4:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  8033d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033da:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8033e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8033eb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033ef:	75 17                	jne    803408 <insert_sorted_with_merge_freeList+0x243>
  8033f1:	83 ec 04             	sub    $0x4,%esp
  8033f4:	68 0c 45 80 00       	push   $0x80450c
  8033f9:	68 49 01 00 00       	push   $0x149
  8033fe:	68 2f 45 80 00       	push   $0x80452f
  803403:	e8 eb d4 ff ff       	call   8008f3 <_panic>
  803408:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80340e:	8b 45 08             	mov    0x8(%ebp),%eax
  803411:	89 10                	mov    %edx,(%eax)
  803413:	8b 45 08             	mov    0x8(%ebp),%eax
  803416:	8b 00                	mov    (%eax),%eax
  803418:	85 c0                	test   %eax,%eax
  80341a:	74 0d                	je     803429 <insert_sorted_with_merge_freeList+0x264>
  80341c:	a1 48 51 80 00       	mov    0x805148,%eax
  803421:	8b 55 08             	mov    0x8(%ebp),%edx
  803424:	89 50 04             	mov    %edx,0x4(%eax)
  803427:	eb 08                	jmp    803431 <insert_sorted_with_merge_freeList+0x26c>
  803429:	8b 45 08             	mov    0x8(%ebp),%eax
  80342c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803431:	8b 45 08             	mov    0x8(%ebp),%eax
  803434:	a3 48 51 80 00       	mov    %eax,0x805148
  803439:	8b 45 08             	mov    0x8(%ebp),%eax
  80343c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803443:	a1 54 51 80 00       	mov    0x805154,%eax
  803448:	40                   	inc    %eax
  803449:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80344e:	e9 bb 04 00 00       	jmp    80390e <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803453:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803457:	75 17                	jne    803470 <insert_sorted_with_merge_freeList+0x2ab>
  803459:	83 ec 04             	sub    $0x4,%esp
  80345c:	68 80 45 80 00       	push   $0x804580
  803461:	68 4c 01 00 00       	push   $0x14c
  803466:	68 2f 45 80 00       	push   $0x80452f
  80346b:	e8 83 d4 ff ff       	call   8008f3 <_panic>
  803470:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803476:	8b 45 08             	mov    0x8(%ebp),%eax
  803479:	89 50 04             	mov    %edx,0x4(%eax)
  80347c:	8b 45 08             	mov    0x8(%ebp),%eax
  80347f:	8b 40 04             	mov    0x4(%eax),%eax
  803482:	85 c0                	test   %eax,%eax
  803484:	74 0c                	je     803492 <insert_sorted_with_merge_freeList+0x2cd>
  803486:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80348b:	8b 55 08             	mov    0x8(%ebp),%edx
  80348e:	89 10                	mov    %edx,(%eax)
  803490:	eb 08                	jmp    80349a <insert_sorted_with_merge_freeList+0x2d5>
  803492:	8b 45 08             	mov    0x8(%ebp),%eax
  803495:	a3 38 51 80 00       	mov    %eax,0x805138
  80349a:	8b 45 08             	mov    0x8(%ebp),%eax
  80349d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034ab:	a1 44 51 80 00       	mov    0x805144,%eax
  8034b0:	40                   	inc    %eax
  8034b1:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8034b6:	e9 53 04 00 00       	jmp    80390e <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8034bb:	a1 38 51 80 00       	mov    0x805138,%eax
  8034c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034c3:	e9 15 04 00 00       	jmp    8038dd <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8034c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034cb:	8b 00                	mov    (%eax),%eax
  8034cd:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8034d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d3:	8b 50 08             	mov    0x8(%eax),%edx
  8034d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d9:	8b 40 08             	mov    0x8(%eax),%eax
  8034dc:	39 c2                	cmp    %eax,%edx
  8034de:	0f 86 f1 03 00 00    	jbe    8038d5 <insert_sorted_with_merge_freeList+0x710>
  8034e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e7:	8b 50 08             	mov    0x8(%eax),%edx
  8034ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ed:	8b 40 08             	mov    0x8(%eax),%eax
  8034f0:	39 c2                	cmp    %eax,%edx
  8034f2:	0f 83 dd 03 00 00    	jae    8038d5 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8034f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034fb:	8b 50 08             	mov    0x8(%eax),%edx
  8034fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803501:	8b 40 0c             	mov    0xc(%eax),%eax
  803504:	01 c2                	add    %eax,%edx
  803506:	8b 45 08             	mov    0x8(%ebp),%eax
  803509:	8b 40 08             	mov    0x8(%eax),%eax
  80350c:	39 c2                	cmp    %eax,%edx
  80350e:	0f 85 b9 01 00 00    	jne    8036cd <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803514:	8b 45 08             	mov    0x8(%ebp),%eax
  803517:	8b 50 08             	mov    0x8(%eax),%edx
  80351a:	8b 45 08             	mov    0x8(%ebp),%eax
  80351d:	8b 40 0c             	mov    0xc(%eax),%eax
  803520:	01 c2                	add    %eax,%edx
  803522:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803525:	8b 40 08             	mov    0x8(%eax),%eax
  803528:	39 c2                	cmp    %eax,%edx
  80352a:	0f 85 0d 01 00 00    	jne    80363d <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803530:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803533:	8b 50 0c             	mov    0xc(%eax),%edx
  803536:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803539:	8b 40 0c             	mov    0xc(%eax),%eax
  80353c:	01 c2                	add    %eax,%edx
  80353e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803541:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803544:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803548:	75 17                	jne    803561 <insert_sorted_with_merge_freeList+0x39c>
  80354a:	83 ec 04             	sub    $0x4,%esp
  80354d:	68 d8 45 80 00       	push   $0x8045d8
  803552:	68 5c 01 00 00       	push   $0x15c
  803557:	68 2f 45 80 00       	push   $0x80452f
  80355c:	e8 92 d3 ff ff       	call   8008f3 <_panic>
  803561:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803564:	8b 00                	mov    (%eax),%eax
  803566:	85 c0                	test   %eax,%eax
  803568:	74 10                	je     80357a <insert_sorted_with_merge_freeList+0x3b5>
  80356a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80356d:	8b 00                	mov    (%eax),%eax
  80356f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803572:	8b 52 04             	mov    0x4(%edx),%edx
  803575:	89 50 04             	mov    %edx,0x4(%eax)
  803578:	eb 0b                	jmp    803585 <insert_sorted_with_merge_freeList+0x3c0>
  80357a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80357d:	8b 40 04             	mov    0x4(%eax),%eax
  803580:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803585:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803588:	8b 40 04             	mov    0x4(%eax),%eax
  80358b:	85 c0                	test   %eax,%eax
  80358d:	74 0f                	je     80359e <insert_sorted_with_merge_freeList+0x3d9>
  80358f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803592:	8b 40 04             	mov    0x4(%eax),%eax
  803595:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803598:	8b 12                	mov    (%edx),%edx
  80359a:	89 10                	mov    %edx,(%eax)
  80359c:	eb 0a                	jmp    8035a8 <insert_sorted_with_merge_freeList+0x3e3>
  80359e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035a1:	8b 00                	mov    (%eax),%eax
  8035a3:	a3 38 51 80 00       	mov    %eax,0x805138
  8035a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035b4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035bb:	a1 44 51 80 00       	mov    0x805144,%eax
  8035c0:	48                   	dec    %eax
  8035c1:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8035c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035c9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8035d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035d3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8035da:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8035de:	75 17                	jne    8035f7 <insert_sorted_with_merge_freeList+0x432>
  8035e0:	83 ec 04             	sub    $0x4,%esp
  8035e3:	68 0c 45 80 00       	push   $0x80450c
  8035e8:	68 5f 01 00 00       	push   $0x15f
  8035ed:	68 2f 45 80 00       	push   $0x80452f
  8035f2:	e8 fc d2 ff ff       	call   8008f3 <_panic>
  8035f7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8035fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803600:	89 10                	mov    %edx,(%eax)
  803602:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803605:	8b 00                	mov    (%eax),%eax
  803607:	85 c0                	test   %eax,%eax
  803609:	74 0d                	je     803618 <insert_sorted_with_merge_freeList+0x453>
  80360b:	a1 48 51 80 00       	mov    0x805148,%eax
  803610:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803613:	89 50 04             	mov    %edx,0x4(%eax)
  803616:	eb 08                	jmp    803620 <insert_sorted_with_merge_freeList+0x45b>
  803618:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80361b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803620:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803623:	a3 48 51 80 00       	mov    %eax,0x805148
  803628:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80362b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803632:	a1 54 51 80 00       	mov    0x805154,%eax
  803637:	40                   	inc    %eax
  803638:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  80363d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803640:	8b 50 0c             	mov    0xc(%eax),%edx
  803643:	8b 45 08             	mov    0x8(%ebp),%eax
  803646:	8b 40 0c             	mov    0xc(%eax),%eax
  803649:	01 c2                	add    %eax,%edx
  80364b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80364e:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803651:	8b 45 08             	mov    0x8(%ebp),%eax
  803654:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80365b:	8b 45 08             	mov    0x8(%ebp),%eax
  80365e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803665:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803669:	75 17                	jne    803682 <insert_sorted_with_merge_freeList+0x4bd>
  80366b:	83 ec 04             	sub    $0x4,%esp
  80366e:	68 0c 45 80 00       	push   $0x80450c
  803673:	68 64 01 00 00       	push   $0x164
  803678:	68 2f 45 80 00       	push   $0x80452f
  80367d:	e8 71 d2 ff ff       	call   8008f3 <_panic>
  803682:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803688:	8b 45 08             	mov    0x8(%ebp),%eax
  80368b:	89 10                	mov    %edx,(%eax)
  80368d:	8b 45 08             	mov    0x8(%ebp),%eax
  803690:	8b 00                	mov    (%eax),%eax
  803692:	85 c0                	test   %eax,%eax
  803694:	74 0d                	je     8036a3 <insert_sorted_with_merge_freeList+0x4de>
  803696:	a1 48 51 80 00       	mov    0x805148,%eax
  80369b:	8b 55 08             	mov    0x8(%ebp),%edx
  80369e:	89 50 04             	mov    %edx,0x4(%eax)
  8036a1:	eb 08                	jmp    8036ab <insert_sorted_with_merge_freeList+0x4e6>
  8036a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ae:	a3 48 51 80 00       	mov    %eax,0x805148
  8036b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036bd:	a1 54 51 80 00       	mov    0x805154,%eax
  8036c2:	40                   	inc    %eax
  8036c3:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8036c8:	e9 41 02 00 00       	jmp    80390e <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8036cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d0:	8b 50 08             	mov    0x8(%eax),%edx
  8036d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8036d9:	01 c2                	add    %eax,%edx
  8036db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036de:	8b 40 08             	mov    0x8(%eax),%eax
  8036e1:	39 c2                	cmp    %eax,%edx
  8036e3:	0f 85 7c 01 00 00    	jne    803865 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8036e9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8036ed:	74 06                	je     8036f5 <insert_sorted_with_merge_freeList+0x530>
  8036ef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036f3:	75 17                	jne    80370c <insert_sorted_with_merge_freeList+0x547>
  8036f5:	83 ec 04             	sub    $0x4,%esp
  8036f8:	68 48 45 80 00       	push   $0x804548
  8036fd:	68 69 01 00 00       	push   $0x169
  803702:	68 2f 45 80 00       	push   $0x80452f
  803707:	e8 e7 d1 ff ff       	call   8008f3 <_panic>
  80370c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80370f:	8b 50 04             	mov    0x4(%eax),%edx
  803712:	8b 45 08             	mov    0x8(%ebp),%eax
  803715:	89 50 04             	mov    %edx,0x4(%eax)
  803718:	8b 45 08             	mov    0x8(%ebp),%eax
  80371b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80371e:	89 10                	mov    %edx,(%eax)
  803720:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803723:	8b 40 04             	mov    0x4(%eax),%eax
  803726:	85 c0                	test   %eax,%eax
  803728:	74 0d                	je     803737 <insert_sorted_with_merge_freeList+0x572>
  80372a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80372d:	8b 40 04             	mov    0x4(%eax),%eax
  803730:	8b 55 08             	mov    0x8(%ebp),%edx
  803733:	89 10                	mov    %edx,(%eax)
  803735:	eb 08                	jmp    80373f <insert_sorted_with_merge_freeList+0x57a>
  803737:	8b 45 08             	mov    0x8(%ebp),%eax
  80373a:	a3 38 51 80 00       	mov    %eax,0x805138
  80373f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803742:	8b 55 08             	mov    0x8(%ebp),%edx
  803745:	89 50 04             	mov    %edx,0x4(%eax)
  803748:	a1 44 51 80 00       	mov    0x805144,%eax
  80374d:	40                   	inc    %eax
  80374e:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803753:	8b 45 08             	mov    0x8(%ebp),%eax
  803756:	8b 50 0c             	mov    0xc(%eax),%edx
  803759:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80375c:	8b 40 0c             	mov    0xc(%eax),%eax
  80375f:	01 c2                	add    %eax,%edx
  803761:	8b 45 08             	mov    0x8(%ebp),%eax
  803764:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803767:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80376b:	75 17                	jne    803784 <insert_sorted_with_merge_freeList+0x5bf>
  80376d:	83 ec 04             	sub    $0x4,%esp
  803770:	68 d8 45 80 00       	push   $0x8045d8
  803775:	68 6b 01 00 00       	push   $0x16b
  80377a:	68 2f 45 80 00       	push   $0x80452f
  80377f:	e8 6f d1 ff ff       	call   8008f3 <_panic>
  803784:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803787:	8b 00                	mov    (%eax),%eax
  803789:	85 c0                	test   %eax,%eax
  80378b:	74 10                	je     80379d <insert_sorted_with_merge_freeList+0x5d8>
  80378d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803790:	8b 00                	mov    (%eax),%eax
  803792:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803795:	8b 52 04             	mov    0x4(%edx),%edx
  803798:	89 50 04             	mov    %edx,0x4(%eax)
  80379b:	eb 0b                	jmp    8037a8 <insert_sorted_with_merge_freeList+0x5e3>
  80379d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037a0:	8b 40 04             	mov    0x4(%eax),%eax
  8037a3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8037a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037ab:	8b 40 04             	mov    0x4(%eax),%eax
  8037ae:	85 c0                	test   %eax,%eax
  8037b0:	74 0f                	je     8037c1 <insert_sorted_with_merge_freeList+0x5fc>
  8037b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037b5:	8b 40 04             	mov    0x4(%eax),%eax
  8037b8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037bb:	8b 12                	mov    (%edx),%edx
  8037bd:	89 10                	mov    %edx,(%eax)
  8037bf:	eb 0a                	jmp    8037cb <insert_sorted_with_merge_freeList+0x606>
  8037c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037c4:	8b 00                	mov    (%eax),%eax
  8037c6:	a3 38 51 80 00       	mov    %eax,0x805138
  8037cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037de:	a1 44 51 80 00       	mov    0x805144,%eax
  8037e3:	48                   	dec    %eax
  8037e4:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8037e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037ec:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8037f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037f6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8037fd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803801:	75 17                	jne    80381a <insert_sorted_with_merge_freeList+0x655>
  803803:	83 ec 04             	sub    $0x4,%esp
  803806:	68 0c 45 80 00       	push   $0x80450c
  80380b:	68 6e 01 00 00       	push   $0x16e
  803810:	68 2f 45 80 00       	push   $0x80452f
  803815:	e8 d9 d0 ff ff       	call   8008f3 <_panic>
  80381a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803820:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803823:	89 10                	mov    %edx,(%eax)
  803825:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803828:	8b 00                	mov    (%eax),%eax
  80382a:	85 c0                	test   %eax,%eax
  80382c:	74 0d                	je     80383b <insert_sorted_with_merge_freeList+0x676>
  80382e:	a1 48 51 80 00       	mov    0x805148,%eax
  803833:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803836:	89 50 04             	mov    %edx,0x4(%eax)
  803839:	eb 08                	jmp    803843 <insert_sorted_with_merge_freeList+0x67e>
  80383b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80383e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803843:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803846:	a3 48 51 80 00       	mov    %eax,0x805148
  80384b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80384e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803855:	a1 54 51 80 00       	mov    0x805154,%eax
  80385a:	40                   	inc    %eax
  80385b:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803860:	e9 a9 00 00 00       	jmp    80390e <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803865:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803869:	74 06                	je     803871 <insert_sorted_with_merge_freeList+0x6ac>
  80386b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80386f:	75 17                	jne    803888 <insert_sorted_with_merge_freeList+0x6c3>
  803871:	83 ec 04             	sub    $0x4,%esp
  803874:	68 a4 45 80 00       	push   $0x8045a4
  803879:	68 73 01 00 00       	push   $0x173
  80387e:	68 2f 45 80 00       	push   $0x80452f
  803883:	e8 6b d0 ff ff       	call   8008f3 <_panic>
  803888:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80388b:	8b 10                	mov    (%eax),%edx
  80388d:	8b 45 08             	mov    0x8(%ebp),%eax
  803890:	89 10                	mov    %edx,(%eax)
  803892:	8b 45 08             	mov    0x8(%ebp),%eax
  803895:	8b 00                	mov    (%eax),%eax
  803897:	85 c0                	test   %eax,%eax
  803899:	74 0b                	je     8038a6 <insert_sorted_with_merge_freeList+0x6e1>
  80389b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80389e:	8b 00                	mov    (%eax),%eax
  8038a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8038a3:	89 50 04             	mov    %edx,0x4(%eax)
  8038a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8038ac:	89 10                	mov    %edx,(%eax)
  8038ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8038b4:	89 50 04             	mov    %edx,0x4(%eax)
  8038b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ba:	8b 00                	mov    (%eax),%eax
  8038bc:	85 c0                	test   %eax,%eax
  8038be:	75 08                	jne    8038c8 <insert_sorted_with_merge_freeList+0x703>
  8038c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8038c8:	a1 44 51 80 00       	mov    0x805144,%eax
  8038cd:	40                   	inc    %eax
  8038ce:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8038d3:	eb 39                	jmp    80390e <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8038d5:	a1 40 51 80 00       	mov    0x805140,%eax
  8038da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8038dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038e1:	74 07                	je     8038ea <insert_sorted_with_merge_freeList+0x725>
  8038e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038e6:	8b 00                	mov    (%eax),%eax
  8038e8:	eb 05                	jmp    8038ef <insert_sorted_with_merge_freeList+0x72a>
  8038ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8038ef:	a3 40 51 80 00       	mov    %eax,0x805140
  8038f4:	a1 40 51 80 00       	mov    0x805140,%eax
  8038f9:	85 c0                	test   %eax,%eax
  8038fb:	0f 85 c7 fb ff ff    	jne    8034c8 <insert_sorted_with_merge_freeList+0x303>
  803901:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803905:	0f 85 bd fb ff ff    	jne    8034c8 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80390b:	eb 01                	jmp    80390e <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80390d:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80390e:	90                   	nop
  80390f:	c9                   	leave  
  803910:	c3                   	ret    
  803911:	66 90                	xchg   %ax,%ax
  803913:	90                   	nop

00803914 <__udivdi3>:
  803914:	55                   	push   %ebp
  803915:	57                   	push   %edi
  803916:	56                   	push   %esi
  803917:	53                   	push   %ebx
  803918:	83 ec 1c             	sub    $0x1c,%esp
  80391b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80391f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803923:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803927:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80392b:	89 ca                	mov    %ecx,%edx
  80392d:	89 f8                	mov    %edi,%eax
  80392f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803933:	85 f6                	test   %esi,%esi
  803935:	75 2d                	jne    803964 <__udivdi3+0x50>
  803937:	39 cf                	cmp    %ecx,%edi
  803939:	77 65                	ja     8039a0 <__udivdi3+0x8c>
  80393b:	89 fd                	mov    %edi,%ebp
  80393d:	85 ff                	test   %edi,%edi
  80393f:	75 0b                	jne    80394c <__udivdi3+0x38>
  803941:	b8 01 00 00 00       	mov    $0x1,%eax
  803946:	31 d2                	xor    %edx,%edx
  803948:	f7 f7                	div    %edi
  80394a:	89 c5                	mov    %eax,%ebp
  80394c:	31 d2                	xor    %edx,%edx
  80394e:	89 c8                	mov    %ecx,%eax
  803950:	f7 f5                	div    %ebp
  803952:	89 c1                	mov    %eax,%ecx
  803954:	89 d8                	mov    %ebx,%eax
  803956:	f7 f5                	div    %ebp
  803958:	89 cf                	mov    %ecx,%edi
  80395a:	89 fa                	mov    %edi,%edx
  80395c:	83 c4 1c             	add    $0x1c,%esp
  80395f:	5b                   	pop    %ebx
  803960:	5e                   	pop    %esi
  803961:	5f                   	pop    %edi
  803962:	5d                   	pop    %ebp
  803963:	c3                   	ret    
  803964:	39 ce                	cmp    %ecx,%esi
  803966:	77 28                	ja     803990 <__udivdi3+0x7c>
  803968:	0f bd fe             	bsr    %esi,%edi
  80396b:	83 f7 1f             	xor    $0x1f,%edi
  80396e:	75 40                	jne    8039b0 <__udivdi3+0x9c>
  803970:	39 ce                	cmp    %ecx,%esi
  803972:	72 0a                	jb     80397e <__udivdi3+0x6a>
  803974:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803978:	0f 87 9e 00 00 00    	ja     803a1c <__udivdi3+0x108>
  80397e:	b8 01 00 00 00       	mov    $0x1,%eax
  803983:	89 fa                	mov    %edi,%edx
  803985:	83 c4 1c             	add    $0x1c,%esp
  803988:	5b                   	pop    %ebx
  803989:	5e                   	pop    %esi
  80398a:	5f                   	pop    %edi
  80398b:	5d                   	pop    %ebp
  80398c:	c3                   	ret    
  80398d:	8d 76 00             	lea    0x0(%esi),%esi
  803990:	31 ff                	xor    %edi,%edi
  803992:	31 c0                	xor    %eax,%eax
  803994:	89 fa                	mov    %edi,%edx
  803996:	83 c4 1c             	add    $0x1c,%esp
  803999:	5b                   	pop    %ebx
  80399a:	5e                   	pop    %esi
  80399b:	5f                   	pop    %edi
  80399c:	5d                   	pop    %ebp
  80399d:	c3                   	ret    
  80399e:	66 90                	xchg   %ax,%ax
  8039a0:	89 d8                	mov    %ebx,%eax
  8039a2:	f7 f7                	div    %edi
  8039a4:	31 ff                	xor    %edi,%edi
  8039a6:	89 fa                	mov    %edi,%edx
  8039a8:	83 c4 1c             	add    $0x1c,%esp
  8039ab:	5b                   	pop    %ebx
  8039ac:	5e                   	pop    %esi
  8039ad:	5f                   	pop    %edi
  8039ae:	5d                   	pop    %ebp
  8039af:	c3                   	ret    
  8039b0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8039b5:	89 eb                	mov    %ebp,%ebx
  8039b7:	29 fb                	sub    %edi,%ebx
  8039b9:	89 f9                	mov    %edi,%ecx
  8039bb:	d3 e6                	shl    %cl,%esi
  8039bd:	89 c5                	mov    %eax,%ebp
  8039bf:	88 d9                	mov    %bl,%cl
  8039c1:	d3 ed                	shr    %cl,%ebp
  8039c3:	89 e9                	mov    %ebp,%ecx
  8039c5:	09 f1                	or     %esi,%ecx
  8039c7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8039cb:	89 f9                	mov    %edi,%ecx
  8039cd:	d3 e0                	shl    %cl,%eax
  8039cf:	89 c5                	mov    %eax,%ebp
  8039d1:	89 d6                	mov    %edx,%esi
  8039d3:	88 d9                	mov    %bl,%cl
  8039d5:	d3 ee                	shr    %cl,%esi
  8039d7:	89 f9                	mov    %edi,%ecx
  8039d9:	d3 e2                	shl    %cl,%edx
  8039db:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039df:	88 d9                	mov    %bl,%cl
  8039e1:	d3 e8                	shr    %cl,%eax
  8039e3:	09 c2                	or     %eax,%edx
  8039e5:	89 d0                	mov    %edx,%eax
  8039e7:	89 f2                	mov    %esi,%edx
  8039e9:	f7 74 24 0c          	divl   0xc(%esp)
  8039ed:	89 d6                	mov    %edx,%esi
  8039ef:	89 c3                	mov    %eax,%ebx
  8039f1:	f7 e5                	mul    %ebp
  8039f3:	39 d6                	cmp    %edx,%esi
  8039f5:	72 19                	jb     803a10 <__udivdi3+0xfc>
  8039f7:	74 0b                	je     803a04 <__udivdi3+0xf0>
  8039f9:	89 d8                	mov    %ebx,%eax
  8039fb:	31 ff                	xor    %edi,%edi
  8039fd:	e9 58 ff ff ff       	jmp    80395a <__udivdi3+0x46>
  803a02:	66 90                	xchg   %ax,%ax
  803a04:	8b 54 24 08          	mov    0x8(%esp),%edx
  803a08:	89 f9                	mov    %edi,%ecx
  803a0a:	d3 e2                	shl    %cl,%edx
  803a0c:	39 c2                	cmp    %eax,%edx
  803a0e:	73 e9                	jae    8039f9 <__udivdi3+0xe5>
  803a10:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803a13:	31 ff                	xor    %edi,%edi
  803a15:	e9 40 ff ff ff       	jmp    80395a <__udivdi3+0x46>
  803a1a:	66 90                	xchg   %ax,%ax
  803a1c:	31 c0                	xor    %eax,%eax
  803a1e:	e9 37 ff ff ff       	jmp    80395a <__udivdi3+0x46>
  803a23:	90                   	nop

00803a24 <__umoddi3>:
  803a24:	55                   	push   %ebp
  803a25:	57                   	push   %edi
  803a26:	56                   	push   %esi
  803a27:	53                   	push   %ebx
  803a28:	83 ec 1c             	sub    $0x1c,%esp
  803a2b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803a2f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803a33:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a37:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803a3b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803a3f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803a43:	89 f3                	mov    %esi,%ebx
  803a45:	89 fa                	mov    %edi,%edx
  803a47:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a4b:	89 34 24             	mov    %esi,(%esp)
  803a4e:	85 c0                	test   %eax,%eax
  803a50:	75 1a                	jne    803a6c <__umoddi3+0x48>
  803a52:	39 f7                	cmp    %esi,%edi
  803a54:	0f 86 a2 00 00 00    	jbe    803afc <__umoddi3+0xd8>
  803a5a:	89 c8                	mov    %ecx,%eax
  803a5c:	89 f2                	mov    %esi,%edx
  803a5e:	f7 f7                	div    %edi
  803a60:	89 d0                	mov    %edx,%eax
  803a62:	31 d2                	xor    %edx,%edx
  803a64:	83 c4 1c             	add    $0x1c,%esp
  803a67:	5b                   	pop    %ebx
  803a68:	5e                   	pop    %esi
  803a69:	5f                   	pop    %edi
  803a6a:	5d                   	pop    %ebp
  803a6b:	c3                   	ret    
  803a6c:	39 f0                	cmp    %esi,%eax
  803a6e:	0f 87 ac 00 00 00    	ja     803b20 <__umoddi3+0xfc>
  803a74:	0f bd e8             	bsr    %eax,%ebp
  803a77:	83 f5 1f             	xor    $0x1f,%ebp
  803a7a:	0f 84 ac 00 00 00    	je     803b2c <__umoddi3+0x108>
  803a80:	bf 20 00 00 00       	mov    $0x20,%edi
  803a85:	29 ef                	sub    %ebp,%edi
  803a87:	89 fe                	mov    %edi,%esi
  803a89:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803a8d:	89 e9                	mov    %ebp,%ecx
  803a8f:	d3 e0                	shl    %cl,%eax
  803a91:	89 d7                	mov    %edx,%edi
  803a93:	89 f1                	mov    %esi,%ecx
  803a95:	d3 ef                	shr    %cl,%edi
  803a97:	09 c7                	or     %eax,%edi
  803a99:	89 e9                	mov    %ebp,%ecx
  803a9b:	d3 e2                	shl    %cl,%edx
  803a9d:	89 14 24             	mov    %edx,(%esp)
  803aa0:	89 d8                	mov    %ebx,%eax
  803aa2:	d3 e0                	shl    %cl,%eax
  803aa4:	89 c2                	mov    %eax,%edx
  803aa6:	8b 44 24 08          	mov    0x8(%esp),%eax
  803aaa:	d3 e0                	shl    %cl,%eax
  803aac:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ab0:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ab4:	89 f1                	mov    %esi,%ecx
  803ab6:	d3 e8                	shr    %cl,%eax
  803ab8:	09 d0                	or     %edx,%eax
  803aba:	d3 eb                	shr    %cl,%ebx
  803abc:	89 da                	mov    %ebx,%edx
  803abe:	f7 f7                	div    %edi
  803ac0:	89 d3                	mov    %edx,%ebx
  803ac2:	f7 24 24             	mull   (%esp)
  803ac5:	89 c6                	mov    %eax,%esi
  803ac7:	89 d1                	mov    %edx,%ecx
  803ac9:	39 d3                	cmp    %edx,%ebx
  803acb:	0f 82 87 00 00 00    	jb     803b58 <__umoddi3+0x134>
  803ad1:	0f 84 91 00 00 00    	je     803b68 <__umoddi3+0x144>
  803ad7:	8b 54 24 04          	mov    0x4(%esp),%edx
  803adb:	29 f2                	sub    %esi,%edx
  803add:	19 cb                	sbb    %ecx,%ebx
  803adf:	89 d8                	mov    %ebx,%eax
  803ae1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803ae5:	d3 e0                	shl    %cl,%eax
  803ae7:	89 e9                	mov    %ebp,%ecx
  803ae9:	d3 ea                	shr    %cl,%edx
  803aeb:	09 d0                	or     %edx,%eax
  803aed:	89 e9                	mov    %ebp,%ecx
  803aef:	d3 eb                	shr    %cl,%ebx
  803af1:	89 da                	mov    %ebx,%edx
  803af3:	83 c4 1c             	add    $0x1c,%esp
  803af6:	5b                   	pop    %ebx
  803af7:	5e                   	pop    %esi
  803af8:	5f                   	pop    %edi
  803af9:	5d                   	pop    %ebp
  803afa:	c3                   	ret    
  803afb:	90                   	nop
  803afc:	89 fd                	mov    %edi,%ebp
  803afe:	85 ff                	test   %edi,%edi
  803b00:	75 0b                	jne    803b0d <__umoddi3+0xe9>
  803b02:	b8 01 00 00 00       	mov    $0x1,%eax
  803b07:	31 d2                	xor    %edx,%edx
  803b09:	f7 f7                	div    %edi
  803b0b:	89 c5                	mov    %eax,%ebp
  803b0d:	89 f0                	mov    %esi,%eax
  803b0f:	31 d2                	xor    %edx,%edx
  803b11:	f7 f5                	div    %ebp
  803b13:	89 c8                	mov    %ecx,%eax
  803b15:	f7 f5                	div    %ebp
  803b17:	89 d0                	mov    %edx,%eax
  803b19:	e9 44 ff ff ff       	jmp    803a62 <__umoddi3+0x3e>
  803b1e:	66 90                	xchg   %ax,%ax
  803b20:	89 c8                	mov    %ecx,%eax
  803b22:	89 f2                	mov    %esi,%edx
  803b24:	83 c4 1c             	add    $0x1c,%esp
  803b27:	5b                   	pop    %ebx
  803b28:	5e                   	pop    %esi
  803b29:	5f                   	pop    %edi
  803b2a:	5d                   	pop    %ebp
  803b2b:	c3                   	ret    
  803b2c:	3b 04 24             	cmp    (%esp),%eax
  803b2f:	72 06                	jb     803b37 <__umoddi3+0x113>
  803b31:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803b35:	77 0f                	ja     803b46 <__umoddi3+0x122>
  803b37:	89 f2                	mov    %esi,%edx
  803b39:	29 f9                	sub    %edi,%ecx
  803b3b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803b3f:	89 14 24             	mov    %edx,(%esp)
  803b42:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b46:	8b 44 24 04          	mov    0x4(%esp),%eax
  803b4a:	8b 14 24             	mov    (%esp),%edx
  803b4d:	83 c4 1c             	add    $0x1c,%esp
  803b50:	5b                   	pop    %ebx
  803b51:	5e                   	pop    %esi
  803b52:	5f                   	pop    %edi
  803b53:	5d                   	pop    %ebp
  803b54:	c3                   	ret    
  803b55:	8d 76 00             	lea    0x0(%esi),%esi
  803b58:	2b 04 24             	sub    (%esp),%eax
  803b5b:	19 fa                	sbb    %edi,%edx
  803b5d:	89 d1                	mov    %edx,%ecx
  803b5f:	89 c6                	mov    %eax,%esi
  803b61:	e9 71 ff ff ff       	jmp    803ad7 <__umoddi3+0xb3>
  803b66:	66 90                	xchg   %ax,%ax
  803b68:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803b6c:	72 ea                	jb     803b58 <__umoddi3+0x134>
  803b6e:	89 d9                	mov    %ebx,%ecx
  803b70:	e9 62 ff ff ff       	jmp    803ad7 <__umoddi3+0xb3>
