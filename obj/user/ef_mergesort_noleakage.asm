
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
  800041:	e8 83 1e 00 00       	call   801ec9 <sys_disable_interrupt>

		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 20 3c 80 00       	push   $0x803c20
  80004e:	e8 54 0b 00 00       	call   800ba7 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 22 3c 80 00       	push   $0x803c22
  80005e:	e8 44 0b 00 00       	call   800ba7 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 38 3c 80 00       	push   $0x803c38
  80006e:	e8 34 0b 00 00       	call   800ba7 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 22 3c 80 00       	push   $0x803c22
  80007e:	e8 24 0b 00 00       	call   800ba7 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 20 3c 80 00       	push   $0x803c20
  80008e:	e8 14 0b 00 00       	call   800ba7 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
		//readline("Enter the number of elements: ", Line);
		cprintf("Enter the number of elements: ");
  800096:	83 ec 0c             	sub    $0xc,%esp
  800099:	68 50 3c 80 00       	push   $0x803c50
  80009e:	e8 04 0b 00 00       	call   800ba7 <cprintf>
  8000a3:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = 2000 ;
  8000a6:	c7 45 f0 d0 07 00 00 	movl   $0x7d0,-0x10(%ebp)
		cprintf("%d\n", NumOfElements) ;
  8000ad:	83 ec 08             	sub    $0x8,%esp
  8000b0:	ff 75 f0             	pushl  -0x10(%ebp)
  8000b3:	68 6f 3c 80 00       	push   $0x803c6f
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
  8000d8:	68 74 3c 80 00       	push   $0x803c74
  8000dd:	e8 c5 0a 00 00       	call   800ba7 <cprintf>
  8000e2:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	68 96 3c 80 00       	push   $0x803c96
  8000ed:	e8 b5 0a 00 00       	call   800ba7 <cprintf>
  8000f2:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000f5:	83 ec 0c             	sub    $0xc,%esp
  8000f8:	68 a4 3c 80 00       	push   $0x803ca4
  8000fd:	e8 a5 0a 00 00       	call   800ba7 <cprintf>
  800102:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  800105:	83 ec 0c             	sub    $0xc,%esp
  800108:	68 b3 3c 80 00       	push   $0x803cb3
  80010d:	e8 95 0a 00 00       	call   800ba7 <cprintf>
  800112:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800115:	83 ec 0c             	sub    $0xc,%esp
  800118:	68 c3 3c 80 00       	push   $0x803cc3
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
  800158:	e8 86 1d 00 00       	call   801ee3 <sys_enable_interrupt>

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
  8001cd:	e8 f7 1c 00 00       	call   801ec9 <sys_disable_interrupt>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001d2:	83 ec 0c             	sub    $0xc,%esp
  8001d5:	68 cc 3c 80 00       	push   $0x803ccc
  8001da:	e8 c8 09 00 00       	call   800ba7 <cprintf>
  8001df:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001e2:	e8 fc 1c 00 00       	call   801ee3 <sys_enable_interrupt>

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
  800204:	68 00 3d 80 00       	push   $0x803d00
  800209:	6a 4e                	push   $0x4e
  80020b:	68 22 3d 80 00       	push   $0x803d22
  800210:	e8 de 06 00 00       	call   8008f3 <_panic>
		else
		{
			sys_disable_interrupt();
  800215:	e8 af 1c 00 00       	call   801ec9 <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  80021a:	83 ec 0c             	sub    $0xc,%esp
  80021d:	68 40 3d 80 00       	push   $0x803d40
  800222:	e8 80 09 00 00       	call   800ba7 <cprintf>
  800227:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  80022a:	83 ec 0c             	sub    $0xc,%esp
  80022d:	68 74 3d 80 00       	push   $0x803d74
  800232:	e8 70 09 00 00       	call   800ba7 <cprintf>
  800237:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  80023a:	83 ec 0c             	sub    $0xc,%esp
  80023d:	68 a8 3d 80 00       	push   $0x803da8
  800242:	e8 60 09 00 00       	call   800ba7 <cprintf>
  800247:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  80024a:	e8 94 1c 00 00       	call   801ee3 <sys_enable_interrupt>
		}

		free(Elements) ;
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	ff 75 ec             	pushl  -0x14(%ebp)
  800255:	e8 03 19 00 00       	call   801b5d <free>
  80025a:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  80025d:	e8 67 1c 00 00       	call   801ec9 <sys_disable_interrupt>
			Chose = 0 ;
  800262:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800266:	eb 3e                	jmp    8002a6 <_main+0x26e>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800268:	83 ec 0c             	sub    $0xc,%esp
  80026b:	68 da 3d 80 00       	push   $0x803dda
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
  8002b2:	e8 2c 1c 00 00       	call   801ee3 <sys_enable_interrupt>

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
  800446:	68 20 3c 80 00       	push   $0x803c20
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
  800468:	68 f8 3d 80 00       	push   $0x803df8
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
  800496:	68 6f 3c 80 00       	push   $0x803c6f
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
  80072b:	e8 cd 17 00 00       	call   801efd <sys_cputc>
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
  80073c:	e8 88 17 00 00       	call   801ec9 <sys_disable_interrupt>
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
  80074f:	e8 a9 17 00 00       	call   801efd <sys_cputc>
  800754:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800757:	e8 87 17 00 00       	call   801ee3 <sys_enable_interrupt>
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
  80076e:	e8 d1 15 00 00       	call   801d44 <sys_cgetc>
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
  800787:	e8 3d 17 00 00       	call   801ec9 <sys_disable_interrupt>
	int c=0;
  80078c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800793:	eb 08                	jmp    80079d <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800795:	e8 aa 15 00 00       	call   801d44 <sys_cgetc>
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
  8007a3:	e8 3b 17 00 00       	call   801ee3 <sys_enable_interrupt>
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
  8007bd:	e8 fa 18 00 00       	call   8020bc <sys_getenvindex>
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
  800828:	e8 9c 16 00 00       	call   801ec9 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80082d:	83 ec 0c             	sub    $0xc,%esp
  800830:	68 18 3e 80 00       	push   $0x803e18
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
  800858:	68 40 3e 80 00       	push   $0x803e40
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
  800889:	68 68 3e 80 00       	push   $0x803e68
  80088e:	e8 14 03 00 00       	call   800ba7 <cprintf>
  800893:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800896:	a1 24 50 80 00       	mov    0x805024,%eax
  80089b:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8008a1:	83 ec 08             	sub    $0x8,%esp
  8008a4:	50                   	push   %eax
  8008a5:	68 c0 3e 80 00       	push   $0x803ec0
  8008aa:	e8 f8 02 00 00       	call   800ba7 <cprintf>
  8008af:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8008b2:	83 ec 0c             	sub    $0xc,%esp
  8008b5:	68 18 3e 80 00       	push   $0x803e18
  8008ba:	e8 e8 02 00 00       	call   800ba7 <cprintf>
  8008bf:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8008c2:	e8 1c 16 00 00       	call   801ee3 <sys_enable_interrupt>

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
  8008da:	e8 a9 17 00 00       	call   802088 <sys_destroy_env>
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
  8008eb:	e8 fe 17 00 00       	call   8020ee <sys_exit_env>
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
  800914:	68 d4 3e 80 00       	push   $0x803ed4
  800919:	e8 89 02 00 00       	call   800ba7 <cprintf>
  80091e:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800921:	a1 00 50 80 00       	mov    0x805000,%eax
  800926:	ff 75 0c             	pushl  0xc(%ebp)
  800929:	ff 75 08             	pushl  0x8(%ebp)
  80092c:	50                   	push   %eax
  80092d:	68 d9 3e 80 00       	push   $0x803ed9
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
  800951:	68 f5 3e 80 00       	push   $0x803ef5
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
  80097d:	68 f8 3e 80 00       	push   $0x803ef8
  800982:	6a 26                	push   $0x26
  800984:	68 44 3f 80 00       	push   $0x803f44
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
  800a4f:	68 50 3f 80 00       	push   $0x803f50
  800a54:	6a 3a                	push   $0x3a
  800a56:	68 44 3f 80 00       	push   $0x803f44
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
  800abf:	68 a4 3f 80 00       	push   $0x803fa4
  800ac4:	6a 44                	push   $0x44
  800ac6:	68 44 3f 80 00       	push   $0x803f44
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
  800b19:	e8 fd 11 00 00       	call   801d1b <sys_cputs>
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
  800b90:	e8 86 11 00 00       	call   801d1b <sys_cputs>
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
  800bda:	e8 ea 12 00 00       	call   801ec9 <sys_disable_interrupt>
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
  800bfa:	e8 e4 12 00 00       	call   801ee3 <sys_enable_interrupt>
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
  800c44:	e8 57 2d 00 00       	call   8039a0 <__udivdi3>
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
  800c94:	e8 17 2e 00 00       	call   803ab0 <__umoddi3>
  800c99:	83 c4 10             	add    $0x10,%esp
  800c9c:	05 14 42 80 00       	add    $0x804214,%eax
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
  800def:	8b 04 85 38 42 80 00 	mov    0x804238(,%eax,4),%eax
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
  800ed0:	8b 34 9d 80 40 80 00 	mov    0x804080(,%ebx,4),%esi
  800ed7:	85 f6                	test   %esi,%esi
  800ed9:	75 19                	jne    800ef4 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800edb:	53                   	push   %ebx
  800edc:	68 25 42 80 00       	push   $0x804225
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
  800ef5:	68 2e 42 80 00       	push   $0x80422e
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
  800f22:	be 31 42 80 00       	mov    $0x804231,%esi
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
  801948:	68 90 43 80 00       	push   $0x804390
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
  801a18:	e8 42 04 00 00       	call   801e5f <sys_allocate_chunk>
  801a1d:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801a20:	a1 20 51 80 00       	mov    0x805120,%eax
  801a25:	83 ec 0c             	sub    $0xc,%esp
  801a28:	50                   	push   %eax
  801a29:	e8 b7 0a 00 00       	call   8024e5 <initialize_MemBlocksList>
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
  801a56:	68 b5 43 80 00       	push   $0x8043b5
  801a5b:	6a 33                	push   $0x33
  801a5d:	68 d3 43 80 00       	push   $0x8043d3
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
  801ad5:	68 e0 43 80 00       	push   $0x8043e0
  801ada:	6a 34                	push   $0x34
  801adc:	68 d3 43 80 00       	push   $0x8043d3
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
  801b4a:	68 04 44 80 00       	push   $0x804404
  801b4f:	6a 46                	push   $0x46
  801b51:	68 d3 43 80 00       	push   $0x8043d3
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
  801b66:	68 2c 44 80 00       	push   $0x80442c
  801b6b:	6a 61                	push   $0x61
  801b6d:	68 d3 43 80 00       	push   $0x8043d3
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
  801b8c:	75 0a                	jne    801b98 <smalloc+0x21>
  801b8e:	b8 00 00 00 00       	mov    $0x0,%eax
  801b93:	e9 9e 00 00 00       	jmp    801c36 <smalloc+0xbf>
	//3-If the Kernel successfully creates the shared variable, return its virtual address
	//4-Else, return NULL



	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801b98:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801b9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ba5:	01 d0                	add    %edx,%eax
  801ba7:	48                   	dec    %eax
  801ba8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801bab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bae:	ba 00 00 00 00       	mov    $0x0,%edx
  801bb3:	f7 75 f0             	divl   -0x10(%ebp)
  801bb6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bb9:	29 d0                	sub    %edx,%eax
  801bbb:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801bbe:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801bc5:	e8 63 06 00 00       	call   80222d <sys_isUHeapPlacementStrategyFIRSTFIT>
  801bca:	85 c0                	test   %eax,%eax
  801bcc:	74 11                	je     801bdf <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801bce:	83 ec 0c             	sub    $0xc,%esp
  801bd1:	ff 75 e8             	pushl  -0x18(%ebp)
  801bd4:	e8 ce 0c 00 00       	call   8028a7 <alloc_block_FF>
  801bd9:	83 c4 10             	add    $0x10,%esp
  801bdc:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801bdf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801be3:	74 4c                	je     801c31 <smalloc+0xba>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801be5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be8:	8b 40 08             	mov    0x8(%eax),%eax
  801beb:	89 c2                	mov    %eax,%edx
  801bed:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801bf1:	52                   	push   %edx
  801bf2:	50                   	push   %eax
  801bf3:	ff 75 0c             	pushl  0xc(%ebp)
  801bf6:	ff 75 08             	pushl  0x8(%ebp)
  801bf9:	e8 b4 03 00 00       	call   801fb2 <sys_createSharedObject>
  801bfe:	83 c4 10             	add    $0x10,%esp
  801c01:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("Output is :  %d \n" , result);
  801c04:	83 ec 08             	sub    $0x8,%esp
  801c07:	ff 75 e0             	pushl  -0x20(%ebp)
  801c0a:	68 4f 44 80 00       	push   $0x80444f
  801c0f:	e8 93 ef ff ff       	call   800ba7 <cprintf>
  801c14:	83 c4 10             	add    $0x10,%esp
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801c17:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801c1b:	74 14                	je     801c31 <smalloc+0xba>
  801c1d:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801c21:	74 0e                	je     801c31 <smalloc+0xba>
  801c23:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801c27:	74 08                	je     801c31 <smalloc+0xba>
			return (void*) mem_block->sva;
  801c29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c2c:	8b 40 08             	mov    0x8(%eax),%eax
  801c2f:	eb 05                	jmp    801c36 <smalloc+0xbf>
	}
	return NULL;
  801c31:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801c36:	c9                   	leave  
  801c37:	c3                   	ret    

00801c38 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801c38:	55                   	push   %ebp
  801c39:	89 e5                	mov    %esp,%ebp
  801c3b:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c3e:	e8 ee fc ff ff       	call   801931 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801c43:	83 ec 04             	sub    $0x4,%esp
  801c46:	68 64 44 80 00       	push   $0x804464
  801c4b:	68 ab 00 00 00       	push   $0xab
  801c50:	68 d3 43 80 00       	push   $0x8043d3
  801c55:	e8 99 ec ff ff       	call   8008f3 <_panic>

00801c5a <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801c5a:	55                   	push   %ebp
  801c5b:	89 e5                	mov    %esp,%ebp
  801c5d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c60:	e8 cc fc ff ff       	call   801931 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801c65:	83 ec 04             	sub    $0x4,%esp
  801c68:	68 88 44 80 00       	push   $0x804488
  801c6d:	68 ef 00 00 00       	push   $0xef
  801c72:	68 d3 43 80 00       	push   $0x8043d3
  801c77:	e8 77 ec ff ff       	call   8008f3 <_panic>

00801c7c <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801c7c:	55                   	push   %ebp
  801c7d:	89 e5                	mov    %esp,%ebp
  801c7f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801c82:	83 ec 04             	sub    $0x4,%esp
  801c85:	68 b0 44 80 00       	push   $0x8044b0
  801c8a:	68 03 01 00 00       	push   $0x103
  801c8f:	68 d3 43 80 00       	push   $0x8043d3
  801c94:	e8 5a ec ff ff       	call   8008f3 <_panic>

00801c99 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801c99:	55                   	push   %ebp
  801c9a:	89 e5                	mov    %esp,%ebp
  801c9c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c9f:	83 ec 04             	sub    $0x4,%esp
  801ca2:	68 d4 44 80 00       	push   $0x8044d4
  801ca7:	68 0e 01 00 00       	push   $0x10e
  801cac:	68 d3 43 80 00       	push   $0x8043d3
  801cb1:	e8 3d ec ff ff       	call   8008f3 <_panic>

00801cb6 <shrink>:

}
void shrink(uint32 newSize)
{
  801cb6:	55                   	push   %ebp
  801cb7:	89 e5                	mov    %esp,%ebp
  801cb9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801cbc:	83 ec 04             	sub    $0x4,%esp
  801cbf:	68 d4 44 80 00       	push   $0x8044d4
  801cc4:	68 13 01 00 00       	push   $0x113
  801cc9:	68 d3 43 80 00       	push   $0x8043d3
  801cce:	e8 20 ec ff ff       	call   8008f3 <_panic>

00801cd3 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801cd3:	55                   	push   %ebp
  801cd4:	89 e5                	mov    %esp,%ebp
  801cd6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801cd9:	83 ec 04             	sub    $0x4,%esp
  801cdc:	68 d4 44 80 00       	push   $0x8044d4
  801ce1:	68 18 01 00 00       	push   $0x118
  801ce6:	68 d3 43 80 00       	push   $0x8043d3
  801ceb:	e8 03 ec ff ff       	call   8008f3 <_panic>

00801cf0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801cf0:	55                   	push   %ebp
  801cf1:	89 e5                	mov    %esp,%ebp
  801cf3:	57                   	push   %edi
  801cf4:	56                   	push   %esi
  801cf5:	53                   	push   %ebx
  801cf6:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cff:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d02:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d05:	8b 7d 18             	mov    0x18(%ebp),%edi
  801d08:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801d0b:	cd 30                	int    $0x30
  801d0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801d10:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801d13:	83 c4 10             	add    $0x10,%esp
  801d16:	5b                   	pop    %ebx
  801d17:	5e                   	pop    %esi
  801d18:	5f                   	pop    %edi
  801d19:	5d                   	pop    %ebp
  801d1a:	c3                   	ret    

00801d1b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801d1b:	55                   	push   %ebp
  801d1c:	89 e5                	mov    %esp,%ebp
  801d1e:	83 ec 04             	sub    $0x4,%esp
  801d21:	8b 45 10             	mov    0x10(%ebp),%eax
  801d24:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801d27:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	52                   	push   %edx
  801d33:	ff 75 0c             	pushl  0xc(%ebp)
  801d36:	50                   	push   %eax
  801d37:	6a 00                	push   $0x0
  801d39:	e8 b2 ff ff ff       	call   801cf0 <syscall>
  801d3e:	83 c4 18             	add    $0x18,%esp
}
  801d41:	90                   	nop
  801d42:	c9                   	leave  
  801d43:	c3                   	ret    

