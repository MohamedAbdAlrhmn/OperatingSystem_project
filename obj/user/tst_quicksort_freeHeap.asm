
obj/user/tst_quicksort_freeHeap:     file format elf32-i386


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
  800031:	e8 20 08 00 00       	call   800856 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
uint32 CheckSorted(int *Elements, int NumOfElements);

int CheckAndCountEmptyLocInWS(volatile struct Env *myEnv);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	81 ec 34 01 00 00    	sub    $0x134,%esp


	//int InitFreeFrames = sys_calculate_free_frames() ;
	char Line[255] ;
	char Chose ;
	int Iteration = 0 ;
  800042:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	do
	{

		Iteration++ ;
  800049:	ff 45 f0             	incl   -0x10(%ebp)
		//		cprintf("Free Frames Before Allocation = %d\n", sys_calculate_free_frames()) ;

	sys_disable_interrupt();
  80004c:	e8 9b 1e 00 00       	call   801eec <sys_disable_interrupt>
		readline("Enter the number of elements: ", Line);
  800051:	83 ec 08             	sub    $0x8,%esp
  800054:	8d 85 c9 fe ff ff    	lea    -0x137(%ebp),%eax
  80005a:	50                   	push   %eax
  80005b:	68 e0 25 80 00       	push   $0x8025e0
  800060:	e8 63 12 00 00       	call   8012c8 <readline>
  800065:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  800068:	83 ec 04             	sub    $0x4,%esp
  80006b:	6a 0a                	push   $0xa
  80006d:	6a 00                	push   $0x0
  80006f:	8d 85 c9 fe ff ff    	lea    -0x137(%ebp),%eax
  800075:	50                   	push   %eax
  800076:	e8 b3 17 00 00       	call   80182e <strtol>
  80007b:	83 c4 10             	add    $0x10,%esp
  80007e:	89 45 ec             	mov    %eax,-0x14(%ebp)

		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  800081:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800084:	c1 e0 02             	shl    $0x2,%eax
  800087:	83 ec 0c             	sub    $0xc,%esp
  80008a:	50                   	push   %eax
  80008b:	e8 60 1b 00 00       	call   801bf0 <malloc>
  800090:	83 c4 10             	add    $0x10,%esp
  800093:	89 45 e8             	mov    %eax,-0x18(%ebp)

		int numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  800096:	a1 24 30 80 00       	mov    0x803024,%eax
  80009b:	83 ec 0c             	sub    $0xc,%esp
  80009e:	50                   	push   %eax
  80009f:	e8 7f 03 00 00       	call   800423 <CheckAndCountEmptyLocInWS>
  8000a4:	83 c4 10             	add    $0x10,%esp
  8000a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int InitFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS ;
  8000aa:	e8 50 1d 00 00       	call   801dff <sys_calculate_free_frames>
  8000af:	89 c3                	mov    %eax,%ebx
  8000b1:	e8 62 1d 00 00       	call   801e18 <sys_calculate_modified_frames>
  8000b6:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  8000b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000bc:	29 c2                	sub    %eax,%edx
  8000be:	89 d0                	mov    %edx,%eax
  8000c0:	89 45 e0             	mov    %eax,-0x20(%ebp)

		Elements[NumOfElements] = 10 ;
  8000c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000c6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000d0:	01 d0                	add    %edx,%eax
  8000d2:	c7 00 0a 00 00 00    	movl   $0xa,(%eax)
		//		cprintf("Free Frames After Allocation = %d\n", sys_calculate_free_frames()) ;
		cprintf("Choose the initialization method:\n") ;
  8000d8:	83 ec 0c             	sub    $0xc,%esp
  8000db:	68 00 26 80 00       	push   $0x802600
  8000e0:	e8 61 0b 00 00       	call   800c46 <cprintf>
  8000e5:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000e8:	83 ec 0c             	sub    $0xc,%esp
  8000eb:	68 23 26 80 00       	push   $0x802623
  8000f0:	e8 51 0b 00 00       	call   800c46 <cprintf>
  8000f5:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000f8:	83 ec 0c             	sub    $0xc,%esp
  8000fb:	68 31 26 80 00       	push   $0x802631
  800100:	e8 41 0b 00 00       	call   800c46 <cprintf>
  800105:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n") ;
  800108:	83 ec 0c             	sub    $0xc,%esp
  80010b:	68 40 26 80 00       	push   $0x802640
  800110:	e8 31 0b 00 00       	call   800c46 <cprintf>
  800115:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800118:	83 ec 0c             	sub    $0xc,%esp
  80011b:	68 50 26 80 00       	push   $0x802650
  800120:	e8 21 0b 00 00       	call   800c46 <cprintf>
  800125:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  800128:	e8 d1 06 00 00       	call   8007fe <getchar>
  80012d:	88 45 f7             	mov    %al,-0x9(%ebp)
			cputchar(Chose);
  800130:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800134:	83 ec 0c             	sub    $0xc,%esp
  800137:	50                   	push   %eax
  800138:	e8 79 06 00 00       	call   8007b6 <cputchar>
  80013d:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800140:	83 ec 0c             	sub    $0xc,%esp
  800143:	6a 0a                	push   $0xa
  800145:	e8 6c 06 00 00       	call   8007b6 <cputchar>
  80014a:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  80014d:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  800151:	74 0c                	je     80015f <_main+0x127>
  800153:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  800157:	74 06                	je     80015f <_main+0x127>
  800159:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  80015d:	75 b9                	jne    800118 <_main+0xe0>
	sys_enable_interrupt();
  80015f:	e8 a2 1d 00 00       	call   801f06 <sys_enable_interrupt>
		int  i ;
		switch (Chose)
  800164:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800168:	83 f8 62             	cmp    $0x62,%eax
  80016b:	74 1d                	je     80018a <_main+0x152>
  80016d:	83 f8 63             	cmp    $0x63,%eax
  800170:	74 2b                	je     80019d <_main+0x165>
  800172:	83 f8 61             	cmp    $0x61,%eax
  800175:	75 39                	jne    8001b0 <_main+0x178>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  800177:	83 ec 08             	sub    $0x8,%esp
  80017a:	ff 75 ec             	pushl  -0x14(%ebp)
  80017d:	ff 75 e8             	pushl  -0x18(%ebp)
  800180:	e8 f9 04 00 00       	call   80067e <InitializeAscending>
  800185:	83 c4 10             	add    $0x10,%esp
			break ;
  800188:	eb 37                	jmp    8001c1 <_main+0x189>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018a:	83 ec 08             	sub    $0x8,%esp
  80018d:	ff 75 ec             	pushl  -0x14(%ebp)
  800190:	ff 75 e8             	pushl  -0x18(%ebp)
  800193:	e8 17 05 00 00       	call   8006af <InitializeDescending>
  800198:	83 c4 10             	add    $0x10,%esp
			break ;
  80019b:	eb 24                	jmp    8001c1 <_main+0x189>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  80019d:	83 ec 08             	sub    $0x8,%esp
  8001a0:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a3:	ff 75 e8             	pushl  -0x18(%ebp)
  8001a6:	e8 39 05 00 00       	call   8006e4 <InitializeSemiRandom>
  8001ab:	83 c4 10             	add    $0x10,%esp
			break ;
  8001ae:	eb 11                	jmp    8001c1 <_main+0x189>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b0:	83 ec 08             	sub    $0x8,%esp
  8001b3:	ff 75 ec             	pushl  -0x14(%ebp)
  8001b6:	ff 75 e8             	pushl  -0x18(%ebp)
  8001b9:	e8 26 05 00 00       	call   8006e4 <InitializeSemiRandom>
  8001be:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  8001c1:	83 ec 08             	sub    $0x8,%esp
  8001c4:	ff 75 ec             	pushl  -0x14(%ebp)
  8001c7:	ff 75 e8             	pushl  -0x18(%ebp)
  8001ca:	e8 f4 02 00 00       	call   8004c3 <QuickSort>
  8001cf:	83 c4 10             	add    $0x10,%esp

		//		PrintElements(Elements, NumOfElements);

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001d2:	83 ec 08             	sub    $0x8,%esp
  8001d5:	ff 75 ec             	pushl  -0x14(%ebp)
  8001d8:	ff 75 e8             	pushl  -0x18(%ebp)
  8001db:	e8 f4 03 00 00       	call   8005d4 <CheckSorted>
  8001e0:	83 c4 10             	add    $0x10,%esp
  8001e3:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001e6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8001ea:	75 14                	jne    800200 <_main+0x1c8>
  8001ec:	83 ec 04             	sub    $0x4,%esp
  8001ef:	68 5c 26 80 00       	push   $0x80265c
  8001f4:	6a 57                	push   $0x57
  8001f6:	68 7e 26 80 00       	push   $0x80267e
  8001fb:	e8 92 07 00 00       	call   800992 <_panic>
		else
		{
			cprintf("===============================================\n") ;
  800200:	83 ec 0c             	sub    $0xc,%esp
  800203:	68 9c 26 80 00       	push   $0x80269c
  800208:	e8 39 0a 00 00       	call   800c46 <cprintf>
  80020d:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800210:	83 ec 0c             	sub    $0xc,%esp
  800213:	68 d0 26 80 00       	push   $0x8026d0
  800218:	e8 29 0a 00 00       	call   800c46 <cprintf>
  80021d:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800220:	83 ec 0c             	sub    $0xc,%esp
  800223:	68 04 27 80 00       	push   $0x802704
  800228:	e8 19 0a 00 00       	call   800c46 <cprintf>
  80022d:	83 c4 10             	add    $0x10,%esp
		}

		//		cprintf("Free Frames After Calculation = %d\n", sys_calculate_free_frames()) ;

		cprintf("Freeing the Heap...\n\n") ;
  800230:	83 ec 0c             	sub    $0xc,%esp
  800233:	68 36 27 80 00       	push   $0x802736
  800238:	e8 09 0a 00 00       	call   800c46 <cprintf>
  80023d:	83 c4 10             	add    $0x10,%esp
		free(Elements) ;
  800240:	83 ec 0c             	sub    $0xc,%esp
  800243:	ff 75 e8             	pushl  -0x18(%ebp)
  800246:	e8 e6 19 00 00       	call   801c31 <free>
  80024b:	83 c4 10             	add    $0x10,%esp


		///Testing the freeHeap according to the specified scenario
		if (Iteration == 1)
  80024e:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  800252:	75 72                	jne    8002c6 <_main+0x28e>
		{
			if (!(NumOfElements == 1000 && Chose == 'a'))
  800254:	81 7d ec e8 03 00 00 	cmpl   $0x3e8,-0x14(%ebp)
  80025b:	75 06                	jne    800263 <_main+0x22b>
  80025d:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  800261:	74 14                	je     800277 <_main+0x23f>
				panic("Please ensure the number of elements and the initialization method of this test");
  800263:	83 ec 04             	sub    $0x4,%esp
  800266:	68 4c 27 80 00       	push   $0x80274c
  80026b:	6a 69                	push   $0x69
  80026d:	68 7e 26 80 00       	push   $0x80267e
  800272:	e8 1b 07 00 00       	call   800992 <_panic>

			numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  800277:	a1 24 30 80 00       	mov    0x803024,%eax
  80027c:	83 ec 0c             	sub    $0xc,%esp
  80027f:	50                   	push   %eax
  800280:	e8 9e 01 00 00       	call   800423 <CheckAndCountEmptyLocInWS>
  800285:	83 c4 10             	add    $0x10,%esp
  800288:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			int CurrFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  80028b:	e8 6f 1b 00 00       	call   801dff <sys_calculate_free_frames>
  800290:	89 c3                	mov    %eax,%ebx
  800292:	e8 81 1b 00 00       	call   801e18 <sys_calculate_modified_frames>
  800297:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  80029a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80029d:	29 c2                	sub    %eax,%edx
  80029f:	89 d0                	mov    %edx,%eax
  8002a1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
  8002a4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002a7:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002aa:	0f 84 05 01 00 00    	je     8003b5 <_main+0x37d>
  8002b0:	68 9c 27 80 00       	push   $0x80279c
  8002b5:	68 c1 27 80 00       	push   $0x8027c1
  8002ba:	6a 6d                	push   $0x6d
  8002bc:	68 7e 26 80 00       	push   $0x80267e
  8002c1:	e8 cc 06 00 00       	call   800992 <_panic>
		}
		else if (Iteration == 2 )
  8002c6:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  8002ca:	75 72                	jne    80033e <_main+0x306>
		{
			if (!(NumOfElements == 5000 && Chose == 'b'))
  8002cc:	81 7d ec 88 13 00 00 	cmpl   $0x1388,-0x14(%ebp)
  8002d3:	75 06                	jne    8002db <_main+0x2a3>
  8002d5:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  8002d9:	74 14                	je     8002ef <_main+0x2b7>
				panic("Please ensure the number of elements and the initialization method of this test");
  8002db:	83 ec 04             	sub    $0x4,%esp
  8002de:	68 4c 27 80 00       	push   $0x80274c
  8002e3:	6a 72                	push   $0x72
  8002e5:	68 7e 26 80 00       	push   $0x80267e
  8002ea:	e8 a3 06 00 00       	call   800992 <_panic>

			int numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  8002ef:	a1 24 30 80 00       	mov    0x803024,%eax
  8002f4:	83 ec 0c             	sub    $0xc,%esp
  8002f7:	50                   	push   %eax
  8002f8:	e8 26 01 00 00       	call   800423 <CheckAndCountEmptyLocInWS>
  8002fd:	83 c4 10             	add    $0x10,%esp
  800300:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			int CurrFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  800303:	e8 f7 1a 00 00       	call   801dff <sys_calculate_free_frames>
  800308:	89 c3                	mov    %eax,%ebx
  80030a:	e8 09 1b 00 00       	call   801e18 <sys_calculate_modified_frames>
  80030f:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  800312:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800315:	29 c2                	sub    %eax,%edx
  800317:	89 d0                	mov    %edx,%eax
  800319:	89 45 d0             	mov    %eax,-0x30(%ebp)
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
  80031c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80031f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800322:	0f 84 8d 00 00 00    	je     8003b5 <_main+0x37d>
  800328:	68 9c 27 80 00       	push   $0x80279c
  80032d:	68 c1 27 80 00       	push   $0x8027c1
  800332:	6a 76                	push   $0x76
  800334:	68 7e 26 80 00       	push   $0x80267e
  800339:	e8 54 06 00 00       	call   800992 <_panic>
		}
		else if (Iteration == 3 )
  80033e:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
  800342:	75 71                	jne    8003b5 <_main+0x37d>
		{
			if (!(NumOfElements == 300000 && Chose == 'c'))
  800344:	81 7d ec e0 93 04 00 	cmpl   $0x493e0,-0x14(%ebp)
  80034b:	75 06                	jne    800353 <_main+0x31b>
  80034d:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800351:	74 14                	je     800367 <_main+0x32f>
				panic("Please ensure the number of elements and the initialization method of this test");
  800353:	83 ec 04             	sub    $0x4,%esp
  800356:	68 4c 27 80 00       	push   $0x80274c
  80035b:	6a 7b                	push   $0x7b
  80035d:	68 7e 26 80 00       	push   $0x80267e
  800362:	e8 2b 06 00 00       	call   800992 <_panic>

			int numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  800367:	a1 24 30 80 00       	mov    0x803024,%eax
  80036c:	83 ec 0c             	sub    $0xc,%esp
  80036f:	50                   	push   %eax
  800370:	e8 ae 00 00 00       	call   800423 <CheckAndCountEmptyLocInWS>
  800375:	83 c4 10             	add    $0x10,%esp
  800378:	89 45 cc             	mov    %eax,-0x34(%ebp)
			int CurrFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  80037b:	e8 7f 1a 00 00       	call   801dff <sys_calculate_free_frames>
  800380:	89 c3                	mov    %eax,%ebx
  800382:	e8 91 1a 00 00       	call   801e18 <sys_calculate_modified_frames>
  800387:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  80038a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80038d:	29 c2                	sub    %eax,%edx
  80038f:	89 d0                	mov    %edx,%eax
  800391:	89 45 c8             	mov    %eax,-0x38(%ebp)
			//cprintf("numOFEmptyLocInWS = %d\n", numOFEmptyLocInWS );
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
  800394:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800397:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80039a:	74 19                	je     8003b5 <_main+0x37d>
  80039c:	68 9c 27 80 00       	push   $0x80279c
  8003a1:	68 c1 27 80 00       	push   $0x8027c1
  8003a6:	68 80 00 00 00       	push   $0x80
  8003ab:	68 7e 26 80 00       	push   $0x80267e
  8003b0:	e8 dd 05 00 00       	call   800992 <_panic>
		}
		///========================================================================
	sys_disable_interrupt();
  8003b5:	e8 32 1b 00 00       	call   801eec <sys_disable_interrupt>
		Chose = 0 ;
  8003ba:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
		while (Chose != 'y' && Chose != 'n')
  8003be:	eb 42                	jmp    800402 <_main+0x3ca>
		{
			cprintf("Do you want to repeat (y/n): ") ;
  8003c0:	83 ec 0c             	sub    $0xc,%esp
  8003c3:	68 d6 27 80 00       	push   $0x8027d6
  8003c8:	e8 79 08 00 00       	call   800c46 <cprintf>
  8003cd:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  8003d0:	e8 29 04 00 00       	call   8007fe <getchar>
  8003d5:	88 45 f7             	mov    %al,-0x9(%ebp)
			cputchar(Chose);
  8003d8:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8003dc:	83 ec 0c             	sub    $0xc,%esp
  8003df:	50                   	push   %eax
  8003e0:	e8 d1 03 00 00       	call   8007b6 <cputchar>
  8003e5:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8003e8:	83 ec 0c             	sub    $0xc,%esp
  8003eb:	6a 0a                	push   $0xa
  8003ed:	e8 c4 03 00 00       	call   8007b6 <cputchar>
  8003f2:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8003f5:	83 ec 0c             	sub    $0xc,%esp
  8003f8:	6a 0a                	push   $0xa
  8003fa:	e8 b7 03 00 00       	call   8007b6 <cputchar>
  8003ff:	83 c4 10             	add    $0x10,%esp
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
		}
		///========================================================================
	sys_disable_interrupt();
		Chose = 0 ;
		while (Chose != 'y' && Chose != 'n')
  800402:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  800406:	74 06                	je     80040e <_main+0x3d6>
  800408:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  80040c:	75 b2                	jne    8003c0 <_main+0x388>
			Chose = getchar() ;
			cputchar(Chose);
			cputchar('\n');
			cputchar('\n');
		}
	sys_enable_interrupt();
  80040e:	e8 f3 1a 00 00       	call   801f06 <sys_enable_interrupt>

	} while (Chose == 'y');
  800413:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  800417:	0f 84 2c fc ff ff    	je     800049 <_main+0x11>
}
  80041d:	90                   	nop
  80041e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800421:	c9                   	leave  
  800422:	c3                   	ret    

00800423 <CheckAndCountEmptyLocInWS>:

int CheckAndCountEmptyLocInWS(volatile struct Env *myEnv)
{
  800423:	55                   	push   %ebp
  800424:	89 e5                	mov    %esp,%ebp
  800426:	83 ec 18             	sub    $0x18,%esp
	int numOFEmptyLocInWS = 0, i;
  800429:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (i = 0 ; i < myEnv->page_WS_max_size; i++)
  800430:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800437:	eb 74                	jmp    8004ad <CheckAndCountEmptyLocInWS+0x8a>
	{
		if (myEnv->__uptr_pws[i].empty)
  800439:	8b 45 08             	mov    0x8(%ebp),%eax
  80043c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800442:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800445:	89 d0                	mov    %edx,%eax
  800447:	01 c0                	add    %eax,%eax
  800449:	01 d0                	add    %edx,%eax
  80044b:	c1 e0 03             	shl    $0x3,%eax
  80044e:	01 c8                	add    %ecx,%eax
  800450:	8a 40 04             	mov    0x4(%eax),%al
  800453:	84 c0                	test   %al,%al
  800455:	74 05                	je     80045c <CheckAndCountEmptyLocInWS+0x39>
		{
			numOFEmptyLocInWS++;
  800457:	ff 45 f4             	incl   -0xc(%ebp)
  80045a:	eb 4e                	jmp    8004aa <CheckAndCountEmptyLocInWS+0x87>
		}
		else
		{
			uint32 va = ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) ;
  80045c:	8b 45 08             	mov    0x8(%ebp),%eax
  80045f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800465:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800468:	89 d0                	mov    %edx,%eax
  80046a:	01 c0                	add    %eax,%eax
  80046c:	01 d0                	add    %edx,%eax
  80046e:	c1 e0 03             	shl    $0x3,%eax
  800471:	01 c8                	add    %ecx,%eax
  800473:	8b 00                	mov    (%eax),%eax
  800475:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800478:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80047b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800480:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (va >= USER_HEAP_START && va < (USER_HEAP_MAX))
  800483:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800486:	85 c0                	test   %eax,%eax
  800488:	79 20                	jns    8004aa <CheckAndCountEmptyLocInWS+0x87>
  80048a:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  800491:	77 17                	ja     8004aa <CheckAndCountEmptyLocInWS+0x87>
				panic("freeMem didn't remove its page(s) from the WS");
  800493:	83 ec 04             	sub    $0x4,%esp
  800496:	68 f4 27 80 00       	push   $0x8027f4
  80049b:	68 9f 00 00 00       	push   $0x9f
  8004a0:	68 7e 26 80 00       	push   $0x80267e
  8004a5:	e8 e8 04 00 00       	call   800992 <_panic>
}

int CheckAndCountEmptyLocInWS(volatile struct Env *myEnv)
{
	int numOFEmptyLocInWS = 0, i;
	for (i = 0 ; i < myEnv->page_WS_max_size; i++)
  8004aa:	ff 45 f0             	incl   -0x10(%ebp)
  8004ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b0:	8b 50 74             	mov    0x74(%eax),%edx
  8004b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004b6:	39 c2                	cmp    %eax,%edx
  8004b8:	0f 87 7b ff ff ff    	ja     800439 <CheckAndCountEmptyLocInWS+0x16>
			uint32 va = ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) ;
			if (va >= USER_HEAP_START && va < (USER_HEAP_MAX))
				panic("freeMem didn't remove its page(s) from the WS");
		}
	}
	return numOFEmptyLocInWS;
  8004be:	8b 45 f4             	mov    -0xc(%ebp),%eax

}
  8004c1:	c9                   	leave  
  8004c2:	c3                   	ret    

