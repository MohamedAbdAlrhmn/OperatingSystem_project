
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
  800041:	e8 f3 1f 00 00       	call   802039 <sys_disable_interrupt>

		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 80 3d 80 00       	push   $0x803d80
  80004e:	e8 54 0b 00 00       	call   800ba7 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 82 3d 80 00       	push   $0x803d82
  80005e:	e8 44 0b 00 00       	call   800ba7 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 98 3d 80 00       	push   $0x803d98
  80006e:	e8 34 0b 00 00       	call   800ba7 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 82 3d 80 00       	push   $0x803d82
  80007e:	e8 24 0b 00 00       	call   800ba7 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 80 3d 80 00       	push   $0x803d80
  80008e:	e8 14 0b 00 00       	call   800ba7 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
		//readline("Enter the number of elements: ", Line);
		cprintf("Enter the number of elements: ");
  800096:	83 ec 0c             	sub    $0xc,%esp
  800099:	68 b0 3d 80 00       	push   $0x803db0
  80009e:	e8 04 0b 00 00       	call   800ba7 <cprintf>
  8000a3:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = 2000 ;
  8000a6:	c7 45 f0 d0 07 00 00 	movl   $0x7d0,-0x10(%ebp)
		cprintf("%d\n", NumOfElements) ;
  8000ad:	83 ec 08             	sub    $0x8,%esp
  8000b0:	ff 75 f0             	pushl  -0x10(%ebp)
  8000b3:	68 cf 3d 80 00       	push   $0x803dcf
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
  8000d8:	68 d4 3d 80 00       	push   $0x803dd4
  8000dd:	e8 c5 0a 00 00       	call   800ba7 <cprintf>
  8000e2:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	68 f6 3d 80 00       	push   $0x803df6
  8000ed:	e8 b5 0a 00 00       	call   800ba7 <cprintf>
  8000f2:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000f5:	83 ec 0c             	sub    $0xc,%esp
  8000f8:	68 04 3e 80 00       	push   $0x803e04
  8000fd:	e8 a5 0a 00 00       	call   800ba7 <cprintf>
  800102:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  800105:	83 ec 0c             	sub    $0xc,%esp
  800108:	68 13 3e 80 00       	push   $0x803e13
  80010d:	e8 95 0a 00 00       	call   800ba7 <cprintf>
  800112:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800115:	83 ec 0c             	sub    $0xc,%esp
  800118:	68 23 3e 80 00       	push   $0x803e23
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
  800158:	e8 f6 1e 00 00       	call   802053 <sys_enable_interrupt>

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
  8001cd:	e8 67 1e 00 00       	call   802039 <sys_disable_interrupt>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001d2:	83 ec 0c             	sub    $0xc,%esp
  8001d5:	68 2c 3e 80 00       	push   $0x803e2c
  8001da:	e8 c8 09 00 00       	call   800ba7 <cprintf>
  8001df:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001e2:	e8 6c 1e 00 00       	call   802053 <sys_enable_interrupt>

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
  800204:	68 60 3e 80 00       	push   $0x803e60
  800209:	6a 4e                	push   $0x4e
  80020b:	68 82 3e 80 00       	push   $0x803e82
  800210:	e8 de 06 00 00       	call   8008f3 <_panic>
		else
		{
			sys_disable_interrupt();
  800215:	e8 1f 1e 00 00       	call   802039 <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  80021a:	83 ec 0c             	sub    $0xc,%esp
  80021d:	68 a0 3e 80 00       	push   $0x803ea0
  800222:	e8 80 09 00 00       	call   800ba7 <cprintf>
  800227:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  80022a:	83 ec 0c             	sub    $0xc,%esp
  80022d:	68 d4 3e 80 00       	push   $0x803ed4
  800232:	e8 70 09 00 00       	call   800ba7 <cprintf>
  800237:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  80023a:	83 ec 0c             	sub    $0xc,%esp
  80023d:	68 08 3f 80 00       	push   $0x803f08
  800242:	e8 60 09 00 00       	call   800ba7 <cprintf>
  800247:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  80024a:	e8 04 1e 00 00       	call   802053 <sys_enable_interrupt>
		}

		free(Elements) ;
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	ff 75 ec             	pushl  -0x14(%ebp)
  800255:	e8 50 19 00 00       	call   801baa <free>
  80025a:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  80025d:	e8 d7 1d 00 00       	call   802039 <sys_disable_interrupt>
			Chose = 0 ;
  800262:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800266:	eb 3e                	jmp    8002a6 <_main+0x26e>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800268:	83 ec 0c             	sub    $0xc,%esp
  80026b:	68 3a 3f 80 00       	push   $0x803f3a
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
  8002b2:	e8 9c 1d 00 00       	call   802053 <sys_enable_interrupt>

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
  800446:	68 80 3d 80 00       	push   $0x803d80
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
  800468:	68 58 3f 80 00       	push   $0x803f58
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
  800496:	68 cf 3d 80 00       	push   $0x803dcf
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
  80072b:	e8 3d 19 00 00       	call   80206d <sys_cputc>
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
  80073c:	e8 f8 18 00 00       	call   802039 <sys_disable_interrupt>
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
  80074f:	e8 19 19 00 00       	call   80206d <sys_cputc>
  800754:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800757:	e8 f7 18 00 00       	call   802053 <sys_enable_interrupt>
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
  80076e:	e8 41 17 00 00       	call   801eb4 <sys_cgetc>
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
  800787:	e8 ad 18 00 00       	call   802039 <sys_disable_interrupt>
	int c=0;
  80078c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800793:	eb 08                	jmp    80079d <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800795:	e8 1a 17 00 00       	call   801eb4 <sys_cgetc>
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
  8007a3:	e8 ab 18 00 00       	call   802053 <sys_enable_interrupt>
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
  8007bd:	e8 6a 1a 00 00       	call   80222c <sys_getenvindex>
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
  800828:	e8 0c 18 00 00       	call   802039 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80082d:	83 ec 0c             	sub    $0xc,%esp
  800830:	68 78 3f 80 00       	push   $0x803f78
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
  800858:	68 a0 3f 80 00       	push   $0x803fa0
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
  800889:	68 c8 3f 80 00       	push   $0x803fc8
  80088e:	e8 14 03 00 00       	call   800ba7 <cprintf>
  800893:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800896:	a1 24 50 80 00       	mov    0x805024,%eax
  80089b:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8008a1:	83 ec 08             	sub    $0x8,%esp
  8008a4:	50                   	push   %eax
  8008a5:	68 20 40 80 00       	push   $0x804020
  8008aa:	e8 f8 02 00 00       	call   800ba7 <cprintf>
  8008af:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8008b2:	83 ec 0c             	sub    $0xc,%esp
  8008b5:	68 78 3f 80 00       	push   $0x803f78
  8008ba:	e8 e8 02 00 00       	call   800ba7 <cprintf>
  8008bf:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8008c2:	e8 8c 17 00 00       	call   802053 <sys_enable_interrupt>

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
  8008da:	e8 19 19 00 00       	call   8021f8 <sys_destroy_env>
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
  8008eb:	e8 6e 19 00 00       	call   80225e <sys_exit_env>
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
  800914:	68 34 40 80 00       	push   $0x804034
  800919:	e8 89 02 00 00       	call   800ba7 <cprintf>
  80091e:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800921:	a1 00 50 80 00       	mov    0x805000,%eax
  800926:	ff 75 0c             	pushl  0xc(%ebp)
  800929:	ff 75 08             	pushl  0x8(%ebp)
  80092c:	50                   	push   %eax
  80092d:	68 39 40 80 00       	push   $0x804039
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
  800951:	68 55 40 80 00       	push   $0x804055
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
  80097d:	68 58 40 80 00       	push   $0x804058
  800982:	6a 26                	push   $0x26
  800984:	68 a4 40 80 00       	push   $0x8040a4
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
  800a4f:	68 b0 40 80 00       	push   $0x8040b0
  800a54:	6a 3a                	push   $0x3a
  800a56:	68 a4 40 80 00       	push   $0x8040a4
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
  800abf:	68 04 41 80 00       	push   $0x804104
  800ac4:	6a 44                	push   $0x44
  800ac6:	68 a4 40 80 00       	push   $0x8040a4
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
  800b19:	e8 6d 13 00 00       	call   801e8b <sys_cputs>
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
  800b90:	e8 f6 12 00 00       	call   801e8b <sys_cputs>
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
  800bda:	e8 5a 14 00 00       	call   802039 <sys_disable_interrupt>
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
  800bfa:	e8 54 14 00 00       	call   802053 <sys_enable_interrupt>
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
  800c44:	e8 c7 2e 00 00       	call   803b10 <__udivdi3>
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
  800c94:	e8 87 2f 00 00       	call   803c20 <__umoddi3>
  800c99:	83 c4 10             	add    $0x10,%esp
  800c9c:	05 74 43 80 00       	add    $0x804374,%eax
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
  800def:	8b 04 85 98 43 80 00 	mov    0x804398(,%eax,4),%eax
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
  800ed0:	8b 34 9d e0 41 80 00 	mov    0x8041e0(,%ebx,4),%esi
  800ed7:	85 f6                	test   %esi,%esi
  800ed9:	75 19                	jne    800ef4 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800edb:	53                   	push   %ebx
  800edc:	68 85 43 80 00       	push   $0x804385
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
  800ef5:	68 8e 43 80 00       	push   $0x80438e
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
  800f22:	be 91 43 80 00       	mov    $0x804391,%esi
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
  801948:	68 f0 44 80 00       	push   $0x8044f0
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
  801a18:	e8 b2 05 00 00       	call   801fcf <sys_allocate_chunk>
  801a1d:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801a20:	a1 20 51 80 00       	mov    0x805120,%eax
  801a25:	83 ec 0c             	sub    $0xc,%esp
  801a28:	50                   	push   %eax
  801a29:	e8 27 0c 00 00       	call   802655 <initialize_MemBlocksList>
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
  801a56:	68 15 45 80 00       	push   $0x804515
  801a5b:	6a 33                	push   $0x33
  801a5d:	68 33 45 80 00       	push   $0x804533
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
  801ad5:	68 40 45 80 00       	push   $0x804540
  801ada:	6a 34                	push   $0x34
  801adc:	68 33 45 80 00       	push   $0x804533
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
  801b6d:	e8 2b 08 00 00       	call   80239d <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b72:	85 c0                	test   %eax,%eax
  801b74:	74 11                	je     801b87 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801b76:	83 ec 0c             	sub    $0xc,%esp
  801b79:	ff 75 e8             	pushl  -0x18(%ebp)
  801b7c:	e8 96 0e 00 00       	call   802a17 <alloc_block_FF>
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
  801b93:	e8 f2 0b 00 00       	call   80278a <insert_sorted_allocList>
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
  801bad:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb3:	83 ec 08             	sub    $0x8,%esp
  801bb6:	50                   	push   %eax
  801bb7:	68 40 50 80 00       	push   $0x805040
  801bbc:	e8 71 0b 00 00       	call   802732 <find_block>
  801bc1:	83 c4 10             	add    $0x10,%esp
  801bc4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(free_block!=NULL)
  801bc7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bcb:	0f 84 a6 00 00 00    	je     801c77 <free+0xcd>
	{
		sys_free_user_mem(free_block->sva,free_block->size);
  801bd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bd4:	8b 50 0c             	mov    0xc(%eax),%edx
  801bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bda:	8b 40 08             	mov    0x8(%eax),%eax
  801bdd:	83 ec 08             	sub    $0x8,%esp
  801be0:	52                   	push   %edx
  801be1:	50                   	push   %eax
  801be2:	e8 b0 03 00 00       	call   801f97 <sys_free_user_mem>
  801be7:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,free_block);
  801bea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bee:	75 14                	jne    801c04 <free+0x5a>
  801bf0:	83 ec 04             	sub    $0x4,%esp
  801bf3:	68 15 45 80 00       	push   $0x804515
  801bf8:	6a 74                	push   $0x74
  801bfa:	68 33 45 80 00       	push   $0x804533
  801bff:	e8 ef ec ff ff       	call   8008f3 <_panic>
  801c04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c07:	8b 00                	mov    (%eax),%eax
  801c09:	85 c0                	test   %eax,%eax
  801c0b:	74 10                	je     801c1d <free+0x73>
  801c0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c10:	8b 00                	mov    (%eax),%eax
  801c12:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c15:	8b 52 04             	mov    0x4(%edx),%edx
  801c18:	89 50 04             	mov    %edx,0x4(%eax)
  801c1b:	eb 0b                	jmp    801c28 <free+0x7e>
  801c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c20:	8b 40 04             	mov    0x4(%eax),%eax
  801c23:	a3 44 50 80 00       	mov    %eax,0x805044
  801c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c2b:	8b 40 04             	mov    0x4(%eax),%eax
  801c2e:	85 c0                	test   %eax,%eax
  801c30:	74 0f                	je     801c41 <free+0x97>
  801c32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c35:	8b 40 04             	mov    0x4(%eax),%eax
  801c38:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c3b:	8b 12                	mov    (%edx),%edx
  801c3d:	89 10                	mov    %edx,(%eax)
  801c3f:	eb 0a                	jmp    801c4b <free+0xa1>
  801c41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c44:	8b 00                	mov    (%eax),%eax
  801c46:	a3 40 50 80 00       	mov    %eax,0x805040
  801c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c4e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801c54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c57:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801c5e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801c63:	48                   	dec    %eax
  801c64:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(free_block);
  801c69:	83 ec 0c             	sub    $0xc,%esp
  801c6c:	ff 75 f4             	pushl  -0xc(%ebp)
  801c6f:	e8 4e 17 00 00       	call   8033c2 <insert_sorted_with_merge_freeList>
  801c74:	83 c4 10             	add    $0x10,%esp
	}

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801c77:	90                   	nop
  801c78:	c9                   	leave  
  801c79:	c3                   	ret    

00801c7a <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801c7a:	55                   	push   %ebp
  801c7b:	89 e5                	mov    %esp,%ebp
  801c7d:	83 ec 38             	sub    $0x38,%esp
  801c80:	8b 45 10             	mov    0x10(%ebp),%eax
  801c83:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c86:	e8 a6 fc ff ff       	call   801931 <InitializeUHeap>
	if (size == 0) return NULL ;
  801c8b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c8f:	75 0a                	jne    801c9b <smalloc+0x21>
  801c91:	b8 00 00 00 00       	mov    $0x0,%eax
  801c96:	e9 8b 00 00 00       	jmp    801d26 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801c9b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801ca2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ca5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ca8:	01 d0                	add    %edx,%eax
  801caa:	48                   	dec    %eax
  801cab:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801cae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cb1:	ba 00 00 00 00       	mov    $0x0,%edx
  801cb6:	f7 75 f0             	divl   -0x10(%ebp)
  801cb9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cbc:	29 d0                	sub    %edx,%eax
  801cbe:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801cc1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801cc8:	e8 d0 06 00 00       	call   80239d <sys_isUHeapPlacementStrategyFIRSTFIT>
  801ccd:	85 c0                	test   %eax,%eax
  801ccf:	74 11                	je     801ce2 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801cd1:	83 ec 0c             	sub    $0xc,%esp
  801cd4:	ff 75 e8             	pushl  -0x18(%ebp)
  801cd7:	e8 3b 0d 00 00       	call   802a17 <alloc_block_FF>
  801cdc:	83 c4 10             	add    $0x10,%esp
  801cdf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  801ce2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ce6:	74 39                	je     801d21 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801ce8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ceb:	8b 40 08             	mov    0x8(%eax),%eax
  801cee:	89 c2                	mov    %eax,%edx
  801cf0:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801cf4:	52                   	push   %edx
  801cf5:	50                   	push   %eax
  801cf6:	ff 75 0c             	pushl  0xc(%ebp)
  801cf9:	ff 75 08             	pushl  0x8(%ebp)
  801cfc:	e8 21 04 00 00       	call   802122 <sys_createSharedObject>
  801d01:	83 c4 10             	add    $0x10,%esp
  801d04:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801d07:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801d0b:	74 14                	je     801d21 <smalloc+0xa7>
  801d0d:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801d11:	74 0e                	je     801d21 <smalloc+0xa7>
  801d13:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801d17:	74 08                	je     801d21 <smalloc+0xa7>
			return (void*) mem_block->sva;
  801d19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d1c:	8b 40 08             	mov    0x8(%eax),%eax
  801d1f:	eb 05                	jmp    801d26 <smalloc+0xac>
	}
	return NULL;
  801d21:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801d26:	c9                   	leave  
  801d27:	c3                   	ret    

00801d28 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801d28:	55                   	push   %ebp
  801d29:	89 e5                	mov    %esp,%ebp
  801d2b:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d2e:	e8 fe fb ff ff       	call   801931 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801d33:	83 ec 08             	sub    $0x8,%esp
  801d36:	ff 75 0c             	pushl  0xc(%ebp)
  801d39:	ff 75 08             	pushl  0x8(%ebp)
  801d3c:	e8 0b 04 00 00       	call   80214c <sys_getSizeOfSharedObject>
  801d41:	83 c4 10             	add    $0x10,%esp
  801d44:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  801d47:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  801d4b:	74 76                	je     801dc3 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801d4d:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801d54:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d57:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d5a:	01 d0                	add    %edx,%eax
  801d5c:	48                   	dec    %eax
  801d5d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801d60:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d63:	ba 00 00 00 00       	mov    $0x0,%edx
  801d68:	f7 75 ec             	divl   -0x14(%ebp)
  801d6b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d6e:	29 d0                	sub    %edx,%eax
  801d70:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801d73:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801d7a:	e8 1e 06 00 00       	call   80239d <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d7f:	85 c0                	test   %eax,%eax
  801d81:	74 11                	je     801d94 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801d83:	83 ec 0c             	sub    $0xc,%esp
  801d86:	ff 75 e4             	pushl  -0x1c(%ebp)
  801d89:	e8 89 0c 00 00       	call   802a17 <alloc_block_FF>
  801d8e:	83 c4 10             	add    $0x10,%esp
  801d91:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  801d94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d98:	74 29                	je     801dc3 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801d9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d9d:	8b 40 08             	mov    0x8(%eax),%eax
  801da0:	83 ec 04             	sub    $0x4,%esp
  801da3:	50                   	push   %eax
  801da4:	ff 75 0c             	pushl  0xc(%ebp)
  801da7:	ff 75 08             	pushl  0x8(%ebp)
  801daa:	e8 ba 03 00 00       	call   802169 <sys_getSharedObject>
  801daf:	83 c4 10             	add    $0x10,%esp
  801db2:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  801db5:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  801db9:	74 08                	je     801dc3 <sget+0x9b>
				return (void *)mem_block->sva;
  801dbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dbe:	8b 40 08             	mov    0x8(%eax),%eax
  801dc1:	eb 05                	jmp    801dc8 <sget+0xa0>
		}
	}
	return NULL;
  801dc3:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801dc8:	c9                   	leave  
  801dc9:	c3                   	ret    

