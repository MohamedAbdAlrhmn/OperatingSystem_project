
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
  80003e:	e8 fa 19 00 00       	call   801a3d <sys_getenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int32 parentenvID = sys_getparentenvid();
  800046:	e8 24 1a 00 00       	call   801a6f <sys_getparentenvid>
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
  80005f:	68 80 37 80 00       	push   $0x803780
  800064:	ff 75 ec             	pushl  -0x14(%ebp)
  800067:	e8 66 15 00 00       	call   8015d2 <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	numOfElements = sget(parentenvID,"arrSize") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 84 37 80 00       	push   $0x803784
  80007a:	ff 75 ec             	pushl  -0x14(%ebp)
  80007d:	e8 50 15 00 00       	call   8015d2 <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//Get the check-finishing counter
	int *finishedCount = NULL;
  800088:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	finishedCount = sget(parentenvID,"finishedCount") ;
  80008f:	83 ec 08             	sub    $0x8,%esp
  800092:	68 8c 37 80 00       	push   $0x80378c
  800097:	ff 75 ec             	pushl  -0x14(%ebp)
  80009a:	e8 33 15 00 00       	call   8015d2 <sget>
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
  8000b3:	68 9a 37 80 00       	push   $0x80379a
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
  800112:	68 a9 37 80 00       	push   $0x8037a9
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
  800166:	e8 37 19 00 00       	call   801aa2 <sys_get_virtual_time>
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
  8002f6:	68 c5 37 80 00       	push   $0x8037c5
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
  800318:	68 c7 37 80 00       	push   $0x8037c7
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
  800346:	68 cc 37 80 00       	push   $0x8037cc
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
  80035c:	e8 f5 16 00 00       	call   801a56 <sys_getenvindex>
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
  8003c7:	e8 97 14 00 00       	call   801863 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8003cc:	83 ec 0c             	sub    $0xc,%esp
  8003cf:	68 e8 37 80 00       	push   $0x8037e8
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
  8003f7:	68 10 38 80 00       	push   $0x803810
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
  800428:	68 38 38 80 00       	push   $0x803838
  80042d:	e8 34 01 00 00       	call   800566 <cprintf>
  800432:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800435:	a1 20 50 80 00       	mov    0x805020,%eax
  80043a:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800440:	83 ec 08             	sub    $0x8,%esp
  800443:	50                   	push   %eax
  800444:	68 90 38 80 00       	push   $0x803890
  800449:	e8 18 01 00 00       	call   800566 <cprintf>
  80044e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800451:	83 ec 0c             	sub    $0xc,%esp
  800454:	68 e8 37 80 00       	push   $0x8037e8
  800459:	e8 08 01 00 00       	call   800566 <cprintf>
  80045e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800461:	e8 17 14 00 00       	call   80187d <sys_enable_interrupt>

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
  800479:	e8 a4 15 00 00       	call   801a22 <sys_destroy_env>
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
  80048a:	e8 f9 15 00 00       	call   801a88 <sys_exit_env>
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
  8004d8:	e8 d8 11 00 00       	call   8016b5 <sys_cputs>
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
  80054f:	e8 61 11 00 00       	call   8016b5 <sys_cputs>
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
  800599:	e8 c5 12 00 00       	call   801863 <sys_disable_interrupt>
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
  8005b9:	e8 bf 12 00 00       	call   80187d <sys_enable_interrupt>
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
  800603:	e8 10 2f 00 00       	call   803518 <__udivdi3>
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
  800653:	e8 d0 2f 00 00       	call   803628 <__umoddi3>
  800658:	83 c4 10             	add    $0x10,%esp
  80065b:	05 d4 3a 80 00       	add    $0x803ad4,%eax
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
  8007ae:	8b 04 85 f8 3a 80 00 	mov    0x803af8(,%eax,4),%eax
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
  80088f:	8b 34 9d 40 39 80 00 	mov    0x803940(,%ebx,4),%esi
  800896:	85 f6                	test   %esi,%esi
  800898:	75 19                	jne    8008b3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80089a:	53                   	push   %ebx
  80089b:	68 e5 3a 80 00       	push   $0x803ae5
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
  8008b4:	68 ee 3a 80 00       	push   $0x803aee
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
  8008e1:	be f1 3a 80 00       	mov    $0x803af1,%esi
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
  801307:	68 50 3c 80 00       	push   $0x803c50
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
  8013d7:	e8 1d 04 00 00       	call   8017f9 <sys_allocate_chunk>
  8013dc:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013df:	a1 20 51 80 00       	mov    0x805120,%eax
  8013e4:	83 ec 0c             	sub    $0xc,%esp
  8013e7:	50                   	push   %eax
  8013e8:	e8 92 0a 00 00       	call   801e7f <initialize_MemBlocksList>
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
  801415:	68 75 3c 80 00       	push   $0x803c75
  80141a:	6a 33                	push   $0x33
  80141c:	68 93 3c 80 00       	push   $0x803c93
  801421:	e8 12 1f 00 00       	call   803338 <_panic>
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
  801494:	68 a0 3c 80 00       	push   $0x803ca0
  801499:	6a 34                	push   $0x34
  80149b:	68 93 3c 80 00       	push   $0x803c93
  8014a0:	e8 93 1e 00 00       	call   803338 <_panic>
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
  801509:	68 c4 3c 80 00       	push   $0x803cc4
  80150e:	6a 46                	push   $0x46
  801510:	68 93 3c 80 00       	push   $0x803c93
  801515:	e8 1e 1e 00 00       	call   803338 <_panic>
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
  801525:	68 ec 3c 80 00       	push   $0x803cec
  80152a:	6a 61                	push   $0x61
  80152c:	68 93 3c 80 00       	push   $0x803c93
  801531:	e8 02 1e 00 00       	call   803338 <_panic>

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
  80154b:	75 07                	jne    801554 <smalloc+0x1e>
  80154d:	b8 00 00 00 00       	mov    $0x0,%eax
  801552:	eb 7c                	jmp    8015d0 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801554:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80155b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80155e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801561:	01 d0                	add    %edx,%eax
  801563:	48                   	dec    %eax
  801564:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801567:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80156a:	ba 00 00 00 00       	mov    $0x0,%edx
  80156f:	f7 75 f0             	divl   -0x10(%ebp)
  801572:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801575:	29 d0                	sub    %edx,%eax
  801577:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  80157a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801581:	e8 41 06 00 00       	call   801bc7 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801586:	85 c0                	test   %eax,%eax
  801588:	74 11                	je     80159b <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  80158a:	83 ec 0c             	sub    $0xc,%esp
  80158d:	ff 75 e8             	pushl  -0x18(%ebp)
  801590:	e8 ac 0c 00 00       	call   802241 <alloc_block_FF>
  801595:	83 c4 10             	add    $0x10,%esp
  801598:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  80159b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80159f:	74 2a                	je     8015cb <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8015a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015a4:	8b 40 08             	mov    0x8(%eax),%eax
  8015a7:	89 c2                	mov    %eax,%edx
  8015a9:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8015ad:	52                   	push   %edx
  8015ae:	50                   	push   %eax
  8015af:	ff 75 0c             	pushl  0xc(%ebp)
  8015b2:	ff 75 08             	pushl  0x8(%ebp)
  8015b5:	e8 92 03 00 00       	call   80194c <sys_createSharedObject>
  8015ba:	83 c4 10             	add    $0x10,%esp
  8015bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  8015c0:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  8015c4:	74 05                	je     8015cb <smalloc+0x95>
			return (void*)virtual_address;
  8015c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015c9:	eb 05                	jmp    8015d0 <smalloc+0x9a>
	}
	return NULL;
  8015cb:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8015d0:	c9                   	leave  
  8015d1:	c3                   	ret    

008015d2 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8015d2:	55                   	push   %ebp
  8015d3:	89 e5                	mov    %esp,%ebp
  8015d5:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015d8:	e8 13 fd ff ff       	call   8012f0 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8015dd:	83 ec 04             	sub    $0x4,%esp
  8015e0:	68 10 3d 80 00       	push   $0x803d10
  8015e5:	68 a2 00 00 00       	push   $0xa2
  8015ea:	68 93 3c 80 00       	push   $0x803c93
  8015ef:	e8 44 1d 00 00       	call   803338 <_panic>

008015f4 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8015f4:	55                   	push   %ebp
  8015f5:	89 e5                	mov    %esp,%ebp
  8015f7:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015fa:	e8 f1 fc ff ff       	call   8012f0 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8015ff:	83 ec 04             	sub    $0x4,%esp
  801602:	68 34 3d 80 00       	push   $0x803d34
  801607:	68 e6 00 00 00       	push   $0xe6
  80160c:	68 93 3c 80 00       	push   $0x803c93
  801611:	e8 22 1d 00 00       	call   803338 <_panic>

00801616 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801616:	55                   	push   %ebp
  801617:	89 e5                	mov    %esp,%ebp
  801619:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80161c:	83 ec 04             	sub    $0x4,%esp
  80161f:	68 5c 3d 80 00       	push   $0x803d5c
  801624:	68 fa 00 00 00       	push   $0xfa
  801629:	68 93 3c 80 00       	push   $0x803c93
  80162e:	e8 05 1d 00 00       	call   803338 <_panic>

00801633 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801633:	55                   	push   %ebp
  801634:	89 e5                	mov    %esp,%ebp
  801636:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801639:	83 ec 04             	sub    $0x4,%esp
  80163c:	68 80 3d 80 00       	push   $0x803d80
  801641:	68 05 01 00 00       	push   $0x105
  801646:	68 93 3c 80 00       	push   $0x803c93
  80164b:	e8 e8 1c 00 00       	call   803338 <_panic>

00801650 <shrink>:

}
void shrink(uint32 newSize)
{
  801650:	55                   	push   %ebp
  801651:	89 e5                	mov    %esp,%ebp
  801653:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801656:	83 ec 04             	sub    $0x4,%esp
  801659:	68 80 3d 80 00       	push   $0x803d80
  80165e:	68 0a 01 00 00       	push   $0x10a
  801663:	68 93 3c 80 00       	push   $0x803c93
  801668:	e8 cb 1c 00 00       	call   803338 <_panic>

0080166d <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80166d:	55                   	push   %ebp
  80166e:	89 e5                	mov    %esp,%ebp
  801670:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801673:	83 ec 04             	sub    $0x4,%esp
  801676:	68 80 3d 80 00       	push   $0x803d80
  80167b:	68 0f 01 00 00       	push   $0x10f
  801680:	68 93 3c 80 00       	push   $0x803c93
  801685:	e8 ae 1c 00 00       	call   803338 <_panic>

0080168a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80168a:	55                   	push   %ebp
  80168b:	89 e5                	mov    %esp,%ebp
  80168d:	57                   	push   %edi
  80168e:	56                   	push   %esi
  80168f:	53                   	push   %ebx
  801690:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801693:	8b 45 08             	mov    0x8(%ebp),%eax
  801696:	8b 55 0c             	mov    0xc(%ebp),%edx
  801699:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80169c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80169f:	8b 7d 18             	mov    0x18(%ebp),%edi
  8016a2:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8016a5:	cd 30                	int    $0x30
  8016a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8016aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8016ad:	83 c4 10             	add    $0x10,%esp
  8016b0:	5b                   	pop    %ebx
  8016b1:	5e                   	pop    %esi
  8016b2:	5f                   	pop    %edi
  8016b3:	5d                   	pop    %ebp
  8016b4:	c3                   	ret    

008016b5 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8016b5:	55                   	push   %ebp
  8016b6:	89 e5                	mov    %esp,%ebp
  8016b8:	83 ec 04             	sub    $0x4,%esp
  8016bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8016be:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8016c1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c8:	6a 00                	push   $0x0
  8016ca:	6a 00                	push   $0x0
  8016cc:	52                   	push   %edx
  8016cd:	ff 75 0c             	pushl  0xc(%ebp)
  8016d0:	50                   	push   %eax
  8016d1:	6a 00                	push   $0x0
  8016d3:	e8 b2 ff ff ff       	call   80168a <syscall>
  8016d8:	83 c4 18             	add    $0x18,%esp
}
  8016db:	90                   	nop
  8016dc:	c9                   	leave  
  8016dd:	c3                   	ret    

008016de <sys_cgetc>:

int
sys_cgetc(void)
{
  8016de:	55                   	push   %ebp
  8016df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8016e1:	6a 00                	push   $0x0
  8016e3:	6a 00                	push   $0x0
  8016e5:	6a 00                	push   $0x0
  8016e7:	6a 00                	push   $0x0
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 01                	push   $0x1
  8016ed:	e8 98 ff ff ff       	call   80168a <syscall>
  8016f2:	83 c4 18             	add    $0x18,%esp
}
  8016f5:	c9                   	leave  
  8016f6:	c3                   	ret    

008016f7 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8016f7:	55                   	push   %ebp
  8016f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8016fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	6a 00                	push   $0x0
  801706:	52                   	push   %edx
  801707:	50                   	push   %eax
  801708:	6a 05                	push   $0x5
  80170a:	e8 7b ff ff ff       	call   80168a <syscall>
  80170f:	83 c4 18             	add    $0x18,%esp
}
  801712:	c9                   	leave  
  801713:	c3                   	ret    

00801714 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801714:	55                   	push   %ebp
  801715:	89 e5                	mov    %esp,%ebp
  801717:	56                   	push   %esi
  801718:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801719:	8b 75 18             	mov    0x18(%ebp),%esi
  80171c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80171f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801722:	8b 55 0c             	mov    0xc(%ebp),%edx
  801725:	8b 45 08             	mov    0x8(%ebp),%eax
  801728:	56                   	push   %esi
  801729:	53                   	push   %ebx
  80172a:	51                   	push   %ecx
  80172b:	52                   	push   %edx
  80172c:	50                   	push   %eax
  80172d:	6a 06                	push   $0x6
  80172f:	e8 56 ff ff ff       	call   80168a <syscall>
  801734:	83 c4 18             	add    $0x18,%esp
}
  801737:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80173a:	5b                   	pop    %ebx
  80173b:	5e                   	pop    %esi
  80173c:	5d                   	pop    %ebp
  80173d:	c3                   	ret    

0080173e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80173e:	55                   	push   %ebp
  80173f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801741:	8b 55 0c             	mov    0xc(%ebp),%edx
  801744:	8b 45 08             	mov    0x8(%ebp),%eax
  801747:	6a 00                	push   $0x0
  801749:	6a 00                	push   $0x0
  80174b:	6a 00                	push   $0x0
  80174d:	52                   	push   %edx
  80174e:	50                   	push   %eax
  80174f:	6a 07                	push   $0x7
  801751:	e8 34 ff ff ff       	call   80168a <syscall>
  801756:	83 c4 18             	add    $0x18,%esp
}
  801759:	c9                   	leave  
  80175a:	c3                   	ret    

0080175b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80175b:	55                   	push   %ebp
  80175c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80175e:	6a 00                	push   $0x0
  801760:	6a 00                	push   $0x0
  801762:	6a 00                	push   $0x0
  801764:	ff 75 0c             	pushl  0xc(%ebp)
  801767:	ff 75 08             	pushl  0x8(%ebp)
  80176a:	6a 08                	push   $0x8
  80176c:	e8 19 ff ff ff       	call   80168a <syscall>
  801771:	83 c4 18             	add    $0x18,%esp
}
  801774:	c9                   	leave  
  801775:	c3                   	ret    

00801776 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801776:	55                   	push   %ebp
  801777:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801779:	6a 00                	push   $0x0
  80177b:	6a 00                	push   $0x0
  80177d:	6a 00                	push   $0x0
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	6a 09                	push   $0x9
  801785:	e8 00 ff ff ff       	call   80168a <syscall>
  80178a:	83 c4 18             	add    $0x18,%esp
}
  80178d:	c9                   	leave  
  80178e:	c3                   	ret    

0080178f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80178f:	55                   	push   %ebp
  801790:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801792:	6a 00                	push   $0x0
  801794:	6a 00                	push   $0x0
  801796:	6a 00                	push   $0x0
  801798:	6a 00                	push   $0x0
  80179a:	6a 00                	push   $0x0
  80179c:	6a 0a                	push   $0xa
  80179e:	e8 e7 fe ff ff       	call   80168a <syscall>
  8017a3:	83 c4 18             	add    $0x18,%esp
}
  8017a6:	c9                   	leave  
  8017a7:	c3                   	ret    

008017a8 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8017a8:	55                   	push   %ebp
  8017a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8017ab:	6a 00                	push   $0x0
  8017ad:	6a 00                	push   $0x0
  8017af:	6a 00                	push   $0x0
  8017b1:	6a 00                	push   $0x0
  8017b3:	6a 00                	push   $0x0
  8017b5:	6a 0b                	push   $0xb
  8017b7:	e8 ce fe ff ff       	call   80168a <syscall>
  8017bc:	83 c4 18             	add    $0x18,%esp
}
  8017bf:	c9                   	leave  
  8017c0:	c3                   	ret    

