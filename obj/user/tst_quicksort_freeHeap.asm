
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
  800031:	e8 30 08 00 00       	call   800866 <libmain>
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
  80003c:	81 ec 44 01 00 00    	sub    $0x144,%esp


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
  80004c:	e8 9d 22 00 00       	call   8022ee <sys_disable_interrupt>
		readline("Enter the number of elements: ", Line);
  800051:	83 ec 08             	sub    $0x8,%esp
  800054:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  80005a:	50                   	push   %eax
  80005b:	68 40 40 80 00       	push   $0x804040
  800060:	e8 73 12 00 00       	call   8012d8 <readline>
  800065:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  800068:	83 ec 04             	sub    $0x4,%esp
  80006b:	6a 0a                	push   $0xa
  80006d:	6a 00                	push   $0x0
  80006f:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  800075:	50                   	push   %eax
  800076:	e8 c3 17 00 00       	call   80183e <strtol>
  80007b:	83 c4 10             	add    $0x10,%esp
  80007e:	89 45 ec             	mov    %eax,-0x14(%ebp)

		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  800081:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800084:	c1 e0 02             	shl    $0x2,%eax
  800087:	83 ec 0c             	sub    $0xc,%esp
  80008a:	50                   	push   %eax
  80008b:	e8 54 1d 00 00       	call   801de4 <malloc>
  800090:	83 c4 10             	add    $0x10,%esp
  800093:	89 45 e8             	mov    %eax,-0x18(%ebp)
		uint32 num_disk_tables = 1;  //Since it is created with the first array, so it will be decremented in the 1st case only
  800096:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
		int numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  80009d:	a1 24 50 80 00       	mov    0x805024,%eax
  8000a2:	83 ec 0c             	sub    $0xc,%esp
  8000a5:	50                   	push   %eax
  8000a6:	e8 88 03 00 00       	call   800433 <CheckAndCountEmptyLocInWS>
  8000ab:	83 c4 10             	add    $0x10,%esp
  8000ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
		int InitFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  8000b1:	e8 4b 21 00 00       	call   802201 <sys_calculate_free_frames>
  8000b6:	89 c3                	mov    %eax,%ebx
  8000b8:	e8 5d 21 00 00       	call   80221a <sys_calculate_modified_frames>
  8000bd:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  8000c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000c3:	29 c2                	sub    %eax,%edx
  8000c5:	89 d0                	mov    %edx,%eax
  8000c7:	89 45 dc             	mov    %eax,-0x24(%ebp)

		Elements[NumOfElements] = 10 ;
  8000ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000cd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000d7:	01 d0                	add    %edx,%eax
  8000d9:	c7 00 0a 00 00 00    	movl   $0xa,(%eax)
		//		cprintf("Free Frames After Allocation = %d\n", sys_calculate_free_frames()) ;
		cprintf("Choose the initialization method:\n") ;
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	68 60 40 80 00       	push   $0x804060
  8000e7:	e8 6a 0b 00 00       	call   800c56 <cprintf>
  8000ec:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000ef:	83 ec 0c             	sub    $0xc,%esp
  8000f2:	68 83 40 80 00       	push   $0x804083
  8000f7:	e8 5a 0b 00 00       	call   800c56 <cprintf>
  8000fc:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	68 91 40 80 00       	push   $0x804091
  800107:	e8 4a 0b 00 00       	call   800c56 <cprintf>
  80010c:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n") ;
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	68 a0 40 80 00       	push   $0x8040a0
  800117:	e8 3a 0b 00 00       	call   800c56 <cprintf>
  80011c:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	68 b0 40 80 00       	push   $0x8040b0
  800127:	e8 2a 0b 00 00       	call   800c56 <cprintf>
  80012c:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80012f:	e8 da 06 00 00       	call   80080e <getchar>
  800134:	88 45 f7             	mov    %al,-0x9(%ebp)
			cputchar(Chose);
  800137:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80013b:	83 ec 0c             	sub    $0xc,%esp
  80013e:	50                   	push   %eax
  80013f:	e8 82 06 00 00       	call   8007c6 <cputchar>
  800144:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800147:	83 ec 0c             	sub    $0xc,%esp
  80014a:	6a 0a                	push   $0xa
  80014c:	e8 75 06 00 00       	call   8007c6 <cputchar>
  800151:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800154:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  800158:	74 0c                	je     800166 <_main+0x12e>
  80015a:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  80015e:	74 06                	je     800166 <_main+0x12e>
  800160:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800164:	75 b9                	jne    80011f <_main+0xe7>
	sys_enable_interrupt();
  800166:	e8 9d 21 00 00       	call   802308 <sys_enable_interrupt>
		int  i ;
		switch (Chose)
  80016b:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80016f:	83 f8 62             	cmp    $0x62,%eax
  800172:	74 1d                	je     800191 <_main+0x159>
  800174:	83 f8 63             	cmp    $0x63,%eax
  800177:	74 2b                	je     8001a4 <_main+0x16c>
  800179:	83 f8 61             	cmp    $0x61,%eax
  80017c:	75 39                	jne    8001b7 <_main+0x17f>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  80017e:	83 ec 08             	sub    $0x8,%esp
  800181:	ff 75 ec             	pushl  -0x14(%ebp)
  800184:	ff 75 e8             	pushl  -0x18(%ebp)
  800187:	e8 02 05 00 00       	call   80068e <InitializeAscending>
  80018c:	83 c4 10             	add    $0x10,%esp
			break ;
  80018f:	eb 37                	jmp    8001c8 <_main+0x190>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  800191:	83 ec 08             	sub    $0x8,%esp
  800194:	ff 75 ec             	pushl  -0x14(%ebp)
  800197:	ff 75 e8             	pushl  -0x18(%ebp)
  80019a:	e8 20 05 00 00       	call   8006bf <InitializeDescending>
  80019f:	83 c4 10             	add    $0x10,%esp
			break ;
  8001a2:	eb 24                	jmp    8001c8 <_main+0x190>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a4:	83 ec 08             	sub    $0x8,%esp
  8001a7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001aa:	ff 75 e8             	pushl  -0x18(%ebp)
  8001ad:	e8 42 05 00 00       	call   8006f4 <InitializeSemiRandom>
  8001b2:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b5:	eb 11                	jmp    8001c8 <_main+0x190>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b7:	83 ec 08             	sub    $0x8,%esp
  8001ba:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bd:	ff 75 e8             	pushl  -0x18(%ebp)
  8001c0:	e8 2f 05 00 00       	call   8006f4 <InitializeSemiRandom>
  8001c5:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  8001c8:	83 ec 08             	sub    $0x8,%esp
  8001cb:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ce:	ff 75 e8             	pushl  -0x18(%ebp)
  8001d1:	e8 fd 02 00 00       	call   8004d3 <QuickSort>
  8001d6:	83 c4 10             	add    $0x10,%esp

		//		PrintElements(Elements, NumOfElements);

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001d9:	83 ec 08             	sub    $0x8,%esp
  8001dc:	ff 75 ec             	pushl  -0x14(%ebp)
  8001df:	ff 75 e8             	pushl  -0x18(%ebp)
  8001e2:	e8 fd 03 00 00       	call   8005e4 <CheckSorted>
  8001e7:	83 c4 10             	add    $0x10,%esp
  8001ea:	89 45 d8             	mov    %eax,-0x28(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001ed:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8001f1:	75 14                	jne    800207 <_main+0x1cf>
  8001f3:	83 ec 04             	sub    $0x4,%esp
  8001f6:	68 bc 40 80 00       	push   $0x8040bc
  8001fb:	6a 57                	push   $0x57
  8001fd:	68 de 40 80 00       	push   $0x8040de
  800202:	e8 9b 07 00 00       	call   8009a2 <_panic>
		else
		{
			cprintf("===============================================\n") ;
  800207:	83 ec 0c             	sub    $0xc,%esp
  80020a:	68 fc 40 80 00       	push   $0x8040fc
  80020f:	e8 42 0a 00 00       	call   800c56 <cprintf>
  800214:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800217:	83 ec 0c             	sub    $0xc,%esp
  80021a:	68 30 41 80 00       	push   $0x804130
  80021f:	e8 32 0a 00 00       	call   800c56 <cprintf>
  800224:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800227:	83 ec 0c             	sub    $0xc,%esp
  80022a:	68 64 41 80 00       	push   $0x804164
  80022f:	e8 22 0a 00 00       	call   800c56 <cprintf>
  800234:	83 c4 10             	add    $0x10,%esp
		}

		//		cprintf("Free Frames After Calculation = %d\n", sys_calculate_free_frames()) ;

		cprintf("Freeing the Heap...\n\n") ;
  800237:	83 ec 0c             	sub    $0xc,%esp
  80023a:	68 96 41 80 00       	push   $0x804196
  80023f:	e8 12 0a 00 00       	call   800c56 <cprintf>
  800244:	83 c4 10             	add    $0x10,%esp
		free(Elements) ;
  800247:	83 ec 0c             	sub    $0xc,%esp
  80024a:	ff 75 e8             	pushl  -0x18(%ebp)
  80024d:	e8 0d 1c 00 00       	call   801e5f <free>
  800252:	83 c4 10             	add    $0x10,%esp


		///Testing the freeHeap according to the specified scenario
		if (Iteration == 1)
  800255:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  800259:	75 7b                	jne    8002d6 <_main+0x29e>
		{
			InitFreeFrames -= num_disk_tables;
  80025b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80025e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800261:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (!(NumOfElements == 1000 && Chose == 'a'))
  800264:	81 7d ec e8 03 00 00 	cmpl   $0x3e8,-0x14(%ebp)
  80026b:	75 06                	jne    800273 <_main+0x23b>
  80026d:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  800271:	74 14                	je     800287 <_main+0x24f>
				panic("Please ensure the number of elements and the initialization method of this test");
  800273:	83 ec 04             	sub    $0x4,%esp
  800276:	68 ac 41 80 00       	push   $0x8041ac
  80027b:	6a 6a                	push   $0x6a
  80027d:	68 de 40 80 00       	push   $0x8040de
  800282:	e8 1b 07 00 00       	call   8009a2 <_panic>

			numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  800287:	a1 24 50 80 00       	mov    0x805024,%eax
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	50                   	push   %eax
  800290:	e8 9e 01 00 00       	call   800433 <CheckAndCountEmptyLocInWS>
  800295:	83 c4 10             	add    $0x10,%esp
  800298:	89 45 e0             	mov    %eax,-0x20(%ebp)
			int CurrFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  80029b:	e8 61 1f 00 00       	call   802201 <sys_calculate_free_frames>
  8002a0:	89 c3                	mov    %eax,%ebx
  8002a2:	e8 73 1f 00 00       	call   80221a <sys_calculate_modified_frames>
  8002a7:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  8002aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002ad:	29 c2                	sub    %eax,%edx
  8002af:	89 d0                	mov    %edx,%eax
  8002b1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
  8002b4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002b7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8002ba:	0f 84 05 01 00 00    	je     8003c5 <_main+0x38d>
  8002c0:	68 fc 41 80 00       	push   $0x8041fc
  8002c5:	68 21 42 80 00       	push   $0x804221
  8002ca:	6a 6e                	push   $0x6e
  8002cc:	68 de 40 80 00       	push   $0x8040de
  8002d1:	e8 cc 06 00 00       	call   8009a2 <_panic>
		}
		else if (Iteration == 2 )
  8002d6:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  8002da:	75 72                	jne    80034e <_main+0x316>
		{
			if (!(NumOfElements == 5000 && Chose == 'b'))
  8002dc:	81 7d ec 88 13 00 00 	cmpl   $0x1388,-0x14(%ebp)
  8002e3:	75 06                	jne    8002eb <_main+0x2b3>
  8002e5:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  8002e9:	74 14                	je     8002ff <_main+0x2c7>
				panic("Please ensure the number of elements and the initialization method of this test");
  8002eb:	83 ec 04             	sub    $0x4,%esp
  8002ee:	68 ac 41 80 00       	push   $0x8041ac
  8002f3:	6a 73                	push   $0x73
  8002f5:	68 de 40 80 00       	push   $0x8040de
  8002fa:	e8 a3 06 00 00       	call   8009a2 <_panic>

			int numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  8002ff:	a1 24 50 80 00       	mov    0x805024,%eax
  800304:	83 ec 0c             	sub    $0xc,%esp
  800307:	50                   	push   %eax
  800308:	e8 26 01 00 00       	call   800433 <CheckAndCountEmptyLocInWS>
  80030d:	83 c4 10             	add    $0x10,%esp
  800310:	89 45 d0             	mov    %eax,-0x30(%ebp)
			int CurrFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  800313:	e8 e9 1e 00 00       	call   802201 <sys_calculate_free_frames>
  800318:	89 c3                	mov    %eax,%ebx
  80031a:	e8 fb 1e 00 00       	call   80221a <sys_calculate_modified_frames>
  80031f:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  800322:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800325:	29 c2                	sub    %eax,%edx
  800327:	89 d0                	mov    %edx,%eax
  800329:	89 45 cc             	mov    %eax,-0x34(%ebp)
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
  80032c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80032f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800332:	0f 84 8d 00 00 00    	je     8003c5 <_main+0x38d>
  800338:	68 fc 41 80 00       	push   $0x8041fc
  80033d:	68 21 42 80 00       	push   $0x804221
  800342:	6a 77                	push   $0x77
  800344:	68 de 40 80 00       	push   $0x8040de
  800349:	e8 54 06 00 00       	call   8009a2 <_panic>
		}
		else if (Iteration == 3 )
  80034e:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
  800352:	75 71                	jne    8003c5 <_main+0x38d>
		{
			if (!(NumOfElements == 300000 && Chose == 'c'))
  800354:	81 7d ec e0 93 04 00 	cmpl   $0x493e0,-0x14(%ebp)
  80035b:	75 06                	jne    800363 <_main+0x32b>
  80035d:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800361:	74 14                	je     800377 <_main+0x33f>
				panic("Please ensure the number of elements and the initialization method of this test");
  800363:	83 ec 04             	sub    $0x4,%esp
  800366:	68 ac 41 80 00       	push   $0x8041ac
  80036b:	6a 7c                	push   $0x7c
  80036d:	68 de 40 80 00       	push   $0x8040de
  800372:	e8 2b 06 00 00       	call   8009a2 <_panic>

			int numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  800377:	a1 24 50 80 00       	mov    0x805024,%eax
  80037c:	83 ec 0c             	sub    $0xc,%esp
  80037f:	50                   	push   %eax
  800380:	e8 ae 00 00 00       	call   800433 <CheckAndCountEmptyLocInWS>
  800385:	83 c4 10             	add    $0x10,%esp
  800388:	89 45 c8             	mov    %eax,-0x38(%ebp)
			int CurrFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  80038b:	e8 71 1e 00 00       	call   802201 <sys_calculate_free_frames>
  800390:	89 c3                	mov    %eax,%ebx
  800392:	e8 83 1e 00 00       	call   80221a <sys_calculate_modified_frames>
  800397:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  80039a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80039d:	29 c2                	sub    %eax,%edx
  80039f:	89 d0                	mov    %edx,%eax
  8003a1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			//cprintf("numOFEmptyLocInWS = %d\n", numOFEmptyLocInWS );
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
  8003a4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8003a7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8003aa:	74 19                	je     8003c5 <_main+0x38d>
  8003ac:	68 fc 41 80 00       	push   $0x8041fc
  8003b1:	68 21 42 80 00       	push   $0x804221
  8003b6:	68 81 00 00 00       	push   $0x81
  8003bb:	68 de 40 80 00       	push   $0x8040de
  8003c0:	e8 dd 05 00 00       	call   8009a2 <_panic>
		}
		///========================================================================
	sys_disable_interrupt();
  8003c5:	e8 24 1f 00 00       	call   8022ee <sys_disable_interrupt>
		Chose = 0 ;
  8003ca:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
		while (Chose != 'y' && Chose != 'n')
  8003ce:	eb 42                	jmp    800412 <_main+0x3da>
		{
			cprintf("Do you want to repeat (y/n): ") ;
  8003d0:	83 ec 0c             	sub    $0xc,%esp
  8003d3:	68 36 42 80 00       	push   $0x804236
  8003d8:	e8 79 08 00 00       	call   800c56 <cprintf>
  8003dd:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  8003e0:	e8 29 04 00 00       	call   80080e <getchar>
  8003e5:	88 45 f7             	mov    %al,-0x9(%ebp)
			cputchar(Chose);
  8003e8:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8003ec:	83 ec 0c             	sub    $0xc,%esp
  8003ef:	50                   	push   %eax
  8003f0:	e8 d1 03 00 00       	call   8007c6 <cputchar>
  8003f5:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8003f8:	83 ec 0c             	sub    $0xc,%esp
  8003fb:	6a 0a                	push   $0xa
  8003fd:	e8 c4 03 00 00       	call   8007c6 <cputchar>
  800402:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800405:	83 ec 0c             	sub    $0xc,%esp
  800408:	6a 0a                	push   $0xa
  80040a:	e8 b7 03 00 00       	call   8007c6 <cputchar>
  80040f:	83 c4 10             	add    $0x10,%esp
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
		}
		///========================================================================
	sys_disable_interrupt();
		Chose = 0 ;
		while (Chose != 'y' && Chose != 'n')
  800412:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  800416:	74 06                	je     80041e <_main+0x3e6>
  800418:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  80041c:	75 b2                	jne    8003d0 <_main+0x398>
			Chose = getchar() ;
			cputchar(Chose);
			cputchar('\n');
			cputchar('\n');
		}
	sys_enable_interrupt();
  80041e:	e8 e5 1e 00 00       	call   802308 <sys_enable_interrupt>

	} while (Chose == 'y');
  800423:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  800427:	0f 84 1c fc ff ff    	je     800049 <_main+0x11>
}
  80042d:	90                   	nop
  80042e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800431:	c9                   	leave  
  800432:	c3                   	ret    

00800433 <CheckAndCountEmptyLocInWS>:

int CheckAndCountEmptyLocInWS(volatile struct Env *myEnv)
{
  800433:	55                   	push   %ebp
  800434:	89 e5                	mov    %esp,%ebp
  800436:	83 ec 18             	sub    $0x18,%esp
	int numOFEmptyLocInWS = 0, i;
  800439:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (i = 0 ; i < myEnv->page_WS_max_size; i++)
  800440:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800447:	eb 74                	jmp    8004bd <CheckAndCountEmptyLocInWS+0x8a>
	{
		if (myEnv->__uptr_pws[i].empty)
  800449:	8b 45 08             	mov    0x8(%ebp),%eax
  80044c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800452:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800455:	89 d0                	mov    %edx,%eax
  800457:	01 c0                	add    %eax,%eax
  800459:	01 d0                	add    %edx,%eax
  80045b:	c1 e0 03             	shl    $0x3,%eax
  80045e:	01 c8                	add    %ecx,%eax
  800460:	8a 40 04             	mov    0x4(%eax),%al
  800463:	84 c0                	test   %al,%al
  800465:	74 05                	je     80046c <CheckAndCountEmptyLocInWS+0x39>
		{
			numOFEmptyLocInWS++;
  800467:	ff 45 f4             	incl   -0xc(%ebp)
  80046a:	eb 4e                	jmp    8004ba <CheckAndCountEmptyLocInWS+0x87>
		}
		else
		{
			uint32 va = ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) ;
  80046c:	8b 45 08             	mov    0x8(%ebp),%eax
  80046f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800475:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800478:	89 d0                	mov    %edx,%eax
  80047a:	01 c0                	add    %eax,%eax
  80047c:	01 d0                	add    %edx,%eax
  80047e:	c1 e0 03             	shl    $0x3,%eax
  800481:	01 c8                	add    %ecx,%eax
  800483:	8b 00                	mov    (%eax),%eax
  800485:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800488:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80048b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800490:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (va >= USER_HEAP_START && va < (USER_HEAP_MAX))
  800493:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800496:	85 c0                	test   %eax,%eax
  800498:	79 20                	jns    8004ba <CheckAndCountEmptyLocInWS+0x87>
  80049a:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  8004a1:	77 17                	ja     8004ba <CheckAndCountEmptyLocInWS+0x87>
				panic("freeMem didn't remove its page(s) from the WS");
  8004a3:	83 ec 04             	sub    $0x4,%esp
  8004a6:	68 54 42 80 00       	push   $0x804254
  8004ab:	68 a0 00 00 00       	push   $0xa0
  8004b0:	68 de 40 80 00       	push   $0x8040de
  8004b5:	e8 e8 04 00 00       	call   8009a2 <_panic>
}

int CheckAndCountEmptyLocInWS(volatile struct Env *myEnv)
{
	int numOFEmptyLocInWS = 0, i;
	for (i = 0 ; i < myEnv->page_WS_max_size; i++)
  8004ba:	ff 45 f0             	incl   -0x10(%ebp)
  8004bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c0:	8b 50 74             	mov    0x74(%eax),%edx
  8004c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004c6:	39 c2                	cmp    %eax,%edx
  8004c8:	0f 87 7b ff ff ff    	ja     800449 <CheckAndCountEmptyLocInWS+0x16>
			uint32 va = ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) ;
			if (va >= USER_HEAP_START && va < (USER_HEAP_MAX))
				panic("freeMem didn't remove its page(s) from the WS");
		}
	}
	return numOFEmptyLocInWS;
  8004ce:	8b 45 f4             	mov    -0xc(%ebp),%eax

}
  8004d1:	c9                   	leave  
  8004d2:	c3                   	ret    

008004d3 <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  8004d3:	55                   	push   %ebp
  8004d4:	89 e5                	mov    %esp,%ebp
  8004d6:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  8004d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004dc:	48                   	dec    %eax
  8004dd:	50                   	push   %eax
  8004de:	6a 00                	push   $0x0
  8004e0:	ff 75 0c             	pushl  0xc(%ebp)
  8004e3:	ff 75 08             	pushl  0x8(%ebp)
  8004e6:	e8 06 00 00 00       	call   8004f1 <QSort>
  8004eb:	83 c4 10             	add    $0x10,%esp
}
  8004ee:	90                   	nop
  8004ef:	c9                   	leave  
  8004f0:	c3                   	ret    

008004f1 <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  8004f1:	55                   	push   %ebp
  8004f2:	89 e5                	mov    %esp,%ebp
  8004f4:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  8004f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8004fa:	3b 45 14             	cmp    0x14(%ebp),%eax
  8004fd:	0f 8d de 00 00 00    	jge    8005e1 <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  800503:	8b 45 10             	mov    0x10(%ebp),%eax
  800506:	40                   	inc    %eax
  800507:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80050a:	8b 45 14             	mov    0x14(%ebp),%eax
  80050d:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  800510:	e9 80 00 00 00       	jmp    800595 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800515:	ff 45 f4             	incl   -0xc(%ebp)
  800518:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80051b:	3b 45 14             	cmp    0x14(%ebp),%eax
  80051e:	7f 2b                	jg     80054b <QSort+0x5a>
  800520:	8b 45 10             	mov    0x10(%ebp),%eax
  800523:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80052a:	8b 45 08             	mov    0x8(%ebp),%eax
  80052d:	01 d0                	add    %edx,%eax
  80052f:	8b 10                	mov    (%eax),%edx
  800531:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800534:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80053b:	8b 45 08             	mov    0x8(%ebp),%eax
  80053e:	01 c8                	add    %ecx,%eax
  800540:	8b 00                	mov    (%eax),%eax
  800542:	39 c2                	cmp    %eax,%edx
  800544:	7d cf                	jge    800515 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  800546:	eb 03                	jmp    80054b <QSort+0x5a>
  800548:	ff 4d f0             	decl   -0x10(%ebp)
  80054b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80054e:	3b 45 10             	cmp    0x10(%ebp),%eax
  800551:	7e 26                	jle    800579 <QSort+0x88>
  800553:	8b 45 10             	mov    0x10(%ebp),%eax
  800556:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80055d:	8b 45 08             	mov    0x8(%ebp),%eax
  800560:	01 d0                	add    %edx,%eax
  800562:	8b 10                	mov    (%eax),%edx
  800564:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800567:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80056e:	8b 45 08             	mov    0x8(%ebp),%eax
  800571:	01 c8                	add    %ecx,%eax
  800573:	8b 00                	mov    (%eax),%eax
  800575:	39 c2                	cmp    %eax,%edx
  800577:	7e cf                	jle    800548 <QSort+0x57>

		if (i <= j)
  800579:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80057c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80057f:	7f 14                	jg     800595 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  800581:	83 ec 04             	sub    $0x4,%esp
  800584:	ff 75 f0             	pushl  -0x10(%ebp)
  800587:	ff 75 f4             	pushl  -0xc(%ebp)
  80058a:	ff 75 08             	pushl  0x8(%ebp)
  80058d:	e8 a9 00 00 00       	call   80063b <Swap>
  800592:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800595:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800598:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80059b:	0f 8e 77 ff ff ff    	jle    800518 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  8005a1:	83 ec 04             	sub    $0x4,%esp
  8005a4:	ff 75 f0             	pushl  -0x10(%ebp)
  8005a7:	ff 75 10             	pushl  0x10(%ebp)
  8005aa:	ff 75 08             	pushl  0x8(%ebp)
  8005ad:	e8 89 00 00 00       	call   80063b <Swap>
  8005b2:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  8005b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005b8:	48                   	dec    %eax
  8005b9:	50                   	push   %eax
  8005ba:	ff 75 10             	pushl  0x10(%ebp)
  8005bd:	ff 75 0c             	pushl  0xc(%ebp)
  8005c0:	ff 75 08             	pushl  0x8(%ebp)
  8005c3:	e8 29 ff ff ff       	call   8004f1 <QSort>
  8005c8:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  8005cb:	ff 75 14             	pushl  0x14(%ebp)
  8005ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8005d1:	ff 75 0c             	pushl  0xc(%ebp)
  8005d4:	ff 75 08             	pushl  0x8(%ebp)
  8005d7:	e8 15 ff ff ff       	call   8004f1 <QSort>
  8005dc:	83 c4 10             	add    $0x10,%esp
  8005df:	eb 01                	jmp    8005e2 <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  8005e1:	90                   	nop

	Swap( Elements, startIndex, j);

	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);
}
  8005e2:	c9                   	leave  
  8005e3:	c3                   	ret    

008005e4 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8005e4:	55                   	push   %ebp
  8005e5:	89 e5                	mov    %esp,%ebp
  8005e7:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8005ea:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8005f1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8005f8:	eb 33                	jmp    80062d <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8005fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8005fd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800604:	8b 45 08             	mov    0x8(%ebp),%eax
  800607:	01 d0                	add    %edx,%eax
  800609:	8b 10                	mov    (%eax),%edx
  80060b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80060e:	40                   	inc    %eax
  80060f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800616:	8b 45 08             	mov    0x8(%ebp),%eax
  800619:	01 c8                	add    %ecx,%eax
  80061b:	8b 00                	mov    (%eax),%eax
  80061d:	39 c2                	cmp    %eax,%edx
  80061f:	7e 09                	jle    80062a <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800621:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800628:	eb 0c                	jmp    800636 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80062a:	ff 45 f8             	incl   -0x8(%ebp)
  80062d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800630:	48                   	dec    %eax
  800631:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800634:	7f c4                	jg     8005fa <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800636:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800639:	c9                   	leave  
  80063a:	c3                   	ret    

0080063b <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80063b:	55                   	push   %ebp
  80063c:	89 e5                	mov    %esp,%ebp
  80063e:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800641:	8b 45 0c             	mov    0xc(%ebp),%eax
  800644:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80064b:	8b 45 08             	mov    0x8(%ebp),%eax
  80064e:	01 d0                	add    %edx,%eax
  800650:	8b 00                	mov    (%eax),%eax
  800652:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800655:	8b 45 0c             	mov    0xc(%ebp),%eax
  800658:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80065f:	8b 45 08             	mov    0x8(%ebp),%eax
  800662:	01 c2                	add    %eax,%edx
  800664:	8b 45 10             	mov    0x10(%ebp),%eax
  800667:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80066e:	8b 45 08             	mov    0x8(%ebp),%eax
  800671:	01 c8                	add    %ecx,%eax
  800673:	8b 00                	mov    (%eax),%eax
  800675:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800677:	8b 45 10             	mov    0x10(%ebp),%eax
  80067a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800681:	8b 45 08             	mov    0x8(%ebp),%eax
  800684:	01 c2                	add    %eax,%edx
  800686:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800689:	89 02                	mov    %eax,(%edx)
}
  80068b:	90                   	nop
  80068c:	c9                   	leave  
  80068d:	c3                   	ret    

0080068e <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80068e:	55                   	push   %ebp
  80068f:	89 e5                	mov    %esp,%ebp
  800691:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800694:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80069b:	eb 17                	jmp    8006b4 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80069d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006a0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006aa:	01 c2                	add    %eax,%edx
  8006ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006af:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8006b1:	ff 45 fc             	incl   -0x4(%ebp)
  8006b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006b7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006ba:	7c e1                	jl     80069d <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8006bc:	90                   	nop
  8006bd:	c9                   	leave  
  8006be:	c3                   	ret    

008006bf <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8006bf:	55                   	push   %ebp
  8006c0:	89 e5                	mov    %esp,%ebp
  8006c2:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8006c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8006cc:	eb 1b                	jmp    8006e9 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8006ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006db:	01 c2                	add    %eax,%edx
  8006dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e0:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8006e3:	48                   	dec    %eax
  8006e4:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8006e6:	ff 45 fc             	incl   -0x4(%ebp)
  8006e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006ec:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006ef:	7c dd                	jl     8006ce <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8006f1:	90                   	nop
  8006f2:	c9                   	leave  
  8006f3:	c3                   	ret    

008006f4 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8006f4:	55                   	push   %ebp
  8006f5:	89 e5                	mov    %esp,%ebp
  8006f7:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8006fa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006fd:	b8 56 55 55 55       	mov    $0x55555556,%eax
  800702:	f7 e9                	imul   %ecx
  800704:	c1 f9 1f             	sar    $0x1f,%ecx
  800707:	89 d0                	mov    %edx,%eax
  800709:	29 c8                	sub    %ecx,%eax
  80070b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  80070e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800715:	eb 1e                	jmp    800735 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  800717:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80071a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800721:	8b 45 08             	mov    0x8(%ebp),%eax
  800724:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800727:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80072a:	99                   	cltd   
  80072b:	f7 7d f8             	idivl  -0x8(%ebp)
  80072e:	89 d0                	mov    %edx,%eax
  800730:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800732:	ff 45 fc             	incl   -0x4(%ebp)
  800735:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800738:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80073b:	7c da                	jl     800717 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
	}

}
  80073d:	90                   	nop
  80073e:	c9                   	leave  
  80073f:	c3                   	ret    

00800740 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800740:	55                   	push   %ebp
  800741:	89 e5                	mov    %esp,%ebp
  800743:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800746:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80074d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800754:	eb 42                	jmp    800798 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800756:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800759:	99                   	cltd   
  80075a:	f7 7d f0             	idivl  -0x10(%ebp)
  80075d:	89 d0                	mov    %edx,%eax
  80075f:	85 c0                	test   %eax,%eax
  800761:	75 10                	jne    800773 <PrintElements+0x33>
			cprintf("\n");
  800763:	83 ec 0c             	sub    $0xc,%esp
  800766:	68 82 42 80 00       	push   $0x804282
  80076b:	e8 e6 04 00 00       	call   800c56 <cprintf>
  800770:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800773:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800776:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80077d:	8b 45 08             	mov    0x8(%ebp),%eax
  800780:	01 d0                	add    %edx,%eax
  800782:	8b 00                	mov    (%eax),%eax
  800784:	83 ec 08             	sub    $0x8,%esp
  800787:	50                   	push   %eax
  800788:	68 84 42 80 00       	push   $0x804284
  80078d:	e8 c4 04 00 00       	call   800c56 <cprintf>
  800792:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800795:	ff 45 f4             	incl   -0xc(%ebp)
  800798:	8b 45 0c             	mov    0xc(%ebp),%eax
  80079b:	48                   	dec    %eax
  80079c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80079f:	7f b5                	jg     800756 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  8007a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007a4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ae:	01 d0                	add    %edx,%eax
  8007b0:	8b 00                	mov    (%eax),%eax
  8007b2:	83 ec 08             	sub    $0x8,%esp
  8007b5:	50                   	push   %eax
  8007b6:	68 89 42 80 00       	push   $0x804289
  8007bb:	e8 96 04 00 00       	call   800c56 <cprintf>
  8007c0:	83 c4 10             	add    $0x10,%esp

}
  8007c3:	90                   	nop
  8007c4:	c9                   	leave  
  8007c5:	c3                   	ret    

008007c6 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8007c6:	55                   	push   %ebp
  8007c7:	89 e5                	mov    %esp,%ebp
  8007c9:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8007cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cf:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8007d2:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8007d6:	83 ec 0c             	sub    $0xc,%esp
  8007d9:	50                   	push   %eax
  8007da:	e8 43 1b 00 00       	call   802322 <sys_cputc>
  8007df:	83 c4 10             	add    $0x10,%esp
}
  8007e2:	90                   	nop
  8007e3:	c9                   	leave  
  8007e4:	c3                   	ret    