00801dca <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801dca:	55                   	push   %ebp
  801dcb:	89 e5                	mov    %esp,%ebp
  801dcd:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801dd0:	e8 5c fb ff ff       	call   801931 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801dd5:	83 ec 04             	sub    $0x4,%esp
  801dd8:	68 64 45 80 00       	push   $0x804564
  801ddd:	68 f7 00 00 00       	push   $0xf7
  801de2:	68 33 45 80 00       	push   $0x804533
  801de7:	e8 07 eb ff ff       	call   8008f3 <_panic>

00801dec <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801dec:	55                   	push   %ebp
  801ded:	89 e5                	mov    %esp,%ebp
  801def:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801df2:	83 ec 04             	sub    $0x4,%esp
  801df5:	68 8c 45 80 00       	push   $0x80458c
  801dfa:	68 0b 01 00 00       	push   $0x10b
  801dff:	68 33 45 80 00       	push   $0x804533
  801e04:	e8 ea ea ff ff       	call   8008f3 <_panic>

00801e09 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801e09:	55                   	push   %ebp
  801e0a:	89 e5                	mov    %esp,%ebp
  801e0c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e0f:	83 ec 04             	sub    $0x4,%esp
  801e12:	68 b0 45 80 00       	push   $0x8045b0
  801e17:	68 16 01 00 00       	push   $0x116
  801e1c:	68 33 45 80 00       	push   $0x804533
  801e21:	e8 cd ea ff ff       	call   8008f3 <_panic>

00801e26 <shrink>:

}
void shrink(uint32 newSize)
{
  801e26:	55                   	push   %ebp
  801e27:	89 e5                	mov    %esp,%ebp
  801e29:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e2c:	83 ec 04             	sub    $0x4,%esp
  801e2f:	68 b0 45 80 00       	push   $0x8045b0
  801e34:	68 1b 01 00 00       	push   $0x11b
  801e39:	68 33 45 80 00       	push   $0x804533
  801e3e:	e8 b0 ea ff ff       	call   8008f3 <_panic>

00801e43 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801e43:	55                   	push   %ebp
  801e44:	89 e5                	mov    %esp,%ebp
  801e46:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e49:	83 ec 04             	sub    $0x4,%esp
  801e4c:	68 b0 45 80 00       	push   $0x8045b0
  801e51:	68 20 01 00 00       	push   $0x120
  801e56:	68 33 45 80 00       	push   $0x804533
  801e5b:	e8 93 ea ff ff       	call   8008f3 <_panic>

00801e60 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801e60:	55                   	push   %ebp
  801e61:	89 e5                	mov    %esp,%ebp
  801e63:	57                   	push   %edi
  801e64:	56                   	push   %esi
  801e65:	53                   	push   %ebx
  801e66:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801e69:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e6f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e72:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e75:	8b 7d 18             	mov    0x18(%ebp),%edi
  801e78:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801e7b:	cd 30                	int    $0x30
  801e7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801e80:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801e83:	83 c4 10             	add    $0x10,%esp
  801e86:	5b                   	pop    %ebx
  801e87:	5e                   	pop    %esi
  801e88:	5f                   	pop    %edi
  801e89:	5d                   	pop    %ebp
  801e8a:	c3                   	ret    

00801e8b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801e8b:	55                   	push   %ebp
  801e8c:	89 e5                	mov    %esp,%ebp
  801e8e:	83 ec 04             	sub    $0x4,%esp
  801e91:	8b 45 10             	mov    0x10(%ebp),%eax
  801e94:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801e97:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9e:	6a 00                	push   $0x0
  801ea0:	6a 00                	push   $0x0
  801ea2:	52                   	push   %edx
  801ea3:	ff 75 0c             	pushl  0xc(%ebp)
  801ea6:	50                   	push   %eax
  801ea7:	6a 00                	push   $0x0
  801ea9:	e8 b2 ff ff ff       	call   801e60 <syscall>
  801eae:	83 c4 18             	add    $0x18,%esp
}
  801eb1:	90                   	nop
  801eb2:	c9                   	leave  
  801eb3:	c3                   	ret    

00801eb4 <sys_cgetc>:

int
sys_cgetc(void)
{
  801eb4:	55                   	push   %ebp
  801eb5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 00                	push   $0x0
  801ebd:	6a 00                	push   $0x0
  801ebf:	6a 00                	push   $0x0
  801ec1:	6a 01                	push   $0x1
  801ec3:	e8 98 ff ff ff       	call   801e60 <syscall>
  801ec8:	83 c4 18             	add    $0x18,%esp
}
  801ecb:	c9                   	leave  
  801ecc:	c3                   	ret    

00801ecd <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801ecd:	55                   	push   %ebp
  801ece:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801ed0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed6:	6a 00                	push   $0x0
  801ed8:	6a 00                	push   $0x0
  801eda:	6a 00                	push   $0x0
  801edc:	52                   	push   %edx
  801edd:	50                   	push   %eax
  801ede:	6a 05                	push   $0x5
  801ee0:	e8 7b ff ff ff       	call   801e60 <syscall>
  801ee5:	83 c4 18             	add    $0x18,%esp
}
  801ee8:	c9                   	leave  
  801ee9:	c3                   	ret    

00801eea <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801eea:	55                   	push   %ebp
  801eeb:	89 e5                	mov    %esp,%ebp
  801eed:	56                   	push   %esi
  801eee:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801eef:	8b 75 18             	mov    0x18(%ebp),%esi
  801ef2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ef5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ef8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801efb:	8b 45 08             	mov    0x8(%ebp),%eax
  801efe:	56                   	push   %esi
  801eff:	53                   	push   %ebx
  801f00:	51                   	push   %ecx
  801f01:	52                   	push   %edx
  801f02:	50                   	push   %eax
  801f03:	6a 06                	push   $0x6
  801f05:	e8 56 ff ff ff       	call   801e60 <syscall>
  801f0a:	83 c4 18             	add    $0x18,%esp
}
  801f0d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f10:	5b                   	pop    %ebx
  801f11:	5e                   	pop    %esi
  801f12:	5d                   	pop    %ebp
  801f13:	c3                   	ret    

00801f14 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801f14:	55                   	push   %ebp
  801f15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801f17:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1d:	6a 00                	push   $0x0
  801f1f:	6a 00                	push   $0x0
  801f21:	6a 00                	push   $0x0
  801f23:	52                   	push   %edx
  801f24:	50                   	push   %eax
  801f25:	6a 07                	push   $0x7
  801f27:	e8 34 ff ff ff       	call   801e60 <syscall>
  801f2c:	83 c4 18             	add    $0x18,%esp
}
  801f2f:	c9                   	leave  
  801f30:	c3                   	ret    

00801f31 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801f31:	55                   	push   %ebp
  801f32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801f34:	6a 00                	push   $0x0
  801f36:	6a 00                	push   $0x0
  801f38:	6a 00                	push   $0x0
  801f3a:	ff 75 0c             	pushl  0xc(%ebp)
  801f3d:	ff 75 08             	pushl  0x8(%ebp)
  801f40:	6a 08                	push   $0x8
  801f42:	e8 19 ff ff ff       	call   801e60 <syscall>
  801f47:	83 c4 18             	add    $0x18,%esp
}
  801f4a:	c9                   	leave  
  801f4b:	c3                   	ret    

00801f4c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801f4c:	55                   	push   %ebp
  801f4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801f4f:	6a 00                	push   $0x0
  801f51:	6a 00                	push   $0x0
  801f53:	6a 00                	push   $0x0
  801f55:	6a 00                	push   $0x0
  801f57:	6a 00                	push   $0x0
  801f59:	6a 09                	push   $0x9
  801f5b:	e8 00 ff ff ff       	call   801e60 <syscall>
  801f60:	83 c4 18             	add    $0x18,%esp
}
  801f63:	c9                   	leave  
  801f64:	c3                   	ret    

00801f65 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801f65:	55                   	push   %ebp
  801f66:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801f68:	6a 00                	push   $0x0
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 00                	push   $0x0
  801f6e:	6a 00                	push   $0x0
  801f70:	6a 00                	push   $0x0
  801f72:	6a 0a                	push   $0xa
  801f74:	e8 e7 fe ff ff       	call   801e60 <syscall>
  801f79:	83 c4 18             	add    $0x18,%esp
}
  801f7c:	c9                   	leave  
  801f7d:	c3                   	ret    

00801f7e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801f7e:	55                   	push   %ebp
  801f7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801f81:	6a 00                	push   $0x0
  801f83:	6a 00                	push   $0x0
  801f85:	6a 00                	push   $0x0
  801f87:	6a 00                	push   $0x0
  801f89:	6a 00                	push   $0x0
  801f8b:	6a 0b                	push   $0xb
  801f8d:	e8 ce fe ff ff       	call   801e60 <syscall>
  801f92:	83 c4 18             	add    $0x18,%esp
}
  801f95:	c9                   	leave  
  801f96:	c3                   	ret    

00801f97 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801f97:	55                   	push   %ebp
  801f98:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801f9a:	6a 00                	push   $0x0
  801f9c:	6a 00                	push   $0x0
  801f9e:	6a 00                	push   $0x0
  801fa0:	ff 75 0c             	pushl  0xc(%ebp)
  801fa3:	ff 75 08             	pushl  0x8(%ebp)
  801fa6:	6a 0f                	push   $0xf
  801fa8:	e8 b3 fe ff ff       	call   801e60 <syscall>
  801fad:	83 c4 18             	add    $0x18,%esp
	return;
  801fb0:	90                   	nop
}
  801fb1:	c9                   	leave  
  801fb2:	c3                   	ret    

00801fb3 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801fb3:	55                   	push   %ebp
  801fb4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801fb6:	6a 00                	push   $0x0
  801fb8:	6a 00                	push   $0x0
  801fba:	6a 00                	push   $0x0
  801fbc:	ff 75 0c             	pushl  0xc(%ebp)
  801fbf:	ff 75 08             	pushl  0x8(%ebp)
  801fc2:	6a 10                	push   $0x10
  801fc4:	e8 97 fe ff ff       	call   801e60 <syscall>
  801fc9:	83 c4 18             	add    $0x18,%esp
	return ;
  801fcc:	90                   	nop
}
  801fcd:	c9                   	leave  
  801fce:	c3                   	ret    

00801fcf <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801fcf:	55                   	push   %ebp
  801fd0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801fd2:	6a 00                	push   $0x0
  801fd4:	6a 00                	push   $0x0
  801fd6:	ff 75 10             	pushl  0x10(%ebp)
  801fd9:	ff 75 0c             	pushl  0xc(%ebp)
  801fdc:	ff 75 08             	pushl  0x8(%ebp)
  801fdf:	6a 11                	push   $0x11
  801fe1:	e8 7a fe ff ff       	call   801e60 <syscall>
  801fe6:	83 c4 18             	add    $0x18,%esp
	return ;
  801fe9:	90                   	nop
}
  801fea:	c9                   	leave  
  801feb:	c3                   	ret    

00801fec <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801fec:	55                   	push   %ebp
  801fed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801fef:	6a 00                	push   $0x0
  801ff1:	6a 00                	push   $0x0
  801ff3:	6a 00                	push   $0x0
  801ff5:	6a 00                	push   $0x0
  801ff7:	6a 00                	push   $0x0
  801ff9:	6a 0c                	push   $0xc
  801ffb:	e8 60 fe ff ff       	call   801e60 <syscall>
  802000:	83 c4 18             	add    $0x18,%esp
}
  802003:	c9                   	leave  
  802004:	c3                   	ret    

00802005 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802005:	55                   	push   %ebp
  802006:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802008:	6a 00                	push   $0x0
  80200a:	6a 00                	push   $0x0
  80200c:	6a 00                	push   $0x0
  80200e:	6a 00                	push   $0x0
  802010:	ff 75 08             	pushl  0x8(%ebp)
  802013:	6a 0d                	push   $0xd
  802015:	e8 46 fe ff ff       	call   801e60 <syscall>
  80201a:	83 c4 18             	add    $0x18,%esp
}
  80201d:	c9                   	leave  
  80201e:	c3                   	ret    

0080201f <sys_scarce_memory>:

void sys_scarce_memory()
{
  80201f:	55                   	push   %ebp
  802020:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802022:	6a 00                	push   $0x0
  802024:	6a 00                	push   $0x0
  802026:	6a 00                	push   $0x0
  802028:	6a 00                	push   $0x0
  80202a:	6a 00                	push   $0x0
  80202c:	6a 0e                	push   $0xe
  80202e:	e8 2d fe ff ff       	call   801e60 <syscall>
  802033:	83 c4 18             	add    $0x18,%esp
}
  802036:	90                   	nop
  802037:	c9                   	leave  
  802038:	c3                   	ret    

00802039 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802039:	55                   	push   %ebp
  80203a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80203c:	6a 00                	push   $0x0
  80203e:	6a 00                	push   $0x0
  802040:	6a 00                	push   $0x0
  802042:	6a 00                	push   $0x0
  802044:	6a 00                	push   $0x0
  802046:	6a 13                	push   $0x13
  802048:	e8 13 fe ff ff       	call   801e60 <syscall>
  80204d:	83 c4 18             	add    $0x18,%esp
}
  802050:	90                   	nop
  802051:	c9                   	leave  
  802052:	c3                   	ret    

00802053 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802053:	55                   	push   %ebp
  802054:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802056:	6a 00                	push   $0x0
  802058:	6a 00                	push   $0x0
  80205a:	6a 00                	push   $0x0
  80205c:	6a 00                	push   $0x0
  80205e:	6a 00                	push   $0x0
  802060:	6a 14                	push   $0x14
  802062:	e8 f9 fd ff ff       	call   801e60 <syscall>
  802067:	83 c4 18             	add    $0x18,%esp
}
  80206a:	90                   	nop
  80206b:	c9                   	leave  
  80206c:	c3                   	ret    

0080206d <sys_cputc>:


void
sys_cputc(const char c)
{
  80206d:	55                   	push   %ebp
  80206e:	89 e5                	mov    %esp,%ebp
  802070:	83 ec 04             	sub    $0x4,%esp
  802073:	8b 45 08             	mov    0x8(%ebp),%eax
  802076:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802079:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80207d:	6a 00                	push   $0x0
  80207f:	6a 00                	push   $0x0
  802081:	6a 00                	push   $0x0
  802083:	6a 00                	push   $0x0
  802085:	50                   	push   %eax
  802086:	6a 15                	push   $0x15
  802088:	e8 d3 fd ff ff       	call   801e60 <syscall>
  80208d:	83 c4 18             	add    $0x18,%esp
}
  802090:	90                   	nop
  802091:	c9                   	leave  
  802092:	c3                   	ret    

00802093 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802093:	55                   	push   %ebp
  802094:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802096:	6a 00                	push   $0x0
  802098:	6a 00                	push   $0x0
  80209a:	6a 00                	push   $0x0
  80209c:	6a 00                	push   $0x0
  80209e:	6a 00                	push   $0x0
  8020a0:	6a 16                	push   $0x16
  8020a2:	e8 b9 fd ff ff       	call   801e60 <syscall>
  8020a7:	83 c4 18             	add    $0x18,%esp
}
  8020aa:	90                   	nop
  8020ab:	c9                   	leave  
  8020ac:	c3                   	ret    

008020ad <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8020ad:	55                   	push   %ebp
  8020ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8020b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b3:	6a 00                	push   $0x0
  8020b5:	6a 00                	push   $0x0
  8020b7:	6a 00                	push   $0x0
  8020b9:	ff 75 0c             	pushl  0xc(%ebp)
  8020bc:	50                   	push   %eax
  8020bd:	6a 17                	push   $0x17
  8020bf:	e8 9c fd ff ff       	call   801e60 <syscall>
  8020c4:	83 c4 18             	add    $0x18,%esp
}
  8020c7:	c9                   	leave  
  8020c8:	c3                   	ret    

008020c9 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8020c9:	55                   	push   %ebp
  8020ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8020cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d2:	6a 00                	push   $0x0
  8020d4:	6a 00                	push   $0x0
  8020d6:	6a 00                	push   $0x0
  8020d8:	52                   	push   %edx
  8020d9:	50                   	push   %eax
  8020da:	6a 1a                	push   $0x1a
  8020dc:	e8 7f fd ff ff       	call   801e60 <syscall>
  8020e1:	83 c4 18             	add    $0x18,%esp
}
  8020e4:	c9                   	leave  
  8020e5:	c3                   	ret    

008020e6 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8020e6:	55                   	push   %ebp
  8020e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8020e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ef:	6a 00                	push   $0x0
  8020f1:	6a 00                	push   $0x0
  8020f3:	6a 00                	push   $0x0
  8020f5:	52                   	push   %edx
  8020f6:	50                   	push   %eax
  8020f7:	6a 18                	push   $0x18
  8020f9:	e8 62 fd ff ff       	call   801e60 <syscall>
  8020fe:	83 c4 18             	add    $0x18,%esp
}
  802101:	90                   	nop
  802102:	c9                   	leave  
  802103:	c3                   	ret    

00802104 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802104:	55                   	push   %ebp
  802105:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802107:	8b 55 0c             	mov    0xc(%ebp),%edx
  80210a:	8b 45 08             	mov    0x8(%ebp),%eax
  80210d:	6a 00                	push   $0x0
  80210f:	6a 00                	push   $0x0
  802111:	6a 00                	push   $0x0
  802113:	52                   	push   %edx
  802114:	50                   	push   %eax
  802115:	6a 19                	push   $0x19
  802117:	e8 44 fd ff ff       	call   801e60 <syscall>
  80211c:	83 c4 18             	add    $0x18,%esp
}
  80211f:	90                   	nop
  802120:	c9                   	leave  
  802121:	c3                   	ret    

00802122 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802122:	55                   	push   %ebp
  802123:	89 e5                	mov    %esp,%ebp
  802125:	83 ec 04             	sub    $0x4,%esp
  802128:	8b 45 10             	mov    0x10(%ebp),%eax
  80212b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80212e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802131:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802135:	8b 45 08             	mov    0x8(%ebp),%eax
  802138:	6a 00                	push   $0x0
  80213a:	51                   	push   %ecx
  80213b:	52                   	push   %edx
  80213c:	ff 75 0c             	pushl  0xc(%ebp)
  80213f:	50                   	push   %eax
  802140:	6a 1b                	push   $0x1b
  802142:	e8 19 fd ff ff       	call   801e60 <syscall>
  802147:	83 c4 18             	add    $0x18,%esp
}
  80214a:	c9                   	leave  
  80214b:	c3                   	ret    