00801d44 <sys_cgetc>:

int
sys_cgetc(void)
{
  801d44:	55                   	push   %ebp
  801d45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 01                	push   $0x1
  801d53:	e8 98 ff ff ff       	call   801cf0 <syscall>
  801d58:	83 c4 18             	add    $0x18,%esp
}
  801d5b:	c9                   	leave  
  801d5c:	c3                   	ret    

00801d5d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801d5d:	55                   	push   %ebp
  801d5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801d60:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d63:	8b 45 08             	mov    0x8(%ebp),%eax
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	52                   	push   %edx
  801d6d:	50                   	push   %eax
  801d6e:	6a 05                	push   $0x5
  801d70:	e8 7b ff ff ff       	call   801cf0 <syscall>
  801d75:	83 c4 18             	add    $0x18,%esp
}
  801d78:	c9                   	leave  
  801d79:	c3                   	ret    

00801d7a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801d7a:	55                   	push   %ebp
  801d7b:	89 e5                	mov    %esp,%ebp
  801d7d:	56                   	push   %esi
  801d7e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801d7f:	8b 75 18             	mov    0x18(%ebp),%esi
  801d82:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d85:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d88:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8e:	56                   	push   %esi
  801d8f:	53                   	push   %ebx
  801d90:	51                   	push   %ecx
  801d91:	52                   	push   %edx
  801d92:	50                   	push   %eax
  801d93:	6a 06                	push   $0x6
  801d95:	e8 56 ff ff ff       	call   801cf0 <syscall>
  801d9a:	83 c4 18             	add    $0x18,%esp
}
  801d9d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801da0:	5b                   	pop    %ebx
  801da1:	5e                   	pop    %esi
  801da2:	5d                   	pop    %ebp
  801da3:	c3                   	ret    

00801da4 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801da4:	55                   	push   %ebp
  801da5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801da7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801daa:	8b 45 08             	mov    0x8(%ebp),%eax
  801dad:	6a 00                	push   $0x0
  801daf:	6a 00                	push   $0x0
  801db1:	6a 00                	push   $0x0
  801db3:	52                   	push   %edx
  801db4:	50                   	push   %eax
  801db5:	6a 07                	push   $0x7
  801db7:	e8 34 ff ff ff       	call   801cf0 <syscall>
  801dbc:	83 c4 18             	add    $0x18,%esp
}
  801dbf:	c9                   	leave  
  801dc0:	c3                   	ret    

00801dc1 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801dc1:	55                   	push   %ebp
  801dc2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801dc4:	6a 00                	push   $0x0
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 00                	push   $0x0
  801dca:	ff 75 0c             	pushl  0xc(%ebp)
  801dcd:	ff 75 08             	pushl  0x8(%ebp)
  801dd0:	6a 08                	push   $0x8
  801dd2:	e8 19 ff ff ff       	call   801cf0 <syscall>
  801dd7:	83 c4 18             	add    $0x18,%esp
}
  801dda:	c9                   	leave  
  801ddb:	c3                   	ret    

00801ddc <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801ddc:	55                   	push   %ebp
  801ddd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	6a 00                	push   $0x0
  801de5:	6a 00                	push   $0x0
  801de7:	6a 00                	push   $0x0
  801de9:	6a 09                	push   $0x9
  801deb:	e8 00 ff ff ff       	call   801cf0 <syscall>
  801df0:	83 c4 18             	add    $0x18,%esp
}
  801df3:	c9                   	leave  
  801df4:	c3                   	ret    

00801df5 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801df5:	55                   	push   %ebp
  801df6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 00                	push   $0x0
  801e02:	6a 0a                	push   $0xa
  801e04:	e8 e7 fe ff ff       	call   801cf0 <syscall>
  801e09:	83 c4 18             	add    $0x18,%esp
}
  801e0c:	c9                   	leave  
  801e0d:	c3                   	ret    

00801e0e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801e0e:	55                   	push   %ebp
  801e0f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	6a 00                	push   $0x0
  801e19:	6a 00                	push   $0x0
  801e1b:	6a 0b                	push   $0xb
  801e1d:	e8 ce fe ff ff       	call   801cf0 <syscall>
  801e22:	83 c4 18             	add    $0x18,%esp
}
  801e25:	c9                   	leave  
  801e26:	c3                   	ret    

00801e27 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801e27:	55                   	push   %ebp
  801e28:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 00                	push   $0x0
  801e30:	ff 75 0c             	pushl  0xc(%ebp)
  801e33:	ff 75 08             	pushl  0x8(%ebp)
  801e36:	6a 0f                	push   $0xf
  801e38:	e8 b3 fe ff ff       	call   801cf0 <syscall>
  801e3d:	83 c4 18             	add    $0x18,%esp
	return;
  801e40:	90                   	nop
}
  801e41:	c9                   	leave  
  801e42:	c3                   	ret    

00801e43 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801e43:	55                   	push   %ebp
  801e44:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801e46:	6a 00                	push   $0x0
  801e48:	6a 00                	push   $0x0
  801e4a:	6a 00                	push   $0x0
  801e4c:	ff 75 0c             	pushl  0xc(%ebp)
  801e4f:	ff 75 08             	pushl  0x8(%ebp)
  801e52:	6a 10                	push   $0x10
  801e54:	e8 97 fe ff ff       	call   801cf0 <syscall>
  801e59:	83 c4 18             	add    $0x18,%esp
	return ;
  801e5c:	90                   	nop
}
  801e5d:	c9                   	leave  
  801e5e:	c3                   	ret    

00801e5f <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e5f:	55                   	push   %ebp
  801e60:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e62:	6a 00                	push   $0x0
  801e64:	6a 00                	push   $0x0
  801e66:	ff 75 10             	pushl  0x10(%ebp)
  801e69:	ff 75 0c             	pushl  0xc(%ebp)
  801e6c:	ff 75 08             	pushl  0x8(%ebp)
  801e6f:	6a 11                	push   $0x11
  801e71:	e8 7a fe ff ff       	call   801cf0 <syscall>
  801e76:	83 c4 18             	add    $0x18,%esp
	return ;
  801e79:	90                   	nop
}
  801e7a:	c9                   	leave  
  801e7b:	c3                   	ret    

00801e7c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801e7c:	55                   	push   %ebp
  801e7d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	6a 00                	push   $0x0
  801e87:	6a 00                	push   $0x0
  801e89:	6a 0c                	push   $0xc
  801e8b:	e8 60 fe ff ff       	call   801cf0 <syscall>
  801e90:	83 c4 18             	add    $0x18,%esp
}
  801e93:	c9                   	leave  
  801e94:	c3                   	ret    

00801e95 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801e95:	55                   	push   %ebp
  801e96:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 00                	push   $0x0
  801e9e:	6a 00                	push   $0x0
  801ea0:	ff 75 08             	pushl  0x8(%ebp)
  801ea3:	6a 0d                	push   $0xd
  801ea5:	e8 46 fe ff ff       	call   801cf0 <syscall>
  801eaa:	83 c4 18             	add    $0x18,%esp
}
  801ead:	c9                   	leave  
  801eae:	c3                   	ret    

00801eaf <sys_scarce_memory>:

void sys_scarce_memory()
{
  801eaf:	55                   	push   %ebp
  801eb0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 00                	push   $0x0
  801eba:	6a 00                	push   $0x0
  801ebc:	6a 0e                	push   $0xe
  801ebe:	e8 2d fe ff ff       	call   801cf0 <syscall>
  801ec3:	83 c4 18             	add    $0x18,%esp
}
  801ec6:	90                   	nop
  801ec7:	c9                   	leave  
  801ec8:	c3                   	ret    

00801ec9 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801ec9:	55                   	push   %ebp
  801eca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 13                	push   $0x13
  801ed8:	e8 13 fe ff ff       	call   801cf0 <syscall>
  801edd:	83 c4 18             	add    $0x18,%esp
}
  801ee0:	90                   	nop
  801ee1:	c9                   	leave  
  801ee2:	c3                   	ret    

00801ee3 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801ee3:	55                   	push   %ebp
  801ee4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801ee6:	6a 00                	push   $0x0
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 00                	push   $0x0
  801eec:	6a 00                	push   $0x0
  801eee:	6a 00                	push   $0x0
  801ef0:	6a 14                	push   $0x14
  801ef2:	e8 f9 fd ff ff       	call   801cf0 <syscall>
  801ef7:	83 c4 18             	add    $0x18,%esp
}
  801efa:	90                   	nop
  801efb:	c9                   	leave  
  801efc:	c3                   	ret    

00801efd <sys_cputc>:


void
sys_cputc(const char c)
{
  801efd:	55                   	push   %ebp
  801efe:	89 e5                	mov    %esp,%ebp
  801f00:	83 ec 04             	sub    $0x4,%esp
  801f03:	8b 45 08             	mov    0x8(%ebp),%eax
  801f06:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801f09:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f0d:	6a 00                	push   $0x0
  801f0f:	6a 00                	push   $0x0
  801f11:	6a 00                	push   $0x0
  801f13:	6a 00                	push   $0x0
  801f15:	50                   	push   %eax
  801f16:	6a 15                	push   $0x15
  801f18:	e8 d3 fd ff ff       	call   801cf0 <syscall>
  801f1d:	83 c4 18             	add    $0x18,%esp
}
  801f20:	90                   	nop
  801f21:	c9                   	leave  
  801f22:	c3                   	ret    

00801f23 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801f23:	55                   	push   %ebp
  801f24:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801f26:	6a 00                	push   $0x0
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 00                	push   $0x0
  801f2c:	6a 00                	push   $0x0
  801f2e:	6a 00                	push   $0x0
  801f30:	6a 16                	push   $0x16
  801f32:	e8 b9 fd ff ff       	call   801cf0 <syscall>
  801f37:	83 c4 18             	add    $0x18,%esp
}
  801f3a:	90                   	nop
  801f3b:	c9                   	leave  
  801f3c:	c3                   	ret    

00801f3d <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801f3d:	55                   	push   %ebp
  801f3e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801f40:	8b 45 08             	mov    0x8(%ebp),%eax
  801f43:	6a 00                	push   $0x0
  801f45:	6a 00                	push   $0x0
  801f47:	6a 00                	push   $0x0
  801f49:	ff 75 0c             	pushl  0xc(%ebp)
  801f4c:	50                   	push   %eax
  801f4d:	6a 17                	push   $0x17
  801f4f:	e8 9c fd ff ff       	call   801cf0 <syscall>
  801f54:	83 c4 18             	add    $0x18,%esp
}
  801f57:	c9                   	leave  
  801f58:	c3                   	ret    

00801f59 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801f59:	55                   	push   %ebp
  801f5a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f62:	6a 00                	push   $0x0
  801f64:	6a 00                	push   $0x0
  801f66:	6a 00                	push   $0x0
  801f68:	52                   	push   %edx
  801f69:	50                   	push   %eax
  801f6a:	6a 1a                	push   $0x1a
  801f6c:	e8 7f fd ff ff       	call   801cf0 <syscall>
  801f71:	83 c4 18             	add    $0x18,%esp
}
  801f74:	c9                   	leave  
  801f75:	c3                   	ret    

00801f76 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f76:	55                   	push   %ebp
  801f77:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f79:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7f:	6a 00                	push   $0x0
  801f81:	6a 00                	push   $0x0
  801f83:	6a 00                	push   $0x0
  801f85:	52                   	push   %edx
  801f86:	50                   	push   %eax
  801f87:	6a 18                	push   $0x18
  801f89:	e8 62 fd ff ff       	call   801cf0 <syscall>
  801f8e:	83 c4 18             	add    $0x18,%esp
}
  801f91:	90                   	nop
  801f92:	c9                   	leave  
  801f93:	c3                   	ret    

00801f94 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f94:	55                   	push   %ebp
  801f95:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f97:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9d:	6a 00                	push   $0x0
  801f9f:	6a 00                	push   $0x0
  801fa1:	6a 00                	push   $0x0
  801fa3:	52                   	push   %edx
  801fa4:	50                   	push   %eax
  801fa5:	6a 19                	push   $0x19
  801fa7:	e8 44 fd ff ff       	call   801cf0 <syscall>
  801fac:	83 c4 18             	add    $0x18,%esp
}
  801faf:	90                   	nop
  801fb0:	c9                   	leave  
  801fb1:	c3                   	ret    

00801fb2 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801fb2:	55                   	push   %ebp
  801fb3:	89 e5                	mov    %esp,%ebp
  801fb5:	83 ec 04             	sub    $0x4,%esp
  801fb8:	8b 45 10             	mov    0x10(%ebp),%eax
  801fbb:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801fbe:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801fc1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc8:	6a 00                	push   $0x0
  801fca:	51                   	push   %ecx
  801fcb:	52                   	push   %edx
  801fcc:	ff 75 0c             	pushl  0xc(%ebp)
  801fcf:	50                   	push   %eax
  801fd0:	6a 1b                	push   $0x1b
  801fd2:	e8 19 fd ff ff       	call   801cf0 <syscall>
  801fd7:	83 c4 18             	add    $0x18,%esp
}
  801fda:	c9                   	leave  
  801fdb:	c3                   	ret    

00801fdc <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801fdc:	55                   	push   %ebp
  801fdd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801fdf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe5:	6a 00                	push   $0x0
  801fe7:	6a 00                	push   $0x0
  801fe9:	6a 00                	push   $0x0
  801feb:	52                   	push   %edx
  801fec:	50                   	push   %eax
  801fed:	6a 1c                	push   $0x1c
  801fef:	e8 fc fc ff ff       	call   801cf0 <syscall>
  801ff4:	83 c4 18             	add    $0x18,%esp
}
  801ff7:	c9                   	leave  
  801ff8:	c3                   	ret    

00801ff9 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801ff9:	55                   	push   %ebp
  801ffa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ffc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fff:	8b 55 0c             	mov    0xc(%ebp),%edx
  802002:	8b 45 08             	mov    0x8(%ebp),%eax
  802005:	6a 00                	push   $0x0
  802007:	6a 00                	push   $0x0
  802009:	51                   	push   %ecx
  80200a:	52                   	push   %edx
  80200b:	50                   	push   %eax
  80200c:	6a 1d                	push   $0x1d
  80200e:	e8 dd fc ff ff       	call   801cf0 <syscall>
  802013:	83 c4 18             	add    $0x18,%esp
}
  802016:	c9                   	leave  
  802017:	c3                   	ret    

00802018 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802018:	55                   	push   %ebp
  802019:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80201b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80201e:	8b 45 08             	mov    0x8(%ebp),%eax
  802021:	6a 00                	push   $0x0
  802023:	6a 00                	push   $0x0
  802025:	6a 00                	push   $0x0
  802027:	52                   	push   %edx
  802028:	50                   	push   %eax
  802029:	6a 1e                	push   $0x1e
  80202b:	e8 c0 fc ff ff       	call   801cf0 <syscall>
  802030:	83 c4 18             	add    $0x18,%esp
}
  802033:	c9                   	leave  
  802034:	c3                   	ret    

00802035 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802035:	55                   	push   %ebp
  802036:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802038:	6a 00                	push   $0x0
  80203a:	6a 00                	push   $0x0
  80203c:	6a 00                	push   $0x0
  80203e:	6a 00                	push   $0x0
  802040:	6a 00                	push   $0x0
  802042:	6a 1f                	push   $0x1f
  802044:	e8 a7 fc ff ff       	call   801cf0 <syscall>
  802049:	83 c4 18             	add    $0x18,%esp
}
  80204c:	c9                   	leave  
  80204d:	c3                   	ret    

0080204e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80204e:	55                   	push   %ebp
  80204f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802051:	8b 45 08             	mov    0x8(%ebp),%eax
  802054:	6a 00                	push   $0x0
  802056:	ff 75 14             	pushl  0x14(%ebp)
  802059:	ff 75 10             	pushl  0x10(%ebp)
  80205c:	ff 75 0c             	pushl  0xc(%ebp)
  80205f:	50                   	push   %eax
  802060:	6a 20                	push   $0x20
  802062:	e8 89 fc ff ff       	call   801cf0 <syscall>
  802067:	83 c4 18             	add    $0x18,%esp
}
  80206a:	c9                   	leave  
  80206b:	c3                   	ret    

0080206c <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80206c:	55                   	push   %ebp
  80206d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80206f:	8b 45 08             	mov    0x8(%ebp),%eax
  802072:	6a 00                	push   $0x0
  802074:	6a 00                	push   $0x0
  802076:	6a 00                	push   $0x0
  802078:	6a 00                	push   $0x0
  80207a:	50                   	push   %eax
  80207b:	6a 21                	push   $0x21
  80207d:	e8 6e fc ff ff       	call   801cf0 <syscall>
  802082:	83 c4 18             	add    $0x18,%esp
}
  802085:	90                   	nop
  802086:	c9                   	leave  
  802087:	c3                   	ret    

00802088 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802088:	55                   	push   %ebp
  802089:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80208b:	8b 45 08             	mov    0x8(%ebp),%eax
  80208e:	6a 00                	push   $0x0
  802090:	6a 00                	push   $0x0
  802092:	6a 00                	push   $0x0
  802094:	6a 00                	push   $0x0
  802096:	50                   	push   %eax
  802097:	6a 22                	push   $0x22
  802099:	e8 52 fc ff ff       	call   801cf0 <syscall>
  80209e:	83 c4 18             	add    $0x18,%esp
}
  8020a1:	c9                   	leave  
  8020a2:	c3                   	ret    

008020a3 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8020a3:	55                   	push   %ebp
  8020a4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8020a6:	6a 00                	push   $0x0
  8020a8:	6a 00                	push   $0x0
  8020aa:	6a 00                	push   $0x0
  8020ac:	6a 00                	push   $0x0
  8020ae:	6a 00                	push   $0x0
  8020b0:	6a 02                	push   $0x2
  8020b2:	e8 39 fc ff ff       	call   801cf0 <syscall>
  8020b7:	83 c4 18             	add    $0x18,%esp
}
  8020ba:	c9                   	leave  
  8020bb:	c3                   	ret    