008007e5 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8007e5:	55                   	push   %ebp
  8007e6:	89 e5                	mov    %esp,%ebp
  8007e8:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007eb:	e8 fe 1a 00 00       	call   8022ee <sys_disable_interrupt>
	char c = ch;
  8007f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f3:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8007f6:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8007fa:	83 ec 0c             	sub    $0xc,%esp
  8007fd:	50                   	push   %eax
  8007fe:	e8 1f 1b 00 00       	call   802322 <sys_cputc>
  800803:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800806:	e8 fd 1a 00 00       	call   802308 <sys_enable_interrupt>
}
  80080b:	90                   	nop
  80080c:	c9                   	leave  
  80080d:	c3                   	ret    

0080080e <getchar>:

int
getchar(void)
{
  80080e:	55                   	push   %ebp
  80080f:	89 e5                	mov    %esp,%ebp
  800811:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800814:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80081b:	eb 08                	jmp    800825 <getchar+0x17>
	{
		c = sys_cgetc();
  80081d:	e8 47 19 00 00       	call   802169 <sys_cgetc>
  800822:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800825:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800829:	74 f2                	je     80081d <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  80082b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80082e:	c9                   	leave  
  80082f:	c3                   	ret    

00800830 <atomic_getchar>:

int
atomic_getchar(void)
{
  800830:	55                   	push   %ebp
  800831:	89 e5                	mov    %esp,%ebp
  800833:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800836:	e8 b3 1a 00 00       	call   8022ee <sys_disable_interrupt>
	int c=0;
  80083b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800842:	eb 08                	jmp    80084c <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800844:	e8 20 19 00 00       	call   802169 <sys_cgetc>
  800849:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  80084c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800850:	74 f2                	je     800844 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  800852:	e8 b1 1a 00 00       	call   802308 <sys_enable_interrupt>
	return c;
  800857:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80085a:	c9                   	leave  
  80085b:	c3                   	ret    

0080085c <iscons>:

int iscons(int fdnum)
{
  80085c:	55                   	push   %ebp
  80085d:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80085f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800864:	5d                   	pop    %ebp
  800865:	c3                   	ret    

00800866 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800866:	55                   	push   %ebp
  800867:	89 e5                	mov    %esp,%ebp
  800869:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80086c:	e8 70 1c 00 00       	call   8024e1 <sys_getenvindex>
  800871:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800874:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800877:	89 d0                	mov    %edx,%eax
  800879:	c1 e0 03             	shl    $0x3,%eax
  80087c:	01 d0                	add    %edx,%eax
  80087e:	01 c0                	add    %eax,%eax
  800880:	01 d0                	add    %edx,%eax
  800882:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800889:	01 d0                	add    %edx,%eax
  80088b:	c1 e0 04             	shl    $0x4,%eax
  80088e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800893:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800898:	a1 24 50 80 00       	mov    0x805024,%eax
  80089d:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8008a3:	84 c0                	test   %al,%al
  8008a5:	74 0f                	je     8008b6 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8008a7:	a1 24 50 80 00       	mov    0x805024,%eax
  8008ac:	05 5c 05 00 00       	add    $0x55c,%eax
  8008b1:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8008b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8008ba:	7e 0a                	jle    8008c6 <libmain+0x60>
		binaryname = argv[0];
  8008bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008bf:	8b 00                	mov    (%eax),%eax
  8008c1:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8008c6:	83 ec 08             	sub    $0x8,%esp
  8008c9:	ff 75 0c             	pushl  0xc(%ebp)
  8008cc:	ff 75 08             	pushl  0x8(%ebp)
  8008cf:	e8 64 f7 ff ff       	call   800038 <_main>
  8008d4:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8008d7:	e8 12 1a 00 00       	call   8022ee <sys_disable_interrupt>
	cprintf("**************************************\n");
  8008dc:	83 ec 0c             	sub    $0xc,%esp
  8008df:	68 a8 42 80 00       	push   $0x8042a8
  8008e4:	e8 6d 03 00 00       	call   800c56 <cprintf>
  8008e9:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8008ec:	a1 24 50 80 00       	mov    0x805024,%eax
  8008f1:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8008f7:	a1 24 50 80 00       	mov    0x805024,%eax
  8008fc:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800902:	83 ec 04             	sub    $0x4,%esp
  800905:	52                   	push   %edx
  800906:	50                   	push   %eax
  800907:	68 d0 42 80 00       	push   $0x8042d0
  80090c:	e8 45 03 00 00       	call   800c56 <cprintf>
  800911:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800914:	a1 24 50 80 00       	mov    0x805024,%eax
  800919:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80091f:	a1 24 50 80 00       	mov    0x805024,%eax
  800924:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80092a:	a1 24 50 80 00       	mov    0x805024,%eax
  80092f:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800935:	51                   	push   %ecx
  800936:	52                   	push   %edx
  800937:	50                   	push   %eax
  800938:	68 f8 42 80 00       	push   $0x8042f8
  80093d:	e8 14 03 00 00       	call   800c56 <cprintf>
  800942:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800945:	a1 24 50 80 00       	mov    0x805024,%eax
  80094a:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800950:	83 ec 08             	sub    $0x8,%esp
  800953:	50                   	push   %eax
  800954:	68 50 43 80 00       	push   $0x804350
  800959:	e8 f8 02 00 00       	call   800c56 <cprintf>
  80095e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800961:	83 ec 0c             	sub    $0xc,%esp
  800964:	68 a8 42 80 00       	push   $0x8042a8
  800969:	e8 e8 02 00 00       	call   800c56 <cprintf>
  80096e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800971:	e8 92 19 00 00       	call   802308 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800976:	e8 19 00 00 00       	call   800994 <exit>
}
  80097b:	90                   	nop
  80097c:	c9                   	leave  
  80097d:	c3                   	ret    

0080097e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80097e:	55                   	push   %ebp
  80097f:	89 e5                	mov    %esp,%ebp
  800981:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800984:	83 ec 0c             	sub    $0xc,%esp
  800987:	6a 00                	push   $0x0
  800989:	e8 1f 1b 00 00       	call   8024ad <sys_destroy_env>
  80098e:	83 c4 10             	add    $0x10,%esp
}
  800991:	90                   	nop
  800992:	c9                   	leave  
  800993:	c3                   	ret    

00800994 <exit>:

void
exit(void)
{
  800994:	55                   	push   %ebp
  800995:	89 e5                	mov    %esp,%ebp
  800997:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80099a:	e8 74 1b 00 00       	call   802513 <sys_exit_env>
}
  80099f:	90                   	nop
  8009a0:	c9                   	leave  
  8009a1:	c3                   	ret    

008009a2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8009a2:	55                   	push   %ebp
  8009a3:	89 e5                	mov    %esp,%ebp
  8009a5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8009a8:	8d 45 10             	lea    0x10(%ebp),%eax
  8009ab:	83 c0 04             	add    $0x4,%eax
  8009ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8009b1:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8009b6:	85 c0                	test   %eax,%eax
  8009b8:	74 16                	je     8009d0 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8009ba:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8009bf:	83 ec 08             	sub    $0x8,%esp
  8009c2:	50                   	push   %eax
  8009c3:	68 64 43 80 00       	push   $0x804364
  8009c8:	e8 89 02 00 00       	call   800c56 <cprintf>
  8009cd:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8009d0:	a1 00 50 80 00       	mov    0x805000,%eax
  8009d5:	ff 75 0c             	pushl  0xc(%ebp)
  8009d8:	ff 75 08             	pushl  0x8(%ebp)
  8009db:	50                   	push   %eax
  8009dc:	68 69 43 80 00       	push   $0x804369
  8009e1:	e8 70 02 00 00       	call   800c56 <cprintf>
  8009e6:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8009e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ec:	83 ec 08             	sub    $0x8,%esp
  8009ef:	ff 75 f4             	pushl  -0xc(%ebp)
  8009f2:	50                   	push   %eax
  8009f3:	e8 f3 01 00 00       	call   800beb <vcprintf>
  8009f8:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8009fb:	83 ec 08             	sub    $0x8,%esp
  8009fe:	6a 00                	push   $0x0
  800a00:	68 85 43 80 00       	push   $0x804385
  800a05:	e8 e1 01 00 00       	call   800beb <vcprintf>
  800a0a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800a0d:	e8 82 ff ff ff       	call   800994 <exit>

	// should not return here
	while (1) ;
  800a12:	eb fe                	jmp    800a12 <_panic+0x70>

00800a14 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800a14:	55                   	push   %ebp
  800a15:	89 e5                	mov    %esp,%ebp
  800a17:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800a1a:	a1 24 50 80 00       	mov    0x805024,%eax
  800a1f:	8b 50 74             	mov    0x74(%eax),%edx
  800a22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a25:	39 c2                	cmp    %eax,%edx
  800a27:	74 14                	je     800a3d <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800a29:	83 ec 04             	sub    $0x4,%esp
  800a2c:	68 88 43 80 00       	push   $0x804388
  800a31:	6a 26                	push   $0x26
  800a33:	68 d4 43 80 00       	push   $0x8043d4
  800a38:	e8 65 ff ff ff       	call   8009a2 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800a3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800a44:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a4b:	e9 c2 00 00 00       	jmp    800b12 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800a50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a53:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5d:	01 d0                	add    %edx,%eax
  800a5f:	8b 00                	mov    (%eax),%eax
  800a61:	85 c0                	test   %eax,%eax
  800a63:	75 08                	jne    800a6d <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800a65:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800a68:	e9 a2 00 00 00       	jmp    800b0f <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800a6d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a74:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800a7b:	eb 69                	jmp    800ae6 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800a7d:	a1 24 50 80 00       	mov    0x805024,%eax
  800a82:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800a88:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a8b:	89 d0                	mov    %edx,%eax
  800a8d:	01 c0                	add    %eax,%eax
  800a8f:	01 d0                	add    %edx,%eax
  800a91:	c1 e0 03             	shl    $0x3,%eax
  800a94:	01 c8                	add    %ecx,%eax
  800a96:	8a 40 04             	mov    0x4(%eax),%al
  800a99:	84 c0                	test   %al,%al
  800a9b:	75 46                	jne    800ae3 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a9d:	a1 24 50 80 00       	mov    0x805024,%eax
  800aa2:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800aa8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800aab:	89 d0                	mov    %edx,%eax
  800aad:	01 c0                	add    %eax,%eax
  800aaf:	01 d0                	add    %edx,%eax
  800ab1:	c1 e0 03             	shl    $0x3,%eax
  800ab4:	01 c8                	add    %ecx,%eax
  800ab6:	8b 00                	mov    (%eax),%eax
  800ab8:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800abb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800abe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ac3:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800ac5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ac8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800acf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad2:	01 c8                	add    %ecx,%eax
  800ad4:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800ad6:	39 c2                	cmp    %eax,%edx
  800ad8:	75 09                	jne    800ae3 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800ada:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800ae1:	eb 12                	jmp    800af5 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ae3:	ff 45 e8             	incl   -0x18(%ebp)
  800ae6:	a1 24 50 80 00       	mov    0x805024,%eax
  800aeb:	8b 50 74             	mov    0x74(%eax),%edx
  800aee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800af1:	39 c2                	cmp    %eax,%edx
  800af3:	77 88                	ja     800a7d <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800af5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800af9:	75 14                	jne    800b0f <CheckWSWithoutLastIndex+0xfb>
			panic(
  800afb:	83 ec 04             	sub    $0x4,%esp
  800afe:	68 e0 43 80 00       	push   $0x8043e0
  800b03:	6a 3a                	push   $0x3a
  800b05:	68 d4 43 80 00       	push   $0x8043d4
  800b0a:	e8 93 fe ff ff       	call   8009a2 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800b0f:	ff 45 f0             	incl   -0x10(%ebp)
  800b12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b15:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800b18:	0f 8c 32 ff ff ff    	jl     800a50 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800b1e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b25:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800b2c:	eb 26                	jmp    800b54 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800b2e:	a1 24 50 80 00       	mov    0x805024,%eax
  800b33:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b39:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800b3c:	89 d0                	mov    %edx,%eax
  800b3e:	01 c0                	add    %eax,%eax
  800b40:	01 d0                	add    %edx,%eax
  800b42:	c1 e0 03             	shl    $0x3,%eax
  800b45:	01 c8                	add    %ecx,%eax
  800b47:	8a 40 04             	mov    0x4(%eax),%al
  800b4a:	3c 01                	cmp    $0x1,%al
  800b4c:	75 03                	jne    800b51 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800b4e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b51:	ff 45 e0             	incl   -0x20(%ebp)
  800b54:	a1 24 50 80 00       	mov    0x805024,%eax
  800b59:	8b 50 74             	mov    0x74(%eax),%edx
  800b5c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b5f:	39 c2                	cmp    %eax,%edx
  800b61:	77 cb                	ja     800b2e <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b66:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800b69:	74 14                	je     800b7f <CheckWSWithoutLastIndex+0x16b>
		panic(
  800b6b:	83 ec 04             	sub    $0x4,%esp
  800b6e:	68 34 44 80 00       	push   $0x804434
  800b73:	6a 44                	push   $0x44
  800b75:	68 d4 43 80 00       	push   $0x8043d4
  800b7a:	e8 23 fe ff ff       	call   8009a2 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800b7f:	90                   	nop
  800b80:	c9                   	leave  
  800b81:	c3                   	ret    

00800b82 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800b82:	55                   	push   %ebp
  800b83:	89 e5                	mov    %esp,%ebp
  800b85:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800b88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8b:	8b 00                	mov    (%eax),%eax
  800b8d:	8d 48 01             	lea    0x1(%eax),%ecx
  800b90:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b93:	89 0a                	mov    %ecx,(%edx)
  800b95:	8b 55 08             	mov    0x8(%ebp),%edx
  800b98:	88 d1                	mov    %dl,%cl
  800b9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b9d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800ba1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba4:	8b 00                	mov    (%eax),%eax
  800ba6:	3d ff 00 00 00       	cmp    $0xff,%eax
  800bab:	75 2c                	jne    800bd9 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800bad:	a0 28 50 80 00       	mov    0x805028,%al
  800bb2:	0f b6 c0             	movzbl %al,%eax
  800bb5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bb8:	8b 12                	mov    (%edx),%edx
  800bba:	89 d1                	mov    %edx,%ecx
  800bbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bbf:	83 c2 08             	add    $0x8,%edx
  800bc2:	83 ec 04             	sub    $0x4,%esp
  800bc5:	50                   	push   %eax
  800bc6:	51                   	push   %ecx
  800bc7:	52                   	push   %edx
  800bc8:	e8 73 15 00 00       	call   802140 <sys_cputs>
  800bcd:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800bd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800bd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bdc:	8b 40 04             	mov    0x4(%eax),%eax
  800bdf:	8d 50 01             	lea    0x1(%eax),%edx
  800be2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be5:	89 50 04             	mov    %edx,0x4(%eax)
}
  800be8:	90                   	nop
  800be9:	c9                   	leave  
  800bea:	c3                   	ret    

00800beb <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800beb:	55                   	push   %ebp
  800bec:	89 e5                	mov    %esp,%ebp
  800bee:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800bf4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800bfb:	00 00 00 
	b.cnt = 0;
  800bfe:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800c05:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800c08:	ff 75 0c             	pushl  0xc(%ebp)
  800c0b:	ff 75 08             	pushl  0x8(%ebp)
  800c0e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c14:	50                   	push   %eax
  800c15:	68 82 0b 80 00       	push   $0x800b82
  800c1a:	e8 11 02 00 00       	call   800e30 <vprintfmt>
  800c1f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800c22:	a0 28 50 80 00       	mov    0x805028,%al
  800c27:	0f b6 c0             	movzbl %al,%eax
  800c2a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800c30:	83 ec 04             	sub    $0x4,%esp
  800c33:	50                   	push   %eax
  800c34:	52                   	push   %edx
  800c35:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c3b:	83 c0 08             	add    $0x8,%eax
  800c3e:	50                   	push   %eax
  800c3f:	e8 fc 14 00 00       	call   802140 <sys_cputs>
  800c44:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800c47:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800c4e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800c54:	c9                   	leave  
  800c55:	c3                   	ret    

00800c56 <cprintf>:

int cprintf(const char *fmt, ...) {
  800c56:	55                   	push   %ebp
  800c57:	89 e5                	mov    %esp,%ebp
  800c59:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800c5c:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800c63:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c66:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c69:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6c:	83 ec 08             	sub    $0x8,%esp
  800c6f:	ff 75 f4             	pushl  -0xc(%ebp)
  800c72:	50                   	push   %eax
  800c73:	e8 73 ff ff ff       	call   800beb <vcprintf>
  800c78:	83 c4 10             	add    $0x10,%esp
  800c7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800c7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c81:	c9                   	leave  
  800c82:	c3                   	ret    

00800c83 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800c83:	55                   	push   %ebp
  800c84:	89 e5                	mov    %esp,%ebp
  800c86:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800c89:	e8 60 16 00 00       	call   8022ee <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800c8e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c91:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c94:	8b 45 08             	mov    0x8(%ebp),%eax
  800c97:	83 ec 08             	sub    $0x8,%esp
  800c9a:	ff 75 f4             	pushl  -0xc(%ebp)
  800c9d:	50                   	push   %eax
  800c9e:	e8 48 ff ff ff       	call   800beb <vcprintf>
  800ca3:	83 c4 10             	add    $0x10,%esp
  800ca6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800ca9:	e8 5a 16 00 00       	call   802308 <sys_enable_interrupt>
	return cnt;
  800cae:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cb1:	c9                   	leave  
  800cb2:	c3                   	ret    

00800cb3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800cb3:	55                   	push   %ebp
  800cb4:	89 e5                	mov    %esp,%ebp
  800cb6:	53                   	push   %ebx
  800cb7:	83 ec 14             	sub    $0x14,%esp
  800cba:	8b 45 10             	mov    0x10(%ebp),%eax
  800cbd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cc0:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800cc6:	8b 45 18             	mov    0x18(%ebp),%eax
  800cc9:	ba 00 00 00 00       	mov    $0x0,%edx
  800cce:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800cd1:	77 55                	ja     800d28 <printnum+0x75>
  800cd3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800cd6:	72 05                	jb     800cdd <printnum+0x2a>
  800cd8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800cdb:	77 4b                	ja     800d28 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800cdd:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800ce0:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800ce3:	8b 45 18             	mov    0x18(%ebp),%eax
  800ce6:	ba 00 00 00 00       	mov    $0x0,%edx
  800ceb:	52                   	push   %edx
  800cec:	50                   	push   %eax
  800ced:	ff 75 f4             	pushl  -0xc(%ebp)
  800cf0:	ff 75 f0             	pushl  -0x10(%ebp)
  800cf3:	e8 cc 30 00 00       	call   803dc4 <__udivdi3>
  800cf8:	83 c4 10             	add    $0x10,%esp
  800cfb:	83 ec 04             	sub    $0x4,%esp
  800cfe:	ff 75 20             	pushl  0x20(%ebp)
  800d01:	53                   	push   %ebx
  800d02:	ff 75 18             	pushl  0x18(%ebp)
  800d05:	52                   	push   %edx
  800d06:	50                   	push   %eax
  800d07:	ff 75 0c             	pushl  0xc(%ebp)
  800d0a:	ff 75 08             	pushl  0x8(%ebp)
  800d0d:	e8 a1 ff ff ff       	call   800cb3 <printnum>
  800d12:	83 c4 20             	add    $0x20,%esp
  800d15:	eb 1a                	jmp    800d31 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800d17:	83 ec 08             	sub    $0x8,%esp
  800d1a:	ff 75 0c             	pushl  0xc(%ebp)
  800d1d:	ff 75 20             	pushl  0x20(%ebp)
  800d20:	8b 45 08             	mov    0x8(%ebp),%eax
  800d23:	ff d0                	call   *%eax
  800d25:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800d28:	ff 4d 1c             	decl   0x1c(%ebp)
  800d2b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800d2f:	7f e6                	jg     800d17 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800d31:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800d34:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d3f:	53                   	push   %ebx
  800d40:	51                   	push   %ecx
  800d41:	52                   	push   %edx
  800d42:	50                   	push   %eax
  800d43:	e8 8c 31 00 00       	call   803ed4 <__umoddi3>
  800d48:	83 c4 10             	add    $0x10,%esp
  800d4b:	05 94 46 80 00       	add    $0x804694,%eax
  800d50:	8a 00                	mov    (%eax),%al
  800d52:	0f be c0             	movsbl %al,%eax
  800d55:	83 ec 08             	sub    $0x8,%esp
  800d58:	ff 75 0c             	pushl  0xc(%ebp)
  800d5b:	50                   	push   %eax
  800d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5f:	ff d0                	call   *%eax
  800d61:	83 c4 10             	add    $0x10,%esp
}
  800d64:	90                   	nop
  800d65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d68:	c9                   	leave  
  800d69:	c3                   	ret    

00800d6a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800d6a:	55                   	push   %ebp
  800d6b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d6d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d71:	7e 1c                	jle    800d8f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800d73:	8b 45 08             	mov    0x8(%ebp),%eax
  800d76:	8b 00                	mov    (%eax),%eax
  800d78:	8d 50 08             	lea    0x8(%eax),%edx
  800d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7e:	89 10                	mov    %edx,(%eax)
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	8b 00                	mov    (%eax),%eax
  800d85:	83 e8 08             	sub    $0x8,%eax
  800d88:	8b 50 04             	mov    0x4(%eax),%edx
  800d8b:	8b 00                	mov    (%eax),%eax
  800d8d:	eb 40                	jmp    800dcf <getuint+0x65>
	else if (lflag)
  800d8f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d93:	74 1e                	je     800db3 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800d95:	8b 45 08             	mov    0x8(%ebp),%eax
  800d98:	8b 00                	mov    (%eax),%eax
  800d9a:	8d 50 04             	lea    0x4(%eax),%edx
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800da0:	89 10                	mov    %edx,(%eax)
  800da2:	8b 45 08             	mov    0x8(%ebp),%eax
  800da5:	8b 00                	mov    (%eax),%eax
  800da7:	83 e8 04             	sub    $0x4,%eax
  800daa:	8b 00                	mov    (%eax),%eax
  800dac:	ba 00 00 00 00       	mov    $0x0,%edx
  800db1:	eb 1c                	jmp    800dcf <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800db3:	8b 45 08             	mov    0x8(%ebp),%eax
  800db6:	8b 00                	mov    (%eax),%eax
  800db8:	8d 50 04             	lea    0x4(%eax),%edx
  800dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbe:	89 10                	mov    %edx,(%eax)
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc3:	8b 00                	mov    (%eax),%eax
  800dc5:	83 e8 04             	sub    $0x4,%eax
  800dc8:	8b 00                	mov    (%eax),%eax
  800dca:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800dcf:	5d                   	pop    %ebp
  800dd0:	c3                   	ret    

00800dd1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800dd1:	55                   	push   %ebp
  800dd2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800dd4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800dd8:	7e 1c                	jle    800df6 <getint+0x25>
		return va_arg(*ap, long long);
  800dda:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddd:	8b 00                	mov    (%eax),%eax
  800ddf:	8d 50 08             	lea    0x8(%eax),%edx
  800de2:	8b 45 08             	mov    0x8(%ebp),%eax
  800de5:	89 10                	mov    %edx,(%eax)
  800de7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dea:	8b 00                	mov    (%eax),%eax
  800dec:	83 e8 08             	sub    $0x8,%eax
  800def:	8b 50 04             	mov    0x4(%eax),%edx
  800df2:	8b 00                	mov    (%eax),%eax
  800df4:	eb 38                	jmp    800e2e <getint+0x5d>
	else if (lflag)
  800df6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dfa:	74 1a                	je     800e16 <getint+0x45>
		return va_arg(*ap, long);
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dff:	8b 00                	mov    (%eax),%eax
  800e01:	8d 50 04             	lea    0x4(%eax),%edx
  800e04:	8b 45 08             	mov    0x8(%ebp),%eax
  800e07:	89 10                	mov    %edx,(%eax)
  800e09:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0c:	8b 00                	mov    (%eax),%eax
  800e0e:	83 e8 04             	sub    $0x4,%eax
  800e11:	8b 00                	mov    (%eax),%eax
  800e13:	99                   	cltd   
  800e14:	eb 18                	jmp    800e2e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800e16:	8b 45 08             	mov    0x8(%ebp),%eax
  800e19:	8b 00                	mov    (%eax),%eax
  800e1b:	8d 50 04             	lea    0x4(%eax),%edx
  800e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e21:	89 10                	mov    %edx,(%eax)
  800e23:	8b 45 08             	mov    0x8(%ebp),%eax
  800e26:	8b 00                	mov    (%eax),%eax
  800e28:	83 e8 04             	sub    $0x4,%eax
  800e2b:	8b 00                	mov    (%eax),%eax
  800e2d:	99                   	cltd   
}
  800e2e:	5d                   	pop    %ebp
  800e2f:	c3                   	ret    

00800e30 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800e30:	55                   	push   %ebp
  800e31:	89 e5                	mov    %esp,%ebp
  800e33:	56                   	push   %esi
  800e34:	53                   	push   %ebx
  800e35:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e38:	eb 17                	jmp    800e51 <vprintfmt+0x21>
			if (ch == '\0')
  800e3a:	85 db                	test   %ebx,%ebx
  800e3c:	0f 84 af 03 00 00    	je     8011f1 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800e42:	83 ec 08             	sub    $0x8,%esp
  800e45:	ff 75 0c             	pushl  0xc(%ebp)
  800e48:	53                   	push   %ebx
  800e49:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4c:	ff d0                	call   *%eax
  800e4e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e51:	8b 45 10             	mov    0x10(%ebp),%eax
  800e54:	8d 50 01             	lea    0x1(%eax),%edx
  800e57:	89 55 10             	mov    %edx,0x10(%ebp)
  800e5a:	8a 00                	mov    (%eax),%al
  800e5c:	0f b6 d8             	movzbl %al,%ebx
  800e5f:	83 fb 25             	cmp    $0x25,%ebx
  800e62:	75 d6                	jne    800e3a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800e64:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800e68:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800e6f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800e76:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800e7d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e84:	8b 45 10             	mov    0x10(%ebp),%eax
  800e87:	8d 50 01             	lea    0x1(%eax),%edx
  800e8a:	89 55 10             	mov    %edx,0x10(%ebp)
  800e8d:	8a 00                	mov    (%eax),%al
  800e8f:	0f b6 d8             	movzbl %al,%ebx
  800e92:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800e95:	83 f8 55             	cmp    $0x55,%eax
  800e98:	0f 87 2b 03 00 00    	ja     8011c9 <vprintfmt+0x399>
  800e9e:	8b 04 85 b8 46 80 00 	mov    0x8046b8(,%eax,4),%eax
  800ea5:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800ea7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800eab:	eb d7                	jmp    800e84 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ead:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800eb1:	eb d1                	jmp    800e84 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800eb3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800eba:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ebd:	89 d0                	mov    %edx,%eax
  800ebf:	c1 e0 02             	shl    $0x2,%eax
  800ec2:	01 d0                	add    %edx,%eax
  800ec4:	01 c0                	add    %eax,%eax
  800ec6:	01 d8                	add    %ebx,%eax
  800ec8:	83 e8 30             	sub    $0x30,%eax
  800ecb:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800ece:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed1:	8a 00                	mov    (%eax),%al
  800ed3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ed6:	83 fb 2f             	cmp    $0x2f,%ebx
  800ed9:	7e 3e                	jle    800f19 <vprintfmt+0xe9>
  800edb:	83 fb 39             	cmp    $0x39,%ebx
  800ede:	7f 39                	jg     800f19 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ee0:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ee3:	eb d5                	jmp    800eba <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ee5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ee8:	83 c0 04             	add    $0x4,%eax
  800eeb:	89 45 14             	mov    %eax,0x14(%ebp)
  800eee:	8b 45 14             	mov    0x14(%ebp),%eax
  800ef1:	83 e8 04             	sub    $0x4,%eax
  800ef4:	8b 00                	mov    (%eax),%eax
  800ef6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800ef9:	eb 1f                	jmp    800f1a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800efb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800eff:	79 83                	jns    800e84 <vprintfmt+0x54>
				width = 0;
  800f01:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800f08:	e9 77 ff ff ff       	jmp    800e84 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800f0d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800f14:	e9 6b ff ff ff       	jmp    800e84 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800f19:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800f1a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f1e:	0f 89 60 ff ff ff    	jns    800e84 <vprintfmt+0x54>
				width = precision, precision = -1;
  800f24:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f27:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800f2a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800f31:	e9 4e ff ff ff       	jmp    800e84 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800f36:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800f39:	e9 46 ff ff ff       	jmp    800e84 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800f3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f41:	83 c0 04             	add    $0x4,%eax
  800f44:	89 45 14             	mov    %eax,0x14(%ebp)
  800f47:	8b 45 14             	mov    0x14(%ebp),%eax
  800f4a:	83 e8 04             	sub    $0x4,%eax
  800f4d:	8b 00                	mov    (%eax),%eax
  800f4f:	83 ec 08             	sub    $0x8,%esp
  800f52:	ff 75 0c             	pushl  0xc(%ebp)
  800f55:	50                   	push   %eax
  800f56:	8b 45 08             	mov    0x8(%ebp),%eax
  800f59:	ff d0                	call   *%eax
  800f5b:	83 c4 10             	add    $0x10,%esp
			break;
  800f5e:	e9 89 02 00 00       	jmp    8011ec <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800f63:	8b 45 14             	mov    0x14(%ebp),%eax
  800f66:	83 c0 04             	add    $0x4,%eax
  800f69:	89 45 14             	mov    %eax,0x14(%ebp)
  800f6c:	8b 45 14             	mov    0x14(%ebp),%eax
  800f6f:	83 e8 04             	sub    $0x4,%eax
  800f72:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800f74:	85 db                	test   %ebx,%ebx
  800f76:	79 02                	jns    800f7a <vprintfmt+0x14a>
				err = -err;
  800f78:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800f7a:	83 fb 64             	cmp    $0x64,%ebx
  800f7d:	7f 0b                	jg     800f8a <vprintfmt+0x15a>
  800f7f:	8b 34 9d 00 45 80 00 	mov    0x804500(,%ebx,4),%esi
  800f86:	85 f6                	test   %esi,%esi
  800f88:	75 19                	jne    800fa3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800f8a:	53                   	push   %ebx
  800f8b:	68 a5 46 80 00       	push   $0x8046a5
  800f90:	ff 75 0c             	pushl  0xc(%ebp)
  800f93:	ff 75 08             	pushl  0x8(%ebp)
  800f96:	e8 5e 02 00 00       	call   8011f9 <printfmt>
  800f9b:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f9e:	e9 49 02 00 00       	jmp    8011ec <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800fa3:	56                   	push   %esi
  800fa4:	68 ae 46 80 00       	push   $0x8046ae
  800fa9:	ff 75 0c             	pushl  0xc(%ebp)
  800fac:	ff 75 08             	pushl  0x8(%ebp)
  800faf:	e8 45 02 00 00       	call   8011f9 <printfmt>
  800fb4:	83 c4 10             	add    $0x10,%esp
			break;
  800fb7:	e9 30 02 00 00       	jmp    8011ec <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800fbc:	8b 45 14             	mov    0x14(%ebp),%eax
  800fbf:	83 c0 04             	add    $0x4,%eax
  800fc2:	89 45 14             	mov    %eax,0x14(%ebp)
  800fc5:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc8:	83 e8 04             	sub    $0x4,%eax
  800fcb:	8b 30                	mov    (%eax),%esi
  800fcd:	85 f6                	test   %esi,%esi
  800fcf:	75 05                	jne    800fd6 <vprintfmt+0x1a6>
				p = "(null)";
  800fd1:	be b1 46 80 00       	mov    $0x8046b1,%esi
			if (width > 0 && padc != '-')
  800fd6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fda:	7e 6d                	jle    801049 <vprintfmt+0x219>
  800fdc:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800fe0:	74 67                	je     801049 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800fe2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fe5:	83 ec 08             	sub    $0x8,%esp
  800fe8:	50                   	push   %eax
  800fe9:	56                   	push   %esi
  800fea:	e8 12 05 00 00       	call   801501 <strnlen>
  800fef:	83 c4 10             	add    $0x10,%esp
  800ff2:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ff5:	eb 16                	jmp    80100d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ff7:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ffb:	83 ec 08             	sub    $0x8,%esp
  800ffe:	ff 75 0c             	pushl  0xc(%ebp)
  801001:	50                   	push   %eax
  801002:	8b 45 08             	mov    0x8(%ebp),%eax
  801005:	ff d0                	call   *%eax
  801007:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80100a:	ff 4d e4             	decl   -0x1c(%ebp)
  80100d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801011:	7f e4                	jg     800ff7 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801013:	eb 34                	jmp    801049 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801015:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801019:	74 1c                	je     801037 <vprintfmt+0x207>
  80101b:	83 fb 1f             	cmp    $0x1f,%ebx
  80101e:	7e 05                	jle    801025 <vprintfmt+0x1f5>
  801020:	83 fb 7e             	cmp    $0x7e,%ebx
  801023:	7e 12                	jle    801037 <vprintfmt+0x207>
					putch('?', putdat);
  801025:	83 ec 08             	sub    $0x8,%esp
  801028:	ff 75 0c             	pushl  0xc(%ebp)
  80102b:	6a 3f                	push   $0x3f
  80102d:	8b 45 08             	mov    0x8(%ebp),%eax
  801030:	ff d0                	call   *%eax
  801032:	83 c4 10             	add    $0x10,%esp
  801035:	eb 0f                	jmp    801046 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801037:	83 ec 08             	sub    $0x8,%esp
  80103a:	ff 75 0c             	pushl  0xc(%ebp)
  80103d:	53                   	push   %ebx
  80103e:	8b 45 08             	mov    0x8(%ebp),%eax
  801041:	ff d0                	call   *%eax
  801043:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801046:	ff 4d e4             	decl   -0x1c(%ebp)
  801049:	89 f0                	mov    %esi,%eax
  80104b:	8d 70 01             	lea    0x1(%eax),%esi
  80104e:	8a 00                	mov    (%eax),%al
  801050:	0f be d8             	movsbl %al,%ebx
  801053:	85 db                	test   %ebx,%ebx
  801055:	74 24                	je     80107b <vprintfmt+0x24b>
  801057:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80105b:	78 b8                	js     801015 <vprintfmt+0x1e5>
  80105d:	ff 4d e0             	decl   -0x20(%ebp)
  801060:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801064:	79 af                	jns    801015 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801066:	eb 13                	jmp    80107b <vprintfmt+0x24b>
				putch(' ', putdat);
  801068:	83 ec 08             	sub    $0x8,%esp
  80106b:	ff 75 0c             	pushl  0xc(%ebp)
  80106e:	6a 20                	push   $0x20
  801070:	8b 45 08             	mov    0x8(%ebp),%eax
  801073:	ff d0                	call   *%eax
  801075:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801078:	ff 4d e4             	decl   -0x1c(%ebp)
  80107b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80107f:	7f e7                	jg     801068 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801081:	e9 66 01 00 00       	jmp    8011ec <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801086:	83 ec 08             	sub    $0x8,%esp
  801089:	ff 75 e8             	pushl  -0x18(%ebp)
  80108c:	8d 45 14             	lea    0x14(%ebp),%eax
  80108f:	50                   	push   %eax
  801090:	e8 3c fd ff ff       	call   800dd1 <getint>
  801095:	83 c4 10             	add    $0x10,%esp
  801098:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80109b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80109e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010a4:	85 d2                	test   %edx,%edx
  8010a6:	79 23                	jns    8010cb <vprintfmt+0x29b>
				putch('-', putdat);
  8010a8:	83 ec 08             	sub    $0x8,%esp
  8010ab:	ff 75 0c             	pushl  0xc(%ebp)
  8010ae:	6a 2d                	push   $0x2d
  8010b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b3:	ff d0                	call   *%eax
  8010b5:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8010b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010be:	f7 d8                	neg    %eax
  8010c0:	83 d2 00             	adc    $0x0,%edx
  8010c3:	f7 da                	neg    %edx
  8010c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010c8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8010cb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010d2:	e9 bc 00 00 00       	jmp    801193 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8010d7:	83 ec 08             	sub    $0x8,%esp
  8010da:	ff 75 e8             	pushl  -0x18(%ebp)
  8010dd:	8d 45 14             	lea    0x14(%ebp),%eax
  8010e0:	50                   	push   %eax
  8010e1:	e8 84 fc ff ff       	call   800d6a <getuint>
  8010e6:	83 c4 10             	add    $0x10,%esp
  8010e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010ec:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8010ef:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010f6:	e9 98 00 00 00       	jmp    801193 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
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
			putch('X', putdat);
  80111b:	83 ec 08             	sub    $0x8,%esp
  80111e:	ff 75 0c             	pushl  0xc(%ebp)
  801121:	6a 58                	push   $0x58
  801123:	8b 45 08             	mov    0x8(%ebp),%eax
  801126:	ff d0                	call   *%eax
  801128:	83 c4 10             	add    $0x10,%esp
			break;
  80112b:	e9 bc 00 00 00       	jmp    8011ec <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801130:	83 ec 08             	sub    $0x8,%esp
  801133:	ff 75 0c             	pushl  0xc(%ebp)
  801136:	6a 30                	push   $0x30
  801138:	8b 45 08             	mov    0x8(%ebp),%eax
  80113b:	ff d0                	call   *%eax
  80113d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801140:	83 ec 08             	sub    $0x8,%esp
  801143:	ff 75 0c             	pushl  0xc(%ebp)
  801146:	6a 78                	push   $0x78
  801148:	8b 45 08             	mov    0x8(%ebp),%eax
  80114b:	ff d0                	call   *%eax
  80114d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801150:	8b 45 14             	mov    0x14(%ebp),%eax
  801153:	83 c0 04             	add    $0x4,%eax
  801156:	89 45 14             	mov    %eax,0x14(%ebp)
  801159:	8b 45 14             	mov    0x14(%ebp),%eax
  80115c:	83 e8 04             	sub    $0x4,%eax
  80115f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801161:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801164:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80116b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801172:	eb 1f                	jmp    801193 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801174:	83 ec 08             	sub    $0x8,%esp
  801177:	ff 75 e8             	pushl  -0x18(%ebp)
  80117a:	8d 45 14             	lea    0x14(%ebp),%eax
  80117d:	50                   	push   %eax
  80117e:	e8 e7 fb ff ff       	call   800d6a <getuint>
  801183:	83 c4 10             	add    $0x10,%esp
  801186:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801189:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80118c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801193:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801197:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80119a:	83 ec 04             	sub    $0x4,%esp
  80119d:	52                   	push   %edx
  80119e:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011a1:	50                   	push   %eax
  8011a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8011a5:	ff 75 f0             	pushl  -0x10(%ebp)
  8011a8:	ff 75 0c             	pushl  0xc(%ebp)
  8011ab:	ff 75 08             	pushl  0x8(%ebp)
  8011ae:	e8 00 fb ff ff       	call   800cb3 <printnum>
  8011b3:	83 c4 20             	add    $0x20,%esp
			break;
  8011b6:	eb 34                	jmp    8011ec <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8011b8:	83 ec 08             	sub    $0x8,%esp
  8011bb:	ff 75 0c             	pushl  0xc(%ebp)
  8011be:	53                   	push   %ebx
  8011bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c2:	ff d0                	call   *%eax
  8011c4:	83 c4 10             	add    $0x10,%esp
			break;
  8011c7:	eb 23                	jmp    8011ec <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8011c9:	83 ec 08             	sub    $0x8,%esp
  8011cc:	ff 75 0c             	pushl  0xc(%ebp)
  8011cf:	6a 25                	push   $0x25
  8011d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d4:	ff d0                	call   *%eax
  8011d6:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8011d9:	ff 4d 10             	decl   0x10(%ebp)
  8011dc:	eb 03                	jmp    8011e1 <vprintfmt+0x3b1>
  8011de:	ff 4d 10             	decl   0x10(%ebp)
  8011e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e4:	48                   	dec    %eax
  8011e5:	8a 00                	mov    (%eax),%al
  8011e7:	3c 25                	cmp    $0x25,%al
  8011e9:	75 f3                	jne    8011de <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8011eb:	90                   	nop
		}
	}
  8011ec:	e9 47 fc ff ff       	jmp    800e38 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8011f1:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8011f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011f5:	5b                   	pop    %ebx
  8011f6:	5e                   	pop    %esi
  8011f7:	5d                   	pop    %ebp
  8011f8:	c3                   	ret    