0080214c <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80214c:	55                   	push   %ebp
  80214d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80214f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802152:	8b 45 08             	mov    0x8(%ebp),%eax
  802155:	6a 00                	push   $0x0
  802157:	6a 00                	push   $0x0
  802159:	6a 00                	push   $0x0
  80215b:	52                   	push   %edx
  80215c:	50                   	push   %eax
  80215d:	6a 1c                	push   $0x1c
  80215f:	e8 fc fc ff ff       	call   801e60 <syscall>
  802164:	83 c4 18             	add    $0x18,%esp
}
  802167:	c9                   	leave  
  802168:	c3                   	ret    

00802169 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802169:	55                   	push   %ebp
  80216a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80216c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80216f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802172:	8b 45 08             	mov    0x8(%ebp),%eax
  802175:	6a 00                	push   $0x0
  802177:	6a 00                	push   $0x0
  802179:	51                   	push   %ecx
  80217a:	52                   	push   %edx
  80217b:	50                   	push   %eax
  80217c:	6a 1d                	push   $0x1d
  80217e:	e8 dd fc ff ff       	call   801e60 <syscall>
  802183:	83 c4 18             	add    $0x18,%esp
}
  802186:	c9                   	leave  
  802187:	c3                   	ret    

00802188 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802188:	55                   	push   %ebp
  802189:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80218b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80218e:	8b 45 08             	mov    0x8(%ebp),%eax
  802191:	6a 00                	push   $0x0
  802193:	6a 00                	push   $0x0
  802195:	6a 00                	push   $0x0
  802197:	52                   	push   %edx
  802198:	50                   	push   %eax
  802199:	6a 1e                	push   $0x1e
  80219b:	e8 c0 fc ff ff       	call   801e60 <syscall>
  8021a0:	83 c4 18             	add    $0x18,%esp
}
  8021a3:	c9                   	leave  
  8021a4:	c3                   	ret    

008021a5 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8021a5:	55                   	push   %ebp
  8021a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8021a8:	6a 00                	push   $0x0
  8021aa:	6a 00                	push   $0x0
  8021ac:	6a 00                	push   $0x0
  8021ae:	6a 00                	push   $0x0
  8021b0:	6a 00                	push   $0x0
  8021b2:	6a 1f                	push   $0x1f
  8021b4:	e8 a7 fc ff ff       	call   801e60 <syscall>
  8021b9:	83 c4 18             	add    $0x18,%esp
}
  8021bc:	c9                   	leave  
  8021bd:	c3                   	ret    

008021be <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8021be:	55                   	push   %ebp
  8021bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8021c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c4:	6a 00                	push   $0x0
  8021c6:	ff 75 14             	pushl  0x14(%ebp)
  8021c9:	ff 75 10             	pushl  0x10(%ebp)
  8021cc:	ff 75 0c             	pushl  0xc(%ebp)
  8021cf:	50                   	push   %eax
  8021d0:	6a 20                	push   $0x20
  8021d2:	e8 89 fc ff ff       	call   801e60 <syscall>
  8021d7:	83 c4 18             	add    $0x18,%esp
}
  8021da:	c9                   	leave  
  8021db:	c3                   	ret    

008021dc <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8021dc:	55                   	push   %ebp
  8021dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8021df:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e2:	6a 00                	push   $0x0
  8021e4:	6a 00                	push   $0x0
  8021e6:	6a 00                	push   $0x0
  8021e8:	6a 00                	push   $0x0
  8021ea:	50                   	push   %eax
  8021eb:	6a 21                	push   $0x21
  8021ed:	e8 6e fc ff ff       	call   801e60 <syscall>
  8021f2:	83 c4 18             	add    $0x18,%esp
}
  8021f5:	90                   	nop
  8021f6:	c9                   	leave  
  8021f7:	c3                   	ret    

008021f8 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8021f8:	55                   	push   %ebp
  8021f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8021fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fe:	6a 00                	push   $0x0
  802200:	6a 00                	push   $0x0
  802202:	6a 00                	push   $0x0
  802204:	6a 00                	push   $0x0
  802206:	50                   	push   %eax
  802207:	6a 22                	push   $0x22
  802209:	e8 52 fc ff ff       	call   801e60 <syscall>
  80220e:	83 c4 18             	add    $0x18,%esp
}
  802211:	c9                   	leave  
  802212:	c3                   	ret    

00802213 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802213:	55                   	push   %ebp
  802214:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802216:	6a 00                	push   $0x0
  802218:	6a 00                	push   $0x0
  80221a:	6a 00                	push   $0x0
  80221c:	6a 00                	push   $0x0
  80221e:	6a 00                	push   $0x0
  802220:	6a 02                	push   $0x2
  802222:	e8 39 fc ff ff       	call   801e60 <syscall>
  802227:	83 c4 18             	add    $0x18,%esp
}
  80222a:	c9                   	leave  
  80222b:	c3                   	ret    

0080222c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80222c:	55                   	push   %ebp
  80222d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80222f:	6a 00                	push   $0x0
  802231:	6a 00                	push   $0x0
  802233:	6a 00                	push   $0x0
  802235:	6a 00                	push   $0x0
  802237:	6a 00                	push   $0x0
  802239:	6a 03                	push   $0x3
  80223b:	e8 20 fc ff ff       	call   801e60 <syscall>
  802240:	83 c4 18             	add    $0x18,%esp
}
  802243:	c9                   	leave  
  802244:	c3                   	ret    

00802245 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802245:	55                   	push   %ebp
  802246:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802248:	6a 00                	push   $0x0
  80224a:	6a 00                	push   $0x0
  80224c:	6a 00                	push   $0x0
  80224e:	6a 00                	push   $0x0
  802250:	6a 00                	push   $0x0
  802252:	6a 04                	push   $0x4
  802254:	e8 07 fc ff ff       	call   801e60 <syscall>
  802259:	83 c4 18             	add    $0x18,%esp
}
  80225c:	c9                   	leave  
  80225d:	c3                   	ret    

0080225e <sys_exit_env>:


void sys_exit_env(void)
{
  80225e:	55                   	push   %ebp
  80225f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802261:	6a 00                	push   $0x0
  802263:	6a 00                	push   $0x0
  802265:	6a 00                	push   $0x0
  802267:	6a 00                	push   $0x0
  802269:	6a 00                	push   $0x0
  80226b:	6a 23                	push   $0x23
  80226d:	e8 ee fb ff ff       	call   801e60 <syscall>
  802272:	83 c4 18             	add    $0x18,%esp
}
  802275:	90                   	nop
  802276:	c9                   	leave  
  802277:	c3                   	ret    

00802278 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802278:	55                   	push   %ebp
  802279:	89 e5                	mov    %esp,%ebp
  80227b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80227e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802281:	8d 50 04             	lea    0x4(%eax),%edx
  802284:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802287:	6a 00                	push   $0x0
  802289:	6a 00                	push   $0x0
  80228b:	6a 00                	push   $0x0
  80228d:	52                   	push   %edx
  80228e:	50                   	push   %eax
  80228f:	6a 24                	push   $0x24
  802291:	e8 ca fb ff ff       	call   801e60 <syscall>
  802296:	83 c4 18             	add    $0x18,%esp
	return result;
  802299:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80229c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80229f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8022a2:	89 01                	mov    %eax,(%ecx)
  8022a4:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8022a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022aa:	c9                   	leave  
  8022ab:	c2 04 00             	ret    $0x4

008022ae <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8022ae:	55                   	push   %ebp
  8022af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8022b1:	6a 00                	push   $0x0
  8022b3:	6a 00                	push   $0x0
  8022b5:	ff 75 10             	pushl  0x10(%ebp)
  8022b8:	ff 75 0c             	pushl  0xc(%ebp)
  8022bb:	ff 75 08             	pushl  0x8(%ebp)
  8022be:	6a 12                	push   $0x12
  8022c0:	e8 9b fb ff ff       	call   801e60 <syscall>
  8022c5:	83 c4 18             	add    $0x18,%esp
	return ;
  8022c8:	90                   	nop
}
  8022c9:	c9                   	leave  
  8022ca:	c3                   	ret    

008022cb <sys_rcr2>:
uint32 sys_rcr2()
{
  8022cb:	55                   	push   %ebp
  8022cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8022ce:	6a 00                	push   $0x0
  8022d0:	6a 00                	push   $0x0
  8022d2:	6a 00                	push   $0x0
  8022d4:	6a 00                	push   $0x0
  8022d6:	6a 00                	push   $0x0
  8022d8:	6a 25                	push   $0x25
  8022da:	e8 81 fb ff ff       	call   801e60 <syscall>
  8022df:	83 c4 18             	add    $0x18,%esp
}
  8022e2:	c9                   	leave  
  8022e3:	c3                   	ret    

008022e4 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8022e4:	55                   	push   %ebp
  8022e5:	89 e5                	mov    %esp,%ebp
  8022e7:	83 ec 04             	sub    $0x4,%esp
  8022ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ed:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8022f0:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8022f4:	6a 00                	push   $0x0
  8022f6:	6a 00                	push   $0x0
  8022f8:	6a 00                	push   $0x0
  8022fa:	6a 00                	push   $0x0
  8022fc:	50                   	push   %eax
  8022fd:	6a 26                	push   $0x26
  8022ff:	e8 5c fb ff ff       	call   801e60 <syscall>
  802304:	83 c4 18             	add    $0x18,%esp
	return ;
  802307:	90                   	nop
}
  802308:	c9                   	leave  
  802309:	c3                   	ret    

0080230a <rsttst>:
void rsttst()
{
  80230a:	55                   	push   %ebp
  80230b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80230d:	6a 00                	push   $0x0
  80230f:	6a 00                	push   $0x0
  802311:	6a 00                	push   $0x0
  802313:	6a 00                	push   $0x0
  802315:	6a 00                	push   $0x0
  802317:	6a 28                	push   $0x28
  802319:	e8 42 fb ff ff       	call   801e60 <syscall>
  80231e:	83 c4 18             	add    $0x18,%esp
	return ;
  802321:	90                   	nop
}
  802322:	c9                   	leave  
  802323:	c3                   	ret    

00802324 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802324:	55                   	push   %ebp
  802325:	89 e5                	mov    %esp,%ebp
  802327:	83 ec 04             	sub    $0x4,%esp
  80232a:	8b 45 14             	mov    0x14(%ebp),%eax
  80232d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802330:	8b 55 18             	mov    0x18(%ebp),%edx
  802333:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802337:	52                   	push   %edx
  802338:	50                   	push   %eax
  802339:	ff 75 10             	pushl  0x10(%ebp)
  80233c:	ff 75 0c             	pushl  0xc(%ebp)
  80233f:	ff 75 08             	pushl  0x8(%ebp)
  802342:	6a 27                	push   $0x27
  802344:	e8 17 fb ff ff       	call   801e60 <syscall>
  802349:	83 c4 18             	add    $0x18,%esp
	return ;
  80234c:	90                   	nop
}
  80234d:	c9                   	leave  
  80234e:	c3                   	ret    

0080234f <chktst>:
void chktst(uint32 n)
{
  80234f:	55                   	push   %ebp
  802350:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802352:	6a 00                	push   $0x0
  802354:	6a 00                	push   $0x0
  802356:	6a 00                	push   $0x0
  802358:	6a 00                	push   $0x0
  80235a:	ff 75 08             	pushl  0x8(%ebp)
  80235d:	6a 29                	push   $0x29
  80235f:	e8 fc fa ff ff       	call   801e60 <syscall>
  802364:	83 c4 18             	add    $0x18,%esp
	return ;
  802367:	90                   	nop
}
  802368:	c9                   	leave  
  802369:	c3                   	ret    

0080236a <inctst>:

void inctst()
{
  80236a:	55                   	push   %ebp
  80236b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80236d:	6a 00                	push   $0x0
  80236f:	6a 00                	push   $0x0
  802371:	6a 00                	push   $0x0
  802373:	6a 00                	push   $0x0
  802375:	6a 00                	push   $0x0
  802377:	6a 2a                	push   $0x2a
  802379:	e8 e2 fa ff ff       	call   801e60 <syscall>
  80237e:	83 c4 18             	add    $0x18,%esp
	return ;
  802381:	90                   	nop
}
  802382:	c9                   	leave  
  802383:	c3                   	ret    

00802384 <gettst>:
uint32 gettst()
{
  802384:	55                   	push   %ebp
  802385:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802387:	6a 00                	push   $0x0
  802389:	6a 00                	push   $0x0
  80238b:	6a 00                	push   $0x0
  80238d:	6a 00                	push   $0x0
  80238f:	6a 00                	push   $0x0
  802391:	6a 2b                	push   $0x2b
  802393:	e8 c8 fa ff ff       	call   801e60 <syscall>
  802398:	83 c4 18             	add    $0x18,%esp
}
  80239b:	c9                   	leave  
  80239c:	c3                   	ret    

0080239d <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80239d:	55                   	push   %ebp
  80239e:	89 e5                	mov    %esp,%ebp
  8023a0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023a3:	6a 00                	push   $0x0
  8023a5:	6a 00                	push   $0x0
  8023a7:	6a 00                	push   $0x0
  8023a9:	6a 00                	push   $0x0
  8023ab:	6a 00                	push   $0x0
  8023ad:	6a 2c                	push   $0x2c
  8023af:	e8 ac fa ff ff       	call   801e60 <syscall>
  8023b4:	83 c4 18             	add    $0x18,%esp
  8023b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8023ba:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8023be:	75 07                	jne    8023c7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8023c0:	b8 01 00 00 00       	mov    $0x1,%eax
  8023c5:	eb 05                	jmp    8023cc <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8023c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023cc:	c9                   	leave  
  8023cd:	c3                   	ret    

008023ce <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8023ce:	55                   	push   %ebp
  8023cf:	89 e5                	mov    %esp,%ebp
  8023d1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023d4:	6a 00                	push   $0x0
  8023d6:	6a 00                	push   $0x0
  8023d8:	6a 00                	push   $0x0
  8023da:	6a 00                	push   $0x0
  8023dc:	6a 00                	push   $0x0
  8023de:	6a 2c                	push   $0x2c
  8023e0:	e8 7b fa ff ff       	call   801e60 <syscall>
  8023e5:	83 c4 18             	add    $0x18,%esp
  8023e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8023eb:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8023ef:	75 07                	jne    8023f8 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8023f1:	b8 01 00 00 00       	mov    $0x1,%eax
  8023f6:	eb 05                	jmp    8023fd <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8023f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023fd:	c9                   	leave  
  8023fe:	c3                   	ret    

008023ff <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8023ff:	55                   	push   %ebp
  802400:	89 e5                	mov    %esp,%ebp
  802402:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802405:	6a 00                	push   $0x0
  802407:	6a 00                	push   $0x0
  802409:	6a 00                	push   $0x0
  80240b:	6a 00                	push   $0x0
  80240d:	6a 00                	push   $0x0
  80240f:	6a 2c                	push   $0x2c
  802411:	e8 4a fa ff ff       	call   801e60 <syscall>
  802416:	83 c4 18             	add    $0x18,%esp
  802419:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80241c:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802420:	75 07                	jne    802429 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802422:	b8 01 00 00 00       	mov    $0x1,%eax
  802427:	eb 05                	jmp    80242e <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802429:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80242e:	c9                   	leave  
  80242f:	c3                   	ret    

00802430 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802430:	55                   	push   %ebp
  802431:	89 e5                	mov    %esp,%ebp
  802433:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802436:	6a 00                	push   $0x0
  802438:	6a 00                	push   $0x0
  80243a:	6a 00                	push   $0x0
  80243c:	6a 00                	push   $0x0
  80243e:	6a 00                	push   $0x0
  802440:	6a 2c                	push   $0x2c
  802442:	e8 19 fa ff ff       	call   801e60 <syscall>
  802447:	83 c4 18             	add    $0x18,%esp
  80244a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80244d:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802451:	75 07                	jne    80245a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802453:	b8 01 00 00 00       	mov    $0x1,%eax
  802458:	eb 05                	jmp    80245f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80245a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80245f:	c9                   	leave  
  802460:	c3                   	ret    

00802461 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802461:	55                   	push   %ebp
  802462:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802464:	6a 00                	push   $0x0
  802466:	6a 00                	push   $0x0
  802468:	6a 00                	push   $0x0
  80246a:	6a 00                	push   $0x0
  80246c:	ff 75 08             	pushl  0x8(%ebp)
  80246f:	6a 2d                	push   $0x2d
  802471:	e8 ea f9 ff ff       	call   801e60 <syscall>
  802476:	83 c4 18             	add    $0x18,%esp
	return ;
  802479:	90                   	nop
}
  80247a:	c9                   	leave  
  80247b:	c3                   	ret    

0080247c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80247c:	55                   	push   %ebp
  80247d:	89 e5                	mov    %esp,%ebp
  80247f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802480:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802483:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802486:	8b 55 0c             	mov    0xc(%ebp),%edx
  802489:	8b 45 08             	mov    0x8(%ebp),%eax
  80248c:	6a 00                	push   $0x0
  80248e:	53                   	push   %ebx
  80248f:	51                   	push   %ecx
  802490:	52                   	push   %edx
  802491:	50                   	push   %eax
  802492:	6a 2e                	push   $0x2e
  802494:	e8 c7 f9 ff ff       	call   801e60 <syscall>
  802499:	83 c4 18             	add    $0x18,%esp
}
  80249c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80249f:	c9                   	leave  
  8024a0:	c3                   	ret    

008024a1 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8024a1:	55                   	push   %ebp
  8024a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8024a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024aa:	6a 00                	push   $0x0
  8024ac:	6a 00                	push   $0x0
  8024ae:	6a 00                	push   $0x0
  8024b0:	52                   	push   %edx
  8024b1:	50                   	push   %eax
  8024b2:	6a 2f                	push   $0x2f
  8024b4:	e8 a7 f9 ff ff       	call   801e60 <syscall>
  8024b9:	83 c4 18             	add    $0x18,%esp
}
  8024bc:	c9                   	leave  
  8024bd:	c3                   	ret    

