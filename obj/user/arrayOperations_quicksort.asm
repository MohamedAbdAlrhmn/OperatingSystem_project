
obj/user/arrayOperations_quicksort:     file format elf32-i386


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
  800031:	e8 20 03 00 00       	call   800356 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

void QuickSort(int *Elements, int NumOfElements);
void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	int32 envID = sys_getenvid();
  80003e:	e8 1f 1a 00 00       	call   801a62 <sys_getenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int32 parentenvID = sys_getparentenvid();
  800046:	e8 49 1a 00 00       	call   801a94 <sys_getparentenvid>
  80004b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	int ret;
	/*[1] GET SHARED VARs*/
	//Get the shared array & its size
	int *numOfElements = NULL;
  80004e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	int *sharedArray = NULL;
  800055:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	sharedArray = sget(parentenvID,"arr") ;
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	68 c0 37 80 00       	push   $0x8037c0
  800064:	ff 75 ec             	pushl  -0x14(%ebp)
  800067:	e8 8b 15 00 00       	call   8015f7 <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	numOfElements = sget(parentenvID,"arrSize") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 c4 37 80 00       	push   $0x8037c4
  80007a:	ff 75 ec             	pushl  -0x14(%ebp)
  80007d:	e8 75 15 00 00       	call   8015f7 <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//Get the check-finishing counter
	int *finishedCount = NULL;
  800088:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	finishedCount = sget(parentenvID,"finishedCount") ;
  80008f:	83 ec 08             	sub    $0x8,%esp
  800092:	68 cc 37 80 00       	push   $0x8037cc
  800097:	ff 75 ec             	pushl  -0x14(%ebp)
  80009a:	e8 58 15 00 00       	call   8015f7 <sget>
  80009f:	83 c4 10             	add    $0x10,%esp
  8000a2:	89 45 e0             	mov    %eax,-0x20(%ebp)

	/*[2] DO THE JOB*/
	//take a copy from the original array
	int *sortedArray;
	sortedArray = smalloc("quicksortedArr", sizeof(int) * *numOfElements, 0) ;
  8000a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000a8:	8b 00                	mov    (%eax),%eax
  8000aa:	c1 e0 02             	shl    $0x2,%eax
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 00                	push   $0x0
  8000b2:	50                   	push   %eax
  8000b3:	68 da 37 80 00       	push   $0x8037da
  8000b8:	e8 79 14 00 00       	call   801536 <smalloc>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8000c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8000ca:	eb 25                	jmp    8000f1 <_main+0xb9>
	{
		sortedArray[i] = sharedArray[i];
  8000cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000cf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000d9:	01 c2                	add    %eax,%edx
  8000db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000de:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8000e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000e8:	01 c8                	add    %ecx,%eax
  8000ea:	8b 00                	mov    (%eax),%eax
  8000ec:	89 02                	mov    %eax,(%edx)
	/*[2] DO THE JOB*/
	//take a copy from the original array
	int *sortedArray;
	sortedArray = smalloc("quicksortedArr", sizeof(int) * *numOfElements, 0) ;
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8000ee:	ff 45 f4             	incl   -0xc(%ebp)
  8000f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000f4:	8b 00                	mov    (%eax),%eax
  8000f6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8000f9:	7f d1                	jg     8000cc <_main+0x94>
	{
		sortedArray[i] = sharedArray[i];
	}
	QuickSort(sortedArray, *numOfElements);
  8000fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000fe:	8b 00                	mov    (%eax),%eax
  800100:	83 ec 08             	sub    $0x8,%esp
  800103:	50                   	push   %eax
  800104:	ff 75 dc             	pushl  -0x24(%ebp)
  800107:	e8 23 00 00 00       	call   80012f <QuickSort>
  80010c:	83 c4 10             	add    $0x10,%esp
	cprintf("Quick sort is Finished!!!!\n") ;
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	68 e9 37 80 00       	push   $0x8037e9
  800117:	e8 4a 04 00 00       	call   800566 <cprintf>
  80011c:	83 c4 10             	add    $0x10,%esp

	/*[3] SHARE THE RESULTS & DECLARE FINISHING*/
	(*finishedCount)++ ;
  80011f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800122:	8b 00                	mov    (%eax),%eax
  800124:	8d 50 01             	lea    0x1(%eax),%edx
  800127:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80012a:	89 10                	mov    %edx,(%eax)

}
  80012c:	90                   	nop
  80012d:	c9                   	leave  
  80012e:	c3                   	ret    

0080012f <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  80012f:	55                   	push   %ebp
  800130:	89 e5                	mov    %esp,%ebp
  800132:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  800135:	8b 45 0c             	mov    0xc(%ebp),%eax
  800138:	48                   	dec    %eax
  800139:	50                   	push   %eax
  80013a:	6a 00                	push   $0x0
  80013c:	ff 75 0c             	pushl  0xc(%ebp)
  80013f:	ff 75 08             	pushl  0x8(%ebp)
  800142:	e8 06 00 00 00       	call   80014d <QSort>
  800147:	83 c4 10             	add    $0x10,%esp
}
  80014a:	90                   	nop
  80014b:	c9                   	leave  
  80014c:	c3                   	ret    

0080014d <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  80014d:	55                   	push   %ebp
  80014e:	89 e5                	mov    %esp,%ebp
  800150:	83 ec 28             	sub    $0x28,%esp
	if (startIndex >= finalIndex) return;
  800153:	8b 45 10             	mov    0x10(%ebp),%eax
  800156:	3b 45 14             	cmp    0x14(%ebp),%eax
  800159:	0f 8d 1b 01 00 00    	jge    80027a <QSort+0x12d>
	int pvtIndex = RAND(startIndex, finalIndex) ;
  80015f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800162:	83 ec 0c             	sub    $0xc,%esp
  800165:	50                   	push   %eax
  800166:	e8 5c 19 00 00       	call   801ac7 <sys_get_virtual_time>
  80016b:	83 c4 0c             	add    $0xc,%esp
  80016e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800171:	8b 55 14             	mov    0x14(%ebp),%edx
  800174:	2b 55 10             	sub    0x10(%ebp),%edx
  800177:	89 d1                	mov    %edx,%ecx
  800179:	ba 00 00 00 00       	mov    $0x0,%edx
  80017e:	f7 f1                	div    %ecx
  800180:	8b 45 10             	mov    0x10(%ebp),%eax
  800183:	01 d0                	add    %edx,%eax
  800185:	89 45 ec             	mov    %eax,-0x14(%ebp)
	Swap(Elements, startIndex, pvtIndex);
  800188:	83 ec 04             	sub    $0x4,%esp
  80018b:	ff 75 ec             	pushl  -0x14(%ebp)
  80018e:	ff 75 10             	pushl  0x10(%ebp)
  800191:	ff 75 08             	pushl  0x8(%ebp)
  800194:	e8 e4 00 00 00       	call   80027d <Swap>
  800199:	83 c4 10             	add    $0x10,%esp

	int i = startIndex+1, j = finalIndex;
  80019c:	8b 45 10             	mov    0x10(%ebp),%eax
  80019f:	40                   	inc    %eax
  8001a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8001a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8001a6:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  8001a9:	e9 80 00 00 00       	jmp    80022e <QSort+0xe1>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  8001ae:	ff 45 f4             	incl   -0xc(%ebp)
  8001b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001b4:	3b 45 14             	cmp    0x14(%ebp),%eax
  8001b7:	7f 2b                	jg     8001e4 <QSort+0x97>
  8001b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8001bc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8001c6:	01 d0                	add    %edx,%eax
  8001c8:	8b 10                	mov    (%eax),%edx
  8001ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001cd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8001d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d7:	01 c8                	add    %ecx,%eax
  8001d9:	8b 00                	mov    (%eax),%eax
  8001db:	39 c2                	cmp    %eax,%edx
  8001dd:	7d cf                	jge    8001ae <QSort+0x61>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  8001df:	eb 03                	jmp    8001e4 <QSort+0x97>
  8001e1:	ff 4d f0             	decl   -0x10(%ebp)
  8001e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001e7:	3b 45 10             	cmp    0x10(%ebp),%eax
  8001ea:	7e 26                	jle    800212 <QSort+0xc5>
  8001ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8001ef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8001f9:	01 d0                	add    %edx,%eax
  8001fb:	8b 10                	mov    (%eax),%edx
  8001fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800200:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800207:	8b 45 08             	mov    0x8(%ebp),%eax
  80020a:	01 c8                	add    %ecx,%eax
  80020c:	8b 00                	mov    (%eax),%eax
  80020e:	39 c2                	cmp    %eax,%edx
  800210:	7e cf                	jle    8001e1 <QSort+0x94>

		if (i <= j)
  800212:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800215:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800218:	7f 14                	jg     80022e <QSort+0xe1>
		{
			Swap(Elements, i, j);
  80021a:	83 ec 04             	sub    $0x4,%esp
  80021d:	ff 75 f0             	pushl  -0x10(%ebp)
  800220:	ff 75 f4             	pushl  -0xc(%ebp)
  800223:	ff 75 08             	pushl  0x8(%ebp)
  800226:	e8 52 00 00 00       	call   80027d <Swap>
  80022b:	83 c4 10             	add    $0x10,%esp
	int pvtIndex = RAND(startIndex, finalIndex) ;
	Swap(Elements, startIndex, pvtIndex);

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  80022e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800231:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800234:	0f 8e 77 ff ff ff    	jle    8001b1 <QSort+0x64>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  80023a:	83 ec 04             	sub    $0x4,%esp
  80023d:	ff 75 f0             	pushl  -0x10(%ebp)
  800240:	ff 75 10             	pushl  0x10(%ebp)
  800243:	ff 75 08             	pushl  0x8(%ebp)
  800246:	e8 32 00 00 00       	call   80027d <Swap>
  80024b:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  80024e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800251:	48                   	dec    %eax
  800252:	50                   	push   %eax
  800253:	ff 75 10             	pushl  0x10(%ebp)
  800256:	ff 75 0c             	pushl  0xc(%ebp)
  800259:	ff 75 08             	pushl  0x8(%ebp)
  80025c:	e8 ec fe ff ff       	call   80014d <QSort>
  800261:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  800264:	ff 75 14             	pushl  0x14(%ebp)
  800267:	ff 75 f4             	pushl  -0xc(%ebp)
  80026a:	ff 75 0c             	pushl  0xc(%ebp)
  80026d:	ff 75 08             	pushl  0x8(%ebp)
  800270:	e8 d8 fe ff ff       	call   80014d <QSort>
  800275:	83 c4 10             	add    $0x10,%esp
  800278:	eb 01                	jmp    80027b <QSort+0x12e>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  80027a:	90                   	nop
	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);

	//cprintf("qs,after sorting: start = %d, end = %d\n", startIndex, finalIndex);

}
  80027b:	c9                   	leave  
  80027c:	c3                   	ret    

0080027d <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80027d:	55                   	push   %ebp
  80027e:	89 e5                	mov    %esp,%ebp
  800280:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800283:	8b 45 0c             	mov    0xc(%ebp),%eax
  800286:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80028d:	8b 45 08             	mov    0x8(%ebp),%eax
  800290:	01 d0                	add    %edx,%eax
  800292:	8b 00                	mov    (%eax),%eax
  800294:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800297:	8b 45 0c             	mov    0xc(%ebp),%eax
  80029a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a4:	01 c2                	add    %eax,%edx
  8002a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002a9:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b3:	01 c8                	add    %ecx,%eax
  8002b5:	8b 00                	mov    (%eax),%eax
  8002b7:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  8002b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8002bc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c6:	01 c2                	add    %eax,%edx
  8002c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8002cb:	89 02                	mov    %eax,(%edx)
}
  8002cd:	90                   	nop
  8002ce:	c9                   	leave  
  8002cf:	c3                   	ret    

008002d0 <PrintElements>:


void PrintElements(int *Elements, int NumOfElements)
{
  8002d0:	55                   	push   %ebp
  8002d1:	89 e5                	mov    %esp,%ebp
  8002d3:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  8002d6:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  8002dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8002e4:	eb 42                	jmp    800328 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  8002e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002e9:	99                   	cltd   
  8002ea:	f7 7d f0             	idivl  -0x10(%ebp)
  8002ed:	89 d0                	mov    %edx,%eax
  8002ef:	85 c0                	test   %eax,%eax
  8002f1:	75 10                	jne    800303 <PrintElements+0x33>
			cprintf("\n");
  8002f3:	83 ec 0c             	sub    $0xc,%esp
  8002f6:	68 05 38 80 00       	push   $0x803805
  8002fb:	e8 66 02 00 00       	call   800566 <cprintf>
  800300:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800303:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800306:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80030d:	8b 45 08             	mov    0x8(%ebp),%eax
  800310:	01 d0                	add    %edx,%eax
  800312:	8b 00                	mov    (%eax),%eax
  800314:	83 ec 08             	sub    $0x8,%esp
  800317:	50                   	push   %eax
  800318:	68 07 38 80 00       	push   $0x803807
  80031d:	e8 44 02 00 00       	call   800566 <cprintf>
  800322:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800325:	ff 45 f4             	incl   -0xc(%ebp)
  800328:	8b 45 0c             	mov    0xc(%ebp),%eax
  80032b:	48                   	dec    %eax
  80032c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80032f:	7f b5                	jg     8002e6 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800331:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800334:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80033b:	8b 45 08             	mov    0x8(%ebp),%eax
  80033e:	01 d0                	add    %edx,%eax
  800340:	8b 00                	mov    (%eax),%eax
  800342:	83 ec 08             	sub    $0x8,%esp
  800345:	50                   	push   %eax
  800346:	68 0c 38 80 00       	push   $0x80380c
  80034b:	e8 16 02 00 00       	call   800566 <cprintf>
  800350:	83 c4 10             	add    $0x10,%esp

}
  800353:	90                   	nop
  800354:	c9                   	leave  
  800355:	c3                   	ret    

00800356 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800356:	55                   	push   %ebp
  800357:	89 e5                	mov    %esp,%ebp
  800359:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80035c:	e8 1a 17 00 00       	call   801a7b <sys_getenvindex>
  800361:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800364:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800367:	89 d0                	mov    %edx,%eax
  800369:	c1 e0 03             	shl    $0x3,%eax
  80036c:	01 d0                	add    %edx,%eax
  80036e:	01 c0                	add    %eax,%eax
  800370:	01 d0                	add    %edx,%eax
  800372:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800379:	01 d0                	add    %edx,%eax
  80037b:	c1 e0 04             	shl    $0x4,%eax
  80037e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800383:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800388:	a1 20 50 80 00       	mov    0x805020,%eax
  80038d:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800393:	84 c0                	test   %al,%al
  800395:	74 0f                	je     8003a6 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800397:	a1 20 50 80 00       	mov    0x805020,%eax
  80039c:	05 5c 05 00 00       	add    $0x55c,%eax
  8003a1:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8003aa:	7e 0a                	jle    8003b6 <libmain+0x60>
		binaryname = argv[0];
  8003ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003af:	8b 00                	mov    (%eax),%eax
  8003b1:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8003b6:	83 ec 08             	sub    $0x8,%esp
  8003b9:	ff 75 0c             	pushl  0xc(%ebp)
  8003bc:	ff 75 08             	pushl  0x8(%ebp)
  8003bf:	e8 74 fc ff ff       	call   800038 <_main>
  8003c4:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8003c7:	e8 bc 14 00 00       	call   801888 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8003cc:	83 ec 0c             	sub    $0xc,%esp
  8003cf:	68 28 38 80 00       	push   $0x803828
  8003d4:	e8 8d 01 00 00       	call   800566 <cprintf>
  8003d9:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003dc:	a1 20 50 80 00       	mov    0x805020,%eax
  8003e1:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8003e7:	a1 20 50 80 00       	mov    0x805020,%eax
  8003ec:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8003f2:	83 ec 04             	sub    $0x4,%esp
  8003f5:	52                   	push   %edx
  8003f6:	50                   	push   %eax
  8003f7:	68 50 38 80 00       	push   $0x803850
  8003fc:	e8 65 01 00 00       	call   800566 <cprintf>
  800401:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800404:	a1 20 50 80 00       	mov    0x805020,%eax
  800409:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80040f:	a1 20 50 80 00       	mov    0x805020,%eax
  800414:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80041a:	a1 20 50 80 00       	mov    0x805020,%eax
  80041f:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800425:	51                   	push   %ecx
  800426:	52                   	push   %edx
  800427:	50                   	push   %eax
  800428:	68 78 38 80 00       	push   $0x803878
  80042d:	e8 34 01 00 00       	call   800566 <cprintf>
  800432:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800435:	a1 20 50 80 00       	mov    0x805020,%eax
  80043a:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800440:	83 ec 08             	sub    $0x8,%esp
  800443:	50                   	push   %eax
  800444:	68 d0 38 80 00       	push   $0x8038d0
  800449:	e8 18 01 00 00       	call   800566 <cprintf>
  80044e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800451:	83 ec 0c             	sub    $0xc,%esp
  800454:	68 28 38 80 00       	push   $0x803828
  800459:	e8 08 01 00 00       	call   800566 <cprintf>
  80045e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800461:	e8 3c 14 00 00       	call   8018a2 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800466:	e8 19 00 00 00       	call   800484 <exit>
}
  80046b:	90                   	nop
  80046c:	c9                   	leave  
  80046d:	c3                   	ret    

0080046e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80046e:	55                   	push   %ebp
  80046f:	89 e5                	mov    %esp,%ebp
  800471:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800474:	83 ec 0c             	sub    $0xc,%esp
  800477:	6a 00                	push   $0x0
  800479:	e8 c9 15 00 00       	call   801a47 <sys_destroy_env>
  80047e:	83 c4 10             	add    $0x10,%esp
}
  800481:	90                   	nop
  800482:	c9                   	leave  
  800483:	c3                   	ret    

00800484 <exit>:

void
exit(void)
{
  800484:	55                   	push   %ebp
  800485:	89 e5                	mov    %esp,%ebp
  800487:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80048a:	e8 1e 16 00 00       	call   801aad <sys_exit_env>
}
  80048f:	90                   	nop
  800490:	c9                   	leave  
  800491:	c3                   	ret    

00800492 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800492:	55                   	push   %ebp
  800493:	89 e5                	mov    %esp,%ebp
  800495:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800498:	8b 45 0c             	mov    0xc(%ebp),%eax
  80049b:	8b 00                	mov    (%eax),%eax
  80049d:	8d 48 01             	lea    0x1(%eax),%ecx
  8004a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004a3:	89 0a                	mov    %ecx,(%edx)
  8004a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8004a8:	88 d1                	mov    %dl,%cl
  8004aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ad:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b4:	8b 00                	mov    (%eax),%eax
  8004b6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004bb:	75 2c                	jne    8004e9 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004bd:	a0 24 50 80 00       	mov    0x805024,%al
  8004c2:	0f b6 c0             	movzbl %al,%eax
  8004c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c8:	8b 12                	mov    (%edx),%edx
  8004ca:	89 d1                	mov    %edx,%ecx
  8004cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004cf:	83 c2 08             	add    $0x8,%edx
  8004d2:	83 ec 04             	sub    $0x4,%esp
  8004d5:	50                   	push   %eax
  8004d6:	51                   	push   %ecx
  8004d7:	52                   	push   %edx
  8004d8:	e8 fd 11 00 00       	call   8016da <sys_cputs>
  8004dd:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ec:	8b 40 04             	mov    0x4(%eax),%eax
  8004ef:	8d 50 01             	lea    0x1(%eax),%edx
  8004f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f5:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004f8:	90                   	nop
  8004f9:	c9                   	leave  
  8004fa:	c3                   	ret    

008004fb <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004fb:	55                   	push   %ebp
  8004fc:	89 e5                	mov    %esp,%ebp
  8004fe:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800504:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80050b:	00 00 00 
	b.cnt = 0;
  80050e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800515:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800518:	ff 75 0c             	pushl  0xc(%ebp)
  80051b:	ff 75 08             	pushl  0x8(%ebp)
  80051e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800524:	50                   	push   %eax
  800525:	68 92 04 80 00       	push   $0x800492
  80052a:	e8 11 02 00 00       	call   800740 <vprintfmt>
  80052f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800532:	a0 24 50 80 00       	mov    0x805024,%al
  800537:	0f b6 c0             	movzbl %al,%eax
  80053a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800540:	83 ec 04             	sub    $0x4,%esp
  800543:	50                   	push   %eax
  800544:	52                   	push   %edx
  800545:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80054b:	83 c0 08             	add    $0x8,%eax
  80054e:	50                   	push   %eax
  80054f:	e8 86 11 00 00       	call   8016da <sys_cputs>
  800554:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800557:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  80055e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800564:	c9                   	leave  
  800565:	c3                   	ret    

00800566 <cprintf>:

int cprintf(const char *fmt, ...) {
  800566:	55                   	push   %ebp
  800567:	89 e5                	mov    %esp,%ebp
  800569:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80056c:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800573:	8d 45 0c             	lea    0xc(%ebp),%eax
  800576:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800579:	8b 45 08             	mov    0x8(%ebp),%eax
  80057c:	83 ec 08             	sub    $0x8,%esp
  80057f:	ff 75 f4             	pushl  -0xc(%ebp)
  800582:	50                   	push   %eax
  800583:	e8 73 ff ff ff       	call   8004fb <vcprintf>
  800588:	83 c4 10             	add    $0x10,%esp
  80058b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80058e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800591:	c9                   	leave  
  800592:	c3                   	ret    

00800593 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800593:	55                   	push   %ebp
  800594:	89 e5                	mov    %esp,%ebp
  800596:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800599:	e8 ea 12 00 00       	call   801888 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80059e:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a7:	83 ec 08             	sub    $0x8,%esp
  8005aa:	ff 75 f4             	pushl  -0xc(%ebp)
  8005ad:	50                   	push   %eax
  8005ae:	e8 48 ff ff ff       	call   8004fb <vcprintf>
  8005b3:	83 c4 10             	add    $0x10,%esp
  8005b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005b9:	e8 e4 12 00 00       	call   8018a2 <sys_enable_interrupt>
	return cnt;
  8005be:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005c1:	c9                   	leave  
  8005c2:	c3                   	ret    

008005c3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005c3:	55                   	push   %ebp
  8005c4:	89 e5                	mov    %esp,%ebp
  8005c6:	53                   	push   %ebx
  8005c7:	83 ec 14             	sub    $0x14,%esp
  8005ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8005cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005d6:	8b 45 18             	mov    0x18(%ebp),%eax
  8005d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8005de:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005e1:	77 55                	ja     800638 <printnum+0x75>
  8005e3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005e6:	72 05                	jb     8005ed <printnum+0x2a>
  8005e8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005eb:	77 4b                	ja     800638 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005ed:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005f0:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005f3:	8b 45 18             	mov    0x18(%ebp),%eax
  8005f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8005fb:	52                   	push   %edx
  8005fc:	50                   	push   %eax
  8005fd:	ff 75 f4             	pushl  -0xc(%ebp)
  800600:	ff 75 f0             	pushl  -0x10(%ebp)
  800603:	e8 38 2f 00 00       	call   803540 <__udivdi3>
  800608:	83 c4 10             	add    $0x10,%esp
  80060b:	83 ec 04             	sub    $0x4,%esp
  80060e:	ff 75 20             	pushl  0x20(%ebp)
  800611:	53                   	push   %ebx
  800612:	ff 75 18             	pushl  0x18(%ebp)
  800615:	52                   	push   %edx
  800616:	50                   	push   %eax
  800617:	ff 75 0c             	pushl  0xc(%ebp)
  80061a:	ff 75 08             	pushl  0x8(%ebp)
  80061d:	e8 a1 ff ff ff       	call   8005c3 <printnum>
  800622:	83 c4 20             	add    $0x20,%esp
  800625:	eb 1a                	jmp    800641 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800627:	83 ec 08             	sub    $0x8,%esp
  80062a:	ff 75 0c             	pushl  0xc(%ebp)
  80062d:	ff 75 20             	pushl  0x20(%ebp)
  800630:	8b 45 08             	mov    0x8(%ebp),%eax
  800633:	ff d0                	call   *%eax
  800635:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800638:	ff 4d 1c             	decl   0x1c(%ebp)
  80063b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80063f:	7f e6                	jg     800627 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800641:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800644:	bb 00 00 00 00       	mov    $0x0,%ebx
  800649:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80064c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80064f:	53                   	push   %ebx
  800650:	51                   	push   %ecx
  800651:	52                   	push   %edx
  800652:	50                   	push   %eax
  800653:	e8 f8 2f 00 00       	call   803650 <__umoddi3>
  800658:	83 c4 10             	add    $0x10,%esp
  80065b:	05 14 3b 80 00       	add    $0x803b14,%eax
  800660:	8a 00                	mov    (%eax),%al
  800662:	0f be c0             	movsbl %al,%eax
  800665:	83 ec 08             	sub    $0x8,%esp
  800668:	ff 75 0c             	pushl  0xc(%ebp)
  80066b:	50                   	push   %eax
  80066c:	8b 45 08             	mov    0x8(%ebp),%eax
  80066f:	ff d0                	call   *%eax
  800671:	83 c4 10             	add    $0x10,%esp
}
  800674:	90                   	nop
  800675:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800678:	c9                   	leave  
  800679:	c3                   	ret    

0080067a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80067a:	55                   	push   %ebp
  80067b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80067d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800681:	7e 1c                	jle    80069f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800683:	8b 45 08             	mov    0x8(%ebp),%eax
  800686:	8b 00                	mov    (%eax),%eax
  800688:	8d 50 08             	lea    0x8(%eax),%edx
  80068b:	8b 45 08             	mov    0x8(%ebp),%eax
  80068e:	89 10                	mov    %edx,(%eax)
  800690:	8b 45 08             	mov    0x8(%ebp),%eax
  800693:	8b 00                	mov    (%eax),%eax
  800695:	83 e8 08             	sub    $0x8,%eax
  800698:	8b 50 04             	mov    0x4(%eax),%edx
  80069b:	8b 00                	mov    (%eax),%eax
  80069d:	eb 40                	jmp    8006df <getuint+0x65>
	else if (lflag)
  80069f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006a3:	74 1e                	je     8006c3 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a8:	8b 00                	mov    (%eax),%eax
  8006aa:	8d 50 04             	lea    0x4(%eax),%edx
  8006ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b0:	89 10                	mov    %edx,(%eax)
  8006b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b5:	8b 00                	mov    (%eax),%eax
  8006b7:	83 e8 04             	sub    $0x4,%eax
  8006ba:	8b 00                	mov    (%eax),%eax
  8006bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c1:	eb 1c                	jmp    8006df <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c6:	8b 00                	mov    (%eax),%eax
  8006c8:	8d 50 04             	lea    0x4(%eax),%edx
  8006cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ce:	89 10                	mov    %edx,(%eax)
  8006d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d3:	8b 00                	mov    (%eax),%eax
  8006d5:	83 e8 04             	sub    $0x4,%eax
  8006d8:	8b 00                	mov    (%eax),%eax
  8006da:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006df:	5d                   	pop    %ebp
  8006e0:	c3                   	ret    