008011f9 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8011f9:	55                   	push   %ebp
  8011fa:	89 e5                	mov    %esp,%ebp
  8011fc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8011ff:	8d 45 10             	lea    0x10(%ebp),%eax
  801202:	83 c0 04             	add    $0x4,%eax
  801205:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801208:	8b 45 10             	mov    0x10(%ebp),%eax
  80120b:	ff 75 f4             	pushl  -0xc(%ebp)
  80120e:	50                   	push   %eax
  80120f:	ff 75 0c             	pushl  0xc(%ebp)
  801212:	ff 75 08             	pushl  0x8(%ebp)
  801215:	e8 16 fc ff ff       	call   800e30 <vprintfmt>
  80121a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80121d:	90                   	nop
  80121e:	c9                   	leave  
  80121f:	c3                   	ret    

00801220 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801220:	55                   	push   %ebp
  801221:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801223:	8b 45 0c             	mov    0xc(%ebp),%eax
  801226:	8b 40 08             	mov    0x8(%eax),%eax
  801229:	8d 50 01             	lea    0x1(%eax),%edx
  80122c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801232:	8b 45 0c             	mov    0xc(%ebp),%eax
  801235:	8b 10                	mov    (%eax),%edx
  801237:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123a:	8b 40 04             	mov    0x4(%eax),%eax
  80123d:	39 c2                	cmp    %eax,%edx
  80123f:	73 12                	jae    801253 <sprintputch+0x33>
		*b->buf++ = ch;
  801241:	8b 45 0c             	mov    0xc(%ebp),%eax
  801244:	8b 00                	mov    (%eax),%eax
  801246:	8d 48 01             	lea    0x1(%eax),%ecx
  801249:	8b 55 0c             	mov    0xc(%ebp),%edx
  80124c:	89 0a                	mov    %ecx,(%edx)
  80124e:	8b 55 08             	mov    0x8(%ebp),%edx
  801251:	88 10                	mov    %dl,(%eax)
}
  801253:	90                   	nop
  801254:	5d                   	pop    %ebp
  801255:	c3                   	ret    

00801256 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801256:	55                   	push   %ebp
  801257:	89 e5                	mov    %esp,%ebp
  801259:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80125c:	8b 45 08             	mov    0x8(%ebp),%eax
  80125f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801262:	8b 45 0c             	mov    0xc(%ebp),%eax
  801265:	8d 50 ff             	lea    -0x1(%eax),%edx
  801268:	8b 45 08             	mov    0x8(%ebp),%eax
  80126b:	01 d0                	add    %edx,%eax
  80126d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801270:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801277:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80127b:	74 06                	je     801283 <vsnprintf+0x2d>
  80127d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801281:	7f 07                	jg     80128a <vsnprintf+0x34>
		return -E_INVAL;
  801283:	b8 03 00 00 00       	mov    $0x3,%eax
  801288:	eb 20                	jmp    8012aa <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80128a:	ff 75 14             	pushl  0x14(%ebp)
  80128d:	ff 75 10             	pushl  0x10(%ebp)
  801290:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801293:	50                   	push   %eax
  801294:	68 20 12 80 00       	push   $0x801220
  801299:	e8 92 fb ff ff       	call   800e30 <vprintfmt>
  80129e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8012a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012a4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8012a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8012aa:	c9                   	leave  
  8012ab:	c3                   	ret    

008012ac <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8012ac:	55                   	push   %ebp
  8012ad:	89 e5                	mov    %esp,%ebp
  8012af:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8012b2:	8d 45 10             	lea    0x10(%ebp),%eax
  8012b5:	83 c0 04             	add    $0x4,%eax
  8012b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8012bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8012be:	ff 75 f4             	pushl  -0xc(%ebp)
  8012c1:	50                   	push   %eax
  8012c2:	ff 75 0c             	pushl  0xc(%ebp)
  8012c5:	ff 75 08             	pushl  0x8(%ebp)
  8012c8:	e8 89 ff ff ff       	call   801256 <vsnprintf>
  8012cd:	83 c4 10             	add    $0x10,%esp
  8012d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8012d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012d6:	c9                   	leave  
  8012d7:	c3                   	ret    

008012d8 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8012d8:	55                   	push   %ebp
  8012d9:	89 e5                	mov    %esp,%ebp
  8012db:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  8012de:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012e2:	74 13                	je     8012f7 <readline+0x1f>
		cprintf("%s", prompt);
  8012e4:	83 ec 08             	sub    $0x8,%esp
  8012e7:	ff 75 08             	pushl  0x8(%ebp)
  8012ea:	68 10 48 80 00       	push   $0x804810
  8012ef:	e8 62 f9 ff ff       	call   800c56 <cprintf>
  8012f4:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8012f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8012fe:	83 ec 0c             	sub    $0xc,%esp
  801301:	6a 00                	push   $0x0
  801303:	e8 54 f5 ff ff       	call   80085c <iscons>
  801308:	83 c4 10             	add    $0x10,%esp
  80130b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  80130e:	e8 fb f4 ff ff       	call   80080e <getchar>
  801313:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801316:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80131a:	79 22                	jns    80133e <readline+0x66>
			if (c != -E_EOF)
  80131c:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801320:	0f 84 ad 00 00 00    	je     8013d3 <readline+0xfb>
				cprintf("read error: %e\n", c);
  801326:	83 ec 08             	sub    $0x8,%esp
  801329:	ff 75 ec             	pushl  -0x14(%ebp)
  80132c:	68 13 48 80 00       	push   $0x804813
  801331:	e8 20 f9 ff ff       	call   800c56 <cprintf>
  801336:	83 c4 10             	add    $0x10,%esp
			return;
  801339:	e9 95 00 00 00       	jmp    8013d3 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80133e:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801342:	7e 34                	jle    801378 <readline+0xa0>
  801344:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80134b:	7f 2b                	jg     801378 <readline+0xa0>
			if (echoing)
  80134d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801351:	74 0e                	je     801361 <readline+0x89>
				cputchar(c);
  801353:	83 ec 0c             	sub    $0xc,%esp
  801356:	ff 75 ec             	pushl  -0x14(%ebp)
  801359:	e8 68 f4 ff ff       	call   8007c6 <cputchar>
  80135e:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801361:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801364:	8d 50 01             	lea    0x1(%eax),%edx
  801367:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80136a:	89 c2                	mov    %eax,%edx
  80136c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136f:	01 d0                	add    %edx,%eax
  801371:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801374:	88 10                	mov    %dl,(%eax)
  801376:	eb 56                	jmp    8013ce <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801378:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80137c:	75 1f                	jne    80139d <readline+0xc5>
  80137e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801382:	7e 19                	jle    80139d <readline+0xc5>
			if (echoing)
  801384:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801388:	74 0e                	je     801398 <readline+0xc0>
				cputchar(c);
  80138a:	83 ec 0c             	sub    $0xc,%esp
  80138d:	ff 75 ec             	pushl  -0x14(%ebp)
  801390:	e8 31 f4 ff ff       	call   8007c6 <cputchar>
  801395:	83 c4 10             	add    $0x10,%esp

			i--;
  801398:	ff 4d f4             	decl   -0xc(%ebp)
  80139b:	eb 31                	jmp    8013ce <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  80139d:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8013a1:	74 0a                	je     8013ad <readline+0xd5>
  8013a3:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8013a7:	0f 85 61 ff ff ff    	jne    80130e <readline+0x36>
			if (echoing)
  8013ad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013b1:	74 0e                	je     8013c1 <readline+0xe9>
				cputchar(c);
  8013b3:	83 ec 0c             	sub    $0xc,%esp
  8013b6:	ff 75 ec             	pushl  -0x14(%ebp)
  8013b9:	e8 08 f4 ff ff       	call   8007c6 <cputchar>
  8013be:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8013c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c7:	01 d0                	add    %edx,%eax
  8013c9:	c6 00 00             	movb   $0x0,(%eax)
			return;
  8013cc:	eb 06                	jmp    8013d4 <readline+0xfc>
		}
	}
  8013ce:	e9 3b ff ff ff       	jmp    80130e <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  8013d3:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  8013d4:	c9                   	leave  
  8013d5:	c3                   	ret    

008013d6 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8013d6:	55                   	push   %ebp
  8013d7:	89 e5                	mov    %esp,%ebp
  8013d9:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8013dc:	e8 0d 0f 00 00       	call   8022ee <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  8013e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013e5:	74 13                	je     8013fa <atomic_readline+0x24>
		cprintf("%s", prompt);
  8013e7:	83 ec 08             	sub    $0x8,%esp
  8013ea:	ff 75 08             	pushl  0x8(%ebp)
  8013ed:	68 10 48 80 00       	push   $0x804810
  8013f2:	e8 5f f8 ff ff       	call   800c56 <cprintf>
  8013f7:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8013fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801401:	83 ec 0c             	sub    $0xc,%esp
  801404:	6a 00                	push   $0x0
  801406:	e8 51 f4 ff ff       	call   80085c <iscons>
  80140b:	83 c4 10             	add    $0x10,%esp
  80140e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801411:	e8 f8 f3 ff ff       	call   80080e <getchar>
  801416:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801419:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80141d:	79 23                	jns    801442 <atomic_readline+0x6c>
			if (c != -E_EOF)
  80141f:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801423:	74 13                	je     801438 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  801425:	83 ec 08             	sub    $0x8,%esp
  801428:	ff 75 ec             	pushl  -0x14(%ebp)
  80142b:	68 13 48 80 00       	push   $0x804813
  801430:	e8 21 f8 ff ff       	call   800c56 <cprintf>
  801435:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801438:	e8 cb 0e 00 00       	call   802308 <sys_enable_interrupt>
			return;
  80143d:	e9 9a 00 00 00       	jmp    8014dc <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801442:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801446:	7e 34                	jle    80147c <atomic_readline+0xa6>
  801448:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80144f:	7f 2b                	jg     80147c <atomic_readline+0xa6>
			if (echoing)
  801451:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801455:	74 0e                	je     801465 <atomic_readline+0x8f>
				cputchar(c);
  801457:	83 ec 0c             	sub    $0xc,%esp
  80145a:	ff 75 ec             	pushl  -0x14(%ebp)
  80145d:	e8 64 f3 ff ff       	call   8007c6 <cputchar>
  801462:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801465:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801468:	8d 50 01             	lea    0x1(%eax),%edx
  80146b:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80146e:	89 c2                	mov    %eax,%edx
  801470:	8b 45 0c             	mov    0xc(%ebp),%eax
  801473:	01 d0                	add    %edx,%eax
  801475:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801478:	88 10                	mov    %dl,(%eax)
  80147a:	eb 5b                	jmp    8014d7 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  80147c:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801480:	75 1f                	jne    8014a1 <atomic_readline+0xcb>
  801482:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801486:	7e 19                	jle    8014a1 <atomic_readline+0xcb>
			if (echoing)
  801488:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80148c:	74 0e                	je     80149c <atomic_readline+0xc6>
				cputchar(c);
  80148e:	83 ec 0c             	sub    $0xc,%esp
  801491:	ff 75 ec             	pushl  -0x14(%ebp)
  801494:	e8 2d f3 ff ff       	call   8007c6 <cputchar>
  801499:	83 c4 10             	add    $0x10,%esp
			i--;
  80149c:	ff 4d f4             	decl   -0xc(%ebp)
  80149f:	eb 36                	jmp    8014d7 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  8014a1:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8014a5:	74 0a                	je     8014b1 <atomic_readline+0xdb>
  8014a7:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8014ab:	0f 85 60 ff ff ff    	jne    801411 <atomic_readline+0x3b>
			if (echoing)
  8014b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8014b5:	74 0e                	je     8014c5 <atomic_readline+0xef>
				cputchar(c);
  8014b7:	83 ec 0c             	sub    $0xc,%esp
  8014ba:	ff 75 ec             	pushl  -0x14(%ebp)
  8014bd:	e8 04 f3 ff ff       	call   8007c6 <cputchar>
  8014c2:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  8014c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014cb:	01 d0                	add    %edx,%eax
  8014cd:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  8014d0:	e8 33 0e 00 00       	call   802308 <sys_enable_interrupt>
			return;
  8014d5:	eb 05                	jmp    8014dc <atomic_readline+0x106>
		}
	}
  8014d7:	e9 35 ff ff ff       	jmp    801411 <atomic_readline+0x3b>
}
  8014dc:	c9                   	leave  
  8014dd:	c3                   	ret    

008014de <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8014de:	55                   	push   %ebp
  8014df:	89 e5                	mov    %esp,%ebp
  8014e1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8014e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014eb:	eb 06                	jmp    8014f3 <strlen+0x15>
		n++;
  8014ed:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8014f0:	ff 45 08             	incl   0x8(%ebp)
  8014f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f6:	8a 00                	mov    (%eax),%al
  8014f8:	84 c0                	test   %al,%al
  8014fa:	75 f1                	jne    8014ed <strlen+0xf>
		n++;
	return n;
  8014fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8014ff:	c9                   	leave  
  801500:	c3                   	ret    

00801501 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801501:	55                   	push   %ebp
  801502:	89 e5                	mov    %esp,%ebp
  801504:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801507:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80150e:	eb 09                	jmp    801519 <strnlen+0x18>
		n++;
  801510:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801513:	ff 45 08             	incl   0x8(%ebp)
  801516:	ff 4d 0c             	decl   0xc(%ebp)
  801519:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80151d:	74 09                	je     801528 <strnlen+0x27>
  80151f:	8b 45 08             	mov    0x8(%ebp),%eax
  801522:	8a 00                	mov    (%eax),%al
  801524:	84 c0                	test   %al,%al
  801526:	75 e8                	jne    801510 <strnlen+0xf>
		n++;
	return n;
  801528:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80152b:	c9                   	leave  
  80152c:	c3                   	ret    

0080152d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80152d:	55                   	push   %ebp
  80152e:	89 e5                	mov    %esp,%ebp
  801530:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801533:	8b 45 08             	mov    0x8(%ebp),%eax
  801536:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801539:	90                   	nop
  80153a:	8b 45 08             	mov    0x8(%ebp),%eax
  80153d:	8d 50 01             	lea    0x1(%eax),%edx
  801540:	89 55 08             	mov    %edx,0x8(%ebp)
  801543:	8b 55 0c             	mov    0xc(%ebp),%edx
  801546:	8d 4a 01             	lea    0x1(%edx),%ecx
  801549:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80154c:	8a 12                	mov    (%edx),%dl
  80154e:	88 10                	mov    %dl,(%eax)
  801550:	8a 00                	mov    (%eax),%al
  801552:	84 c0                	test   %al,%al
  801554:	75 e4                	jne    80153a <strcpy+0xd>
		/* do nothing */;
	return ret;
  801556:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801559:	c9                   	leave  
  80155a:	c3                   	ret    

0080155b <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80155b:	55                   	push   %ebp
  80155c:	89 e5                	mov    %esp,%ebp
  80155e:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801561:	8b 45 08             	mov    0x8(%ebp),%eax
  801564:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801567:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80156e:	eb 1f                	jmp    80158f <strncpy+0x34>
		*dst++ = *src;
  801570:	8b 45 08             	mov    0x8(%ebp),%eax
  801573:	8d 50 01             	lea    0x1(%eax),%edx
  801576:	89 55 08             	mov    %edx,0x8(%ebp)
  801579:	8b 55 0c             	mov    0xc(%ebp),%edx
  80157c:	8a 12                	mov    (%edx),%dl
  80157e:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801580:	8b 45 0c             	mov    0xc(%ebp),%eax
  801583:	8a 00                	mov    (%eax),%al
  801585:	84 c0                	test   %al,%al
  801587:	74 03                	je     80158c <strncpy+0x31>
			src++;
  801589:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80158c:	ff 45 fc             	incl   -0x4(%ebp)
  80158f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801592:	3b 45 10             	cmp    0x10(%ebp),%eax
  801595:	72 d9                	jb     801570 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801597:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80159a:	c9                   	leave  
  80159b:	c3                   	ret    

0080159c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80159c:	55                   	push   %ebp
  80159d:	89 e5                	mov    %esp,%ebp
  80159f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8015a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8015a8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015ac:	74 30                	je     8015de <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8015ae:	eb 16                	jmp    8015c6 <strlcpy+0x2a>
			*dst++ = *src++;
  8015b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b3:	8d 50 01             	lea    0x1(%eax),%edx
  8015b6:	89 55 08             	mov    %edx,0x8(%ebp)
  8015b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015bc:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015bf:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8015c2:	8a 12                	mov    (%edx),%dl
  8015c4:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8015c6:	ff 4d 10             	decl   0x10(%ebp)
  8015c9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015cd:	74 09                	je     8015d8 <strlcpy+0x3c>
  8015cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d2:	8a 00                	mov    (%eax),%al
  8015d4:	84 c0                	test   %al,%al
  8015d6:	75 d8                	jne    8015b0 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8015d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015db:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8015de:	8b 55 08             	mov    0x8(%ebp),%edx
  8015e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015e4:	29 c2                	sub    %eax,%edx
  8015e6:	89 d0                	mov    %edx,%eax
}
  8015e8:	c9                   	leave  
  8015e9:	c3                   	ret    

008015ea <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8015ea:	55                   	push   %ebp
  8015eb:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8015ed:	eb 06                	jmp    8015f5 <strcmp+0xb>
		p++, q++;
  8015ef:	ff 45 08             	incl   0x8(%ebp)
  8015f2:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8015f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f8:	8a 00                	mov    (%eax),%al
  8015fa:	84 c0                	test   %al,%al
  8015fc:	74 0e                	je     80160c <strcmp+0x22>
  8015fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801601:	8a 10                	mov    (%eax),%dl
  801603:	8b 45 0c             	mov    0xc(%ebp),%eax
  801606:	8a 00                	mov    (%eax),%al
  801608:	38 c2                	cmp    %al,%dl
  80160a:	74 e3                	je     8015ef <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80160c:	8b 45 08             	mov    0x8(%ebp),%eax
  80160f:	8a 00                	mov    (%eax),%al
  801611:	0f b6 d0             	movzbl %al,%edx
  801614:	8b 45 0c             	mov    0xc(%ebp),%eax
  801617:	8a 00                	mov    (%eax),%al
  801619:	0f b6 c0             	movzbl %al,%eax
  80161c:	29 c2                	sub    %eax,%edx
  80161e:	89 d0                	mov    %edx,%eax
}
  801620:	5d                   	pop    %ebp
  801621:	c3                   	ret    

00801622 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801622:	55                   	push   %ebp
  801623:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801625:	eb 09                	jmp    801630 <strncmp+0xe>
		n--, p++, q++;
  801627:	ff 4d 10             	decl   0x10(%ebp)
  80162a:	ff 45 08             	incl   0x8(%ebp)
  80162d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801630:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801634:	74 17                	je     80164d <strncmp+0x2b>
  801636:	8b 45 08             	mov    0x8(%ebp),%eax
  801639:	8a 00                	mov    (%eax),%al
  80163b:	84 c0                	test   %al,%al
  80163d:	74 0e                	je     80164d <strncmp+0x2b>
  80163f:	8b 45 08             	mov    0x8(%ebp),%eax
  801642:	8a 10                	mov    (%eax),%dl
  801644:	8b 45 0c             	mov    0xc(%ebp),%eax
  801647:	8a 00                	mov    (%eax),%al
  801649:	38 c2                	cmp    %al,%dl
  80164b:	74 da                	je     801627 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80164d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801651:	75 07                	jne    80165a <strncmp+0x38>
		return 0;
  801653:	b8 00 00 00 00       	mov    $0x0,%eax
  801658:	eb 14                	jmp    80166e <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80165a:	8b 45 08             	mov    0x8(%ebp),%eax
  80165d:	8a 00                	mov    (%eax),%al
  80165f:	0f b6 d0             	movzbl %al,%edx
  801662:	8b 45 0c             	mov    0xc(%ebp),%eax
  801665:	8a 00                	mov    (%eax),%al
  801667:	0f b6 c0             	movzbl %al,%eax
  80166a:	29 c2                	sub    %eax,%edx
  80166c:	89 d0                	mov    %edx,%eax
}
  80166e:	5d                   	pop    %ebp
  80166f:	c3                   	ret    

00801670 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801670:	55                   	push   %ebp
  801671:	89 e5                	mov    %esp,%ebp
  801673:	83 ec 04             	sub    $0x4,%esp
  801676:	8b 45 0c             	mov    0xc(%ebp),%eax
  801679:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80167c:	eb 12                	jmp    801690 <strchr+0x20>
		if (*s == c)
  80167e:	8b 45 08             	mov    0x8(%ebp),%eax
  801681:	8a 00                	mov    (%eax),%al
  801683:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801686:	75 05                	jne    80168d <strchr+0x1d>
			return (char *) s;
  801688:	8b 45 08             	mov    0x8(%ebp),%eax
  80168b:	eb 11                	jmp    80169e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80168d:	ff 45 08             	incl   0x8(%ebp)
  801690:	8b 45 08             	mov    0x8(%ebp),%eax
  801693:	8a 00                	mov    (%eax),%al
  801695:	84 c0                	test   %al,%al
  801697:	75 e5                	jne    80167e <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801699:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80169e:	c9                   	leave  
  80169f:	c3                   	ret    

008016a0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8016a0:	55                   	push   %ebp
  8016a1:	89 e5                	mov    %esp,%ebp
  8016a3:	83 ec 04             	sub    $0x4,%esp
  8016a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8016ac:	eb 0d                	jmp    8016bb <strfind+0x1b>
		if (*s == c)
  8016ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b1:	8a 00                	mov    (%eax),%al
  8016b3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8016b6:	74 0e                	je     8016c6 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8016b8:	ff 45 08             	incl   0x8(%ebp)
  8016bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016be:	8a 00                	mov    (%eax),%al
  8016c0:	84 c0                	test   %al,%al
  8016c2:	75 ea                	jne    8016ae <strfind+0xe>
  8016c4:	eb 01                	jmp    8016c7 <strfind+0x27>
		if (*s == c)
			break;
  8016c6:	90                   	nop
	return (char *) s;
  8016c7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016ca:	c9                   	leave  
  8016cb:	c3                   	ret    

008016cc <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8016cc:	55                   	push   %ebp
  8016cd:	89 e5                	mov    %esp,%ebp
  8016cf:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8016d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8016d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8016db:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8016de:	eb 0e                	jmp    8016ee <memset+0x22>
		*p++ = c;
  8016e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016e3:	8d 50 01             	lea    0x1(%eax),%edx
  8016e6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8016e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ec:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8016ee:	ff 4d f8             	decl   -0x8(%ebp)
  8016f1:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8016f5:	79 e9                	jns    8016e0 <memset+0x14>
		*p++ = c;

	return v;
  8016f7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016fa:	c9                   	leave  
  8016fb:	c3                   	ret    

008016fc <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8016fc:	55                   	push   %ebp
  8016fd:	89 e5                	mov    %esp,%ebp
  8016ff:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801702:	8b 45 0c             	mov    0xc(%ebp),%eax
  801705:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801708:	8b 45 08             	mov    0x8(%ebp),%eax
  80170b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80170e:	eb 16                	jmp    801726 <memcpy+0x2a>
		*d++ = *s++;
  801710:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801713:	8d 50 01             	lea    0x1(%eax),%edx
  801716:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801719:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80171c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80171f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801722:	8a 12                	mov    (%edx),%dl
  801724:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801726:	8b 45 10             	mov    0x10(%ebp),%eax
  801729:	8d 50 ff             	lea    -0x1(%eax),%edx
  80172c:	89 55 10             	mov    %edx,0x10(%ebp)
  80172f:	85 c0                	test   %eax,%eax
  801731:	75 dd                	jne    801710 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801733:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801736:	c9                   	leave  
  801737:	c3                   	ret    

00801738 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801738:	55                   	push   %ebp
  801739:	89 e5                	mov    %esp,%ebp
  80173b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80173e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801741:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801744:	8b 45 08             	mov    0x8(%ebp),%eax
  801747:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80174a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80174d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801750:	73 50                	jae    8017a2 <memmove+0x6a>
  801752:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801755:	8b 45 10             	mov    0x10(%ebp),%eax
  801758:	01 d0                	add    %edx,%eax
  80175a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80175d:	76 43                	jbe    8017a2 <memmove+0x6a>
		s += n;
  80175f:	8b 45 10             	mov    0x10(%ebp),%eax
  801762:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801765:	8b 45 10             	mov    0x10(%ebp),%eax
  801768:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80176b:	eb 10                	jmp    80177d <memmove+0x45>
			*--d = *--s;
  80176d:	ff 4d f8             	decl   -0x8(%ebp)
  801770:	ff 4d fc             	decl   -0x4(%ebp)
  801773:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801776:	8a 10                	mov    (%eax),%dl
  801778:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80177b:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80177d:	8b 45 10             	mov    0x10(%ebp),%eax
  801780:	8d 50 ff             	lea    -0x1(%eax),%edx
  801783:	89 55 10             	mov    %edx,0x10(%ebp)
  801786:	85 c0                	test   %eax,%eax
  801788:	75 e3                	jne    80176d <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80178a:	eb 23                	jmp    8017af <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80178c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80178f:	8d 50 01             	lea    0x1(%eax),%edx
  801792:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801795:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801798:	8d 4a 01             	lea    0x1(%edx),%ecx
  80179b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80179e:	8a 12                	mov    (%edx),%dl
  8017a0:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8017a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8017a5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8017a8:	89 55 10             	mov    %edx,0x10(%ebp)
  8017ab:	85 c0                	test   %eax,%eax
  8017ad:	75 dd                	jne    80178c <memmove+0x54>
			*d++ = *s++;

	return dst;
  8017af:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017b2:	c9                   	leave  
  8017b3:	c3                   	ret    

