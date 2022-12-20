
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
  80003e:	e8 8f 1b 00 00       	call   801bd2 <sys_getenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int32 parentenvID = sys_getparentenvid();
  800046:	e8 b9 1b 00 00       	call   801c04 <sys_getparentenvid>
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
  80005f:	68 20 39 80 00       	push   $0x803920
  800064:	ff 75 ec             	pushl  -0x14(%ebp)
  800067:	e8 7b 16 00 00       	call   8016e7 <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	numOfElements = sget(parentenvID,"arrSize") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 24 39 80 00       	push   $0x803924
  80007a:	ff 75 ec             	pushl  -0x14(%ebp)
  80007d:	e8 65 16 00 00       	call   8016e7 <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//Get the check-finishing counter
	int *finishedCount = NULL;
  800088:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	finishedCount = sget(parentenvID,"finishedCount") ;
  80008f:	83 ec 08             	sub    $0x8,%esp
  800092:	68 2c 39 80 00       	push   $0x80392c
  800097:	ff 75 ec             	pushl  -0x14(%ebp)
  80009a:	e8 48 16 00 00       	call   8016e7 <sget>
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
  8000b3:	68 3a 39 80 00       	push   $0x80393a
  8000b8:	e8 7c 15 00 00       	call   801639 <smalloc>
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
  800112:	68 49 39 80 00       	push   $0x803949
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
  800166:	e8 cc 1a 00 00       	call   801c37 <sys_get_virtual_time>
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
  8002f6:	68 65 39 80 00       	push   $0x803965
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
  800318:	68 67 39 80 00       	push   $0x803967
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
  800346:	68 6c 39 80 00       	push   $0x80396c
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
  80035c:	e8 8a 18 00 00       	call   801beb <sys_getenvindex>
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
  8003c7:	e8 2c 16 00 00       	call   8019f8 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8003cc:	83 ec 0c             	sub    $0xc,%esp
  8003cf:	68 88 39 80 00       	push   $0x803988
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
  8003f7:	68 b0 39 80 00       	push   $0x8039b0
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
  800428:	68 d8 39 80 00       	push   $0x8039d8
  80042d:	e8 34 01 00 00       	call   800566 <cprintf>
  800432:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800435:	a1 20 50 80 00       	mov    0x805020,%eax
  80043a:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800440:	83 ec 08             	sub    $0x8,%esp
  800443:	50                   	push   %eax
  800444:	68 30 3a 80 00       	push   $0x803a30
  800449:	e8 18 01 00 00       	call   800566 <cprintf>
  80044e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800451:	83 ec 0c             	sub    $0xc,%esp
  800454:	68 88 39 80 00       	push   $0x803988
  800459:	e8 08 01 00 00       	call   800566 <cprintf>
  80045e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800461:	e8 ac 15 00 00       	call   801a12 <sys_enable_interrupt>

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
  800479:	e8 39 17 00 00       	call   801bb7 <sys_destroy_env>
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
  80048a:	e8 8e 17 00 00       	call   801c1d <sys_exit_env>
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
  8004d8:	e8 6d 13 00 00       	call   80184a <sys_cputs>
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
  80054f:	e8 f6 12 00 00       	call   80184a <sys_cputs>
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
  800599:	e8 5a 14 00 00       	call   8019f8 <sys_disable_interrupt>
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
  8005b9:	e8 54 14 00 00       	call   801a12 <sys_enable_interrupt>
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
  800603:	e8 a8 30 00 00       	call   8036b0 <__udivdi3>
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
  800653:	e8 68 31 00 00       	call   8037c0 <__umoddi3>
  800658:	83 c4 10             	add    $0x10,%esp
  80065b:	05 74 3c 80 00       	add    $0x803c74,%eax
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
  8007ae:	8b 04 85 98 3c 80 00 	mov    0x803c98(,%eax,4),%eax
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
  80088f:	8b 34 9d e0 3a 80 00 	mov    0x803ae0(,%ebx,4),%esi
  800896:	85 f6                	test   %esi,%esi
  800898:	75 19                	jne    8008b3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80089a:	53                   	push   %ebx
  80089b:	68 85 3c 80 00       	push   $0x803c85
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
  8008b4:	68 8e 3c 80 00       	push   $0x803c8e
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
  8008e1:	be 91 3c 80 00       	mov    $0x803c91,%esi
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
  801307:	68 f0 3d 80 00       	push   $0x803df0
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
  8013d7:	e8 b2 05 00 00       	call   80198e <sys_allocate_chunk>
  8013dc:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013df:	a1 20 51 80 00       	mov    0x805120,%eax
  8013e4:	83 ec 0c             	sub    $0xc,%esp
  8013e7:	50                   	push   %eax
  8013e8:	e8 27 0c 00 00       	call   802014 <initialize_MemBlocksList>
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
  801415:	68 15 3e 80 00       	push   $0x803e15
  80141a:	6a 33                	push   $0x33
  80141c:	68 33 3e 80 00       	push   $0x803e33
  801421:	e8 a7 20 00 00       	call   8034cd <_panic>
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
  801494:	68 40 3e 80 00       	push   $0x803e40
  801499:	6a 34                	push   $0x34
  80149b:	68 33 3e 80 00       	push   $0x803e33
  8014a0:	e8 28 20 00 00       	call   8034cd <_panic>
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
  8014f1:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014f4:	e8 f7 fd ff ff       	call   8012f0 <InitializeUHeap>
	if (size == 0) return NULL ;
  8014f9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014fd:	75 07                	jne    801506 <malloc+0x18>
  8014ff:	b8 00 00 00 00       	mov    $0x0,%eax
  801504:	eb 61                	jmp    801567 <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  801506:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80150d:	8b 55 08             	mov    0x8(%ebp),%edx
  801510:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801513:	01 d0                	add    %edx,%eax
  801515:	48                   	dec    %eax
  801516:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801519:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80151c:	ba 00 00 00 00       	mov    $0x0,%edx
  801521:	f7 75 f0             	divl   -0x10(%ebp)
  801524:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801527:	29 d0                	sub    %edx,%eax
  801529:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80152c:	e8 2b 08 00 00       	call   801d5c <sys_isUHeapPlacementStrategyFIRSTFIT>
  801531:	85 c0                	test   %eax,%eax
  801533:	74 11                	je     801546 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801535:	83 ec 0c             	sub    $0xc,%esp
  801538:	ff 75 e8             	pushl  -0x18(%ebp)
  80153b:	e8 96 0e 00 00       	call   8023d6 <alloc_block_FF>
  801540:	83 c4 10             	add    $0x10,%esp
  801543:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  801546:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80154a:	74 16                	je     801562 <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  80154c:	83 ec 0c             	sub    $0xc,%esp
  80154f:	ff 75 f4             	pushl  -0xc(%ebp)
  801552:	e8 f2 0b 00 00       	call   802149 <insert_sorted_allocList>
  801557:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  80155a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80155d:	8b 40 08             	mov    0x8(%eax),%eax
  801560:	eb 05                	jmp    801567 <malloc+0x79>
	}

    return NULL;
  801562:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801567:	c9                   	leave  
  801568:	c3                   	ret    

00801569 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801569:	55                   	push   %ebp
  80156a:	89 e5                	mov    %esp,%ebp
  80156c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  80156f:	8b 45 08             	mov    0x8(%ebp),%eax
  801572:	83 ec 08             	sub    $0x8,%esp
  801575:	50                   	push   %eax
  801576:	68 40 50 80 00       	push   $0x805040
  80157b:	e8 71 0b 00 00       	call   8020f1 <find_block>
  801580:	83 c4 10             	add    $0x10,%esp
  801583:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(free_block!=NULL)
  801586:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80158a:	0f 84 a6 00 00 00    	je     801636 <free+0xcd>
	{
		sys_free_user_mem(free_block->sva,free_block->size);
  801590:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801593:	8b 50 0c             	mov    0xc(%eax),%edx
  801596:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801599:	8b 40 08             	mov    0x8(%eax),%eax
  80159c:	83 ec 08             	sub    $0x8,%esp
  80159f:	52                   	push   %edx
  8015a0:	50                   	push   %eax
  8015a1:	e8 b0 03 00 00       	call   801956 <sys_free_user_mem>
  8015a6:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,free_block);
  8015a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015ad:	75 14                	jne    8015c3 <free+0x5a>
  8015af:	83 ec 04             	sub    $0x4,%esp
  8015b2:	68 15 3e 80 00       	push   $0x803e15
  8015b7:	6a 74                	push   $0x74
  8015b9:	68 33 3e 80 00       	push   $0x803e33
  8015be:	e8 0a 1f 00 00       	call   8034cd <_panic>
  8015c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c6:	8b 00                	mov    (%eax),%eax
  8015c8:	85 c0                	test   %eax,%eax
  8015ca:	74 10                	je     8015dc <free+0x73>
  8015cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015cf:	8b 00                	mov    (%eax),%eax
  8015d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015d4:	8b 52 04             	mov    0x4(%edx),%edx
  8015d7:	89 50 04             	mov    %edx,0x4(%eax)
  8015da:	eb 0b                	jmp    8015e7 <free+0x7e>
  8015dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015df:	8b 40 04             	mov    0x4(%eax),%eax
  8015e2:	a3 44 50 80 00       	mov    %eax,0x805044
  8015e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ea:	8b 40 04             	mov    0x4(%eax),%eax
  8015ed:	85 c0                	test   %eax,%eax
  8015ef:	74 0f                	je     801600 <free+0x97>
  8015f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f4:	8b 40 04             	mov    0x4(%eax),%eax
  8015f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015fa:	8b 12                	mov    (%edx),%edx
  8015fc:	89 10                	mov    %edx,(%eax)
  8015fe:	eb 0a                	jmp    80160a <free+0xa1>
  801600:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801603:	8b 00                	mov    (%eax),%eax
  801605:	a3 40 50 80 00       	mov    %eax,0x805040
  80160a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80160d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801613:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801616:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80161d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801622:	48                   	dec    %eax
  801623:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(free_block);
  801628:	83 ec 0c             	sub    $0xc,%esp
  80162b:	ff 75 f4             	pushl  -0xc(%ebp)
  80162e:	e8 4e 17 00 00       	call   802d81 <insert_sorted_with_merge_freeList>
  801633:	83 c4 10             	add    $0x10,%esp
	}

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801636:	90                   	nop
  801637:	c9                   	leave  
  801638:	c3                   	ret    

00801639 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801639:	55                   	push   %ebp
  80163a:	89 e5                	mov    %esp,%ebp
  80163c:	83 ec 38             	sub    $0x38,%esp
  80163f:	8b 45 10             	mov    0x10(%ebp),%eax
  801642:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801645:	e8 a6 fc ff ff       	call   8012f0 <InitializeUHeap>
	if (size == 0) return NULL ;
  80164a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80164e:	75 0a                	jne    80165a <smalloc+0x21>
  801650:	b8 00 00 00 00       	mov    $0x0,%eax
  801655:	e9 8b 00 00 00       	jmp    8016e5 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80165a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801661:	8b 55 0c             	mov    0xc(%ebp),%edx
  801664:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801667:	01 d0                	add    %edx,%eax
  801669:	48                   	dec    %eax
  80166a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80166d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801670:	ba 00 00 00 00       	mov    $0x0,%edx
  801675:	f7 75 f0             	divl   -0x10(%ebp)
  801678:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80167b:	29 d0                	sub    %edx,%eax
  80167d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801680:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801687:	e8 d0 06 00 00       	call   801d5c <sys_isUHeapPlacementStrategyFIRSTFIT>
  80168c:	85 c0                	test   %eax,%eax
  80168e:	74 11                	je     8016a1 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801690:	83 ec 0c             	sub    $0xc,%esp
  801693:	ff 75 e8             	pushl  -0x18(%ebp)
  801696:	e8 3b 0d 00 00       	call   8023d6 <alloc_block_FF>
  80169b:	83 c4 10             	add    $0x10,%esp
  80169e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  8016a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016a5:	74 39                	je     8016e0 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8016a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016aa:	8b 40 08             	mov    0x8(%eax),%eax
  8016ad:	89 c2                	mov    %eax,%edx
  8016af:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8016b3:	52                   	push   %edx
  8016b4:	50                   	push   %eax
  8016b5:	ff 75 0c             	pushl  0xc(%ebp)
  8016b8:	ff 75 08             	pushl  0x8(%ebp)
  8016bb:	e8 21 04 00 00       	call   801ae1 <sys_createSharedObject>
  8016c0:	83 c4 10             	add    $0x10,%esp
  8016c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  8016c6:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8016ca:	74 14                	je     8016e0 <smalloc+0xa7>
  8016cc:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8016d0:	74 0e                	je     8016e0 <smalloc+0xa7>
  8016d2:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  8016d6:	74 08                	je     8016e0 <smalloc+0xa7>
			return (void*) mem_block->sva;
  8016d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016db:	8b 40 08             	mov    0x8(%eax),%eax
  8016de:	eb 05                	jmp    8016e5 <smalloc+0xac>
	}
	return NULL;
  8016e0:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8016e5:	c9                   	leave  
  8016e6:	c3                   	ret    

008016e7 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016e7:	55                   	push   %ebp
  8016e8:	89 e5                	mov    %esp,%ebp
  8016ea:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016ed:	e8 fe fb ff ff       	call   8012f0 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8016f2:	83 ec 08             	sub    $0x8,%esp
  8016f5:	ff 75 0c             	pushl  0xc(%ebp)
  8016f8:	ff 75 08             	pushl  0x8(%ebp)
  8016fb:	e8 0b 04 00 00       	call   801b0b <sys_getSizeOfSharedObject>
  801700:	83 c4 10             	add    $0x10,%esp
  801703:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  801706:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  80170a:	74 76                	je     801782 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80170c:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801713:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801716:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801719:	01 d0                	add    %edx,%eax
  80171b:	48                   	dec    %eax
  80171c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80171f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801722:	ba 00 00 00 00       	mov    $0x0,%edx
  801727:	f7 75 ec             	divl   -0x14(%ebp)
  80172a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80172d:	29 d0                	sub    %edx,%eax
  80172f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801732:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801739:	e8 1e 06 00 00       	call   801d5c <sys_isUHeapPlacementStrategyFIRSTFIT>
  80173e:	85 c0                	test   %eax,%eax
  801740:	74 11                	je     801753 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801742:	83 ec 0c             	sub    $0xc,%esp
  801745:	ff 75 e4             	pushl  -0x1c(%ebp)
  801748:	e8 89 0c 00 00       	call   8023d6 <alloc_block_FF>
  80174d:	83 c4 10             	add    $0x10,%esp
  801750:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  801753:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801757:	74 29                	je     801782 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801759:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80175c:	8b 40 08             	mov    0x8(%eax),%eax
  80175f:	83 ec 04             	sub    $0x4,%esp
  801762:	50                   	push   %eax
  801763:	ff 75 0c             	pushl  0xc(%ebp)
  801766:	ff 75 08             	pushl  0x8(%ebp)
  801769:	e8 ba 03 00 00       	call   801b28 <sys_getSharedObject>
  80176e:	83 c4 10             	add    $0x10,%esp
  801771:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  801774:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  801778:	74 08                	je     801782 <sget+0x9b>
				return (void *)mem_block->sva;
  80177a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80177d:	8b 40 08             	mov    0x8(%eax),%eax
  801780:	eb 05                	jmp    801787 <sget+0xa0>
		}
	}
	return NULL;
  801782:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801787:	c9                   	leave  
  801788:	c3                   	ret    

00801789 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801789:	55                   	push   %ebp
  80178a:	89 e5                	mov    %esp,%ebp
  80178c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80178f:	e8 5c fb ff ff       	call   8012f0 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801794:	83 ec 04             	sub    $0x4,%esp
  801797:	68 64 3e 80 00       	push   $0x803e64
  80179c:	68 f7 00 00 00       	push   $0xf7
  8017a1:	68 33 3e 80 00       	push   $0x803e33
  8017a6:	e8 22 1d 00 00       	call   8034cd <_panic>

008017ab <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8017ab:	55                   	push   %ebp
  8017ac:	89 e5                	mov    %esp,%ebp
  8017ae:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()


	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8017b1:	83 ec 04             	sub    $0x4,%esp
  8017b4:	68 8c 3e 80 00       	push   $0x803e8c
  8017b9:	68 0c 01 00 00       	push   $0x10c
  8017be:	68 33 3e 80 00       	push   $0x803e33
  8017c3:	e8 05 1d 00 00       	call   8034cd <_panic>

008017c8 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8017c8:	55                   	push   %ebp
  8017c9:	89 e5                	mov    %esp,%ebp
  8017cb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017ce:	83 ec 04             	sub    $0x4,%esp
  8017d1:	68 b0 3e 80 00       	push   $0x803eb0
  8017d6:	68 44 01 00 00       	push   $0x144
  8017db:	68 33 3e 80 00       	push   $0x803e33
  8017e0:	e8 e8 1c 00 00       	call   8034cd <_panic>