008006e1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006e1:	55                   	push   %ebp
  8006e2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006e4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006e8:	7e 1c                	jle    800706 <getint+0x25>
		return va_arg(*ap, long long);
  8006ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ed:	8b 00                	mov    (%eax),%eax
  8006ef:	8d 50 08             	lea    0x8(%eax),%edx
  8006f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f5:	89 10                	mov    %edx,(%eax)
  8006f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fa:	8b 00                	mov    (%eax),%eax
  8006fc:	83 e8 08             	sub    $0x8,%eax
  8006ff:	8b 50 04             	mov    0x4(%eax),%edx
  800702:	8b 00                	mov    (%eax),%eax
  800704:	eb 38                	jmp    80073e <getint+0x5d>
	else if (lflag)
  800706:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80070a:	74 1a                	je     800726 <getint+0x45>
		return va_arg(*ap, long);
  80070c:	8b 45 08             	mov    0x8(%ebp),%eax
  80070f:	8b 00                	mov    (%eax),%eax
  800711:	8d 50 04             	lea    0x4(%eax),%edx
  800714:	8b 45 08             	mov    0x8(%ebp),%eax
  800717:	89 10                	mov    %edx,(%eax)
  800719:	8b 45 08             	mov    0x8(%ebp),%eax
  80071c:	8b 00                	mov    (%eax),%eax
  80071e:	83 e8 04             	sub    $0x4,%eax
  800721:	8b 00                	mov    (%eax),%eax
  800723:	99                   	cltd   
  800724:	eb 18                	jmp    80073e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800726:	8b 45 08             	mov    0x8(%ebp),%eax
  800729:	8b 00                	mov    (%eax),%eax
  80072b:	8d 50 04             	lea    0x4(%eax),%edx
  80072e:	8b 45 08             	mov    0x8(%ebp),%eax
  800731:	89 10                	mov    %edx,(%eax)
  800733:	8b 45 08             	mov    0x8(%ebp),%eax
  800736:	8b 00                	mov    (%eax),%eax
  800738:	83 e8 04             	sub    $0x4,%eax
  80073b:	8b 00                	mov    (%eax),%eax
  80073d:	99                   	cltd   
}
  80073e:	5d                   	pop    %ebp
  80073f:	c3                   	ret    

00800740 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800740:	55                   	push   %ebp
  800741:	89 e5                	mov    %esp,%ebp
  800743:	56                   	push   %esi
  800744:	53                   	push   %ebx
  800745:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800748:	eb 17                	jmp    800761 <vprintfmt+0x21>
			if (ch == '\0')
  80074a:	85 db                	test   %ebx,%ebx
  80074c:	0f 84 af 03 00 00    	je     800b01 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800752:	83 ec 08             	sub    $0x8,%esp
  800755:	ff 75 0c             	pushl  0xc(%ebp)
  800758:	53                   	push   %ebx
  800759:	8b 45 08             	mov    0x8(%ebp),%eax
  80075c:	ff d0                	call   *%eax
  80075e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800761:	8b 45 10             	mov    0x10(%ebp),%eax
  800764:	8d 50 01             	lea    0x1(%eax),%edx
  800767:	89 55 10             	mov    %edx,0x10(%ebp)
  80076a:	8a 00                	mov    (%eax),%al
  80076c:	0f b6 d8             	movzbl %al,%ebx
  80076f:	83 fb 25             	cmp    $0x25,%ebx
  800772:	75 d6                	jne    80074a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800774:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800778:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80077f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800786:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80078d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800794:	8b 45 10             	mov    0x10(%ebp),%eax
  800797:	8d 50 01             	lea    0x1(%eax),%edx
  80079a:	89 55 10             	mov    %edx,0x10(%ebp)
  80079d:	8a 00                	mov    (%eax),%al
  80079f:	0f b6 d8             	movzbl %al,%ebx
  8007a2:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007a5:	83 f8 55             	cmp    $0x55,%eax
  8007a8:	0f 87 2b 03 00 00    	ja     800ad9 <vprintfmt+0x399>
  8007ae:	8b 04 85 38 3b 80 00 	mov    0x803b38(,%eax,4),%eax
  8007b5:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007b7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007bb:	eb d7                	jmp    800794 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007bd:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007c1:	eb d1                	jmp    800794 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007c3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007ca:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007cd:	89 d0                	mov    %edx,%eax
  8007cf:	c1 e0 02             	shl    $0x2,%eax
  8007d2:	01 d0                	add    %edx,%eax
  8007d4:	01 c0                	add    %eax,%eax
  8007d6:	01 d8                	add    %ebx,%eax
  8007d8:	83 e8 30             	sub    $0x30,%eax
  8007db:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007de:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e1:	8a 00                	mov    (%eax),%al
  8007e3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007e6:	83 fb 2f             	cmp    $0x2f,%ebx
  8007e9:	7e 3e                	jle    800829 <vprintfmt+0xe9>
  8007eb:	83 fb 39             	cmp    $0x39,%ebx
  8007ee:	7f 39                	jg     800829 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007f0:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007f3:	eb d5                	jmp    8007ca <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f8:	83 c0 04             	add    $0x4,%eax
  8007fb:	89 45 14             	mov    %eax,0x14(%ebp)
  8007fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800801:	83 e8 04             	sub    $0x4,%eax
  800804:	8b 00                	mov    (%eax),%eax
  800806:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800809:	eb 1f                	jmp    80082a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80080b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80080f:	79 83                	jns    800794 <vprintfmt+0x54>
				width = 0;
  800811:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800818:	e9 77 ff ff ff       	jmp    800794 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80081d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800824:	e9 6b ff ff ff       	jmp    800794 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800829:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80082a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80082e:	0f 89 60 ff ff ff    	jns    800794 <vprintfmt+0x54>
				width = precision, precision = -1;
  800834:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800837:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80083a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800841:	e9 4e ff ff ff       	jmp    800794 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800846:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800849:	e9 46 ff ff ff       	jmp    800794 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80084e:	8b 45 14             	mov    0x14(%ebp),%eax
  800851:	83 c0 04             	add    $0x4,%eax
  800854:	89 45 14             	mov    %eax,0x14(%ebp)
  800857:	8b 45 14             	mov    0x14(%ebp),%eax
  80085a:	83 e8 04             	sub    $0x4,%eax
  80085d:	8b 00                	mov    (%eax),%eax
  80085f:	83 ec 08             	sub    $0x8,%esp
  800862:	ff 75 0c             	pushl  0xc(%ebp)
  800865:	50                   	push   %eax
  800866:	8b 45 08             	mov    0x8(%ebp),%eax
  800869:	ff d0                	call   *%eax
  80086b:	83 c4 10             	add    $0x10,%esp
			break;
  80086e:	e9 89 02 00 00       	jmp    800afc <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800873:	8b 45 14             	mov    0x14(%ebp),%eax
  800876:	83 c0 04             	add    $0x4,%eax
  800879:	89 45 14             	mov    %eax,0x14(%ebp)
  80087c:	8b 45 14             	mov    0x14(%ebp),%eax
  80087f:	83 e8 04             	sub    $0x4,%eax
  800882:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800884:	85 db                	test   %ebx,%ebx
  800886:	79 02                	jns    80088a <vprintfmt+0x14a>
				err = -err;
  800888:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80088a:	83 fb 64             	cmp    $0x64,%ebx
  80088d:	7f 0b                	jg     80089a <vprintfmt+0x15a>
  80088f:	8b 34 9d 80 39 80 00 	mov    0x803980(,%ebx,4),%esi
  800896:	85 f6                	test   %esi,%esi
  800898:	75 19                	jne    8008b3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80089a:	53                   	push   %ebx
  80089b:	68 25 3b 80 00       	push   $0x803b25
  8008a0:	ff 75 0c             	pushl  0xc(%ebp)
  8008a3:	ff 75 08             	pushl  0x8(%ebp)
  8008a6:	e8 5e 02 00 00       	call   800b09 <printfmt>
  8008ab:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008ae:	e9 49 02 00 00       	jmp    800afc <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008b3:	56                   	push   %esi
  8008b4:	68 2e 3b 80 00       	push   $0x803b2e
  8008b9:	ff 75 0c             	pushl  0xc(%ebp)
  8008bc:	ff 75 08             	pushl  0x8(%ebp)
  8008bf:	e8 45 02 00 00       	call   800b09 <printfmt>
  8008c4:	83 c4 10             	add    $0x10,%esp
			break;
  8008c7:	e9 30 02 00 00       	jmp    800afc <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cf:	83 c0 04             	add    $0x4,%eax
  8008d2:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d8:	83 e8 04             	sub    $0x4,%eax
  8008db:	8b 30                	mov    (%eax),%esi
  8008dd:	85 f6                	test   %esi,%esi
  8008df:	75 05                	jne    8008e6 <vprintfmt+0x1a6>
				p = "(null)";
  8008e1:	be 31 3b 80 00       	mov    $0x803b31,%esi
			if (width > 0 && padc != '-')
  8008e6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ea:	7e 6d                	jle    800959 <vprintfmt+0x219>
  8008ec:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008f0:	74 67                	je     800959 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f5:	83 ec 08             	sub    $0x8,%esp
  8008f8:	50                   	push   %eax
  8008f9:	56                   	push   %esi
  8008fa:	e8 0c 03 00 00       	call   800c0b <strnlen>
  8008ff:	83 c4 10             	add    $0x10,%esp
  800902:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800905:	eb 16                	jmp    80091d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800907:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80090b:	83 ec 08             	sub    $0x8,%esp
  80090e:	ff 75 0c             	pushl  0xc(%ebp)
  800911:	50                   	push   %eax
  800912:	8b 45 08             	mov    0x8(%ebp),%eax
  800915:	ff d0                	call   *%eax
  800917:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80091a:	ff 4d e4             	decl   -0x1c(%ebp)
  80091d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800921:	7f e4                	jg     800907 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800923:	eb 34                	jmp    800959 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800925:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800929:	74 1c                	je     800947 <vprintfmt+0x207>
  80092b:	83 fb 1f             	cmp    $0x1f,%ebx
  80092e:	7e 05                	jle    800935 <vprintfmt+0x1f5>
  800930:	83 fb 7e             	cmp    $0x7e,%ebx
  800933:	7e 12                	jle    800947 <vprintfmt+0x207>
					putch('?', putdat);
  800935:	83 ec 08             	sub    $0x8,%esp
  800938:	ff 75 0c             	pushl  0xc(%ebp)
  80093b:	6a 3f                	push   $0x3f
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	ff d0                	call   *%eax
  800942:	83 c4 10             	add    $0x10,%esp
  800945:	eb 0f                	jmp    800956 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800947:	83 ec 08             	sub    $0x8,%esp
  80094a:	ff 75 0c             	pushl  0xc(%ebp)
  80094d:	53                   	push   %ebx
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	ff d0                	call   *%eax
  800953:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800956:	ff 4d e4             	decl   -0x1c(%ebp)
  800959:	89 f0                	mov    %esi,%eax
  80095b:	8d 70 01             	lea    0x1(%eax),%esi
  80095e:	8a 00                	mov    (%eax),%al
  800960:	0f be d8             	movsbl %al,%ebx
  800963:	85 db                	test   %ebx,%ebx
  800965:	74 24                	je     80098b <vprintfmt+0x24b>
  800967:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80096b:	78 b8                	js     800925 <vprintfmt+0x1e5>
  80096d:	ff 4d e0             	decl   -0x20(%ebp)
  800970:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800974:	79 af                	jns    800925 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800976:	eb 13                	jmp    80098b <vprintfmt+0x24b>
				putch(' ', putdat);
  800978:	83 ec 08             	sub    $0x8,%esp
  80097b:	ff 75 0c             	pushl  0xc(%ebp)
  80097e:	6a 20                	push   $0x20
  800980:	8b 45 08             	mov    0x8(%ebp),%eax
  800983:	ff d0                	call   *%eax
  800985:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800988:	ff 4d e4             	decl   -0x1c(%ebp)
  80098b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80098f:	7f e7                	jg     800978 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800991:	e9 66 01 00 00       	jmp    800afc <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800996:	83 ec 08             	sub    $0x8,%esp
  800999:	ff 75 e8             	pushl  -0x18(%ebp)
  80099c:	8d 45 14             	lea    0x14(%ebp),%eax
  80099f:	50                   	push   %eax
  8009a0:	e8 3c fd ff ff       	call   8006e1 <getint>
  8009a5:	83 c4 10             	add    $0x10,%esp
  8009a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ab:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009b4:	85 d2                	test   %edx,%edx
  8009b6:	79 23                	jns    8009db <vprintfmt+0x29b>
				putch('-', putdat);
  8009b8:	83 ec 08             	sub    $0x8,%esp
  8009bb:	ff 75 0c             	pushl  0xc(%ebp)
  8009be:	6a 2d                	push   $0x2d
  8009c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c3:	ff d0                	call   *%eax
  8009c5:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009ce:	f7 d8                	neg    %eax
  8009d0:	83 d2 00             	adc    $0x0,%edx
  8009d3:	f7 da                	neg    %edx
  8009d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009d8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009db:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009e2:	e9 bc 00 00 00       	jmp    800aa3 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009e7:	83 ec 08             	sub    $0x8,%esp
  8009ea:	ff 75 e8             	pushl  -0x18(%ebp)
  8009ed:	8d 45 14             	lea    0x14(%ebp),%eax
  8009f0:	50                   	push   %eax
  8009f1:	e8 84 fc ff ff       	call   80067a <getuint>
  8009f6:	83 c4 10             	add    $0x10,%esp
  8009f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009fc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009ff:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a06:	e9 98 00 00 00       	jmp    800aa3 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a0b:	83 ec 08             	sub    $0x8,%esp
  800a0e:	ff 75 0c             	pushl  0xc(%ebp)
  800a11:	6a 58                	push   $0x58
  800a13:	8b 45 08             	mov    0x8(%ebp),%eax
  800a16:	ff d0                	call   *%eax
  800a18:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a1b:	83 ec 08             	sub    $0x8,%esp
  800a1e:	ff 75 0c             	pushl  0xc(%ebp)
  800a21:	6a 58                	push   $0x58
  800a23:	8b 45 08             	mov    0x8(%ebp),%eax
  800a26:	ff d0                	call   *%eax
  800a28:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a2b:	83 ec 08             	sub    $0x8,%esp
  800a2e:	ff 75 0c             	pushl  0xc(%ebp)
  800a31:	6a 58                	push   $0x58
  800a33:	8b 45 08             	mov    0x8(%ebp),%eax
  800a36:	ff d0                	call   *%eax
  800a38:	83 c4 10             	add    $0x10,%esp
			break;
  800a3b:	e9 bc 00 00 00       	jmp    800afc <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a40:	83 ec 08             	sub    $0x8,%esp
  800a43:	ff 75 0c             	pushl  0xc(%ebp)
  800a46:	6a 30                	push   $0x30
  800a48:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4b:	ff d0                	call   *%eax
  800a4d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a50:	83 ec 08             	sub    $0x8,%esp
  800a53:	ff 75 0c             	pushl  0xc(%ebp)
  800a56:	6a 78                	push   $0x78
  800a58:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5b:	ff d0                	call   *%eax
  800a5d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a60:	8b 45 14             	mov    0x14(%ebp),%eax
  800a63:	83 c0 04             	add    $0x4,%eax
  800a66:	89 45 14             	mov    %eax,0x14(%ebp)
  800a69:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6c:	83 e8 04             	sub    $0x4,%eax
  800a6f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a71:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a74:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a7b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a82:	eb 1f                	jmp    800aa3 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a84:	83 ec 08             	sub    $0x8,%esp
  800a87:	ff 75 e8             	pushl  -0x18(%ebp)
  800a8a:	8d 45 14             	lea    0x14(%ebp),%eax
  800a8d:	50                   	push   %eax
  800a8e:	e8 e7 fb ff ff       	call   80067a <getuint>
  800a93:	83 c4 10             	add    $0x10,%esp
  800a96:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a99:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a9c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800aa3:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800aa7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aaa:	83 ec 04             	sub    $0x4,%esp
  800aad:	52                   	push   %edx
  800aae:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ab1:	50                   	push   %eax
  800ab2:	ff 75 f4             	pushl  -0xc(%ebp)
  800ab5:	ff 75 f0             	pushl  -0x10(%ebp)
  800ab8:	ff 75 0c             	pushl  0xc(%ebp)
  800abb:	ff 75 08             	pushl  0x8(%ebp)
  800abe:	e8 00 fb ff ff       	call   8005c3 <printnum>
  800ac3:	83 c4 20             	add    $0x20,%esp
			break;
  800ac6:	eb 34                	jmp    800afc <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ac8:	83 ec 08             	sub    $0x8,%esp
  800acb:	ff 75 0c             	pushl  0xc(%ebp)
  800ace:	53                   	push   %ebx
  800acf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad2:	ff d0                	call   *%eax
  800ad4:	83 c4 10             	add    $0x10,%esp
			break;
  800ad7:	eb 23                	jmp    800afc <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ad9:	83 ec 08             	sub    $0x8,%esp
  800adc:	ff 75 0c             	pushl  0xc(%ebp)
  800adf:	6a 25                	push   $0x25
  800ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae4:	ff d0                	call   *%eax
  800ae6:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ae9:	ff 4d 10             	decl   0x10(%ebp)
  800aec:	eb 03                	jmp    800af1 <vprintfmt+0x3b1>
  800aee:	ff 4d 10             	decl   0x10(%ebp)
  800af1:	8b 45 10             	mov    0x10(%ebp),%eax
  800af4:	48                   	dec    %eax
  800af5:	8a 00                	mov    (%eax),%al
  800af7:	3c 25                	cmp    $0x25,%al
  800af9:	75 f3                	jne    800aee <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800afb:	90                   	nop
		}
	}
  800afc:	e9 47 fc ff ff       	jmp    800748 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b01:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b02:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b05:	5b                   	pop    %ebx
  800b06:	5e                   	pop    %esi
  800b07:	5d                   	pop    %ebp
  800b08:	c3                   	ret    

00800b09 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b09:	55                   	push   %ebp
  800b0a:	89 e5                	mov    %esp,%ebp
  800b0c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b0f:	8d 45 10             	lea    0x10(%ebp),%eax
  800b12:	83 c0 04             	add    $0x4,%eax
  800b15:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b18:	8b 45 10             	mov    0x10(%ebp),%eax
  800b1b:	ff 75 f4             	pushl  -0xc(%ebp)
  800b1e:	50                   	push   %eax
  800b1f:	ff 75 0c             	pushl  0xc(%ebp)
  800b22:	ff 75 08             	pushl  0x8(%ebp)
  800b25:	e8 16 fc ff ff       	call   800740 <vprintfmt>
  800b2a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b2d:	90                   	nop
  800b2e:	c9                   	leave  
  800b2f:	c3                   	ret    

00800b30 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b30:	55                   	push   %ebp
  800b31:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b36:	8b 40 08             	mov    0x8(%eax),%eax
  800b39:	8d 50 01             	lea    0x1(%eax),%edx
  800b3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b45:	8b 10                	mov    (%eax),%edx
  800b47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4a:	8b 40 04             	mov    0x4(%eax),%eax
  800b4d:	39 c2                	cmp    %eax,%edx
  800b4f:	73 12                	jae    800b63 <sprintputch+0x33>
		*b->buf++ = ch;
  800b51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b54:	8b 00                	mov    (%eax),%eax
  800b56:	8d 48 01             	lea    0x1(%eax),%ecx
  800b59:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b5c:	89 0a                	mov    %ecx,(%edx)
  800b5e:	8b 55 08             	mov    0x8(%ebp),%edx
  800b61:	88 10                	mov    %dl,(%eax)
}
  800b63:	90                   	nop
  800b64:	5d                   	pop    %ebp
  800b65:	c3                   	ret    

00800b66 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b66:	55                   	push   %ebp
  800b67:	89 e5                	mov    %esp,%ebp
  800b69:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b75:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b78:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7b:	01 d0                	add    %edx,%eax
  800b7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b80:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b87:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b8b:	74 06                	je     800b93 <vsnprintf+0x2d>
  800b8d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b91:	7f 07                	jg     800b9a <vsnprintf+0x34>
		return -E_INVAL;
  800b93:	b8 03 00 00 00       	mov    $0x3,%eax
  800b98:	eb 20                	jmp    800bba <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b9a:	ff 75 14             	pushl  0x14(%ebp)
  800b9d:	ff 75 10             	pushl  0x10(%ebp)
  800ba0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ba3:	50                   	push   %eax
  800ba4:	68 30 0b 80 00       	push   $0x800b30
  800ba9:	e8 92 fb ff ff       	call   800740 <vprintfmt>
  800bae:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bb1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bb4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bba:	c9                   	leave  
  800bbb:	c3                   	ret    

00800bbc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bbc:	55                   	push   %ebp
  800bbd:	89 e5                	mov    %esp,%ebp
  800bbf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bc2:	8d 45 10             	lea    0x10(%ebp),%eax
  800bc5:	83 c0 04             	add    $0x4,%eax
  800bc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bcb:	8b 45 10             	mov    0x10(%ebp),%eax
  800bce:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd1:	50                   	push   %eax
  800bd2:	ff 75 0c             	pushl  0xc(%ebp)
  800bd5:	ff 75 08             	pushl  0x8(%ebp)
  800bd8:	e8 89 ff ff ff       	call   800b66 <vsnprintf>
  800bdd:	83 c4 10             	add    $0x10,%esp
  800be0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800be3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800be6:	c9                   	leave  
  800be7:	c3                   	ret    

00800be8 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800be8:	55                   	push   %ebp
  800be9:	89 e5                	mov    %esp,%ebp
  800beb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bf5:	eb 06                	jmp    800bfd <strlen+0x15>
		n++;
  800bf7:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bfa:	ff 45 08             	incl   0x8(%ebp)
  800bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800c00:	8a 00                	mov    (%eax),%al
  800c02:	84 c0                	test   %al,%al
  800c04:	75 f1                	jne    800bf7 <strlen+0xf>
		n++;
	return n;
  800c06:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c09:	c9                   	leave  
  800c0a:	c3                   	ret    

00800c0b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c0b:	55                   	push   %ebp
  800c0c:	89 e5                	mov    %esp,%ebp
  800c0e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c11:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c18:	eb 09                	jmp    800c23 <strnlen+0x18>
		n++;
  800c1a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c1d:	ff 45 08             	incl   0x8(%ebp)
  800c20:	ff 4d 0c             	decl   0xc(%ebp)
  800c23:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c27:	74 09                	je     800c32 <strnlen+0x27>
  800c29:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2c:	8a 00                	mov    (%eax),%al
  800c2e:	84 c0                	test   %al,%al
  800c30:	75 e8                	jne    800c1a <strnlen+0xf>
		n++;
	return n;
  800c32:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c35:	c9                   	leave  
  800c36:	c3                   	ret    

00800c37 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c37:	55                   	push   %ebp
  800c38:	89 e5                	mov    %esp,%ebp
  800c3a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c40:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c43:	90                   	nop
  800c44:	8b 45 08             	mov    0x8(%ebp),%eax
  800c47:	8d 50 01             	lea    0x1(%eax),%edx
  800c4a:	89 55 08             	mov    %edx,0x8(%ebp)
  800c4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c50:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c53:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c56:	8a 12                	mov    (%edx),%dl
  800c58:	88 10                	mov    %dl,(%eax)
  800c5a:	8a 00                	mov    (%eax),%al
  800c5c:	84 c0                	test   %al,%al
  800c5e:	75 e4                	jne    800c44 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c60:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c63:	c9                   	leave  
  800c64:	c3                   	ret    

00800c65 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c65:	55                   	push   %ebp
  800c66:	89 e5                	mov    %esp,%ebp
  800c68:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c71:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c78:	eb 1f                	jmp    800c99 <strncpy+0x34>
		*dst++ = *src;
  800c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7d:	8d 50 01             	lea    0x1(%eax),%edx
  800c80:	89 55 08             	mov    %edx,0x8(%ebp)
  800c83:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c86:	8a 12                	mov    (%edx),%dl
  800c88:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8d:	8a 00                	mov    (%eax),%al
  800c8f:	84 c0                	test   %al,%al
  800c91:	74 03                	je     800c96 <strncpy+0x31>
			src++;
  800c93:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c96:	ff 45 fc             	incl   -0x4(%ebp)
  800c99:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c9c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c9f:	72 d9                	jb     800c7a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ca1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ca4:	c9                   	leave  
  800ca5:	c3                   	ret    

00800ca6 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ca6:	55                   	push   %ebp
  800ca7:	89 e5                	mov    %esp,%ebp
  800ca9:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cac:	8b 45 08             	mov    0x8(%ebp),%eax
  800caf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cb2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cb6:	74 30                	je     800ce8 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cb8:	eb 16                	jmp    800cd0 <strlcpy+0x2a>
			*dst++ = *src++;
  800cba:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbd:	8d 50 01             	lea    0x1(%eax),%edx
  800cc0:	89 55 08             	mov    %edx,0x8(%ebp)
  800cc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cc6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cc9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ccc:	8a 12                	mov    (%edx),%dl
  800cce:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cd0:	ff 4d 10             	decl   0x10(%ebp)
  800cd3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cd7:	74 09                	je     800ce2 <strlcpy+0x3c>
  800cd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cdc:	8a 00                	mov    (%eax),%al
  800cde:	84 c0                	test   %al,%al
  800ce0:	75 d8                	jne    800cba <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ce8:	8b 55 08             	mov    0x8(%ebp),%edx
  800ceb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cee:	29 c2                	sub    %eax,%edx
  800cf0:	89 d0                	mov    %edx,%eax
}
  800cf2:	c9                   	leave  
  800cf3:	c3                   	ret    

00800cf4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cf4:	55                   	push   %ebp
  800cf5:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cf7:	eb 06                	jmp    800cff <strcmp+0xb>
		p++, q++;
  800cf9:	ff 45 08             	incl   0x8(%ebp)
  800cfc:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cff:	8b 45 08             	mov    0x8(%ebp),%eax
  800d02:	8a 00                	mov    (%eax),%al
  800d04:	84 c0                	test   %al,%al
  800d06:	74 0e                	je     800d16 <strcmp+0x22>
  800d08:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0b:	8a 10                	mov    (%eax),%dl
  800d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d10:	8a 00                	mov    (%eax),%al
  800d12:	38 c2                	cmp    %al,%dl
  800d14:	74 e3                	je     800cf9 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d16:	8b 45 08             	mov    0x8(%ebp),%eax
  800d19:	8a 00                	mov    (%eax),%al
  800d1b:	0f b6 d0             	movzbl %al,%edx
  800d1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d21:	8a 00                	mov    (%eax),%al
  800d23:	0f b6 c0             	movzbl %al,%eax
  800d26:	29 c2                	sub    %eax,%edx
  800d28:	89 d0                	mov    %edx,%eax
}
  800d2a:	5d                   	pop    %ebp
  800d2b:	c3                   	ret    