008004c3 <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  8004c3:	55                   	push   %ebp
  8004c4:	89 e5                	mov    %esp,%ebp
  8004c6:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  8004c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004cc:	48                   	dec    %eax
  8004cd:	50                   	push   %eax
  8004ce:	6a 00                	push   $0x0
  8004d0:	ff 75 0c             	pushl  0xc(%ebp)
  8004d3:	ff 75 08             	pushl  0x8(%ebp)
  8004d6:	e8 06 00 00 00       	call   8004e1 <QSort>
  8004db:	83 c4 10             	add    $0x10,%esp
}
  8004de:	90                   	nop
  8004df:	c9                   	leave  
  8004e0:	c3                   	ret    

008004e1 <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  8004e1:	55                   	push   %ebp
  8004e2:	89 e5                	mov    %esp,%ebp
  8004e4:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  8004e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ea:	3b 45 14             	cmp    0x14(%ebp),%eax
  8004ed:	0f 8d de 00 00 00    	jge    8005d1 <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  8004f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8004f6:	40                   	inc    %eax
  8004f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8004fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fd:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  800500:	e9 80 00 00 00       	jmp    800585 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800505:	ff 45 f4             	incl   -0xc(%ebp)
  800508:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80050b:	3b 45 14             	cmp    0x14(%ebp),%eax
  80050e:	7f 2b                	jg     80053b <QSort+0x5a>
  800510:	8b 45 10             	mov    0x10(%ebp),%eax
  800513:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80051a:	8b 45 08             	mov    0x8(%ebp),%eax
  80051d:	01 d0                	add    %edx,%eax
  80051f:	8b 10                	mov    (%eax),%edx
  800521:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800524:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80052b:	8b 45 08             	mov    0x8(%ebp),%eax
  80052e:	01 c8                	add    %ecx,%eax
  800530:	8b 00                	mov    (%eax),%eax
  800532:	39 c2                	cmp    %eax,%edx
  800534:	7d cf                	jge    800505 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  800536:	eb 03                	jmp    80053b <QSort+0x5a>
  800538:	ff 4d f0             	decl   -0x10(%ebp)
  80053b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80053e:	3b 45 10             	cmp    0x10(%ebp),%eax
  800541:	7e 26                	jle    800569 <QSort+0x88>
  800543:	8b 45 10             	mov    0x10(%ebp),%eax
  800546:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80054d:	8b 45 08             	mov    0x8(%ebp),%eax
  800550:	01 d0                	add    %edx,%eax
  800552:	8b 10                	mov    (%eax),%edx
  800554:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800557:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80055e:	8b 45 08             	mov    0x8(%ebp),%eax
  800561:	01 c8                	add    %ecx,%eax
  800563:	8b 00                	mov    (%eax),%eax
  800565:	39 c2                	cmp    %eax,%edx
  800567:	7e cf                	jle    800538 <QSort+0x57>

		if (i <= j)
  800569:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80056c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80056f:	7f 14                	jg     800585 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  800571:	83 ec 04             	sub    $0x4,%esp
  800574:	ff 75 f0             	pushl  -0x10(%ebp)
  800577:	ff 75 f4             	pushl  -0xc(%ebp)
  80057a:	ff 75 08             	pushl  0x8(%ebp)
  80057d:	e8 a9 00 00 00       	call   80062b <Swap>
  800582:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800585:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800588:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80058b:	0f 8e 77 ff ff ff    	jle    800508 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  800591:	83 ec 04             	sub    $0x4,%esp
  800594:	ff 75 f0             	pushl  -0x10(%ebp)
  800597:	ff 75 10             	pushl  0x10(%ebp)
  80059a:	ff 75 08             	pushl  0x8(%ebp)
  80059d:	e8 89 00 00 00       	call   80062b <Swap>
  8005a2:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  8005a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005a8:	48                   	dec    %eax
  8005a9:	50                   	push   %eax
  8005aa:	ff 75 10             	pushl  0x10(%ebp)
  8005ad:	ff 75 0c             	pushl  0xc(%ebp)
  8005b0:	ff 75 08             	pushl  0x8(%ebp)
  8005b3:	e8 29 ff ff ff       	call   8004e1 <QSort>
  8005b8:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  8005bb:	ff 75 14             	pushl  0x14(%ebp)
  8005be:	ff 75 f4             	pushl  -0xc(%ebp)
  8005c1:	ff 75 0c             	pushl  0xc(%ebp)
  8005c4:	ff 75 08             	pushl  0x8(%ebp)
  8005c7:	e8 15 ff ff ff       	call   8004e1 <QSort>
  8005cc:	83 c4 10             	add    $0x10,%esp
  8005cf:	eb 01                	jmp    8005d2 <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  8005d1:	90                   	nop

	Swap( Elements, startIndex, j);

	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);
}
  8005d2:	c9                   	leave  
  8005d3:	c3                   	ret    

008005d4 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8005d4:	55                   	push   %ebp
  8005d5:	89 e5                	mov    %esp,%ebp
  8005d7:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8005da:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8005e1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8005e8:	eb 33                	jmp    80061d <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8005ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8005ed:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f7:	01 d0                	add    %edx,%eax
  8005f9:	8b 10                	mov    (%eax),%edx
  8005fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8005fe:	40                   	inc    %eax
  8005ff:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800606:	8b 45 08             	mov    0x8(%ebp),%eax
  800609:	01 c8                	add    %ecx,%eax
  80060b:	8b 00                	mov    (%eax),%eax
  80060d:	39 c2                	cmp    %eax,%edx
  80060f:	7e 09                	jle    80061a <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800611:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800618:	eb 0c                	jmp    800626 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80061a:	ff 45 f8             	incl   -0x8(%ebp)
  80061d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800620:	48                   	dec    %eax
  800621:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800624:	7f c4                	jg     8005ea <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800626:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800629:	c9                   	leave  
  80062a:	c3                   	ret    

0080062b <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80062b:	55                   	push   %ebp
  80062c:	89 e5                	mov    %esp,%ebp
  80062e:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800631:	8b 45 0c             	mov    0xc(%ebp),%eax
  800634:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80063b:	8b 45 08             	mov    0x8(%ebp),%eax
  80063e:	01 d0                	add    %edx,%eax
  800640:	8b 00                	mov    (%eax),%eax
  800642:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800645:	8b 45 0c             	mov    0xc(%ebp),%eax
  800648:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80064f:	8b 45 08             	mov    0x8(%ebp),%eax
  800652:	01 c2                	add    %eax,%edx
  800654:	8b 45 10             	mov    0x10(%ebp),%eax
  800657:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80065e:	8b 45 08             	mov    0x8(%ebp),%eax
  800661:	01 c8                	add    %ecx,%eax
  800663:	8b 00                	mov    (%eax),%eax
  800665:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800667:	8b 45 10             	mov    0x10(%ebp),%eax
  80066a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800671:	8b 45 08             	mov    0x8(%ebp),%eax
  800674:	01 c2                	add    %eax,%edx
  800676:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800679:	89 02                	mov    %eax,(%edx)
}
  80067b:	90                   	nop
  80067c:	c9                   	leave  
  80067d:	c3                   	ret    

0080067e <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80067e:	55                   	push   %ebp
  80067f:	89 e5                	mov    %esp,%ebp
  800681:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800684:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80068b:	eb 17                	jmp    8006a4 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80068d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800690:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800697:	8b 45 08             	mov    0x8(%ebp),%eax
  80069a:	01 c2                	add    %eax,%edx
  80069c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80069f:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8006a1:	ff 45 fc             	incl   -0x4(%ebp)
  8006a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006a7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006aa:	7c e1                	jl     80068d <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8006ac:	90                   	nop
  8006ad:	c9                   	leave  
  8006ae:	c3                   	ret    

008006af <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8006af:	55                   	push   %ebp
  8006b0:	89 e5                	mov    %esp,%ebp
  8006b2:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8006b5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8006bc:	eb 1b                	jmp    8006d9 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8006be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006c1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cb:	01 c2                	add    %eax,%edx
  8006cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d0:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8006d3:	48                   	dec    %eax
  8006d4:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8006d6:	ff 45 fc             	incl   -0x4(%ebp)
  8006d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006dc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006df:	7c dd                	jl     8006be <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8006e1:	90                   	nop
  8006e2:	c9                   	leave  
  8006e3:	c3                   	ret    

008006e4 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8006e4:	55                   	push   %ebp
  8006e5:	89 e5                	mov    %esp,%ebp
  8006e7:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8006ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006ed:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8006f2:	f7 e9                	imul   %ecx
  8006f4:	c1 f9 1f             	sar    $0x1f,%ecx
  8006f7:	89 d0                	mov    %edx,%eax
  8006f9:	29 c8                	sub    %ecx,%eax
  8006fb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8006fe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800705:	eb 1e                	jmp    800725 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  800707:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80070a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800711:	8b 45 08             	mov    0x8(%ebp),%eax
  800714:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800717:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80071a:	99                   	cltd   
  80071b:	f7 7d f8             	idivl  -0x8(%ebp)
  80071e:	89 d0                	mov    %edx,%eax
  800720:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800722:	ff 45 fc             	incl   -0x4(%ebp)
  800725:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800728:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80072b:	7c da                	jl     800707 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
	}

}
  80072d:	90                   	nop
  80072e:	c9                   	leave  
  80072f:	c3                   	ret    

00800730 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800730:	55                   	push   %ebp
  800731:	89 e5                	mov    %esp,%ebp
  800733:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800736:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80073d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800744:	eb 42                	jmp    800788 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800746:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800749:	99                   	cltd   
  80074a:	f7 7d f0             	idivl  -0x10(%ebp)
  80074d:	89 d0                	mov    %edx,%eax
  80074f:	85 c0                	test   %eax,%eax
  800751:	75 10                	jne    800763 <PrintElements+0x33>
			cprintf("\n");
  800753:	83 ec 0c             	sub    $0xc,%esp
  800756:	68 22 28 80 00       	push   $0x802822
  80075b:	e8 e6 04 00 00       	call   800c46 <cprintf>
  800760:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800763:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800766:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80076d:	8b 45 08             	mov    0x8(%ebp),%eax
  800770:	01 d0                	add    %edx,%eax
  800772:	8b 00                	mov    (%eax),%eax
  800774:	83 ec 08             	sub    $0x8,%esp
  800777:	50                   	push   %eax
  800778:	68 24 28 80 00       	push   $0x802824
  80077d:	e8 c4 04 00 00       	call   800c46 <cprintf>
  800782:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800785:	ff 45 f4             	incl   -0xc(%ebp)
  800788:	8b 45 0c             	mov    0xc(%ebp),%eax
  80078b:	48                   	dec    %eax
  80078c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80078f:	7f b5                	jg     800746 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800791:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800794:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80079b:	8b 45 08             	mov    0x8(%ebp),%eax
  80079e:	01 d0                	add    %edx,%eax
  8007a0:	8b 00                	mov    (%eax),%eax
  8007a2:	83 ec 08             	sub    $0x8,%esp
  8007a5:	50                   	push   %eax
  8007a6:	68 29 28 80 00       	push   $0x802829
  8007ab:	e8 96 04 00 00       	call   800c46 <cprintf>
  8007b0:	83 c4 10             	add    $0x10,%esp

}
  8007b3:	90                   	nop
  8007b4:	c9                   	leave  
  8007b5:	c3                   	ret    

008007b6 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8007b6:	55                   	push   %ebp
  8007b7:	89 e5                	mov    %esp,%ebp
  8007b9:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8007bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bf:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8007c2:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8007c6:	83 ec 0c             	sub    $0xc,%esp
  8007c9:	50                   	push   %eax
  8007ca:	e8 51 17 00 00       	call   801f20 <sys_cputc>
  8007cf:	83 c4 10             	add    $0x10,%esp
}
  8007d2:	90                   	nop
  8007d3:	c9                   	leave  
  8007d4:	c3                   	ret    

008007d5 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8007d5:	55                   	push   %ebp
  8007d6:	89 e5                	mov    %esp,%ebp
  8007d8:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007db:	e8 0c 17 00 00       	call   801eec <sys_disable_interrupt>
	char c = ch;
  8007e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e3:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8007e6:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8007ea:	83 ec 0c             	sub    $0xc,%esp
  8007ed:	50                   	push   %eax
  8007ee:	e8 2d 17 00 00       	call   801f20 <sys_cputc>
  8007f3:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8007f6:	e8 0b 17 00 00       	call   801f06 <sys_enable_interrupt>
}
  8007fb:	90                   	nop
  8007fc:	c9                   	leave  
  8007fd:	c3                   	ret    

008007fe <getchar>:

