
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
  80004c:	e8 e7 21 00 00       	call   802238 <sys_disable_interrupt>
		readline("Enter the number of elements: ", Line);
  800051:	83 ec 08             	sub    $0x8,%esp
  800054:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  80005a:	50                   	push   %eax
  80005b:	68 80 3f 80 00       	push   $0x803f80
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
  8000b1:	e8 95 20 00 00       	call   80214b <sys_calculate_free_frames>
  8000b6:	89 c3                	mov    %eax,%ebx
  8000b8:	e8 a7 20 00 00       	call   802164 <sys_calculate_modified_frames>
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
  8000e2:	68 a0 3f 80 00       	push   $0x803fa0
  8000e7:	e8 6a 0b 00 00       	call   800c56 <cprintf>
  8000ec:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000ef:	83 ec 0c             	sub    $0xc,%esp
  8000f2:	68 c3 3f 80 00       	push   $0x803fc3
  8000f7:	e8 5a 0b 00 00       	call   800c56 <cprintf>
  8000fc:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	68 d1 3f 80 00       	push   $0x803fd1
  800107:	e8 4a 0b 00 00       	call   800c56 <cprintf>
  80010c:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n") ;
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	68 e0 3f 80 00       	push   $0x803fe0
  800117:	e8 3a 0b 00 00       	call   800c56 <cprintf>
  80011c:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	68 f0 3f 80 00       	push   $0x803ff0
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
  800166:	e8 e7 20 00 00       	call   802252 <sys_enable_interrupt>
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
  8001f6:	68 fc 3f 80 00       	push   $0x803ffc
  8001fb:	6a 57                	push   $0x57
  8001fd:	68 1e 40 80 00       	push   $0x80401e
  800202:	e8 9b 07 00 00       	call   8009a2 <_panic>
		else
		{
			cprintf("===============================================\n") ;
  800207:	83 ec 0c             	sub    $0xc,%esp
  80020a:	68 3c 40 80 00       	push   $0x80403c
  80020f:	e8 42 0a 00 00       	call   800c56 <cprintf>
  800214:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800217:	83 ec 0c             	sub    $0xc,%esp
  80021a:	68 70 40 80 00       	push   $0x804070
  80021f:	e8 32 0a 00 00       	call   800c56 <cprintf>
  800224:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800227:	83 ec 0c             	sub    $0xc,%esp
  80022a:	68 a4 40 80 00       	push   $0x8040a4
  80022f:	e8 22 0a 00 00       	call   800c56 <cprintf>
  800234:	83 c4 10             	add    $0x10,%esp
		}

		//		cprintf("Free Frames After Calculation = %d\n", sys_calculate_free_frames()) ;

		cprintf("Freeing the Heap...\n\n") ;
  800237:	83 ec 0c             	sub    $0xc,%esp
  80023a:	68 d6 40 80 00       	push   $0x8040d6
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
  800276:	68 ec 40 80 00       	push   $0x8040ec
  80027b:	6a 6a                	push   $0x6a
  80027d:	68 1e 40 80 00       	push   $0x80401e
  800282:	e8 1b 07 00 00       	call   8009a2 <_panic>

			numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  800287:	a1 24 50 80 00       	mov    0x805024,%eax
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	50                   	push   %eax
  800290:	e8 9e 01 00 00       	call   800433 <CheckAndCountEmptyLocInWS>
  800295:	83 c4 10             	add    $0x10,%esp
  800298:	89 45 e0             	mov    %eax,-0x20(%ebp)
			int CurrFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  80029b:	e8 ab 1e 00 00       	call   80214b <sys_calculate_free_frames>
  8002a0:	89 c3                	mov    %eax,%ebx
  8002a2:	e8 bd 1e 00 00       	call   802164 <sys_calculate_modified_frames>
  8002a7:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  8002aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002ad:	29 c2                	sub    %eax,%edx
  8002af:	89 d0                	mov    %edx,%eax
  8002b1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
  8002b4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002b7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8002ba:	0f 84 05 01 00 00    	je     8003c5 <_main+0x38d>
  8002c0:	68 3c 41 80 00       	push   $0x80413c
  8002c5:	68 61 41 80 00       	push   $0x804161
  8002ca:	6a 6e                	push   $0x6e
  8002cc:	68 1e 40 80 00       	push   $0x80401e
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
  8002ee:	68 ec 40 80 00       	push   $0x8040ec
  8002f3:	6a 73                	push   $0x73
  8002f5:	68 1e 40 80 00       	push   $0x80401e
  8002fa:	e8 a3 06 00 00       	call   8009a2 <_panic>

			int numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  8002ff:	a1 24 50 80 00       	mov    0x805024,%eax
  800304:	83 ec 0c             	sub    $0xc,%esp
  800307:	50                   	push   %eax
  800308:	e8 26 01 00 00       	call   800433 <CheckAndCountEmptyLocInWS>
  80030d:	83 c4 10             	add    $0x10,%esp
  800310:	89 45 d0             	mov    %eax,-0x30(%ebp)
			int CurrFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  800313:	e8 33 1e 00 00       	call   80214b <sys_calculate_free_frames>
  800318:	89 c3                	mov    %eax,%ebx
  80031a:	e8 45 1e 00 00       	call   802164 <sys_calculate_modified_frames>
  80031f:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  800322:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800325:	29 c2                	sub    %eax,%edx
  800327:	89 d0                	mov    %edx,%eax
  800329:	89 45 cc             	mov    %eax,-0x34(%ebp)
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
  80032c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80032f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800332:	0f 84 8d 00 00 00    	je     8003c5 <_main+0x38d>
  800338:	68 3c 41 80 00       	push   $0x80413c
  80033d:	68 61 41 80 00       	push   $0x804161
  800342:	6a 77                	push   $0x77
  800344:	68 1e 40 80 00       	push   $0x80401e
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
  800366:	68 ec 40 80 00       	push   $0x8040ec
  80036b:	6a 7c                	push   $0x7c
  80036d:	68 1e 40 80 00       	push   $0x80401e
  800372:	e8 2b 06 00 00       	call   8009a2 <_panic>

			int numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  800377:	a1 24 50 80 00       	mov    0x805024,%eax
  80037c:	83 ec 0c             	sub    $0xc,%esp
  80037f:	50                   	push   %eax
  800380:	e8 ae 00 00 00       	call   800433 <CheckAndCountEmptyLocInWS>
  800385:	83 c4 10             	add    $0x10,%esp
  800388:	89 45 c8             	mov    %eax,-0x38(%ebp)
			int CurrFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  80038b:	e8 bb 1d 00 00       	call   80214b <sys_calculate_free_frames>
  800390:	89 c3                	mov    %eax,%ebx
  800392:	e8 cd 1d 00 00       	call   802164 <sys_calculate_modified_frames>
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
  8003ac:	68 3c 41 80 00       	push   $0x80413c
  8003b1:	68 61 41 80 00       	push   $0x804161
  8003b6:	68 81 00 00 00       	push   $0x81
  8003bb:	68 1e 40 80 00       	push   $0x80401e
  8003c0:	e8 dd 05 00 00       	call   8009a2 <_panic>
		}
		///========================================================================
	sys_disable_interrupt();
  8003c5:	e8 6e 1e 00 00       	call   802238 <sys_disable_interrupt>
		Chose = 0 ;
  8003ca:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
		while (Chose != 'y' && Chose != 'n')
  8003ce:	eb 42                	jmp    800412 <_main+0x3da>
		{
			cprintf("Do you want to repeat (y/n): ") ;
  8003d0:	83 ec 0c             	sub    $0xc,%esp
  8003d3:	68 76 41 80 00       	push   $0x804176
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
  80041e:	e8 2f 1e 00 00       	call   802252 <sys_enable_interrupt>

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
  8004a6:	68 94 41 80 00       	push   $0x804194
  8004ab:	68 a0 00 00 00       	push   $0xa0
  8004b0:	68 1e 40 80 00       	push   $0x80401e
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
  800766:	68 c2 41 80 00       	push   $0x8041c2
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
  800788:	68 c4 41 80 00       	push   $0x8041c4
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
  8007b6:	68 c9 41 80 00       	push   $0x8041c9
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
  8007da:	e8 8d 1a 00 00       	call   80226c <sys_cputc>
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
  8007eb:	e8 48 1a 00 00       	call   802238 <sys_disable_interrupt>
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
  8007fe:	e8 69 1a 00 00       	call   80226c <sys_cputc>
  800803:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800806:	e8 47 1a 00 00       	call   802252 <sys_enable_interrupt>
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
  80081d:	e8 91 18 00 00       	call   8020b3 <sys_cgetc>
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
  800836:	e8 fd 19 00 00       	call   802238 <sys_disable_interrupt>
	int c=0;
  80083b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800842:	eb 08                	jmp    80084c <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800844:	e8 6a 18 00 00       	call   8020b3 <sys_cgetc>
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
  800852:	e8 fb 19 00 00       	call   802252 <sys_enable_interrupt>
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
  80086c:	e8 ba 1b 00 00       	call   80242b <sys_getenvindex>
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
  8008d7:	e8 5c 19 00 00       	call   802238 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8008dc:	83 ec 0c             	sub    $0xc,%esp
  8008df:	68 e8 41 80 00       	push   $0x8041e8
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
  800907:	68 10 42 80 00       	push   $0x804210
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
  800938:	68 38 42 80 00       	push   $0x804238
  80093d:	e8 14 03 00 00       	call   800c56 <cprintf>
  800942:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800945:	a1 24 50 80 00       	mov    0x805024,%eax
  80094a:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800950:	83 ec 08             	sub    $0x8,%esp
  800953:	50                   	push   %eax
  800954:	68 90 42 80 00       	push   $0x804290
  800959:	e8 f8 02 00 00       	call   800c56 <cprintf>
  80095e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800961:	83 ec 0c             	sub    $0xc,%esp
  800964:	68 e8 41 80 00       	push   $0x8041e8
  800969:	e8 e8 02 00 00       	call   800c56 <cprintf>
  80096e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800971:	e8 dc 18 00 00       	call   802252 <sys_enable_interrupt>

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
  800989:	e8 69 1a 00 00       	call   8023f7 <sys_destroy_env>
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
  80099a:	e8 be 1a 00 00       	call   80245d <sys_exit_env>
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
  8009c3:	68 a4 42 80 00       	push   $0x8042a4
  8009c8:	e8 89 02 00 00       	call   800c56 <cprintf>
  8009cd:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8009d0:	a1 00 50 80 00       	mov    0x805000,%eax
  8009d5:	ff 75 0c             	pushl  0xc(%ebp)
  8009d8:	ff 75 08             	pushl  0x8(%ebp)
  8009db:	50                   	push   %eax
  8009dc:	68 a9 42 80 00       	push   $0x8042a9
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
  800a00:	68 c5 42 80 00       	push   $0x8042c5
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
  800a2c:	68 c8 42 80 00       	push   $0x8042c8
  800a31:	6a 26                	push   $0x26
  800a33:	68 14 43 80 00       	push   $0x804314
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
  800afe:	68 20 43 80 00       	push   $0x804320
  800b03:	6a 3a                	push   $0x3a
  800b05:	68 14 43 80 00       	push   $0x804314
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
  800b6e:	68 74 43 80 00       	push   $0x804374
  800b73:	6a 44                	push   $0x44
  800b75:	68 14 43 80 00       	push   $0x804314
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
  800bc8:	e8 bd 14 00 00       	call   80208a <sys_cputs>
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
  800c3f:	e8 46 14 00 00       	call   80208a <sys_cputs>
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
  800c89:	e8 aa 15 00 00       	call   802238 <sys_disable_interrupt>
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
  800ca9:	e8 a4 15 00 00       	call   802252 <sys_enable_interrupt>
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
  800cf3:	e8 18 30 00 00       	call   803d10 <__udivdi3>
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
  800d43:	e8 d8 30 00 00       	call   803e20 <__umoddi3>
  800d48:	83 c4 10             	add    $0x10,%esp
  800d4b:	05 d4 45 80 00       	add    $0x8045d4,%eax
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
  800e9e:	8b 04 85 f8 45 80 00 	mov    0x8045f8(,%eax,4),%eax
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
  800f7f:	8b 34 9d 40 44 80 00 	mov    0x804440(,%ebx,4),%esi
  800f86:	85 f6                	test   %esi,%esi
  800f88:	75 19                	jne    800fa3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800f8a:	53                   	push   %ebx
  800f8b:	68 e5 45 80 00       	push   $0x8045e5
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
  800fa4:	68 ee 45 80 00       	push   $0x8045ee
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
  800fd1:	be f1 45 80 00       	mov    $0x8045f1,%esi
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
  8012ea:	68 50 47 80 00       	push   $0x804750
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
  80132c:	68 53 47 80 00       	push   $0x804753
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
  8013dc:	e8 57 0e 00 00       	call   802238 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  8013e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013e5:	74 13                	je     8013fa <atomic_readline+0x24>
		cprintf("%s", prompt);
  8013e7:	83 ec 08             	sub    $0x8,%esp
  8013ea:	ff 75 08             	pushl  0x8(%ebp)
  8013ed:	68 50 47 80 00       	push   $0x804750
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
  80142b:	68 53 47 80 00       	push   $0x804753
  801430:	e8 21 f8 ff ff       	call   800c56 <cprintf>
  801435:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801438:	e8 15 0e 00 00       	call   802252 <sys_enable_interrupt>
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
  8014d0:	e8 7d 0d 00 00       	call   802252 <sys_enable_interrupt>
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
  801bfd:	68 64 47 80 00       	push   $0x804764
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
  801ccd:	e8 fc 04 00 00       	call   8021ce <sys_allocate_chunk>
  801cd2:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801cd5:	a1 20 51 80 00       	mov    0x805120,%eax
  801cda:	83 ec 0c             	sub    $0xc,%esp
  801cdd:	50                   	push   %eax
  801cde:	e8 71 0b 00 00       	call   802854 <initialize_MemBlocksList>
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
  801d0b:	68 89 47 80 00       	push   $0x804789
  801d10:	6a 33                	push   $0x33
  801d12:	68 a7 47 80 00       	push   $0x8047a7
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
  801d8a:	68 b4 47 80 00       	push   $0x8047b4
  801d8f:	6a 34                	push   $0x34
  801d91:	68 a7 47 80 00       	push   $0x8047a7
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
  801e22:	e8 75 07 00 00       	call   80259c <sys_isUHeapPlacementStrategyFIRSTFIT>
  801e27:	85 c0                	test   %eax,%eax
  801e29:	74 11                	je     801e3c <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801e2b:	83 ec 0c             	sub    $0xc,%esp
  801e2e:	ff 75 e8             	pushl  -0x18(%ebp)
  801e31:	e8 e0 0d 00 00       	call   802c16 <alloc_block_FF>
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
  801e48:	e8 3c 0b 00 00       	call   802989 <insert_sorted_allocList>
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
  801e62:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801e65:	83 ec 04             	sub    $0x4,%esp
  801e68:	68 d8 47 80 00       	push   $0x8047d8
  801e6d:	6a 6f                	push   $0x6f
  801e6f:	68 a7 47 80 00       	push   $0x8047a7
  801e74:	e8 29 eb ff ff       	call   8009a2 <_panic>

00801e79 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801e79:	55                   	push   %ebp
  801e7a:	89 e5                	mov    %esp,%ebp
  801e7c:	83 ec 38             	sub    $0x38,%esp
  801e7f:	8b 45 10             	mov    0x10(%ebp),%eax
  801e82:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e85:	e8 5c fd ff ff       	call   801be6 <InitializeUHeap>
	if (size == 0) return NULL ;
  801e8a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e8e:	75 0a                	jne    801e9a <smalloc+0x21>
  801e90:	b8 00 00 00 00       	mov    $0x0,%eax
  801e95:	e9 8b 00 00 00       	jmp    801f25 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801e9a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801ea1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ea4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ea7:	01 d0                	add    %edx,%eax
  801ea9:	48                   	dec    %eax
  801eaa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ead:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eb0:	ba 00 00 00 00       	mov    $0x0,%edx
  801eb5:	f7 75 f0             	divl   -0x10(%ebp)
  801eb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ebb:	29 d0                	sub    %edx,%eax
  801ebd:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801ec0:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801ec7:	e8 d0 06 00 00       	call   80259c <sys_isUHeapPlacementStrategyFIRSTFIT>
  801ecc:	85 c0                	test   %eax,%eax
  801ece:	74 11                	je     801ee1 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801ed0:	83 ec 0c             	sub    $0xc,%esp
  801ed3:	ff 75 e8             	pushl  -0x18(%ebp)
  801ed6:	e8 3b 0d 00 00       	call   802c16 <alloc_block_FF>
  801edb:	83 c4 10             	add    $0x10,%esp
  801ede:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  801ee1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ee5:	74 39                	je     801f20 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801ee7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eea:	8b 40 08             	mov    0x8(%eax),%eax
  801eed:	89 c2                	mov    %eax,%edx
  801eef:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801ef3:	52                   	push   %edx
  801ef4:	50                   	push   %eax
  801ef5:	ff 75 0c             	pushl  0xc(%ebp)
  801ef8:	ff 75 08             	pushl  0x8(%ebp)
  801efb:	e8 21 04 00 00       	call   802321 <sys_createSharedObject>
  801f00:	83 c4 10             	add    $0x10,%esp
  801f03:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801f06:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801f0a:	74 14                	je     801f20 <smalloc+0xa7>
  801f0c:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801f10:	74 0e                	je     801f20 <smalloc+0xa7>
  801f12:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801f16:	74 08                	je     801f20 <smalloc+0xa7>
			return (void*) mem_block->sva;
  801f18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f1b:	8b 40 08             	mov    0x8(%eax),%eax
  801f1e:	eb 05                	jmp    801f25 <smalloc+0xac>
	}
	return NULL;
  801f20:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801f25:	c9                   	leave  
  801f26:	c3                   	ret    