008017e5 <shrink>:

}
void shrink(uint32 newSize)
{
  8017e5:	55                   	push   %ebp
  8017e6:	89 e5                	mov    %esp,%ebp
  8017e8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017eb:	83 ec 04             	sub    $0x4,%esp
  8017ee:	68 b0 3e 80 00       	push   $0x803eb0
  8017f3:	68 49 01 00 00       	push   $0x149
  8017f8:	68 33 3e 80 00       	push   $0x803e33
  8017fd:	e8 cb 1c 00 00       	call   8034cd <_panic>

00801802 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801802:	55                   	push   %ebp
  801803:	89 e5                	mov    %esp,%ebp
  801805:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801808:	83 ec 04             	sub    $0x4,%esp
  80180b:	68 b0 3e 80 00       	push   $0x803eb0
  801810:	68 4e 01 00 00       	push   $0x14e
  801815:	68 33 3e 80 00       	push   $0x803e33
  80181a:	e8 ae 1c 00 00       	call   8034cd <_panic>

0080181f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80181f:	55                   	push   %ebp
  801820:	89 e5                	mov    %esp,%ebp
  801822:	57                   	push   %edi
  801823:	56                   	push   %esi
  801824:	53                   	push   %ebx
  801825:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801828:	8b 45 08             	mov    0x8(%ebp),%eax
  80182b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80182e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801831:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801834:	8b 7d 18             	mov    0x18(%ebp),%edi
  801837:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80183a:	cd 30                	int    $0x30
  80183c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80183f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801842:	83 c4 10             	add    $0x10,%esp
  801845:	5b                   	pop    %ebx
  801846:	5e                   	pop    %esi
  801847:	5f                   	pop    %edi
  801848:	5d                   	pop    %ebp
  801849:	c3                   	ret    

0080184a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80184a:	55                   	push   %ebp
  80184b:	89 e5                	mov    %esp,%ebp
  80184d:	83 ec 04             	sub    $0x4,%esp
  801850:	8b 45 10             	mov    0x10(%ebp),%eax
  801853:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801856:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80185a:	8b 45 08             	mov    0x8(%ebp),%eax
  80185d:	6a 00                	push   $0x0
  80185f:	6a 00                	push   $0x0
  801861:	52                   	push   %edx
  801862:	ff 75 0c             	pushl  0xc(%ebp)
  801865:	50                   	push   %eax
  801866:	6a 00                	push   $0x0
  801868:	e8 b2 ff ff ff       	call   80181f <syscall>
  80186d:	83 c4 18             	add    $0x18,%esp
}
  801870:	90                   	nop
  801871:	c9                   	leave  
  801872:	c3                   	ret    

00801873 <sys_cgetc>:

int
sys_cgetc(void)
{
  801873:	55                   	push   %ebp
  801874:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801876:	6a 00                	push   $0x0
  801878:	6a 00                	push   $0x0
  80187a:	6a 00                	push   $0x0
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	6a 01                	push   $0x1
  801882:	e8 98 ff ff ff       	call   80181f <syscall>
  801887:	83 c4 18             	add    $0x18,%esp
}
  80188a:	c9                   	leave  
  80188b:	c3                   	ret    

0080188c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80188c:	55                   	push   %ebp
  80188d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80188f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801892:	8b 45 08             	mov    0x8(%ebp),%eax
  801895:	6a 00                	push   $0x0
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	52                   	push   %edx
  80189c:	50                   	push   %eax
  80189d:	6a 05                	push   $0x5
  80189f:	e8 7b ff ff ff       	call   80181f <syscall>
  8018a4:	83 c4 18             	add    $0x18,%esp
}
  8018a7:	c9                   	leave  
  8018a8:	c3                   	ret    

008018a9 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018a9:	55                   	push   %ebp
  8018aa:	89 e5                	mov    %esp,%ebp
  8018ac:	56                   	push   %esi
  8018ad:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018ae:	8b 75 18             	mov    0x18(%ebp),%esi
  8018b1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018b4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bd:	56                   	push   %esi
  8018be:	53                   	push   %ebx
  8018bf:	51                   	push   %ecx
  8018c0:	52                   	push   %edx
  8018c1:	50                   	push   %eax
  8018c2:	6a 06                	push   $0x6
  8018c4:	e8 56 ff ff ff       	call   80181f <syscall>
  8018c9:	83 c4 18             	add    $0x18,%esp
}
  8018cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018cf:	5b                   	pop    %ebx
  8018d0:	5e                   	pop    %esi
  8018d1:	5d                   	pop    %ebp
  8018d2:	c3                   	ret    

008018d3 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018d3:	55                   	push   %ebp
  8018d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	52                   	push   %edx
  8018e3:	50                   	push   %eax
  8018e4:	6a 07                	push   $0x7
  8018e6:	e8 34 ff ff ff       	call   80181f <syscall>
  8018eb:	83 c4 18             	add    $0x18,%esp
}
  8018ee:	c9                   	leave  
  8018ef:	c3                   	ret    

008018f0 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	ff 75 0c             	pushl  0xc(%ebp)
  8018fc:	ff 75 08             	pushl  0x8(%ebp)
  8018ff:	6a 08                	push   $0x8
  801901:	e8 19 ff ff ff       	call   80181f <syscall>
  801906:	83 c4 18             	add    $0x18,%esp
}
  801909:	c9                   	leave  
  80190a:	c3                   	ret    

0080190b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80190b:	55                   	push   %ebp
  80190c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 09                	push   $0x9
  80191a:	e8 00 ff ff ff       	call   80181f <syscall>
  80191f:	83 c4 18             	add    $0x18,%esp
}
  801922:	c9                   	leave  
  801923:	c3                   	ret    

00801924 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801924:	55                   	push   %ebp
  801925:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 0a                	push   $0xa
  801933:	e8 e7 fe ff ff       	call   80181f <syscall>
  801938:	83 c4 18             	add    $0x18,%esp
}
  80193b:	c9                   	leave  
  80193c:	c3                   	ret    

0080193d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80193d:	55                   	push   %ebp
  80193e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801940:	6a 00                	push   $0x0
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	6a 00                	push   $0x0
  80194a:	6a 0b                	push   $0xb
  80194c:	e8 ce fe ff ff       	call   80181f <syscall>
  801951:	83 c4 18             	add    $0x18,%esp
}
  801954:	c9                   	leave  
  801955:	c3                   	ret    

00801956 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801956:	55                   	push   %ebp
  801957:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	ff 75 0c             	pushl  0xc(%ebp)
  801962:	ff 75 08             	pushl  0x8(%ebp)
  801965:	6a 0f                	push   $0xf
  801967:	e8 b3 fe ff ff       	call   80181f <syscall>
  80196c:	83 c4 18             	add    $0x18,%esp
	return;
  80196f:	90                   	nop
}
  801970:	c9                   	leave  
  801971:	c3                   	ret    

00801972 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801972:	55                   	push   %ebp
  801973:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	ff 75 0c             	pushl  0xc(%ebp)
  80197e:	ff 75 08             	pushl  0x8(%ebp)
  801981:	6a 10                	push   $0x10
  801983:	e8 97 fe ff ff       	call   80181f <syscall>
  801988:	83 c4 18             	add    $0x18,%esp
	return ;
  80198b:	90                   	nop
}
  80198c:	c9                   	leave  
  80198d:	c3                   	ret    

0080198e <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80198e:	55                   	push   %ebp
  80198f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801991:	6a 00                	push   $0x0
  801993:	6a 00                	push   $0x0
  801995:	ff 75 10             	pushl  0x10(%ebp)
  801998:	ff 75 0c             	pushl  0xc(%ebp)
  80199b:	ff 75 08             	pushl  0x8(%ebp)
  80199e:	6a 11                	push   $0x11
  8019a0:	e8 7a fe ff ff       	call   80181f <syscall>
  8019a5:	83 c4 18             	add    $0x18,%esp
	return ;
  8019a8:	90                   	nop
}
  8019a9:	c9                   	leave  
  8019aa:	c3                   	ret    

008019ab <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019ab:	55                   	push   %ebp
  8019ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 0c                	push   $0xc
  8019ba:	e8 60 fe ff ff       	call   80181f <syscall>
  8019bf:	83 c4 18             	add    $0x18,%esp
}
  8019c2:	c9                   	leave  
  8019c3:	c3                   	ret    

008019c4 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019c4:	55                   	push   %ebp
  8019c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	ff 75 08             	pushl  0x8(%ebp)
  8019d2:	6a 0d                	push   $0xd
  8019d4:	e8 46 fe ff ff       	call   80181f <syscall>
  8019d9:	83 c4 18             	add    $0x18,%esp
}
  8019dc:	c9                   	leave  
  8019dd:	c3                   	ret    

008019de <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019de:	55                   	push   %ebp
  8019df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 0e                	push   $0xe
  8019ed:	e8 2d fe ff ff       	call   80181f <syscall>
  8019f2:	83 c4 18             	add    $0x18,%esp
}
  8019f5:	90                   	nop
  8019f6:	c9                   	leave  
  8019f7:	c3                   	ret    

008019f8 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019f8:	55                   	push   %ebp
  8019f9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 13                	push   $0x13
  801a07:	e8 13 fe ff ff       	call   80181f <syscall>
  801a0c:	83 c4 18             	add    $0x18,%esp
}
  801a0f:	90                   	nop
  801a10:	c9                   	leave  
  801a11:	c3                   	ret    

00801a12 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a12:	55                   	push   %ebp
  801a13:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 14                	push   $0x14
  801a21:	e8 f9 fd ff ff       	call   80181f <syscall>
  801a26:	83 c4 18             	add    $0x18,%esp
}
  801a29:	90                   	nop
  801a2a:	c9                   	leave  
  801a2b:	c3                   	ret    

00801a2c <sys_cputc>:


void
sys_cputc(const char c)
{
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
  801a2f:	83 ec 04             	sub    $0x4,%esp
  801a32:	8b 45 08             	mov    0x8(%ebp),%eax
  801a35:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a38:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	50                   	push   %eax
  801a45:	6a 15                	push   $0x15
  801a47:	e8 d3 fd ff ff       	call   80181f <syscall>
  801a4c:	83 c4 18             	add    $0x18,%esp
}
  801a4f:	90                   	nop
  801a50:	c9                   	leave  
  801a51:	c3                   	ret    

00801a52 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a52:	55                   	push   %ebp
  801a53:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 16                	push   $0x16
  801a61:	e8 b9 fd ff ff       	call   80181f <syscall>
  801a66:	83 c4 18             	add    $0x18,%esp
}
  801a69:	90                   	nop
  801a6a:	c9                   	leave  
  801a6b:	c3                   	ret    

00801a6c <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a6c:	55                   	push   %ebp
  801a6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	ff 75 0c             	pushl  0xc(%ebp)
  801a7b:	50                   	push   %eax
  801a7c:	6a 17                	push   $0x17
  801a7e:	e8 9c fd ff ff       	call   80181f <syscall>
  801a83:	83 c4 18             	add    $0x18,%esp
}
  801a86:	c9                   	leave  
  801a87:	c3                   	ret    

00801a88 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a88:	55                   	push   %ebp
  801a89:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	52                   	push   %edx
  801a98:	50                   	push   %eax
  801a99:	6a 1a                	push   $0x1a
  801a9b:	e8 7f fd ff ff       	call   80181f <syscall>
  801aa0:	83 c4 18             	add    $0x18,%esp
}
  801aa3:	c9                   	leave  
  801aa4:	c3                   	ret    

00801aa5 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801aa5:	55                   	push   %ebp
  801aa6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801aa8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aab:	8b 45 08             	mov    0x8(%ebp),%eax
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	52                   	push   %edx
  801ab5:	50                   	push   %eax
  801ab6:	6a 18                	push   $0x18
  801ab8:	e8 62 fd ff ff       	call   80181f <syscall>
  801abd:	83 c4 18             	add    $0x18,%esp
}
  801ac0:	90                   	nop
  801ac1:	c9                   	leave  
  801ac2:	c3                   	ret    

00801ac3 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ac3:	55                   	push   %ebp
  801ac4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ac6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	52                   	push   %edx
  801ad3:	50                   	push   %eax
  801ad4:	6a 19                	push   $0x19
  801ad6:	e8 44 fd ff ff       	call   80181f <syscall>
  801adb:	83 c4 18             	add    $0x18,%esp
}
  801ade:	90                   	nop
  801adf:	c9                   	leave  
  801ae0:	c3                   	ret    

00801ae1 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ae1:	55                   	push   %ebp
  801ae2:	89 e5                	mov    %esp,%ebp
  801ae4:	83 ec 04             	sub    $0x4,%esp
  801ae7:	8b 45 10             	mov    0x10(%ebp),%eax
  801aea:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801aed:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801af0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801af4:	8b 45 08             	mov    0x8(%ebp),%eax
  801af7:	6a 00                	push   $0x0
  801af9:	51                   	push   %ecx
  801afa:	52                   	push   %edx
  801afb:	ff 75 0c             	pushl  0xc(%ebp)
  801afe:	50                   	push   %eax
  801aff:	6a 1b                	push   $0x1b
  801b01:	e8 19 fd ff ff       	call   80181f <syscall>
  801b06:	83 c4 18             	add    $0x18,%esp
}
  801b09:	c9                   	leave  
  801b0a:	c3                   	ret    

00801b0b <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b0b:	55                   	push   %ebp
  801b0c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b11:	8b 45 08             	mov    0x8(%ebp),%eax
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	52                   	push   %edx
  801b1b:	50                   	push   %eax
  801b1c:	6a 1c                	push   $0x1c
  801b1e:	e8 fc fc ff ff       	call   80181f <syscall>
  801b23:	83 c4 18             	add    $0x18,%esp
}
  801b26:	c9                   	leave  
  801b27:	c3                   	ret    

00801b28 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b28:	55                   	push   %ebp
  801b29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b2b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b31:	8b 45 08             	mov    0x8(%ebp),%eax
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	51                   	push   %ecx
  801b39:	52                   	push   %edx
  801b3a:	50                   	push   %eax
  801b3b:	6a 1d                	push   $0x1d
  801b3d:	e8 dd fc ff ff       	call   80181f <syscall>
  801b42:	83 c4 18             	add    $0x18,%esp
}
  801b45:	c9                   	leave  
  801b46:	c3                   	ret    

00801b47 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b47:	55                   	push   %ebp
  801b48:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	52                   	push   %edx
  801b57:	50                   	push   %eax
  801b58:	6a 1e                	push   $0x1e
  801b5a:	e8 c0 fc ff ff       	call   80181f <syscall>
  801b5f:	83 c4 18             	add    $0x18,%esp
}
  801b62:	c9                   	leave  
  801b63:	c3                   	ret    

00801b64 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b64:	55                   	push   %ebp
  801b65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 1f                	push   $0x1f
  801b73:	e8 a7 fc ff ff       	call   80181f <syscall>
  801b78:	83 c4 18             	add    $0x18,%esp
}
  801b7b:	c9                   	leave  
  801b7c:	c3                   	ret    

00801b7d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b7d:	55                   	push   %ebp
  801b7e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b80:	8b 45 08             	mov    0x8(%ebp),%eax
  801b83:	6a 00                	push   $0x0
  801b85:	ff 75 14             	pushl  0x14(%ebp)
  801b88:	ff 75 10             	pushl  0x10(%ebp)
  801b8b:	ff 75 0c             	pushl  0xc(%ebp)
  801b8e:	50                   	push   %eax
  801b8f:	6a 20                	push   $0x20
  801b91:	e8 89 fc ff ff       	call   80181f <syscall>
  801b96:	83 c4 18             	add    $0x18,%esp
}
  801b99:	c9                   	leave  
  801b9a:	c3                   	ret    

00801b9b <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b9b:	55                   	push   %ebp
  801b9c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	50                   	push   %eax
  801baa:	6a 21                	push   $0x21
  801bac:	e8 6e fc ff ff       	call   80181f <syscall>
  801bb1:	83 c4 18             	add    $0x18,%esp
}
  801bb4:	90                   	nop
  801bb5:	c9                   	leave  
  801bb6:	c3                   	ret    

00801bb7 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801bb7:	55                   	push   %ebp
  801bb8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bba:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	50                   	push   %eax
  801bc6:	6a 22                	push   $0x22
  801bc8:	e8 52 fc ff ff       	call   80181f <syscall>
  801bcd:	83 c4 18             	add    $0x18,%esp
}
  801bd0:	c9                   	leave  
  801bd1:	c3                   	ret    

00801bd2 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801bd2:	55                   	push   %ebp
  801bd3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 02                	push   $0x2
  801be1:	e8 39 fc ff ff       	call   80181f <syscall>
  801be6:	83 c4 18             	add    $0x18,%esp
}
  801be9:	c9                   	leave  
  801bea:	c3                   	ret    

00801beb <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801beb:	55                   	push   %ebp
  801bec:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 03                	push   $0x3
  801bfa:	e8 20 fc ff ff       	call   80181f <syscall>
  801bff:	83 c4 18             	add    $0x18,%esp
}
  801c02:	c9                   	leave  
  801c03:	c3                   	ret    

00801c04 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c04:	55                   	push   %ebp
  801c05:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 04                	push   $0x4
  801c13:	e8 07 fc ff ff       	call   80181f <syscall>
  801c18:	83 c4 18             	add    $0x18,%esp
}
  801c1b:	c9                   	leave  
  801c1c:	c3                   	ret    

00801c1d <sys_exit_env>:


void sys_exit_env(void)
{
  801c1d:	55                   	push   %ebp
  801c1e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 23                	push   $0x23
  801c2c:	e8 ee fb ff ff       	call   80181f <syscall>
  801c31:	83 c4 18             	add    $0x18,%esp
}
  801c34:	90                   	nop
  801c35:	c9                   	leave  
  801c36:	c3                   	ret    

00801c37 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c37:	55                   	push   %ebp
  801c38:	89 e5                	mov    %esp,%ebp
  801c3a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c3d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c40:	8d 50 04             	lea    0x4(%eax),%edx
  801c43:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	52                   	push   %edx
  801c4d:	50                   	push   %eax
  801c4e:	6a 24                	push   $0x24
  801c50:	e8 ca fb ff ff       	call   80181f <syscall>
  801c55:	83 c4 18             	add    $0x18,%esp
	return result;
  801c58:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c5b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c5e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c61:	89 01                	mov    %eax,(%ecx)
  801c63:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c66:	8b 45 08             	mov    0x8(%ebp),%eax
  801c69:	c9                   	leave  
  801c6a:	c2 04 00             	ret    $0x4

00801c6d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c6d:	55                   	push   %ebp
  801c6e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	ff 75 10             	pushl  0x10(%ebp)
  801c77:	ff 75 0c             	pushl  0xc(%ebp)
  801c7a:	ff 75 08             	pushl  0x8(%ebp)
  801c7d:	6a 12                	push   $0x12
  801c7f:	e8 9b fb ff ff       	call   80181f <syscall>
  801c84:	83 c4 18             	add    $0x18,%esp
	return ;
  801c87:	90                   	nop
}
  801c88:	c9                   	leave  
  801c89:	c3                   	ret    