008024be <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8024be:	55                   	push   %ebp
  8024bf:	89 e5                	mov    %esp,%ebp
  8024c1:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8024c4:	83 ec 0c             	sub    $0xc,%esp
  8024c7:	68 c0 45 80 00       	push   $0x8045c0
  8024cc:	e8 d6 e6 ff ff       	call   800ba7 <cprintf>
  8024d1:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8024d4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8024db:	83 ec 0c             	sub    $0xc,%esp
  8024de:	68 ec 45 80 00       	push   $0x8045ec
  8024e3:	e8 bf e6 ff ff       	call   800ba7 <cprintf>
  8024e8:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8024eb:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8024ef:	a1 38 51 80 00       	mov    0x805138,%eax
  8024f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024f7:	eb 56                	jmp    80254f <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8024f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024fd:	74 1c                	je     80251b <print_mem_block_lists+0x5d>
  8024ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802502:	8b 50 08             	mov    0x8(%eax),%edx
  802505:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802508:	8b 48 08             	mov    0x8(%eax),%ecx
  80250b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80250e:	8b 40 0c             	mov    0xc(%eax),%eax
  802511:	01 c8                	add    %ecx,%eax
  802513:	39 c2                	cmp    %eax,%edx
  802515:	73 04                	jae    80251b <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802517:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80251b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251e:	8b 50 08             	mov    0x8(%eax),%edx
  802521:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802524:	8b 40 0c             	mov    0xc(%eax),%eax
  802527:	01 c2                	add    %eax,%edx
  802529:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252c:	8b 40 08             	mov    0x8(%eax),%eax
  80252f:	83 ec 04             	sub    $0x4,%esp
  802532:	52                   	push   %edx
  802533:	50                   	push   %eax
  802534:	68 01 46 80 00       	push   $0x804601
  802539:	e8 69 e6 ff ff       	call   800ba7 <cprintf>
  80253e:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802541:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802544:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802547:	a1 40 51 80 00       	mov    0x805140,%eax
  80254c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80254f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802553:	74 07                	je     80255c <print_mem_block_lists+0x9e>
  802555:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802558:	8b 00                	mov    (%eax),%eax
  80255a:	eb 05                	jmp    802561 <print_mem_block_lists+0xa3>
  80255c:	b8 00 00 00 00       	mov    $0x0,%eax
  802561:	a3 40 51 80 00       	mov    %eax,0x805140
  802566:	a1 40 51 80 00       	mov    0x805140,%eax
  80256b:	85 c0                	test   %eax,%eax
  80256d:	75 8a                	jne    8024f9 <print_mem_block_lists+0x3b>
  80256f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802573:	75 84                	jne    8024f9 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802575:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802579:	75 10                	jne    80258b <print_mem_block_lists+0xcd>
  80257b:	83 ec 0c             	sub    $0xc,%esp
  80257e:	68 10 46 80 00       	push   $0x804610
  802583:	e8 1f e6 ff ff       	call   800ba7 <cprintf>
  802588:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80258b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802592:	83 ec 0c             	sub    $0xc,%esp
  802595:	68 34 46 80 00       	push   $0x804634
  80259a:	e8 08 e6 ff ff       	call   800ba7 <cprintf>
  80259f:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8025a2:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8025a6:	a1 40 50 80 00       	mov    0x805040,%eax
  8025ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025ae:	eb 56                	jmp    802606 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8025b0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025b4:	74 1c                	je     8025d2 <print_mem_block_lists+0x114>
  8025b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b9:	8b 50 08             	mov    0x8(%eax),%edx
  8025bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025bf:	8b 48 08             	mov    0x8(%eax),%ecx
  8025c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8025c8:	01 c8                	add    %ecx,%eax
  8025ca:	39 c2                	cmp    %eax,%edx
  8025cc:	73 04                	jae    8025d2 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8025ce:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8025d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d5:	8b 50 08             	mov    0x8(%eax),%edx
  8025d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025db:	8b 40 0c             	mov    0xc(%eax),%eax
  8025de:	01 c2                	add    %eax,%edx
  8025e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e3:	8b 40 08             	mov    0x8(%eax),%eax
  8025e6:	83 ec 04             	sub    $0x4,%esp
  8025e9:	52                   	push   %edx
  8025ea:	50                   	push   %eax
  8025eb:	68 01 46 80 00       	push   $0x804601
  8025f0:	e8 b2 e5 ff ff       	call   800ba7 <cprintf>
  8025f5:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8025f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8025fe:	a1 48 50 80 00       	mov    0x805048,%eax
  802603:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802606:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80260a:	74 07                	je     802613 <print_mem_block_lists+0x155>
  80260c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260f:	8b 00                	mov    (%eax),%eax
  802611:	eb 05                	jmp    802618 <print_mem_block_lists+0x15a>
  802613:	b8 00 00 00 00       	mov    $0x0,%eax
  802618:	a3 48 50 80 00       	mov    %eax,0x805048
  80261d:	a1 48 50 80 00       	mov    0x805048,%eax
  802622:	85 c0                	test   %eax,%eax
  802624:	75 8a                	jne    8025b0 <print_mem_block_lists+0xf2>
  802626:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80262a:	75 84                	jne    8025b0 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80262c:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802630:	75 10                	jne    802642 <print_mem_block_lists+0x184>
  802632:	83 ec 0c             	sub    $0xc,%esp
  802635:	68 4c 46 80 00       	push   $0x80464c
  80263a:	e8 68 e5 ff ff       	call   800ba7 <cprintf>
  80263f:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802642:	83 ec 0c             	sub    $0xc,%esp
  802645:	68 c0 45 80 00       	push   $0x8045c0
  80264a:	e8 58 e5 ff ff       	call   800ba7 <cprintf>
  80264f:	83 c4 10             	add    $0x10,%esp

}
  802652:	90                   	nop
  802653:	c9                   	leave  
  802654:	c3                   	ret    

00802655 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802655:	55                   	push   %ebp
  802656:	89 e5                	mov    %esp,%ebp
  802658:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  80265b:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802662:	00 00 00 
  802665:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80266c:	00 00 00 
  80266f:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802676:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802679:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802680:	e9 9e 00 00 00       	jmp    802723 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802685:	a1 50 50 80 00       	mov    0x805050,%eax
  80268a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80268d:	c1 e2 04             	shl    $0x4,%edx
  802690:	01 d0                	add    %edx,%eax
  802692:	85 c0                	test   %eax,%eax
  802694:	75 14                	jne    8026aa <initialize_MemBlocksList+0x55>
  802696:	83 ec 04             	sub    $0x4,%esp
  802699:	68 74 46 80 00       	push   $0x804674
  80269e:	6a 46                	push   $0x46
  8026a0:	68 97 46 80 00       	push   $0x804697
  8026a5:	e8 49 e2 ff ff       	call   8008f3 <_panic>
  8026aa:	a1 50 50 80 00       	mov    0x805050,%eax
  8026af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026b2:	c1 e2 04             	shl    $0x4,%edx
  8026b5:	01 d0                	add    %edx,%eax
  8026b7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8026bd:	89 10                	mov    %edx,(%eax)
  8026bf:	8b 00                	mov    (%eax),%eax
  8026c1:	85 c0                	test   %eax,%eax
  8026c3:	74 18                	je     8026dd <initialize_MemBlocksList+0x88>
  8026c5:	a1 48 51 80 00       	mov    0x805148,%eax
  8026ca:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8026d0:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8026d3:	c1 e1 04             	shl    $0x4,%ecx
  8026d6:	01 ca                	add    %ecx,%edx
  8026d8:	89 50 04             	mov    %edx,0x4(%eax)
  8026db:	eb 12                	jmp    8026ef <initialize_MemBlocksList+0x9a>
  8026dd:	a1 50 50 80 00       	mov    0x805050,%eax
  8026e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026e5:	c1 e2 04             	shl    $0x4,%edx
  8026e8:	01 d0                	add    %edx,%eax
  8026ea:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8026ef:	a1 50 50 80 00       	mov    0x805050,%eax
  8026f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026f7:	c1 e2 04             	shl    $0x4,%edx
  8026fa:	01 d0                	add    %edx,%eax
  8026fc:	a3 48 51 80 00       	mov    %eax,0x805148
  802701:	a1 50 50 80 00       	mov    0x805050,%eax
  802706:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802709:	c1 e2 04             	shl    $0x4,%edx
  80270c:	01 d0                	add    %edx,%eax
  80270e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802715:	a1 54 51 80 00       	mov    0x805154,%eax
  80271a:	40                   	inc    %eax
  80271b:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802720:	ff 45 f4             	incl   -0xc(%ebp)
  802723:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802726:	3b 45 08             	cmp    0x8(%ebp),%eax
  802729:	0f 82 56 ff ff ff    	jb     802685 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  80272f:	90                   	nop
  802730:	c9                   	leave  
  802731:	c3                   	ret    