008017b4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8017b4:	55                   	push   %ebp
  8017b5:	89 e5                	mov    %esp,%ebp
  8017b7:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8017ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8017c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c3:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8017c6:	eb 2a                	jmp    8017f2 <memcmp+0x3e>
		if (*s1 != *s2)
  8017c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017cb:	8a 10                	mov    (%eax),%dl
  8017cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017d0:	8a 00                	mov    (%eax),%al
  8017d2:	38 c2                	cmp    %al,%dl
  8017d4:	74 16                	je     8017ec <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8017d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017d9:	8a 00                	mov    (%eax),%al
  8017db:	0f b6 d0             	movzbl %al,%edx
  8017de:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017e1:	8a 00                	mov    (%eax),%al
  8017e3:	0f b6 c0             	movzbl %al,%eax
  8017e6:	29 c2                	sub    %eax,%edx
  8017e8:	89 d0                	mov    %edx,%eax
  8017ea:	eb 18                	jmp    801804 <memcmp+0x50>
		s1++, s2++;
  8017ec:	ff 45 fc             	incl   -0x4(%ebp)
  8017ef:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8017f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8017f5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8017f8:	89 55 10             	mov    %edx,0x10(%ebp)
  8017fb:	85 c0                	test   %eax,%eax
  8017fd:	75 c9                	jne    8017c8 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8017ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801804:	c9                   	leave  
  801805:	c3                   	ret    

00801806 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801806:	55                   	push   %ebp
  801807:	89 e5                	mov    %esp,%ebp
  801809:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80180c:	8b 55 08             	mov    0x8(%ebp),%edx
  80180f:	8b 45 10             	mov    0x10(%ebp),%eax
  801812:	01 d0                	add    %edx,%eax
  801814:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801817:	eb 15                	jmp    80182e <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801819:	8b 45 08             	mov    0x8(%ebp),%eax
  80181c:	8a 00                	mov    (%eax),%al
  80181e:	0f b6 d0             	movzbl %al,%edx
  801821:	8b 45 0c             	mov    0xc(%ebp),%eax
  801824:	0f b6 c0             	movzbl %al,%eax
  801827:	39 c2                	cmp    %eax,%edx
  801829:	74 0d                	je     801838 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80182b:	ff 45 08             	incl   0x8(%ebp)
  80182e:	8b 45 08             	mov    0x8(%ebp),%eax
  801831:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801834:	72 e3                	jb     801819 <memfind+0x13>
  801836:	eb 01                	jmp    801839 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801838:	90                   	nop
	return (void *) s;
  801839:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80183c:	c9                   	leave  
  80183d:	c3                   	ret    

0080183e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80183e:	55                   	push   %ebp
  80183f:	89 e5                	mov    %esp,%ebp
  801841:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801844:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80184b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801852:	eb 03                	jmp    801857 <strtol+0x19>
		s++;
  801854:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801857:	8b 45 08             	mov    0x8(%ebp),%eax
  80185a:	8a 00                	mov    (%eax),%al
  80185c:	3c 20                	cmp    $0x20,%al
  80185e:	74 f4                	je     801854 <strtol+0x16>
  801860:	8b 45 08             	mov    0x8(%ebp),%eax
  801863:	8a 00                	mov    (%eax),%al
  801865:	3c 09                	cmp    $0x9,%al
  801867:	74 eb                	je     801854 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801869:	8b 45 08             	mov    0x8(%ebp),%eax
  80186c:	8a 00                	mov    (%eax),%al
  80186e:	3c 2b                	cmp    $0x2b,%al
  801870:	75 05                	jne    801877 <strtol+0x39>
		s++;
  801872:	ff 45 08             	incl   0x8(%ebp)
  801875:	eb 13                	jmp    80188a <strtol+0x4c>
	else if (*s == '-')
  801877:	8b 45 08             	mov    0x8(%ebp),%eax
  80187a:	8a 00                	mov    (%eax),%al
  80187c:	3c 2d                	cmp    $0x2d,%al
  80187e:	75 0a                	jne    80188a <strtol+0x4c>
		s++, neg = 1;
  801880:	ff 45 08             	incl   0x8(%ebp)
  801883:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80188a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80188e:	74 06                	je     801896 <strtol+0x58>
  801890:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801894:	75 20                	jne    8018b6 <strtol+0x78>
  801896:	8b 45 08             	mov    0x8(%ebp),%eax
  801899:	8a 00                	mov    (%eax),%al
  80189b:	3c 30                	cmp    $0x30,%al
  80189d:	75 17                	jne    8018b6 <strtol+0x78>
  80189f:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a2:	40                   	inc    %eax
  8018a3:	8a 00                	mov    (%eax),%al
  8018a5:	3c 78                	cmp    $0x78,%al
  8018a7:	75 0d                	jne    8018b6 <strtol+0x78>
		s += 2, base = 16;
  8018a9:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8018ad:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8018b4:	eb 28                	jmp    8018de <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8018b6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8018ba:	75 15                	jne    8018d1 <strtol+0x93>
  8018bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bf:	8a 00                	mov    (%eax),%al
  8018c1:	3c 30                	cmp    $0x30,%al
  8018c3:	75 0c                	jne    8018d1 <strtol+0x93>
		s++, base = 8;
  8018c5:	ff 45 08             	incl   0x8(%ebp)
  8018c8:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8018cf:	eb 0d                	jmp    8018de <strtol+0xa0>
	else if (base == 0)
  8018d1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8018d5:	75 07                	jne    8018de <strtol+0xa0>
		base = 10;
  8018d7:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8018de:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e1:	8a 00                	mov    (%eax),%al
  8018e3:	3c 2f                	cmp    $0x2f,%al
  8018e5:	7e 19                	jle    801900 <strtol+0xc2>
  8018e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ea:	8a 00                	mov    (%eax),%al
  8018ec:	3c 39                	cmp    $0x39,%al
  8018ee:	7f 10                	jg     801900 <strtol+0xc2>
			dig = *s - '0';
  8018f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f3:	8a 00                	mov    (%eax),%al
  8018f5:	0f be c0             	movsbl %al,%eax
  8018f8:	83 e8 30             	sub    $0x30,%eax
  8018fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018fe:	eb 42                	jmp    801942 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801900:	8b 45 08             	mov    0x8(%ebp),%eax
  801903:	8a 00                	mov    (%eax),%al
  801905:	3c 60                	cmp    $0x60,%al
  801907:	7e 19                	jle    801922 <strtol+0xe4>
  801909:	8b 45 08             	mov    0x8(%ebp),%eax
  80190c:	8a 00                	mov    (%eax),%al
  80190e:	3c 7a                	cmp    $0x7a,%al
  801910:	7f 10                	jg     801922 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801912:	8b 45 08             	mov    0x8(%ebp),%eax
  801915:	8a 00                	mov    (%eax),%al
  801917:	0f be c0             	movsbl %al,%eax
  80191a:	83 e8 57             	sub    $0x57,%eax
  80191d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801920:	eb 20                	jmp    801942 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801922:	8b 45 08             	mov    0x8(%ebp),%eax
  801925:	8a 00                	mov    (%eax),%al
  801927:	3c 40                	cmp    $0x40,%al
  801929:	7e 39                	jle    801964 <strtol+0x126>
  80192b:	8b 45 08             	mov    0x8(%ebp),%eax
  80192e:	8a 00                	mov    (%eax),%al
  801930:	3c 5a                	cmp    $0x5a,%al
  801932:	7f 30                	jg     801964 <strtol+0x126>
			dig = *s - 'A' + 10;
  801934:	8b 45 08             	mov    0x8(%ebp),%eax
  801937:	8a 00                	mov    (%eax),%al
  801939:	0f be c0             	movsbl %al,%eax
  80193c:	83 e8 37             	sub    $0x37,%eax
  80193f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801942:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801945:	3b 45 10             	cmp    0x10(%ebp),%eax
  801948:	7d 19                	jge    801963 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80194a:	ff 45 08             	incl   0x8(%ebp)
  80194d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801950:	0f af 45 10          	imul   0x10(%ebp),%eax
  801954:	89 c2                	mov    %eax,%edx
  801956:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801959:	01 d0                	add    %edx,%eax
  80195b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80195e:	e9 7b ff ff ff       	jmp    8018de <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801963:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801964:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801968:	74 08                	je     801972 <strtol+0x134>
		*endptr = (char *) s;
  80196a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80196d:	8b 55 08             	mov    0x8(%ebp),%edx
  801970:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801972:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801976:	74 07                	je     80197f <strtol+0x141>
  801978:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80197b:	f7 d8                	neg    %eax
  80197d:	eb 03                	jmp    801982 <strtol+0x144>
  80197f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801982:	c9                   	leave  
  801983:	c3                   	ret    

00801984 <ltostr>:

void
ltostr(long value, char *str)
{
  801984:	55                   	push   %ebp
  801985:	89 e5                	mov    %esp,%ebp
  801987:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80198a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801991:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801998:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80199c:	79 13                	jns    8019b1 <ltostr+0x2d>
	{
		neg = 1;
  80199e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8019a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a8:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8019ab:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8019ae:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8019b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b4:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8019b9:	99                   	cltd   
  8019ba:	f7 f9                	idiv   %ecx
  8019bc:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8019bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019c2:	8d 50 01             	lea    0x1(%eax),%edx
  8019c5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8019c8:	89 c2                	mov    %eax,%edx
  8019ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019cd:	01 d0                	add    %edx,%eax
  8019cf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8019d2:	83 c2 30             	add    $0x30,%edx
  8019d5:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8019d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019da:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8019df:	f7 e9                	imul   %ecx
  8019e1:	c1 fa 02             	sar    $0x2,%edx
  8019e4:	89 c8                	mov    %ecx,%eax
  8019e6:	c1 f8 1f             	sar    $0x1f,%eax
  8019e9:	29 c2                	sub    %eax,%edx
  8019eb:	89 d0                	mov    %edx,%eax
  8019ed:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8019f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019f3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8019f8:	f7 e9                	imul   %ecx
  8019fa:	c1 fa 02             	sar    $0x2,%edx
  8019fd:	89 c8                	mov    %ecx,%eax
  8019ff:	c1 f8 1f             	sar    $0x1f,%eax
  801a02:	29 c2                	sub    %eax,%edx
  801a04:	89 d0                	mov    %edx,%eax
  801a06:	c1 e0 02             	shl    $0x2,%eax
  801a09:	01 d0                	add    %edx,%eax
  801a0b:	01 c0                	add    %eax,%eax
  801a0d:	29 c1                	sub    %eax,%ecx
  801a0f:	89 ca                	mov    %ecx,%edx
  801a11:	85 d2                	test   %edx,%edx
  801a13:	75 9c                	jne    8019b1 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801a15:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801a1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a1f:	48                   	dec    %eax
  801a20:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801a23:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a27:	74 3d                	je     801a66 <ltostr+0xe2>
		start = 1 ;
  801a29:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801a30:	eb 34                	jmp    801a66 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801a32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a35:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a38:	01 d0                	add    %edx,%eax
  801a3a:	8a 00                	mov    (%eax),%al
  801a3c:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801a3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a42:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a45:	01 c2                	add    %eax,%edx
  801a47:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801a4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a4d:	01 c8                	add    %ecx,%eax
  801a4f:	8a 00                	mov    (%eax),%al
  801a51:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801a53:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a56:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a59:	01 c2                	add    %eax,%edx
  801a5b:	8a 45 eb             	mov    -0x15(%ebp),%al
  801a5e:	88 02                	mov    %al,(%edx)
		start++ ;
  801a60:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801a63:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a69:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a6c:	7c c4                	jl     801a32 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801a6e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801a71:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a74:	01 d0                	add    %edx,%eax
  801a76:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801a79:	90                   	nop
  801a7a:	c9                   	leave  
  801a7b:	c3                   	ret    

00801a7c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801a7c:	55                   	push   %ebp
  801a7d:	89 e5                	mov    %esp,%ebp
  801a7f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801a82:	ff 75 08             	pushl  0x8(%ebp)
  801a85:	e8 54 fa ff ff       	call   8014de <strlen>
  801a8a:	83 c4 04             	add    $0x4,%esp
  801a8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801a90:	ff 75 0c             	pushl  0xc(%ebp)
  801a93:	e8 46 fa ff ff       	call   8014de <strlen>
  801a98:	83 c4 04             	add    $0x4,%esp
  801a9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801a9e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801aa5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801aac:	eb 17                	jmp    801ac5 <strcconcat+0x49>
		final[s] = str1[s] ;
  801aae:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ab1:	8b 45 10             	mov    0x10(%ebp),%eax
  801ab4:	01 c2                	add    %eax,%edx
  801ab6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  801abc:	01 c8                	add    %ecx,%eax
  801abe:	8a 00                	mov    (%eax),%al
  801ac0:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801ac2:	ff 45 fc             	incl   -0x4(%ebp)
  801ac5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ac8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801acb:	7c e1                	jl     801aae <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801acd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801ad4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801adb:	eb 1f                	jmp    801afc <strcconcat+0x80>
		final[s++] = str2[i] ;
  801add:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ae0:	8d 50 01             	lea    0x1(%eax),%edx
  801ae3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801ae6:	89 c2                	mov    %eax,%edx
  801ae8:	8b 45 10             	mov    0x10(%ebp),%eax
  801aeb:	01 c2                	add    %eax,%edx
  801aed:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801af0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af3:	01 c8                	add    %ecx,%eax
  801af5:	8a 00                	mov    (%eax),%al
  801af7:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801af9:	ff 45 f8             	incl   -0x8(%ebp)
  801afc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801aff:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b02:	7c d9                	jl     801add <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801b04:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b07:	8b 45 10             	mov    0x10(%ebp),%eax
  801b0a:	01 d0                	add    %edx,%eax
  801b0c:	c6 00 00             	movb   $0x0,(%eax)
}
  801b0f:	90                   	nop
  801b10:	c9                   	leave  
  801b11:	c3                   	ret    

00801b12 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801b12:	55                   	push   %ebp
  801b13:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801b15:	8b 45 14             	mov    0x14(%ebp),%eax
  801b18:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801b1e:	8b 45 14             	mov    0x14(%ebp),%eax
  801b21:	8b 00                	mov    (%eax),%eax
  801b23:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b2a:	8b 45 10             	mov    0x10(%ebp),%eax
  801b2d:	01 d0                	add    %edx,%eax
  801b2f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801b35:	eb 0c                	jmp    801b43 <strsplit+0x31>
			*string++ = 0;
  801b37:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3a:	8d 50 01             	lea    0x1(%eax),%edx
  801b3d:	89 55 08             	mov    %edx,0x8(%ebp)
  801b40:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801b43:	8b 45 08             	mov    0x8(%ebp),%eax
  801b46:	8a 00                	mov    (%eax),%al
  801b48:	84 c0                	test   %al,%al
  801b4a:	74 18                	je     801b64 <strsplit+0x52>
  801b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4f:	8a 00                	mov    (%eax),%al
  801b51:	0f be c0             	movsbl %al,%eax
  801b54:	50                   	push   %eax
  801b55:	ff 75 0c             	pushl  0xc(%ebp)
  801b58:	e8 13 fb ff ff       	call   801670 <strchr>
  801b5d:	83 c4 08             	add    $0x8,%esp
  801b60:	85 c0                	test   %eax,%eax
  801b62:	75 d3                	jne    801b37 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801b64:	8b 45 08             	mov    0x8(%ebp),%eax
  801b67:	8a 00                	mov    (%eax),%al
  801b69:	84 c0                	test   %al,%al
  801b6b:	74 5a                	je     801bc7 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801b6d:	8b 45 14             	mov    0x14(%ebp),%eax
  801b70:	8b 00                	mov    (%eax),%eax
  801b72:	83 f8 0f             	cmp    $0xf,%eax
  801b75:	75 07                	jne    801b7e <strsplit+0x6c>
		{
			return 0;
  801b77:	b8 00 00 00 00       	mov    $0x0,%eax
  801b7c:	eb 66                	jmp    801be4 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801b7e:	8b 45 14             	mov    0x14(%ebp),%eax
  801b81:	8b 00                	mov    (%eax),%eax
  801b83:	8d 48 01             	lea    0x1(%eax),%ecx
  801b86:	8b 55 14             	mov    0x14(%ebp),%edx
  801b89:	89 0a                	mov    %ecx,(%edx)
  801b8b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b92:	8b 45 10             	mov    0x10(%ebp),%eax
  801b95:	01 c2                	add    %eax,%edx
  801b97:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801b9c:	eb 03                	jmp    801ba1 <strsplit+0x8f>
			string++;
  801b9e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba4:	8a 00                	mov    (%eax),%al
  801ba6:	84 c0                	test   %al,%al
  801ba8:	74 8b                	je     801b35 <strsplit+0x23>
  801baa:	8b 45 08             	mov    0x8(%ebp),%eax
  801bad:	8a 00                	mov    (%eax),%al
  801baf:	0f be c0             	movsbl %al,%eax
  801bb2:	50                   	push   %eax
  801bb3:	ff 75 0c             	pushl  0xc(%ebp)
  801bb6:	e8 b5 fa ff ff       	call   801670 <strchr>
  801bbb:	83 c4 08             	add    $0x8,%esp
  801bbe:	85 c0                	test   %eax,%eax
  801bc0:	74 dc                	je     801b9e <strsplit+0x8c>
			string++;
	}
  801bc2:	e9 6e ff ff ff       	jmp    801b35 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801bc7:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801bc8:	8b 45 14             	mov    0x14(%ebp),%eax
  801bcb:	8b 00                	mov    (%eax),%eax
  801bcd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801bd4:	8b 45 10             	mov    0x10(%ebp),%eax
  801bd7:	01 d0                	add    %edx,%eax
  801bd9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801bdf:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801be4:	c9                   	leave  
  801be5:	c3                   	ret    

00801be6 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801be6:	55                   	push   %ebp
  801be7:	89 e5                	mov    %esp,%ebp
  801be9:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801bec:	a1 04 50 80 00       	mov    0x805004,%eax
  801bf1:	85 c0                	test   %eax,%eax
  801bf3:	74 1f                	je     801c14 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801bf5:	e8 1d 00 00 00       	call   801c17 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801bfa:	83 ec 0c             	sub    $0xc,%esp
  801bfd:	68 24 48 80 00       	push   $0x804824
  801c02:	e8 4f f0 ff ff       	call   800c56 <cprintf>
  801c07:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801c0a:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801c11:	00 00 00 
	}
}
  801c14:	90                   	nop
  801c15:	c9                   	leave  
  801c16:	c3                   	ret    

00801c17 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801c17:	55                   	push   %ebp
  801c18:	89 e5                	mov    %esp,%ebp
  801c1a:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  801c1d:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801c24:	00 00 00 
  801c27:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801c2e:	00 00 00 
  801c31:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801c38:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801c3b:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801c42:	00 00 00 
  801c45:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801c4c:	00 00 00 
  801c4f:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801c56:	00 00 00 
	uint32 arr_size = 0;
  801c59:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  801c60:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801c67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c6a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c6f:	2d 00 10 00 00       	sub    $0x1000,%eax
  801c74:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  801c79:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801c80:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  801c83:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801c8a:	a1 20 51 80 00       	mov    0x805120,%eax
  801c8f:	c1 e0 04             	shl    $0x4,%eax
  801c92:	89 c2                	mov    %eax,%edx
  801c94:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c97:	01 d0                	add    %edx,%eax
  801c99:	48                   	dec    %eax
  801c9a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801c9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ca0:	ba 00 00 00 00       	mov    $0x0,%edx
  801ca5:	f7 75 ec             	divl   -0x14(%ebp)
  801ca8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801cab:	29 d0                	sub    %edx,%eax
  801cad:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  801cb0:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801cb7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801cba:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801cbf:	2d 00 10 00 00       	sub    $0x1000,%eax
  801cc4:	83 ec 04             	sub    $0x4,%esp
  801cc7:	6a 06                	push   $0x6
  801cc9:	ff 75 f4             	pushl  -0xc(%ebp)
  801ccc:	50                   	push   %eax
  801ccd:	e8 b2 05 00 00       	call   802284 <sys_allocate_chunk>
  801cd2:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801cd5:	a1 20 51 80 00       	mov    0x805120,%eax
  801cda:	83 ec 0c             	sub    $0xc,%esp
  801cdd:	50                   	push   %eax
  801cde:	e8 27 0c 00 00       	call   80290a <initialize_MemBlocksList>
  801ce3:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  801ce6:	a1 48 51 80 00       	mov    0x805148,%eax
  801ceb:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  801cee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cf1:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  801cf8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cfb:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  801d02:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801d06:	75 14                	jne    801d1c <initialize_dyn_block_system+0x105>
  801d08:	83 ec 04             	sub    $0x4,%esp
  801d0b:	68 49 48 80 00       	push   $0x804849
  801d10:	6a 33                	push   $0x33
  801d12:	68 67 48 80 00       	push   $0x804867
  801d17:	e8 86 ec ff ff       	call   8009a2 <_panic>
  801d1c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d1f:	8b 00                	mov    (%eax),%eax
  801d21:	85 c0                	test   %eax,%eax
  801d23:	74 10                	je     801d35 <initialize_dyn_block_system+0x11e>
  801d25:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d28:	8b 00                	mov    (%eax),%eax
  801d2a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d2d:	8b 52 04             	mov    0x4(%edx),%edx
  801d30:	89 50 04             	mov    %edx,0x4(%eax)
  801d33:	eb 0b                	jmp    801d40 <initialize_dyn_block_system+0x129>
  801d35:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d38:	8b 40 04             	mov    0x4(%eax),%eax
  801d3b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801d40:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d43:	8b 40 04             	mov    0x4(%eax),%eax
  801d46:	85 c0                	test   %eax,%eax
  801d48:	74 0f                	je     801d59 <initialize_dyn_block_system+0x142>
  801d4a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d4d:	8b 40 04             	mov    0x4(%eax),%eax
  801d50:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d53:	8b 12                	mov    (%edx),%edx
  801d55:	89 10                	mov    %edx,(%eax)
  801d57:	eb 0a                	jmp    801d63 <initialize_dyn_block_system+0x14c>
  801d59:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d5c:	8b 00                	mov    (%eax),%eax
  801d5e:	a3 48 51 80 00       	mov    %eax,0x805148
  801d63:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d66:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801d6c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d6f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801d76:	a1 54 51 80 00       	mov    0x805154,%eax
  801d7b:	48                   	dec    %eax
  801d7c:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  801d81:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801d85:	75 14                	jne    801d9b <initialize_dyn_block_system+0x184>
  801d87:	83 ec 04             	sub    $0x4,%esp
  801d8a:	68 74 48 80 00       	push   $0x804874
  801d8f:	6a 34                	push   $0x34
  801d91:	68 67 48 80 00       	push   $0x804867
  801d96:	e8 07 ec ff ff       	call   8009a2 <_panic>
  801d9b:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801da1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801da4:	89 10                	mov    %edx,(%eax)
  801da6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801da9:	8b 00                	mov    (%eax),%eax
  801dab:	85 c0                	test   %eax,%eax
  801dad:	74 0d                	je     801dbc <initialize_dyn_block_system+0x1a5>
  801daf:	a1 38 51 80 00       	mov    0x805138,%eax
  801db4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801db7:	89 50 04             	mov    %edx,0x4(%eax)
  801dba:	eb 08                	jmp    801dc4 <initialize_dyn_block_system+0x1ad>
  801dbc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801dbf:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801dc4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801dc7:	a3 38 51 80 00       	mov    %eax,0x805138
  801dcc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801dcf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801dd6:	a1 44 51 80 00       	mov    0x805144,%eax
  801ddb:	40                   	inc    %eax
  801ddc:	a3 44 51 80 00       	mov    %eax,0x805144
}
  801de1:	90                   	nop
  801de2:	c9                   	leave  
  801de3:	c3                   	ret    

00801de4 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801de4:	55                   	push   %ebp
  801de5:	89 e5                	mov    %esp,%ebp
  801de7:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801dea:	e8 f7 fd ff ff       	call   801be6 <InitializeUHeap>
	if (size == 0) return NULL ;
  801def:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801df3:	75 07                	jne    801dfc <malloc+0x18>
  801df5:	b8 00 00 00 00       	mov    $0x0,%eax
  801dfa:	eb 61                	jmp    801e5d <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  801dfc:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801e03:	8b 55 08             	mov    0x8(%ebp),%edx
  801e06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e09:	01 d0                	add    %edx,%eax
  801e0b:	48                   	dec    %eax
  801e0c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801e0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e12:	ba 00 00 00 00       	mov    $0x0,%edx
  801e17:	f7 75 f0             	divl   -0x10(%ebp)
  801e1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e1d:	29 d0                	sub    %edx,%eax
  801e1f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801e22:	e8 2b 08 00 00       	call   802652 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801e27:	85 c0                	test   %eax,%eax
  801e29:	74 11                	je     801e3c <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801e2b:	83 ec 0c             	sub    $0xc,%esp
  801e2e:	ff 75 e8             	pushl  -0x18(%ebp)
  801e31:	e8 96 0e 00 00       	call   802ccc <alloc_block_FF>
  801e36:	83 c4 10             	add    $0x10,%esp
  801e39:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  801e3c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e40:	74 16                	je     801e58 <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  801e42:	83 ec 0c             	sub    $0xc,%esp
  801e45:	ff 75 f4             	pushl  -0xc(%ebp)
  801e48:	e8 f2 0b 00 00       	call   802a3f <insert_sorted_allocList>
  801e4d:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  801e50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e53:	8b 40 08             	mov    0x8(%eax),%eax
  801e56:	eb 05                	jmp    801e5d <malloc+0x79>
	}

    return NULL;
  801e58:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e5d:	c9                   	leave  
  801e5e:	c3                   	ret    

00801e5f <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801e5f:	55                   	push   %ebp
  801e60:	89 e5                	mov    %esp,%ebp
  801e62:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801e65:	8b 45 08             	mov    0x8(%ebp),%eax
  801e68:	83 ec 08             	sub    $0x8,%esp
  801e6b:	50                   	push   %eax
  801e6c:	68 40 50 80 00       	push   $0x805040
  801e71:	e8 71 0b 00 00       	call   8029e7 <find_block>
  801e76:	83 c4 10             	add    $0x10,%esp
  801e79:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(free_block!=NULL)
  801e7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e80:	0f 84 a6 00 00 00    	je     801f2c <free+0xcd>
	{
		sys_free_user_mem(free_block->sva,free_block->size);
  801e86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e89:	8b 50 0c             	mov    0xc(%eax),%edx
  801e8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e8f:	8b 40 08             	mov    0x8(%eax),%eax
  801e92:	83 ec 08             	sub    $0x8,%esp
  801e95:	52                   	push   %edx
  801e96:	50                   	push   %eax
  801e97:	e8 b0 03 00 00       	call   80224c <sys_free_user_mem>
  801e9c:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,free_block);
  801e9f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ea3:	75 14                	jne    801eb9 <free+0x5a>
  801ea5:	83 ec 04             	sub    $0x4,%esp
  801ea8:	68 49 48 80 00       	push   $0x804849
  801ead:	6a 74                	push   $0x74
  801eaf:	68 67 48 80 00       	push   $0x804867
  801eb4:	e8 e9 ea ff ff       	call   8009a2 <_panic>
  801eb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ebc:	8b 00                	mov    (%eax),%eax
  801ebe:	85 c0                	test   %eax,%eax
  801ec0:	74 10                	je     801ed2 <free+0x73>
  801ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec5:	8b 00                	mov    (%eax),%eax
  801ec7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eca:	8b 52 04             	mov    0x4(%edx),%edx
  801ecd:	89 50 04             	mov    %edx,0x4(%eax)
  801ed0:	eb 0b                	jmp    801edd <free+0x7e>
  801ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed5:	8b 40 04             	mov    0x4(%eax),%eax
  801ed8:	a3 44 50 80 00       	mov    %eax,0x805044
  801edd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee0:	8b 40 04             	mov    0x4(%eax),%eax
  801ee3:	85 c0                	test   %eax,%eax
  801ee5:	74 0f                	je     801ef6 <free+0x97>
  801ee7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eea:	8b 40 04             	mov    0x4(%eax),%eax
  801eed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ef0:	8b 12                	mov    (%edx),%edx
  801ef2:	89 10                	mov    %edx,(%eax)
  801ef4:	eb 0a                	jmp    801f00 <free+0xa1>
  801ef6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef9:	8b 00                	mov    (%eax),%eax
  801efb:	a3 40 50 80 00       	mov    %eax,0x805040
  801f00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f03:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f0c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f13:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801f18:	48                   	dec    %eax
  801f19:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(free_block);
  801f1e:	83 ec 0c             	sub    $0xc,%esp
  801f21:	ff 75 f4             	pushl  -0xc(%ebp)
  801f24:	e8 4e 17 00 00       	call   803677 <insert_sorted_with_merge_freeList>
  801f29:	83 c4 10             	add    $0x10,%esp
	}

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801f2c:	90                   	nop
  801f2d:	c9                   	leave  
  801f2e:	c3                   	ret    

00801f2f <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801f2f:	55                   	push   %ebp
  801f30:	89 e5                	mov    %esp,%ebp
  801f32:	83 ec 38             	sub    $0x38,%esp
  801f35:	8b 45 10             	mov    0x10(%ebp),%eax
  801f38:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f3b:	e8 a6 fc ff ff       	call   801be6 <InitializeUHeap>
	if (size == 0) return NULL ;
  801f40:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f44:	75 0a                	jne    801f50 <smalloc+0x21>
  801f46:	b8 00 00 00 00       	mov    $0x0,%eax
  801f4b:	e9 8b 00 00 00       	jmp    801fdb <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801f50:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801f57:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f5d:	01 d0                	add    %edx,%eax
  801f5f:	48                   	dec    %eax
  801f60:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801f63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f66:	ba 00 00 00 00       	mov    $0x0,%edx
  801f6b:	f7 75 f0             	divl   -0x10(%ebp)
  801f6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f71:	29 d0                	sub    %edx,%eax
  801f73:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801f76:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801f7d:	e8 d0 06 00 00       	call   802652 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801f82:	85 c0                	test   %eax,%eax
  801f84:	74 11                	je     801f97 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801f86:	83 ec 0c             	sub    $0xc,%esp
  801f89:	ff 75 e8             	pushl  -0x18(%ebp)
  801f8c:	e8 3b 0d 00 00       	call   802ccc <alloc_block_FF>
  801f91:	83 c4 10             	add    $0x10,%esp
  801f94:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  801f97:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f9b:	74 39                	je     801fd6 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801f9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa0:	8b 40 08             	mov    0x8(%eax),%eax
  801fa3:	89 c2                	mov    %eax,%edx
  801fa5:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801fa9:	52                   	push   %edx
  801faa:	50                   	push   %eax
  801fab:	ff 75 0c             	pushl  0xc(%ebp)
  801fae:	ff 75 08             	pushl  0x8(%ebp)
  801fb1:	e8 21 04 00 00       	call   8023d7 <sys_createSharedObject>
  801fb6:	83 c4 10             	add    $0x10,%esp
  801fb9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801fbc:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801fc0:	74 14                	je     801fd6 <smalloc+0xa7>
  801fc2:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801fc6:	74 0e                	je     801fd6 <smalloc+0xa7>
  801fc8:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801fcc:	74 08                	je     801fd6 <smalloc+0xa7>
			return (void*) mem_block->sva;
  801fce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd1:	8b 40 08             	mov    0x8(%eax),%eax
  801fd4:	eb 05                	jmp    801fdb <smalloc+0xac>
	}
	return NULL;
  801fd6:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801fdb:	c9                   	leave  
  801fdc:	c3                   	ret    