00801c8a <sys_rcr2>:
uint32 sys_rcr2()
{
  801c8a:	55                   	push   %ebp
  801c8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 25                	push   $0x25
  801c99:	e8 81 fb ff ff       	call   80181f <syscall>
  801c9e:	83 c4 18             	add    $0x18,%esp
}
  801ca1:	c9                   	leave  
  801ca2:	c3                   	ret    

00801ca3 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ca3:	55                   	push   %ebp
  801ca4:	89 e5                	mov    %esp,%ebp
  801ca6:	83 ec 04             	sub    $0x4,%esp
  801ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cac:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801caf:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	50                   	push   %eax
  801cbc:	6a 26                	push   $0x26
  801cbe:	e8 5c fb ff ff       	call   80181f <syscall>
  801cc3:	83 c4 18             	add    $0x18,%esp
	return ;
  801cc6:	90                   	nop
}
  801cc7:	c9                   	leave  
  801cc8:	c3                   	ret    

00801cc9 <rsttst>:
void rsttst()
{
  801cc9:	55                   	push   %ebp
  801cca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ccc:	6a 00                	push   $0x0
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 28                	push   $0x28
  801cd8:	e8 42 fb ff ff       	call   80181f <syscall>
  801cdd:	83 c4 18             	add    $0x18,%esp
	return ;
  801ce0:	90                   	nop
}
  801ce1:	c9                   	leave  
  801ce2:	c3                   	ret    

00801ce3 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ce3:	55                   	push   %ebp
  801ce4:	89 e5                	mov    %esp,%ebp
  801ce6:	83 ec 04             	sub    $0x4,%esp
  801ce9:	8b 45 14             	mov    0x14(%ebp),%eax
  801cec:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801cef:	8b 55 18             	mov    0x18(%ebp),%edx
  801cf2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cf6:	52                   	push   %edx
  801cf7:	50                   	push   %eax
  801cf8:	ff 75 10             	pushl  0x10(%ebp)
  801cfb:	ff 75 0c             	pushl  0xc(%ebp)
  801cfe:	ff 75 08             	pushl  0x8(%ebp)
  801d01:	6a 27                	push   $0x27
  801d03:	e8 17 fb ff ff       	call   80181f <syscall>
  801d08:	83 c4 18             	add    $0x18,%esp
	return ;
  801d0b:	90                   	nop
}
  801d0c:	c9                   	leave  
  801d0d:	c3                   	ret    

00801d0e <chktst>:
void chktst(uint32 n)
{
  801d0e:	55                   	push   %ebp
  801d0f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	ff 75 08             	pushl  0x8(%ebp)
  801d1c:	6a 29                	push   $0x29
  801d1e:	e8 fc fa ff ff       	call   80181f <syscall>
  801d23:	83 c4 18             	add    $0x18,%esp
	return ;
  801d26:	90                   	nop
}
  801d27:	c9                   	leave  
  801d28:	c3                   	ret    

00801d29 <inctst>:

void inctst()
{
  801d29:	55                   	push   %ebp
  801d2a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	6a 2a                	push   $0x2a
  801d38:	e8 e2 fa ff ff       	call   80181f <syscall>
  801d3d:	83 c4 18             	add    $0x18,%esp
	return ;
  801d40:	90                   	nop
}
  801d41:	c9                   	leave  
  801d42:	c3                   	ret    

00801d43 <gettst>:
uint32 gettst()
{
  801d43:	55                   	push   %ebp
  801d44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 2b                	push   $0x2b
  801d52:	e8 c8 fa ff ff       	call   80181f <syscall>
  801d57:	83 c4 18             	add    $0x18,%esp
}
  801d5a:	c9                   	leave  
  801d5b:	c3                   	ret    

00801d5c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d5c:	55                   	push   %ebp
  801d5d:	89 e5                	mov    %esp,%ebp
  801d5f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 2c                	push   $0x2c
  801d6e:	e8 ac fa ff ff       	call   80181f <syscall>
  801d73:	83 c4 18             	add    $0x18,%esp
  801d76:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d79:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d7d:	75 07                	jne    801d86 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d7f:	b8 01 00 00 00       	mov    $0x1,%eax
  801d84:	eb 05                	jmp    801d8b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d86:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d8b:	c9                   	leave  
  801d8c:	c3                   	ret    

00801d8d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d8d:	55                   	push   %ebp
  801d8e:	89 e5                	mov    %esp,%ebp
  801d90:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	6a 00                	push   $0x0
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 2c                	push   $0x2c
  801d9f:	e8 7b fa ff ff       	call   80181f <syscall>
  801da4:	83 c4 18             	add    $0x18,%esp
  801da7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801daa:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801dae:	75 07                	jne    801db7 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801db0:	b8 01 00 00 00       	mov    $0x1,%eax
  801db5:	eb 05                	jmp    801dbc <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801db7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dbc:	c9                   	leave  
  801dbd:	c3                   	ret    

00801dbe <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801dbe:	55                   	push   %ebp
  801dbf:	89 e5                	mov    %esp,%ebp
  801dc1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dc4:	6a 00                	push   $0x0
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 2c                	push   $0x2c
  801dd0:	e8 4a fa ff ff       	call   80181f <syscall>
  801dd5:	83 c4 18             	add    $0x18,%esp
  801dd8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ddb:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ddf:	75 07                	jne    801de8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801de1:	b8 01 00 00 00       	mov    $0x1,%eax
  801de6:	eb 05                	jmp    801ded <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801de8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ded:	c9                   	leave  
  801dee:	c3                   	ret    

00801def <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801def:	55                   	push   %ebp
  801df0:	89 e5                	mov    %esp,%ebp
  801df2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 2c                	push   $0x2c
  801e01:	e8 19 fa ff ff       	call   80181f <syscall>
  801e06:	83 c4 18             	add    $0x18,%esp
  801e09:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e0c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e10:	75 07                	jne    801e19 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e12:	b8 01 00 00 00       	mov    $0x1,%eax
  801e17:	eb 05                	jmp    801e1e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e1e:	c9                   	leave  
  801e1f:	c3                   	ret    

00801e20 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e20:	55                   	push   %ebp
  801e21:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e23:	6a 00                	push   $0x0
  801e25:	6a 00                	push   $0x0
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	ff 75 08             	pushl  0x8(%ebp)
  801e2e:	6a 2d                	push   $0x2d
  801e30:	e8 ea f9 ff ff       	call   80181f <syscall>
  801e35:	83 c4 18             	add    $0x18,%esp
	return ;
  801e38:	90                   	nop
}
  801e39:	c9                   	leave  
  801e3a:	c3                   	ret    

00801e3b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e3b:	55                   	push   %ebp
  801e3c:	89 e5                	mov    %esp,%ebp
  801e3e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e3f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e42:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e45:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e48:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4b:	6a 00                	push   $0x0
  801e4d:	53                   	push   %ebx
  801e4e:	51                   	push   %ecx
  801e4f:	52                   	push   %edx
  801e50:	50                   	push   %eax
  801e51:	6a 2e                	push   $0x2e
  801e53:	e8 c7 f9 ff ff       	call   80181f <syscall>
  801e58:	83 c4 18             	add    $0x18,%esp
}
  801e5b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e5e:	c9                   	leave  
  801e5f:	c3                   	ret    

00801e60 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e60:	55                   	push   %ebp
  801e61:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e63:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e66:	8b 45 08             	mov    0x8(%ebp),%eax
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 00                	push   $0x0
  801e6f:	52                   	push   %edx
  801e70:	50                   	push   %eax
  801e71:	6a 2f                	push   $0x2f
  801e73:	e8 a7 f9 ff ff       	call   80181f <syscall>
  801e78:	83 c4 18             	add    $0x18,%esp
}
  801e7b:	c9                   	leave  
  801e7c:	c3                   	ret    

00801e7d <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e7d:	55                   	push   %ebp
  801e7e:	89 e5                	mov    %esp,%ebp
  801e80:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e83:	83 ec 0c             	sub    $0xc,%esp
  801e86:	68 c0 3e 80 00       	push   $0x803ec0
  801e8b:	e8 d6 e6 ff ff       	call   800566 <cprintf>
  801e90:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e93:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e9a:	83 ec 0c             	sub    $0xc,%esp
  801e9d:	68 ec 3e 80 00       	push   $0x803eec
  801ea2:	e8 bf e6 ff ff       	call   800566 <cprintf>
  801ea7:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801eaa:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801eae:	a1 38 51 80 00       	mov    0x805138,%eax
  801eb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801eb6:	eb 56                	jmp    801f0e <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801eb8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ebc:	74 1c                	je     801eda <print_mem_block_lists+0x5d>
  801ebe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec1:	8b 50 08             	mov    0x8(%eax),%edx
  801ec4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ec7:	8b 48 08             	mov    0x8(%eax),%ecx
  801eca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ecd:	8b 40 0c             	mov    0xc(%eax),%eax
  801ed0:	01 c8                	add    %ecx,%eax
  801ed2:	39 c2                	cmp    %eax,%edx
  801ed4:	73 04                	jae    801eda <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801ed6:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801eda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801edd:	8b 50 08             	mov    0x8(%eax),%edx
  801ee0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee3:	8b 40 0c             	mov    0xc(%eax),%eax
  801ee6:	01 c2                	add    %eax,%edx
  801ee8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eeb:	8b 40 08             	mov    0x8(%eax),%eax
  801eee:	83 ec 04             	sub    $0x4,%esp
  801ef1:	52                   	push   %edx
  801ef2:	50                   	push   %eax
  801ef3:	68 01 3f 80 00       	push   $0x803f01
  801ef8:	e8 69 e6 ff ff       	call   800566 <cprintf>
  801efd:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f03:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f06:	a1 40 51 80 00       	mov    0x805140,%eax
  801f0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f0e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f12:	74 07                	je     801f1b <print_mem_block_lists+0x9e>
  801f14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f17:	8b 00                	mov    (%eax),%eax
  801f19:	eb 05                	jmp    801f20 <print_mem_block_lists+0xa3>
  801f1b:	b8 00 00 00 00       	mov    $0x0,%eax
  801f20:	a3 40 51 80 00       	mov    %eax,0x805140
  801f25:	a1 40 51 80 00       	mov    0x805140,%eax
  801f2a:	85 c0                	test   %eax,%eax
  801f2c:	75 8a                	jne    801eb8 <print_mem_block_lists+0x3b>
  801f2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f32:	75 84                	jne    801eb8 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f34:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f38:	75 10                	jne    801f4a <print_mem_block_lists+0xcd>
  801f3a:	83 ec 0c             	sub    $0xc,%esp
  801f3d:	68 10 3f 80 00       	push   $0x803f10
  801f42:	e8 1f e6 ff ff       	call   800566 <cprintf>
  801f47:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f4a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f51:	83 ec 0c             	sub    $0xc,%esp
  801f54:	68 34 3f 80 00       	push   $0x803f34
  801f59:	e8 08 e6 ff ff       	call   800566 <cprintf>
  801f5e:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f61:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f65:	a1 40 50 80 00       	mov    0x805040,%eax
  801f6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f6d:	eb 56                	jmp    801fc5 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f6f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f73:	74 1c                	je     801f91 <print_mem_block_lists+0x114>
  801f75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f78:	8b 50 08             	mov    0x8(%eax),%edx
  801f7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f7e:	8b 48 08             	mov    0x8(%eax),%ecx
  801f81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f84:	8b 40 0c             	mov    0xc(%eax),%eax
  801f87:	01 c8                	add    %ecx,%eax
  801f89:	39 c2                	cmp    %eax,%edx
  801f8b:	73 04                	jae    801f91 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f8d:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f94:	8b 50 08             	mov    0x8(%eax),%edx
  801f97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9a:	8b 40 0c             	mov    0xc(%eax),%eax
  801f9d:	01 c2                	add    %eax,%edx
  801f9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa2:	8b 40 08             	mov    0x8(%eax),%eax
  801fa5:	83 ec 04             	sub    $0x4,%esp
  801fa8:	52                   	push   %edx
  801fa9:	50                   	push   %eax
  801faa:	68 01 3f 80 00       	push   $0x803f01
  801faf:	e8 b2 e5 ff ff       	call   800566 <cprintf>
  801fb4:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fbd:	a1 48 50 80 00       	mov    0x805048,%eax
  801fc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fc5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fc9:	74 07                	je     801fd2 <print_mem_block_lists+0x155>
  801fcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fce:	8b 00                	mov    (%eax),%eax
  801fd0:	eb 05                	jmp    801fd7 <print_mem_block_lists+0x15a>
  801fd2:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd7:	a3 48 50 80 00       	mov    %eax,0x805048
  801fdc:	a1 48 50 80 00       	mov    0x805048,%eax
  801fe1:	85 c0                	test   %eax,%eax
  801fe3:	75 8a                	jne    801f6f <print_mem_block_lists+0xf2>
  801fe5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fe9:	75 84                	jne    801f6f <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801feb:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fef:	75 10                	jne    802001 <print_mem_block_lists+0x184>
  801ff1:	83 ec 0c             	sub    $0xc,%esp
  801ff4:	68 4c 3f 80 00       	push   $0x803f4c
  801ff9:	e8 68 e5 ff ff       	call   800566 <cprintf>
  801ffe:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802001:	83 ec 0c             	sub    $0xc,%esp
  802004:	68 c0 3e 80 00       	push   $0x803ec0
  802009:	e8 58 e5 ff ff       	call   800566 <cprintf>
  80200e:	83 c4 10             	add    $0x10,%esp

}
  802011:	90                   	nop
  802012:	c9                   	leave  
  802013:	c3                   	ret    

00802014 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802014:	55                   	push   %ebp
  802015:	89 e5                	mov    %esp,%ebp
  802017:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  80201a:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802021:	00 00 00 
  802024:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80202b:	00 00 00 
  80202e:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802035:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802038:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80203f:	e9 9e 00 00 00       	jmp    8020e2 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802044:	a1 50 50 80 00       	mov    0x805050,%eax
  802049:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80204c:	c1 e2 04             	shl    $0x4,%edx
  80204f:	01 d0                	add    %edx,%eax
  802051:	85 c0                	test   %eax,%eax
  802053:	75 14                	jne    802069 <initialize_MemBlocksList+0x55>
  802055:	83 ec 04             	sub    $0x4,%esp
  802058:	68 74 3f 80 00       	push   $0x803f74
  80205d:	6a 46                	push   $0x46
  80205f:	68 97 3f 80 00       	push   $0x803f97
  802064:	e8 64 14 00 00       	call   8034cd <_panic>
  802069:	a1 50 50 80 00       	mov    0x805050,%eax
  80206e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802071:	c1 e2 04             	shl    $0x4,%edx
  802074:	01 d0                	add    %edx,%eax
  802076:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80207c:	89 10                	mov    %edx,(%eax)
  80207e:	8b 00                	mov    (%eax),%eax
  802080:	85 c0                	test   %eax,%eax
  802082:	74 18                	je     80209c <initialize_MemBlocksList+0x88>
  802084:	a1 48 51 80 00       	mov    0x805148,%eax
  802089:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80208f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802092:	c1 e1 04             	shl    $0x4,%ecx
  802095:	01 ca                	add    %ecx,%edx
  802097:	89 50 04             	mov    %edx,0x4(%eax)
  80209a:	eb 12                	jmp    8020ae <initialize_MemBlocksList+0x9a>
  80209c:	a1 50 50 80 00       	mov    0x805050,%eax
  8020a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020a4:	c1 e2 04             	shl    $0x4,%edx
  8020a7:	01 d0                	add    %edx,%eax
  8020a9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8020ae:	a1 50 50 80 00       	mov    0x805050,%eax
  8020b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020b6:	c1 e2 04             	shl    $0x4,%edx
  8020b9:	01 d0                	add    %edx,%eax
  8020bb:	a3 48 51 80 00       	mov    %eax,0x805148
  8020c0:	a1 50 50 80 00       	mov    0x805050,%eax
  8020c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020c8:	c1 e2 04             	shl    $0x4,%edx
  8020cb:	01 d0                	add    %edx,%eax
  8020cd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020d4:	a1 54 51 80 00       	mov    0x805154,%eax
  8020d9:	40                   	inc    %eax
  8020da:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8020df:	ff 45 f4             	incl   -0xc(%ebp)
  8020e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020e8:	0f 82 56 ff ff ff    	jb     802044 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8020ee:	90                   	nop
  8020ef:	c9                   	leave  
  8020f0:	c3                   	ret    