00802732 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802732:	55                   	push   %ebp
  802733:	89 e5                	mov    %esp,%ebp
  802735:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802738:	8b 45 08             	mov    0x8(%ebp),%eax
  80273b:	8b 00                	mov    (%eax),%eax
  80273d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802740:	eb 19                	jmp    80275b <find_block+0x29>
	{
		if(va==point->sva)
  802742:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802745:	8b 40 08             	mov    0x8(%eax),%eax
  802748:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80274b:	75 05                	jne    802752 <find_block+0x20>
		   return point;
  80274d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802750:	eb 36                	jmp    802788 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802752:	8b 45 08             	mov    0x8(%ebp),%eax
  802755:	8b 40 08             	mov    0x8(%eax),%eax
  802758:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80275b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80275f:	74 07                	je     802768 <find_block+0x36>
  802761:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802764:	8b 00                	mov    (%eax),%eax
  802766:	eb 05                	jmp    80276d <find_block+0x3b>
  802768:	b8 00 00 00 00       	mov    $0x0,%eax
  80276d:	8b 55 08             	mov    0x8(%ebp),%edx
  802770:	89 42 08             	mov    %eax,0x8(%edx)
  802773:	8b 45 08             	mov    0x8(%ebp),%eax
  802776:	8b 40 08             	mov    0x8(%eax),%eax
  802779:	85 c0                	test   %eax,%eax
  80277b:	75 c5                	jne    802742 <find_block+0x10>
  80277d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802781:	75 bf                	jne    802742 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802783:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802788:	c9                   	leave  
  802789:	c3                   	ret    

0080278a <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80278a:	55                   	push   %ebp
  80278b:	89 e5                	mov    %esp,%ebp
  80278d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802790:	a1 40 50 80 00       	mov    0x805040,%eax
  802795:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802798:	a1 44 50 80 00       	mov    0x805044,%eax
  80279d:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8027a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8027a6:	74 24                	je     8027cc <insert_sorted_allocList+0x42>
  8027a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ab:	8b 50 08             	mov    0x8(%eax),%edx
  8027ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b1:	8b 40 08             	mov    0x8(%eax),%eax
  8027b4:	39 c2                	cmp    %eax,%edx
  8027b6:	76 14                	jbe    8027cc <insert_sorted_allocList+0x42>
  8027b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027bb:	8b 50 08             	mov    0x8(%eax),%edx
  8027be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027c1:	8b 40 08             	mov    0x8(%eax),%eax
  8027c4:	39 c2                	cmp    %eax,%edx
  8027c6:	0f 82 60 01 00 00    	jb     80292c <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8027cc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027d0:	75 65                	jne    802837 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8027d2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027d6:	75 14                	jne    8027ec <insert_sorted_allocList+0x62>
  8027d8:	83 ec 04             	sub    $0x4,%esp
  8027db:	68 74 46 80 00       	push   $0x804674
  8027e0:	6a 6b                	push   $0x6b
  8027e2:	68 97 46 80 00       	push   $0x804697
  8027e7:	e8 07 e1 ff ff       	call   8008f3 <_panic>
  8027ec:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8027f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f5:	89 10                	mov    %edx,(%eax)
  8027f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fa:	8b 00                	mov    (%eax),%eax
  8027fc:	85 c0                	test   %eax,%eax
  8027fe:	74 0d                	je     80280d <insert_sorted_allocList+0x83>
  802800:	a1 40 50 80 00       	mov    0x805040,%eax
  802805:	8b 55 08             	mov    0x8(%ebp),%edx
  802808:	89 50 04             	mov    %edx,0x4(%eax)
  80280b:	eb 08                	jmp    802815 <insert_sorted_allocList+0x8b>
  80280d:	8b 45 08             	mov    0x8(%ebp),%eax
  802810:	a3 44 50 80 00       	mov    %eax,0x805044
  802815:	8b 45 08             	mov    0x8(%ebp),%eax
  802818:	a3 40 50 80 00       	mov    %eax,0x805040
  80281d:	8b 45 08             	mov    0x8(%ebp),%eax
  802820:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802827:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80282c:	40                   	inc    %eax
  80282d:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802832:	e9 dc 01 00 00       	jmp    802a13 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802837:	8b 45 08             	mov    0x8(%ebp),%eax
  80283a:	8b 50 08             	mov    0x8(%eax),%edx
  80283d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802840:	8b 40 08             	mov    0x8(%eax),%eax
  802843:	39 c2                	cmp    %eax,%edx
  802845:	77 6c                	ja     8028b3 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802847:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80284b:	74 06                	je     802853 <insert_sorted_allocList+0xc9>
  80284d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802851:	75 14                	jne    802867 <insert_sorted_allocList+0xdd>
  802853:	83 ec 04             	sub    $0x4,%esp
  802856:	68 b0 46 80 00       	push   $0x8046b0
  80285b:	6a 6f                	push   $0x6f
  80285d:	68 97 46 80 00       	push   $0x804697
  802862:	e8 8c e0 ff ff       	call   8008f3 <_panic>
  802867:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80286a:	8b 50 04             	mov    0x4(%eax),%edx
  80286d:	8b 45 08             	mov    0x8(%ebp),%eax
  802870:	89 50 04             	mov    %edx,0x4(%eax)
  802873:	8b 45 08             	mov    0x8(%ebp),%eax
  802876:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802879:	89 10                	mov    %edx,(%eax)
  80287b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80287e:	8b 40 04             	mov    0x4(%eax),%eax
  802881:	85 c0                	test   %eax,%eax
  802883:	74 0d                	je     802892 <insert_sorted_allocList+0x108>
  802885:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802888:	8b 40 04             	mov    0x4(%eax),%eax
  80288b:	8b 55 08             	mov    0x8(%ebp),%edx
  80288e:	89 10                	mov    %edx,(%eax)
  802890:	eb 08                	jmp    80289a <insert_sorted_allocList+0x110>
  802892:	8b 45 08             	mov    0x8(%ebp),%eax
  802895:	a3 40 50 80 00       	mov    %eax,0x805040
  80289a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80289d:	8b 55 08             	mov    0x8(%ebp),%edx
  8028a0:	89 50 04             	mov    %edx,0x4(%eax)
  8028a3:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8028a8:	40                   	inc    %eax
  8028a9:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8028ae:	e9 60 01 00 00       	jmp    802a13 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8028b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b6:	8b 50 08             	mov    0x8(%eax),%edx
  8028b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028bc:	8b 40 08             	mov    0x8(%eax),%eax
  8028bf:	39 c2                	cmp    %eax,%edx
  8028c1:	0f 82 4c 01 00 00    	jb     802a13 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8028c7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028cb:	75 14                	jne    8028e1 <insert_sorted_allocList+0x157>
  8028cd:	83 ec 04             	sub    $0x4,%esp
  8028d0:	68 e8 46 80 00       	push   $0x8046e8
  8028d5:	6a 73                	push   $0x73
  8028d7:	68 97 46 80 00       	push   $0x804697
  8028dc:	e8 12 e0 ff ff       	call   8008f3 <_panic>
  8028e1:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8028e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ea:	89 50 04             	mov    %edx,0x4(%eax)
  8028ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f0:	8b 40 04             	mov    0x4(%eax),%eax
  8028f3:	85 c0                	test   %eax,%eax
  8028f5:	74 0c                	je     802903 <insert_sorted_allocList+0x179>
  8028f7:	a1 44 50 80 00       	mov    0x805044,%eax
  8028fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8028ff:	89 10                	mov    %edx,(%eax)
  802901:	eb 08                	jmp    80290b <insert_sorted_allocList+0x181>
  802903:	8b 45 08             	mov    0x8(%ebp),%eax
  802906:	a3 40 50 80 00       	mov    %eax,0x805040
  80290b:	8b 45 08             	mov    0x8(%ebp),%eax
  80290e:	a3 44 50 80 00       	mov    %eax,0x805044
  802913:	8b 45 08             	mov    0x8(%ebp),%eax
  802916:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80291c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802921:	40                   	inc    %eax
  802922:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802927:	e9 e7 00 00 00       	jmp    802a13 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80292c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80292f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802932:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802939:	a1 40 50 80 00       	mov    0x805040,%eax
  80293e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802941:	e9 9d 00 00 00       	jmp    8029e3 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802946:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802949:	8b 00                	mov    (%eax),%eax
  80294b:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80294e:	8b 45 08             	mov    0x8(%ebp),%eax
  802951:	8b 50 08             	mov    0x8(%eax),%edx
  802954:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802957:	8b 40 08             	mov    0x8(%eax),%eax
  80295a:	39 c2                	cmp    %eax,%edx
  80295c:	76 7d                	jbe    8029db <insert_sorted_allocList+0x251>
  80295e:	8b 45 08             	mov    0x8(%ebp),%eax
  802961:	8b 50 08             	mov    0x8(%eax),%edx
  802964:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802967:	8b 40 08             	mov    0x8(%eax),%eax
  80296a:	39 c2                	cmp    %eax,%edx
  80296c:	73 6d                	jae    8029db <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80296e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802972:	74 06                	je     80297a <insert_sorted_allocList+0x1f0>
  802974:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802978:	75 14                	jne    80298e <insert_sorted_allocList+0x204>
  80297a:	83 ec 04             	sub    $0x4,%esp
  80297d:	68 0c 47 80 00       	push   $0x80470c
  802982:	6a 7f                	push   $0x7f
  802984:	68 97 46 80 00       	push   $0x804697
  802989:	e8 65 df ff ff       	call   8008f3 <_panic>
  80298e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802991:	8b 10                	mov    (%eax),%edx
  802993:	8b 45 08             	mov    0x8(%ebp),%eax
  802996:	89 10                	mov    %edx,(%eax)
  802998:	8b 45 08             	mov    0x8(%ebp),%eax
  80299b:	8b 00                	mov    (%eax),%eax
  80299d:	85 c0                	test   %eax,%eax
  80299f:	74 0b                	je     8029ac <insert_sorted_allocList+0x222>
  8029a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a4:	8b 00                	mov    (%eax),%eax
  8029a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8029a9:	89 50 04             	mov    %edx,0x4(%eax)
  8029ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029af:	8b 55 08             	mov    0x8(%ebp),%edx
  8029b2:	89 10                	mov    %edx,(%eax)
  8029b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029ba:	89 50 04             	mov    %edx,0x4(%eax)
  8029bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c0:	8b 00                	mov    (%eax),%eax
  8029c2:	85 c0                	test   %eax,%eax
  8029c4:	75 08                	jne    8029ce <insert_sorted_allocList+0x244>
  8029c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c9:	a3 44 50 80 00       	mov    %eax,0x805044
  8029ce:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029d3:	40                   	inc    %eax
  8029d4:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8029d9:	eb 39                	jmp    802a14 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8029db:	a1 48 50 80 00       	mov    0x805048,%eax
  8029e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029e7:	74 07                	je     8029f0 <insert_sorted_allocList+0x266>
  8029e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ec:	8b 00                	mov    (%eax),%eax
  8029ee:	eb 05                	jmp    8029f5 <insert_sorted_allocList+0x26b>
  8029f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8029f5:	a3 48 50 80 00       	mov    %eax,0x805048
  8029fa:	a1 48 50 80 00       	mov    0x805048,%eax
  8029ff:	85 c0                	test   %eax,%eax
  802a01:	0f 85 3f ff ff ff    	jne    802946 <insert_sorted_allocList+0x1bc>
  802a07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a0b:	0f 85 35 ff ff ff    	jne    802946 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802a11:	eb 01                	jmp    802a14 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802a13:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802a14:	90                   	nop
  802a15:	c9                   	leave  
  802a16:	c3                   	ret    

00802a17 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802a17:	55                   	push   %ebp
  802a18:	89 e5                	mov    %esp,%ebp
  802a1a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802a1d:	a1 38 51 80 00       	mov    0x805138,%eax
  802a22:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a25:	e9 85 01 00 00       	jmp    802baf <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802a2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2d:	8b 40 0c             	mov    0xc(%eax),%eax
  802a30:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a33:	0f 82 6e 01 00 00    	jb     802ba7 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3c:	8b 40 0c             	mov    0xc(%eax),%eax
  802a3f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a42:	0f 85 8a 00 00 00    	jne    802ad2 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802a48:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a4c:	75 17                	jne    802a65 <alloc_block_FF+0x4e>
  802a4e:	83 ec 04             	sub    $0x4,%esp
  802a51:	68 40 47 80 00       	push   $0x804740
  802a56:	68 93 00 00 00       	push   $0x93
  802a5b:	68 97 46 80 00       	push   $0x804697
  802a60:	e8 8e de ff ff       	call   8008f3 <_panic>
  802a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a68:	8b 00                	mov    (%eax),%eax
  802a6a:	85 c0                	test   %eax,%eax
  802a6c:	74 10                	je     802a7e <alloc_block_FF+0x67>
  802a6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a71:	8b 00                	mov    (%eax),%eax
  802a73:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a76:	8b 52 04             	mov    0x4(%edx),%edx
  802a79:	89 50 04             	mov    %edx,0x4(%eax)
  802a7c:	eb 0b                	jmp    802a89 <alloc_block_FF+0x72>
  802a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a81:	8b 40 04             	mov    0x4(%eax),%eax
  802a84:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8c:	8b 40 04             	mov    0x4(%eax),%eax
  802a8f:	85 c0                	test   %eax,%eax
  802a91:	74 0f                	je     802aa2 <alloc_block_FF+0x8b>
  802a93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a96:	8b 40 04             	mov    0x4(%eax),%eax
  802a99:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a9c:	8b 12                	mov    (%edx),%edx
  802a9e:	89 10                	mov    %edx,(%eax)
  802aa0:	eb 0a                	jmp    802aac <alloc_block_FF+0x95>
  802aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa5:	8b 00                	mov    (%eax),%eax
  802aa7:	a3 38 51 80 00       	mov    %eax,0x805138
  802aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aaf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ab5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802abf:	a1 44 51 80 00       	mov    0x805144,%eax
  802ac4:	48                   	dec    %eax
  802ac5:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acd:	e9 10 01 00 00       	jmp    802be2 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ad8:	3b 45 08             	cmp    0x8(%ebp),%eax
  802adb:	0f 86 c6 00 00 00    	jbe    802ba7 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802ae1:	a1 48 51 80 00       	mov    0x805148,%eax
  802ae6:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aec:	8b 50 08             	mov    0x8(%eax),%edx
  802aef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af2:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802af5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af8:	8b 55 08             	mov    0x8(%ebp),%edx
  802afb:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802afe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b02:	75 17                	jne    802b1b <alloc_block_FF+0x104>
  802b04:	83 ec 04             	sub    $0x4,%esp
  802b07:	68 40 47 80 00       	push   $0x804740
  802b0c:	68 9b 00 00 00       	push   $0x9b
  802b11:	68 97 46 80 00       	push   $0x804697
  802b16:	e8 d8 dd ff ff       	call   8008f3 <_panic>
  802b1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b1e:	8b 00                	mov    (%eax),%eax
  802b20:	85 c0                	test   %eax,%eax
  802b22:	74 10                	je     802b34 <alloc_block_FF+0x11d>
  802b24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b27:	8b 00                	mov    (%eax),%eax
  802b29:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b2c:	8b 52 04             	mov    0x4(%edx),%edx
  802b2f:	89 50 04             	mov    %edx,0x4(%eax)
  802b32:	eb 0b                	jmp    802b3f <alloc_block_FF+0x128>
  802b34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b37:	8b 40 04             	mov    0x4(%eax),%eax
  802b3a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b42:	8b 40 04             	mov    0x4(%eax),%eax
  802b45:	85 c0                	test   %eax,%eax
  802b47:	74 0f                	je     802b58 <alloc_block_FF+0x141>
  802b49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b4c:	8b 40 04             	mov    0x4(%eax),%eax
  802b4f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b52:	8b 12                	mov    (%edx),%edx
  802b54:	89 10                	mov    %edx,(%eax)
  802b56:	eb 0a                	jmp    802b62 <alloc_block_FF+0x14b>
  802b58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b5b:	8b 00                	mov    (%eax),%eax
  802b5d:	a3 48 51 80 00       	mov    %eax,0x805148
  802b62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b65:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b6e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b75:	a1 54 51 80 00       	mov    0x805154,%eax
  802b7a:	48                   	dec    %eax
  802b7b:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802b80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b83:	8b 50 08             	mov    0x8(%eax),%edx
  802b86:	8b 45 08             	mov    0x8(%ebp),%eax
  802b89:	01 c2                	add    %eax,%edx
  802b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8e:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802b91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b94:	8b 40 0c             	mov    0xc(%eax),%eax
  802b97:	2b 45 08             	sub    0x8(%ebp),%eax
  802b9a:	89 c2                	mov    %eax,%edx
  802b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9f:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802ba2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba5:	eb 3b                	jmp    802be2 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802ba7:	a1 40 51 80 00       	mov    0x805140,%eax
  802bac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802baf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bb3:	74 07                	je     802bbc <alloc_block_FF+0x1a5>
  802bb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb8:	8b 00                	mov    (%eax),%eax
  802bba:	eb 05                	jmp    802bc1 <alloc_block_FF+0x1aa>
  802bbc:	b8 00 00 00 00       	mov    $0x0,%eax
  802bc1:	a3 40 51 80 00       	mov    %eax,0x805140
  802bc6:	a1 40 51 80 00       	mov    0x805140,%eax
  802bcb:	85 c0                	test   %eax,%eax
  802bcd:	0f 85 57 fe ff ff    	jne    802a2a <alloc_block_FF+0x13>
  802bd3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bd7:	0f 85 4d fe ff ff    	jne    802a2a <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802bdd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802be2:	c9                   	leave  
  802be3:	c3                   	ret    

00802be4 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802be4:	55                   	push   %ebp
  802be5:	89 e5                	mov    %esp,%ebp
  802be7:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802bea:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802bf1:	a1 38 51 80 00       	mov    0x805138,%eax
  802bf6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bf9:	e9 df 00 00 00       	jmp    802cdd <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802bfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c01:	8b 40 0c             	mov    0xc(%eax),%eax
  802c04:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c07:	0f 82 c8 00 00 00    	jb     802cd5 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802c0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c10:	8b 40 0c             	mov    0xc(%eax),%eax
  802c13:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c16:	0f 85 8a 00 00 00    	jne    802ca6 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802c1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c20:	75 17                	jne    802c39 <alloc_block_BF+0x55>
  802c22:	83 ec 04             	sub    $0x4,%esp
  802c25:	68 40 47 80 00       	push   $0x804740
  802c2a:	68 b7 00 00 00       	push   $0xb7
  802c2f:	68 97 46 80 00       	push   $0x804697
  802c34:	e8 ba dc ff ff       	call   8008f3 <_panic>
  802c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3c:	8b 00                	mov    (%eax),%eax
  802c3e:	85 c0                	test   %eax,%eax
  802c40:	74 10                	je     802c52 <alloc_block_BF+0x6e>
  802c42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c45:	8b 00                	mov    (%eax),%eax
  802c47:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c4a:	8b 52 04             	mov    0x4(%edx),%edx
  802c4d:	89 50 04             	mov    %edx,0x4(%eax)
  802c50:	eb 0b                	jmp    802c5d <alloc_block_BF+0x79>
  802c52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c55:	8b 40 04             	mov    0x4(%eax),%eax
  802c58:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c60:	8b 40 04             	mov    0x4(%eax),%eax
  802c63:	85 c0                	test   %eax,%eax
  802c65:	74 0f                	je     802c76 <alloc_block_BF+0x92>
  802c67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6a:	8b 40 04             	mov    0x4(%eax),%eax
  802c6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c70:	8b 12                	mov    (%edx),%edx
  802c72:	89 10                	mov    %edx,(%eax)
  802c74:	eb 0a                	jmp    802c80 <alloc_block_BF+0x9c>
  802c76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c79:	8b 00                	mov    (%eax),%eax
  802c7b:	a3 38 51 80 00       	mov    %eax,0x805138
  802c80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c83:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c93:	a1 44 51 80 00       	mov    0x805144,%eax
  802c98:	48                   	dec    %eax
  802c99:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca1:	e9 4d 01 00 00       	jmp    802df3 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802ca6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca9:	8b 40 0c             	mov    0xc(%eax),%eax
  802cac:	3b 45 08             	cmp    0x8(%ebp),%eax
  802caf:	76 24                	jbe    802cd5 <alloc_block_BF+0xf1>
  802cb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb4:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802cba:	73 19                	jae    802cd5 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802cbc:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802cc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc6:	8b 40 0c             	mov    0xc(%eax),%eax
  802cc9:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccf:	8b 40 08             	mov    0x8(%eax),%eax
  802cd2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802cd5:	a1 40 51 80 00       	mov    0x805140,%eax
  802cda:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cdd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ce1:	74 07                	je     802cea <alloc_block_BF+0x106>
  802ce3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce6:	8b 00                	mov    (%eax),%eax
  802ce8:	eb 05                	jmp    802cef <alloc_block_BF+0x10b>
  802cea:	b8 00 00 00 00       	mov    $0x0,%eax
  802cef:	a3 40 51 80 00       	mov    %eax,0x805140
  802cf4:	a1 40 51 80 00       	mov    0x805140,%eax
  802cf9:	85 c0                	test   %eax,%eax
  802cfb:	0f 85 fd fe ff ff    	jne    802bfe <alloc_block_BF+0x1a>
  802d01:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d05:	0f 85 f3 fe ff ff    	jne    802bfe <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802d0b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d0f:	0f 84 d9 00 00 00    	je     802dee <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d15:	a1 48 51 80 00       	mov    0x805148,%eax
  802d1a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802d1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d20:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d23:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802d26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d29:	8b 55 08             	mov    0x8(%ebp),%edx
  802d2c:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802d2f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802d33:	75 17                	jne    802d4c <alloc_block_BF+0x168>
  802d35:	83 ec 04             	sub    $0x4,%esp
  802d38:	68 40 47 80 00       	push   $0x804740
  802d3d:	68 c7 00 00 00       	push   $0xc7
  802d42:	68 97 46 80 00       	push   $0x804697
  802d47:	e8 a7 db ff ff       	call   8008f3 <_panic>
  802d4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d4f:	8b 00                	mov    (%eax),%eax
  802d51:	85 c0                	test   %eax,%eax
  802d53:	74 10                	je     802d65 <alloc_block_BF+0x181>
  802d55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d58:	8b 00                	mov    (%eax),%eax
  802d5a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d5d:	8b 52 04             	mov    0x4(%edx),%edx
  802d60:	89 50 04             	mov    %edx,0x4(%eax)
  802d63:	eb 0b                	jmp    802d70 <alloc_block_BF+0x18c>
  802d65:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d68:	8b 40 04             	mov    0x4(%eax),%eax
  802d6b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d73:	8b 40 04             	mov    0x4(%eax),%eax
  802d76:	85 c0                	test   %eax,%eax
  802d78:	74 0f                	je     802d89 <alloc_block_BF+0x1a5>
  802d7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d7d:	8b 40 04             	mov    0x4(%eax),%eax
  802d80:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d83:	8b 12                	mov    (%edx),%edx
  802d85:	89 10                	mov    %edx,(%eax)
  802d87:	eb 0a                	jmp    802d93 <alloc_block_BF+0x1af>
  802d89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d8c:	8b 00                	mov    (%eax),%eax
  802d8e:	a3 48 51 80 00       	mov    %eax,0x805148
  802d93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d96:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d9c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d9f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802da6:	a1 54 51 80 00       	mov    0x805154,%eax
  802dab:	48                   	dec    %eax
  802dac:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802db1:	83 ec 08             	sub    $0x8,%esp
  802db4:	ff 75 ec             	pushl  -0x14(%ebp)
  802db7:	68 38 51 80 00       	push   $0x805138
  802dbc:	e8 71 f9 ff ff       	call   802732 <find_block>
  802dc1:	83 c4 10             	add    $0x10,%esp
  802dc4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802dc7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dca:	8b 50 08             	mov    0x8(%eax),%edx
  802dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd0:	01 c2                	add    %eax,%edx
  802dd2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dd5:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802dd8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ddb:	8b 40 0c             	mov    0xc(%eax),%eax
  802dde:	2b 45 08             	sub    0x8(%ebp),%eax
  802de1:	89 c2                	mov    %eax,%edx
  802de3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802de6:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802de9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dec:	eb 05                	jmp    802df3 <alloc_block_BF+0x20f>
	}
	return NULL;
  802dee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802df3:	c9                   	leave  
  802df4:	c3                   	ret    