00801f27 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801f27:	55                   	push   %ebp
  801f28:	89 e5                	mov    %esp,%ebp
  801f2a:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f2d:	e8 b4 fc ff ff       	call   801be6 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801f32:	83 ec 08             	sub    $0x8,%esp
  801f35:	ff 75 0c             	pushl  0xc(%ebp)
  801f38:	ff 75 08             	pushl  0x8(%ebp)
  801f3b:	e8 0b 04 00 00       	call   80234b <sys_getSizeOfSharedObject>
  801f40:	83 c4 10             	add    $0x10,%esp
  801f43:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  801f46:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  801f4a:	74 76                	je     801fc2 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801f4c:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801f53:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f59:	01 d0                	add    %edx,%eax
  801f5b:	48                   	dec    %eax
  801f5c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801f5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f62:	ba 00 00 00 00       	mov    $0x0,%edx
  801f67:	f7 75 ec             	divl   -0x14(%ebp)
  801f6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f6d:	29 d0                	sub    %edx,%eax
  801f6f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801f72:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801f79:	e8 1e 06 00 00       	call   80259c <sys_isUHeapPlacementStrategyFIRSTFIT>
  801f7e:	85 c0                	test   %eax,%eax
  801f80:	74 11                	je     801f93 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801f82:	83 ec 0c             	sub    $0xc,%esp
  801f85:	ff 75 e4             	pushl  -0x1c(%ebp)
  801f88:	e8 89 0c 00 00       	call   802c16 <alloc_block_FF>
  801f8d:	83 c4 10             	add    $0x10,%esp
  801f90:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  801f93:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f97:	74 29                	je     801fc2 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801f99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9c:	8b 40 08             	mov    0x8(%eax),%eax
  801f9f:	83 ec 04             	sub    $0x4,%esp
  801fa2:	50                   	push   %eax
  801fa3:	ff 75 0c             	pushl  0xc(%ebp)
  801fa6:	ff 75 08             	pushl  0x8(%ebp)
  801fa9:	e8 ba 03 00 00       	call   802368 <sys_getSharedObject>
  801fae:	83 c4 10             	add    $0x10,%esp
  801fb1:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  801fb4:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  801fb8:	74 08                	je     801fc2 <sget+0x9b>
				return (void *)mem_block->sva;
  801fba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbd:	8b 40 08             	mov    0x8(%eax),%eax
  801fc0:	eb 05                	jmp    801fc7 <sget+0xa0>
		}
	}
	return (void *)NULL;
  801fc2:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801fc7:	c9                   	leave  
  801fc8:	c3                   	ret    

00801fc9 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801fc9:	55                   	push   %ebp
  801fca:	89 e5                	mov    %esp,%ebp
  801fcc:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801fcf:	e8 12 fc ff ff       	call   801be6 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801fd4:	83 ec 04             	sub    $0x4,%esp
  801fd7:	68 fc 47 80 00       	push   $0x8047fc
  801fdc:	68 f1 00 00 00       	push   $0xf1
  801fe1:	68 a7 47 80 00       	push   $0x8047a7
  801fe6:	e8 b7 e9 ff ff       	call   8009a2 <_panic>

00801feb <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801feb:	55                   	push   %ebp
  801fec:	89 e5                	mov    %esp,%ebp
  801fee:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801ff1:	83 ec 04             	sub    $0x4,%esp
  801ff4:	68 24 48 80 00       	push   $0x804824
  801ff9:	68 05 01 00 00       	push   $0x105
  801ffe:	68 a7 47 80 00       	push   $0x8047a7
  802003:	e8 9a e9 ff ff       	call   8009a2 <_panic>

00802008 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802008:	55                   	push   %ebp
  802009:	89 e5                	mov    %esp,%ebp
  80200b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80200e:	83 ec 04             	sub    $0x4,%esp
  802011:	68 48 48 80 00       	push   $0x804848
  802016:	68 10 01 00 00       	push   $0x110
  80201b:	68 a7 47 80 00       	push   $0x8047a7
  802020:	e8 7d e9 ff ff       	call   8009a2 <_panic>

00802025 <shrink>:

}
void shrink(uint32 newSize)
{
  802025:	55                   	push   %ebp
  802026:	89 e5                	mov    %esp,%ebp
  802028:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80202b:	83 ec 04             	sub    $0x4,%esp
  80202e:	68 48 48 80 00       	push   $0x804848
  802033:	68 15 01 00 00       	push   $0x115
  802038:	68 a7 47 80 00       	push   $0x8047a7
  80203d:	e8 60 e9 ff ff       	call   8009a2 <_panic>

00802042 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802042:	55                   	push   %ebp
  802043:	89 e5                	mov    %esp,%ebp
  802045:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802048:	83 ec 04             	sub    $0x4,%esp
  80204b:	68 48 48 80 00       	push   $0x804848
  802050:	68 1a 01 00 00       	push   $0x11a
  802055:	68 a7 47 80 00       	push   $0x8047a7
  80205a:	e8 43 e9 ff ff       	call   8009a2 <_panic>

0080205f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80205f:	55                   	push   %ebp
  802060:	89 e5                	mov    %esp,%ebp
  802062:	57                   	push   %edi
  802063:	56                   	push   %esi
  802064:	53                   	push   %ebx
  802065:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802068:	8b 45 08             	mov    0x8(%ebp),%eax
  80206b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80206e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802071:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802074:	8b 7d 18             	mov    0x18(%ebp),%edi
  802077:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80207a:	cd 30                	int    $0x30
  80207c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80207f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802082:	83 c4 10             	add    $0x10,%esp
  802085:	5b                   	pop    %ebx
  802086:	5e                   	pop    %esi
  802087:	5f                   	pop    %edi
  802088:	5d                   	pop    %ebp
  802089:	c3                   	ret    

0080208a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80208a:	55                   	push   %ebp
  80208b:	89 e5                	mov    %esp,%ebp
  80208d:	83 ec 04             	sub    $0x4,%esp
  802090:	8b 45 10             	mov    0x10(%ebp),%eax
  802093:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802096:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80209a:	8b 45 08             	mov    0x8(%ebp),%eax
  80209d:	6a 00                	push   $0x0
  80209f:	6a 00                	push   $0x0
  8020a1:	52                   	push   %edx
  8020a2:	ff 75 0c             	pushl  0xc(%ebp)
  8020a5:	50                   	push   %eax
  8020a6:	6a 00                	push   $0x0
  8020a8:	e8 b2 ff ff ff       	call   80205f <syscall>
  8020ad:	83 c4 18             	add    $0x18,%esp
}
  8020b0:	90                   	nop
  8020b1:	c9                   	leave  
  8020b2:	c3                   	ret    

008020b3 <sys_cgetc>:

int
sys_cgetc(void)
{
  8020b3:	55                   	push   %ebp
  8020b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8020b6:	6a 00                	push   $0x0
  8020b8:	6a 00                	push   $0x0
  8020ba:	6a 00                	push   $0x0
  8020bc:	6a 00                	push   $0x0
  8020be:	6a 00                	push   $0x0
  8020c0:	6a 01                	push   $0x1
  8020c2:	e8 98 ff ff ff       	call   80205f <syscall>
  8020c7:	83 c4 18             	add    $0x18,%esp
}
  8020ca:	c9                   	leave  
  8020cb:	c3                   	ret    

008020cc <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8020cc:	55                   	push   %ebp
  8020cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8020cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d5:	6a 00                	push   $0x0
  8020d7:	6a 00                	push   $0x0
  8020d9:	6a 00                	push   $0x0
  8020db:	52                   	push   %edx
  8020dc:	50                   	push   %eax
  8020dd:	6a 05                	push   $0x5
  8020df:	e8 7b ff ff ff       	call   80205f <syscall>
  8020e4:	83 c4 18             	add    $0x18,%esp
}
  8020e7:	c9                   	leave  
  8020e8:	c3                   	ret    

008020e9 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8020e9:	55                   	push   %ebp
  8020ea:	89 e5                	mov    %esp,%ebp
  8020ec:	56                   	push   %esi
  8020ed:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8020ee:	8b 75 18             	mov    0x18(%ebp),%esi
  8020f1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020f4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fd:	56                   	push   %esi
  8020fe:	53                   	push   %ebx
  8020ff:	51                   	push   %ecx
  802100:	52                   	push   %edx
  802101:	50                   	push   %eax
  802102:	6a 06                	push   $0x6
  802104:	e8 56 ff ff ff       	call   80205f <syscall>
  802109:	83 c4 18             	add    $0x18,%esp
}
  80210c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80210f:	5b                   	pop    %ebx
  802110:	5e                   	pop    %esi
  802111:	5d                   	pop    %ebp
  802112:	c3                   	ret    

00802113 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802113:	55                   	push   %ebp
  802114:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802116:	8b 55 0c             	mov    0xc(%ebp),%edx
  802119:	8b 45 08             	mov    0x8(%ebp),%eax
  80211c:	6a 00                	push   $0x0
  80211e:	6a 00                	push   $0x0
  802120:	6a 00                	push   $0x0
  802122:	52                   	push   %edx
  802123:	50                   	push   %eax
  802124:	6a 07                	push   $0x7
  802126:	e8 34 ff ff ff       	call   80205f <syscall>
  80212b:	83 c4 18             	add    $0x18,%esp
}
  80212e:	c9                   	leave  
  80212f:	c3                   	ret    

00802130 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802130:	55                   	push   %ebp
  802131:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802133:	6a 00                	push   $0x0
  802135:	6a 00                	push   $0x0
  802137:	6a 00                	push   $0x0
  802139:	ff 75 0c             	pushl  0xc(%ebp)
  80213c:	ff 75 08             	pushl  0x8(%ebp)
  80213f:	6a 08                	push   $0x8
  802141:	e8 19 ff ff ff       	call   80205f <syscall>
  802146:	83 c4 18             	add    $0x18,%esp
}
  802149:	c9                   	leave  
  80214a:	c3                   	ret    

0080214b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80214b:	55                   	push   %ebp
  80214c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80214e:	6a 00                	push   $0x0
  802150:	6a 00                	push   $0x0
  802152:	6a 00                	push   $0x0
  802154:	6a 00                	push   $0x0
  802156:	6a 00                	push   $0x0
  802158:	6a 09                	push   $0x9
  80215a:	e8 00 ff ff ff       	call   80205f <syscall>
  80215f:	83 c4 18             	add    $0x18,%esp
}
  802162:	c9                   	leave  
  802163:	c3                   	ret    

00802164 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802164:	55                   	push   %ebp
  802165:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802167:	6a 00                	push   $0x0
  802169:	6a 00                	push   $0x0
  80216b:	6a 00                	push   $0x0
  80216d:	6a 00                	push   $0x0
  80216f:	6a 00                	push   $0x0
  802171:	6a 0a                	push   $0xa
  802173:	e8 e7 fe ff ff       	call   80205f <syscall>
  802178:	83 c4 18             	add    $0x18,%esp
}
  80217b:	c9                   	leave  
  80217c:	c3                   	ret    

0080217d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80217d:	55                   	push   %ebp
  80217e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802180:	6a 00                	push   $0x0
  802182:	6a 00                	push   $0x0
  802184:	6a 00                	push   $0x0
  802186:	6a 00                	push   $0x0
  802188:	6a 00                	push   $0x0
  80218a:	6a 0b                	push   $0xb
  80218c:	e8 ce fe ff ff       	call   80205f <syscall>
  802191:	83 c4 18             	add    $0x18,%esp
}
  802194:	c9                   	leave  
  802195:	c3                   	ret    

00802196 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802196:	55                   	push   %ebp
  802197:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802199:	6a 00                	push   $0x0
  80219b:	6a 00                	push   $0x0
  80219d:	6a 00                	push   $0x0
  80219f:	ff 75 0c             	pushl  0xc(%ebp)
  8021a2:	ff 75 08             	pushl  0x8(%ebp)
  8021a5:	6a 0f                	push   $0xf
  8021a7:	e8 b3 fe ff ff       	call   80205f <syscall>
  8021ac:	83 c4 18             	add    $0x18,%esp
	return;
  8021af:	90                   	nop
}
  8021b0:	c9                   	leave  
  8021b1:	c3                   	ret    

008021b2 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8021b2:	55                   	push   %ebp
  8021b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8021b5:	6a 00                	push   $0x0
  8021b7:	6a 00                	push   $0x0
  8021b9:	6a 00                	push   $0x0
  8021bb:	ff 75 0c             	pushl  0xc(%ebp)
  8021be:	ff 75 08             	pushl  0x8(%ebp)
  8021c1:	6a 10                	push   $0x10
  8021c3:	e8 97 fe ff ff       	call   80205f <syscall>
  8021c8:	83 c4 18             	add    $0x18,%esp
	return ;
  8021cb:	90                   	nop
}
  8021cc:	c9                   	leave  
  8021cd:	c3                   	ret    

008021ce <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8021ce:	55                   	push   %ebp
  8021cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8021d1:	6a 00                	push   $0x0
  8021d3:	6a 00                	push   $0x0
  8021d5:	ff 75 10             	pushl  0x10(%ebp)
  8021d8:	ff 75 0c             	pushl  0xc(%ebp)
  8021db:	ff 75 08             	pushl  0x8(%ebp)
  8021de:	6a 11                	push   $0x11
  8021e0:	e8 7a fe ff ff       	call   80205f <syscall>
  8021e5:	83 c4 18             	add    $0x18,%esp
	return ;
  8021e8:	90                   	nop
}
  8021e9:	c9                   	leave  
  8021ea:	c3                   	ret    

008021eb <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8021eb:	55                   	push   %ebp
  8021ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8021ee:	6a 00                	push   $0x0
  8021f0:	6a 00                	push   $0x0
  8021f2:	6a 00                	push   $0x0
  8021f4:	6a 00                	push   $0x0
  8021f6:	6a 00                	push   $0x0
  8021f8:	6a 0c                	push   $0xc
  8021fa:	e8 60 fe ff ff       	call   80205f <syscall>
  8021ff:	83 c4 18             	add    $0x18,%esp
}
  802202:	c9                   	leave  
  802203:	c3                   	ret    

00802204 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802204:	55                   	push   %ebp
  802205:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802207:	6a 00                	push   $0x0
  802209:	6a 00                	push   $0x0
  80220b:	6a 00                	push   $0x0
  80220d:	6a 00                	push   $0x0
  80220f:	ff 75 08             	pushl  0x8(%ebp)
  802212:	6a 0d                	push   $0xd
  802214:	e8 46 fe ff ff       	call   80205f <syscall>
  802219:	83 c4 18             	add    $0x18,%esp
}
  80221c:	c9                   	leave  
  80221d:	c3                   	ret    

0080221e <sys_scarce_memory>:

void sys_scarce_memory()
{
  80221e:	55                   	push   %ebp
  80221f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802221:	6a 00                	push   $0x0
  802223:	6a 00                	push   $0x0
  802225:	6a 00                	push   $0x0
  802227:	6a 00                	push   $0x0
  802229:	6a 00                	push   $0x0
  80222b:	6a 0e                	push   $0xe
  80222d:	e8 2d fe ff ff       	call   80205f <syscall>
  802232:	83 c4 18             	add    $0x18,%esp
}
  802235:	90                   	nop
  802236:	c9                   	leave  
  802237:	c3                   	ret    

00802238 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802238:	55                   	push   %ebp
  802239:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80223b:	6a 00                	push   $0x0
  80223d:	6a 00                	push   $0x0
  80223f:	6a 00                	push   $0x0
  802241:	6a 00                	push   $0x0
  802243:	6a 00                	push   $0x0
  802245:	6a 13                	push   $0x13
  802247:	e8 13 fe ff ff       	call   80205f <syscall>
  80224c:	83 c4 18             	add    $0x18,%esp
}
  80224f:	90                   	nop
  802250:	c9                   	leave  
  802251:	c3                   	ret    

00802252 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802252:	55                   	push   %ebp
  802253:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802255:	6a 00                	push   $0x0
  802257:	6a 00                	push   $0x0
  802259:	6a 00                	push   $0x0
  80225b:	6a 00                	push   $0x0
  80225d:	6a 00                	push   $0x0
  80225f:	6a 14                	push   $0x14
  802261:	e8 f9 fd ff ff       	call   80205f <syscall>
  802266:	83 c4 18             	add    $0x18,%esp
}
  802269:	90                   	nop
  80226a:	c9                   	leave  
  80226b:	c3                   	ret    

0080226c <sys_cputc>:


void
sys_cputc(const char c)
{
  80226c:	55                   	push   %ebp
  80226d:	89 e5                	mov    %esp,%ebp
  80226f:	83 ec 04             	sub    $0x4,%esp
  802272:	8b 45 08             	mov    0x8(%ebp),%eax
  802275:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802278:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80227c:	6a 00                	push   $0x0
  80227e:	6a 00                	push   $0x0
  802280:	6a 00                	push   $0x0
  802282:	6a 00                	push   $0x0
  802284:	50                   	push   %eax
  802285:	6a 15                	push   $0x15
  802287:	e8 d3 fd ff ff       	call   80205f <syscall>
  80228c:	83 c4 18             	add    $0x18,%esp
}
  80228f:	90                   	nop
  802290:	c9                   	leave  
  802291:	c3                   	ret    

00802292 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802292:	55                   	push   %ebp
  802293:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802295:	6a 00                	push   $0x0
  802297:	6a 00                	push   $0x0
  802299:	6a 00                	push   $0x0
  80229b:	6a 00                	push   $0x0
  80229d:	6a 00                	push   $0x0
  80229f:	6a 16                	push   $0x16
  8022a1:	e8 b9 fd ff ff       	call   80205f <syscall>
  8022a6:	83 c4 18             	add    $0x18,%esp
}
  8022a9:	90                   	nop
  8022aa:	c9                   	leave  
  8022ab:	c3                   	ret    

008022ac <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8022ac:	55                   	push   %ebp
  8022ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8022af:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b2:	6a 00                	push   $0x0
  8022b4:	6a 00                	push   $0x0
  8022b6:	6a 00                	push   $0x0
  8022b8:	ff 75 0c             	pushl  0xc(%ebp)
  8022bb:	50                   	push   %eax
  8022bc:	6a 17                	push   $0x17
  8022be:	e8 9c fd ff ff       	call   80205f <syscall>
  8022c3:	83 c4 18             	add    $0x18,%esp
}
  8022c6:	c9                   	leave  
  8022c7:	c3                   	ret    

008022c8 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8022c8:	55                   	push   %ebp
  8022c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d1:	6a 00                	push   $0x0
  8022d3:	6a 00                	push   $0x0
  8022d5:	6a 00                	push   $0x0
  8022d7:	52                   	push   %edx
  8022d8:	50                   	push   %eax
  8022d9:	6a 1a                	push   $0x1a
  8022db:	e8 7f fd ff ff       	call   80205f <syscall>
  8022e0:	83 c4 18             	add    $0x18,%esp
}
  8022e3:	c9                   	leave  
  8022e4:	c3                   	ret    

008022e5 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8022e5:	55                   	push   %ebp
  8022e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ee:	6a 00                	push   $0x0
  8022f0:	6a 00                	push   $0x0
  8022f2:	6a 00                	push   $0x0
  8022f4:	52                   	push   %edx
  8022f5:	50                   	push   %eax
  8022f6:	6a 18                	push   $0x18
  8022f8:	e8 62 fd ff ff       	call   80205f <syscall>
  8022fd:	83 c4 18             	add    $0x18,%esp
}
  802300:	90                   	nop
  802301:	c9                   	leave  
  802302:	c3                   	ret    