int
getchar(void)
{
  8007fe:	55                   	push   %ebp
  8007ff:	89 e5                	mov    %esp,%ebp
  800801:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800804:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80080b:	eb 08                	jmp    800815 <getchar+0x17>
	{
		c = sys_cgetc();
  80080d:	e8 55 15 00 00       	call   801d67 <sys_cgetc>
  800812:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800815:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800819:	74 f2                	je     80080d <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  80081b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80081e:	c9                   	leave  
  80081f:	c3                   	ret    

00800820 <atomic_getchar>:

int
atomic_getchar(void)
{
  800820:	55                   	push   %ebp
  800821:	89 e5                	mov    %esp,%ebp
  800823:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800826:	e8 c1 16 00 00       	call   801eec <sys_disable_interrupt>
	int c=0;
  80082b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800832:	eb 08                	jmp    80083c <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800834:	e8 2e 15 00 00       	call   801d67 <sys_cgetc>
  800839:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  80083c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800840:	74 f2                	je     800834 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  800842:	e8 bf 16 00 00       	call   801f06 <sys_enable_interrupt>
	return c;
  800847:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80084a:	c9                   	leave  
  80084b:	c3                   	ret    

0080084c <iscons>:

int iscons(int fdnum)
{
  80084c:	55                   	push   %ebp
  80084d:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80084f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800854:	5d                   	pop    %ebp
  800855:	c3                   	ret    

00800856 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800856:	55                   	push   %ebp
  800857:	89 e5                	mov    %esp,%ebp
  800859:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80085c:	e8 7e 18 00 00       	call   8020df <sys_getenvindex>
  800861:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800864:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800867:	89 d0                	mov    %edx,%eax
  800869:	c1 e0 03             	shl    $0x3,%eax
  80086c:	01 d0                	add    %edx,%eax
  80086e:	01 c0                	add    %eax,%eax
  800870:	01 d0                	add    %edx,%eax
  800872:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800879:	01 d0                	add    %edx,%eax
  80087b:	c1 e0 04             	shl    $0x4,%eax
  80087e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800883:	a3 24 30 80 00       	mov    %eax,0x803024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800888:	a1 24 30 80 00       	mov    0x803024,%eax
  80088d:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800893:	84 c0                	test   %al,%al
  800895:	74 0f                	je     8008a6 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800897:	a1 24 30 80 00       	mov    0x803024,%eax
  80089c:	05 5c 05 00 00       	add    $0x55c,%eax
  8008a1:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8008a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8008aa:	7e 0a                	jle    8008b6 <libmain+0x60>
		binaryname = argv[0];
  8008ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008af:	8b 00                	mov    (%eax),%eax
  8008b1:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8008b6:	83 ec 08             	sub    $0x8,%esp
  8008b9:	ff 75 0c             	pushl  0xc(%ebp)
  8008bc:	ff 75 08             	pushl  0x8(%ebp)
  8008bf:	e8 74 f7 ff ff       	call   800038 <_main>
  8008c4:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8008c7:	e8 20 16 00 00       	call   801eec <sys_disable_interrupt>
	cprintf("**************************************\n");
  8008cc:	83 ec 0c             	sub    $0xc,%esp
  8008cf:	68 48 28 80 00       	push   $0x802848
  8008d4:	e8 6d 03 00 00       	call   800c46 <cprintf>
  8008d9:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8008dc:	a1 24 30 80 00       	mov    0x803024,%eax
  8008e1:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8008e7:	a1 24 30 80 00       	mov    0x803024,%eax
  8008ec:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8008f2:	83 ec 04             	sub    $0x4,%esp
  8008f5:	52                   	push   %edx
  8008f6:	50                   	push   %eax
  8008f7:	68 70 28 80 00       	push   $0x802870
  8008fc:	e8 45 03 00 00       	call   800c46 <cprintf>
  800901:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800904:	a1 24 30 80 00       	mov    0x803024,%eax
  800909:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80090f:	a1 24 30 80 00       	mov    0x803024,%eax
  800914:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80091a:	a1 24 30 80 00       	mov    0x803024,%eax
  80091f:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800925:	51                   	push   %ecx
  800926:	52                   	push   %edx
  800927:	50                   	push   %eax
  800928:	68 98 28 80 00       	push   $0x802898
  80092d:	e8 14 03 00 00       	call   800c46 <cprintf>
  800932:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800935:	a1 24 30 80 00       	mov    0x803024,%eax
  80093a:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800940:	83 ec 08             	sub    $0x8,%esp
  800943:	50                   	push   %eax
  800944:	68 f0 28 80 00       	push   $0x8028f0
  800949:	e8 f8 02 00 00       	call   800c46 <cprintf>
  80094e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800951:	83 ec 0c             	sub    $0xc,%esp
  800954:	68 48 28 80 00       	push   $0x802848
  800959:	e8 e8 02 00 00       	call   800c46 <cprintf>
  80095e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800961:	e8 a0 15 00 00       	call   801f06 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800966:	e8 19 00 00 00       	call   800984 <exit>
}
  80096b:	90                   	nop
  80096c:	c9                   	leave  
  80096d:	c3                   	ret    

0080096e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80096e:	55                   	push   %ebp
  80096f:	89 e5                	mov    %esp,%ebp
  800971:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800974:	83 ec 0c             	sub    $0xc,%esp
  800977:	6a 00                	push   $0x0
  800979:	e8 2d 17 00 00       	call   8020ab <sys_destroy_env>
  80097e:	83 c4 10             	add    $0x10,%esp
}
  800981:	90                   	nop
  800982:	c9                   	leave  
  800983:	c3                   	ret    

00800984 <exit>:

void
exit(void)
{
  800984:	55                   	push   %ebp
  800985:	89 e5                	mov    %esp,%ebp
  800987:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80098a:	e8 82 17 00 00       	call   802111 <sys_exit_env>
}
  80098f:	90                   	nop
  800990:	c9                   	leave  
  800991:	c3                   	ret    

00800992 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800992:	55                   	push   %ebp
  800993:	89 e5                	mov    %esp,%ebp
  800995:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800998:	8d 45 10             	lea    0x10(%ebp),%eax
  80099b:	83 c0 04             	add    $0x4,%eax
  80099e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8009a1:	a1 5c 31 80 00       	mov    0x80315c,%eax
  8009a6:	85 c0                	test   %eax,%eax
  8009a8:	74 16                	je     8009c0 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8009aa:	a1 5c 31 80 00       	mov    0x80315c,%eax
  8009af:	83 ec 08             	sub    $0x8,%esp
  8009b2:	50                   	push   %eax
  8009b3:	68 04 29 80 00       	push   $0x802904
  8009b8:	e8 89 02 00 00       	call   800c46 <cprintf>
  8009bd:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8009c0:	a1 00 30 80 00       	mov    0x803000,%eax
  8009c5:	ff 75 0c             	pushl  0xc(%ebp)
  8009c8:	ff 75 08             	pushl  0x8(%ebp)
  8009cb:	50                   	push   %eax
  8009cc:	68 09 29 80 00       	push   $0x802909
  8009d1:	e8 70 02 00 00       	call   800c46 <cprintf>
  8009d6:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8009d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8009dc:	83 ec 08             	sub    $0x8,%esp
  8009df:	ff 75 f4             	pushl  -0xc(%ebp)
  8009e2:	50                   	push   %eax
  8009e3:	e8 f3 01 00 00       	call   800bdb <vcprintf>
  8009e8:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8009eb:	83 ec 08             	sub    $0x8,%esp
  8009ee:	6a 00                	push   $0x0
  8009f0:	68 25 29 80 00       	push   $0x802925
  8009f5:	e8 e1 01 00 00       	call   800bdb <vcprintf>
  8009fa:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8009fd:	e8 82 ff ff ff       	call   800984 <exit>

	// should not return here
	while (1) ;
  800a02:	eb fe                	jmp    800a02 <_panic+0x70>

00800a04 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800a04:	55                   	push   %ebp
  800a05:	89 e5                	mov    %esp,%ebp
  800a07:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800a0a:	a1 24 30 80 00       	mov    0x803024,%eax
  800a0f:	8b 50 74             	mov    0x74(%eax),%edx
  800a12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a15:	39 c2                	cmp    %eax,%edx
  800a17:	74 14                	je     800a2d <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800a19:	83 ec 04             	sub    $0x4,%esp
  800a1c:	68 28 29 80 00       	push   $0x802928
  800a21:	6a 26                	push   $0x26
  800a23:	68 74 29 80 00       	push   $0x802974
  800a28:	e8 65 ff ff ff       	call   800992 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800a2d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800a34:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a3b:	e9 c2 00 00 00       	jmp    800b02 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800a40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a43:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4d:	01 d0                	add    %edx,%eax
  800a4f:	8b 00                	mov    (%eax),%eax
  800a51:	85 c0                	test   %eax,%eax
  800a53:	75 08                	jne    800a5d <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800a55:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800a58:	e9 a2 00 00 00       	jmp    800aff <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800a5d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a64:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800a6b:	eb 69                	jmp    800ad6 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800a6d:	a1 24 30 80 00       	mov    0x803024,%eax
  800a72:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800a78:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a7b:	89 d0                	mov    %edx,%eax
  800a7d:	01 c0                	add    %eax,%eax
  800a7f:	01 d0                	add    %edx,%eax
  800a81:	c1 e0 03             	shl    $0x3,%eax
  800a84:	01 c8                	add    %ecx,%eax
  800a86:	8a 40 04             	mov    0x4(%eax),%al
  800a89:	84 c0                	test   %al,%al
  800a8b:	75 46                	jne    800ad3 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a8d:	a1 24 30 80 00       	mov    0x803024,%eax
  800a92:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800a98:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a9b:	89 d0                	mov    %edx,%eax
  800a9d:	01 c0                	add    %eax,%eax
  800a9f:	01 d0                	add    %edx,%eax
  800aa1:	c1 e0 03             	shl    $0x3,%eax
  800aa4:	01 c8                	add    %ecx,%eax
  800aa6:	8b 00                	mov    (%eax),%eax
  800aa8:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800aab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800aae:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ab3:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800ab5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ab8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800abf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac2:	01 c8                	add    %ecx,%eax
  800ac4:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800ac6:	39 c2                	cmp    %eax,%edx
  800ac8:	75 09                	jne    800ad3 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800aca:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800ad1:	eb 12                	jmp    800ae5 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ad3:	ff 45 e8             	incl   -0x18(%ebp)
  800ad6:	a1 24 30 80 00       	mov    0x803024,%eax
  800adb:	8b 50 74             	mov    0x74(%eax),%edx
  800ade:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800ae1:	39 c2                	cmp    %eax,%edx
  800ae3:	77 88                	ja     800a6d <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800ae5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800ae9:	75 14                	jne    800aff <CheckWSWithoutLastIndex+0xfb>
			panic(
  800aeb:	83 ec 04             	sub    $0x4,%esp
  800aee:	68 80 29 80 00       	push   $0x802980
  800af3:	6a 3a                	push   $0x3a
  800af5:	68 74 29 80 00       	push   $0x802974
  800afa:	e8 93 fe ff ff       	call   800992 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800aff:	ff 45 f0             	incl   -0x10(%ebp)
  800b02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b05:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800b08:	0f 8c 32 ff ff ff    	jl     800a40 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800b0e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b15:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800b1c:	eb 26                	jmp    800b44 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800b1e:	a1 24 30 80 00       	mov    0x803024,%eax
  800b23:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b29:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800b2c:	89 d0                	mov    %edx,%eax
  800b2e:	01 c0                	add    %eax,%eax
  800b30:	01 d0                	add    %edx,%eax
  800b32:	c1 e0 03             	shl    $0x3,%eax
  800b35:	01 c8                	add    %ecx,%eax
  800b37:	8a 40 04             	mov    0x4(%eax),%al
  800b3a:	3c 01                	cmp    $0x1,%al
  800b3c:	75 03                	jne    800b41 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800b3e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b41:	ff 45 e0             	incl   -0x20(%ebp)
  800b44:	a1 24 30 80 00       	mov    0x803024,%eax
  800b49:	8b 50 74             	mov    0x74(%eax),%edx
  800b4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b4f:	39 c2                	cmp    %eax,%edx
  800b51:	77 cb                	ja     800b1e <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b56:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800b59:	74 14                	je     800b6f <CheckWSWithoutLastIndex+0x16b>
		panic(
  800b5b:	83 ec 04             	sub    $0x4,%esp
  800b5e:	68 d4 29 80 00       	push   $0x8029d4
  800b63:	6a 44                	push   $0x44
  800b65:	68 74 29 80 00       	push   $0x802974
  800b6a:	e8 23 fe ff ff       	call   800992 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800b6f:	90                   	nop
  800b70:	c9                   	leave  
  800b71:	c3                   	ret    

00800b72 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800b72:	55                   	push   %ebp
  800b73:	89 e5                	mov    %esp,%ebp
  800b75:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800b78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7b:	8b 00                	mov    (%eax),%eax
  800b7d:	8d 48 01             	lea    0x1(%eax),%ecx
  800b80:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b83:	89 0a                	mov    %ecx,(%edx)
  800b85:	8b 55 08             	mov    0x8(%ebp),%edx
  800b88:	88 d1                	mov    %dl,%cl
  800b8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b8d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800b91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b94:	8b 00                	mov    (%eax),%eax
  800b96:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b9b:	75 2c                	jne    800bc9 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800b9d:	a0 28 30 80 00       	mov    0x803028,%al
  800ba2:	0f b6 c0             	movzbl %al,%eax
  800ba5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ba8:	8b 12                	mov    (%edx),%edx
  800baa:	89 d1                	mov    %edx,%ecx
  800bac:	8b 55 0c             	mov    0xc(%ebp),%edx
  800baf:	83 c2 08             	add    $0x8,%edx
  800bb2:	83 ec 04             	sub    $0x4,%esp
  800bb5:	50                   	push   %eax
  800bb6:	51                   	push   %ecx
  800bb7:	52                   	push   %edx
  800bb8:	e8 81 11 00 00       	call   801d3e <sys_cputs>
  800bbd:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800bc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800bc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bcc:	8b 40 04             	mov    0x4(%eax),%eax
  800bcf:	8d 50 01             	lea    0x1(%eax),%edx
  800bd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd5:	89 50 04             	mov    %edx,0x4(%eax)
}
  800bd8:	90                   	nop
  800bd9:	c9                   	leave  
  800bda:	c3                   	ret    

00800bdb <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800bdb:	55                   	push   %ebp
  800bdc:	89 e5                	mov    %esp,%ebp
  800bde:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800be4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800beb:	00 00 00 
	b.cnt = 0;
  800bee:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800bf5:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800bf8:	ff 75 0c             	pushl  0xc(%ebp)
  800bfb:	ff 75 08             	pushl  0x8(%ebp)
  800bfe:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c04:	50                   	push   %eax
  800c05:	68 72 0b 80 00       	push   $0x800b72
  800c0a:	e8 11 02 00 00       	call   800e20 <vprintfmt>
  800c0f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800c12:	a0 28 30 80 00       	mov    0x803028,%al
  800c17:	0f b6 c0             	movzbl %al,%eax
  800c1a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800c20:	83 ec 04             	sub    $0x4,%esp
  800c23:	50                   	push   %eax
  800c24:	52                   	push   %edx
  800c25:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c2b:	83 c0 08             	add    $0x8,%eax
  800c2e:	50                   	push   %eax
  800c2f:	e8 0a 11 00 00       	call   801d3e <sys_cputs>
  800c34:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800c37:	c6 05 28 30 80 00 00 	movb   $0x0,0x803028
	return b.cnt;
  800c3e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800c44:	c9                   	leave  
  800c45:	c3                   	ret    

00800c46 <cprintf>:

int cprintf(const char *fmt, ...) {
  800c46:	55                   	push   %ebp
  800c47:	89 e5                	mov    %esp,%ebp
  800c49:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800c4c:	c6 05 28 30 80 00 01 	movb   $0x1,0x803028
	va_start(ap, fmt);
  800c53:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c56:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c59:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5c:	83 ec 08             	sub    $0x8,%esp
  800c5f:	ff 75 f4             	pushl  -0xc(%ebp)
  800c62:	50                   	push   %eax
  800c63:	e8 73 ff ff ff       	call   800bdb <vcprintf>
  800c68:	83 c4 10             	add    $0x10,%esp
  800c6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800c6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c71:	c9                   	leave  
  800c72:	c3                   	ret    

00800c73 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800c73:	55                   	push   %ebp
  800c74:	89 e5                	mov    %esp,%ebp
  800c76:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800c79:	e8 6e 12 00 00       	call   801eec <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800c7e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c81:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c84:	8b 45 08             	mov    0x8(%ebp),%eax
  800c87:	83 ec 08             	sub    $0x8,%esp
  800c8a:	ff 75 f4             	pushl  -0xc(%ebp)
  800c8d:	50                   	push   %eax
  800c8e:	e8 48 ff ff ff       	call   800bdb <vcprintf>
  800c93:	83 c4 10             	add    $0x10,%esp
  800c96:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800c99:	e8 68 12 00 00       	call   801f06 <sys_enable_interrupt>
	return cnt;
  800c9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ca1:	c9                   	leave  
  800ca2:	c3                   	ret    

00800ca3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800ca3:	55                   	push   %ebp
  800ca4:	89 e5                	mov    %esp,%ebp
  800ca6:	53                   	push   %ebx
  800ca7:	83 ec 14             	sub    $0x14,%esp
  800caa:	8b 45 10             	mov    0x10(%ebp),%eax
  800cad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cb0:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800cb6:	8b 45 18             	mov    0x18(%ebp),%eax
  800cb9:	ba 00 00 00 00       	mov    $0x0,%edx
  800cbe:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800cc1:	77 55                	ja     800d18 <printnum+0x75>
  800cc3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800cc6:	72 05                	jb     800ccd <printnum+0x2a>
  800cc8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ccb:	77 4b                	ja     800d18 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800ccd:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800cd0:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800cd3:	8b 45 18             	mov    0x18(%ebp),%eax
  800cd6:	ba 00 00 00 00       	mov    $0x0,%edx
  800cdb:	52                   	push   %edx
  800cdc:	50                   	push   %eax
  800cdd:	ff 75 f4             	pushl  -0xc(%ebp)
  800ce0:	ff 75 f0             	pushl  -0x10(%ebp)
  800ce3:	e8 8c 16 00 00       	call   802374 <__udivdi3>
  800ce8:	83 c4 10             	add    $0x10,%esp
  800ceb:	83 ec 04             	sub    $0x4,%esp
  800cee:	ff 75 20             	pushl  0x20(%ebp)
  800cf1:	53                   	push   %ebx
  800cf2:	ff 75 18             	pushl  0x18(%ebp)
  800cf5:	52                   	push   %edx
  800cf6:	50                   	push   %eax
  800cf7:	ff 75 0c             	pushl  0xc(%ebp)
  800cfa:	ff 75 08             	pushl  0x8(%ebp)
  800cfd:	e8 a1 ff ff ff       	call   800ca3 <printnum>
  800d02:	83 c4 20             	add    $0x20,%esp
  800d05:	eb 1a                	jmp    800d21 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800d07:	83 ec 08             	sub    $0x8,%esp
  800d0a:	ff 75 0c             	pushl  0xc(%ebp)
  800d0d:	ff 75 20             	pushl  0x20(%ebp)
  800d10:	8b 45 08             	mov    0x8(%ebp),%eax
  800d13:	ff d0                	call   *%eax
  800d15:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800d18:	ff 4d 1c             	decl   0x1c(%ebp)
  800d1b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800d1f:	7f e6                	jg     800d07 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800d21:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800d24:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d2c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d2f:	53                   	push   %ebx
  800d30:	51                   	push   %ecx
  800d31:	52                   	push   %edx
  800d32:	50                   	push   %eax
  800d33:	e8 4c 17 00 00       	call   802484 <__umoddi3>
  800d38:	83 c4 10             	add    $0x10,%esp
  800d3b:	05 34 2c 80 00       	add    $0x802c34,%eax
  800d40:	8a 00                	mov    (%eax),%al
  800d42:	0f be c0             	movsbl %al,%eax
  800d45:	83 ec 08             	sub    $0x8,%esp
  800d48:	ff 75 0c             	pushl  0xc(%ebp)
  800d4b:	50                   	push   %eax
  800d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4f:	ff d0                	call   *%eax
  800d51:	83 c4 10             	add    $0x10,%esp
}
  800d54:	90                   	nop
  800d55:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d58:	c9                   	leave  
  800d59:	c3                   	ret    

00800d5a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800d5a:	55                   	push   %ebp
  800d5b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d5d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d61:	7e 1c                	jle    800d7f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800d63:	8b 45 08             	mov    0x8(%ebp),%eax
  800d66:	8b 00                	mov    (%eax),%eax
  800d68:	8d 50 08             	lea    0x8(%eax),%edx
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6e:	89 10                	mov    %edx,(%eax)
  800d70:	8b 45 08             	mov    0x8(%ebp),%eax
  800d73:	8b 00                	mov    (%eax),%eax
  800d75:	83 e8 08             	sub    $0x8,%eax
  800d78:	8b 50 04             	mov    0x4(%eax),%edx
  800d7b:	8b 00                	mov    (%eax),%eax
  800d7d:	eb 40                	jmp    800dbf <getuint+0x65>
	else if (lflag)
  800d7f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d83:	74 1e                	je     800da3 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800d85:	8b 45 08             	mov    0x8(%ebp),%eax
  800d88:	8b 00                	mov    (%eax),%eax
  800d8a:	8d 50 04             	lea    0x4(%eax),%edx
  800d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d90:	89 10                	mov    %edx,(%eax)
  800d92:	8b 45 08             	mov    0x8(%ebp),%eax
  800d95:	8b 00                	mov    (%eax),%eax
  800d97:	83 e8 04             	sub    $0x4,%eax
  800d9a:	8b 00                	mov    (%eax),%eax
  800d9c:	ba 00 00 00 00       	mov    $0x0,%edx
  800da1:	eb 1c                	jmp    800dbf <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800da3:	8b 45 08             	mov    0x8(%ebp),%eax
  800da6:	8b 00                	mov    (%eax),%eax
  800da8:	8d 50 04             	lea    0x4(%eax),%edx
  800dab:	8b 45 08             	mov    0x8(%ebp),%eax
  800dae:	89 10                	mov    %edx,(%eax)
  800db0:	8b 45 08             	mov    0x8(%ebp),%eax
  800db3:	8b 00                	mov    (%eax),%eax
  800db5:	83 e8 04             	sub    $0x4,%eax
  800db8:	8b 00                	mov    (%eax),%eax
  800dba:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800dbf:	5d                   	pop    %ebp
  800dc0:	c3                   	ret    

00800dc1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800dc1:	55                   	push   %ebp
  800dc2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800dc4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800dc8:	7e 1c                	jle    800de6 <getint+0x25>
		return va_arg(*ap, long long);
  800dca:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcd:	8b 00                	mov    (%eax),%eax
  800dcf:	8d 50 08             	lea    0x8(%eax),%edx
  800dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd5:	89 10                	mov    %edx,(%eax)
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dda:	8b 00                	mov    (%eax),%eax
  800ddc:	83 e8 08             	sub    $0x8,%eax
  800ddf:	8b 50 04             	mov    0x4(%eax),%edx
  800de2:	8b 00                	mov    (%eax),%eax
  800de4:	eb 38                	jmp    800e1e <getint+0x5d>
	else if (lflag)
  800de6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dea:	74 1a                	je     800e06 <getint+0x45>
		return va_arg(*ap, long);
  800dec:	8b 45 08             	mov    0x8(%ebp),%eax
  800def:	8b 00                	mov    (%eax),%eax
  800df1:	8d 50 04             	lea    0x4(%eax),%edx
  800df4:	8b 45 08             	mov    0x8(%ebp),%eax
  800df7:	89 10                	mov    %edx,(%eax)
  800df9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfc:	8b 00                	mov    (%eax),%eax
  800dfe:	83 e8 04             	sub    $0x4,%eax
  800e01:	8b 00                	mov    (%eax),%eax
  800e03:	99                   	cltd   
  800e04:	eb 18                	jmp    800e1e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800e06:	8b 45 08             	mov    0x8(%ebp),%eax
  800e09:	8b 00                	mov    (%eax),%eax
  800e0b:	8d 50 04             	lea    0x4(%eax),%edx
  800e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e11:	89 10                	mov    %edx,(%eax)
  800e13:	8b 45 08             	mov    0x8(%ebp),%eax
  800e16:	8b 00                	mov    (%eax),%eax
  800e18:	83 e8 04             	sub    $0x4,%eax
  800e1b:	8b 00                	mov    (%eax),%eax
  800e1d:	99                   	cltd   
}
  800e1e:	5d                   	pop    %ebp
  800e1f:	c3                   	ret    

00800e20 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800e20:	55                   	push   %ebp
  800e21:	89 e5                	mov    %esp,%ebp
  800e23:	56                   	push   %esi
  800e24:	53                   	push   %ebx
  800e25:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e28:	eb 17                	jmp    800e41 <vprintfmt+0x21>
			if (ch == '\0')
  800e2a:	85 db                	test   %ebx,%ebx
  800e2c:	0f 84 af 03 00 00    	je     8011e1 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800e32:	83 ec 08             	sub    $0x8,%esp
  800e35:	ff 75 0c             	pushl  0xc(%ebp)
  800e38:	53                   	push   %ebx
  800e39:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3c:	ff d0                	call   *%eax
  800e3e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e41:	8b 45 10             	mov    0x10(%ebp),%eax
  800e44:	8d 50 01             	lea    0x1(%eax),%edx
  800e47:	89 55 10             	mov    %edx,0x10(%ebp)
  800e4a:	8a 00                	mov    (%eax),%al
  800e4c:	0f b6 d8             	movzbl %al,%ebx
  800e4f:	83 fb 25             	cmp    $0x25,%ebx
  800e52:	75 d6                	jne    800e2a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800e54:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800e58:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800e5f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800e66:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800e6d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e74:	8b 45 10             	mov    0x10(%ebp),%eax
  800e77:	8d 50 01             	lea    0x1(%eax),%edx
  800e7a:	89 55 10             	mov    %edx,0x10(%ebp)
  800e7d:	8a 00                	mov    (%eax),%al
  800e7f:	0f b6 d8             	movzbl %al,%ebx
  800e82:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800e85:	83 f8 55             	cmp    $0x55,%eax
  800e88:	0f 87 2b 03 00 00    	ja     8011b9 <vprintfmt+0x399>
  800e8e:	8b 04 85 58 2c 80 00 	mov    0x802c58(,%eax,4),%eax
  800e95:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800e97:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800e9b:	eb d7                	jmp    800e74 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800e9d:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800ea1:	eb d1                	jmp    800e74 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ea3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800eaa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ead:	89 d0                	mov    %edx,%eax
  800eaf:	c1 e0 02             	shl    $0x2,%eax
  800eb2:	01 d0                	add    %edx,%eax
  800eb4:	01 c0                	add    %eax,%eax
  800eb6:	01 d8                	add    %ebx,%eax
  800eb8:	83 e8 30             	sub    $0x30,%eax
  800ebb:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800ebe:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec1:	8a 00                	mov    (%eax),%al
  800ec3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ec6:	83 fb 2f             	cmp    $0x2f,%ebx
  800ec9:	7e 3e                	jle    800f09 <vprintfmt+0xe9>
  800ecb:	83 fb 39             	cmp    $0x39,%ebx
  800ece:	7f 39                	jg     800f09 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ed0:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ed3:	eb d5                	jmp    800eaa <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ed5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ed8:	83 c0 04             	add    $0x4,%eax
  800edb:	89 45 14             	mov    %eax,0x14(%ebp)
  800ede:	8b 45 14             	mov    0x14(%ebp),%eax
  800ee1:	83 e8 04             	sub    $0x4,%eax
  800ee4:	8b 00                	mov    (%eax),%eax
  800ee6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800ee9:	eb 1f                	jmp    800f0a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800eeb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800eef:	79 83                	jns    800e74 <vprintfmt+0x54>
				width = 0;
  800ef1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800ef8:	e9 77 ff ff ff       	jmp    800e74 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800efd:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800f04:	e9 6b ff ff ff       	jmp    800e74 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800f09:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800f0a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f0e:	0f 89 60 ff ff ff    	jns    800e74 <vprintfmt+0x54>
				width = precision, precision = -1;
  800f14:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f17:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800f1a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800f21:	e9 4e ff ff ff       	jmp    800e74 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800f26:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800f29:	e9 46 ff ff ff       	jmp    800e74 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800f2e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f31:	83 c0 04             	add    $0x4,%eax
  800f34:	89 45 14             	mov    %eax,0x14(%ebp)
  800f37:	8b 45 14             	mov    0x14(%ebp),%eax
  800f3a:	83 e8 04             	sub    $0x4,%eax
  800f3d:	8b 00                	mov    (%eax),%eax
  800f3f:	83 ec 08             	sub    $0x8,%esp
  800f42:	ff 75 0c             	pushl  0xc(%ebp)
  800f45:	50                   	push   %eax
  800f46:	8b 45 08             	mov    0x8(%ebp),%eax
  800f49:	ff d0                	call   *%eax
  800f4b:	83 c4 10             	add    $0x10,%esp
			break;
  800f4e:	e9 89 02 00 00       	jmp    8011dc <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800f53:	8b 45 14             	mov    0x14(%ebp),%eax
  800f56:	83 c0 04             	add    $0x4,%eax
  800f59:	89 45 14             	mov    %eax,0x14(%ebp)
  800f5c:	8b 45 14             	mov    0x14(%ebp),%eax
  800f5f:	83 e8 04             	sub    $0x4,%eax
  800f62:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800f64:	85 db                	test   %ebx,%ebx
  800f66:	79 02                	jns    800f6a <vprintfmt+0x14a>
				err = -err;
  800f68:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800f6a:	83 fb 64             	cmp    $0x64,%ebx
  800f6d:	7f 0b                	jg     800f7a <vprintfmt+0x15a>
  800f6f:	8b 34 9d a0 2a 80 00 	mov    0x802aa0(,%ebx,4),%esi
  800f76:	85 f6                	test   %esi,%esi
  800f78:	75 19                	jne    800f93 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800f7a:	53                   	push   %ebx
  800f7b:	68 45 2c 80 00       	push   $0x802c45
  800f80:	ff 75 0c             	pushl  0xc(%ebp)
  800f83:	ff 75 08             	pushl  0x8(%ebp)
  800f86:	e8 5e 02 00 00       	call   8011e9 <printfmt>
  800f8b:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f8e:	e9 49 02 00 00       	jmp    8011dc <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800f93:	56                   	push   %esi
  800f94:	68 4e 2c 80 00       	push   $0x802c4e
  800f99:	ff 75 0c             	pushl  0xc(%ebp)
  800f9c:	ff 75 08             	pushl  0x8(%ebp)
  800f9f:	e8 45 02 00 00       	call   8011e9 <printfmt>
  800fa4:	83 c4 10             	add    $0x10,%esp
			break;
  800fa7:	e9 30 02 00 00       	jmp    8011dc <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800fac:	8b 45 14             	mov    0x14(%ebp),%eax
  800faf:	83 c0 04             	add    $0x4,%eax
  800fb2:	89 45 14             	mov    %eax,0x14(%ebp)
  800fb5:	8b 45 14             	mov    0x14(%ebp),%eax
  800fb8:	83 e8 04             	sub    $0x4,%eax
  800fbb:	8b 30                	mov    (%eax),%esi
  800fbd:	85 f6                	test   %esi,%esi
  800fbf:	75 05                	jne    800fc6 <vprintfmt+0x1a6>
				p = "(null)";
  800fc1:	be 51 2c 80 00       	mov    $0x802c51,%esi
			if (width > 0 && padc != '-')
  800fc6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fca:	7e 6d                	jle    801039 <vprintfmt+0x219>
  800fcc:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800fd0:	74 67                	je     801039 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800fd2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fd5:	83 ec 08             	sub    $0x8,%esp
  800fd8:	50                   	push   %eax
  800fd9:	56                   	push   %esi
  800fda:	e8 12 05 00 00       	call   8014f1 <strnlen>
  800fdf:	83 c4 10             	add    $0x10,%esp
  800fe2:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800fe5:	eb 16                	jmp    800ffd <vprintfmt+0x1dd>
					putch(padc, putdat);
  800fe7:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800feb:	83 ec 08             	sub    $0x8,%esp
  800fee:	ff 75 0c             	pushl  0xc(%ebp)
  800ff1:	50                   	push   %eax
  800ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff5:	ff d0                	call   *%eax
  800ff7:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ffa:	ff 4d e4             	decl   -0x1c(%ebp)
  800ffd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801001:	7f e4                	jg     800fe7 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801003:	eb 34                	jmp    801039 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801005:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801009:	74 1c                	je     801027 <vprintfmt+0x207>
  80100b:	83 fb 1f             	cmp    $0x1f,%ebx
  80100e:	7e 05                	jle    801015 <vprintfmt+0x1f5>
  801010:	83 fb 7e             	cmp    $0x7e,%ebx
  801013:	7e 12                	jle    801027 <vprintfmt+0x207>
					putch('?', putdat);
  801015:	83 ec 08             	sub    $0x8,%esp
  801018:	ff 75 0c             	pushl  0xc(%ebp)
  80101b:	6a 3f                	push   $0x3f
  80101d:	8b 45 08             	mov    0x8(%ebp),%eax
  801020:	ff d0                	call   *%eax
  801022:	83 c4 10             	add    $0x10,%esp
  801025:	eb 0f                	jmp    801036 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801027:	83 ec 08             	sub    $0x8,%esp
  80102a:	ff 75 0c             	pushl  0xc(%ebp)
  80102d:	53                   	push   %ebx
  80102e:	8b 45 08             	mov    0x8(%ebp),%eax
  801031:	ff d0                	call   *%eax
  801033:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801036:	ff 4d e4             	decl   -0x1c(%ebp)
  801039:	89 f0                	mov    %esi,%eax
  80103b:	8d 70 01             	lea    0x1(%eax),%esi
  80103e:	8a 00                	mov    (%eax),%al
  801040:	0f be d8             	movsbl %al,%ebx
  801043:	85 db                	test   %ebx,%ebx
  801045:	74 24                	je     80106b <vprintfmt+0x24b>
  801047:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80104b:	78 b8                	js     801005 <vprintfmt+0x1e5>
  80104d:	ff 4d e0             	decl   -0x20(%ebp)
  801050:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801054:	79 af                	jns    801005 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801056:	eb 13                	jmp    80106b <vprintfmt+0x24b>
				putch(' ', putdat);
  801058:	83 ec 08             	sub    $0x8,%esp
  80105b:	ff 75 0c             	pushl  0xc(%ebp)
  80105e:	6a 20                	push   $0x20
  801060:	8b 45 08             	mov    0x8(%ebp),%eax
  801063:	ff d0                	call   *%eax
  801065:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801068:	ff 4d e4             	decl   -0x1c(%ebp)
  80106b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80106f:	7f e7                	jg     801058 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801071:	e9 66 01 00 00       	jmp    8011dc <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801076:	83 ec 08             	sub    $0x8,%esp
  801079:	ff 75 e8             	pushl  -0x18(%ebp)
  80107c:	8d 45 14             	lea    0x14(%ebp),%eax
  80107f:	50                   	push   %eax
  801080:	e8 3c fd ff ff       	call   800dc1 <getint>
  801085:	83 c4 10             	add    $0x10,%esp
  801088:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80108b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80108e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801091:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801094:	85 d2                	test   %edx,%edx
  801096:	79 23                	jns    8010bb <vprintfmt+0x29b>
				putch('-', putdat);
  801098:	83 ec 08             	sub    $0x8,%esp
  80109b:	ff 75 0c             	pushl  0xc(%ebp)
  80109e:	6a 2d                	push   $0x2d
  8010a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a3:	ff d0                	call   *%eax
  8010a5:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8010a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010ae:	f7 d8                	neg    %eax
  8010b0:	83 d2 00             	adc    $0x0,%edx
  8010b3:	f7 da                	neg    %edx
  8010b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010b8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8010bb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010c2:	e9 bc 00 00 00       	jmp    801183 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8010c7:	83 ec 08             	sub    $0x8,%esp
  8010ca:	ff 75 e8             	pushl  -0x18(%ebp)
  8010cd:	8d 45 14             	lea    0x14(%ebp),%eax
  8010d0:	50                   	push   %eax
  8010d1:	e8 84 fc ff ff       	call   800d5a <getuint>
  8010d6:	83 c4 10             	add    $0x10,%esp
  8010d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010dc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8010df:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010e6:	e9 98 00 00 00       	jmp    801183 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8010eb:	83 ec 08             	sub    $0x8,%esp
  8010ee:	ff 75 0c             	pushl  0xc(%ebp)
  8010f1:	6a 58                	push   $0x58
  8010f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f6:	ff d0                	call   *%eax
  8010f8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8010fb:	83 ec 08             	sub    $0x8,%esp
  8010fe:	ff 75 0c             	pushl  0xc(%ebp)
  801101:	6a 58                	push   $0x58
  801103:	8b 45 08             	mov    0x8(%ebp),%eax
  801106:	ff d0                	call   *%eax
  801108:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80110b:	83 ec 08             	sub    $0x8,%esp
  80110e:	ff 75 0c             	pushl  0xc(%ebp)
  801111:	6a 58                	push   $0x58
  801113:	8b 45 08             	mov    0x8(%ebp),%eax
  801116:	ff d0                	call   *%eax
  801118:	83 c4 10             	add    $0x10,%esp
			break;
  80111b:	e9 bc 00 00 00       	jmp    8011dc <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801120:	83 ec 08             	sub    $0x8,%esp
  801123:	ff 75 0c             	pushl  0xc(%ebp)
  801126:	6a 30                	push   $0x30
  801128:	8b 45 08             	mov    0x8(%ebp),%eax
  80112b:	ff d0                	call   *%eax
  80112d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801130:	83 ec 08             	sub    $0x8,%esp
  801133:	ff 75 0c             	pushl  0xc(%ebp)
  801136:	6a 78                	push   $0x78
  801138:	8b 45 08             	mov    0x8(%ebp),%eax
  80113b:	ff d0                	call   *%eax
  80113d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801140:	8b 45 14             	mov    0x14(%ebp),%eax
  801143:	83 c0 04             	add    $0x4,%eax
  801146:	89 45 14             	mov    %eax,0x14(%ebp)
  801149:	8b 45 14             	mov    0x14(%ebp),%eax
  80114c:	83 e8 04             	sub    $0x4,%eax
  80114f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801151:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801154:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80115b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801162:	eb 1f                	jmp    801183 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801164:	83 ec 08             	sub    $0x8,%esp
  801167:	ff 75 e8             	pushl  -0x18(%ebp)
  80116a:	8d 45 14             	lea    0x14(%ebp),%eax
  80116d:	50                   	push   %eax
  80116e:	e8 e7 fb ff ff       	call   800d5a <getuint>
  801173:	83 c4 10             	add    $0x10,%esp
  801176:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801179:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80117c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801183:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801187:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80118a:	83 ec 04             	sub    $0x4,%esp
  80118d:	52                   	push   %edx
  80118e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801191:	50                   	push   %eax
  801192:	ff 75 f4             	pushl  -0xc(%ebp)
  801195:	ff 75 f0             	pushl  -0x10(%ebp)
  801198:	ff 75 0c             	pushl  0xc(%ebp)
  80119b:	ff 75 08             	pushl  0x8(%ebp)
  80119e:	e8 00 fb ff ff       	call   800ca3 <printnum>
  8011a3:	83 c4 20             	add    $0x20,%esp
			break;
  8011a6:	eb 34                	jmp    8011dc <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8011a8:	83 ec 08             	sub    $0x8,%esp
  8011ab:	ff 75 0c             	pushl  0xc(%ebp)
  8011ae:	53                   	push   %ebx
  8011af:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b2:	ff d0                	call   *%eax
  8011b4:	83 c4 10             	add    $0x10,%esp
			break;
  8011b7:	eb 23                	jmp    8011dc <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8011b9:	83 ec 08             	sub    $0x8,%esp
  8011bc:	ff 75 0c             	pushl  0xc(%ebp)
  8011bf:	6a 25                	push   $0x25
  8011c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c4:	ff d0                	call   *%eax
  8011c6:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8011c9:	ff 4d 10             	decl   0x10(%ebp)
  8011cc:	eb 03                	jmp    8011d1 <vprintfmt+0x3b1>
  8011ce:	ff 4d 10             	decl   0x10(%ebp)
  8011d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d4:	48                   	dec    %eax
  8011d5:	8a 00                	mov    (%eax),%al
  8011d7:	3c 25                	cmp    $0x25,%al
  8011d9:	75 f3                	jne    8011ce <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8011db:	90                   	nop
		}
	}
  8011dc:	e9 47 fc ff ff       	jmp    800e28 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8011e1:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8011e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011e5:	5b                   	pop    %ebx
  8011e6:	5e                   	pop    %esi
  8011e7:	5d                   	pop    %ebp
  8011e8:	c3                   	ret    