00802df5 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802df5:	55                   	push   %ebp
  802df6:	89 e5                	mov    %esp,%ebp
  802df8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802dfb:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e00:	85 c0                	test   %eax,%eax
  802e02:	0f 85 de 01 00 00    	jne    802fe6 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802e08:	a1 38 51 80 00       	mov    0x805138,%eax
  802e0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e10:	e9 9e 01 00 00       	jmp    802fb3 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802e15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e18:	8b 40 0c             	mov    0xc(%eax),%eax
  802e1b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e1e:	0f 82 87 01 00 00    	jb     802fab <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802e24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e27:	8b 40 0c             	mov    0xc(%eax),%eax
  802e2a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e2d:	0f 85 95 00 00 00    	jne    802ec8 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802e33:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e37:	75 17                	jne    802e50 <alloc_block_NF+0x5b>
  802e39:	83 ec 04             	sub    $0x4,%esp
  802e3c:	68 40 47 80 00       	push   $0x804740
  802e41:	68 e0 00 00 00       	push   $0xe0
  802e46:	68 97 46 80 00       	push   $0x804697
  802e4b:	e8 a3 da ff ff       	call   8008f3 <_panic>
  802e50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e53:	8b 00                	mov    (%eax),%eax
  802e55:	85 c0                	test   %eax,%eax
  802e57:	74 10                	je     802e69 <alloc_block_NF+0x74>
  802e59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5c:	8b 00                	mov    (%eax),%eax
  802e5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e61:	8b 52 04             	mov    0x4(%edx),%edx
  802e64:	89 50 04             	mov    %edx,0x4(%eax)
  802e67:	eb 0b                	jmp    802e74 <alloc_block_NF+0x7f>
  802e69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6c:	8b 40 04             	mov    0x4(%eax),%eax
  802e6f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e77:	8b 40 04             	mov    0x4(%eax),%eax
  802e7a:	85 c0                	test   %eax,%eax
  802e7c:	74 0f                	je     802e8d <alloc_block_NF+0x98>
  802e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e81:	8b 40 04             	mov    0x4(%eax),%eax
  802e84:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e87:	8b 12                	mov    (%edx),%edx
  802e89:	89 10                	mov    %edx,(%eax)
  802e8b:	eb 0a                	jmp    802e97 <alloc_block_NF+0xa2>
  802e8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e90:	8b 00                	mov    (%eax),%eax
  802e92:	a3 38 51 80 00       	mov    %eax,0x805138
  802e97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ea0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eaa:	a1 44 51 80 00       	mov    0x805144,%eax
  802eaf:	48                   	dec    %eax
  802eb0:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802eb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb8:	8b 40 08             	mov    0x8(%eax),%eax
  802ebb:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   return  point;
  802ec0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec3:	e9 f8 04 00 00       	jmp    8033c0 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802ec8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecb:	8b 40 0c             	mov    0xc(%eax),%eax
  802ece:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ed1:	0f 86 d4 00 00 00    	jbe    802fab <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802ed7:	a1 48 51 80 00       	mov    0x805148,%eax
  802edc:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802edf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee2:	8b 50 08             	mov    0x8(%eax),%edx
  802ee5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee8:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802eeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eee:	8b 55 08             	mov    0x8(%ebp),%edx
  802ef1:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802ef4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ef8:	75 17                	jne    802f11 <alloc_block_NF+0x11c>
  802efa:	83 ec 04             	sub    $0x4,%esp
  802efd:	68 40 47 80 00       	push   $0x804740
  802f02:	68 e9 00 00 00       	push   $0xe9
  802f07:	68 97 46 80 00       	push   $0x804697
  802f0c:	e8 e2 d9 ff ff       	call   8008f3 <_panic>
  802f11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f14:	8b 00                	mov    (%eax),%eax
  802f16:	85 c0                	test   %eax,%eax
  802f18:	74 10                	je     802f2a <alloc_block_NF+0x135>
  802f1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f1d:	8b 00                	mov    (%eax),%eax
  802f1f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f22:	8b 52 04             	mov    0x4(%edx),%edx
  802f25:	89 50 04             	mov    %edx,0x4(%eax)
  802f28:	eb 0b                	jmp    802f35 <alloc_block_NF+0x140>
  802f2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f2d:	8b 40 04             	mov    0x4(%eax),%eax
  802f30:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f38:	8b 40 04             	mov    0x4(%eax),%eax
  802f3b:	85 c0                	test   %eax,%eax
  802f3d:	74 0f                	je     802f4e <alloc_block_NF+0x159>
  802f3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f42:	8b 40 04             	mov    0x4(%eax),%eax
  802f45:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f48:	8b 12                	mov    (%edx),%edx
  802f4a:	89 10                	mov    %edx,(%eax)
  802f4c:	eb 0a                	jmp    802f58 <alloc_block_NF+0x163>
  802f4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f51:	8b 00                	mov    (%eax),%eax
  802f53:	a3 48 51 80 00       	mov    %eax,0x805148
  802f58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f5b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f64:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f6b:	a1 54 51 80 00       	mov    0x805154,%eax
  802f70:	48                   	dec    %eax
  802f71:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802f76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f79:	8b 40 08             	mov    0x8(%eax),%eax
  802f7c:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   point->sva += size;
  802f81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f84:	8b 50 08             	mov    0x8(%eax),%edx
  802f87:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8a:	01 c2                	add    %eax,%edx
  802f8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8f:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802f92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f95:	8b 40 0c             	mov    0xc(%eax),%eax
  802f98:	2b 45 08             	sub    0x8(%ebp),%eax
  802f9b:	89 c2                	mov    %eax,%edx
  802f9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa0:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802fa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fa6:	e9 15 04 00 00       	jmp    8033c0 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802fab:	a1 40 51 80 00       	mov    0x805140,%eax
  802fb0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fb3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fb7:	74 07                	je     802fc0 <alloc_block_NF+0x1cb>
  802fb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbc:	8b 00                	mov    (%eax),%eax
  802fbe:	eb 05                	jmp    802fc5 <alloc_block_NF+0x1d0>
  802fc0:	b8 00 00 00 00       	mov    $0x0,%eax
  802fc5:	a3 40 51 80 00       	mov    %eax,0x805140
  802fca:	a1 40 51 80 00       	mov    0x805140,%eax
  802fcf:	85 c0                	test   %eax,%eax
  802fd1:	0f 85 3e fe ff ff    	jne    802e15 <alloc_block_NF+0x20>
  802fd7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fdb:	0f 85 34 fe ff ff    	jne    802e15 <alloc_block_NF+0x20>
  802fe1:	e9 d5 03 00 00       	jmp    8033bb <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802fe6:	a1 38 51 80 00       	mov    0x805138,%eax
  802feb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fee:	e9 b1 01 00 00       	jmp    8031a4 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802ff3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff6:	8b 50 08             	mov    0x8(%eax),%edx
  802ff9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802ffe:	39 c2                	cmp    %eax,%edx
  803000:	0f 82 96 01 00 00    	jb     80319c <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  803006:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803009:	8b 40 0c             	mov    0xc(%eax),%eax
  80300c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80300f:	0f 82 87 01 00 00    	jb     80319c <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  803015:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803018:	8b 40 0c             	mov    0xc(%eax),%eax
  80301b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80301e:	0f 85 95 00 00 00    	jne    8030b9 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803024:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803028:	75 17                	jne    803041 <alloc_block_NF+0x24c>
  80302a:	83 ec 04             	sub    $0x4,%esp
  80302d:	68 40 47 80 00       	push   $0x804740
  803032:	68 fc 00 00 00       	push   $0xfc
  803037:	68 97 46 80 00       	push   $0x804697
  80303c:	e8 b2 d8 ff ff       	call   8008f3 <_panic>
  803041:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803044:	8b 00                	mov    (%eax),%eax
  803046:	85 c0                	test   %eax,%eax
  803048:	74 10                	je     80305a <alloc_block_NF+0x265>
  80304a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304d:	8b 00                	mov    (%eax),%eax
  80304f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803052:	8b 52 04             	mov    0x4(%edx),%edx
  803055:	89 50 04             	mov    %edx,0x4(%eax)
  803058:	eb 0b                	jmp    803065 <alloc_block_NF+0x270>
  80305a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305d:	8b 40 04             	mov    0x4(%eax),%eax
  803060:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803065:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803068:	8b 40 04             	mov    0x4(%eax),%eax
  80306b:	85 c0                	test   %eax,%eax
  80306d:	74 0f                	je     80307e <alloc_block_NF+0x289>
  80306f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803072:	8b 40 04             	mov    0x4(%eax),%eax
  803075:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803078:	8b 12                	mov    (%edx),%edx
  80307a:	89 10                	mov    %edx,(%eax)
  80307c:	eb 0a                	jmp    803088 <alloc_block_NF+0x293>
  80307e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803081:	8b 00                	mov    (%eax),%eax
  803083:	a3 38 51 80 00       	mov    %eax,0x805138
  803088:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803091:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803094:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80309b:	a1 44 51 80 00       	mov    0x805144,%eax
  8030a0:	48                   	dec    %eax
  8030a1:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8030a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a9:	8b 40 08             	mov    0x8(%eax),%eax
  8030ac:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  8030b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b4:	e9 07 03 00 00       	jmp    8033c0 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8030b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8030bf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030c2:	0f 86 d4 00 00 00    	jbe    80319c <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8030c8:	a1 48 51 80 00       	mov    0x805148,%eax
  8030cd:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8030d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d3:	8b 50 08             	mov    0x8(%eax),%edx
  8030d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d9:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8030dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030df:	8b 55 08             	mov    0x8(%ebp),%edx
  8030e2:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8030e5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030e9:	75 17                	jne    803102 <alloc_block_NF+0x30d>
  8030eb:	83 ec 04             	sub    $0x4,%esp
  8030ee:	68 40 47 80 00       	push   $0x804740
  8030f3:	68 04 01 00 00       	push   $0x104
  8030f8:	68 97 46 80 00       	push   $0x804697
  8030fd:	e8 f1 d7 ff ff       	call   8008f3 <_panic>
  803102:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803105:	8b 00                	mov    (%eax),%eax
  803107:	85 c0                	test   %eax,%eax
  803109:	74 10                	je     80311b <alloc_block_NF+0x326>
  80310b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80310e:	8b 00                	mov    (%eax),%eax
  803110:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803113:	8b 52 04             	mov    0x4(%edx),%edx
  803116:	89 50 04             	mov    %edx,0x4(%eax)
  803119:	eb 0b                	jmp    803126 <alloc_block_NF+0x331>
  80311b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80311e:	8b 40 04             	mov    0x4(%eax),%eax
  803121:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803126:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803129:	8b 40 04             	mov    0x4(%eax),%eax
  80312c:	85 c0                	test   %eax,%eax
  80312e:	74 0f                	je     80313f <alloc_block_NF+0x34a>
  803130:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803133:	8b 40 04             	mov    0x4(%eax),%eax
  803136:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803139:	8b 12                	mov    (%edx),%edx
  80313b:	89 10                	mov    %edx,(%eax)
  80313d:	eb 0a                	jmp    803149 <alloc_block_NF+0x354>
  80313f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803142:	8b 00                	mov    (%eax),%eax
  803144:	a3 48 51 80 00       	mov    %eax,0x805148
  803149:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80314c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803152:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803155:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80315c:	a1 54 51 80 00       	mov    0x805154,%eax
  803161:	48                   	dec    %eax
  803162:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803167:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80316a:	8b 40 08             	mov    0x8(%eax),%eax
  80316d:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  803172:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803175:	8b 50 08             	mov    0x8(%eax),%edx
  803178:	8b 45 08             	mov    0x8(%ebp),%eax
  80317b:	01 c2                	add    %eax,%edx
  80317d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803180:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803183:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803186:	8b 40 0c             	mov    0xc(%eax),%eax
  803189:	2b 45 08             	sub    0x8(%ebp),%eax
  80318c:	89 c2                	mov    %eax,%edx
  80318e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803191:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803194:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803197:	e9 24 02 00 00       	jmp    8033c0 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80319c:	a1 40 51 80 00       	mov    0x805140,%eax
  8031a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031a8:	74 07                	je     8031b1 <alloc_block_NF+0x3bc>
  8031aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ad:	8b 00                	mov    (%eax),%eax
  8031af:	eb 05                	jmp    8031b6 <alloc_block_NF+0x3c1>
  8031b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8031b6:	a3 40 51 80 00       	mov    %eax,0x805140
  8031bb:	a1 40 51 80 00       	mov    0x805140,%eax
  8031c0:	85 c0                	test   %eax,%eax
  8031c2:	0f 85 2b fe ff ff    	jne    802ff3 <alloc_block_NF+0x1fe>
  8031c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031cc:	0f 85 21 fe ff ff    	jne    802ff3 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8031d2:	a1 38 51 80 00       	mov    0x805138,%eax
  8031d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031da:	e9 ae 01 00 00       	jmp    80338d <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8031df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e2:	8b 50 08             	mov    0x8(%eax),%edx
  8031e5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031ea:	39 c2                	cmp    %eax,%edx
  8031ec:	0f 83 93 01 00 00    	jae    803385 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  8031f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8031f8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031fb:	0f 82 84 01 00 00    	jb     803385 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  803201:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803204:	8b 40 0c             	mov    0xc(%eax),%eax
  803207:	3b 45 08             	cmp    0x8(%ebp),%eax
  80320a:	0f 85 95 00 00 00    	jne    8032a5 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803210:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803214:	75 17                	jne    80322d <alloc_block_NF+0x438>
  803216:	83 ec 04             	sub    $0x4,%esp
  803219:	68 40 47 80 00       	push   $0x804740
  80321e:	68 14 01 00 00       	push   $0x114
  803223:	68 97 46 80 00       	push   $0x804697
  803228:	e8 c6 d6 ff ff       	call   8008f3 <_panic>
  80322d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803230:	8b 00                	mov    (%eax),%eax
  803232:	85 c0                	test   %eax,%eax
  803234:	74 10                	je     803246 <alloc_block_NF+0x451>
  803236:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803239:	8b 00                	mov    (%eax),%eax
  80323b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80323e:	8b 52 04             	mov    0x4(%edx),%edx
  803241:	89 50 04             	mov    %edx,0x4(%eax)
  803244:	eb 0b                	jmp    803251 <alloc_block_NF+0x45c>
  803246:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803249:	8b 40 04             	mov    0x4(%eax),%eax
  80324c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803251:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803254:	8b 40 04             	mov    0x4(%eax),%eax
  803257:	85 c0                	test   %eax,%eax
  803259:	74 0f                	je     80326a <alloc_block_NF+0x475>
  80325b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325e:	8b 40 04             	mov    0x4(%eax),%eax
  803261:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803264:	8b 12                	mov    (%edx),%edx
  803266:	89 10                	mov    %edx,(%eax)
  803268:	eb 0a                	jmp    803274 <alloc_block_NF+0x47f>
  80326a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326d:	8b 00                	mov    (%eax),%eax
  80326f:	a3 38 51 80 00       	mov    %eax,0x805138
  803274:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803277:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80327d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803280:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803287:	a1 44 51 80 00       	mov    0x805144,%eax
  80328c:	48                   	dec    %eax
  80328d:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803292:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803295:	8b 40 08             	mov    0x8(%eax),%eax
  803298:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  80329d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a0:	e9 1b 01 00 00       	jmp    8033c0 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8032a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a8:	8b 40 0c             	mov    0xc(%eax),%eax
  8032ab:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032ae:	0f 86 d1 00 00 00    	jbe    803385 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8032b4:	a1 48 51 80 00       	mov    0x805148,%eax
  8032b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  8032bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032bf:	8b 50 08             	mov    0x8(%eax),%edx
  8032c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032c5:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8032c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8032ce:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8032d1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8032d5:	75 17                	jne    8032ee <alloc_block_NF+0x4f9>
  8032d7:	83 ec 04             	sub    $0x4,%esp
  8032da:	68 40 47 80 00       	push   $0x804740
  8032df:	68 1c 01 00 00       	push   $0x11c
  8032e4:	68 97 46 80 00       	push   $0x804697
  8032e9:	e8 05 d6 ff ff       	call   8008f3 <_panic>
  8032ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032f1:	8b 00                	mov    (%eax),%eax
  8032f3:	85 c0                	test   %eax,%eax
  8032f5:	74 10                	je     803307 <alloc_block_NF+0x512>
  8032f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032fa:	8b 00                	mov    (%eax),%eax
  8032fc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8032ff:	8b 52 04             	mov    0x4(%edx),%edx
  803302:	89 50 04             	mov    %edx,0x4(%eax)
  803305:	eb 0b                	jmp    803312 <alloc_block_NF+0x51d>
  803307:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80330a:	8b 40 04             	mov    0x4(%eax),%eax
  80330d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803312:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803315:	8b 40 04             	mov    0x4(%eax),%eax
  803318:	85 c0                	test   %eax,%eax
  80331a:	74 0f                	je     80332b <alloc_block_NF+0x536>
  80331c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80331f:	8b 40 04             	mov    0x4(%eax),%eax
  803322:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803325:	8b 12                	mov    (%edx),%edx
  803327:	89 10                	mov    %edx,(%eax)
  803329:	eb 0a                	jmp    803335 <alloc_block_NF+0x540>
  80332b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80332e:	8b 00                	mov    (%eax),%eax
  803330:	a3 48 51 80 00       	mov    %eax,0x805148
  803335:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803338:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80333e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803341:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803348:	a1 54 51 80 00       	mov    0x805154,%eax
  80334d:	48                   	dec    %eax
  80334e:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803353:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803356:	8b 40 08             	mov    0x8(%eax),%eax
  803359:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  80335e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803361:	8b 50 08             	mov    0x8(%eax),%edx
  803364:	8b 45 08             	mov    0x8(%ebp),%eax
  803367:	01 c2                	add    %eax,%edx
  803369:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336c:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80336f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803372:	8b 40 0c             	mov    0xc(%eax),%eax
  803375:	2b 45 08             	sub    0x8(%ebp),%eax
  803378:	89 c2                	mov    %eax,%edx
  80337a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80337d:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803380:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803383:	eb 3b                	jmp    8033c0 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803385:	a1 40 51 80 00       	mov    0x805140,%eax
  80338a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80338d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803391:	74 07                	je     80339a <alloc_block_NF+0x5a5>
  803393:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803396:	8b 00                	mov    (%eax),%eax
  803398:	eb 05                	jmp    80339f <alloc_block_NF+0x5aa>
  80339a:	b8 00 00 00 00       	mov    $0x0,%eax
  80339f:	a3 40 51 80 00       	mov    %eax,0x805140
  8033a4:	a1 40 51 80 00       	mov    0x805140,%eax
  8033a9:	85 c0                	test   %eax,%eax
  8033ab:	0f 85 2e fe ff ff    	jne    8031df <alloc_block_NF+0x3ea>
  8033b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033b5:	0f 85 24 fe ff ff    	jne    8031df <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  8033bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033c0:	c9                   	leave  
  8033c1:	c3                   	ret    