008020bc <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8020bc:	55                   	push   %ebp
  8020bd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8020bf:	6a 00                	push   $0x0
  8020c1:	6a 00                	push   $0x0
  8020c3:	6a 00                	push   $0x0
  8020c5:	6a 00                	push   $0x0
  8020c7:	6a 00                	push   $0x0
  8020c9:	6a 03                	push   $0x3
  8020cb:	e8 20 fc ff ff       	call   801cf0 <syscall>
  8020d0:	83 c4 18             	add    $0x18,%esp
}
  8020d3:	c9                   	leave  
  8020d4:	c3                   	ret    

008020d5 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8020d5:	55                   	push   %ebp
  8020d6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8020d8:	6a 00                	push   $0x0
  8020da:	6a 00                	push   $0x0
  8020dc:	6a 00                	push   $0x0
  8020de:	6a 00                	push   $0x0
  8020e0:	6a 00                	push   $0x0
  8020e2:	6a 04                	push   $0x4
  8020e4:	e8 07 fc ff ff       	call   801cf0 <syscall>
  8020e9:	83 c4 18             	add    $0x18,%esp
}
  8020ec:	c9                   	leave  
  8020ed:	c3                   	ret    

008020ee <sys_exit_env>:


void sys_exit_env(void)
{
  8020ee:	55                   	push   %ebp
  8020ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8020f1:	6a 00                	push   $0x0
  8020f3:	6a 00                	push   $0x0
  8020f5:	6a 00                	push   $0x0
  8020f7:	6a 00                	push   $0x0
  8020f9:	6a 00                	push   $0x0
  8020fb:	6a 23                	push   $0x23
  8020fd:	e8 ee fb ff ff       	call   801cf0 <syscall>
  802102:	83 c4 18             	add    $0x18,%esp
}
  802105:	90                   	nop
  802106:	c9                   	leave  
  802107:	c3                   	ret    

00802108 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802108:	55                   	push   %ebp
  802109:	89 e5                	mov    %esp,%ebp
  80210b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80210e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802111:	8d 50 04             	lea    0x4(%eax),%edx
  802114:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802117:	6a 00                	push   $0x0
  802119:	6a 00                	push   $0x0
  80211b:	6a 00                	push   $0x0
  80211d:	52                   	push   %edx
  80211e:	50                   	push   %eax
  80211f:	6a 24                	push   $0x24
  802121:	e8 ca fb ff ff       	call   801cf0 <syscall>
  802126:	83 c4 18             	add    $0x18,%esp
	return result;
  802129:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80212c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80212f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802132:	89 01                	mov    %eax,(%ecx)
  802134:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802137:	8b 45 08             	mov    0x8(%ebp),%eax
  80213a:	c9                   	leave  
  80213b:	c2 04 00             	ret    $0x4

0080213e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80213e:	55                   	push   %ebp
  80213f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802141:	6a 00                	push   $0x0
  802143:	6a 00                	push   $0x0
  802145:	ff 75 10             	pushl  0x10(%ebp)
  802148:	ff 75 0c             	pushl  0xc(%ebp)
  80214b:	ff 75 08             	pushl  0x8(%ebp)
  80214e:	6a 12                	push   $0x12
  802150:	e8 9b fb ff ff       	call   801cf0 <syscall>
  802155:	83 c4 18             	add    $0x18,%esp
	return ;
  802158:	90                   	nop
}
  802159:	c9                   	leave  
  80215a:	c3                   	ret    

0080215b <sys_rcr2>:
uint32 sys_rcr2()
{
  80215b:	55                   	push   %ebp
  80215c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80215e:	6a 00                	push   $0x0
  802160:	6a 00                	push   $0x0
  802162:	6a 00                	push   $0x0
  802164:	6a 00                	push   $0x0
  802166:	6a 00                	push   $0x0
  802168:	6a 25                	push   $0x25
  80216a:	e8 81 fb ff ff       	call   801cf0 <syscall>
  80216f:	83 c4 18             	add    $0x18,%esp
}
  802172:	c9                   	leave  
  802173:	c3                   	ret    

00802174 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802174:	55                   	push   %ebp
  802175:	89 e5                	mov    %esp,%ebp
  802177:	83 ec 04             	sub    $0x4,%esp
  80217a:	8b 45 08             	mov    0x8(%ebp),%eax
  80217d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802180:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802184:	6a 00                	push   $0x0
  802186:	6a 00                	push   $0x0
  802188:	6a 00                	push   $0x0
  80218a:	6a 00                	push   $0x0
  80218c:	50                   	push   %eax
  80218d:	6a 26                	push   $0x26
  80218f:	e8 5c fb ff ff       	call   801cf0 <syscall>
  802194:	83 c4 18             	add    $0x18,%esp
	return ;
  802197:	90                   	nop
}
  802198:	c9                   	leave  
  802199:	c3                   	ret    

0080219a <rsttst>:
void rsttst()
{
  80219a:	55                   	push   %ebp
  80219b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80219d:	6a 00                	push   $0x0
  80219f:	6a 00                	push   $0x0
  8021a1:	6a 00                	push   $0x0
  8021a3:	6a 00                	push   $0x0
  8021a5:	6a 00                	push   $0x0
  8021a7:	6a 28                	push   $0x28
  8021a9:	e8 42 fb ff ff       	call   801cf0 <syscall>
  8021ae:	83 c4 18             	add    $0x18,%esp
	return ;
  8021b1:	90                   	nop
}
  8021b2:	c9                   	leave  
  8021b3:	c3                   	ret    

008021b4 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8021b4:	55                   	push   %ebp
  8021b5:	89 e5                	mov    %esp,%ebp
  8021b7:	83 ec 04             	sub    $0x4,%esp
  8021ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8021bd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8021c0:	8b 55 18             	mov    0x18(%ebp),%edx
  8021c3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8021c7:	52                   	push   %edx
  8021c8:	50                   	push   %eax
  8021c9:	ff 75 10             	pushl  0x10(%ebp)
  8021cc:	ff 75 0c             	pushl  0xc(%ebp)
  8021cf:	ff 75 08             	pushl  0x8(%ebp)
  8021d2:	6a 27                	push   $0x27
  8021d4:	e8 17 fb ff ff       	call   801cf0 <syscall>
  8021d9:	83 c4 18             	add    $0x18,%esp
	return ;
  8021dc:	90                   	nop
}
  8021dd:	c9                   	leave  
  8021de:	c3                   	ret    

008021df <chktst>:
void chktst(uint32 n)
{
  8021df:	55                   	push   %ebp
  8021e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8021e2:	6a 00                	push   $0x0
  8021e4:	6a 00                	push   $0x0
  8021e6:	6a 00                	push   $0x0
  8021e8:	6a 00                	push   $0x0
  8021ea:	ff 75 08             	pushl  0x8(%ebp)
  8021ed:	6a 29                	push   $0x29
  8021ef:	e8 fc fa ff ff       	call   801cf0 <syscall>
  8021f4:	83 c4 18             	add    $0x18,%esp
	return ;
  8021f7:	90                   	nop
}
  8021f8:	c9                   	leave  
  8021f9:	c3                   	ret    

008021fa <inctst>:

void inctst()
{
  8021fa:	55                   	push   %ebp
  8021fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 00                	push   $0x0
  802201:	6a 00                	push   $0x0
  802203:	6a 00                	push   $0x0
  802205:	6a 00                	push   $0x0
  802207:	6a 2a                	push   $0x2a
  802209:	e8 e2 fa ff ff       	call   801cf0 <syscall>
  80220e:	83 c4 18             	add    $0x18,%esp
	return ;
  802211:	90                   	nop
}
  802212:	c9                   	leave  
  802213:	c3                   	ret    

00802214 <gettst>:
uint32 gettst()
{
  802214:	55                   	push   %ebp
  802215:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802217:	6a 00                	push   $0x0
  802219:	6a 00                	push   $0x0
  80221b:	6a 00                	push   $0x0
  80221d:	6a 00                	push   $0x0
  80221f:	6a 00                	push   $0x0
  802221:	6a 2b                	push   $0x2b
  802223:	e8 c8 fa ff ff       	call   801cf0 <syscall>
  802228:	83 c4 18             	add    $0x18,%esp
}
  80222b:	c9                   	leave  
  80222c:	c3                   	ret    

0080222d <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80222d:	55                   	push   %ebp
  80222e:	89 e5                	mov    %esp,%ebp
  802230:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802233:	6a 00                	push   $0x0
  802235:	6a 00                	push   $0x0
  802237:	6a 00                	push   $0x0
  802239:	6a 00                	push   $0x0
  80223b:	6a 00                	push   $0x0
  80223d:	6a 2c                	push   $0x2c
  80223f:	e8 ac fa ff ff       	call   801cf0 <syscall>
  802244:	83 c4 18             	add    $0x18,%esp
  802247:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80224a:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80224e:	75 07                	jne    802257 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802250:	b8 01 00 00 00       	mov    $0x1,%eax
  802255:	eb 05                	jmp    80225c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802257:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80225c:	c9                   	leave  
  80225d:	c3                   	ret    

0080225e <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80225e:	55                   	push   %ebp
  80225f:	89 e5                	mov    %esp,%ebp
  802261:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802264:	6a 00                	push   $0x0
  802266:	6a 00                	push   $0x0
  802268:	6a 00                	push   $0x0
  80226a:	6a 00                	push   $0x0
  80226c:	6a 00                	push   $0x0
  80226e:	6a 2c                	push   $0x2c
  802270:	e8 7b fa ff ff       	call   801cf0 <syscall>
  802275:	83 c4 18             	add    $0x18,%esp
  802278:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80227b:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80227f:	75 07                	jne    802288 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802281:	b8 01 00 00 00       	mov    $0x1,%eax
  802286:	eb 05                	jmp    80228d <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802288:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80228d:	c9                   	leave  
  80228e:	c3                   	ret    

0080228f <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80228f:	55                   	push   %ebp
  802290:	89 e5                	mov    %esp,%ebp
  802292:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802295:	6a 00                	push   $0x0
  802297:	6a 00                	push   $0x0
  802299:	6a 00                	push   $0x0
  80229b:	6a 00                	push   $0x0
  80229d:	6a 00                	push   $0x0
  80229f:	6a 2c                	push   $0x2c
  8022a1:	e8 4a fa ff ff       	call   801cf0 <syscall>
  8022a6:	83 c4 18             	add    $0x18,%esp
  8022a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8022ac:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8022b0:	75 07                	jne    8022b9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8022b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8022b7:	eb 05                	jmp    8022be <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8022b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022be:	c9                   	leave  
  8022bf:	c3                   	ret    

008022c0 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8022c0:	55                   	push   %ebp
  8022c1:	89 e5                	mov    %esp,%ebp
  8022c3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022c6:	6a 00                	push   $0x0
  8022c8:	6a 00                	push   $0x0
  8022ca:	6a 00                	push   $0x0
  8022cc:	6a 00                	push   $0x0
  8022ce:	6a 00                	push   $0x0
  8022d0:	6a 2c                	push   $0x2c
  8022d2:	e8 19 fa ff ff       	call   801cf0 <syscall>
  8022d7:	83 c4 18             	add    $0x18,%esp
  8022da:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8022dd:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8022e1:	75 07                	jne    8022ea <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8022e3:	b8 01 00 00 00       	mov    $0x1,%eax
  8022e8:	eb 05                	jmp    8022ef <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8022ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022ef:	c9                   	leave  
  8022f0:	c3                   	ret    

008022f1 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8022f1:	55                   	push   %ebp
  8022f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8022f4:	6a 00                	push   $0x0
  8022f6:	6a 00                	push   $0x0
  8022f8:	6a 00                	push   $0x0
  8022fa:	6a 00                	push   $0x0
  8022fc:	ff 75 08             	pushl  0x8(%ebp)
  8022ff:	6a 2d                	push   $0x2d
  802301:	e8 ea f9 ff ff       	call   801cf0 <syscall>
  802306:	83 c4 18             	add    $0x18,%esp
	return ;
  802309:	90                   	nop
}
  80230a:	c9                   	leave  
  80230b:	c3                   	ret    

0080230c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80230c:	55                   	push   %ebp
  80230d:	89 e5                	mov    %esp,%ebp
  80230f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802310:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802313:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802316:	8b 55 0c             	mov    0xc(%ebp),%edx
  802319:	8b 45 08             	mov    0x8(%ebp),%eax
  80231c:	6a 00                	push   $0x0
  80231e:	53                   	push   %ebx
  80231f:	51                   	push   %ecx
  802320:	52                   	push   %edx
  802321:	50                   	push   %eax
  802322:	6a 2e                	push   $0x2e
  802324:	e8 c7 f9 ff ff       	call   801cf0 <syscall>
  802329:	83 c4 18             	add    $0x18,%esp
}
  80232c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80232f:	c9                   	leave  
  802330:	c3                   	ret    

00802331 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802331:	55                   	push   %ebp
  802332:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802334:	8b 55 0c             	mov    0xc(%ebp),%edx
  802337:	8b 45 08             	mov    0x8(%ebp),%eax
  80233a:	6a 00                	push   $0x0
  80233c:	6a 00                	push   $0x0
  80233e:	6a 00                	push   $0x0
  802340:	52                   	push   %edx
  802341:	50                   	push   %eax
  802342:	6a 2f                	push   $0x2f
  802344:	e8 a7 f9 ff ff       	call   801cf0 <syscall>
  802349:	83 c4 18             	add    $0x18,%esp
}
  80234c:	c9                   	leave  
  80234d:	c3                   	ret    

0080234e <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80234e:	55                   	push   %ebp
  80234f:	89 e5                	mov    %esp,%ebp
  802351:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802354:	83 ec 0c             	sub    $0xc,%esp
  802357:	68 e4 44 80 00       	push   $0x8044e4
  80235c:	e8 46 e8 ff ff       	call   800ba7 <cprintf>
  802361:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802364:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80236b:	83 ec 0c             	sub    $0xc,%esp
  80236e:	68 10 45 80 00       	push   $0x804510
  802373:	e8 2f e8 ff ff       	call   800ba7 <cprintf>
  802378:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80237b:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80237f:	a1 38 51 80 00       	mov    0x805138,%eax
  802384:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802387:	eb 56                	jmp    8023df <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802389:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80238d:	74 1c                	je     8023ab <print_mem_block_lists+0x5d>
  80238f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802392:	8b 50 08             	mov    0x8(%eax),%edx
  802395:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802398:	8b 48 08             	mov    0x8(%eax),%ecx
  80239b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80239e:	8b 40 0c             	mov    0xc(%eax),%eax
  8023a1:	01 c8                	add    %ecx,%eax
  8023a3:	39 c2                	cmp    %eax,%edx
  8023a5:	73 04                	jae    8023ab <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8023a7:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8023ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ae:	8b 50 08             	mov    0x8(%eax),%edx
  8023b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8023b7:	01 c2                	add    %eax,%edx
  8023b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bc:	8b 40 08             	mov    0x8(%eax),%eax
  8023bf:	83 ec 04             	sub    $0x4,%esp
  8023c2:	52                   	push   %edx
  8023c3:	50                   	push   %eax
  8023c4:	68 25 45 80 00       	push   $0x804525
  8023c9:	e8 d9 e7 ff ff       	call   800ba7 <cprintf>
  8023ce:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8023d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8023d7:	a1 40 51 80 00       	mov    0x805140,%eax
  8023dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023e3:	74 07                	je     8023ec <print_mem_block_lists+0x9e>
  8023e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e8:	8b 00                	mov    (%eax),%eax
  8023ea:	eb 05                	jmp    8023f1 <print_mem_block_lists+0xa3>
  8023ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8023f1:	a3 40 51 80 00       	mov    %eax,0x805140
  8023f6:	a1 40 51 80 00       	mov    0x805140,%eax
  8023fb:	85 c0                	test   %eax,%eax
  8023fd:	75 8a                	jne    802389 <print_mem_block_lists+0x3b>
  8023ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802403:	75 84                	jne    802389 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802405:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802409:	75 10                	jne    80241b <print_mem_block_lists+0xcd>
  80240b:	83 ec 0c             	sub    $0xc,%esp
  80240e:	68 34 45 80 00       	push   $0x804534
  802413:	e8 8f e7 ff ff       	call   800ba7 <cprintf>
  802418:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80241b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802422:	83 ec 0c             	sub    $0xc,%esp
  802425:	68 58 45 80 00       	push   $0x804558
  80242a:	e8 78 e7 ff ff       	call   800ba7 <cprintf>
  80242f:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802432:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802436:	a1 40 50 80 00       	mov    0x805040,%eax
  80243b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80243e:	eb 56                	jmp    802496 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802440:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802444:	74 1c                	je     802462 <print_mem_block_lists+0x114>
  802446:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802449:	8b 50 08             	mov    0x8(%eax),%edx
  80244c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80244f:	8b 48 08             	mov    0x8(%eax),%ecx
  802452:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802455:	8b 40 0c             	mov    0xc(%eax),%eax
  802458:	01 c8                	add    %ecx,%eax
  80245a:	39 c2                	cmp    %eax,%edx
  80245c:	73 04                	jae    802462 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80245e:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802462:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802465:	8b 50 08             	mov    0x8(%eax),%edx
  802468:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246b:	8b 40 0c             	mov    0xc(%eax),%eax
  80246e:	01 c2                	add    %eax,%edx
  802470:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802473:	8b 40 08             	mov    0x8(%eax),%eax
  802476:	83 ec 04             	sub    $0x4,%esp
  802479:	52                   	push   %edx
  80247a:	50                   	push   %eax
  80247b:	68 25 45 80 00       	push   $0x804525
  802480:	e8 22 e7 ff ff       	call   800ba7 <cprintf>
  802485:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802488:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80248e:	a1 48 50 80 00       	mov    0x805048,%eax
  802493:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802496:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80249a:	74 07                	je     8024a3 <print_mem_block_lists+0x155>
  80249c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249f:	8b 00                	mov    (%eax),%eax
  8024a1:	eb 05                	jmp    8024a8 <print_mem_block_lists+0x15a>
  8024a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a8:	a3 48 50 80 00       	mov    %eax,0x805048
  8024ad:	a1 48 50 80 00       	mov    0x805048,%eax
  8024b2:	85 c0                	test   %eax,%eax
  8024b4:	75 8a                	jne    802440 <print_mem_block_lists+0xf2>
  8024b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024ba:	75 84                	jne    802440 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8024bc:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8024c0:	75 10                	jne    8024d2 <print_mem_block_lists+0x184>
  8024c2:	83 ec 0c             	sub    $0xc,%esp
  8024c5:	68 70 45 80 00       	push   $0x804570
  8024ca:	e8 d8 e6 ff ff       	call   800ba7 <cprintf>
  8024cf:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8024d2:	83 ec 0c             	sub    $0xc,%esp
  8024d5:	68 e4 44 80 00       	push   $0x8044e4
  8024da:	e8 c8 e6 ff ff       	call   800ba7 <cprintf>
  8024df:	83 c4 10             	add    $0x10,%esp

}
  8024e2:	90                   	nop
  8024e3:	c9                   	leave  
  8024e4:	c3                   	ret    