008011e9 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8011e9:	55                   	push   %ebp
  8011ea:	89 e5                	mov    %esp,%ebp
  8011ec:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8011ef:	8d 45 10             	lea    0x10(%ebp),%eax
  8011f2:	83 c0 04             	add    $0x4,%eax
  8011f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8011f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8011fb:	ff 75 f4             	pushl  -0xc(%ebp)
  8011fe:	50                   	push   %eax
  8011ff:	ff 75 0c             	pushl  0xc(%ebp)
  801202:	ff 75 08             	pushl  0x8(%ebp)
  801205:	e8 16 fc ff ff       	call   800e20 <vprintfmt>
  80120a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80120d:	90                   	nop
  80120e:	c9                   	leave  
  80120f:	c3                   	ret    

00801210 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801210:	55                   	push   %ebp
  801211:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801213:	8b 45 0c             	mov    0xc(%ebp),%eax
  801216:	8b 40 08             	mov    0x8(%eax),%eax
  801219:	8d 50 01             	lea    0x1(%eax),%edx
  80121c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801222:	8b 45 0c             	mov    0xc(%ebp),%eax
  801225:	8b 10                	mov    (%eax),%edx
  801227:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122a:	8b 40 04             	mov    0x4(%eax),%eax
  80122d:	39 c2                	cmp    %eax,%edx
  80122f:	73 12                	jae    801243 <sprintputch+0x33>
		*b->buf++ = ch;
  801231:	8b 45 0c             	mov    0xc(%ebp),%eax
  801234:	8b 00                	mov    (%eax),%eax
  801236:	8d 48 01             	lea    0x1(%eax),%ecx
  801239:	8b 55 0c             	mov    0xc(%ebp),%edx
  80123c:	89 0a                	mov    %ecx,(%edx)
  80123e:	8b 55 08             	mov    0x8(%ebp),%edx
  801241:	88 10                	mov    %dl,(%eax)
}
  801243:	90                   	nop
  801244:	5d                   	pop    %ebp
  801245:	c3                   	ret    

00801246 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801246:	55                   	push   %ebp
  801247:	89 e5                	mov    %esp,%ebp
  801249:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80124c:	8b 45 08             	mov    0x8(%ebp),%eax
  80124f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801252:	8b 45 0c             	mov    0xc(%ebp),%eax
  801255:	8d 50 ff             	lea    -0x1(%eax),%edx
  801258:	8b 45 08             	mov    0x8(%ebp),%eax
  80125b:	01 d0                	add    %edx,%eax
  80125d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801260:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801267:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80126b:	74 06                	je     801273 <vsnprintf+0x2d>
  80126d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801271:	7f 07                	jg     80127a <vsnprintf+0x34>
		return -E_INVAL;
  801273:	b8 03 00 00 00       	mov    $0x3,%eax
  801278:	eb 20                	jmp    80129a <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80127a:	ff 75 14             	pushl  0x14(%ebp)
  80127d:	ff 75 10             	pushl  0x10(%ebp)
  801280:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801283:	50                   	push   %eax
  801284:	68 10 12 80 00       	push   $0x801210
  801289:	e8 92 fb ff ff       	call   800e20 <vprintfmt>
  80128e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801291:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801294:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801297:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80129a:	c9                   	leave  
  80129b:	c3                   	ret    

0080129c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80129c:	55                   	push   %ebp
  80129d:	89 e5                	mov    %esp,%ebp
  80129f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8012a2:	8d 45 10             	lea    0x10(%ebp),%eax
  8012a5:	83 c0 04             	add    $0x4,%eax
  8012a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8012ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ae:	ff 75 f4             	pushl  -0xc(%ebp)
  8012b1:	50                   	push   %eax
  8012b2:	ff 75 0c             	pushl  0xc(%ebp)
  8012b5:	ff 75 08             	pushl  0x8(%ebp)
  8012b8:	e8 89 ff ff ff       	call   801246 <vsnprintf>
  8012bd:	83 c4 10             	add    $0x10,%esp
  8012c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8012c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012c6:	c9                   	leave  
  8012c7:	c3                   	ret    

008012c8 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8012c8:	55                   	push   %ebp
  8012c9:	89 e5                	mov    %esp,%ebp
  8012cb:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  8012ce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012d2:	74 13                	je     8012e7 <readline+0x1f>
		cprintf("%s", prompt);
  8012d4:	83 ec 08             	sub    $0x8,%esp
  8012d7:	ff 75 08             	pushl  0x8(%ebp)
  8012da:	68 b0 2d 80 00       	push   $0x802db0
  8012df:	e8 62 f9 ff ff       	call   800c46 <cprintf>
  8012e4:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8012e7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8012ee:	83 ec 0c             	sub    $0xc,%esp
  8012f1:	6a 00                	push   $0x0
  8012f3:	e8 54 f5 ff ff       	call   80084c <iscons>
  8012f8:	83 c4 10             	add    $0x10,%esp
  8012fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8012fe:	e8 fb f4 ff ff       	call   8007fe <getchar>
  801303:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801306:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80130a:	79 22                	jns    80132e <readline+0x66>
			if (c != -E_EOF)
  80130c:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801310:	0f 84 ad 00 00 00    	je     8013c3 <readline+0xfb>
				cprintf("read error: %e\n", c);
  801316:	83 ec 08             	sub    $0x8,%esp
  801319:	ff 75 ec             	pushl  -0x14(%ebp)
  80131c:	68 b3 2d 80 00       	push   $0x802db3
  801321:	e8 20 f9 ff ff       	call   800c46 <cprintf>
  801326:	83 c4 10             	add    $0x10,%esp
			return;
  801329:	e9 95 00 00 00       	jmp    8013c3 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80132e:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801332:	7e 34                	jle    801368 <readline+0xa0>
  801334:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80133b:	7f 2b                	jg     801368 <readline+0xa0>
			if (echoing)
  80133d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801341:	74 0e                	je     801351 <readline+0x89>
				cputchar(c);
  801343:	83 ec 0c             	sub    $0xc,%esp
  801346:	ff 75 ec             	pushl  -0x14(%ebp)
  801349:	e8 68 f4 ff ff       	call   8007b6 <cputchar>
  80134e:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801351:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801354:	8d 50 01             	lea    0x1(%eax),%edx
  801357:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80135a:	89 c2                	mov    %eax,%edx
  80135c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80135f:	01 d0                	add    %edx,%eax
  801361:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801364:	88 10                	mov    %dl,(%eax)
  801366:	eb 56                	jmp    8013be <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801368:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80136c:	75 1f                	jne    80138d <readline+0xc5>
  80136e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801372:	7e 19                	jle    80138d <readline+0xc5>
			if (echoing)
  801374:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801378:	74 0e                	je     801388 <readline+0xc0>
				cputchar(c);
  80137a:	83 ec 0c             	sub    $0xc,%esp
  80137d:	ff 75 ec             	pushl  -0x14(%ebp)
  801380:	e8 31 f4 ff ff       	call   8007b6 <cputchar>
  801385:	83 c4 10             	add    $0x10,%esp

			i--;
  801388:	ff 4d f4             	decl   -0xc(%ebp)
  80138b:	eb 31                	jmp    8013be <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  80138d:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801391:	74 0a                	je     80139d <readline+0xd5>
  801393:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801397:	0f 85 61 ff ff ff    	jne    8012fe <readline+0x36>
			if (echoing)
  80139d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013a1:	74 0e                	je     8013b1 <readline+0xe9>
				cputchar(c);
  8013a3:	83 ec 0c             	sub    $0xc,%esp
  8013a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8013a9:	e8 08 f4 ff ff       	call   8007b6 <cputchar>
  8013ae:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8013b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b7:	01 d0                	add    %edx,%eax
  8013b9:	c6 00 00             	movb   $0x0,(%eax)
			return;
  8013bc:	eb 06                	jmp    8013c4 <readline+0xfc>
		}
	}
  8013be:	e9 3b ff ff ff       	jmp    8012fe <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  8013c3:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  8013c4:	c9                   	leave  
  8013c5:	c3                   	ret    

008013c6 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8013c6:	55                   	push   %ebp
  8013c7:	89 e5                	mov    %esp,%ebp
  8013c9:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8013cc:	e8 1b 0b 00 00       	call   801eec <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  8013d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013d5:	74 13                	je     8013ea <atomic_readline+0x24>
		cprintf("%s", prompt);
  8013d7:	83 ec 08             	sub    $0x8,%esp
  8013da:	ff 75 08             	pushl  0x8(%ebp)
  8013dd:	68 b0 2d 80 00       	push   $0x802db0
  8013e2:	e8 5f f8 ff ff       	call   800c46 <cprintf>
  8013e7:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8013ea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8013f1:	83 ec 0c             	sub    $0xc,%esp
  8013f4:	6a 00                	push   $0x0
  8013f6:	e8 51 f4 ff ff       	call   80084c <iscons>
  8013fb:	83 c4 10             	add    $0x10,%esp
  8013fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801401:	e8 f8 f3 ff ff       	call   8007fe <getchar>
  801406:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801409:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80140d:	79 23                	jns    801432 <atomic_readline+0x6c>
			if (c != -E_EOF)
  80140f:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801413:	74 13                	je     801428 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  801415:	83 ec 08             	sub    $0x8,%esp
  801418:	ff 75 ec             	pushl  -0x14(%ebp)
  80141b:	68 b3 2d 80 00       	push   $0x802db3
  801420:	e8 21 f8 ff ff       	call   800c46 <cprintf>
  801425:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801428:	e8 d9 0a 00 00       	call   801f06 <sys_enable_interrupt>
			return;
  80142d:	e9 9a 00 00 00       	jmp    8014cc <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801432:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801436:	7e 34                	jle    80146c <atomic_readline+0xa6>
  801438:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80143f:	7f 2b                	jg     80146c <atomic_readline+0xa6>
			if (echoing)
  801441:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801445:	74 0e                	je     801455 <atomic_readline+0x8f>
				cputchar(c);
  801447:	83 ec 0c             	sub    $0xc,%esp
  80144a:	ff 75 ec             	pushl  -0x14(%ebp)
  80144d:	e8 64 f3 ff ff       	call   8007b6 <cputchar>
  801452:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801455:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801458:	8d 50 01             	lea    0x1(%eax),%edx
  80145b:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80145e:	89 c2                	mov    %eax,%edx
  801460:	8b 45 0c             	mov    0xc(%ebp),%eax
  801463:	01 d0                	add    %edx,%eax
  801465:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801468:	88 10                	mov    %dl,(%eax)
  80146a:	eb 5b                	jmp    8014c7 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  80146c:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801470:	75 1f                	jne    801491 <atomic_readline+0xcb>
  801472:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801476:	7e 19                	jle    801491 <atomic_readline+0xcb>
			if (echoing)
  801478:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80147c:	74 0e                	je     80148c <atomic_readline+0xc6>
				cputchar(c);
  80147e:	83 ec 0c             	sub    $0xc,%esp
  801481:	ff 75 ec             	pushl  -0x14(%ebp)
  801484:	e8 2d f3 ff ff       	call   8007b6 <cputchar>
  801489:	83 c4 10             	add    $0x10,%esp
			i--;
  80148c:	ff 4d f4             	decl   -0xc(%ebp)
  80148f:	eb 36                	jmp    8014c7 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  801491:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801495:	74 0a                	je     8014a1 <atomic_readline+0xdb>
  801497:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80149b:	0f 85 60 ff ff ff    	jne    801401 <atomic_readline+0x3b>
			if (echoing)
  8014a1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8014a5:	74 0e                	je     8014b5 <atomic_readline+0xef>
				cputchar(c);
  8014a7:	83 ec 0c             	sub    $0xc,%esp
  8014aa:	ff 75 ec             	pushl  -0x14(%ebp)
  8014ad:	e8 04 f3 ff ff       	call   8007b6 <cputchar>
  8014b2:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  8014b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014bb:	01 d0                	add    %edx,%eax
  8014bd:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  8014c0:	e8 41 0a 00 00       	call   801f06 <sys_enable_interrupt>
			return;
  8014c5:	eb 05                	jmp    8014cc <atomic_readline+0x106>
		}
	}
  8014c7:	e9 35 ff ff ff       	jmp    801401 <atomic_readline+0x3b>
}
  8014cc:	c9                   	leave  
  8014cd:	c3                   	ret    