008020f1 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8020f1:	55                   	push   %ebp
  8020f2:	89 e5                	mov    %esp,%ebp
  8020f4:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8020f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fa:	8b 00                	mov    (%eax),%eax
  8020fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020ff:	eb 19                	jmp    80211a <find_block+0x29>
	{
		if(va==point->sva)
  802101:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802104:	8b 40 08             	mov    0x8(%eax),%eax
  802107:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80210a:	75 05                	jne    802111 <find_block+0x20>
		   return point;
  80210c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80210f:	eb 36                	jmp    802147 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802111:	8b 45 08             	mov    0x8(%ebp),%eax
  802114:	8b 40 08             	mov    0x8(%eax),%eax
  802117:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80211a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80211e:	74 07                	je     802127 <find_block+0x36>
  802120:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802123:	8b 00                	mov    (%eax),%eax
  802125:	eb 05                	jmp    80212c <find_block+0x3b>
  802127:	b8 00 00 00 00       	mov    $0x0,%eax
  80212c:	8b 55 08             	mov    0x8(%ebp),%edx
  80212f:	89 42 08             	mov    %eax,0x8(%edx)
  802132:	8b 45 08             	mov    0x8(%ebp),%eax
  802135:	8b 40 08             	mov    0x8(%eax),%eax
  802138:	85 c0                	test   %eax,%eax
  80213a:	75 c5                	jne    802101 <find_block+0x10>
  80213c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802140:	75 bf                	jne    802101 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802142:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802147:	c9                   	leave  
  802148:	c3                   	ret    

00802149 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802149:	55                   	push   %ebp
  80214a:	89 e5                	mov    %esp,%ebp
  80214c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80214f:	a1 40 50 80 00       	mov    0x805040,%eax
  802154:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802157:	a1 44 50 80 00       	mov    0x805044,%eax
  80215c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80215f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802162:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802165:	74 24                	je     80218b <insert_sorted_allocList+0x42>
  802167:	8b 45 08             	mov    0x8(%ebp),%eax
  80216a:	8b 50 08             	mov    0x8(%eax),%edx
  80216d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802170:	8b 40 08             	mov    0x8(%eax),%eax
  802173:	39 c2                	cmp    %eax,%edx
  802175:	76 14                	jbe    80218b <insert_sorted_allocList+0x42>
  802177:	8b 45 08             	mov    0x8(%ebp),%eax
  80217a:	8b 50 08             	mov    0x8(%eax),%edx
  80217d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802180:	8b 40 08             	mov    0x8(%eax),%eax
  802183:	39 c2                	cmp    %eax,%edx
  802185:	0f 82 60 01 00 00    	jb     8022eb <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  80218b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80218f:	75 65                	jne    8021f6 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802191:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802195:	75 14                	jne    8021ab <insert_sorted_allocList+0x62>
  802197:	83 ec 04             	sub    $0x4,%esp
  80219a:	68 74 3f 80 00       	push   $0x803f74
  80219f:	6a 6b                	push   $0x6b
  8021a1:	68 97 3f 80 00       	push   $0x803f97
  8021a6:	e8 22 13 00 00       	call   8034cd <_panic>
  8021ab:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8021b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b4:	89 10                	mov    %edx,(%eax)
  8021b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b9:	8b 00                	mov    (%eax),%eax
  8021bb:	85 c0                	test   %eax,%eax
  8021bd:	74 0d                	je     8021cc <insert_sorted_allocList+0x83>
  8021bf:	a1 40 50 80 00       	mov    0x805040,%eax
  8021c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8021c7:	89 50 04             	mov    %edx,0x4(%eax)
  8021ca:	eb 08                	jmp    8021d4 <insert_sorted_allocList+0x8b>
  8021cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cf:	a3 44 50 80 00       	mov    %eax,0x805044
  8021d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d7:	a3 40 50 80 00       	mov    %eax,0x805040
  8021dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021e6:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021eb:	40                   	inc    %eax
  8021ec:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021f1:	e9 dc 01 00 00       	jmp    8023d2 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8021f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f9:	8b 50 08             	mov    0x8(%eax),%edx
  8021fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ff:	8b 40 08             	mov    0x8(%eax),%eax
  802202:	39 c2                	cmp    %eax,%edx
  802204:	77 6c                	ja     802272 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802206:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80220a:	74 06                	je     802212 <insert_sorted_allocList+0xc9>
  80220c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802210:	75 14                	jne    802226 <insert_sorted_allocList+0xdd>
  802212:	83 ec 04             	sub    $0x4,%esp
  802215:	68 b0 3f 80 00       	push   $0x803fb0
  80221a:	6a 6f                	push   $0x6f
  80221c:	68 97 3f 80 00       	push   $0x803f97
  802221:	e8 a7 12 00 00       	call   8034cd <_panic>
  802226:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802229:	8b 50 04             	mov    0x4(%eax),%edx
  80222c:	8b 45 08             	mov    0x8(%ebp),%eax
  80222f:	89 50 04             	mov    %edx,0x4(%eax)
  802232:	8b 45 08             	mov    0x8(%ebp),%eax
  802235:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802238:	89 10                	mov    %edx,(%eax)
  80223a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80223d:	8b 40 04             	mov    0x4(%eax),%eax
  802240:	85 c0                	test   %eax,%eax
  802242:	74 0d                	je     802251 <insert_sorted_allocList+0x108>
  802244:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802247:	8b 40 04             	mov    0x4(%eax),%eax
  80224a:	8b 55 08             	mov    0x8(%ebp),%edx
  80224d:	89 10                	mov    %edx,(%eax)
  80224f:	eb 08                	jmp    802259 <insert_sorted_allocList+0x110>
  802251:	8b 45 08             	mov    0x8(%ebp),%eax
  802254:	a3 40 50 80 00       	mov    %eax,0x805040
  802259:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80225c:	8b 55 08             	mov    0x8(%ebp),%edx
  80225f:	89 50 04             	mov    %edx,0x4(%eax)
  802262:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802267:	40                   	inc    %eax
  802268:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80226d:	e9 60 01 00 00       	jmp    8023d2 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802272:	8b 45 08             	mov    0x8(%ebp),%eax
  802275:	8b 50 08             	mov    0x8(%eax),%edx
  802278:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80227b:	8b 40 08             	mov    0x8(%eax),%eax
  80227e:	39 c2                	cmp    %eax,%edx
  802280:	0f 82 4c 01 00 00    	jb     8023d2 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802286:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80228a:	75 14                	jne    8022a0 <insert_sorted_allocList+0x157>
  80228c:	83 ec 04             	sub    $0x4,%esp
  80228f:	68 e8 3f 80 00       	push   $0x803fe8
  802294:	6a 73                	push   $0x73
  802296:	68 97 3f 80 00       	push   $0x803f97
  80229b:	e8 2d 12 00 00       	call   8034cd <_panic>
  8022a0:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8022a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a9:	89 50 04             	mov    %edx,0x4(%eax)
  8022ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8022af:	8b 40 04             	mov    0x4(%eax),%eax
  8022b2:	85 c0                	test   %eax,%eax
  8022b4:	74 0c                	je     8022c2 <insert_sorted_allocList+0x179>
  8022b6:	a1 44 50 80 00       	mov    0x805044,%eax
  8022bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8022be:	89 10                	mov    %edx,(%eax)
  8022c0:	eb 08                	jmp    8022ca <insert_sorted_allocList+0x181>
  8022c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c5:	a3 40 50 80 00       	mov    %eax,0x805040
  8022ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cd:	a3 44 50 80 00       	mov    %eax,0x805044
  8022d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022db:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022e0:	40                   	inc    %eax
  8022e1:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022e6:	e9 e7 00 00 00       	jmp    8023d2 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8022eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8022f1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8022f8:	a1 40 50 80 00       	mov    0x805040,%eax
  8022fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802300:	e9 9d 00 00 00       	jmp    8023a2 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802305:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802308:	8b 00                	mov    (%eax),%eax
  80230a:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80230d:	8b 45 08             	mov    0x8(%ebp),%eax
  802310:	8b 50 08             	mov    0x8(%eax),%edx
  802313:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802316:	8b 40 08             	mov    0x8(%eax),%eax
  802319:	39 c2                	cmp    %eax,%edx
  80231b:	76 7d                	jbe    80239a <insert_sorted_allocList+0x251>
  80231d:	8b 45 08             	mov    0x8(%ebp),%eax
  802320:	8b 50 08             	mov    0x8(%eax),%edx
  802323:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802326:	8b 40 08             	mov    0x8(%eax),%eax
  802329:	39 c2                	cmp    %eax,%edx
  80232b:	73 6d                	jae    80239a <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80232d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802331:	74 06                	je     802339 <insert_sorted_allocList+0x1f0>
  802333:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802337:	75 14                	jne    80234d <insert_sorted_allocList+0x204>
  802339:	83 ec 04             	sub    $0x4,%esp
  80233c:	68 0c 40 80 00       	push   $0x80400c
  802341:	6a 7f                	push   $0x7f
  802343:	68 97 3f 80 00       	push   $0x803f97
  802348:	e8 80 11 00 00       	call   8034cd <_panic>
  80234d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802350:	8b 10                	mov    (%eax),%edx
  802352:	8b 45 08             	mov    0x8(%ebp),%eax
  802355:	89 10                	mov    %edx,(%eax)
  802357:	8b 45 08             	mov    0x8(%ebp),%eax
  80235a:	8b 00                	mov    (%eax),%eax
  80235c:	85 c0                	test   %eax,%eax
  80235e:	74 0b                	je     80236b <insert_sorted_allocList+0x222>
  802360:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802363:	8b 00                	mov    (%eax),%eax
  802365:	8b 55 08             	mov    0x8(%ebp),%edx
  802368:	89 50 04             	mov    %edx,0x4(%eax)
  80236b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236e:	8b 55 08             	mov    0x8(%ebp),%edx
  802371:	89 10                	mov    %edx,(%eax)
  802373:	8b 45 08             	mov    0x8(%ebp),%eax
  802376:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802379:	89 50 04             	mov    %edx,0x4(%eax)
  80237c:	8b 45 08             	mov    0x8(%ebp),%eax
  80237f:	8b 00                	mov    (%eax),%eax
  802381:	85 c0                	test   %eax,%eax
  802383:	75 08                	jne    80238d <insert_sorted_allocList+0x244>
  802385:	8b 45 08             	mov    0x8(%ebp),%eax
  802388:	a3 44 50 80 00       	mov    %eax,0x805044
  80238d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802392:	40                   	inc    %eax
  802393:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802398:	eb 39                	jmp    8023d3 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80239a:	a1 48 50 80 00       	mov    0x805048,%eax
  80239f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023a6:	74 07                	je     8023af <insert_sorted_allocList+0x266>
  8023a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ab:	8b 00                	mov    (%eax),%eax
  8023ad:	eb 05                	jmp    8023b4 <insert_sorted_allocList+0x26b>
  8023af:	b8 00 00 00 00       	mov    $0x0,%eax
  8023b4:	a3 48 50 80 00       	mov    %eax,0x805048
  8023b9:	a1 48 50 80 00       	mov    0x805048,%eax
  8023be:	85 c0                	test   %eax,%eax
  8023c0:	0f 85 3f ff ff ff    	jne    802305 <insert_sorted_allocList+0x1bc>
  8023c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023ca:	0f 85 35 ff ff ff    	jne    802305 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8023d0:	eb 01                	jmp    8023d3 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8023d2:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8023d3:	90                   	nop
  8023d4:	c9                   	leave  
  8023d5:	c3                   	ret    

008023d6 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8023d6:	55                   	push   %ebp
  8023d7:	89 e5                	mov    %esp,%ebp
  8023d9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8023dc:	a1 38 51 80 00       	mov    0x805138,%eax
  8023e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023e4:	e9 85 01 00 00       	jmp    80256e <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8023e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8023ef:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023f2:	0f 82 6e 01 00 00    	jb     802566 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8023f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fb:	8b 40 0c             	mov    0xc(%eax),%eax
  8023fe:	3b 45 08             	cmp    0x8(%ebp),%eax
  802401:	0f 85 8a 00 00 00    	jne    802491 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802407:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80240b:	75 17                	jne    802424 <alloc_block_FF+0x4e>
  80240d:	83 ec 04             	sub    $0x4,%esp
  802410:	68 40 40 80 00       	push   $0x804040
  802415:	68 93 00 00 00       	push   $0x93
  80241a:	68 97 3f 80 00       	push   $0x803f97
  80241f:	e8 a9 10 00 00       	call   8034cd <_panic>
  802424:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802427:	8b 00                	mov    (%eax),%eax
  802429:	85 c0                	test   %eax,%eax
  80242b:	74 10                	je     80243d <alloc_block_FF+0x67>
  80242d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802430:	8b 00                	mov    (%eax),%eax
  802432:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802435:	8b 52 04             	mov    0x4(%edx),%edx
  802438:	89 50 04             	mov    %edx,0x4(%eax)
  80243b:	eb 0b                	jmp    802448 <alloc_block_FF+0x72>
  80243d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802440:	8b 40 04             	mov    0x4(%eax),%eax
  802443:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802448:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244b:	8b 40 04             	mov    0x4(%eax),%eax
  80244e:	85 c0                	test   %eax,%eax
  802450:	74 0f                	je     802461 <alloc_block_FF+0x8b>
  802452:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802455:	8b 40 04             	mov    0x4(%eax),%eax
  802458:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80245b:	8b 12                	mov    (%edx),%edx
  80245d:	89 10                	mov    %edx,(%eax)
  80245f:	eb 0a                	jmp    80246b <alloc_block_FF+0x95>
  802461:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802464:	8b 00                	mov    (%eax),%eax
  802466:	a3 38 51 80 00       	mov    %eax,0x805138
  80246b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802474:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802477:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80247e:	a1 44 51 80 00       	mov    0x805144,%eax
  802483:	48                   	dec    %eax
  802484:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802489:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248c:	e9 10 01 00 00       	jmp    8025a1 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802491:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802494:	8b 40 0c             	mov    0xc(%eax),%eax
  802497:	3b 45 08             	cmp    0x8(%ebp),%eax
  80249a:	0f 86 c6 00 00 00    	jbe    802566 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8024a0:	a1 48 51 80 00       	mov    0x805148,%eax
  8024a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8024a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ab:	8b 50 08             	mov    0x8(%eax),%edx
  8024ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024b1:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8024b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8024ba:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8024bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024c1:	75 17                	jne    8024da <alloc_block_FF+0x104>
  8024c3:	83 ec 04             	sub    $0x4,%esp
  8024c6:	68 40 40 80 00       	push   $0x804040
  8024cb:	68 9b 00 00 00       	push   $0x9b
  8024d0:	68 97 3f 80 00       	push   $0x803f97
  8024d5:	e8 f3 0f 00 00       	call   8034cd <_panic>
  8024da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024dd:	8b 00                	mov    (%eax),%eax
  8024df:	85 c0                	test   %eax,%eax
  8024e1:	74 10                	je     8024f3 <alloc_block_FF+0x11d>
  8024e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e6:	8b 00                	mov    (%eax),%eax
  8024e8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024eb:	8b 52 04             	mov    0x4(%edx),%edx
  8024ee:	89 50 04             	mov    %edx,0x4(%eax)
  8024f1:	eb 0b                	jmp    8024fe <alloc_block_FF+0x128>
  8024f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f6:	8b 40 04             	mov    0x4(%eax),%eax
  8024f9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8024fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802501:	8b 40 04             	mov    0x4(%eax),%eax
  802504:	85 c0                	test   %eax,%eax
  802506:	74 0f                	je     802517 <alloc_block_FF+0x141>
  802508:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80250b:	8b 40 04             	mov    0x4(%eax),%eax
  80250e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802511:	8b 12                	mov    (%edx),%edx
  802513:	89 10                	mov    %edx,(%eax)
  802515:	eb 0a                	jmp    802521 <alloc_block_FF+0x14b>
  802517:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80251a:	8b 00                	mov    (%eax),%eax
  80251c:	a3 48 51 80 00       	mov    %eax,0x805148
  802521:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802524:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80252a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80252d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802534:	a1 54 51 80 00       	mov    0x805154,%eax
  802539:	48                   	dec    %eax
  80253a:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  80253f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802542:	8b 50 08             	mov    0x8(%eax),%edx
  802545:	8b 45 08             	mov    0x8(%ebp),%eax
  802548:	01 c2                	add    %eax,%edx
  80254a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254d:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802550:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802553:	8b 40 0c             	mov    0xc(%eax),%eax
  802556:	2b 45 08             	sub    0x8(%ebp),%eax
  802559:	89 c2                	mov    %eax,%edx
  80255b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255e:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802561:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802564:	eb 3b                	jmp    8025a1 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802566:	a1 40 51 80 00       	mov    0x805140,%eax
  80256b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80256e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802572:	74 07                	je     80257b <alloc_block_FF+0x1a5>
  802574:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802577:	8b 00                	mov    (%eax),%eax
  802579:	eb 05                	jmp    802580 <alloc_block_FF+0x1aa>
  80257b:	b8 00 00 00 00       	mov    $0x0,%eax
  802580:	a3 40 51 80 00       	mov    %eax,0x805140
  802585:	a1 40 51 80 00       	mov    0x805140,%eax
  80258a:	85 c0                	test   %eax,%eax
  80258c:	0f 85 57 fe ff ff    	jne    8023e9 <alloc_block_FF+0x13>
  802592:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802596:	0f 85 4d fe ff ff    	jne    8023e9 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  80259c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025a1:	c9                   	leave  
  8025a2:	c3                   	ret    

008025a3 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8025a3:	55                   	push   %ebp
  8025a4:	89 e5                	mov    %esp,%ebp
  8025a6:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8025a9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8025b0:	a1 38 51 80 00       	mov    0x805138,%eax
  8025b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025b8:	e9 df 00 00 00       	jmp    80269c <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8025bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8025c3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025c6:	0f 82 c8 00 00 00    	jb     802694 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8025cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8025d2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025d5:	0f 85 8a 00 00 00    	jne    802665 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8025db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025df:	75 17                	jne    8025f8 <alloc_block_BF+0x55>
  8025e1:	83 ec 04             	sub    $0x4,%esp
  8025e4:	68 40 40 80 00       	push   $0x804040
  8025e9:	68 b7 00 00 00       	push   $0xb7
  8025ee:	68 97 3f 80 00       	push   $0x803f97
  8025f3:	e8 d5 0e 00 00       	call   8034cd <_panic>
  8025f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fb:	8b 00                	mov    (%eax),%eax
  8025fd:	85 c0                	test   %eax,%eax
  8025ff:	74 10                	je     802611 <alloc_block_BF+0x6e>
  802601:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802604:	8b 00                	mov    (%eax),%eax
  802606:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802609:	8b 52 04             	mov    0x4(%edx),%edx
  80260c:	89 50 04             	mov    %edx,0x4(%eax)
  80260f:	eb 0b                	jmp    80261c <alloc_block_BF+0x79>
  802611:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802614:	8b 40 04             	mov    0x4(%eax),%eax
  802617:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80261c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261f:	8b 40 04             	mov    0x4(%eax),%eax
  802622:	85 c0                	test   %eax,%eax
  802624:	74 0f                	je     802635 <alloc_block_BF+0x92>
  802626:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802629:	8b 40 04             	mov    0x4(%eax),%eax
  80262c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80262f:	8b 12                	mov    (%edx),%edx
  802631:	89 10                	mov    %edx,(%eax)
  802633:	eb 0a                	jmp    80263f <alloc_block_BF+0x9c>
  802635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802638:	8b 00                	mov    (%eax),%eax
  80263a:	a3 38 51 80 00       	mov    %eax,0x805138
  80263f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802642:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802648:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802652:	a1 44 51 80 00       	mov    0x805144,%eax
  802657:	48                   	dec    %eax
  802658:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  80265d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802660:	e9 4d 01 00 00       	jmp    8027b2 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802665:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802668:	8b 40 0c             	mov    0xc(%eax),%eax
  80266b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80266e:	76 24                	jbe    802694 <alloc_block_BF+0xf1>
  802670:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802673:	8b 40 0c             	mov    0xc(%eax),%eax
  802676:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802679:	73 19                	jae    802694 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80267b:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802682:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802685:	8b 40 0c             	mov    0xc(%eax),%eax
  802688:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  80268b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268e:	8b 40 08             	mov    0x8(%eax),%eax
  802691:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802694:	a1 40 51 80 00       	mov    0x805140,%eax
  802699:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80269c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026a0:	74 07                	je     8026a9 <alloc_block_BF+0x106>
  8026a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a5:	8b 00                	mov    (%eax),%eax
  8026a7:	eb 05                	jmp    8026ae <alloc_block_BF+0x10b>
  8026a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ae:	a3 40 51 80 00       	mov    %eax,0x805140
  8026b3:	a1 40 51 80 00       	mov    0x805140,%eax
  8026b8:	85 c0                	test   %eax,%eax
  8026ba:	0f 85 fd fe ff ff    	jne    8025bd <alloc_block_BF+0x1a>
  8026c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026c4:	0f 85 f3 fe ff ff    	jne    8025bd <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8026ca:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8026ce:	0f 84 d9 00 00 00    	je     8027ad <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8026d4:	a1 48 51 80 00       	mov    0x805148,%eax
  8026d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8026dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026df:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026e2:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8026e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8026eb:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8026ee:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8026f2:	75 17                	jne    80270b <alloc_block_BF+0x168>
  8026f4:	83 ec 04             	sub    $0x4,%esp
  8026f7:	68 40 40 80 00       	push   $0x804040
  8026fc:	68 c7 00 00 00       	push   $0xc7
  802701:	68 97 3f 80 00       	push   $0x803f97
  802706:	e8 c2 0d 00 00       	call   8034cd <_panic>
  80270b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80270e:	8b 00                	mov    (%eax),%eax
  802710:	85 c0                	test   %eax,%eax
  802712:	74 10                	je     802724 <alloc_block_BF+0x181>
  802714:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802717:	8b 00                	mov    (%eax),%eax
  802719:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80271c:	8b 52 04             	mov    0x4(%edx),%edx
  80271f:	89 50 04             	mov    %edx,0x4(%eax)
  802722:	eb 0b                	jmp    80272f <alloc_block_BF+0x18c>
  802724:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802727:	8b 40 04             	mov    0x4(%eax),%eax
  80272a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80272f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802732:	8b 40 04             	mov    0x4(%eax),%eax
  802735:	85 c0                	test   %eax,%eax
  802737:	74 0f                	je     802748 <alloc_block_BF+0x1a5>
  802739:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80273c:	8b 40 04             	mov    0x4(%eax),%eax
  80273f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802742:	8b 12                	mov    (%edx),%edx
  802744:	89 10                	mov    %edx,(%eax)
  802746:	eb 0a                	jmp    802752 <alloc_block_BF+0x1af>
  802748:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80274b:	8b 00                	mov    (%eax),%eax
  80274d:	a3 48 51 80 00       	mov    %eax,0x805148
  802752:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802755:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80275b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80275e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802765:	a1 54 51 80 00       	mov    0x805154,%eax
  80276a:	48                   	dec    %eax
  80276b:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802770:	83 ec 08             	sub    $0x8,%esp
  802773:	ff 75 ec             	pushl  -0x14(%ebp)
  802776:	68 38 51 80 00       	push   $0x805138
  80277b:	e8 71 f9 ff ff       	call   8020f1 <find_block>
  802780:	83 c4 10             	add    $0x10,%esp
  802783:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802786:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802789:	8b 50 08             	mov    0x8(%eax),%edx
  80278c:	8b 45 08             	mov    0x8(%ebp),%eax
  80278f:	01 c2                	add    %eax,%edx
  802791:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802794:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802797:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80279a:	8b 40 0c             	mov    0xc(%eax),%eax
  80279d:	2b 45 08             	sub    0x8(%ebp),%eax
  8027a0:	89 c2                	mov    %eax,%edx
  8027a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027a5:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8027a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027ab:	eb 05                	jmp    8027b2 <alloc_block_BF+0x20f>
	}
	return NULL;
  8027ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027b2:	c9                   	leave  
  8027b3:	c3                   	ret    