00800d2c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d2c:	55                   	push   %ebp
  800d2d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d2f:	eb 09                	jmp    800d3a <strncmp+0xe>
		n--, p++, q++;
  800d31:	ff 4d 10             	decl   0x10(%ebp)
  800d34:	ff 45 08             	incl   0x8(%ebp)
  800d37:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d3a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d3e:	74 17                	je     800d57 <strncmp+0x2b>
  800d40:	8b 45 08             	mov    0x8(%ebp),%eax
  800d43:	8a 00                	mov    (%eax),%al
  800d45:	84 c0                	test   %al,%al
  800d47:	74 0e                	je     800d57 <strncmp+0x2b>
  800d49:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4c:	8a 10                	mov    (%eax),%dl
  800d4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d51:	8a 00                	mov    (%eax),%al
  800d53:	38 c2                	cmp    %al,%dl
  800d55:	74 da                	je     800d31 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d57:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d5b:	75 07                	jne    800d64 <strncmp+0x38>
		return 0;
  800d5d:	b8 00 00 00 00       	mov    $0x0,%eax
  800d62:	eb 14                	jmp    800d78 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d64:	8b 45 08             	mov    0x8(%ebp),%eax
  800d67:	8a 00                	mov    (%eax),%al
  800d69:	0f b6 d0             	movzbl %al,%edx
  800d6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6f:	8a 00                	mov    (%eax),%al
  800d71:	0f b6 c0             	movzbl %al,%eax
  800d74:	29 c2                	sub    %eax,%edx
  800d76:	89 d0                	mov    %edx,%eax
}
  800d78:	5d                   	pop    %ebp
  800d79:	c3                   	ret    

00800d7a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d7a:	55                   	push   %ebp
  800d7b:	89 e5                	mov    %esp,%ebp
  800d7d:	83 ec 04             	sub    $0x4,%esp
  800d80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d83:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d86:	eb 12                	jmp    800d9a <strchr+0x20>
		if (*s == c)
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	8a 00                	mov    (%eax),%al
  800d8d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d90:	75 05                	jne    800d97 <strchr+0x1d>
			return (char *) s;
  800d92:	8b 45 08             	mov    0x8(%ebp),%eax
  800d95:	eb 11                	jmp    800da8 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d97:	ff 45 08             	incl   0x8(%ebp)
  800d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9d:	8a 00                	mov    (%eax),%al
  800d9f:	84 c0                	test   %al,%al
  800da1:	75 e5                	jne    800d88 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800da3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800da8:	c9                   	leave  
  800da9:	c3                   	ret    

00800daa <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800daa:	55                   	push   %ebp
  800dab:	89 e5                	mov    %esp,%ebp
  800dad:	83 ec 04             	sub    $0x4,%esp
  800db0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800db6:	eb 0d                	jmp    800dc5 <strfind+0x1b>
		if (*s == c)
  800db8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbb:	8a 00                	mov    (%eax),%al
  800dbd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dc0:	74 0e                	je     800dd0 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dc2:	ff 45 08             	incl   0x8(%ebp)
  800dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc8:	8a 00                	mov    (%eax),%al
  800dca:	84 c0                	test   %al,%al
  800dcc:	75 ea                	jne    800db8 <strfind+0xe>
  800dce:	eb 01                	jmp    800dd1 <strfind+0x27>
		if (*s == c)
			break;
  800dd0:	90                   	nop
	return (char *) s;
  800dd1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dd4:	c9                   	leave  
  800dd5:	c3                   	ret    

00800dd6 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800dd6:	55                   	push   %ebp
  800dd7:	89 e5                	mov    %esp,%ebp
  800dd9:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800de2:	8b 45 10             	mov    0x10(%ebp),%eax
  800de5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800de8:	eb 0e                	jmp    800df8 <memset+0x22>
		*p++ = c;
  800dea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ded:	8d 50 01             	lea    0x1(%eax),%edx
  800df0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800df3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800df6:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800df8:	ff 4d f8             	decl   -0x8(%ebp)
  800dfb:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dff:	79 e9                	jns    800dea <memset+0x14>
		*p++ = c;

	return v;
  800e01:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e04:	c9                   	leave  
  800e05:	c3                   	ret    

00800e06 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e06:	55                   	push   %ebp
  800e07:	89 e5                	mov    %esp,%ebp
  800e09:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e12:	8b 45 08             	mov    0x8(%ebp),%eax
  800e15:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e18:	eb 16                	jmp    800e30 <memcpy+0x2a>
		*d++ = *s++;
  800e1a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e1d:	8d 50 01             	lea    0x1(%eax),%edx
  800e20:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e23:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e26:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e29:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e2c:	8a 12                	mov    (%edx),%dl
  800e2e:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e30:	8b 45 10             	mov    0x10(%ebp),%eax
  800e33:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e36:	89 55 10             	mov    %edx,0x10(%ebp)
  800e39:	85 c0                	test   %eax,%eax
  800e3b:	75 dd                	jne    800e1a <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e3d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e40:	c9                   	leave  
  800e41:	c3                   	ret    

00800e42 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e42:	55                   	push   %ebp
  800e43:	89 e5                	mov    %esp,%ebp
  800e45:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e51:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e54:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e57:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e5a:	73 50                	jae    800eac <memmove+0x6a>
  800e5c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e5f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e62:	01 d0                	add    %edx,%eax
  800e64:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e67:	76 43                	jbe    800eac <memmove+0x6a>
		s += n;
  800e69:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e6f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e72:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e75:	eb 10                	jmp    800e87 <memmove+0x45>
			*--d = *--s;
  800e77:	ff 4d f8             	decl   -0x8(%ebp)
  800e7a:	ff 4d fc             	decl   -0x4(%ebp)
  800e7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e80:	8a 10                	mov    (%eax),%dl
  800e82:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e85:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e87:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e8d:	89 55 10             	mov    %edx,0x10(%ebp)
  800e90:	85 c0                	test   %eax,%eax
  800e92:	75 e3                	jne    800e77 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e94:	eb 23                	jmp    800eb9 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e96:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e99:	8d 50 01             	lea    0x1(%eax),%edx
  800e9c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e9f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ea2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ea5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ea8:	8a 12                	mov    (%edx),%dl
  800eaa:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800eac:	8b 45 10             	mov    0x10(%ebp),%eax
  800eaf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eb2:	89 55 10             	mov    %edx,0x10(%ebp)
  800eb5:	85 c0                	test   %eax,%eax
  800eb7:	75 dd                	jne    800e96 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800eb9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ebc:	c9                   	leave  
  800ebd:	c3                   	ret    

00800ebe <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ebe:	55                   	push   %ebp
  800ebf:	89 e5                	mov    %esp,%ebp
  800ec1:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800eca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecd:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ed0:	eb 2a                	jmp    800efc <memcmp+0x3e>
		if (*s1 != *s2)
  800ed2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed5:	8a 10                	mov    (%eax),%dl
  800ed7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eda:	8a 00                	mov    (%eax),%al
  800edc:	38 c2                	cmp    %al,%dl
  800ede:	74 16                	je     800ef6 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ee0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee3:	8a 00                	mov    (%eax),%al
  800ee5:	0f b6 d0             	movzbl %al,%edx
  800ee8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eeb:	8a 00                	mov    (%eax),%al
  800eed:	0f b6 c0             	movzbl %al,%eax
  800ef0:	29 c2                	sub    %eax,%edx
  800ef2:	89 d0                	mov    %edx,%eax
  800ef4:	eb 18                	jmp    800f0e <memcmp+0x50>
		s1++, s2++;
  800ef6:	ff 45 fc             	incl   -0x4(%ebp)
  800ef9:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800efc:	8b 45 10             	mov    0x10(%ebp),%eax
  800eff:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f02:	89 55 10             	mov    %edx,0x10(%ebp)
  800f05:	85 c0                	test   %eax,%eax
  800f07:	75 c9                	jne    800ed2 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f09:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f0e:	c9                   	leave  
  800f0f:	c3                   	ret    

00800f10 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f10:	55                   	push   %ebp
  800f11:	89 e5                	mov    %esp,%ebp
  800f13:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f16:	8b 55 08             	mov    0x8(%ebp),%edx
  800f19:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1c:	01 d0                	add    %edx,%eax
  800f1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f21:	eb 15                	jmp    800f38 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f23:	8b 45 08             	mov    0x8(%ebp),%eax
  800f26:	8a 00                	mov    (%eax),%al
  800f28:	0f b6 d0             	movzbl %al,%edx
  800f2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2e:	0f b6 c0             	movzbl %al,%eax
  800f31:	39 c2                	cmp    %eax,%edx
  800f33:	74 0d                	je     800f42 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f35:	ff 45 08             	incl   0x8(%ebp)
  800f38:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f3e:	72 e3                	jb     800f23 <memfind+0x13>
  800f40:	eb 01                	jmp    800f43 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f42:	90                   	nop
	return (void *) s;
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f46:	c9                   	leave  
  800f47:	c3                   	ret    

00800f48 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f48:	55                   	push   %ebp
  800f49:	89 e5                	mov    %esp,%ebp
  800f4b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f4e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f55:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f5c:	eb 03                	jmp    800f61 <strtol+0x19>
		s++;
  800f5e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f61:	8b 45 08             	mov    0x8(%ebp),%eax
  800f64:	8a 00                	mov    (%eax),%al
  800f66:	3c 20                	cmp    $0x20,%al
  800f68:	74 f4                	je     800f5e <strtol+0x16>
  800f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6d:	8a 00                	mov    (%eax),%al
  800f6f:	3c 09                	cmp    $0x9,%al
  800f71:	74 eb                	je     800f5e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f73:	8b 45 08             	mov    0x8(%ebp),%eax
  800f76:	8a 00                	mov    (%eax),%al
  800f78:	3c 2b                	cmp    $0x2b,%al
  800f7a:	75 05                	jne    800f81 <strtol+0x39>
		s++;
  800f7c:	ff 45 08             	incl   0x8(%ebp)
  800f7f:	eb 13                	jmp    800f94 <strtol+0x4c>
	else if (*s == '-')
  800f81:	8b 45 08             	mov    0x8(%ebp),%eax
  800f84:	8a 00                	mov    (%eax),%al
  800f86:	3c 2d                	cmp    $0x2d,%al
  800f88:	75 0a                	jne    800f94 <strtol+0x4c>
		s++, neg = 1;
  800f8a:	ff 45 08             	incl   0x8(%ebp)
  800f8d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f94:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f98:	74 06                	je     800fa0 <strtol+0x58>
  800f9a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f9e:	75 20                	jne    800fc0 <strtol+0x78>
  800fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa3:	8a 00                	mov    (%eax),%al
  800fa5:	3c 30                	cmp    $0x30,%al
  800fa7:	75 17                	jne    800fc0 <strtol+0x78>
  800fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fac:	40                   	inc    %eax
  800fad:	8a 00                	mov    (%eax),%al
  800faf:	3c 78                	cmp    $0x78,%al
  800fb1:	75 0d                	jne    800fc0 <strtol+0x78>
		s += 2, base = 16;
  800fb3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fb7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fbe:	eb 28                	jmp    800fe8 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fc0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fc4:	75 15                	jne    800fdb <strtol+0x93>
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc9:	8a 00                	mov    (%eax),%al
  800fcb:	3c 30                	cmp    $0x30,%al
  800fcd:	75 0c                	jne    800fdb <strtol+0x93>
		s++, base = 8;
  800fcf:	ff 45 08             	incl   0x8(%ebp)
  800fd2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fd9:	eb 0d                	jmp    800fe8 <strtol+0xa0>
	else if (base == 0)
  800fdb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fdf:	75 07                	jne    800fe8 <strtol+0xa0>
		base = 10;
  800fe1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  800feb:	8a 00                	mov    (%eax),%al
  800fed:	3c 2f                	cmp    $0x2f,%al
  800fef:	7e 19                	jle    80100a <strtol+0xc2>
  800ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff4:	8a 00                	mov    (%eax),%al
  800ff6:	3c 39                	cmp    $0x39,%al
  800ff8:	7f 10                	jg     80100a <strtol+0xc2>
			dig = *s - '0';
  800ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffd:	8a 00                	mov    (%eax),%al
  800fff:	0f be c0             	movsbl %al,%eax
  801002:	83 e8 30             	sub    $0x30,%eax
  801005:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801008:	eb 42                	jmp    80104c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80100a:	8b 45 08             	mov    0x8(%ebp),%eax
  80100d:	8a 00                	mov    (%eax),%al
  80100f:	3c 60                	cmp    $0x60,%al
  801011:	7e 19                	jle    80102c <strtol+0xe4>
  801013:	8b 45 08             	mov    0x8(%ebp),%eax
  801016:	8a 00                	mov    (%eax),%al
  801018:	3c 7a                	cmp    $0x7a,%al
  80101a:	7f 10                	jg     80102c <strtol+0xe4>
			dig = *s - 'a' + 10;
  80101c:	8b 45 08             	mov    0x8(%ebp),%eax
  80101f:	8a 00                	mov    (%eax),%al
  801021:	0f be c0             	movsbl %al,%eax
  801024:	83 e8 57             	sub    $0x57,%eax
  801027:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80102a:	eb 20                	jmp    80104c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80102c:	8b 45 08             	mov    0x8(%ebp),%eax
  80102f:	8a 00                	mov    (%eax),%al
  801031:	3c 40                	cmp    $0x40,%al
  801033:	7e 39                	jle    80106e <strtol+0x126>
  801035:	8b 45 08             	mov    0x8(%ebp),%eax
  801038:	8a 00                	mov    (%eax),%al
  80103a:	3c 5a                	cmp    $0x5a,%al
  80103c:	7f 30                	jg     80106e <strtol+0x126>
			dig = *s - 'A' + 10;
  80103e:	8b 45 08             	mov    0x8(%ebp),%eax
  801041:	8a 00                	mov    (%eax),%al
  801043:	0f be c0             	movsbl %al,%eax
  801046:	83 e8 37             	sub    $0x37,%eax
  801049:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80104c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80104f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801052:	7d 19                	jge    80106d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801054:	ff 45 08             	incl   0x8(%ebp)
  801057:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80105a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80105e:	89 c2                	mov    %eax,%edx
  801060:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801063:	01 d0                	add    %edx,%eax
  801065:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801068:	e9 7b ff ff ff       	jmp    800fe8 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80106d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80106e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801072:	74 08                	je     80107c <strtol+0x134>
		*endptr = (char *) s;
  801074:	8b 45 0c             	mov    0xc(%ebp),%eax
  801077:	8b 55 08             	mov    0x8(%ebp),%edx
  80107a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80107c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801080:	74 07                	je     801089 <strtol+0x141>
  801082:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801085:	f7 d8                	neg    %eax
  801087:	eb 03                	jmp    80108c <strtol+0x144>
  801089:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80108c:	c9                   	leave  
  80108d:	c3                   	ret    

0080108e <ltostr>:

void
ltostr(long value, char *str)
{
  80108e:	55                   	push   %ebp
  80108f:	89 e5                	mov    %esp,%ebp
  801091:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801094:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80109b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010a6:	79 13                	jns    8010bb <ltostr+0x2d>
	{
		neg = 1;
  8010a8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b2:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010b5:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010b8:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010be:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010c3:	99                   	cltd   
  8010c4:	f7 f9                	idiv   %ecx
  8010c6:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010cc:	8d 50 01             	lea    0x1(%eax),%edx
  8010cf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010d2:	89 c2                	mov    %eax,%edx
  8010d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d7:	01 d0                	add    %edx,%eax
  8010d9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010dc:	83 c2 30             	add    $0x30,%edx
  8010df:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010e4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010e9:	f7 e9                	imul   %ecx
  8010eb:	c1 fa 02             	sar    $0x2,%edx
  8010ee:	89 c8                	mov    %ecx,%eax
  8010f0:	c1 f8 1f             	sar    $0x1f,%eax
  8010f3:	29 c2                	sub    %eax,%edx
  8010f5:	89 d0                	mov    %edx,%eax
  8010f7:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010fd:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801102:	f7 e9                	imul   %ecx
  801104:	c1 fa 02             	sar    $0x2,%edx
  801107:	89 c8                	mov    %ecx,%eax
  801109:	c1 f8 1f             	sar    $0x1f,%eax
  80110c:	29 c2                	sub    %eax,%edx
  80110e:	89 d0                	mov    %edx,%eax
  801110:	c1 e0 02             	shl    $0x2,%eax
  801113:	01 d0                	add    %edx,%eax
  801115:	01 c0                	add    %eax,%eax
  801117:	29 c1                	sub    %eax,%ecx
  801119:	89 ca                	mov    %ecx,%edx
  80111b:	85 d2                	test   %edx,%edx
  80111d:	75 9c                	jne    8010bb <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80111f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801126:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801129:	48                   	dec    %eax
  80112a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80112d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801131:	74 3d                	je     801170 <ltostr+0xe2>
		start = 1 ;
  801133:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80113a:	eb 34                	jmp    801170 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80113c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80113f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801142:	01 d0                	add    %edx,%eax
  801144:	8a 00                	mov    (%eax),%al
  801146:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801149:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80114c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114f:	01 c2                	add    %eax,%edx
  801151:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801154:	8b 45 0c             	mov    0xc(%ebp),%eax
  801157:	01 c8                	add    %ecx,%eax
  801159:	8a 00                	mov    (%eax),%al
  80115b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80115d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801160:	8b 45 0c             	mov    0xc(%ebp),%eax
  801163:	01 c2                	add    %eax,%edx
  801165:	8a 45 eb             	mov    -0x15(%ebp),%al
  801168:	88 02                	mov    %al,(%edx)
		start++ ;
  80116a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80116d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801170:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801173:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801176:	7c c4                	jl     80113c <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801178:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80117b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117e:	01 d0                	add    %edx,%eax
  801180:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801183:	90                   	nop
  801184:	c9                   	leave  
  801185:	c3                   	ret    

00801186 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801186:	55                   	push   %ebp
  801187:	89 e5                	mov    %esp,%ebp
  801189:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80118c:	ff 75 08             	pushl  0x8(%ebp)
  80118f:	e8 54 fa ff ff       	call   800be8 <strlen>
  801194:	83 c4 04             	add    $0x4,%esp
  801197:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80119a:	ff 75 0c             	pushl  0xc(%ebp)
  80119d:	e8 46 fa ff ff       	call   800be8 <strlen>
  8011a2:	83 c4 04             	add    $0x4,%esp
  8011a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011a8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011b6:	eb 17                	jmp    8011cf <strcconcat+0x49>
		final[s] = str1[s] ;
  8011b8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8011be:	01 c2                	add    %eax,%edx
  8011c0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c6:	01 c8                	add    %ecx,%eax
  8011c8:	8a 00                	mov    (%eax),%al
  8011ca:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011cc:	ff 45 fc             	incl   -0x4(%ebp)
  8011cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011d5:	7c e1                	jl     8011b8 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011d7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011de:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011e5:	eb 1f                	jmp    801206 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ea:	8d 50 01             	lea    0x1(%eax),%edx
  8011ed:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011f0:	89 c2                	mov    %eax,%edx
  8011f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f5:	01 c2                	add    %eax,%edx
  8011f7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fd:	01 c8                	add    %ecx,%eax
  8011ff:	8a 00                	mov    (%eax),%al
  801201:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801203:	ff 45 f8             	incl   -0x8(%ebp)
  801206:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801209:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80120c:	7c d9                	jl     8011e7 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80120e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801211:	8b 45 10             	mov    0x10(%ebp),%eax
  801214:	01 d0                	add    %edx,%eax
  801216:	c6 00 00             	movb   $0x0,(%eax)
}
  801219:	90                   	nop
  80121a:	c9                   	leave  
  80121b:	c3                   	ret    

0080121c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80121c:	55                   	push   %ebp
  80121d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80121f:	8b 45 14             	mov    0x14(%ebp),%eax
  801222:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801228:	8b 45 14             	mov    0x14(%ebp),%eax
  80122b:	8b 00                	mov    (%eax),%eax
  80122d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801234:	8b 45 10             	mov    0x10(%ebp),%eax
  801237:	01 d0                	add    %edx,%eax
  801239:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80123f:	eb 0c                	jmp    80124d <strsplit+0x31>
			*string++ = 0;
  801241:	8b 45 08             	mov    0x8(%ebp),%eax
  801244:	8d 50 01             	lea    0x1(%eax),%edx
  801247:	89 55 08             	mov    %edx,0x8(%ebp)
  80124a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80124d:	8b 45 08             	mov    0x8(%ebp),%eax
  801250:	8a 00                	mov    (%eax),%al
  801252:	84 c0                	test   %al,%al
  801254:	74 18                	je     80126e <strsplit+0x52>
  801256:	8b 45 08             	mov    0x8(%ebp),%eax
  801259:	8a 00                	mov    (%eax),%al
  80125b:	0f be c0             	movsbl %al,%eax
  80125e:	50                   	push   %eax
  80125f:	ff 75 0c             	pushl  0xc(%ebp)
  801262:	e8 13 fb ff ff       	call   800d7a <strchr>
  801267:	83 c4 08             	add    $0x8,%esp
  80126a:	85 c0                	test   %eax,%eax
  80126c:	75 d3                	jne    801241 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80126e:	8b 45 08             	mov    0x8(%ebp),%eax
  801271:	8a 00                	mov    (%eax),%al
  801273:	84 c0                	test   %al,%al
  801275:	74 5a                	je     8012d1 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801277:	8b 45 14             	mov    0x14(%ebp),%eax
  80127a:	8b 00                	mov    (%eax),%eax
  80127c:	83 f8 0f             	cmp    $0xf,%eax
  80127f:	75 07                	jne    801288 <strsplit+0x6c>
		{
			return 0;
  801281:	b8 00 00 00 00       	mov    $0x0,%eax
  801286:	eb 66                	jmp    8012ee <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801288:	8b 45 14             	mov    0x14(%ebp),%eax
  80128b:	8b 00                	mov    (%eax),%eax
  80128d:	8d 48 01             	lea    0x1(%eax),%ecx
  801290:	8b 55 14             	mov    0x14(%ebp),%edx
  801293:	89 0a                	mov    %ecx,(%edx)
  801295:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80129c:	8b 45 10             	mov    0x10(%ebp),%eax
  80129f:	01 c2                	add    %eax,%edx
  8012a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a4:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012a6:	eb 03                	jmp    8012ab <strsplit+0x8f>
			string++;
  8012a8:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ae:	8a 00                	mov    (%eax),%al
  8012b0:	84 c0                	test   %al,%al
  8012b2:	74 8b                	je     80123f <strsplit+0x23>
  8012b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b7:	8a 00                	mov    (%eax),%al
  8012b9:	0f be c0             	movsbl %al,%eax
  8012bc:	50                   	push   %eax
  8012bd:	ff 75 0c             	pushl  0xc(%ebp)
  8012c0:	e8 b5 fa ff ff       	call   800d7a <strchr>
  8012c5:	83 c4 08             	add    $0x8,%esp
  8012c8:	85 c0                	test   %eax,%eax
  8012ca:	74 dc                	je     8012a8 <strsplit+0x8c>
			string++;
	}
  8012cc:	e9 6e ff ff ff       	jmp    80123f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012d1:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8012d5:	8b 00                	mov    (%eax),%eax
  8012d7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012de:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e1:	01 d0                	add    %edx,%eax
  8012e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012e9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012ee:	c9                   	leave  
  8012ef:	c3                   	ret    

008012f0 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8012f0:	55                   	push   %ebp
  8012f1:	89 e5                	mov    %esp,%ebp
  8012f3:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8012f6:	a1 04 50 80 00       	mov    0x805004,%eax
  8012fb:	85 c0                	test   %eax,%eax
  8012fd:	74 1f                	je     80131e <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8012ff:	e8 1d 00 00 00       	call   801321 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801304:	83 ec 0c             	sub    $0xc,%esp
  801307:	68 90 3c 80 00       	push   $0x803c90
  80130c:	e8 55 f2 ff ff       	call   800566 <cprintf>
  801311:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801314:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  80131b:	00 00 00 
	}
}
  80131e:	90                   	nop
  80131f:	c9                   	leave  
  801320:	c3                   	ret    

00801321 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801321:	55                   	push   %ebp
  801322:	89 e5                	mov    %esp,%ebp
  801324:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  801327:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  80132e:	00 00 00 
  801331:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801338:	00 00 00 
  80133b:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801342:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801345:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  80134c:	00 00 00 
  80134f:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801356:	00 00 00 
  801359:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801360:	00 00 00 
	uint32 arr_size = 0;
  801363:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  80136a:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801371:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801374:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801379:	2d 00 10 00 00       	sub    $0x1000,%eax
  80137e:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  801383:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  80138a:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  80138d:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801394:	a1 20 51 80 00       	mov    0x805120,%eax
  801399:	c1 e0 04             	shl    $0x4,%eax
  80139c:	89 c2                	mov    %eax,%edx
  80139e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013a1:	01 d0                	add    %edx,%eax
  8013a3:	48                   	dec    %eax
  8013a4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8013a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8013af:	f7 75 ec             	divl   -0x14(%ebp)
  8013b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013b5:	29 d0                	sub    %edx,%eax
  8013b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  8013ba:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8013c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013c4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013c9:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013ce:	83 ec 04             	sub    $0x4,%esp
  8013d1:	6a 06                	push   $0x6
  8013d3:	ff 75 f4             	pushl  -0xc(%ebp)
  8013d6:	50                   	push   %eax
  8013d7:	e8 42 04 00 00       	call   80181e <sys_allocate_chunk>
  8013dc:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013df:	a1 20 51 80 00       	mov    0x805120,%eax
  8013e4:	83 ec 0c             	sub    $0xc,%esp
  8013e7:	50                   	push   %eax
  8013e8:	e8 b7 0a 00 00       	call   801ea4 <initialize_MemBlocksList>
  8013ed:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  8013f0:	a1 48 51 80 00       	mov    0x805148,%eax
  8013f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  8013f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013fb:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  801402:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801405:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  80140c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801410:	75 14                	jne    801426 <initialize_dyn_block_system+0x105>
  801412:	83 ec 04             	sub    $0x4,%esp
  801415:	68 b5 3c 80 00       	push   $0x803cb5
  80141a:	6a 33                	push   $0x33
  80141c:	68 d3 3c 80 00       	push   $0x803cd3
  801421:	e8 37 1f 00 00       	call   80335d <_panic>
  801426:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801429:	8b 00                	mov    (%eax),%eax
  80142b:	85 c0                	test   %eax,%eax
  80142d:	74 10                	je     80143f <initialize_dyn_block_system+0x11e>
  80142f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801432:	8b 00                	mov    (%eax),%eax
  801434:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801437:	8b 52 04             	mov    0x4(%edx),%edx
  80143a:	89 50 04             	mov    %edx,0x4(%eax)
  80143d:	eb 0b                	jmp    80144a <initialize_dyn_block_system+0x129>
  80143f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801442:	8b 40 04             	mov    0x4(%eax),%eax
  801445:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80144a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80144d:	8b 40 04             	mov    0x4(%eax),%eax
  801450:	85 c0                	test   %eax,%eax
  801452:	74 0f                	je     801463 <initialize_dyn_block_system+0x142>
  801454:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801457:	8b 40 04             	mov    0x4(%eax),%eax
  80145a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80145d:	8b 12                	mov    (%edx),%edx
  80145f:	89 10                	mov    %edx,(%eax)
  801461:	eb 0a                	jmp    80146d <initialize_dyn_block_system+0x14c>
  801463:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801466:	8b 00                	mov    (%eax),%eax
  801468:	a3 48 51 80 00       	mov    %eax,0x805148
  80146d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801470:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801476:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801479:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801480:	a1 54 51 80 00       	mov    0x805154,%eax
  801485:	48                   	dec    %eax
  801486:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  80148b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80148f:	75 14                	jne    8014a5 <initialize_dyn_block_system+0x184>
  801491:	83 ec 04             	sub    $0x4,%esp
  801494:	68 e0 3c 80 00       	push   $0x803ce0
  801499:	6a 34                	push   $0x34
  80149b:	68 d3 3c 80 00       	push   $0x803cd3
  8014a0:	e8 b8 1e 00 00       	call   80335d <_panic>
  8014a5:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8014ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014ae:	89 10                	mov    %edx,(%eax)
  8014b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014b3:	8b 00                	mov    (%eax),%eax
  8014b5:	85 c0                	test   %eax,%eax
  8014b7:	74 0d                	je     8014c6 <initialize_dyn_block_system+0x1a5>
  8014b9:	a1 38 51 80 00       	mov    0x805138,%eax
  8014be:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8014c1:	89 50 04             	mov    %edx,0x4(%eax)
  8014c4:	eb 08                	jmp    8014ce <initialize_dyn_block_system+0x1ad>
  8014c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014c9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8014ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014d1:	a3 38 51 80 00       	mov    %eax,0x805138
  8014d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014d9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8014e0:	a1 44 51 80 00       	mov    0x805144,%eax
  8014e5:	40                   	inc    %eax
  8014e6:	a3 44 51 80 00       	mov    %eax,0x805144
}
  8014eb:	90                   	nop
  8014ec:	c9                   	leave  
  8014ed:	c3                   	ret    