008014ce <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8014ce:	55                   	push   %ebp
  8014cf:	89 e5                	mov    %esp,%ebp
  8014d1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8014d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014db:	eb 06                	jmp    8014e3 <strlen+0x15>
		n++;
  8014dd:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8014e0:	ff 45 08             	incl   0x8(%ebp)
  8014e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e6:	8a 00                	mov    (%eax),%al
  8014e8:	84 c0                	test   %al,%al
  8014ea:	75 f1                	jne    8014dd <strlen+0xf>
		n++;
	return n;
  8014ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8014ef:	c9                   	leave  
  8014f0:	c3                   	ret    

008014f1 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8014f1:	55                   	push   %ebp
  8014f2:	89 e5                	mov    %esp,%ebp
  8014f4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8014f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014fe:	eb 09                	jmp    801509 <strnlen+0x18>
		n++;
  801500:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801503:	ff 45 08             	incl   0x8(%ebp)
  801506:	ff 4d 0c             	decl   0xc(%ebp)
  801509:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80150d:	74 09                	je     801518 <strnlen+0x27>
  80150f:	8b 45 08             	mov    0x8(%ebp),%eax
  801512:	8a 00                	mov    (%eax),%al
  801514:	84 c0                	test   %al,%al
  801516:	75 e8                	jne    801500 <strnlen+0xf>
		n++;
	return n;
  801518:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80151b:	c9                   	leave  
  80151c:	c3                   	ret    

0080151d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80151d:	55                   	push   %ebp
  80151e:	89 e5                	mov    %esp,%ebp
  801520:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801523:	8b 45 08             	mov    0x8(%ebp),%eax
  801526:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801529:	90                   	nop
  80152a:	8b 45 08             	mov    0x8(%ebp),%eax
  80152d:	8d 50 01             	lea    0x1(%eax),%edx
  801530:	89 55 08             	mov    %edx,0x8(%ebp)
  801533:	8b 55 0c             	mov    0xc(%ebp),%edx
  801536:	8d 4a 01             	lea    0x1(%edx),%ecx
  801539:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80153c:	8a 12                	mov    (%edx),%dl
  80153e:	88 10                	mov    %dl,(%eax)
  801540:	8a 00                	mov    (%eax),%al
  801542:	84 c0                	test   %al,%al
  801544:	75 e4                	jne    80152a <strcpy+0xd>
		/* do nothing */;
	return ret;
  801546:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801549:	c9                   	leave  
  80154a:	c3                   	ret    

0080154b <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80154b:	55                   	push   %ebp
  80154c:	89 e5                	mov    %esp,%ebp
  80154e:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801551:	8b 45 08             	mov    0x8(%ebp),%eax
  801554:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801557:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80155e:	eb 1f                	jmp    80157f <strncpy+0x34>
		*dst++ = *src;
  801560:	8b 45 08             	mov    0x8(%ebp),%eax
  801563:	8d 50 01             	lea    0x1(%eax),%edx
  801566:	89 55 08             	mov    %edx,0x8(%ebp)
  801569:	8b 55 0c             	mov    0xc(%ebp),%edx
  80156c:	8a 12                	mov    (%edx),%dl
  80156e:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801570:	8b 45 0c             	mov    0xc(%ebp),%eax
  801573:	8a 00                	mov    (%eax),%al
  801575:	84 c0                	test   %al,%al
  801577:	74 03                	je     80157c <strncpy+0x31>
			src++;
  801579:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80157c:	ff 45 fc             	incl   -0x4(%ebp)
  80157f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801582:	3b 45 10             	cmp    0x10(%ebp),%eax
  801585:	72 d9                	jb     801560 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801587:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80158a:	c9                   	leave  
  80158b:	c3                   	ret    

0080158c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80158c:	55                   	push   %ebp
  80158d:	89 e5                	mov    %esp,%ebp
  80158f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801592:	8b 45 08             	mov    0x8(%ebp),%eax
  801595:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801598:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80159c:	74 30                	je     8015ce <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80159e:	eb 16                	jmp    8015b6 <strlcpy+0x2a>
			*dst++ = *src++;
  8015a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a3:	8d 50 01             	lea    0x1(%eax),%edx
  8015a6:	89 55 08             	mov    %edx,0x8(%ebp)
  8015a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ac:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015af:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8015b2:	8a 12                	mov    (%edx),%dl
  8015b4:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8015b6:	ff 4d 10             	decl   0x10(%ebp)
  8015b9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015bd:	74 09                	je     8015c8 <strlcpy+0x3c>
  8015bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c2:	8a 00                	mov    (%eax),%al
  8015c4:	84 c0                	test   %al,%al
  8015c6:	75 d8                	jne    8015a0 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8015c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8015ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8015d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015d4:	29 c2                	sub    %eax,%edx
  8015d6:	89 d0                	mov    %edx,%eax
}
  8015d8:	c9                   	leave  
  8015d9:	c3                   	ret    

008015da <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8015da:	55                   	push   %ebp
  8015db:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8015dd:	eb 06                	jmp    8015e5 <strcmp+0xb>
		p++, q++;
  8015df:	ff 45 08             	incl   0x8(%ebp)
  8015e2:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8015e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e8:	8a 00                	mov    (%eax),%al
  8015ea:	84 c0                	test   %al,%al
  8015ec:	74 0e                	je     8015fc <strcmp+0x22>
  8015ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f1:	8a 10                	mov    (%eax),%dl
  8015f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f6:	8a 00                	mov    (%eax),%al
  8015f8:	38 c2                	cmp    %al,%dl
  8015fa:	74 e3                	je     8015df <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8015fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ff:	8a 00                	mov    (%eax),%al
  801601:	0f b6 d0             	movzbl %al,%edx
  801604:	8b 45 0c             	mov    0xc(%ebp),%eax
  801607:	8a 00                	mov    (%eax),%al
  801609:	0f b6 c0             	movzbl %al,%eax
  80160c:	29 c2                	sub    %eax,%edx
  80160e:	89 d0                	mov    %edx,%eax
}
  801610:	5d                   	pop    %ebp
  801611:	c3                   	ret    

00801612 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801612:	55                   	push   %ebp
  801613:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801615:	eb 09                	jmp    801620 <strncmp+0xe>
		n--, p++, q++;
  801617:	ff 4d 10             	decl   0x10(%ebp)
  80161a:	ff 45 08             	incl   0x8(%ebp)
  80161d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801620:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801624:	74 17                	je     80163d <strncmp+0x2b>
  801626:	8b 45 08             	mov    0x8(%ebp),%eax
  801629:	8a 00                	mov    (%eax),%al
  80162b:	84 c0                	test   %al,%al
  80162d:	74 0e                	je     80163d <strncmp+0x2b>
  80162f:	8b 45 08             	mov    0x8(%ebp),%eax
  801632:	8a 10                	mov    (%eax),%dl
  801634:	8b 45 0c             	mov    0xc(%ebp),%eax
  801637:	8a 00                	mov    (%eax),%al
  801639:	38 c2                	cmp    %al,%dl
  80163b:	74 da                	je     801617 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80163d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801641:	75 07                	jne    80164a <strncmp+0x38>
		return 0;
  801643:	b8 00 00 00 00       	mov    $0x0,%eax
  801648:	eb 14                	jmp    80165e <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80164a:	8b 45 08             	mov    0x8(%ebp),%eax
  80164d:	8a 00                	mov    (%eax),%al
  80164f:	0f b6 d0             	movzbl %al,%edx
  801652:	8b 45 0c             	mov    0xc(%ebp),%eax
  801655:	8a 00                	mov    (%eax),%al
  801657:	0f b6 c0             	movzbl %al,%eax
  80165a:	29 c2                	sub    %eax,%edx
  80165c:	89 d0                	mov    %edx,%eax
}
  80165e:	5d                   	pop    %ebp
  80165f:	c3                   	ret    

00801660 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801660:	55                   	push   %ebp
  801661:	89 e5                	mov    %esp,%ebp
  801663:	83 ec 04             	sub    $0x4,%esp
  801666:	8b 45 0c             	mov    0xc(%ebp),%eax
  801669:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80166c:	eb 12                	jmp    801680 <strchr+0x20>
		if (*s == c)
  80166e:	8b 45 08             	mov    0x8(%ebp),%eax
  801671:	8a 00                	mov    (%eax),%al
  801673:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801676:	75 05                	jne    80167d <strchr+0x1d>
			return (char *) s;
  801678:	8b 45 08             	mov    0x8(%ebp),%eax
  80167b:	eb 11                	jmp    80168e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80167d:	ff 45 08             	incl   0x8(%ebp)
  801680:	8b 45 08             	mov    0x8(%ebp),%eax
  801683:	8a 00                	mov    (%eax),%al
  801685:	84 c0                	test   %al,%al
  801687:	75 e5                	jne    80166e <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801689:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80168e:	c9                   	leave  
  80168f:	c3                   	ret    

00801690 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801690:	55                   	push   %ebp
  801691:	89 e5                	mov    %esp,%ebp
  801693:	83 ec 04             	sub    $0x4,%esp
  801696:	8b 45 0c             	mov    0xc(%ebp),%eax
  801699:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80169c:	eb 0d                	jmp    8016ab <strfind+0x1b>
		if (*s == c)
  80169e:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a1:	8a 00                	mov    (%eax),%al
  8016a3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8016a6:	74 0e                	je     8016b6 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8016a8:	ff 45 08             	incl   0x8(%ebp)
  8016ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ae:	8a 00                	mov    (%eax),%al
  8016b0:	84 c0                	test   %al,%al
  8016b2:	75 ea                	jne    80169e <strfind+0xe>
  8016b4:	eb 01                	jmp    8016b7 <strfind+0x27>
		if (*s == c)
			break;
  8016b6:	90                   	nop
	return (char *) s;
  8016b7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016ba:	c9                   	leave  
  8016bb:	c3                   	ret    

008016bc <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8016bc:	55                   	push   %ebp
  8016bd:	89 e5                	mov    %esp,%ebp
  8016bf:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8016c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8016c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8016cb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8016ce:	eb 0e                	jmp    8016de <memset+0x22>
		*p++ = c;
  8016d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016d3:	8d 50 01             	lea    0x1(%eax),%edx
  8016d6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8016d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016dc:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8016de:	ff 4d f8             	decl   -0x8(%ebp)
  8016e1:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8016e5:	79 e9                	jns    8016d0 <memset+0x14>
		*p++ = c;

	return v;
  8016e7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016ea:	c9                   	leave  
  8016eb:	c3                   	ret    

008016ec <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8016ec:	55                   	push   %ebp
  8016ed:	89 e5                	mov    %esp,%ebp
  8016ef:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8016f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8016f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8016fe:	eb 16                	jmp    801716 <memcpy+0x2a>
		*d++ = *s++;
  801700:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801703:	8d 50 01             	lea    0x1(%eax),%edx
  801706:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801709:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80170c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80170f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801712:	8a 12                	mov    (%edx),%dl
  801714:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801716:	8b 45 10             	mov    0x10(%ebp),%eax
  801719:	8d 50 ff             	lea    -0x1(%eax),%edx
  80171c:	89 55 10             	mov    %edx,0x10(%ebp)
  80171f:	85 c0                	test   %eax,%eax
  801721:	75 dd                	jne    801700 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801723:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801726:	c9                   	leave  
  801727:	c3                   	ret    

00801728 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801728:	55                   	push   %ebp
  801729:	89 e5                	mov    %esp,%ebp
  80172b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80172e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801731:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801734:	8b 45 08             	mov    0x8(%ebp),%eax
  801737:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80173a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80173d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801740:	73 50                	jae    801792 <memmove+0x6a>
  801742:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801745:	8b 45 10             	mov    0x10(%ebp),%eax
  801748:	01 d0                	add    %edx,%eax
  80174a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80174d:	76 43                	jbe    801792 <memmove+0x6a>
		s += n;
  80174f:	8b 45 10             	mov    0x10(%ebp),%eax
  801752:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801755:	8b 45 10             	mov    0x10(%ebp),%eax
  801758:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80175b:	eb 10                	jmp    80176d <memmove+0x45>
			*--d = *--s;
  80175d:	ff 4d f8             	decl   -0x8(%ebp)
  801760:	ff 4d fc             	decl   -0x4(%ebp)
  801763:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801766:	8a 10                	mov    (%eax),%dl
  801768:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80176b:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80176d:	8b 45 10             	mov    0x10(%ebp),%eax
  801770:	8d 50 ff             	lea    -0x1(%eax),%edx
  801773:	89 55 10             	mov    %edx,0x10(%ebp)
  801776:	85 c0                	test   %eax,%eax
  801778:	75 e3                	jne    80175d <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80177a:	eb 23                	jmp    80179f <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80177c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80177f:	8d 50 01             	lea    0x1(%eax),%edx
  801782:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801785:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801788:	8d 4a 01             	lea    0x1(%edx),%ecx
  80178b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80178e:	8a 12                	mov    (%edx),%dl
  801790:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801792:	8b 45 10             	mov    0x10(%ebp),%eax
  801795:	8d 50 ff             	lea    -0x1(%eax),%edx
  801798:	89 55 10             	mov    %edx,0x10(%ebp)
  80179b:	85 c0                	test   %eax,%eax
  80179d:	75 dd                	jne    80177c <memmove+0x54>
			*d++ = *s++;

	return dst;
  80179f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017a2:	c9                   	leave  
  8017a3:	c3                   	ret    

008017a4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8017a4:	55                   	push   %ebp
  8017a5:	89 e5                	mov    %esp,%ebp
  8017a7:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8017aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8017b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017b3:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8017b6:	eb 2a                	jmp    8017e2 <memcmp+0x3e>
		if (*s1 != *s2)
  8017b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017bb:	8a 10                	mov    (%eax),%dl
  8017bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017c0:	8a 00                	mov    (%eax),%al
  8017c2:	38 c2                	cmp    %al,%dl
  8017c4:	74 16                	je     8017dc <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8017c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017c9:	8a 00                	mov    (%eax),%al
  8017cb:	0f b6 d0             	movzbl %al,%edx
  8017ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017d1:	8a 00                	mov    (%eax),%al
  8017d3:	0f b6 c0             	movzbl %al,%eax
  8017d6:	29 c2                	sub    %eax,%edx
  8017d8:	89 d0                	mov    %edx,%eax
  8017da:	eb 18                	jmp    8017f4 <memcmp+0x50>
		s1++, s2++;
  8017dc:	ff 45 fc             	incl   -0x4(%ebp)
  8017df:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8017e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8017e5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8017e8:	89 55 10             	mov    %edx,0x10(%ebp)
  8017eb:	85 c0                	test   %eax,%eax
  8017ed:	75 c9                	jne    8017b8 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8017ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017f4:	c9                   	leave  
  8017f5:	c3                   	ret    

008017f6 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8017f6:	55                   	push   %ebp
  8017f7:	89 e5                	mov    %esp,%ebp
  8017f9:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8017fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8017ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801802:	01 d0                	add    %edx,%eax
  801804:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801807:	eb 15                	jmp    80181e <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801809:	8b 45 08             	mov    0x8(%ebp),%eax
  80180c:	8a 00                	mov    (%eax),%al
  80180e:	0f b6 d0             	movzbl %al,%edx
  801811:	8b 45 0c             	mov    0xc(%ebp),%eax
  801814:	0f b6 c0             	movzbl %al,%eax
  801817:	39 c2                	cmp    %eax,%edx
  801819:	74 0d                	je     801828 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80181b:	ff 45 08             	incl   0x8(%ebp)
  80181e:	8b 45 08             	mov    0x8(%ebp),%eax
  801821:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801824:	72 e3                	jb     801809 <memfind+0x13>
  801826:	eb 01                	jmp    801829 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801828:	90                   	nop
	return (void *) s;
  801829:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80182c:	c9                   	leave  
  80182d:	c3                   	ret    

0080182e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80182e:	55                   	push   %ebp
  80182f:	89 e5                	mov    %esp,%ebp
  801831:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801834:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80183b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801842:	eb 03                	jmp    801847 <strtol+0x19>
		s++;
  801844:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801847:	8b 45 08             	mov    0x8(%ebp),%eax
  80184a:	8a 00                	mov    (%eax),%al
  80184c:	3c 20                	cmp    $0x20,%al
  80184e:	74 f4                	je     801844 <strtol+0x16>
  801850:	8b 45 08             	mov    0x8(%ebp),%eax
  801853:	8a 00                	mov    (%eax),%al
  801855:	3c 09                	cmp    $0x9,%al
  801857:	74 eb                	je     801844 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801859:	8b 45 08             	mov    0x8(%ebp),%eax
  80185c:	8a 00                	mov    (%eax),%al
  80185e:	3c 2b                	cmp    $0x2b,%al
  801860:	75 05                	jne    801867 <strtol+0x39>
		s++;
  801862:	ff 45 08             	incl   0x8(%ebp)
  801865:	eb 13                	jmp    80187a <strtol+0x4c>
	else if (*s == '-')
  801867:	8b 45 08             	mov    0x8(%ebp),%eax
  80186a:	8a 00                	mov    (%eax),%al
  80186c:	3c 2d                	cmp    $0x2d,%al
  80186e:	75 0a                	jne    80187a <strtol+0x4c>
		s++, neg = 1;
  801870:	ff 45 08             	incl   0x8(%ebp)
  801873:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80187a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80187e:	74 06                	je     801886 <strtol+0x58>
  801880:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801884:	75 20                	jne    8018a6 <strtol+0x78>
  801886:	8b 45 08             	mov    0x8(%ebp),%eax
  801889:	8a 00                	mov    (%eax),%al
  80188b:	3c 30                	cmp    $0x30,%al
  80188d:	75 17                	jne    8018a6 <strtol+0x78>
  80188f:	8b 45 08             	mov    0x8(%ebp),%eax
  801892:	40                   	inc    %eax
  801893:	8a 00                	mov    (%eax),%al
  801895:	3c 78                	cmp    $0x78,%al
  801897:	75 0d                	jne    8018a6 <strtol+0x78>
		s += 2, base = 16;
  801899:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80189d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8018a4:	eb 28                	jmp    8018ce <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8018a6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8018aa:	75 15                	jne    8018c1 <strtol+0x93>
  8018ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8018af:	8a 00                	mov    (%eax),%al
  8018b1:	3c 30                	cmp    $0x30,%al
  8018b3:	75 0c                	jne    8018c1 <strtol+0x93>
		s++, base = 8;
  8018b5:	ff 45 08             	incl   0x8(%ebp)
  8018b8:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8018bf:	eb 0d                	jmp    8018ce <strtol+0xa0>
	else if (base == 0)
  8018c1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8018c5:	75 07                	jne    8018ce <strtol+0xa0>
		base = 10;
  8018c7:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8018ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d1:	8a 00                	mov    (%eax),%al
  8018d3:	3c 2f                	cmp    $0x2f,%al
  8018d5:	7e 19                	jle    8018f0 <strtol+0xc2>
  8018d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018da:	8a 00                	mov    (%eax),%al
  8018dc:	3c 39                	cmp    $0x39,%al
  8018de:	7f 10                	jg     8018f0 <strtol+0xc2>
			dig = *s - '0';
  8018e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e3:	8a 00                	mov    (%eax),%al
  8018e5:	0f be c0             	movsbl %al,%eax
  8018e8:	83 e8 30             	sub    $0x30,%eax
  8018eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018ee:	eb 42                	jmp    801932 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8018f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f3:	8a 00                	mov    (%eax),%al
  8018f5:	3c 60                	cmp    $0x60,%al
  8018f7:	7e 19                	jle    801912 <strtol+0xe4>
  8018f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fc:	8a 00                	mov    (%eax),%al
  8018fe:	3c 7a                	cmp    $0x7a,%al
  801900:	7f 10                	jg     801912 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801902:	8b 45 08             	mov    0x8(%ebp),%eax
  801905:	8a 00                	mov    (%eax),%al
  801907:	0f be c0             	movsbl %al,%eax
  80190a:	83 e8 57             	sub    $0x57,%eax
  80190d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801910:	eb 20                	jmp    801932 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801912:	8b 45 08             	mov    0x8(%ebp),%eax
  801915:	8a 00                	mov    (%eax),%al
  801917:	3c 40                	cmp    $0x40,%al
  801919:	7e 39                	jle    801954 <strtol+0x126>
  80191b:	8b 45 08             	mov    0x8(%ebp),%eax
  80191e:	8a 00                	mov    (%eax),%al
  801920:	3c 5a                	cmp    $0x5a,%al
  801922:	7f 30                	jg     801954 <strtol+0x126>
			dig = *s - 'A' + 10;
  801924:	8b 45 08             	mov    0x8(%ebp),%eax
  801927:	8a 00                	mov    (%eax),%al
  801929:	0f be c0             	movsbl %al,%eax
  80192c:	83 e8 37             	sub    $0x37,%eax
  80192f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801932:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801935:	3b 45 10             	cmp    0x10(%ebp),%eax
  801938:	7d 19                	jge    801953 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80193a:	ff 45 08             	incl   0x8(%ebp)
  80193d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801940:	0f af 45 10          	imul   0x10(%ebp),%eax
  801944:	89 c2                	mov    %eax,%edx
  801946:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801949:	01 d0                	add    %edx,%eax
  80194b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80194e:	e9 7b ff ff ff       	jmp    8018ce <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801953:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801954:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801958:	74 08                	je     801962 <strtol+0x134>
		*endptr = (char *) s;
  80195a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80195d:	8b 55 08             	mov    0x8(%ebp),%edx
  801960:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801962:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801966:	74 07                	je     80196f <strtol+0x141>
  801968:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80196b:	f7 d8                	neg    %eax
  80196d:	eb 03                	jmp    801972 <strtol+0x144>
  80196f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801972:	c9                   	leave  
  801973:	c3                   	ret    