00801fdd <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801fdd:	55                   	push   %ebp
  801fde:	89 e5                	mov    %esp,%ebp
  801fe0:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801fe3:	e8 fe fb ff ff       	call   801be6 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801fe8:	83 ec 08             	sub    $0x8,%esp
  801feb:	ff 75 0c             	pushl  0xc(%ebp)
  801fee:	ff 75 08             	pushl  0x8(%ebp)
  801ff1:	e8 0b 04 00 00       	call   802401 <sys_getSizeOfSharedObject>
  801ff6:	83 c4 10             	add    $0x10,%esp
  801ff9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  801ffc:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  802000:	74 76                	je     802078 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  802002:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802009:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80200c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80200f:	01 d0                	add    %edx,%eax
  802011:	48                   	dec    %eax
  802012:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802015:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802018:	ba 00 00 00 00       	mov    $0x0,%edx
  80201d:	f7 75 ec             	divl   -0x14(%ebp)
  802020:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802023:	29 d0                	sub    %edx,%eax
  802025:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  802028:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80202f:	e8 1e 06 00 00       	call   802652 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802034:	85 c0                	test   %eax,%eax
  802036:	74 11                	je     802049 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  802038:	83 ec 0c             	sub    $0xc,%esp
  80203b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80203e:	e8 89 0c 00 00       	call   802ccc <alloc_block_FF>
  802043:	83 c4 10             	add    $0x10,%esp
  802046:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  802049:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80204d:	74 29                	je     802078 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  80204f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802052:	8b 40 08             	mov    0x8(%eax),%eax
  802055:	83 ec 04             	sub    $0x4,%esp
  802058:	50                   	push   %eax
  802059:	ff 75 0c             	pushl  0xc(%ebp)
  80205c:	ff 75 08             	pushl  0x8(%ebp)
  80205f:	e8 ba 03 00 00       	call   80241e <sys_getSharedObject>
  802064:	83 c4 10             	add    $0x10,%esp
  802067:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  80206a:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  80206e:	74 08                	je     802078 <sget+0x9b>
				return (void *)mem_block->sva;
  802070:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802073:	8b 40 08             	mov    0x8(%eax),%eax
  802076:	eb 05                	jmp    80207d <sget+0xa0>
		}
	}
	return NULL;
  802078:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80207d:	c9                   	leave  
  80207e:	c3                   	ret    

0080207f <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80207f:	55                   	push   %ebp
  802080:	89 e5                	mov    %esp,%ebp
  802082:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802085:	e8 5c fb ff ff       	call   801be6 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80208a:	83 ec 04             	sub    $0x4,%esp
  80208d:	68 98 48 80 00       	push   $0x804898
  802092:	68 f7 00 00 00       	push   $0xf7
  802097:	68 67 48 80 00       	push   $0x804867
  80209c:	e8 01 e9 ff ff       	call   8009a2 <_panic>

008020a1 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8020a1:	55                   	push   %ebp
  8020a2:	89 e5                	mov    %esp,%ebp
  8020a4:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8020a7:	83 ec 04             	sub    $0x4,%esp
  8020aa:	68 c0 48 80 00       	push   $0x8048c0
  8020af:	68 0b 01 00 00       	push   $0x10b
  8020b4:	68 67 48 80 00       	push   $0x804867
  8020b9:	e8 e4 e8 ff ff       	call   8009a2 <_panic>

008020be <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8020be:	55                   	push   %ebp
  8020bf:	89 e5                	mov    %esp,%ebp
  8020c1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020c4:	83 ec 04             	sub    $0x4,%esp
  8020c7:	68 e4 48 80 00       	push   $0x8048e4
  8020cc:	68 16 01 00 00       	push   $0x116
  8020d1:	68 67 48 80 00       	push   $0x804867
  8020d6:	e8 c7 e8 ff ff       	call   8009a2 <_panic>

008020db <shrink>:

}
void shrink(uint32 newSize)
{
  8020db:	55                   	push   %ebp
  8020dc:	89 e5                	mov    %esp,%ebp
  8020de:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020e1:	83 ec 04             	sub    $0x4,%esp
  8020e4:	68 e4 48 80 00       	push   $0x8048e4
  8020e9:	68 1b 01 00 00       	push   $0x11b
  8020ee:	68 67 48 80 00       	push   $0x804867
  8020f3:	e8 aa e8 ff ff       	call   8009a2 <_panic>

008020f8 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8020f8:	55                   	push   %ebp
  8020f9:	89 e5                	mov    %esp,%ebp
  8020fb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020fe:	83 ec 04             	sub    $0x4,%esp
  802101:	68 e4 48 80 00       	push   $0x8048e4
  802106:	68 20 01 00 00       	push   $0x120
  80210b:	68 67 48 80 00       	push   $0x804867
  802110:	e8 8d e8 ff ff       	call   8009a2 <_panic>

00802115 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802115:	55                   	push   %ebp
  802116:	89 e5                	mov    %esp,%ebp
  802118:	57                   	push   %edi
  802119:	56                   	push   %esi
  80211a:	53                   	push   %ebx
  80211b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80211e:	8b 45 08             	mov    0x8(%ebp),%eax
  802121:	8b 55 0c             	mov    0xc(%ebp),%edx
  802124:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802127:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80212a:	8b 7d 18             	mov    0x18(%ebp),%edi
  80212d:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802130:	cd 30                	int    $0x30
  802132:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802135:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802138:	83 c4 10             	add    $0x10,%esp
  80213b:	5b                   	pop    %ebx
  80213c:	5e                   	pop    %esi
  80213d:	5f                   	pop    %edi
  80213e:	5d                   	pop    %ebp
  80213f:	c3                   	ret    

00802140 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802140:	55                   	push   %ebp
  802141:	89 e5                	mov    %esp,%ebp
  802143:	83 ec 04             	sub    $0x4,%esp
  802146:	8b 45 10             	mov    0x10(%ebp),%eax
  802149:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80214c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802150:	8b 45 08             	mov    0x8(%ebp),%eax
  802153:	6a 00                	push   $0x0
  802155:	6a 00                	push   $0x0
  802157:	52                   	push   %edx
  802158:	ff 75 0c             	pushl  0xc(%ebp)
  80215b:	50                   	push   %eax
  80215c:	6a 00                	push   $0x0
  80215e:	e8 b2 ff ff ff       	call   802115 <syscall>
  802163:	83 c4 18             	add    $0x18,%esp
}
  802166:	90                   	nop
  802167:	c9                   	leave  
  802168:	c3                   	ret    

00802169 <sys_cgetc>:

int
sys_cgetc(void)
{
  802169:	55                   	push   %ebp
  80216a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80216c:	6a 00                	push   $0x0
  80216e:	6a 00                	push   $0x0
  802170:	6a 00                	push   $0x0
  802172:	6a 00                	push   $0x0
  802174:	6a 00                	push   $0x0
  802176:	6a 01                	push   $0x1
  802178:	e8 98 ff ff ff       	call   802115 <syscall>
  80217d:	83 c4 18             	add    $0x18,%esp
}
  802180:	c9                   	leave  
  802181:	c3                   	ret    

00802182 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802182:	55                   	push   %ebp
  802183:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802185:	8b 55 0c             	mov    0xc(%ebp),%edx
  802188:	8b 45 08             	mov    0x8(%ebp),%eax
  80218b:	6a 00                	push   $0x0
  80218d:	6a 00                	push   $0x0
  80218f:	6a 00                	push   $0x0
  802191:	52                   	push   %edx
  802192:	50                   	push   %eax
  802193:	6a 05                	push   $0x5
  802195:	e8 7b ff ff ff       	call   802115 <syscall>
  80219a:	83 c4 18             	add    $0x18,%esp
}
  80219d:	c9                   	leave  
  80219e:	c3                   	ret    

0080219f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80219f:	55                   	push   %ebp
  8021a0:	89 e5                	mov    %esp,%ebp
  8021a2:	56                   	push   %esi
  8021a3:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8021a4:	8b 75 18             	mov    0x18(%ebp),%esi
  8021a7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021aa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b3:	56                   	push   %esi
  8021b4:	53                   	push   %ebx
  8021b5:	51                   	push   %ecx
  8021b6:	52                   	push   %edx
  8021b7:	50                   	push   %eax
  8021b8:	6a 06                	push   $0x6
  8021ba:	e8 56 ff ff ff       	call   802115 <syscall>
  8021bf:	83 c4 18             	add    $0x18,%esp
}
  8021c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021c5:	5b                   	pop    %ebx
  8021c6:	5e                   	pop    %esi
  8021c7:	5d                   	pop    %ebp
  8021c8:	c3                   	ret    

008021c9 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8021c9:	55                   	push   %ebp
  8021ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8021cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d2:	6a 00                	push   $0x0
  8021d4:	6a 00                	push   $0x0
  8021d6:	6a 00                	push   $0x0
  8021d8:	52                   	push   %edx
  8021d9:	50                   	push   %eax
  8021da:	6a 07                	push   $0x7
  8021dc:	e8 34 ff ff ff       	call   802115 <syscall>
  8021e1:	83 c4 18             	add    $0x18,%esp
}
  8021e4:	c9                   	leave  
  8021e5:	c3                   	ret    

008021e6 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8021e6:	55                   	push   %ebp
  8021e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8021e9:	6a 00                	push   $0x0
  8021eb:	6a 00                	push   $0x0
  8021ed:	6a 00                	push   $0x0
  8021ef:	ff 75 0c             	pushl  0xc(%ebp)
  8021f2:	ff 75 08             	pushl  0x8(%ebp)
  8021f5:	6a 08                	push   $0x8
  8021f7:	e8 19 ff ff ff       	call   802115 <syscall>
  8021fc:	83 c4 18             	add    $0x18,%esp
}
  8021ff:	c9                   	leave  
  802200:	c3                   	ret    

00802201 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802201:	55                   	push   %ebp
  802202:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802204:	6a 00                	push   $0x0
  802206:	6a 00                	push   $0x0
  802208:	6a 00                	push   $0x0
  80220a:	6a 00                	push   $0x0
  80220c:	6a 00                	push   $0x0
  80220e:	6a 09                	push   $0x9
  802210:	e8 00 ff ff ff       	call   802115 <syscall>
  802215:	83 c4 18             	add    $0x18,%esp
}
  802218:	c9                   	leave  
  802219:	c3                   	ret    

0080221a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80221a:	55                   	push   %ebp
  80221b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80221d:	6a 00                	push   $0x0
  80221f:	6a 00                	push   $0x0
  802221:	6a 00                	push   $0x0
  802223:	6a 00                	push   $0x0
  802225:	6a 00                	push   $0x0
  802227:	6a 0a                	push   $0xa
  802229:	e8 e7 fe ff ff       	call   802115 <syscall>
  80222e:	83 c4 18             	add    $0x18,%esp
}
  802231:	c9                   	leave  
  802232:	c3                   	ret    

00802233 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802233:	55                   	push   %ebp
  802234:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802236:	6a 00                	push   $0x0
  802238:	6a 00                	push   $0x0
  80223a:	6a 00                	push   $0x0
  80223c:	6a 00                	push   $0x0
  80223e:	6a 00                	push   $0x0
  802240:	6a 0b                	push   $0xb
  802242:	e8 ce fe ff ff       	call   802115 <syscall>
  802247:	83 c4 18             	add    $0x18,%esp
}
  80224a:	c9                   	leave  
  80224b:	c3                   	ret    

0080224c <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80224c:	55                   	push   %ebp
  80224d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80224f:	6a 00                	push   $0x0
  802251:	6a 00                	push   $0x0
  802253:	6a 00                	push   $0x0
  802255:	ff 75 0c             	pushl  0xc(%ebp)
  802258:	ff 75 08             	pushl  0x8(%ebp)
  80225b:	6a 0f                	push   $0xf
  80225d:	e8 b3 fe ff ff       	call   802115 <syscall>
  802262:	83 c4 18             	add    $0x18,%esp
	return;
  802265:	90                   	nop
}
  802266:	c9                   	leave  
  802267:	c3                   	ret    

00802268 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802268:	55                   	push   %ebp
  802269:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80226b:	6a 00                	push   $0x0
  80226d:	6a 00                	push   $0x0
  80226f:	6a 00                	push   $0x0
  802271:	ff 75 0c             	pushl  0xc(%ebp)
  802274:	ff 75 08             	pushl  0x8(%ebp)
  802277:	6a 10                	push   $0x10
  802279:	e8 97 fe ff ff       	call   802115 <syscall>
  80227e:	83 c4 18             	add    $0x18,%esp
	return ;
  802281:	90                   	nop
}
  802282:	c9                   	leave  
  802283:	c3                   	ret    

00802284 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802284:	55                   	push   %ebp
  802285:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802287:	6a 00                	push   $0x0
  802289:	6a 00                	push   $0x0
  80228b:	ff 75 10             	pushl  0x10(%ebp)
  80228e:	ff 75 0c             	pushl  0xc(%ebp)
  802291:	ff 75 08             	pushl  0x8(%ebp)
  802294:	6a 11                	push   $0x11
  802296:	e8 7a fe ff ff       	call   802115 <syscall>
  80229b:	83 c4 18             	add    $0x18,%esp
	return ;
  80229e:	90                   	nop
}
  80229f:	c9                   	leave  
  8022a0:	c3                   	ret    

008022a1 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8022a1:	55                   	push   %ebp
  8022a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8022a4:	6a 00                	push   $0x0
  8022a6:	6a 00                	push   $0x0
  8022a8:	6a 00                	push   $0x0
  8022aa:	6a 00                	push   $0x0
  8022ac:	6a 00                	push   $0x0
  8022ae:	6a 0c                	push   $0xc
  8022b0:	e8 60 fe ff ff       	call   802115 <syscall>
  8022b5:	83 c4 18             	add    $0x18,%esp
}
  8022b8:	c9                   	leave  
  8022b9:	c3                   	ret    

008022ba <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8022ba:	55                   	push   %ebp
  8022bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8022bd:	6a 00                	push   $0x0
  8022bf:	6a 00                	push   $0x0
  8022c1:	6a 00                	push   $0x0
  8022c3:	6a 00                	push   $0x0
  8022c5:	ff 75 08             	pushl  0x8(%ebp)
  8022c8:	6a 0d                	push   $0xd
  8022ca:	e8 46 fe ff ff       	call   802115 <syscall>
  8022cf:	83 c4 18             	add    $0x18,%esp
}
  8022d2:	c9                   	leave  
  8022d3:	c3                   	ret    

008022d4 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8022d4:	55                   	push   %ebp
  8022d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8022d7:	6a 00                	push   $0x0
  8022d9:	6a 00                	push   $0x0
  8022db:	6a 00                	push   $0x0
  8022dd:	6a 00                	push   $0x0
  8022df:	6a 00                	push   $0x0
  8022e1:	6a 0e                	push   $0xe
  8022e3:	e8 2d fe ff ff       	call   802115 <syscall>
  8022e8:	83 c4 18             	add    $0x18,%esp
}
  8022eb:	90                   	nop
  8022ec:	c9                   	leave  
  8022ed:	c3                   	ret    

008022ee <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8022ee:	55                   	push   %ebp
  8022ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8022f1:	6a 00                	push   $0x0
  8022f3:	6a 00                	push   $0x0
  8022f5:	6a 00                	push   $0x0
  8022f7:	6a 00                	push   $0x0
  8022f9:	6a 00                	push   $0x0
  8022fb:	6a 13                	push   $0x13
  8022fd:	e8 13 fe ff ff       	call   802115 <syscall>
  802302:	83 c4 18             	add    $0x18,%esp
}
  802305:	90                   	nop
  802306:	c9                   	leave  
  802307:	c3                   	ret    

00802308 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802308:	55                   	push   %ebp
  802309:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80230b:	6a 00                	push   $0x0
  80230d:	6a 00                	push   $0x0
  80230f:	6a 00                	push   $0x0
  802311:	6a 00                	push   $0x0
  802313:	6a 00                	push   $0x0
  802315:	6a 14                	push   $0x14
  802317:	e8 f9 fd ff ff       	call   802115 <syscall>
  80231c:	83 c4 18             	add    $0x18,%esp
}
  80231f:	90                   	nop
  802320:	c9                   	leave  
  802321:	c3                   	ret    

00802322 <sys_cputc>:


void
sys_cputc(const char c)
{
  802322:	55                   	push   %ebp
  802323:	89 e5                	mov    %esp,%ebp
  802325:	83 ec 04             	sub    $0x4,%esp
  802328:	8b 45 08             	mov    0x8(%ebp),%eax
  80232b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80232e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802332:	6a 00                	push   $0x0
  802334:	6a 00                	push   $0x0
  802336:	6a 00                	push   $0x0
  802338:	6a 00                	push   $0x0
  80233a:	50                   	push   %eax
  80233b:	6a 15                	push   $0x15
  80233d:	e8 d3 fd ff ff       	call   802115 <syscall>
  802342:	83 c4 18             	add    $0x18,%esp
}
  802345:	90                   	nop
  802346:	c9                   	leave  
  802347:	c3                   	ret    

00802348 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802348:	55                   	push   %ebp
  802349:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80234b:	6a 00                	push   $0x0
  80234d:	6a 00                	push   $0x0
  80234f:	6a 00                	push   $0x0
  802351:	6a 00                	push   $0x0
  802353:	6a 00                	push   $0x0
  802355:	6a 16                	push   $0x16
  802357:	e8 b9 fd ff ff       	call   802115 <syscall>
  80235c:	83 c4 18             	add    $0x18,%esp
}
  80235f:	90                   	nop
  802360:	c9                   	leave  
  802361:	c3                   	ret    

00802362 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802362:	55                   	push   %ebp
  802363:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802365:	8b 45 08             	mov    0x8(%ebp),%eax
  802368:	6a 00                	push   $0x0
  80236a:	6a 00                	push   $0x0
  80236c:	6a 00                	push   $0x0
  80236e:	ff 75 0c             	pushl  0xc(%ebp)
  802371:	50                   	push   %eax
  802372:	6a 17                	push   $0x17
  802374:	e8 9c fd ff ff       	call   802115 <syscall>
  802379:	83 c4 18             	add    $0x18,%esp
}
  80237c:	c9                   	leave  
  80237d:	c3                   	ret    

0080237e <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80237e:	55                   	push   %ebp
  80237f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802381:	8b 55 0c             	mov    0xc(%ebp),%edx
  802384:	8b 45 08             	mov    0x8(%ebp),%eax
  802387:	6a 00                	push   $0x0
  802389:	6a 00                	push   $0x0
  80238b:	6a 00                	push   $0x0
  80238d:	52                   	push   %edx
  80238e:	50                   	push   %eax
  80238f:	6a 1a                	push   $0x1a
  802391:	e8 7f fd ff ff       	call   802115 <syscall>
  802396:	83 c4 18             	add    $0x18,%esp
}
  802399:	c9                   	leave  
  80239a:	c3                   	ret    

0080239b <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80239b:	55                   	push   %ebp
  80239c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80239e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a4:	6a 00                	push   $0x0
  8023a6:	6a 00                	push   $0x0
  8023a8:	6a 00                	push   $0x0
  8023aa:	52                   	push   %edx
  8023ab:	50                   	push   %eax
  8023ac:	6a 18                	push   $0x18
  8023ae:	e8 62 fd ff ff       	call   802115 <syscall>
  8023b3:	83 c4 18             	add    $0x18,%esp
}
  8023b6:	90                   	nop
  8023b7:	c9                   	leave  
  8023b8:	c3                   	ret    

008023b9 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8023b9:	55                   	push   %ebp
  8023ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8023bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c2:	6a 00                	push   $0x0
  8023c4:	6a 00                	push   $0x0
  8023c6:	6a 00                	push   $0x0
  8023c8:	52                   	push   %edx
  8023c9:	50                   	push   %eax
  8023ca:	6a 19                	push   $0x19
  8023cc:	e8 44 fd ff ff       	call   802115 <syscall>
  8023d1:	83 c4 18             	add    $0x18,%esp
}
  8023d4:	90                   	nop
  8023d5:	c9                   	leave  
  8023d6:	c3                   	ret    

008023d7 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8023d7:	55                   	push   %ebp
  8023d8:	89 e5                	mov    %esp,%ebp
  8023da:	83 ec 04             	sub    $0x4,%esp
  8023dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8023e0:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8023e3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8023e6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8023ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ed:	6a 00                	push   $0x0
  8023ef:	51                   	push   %ecx
  8023f0:	52                   	push   %edx
  8023f1:	ff 75 0c             	pushl  0xc(%ebp)
  8023f4:	50                   	push   %eax
  8023f5:	6a 1b                	push   $0x1b
  8023f7:	e8 19 fd ff ff       	call   802115 <syscall>
  8023fc:	83 c4 18             	add    $0x18,%esp
}
  8023ff:	c9                   	leave  
  802400:	c3                   	ret    

00802401 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802401:	55                   	push   %ebp
  802402:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802404:	8b 55 0c             	mov    0xc(%ebp),%edx
  802407:	8b 45 08             	mov    0x8(%ebp),%eax
  80240a:	6a 00                	push   $0x0
  80240c:	6a 00                	push   $0x0
  80240e:	6a 00                	push   $0x0
  802410:	52                   	push   %edx
  802411:	50                   	push   %eax
  802412:	6a 1c                	push   $0x1c
  802414:	e8 fc fc ff ff       	call   802115 <syscall>
  802419:	83 c4 18             	add    $0x18,%esp
}
  80241c:	c9                   	leave  
  80241d:	c3                   	ret    

0080241e <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80241e:	55                   	push   %ebp
  80241f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802421:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802424:	8b 55 0c             	mov    0xc(%ebp),%edx
  802427:	8b 45 08             	mov    0x8(%ebp),%eax
  80242a:	6a 00                	push   $0x0
  80242c:	6a 00                	push   $0x0
  80242e:	51                   	push   %ecx
  80242f:	52                   	push   %edx
  802430:	50                   	push   %eax
  802431:	6a 1d                	push   $0x1d
  802433:	e8 dd fc ff ff       	call   802115 <syscall>
  802438:	83 c4 18             	add    $0x18,%esp
}
  80243b:	c9                   	leave  
  80243c:	c3                   	ret    

0080243d <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80243d:	55                   	push   %ebp
  80243e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802440:	8b 55 0c             	mov    0xc(%ebp),%edx
  802443:	8b 45 08             	mov    0x8(%ebp),%eax
  802446:	6a 00                	push   $0x0
  802448:	6a 00                	push   $0x0
  80244a:	6a 00                	push   $0x0
  80244c:	52                   	push   %edx
  80244d:	50                   	push   %eax
  80244e:	6a 1e                	push   $0x1e
  802450:	e8 c0 fc ff ff       	call   802115 <syscall>
  802455:	83 c4 18             	add    $0x18,%esp
}
  802458:	c9                   	leave  
  802459:	c3                   	ret    

0080245a <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80245a:	55                   	push   %ebp
  80245b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80245d:	6a 00                	push   $0x0
  80245f:	6a 00                	push   $0x0
  802461:	6a 00                	push   $0x0
  802463:	6a 00                	push   $0x0
  802465:	6a 00                	push   $0x0
  802467:	6a 1f                	push   $0x1f
  802469:	e8 a7 fc ff ff       	call   802115 <syscall>
  80246e:	83 c4 18             	add    $0x18,%esp
}
  802471:	c9                   	leave  
  802472:	c3                   	ret    

00802473 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802473:	55                   	push   %ebp
  802474:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802476:	8b 45 08             	mov    0x8(%ebp),%eax
  802479:	6a 00                	push   $0x0
  80247b:	ff 75 14             	pushl  0x14(%ebp)
  80247e:	ff 75 10             	pushl  0x10(%ebp)
  802481:	ff 75 0c             	pushl  0xc(%ebp)
  802484:	50                   	push   %eax
  802485:	6a 20                	push   $0x20
  802487:	e8 89 fc ff ff       	call   802115 <syscall>
  80248c:	83 c4 18             	add    $0x18,%esp
}
  80248f:	c9                   	leave  
  802490:	c3                   	ret    

00802491 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802491:	55                   	push   %ebp
  802492:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802494:	8b 45 08             	mov    0x8(%ebp),%eax
  802497:	6a 00                	push   $0x0
  802499:	6a 00                	push   $0x0
  80249b:	6a 00                	push   $0x0
  80249d:	6a 00                	push   $0x0
  80249f:	50                   	push   %eax
  8024a0:	6a 21                	push   $0x21
  8024a2:	e8 6e fc ff ff       	call   802115 <syscall>
  8024a7:	83 c4 18             	add    $0x18,%esp
}
  8024aa:	90                   	nop
  8024ab:	c9                   	leave  
  8024ac:	c3                   	ret    

008024ad <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8024ad:	55                   	push   %ebp
  8024ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8024b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b3:	6a 00                	push   $0x0
  8024b5:	6a 00                	push   $0x0
  8024b7:	6a 00                	push   $0x0
  8024b9:	6a 00                	push   $0x0
  8024bb:	50                   	push   %eax
  8024bc:	6a 22                	push   $0x22
  8024be:	e8 52 fc ff ff       	call   802115 <syscall>
  8024c3:	83 c4 18             	add    $0x18,%esp
}
  8024c6:	c9                   	leave  
  8024c7:	c3                   	ret    

008024c8 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8024c8:	55                   	push   %ebp
  8024c9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8024cb:	6a 00                	push   $0x0
  8024cd:	6a 00                	push   $0x0
  8024cf:	6a 00                	push   $0x0
  8024d1:	6a 00                	push   $0x0
  8024d3:	6a 00                	push   $0x0
  8024d5:	6a 02                	push   $0x2
  8024d7:	e8 39 fc ff ff       	call   802115 <syscall>
  8024dc:	83 c4 18             	add    $0x18,%esp
}
  8024df:	c9                   	leave  
  8024e0:	c3                   	ret    

008024e1 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8024e1:	55                   	push   %ebp
  8024e2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8024e4:	6a 00                	push   $0x0
  8024e6:	6a 00                	push   $0x0
  8024e8:	6a 00                	push   $0x0
  8024ea:	6a 00                	push   $0x0
  8024ec:	6a 00                	push   $0x0
  8024ee:	6a 03                	push   $0x3
  8024f0:	e8 20 fc ff ff       	call   802115 <syscall>
  8024f5:	83 c4 18             	add    $0x18,%esp
}
  8024f8:	c9                   	leave  
  8024f9:	c3                   	ret    

008024fa <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8024fa:	55                   	push   %ebp
  8024fb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8024fd:	6a 00                	push   $0x0
  8024ff:	6a 00                	push   $0x0
  802501:	6a 00                	push   $0x0
  802503:	6a 00                	push   $0x0
  802505:	6a 00                	push   $0x0
  802507:	6a 04                	push   $0x4
  802509:	e8 07 fc ff ff       	call   802115 <syscall>
  80250e:	83 c4 18             	add    $0x18,%esp
}
  802511:	c9                   	leave  
  802512:	c3                   	ret    

00802513 <sys_exit_env>:


void sys_exit_env(void)
{
  802513:	55                   	push   %ebp
  802514:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802516:	6a 00                	push   $0x0
  802518:	6a 00                	push   $0x0
  80251a:	6a 00                	push   $0x0
  80251c:	6a 00                	push   $0x0
  80251e:	6a 00                	push   $0x0
  802520:	6a 23                	push   $0x23
  802522:	e8 ee fb ff ff       	call   802115 <syscall>
  802527:	83 c4 18             	add    $0x18,%esp
}
  80252a:	90                   	nop
  80252b:	c9                   	leave  
  80252c:	c3                   	ret    

0080252d <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80252d:	55                   	push   %ebp
  80252e:	89 e5                	mov    %esp,%ebp
  802530:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802533:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802536:	8d 50 04             	lea    0x4(%eax),%edx
  802539:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80253c:	6a 00                	push   $0x0
  80253e:	6a 00                	push   $0x0
  802540:	6a 00                	push   $0x0
  802542:	52                   	push   %edx
  802543:	50                   	push   %eax
  802544:	6a 24                	push   $0x24
  802546:	e8 ca fb ff ff       	call   802115 <syscall>
  80254b:	83 c4 18             	add    $0x18,%esp
	return result;
  80254e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802551:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802554:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802557:	89 01                	mov    %eax,(%ecx)
  802559:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80255c:	8b 45 08             	mov    0x8(%ebp),%eax
  80255f:	c9                   	leave  
  802560:	c2 04 00             	ret    $0x4

00802563 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802563:	55                   	push   %ebp
  802564:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802566:	6a 00                	push   $0x0
  802568:	6a 00                	push   $0x0
  80256a:	ff 75 10             	pushl  0x10(%ebp)
  80256d:	ff 75 0c             	pushl  0xc(%ebp)
  802570:	ff 75 08             	pushl  0x8(%ebp)
  802573:	6a 12                	push   $0x12
  802575:	e8 9b fb ff ff       	call   802115 <syscall>
  80257a:	83 c4 18             	add    $0x18,%esp
	return ;
  80257d:	90                   	nop
}
  80257e:	c9                   	leave  
  80257f:	c3                   	ret    

00802580 <sys_rcr2>:
uint32 sys_rcr2()
{
  802580:	55                   	push   %ebp
  802581:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802583:	6a 00                	push   $0x0
  802585:	6a 00                	push   $0x0
  802587:	6a 00                	push   $0x0
  802589:	6a 00                	push   $0x0
  80258b:	6a 00                	push   $0x0
  80258d:	6a 25                	push   $0x25
  80258f:	e8 81 fb ff ff       	call   802115 <syscall>
  802594:	83 c4 18             	add    $0x18,%esp
}
  802597:	c9                   	leave  
  802598:	c3                   	ret    

00802599 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802599:	55                   	push   %ebp
  80259a:	89 e5                	mov    %esp,%ebp
  80259c:	83 ec 04             	sub    $0x4,%esp
  80259f:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8025a5:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8025a9:	6a 00                	push   $0x0
  8025ab:	6a 00                	push   $0x0
  8025ad:	6a 00                	push   $0x0
  8025af:	6a 00                	push   $0x0
  8025b1:	50                   	push   %eax
  8025b2:	6a 26                	push   $0x26
  8025b4:	e8 5c fb ff ff       	call   802115 <syscall>
  8025b9:	83 c4 18             	add    $0x18,%esp
	return ;
  8025bc:	90                   	nop
}
  8025bd:	c9                   	leave  
  8025be:	c3                   	ret    

008025bf <rsttst>:
void rsttst()
{
  8025bf:	55                   	push   %ebp
  8025c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8025c2:	6a 00                	push   $0x0
  8025c4:	6a 00                	push   $0x0
  8025c6:	6a 00                	push   $0x0
  8025c8:	6a 00                	push   $0x0
  8025ca:	6a 00                	push   $0x0
  8025cc:	6a 28                	push   $0x28
  8025ce:	e8 42 fb ff ff       	call   802115 <syscall>
  8025d3:	83 c4 18             	add    $0x18,%esp
	return ;
  8025d6:	90                   	nop
}
  8025d7:	c9                   	leave  
  8025d8:	c3                   	ret    

008025d9 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8025d9:	55                   	push   %ebp
  8025da:	89 e5                	mov    %esp,%ebp
  8025dc:	83 ec 04             	sub    $0x4,%esp
  8025df:	8b 45 14             	mov    0x14(%ebp),%eax
  8025e2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8025e5:	8b 55 18             	mov    0x18(%ebp),%edx
  8025e8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8025ec:	52                   	push   %edx
  8025ed:	50                   	push   %eax
  8025ee:	ff 75 10             	pushl  0x10(%ebp)
  8025f1:	ff 75 0c             	pushl  0xc(%ebp)
  8025f4:	ff 75 08             	pushl  0x8(%ebp)
  8025f7:	6a 27                	push   $0x27
  8025f9:	e8 17 fb ff ff       	call   802115 <syscall>
  8025fe:	83 c4 18             	add    $0x18,%esp
	return ;
  802601:	90                   	nop
}
  802602:	c9                   	leave  
  802603:	c3                   	ret    

00802604 <chktst>:
void chktst(uint32 n)
{
  802604:	55                   	push   %ebp
  802605:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802607:	6a 00                	push   $0x0
  802609:	6a 00                	push   $0x0
  80260b:	6a 00                	push   $0x0
  80260d:	6a 00                	push   $0x0
  80260f:	ff 75 08             	pushl  0x8(%ebp)
  802612:	6a 29                	push   $0x29
  802614:	e8 fc fa ff ff       	call   802115 <syscall>
  802619:	83 c4 18             	add    $0x18,%esp
	return ;
  80261c:	90                   	nop
}
  80261d:	c9                   	leave  
  80261e:	c3                   	ret    

0080261f <inctst>:

void inctst()
{
  80261f:	55                   	push   %ebp
  802620:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802622:	6a 00                	push   $0x0
  802624:	6a 00                	push   $0x0
  802626:	6a 00                	push   $0x0
  802628:	6a 00                	push   $0x0
  80262a:	6a 00                	push   $0x0
  80262c:	6a 2a                	push   $0x2a
  80262e:	e8 e2 fa ff ff       	call   802115 <syscall>
  802633:	83 c4 18             	add    $0x18,%esp
	return ;
  802636:	90                   	nop
}
  802637:	c9                   	leave  
  802638:	c3                   	ret    

00802639 <gettst>:
uint32 gettst()
{
  802639:	55                   	push   %ebp
  80263a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80263c:	6a 00                	push   $0x0
  80263e:	6a 00                	push   $0x0
  802640:	6a 00                	push   $0x0
  802642:	6a 00                	push   $0x0
  802644:	6a 00                	push   $0x0
  802646:	6a 2b                	push   $0x2b
  802648:	e8 c8 fa ff ff       	call   802115 <syscall>
  80264d:	83 c4 18             	add    $0x18,%esp
}
  802650:	c9                   	leave  
  802651:	c3                   	ret    