008014ee <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8014ee:	55                   	push   %ebp
  8014ef:	89 e5                	mov    %esp,%ebp
  8014f1:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014f4:	e8 f7 fd ff ff       	call   8012f0 <InitializeUHeap>
	if (size == 0) return NULL ;
  8014f9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014fd:	75 07                	jne    801506 <malloc+0x18>
  8014ff:	b8 00 00 00 00       	mov    $0x0,%eax
  801504:	eb 14                	jmp    80151a <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801506:	83 ec 04             	sub    $0x4,%esp
  801509:	68 04 3d 80 00       	push   $0x803d04
  80150e:	6a 46                	push   $0x46
  801510:	68 d3 3c 80 00       	push   $0x803cd3
  801515:	e8 43 1e 00 00       	call   80335d <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  80151a:	c9                   	leave  
  80151b:	c3                   	ret    

0080151c <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80151c:	55                   	push   %ebp
  80151d:	89 e5                	mov    %esp,%ebp
  80151f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801522:	83 ec 04             	sub    $0x4,%esp
  801525:	68 2c 3d 80 00       	push   $0x803d2c
  80152a:	6a 61                	push   $0x61
  80152c:	68 d3 3c 80 00       	push   $0x803cd3
  801531:	e8 27 1e 00 00       	call   80335d <_panic>

00801536 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801536:	55                   	push   %ebp
  801537:	89 e5                	mov    %esp,%ebp
  801539:	83 ec 38             	sub    $0x38,%esp
  80153c:	8b 45 10             	mov    0x10(%ebp),%eax
  80153f:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801542:	e8 a9 fd ff ff       	call   8012f0 <InitializeUHeap>
	if (size == 0) return NULL ;
  801547:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80154b:	75 0a                	jne    801557 <smalloc+0x21>
  80154d:	b8 00 00 00 00       	mov    $0x0,%eax
  801552:	e9 9e 00 00 00       	jmp    8015f5 <smalloc+0xbf>
	//3-If the Kernel successfully creates the shared variable, return its virtual address
	//4-Else, return NULL



	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801557:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80155e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801561:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801564:	01 d0                	add    %edx,%eax
  801566:	48                   	dec    %eax
  801567:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80156a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80156d:	ba 00 00 00 00       	mov    $0x0,%edx
  801572:	f7 75 f0             	divl   -0x10(%ebp)
  801575:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801578:	29 d0                	sub    %edx,%eax
  80157a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  80157d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801584:	e8 63 06 00 00       	call   801bec <sys_isUHeapPlacementStrategyFIRSTFIT>
  801589:	85 c0                	test   %eax,%eax
  80158b:	74 11                	je     80159e <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  80158d:	83 ec 0c             	sub    $0xc,%esp
  801590:	ff 75 e8             	pushl  -0x18(%ebp)
  801593:	e8 ce 0c 00 00       	call   802266 <alloc_block_FF>
  801598:	83 c4 10             	add    $0x10,%esp
  80159b:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  80159e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015a2:	74 4c                	je     8015f0 <smalloc+0xba>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8015a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015a7:	8b 40 08             	mov    0x8(%eax),%eax
  8015aa:	89 c2                	mov    %eax,%edx
  8015ac:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8015b0:	52                   	push   %edx
  8015b1:	50                   	push   %eax
  8015b2:	ff 75 0c             	pushl  0xc(%ebp)
  8015b5:	ff 75 08             	pushl  0x8(%ebp)
  8015b8:	e8 b4 03 00 00       	call   801971 <sys_createSharedObject>
  8015bd:	83 c4 10             	add    $0x10,%esp
  8015c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("Output is :  %d \n" , result);
  8015c3:	83 ec 08             	sub    $0x8,%esp
  8015c6:	ff 75 e0             	pushl  -0x20(%ebp)
  8015c9:	68 4f 3d 80 00       	push   $0x803d4f
  8015ce:	e8 93 ef ff ff       	call   800566 <cprintf>
  8015d3:	83 c4 10             	add    $0x10,%esp
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  8015d6:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8015da:	74 14                	je     8015f0 <smalloc+0xba>
  8015dc:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8015e0:	74 0e                	je     8015f0 <smalloc+0xba>
  8015e2:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  8015e6:	74 08                	je     8015f0 <smalloc+0xba>
			return (void*) mem_block->sva;
  8015e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015eb:	8b 40 08             	mov    0x8(%eax),%eax
  8015ee:	eb 05                	jmp    8015f5 <smalloc+0xbf>
	}
	return NULL;
  8015f0:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8015f5:	c9                   	leave  
  8015f6:	c3                   	ret    

008015f7 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8015f7:	55                   	push   %ebp
  8015f8:	89 e5                	mov    %esp,%ebp
  8015fa:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015fd:	e8 ee fc ff ff       	call   8012f0 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801602:	83 ec 04             	sub    $0x4,%esp
  801605:	68 64 3d 80 00       	push   $0x803d64
  80160a:	68 ab 00 00 00       	push   $0xab
  80160f:	68 d3 3c 80 00       	push   $0x803cd3
  801614:	e8 44 1d 00 00       	call   80335d <_panic>

00801619 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801619:	55                   	push   %ebp
  80161a:	89 e5                	mov    %esp,%ebp
  80161c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80161f:	e8 cc fc ff ff       	call   8012f0 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801624:	83 ec 04             	sub    $0x4,%esp
  801627:	68 88 3d 80 00       	push   $0x803d88
  80162c:	68 ef 00 00 00       	push   $0xef
  801631:	68 d3 3c 80 00       	push   $0x803cd3
  801636:	e8 22 1d 00 00       	call   80335d <_panic>

0080163b <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80163b:	55                   	push   %ebp
  80163c:	89 e5                	mov    %esp,%ebp
  80163e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801641:	83 ec 04             	sub    $0x4,%esp
  801644:	68 b0 3d 80 00       	push   $0x803db0
  801649:	68 03 01 00 00       	push   $0x103
  80164e:	68 d3 3c 80 00       	push   $0x803cd3
  801653:	e8 05 1d 00 00       	call   80335d <_panic>

00801658 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801658:	55                   	push   %ebp
  801659:	89 e5                	mov    %esp,%ebp
  80165b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80165e:	83 ec 04             	sub    $0x4,%esp
  801661:	68 d4 3d 80 00       	push   $0x803dd4
  801666:	68 0e 01 00 00       	push   $0x10e
  80166b:	68 d3 3c 80 00       	push   $0x803cd3
  801670:	e8 e8 1c 00 00       	call   80335d <_panic>

00801675 <shrink>:

}
void shrink(uint32 newSize)
{
  801675:	55                   	push   %ebp
  801676:	89 e5                	mov    %esp,%ebp
  801678:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80167b:	83 ec 04             	sub    $0x4,%esp
  80167e:	68 d4 3d 80 00       	push   $0x803dd4
  801683:	68 13 01 00 00       	push   $0x113
  801688:	68 d3 3c 80 00       	push   $0x803cd3
  80168d:	e8 cb 1c 00 00       	call   80335d <_panic>

00801692 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801692:	55                   	push   %ebp
  801693:	89 e5                	mov    %esp,%ebp
  801695:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801698:	83 ec 04             	sub    $0x4,%esp
  80169b:	68 d4 3d 80 00       	push   $0x803dd4
  8016a0:	68 18 01 00 00       	push   $0x118
  8016a5:	68 d3 3c 80 00       	push   $0x803cd3
  8016aa:	e8 ae 1c 00 00       	call   80335d <_panic>

008016af <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8016af:	55                   	push   %ebp
  8016b0:	89 e5                	mov    %esp,%ebp
  8016b2:	57                   	push   %edi
  8016b3:	56                   	push   %esi
  8016b4:	53                   	push   %ebx
  8016b5:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016be:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016c1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016c4:	8b 7d 18             	mov    0x18(%ebp),%edi
  8016c7:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8016ca:	cd 30                	int    $0x30
  8016cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8016cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8016d2:	83 c4 10             	add    $0x10,%esp
  8016d5:	5b                   	pop    %ebx
  8016d6:	5e                   	pop    %esi
  8016d7:	5f                   	pop    %edi
  8016d8:	5d                   	pop    %ebp
  8016d9:	c3                   	ret    

008016da <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8016da:	55                   	push   %ebp
  8016db:	89 e5                	mov    %esp,%ebp
  8016dd:	83 ec 04             	sub    $0x4,%esp
  8016e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8016e3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8016e6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ed:	6a 00                	push   $0x0
  8016ef:	6a 00                	push   $0x0
  8016f1:	52                   	push   %edx
  8016f2:	ff 75 0c             	pushl  0xc(%ebp)
  8016f5:	50                   	push   %eax
  8016f6:	6a 00                	push   $0x0
  8016f8:	e8 b2 ff ff ff       	call   8016af <syscall>
  8016fd:	83 c4 18             	add    $0x18,%esp
}
  801700:	90                   	nop
  801701:	c9                   	leave  
  801702:	c3                   	ret    

00801703 <sys_cgetc>:

int
sys_cgetc(void)
{
  801703:	55                   	push   %ebp
  801704:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801706:	6a 00                	push   $0x0
  801708:	6a 00                	push   $0x0
  80170a:	6a 00                	push   $0x0
  80170c:	6a 00                	push   $0x0
  80170e:	6a 00                	push   $0x0
  801710:	6a 01                	push   $0x1
  801712:	e8 98 ff ff ff       	call   8016af <syscall>
  801717:	83 c4 18             	add    $0x18,%esp
}
  80171a:	c9                   	leave  
  80171b:	c3                   	ret    

0080171c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80171c:	55                   	push   %ebp
  80171d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80171f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801722:	8b 45 08             	mov    0x8(%ebp),%eax
  801725:	6a 00                	push   $0x0
  801727:	6a 00                	push   $0x0
  801729:	6a 00                	push   $0x0
  80172b:	52                   	push   %edx
  80172c:	50                   	push   %eax
  80172d:	6a 05                	push   $0x5
  80172f:	e8 7b ff ff ff       	call   8016af <syscall>
  801734:	83 c4 18             	add    $0x18,%esp
}
  801737:	c9                   	leave  
  801738:	c3                   	ret    

00801739 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801739:	55                   	push   %ebp
  80173a:	89 e5                	mov    %esp,%ebp
  80173c:	56                   	push   %esi
  80173d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80173e:	8b 75 18             	mov    0x18(%ebp),%esi
  801741:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801744:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801747:	8b 55 0c             	mov    0xc(%ebp),%edx
  80174a:	8b 45 08             	mov    0x8(%ebp),%eax
  80174d:	56                   	push   %esi
  80174e:	53                   	push   %ebx
  80174f:	51                   	push   %ecx
  801750:	52                   	push   %edx
  801751:	50                   	push   %eax
  801752:	6a 06                	push   $0x6
  801754:	e8 56 ff ff ff       	call   8016af <syscall>
  801759:	83 c4 18             	add    $0x18,%esp
}
  80175c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80175f:	5b                   	pop    %ebx
  801760:	5e                   	pop    %esi
  801761:	5d                   	pop    %ebp
  801762:	c3                   	ret    

00801763 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801763:	55                   	push   %ebp
  801764:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801766:	8b 55 0c             	mov    0xc(%ebp),%edx
  801769:	8b 45 08             	mov    0x8(%ebp),%eax
  80176c:	6a 00                	push   $0x0
  80176e:	6a 00                	push   $0x0
  801770:	6a 00                	push   $0x0
  801772:	52                   	push   %edx
  801773:	50                   	push   %eax
  801774:	6a 07                	push   $0x7
  801776:	e8 34 ff ff ff       	call   8016af <syscall>
  80177b:	83 c4 18             	add    $0x18,%esp
}
  80177e:	c9                   	leave  
  80177f:	c3                   	ret    

00801780 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801780:	55                   	push   %ebp
  801781:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801783:	6a 00                	push   $0x0
  801785:	6a 00                	push   $0x0
  801787:	6a 00                	push   $0x0
  801789:	ff 75 0c             	pushl  0xc(%ebp)
  80178c:	ff 75 08             	pushl  0x8(%ebp)
  80178f:	6a 08                	push   $0x8
  801791:	e8 19 ff ff ff       	call   8016af <syscall>
  801796:	83 c4 18             	add    $0x18,%esp
}
  801799:	c9                   	leave  
  80179a:	c3                   	ret    

0080179b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80179b:	55                   	push   %ebp
  80179c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 00                	push   $0x0
  8017a2:	6a 00                	push   $0x0
  8017a4:	6a 00                	push   $0x0
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 09                	push   $0x9
  8017aa:	e8 00 ff ff ff       	call   8016af <syscall>
  8017af:	83 c4 18             	add    $0x18,%esp
}
  8017b2:	c9                   	leave  
  8017b3:	c3                   	ret    

008017b4 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8017b4:	55                   	push   %ebp
  8017b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8017b7:	6a 00                	push   $0x0
  8017b9:	6a 00                	push   $0x0
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 0a                	push   $0xa
  8017c3:	e8 e7 fe ff ff       	call   8016af <syscall>
  8017c8:	83 c4 18             	add    $0x18,%esp
}
  8017cb:	c9                   	leave  
  8017cc:	c3                   	ret    

008017cd <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8017cd:	55                   	push   %ebp
  8017ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8017d0:	6a 00                	push   $0x0
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 00                	push   $0x0
  8017d6:	6a 00                	push   $0x0
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 0b                	push   $0xb
  8017dc:	e8 ce fe ff ff       	call   8016af <syscall>
  8017e1:	83 c4 18             	add    $0x18,%esp
}
  8017e4:	c9                   	leave  
  8017e5:	c3                   	ret    

008017e6 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8017e6:	55                   	push   %ebp
  8017e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8017e9:	6a 00                	push   $0x0
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 00                	push   $0x0
  8017ef:	ff 75 0c             	pushl  0xc(%ebp)
  8017f2:	ff 75 08             	pushl  0x8(%ebp)
  8017f5:	6a 0f                	push   $0xf
  8017f7:	e8 b3 fe ff ff       	call   8016af <syscall>
  8017fc:	83 c4 18             	add    $0x18,%esp
	return;
  8017ff:	90                   	nop
}
  801800:	c9                   	leave  
  801801:	c3                   	ret    

00801802 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801802:	55                   	push   %ebp
  801803:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801805:	6a 00                	push   $0x0
  801807:	6a 00                	push   $0x0
  801809:	6a 00                	push   $0x0
  80180b:	ff 75 0c             	pushl  0xc(%ebp)
  80180e:	ff 75 08             	pushl  0x8(%ebp)
  801811:	6a 10                	push   $0x10
  801813:	e8 97 fe ff ff       	call   8016af <syscall>
  801818:	83 c4 18             	add    $0x18,%esp
	return ;
  80181b:	90                   	nop
}
  80181c:	c9                   	leave  
  80181d:	c3                   	ret    

0080181e <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80181e:	55                   	push   %ebp
  80181f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801821:	6a 00                	push   $0x0
  801823:	6a 00                	push   $0x0
  801825:	ff 75 10             	pushl  0x10(%ebp)
  801828:	ff 75 0c             	pushl  0xc(%ebp)
  80182b:	ff 75 08             	pushl  0x8(%ebp)
  80182e:	6a 11                	push   $0x11
  801830:	e8 7a fe ff ff       	call   8016af <syscall>
  801835:	83 c4 18             	add    $0x18,%esp
	return ;
  801838:	90                   	nop
}
  801839:	c9                   	leave  
  80183a:	c3                   	ret    

0080183b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80183b:	55                   	push   %ebp
  80183c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	6a 00                	push   $0x0
  801844:	6a 00                	push   $0x0
  801846:	6a 00                	push   $0x0
  801848:	6a 0c                	push   $0xc
  80184a:	e8 60 fe ff ff       	call   8016af <syscall>
  80184f:	83 c4 18             	add    $0x18,%esp
}
  801852:	c9                   	leave  
  801853:	c3                   	ret    

00801854 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801854:	55                   	push   %ebp
  801855:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801857:	6a 00                	push   $0x0
  801859:	6a 00                	push   $0x0
  80185b:	6a 00                	push   $0x0
  80185d:	6a 00                	push   $0x0
  80185f:	ff 75 08             	pushl  0x8(%ebp)
  801862:	6a 0d                	push   $0xd
  801864:	e8 46 fe ff ff       	call   8016af <syscall>
  801869:	83 c4 18             	add    $0x18,%esp
}
  80186c:	c9                   	leave  
  80186d:	c3                   	ret    

0080186e <sys_scarce_memory>:

void sys_scarce_memory()
{
  80186e:	55                   	push   %ebp
  80186f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 0e                	push   $0xe
  80187d:	e8 2d fe ff ff       	call   8016af <syscall>
  801882:	83 c4 18             	add    $0x18,%esp
}
  801885:	90                   	nop
  801886:	c9                   	leave  
  801887:	c3                   	ret    

00801888 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801888:	55                   	push   %ebp
  801889:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	6a 13                	push   $0x13
  801897:	e8 13 fe ff ff       	call   8016af <syscall>
  80189c:	83 c4 18             	add    $0x18,%esp
}
  80189f:	90                   	nop
  8018a0:	c9                   	leave  
  8018a1:	c3                   	ret    

008018a2 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8018a2:	55                   	push   %ebp
  8018a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 14                	push   $0x14
  8018b1:	e8 f9 fd ff ff       	call   8016af <syscall>
  8018b6:	83 c4 18             	add    $0x18,%esp
}
  8018b9:	90                   	nop
  8018ba:	c9                   	leave  
  8018bb:	c3                   	ret    

008018bc <sys_cputc>:


void
sys_cputc(const char c)
{
  8018bc:	55                   	push   %ebp
  8018bd:	89 e5                	mov    %esp,%ebp
  8018bf:	83 ec 04             	sub    $0x4,%esp
  8018c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8018c8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 00                	push   $0x0
  8018d4:	50                   	push   %eax
  8018d5:	6a 15                	push   $0x15
  8018d7:	e8 d3 fd ff ff       	call   8016af <syscall>
  8018dc:	83 c4 18             	add    $0x18,%esp
}
  8018df:	90                   	nop
  8018e0:	c9                   	leave  
  8018e1:	c3                   	ret    

008018e2 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8018e2:	55                   	push   %ebp
  8018e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 16                	push   $0x16
  8018f1:	e8 b9 fd ff ff       	call   8016af <syscall>
  8018f6:	83 c4 18             	add    $0x18,%esp
}
  8018f9:	90                   	nop
  8018fa:	c9                   	leave  
  8018fb:	c3                   	ret    

008018fc <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8018fc:	55                   	push   %ebp
  8018fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8018ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	ff 75 0c             	pushl  0xc(%ebp)
  80190b:	50                   	push   %eax
  80190c:	6a 17                	push   $0x17
  80190e:	e8 9c fd ff ff       	call   8016af <syscall>
  801913:	83 c4 18             	add    $0x18,%esp
}
  801916:	c9                   	leave  
  801917:	c3                   	ret    

00801918 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801918:	55                   	push   %ebp
  801919:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80191b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80191e:	8b 45 08             	mov    0x8(%ebp),%eax
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	52                   	push   %edx
  801928:	50                   	push   %eax
  801929:	6a 1a                	push   $0x1a
  80192b:	e8 7f fd ff ff       	call   8016af <syscall>
  801930:	83 c4 18             	add    $0x18,%esp
}
  801933:	c9                   	leave  
  801934:	c3                   	ret    

00801935 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801935:	55                   	push   %ebp
  801936:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801938:	8b 55 0c             	mov    0xc(%ebp),%edx
  80193b:	8b 45 08             	mov    0x8(%ebp),%eax
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	6a 00                	push   $0x0
  801944:	52                   	push   %edx
  801945:	50                   	push   %eax
  801946:	6a 18                	push   $0x18
  801948:	e8 62 fd ff ff       	call   8016af <syscall>
  80194d:	83 c4 18             	add    $0x18,%esp
}
  801950:	90                   	nop
  801951:	c9                   	leave  
  801952:	c3                   	ret    

00801953 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801953:	55                   	push   %ebp
  801954:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801956:	8b 55 0c             	mov    0xc(%ebp),%edx
  801959:	8b 45 08             	mov    0x8(%ebp),%eax
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	52                   	push   %edx
  801963:	50                   	push   %eax
  801964:	6a 19                	push   $0x19
  801966:	e8 44 fd ff ff       	call   8016af <syscall>
  80196b:	83 c4 18             	add    $0x18,%esp
}
  80196e:	90                   	nop
  80196f:	c9                   	leave  
  801970:	c3                   	ret    

00801971 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801971:	55                   	push   %ebp
  801972:	89 e5                	mov    %esp,%ebp
  801974:	83 ec 04             	sub    $0x4,%esp
  801977:	8b 45 10             	mov    0x10(%ebp),%eax
  80197a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80197d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801980:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801984:	8b 45 08             	mov    0x8(%ebp),%eax
  801987:	6a 00                	push   $0x0
  801989:	51                   	push   %ecx
  80198a:	52                   	push   %edx
  80198b:	ff 75 0c             	pushl  0xc(%ebp)
  80198e:	50                   	push   %eax
  80198f:	6a 1b                	push   $0x1b
  801991:	e8 19 fd ff ff       	call   8016af <syscall>
  801996:	83 c4 18             	add    $0x18,%esp
}
  801999:	c9                   	leave  
  80199a:	c3                   	ret    

0080199b <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80199b:	55                   	push   %ebp
  80199c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80199e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	52                   	push   %edx
  8019ab:	50                   	push   %eax
  8019ac:	6a 1c                	push   $0x1c
  8019ae:	e8 fc fc ff ff       	call   8016af <syscall>
  8019b3:	83 c4 18             	add    $0x18,%esp
}
  8019b6:	c9                   	leave  
  8019b7:	c3                   	ret    

008019b8 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8019b8:	55                   	push   %ebp
  8019b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8019bb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 00                	push   $0x0
  8019c8:	51                   	push   %ecx
  8019c9:	52                   	push   %edx
  8019ca:	50                   	push   %eax
  8019cb:	6a 1d                	push   $0x1d
  8019cd:	e8 dd fc ff ff       	call   8016af <syscall>
  8019d2:	83 c4 18             	add    $0x18,%esp
}
  8019d5:	c9                   	leave  
  8019d6:	c3                   	ret    

008019d7 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8019d7:	55                   	push   %ebp
  8019d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8019da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	52                   	push   %edx
  8019e7:	50                   	push   %eax
  8019e8:	6a 1e                	push   $0x1e
  8019ea:	e8 c0 fc ff ff       	call   8016af <syscall>
  8019ef:	83 c4 18             	add    $0x18,%esp
}
  8019f2:	c9                   	leave  
  8019f3:	c3                   	ret    

008019f4 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8019f4:	55                   	push   %ebp
  8019f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 1f                	push   $0x1f
  801a03:	e8 a7 fc ff ff       	call   8016af <syscall>
  801a08:	83 c4 18             	add    $0x18,%esp
}
  801a0b:	c9                   	leave  
  801a0c:	c3                   	ret    

00801a0d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a0d:	55                   	push   %ebp
  801a0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a10:	8b 45 08             	mov    0x8(%ebp),%eax
  801a13:	6a 00                	push   $0x0
  801a15:	ff 75 14             	pushl  0x14(%ebp)
  801a18:	ff 75 10             	pushl  0x10(%ebp)
  801a1b:	ff 75 0c             	pushl  0xc(%ebp)
  801a1e:	50                   	push   %eax
  801a1f:	6a 20                	push   $0x20
  801a21:	e8 89 fc ff ff       	call   8016af <syscall>
  801a26:	83 c4 18             	add    $0x18,%esp
}
  801a29:	c9                   	leave  
  801a2a:	c3                   	ret    

00801a2b <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801a2b:	55                   	push   %ebp
  801a2c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	50                   	push   %eax
  801a3a:	6a 21                	push   $0x21
  801a3c:	e8 6e fc ff ff       	call   8016af <syscall>
  801a41:	83 c4 18             	add    $0x18,%esp
}
  801a44:	90                   	nop
  801a45:	c9                   	leave  
  801a46:	c3                   	ret    

00801a47 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	50                   	push   %eax
  801a56:	6a 22                	push   $0x22
  801a58:	e8 52 fc ff ff       	call   8016af <syscall>
  801a5d:	83 c4 18             	add    $0x18,%esp
}
  801a60:	c9                   	leave  
  801a61:	c3                   	ret    

00801a62 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a62:	55                   	push   %ebp
  801a63:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 02                	push   $0x2
  801a71:	e8 39 fc ff ff       	call   8016af <syscall>
  801a76:	83 c4 18             	add    $0x18,%esp
}
  801a79:	c9                   	leave  
  801a7a:	c3                   	ret    

00801a7b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a7b:	55                   	push   %ebp
  801a7c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 03                	push   $0x3
  801a8a:	e8 20 fc ff ff       	call   8016af <syscall>
  801a8f:	83 c4 18             	add    $0x18,%esp
}
  801a92:	c9                   	leave  
  801a93:	c3                   	ret    

00801a94 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a94:	55                   	push   %ebp
  801a95:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 04                	push   $0x4
  801aa3:	e8 07 fc ff ff       	call   8016af <syscall>
  801aa8:	83 c4 18             	add    $0x18,%esp
}
  801aab:	c9                   	leave  
  801aac:	c3                   	ret    