008017c1 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8017c1:	55                   	push   %ebp
  8017c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8017c4:	6a 00                	push   $0x0
  8017c6:	6a 00                	push   $0x0
  8017c8:	6a 00                	push   $0x0
  8017ca:	ff 75 0c             	pushl  0xc(%ebp)
  8017cd:	ff 75 08             	pushl  0x8(%ebp)
  8017d0:	6a 0f                	push   $0xf
  8017d2:	e8 b3 fe ff ff       	call   80168a <syscall>
  8017d7:	83 c4 18             	add    $0x18,%esp
	return;
  8017da:	90                   	nop
}
  8017db:	c9                   	leave  
  8017dc:	c3                   	ret    

008017dd <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8017dd:	55                   	push   %ebp
  8017de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8017e0:	6a 00                	push   $0x0
  8017e2:	6a 00                	push   $0x0
  8017e4:	6a 00                	push   $0x0
  8017e6:	ff 75 0c             	pushl  0xc(%ebp)
  8017e9:	ff 75 08             	pushl  0x8(%ebp)
  8017ec:	6a 10                	push   $0x10
  8017ee:	e8 97 fe ff ff       	call   80168a <syscall>
  8017f3:	83 c4 18             	add    $0x18,%esp
	return ;
  8017f6:	90                   	nop
}
  8017f7:	c9                   	leave  
  8017f8:	c3                   	ret    

008017f9 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8017f9:	55                   	push   %ebp
  8017fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8017fc:	6a 00                	push   $0x0
  8017fe:	6a 00                	push   $0x0
  801800:	ff 75 10             	pushl  0x10(%ebp)
  801803:	ff 75 0c             	pushl  0xc(%ebp)
  801806:	ff 75 08             	pushl  0x8(%ebp)
  801809:	6a 11                	push   $0x11
  80180b:	e8 7a fe ff ff       	call   80168a <syscall>
  801810:	83 c4 18             	add    $0x18,%esp
	return ;
  801813:	90                   	nop
}
  801814:	c9                   	leave  
  801815:	c3                   	ret    

00801816 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801816:	55                   	push   %ebp
  801817:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801819:	6a 00                	push   $0x0
  80181b:	6a 00                	push   $0x0
  80181d:	6a 00                	push   $0x0
  80181f:	6a 00                	push   $0x0
  801821:	6a 00                	push   $0x0
  801823:	6a 0c                	push   $0xc
  801825:	e8 60 fe ff ff       	call   80168a <syscall>
  80182a:	83 c4 18             	add    $0x18,%esp
}
  80182d:	c9                   	leave  
  80182e:	c3                   	ret    

0080182f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80182f:	55                   	push   %ebp
  801830:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	6a 00                	push   $0x0
  80183a:	ff 75 08             	pushl  0x8(%ebp)
  80183d:	6a 0d                	push   $0xd
  80183f:	e8 46 fe ff ff       	call   80168a <syscall>
  801844:	83 c4 18             	add    $0x18,%esp
}
  801847:	c9                   	leave  
  801848:	c3                   	ret    

00801849 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801849:	55                   	push   %ebp
  80184a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80184c:	6a 00                	push   $0x0
  80184e:	6a 00                	push   $0x0
  801850:	6a 00                	push   $0x0
  801852:	6a 00                	push   $0x0
  801854:	6a 00                	push   $0x0
  801856:	6a 0e                	push   $0xe
  801858:	e8 2d fe ff ff       	call   80168a <syscall>
  80185d:	83 c4 18             	add    $0x18,%esp
}
  801860:	90                   	nop
  801861:	c9                   	leave  
  801862:	c3                   	ret    

00801863 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801863:	55                   	push   %ebp
  801864:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	6a 13                	push   $0x13
  801872:	e8 13 fe ff ff       	call   80168a <syscall>
  801877:	83 c4 18             	add    $0x18,%esp
}
  80187a:	90                   	nop
  80187b:	c9                   	leave  
  80187c:	c3                   	ret    

0080187d <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80187d:	55                   	push   %ebp
  80187e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801880:	6a 00                	push   $0x0
  801882:	6a 00                	push   $0x0
  801884:	6a 00                	push   $0x0
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	6a 14                	push   $0x14
  80188c:	e8 f9 fd ff ff       	call   80168a <syscall>
  801891:	83 c4 18             	add    $0x18,%esp
}
  801894:	90                   	nop
  801895:	c9                   	leave  
  801896:	c3                   	ret    

00801897 <sys_cputc>:


void
sys_cputc(const char c)
{
  801897:	55                   	push   %ebp
  801898:	89 e5                	mov    %esp,%ebp
  80189a:	83 ec 04             	sub    $0x4,%esp
  80189d:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8018a3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 00                	push   $0x0
  8018af:	50                   	push   %eax
  8018b0:	6a 15                	push   $0x15
  8018b2:	e8 d3 fd ff ff       	call   80168a <syscall>
  8018b7:	83 c4 18             	add    $0x18,%esp
}
  8018ba:	90                   	nop
  8018bb:	c9                   	leave  
  8018bc:	c3                   	ret    

008018bd <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8018bd:	55                   	push   %ebp
  8018be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8018c0:	6a 00                	push   $0x0
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 16                	push   $0x16
  8018cc:	e8 b9 fd ff ff       	call   80168a <syscall>
  8018d1:	83 c4 18             	add    $0x18,%esp
}
  8018d4:	90                   	nop
  8018d5:	c9                   	leave  
  8018d6:	c3                   	ret    

008018d7 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8018d7:	55                   	push   %ebp
  8018d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8018da:	8b 45 08             	mov    0x8(%ebp),%eax
  8018dd:	6a 00                	push   $0x0
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 00                	push   $0x0
  8018e3:	ff 75 0c             	pushl  0xc(%ebp)
  8018e6:	50                   	push   %eax
  8018e7:	6a 17                	push   $0x17
  8018e9:	e8 9c fd ff ff       	call   80168a <syscall>
  8018ee:	83 c4 18             	add    $0x18,%esp
}
  8018f1:	c9                   	leave  
  8018f2:	c3                   	ret    

008018f3 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8018f3:	55                   	push   %ebp
  8018f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	52                   	push   %edx
  801903:	50                   	push   %eax
  801904:	6a 1a                	push   $0x1a
  801906:	e8 7f fd ff ff       	call   80168a <syscall>
  80190b:	83 c4 18             	add    $0x18,%esp
}
  80190e:	c9                   	leave  
  80190f:	c3                   	ret    

00801910 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801910:	55                   	push   %ebp
  801911:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801913:	8b 55 0c             	mov    0xc(%ebp),%edx
  801916:	8b 45 08             	mov    0x8(%ebp),%eax
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	52                   	push   %edx
  801920:	50                   	push   %eax
  801921:	6a 18                	push   $0x18
  801923:	e8 62 fd ff ff       	call   80168a <syscall>
  801928:	83 c4 18             	add    $0x18,%esp
}
  80192b:	90                   	nop
  80192c:	c9                   	leave  
  80192d:	c3                   	ret    

0080192e <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80192e:	55                   	push   %ebp
  80192f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801931:	8b 55 0c             	mov    0xc(%ebp),%edx
  801934:	8b 45 08             	mov    0x8(%ebp),%eax
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	52                   	push   %edx
  80193e:	50                   	push   %eax
  80193f:	6a 19                	push   $0x19
  801941:	e8 44 fd ff ff       	call   80168a <syscall>
  801946:	83 c4 18             	add    $0x18,%esp
}
  801949:	90                   	nop
  80194a:	c9                   	leave  
  80194b:	c3                   	ret    

0080194c <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80194c:	55                   	push   %ebp
  80194d:	89 e5                	mov    %esp,%ebp
  80194f:	83 ec 04             	sub    $0x4,%esp
  801952:	8b 45 10             	mov    0x10(%ebp),%eax
  801955:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801958:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80195b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80195f:	8b 45 08             	mov    0x8(%ebp),%eax
  801962:	6a 00                	push   $0x0
  801964:	51                   	push   %ecx
  801965:	52                   	push   %edx
  801966:	ff 75 0c             	pushl  0xc(%ebp)
  801969:	50                   	push   %eax
  80196a:	6a 1b                	push   $0x1b
  80196c:	e8 19 fd ff ff       	call   80168a <syscall>
  801971:	83 c4 18             	add    $0x18,%esp
}
  801974:	c9                   	leave  
  801975:	c3                   	ret    

00801976 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801976:	55                   	push   %ebp
  801977:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801979:	8b 55 0c             	mov    0xc(%ebp),%edx
  80197c:	8b 45 08             	mov    0x8(%ebp),%eax
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	52                   	push   %edx
  801986:	50                   	push   %eax
  801987:	6a 1c                	push   $0x1c
  801989:	e8 fc fc ff ff       	call   80168a <syscall>
  80198e:	83 c4 18             	add    $0x18,%esp
}
  801991:	c9                   	leave  
  801992:	c3                   	ret    

00801993 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801993:	55                   	push   %ebp
  801994:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801996:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801999:	8b 55 0c             	mov    0xc(%ebp),%edx
  80199c:	8b 45 08             	mov    0x8(%ebp),%eax
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	51                   	push   %ecx
  8019a4:	52                   	push   %edx
  8019a5:	50                   	push   %eax
  8019a6:	6a 1d                	push   $0x1d
  8019a8:	e8 dd fc ff ff       	call   80168a <syscall>
  8019ad:	83 c4 18             	add    $0x18,%esp
}
  8019b0:	c9                   	leave  
  8019b1:	c3                   	ret    

008019b2 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8019b2:	55                   	push   %ebp
  8019b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8019b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	52                   	push   %edx
  8019c2:	50                   	push   %eax
  8019c3:	6a 1e                	push   $0x1e
  8019c5:	e8 c0 fc ff ff       	call   80168a <syscall>
  8019ca:	83 c4 18             	add    $0x18,%esp
}
  8019cd:	c9                   	leave  
  8019ce:	c3                   	ret    

008019cf <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8019cf:	55                   	push   %ebp
  8019d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 1f                	push   $0x1f
  8019de:	e8 a7 fc ff ff       	call   80168a <syscall>
  8019e3:	83 c4 18             	add    $0x18,%esp
}
  8019e6:	c9                   	leave  
  8019e7:	c3                   	ret    

008019e8 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8019e8:	55                   	push   %ebp
  8019e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8019eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ee:	6a 00                	push   $0x0
  8019f0:	ff 75 14             	pushl  0x14(%ebp)
  8019f3:	ff 75 10             	pushl  0x10(%ebp)
  8019f6:	ff 75 0c             	pushl  0xc(%ebp)
  8019f9:	50                   	push   %eax
  8019fa:	6a 20                	push   $0x20
  8019fc:	e8 89 fc ff ff       	call   80168a <syscall>
  801a01:	83 c4 18             	add    $0x18,%esp
}
  801a04:	c9                   	leave  
  801a05:	c3                   	ret    

00801a06 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801a06:	55                   	push   %ebp
  801a07:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a09:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	50                   	push   %eax
  801a15:	6a 21                	push   $0x21
  801a17:	e8 6e fc ff ff       	call   80168a <syscall>
  801a1c:	83 c4 18             	add    $0x18,%esp
}
  801a1f:	90                   	nop
  801a20:	c9                   	leave  
  801a21:	c3                   	ret    

00801a22 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a22:	55                   	push   %ebp
  801a23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a25:	8b 45 08             	mov    0x8(%ebp),%eax
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	50                   	push   %eax
  801a31:	6a 22                	push   $0x22
  801a33:	e8 52 fc ff ff       	call   80168a <syscall>
  801a38:	83 c4 18             	add    $0x18,%esp
}
  801a3b:	c9                   	leave  
  801a3c:	c3                   	ret    

00801a3d <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a3d:	55                   	push   %ebp
  801a3e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 02                	push   $0x2
  801a4c:	e8 39 fc ff ff       	call   80168a <syscall>
  801a51:	83 c4 18             	add    $0x18,%esp
}
  801a54:	c9                   	leave  
  801a55:	c3                   	ret    

00801a56 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a56:	55                   	push   %ebp
  801a57:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 03                	push   $0x3
  801a65:	e8 20 fc ff ff       	call   80168a <syscall>
  801a6a:	83 c4 18             	add    $0x18,%esp
}
  801a6d:	c9                   	leave  
  801a6e:	c3                   	ret    

00801a6f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a6f:	55                   	push   %ebp
  801a70:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 04                	push   $0x4
  801a7e:	e8 07 fc ff ff       	call   80168a <syscall>
  801a83:	83 c4 18             	add    $0x18,%esp
}
  801a86:	c9                   	leave  
  801a87:	c3                   	ret    

00801a88 <sys_exit_env>:


void sys_exit_env(void)
{
  801a88:	55                   	push   %ebp
  801a89:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 23                	push   $0x23
  801a97:	e8 ee fb ff ff       	call   80168a <syscall>
  801a9c:	83 c4 18             	add    $0x18,%esp
}
  801a9f:	90                   	nop
  801aa0:	c9                   	leave  
  801aa1:	c3                   	ret    

00801aa2 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801aa2:	55                   	push   %ebp
  801aa3:	89 e5                	mov    %esp,%ebp
  801aa5:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801aa8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801aab:	8d 50 04             	lea    0x4(%eax),%edx
  801aae:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	52                   	push   %edx
  801ab8:	50                   	push   %eax
  801ab9:	6a 24                	push   $0x24
  801abb:	e8 ca fb ff ff       	call   80168a <syscall>
  801ac0:	83 c4 18             	add    $0x18,%esp
	return result;
  801ac3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ac6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ac9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801acc:	89 01                	mov    %eax,(%ecx)
  801ace:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad4:	c9                   	leave  
  801ad5:	c2 04 00             	ret    $0x4

00801ad8 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801ad8:	55                   	push   %ebp
  801ad9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	ff 75 10             	pushl  0x10(%ebp)
  801ae2:	ff 75 0c             	pushl  0xc(%ebp)
  801ae5:	ff 75 08             	pushl  0x8(%ebp)
  801ae8:	6a 12                	push   $0x12
  801aea:	e8 9b fb ff ff       	call   80168a <syscall>
  801aef:	83 c4 18             	add    $0x18,%esp
	return ;
  801af2:	90                   	nop
}
  801af3:	c9                   	leave  
  801af4:	c3                   	ret    

00801af5 <sys_rcr2>:
uint32 sys_rcr2()
{
  801af5:	55                   	push   %ebp
  801af6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 25                	push   $0x25
  801b04:	e8 81 fb ff ff       	call   80168a <syscall>
  801b09:	83 c4 18             	add    $0x18,%esp
}
  801b0c:	c9                   	leave  
  801b0d:	c3                   	ret    

00801b0e <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801b0e:	55                   	push   %ebp
  801b0f:	89 e5                	mov    %esp,%ebp
  801b11:	83 ec 04             	sub    $0x4,%esp
  801b14:	8b 45 08             	mov    0x8(%ebp),%eax
  801b17:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b1a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	50                   	push   %eax
  801b27:	6a 26                	push   $0x26
  801b29:	e8 5c fb ff ff       	call   80168a <syscall>
  801b2e:	83 c4 18             	add    $0x18,%esp
	return ;
  801b31:	90                   	nop
}
  801b32:	c9                   	leave  
  801b33:	c3                   	ret    

00801b34 <rsttst>:
void rsttst()
{
  801b34:	55                   	push   %ebp
  801b35:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 28                	push   $0x28
  801b43:	e8 42 fb ff ff       	call   80168a <syscall>
  801b48:	83 c4 18             	add    $0x18,%esp
	return ;
  801b4b:	90                   	nop
}
  801b4c:	c9                   	leave  
  801b4d:	c3                   	ret    

00801b4e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
  801b51:	83 ec 04             	sub    $0x4,%esp
  801b54:	8b 45 14             	mov    0x14(%ebp),%eax
  801b57:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b5a:	8b 55 18             	mov    0x18(%ebp),%edx
  801b5d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b61:	52                   	push   %edx
  801b62:	50                   	push   %eax
  801b63:	ff 75 10             	pushl  0x10(%ebp)
  801b66:	ff 75 0c             	pushl  0xc(%ebp)
  801b69:	ff 75 08             	pushl  0x8(%ebp)
  801b6c:	6a 27                	push   $0x27
  801b6e:	e8 17 fb ff ff       	call   80168a <syscall>
  801b73:	83 c4 18             	add    $0x18,%esp
	return ;
  801b76:	90                   	nop
}
  801b77:	c9                   	leave  
  801b78:	c3                   	ret    

00801b79 <chktst>:
void chktst(uint32 n)
{
  801b79:	55                   	push   %ebp
  801b7a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	ff 75 08             	pushl  0x8(%ebp)
  801b87:	6a 29                	push   $0x29
  801b89:	e8 fc fa ff ff       	call   80168a <syscall>
  801b8e:	83 c4 18             	add    $0x18,%esp
	return ;
  801b91:	90                   	nop
}
  801b92:	c9                   	leave  
  801b93:	c3                   	ret    

00801b94 <inctst>:

void inctst()
{
  801b94:	55                   	push   %ebp
  801b95:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 00                	push   $0x0
  801ba1:	6a 2a                	push   $0x2a
  801ba3:	e8 e2 fa ff ff       	call   80168a <syscall>
  801ba8:	83 c4 18             	add    $0x18,%esp
	return ;
  801bab:	90                   	nop
}
  801bac:	c9                   	leave  
  801bad:	c3                   	ret    