00801974 <ltostr>:

void
ltostr(long value, char *str)
{
  801974:	55                   	push   %ebp
  801975:	89 e5                	mov    %esp,%ebp
  801977:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80197a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801981:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801988:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80198c:	79 13                	jns    8019a1 <ltostr+0x2d>
	{
		neg = 1;
  80198e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801995:	8b 45 0c             	mov    0xc(%ebp),%eax
  801998:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80199b:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80199e:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8019a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a4:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8019a9:	99                   	cltd   
  8019aa:	f7 f9                	idiv   %ecx
  8019ac:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8019af:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019b2:	8d 50 01             	lea    0x1(%eax),%edx
  8019b5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8019b8:	89 c2                	mov    %eax,%edx
  8019ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019bd:	01 d0                	add    %edx,%eax
  8019bf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8019c2:	83 c2 30             	add    $0x30,%edx
  8019c5:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8019c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019ca:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8019cf:	f7 e9                	imul   %ecx
  8019d1:	c1 fa 02             	sar    $0x2,%edx
  8019d4:	89 c8                	mov    %ecx,%eax
  8019d6:	c1 f8 1f             	sar    $0x1f,%eax
  8019d9:	29 c2                	sub    %eax,%edx
  8019db:	89 d0                	mov    %edx,%eax
  8019dd:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8019e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019e3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8019e8:	f7 e9                	imul   %ecx
  8019ea:	c1 fa 02             	sar    $0x2,%edx
  8019ed:	89 c8                	mov    %ecx,%eax
  8019ef:	c1 f8 1f             	sar    $0x1f,%eax
  8019f2:	29 c2                	sub    %eax,%edx
  8019f4:	89 d0                	mov    %edx,%eax
  8019f6:	c1 e0 02             	shl    $0x2,%eax
  8019f9:	01 d0                	add    %edx,%eax
  8019fb:	01 c0                	add    %eax,%eax
  8019fd:	29 c1                	sub    %eax,%ecx
  8019ff:	89 ca                	mov    %ecx,%edx
  801a01:	85 d2                	test   %edx,%edx
  801a03:	75 9c                	jne    8019a1 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801a05:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801a0c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a0f:	48                   	dec    %eax
  801a10:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801a13:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a17:	74 3d                	je     801a56 <ltostr+0xe2>
		start = 1 ;
  801a19:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801a20:	eb 34                	jmp    801a56 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801a22:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a25:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a28:	01 d0                	add    %edx,%eax
  801a2a:	8a 00                	mov    (%eax),%al
  801a2c:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801a2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a32:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a35:	01 c2                	add    %eax,%edx
  801a37:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801a3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a3d:	01 c8                	add    %ecx,%eax
  801a3f:	8a 00                	mov    (%eax),%al
  801a41:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801a43:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a46:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a49:	01 c2                	add    %eax,%edx
  801a4b:	8a 45 eb             	mov    -0x15(%ebp),%al
  801a4e:	88 02                	mov    %al,(%edx)
		start++ ;
  801a50:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801a53:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801a56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a59:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a5c:	7c c4                	jl     801a22 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801a5e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801a61:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a64:	01 d0                	add    %edx,%eax
  801a66:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801a69:	90                   	nop
  801a6a:	c9                   	leave  
  801a6b:	c3                   	ret    

00801a6c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801a6c:	55                   	push   %ebp
  801a6d:	89 e5                	mov    %esp,%ebp
  801a6f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801a72:	ff 75 08             	pushl  0x8(%ebp)
  801a75:	e8 54 fa ff ff       	call   8014ce <strlen>
  801a7a:	83 c4 04             	add    $0x4,%esp
  801a7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801a80:	ff 75 0c             	pushl  0xc(%ebp)
  801a83:	e8 46 fa ff ff       	call   8014ce <strlen>
  801a88:	83 c4 04             	add    $0x4,%esp
  801a8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801a8e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801a95:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801a9c:	eb 17                	jmp    801ab5 <strcconcat+0x49>
		final[s] = str1[s] ;
  801a9e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801aa1:	8b 45 10             	mov    0x10(%ebp),%eax
  801aa4:	01 c2                	add    %eax,%edx
  801aa6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  801aac:	01 c8                	add    %ecx,%eax
  801aae:	8a 00                	mov    (%eax),%al
  801ab0:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801ab2:	ff 45 fc             	incl   -0x4(%ebp)
  801ab5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ab8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801abb:	7c e1                	jl     801a9e <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801abd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801ac4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801acb:	eb 1f                	jmp    801aec <strcconcat+0x80>
		final[s++] = str2[i] ;
  801acd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ad0:	8d 50 01             	lea    0x1(%eax),%edx
  801ad3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801ad6:	89 c2                	mov    %eax,%edx
  801ad8:	8b 45 10             	mov    0x10(%ebp),%eax
  801adb:	01 c2                	add    %eax,%edx
  801add:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801ae0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ae3:	01 c8                	add    %ecx,%eax
  801ae5:	8a 00                	mov    (%eax),%al
  801ae7:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801ae9:	ff 45 f8             	incl   -0x8(%ebp)
  801aec:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801aef:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801af2:	7c d9                	jl     801acd <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801af4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801af7:	8b 45 10             	mov    0x10(%ebp),%eax
  801afa:	01 d0                	add    %edx,%eax
  801afc:	c6 00 00             	movb   $0x0,(%eax)
}
  801aff:	90                   	nop
  801b00:	c9                   	leave  
  801b01:	c3                   	ret    

00801b02 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801b02:	55                   	push   %ebp
  801b03:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801b05:	8b 45 14             	mov    0x14(%ebp),%eax
  801b08:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801b0e:	8b 45 14             	mov    0x14(%ebp),%eax
  801b11:	8b 00                	mov    (%eax),%eax
  801b13:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b1a:	8b 45 10             	mov    0x10(%ebp),%eax
  801b1d:	01 d0                	add    %edx,%eax
  801b1f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801b25:	eb 0c                	jmp    801b33 <strsplit+0x31>
			*string++ = 0;
  801b27:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2a:	8d 50 01             	lea    0x1(%eax),%edx
  801b2d:	89 55 08             	mov    %edx,0x8(%ebp)
  801b30:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801b33:	8b 45 08             	mov    0x8(%ebp),%eax
  801b36:	8a 00                	mov    (%eax),%al
  801b38:	84 c0                	test   %al,%al
  801b3a:	74 18                	je     801b54 <strsplit+0x52>
  801b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3f:	8a 00                	mov    (%eax),%al
  801b41:	0f be c0             	movsbl %al,%eax
  801b44:	50                   	push   %eax
  801b45:	ff 75 0c             	pushl  0xc(%ebp)
  801b48:	e8 13 fb ff ff       	call   801660 <strchr>
  801b4d:	83 c4 08             	add    $0x8,%esp
  801b50:	85 c0                	test   %eax,%eax
  801b52:	75 d3                	jne    801b27 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801b54:	8b 45 08             	mov    0x8(%ebp),%eax
  801b57:	8a 00                	mov    (%eax),%al
  801b59:	84 c0                	test   %al,%al
  801b5b:	74 5a                	je     801bb7 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801b5d:	8b 45 14             	mov    0x14(%ebp),%eax
  801b60:	8b 00                	mov    (%eax),%eax
  801b62:	83 f8 0f             	cmp    $0xf,%eax
  801b65:	75 07                	jne    801b6e <strsplit+0x6c>
		{
			return 0;
  801b67:	b8 00 00 00 00       	mov    $0x0,%eax
  801b6c:	eb 66                	jmp    801bd4 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801b6e:	8b 45 14             	mov    0x14(%ebp),%eax
  801b71:	8b 00                	mov    (%eax),%eax
  801b73:	8d 48 01             	lea    0x1(%eax),%ecx
  801b76:	8b 55 14             	mov    0x14(%ebp),%edx
  801b79:	89 0a                	mov    %ecx,(%edx)
  801b7b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b82:	8b 45 10             	mov    0x10(%ebp),%eax
  801b85:	01 c2                	add    %eax,%edx
  801b87:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801b8c:	eb 03                	jmp    801b91 <strsplit+0x8f>
			string++;
  801b8e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801b91:	8b 45 08             	mov    0x8(%ebp),%eax
  801b94:	8a 00                	mov    (%eax),%al
  801b96:	84 c0                	test   %al,%al
  801b98:	74 8b                	je     801b25 <strsplit+0x23>
  801b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9d:	8a 00                	mov    (%eax),%al
  801b9f:	0f be c0             	movsbl %al,%eax
  801ba2:	50                   	push   %eax
  801ba3:	ff 75 0c             	pushl  0xc(%ebp)
  801ba6:	e8 b5 fa ff ff       	call   801660 <strchr>
  801bab:	83 c4 08             	add    $0x8,%esp
  801bae:	85 c0                	test   %eax,%eax
  801bb0:	74 dc                	je     801b8e <strsplit+0x8c>
			string++;
	}
  801bb2:	e9 6e ff ff ff       	jmp    801b25 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801bb7:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801bb8:	8b 45 14             	mov    0x14(%ebp),%eax
  801bbb:	8b 00                	mov    (%eax),%eax
  801bbd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801bc4:	8b 45 10             	mov    0x10(%ebp),%eax
  801bc7:	01 d0                	add    %edx,%eax
  801bc9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801bcf:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801bd4:	c9                   	leave  
  801bd5:	c3                   	ret    

00801bd6 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801bd6:	55                   	push   %ebp
  801bd7:	89 e5                	mov    %esp,%ebp
  801bd9:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  801bdc:	83 ec 04             	sub    $0x4,%esp
  801bdf:	68 c4 2d 80 00       	push   $0x802dc4
  801be4:	6a 0e                	push   $0xe
  801be6:	68 fe 2d 80 00       	push   $0x802dfe
  801beb:	e8 a2 ed ff ff       	call   800992 <_panic>

00801bf0 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  801bf0:	55                   	push   %ebp
  801bf1:	89 e5                	mov    %esp,%ebp
  801bf3:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  801bf6:	a1 04 30 80 00       	mov    0x803004,%eax
  801bfb:	85 c0                	test   %eax,%eax
  801bfd:	74 0f                	je     801c0e <malloc+0x1e>
	{
		initialize_dyn_block_system();
  801bff:	e8 d2 ff ff ff       	call   801bd6 <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801c04:	c7 05 04 30 80 00 00 	movl   $0x0,0x803004
  801c0b:	00 00 00 
	}
	if (size == 0) return NULL ;
  801c0e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c12:	75 07                	jne    801c1b <malloc+0x2b>
  801c14:	b8 00 00 00 00       	mov    $0x0,%eax
  801c19:	eb 14                	jmp    801c2f <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801c1b:	83 ec 04             	sub    $0x4,%esp
  801c1e:	68 0c 2e 80 00       	push   $0x802e0c
  801c23:	6a 2e                	push   $0x2e
  801c25:	68 fe 2d 80 00       	push   $0x802dfe
  801c2a:	e8 63 ed ff ff       	call   800992 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  801c2f:	c9                   	leave  
  801c30:	c3                   	ret    

00801c31 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801c31:	55                   	push   %ebp
  801c32:	89 e5                	mov    %esp,%ebp
  801c34:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801c37:	83 ec 04             	sub    $0x4,%esp
  801c3a:	68 34 2e 80 00       	push   $0x802e34
  801c3f:	6a 49                	push   $0x49
  801c41:	68 fe 2d 80 00       	push   $0x802dfe
  801c46:	e8 47 ed ff ff       	call   800992 <_panic>

00801c4b <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801c4b:	55                   	push   %ebp
  801c4c:	89 e5                	mov    %esp,%ebp
  801c4e:	83 ec 18             	sub    $0x18,%esp
  801c51:	8b 45 10             	mov    0x10(%ebp),%eax
  801c54:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801c57:	83 ec 04             	sub    $0x4,%esp
  801c5a:	68 58 2e 80 00       	push   $0x802e58
  801c5f:	6a 57                	push   $0x57
  801c61:	68 fe 2d 80 00       	push   $0x802dfe
  801c66:	e8 27 ed ff ff       	call   800992 <_panic>

00801c6b <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801c6b:	55                   	push   %ebp
  801c6c:	89 e5                	mov    %esp,%ebp
  801c6e:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801c71:	83 ec 04             	sub    $0x4,%esp
  801c74:	68 80 2e 80 00       	push   $0x802e80
  801c79:	6a 60                	push   $0x60
  801c7b:	68 fe 2d 80 00       	push   $0x802dfe
  801c80:	e8 0d ed ff ff       	call   800992 <_panic>

00801c85 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801c85:	55                   	push   %ebp
  801c86:	89 e5                	mov    %esp,%ebp
  801c88:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801c8b:	83 ec 04             	sub    $0x4,%esp
  801c8e:	68 a4 2e 80 00       	push   $0x802ea4
  801c93:	6a 7c                	push   $0x7c
  801c95:	68 fe 2d 80 00       	push   $0x802dfe
  801c9a:	e8 f3 ec ff ff       	call   800992 <_panic>

00801c9f <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  801c9f:	55                   	push   %ebp
  801ca0:	89 e5                	mov    %esp,%ebp
  801ca2:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801ca5:	83 ec 04             	sub    $0x4,%esp
  801ca8:	68 cc 2e 80 00       	push   $0x802ecc
  801cad:	68 86 00 00 00       	push   $0x86
  801cb2:	68 fe 2d 80 00       	push   $0x802dfe
  801cb7:	e8 d6 ec ff ff       	call   800992 <_panic>

00801cbc <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801cbc:	55                   	push   %ebp
  801cbd:	89 e5                	mov    %esp,%ebp
  801cbf:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801cc2:	83 ec 04             	sub    $0x4,%esp
  801cc5:	68 f0 2e 80 00       	push   $0x802ef0
  801cca:	68 91 00 00 00       	push   $0x91
  801ccf:	68 fe 2d 80 00       	push   $0x802dfe
  801cd4:	e8 b9 ec ff ff       	call   800992 <_panic>

00801cd9 <shrink>:

}
void shrink(uint32 newSize)
{
  801cd9:	55                   	push   %ebp
  801cda:	89 e5                	mov    %esp,%ebp
  801cdc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801cdf:	83 ec 04             	sub    $0x4,%esp
  801ce2:	68 f0 2e 80 00       	push   $0x802ef0
  801ce7:	68 96 00 00 00       	push   $0x96
  801cec:	68 fe 2d 80 00       	push   $0x802dfe
  801cf1:	e8 9c ec ff ff       	call   800992 <_panic>

00801cf6 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801cf6:	55                   	push   %ebp
  801cf7:	89 e5                	mov    %esp,%ebp
  801cf9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801cfc:	83 ec 04             	sub    $0x4,%esp
  801cff:	68 f0 2e 80 00       	push   $0x802ef0
  801d04:	68 9b 00 00 00       	push   $0x9b
  801d09:	68 fe 2d 80 00       	push   $0x802dfe
  801d0e:	e8 7f ec ff ff       	call   800992 <_panic>

00801d13 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801d13:	55                   	push   %ebp
  801d14:	89 e5                	mov    %esp,%ebp
  801d16:	57                   	push   %edi
  801d17:	56                   	push   %esi
  801d18:	53                   	push   %ebx
  801d19:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d22:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d25:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d28:	8b 7d 18             	mov    0x18(%ebp),%edi
  801d2b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801d2e:	cd 30                	int    $0x30
  801d30:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801d33:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801d36:	83 c4 10             	add    $0x10,%esp
  801d39:	5b                   	pop    %ebx
  801d3a:	5e                   	pop    %esi
  801d3b:	5f                   	pop    %edi
  801d3c:	5d                   	pop    %ebp
  801d3d:	c3                   	ret    

00801d3e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801d3e:	55                   	push   %ebp
  801d3f:	89 e5                	mov    %esp,%ebp
  801d41:	83 ec 04             	sub    $0x4,%esp
  801d44:	8b 45 10             	mov    0x10(%ebp),%eax
  801d47:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801d4a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d51:	6a 00                	push   $0x0
  801d53:	6a 00                	push   $0x0
  801d55:	52                   	push   %edx
  801d56:	ff 75 0c             	pushl  0xc(%ebp)
  801d59:	50                   	push   %eax
  801d5a:	6a 00                	push   $0x0
  801d5c:	e8 b2 ff ff ff       	call   801d13 <syscall>
  801d61:	83 c4 18             	add    $0x18,%esp
}
  801d64:	90                   	nop
  801d65:	c9                   	leave  
  801d66:	c3                   	ret    

00801d67 <sys_cgetc>:

int
sys_cgetc(void)
{
  801d67:	55                   	push   %ebp
  801d68:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 00                	push   $0x0
  801d72:	6a 00                	push   $0x0
  801d74:	6a 01                	push   $0x1
  801d76:	e8 98 ff ff ff       	call   801d13 <syscall>
  801d7b:	83 c4 18             	add    $0x18,%esp
}
  801d7e:	c9                   	leave  
  801d7f:	c3                   	ret    

00801d80 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801d80:	55                   	push   %ebp
  801d81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801d83:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d86:	8b 45 08             	mov    0x8(%ebp),%eax
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	52                   	push   %edx
  801d90:	50                   	push   %eax
  801d91:	6a 05                	push   $0x5
  801d93:	e8 7b ff ff ff       	call   801d13 <syscall>
  801d98:	83 c4 18             	add    $0x18,%esp
}
  801d9b:	c9                   	leave  
  801d9c:	c3                   	ret    

00801d9d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801d9d:	55                   	push   %ebp
  801d9e:	89 e5                	mov    %esp,%ebp
  801da0:	56                   	push   %esi
  801da1:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801da2:	8b 75 18             	mov    0x18(%ebp),%esi
  801da5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801da8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dab:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dae:	8b 45 08             	mov    0x8(%ebp),%eax
  801db1:	56                   	push   %esi
  801db2:	53                   	push   %ebx
  801db3:	51                   	push   %ecx
  801db4:	52                   	push   %edx
  801db5:	50                   	push   %eax
  801db6:	6a 06                	push   $0x6
  801db8:	e8 56 ff ff ff       	call   801d13 <syscall>
  801dbd:	83 c4 18             	add    $0x18,%esp
}
  801dc0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dc3:	5b                   	pop    %ebx
  801dc4:	5e                   	pop    %esi
  801dc5:	5d                   	pop    %ebp
  801dc6:	c3                   	ret    

00801dc7 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801dc7:	55                   	push   %ebp
  801dc8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801dca:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 00                	push   $0x0
  801dd6:	52                   	push   %edx
  801dd7:	50                   	push   %eax
  801dd8:	6a 07                	push   $0x7
  801dda:	e8 34 ff ff ff       	call   801d13 <syscall>
  801ddf:	83 c4 18             	add    $0x18,%esp
}
  801de2:	c9                   	leave  
  801de3:	c3                   	ret    

00801de4 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801de4:	55                   	push   %ebp
  801de5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801de7:	6a 00                	push   $0x0
  801de9:	6a 00                	push   $0x0
  801deb:	6a 00                	push   $0x0
  801ded:	ff 75 0c             	pushl  0xc(%ebp)
  801df0:	ff 75 08             	pushl  0x8(%ebp)
  801df3:	6a 08                	push   $0x8
  801df5:	e8 19 ff ff ff       	call   801d13 <syscall>
  801dfa:	83 c4 18             	add    $0x18,%esp
}
  801dfd:	c9                   	leave  
  801dfe:	c3                   	ret    

00801dff <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801dff:	55                   	push   %ebp
  801e00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801e02:	6a 00                	push   $0x0
  801e04:	6a 00                	push   $0x0
  801e06:	6a 00                	push   $0x0
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 09                	push   $0x9
  801e0e:	e8 00 ff ff ff       	call   801d13 <syscall>
  801e13:	83 c4 18             	add    $0x18,%esp
}
  801e16:	c9                   	leave  
  801e17:	c3                   	ret    