008027b4 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8027b4:	55                   	push   %ebp
  8027b5:	89 e5                	mov    %esp,%ebp
  8027b7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8027ba:	a1 28 50 80 00       	mov    0x805028,%eax
  8027bf:	85 c0                	test   %eax,%eax
  8027c1:	0f 85 de 01 00 00    	jne    8029a5 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8027c7:	a1 38 51 80 00       	mov    0x805138,%eax
  8027cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027cf:	e9 9e 01 00 00       	jmp    802972 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8027d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8027da:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027dd:	0f 82 87 01 00 00    	jb     80296a <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8027e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e6:	8b 40 0c             	mov    0xc(%eax),%eax
  8027e9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027ec:	0f 85 95 00 00 00    	jne    802887 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8027f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027f6:	75 17                	jne    80280f <alloc_block_NF+0x5b>
  8027f8:	83 ec 04             	sub    $0x4,%esp
  8027fb:	68 40 40 80 00       	push   $0x804040
  802800:	68 e0 00 00 00       	push   $0xe0
  802805:	68 97 3f 80 00       	push   $0x803f97
  80280a:	e8 be 0c 00 00       	call   8034cd <_panic>
  80280f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802812:	8b 00                	mov    (%eax),%eax
  802814:	85 c0                	test   %eax,%eax
  802816:	74 10                	je     802828 <alloc_block_NF+0x74>
  802818:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281b:	8b 00                	mov    (%eax),%eax
  80281d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802820:	8b 52 04             	mov    0x4(%edx),%edx
  802823:	89 50 04             	mov    %edx,0x4(%eax)
  802826:	eb 0b                	jmp    802833 <alloc_block_NF+0x7f>
  802828:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282b:	8b 40 04             	mov    0x4(%eax),%eax
  80282e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802833:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802836:	8b 40 04             	mov    0x4(%eax),%eax
  802839:	85 c0                	test   %eax,%eax
  80283b:	74 0f                	je     80284c <alloc_block_NF+0x98>
  80283d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802840:	8b 40 04             	mov    0x4(%eax),%eax
  802843:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802846:	8b 12                	mov    (%edx),%edx
  802848:	89 10                	mov    %edx,(%eax)
  80284a:	eb 0a                	jmp    802856 <alloc_block_NF+0xa2>
  80284c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284f:	8b 00                	mov    (%eax),%eax
  802851:	a3 38 51 80 00       	mov    %eax,0x805138
  802856:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802859:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80285f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802862:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802869:	a1 44 51 80 00       	mov    0x805144,%eax
  80286e:	48                   	dec    %eax
  80286f:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802874:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802877:	8b 40 08             	mov    0x8(%eax),%eax
  80287a:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  80287f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802882:	e9 f8 04 00 00       	jmp    802d7f <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802887:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288a:	8b 40 0c             	mov    0xc(%eax),%eax
  80288d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802890:	0f 86 d4 00 00 00    	jbe    80296a <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802896:	a1 48 51 80 00       	mov    0x805148,%eax
  80289b:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  80289e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a1:	8b 50 08             	mov    0x8(%eax),%edx
  8028a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a7:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8028aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8028b0:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8028b3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028b7:	75 17                	jne    8028d0 <alloc_block_NF+0x11c>
  8028b9:	83 ec 04             	sub    $0x4,%esp
  8028bc:	68 40 40 80 00       	push   $0x804040
  8028c1:	68 e9 00 00 00       	push   $0xe9
  8028c6:	68 97 3f 80 00       	push   $0x803f97
  8028cb:	e8 fd 0b 00 00       	call   8034cd <_panic>
  8028d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d3:	8b 00                	mov    (%eax),%eax
  8028d5:	85 c0                	test   %eax,%eax
  8028d7:	74 10                	je     8028e9 <alloc_block_NF+0x135>
  8028d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028dc:	8b 00                	mov    (%eax),%eax
  8028de:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028e1:	8b 52 04             	mov    0x4(%edx),%edx
  8028e4:	89 50 04             	mov    %edx,0x4(%eax)
  8028e7:	eb 0b                	jmp    8028f4 <alloc_block_NF+0x140>
  8028e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ec:	8b 40 04             	mov    0x4(%eax),%eax
  8028ef:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f7:	8b 40 04             	mov    0x4(%eax),%eax
  8028fa:	85 c0                	test   %eax,%eax
  8028fc:	74 0f                	je     80290d <alloc_block_NF+0x159>
  8028fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802901:	8b 40 04             	mov    0x4(%eax),%eax
  802904:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802907:	8b 12                	mov    (%edx),%edx
  802909:	89 10                	mov    %edx,(%eax)
  80290b:	eb 0a                	jmp    802917 <alloc_block_NF+0x163>
  80290d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802910:	8b 00                	mov    (%eax),%eax
  802912:	a3 48 51 80 00       	mov    %eax,0x805148
  802917:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80291a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802920:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802923:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80292a:	a1 54 51 80 00       	mov    0x805154,%eax
  80292f:	48                   	dec    %eax
  802930:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802935:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802938:	8b 40 08             	mov    0x8(%eax),%eax
  80293b:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802940:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802943:	8b 50 08             	mov    0x8(%eax),%edx
  802946:	8b 45 08             	mov    0x8(%ebp),%eax
  802949:	01 c2                	add    %eax,%edx
  80294b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294e:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802951:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802954:	8b 40 0c             	mov    0xc(%eax),%eax
  802957:	2b 45 08             	sub    0x8(%ebp),%eax
  80295a:	89 c2                	mov    %eax,%edx
  80295c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295f:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802962:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802965:	e9 15 04 00 00       	jmp    802d7f <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80296a:	a1 40 51 80 00       	mov    0x805140,%eax
  80296f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802972:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802976:	74 07                	je     80297f <alloc_block_NF+0x1cb>
  802978:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297b:	8b 00                	mov    (%eax),%eax
  80297d:	eb 05                	jmp    802984 <alloc_block_NF+0x1d0>
  80297f:	b8 00 00 00 00       	mov    $0x0,%eax
  802984:	a3 40 51 80 00       	mov    %eax,0x805140
  802989:	a1 40 51 80 00       	mov    0x805140,%eax
  80298e:	85 c0                	test   %eax,%eax
  802990:	0f 85 3e fe ff ff    	jne    8027d4 <alloc_block_NF+0x20>
  802996:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80299a:	0f 85 34 fe ff ff    	jne    8027d4 <alloc_block_NF+0x20>
  8029a0:	e9 d5 03 00 00       	jmp    802d7a <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029a5:	a1 38 51 80 00       	mov    0x805138,%eax
  8029aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029ad:	e9 b1 01 00 00       	jmp    802b63 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8029b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b5:	8b 50 08             	mov    0x8(%eax),%edx
  8029b8:	a1 28 50 80 00       	mov    0x805028,%eax
  8029bd:	39 c2                	cmp    %eax,%edx
  8029bf:	0f 82 96 01 00 00    	jb     802b5b <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8029c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8029cb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029ce:	0f 82 87 01 00 00    	jb     802b5b <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8029d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8029da:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029dd:	0f 85 95 00 00 00    	jne    802a78 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8029e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029e7:	75 17                	jne    802a00 <alloc_block_NF+0x24c>
  8029e9:	83 ec 04             	sub    $0x4,%esp
  8029ec:	68 40 40 80 00       	push   $0x804040
  8029f1:	68 fc 00 00 00       	push   $0xfc
  8029f6:	68 97 3f 80 00       	push   $0x803f97
  8029fb:	e8 cd 0a 00 00       	call   8034cd <_panic>
  802a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a03:	8b 00                	mov    (%eax),%eax
  802a05:	85 c0                	test   %eax,%eax
  802a07:	74 10                	je     802a19 <alloc_block_NF+0x265>
  802a09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0c:	8b 00                	mov    (%eax),%eax
  802a0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a11:	8b 52 04             	mov    0x4(%edx),%edx
  802a14:	89 50 04             	mov    %edx,0x4(%eax)
  802a17:	eb 0b                	jmp    802a24 <alloc_block_NF+0x270>
  802a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1c:	8b 40 04             	mov    0x4(%eax),%eax
  802a1f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a27:	8b 40 04             	mov    0x4(%eax),%eax
  802a2a:	85 c0                	test   %eax,%eax
  802a2c:	74 0f                	je     802a3d <alloc_block_NF+0x289>
  802a2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a31:	8b 40 04             	mov    0x4(%eax),%eax
  802a34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a37:	8b 12                	mov    (%edx),%edx
  802a39:	89 10                	mov    %edx,(%eax)
  802a3b:	eb 0a                	jmp    802a47 <alloc_block_NF+0x293>
  802a3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a40:	8b 00                	mov    (%eax),%eax
  802a42:	a3 38 51 80 00       	mov    %eax,0x805138
  802a47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a53:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a5a:	a1 44 51 80 00       	mov    0x805144,%eax
  802a5f:	48                   	dec    %eax
  802a60:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a68:	8b 40 08             	mov    0x8(%eax),%eax
  802a6b:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a73:	e9 07 03 00 00       	jmp    802d7f <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7b:	8b 40 0c             	mov    0xc(%eax),%eax
  802a7e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a81:	0f 86 d4 00 00 00    	jbe    802b5b <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a87:	a1 48 51 80 00       	mov    0x805148,%eax
  802a8c:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a92:	8b 50 08             	mov    0x8(%eax),%edx
  802a95:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a98:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802a9b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a9e:	8b 55 08             	mov    0x8(%ebp),%edx
  802aa1:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802aa4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802aa8:	75 17                	jne    802ac1 <alloc_block_NF+0x30d>
  802aaa:	83 ec 04             	sub    $0x4,%esp
  802aad:	68 40 40 80 00       	push   $0x804040
  802ab2:	68 04 01 00 00       	push   $0x104
  802ab7:	68 97 3f 80 00       	push   $0x803f97
  802abc:	e8 0c 0a 00 00       	call   8034cd <_panic>
  802ac1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ac4:	8b 00                	mov    (%eax),%eax
  802ac6:	85 c0                	test   %eax,%eax
  802ac8:	74 10                	je     802ada <alloc_block_NF+0x326>
  802aca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802acd:	8b 00                	mov    (%eax),%eax
  802acf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ad2:	8b 52 04             	mov    0x4(%edx),%edx
  802ad5:	89 50 04             	mov    %edx,0x4(%eax)
  802ad8:	eb 0b                	jmp    802ae5 <alloc_block_NF+0x331>
  802ada:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802add:	8b 40 04             	mov    0x4(%eax),%eax
  802ae0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ae5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ae8:	8b 40 04             	mov    0x4(%eax),%eax
  802aeb:	85 c0                	test   %eax,%eax
  802aed:	74 0f                	je     802afe <alloc_block_NF+0x34a>
  802aef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802af2:	8b 40 04             	mov    0x4(%eax),%eax
  802af5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802af8:	8b 12                	mov    (%edx),%edx
  802afa:	89 10                	mov    %edx,(%eax)
  802afc:	eb 0a                	jmp    802b08 <alloc_block_NF+0x354>
  802afe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b01:	8b 00                	mov    (%eax),%eax
  802b03:	a3 48 51 80 00       	mov    %eax,0x805148
  802b08:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b0b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b11:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b14:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b1b:	a1 54 51 80 00       	mov    0x805154,%eax
  802b20:	48                   	dec    %eax
  802b21:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802b26:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b29:	8b 40 08             	mov    0x8(%eax),%eax
  802b2c:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b34:	8b 50 08             	mov    0x8(%eax),%edx
  802b37:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3a:	01 c2                	add    %eax,%edx
  802b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3f:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b45:	8b 40 0c             	mov    0xc(%eax),%eax
  802b48:	2b 45 08             	sub    0x8(%ebp),%eax
  802b4b:	89 c2                	mov    %eax,%edx
  802b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b50:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802b53:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b56:	e9 24 02 00 00       	jmp    802d7f <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b5b:	a1 40 51 80 00       	mov    0x805140,%eax
  802b60:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b63:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b67:	74 07                	je     802b70 <alloc_block_NF+0x3bc>
  802b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6c:	8b 00                	mov    (%eax),%eax
  802b6e:	eb 05                	jmp    802b75 <alloc_block_NF+0x3c1>
  802b70:	b8 00 00 00 00       	mov    $0x0,%eax
  802b75:	a3 40 51 80 00       	mov    %eax,0x805140
  802b7a:	a1 40 51 80 00       	mov    0x805140,%eax
  802b7f:	85 c0                	test   %eax,%eax
  802b81:	0f 85 2b fe ff ff    	jne    8029b2 <alloc_block_NF+0x1fe>
  802b87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b8b:	0f 85 21 fe ff ff    	jne    8029b2 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b91:	a1 38 51 80 00       	mov    0x805138,%eax
  802b96:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b99:	e9 ae 01 00 00       	jmp    802d4c <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802b9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba1:	8b 50 08             	mov    0x8(%eax),%edx
  802ba4:	a1 28 50 80 00       	mov    0x805028,%eax
  802ba9:	39 c2                	cmp    %eax,%edx
  802bab:	0f 83 93 01 00 00    	jae    802d44 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802bb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb4:	8b 40 0c             	mov    0xc(%eax),%eax
  802bb7:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bba:	0f 82 84 01 00 00    	jb     802d44 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc3:	8b 40 0c             	mov    0xc(%eax),%eax
  802bc6:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bc9:	0f 85 95 00 00 00    	jne    802c64 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802bcf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bd3:	75 17                	jne    802bec <alloc_block_NF+0x438>
  802bd5:	83 ec 04             	sub    $0x4,%esp
  802bd8:	68 40 40 80 00       	push   $0x804040
  802bdd:	68 14 01 00 00       	push   $0x114
  802be2:	68 97 3f 80 00       	push   $0x803f97
  802be7:	e8 e1 08 00 00       	call   8034cd <_panic>
  802bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bef:	8b 00                	mov    (%eax),%eax
  802bf1:	85 c0                	test   %eax,%eax
  802bf3:	74 10                	je     802c05 <alloc_block_NF+0x451>
  802bf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf8:	8b 00                	mov    (%eax),%eax
  802bfa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bfd:	8b 52 04             	mov    0x4(%edx),%edx
  802c00:	89 50 04             	mov    %edx,0x4(%eax)
  802c03:	eb 0b                	jmp    802c10 <alloc_block_NF+0x45c>
  802c05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c08:	8b 40 04             	mov    0x4(%eax),%eax
  802c0b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c13:	8b 40 04             	mov    0x4(%eax),%eax
  802c16:	85 c0                	test   %eax,%eax
  802c18:	74 0f                	je     802c29 <alloc_block_NF+0x475>
  802c1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1d:	8b 40 04             	mov    0x4(%eax),%eax
  802c20:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c23:	8b 12                	mov    (%edx),%edx
  802c25:	89 10                	mov    %edx,(%eax)
  802c27:	eb 0a                	jmp    802c33 <alloc_block_NF+0x47f>
  802c29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2c:	8b 00                	mov    (%eax),%eax
  802c2e:	a3 38 51 80 00       	mov    %eax,0x805138
  802c33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c36:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c46:	a1 44 51 80 00       	mov    0x805144,%eax
  802c4b:	48                   	dec    %eax
  802c4c:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802c51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c54:	8b 40 08             	mov    0x8(%eax),%eax
  802c57:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5f:	e9 1b 01 00 00       	jmp    802d7f <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802c64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c67:	8b 40 0c             	mov    0xc(%eax),%eax
  802c6a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c6d:	0f 86 d1 00 00 00    	jbe    802d44 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802c73:	a1 48 51 80 00       	mov    0x805148,%eax
  802c78:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802c7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7e:	8b 50 08             	mov    0x8(%eax),%edx
  802c81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c84:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802c87:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c8a:	8b 55 08             	mov    0x8(%ebp),%edx
  802c8d:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802c90:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c94:	75 17                	jne    802cad <alloc_block_NF+0x4f9>
  802c96:	83 ec 04             	sub    $0x4,%esp
  802c99:	68 40 40 80 00       	push   $0x804040
  802c9e:	68 1c 01 00 00       	push   $0x11c
  802ca3:	68 97 3f 80 00       	push   $0x803f97
  802ca8:	e8 20 08 00 00       	call   8034cd <_panic>
  802cad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cb0:	8b 00                	mov    (%eax),%eax
  802cb2:	85 c0                	test   %eax,%eax
  802cb4:	74 10                	je     802cc6 <alloc_block_NF+0x512>
  802cb6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cb9:	8b 00                	mov    (%eax),%eax
  802cbb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cbe:	8b 52 04             	mov    0x4(%edx),%edx
  802cc1:	89 50 04             	mov    %edx,0x4(%eax)
  802cc4:	eb 0b                	jmp    802cd1 <alloc_block_NF+0x51d>
  802cc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cc9:	8b 40 04             	mov    0x4(%eax),%eax
  802ccc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802cd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cd4:	8b 40 04             	mov    0x4(%eax),%eax
  802cd7:	85 c0                	test   %eax,%eax
  802cd9:	74 0f                	je     802cea <alloc_block_NF+0x536>
  802cdb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cde:	8b 40 04             	mov    0x4(%eax),%eax
  802ce1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ce4:	8b 12                	mov    (%edx),%edx
  802ce6:	89 10                	mov    %edx,(%eax)
  802ce8:	eb 0a                	jmp    802cf4 <alloc_block_NF+0x540>
  802cea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ced:	8b 00                	mov    (%eax),%eax
  802cef:	a3 48 51 80 00       	mov    %eax,0x805148
  802cf4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cf7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cfd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d00:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d07:	a1 54 51 80 00       	mov    0x805154,%eax
  802d0c:	48                   	dec    %eax
  802d0d:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802d12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d15:	8b 40 08             	mov    0x8(%eax),%eax
  802d18:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802d1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d20:	8b 50 08             	mov    0x8(%eax),%edx
  802d23:	8b 45 08             	mov    0x8(%ebp),%eax
  802d26:	01 c2                	add    %eax,%edx
  802d28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2b:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802d2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d31:	8b 40 0c             	mov    0xc(%eax),%eax
  802d34:	2b 45 08             	sub    0x8(%ebp),%eax
  802d37:	89 c2                	mov    %eax,%edx
  802d39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3c:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802d3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d42:	eb 3b                	jmp    802d7f <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802d44:	a1 40 51 80 00       	mov    0x805140,%eax
  802d49:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d4c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d50:	74 07                	je     802d59 <alloc_block_NF+0x5a5>
  802d52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d55:	8b 00                	mov    (%eax),%eax
  802d57:	eb 05                	jmp    802d5e <alloc_block_NF+0x5aa>
  802d59:	b8 00 00 00 00       	mov    $0x0,%eax
  802d5e:	a3 40 51 80 00       	mov    %eax,0x805140
  802d63:	a1 40 51 80 00       	mov    0x805140,%eax
  802d68:	85 c0                	test   %eax,%eax
  802d6a:	0f 85 2e fe ff ff    	jne    802b9e <alloc_block_NF+0x3ea>
  802d70:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d74:	0f 85 24 fe ff ff    	jne    802b9e <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802d7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d7f:	c9                   	leave  
  802d80:	c3                   	ret    