008024e5 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8024e5:	55                   	push   %ebp
  8024e6:	89 e5                	mov    %esp,%ebp
  8024e8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8024eb:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8024f2:	00 00 00 
  8024f5:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8024fc:	00 00 00 
  8024ff:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802506:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802509:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802510:	e9 9e 00 00 00       	jmp    8025b3 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802515:	a1 50 50 80 00       	mov    0x805050,%eax
  80251a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80251d:	c1 e2 04             	shl    $0x4,%edx
  802520:	01 d0                	add    %edx,%eax
  802522:	85 c0                	test   %eax,%eax
  802524:	75 14                	jne    80253a <initialize_MemBlocksList+0x55>
  802526:	83 ec 04             	sub    $0x4,%esp
  802529:	68 98 45 80 00       	push   $0x804598
  80252e:	6a 46                	push   $0x46
  802530:	68 bb 45 80 00       	push   $0x8045bb
  802535:	e8 b9 e3 ff ff       	call   8008f3 <_panic>
  80253a:	a1 50 50 80 00       	mov    0x805050,%eax
  80253f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802542:	c1 e2 04             	shl    $0x4,%edx
  802545:	01 d0                	add    %edx,%eax
  802547:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80254d:	89 10                	mov    %edx,(%eax)
  80254f:	8b 00                	mov    (%eax),%eax
  802551:	85 c0                	test   %eax,%eax
  802553:	74 18                	je     80256d <initialize_MemBlocksList+0x88>
  802555:	a1 48 51 80 00       	mov    0x805148,%eax
  80255a:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802560:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802563:	c1 e1 04             	shl    $0x4,%ecx
  802566:	01 ca                	add    %ecx,%edx
  802568:	89 50 04             	mov    %edx,0x4(%eax)
  80256b:	eb 12                	jmp    80257f <initialize_MemBlocksList+0x9a>
  80256d:	a1 50 50 80 00       	mov    0x805050,%eax
  802572:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802575:	c1 e2 04             	shl    $0x4,%edx
  802578:	01 d0                	add    %edx,%eax
  80257a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80257f:	a1 50 50 80 00       	mov    0x805050,%eax
  802584:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802587:	c1 e2 04             	shl    $0x4,%edx
  80258a:	01 d0                	add    %edx,%eax
  80258c:	a3 48 51 80 00       	mov    %eax,0x805148
  802591:	a1 50 50 80 00       	mov    0x805050,%eax
  802596:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802599:	c1 e2 04             	shl    $0x4,%edx
  80259c:	01 d0                	add    %edx,%eax
  80259e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025a5:	a1 54 51 80 00       	mov    0x805154,%eax
  8025aa:	40                   	inc    %eax
  8025ab:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8025b0:	ff 45 f4             	incl   -0xc(%ebp)
  8025b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025b9:	0f 82 56 ff ff ff    	jb     802515 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8025bf:	90                   	nop
  8025c0:	c9                   	leave  
  8025c1:	c3                   	ret    

008025c2 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8025c2:	55                   	push   %ebp
  8025c3:	89 e5                	mov    %esp,%ebp
  8025c5:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8025c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025cb:	8b 00                	mov    (%eax),%eax
  8025cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8025d0:	eb 19                	jmp    8025eb <find_block+0x29>
	{
		if(va==point->sva)
  8025d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025d5:	8b 40 08             	mov    0x8(%eax),%eax
  8025d8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8025db:	75 05                	jne    8025e2 <find_block+0x20>
		   return point;
  8025dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025e0:	eb 36                	jmp    802618 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8025e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e5:	8b 40 08             	mov    0x8(%eax),%eax
  8025e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8025eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8025ef:	74 07                	je     8025f8 <find_block+0x36>
  8025f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025f4:	8b 00                	mov    (%eax),%eax
  8025f6:	eb 05                	jmp    8025fd <find_block+0x3b>
  8025f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8025fd:	8b 55 08             	mov    0x8(%ebp),%edx
  802600:	89 42 08             	mov    %eax,0x8(%edx)
  802603:	8b 45 08             	mov    0x8(%ebp),%eax
  802606:	8b 40 08             	mov    0x8(%eax),%eax
  802609:	85 c0                	test   %eax,%eax
  80260b:	75 c5                	jne    8025d2 <find_block+0x10>
  80260d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802611:	75 bf                	jne    8025d2 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802613:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802618:	c9                   	leave  
  802619:	c3                   	ret    

0080261a <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80261a:	55                   	push   %ebp
  80261b:	89 e5                	mov    %esp,%ebp
  80261d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802620:	a1 40 50 80 00       	mov    0x805040,%eax
  802625:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802628:	a1 44 50 80 00       	mov    0x805044,%eax
  80262d:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802630:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802633:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802636:	74 24                	je     80265c <insert_sorted_allocList+0x42>
  802638:	8b 45 08             	mov    0x8(%ebp),%eax
  80263b:	8b 50 08             	mov    0x8(%eax),%edx
  80263e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802641:	8b 40 08             	mov    0x8(%eax),%eax
  802644:	39 c2                	cmp    %eax,%edx
  802646:	76 14                	jbe    80265c <insert_sorted_allocList+0x42>
  802648:	8b 45 08             	mov    0x8(%ebp),%eax
  80264b:	8b 50 08             	mov    0x8(%eax),%edx
  80264e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802651:	8b 40 08             	mov    0x8(%eax),%eax
  802654:	39 c2                	cmp    %eax,%edx
  802656:	0f 82 60 01 00 00    	jb     8027bc <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  80265c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802660:	75 65                	jne    8026c7 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802662:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802666:	75 14                	jne    80267c <insert_sorted_allocList+0x62>
  802668:	83 ec 04             	sub    $0x4,%esp
  80266b:	68 98 45 80 00       	push   $0x804598
  802670:	6a 6b                	push   $0x6b
  802672:	68 bb 45 80 00       	push   $0x8045bb
  802677:	e8 77 e2 ff ff       	call   8008f3 <_panic>
  80267c:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802682:	8b 45 08             	mov    0x8(%ebp),%eax
  802685:	89 10                	mov    %edx,(%eax)
  802687:	8b 45 08             	mov    0x8(%ebp),%eax
  80268a:	8b 00                	mov    (%eax),%eax
  80268c:	85 c0                	test   %eax,%eax
  80268e:	74 0d                	je     80269d <insert_sorted_allocList+0x83>
  802690:	a1 40 50 80 00       	mov    0x805040,%eax
  802695:	8b 55 08             	mov    0x8(%ebp),%edx
  802698:	89 50 04             	mov    %edx,0x4(%eax)
  80269b:	eb 08                	jmp    8026a5 <insert_sorted_allocList+0x8b>
  80269d:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a0:	a3 44 50 80 00       	mov    %eax,0x805044
  8026a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a8:	a3 40 50 80 00       	mov    %eax,0x805040
  8026ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026b7:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8026bc:	40                   	inc    %eax
  8026bd:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8026c2:	e9 dc 01 00 00       	jmp    8028a3 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8026c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ca:	8b 50 08             	mov    0x8(%eax),%edx
  8026cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026d0:	8b 40 08             	mov    0x8(%eax),%eax
  8026d3:	39 c2                	cmp    %eax,%edx
  8026d5:	77 6c                	ja     802743 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8026d7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026db:	74 06                	je     8026e3 <insert_sorted_allocList+0xc9>
  8026dd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026e1:	75 14                	jne    8026f7 <insert_sorted_allocList+0xdd>
  8026e3:	83 ec 04             	sub    $0x4,%esp
  8026e6:	68 d4 45 80 00       	push   $0x8045d4
  8026eb:	6a 6f                	push   $0x6f
  8026ed:	68 bb 45 80 00       	push   $0x8045bb
  8026f2:	e8 fc e1 ff ff       	call   8008f3 <_panic>
  8026f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026fa:	8b 50 04             	mov    0x4(%eax),%edx
  8026fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802700:	89 50 04             	mov    %edx,0x4(%eax)
  802703:	8b 45 08             	mov    0x8(%ebp),%eax
  802706:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802709:	89 10                	mov    %edx,(%eax)
  80270b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80270e:	8b 40 04             	mov    0x4(%eax),%eax
  802711:	85 c0                	test   %eax,%eax
  802713:	74 0d                	je     802722 <insert_sorted_allocList+0x108>
  802715:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802718:	8b 40 04             	mov    0x4(%eax),%eax
  80271b:	8b 55 08             	mov    0x8(%ebp),%edx
  80271e:	89 10                	mov    %edx,(%eax)
  802720:	eb 08                	jmp    80272a <insert_sorted_allocList+0x110>
  802722:	8b 45 08             	mov    0x8(%ebp),%eax
  802725:	a3 40 50 80 00       	mov    %eax,0x805040
  80272a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80272d:	8b 55 08             	mov    0x8(%ebp),%edx
  802730:	89 50 04             	mov    %edx,0x4(%eax)
  802733:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802738:	40                   	inc    %eax
  802739:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80273e:	e9 60 01 00 00       	jmp    8028a3 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802743:	8b 45 08             	mov    0x8(%ebp),%eax
  802746:	8b 50 08             	mov    0x8(%eax),%edx
  802749:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80274c:	8b 40 08             	mov    0x8(%eax),%eax
  80274f:	39 c2                	cmp    %eax,%edx
  802751:	0f 82 4c 01 00 00    	jb     8028a3 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802757:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80275b:	75 14                	jne    802771 <insert_sorted_allocList+0x157>
  80275d:	83 ec 04             	sub    $0x4,%esp
  802760:	68 0c 46 80 00       	push   $0x80460c
  802765:	6a 73                	push   $0x73
  802767:	68 bb 45 80 00       	push   $0x8045bb
  80276c:	e8 82 e1 ff ff       	call   8008f3 <_panic>
  802771:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802777:	8b 45 08             	mov    0x8(%ebp),%eax
  80277a:	89 50 04             	mov    %edx,0x4(%eax)
  80277d:	8b 45 08             	mov    0x8(%ebp),%eax
  802780:	8b 40 04             	mov    0x4(%eax),%eax
  802783:	85 c0                	test   %eax,%eax
  802785:	74 0c                	je     802793 <insert_sorted_allocList+0x179>
  802787:	a1 44 50 80 00       	mov    0x805044,%eax
  80278c:	8b 55 08             	mov    0x8(%ebp),%edx
  80278f:	89 10                	mov    %edx,(%eax)
  802791:	eb 08                	jmp    80279b <insert_sorted_allocList+0x181>
  802793:	8b 45 08             	mov    0x8(%ebp),%eax
  802796:	a3 40 50 80 00       	mov    %eax,0x805040
  80279b:	8b 45 08             	mov    0x8(%ebp),%eax
  80279e:	a3 44 50 80 00       	mov    %eax,0x805044
  8027a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027ac:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8027b1:	40                   	inc    %eax
  8027b2:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8027b7:	e9 e7 00 00 00       	jmp    8028a3 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8027bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8027c2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8027c9:	a1 40 50 80 00       	mov    0x805040,%eax
  8027ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027d1:	e9 9d 00 00 00       	jmp    802873 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8027d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d9:	8b 00                	mov    (%eax),%eax
  8027db:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8027de:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e1:	8b 50 08             	mov    0x8(%eax),%edx
  8027e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e7:	8b 40 08             	mov    0x8(%eax),%eax
  8027ea:	39 c2                	cmp    %eax,%edx
  8027ec:	76 7d                	jbe    80286b <insert_sorted_allocList+0x251>
  8027ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f1:	8b 50 08             	mov    0x8(%eax),%edx
  8027f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027f7:	8b 40 08             	mov    0x8(%eax),%eax
  8027fa:	39 c2                	cmp    %eax,%edx
  8027fc:	73 6d                	jae    80286b <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8027fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802802:	74 06                	je     80280a <insert_sorted_allocList+0x1f0>
  802804:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802808:	75 14                	jne    80281e <insert_sorted_allocList+0x204>
  80280a:	83 ec 04             	sub    $0x4,%esp
  80280d:	68 30 46 80 00       	push   $0x804630
  802812:	6a 7f                	push   $0x7f
  802814:	68 bb 45 80 00       	push   $0x8045bb
  802819:	e8 d5 e0 ff ff       	call   8008f3 <_panic>
  80281e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802821:	8b 10                	mov    (%eax),%edx
  802823:	8b 45 08             	mov    0x8(%ebp),%eax
  802826:	89 10                	mov    %edx,(%eax)
  802828:	8b 45 08             	mov    0x8(%ebp),%eax
  80282b:	8b 00                	mov    (%eax),%eax
  80282d:	85 c0                	test   %eax,%eax
  80282f:	74 0b                	je     80283c <insert_sorted_allocList+0x222>
  802831:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802834:	8b 00                	mov    (%eax),%eax
  802836:	8b 55 08             	mov    0x8(%ebp),%edx
  802839:	89 50 04             	mov    %edx,0x4(%eax)
  80283c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283f:	8b 55 08             	mov    0x8(%ebp),%edx
  802842:	89 10                	mov    %edx,(%eax)
  802844:	8b 45 08             	mov    0x8(%ebp),%eax
  802847:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80284a:	89 50 04             	mov    %edx,0x4(%eax)
  80284d:	8b 45 08             	mov    0x8(%ebp),%eax
  802850:	8b 00                	mov    (%eax),%eax
  802852:	85 c0                	test   %eax,%eax
  802854:	75 08                	jne    80285e <insert_sorted_allocList+0x244>
  802856:	8b 45 08             	mov    0x8(%ebp),%eax
  802859:	a3 44 50 80 00       	mov    %eax,0x805044
  80285e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802863:	40                   	inc    %eax
  802864:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802869:	eb 39                	jmp    8028a4 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80286b:	a1 48 50 80 00       	mov    0x805048,%eax
  802870:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802873:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802877:	74 07                	je     802880 <insert_sorted_allocList+0x266>
  802879:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287c:	8b 00                	mov    (%eax),%eax
  80287e:	eb 05                	jmp    802885 <insert_sorted_allocList+0x26b>
  802880:	b8 00 00 00 00       	mov    $0x0,%eax
  802885:	a3 48 50 80 00       	mov    %eax,0x805048
  80288a:	a1 48 50 80 00       	mov    0x805048,%eax
  80288f:	85 c0                	test   %eax,%eax
  802891:	0f 85 3f ff ff ff    	jne    8027d6 <insert_sorted_allocList+0x1bc>
  802897:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80289b:	0f 85 35 ff ff ff    	jne    8027d6 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8028a1:	eb 01                	jmp    8028a4 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8028a3:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8028a4:	90                   	nop
  8028a5:	c9                   	leave  
  8028a6:	c3                   	ret    

008028a7 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8028a7:	55                   	push   %ebp
  8028a8:	89 e5                	mov    %esp,%ebp
  8028aa:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8028ad:	a1 38 51 80 00       	mov    0x805138,%eax
  8028b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028b5:	e9 85 01 00 00       	jmp    802a3f <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8028ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8028c0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028c3:	0f 82 6e 01 00 00    	jb     802a37 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8028c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8028cf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028d2:	0f 85 8a 00 00 00    	jne    802962 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8028d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028dc:	75 17                	jne    8028f5 <alloc_block_FF+0x4e>
  8028de:	83 ec 04             	sub    $0x4,%esp
  8028e1:	68 64 46 80 00       	push   $0x804664
  8028e6:	68 93 00 00 00       	push   $0x93
  8028eb:	68 bb 45 80 00       	push   $0x8045bb
  8028f0:	e8 fe df ff ff       	call   8008f3 <_panic>
  8028f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f8:	8b 00                	mov    (%eax),%eax
  8028fa:	85 c0                	test   %eax,%eax
  8028fc:	74 10                	je     80290e <alloc_block_FF+0x67>
  8028fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802901:	8b 00                	mov    (%eax),%eax
  802903:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802906:	8b 52 04             	mov    0x4(%edx),%edx
  802909:	89 50 04             	mov    %edx,0x4(%eax)
  80290c:	eb 0b                	jmp    802919 <alloc_block_FF+0x72>
  80290e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802911:	8b 40 04             	mov    0x4(%eax),%eax
  802914:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802919:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291c:	8b 40 04             	mov    0x4(%eax),%eax
  80291f:	85 c0                	test   %eax,%eax
  802921:	74 0f                	je     802932 <alloc_block_FF+0x8b>
  802923:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802926:	8b 40 04             	mov    0x4(%eax),%eax
  802929:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80292c:	8b 12                	mov    (%edx),%edx
  80292e:	89 10                	mov    %edx,(%eax)
  802930:	eb 0a                	jmp    80293c <alloc_block_FF+0x95>
  802932:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802935:	8b 00                	mov    (%eax),%eax
  802937:	a3 38 51 80 00       	mov    %eax,0x805138
  80293c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802945:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802948:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80294f:	a1 44 51 80 00       	mov    0x805144,%eax
  802954:	48                   	dec    %eax
  802955:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  80295a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295d:	e9 10 01 00 00       	jmp    802a72 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802962:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802965:	8b 40 0c             	mov    0xc(%eax),%eax
  802968:	3b 45 08             	cmp    0x8(%ebp),%eax
  80296b:	0f 86 c6 00 00 00    	jbe    802a37 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802971:	a1 48 51 80 00       	mov    0x805148,%eax
  802976:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802979:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297c:	8b 50 08             	mov    0x8(%eax),%edx
  80297f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802982:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802985:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802988:	8b 55 08             	mov    0x8(%ebp),%edx
  80298b:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80298e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802992:	75 17                	jne    8029ab <alloc_block_FF+0x104>
  802994:	83 ec 04             	sub    $0x4,%esp
  802997:	68 64 46 80 00       	push   $0x804664
  80299c:	68 9b 00 00 00       	push   $0x9b
  8029a1:	68 bb 45 80 00       	push   $0x8045bb
  8029a6:	e8 48 df ff ff       	call   8008f3 <_panic>
  8029ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ae:	8b 00                	mov    (%eax),%eax
  8029b0:	85 c0                	test   %eax,%eax
  8029b2:	74 10                	je     8029c4 <alloc_block_FF+0x11d>
  8029b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b7:	8b 00                	mov    (%eax),%eax
  8029b9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029bc:	8b 52 04             	mov    0x4(%edx),%edx
  8029bf:	89 50 04             	mov    %edx,0x4(%eax)
  8029c2:	eb 0b                	jmp    8029cf <alloc_block_FF+0x128>
  8029c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c7:	8b 40 04             	mov    0x4(%eax),%eax
  8029ca:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d2:	8b 40 04             	mov    0x4(%eax),%eax
  8029d5:	85 c0                	test   %eax,%eax
  8029d7:	74 0f                	je     8029e8 <alloc_block_FF+0x141>
  8029d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029dc:	8b 40 04             	mov    0x4(%eax),%eax
  8029df:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029e2:	8b 12                	mov    (%edx),%edx
  8029e4:	89 10                	mov    %edx,(%eax)
  8029e6:	eb 0a                	jmp    8029f2 <alloc_block_FF+0x14b>
  8029e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029eb:	8b 00                	mov    (%eax),%eax
  8029ed:	a3 48 51 80 00       	mov    %eax,0x805148
  8029f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029fe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a05:	a1 54 51 80 00       	mov    0x805154,%eax
  802a0a:	48                   	dec    %eax
  802a0b:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a13:	8b 50 08             	mov    0x8(%eax),%edx
  802a16:	8b 45 08             	mov    0x8(%ebp),%eax
  802a19:	01 c2                	add    %eax,%edx
  802a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1e:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a24:	8b 40 0c             	mov    0xc(%eax),%eax
  802a27:	2b 45 08             	sub    0x8(%ebp),%eax
  802a2a:	89 c2                	mov    %eax,%edx
  802a2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2f:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802a32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a35:	eb 3b                	jmp    802a72 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802a37:	a1 40 51 80 00       	mov    0x805140,%eax
  802a3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a3f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a43:	74 07                	je     802a4c <alloc_block_FF+0x1a5>
  802a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a48:	8b 00                	mov    (%eax),%eax
  802a4a:	eb 05                	jmp    802a51 <alloc_block_FF+0x1aa>
  802a4c:	b8 00 00 00 00       	mov    $0x0,%eax
  802a51:	a3 40 51 80 00       	mov    %eax,0x805140
  802a56:	a1 40 51 80 00       	mov    0x805140,%eax
  802a5b:	85 c0                	test   %eax,%eax
  802a5d:	0f 85 57 fe ff ff    	jne    8028ba <alloc_block_FF+0x13>
  802a63:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a67:	0f 85 4d fe ff ff    	jne    8028ba <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802a6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a72:	c9                   	leave  
  802a73:	c3                   	ret    

00802a74 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802a74:	55                   	push   %ebp
  802a75:	89 e5                	mov    %esp,%ebp
  802a77:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802a7a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802a81:	a1 38 51 80 00       	mov    0x805138,%eax
  802a86:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a89:	e9 df 00 00 00       	jmp    802b6d <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a91:	8b 40 0c             	mov    0xc(%eax),%eax
  802a94:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a97:	0f 82 c8 00 00 00    	jb     802b65 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802a9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa0:	8b 40 0c             	mov    0xc(%eax),%eax
  802aa3:	3b 45 08             	cmp    0x8(%ebp),%eax
  802aa6:	0f 85 8a 00 00 00    	jne    802b36 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802aac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ab0:	75 17                	jne    802ac9 <alloc_block_BF+0x55>
  802ab2:	83 ec 04             	sub    $0x4,%esp
  802ab5:	68 64 46 80 00       	push   $0x804664
  802aba:	68 b7 00 00 00       	push   $0xb7
  802abf:	68 bb 45 80 00       	push   $0x8045bb
  802ac4:	e8 2a de ff ff       	call   8008f3 <_panic>
  802ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acc:	8b 00                	mov    (%eax),%eax
  802ace:	85 c0                	test   %eax,%eax
  802ad0:	74 10                	je     802ae2 <alloc_block_BF+0x6e>
  802ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad5:	8b 00                	mov    (%eax),%eax
  802ad7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ada:	8b 52 04             	mov    0x4(%edx),%edx
  802add:	89 50 04             	mov    %edx,0x4(%eax)
  802ae0:	eb 0b                	jmp    802aed <alloc_block_BF+0x79>
  802ae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae5:	8b 40 04             	mov    0x4(%eax),%eax
  802ae8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af0:	8b 40 04             	mov    0x4(%eax),%eax
  802af3:	85 c0                	test   %eax,%eax
  802af5:	74 0f                	je     802b06 <alloc_block_BF+0x92>
  802af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afa:	8b 40 04             	mov    0x4(%eax),%eax
  802afd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b00:	8b 12                	mov    (%edx),%edx
  802b02:	89 10                	mov    %edx,(%eax)
  802b04:	eb 0a                	jmp    802b10 <alloc_block_BF+0x9c>
  802b06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b09:	8b 00                	mov    (%eax),%eax
  802b0b:	a3 38 51 80 00       	mov    %eax,0x805138
  802b10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b13:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b23:	a1 44 51 80 00       	mov    0x805144,%eax
  802b28:	48                   	dec    %eax
  802b29:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b31:	e9 4d 01 00 00       	jmp    802c83 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802b36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b39:	8b 40 0c             	mov    0xc(%eax),%eax
  802b3c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b3f:	76 24                	jbe    802b65 <alloc_block_BF+0xf1>
  802b41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b44:	8b 40 0c             	mov    0xc(%eax),%eax
  802b47:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802b4a:	73 19                	jae    802b65 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802b4c:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b56:	8b 40 0c             	mov    0xc(%eax),%eax
  802b59:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802b5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5f:	8b 40 08             	mov    0x8(%eax),%eax
  802b62:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802b65:	a1 40 51 80 00       	mov    0x805140,%eax
  802b6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b6d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b71:	74 07                	je     802b7a <alloc_block_BF+0x106>
  802b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b76:	8b 00                	mov    (%eax),%eax
  802b78:	eb 05                	jmp    802b7f <alloc_block_BF+0x10b>
  802b7a:	b8 00 00 00 00       	mov    $0x0,%eax
  802b7f:	a3 40 51 80 00       	mov    %eax,0x805140
  802b84:	a1 40 51 80 00       	mov    0x805140,%eax
  802b89:	85 c0                	test   %eax,%eax
  802b8b:	0f 85 fd fe ff ff    	jne    802a8e <alloc_block_BF+0x1a>
  802b91:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b95:	0f 85 f3 fe ff ff    	jne    802a8e <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802b9b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b9f:	0f 84 d9 00 00 00    	je     802c7e <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802ba5:	a1 48 51 80 00       	mov    0x805148,%eax
  802baa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802bad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bb0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bb3:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802bb6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bb9:	8b 55 08             	mov    0x8(%ebp),%edx
  802bbc:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802bbf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802bc3:	75 17                	jne    802bdc <alloc_block_BF+0x168>
  802bc5:	83 ec 04             	sub    $0x4,%esp
  802bc8:	68 64 46 80 00       	push   $0x804664
  802bcd:	68 c7 00 00 00       	push   $0xc7
  802bd2:	68 bb 45 80 00       	push   $0x8045bb
  802bd7:	e8 17 dd ff ff       	call   8008f3 <_panic>
  802bdc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bdf:	8b 00                	mov    (%eax),%eax
  802be1:	85 c0                	test   %eax,%eax
  802be3:	74 10                	je     802bf5 <alloc_block_BF+0x181>
  802be5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802be8:	8b 00                	mov    (%eax),%eax
  802bea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802bed:	8b 52 04             	mov    0x4(%edx),%edx
  802bf0:	89 50 04             	mov    %edx,0x4(%eax)
  802bf3:	eb 0b                	jmp    802c00 <alloc_block_BF+0x18c>
  802bf5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bf8:	8b 40 04             	mov    0x4(%eax),%eax
  802bfb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c03:	8b 40 04             	mov    0x4(%eax),%eax
  802c06:	85 c0                	test   %eax,%eax
  802c08:	74 0f                	je     802c19 <alloc_block_BF+0x1a5>
  802c0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c0d:	8b 40 04             	mov    0x4(%eax),%eax
  802c10:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c13:	8b 12                	mov    (%edx),%edx
  802c15:	89 10                	mov    %edx,(%eax)
  802c17:	eb 0a                	jmp    802c23 <alloc_block_BF+0x1af>
  802c19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c1c:	8b 00                	mov    (%eax),%eax
  802c1e:	a3 48 51 80 00       	mov    %eax,0x805148
  802c23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c26:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c2f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c36:	a1 54 51 80 00       	mov    0x805154,%eax
  802c3b:	48                   	dec    %eax
  802c3c:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802c41:	83 ec 08             	sub    $0x8,%esp
  802c44:	ff 75 ec             	pushl  -0x14(%ebp)
  802c47:	68 38 51 80 00       	push   $0x805138
  802c4c:	e8 71 f9 ff ff       	call   8025c2 <find_block>
  802c51:	83 c4 10             	add    $0x10,%esp
  802c54:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802c57:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c5a:	8b 50 08             	mov    0x8(%eax),%edx
  802c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c60:	01 c2                	add    %eax,%edx
  802c62:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c65:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802c68:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c6b:	8b 40 0c             	mov    0xc(%eax),%eax
  802c6e:	2b 45 08             	sub    0x8(%ebp),%eax
  802c71:	89 c2                	mov    %eax,%edx
  802c73:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c76:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802c79:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c7c:	eb 05                	jmp    802c83 <alloc_block_BF+0x20f>
	}
	return NULL;
  802c7e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c83:	c9                   	leave  
  802c84:	c3                   	ret    