00801bae <gettst>:
uint32 gettst()
{
  801bae:	55                   	push   %ebp
  801baf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 2b                	push   $0x2b
  801bbd:	e8 c8 fa ff ff       	call   80168a <syscall>
  801bc2:	83 c4 18             	add    $0x18,%esp
}
  801bc5:	c9                   	leave  
  801bc6:	c3                   	ret    

00801bc7 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801bc7:	55                   	push   %ebp
  801bc8:	89 e5                	mov    %esp,%ebp
  801bca:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 2c                	push   $0x2c
  801bd9:	e8 ac fa ff ff       	call   80168a <syscall>
  801bde:	83 c4 18             	add    $0x18,%esp
  801be1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801be4:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801be8:	75 07                	jne    801bf1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801bea:	b8 01 00 00 00       	mov    $0x1,%eax
  801bef:	eb 05                	jmp    801bf6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801bf1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bf6:	c9                   	leave  
  801bf7:	c3                   	ret    

00801bf8 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801bf8:	55                   	push   %ebp
  801bf9:	89 e5                	mov    %esp,%ebp
  801bfb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	6a 2c                	push   $0x2c
  801c0a:	e8 7b fa ff ff       	call   80168a <syscall>
  801c0f:	83 c4 18             	add    $0x18,%esp
  801c12:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c15:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c19:	75 07                	jne    801c22 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c1b:	b8 01 00 00 00       	mov    $0x1,%eax
  801c20:	eb 05                	jmp    801c27 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c22:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c27:	c9                   	leave  
  801c28:	c3                   	ret    

00801c29 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c29:	55                   	push   %ebp
  801c2a:	89 e5                	mov    %esp,%ebp
  801c2c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 2c                	push   $0x2c
  801c3b:	e8 4a fa ff ff       	call   80168a <syscall>
  801c40:	83 c4 18             	add    $0x18,%esp
  801c43:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c46:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c4a:	75 07                	jne    801c53 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c4c:	b8 01 00 00 00       	mov    $0x1,%eax
  801c51:	eb 05                	jmp    801c58 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c53:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c58:	c9                   	leave  
  801c59:	c3                   	ret    

00801c5a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c5a:	55                   	push   %ebp
  801c5b:	89 e5                	mov    %esp,%ebp
  801c5d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 2c                	push   $0x2c
  801c6c:	e8 19 fa ff ff       	call   80168a <syscall>
  801c71:	83 c4 18             	add    $0x18,%esp
  801c74:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c77:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c7b:	75 07                	jne    801c84 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c7d:	b8 01 00 00 00       	mov    $0x1,%eax
  801c82:	eb 05                	jmp    801c89 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c84:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c89:	c9                   	leave  
  801c8a:	c3                   	ret    

00801c8b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c8b:	55                   	push   %ebp
  801c8c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	ff 75 08             	pushl  0x8(%ebp)
  801c99:	6a 2d                	push   $0x2d
  801c9b:	e8 ea f9 ff ff       	call   80168a <syscall>
  801ca0:	83 c4 18             	add    $0x18,%esp
	return ;
  801ca3:	90                   	nop
}
  801ca4:	c9                   	leave  
  801ca5:	c3                   	ret    

00801ca6 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ca6:	55                   	push   %ebp
  801ca7:	89 e5                	mov    %esp,%ebp
  801ca9:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801caa:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cad:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cb0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb6:	6a 00                	push   $0x0
  801cb8:	53                   	push   %ebx
  801cb9:	51                   	push   %ecx
  801cba:	52                   	push   %edx
  801cbb:	50                   	push   %eax
  801cbc:	6a 2e                	push   $0x2e
  801cbe:	e8 c7 f9 ff ff       	call   80168a <syscall>
  801cc3:	83 c4 18             	add    $0x18,%esp
}
  801cc6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cc9:	c9                   	leave  
  801cca:	c3                   	ret    

00801ccb <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ccb:	55                   	push   %ebp
  801ccc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801cce:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	52                   	push   %edx
  801cdb:	50                   	push   %eax
  801cdc:	6a 2f                	push   $0x2f
  801cde:	e8 a7 f9 ff ff       	call   80168a <syscall>
  801ce3:	83 c4 18             	add    $0x18,%esp
}
  801ce6:	c9                   	leave  
  801ce7:	c3                   	ret    

00801ce8 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801ce8:	55                   	push   %ebp
  801ce9:	89 e5                	mov    %esp,%ebp
  801ceb:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801cee:	83 ec 0c             	sub    $0xc,%esp
  801cf1:	68 90 3d 80 00       	push   $0x803d90
  801cf6:	e8 6b e8 ff ff       	call   800566 <cprintf>
  801cfb:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801cfe:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801d05:	83 ec 0c             	sub    $0xc,%esp
  801d08:	68 bc 3d 80 00       	push   $0x803dbc
  801d0d:	e8 54 e8 ff ff       	call   800566 <cprintf>
  801d12:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801d15:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d19:	a1 38 51 80 00       	mov    0x805138,%eax
  801d1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d21:	eb 56                	jmp    801d79 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d23:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d27:	74 1c                	je     801d45 <print_mem_block_lists+0x5d>
  801d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d2c:	8b 50 08             	mov    0x8(%eax),%edx
  801d2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d32:	8b 48 08             	mov    0x8(%eax),%ecx
  801d35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d38:	8b 40 0c             	mov    0xc(%eax),%eax
  801d3b:	01 c8                	add    %ecx,%eax
  801d3d:	39 c2                	cmp    %eax,%edx
  801d3f:	73 04                	jae    801d45 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801d41:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d48:	8b 50 08             	mov    0x8(%eax),%edx
  801d4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d4e:	8b 40 0c             	mov    0xc(%eax),%eax
  801d51:	01 c2                	add    %eax,%edx
  801d53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d56:	8b 40 08             	mov    0x8(%eax),%eax
  801d59:	83 ec 04             	sub    $0x4,%esp
  801d5c:	52                   	push   %edx
  801d5d:	50                   	push   %eax
  801d5e:	68 d1 3d 80 00       	push   $0x803dd1
  801d63:	e8 fe e7 ff ff       	call   800566 <cprintf>
  801d68:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d71:	a1 40 51 80 00       	mov    0x805140,%eax
  801d76:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d79:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d7d:	74 07                	je     801d86 <print_mem_block_lists+0x9e>
  801d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d82:	8b 00                	mov    (%eax),%eax
  801d84:	eb 05                	jmp    801d8b <print_mem_block_lists+0xa3>
  801d86:	b8 00 00 00 00       	mov    $0x0,%eax
  801d8b:	a3 40 51 80 00       	mov    %eax,0x805140
  801d90:	a1 40 51 80 00       	mov    0x805140,%eax
  801d95:	85 c0                	test   %eax,%eax
  801d97:	75 8a                	jne    801d23 <print_mem_block_lists+0x3b>
  801d99:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d9d:	75 84                	jne    801d23 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801d9f:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801da3:	75 10                	jne    801db5 <print_mem_block_lists+0xcd>
  801da5:	83 ec 0c             	sub    $0xc,%esp
  801da8:	68 e0 3d 80 00       	push   $0x803de0
  801dad:	e8 b4 e7 ff ff       	call   800566 <cprintf>
  801db2:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801db5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801dbc:	83 ec 0c             	sub    $0xc,%esp
  801dbf:	68 04 3e 80 00       	push   $0x803e04
  801dc4:	e8 9d e7 ff ff       	call   800566 <cprintf>
  801dc9:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801dcc:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801dd0:	a1 40 50 80 00       	mov    0x805040,%eax
  801dd5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dd8:	eb 56                	jmp    801e30 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801dda:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801dde:	74 1c                	je     801dfc <print_mem_block_lists+0x114>
  801de0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de3:	8b 50 08             	mov    0x8(%eax),%edx
  801de6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801de9:	8b 48 08             	mov    0x8(%eax),%ecx
  801dec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801def:	8b 40 0c             	mov    0xc(%eax),%eax
  801df2:	01 c8                	add    %ecx,%eax
  801df4:	39 c2                	cmp    %eax,%edx
  801df6:	73 04                	jae    801dfc <print_mem_block_lists+0x114>
			sorted = 0 ;
  801df8:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801dfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dff:	8b 50 08             	mov    0x8(%eax),%edx
  801e02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e05:	8b 40 0c             	mov    0xc(%eax),%eax
  801e08:	01 c2                	add    %eax,%edx
  801e0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e0d:	8b 40 08             	mov    0x8(%eax),%eax
  801e10:	83 ec 04             	sub    $0x4,%esp
  801e13:	52                   	push   %edx
  801e14:	50                   	push   %eax
  801e15:	68 d1 3d 80 00       	push   $0x803dd1
  801e1a:	e8 47 e7 ff ff       	call   800566 <cprintf>
  801e1f:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e25:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e28:	a1 48 50 80 00       	mov    0x805048,%eax
  801e2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e30:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e34:	74 07                	je     801e3d <print_mem_block_lists+0x155>
  801e36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e39:	8b 00                	mov    (%eax),%eax
  801e3b:	eb 05                	jmp    801e42 <print_mem_block_lists+0x15a>
  801e3d:	b8 00 00 00 00       	mov    $0x0,%eax
  801e42:	a3 48 50 80 00       	mov    %eax,0x805048
  801e47:	a1 48 50 80 00       	mov    0x805048,%eax
  801e4c:	85 c0                	test   %eax,%eax
  801e4e:	75 8a                	jne    801dda <print_mem_block_lists+0xf2>
  801e50:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e54:	75 84                	jne    801dda <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801e56:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e5a:	75 10                	jne    801e6c <print_mem_block_lists+0x184>
  801e5c:	83 ec 0c             	sub    $0xc,%esp
  801e5f:	68 1c 3e 80 00       	push   $0x803e1c
  801e64:	e8 fd e6 ff ff       	call   800566 <cprintf>
  801e69:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801e6c:	83 ec 0c             	sub    $0xc,%esp
  801e6f:	68 90 3d 80 00       	push   $0x803d90
  801e74:	e8 ed e6 ff ff       	call   800566 <cprintf>
  801e79:	83 c4 10             	add    $0x10,%esp

}
  801e7c:	90                   	nop
  801e7d:	c9                   	leave  
  801e7e:	c3                   	ret    

00801e7f <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801e7f:	55                   	push   %ebp
  801e80:	89 e5                	mov    %esp,%ebp
  801e82:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801e85:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801e8c:	00 00 00 
  801e8f:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801e96:	00 00 00 
  801e99:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801ea0:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801ea3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801eaa:	e9 9e 00 00 00       	jmp    801f4d <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801eaf:	a1 50 50 80 00       	mov    0x805050,%eax
  801eb4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eb7:	c1 e2 04             	shl    $0x4,%edx
  801eba:	01 d0                	add    %edx,%eax
  801ebc:	85 c0                	test   %eax,%eax
  801ebe:	75 14                	jne    801ed4 <initialize_MemBlocksList+0x55>
  801ec0:	83 ec 04             	sub    $0x4,%esp
  801ec3:	68 44 3e 80 00       	push   $0x803e44
  801ec8:	6a 46                	push   $0x46
  801eca:	68 67 3e 80 00       	push   $0x803e67
  801ecf:	e8 64 14 00 00       	call   803338 <_panic>
  801ed4:	a1 50 50 80 00       	mov    0x805050,%eax
  801ed9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801edc:	c1 e2 04             	shl    $0x4,%edx
  801edf:	01 d0                	add    %edx,%eax
  801ee1:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801ee7:	89 10                	mov    %edx,(%eax)
  801ee9:	8b 00                	mov    (%eax),%eax
  801eeb:	85 c0                	test   %eax,%eax
  801eed:	74 18                	je     801f07 <initialize_MemBlocksList+0x88>
  801eef:	a1 48 51 80 00       	mov    0x805148,%eax
  801ef4:	8b 15 50 50 80 00    	mov    0x805050,%edx
  801efa:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801efd:	c1 e1 04             	shl    $0x4,%ecx
  801f00:	01 ca                	add    %ecx,%edx
  801f02:	89 50 04             	mov    %edx,0x4(%eax)
  801f05:	eb 12                	jmp    801f19 <initialize_MemBlocksList+0x9a>
  801f07:	a1 50 50 80 00       	mov    0x805050,%eax
  801f0c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f0f:	c1 e2 04             	shl    $0x4,%edx
  801f12:	01 d0                	add    %edx,%eax
  801f14:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801f19:	a1 50 50 80 00       	mov    0x805050,%eax
  801f1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f21:	c1 e2 04             	shl    $0x4,%edx
  801f24:	01 d0                	add    %edx,%eax
  801f26:	a3 48 51 80 00       	mov    %eax,0x805148
  801f2b:	a1 50 50 80 00       	mov    0x805050,%eax
  801f30:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f33:	c1 e2 04             	shl    $0x4,%edx
  801f36:	01 d0                	add    %edx,%eax
  801f38:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f3f:	a1 54 51 80 00       	mov    0x805154,%eax
  801f44:	40                   	inc    %eax
  801f45:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801f4a:	ff 45 f4             	incl   -0xc(%ebp)
  801f4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f50:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f53:	0f 82 56 ff ff ff    	jb     801eaf <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801f59:	90                   	nop
  801f5a:	c9                   	leave  
  801f5b:	c3                   	ret    