00802303 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802303:	55                   	push   %ebp
  802304:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802306:	8b 55 0c             	mov    0xc(%ebp),%edx
  802309:	8b 45 08             	mov    0x8(%ebp),%eax
  80230c:	6a 00                	push   $0x0
  80230e:	6a 00                	push   $0x0
  802310:	6a 00                	push   $0x0
  802312:	52                   	push   %edx
  802313:	50                   	push   %eax
  802314:	6a 19                	push   $0x19
  802316:	e8 44 fd ff ff       	call   80205f <syscall>
  80231b:	83 c4 18             	add    $0x18,%esp
}
  80231e:	90                   	nop
  80231f:	c9                   	leave  
  802320:	c3                   	ret    

00802321 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802321:	55                   	push   %ebp
  802322:	89 e5                	mov    %esp,%ebp
  802324:	83 ec 04             	sub    $0x4,%esp
  802327:	8b 45 10             	mov    0x10(%ebp),%eax
  80232a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80232d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802330:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802334:	8b 45 08             	mov    0x8(%ebp),%eax
  802337:	6a 00                	push   $0x0
  802339:	51                   	push   %ecx
  80233a:	52                   	push   %edx
  80233b:	ff 75 0c             	pushl  0xc(%ebp)
  80233e:	50                   	push   %eax
  80233f:	6a 1b                	push   $0x1b
  802341:	e8 19 fd ff ff       	call   80205f <syscall>
  802346:	83 c4 18             	add    $0x18,%esp
}
  802349:	c9                   	leave  
  80234a:	c3                   	ret    

0080234b <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80234b:	55                   	push   %ebp
  80234c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80234e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802351:	8b 45 08             	mov    0x8(%ebp),%eax
  802354:	6a 00                	push   $0x0
  802356:	6a 00                	push   $0x0
  802358:	6a 00                	push   $0x0
  80235a:	52                   	push   %edx
  80235b:	50                   	push   %eax
  80235c:	6a 1c                	push   $0x1c
  80235e:	e8 fc fc ff ff       	call   80205f <syscall>
  802363:	83 c4 18             	add    $0x18,%esp
}
  802366:	c9                   	leave  
  802367:	c3                   	ret    

00802368 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802368:	55                   	push   %ebp
  802369:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80236b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80236e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802371:	8b 45 08             	mov    0x8(%ebp),%eax
  802374:	6a 00                	push   $0x0
  802376:	6a 00                	push   $0x0
  802378:	51                   	push   %ecx
  802379:	52                   	push   %edx
  80237a:	50                   	push   %eax
  80237b:	6a 1d                	push   $0x1d
  80237d:	e8 dd fc ff ff       	call   80205f <syscall>
  802382:	83 c4 18             	add    $0x18,%esp
}
  802385:	c9                   	leave  
  802386:	c3                   	ret    

00802387 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802387:	55                   	push   %ebp
  802388:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80238a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80238d:	8b 45 08             	mov    0x8(%ebp),%eax
  802390:	6a 00                	push   $0x0
  802392:	6a 00                	push   $0x0
  802394:	6a 00                	push   $0x0
  802396:	52                   	push   %edx
  802397:	50                   	push   %eax
  802398:	6a 1e                	push   $0x1e
  80239a:	e8 c0 fc ff ff       	call   80205f <syscall>
  80239f:	83 c4 18             	add    $0x18,%esp
}
  8023a2:	c9                   	leave  
  8023a3:	c3                   	ret    

008023a4 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8023a4:	55                   	push   %ebp
  8023a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8023a7:	6a 00                	push   $0x0
  8023a9:	6a 00                	push   $0x0
  8023ab:	6a 00                	push   $0x0
  8023ad:	6a 00                	push   $0x0
  8023af:	6a 00                	push   $0x0
  8023b1:	6a 1f                	push   $0x1f
  8023b3:	e8 a7 fc ff ff       	call   80205f <syscall>
  8023b8:	83 c4 18             	add    $0x18,%esp
}
  8023bb:	c9                   	leave  
  8023bc:	c3                   	ret    

008023bd <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8023bd:	55                   	push   %ebp
  8023be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8023c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c3:	6a 00                	push   $0x0
  8023c5:	ff 75 14             	pushl  0x14(%ebp)
  8023c8:	ff 75 10             	pushl  0x10(%ebp)
  8023cb:	ff 75 0c             	pushl  0xc(%ebp)
  8023ce:	50                   	push   %eax
  8023cf:	6a 20                	push   $0x20
  8023d1:	e8 89 fc ff ff       	call   80205f <syscall>
  8023d6:	83 c4 18             	add    $0x18,%esp
}
  8023d9:	c9                   	leave  
  8023da:	c3                   	ret    

008023db <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8023db:	55                   	push   %ebp
  8023dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8023de:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e1:	6a 00                	push   $0x0
  8023e3:	6a 00                	push   $0x0
  8023e5:	6a 00                	push   $0x0
  8023e7:	6a 00                	push   $0x0
  8023e9:	50                   	push   %eax
  8023ea:	6a 21                	push   $0x21
  8023ec:	e8 6e fc ff ff       	call   80205f <syscall>
  8023f1:	83 c4 18             	add    $0x18,%esp
}
  8023f4:	90                   	nop
  8023f5:	c9                   	leave  
  8023f6:	c3                   	ret    

008023f7 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8023f7:	55                   	push   %ebp
  8023f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8023fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fd:	6a 00                	push   $0x0
  8023ff:	6a 00                	push   $0x0
  802401:	6a 00                	push   $0x0
  802403:	6a 00                	push   $0x0
  802405:	50                   	push   %eax
  802406:	6a 22                	push   $0x22
  802408:	e8 52 fc ff ff       	call   80205f <syscall>
  80240d:	83 c4 18             	add    $0x18,%esp
}
  802410:	c9                   	leave  
  802411:	c3                   	ret    

00802412 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802412:	55                   	push   %ebp
  802413:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802415:	6a 00                	push   $0x0
  802417:	6a 00                	push   $0x0
  802419:	6a 00                	push   $0x0
  80241b:	6a 00                	push   $0x0
  80241d:	6a 00                	push   $0x0
  80241f:	6a 02                	push   $0x2
  802421:	e8 39 fc ff ff       	call   80205f <syscall>
  802426:	83 c4 18             	add    $0x18,%esp
}
  802429:	c9                   	leave  
  80242a:	c3                   	ret    

0080242b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80242b:	55                   	push   %ebp
  80242c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80242e:	6a 00                	push   $0x0
  802430:	6a 00                	push   $0x0
  802432:	6a 00                	push   $0x0
  802434:	6a 00                	push   $0x0
  802436:	6a 00                	push   $0x0
  802438:	6a 03                	push   $0x3
  80243a:	e8 20 fc ff ff       	call   80205f <syscall>
  80243f:	83 c4 18             	add    $0x18,%esp
}
  802442:	c9                   	leave  
  802443:	c3                   	ret    

00802444 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802444:	55                   	push   %ebp
  802445:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802447:	6a 00                	push   $0x0
  802449:	6a 00                	push   $0x0
  80244b:	6a 00                	push   $0x0
  80244d:	6a 00                	push   $0x0
  80244f:	6a 00                	push   $0x0
  802451:	6a 04                	push   $0x4
  802453:	e8 07 fc ff ff       	call   80205f <syscall>
  802458:	83 c4 18             	add    $0x18,%esp
}
  80245b:	c9                   	leave  
  80245c:	c3                   	ret    

0080245d <sys_exit_env>:


void sys_exit_env(void)
{
  80245d:	55                   	push   %ebp
  80245e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802460:	6a 00                	push   $0x0
  802462:	6a 00                	push   $0x0
  802464:	6a 00                	push   $0x0
  802466:	6a 00                	push   $0x0
  802468:	6a 00                	push   $0x0
  80246a:	6a 23                	push   $0x23
  80246c:	e8 ee fb ff ff       	call   80205f <syscall>
  802471:	83 c4 18             	add    $0x18,%esp
}
  802474:	90                   	nop
  802475:	c9                   	leave  
  802476:	c3                   	ret    

00802477 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802477:	55                   	push   %ebp
  802478:	89 e5                	mov    %esp,%ebp
  80247a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80247d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802480:	8d 50 04             	lea    0x4(%eax),%edx
  802483:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802486:	6a 00                	push   $0x0
  802488:	6a 00                	push   $0x0
  80248a:	6a 00                	push   $0x0
  80248c:	52                   	push   %edx
  80248d:	50                   	push   %eax
  80248e:	6a 24                	push   $0x24
  802490:	e8 ca fb ff ff       	call   80205f <syscall>
  802495:	83 c4 18             	add    $0x18,%esp
	return result;
  802498:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80249b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80249e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024a1:	89 01                	mov    %eax,(%ecx)
  8024a3:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8024a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a9:	c9                   	leave  
  8024aa:	c2 04 00             	ret    $0x4

008024ad <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8024ad:	55                   	push   %ebp
  8024ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8024b0:	6a 00                	push   $0x0
  8024b2:	6a 00                	push   $0x0
  8024b4:	ff 75 10             	pushl  0x10(%ebp)
  8024b7:	ff 75 0c             	pushl  0xc(%ebp)
  8024ba:	ff 75 08             	pushl  0x8(%ebp)
  8024bd:	6a 12                	push   $0x12
  8024bf:	e8 9b fb ff ff       	call   80205f <syscall>
  8024c4:	83 c4 18             	add    $0x18,%esp
	return ;
  8024c7:	90                   	nop
}
  8024c8:	c9                   	leave  
  8024c9:	c3                   	ret    

008024ca <sys_rcr2>:
uint32 sys_rcr2()
{
  8024ca:	55                   	push   %ebp
  8024cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8024cd:	6a 00                	push   $0x0
  8024cf:	6a 00                	push   $0x0
  8024d1:	6a 00                	push   $0x0
  8024d3:	6a 00                	push   $0x0
  8024d5:	6a 00                	push   $0x0
  8024d7:	6a 25                	push   $0x25
  8024d9:	e8 81 fb ff ff       	call   80205f <syscall>
  8024de:	83 c4 18             	add    $0x18,%esp
}
  8024e1:	c9                   	leave  
  8024e2:	c3                   	ret    

008024e3 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8024e3:	55                   	push   %ebp
  8024e4:	89 e5                	mov    %esp,%ebp
  8024e6:	83 ec 04             	sub    $0x4,%esp
  8024e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ec:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8024ef:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8024f3:	6a 00                	push   $0x0
  8024f5:	6a 00                	push   $0x0
  8024f7:	6a 00                	push   $0x0
  8024f9:	6a 00                	push   $0x0
  8024fb:	50                   	push   %eax
  8024fc:	6a 26                	push   $0x26
  8024fe:	e8 5c fb ff ff       	call   80205f <syscall>
  802503:	83 c4 18             	add    $0x18,%esp
	return ;
  802506:	90                   	nop
}
  802507:	c9                   	leave  
  802508:	c3                   	ret    

00802509 <rsttst>:
void rsttst()
{
  802509:	55                   	push   %ebp
  80250a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80250c:	6a 00                	push   $0x0
  80250e:	6a 00                	push   $0x0
  802510:	6a 00                	push   $0x0
  802512:	6a 00                	push   $0x0
  802514:	6a 00                	push   $0x0
  802516:	6a 28                	push   $0x28
  802518:	e8 42 fb ff ff       	call   80205f <syscall>
  80251d:	83 c4 18             	add    $0x18,%esp
	return ;
  802520:	90                   	nop
}
  802521:	c9                   	leave  
  802522:	c3                   	ret    

00802523 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802523:	55                   	push   %ebp
  802524:	89 e5                	mov    %esp,%ebp
  802526:	83 ec 04             	sub    $0x4,%esp
  802529:	8b 45 14             	mov    0x14(%ebp),%eax
  80252c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80252f:	8b 55 18             	mov    0x18(%ebp),%edx
  802532:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802536:	52                   	push   %edx
  802537:	50                   	push   %eax
  802538:	ff 75 10             	pushl  0x10(%ebp)
  80253b:	ff 75 0c             	pushl  0xc(%ebp)
  80253e:	ff 75 08             	pushl  0x8(%ebp)
  802541:	6a 27                	push   $0x27
  802543:	e8 17 fb ff ff       	call   80205f <syscall>
  802548:	83 c4 18             	add    $0x18,%esp
	return ;
  80254b:	90                   	nop
}
  80254c:	c9                   	leave  
  80254d:	c3                   	ret    

0080254e <chktst>:
void chktst(uint32 n)
{
  80254e:	55                   	push   %ebp
  80254f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802551:	6a 00                	push   $0x0
  802553:	6a 00                	push   $0x0
  802555:	6a 00                	push   $0x0
  802557:	6a 00                	push   $0x0
  802559:	ff 75 08             	pushl  0x8(%ebp)
  80255c:	6a 29                	push   $0x29
  80255e:	e8 fc fa ff ff       	call   80205f <syscall>
  802563:	83 c4 18             	add    $0x18,%esp
	return ;
  802566:	90                   	nop
}
  802567:	c9                   	leave  
  802568:	c3                   	ret    

00802569 <inctst>:

void inctst()
{
  802569:	55                   	push   %ebp
  80256a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80256c:	6a 00                	push   $0x0
  80256e:	6a 00                	push   $0x0
  802570:	6a 00                	push   $0x0
  802572:	6a 00                	push   $0x0
  802574:	6a 00                	push   $0x0
  802576:	6a 2a                	push   $0x2a
  802578:	e8 e2 fa ff ff       	call   80205f <syscall>
  80257d:	83 c4 18             	add    $0x18,%esp
	return ;
  802580:	90                   	nop
}
  802581:	c9                   	leave  
  802582:	c3                   	ret    

00802583 <gettst>:
uint32 gettst()
{
  802583:	55                   	push   %ebp
  802584:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802586:	6a 00                	push   $0x0
  802588:	6a 00                	push   $0x0
  80258a:	6a 00                	push   $0x0
  80258c:	6a 00                	push   $0x0
  80258e:	6a 00                	push   $0x0
  802590:	6a 2b                	push   $0x2b
  802592:	e8 c8 fa ff ff       	call   80205f <syscall>
  802597:	83 c4 18             	add    $0x18,%esp
}
  80259a:	c9                   	leave  
  80259b:	c3                   	ret    

0080259c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80259c:	55                   	push   %ebp
  80259d:	89 e5                	mov    %esp,%ebp
  80259f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025a2:	6a 00                	push   $0x0
  8025a4:	6a 00                	push   $0x0
  8025a6:	6a 00                	push   $0x0
  8025a8:	6a 00                	push   $0x0
  8025aa:	6a 00                	push   $0x0
  8025ac:	6a 2c                	push   $0x2c
  8025ae:	e8 ac fa ff ff       	call   80205f <syscall>
  8025b3:	83 c4 18             	add    $0x18,%esp
  8025b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8025b9:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8025bd:	75 07                	jne    8025c6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8025bf:	b8 01 00 00 00       	mov    $0x1,%eax
  8025c4:	eb 05                	jmp    8025cb <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8025c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025cb:	c9                   	leave  
  8025cc:	c3                   	ret    

008025cd <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8025cd:	55                   	push   %ebp
  8025ce:	89 e5                	mov    %esp,%ebp
  8025d0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025d3:	6a 00                	push   $0x0
  8025d5:	6a 00                	push   $0x0
  8025d7:	6a 00                	push   $0x0
  8025d9:	6a 00                	push   $0x0
  8025db:	6a 00                	push   $0x0
  8025dd:	6a 2c                	push   $0x2c
  8025df:	e8 7b fa ff ff       	call   80205f <syscall>
  8025e4:	83 c4 18             	add    $0x18,%esp
  8025e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8025ea:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8025ee:	75 07                	jne    8025f7 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8025f0:	b8 01 00 00 00       	mov    $0x1,%eax
  8025f5:	eb 05                	jmp    8025fc <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8025f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025fc:	c9                   	leave  
  8025fd:	c3                   	ret    

008025fe <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8025fe:	55                   	push   %ebp
  8025ff:	89 e5                	mov    %esp,%ebp
  802601:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802604:	6a 00                	push   $0x0
  802606:	6a 00                	push   $0x0
  802608:	6a 00                	push   $0x0
  80260a:	6a 00                	push   $0x0
  80260c:	6a 00                	push   $0x0
  80260e:	6a 2c                	push   $0x2c
  802610:	e8 4a fa ff ff       	call   80205f <syscall>
  802615:	83 c4 18             	add    $0x18,%esp
  802618:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80261b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80261f:	75 07                	jne    802628 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802621:	b8 01 00 00 00       	mov    $0x1,%eax
  802626:	eb 05                	jmp    80262d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802628:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80262d:	c9                   	leave  
  80262e:	c3                   	ret    

0080262f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80262f:	55                   	push   %ebp
  802630:	89 e5                	mov    %esp,%ebp
  802632:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802635:	6a 00                	push   $0x0
  802637:	6a 00                	push   $0x0
  802639:	6a 00                	push   $0x0
  80263b:	6a 00                	push   $0x0
  80263d:	6a 00                	push   $0x0
  80263f:	6a 2c                	push   $0x2c
  802641:	e8 19 fa ff ff       	call   80205f <syscall>
  802646:	83 c4 18             	add    $0x18,%esp
  802649:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80264c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802650:	75 07                	jne    802659 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802652:	b8 01 00 00 00       	mov    $0x1,%eax
  802657:	eb 05                	jmp    80265e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802659:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80265e:	c9                   	leave  
  80265f:	c3                   	ret    

00802660 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802660:	55                   	push   %ebp
  802661:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802663:	6a 00                	push   $0x0
  802665:	6a 00                	push   $0x0
  802667:	6a 00                	push   $0x0
  802669:	6a 00                	push   $0x0
  80266b:	ff 75 08             	pushl  0x8(%ebp)
  80266e:	6a 2d                	push   $0x2d
  802670:	e8 ea f9 ff ff       	call   80205f <syscall>
  802675:	83 c4 18             	add    $0x18,%esp
	return ;
  802678:	90                   	nop
}
  802679:	c9                   	leave  
  80267a:	c3                   	ret    

0080267b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80267b:	55                   	push   %ebp
  80267c:	89 e5                	mov    %esp,%ebp
  80267e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80267f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802682:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802685:	8b 55 0c             	mov    0xc(%ebp),%edx
  802688:	8b 45 08             	mov    0x8(%ebp),%eax
  80268b:	6a 00                	push   $0x0
  80268d:	53                   	push   %ebx
  80268e:	51                   	push   %ecx
  80268f:	52                   	push   %edx
  802690:	50                   	push   %eax
  802691:	6a 2e                	push   $0x2e
  802693:	e8 c7 f9 ff ff       	call   80205f <syscall>
  802698:	83 c4 18             	add    $0x18,%esp
}
  80269b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80269e:	c9                   	leave  
  80269f:	c3                   	ret    

008026a0 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8026a0:	55                   	push   %ebp
  8026a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8026a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a9:	6a 00                	push   $0x0
  8026ab:	6a 00                	push   $0x0
  8026ad:	6a 00                	push   $0x0
  8026af:	52                   	push   %edx
  8026b0:	50                   	push   %eax
  8026b1:	6a 2f                	push   $0x2f
  8026b3:	e8 a7 f9 ff ff       	call   80205f <syscall>
  8026b8:	83 c4 18             	add    $0x18,%esp
}
  8026bb:	c9                   	leave  
  8026bc:	c3                   	ret    