00801e18 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801e18:	55                   	push   %ebp
  801e19:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801e1b:	6a 00                	push   $0x0
  801e1d:	6a 00                	push   $0x0
  801e1f:	6a 00                	push   $0x0
  801e21:	6a 00                	push   $0x0
  801e23:	6a 00                	push   $0x0
  801e25:	6a 0a                	push   $0xa
  801e27:	e8 e7 fe ff ff       	call   801d13 <syscall>
  801e2c:	83 c4 18             	add    $0x18,%esp
}
  801e2f:	c9                   	leave  
  801e30:	c3                   	ret    

00801e31 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801e31:	55                   	push   %ebp
  801e32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801e34:	6a 00                	push   $0x0
  801e36:	6a 00                	push   $0x0
  801e38:	6a 00                	push   $0x0
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 0b                	push   $0xb
  801e40:	e8 ce fe ff ff       	call   801d13 <syscall>
  801e45:	83 c4 18             	add    $0x18,%esp
}
  801e48:	c9                   	leave  
  801e49:	c3                   	ret    

00801e4a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801e4a:	55                   	push   %ebp
  801e4b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801e4d:	6a 00                	push   $0x0
  801e4f:	6a 00                	push   $0x0
  801e51:	6a 00                	push   $0x0
  801e53:	ff 75 0c             	pushl  0xc(%ebp)
  801e56:	ff 75 08             	pushl  0x8(%ebp)
  801e59:	6a 0f                	push   $0xf
  801e5b:	e8 b3 fe ff ff       	call   801d13 <syscall>
  801e60:	83 c4 18             	add    $0x18,%esp
	return;
  801e63:	90                   	nop
}
  801e64:	c9                   	leave  
  801e65:	c3                   	ret    

00801e66 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801e66:	55                   	push   %ebp
  801e67:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 00                	push   $0x0
  801e6f:	ff 75 0c             	pushl  0xc(%ebp)
  801e72:	ff 75 08             	pushl  0x8(%ebp)
  801e75:	6a 10                	push   $0x10
  801e77:	e8 97 fe ff ff       	call   801d13 <syscall>
  801e7c:	83 c4 18             	add    $0x18,%esp
	return ;
  801e7f:	90                   	nop
}
  801e80:	c9                   	leave  
  801e81:	c3                   	ret    

00801e82 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e82:	55                   	push   %ebp
  801e83:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e85:	6a 00                	push   $0x0
  801e87:	6a 00                	push   $0x0
  801e89:	ff 75 10             	pushl  0x10(%ebp)
  801e8c:	ff 75 0c             	pushl  0xc(%ebp)
  801e8f:	ff 75 08             	pushl  0x8(%ebp)
  801e92:	6a 11                	push   $0x11
  801e94:	e8 7a fe ff ff       	call   801d13 <syscall>
  801e99:	83 c4 18             	add    $0x18,%esp
	return ;
  801e9c:	90                   	nop
}
  801e9d:	c9                   	leave  
  801e9e:	c3                   	ret    

00801e9f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801e9f:	55                   	push   %ebp
  801ea0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801ea2:	6a 00                	push   $0x0
  801ea4:	6a 00                	push   $0x0
  801ea6:	6a 00                	push   $0x0
  801ea8:	6a 00                	push   $0x0
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 0c                	push   $0xc
  801eae:	e8 60 fe ff ff       	call   801d13 <syscall>
  801eb3:	83 c4 18             	add    $0x18,%esp
}
  801eb6:	c9                   	leave  
  801eb7:	c3                   	ret    

00801eb8 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801eb8:	55                   	push   %ebp
  801eb9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ebb:	6a 00                	push   $0x0
  801ebd:	6a 00                	push   $0x0
  801ebf:	6a 00                	push   $0x0
  801ec1:	6a 00                	push   $0x0
  801ec3:	ff 75 08             	pushl  0x8(%ebp)
  801ec6:	6a 0d                	push   $0xd
  801ec8:	e8 46 fe ff ff       	call   801d13 <syscall>
  801ecd:	83 c4 18             	add    $0x18,%esp
}
  801ed0:	c9                   	leave  
  801ed1:	c3                   	ret    

00801ed2 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ed2:	55                   	push   %ebp
  801ed3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ed5:	6a 00                	push   $0x0
  801ed7:	6a 00                	push   $0x0
  801ed9:	6a 00                	push   $0x0
  801edb:	6a 00                	push   $0x0
  801edd:	6a 00                	push   $0x0
  801edf:	6a 0e                	push   $0xe
  801ee1:	e8 2d fe ff ff       	call   801d13 <syscall>
  801ee6:	83 c4 18             	add    $0x18,%esp
}
  801ee9:	90                   	nop
  801eea:	c9                   	leave  
  801eeb:	c3                   	ret    

00801eec <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801eec:	55                   	push   %ebp
  801eed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801eef:	6a 00                	push   $0x0
  801ef1:	6a 00                	push   $0x0
  801ef3:	6a 00                	push   $0x0
  801ef5:	6a 00                	push   $0x0
  801ef7:	6a 00                	push   $0x0
  801ef9:	6a 13                	push   $0x13
  801efb:	e8 13 fe ff ff       	call   801d13 <syscall>
  801f00:	83 c4 18             	add    $0x18,%esp
}
  801f03:	90                   	nop
  801f04:	c9                   	leave  
  801f05:	c3                   	ret    

00801f06 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801f06:	55                   	push   %ebp
  801f07:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801f09:	6a 00                	push   $0x0
  801f0b:	6a 00                	push   $0x0
  801f0d:	6a 00                	push   $0x0
  801f0f:	6a 00                	push   $0x0
  801f11:	6a 00                	push   $0x0
  801f13:	6a 14                	push   $0x14
  801f15:	e8 f9 fd ff ff       	call   801d13 <syscall>
  801f1a:	83 c4 18             	add    $0x18,%esp
}
  801f1d:	90                   	nop
  801f1e:	c9                   	leave  
  801f1f:	c3                   	ret    

00801f20 <sys_cputc>:


void
sys_cputc(const char c)
{
  801f20:	55                   	push   %ebp
  801f21:	89 e5                	mov    %esp,%ebp
  801f23:	83 ec 04             	sub    $0x4,%esp
  801f26:	8b 45 08             	mov    0x8(%ebp),%eax
  801f29:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801f2c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f30:	6a 00                	push   $0x0
  801f32:	6a 00                	push   $0x0
  801f34:	6a 00                	push   $0x0
  801f36:	6a 00                	push   $0x0
  801f38:	50                   	push   %eax
  801f39:	6a 15                	push   $0x15
  801f3b:	e8 d3 fd ff ff       	call   801d13 <syscall>
  801f40:	83 c4 18             	add    $0x18,%esp
}
  801f43:	90                   	nop
  801f44:	c9                   	leave  
  801f45:	c3                   	ret    

00801f46 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801f46:	55                   	push   %ebp
  801f47:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801f49:	6a 00                	push   $0x0
  801f4b:	6a 00                	push   $0x0
  801f4d:	6a 00                	push   $0x0
  801f4f:	6a 00                	push   $0x0
  801f51:	6a 00                	push   $0x0
  801f53:	6a 16                	push   $0x16
  801f55:	e8 b9 fd ff ff       	call   801d13 <syscall>
  801f5a:	83 c4 18             	add    $0x18,%esp
}
  801f5d:	90                   	nop
  801f5e:	c9                   	leave  
  801f5f:	c3                   	ret    

00801f60 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801f60:	55                   	push   %ebp
  801f61:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801f63:	8b 45 08             	mov    0x8(%ebp),%eax
  801f66:	6a 00                	push   $0x0
  801f68:	6a 00                	push   $0x0
  801f6a:	6a 00                	push   $0x0
  801f6c:	ff 75 0c             	pushl  0xc(%ebp)
  801f6f:	50                   	push   %eax
  801f70:	6a 17                	push   $0x17
  801f72:	e8 9c fd ff ff       	call   801d13 <syscall>
  801f77:	83 c4 18             	add    $0x18,%esp
}
  801f7a:	c9                   	leave  
  801f7b:	c3                   	ret    

00801f7c <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801f7c:	55                   	push   %ebp
  801f7d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f82:	8b 45 08             	mov    0x8(%ebp),%eax
  801f85:	6a 00                	push   $0x0
  801f87:	6a 00                	push   $0x0
  801f89:	6a 00                	push   $0x0
  801f8b:	52                   	push   %edx
  801f8c:	50                   	push   %eax
  801f8d:	6a 1a                	push   $0x1a
  801f8f:	e8 7f fd ff ff       	call   801d13 <syscall>
  801f94:	83 c4 18             	add    $0x18,%esp
}
  801f97:	c9                   	leave  
  801f98:	c3                   	ret    

00801f99 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f99:	55                   	push   %ebp
  801f9a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa2:	6a 00                	push   $0x0
  801fa4:	6a 00                	push   $0x0
  801fa6:	6a 00                	push   $0x0
  801fa8:	52                   	push   %edx
  801fa9:	50                   	push   %eax
  801faa:	6a 18                	push   $0x18
  801fac:	e8 62 fd ff ff       	call   801d13 <syscall>
  801fb1:	83 c4 18             	add    $0x18,%esp
}
  801fb4:	90                   	nop
  801fb5:	c9                   	leave  
  801fb6:	c3                   	ret    

00801fb7 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801fb7:	55                   	push   %ebp
  801fb8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801fba:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc0:	6a 00                	push   $0x0
  801fc2:	6a 00                	push   $0x0
  801fc4:	6a 00                	push   $0x0
  801fc6:	52                   	push   %edx
  801fc7:	50                   	push   %eax
  801fc8:	6a 19                	push   $0x19
  801fca:	e8 44 fd ff ff       	call   801d13 <syscall>
  801fcf:	83 c4 18             	add    $0x18,%esp
}
  801fd2:	90                   	nop
  801fd3:	c9                   	leave  
  801fd4:	c3                   	ret    

00801fd5 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801fd5:	55                   	push   %ebp
  801fd6:	89 e5                	mov    %esp,%ebp
  801fd8:	83 ec 04             	sub    $0x4,%esp
  801fdb:	8b 45 10             	mov    0x10(%ebp),%eax
  801fde:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801fe1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801fe4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  801feb:	6a 00                	push   $0x0
  801fed:	51                   	push   %ecx
  801fee:	52                   	push   %edx
  801fef:	ff 75 0c             	pushl  0xc(%ebp)
  801ff2:	50                   	push   %eax
  801ff3:	6a 1b                	push   $0x1b
  801ff5:	e8 19 fd ff ff       	call   801d13 <syscall>
  801ffa:	83 c4 18             	add    $0x18,%esp
}
  801ffd:	c9                   	leave  
  801ffe:	c3                   	ret    

00801fff <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801fff:	55                   	push   %ebp
  802000:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802002:	8b 55 0c             	mov    0xc(%ebp),%edx
  802005:	8b 45 08             	mov    0x8(%ebp),%eax
  802008:	6a 00                	push   $0x0
  80200a:	6a 00                	push   $0x0
  80200c:	6a 00                	push   $0x0
  80200e:	52                   	push   %edx
  80200f:	50                   	push   %eax
  802010:	6a 1c                	push   $0x1c
  802012:	e8 fc fc ff ff       	call   801d13 <syscall>
  802017:	83 c4 18             	add    $0x18,%esp
}
  80201a:	c9                   	leave  
  80201b:	c3                   	ret    

0080201c <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80201c:	55                   	push   %ebp
  80201d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80201f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802022:	8b 55 0c             	mov    0xc(%ebp),%edx
  802025:	8b 45 08             	mov    0x8(%ebp),%eax
  802028:	6a 00                	push   $0x0
  80202a:	6a 00                	push   $0x0
  80202c:	51                   	push   %ecx
  80202d:	52                   	push   %edx
  80202e:	50                   	push   %eax
  80202f:	6a 1d                	push   $0x1d
  802031:	e8 dd fc ff ff       	call   801d13 <syscall>
  802036:	83 c4 18             	add    $0x18,%esp
}
  802039:	c9                   	leave  
  80203a:	c3                   	ret    

0080203b <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80203b:	55                   	push   %ebp
  80203c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80203e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802041:	8b 45 08             	mov    0x8(%ebp),%eax
  802044:	6a 00                	push   $0x0
  802046:	6a 00                	push   $0x0
  802048:	6a 00                	push   $0x0
  80204a:	52                   	push   %edx
  80204b:	50                   	push   %eax
  80204c:	6a 1e                	push   $0x1e
  80204e:	e8 c0 fc ff ff       	call   801d13 <syscall>
  802053:	83 c4 18             	add    $0x18,%esp
}
  802056:	c9                   	leave  
  802057:	c3                   	ret    

00802058 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802058:	55                   	push   %ebp
  802059:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80205b:	6a 00                	push   $0x0
  80205d:	6a 00                	push   $0x0
  80205f:	6a 00                	push   $0x0
  802061:	6a 00                	push   $0x0
  802063:	6a 00                	push   $0x0
  802065:	6a 1f                	push   $0x1f
  802067:	e8 a7 fc ff ff       	call   801d13 <syscall>
  80206c:	83 c4 18             	add    $0x18,%esp
}
  80206f:	c9                   	leave  
  802070:	c3                   	ret    

00802071 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802071:	55                   	push   %ebp
  802072:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802074:	8b 45 08             	mov    0x8(%ebp),%eax
  802077:	6a 00                	push   $0x0
  802079:	ff 75 14             	pushl  0x14(%ebp)
  80207c:	ff 75 10             	pushl  0x10(%ebp)
  80207f:	ff 75 0c             	pushl  0xc(%ebp)
  802082:	50                   	push   %eax
  802083:	6a 20                	push   $0x20
  802085:	e8 89 fc ff ff       	call   801d13 <syscall>
  80208a:	83 c4 18             	add    $0x18,%esp
}
  80208d:	c9                   	leave  
  80208e:	c3                   	ret    

0080208f <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80208f:	55                   	push   %ebp
  802090:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802092:	8b 45 08             	mov    0x8(%ebp),%eax
  802095:	6a 00                	push   $0x0
  802097:	6a 00                	push   $0x0
  802099:	6a 00                	push   $0x0
  80209b:	6a 00                	push   $0x0
  80209d:	50                   	push   %eax
  80209e:	6a 21                	push   $0x21
  8020a0:	e8 6e fc ff ff       	call   801d13 <syscall>
  8020a5:	83 c4 18             	add    $0x18,%esp
}
  8020a8:	90                   	nop
  8020a9:	c9                   	leave  
  8020aa:	c3                   	ret    

008020ab <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8020ab:	55                   	push   %ebp
  8020ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8020ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b1:	6a 00                	push   $0x0
  8020b3:	6a 00                	push   $0x0
  8020b5:	6a 00                	push   $0x0
  8020b7:	6a 00                	push   $0x0
  8020b9:	50                   	push   %eax
  8020ba:	6a 22                	push   $0x22
  8020bc:	e8 52 fc ff ff       	call   801d13 <syscall>
  8020c1:	83 c4 18             	add    $0x18,%esp
}
  8020c4:	c9                   	leave  
  8020c5:	c3                   	ret    

008020c6 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8020c6:	55                   	push   %ebp
  8020c7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8020c9:	6a 00                	push   $0x0
  8020cb:	6a 00                	push   $0x0
  8020cd:	6a 00                	push   $0x0
  8020cf:	6a 00                	push   $0x0
  8020d1:	6a 00                	push   $0x0
  8020d3:	6a 02                	push   $0x2
  8020d5:	e8 39 fc ff ff       	call   801d13 <syscall>
  8020da:	83 c4 18             	add    $0x18,%esp
}
  8020dd:	c9                   	leave  
  8020de:	c3                   	ret    

008020df <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8020df:	55                   	push   %ebp
  8020e0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8020e2:	6a 00                	push   $0x0
  8020e4:	6a 00                	push   $0x0
  8020e6:	6a 00                	push   $0x0
  8020e8:	6a 00                	push   $0x0
  8020ea:	6a 00                	push   $0x0
  8020ec:	6a 03                	push   $0x3
  8020ee:	e8 20 fc ff ff       	call   801d13 <syscall>
  8020f3:	83 c4 18             	add    $0x18,%esp
}
  8020f6:	c9                   	leave  
  8020f7:	c3                   	ret    

008020f8 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8020f8:	55                   	push   %ebp
  8020f9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8020fb:	6a 00                	push   $0x0
  8020fd:	6a 00                	push   $0x0
  8020ff:	6a 00                	push   $0x0
  802101:	6a 00                	push   $0x0
  802103:	6a 00                	push   $0x0
  802105:	6a 04                	push   $0x4
  802107:	e8 07 fc ff ff       	call   801d13 <syscall>
  80210c:	83 c4 18             	add    $0x18,%esp
}
  80210f:	c9                   	leave  
  802110:	c3                   	ret    

00802111 <sys_exit_env>:


void sys_exit_env(void)
{
  802111:	55                   	push   %ebp
  802112:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802114:	6a 00                	push   $0x0
  802116:	6a 00                	push   $0x0
  802118:	6a 00                	push   $0x0
  80211a:	6a 00                	push   $0x0
  80211c:	6a 00                	push   $0x0
  80211e:	6a 23                	push   $0x23
  802120:	e8 ee fb ff ff       	call   801d13 <syscall>
  802125:	83 c4 18             	add    $0x18,%esp
}
  802128:	90                   	nop
  802129:	c9                   	leave  
  80212a:	c3                   	ret    

0080212b <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80212b:	55                   	push   %ebp
  80212c:	89 e5                	mov    %esp,%ebp
  80212e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802131:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802134:	8d 50 04             	lea    0x4(%eax),%edx
  802137:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80213a:	6a 00                	push   $0x0
  80213c:	6a 00                	push   $0x0
  80213e:	6a 00                	push   $0x0
  802140:	52                   	push   %edx
  802141:	50                   	push   %eax
  802142:	6a 24                	push   $0x24
  802144:	e8 ca fb ff ff       	call   801d13 <syscall>
  802149:	83 c4 18             	add    $0x18,%esp
	return result;
  80214c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80214f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802152:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802155:	89 01                	mov    %eax,(%ecx)
  802157:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80215a:	8b 45 08             	mov    0x8(%ebp),%eax
  80215d:	c9                   	leave  
  80215e:	c2 04 00             	ret    $0x4

00802161 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802161:	55                   	push   %ebp
  802162:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802164:	6a 00                	push   $0x0
  802166:	6a 00                	push   $0x0
  802168:	ff 75 10             	pushl  0x10(%ebp)
  80216b:	ff 75 0c             	pushl  0xc(%ebp)
  80216e:	ff 75 08             	pushl  0x8(%ebp)
  802171:	6a 12                	push   $0x12
  802173:	e8 9b fb ff ff       	call   801d13 <syscall>
  802178:	83 c4 18             	add    $0x18,%esp
	return ;
  80217b:	90                   	nop
}
  80217c:	c9                   	leave  
  80217d:	c3                   	ret    

0080217e <sys_rcr2>:
uint32 sys_rcr2()
{
  80217e:	55                   	push   %ebp
  80217f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802181:	6a 00                	push   $0x0
  802183:	6a 00                	push   $0x0
  802185:	6a 00                	push   $0x0
  802187:	6a 00                	push   $0x0
  802189:	6a 00                	push   $0x0
  80218b:	6a 25                	push   $0x25
  80218d:	e8 81 fb ff ff       	call   801d13 <syscall>
  802192:	83 c4 18             	add    $0x18,%esp
}
  802195:	c9                   	leave  
  802196:	c3                   	ret    

00802197 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802197:	55                   	push   %ebp
  802198:	89 e5                	mov    %esp,%ebp
  80219a:	83 ec 04             	sub    $0x4,%esp
  80219d:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8021a3:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8021a7:	6a 00                	push   $0x0
  8021a9:	6a 00                	push   $0x0
  8021ab:	6a 00                	push   $0x0
  8021ad:	6a 00                	push   $0x0
  8021af:	50                   	push   %eax
  8021b0:	6a 26                	push   $0x26
  8021b2:	e8 5c fb ff ff       	call   801d13 <syscall>
  8021b7:	83 c4 18             	add    $0x18,%esp
	return ;
  8021ba:	90                   	nop
}
  8021bb:	c9                   	leave  
  8021bc:	c3                   	ret    

008021bd <rsttst>:
void rsttst()
{
  8021bd:	55                   	push   %ebp
  8021be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8021c0:	6a 00                	push   $0x0
  8021c2:	6a 00                	push   $0x0
  8021c4:	6a 00                	push   $0x0
  8021c6:	6a 00                	push   $0x0
  8021c8:	6a 00                	push   $0x0
  8021ca:	6a 28                	push   $0x28
  8021cc:	e8 42 fb ff ff       	call   801d13 <syscall>
  8021d1:	83 c4 18             	add    $0x18,%esp
	return ;
  8021d4:	90                   	nop
}
  8021d5:	c9                   	leave  
  8021d6:	c3                   	ret    

008021d7 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8021d7:	55                   	push   %ebp
  8021d8:	89 e5                	mov    %esp,%ebp
  8021da:	83 ec 04             	sub    $0x4,%esp
  8021dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8021e0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8021e3:	8b 55 18             	mov    0x18(%ebp),%edx
  8021e6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8021ea:	52                   	push   %edx
  8021eb:	50                   	push   %eax
  8021ec:	ff 75 10             	pushl  0x10(%ebp)
  8021ef:	ff 75 0c             	pushl  0xc(%ebp)
  8021f2:	ff 75 08             	pushl  0x8(%ebp)
  8021f5:	6a 27                	push   $0x27
  8021f7:	e8 17 fb ff ff       	call   801d13 <syscall>
  8021fc:	83 c4 18             	add    $0x18,%esp
	return ;
  8021ff:	90                   	nop
}
  802200:	c9                   	leave  
  802201:	c3                   	ret    