00801aad <sys_exit_env>:


void sys_exit_env(void)
{
  801aad:	55                   	push   %ebp
  801aae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 23                	push   $0x23
  801abc:	e8 ee fb ff ff       	call   8016af <syscall>
  801ac1:	83 c4 18             	add    $0x18,%esp
}
  801ac4:	90                   	nop
  801ac5:	c9                   	leave  
  801ac6:	c3                   	ret    

00801ac7 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801ac7:	55                   	push   %ebp
  801ac8:	89 e5                	mov    %esp,%ebp
  801aca:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801acd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ad0:	8d 50 04             	lea    0x4(%eax),%edx
  801ad3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	52                   	push   %edx
  801add:	50                   	push   %eax
  801ade:	6a 24                	push   $0x24
  801ae0:	e8 ca fb ff ff       	call   8016af <syscall>
  801ae5:	83 c4 18             	add    $0x18,%esp
	return result;
  801ae8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801aeb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801aee:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801af1:	89 01                	mov    %eax,(%ecx)
  801af3:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801af6:	8b 45 08             	mov    0x8(%ebp),%eax
  801af9:	c9                   	leave  
  801afa:	c2 04 00             	ret    $0x4

00801afd <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801afd:	55                   	push   %ebp
  801afe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	ff 75 10             	pushl  0x10(%ebp)
  801b07:	ff 75 0c             	pushl  0xc(%ebp)
  801b0a:	ff 75 08             	pushl  0x8(%ebp)
  801b0d:	6a 12                	push   $0x12
  801b0f:	e8 9b fb ff ff       	call   8016af <syscall>
  801b14:	83 c4 18             	add    $0x18,%esp
	return ;
  801b17:	90                   	nop
}
  801b18:	c9                   	leave  
  801b19:	c3                   	ret    

00801b1a <sys_rcr2>:
uint32 sys_rcr2()
{
  801b1a:	55                   	push   %ebp
  801b1b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 25                	push   $0x25
  801b29:	e8 81 fb ff ff       	call   8016af <syscall>
  801b2e:	83 c4 18             	add    $0x18,%esp
}
  801b31:	c9                   	leave  
  801b32:	c3                   	ret    

00801b33 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801b33:	55                   	push   %ebp
  801b34:	89 e5                	mov    %esp,%ebp
  801b36:	83 ec 04             	sub    $0x4,%esp
  801b39:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b3f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	50                   	push   %eax
  801b4c:	6a 26                	push   $0x26
  801b4e:	e8 5c fb ff ff       	call   8016af <syscall>
  801b53:	83 c4 18             	add    $0x18,%esp
	return ;
  801b56:	90                   	nop
}
  801b57:	c9                   	leave  
  801b58:	c3                   	ret    

00801b59 <rsttst>:
void rsttst()
{
  801b59:	55                   	push   %ebp
  801b5a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	6a 28                	push   $0x28
  801b68:	e8 42 fb ff ff       	call   8016af <syscall>
  801b6d:	83 c4 18             	add    $0x18,%esp
	return ;
  801b70:	90                   	nop
}
  801b71:	c9                   	leave  
  801b72:	c3                   	ret    

00801b73 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b73:	55                   	push   %ebp
  801b74:	89 e5                	mov    %esp,%ebp
  801b76:	83 ec 04             	sub    $0x4,%esp
  801b79:	8b 45 14             	mov    0x14(%ebp),%eax
  801b7c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b7f:	8b 55 18             	mov    0x18(%ebp),%edx
  801b82:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b86:	52                   	push   %edx
  801b87:	50                   	push   %eax
  801b88:	ff 75 10             	pushl  0x10(%ebp)
  801b8b:	ff 75 0c             	pushl  0xc(%ebp)
  801b8e:	ff 75 08             	pushl  0x8(%ebp)
  801b91:	6a 27                	push   $0x27
  801b93:	e8 17 fb ff ff       	call   8016af <syscall>
  801b98:	83 c4 18             	add    $0x18,%esp
	return ;
  801b9b:	90                   	nop
}
  801b9c:	c9                   	leave  
  801b9d:	c3                   	ret    

00801b9e <chktst>:
void chktst(uint32 n)
{
  801b9e:	55                   	push   %ebp
  801b9f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	ff 75 08             	pushl  0x8(%ebp)
  801bac:	6a 29                	push   $0x29
  801bae:	e8 fc fa ff ff       	call   8016af <syscall>
  801bb3:	83 c4 18             	add    $0x18,%esp
	return ;
  801bb6:	90                   	nop
}
  801bb7:	c9                   	leave  
  801bb8:	c3                   	ret    

00801bb9 <inctst>:

void inctst()
{
  801bb9:	55                   	push   %ebp
  801bba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 2a                	push   $0x2a
  801bc8:	e8 e2 fa ff ff       	call   8016af <syscall>
  801bcd:	83 c4 18             	add    $0x18,%esp
	return ;
  801bd0:	90                   	nop
}
  801bd1:	c9                   	leave  
  801bd2:	c3                   	ret    

00801bd3 <gettst>:
uint32 gettst()
{
  801bd3:	55                   	push   %ebp
  801bd4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	6a 2b                	push   $0x2b
  801be2:	e8 c8 fa ff ff       	call   8016af <syscall>
  801be7:	83 c4 18             	add    $0x18,%esp
}
  801bea:	c9                   	leave  
  801beb:	c3                   	ret    

00801bec <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801bec:	55                   	push   %ebp
  801bed:	89 e5                	mov    %esp,%ebp
  801bef:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 2c                	push   $0x2c
  801bfe:	e8 ac fa ff ff       	call   8016af <syscall>
  801c03:	83 c4 18             	add    $0x18,%esp
  801c06:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c09:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c0d:	75 07                	jne    801c16 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c0f:	b8 01 00 00 00       	mov    $0x1,%eax
  801c14:	eb 05                	jmp    801c1b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c16:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c1b:	c9                   	leave  
  801c1c:	c3                   	ret    

00801c1d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c1d:	55                   	push   %ebp
  801c1e:	89 e5                	mov    %esp,%ebp
  801c20:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 2c                	push   $0x2c
  801c2f:	e8 7b fa ff ff       	call   8016af <syscall>
  801c34:	83 c4 18             	add    $0x18,%esp
  801c37:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c3a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c3e:	75 07                	jne    801c47 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c40:	b8 01 00 00 00       	mov    $0x1,%eax
  801c45:	eb 05                	jmp    801c4c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c47:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c4c:	c9                   	leave  
  801c4d:	c3                   	ret    

00801c4e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c4e:	55                   	push   %ebp
  801c4f:	89 e5                	mov    %esp,%ebp
  801c51:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 2c                	push   $0x2c
  801c60:	e8 4a fa ff ff       	call   8016af <syscall>
  801c65:	83 c4 18             	add    $0x18,%esp
  801c68:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c6b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c6f:	75 07                	jne    801c78 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c71:	b8 01 00 00 00       	mov    $0x1,%eax
  801c76:	eb 05                	jmp    801c7d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c78:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c7d:	c9                   	leave  
  801c7e:	c3                   	ret    

00801c7f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c7f:	55                   	push   %ebp
  801c80:	89 e5                	mov    %esp,%ebp
  801c82:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 2c                	push   $0x2c
  801c91:	e8 19 fa ff ff       	call   8016af <syscall>
  801c96:	83 c4 18             	add    $0x18,%esp
  801c99:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c9c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ca0:	75 07                	jne    801ca9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ca2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ca7:	eb 05                	jmp    801cae <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ca9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cae:	c9                   	leave  
  801caf:	c3                   	ret    

00801cb0 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801cb0:	55                   	push   %ebp
  801cb1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	ff 75 08             	pushl  0x8(%ebp)
  801cbe:	6a 2d                	push   $0x2d
  801cc0:	e8 ea f9 ff ff       	call   8016af <syscall>
  801cc5:	83 c4 18             	add    $0x18,%esp
	return ;
  801cc8:	90                   	nop
}
  801cc9:	c9                   	leave  
  801cca:	c3                   	ret    

00801ccb <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ccb:	55                   	push   %ebp
  801ccc:	89 e5                	mov    %esp,%ebp
  801cce:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ccf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cd2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cd5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdb:	6a 00                	push   $0x0
  801cdd:	53                   	push   %ebx
  801cde:	51                   	push   %ecx
  801cdf:	52                   	push   %edx
  801ce0:	50                   	push   %eax
  801ce1:	6a 2e                	push   $0x2e
  801ce3:	e8 c7 f9 ff ff       	call   8016af <syscall>
  801ce8:	83 c4 18             	add    $0x18,%esp
}
  801ceb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cee:	c9                   	leave  
  801cef:	c3                   	ret    

00801cf0 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801cf0:	55                   	push   %ebp
  801cf1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801cf3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	52                   	push   %edx
  801d00:	50                   	push   %eax
  801d01:	6a 2f                	push   $0x2f
  801d03:	e8 a7 f9 ff ff       	call   8016af <syscall>
  801d08:	83 c4 18             	add    $0x18,%esp
}
  801d0b:	c9                   	leave  
  801d0c:	c3                   	ret    

00801d0d <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801d0d:	55                   	push   %ebp
  801d0e:	89 e5                	mov    %esp,%ebp
  801d10:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801d13:	83 ec 0c             	sub    $0xc,%esp
  801d16:	68 e4 3d 80 00       	push   $0x803de4
  801d1b:	e8 46 e8 ff ff       	call   800566 <cprintf>
  801d20:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801d23:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801d2a:	83 ec 0c             	sub    $0xc,%esp
  801d2d:	68 10 3e 80 00       	push   $0x803e10
  801d32:	e8 2f e8 ff ff       	call   800566 <cprintf>
  801d37:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801d3a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d3e:	a1 38 51 80 00       	mov    0x805138,%eax
  801d43:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d46:	eb 56                	jmp    801d9e <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d48:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d4c:	74 1c                	je     801d6a <print_mem_block_lists+0x5d>
  801d4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d51:	8b 50 08             	mov    0x8(%eax),%edx
  801d54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d57:	8b 48 08             	mov    0x8(%eax),%ecx
  801d5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d5d:	8b 40 0c             	mov    0xc(%eax),%eax
  801d60:	01 c8                	add    %ecx,%eax
  801d62:	39 c2                	cmp    %eax,%edx
  801d64:	73 04                	jae    801d6a <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801d66:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d6d:	8b 50 08             	mov    0x8(%eax),%edx
  801d70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d73:	8b 40 0c             	mov    0xc(%eax),%eax
  801d76:	01 c2                	add    %eax,%edx
  801d78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d7b:	8b 40 08             	mov    0x8(%eax),%eax
  801d7e:	83 ec 04             	sub    $0x4,%esp
  801d81:	52                   	push   %edx
  801d82:	50                   	push   %eax
  801d83:	68 25 3e 80 00       	push   $0x803e25
  801d88:	e8 d9 e7 ff ff       	call   800566 <cprintf>
  801d8d:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d93:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d96:	a1 40 51 80 00       	mov    0x805140,%eax
  801d9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801da2:	74 07                	je     801dab <print_mem_block_lists+0x9e>
  801da4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da7:	8b 00                	mov    (%eax),%eax
  801da9:	eb 05                	jmp    801db0 <print_mem_block_lists+0xa3>
  801dab:	b8 00 00 00 00       	mov    $0x0,%eax
  801db0:	a3 40 51 80 00       	mov    %eax,0x805140
  801db5:	a1 40 51 80 00       	mov    0x805140,%eax
  801dba:	85 c0                	test   %eax,%eax
  801dbc:	75 8a                	jne    801d48 <print_mem_block_lists+0x3b>
  801dbe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dc2:	75 84                	jne    801d48 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801dc4:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801dc8:	75 10                	jne    801dda <print_mem_block_lists+0xcd>
  801dca:	83 ec 0c             	sub    $0xc,%esp
  801dcd:	68 34 3e 80 00       	push   $0x803e34
  801dd2:	e8 8f e7 ff ff       	call   800566 <cprintf>
  801dd7:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801dda:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801de1:	83 ec 0c             	sub    $0xc,%esp
  801de4:	68 58 3e 80 00       	push   $0x803e58
  801de9:	e8 78 e7 ff ff       	call   800566 <cprintf>
  801dee:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801df1:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801df5:	a1 40 50 80 00       	mov    0x805040,%eax
  801dfa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dfd:	eb 56                	jmp    801e55 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801dff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e03:	74 1c                	je     801e21 <print_mem_block_lists+0x114>
  801e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e08:	8b 50 08             	mov    0x8(%eax),%edx
  801e0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e0e:	8b 48 08             	mov    0x8(%eax),%ecx
  801e11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e14:	8b 40 0c             	mov    0xc(%eax),%eax
  801e17:	01 c8                	add    %ecx,%eax
  801e19:	39 c2                	cmp    %eax,%edx
  801e1b:	73 04                	jae    801e21 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801e1d:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e24:	8b 50 08             	mov    0x8(%eax),%edx
  801e27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e2a:	8b 40 0c             	mov    0xc(%eax),%eax
  801e2d:	01 c2                	add    %eax,%edx
  801e2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e32:	8b 40 08             	mov    0x8(%eax),%eax
  801e35:	83 ec 04             	sub    $0x4,%esp
  801e38:	52                   	push   %edx
  801e39:	50                   	push   %eax
  801e3a:	68 25 3e 80 00       	push   $0x803e25
  801e3f:	e8 22 e7 ff ff       	call   800566 <cprintf>
  801e44:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e4d:	a1 48 50 80 00       	mov    0x805048,%eax
  801e52:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e55:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e59:	74 07                	je     801e62 <print_mem_block_lists+0x155>
  801e5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e5e:	8b 00                	mov    (%eax),%eax
  801e60:	eb 05                	jmp    801e67 <print_mem_block_lists+0x15a>
  801e62:	b8 00 00 00 00       	mov    $0x0,%eax
  801e67:	a3 48 50 80 00       	mov    %eax,0x805048
  801e6c:	a1 48 50 80 00       	mov    0x805048,%eax
  801e71:	85 c0                	test   %eax,%eax
  801e73:	75 8a                	jne    801dff <print_mem_block_lists+0xf2>
  801e75:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e79:	75 84                	jne    801dff <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801e7b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e7f:	75 10                	jne    801e91 <print_mem_block_lists+0x184>
  801e81:	83 ec 0c             	sub    $0xc,%esp
  801e84:	68 70 3e 80 00       	push   $0x803e70
  801e89:	e8 d8 e6 ff ff       	call   800566 <cprintf>
  801e8e:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801e91:	83 ec 0c             	sub    $0xc,%esp
  801e94:	68 e4 3d 80 00       	push   $0x803de4
  801e99:	e8 c8 e6 ff ff       	call   800566 <cprintf>
  801e9e:	83 c4 10             	add    $0x10,%esp

}
  801ea1:	90                   	nop
  801ea2:	c9                   	leave  
  801ea3:	c3                   	ret    

00801ea4 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801ea4:	55                   	push   %ebp
  801ea5:	89 e5                	mov    %esp,%ebp
  801ea7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801eaa:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801eb1:	00 00 00 
  801eb4:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801ebb:	00 00 00 
  801ebe:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801ec5:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801ec8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801ecf:	e9 9e 00 00 00       	jmp    801f72 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801ed4:	a1 50 50 80 00       	mov    0x805050,%eax
  801ed9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801edc:	c1 e2 04             	shl    $0x4,%edx
  801edf:	01 d0                	add    %edx,%eax
  801ee1:	85 c0                	test   %eax,%eax
  801ee3:	75 14                	jne    801ef9 <initialize_MemBlocksList+0x55>
  801ee5:	83 ec 04             	sub    $0x4,%esp
  801ee8:	68 98 3e 80 00       	push   $0x803e98
  801eed:	6a 46                	push   $0x46
  801eef:	68 bb 3e 80 00       	push   $0x803ebb
  801ef4:	e8 64 14 00 00       	call   80335d <_panic>
  801ef9:	a1 50 50 80 00       	mov    0x805050,%eax
  801efe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f01:	c1 e2 04             	shl    $0x4,%edx
  801f04:	01 d0                	add    %edx,%eax
  801f06:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801f0c:	89 10                	mov    %edx,(%eax)
  801f0e:	8b 00                	mov    (%eax),%eax
  801f10:	85 c0                	test   %eax,%eax
  801f12:	74 18                	je     801f2c <initialize_MemBlocksList+0x88>
  801f14:	a1 48 51 80 00       	mov    0x805148,%eax
  801f19:	8b 15 50 50 80 00    	mov    0x805050,%edx
  801f1f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801f22:	c1 e1 04             	shl    $0x4,%ecx
  801f25:	01 ca                	add    %ecx,%edx
  801f27:	89 50 04             	mov    %edx,0x4(%eax)
  801f2a:	eb 12                	jmp    801f3e <initialize_MemBlocksList+0x9a>
  801f2c:	a1 50 50 80 00       	mov    0x805050,%eax
  801f31:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f34:	c1 e2 04             	shl    $0x4,%edx
  801f37:	01 d0                	add    %edx,%eax
  801f39:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801f3e:	a1 50 50 80 00       	mov    0x805050,%eax
  801f43:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f46:	c1 e2 04             	shl    $0x4,%edx
  801f49:	01 d0                	add    %edx,%eax
  801f4b:	a3 48 51 80 00       	mov    %eax,0x805148
  801f50:	a1 50 50 80 00       	mov    0x805050,%eax
  801f55:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f58:	c1 e2 04             	shl    $0x4,%edx
  801f5b:	01 d0                	add    %edx,%eax
  801f5d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f64:	a1 54 51 80 00       	mov    0x805154,%eax
  801f69:	40                   	inc    %eax
  801f6a:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801f6f:	ff 45 f4             	incl   -0xc(%ebp)
  801f72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f75:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f78:	0f 82 56 ff ff ff    	jb     801ed4 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801f7e:	90                   	nop
  801f7f:	c9                   	leave  
  801f80:	c3                   	ret    