00801f5c <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801f5c:	55                   	push   %ebp
  801f5d:	89 e5                	mov    %esp,%ebp
  801f5f:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f62:	8b 45 08             	mov    0x8(%ebp),%eax
  801f65:	8b 00                	mov    (%eax),%eax
  801f67:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f6a:	eb 19                	jmp    801f85 <find_block+0x29>
	{
		if(va==point->sva)
  801f6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f6f:	8b 40 08             	mov    0x8(%eax),%eax
  801f72:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801f75:	75 05                	jne    801f7c <find_block+0x20>
		   return point;
  801f77:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f7a:	eb 36                	jmp    801fb2 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7f:	8b 40 08             	mov    0x8(%eax),%eax
  801f82:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f85:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f89:	74 07                	je     801f92 <find_block+0x36>
  801f8b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f8e:	8b 00                	mov    (%eax),%eax
  801f90:	eb 05                	jmp    801f97 <find_block+0x3b>
  801f92:	b8 00 00 00 00       	mov    $0x0,%eax
  801f97:	8b 55 08             	mov    0x8(%ebp),%edx
  801f9a:	89 42 08             	mov    %eax,0x8(%edx)
  801f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa0:	8b 40 08             	mov    0x8(%eax),%eax
  801fa3:	85 c0                	test   %eax,%eax
  801fa5:	75 c5                	jne    801f6c <find_block+0x10>
  801fa7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801fab:	75 bf                	jne    801f6c <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801fad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fb2:	c9                   	leave  
  801fb3:	c3                   	ret    

00801fb4 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801fb4:	55                   	push   %ebp
  801fb5:	89 e5                	mov    %esp,%ebp
  801fb7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801fba:	a1 40 50 80 00       	mov    0x805040,%eax
  801fbf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801fc2:	a1 44 50 80 00       	mov    0x805044,%eax
  801fc7:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801fca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fcd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801fd0:	74 24                	je     801ff6 <insert_sorted_allocList+0x42>
  801fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd5:	8b 50 08             	mov    0x8(%eax),%edx
  801fd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fdb:	8b 40 08             	mov    0x8(%eax),%eax
  801fde:	39 c2                	cmp    %eax,%edx
  801fe0:	76 14                	jbe    801ff6 <insert_sorted_allocList+0x42>
  801fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe5:	8b 50 08             	mov    0x8(%eax),%edx
  801fe8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801feb:	8b 40 08             	mov    0x8(%eax),%eax
  801fee:	39 c2                	cmp    %eax,%edx
  801ff0:	0f 82 60 01 00 00    	jb     802156 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  801ff6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ffa:	75 65                	jne    802061 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  801ffc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802000:	75 14                	jne    802016 <insert_sorted_allocList+0x62>
  802002:	83 ec 04             	sub    $0x4,%esp
  802005:	68 44 3e 80 00       	push   $0x803e44
  80200a:	6a 6b                	push   $0x6b
  80200c:	68 67 3e 80 00       	push   $0x803e67
  802011:	e8 22 13 00 00       	call   803338 <_panic>
  802016:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80201c:	8b 45 08             	mov    0x8(%ebp),%eax
  80201f:	89 10                	mov    %edx,(%eax)
  802021:	8b 45 08             	mov    0x8(%ebp),%eax
  802024:	8b 00                	mov    (%eax),%eax
  802026:	85 c0                	test   %eax,%eax
  802028:	74 0d                	je     802037 <insert_sorted_allocList+0x83>
  80202a:	a1 40 50 80 00       	mov    0x805040,%eax
  80202f:	8b 55 08             	mov    0x8(%ebp),%edx
  802032:	89 50 04             	mov    %edx,0x4(%eax)
  802035:	eb 08                	jmp    80203f <insert_sorted_allocList+0x8b>
  802037:	8b 45 08             	mov    0x8(%ebp),%eax
  80203a:	a3 44 50 80 00       	mov    %eax,0x805044
  80203f:	8b 45 08             	mov    0x8(%ebp),%eax
  802042:	a3 40 50 80 00       	mov    %eax,0x805040
  802047:	8b 45 08             	mov    0x8(%ebp),%eax
  80204a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802051:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802056:	40                   	inc    %eax
  802057:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80205c:	e9 dc 01 00 00       	jmp    80223d <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802061:	8b 45 08             	mov    0x8(%ebp),%eax
  802064:	8b 50 08             	mov    0x8(%eax),%edx
  802067:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80206a:	8b 40 08             	mov    0x8(%eax),%eax
  80206d:	39 c2                	cmp    %eax,%edx
  80206f:	77 6c                	ja     8020dd <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802071:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802075:	74 06                	je     80207d <insert_sorted_allocList+0xc9>
  802077:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80207b:	75 14                	jne    802091 <insert_sorted_allocList+0xdd>
  80207d:	83 ec 04             	sub    $0x4,%esp
  802080:	68 80 3e 80 00       	push   $0x803e80
  802085:	6a 6f                	push   $0x6f
  802087:	68 67 3e 80 00       	push   $0x803e67
  80208c:	e8 a7 12 00 00       	call   803338 <_panic>
  802091:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802094:	8b 50 04             	mov    0x4(%eax),%edx
  802097:	8b 45 08             	mov    0x8(%ebp),%eax
  80209a:	89 50 04             	mov    %edx,0x4(%eax)
  80209d:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020a3:	89 10                	mov    %edx,(%eax)
  8020a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020a8:	8b 40 04             	mov    0x4(%eax),%eax
  8020ab:	85 c0                	test   %eax,%eax
  8020ad:	74 0d                	je     8020bc <insert_sorted_allocList+0x108>
  8020af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020b2:	8b 40 04             	mov    0x4(%eax),%eax
  8020b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8020b8:	89 10                	mov    %edx,(%eax)
  8020ba:	eb 08                	jmp    8020c4 <insert_sorted_allocList+0x110>
  8020bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bf:	a3 40 50 80 00       	mov    %eax,0x805040
  8020c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8020ca:	89 50 04             	mov    %edx,0x4(%eax)
  8020cd:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8020d2:	40                   	inc    %eax
  8020d3:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8020d8:	e9 60 01 00 00       	jmp    80223d <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8020dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e0:	8b 50 08             	mov    0x8(%eax),%edx
  8020e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020e6:	8b 40 08             	mov    0x8(%eax),%eax
  8020e9:	39 c2                	cmp    %eax,%edx
  8020eb:	0f 82 4c 01 00 00    	jb     80223d <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8020f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020f5:	75 14                	jne    80210b <insert_sorted_allocList+0x157>
  8020f7:	83 ec 04             	sub    $0x4,%esp
  8020fa:	68 b8 3e 80 00       	push   $0x803eb8
  8020ff:	6a 73                	push   $0x73
  802101:	68 67 3e 80 00       	push   $0x803e67
  802106:	e8 2d 12 00 00       	call   803338 <_panic>
  80210b:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802111:	8b 45 08             	mov    0x8(%ebp),%eax
  802114:	89 50 04             	mov    %edx,0x4(%eax)
  802117:	8b 45 08             	mov    0x8(%ebp),%eax
  80211a:	8b 40 04             	mov    0x4(%eax),%eax
  80211d:	85 c0                	test   %eax,%eax
  80211f:	74 0c                	je     80212d <insert_sorted_allocList+0x179>
  802121:	a1 44 50 80 00       	mov    0x805044,%eax
  802126:	8b 55 08             	mov    0x8(%ebp),%edx
  802129:	89 10                	mov    %edx,(%eax)
  80212b:	eb 08                	jmp    802135 <insert_sorted_allocList+0x181>
  80212d:	8b 45 08             	mov    0x8(%ebp),%eax
  802130:	a3 40 50 80 00       	mov    %eax,0x805040
  802135:	8b 45 08             	mov    0x8(%ebp),%eax
  802138:	a3 44 50 80 00       	mov    %eax,0x805044
  80213d:	8b 45 08             	mov    0x8(%ebp),%eax
  802140:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802146:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80214b:	40                   	inc    %eax
  80214c:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802151:	e9 e7 00 00 00       	jmp    80223d <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802156:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802159:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80215c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802163:	a1 40 50 80 00       	mov    0x805040,%eax
  802168:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80216b:	e9 9d 00 00 00       	jmp    80220d <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802170:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802173:	8b 00                	mov    (%eax),%eax
  802175:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802178:	8b 45 08             	mov    0x8(%ebp),%eax
  80217b:	8b 50 08             	mov    0x8(%eax),%edx
  80217e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802181:	8b 40 08             	mov    0x8(%eax),%eax
  802184:	39 c2                	cmp    %eax,%edx
  802186:	76 7d                	jbe    802205 <insert_sorted_allocList+0x251>
  802188:	8b 45 08             	mov    0x8(%ebp),%eax
  80218b:	8b 50 08             	mov    0x8(%eax),%edx
  80218e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802191:	8b 40 08             	mov    0x8(%eax),%eax
  802194:	39 c2                	cmp    %eax,%edx
  802196:	73 6d                	jae    802205 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802198:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80219c:	74 06                	je     8021a4 <insert_sorted_allocList+0x1f0>
  80219e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021a2:	75 14                	jne    8021b8 <insert_sorted_allocList+0x204>
  8021a4:	83 ec 04             	sub    $0x4,%esp
  8021a7:	68 dc 3e 80 00       	push   $0x803edc
  8021ac:	6a 7f                	push   $0x7f
  8021ae:	68 67 3e 80 00       	push   $0x803e67
  8021b3:	e8 80 11 00 00       	call   803338 <_panic>
  8021b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021bb:	8b 10                	mov    (%eax),%edx
  8021bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c0:	89 10                	mov    %edx,(%eax)
  8021c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c5:	8b 00                	mov    (%eax),%eax
  8021c7:	85 c0                	test   %eax,%eax
  8021c9:	74 0b                	je     8021d6 <insert_sorted_allocList+0x222>
  8021cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ce:	8b 00                	mov    (%eax),%eax
  8021d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8021d3:	89 50 04             	mov    %edx,0x4(%eax)
  8021d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8021dc:	89 10                	mov    %edx,(%eax)
  8021de:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021e4:	89 50 04             	mov    %edx,0x4(%eax)
  8021e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ea:	8b 00                	mov    (%eax),%eax
  8021ec:	85 c0                	test   %eax,%eax
  8021ee:	75 08                	jne    8021f8 <insert_sorted_allocList+0x244>
  8021f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f3:	a3 44 50 80 00       	mov    %eax,0x805044
  8021f8:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021fd:	40                   	inc    %eax
  8021fe:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802203:	eb 39                	jmp    80223e <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802205:	a1 48 50 80 00       	mov    0x805048,%eax
  80220a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80220d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802211:	74 07                	je     80221a <insert_sorted_allocList+0x266>
  802213:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802216:	8b 00                	mov    (%eax),%eax
  802218:	eb 05                	jmp    80221f <insert_sorted_allocList+0x26b>
  80221a:	b8 00 00 00 00       	mov    $0x0,%eax
  80221f:	a3 48 50 80 00       	mov    %eax,0x805048
  802224:	a1 48 50 80 00       	mov    0x805048,%eax
  802229:	85 c0                	test   %eax,%eax
  80222b:	0f 85 3f ff ff ff    	jne    802170 <insert_sorted_allocList+0x1bc>
  802231:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802235:	0f 85 35 ff ff ff    	jne    802170 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80223b:	eb 01                	jmp    80223e <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80223d:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80223e:	90                   	nop
  80223f:	c9                   	leave  
  802240:	c3                   	ret    

00802241 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802241:	55                   	push   %ebp
  802242:	89 e5                	mov    %esp,%ebp
  802244:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802247:	a1 38 51 80 00       	mov    0x805138,%eax
  80224c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80224f:	e9 85 01 00 00       	jmp    8023d9 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802254:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802257:	8b 40 0c             	mov    0xc(%eax),%eax
  80225a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80225d:	0f 82 6e 01 00 00    	jb     8023d1 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802263:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802266:	8b 40 0c             	mov    0xc(%eax),%eax
  802269:	3b 45 08             	cmp    0x8(%ebp),%eax
  80226c:	0f 85 8a 00 00 00    	jne    8022fc <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802272:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802276:	75 17                	jne    80228f <alloc_block_FF+0x4e>
  802278:	83 ec 04             	sub    $0x4,%esp
  80227b:	68 10 3f 80 00       	push   $0x803f10
  802280:	68 93 00 00 00       	push   $0x93
  802285:	68 67 3e 80 00       	push   $0x803e67
  80228a:	e8 a9 10 00 00       	call   803338 <_panic>
  80228f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802292:	8b 00                	mov    (%eax),%eax
  802294:	85 c0                	test   %eax,%eax
  802296:	74 10                	je     8022a8 <alloc_block_FF+0x67>
  802298:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229b:	8b 00                	mov    (%eax),%eax
  80229d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022a0:	8b 52 04             	mov    0x4(%edx),%edx
  8022a3:	89 50 04             	mov    %edx,0x4(%eax)
  8022a6:	eb 0b                	jmp    8022b3 <alloc_block_FF+0x72>
  8022a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ab:	8b 40 04             	mov    0x4(%eax),%eax
  8022ae:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8022b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b6:	8b 40 04             	mov    0x4(%eax),%eax
  8022b9:	85 c0                	test   %eax,%eax
  8022bb:	74 0f                	je     8022cc <alloc_block_FF+0x8b>
  8022bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c0:	8b 40 04             	mov    0x4(%eax),%eax
  8022c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022c6:	8b 12                	mov    (%edx),%edx
  8022c8:	89 10                	mov    %edx,(%eax)
  8022ca:	eb 0a                	jmp    8022d6 <alloc_block_FF+0x95>
  8022cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cf:	8b 00                	mov    (%eax),%eax
  8022d1:	a3 38 51 80 00       	mov    %eax,0x805138
  8022d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022e9:	a1 44 51 80 00       	mov    0x805144,%eax
  8022ee:	48                   	dec    %eax
  8022ef:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8022f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f7:	e9 10 01 00 00       	jmp    80240c <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8022fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ff:	8b 40 0c             	mov    0xc(%eax),%eax
  802302:	3b 45 08             	cmp    0x8(%ebp),%eax
  802305:	0f 86 c6 00 00 00    	jbe    8023d1 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80230b:	a1 48 51 80 00       	mov    0x805148,%eax
  802310:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802313:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802316:	8b 50 08             	mov    0x8(%eax),%edx
  802319:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80231c:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  80231f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802322:	8b 55 08             	mov    0x8(%ebp),%edx
  802325:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802328:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80232c:	75 17                	jne    802345 <alloc_block_FF+0x104>
  80232e:	83 ec 04             	sub    $0x4,%esp
  802331:	68 10 3f 80 00       	push   $0x803f10
  802336:	68 9b 00 00 00       	push   $0x9b
  80233b:	68 67 3e 80 00       	push   $0x803e67
  802340:	e8 f3 0f 00 00       	call   803338 <_panic>
  802345:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802348:	8b 00                	mov    (%eax),%eax
  80234a:	85 c0                	test   %eax,%eax
  80234c:	74 10                	je     80235e <alloc_block_FF+0x11d>
  80234e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802351:	8b 00                	mov    (%eax),%eax
  802353:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802356:	8b 52 04             	mov    0x4(%edx),%edx
  802359:	89 50 04             	mov    %edx,0x4(%eax)
  80235c:	eb 0b                	jmp    802369 <alloc_block_FF+0x128>
  80235e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802361:	8b 40 04             	mov    0x4(%eax),%eax
  802364:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802369:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80236c:	8b 40 04             	mov    0x4(%eax),%eax
  80236f:	85 c0                	test   %eax,%eax
  802371:	74 0f                	je     802382 <alloc_block_FF+0x141>
  802373:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802376:	8b 40 04             	mov    0x4(%eax),%eax
  802379:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80237c:	8b 12                	mov    (%edx),%edx
  80237e:	89 10                	mov    %edx,(%eax)
  802380:	eb 0a                	jmp    80238c <alloc_block_FF+0x14b>
  802382:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802385:	8b 00                	mov    (%eax),%eax
  802387:	a3 48 51 80 00       	mov    %eax,0x805148
  80238c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80238f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802395:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802398:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80239f:	a1 54 51 80 00       	mov    0x805154,%eax
  8023a4:	48                   	dec    %eax
  8023a5:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8023aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ad:	8b 50 08             	mov    0x8(%eax),%edx
  8023b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b3:	01 c2                	add    %eax,%edx
  8023b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b8:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8023bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023be:	8b 40 0c             	mov    0xc(%eax),%eax
  8023c1:	2b 45 08             	sub    0x8(%ebp),%eax
  8023c4:	89 c2                	mov    %eax,%edx
  8023c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c9:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8023cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023cf:	eb 3b                	jmp    80240c <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8023d1:	a1 40 51 80 00       	mov    0x805140,%eax
  8023d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023dd:	74 07                	je     8023e6 <alloc_block_FF+0x1a5>
  8023df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e2:	8b 00                	mov    (%eax),%eax
  8023e4:	eb 05                	jmp    8023eb <alloc_block_FF+0x1aa>
  8023e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8023eb:	a3 40 51 80 00       	mov    %eax,0x805140
  8023f0:	a1 40 51 80 00       	mov    0x805140,%eax
  8023f5:	85 c0                	test   %eax,%eax
  8023f7:	0f 85 57 fe ff ff    	jne    802254 <alloc_block_FF+0x13>
  8023fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802401:	0f 85 4d fe ff ff    	jne    802254 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802407:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80240c:	c9                   	leave  
  80240d:	c3                   	ret    

0080240e <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80240e:	55                   	push   %ebp
  80240f:	89 e5                	mov    %esp,%ebp
  802411:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802414:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80241b:	a1 38 51 80 00       	mov    0x805138,%eax
  802420:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802423:	e9 df 00 00 00       	jmp    802507 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802428:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242b:	8b 40 0c             	mov    0xc(%eax),%eax
  80242e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802431:	0f 82 c8 00 00 00    	jb     8024ff <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802437:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243a:	8b 40 0c             	mov    0xc(%eax),%eax
  80243d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802440:	0f 85 8a 00 00 00    	jne    8024d0 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802446:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80244a:	75 17                	jne    802463 <alloc_block_BF+0x55>
  80244c:	83 ec 04             	sub    $0x4,%esp
  80244f:	68 10 3f 80 00       	push   $0x803f10
  802454:	68 b7 00 00 00       	push   $0xb7
  802459:	68 67 3e 80 00       	push   $0x803e67
  80245e:	e8 d5 0e 00 00       	call   803338 <_panic>
  802463:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802466:	8b 00                	mov    (%eax),%eax
  802468:	85 c0                	test   %eax,%eax
  80246a:	74 10                	je     80247c <alloc_block_BF+0x6e>
  80246c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246f:	8b 00                	mov    (%eax),%eax
  802471:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802474:	8b 52 04             	mov    0x4(%edx),%edx
  802477:	89 50 04             	mov    %edx,0x4(%eax)
  80247a:	eb 0b                	jmp    802487 <alloc_block_BF+0x79>
  80247c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247f:	8b 40 04             	mov    0x4(%eax),%eax
  802482:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802487:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248a:	8b 40 04             	mov    0x4(%eax),%eax
  80248d:	85 c0                	test   %eax,%eax
  80248f:	74 0f                	je     8024a0 <alloc_block_BF+0x92>
  802491:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802494:	8b 40 04             	mov    0x4(%eax),%eax
  802497:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80249a:	8b 12                	mov    (%edx),%edx
  80249c:	89 10                	mov    %edx,(%eax)
  80249e:	eb 0a                	jmp    8024aa <alloc_block_BF+0x9c>
  8024a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a3:	8b 00                	mov    (%eax),%eax
  8024a5:	a3 38 51 80 00       	mov    %eax,0x805138
  8024aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024bd:	a1 44 51 80 00       	mov    0x805144,%eax
  8024c2:	48                   	dec    %eax
  8024c3:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8024c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cb:	e9 4d 01 00 00       	jmp    80261d <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8024d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8024d6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024d9:	76 24                	jbe    8024ff <alloc_block_BF+0xf1>
  8024db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024de:	8b 40 0c             	mov    0xc(%eax),%eax
  8024e1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8024e4:	73 19                	jae    8024ff <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8024e6:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8024ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8024f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8024f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f9:	8b 40 08             	mov    0x8(%eax),%eax
  8024fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8024ff:	a1 40 51 80 00       	mov    0x805140,%eax
  802504:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802507:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80250b:	74 07                	je     802514 <alloc_block_BF+0x106>
  80250d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802510:	8b 00                	mov    (%eax),%eax
  802512:	eb 05                	jmp    802519 <alloc_block_BF+0x10b>
  802514:	b8 00 00 00 00       	mov    $0x0,%eax
  802519:	a3 40 51 80 00       	mov    %eax,0x805140
  80251e:	a1 40 51 80 00       	mov    0x805140,%eax
  802523:	85 c0                	test   %eax,%eax
  802525:	0f 85 fd fe ff ff    	jne    802428 <alloc_block_BF+0x1a>
  80252b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80252f:	0f 85 f3 fe ff ff    	jne    802428 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802535:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802539:	0f 84 d9 00 00 00    	je     802618 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  80253f:	a1 48 51 80 00       	mov    0x805148,%eax
  802544:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802547:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80254a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80254d:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802550:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802553:	8b 55 08             	mov    0x8(%ebp),%edx
  802556:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802559:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80255d:	75 17                	jne    802576 <alloc_block_BF+0x168>
  80255f:	83 ec 04             	sub    $0x4,%esp
  802562:	68 10 3f 80 00       	push   $0x803f10
  802567:	68 c7 00 00 00       	push   $0xc7
  80256c:	68 67 3e 80 00       	push   $0x803e67
  802571:	e8 c2 0d 00 00       	call   803338 <_panic>
  802576:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802579:	8b 00                	mov    (%eax),%eax
  80257b:	85 c0                	test   %eax,%eax
  80257d:	74 10                	je     80258f <alloc_block_BF+0x181>
  80257f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802582:	8b 00                	mov    (%eax),%eax
  802584:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802587:	8b 52 04             	mov    0x4(%edx),%edx
  80258a:	89 50 04             	mov    %edx,0x4(%eax)
  80258d:	eb 0b                	jmp    80259a <alloc_block_BF+0x18c>
  80258f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802592:	8b 40 04             	mov    0x4(%eax),%eax
  802595:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80259a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80259d:	8b 40 04             	mov    0x4(%eax),%eax
  8025a0:	85 c0                	test   %eax,%eax
  8025a2:	74 0f                	je     8025b3 <alloc_block_BF+0x1a5>
  8025a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025a7:	8b 40 04             	mov    0x4(%eax),%eax
  8025aa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025ad:	8b 12                	mov    (%edx),%edx
  8025af:	89 10                	mov    %edx,(%eax)
  8025b1:	eb 0a                	jmp    8025bd <alloc_block_BF+0x1af>
  8025b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025b6:	8b 00                	mov    (%eax),%eax
  8025b8:	a3 48 51 80 00       	mov    %eax,0x805148
  8025bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025c9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025d0:	a1 54 51 80 00       	mov    0x805154,%eax
  8025d5:	48                   	dec    %eax
  8025d6:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8025db:	83 ec 08             	sub    $0x8,%esp
  8025de:	ff 75 ec             	pushl  -0x14(%ebp)
  8025e1:	68 38 51 80 00       	push   $0x805138
  8025e6:	e8 71 f9 ff ff       	call   801f5c <find_block>
  8025eb:	83 c4 10             	add    $0x10,%esp
  8025ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8025f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025f4:	8b 50 08             	mov    0x8(%eax),%edx
  8025f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fa:	01 c2                	add    %eax,%edx
  8025fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025ff:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802602:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802605:	8b 40 0c             	mov    0xc(%eax),%eax
  802608:	2b 45 08             	sub    0x8(%ebp),%eax
  80260b:	89 c2                	mov    %eax,%edx
  80260d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802610:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802613:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802616:	eb 05                	jmp    80261d <alloc_block_BF+0x20f>
	}
	return NULL;
  802618:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80261d:	c9                   	leave  
  80261e:	c3                   	ret    