00802d81 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802d81:	55                   	push   %ebp
  802d82:	89 e5                	mov    %esp,%ebp
  802d84:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802d87:	a1 38 51 80 00       	mov    0x805138,%eax
  802d8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802d8f:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d94:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802d97:	a1 38 51 80 00       	mov    0x805138,%eax
  802d9c:	85 c0                	test   %eax,%eax
  802d9e:	74 14                	je     802db4 <insert_sorted_with_merge_freeList+0x33>
  802da0:	8b 45 08             	mov    0x8(%ebp),%eax
  802da3:	8b 50 08             	mov    0x8(%eax),%edx
  802da6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da9:	8b 40 08             	mov    0x8(%eax),%eax
  802dac:	39 c2                	cmp    %eax,%edx
  802dae:	0f 87 9b 01 00 00    	ja     802f4f <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802db4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802db8:	75 17                	jne    802dd1 <insert_sorted_with_merge_freeList+0x50>
  802dba:	83 ec 04             	sub    $0x4,%esp
  802dbd:	68 74 3f 80 00       	push   $0x803f74
  802dc2:	68 38 01 00 00       	push   $0x138
  802dc7:	68 97 3f 80 00       	push   $0x803f97
  802dcc:	e8 fc 06 00 00       	call   8034cd <_panic>
  802dd1:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dda:	89 10                	mov    %edx,(%eax)
  802ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddf:	8b 00                	mov    (%eax),%eax
  802de1:	85 c0                	test   %eax,%eax
  802de3:	74 0d                	je     802df2 <insert_sorted_with_merge_freeList+0x71>
  802de5:	a1 38 51 80 00       	mov    0x805138,%eax
  802dea:	8b 55 08             	mov    0x8(%ebp),%edx
  802ded:	89 50 04             	mov    %edx,0x4(%eax)
  802df0:	eb 08                	jmp    802dfa <insert_sorted_with_merge_freeList+0x79>
  802df2:	8b 45 08             	mov    0x8(%ebp),%eax
  802df5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfd:	a3 38 51 80 00       	mov    %eax,0x805138
  802e02:	8b 45 08             	mov    0x8(%ebp),%eax
  802e05:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e0c:	a1 44 51 80 00       	mov    0x805144,%eax
  802e11:	40                   	inc    %eax
  802e12:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e17:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e1b:	0f 84 a8 06 00 00    	je     8034c9 <insert_sorted_with_merge_freeList+0x748>
  802e21:	8b 45 08             	mov    0x8(%ebp),%eax
  802e24:	8b 50 08             	mov    0x8(%eax),%edx
  802e27:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2a:	8b 40 0c             	mov    0xc(%eax),%eax
  802e2d:	01 c2                	add    %eax,%edx
  802e2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e32:	8b 40 08             	mov    0x8(%eax),%eax
  802e35:	39 c2                	cmp    %eax,%edx
  802e37:	0f 85 8c 06 00 00    	jne    8034c9 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e40:	8b 50 0c             	mov    0xc(%eax),%edx
  802e43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e46:	8b 40 0c             	mov    0xc(%eax),%eax
  802e49:	01 c2                	add    %eax,%edx
  802e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4e:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802e51:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e55:	75 17                	jne    802e6e <insert_sorted_with_merge_freeList+0xed>
  802e57:	83 ec 04             	sub    $0x4,%esp
  802e5a:	68 40 40 80 00       	push   $0x804040
  802e5f:	68 3c 01 00 00       	push   $0x13c
  802e64:	68 97 3f 80 00       	push   $0x803f97
  802e69:	e8 5f 06 00 00       	call   8034cd <_panic>
  802e6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e71:	8b 00                	mov    (%eax),%eax
  802e73:	85 c0                	test   %eax,%eax
  802e75:	74 10                	je     802e87 <insert_sorted_with_merge_freeList+0x106>
  802e77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e7a:	8b 00                	mov    (%eax),%eax
  802e7c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e7f:	8b 52 04             	mov    0x4(%edx),%edx
  802e82:	89 50 04             	mov    %edx,0x4(%eax)
  802e85:	eb 0b                	jmp    802e92 <insert_sorted_with_merge_freeList+0x111>
  802e87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e8a:	8b 40 04             	mov    0x4(%eax),%eax
  802e8d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e95:	8b 40 04             	mov    0x4(%eax),%eax
  802e98:	85 c0                	test   %eax,%eax
  802e9a:	74 0f                	je     802eab <insert_sorted_with_merge_freeList+0x12a>
  802e9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e9f:	8b 40 04             	mov    0x4(%eax),%eax
  802ea2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ea5:	8b 12                	mov    (%edx),%edx
  802ea7:	89 10                	mov    %edx,(%eax)
  802ea9:	eb 0a                	jmp    802eb5 <insert_sorted_with_merge_freeList+0x134>
  802eab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eae:	8b 00                	mov    (%eax),%eax
  802eb0:	a3 38 51 80 00       	mov    %eax,0x805138
  802eb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ebe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ec8:	a1 44 51 80 00       	mov    0x805144,%eax
  802ecd:	48                   	dec    %eax
  802ece:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802ed3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802edd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802ee7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802eeb:	75 17                	jne    802f04 <insert_sorted_with_merge_freeList+0x183>
  802eed:	83 ec 04             	sub    $0x4,%esp
  802ef0:	68 74 3f 80 00       	push   $0x803f74
  802ef5:	68 3f 01 00 00       	push   $0x13f
  802efa:	68 97 3f 80 00       	push   $0x803f97
  802eff:	e8 c9 05 00 00       	call   8034cd <_panic>
  802f04:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f0d:	89 10                	mov    %edx,(%eax)
  802f0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f12:	8b 00                	mov    (%eax),%eax
  802f14:	85 c0                	test   %eax,%eax
  802f16:	74 0d                	je     802f25 <insert_sorted_with_merge_freeList+0x1a4>
  802f18:	a1 48 51 80 00       	mov    0x805148,%eax
  802f1d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f20:	89 50 04             	mov    %edx,0x4(%eax)
  802f23:	eb 08                	jmp    802f2d <insert_sorted_with_merge_freeList+0x1ac>
  802f25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f28:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f30:	a3 48 51 80 00       	mov    %eax,0x805148
  802f35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f38:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f3f:	a1 54 51 80 00       	mov    0x805154,%eax
  802f44:	40                   	inc    %eax
  802f45:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802f4a:	e9 7a 05 00 00       	jmp    8034c9 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f52:	8b 50 08             	mov    0x8(%eax),%edx
  802f55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f58:	8b 40 08             	mov    0x8(%eax),%eax
  802f5b:	39 c2                	cmp    %eax,%edx
  802f5d:	0f 82 14 01 00 00    	jb     803077 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802f63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f66:	8b 50 08             	mov    0x8(%eax),%edx
  802f69:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f6c:	8b 40 0c             	mov    0xc(%eax),%eax
  802f6f:	01 c2                	add    %eax,%edx
  802f71:	8b 45 08             	mov    0x8(%ebp),%eax
  802f74:	8b 40 08             	mov    0x8(%eax),%eax
  802f77:	39 c2                	cmp    %eax,%edx
  802f79:	0f 85 90 00 00 00    	jne    80300f <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802f7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f82:	8b 50 0c             	mov    0xc(%eax),%edx
  802f85:	8b 45 08             	mov    0x8(%ebp),%eax
  802f88:	8b 40 0c             	mov    0xc(%eax),%eax
  802f8b:	01 c2                	add    %eax,%edx
  802f8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f90:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802f93:	8b 45 08             	mov    0x8(%ebp),%eax
  802f96:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802fa7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fab:	75 17                	jne    802fc4 <insert_sorted_with_merge_freeList+0x243>
  802fad:	83 ec 04             	sub    $0x4,%esp
  802fb0:	68 74 3f 80 00       	push   $0x803f74
  802fb5:	68 49 01 00 00       	push   $0x149
  802fba:	68 97 3f 80 00       	push   $0x803f97
  802fbf:	e8 09 05 00 00       	call   8034cd <_panic>
  802fc4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802fca:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcd:	89 10                	mov    %edx,(%eax)
  802fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd2:	8b 00                	mov    (%eax),%eax
  802fd4:	85 c0                	test   %eax,%eax
  802fd6:	74 0d                	je     802fe5 <insert_sorted_with_merge_freeList+0x264>
  802fd8:	a1 48 51 80 00       	mov    0x805148,%eax
  802fdd:	8b 55 08             	mov    0x8(%ebp),%edx
  802fe0:	89 50 04             	mov    %edx,0x4(%eax)
  802fe3:	eb 08                	jmp    802fed <insert_sorted_with_merge_freeList+0x26c>
  802fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fed:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff0:	a3 48 51 80 00       	mov    %eax,0x805148
  802ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fff:	a1 54 51 80 00       	mov    0x805154,%eax
  803004:	40                   	inc    %eax
  803005:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80300a:	e9 bb 04 00 00       	jmp    8034ca <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  80300f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803013:	75 17                	jne    80302c <insert_sorted_with_merge_freeList+0x2ab>
  803015:	83 ec 04             	sub    $0x4,%esp
  803018:	68 e8 3f 80 00       	push   $0x803fe8
  80301d:	68 4c 01 00 00       	push   $0x14c
  803022:	68 97 3f 80 00       	push   $0x803f97
  803027:	e8 a1 04 00 00       	call   8034cd <_panic>
  80302c:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803032:	8b 45 08             	mov    0x8(%ebp),%eax
  803035:	89 50 04             	mov    %edx,0x4(%eax)
  803038:	8b 45 08             	mov    0x8(%ebp),%eax
  80303b:	8b 40 04             	mov    0x4(%eax),%eax
  80303e:	85 c0                	test   %eax,%eax
  803040:	74 0c                	je     80304e <insert_sorted_with_merge_freeList+0x2cd>
  803042:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803047:	8b 55 08             	mov    0x8(%ebp),%edx
  80304a:	89 10                	mov    %edx,(%eax)
  80304c:	eb 08                	jmp    803056 <insert_sorted_with_merge_freeList+0x2d5>
  80304e:	8b 45 08             	mov    0x8(%ebp),%eax
  803051:	a3 38 51 80 00       	mov    %eax,0x805138
  803056:	8b 45 08             	mov    0x8(%ebp),%eax
  803059:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80305e:	8b 45 08             	mov    0x8(%ebp),%eax
  803061:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803067:	a1 44 51 80 00       	mov    0x805144,%eax
  80306c:	40                   	inc    %eax
  80306d:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803072:	e9 53 04 00 00       	jmp    8034ca <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803077:	a1 38 51 80 00       	mov    0x805138,%eax
  80307c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80307f:	e9 15 04 00 00       	jmp    803499 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803084:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803087:	8b 00                	mov    (%eax),%eax
  803089:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  80308c:	8b 45 08             	mov    0x8(%ebp),%eax
  80308f:	8b 50 08             	mov    0x8(%eax),%edx
  803092:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803095:	8b 40 08             	mov    0x8(%eax),%eax
  803098:	39 c2                	cmp    %eax,%edx
  80309a:	0f 86 f1 03 00 00    	jbe    803491 <insert_sorted_with_merge_freeList+0x710>
  8030a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a3:	8b 50 08             	mov    0x8(%eax),%edx
  8030a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a9:	8b 40 08             	mov    0x8(%eax),%eax
  8030ac:	39 c2                	cmp    %eax,%edx
  8030ae:	0f 83 dd 03 00 00    	jae    803491 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8030b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b7:	8b 50 08             	mov    0x8(%eax),%edx
  8030ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8030c0:	01 c2                	add    %eax,%edx
  8030c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c5:	8b 40 08             	mov    0x8(%eax),%eax
  8030c8:	39 c2                	cmp    %eax,%edx
  8030ca:	0f 85 b9 01 00 00    	jne    803289 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8030d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d3:	8b 50 08             	mov    0x8(%eax),%edx
  8030d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8030dc:	01 c2                	add    %eax,%edx
  8030de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e1:	8b 40 08             	mov    0x8(%eax),%eax
  8030e4:	39 c2                	cmp    %eax,%edx
  8030e6:	0f 85 0d 01 00 00    	jne    8031f9 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8030ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ef:	8b 50 0c             	mov    0xc(%eax),%edx
  8030f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8030f8:	01 c2                	add    %eax,%edx
  8030fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fd:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803100:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803104:	75 17                	jne    80311d <insert_sorted_with_merge_freeList+0x39c>
  803106:	83 ec 04             	sub    $0x4,%esp
  803109:	68 40 40 80 00       	push   $0x804040
  80310e:	68 5c 01 00 00       	push   $0x15c
  803113:	68 97 3f 80 00       	push   $0x803f97
  803118:	e8 b0 03 00 00       	call   8034cd <_panic>
  80311d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803120:	8b 00                	mov    (%eax),%eax
  803122:	85 c0                	test   %eax,%eax
  803124:	74 10                	je     803136 <insert_sorted_with_merge_freeList+0x3b5>
  803126:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803129:	8b 00                	mov    (%eax),%eax
  80312b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80312e:	8b 52 04             	mov    0x4(%edx),%edx
  803131:	89 50 04             	mov    %edx,0x4(%eax)
  803134:	eb 0b                	jmp    803141 <insert_sorted_with_merge_freeList+0x3c0>
  803136:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803139:	8b 40 04             	mov    0x4(%eax),%eax
  80313c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803141:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803144:	8b 40 04             	mov    0x4(%eax),%eax
  803147:	85 c0                	test   %eax,%eax
  803149:	74 0f                	je     80315a <insert_sorted_with_merge_freeList+0x3d9>
  80314b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80314e:	8b 40 04             	mov    0x4(%eax),%eax
  803151:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803154:	8b 12                	mov    (%edx),%edx
  803156:	89 10                	mov    %edx,(%eax)
  803158:	eb 0a                	jmp    803164 <insert_sorted_with_merge_freeList+0x3e3>
  80315a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80315d:	8b 00                	mov    (%eax),%eax
  80315f:	a3 38 51 80 00       	mov    %eax,0x805138
  803164:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803167:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80316d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803170:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803177:	a1 44 51 80 00       	mov    0x805144,%eax
  80317c:	48                   	dec    %eax
  80317d:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803182:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803185:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  80318c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80318f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803196:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80319a:	75 17                	jne    8031b3 <insert_sorted_with_merge_freeList+0x432>
  80319c:	83 ec 04             	sub    $0x4,%esp
  80319f:	68 74 3f 80 00       	push   $0x803f74
  8031a4:	68 5f 01 00 00       	push   $0x15f
  8031a9:	68 97 3f 80 00       	push   $0x803f97
  8031ae:	e8 1a 03 00 00       	call   8034cd <_panic>
  8031b3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031bc:	89 10                	mov    %edx,(%eax)
  8031be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c1:	8b 00                	mov    (%eax),%eax
  8031c3:	85 c0                	test   %eax,%eax
  8031c5:	74 0d                	je     8031d4 <insert_sorted_with_merge_freeList+0x453>
  8031c7:	a1 48 51 80 00       	mov    0x805148,%eax
  8031cc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031cf:	89 50 04             	mov    %edx,0x4(%eax)
  8031d2:	eb 08                	jmp    8031dc <insert_sorted_with_merge_freeList+0x45b>
  8031d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031df:	a3 48 51 80 00       	mov    %eax,0x805148
  8031e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031ee:	a1 54 51 80 00       	mov    0x805154,%eax
  8031f3:	40                   	inc    %eax
  8031f4:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8031f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031fc:	8b 50 0c             	mov    0xc(%eax),%edx
  8031ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803202:	8b 40 0c             	mov    0xc(%eax),%eax
  803205:	01 c2                	add    %eax,%edx
  803207:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320a:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80320d:	8b 45 08             	mov    0x8(%ebp),%eax
  803210:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803217:	8b 45 08             	mov    0x8(%ebp),%eax
  80321a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803221:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803225:	75 17                	jne    80323e <insert_sorted_with_merge_freeList+0x4bd>
  803227:	83 ec 04             	sub    $0x4,%esp
  80322a:	68 74 3f 80 00       	push   $0x803f74
  80322f:	68 64 01 00 00       	push   $0x164
  803234:	68 97 3f 80 00       	push   $0x803f97
  803239:	e8 8f 02 00 00       	call   8034cd <_panic>
  80323e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803244:	8b 45 08             	mov    0x8(%ebp),%eax
  803247:	89 10                	mov    %edx,(%eax)
  803249:	8b 45 08             	mov    0x8(%ebp),%eax
  80324c:	8b 00                	mov    (%eax),%eax
  80324e:	85 c0                	test   %eax,%eax
  803250:	74 0d                	je     80325f <insert_sorted_with_merge_freeList+0x4de>
  803252:	a1 48 51 80 00       	mov    0x805148,%eax
  803257:	8b 55 08             	mov    0x8(%ebp),%edx
  80325a:	89 50 04             	mov    %edx,0x4(%eax)
  80325d:	eb 08                	jmp    803267 <insert_sorted_with_merge_freeList+0x4e6>
  80325f:	8b 45 08             	mov    0x8(%ebp),%eax
  803262:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803267:	8b 45 08             	mov    0x8(%ebp),%eax
  80326a:	a3 48 51 80 00       	mov    %eax,0x805148
  80326f:	8b 45 08             	mov    0x8(%ebp),%eax
  803272:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803279:	a1 54 51 80 00       	mov    0x805154,%eax
  80327e:	40                   	inc    %eax
  80327f:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803284:	e9 41 02 00 00       	jmp    8034ca <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803289:	8b 45 08             	mov    0x8(%ebp),%eax
  80328c:	8b 50 08             	mov    0x8(%eax),%edx
  80328f:	8b 45 08             	mov    0x8(%ebp),%eax
  803292:	8b 40 0c             	mov    0xc(%eax),%eax
  803295:	01 c2                	add    %eax,%edx
  803297:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80329a:	8b 40 08             	mov    0x8(%eax),%eax
  80329d:	39 c2                	cmp    %eax,%edx
  80329f:	0f 85 7c 01 00 00    	jne    803421 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8032a5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032a9:	74 06                	je     8032b1 <insert_sorted_with_merge_freeList+0x530>
  8032ab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032af:	75 17                	jne    8032c8 <insert_sorted_with_merge_freeList+0x547>
  8032b1:	83 ec 04             	sub    $0x4,%esp
  8032b4:	68 b0 3f 80 00       	push   $0x803fb0
  8032b9:	68 69 01 00 00       	push   $0x169
  8032be:	68 97 3f 80 00       	push   $0x803f97
  8032c3:	e8 05 02 00 00       	call   8034cd <_panic>
  8032c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032cb:	8b 50 04             	mov    0x4(%eax),%edx
  8032ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d1:	89 50 04             	mov    %edx,0x4(%eax)
  8032d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032da:	89 10                	mov    %edx,(%eax)
  8032dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032df:	8b 40 04             	mov    0x4(%eax),%eax
  8032e2:	85 c0                	test   %eax,%eax
  8032e4:	74 0d                	je     8032f3 <insert_sorted_with_merge_freeList+0x572>
  8032e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e9:	8b 40 04             	mov    0x4(%eax),%eax
  8032ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8032ef:	89 10                	mov    %edx,(%eax)
  8032f1:	eb 08                	jmp    8032fb <insert_sorted_with_merge_freeList+0x57a>
  8032f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f6:	a3 38 51 80 00       	mov    %eax,0x805138
  8032fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032fe:	8b 55 08             	mov    0x8(%ebp),%edx
  803301:	89 50 04             	mov    %edx,0x4(%eax)
  803304:	a1 44 51 80 00       	mov    0x805144,%eax
  803309:	40                   	inc    %eax
  80330a:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  80330f:	8b 45 08             	mov    0x8(%ebp),%eax
  803312:	8b 50 0c             	mov    0xc(%eax),%edx
  803315:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803318:	8b 40 0c             	mov    0xc(%eax),%eax
  80331b:	01 c2                	add    %eax,%edx
  80331d:	8b 45 08             	mov    0x8(%ebp),%eax
  803320:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803323:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803327:	75 17                	jne    803340 <insert_sorted_with_merge_freeList+0x5bf>
  803329:	83 ec 04             	sub    $0x4,%esp
  80332c:	68 40 40 80 00       	push   $0x804040
  803331:	68 6b 01 00 00       	push   $0x16b
  803336:	68 97 3f 80 00       	push   $0x803f97
  80333b:	e8 8d 01 00 00       	call   8034cd <_panic>
  803340:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803343:	8b 00                	mov    (%eax),%eax
  803345:	85 c0                	test   %eax,%eax
  803347:	74 10                	je     803359 <insert_sorted_with_merge_freeList+0x5d8>
  803349:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80334c:	8b 00                	mov    (%eax),%eax
  80334e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803351:	8b 52 04             	mov    0x4(%edx),%edx
  803354:	89 50 04             	mov    %edx,0x4(%eax)
  803357:	eb 0b                	jmp    803364 <insert_sorted_with_merge_freeList+0x5e3>
  803359:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80335c:	8b 40 04             	mov    0x4(%eax),%eax
  80335f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803364:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803367:	8b 40 04             	mov    0x4(%eax),%eax
  80336a:	85 c0                	test   %eax,%eax
  80336c:	74 0f                	je     80337d <insert_sorted_with_merge_freeList+0x5fc>
  80336e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803371:	8b 40 04             	mov    0x4(%eax),%eax
  803374:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803377:	8b 12                	mov    (%edx),%edx
  803379:	89 10                	mov    %edx,(%eax)
  80337b:	eb 0a                	jmp    803387 <insert_sorted_with_merge_freeList+0x606>
  80337d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803380:	8b 00                	mov    (%eax),%eax
  803382:	a3 38 51 80 00       	mov    %eax,0x805138
  803387:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80338a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803390:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803393:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80339a:	a1 44 51 80 00       	mov    0x805144,%eax
  80339f:	48                   	dec    %eax
  8033a0:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8033a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8033af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8033b9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033bd:	75 17                	jne    8033d6 <insert_sorted_with_merge_freeList+0x655>
  8033bf:	83 ec 04             	sub    $0x4,%esp
  8033c2:	68 74 3f 80 00       	push   $0x803f74
  8033c7:	68 6e 01 00 00       	push   $0x16e
  8033cc:	68 97 3f 80 00       	push   $0x803f97
  8033d1:	e8 f7 00 00 00       	call   8034cd <_panic>
  8033d6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033df:	89 10                	mov    %edx,(%eax)
  8033e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e4:	8b 00                	mov    (%eax),%eax
  8033e6:	85 c0                	test   %eax,%eax
  8033e8:	74 0d                	je     8033f7 <insert_sorted_with_merge_freeList+0x676>
  8033ea:	a1 48 51 80 00       	mov    0x805148,%eax
  8033ef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033f2:	89 50 04             	mov    %edx,0x4(%eax)
  8033f5:	eb 08                	jmp    8033ff <insert_sorted_with_merge_freeList+0x67e>
  8033f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033fa:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803402:	a3 48 51 80 00       	mov    %eax,0x805148
  803407:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80340a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803411:	a1 54 51 80 00       	mov    0x805154,%eax
  803416:	40                   	inc    %eax
  803417:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80341c:	e9 a9 00 00 00       	jmp    8034ca <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803421:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803425:	74 06                	je     80342d <insert_sorted_with_merge_freeList+0x6ac>
  803427:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80342b:	75 17                	jne    803444 <insert_sorted_with_merge_freeList+0x6c3>
  80342d:	83 ec 04             	sub    $0x4,%esp
  803430:	68 0c 40 80 00       	push   $0x80400c
  803435:	68 73 01 00 00       	push   $0x173
  80343a:	68 97 3f 80 00       	push   $0x803f97
  80343f:	e8 89 00 00 00       	call   8034cd <_panic>
  803444:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803447:	8b 10                	mov    (%eax),%edx
  803449:	8b 45 08             	mov    0x8(%ebp),%eax
  80344c:	89 10                	mov    %edx,(%eax)
  80344e:	8b 45 08             	mov    0x8(%ebp),%eax
  803451:	8b 00                	mov    (%eax),%eax
  803453:	85 c0                	test   %eax,%eax
  803455:	74 0b                	je     803462 <insert_sorted_with_merge_freeList+0x6e1>
  803457:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80345a:	8b 00                	mov    (%eax),%eax
  80345c:	8b 55 08             	mov    0x8(%ebp),%edx
  80345f:	89 50 04             	mov    %edx,0x4(%eax)
  803462:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803465:	8b 55 08             	mov    0x8(%ebp),%edx
  803468:	89 10                	mov    %edx,(%eax)
  80346a:	8b 45 08             	mov    0x8(%ebp),%eax
  80346d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803470:	89 50 04             	mov    %edx,0x4(%eax)
  803473:	8b 45 08             	mov    0x8(%ebp),%eax
  803476:	8b 00                	mov    (%eax),%eax
  803478:	85 c0                	test   %eax,%eax
  80347a:	75 08                	jne    803484 <insert_sorted_with_merge_freeList+0x703>
  80347c:	8b 45 08             	mov    0x8(%ebp),%eax
  80347f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803484:	a1 44 51 80 00       	mov    0x805144,%eax
  803489:	40                   	inc    %eax
  80348a:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  80348f:	eb 39                	jmp    8034ca <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803491:	a1 40 51 80 00       	mov    0x805140,%eax
  803496:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803499:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80349d:	74 07                	je     8034a6 <insert_sorted_with_merge_freeList+0x725>
  80349f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a2:	8b 00                	mov    (%eax),%eax
  8034a4:	eb 05                	jmp    8034ab <insert_sorted_with_merge_freeList+0x72a>
  8034a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8034ab:	a3 40 51 80 00       	mov    %eax,0x805140
  8034b0:	a1 40 51 80 00       	mov    0x805140,%eax
  8034b5:	85 c0                	test   %eax,%eax
  8034b7:	0f 85 c7 fb ff ff    	jne    803084 <insert_sorted_with_merge_freeList+0x303>
  8034bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034c1:	0f 85 bd fb ff ff    	jne    803084 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8034c7:	eb 01                	jmp    8034ca <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8034c9:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8034ca:	90                   	nop
  8034cb:	c9                   	leave  
  8034cc:	c3                   	ret    