00801f81 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801f81:	55                   	push   %ebp
  801f82:	89 e5                	mov    %esp,%ebp
  801f84:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f87:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8a:	8b 00                	mov    (%eax),%eax
  801f8c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f8f:	eb 19                	jmp    801faa <find_block+0x29>
	{
		if(va==point->sva)
  801f91:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f94:	8b 40 08             	mov    0x8(%eax),%eax
  801f97:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801f9a:	75 05                	jne    801fa1 <find_block+0x20>
		   return point;
  801f9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f9f:	eb 36                	jmp    801fd7 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa4:	8b 40 08             	mov    0x8(%eax),%eax
  801fa7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801faa:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801fae:	74 07                	je     801fb7 <find_block+0x36>
  801fb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fb3:	8b 00                	mov    (%eax),%eax
  801fb5:	eb 05                	jmp    801fbc <find_block+0x3b>
  801fb7:	b8 00 00 00 00       	mov    $0x0,%eax
  801fbc:	8b 55 08             	mov    0x8(%ebp),%edx
  801fbf:	89 42 08             	mov    %eax,0x8(%edx)
  801fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc5:	8b 40 08             	mov    0x8(%eax),%eax
  801fc8:	85 c0                	test   %eax,%eax
  801fca:	75 c5                	jne    801f91 <find_block+0x10>
  801fcc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801fd0:	75 bf                	jne    801f91 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801fd2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fd7:	c9                   	leave  
  801fd8:	c3                   	ret    

00801fd9 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801fd9:	55                   	push   %ebp
  801fda:	89 e5                	mov    %esp,%ebp
  801fdc:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801fdf:	a1 40 50 80 00       	mov    0x805040,%eax
  801fe4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801fe7:	a1 44 50 80 00       	mov    0x805044,%eax
  801fec:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801fef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ff2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801ff5:	74 24                	je     80201b <insert_sorted_allocList+0x42>
  801ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffa:	8b 50 08             	mov    0x8(%eax),%edx
  801ffd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802000:	8b 40 08             	mov    0x8(%eax),%eax
  802003:	39 c2                	cmp    %eax,%edx
  802005:	76 14                	jbe    80201b <insert_sorted_allocList+0x42>
  802007:	8b 45 08             	mov    0x8(%ebp),%eax
  80200a:	8b 50 08             	mov    0x8(%eax),%edx
  80200d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802010:	8b 40 08             	mov    0x8(%eax),%eax
  802013:	39 c2                	cmp    %eax,%edx
  802015:	0f 82 60 01 00 00    	jb     80217b <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  80201b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80201f:	75 65                	jne    802086 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802021:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802025:	75 14                	jne    80203b <insert_sorted_allocList+0x62>
  802027:	83 ec 04             	sub    $0x4,%esp
  80202a:	68 98 3e 80 00       	push   $0x803e98
  80202f:	6a 6b                	push   $0x6b
  802031:	68 bb 3e 80 00       	push   $0x803ebb
  802036:	e8 22 13 00 00       	call   80335d <_panic>
  80203b:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802041:	8b 45 08             	mov    0x8(%ebp),%eax
  802044:	89 10                	mov    %edx,(%eax)
  802046:	8b 45 08             	mov    0x8(%ebp),%eax
  802049:	8b 00                	mov    (%eax),%eax
  80204b:	85 c0                	test   %eax,%eax
  80204d:	74 0d                	je     80205c <insert_sorted_allocList+0x83>
  80204f:	a1 40 50 80 00       	mov    0x805040,%eax
  802054:	8b 55 08             	mov    0x8(%ebp),%edx
  802057:	89 50 04             	mov    %edx,0x4(%eax)
  80205a:	eb 08                	jmp    802064 <insert_sorted_allocList+0x8b>
  80205c:	8b 45 08             	mov    0x8(%ebp),%eax
  80205f:	a3 44 50 80 00       	mov    %eax,0x805044
  802064:	8b 45 08             	mov    0x8(%ebp),%eax
  802067:	a3 40 50 80 00       	mov    %eax,0x805040
  80206c:	8b 45 08             	mov    0x8(%ebp),%eax
  80206f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802076:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80207b:	40                   	inc    %eax
  80207c:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802081:	e9 dc 01 00 00       	jmp    802262 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802086:	8b 45 08             	mov    0x8(%ebp),%eax
  802089:	8b 50 08             	mov    0x8(%eax),%edx
  80208c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80208f:	8b 40 08             	mov    0x8(%eax),%eax
  802092:	39 c2                	cmp    %eax,%edx
  802094:	77 6c                	ja     802102 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802096:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80209a:	74 06                	je     8020a2 <insert_sorted_allocList+0xc9>
  80209c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020a0:	75 14                	jne    8020b6 <insert_sorted_allocList+0xdd>
  8020a2:	83 ec 04             	sub    $0x4,%esp
  8020a5:	68 d4 3e 80 00       	push   $0x803ed4
  8020aa:	6a 6f                	push   $0x6f
  8020ac:	68 bb 3e 80 00       	push   $0x803ebb
  8020b1:	e8 a7 12 00 00       	call   80335d <_panic>
  8020b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020b9:	8b 50 04             	mov    0x4(%eax),%edx
  8020bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bf:	89 50 04             	mov    %edx,0x4(%eax)
  8020c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020c8:	89 10                	mov    %edx,(%eax)
  8020ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020cd:	8b 40 04             	mov    0x4(%eax),%eax
  8020d0:	85 c0                	test   %eax,%eax
  8020d2:	74 0d                	je     8020e1 <insert_sorted_allocList+0x108>
  8020d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020d7:	8b 40 04             	mov    0x4(%eax),%eax
  8020da:	8b 55 08             	mov    0x8(%ebp),%edx
  8020dd:	89 10                	mov    %edx,(%eax)
  8020df:	eb 08                	jmp    8020e9 <insert_sorted_allocList+0x110>
  8020e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e4:	a3 40 50 80 00       	mov    %eax,0x805040
  8020e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8020ef:	89 50 04             	mov    %edx,0x4(%eax)
  8020f2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8020f7:	40                   	inc    %eax
  8020f8:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8020fd:	e9 60 01 00 00       	jmp    802262 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802102:	8b 45 08             	mov    0x8(%ebp),%eax
  802105:	8b 50 08             	mov    0x8(%eax),%edx
  802108:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80210b:	8b 40 08             	mov    0x8(%eax),%eax
  80210e:	39 c2                	cmp    %eax,%edx
  802110:	0f 82 4c 01 00 00    	jb     802262 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802116:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80211a:	75 14                	jne    802130 <insert_sorted_allocList+0x157>
  80211c:	83 ec 04             	sub    $0x4,%esp
  80211f:	68 0c 3f 80 00       	push   $0x803f0c
  802124:	6a 73                	push   $0x73
  802126:	68 bb 3e 80 00       	push   $0x803ebb
  80212b:	e8 2d 12 00 00       	call   80335d <_panic>
  802130:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802136:	8b 45 08             	mov    0x8(%ebp),%eax
  802139:	89 50 04             	mov    %edx,0x4(%eax)
  80213c:	8b 45 08             	mov    0x8(%ebp),%eax
  80213f:	8b 40 04             	mov    0x4(%eax),%eax
  802142:	85 c0                	test   %eax,%eax
  802144:	74 0c                	je     802152 <insert_sorted_allocList+0x179>
  802146:	a1 44 50 80 00       	mov    0x805044,%eax
  80214b:	8b 55 08             	mov    0x8(%ebp),%edx
  80214e:	89 10                	mov    %edx,(%eax)
  802150:	eb 08                	jmp    80215a <insert_sorted_allocList+0x181>
  802152:	8b 45 08             	mov    0x8(%ebp),%eax
  802155:	a3 40 50 80 00       	mov    %eax,0x805040
  80215a:	8b 45 08             	mov    0x8(%ebp),%eax
  80215d:	a3 44 50 80 00       	mov    %eax,0x805044
  802162:	8b 45 08             	mov    0x8(%ebp),%eax
  802165:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80216b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802170:	40                   	inc    %eax
  802171:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802176:	e9 e7 00 00 00       	jmp    802262 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80217b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80217e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802181:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802188:	a1 40 50 80 00       	mov    0x805040,%eax
  80218d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802190:	e9 9d 00 00 00       	jmp    802232 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802195:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802198:	8b 00                	mov    (%eax),%eax
  80219a:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80219d:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a0:	8b 50 08             	mov    0x8(%eax),%edx
  8021a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a6:	8b 40 08             	mov    0x8(%eax),%eax
  8021a9:	39 c2                	cmp    %eax,%edx
  8021ab:	76 7d                	jbe    80222a <insert_sorted_allocList+0x251>
  8021ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b0:	8b 50 08             	mov    0x8(%eax),%edx
  8021b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021b6:	8b 40 08             	mov    0x8(%eax),%eax
  8021b9:	39 c2                	cmp    %eax,%edx
  8021bb:	73 6d                	jae    80222a <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8021bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021c1:	74 06                	je     8021c9 <insert_sorted_allocList+0x1f0>
  8021c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021c7:	75 14                	jne    8021dd <insert_sorted_allocList+0x204>
  8021c9:	83 ec 04             	sub    $0x4,%esp
  8021cc:	68 30 3f 80 00       	push   $0x803f30
  8021d1:	6a 7f                	push   $0x7f
  8021d3:	68 bb 3e 80 00       	push   $0x803ebb
  8021d8:	e8 80 11 00 00       	call   80335d <_panic>
  8021dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e0:	8b 10                	mov    (%eax),%edx
  8021e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e5:	89 10                	mov    %edx,(%eax)
  8021e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ea:	8b 00                	mov    (%eax),%eax
  8021ec:	85 c0                	test   %eax,%eax
  8021ee:	74 0b                	je     8021fb <insert_sorted_allocList+0x222>
  8021f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f3:	8b 00                	mov    (%eax),%eax
  8021f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8021f8:	89 50 04             	mov    %edx,0x4(%eax)
  8021fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021fe:	8b 55 08             	mov    0x8(%ebp),%edx
  802201:	89 10                	mov    %edx,(%eax)
  802203:	8b 45 08             	mov    0x8(%ebp),%eax
  802206:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802209:	89 50 04             	mov    %edx,0x4(%eax)
  80220c:	8b 45 08             	mov    0x8(%ebp),%eax
  80220f:	8b 00                	mov    (%eax),%eax
  802211:	85 c0                	test   %eax,%eax
  802213:	75 08                	jne    80221d <insert_sorted_allocList+0x244>
  802215:	8b 45 08             	mov    0x8(%ebp),%eax
  802218:	a3 44 50 80 00       	mov    %eax,0x805044
  80221d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802222:	40                   	inc    %eax
  802223:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802228:	eb 39                	jmp    802263 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80222a:	a1 48 50 80 00       	mov    0x805048,%eax
  80222f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802232:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802236:	74 07                	je     80223f <insert_sorted_allocList+0x266>
  802238:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223b:	8b 00                	mov    (%eax),%eax
  80223d:	eb 05                	jmp    802244 <insert_sorted_allocList+0x26b>
  80223f:	b8 00 00 00 00       	mov    $0x0,%eax
  802244:	a3 48 50 80 00       	mov    %eax,0x805048
  802249:	a1 48 50 80 00       	mov    0x805048,%eax
  80224e:	85 c0                	test   %eax,%eax
  802250:	0f 85 3f ff ff ff    	jne    802195 <insert_sorted_allocList+0x1bc>
  802256:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80225a:	0f 85 35 ff ff ff    	jne    802195 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802260:	eb 01                	jmp    802263 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802262:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802263:	90                   	nop
  802264:	c9                   	leave  
  802265:	c3                   	ret    

00802266 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802266:	55                   	push   %ebp
  802267:	89 e5                	mov    %esp,%ebp
  802269:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80226c:	a1 38 51 80 00       	mov    0x805138,%eax
  802271:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802274:	e9 85 01 00 00       	jmp    8023fe <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802279:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227c:	8b 40 0c             	mov    0xc(%eax),%eax
  80227f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802282:	0f 82 6e 01 00 00    	jb     8023f6 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802288:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228b:	8b 40 0c             	mov    0xc(%eax),%eax
  80228e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802291:	0f 85 8a 00 00 00    	jne    802321 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802297:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80229b:	75 17                	jne    8022b4 <alloc_block_FF+0x4e>
  80229d:	83 ec 04             	sub    $0x4,%esp
  8022a0:	68 64 3f 80 00       	push   $0x803f64
  8022a5:	68 93 00 00 00       	push   $0x93
  8022aa:	68 bb 3e 80 00       	push   $0x803ebb
  8022af:	e8 a9 10 00 00       	call   80335d <_panic>
  8022b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b7:	8b 00                	mov    (%eax),%eax
  8022b9:	85 c0                	test   %eax,%eax
  8022bb:	74 10                	je     8022cd <alloc_block_FF+0x67>
  8022bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c0:	8b 00                	mov    (%eax),%eax
  8022c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022c5:	8b 52 04             	mov    0x4(%edx),%edx
  8022c8:	89 50 04             	mov    %edx,0x4(%eax)
  8022cb:	eb 0b                	jmp    8022d8 <alloc_block_FF+0x72>
  8022cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d0:	8b 40 04             	mov    0x4(%eax),%eax
  8022d3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8022d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022db:	8b 40 04             	mov    0x4(%eax),%eax
  8022de:	85 c0                	test   %eax,%eax
  8022e0:	74 0f                	je     8022f1 <alloc_block_FF+0x8b>
  8022e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e5:	8b 40 04             	mov    0x4(%eax),%eax
  8022e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022eb:	8b 12                	mov    (%edx),%edx
  8022ed:	89 10                	mov    %edx,(%eax)
  8022ef:	eb 0a                	jmp    8022fb <alloc_block_FF+0x95>
  8022f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f4:	8b 00                	mov    (%eax),%eax
  8022f6:	a3 38 51 80 00       	mov    %eax,0x805138
  8022fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802304:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802307:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80230e:	a1 44 51 80 00       	mov    0x805144,%eax
  802313:	48                   	dec    %eax
  802314:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802319:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231c:	e9 10 01 00 00       	jmp    802431 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802321:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802324:	8b 40 0c             	mov    0xc(%eax),%eax
  802327:	3b 45 08             	cmp    0x8(%ebp),%eax
  80232a:	0f 86 c6 00 00 00    	jbe    8023f6 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802330:	a1 48 51 80 00       	mov    0x805148,%eax
  802335:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802338:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233b:	8b 50 08             	mov    0x8(%eax),%edx
  80233e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802341:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802344:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802347:	8b 55 08             	mov    0x8(%ebp),%edx
  80234a:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80234d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802351:	75 17                	jne    80236a <alloc_block_FF+0x104>
  802353:	83 ec 04             	sub    $0x4,%esp
  802356:	68 64 3f 80 00       	push   $0x803f64
  80235b:	68 9b 00 00 00       	push   $0x9b
  802360:	68 bb 3e 80 00       	push   $0x803ebb
  802365:	e8 f3 0f 00 00       	call   80335d <_panic>
  80236a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80236d:	8b 00                	mov    (%eax),%eax
  80236f:	85 c0                	test   %eax,%eax
  802371:	74 10                	je     802383 <alloc_block_FF+0x11d>
  802373:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802376:	8b 00                	mov    (%eax),%eax
  802378:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80237b:	8b 52 04             	mov    0x4(%edx),%edx
  80237e:	89 50 04             	mov    %edx,0x4(%eax)
  802381:	eb 0b                	jmp    80238e <alloc_block_FF+0x128>
  802383:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802386:	8b 40 04             	mov    0x4(%eax),%eax
  802389:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80238e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802391:	8b 40 04             	mov    0x4(%eax),%eax
  802394:	85 c0                	test   %eax,%eax
  802396:	74 0f                	je     8023a7 <alloc_block_FF+0x141>
  802398:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80239b:	8b 40 04             	mov    0x4(%eax),%eax
  80239e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023a1:	8b 12                	mov    (%edx),%edx
  8023a3:	89 10                	mov    %edx,(%eax)
  8023a5:	eb 0a                	jmp    8023b1 <alloc_block_FF+0x14b>
  8023a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023aa:	8b 00                	mov    (%eax),%eax
  8023ac:	a3 48 51 80 00       	mov    %eax,0x805148
  8023b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023bd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023c4:	a1 54 51 80 00       	mov    0x805154,%eax
  8023c9:	48                   	dec    %eax
  8023ca:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8023cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d2:	8b 50 08             	mov    0x8(%eax),%edx
  8023d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d8:	01 c2                	add    %eax,%edx
  8023da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023dd:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8023e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e3:	8b 40 0c             	mov    0xc(%eax),%eax
  8023e6:	2b 45 08             	sub    0x8(%ebp),%eax
  8023e9:	89 c2                	mov    %eax,%edx
  8023eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ee:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8023f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f4:	eb 3b                	jmp    802431 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8023f6:	a1 40 51 80 00       	mov    0x805140,%eax
  8023fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802402:	74 07                	je     80240b <alloc_block_FF+0x1a5>
  802404:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802407:	8b 00                	mov    (%eax),%eax
  802409:	eb 05                	jmp    802410 <alloc_block_FF+0x1aa>
  80240b:	b8 00 00 00 00       	mov    $0x0,%eax
  802410:	a3 40 51 80 00       	mov    %eax,0x805140
  802415:	a1 40 51 80 00       	mov    0x805140,%eax
  80241a:	85 c0                	test   %eax,%eax
  80241c:	0f 85 57 fe ff ff    	jne    802279 <alloc_block_FF+0x13>
  802422:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802426:	0f 85 4d fe ff ff    	jne    802279 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  80242c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802431:	c9                   	leave  
  802432:	c3                   	ret    

00802433 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802433:	55                   	push   %ebp
  802434:	89 e5                	mov    %esp,%ebp
  802436:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802439:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802440:	a1 38 51 80 00       	mov    0x805138,%eax
  802445:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802448:	e9 df 00 00 00       	jmp    80252c <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80244d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802450:	8b 40 0c             	mov    0xc(%eax),%eax
  802453:	3b 45 08             	cmp    0x8(%ebp),%eax
  802456:	0f 82 c8 00 00 00    	jb     802524 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  80245c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245f:	8b 40 0c             	mov    0xc(%eax),%eax
  802462:	3b 45 08             	cmp    0x8(%ebp),%eax
  802465:	0f 85 8a 00 00 00    	jne    8024f5 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  80246b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80246f:	75 17                	jne    802488 <alloc_block_BF+0x55>
  802471:	83 ec 04             	sub    $0x4,%esp
  802474:	68 64 3f 80 00       	push   $0x803f64
  802479:	68 b7 00 00 00       	push   $0xb7
  80247e:	68 bb 3e 80 00       	push   $0x803ebb
  802483:	e8 d5 0e 00 00       	call   80335d <_panic>
  802488:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248b:	8b 00                	mov    (%eax),%eax
  80248d:	85 c0                	test   %eax,%eax
  80248f:	74 10                	je     8024a1 <alloc_block_BF+0x6e>
  802491:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802494:	8b 00                	mov    (%eax),%eax
  802496:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802499:	8b 52 04             	mov    0x4(%edx),%edx
  80249c:	89 50 04             	mov    %edx,0x4(%eax)
  80249f:	eb 0b                	jmp    8024ac <alloc_block_BF+0x79>
  8024a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a4:	8b 40 04             	mov    0x4(%eax),%eax
  8024a7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8024ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024af:	8b 40 04             	mov    0x4(%eax),%eax
  8024b2:	85 c0                	test   %eax,%eax
  8024b4:	74 0f                	je     8024c5 <alloc_block_BF+0x92>
  8024b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b9:	8b 40 04             	mov    0x4(%eax),%eax
  8024bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024bf:	8b 12                	mov    (%edx),%edx
  8024c1:	89 10                	mov    %edx,(%eax)
  8024c3:	eb 0a                	jmp    8024cf <alloc_block_BF+0x9c>
  8024c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c8:	8b 00                	mov    (%eax),%eax
  8024ca:	a3 38 51 80 00       	mov    %eax,0x805138
  8024cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024db:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024e2:	a1 44 51 80 00       	mov    0x805144,%eax
  8024e7:	48                   	dec    %eax
  8024e8:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8024ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f0:	e9 4d 01 00 00       	jmp    802642 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8024f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8024fb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024fe:	76 24                	jbe    802524 <alloc_block_BF+0xf1>
  802500:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802503:	8b 40 0c             	mov    0xc(%eax),%eax
  802506:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802509:	73 19                	jae    802524 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80250b:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802512:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802515:	8b 40 0c             	mov    0xc(%eax),%eax
  802518:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  80251b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251e:	8b 40 08             	mov    0x8(%eax),%eax
  802521:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802524:	a1 40 51 80 00       	mov    0x805140,%eax
  802529:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80252c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802530:	74 07                	je     802539 <alloc_block_BF+0x106>
  802532:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802535:	8b 00                	mov    (%eax),%eax
  802537:	eb 05                	jmp    80253e <alloc_block_BF+0x10b>
  802539:	b8 00 00 00 00       	mov    $0x0,%eax
  80253e:	a3 40 51 80 00       	mov    %eax,0x805140
  802543:	a1 40 51 80 00       	mov    0x805140,%eax
  802548:	85 c0                	test   %eax,%eax
  80254a:	0f 85 fd fe ff ff    	jne    80244d <alloc_block_BF+0x1a>
  802550:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802554:	0f 85 f3 fe ff ff    	jne    80244d <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  80255a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80255e:	0f 84 d9 00 00 00    	je     80263d <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802564:	a1 48 51 80 00       	mov    0x805148,%eax
  802569:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  80256c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80256f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802572:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802575:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802578:	8b 55 08             	mov    0x8(%ebp),%edx
  80257b:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  80257e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802582:	75 17                	jne    80259b <alloc_block_BF+0x168>
  802584:	83 ec 04             	sub    $0x4,%esp
  802587:	68 64 3f 80 00       	push   $0x803f64
  80258c:	68 c7 00 00 00       	push   $0xc7
  802591:	68 bb 3e 80 00       	push   $0x803ebb
  802596:	e8 c2 0d 00 00       	call   80335d <_panic>
  80259b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80259e:	8b 00                	mov    (%eax),%eax
  8025a0:	85 c0                	test   %eax,%eax
  8025a2:	74 10                	je     8025b4 <alloc_block_BF+0x181>
  8025a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025a7:	8b 00                	mov    (%eax),%eax
  8025a9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025ac:	8b 52 04             	mov    0x4(%edx),%edx
  8025af:	89 50 04             	mov    %edx,0x4(%eax)
  8025b2:	eb 0b                	jmp    8025bf <alloc_block_BF+0x18c>
  8025b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025b7:	8b 40 04             	mov    0x4(%eax),%eax
  8025ba:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8025bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025c2:	8b 40 04             	mov    0x4(%eax),%eax
  8025c5:	85 c0                	test   %eax,%eax
  8025c7:	74 0f                	je     8025d8 <alloc_block_BF+0x1a5>
  8025c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025cc:	8b 40 04             	mov    0x4(%eax),%eax
  8025cf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025d2:	8b 12                	mov    (%edx),%edx
  8025d4:	89 10                	mov    %edx,(%eax)
  8025d6:	eb 0a                	jmp    8025e2 <alloc_block_BF+0x1af>
  8025d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025db:	8b 00                	mov    (%eax),%eax
  8025dd:	a3 48 51 80 00       	mov    %eax,0x805148
  8025e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025ee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025f5:	a1 54 51 80 00       	mov    0x805154,%eax
  8025fa:	48                   	dec    %eax
  8025fb:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802600:	83 ec 08             	sub    $0x8,%esp
  802603:	ff 75 ec             	pushl  -0x14(%ebp)
  802606:	68 38 51 80 00       	push   $0x805138
  80260b:	e8 71 f9 ff ff       	call   801f81 <find_block>
  802610:	83 c4 10             	add    $0x10,%esp
  802613:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802616:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802619:	8b 50 08             	mov    0x8(%eax),%edx
  80261c:	8b 45 08             	mov    0x8(%ebp),%eax
  80261f:	01 c2                	add    %eax,%edx
  802621:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802624:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802627:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80262a:	8b 40 0c             	mov    0xc(%eax),%eax
  80262d:	2b 45 08             	sub    0x8(%ebp),%eax
  802630:	89 c2                	mov    %eax,%edx
  802632:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802635:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802638:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80263b:	eb 05                	jmp    802642 <alloc_block_BF+0x20f>
	}
	return NULL;
  80263d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802642:	c9                   	leave  
  802643:	c3                   	ret    

00802644 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802644:	55                   	push   %ebp
  802645:	89 e5                	mov    %esp,%ebp
  802647:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  80264a:	a1 28 50 80 00       	mov    0x805028,%eax
  80264f:	85 c0                	test   %eax,%eax
  802651:	0f 85 de 01 00 00    	jne    802835 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802657:	a1 38 51 80 00       	mov    0x805138,%eax
  80265c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80265f:	e9 9e 01 00 00       	jmp    802802 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802664:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802667:	8b 40 0c             	mov    0xc(%eax),%eax
  80266a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80266d:	0f 82 87 01 00 00    	jb     8027fa <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802673:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802676:	8b 40 0c             	mov    0xc(%eax),%eax
  802679:	3b 45 08             	cmp    0x8(%ebp),%eax
  80267c:	0f 85 95 00 00 00    	jne    802717 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802682:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802686:	75 17                	jne    80269f <alloc_block_NF+0x5b>
  802688:	83 ec 04             	sub    $0x4,%esp
  80268b:	68 64 3f 80 00       	push   $0x803f64
  802690:	68 e0 00 00 00       	push   $0xe0
  802695:	68 bb 3e 80 00       	push   $0x803ebb
  80269a:	e8 be 0c 00 00       	call   80335d <_panic>
  80269f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a2:	8b 00                	mov    (%eax),%eax
  8026a4:	85 c0                	test   %eax,%eax
  8026a6:	74 10                	je     8026b8 <alloc_block_NF+0x74>
  8026a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ab:	8b 00                	mov    (%eax),%eax
  8026ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026b0:	8b 52 04             	mov    0x4(%edx),%edx
  8026b3:	89 50 04             	mov    %edx,0x4(%eax)
  8026b6:	eb 0b                	jmp    8026c3 <alloc_block_NF+0x7f>
  8026b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bb:	8b 40 04             	mov    0x4(%eax),%eax
  8026be:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8026c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c6:	8b 40 04             	mov    0x4(%eax),%eax
  8026c9:	85 c0                	test   %eax,%eax
  8026cb:	74 0f                	je     8026dc <alloc_block_NF+0x98>
  8026cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d0:	8b 40 04             	mov    0x4(%eax),%eax
  8026d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026d6:	8b 12                	mov    (%edx),%edx
  8026d8:	89 10                	mov    %edx,(%eax)
  8026da:	eb 0a                	jmp    8026e6 <alloc_block_NF+0xa2>
  8026dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026df:	8b 00                	mov    (%eax),%eax
  8026e1:	a3 38 51 80 00       	mov    %eax,0x805138
  8026e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026f9:	a1 44 51 80 00       	mov    0x805144,%eax
  8026fe:	48                   	dec    %eax
  8026ff:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802704:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802707:	8b 40 08             	mov    0x8(%eax),%eax
  80270a:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  80270f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802712:	e9 f8 04 00 00       	jmp    802c0f <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802717:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271a:	8b 40 0c             	mov    0xc(%eax),%eax
  80271d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802720:	0f 86 d4 00 00 00    	jbe    8027fa <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802726:	a1 48 51 80 00       	mov    0x805148,%eax
  80272b:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  80272e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802731:	8b 50 08             	mov    0x8(%eax),%edx
  802734:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802737:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  80273a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80273d:	8b 55 08             	mov    0x8(%ebp),%edx
  802740:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802743:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802747:	75 17                	jne    802760 <alloc_block_NF+0x11c>
  802749:	83 ec 04             	sub    $0x4,%esp
  80274c:	68 64 3f 80 00       	push   $0x803f64
  802751:	68 e9 00 00 00       	push   $0xe9
  802756:	68 bb 3e 80 00       	push   $0x803ebb
  80275b:	e8 fd 0b 00 00       	call   80335d <_panic>
  802760:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802763:	8b 00                	mov    (%eax),%eax
  802765:	85 c0                	test   %eax,%eax
  802767:	74 10                	je     802779 <alloc_block_NF+0x135>
  802769:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80276c:	8b 00                	mov    (%eax),%eax
  80276e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802771:	8b 52 04             	mov    0x4(%edx),%edx
  802774:	89 50 04             	mov    %edx,0x4(%eax)
  802777:	eb 0b                	jmp    802784 <alloc_block_NF+0x140>
  802779:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80277c:	8b 40 04             	mov    0x4(%eax),%eax
  80277f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802784:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802787:	8b 40 04             	mov    0x4(%eax),%eax
  80278a:	85 c0                	test   %eax,%eax
  80278c:	74 0f                	je     80279d <alloc_block_NF+0x159>
  80278e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802791:	8b 40 04             	mov    0x4(%eax),%eax
  802794:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802797:	8b 12                	mov    (%edx),%edx
  802799:	89 10                	mov    %edx,(%eax)
  80279b:	eb 0a                	jmp    8027a7 <alloc_block_NF+0x163>
  80279d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a0:	8b 00                	mov    (%eax),%eax
  8027a2:	a3 48 51 80 00       	mov    %eax,0x805148
  8027a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027ba:	a1 54 51 80 00       	mov    0x805154,%eax
  8027bf:	48                   	dec    %eax
  8027c0:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  8027c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c8:	8b 40 08             	mov    0x8(%eax),%eax
  8027cb:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8027d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d3:	8b 50 08             	mov    0x8(%eax),%edx
  8027d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d9:	01 c2                	add    %eax,%edx
  8027db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027de:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8027e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8027e7:	2b 45 08             	sub    0x8(%ebp),%eax
  8027ea:	89 c2                	mov    %eax,%edx
  8027ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ef:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8027f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f5:	e9 15 04 00 00       	jmp    802c0f <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8027fa:	a1 40 51 80 00       	mov    0x805140,%eax
  8027ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802802:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802806:	74 07                	je     80280f <alloc_block_NF+0x1cb>
  802808:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280b:	8b 00                	mov    (%eax),%eax
  80280d:	eb 05                	jmp    802814 <alloc_block_NF+0x1d0>
  80280f:	b8 00 00 00 00       	mov    $0x0,%eax
  802814:	a3 40 51 80 00       	mov    %eax,0x805140
  802819:	a1 40 51 80 00       	mov    0x805140,%eax
  80281e:	85 c0                	test   %eax,%eax
  802820:	0f 85 3e fe ff ff    	jne    802664 <alloc_block_NF+0x20>
  802826:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80282a:	0f 85 34 fe ff ff    	jne    802664 <alloc_block_NF+0x20>
  802830:	e9 d5 03 00 00       	jmp    802c0a <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802835:	a1 38 51 80 00       	mov    0x805138,%eax
  80283a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80283d:	e9 b1 01 00 00       	jmp    8029f3 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802842:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802845:	8b 50 08             	mov    0x8(%eax),%edx
  802848:	a1 28 50 80 00       	mov    0x805028,%eax
  80284d:	39 c2                	cmp    %eax,%edx
  80284f:	0f 82 96 01 00 00    	jb     8029eb <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802855:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802858:	8b 40 0c             	mov    0xc(%eax),%eax
  80285b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80285e:	0f 82 87 01 00 00    	jb     8029eb <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802864:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802867:	8b 40 0c             	mov    0xc(%eax),%eax
  80286a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80286d:	0f 85 95 00 00 00    	jne    802908 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802873:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802877:	75 17                	jne    802890 <alloc_block_NF+0x24c>
  802879:	83 ec 04             	sub    $0x4,%esp
  80287c:	68 64 3f 80 00       	push   $0x803f64
  802881:	68 fc 00 00 00       	push   $0xfc
  802886:	68 bb 3e 80 00       	push   $0x803ebb
  80288b:	e8 cd 0a 00 00       	call   80335d <_panic>
  802890:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802893:	8b 00                	mov    (%eax),%eax
  802895:	85 c0                	test   %eax,%eax
  802897:	74 10                	je     8028a9 <alloc_block_NF+0x265>
  802899:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289c:	8b 00                	mov    (%eax),%eax
  80289e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028a1:	8b 52 04             	mov    0x4(%edx),%edx
  8028a4:	89 50 04             	mov    %edx,0x4(%eax)
  8028a7:	eb 0b                	jmp    8028b4 <alloc_block_NF+0x270>
  8028a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ac:	8b 40 04             	mov    0x4(%eax),%eax
  8028af:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8028b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b7:	8b 40 04             	mov    0x4(%eax),%eax
  8028ba:	85 c0                	test   %eax,%eax
  8028bc:	74 0f                	je     8028cd <alloc_block_NF+0x289>
  8028be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c1:	8b 40 04             	mov    0x4(%eax),%eax
  8028c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028c7:	8b 12                	mov    (%edx),%edx
  8028c9:	89 10                	mov    %edx,(%eax)
  8028cb:	eb 0a                	jmp    8028d7 <alloc_block_NF+0x293>
  8028cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d0:	8b 00                	mov    (%eax),%eax
  8028d2:	a3 38 51 80 00       	mov    %eax,0x805138
  8028d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028ea:	a1 44 51 80 00       	mov    0x805144,%eax
  8028ef:	48                   	dec    %eax
  8028f0:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8028f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f8:	8b 40 08             	mov    0x8(%eax),%eax
  8028fb:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802900:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802903:	e9 07 03 00 00       	jmp    802c0f <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802908:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290b:	8b 40 0c             	mov    0xc(%eax),%eax
  80290e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802911:	0f 86 d4 00 00 00    	jbe    8029eb <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802917:	a1 48 51 80 00       	mov    0x805148,%eax
  80291c:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  80291f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802922:	8b 50 08             	mov    0x8(%eax),%edx
  802925:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802928:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80292b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80292e:	8b 55 08             	mov    0x8(%ebp),%edx
  802931:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802934:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802938:	75 17                	jne    802951 <alloc_block_NF+0x30d>
  80293a:	83 ec 04             	sub    $0x4,%esp
  80293d:	68 64 3f 80 00       	push   $0x803f64
  802942:	68 04 01 00 00       	push   $0x104
  802947:	68 bb 3e 80 00       	push   $0x803ebb
  80294c:	e8 0c 0a 00 00       	call   80335d <_panic>
  802951:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802954:	8b 00                	mov    (%eax),%eax
  802956:	85 c0                	test   %eax,%eax
  802958:	74 10                	je     80296a <alloc_block_NF+0x326>
  80295a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80295d:	8b 00                	mov    (%eax),%eax
  80295f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802962:	8b 52 04             	mov    0x4(%edx),%edx
  802965:	89 50 04             	mov    %edx,0x4(%eax)
  802968:	eb 0b                	jmp    802975 <alloc_block_NF+0x331>
  80296a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80296d:	8b 40 04             	mov    0x4(%eax),%eax
  802970:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802975:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802978:	8b 40 04             	mov    0x4(%eax),%eax
  80297b:	85 c0                	test   %eax,%eax
  80297d:	74 0f                	je     80298e <alloc_block_NF+0x34a>
  80297f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802982:	8b 40 04             	mov    0x4(%eax),%eax
  802985:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802988:	8b 12                	mov    (%edx),%edx
  80298a:	89 10                	mov    %edx,(%eax)
  80298c:	eb 0a                	jmp    802998 <alloc_block_NF+0x354>
  80298e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802991:	8b 00                	mov    (%eax),%eax
  802993:	a3 48 51 80 00       	mov    %eax,0x805148
  802998:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80299b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029a4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029ab:	a1 54 51 80 00       	mov    0x805154,%eax
  8029b0:	48                   	dec    %eax
  8029b1:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8029b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029b9:	8b 40 08             	mov    0x8(%eax),%eax
  8029bc:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  8029c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c4:	8b 50 08             	mov    0x8(%eax),%edx
  8029c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ca:	01 c2                	add    %eax,%edx
  8029cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cf:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8029d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8029d8:	2b 45 08             	sub    0x8(%ebp),%eax
  8029db:	89 c2                	mov    %eax,%edx
  8029dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e0:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8029e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029e6:	e9 24 02 00 00       	jmp    802c0f <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029eb:	a1 40 51 80 00       	mov    0x805140,%eax
  8029f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029f7:	74 07                	je     802a00 <alloc_block_NF+0x3bc>
  8029f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fc:	8b 00                	mov    (%eax),%eax
  8029fe:	eb 05                	jmp    802a05 <alloc_block_NF+0x3c1>
  802a00:	b8 00 00 00 00       	mov    $0x0,%eax
  802a05:	a3 40 51 80 00       	mov    %eax,0x805140
  802a0a:	a1 40 51 80 00       	mov    0x805140,%eax
  802a0f:	85 c0                	test   %eax,%eax
  802a11:	0f 85 2b fe ff ff    	jne    802842 <alloc_block_NF+0x1fe>
  802a17:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a1b:	0f 85 21 fe ff ff    	jne    802842 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a21:	a1 38 51 80 00       	mov    0x805138,%eax
  802a26:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a29:	e9 ae 01 00 00       	jmp    802bdc <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802a2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a31:	8b 50 08             	mov    0x8(%eax),%edx
  802a34:	a1 28 50 80 00       	mov    0x805028,%eax
  802a39:	39 c2                	cmp    %eax,%edx
  802a3b:	0f 83 93 01 00 00    	jae    802bd4 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802a41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a44:	8b 40 0c             	mov    0xc(%eax),%eax
  802a47:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a4a:	0f 82 84 01 00 00    	jb     802bd4 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a53:	8b 40 0c             	mov    0xc(%eax),%eax
  802a56:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a59:	0f 85 95 00 00 00    	jne    802af4 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a5f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a63:	75 17                	jne    802a7c <alloc_block_NF+0x438>
  802a65:	83 ec 04             	sub    $0x4,%esp
  802a68:	68 64 3f 80 00       	push   $0x803f64
  802a6d:	68 14 01 00 00       	push   $0x114
  802a72:	68 bb 3e 80 00       	push   $0x803ebb
  802a77:	e8 e1 08 00 00       	call   80335d <_panic>
  802a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7f:	8b 00                	mov    (%eax),%eax
  802a81:	85 c0                	test   %eax,%eax
  802a83:	74 10                	je     802a95 <alloc_block_NF+0x451>
  802a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a88:	8b 00                	mov    (%eax),%eax
  802a8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a8d:	8b 52 04             	mov    0x4(%edx),%edx
  802a90:	89 50 04             	mov    %edx,0x4(%eax)
  802a93:	eb 0b                	jmp    802aa0 <alloc_block_NF+0x45c>
  802a95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a98:	8b 40 04             	mov    0x4(%eax),%eax
  802a9b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa3:	8b 40 04             	mov    0x4(%eax),%eax
  802aa6:	85 c0                	test   %eax,%eax
  802aa8:	74 0f                	je     802ab9 <alloc_block_NF+0x475>
  802aaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aad:	8b 40 04             	mov    0x4(%eax),%eax
  802ab0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ab3:	8b 12                	mov    (%edx),%edx
  802ab5:	89 10                	mov    %edx,(%eax)
  802ab7:	eb 0a                	jmp    802ac3 <alloc_block_NF+0x47f>
  802ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abc:	8b 00                	mov    (%eax),%eax
  802abe:	a3 38 51 80 00       	mov    %eax,0x805138
  802ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ad6:	a1 44 51 80 00       	mov    0x805144,%eax
  802adb:	48                   	dec    %eax
  802adc:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae4:	8b 40 08             	mov    0x8(%eax),%eax
  802ae7:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aef:	e9 1b 01 00 00       	jmp    802c0f <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af7:	8b 40 0c             	mov    0xc(%eax),%eax
  802afa:	3b 45 08             	cmp    0x8(%ebp),%eax
  802afd:	0f 86 d1 00 00 00    	jbe    802bd4 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b03:	a1 48 51 80 00       	mov    0x805148,%eax
  802b08:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0e:	8b 50 08             	mov    0x8(%eax),%edx
  802b11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b14:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b1a:	8b 55 08             	mov    0x8(%ebp),%edx
  802b1d:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b20:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b24:	75 17                	jne    802b3d <alloc_block_NF+0x4f9>
  802b26:	83 ec 04             	sub    $0x4,%esp
  802b29:	68 64 3f 80 00       	push   $0x803f64
  802b2e:	68 1c 01 00 00       	push   $0x11c
  802b33:	68 bb 3e 80 00       	push   $0x803ebb
  802b38:	e8 20 08 00 00       	call   80335d <_panic>
  802b3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b40:	8b 00                	mov    (%eax),%eax
  802b42:	85 c0                	test   %eax,%eax
  802b44:	74 10                	je     802b56 <alloc_block_NF+0x512>
  802b46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b49:	8b 00                	mov    (%eax),%eax
  802b4b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b4e:	8b 52 04             	mov    0x4(%edx),%edx
  802b51:	89 50 04             	mov    %edx,0x4(%eax)
  802b54:	eb 0b                	jmp    802b61 <alloc_block_NF+0x51d>
  802b56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b59:	8b 40 04             	mov    0x4(%eax),%eax
  802b5c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b64:	8b 40 04             	mov    0x4(%eax),%eax
  802b67:	85 c0                	test   %eax,%eax
  802b69:	74 0f                	je     802b7a <alloc_block_NF+0x536>
  802b6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b6e:	8b 40 04             	mov    0x4(%eax),%eax
  802b71:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b74:	8b 12                	mov    (%edx),%edx
  802b76:	89 10                	mov    %edx,(%eax)
  802b78:	eb 0a                	jmp    802b84 <alloc_block_NF+0x540>
  802b7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b7d:	8b 00                	mov    (%eax),%eax
  802b7f:	a3 48 51 80 00       	mov    %eax,0x805148
  802b84:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b87:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b90:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b97:	a1 54 51 80 00       	mov    0x805154,%eax
  802b9c:	48                   	dec    %eax
  802b9d:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802ba2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba5:	8b 40 08             	mov    0x8(%eax),%eax
  802ba8:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802bad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb0:	8b 50 08             	mov    0x8(%eax),%edx
  802bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb6:	01 c2                	add    %eax,%edx
  802bb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbb:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802bbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc1:	8b 40 0c             	mov    0xc(%eax),%eax
  802bc4:	2b 45 08             	sub    0x8(%ebp),%eax
  802bc7:	89 c2                	mov    %eax,%edx
  802bc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcc:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802bcf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd2:	eb 3b                	jmp    802c0f <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802bd4:	a1 40 51 80 00       	mov    0x805140,%eax
  802bd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bdc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802be0:	74 07                	je     802be9 <alloc_block_NF+0x5a5>
  802be2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be5:	8b 00                	mov    (%eax),%eax
  802be7:	eb 05                	jmp    802bee <alloc_block_NF+0x5aa>
  802be9:	b8 00 00 00 00       	mov    $0x0,%eax
  802bee:	a3 40 51 80 00       	mov    %eax,0x805140
  802bf3:	a1 40 51 80 00       	mov    0x805140,%eax
  802bf8:	85 c0                	test   %eax,%eax
  802bfa:	0f 85 2e fe ff ff    	jne    802a2e <alloc_block_NF+0x3ea>
  802c00:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c04:	0f 85 24 fe ff ff    	jne    802a2e <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802c0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c0f:	c9                   	leave  
  802c10:	c3                   	ret    