0080261f <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80261f:	55                   	push   %ebp
  802620:	89 e5                	mov    %esp,%ebp
  802622:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802625:	a1 28 50 80 00       	mov    0x805028,%eax
  80262a:	85 c0                	test   %eax,%eax
  80262c:	0f 85 de 01 00 00    	jne    802810 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802632:	a1 38 51 80 00       	mov    0x805138,%eax
  802637:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80263a:	e9 9e 01 00 00       	jmp    8027dd <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  80263f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802642:	8b 40 0c             	mov    0xc(%eax),%eax
  802645:	3b 45 08             	cmp    0x8(%ebp),%eax
  802648:	0f 82 87 01 00 00    	jb     8027d5 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  80264e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802651:	8b 40 0c             	mov    0xc(%eax),%eax
  802654:	3b 45 08             	cmp    0x8(%ebp),%eax
  802657:	0f 85 95 00 00 00    	jne    8026f2 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  80265d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802661:	75 17                	jne    80267a <alloc_block_NF+0x5b>
  802663:	83 ec 04             	sub    $0x4,%esp
  802666:	68 10 3f 80 00       	push   $0x803f10
  80266b:	68 e0 00 00 00       	push   $0xe0
  802670:	68 67 3e 80 00       	push   $0x803e67
  802675:	e8 be 0c 00 00       	call   803338 <_panic>
  80267a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267d:	8b 00                	mov    (%eax),%eax
  80267f:	85 c0                	test   %eax,%eax
  802681:	74 10                	je     802693 <alloc_block_NF+0x74>
  802683:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802686:	8b 00                	mov    (%eax),%eax
  802688:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80268b:	8b 52 04             	mov    0x4(%edx),%edx
  80268e:	89 50 04             	mov    %edx,0x4(%eax)
  802691:	eb 0b                	jmp    80269e <alloc_block_NF+0x7f>
  802693:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802696:	8b 40 04             	mov    0x4(%eax),%eax
  802699:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80269e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a1:	8b 40 04             	mov    0x4(%eax),%eax
  8026a4:	85 c0                	test   %eax,%eax
  8026a6:	74 0f                	je     8026b7 <alloc_block_NF+0x98>
  8026a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ab:	8b 40 04             	mov    0x4(%eax),%eax
  8026ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026b1:	8b 12                	mov    (%edx),%edx
  8026b3:	89 10                	mov    %edx,(%eax)
  8026b5:	eb 0a                	jmp    8026c1 <alloc_block_NF+0xa2>
  8026b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ba:	8b 00                	mov    (%eax),%eax
  8026bc:	a3 38 51 80 00       	mov    %eax,0x805138
  8026c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026d4:	a1 44 51 80 00       	mov    0x805144,%eax
  8026d9:	48                   	dec    %eax
  8026da:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8026df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e2:	8b 40 08             	mov    0x8(%eax),%eax
  8026e5:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8026ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ed:	e9 f8 04 00 00       	jmp    802bea <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8026f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8026f8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026fb:	0f 86 d4 00 00 00    	jbe    8027d5 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802701:	a1 48 51 80 00       	mov    0x805148,%eax
  802706:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802709:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270c:	8b 50 08             	mov    0x8(%eax),%edx
  80270f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802712:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802715:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802718:	8b 55 08             	mov    0x8(%ebp),%edx
  80271b:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80271e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802722:	75 17                	jne    80273b <alloc_block_NF+0x11c>
  802724:	83 ec 04             	sub    $0x4,%esp
  802727:	68 10 3f 80 00       	push   $0x803f10
  80272c:	68 e9 00 00 00       	push   $0xe9
  802731:	68 67 3e 80 00       	push   $0x803e67
  802736:	e8 fd 0b 00 00       	call   803338 <_panic>
  80273b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80273e:	8b 00                	mov    (%eax),%eax
  802740:	85 c0                	test   %eax,%eax
  802742:	74 10                	je     802754 <alloc_block_NF+0x135>
  802744:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802747:	8b 00                	mov    (%eax),%eax
  802749:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80274c:	8b 52 04             	mov    0x4(%edx),%edx
  80274f:	89 50 04             	mov    %edx,0x4(%eax)
  802752:	eb 0b                	jmp    80275f <alloc_block_NF+0x140>
  802754:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802757:	8b 40 04             	mov    0x4(%eax),%eax
  80275a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80275f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802762:	8b 40 04             	mov    0x4(%eax),%eax
  802765:	85 c0                	test   %eax,%eax
  802767:	74 0f                	je     802778 <alloc_block_NF+0x159>
  802769:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80276c:	8b 40 04             	mov    0x4(%eax),%eax
  80276f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802772:	8b 12                	mov    (%edx),%edx
  802774:	89 10                	mov    %edx,(%eax)
  802776:	eb 0a                	jmp    802782 <alloc_block_NF+0x163>
  802778:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80277b:	8b 00                	mov    (%eax),%eax
  80277d:	a3 48 51 80 00       	mov    %eax,0x805148
  802782:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802785:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80278b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80278e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802795:	a1 54 51 80 00       	mov    0x805154,%eax
  80279a:	48                   	dec    %eax
  80279b:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  8027a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a3:	8b 40 08             	mov    0x8(%eax),%eax
  8027a6:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8027ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ae:	8b 50 08             	mov    0x8(%eax),%edx
  8027b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b4:	01 c2                	add    %eax,%edx
  8027b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b9:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8027bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8027c2:	2b 45 08             	sub    0x8(%ebp),%eax
  8027c5:	89 c2                	mov    %eax,%edx
  8027c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ca:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8027cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d0:	e9 15 04 00 00       	jmp    802bea <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8027d5:	a1 40 51 80 00       	mov    0x805140,%eax
  8027da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027e1:	74 07                	je     8027ea <alloc_block_NF+0x1cb>
  8027e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e6:	8b 00                	mov    (%eax),%eax
  8027e8:	eb 05                	jmp    8027ef <alloc_block_NF+0x1d0>
  8027ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8027ef:	a3 40 51 80 00       	mov    %eax,0x805140
  8027f4:	a1 40 51 80 00       	mov    0x805140,%eax
  8027f9:	85 c0                	test   %eax,%eax
  8027fb:	0f 85 3e fe ff ff    	jne    80263f <alloc_block_NF+0x20>
  802801:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802805:	0f 85 34 fe ff ff    	jne    80263f <alloc_block_NF+0x20>
  80280b:	e9 d5 03 00 00       	jmp    802be5 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802810:	a1 38 51 80 00       	mov    0x805138,%eax
  802815:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802818:	e9 b1 01 00 00       	jmp    8029ce <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  80281d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802820:	8b 50 08             	mov    0x8(%eax),%edx
  802823:	a1 28 50 80 00       	mov    0x805028,%eax
  802828:	39 c2                	cmp    %eax,%edx
  80282a:	0f 82 96 01 00 00    	jb     8029c6 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802830:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802833:	8b 40 0c             	mov    0xc(%eax),%eax
  802836:	3b 45 08             	cmp    0x8(%ebp),%eax
  802839:	0f 82 87 01 00 00    	jb     8029c6 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  80283f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802842:	8b 40 0c             	mov    0xc(%eax),%eax
  802845:	3b 45 08             	cmp    0x8(%ebp),%eax
  802848:	0f 85 95 00 00 00    	jne    8028e3 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80284e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802852:	75 17                	jne    80286b <alloc_block_NF+0x24c>
  802854:	83 ec 04             	sub    $0x4,%esp
  802857:	68 10 3f 80 00       	push   $0x803f10
  80285c:	68 fc 00 00 00       	push   $0xfc
  802861:	68 67 3e 80 00       	push   $0x803e67
  802866:	e8 cd 0a 00 00       	call   803338 <_panic>
  80286b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286e:	8b 00                	mov    (%eax),%eax
  802870:	85 c0                	test   %eax,%eax
  802872:	74 10                	je     802884 <alloc_block_NF+0x265>
  802874:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802877:	8b 00                	mov    (%eax),%eax
  802879:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80287c:	8b 52 04             	mov    0x4(%edx),%edx
  80287f:	89 50 04             	mov    %edx,0x4(%eax)
  802882:	eb 0b                	jmp    80288f <alloc_block_NF+0x270>
  802884:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802887:	8b 40 04             	mov    0x4(%eax),%eax
  80288a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80288f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802892:	8b 40 04             	mov    0x4(%eax),%eax
  802895:	85 c0                	test   %eax,%eax
  802897:	74 0f                	je     8028a8 <alloc_block_NF+0x289>
  802899:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289c:	8b 40 04             	mov    0x4(%eax),%eax
  80289f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028a2:	8b 12                	mov    (%edx),%edx
  8028a4:	89 10                	mov    %edx,(%eax)
  8028a6:	eb 0a                	jmp    8028b2 <alloc_block_NF+0x293>
  8028a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ab:	8b 00                	mov    (%eax),%eax
  8028ad:	a3 38 51 80 00       	mov    %eax,0x805138
  8028b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028c5:	a1 44 51 80 00       	mov    0x805144,%eax
  8028ca:	48                   	dec    %eax
  8028cb:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8028d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d3:	8b 40 08             	mov    0x8(%eax),%eax
  8028d6:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8028db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028de:	e9 07 03 00 00       	jmp    802bea <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8028e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e6:	8b 40 0c             	mov    0xc(%eax),%eax
  8028e9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028ec:	0f 86 d4 00 00 00    	jbe    8029c6 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8028f2:	a1 48 51 80 00       	mov    0x805148,%eax
  8028f7:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8028fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fd:	8b 50 08             	mov    0x8(%eax),%edx
  802900:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802903:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802906:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802909:	8b 55 08             	mov    0x8(%ebp),%edx
  80290c:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80290f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802913:	75 17                	jne    80292c <alloc_block_NF+0x30d>
  802915:	83 ec 04             	sub    $0x4,%esp
  802918:	68 10 3f 80 00       	push   $0x803f10
  80291d:	68 04 01 00 00       	push   $0x104
  802922:	68 67 3e 80 00       	push   $0x803e67
  802927:	e8 0c 0a 00 00       	call   803338 <_panic>
  80292c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80292f:	8b 00                	mov    (%eax),%eax
  802931:	85 c0                	test   %eax,%eax
  802933:	74 10                	je     802945 <alloc_block_NF+0x326>
  802935:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802938:	8b 00                	mov    (%eax),%eax
  80293a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80293d:	8b 52 04             	mov    0x4(%edx),%edx
  802940:	89 50 04             	mov    %edx,0x4(%eax)
  802943:	eb 0b                	jmp    802950 <alloc_block_NF+0x331>
  802945:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802948:	8b 40 04             	mov    0x4(%eax),%eax
  80294b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802950:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802953:	8b 40 04             	mov    0x4(%eax),%eax
  802956:	85 c0                	test   %eax,%eax
  802958:	74 0f                	je     802969 <alloc_block_NF+0x34a>
  80295a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80295d:	8b 40 04             	mov    0x4(%eax),%eax
  802960:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802963:	8b 12                	mov    (%edx),%edx
  802965:	89 10                	mov    %edx,(%eax)
  802967:	eb 0a                	jmp    802973 <alloc_block_NF+0x354>
  802969:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80296c:	8b 00                	mov    (%eax),%eax
  80296e:	a3 48 51 80 00       	mov    %eax,0x805148
  802973:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802976:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80297c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80297f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802986:	a1 54 51 80 00       	mov    0x805154,%eax
  80298b:	48                   	dec    %eax
  80298c:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802991:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802994:	8b 40 08             	mov    0x8(%eax),%eax
  802997:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  80299c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299f:	8b 50 08             	mov    0x8(%eax),%edx
  8029a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a5:	01 c2                	add    %eax,%edx
  8029a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029aa:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8029ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8029b3:	2b 45 08             	sub    0x8(%ebp),%eax
  8029b6:	89 c2                	mov    %eax,%edx
  8029b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bb:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8029be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029c1:	e9 24 02 00 00       	jmp    802bea <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029c6:	a1 40 51 80 00       	mov    0x805140,%eax
  8029cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029d2:	74 07                	je     8029db <alloc_block_NF+0x3bc>
  8029d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d7:	8b 00                	mov    (%eax),%eax
  8029d9:	eb 05                	jmp    8029e0 <alloc_block_NF+0x3c1>
  8029db:	b8 00 00 00 00       	mov    $0x0,%eax
  8029e0:	a3 40 51 80 00       	mov    %eax,0x805140
  8029e5:	a1 40 51 80 00       	mov    0x805140,%eax
  8029ea:	85 c0                	test   %eax,%eax
  8029ec:	0f 85 2b fe ff ff    	jne    80281d <alloc_block_NF+0x1fe>
  8029f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029f6:	0f 85 21 fe ff ff    	jne    80281d <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029fc:	a1 38 51 80 00       	mov    0x805138,%eax
  802a01:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a04:	e9 ae 01 00 00       	jmp    802bb7 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802a09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0c:	8b 50 08             	mov    0x8(%eax),%edx
  802a0f:	a1 28 50 80 00       	mov    0x805028,%eax
  802a14:	39 c2                	cmp    %eax,%edx
  802a16:	0f 83 93 01 00 00    	jae    802baf <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1f:	8b 40 0c             	mov    0xc(%eax),%eax
  802a22:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a25:	0f 82 84 01 00 00    	jb     802baf <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802a2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2e:	8b 40 0c             	mov    0xc(%eax),%eax
  802a31:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a34:	0f 85 95 00 00 00    	jne    802acf <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a3a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a3e:	75 17                	jne    802a57 <alloc_block_NF+0x438>
  802a40:	83 ec 04             	sub    $0x4,%esp
  802a43:	68 10 3f 80 00       	push   $0x803f10
  802a48:	68 14 01 00 00       	push   $0x114
  802a4d:	68 67 3e 80 00       	push   $0x803e67
  802a52:	e8 e1 08 00 00       	call   803338 <_panic>
  802a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5a:	8b 00                	mov    (%eax),%eax
  802a5c:	85 c0                	test   %eax,%eax
  802a5e:	74 10                	je     802a70 <alloc_block_NF+0x451>
  802a60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a63:	8b 00                	mov    (%eax),%eax
  802a65:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a68:	8b 52 04             	mov    0x4(%edx),%edx
  802a6b:	89 50 04             	mov    %edx,0x4(%eax)
  802a6e:	eb 0b                	jmp    802a7b <alloc_block_NF+0x45c>
  802a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a73:	8b 40 04             	mov    0x4(%eax),%eax
  802a76:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7e:	8b 40 04             	mov    0x4(%eax),%eax
  802a81:	85 c0                	test   %eax,%eax
  802a83:	74 0f                	je     802a94 <alloc_block_NF+0x475>
  802a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a88:	8b 40 04             	mov    0x4(%eax),%eax
  802a8b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a8e:	8b 12                	mov    (%edx),%edx
  802a90:	89 10                	mov    %edx,(%eax)
  802a92:	eb 0a                	jmp    802a9e <alloc_block_NF+0x47f>
  802a94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a97:	8b 00                	mov    (%eax),%eax
  802a99:	a3 38 51 80 00       	mov    %eax,0x805138
  802a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aaa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ab1:	a1 44 51 80 00       	mov    0x805144,%eax
  802ab6:	48                   	dec    %eax
  802ab7:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802abc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abf:	8b 40 08             	mov    0x8(%eax),%eax
  802ac2:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802ac7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aca:	e9 1b 01 00 00       	jmp    802bea <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad2:	8b 40 0c             	mov    0xc(%eax),%eax
  802ad5:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ad8:	0f 86 d1 00 00 00    	jbe    802baf <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802ade:	a1 48 51 80 00       	mov    0x805148,%eax
  802ae3:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae9:	8b 50 08             	mov    0x8(%eax),%edx
  802aec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aef:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802af2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af5:	8b 55 08             	mov    0x8(%ebp),%edx
  802af8:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802afb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802aff:	75 17                	jne    802b18 <alloc_block_NF+0x4f9>
  802b01:	83 ec 04             	sub    $0x4,%esp
  802b04:	68 10 3f 80 00       	push   $0x803f10
  802b09:	68 1c 01 00 00       	push   $0x11c
  802b0e:	68 67 3e 80 00       	push   $0x803e67
  802b13:	e8 20 08 00 00       	call   803338 <_panic>
  802b18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b1b:	8b 00                	mov    (%eax),%eax
  802b1d:	85 c0                	test   %eax,%eax
  802b1f:	74 10                	je     802b31 <alloc_block_NF+0x512>
  802b21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b24:	8b 00                	mov    (%eax),%eax
  802b26:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b29:	8b 52 04             	mov    0x4(%edx),%edx
  802b2c:	89 50 04             	mov    %edx,0x4(%eax)
  802b2f:	eb 0b                	jmp    802b3c <alloc_block_NF+0x51d>
  802b31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b34:	8b 40 04             	mov    0x4(%eax),%eax
  802b37:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b3f:	8b 40 04             	mov    0x4(%eax),%eax
  802b42:	85 c0                	test   %eax,%eax
  802b44:	74 0f                	je     802b55 <alloc_block_NF+0x536>
  802b46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b49:	8b 40 04             	mov    0x4(%eax),%eax
  802b4c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b4f:	8b 12                	mov    (%edx),%edx
  802b51:	89 10                	mov    %edx,(%eax)
  802b53:	eb 0a                	jmp    802b5f <alloc_block_NF+0x540>
  802b55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b58:	8b 00                	mov    (%eax),%eax
  802b5a:	a3 48 51 80 00       	mov    %eax,0x805148
  802b5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b62:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b6b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b72:	a1 54 51 80 00       	mov    0x805154,%eax
  802b77:	48                   	dec    %eax
  802b78:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802b7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b80:	8b 40 08             	mov    0x8(%eax),%eax
  802b83:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802b88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8b:	8b 50 08             	mov    0x8(%eax),%edx
  802b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b91:	01 c2                	add    %eax,%edx
  802b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b96:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9c:	8b 40 0c             	mov    0xc(%eax),%eax
  802b9f:	2b 45 08             	sub    0x8(%ebp),%eax
  802ba2:	89 c2                	mov    %eax,%edx
  802ba4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba7:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802baa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bad:	eb 3b                	jmp    802bea <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802baf:	a1 40 51 80 00       	mov    0x805140,%eax
  802bb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bb7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bbb:	74 07                	je     802bc4 <alloc_block_NF+0x5a5>
  802bbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc0:	8b 00                	mov    (%eax),%eax
  802bc2:	eb 05                	jmp    802bc9 <alloc_block_NF+0x5aa>
  802bc4:	b8 00 00 00 00       	mov    $0x0,%eax
  802bc9:	a3 40 51 80 00       	mov    %eax,0x805140
  802bce:	a1 40 51 80 00       	mov    0x805140,%eax
  802bd3:	85 c0                	test   %eax,%eax
  802bd5:	0f 85 2e fe ff ff    	jne    802a09 <alloc_block_NF+0x3ea>
  802bdb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bdf:	0f 85 24 fe ff ff    	jne    802a09 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802be5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bea:	c9                   	leave  
  802beb:	c3                   	ret    