00802c85 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802c85:	55                   	push   %ebp
  802c86:	89 e5                	mov    %esp,%ebp
  802c88:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802c8b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802c90:	85 c0                	test   %eax,%eax
  802c92:	0f 85 de 01 00 00    	jne    802e76 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802c98:	a1 38 51 80 00       	mov    0x805138,%eax
  802c9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ca0:	e9 9e 01 00 00       	jmp    802e43 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802ca5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca8:	8b 40 0c             	mov    0xc(%eax),%eax
  802cab:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cae:	0f 82 87 01 00 00    	jb     802e3b <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802cb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb7:	8b 40 0c             	mov    0xc(%eax),%eax
  802cba:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cbd:	0f 85 95 00 00 00    	jne    802d58 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802cc3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cc7:	75 17                	jne    802ce0 <alloc_block_NF+0x5b>
  802cc9:	83 ec 04             	sub    $0x4,%esp
  802ccc:	68 64 46 80 00       	push   $0x804664
  802cd1:	68 e0 00 00 00       	push   $0xe0
  802cd6:	68 bb 45 80 00       	push   $0x8045bb
  802cdb:	e8 13 dc ff ff       	call   8008f3 <_panic>
  802ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce3:	8b 00                	mov    (%eax),%eax
  802ce5:	85 c0                	test   %eax,%eax
  802ce7:	74 10                	je     802cf9 <alloc_block_NF+0x74>
  802ce9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cec:	8b 00                	mov    (%eax),%eax
  802cee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cf1:	8b 52 04             	mov    0x4(%edx),%edx
  802cf4:	89 50 04             	mov    %edx,0x4(%eax)
  802cf7:	eb 0b                	jmp    802d04 <alloc_block_NF+0x7f>
  802cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfc:	8b 40 04             	mov    0x4(%eax),%eax
  802cff:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d07:	8b 40 04             	mov    0x4(%eax),%eax
  802d0a:	85 c0                	test   %eax,%eax
  802d0c:	74 0f                	je     802d1d <alloc_block_NF+0x98>
  802d0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d11:	8b 40 04             	mov    0x4(%eax),%eax
  802d14:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d17:	8b 12                	mov    (%edx),%edx
  802d19:	89 10                	mov    %edx,(%eax)
  802d1b:	eb 0a                	jmp    802d27 <alloc_block_NF+0xa2>
  802d1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d20:	8b 00                	mov    (%eax),%eax
  802d22:	a3 38 51 80 00       	mov    %eax,0x805138
  802d27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d33:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d3a:	a1 44 51 80 00       	mov    0x805144,%eax
  802d3f:	48                   	dec    %eax
  802d40:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802d45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d48:	8b 40 08             	mov    0x8(%eax),%eax
  802d4b:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   return  point;
  802d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d53:	e9 f8 04 00 00       	jmp    803250 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802d58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5b:	8b 40 0c             	mov    0xc(%eax),%eax
  802d5e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d61:	0f 86 d4 00 00 00    	jbe    802e3b <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d67:	a1 48 51 80 00       	mov    0x805148,%eax
  802d6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d72:	8b 50 08             	mov    0x8(%eax),%edx
  802d75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d78:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802d7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d7e:	8b 55 08             	mov    0x8(%ebp),%edx
  802d81:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802d84:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d88:	75 17                	jne    802da1 <alloc_block_NF+0x11c>
  802d8a:	83 ec 04             	sub    $0x4,%esp
  802d8d:	68 64 46 80 00       	push   $0x804664
  802d92:	68 e9 00 00 00       	push   $0xe9
  802d97:	68 bb 45 80 00       	push   $0x8045bb
  802d9c:	e8 52 db ff ff       	call   8008f3 <_panic>
  802da1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da4:	8b 00                	mov    (%eax),%eax
  802da6:	85 c0                	test   %eax,%eax
  802da8:	74 10                	je     802dba <alloc_block_NF+0x135>
  802daa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dad:	8b 00                	mov    (%eax),%eax
  802daf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802db2:	8b 52 04             	mov    0x4(%edx),%edx
  802db5:	89 50 04             	mov    %edx,0x4(%eax)
  802db8:	eb 0b                	jmp    802dc5 <alloc_block_NF+0x140>
  802dba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dbd:	8b 40 04             	mov    0x4(%eax),%eax
  802dc0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802dc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc8:	8b 40 04             	mov    0x4(%eax),%eax
  802dcb:	85 c0                	test   %eax,%eax
  802dcd:	74 0f                	je     802dde <alloc_block_NF+0x159>
  802dcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd2:	8b 40 04             	mov    0x4(%eax),%eax
  802dd5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dd8:	8b 12                	mov    (%edx),%edx
  802dda:	89 10                	mov    %edx,(%eax)
  802ddc:	eb 0a                	jmp    802de8 <alloc_block_NF+0x163>
  802dde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de1:	8b 00                	mov    (%eax),%eax
  802de3:	a3 48 51 80 00       	mov    %eax,0x805148
  802de8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802deb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802df1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dfb:	a1 54 51 80 00       	mov    0x805154,%eax
  802e00:	48                   	dec    %eax
  802e01:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802e06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e09:	8b 40 08             	mov    0x8(%eax),%eax
  802e0c:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   point->sva += size;
  802e11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e14:	8b 50 08             	mov    0x8(%eax),%edx
  802e17:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1a:	01 c2                	add    %eax,%edx
  802e1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1f:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802e22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e25:	8b 40 0c             	mov    0xc(%eax),%eax
  802e28:	2b 45 08             	sub    0x8(%ebp),%eax
  802e2b:	89 c2                	mov    %eax,%edx
  802e2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e30:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802e33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e36:	e9 15 04 00 00       	jmp    803250 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802e3b:	a1 40 51 80 00       	mov    0x805140,%eax
  802e40:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e43:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e47:	74 07                	je     802e50 <alloc_block_NF+0x1cb>
  802e49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4c:	8b 00                	mov    (%eax),%eax
  802e4e:	eb 05                	jmp    802e55 <alloc_block_NF+0x1d0>
  802e50:	b8 00 00 00 00       	mov    $0x0,%eax
  802e55:	a3 40 51 80 00       	mov    %eax,0x805140
  802e5a:	a1 40 51 80 00       	mov    0x805140,%eax
  802e5f:	85 c0                	test   %eax,%eax
  802e61:	0f 85 3e fe ff ff    	jne    802ca5 <alloc_block_NF+0x20>
  802e67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e6b:	0f 85 34 fe ff ff    	jne    802ca5 <alloc_block_NF+0x20>
  802e71:	e9 d5 03 00 00       	jmp    80324b <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802e76:	a1 38 51 80 00       	mov    0x805138,%eax
  802e7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e7e:	e9 b1 01 00 00       	jmp    803034 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802e83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e86:	8b 50 08             	mov    0x8(%eax),%edx
  802e89:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e8e:	39 c2                	cmp    %eax,%edx
  802e90:	0f 82 96 01 00 00    	jb     80302c <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802e96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e99:	8b 40 0c             	mov    0xc(%eax),%eax
  802e9c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e9f:	0f 82 87 01 00 00    	jb     80302c <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802ea5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea8:	8b 40 0c             	mov    0xc(%eax),%eax
  802eab:	3b 45 08             	cmp    0x8(%ebp),%eax
  802eae:	0f 85 95 00 00 00    	jne    802f49 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802eb4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eb8:	75 17                	jne    802ed1 <alloc_block_NF+0x24c>
  802eba:	83 ec 04             	sub    $0x4,%esp
  802ebd:	68 64 46 80 00       	push   $0x804664
  802ec2:	68 fc 00 00 00       	push   $0xfc
  802ec7:	68 bb 45 80 00       	push   $0x8045bb
  802ecc:	e8 22 da ff ff       	call   8008f3 <_panic>
  802ed1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed4:	8b 00                	mov    (%eax),%eax
  802ed6:	85 c0                	test   %eax,%eax
  802ed8:	74 10                	je     802eea <alloc_block_NF+0x265>
  802eda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edd:	8b 00                	mov    (%eax),%eax
  802edf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ee2:	8b 52 04             	mov    0x4(%edx),%edx
  802ee5:	89 50 04             	mov    %edx,0x4(%eax)
  802ee8:	eb 0b                	jmp    802ef5 <alloc_block_NF+0x270>
  802eea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eed:	8b 40 04             	mov    0x4(%eax),%eax
  802ef0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ef5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef8:	8b 40 04             	mov    0x4(%eax),%eax
  802efb:	85 c0                	test   %eax,%eax
  802efd:	74 0f                	je     802f0e <alloc_block_NF+0x289>
  802eff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f02:	8b 40 04             	mov    0x4(%eax),%eax
  802f05:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f08:	8b 12                	mov    (%edx),%edx
  802f0a:	89 10                	mov    %edx,(%eax)
  802f0c:	eb 0a                	jmp    802f18 <alloc_block_NF+0x293>
  802f0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f11:	8b 00                	mov    (%eax),%eax
  802f13:	a3 38 51 80 00       	mov    %eax,0x805138
  802f18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f24:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f2b:	a1 44 51 80 00       	mov    0x805144,%eax
  802f30:	48                   	dec    %eax
  802f31:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802f36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f39:	8b 40 08             	mov    0x8(%eax),%eax
  802f3c:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  802f41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f44:	e9 07 03 00 00       	jmp    803250 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4c:	8b 40 0c             	mov    0xc(%eax),%eax
  802f4f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f52:	0f 86 d4 00 00 00    	jbe    80302c <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802f58:	a1 48 51 80 00       	mov    0x805148,%eax
  802f5d:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802f60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f63:	8b 50 08             	mov    0x8(%eax),%edx
  802f66:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f69:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802f6c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f6f:	8b 55 08             	mov    0x8(%ebp),%edx
  802f72:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802f75:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f79:	75 17                	jne    802f92 <alloc_block_NF+0x30d>
  802f7b:	83 ec 04             	sub    $0x4,%esp
  802f7e:	68 64 46 80 00       	push   $0x804664
  802f83:	68 04 01 00 00       	push   $0x104
  802f88:	68 bb 45 80 00       	push   $0x8045bb
  802f8d:	e8 61 d9 ff ff       	call   8008f3 <_panic>
  802f92:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f95:	8b 00                	mov    (%eax),%eax
  802f97:	85 c0                	test   %eax,%eax
  802f99:	74 10                	je     802fab <alloc_block_NF+0x326>
  802f9b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f9e:	8b 00                	mov    (%eax),%eax
  802fa0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fa3:	8b 52 04             	mov    0x4(%edx),%edx
  802fa6:	89 50 04             	mov    %edx,0x4(%eax)
  802fa9:	eb 0b                	jmp    802fb6 <alloc_block_NF+0x331>
  802fab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fae:	8b 40 04             	mov    0x4(%eax),%eax
  802fb1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fb6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb9:	8b 40 04             	mov    0x4(%eax),%eax
  802fbc:	85 c0                	test   %eax,%eax
  802fbe:	74 0f                	je     802fcf <alloc_block_NF+0x34a>
  802fc0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc3:	8b 40 04             	mov    0x4(%eax),%eax
  802fc6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fc9:	8b 12                	mov    (%edx),%edx
  802fcb:	89 10                	mov    %edx,(%eax)
  802fcd:	eb 0a                	jmp    802fd9 <alloc_block_NF+0x354>
  802fcf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fd2:	8b 00                	mov    (%eax),%eax
  802fd4:	a3 48 51 80 00       	mov    %eax,0x805148
  802fd9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fdc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fe2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fec:	a1 54 51 80 00       	mov    0x805154,%eax
  802ff1:	48                   	dec    %eax
  802ff2:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802ff7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ffa:	8b 40 08             	mov    0x8(%eax),%eax
  802ffd:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  803002:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803005:	8b 50 08             	mov    0x8(%eax),%edx
  803008:	8b 45 08             	mov    0x8(%ebp),%eax
  80300b:	01 c2                	add    %eax,%edx
  80300d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803010:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803013:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803016:	8b 40 0c             	mov    0xc(%eax),%eax
  803019:	2b 45 08             	sub    0x8(%ebp),%eax
  80301c:	89 c2                	mov    %eax,%edx
  80301e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803021:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803024:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803027:	e9 24 02 00 00       	jmp    803250 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80302c:	a1 40 51 80 00       	mov    0x805140,%eax
  803031:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803034:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803038:	74 07                	je     803041 <alloc_block_NF+0x3bc>
  80303a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303d:	8b 00                	mov    (%eax),%eax
  80303f:	eb 05                	jmp    803046 <alloc_block_NF+0x3c1>
  803041:	b8 00 00 00 00       	mov    $0x0,%eax
  803046:	a3 40 51 80 00       	mov    %eax,0x805140
  80304b:	a1 40 51 80 00       	mov    0x805140,%eax
  803050:	85 c0                	test   %eax,%eax
  803052:	0f 85 2b fe ff ff    	jne    802e83 <alloc_block_NF+0x1fe>
  803058:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80305c:	0f 85 21 fe ff ff    	jne    802e83 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803062:	a1 38 51 80 00       	mov    0x805138,%eax
  803067:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80306a:	e9 ae 01 00 00       	jmp    80321d <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  80306f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803072:	8b 50 08             	mov    0x8(%eax),%edx
  803075:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80307a:	39 c2                	cmp    %eax,%edx
  80307c:	0f 83 93 01 00 00    	jae    803215 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  803082:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803085:	8b 40 0c             	mov    0xc(%eax),%eax
  803088:	3b 45 08             	cmp    0x8(%ebp),%eax
  80308b:	0f 82 84 01 00 00    	jb     803215 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  803091:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803094:	8b 40 0c             	mov    0xc(%eax),%eax
  803097:	3b 45 08             	cmp    0x8(%ebp),%eax
  80309a:	0f 85 95 00 00 00    	jne    803135 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8030a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030a4:	75 17                	jne    8030bd <alloc_block_NF+0x438>
  8030a6:	83 ec 04             	sub    $0x4,%esp
  8030a9:	68 64 46 80 00       	push   $0x804664
  8030ae:	68 14 01 00 00       	push   $0x114
  8030b3:	68 bb 45 80 00       	push   $0x8045bb
  8030b8:	e8 36 d8 ff ff       	call   8008f3 <_panic>
  8030bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c0:	8b 00                	mov    (%eax),%eax
  8030c2:	85 c0                	test   %eax,%eax
  8030c4:	74 10                	je     8030d6 <alloc_block_NF+0x451>
  8030c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c9:	8b 00                	mov    (%eax),%eax
  8030cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030ce:	8b 52 04             	mov    0x4(%edx),%edx
  8030d1:	89 50 04             	mov    %edx,0x4(%eax)
  8030d4:	eb 0b                	jmp    8030e1 <alloc_block_NF+0x45c>
  8030d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d9:	8b 40 04             	mov    0x4(%eax),%eax
  8030dc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e4:	8b 40 04             	mov    0x4(%eax),%eax
  8030e7:	85 c0                	test   %eax,%eax
  8030e9:	74 0f                	je     8030fa <alloc_block_NF+0x475>
  8030eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ee:	8b 40 04             	mov    0x4(%eax),%eax
  8030f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030f4:	8b 12                	mov    (%edx),%edx
  8030f6:	89 10                	mov    %edx,(%eax)
  8030f8:	eb 0a                	jmp    803104 <alloc_block_NF+0x47f>
  8030fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fd:	8b 00                	mov    (%eax),%eax
  8030ff:	a3 38 51 80 00       	mov    %eax,0x805138
  803104:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803107:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80310d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803110:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803117:	a1 44 51 80 00       	mov    0x805144,%eax
  80311c:	48                   	dec    %eax
  80311d:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803122:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803125:	8b 40 08             	mov    0x8(%eax),%eax
  803128:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  80312d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803130:	e9 1b 01 00 00       	jmp    803250 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803135:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803138:	8b 40 0c             	mov    0xc(%eax),%eax
  80313b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80313e:	0f 86 d1 00 00 00    	jbe    803215 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803144:	a1 48 51 80 00       	mov    0x805148,%eax
  803149:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  80314c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314f:	8b 50 08             	mov    0x8(%eax),%edx
  803152:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803155:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803158:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80315b:	8b 55 08             	mov    0x8(%ebp),%edx
  80315e:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803161:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803165:	75 17                	jne    80317e <alloc_block_NF+0x4f9>
  803167:	83 ec 04             	sub    $0x4,%esp
  80316a:	68 64 46 80 00       	push   $0x804664
  80316f:	68 1c 01 00 00       	push   $0x11c
  803174:	68 bb 45 80 00       	push   $0x8045bb
  803179:	e8 75 d7 ff ff       	call   8008f3 <_panic>
  80317e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803181:	8b 00                	mov    (%eax),%eax
  803183:	85 c0                	test   %eax,%eax
  803185:	74 10                	je     803197 <alloc_block_NF+0x512>
  803187:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80318a:	8b 00                	mov    (%eax),%eax
  80318c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80318f:	8b 52 04             	mov    0x4(%edx),%edx
  803192:	89 50 04             	mov    %edx,0x4(%eax)
  803195:	eb 0b                	jmp    8031a2 <alloc_block_NF+0x51d>
  803197:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80319a:	8b 40 04             	mov    0x4(%eax),%eax
  80319d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031a5:	8b 40 04             	mov    0x4(%eax),%eax
  8031a8:	85 c0                	test   %eax,%eax
  8031aa:	74 0f                	je     8031bb <alloc_block_NF+0x536>
  8031ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031af:	8b 40 04             	mov    0x4(%eax),%eax
  8031b2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8031b5:	8b 12                	mov    (%edx),%edx
  8031b7:	89 10                	mov    %edx,(%eax)
  8031b9:	eb 0a                	jmp    8031c5 <alloc_block_NF+0x540>
  8031bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031be:	8b 00                	mov    (%eax),%eax
  8031c0:	a3 48 51 80 00       	mov    %eax,0x805148
  8031c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031d1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031d8:	a1 54 51 80 00       	mov    0x805154,%eax
  8031dd:	48                   	dec    %eax
  8031de:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8031e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031e6:	8b 40 08             	mov    0x8(%eax),%eax
  8031e9:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  8031ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f1:	8b 50 08             	mov    0x8(%eax),%edx
  8031f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f7:	01 c2                	add    %eax,%edx
  8031f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031fc:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8031ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803202:	8b 40 0c             	mov    0xc(%eax),%eax
  803205:	2b 45 08             	sub    0x8(%ebp),%eax
  803208:	89 c2                	mov    %eax,%edx
  80320a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320d:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803210:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803213:	eb 3b                	jmp    803250 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803215:	a1 40 51 80 00       	mov    0x805140,%eax
  80321a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80321d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803221:	74 07                	je     80322a <alloc_block_NF+0x5a5>
  803223:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803226:	8b 00                	mov    (%eax),%eax
  803228:	eb 05                	jmp    80322f <alloc_block_NF+0x5aa>
  80322a:	b8 00 00 00 00       	mov    $0x0,%eax
  80322f:	a3 40 51 80 00       	mov    %eax,0x805140
  803234:	a1 40 51 80 00       	mov    0x805140,%eax
  803239:	85 c0                	test   %eax,%eax
  80323b:	0f 85 2e fe ff ff    	jne    80306f <alloc_block_NF+0x3ea>
  803241:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803245:	0f 85 24 fe ff ff    	jne    80306f <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  80324b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803250:	c9                   	leave  
  803251:	c3                   	ret    