00802c11 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802c11:	55                   	push   %ebp
  802c12:	89 e5                	mov    %esp,%ebp
  802c14:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802c17:	a1 38 51 80 00       	mov    0x805138,%eax
  802c1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802c1f:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802c24:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802c27:	a1 38 51 80 00       	mov    0x805138,%eax
  802c2c:	85 c0                	test   %eax,%eax
  802c2e:	74 14                	je     802c44 <insert_sorted_with_merge_freeList+0x33>
  802c30:	8b 45 08             	mov    0x8(%ebp),%eax
  802c33:	8b 50 08             	mov    0x8(%eax),%edx
  802c36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c39:	8b 40 08             	mov    0x8(%eax),%eax
  802c3c:	39 c2                	cmp    %eax,%edx
  802c3e:	0f 87 9b 01 00 00    	ja     802ddf <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802c44:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c48:	75 17                	jne    802c61 <insert_sorted_with_merge_freeList+0x50>
  802c4a:	83 ec 04             	sub    $0x4,%esp
  802c4d:	68 98 3e 80 00       	push   $0x803e98
  802c52:	68 38 01 00 00       	push   $0x138
  802c57:	68 bb 3e 80 00       	push   $0x803ebb
  802c5c:	e8 fc 06 00 00       	call   80335d <_panic>
  802c61:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802c67:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6a:	89 10                	mov    %edx,(%eax)
  802c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6f:	8b 00                	mov    (%eax),%eax
  802c71:	85 c0                	test   %eax,%eax
  802c73:	74 0d                	je     802c82 <insert_sorted_with_merge_freeList+0x71>
  802c75:	a1 38 51 80 00       	mov    0x805138,%eax
  802c7a:	8b 55 08             	mov    0x8(%ebp),%edx
  802c7d:	89 50 04             	mov    %edx,0x4(%eax)
  802c80:	eb 08                	jmp    802c8a <insert_sorted_with_merge_freeList+0x79>
  802c82:	8b 45 08             	mov    0x8(%ebp),%eax
  802c85:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8d:	a3 38 51 80 00       	mov    %eax,0x805138
  802c92:	8b 45 08             	mov    0x8(%ebp),%eax
  802c95:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c9c:	a1 44 51 80 00       	mov    0x805144,%eax
  802ca1:	40                   	inc    %eax
  802ca2:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802ca7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cab:	0f 84 a8 06 00 00    	je     803359 <insert_sorted_with_merge_freeList+0x748>
  802cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb4:	8b 50 08             	mov    0x8(%eax),%edx
  802cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cba:	8b 40 0c             	mov    0xc(%eax),%eax
  802cbd:	01 c2                	add    %eax,%edx
  802cbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc2:	8b 40 08             	mov    0x8(%eax),%eax
  802cc5:	39 c2                	cmp    %eax,%edx
  802cc7:	0f 85 8c 06 00 00    	jne    803359 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd0:	8b 50 0c             	mov    0xc(%eax),%edx
  802cd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd6:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd9:	01 c2                	add    %eax,%edx
  802cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cde:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802ce1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ce5:	75 17                	jne    802cfe <insert_sorted_with_merge_freeList+0xed>
  802ce7:	83 ec 04             	sub    $0x4,%esp
  802cea:	68 64 3f 80 00       	push   $0x803f64
  802cef:	68 3c 01 00 00       	push   $0x13c
  802cf4:	68 bb 3e 80 00       	push   $0x803ebb
  802cf9:	e8 5f 06 00 00       	call   80335d <_panic>
  802cfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d01:	8b 00                	mov    (%eax),%eax
  802d03:	85 c0                	test   %eax,%eax
  802d05:	74 10                	je     802d17 <insert_sorted_with_merge_freeList+0x106>
  802d07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d0a:	8b 00                	mov    (%eax),%eax
  802d0c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d0f:	8b 52 04             	mov    0x4(%edx),%edx
  802d12:	89 50 04             	mov    %edx,0x4(%eax)
  802d15:	eb 0b                	jmp    802d22 <insert_sorted_with_merge_freeList+0x111>
  802d17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1a:	8b 40 04             	mov    0x4(%eax),%eax
  802d1d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d25:	8b 40 04             	mov    0x4(%eax),%eax
  802d28:	85 c0                	test   %eax,%eax
  802d2a:	74 0f                	je     802d3b <insert_sorted_with_merge_freeList+0x12a>
  802d2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d2f:	8b 40 04             	mov    0x4(%eax),%eax
  802d32:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d35:	8b 12                	mov    (%edx),%edx
  802d37:	89 10                	mov    %edx,(%eax)
  802d39:	eb 0a                	jmp    802d45 <insert_sorted_with_merge_freeList+0x134>
  802d3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d3e:	8b 00                	mov    (%eax),%eax
  802d40:	a3 38 51 80 00       	mov    %eax,0x805138
  802d45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d48:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d51:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d58:	a1 44 51 80 00       	mov    0x805144,%eax
  802d5d:	48                   	dec    %eax
  802d5e:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802d63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d66:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802d6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d70:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802d77:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d7b:	75 17                	jne    802d94 <insert_sorted_with_merge_freeList+0x183>
  802d7d:	83 ec 04             	sub    $0x4,%esp
  802d80:	68 98 3e 80 00       	push   $0x803e98
  802d85:	68 3f 01 00 00       	push   $0x13f
  802d8a:	68 bb 3e 80 00       	push   $0x803ebb
  802d8f:	e8 c9 05 00 00       	call   80335d <_panic>
  802d94:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802d9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d9d:	89 10                	mov    %edx,(%eax)
  802d9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da2:	8b 00                	mov    (%eax),%eax
  802da4:	85 c0                	test   %eax,%eax
  802da6:	74 0d                	je     802db5 <insert_sorted_with_merge_freeList+0x1a4>
  802da8:	a1 48 51 80 00       	mov    0x805148,%eax
  802dad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802db0:	89 50 04             	mov    %edx,0x4(%eax)
  802db3:	eb 08                	jmp    802dbd <insert_sorted_with_merge_freeList+0x1ac>
  802db5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802dbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc0:	a3 48 51 80 00       	mov    %eax,0x805148
  802dc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dcf:	a1 54 51 80 00       	mov    0x805154,%eax
  802dd4:	40                   	inc    %eax
  802dd5:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802dda:	e9 7a 05 00 00       	jmp    803359 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  802de2:	8b 50 08             	mov    0x8(%eax),%edx
  802de5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802de8:	8b 40 08             	mov    0x8(%eax),%eax
  802deb:	39 c2                	cmp    %eax,%edx
  802ded:	0f 82 14 01 00 00    	jb     802f07 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802df3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802df6:	8b 50 08             	mov    0x8(%eax),%edx
  802df9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dfc:	8b 40 0c             	mov    0xc(%eax),%eax
  802dff:	01 c2                	add    %eax,%edx
  802e01:	8b 45 08             	mov    0x8(%ebp),%eax
  802e04:	8b 40 08             	mov    0x8(%eax),%eax
  802e07:	39 c2                	cmp    %eax,%edx
  802e09:	0f 85 90 00 00 00    	jne    802e9f <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802e0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e12:	8b 50 0c             	mov    0xc(%eax),%edx
  802e15:	8b 45 08             	mov    0x8(%ebp),%eax
  802e18:	8b 40 0c             	mov    0xc(%eax),%eax
  802e1b:	01 c2                	add    %eax,%edx
  802e1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e20:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802e23:	8b 45 08             	mov    0x8(%ebp),%eax
  802e26:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e30:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e37:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e3b:	75 17                	jne    802e54 <insert_sorted_with_merge_freeList+0x243>
  802e3d:	83 ec 04             	sub    $0x4,%esp
  802e40:	68 98 3e 80 00       	push   $0x803e98
  802e45:	68 49 01 00 00       	push   $0x149
  802e4a:	68 bb 3e 80 00       	push   $0x803ebb
  802e4f:	e8 09 05 00 00       	call   80335d <_panic>
  802e54:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5d:	89 10                	mov    %edx,(%eax)
  802e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e62:	8b 00                	mov    (%eax),%eax
  802e64:	85 c0                	test   %eax,%eax
  802e66:	74 0d                	je     802e75 <insert_sorted_with_merge_freeList+0x264>
  802e68:	a1 48 51 80 00       	mov    0x805148,%eax
  802e6d:	8b 55 08             	mov    0x8(%ebp),%edx
  802e70:	89 50 04             	mov    %edx,0x4(%eax)
  802e73:	eb 08                	jmp    802e7d <insert_sorted_with_merge_freeList+0x26c>
  802e75:	8b 45 08             	mov    0x8(%ebp),%eax
  802e78:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e80:	a3 48 51 80 00       	mov    %eax,0x805148
  802e85:	8b 45 08             	mov    0x8(%ebp),%eax
  802e88:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e8f:	a1 54 51 80 00       	mov    0x805154,%eax
  802e94:	40                   	inc    %eax
  802e95:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e9a:	e9 bb 04 00 00       	jmp    80335a <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802e9f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ea3:	75 17                	jne    802ebc <insert_sorted_with_merge_freeList+0x2ab>
  802ea5:	83 ec 04             	sub    $0x4,%esp
  802ea8:	68 0c 3f 80 00       	push   $0x803f0c
  802ead:	68 4c 01 00 00       	push   $0x14c
  802eb2:	68 bb 3e 80 00       	push   $0x803ebb
  802eb7:	e8 a1 04 00 00       	call   80335d <_panic>
  802ebc:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec5:	89 50 04             	mov    %edx,0x4(%eax)
  802ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecb:	8b 40 04             	mov    0x4(%eax),%eax
  802ece:	85 c0                	test   %eax,%eax
  802ed0:	74 0c                	je     802ede <insert_sorted_with_merge_freeList+0x2cd>
  802ed2:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802ed7:	8b 55 08             	mov    0x8(%ebp),%edx
  802eda:	89 10                	mov    %edx,(%eax)
  802edc:	eb 08                	jmp    802ee6 <insert_sorted_with_merge_freeList+0x2d5>
  802ede:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee1:	a3 38 51 80 00       	mov    %eax,0x805138
  802ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802eee:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ef7:	a1 44 51 80 00       	mov    0x805144,%eax
  802efc:	40                   	inc    %eax
  802efd:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f02:	e9 53 04 00 00       	jmp    80335a <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802f07:	a1 38 51 80 00       	mov    0x805138,%eax
  802f0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f0f:	e9 15 04 00 00       	jmp    803329 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802f14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f17:	8b 00                	mov    (%eax),%eax
  802f19:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1f:	8b 50 08             	mov    0x8(%eax),%edx
  802f22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f25:	8b 40 08             	mov    0x8(%eax),%eax
  802f28:	39 c2                	cmp    %eax,%edx
  802f2a:	0f 86 f1 03 00 00    	jbe    803321 <insert_sorted_with_merge_freeList+0x710>
  802f30:	8b 45 08             	mov    0x8(%ebp),%eax
  802f33:	8b 50 08             	mov    0x8(%eax),%edx
  802f36:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f39:	8b 40 08             	mov    0x8(%eax),%eax
  802f3c:	39 c2                	cmp    %eax,%edx
  802f3e:	0f 83 dd 03 00 00    	jae    803321 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802f44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f47:	8b 50 08             	mov    0x8(%eax),%edx
  802f4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4d:	8b 40 0c             	mov    0xc(%eax),%eax
  802f50:	01 c2                	add    %eax,%edx
  802f52:	8b 45 08             	mov    0x8(%ebp),%eax
  802f55:	8b 40 08             	mov    0x8(%eax),%eax
  802f58:	39 c2                	cmp    %eax,%edx
  802f5a:	0f 85 b9 01 00 00    	jne    803119 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802f60:	8b 45 08             	mov    0x8(%ebp),%eax
  802f63:	8b 50 08             	mov    0x8(%eax),%edx
  802f66:	8b 45 08             	mov    0x8(%ebp),%eax
  802f69:	8b 40 0c             	mov    0xc(%eax),%eax
  802f6c:	01 c2                	add    %eax,%edx
  802f6e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f71:	8b 40 08             	mov    0x8(%eax),%eax
  802f74:	39 c2                	cmp    %eax,%edx
  802f76:	0f 85 0d 01 00 00    	jne    803089 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802f7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7f:	8b 50 0c             	mov    0xc(%eax),%edx
  802f82:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f85:	8b 40 0c             	mov    0xc(%eax),%eax
  802f88:	01 c2                	add    %eax,%edx
  802f8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8d:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802f90:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f94:	75 17                	jne    802fad <insert_sorted_with_merge_freeList+0x39c>
  802f96:	83 ec 04             	sub    $0x4,%esp
  802f99:	68 64 3f 80 00       	push   $0x803f64
  802f9e:	68 5c 01 00 00       	push   $0x15c
  802fa3:	68 bb 3e 80 00       	push   $0x803ebb
  802fa8:	e8 b0 03 00 00       	call   80335d <_panic>
  802fad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb0:	8b 00                	mov    (%eax),%eax
  802fb2:	85 c0                	test   %eax,%eax
  802fb4:	74 10                	je     802fc6 <insert_sorted_with_merge_freeList+0x3b5>
  802fb6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb9:	8b 00                	mov    (%eax),%eax
  802fbb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fbe:	8b 52 04             	mov    0x4(%edx),%edx
  802fc1:	89 50 04             	mov    %edx,0x4(%eax)
  802fc4:	eb 0b                	jmp    802fd1 <insert_sorted_with_merge_freeList+0x3c0>
  802fc6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc9:	8b 40 04             	mov    0x4(%eax),%eax
  802fcc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fd1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fd4:	8b 40 04             	mov    0x4(%eax),%eax
  802fd7:	85 c0                	test   %eax,%eax
  802fd9:	74 0f                	je     802fea <insert_sorted_with_merge_freeList+0x3d9>
  802fdb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fde:	8b 40 04             	mov    0x4(%eax),%eax
  802fe1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fe4:	8b 12                	mov    (%edx),%edx
  802fe6:	89 10                	mov    %edx,(%eax)
  802fe8:	eb 0a                	jmp    802ff4 <insert_sorted_with_merge_freeList+0x3e3>
  802fea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fed:	8b 00                	mov    (%eax),%eax
  802fef:	a3 38 51 80 00       	mov    %eax,0x805138
  802ff4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ffd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803000:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803007:	a1 44 51 80 00       	mov    0x805144,%eax
  80300c:	48                   	dec    %eax
  80300d:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803012:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803015:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  80301c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80301f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803026:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80302a:	75 17                	jne    803043 <insert_sorted_with_merge_freeList+0x432>
  80302c:	83 ec 04             	sub    $0x4,%esp
  80302f:	68 98 3e 80 00       	push   $0x803e98
  803034:	68 5f 01 00 00       	push   $0x15f
  803039:	68 bb 3e 80 00       	push   $0x803ebb
  80303e:	e8 1a 03 00 00       	call   80335d <_panic>
  803043:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803049:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80304c:	89 10                	mov    %edx,(%eax)
  80304e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803051:	8b 00                	mov    (%eax),%eax
  803053:	85 c0                	test   %eax,%eax
  803055:	74 0d                	je     803064 <insert_sorted_with_merge_freeList+0x453>
  803057:	a1 48 51 80 00       	mov    0x805148,%eax
  80305c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80305f:	89 50 04             	mov    %edx,0x4(%eax)
  803062:	eb 08                	jmp    80306c <insert_sorted_with_merge_freeList+0x45b>
  803064:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803067:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80306c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80306f:	a3 48 51 80 00       	mov    %eax,0x805148
  803074:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803077:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80307e:	a1 54 51 80 00       	mov    0x805154,%eax
  803083:	40                   	inc    %eax
  803084:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803089:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308c:	8b 50 0c             	mov    0xc(%eax),%edx
  80308f:	8b 45 08             	mov    0x8(%ebp),%eax
  803092:	8b 40 0c             	mov    0xc(%eax),%eax
  803095:	01 c2                	add    %eax,%edx
  803097:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309a:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80309d:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8030a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030aa:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8030b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030b5:	75 17                	jne    8030ce <insert_sorted_with_merge_freeList+0x4bd>
  8030b7:	83 ec 04             	sub    $0x4,%esp
  8030ba:	68 98 3e 80 00       	push   $0x803e98
  8030bf:	68 64 01 00 00       	push   $0x164
  8030c4:	68 bb 3e 80 00       	push   $0x803ebb
  8030c9:	e8 8f 02 00 00       	call   80335d <_panic>
  8030ce:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d7:	89 10                	mov    %edx,(%eax)
  8030d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030dc:	8b 00                	mov    (%eax),%eax
  8030de:	85 c0                	test   %eax,%eax
  8030e0:	74 0d                	je     8030ef <insert_sorted_with_merge_freeList+0x4de>
  8030e2:	a1 48 51 80 00       	mov    0x805148,%eax
  8030e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8030ea:	89 50 04             	mov    %edx,0x4(%eax)
  8030ed:	eb 08                	jmp    8030f7 <insert_sorted_with_merge_freeList+0x4e6>
  8030ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fa:	a3 48 51 80 00       	mov    %eax,0x805148
  8030ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803102:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803109:	a1 54 51 80 00       	mov    0x805154,%eax
  80310e:	40                   	inc    %eax
  80310f:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803114:	e9 41 02 00 00       	jmp    80335a <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803119:	8b 45 08             	mov    0x8(%ebp),%eax
  80311c:	8b 50 08             	mov    0x8(%eax),%edx
  80311f:	8b 45 08             	mov    0x8(%ebp),%eax
  803122:	8b 40 0c             	mov    0xc(%eax),%eax
  803125:	01 c2                	add    %eax,%edx
  803127:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80312a:	8b 40 08             	mov    0x8(%eax),%eax
  80312d:	39 c2                	cmp    %eax,%edx
  80312f:	0f 85 7c 01 00 00    	jne    8032b1 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803135:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803139:	74 06                	je     803141 <insert_sorted_with_merge_freeList+0x530>
  80313b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80313f:	75 17                	jne    803158 <insert_sorted_with_merge_freeList+0x547>
  803141:	83 ec 04             	sub    $0x4,%esp
  803144:	68 d4 3e 80 00       	push   $0x803ed4
  803149:	68 69 01 00 00       	push   $0x169
  80314e:	68 bb 3e 80 00       	push   $0x803ebb
  803153:	e8 05 02 00 00       	call   80335d <_panic>
  803158:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80315b:	8b 50 04             	mov    0x4(%eax),%edx
  80315e:	8b 45 08             	mov    0x8(%ebp),%eax
  803161:	89 50 04             	mov    %edx,0x4(%eax)
  803164:	8b 45 08             	mov    0x8(%ebp),%eax
  803167:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80316a:	89 10                	mov    %edx,(%eax)
  80316c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80316f:	8b 40 04             	mov    0x4(%eax),%eax
  803172:	85 c0                	test   %eax,%eax
  803174:	74 0d                	je     803183 <insert_sorted_with_merge_freeList+0x572>
  803176:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803179:	8b 40 04             	mov    0x4(%eax),%eax
  80317c:	8b 55 08             	mov    0x8(%ebp),%edx
  80317f:	89 10                	mov    %edx,(%eax)
  803181:	eb 08                	jmp    80318b <insert_sorted_with_merge_freeList+0x57a>
  803183:	8b 45 08             	mov    0x8(%ebp),%eax
  803186:	a3 38 51 80 00       	mov    %eax,0x805138
  80318b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80318e:	8b 55 08             	mov    0x8(%ebp),%edx
  803191:	89 50 04             	mov    %edx,0x4(%eax)
  803194:	a1 44 51 80 00       	mov    0x805144,%eax
  803199:	40                   	inc    %eax
  80319a:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  80319f:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a2:	8b 50 0c             	mov    0xc(%eax),%edx
  8031a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a8:	8b 40 0c             	mov    0xc(%eax),%eax
  8031ab:	01 c2                	add    %eax,%edx
  8031ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b0:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8031b3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031b7:	75 17                	jne    8031d0 <insert_sorted_with_merge_freeList+0x5bf>
  8031b9:	83 ec 04             	sub    $0x4,%esp
  8031bc:	68 64 3f 80 00       	push   $0x803f64
  8031c1:	68 6b 01 00 00       	push   $0x16b
  8031c6:	68 bb 3e 80 00       	push   $0x803ebb
  8031cb:	e8 8d 01 00 00       	call   80335d <_panic>
  8031d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d3:	8b 00                	mov    (%eax),%eax
  8031d5:	85 c0                	test   %eax,%eax
  8031d7:	74 10                	je     8031e9 <insert_sorted_with_merge_freeList+0x5d8>
  8031d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031dc:	8b 00                	mov    (%eax),%eax
  8031de:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031e1:	8b 52 04             	mov    0x4(%edx),%edx
  8031e4:	89 50 04             	mov    %edx,0x4(%eax)
  8031e7:	eb 0b                	jmp    8031f4 <insert_sorted_with_merge_freeList+0x5e3>
  8031e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ec:	8b 40 04             	mov    0x4(%eax),%eax
  8031ef:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f7:	8b 40 04             	mov    0x4(%eax),%eax
  8031fa:	85 c0                	test   %eax,%eax
  8031fc:	74 0f                	je     80320d <insert_sorted_with_merge_freeList+0x5fc>
  8031fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803201:	8b 40 04             	mov    0x4(%eax),%eax
  803204:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803207:	8b 12                	mov    (%edx),%edx
  803209:	89 10                	mov    %edx,(%eax)
  80320b:	eb 0a                	jmp    803217 <insert_sorted_with_merge_freeList+0x606>
  80320d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803210:	8b 00                	mov    (%eax),%eax
  803212:	a3 38 51 80 00       	mov    %eax,0x805138
  803217:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80321a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803220:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803223:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80322a:	a1 44 51 80 00       	mov    0x805144,%eax
  80322f:	48                   	dec    %eax
  803230:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803235:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803238:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80323f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803242:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803249:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80324d:	75 17                	jne    803266 <insert_sorted_with_merge_freeList+0x655>
  80324f:	83 ec 04             	sub    $0x4,%esp
  803252:	68 98 3e 80 00       	push   $0x803e98
  803257:	68 6e 01 00 00       	push   $0x16e
  80325c:	68 bb 3e 80 00       	push   $0x803ebb
  803261:	e8 f7 00 00 00       	call   80335d <_panic>
  803266:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80326c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80326f:	89 10                	mov    %edx,(%eax)
  803271:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803274:	8b 00                	mov    (%eax),%eax
  803276:	85 c0                	test   %eax,%eax
  803278:	74 0d                	je     803287 <insert_sorted_with_merge_freeList+0x676>
  80327a:	a1 48 51 80 00       	mov    0x805148,%eax
  80327f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803282:	89 50 04             	mov    %edx,0x4(%eax)
  803285:	eb 08                	jmp    80328f <insert_sorted_with_merge_freeList+0x67e>
  803287:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80328a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80328f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803292:	a3 48 51 80 00       	mov    %eax,0x805148
  803297:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80329a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032a1:	a1 54 51 80 00       	mov    0x805154,%eax
  8032a6:	40                   	inc    %eax
  8032a7:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8032ac:	e9 a9 00 00 00       	jmp    80335a <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8032b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032b5:	74 06                	je     8032bd <insert_sorted_with_merge_freeList+0x6ac>
  8032b7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032bb:	75 17                	jne    8032d4 <insert_sorted_with_merge_freeList+0x6c3>
  8032bd:	83 ec 04             	sub    $0x4,%esp
  8032c0:	68 30 3f 80 00       	push   $0x803f30
  8032c5:	68 73 01 00 00       	push   $0x173
  8032ca:	68 bb 3e 80 00       	push   $0x803ebb
  8032cf:	e8 89 00 00 00       	call   80335d <_panic>
  8032d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d7:	8b 10                	mov    (%eax),%edx
  8032d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032dc:	89 10                	mov    %edx,(%eax)
  8032de:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e1:	8b 00                	mov    (%eax),%eax
  8032e3:	85 c0                	test   %eax,%eax
  8032e5:	74 0b                	je     8032f2 <insert_sorted_with_merge_freeList+0x6e1>
  8032e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ea:	8b 00                	mov    (%eax),%eax
  8032ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8032ef:	89 50 04             	mov    %edx,0x4(%eax)
  8032f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8032f8:	89 10                	mov    %edx,(%eax)
  8032fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803300:	89 50 04             	mov    %edx,0x4(%eax)
  803303:	8b 45 08             	mov    0x8(%ebp),%eax
  803306:	8b 00                	mov    (%eax),%eax
  803308:	85 c0                	test   %eax,%eax
  80330a:	75 08                	jne    803314 <insert_sorted_with_merge_freeList+0x703>
  80330c:	8b 45 08             	mov    0x8(%ebp),%eax
  80330f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803314:	a1 44 51 80 00       	mov    0x805144,%eax
  803319:	40                   	inc    %eax
  80331a:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  80331f:	eb 39                	jmp    80335a <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803321:	a1 40 51 80 00       	mov    0x805140,%eax
  803326:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803329:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80332d:	74 07                	je     803336 <insert_sorted_with_merge_freeList+0x725>
  80332f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803332:	8b 00                	mov    (%eax),%eax
  803334:	eb 05                	jmp    80333b <insert_sorted_with_merge_freeList+0x72a>
  803336:	b8 00 00 00 00       	mov    $0x0,%eax
  80333b:	a3 40 51 80 00       	mov    %eax,0x805140
  803340:	a1 40 51 80 00       	mov    0x805140,%eax
  803345:	85 c0                	test   %eax,%eax
  803347:	0f 85 c7 fb ff ff    	jne    802f14 <insert_sorted_with_merge_freeList+0x303>
  80334d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803351:	0f 85 bd fb ff ff    	jne    802f14 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803357:	eb 01                	jmp    80335a <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803359:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80335a:	90                   	nop
  80335b:	c9                   	leave  
  80335c:	c3                   	ret    