00802bec <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802bec:	55                   	push   %ebp
  802bed:	89 e5                	mov    %esp,%ebp
  802bef:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802bf2:	a1 38 51 80 00       	mov    0x805138,%eax
  802bf7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802bfa:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802bff:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802c02:	a1 38 51 80 00       	mov    0x805138,%eax
  802c07:	85 c0                	test   %eax,%eax
  802c09:	74 14                	je     802c1f <insert_sorted_with_merge_freeList+0x33>
  802c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0e:	8b 50 08             	mov    0x8(%eax),%edx
  802c11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c14:	8b 40 08             	mov    0x8(%eax),%eax
  802c17:	39 c2                	cmp    %eax,%edx
  802c19:	0f 87 9b 01 00 00    	ja     802dba <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802c1f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c23:	75 17                	jne    802c3c <insert_sorted_with_merge_freeList+0x50>
  802c25:	83 ec 04             	sub    $0x4,%esp
  802c28:	68 44 3e 80 00       	push   $0x803e44
  802c2d:	68 38 01 00 00       	push   $0x138
  802c32:	68 67 3e 80 00       	push   $0x803e67
  802c37:	e8 fc 06 00 00       	call   803338 <_panic>
  802c3c:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802c42:	8b 45 08             	mov    0x8(%ebp),%eax
  802c45:	89 10                	mov    %edx,(%eax)
  802c47:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4a:	8b 00                	mov    (%eax),%eax
  802c4c:	85 c0                	test   %eax,%eax
  802c4e:	74 0d                	je     802c5d <insert_sorted_with_merge_freeList+0x71>
  802c50:	a1 38 51 80 00       	mov    0x805138,%eax
  802c55:	8b 55 08             	mov    0x8(%ebp),%edx
  802c58:	89 50 04             	mov    %edx,0x4(%eax)
  802c5b:	eb 08                	jmp    802c65 <insert_sorted_with_merge_freeList+0x79>
  802c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c60:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c65:	8b 45 08             	mov    0x8(%ebp),%eax
  802c68:	a3 38 51 80 00       	mov    %eax,0x805138
  802c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c70:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c77:	a1 44 51 80 00       	mov    0x805144,%eax
  802c7c:	40                   	inc    %eax
  802c7d:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802c82:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c86:	0f 84 a8 06 00 00    	je     803334 <insert_sorted_with_merge_freeList+0x748>
  802c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8f:	8b 50 08             	mov    0x8(%eax),%edx
  802c92:	8b 45 08             	mov    0x8(%ebp),%eax
  802c95:	8b 40 0c             	mov    0xc(%eax),%eax
  802c98:	01 c2                	add    %eax,%edx
  802c9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c9d:	8b 40 08             	mov    0x8(%eax),%eax
  802ca0:	39 c2                	cmp    %eax,%edx
  802ca2:	0f 85 8c 06 00 00    	jne    803334 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  802cab:	8b 50 0c             	mov    0xc(%eax),%edx
  802cae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb1:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb4:	01 c2                	add    %eax,%edx
  802cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb9:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802cbc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cc0:	75 17                	jne    802cd9 <insert_sorted_with_merge_freeList+0xed>
  802cc2:	83 ec 04             	sub    $0x4,%esp
  802cc5:	68 10 3f 80 00       	push   $0x803f10
  802cca:	68 3c 01 00 00       	push   $0x13c
  802ccf:	68 67 3e 80 00       	push   $0x803e67
  802cd4:	e8 5f 06 00 00       	call   803338 <_panic>
  802cd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cdc:	8b 00                	mov    (%eax),%eax
  802cde:	85 c0                	test   %eax,%eax
  802ce0:	74 10                	je     802cf2 <insert_sorted_with_merge_freeList+0x106>
  802ce2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce5:	8b 00                	mov    (%eax),%eax
  802ce7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cea:	8b 52 04             	mov    0x4(%edx),%edx
  802ced:	89 50 04             	mov    %edx,0x4(%eax)
  802cf0:	eb 0b                	jmp    802cfd <insert_sorted_with_merge_freeList+0x111>
  802cf2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf5:	8b 40 04             	mov    0x4(%eax),%eax
  802cf8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d00:	8b 40 04             	mov    0x4(%eax),%eax
  802d03:	85 c0                	test   %eax,%eax
  802d05:	74 0f                	je     802d16 <insert_sorted_with_merge_freeList+0x12a>
  802d07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d0a:	8b 40 04             	mov    0x4(%eax),%eax
  802d0d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d10:	8b 12                	mov    (%edx),%edx
  802d12:	89 10                	mov    %edx,(%eax)
  802d14:	eb 0a                	jmp    802d20 <insert_sorted_with_merge_freeList+0x134>
  802d16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d19:	8b 00                	mov    (%eax),%eax
  802d1b:	a3 38 51 80 00       	mov    %eax,0x805138
  802d20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d23:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d2c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d33:	a1 44 51 80 00       	mov    0x805144,%eax
  802d38:	48                   	dec    %eax
  802d39:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802d3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d41:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802d48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802d52:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d56:	75 17                	jne    802d6f <insert_sorted_with_merge_freeList+0x183>
  802d58:	83 ec 04             	sub    $0x4,%esp
  802d5b:	68 44 3e 80 00       	push   $0x803e44
  802d60:	68 3f 01 00 00       	push   $0x13f
  802d65:	68 67 3e 80 00       	push   $0x803e67
  802d6a:	e8 c9 05 00 00       	call   803338 <_panic>
  802d6f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802d75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d78:	89 10                	mov    %edx,(%eax)
  802d7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d7d:	8b 00                	mov    (%eax),%eax
  802d7f:	85 c0                	test   %eax,%eax
  802d81:	74 0d                	je     802d90 <insert_sorted_with_merge_freeList+0x1a4>
  802d83:	a1 48 51 80 00       	mov    0x805148,%eax
  802d88:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d8b:	89 50 04             	mov    %edx,0x4(%eax)
  802d8e:	eb 08                	jmp    802d98 <insert_sorted_with_merge_freeList+0x1ac>
  802d90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d93:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d9b:	a3 48 51 80 00       	mov    %eax,0x805148
  802da0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802daa:	a1 54 51 80 00       	mov    0x805154,%eax
  802daf:	40                   	inc    %eax
  802db0:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802db5:	e9 7a 05 00 00       	jmp    803334 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802dba:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbd:	8b 50 08             	mov    0x8(%eax),%edx
  802dc0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dc3:	8b 40 08             	mov    0x8(%eax),%eax
  802dc6:	39 c2                	cmp    %eax,%edx
  802dc8:	0f 82 14 01 00 00    	jb     802ee2 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802dce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd1:	8b 50 08             	mov    0x8(%eax),%edx
  802dd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd7:	8b 40 0c             	mov    0xc(%eax),%eax
  802dda:	01 c2                	add    %eax,%edx
  802ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddf:	8b 40 08             	mov    0x8(%eax),%eax
  802de2:	39 c2                	cmp    %eax,%edx
  802de4:	0f 85 90 00 00 00    	jne    802e7a <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802dea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ded:	8b 50 0c             	mov    0xc(%eax),%edx
  802df0:	8b 45 08             	mov    0x8(%ebp),%eax
  802df3:	8b 40 0c             	mov    0xc(%eax),%eax
  802df6:	01 c2                	add    %eax,%edx
  802df8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dfb:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802e01:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802e08:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e12:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e16:	75 17                	jne    802e2f <insert_sorted_with_merge_freeList+0x243>
  802e18:	83 ec 04             	sub    $0x4,%esp
  802e1b:	68 44 3e 80 00       	push   $0x803e44
  802e20:	68 49 01 00 00       	push   $0x149
  802e25:	68 67 3e 80 00       	push   $0x803e67
  802e2a:	e8 09 05 00 00       	call   803338 <_panic>
  802e2f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e35:	8b 45 08             	mov    0x8(%ebp),%eax
  802e38:	89 10                	mov    %edx,(%eax)
  802e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3d:	8b 00                	mov    (%eax),%eax
  802e3f:	85 c0                	test   %eax,%eax
  802e41:	74 0d                	je     802e50 <insert_sorted_with_merge_freeList+0x264>
  802e43:	a1 48 51 80 00       	mov    0x805148,%eax
  802e48:	8b 55 08             	mov    0x8(%ebp),%edx
  802e4b:	89 50 04             	mov    %edx,0x4(%eax)
  802e4e:	eb 08                	jmp    802e58 <insert_sorted_with_merge_freeList+0x26c>
  802e50:	8b 45 08             	mov    0x8(%ebp),%eax
  802e53:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e58:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5b:	a3 48 51 80 00       	mov    %eax,0x805148
  802e60:	8b 45 08             	mov    0x8(%ebp),%eax
  802e63:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e6a:	a1 54 51 80 00       	mov    0x805154,%eax
  802e6f:	40                   	inc    %eax
  802e70:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e75:	e9 bb 04 00 00       	jmp    803335 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802e7a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e7e:	75 17                	jne    802e97 <insert_sorted_with_merge_freeList+0x2ab>
  802e80:	83 ec 04             	sub    $0x4,%esp
  802e83:	68 b8 3e 80 00       	push   $0x803eb8
  802e88:	68 4c 01 00 00       	push   $0x14c
  802e8d:	68 67 3e 80 00       	push   $0x803e67
  802e92:	e8 a1 04 00 00       	call   803338 <_panic>
  802e97:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea0:	89 50 04             	mov    %edx,0x4(%eax)
  802ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea6:	8b 40 04             	mov    0x4(%eax),%eax
  802ea9:	85 c0                	test   %eax,%eax
  802eab:	74 0c                	je     802eb9 <insert_sorted_with_merge_freeList+0x2cd>
  802ead:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802eb2:	8b 55 08             	mov    0x8(%ebp),%edx
  802eb5:	89 10                	mov    %edx,(%eax)
  802eb7:	eb 08                	jmp    802ec1 <insert_sorted_with_merge_freeList+0x2d5>
  802eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebc:	a3 38 51 80 00       	mov    %eax,0x805138
  802ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ed2:	a1 44 51 80 00       	mov    0x805144,%eax
  802ed7:	40                   	inc    %eax
  802ed8:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802edd:	e9 53 04 00 00       	jmp    803335 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802ee2:	a1 38 51 80 00       	mov    0x805138,%eax
  802ee7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802eea:	e9 15 04 00 00       	jmp    803304 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802eef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef2:	8b 00                	mov    (%eax),%eax
  802ef4:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  802efa:	8b 50 08             	mov    0x8(%eax),%edx
  802efd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f00:	8b 40 08             	mov    0x8(%eax),%eax
  802f03:	39 c2                	cmp    %eax,%edx
  802f05:	0f 86 f1 03 00 00    	jbe    8032fc <insert_sorted_with_merge_freeList+0x710>
  802f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0e:	8b 50 08             	mov    0x8(%eax),%edx
  802f11:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f14:	8b 40 08             	mov    0x8(%eax),%eax
  802f17:	39 c2                	cmp    %eax,%edx
  802f19:	0f 83 dd 03 00 00    	jae    8032fc <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802f1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f22:	8b 50 08             	mov    0x8(%eax),%edx
  802f25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f28:	8b 40 0c             	mov    0xc(%eax),%eax
  802f2b:	01 c2                	add    %eax,%edx
  802f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f30:	8b 40 08             	mov    0x8(%eax),%eax
  802f33:	39 c2                	cmp    %eax,%edx
  802f35:	0f 85 b9 01 00 00    	jne    8030f4 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3e:	8b 50 08             	mov    0x8(%eax),%edx
  802f41:	8b 45 08             	mov    0x8(%ebp),%eax
  802f44:	8b 40 0c             	mov    0xc(%eax),%eax
  802f47:	01 c2                	add    %eax,%edx
  802f49:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f4c:	8b 40 08             	mov    0x8(%eax),%eax
  802f4f:	39 c2                	cmp    %eax,%edx
  802f51:	0f 85 0d 01 00 00    	jne    803064 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802f57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5a:	8b 50 0c             	mov    0xc(%eax),%edx
  802f5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f60:	8b 40 0c             	mov    0xc(%eax),%eax
  802f63:	01 c2                	add    %eax,%edx
  802f65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f68:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802f6b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f6f:	75 17                	jne    802f88 <insert_sorted_with_merge_freeList+0x39c>
  802f71:	83 ec 04             	sub    $0x4,%esp
  802f74:	68 10 3f 80 00       	push   $0x803f10
  802f79:	68 5c 01 00 00       	push   $0x15c
  802f7e:	68 67 3e 80 00       	push   $0x803e67
  802f83:	e8 b0 03 00 00       	call   803338 <_panic>
  802f88:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f8b:	8b 00                	mov    (%eax),%eax
  802f8d:	85 c0                	test   %eax,%eax
  802f8f:	74 10                	je     802fa1 <insert_sorted_with_merge_freeList+0x3b5>
  802f91:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f94:	8b 00                	mov    (%eax),%eax
  802f96:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f99:	8b 52 04             	mov    0x4(%edx),%edx
  802f9c:	89 50 04             	mov    %edx,0x4(%eax)
  802f9f:	eb 0b                	jmp    802fac <insert_sorted_with_merge_freeList+0x3c0>
  802fa1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fa4:	8b 40 04             	mov    0x4(%eax),%eax
  802fa7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802faf:	8b 40 04             	mov    0x4(%eax),%eax
  802fb2:	85 c0                	test   %eax,%eax
  802fb4:	74 0f                	je     802fc5 <insert_sorted_with_merge_freeList+0x3d9>
  802fb6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb9:	8b 40 04             	mov    0x4(%eax),%eax
  802fbc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fbf:	8b 12                	mov    (%edx),%edx
  802fc1:	89 10                	mov    %edx,(%eax)
  802fc3:	eb 0a                	jmp    802fcf <insert_sorted_with_merge_freeList+0x3e3>
  802fc5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc8:	8b 00                	mov    (%eax),%eax
  802fca:	a3 38 51 80 00       	mov    %eax,0x805138
  802fcf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fd2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fd8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fdb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fe2:	a1 44 51 80 00       	mov    0x805144,%eax
  802fe7:	48                   	dec    %eax
  802fe8:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  802fed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  802ff7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ffa:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803001:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803005:	75 17                	jne    80301e <insert_sorted_with_merge_freeList+0x432>
  803007:	83 ec 04             	sub    $0x4,%esp
  80300a:	68 44 3e 80 00       	push   $0x803e44
  80300f:	68 5f 01 00 00       	push   $0x15f
  803014:	68 67 3e 80 00       	push   $0x803e67
  803019:	e8 1a 03 00 00       	call   803338 <_panic>
  80301e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803024:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803027:	89 10                	mov    %edx,(%eax)
  803029:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80302c:	8b 00                	mov    (%eax),%eax
  80302e:	85 c0                	test   %eax,%eax
  803030:	74 0d                	je     80303f <insert_sorted_with_merge_freeList+0x453>
  803032:	a1 48 51 80 00       	mov    0x805148,%eax
  803037:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80303a:	89 50 04             	mov    %edx,0x4(%eax)
  80303d:	eb 08                	jmp    803047 <insert_sorted_with_merge_freeList+0x45b>
  80303f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803042:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803047:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80304a:	a3 48 51 80 00       	mov    %eax,0x805148
  80304f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803052:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803059:	a1 54 51 80 00       	mov    0x805154,%eax
  80305e:	40                   	inc    %eax
  80305f:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803064:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803067:	8b 50 0c             	mov    0xc(%eax),%edx
  80306a:	8b 45 08             	mov    0x8(%ebp),%eax
  80306d:	8b 40 0c             	mov    0xc(%eax),%eax
  803070:	01 c2                	add    %eax,%edx
  803072:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803075:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803078:	8b 45 08             	mov    0x8(%ebp),%eax
  80307b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803082:	8b 45 08             	mov    0x8(%ebp),%eax
  803085:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80308c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803090:	75 17                	jne    8030a9 <insert_sorted_with_merge_freeList+0x4bd>
  803092:	83 ec 04             	sub    $0x4,%esp
  803095:	68 44 3e 80 00       	push   $0x803e44
  80309a:	68 64 01 00 00       	push   $0x164
  80309f:	68 67 3e 80 00       	push   $0x803e67
  8030a4:	e8 8f 02 00 00       	call   803338 <_panic>
  8030a9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030af:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b2:	89 10                	mov    %edx,(%eax)
  8030b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b7:	8b 00                	mov    (%eax),%eax
  8030b9:	85 c0                	test   %eax,%eax
  8030bb:	74 0d                	je     8030ca <insert_sorted_with_merge_freeList+0x4de>
  8030bd:	a1 48 51 80 00       	mov    0x805148,%eax
  8030c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8030c5:	89 50 04             	mov    %edx,0x4(%eax)
  8030c8:	eb 08                	jmp    8030d2 <insert_sorted_with_merge_freeList+0x4e6>
  8030ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8030cd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d5:	a3 48 51 80 00       	mov    %eax,0x805148
  8030da:	8b 45 08             	mov    0x8(%ebp),%eax
  8030dd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030e4:	a1 54 51 80 00       	mov    0x805154,%eax
  8030e9:	40                   	inc    %eax
  8030ea:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8030ef:	e9 41 02 00 00       	jmp    803335 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8030f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f7:	8b 50 08             	mov    0x8(%eax),%edx
  8030fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fd:	8b 40 0c             	mov    0xc(%eax),%eax
  803100:	01 c2                	add    %eax,%edx
  803102:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803105:	8b 40 08             	mov    0x8(%eax),%eax
  803108:	39 c2                	cmp    %eax,%edx
  80310a:	0f 85 7c 01 00 00    	jne    80328c <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803110:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803114:	74 06                	je     80311c <insert_sorted_with_merge_freeList+0x530>
  803116:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80311a:	75 17                	jne    803133 <insert_sorted_with_merge_freeList+0x547>
  80311c:	83 ec 04             	sub    $0x4,%esp
  80311f:	68 80 3e 80 00       	push   $0x803e80
  803124:	68 69 01 00 00       	push   $0x169
  803129:	68 67 3e 80 00       	push   $0x803e67
  80312e:	e8 05 02 00 00       	call   803338 <_panic>
  803133:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803136:	8b 50 04             	mov    0x4(%eax),%edx
  803139:	8b 45 08             	mov    0x8(%ebp),%eax
  80313c:	89 50 04             	mov    %edx,0x4(%eax)
  80313f:	8b 45 08             	mov    0x8(%ebp),%eax
  803142:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803145:	89 10                	mov    %edx,(%eax)
  803147:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80314a:	8b 40 04             	mov    0x4(%eax),%eax
  80314d:	85 c0                	test   %eax,%eax
  80314f:	74 0d                	je     80315e <insert_sorted_with_merge_freeList+0x572>
  803151:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803154:	8b 40 04             	mov    0x4(%eax),%eax
  803157:	8b 55 08             	mov    0x8(%ebp),%edx
  80315a:	89 10                	mov    %edx,(%eax)
  80315c:	eb 08                	jmp    803166 <insert_sorted_with_merge_freeList+0x57a>
  80315e:	8b 45 08             	mov    0x8(%ebp),%eax
  803161:	a3 38 51 80 00       	mov    %eax,0x805138
  803166:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803169:	8b 55 08             	mov    0x8(%ebp),%edx
  80316c:	89 50 04             	mov    %edx,0x4(%eax)
  80316f:	a1 44 51 80 00       	mov    0x805144,%eax
  803174:	40                   	inc    %eax
  803175:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  80317a:	8b 45 08             	mov    0x8(%ebp),%eax
  80317d:	8b 50 0c             	mov    0xc(%eax),%edx
  803180:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803183:	8b 40 0c             	mov    0xc(%eax),%eax
  803186:	01 c2                	add    %eax,%edx
  803188:	8b 45 08             	mov    0x8(%ebp),%eax
  80318b:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80318e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803192:	75 17                	jne    8031ab <insert_sorted_with_merge_freeList+0x5bf>
  803194:	83 ec 04             	sub    $0x4,%esp
  803197:	68 10 3f 80 00       	push   $0x803f10
  80319c:	68 6b 01 00 00       	push   $0x16b
  8031a1:	68 67 3e 80 00       	push   $0x803e67
  8031a6:	e8 8d 01 00 00       	call   803338 <_panic>
  8031ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ae:	8b 00                	mov    (%eax),%eax
  8031b0:	85 c0                	test   %eax,%eax
  8031b2:	74 10                	je     8031c4 <insert_sorted_with_merge_freeList+0x5d8>
  8031b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b7:	8b 00                	mov    (%eax),%eax
  8031b9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031bc:	8b 52 04             	mov    0x4(%edx),%edx
  8031bf:	89 50 04             	mov    %edx,0x4(%eax)
  8031c2:	eb 0b                	jmp    8031cf <insert_sorted_with_merge_freeList+0x5e3>
  8031c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c7:	8b 40 04             	mov    0x4(%eax),%eax
  8031ca:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d2:	8b 40 04             	mov    0x4(%eax),%eax
  8031d5:	85 c0                	test   %eax,%eax
  8031d7:	74 0f                	je     8031e8 <insert_sorted_with_merge_freeList+0x5fc>
  8031d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031dc:	8b 40 04             	mov    0x4(%eax),%eax
  8031df:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031e2:	8b 12                	mov    (%edx),%edx
  8031e4:	89 10                	mov    %edx,(%eax)
  8031e6:	eb 0a                	jmp    8031f2 <insert_sorted_with_merge_freeList+0x606>
  8031e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031eb:	8b 00                	mov    (%eax),%eax
  8031ed:	a3 38 51 80 00       	mov    %eax,0x805138
  8031f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031fe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803205:	a1 44 51 80 00       	mov    0x805144,%eax
  80320a:	48                   	dec    %eax
  80320b:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803210:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803213:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80321a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80321d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803224:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803228:	75 17                	jne    803241 <insert_sorted_with_merge_freeList+0x655>
  80322a:	83 ec 04             	sub    $0x4,%esp
  80322d:	68 44 3e 80 00       	push   $0x803e44
  803232:	68 6e 01 00 00       	push   $0x16e
  803237:	68 67 3e 80 00       	push   $0x803e67
  80323c:	e8 f7 00 00 00       	call   803338 <_panic>
  803241:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803247:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80324a:	89 10                	mov    %edx,(%eax)
  80324c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80324f:	8b 00                	mov    (%eax),%eax
  803251:	85 c0                	test   %eax,%eax
  803253:	74 0d                	je     803262 <insert_sorted_with_merge_freeList+0x676>
  803255:	a1 48 51 80 00       	mov    0x805148,%eax
  80325a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80325d:	89 50 04             	mov    %edx,0x4(%eax)
  803260:	eb 08                	jmp    80326a <insert_sorted_with_merge_freeList+0x67e>
  803262:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803265:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80326a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80326d:	a3 48 51 80 00       	mov    %eax,0x805148
  803272:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803275:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80327c:	a1 54 51 80 00       	mov    0x805154,%eax
  803281:	40                   	inc    %eax
  803282:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803287:	e9 a9 00 00 00       	jmp    803335 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  80328c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803290:	74 06                	je     803298 <insert_sorted_with_merge_freeList+0x6ac>
  803292:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803296:	75 17                	jne    8032af <insert_sorted_with_merge_freeList+0x6c3>
  803298:	83 ec 04             	sub    $0x4,%esp
  80329b:	68 dc 3e 80 00       	push   $0x803edc
  8032a0:	68 73 01 00 00       	push   $0x173
  8032a5:	68 67 3e 80 00       	push   $0x803e67
  8032aa:	e8 89 00 00 00       	call   803338 <_panic>
  8032af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b2:	8b 10                	mov    (%eax),%edx
  8032b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b7:	89 10                	mov    %edx,(%eax)
  8032b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bc:	8b 00                	mov    (%eax),%eax
  8032be:	85 c0                	test   %eax,%eax
  8032c0:	74 0b                	je     8032cd <insert_sorted_with_merge_freeList+0x6e1>
  8032c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c5:	8b 00                	mov    (%eax),%eax
  8032c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8032ca:	89 50 04             	mov    %edx,0x4(%eax)
  8032cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8032d3:	89 10                	mov    %edx,(%eax)
  8032d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032db:	89 50 04             	mov    %edx,0x4(%eax)
  8032de:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e1:	8b 00                	mov    (%eax),%eax
  8032e3:	85 c0                	test   %eax,%eax
  8032e5:	75 08                	jne    8032ef <insert_sorted_with_merge_freeList+0x703>
  8032e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ea:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032ef:	a1 44 51 80 00       	mov    0x805144,%eax
  8032f4:	40                   	inc    %eax
  8032f5:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8032fa:	eb 39                	jmp    803335 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8032fc:	a1 40 51 80 00       	mov    0x805140,%eax
  803301:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803304:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803308:	74 07                	je     803311 <insert_sorted_with_merge_freeList+0x725>
  80330a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80330d:	8b 00                	mov    (%eax),%eax
  80330f:	eb 05                	jmp    803316 <insert_sorted_with_merge_freeList+0x72a>
  803311:	b8 00 00 00 00       	mov    $0x0,%eax
  803316:	a3 40 51 80 00       	mov    %eax,0x805140
  80331b:	a1 40 51 80 00       	mov    0x805140,%eax
  803320:	85 c0                	test   %eax,%eax
  803322:	0f 85 c7 fb ff ff    	jne    802eef <insert_sorted_with_merge_freeList+0x303>
  803328:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80332c:	0f 85 bd fb ff ff    	jne    802eef <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803332:	eb 01                	jmp    803335 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803334:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803335:	90                   	nop
  803336:	c9                   	leave  
  803337:	c3                   	ret    