00803252 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803252:	55                   	push   %ebp
  803253:	89 e5                	mov    %esp,%ebp
  803255:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  803258:	a1 38 51 80 00       	mov    0x805138,%eax
  80325d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  803260:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803265:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  803268:	a1 38 51 80 00       	mov    0x805138,%eax
  80326d:	85 c0                	test   %eax,%eax
  80326f:	74 14                	je     803285 <insert_sorted_with_merge_freeList+0x33>
  803271:	8b 45 08             	mov    0x8(%ebp),%eax
  803274:	8b 50 08             	mov    0x8(%eax),%edx
  803277:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80327a:	8b 40 08             	mov    0x8(%eax),%eax
  80327d:	39 c2                	cmp    %eax,%edx
  80327f:	0f 87 9b 01 00 00    	ja     803420 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  803285:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803289:	75 17                	jne    8032a2 <insert_sorted_with_merge_freeList+0x50>
  80328b:	83 ec 04             	sub    $0x4,%esp
  80328e:	68 98 45 80 00       	push   $0x804598
  803293:	68 38 01 00 00       	push   $0x138
  803298:	68 bb 45 80 00       	push   $0x8045bb
  80329d:	e8 51 d6 ff ff       	call   8008f3 <_panic>
  8032a2:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8032a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ab:	89 10                	mov    %edx,(%eax)
  8032ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b0:	8b 00                	mov    (%eax),%eax
  8032b2:	85 c0                	test   %eax,%eax
  8032b4:	74 0d                	je     8032c3 <insert_sorted_with_merge_freeList+0x71>
  8032b6:	a1 38 51 80 00       	mov    0x805138,%eax
  8032bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8032be:	89 50 04             	mov    %edx,0x4(%eax)
  8032c1:	eb 08                	jmp    8032cb <insert_sorted_with_merge_freeList+0x79>
  8032c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ce:	a3 38 51 80 00       	mov    %eax,0x805138
  8032d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032dd:	a1 44 51 80 00       	mov    0x805144,%eax
  8032e2:	40                   	inc    %eax
  8032e3:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8032e8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8032ec:	0f 84 a8 06 00 00    	je     80399a <insert_sorted_with_merge_freeList+0x748>
  8032f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f5:	8b 50 08             	mov    0x8(%eax),%edx
  8032f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fb:	8b 40 0c             	mov    0xc(%eax),%eax
  8032fe:	01 c2                	add    %eax,%edx
  803300:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803303:	8b 40 08             	mov    0x8(%eax),%eax
  803306:	39 c2                	cmp    %eax,%edx
  803308:	0f 85 8c 06 00 00    	jne    80399a <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  80330e:	8b 45 08             	mov    0x8(%ebp),%eax
  803311:	8b 50 0c             	mov    0xc(%eax),%edx
  803314:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803317:	8b 40 0c             	mov    0xc(%eax),%eax
  80331a:	01 c2                	add    %eax,%edx
  80331c:	8b 45 08             	mov    0x8(%ebp),%eax
  80331f:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803322:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803326:	75 17                	jne    80333f <insert_sorted_with_merge_freeList+0xed>
  803328:	83 ec 04             	sub    $0x4,%esp
  80332b:	68 64 46 80 00       	push   $0x804664
  803330:	68 3c 01 00 00       	push   $0x13c
  803335:	68 bb 45 80 00       	push   $0x8045bb
  80333a:	e8 b4 d5 ff ff       	call   8008f3 <_panic>
  80333f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803342:	8b 00                	mov    (%eax),%eax
  803344:	85 c0                	test   %eax,%eax
  803346:	74 10                	je     803358 <insert_sorted_with_merge_freeList+0x106>
  803348:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80334b:	8b 00                	mov    (%eax),%eax
  80334d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803350:	8b 52 04             	mov    0x4(%edx),%edx
  803353:	89 50 04             	mov    %edx,0x4(%eax)
  803356:	eb 0b                	jmp    803363 <insert_sorted_with_merge_freeList+0x111>
  803358:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80335b:	8b 40 04             	mov    0x4(%eax),%eax
  80335e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803363:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803366:	8b 40 04             	mov    0x4(%eax),%eax
  803369:	85 c0                	test   %eax,%eax
  80336b:	74 0f                	je     80337c <insert_sorted_with_merge_freeList+0x12a>
  80336d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803370:	8b 40 04             	mov    0x4(%eax),%eax
  803373:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803376:	8b 12                	mov    (%edx),%edx
  803378:	89 10                	mov    %edx,(%eax)
  80337a:	eb 0a                	jmp    803386 <insert_sorted_with_merge_freeList+0x134>
  80337c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80337f:	8b 00                	mov    (%eax),%eax
  803381:	a3 38 51 80 00       	mov    %eax,0x805138
  803386:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803389:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80338f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803392:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803399:	a1 44 51 80 00       	mov    0x805144,%eax
  80339e:	48                   	dec    %eax
  80339f:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  8033a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033a7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  8033ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033b1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  8033b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033bc:	75 17                	jne    8033d5 <insert_sorted_with_merge_freeList+0x183>
  8033be:	83 ec 04             	sub    $0x4,%esp
  8033c1:	68 98 45 80 00       	push   $0x804598
  8033c6:	68 3f 01 00 00       	push   $0x13f
  8033cb:	68 bb 45 80 00       	push   $0x8045bb
  8033d0:	e8 1e d5 ff ff       	call   8008f3 <_panic>
  8033d5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033de:	89 10                	mov    %edx,(%eax)
  8033e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033e3:	8b 00                	mov    (%eax),%eax
  8033e5:	85 c0                	test   %eax,%eax
  8033e7:	74 0d                	je     8033f6 <insert_sorted_with_merge_freeList+0x1a4>
  8033e9:	a1 48 51 80 00       	mov    0x805148,%eax
  8033ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033f1:	89 50 04             	mov    %edx,0x4(%eax)
  8033f4:	eb 08                	jmp    8033fe <insert_sorted_with_merge_freeList+0x1ac>
  8033f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033f9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803401:	a3 48 51 80 00       	mov    %eax,0x805148
  803406:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803409:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803410:	a1 54 51 80 00       	mov    0x805154,%eax
  803415:	40                   	inc    %eax
  803416:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80341b:	e9 7a 05 00 00       	jmp    80399a <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803420:	8b 45 08             	mov    0x8(%ebp),%eax
  803423:	8b 50 08             	mov    0x8(%eax),%edx
  803426:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803429:	8b 40 08             	mov    0x8(%eax),%eax
  80342c:	39 c2                	cmp    %eax,%edx
  80342e:	0f 82 14 01 00 00    	jb     803548 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803434:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803437:	8b 50 08             	mov    0x8(%eax),%edx
  80343a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80343d:	8b 40 0c             	mov    0xc(%eax),%eax
  803440:	01 c2                	add    %eax,%edx
  803442:	8b 45 08             	mov    0x8(%ebp),%eax
  803445:	8b 40 08             	mov    0x8(%eax),%eax
  803448:	39 c2                	cmp    %eax,%edx
  80344a:	0f 85 90 00 00 00    	jne    8034e0 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803450:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803453:	8b 50 0c             	mov    0xc(%eax),%edx
  803456:	8b 45 08             	mov    0x8(%ebp),%eax
  803459:	8b 40 0c             	mov    0xc(%eax),%eax
  80345c:	01 c2                	add    %eax,%edx
  80345e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803461:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803464:	8b 45 08             	mov    0x8(%ebp),%eax
  803467:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  80346e:	8b 45 08             	mov    0x8(%ebp),%eax
  803471:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803478:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80347c:	75 17                	jne    803495 <insert_sorted_with_merge_freeList+0x243>
  80347e:	83 ec 04             	sub    $0x4,%esp
  803481:	68 98 45 80 00       	push   $0x804598
  803486:	68 49 01 00 00       	push   $0x149
  80348b:	68 bb 45 80 00       	push   $0x8045bb
  803490:	e8 5e d4 ff ff       	call   8008f3 <_panic>
  803495:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80349b:	8b 45 08             	mov    0x8(%ebp),%eax
  80349e:	89 10                	mov    %edx,(%eax)
  8034a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a3:	8b 00                	mov    (%eax),%eax
  8034a5:	85 c0                	test   %eax,%eax
  8034a7:	74 0d                	je     8034b6 <insert_sorted_with_merge_freeList+0x264>
  8034a9:	a1 48 51 80 00       	mov    0x805148,%eax
  8034ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8034b1:	89 50 04             	mov    %edx,0x4(%eax)
  8034b4:	eb 08                	jmp    8034be <insert_sorted_with_merge_freeList+0x26c>
  8034b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034be:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c1:	a3 48 51 80 00       	mov    %eax,0x805148
  8034c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034d0:	a1 54 51 80 00       	mov    0x805154,%eax
  8034d5:	40                   	inc    %eax
  8034d6:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8034db:	e9 bb 04 00 00       	jmp    80399b <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8034e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034e4:	75 17                	jne    8034fd <insert_sorted_with_merge_freeList+0x2ab>
  8034e6:	83 ec 04             	sub    $0x4,%esp
  8034e9:	68 0c 46 80 00       	push   $0x80460c
  8034ee:	68 4c 01 00 00       	push   $0x14c
  8034f3:	68 bb 45 80 00       	push   $0x8045bb
  8034f8:	e8 f6 d3 ff ff       	call   8008f3 <_panic>
  8034fd:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803503:	8b 45 08             	mov    0x8(%ebp),%eax
  803506:	89 50 04             	mov    %edx,0x4(%eax)
  803509:	8b 45 08             	mov    0x8(%ebp),%eax
  80350c:	8b 40 04             	mov    0x4(%eax),%eax
  80350f:	85 c0                	test   %eax,%eax
  803511:	74 0c                	je     80351f <insert_sorted_with_merge_freeList+0x2cd>
  803513:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803518:	8b 55 08             	mov    0x8(%ebp),%edx
  80351b:	89 10                	mov    %edx,(%eax)
  80351d:	eb 08                	jmp    803527 <insert_sorted_with_merge_freeList+0x2d5>
  80351f:	8b 45 08             	mov    0x8(%ebp),%eax
  803522:	a3 38 51 80 00       	mov    %eax,0x805138
  803527:	8b 45 08             	mov    0x8(%ebp),%eax
  80352a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80352f:	8b 45 08             	mov    0x8(%ebp),%eax
  803532:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803538:	a1 44 51 80 00       	mov    0x805144,%eax
  80353d:	40                   	inc    %eax
  80353e:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803543:	e9 53 04 00 00       	jmp    80399b <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803548:	a1 38 51 80 00       	mov    0x805138,%eax
  80354d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803550:	e9 15 04 00 00       	jmp    80396a <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803555:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803558:	8b 00                	mov    (%eax),%eax
  80355a:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  80355d:	8b 45 08             	mov    0x8(%ebp),%eax
  803560:	8b 50 08             	mov    0x8(%eax),%edx
  803563:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803566:	8b 40 08             	mov    0x8(%eax),%eax
  803569:	39 c2                	cmp    %eax,%edx
  80356b:	0f 86 f1 03 00 00    	jbe    803962 <insert_sorted_with_merge_freeList+0x710>
  803571:	8b 45 08             	mov    0x8(%ebp),%eax
  803574:	8b 50 08             	mov    0x8(%eax),%edx
  803577:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80357a:	8b 40 08             	mov    0x8(%eax),%eax
  80357d:	39 c2                	cmp    %eax,%edx
  80357f:	0f 83 dd 03 00 00    	jae    803962 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803585:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803588:	8b 50 08             	mov    0x8(%eax),%edx
  80358b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80358e:	8b 40 0c             	mov    0xc(%eax),%eax
  803591:	01 c2                	add    %eax,%edx
  803593:	8b 45 08             	mov    0x8(%ebp),%eax
  803596:	8b 40 08             	mov    0x8(%eax),%eax
  803599:	39 c2                	cmp    %eax,%edx
  80359b:	0f 85 b9 01 00 00    	jne    80375a <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8035a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a4:	8b 50 08             	mov    0x8(%eax),%edx
  8035a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035aa:	8b 40 0c             	mov    0xc(%eax),%eax
  8035ad:	01 c2                	add    %eax,%edx
  8035af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035b2:	8b 40 08             	mov    0x8(%eax),%eax
  8035b5:	39 c2                	cmp    %eax,%edx
  8035b7:	0f 85 0d 01 00 00    	jne    8036ca <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8035bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c0:	8b 50 0c             	mov    0xc(%eax),%edx
  8035c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8035c9:	01 c2                	add    %eax,%edx
  8035cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ce:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8035d1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8035d5:	75 17                	jne    8035ee <insert_sorted_with_merge_freeList+0x39c>
  8035d7:	83 ec 04             	sub    $0x4,%esp
  8035da:	68 64 46 80 00       	push   $0x804664
  8035df:	68 5c 01 00 00       	push   $0x15c
  8035e4:	68 bb 45 80 00       	push   $0x8045bb
  8035e9:	e8 05 d3 ff ff       	call   8008f3 <_panic>
  8035ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035f1:	8b 00                	mov    (%eax),%eax
  8035f3:	85 c0                	test   %eax,%eax
  8035f5:	74 10                	je     803607 <insert_sorted_with_merge_freeList+0x3b5>
  8035f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035fa:	8b 00                	mov    (%eax),%eax
  8035fc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8035ff:	8b 52 04             	mov    0x4(%edx),%edx
  803602:	89 50 04             	mov    %edx,0x4(%eax)
  803605:	eb 0b                	jmp    803612 <insert_sorted_with_merge_freeList+0x3c0>
  803607:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80360a:	8b 40 04             	mov    0x4(%eax),%eax
  80360d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803612:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803615:	8b 40 04             	mov    0x4(%eax),%eax
  803618:	85 c0                	test   %eax,%eax
  80361a:	74 0f                	je     80362b <insert_sorted_with_merge_freeList+0x3d9>
  80361c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80361f:	8b 40 04             	mov    0x4(%eax),%eax
  803622:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803625:	8b 12                	mov    (%edx),%edx
  803627:	89 10                	mov    %edx,(%eax)
  803629:	eb 0a                	jmp    803635 <insert_sorted_with_merge_freeList+0x3e3>
  80362b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80362e:	8b 00                	mov    (%eax),%eax
  803630:	a3 38 51 80 00       	mov    %eax,0x805138
  803635:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803638:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80363e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803641:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803648:	a1 44 51 80 00       	mov    0x805144,%eax
  80364d:	48                   	dec    %eax
  80364e:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803653:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803656:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  80365d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803660:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803667:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80366b:	75 17                	jne    803684 <insert_sorted_with_merge_freeList+0x432>
  80366d:	83 ec 04             	sub    $0x4,%esp
  803670:	68 98 45 80 00       	push   $0x804598
  803675:	68 5f 01 00 00       	push   $0x15f
  80367a:	68 bb 45 80 00       	push   $0x8045bb
  80367f:	e8 6f d2 ff ff       	call   8008f3 <_panic>
  803684:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80368a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80368d:	89 10                	mov    %edx,(%eax)
  80368f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803692:	8b 00                	mov    (%eax),%eax
  803694:	85 c0                	test   %eax,%eax
  803696:	74 0d                	je     8036a5 <insert_sorted_with_merge_freeList+0x453>
  803698:	a1 48 51 80 00       	mov    0x805148,%eax
  80369d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036a0:	89 50 04             	mov    %edx,0x4(%eax)
  8036a3:	eb 08                	jmp    8036ad <insert_sorted_with_merge_freeList+0x45b>
  8036a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036a8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036b0:	a3 48 51 80 00       	mov    %eax,0x805148
  8036b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036b8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036bf:	a1 54 51 80 00       	mov    0x805154,%eax
  8036c4:	40                   	inc    %eax
  8036c5:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8036ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036cd:	8b 50 0c             	mov    0xc(%eax),%edx
  8036d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8036d6:	01 c2                	add    %eax,%edx
  8036d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036db:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8036de:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8036e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036eb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8036f2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036f6:	75 17                	jne    80370f <insert_sorted_with_merge_freeList+0x4bd>
  8036f8:	83 ec 04             	sub    $0x4,%esp
  8036fb:	68 98 45 80 00       	push   $0x804598
  803700:	68 64 01 00 00       	push   $0x164
  803705:	68 bb 45 80 00       	push   $0x8045bb
  80370a:	e8 e4 d1 ff ff       	call   8008f3 <_panic>
  80370f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803715:	8b 45 08             	mov    0x8(%ebp),%eax
  803718:	89 10                	mov    %edx,(%eax)
  80371a:	8b 45 08             	mov    0x8(%ebp),%eax
  80371d:	8b 00                	mov    (%eax),%eax
  80371f:	85 c0                	test   %eax,%eax
  803721:	74 0d                	je     803730 <insert_sorted_with_merge_freeList+0x4de>
  803723:	a1 48 51 80 00       	mov    0x805148,%eax
  803728:	8b 55 08             	mov    0x8(%ebp),%edx
  80372b:	89 50 04             	mov    %edx,0x4(%eax)
  80372e:	eb 08                	jmp    803738 <insert_sorted_with_merge_freeList+0x4e6>
  803730:	8b 45 08             	mov    0x8(%ebp),%eax
  803733:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803738:	8b 45 08             	mov    0x8(%ebp),%eax
  80373b:	a3 48 51 80 00       	mov    %eax,0x805148
  803740:	8b 45 08             	mov    0x8(%ebp),%eax
  803743:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80374a:	a1 54 51 80 00       	mov    0x805154,%eax
  80374f:	40                   	inc    %eax
  803750:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803755:	e9 41 02 00 00       	jmp    80399b <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80375a:	8b 45 08             	mov    0x8(%ebp),%eax
  80375d:	8b 50 08             	mov    0x8(%eax),%edx
  803760:	8b 45 08             	mov    0x8(%ebp),%eax
  803763:	8b 40 0c             	mov    0xc(%eax),%eax
  803766:	01 c2                	add    %eax,%edx
  803768:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80376b:	8b 40 08             	mov    0x8(%eax),%eax
  80376e:	39 c2                	cmp    %eax,%edx
  803770:	0f 85 7c 01 00 00    	jne    8038f2 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803776:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80377a:	74 06                	je     803782 <insert_sorted_with_merge_freeList+0x530>
  80377c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803780:	75 17                	jne    803799 <insert_sorted_with_merge_freeList+0x547>
  803782:	83 ec 04             	sub    $0x4,%esp
  803785:	68 d4 45 80 00       	push   $0x8045d4
  80378a:	68 69 01 00 00       	push   $0x169
  80378f:	68 bb 45 80 00       	push   $0x8045bb
  803794:	e8 5a d1 ff ff       	call   8008f3 <_panic>
  803799:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80379c:	8b 50 04             	mov    0x4(%eax),%edx
  80379f:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a2:	89 50 04             	mov    %edx,0x4(%eax)
  8037a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037ab:	89 10                	mov    %edx,(%eax)
  8037ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037b0:	8b 40 04             	mov    0x4(%eax),%eax
  8037b3:	85 c0                	test   %eax,%eax
  8037b5:	74 0d                	je     8037c4 <insert_sorted_with_merge_freeList+0x572>
  8037b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037ba:	8b 40 04             	mov    0x4(%eax),%eax
  8037bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8037c0:	89 10                	mov    %edx,(%eax)
  8037c2:	eb 08                	jmp    8037cc <insert_sorted_with_merge_freeList+0x57a>
  8037c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c7:	a3 38 51 80 00       	mov    %eax,0x805138
  8037cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8037d2:	89 50 04             	mov    %edx,0x4(%eax)
  8037d5:	a1 44 51 80 00       	mov    0x805144,%eax
  8037da:	40                   	inc    %eax
  8037db:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8037e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e3:	8b 50 0c             	mov    0xc(%eax),%edx
  8037e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8037ec:	01 c2                	add    %eax,%edx
  8037ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f1:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8037f4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8037f8:	75 17                	jne    803811 <insert_sorted_with_merge_freeList+0x5bf>
  8037fa:	83 ec 04             	sub    $0x4,%esp
  8037fd:	68 64 46 80 00       	push   $0x804664
  803802:	68 6b 01 00 00       	push   $0x16b
  803807:	68 bb 45 80 00       	push   $0x8045bb
  80380c:	e8 e2 d0 ff ff       	call   8008f3 <_panic>
  803811:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803814:	8b 00                	mov    (%eax),%eax
  803816:	85 c0                	test   %eax,%eax
  803818:	74 10                	je     80382a <insert_sorted_with_merge_freeList+0x5d8>
  80381a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80381d:	8b 00                	mov    (%eax),%eax
  80381f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803822:	8b 52 04             	mov    0x4(%edx),%edx
  803825:	89 50 04             	mov    %edx,0x4(%eax)
  803828:	eb 0b                	jmp    803835 <insert_sorted_with_merge_freeList+0x5e3>
  80382a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80382d:	8b 40 04             	mov    0x4(%eax),%eax
  803830:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803835:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803838:	8b 40 04             	mov    0x4(%eax),%eax
  80383b:	85 c0                	test   %eax,%eax
  80383d:	74 0f                	je     80384e <insert_sorted_with_merge_freeList+0x5fc>
  80383f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803842:	8b 40 04             	mov    0x4(%eax),%eax
  803845:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803848:	8b 12                	mov    (%edx),%edx
  80384a:	89 10                	mov    %edx,(%eax)
  80384c:	eb 0a                	jmp    803858 <insert_sorted_with_merge_freeList+0x606>
  80384e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803851:	8b 00                	mov    (%eax),%eax
  803853:	a3 38 51 80 00       	mov    %eax,0x805138
  803858:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80385b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803861:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803864:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80386b:	a1 44 51 80 00       	mov    0x805144,%eax
  803870:	48                   	dec    %eax
  803871:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803876:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803879:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803880:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803883:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80388a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80388e:	75 17                	jne    8038a7 <insert_sorted_with_merge_freeList+0x655>
  803890:	83 ec 04             	sub    $0x4,%esp
  803893:	68 98 45 80 00       	push   $0x804598
  803898:	68 6e 01 00 00       	push   $0x16e
  80389d:	68 bb 45 80 00       	push   $0x8045bb
  8038a2:	e8 4c d0 ff ff       	call   8008f3 <_panic>
  8038a7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8038ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038b0:	89 10                	mov    %edx,(%eax)
  8038b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038b5:	8b 00                	mov    (%eax),%eax
  8038b7:	85 c0                	test   %eax,%eax
  8038b9:	74 0d                	je     8038c8 <insert_sorted_with_merge_freeList+0x676>
  8038bb:	a1 48 51 80 00       	mov    0x805148,%eax
  8038c0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038c3:	89 50 04             	mov    %edx,0x4(%eax)
  8038c6:	eb 08                	jmp    8038d0 <insert_sorted_with_merge_freeList+0x67e>
  8038c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038cb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8038d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038d3:	a3 48 51 80 00       	mov    %eax,0x805148
  8038d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038db:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038e2:	a1 54 51 80 00       	mov    0x805154,%eax
  8038e7:	40                   	inc    %eax
  8038e8:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8038ed:	e9 a9 00 00 00       	jmp    80399b <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8038f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038f6:	74 06                	je     8038fe <insert_sorted_with_merge_freeList+0x6ac>
  8038f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038fc:	75 17                	jne    803915 <insert_sorted_with_merge_freeList+0x6c3>
  8038fe:	83 ec 04             	sub    $0x4,%esp
  803901:	68 30 46 80 00       	push   $0x804630
  803906:	68 73 01 00 00       	push   $0x173
  80390b:	68 bb 45 80 00       	push   $0x8045bb
  803910:	e8 de cf ff ff       	call   8008f3 <_panic>
  803915:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803918:	8b 10                	mov    (%eax),%edx
  80391a:	8b 45 08             	mov    0x8(%ebp),%eax
  80391d:	89 10                	mov    %edx,(%eax)
  80391f:	8b 45 08             	mov    0x8(%ebp),%eax
  803922:	8b 00                	mov    (%eax),%eax
  803924:	85 c0                	test   %eax,%eax
  803926:	74 0b                	je     803933 <insert_sorted_with_merge_freeList+0x6e1>
  803928:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80392b:	8b 00                	mov    (%eax),%eax
  80392d:	8b 55 08             	mov    0x8(%ebp),%edx
  803930:	89 50 04             	mov    %edx,0x4(%eax)
  803933:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803936:	8b 55 08             	mov    0x8(%ebp),%edx
  803939:	89 10                	mov    %edx,(%eax)
  80393b:	8b 45 08             	mov    0x8(%ebp),%eax
  80393e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803941:	89 50 04             	mov    %edx,0x4(%eax)
  803944:	8b 45 08             	mov    0x8(%ebp),%eax
  803947:	8b 00                	mov    (%eax),%eax
  803949:	85 c0                	test   %eax,%eax
  80394b:	75 08                	jne    803955 <insert_sorted_with_merge_freeList+0x703>
  80394d:	8b 45 08             	mov    0x8(%ebp),%eax
  803950:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803955:	a1 44 51 80 00       	mov    0x805144,%eax
  80395a:	40                   	inc    %eax
  80395b:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803960:	eb 39                	jmp    80399b <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803962:	a1 40 51 80 00       	mov    0x805140,%eax
  803967:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80396a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80396e:	74 07                	je     803977 <insert_sorted_with_merge_freeList+0x725>
  803970:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803973:	8b 00                	mov    (%eax),%eax
  803975:	eb 05                	jmp    80397c <insert_sorted_with_merge_freeList+0x72a>
  803977:	b8 00 00 00 00       	mov    $0x0,%eax
  80397c:	a3 40 51 80 00       	mov    %eax,0x805140
  803981:	a1 40 51 80 00       	mov    0x805140,%eax
  803986:	85 c0                	test   %eax,%eax
  803988:	0f 85 c7 fb ff ff    	jne    803555 <insert_sorted_with_merge_freeList+0x303>
  80398e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803992:	0f 85 bd fb ff ff    	jne    803555 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803998:	eb 01                	jmp    80399b <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80399a:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80399b:	90                   	nop
  80399c:	c9                   	leave  
  80399d:	c3                   	ret    
  80399e:	66 90                	xchg   %ax,%ax