008034cd <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8034cd:	55                   	push   %ebp
  8034ce:	89 e5                	mov    %esp,%ebp
  8034d0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8034d3:	8d 45 10             	lea    0x10(%ebp),%eax
  8034d6:	83 c0 04             	add    $0x4,%eax
  8034d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8034dc:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8034e1:	85 c0                	test   %eax,%eax
  8034e3:	74 16                	je     8034fb <_panic+0x2e>
		cprintf("%s: ", argv0);
  8034e5:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8034ea:	83 ec 08             	sub    $0x8,%esp
  8034ed:	50                   	push   %eax
  8034ee:	68 60 40 80 00       	push   $0x804060
  8034f3:	e8 6e d0 ff ff       	call   800566 <cprintf>
  8034f8:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8034fb:	a1 00 50 80 00       	mov    0x805000,%eax
  803500:	ff 75 0c             	pushl  0xc(%ebp)
  803503:	ff 75 08             	pushl  0x8(%ebp)
  803506:	50                   	push   %eax
  803507:	68 65 40 80 00       	push   $0x804065
  80350c:	e8 55 d0 ff ff       	call   800566 <cprintf>
  803511:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803514:	8b 45 10             	mov    0x10(%ebp),%eax
  803517:	83 ec 08             	sub    $0x8,%esp
  80351a:	ff 75 f4             	pushl  -0xc(%ebp)
  80351d:	50                   	push   %eax
  80351e:	e8 d8 cf ff ff       	call   8004fb <vcprintf>
  803523:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803526:	83 ec 08             	sub    $0x8,%esp
  803529:	6a 00                	push   $0x0
  80352b:	68 81 40 80 00       	push   $0x804081
  803530:	e8 c6 cf ff ff       	call   8004fb <vcprintf>
  803535:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803538:	e8 47 cf ff ff       	call   800484 <exit>

	// should not return here
	while (1) ;
  80353d:	eb fe                	jmp    80353d <_panic+0x70>