00803338 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803338:	55                   	push   %ebp
  803339:	89 e5                	mov    %esp,%ebp
  80333b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80333e:	8d 45 10             	lea    0x10(%ebp),%eax
  803341:	83 c0 04             	add    $0x4,%eax
  803344:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803347:	a1 5c 51 80 00       	mov    0x80515c,%eax
  80334c:	85 c0                	test   %eax,%eax
  80334e:	74 16                	je     803366 <_panic+0x2e>
		cprintf("%s: ", argv0);
  803350:	a1 5c 51 80 00       	mov    0x80515c,%eax
  803355:	83 ec 08             	sub    $0x8,%esp
  803358:	50                   	push   %eax
  803359:	68 30 3f 80 00       	push   $0x803f30
  80335e:	e8 03 d2 ff ff       	call   800566 <cprintf>
  803363:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803366:	a1 00 50 80 00       	mov    0x805000,%eax
  80336b:	ff 75 0c             	pushl  0xc(%ebp)
  80336e:	ff 75 08             	pushl  0x8(%ebp)
  803371:	50                   	push   %eax
  803372:	68 35 3f 80 00       	push   $0x803f35
  803377:	e8 ea d1 ff ff       	call   800566 <cprintf>
  80337c:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80337f:	8b 45 10             	mov    0x10(%ebp),%eax
  803382:	83 ec 08             	sub    $0x8,%esp
  803385:	ff 75 f4             	pushl  -0xc(%ebp)
  803388:	50                   	push   %eax
  803389:	e8 6d d1 ff ff       	call   8004fb <vcprintf>
  80338e:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803391:	83 ec 08             	sub    $0x8,%esp
  803394:	6a 00                	push   $0x0
  803396:	68 51 3f 80 00       	push   $0x803f51
  80339b:	e8 5b d1 ff ff       	call   8004fb <vcprintf>
  8033a0:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8033a3:	e8 dc d0 ff ff       	call   800484 <exit>

	// should not return here
	while (1) ;
  8033a8:	eb fe                	jmp    8033a8 <_panic+0x70>