008026bd <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8026bd:	55                   	push   %ebp
  8026be:	89 e5                	mov    %esp,%ebp
  8026c0:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8026c3:	83 ec 0c             	sub    $0xc,%esp
  8026c6:	68 58 48 80 00       	push   $0x804858
  8026cb:	e8 86 e5 ff ff       	call   800c56 <cprintf>
  8026d0:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8026d3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8026da:	83 ec 0c             	sub    $0xc,%esp
  8026dd:	68 84 48 80 00       	push   $0x804884
  8026e2:	e8 6f e5 ff ff       	call   800c56 <cprintf>
  8026e7:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8026ea:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8026ee:	a1 38 51 80 00       	mov    0x805138,%eax
  8026f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026f6:	eb 56                	jmp    80274e <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8026f8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026fc:	74 1c                	je     80271a <print_mem_block_lists+0x5d>
  8026fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802701:	8b 50 08             	mov    0x8(%eax),%edx
  802704:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802707:	8b 48 08             	mov    0x8(%eax),%ecx
  80270a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80270d:	8b 40 0c             	mov    0xc(%eax),%eax
  802710:	01 c8                	add    %ecx,%eax
  802712:	39 c2                	cmp    %eax,%edx
  802714:	73 04                	jae    80271a <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802716:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80271a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271d:	8b 50 08             	mov    0x8(%eax),%edx
  802720:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802723:	8b 40 0c             	mov    0xc(%eax),%eax
  802726:	01 c2                	add    %eax,%edx
  802728:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272b:	8b 40 08             	mov    0x8(%eax),%eax
  80272e:	83 ec 04             	sub    $0x4,%esp
  802731:	52                   	push   %edx
  802732:	50                   	push   %eax
  802733:	68 99 48 80 00       	push   $0x804899
  802738:	e8 19 e5 ff ff       	call   800c56 <cprintf>
  80273d:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802740:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802743:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802746:	a1 40 51 80 00       	mov    0x805140,%eax
  80274b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80274e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802752:	74 07                	je     80275b <print_mem_block_lists+0x9e>
  802754:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802757:	8b 00                	mov    (%eax),%eax
  802759:	eb 05                	jmp    802760 <print_mem_block_lists+0xa3>
  80275b:	b8 00 00 00 00       	mov    $0x0,%eax
  802760:	a3 40 51 80 00       	mov    %eax,0x805140
  802765:	a1 40 51 80 00       	mov    0x805140,%eax
  80276a:	85 c0                	test   %eax,%eax
  80276c:	75 8a                	jne    8026f8 <print_mem_block_lists+0x3b>
  80276e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802772:	75 84                	jne    8026f8 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802774:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802778:	75 10                	jne    80278a <print_mem_block_lists+0xcd>
  80277a:	83 ec 0c             	sub    $0xc,%esp
  80277d:	68 a8 48 80 00       	push   $0x8048a8
  802782:	e8 cf e4 ff ff       	call   800c56 <cprintf>
  802787:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80278a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802791:	83 ec 0c             	sub    $0xc,%esp
  802794:	68 cc 48 80 00       	push   $0x8048cc
  802799:	e8 b8 e4 ff ff       	call   800c56 <cprintf>
  80279e:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8027a1:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8027a5:	a1 40 50 80 00       	mov    0x805040,%eax
  8027aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027ad:	eb 56                	jmp    802805 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8027af:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027b3:	74 1c                	je     8027d1 <print_mem_block_lists+0x114>
  8027b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b8:	8b 50 08             	mov    0x8(%eax),%edx
  8027bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027be:	8b 48 08             	mov    0x8(%eax),%ecx
  8027c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8027c7:	01 c8                	add    %ecx,%eax
  8027c9:	39 c2                	cmp    %eax,%edx
  8027cb:	73 04                	jae    8027d1 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8027cd:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8027d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d4:	8b 50 08             	mov    0x8(%eax),%edx
  8027d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027da:	8b 40 0c             	mov    0xc(%eax),%eax
  8027dd:	01 c2                	add    %eax,%edx
  8027df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e2:	8b 40 08             	mov    0x8(%eax),%eax
  8027e5:	83 ec 04             	sub    $0x4,%esp
  8027e8:	52                   	push   %edx
  8027e9:	50                   	push   %eax
  8027ea:	68 99 48 80 00       	push   $0x804899
  8027ef:	e8 62 e4 ff ff       	call   800c56 <cprintf>
  8027f4:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8027f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8027fd:	a1 48 50 80 00       	mov    0x805048,%eax
  802802:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802805:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802809:	74 07                	je     802812 <print_mem_block_lists+0x155>
  80280b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280e:	8b 00                	mov    (%eax),%eax
  802810:	eb 05                	jmp    802817 <print_mem_block_lists+0x15a>
  802812:	b8 00 00 00 00       	mov    $0x0,%eax
  802817:	a3 48 50 80 00       	mov    %eax,0x805048
  80281c:	a1 48 50 80 00       	mov    0x805048,%eax
  802821:	85 c0                	test   %eax,%eax
  802823:	75 8a                	jne    8027af <print_mem_block_lists+0xf2>
  802825:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802829:	75 84                	jne    8027af <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80282b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80282f:	75 10                	jne    802841 <print_mem_block_lists+0x184>
  802831:	83 ec 0c             	sub    $0xc,%esp
  802834:	68 e4 48 80 00       	push   $0x8048e4
  802839:	e8 18 e4 ff ff       	call   800c56 <cprintf>
  80283e:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802841:	83 ec 0c             	sub    $0xc,%esp
  802844:	68 58 48 80 00       	push   $0x804858
  802849:	e8 08 e4 ff ff       	call   800c56 <cprintf>
  80284e:	83 c4 10             	add    $0x10,%esp

}
  802851:	90                   	nop
  802852:	c9                   	leave  
  802853:	c3                   	ret    

00802854 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802854:	55                   	push   %ebp
  802855:	89 e5                	mov    %esp,%ebp
  802857:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  80285a:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802861:	00 00 00 
  802864:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80286b:	00 00 00 
  80286e:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802875:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802878:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80287f:	e9 9e 00 00 00       	jmp    802922 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802884:	a1 50 50 80 00       	mov    0x805050,%eax
  802889:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80288c:	c1 e2 04             	shl    $0x4,%edx
  80288f:	01 d0                	add    %edx,%eax
  802891:	85 c0                	test   %eax,%eax
  802893:	75 14                	jne    8028a9 <initialize_MemBlocksList+0x55>
  802895:	83 ec 04             	sub    $0x4,%esp
  802898:	68 0c 49 80 00       	push   $0x80490c
  80289d:	6a 46                	push   $0x46
  80289f:	68 2f 49 80 00       	push   $0x80492f
  8028a4:	e8 f9 e0 ff ff       	call   8009a2 <_panic>
  8028a9:	a1 50 50 80 00       	mov    0x805050,%eax
  8028ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028b1:	c1 e2 04             	shl    $0x4,%edx
  8028b4:	01 d0                	add    %edx,%eax
  8028b6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8028bc:	89 10                	mov    %edx,(%eax)
  8028be:	8b 00                	mov    (%eax),%eax
  8028c0:	85 c0                	test   %eax,%eax
  8028c2:	74 18                	je     8028dc <initialize_MemBlocksList+0x88>
  8028c4:	a1 48 51 80 00       	mov    0x805148,%eax
  8028c9:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8028cf:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8028d2:	c1 e1 04             	shl    $0x4,%ecx
  8028d5:	01 ca                	add    %ecx,%edx
  8028d7:	89 50 04             	mov    %edx,0x4(%eax)
  8028da:	eb 12                	jmp    8028ee <initialize_MemBlocksList+0x9a>
  8028dc:	a1 50 50 80 00       	mov    0x805050,%eax
  8028e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028e4:	c1 e2 04             	shl    $0x4,%edx
  8028e7:	01 d0                	add    %edx,%eax
  8028e9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028ee:	a1 50 50 80 00       	mov    0x805050,%eax
  8028f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028f6:	c1 e2 04             	shl    $0x4,%edx
  8028f9:	01 d0                	add    %edx,%eax
  8028fb:	a3 48 51 80 00       	mov    %eax,0x805148
  802900:	a1 50 50 80 00       	mov    0x805050,%eax
  802905:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802908:	c1 e2 04             	shl    $0x4,%edx
  80290b:	01 d0                	add    %edx,%eax
  80290d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802914:	a1 54 51 80 00       	mov    0x805154,%eax
  802919:	40                   	inc    %eax
  80291a:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  80291f:	ff 45 f4             	incl   -0xc(%ebp)
  802922:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802925:	3b 45 08             	cmp    0x8(%ebp),%eax
  802928:	0f 82 56 ff ff ff    	jb     802884 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  80292e:	90                   	nop
  80292f:	c9                   	leave  
  802930:	c3                   	ret    