008033c2 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8033c2:	55                   	push   %ebp
  8033c3:	89 e5                	mov    %esp,%ebp
  8033c5:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  8033c8:	a1 38 51 80 00       	mov    0x805138,%eax
  8033cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  8033d0:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8033d5:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  8033d8:	a1 38 51 80 00       	mov    0x805138,%eax
  8033dd:	85 c0                	test   %eax,%eax
  8033df:	74 14                	je     8033f5 <insert_sorted_with_merge_freeList+0x33>
  8033e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e4:	8b 50 08             	mov    0x8(%eax),%edx
  8033e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ea:	8b 40 08             	mov    0x8(%eax),%eax
  8033ed:	39 c2                	cmp    %eax,%edx
  8033ef:	0f 87 9b 01 00 00    	ja     803590 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  8033f5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033f9:	75 17                	jne    803412 <insert_sorted_with_merge_freeList+0x50>
  8033fb:	83 ec 04             	sub    $0x4,%esp
  8033fe:	68 74 46 80 00       	push   $0x804674
  803403:	68 38 01 00 00       	push   $0x138
  803408:	68 97 46 80 00       	push   $0x804697
  80340d:	e8 e1 d4 ff ff       	call   8008f3 <_panic>
  803412:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803418:	8b 45 08             	mov    0x8(%ebp),%eax
  80341b:	89 10                	mov    %edx,(%eax)
  80341d:	8b 45 08             	mov    0x8(%ebp),%eax
  803420:	8b 00                	mov    (%eax),%eax
  803422:	85 c0                	test   %eax,%eax
  803424:	74 0d                	je     803433 <insert_sorted_with_merge_freeList+0x71>
  803426:	a1 38 51 80 00       	mov    0x805138,%eax
  80342b:	8b 55 08             	mov    0x8(%ebp),%edx
  80342e:	89 50 04             	mov    %edx,0x4(%eax)
  803431:	eb 08                	jmp    80343b <insert_sorted_with_merge_freeList+0x79>
  803433:	8b 45 08             	mov    0x8(%ebp),%eax
  803436:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80343b:	8b 45 08             	mov    0x8(%ebp),%eax
  80343e:	a3 38 51 80 00       	mov    %eax,0x805138
  803443:	8b 45 08             	mov    0x8(%ebp),%eax
  803446:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80344d:	a1 44 51 80 00       	mov    0x805144,%eax
  803452:	40                   	inc    %eax
  803453:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803458:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80345c:	0f 84 a8 06 00 00    	je     803b0a <insert_sorted_with_merge_freeList+0x748>
  803462:	8b 45 08             	mov    0x8(%ebp),%eax
  803465:	8b 50 08             	mov    0x8(%eax),%edx
  803468:	8b 45 08             	mov    0x8(%ebp),%eax
  80346b:	8b 40 0c             	mov    0xc(%eax),%eax
  80346e:	01 c2                	add    %eax,%edx
  803470:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803473:	8b 40 08             	mov    0x8(%eax),%eax
  803476:	39 c2                	cmp    %eax,%edx
  803478:	0f 85 8c 06 00 00    	jne    803b0a <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  80347e:	8b 45 08             	mov    0x8(%ebp),%eax
  803481:	8b 50 0c             	mov    0xc(%eax),%edx
  803484:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803487:	8b 40 0c             	mov    0xc(%eax),%eax
  80348a:	01 c2                	add    %eax,%edx
  80348c:	8b 45 08             	mov    0x8(%ebp),%eax
  80348f:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803492:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803496:	75 17                	jne    8034af <insert_sorted_with_merge_freeList+0xed>
  803498:	83 ec 04             	sub    $0x4,%esp
  80349b:	68 40 47 80 00       	push   $0x804740
  8034a0:	68 3c 01 00 00       	push   $0x13c
  8034a5:	68 97 46 80 00       	push   $0x804697
  8034aa:	e8 44 d4 ff ff       	call   8008f3 <_panic>
  8034af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034b2:	8b 00                	mov    (%eax),%eax
  8034b4:	85 c0                	test   %eax,%eax
  8034b6:	74 10                	je     8034c8 <insert_sorted_with_merge_freeList+0x106>
  8034b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034bb:	8b 00                	mov    (%eax),%eax
  8034bd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034c0:	8b 52 04             	mov    0x4(%edx),%edx
  8034c3:	89 50 04             	mov    %edx,0x4(%eax)
  8034c6:	eb 0b                	jmp    8034d3 <insert_sorted_with_merge_freeList+0x111>
  8034c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034cb:	8b 40 04             	mov    0x4(%eax),%eax
  8034ce:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034d6:	8b 40 04             	mov    0x4(%eax),%eax
  8034d9:	85 c0                	test   %eax,%eax
  8034db:	74 0f                	je     8034ec <insert_sorted_with_merge_freeList+0x12a>
  8034dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034e0:	8b 40 04             	mov    0x4(%eax),%eax
  8034e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034e6:	8b 12                	mov    (%edx),%edx
  8034e8:	89 10                	mov    %edx,(%eax)
  8034ea:	eb 0a                	jmp    8034f6 <insert_sorted_with_merge_freeList+0x134>
  8034ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034ef:	8b 00                	mov    (%eax),%eax
  8034f1:	a3 38 51 80 00       	mov    %eax,0x805138
  8034f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803502:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803509:	a1 44 51 80 00       	mov    0x805144,%eax
  80350e:	48                   	dec    %eax
  80350f:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  803514:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803517:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  80351e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803521:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803528:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80352c:	75 17                	jne    803545 <insert_sorted_with_merge_freeList+0x183>
  80352e:	83 ec 04             	sub    $0x4,%esp
  803531:	68 74 46 80 00       	push   $0x804674
  803536:	68 3f 01 00 00       	push   $0x13f
  80353b:	68 97 46 80 00       	push   $0x804697
  803540:	e8 ae d3 ff ff       	call   8008f3 <_panic>
  803545:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80354b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80354e:	89 10                	mov    %edx,(%eax)
  803550:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803553:	8b 00                	mov    (%eax),%eax
  803555:	85 c0                	test   %eax,%eax
  803557:	74 0d                	je     803566 <insert_sorted_with_merge_freeList+0x1a4>
  803559:	a1 48 51 80 00       	mov    0x805148,%eax
  80355e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803561:	89 50 04             	mov    %edx,0x4(%eax)
  803564:	eb 08                	jmp    80356e <insert_sorted_with_merge_freeList+0x1ac>
  803566:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803569:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80356e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803571:	a3 48 51 80 00       	mov    %eax,0x805148
  803576:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803579:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803580:	a1 54 51 80 00       	mov    0x805154,%eax
  803585:	40                   	inc    %eax
  803586:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80358b:	e9 7a 05 00 00       	jmp    803b0a <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803590:	8b 45 08             	mov    0x8(%ebp),%eax
  803593:	8b 50 08             	mov    0x8(%eax),%edx
  803596:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803599:	8b 40 08             	mov    0x8(%eax),%eax
  80359c:	39 c2                	cmp    %eax,%edx
  80359e:	0f 82 14 01 00 00    	jb     8036b8 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8035a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035a7:	8b 50 08             	mov    0x8(%eax),%edx
  8035aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035ad:	8b 40 0c             	mov    0xc(%eax),%eax
  8035b0:	01 c2                	add    %eax,%edx
  8035b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b5:	8b 40 08             	mov    0x8(%eax),%eax
  8035b8:	39 c2                	cmp    %eax,%edx
  8035ba:	0f 85 90 00 00 00    	jne    803650 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8035c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035c3:	8b 50 0c             	mov    0xc(%eax),%edx
  8035c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8035cc:	01 c2                	add    %eax,%edx
  8035ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035d1:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  8035d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8035de:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8035e8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035ec:	75 17                	jne    803605 <insert_sorted_with_merge_freeList+0x243>
  8035ee:	83 ec 04             	sub    $0x4,%esp
  8035f1:	68 74 46 80 00       	push   $0x804674
  8035f6:	68 49 01 00 00       	push   $0x149
  8035fb:	68 97 46 80 00       	push   $0x804697
  803600:	e8 ee d2 ff ff       	call   8008f3 <_panic>
  803605:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80360b:	8b 45 08             	mov    0x8(%ebp),%eax
  80360e:	89 10                	mov    %edx,(%eax)
  803610:	8b 45 08             	mov    0x8(%ebp),%eax
  803613:	8b 00                	mov    (%eax),%eax
  803615:	85 c0                	test   %eax,%eax
  803617:	74 0d                	je     803626 <insert_sorted_with_merge_freeList+0x264>
  803619:	a1 48 51 80 00       	mov    0x805148,%eax
  80361e:	8b 55 08             	mov    0x8(%ebp),%edx
  803621:	89 50 04             	mov    %edx,0x4(%eax)
  803624:	eb 08                	jmp    80362e <insert_sorted_with_merge_freeList+0x26c>
  803626:	8b 45 08             	mov    0x8(%ebp),%eax
  803629:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80362e:	8b 45 08             	mov    0x8(%ebp),%eax
  803631:	a3 48 51 80 00       	mov    %eax,0x805148
  803636:	8b 45 08             	mov    0x8(%ebp),%eax
  803639:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803640:	a1 54 51 80 00       	mov    0x805154,%eax
  803645:	40                   	inc    %eax
  803646:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80364b:	e9 bb 04 00 00       	jmp    803b0b <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803650:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803654:	75 17                	jne    80366d <insert_sorted_with_merge_freeList+0x2ab>
  803656:	83 ec 04             	sub    $0x4,%esp
  803659:	68 e8 46 80 00       	push   $0x8046e8
  80365e:	68 4c 01 00 00       	push   $0x14c
  803663:	68 97 46 80 00       	push   $0x804697
  803668:	e8 86 d2 ff ff       	call   8008f3 <_panic>
  80366d:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803673:	8b 45 08             	mov    0x8(%ebp),%eax
  803676:	89 50 04             	mov    %edx,0x4(%eax)
  803679:	8b 45 08             	mov    0x8(%ebp),%eax
  80367c:	8b 40 04             	mov    0x4(%eax),%eax
  80367f:	85 c0                	test   %eax,%eax
  803681:	74 0c                	je     80368f <insert_sorted_with_merge_freeList+0x2cd>
  803683:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803688:	8b 55 08             	mov    0x8(%ebp),%edx
  80368b:	89 10                	mov    %edx,(%eax)
  80368d:	eb 08                	jmp    803697 <insert_sorted_with_merge_freeList+0x2d5>
  80368f:	8b 45 08             	mov    0x8(%ebp),%eax
  803692:	a3 38 51 80 00       	mov    %eax,0x805138
  803697:	8b 45 08             	mov    0x8(%ebp),%eax
  80369a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80369f:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036a8:	a1 44 51 80 00       	mov    0x805144,%eax
  8036ad:	40                   	inc    %eax
  8036ae:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8036b3:	e9 53 04 00 00       	jmp    803b0b <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8036b8:	a1 38 51 80 00       	mov    0x805138,%eax
  8036bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036c0:	e9 15 04 00 00       	jmp    803ada <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8036c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c8:	8b 00                	mov    (%eax),%eax
  8036ca:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8036cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d0:	8b 50 08             	mov    0x8(%eax),%edx
  8036d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d6:	8b 40 08             	mov    0x8(%eax),%eax
  8036d9:	39 c2                	cmp    %eax,%edx
  8036db:	0f 86 f1 03 00 00    	jbe    803ad2 <insert_sorted_with_merge_freeList+0x710>
  8036e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e4:	8b 50 08             	mov    0x8(%eax),%edx
  8036e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036ea:	8b 40 08             	mov    0x8(%eax),%eax
  8036ed:	39 c2                	cmp    %eax,%edx
  8036ef:	0f 83 dd 03 00 00    	jae    803ad2 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8036f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f8:	8b 50 08             	mov    0x8(%eax),%edx
  8036fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036fe:	8b 40 0c             	mov    0xc(%eax),%eax
  803701:	01 c2                	add    %eax,%edx
  803703:	8b 45 08             	mov    0x8(%ebp),%eax
  803706:	8b 40 08             	mov    0x8(%eax),%eax
  803709:	39 c2                	cmp    %eax,%edx
  80370b:	0f 85 b9 01 00 00    	jne    8038ca <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803711:	8b 45 08             	mov    0x8(%ebp),%eax
  803714:	8b 50 08             	mov    0x8(%eax),%edx
  803717:	8b 45 08             	mov    0x8(%ebp),%eax
  80371a:	8b 40 0c             	mov    0xc(%eax),%eax
  80371d:	01 c2                	add    %eax,%edx
  80371f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803722:	8b 40 08             	mov    0x8(%eax),%eax
  803725:	39 c2                	cmp    %eax,%edx
  803727:	0f 85 0d 01 00 00    	jne    80383a <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  80372d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803730:	8b 50 0c             	mov    0xc(%eax),%edx
  803733:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803736:	8b 40 0c             	mov    0xc(%eax),%eax
  803739:	01 c2                	add    %eax,%edx
  80373b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80373e:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803741:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803745:	75 17                	jne    80375e <insert_sorted_with_merge_freeList+0x39c>
  803747:	83 ec 04             	sub    $0x4,%esp
  80374a:	68 40 47 80 00       	push   $0x804740
  80374f:	68 5c 01 00 00       	push   $0x15c
  803754:	68 97 46 80 00       	push   $0x804697
  803759:	e8 95 d1 ff ff       	call   8008f3 <_panic>
  80375e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803761:	8b 00                	mov    (%eax),%eax
  803763:	85 c0                	test   %eax,%eax
  803765:	74 10                	je     803777 <insert_sorted_with_merge_freeList+0x3b5>
  803767:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80376a:	8b 00                	mov    (%eax),%eax
  80376c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80376f:	8b 52 04             	mov    0x4(%edx),%edx
  803772:	89 50 04             	mov    %edx,0x4(%eax)
  803775:	eb 0b                	jmp    803782 <insert_sorted_with_merge_freeList+0x3c0>
  803777:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80377a:	8b 40 04             	mov    0x4(%eax),%eax
  80377d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803782:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803785:	8b 40 04             	mov    0x4(%eax),%eax
  803788:	85 c0                	test   %eax,%eax
  80378a:	74 0f                	je     80379b <insert_sorted_with_merge_freeList+0x3d9>
  80378c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80378f:	8b 40 04             	mov    0x4(%eax),%eax
  803792:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803795:	8b 12                	mov    (%edx),%edx
  803797:	89 10                	mov    %edx,(%eax)
  803799:	eb 0a                	jmp    8037a5 <insert_sorted_with_merge_freeList+0x3e3>
  80379b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80379e:	8b 00                	mov    (%eax),%eax
  8037a0:	a3 38 51 80 00       	mov    %eax,0x805138
  8037a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037b1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037b8:	a1 44 51 80 00       	mov    0x805144,%eax
  8037bd:	48                   	dec    %eax
  8037be:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8037c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037c6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8037cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037d0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8037d7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8037db:	75 17                	jne    8037f4 <insert_sorted_with_merge_freeList+0x432>
  8037dd:	83 ec 04             	sub    $0x4,%esp
  8037e0:	68 74 46 80 00       	push   $0x804674
  8037e5:	68 5f 01 00 00       	push   $0x15f
  8037ea:	68 97 46 80 00       	push   $0x804697
  8037ef:	e8 ff d0 ff ff       	call   8008f3 <_panic>
  8037f4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8037fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037fd:	89 10                	mov    %edx,(%eax)
  8037ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803802:	8b 00                	mov    (%eax),%eax
  803804:	85 c0                	test   %eax,%eax
  803806:	74 0d                	je     803815 <insert_sorted_with_merge_freeList+0x453>
  803808:	a1 48 51 80 00       	mov    0x805148,%eax
  80380d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803810:	89 50 04             	mov    %edx,0x4(%eax)
  803813:	eb 08                	jmp    80381d <insert_sorted_with_merge_freeList+0x45b>
  803815:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803818:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80381d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803820:	a3 48 51 80 00       	mov    %eax,0x805148
  803825:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803828:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80382f:	a1 54 51 80 00       	mov    0x805154,%eax
  803834:	40                   	inc    %eax
  803835:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  80383a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80383d:	8b 50 0c             	mov    0xc(%eax),%edx
  803840:	8b 45 08             	mov    0x8(%ebp),%eax
  803843:	8b 40 0c             	mov    0xc(%eax),%eax
  803846:	01 c2                	add    %eax,%edx
  803848:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80384b:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80384e:	8b 45 08             	mov    0x8(%ebp),%eax
  803851:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803858:	8b 45 08             	mov    0x8(%ebp),%eax
  80385b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803862:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803866:	75 17                	jne    80387f <insert_sorted_with_merge_freeList+0x4bd>
  803868:	83 ec 04             	sub    $0x4,%esp
  80386b:	68 74 46 80 00       	push   $0x804674
  803870:	68 64 01 00 00       	push   $0x164
  803875:	68 97 46 80 00       	push   $0x804697
  80387a:	e8 74 d0 ff ff       	call   8008f3 <_panic>
  80387f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803885:	8b 45 08             	mov    0x8(%ebp),%eax
  803888:	89 10                	mov    %edx,(%eax)
  80388a:	8b 45 08             	mov    0x8(%ebp),%eax
  80388d:	8b 00                	mov    (%eax),%eax
  80388f:	85 c0                	test   %eax,%eax
  803891:	74 0d                	je     8038a0 <insert_sorted_with_merge_freeList+0x4de>
  803893:	a1 48 51 80 00       	mov    0x805148,%eax
  803898:	8b 55 08             	mov    0x8(%ebp),%edx
  80389b:	89 50 04             	mov    %edx,0x4(%eax)
  80389e:	eb 08                	jmp    8038a8 <insert_sorted_with_merge_freeList+0x4e6>
  8038a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8038a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ab:	a3 48 51 80 00       	mov    %eax,0x805148
  8038b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038ba:	a1 54 51 80 00       	mov    0x805154,%eax
  8038bf:	40                   	inc    %eax
  8038c0:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8038c5:	e9 41 02 00 00       	jmp    803b0b <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8038ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8038cd:	8b 50 08             	mov    0x8(%eax),%edx
  8038d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8038d6:	01 c2                	add    %eax,%edx
  8038d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038db:	8b 40 08             	mov    0x8(%eax),%eax
  8038de:	39 c2                	cmp    %eax,%edx
  8038e0:	0f 85 7c 01 00 00    	jne    803a62 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8038e6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8038ea:	74 06                	je     8038f2 <insert_sorted_with_merge_freeList+0x530>
  8038ec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038f0:	75 17                	jne    803909 <insert_sorted_with_merge_freeList+0x547>
  8038f2:	83 ec 04             	sub    $0x4,%esp
  8038f5:	68 b0 46 80 00       	push   $0x8046b0
  8038fa:	68 69 01 00 00       	push   $0x169
  8038ff:	68 97 46 80 00       	push   $0x804697
  803904:	e8 ea cf ff ff       	call   8008f3 <_panic>
  803909:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80390c:	8b 50 04             	mov    0x4(%eax),%edx
  80390f:	8b 45 08             	mov    0x8(%ebp),%eax
  803912:	89 50 04             	mov    %edx,0x4(%eax)
  803915:	8b 45 08             	mov    0x8(%ebp),%eax
  803918:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80391b:	89 10                	mov    %edx,(%eax)
  80391d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803920:	8b 40 04             	mov    0x4(%eax),%eax
  803923:	85 c0                	test   %eax,%eax
  803925:	74 0d                	je     803934 <insert_sorted_with_merge_freeList+0x572>
  803927:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80392a:	8b 40 04             	mov    0x4(%eax),%eax
  80392d:	8b 55 08             	mov    0x8(%ebp),%edx
  803930:	89 10                	mov    %edx,(%eax)
  803932:	eb 08                	jmp    80393c <insert_sorted_with_merge_freeList+0x57a>
  803934:	8b 45 08             	mov    0x8(%ebp),%eax
  803937:	a3 38 51 80 00       	mov    %eax,0x805138
  80393c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80393f:	8b 55 08             	mov    0x8(%ebp),%edx
  803942:	89 50 04             	mov    %edx,0x4(%eax)
  803945:	a1 44 51 80 00       	mov    0x805144,%eax
  80394a:	40                   	inc    %eax
  80394b:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803950:	8b 45 08             	mov    0x8(%ebp),%eax
  803953:	8b 50 0c             	mov    0xc(%eax),%edx
  803956:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803959:	8b 40 0c             	mov    0xc(%eax),%eax
  80395c:	01 c2                	add    %eax,%edx
  80395e:	8b 45 08             	mov    0x8(%ebp),%eax
  803961:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803964:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803968:	75 17                	jne    803981 <insert_sorted_with_merge_freeList+0x5bf>
  80396a:	83 ec 04             	sub    $0x4,%esp
  80396d:	68 40 47 80 00       	push   $0x804740
  803972:	68 6b 01 00 00       	push   $0x16b
  803977:	68 97 46 80 00       	push   $0x804697
  80397c:	e8 72 cf ff ff       	call   8008f3 <_panic>
  803981:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803984:	8b 00                	mov    (%eax),%eax
  803986:	85 c0                	test   %eax,%eax
  803988:	74 10                	je     80399a <insert_sorted_with_merge_freeList+0x5d8>
  80398a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80398d:	8b 00                	mov    (%eax),%eax
  80398f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803992:	8b 52 04             	mov    0x4(%edx),%edx
  803995:	89 50 04             	mov    %edx,0x4(%eax)
  803998:	eb 0b                	jmp    8039a5 <insert_sorted_with_merge_freeList+0x5e3>
  80399a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80399d:	8b 40 04             	mov    0x4(%eax),%eax
  8039a0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8039a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039a8:	8b 40 04             	mov    0x4(%eax),%eax
  8039ab:	85 c0                	test   %eax,%eax
  8039ad:	74 0f                	je     8039be <insert_sorted_with_merge_freeList+0x5fc>
  8039af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039b2:	8b 40 04             	mov    0x4(%eax),%eax
  8039b5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039b8:	8b 12                	mov    (%edx),%edx
  8039ba:	89 10                	mov    %edx,(%eax)
  8039bc:	eb 0a                	jmp    8039c8 <insert_sorted_with_merge_freeList+0x606>
  8039be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039c1:	8b 00                	mov    (%eax),%eax
  8039c3:	a3 38 51 80 00       	mov    %eax,0x805138
  8039c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039d4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039db:	a1 44 51 80 00       	mov    0x805144,%eax
  8039e0:	48                   	dec    %eax
  8039e1:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8039e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039e9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8039f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039f3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8039fa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8039fe:	75 17                	jne    803a17 <insert_sorted_with_merge_freeList+0x655>
  803a00:	83 ec 04             	sub    $0x4,%esp
  803a03:	68 74 46 80 00       	push   $0x804674
  803a08:	68 6e 01 00 00       	push   $0x16e
  803a0d:	68 97 46 80 00       	push   $0x804697
  803a12:	e8 dc ce ff ff       	call   8008f3 <_panic>
  803a17:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a1d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a20:	89 10                	mov    %edx,(%eax)
  803a22:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a25:	8b 00                	mov    (%eax),%eax
  803a27:	85 c0                	test   %eax,%eax
  803a29:	74 0d                	je     803a38 <insert_sorted_with_merge_freeList+0x676>
  803a2b:	a1 48 51 80 00       	mov    0x805148,%eax
  803a30:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a33:	89 50 04             	mov    %edx,0x4(%eax)
  803a36:	eb 08                	jmp    803a40 <insert_sorted_with_merge_freeList+0x67e>
  803a38:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a3b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803a40:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a43:	a3 48 51 80 00       	mov    %eax,0x805148
  803a48:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a4b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a52:	a1 54 51 80 00       	mov    0x805154,%eax
  803a57:	40                   	inc    %eax
  803a58:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803a5d:	e9 a9 00 00 00       	jmp    803b0b <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803a62:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a66:	74 06                	je     803a6e <insert_sorted_with_merge_freeList+0x6ac>
  803a68:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a6c:	75 17                	jne    803a85 <insert_sorted_with_merge_freeList+0x6c3>
  803a6e:	83 ec 04             	sub    $0x4,%esp
  803a71:	68 0c 47 80 00       	push   $0x80470c
  803a76:	68 73 01 00 00       	push   $0x173
  803a7b:	68 97 46 80 00       	push   $0x804697
  803a80:	e8 6e ce ff ff       	call   8008f3 <_panic>
  803a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a88:	8b 10                	mov    (%eax),%edx
  803a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a8d:	89 10                	mov    %edx,(%eax)
  803a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  803a92:	8b 00                	mov    (%eax),%eax
  803a94:	85 c0                	test   %eax,%eax
  803a96:	74 0b                	je     803aa3 <insert_sorted_with_merge_freeList+0x6e1>
  803a98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a9b:	8b 00                	mov    (%eax),%eax
  803a9d:	8b 55 08             	mov    0x8(%ebp),%edx
  803aa0:	89 50 04             	mov    %edx,0x4(%eax)
  803aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aa6:	8b 55 08             	mov    0x8(%ebp),%edx
  803aa9:	89 10                	mov    %edx,(%eax)
  803aab:	8b 45 08             	mov    0x8(%ebp),%eax
  803aae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ab1:	89 50 04             	mov    %edx,0x4(%eax)
  803ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  803ab7:	8b 00                	mov    (%eax),%eax
  803ab9:	85 c0                	test   %eax,%eax
  803abb:	75 08                	jne    803ac5 <insert_sorted_with_merge_freeList+0x703>
  803abd:	8b 45 08             	mov    0x8(%ebp),%eax
  803ac0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803ac5:	a1 44 51 80 00       	mov    0x805144,%eax
  803aca:	40                   	inc    %eax
  803acb:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803ad0:	eb 39                	jmp    803b0b <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803ad2:	a1 40 51 80 00       	mov    0x805140,%eax
  803ad7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ada:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ade:	74 07                	je     803ae7 <insert_sorted_with_merge_freeList+0x725>
  803ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ae3:	8b 00                	mov    (%eax),%eax
  803ae5:	eb 05                	jmp    803aec <insert_sorted_with_merge_freeList+0x72a>
  803ae7:	b8 00 00 00 00       	mov    $0x0,%eax
  803aec:	a3 40 51 80 00       	mov    %eax,0x805140
  803af1:	a1 40 51 80 00       	mov    0x805140,%eax
  803af6:	85 c0                	test   %eax,%eax
  803af8:	0f 85 c7 fb ff ff    	jne    8036c5 <insert_sorted_with_merge_freeList+0x303>
  803afe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b02:	0f 85 bd fb ff ff    	jne    8036c5 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803b08:	eb 01                	jmp    803b0b <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803b0a:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803b0b:	90                   	nop
  803b0c:	c9                   	leave  
  803b0d:	c3                   	ret    
  803b0e:	66 90                	xchg   %ax,%ax