008039a0 <__udivdi3>:
  8039a0:	55                   	push   %ebp
  8039a1:	57                   	push   %edi
  8039a2:	56                   	push   %esi
  8039a3:	53                   	push   %ebx
  8039a4:	83 ec 1c             	sub    $0x1c,%esp
  8039a7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8039ab:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8039af:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8039b3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8039b7:	89 ca                	mov    %ecx,%edx
  8039b9:	89 f8                	mov    %edi,%eax
  8039bb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8039bf:	85 f6                	test   %esi,%esi
  8039c1:	75 2d                	jne    8039f0 <__udivdi3+0x50>
  8039c3:	39 cf                	cmp    %ecx,%edi
  8039c5:	77 65                	ja     803a2c <__udivdi3+0x8c>
  8039c7:	89 fd                	mov    %edi,%ebp
  8039c9:	85 ff                	test   %edi,%edi
  8039cb:	75 0b                	jne    8039d8 <__udivdi3+0x38>
  8039cd:	b8 01 00 00 00       	mov    $0x1,%eax
  8039d2:	31 d2                	xor    %edx,%edx
  8039d4:	f7 f7                	div    %edi
  8039d6:	89 c5                	mov    %eax,%ebp
  8039d8:	31 d2                	xor    %edx,%edx
  8039da:	89 c8                	mov    %ecx,%eax
  8039dc:	f7 f5                	div    %ebp
  8039de:	89 c1                	mov    %eax,%ecx
  8039e0:	89 d8                	mov    %ebx,%eax
  8039e2:	f7 f5                	div    %ebp
  8039e4:	89 cf                	mov    %ecx,%edi
  8039e6:	89 fa                	mov    %edi,%edx
  8039e8:	83 c4 1c             	add    $0x1c,%esp
  8039eb:	5b                   	pop    %ebx
  8039ec:	5e                   	pop    %esi
  8039ed:	5f                   	pop    %edi
  8039ee:	5d                   	pop    %ebp
  8039ef:	c3                   	ret    
  8039f0:	39 ce                	cmp    %ecx,%esi
  8039f2:	77 28                	ja     803a1c <__udivdi3+0x7c>
  8039f4:	0f bd fe             	bsr    %esi,%edi
  8039f7:	83 f7 1f             	xor    $0x1f,%edi
  8039fa:	75 40                	jne    803a3c <__udivdi3+0x9c>
  8039fc:	39 ce                	cmp    %ecx,%esi
  8039fe:	72 0a                	jb     803a0a <__udivdi3+0x6a>
  803a00:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803a04:	0f 87 9e 00 00 00    	ja     803aa8 <__udivdi3+0x108>
  803a0a:	b8 01 00 00 00       	mov    $0x1,%eax
  803a0f:	89 fa                	mov    %edi,%edx
  803a11:	83 c4 1c             	add    $0x1c,%esp
  803a14:	5b                   	pop    %ebx
  803a15:	5e                   	pop    %esi
  803a16:	5f                   	pop    %edi
  803a17:	5d                   	pop    %ebp
  803a18:	c3                   	ret    
  803a19:	8d 76 00             	lea    0x0(%esi),%esi
  803a1c:	31 ff                	xor    %edi,%edi
  803a1e:	31 c0                	xor    %eax,%eax
  803a20:	89 fa                	mov    %edi,%edx
  803a22:	83 c4 1c             	add    $0x1c,%esp
  803a25:	5b                   	pop    %ebx
  803a26:	5e                   	pop    %esi
  803a27:	5f                   	pop    %edi
  803a28:	5d                   	pop    %ebp
  803a29:	c3                   	ret    
  803a2a:	66 90                	xchg   %ax,%ax
  803a2c:	89 d8                	mov    %ebx,%eax
  803a2e:	f7 f7                	div    %edi
  803a30:	31 ff                	xor    %edi,%edi
  803a32:	89 fa                	mov    %edi,%edx
  803a34:	83 c4 1c             	add    $0x1c,%esp
  803a37:	5b                   	pop    %ebx
  803a38:	5e                   	pop    %esi
  803a39:	5f                   	pop    %edi
  803a3a:	5d                   	pop    %ebp
  803a3b:	c3                   	ret    
  803a3c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803a41:	89 eb                	mov    %ebp,%ebx
  803a43:	29 fb                	sub    %edi,%ebx
  803a45:	89 f9                	mov    %edi,%ecx
  803a47:	d3 e6                	shl    %cl,%esi
  803a49:	89 c5                	mov    %eax,%ebp
  803a4b:	88 d9                	mov    %bl,%cl
  803a4d:	d3 ed                	shr    %cl,%ebp
  803a4f:	89 e9                	mov    %ebp,%ecx
  803a51:	09 f1                	or     %esi,%ecx
  803a53:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803a57:	89 f9                	mov    %edi,%ecx
  803a59:	d3 e0                	shl    %cl,%eax
  803a5b:	89 c5                	mov    %eax,%ebp
  803a5d:	89 d6                	mov    %edx,%esi
  803a5f:	88 d9                	mov    %bl,%cl
  803a61:	d3 ee                	shr    %cl,%esi
  803a63:	89 f9                	mov    %edi,%ecx
  803a65:	d3 e2                	shl    %cl,%edx
  803a67:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a6b:	88 d9                	mov    %bl,%cl
  803a6d:	d3 e8                	shr    %cl,%eax
  803a6f:	09 c2                	or     %eax,%edx
  803a71:	89 d0                	mov    %edx,%eax
  803a73:	89 f2                	mov    %esi,%edx
  803a75:	f7 74 24 0c          	divl   0xc(%esp)
  803a79:	89 d6                	mov    %edx,%esi
  803a7b:	89 c3                	mov    %eax,%ebx
  803a7d:	f7 e5                	mul    %ebp
  803a7f:	39 d6                	cmp    %edx,%esi
  803a81:	72 19                	jb     803a9c <__udivdi3+0xfc>
  803a83:	74 0b                	je     803a90 <__udivdi3+0xf0>
  803a85:	89 d8                	mov    %ebx,%eax
  803a87:	31 ff                	xor    %edi,%edi
  803a89:	e9 58 ff ff ff       	jmp    8039e6 <__udivdi3+0x46>
  803a8e:	66 90                	xchg   %ax,%ax
  803a90:	8b 54 24 08          	mov    0x8(%esp),%edx
  803a94:	89 f9                	mov    %edi,%ecx
  803a96:	d3 e2                	shl    %cl,%edx
  803a98:	39 c2                	cmp    %eax,%edx
  803a9a:	73 e9                	jae    803a85 <__udivdi3+0xe5>
  803a9c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803a9f:	31 ff                	xor    %edi,%edi
  803aa1:	e9 40 ff ff ff       	jmp    8039e6 <__udivdi3+0x46>
  803aa6:	66 90                	xchg   %ax,%ax
  803aa8:	31 c0                	xor    %eax,%eax
  803aaa:	e9 37 ff ff ff       	jmp    8039e6 <__udivdi3+0x46>
  803aaf:	90                   	nop