00802931 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802931:	55                   	push   %ebp
  802932:	89 e5                	mov    %esp,%ebp
  802934:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802937:	8b 45 08             	mov    0x8(%ebp),%eax
  80293a:	8b 00                	mov    (%eax),%eax
  80293c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80293f:	eb 19                	jmp    80295a <find_block+0x29>
	{
		if(va==point->sva)
  802941:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802944:	8b 40 08             	mov    0x8(%eax),%eax
  802947:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80294a:	75 05                	jne    802951 <find_block+0x20>
		   return point;
  80294c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80294f:	eb 36                	jmp    802987 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802951:	8b 45 08             	mov    0x8(%ebp),%eax
  802954:	8b 40 08             	mov    0x8(%eax),%eax
  802957:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80295a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80295e:	74 07                	je     802967 <find_block+0x36>
  802960:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802963:	8b 00                	mov    (%eax),%eax
  802965:	eb 05                	jmp    80296c <find_block+0x3b>
  802967:	b8 00 00 00 00       	mov    $0x0,%eax
  80296c:	8b 55 08             	mov    0x8(%ebp),%edx
  80296f:	89 42 08             	mov    %eax,0x8(%edx)
  802972:	8b 45 08             	mov    0x8(%ebp),%eax
  802975:	8b 40 08             	mov    0x8(%eax),%eax
  802978:	85 c0                	test   %eax,%eax
  80297a:	75 c5                	jne    802941 <find_block+0x10>
  80297c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802980:	75 bf                	jne    802941 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802982:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802987:	c9                   	leave  
  802988:	c3                   	ret    

00802989 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802989:	55                   	push   %ebp
  80298a:	89 e5                	mov    %esp,%ebp
  80298c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80298f:	a1 40 50 80 00       	mov    0x805040,%eax
  802994:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802997:	a1 44 50 80 00       	mov    0x805044,%eax
  80299c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80299f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8029a5:	74 24                	je     8029cb <insert_sorted_allocList+0x42>
  8029a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029aa:	8b 50 08             	mov    0x8(%eax),%edx
  8029ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b0:	8b 40 08             	mov    0x8(%eax),%eax
  8029b3:	39 c2                	cmp    %eax,%edx
  8029b5:	76 14                	jbe    8029cb <insert_sorted_allocList+0x42>
  8029b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ba:	8b 50 08             	mov    0x8(%eax),%edx
  8029bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029c0:	8b 40 08             	mov    0x8(%eax),%eax
  8029c3:	39 c2                	cmp    %eax,%edx
  8029c5:	0f 82 60 01 00 00    	jb     802b2b <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8029cb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029cf:	75 65                	jne    802a36 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8029d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029d5:	75 14                	jne    8029eb <insert_sorted_allocList+0x62>
  8029d7:	83 ec 04             	sub    $0x4,%esp
  8029da:	68 0c 49 80 00       	push   $0x80490c
  8029df:	6a 6b                	push   $0x6b
  8029e1:	68 2f 49 80 00       	push   $0x80492f
  8029e6:	e8 b7 df ff ff       	call   8009a2 <_panic>
  8029eb:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8029f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f4:	89 10                	mov    %edx,(%eax)
  8029f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f9:	8b 00                	mov    (%eax),%eax
  8029fb:	85 c0                	test   %eax,%eax
  8029fd:	74 0d                	je     802a0c <insert_sorted_allocList+0x83>
  8029ff:	a1 40 50 80 00       	mov    0x805040,%eax
  802a04:	8b 55 08             	mov    0x8(%ebp),%edx
  802a07:	89 50 04             	mov    %edx,0x4(%eax)
  802a0a:	eb 08                	jmp    802a14 <insert_sorted_allocList+0x8b>
  802a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0f:	a3 44 50 80 00       	mov    %eax,0x805044
  802a14:	8b 45 08             	mov    0x8(%ebp),%eax
  802a17:	a3 40 50 80 00       	mov    %eax,0x805040
  802a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a26:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a2b:	40                   	inc    %eax
  802a2c:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802a31:	e9 dc 01 00 00       	jmp    802c12 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802a36:	8b 45 08             	mov    0x8(%ebp),%eax
  802a39:	8b 50 08             	mov    0x8(%eax),%edx
  802a3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a3f:	8b 40 08             	mov    0x8(%eax),%eax
  802a42:	39 c2                	cmp    %eax,%edx
  802a44:	77 6c                	ja     802ab2 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802a46:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a4a:	74 06                	je     802a52 <insert_sorted_allocList+0xc9>
  802a4c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a50:	75 14                	jne    802a66 <insert_sorted_allocList+0xdd>
  802a52:	83 ec 04             	sub    $0x4,%esp
  802a55:	68 48 49 80 00       	push   $0x804948
  802a5a:	6a 6f                	push   $0x6f
  802a5c:	68 2f 49 80 00       	push   $0x80492f
  802a61:	e8 3c df ff ff       	call   8009a2 <_panic>
  802a66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a69:	8b 50 04             	mov    0x4(%eax),%edx
  802a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6f:	89 50 04             	mov    %edx,0x4(%eax)
  802a72:	8b 45 08             	mov    0x8(%ebp),%eax
  802a75:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a78:	89 10                	mov    %edx,(%eax)
  802a7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a7d:	8b 40 04             	mov    0x4(%eax),%eax
  802a80:	85 c0                	test   %eax,%eax
  802a82:	74 0d                	je     802a91 <insert_sorted_allocList+0x108>
  802a84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a87:	8b 40 04             	mov    0x4(%eax),%eax
  802a8a:	8b 55 08             	mov    0x8(%ebp),%edx
  802a8d:	89 10                	mov    %edx,(%eax)
  802a8f:	eb 08                	jmp    802a99 <insert_sorted_allocList+0x110>
  802a91:	8b 45 08             	mov    0x8(%ebp),%eax
  802a94:	a3 40 50 80 00       	mov    %eax,0x805040
  802a99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a9c:	8b 55 08             	mov    0x8(%ebp),%edx
  802a9f:	89 50 04             	mov    %edx,0x4(%eax)
  802aa2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802aa7:	40                   	inc    %eax
  802aa8:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802aad:	e9 60 01 00 00       	jmp    802c12 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab5:	8b 50 08             	mov    0x8(%eax),%edx
  802ab8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802abb:	8b 40 08             	mov    0x8(%eax),%eax
  802abe:	39 c2                	cmp    %eax,%edx
  802ac0:	0f 82 4c 01 00 00    	jb     802c12 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802ac6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802aca:	75 14                	jne    802ae0 <insert_sorted_allocList+0x157>
  802acc:	83 ec 04             	sub    $0x4,%esp
  802acf:	68 80 49 80 00       	push   $0x804980
  802ad4:	6a 73                	push   $0x73
  802ad6:	68 2f 49 80 00       	push   $0x80492f
  802adb:	e8 c2 de ff ff       	call   8009a2 <_panic>
  802ae0:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae9:	89 50 04             	mov    %edx,0x4(%eax)
  802aec:	8b 45 08             	mov    0x8(%ebp),%eax
  802aef:	8b 40 04             	mov    0x4(%eax),%eax
  802af2:	85 c0                	test   %eax,%eax
  802af4:	74 0c                	je     802b02 <insert_sorted_allocList+0x179>
  802af6:	a1 44 50 80 00       	mov    0x805044,%eax
  802afb:	8b 55 08             	mov    0x8(%ebp),%edx
  802afe:	89 10                	mov    %edx,(%eax)
  802b00:	eb 08                	jmp    802b0a <insert_sorted_allocList+0x181>
  802b02:	8b 45 08             	mov    0x8(%ebp),%eax
  802b05:	a3 40 50 80 00       	mov    %eax,0x805040
  802b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0d:	a3 44 50 80 00       	mov    %eax,0x805044
  802b12:	8b 45 08             	mov    0x8(%ebp),%eax
  802b15:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b1b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b20:	40                   	inc    %eax
  802b21:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802b26:	e9 e7 00 00 00       	jmp    802c12 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802b2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802b31:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802b38:	a1 40 50 80 00       	mov    0x805040,%eax
  802b3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b40:	e9 9d 00 00 00       	jmp    802be2 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b48:	8b 00                	mov    (%eax),%eax
  802b4a:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b50:	8b 50 08             	mov    0x8(%eax),%edx
  802b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b56:	8b 40 08             	mov    0x8(%eax),%eax
  802b59:	39 c2                	cmp    %eax,%edx
  802b5b:	76 7d                	jbe    802bda <insert_sorted_allocList+0x251>
  802b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b60:	8b 50 08             	mov    0x8(%eax),%edx
  802b63:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b66:	8b 40 08             	mov    0x8(%eax),%eax
  802b69:	39 c2                	cmp    %eax,%edx
  802b6b:	73 6d                	jae    802bda <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802b6d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b71:	74 06                	je     802b79 <insert_sorted_allocList+0x1f0>
  802b73:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b77:	75 14                	jne    802b8d <insert_sorted_allocList+0x204>
  802b79:	83 ec 04             	sub    $0x4,%esp
  802b7c:	68 a4 49 80 00       	push   $0x8049a4
  802b81:	6a 7f                	push   $0x7f
  802b83:	68 2f 49 80 00       	push   $0x80492f
  802b88:	e8 15 de ff ff       	call   8009a2 <_panic>
  802b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b90:	8b 10                	mov    (%eax),%edx
  802b92:	8b 45 08             	mov    0x8(%ebp),%eax
  802b95:	89 10                	mov    %edx,(%eax)
  802b97:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9a:	8b 00                	mov    (%eax),%eax
  802b9c:	85 c0                	test   %eax,%eax
  802b9e:	74 0b                	je     802bab <insert_sorted_allocList+0x222>
  802ba0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba3:	8b 00                	mov    (%eax),%eax
  802ba5:	8b 55 08             	mov    0x8(%ebp),%edx
  802ba8:	89 50 04             	mov    %edx,0x4(%eax)
  802bab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bae:	8b 55 08             	mov    0x8(%ebp),%edx
  802bb1:	89 10                	mov    %edx,(%eax)
  802bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bb9:	89 50 04             	mov    %edx,0x4(%eax)
  802bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbf:	8b 00                	mov    (%eax),%eax
  802bc1:	85 c0                	test   %eax,%eax
  802bc3:	75 08                	jne    802bcd <insert_sorted_allocList+0x244>
  802bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc8:	a3 44 50 80 00       	mov    %eax,0x805044
  802bcd:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802bd2:	40                   	inc    %eax
  802bd3:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802bd8:	eb 39                	jmp    802c13 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802bda:	a1 48 50 80 00       	mov    0x805048,%eax
  802bdf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802be2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802be6:	74 07                	je     802bef <insert_sorted_allocList+0x266>
  802be8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802beb:	8b 00                	mov    (%eax),%eax
  802bed:	eb 05                	jmp    802bf4 <insert_sorted_allocList+0x26b>
  802bef:	b8 00 00 00 00       	mov    $0x0,%eax
  802bf4:	a3 48 50 80 00       	mov    %eax,0x805048
  802bf9:	a1 48 50 80 00       	mov    0x805048,%eax
  802bfe:	85 c0                	test   %eax,%eax
  802c00:	0f 85 3f ff ff ff    	jne    802b45 <insert_sorted_allocList+0x1bc>
  802c06:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c0a:	0f 85 35 ff ff ff    	jne    802b45 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802c10:	eb 01                	jmp    802c13 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802c12:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802c13:	90                   	nop
  802c14:	c9                   	leave  
  802c15:	c3                   	ret    

00802c16 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802c16:	55                   	push   %ebp
  802c17:	89 e5                	mov    %esp,%ebp
  802c19:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802c1c:	a1 38 51 80 00       	mov    0x805138,%eax
  802c21:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c24:	e9 85 01 00 00       	jmp    802dae <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802c29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2c:	8b 40 0c             	mov    0xc(%eax),%eax
  802c2f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c32:	0f 82 6e 01 00 00    	jb     802da6 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802c38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3b:	8b 40 0c             	mov    0xc(%eax),%eax
  802c3e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c41:	0f 85 8a 00 00 00    	jne    802cd1 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802c47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c4b:	75 17                	jne    802c64 <alloc_block_FF+0x4e>
  802c4d:	83 ec 04             	sub    $0x4,%esp
  802c50:	68 d8 49 80 00       	push   $0x8049d8
  802c55:	68 93 00 00 00       	push   $0x93
  802c5a:	68 2f 49 80 00       	push   $0x80492f
  802c5f:	e8 3e dd ff ff       	call   8009a2 <_panic>
  802c64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c67:	8b 00                	mov    (%eax),%eax
  802c69:	85 c0                	test   %eax,%eax
  802c6b:	74 10                	je     802c7d <alloc_block_FF+0x67>
  802c6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c70:	8b 00                	mov    (%eax),%eax
  802c72:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c75:	8b 52 04             	mov    0x4(%edx),%edx
  802c78:	89 50 04             	mov    %edx,0x4(%eax)
  802c7b:	eb 0b                	jmp    802c88 <alloc_block_FF+0x72>
  802c7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c80:	8b 40 04             	mov    0x4(%eax),%eax
  802c83:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8b:	8b 40 04             	mov    0x4(%eax),%eax
  802c8e:	85 c0                	test   %eax,%eax
  802c90:	74 0f                	je     802ca1 <alloc_block_FF+0x8b>
  802c92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c95:	8b 40 04             	mov    0x4(%eax),%eax
  802c98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c9b:	8b 12                	mov    (%edx),%edx
  802c9d:	89 10                	mov    %edx,(%eax)
  802c9f:	eb 0a                	jmp    802cab <alloc_block_FF+0x95>
  802ca1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca4:	8b 00                	mov    (%eax),%eax
  802ca6:	a3 38 51 80 00       	mov    %eax,0x805138
  802cab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cbe:	a1 44 51 80 00       	mov    0x805144,%eax
  802cc3:	48                   	dec    %eax
  802cc4:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802cc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccc:	e9 10 01 00 00       	jmp    802de1 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802cd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd4:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd7:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cda:	0f 86 c6 00 00 00    	jbe    802da6 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802ce0:	a1 48 51 80 00       	mov    0x805148,%eax
  802ce5:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802ce8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ceb:	8b 50 08             	mov    0x8(%eax),%edx
  802cee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf1:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802cf4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf7:	8b 55 08             	mov    0x8(%ebp),%edx
  802cfa:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802cfd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d01:	75 17                	jne    802d1a <alloc_block_FF+0x104>
  802d03:	83 ec 04             	sub    $0x4,%esp
  802d06:	68 d8 49 80 00       	push   $0x8049d8
  802d0b:	68 9b 00 00 00       	push   $0x9b
  802d10:	68 2f 49 80 00       	push   $0x80492f
  802d15:	e8 88 dc ff ff       	call   8009a2 <_panic>
  802d1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1d:	8b 00                	mov    (%eax),%eax
  802d1f:	85 c0                	test   %eax,%eax
  802d21:	74 10                	je     802d33 <alloc_block_FF+0x11d>
  802d23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d26:	8b 00                	mov    (%eax),%eax
  802d28:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d2b:	8b 52 04             	mov    0x4(%edx),%edx
  802d2e:	89 50 04             	mov    %edx,0x4(%eax)
  802d31:	eb 0b                	jmp    802d3e <alloc_block_FF+0x128>
  802d33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d36:	8b 40 04             	mov    0x4(%eax),%eax
  802d39:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d41:	8b 40 04             	mov    0x4(%eax),%eax
  802d44:	85 c0                	test   %eax,%eax
  802d46:	74 0f                	je     802d57 <alloc_block_FF+0x141>
  802d48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4b:	8b 40 04             	mov    0x4(%eax),%eax
  802d4e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d51:	8b 12                	mov    (%edx),%edx
  802d53:	89 10                	mov    %edx,(%eax)
  802d55:	eb 0a                	jmp    802d61 <alloc_block_FF+0x14b>
  802d57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d5a:	8b 00                	mov    (%eax),%eax
  802d5c:	a3 48 51 80 00       	mov    %eax,0x805148
  802d61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d64:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d6d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d74:	a1 54 51 80 00       	mov    0x805154,%eax
  802d79:	48                   	dec    %eax
  802d7a:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d82:	8b 50 08             	mov    0x8(%eax),%edx
  802d85:	8b 45 08             	mov    0x8(%ebp),%eax
  802d88:	01 c2                	add    %eax,%edx
  802d8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8d:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802d90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d93:	8b 40 0c             	mov    0xc(%eax),%eax
  802d96:	2b 45 08             	sub    0x8(%ebp),%eax
  802d99:	89 c2                	mov    %eax,%edx
  802d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9e:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802da1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da4:	eb 3b                	jmp    802de1 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802da6:	a1 40 51 80 00       	mov    0x805140,%eax
  802dab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802db2:	74 07                	je     802dbb <alloc_block_FF+0x1a5>
  802db4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db7:	8b 00                	mov    (%eax),%eax
  802db9:	eb 05                	jmp    802dc0 <alloc_block_FF+0x1aa>
  802dbb:	b8 00 00 00 00       	mov    $0x0,%eax
  802dc0:	a3 40 51 80 00       	mov    %eax,0x805140
  802dc5:	a1 40 51 80 00       	mov    0x805140,%eax
  802dca:	85 c0                	test   %eax,%eax
  802dcc:	0f 85 57 fe ff ff    	jne    802c29 <alloc_block_FF+0x13>
  802dd2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dd6:	0f 85 4d fe ff ff    	jne    802c29 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802ddc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802de1:	c9                   	leave  
  802de2:	c3                   	ret    

00802de3 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802de3:	55                   	push   %ebp
  802de4:	89 e5                	mov    %esp,%ebp
  802de6:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802de9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802df0:	a1 38 51 80 00       	mov    0x805138,%eax
  802df5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802df8:	e9 df 00 00 00       	jmp    802edc <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802dfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e00:	8b 40 0c             	mov    0xc(%eax),%eax
  802e03:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e06:	0f 82 c8 00 00 00    	jb     802ed4 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802e0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0f:	8b 40 0c             	mov    0xc(%eax),%eax
  802e12:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e15:	0f 85 8a 00 00 00    	jne    802ea5 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802e1b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e1f:	75 17                	jne    802e38 <alloc_block_BF+0x55>
  802e21:	83 ec 04             	sub    $0x4,%esp
  802e24:	68 d8 49 80 00       	push   $0x8049d8
  802e29:	68 b7 00 00 00       	push   $0xb7
  802e2e:	68 2f 49 80 00       	push   $0x80492f
  802e33:	e8 6a db ff ff       	call   8009a2 <_panic>
  802e38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3b:	8b 00                	mov    (%eax),%eax
  802e3d:	85 c0                	test   %eax,%eax
  802e3f:	74 10                	je     802e51 <alloc_block_BF+0x6e>
  802e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e44:	8b 00                	mov    (%eax),%eax
  802e46:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e49:	8b 52 04             	mov    0x4(%edx),%edx
  802e4c:	89 50 04             	mov    %edx,0x4(%eax)
  802e4f:	eb 0b                	jmp    802e5c <alloc_block_BF+0x79>
  802e51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e54:	8b 40 04             	mov    0x4(%eax),%eax
  802e57:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5f:	8b 40 04             	mov    0x4(%eax),%eax
  802e62:	85 c0                	test   %eax,%eax
  802e64:	74 0f                	je     802e75 <alloc_block_BF+0x92>
  802e66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e69:	8b 40 04             	mov    0x4(%eax),%eax
  802e6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e6f:	8b 12                	mov    (%edx),%edx
  802e71:	89 10                	mov    %edx,(%eax)
  802e73:	eb 0a                	jmp    802e7f <alloc_block_BF+0x9c>
  802e75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e78:	8b 00                	mov    (%eax),%eax
  802e7a:	a3 38 51 80 00       	mov    %eax,0x805138
  802e7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e82:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e92:	a1 44 51 80 00       	mov    0x805144,%eax
  802e97:	48                   	dec    %eax
  802e98:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802e9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea0:	e9 4d 01 00 00       	jmp    802ff2 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802ea5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea8:	8b 40 0c             	mov    0xc(%eax),%eax
  802eab:	3b 45 08             	cmp    0x8(%ebp),%eax
  802eae:	76 24                	jbe    802ed4 <alloc_block_BF+0xf1>
  802eb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb3:	8b 40 0c             	mov    0xc(%eax),%eax
  802eb6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802eb9:	73 19                	jae    802ed4 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802ebb:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec8:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802ecb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ece:	8b 40 08             	mov    0x8(%eax),%eax
  802ed1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802ed4:	a1 40 51 80 00       	mov    0x805140,%eax
  802ed9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802edc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ee0:	74 07                	je     802ee9 <alloc_block_BF+0x106>
  802ee2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee5:	8b 00                	mov    (%eax),%eax
  802ee7:	eb 05                	jmp    802eee <alloc_block_BF+0x10b>
  802ee9:	b8 00 00 00 00       	mov    $0x0,%eax
  802eee:	a3 40 51 80 00       	mov    %eax,0x805140
  802ef3:	a1 40 51 80 00       	mov    0x805140,%eax
  802ef8:	85 c0                	test   %eax,%eax
  802efa:	0f 85 fd fe ff ff    	jne    802dfd <alloc_block_BF+0x1a>
  802f00:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f04:	0f 85 f3 fe ff ff    	jne    802dfd <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802f0a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f0e:	0f 84 d9 00 00 00    	je     802fed <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802f14:	a1 48 51 80 00       	mov    0x805148,%eax
  802f19:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802f1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f1f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f22:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802f25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f28:	8b 55 08             	mov    0x8(%ebp),%edx
  802f2b:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802f2e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802f32:	75 17                	jne    802f4b <alloc_block_BF+0x168>
  802f34:	83 ec 04             	sub    $0x4,%esp
  802f37:	68 d8 49 80 00       	push   $0x8049d8
  802f3c:	68 c7 00 00 00       	push   $0xc7
  802f41:	68 2f 49 80 00       	push   $0x80492f
  802f46:	e8 57 da ff ff       	call   8009a2 <_panic>
  802f4b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f4e:	8b 00                	mov    (%eax),%eax
  802f50:	85 c0                	test   %eax,%eax
  802f52:	74 10                	je     802f64 <alloc_block_BF+0x181>
  802f54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f57:	8b 00                	mov    (%eax),%eax
  802f59:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f5c:	8b 52 04             	mov    0x4(%edx),%edx
  802f5f:	89 50 04             	mov    %edx,0x4(%eax)
  802f62:	eb 0b                	jmp    802f6f <alloc_block_BF+0x18c>
  802f64:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f67:	8b 40 04             	mov    0x4(%eax),%eax
  802f6a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f72:	8b 40 04             	mov    0x4(%eax),%eax
  802f75:	85 c0                	test   %eax,%eax
  802f77:	74 0f                	je     802f88 <alloc_block_BF+0x1a5>
  802f79:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f7c:	8b 40 04             	mov    0x4(%eax),%eax
  802f7f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f82:	8b 12                	mov    (%edx),%edx
  802f84:	89 10                	mov    %edx,(%eax)
  802f86:	eb 0a                	jmp    802f92 <alloc_block_BF+0x1af>
  802f88:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f8b:	8b 00                	mov    (%eax),%eax
  802f8d:	a3 48 51 80 00       	mov    %eax,0x805148
  802f92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f95:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f9b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f9e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fa5:	a1 54 51 80 00       	mov    0x805154,%eax
  802faa:	48                   	dec    %eax
  802fab:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802fb0:	83 ec 08             	sub    $0x8,%esp
  802fb3:	ff 75 ec             	pushl  -0x14(%ebp)
  802fb6:	68 38 51 80 00       	push   $0x805138
  802fbb:	e8 71 f9 ff ff       	call   802931 <find_block>
  802fc0:	83 c4 10             	add    $0x10,%esp
  802fc3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802fc6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fc9:	8b 50 08             	mov    0x8(%eax),%edx
  802fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcf:	01 c2                	add    %eax,%edx
  802fd1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fd4:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802fd7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fda:	8b 40 0c             	mov    0xc(%eax),%eax
  802fdd:	2b 45 08             	sub    0x8(%ebp),%eax
  802fe0:	89 c2                	mov    %eax,%edx
  802fe2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fe5:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802fe8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802feb:	eb 05                	jmp    802ff2 <alloc_block_BF+0x20f>
	}
	return NULL;
  802fed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ff2:	c9                   	leave  
  802ff3:	c3                   	ret    