00802202 <chktst>:
void chktst(uint32 n)
{
  802202:	55                   	push   %ebp
  802203:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802205:	6a 00                	push   $0x0
  802207:	6a 00                	push   $0x0
  802209:	6a 00                	push   $0x0
  80220b:	6a 00                	push   $0x0
  80220d:	ff 75 08             	pushl  0x8(%ebp)
  802210:	6a 29                	push   $0x29
  802212:	e8 fc fa ff ff       	call   801d13 <syscall>
  802217:	83 c4 18             	add    $0x18,%esp
	return ;
  80221a:	90                   	nop
}
  80221b:	c9                   	leave  
  80221c:	c3                   	ret    

0080221d <inctst>:

void inctst()
{
  80221d:	55                   	push   %ebp
  80221e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802220:	6a 00                	push   $0x0
  802222:	6a 00                	push   $0x0
  802224:	6a 00                	push   $0x0
  802226:	6a 00                	push   $0x0
  802228:	6a 00                	push   $0x0
  80222a:	6a 2a                	push   $0x2a
  80222c:	e8 e2 fa ff ff       	call   801d13 <syscall>
  802231:	83 c4 18             	add    $0x18,%esp
	return ;
  802234:	90                   	nop
}
  802235:	c9                   	leave  
  802236:	c3                   	ret    

00802237 <gettst>:
uint32 gettst()
{
  802237:	55                   	push   %ebp
  802238:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80223a:	6a 00                	push   $0x0
  80223c:	6a 00                	push   $0x0
  80223e:	6a 00                	push   $0x0
  802240:	6a 00                	push   $0x0
  802242:	6a 00                	push   $0x0
  802244:	6a 2b                	push   $0x2b
  802246:	e8 c8 fa ff ff       	call   801d13 <syscall>
  80224b:	83 c4 18             	add    $0x18,%esp
}
  80224e:	c9                   	leave  
  80224f:	c3                   	ret    

00802250 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802250:	55                   	push   %ebp
  802251:	89 e5                	mov    %esp,%ebp
  802253:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802256:	6a 00                	push   $0x0
  802258:	6a 00                	push   $0x0
  80225a:	6a 00                	push   $0x0
  80225c:	6a 00                	push   $0x0
  80225e:	6a 00                	push   $0x0
  802260:	6a 2c                	push   $0x2c
  802262:	e8 ac fa ff ff       	call   801d13 <syscall>
  802267:	83 c4 18             	add    $0x18,%esp
  80226a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80226d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802271:	75 07                	jne    80227a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802273:	b8 01 00 00 00       	mov    $0x1,%eax
  802278:	eb 05                	jmp    80227f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80227a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80227f:	c9                   	leave  
  802280:	c3                   	ret    

00802281 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802281:	55                   	push   %ebp
  802282:	89 e5                	mov    %esp,%ebp
  802284:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802287:	6a 00                	push   $0x0
  802289:	6a 00                	push   $0x0
  80228b:	6a 00                	push   $0x0
  80228d:	6a 00                	push   $0x0
  80228f:	6a 00                	push   $0x0
  802291:	6a 2c                	push   $0x2c
  802293:	e8 7b fa ff ff       	call   801d13 <syscall>
  802298:	83 c4 18             	add    $0x18,%esp
  80229b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80229e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8022a2:	75 07                	jne    8022ab <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8022a4:	b8 01 00 00 00       	mov    $0x1,%eax
  8022a9:	eb 05                	jmp    8022b0 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8022ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022b0:	c9                   	leave  
  8022b1:	c3                   	ret    

008022b2 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8022b2:	55                   	push   %ebp
  8022b3:	89 e5                	mov    %esp,%ebp
  8022b5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022b8:	6a 00                	push   $0x0
  8022ba:	6a 00                	push   $0x0
  8022bc:	6a 00                	push   $0x0
  8022be:	6a 00                	push   $0x0
  8022c0:	6a 00                	push   $0x0
  8022c2:	6a 2c                	push   $0x2c
  8022c4:	e8 4a fa ff ff       	call   801d13 <syscall>
  8022c9:	83 c4 18             	add    $0x18,%esp
  8022cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8022cf:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8022d3:	75 07                	jne    8022dc <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8022d5:	b8 01 00 00 00       	mov    $0x1,%eax
  8022da:	eb 05                	jmp    8022e1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8022dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022e1:	c9                   	leave  
  8022e2:	c3                   	ret    

008022e3 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8022e3:	55                   	push   %ebp
  8022e4:	89 e5                	mov    %esp,%ebp
  8022e6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022e9:	6a 00                	push   $0x0
  8022eb:	6a 00                	push   $0x0
  8022ed:	6a 00                	push   $0x0
  8022ef:	6a 00                	push   $0x0
  8022f1:	6a 00                	push   $0x0
  8022f3:	6a 2c                	push   $0x2c
  8022f5:	e8 19 fa ff ff       	call   801d13 <syscall>
  8022fa:	83 c4 18             	add    $0x18,%esp
  8022fd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802300:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802304:	75 07                	jne    80230d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802306:	b8 01 00 00 00       	mov    $0x1,%eax
  80230b:	eb 05                	jmp    802312 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80230d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802312:	c9                   	leave  
  802313:	c3                   	ret    

00802314 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802314:	55                   	push   %ebp
  802315:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802317:	6a 00                	push   $0x0
  802319:	6a 00                	push   $0x0
  80231b:	6a 00                	push   $0x0
  80231d:	6a 00                	push   $0x0
  80231f:	ff 75 08             	pushl  0x8(%ebp)
  802322:	6a 2d                	push   $0x2d
  802324:	e8 ea f9 ff ff       	call   801d13 <syscall>
  802329:	83 c4 18             	add    $0x18,%esp
	return ;
  80232c:	90                   	nop
}
  80232d:	c9                   	leave  
  80232e:	c3                   	ret    

0080232f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80232f:	55                   	push   %ebp
  802330:	89 e5                	mov    %esp,%ebp
  802332:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802333:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802336:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802339:	8b 55 0c             	mov    0xc(%ebp),%edx
  80233c:	8b 45 08             	mov    0x8(%ebp),%eax
  80233f:	6a 00                	push   $0x0
  802341:	53                   	push   %ebx
  802342:	51                   	push   %ecx
  802343:	52                   	push   %edx
  802344:	50                   	push   %eax
  802345:	6a 2e                	push   $0x2e
  802347:	e8 c7 f9 ff ff       	call   801d13 <syscall>
  80234c:	83 c4 18             	add    $0x18,%esp
}
  80234f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802352:	c9                   	leave  
  802353:	c3                   	ret    

00802354 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802354:	55                   	push   %ebp
  802355:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802357:	8b 55 0c             	mov    0xc(%ebp),%edx
  80235a:	8b 45 08             	mov    0x8(%ebp),%eax
  80235d:	6a 00                	push   $0x0
  80235f:	6a 00                	push   $0x0
  802361:	6a 00                	push   $0x0
  802363:	52                   	push   %edx
  802364:	50                   	push   %eax
  802365:	6a 2f                	push   $0x2f
  802367:	e8 a7 f9 ff ff       	call   801d13 <syscall>
  80236c:	83 c4 18             	add    $0x18,%esp
}
  80236f:	c9                   	leave  
  802370:	c3                   	ret    
  802371:	66 90                	xchg   %ax,%ax
  802373:	90                   	nop

00802374 <__udivdi3>:
  802374:	55                   	push   %ebp
  802375:	57                   	push   %edi
  802376:	56                   	push   %esi
  802377:	53                   	push   %ebx
  802378:	83 ec 1c             	sub    $0x1c,%esp
  80237b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80237f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802383:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802387:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80238b:	89 ca                	mov    %ecx,%edx
  80238d:	89 f8                	mov    %edi,%eax
  80238f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802393:	85 f6                	test   %esi,%esi
  802395:	75 2d                	jne    8023c4 <__udivdi3+0x50>
  802397:	39 cf                	cmp    %ecx,%edi
  802399:	77 65                	ja     802400 <__udivdi3+0x8c>
  80239b:	89 fd                	mov    %edi,%ebp
  80239d:	85 ff                	test   %edi,%edi
  80239f:	75 0b                	jne    8023ac <__udivdi3+0x38>
  8023a1:	b8 01 00 00 00       	mov    $0x1,%eax
  8023a6:	31 d2                	xor    %edx,%edx
  8023a8:	f7 f7                	div    %edi
  8023aa:	89 c5                	mov    %eax,%ebp
  8023ac:	31 d2                	xor    %edx,%edx
  8023ae:	89 c8                	mov    %ecx,%eax
  8023b0:	f7 f5                	div    %ebp
  8023b2:	89 c1                	mov    %eax,%ecx
  8023b4:	89 d8                	mov    %ebx,%eax
  8023b6:	f7 f5                	div    %ebp
  8023b8:	89 cf                	mov    %ecx,%edi
  8023ba:	89 fa                	mov    %edi,%edx
  8023bc:	83 c4 1c             	add    $0x1c,%esp
  8023bf:	5b                   	pop    %ebx
  8023c0:	5e                   	pop    %esi
  8023c1:	5f                   	pop    %edi
  8023c2:	5d                   	pop    %ebp
  8023c3:	c3                   	ret    
  8023c4:	39 ce                	cmp    %ecx,%esi
  8023c6:	77 28                	ja     8023f0 <__udivdi3+0x7c>
  8023c8:	0f bd fe             	bsr    %esi,%edi
  8023cb:	83 f7 1f             	xor    $0x1f,%edi
  8023ce:	75 40                	jne    802410 <__udivdi3+0x9c>
  8023d0:	39 ce                	cmp    %ecx,%esi
  8023d2:	72 0a                	jb     8023de <__udivdi3+0x6a>
  8023d4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8023d8:	0f 87 9e 00 00 00    	ja     80247c <__udivdi3+0x108>
  8023de:	b8 01 00 00 00       	mov    $0x1,%eax
  8023e3:	89 fa                	mov    %edi,%edx
  8023e5:	83 c4 1c             	add    $0x1c,%esp
  8023e8:	5b                   	pop    %ebx
  8023e9:	5e                   	pop    %esi
  8023ea:	5f                   	pop    %edi
  8023eb:	5d                   	pop    %ebp
  8023ec:	c3                   	ret    
  8023ed:	8d 76 00             	lea    0x0(%esi),%esi
  8023f0:	31 ff                	xor    %edi,%edi
  8023f2:	31 c0                	xor    %eax,%eax
  8023f4:	89 fa                	mov    %edi,%edx
  8023f6:	83 c4 1c             	add    $0x1c,%esp
  8023f9:	5b                   	pop    %ebx
  8023fa:	5e                   	pop    %esi
  8023fb:	5f                   	pop    %edi
  8023fc:	5d                   	pop    %ebp
  8023fd:	c3                   	ret    
  8023fe:	66 90                	xchg   %ax,%ax
  802400:	89 d8                	mov    %ebx,%eax
  802402:	f7 f7                	div    %edi
  802404:	31 ff                	xor    %edi,%edi
  802406:	89 fa                	mov    %edi,%edx
  802408:	83 c4 1c             	add    $0x1c,%esp
  80240b:	5b                   	pop    %ebx
  80240c:	5e                   	pop    %esi
  80240d:	5f                   	pop    %edi
  80240e:	5d                   	pop    %ebp
  80240f:	c3                   	ret    
  802410:	bd 20 00 00 00       	mov    $0x20,%ebp
  802415:	89 eb                	mov    %ebp,%ebx
  802417:	29 fb                	sub    %edi,%ebx
  802419:	89 f9                	mov    %edi,%ecx
  80241b:	d3 e6                	shl    %cl,%esi
  80241d:	89 c5                	mov    %eax,%ebp
  80241f:	88 d9                	mov    %bl,%cl
  802421:	d3 ed                	shr    %cl,%ebp
  802423:	89 e9                	mov    %ebp,%ecx
  802425:	09 f1                	or     %esi,%ecx
  802427:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80242b:	89 f9                	mov    %edi,%ecx
  80242d:	d3 e0                	shl    %cl,%eax
  80242f:	89 c5                	mov    %eax,%ebp
  802431:	89 d6                	mov    %edx,%esi
  802433:	88 d9                	mov    %bl,%cl
  802435:	d3 ee                	shr    %cl,%esi
  802437:	89 f9                	mov    %edi,%ecx
  802439:	d3 e2                	shl    %cl,%edx
  80243b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80243f:	88 d9                	mov    %bl,%cl
  802441:	d3 e8                	shr    %cl,%eax
  802443:	09 c2                	or     %eax,%edx
  802445:	89 d0                	mov    %edx,%eax
  802447:	89 f2                	mov    %esi,%edx
  802449:	f7 74 24 0c          	divl   0xc(%esp)
  80244d:	89 d6                	mov    %edx,%esi
  80244f:	89 c3                	mov    %eax,%ebx
  802451:	f7 e5                	mul    %ebp
  802453:	39 d6                	cmp    %edx,%esi
  802455:	72 19                	jb     802470 <__udivdi3+0xfc>
  802457:	74 0b                	je     802464 <__udivdi3+0xf0>
  802459:	89 d8                	mov    %ebx,%eax
  80245b:	31 ff                	xor    %edi,%edi
  80245d:	e9 58 ff ff ff       	jmp    8023ba <__udivdi3+0x46>
  802462:	66 90                	xchg   %ax,%ax
  802464:	8b 54 24 08          	mov    0x8(%esp),%edx
  802468:	89 f9                	mov    %edi,%ecx
  80246a:	d3 e2                	shl    %cl,%edx
  80246c:	39 c2                	cmp    %eax,%edx
  80246e:	73 e9                	jae    802459 <__udivdi3+0xe5>
  802470:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802473:	31 ff                	xor    %edi,%edi
  802475:	e9 40 ff ff ff       	jmp    8023ba <__udivdi3+0x46>
  80247a:	66 90                	xchg   %ax,%ax
  80247c:	31 c0                	xor    %eax,%eax
  80247e:	e9 37 ff ff ff       	jmp    8023ba <__udivdi3+0x46>
  802483:	90                   	nop

00802484 <__umoddi3>:
  802484:	55                   	push   %ebp
  802485:	57                   	push   %edi
  802486:	56                   	push   %esi
  802487:	53                   	push   %ebx
  802488:	83 ec 1c             	sub    $0x1c,%esp
  80248b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80248f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802493:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802497:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80249b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80249f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024a3:	89 f3                	mov    %esi,%ebx
  8024a5:	89 fa                	mov    %edi,%edx
  8024a7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8024ab:	89 34 24             	mov    %esi,(%esp)
  8024ae:	85 c0                	test   %eax,%eax
  8024b0:	75 1a                	jne    8024cc <__umoddi3+0x48>
  8024b2:	39 f7                	cmp    %esi,%edi
  8024b4:	0f 86 a2 00 00 00    	jbe    80255c <__umoddi3+0xd8>
  8024ba:	89 c8                	mov    %ecx,%eax
  8024bc:	89 f2                	mov    %esi,%edx
  8024be:	f7 f7                	div    %edi
  8024c0:	89 d0                	mov    %edx,%eax
  8024c2:	31 d2                	xor    %edx,%edx
  8024c4:	83 c4 1c             	add    $0x1c,%esp
  8024c7:	5b                   	pop    %ebx
  8024c8:	5e                   	pop    %esi
  8024c9:	5f                   	pop    %edi
  8024ca:	5d                   	pop    %ebp
  8024cb:	c3                   	ret    
  8024cc:	39 f0                	cmp    %esi,%eax
  8024ce:	0f 87 ac 00 00 00    	ja     802580 <__umoddi3+0xfc>
  8024d4:	0f bd e8             	bsr    %eax,%ebp
  8024d7:	83 f5 1f             	xor    $0x1f,%ebp
  8024da:	0f 84 ac 00 00 00    	je     80258c <__umoddi3+0x108>
  8024e0:	bf 20 00 00 00       	mov    $0x20,%edi
  8024e5:	29 ef                	sub    %ebp,%edi
  8024e7:	89 fe                	mov    %edi,%esi
  8024e9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8024ed:	89 e9                	mov    %ebp,%ecx
  8024ef:	d3 e0                	shl    %cl,%eax
  8024f1:	89 d7                	mov    %edx,%edi
  8024f3:	89 f1                	mov    %esi,%ecx
  8024f5:	d3 ef                	shr    %cl,%edi
  8024f7:	09 c7                	or     %eax,%edi
  8024f9:	89 e9                	mov    %ebp,%ecx
  8024fb:	d3 e2                	shl    %cl,%edx
  8024fd:	89 14 24             	mov    %edx,(%esp)
  802500:	89 d8                	mov    %ebx,%eax
  802502:	d3 e0                	shl    %cl,%eax
  802504:	89 c2                	mov    %eax,%edx
  802506:	8b 44 24 08          	mov    0x8(%esp),%eax
  80250a:	d3 e0                	shl    %cl,%eax
  80250c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802510:	8b 44 24 08          	mov    0x8(%esp),%eax
  802514:	89 f1                	mov    %esi,%ecx
  802516:	d3 e8                	shr    %cl,%eax
  802518:	09 d0                	or     %edx,%eax
  80251a:	d3 eb                	shr    %cl,%ebx
  80251c:	89 da                	mov    %ebx,%edx
  80251e:	f7 f7                	div    %edi
  802520:	89 d3                	mov    %edx,%ebx
  802522:	f7 24 24             	mull   (%esp)
  802525:	89 c6                	mov    %eax,%esi
  802527:	89 d1                	mov    %edx,%ecx
  802529:	39 d3                	cmp    %edx,%ebx
  80252b:	0f 82 87 00 00 00    	jb     8025b8 <__umoddi3+0x134>
  802531:	0f 84 91 00 00 00    	je     8025c8 <__umoddi3+0x144>
  802537:	8b 54 24 04          	mov    0x4(%esp),%edx
  80253b:	29 f2                	sub    %esi,%edx
  80253d:	19 cb                	sbb    %ecx,%ebx
  80253f:	89 d8                	mov    %ebx,%eax
  802541:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802545:	d3 e0                	shl    %cl,%eax
  802547:	89 e9                	mov    %ebp,%ecx
  802549:	d3 ea                	shr    %cl,%edx
  80254b:	09 d0                	or     %edx,%eax
  80254d:	89 e9                	mov    %ebp,%ecx
  80254f:	d3 eb                	shr    %cl,%ebx
  802551:	89 da                	mov    %ebx,%edx
  802553:	83 c4 1c             	add    $0x1c,%esp
  802556:	5b                   	pop    %ebx
  802557:	5e                   	pop    %esi
  802558:	5f                   	pop    %edi
  802559:	5d                   	pop    %ebp
  80255a:	c3                   	ret    
  80255b:	90                   	nop
  80255c:	89 fd                	mov    %edi,%ebp
  80255e:	85 ff                	test   %edi,%edi
  802560:	75 0b                	jne    80256d <__umoddi3+0xe9>
  802562:	b8 01 00 00 00       	mov    $0x1,%eax
  802567:	31 d2                	xor    %edx,%edx
  802569:	f7 f7                	div    %edi
  80256b:	89 c5                	mov    %eax,%ebp
  80256d:	89 f0                	mov    %esi,%eax
  80256f:	31 d2                	xor    %edx,%edx
  802571:	f7 f5                	div    %ebp
  802573:	89 c8                	mov    %ecx,%eax
  802575:	f7 f5                	div    %ebp
  802577:	89 d0                	mov    %edx,%eax
  802579:	e9 44 ff ff ff       	jmp    8024c2 <__umoddi3+0x3e>
  80257e:	66 90                	xchg   %ax,%ax
  802580:	89 c8                	mov    %ecx,%eax
  802582:	89 f2                	mov    %esi,%edx
  802584:	83 c4 1c             	add    $0x1c,%esp
  802587:	5b                   	pop    %ebx
  802588:	5e                   	pop    %esi
  802589:	5f                   	pop    %edi
  80258a:	5d                   	pop    %ebp
  80258b:	c3                   	ret    
  80258c:	3b 04 24             	cmp    (%esp),%eax
  80258f:	72 06                	jb     802597 <__umoddi3+0x113>
  802591:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802595:	77 0f                	ja     8025a6 <__umoddi3+0x122>
  802597:	89 f2                	mov    %esi,%edx
  802599:	29 f9                	sub    %edi,%ecx
  80259b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80259f:	89 14 24             	mov    %edx,(%esp)
  8025a2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8025a6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8025aa:	8b 14 24             	mov    (%esp),%edx
  8025ad:	83 c4 1c             	add    $0x1c,%esp
  8025b0:	5b                   	pop    %ebx
  8025b1:	5e                   	pop    %esi
  8025b2:	5f                   	pop    %edi
  8025b3:	5d                   	pop    %ebp
  8025b4:	c3                   	ret    
  8025b5:	8d 76 00             	lea    0x0(%esi),%esi
  8025b8:	2b 04 24             	sub    (%esp),%eax
  8025bb:	19 fa                	sbb    %edi,%edx
  8025bd:	89 d1                	mov    %edx,%ecx
  8025bf:	89 c6                	mov    %eax,%esi
  8025c1:	e9 71 ff ff ff       	jmp    802537 <__umoddi3+0xb3>
  8025c6:	66 90                	xchg   %ax,%ax
  8025c8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8025cc:	72 ea                	jb     8025b8 <__umoddi3+0x134>
  8025ce:	89 d9                	mov    %ebx,%ecx
  8025d0:	e9 62 ff ff ff       	jmp    802537 <__umoddi3+0xb3>