00802652 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802652:	55                   	push   %ebp
  802653:	89 e5                	mov    %esp,%ebp
  802655:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802658:	6a 00                	push   $0x0
  80265a:	6a 00                	push   $0x0
  80265c:	6a 00                	push   $0x0
  80265e:	6a 00                	push   $0x0
  802660:	6a 00                	push   $0x0
  802662:	6a 2c                	push   $0x2c
  802664:	e8 ac fa ff ff       	call   802115 <syscall>
  802669:	83 c4 18             	add    $0x18,%esp
  80266c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80266f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802673:	75 07                	jne    80267c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802675:	b8 01 00 00 00       	mov    $0x1,%eax
  80267a:	eb 05                	jmp    802681 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80267c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802681:	c9                   	leave  
  802682:	c3                   	ret    

00802683 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802683:	55                   	push   %ebp
  802684:	89 e5                	mov    %esp,%ebp
  802686:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802689:	6a 00                	push   $0x0
  80268b:	6a 00                	push   $0x0
  80268d:	6a 00                	push   $0x0
  80268f:	6a 00                	push   $0x0
  802691:	6a 00                	push   $0x0
  802693:	6a 2c                	push   $0x2c
  802695:	e8 7b fa ff ff       	call   802115 <syscall>
  80269a:	83 c4 18             	add    $0x18,%esp
  80269d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8026a0:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8026a4:	75 07                	jne    8026ad <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8026a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8026ab:	eb 05                	jmp    8026b2 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8026ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026b2:	c9                   	leave  
  8026b3:	c3                   	ret    

008026b4 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8026b4:	55                   	push   %ebp
  8026b5:	89 e5                	mov    %esp,%ebp
  8026b7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8026ba:	6a 00                	push   $0x0
  8026bc:	6a 00                	push   $0x0
  8026be:	6a 00                	push   $0x0
  8026c0:	6a 00                	push   $0x0
  8026c2:	6a 00                	push   $0x0
  8026c4:	6a 2c                	push   $0x2c
  8026c6:	e8 4a fa ff ff       	call   802115 <syscall>
  8026cb:	83 c4 18             	add    $0x18,%esp
  8026ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8026d1:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8026d5:	75 07                	jne    8026de <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8026d7:	b8 01 00 00 00       	mov    $0x1,%eax
  8026dc:	eb 05                	jmp    8026e3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8026de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026e3:	c9                   	leave  
  8026e4:	c3                   	ret    

008026e5 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8026e5:	55                   	push   %ebp
  8026e6:	89 e5                	mov    %esp,%ebp
  8026e8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8026eb:	6a 00                	push   $0x0
  8026ed:	6a 00                	push   $0x0
  8026ef:	6a 00                	push   $0x0
  8026f1:	6a 00                	push   $0x0
  8026f3:	6a 00                	push   $0x0
  8026f5:	6a 2c                	push   $0x2c
  8026f7:	e8 19 fa ff ff       	call   802115 <syscall>
  8026fc:	83 c4 18             	add    $0x18,%esp
  8026ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802702:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802706:	75 07                	jne    80270f <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802708:	b8 01 00 00 00       	mov    $0x1,%eax
  80270d:	eb 05                	jmp    802714 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80270f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802714:	c9                   	leave  
  802715:	c3                   	ret    

00802716 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802716:	55                   	push   %ebp
  802717:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802719:	6a 00                	push   $0x0
  80271b:	6a 00                	push   $0x0
  80271d:	6a 00                	push   $0x0
  80271f:	6a 00                	push   $0x0
  802721:	ff 75 08             	pushl  0x8(%ebp)
  802724:	6a 2d                	push   $0x2d
  802726:	e8 ea f9 ff ff       	call   802115 <syscall>
  80272b:	83 c4 18             	add    $0x18,%esp
	return ;
  80272e:	90                   	nop
}
  80272f:	c9                   	leave  
  802730:	c3                   	ret    

00802731 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802731:	55                   	push   %ebp
  802732:	89 e5                	mov    %esp,%ebp
  802734:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802735:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802738:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80273b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80273e:	8b 45 08             	mov    0x8(%ebp),%eax
  802741:	6a 00                	push   $0x0
  802743:	53                   	push   %ebx
  802744:	51                   	push   %ecx
  802745:	52                   	push   %edx
  802746:	50                   	push   %eax
  802747:	6a 2e                	push   $0x2e
  802749:	e8 c7 f9 ff ff       	call   802115 <syscall>
  80274e:	83 c4 18             	add    $0x18,%esp
}
  802751:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802754:	c9                   	leave  
  802755:	c3                   	ret    

00802756 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802756:	55                   	push   %ebp
  802757:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802759:	8b 55 0c             	mov    0xc(%ebp),%edx
  80275c:	8b 45 08             	mov    0x8(%ebp),%eax
  80275f:	6a 00                	push   $0x0
  802761:	6a 00                	push   $0x0
  802763:	6a 00                	push   $0x0
  802765:	52                   	push   %edx
  802766:	50                   	push   %eax
  802767:	6a 2f                	push   $0x2f
  802769:	e8 a7 f9 ff ff       	call   802115 <syscall>
  80276e:	83 c4 18             	add    $0x18,%esp
}
  802771:	c9                   	leave  
  802772:	c3                   	ret    

00802773 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802773:	55                   	push   %ebp
  802774:	89 e5                	mov    %esp,%ebp
  802776:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802779:	83 ec 0c             	sub    $0xc,%esp
  80277c:	68 f4 48 80 00       	push   $0x8048f4
  802781:	e8 d0 e4 ff ff       	call   800c56 <cprintf>
  802786:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802789:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802790:	83 ec 0c             	sub    $0xc,%esp
  802793:	68 20 49 80 00       	push   $0x804920
  802798:	e8 b9 e4 ff ff       	call   800c56 <cprintf>
  80279d:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8027a0:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8027a4:	a1 38 51 80 00       	mov    0x805138,%eax
  8027a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027ac:	eb 56                	jmp    802804 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8027ae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027b2:	74 1c                	je     8027d0 <print_mem_block_lists+0x5d>
  8027b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b7:	8b 50 08             	mov    0x8(%eax),%edx
  8027ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027bd:	8b 48 08             	mov    0x8(%eax),%ecx
  8027c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8027c6:	01 c8                	add    %ecx,%eax
  8027c8:	39 c2                	cmp    %eax,%edx
  8027ca:	73 04                	jae    8027d0 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8027cc:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8027d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d3:	8b 50 08             	mov    0x8(%eax),%edx
  8027d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8027dc:	01 c2                	add    %eax,%edx
  8027de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e1:	8b 40 08             	mov    0x8(%eax),%eax
  8027e4:	83 ec 04             	sub    $0x4,%esp
  8027e7:	52                   	push   %edx
  8027e8:	50                   	push   %eax
  8027e9:	68 35 49 80 00       	push   $0x804935
  8027ee:	e8 63 e4 ff ff       	call   800c56 <cprintf>
  8027f3:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8027f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8027fc:	a1 40 51 80 00       	mov    0x805140,%eax
  802801:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802804:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802808:	74 07                	je     802811 <print_mem_block_lists+0x9e>
  80280a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280d:	8b 00                	mov    (%eax),%eax
  80280f:	eb 05                	jmp    802816 <print_mem_block_lists+0xa3>
  802811:	b8 00 00 00 00       	mov    $0x0,%eax
  802816:	a3 40 51 80 00       	mov    %eax,0x805140
  80281b:	a1 40 51 80 00       	mov    0x805140,%eax
  802820:	85 c0                	test   %eax,%eax
  802822:	75 8a                	jne    8027ae <print_mem_block_lists+0x3b>
  802824:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802828:	75 84                	jne    8027ae <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80282a:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80282e:	75 10                	jne    802840 <print_mem_block_lists+0xcd>
  802830:	83 ec 0c             	sub    $0xc,%esp
  802833:	68 44 49 80 00       	push   $0x804944
  802838:	e8 19 e4 ff ff       	call   800c56 <cprintf>
  80283d:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802840:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802847:	83 ec 0c             	sub    $0xc,%esp
  80284a:	68 68 49 80 00       	push   $0x804968
  80284f:	e8 02 e4 ff ff       	call   800c56 <cprintf>
  802854:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802857:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80285b:	a1 40 50 80 00       	mov    0x805040,%eax
  802860:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802863:	eb 56                	jmp    8028bb <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802865:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802869:	74 1c                	je     802887 <print_mem_block_lists+0x114>
  80286b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286e:	8b 50 08             	mov    0x8(%eax),%edx
  802871:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802874:	8b 48 08             	mov    0x8(%eax),%ecx
  802877:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80287a:	8b 40 0c             	mov    0xc(%eax),%eax
  80287d:	01 c8                	add    %ecx,%eax
  80287f:	39 c2                	cmp    %eax,%edx
  802881:	73 04                	jae    802887 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802883:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802887:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288a:	8b 50 08             	mov    0x8(%eax),%edx
  80288d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802890:	8b 40 0c             	mov    0xc(%eax),%eax
  802893:	01 c2                	add    %eax,%edx
  802895:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802898:	8b 40 08             	mov    0x8(%eax),%eax
  80289b:	83 ec 04             	sub    $0x4,%esp
  80289e:	52                   	push   %edx
  80289f:	50                   	push   %eax
  8028a0:	68 35 49 80 00       	push   $0x804935
  8028a5:	e8 ac e3 ff ff       	call   800c56 <cprintf>
  8028aa:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8028ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8028b3:	a1 48 50 80 00       	mov    0x805048,%eax
  8028b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028bf:	74 07                	je     8028c8 <print_mem_block_lists+0x155>
  8028c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c4:	8b 00                	mov    (%eax),%eax
  8028c6:	eb 05                	jmp    8028cd <print_mem_block_lists+0x15a>
  8028c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8028cd:	a3 48 50 80 00       	mov    %eax,0x805048
  8028d2:	a1 48 50 80 00       	mov    0x805048,%eax
  8028d7:	85 c0                	test   %eax,%eax
  8028d9:	75 8a                	jne    802865 <print_mem_block_lists+0xf2>
  8028db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028df:	75 84                	jne    802865 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8028e1:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8028e5:	75 10                	jne    8028f7 <print_mem_block_lists+0x184>
  8028e7:	83 ec 0c             	sub    $0xc,%esp
  8028ea:	68 80 49 80 00       	push   $0x804980
  8028ef:	e8 62 e3 ff ff       	call   800c56 <cprintf>
  8028f4:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8028f7:	83 ec 0c             	sub    $0xc,%esp
  8028fa:	68 f4 48 80 00       	push   $0x8048f4
  8028ff:	e8 52 e3 ff ff       	call   800c56 <cprintf>
  802904:	83 c4 10             	add    $0x10,%esp

}
  802907:	90                   	nop
  802908:	c9                   	leave  
  802909:	c3                   	ret    

0080290a <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80290a:	55                   	push   %ebp
  80290b:	89 e5                	mov    %esp,%ebp
  80290d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802910:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802917:	00 00 00 
  80291a:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802921:	00 00 00 
  802924:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80292b:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  80292e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802935:	e9 9e 00 00 00       	jmp    8029d8 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  80293a:	a1 50 50 80 00       	mov    0x805050,%eax
  80293f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802942:	c1 e2 04             	shl    $0x4,%edx
  802945:	01 d0                	add    %edx,%eax
  802947:	85 c0                	test   %eax,%eax
  802949:	75 14                	jne    80295f <initialize_MemBlocksList+0x55>
  80294b:	83 ec 04             	sub    $0x4,%esp
  80294e:	68 a8 49 80 00       	push   $0x8049a8
  802953:	6a 46                	push   $0x46
  802955:	68 cb 49 80 00       	push   $0x8049cb
  80295a:	e8 43 e0 ff ff       	call   8009a2 <_panic>
  80295f:	a1 50 50 80 00       	mov    0x805050,%eax
  802964:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802967:	c1 e2 04             	shl    $0x4,%edx
  80296a:	01 d0                	add    %edx,%eax
  80296c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802972:	89 10                	mov    %edx,(%eax)
  802974:	8b 00                	mov    (%eax),%eax
  802976:	85 c0                	test   %eax,%eax
  802978:	74 18                	je     802992 <initialize_MemBlocksList+0x88>
  80297a:	a1 48 51 80 00       	mov    0x805148,%eax
  80297f:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802985:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802988:	c1 e1 04             	shl    $0x4,%ecx
  80298b:	01 ca                	add    %ecx,%edx
  80298d:	89 50 04             	mov    %edx,0x4(%eax)
  802990:	eb 12                	jmp    8029a4 <initialize_MemBlocksList+0x9a>
  802992:	a1 50 50 80 00       	mov    0x805050,%eax
  802997:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80299a:	c1 e2 04             	shl    $0x4,%edx
  80299d:	01 d0                	add    %edx,%eax
  80299f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029a4:	a1 50 50 80 00       	mov    0x805050,%eax
  8029a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029ac:	c1 e2 04             	shl    $0x4,%edx
  8029af:	01 d0                	add    %edx,%eax
  8029b1:	a3 48 51 80 00       	mov    %eax,0x805148
  8029b6:	a1 50 50 80 00       	mov    0x805050,%eax
  8029bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029be:	c1 e2 04             	shl    $0x4,%edx
  8029c1:	01 d0                	add    %edx,%eax
  8029c3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029ca:	a1 54 51 80 00       	mov    0x805154,%eax
  8029cf:	40                   	inc    %eax
  8029d0:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8029d5:	ff 45 f4             	incl   -0xc(%ebp)
  8029d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029db:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029de:	0f 82 56 ff ff ff    	jb     80293a <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8029e4:	90                   	nop
  8029e5:	c9                   	leave  
  8029e6:	c3                   	ret    

008029e7 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8029e7:	55                   	push   %ebp
  8029e8:	89 e5                	mov    %esp,%ebp
  8029ea:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8029ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f0:	8b 00                	mov    (%eax),%eax
  8029f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8029f5:	eb 19                	jmp    802a10 <find_block+0x29>
	{
		if(va==point->sva)
  8029f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8029fa:	8b 40 08             	mov    0x8(%eax),%eax
  8029fd:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802a00:	75 05                	jne    802a07 <find_block+0x20>
		   return point;
  802a02:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a05:	eb 36                	jmp    802a3d <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802a07:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0a:	8b 40 08             	mov    0x8(%eax),%eax
  802a0d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802a10:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802a14:	74 07                	je     802a1d <find_block+0x36>
  802a16:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a19:	8b 00                	mov    (%eax),%eax
  802a1b:	eb 05                	jmp    802a22 <find_block+0x3b>
  802a1d:	b8 00 00 00 00       	mov    $0x0,%eax
  802a22:	8b 55 08             	mov    0x8(%ebp),%edx
  802a25:	89 42 08             	mov    %eax,0x8(%edx)
  802a28:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2b:	8b 40 08             	mov    0x8(%eax),%eax
  802a2e:	85 c0                	test   %eax,%eax
  802a30:	75 c5                	jne    8029f7 <find_block+0x10>
  802a32:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802a36:	75 bf                	jne    8029f7 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802a38:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a3d:	c9                   	leave  
  802a3e:	c3                   	ret    

00802a3f <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802a3f:	55                   	push   %ebp
  802a40:	89 e5                	mov    %esp,%ebp
  802a42:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802a45:	a1 40 50 80 00       	mov    0x805040,%eax
  802a4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802a4d:	a1 44 50 80 00       	mov    0x805044,%eax
  802a52:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802a55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a58:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802a5b:	74 24                	je     802a81 <insert_sorted_allocList+0x42>
  802a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a60:	8b 50 08             	mov    0x8(%eax),%edx
  802a63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a66:	8b 40 08             	mov    0x8(%eax),%eax
  802a69:	39 c2                	cmp    %eax,%edx
  802a6b:	76 14                	jbe    802a81 <insert_sorted_allocList+0x42>
  802a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a70:	8b 50 08             	mov    0x8(%eax),%edx
  802a73:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a76:	8b 40 08             	mov    0x8(%eax),%eax
  802a79:	39 c2                	cmp    %eax,%edx
  802a7b:	0f 82 60 01 00 00    	jb     802be1 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802a81:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a85:	75 65                	jne    802aec <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802a87:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a8b:	75 14                	jne    802aa1 <insert_sorted_allocList+0x62>
  802a8d:	83 ec 04             	sub    $0x4,%esp
  802a90:	68 a8 49 80 00       	push   $0x8049a8
  802a95:	6a 6b                	push   $0x6b
  802a97:	68 cb 49 80 00       	push   $0x8049cb
  802a9c:	e8 01 df ff ff       	call   8009a2 <_panic>
  802aa1:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aaa:	89 10                	mov    %edx,(%eax)
  802aac:	8b 45 08             	mov    0x8(%ebp),%eax
  802aaf:	8b 00                	mov    (%eax),%eax
  802ab1:	85 c0                	test   %eax,%eax
  802ab3:	74 0d                	je     802ac2 <insert_sorted_allocList+0x83>
  802ab5:	a1 40 50 80 00       	mov    0x805040,%eax
  802aba:	8b 55 08             	mov    0x8(%ebp),%edx
  802abd:	89 50 04             	mov    %edx,0x4(%eax)
  802ac0:	eb 08                	jmp    802aca <insert_sorted_allocList+0x8b>
  802ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac5:	a3 44 50 80 00       	mov    %eax,0x805044
  802aca:	8b 45 08             	mov    0x8(%ebp),%eax
  802acd:	a3 40 50 80 00       	mov    %eax,0x805040
  802ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802adc:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802ae1:	40                   	inc    %eax
  802ae2:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802ae7:	e9 dc 01 00 00       	jmp    802cc8 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802aec:	8b 45 08             	mov    0x8(%ebp),%eax
  802aef:	8b 50 08             	mov    0x8(%eax),%edx
  802af2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af5:	8b 40 08             	mov    0x8(%eax),%eax
  802af8:	39 c2                	cmp    %eax,%edx
  802afa:	77 6c                	ja     802b68 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802afc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b00:	74 06                	je     802b08 <insert_sorted_allocList+0xc9>
  802b02:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b06:	75 14                	jne    802b1c <insert_sorted_allocList+0xdd>
  802b08:	83 ec 04             	sub    $0x4,%esp
  802b0b:	68 e4 49 80 00       	push   $0x8049e4
  802b10:	6a 6f                	push   $0x6f
  802b12:	68 cb 49 80 00       	push   $0x8049cb
  802b17:	e8 86 de ff ff       	call   8009a2 <_panic>
  802b1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b1f:	8b 50 04             	mov    0x4(%eax),%edx
  802b22:	8b 45 08             	mov    0x8(%ebp),%eax
  802b25:	89 50 04             	mov    %edx,0x4(%eax)
  802b28:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b2e:	89 10                	mov    %edx,(%eax)
  802b30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b33:	8b 40 04             	mov    0x4(%eax),%eax
  802b36:	85 c0                	test   %eax,%eax
  802b38:	74 0d                	je     802b47 <insert_sorted_allocList+0x108>
  802b3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b3d:	8b 40 04             	mov    0x4(%eax),%eax
  802b40:	8b 55 08             	mov    0x8(%ebp),%edx
  802b43:	89 10                	mov    %edx,(%eax)
  802b45:	eb 08                	jmp    802b4f <insert_sorted_allocList+0x110>
  802b47:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4a:	a3 40 50 80 00       	mov    %eax,0x805040
  802b4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b52:	8b 55 08             	mov    0x8(%ebp),%edx
  802b55:	89 50 04             	mov    %edx,0x4(%eax)
  802b58:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b5d:	40                   	inc    %eax
  802b5e:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802b63:	e9 60 01 00 00       	jmp    802cc8 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802b68:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6b:	8b 50 08             	mov    0x8(%eax),%edx
  802b6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b71:	8b 40 08             	mov    0x8(%eax),%eax
  802b74:	39 c2                	cmp    %eax,%edx
  802b76:	0f 82 4c 01 00 00    	jb     802cc8 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802b7c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b80:	75 14                	jne    802b96 <insert_sorted_allocList+0x157>
  802b82:	83 ec 04             	sub    $0x4,%esp
  802b85:	68 1c 4a 80 00       	push   $0x804a1c
  802b8a:	6a 73                	push   $0x73
  802b8c:	68 cb 49 80 00       	push   $0x8049cb
  802b91:	e8 0c de ff ff       	call   8009a2 <_panic>
  802b96:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9f:	89 50 04             	mov    %edx,0x4(%eax)
  802ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba5:	8b 40 04             	mov    0x4(%eax),%eax
  802ba8:	85 c0                	test   %eax,%eax
  802baa:	74 0c                	je     802bb8 <insert_sorted_allocList+0x179>
  802bac:	a1 44 50 80 00       	mov    0x805044,%eax
  802bb1:	8b 55 08             	mov    0x8(%ebp),%edx
  802bb4:	89 10                	mov    %edx,(%eax)
  802bb6:	eb 08                	jmp    802bc0 <insert_sorted_allocList+0x181>
  802bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbb:	a3 40 50 80 00       	mov    %eax,0x805040
  802bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc3:	a3 44 50 80 00       	mov    %eax,0x805044
  802bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bd1:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802bd6:	40                   	inc    %eax
  802bd7:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802bdc:	e9 e7 00 00 00       	jmp    802cc8 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802be1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802be7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802bee:	a1 40 50 80 00       	mov    0x805040,%eax
  802bf3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bf6:	e9 9d 00 00 00       	jmp    802c98 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802bfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfe:	8b 00                	mov    (%eax),%eax
  802c00:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802c03:	8b 45 08             	mov    0x8(%ebp),%eax
  802c06:	8b 50 08             	mov    0x8(%eax),%edx
  802c09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0c:	8b 40 08             	mov    0x8(%eax),%eax
  802c0f:	39 c2                	cmp    %eax,%edx
  802c11:	76 7d                	jbe    802c90 <insert_sorted_allocList+0x251>
  802c13:	8b 45 08             	mov    0x8(%ebp),%eax
  802c16:	8b 50 08             	mov    0x8(%eax),%edx
  802c19:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c1c:	8b 40 08             	mov    0x8(%eax),%eax
  802c1f:	39 c2                	cmp    %eax,%edx
  802c21:	73 6d                	jae    802c90 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802c23:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c27:	74 06                	je     802c2f <insert_sorted_allocList+0x1f0>
  802c29:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c2d:	75 14                	jne    802c43 <insert_sorted_allocList+0x204>
  802c2f:	83 ec 04             	sub    $0x4,%esp
  802c32:	68 40 4a 80 00       	push   $0x804a40
  802c37:	6a 7f                	push   $0x7f
  802c39:	68 cb 49 80 00       	push   $0x8049cb
  802c3e:	e8 5f dd ff ff       	call   8009a2 <_panic>
  802c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c46:	8b 10                	mov    (%eax),%edx
  802c48:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4b:	89 10                	mov    %edx,(%eax)
  802c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c50:	8b 00                	mov    (%eax),%eax
  802c52:	85 c0                	test   %eax,%eax
  802c54:	74 0b                	je     802c61 <insert_sorted_allocList+0x222>
  802c56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c59:	8b 00                	mov    (%eax),%eax
  802c5b:	8b 55 08             	mov    0x8(%ebp),%edx
  802c5e:	89 50 04             	mov    %edx,0x4(%eax)
  802c61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c64:	8b 55 08             	mov    0x8(%ebp),%edx
  802c67:	89 10                	mov    %edx,(%eax)
  802c69:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c6f:	89 50 04             	mov    %edx,0x4(%eax)
  802c72:	8b 45 08             	mov    0x8(%ebp),%eax
  802c75:	8b 00                	mov    (%eax),%eax
  802c77:	85 c0                	test   %eax,%eax
  802c79:	75 08                	jne    802c83 <insert_sorted_allocList+0x244>
  802c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7e:	a3 44 50 80 00       	mov    %eax,0x805044
  802c83:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802c88:	40                   	inc    %eax
  802c89:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802c8e:	eb 39                	jmp    802cc9 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802c90:	a1 48 50 80 00       	mov    0x805048,%eax
  802c95:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c98:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c9c:	74 07                	je     802ca5 <insert_sorted_allocList+0x266>
  802c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca1:	8b 00                	mov    (%eax),%eax
  802ca3:	eb 05                	jmp    802caa <insert_sorted_allocList+0x26b>
  802ca5:	b8 00 00 00 00       	mov    $0x0,%eax
  802caa:	a3 48 50 80 00       	mov    %eax,0x805048
  802caf:	a1 48 50 80 00       	mov    0x805048,%eax
  802cb4:	85 c0                	test   %eax,%eax
  802cb6:	0f 85 3f ff ff ff    	jne    802bfb <insert_sorted_allocList+0x1bc>
  802cbc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cc0:	0f 85 35 ff ff ff    	jne    802bfb <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802cc6:	eb 01                	jmp    802cc9 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802cc8:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802cc9:	90                   	nop
  802cca:	c9                   	leave  
  802ccb:	c3                   	ret    

00802ccc <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802ccc:	55                   	push   %ebp
  802ccd:	89 e5                	mov    %esp,%ebp
  802ccf:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802cd2:	a1 38 51 80 00       	mov    0x805138,%eax
  802cd7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cda:	e9 85 01 00 00       	jmp    802e64 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802cdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce2:	8b 40 0c             	mov    0xc(%eax),%eax
  802ce5:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ce8:	0f 82 6e 01 00 00    	jb     802e5c <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802cee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf1:	8b 40 0c             	mov    0xc(%eax),%eax
  802cf4:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cf7:	0f 85 8a 00 00 00    	jne    802d87 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802cfd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d01:	75 17                	jne    802d1a <alloc_block_FF+0x4e>
  802d03:	83 ec 04             	sub    $0x4,%esp
  802d06:	68 74 4a 80 00       	push   $0x804a74
  802d0b:	68 93 00 00 00       	push   $0x93
  802d10:	68 cb 49 80 00       	push   $0x8049cb
  802d15:	e8 88 dc ff ff       	call   8009a2 <_panic>
  802d1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1d:	8b 00                	mov    (%eax),%eax
  802d1f:	85 c0                	test   %eax,%eax
  802d21:	74 10                	je     802d33 <alloc_block_FF+0x67>
  802d23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d26:	8b 00                	mov    (%eax),%eax
  802d28:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d2b:	8b 52 04             	mov    0x4(%edx),%edx
  802d2e:	89 50 04             	mov    %edx,0x4(%eax)
  802d31:	eb 0b                	jmp    802d3e <alloc_block_FF+0x72>
  802d33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d36:	8b 40 04             	mov    0x4(%eax),%eax
  802d39:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d41:	8b 40 04             	mov    0x4(%eax),%eax
  802d44:	85 c0                	test   %eax,%eax
  802d46:	74 0f                	je     802d57 <alloc_block_FF+0x8b>
  802d48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4b:	8b 40 04             	mov    0x4(%eax),%eax
  802d4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d51:	8b 12                	mov    (%edx),%edx
  802d53:	89 10                	mov    %edx,(%eax)
  802d55:	eb 0a                	jmp    802d61 <alloc_block_FF+0x95>
  802d57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5a:	8b 00                	mov    (%eax),%eax
  802d5c:	a3 38 51 80 00       	mov    %eax,0x805138
  802d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d64:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d74:	a1 44 51 80 00       	mov    0x805144,%eax
  802d79:	48                   	dec    %eax
  802d7a:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d82:	e9 10 01 00 00       	jmp    802e97 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802d87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8a:	8b 40 0c             	mov    0xc(%eax),%eax
  802d8d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d90:	0f 86 c6 00 00 00    	jbe    802e5c <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d96:	a1 48 51 80 00       	mov    0x805148,%eax
  802d9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802d9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da1:	8b 50 08             	mov    0x8(%eax),%edx
  802da4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da7:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802daa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dad:	8b 55 08             	mov    0x8(%ebp),%edx
  802db0:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802db3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802db7:	75 17                	jne    802dd0 <alloc_block_FF+0x104>
  802db9:	83 ec 04             	sub    $0x4,%esp
  802dbc:	68 74 4a 80 00       	push   $0x804a74
  802dc1:	68 9b 00 00 00       	push   $0x9b
  802dc6:	68 cb 49 80 00       	push   $0x8049cb
  802dcb:	e8 d2 db ff ff       	call   8009a2 <_panic>
  802dd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd3:	8b 00                	mov    (%eax),%eax
  802dd5:	85 c0                	test   %eax,%eax
  802dd7:	74 10                	je     802de9 <alloc_block_FF+0x11d>
  802dd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ddc:	8b 00                	mov    (%eax),%eax
  802dde:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802de1:	8b 52 04             	mov    0x4(%edx),%edx
  802de4:	89 50 04             	mov    %edx,0x4(%eax)
  802de7:	eb 0b                	jmp    802df4 <alloc_block_FF+0x128>
  802de9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dec:	8b 40 04             	mov    0x4(%eax),%eax
  802def:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802df4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df7:	8b 40 04             	mov    0x4(%eax),%eax
  802dfa:	85 c0                	test   %eax,%eax
  802dfc:	74 0f                	je     802e0d <alloc_block_FF+0x141>
  802dfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e01:	8b 40 04             	mov    0x4(%eax),%eax
  802e04:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e07:	8b 12                	mov    (%edx),%edx
  802e09:	89 10                	mov    %edx,(%eax)
  802e0b:	eb 0a                	jmp    802e17 <alloc_block_FF+0x14b>
  802e0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e10:	8b 00                	mov    (%eax),%eax
  802e12:	a3 48 51 80 00       	mov    %eax,0x805148
  802e17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e1a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e23:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e2a:	a1 54 51 80 00       	mov    0x805154,%eax
  802e2f:	48                   	dec    %eax
  802e30:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802e35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e38:	8b 50 08             	mov    0x8(%eax),%edx
  802e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3e:	01 c2                	add    %eax,%edx
  802e40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e43:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802e46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e49:	8b 40 0c             	mov    0xc(%eax),%eax
  802e4c:	2b 45 08             	sub    0x8(%ebp),%eax
  802e4f:	89 c2                	mov    %eax,%edx
  802e51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e54:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802e57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e5a:	eb 3b                	jmp    802e97 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802e5c:	a1 40 51 80 00       	mov    0x805140,%eax
  802e61:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e64:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e68:	74 07                	je     802e71 <alloc_block_FF+0x1a5>
  802e6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6d:	8b 00                	mov    (%eax),%eax
  802e6f:	eb 05                	jmp    802e76 <alloc_block_FF+0x1aa>
  802e71:	b8 00 00 00 00       	mov    $0x0,%eax
  802e76:	a3 40 51 80 00       	mov    %eax,0x805140
  802e7b:	a1 40 51 80 00       	mov    0x805140,%eax
  802e80:	85 c0                	test   %eax,%eax
  802e82:	0f 85 57 fe ff ff    	jne    802cdf <alloc_block_FF+0x13>
  802e88:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e8c:	0f 85 4d fe ff ff    	jne    802cdf <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802e92:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e97:	c9                   	leave  
  802e98:	c3                   	ret    

00802e99 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802e99:	55                   	push   %ebp
  802e9a:	89 e5                	mov    %esp,%ebp
  802e9c:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802e9f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802ea6:	a1 38 51 80 00       	mov    0x805138,%eax
  802eab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802eae:	e9 df 00 00 00       	jmp    802f92 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802eb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb6:	8b 40 0c             	mov    0xc(%eax),%eax
  802eb9:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ebc:	0f 82 c8 00 00 00    	jb     802f8a <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec8:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ecb:	0f 85 8a 00 00 00    	jne    802f5b <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802ed1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ed5:	75 17                	jne    802eee <alloc_block_BF+0x55>
  802ed7:	83 ec 04             	sub    $0x4,%esp
  802eda:	68 74 4a 80 00       	push   $0x804a74
  802edf:	68 b7 00 00 00       	push   $0xb7
  802ee4:	68 cb 49 80 00       	push   $0x8049cb
  802ee9:	e8 b4 da ff ff       	call   8009a2 <_panic>
  802eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef1:	8b 00                	mov    (%eax),%eax
  802ef3:	85 c0                	test   %eax,%eax
  802ef5:	74 10                	je     802f07 <alloc_block_BF+0x6e>
  802ef7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efa:	8b 00                	mov    (%eax),%eax
  802efc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802eff:	8b 52 04             	mov    0x4(%edx),%edx
  802f02:	89 50 04             	mov    %edx,0x4(%eax)
  802f05:	eb 0b                	jmp    802f12 <alloc_block_BF+0x79>
  802f07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0a:	8b 40 04             	mov    0x4(%eax),%eax
  802f0d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f15:	8b 40 04             	mov    0x4(%eax),%eax
  802f18:	85 c0                	test   %eax,%eax
  802f1a:	74 0f                	je     802f2b <alloc_block_BF+0x92>
  802f1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1f:	8b 40 04             	mov    0x4(%eax),%eax
  802f22:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f25:	8b 12                	mov    (%edx),%edx
  802f27:	89 10                	mov    %edx,(%eax)
  802f29:	eb 0a                	jmp    802f35 <alloc_block_BF+0x9c>
  802f2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2e:	8b 00                	mov    (%eax),%eax
  802f30:	a3 38 51 80 00       	mov    %eax,0x805138
  802f35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f38:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f41:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f48:	a1 44 51 80 00       	mov    0x805144,%eax
  802f4d:	48                   	dec    %eax
  802f4e:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802f53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f56:	e9 4d 01 00 00       	jmp    8030a8 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802f5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5e:	8b 40 0c             	mov    0xc(%eax),%eax
  802f61:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f64:	76 24                	jbe    802f8a <alloc_block_BF+0xf1>
  802f66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f69:	8b 40 0c             	mov    0xc(%eax),%eax
  802f6c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802f6f:	73 19                	jae    802f8a <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802f71:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802f78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7b:	8b 40 0c             	mov    0xc(%eax),%eax
  802f7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802f81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f84:	8b 40 08             	mov    0x8(%eax),%eax
  802f87:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802f8a:	a1 40 51 80 00       	mov    0x805140,%eax
  802f8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f96:	74 07                	je     802f9f <alloc_block_BF+0x106>
  802f98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9b:	8b 00                	mov    (%eax),%eax
  802f9d:	eb 05                	jmp    802fa4 <alloc_block_BF+0x10b>
  802f9f:	b8 00 00 00 00       	mov    $0x0,%eax
  802fa4:	a3 40 51 80 00       	mov    %eax,0x805140
  802fa9:	a1 40 51 80 00       	mov    0x805140,%eax
  802fae:	85 c0                	test   %eax,%eax
  802fb0:	0f 85 fd fe ff ff    	jne    802eb3 <alloc_block_BF+0x1a>
  802fb6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fba:	0f 85 f3 fe ff ff    	jne    802eb3 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802fc0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fc4:	0f 84 d9 00 00 00    	je     8030a3 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802fca:	a1 48 51 80 00       	mov    0x805148,%eax
  802fcf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802fd2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fd5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802fd8:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802fdb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fde:	8b 55 08             	mov    0x8(%ebp),%edx
  802fe1:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802fe4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802fe8:	75 17                	jne    803001 <alloc_block_BF+0x168>
  802fea:	83 ec 04             	sub    $0x4,%esp
  802fed:	68 74 4a 80 00       	push   $0x804a74
  802ff2:	68 c7 00 00 00       	push   $0xc7
  802ff7:	68 cb 49 80 00       	push   $0x8049cb
  802ffc:	e8 a1 d9 ff ff       	call   8009a2 <_panic>
  803001:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803004:	8b 00                	mov    (%eax),%eax
  803006:	85 c0                	test   %eax,%eax
  803008:	74 10                	je     80301a <alloc_block_BF+0x181>
  80300a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80300d:	8b 00                	mov    (%eax),%eax
  80300f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803012:	8b 52 04             	mov    0x4(%edx),%edx
  803015:	89 50 04             	mov    %edx,0x4(%eax)
  803018:	eb 0b                	jmp    803025 <alloc_block_BF+0x18c>
  80301a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80301d:	8b 40 04             	mov    0x4(%eax),%eax
  803020:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803025:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803028:	8b 40 04             	mov    0x4(%eax),%eax
  80302b:	85 c0                	test   %eax,%eax
  80302d:	74 0f                	je     80303e <alloc_block_BF+0x1a5>
  80302f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803032:	8b 40 04             	mov    0x4(%eax),%eax
  803035:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803038:	8b 12                	mov    (%edx),%edx
  80303a:	89 10                	mov    %edx,(%eax)
  80303c:	eb 0a                	jmp    803048 <alloc_block_BF+0x1af>
  80303e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803041:	8b 00                	mov    (%eax),%eax
  803043:	a3 48 51 80 00       	mov    %eax,0x805148
  803048:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80304b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803051:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803054:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80305b:	a1 54 51 80 00       	mov    0x805154,%eax
  803060:	48                   	dec    %eax
  803061:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  803066:	83 ec 08             	sub    $0x8,%esp
  803069:	ff 75 ec             	pushl  -0x14(%ebp)
  80306c:	68 38 51 80 00       	push   $0x805138
  803071:	e8 71 f9 ff ff       	call   8029e7 <find_block>
  803076:	83 c4 10             	add    $0x10,%esp
  803079:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  80307c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80307f:	8b 50 08             	mov    0x8(%eax),%edx
  803082:	8b 45 08             	mov    0x8(%ebp),%eax
  803085:	01 c2                	add    %eax,%edx
  803087:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80308a:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  80308d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803090:	8b 40 0c             	mov    0xc(%eax),%eax
  803093:	2b 45 08             	sub    0x8(%ebp),%eax
  803096:	89 c2                	mov    %eax,%edx
  803098:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80309b:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  80309e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030a1:	eb 05                	jmp    8030a8 <alloc_block_BF+0x20f>
	}
	return NULL;
  8030a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030a8:	c9                   	leave  
  8030a9:	c3                   	ret    