00802ff4 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802ff4:	55                   	push   %ebp
  802ff5:	89 e5                	mov    %esp,%ebp
  802ff7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802ffa:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802fff:	85 c0                	test   %eax,%eax
  803001:	0f 85 de 01 00 00    	jne    8031e5 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  803007:	a1 38 51 80 00       	mov    0x805138,%eax
  80300c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80300f:	e9 9e 01 00 00       	jmp    8031b2 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  803014:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803017:	8b 40 0c             	mov    0xc(%eax),%eax
  80301a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80301d:	0f 82 87 01 00 00    	jb     8031aa <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  803023:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803026:	8b 40 0c             	mov    0xc(%eax),%eax
  803029:	3b 45 08             	cmp    0x8(%ebp),%eax
  80302c:	0f 85 95 00 00 00    	jne    8030c7 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  803032:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803036:	75 17                	jne    80304f <alloc_block_NF+0x5b>
  803038:	83 ec 04             	sub    $0x4,%esp
  80303b:	68 d8 49 80 00       	push   $0x8049d8
  803040:	68 e0 00 00 00       	push   $0xe0
  803045:	68 2f 49 80 00       	push   $0x80492f
  80304a:	e8 53 d9 ff ff       	call   8009a2 <_panic>
  80304f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803052:	8b 00                	mov    (%eax),%eax
  803054:	85 c0                	test   %eax,%eax
  803056:	74 10                	je     803068 <alloc_block_NF+0x74>
  803058:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305b:	8b 00                	mov    (%eax),%eax
  80305d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803060:	8b 52 04             	mov    0x4(%edx),%edx
  803063:	89 50 04             	mov    %edx,0x4(%eax)
  803066:	eb 0b                	jmp    803073 <alloc_block_NF+0x7f>
  803068:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306b:	8b 40 04             	mov    0x4(%eax),%eax
  80306e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803073:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803076:	8b 40 04             	mov    0x4(%eax),%eax
  803079:	85 c0                	test   %eax,%eax
  80307b:	74 0f                	je     80308c <alloc_block_NF+0x98>
  80307d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803080:	8b 40 04             	mov    0x4(%eax),%eax
  803083:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803086:	8b 12                	mov    (%edx),%edx
  803088:	89 10                	mov    %edx,(%eax)
  80308a:	eb 0a                	jmp    803096 <alloc_block_NF+0xa2>
  80308c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308f:	8b 00                	mov    (%eax),%eax
  803091:	a3 38 51 80 00       	mov    %eax,0x805138
  803096:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803099:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80309f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030a9:	a1 44 51 80 00       	mov    0x805144,%eax
  8030ae:	48                   	dec    %eax
  8030af:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8030b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b7:	8b 40 08             	mov    0x8(%eax),%eax
  8030ba:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   return  point;
  8030bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c2:	e9 f8 04 00 00       	jmp    8035bf <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8030c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8030cd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030d0:	0f 86 d4 00 00 00    	jbe    8031aa <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8030d6:	a1 48 51 80 00       	mov    0x805148,%eax
  8030db:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8030de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e1:	8b 50 08             	mov    0x8(%eax),%edx
  8030e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030e7:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8030ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8030f0:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8030f3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030f7:	75 17                	jne    803110 <alloc_block_NF+0x11c>
  8030f9:	83 ec 04             	sub    $0x4,%esp
  8030fc:	68 d8 49 80 00       	push   $0x8049d8
  803101:	68 e9 00 00 00       	push   $0xe9
  803106:	68 2f 49 80 00       	push   $0x80492f
  80310b:	e8 92 d8 ff ff       	call   8009a2 <_panic>
  803110:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803113:	8b 00                	mov    (%eax),%eax
  803115:	85 c0                	test   %eax,%eax
  803117:	74 10                	je     803129 <alloc_block_NF+0x135>
  803119:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80311c:	8b 00                	mov    (%eax),%eax
  80311e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803121:	8b 52 04             	mov    0x4(%edx),%edx
  803124:	89 50 04             	mov    %edx,0x4(%eax)
  803127:	eb 0b                	jmp    803134 <alloc_block_NF+0x140>
  803129:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80312c:	8b 40 04             	mov    0x4(%eax),%eax
  80312f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803134:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803137:	8b 40 04             	mov    0x4(%eax),%eax
  80313a:	85 c0                	test   %eax,%eax
  80313c:	74 0f                	je     80314d <alloc_block_NF+0x159>
  80313e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803141:	8b 40 04             	mov    0x4(%eax),%eax
  803144:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803147:	8b 12                	mov    (%edx),%edx
  803149:	89 10                	mov    %edx,(%eax)
  80314b:	eb 0a                	jmp    803157 <alloc_block_NF+0x163>
  80314d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803150:	8b 00                	mov    (%eax),%eax
  803152:	a3 48 51 80 00       	mov    %eax,0x805148
  803157:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80315a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803160:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803163:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80316a:	a1 54 51 80 00       	mov    0x805154,%eax
  80316f:	48                   	dec    %eax
  803170:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  803175:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803178:	8b 40 08             	mov    0x8(%eax),%eax
  80317b:	a3 2c 50 80 00       	mov    %eax,0x80502c
				   point->sva += size;
  803180:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803183:	8b 50 08             	mov    0x8(%eax),%edx
  803186:	8b 45 08             	mov    0x8(%ebp),%eax
  803189:	01 c2                	add    %eax,%edx
  80318b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318e:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  803191:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803194:	8b 40 0c             	mov    0xc(%eax),%eax
  803197:	2b 45 08             	sub    0x8(%ebp),%eax
  80319a:	89 c2                	mov    %eax,%edx
  80319c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319f:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8031a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031a5:	e9 15 04 00 00       	jmp    8035bf <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8031aa:	a1 40 51 80 00       	mov    0x805140,%eax
  8031af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031b6:	74 07                	je     8031bf <alloc_block_NF+0x1cb>
  8031b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031bb:	8b 00                	mov    (%eax),%eax
  8031bd:	eb 05                	jmp    8031c4 <alloc_block_NF+0x1d0>
  8031bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8031c4:	a3 40 51 80 00       	mov    %eax,0x805140
  8031c9:	a1 40 51 80 00       	mov    0x805140,%eax
  8031ce:	85 c0                	test   %eax,%eax
  8031d0:	0f 85 3e fe ff ff    	jne    803014 <alloc_block_NF+0x20>
  8031d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031da:	0f 85 34 fe ff ff    	jne    803014 <alloc_block_NF+0x20>
  8031e0:	e9 d5 03 00 00       	jmp    8035ba <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8031e5:	a1 38 51 80 00       	mov    0x805138,%eax
  8031ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031ed:	e9 b1 01 00 00       	jmp    8033a3 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8031f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f5:	8b 50 08             	mov    0x8(%eax),%edx
  8031f8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031fd:	39 c2                	cmp    %eax,%edx
  8031ff:	0f 82 96 01 00 00    	jb     80339b <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  803205:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803208:	8b 40 0c             	mov    0xc(%eax),%eax
  80320b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80320e:	0f 82 87 01 00 00    	jb     80339b <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  803214:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803217:	8b 40 0c             	mov    0xc(%eax),%eax
  80321a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80321d:	0f 85 95 00 00 00    	jne    8032b8 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803223:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803227:	75 17                	jne    803240 <alloc_block_NF+0x24c>
  803229:	83 ec 04             	sub    $0x4,%esp
  80322c:	68 d8 49 80 00       	push   $0x8049d8
  803231:	68 fc 00 00 00       	push   $0xfc
  803236:	68 2f 49 80 00       	push   $0x80492f
  80323b:	e8 62 d7 ff ff       	call   8009a2 <_panic>
  803240:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803243:	8b 00                	mov    (%eax),%eax
  803245:	85 c0                	test   %eax,%eax
  803247:	74 10                	je     803259 <alloc_block_NF+0x265>
  803249:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324c:	8b 00                	mov    (%eax),%eax
  80324e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803251:	8b 52 04             	mov    0x4(%edx),%edx
  803254:	89 50 04             	mov    %edx,0x4(%eax)
  803257:	eb 0b                	jmp    803264 <alloc_block_NF+0x270>
  803259:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325c:	8b 40 04             	mov    0x4(%eax),%eax
  80325f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803264:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803267:	8b 40 04             	mov    0x4(%eax),%eax
  80326a:	85 c0                	test   %eax,%eax
  80326c:	74 0f                	je     80327d <alloc_block_NF+0x289>
  80326e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803271:	8b 40 04             	mov    0x4(%eax),%eax
  803274:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803277:	8b 12                	mov    (%edx),%edx
  803279:	89 10                	mov    %edx,(%eax)
  80327b:	eb 0a                	jmp    803287 <alloc_block_NF+0x293>
  80327d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803280:	8b 00                	mov    (%eax),%eax
  803282:	a3 38 51 80 00       	mov    %eax,0x805138
  803287:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803290:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803293:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80329a:	a1 44 51 80 00       	mov    0x805144,%eax
  80329f:	48                   	dec    %eax
  8032a0:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8032a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a8:	8b 40 08             	mov    0x8(%eax),%eax
  8032ab:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  8032b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b3:	e9 07 03 00 00       	jmp    8035bf <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8032b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8032be:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032c1:	0f 86 d4 00 00 00    	jbe    80339b <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8032c7:	a1 48 51 80 00       	mov    0x805148,%eax
  8032cc:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8032cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d2:	8b 50 08             	mov    0x8(%eax),%edx
  8032d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d8:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8032db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032de:	8b 55 08             	mov    0x8(%ebp),%edx
  8032e1:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8032e4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032e8:	75 17                	jne    803301 <alloc_block_NF+0x30d>
  8032ea:	83 ec 04             	sub    $0x4,%esp
  8032ed:	68 d8 49 80 00       	push   $0x8049d8
  8032f2:	68 04 01 00 00       	push   $0x104
  8032f7:	68 2f 49 80 00       	push   $0x80492f
  8032fc:	e8 a1 d6 ff ff       	call   8009a2 <_panic>
  803301:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803304:	8b 00                	mov    (%eax),%eax
  803306:	85 c0                	test   %eax,%eax
  803308:	74 10                	je     80331a <alloc_block_NF+0x326>
  80330a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80330d:	8b 00                	mov    (%eax),%eax
  80330f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803312:	8b 52 04             	mov    0x4(%edx),%edx
  803315:	89 50 04             	mov    %edx,0x4(%eax)
  803318:	eb 0b                	jmp    803325 <alloc_block_NF+0x331>
  80331a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80331d:	8b 40 04             	mov    0x4(%eax),%eax
  803320:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803325:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803328:	8b 40 04             	mov    0x4(%eax),%eax
  80332b:	85 c0                	test   %eax,%eax
  80332d:	74 0f                	je     80333e <alloc_block_NF+0x34a>
  80332f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803332:	8b 40 04             	mov    0x4(%eax),%eax
  803335:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803338:	8b 12                	mov    (%edx),%edx
  80333a:	89 10                	mov    %edx,(%eax)
  80333c:	eb 0a                	jmp    803348 <alloc_block_NF+0x354>
  80333e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803341:	8b 00                	mov    (%eax),%eax
  803343:	a3 48 51 80 00       	mov    %eax,0x805148
  803348:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80334b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803351:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803354:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80335b:	a1 54 51 80 00       	mov    0x805154,%eax
  803360:	48                   	dec    %eax
  803361:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803366:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803369:	8b 40 08             	mov    0x8(%eax),%eax
  80336c:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  803371:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803374:	8b 50 08             	mov    0x8(%eax),%edx
  803377:	8b 45 08             	mov    0x8(%ebp),%eax
  80337a:	01 c2                	add    %eax,%edx
  80337c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80337f:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803382:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803385:	8b 40 0c             	mov    0xc(%eax),%eax
  803388:	2b 45 08             	sub    0x8(%ebp),%eax
  80338b:	89 c2                	mov    %eax,%edx
  80338d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803390:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803393:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803396:	e9 24 02 00 00       	jmp    8035bf <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80339b:	a1 40 51 80 00       	mov    0x805140,%eax
  8033a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033a7:	74 07                	je     8033b0 <alloc_block_NF+0x3bc>
  8033a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ac:	8b 00                	mov    (%eax),%eax
  8033ae:	eb 05                	jmp    8033b5 <alloc_block_NF+0x3c1>
  8033b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8033b5:	a3 40 51 80 00       	mov    %eax,0x805140
  8033ba:	a1 40 51 80 00       	mov    0x805140,%eax
  8033bf:	85 c0                	test   %eax,%eax
  8033c1:	0f 85 2b fe ff ff    	jne    8031f2 <alloc_block_NF+0x1fe>
  8033c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033cb:	0f 85 21 fe ff ff    	jne    8031f2 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8033d1:	a1 38 51 80 00       	mov    0x805138,%eax
  8033d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033d9:	e9 ae 01 00 00       	jmp    80358c <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8033de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e1:	8b 50 08             	mov    0x8(%eax),%edx
  8033e4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8033e9:	39 c2                	cmp    %eax,%edx
  8033eb:	0f 83 93 01 00 00    	jae    803584 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  8033f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8033f7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033fa:	0f 82 84 01 00 00    	jb     803584 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  803400:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803403:	8b 40 0c             	mov    0xc(%eax),%eax
  803406:	3b 45 08             	cmp    0x8(%ebp),%eax
  803409:	0f 85 95 00 00 00    	jne    8034a4 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80340f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803413:	75 17                	jne    80342c <alloc_block_NF+0x438>
  803415:	83 ec 04             	sub    $0x4,%esp
  803418:	68 d8 49 80 00       	push   $0x8049d8
  80341d:	68 14 01 00 00       	push   $0x114
  803422:	68 2f 49 80 00       	push   $0x80492f
  803427:	e8 76 d5 ff ff       	call   8009a2 <_panic>
  80342c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80342f:	8b 00                	mov    (%eax),%eax
  803431:	85 c0                	test   %eax,%eax
  803433:	74 10                	je     803445 <alloc_block_NF+0x451>
  803435:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803438:	8b 00                	mov    (%eax),%eax
  80343a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80343d:	8b 52 04             	mov    0x4(%edx),%edx
  803440:	89 50 04             	mov    %edx,0x4(%eax)
  803443:	eb 0b                	jmp    803450 <alloc_block_NF+0x45c>
  803445:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803448:	8b 40 04             	mov    0x4(%eax),%eax
  80344b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803450:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803453:	8b 40 04             	mov    0x4(%eax),%eax
  803456:	85 c0                	test   %eax,%eax
  803458:	74 0f                	je     803469 <alloc_block_NF+0x475>
  80345a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80345d:	8b 40 04             	mov    0x4(%eax),%eax
  803460:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803463:	8b 12                	mov    (%edx),%edx
  803465:	89 10                	mov    %edx,(%eax)
  803467:	eb 0a                	jmp    803473 <alloc_block_NF+0x47f>
  803469:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80346c:	8b 00                	mov    (%eax),%eax
  80346e:	a3 38 51 80 00       	mov    %eax,0x805138
  803473:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803476:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80347c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80347f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803486:	a1 44 51 80 00       	mov    0x805144,%eax
  80348b:	48                   	dec    %eax
  80348c:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803491:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803494:	8b 40 08             	mov    0x8(%eax),%eax
  803497:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   return  point;
  80349c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80349f:	e9 1b 01 00 00       	jmp    8035bf <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8034a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8034aa:	3b 45 08             	cmp    0x8(%ebp),%eax
  8034ad:	0f 86 d1 00 00 00    	jbe    803584 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8034b3:	a1 48 51 80 00       	mov    0x805148,%eax
  8034b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  8034bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034be:	8b 50 08             	mov    0x8(%eax),%edx
  8034c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034c4:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8034c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8034cd:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8034d0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8034d4:	75 17                	jne    8034ed <alloc_block_NF+0x4f9>
  8034d6:	83 ec 04             	sub    $0x4,%esp
  8034d9:	68 d8 49 80 00       	push   $0x8049d8
  8034de:	68 1c 01 00 00       	push   $0x11c
  8034e3:	68 2f 49 80 00       	push   $0x80492f
  8034e8:	e8 b5 d4 ff ff       	call   8009a2 <_panic>
  8034ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034f0:	8b 00                	mov    (%eax),%eax
  8034f2:	85 c0                	test   %eax,%eax
  8034f4:	74 10                	je     803506 <alloc_block_NF+0x512>
  8034f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034f9:	8b 00                	mov    (%eax),%eax
  8034fb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8034fe:	8b 52 04             	mov    0x4(%edx),%edx
  803501:	89 50 04             	mov    %edx,0x4(%eax)
  803504:	eb 0b                	jmp    803511 <alloc_block_NF+0x51d>
  803506:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803509:	8b 40 04             	mov    0x4(%eax),%eax
  80350c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803511:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803514:	8b 40 04             	mov    0x4(%eax),%eax
  803517:	85 c0                	test   %eax,%eax
  803519:	74 0f                	je     80352a <alloc_block_NF+0x536>
  80351b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80351e:	8b 40 04             	mov    0x4(%eax),%eax
  803521:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803524:	8b 12                	mov    (%edx),%edx
  803526:	89 10                	mov    %edx,(%eax)
  803528:	eb 0a                	jmp    803534 <alloc_block_NF+0x540>
  80352a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80352d:	8b 00                	mov    (%eax),%eax
  80352f:	a3 48 51 80 00       	mov    %eax,0x805148
  803534:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803537:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80353d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803540:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803547:	a1 54 51 80 00       	mov    0x805154,%eax
  80354c:	48                   	dec    %eax
  80354d:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803552:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803555:	8b 40 08             	mov    0x8(%eax),%eax
  803558:	a3 2c 50 80 00       	mov    %eax,0x80502c
					   point->sva += size;
  80355d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803560:	8b 50 08             	mov    0x8(%eax),%edx
  803563:	8b 45 08             	mov    0x8(%ebp),%eax
  803566:	01 c2                	add    %eax,%edx
  803568:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80356b:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80356e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803571:	8b 40 0c             	mov    0xc(%eax),%eax
  803574:	2b 45 08             	sub    0x8(%ebp),%eax
  803577:	89 c2                	mov    %eax,%edx
  803579:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80357c:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  80357f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803582:	eb 3b                	jmp    8035bf <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803584:	a1 40 51 80 00       	mov    0x805140,%eax
  803589:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80358c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803590:	74 07                	je     803599 <alloc_block_NF+0x5a5>
  803592:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803595:	8b 00                	mov    (%eax),%eax
  803597:	eb 05                	jmp    80359e <alloc_block_NF+0x5aa>
  803599:	b8 00 00 00 00       	mov    $0x0,%eax
  80359e:	a3 40 51 80 00       	mov    %eax,0x805140
  8035a3:	a1 40 51 80 00       	mov    0x805140,%eax
  8035a8:	85 c0                	test   %eax,%eax
  8035aa:	0f 85 2e fe ff ff    	jne    8033de <alloc_block_NF+0x3ea>
  8035b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035b4:	0f 85 24 fe ff ff    	jne    8033de <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  8035ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8035bf:	c9                   	leave  
  8035c0:	c3                   	ret    