008033aa <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8033aa:	55                   	push   %ebp
  8033ab:	89 e5                	mov    %esp,%ebp
  8033ad:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8033b0:	a1 20 50 80 00       	mov    0x805020,%eax
  8033b5:	8b 50 74             	mov    0x74(%eax),%edx
  8033b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033bb:	39 c2                	cmp    %eax,%edx
  8033bd:	74 14                	je     8033d3 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8033bf:	83 ec 04             	sub    $0x4,%esp
  8033c2:	68 54 3f 80 00       	push   $0x803f54
  8033c7:	6a 26                	push   $0x26
  8033c9:	68 a0 3f 80 00       	push   $0x803fa0
  8033ce:	e8 65 ff ff ff       	call   803338 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8033d3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8033da:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8033e1:	e9 c2 00 00 00       	jmp    8034a8 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8033e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033e9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8033f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f3:	01 d0                	add    %edx,%eax
  8033f5:	8b 00                	mov    (%eax),%eax
  8033f7:	85 c0                	test   %eax,%eax
  8033f9:	75 08                	jne    803403 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8033fb:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8033fe:	e9 a2 00 00 00       	jmp    8034a5 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  803403:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80340a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803411:	eb 69                	jmp    80347c <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803413:	a1 20 50 80 00       	mov    0x805020,%eax
  803418:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80341e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803421:	89 d0                	mov    %edx,%eax
  803423:	01 c0                	add    %eax,%eax
  803425:	01 d0                	add    %edx,%eax
  803427:	c1 e0 03             	shl    $0x3,%eax
  80342a:	01 c8                	add    %ecx,%eax
  80342c:	8a 40 04             	mov    0x4(%eax),%al
  80342f:	84 c0                	test   %al,%al
  803431:	75 46                	jne    803479 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803433:	a1 20 50 80 00       	mov    0x805020,%eax
  803438:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80343e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803441:	89 d0                	mov    %edx,%eax
  803443:	01 c0                	add    %eax,%eax
  803445:	01 d0                	add    %edx,%eax
  803447:	c1 e0 03             	shl    $0x3,%eax
  80344a:	01 c8                	add    %ecx,%eax
  80344c:	8b 00                	mov    (%eax),%eax
  80344e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803451:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803454:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803459:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80345b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80345e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803465:	8b 45 08             	mov    0x8(%ebp),%eax
  803468:	01 c8                	add    %ecx,%eax
  80346a:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80346c:	39 c2                	cmp    %eax,%edx
  80346e:	75 09                	jne    803479 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  803470:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803477:	eb 12                	jmp    80348b <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803479:	ff 45 e8             	incl   -0x18(%ebp)
  80347c:	a1 20 50 80 00       	mov    0x805020,%eax
  803481:	8b 50 74             	mov    0x74(%eax),%edx
  803484:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803487:	39 c2                	cmp    %eax,%edx
  803489:	77 88                	ja     803413 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80348b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80348f:	75 14                	jne    8034a5 <CheckWSWithoutLastIndex+0xfb>
			panic(
  803491:	83 ec 04             	sub    $0x4,%esp
  803494:	68 ac 3f 80 00       	push   $0x803fac
  803499:	6a 3a                	push   $0x3a
  80349b:	68 a0 3f 80 00       	push   $0x803fa0
  8034a0:	e8 93 fe ff ff       	call   803338 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8034a5:	ff 45 f0             	incl   -0x10(%ebp)
  8034a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034ab:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8034ae:	0f 8c 32 ff ff ff    	jl     8033e6 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8034b4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8034bb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8034c2:	eb 26                	jmp    8034ea <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8034c4:	a1 20 50 80 00       	mov    0x805020,%eax
  8034c9:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8034cf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8034d2:	89 d0                	mov    %edx,%eax
  8034d4:	01 c0                	add    %eax,%eax
  8034d6:	01 d0                	add    %edx,%eax
  8034d8:	c1 e0 03             	shl    $0x3,%eax
  8034db:	01 c8                	add    %ecx,%eax
  8034dd:	8a 40 04             	mov    0x4(%eax),%al
  8034e0:	3c 01                	cmp    $0x1,%al
  8034e2:	75 03                	jne    8034e7 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8034e4:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8034e7:	ff 45 e0             	incl   -0x20(%ebp)
  8034ea:	a1 20 50 80 00       	mov    0x805020,%eax
  8034ef:	8b 50 74             	mov    0x74(%eax),%edx
  8034f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034f5:	39 c2                	cmp    %eax,%edx
  8034f7:	77 cb                	ja     8034c4 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8034f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034fc:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8034ff:	74 14                	je     803515 <CheckWSWithoutLastIndex+0x16b>
		panic(
  803501:	83 ec 04             	sub    $0x4,%esp
  803504:	68 00 40 80 00       	push   $0x804000
  803509:	6a 44                	push   $0x44
  80350b:	68 a0 3f 80 00       	push   $0x803fa0
  803510:	e8 23 fe ff ff       	call   803338 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803515:	90                   	nop
  803516:	c9                   	leave  
  803517:	c3                   	ret    

00803518 <__udivdi3>:
  803518:	55                   	push   %ebp
  803519:	57                   	push   %edi
  80351a:	56                   	push   %esi
  80351b:	53                   	push   %ebx
  80351c:	83 ec 1c             	sub    $0x1c,%esp
  80351f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803523:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803527:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80352b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80352f:	89 ca                	mov    %ecx,%edx
  803531:	89 f8                	mov    %edi,%eax
  803533:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803537:	85 f6                	test   %esi,%esi
  803539:	75 2d                	jne    803568 <__udivdi3+0x50>
  80353b:	39 cf                	cmp    %ecx,%edi
  80353d:	77 65                	ja     8035a4 <__udivdi3+0x8c>
  80353f:	89 fd                	mov    %edi,%ebp
  803541:	85 ff                	test   %edi,%edi
  803543:	75 0b                	jne    803550 <__udivdi3+0x38>
  803545:	b8 01 00 00 00       	mov    $0x1,%eax
  80354a:	31 d2                	xor    %edx,%edx
  80354c:	f7 f7                	div    %edi
  80354e:	89 c5                	mov    %eax,%ebp
  803550:	31 d2                	xor    %edx,%edx
  803552:	89 c8                	mov    %ecx,%eax
  803554:	f7 f5                	div    %ebp
  803556:	89 c1                	mov    %eax,%ecx
  803558:	89 d8                	mov    %ebx,%eax
  80355a:	f7 f5                	div    %ebp
  80355c:	89 cf                	mov    %ecx,%edi
  80355e:	89 fa                	mov    %edi,%edx
  803560:	83 c4 1c             	add    $0x1c,%esp
  803563:	5b                   	pop    %ebx
  803564:	5e                   	pop    %esi
  803565:	5f                   	pop    %edi
  803566:	5d                   	pop    %ebp
  803567:	c3                   	ret    
  803568:	39 ce                	cmp    %ecx,%esi
  80356a:	77 28                	ja     803594 <__udivdi3+0x7c>
  80356c:	0f bd fe             	bsr    %esi,%edi
  80356f:	83 f7 1f             	xor    $0x1f,%edi
  803572:	75 40                	jne    8035b4 <__udivdi3+0x9c>
  803574:	39 ce                	cmp    %ecx,%esi
  803576:	72 0a                	jb     803582 <__udivdi3+0x6a>
  803578:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80357c:	0f 87 9e 00 00 00    	ja     803620 <__udivdi3+0x108>
  803582:	b8 01 00 00 00       	mov    $0x1,%eax
  803587:	89 fa                	mov    %edi,%edx
  803589:	83 c4 1c             	add    $0x1c,%esp
  80358c:	5b                   	pop    %ebx
  80358d:	5e                   	pop    %esi
  80358e:	5f                   	pop    %edi
  80358f:	5d                   	pop    %ebp
  803590:	c3                   	ret    
  803591:	8d 76 00             	lea    0x0(%esi),%esi
  803594:	31 ff                	xor    %edi,%edi
  803596:	31 c0                	xor    %eax,%eax
  803598:	89 fa                	mov    %edi,%edx
  80359a:	83 c4 1c             	add    $0x1c,%esp
  80359d:	5b                   	pop    %ebx
  80359e:	5e                   	pop    %esi
  80359f:	5f                   	pop    %edi
  8035a0:	5d                   	pop    %ebp
  8035a1:	c3                   	ret    
  8035a2:	66 90                	xchg   %ax,%ax
  8035a4:	89 d8                	mov    %ebx,%eax
  8035a6:	f7 f7                	div    %edi
  8035a8:	31 ff                	xor    %edi,%edi
  8035aa:	89 fa                	mov    %edi,%edx
  8035ac:	83 c4 1c             	add    $0x1c,%esp
  8035af:	5b                   	pop    %ebx
  8035b0:	5e                   	pop    %esi
  8035b1:	5f                   	pop    %edi
  8035b2:	5d                   	pop    %ebp
  8035b3:	c3                   	ret    
  8035b4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8035b9:	89 eb                	mov    %ebp,%ebx
  8035bb:	29 fb                	sub    %edi,%ebx
  8035bd:	89 f9                	mov    %edi,%ecx
  8035bf:	d3 e6                	shl    %cl,%esi
  8035c1:	89 c5                	mov    %eax,%ebp
  8035c3:	88 d9                	mov    %bl,%cl
  8035c5:	d3 ed                	shr    %cl,%ebp
  8035c7:	89 e9                	mov    %ebp,%ecx
  8035c9:	09 f1                	or     %esi,%ecx
  8035cb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8035cf:	89 f9                	mov    %edi,%ecx
  8035d1:	d3 e0                	shl    %cl,%eax
  8035d3:	89 c5                	mov    %eax,%ebp
  8035d5:	89 d6                	mov    %edx,%esi
  8035d7:	88 d9                	mov    %bl,%cl
  8035d9:	d3 ee                	shr    %cl,%esi
  8035db:	89 f9                	mov    %edi,%ecx
  8035dd:	d3 e2                	shl    %cl,%edx
  8035df:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035e3:	88 d9                	mov    %bl,%cl
  8035e5:	d3 e8                	shr    %cl,%eax
  8035e7:	09 c2                	or     %eax,%edx
  8035e9:	89 d0                	mov    %edx,%eax
  8035eb:	89 f2                	mov    %esi,%edx
  8035ed:	f7 74 24 0c          	divl   0xc(%esp)
  8035f1:	89 d6                	mov    %edx,%esi
  8035f3:	89 c3                	mov    %eax,%ebx
  8035f5:	f7 e5                	mul    %ebp
  8035f7:	39 d6                	cmp    %edx,%esi
  8035f9:	72 19                	jb     803614 <__udivdi3+0xfc>
  8035fb:	74 0b                	je     803608 <__udivdi3+0xf0>
  8035fd:	89 d8                	mov    %ebx,%eax
  8035ff:	31 ff                	xor    %edi,%edi
  803601:	e9 58 ff ff ff       	jmp    80355e <__udivdi3+0x46>
  803606:	66 90                	xchg   %ax,%ax
  803608:	8b 54 24 08          	mov    0x8(%esp),%edx
  80360c:	89 f9                	mov    %edi,%ecx
  80360e:	d3 e2                	shl    %cl,%edx
  803610:	39 c2                	cmp    %eax,%edx
  803612:	73 e9                	jae    8035fd <__udivdi3+0xe5>
  803614:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803617:	31 ff                	xor    %edi,%edi
  803619:	e9 40 ff ff ff       	jmp    80355e <__udivdi3+0x46>
  80361e:	66 90                	xchg   %ax,%ax
  803620:	31 c0                	xor    %eax,%eax
  803622:	e9 37 ff ff ff       	jmp    80355e <__udivdi3+0x46>
  803627:	90                   	nop

00803628 <__umoddi3>:
  803628:	55                   	push   %ebp
  803629:	57                   	push   %edi
  80362a:	56                   	push   %esi
  80362b:	53                   	push   %ebx
  80362c:	83 ec 1c             	sub    $0x1c,%esp
  80362f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803633:	8b 74 24 34          	mov    0x34(%esp),%esi
  803637:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80363b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80363f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803643:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803647:	89 f3                	mov    %esi,%ebx
  803649:	89 fa                	mov    %edi,%edx
  80364b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80364f:	89 34 24             	mov    %esi,(%esp)
  803652:	85 c0                	test   %eax,%eax
  803654:	75 1a                	jne    803670 <__umoddi3+0x48>
  803656:	39 f7                	cmp    %esi,%edi
  803658:	0f 86 a2 00 00 00    	jbe    803700 <__umoddi3+0xd8>
  80365e:	89 c8                	mov    %ecx,%eax
  803660:	89 f2                	mov    %esi,%edx
  803662:	f7 f7                	div    %edi
  803664:	89 d0                	mov    %edx,%eax
  803666:	31 d2                	xor    %edx,%edx
  803668:	83 c4 1c             	add    $0x1c,%esp
  80366b:	5b                   	pop    %ebx
  80366c:	5e                   	pop    %esi
  80366d:	5f                   	pop    %edi
  80366e:	5d                   	pop    %ebp
  80366f:	c3                   	ret    
  803670:	39 f0                	cmp    %esi,%eax
  803672:	0f 87 ac 00 00 00    	ja     803724 <__umoddi3+0xfc>
  803678:	0f bd e8             	bsr    %eax,%ebp
  80367b:	83 f5 1f             	xor    $0x1f,%ebp
  80367e:	0f 84 ac 00 00 00    	je     803730 <__umoddi3+0x108>
  803684:	bf 20 00 00 00       	mov    $0x20,%edi
  803689:	29 ef                	sub    %ebp,%edi
  80368b:	89 fe                	mov    %edi,%esi
  80368d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803691:	89 e9                	mov    %ebp,%ecx
  803693:	d3 e0                	shl    %cl,%eax
  803695:	89 d7                	mov    %edx,%edi
  803697:	89 f1                	mov    %esi,%ecx
  803699:	d3 ef                	shr    %cl,%edi
  80369b:	09 c7                	or     %eax,%edi
  80369d:	89 e9                	mov    %ebp,%ecx
  80369f:	d3 e2                	shl    %cl,%edx
  8036a1:	89 14 24             	mov    %edx,(%esp)
  8036a4:	89 d8                	mov    %ebx,%eax
  8036a6:	d3 e0                	shl    %cl,%eax
  8036a8:	89 c2                	mov    %eax,%edx
  8036aa:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036ae:	d3 e0                	shl    %cl,%eax
  8036b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8036b4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036b8:	89 f1                	mov    %esi,%ecx
  8036ba:	d3 e8                	shr    %cl,%eax
  8036bc:	09 d0                	or     %edx,%eax
  8036be:	d3 eb                	shr    %cl,%ebx
  8036c0:	89 da                	mov    %ebx,%edx
  8036c2:	f7 f7                	div    %edi
  8036c4:	89 d3                	mov    %edx,%ebx
  8036c6:	f7 24 24             	mull   (%esp)
  8036c9:	89 c6                	mov    %eax,%esi
  8036cb:	89 d1                	mov    %edx,%ecx
  8036cd:	39 d3                	cmp    %edx,%ebx
  8036cf:	0f 82 87 00 00 00    	jb     80375c <__umoddi3+0x134>
  8036d5:	0f 84 91 00 00 00    	je     80376c <__umoddi3+0x144>
  8036db:	8b 54 24 04          	mov    0x4(%esp),%edx
  8036df:	29 f2                	sub    %esi,%edx
  8036e1:	19 cb                	sbb    %ecx,%ebx
  8036e3:	89 d8                	mov    %ebx,%eax
  8036e5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8036e9:	d3 e0                	shl    %cl,%eax
  8036eb:	89 e9                	mov    %ebp,%ecx
  8036ed:	d3 ea                	shr    %cl,%edx
  8036ef:	09 d0                	or     %edx,%eax
  8036f1:	89 e9                	mov    %ebp,%ecx
  8036f3:	d3 eb                	shr    %cl,%ebx
  8036f5:	89 da                	mov    %ebx,%edx
  8036f7:	83 c4 1c             	add    $0x1c,%esp
  8036fa:	5b                   	pop    %ebx
  8036fb:	5e                   	pop    %esi
  8036fc:	5f                   	pop    %edi
  8036fd:	5d                   	pop    %ebp
  8036fe:	c3                   	ret    
  8036ff:	90                   	nop
  803700:	89 fd                	mov    %edi,%ebp
  803702:	85 ff                	test   %edi,%edi
  803704:	75 0b                	jne    803711 <__umoddi3+0xe9>
  803706:	b8 01 00 00 00       	mov    $0x1,%eax
  80370b:	31 d2                	xor    %edx,%edx
  80370d:	f7 f7                	div    %edi
  80370f:	89 c5                	mov    %eax,%ebp
  803711:	89 f0                	mov    %esi,%eax
  803713:	31 d2                	xor    %edx,%edx
  803715:	f7 f5                	div    %ebp
  803717:	89 c8                	mov    %ecx,%eax
  803719:	f7 f5                	div    %ebp
  80371b:	89 d0                	mov    %edx,%eax
  80371d:	e9 44 ff ff ff       	jmp    803666 <__umoddi3+0x3e>
  803722:	66 90                	xchg   %ax,%ax
  803724:	89 c8                	mov    %ecx,%eax
  803726:	89 f2                	mov    %esi,%edx
  803728:	83 c4 1c             	add    $0x1c,%esp
  80372b:	5b                   	pop    %ebx
  80372c:	5e                   	pop    %esi
  80372d:	5f                   	pop    %edi
  80372e:	5d                   	pop    %ebp
  80372f:	c3                   	ret    
  803730:	3b 04 24             	cmp    (%esp),%eax
  803733:	72 06                	jb     80373b <__umoddi3+0x113>
  803735:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803739:	77 0f                	ja     80374a <__umoddi3+0x122>
  80373b:	89 f2                	mov    %esi,%edx
  80373d:	29 f9                	sub    %edi,%ecx
  80373f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803743:	89 14 24             	mov    %edx,(%esp)
  803746:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80374a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80374e:	8b 14 24             	mov    (%esp),%edx
  803751:	83 c4 1c             	add    $0x1c,%esp
  803754:	5b                   	pop    %ebx
  803755:	5e                   	pop    %esi
  803756:	5f                   	pop    %edi
  803757:	5d                   	pop    %ebp
  803758:	c3                   	ret    
  803759:	8d 76 00             	lea    0x0(%esi),%esi
  80375c:	2b 04 24             	sub    (%esp),%eax
  80375f:	19 fa                	sbb    %edi,%edx
  803761:	89 d1                	mov    %edx,%ecx
  803763:	89 c6                	mov    %eax,%esi
  803765:	e9 71 ff ff ff       	jmp    8036db <__umoddi3+0xb3>
  80376a:	66 90                	xchg   %ax,%ax
  80376c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803770:	72 ea                	jb     80375c <__umoddi3+0x134>
  803772:	89 d9                	mov    %ebx,%ecx
  803774:	e9 62 ff ff ff       	jmp    8036db <__umoddi3+0xb3>