008030aa <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8030aa:	55                   	push   %ebp
  8030ab:	89 e5                	mov    %esp,%ebp
  8030ad:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8030b0:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030b5:	85 c0                	test   %eax,%eax
  8030b7:	0f 85 de 01 00 00    	jne    80329b <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8030bd:	a1 38 51 80 00       	mov    0x805138,%eax
  8030c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030c5:	e9 9e 01 00 00       	jmp    803268 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8030ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8030d0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030d3:	0f 82 87 01 00 00    	jb     803260 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8030d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8030df:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030e2:	0f 85 95 00 00 00    	jne    80317d <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8030e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030ec:	75 17                	jne    803105 <alloc_block_NF+0x5b>
  8030ee:	83 ec 04             	sub    $0x4,%esp
  8030f1:	68 74 4a 80 00       	push   $0x804a74
  8030f6:	68 e0 00 00 00       	push   $0xe0
  8030fb:	68 cb 49 80 00       	push   $0x8049cb
  803100:	e8 9d d8 ff ff       	call   8009a2 <_panic>
  803105:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803108:	8b 00                	mov    (%eax),%eax
  80310a:	85 c0                	test   %eax,%eax
  80310c:	74 10                	je     80311e <alloc_block_NF+0x74>
  80310e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803111:	8b 00                	mov    (%eax),%eax
  803113:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803116:	8b 52 04             	mov    0x4(%edx),%edx
  803119:	89 50 04             	mov    %edx,0x4(%eax)
  80311c:	eb 0b                	jmp    803129 <alloc_block_NF+0x7f>
  80311e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803121:	8b 40 04             	mov    0x4(%eax),%eax
  803124:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803129:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312c:	8b 40 04             	mov    0x4(%eax),%eax
  80312f:	85 c0                	test   %eax,%eax
  803131:	74 0f                	je     803142 <alloc_block_NF+0x98>
  803133:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803136:	8b 40 04             	mov    0x4(%eax),%eax
  803139:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80313c:	8b 12                	mov    (%edx),%edx
  80313e:	89 10                	mov    %edx,(%eax)
  803140:	eb 0a                	jmp    80314c <alloc_block_NF+0xa2>
  803142:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803145:	8b 00                	mov    (%eax),%eax
  803147:	a3 38 51 80 00       	mov    %eax,0x805138
  80314c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803155:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803158:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80315f:	a1 44 51 80 00       	mov    0x805144,%eax
  803164:	48                   	dec    %eax
  803165:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  80316a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316d:	8b 40 08             	mov    0x8(%eax),%eax
  803170:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   return  point;
  803175:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803178:	e9 f8 04 00 00       	jmp    803675 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  80317d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803180:	8b 40 0c             	mov    0xc(%eax),%eax
  803183:	3b 45 08             	cmp    0x8(%ebp),%eax
  803186:	0f 86 d4 00 00 00    	jbe    803260 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80318c:	a1 48 51 80 00       	mov    0x805148,%eax
  803191:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  803194:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803197:	8b 50 08             	mov    0x8(%eax),%edx
  80319a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80319d:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8031a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8031a6:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8031a9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031ad:	75 17                	jne    8031c6 <alloc_block_NF+0x11c>
  8031af:	83 ec 04             	sub    $0x4,%esp
  8031b2:	68 74 4a 80 00       	push   $0x804a74
  8031b7:	68 e9 00 00 00       	push   $0xe9
  8031bc:	68 cb 49 80 00       	push   $0x8049cb
  8031c1:	e8 dc d7 ff ff       	call   8009a2 <_panic>
  8031c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c9:	8b 00                	mov    (%eax),%eax
  8031cb:	85 c0                	test   %eax,%eax
  8031cd:	74 10                	je     8031df <alloc_block_NF+0x135>
  8031cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031d2:	8b 00                	mov    (%eax),%eax
  8031d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031d7:	8b 52 04             	mov    0x4(%edx),%edx
  8031da:	89 50 04             	mov    %edx,0x4(%eax)
  8031dd:	eb 0b                	jmp    8031ea <alloc_block_NF+0x140>
  8031df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031e2:	8b 40 04             	mov    0x4(%eax),%eax
  8031e5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ed:	8b 40 04             	mov    0x4(%eax),%eax
  8031f0:	85 c0                	test   %eax,%eax
  8031f2:	74 0f                	je     803203 <alloc_block_NF+0x159>
  8031f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f7:	8b 40 04             	mov    0x4(%eax),%eax
  8031fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031fd:	8b 12                	mov    (%edx),%edx
  8031ff:	89 10                	mov    %edx,(%eax)
  803201:	eb 0a                	jmp    80320d <alloc_block_NF+0x163>
  803203:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803206:	8b 00                	mov    (%eax),%eax
  803208:	a3 48 51 80 00       	mov    %eax,0x805148
  80320d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803210:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803216:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803219:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803220:	a1 54 51 80 00       	mov    0x805154,%eax
  803225:	48                   	dec    %eax
  803226:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  80322b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80322e:	8b 40 08             	mov    0x8(%eax),%eax
  803231:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   point->sva += size;
  803236:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803239:	8b 50 08             	mov    0x8(%eax),%edx
  80323c:	8b 45 08             	mov    0x8(%ebp),%eax
  80323f:	01 c2                	add    %eax,%edx
  803241:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803244:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  803247:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324a:	8b 40 0c             	mov    0xc(%eax),%eax
  80324d:	2b 45 08             	sub    0x8(%ebp),%eax
  803250:	89 c2                	mov    %eax,%edx
  803252:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803255:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  803258:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80325b:	e9 15 04 00 00       	jmp    803675 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  803260:	a1 40 51 80 00       	mov    0x805140,%eax
  803265:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803268:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80326c:	74 07                	je     803275 <alloc_block_NF+0x1cb>
  80326e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803271:	8b 00                	mov    (%eax),%eax
  803273:	eb 05                	jmp    80327a <alloc_block_NF+0x1d0>
  803275:	b8 00 00 00 00       	mov    $0x0,%eax
  80327a:	a3 40 51 80 00       	mov    %eax,0x805140
  80327f:	a1 40 51 80 00       	mov    0x805140,%eax
  803284:	85 c0                	test   %eax,%eax
  803286:	0f 85 3e fe ff ff    	jne    8030ca <alloc_block_NF+0x20>
  80328c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803290:	0f 85 34 fe ff ff    	jne    8030ca <alloc_block_NF+0x20>
  803296:	e9 d5 03 00 00       	jmp    803670 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80329b:	a1 38 51 80 00       	mov    0x805138,%eax
  8032a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032a3:	e9 b1 01 00 00       	jmp    803459 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8032a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ab:	8b 50 08             	mov    0x8(%eax),%edx
  8032ae:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032b3:	39 c2                	cmp    %eax,%edx
  8032b5:	0f 82 96 01 00 00    	jb     803451 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8032bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032be:	8b 40 0c             	mov    0xc(%eax),%eax
  8032c1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032c4:	0f 82 87 01 00 00    	jb     803451 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8032ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8032d0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032d3:	0f 85 95 00 00 00    	jne    80336e <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8032d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032dd:	75 17                	jne    8032f6 <alloc_block_NF+0x24c>
  8032df:	83 ec 04             	sub    $0x4,%esp
  8032e2:	68 74 4a 80 00       	push   $0x804a74
  8032e7:	68 fc 00 00 00       	push   $0xfc
  8032ec:	68 cb 49 80 00       	push   $0x8049cb
  8032f1:	e8 ac d6 ff ff       	call   8009a2 <_panic>
  8032f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f9:	8b 00                	mov    (%eax),%eax
  8032fb:	85 c0                	test   %eax,%eax
  8032fd:	74 10                	je     80330f <alloc_block_NF+0x265>
  8032ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803302:	8b 00                	mov    (%eax),%eax
  803304:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803307:	8b 52 04             	mov    0x4(%edx),%edx
  80330a:	89 50 04             	mov    %edx,0x4(%eax)
  80330d:	eb 0b                	jmp    80331a <alloc_block_NF+0x270>
  80330f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803312:	8b 40 04             	mov    0x4(%eax),%eax
  803315:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80331a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80331d:	8b 40 04             	mov    0x4(%eax),%eax
  803320:	85 c0                	test   %eax,%eax
  803322:	74 0f                	je     803333 <alloc_block_NF+0x289>
  803324:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803327:	8b 40 04             	mov    0x4(%eax),%eax
  80332a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80332d:	8b 12                	mov    (%edx),%edx
  80332f:	89 10                	mov    %edx,(%eax)
  803331:	eb 0a                	jmp    80333d <alloc_block_NF+0x293>
  803333:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803336:	8b 00                	mov    (%eax),%eax
  803338:	a3 38 51 80 00       	mov    %eax,0x805138
  80333d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803340:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803346:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803349:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803350:	a1 44 51 80 00       	mov    0x805144,%eax
  803355:	48                   	dec    %eax
  803356:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  80335b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335e:	8b 40 08             	mov    0x8(%eax),%eax
  803361:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  803366:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803369:	e9 07 03 00 00       	jmp    803675 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80336e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803371:	8b 40 0c             	mov    0xc(%eax),%eax
  803374:	3b 45 08             	cmp    0x8(%ebp),%eax
  803377:	0f 86 d4 00 00 00    	jbe    803451 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80337d:	a1 48 51 80 00       	mov    0x805148,%eax
  803382:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  803385:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803388:	8b 50 08             	mov    0x8(%eax),%edx
  80338b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80338e:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803391:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803394:	8b 55 08             	mov    0x8(%ebp),%edx
  803397:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80339a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80339e:	75 17                	jne    8033b7 <alloc_block_NF+0x30d>
  8033a0:	83 ec 04             	sub    $0x4,%esp
  8033a3:	68 74 4a 80 00       	push   $0x804a74
  8033a8:	68 04 01 00 00       	push   $0x104
  8033ad:	68 cb 49 80 00       	push   $0x8049cb
  8033b2:	e8 eb d5 ff ff       	call   8009a2 <_panic>
  8033b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ba:	8b 00                	mov    (%eax),%eax
  8033bc:	85 c0                	test   %eax,%eax
  8033be:	74 10                	je     8033d0 <alloc_block_NF+0x326>
  8033c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033c3:	8b 00                	mov    (%eax),%eax
  8033c5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033c8:	8b 52 04             	mov    0x4(%edx),%edx
  8033cb:	89 50 04             	mov    %edx,0x4(%eax)
  8033ce:	eb 0b                	jmp    8033db <alloc_block_NF+0x331>
  8033d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033d3:	8b 40 04             	mov    0x4(%eax),%eax
  8033d6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033de:	8b 40 04             	mov    0x4(%eax),%eax
  8033e1:	85 c0                	test   %eax,%eax
  8033e3:	74 0f                	je     8033f4 <alloc_block_NF+0x34a>
  8033e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e8:	8b 40 04             	mov    0x4(%eax),%eax
  8033eb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033ee:	8b 12                	mov    (%edx),%edx
  8033f0:	89 10                	mov    %edx,(%eax)
  8033f2:	eb 0a                	jmp    8033fe <alloc_block_NF+0x354>
  8033f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033f7:	8b 00                	mov    (%eax),%eax
  8033f9:	a3 48 51 80 00       	mov    %eax,0x805148
  8033fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803401:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803407:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80340a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803411:	a1 54 51 80 00       	mov    0x805154,%eax
  803416:	48                   	dec    %eax
  803417:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  80341c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80341f:	8b 40 08             	mov    0x8(%eax),%eax
  803422:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  803427:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80342a:	8b 50 08             	mov    0x8(%eax),%edx
  80342d:	8b 45 08             	mov    0x8(%ebp),%eax
  803430:	01 c2                	add    %eax,%edx
  803432:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803435:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803438:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343b:	8b 40 0c             	mov    0xc(%eax),%eax
  80343e:	2b 45 08             	sub    0x8(%ebp),%eax
  803441:	89 c2                	mov    %eax,%edx
  803443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803446:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803449:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80344c:	e9 24 02 00 00       	jmp    803675 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803451:	a1 40 51 80 00       	mov    0x805140,%eax
  803456:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803459:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80345d:	74 07                	je     803466 <alloc_block_NF+0x3bc>
  80345f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803462:	8b 00                	mov    (%eax),%eax
  803464:	eb 05                	jmp    80346b <alloc_block_NF+0x3c1>
  803466:	b8 00 00 00 00       	mov    $0x0,%eax
  80346b:	a3 40 51 80 00       	mov    %eax,0x805140
  803470:	a1 40 51 80 00       	mov    0x805140,%eax
  803475:	85 c0                	test   %eax,%eax
  803477:	0f 85 2b fe ff ff    	jne    8032a8 <alloc_block_NF+0x1fe>
  80347d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803481:	0f 85 21 fe ff ff    	jne    8032a8 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803487:	a1 38 51 80 00       	mov    0x805138,%eax
  80348c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80348f:	e9 ae 01 00 00       	jmp    803642 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  803494:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803497:	8b 50 08             	mov    0x8(%eax),%edx
  80349a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80349f:	39 c2                	cmp    %eax,%edx
  8034a1:	0f 83 93 01 00 00    	jae    80363a <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  8034a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034aa:	8b 40 0c             	mov    0xc(%eax),%eax
  8034ad:	3b 45 08             	cmp    0x8(%ebp),%eax
  8034b0:	0f 82 84 01 00 00    	jb     80363a <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  8034b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8034bc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8034bf:	0f 85 95 00 00 00    	jne    80355a <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8034c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034c9:	75 17                	jne    8034e2 <alloc_block_NF+0x438>
  8034cb:	83 ec 04             	sub    $0x4,%esp
  8034ce:	68 74 4a 80 00       	push   $0x804a74
  8034d3:	68 14 01 00 00       	push   $0x114
  8034d8:	68 cb 49 80 00       	push   $0x8049cb
  8034dd:	e8 c0 d4 ff ff       	call   8009a2 <_panic>
  8034e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e5:	8b 00                	mov    (%eax),%eax
  8034e7:	85 c0                	test   %eax,%eax
  8034e9:	74 10                	je     8034fb <alloc_block_NF+0x451>
  8034eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ee:	8b 00                	mov    (%eax),%eax
  8034f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034f3:	8b 52 04             	mov    0x4(%edx),%edx
  8034f6:	89 50 04             	mov    %edx,0x4(%eax)
  8034f9:	eb 0b                	jmp    803506 <alloc_block_NF+0x45c>
  8034fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034fe:	8b 40 04             	mov    0x4(%eax),%eax
  803501:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803506:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803509:	8b 40 04             	mov    0x4(%eax),%eax
  80350c:	85 c0                	test   %eax,%eax
  80350e:	74 0f                	je     80351f <alloc_block_NF+0x475>
  803510:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803513:	8b 40 04             	mov    0x4(%eax),%eax
  803516:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803519:	8b 12                	mov    (%edx),%edx
  80351b:	89 10                	mov    %edx,(%eax)
  80351d:	eb 0a                	jmp    803529 <alloc_block_NF+0x47f>
  80351f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803522:	8b 00                	mov    (%eax),%eax
  803524:	a3 38 51 80 00       	mov    %eax,0x805138
  803529:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80352c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803532:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803535:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80353c:	a1 44 51 80 00       	mov    0x805144,%eax
  803541:	48                   	dec    %eax
  803542:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803547:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80354a:	8b 40 08             	mov    0x8(%eax),%eax
  80354d:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  803552:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803555:	e9 1b 01 00 00       	jmp    803675 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80355a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80355d:	8b 40 0c             	mov    0xc(%eax),%eax
  803560:	3b 45 08             	cmp    0x8(%ebp),%eax
  803563:	0f 86 d1 00 00 00    	jbe    80363a <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803569:	a1 48 51 80 00       	mov    0x805148,%eax
  80356e:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  803571:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803574:	8b 50 08             	mov    0x8(%eax),%edx
  803577:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80357a:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80357d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803580:	8b 55 08             	mov    0x8(%ebp),%edx
  803583:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803586:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80358a:	75 17                	jne    8035a3 <alloc_block_NF+0x4f9>
  80358c:	83 ec 04             	sub    $0x4,%esp
  80358f:	68 74 4a 80 00       	push   $0x804a74
  803594:	68 1c 01 00 00       	push   $0x11c
  803599:	68 cb 49 80 00       	push   $0x8049cb
  80359e:	e8 ff d3 ff ff       	call   8009a2 <_panic>
  8035a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035a6:	8b 00                	mov    (%eax),%eax
  8035a8:	85 c0                	test   %eax,%eax
  8035aa:	74 10                	je     8035bc <alloc_block_NF+0x512>
  8035ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035af:	8b 00                	mov    (%eax),%eax
  8035b1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8035b4:	8b 52 04             	mov    0x4(%edx),%edx
  8035b7:	89 50 04             	mov    %edx,0x4(%eax)
  8035ba:	eb 0b                	jmp    8035c7 <alloc_block_NF+0x51d>
  8035bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035bf:	8b 40 04             	mov    0x4(%eax),%eax
  8035c2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035ca:	8b 40 04             	mov    0x4(%eax),%eax
  8035cd:	85 c0                	test   %eax,%eax
  8035cf:	74 0f                	je     8035e0 <alloc_block_NF+0x536>
  8035d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035d4:	8b 40 04             	mov    0x4(%eax),%eax
  8035d7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8035da:	8b 12                	mov    (%edx),%edx
  8035dc:	89 10                	mov    %edx,(%eax)
  8035de:	eb 0a                	jmp    8035ea <alloc_block_NF+0x540>
  8035e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035e3:	8b 00                	mov    (%eax),%eax
  8035e5:	a3 48 51 80 00       	mov    %eax,0x805148
  8035ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035f6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035fd:	a1 54 51 80 00       	mov    0x805154,%eax
  803602:	48                   	dec    %eax
  803603:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803608:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80360b:	8b 40 08             	mov    0x8(%eax),%eax
  80360e:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  803613:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803616:	8b 50 08             	mov    0x8(%eax),%edx
  803619:	8b 45 08             	mov    0x8(%ebp),%eax
  80361c:	01 c2                	add    %eax,%edx
  80361e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803621:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803624:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803627:	8b 40 0c             	mov    0xc(%eax),%eax
  80362a:	2b 45 08             	sub    0x8(%ebp),%eax
  80362d:	89 c2                	mov    %eax,%edx
  80362f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803632:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803635:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803638:	eb 3b                	jmp    803675 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  80363a:	a1 40 51 80 00       	mov    0x805140,%eax
  80363f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803642:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803646:	74 07                	je     80364f <alloc_block_NF+0x5a5>
  803648:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80364b:	8b 00                	mov    (%eax),%eax
  80364d:	eb 05                	jmp    803654 <alloc_block_NF+0x5aa>
  80364f:	b8 00 00 00 00       	mov    $0x0,%eax
  803654:	a3 40 51 80 00       	mov    %eax,0x805140
  803659:	a1 40 51 80 00       	mov    0x805140,%eax
  80365e:	85 c0                	test   %eax,%eax
  803660:	0f 85 2e fe ff ff    	jne    803494 <alloc_block_NF+0x3ea>
  803666:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80366a:	0f 85 24 fe ff ff    	jne    803494 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  803670:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803675:	c9                   	leave  
  803676:	c3                   	ret    