008035c1 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8035c1:	55                   	push   %ebp
  8035c2:	89 e5                	mov    %esp,%ebp
  8035c4:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  8035c7:	a1 38 51 80 00       	mov    0x805138,%eax
  8035cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  8035cf:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8035d4:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  8035d7:	a1 38 51 80 00       	mov    0x805138,%eax
  8035dc:	85 c0                	test   %eax,%eax
  8035de:	74 14                	je     8035f4 <insert_sorted_with_merge_freeList+0x33>
  8035e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e3:	8b 50 08             	mov    0x8(%eax),%edx
  8035e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035e9:	8b 40 08             	mov    0x8(%eax),%eax
  8035ec:	39 c2                	cmp    %eax,%edx
  8035ee:	0f 87 9b 01 00 00    	ja     80378f <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  8035f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035f8:	75 17                	jne    803611 <insert_sorted_with_merge_freeList+0x50>
  8035fa:	83 ec 04             	sub    $0x4,%esp
  8035fd:	68 0c 49 80 00       	push   $0x80490c
  803602:	68 38 01 00 00       	push   $0x138
  803607:	68 2f 49 80 00       	push   $0x80492f
  80360c:	e8 91 d3 ff ff       	call   8009a2 <_panic>
  803611:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803617:	8b 45 08             	mov    0x8(%ebp),%eax
  80361a:	89 10                	mov    %edx,(%eax)
  80361c:	8b 45 08             	mov    0x8(%ebp),%eax
  80361f:	8b 00                	mov    (%eax),%eax
  803621:	85 c0                	test   %eax,%eax
  803623:	74 0d                	je     803632 <insert_sorted_with_merge_freeList+0x71>
  803625:	a1 38 51 80 00       	mov    0x805138,%eax
  80362a:	8b 55 08             	mov    0x8(%ebp),%edx
  80362d:	89 50 04             	mov    %edx,0x4(%eax)
  803630:	eb 08                	jmp    80363a <insert_sorted_with_merge_freeList+0x79>
  803632:	8b 45 08             	mov    0x8(%ebp),%eax
  803635:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80363a:	8b 45 08             	mov    0x8(%ebp),%eax
  80363d:	a3 38 51 80 00       	mov    %eax,0x805138
  803642:	8b 45 08             	mov    0x8(%ebp),%eax
  803645:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80364c:	a1 44 51 80 00       	mov    0x805144,%eax
  803651:	40                   	inc    %eax
  803652:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803657:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80365b:	0f 84 a8 06 00 00    	je     803d09 <insert_sorted_with_merge_freeList+0x748>
  803661:	8b 45 08             	mov    0x8(%ebp),%eax
  803664:	8b 50 08             	mov    0x8(%eax),%edx
  803667:	8b 45 08             	mov    0x8(%ebp),%eax
  80366a:	8b 40 0c             	mov    0xc(%eax),%eax
  80366d:	01 c2                	add    %eax,%edx
  80366f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803672:	8b 40 08             	mov    0x8(%eax),%eax
  803675:	39 c2                	cmp    %eax,%edx
  803677:	0f 85 8c 06 00 00    	jne    803d09 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  80367d:	8b 45 08             	mov    0x8(%ebp),%eax
  803680:	8b 50 0c             	mov    0xc(%eax),%edx
  803683:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803686:	8b 40 0c             	mov    0xc(%eax),%eax
  803689:	01 c2                	add    %eax,%edx
  80368b:	8b 45 08             	mov    0x8(%ebp),%eax
  80368e:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803691:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803695:	75 17                	jne    8036ae <insert_sorted_with_merge_freeList+0xed>
  803697:	83 ec 04             	sub    $0x4,%esp
  80369a:	68 d8 49 80 00       	push   $0x8049d8
  80369f:	68 3c 01 00 00       	push   $0x13c
  8036a4:	68 2f 49 80 00       	push   $0x80492f
  8036a9:	e8 f4 d2 ff ff       	call   8009a2 <_panic>
  8036ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036b1:	8b 00                	mov    (%eax),%eax
  8036b3:	85 c0                	test   %eax,%eax
  8036b5:	74 10                	je     8036c7 <insert_sorted_with_merge_freeList+0x106>
  8036b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036ba:	8b 00                	mov    (%eax),%eax
  8036bc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036bf:	8b 52 04             	mov    0x4(%edx),%edx
  8036c2:	89 50 04             	mov    %edx,0x4(%eax)
  8036c5:	eb 0b                	jmp    8036d2 <insert_sorted_with_merge_freeList+0x111>
  8036c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036ca:	8b 40 04             	mov    0x4(%eax),%eax
  8036cd:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8036d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036d5:	8b 40 04             	mov    0x4(%eax),%eax
  8036d8:	85 c0                	test   %eax,%eax
  8036da:	74 0f                	je     8036eb <insert_sorted_with_merge_freeList+0x12a>
  8036dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036df:	8b 40 04             	mov    0x4(%eax),%eax
  8036e2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036e5:	8b 12                	mov    (%edx),%edx
  8036e7:	89 10                	mov    %edx,(%eax)
  8036e9:	eb 0a                	jmp    8036f5 <insert_sorted_with_merge_freeList+0x134>
  8036eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036ee:	8b 00                	mov    (%eax),%eax
  8036f0:	a3 38 51 80 00       	mov    %eax,0x805138
  8036f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803701:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803708:	a1 44 51 80 00       	mov    0x805144,%eax
  80370d:	48                   	dec    %eax
  80370e:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  803713:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803716:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  80371d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803720:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803727:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80372b:	75 17                	jne    803744 <insert_sorted_with_merge_freeList+0x183>
  80372d:	83 ec 04             	sub    $0x4,%esp
  803730:	68 0c 49 80 00       	push   $0x80490c
  803735:	68 3f 01 00 00       	push   $0x13f
  80373a:	68 2f 49 80 00       	push   $0x80492f
  80373f:	e8 5e d2 ff ff       	call   8009a2 <_panic>
  803744:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80374a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80374d:	89 10                	mov    %edx,(%eax)
  80374f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803752:	8b 00                	mov    (%eax),%eax
  803754:	85 c0                	test   %eax,%eax
  803756:	74 0d                	je     803765 <insert_sorted_with_merge_freeList+0x1a4>
  803758:	a1 48 51 80 00       	mov    0x805148,%eax
  80375d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803760:	89 50 04             	mov    %edx,0x4(%eax)
  803763:	eb 08                	jmp    80376d <insert_sorted_with_merge_freeList+0x1ac>
  803765:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803768:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80376d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803770:	a3 48 51 80 00       	mov    %eax,0x805148
  803775:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803778:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80377f:	a1 54 51 80 00       	mov    0x805154,%eax
  803784:	40                   	inc    %eax
  803785:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80378a:	e9 7a 05 00 00       	jmp    803d09 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  80378f:	8b 45 08             	mov    0x8(%ebp),%eax
  803792:	8b 50 08             	mov    0x8(%eax),%edx
  803795:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803798:	8b 40 08             	mov    0x8(%eax),%eax
  80379b:	39 c2                	cmp    %eax,%edx
  80379d:	0f 82 14 01 00 00    	jb     8038b7 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8037a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037a6:	8b 50 08             	mov    0x8(%eax),%edx
  8037a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8037af:	01 c2                	add    %eax,%edx
  8037b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b4:	8b 40 08             	mov    0x8(%eax),%eax
  8037b7:	39 c2                	cmp    %eax,%edx
  8037b9:	0f 85 90 00 00 00    	jne    80384f <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8037bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037c2:	8b 50 0c             	mov    0xc(%eax),%edx
  8037c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8037cb:	01 c2                	add    %eax,%edx
  8037cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037d0:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  8037d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8037dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8037e7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037eb:	75 17                	jne    803804 <insert_sorted_with_merge_freeList+0x243>
  8037ed:	83 ec 04             	sub    $0x4,%esp
  8037f0:	68 0c 49 80 00       	push   $0x80490c
  8037f5:	68 49 01 00 00       	push   $0x149
  8037fa:	68 2f 49 80 00       	push   $0x80492f
  8037ff:	e8 9e d1 ff ff       	call   8009a2 <_panic>
  803804:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80380a:	8b 45 08             	mov    0x8(%ebp),%eax
  80380d:	89 10                	mov    %edx,(%eax)
  80380f:	8b 45 08             	mov    0x8(%ebp),%eax
  803812:	8b 00                	mov    (%eax),%eax
  803814:	85 c0                	test   %eax,%eax
  803816:	74 0d                	je     803825 <insert_sorted_with_merge_freeList+0x264>
  803818:	a1 48 51 80 00       	mov    0x805148,%eax
  80381d:	8b 55 08             	mov    0x8(%ebp),%edx
  803820:	89 50 04             	mov    %edx,0x4(%eax)
  803823:	eb 08                	jmp    80382d <insert_sorted_with_merge_freeList+0x26c>
  803825:	8b 45 08             	mov    0x8(%ebp),%eax
  803828:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80382d:	8b 45 08             	mov    0x8(%ebp),%eax
  803830:	a3 48 51 80 00       	mov    %eax,0x805148
  803835:	8b 45 08             	mov    0x8(%ebp),%eax
  803838:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80383f:	a1 54 51 80 00       	mov    0x805154,%eax
  803844:	40                   	inc    %eax
  803845:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80384a:	e9 bb 04 00 00       	jmp    803d0a <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  80384f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803853:	75 17                	jne    80386c <insert_sorted_with_merge_freeList+0x2ab>
  803855:	83 ec 04             	sub    $0x4,%esp
  803858:	68 80 49 80 00       	push   $0x804980
  80385d:	68 4c 01 00 00       	push   $0x14c
  803862:	68 2f 49 80 00       	push   $0x80492f
  803867:	e8 36 d1 ff ff       	call   8009a2 <_panic>
  80386c:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803872:	8b 45 08             	mov    0x8(%ebp),%eax
  803875:	89 50 04             	mov    %edx,0x4(%eax)
  803878:	8b 45 08             	mov    0x8(%ebp),%eax
  80387b:	8b 40 04             	mov    0x4(%eax),%eax
  80387e:	85 c0                	test   %eax,%eax
  803880:	74 0c                	je     80388e <insert_sorted_with_merge_freeList+0x2cd>
  803882:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803887:	8b 55 08             	mov    0x8(%ebp),%edx
  80388a:	89 10                	mov    %edx,(%eax)
  80388c:	eb 08                	jmp    803896 <insert_sorted_with_merge_freeList+0x2d5>
  80388e:	8b 45 08             	mov    0x8(%ebp),%eax
  803891:	a3 38 51 80 00       	mov    %eax,0x805138
  803896:	8b 45 08             	mov    0x8(%ebp),%eax
  803899:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80389e:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038a7:	a1 44 51 80 00       	mov    0x805144,%eax
  8038ac:	40                   	inc    %eax
  8038ad:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8038b2:	e9 53 04 00 00       	jmp    803d0a <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8038b7:	a1 38 51 80 00       	mov    0x805138,%eax
  8038bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8038bf:	e9 15 04 00 00       	jmp    803cd9 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8038c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038c7:	8b 00                	mov    (%eax),%eax
  8038c9:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8038cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8038cf:	8b 50 08             	mov    0x8(%eax),%edx
  8038d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038d5:	8b 40 08             	mov    0x8(%eax),%eax
  8038d8:	39 c2                	cmp    %eax,%edx
  8038da:	0f 86 f1 03 00 00    	jbe    803cd1 <insert_sorted_with_merge_freeList+0x710>
  8038e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e3:	8b 50 08             	mov    0x8(%eax),%edx
  8038e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038e9:	8b 40 08             	mov    0x8(%eax),%eax
  8038ec:	39 c2                	cmp    %eax,%edx
  8038ee:	0f 83 dd 03 00 00    	jae    803cd1 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8038f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038f7:	8b 50 08             	mov    0x8(%eax),%edx
  8038fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038fd:	8b 40 0c             	mov    0xc(%eax),%eax
  803900:	01 c2                	add    %eax,%edx
  803902:	8b 45 08             	mov    0x8(%ebp),%eax
  803905:	8b 40 08             	mov    0x8(%eax),%eax
  803908:	39 c2                	cmp    %eax,%edx
  80390a:	0f 85 b9 01 00 00    	jne    803ac9 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803910:	8b 45 08             	mov    0x8(%ebp),%eax
  803913:	8b 50 08             	mov    0x8(%eax),%edx
  803916:	8b 45 08             	mov    0x8(%ebp),%eax
  803919:	8b 40 0c             	mov    0xc(%eax),%eax
  80391c:	01 c2                	add    %eax,%edx
  80391e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803921:	8b 40 08             	mov    0x8(%eax),%eax
  803924:	39 c2                	cmp    %eax,%edx
  803926:	0f 85 0d 01 00 00    	jne    803a39 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  80392c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80392f:	8b 50 0c             	mov    0xc(%eax),%edx
  803932:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803935:	8b 40 0c             	mov    0xc(%eax),%eax
  803938:	01 c2                	add    %eax,%edx
  80393a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80393d:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803940:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803944:	75 17                	jne    80395d <insert_sorted_with_merge_freeList+0x39c>
  803946:	83 ec 04             	sub    $0x4,%esp
  803949:	68 d8 49 80 00       	push   $0x8049d8
  80394e:	68 5c 01 00 00       	push   $0x15c
  803953:	68 2f 49 80 00       	push   $0x80492f
  803958:	e8 45 d0 ff ff       	call   8009a2 <_panic>
  80395d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803960:	8b 00                	mov    (%eax),%eax
  803962:	85 c0                	test   %eax,%eax
  803964:	74 10                	je     803976 <insert_sorted_with_merge_freeList+0x3b5>
  803966:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803969:	8b 00                	mov    (%eax),%eax
  80396b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80396e:	8b 52 04             	mov    0x4(%edx),%edx
  803971:	89 50 04             	mov    %edx,0x4(%eax)
  803974:	eb 0b                	jmp    803981 <insert_sorted_with_merge_freeList+0x3c0>
  803976:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803979:	8b 40 04             	mov    0x4(%eax),%eax
  80397c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803981:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803984:	8b 40 04             	mov    0x4(%eax),%eax
  803987:	85 c0                	test   %eax,%eax
  803989:	74 0f                	je     80399a <insert_sorted_with_merge_freeList+0x3d9>
  80398b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80398e:	8b 40 04             	mov    0x4(%eax),%eax
  803991:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803994:	8b 12                	mov    (%edx),%edx
  803996:	89 10                	mov    %edx,(%eax)
  803998:	eb 0a                	jmp    8039a4 <insert_sorted_with_merge_freeList+0x3e3>
  80399a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80399d:	8b 00                	mov    (%eax),%eax
  80399f:	a3 38 51 80 00       	mov    %eax,0x805138
  8039a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039b0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039b7:	a1 44 51 80 00       	mov    0x805144,%eax
  8039bc:	48                   	dec    %eax
  8039bd:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8039c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039c5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8039cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039cf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8039d6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8039da:	75 17                	jne    8039f3 <insert_sorted_with_merge_freeList+0x432>
  8039dc:	83 ec 04             	sub    $0x4,%esp
  8039df:	68 0c 49 80 00       	push   $0x80490c
  8039e4:	68 5f 01 00 00       	push   $0x15f
  8039e9:	68 2f 49 80 00       	push   $0x80492f
  8039ee:	e8 af cf ff ff       	call   8009a2 <_panic>
  8039f3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8039f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039fc:	89 10                	mov    %edx,(%eax)
  8039fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a01:	8b 00                	mov    (%eax),%eax
  803a03:	85 c0                	test   %eax,%eax
  803a05:	74 0d                	je     803a14 <insert_sorted_with_merge_freeList+0x453>
  803a07:	a1 48 51 80 00       	mov    0x805148,%eax
  803a0c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a0f:	89 50 04             	mov    %edx,0x4(%eax)
  803a12:	eb 08                	jmp    803a1c <insert_sorted_with_merge_freeList+0x45b>
  803a14:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a17:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803a1c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a1f:	a3 48 51 80 00       	mov    %eax,0x805148
  803a24:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a27:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a2e:	a1 54 51 80 00       	mov    0x805154,%eax
  803a33:	40                   	inc    %eax
  803a34:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a3c:	8b 50 0c             	mov    0xc(%eax),%edx
  803a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  803a42:	8b 40 0c             	mov    0xc(%eax),%eax
  803a45:	01 c2                	add    %eax,%edx
  803a47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a4a:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  803a50:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803a57:	8b 45 08             	mov    0x8(%ebp),%eax
  803a5a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803a61:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a65:	75 17                	jne    803a7e <insert_sorted_with_merge_freeList+0x4bd>
  803a67:	83 ec 04             	sub    $0x4,%esp
  803a6a:	68 0c 49 80 00       	push   $0x80490c
  803a6f:	68 64 01 00 00       	push   $0x164
  803a74:	68 2f 49 80 00       	push   $0x80492f
  803a79:	e8 24 cf ff ff       	call   8009a2 <_panic>
  803a7e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a84:	8b 45 08             	mov    0x8(%ebp),%eax
  803a87:	89 10                	mov    %edx,(%eax)
  803a89:	8b 45 08             	mov    0x8(%ebp),%eax
  803a8c:	8b 00                	mov    (%eax),%eax
  803a8e:	85 c0                	test   %eax,%eax
  803a90:	74 0d                	je     803a9f <insert_sorted_with_merge_freeList+0x4de>
  803a92:	a1 48 51 80 00       	mov    0x805148,%eax
  803a97:	8b 55 08             	mov    0x8(%ebp),%edx
  803a9a:	89 50 04             	mov    %edx,0x4(%eax)
  803a9d:	eb 08                	jmp    803aa7 <insert_sorted_with_merge_freeList+0x4e6>
  803a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  803aa2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  803aaa:	a3 48 51 80 00       	mov    %eax,0x805148
  803aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  803ab2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ab9:	a1 54 51 80 00       	mov    0x805154,%eax
  803abe:	40                   	inc    %eax
  803abf:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803ac4:	e9 41 02 00 00       	jmp    803d0a <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  803acc:	8b 50 08             	mov    0x8(%eax),%edx
  803acf:	8b 45 08             	mov    0x8(%ebp),%eax
  803ad2:	8b 40 0c             	mov    0xc(%eax),%eax
  803ad5:	01 c2                	add    %eax,%edx
  803ad7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ada:	8b 40 08             	mov    0x8(%eax),%eax
  803add:	39 c2                	cmp    %eax,%edx
  803adf:	0f 85 7c 01 00 00    	jne    803c61 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803ae5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803ae9:	74 06                	je     803af1 <insert_sorted_with_merge_freeList+0x530>
  803aeb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803aef:	75 17                	jne    803b08 <insert_sorted_with_merge_freeList+0x547>
  803af1:	83 ec 04             	sub    $0x4,%esp
  803af4:	68 48 49 80 00       	push   $0x804948
  803af9:	68 69 01 00 00       	push   $0x169
  803afe:	68 2f 49 80 00       	push   $0x80492f
  803b03:	e8 9a ce ff ff       	call   8009a2 <_panic>
  803b08:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b0b:	8b 50 04             	mov    0x4(%eax),%edx
  803b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  803b11:	89 50 04             	mov    %edx,0x4(%eax)
  803b14:	8b 45 08             	mov    0x8(%ebp),%eax
  803b17:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b1a:	89 10                	mov    %edx,(%eax)
  803b1c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b1f:	8b 40 04             	mov    0x4(%eax),%eax
  803b22:	85 c0                	test   %eax,%eax
  803b24:	74 0d                	je     803b33 <insert_sorted_with_merge_freeList+0x572>
  803b26:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b29:	8b 40 04             	mov    0x4(%eax),%eax
  803b2c:	8b 55 08             	mov    0x8(%ebp),%edx
  803b2f:	89 10                	mov    %edx,(%eax)
  803b31:	eb 08                	jmp    803b3b <insert_sorted_with_merge_freeList+0x57a>
  803b33:	8b 45 08             	mov    0x8(%ebp),%eax
  803b36:	a3 38 51 80 00       	mov    %eax,0x805138
  803b3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b3e:	8b 55 08             	mov    0x8(%ebp),%edx
  803b41:	89 50 04             	mov    %edx,0x4(%eax)
  803b44:	a1 44 51 80 00       	mov    0x805144,%eax
  803b49:	40                   	inc    %eax
  803b4a:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  803b52:	8b 50 0c             	mov    0xc(%eax),%edx
  803b55:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b58:	8b 40 0c             	mov    0xc(%eax),%eax
  803b5b:	01 c2                	add    %eax,%edx
  803b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  803b60:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803b63:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803b67:	75 17                	jne    803b80 <insert_sorted_with_merge_freeList+0x5bf>
  803b69:	83 ec 04             	sub    $0x4,%esp
  803b6c:	68 d8 49 80 00       	push   $0x8049d8
  803b71:	68 6b 01 00 00       	push   $0x16b
  803b76:	68 2f 49 80 00       	push   $0x80492f
  803b7b:	e8 22 ce ff ff       	call   8009a2 <_panic>
  803b80:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b83:	8b 00                	mov    (%eax),%eax
  803b85:	85 c0                	test   %eax,%eax
  803b87:	74 10                	je     803b99 <insert_sorted_with_merge_freeList+0x5d8>
  803b89:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b8c:	8b 00                	mov    (%eax),%eax
  803b8e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b91:	8b 52 04             	mov    0x4(%edx),%edx
  803b94:	89 50 04             	mov    %edx,0x4(%eax)
  803b97:	eb 0b                	jmp    803ba4 <insert_sorted_with_merge_freeList+0x5e3>
  803b99:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b9c:	8b 40 04             	mov    0x4(%eax),%eax
  803b9f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803ba4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ba7:	8b 40 04             	mov    0x4(%eax),%eax
  803baa:	85 c0                	test   %eax,%eax
  803bac:	74 0f                	je     803bbd <insert_sorted_with_merge_freeList+0x5fc>
  803bae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bb1:	8b 40 04             	mov    0x4(%eax),%eax
  803bb4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803bb7:	8b 12                	mov    (%edx),%edx
  803bb9:	89 10                	mov    %edx,(%eax)
  803bbb:	eb 0a                	jmp    803bc7 <insert_sorted_with_merge_freeList+0x606>
  803bbd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bc0:	8b 00                	mov    (%eax),%eax
  803bc2:	a3 38 51 80 00       	mov    %eax,0x805138
  803bc7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803bd0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bd3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bda:	a1 44 51 80 00       	mov    0x805144,%eax
  803bdf:	48                   	dec    %eax
  803be0:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803be5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803be8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803bef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bf2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803bf9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803bfd:	75 17                	jne    803c16 <insert_sorted_with_merge_freeList+0x655>
  803bff:	83 ec 04             	sub    $0x4,%esp
  803c02:	68 0c 49 80 00       	push   $0x80490c
  803c07:	68 6e 01 00 00       	push   $0x16e
  803c0c:	68 2f 49 80 00       	push   $0x80492f
  803c11:	e8 8c cd ff ff       	call   8009a2 <_panic>
  803c16:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803c1c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c1f:	89 10                	mov    %edx,(%eax)
  803c21:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c24:	8b 00                	mov    (%eax),%eax
  803c26:	85 c0                	test   %eax,%eax
  803c28:	74 0d                	je     803c37 <insert_sorted_with_merge_freeList+0x676>
  803c2a:	a1 48 51 80 00       	mov    0x805148,%eax
  803c2f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c32:	89 50 04             	mov    %edx,0x4(%eax)
  803c35:	eb 08                	jmp    803c3f <insert_sorted_with_merge_freeList+0x67e>
  803c37:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c3a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803c3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c42:	a3 48 51 80 00       	mov    %eax,0x805148
  803c47:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c4a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c51:	a1 54 51 80 00       	mov    0x805154,%eax
  803c56:	40                   	inc    %eax
  803c57:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803c5c:	e9 a9 00 00 00       	jmp    803d0a <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803c61:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c65:	74 06                	je     803c6d <insert_sorted_with_merge_freeList+0x6ac>
  803c67:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c6b:	75 17                	jne    803c84 <insert_sorted_with_merge_freeList+0x6c3>
  803c6d:	83 ec 04             	sub    $0x4,%esp
  803c70:	68 a4 49 80 00       	push   $0x8049a4
  803c75:	68 73 01 00 00       	push   $0x173
  803c7a:	68 2f 49 80 00       	push   $0x80492f
  803c7f:	e8 1e cd ff ff       	call   8009a2 <_panic>
  803c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c87:	8b 10                	mov    (%eax),%edx
  803c89:	8b 45 08             	mov    0x8(%ebp),%eax
  803c8c:	89 10                	mov    %edx,(%eax)
  803c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  803c91:	8b 00                	mov    (%eax),%eax
  803c93:	85 c0                	test   %eax,%eax
  803c95:	74 0b                	je     803ca2 <insert_sorted_with_merge_freeList+0x6e1>
  803c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c9a:	8b 00                	mov    (%eax),%eax
  803c9c:	8b 55 08             	mov    0x8(%ebp),%edx
  803c9f:	89 50 04             	mov    %edx,0x4(%eax)
  803ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ca5:	8b 55 08             	mov    0x8(%ebp),%edx
  803ca8:	89 10                	mov    %edx,(%eax)
  803caa:	8b 45 08             	mov    0x8(%ebp),%eax
  803cad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803cb0:	89 50 04             	mov    %edx,0x4(%eax)
  803cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  803cb6:	8b 00                	mov    (%eax),%eax
  803cb8:	85 c0                	test   %eax,%eax
  803cba:	75 08                	jne    803cc4 <insert_sorted_with_merge_freeList+0x703>
  803cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  803cbf:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803cc4:	a1 44 51 80 00       	mov    0x805144,%eax
  803cc9:	40                   	inc    %eax
  803cca:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803ccf:	eb 39                	jmp    803d0a <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803cd1:	a1 40 51 80 00       	mov    0x805140,%eax
  803cd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803cd9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803cdd:	74 07                	je     803ce6 <insert_sorted_with_merge_freeList+0x725>
  803cdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ce2:	8b 00                	mov    (%eax),%eax
  803ce4:	eb 05                	jmp    803ceb <insert_sorted_with_merge_freeList+0x72a>
  803ce6:	b8 00 00 00 00       	mov    $0x0,%eax
  803ceb:	a3 40 51 80 00       	mov    %eax,0x805140
  803cf0:	a1 40 51 80 00       	mov    0x805140,%eax
  803cf5:	85 c0                	test   %eax,%eax
  803cf7:	0f 85 c7 fb ff ff    	jne    8038c4 <insert_sorted_with_merge_freeList+0x303>
  803cfd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d01:	0f 85 bd fb ff ff    	jne    8038c4 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803d07:	eb 01                	jmp    803d0a <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803d09:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803d0a:	90                   	nop
  803d0b:	c9                   	leave  
  803d0c:	c3                   	ret    
  803d0d:	66 90                	xchg   %ax,%ax
  803d0f:	90                   	nop