0080353f <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80353f:	55                   	push   %ebp
  803540:	89 e5                	mov    %esp,%ebp
  803542:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803545:	a1 20 50 80 00       	mov    0x805020,%eax
  80354a:	8b 50 74             	mov    0x74(%eax),%edx
  80354d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803550:	39 c2                	cmp    %eax,%edx
  803552:	74 14                	je     803568 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803554:	83 ec 04             	sub    $0x4,%esp
  803557:	68 84 40 80 00       	push   $0x804084
  80355c:	6a 26                	push   $0x26
  80355e:	68 d0 40 80 00       	push   $0x8040d0
  803563:	e8 65 ff ff ff       	call   8034cd <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803568:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80356f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803576:	e9 c2 00 00 00       	jmp    80363d <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80357b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80357e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803585:	8b 45 08             	mov    0x8(%ebp),%eax
  803588:	01 d0                	add    %edx,%eax
  80358a:	8b 00                	mov    (%eax),%eax
  80358c:	85 c0                	test   %eax,%eax
  80358e:	75 08                	jne    803598 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  803590:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803593:	e9 a2 00 00 00       	jmp    80363a <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  803598:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80359f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8035a6:	eb 69                	jmp    803611 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8035a8:	a1 20 50 80 00       	mov    0x805020,%eax
  8035ad:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8035b3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8035b6:	89 d0                	mov    %edx,%eax
  8035b8:	01 c0                	add    %eax,%eax
  8035ba:	01 d0                	add    %edx,%eax
  8035bc:	c1 e0 03             	shl    $0x3,%eax
  8035bf:	01 c8                	add    %ecx,%eax
  8035c1:	8a 40 04             	mov    0x4(%eax),%al
  8035c4:	84 c0                	test   %al,%al
  8035c6:	75 46                	jne    80360e <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8035c8:	a1 20 50 80 00       	mov    0x805020,%eax
  8035cd:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8035d3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8035d6:	89 d0                	mov    %edx,%eax
  8035d8:	01 c0                	add    %eax,%eax
  8035da:	01 d0                	add    %edx,%eax
  8035dc:	c1 e0 03             	shl    $0x3,%eax
  8035df:	01 c8                	add    %ecx,%eax
  8035e1:	8b 00                	mov    (%eax),%eax
  8035e3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8035e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035e9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8035ee:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8035f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035f3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8035fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8035fd:	01 c8                	add    %ecx,%eax
  8035ff:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803601:	39 c2                	cmp    %eax,%edx
  803603:	75 09                	jne    80360e <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  803605:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80360c:	eb 12                	jmp    803620 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80360e:	ff 45 e8             	incl   -0x18(%ebp)
  803611:	a1 20 50 80 00       	mov    0x805020,%eax
  803616:	8b 50 74             	mov    0x74(%eax),%edx
  803619:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80361c:	39 c2                	cmp    %eax,%edx
  80361e:	77 88                	ja     8035a8 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803620:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803624:	75 14                	jne    80363a <CheckWSWithoutLastIndex+0xfb>
			panic(
  803626:	83 ec 04             	sub    $0x4,%esp
  803629:	68 dc 40 80 00       	push   $0x8040dc
  80362e:	6a 3a                	push   $0x3a
  803630:	68 d0 40 80 00       	push   $0x8040d0
  803635:	e8 93 fe ff ff       	call   8034cd <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80363a:	ff 45 f0             	incl   -0x10(%ebp)
  80363d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803640:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803643:	0f 8c 32 ff ff ff    	jl     80357b <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803649:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803650:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803657:	eb 26                	jmp    80367f <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803659:	a1 20 50 80 00       	mov    0x805020,%eax
  80365e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803664:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803667:	89 d0                	mov    %edx,%eax
  803669:	01 c0                	add    %eax,%eax
  80366b:	01 d0                	add    %edx,%eax
  80366d:	c1 e0 03             	shl    $0x3,%eax
  803670:	01 c8                	add    %ecx,%eax
  803672:	8a 40 04             	mov    0x4(%eax),%al
  803675:	3c 01                	cmp    $0x1,%al
  803677:	75 03                	jne    80367c <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  803679:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80367c:	ff 45 e0             	incl   -0x20(%ebp)
  80367f:	a1 20 50 80 00       	mov    0x805020,%eax
  803684:	8b 50 74             	mov    0x74(%eax),%edx
  803687:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80368a:	39 c2                	cmp    %eax,%edx
  80368c:	77 cb                	ja     803659 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80368e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803691:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803694:	74 14                	je     8036aa <CheckWSWithoutLastIndex+0x16b>
		panic(
  803696:	83 ec 04             	sub    $0x4,%esp
  803699:	68 30 41 80 00       	push   $0x804130
  80369e:	6a 44                	push   $0x44
  8036a0:	68 d0 40 80 00       	push   $0x8040d0
  8036a5:	e8 23 fe ff ff       	call   8034cd <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8036aa:	90                   	nop
  8036ab:	c9                   	leave  
  8036ac:	c3                   	ret    
  8036ad:	66 90                	xchg   %ax,%ax
  8036af:	90                   	nop

008036b0 <__udivdi3>:
  8036b0:	55                   	push   %ebp
  8036b1:	57                   	push   %edi
  8036b2:	56                   	push   %esi
  8036b3:	53                   	push   %ebx
  8036b4:	83 ec 1c             	sub    $0x1c,%esp
  8036b7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8036bb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8036bf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8036c3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8036c7:	89 ca                	mov    %ecx,%edx
  8036c9:	89 f8                	mov    %edi,%eax
  8036cb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8036cf:	85 f6                	test   %esi,%esi
  8036d1:	75 2d                	jne    803700 <__udivdi3+0x50>
  8036d3:	39 cf                	cmp    %ecx,%edi
  8036d5:	77 65                	ja     80373c <__udivdi3+0x8c>
  8036d7:	89 fd                	mov    %edi,%ebp
  8036d9:	85 ff                	test   %edi,%edi
  8036db:	75 0b                	jne    8036e8 <__udivdi3+0x38>
  8036dd:	b8 01 00 00 00       	mov    $0x1,%eax
  8036e2:	31 d2                	xor    %edx,%edx
  8036e4:	f7 f7                	div    %edi
  8036e6:	89 c5                	mov    %eax,%ebp
  8036e8:	31 d2                	xor    %edx,%edx
  8036ea:	89 c8                	mov    %ecx,%eax
  8036ec:	f7 f5                	div    %ebp
  8036ee:	89 c1                	mov    %eax,%ecx
  8036f0:	89 d8                	mov    %ebx,%eax
  8036f2:	f7 f5                	div    %ebp
  8036f4:	89 cf                	mov    %ecx,%edi
  8036f6:	89 fa                	mov    %edi,%edx
  8036f8:	83 c4 1c             	add    $0x1c,%esp
  8036fb:	5b                   	pop    %ebx
  8036fc:	5e                   	pop    %esi
  8036fd:	5f                   	pop    %edi
  8036fe:	5d                   	pop    %ebp
  8036ff:	c3                   	ret    
  803700:	39 ce                	cmp    %ecx,%esi
  803702:	77 28                	ja     80372c <__udivdi3+0x7c>
  803704:	0f bd fe             	bsr    %esi,%edi
  803707:	83 f7 1f             	xor    $0x1f,%edi
  80370a:	75 40                	jne    80374c <__udivdi3+0x9c>
  80370c:	39 ce                	cmp    %ecx,%esi
  80370e:	72 0a                	jb     80371a <__udivdi3+0x6a>
  803710:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803714:	0f 87 9e 00 00 00    	ja     8037b8 <__udivdi3+0x108>
  80371a:	b8 01 00 00 00       	mov    $0x1,%eax
  80371f:	89 fa                	mov    %edi,%edx
  803721:	83 c4 1c             	add    $0x1c,%esp
  803724:	5b                   	pop    %ebx
  803725:	5e                   	pop    %esi
  803726:	5f                   	pop    %edi
  803727:	5d                   	pop    %ebp
  803728:	c3                   	ret    
  803729:	8d 76 00             	lea    0x0(%esi),%esi
  80372c:	31 ff                	xor    %edi,%edi
  80372e:	31 c0                	xor    %eax,%eax
  803730:	89 fa                	mov    %edi,%edx
  803732:	83 c4 1c             	add    $0x1c,%esp
  803735:	5b                   	pop    %ebx
  803736:	5e                   	pop    %esi
  803737:	5f                   	pop    %edi
  803738:	5d                   	pop    %ebp
  803739:	c3                   	ret    
  80373a:	66 90                	xchg   %ax,%ax
  80373c:	89 d8                	mov    %ebx,%eax
  80373e:	f7 f7                	div    %edi
  803740:	31 ff                	xor    %edi,%edi
  803742:	89 fa                	mov    %edi,%edx
  803744:	83 c4 1c             	add    $0x1c,%esp
  803747:	5b                   	pop    %ebx
  803748:	5e                   	pop    %esi
  803749:	5f                   	pop    %edi
  80374a:	5d                   	pop    %ebp
  80374b:	c3                   	ret    
  80374c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803751:	89 eb                	mov    %ebp,%ebx
  803753:	29 fb                	sub    %edi,%ebx
  803755:	89 f9                	mov    %edi,%ecx
  803757:	d3 e6                	shl    %cl,%esi
  803759:	89 c5                	mov    %eax,%ebp
  80375b:	88 d9                	mov    %bl,%cl
  80375d:	d3 ed                	shr    %cl,%ebp
  80375f:	89 e9                	mov    %ebp,%ecx
  803761:	09 f1                	or     %esi,%ecx
  803763:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803767:	89 f9                	mov    %edi,%ecx
  803769:	d3 e0                	shl    %cl,%eax
  80376b:	89 c5                	mov    %eax,%ebp
  80376d:	89 d6                	mov    %edx,%esi
  80376f:	88 d9                	mov    %bl,%cl
  803771:	d3 ee                	shr    %cl,%esi
  803773:	89 f9                	mov    %edi,%ecx
  803775:	d3 e2                	shl    %cl,%edx
  803777:	8b 44 24 08          	mov    0x8(%esp),%eax
  80377b:	88 d9                	mov    %bl,%cl
  80377d:	d3 e8                	shr    %cl,%eax
  80377f:	09 c2                	or     %eax,%edx
  803781:	89 d0                	mov    %edx,%eax
  803783:	89 f2                	mov    %esi,%edx
  803785:	f7 74 24 0c          	divl   0xc(%esp)
  803789:	89 d6                	mov    %edx,%esi
  80378b:	89 c3                	mov    %eax,%ebx
  80378d:	f7 e5                	mul    %ebp
  80378f:	39 d6                	cmp    %edx,%esi
  803791:	72 19                	jb     8037ac <__udivdi3+0xfc>
  803793:	74 0b                	je     8037a0 <__udivdi3+0xf0>
  803795:	89 d8                	mov    %ebx,%eax
  803797:	31 ff                	xor    %edi,%edi
  803799:	e9 58 ff ff ff       	jmp    8036f6 <__udivdi3+0x46>
  80379e:	66 90                	xchg   %ax,%ax
  8037a0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8037a4:	89 f9                	mov    %edi,%ecx
  8037a6:	d3 e2                	shl    %cl,%edx
  8037a8:	39 c2                	cmp    %eax,%edx
  8037aa:	73 e9                	jae    803795 <__udivdi3+0xe5>
  8037ac:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8037af:	31 ff                	xor    %edi,%edi
  8037b1:	e9 40 ff ff ff       	jmp    8036f6 <__udivdi3+0x46>
  8037b6:	66 90                	xchg   %ax,%ax
  8037b8:	31 c0                	xor    %eax,%eax
  8037ba:	e9 37 ff ff ff       	jmp    8036f6 <__udivdi3+0x46>
  8037bf:	90                   	nop

008037c0 <__umoddi3>:
  8037c0:	55                   	push   %ebp
  8037c1:	57                   	push   %edi
  8037c2:	56                   	push   %esi
  8037c3:	53                   	push   %ebx
  8037c4:	83 ec 1c             	sub    $0x1c,%esp
  8037c7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8037cb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8037cf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8037d3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8037d7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8037db:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8037df:	89 f3                	mov    %esi,%ebx
  8037e1:	89 fa                	mov    %edi,%edx
  8037e3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8037e7:	89 34 24             	mov    %esi,(%esp)
  8037ea:	85 c0                	test   %eax,%eax
  8037ec:	75 1a                	jne    803808 <__umoddi3+0x48>
  8037ee:	39 f7                	cmp    %esi,%edi
  8037f0:	0f 86 a2 00 00 00    	jbe    803898 <__umoddi3+0xd8>
  8037f6:	89 c8                	mov    %ecx,%eax
  8037f8:	89 f2                	mov    %esi,%edx
  8037fa:	f7 f7                	div    %edi
  8037fc:	89 d0                	mov    %edx,%eax
  8037fe:	31 d2                	xor    %edx,%edx
  803800:	83 c4 1c             	add    $0x1c,%esp
  803803:	5b                   	pop    %ebx
  803804:	5e                   	pop    %esi
  803805:	5f                   	pop    %edi
  803806:	5d                   	pop    %ebp
  803807:	c3                   	ret    
  803808:	39 f0                	cmp    %esi,%eax
  80380a:	0f 87 ac 00 00 00    	ja     8038bc <__umoddi3+0xfc>
  803810:	0f bd e8             	bsr    %eax,%ebp
  803813:	83 f5 1f             	xor    $0x1f,%ebp
  803816:	0f 84 ac 00 00 00    	je     8038c8 <__umoddi3+0x108>
  80381c:	bf 20 00 00 00       	mov    $0x20,%edi
  803821:	29 ef                	sub    %ebp,%edi
  803823:	89 fe                	mov    %edi,%esi
  803825:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803829:	89 e9                	mov    %ebp,%ecx
  80382b:	d3 e0                	shl    %cl,%eax
  80382d:	89 d7                	mov    %edx,%edi
  80382f:	89 f1                	mov    %esi,%ecx
  803831:	d3 ef                	shr    %cl,%edi
  803833:	09 c7                	or     %eax,%edi
  803835:	89 e9                	mov    %ebp,%ecx
  803837:	d3 e2                	shl    %cl,%edx
  803839:	89 14 24             	mov    %edx,(%esp)
  80383c:	89 d8                	mov    %ebx,%eax
  80383e:	d3 e0                	shl    %cl,%eax
  803840:	89 c2                	mov    %eax,%edx
  803842:	8b 44 24 08          	mov    0x8(%esp),%eax
  803846:	d3 e0                	shl    %cl,%eax
  803848:	89 44 24 04          	mov    %eax,0x4(%esp)
  80384c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803850:	89 f1                	mov    %esi,%ecx
  803852:	d3 e8                	shr    %cl,%eax
  803854:	09 d0                	or     %edx,%eax
  803856:	d3 eb                	shr    %cl,%ebx
  803858:	89 da                	mov    %ebx,%edx
  80385a:	f7 f7                	div    %edi
  80385c:	89 d3                	mov    %edx,%ebx
  80385e:	f7 24 24             	mull   (%esp)
  803861:	89 c6                	mov    %eax,%esi
  803863:	89 d1                	mov    %edx,%ecx
  803865:	39 d3                	cmp    %edx,%ebx
  803867:	0f 82 87 00 00 00    	jb     8038f4 <__umoddi3+0x134>
  80386d:	0f 84 91 00 00 00    	je     803904 <__umoddi3+0x144>
  803873:	8b 54 24 04          	mov    0x4(%esp),%edx
  803877:	29 f2                	sub    %esi,%edx
  803879:	19 cb                	sbb    %ecx,%ebx
  80387b:	89 d8                	mov    %ebx,%eax
  80387d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803881:	d3 e0                	shl    %cl,%eax
  803883:	89 e9                	mov    %ebp,%ecx
  803885:	d3 ea                	shr    %cl,%edx
  803887:	09 d0                	or     %edx,%eax
  803889:	89 e9                	mov    %ebp,%ecx
  80388b:	d3 eb                	shr    %cl,%ebx
  80388d:	89 da                	mov    %ebx,%edx
  80388f:	83 c4 1c             	add    $0x1c,%esp
  803892:	5b                   	pop    %ebx
  803893:	5e                   	pop    %esi
  803894:	5f                   	pop    %edi
  803895:	5d                   	pop    %ebp
  803896:	c3                   	ret    
  803897:	90                   	nop
  803898:	89 fd                	mov    %edi,%ebp
  80389a:	85 ff                	test   %edi,%edi
  80389c:	75 0b                	jne    8038a9 <__umoddi3+0xe9>
  80389e:	b8 01 00 00 00       	mov    $0x1,%eax
  8038a3:	31 d2                	xor    %edx,%edx
  8038a5:	f7 f7                	div    %edi
  8038a7:	89 c5                	mov    %eax,%ebp
  8038a9:	89 f0                	mov    %esi,%eax
  8038ab:	31 d2                	xor    %edx,%edx
  8038ad:	f7 f5                	div    %ebp
  8038af:	89 c8                	mov    %ecx,%eax
  8038b1:	f7 f5                	div    %ebp
  8038b3:	89 d0                	mov    %edx,%eax
  8038b5:	e9 44 ff ff ff       	jmp    8037fe <__umoddi3+0x3e>
  8038ba:	66 90                	xchg   %ax,%ax
  8038bc:	89 c8                	mov    %ecx,%eax
  8038be:	89 f2                	mov    %esi,%edx
  8038c0:	83 c4 1c             	add    $0x1c,%esp
  8038c3:	5b                   	pop    %ebx
  8038c4:	5e                   	pop    %esi
  8038c5:	5f                   	pop    %edi
  8038c6:	5d                   	pop    %ebp
  8038c7:	c3                   	ret    
  8038c8:	3b 04 24             	cmp    (%esp),%eax
  8038cb:	72 06                	jb     8038d3 <__umoddi3+0x113>
  8038cd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8038d1:	77 0f                	ja     8038e2 <__umoddi3+0x122>
  8038d3:	89 f2                	mov    %esi,%edx
  8038d5:	29 f9                	sub    %edi,%ecx
  8038d7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8038db:	89 14 24             	mov    %edx,(%esp)
  8038de:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8038e2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8038e6:	8b 14 24             	mov    (%esp),%edx
  8038e9:	83 c4 1c             	add    $0x1c,%esp
  8038ec:	5b                   	pop    %ebx
  8038ed:	5e                   	pop    %esi
  8038ee:	5f                   	pop    %edi
  8038ef:	5d                   	pop    %ebp
  8038f0:	c3                   	ret    
  8038f1:	8d 76 00             	lea    0x0(%esi),%esi
  8038f4:	2b 04 24             	sub    (%esp),%eax
  8038f7:	19 fa                	sbb    %edi,%edx
  8038f9:	89 d1                	mov    %edx,%ecx
  8038fb:	89 c6                	mov    %eax,%esi
  8038fd:	e9 71 ff ff ff       	jmp    803873 <__umoddi3+0xb3>
  803902:	66 90                	xchg   %ax,%ax
  803904:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803908:	72 ea                	jb     8038f4 <__umoddi3+0x134>
  80390a:	89 d9                	mov    %ebx,%ecx
  80390c:	e9 62 ff ff ff       	jmp    803873 <__umoddi3+0xb3>