00803677 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803677:	55                   	push   %ebp
  803678:	89 e5                	mov    %esp,%ebp
  80367a:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  80367d:	a1 38 51 80 00       	mov    0x805138,%eax
  803682:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  803685:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80368a:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  80368d:	a1 38 51 80 00       	mov    0x805138,%eax
  803692:	85 c0                	test   %eax,%eax
  803694:	74 14                	je     8036aa <insert_sorted_with_merge_freeList+0x33>
  803696:	8b 45 08             	mov    0x8(%ebp),%eax
  803699:	8b 50 08             	mov    0x8(%eax),%edx
  80369c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80369f:	8b 40 08             	mov    0x8(%eax),%eax
  8036a2:	39 c2                	cmp    %eax,%edx
  8036a4:	0f 87 9b 01 00 00    	ja     803845 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  8036aa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036ae:	75 17                	jne    8036c7 <insert_sorted_with_merge_freeList+0x50>
  8036b0:	83 ec 04             	sub    $0x4,%esp
  8036b3:	68 a8 49 80 00       	push   $0x8049a8
  8036b8:	68 38 01 00 00       	push   $0x138
  8036bd:	68 cb 49 80 00       	push   $0x8049cb
  8036c2:	e8 db d2 ff ff       	call   8009a2 <_panic>
  8036c7:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8036cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d0:	89 10                	mov    %edx,(%eax)
  8036d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d5:	8b 00                	mov    (%eax),%eax
  8036d7:	85 c0                	test   %eax,%eax
  8036d9:	74 0d                	je     8036e8 <insert_sorted_with_merge_freeList+0x71>
  8036db:	a1 38 51 80 00       	mov    0x805138,%eax
  8036e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8036e3:	89 50 04             	mov    %edx,0x4(%eax)
  8036e6:	eb 08                	jmp    8036f0 <insert_sorted_with_merge_freeList+0x79>
  8036e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036eb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8036f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f3:	a3 38 51 80 00       	mov    %eax,0x805138
  8036f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036fb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803702:	a1 44 51 80 00       	mov    0x805144,%eax
  803707:	40                   	inc    %eax
  803708:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80370d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803711:	0f 84 a8 06 00 00    	je     803dbf <insert_sorted_with_merge_freeList+0x748>
  803717:	8b 45 08             	mov    0x8(%ebp),%eax
  80371a:	8b 50 08             	mov    0x8(%eax),%edx
  80371d:	8b 45 08             	mov    0x8(%ebp),%eax
  803720:	8b 40 0c             	mov    0xc(%eax),%eax
  803723:	01 c2                	add    %eax,%edx
  803725:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803728:	8b 40 08             	mov    0x8(%eax),%eax
  80372b:	39 c2                	cmp    %eax,%edx
  80372d:	0f 85 8c 06 00 00    	jne    803dbf <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  803733:	8b 45 08             	mov    0x8(%ebp),%eax
  803736:	8b 50 0c             	mov    0xc(%eax),%edx
  803739:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80373c:	8b 40 0c             	mov    0xc(%eax),%eax
  80373f:	01 c2                	add    %eax,%edx
  803741:	8b 45 08             	mov    0x8(%ebp),%eax
  803744:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803747:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80374b:	75 17                	jne    803764 <insert_sorted_with_merge_freeList+0xed>
  80374d:	83 ec 04             	sub    $0x4,%esp
  803750:	68 74 4a 80 00       	push   $0x804a74
  803755:	68 3c 01 00 00       	push   $0x13c
  80375a:	68 cb 49 80 00       	push   $0x8049cb
  80375f:	e8 3e d2 ff ff       	call   8009a2 <_panic>
  803764:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803767:	8b 00                	mov    (%eax),%eax
  803769:	85 c0                	test   %eax,%eax
  80376b:	74 10                	je     80377d <insert_sorted_with_merge_freeList+0x106>
  80376d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803770:	8b 00                	mov    (%eax),%eax
  803772:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803775:	8b 52 04             	mov    0x4(%edx),%edx
  803778:	89 50 04             	mov    %edx,0x4(%eax)
  80377b:	eb 0b                	jmp    803788 <insert_sorted_with_merge_freeList+0x111>
  80377d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803780:	8b 40 04             	mov    0x4(%eax),%eax
  803783:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803788:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80378b:	8b 40 04             	mov    0x4(%eax),%eax
  80378e:	85 c0                	test   %eax,%eax
  803790:	74 0f                	je     8037a1 <insert_sorted_with_merge_freeList+0x12a>
  803792:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803795:	8b 40 04             	mov    0x4(%eax),%eax
  803798:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80379b:	8b 12                	mov    (%edx),%edx
  80379d:	89 10                	mov    %edx,(%eax)
  80379f:	eb 0a                	jmp    8037ab <insert_sorted_with_merge_freeList+0x134>
  8037a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037a4:	8b 00                	mov    (%eax),%eax
  8037a6:	a3 38 51 80 00       	mov    %eax,0x805138
  8037ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037b7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037be:	a1 44 51 80 00       	mov    0x805144,%eax
  8037c3:	48                   	dec    %eax
  8037c4:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  8037c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037cc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  8037d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037d6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  8037dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8037e1:	75 17                	jne    8037fa <insert_sorted_with_merge_freeList+0x183>
  8037e3:	83 ec 04             	sub    $0x4,%esp
  8037e6:	68 a8 49 80 00       	push   $0x8049a8
  8037eb:	68 3f 01 00 00       	push   $0x13f
  8037f0:	68 cb 49 80 00       	push   $0x8049cb
  8037f5:	e8 a8 d1 ff ff       	call   8009a2 <_panic>
  8037fa:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803800:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803803:	89 10                	mov    %edx,(%eax)
  803805:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803808:	8b 00                	mov    (%eax),%eax
  80380a:	85 c0                	test   %eax,%eax
  80380c:	74 0d                	je     80381b <insert_sorted_with_merge_freeList+0x1a4>
  80380e:	a1 48 51 80 00       	mov    0x805148,%eax
  803813:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803816:	89 50 04             	mov    %edx,0x4(%eax)
  803819:	eb 08                	jmp    803823 <insert_sorted_with_merge_freeList+0x1ac>
  80381b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80381e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803823:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803826:	a3 48 51 80 00       	mov    %eax,0x805148
  80382b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80382e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803835:	a1 54 51 80 00       	mov    0x805154,%eax
  80383a:	40                   	inc    %eax
  80383b:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803840:	e9 7a 05 00 00       	jmp    803dbf <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803845:	8b 45 08             	mov    0x8(%ebp),%eax
  803848:	8b 50 08             	mov    0x8(%eax),%edx
  80384b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80384e:	8b 40 08             	mov    0x8(%eax),%eax
  803851:	39 c2                	cmp    %eax,%edx
  803853:	0f 82 14 01 00 00    	jb     80396d <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803859:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80385c:	8b 50 08             	mov    0x8(%eax),%edx
  80385f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803862:	8b 40 0c             	mov    0xc(%eax),%eax
  803865:	01 c2                	add    %eax,%edx
  803867:	8b 45 08             	mov    0x8(%ebp),%eax
  80386a:	8b 40 08             	mov    0x8(%eax),%eax
  80386d:	39 c2                	cmp    %eax,%edx
  80386f:	0f 85 90 00 00 00    	jne    803905 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803875:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803878:	8b 50 0c             	mov    0xc(%eax),%edx
  80387b:	8b 45 08             	mov    0x8(%ebp),%eax
  80387e:	8b 40 0c             	mov    0xc(%eax),%eax
  803881:	01 c2                	add    %eax,%edx
  803883:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803886:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803889:	8b 45 08             	mov    0x8(%ebp),%eax
  80388c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803893:	8b 45 08             	mov    0x8(%ebp),%eax
  803896:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80389d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038a1:	75 17                	jne    8038ba <insert_sorted_with_merge_freeList+0x243>
  8038a3:	83 ec 04             	sub    $0x4,%esp
  8038a6:	68 a8 49 80 00       	push   $0x8049a8
  8038ab:	68 49 01 00 00       	push   $0x149
  8038b0:	68 cb 49 80 00       	push   $0x8049cb
  8038b5:	e8 e8 d0 ff ff       	call   8009a2 <_panic>
  8038ba:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8038c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c3:	89 10                	mov    %edx,(%eax)
  8038c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c8:	8b 00                	mov    (%eax),%eax
  8038ca:	85 c0                	test   %eax,%eax
  8038cc:	74 0d                	je     8038db <insert_sorted_with_merge_freeList+0x264>
  8038ce:	a1 48 51 80 00       	mov    0x805148,%eax
  8038d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8038d6:	89 50 04             	mov    %edx,0x4(%eax)
  8038d9:	eb 08                	jmp    8038e3 <insert_sorted_with_merge_freeList+0x26c>
  8038db:	8b 45 08             	mov    0x8(%ebp),%eax
  8038de:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8038e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e6:	a3 48 51 80 00       	mov    %eax,0x805148
  8038eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038f5:	a1 54 51 80 00       	mov    0x805154,%eax
  8038fa:	40                   	inc    %eax
  8038fb:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803900:	e9 bb 04 00 00       	jmp    803dc0 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803905:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803909:	75 17                	jne    803922 <insert_sorted_with_merge_freeList+0x2ab>
  80390b:	83 ec 04             	sub    $0x4,%esp
  80390e:	68 1c 4a 80 00       	push   $0x804a1c
  803913:	68 4c 01 00 00       	push   $0x14c
  803918:	68 cb 49 80 00       	push   $0x8049cb
  80391d:	e8 80 d0 ff ff       	call   8009a2 <_panic>
  803922:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803928:	8b 45 08             	mov    0x8(%ebp),%eax
  80392b:	89 50 04             	mov    %edx,0x4(%eax)
  80392e:	8b 45 08             	mov    0x8(%ebp),%eax
  803931:	8b 40 04             	mov    0x4(%eax),%eax
  803934:	85 c0                	test   %eax,%eax
  803936:	74 0c                	je     803944 <insert_sorted_with_merge_freeList+0x2cd>
  803938:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80393d:	8b 55 08             	mov    0x8(%ebp),%edx
  803940:	89 10                	mov    %edx,(%eax)
  803942:	eb 08                	jmp    80394c <insert_sorted_with_merge_freeList+0x2d5>
  803944:	8b 45 08             	mov    0x8(%ebp),%eax
  803947:	a3 38 51 80 00       	mov    %eax,0x805138
  80394c:	8b 45 08             	mov    0x8(%ebp),%eax
  80394f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803954:	8b 45 08             	mov    0x8(%ebp),%eax
  803957:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80395d:	a1 44 51 80 00       	mov    0x805144,%eax
  803962:	40                   	inc    %eax
  803963:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803968:	e9 53 04 00 00       	jmp    803dc0 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80396d:	a1 38 51 80 00       	mov    0x805138,%eax
  803972:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803975:	e9 15 04 00 00       	jmp    803d8f <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  80397a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80397d:	8b 00                	mov    (%eax),%eax
  80397f:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803982:	8b 45 08             	mov    0x8(%ebp),%eax
  803985:	8b 50 08             	mov    0x8(%eax),%edx
  803988:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80398b:	8b 40 08             	mov    0x8(%eax),%eax
  80398e:	39 c2                	cmp    %eax,%edx
  803990:	0f 86 f1 03 00 00    	jbe    803d87 <insert_sorted_with_merge_freeList+0x710>
  803996:	8b 45 08             	mov    0x8(%ebp),%eax
  803999:	8b 50 08             	mov    0x8(%eax),%edx
  80399c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80399f:	8b 40 08             	mov    0x8(%eax),%eax
  8039a2:	39 c2                	cmp    %eax,%edx
  8039a4:	0f 83 dd 03 00 00    	jae    803d87 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8039aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039ad:	8b 50 08             	mov    0x8(%eax),%edx
  8039b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8039b6:	01 c2                	add    %eax,%edx
  8039b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8039bb:	8b 40 08             	mov    0x8(%eax),%eax
  8039be:	39 c2                	cmp    %eax,%edx
  8039c0:	0f 85 b9 01 00 00    	jne    803b7f <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8039c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8039c9:	8b 50 08             	mov    0x8(%eax),%edx
  8039cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8039cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8039d2:	01 c2                	add    %eax,%edx
  8039d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039d7:	8b 40 08             	mov    0x8(%eax),%eax
  8039da:	39 c2                	cmp    %eax,%edx
  8039dc:	0f 85 0d 01 00 00    	jne    803aef <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8039e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039e5:	8b 50 0c             	mov    0xc(%eax),%edx
  8039e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039eb:	8b 40 0c             	mov    0xc(%eax),%eax
  8039ee:	01 c2                	add    %eax,%edx
  8039f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039f3:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8039f6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8039fa:	75 17                	jne    803a13 <insert_sorted_with_merge_freeList+0x39c>
  8039fc:	83 ec 04             	sub    $0x4,%esp
  8039ff:	68 74 4a 80 00       	push   $0x804a74
  803a04:	68 5c 01 00 00       	push   $0x15c
  803a09:	68 cb 49 80 00       	push   $0x8049cb
  803a0e:	e8 8f cf ff ff       	call   8009a2 <_panic>
  803a13:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a16:	8b 00                	mov    (%eax),%eax
  803a18:	85 c0                	test   %eax,%eax
  803a1a:	74 10                	je     803a2c <insert_sorted_with_merge_freeList+0x3b5>
  803a1c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a1f:	8b 00                	mov    (%eax),%eax
  803a21:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a24:	8b 52 04             	mov    0x4(%edx),%edx
  803a27:	89 50 04             	mov    %edx,0x4(%eax)
  803a2a:	eb 0b                	jmp    803a37 <insert_sorted_with_merge_freeList+0x3c0>
  803a2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a2f:	8b 40 04             	mov    0x4(%eax),%eax
  803a32:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803a37:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a3a:	8b 40 04             	mov    0x4(%eax),%eax
  803a3d:	85 c0                	test   %eax,%eax
  803a3f:	74 0f                	je     803a50 <insert_sorted_with_merge_freeList+0x3d9>
  803a41:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a44:	8b 40 04             	mov    0x4(%eax),%eax
  803a47:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a4a:	8b 12                	mov    (%edx),%edx
  803a4c:	89 10                	mov    %edx,(%eax)
  803a4e:	eb 0a                	jmp    803a5a <insert_sorted_with_merge_freeList+0x3e3>
  803a50:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a53:	8b 00                	mov    (%eax),%eax
  803a55:	a3 38 51 80 00       	mov    %eax,0x805138
  803a5a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a5d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a63:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a66:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a6d:	a1 44 51 80 00       	mov    0x805144,%eax
  803a72:	48                   	dec    %eax
  803a73:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803a78:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a7b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803a82:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a85:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803a8c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803a90:	75 17                	jne    803aa9 <insert_sorted_with_merge_freeList+0x432>
  803a92:	83 ec 04             	sub    $0x4,%esp
  803a95:	68 a8 49 80 00       	push   $0x8049a8
  803a9a:	68 5f 01 00 00       	push   $0x15f
  803a9f:	68 cb 49 80 00       	push   $0x8049cb
  803aa4:	e8 f9 ce ff ff       	call   8009a2 <_panic>
  803aa9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803aaf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ab2:	89 10                	mov    %edx,(%eax)
  803ab4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ab7:	8b 00                	mov    (%eax),%eax
  803ab9:	85 c0                	test   %eax,%eax
  803abb:	74 0d                	je     803aca <insert_sorted_with_merge_freeList+0x453>
  803abd:	a1 48 51 80 00       	mov    0x805148,%eax
  803ac2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803ac5:	89 50 04             	mov    %edx,0x4(%eax)
  803ac8:	eb 08                	jmp    803ad2 <insert_sorted_with_merge_freeList+0x45b>
  803aca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803acd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803ad2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ad5:	a3 48 51 80 00       	mov    %eax,0x805148
  803ada:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803add:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ae4:	a1 54 51 80 00       	mov    0x805154,%eax
  803ae9:	40                   	inc    %eax
  803aea:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803af2:	8b 50 0c             	mov    0xc(%eax),%edx
  803af5:	8b 45 08             	mov    0x8(%ebp),%eax
  803af8:	8b 40 0c             	mov    0xc(%eax),%eax
  803afb:	01 c2                	add    %eax,%edx
  803afd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b00:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803b03:	8b 45 08             	mov    0x8(%ebp),%eax
  803b06:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  803b10:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803b17:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b1b:	75 17                	jne    803b34 <insert_sorted_with_merge_freeList+0x4bd>
  803b1d:	83 ec 04             	sub    $0x4,%esp
  803b20:	68 a8 49 80 00       	push   $0x8049a8
  803b25:	68 64 01 00 00       	push   $0x164
  803b2a:	68 cb 49 80 00       	push   $0x8049cb
  803b2f:	e8 6e ce ff ff       	call   8009a2 <_panic>
  803b34:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  803b3d:	89 10                	mov    %edx,(%eax)
  803b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  803b42:	8b 00                	mov    (%eax),%eax
  803b44:	85 c0                	test   %eax,%eax
  803b46:	74 0d                	je     803b55 <insert_sorted_with_merge_freeList+0x4de>
  803b48:	a1 48 51 80 00       	mov    0x805148,%eax
  803b4d:	8b 55 08             	mov    0x8(%ebp),%edx
  803b50:	89 50 04             	mov    %edx,0x4(%eax)
  803b53:	eb 08                	jmp    803b5d <insert_sorted_with_merge_freeList+0x4e6>
  803b55:	8b 45 08             	mov    0x8(%ebp),%eax
  803b58:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  803b60:	a3 48 51 80 00       	mov    %eax,0x805148
  803b65:	8b 45 08             	mov    0x8(%ebp),%eax
  803b68:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b6f:	a1 54 51 80 00       	mov    0x805154,%eax
  803b74:	40                   	inc    %eax
  803b75:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803b7a:	e9 41 02 00 00       	jmp    803dc0 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  803b82:	8b 50 08             	mov    0x8(%eax),%edx
  803b85:	8b 45 08             	mov    0x8(%ebp),%eax
  803b88:	8b 40 0c             	mov    0xc(%eax),%eax
  803b8b:	01 c2                	add    %eax,%edx
  803b8d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b90:	8b 40 08             	mov    0x8(%eax),%eax
  803b93:	39 c2                	cmp    %eax,%edx
  803b95:	0f 85 7c 01 00 00    	jne    803d17 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803b9b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803b9f:	74 06                	je     803ba7 <insert_sorted_with_merge_freeList+0x530>
  803ba1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803ba5:	75 17                	jne    803bbe <insert_sorted_with_merge_freeList+0x547>
  803ba7:	83 ec 04             	sub    $0x4,%esp
  803baa:	68 e4 49 80 00       	push   $0x8049e4
  803baf:	68 69 01 00 00       	push   $0x169
  803bb4:	68 cb 49 80 00       	push   $0x8049cb
  803bb9:	e8 e4 cd ff ff       	call   8009a2 <_panic>
  803bbe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bc1:	8b 50 04             	mov    0x4(%eax),%edx
  803bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  803bc7:	89 50 04             	mov    %edx,0x4(%eax)
  803bca:	8b 45 08             	mov    0x8(%ebp),%eax
  803bcd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803bd0:	89 10                	mov    %edx,(%eax)
  803bd2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bd5:	8b 40 04             	mov    0x4(%eax),%eax
  803bd8:	85 c0                	test   %eax,%eax
  803bda:	74 0d                	je     803be9 <insert_sorted_with_merge_freeList+0x572>
  803bdc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bdf:	8b 40 04             	mov    0x4(%eax),%eax
  803be2:	8b 55 08             	mov    0x8(%ebp),%edx
  803be5:	89 10                	mov    %edx,(%eax)
  803be7:	eb 08                	jmp    803bf1 <insert_sorted_with_merge_freeList+0x57a>
  803be9:	8b 45 08             	mov    0x8(%ebp),%eax
  803bec:	a3 38 51 80 00       	mov    %eax,0x805138
  803bf1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bf4:	8b 55 08             	mov    0x8(%ebp),%edx
  803bf7:	89 50 04             	mov    %edx,0x4(%eax)
  803bfa:	a1 44 51 80 00       	mov    0x805144,%eax
  803bff:	40                   	inc    %eax
  803c00:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803c05:	8b 45 08             	mov    0x8(%ebp),%eax
  803c08:	8b 50 0c             	mov    0xc(%eax),%edx
  803c0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c0e:	8b 40 0c             	mov    0xc(%eax),%eax
  803c11:	01 c2                	add    %eax,%edx
  803c13:	8b 45 08             	mov    0x8(%ebp),%eax
  803c16:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803c19:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803c1d:	75 17                	jne    803c36 <insert_sorted_with_merge_freeList+0x5bf>
  803c1f:	83 ec 04             	sub    $0x4,%esp
  803c22:	68 74 4a 80 00       	push   $0x804a74
  803c27:	68 6b 01 00 00       	push   $0x16b
  803c2c:	68 cb 49 80 00       	push   $0x8049cb
  803c31:	e8 6c cd ff ff       	call   8009a2 <_panic>
  803c36:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c39:	8b 00                	mov    (%eax),%eax
  803c3b:	85 c0                	test   %eax,%eax
  803c3d:	74 10                	je     803c4f <insert_sorted_with_merge_freeList+0x5d8>
  803c3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c42:	8b 00                	mov    (%eax),%eax
  803c44:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c47:	8b 52 04             	mov    0x4(%edx),%edx
  803c4a:	89 50 04             	mov    %edx,0x4(%eax)
  803c4d:	eb 0b                	jmp    803c5a <insert_sorted_with_merge_freeList+0x5e3>
  803c4f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c52:	8b 40 04             	mov    0x4(%eax),%eax
  803c55:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803c5a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c5d:	8b 40 04             	mov    0x4(%eax),%eax
  803c60:	85 c0                	test   %eax,%eax
  803c62:	74 0f                	je     803c73 <insert_sorted_with_merge_freeList+0x5fc>
  803c64:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c67:	8b 40 04             	mov    0x4(%eax),%eax
  803c6a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c6d:	8b 12                	mov    (%edx),%edx
  803c6f:	89 10                	mov    %edx,(%eax)
  803c71:	eb 0a                	jmp    803c7d <insert_sorted_with_merge_freeList+0x606>
  803c73:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c76:	8b 00                	mov    (%eax),%eax
  803c78:	a3 38 51 80 00       	mov    %eax,0x805138
  803c7d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c80:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c89:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c90:	a1 44 51 80 00       	mov    0x805144,%eax
  803c95:	48                   	dec    %eax
  803c96:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803c9b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c9e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803ca5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ca8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803caf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803cb3:	75 17                	jne    803ccc <insert_sorted_with_merge_freeList+0x655>
  803cb5:	83 ec 04             	sub    $0x4,%esp
  803cb8:	68 a8 49 80 00       	push   $0x8049a8
  803cbd:	68 6e 01 00 00       	push   $0x16e
  803cc2:	68 cb 49 80 00       	push   $0x8049cb
  803cc7:	e8 d6 cc ff ff       	call   8009a2 <_panic>
  803ccc:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803cd2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cd5:	89 10                	mov    %edx,(%eax)
  803cd7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cda:	8b 00                	mov    (%eax),%eax
  803cdc:	85 c0                	test   %eax,%eax
  803cde:	74 0d                	je     803ced <insert_sorted_with_merge_freeList+0x676>
  803ce0:	a1 48 51 80 00       	mov    0x805148,%eax
  803ce5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803ce8:	89 50 04             	mov    %edx,0x4(%eax)
  803ceb:	eb 08                	jmp    803cf5 <insert_sorted_with_merge_freeList+0x67e>
  803ced:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cf0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803cf5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cf8:	a3 48 51 80 00       	mov    %eax,0x805148
  803cfd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d00:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d07:	a1 54 51 80 00       	mov    0x805154,%eax
  803d0c:	40                   	inc    %eax
  803d0d:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803d12:	e9 a9 00 00 00       	jmp    803dc0 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803d17:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d1b:	74 06                	je     803d23 <insert_sorted_with_merge_freeList+0x6ac>
  803d1d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803d21:	75 17                	jne    803d3a <insert_sorted_with_merge_freeList+0x6c3>
  803d23:	83 ec 04             	sub    $0x4,%esp
  803d26:	68 40 4a 80 00       	push   $0x804a40
  803d2b:	68 73 01 00 00       	push   $0x173
  803d30:	68 cb 49 80 00       	push   $0x8049cb
  803d35:	e8 68 cc ff ff       	call   8009a2 <_panic>
  803d3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d3d:	8b 10                	mov    (%eax),%edx
  803d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  803d42:	89 10                	mov    %edx,(%eax)
  803d44:	8b 45 08             	mov    0x8(%ebp),%eax
  803d47:	8b 00                	mov    (%eax),%eax
  803d49:	85 c0                	test   %eax,%eax
  803d4b:	74 0b                	je     803d58 <insert_sorted_with_merge_freeList+0x6e1>
  803d4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d50:	8b 00                	mov    (%eax),%eax
  803d52:	8b 55 08             	mov    0x8(%ebp),%edx
  803d55:	89 50 04             	mov    %edx,0x4(%eax)
  803d58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d5b:	8b 55 08             	mov    0x8(%ebp),%edx
  803d5e:	89 10                	mov    %edx,(%eax)
  803d60:	8b 45 08             	mov    0x8(%ebp),%eax
  803d63:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d66:	89 50 04             	mov    %edx,0x4(%eax)
  803d69:	8b 45 08             	mov    0x8(%ebp),%eax
  803d6c:	8b 00                	mov    (%eax),%eax
  803d6e:	85 c0                	test   %eax,%eax
  803d70:	75 08                	jne    803d7a <insert_sorted_with_merge_freeList+0x703>
  803d72:	8b 45 08             	mov    0x8(%ebp),%eax
  803d75:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803d7a:	a1 44 51 80 00       	mov    0x805144,%eax
  803d7f:	40                   	inc    %eax
  803d80:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803d85:	eb 39                	jmp    803dc0 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803d87:	a1 40 51 80 00       	mov    0x805140,%eax
  803d8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803d8f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d93:	74 07                	je     803d9c <insert_sorted_with_merge_freeList+0x725>
  803d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d98:	8b 00                	mov    (%eax),%eax
  803d9a:	eb 05                	jmp    803da1 <insert_sorted_with_merge_freeList+0x72a>
  803d9c:	b8 00 00 00 00       	mov    $0x0,%eax
  803da1:	a3 40 51 80 00       	mov    %eax,0x805140
  803da6:	a1 40 51 80 00       	mov    0x805140,%eax
  803dab:	85 c0                	test   %eax,%eax
  803dad:	0f 85 c7 fb ff ff    	jne    80397a <insert_sorted_with_merge_freeList+0x303>
  803db3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803db7:	0f 85 bd fb ff ff    	jne    80397a <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803dbd:	eb 01                	jmp    803dc0 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803dbf:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803dc0:	90                   	nop
  803dc1:	c9                   	leave  
  803dc2:	c3                   	ret    
  803dc3:	90                   	nop

00803dc4 <__udivdi3>:
  803dc4:	55                   	push   %ebp
  803dc5:	57                   	push   %edi
  803dc6:	56                   	push   %esi
  803dc7:	53                   	push   %ebx
  803dc8:	83 ec 1c             	sub    $0x1c,%esp
  803dcb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803dcf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803dd3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803dd7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803ddb:	89 ca                	mov    %ecx,%edx
  803ddd:	89 f8                	mov    %edi,%eax
  803ddf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803de3:	85 f6                	test   %esi,%esi
  803de5:	75 2d                	jne    803e14 <__udivdi3+0x50>
  803de7:	39 cf                	cmp    %ecx,%edi
  803de9:	77 65                	ja     803e50 <__udivdi3+0x8c>
  803deb:	89 fd                	mov    %edi,%ebp
  803ded:	85 ff                	test   %edi,%edi
  803def:	75 0b                	jne    803dfc <__udivdi3+0x38>
  803df1:	b8 01 00 00 00       	mov    $0x1,%eax
  803df6:	31 d2                	xor    %edx,%edx
  803df8:	f7 f7                	div    %edi
  803dfa:	89 c5                	mov    %eax,%ebp
  803dfc:	31 d2                	xor    %edx,%edx
  803dfe:	89 c8                	mov    %ecx,%eax
  803e00:	f7 f5                	div    %ebp
  803e02:	89 c1                	mov    %eax,%ecx
  803e04:	89 d8                	mov    %ebx,%eax
  803e06:	f7 f5                	div    %ebp
  803e08:	89 cf                	mov    %ecx,%edi
  803e0a:	89 fa                	mov    %edi,%edx
  803e0c:	83 c4 1c             	add    $0x1c,%esp
  803e0f:	5b                   	pop    %ebx
  803e10:	5e                   	pop    %esi
  803e11:	5f                   	pop    %edi
  803e12:	5d                   	pop    %ebp
  803e13:	c3                   	ret    
  803e14:	39 ce                	cmp    %ecx,%esi
  803e16:	77 28                	ja     803e40 <__udivdi3+0x7c>
  803e18:	0f bd fe             	bsr    %esi,%edi
  803e1b:	83 f7 1f             	xor    $0x1f,%edi
  803e1e:	75 40                	jne    803e60 <__udivdi3+0x9c>
  803e20:	39 ce                	cmp    %ecx,%esi
  803e22:	72 0a                	jb     803e2e <__udivdi3+0x6a>
  803e24:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803e28:	0f 87 9e 00 00 00    	ja     803ecc <__udivdi3+0x108>
  803e2e:	b8 01 00 00 00       	mov    $0x1,%eax
  803e33:	89 fa                	mov    %edi,%edx
  803e35:	83 c4 1c             	add    $0x1c,%esp
  803e38:	5b                   	pop    %ebx
  803e39:	5e                   	pop    %esi
  803e3a:	5f                   	pop    %edi
  803e3b:	5d                   	pop    %ebp
  803e3c:	c3                   	ret    
  803e3d:	8d 76 00             	lea    0x0(%esi),%esi
  803e40:	31 ff                	xor    %edi,%edi
  803e42:	31 c0                	xor    %eax,%eax
  803e44:	89 fa                	mov    %edi,%edx
  803e46:	83 c4 1c             	add    $0x1c,%esp
  803e49:	5b                   	pop    %ebx
  803e4a:	5e                   	pop    %esi
  803e4b:	5f                   	pop    %edi
  803e4c:	5d                   	pop    %ebp
  803e4d:	c3                   	ret    
  803e4e:	66 90                	xchg   %ax,%ax
  803e50:	89 d8                	mov    %ebx,%eax
  803e52:	f7 f7                	div    %edi
  803e54:	31 ff                	xor    %edi,%edi
  803e56:	89 fa                	mov    %edi,%edx
  803e58:	83 c4 1c             	add    $0x1c,%esp
  803e5b:	5b                   	pop    %ebx
  803e5c:	5e                   	pop    %esi
  803e5d:	5f                   	pop    %edi
  803e5e:	5d                   	pop    %ebp
  803e5f:	c3                   	ret    
  803e60:	bd 20 00 00 00       	mov    $0x20,%ebp
  803e65:	89 eb                	mov    %ebp,%ebx
  803e67:	29 fb                	sub    %edi,%ebx
  803e69:	89 f9                	mov    %edi,%ecx
  803e6b:	d3 e6                	shl    %cl,%esi
  803e6d:	89 c5                	mov    %eax,%ebp
  803e6f:	88 d9                	mov    %bl,%cl
  803e71:	d3 ed                	shr    %cl,%ebp
  803e73:	89 e9                	mov    %ebp,%ecx
  803e75:	09 f1                	or     %esi,%ecx
  803e77:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803e7b:	89 f9                	mov    %edi,%ecx
  803e7d:	d3 e0                	shl    %cl,%eax
  803e7f:	89 c5                	mov    %eax,%ebp
  803e81:	89 d6                	mov    %edx,%esi
  803e83:	88 d9                	mov    %bl,%cl
  803e85:	d3 ee                	shr    %cl,%esi
  803e87:	89 f9                	mov    %edi,%ecx
  803e89:	d3 e2                	shl    %cl,%edx
  803e8b:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e8f:	88 d9                	mov    %bl,%cl
  803e91:	d3 e8                	shr    %cl,%eax
  803e93:	09 c2                	or     %eax,%edx
  803e95:	89 d0                	mov    %edx,%eax
  803e97:	89 f2                	mov    %esi,%edx
  803e99:	f7 74 24 0c          	divl   0xc(%esp)
  803e9d:	89 d6                	mov    %edx,%esi
  803e9f:	89 c3                	mov    %eax,%ebx
  803ea1:	f7 e5                	mul    %ebp
  803ea3:	39 d6                	cmp    %edx,%esi
  803ea5:	72 19                	jb     803ec0 <__udivdi3+0xfc>
  803ea7:	74 0b                	je     803eb4 <__udivdi3+0xf0>
  803ea9:	89 d8                	mov    %ebx,%eax
  803eab:	31 ff                	xor    %edi,%edi
  803ead:	e9 58 ff ff ff       	jmp    803e0a <__udivdi3+0x46>
  803eb2:	66 90                	xchg   %ax,%ax
  803eb4:	8b 54 24 08          	mov    0x8(%esp),%edx
  803eb8:	89 f9                	mov    %edi,%ecx
  803eba:	d3 e2                	shl    %cl,%edx
  803ebc:	39 c2                	cmp    %eax,%edx
  803ebe:	73 e9                	jae    803ea9 <__udivdi3+0xe5>
  803ec0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803ec3:	31 ff                	xor    %edi,%edi
  803ec5:	e9 40 ff ff ff       	jmp    803e0a <__udivdi3+0x46>
  803eca:	66 90                	xchg   %ax,%ax
  803ecc:	31 c0                	xor    %eax,%eax
  803ece:	e9 37 ff ff ff       	jmp    803e0a <__udivdi3+0x46>
  803ed3:	90                   	nop

00803ed4 <__umoddi3>:
  803ed4:	55                   	push   %ebp
  803ed5:	57                   	push   %edi
  803ed6:	56                   	push   %esi
  803ed7:	53                   	push   %ebx
  803ed8:	83 ec 1c             	sub    $0x1c,%esp
  803edb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803edf:	8b 74 24 34          	mov    0x34(%esp),%esi
  803ee3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803ee7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803eeb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803eef:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803ef3:	89 f3                	mov    %esi,%ebx
  803ef5:	89 fa                	mov    %edi,%edx
  803ef7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803efb:	89 34 24             	mov    %esi,(%esp)
  803efe:	85 c0                	test   %eax,%eax
  803f00:	75 1a                	jne    803f1c <__umoddi3+0x48>
  803f02:	39 f7                	cmp    %esi,%edi
  803f04:	0f 86 a2 00 00 00    	jbe    803fac <__umoddi3+0xd8>
  803f0a:	89 c8                	mov    %ecx,%eax
  803f0c:	89 f2                	mov    %esi,%edx
  803f0e:	f7 f7                	div    %edi
  803f10:	89 d0                	mov    %edx,%eax
  803f12:	31 d2                	xor    %edx,%edx
  803f14:	83 c4 1c             	add    $0x1c,%esp
  803f17:	5b                   	pop    %ebx
  803f18:	5e                   	pop    %esi
  803f19:	5f                   	pop    %edi
  803f1a:	5d                   	pop    %ebp
  803f1b:	c3                   	ret    
  803f1c:	39 f0                	cmp    %esi,%eax
  803f1e:	0f 87 ac 00 00 00    	ja     803fd0 <__umoddi3+0xfc>
  803f24:	0f bd e8             	bsr    %eax,%ebp
  803f27:	83 f5 1f             	xor    $0x1f,%ebp
  803f2a:	0f 84 ac 00 00 00    	je     803fdc <__umoddi3+0x108>
  803f30:	bf 20 00 00 00       	mov    $0x20,%edi
  803f35:	29 ef                	sub    %ebp,%edi
  803f37:	89 fe                	mov    %edi,%esi
  803f39:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803f3d:	89 e9                	mov    %ebp,%ecx
  803f3f:	d3 e0                	shl    %cl,%eax
  803f41:	89 d7                	mov    %edx,%edi
  803f43:	89 f1                	mov    %esi,%ecx
  803f45:	d3 ef                	shr    %cl,%edi
  803f47:	09 c7                	or     %eax,%edi
  803f49:	89 e9                	mov    %ebp,%ecx
  803f4b:	d3 e2                	shl    %cl,%edx
  803f4d:	89 14 24             	mov    %edx,(%esp)
  803f50:	89 d8                	mov    %ebx,%eax
  803f52:	d3 e0                	shl    %cl,%eax
  803f54:	89 c2                	mov    %eax,%edx
  803f56:	8b 44 24 08          	mov    0x8(%esp),%eax
  803f5a:	d3 e0                	shl    %cl,%eax
  803f5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803f60:	8b 44 24 08          	mov    0x8(%esp),%eax
  803f64:	89 f1                	mov    %esi,%ecx
  803f66:	d3 e8                	shr    %cl,%eax
  803f68:	09 d0                	or     %edx,%eax
  803f6a:	d3 eb                	shr    %cl,%ebx
  803f6c:	89 da                	mov    %ebx,%edx
  803f6e:	f7 f7                	div    %edi
  803f70:	89 d3                	mov    %edx,%ebx
  803f72:	f7 24 24             	mull   (%esp)
  803f75:	89 c6                	mov    %eax,%esi
  803f77:	89 d1                	mov    %edx,%ecx
  803f79:	39 d3                	cmp    %edx,%ebx
  803f7b:	0f 82 87 00 00 00    	jb     804008 <__umoddi3+0x134>
  803f81:	0f 84 91 00 00 00    	je     804018 <__umoddi3+0x144>
  803f87:	8b 54 24 04          	mov    0x4(%esp),%edx
  803f8b:	29 f2                	sub    %esi,%edx
  803f8d:	19 cb                	sbb    %ecx,%ebx
  803f8f:	89 d8                	mov    %ebx,%eax
  803f91:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803f95:	d3 e0                	shl    %cl,%eax
  803f97:	89 e9                	mov    %ebp,%ecx
  803f99:	d3 ea                	shr    %cl,%edx
  803f9b:	09 d0                	or     %edx,%eax
  803f9d:	89 e9                	mov    %ebp,%ecx
  803f9f:	d3 eb                	shr    %cl,%ebx
  803fa1:	89 da                	mov    %ebx,%edx
  803fa3:	83 c4 1c             	add    $0x1c,%esp
  803fa6:	5b                   	pop    %ebx
  803fa7:	5e                   	pop    %esi
  803fa8:	5f                   	pop    %edi
  803fa9:	5d                   	pop    %ebp
  803faa:	c3                   	ret    
  803fab:	90                   	nop
  803fac:	89 fd                	mov    %edi,%ebp
  803fae:	85 ff                	test   %edi,%edi
  803fb0:	75 0b                	jne    803fbd <__umoddi3+0xe9>
  803fb2:	b8 01 00 00 00       	mov    $0x1,%eax
  803fb7:	31 d2                	xor    %edx,%edx
  803fb9:	f7 f7                	div    %edi
  803fbb:	89 c5                	mov    %eax,%ebp
  803fbd:	89 f0                	mov    %esi,%eax
  803fbf:	31 d2                	xor    %edx,%edx
  803fc1:	f7 f5                	div    %ebp
  803fc3:	89 c8                	mov    %ecx,%eax
  803fc5:	f7 f5                	div    %ebp
  803fc7:	89 d0                	mov    %edx,%eax
  803fc9:	e9 44 ff ff ff       	jmp    803f12 <__umoddi3+0x3e>
  803fce:	66 90                	xchg   %ax,%ax
  803fd0:	89 c8                	mov    %ecx,%eax
  803fd2:	89 f2                	mov    %esi,%edx
  803fd4:	83 c4 1c             	add    $0x1c,%esp
  803fd7:	5b                   	pop    %ebx
  803fd8:	5e                   	pop    %esi
  803fd9:	5f                   	pop    %edi
  803fda:	5d                   	pop    %ebp
  803fdb:	c3                   	ret    
  803fdc:	3b 04 24             	cmp    (%esp),%eax
  803fdf:	72 06                	jb     803fe7 <__umoddi3+0x113>
  803fe1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803fe5:	77 0f                	ja     803ff6 <__umoddi3+0x122>
  803fe7:	89 f2                	mov    %esi,%edx
  803fe9:	29 f9                	sub    %edi,%ecx
  803feb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803fef:	89 14 24             	mov    %edx,(%esp)
  803ff2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ff6:	8b 44 24 04          	mov    0x4(%esp),%eax
  803ffa:	8b 14 24             	mov    (%esp),%edx
  803ffd:	83 c4 1c             	add    $0x1c,%esp
  804000:	5b                   	pop    %ebx
  804001:	5e                   	pop    %esi
  804002:	5f                   	pop    %edi
  804003:	5d                   	pop    %ebp
  804004:	c3                   	ret    
  804005:	8d 76 00             	lea    0x0(%esi),%esi
  804008:	2b 04 24             	sub    (%esp),%eax
  80400b:	19 fa                	sbb    %edi,%edx
  80400d:	89 d1                	mov    %edx,%ecx
  80400f:	89 c6                	mov    %eax,%esi
  804011:	e9 71 ff ff ff       	jmp    803f87 <__umoddi3+0xb3>
  804016:	66 90                	xchg   %ax,%ax
  804018:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80401c:	72 ea                	jb     804008 <__umoddi3+0x134>
  80401e:	89 d9                	mov    %ebx,%ecx
  804020:	e9 62 ff ff ff       	jmp    803f87 <__umoddi3+0xb3>