00803d10 <__udivdi3>:
  803d10:	55                   	push   %ebp
  803d11:	57                   	push   %edi
  803d12:	56                   	push   %esi
  803d13:	53                   	push   %ebx
  803d14:	83 ec 1c             	sub    $0x1c,%esp
  803d17:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803d1b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803d1f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803d23:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803d27:	89 ca                	mov    %ecx,%edx
  803d29:	89 f8                	mov    %edi,%eax
  803d2b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803d2f:	85 f6                	test   %esi,%esi
  803d31:	75 2d                	jne    803d60 <__udivdi3+0x50>
  803d33:	39 cf                	cmp    %ecx,%edi
  803d35:	77 65                	ja     803d9c <__udivdi3+0x8c>
  803d37:	89 fd                	mov    %edi,%ebp
  803d39:	85 ff                	test   %edi,%edi
  803d3b:	75 0b                	jne    803d48 <__udivdi3+0x38>
  803d3d:	b8 01 00 00 00       	mov    $0x1,%eax
  803d42:	31 d2                	xor    %edx,%edx
  803d44:	f7 f7                	div    %edi
  803d46:	89 c5                	mov    %eax,%ebp
  803d48:	31 d2                	xor    %edx,%edx
  803d4a:	89 c8                	mov    %ecx,%eax
  803d4c:	f7 f5                	div    %ebp
  803d4e:	89 c1                	mov    %eax,%ecx
  803d50:	89 d8                	mov    %ebx,%eax
  803d52:	f7 f5                	div    %ebp
  803d54:	89 cf                	mov    %ecx,%edi
  803d56:	89 fa                	mov    %edi,%edx
  803d58:	83 c4 1c             	add    $0x1c,%esp
  803d5b:	5b                   	pop    %ebx
  803d5c:	5e                   	pop    %esi
  803d5d:	5f                   	pop    %edi
  803d5e:	5d                   	pop    %ebp
  803d5f:	c3                   	ret    
  803d60:	39 ce                	cmp    %ecx,%esi
  803d62:	77 28                	ja     803d8c <__udivdi3+0x7c>
  803d64:	0f bd fe             	bsr    %esi,%edi
  803d67:	83 f7 1f             	xor    $0x1f,%edi
  803d6a:	75 40                	jne    803dac <__udivdi3+0x9c>
  803d6c:	39 ce                	cmp    %ecx,%esi
  803d6e:	72 0a                	jb     803d7a <__udivdi3+0x6a>
  803d70:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803d74:	0f 87 9e 00 00 00    	ja     803e18 <__udivdi3+0x108>
  803d7a:	b8 01 00 00 00       	mov    $0x1,%eax
  803d7f:	89 fa                	mov    %edi,%edx
  803d81:	83 c4 1c             	add    $0x1c,%esp
  803d84:	5b                   	pop    %ebx
  803d85:	5e                   	pop    %esi
  803d86:	5f                   	pop    %edi
  803d87:	5d                   	pop    %ebp
  803d88:	c3                   	ret    
  803d89:	8d 76 00             	lea    0x0(%esi),%esi
  803d8c:	31 ff                	xor    %edi,%edi
  803d8e:	31 c0                	xor    %eax,%eax
  803d90:	89 fa                	mov    %edi,%edx
  803d92:	83 c4 1c             	add    $0x1c,%esp
  803d95:	5b                   	pop    %ebx
  803d96:	5e                   	pop    %esi
  803d97:	5f                   	pop    %edi
  803d98:	5d                   	pop    %ebp
  803d99:	c3                   	ret    
  803d9a:	66 90                	xchg   %ax,%ax
  803d9c:	89 d8                	mov    %ebx,%eax
  803d9e:	f7 f7                	div    %edi
  803da0:	31 ff                	xor    %edi,%edi
  803da2:	89 fa                	mov    %edi,%edx
  803da4:	83 c4 1c             	add    $0x1c,%esp
  803da7:	5b                   	pop    %ebx
  803da8:	5e                   	pop    %esi
  803da9:	5f                   	pop    %edi
  803daa:	5d                   	pop    %ebp
  803dab:	c3                   	ret    
  803dac:	bd 20 00 00 00       	mov    $0x20,%ebp
  803db1:	89 eb                	mov    %ebp,%ebx
  803db3:	29 fb                	sub    %edi,%ebx
  803db5:	89 f9                	mov    %edi,%ecx
  803db7:	d3 e6                	shl    %cl,%esi
  803db9:	89 c5                	mov    %eax,%ebp
  803dbb:	88 d9                	mov    %bl,%cl
  803dbd:	d3 ed                	shr    %cl,%ebp
  803dbf:	89 e9                	mov    %ebp,%ecx
  803dc1:	09 f1                	or     %esi,%ecx
  803dc3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803dc7:	89 f9                	mov    %edi,%ecx
  803dc9:	d3 e0                	shl    %cl,%eax
  803dcb:	89 c5                	mov    %eax,%ebp
  803dcd:	89 d6                	mov    %edx,%esi
  803dcf:	88 d9                	mov    %bl,%cl
  803dd1:	d3 ee                	shr    %cl,%esi
  803dd3:	89 f9                	mov    %edi,%ecx
  803dd5:	d3 e2                	shl    %cl,%edx
  803dd7:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ddb:	88 d9                	mov    %bl,%cl
  803ddd:	d3 e8                	shr    %cl,%eax
  803ddf:	09 c2                	or     %eax,%edx
  803de1:	89 d0                	mov    %edx,%eax
  803de3:	89 f2                	mov    %esi,%edx
  803de5:	f7 74 24 0c          	divl   0xc(%esp)
  803de9:	89 d6                	mov    %edx,%esi
  803deb:	89 c3                	mov    %eax,%ebx
  803ded:	f7 e5                	mul    %ebp
  803def:	39 d6                	cmp    %edx,%esi
  803df1:	72 19                	jb     803e0c <__udivdi3+0xfc>
  803df3:	74 0b                	je     803e00 <__udivdi3+0xf0>
  803df5:	89 d8                	mov    %ebx,%eax
  803df7:	31 ff                	xor    %edi,%edi
  803df9:	e9 58 ff ff ff       	jmp    803d56 <__udivdi3+0x46>
  803dfe:	66 90                	xchg   %ax,%ax
  803e00:	8b 54 24 08          	mov    0x8(%esp),%edx
  803e04:	89 f9                	mov    %edi,%ecx
  803e06:	d3 e2                	shl    %cl,%edx
  803e08:	39 c2                	cmp    %eax,%edx
  803e0a:	73 e9                	jae    803df5 <__udivdi3+0xe5>
  803e0c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803e0f:	31 ff                	xor    %edi,%edi
  803e11:	e9 40 ff ff ff       	jmp    803d56 <__udivdi3+0x46>
  803e16:	66 90                	xchg   %ax,%ax
  803e18:	31 c0                	xor    %eax,%eax
  803e1a:	e9 37 ff ff ff       	jmp    803d56 <__udivdi3+0x46>
  803e1f:	90                   	nop

00803e20 <__umoddi3>:
  803e20:	55                   	push   %ebp
  803e21:	57                   	push   %edi
  803e22:	56                   	push   %esi
  803e23:	53                   	push   %ebx
  803e24:	83 ec 1c             	sub    $0x1c,%esp
  803e27:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803e2b:	8b 74 24 34          	mov    0x34(%esp),%esi
  803e2f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803e33:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803e37:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803e3b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803e3f:	89 f3                	mov    %esi,%ebx
  803e41:	89 fa                	mov    %edi,%edx
  803e43:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803e47:	89 34 24             	mov    %esi,(%esp)
  803e4a:	85 c0                	test   %eax,%eax
  803e4c:	75 1a                	jne    803e68 <__umoddi3+0x48>
  803e4e:	39 f7                	cmp    %esi,%edi
  803e50:	0f 86 a2 00 00 00    	jbe    803ef8 <__umoddi3+0xd8>
  803e56:	89 c8                	mov    %ecx,%eax
  803e58:	89 f2                	mov    %esi,%edx
  803e5a:	f7 f7                	div    %edi
  803e5c:	89 d0                	mov    %edx,%eax
  803e5e:	31 d2                	xor    %edx,%edx
  803e60:	83 c4 1c             	add    $0x1c,%esp
  803e63:	5b                   	pop    %ebx
  803e64:	5e                   	pop    %esi
  803e65:	5f                   	pop    %edi
  803e66:	5d                   	pop    %ebp
  803e67:	c3                   	ret    
  803e68:	39 f0                	cmp    %esi,%eax
  803e6a:	0f 87 ac 00 00 00    	ja     803f1c <__umoddi3+0xfc>
  803e70:	0f bd e8             	bsr    %eax,%ebp
  803e73:	83 f5 1f             	xor    $0x1f,%ebp
  803e76:	0f 84 ac 00 00 00    	je     803f28 <__umoddi3+0x108>
  803e7c:	bf 20 00 00 00       	mov    $0x20,%edi
  803e81:	29 ef                	sub    %ebp,%edi
  803e83:	89 fe                	mov    %edi,%esi
  803e85:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803e89:	89 e9                	mov    %ebp,%ecx
  803e8b:	d3 e0                	shl    %cl,%eax
  803e8d:	89 d7                	mov    %edx,%edi
  803e8f:	89 f1                	mov    %esi,%ecx
  803e91:	d3 ef                	shr    %cl,%edi
  803e93:	09 c7                	or     %eax,%edi
  803e95:	89 e9                	mov    %ebp,%ecx
  803e97:	d3 e2                	shl    %cl,%edx
  803e99:	89 14 24             	mov    %edx,(%esp)
  803e9c:	89 d8                	mov    %ebx,%eax
  803e9e:	d3 e0                	shl    %cl,%eax
  803ea0:	89 c2                	mov    %eax,%edx
  803ea2:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ea6:	d3 e0                	shl    %cl,%eax
  803ea8:	89 44 24 04          	mov    %eax,0x4(%esp)
  803eac:	8b 44 24 08          	mov    0x8(%esp),%eax
  803eb0:	89 f1                	mov    %esi,%ecx
  803eb2:	d3 e8                	shr    %cl,%eax
  803eb4:	09 d0                	or     %edx,%eax
  803eb6:	d3 eb                	shr    %cl,%ebx
  803eb8:	89 da                	mov    %ebx,%edx
  803eba:	f7 f7                	div    %edi
  803ebc:	89 d3                	mov    %edx,%ebx
  803ebe:	f7 24 24             	mull   (%esp)
  803ec1:	89 c6                	mov    %eax,%esi
  803ec3:	89 d1                	mov    %edx,%ecx
  803ec5:	39 d3                	cmp    %edx,%ebx
  803ec7:	0f 82 87 00 00 00    	jb     803f54 <__umoddi3+0x134>
  803ecd:	0f 84 91 00 00 00    	je     803f64 <__umoddi3+0x144>
  803ed3:	8b 54 24 04          	mov    0x4(%esp),%edx
  803ed7:	29 f2                	sub    %esi,%edx
  803ed9:	19 cb                	sbb    %ecx,%ebx
  803edb:	89 d8                	mov    %ebx,%eax
  803edd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803ee1:	d3 e0                	shl    %cl,%eax
  803ee3:	89 e9                	mov    %ebp,%ecx
  803ee5:	d3 ea                	shr    %cl,%edx
  803ee7:	09 d0                	or     %edx,%eax
  803ee9:	89 e9                	mov    %ebp,%ecx
  803eeb:	d3 eb                	shr    %cl,%ebx
  803eed:	89 da                	mov    %ebx,%edx
  803eef:	83 c4 1c             	add    $0x1c,%esp
  803ef2:	5b                   	pop    %ebx
  803ef3:	5e                   	pop    %esi
  803ef4:	5f                   	pop    %edi
  803ef5:	5d                   	pop    %ebp
  803ef6:	c3                   	ret    
  803ef7:	90                   	nop
  803ef8:	89 fd                	mov    %edi,%ebp
  803efa:	85 ff                	test   %edi,%edi
  803efc:	75 0b                	jne    803f09 <__umoddi3+0xe9>
  803efe:	b8 01 00 00 00       	mov    $0x1,%eax
  803f03:	31 d2                	xor    %edx,%edx
  803f05:	f7 f7                	div    %edi
  803f07:	89 c5                	mov    %eax,%ebp
  803f09:	89 f0                	mov    %esi,%eax
  803f0b:	31 d2                	xor    %edx,%edx
  803f0d:	f7 f5                	div    %ebp
  803f0f:	89 c8                	mov    %ecx,%eax
  803f11:	f7 f5                	div    %ebp
  803f13:	89 d0                	mov    %edx,%eax
  803f15:	e9 44 ff ff ff       	jmp    803e5e <__umoddi3+0x3e>
  803f1a:	66 90                	xchg   %ax,%ax
  803f1c:	89 c8                	mov    %ecx,%eax
  803f1e:	89 f2                	mov    %esi,%edx
  803f20:	83 c4 1c             	add    $0x1c,%esp
  803f23:	5b                   	pop    %ebx
  803f24:	5e                   	pop    %esi
  803f25:	5f                   	pop    %edi
  803f26:	5d                   	pop    %ebp
  803f27:	c3                   	ret    
  803f28:	3b 04 24             	cmp    (%esp),%eax
  803f2b:	72 06                	jb     803f33 <__umoddi3+0x113>
  803f2d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803f31:	77 0f                	ja     803f42 <__umoddi3+0x122>
  803f33:	89 f2                	mov    %esi,%edx
  803f35:	29 f9                	sub    %edi,%ecx
  803f37:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803f3b:	89 14 24             	mov    %edx,(%esp)
  803f3e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803f42:	8b 44 24 04          	mov    0x4(%esp),%eax
  803f46:	8b 14 24             	mov    (%esp),%edx
  803f49:	83 c4 1c             	add    $0x1c,%esp
  803f4c:	5b                   	pop    %ebx
  803f4d:	5e                   	pop    %esi
  803f4e:	5f                   	pop    %edi
  803f4f:	5d                   	pop    %ebp
  803f50:	c3                   	ret    
  803f51:	8d 76 00             	lea    0x0(%esi),%esi
  803f54:	2b 04 24             	sub    (%esp),%eax
  803f57:	19 fa                	sbb    %edi,%edx
  803f59:	89 d1                	mov    %edx,%ecx
  803f5b:	89 c6                	mov    %eax,%esi
  803f5d:	e9 71 ff ff ff       	jmp    803ed3 <__umoddi3+0xb3>
  803f62:	66 90                	xchg   %ax,%ax
  803f64:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803f68:	72 ea                	jb     803f54 <__umoddi3+0x134>
  803f6a:	89 d9                	mov    %ebx,%ecx
  803f6c:	e9 62 ff ff ff       	jmp    803ed3 <__umoddi3+0xb3>