00803b10 <__udivdi3>:
  803b10:	55                   	push   %ebp
  803b11:	57                   	push   %edi
  803b12:	56                   	push   %esi
  803b13:	53                   	push   %ebx
  803b14:	83 ec 1c             	sub    $0x1c,%esp
  803b17:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803b1b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b1f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b23:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b27:	89 ca                	mov    %ecx,%edx
  803b29:	89 f8                	mov    %edi,%eax
  803b2b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803b2f:	85 f6                	test   %esi,%esi
  803b31:	75 2d                	jne    803b60 <__udivdi3+0x50>
  803b33:	39 cf                	cmp    %ecx,%edi
  803b35:	77 65                	ja     803b9c <__udivdi3+0x8c>
  803b37:	89 fd                	mov    %edi,%ebp
  803b39:	85 ff                	test   %edi,%edi
  803b3b:	75 0b                	jne    803b48 <__udivdi3+0x38>
  803b3d:	b8 01 00 00 00       	mov    $0x1,%eax
  803b42:	31 d2                	xor    %edx,%edx
  803b44:	f7 f7                	div    %edi
  803b46:	89 c5                	mov    %eax,%ebp
  803b48:	31 d2                	xor    %edx,%edx
  803b4a:	89 c8                	mov    %ecx,%eax
  803b4c:	f7 f5                	div    %ebp
  803b4e:	89 c1                	mov    %eax,%ecx
  803b50:	89 d8                	mov    %ebx,%eax
  803b52:	f7 f5                	div    %ebp
  803b54:	89 cf                	mov    %ecx,%edi
  803b56:	89 fa                	mov    %edi,%edx
  803b58:	83 c4 1c             	add    $0x1c,%esp
  803b5b:	5b                   	pop    %ebx
  803b5c:	5e                   	pop    %esi
  803b5d:	5f                   	pop    %edi
  803b5e:	5d                   	pop    %ebp
  803b5f:	c3                   	ret    
  803b60:	39 ce                	cmp    %ecx,%esi
  803b62:	77 28                	ja     803b8c <__udivdi3+0x7c>
  803b64:	0f bd fe             	bsr    %esi,%edi
  803b67:	83 f7 1f             	xor    $0x1f,%edi
  803b6a:	75 40                	jne    803bac <__udivdi3+0x9c>
  803b6c:	39 ce                	cmp    %ecx,%esi
  803b6e:	72 0a                	jb     803b7a <__udivdi3+0x6a>
  803b70:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803b74:	0f 87 9e 00 00 00    	ja     803c18 <__udivdi3+0x108>
  803b7a:	b8 01 00 00 00       	mov    $0x1,%eax
  803b7f:	89 fa                	mov    %edi,%edx
  803b81:	83 c4 1c             	add    $0x1c,%esp
  803b84:	5b                   	pop    %ebx
  803b85:	5e                   	pop    %esi
  803b86:	5f                   	pop    %edi
  803b87:	5d                   	pop    %ebp
  803b88:	c3                   	ret    
  803b89:	8d 76 00             	lea    0x0(%esi),%esi
  803b8c:	31 ff                	xor    %edi,%edi
  803b8e:	31 c0                	xor    %eax,%eax
  803b90:	89 fa                	mov    %edi,%edx
  803b92:	83 c4 1c             	add    $0x1c,%esp
  803b95:	5b                   	pop    %ebx
  803b96:	5e                   	pop    %esi
  803b97:	5f                   	pop    %edi
  803b98:	5d                   	pop    %ebp
  803b99:	c3                   	ret    
  803b9a:	66 90                	xchg   %ax,%ax
  803b9c:	89 d8                	mov    %ebx,%eax
  803b9e:	f7 f7                	div    %edi
  803ba0:	31 ff                	xor    %edi,%edi
  803ba2:	89 fa                	mov    %edi,%edx
  803ba4:	83 c4 1c             	add    $0x1c,%esp
  803ba7:	5b                   	pop    %ebx
  803ba8:	5e                   	pop    %esi
  803ba9:	5f                   	pop    %edi
  803baa:	5d                   	pop    %ebp
  803bab:	c3                   	ret    
  803bac:	bd 20 00 00 00       	mov    $0x20,%ebp
  803bb1:	89 eb                	mov    %ebp,%ebx
  803bb3:	29 fb                	sub    %edi,%ebx
  803bb5:	89 f9                	mov    %edi,%ecx
  803bb7:	d3 e6                	shl    %cl,%esi
  803bb9:	89 c5                	mov    %eax,%ebp
  803bbb:	88 d9                	mov    %bl,%cl
  803bbd:	d3 ed                	shr    %cl,%ebp
  803bbf:	89 e9                	mov    %ebp,%ecx
  803bc1:	09 f1                	or     %esi,%ecx
  803bc3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803bc7:	89 f9                	mov    %edi,%ecx
  803bc9:	d3 e0                	shl    %cl,%eax
  803bcb:	89 c5                	mov    %eax,%ebp
  803bcd:	89 d6                	mov    %edx,%esi
  803bcf:	88 d9                	mov    %bl,%cl
  803bd1:	d3 ee                	shr    %cl,%esi
  803bd3:	89 f9                	mov    %edi,%ecx
  803bd5:	d3 e2                	shl    %cl,%edx
  803bd7:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bdb:	88 d9                	mov    %bl,%cl
  803bdd:	d3 e8                	shr    %cl,%eax
  803bdf:	09 c2                	or     %eax,%edx
  803be1:	89 d0                	mov    %edx,%eax
  803be3:	89 f2                	mov    %esi,%edx
  803be5:	f7 74 24 0c          	divl   0xc(%esp)
  803be9:	89 d6                	mov    %edx,%esi
  803beb:	89 c3                	mov    %eax,%ebx
  803bed:	f7 e5                	mul    %ebp
  803bef:	39 d6                	cmp    %edx,%esi
  803bf1:	72 19                	jb     803c0c <__udivdi3+0xfc>
  803bf3:	74 0b                	je     803c00 <__udivdi3+0xf0>
  803bf5:	89 d8                	mov    %ebx,%eax
  803bf7:	31 ff                	xor    %edi,%edi
  803bf9:	e9 58 ff ff ff       	jmp    803b56 <__udivdi3+0x46>
  803bfe:	66 90                	xchg   %ax,%ax
  803c00:	8b 54 24 08          	mov    0x8(%esp),%edx
  803c04:	89 f9                	mov    %edi,%ecx
  803c06:	d3 e2                	shl    %cl,%edx
  803c08:	39 c2                	cmp    %eax,%edx
  803c0a:	73 e9                	jae    803bf5 <__udivdi3+0xe5>
  803c0c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803c0f:	31 ff                	xor    %edi,%edi
  803c11:	e9 40 ff ff ff       	jmp    803b56 <__udivdi3+0x46>
  803c16:	66 90                	xchg   %ax,%ax
  803c18:	31 c0                	xor    %eax,%eax
  803c1a:	e9 37 ff ff ff       	jmp    803b56 <__udivdi3+0x46>
  803c1f:	90                   	nop

00803c20 <__umoddi3>:
  803c20:	55                   	push   %ebp
  803c21:	57                   	push   %edi
  803c22:	56                   	push   %esi
  803c23:	53                   	push   %ebx
  803c24:	83 ec 1c             	sub    $0x1c,%esp
  803c27:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803c2b:	8b 74 24 34          	mov    0x34(%esp),%esi
  803c2f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c33:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c37:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c3b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c3f:	89 f3                	mov    %esi,%ebx
  803c41:	89 fa                	mov    %edi,%edx
  803c43:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c47:	89 34 24             	mov    %esi,(%esp)
  803c4a:	85 c0                	test   %eax,%eax
  803c4c:	75 1a                	jne    803c68 <__umoddi3+0x48>
  803c4e:	39 f7                	cmp    %esi,%edi
  803c50:	0f 86 a2 00 00 00    	jbe    803cf8 <__umoddi3+0xd8>
  803c56:	89 c8                	mov    %ecx,%eax
  803c58:	89 f2                	mov    %esi,%edx
  803c5a:	f7 f7                	div    %edi
  803c5c:	89 d0                	mov    %edx,%eax
  803c5e:	31 d2                	xor    %edx,%edx
  803c60:	83 c4 1c             	add    $0x1c,%esp
  803c63:	5b                   	pop    %ebx
  803c64:	5e                   	pop    %esi
  803c65:	5f                   	pop    %edi
  803c66:	5d                   	pop    %ebp
  803c67:	c3                   	ret    
  803c68:	39 f0                	cmp    %esi,%eax
  803c6a:	0f 87 ac 00 00 00    	ja     803d1c <__umoddi3+0xfc>
  803c70:	0f bd e8             	bsr    %eax,%ebp
  803c73:	83 f5 1f             	xor    $0x1f,%ebp
  803c76:	0f 84 ac 00 00 00    	je     803d28 <__umoddi3+0x108>
  803c7c:	bf 20 00 00 00       	mov    $0x20,%edi
  803c81:	29 ef                	sub    %ebp,%edi
  803c83:	89 fe                	mov    %edi,%esi
  803c85:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803c89:	89 e9                	mov    %ebp,%ecx
  803c8b:	d3 e0                	shl    %cl,%eax
  803c8d:	89 d7                	mov    %edx,%edi
  803c8f:	89 f1                	mov    %esi,%ecx
  803c91:	d3 ef                	shr    %cl,%edi
  803c93:	09 c7                	or     %eax,%edi
  803c95:	89 e9                	mov    %ebp,%ecx
  803c97:	d3 e2                	shl    %cl,%edx
  803c99:	89 14 24             	mov    %edx,(%esp)
  803c9c:	89 d8                	mov    %ebx,%eax
  803c9e:	d3 e0                	shl    %cl,%eax
  803ca0:	89 c2                	mov    %eax,%edx
  803ca2:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ca6:	d3 e0                	shl    %cl,%eax
  803ca8:	89 44 24 04          	mov    %eax,0x4(%esp)
  803cac:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cb0:	89 f1                	mov    %esi,%ecx
  803cb2:	d3 e8                	shr    %cl,%eax
  803cb4:	09 d0                	or     %edx,%eax
  803cb6:	d3 eb                	shr    %cl,%ebx
  803cb8:	89 da                	mov    %ebx,%edx
  803cba:	f7 f7                	div    %edi
  803cbc:	89 d3                	mov    %edx,%ebx
  803cbe:	f7 24 24             	mull   (%esp)
  803cc1:	89 c6                	mov    %eax,%esi
  803cc3:	89 d1                	mov    %edx,%ecx
  803cc5:	39 d3                	cmp    %edx,%ebx
  803cc7:	0f 82 87 00 00 00    	jb     803d54 <__umoddi3+0x134>
  803ccd:	0f 84 91 00 00 00    	je     803d64 <__umoddi3+0x144>
  803cd3:	8b 54 24 04          	mov    0x4(%esp),%edx
  803cd7:	29 f2                	sub    %esi,%edx
  803cd9:	19 cb                	sbb    %ecx,%ebx
  803cdb:	89 d8                	mov    %ebx,%eax
  803cdd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803ce1:	d3 e0                	shl    %cl,%eax
  803ce3:	89 e9                	mov    %ebp,%ecx
  803ce5:	d3 ea                	shr    %cl,%edx
  803ce7:	09 d0                	or     %edx,%eax
  803ce9:	89 e9                	mov    %ebp,%ecx
  803ceb:	d3 eb                	shr    %cl,%ebx
  803ced:	89 da                	mov    %ebx,%edx
  803cef:	83 c4 1c             	add    $0x1c,%esp
  803cf2:	5b                   	pop    %ebx
  803cf3:	5e                   	pop    %esi
  803cf4:	5f                   	pop    %edi
  803cf5:	5d                   	pop    %ebp
  803cf6:	c3                   	ret    
  803cf7:	90                   	nop
  803cf8:	89 fd                	mov    %edi,%ebp
  803cfa:	85 ff                	test   %edi,%edi
  803cfc:	75 0b                	jne    803d09 <__umoddi3+0xe9>
  803cfe:	b8 01 00 00 00       	mov    $0x1,%eax
  803d03:	31 d2                	xor    %edx,%edx
  803d05:	f7 f7                	div    %edi
  803d07:	89 c5                	mov    %eax,%ebp
  803d09:	89 f0                	mov    %esi,%eax
  803d0b:	31 d2                	xor    %edx,%edx
  803d0d:	f7 f5                	div    %ebp
  803d0f:	89 c8                	mov    %ecx,%eax
  803d11:	f7 f5                	div    %ebp
  803d13:	89 d0                	mov    %edx,%eax
  803d15:	e9 44 ff ff ff       	jmp    803c5e <__umoddi3+0x3e>
  803d1a:	66 90                	xchg   %ax,%ax
  803d1c:	89 c8                	mov    %ecx,%eax
  803d1e:	89 f2                	mov    %esi,%edx
  803d20:	83 c4 1c             	add    $0x1c,%esp
  803d23:	5b                   	pop    %ebx
  803d24:	5e                   	pop    %esi
  803d25:	5f                   	pop    %edi
  803d26:	5d                   	pop    %ebp
  803d27:	c3                   	ret    
  803d28:	3b 04 24             	cmp    (%esp),%eax
  803d2b:	72 06                	jb     803d33 <__umoddi3+0x113>
  803d2d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803d31:	77 0f                	ja     803d42 <__umoddi3+0x122>
  803d33:	89 f2                	mov    %esi,%edx
  803d35:	29 f9                	sub    %edi,%ecx
  803d37:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d3b:	89 14 24             	mov    %edx,(%esp)
  803d3e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d42:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d46:	8b 14 24             	mov    (%esp),%edx
  803d49:	83 c4 1c             	add    $0x1c,%esp
  803d4c:	5b                   	pop    %ebx
  803d4d:	5e                   	pop    %esi
  803d4e:	5f                   	pop    %edi
  803d4f:	5d                   	pop    %ebp
  803d50:	c3                   	ret    
  803d51:	8d 76 00             	lea    0x0(%esi),%esi
  803d54:	2b 04 24             	sub    (%esp),%eax
  803d57:	19 fa                	sbb    %edi,%edx
  803d59:	89 d1                	mov    %edx,%ecx
  803d5b:	89 c6                	mov    %eax,%esi
  803d5d:	e9 71 ff ff ff       	jmp    803cd3 <__umoddi3+0xb3>
  803d62:	66 90                	xchg   %ax,%ax
  803d64:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803d68:	72 ea                	jb     803d54 <__umoddi3+0x134>
  803d6a:	89 d9                	mov    %ebx,%ecx
  803d6c:	e9 62 ff ff ff       	jmp    803cd3 <__umoddi3+0xb3>