00803ab0 <__umoddi3>:
  803ab0:	55                   	push   %ebp
  803ab1:	57                   	push   %edi
  803ab2:	56                   	push   %esi
  803ab3:	53                   	push   %ebx
  803ab4:	83 ec 1c             	sub    $0x1c,%esp
  803ab7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803abb:	8b 74 24 34          	mov    0x34(%esp),%esi
  803abf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803ac3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803ac7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803acb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803acf:	89 f3                	mov    %esi,%ebx
  803ad1:	89 fa                	mov    %edi,%edx
  803ad3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ad7:	89 34 24             	mov    %esi,(%esp)
  803ada:	85 c0                	test   %eax,%eax
  803adc:	75 1a                	jne    803af8 <__umoddi3+0x48>
  803ade:	39 f7                	cmp    %esi,%edi
  803ae0:	0f 86 a2 00 00 00    	jbe    803b88 <__umoddi3+0xd8>
  803ae6:	89 c8                	mov    %ecx,%eax
  803ae8:	89 f2                	mov    %esi,%edx
  803aea:	f7 f7                	div    %edi
  803aec:	89 d0                	mov    %edx,%eax
  803aee:	31 d2                	xor    %edx,%edx
  803af0:	83 c4 1c             	add    $0x1c,%esp
  803af3:	5b                   	pop    %ebx
  803af4:	5e                   	pop    %esi
  803af5:	5f                   	pop    %edi
  803af6:	5d                   	pop    %ebp
  803af7:	c3                   	ret    
  803af8:	39 f0                	cmp    %esi,%eax
  803afa:	0f 87 ac 00 00 00    	ja     803bac <__umoddi3+0xfc>
  803b00:	0f bd e8             	bsr    %eax,%ebp
  803b03:	83 f5 1f             	xor    $0x1f,%ebp
  803b06:	0f 84 ac 00 00 00    	je     803bb8 <__umoddi3+0x108>
  803b0c:	bf 20 00 00 00       	mov    $0x20,%edi
  803b11:	29 ef                	sub    %ebp,%edi
  803b13:	89 fe                	mov    %edi,%esi
  803b15:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803b19:	89 e9                	mov    %ebp,%ecx
  803b1b:	d3 e0                	shl    %cl,%eax
  803b1d:	89 d7                	mov    %edx,%edi
  803b1f:	89 f1                	mov    %esi,%ecx
  803b21:	d3 ef                	shr    %cl,%edi
  803b23:	09 c7                	or     %eax,%edi
  803b25:	89 e9                	mov    %ebp,%ecx
  803b27:	d3 e2                	shl    %cl,%edx
  803b29:	89 14 24             	mov    %edx,(%esp)
  803b2c:	89 d8                	mov    %ebx,%eax
  803b2e:	d3 e0                	shl    %cl,%eax
  803b30:	89 c2                	mov    %eax,%edx
  803b32:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b36:	d3 e0                	shl    %cl,%eax
  803b38:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b3c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b40:	89 f1                	mov    %esi,%ecx
  803b42:	d3 e8                	shr    %cl,%eax
  803b44:	09 d0                	or     %edx,%eax
  803b46:	d3 eb                	shr    %cl,%ebx
  803b48:	89 da                	mov    %ebx,%edx
  803b4a:	f7 f7                	div    %edi
  803b4c:	89 d3                	mov    %edx,%ebx
  803b4e:	f7 24 24             	mull   (%esp)
  803b51:	89 c6                	mov    %eax,%esi
  803b53:	89 d1                	mov    %edx,%ecx
  803b55:	39 d3                	cmp    %edx,%ebx
  803b57:	0f 82 87 00 00 00    	jb     803be4 <__umoddi3+0x134>
  803b5d:	0f 84 91 00 00 00    	je     803bf4 <__umoddi3+0x144>
  803b63:	8b 54 24 04          	mov    0x4(%esp),%edx
  803b67:	29 f2                	sub    %esi,%edx
  803b69:	19 cb                	sbb    %ecx,%ebx
  803b6b:	89 d8                	mov    %ebx,%eax
  803b6d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803b71:	d3 e0                	shl    %cl,%eax
  803b73:	89 e9                	mov    %ebp,%ecx
  803b75:	d3 ea                	shr    %cl,%edx
  803b77:	09 d0                	or     %edx,%eax
  803b79:	89 e9                	mov    %ebp,%ecx
  803b7b:	d3 eb                	shr    %cl,%ebx
  803b7d:	89 da                	mov    %ebx,%edx
  803b7f:	83 c4 1c             	add    $0x1c,%esp
  803b82:	5b                   	pop    %ebx
  803b83:	5e                   	pop    %esi
  803b84:	5f                   	pop    %edi
  803b85:	5d                   	pop    %ebp
  803b86:	c3                   	ret    
  803b87:	90                   	nop
  803b88:	89 fd                	mov    %edi,%ebp
  803b8a:	85 ff                	test   %edi,%edi
  803b8c:	75 0b                	jne    803b99 <__umoddi3+0xe9>
  803b8e:	b8 01 00 00 00       	mov    $0x1,%eax
  803b93:	31 d2                	xor    %edx,%edx
  803b95:	f7 f7                	div    %edi
  803b97:	89 c5                	mov    %eax,%ebp
  803b99:	89 f0                	mov    %esi,%eax
  803b9b:	31 d2                	xor    %edx,%edx
  803b9d:	f7 f5                	div    %ebp
  803b9f:	89 c8                	mov    %ecx,%eax
  803ba1:	f7 f5                	div    %ebp
  803ba3:	89 d0                	mov    %edx,%eax
  803ba5:	e9 44 ff ff ff       	jmp    803aee <__umoddi3+0x3e>
  803baa:	66 90                	xchg   %ax,%ax
  803bac:	89 c8                	mov    %ecx,%eax
  803bae:	89 f2                	mov    %esi,%edx
  803bb0:	83 c4 1c             	add    $0x1c,%esp
  803bb3:	5b                   	pop    %ebx
  803bb4:	5e                   	pop    %esi
  803bb5:	5f                   	pop    %edi
  803bb6:	5d                   	pop    %ebp
  803bb7:	c3                   	ret    
  803bb8:	3b 04 24             	cmp    (%esp),%eax
  803bbb:	72 06                	jb     803bc3 <__umoddi3+0x113>
  803bbd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803bc1:	77 0f                	ja     803bd2 <__umoddi3+0x122>
  803bc3:	89 f2                	mov    %esi,%edx
  803bc5:	29 f9                	sub    %edi,%ecx
  803bc7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803bcb:	89 14 24             	mov    %edx,(%esp)
  803bce:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803bd2:	8b 44 24 04          	mov    0x4(%esp),%eax
  803bd6:	8b 14 24             	mov    (%esp),%edx
  803bd9:	83 c4 1c             	add    $0x1c,%esp
  803bdc:	5b                   	pop    %ebx
  803bdd:	5e                   	pop    %esi
  803bde:	5f                   	pop    %edi
  803bdf:	5d                   	pop    %ebp
  803be0:	c3                   	ret    
  803be1:	8d 76 00             	lea    0x0(%esi),%esi
  803be4:	2b 04 24             	sub    (%esp),%eax
  803be7:	19 fa                	sbb    %edi,%edx
  803be9:	89 d1                	mov    %edx,%ecx
  803beb:	89 c6                	mov    %eax,%esi
  803bed:	e9 71 ff ff ff       	jmp    803b63 <__umoddi3+0xb3>
  803bf2:	66 90                	xchg   %ax,%ax
  803bf4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803bf8:	72 ea                	jb     803be4 <__umoddi3+0x134>
  803bfa:	89 d9                	mov    %ebx,%ecx
  803bfc:	e9 62 ff ff ff       	jmp    803b63 <__umoddi3+0xb3>