0080335d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80335d:	55                   	push   %ebp
  80335e:	89 e5                	mov    %esp,%ebp
  803360:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803363:	8d 45 10             	lea    0x10(%ebp),%eax
  803366:	83 c0 04             	add    $0x4,%eax
  803369:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80336c:	a1 5c 51 80 00       	mov    0x80515c,%eax
  803371:	85 c0                	test   %eax,%eax
  803373:	74 16                	je     80338b <_panic+0x2e>
		cprintf("%s: ", argv0);
  803375:	a1 5c 51 80 00       	mov    0x80515c,%eax
  80337a:	83 ec 08             	sub    $0x8,%esp
  80337d:	50                   	push   %eax
  80337e:	68 84 3f 80 00       	push   $0x803f84
  803383:	e8 de d1 ff ff       	call   800566 <cprintf>
  803388:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80338b:	a1 00 50 80 00       	mov    0x805000,%eax
  803390:	ff 75 0c             	pushl  0xc(%ebp)
  803393:	ff 75 08             	pushl  0x8(%ebp)
  803396:	50                   	push   %eax
  803397:	68 89 3f 80 00       	push   $0x803f89
  80339c:	e8 c5 d1 ff ff       	call   800566 <cprintf>
  8033a1:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8033a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8033a7:	83 ec 08             	sub    $0x8,%esp
  8033aa:	ff 75 f4             	pushl  -0xc(%ebp)
  8033ad:	50                   	push   %eax
  8033ae:	e8 48 d1 ff ff       	call   8004fb <vcprintf>
  8033b3:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8033b6:	83 ec 08             	sub    $0x8,%esp
  8033b9:	6a 00                	push   $0x0
  8033bb:	68 a5 3f 80 00       	push   $0x803fa5
  8033c0:	e8 36 d1 ff ff       	call   8004fb <vcprintf>
  8033c5:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8033c8:	e8 b7 d0 ff ff       	call   800484 <exit>

	// should not return here
	while (1) ;
  8033cd:	eb fe                	jmp    8033cd <_panic+0x70>

008033cf <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8033cf:	55                   	push   %ebp
  8033d0:	89 e5                	mov    %esp,%ebp
  8033d2:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8033d5:	a1 20 50 80 00       	mov    0x805020,%eax
  8033da:	8b 50 74             	mov    0x74(%eax),%edx
  8033dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033e0:	39 c2                	cmp    %eax,%edx
  8033e2:	74 14                	je     8033f8 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8033e4:	83 ec 04             	sub    $0x4,%esp
  8033e7:	68 a8 3f 80 00       	push   $0x803fa8
  8033ec:	6a 26                	push   $0x26
  8033ee:	68 f4 3f 80 00       	push   $0x803ff4
  8033f3:	e8 65 ff ff ff       	call   80335d <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8033f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8033ff:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803406:	e9 c2 00 00 00       	jmp    8034cd <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80340b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80340e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803415:	8b 45 08             	mov    0x8(%ebp),%eax
  803418:	01 d0                	add    %edx,%eax
  80341a:	8b 00                	mov    (%eax),%eax
  80341c:	85 c0                	test   %eax,%eax
  80341e:	75 08                	jne    803428 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  803420:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803423:	e9 a2 00 00 00       	jmp    8034ca <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  803428:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80342f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803436:	eb 69                	jmp    8034a1 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803438:	a1 20 50 80 00       	mov    0x805020,%eax
  80343d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803443:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803446:	89 d0                	mov    %edx,%eax
  803448:	01 c0                	add    %eax,%eax
  80344a:	01 d0                	add    %edx,%eax
  80344c:	c1 e0 03             	shl    $0x3,%eax
  80344f:	01 c8                	add    %ecx,%eax
  803451:	8a 40 04             	mov    0x4(%eax),%al
  803454:	84 c0                	test   %al,%al
  803456:	75 46                	jne    80349e <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803458:	a1 20 50 80 00       	mov    0x805020,%eax
  80345d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803463:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803466:	89 d0                	mov    %edx,%eax
  803468:	01 c0                	add    %eax,%eax
  80346a:	01 d0                	add    %edx,%eax
  80346c:	c1 e0 03             	shl    $0x3,%eax
  80346f:	01 c8                	add    %ecx,%eax
  803471:	8b 00                	mov    (%eax),%eax
  803473:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803476:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803479:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80347e:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803480:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803483:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80348a:	8b 45 08             	mov    0x8(%ebp),%eax
  80348d:	01 c8                	add    %ecx,%eax
  80348f:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803491:	39 c2                	cmp    %eax,%edx
  803493:	75 09                	jne    80349e <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  803495:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80349c:	eb 12                	jmp    8034b0 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80349e:	ff 45 e8             	incl   -0x18(%ebp)
  8034a1:	a1 20 50 80 00       	mov    0x805020,%eax
  8034a6:	8b 50 74             	mov    0x74(%eax),%edx
  8034a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ac:	39 c2                	cmp    %eax,%edx
  8034ae:	77 88                	ja     803438 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8034b0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8034b4:	75 14                	jne    8034ca <CheckWSWithoutLastIndex+0xfb>
			panic(
  8034b6:	83 ec 04             	sub    $0x4,%esp
  8034b9:	68 00 40 80 00       	push   $0x804000
  8034be:	6a 3a                	push   $0x3a
  8034c0:	68 f4 3f 80 00       	push   $0x803ff4
  8034c5:	e8 93 fe ff ff       	call   80335d <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8034ca:	ff 45 f0             	incl   -0x10(%ebp)
  8034cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034d0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8034d3:	0f 8c 32 ff ff ff    	jl     80340b <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8034d9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8034e0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8034e7:	eb 26                	jmp    80350f <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8034e9:	a1 20 50 80 00       	mov    0x805020,%eax
  8034ee:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8034f4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8034f7:	89 d0                	mov    %edx,%eax
  8034f9:	01 c0                	add    %eax,%eax
  8034fb:	01 d0                	add    %edx,%eax
  8034fd:	c1 e0 03             	shl    $0x3,%eax
  803500:	01 c8                	add    %ecx,%eax
  803502:	8a 40 04             	mov    0x4(%eax),%al
  803505:	3c 01                	cmp    $0x1,%al
  803507:	75 03                	jne    80350c <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  803509:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80350c:	ff 45 e0             	incl   -0x20(%ebp)
  80350f:	a1 20 50 80 00       	mov    0x805020,%eax
  803514:	8b 50 74             	mov    0x74(%eax),%edx
  803517:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80351a:	39 c2                	cmp    %eax,%edx
  80351c:	77 cb                	ja     8034e9 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80351e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803521:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803524:	74 14                	je     80353a <CheckWSWithoutLastIndex+0x16b>
		panic(
  803526:	83 ec 04             	sub    $0x4,%esp
  803529:	68 54 40 80 00       	push   $0x804054
  80352e:	6a 44                	push   $0x44
  803530:	68 f4 3f 80 00       	push   $0x803ff4
  803535:	e8 23 fe ff ff       	call   80335d <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80353a:	90                   	nop
  80353b:	c9                   	leave  
  80353c:	c3                   	ret    
  80353d:	66 90                	xchg   %ax,%ax
  80353f:	90                   	nop

00803540 <__udivdi3>:
  803540:	55                   	push   %ebp
  803541:	57                   	push   %edi
  803542:	56                   	push   %esi
  803543:	53                   	push   %ebx
  803544:	83 ec 1c             	sub    $0x1c,%esp
  803547:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80354b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80354f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803553:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803557:	89 ca                	mov    %ecx,%edx
  803559:	89 f8                	mov    %edi,%eax
  80355b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80355f:	85 f6                	test   %esi,%esi
  803561:	75 2d                	jne    803590 <__udivdi3+0x50>
  803563:	39 cf                	cmp    %ecx,%edi
  803565:	77 65                	ja     8035cc <__udivdi3+0x8c>
  803567:	89 fd                	mov    %edi,%ebp
  803569:	85 ff                	test   %edi,%edi
  80356b:	75 0b                	jne    803578 <__udivdi3+0x38>
  80356d:	b8 01 00 00 00       	mov    $0x1,%eax
  803572:	31 d2                	xor    %edx,%edx
  803574:	f7 f7                	div    %edi
  803576:	89 c5                	mov    %eax,%ebp
  803578:	31 d2                	xor    %edx,%edx
  80357a:	89 c8                	mov    %ecx,%eax
  80357c:	f7 f5                	div    %ebp
  80357e:	89 c1                	mov    %eax,%ecx
  803580:	89 d8                	mov    %ebx,%eax
  803582:	f7 f5                	div    %ebp
  803584:	89 cf                	mov    %ecx,%edi
  803586:	89 fa                	mov    %edi,%edx
  803588:	83 c4 1c             	add    $0x1c,%esp
  80358b:	5b                   	pop    %ebx
  80358c:	5e                   	pop    %esi
  80358d:	5f                   	pop    %edi
  80358e:	5d                   	pop    %ebp
  80358f:	c3                   	ret    
  803590:	39 ce                	cmp    %ecx,%esi
  803592:	77 28                	ja     8035bc <__udivdi3+0x7c>
  803594:	0f bd fe             	bsr    %esi,%edi
  803597:	83 f7 1f             	xor    $0x1f,%edi
  80359a:	75 40                	jne    8035dc <__udivdi3+0x9c>
  80359c:	39 ce                	cmp    %ecx,%esi
  80359e:	72 0a                	jb     8035aa <__udivdi3+0x6a>
  8035a0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8035a4:	0f 87 9e 00 00 00    	ja     803648 <__udivdi3+0x108>
  8035aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8035af:	89 fa                	mov    %edi,%edx
  8035b1:	83 c4 1c             	add    $0x1c,%esp
  8035b4:	5b                   	pop    %ebx
  8035b5:	5e                   	pop    %esi
  8035b6:	5f                   	pop    %edi
  8035b7:	5d                   	pop    %ebp
  8035b8:	c3                   	ret    
  8035b9:	8d 76 00             	lea    0x0(%esi),%esi
  8035bc:	31 ff                	xor    %edi,%edi
  8035be:	31 c0                	xor    %eax,%eax
  8035c0:	89 fa                	mov    %edi,%edx
  8035c2:	83 c4 1c             	add    $0x1c,%esp
  8035c5:	5b                   	pop    %ebx
  8035c6:	5e                   	pop    %esi
  8035c7:	5f                   	pop    %edi
  8035c8:	5d                   	pop    %ebp
  8035c9:	c3                   	ret    
  8035ca:	66 90                	xchg   %ax,%ax
  8035cc:	89 d8                	mov    %ebx,%eax
  8035ce:	f7 f7                	div    %edi
  8035d0:	31 ff                	xor    %edi,%edi
  8035d2:	89 fa                	mov    %edi,%edx
  8035d4:	83 c4 1c             	add    $0x1c,%esp
  8035d7:	5b                   	pop    %ebx
  8035d8:	5e                   	pop    %esi
  8035d9:	5f                   	pop    %edi
  8035da:	5d                   	pop    %ebp
  8035db:	c3                   	ret    
  8035dc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8035e1:	89 eb                	mov    %ebp,%ebx
  8035e3:	29 fb                	sub    %edi,%ebx
  8035e5:	89 f9                	mov    %edi,%ecx
  8035e7:	d3 e6                	shl    %cl,%esi
  8035e9:	89 c5                	mov    %eax,%ebp
  8035eb:	88 d9                	mov    %bl,%cl
  8035ed:	d3 ed                	shr    %cl,%ebp
  8035ef:	89 e9                	mov    %ebp,%ecx
  8035f1:	09 f1                	or     %esi,%ecx
  8035f3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8035f7:	89 f9                	mov    %edi,%ecx
  8035f9:	d3 e0                	shl    %cl,%eax
  8035fb:	89 c5                	mov    %eax,%ebp
  8035fd:	89 d6                	mov    %edx,%esi
  8035ff:	88 d9                	mov    %bl,%cl
  803601:	d3 ee                	shr    %cl,%esi
  803603:	89 f9                	mov    %edi,%ecx
  803605:	d3 e2                	shl    %cl,%edx
  803607:	8b 44 24 08          	mov    0x8(%esp),%eax
  80360b:	88 d9                	mov    %bl,%cl
  80360d:	d3 e8                	shr    %cl,%eax
  80360f:	09 c2                	or     %eax,%edx
  803611:	89 d0                	mov    %edx,%eax
  803613:	89 f2                	mov    %esi,%edx
  803615:	f7 74 24 0c          	divl   0xc(%esp)
  803619:	89 d6                	mov    %edx,%esi
  80361b:	89 c3                	mov    %eax,%ebx
  80361d:	f7 e5                	mul    %ebp
  80361f:	39 d6                	cmp    %edx,%esi
  803621:	72 19                	jb     80363c <__udivdi3+0xfc>
  803623:	74 0b                	je     803630 <__udivdi3+0xf0>
  803625:	89 d8                	mov    %ebx,%eax
  803627:	31 ff                	xor    %edi,%edi
  803629:	e9 58 ff ff ff       	jmp    803586 <__udivdi3+0x46>
  80362e:	66 90                	xchg   %ax,%ax
  803630:	8b 54 24 08          	mov    0x8(%esp),%edx
  803634:	89 f9                	mov    %edi,%ecx
  803636:	d3 e2                	shl    %cl,%edx
  803638:	39 c2                	cmp    %eax,%edx
  80363a:	73 e9                	jae    803625 <__udivdi3+0xe5>
  80363c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80363f:	31 ff                	xor    %edi,%edi
  803641:	e9 40 ff ff ff       	jmp    803586 <__udivdi3+0x46>
  803646:	66 90                	xchg   %ax,%ax
  803648:	31 c0                	xor    %eax,%eax
  80364a:	e9 37 ff ff ff       	jmp    803586 <__udivdi3+0x46>
  80364f:	90                   	nop

00803650 <__umoddi3>:
  803650:	55                   	push   %ebp
  803651:	57                   	push   %edi
  803652:	56                   	push   %esi
  803653:	53                   	push   %ebx
  803654:	83 ec 1c             	sub    $0x1c,%esp
  803657:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80365b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80365f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803663:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803667:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80366b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80366f:	89 f3                	mov    %esi,%ebx
  803671:	89 fa                	mov    %edi,%edx
  803673:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803677:	89 34 24             	mov    %esi,(%esp)
  80367a:	85 c0                	test   %eax,%eax
  80367c:	75 1a                	jne    803698 <__umoddi3+0x48>
  80367e:	39 f7                	cmp    %esi,%edi
  803680:	0f 86 a2 00 00 00    	jbe    803728 <__umoddi3+0xd8>
  803686:	89 c8                	mov    %ecx,%eax
  803688:	89 f2                	mov    %esi,%edx
  80368a:	f7 f7                	div    %edi
  80368c:	89 d0                	mov    %edx,%eax
  80368e:	31 d2                	xor    %edx,%edx
  803690:	83 c4 1c             	add    $0x1c,%esp
  803693:	5b                   	pop    %ebx
  803694:	5e                   	pop    %esi
  803695:	5f                   	pop    %edi
  803696:	5d                   	pop    %ebp
  803697:	c3                   	ret    
  803698:	39 f0                	cmp    %esi,%eax
  80369a:	0f 87 ac 00 00 00    	ja     80374c <__umoddi3+0xfc>
  8036a0:	0f bd e8             	bsr    %eax,%ebp
  8036a3:	83 f5 1f             	xor    $0x1f,%ebp
  8036a6:	0f 84 ac 00 00 00    	je     803758 <__umoddi3+0x108>
  8036ac:	bf 20 00 00 00       	mov    $0x20,%edi
  8036b1:	29 ef                	sub    %ebp,%edi
  8036b3:	89 fe                	mov    %edi,%esi
  8036b5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8036b9:	89 e9                	mov    %ebp,%ecx
  8036bb:	d3 e0                	shl    %cl,%eax
  8036bd:	89 d7                	mov    %edx,%edi
  8036bf:	89 f1                	mov    %esi,%ecx
  8036c1:	d3 ef                	shr    %cl,%edi
  8036c3:	09 c7                	or     %eax,%edi
  8036c5:	89 e9                	mov    %ebp,%ecx
  8036c7:	d3 e2                	shl    %cl,%edx
  8036c9:	89 14 24             	mov    %edx,(%esp)
  8036cc:	89 d8                	mov    %ebx,%eax
  8036ce:	d3 e0                	shl    %cl,%eax
  8036d0:	89 c2                	mov    %eax,%edx
  8036d2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036d6:	d3 e0                	shl    %cl,%eax
  8036d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8036dc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036e0:	89 f1                	mov    %esi,%ecx
  8036e2:	d3 e8                	shr    %cl,%eax
  8036e4:	09 d0                	or     %edx,%eax
  8036e6:	d3 eb                	shr    %cl,%ebx
  8036e8:	89 da                	mov    %ebx,%edx
  8036ea:	f7 f7                	div    %edi
  8036ec:	89 d3                	mov    %edx,%ebx
  8036ee:	f7 24 24             	mull   (%esp)
  8036f1:	89 c6                	mov    %eax,%esi
  8036f3:	89 d1                	mov    %edx,%ecx
  8036f5:	39 d3                	cmp    %edx,%ebx
  8036f7:	0f 82 87 00 00 00    	jb     803784 <__umoddi3+0x134>
  8036fd:	0f 84 91 00 00 00    	je     803794 <__umoddi3+0x144>
  803703:	8b 54 24 04          	mov    0x4(%esp),%edx
  803707:	29 f2                	sub    %esi,%edx
  803709:	19 cb                	sbb    %ecx,%ebx
  80370b:	89 d8                	mov    %ebx,%eax
  80370d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803711:	d3 e0                	shl    %cl,%eax
  803713:	89 e9                	mov    %ebp,%ecx
  803715:	d3 ea                	shr    %cl,%edx
  803717:	09 d0                	or     %edx,%eax
  803719:	89 e9                	mov    %ebp,%ecx
  80371b:	d3 eb                	shr    %cl,%ebx
  80371d:	89 da                	mov    %ebx,%edx
  80371f:	83 c4 1c             	add    $0x1c,%esp
  803722:	5b                   	pop    %ebx
  803723:	5e                   	pop    %esi
  803724:	5f                   	pop    %edi
  803725:	5d                   	pop    %ebp
  803726:	c3                   	ret    
  803727:	90                   	nop
  803728:	89 fd                	mov    %edi,%ebp
  80372a:	85 ff                	test   %edi,%edi
  80372c:	75 0b                	jne    803739 <__umoddi3+0xe9>
  80372e:	b8 01 00 00 00       	mov    $0x1,%eax
  803733:	31 d2                	xor    %edx,%edx
  803735:	f7 f7                	div    %edi
  803737:	89 c5                	mov    %eax,%ebp
  803739:	89 f0                	mov    %esi,%eax
  80373b:	31 d2                	xor    %edx,%edx
  80373d:	f7 f5                	div    %ebp
  80373f:	89 c8                	mov    %ecx,%eax
  803741:	f7 f5                	div    %ebp
  803743:	89 d0                	mov    %edx,%eax
  803745:	e9 44 ff ff ff       	jmp    80368e <__umoddi3+0x3e>
  80374a:	66 90                	xchg   %ax,%ax
  80374c:	89 c8                	mov    %ecx,%eax
  80374e:	89 f2                	mov    %esi,%edx
  803750:	83 c4 1c             	add    $0x1c,%esp
  803753:	5b                   	pop    %ebx
  803754:	5e                   	pop    %esi
  803755:	5f                   	pop    %edi
  803756:	5d                   	pop    %ebp
  803757:	c3                   	ret    
  803758:	3b 04 24             	cmp    (%esp),%eax
  80375b:	72 06                	jb     803763 <__umoddi3+0x113>
  80375d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803761:	77 0f                	ja     803772 <__umoddi3+0x122>
  803763:	89 f2                	mov    %esi,%edx
  803765:	29 f9                	sub    %edi,%ecx
  803767:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80376b:	89 14 24             	mov    %edx,(%esp)
  80376e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803772:	8b 44 24 04          	mov    0x4(%esp),%eax
  803776:	8b 14 24             	mov    (%esp),%edx
  803779:	83 c4 1c             	add    $0x1c,%esp
  80377c:	5b                   	pop    %ebx
  80377d:	5e                   	pop    %esi
  80377e:	5f                   	pop    %edi
  80377f:	5d                   	pop    %ebp
  803780:	c3                   	ret    
  803781:	8d 76 00             	lea    0x0(%esi),%esi
  803784:	2b 04 24             	sub    (%esp),%eax
  803787:	19 fa                	sbb    %edi,%edx
  803789:	89 d1                	mov    %edx,%ecx
  80378b:	89 c6                	mov    %eax,%esi
  80378d:	e9 71 ff ff ff       	jmp    803703 <__umoddi3+0xb3>
  803792:	66 90                	xchg   %ax,%ax
  803794:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803798:	72 ea                	jb     803784 <__umoddi3+0x134>
  80379a:	89 d9                	mov    %ebx,%ecx
  80379c:	e9 62 ff ff ff       	jmp    803703 <__umoddi3+0xb3>
