
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
  80003e:	e8 d9 1a 00 00       	call   801b1c <sys_getenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int32 parentenvID = sys_getparentenvid();
  800046:	e8 03 1b 00 00       	call   801b4e <sys_getparentenvid>
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
  80005f:	68 60 38 80 00       	push   $0x803860
  800064:	ff 75 ec             	pushl  -0x14(%ebp)
  800067:	e8 c5 15 00 00       	call   801631 <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	numOfElements = sget(parentenvID,"arrSize") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 64 38 80 00       	push   $0x803864
  80007a:	ff 75 ec             	pushl  -0x14(%ebp)
  80007d:	e8 af 15 00 00       	call   801631 <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//Get the check-finishing counter
	int *finishedCount = NULL;
  800088:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	finishedCount = sget(parentenvID,"finishedCount") ;
  80008f:	83 ec 08             	sub    $0x8,%esp
  800092:	68 6c 38 80 00       	push   $0x80386c
  800097:	ff 75 ec             	pushl  -0x14(%ebp)
  80009a:	e8 92 15 00 00       	call   801631 <sget>
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
  8000b3:	68 7a 38 80 00       	push   $0x80387a
  8000b8:	e8 c6 14 00 00       	call   801583 <smalloc>
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
  800112:	68 89 38 80 00       	push   $0x803889
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
  800166:	e8 16 1a 00 00       	call   801b81 <sys_get_virtual_time>
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
  8002f6:	68 a5 38 80 00       	push   $0x8038a5
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
  800318:	68 a7 38 80 00       	push   $0x8038a7
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
  800346:	68 ac 38 80 00       	push   $0x8038ac
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
  80035c:	e8 d4 17 00 00       	call   801b35 <sys_getenvindex>
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
  8003c7:	e8 76 15 00 00       	call   801942 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8003cc:	83 ec 0c             	sub    $0xc,%esp
  8003cf:	68 c8 38 80 00       	push   $0x8038c8
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
  8003f7:	68 f0 38 80 00       	push   $0x8038f0
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
  800428:	68 18 39 80 00       	push   $0x803918
  80042d:	e8 34 01 00 00       	call   800566 <cprintf>
  800432:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800435:	a1 20 50 80 00       	mov    0x805020,%eax
  80043a:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800440:	83 ec 08             	sub    $0x8,%esp
  800443:	50                   	push   %eax
  800444:	68 70 39 80 00       	push   $0x803970
  800449:	e8 18 01 00 00       	call   800566 <cprintf>
  80044e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800451:	83 ec 0c             	sub    $0xc,%esp
  800454:	68 c8 38 80 00       	push   $0x8038c8
  800459:	e8 08 01 00 00       	call   800566 <cprintf>
  80045e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800461:	e8 f6 14 00 00       	call   80195c <sys_enable_interrupt>

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
  800479:	e8 83 16 00 00       	call   801b01 <sys_destroy_env>
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
  80048a:	e8 d8 16 00 00       	call   801b67 <sys_exit_env>
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
  8004d8:	e8 b7 12 00 00       	call   801794 <sys_cputs>
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
  80054f:	e8 40 12 00 00       	call   801794 <sys_cputs>
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
  800599:	e8 a4 13 00 00       	call   801942 <sys_disable_interrupt>
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
  8005b9:	e8 9e 13 00 00       	call   80195c <sys_enable_interrupt>
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
  800603:	e8 f0 2f 00 00       	call   8035f8 <__udivdi3>
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
  800653:	e8 b0 30 00 00       	call   803708 <__umoddi3>
  800658:	83 c4 10             	add    $0x10,%esp
  80065b:	05 b4 3b 80 00       	add    $0x803bb4,%eax
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
  8007ae:	8b 04 85 d8 3b 80 00 	mov    0x803bd8(,%eax,4),%eax
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
  80088f:	8b 34 9d 20 3a 80 00 	mov    0x803a20(,%ebx,4),%esi
  800896:	85 f6                	test   %esi,%esi
  800898:	75 19                	jne    8008b3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80089a:	53                   	push   %ebx
  80089b:	68 c5 3b 80 00       	push   $0x803bc5
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
  8008b4:	68 ce 3b 80 00       	push   $0x803bce
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
  8008e1:	be d1 3b 80 00       	mov    $0x803bd1,%esi
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
  801307:	68 30 3d 80 00       	push   $0x803d30
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
  8013d7:	e8 fc 04 00 00       	call   8018d8 <sys_allocate_chunk>
  8013dc:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013df:	a1 20 51 80 00       	mov    0x805120,%eax
  8013e4:	83 ec 0c             	sub    $0xc,%esp
  8013e7:	50                   	push   %eax
  8013e8:	e8 71 0b 00 00       	call   801f5e <initialize_MemBlocksList>
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
  801415:	68 55 3d 80 00       	push   $0x803d55
  80141a:	6a 33                	push   $0x33
  80141c:	68 73 3d 80 00       	push   $0x803d73
  801421:	e8 f1 1f 00 00       	call   803417 <_panic>
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
  801494:	68 80 3d 80 00       	push   $0x803d80
  801499:	6a 34                	push   $0x34
  80149b:	68 73 3d 80 00       	push   $0x803d73
  8014a0:	e8 72 1f 00 00       	call   803417 <_panic>
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
  80152c:	e8 75 07 00 00       	call   801ca6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801531:	85 c0                	test   %eax,%eax
  801533:	74 11                	je     801546 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801535:	83 ec 0c             	sub    $0xc,%esp
  801538:	ff 75 e8             	pushl  -0x18(%ebp)
  80153b:	e8 e0 0d 00 00       	call   802320 <alloc_block_FF>
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
  801552:	e8 3c 0b 00 00       	call   802093 <insert_sorted_allocList>
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
  80156c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80156f:	83 ec 04             	sub    $0x4,%esp
  801572:	68 a4 3d 80 00       	push   $0x803da4
  801577:	6a 6f                	push   $0x6f
  801579:	68 73 3d 80 00       	push   $0x803d73
  80157e:	e8 94 1e 00 00       	call   803417 <_panic>

00801583 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801583:	55                   	push   %ebp
  801584:	89 e5                	mov    %esp,%ebp
  801586:	83 ec 38             	sub    $0x38,%esp
  801589:	8b 45 10             	mov    0x10(%ebp),%eax
  80158c:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80158f:	e8 5c fd ff ff       	call   8012f0 <InitializeUHeap>
	if (size == 0) return NULL ;
  801594:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801598:	75 0a                	jne    8015a4 <smalloc+0x21>
  80159a:	b8 00 00 00 00       	mov    $0x0,%eax
  80159f:	e9 8b 00 00 00       	jmp    80162f <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8015a4:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8015ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b1:	01 d0                	add    %edx,%eax
  8015b3:	48                   	dec    %eax
  8015b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8015b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8015bf:	f7 75 f0             	divl   -0x10(%ebp)
  8015c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015c5:	29 d0                	sub    %edx,%eax
  8015c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8015ca:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8015d1:	e8 d0 06 00 00       	call   801ca6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015d6:	85 c0                	test   %eax,%eax
  8015d8:	74 11                	je     8015eb <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  8015da:	83 ec 0c             	sub    $0xc,%esp
  8015dd:	ff 75 e8             	pushl  -0x18(%ebp)
  8015e0:	e8 3b 0d 00 00       	call   802320 <alloc_block_FF>
  8015e5:	83 c4 10             	add    $0x10,%esp
  8015e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  8015eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015ef:	74 39                	je     80162a <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8015f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f4:	8b 40 08             	mov    0x8(%eax),%eax
  8015f7:	89 c2                	mov    %eax,%edx
  8015f9:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8015fd:	52                   	push   %edx
  8015fe:	50                   	push   %eax
  8015ff:	ff 75 0c             	pushl  0xc(%ebp)
  801602:	ff 75 08             	pushl  0x8(%ebp)
  801605:	e8 21 04 00 00       	call   801a2b <sys_createSharedObject>
  80160a:	83 c4 10             	add    $0x10,%esp
  80160d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801610:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801614:	74 14                	je     80162a <smalloc+0xa7>
  801616:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  80161a:	74 0e                	je     80162a <smalloc+0xa7>
  80161c:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801620:	74 08                	je     80162a <smalloc+0xa7>
			return (void*) mem_block->sva;
  801622:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801625:	8b 40 08             	mov    0x8(%eax),%eax
  801628:	eb 05                	jmp    80162f <smalloc+0xac>
	}
	return NULL;
  80162a:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80162f:	c9                   	leave  
  801630:	c3                   	ret    

00801631 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801631:	55                   	push   %ebp
  801632:	89 e5                	mov    %esp,%ebp
  801634:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801637:	e8 b4 fc ff ff       	call   8012f0 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80163c:	83 ec 08             	sub    $0x8,%esp
  80163f:	ff 75 0c             	pushl  0xc(%ebp)
  801642:	ff 75 08             	pushl  0x8(%ebp)
  801645:	e8 0b 04 00 00       	call   801a55 <sys_getSizeOfSharedObject>
  80164a:	83 c4 10             	add    $0x10,%esp
  80164d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  801650:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  801654:	74 76                	je     8016cc <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801656:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80165d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801660:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801663:	01 d0                	add    %edx,%eax
  801665:	48                   	dec    %eax
  801666:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801669:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80166c:	ba 00 00 00 00       	mov    $0x0,%edx
  801671:	f7 75 ec             	divl   -0x14(%ebp)
  801674:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801677:	29 d0                	sub    %edx,%eax
  801679:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  80167c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801683:	e8 1e 06 00 00       	call   801ca6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801688:	85 c0                	test   %eax,%eax
  80168a:	74 11                	je     80169d <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  80168c:	83 ec 0c             	sub    $0xc,%esp
  80168f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801692:	e8 89 0c 00 00       	call   802320 <alloc_block_FF>
  801697:	83 c4 10             	add    $0x10,%esp
  80169a:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  80169d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016a1:	74 29                	je     8016cc <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  8016a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a6:	8b 40 08             	mov    0x8(%eax),%eax
  8016a9:	83 ec 04             	sub    $0x4,%esp
  8016ac:	50                   	push   %eax
  8016ad:	ff 75 0c             	pushl  0xc(%ebp)
  8016b0:	ff 75 08             	pushl  0x8(%ebp)
  8016b3:	e8 ba 03 00 00       	call   801a72 <sys_getSharedObject>
  8016b8:	83 c4 10             	add    $0x10,%esp
  8016bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  8016be:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  8016c2:	74 08                	je     8016cc <sget+0x9b>
				return (void *)mem_block->sva;
  8016c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c7:	8b 40 08             	mov    0x8(%eax),%eax
  8016ca:	eb 05                	jmp    8016d1 <sget+0xa0>
		}
	}
	return NULL;
  8016cc:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8016d1:	c9                   	leave  
  8016d2:	c3                   	ret    

008016d3 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8016d3:	55                   	push   %ebp
  8016d4:	89 e5                	mov    %esp,%ebp
  8016d6:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016d9:	e8 12 fc ff ff       	call   8012f0 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8016de:	83 ec 04             	sub    $0x4,%esp
  8016e1:	68 c8 3d 80 00       	push   $0x803dc8
  8016e6:	68 f1 00 00 00       	push   $0xf1
  8016eb:	68 73 3d 80 00       	push   $0x803d73
  8016f0:	e8 22 1d 00 00       	call   803417 <_panic>

008016f5 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8016f5:	55                   	push   %ebp
  8016f6:	89 e5                	mov    %esp,%ebp
  8016f8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8016fb:	83 ec 04             	sub    $0x4,%esp
  8016fe:	68 f0 3d 80 00       	push   $0x803df0
  801703:	68 05 01 00 00       	push   $0x105
  801708:	68 73 3d 80 00       	push   $0x803d73
  80170d:	e8 05 1d 00 00       	call   803417 <_panic>

00801712 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801712:	55                   	push   %ebp
  801713:	89 e5                	mov    %esp,%ebp
  801715:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801718:	83 ec 04             	sub    $0x4,%esp
  80171b:	68 14 3e 80 00       	push   $0x803e14
  801720:	68 10 01 00 00       	push   $0x110
  801725:	68 73 3d 80 00       	push   $0x803d73
  80172a:	e8 e8 1c 00 00       	call   803417 <_panic>

0080172f <shrink>:

}
void shrink(uint32 newSize)
{
  80172f:	55                   	push   %ebp
  801730:	89 e5                	mov    %esp,%ebp
  801732:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801735:	83 ec 04             	sub    $0x4,%esp
  801738:	68 14 3e 80 00       	push   $0x803e14
  80173d:	68 15 01 00 00       	push   $0x115
  801742:	68 73 3d 80 00       	push   $0x803d73
  801747:	e8 cb 1c 00 00       	call   803417 <_panic>

0080174c <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80174c:	55                   	push   %ebp
  80174d:	89 e5                	mov    %esp,%ebp
  80174f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801752:	83 ec 04             	sub    $0x4,%esp
  801755:	68 14 3e 80 00       	push   $0x803e14
  80175a:	68 1a 01 00 00       	push   $0x11a
  80175f:	68 73 3d 80 00       	push   $0x803d73
  801764:	e8 ae 1c 00 00       	call   803417 <_panic>

00801769 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801769:	55                   	push   %ebp
  80176a:	89 e5                	mov    %esp,%ebp
  80176c:	57                   	push   %edi
  80176d:	56                   	push   %esi
  80176e:	53                   	push   %ebx
  80176f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801772:	8b 45 08             	mov    0x8(%ebp),%eax
  801775:	8b 55 0c             	mov    0xc(%ebp),%edx
  801778:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80177b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80177e:	8b 7d 18             	mov    0x18(%ebp),%edi
  801781:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801784:	cd 30                	int    $0x30
  801786:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801789:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80178c:	83 c4 10             	add    $0x10,%esp
  80178f:	5b                   	pop    %ebx
  801790:	5e                   	pop    %esi
  801791:	5f                   	pop    %edi
  801792:	5d                   	pop    %ebp
  801793:	c3                   	ret    

00801794 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801794:	55                   	push   %ebp
  801795:	89 e5                	mov    %esp,%ebp
  801797:	83 ec 04             	sub    $0x4,%esp
  80179a:	8b 45 10             	mov    0x10(%ebp),%eax
  80179d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8017a0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a7:	6a 00                	push   $0x0
  8017a9:	6a 00                	push   $0x0
  8017ab:	52                   	push   %edx
  8017ac:	ff 75 0c             	pushl  0xc(%ebp)
  8017af:	50                   	push   %eax
  8017b0:	6a 00                	push   $0x0
  8017b2:	e8 b2 ff ff ff       	call   801769 <syscall>
  8017b7:	83 c4 18             	add    $0x18,%esp
}
  8017ba:	90                   	nop
  8017bb:	c9                   	leave  
  8017bc:	c3                   	ret    

008017bd <sys_cgetc>:

int
sys_cgetc(void)
{
  8017bd:	55                   	push   %ebp
  8017be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8017c0:	6a 00                	push   $0x0
  8017c2:	6a 00                	push   $0x0
  8017c4:	6a 00                	push   $0x0
  8017c6:	6a 00                	push   $0x0
  8017c8:	6a 00                	push   $0x0
  8017ca:	6a 01                	push   $0x1
  8017cc:	e8 98 ff ff ff       	call   801769 <syscall>
  8017d1:	83 c4 18             	add    $0x18,%esp
}
  8017d4:	c9                   	leave  
  8017d5:	c3                   	ret    

008017d6 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8017d6:	55                   	push   %ebp
  8017d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8017d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017df:	6a 00                	push   $0x0
  8017e1:	6a 00                	push   $0x0
  8017e3:	6a 00                	push   $0x0
  8017e5:	52                   	push   %edx
  8017e6:	50                   	push   %eax
  8017e7:	6a 05                	push   $0x5
  8017e9:	e8 7b ff ff ff       	call   801769 <syscall>
  8017ee:	83 c4 18             	add    $0x18,%esp
}
  8017f1:	c9                   	leave  
  8017f2:	c3                   	ret    

008017f3 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8017f3:	55                   	push   %ebp
  8017f4:	89 e5                	mov    %esp,%ebp
  8017f6:	56                   	push   %esi
  8017f7:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8017f8:	8b 75 18             	mov    0x18(%ebp),%esi
  8017fb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017fe:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801801:	8b 55 0c             	mov    0xc(%ebp),%edx
  801804:	8b 45 08             	mov    0x8(%ebp),%eax
  801807:	56                   	push   %esi
  801808:	53                   	push   %ebx
  801809:	51                   	push   %ecx
  80180a:	52                   	push   %edx
  80180b:	50                   	push   %eax
  80180c:	6a 06                	push   $0x6
  80180e:	e8 56 ff ff ff       	call   801769 <syscall>
  801813:	83 c4 18             	add    $0x18,%esp
}
  801816:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801819:	5b                   	pop    %ebx
  80181a:	5e                   	pop    %esi
  80181b:	5d                   	pop    %ebp
  80181c:	c3                   	ret    

0080181d <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80181d:	55                   	push   %ebp
  80181e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801820:	8b 55 0c             	mov    0xc(%ebp),%edx
  801823:	8b 45 08             	mov    0x8(%ebp),%eax
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	6a 00                	push   $0x0
  80182c:	52                   	push   %edx
  80182d:	50                   	push   %eax
  80182e:	6a 07                	push   $0x7
  801830:	e8 34 ff ff ff       	call   801769 <syscall>
  801835:	83 c4 18             	add    $0x18,%esp
}
  801838:	c9                   	leave  
  801839:	c3                   	ret    

0080183a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80183a:	55                   	push   %ebp
  80183b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80183d:	6a 00                	push   $0x0
  80183f:	6a 00                	push   $0x0
  801841:	6a 00                	push   $0x0
  801843:	ff 75 0c             	pushl  0xc(%ebp)
  801846:	ff 75 08             	pushl  0x8(%ebp)
  801849:	6a 08                	push   $0x8
  80184b:	e8 19 ff ff ff       	call   801769 <syscall>
  801850:	83 c4 18             	add    $0x18,%esp
}
  801853:	c9                   	leave  
  801854:	c3                   	ret    

00801855 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801855:	55                   	push   %ebp
  801856:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 09                	push   $0x9
  801864:	e8 00 ff ff ff       	call   801769 <syscall>
  801869:	83 c4 18             	add    $0x18,%esp
}
  80186c:	c9                   	leave  
  80186d:	c3                   	ret    

0080186e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80186e:	55                   	push   %ebp
  80186f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 0a                	push   $0xa
  80187d:	e8 e7 fe ff ff       	call   801769 <syscall>
  801882:	83 c4 18             	add    $0x18,%esp
}
  801885:	c9                   	leave  
  801886:	c3                   	ret    

00801887 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801887:	55                   	push   %ebp
  801888:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80188a:	6a 00                	push   $0x0
  80188c:	6a 00                	push   $0x0
  80188e:	6a 00                	push   $0x0
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	6a 0b                	push   $0xb
  801896:	e8 ce fe ff ff       	call   801769 <syscall>
  80189b:	83 c4 18             	add    $0x18,%esp
}
  80189e:	c9                   	leave  
  80189f:	c3                   	ret    

008018a0 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8018a0:	55                   	push   %ebp
  8018a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 00                	push   $0x0
  8018a9:	ff 75 0c             	pushl  0xc(%ebp)
  8018ac:	ff 75 08             	pushl  0x8(%ebp)
  8018af:	6a 0f                	push   $0xf
  8018b1:	e8 b3 fe ff ff       	call   801769 <syscall>
  8018b6:	83 c4 18             	add    $0x18,%esp
	return;
  8018b9:	90                   	nop
}
  8018ba:	c9                   	leave  
  8018bb:	c3                   	ret    

008018bc <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8018bc:	55                   	push   %ebp
  8018bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	ff 75 0c             	pushl  0xc(%ebp)
  8018c8:	ff 75 08             	pushl  0x8(%ebp)
  8018cb:	6a 10                	push   $0x10
  8018cd:	e8 97 fe ff ff       	call   801769 <syscall>
  8018d2:	83 c4 18             	add    $0x18,%esp
	return ;
  8018d5:	90                   	nop
}
  8018d6:	c9                   	leave  
  8018d7:	c3                   	ret    

008018d8 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8018d8:	55                   	push   %ebp
  8018d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	ff 75 10             	pushl  0x10(%ebp)
  8018e2:	ff 75 0c             	pushl  0xc(%ebp)
  8018e5:	ff 75 08             	pushl  0x8(%ebp)
  8018e8:	6a 11                	push   $0x11
  8018ea:	e8 7a fe ff ff       	call   801769 <syscall>
  8018ef:	83 c4 18             	add    $0x18,%esp
	return ;
  8018f2:	90                   	nop
}
  8018f3:	c9                   	leave  
  8018f4:	c3                   	ret    

008018f5 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8018f5:	55                   	push   %ebp
  8018f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	6a 0c                	push   $0xc
  801904:	e8 60 fe ff ff       	call   801769 <syscall>
  801909:	83 c4 18             	add    $0x18,%esp
}
  80190c:	c9                   	leave  
  80190d:	c3                   	ret    

0080190e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80190e:	55                   	push   %ebp
  80190f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	ff 75 08             	pushl  0x8(%ebp)
  80191c:	6a 0d                	push   $0xd
  80191e:	e8 46 fe ff ff       	call   801769 <syscall>
  801923:	83 c4 18             	add    $0x18,%esp
}
  801926:	c9                   	leave  
  801927:	c3                   	ret    

00801928 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801928:	55                   	push   %ebp
  801929:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	6a 0e                	push   $0xe
  801937:	e8 2d fe ff ff       	call   801769 <syscall>
  80193c:	83 c4 18             	add    $0x18,%esp
}
  80193f:	90                   	nop
  801940:	c9                   	leave  
  801941:	c3                   	ret    

00801942 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801942:	55                   	push   %ebp
  801943:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	6a 13                	push   $0x13
  801951:	e8 13 fe ff ff       	call   801769 <syscall>
  801956:	83 c4 18             	add    $0x18,%esp
}
  801959:	90                   	nop
  80195a:	c9                   	leave  
  80195b:	c3                   	ret    

0080195c <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	6a 14                	push   $0x14
  80196b:	e8 f9 fd ff ff       	call   801769 <syscall>
  801970:	83 c4 18             	add    $0x18,%esp
}
  801973:	90                   	nop
  801974:	c9                   	leave  
  801975:	c3                   	ret    

00801976 <sys_cputc>:


void
sys_cputc(const char c)
{
  801976:	55                   	push   %ebp
  801977:	89 e5                	mov    %esp,%ebp
  801979:	83 ec 04             	sub    $0x4,%esp
  80197c:	8b 45 08             	mov    0x8(%ebp),%eax
  80197f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801982:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	50                   	push   %eax
  80198f:	6a 15                	push   $0x15
  801991:	e8 d3 fd ff ff       	call   801769 <syscall>
  801996:	83 c4 18             	add    $0x18,%esp
}
  801999:	90                   	nop
  80199a:	c9                   	leave  
  80199b:	c3                   	ret    

0080199c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80199c:	55                   	push   %ebp
  80199d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 16                	push   $0x16
  8019ab:	e8 b9 fd ff ff       	call   801769 <syscall>
  8019b0:	83 c4 18             	add    $0x18,%esp
}
  8019b3:	90                   	nop
  8019b4:	c9                   	leave  
  8019b5:	c3                   	ret    

008019b6 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8019b6:	55                   	push   %ebp
  8019b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8019b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	ff 75 0c             	pushl  0xc(%ebp)
  8019c5:	50                   	push   %eax
  8019c6:	6a 17                	push   $0x17
  8019c8:	e8 9c fd ff ff       	call   801769 <syscall>
  8019cd:	83 c4 18             	add    $0x18,%esp
}
  8019d0:	c9                   	leave  
  8019d1:	c3                   	ret    

008019d2 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	52                   	push   %edx
  8019e2:	50                   	push   %eax
  8019e3:	6a 1a                	push   $0x1a
  8019e5:	e8 7f fd ff ff       	call   801769 <syscall>
  8019ea:	83 c4 18             	add    $0x18,%esp
}
  8019ed:	c9                   	leave  
  8019ee:	c3                   	ret    

008019ef <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019ef:	55                   	push   %ebp
  8019f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	52                   	push   %edx
  8019ff:	50                   	push   %eax
  801a00:	6a 18                	push   $0x18
  801a02:	e8 62 fd ff ff       	call   801769 <syscall>
  801a07:	83 c4 18             	add    $0x18,%esp
}
  801a0a:	90                   	nop
  801a0b:	c9                   	leave  
  801a0c:	c3                   	ret    

00801a0d <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a0d:	55                   	push   %ebp
  801a0e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a10:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a13:	8b 45 08             	mov    0x8(%ebp),%eax
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	52                   	push   %edx
  801a1d:	50                   	push   %eax
  801a1e:	6a 19                	push   $0x19
  801a20:	e8 44 fd ff ff       	call   801769 <syscall>
  801a25:	83 c4 18             	add    $0x18,%esp
}
  801a28:	90                   	nop
  801a29:	c9                   	leave  
  801a2a:	c3                   	ret    

00801a2b <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a2b:	55                   	push   %ebp
  801a2c:	89 e5                	mov    %esp,%ebp
  801a2e:	83 ec 04             	sub    $0x4,%esp
  801a31:	8b 45 10             	mov    0x10(%ebp),%eax
  801a34:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a37:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a3a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a41:	6a 00                	push   $0x0
  801a43:	51                   	push   %ecx
  801a44:	52                   	push   %edx
  801a45:	ff 75 0c             	pushl  0xc(%ebp)
  801a48:	50                   	push   %eax
  801a49:	6a 1b                	push   $0x1b
  801a4b:	e8 19 fd ff ff       	call   801769 <syscall>
  801a50:	83 c4 18             	add    $0x18,%esp
}
  801a53:	c9                   	leave  
  801a54:	c3                   	ret    

00801a55 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a55:	55                   	push   %ebp
  801a56:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a58:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	52                   	push   %edx
  801a65:	50                   	push   %eax
  801a66:	6a 1c                	push   $0x1c
  801a68:	e8 fc fc ff ff       	call   801769 <syscall>
  801a6d:	83 c4 18             	add    $0x18,%esp
}
  801a70:	c9                   	leave  
  801a71:	c3                   	ret    

00801a72 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a72:	55                   	push   %ebp
  801a73:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a75:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a78:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	51                   	push   %ecx
  801a83:	52                   	push   %edx
  801a84:	50                   	push   %eax
  801a85:	6a 1d                	push   $0x1d
  801a87:	e8 dd fc ff ff       	call   801769 <syscall>
  801a8c:	83 c4 18             	add    $0x18,%esp
}
  801a8f:	c9                   	leave  
  801a90:	c3                   	ret    

00801a91 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a91:	55                   	push   %ebp
  801a92:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a94:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a97:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	52                   	push   %edx
  801aa1:	50                   	push   %eax
  801aa2:	6a 1e                	push   $0x1e
  801aa4:	e8 c0 fc ff ff       	call   801769 <syscall>
  801aa9:	83 c4 18             	add    $0x18,%esp
}
  801aac:	c9                   	leave  
  801aad:	c3                   	ret    

00801aae <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801aae:	55                   	push   %ebp
  801aaf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 1f                	push   $0x1f
  801abd:	e8 a7 fc ff ff       	call   801769 <syscall>
  801ac2:	83 c4 18             	add    $0x18,%esp
}
  801ac5:	c9                   	leave  
  801ac6:	c3                   	ret    

00801ac7 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ac7:	55                   	push   %ebp
  801ac8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801aca:	8b 45 08             	mov    0x8(%ebp),%eax
  801acd:	6a 00                	push   $0x0
  801acf:	ff 75 14             	pushl  0x14(%ebp)
  801ad2:	ff 75 10             	pushl  0x10(%ebp)
  801ad5:	ff 75 0c             	pushl  0xc(%ebp)
  801ad8:	50                   	push   %eax
  801ad9:	6a 20                	push   $0x20
  801adb:	e8 89 fc ff ff       	call   801769 <syscall>
  801ae0:	83 c4 18             	add    $0x18,%esp
}
  801ae3:	c9                   	leave  
  801ae4:	c3                   	ret    

00801ae5 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801ae5:	55                   	push   %ebp
  801ae6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	6a 00                	push   $0x0
  801af3:	50                   	push   %eax
  801af4:	6a 21                	push   $0x21
  801af6:	e8 6e fc ff ff       	call   801769 <syscall>
  801afb:	83 c4 18             	add    $0x18,%esp
}
  801afe:	90                   	nop
  801aff:	c9                   	leave  
  801b00:	c3                   	ret    

00801b01 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b01:	55                   	push   %ebp
  801b02:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b04:	8b 45 08             	mov    0x8(%ebp),%eax
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	50                   	push   %eax
  801b10:	6a 22                	push   $0x22
  801b12:	e8 52 fc ff ff       	call   801769 <syscall>
  801b17:	83 c4 18             	add    $0x18,%esp
}
  801b1a:	c9                   	leave  
  801b1b:	c3                   	ret    

00801b1c <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b1c:	55                   	push   %ebp
  801b1d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 02                	push   $0x2
  801b2b:	e8 39 fc ff ff       	call   801769 <syscall>
  801b30:	83 c4 18             	add    $0x18,%esp
}
  801b33:	c9                   	leave  
  801b34:	c3                   	ret    

00801b35 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b35:	55                   	push   %ebp
  801b36:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 03                	push   $0x3
  801b44:	e8 20 fc ff ff       	call   801769 <syscall>
  801b49:	83 c4 18             	add    $0x18,%esp
}
  801b4c:	c9                   	leave  
  801b4d:	c3                   	ret    

00801b4e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 04                	push   $0x4
  801b5d:	e8 07 fc ff ff       	call   801769 <syscall>
  801b62:	83 c4 18             	add    $0x18,%esp
}
  801b65:	c9                   	leave  
  801b66:	c3                   	ret    

00801b67 <sys_exit_env>:


void sys_exit_env(void)
{
  801b67:	55                   	push   %ebp
  801b68:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	6a 23                	push   $0x23
  801b76:	e8 ee fb ff ff       	call   801769 <syscall>
  801b7b:	83 c4 18             	add    $0x18,%esp
}
  801b7e:	90                   	nop
  801b7f:	c9                   	leave  
  801b80:	c3                   	ret    

00801b81 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801b81:	55                   	push   %ebp
  801b82:	89 e5                	mov    %esp,%ebp
  801b84:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b87:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b8a:	8d 50 04             	lea    0x4(%eax),%edx
  801b8d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	52                   	push   %edx
  801b97:	50                   	push   %eax
  801b98:	6a 24                	push   $0x24
  801b9a:	e8 ca fb ff ff       	call   801769 <syscall>
  801b9f:	83 c4 18             	add    $0x18,%esp
	return result;
  801ba2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ba5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ba8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bab:	89 01                	mov    %eax,(%ecx)
  801bad:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb3:	c9                   	leave  
  801bb4:	c2 04 00             	ret    $0x4

00801bb7 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801bb7:	55                   	push   %ebp
  801bb8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	ff 75 10             	pushl  0x10(%ebp)
  801bc1:	ff 75 0c             	pushl  0xc(%ebp)
  801bc4:	ff 75 08             	pushl  0x8(%ebp)
  801bc7:	6a 12                	push   $0x12
  801bc9:	e8 9b fb ff ff       	call   801769 <syscall>
  801bce:	83 c4 18             	add    $0x18,%esp
	return ;
  801bd1:	90                   	nop
}
  801bd2:	c9                   	leave  
  801bd3:	c3                   	ret    

00801bd4 <sys_rcr2>:
uint32 sys_rcr2()
{
  801bd4:	55                   	push   %ebp
  801bd5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 25                	push   $0x25
  801be3:	e8 81 fb ff ff       	call   801769 <syscall>
  801be8:	83 c4 18             	add    $0x18,%esp
}
  801beb:	c9                   	leave  
  801bec:	c3                   	ret    

00801bed <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801bed:	55                   	push   %ebp
  801bee:	89 e5                	mov    %esp,%ebp
  801bf0:	83 ec 04             	sub    $0x4,%esp
  801bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801bf9:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	50                   	push   %eax
  801c06:	6a 26                	push   $0x26
  801c08:	e8 5c fb ff ff       	call   801769 <syscall>
  801c0d:	83 c4 18             	add    $0x18,%esp
	return ;
  801c10:	90                   	nop
}
  801c11:	c9                   	leave  
  801c12:	c3                   	ret    

00801c13 <rsttst>:
void rsttst()
{
  801c13:	55                   	push   %ebp
  801c14:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 28                	push   $0x28
  801c22:	e8 42 fb ff ff       	call   801769 <syscall>
  801c27:	83 c4 18             	add    $0x18,%esp
	return ;
  801c2a:	90                   	nop
}
  801c2b:	c9                   	leave  
  801c2c:	c3                   	ret    

00801c2d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c2d:	55                   	push   %ebp
  801c2e:	89 e5                	mov    %esp,%ebp
  801c30:	83 ec 04             	sub    $0x4,%esp
  801c33:	8b 45 14             	mov    0x14(%ebp),%eax
  801c36:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c39:	8b 55 18             	mov    0x18(%ebp),%edx
  801c3c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c40:	52                   	push   %edx
  801c41:	50                   	push   %eax
  801c42:	ff 75 10             	pushl  0x10(%ebp)
  801c45:	ff 75 0c             	pushl  0xc(%ebp)
  801c48:	ff 75 08             	pushl  0x8(%ebp)
  801c4b:	6a 27                	push   $0x27
  801c4d:	e8 17 fb ff ff       	call   801769 <syscall>
  801c52:	83 c4 18             	add    $0x18,%esp
	return ;
  801c55:	90                   	nop
}
  801c56:	c9                   	leave  
  801c57:	c3                   	ret    

00801c58 <chktst>:
void chktst(uint32 n)
{
  801c58:	55                   	push   %ebp
  801c59:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	ff 75 08             	pushl  0x8(%ebp)
  801c66:	6a 29                	push   $0x29
  801c68:	e8 fc fa ff ff       	call   801769 <syscall>
  801c6d:	83 c4 18             	add    $0x18,%esp
	return ;
  801c70:	90                   	nop
}
  801c71:	c9                   	leave  
  801c72:	c3                   	ret    

00801c73 <inctst>:

void inctst()
{
  801c73:	55                   	push   %ebp
  801c74:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 2a                	push   $0x2a
  801c82:	e8 e2 fa ff ff       	call   801769 <syscall>
  801c87:	83 c4 18             	add    $0x18,%esp
	return ;
  801c8a:	90                   	nop
}
  801c8b:	c9                   	leave  
  801c8c:	c3                   	ret    

00801c8d <gettst>:
uint32 gettst()
{
  801c8d:	55                   	push   %ebp
  801c8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 2b                	push   $0x2b
  801c9c:	e8 c8 fa ff ff       	call   801769 <syscall>
  801ca1:	83 c4 18             	add    $0x18,%esp
}
  801ca4:	c9                   	leave  
  801ca5:	c3                   	ret    

00801ca6 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801ca6:	55                   	push   %ebp
  801ca7:	89 e5                	mov    %esp,%ebp
  801ca9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 2c                	push   $0x2c
  801cb8:	e8 ac fa ff ff       	call   801769 <syscall>
  801cbd:	83 c4 18             	add    $0x18,%esp
  801cc0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801cc3:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801cc7:	75 07                	jne    801cd0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801cc9:	b8 01 00 00 00       	mov    $0x1,%eax
  801cce:	eb 05                	jmp    801cd5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801cd0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cd5:	c9                   	leave  
  801cd6:	c3                   	ret    

00801cd7 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801cd7:	55                   	push   %ebp
  801cd8:	89 e5                	mov    %esp,%ebp
  801cda:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cdd:	6a 00                	push   $0x0
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 2c                	push   $0x2c
  801ce9:	e8 7b fa ff ff       	call   801769 <syscall>
  801cee:	83 c4 18             	add    $0x18,%esp
  801cf1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801cf4:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801cf8:	75 07                	jne    801d01 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801cfa:	b8 01 00 00 00       	mov    $0x1,%eax
  801cff:	eb 05                	jmp    801d06 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d01:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d06:	c9                   	leave  
  801d07:	c3                   	ret    

00801d08 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d08:	55                   	push   %ebp
  801d09:	89 e5                	mov    %esp,%ebp
  801d0b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	6a 2c                	push   $0x2c
  801d1a:	e8 4a fa ff ff       	call   801769 <syscall>
  801d1f:	83 c4 18             	add    $0x18,%esp
  801d22:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d25:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d29:	75 07                	jne    801d32 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d2b:	b8 01 00 00 00       	mov    $0x1,%eax
  801d30:	eb 05                	jmp    801d37 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d32:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d37:	c9                   	leave  
  801d38:	c3                   	ret    

00801d39 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d39:	55                   	push   %ebp
  801d3a:	89 e5                	mov    %esp,%ebp
  801d3c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 2c                	push   $0x2c
  801d4b:	e8 19 fa ff ff       	call   801769 <syscall>
  801d50:	83 c4 18             	add    $0x18,%esp
  801d53:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d56:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d5a:	75 07                	jne    801d63 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d5c:	b8 01 00 00 00       	mov    $0x1,%eax
  801d61:	eb 05                	jmp    801d68 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d63:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d68:	c9                   	leave  
  801d69:	c3                   	ret    

00801d6a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d6a:	55                   	push   %ebp
  801d6b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	ff 75 08             	pushl  0x8(%ebp)
  801d78:	6a 2d                	push   $0x2d
  801d7a:	e8 ea f9 ff ff       	call   801769 <syscall>
  801d7f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d82:	90                   	nop
}
  801d83:	c9                   	leave  
  801d84:	c3                   	ret    

00801d85 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d85:	55                   	push   %ebp
  801d86:	89 e5                	mov    %esp,%ebp
  801d88:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d89:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d8c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d92:	8b 45 08             	mov    0x8(%ebp),%eax
  801d95:	6a 00                	push   $0x0
  801d97:	53                   	push   %ebx
  801d98:	51                   	push   %ecx
  801d99:	52                   	push   %edx
  801d9a:	50                   	push   %eax
  801d9b:	6a 2e                	push   $0x2e
  801d9d:	e8 c7 f9 ff ff       	call   801769 <syscall>
  801da2:	83 c4 18             	add    $0x18,%esp
}
  801da5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801da8:	c9                   	leave  
  801da9:	c3                   	ret    

00801daa <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801daa:	55                   	push   %ebp
  801dab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801dad:	8b 55 0c             	mov    0xc(%ebp),%edx
  801db0:	8b 45 08             	mov    0x8(%ebp),%eax
  801db3:	6a 00                	push   $0x0
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	52                   	push   %edx
  801dba:	50                   	push   %eax
  801dbb:	6a 2f                	push   $0x2f
  801dbd:	e8 a7 f9 ff ff       	call   801769 <syscall>
  801dc2:	83 c4 18             	add    $0x18,%esp
}
  801dc5:	c9                   	leave  
  801dc6:	c3                   	ret    

00801dc7 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801dc7:	55                   	push   %ebp
  801dc8:	89 e5                	mov    %esp,%ebp
  801dca:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801dcd:	83 ec 0c             	sub    $0xc,%esp
  801dd0:	68 24 3e 80 00       	push   $0x803e24
  801dd5:	e8 8c e7 ff ff       	call   800566 <cprintf>
  801dda:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801ddd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801de4:	83 ec 0c             	sub    $0xc,%esp
  801de7:	68 50 3e 80 00       	push   $0x803e50
  801dec:	e8 75 e7 ff ff       	call   800566 <cprintf>
  801df1:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801df4:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801df8:	a1 38 51 80 00       	mov    0x805138,%eax
  801dfd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e00:	eb 56                	jmp    801e58 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e02:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e06:	74 1c                	je     801e24 <print_mem_block_lists+0x5d>
  801e08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e0b:	8b 50 08             	mov    0x8(%eax),%edx
  801e0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e11:	8b 48 08             	mov    0x8(%eax),%ecx
  801e14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e17:	8b 40 0c             	mov    0xc(%eax),%eax
  801e1a:	01 c8                	add    %ecx,%eax
  801e1c:	39 c2                	cmp    %eax,%edx
  801e1e:	73 04                	jae    801e24 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801e20:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e27:	8b 50 08             	mov    0x8(%eax),%edx
  801e2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e2d:	8b 40 0c             	mov    0xc(%eax),%eax
  801e30:	01 c2                	add    %eax,%edx
  801e32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e35:	8b 40 08             	mov    0x8(%eax),%eax
  801e38:	83 ec 04             	sub    $0x4,%esp
  801e3b:	52                   	push   %edx
  801e3c:	50                   	push   %eax
  801e3d:	68 65 3e 80 00       	push   $0x803e65
  801e42:	e8 1f e7 ff ff       	call   800566 <cprintf>
  801e47:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e50:	a1 40 51 80 00       	mov    0x805140,%eax
  801e55:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e58:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e5c:	74 07                	je     801e65 <print_mem_block_lists+0x9e>
  801e5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e61:	8b 00                	mov    (%eax),%eax
  801e63:	eb 05                	jmp    801e6a <print_mem_block_lists+0xa3>
  801e65:	b8 00 00 00 00       	mov    $0x0,%eax
  801e6a:	a3 40 51 80 00       	mov    %eax,0x805140
  801e6f:	a1 40 51 80 00       	mov    0x805140,%eax
  801e74:	85 c0                	test   %eax,%eax
  801e76:	75 8a                	jne    801e02 <print_mem_block_lists+0x3b>
  801e78:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e7c:	75 84                	jne    801e02 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801e7e:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e82:	75 10                	jne    801e94 <print_mem_block_lists+0xcd>
  801e84:	83 ec 0c             	sub    $0xc,%esp
  801e87:	68 74 3e 80 00       	push   $0x803e74
  801e8c:	e8 d5 e6 ff ff       	call   800566 <cprintf>
  801e91:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801e94:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801e9b:	83 ec 0c             	sub    $0xc,%esp
  801e9e:	68 98 3e 80 00       	push   $0x803e98
  801ea3:	e8 be e6 ff ff       	call   800566 <cprintf>
  801ea8:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801eab:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801eaf:	a1 40 50 80 00       	mov    0x805040,%eax
  801eb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801eb7:	eb 56                	jmp    801f0f <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801eb9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ebd:	74 1c                	je     801edb <print_mem_block_lists+0x114>
  801ebf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec2:	8b 50 08             	mov    0x8(%eax),%edx
  801ec5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ec8:	8b 48 08             	mov    0x8(%eax),%ecx
  801ecb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ece:	8b 40 0c             	mov    0xc(%eax),%eax
  801ed1:	01 c8                	add    %ecx,%eax
  801ed3:	39 c2                	cmp    %eax,%edx
  801ed5:	73 04                	jae    801edb <print_mem_block_lists+0x114>
			sorted = 0 ;
  801ed7:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801edb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ede:	8b 50 08             	mov    0x8(%eax),%edx
  801ee1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee4:	8b 40 0c             	mov    0xc(%eax),%eax
  801ee7:	01 c2                	add    %eax,%edx
  801ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eec:	8b 40 08             	mov    0x8(%eax),%eax
  801eef:	83 ec 04             	sub    $0x4,%esp
  801ef2:	52                   	push   %edx
  801ef3:	50                   	push   %eax
  801ef4:	68 65 3e 80 00       	push   $0x803e65
  801ef9:	e8 68 e6 ff ff       	call   800566 <cprintf>
  801efe:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f04:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f07:	a1 48 50 80 00       	mov    0x805048,%eax
  801f0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f0f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f13:	74 07                	je     801f1c <print_mem_block_lists+0x155>
  801f15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f18:	8b 00                	mov    (%eax),%eax
  801f1a:	eb 05                	jmp    801f21 <print_mem_block_lists+0x15a>
  801f1c:	b8 00 00 00 00       	mov    $0x0,%eax
  801f21:	a3 48 50 80 00       	mov    %eax,0x805048
  801f26:	a1 48 50 80 00       	mov    0x805048,%eax
  801f2b:	85 c0                	test   %eax,%eax
  801f2d:	75 8a                	jne    801eb9 <print_mem_block_lists+0xf2>
  801f2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f33:	75 84                	jne    801eb9 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801f35:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f39:	75 10                	jne    801f4b <print_mem_block_lists+0x184>
  801f3b:	83 ec 0c             	sub    $0xc,%esp
  801f3e:	68 b0 3e 80 00       	push   $0x803eb0
  801f43:	e8 1e e6 ff ff       	call   800566 <cprintf>
  801f48:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801f4b:	83 ec 0c             	sub    $0xc,%esp
  801f4e:	68 24 3e 80 00       	push   $0x803e24
  801f53:	e8 0e e6 ff ff       	call   800566 <cprintf>
  801f58:	83 c4 10             	add    $0x10,%esp

}
  801f5b:	90                   	nop
  801f5c:	c9                   	leave  
  801f5d:	c3                   	ret    

00801f5e <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801f5e:	55                   	push   %ebp
  801f5f:	89 e5                	mov    %esp,%ebp
  801f61:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801f64:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801f6b:	00 00 00 
  801f6e:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801f75:	00 00 00 
  801f78:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801f7f:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801f82:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801f89:	e9 9e 00 00 00       	jmp    80202c <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801f8e:	a1 50 50 80 00       	mov    0x805050,%eax
  801f93:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f96:	c1 e2 04             	shl    $0x4,%edx
  801f99:	01 d0                	add    %edx,%eax
  801f9b:	85 c0                	test   %eax,%eax
  801f9d:	75 14                	jne    801fb3 <initialize_MemBlocksList+0x55>
  801f9f:	83 ec 04             	sub    $0x4,%esp
  801fa2:	68 d8 3e 80 00       	push   $0x803ed8
  801fa7:	6a 46                	push   $0x46
  801fa9:	68 fb 3e 80 00       	push   $0x803efb
  801fae:	e8 64 14 00 00       	call   803417 <_panic>
  801fb3:	a1 50 50 80 00       	mov    0x805050,%eax
  801fb8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fbb:	c1 e2 04             	shl    $0x4,%edx
  801fbe:	01 d0                	add    %edx,%eax
  801fc0:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801fc6:	89 10                	mov    %edx,(%eax)
  801fc8:	8b 00                	mov    (%eax),%eax
  801fca:	85 c0                	test   %eax,%eax
  801fcc:	74 18                	je     801fe6 <initialize_MemBlocksList+0x88>
  801fce:	a1 48 51 80 00       	mov    0x805148,%eax
  801fd3:	8b 15 50 50 80 00    	mov    0x805050,%edx
  801fd9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801fdc:	c1 e1 04             	shl    $0x4,%ecx
  801fdf:	01 ca                	add    %ecx,%edx
  801fe1:	89 50 04             	mov    %edx,0x4(%eax)
  801fe4:	eb 12                	jmp    801ff8 <initialize_MemBlocksList+0x9a>
  801fe6:	a1 50 50 80 00       	mov    0x805050,%eax
  801feb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fee:	c1 e2 04             	shl    $0x4,%edx
  801ff1:	01 d0                	add    %edx,%eax
  801ff3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801ff8:	a1 50 50 80 00       	mov    0x805050,%eax
  801ffd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802000:	c1 e2 04             	shl    $0x4,%edx
  802003:	01 d0                	add    %edx,%eax
  802005:	a3 48 51 80 00       	mov    %eax,0x805148
  80200a:	a1 50 50 80 00       	mov    0x805050,%eax
  80200f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802012:	c1 e2 04             	shl    $0x4,%edx
  802015:	01 d0                	add    %edx,%eax
  802017:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80201e:	a1 54 51 80 00       	mov    0x805154,%eax
  802023:	40                   	inc    %eax
  802024:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802029:	ff 45 f4             	incl   -0xc(%ebp)
  80202c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802032:	0f 82 56 ff ff ff    	jb     801f8e <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802038:	90                   	nop
  802039:	c9                   	leave  
  80203a:	c3                   	ret    

0080203b <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80203b:	55                   	push   %ebp
  80203c:	89 e5                	mov    %esp,%ebp
  80203e:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802041:	8b 45 08             	mov    0x8(%ebp),%eax
  802044:	8b 00                	mov    (%eax),%eax
  802046:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802049:	eb 19                	jmp    802064 <find_block+0x29>
	{
		if(va==point->sva)
  80204b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80204e:	8b 40 08             	mov    0x8(%eax),%eax
  802051:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802054:	75 05                	jne    80205b <find_block+0x20>
		   return point;
  802056:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802059:	eb 36                	jmp    802091 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80205b:	8b 45 08             	mov    0x8(%ebp),%eax
  80205e:	8b 40 08             	mov    0x8(%eax),%eax
  802061:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802064:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802068:	74 07                	je     802071 <find_block+0x36>
  80206a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80206d:	8b 00                	mov    (%eax),%eax
  80206f:	eb 05                	jmp    802076 <find_block+0x3b>
  802071:	b8 00 00 00 00       	mov    $0x0,%eax
  802076:	8b 55 08             	mov    0x8(%ebp),%edx
  802079:	89 42 08             	mov    %eax,0x8(%edx)
  80207c:	8b 45 08             	mov    0x8(%ebp),%eax
  80207f:	8b 40 08             	mov    0x8(%eax),%eax
  802082:	85 c0                	test   %eax,%eax
  802084:	75 c5                	jne    80204b <find_block+0x10>
  802086:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80208a:	75 bf                	jne    80204b <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  80208c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802091:	c9                   	leave  
  802092:	c3                   	ret    

00802093 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802093:	55                   	push   %ebp
  802094:	89 e5                	mov    %esp,%ebp
  802096:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802099:	a1 40 50 80 00       	mov    0x805040,%eax
  80209e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8020a1:	a1 44 50 80 00       	mov    0x805044,%eax
  8020a6:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8020a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ac:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8020af:	74 24                	je     8020d5 <insert_sorted_allocList+0x42>
  8020b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b4:	8b 50 08             	mov    0x8(%eax),%edx
  8020b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ba:	8b 40 08             	mov    0x8(%eax),%eax
  8020bd:	39 c2                	cmp    %eax,%edx
  8020bf:	76 14                	jbe    8020d5 <insert_sorted_allocList+0x42>
  8020c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c4:	8b 50 08             	mov    0x8(%eax),%edx
  8020c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020ca:	8b 40 08             	mov    0x8(%eax),%eax
  8020cd:	39 c2                	cmp    %eax,%edx
  8020cf:	0f 82 60 01 00 00    	jb     802235 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8020d5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020d9:	75 65                	jne    802140 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8020db:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020df:	75 14                	jne    8020f5 <insert_sorted_allocList+0x62>
  8020e1:	83 ec 04             	sub    $0x4,%esp
  8020e4:	68 d8 3e 80 00       	push   $0x803ed8
  8020e9:	6a 6b                	push   $0x6b
  8020eb:	68 fb 3e 80 00       	push   $0x803efb
  8020f0:	e8 22 13 00 00       	call   803417 <_panic>
  8020f5:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8020fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fe:	89 10                	mov    %edx,(%eax)
  802100:	8b 45 08             	mov    0x8(%ebp),%eax
  802103:	8b 00                	mov    (%eax),%eax
  802105:	85 c0                	test   %eax,%eax
  802107:	74 0d                	je     802116 <insert_sorted_allocList+0x83>
  802109:	a1 40 50 80 00       	mov    0x805040,%eax
  80210e:	8b 55 08             	mov    0x8(%ebp),%edx
  802111:	89 50 04             	mov    %edx,0x4(%eax)
  802114:	eb 08                	jmp    80211e <insert_sorted_allocList+0x8b>
  802116:	8b 45 08             	mov    0x8(%ebp),%eax
  802119:	a3 44 50 80 00       	mov    %eax,0x805044
  80211e:	8b 45 08             	mov    0x8(%ebp),%eax
  802121:	a3 40 50 80 00       	mov    %eax,0x805040
  802126:	8b 45 08             	mov    0x8(%ebp),%eax
  802129:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802130:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802135:	40                   	inc    %eax
  802136:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80213b:	e9 dc 01 00 00       	jmp    80231c <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802140:	8b 45 08             	mov    0x8(%ebp),%eax
  802143:	8b 50 08             	mov    0x8(%eax),%edx
  802146:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802149:	8b 40 08             	mov    0x8(%eax),%eax
  80214c:	39 c2                	cmp    %eax,%edx
  80214e:	77 6c                	ja     8021bc <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802150:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802154:	74 06                	je     80215c <insert_sorted_allocList+0xc9>
  802156:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80215a:	75 14                	jne    802170 <insert_sorted_allocList+0xdd>
  80215c:	83 ec 04             	sub    $0x4,%esp
  80215f:	68 14 3f 80 00       	push   $0x803f14
  802164:	6a 6f                	push   $0x6f
  802166:	68 fb 3e 80 00       	push   $0x803efb
  80216b:	e8 a7 12 00 00       	call   803417 <_panic>
  802170:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802173:	8b 50 04             	mov    0x4(%eax),%edx
  802176:	8b 45 08             	mov    0x8(%ebp),%eax
  802179:	89 50 04             	mov    %edx,0x4(%eax)
  80217c:	8b 45 08             	mov    0x8(%ebp),%eax
  80217f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802182:	89 10                	mov    %edx,(%eax)
  802184:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802187:	8b 40 04             	mov    0x4(%eax),%eax
  80218a:	85 c0                	test   %eax,%eax
  80218c:	74 0d                	je     80219b <insert_sorted_allocList+0x108>
  80218e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802191:	8b 40 04             	mov    0x4(%eax),%eax
  802194:	8b 55 08             	mov    0x8(%ebp),%edx
  802197:	89 10                	mov    %edx,(%eax)
  802199:	eb 08                	jmp    8021a3 <insert_sorted_allocList+0x110>
  80219b:	8b 45 08             	mov    0x8(%ebp),%eax
  80219e:	a3 40 50 80 00       	mov    %eax,0x805040
  8021a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8021a9:	89 50 04             	mov    %edx,0x4(%eax)
  8021ac:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021b1:	40                   	inc    %eax
  8021b2:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021b7:	e9 60 01 00 00       	jmp    80231c <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8021bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bf:	8b 50 08             	mov    0x8(%eax),%edx
  8021c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021c5:	8b 40 08             	mov    0x8(%eax),%eax
  8021c8:	39 c2                	cmp    %eax,%edx
  8021ca:	0f 82 4c 01 00 00    	jb     80231c <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8021d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021d4:	75 14                	jne    8021ea <insert_sorted_allocList+0x157>
  8021d6:	83 ec 04             	sub    $0x4,%esp
  8021d9:	68 4c 3f 80 00       	push   $0x803f4c
  8021de:	6a 73                	push   $0x73
  8021e0:	68 fb 3e 80 00       	push   $0x803efb
  8021e5:	e8 2d 12 00 00       	call   803417 <_panic>
  8021ea:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8021f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f3:	89 50 04             	mov    %edx,0x4(%eax)
  8021f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f9:	8b 40 04             	mov    0x4(%eax),%eax
  8021fc:	85 c0                	test   %eax,%eax
  8021fe:	74 0c                	je     80220c <insert_sorted_allocList+0x179>
  802200:	a1 44 50 80 00       	mov    0x805044,%eax
  802205:	8b 55 08             	mov    0x8(%ebp),%edx
  802208:	89 10                	mov    %edx,(%eax)
  80220a:	eb 08                	jmp    802214 <insert_sorted_allocList+0x181>
  80220c:	8b 45 08             	mov    0x8(%ebp),%eax
  80220f:	a3 40 50 80 00       	mov    %eax,0x805040
  802214:	8b 45 08             	mov    0x8(%ebp),%eax
  802217:	a3 44 50 80 00       	mov    %eax,0x805044
  80221c:	8b 45 08             	mov    0x8(%ebp),%eax
  80221f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802225:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80222a:	40                   	inc    %eax
  80222b:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802230:	e9 e7 00 00 00       	jmp    80231c <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802235:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802238:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80223b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802242:	a1 40 50 80 00       	mov    0x805040,%eax
  802247:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80224a:	e9 9d 00 00 00       	jmp    8022ec <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80224f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802252:	8b 00                	mov    (%eax),%eax
  802254:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802257:	8b 45 08             	mov    0x8(%ebp),%eax
  80225a:	8b 50 08             	mov    0x8(%eax),%edx
  80225d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802260:	8b 40 08             	mov    0x8(%eax),%eax
  802263:	39 c2                	cmp    %eax,%edx
  802265:	76 7d                	jbe    8022e4 <insert_sorted_allocList+0x251>
  802267:	8b 45 08             	mov    0x8(%ebp),%eax
  80226a:	8b 50 08             	mov    0x8(%eax),%edx
  80226d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802270:	8b 40 08             	mov    0x8(%eax),%eax
  802273:	39 c2                	cmp    %eax,%edx
  802275:	73 6d                	jae    8022e4 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802277:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80227b:	74 06                	je     802283 <insert_sorted_allocList+0x1f0>
  80227d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802281:	75 14                	jne    802297 <insert_sorted_allocList+0x204>
  802283:	83 ec 04             	sub    $0x4,%esp
  802286:	68 70 3f 80 00       	push   $0x803f70
  80228b:	6a 7f                	push   $0x7f
  80228d:	68 fb 3e 80 00       	push   $0x803efb
  802292:	e8 80 11 00 00       	call   803417 <_panic>
  802297:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229a:	8b 10                	mov    (%eax),%edx
  80229c:	8b 45 08             	mov    0x8(%ebp),%eax
  80229f:	89 10                	mov    %edx,(%eax)
  8022a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a4:	8b 00                	mov    (%eax),%eax
  8022a6:	85 c0                	test   %eax,%eax
  8022a8:	74 0b                	je     8022b5 <insert_sorted_allocList+0x222>
  8022aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ad:	8b 00                	mov    (%eax),%eax
  8022af:	8b 55 08             	mov    0x8(%ebp),%edx
  8022b2:	89 50 04             	mov    %edx,0x4(%eax)
  8022b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8022bb:	89 10                	mov    %edx,(%eax)
  8022bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022c3:	89 50 04             	mov    %edx,0x4(%eax)
  8022c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c9:	8b 00                	mov    (%eax),%eax
  8022cb:	85 c0                	test   %eax,%eax
  8022cd:	75 08                	jne    8022d7 <insert_sorted_allocList+0x244>
  8022cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d2:	a3 44 50 80 00       	mov    %eax,0x805044
  8022d7:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022dc:	40                   	inc    %eax
  8022dd:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8022e2:	eb 39                	jmp    80231d <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8022e4:	a1 48 50 80 00       	mov    0x805048,%eax
  8022e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022f0:	74 07                	je     8022f9 <insert_sorted_allocList+0x266>
  8022f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f5:	8b 00                	mov    (%eax),%eax
  8022f7:	eb 05                	jmp    8022fe <insert_sorted_allocList+0x26b>
  8022f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8022fe:	a3 48 50 80 00       	mov    %eax,0x805048
  802303:	a1 48 50 80 00       	mov    0x805048,%eax
  802308:	85 c0                	test   %eax,%eax
  80230a:	0f 85 3f ff ff ff    	jne    80224f <insert_sorted_allocList+0x1bc>
  802310:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802314:	0f 85 35 ff ff ff    	jne    80224f <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80231a:	eb 01                	jmp    80231d <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80231c:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80231d:	90                   	nop
  80231e:	c9                   	leave  
  80231f:	c3                   	ret    

00802320 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802320:	55                   	push   %ebp
  802321:	89 e5                	mov    %esp,%ebp
  802323:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802326:	a1 38 51 80 00       	mov    0x805138,%eax
  80232b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80232e:	e9 85 01 00 00       	jmp    8024b8 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802333:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802336:	8b 40 0c             	mov    0xc(%eax),%eax
  802339:	3b 45 08             	cmp    0x8(%ebp),%eax
  80233c:	0f 82 6e 01 00 00    	jb     8024b0 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802342:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802345:	8b 40 0c             	mov    0xc(%eax),%eax
  802348:	3b 45 08             	cmp    0x8(%ebp),%eax
  80234b:	0f 85 8a 00 00 00    	jne    8023db <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802351:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802355:	75 17                	jne    80236e <alloc_block_FF+0x4e>
  802357:	83 ec 04             	sub    $0x4,%esp
  80235a:	68 a4 3f 80 00       	push   $0x803fa4
  80235f:	68 93 00 00 00       	push   $0x93
  802364:	68 fb 3e 80 00       	push   $0x803efb
  802369:	e8 a9 10 00 00       	call   803417 <_panic>
  80236e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802371:	8b 00                	mov    (%eax),%eax
  802373:	85 c0                	test   %eax,%eax
  802375:	74 10                	je     802387 <alloc_block_FF+0x67>
  802377:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237a:	8b 00                	mov    (%eax),%eax
  80237c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80237f:	8b 52 04             	mov    0x4(%edx),%edx
  802382:	89 50 04             	mov    %edx,0x4(%eax)
  802385:	eb 0b                	jmp    802392 <alloc_block_FF+0x72>
  802387:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238a:	8b 40 04             	mov    0x4(%eax),%eax
  80238d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802392:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802395:	8b 40 04             	mov    0x4(%eax),%eax
  802398:	85 c0                	test   %eax,%eax
  80239a:	74 0f                	je     8023ab <alloc_block_FF+0x8b>
  80239c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239f:	8b 40 04             	mov    0x4(%eax),%eax
  8023a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023a5:	8b 12                	mov    (%edx),%edx
  8023a7:	89 10                	mov    %edx,(%eax)
  8023a9:	eb 0a                	jmp    8023b5 <alloc_block_FF+0x95>
  8023ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ae:	8b 00                	mov    (%eax),%eax
  8023b0:	a3 38 51 80 00       	mov    %eax,0x805138
  8023b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023c8:	a1 44 51 80 00       	mov    0x805144,%eax
  8023cd:	48                   	dec    %eax
  8023ce:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8023d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d6:	e9 10 01 00 00       	jmp    8024eb <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8023db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023de:	8b 40 0c             	mov    0xc(%eax),%eax
  8023e1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023e4:	0f 86 c6 00 00 00    	jbe    8024b0 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8023ea:	a1 48 51 80 00       	mov    0x805148,%eax
  8023ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8023f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f5:	8b 50 08             	mov    0x8(%eax),%edx
  8023f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023fb:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8023fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802401:	8b 55 08             	mov    0x8(%ebp),%edx
  802404:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802407:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80240b:	75 17                	jne    802424 <alloc_block_FF+0x104>
  80240d:	83 ec 04             	sub    $0x4,%esp
  802410:	68 a4 3f 80 00       	push   $0x803fa4
  802415:	68 9b 00 00 00       	push   $0x9b
  80241a:	68 fb 3e 80 00       	push   $0x803efb
  80241f:	e8 f3 0f 00 00       	call   803417 <_panic>
  802424:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802427:	8b 00                	mov    (%eax),%eax
  802429:	85 c0                	test   %eax,%eax
  80242b:	74 10                	je     80243d <alloc_block_FF+0x11d>
  80242d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802430:	8b 00                	mov    (%eax),%eax
  802432:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802435:	8b 52 04             	mov    0x4(%edx),%edx
  802438:	89 50 04             	mov    %edx,0x4(%eax)
  80243b:	eb 0b                	jmp    802448 <alloc_block_FF+0x128>
  80243d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802440:	8b 40 04             	mov    0x4(%eax),%eax
  802443:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802448:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80244b:	8b 40 04             	mov    0x4(%eax),%eax
  80244e:	85 c0                	test   %eax,%eax
  802450:	74 0f                	je     802461 <alloc_block_FF+0x141>
  802452:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802455:	8b 40 04             	mov    0x4(%eax),%eax
  802458:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80245b:	8b 12                	mov    (%edx),%edx
  80245d:	89 10                	mov    %edx,(%eax)
  80245f:	eb 0a                	jmp    80246b <alloc_block_FF+0x14b>
  802461:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802464:	8b 00                	mov    (%eax),%eax
  802466:	a3 48 51 80 00       	mov    %eax,0x805148
  80246b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80246e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802474:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802477:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80247e:	a1 54 51 80 00       	mov    0x805154,%eax
  802483:	48                   	dec    %eax
  802484:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802489:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248c:	8b 50 08             	mov    0x8(%eax),%edx
  80248f:	8b 45 08             	mov    0x8(%ebp),%eax
  802492:	01 c2                	add    %eax,%edx
  802494:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802497:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  80249a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249d:	8b 40 0c             	mov    0xc(%eax),%eax
  8024a0:	2b 45 08             	sub    0x8(%ebp),%eax
  8024a3:	89 c2                	mov    %eax,%edx
  8024a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a8:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8024ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ae:	eb 3b                	jmp    8024eb <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8024b0:	a1 40 51 80 00       	mov    0x805140,%eax
  8024b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024bc:	74 07                	je     8024c5 <alloc_block_FF+0x1a5>
  8024be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c1:	8b 00                	mov    (%eax),%eax
  8024c3:	eb 05                	jmp    8024ca <alloc_block_FF+0x1aa>
  8024c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8024ca:	a3 40 51 80 00       	mov    %eax,0x805140
  8024cf:	a1 40 51 80 00       	mov    0x805140,%eax
  8024d4:	85 c0                	test   %eax,%eax
  8024d6:	0f 85 57 fe ff ff    	jne    802333 <alloc_block_FF+0x13>
  8024dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024e0:	0f 85 4d fe ff ff    	jne    802333 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8024e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024eb:	c9                   	leave  
  8024ec:	c3                   	ret    

008024ed <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8024ed:	55                   	push   %ebp
  8024ee:	89 e5                	mov    %esp,%ebp
  8024f0:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8024f3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8024fa:	a1 38 51 80 00       	mov    0x805138,%eax
  8024ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802502:	e9 df 00 00 00       	jmp    8025e6 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802507:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250a:	8b 40 0c             	mov    0xc(%eax),%eax
  80250d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802510:	0f 82 c8 00 00 00    	jb     8025de <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802516:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802519:	8b 40 0c             	mov    0xc(%eax),%eax
  80251c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80251f:	0f 85 8a 00 00 00    	jne    8025af <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802525:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802529:	75 17                	jne    802542 <alloc_block_BF+0x55>
  80252b:	83 ec 04             	sub    $0x4,%esp
  80252e:	68 a4 3f 80 00       	push   $0x803fa4
  802533:	68 b7 00 00 00       	push   $0xb7
  802538:	68 fb 3e 80 00       	push   $0x803efb
  80253d:	e8 d5 0e 00 00       	call   803417 <_panic>
  802542:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802545:	8b 00                	mov    (%eax),%eax
  802547:	85 c0                	test   %eax,%eax
  802549:	74 10                	je     80255b <alloc_block_BF+0x6e>
  80254b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254e:	8b 00                	mov    (%eax),%eax
  802550:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802553:	8b 52 04             	mov    0x4(%edx),%edx
  802556:	89 50 04             	mov    %edx,0x4(%eax)
  802559:	eb 0b                	jmp    802566 <alloc_block_BF+0x79>
  80255b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255e:	8b 40 04             	mov    0x4(%eax),%eax
  802561:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802566:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802569:	8b 40 04             	mov    0x4(%eax),%eax
  80256c:	85 c0                	test   %eax,%eax
  80256e:	74 0f                	je     80257f <alloc_block_BF+0x92>
  802570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802573:	8b 40 04             	mov    0x4(%eax),%eax
  802576:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802579:	8b 12                	mov    (%edx),%edx
  80257b:	89 10                	mov    %edx,(%eax)
  80257d:	eb 0a                	jmp    802589 <alloc_block_BF+0x9c>
  80257f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802582:	8b 00                	mov    (%eax),%eax
  802584:	a3 38 51 80 00       	mov    %eax,0x805138
  802589:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802592:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802595:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80259c:	a1 44 51 80 00       	mov    0x805144,%eax
  8025a1:	48                   	dec    %eax
  8025a2:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8025a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025aa:	e9 4d 01 00 00       	jmp    8026fc <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8025af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8025b5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025b8:	76 24                	jbe    8025de <alloc_block_BF+0xf1>
  8025ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8025c0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8025c3:	73 19                	jae    8025de <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8025c5:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8025cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8025d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8025d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d8:	8b 40 08             	mov    0x8(%eax),%eax
  8025db:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8025de:	a1 40 51 80 00       	mov    0x805140,%eax
  8025e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ea:	74 07                	je     8025f3 <alloc_block_BF+0x106>
  8025ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ef:	8b 00                	mov    (%eax),%eax
  8025f1:	eb 05                	jmp    8025f8 <alloc_block_BF+0x10b>
  8025f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8025f8:	a3 40 51 80 00       	mov    %eax,0x805140
  8025fd:	a1 40 51 80 00       	mov    0x805140,%eax
  802602:	85 c0                	test   %eax,%eax
  802604:	0f 85 fd fe ff ff    	jne    802507 <alloc_block_BF+0x1a>
  80260a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80260e:	0f 85 f3 fe ff ff    	jne    802507 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802614:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802618:	0f 84 d9 00 00 00    	je     8026f7 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  80261e:	a1 48 51 80 00       	mov    0x805148,%eax
  802623:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802626:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802629:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80262c:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  80262f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802632:	8b 55 08             	mov    0x8(%ebp),%edx
  802635:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802638:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80263c:	75 17                	jne    802655 <alloc_block_BF+0x168>
  80263e:	83 ec 04             	sub    $0x4,%esp
  802641:	68 a4 3f 80 00       	push   $0x803fa4
  802646:	68 c7 00 00 00       	push   $0xc7
  80264b:	68 fb 3e 80 00       	push   $0x803efb
  802650:	e8 c2 0d 00 00       	call   803417 <_panic>
  802655:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802658:	8b 00                	mov    (%eax),%eax
  80265a:	85 c0                	test   %eax,%eax
  80265c:	74 10                	je     80266e <alloc_block_BF+0x181>
  80265e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802661:	8b 00                	mov    (%eax),%eax
  802663:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802666:	8b 52 04             	mov    0x4(%edx),%edx
  802669:	89 50 04             	mov    %edx,0x4(%eax)
  80266c:	eb 0b                	jmp    802679 <alloc_block_BF+0x18c>
  80266e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802671:	8b 40 04             	mov    0x4(%eax),%eax
  802674:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802679:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80267c:	8b 40 04             	mov    0x4(%eax),%eax
  80267f:	85 c0                	test   %eax,%eax
  802681:	74 0f                	je     802692 <alloc_block_BF+0x1a5>
  802683:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802686:	8b 40 04             	mov    0x4(%eax),%eax
  802689:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80268c:	8b 12                	mov    (%edx),%edx
  80268e:	89 10                	mov    %edx,(%eax)
  802690:	eb 0a                	jmp    80269c <alloc_block_BF+0x1af>
  802692:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802695:	8b 00                	mov    (%eax),%eax
  802697:	a3 48 51 80 00       	mov    %eax,0x805148
  80269c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80269f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026a8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026af:	a1 54 51 80 00       	mov    0x805154,%eax
  8026b4:	48                   	dec    %eax
  8026b5:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8026ba:	83 ec 08             	sub    $0x8,%esp
  8026bd:	ff 75 ec             	pushl  -0x14(%ebp)
  8026c0:	68 38 51 80 00       	push   $0x805138
  8026c5:	e8 71 f9 ff ff       	call   80203b <find_block>
  8026ca:	83 c4 10             	add    $0x10,%esp
  8026cd:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8026d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026d3:	8b 50 08             	mov    0x8(%eax),%edx
  8026d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d9:	01 c2                	add    %eax,%edx
  8026db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026de:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8026e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8026e7:	2b 45 08             	sub    0x8(%ebp),%eax
  8026ea:	89 c2                	mov    %eax,%edx
  8026ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026ef:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8026f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026f5:	eb 05                	jmp    8026fc <alloc_block_BF+0x20f>
	}
	return NULL;
  8026f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026fc:	c9                   	leave  
  8026fd:	c3                   	ret    

008026fe <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8026fe:	55                   	push   %ebp
  8026ff:	89 e5                	mov    %esp,%ebp
  802701:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802704:	a1 28 50 80 00       	mov    0x805028,%eax
  802709:	85 c0                	test   %eax,%eax
  80270b:	0f 85 de 01 00 00    	jne    8028ef <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802711:	a1 38 51 80 00       	mov    0x805138,%eax
  802716:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802719:	e9 9e 01 00 00       	jmp    8028bc <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  80271e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802721:	8b 40 0c             	mov    0xc(%eax),%eax
  802724:	3b 45 08             	cmp    0x8(%ebp),%eax
  802727:	0f 82 87 01 00 00    	jb     8028b4 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  80272d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802730:	8b 40 0c             	mov    0xc(%eax),%eax
  802733:	3b 45 08             	cmp    0x8(%ebp),%eax
  802736:	0f 85 95 00 00 00    	jne    8027d1 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  80273c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802740:	75 17                	jne    802759 <alloc_block_NF+0x5b>
  802742:	83 ec 04             	sub    $0x4,%esp
  802745:	68 a4 3f 80 00       	push   $0x803fa4
  80274a:	68 e0 00 00 00       	push   $0xe0
  80274f:	68 fb 3e 80 00       	push   $0x803efb
  802754:	e8 be 0c 00 00       	call   803417 <_panic>
  802759:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275c:	8b 00                	mov    (%eax),%eax
  80275e:	85 c0                	test   %eax,%eax
  802760:	74 10                	je     802772 <alloc_block_NF+0x74>
  802762:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802765:	8b 00                	mov    (%eax),%eax
  802767:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80276a:	8b 52 04             	mov    0x4(%edx),%edx
  80276d:	89 50 04             	mov    %edx,0x4(%eax)
  802770:	eb 0b                	jmp    80277d <alloc_block_NF+0x7f>
  802772:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802775:	8b 40 04             	mov    0x4(%eax),%eax
  802778:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80277d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802780:	8b 40 04             	mov    0x4(%eax),%eax
  802783:	85 c0                	test   %eax,%eax
  802785:	74 0f                	je     802796 <alloc_block_NF+0x98>
  802787:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278a:	8b 40 04             	mov    0x4(%eax),%eax
  80278d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802790:	8b 12                	mov    (%edx),%edx
  802792:	89 10                	mov    %edx,(%eax)
  802794:	eb 0a                	jmp    8027a0 <alloc_block_NF+0xa2>
  802796:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802799:	8b 00                	mov    (%eax),%eax
  80279b:	a3 38 51 80 00       	mov    %eax,0x805138
  8027a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027b3:	a1 44 51 80 00       	mov    0x805144,%eax
  8027b8:	48                   	dec    %eax
  8027b9:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8027be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c1:	8b 40 08             	mov    0x8(%eax),%eax
  8027c4:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8027c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cc:	e9 f8 04 00 00       	jmp    802cc9 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8027d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8027d7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027da:	0f 86 d4 00 00 00    	jbe    8028b4 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8027e0:	a1 48 51 80 00       	mov    0x805148,%eax
  8027e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8027e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027eb:	8b 50 08             	mov    0x8(%eax),%edx
  8027ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f1:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8027f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8027fa:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8027fd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802801:	75 17                	jne    80281a <alloc_block_NF+0x11c>
  802803:	83 ec 04             	sub    $0x4,%esp
  802806:	68 a4 3f 80 00       	push   $0x803fa4
  80280b:	68 e9 00 00 00       	push   $0xe9
  802810:	68 fb 3e 80 00       	push   $0x803efb
  802815:	e8 fd 0b 00 00       	call   803417 <_panic>
  80281a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80281d:	8b 00                	mov    (%eax),%eax
  80281f:	85 c0                	test   %eax,%eax
  802821:	74 10                	je     802833 <alloc_block_NF+0x135>
  802823:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802826:	8b 00                	mov    (%eax),%eax
  802828:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80282b:	8b 52 04             	mov    0x4(%edx),%edx
  80282e:	89 50 04             	mov    %edx,0x4(%eax)
  802831:	eb 0b                	jmp    80283e <alloc_block_NF+0x140>
  802833:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802836:	8b 40 04             	mov    0x4(%eax),%eax
  802839:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80283e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802841:	8b 40 04             	mov    0x4(%eax),%eax
  802844:	85 c0                	test   %eax,%eax
  802846:	74 0f                	je     802857 <alloc_block_NF+0x159>
  802848:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80284b:	8b 40 04             	mov    0x4(%eax),%eax
  80284e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802851:	8b 12                	mov    (%edx),%edx
  802853:	89 10                	mov    %edx,(%eax)
  802855:	eb 0a                	jmp    802861 <alloc_block_NF+0x163>
  802857:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80285a:	8b 00                	mov    (%eax),%eax
  80285c:	a3 48 51 80 00       	mov    %eax,0x805148
  802861:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802864:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80286a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80286d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802874:	a1 54 51 80 00       	mov    0x805154,%eax
  802879:	48                   	dec    %eax
  80287a:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  80287f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802882:	8b 40 08             	mov    0x8(%eax),%eax
  802885:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  80288a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288d:	8b 50 08             	mov    0x8(%eax),%edx
  802890:	8b 45 08             	mov    0x8(%ebp),%eax
  802893:	01 c2                	add    %eax,%edx
  802895:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802898:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  80289b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289e:	8b 40 0c             	mov    0xc(%eax),%eax
  8028a1:	2b 45 08             	sub    0x8(%ebp),%eax
  8028a4:	89 c2                	mov    %eax,%edx
  8028a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a9:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8028ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028af:	e9 15 04 00 00       	jmp    802cc9 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8028b4:	a1 40 51 80 00       	mov    0x805140,%eax
  8028b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028c0:	74 07                	je     8028c9 <alloc_block_NF+0x1cb>
  8028c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c5:	8b 00                	mov    (%eax),%eax
  8028c7:	eb 05                	jmp    8028ce <alloc_block_NF+0x1d0>
  8028c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8028ce:	a3 40 51 80 00       	mov    %eax,0x805140
  8028d3:	a1 40 51 80 00       	mov    0x805140,%eax
  8028d8:	85 c0                	test   %eax,%eax
  8028da:	0f 85 3e fe ff ff    	jne    80271e <alloc_block_NF+0x20>
  8028e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028e4:	0f 85 34 fe ff ff    	jne    80271e <alloc_block_NF+0x20>
  8028ea:	e9 d5 03 00 00       	jmp    802cc4 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8028ef:	a1 38 51 80 00       	mov    0x805138,%eax
  8028f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028f7:	e9 b1 01 00 00       	jmp    802aad <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8028fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ff:	8b 50 08             	mov    0x8(%eax),%edx
  802902:	a1 28 50 80 00       	mov    0x805028,%eax
  802907:	39 c2                	cmp    %eax,%edx
  802909:	0f 82 96 01 00 00    	jb     802aa5 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  80290f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802912:	8b 40 0c             	mov    0xc(%eax),%eax
  802915:	3b 45 08             	cmp    0x8(%ebp),%eax
  802918:	0f 82 87 01 00 00    	jb     802aa5 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  80291e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802921:	8b 40 0c             	mov    0xc(%eax),%eax
  802924:	3b 45 08             	cmp    0x8(%ebp),%eax
  802927:	0f 85 95 00 00 00    	jne    8029c2 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80292d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802931:	75 17                	jne    80294a <alloc_block_NF+0x24c>
  802933:	83 ec 04             	sub    $0x4,%esp
  802936:	68 a4 3f 80 00       	push   $0x803fa4
  80293b:	68 fc 00 00 00       	push   $0xfc
  802940:	68 fb 3e 80 00       	push   $0x803efb
  802945:	e8 cd 0a 00 00       	call   803417 <_panic>
  80294a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294d:	8b 00                	mov    (%eax),%eax
  80294f:	85 c0                	test   %eax,%eax
  802951:	74 10                	je     802963 <alloc_block_NF+0x265>
  802953:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802956:	8b 00                	mov    (%eax),%eax
  802958:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80295b:	8b 52 04             	mov    0x4(%edx),%edx
  80295e:	89 50 04             	mov    %edx,0x4(%eax)
  802961:	eb 0b                	jmp    80296e <alloc_block_NF+0x270>
  802963:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802966:	8b 40 04             	mov    0x4(%eax),%eax
  802969:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80296e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802971:	8b 40 04             	mov    0x4(%eax),%eax
  802974:	85 c0                	test   %eax,%eax
  802976:	74 0f                	je     802987 <alloc_block_NF+0x289>
  802978:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297b:	8b 40 04             	mov    0x4(%eax),%eax
  80297e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802981:	8b 12                	mov    (%edx),%edx
  802983:	89 10                	mov    %edx,(%eax)
  802985:	eb 0a                	jmp    802991 <alloc_block_NF+0x293>
  802987:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298a:	8b 00                	mov    (%eax),%eax
  80298c:	a3 38 51 80 00       	mov    %eax,0x805138
  802991:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802994:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80299a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029a4:	a1 44 51 80 00       	mov    0x805144,%eax
  8029a9:	48                   	dec    %eax
  8029aa:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8029af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b2:	8b 40 08             	mov    0x8(%eax),%eax
  8029b5:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8029ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bd:	e9 07 03 00 00       	jmp    802cc9 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8029c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8029c8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029cb:	0f 86 d4 00 00 00    	jbe    802aa5 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8029d1:	a1 48 51 80 00       	mov    0x805148,%eax
  8029d6:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8029d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029dc:	8b 50 08             	mov    0x8(%eax),%edx
  8029df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029e2:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8029e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8029eb:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8029ee:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029f2:	75 17                	jne    802a0b <alloc_block_NF+0x30d>
  8029f4:	83 ec 04             	sub    $0x4,%esp
  8029f7:	68 a4 3f 80 00       	push   $0x803fa4
  8029fc:	68 04 01 00 00       	push   $0x104
  802a01:	68 fb 3e 80 00       	push   $0x803efb
  802a06:	e8 0c 0a 00 00       	call   803417 <_panic>
  802a0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a0e:	8b 00                	mov    (%eax),%eax
  802a10:	85 c0                	test   %eax,%eax
  802a12:	74 10                	je     802a24 <alloc_block_NF+0x326>
  802a14:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a17:	8b 00                	mov    (%eax),%eax
  802a19:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a1c:	8b 52 04             	mov    0x4(%edx),%edx
  802a1f:	89 50 04             	mov    %edx,0x4(%eax)
  802a22:	eb 0b                	jmp    802a2f <alloc_block_NF+0x331>
  802a24:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a27:	8b 40 04             	mov    0x4(%eax),%eax
  802a2a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a2f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a32:	8b 40 04             	mov    0x4(%eax),%eax
  802a35:	85 c0                	test   %eax,%eax
  802a37:	74 0f                	je     802a48 <alloc_block_NF+0x34a>
  802a39:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a3c:	8b 40 04             	mov    0x4(%eax),%eax
  802a3f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a42:	8b 12                	mov    (%edx),%edx
  802a44:	89 10                	mov    %edx,(%eax)
  802a46:	eb 0a                	jmp    802a52 <alloc_block_NF+0x354>
  802a48:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a4b:	8b 00                	mov    (%eax),%eax
  802a4d:	a3 48 51 80 00       	mov    %eax,0x805148
  802a52:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a55:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a5b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a5e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a65:	a1 54 51 80 00       	mov    0x805154,%eax
  802a6a:	48                   	dec    %eax
  802a6b:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802a70:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a73:	8b 40 08             	mov    0x8(%eax),%eax
  802a76:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802a7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7e:	8b 50 08             	mov    0x8(%eax),%edx
  802a81:	8b 45 08             	mov    0x8(%ebp),%eax
  802a84:	01 c2                	add    %eax,%edx
  802a86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a89:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802a8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8f:	8b 40 0c             	mov    0xc(%eax),%eax
  802a92:	2b 45 08             	sub    0x8(%ebp),%eax
  802a95:	89 c2                	mov    %eax,%edx
  802a97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9a:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802a9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aa0:	e9 24 02 00 00       	jmp    802cc9 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802aa5:	a1 40 51 80 00       	mov    0x805140,%eax
  802aaa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ab1:	74 07                	je     802aba <alloc_block_NF+0x3bc>
  802ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab6:	8b 00                	mov    (%eax),%eax
  802ab8:	eb 05                	jmp    802abf <alloc_block_NF+0x3c1>
  802aba:	b8 00 00 00 00       	mov    $0x0,%eax
  802abf:	a3 40 51 80 00       	mov    %eax,0x805140
  802ac4:	a1 40 51 80 00       	mov    0x805140,%eax
  802ac9:	85 c0                	test   %eax,%eax
  802acb:	0f 85 2b fe ff ff    	jne    8028fc <alloc_block_NF+0x1fe>
  802ad1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ad5:	0f 85 21 fe ff ff    	jne    8028fc <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802adb:	a1 38 51 80 00       	mov    0x805138,%eax
  802ae0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ae3:	e9 ae 01 00 00       	jmp    802c96 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aeb:	8b 50 08             	mov    0x8(%eax),%edx
  802aee:	a1 28 50 80 00       	mov    0x805028,%eax
  802af3:	39 c2                	cmp    %eax,%edx
  802af5:	0f 83 93 01 00 00    	jae    802c8e <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afe:	8b 40 0c             	mov    0xc(%eax),%eax
  802b01:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b04:	0f 82 84 01 00 00    	jb     802c8e <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0d:	8b 40 0c             	mov    0xc(%eax),%eax
  802b10:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b13:	0f 85 95 00 00 00    	jne    802bae <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802b19:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b1d:	75 17                	jne    802b36 <alloc_block_NF+0x438>
  802b1f:	83 ec 04             	sub    $0x4,%esp
  802b22:	68 a4 3f 80 00       	push   $0x803fa4
  802b27:	68 14 01 00 00       	push   $0x114
  802b2c:	68 fb 3e 80 00       	push   $0x803efb
  802b31:	e8 e1 08 00 00       	call   803417 <_panic>
  802b36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b39:	8b 00                	mov    (%eax),%eax
  802b3b:	85 c0                	test   %eax,%eax
  802b3d:	74 10                	je     802b4f <alloc_block_NF+0x451>
  802b3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b42:	8b 00                	mov    (%eax),%eax
  802b44:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b47:	8b 52 04             	mov    0x4(%edx),%edx
  802b4a:	89 50 04             	mov    %edx,0x4(%eax)
  802b4d:	eb 0b                	jmp    802b5a <alloc_block_NF+0x45c>
  802b4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b52:	8b 40 04             	mov    0x4(%eax),%eax
  802b55:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5d:	8b 40 04             	mov    0x4(%eax),%eax
  802b60:	85 c0                	test   %eax,%eax
  802b62:	74 0f                	je     802b73 <alloc_block_NF+0x475>
  802b64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b67:	8b 40 04             	mov    0x4(%eax),%eax
  802b6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b6d:	8b 12                	mov    (%edx),%edx
  802b6f:	89 10                	mov    %edx,(%eax)
  802b71:	eb 0a                	jmp    802b7d <alloc_block_NF+0x47f>
  802b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b76:	8b 00                	mov    (%eax),%eax
  802b78:	a3 38 51 80 00       	mov    %eax,0x805138
  802b7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b80:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b89:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b90:	a1 44 51 80 00       	mov    0x805144,%eax
  802b95:	48                   	dec    %eax
  802b96:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802b9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9e:	8b 40 08             	mov    0x8(%eax),%eax
  802ba1:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802ba6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba9:	e9 1b 01 00 00       	jmp    802cc9 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802bae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb1:	8b 40 0c             	mov    0xc(%eax),%eax
  802bb4:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bb7:	0f 86 d1 00 00 00    	jbe    802c8e <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802bbd:	a1 48 51 80 00       	mov    0x805148,%eax
  802bc2:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc8:	8b 50 08             	mov    0x8(%eax),%edx
  802bcb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bce:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802bd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd4:	8b 55 08             	mov    0x8(%ebp),%edx
  802bd7:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802bda:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802bde:	75 17                	jne    802bf7 <alloc_block_NF+0x4f9>
  802be0:	83 ec 04             	sub    $0x4,%esp
  802be3:	68 a4 3f 80 00       	push   $0x803fa4
  802be8:	68 1c 01 00 00       	push   $0x11c
  802bed:	68 fb 3e 80 00       	push   $0x803efb
  802bf2:	e8 20 08 00 00       	call   803417 <_panic>
  802bf7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bfa:	8b 00                	mov    (%eax),%eax
  802bfc:	85 c0                	test   %eax,%eax
  802bfe:	74 10                	je     802c10 <alloc_block_NF+0x512>
  802c00:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c03:	8b 00                	mov    (%eax),%eax
  802c05:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c08:	8b 52 04             	mov    0x4(%edx),%edx
  802c0b:	89 50 04             	mov    %edx,0x4(%eax)
  802c0e:	eb 0b                	jmp    802c1b <alloc_block_NF+0x51d>
  802c10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c13:	8b 40 04             	mov    0x4(%eax),%eax
  802c16:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c1e:	8b 40 04             	mov    0x4(%eax),%eax
  802c21:	85 c0                	test   %eax,%eax
  802c23:	74 0f                	je     802c34 <alloc_block_NF+0x536>
  802c25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c28:	8b 40 04             	mov    0x4(%eax),%eax
  802c2b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c2e:	8b 12                	mov    (%edx),%edx
  802c30:	89 10                	mov    %edx,(%eax)
  802c32:	eb 0a                	jmp    802c3e <alloc_block_NF+0x540>
  802c34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c37:	8b 00                	mov    (%eax),%eax
  802c39:	a3 48 51 80 00       	mov    %eax,0x805148
  802c3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c41:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c4a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c51:	a1 54 51 80 00       	mov    0x805154,%eax
  802c56:	48                   	dec    %eax
  802c57:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802c5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c5f:	8b 40 08             	mov    0x8(%eax),%eax
  802c62:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802c67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6a:	8b 50 08             	mov    0x8(%eax),%edx
  802c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c70:	01 c2                	add    %eax,%edx
  802c72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c75:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802c78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7b:	8b 40 0c             	mov    0xc(%eax),%eax
  802c7e:	2b 45 08             	sub    0x8(%ebp),%eax
  802c81:	89 c2                	mov    %eax,%edx
  802c83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c86:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802c89:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c8c:	eb 3b                	jmp    802cc9 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c8e:	a1 40 51 80 00       	mov    0x805140,%eax
  802c93:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c96:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c9a:	74 07                	je     802ca3 <alloc_block_NF+0x5a5>
  802c9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9f:	8b 00                	mov    (%eax),%eax
  802ca1:	eb 05                	jmp    802ca8 <alloc_block_NF+0x5aa>
  802ca3:	b8 00 00 00 00       	mov    $0x0,%eax
  802ca8:	a3 40 51 80 00       	mov    %eax,0x805140
  802cad:	a1 40 51 80 00       	mov    0x805140,%eax
  802cb2:	85 c0                	test   %eax,%eax
  802cb4:	0f 85 2e fe ff ff    	jne    802ae8 <alloc_block_NF+0x3ea>
  802cba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cbe:	0f 85 24 fe ff ff    	jne    802ae8 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802cc4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cc9:	c9                   	leave  
  802cca:	c3                   	ret    

00802ccb <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802ccb:	55                   	push   %ebp
  802ccc:	89 e5                	mov    %esp,%ebp
  802cce:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802cd1:	a1 38 51 80 00       	mov    0x805138,%eax
  802cd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802cd9:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802cde:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802ce1:	a1 38 51 80 00       	mov    0x805138,%eax
  802ce6:	85 c0                	test   %eax,%eax
  802ce8:	74 14                	je     802cfe <insert_sorted_with_merge_freeList+0x33>
  802cea:	8b 45 08             	mov    0x8(%ebp),%eax
  802ced:	8b 50 08             	mov    0x8(%eax),%edx
  802cf0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf3:	8b 40 08             	mov    0x8(%eax),%eax
  802cf6:	39 c2                	cmp    %eax,%edx
  802cf8:	0f 87 9b 01 00 00    	ja     802e99 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802cfe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d02:	75 17                	jne    802d1b <insert_sorted_with_merge_freeList+0x50>
  802d04:	83 ec 04             	sub    $0x4,%esp
  802d07:	68 d8 3e 80 00       	push   $0x803ed8
  802d0c:	68 38 01 00 00       	push   $0x138
  802d11:	68 fb 3e 80 00       	push   $0x803efb
  802d16:	e8 fc 06 00 00       	call   803417 <_panic>
  802d1b:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802d21:	8b 45 08             	mov    0x8(%ebp),%eax
  802d24:	89 10                	mov    %edx,(%eax)
  802d26:	8b 45 08             	mov    0x8(%ebp),%eax
  802d29:	8b 00                	mov    (%eax),%eax
  802d2b:	85 c0                	test   %eax,%eax
  802d2d:	74 0d                	je     802d3c <insert_sorted_with_merge_freeList+0x71>
  802d2f:	a1 38 51 80 00       	mov    0x805138,%eax
  802d34:	8b 55 08             	mov    0x8(%ebp),%edx
  802d37:	89 50 04             	mov    %edx,0x4(%eax)
  802d3a:	eb 08                	jmp    802d44 <insert_sorted_with_merge_freeList+0x79>
  802d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d44:	8b 45 08             	mov    0x8(%ebp),%eax
  802d47:	a3 38 51 80 00       	mov    %eax,0x805138
  802d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d56:	a1 44 51 80 00       	mov    0x805144,%eax
  802d5b:	40                   	inc    %eax
  802d5c:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d61:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d65:	0f 84 a8 06 00 00    	je     803413 <insert_sorted_with_merge_freeList+0x748>
  802d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6e:	8b 50 08             	mov    0x8(%eax),%edx
  802d71:	8b 45 08             	mov    0x8(%ebp),%eax
  802d74:	8b 40 0c             	mov    0xc(%eax),%eax
  802d77:	01 c2                	add    %eax,%edx
  802d79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d7c:	8b 40 08             	mov    0x8(%eax),%eax
  802d7f:	39 c2                	cmp    %eax,%edx
  802d81:	0f 85 8c 06 00 00    	jne    803413 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802d87:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8a:	8b 50 0c             	mov    0xc(%eax),%edx
  802d8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d90:	8b 40 0c             	mov    0xc(%eax),%eax
  802d93:	01 c2                	add    %eax,%edx
  802d95:	8b 45 08             	mov    0x8(%ebp),%eax
  802d98:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802d9b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d9f:	75 17                	jne    802db8 <insert_sorted_with_merge_freeList+0xed>
  802da1:	83 ec 04             	sub    $0x4,%esp
  802da4:	68 a4 3f 80 00       	push   $0x803fa4
  802da9:	68 3c 01 00 00       	push   $0x13c
  802dae:	68 fb 3e 80 00       	push   $0x803efb
  802db3:	e8 5f 06 00 00       	call   803417 <_panic>
  802db8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dbb:	8b 00                	mov    (%eax),%eax
  802dbd:	85 c0                	test   %eax,%eax
  802dbf:	74 10                	je     802dd1 <insert_sorted_with_merge_freeList+0x106>
  802dc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc4:	8b 00                	mov    (%eax),%eax
  802dc6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dc9:	8b 52 04             	mov    0x4(%edx),%edx
  802dcc:	89 50 04             	mov    %edx,0x4(%eax)
  802dcf:	eb 0b                	jmp    802ddc <insert_sorted_with_merge_freeList+0x111>
  802dd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd4:	8b 40 04             	mov    0x4(%eax),%eax
  802dd7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ddc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ddf:	8b 40 04             	mov    0x4(%eax),%eax
  802de2:	85 c0                	test   %eax,%eax
  802de4:	74 0f                	je     802df5 <insert_sorted_with_merge_freeList+0x12a>
  802de6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de9:	8b 40 04             	mov    0x4(%eax),%eax
  802dec:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802def:	8b 12                	mov    (%edx),%edx
  802df1:	89 10                	mov    %edx,(%eax)
  802df3:	eb 0a                	jmp    802dff <insert_sorted_with_merge_freeList+0x134>
  802df5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df8:	8b 00                	mov    (%eax),%eax
  802dfa:	a3 38 51 80 00       	mov    %eax,0x805138
  802dff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e02:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e0b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e12:	a1 44 51 80 00       	mov    0x805144,%eax
  802e17:	48                   	dec    %eax
  802e18:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802e1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e20:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802e27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e2a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802e31:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e35:	75 17                	jne    802e4e <insert_sorted_with_merge_freeList+0x183>
  802e37:	83 ec 04             	sub    $0x4,%esp
  802e3a:	68 d8 3e 80 00       	push   $0x803ed8
  802e3f:	68 3f 01 00 00       	push   $0x13f
  802e44:	68 fb 3e 80 00       	push   $0x803efb
  802e49:	e8 c9 05 00 00       	call   803417 <_panic>
  802e4e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e57:	89 10                	mov    %edx,(%eax)
  802e59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e5c:	8b 00                	mov    (%eax),%eax
  802e5e:	85 c0                	test   %eax,%eax
  802e60:	74 0d                	je     802e6f <insert_sorted_with_merge_freeList+0x1a4>
  802e62:	a1 48 51 80 00       	mov    0x805148,%eax
  802e67:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e6a:	89 50 04             	mov    %edx,0x4(%eax)
  802e6d:	eb 08                	jmp    802e77 <insert_sorted_with_merge_freeList+0x1ac>
  802e6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e72:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e7a:	a3 48 51 80 00       	mov    %eax,0x805148
  802e7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e82:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e89:	a1 54 51 80 00       	mov    0x805154,%eax
  802e8e:	40                   	inc    %eax
  802e8f:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e94:	e9 7a 05 00 00       	jmp    803413 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802e99:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9c:	8b 50 08             	mov    0x8(%eax),%edx
  802e9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ea2:	8b 40 08             	mov    0x8(%eax),%eax
  802ea5:	39 c2                	cmp    %eax,%edx
  802ea7:	0f 82 14 01 00 00    	jb     802fc1 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802ead:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eb0:	8b 50 08             	mov    0x8(%eax),%edx
  802eb3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eb6:	8b 40 0c             	mov    0xc(%eax),%eax
  802eb9:	01 c2                	add    %eax,%edx
  802ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebe:	8b 40 08             	mov    0x8(%eax),%eax
  802ec1:	39 c2                	cmp    %eax,%edx
  802ec3:	0f 85 90 00 00 00    	jne    802f59 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802ec9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ecc:	8b 50 0c             	mov    0xc(%eax),%edx
  802ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed2:	8b 40 0c             	mov    0xc(%eax),%eax
  802ed5:	01 c2                	add    %eax,%edx
  802ed7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eda:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802edd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eea:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802ef1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ef5:	75 17                	jne    802f0e <insert_sorted_with_merge_freeList+0x243>
  802ef7:	83 ec 04             	sub    $0x4,%esp
  802efa:	68 d8 3e 80 00       	push   $0x803ed8
  802eff:	68 49 01 00 00       	push   $0x149
  802f04:	68 fb 3e 80 00       	push   $0x803efb
  802f09:	e8 09 05 00 00       	call   803417 <_panic>
  802f0e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f14:	8b 45 08             	mov    0x8(%ebp),%eax
  802f17:	89 10                	mov    %edx,(%eax)
  802f19:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1c:	8b 00                	mov    (%eax),%eax
  802f1e:	85 c0                	test   %eax,%eax
  802f20:	74 0d                	je     802f2f <insert_sorted_with_merge_freeList+0x264>
  802f22:	a1 48 51 80 00       	mov    0x805148,%eax
  802f27:	8b 55 08             	mov    0x8(%ebp),%edx
  802f2a:	89 50 04             	mov    %edx,0x4(%eax)
  802f2d:	eb 08                	jmp    802f37 <insert_sorted_with_merge_freeList+0x26c>
  802f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f32:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f37:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3a:	a3 48 51 80 00       	mov    %eax,0x805148
  802f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f42:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f49:	a1 54 51 80 00       	mov    0x805154,%eax
  802f4e:	40                   	inc    %eax
  802f4f:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f54:	e9 bb 04 00 00       	jmp    803414 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802f59:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f5d:	75 17                	jne    802f76 <insert_sorted_with_merge_freeList+0x2ab>
  802f5f:	83 ec 04             	sub    $0x4,%esp
  802f62:	68 4c 3f 80 00       	push   $0x803f4c
  802f67:	68 4c 01 00 00       	push   $0x14c
  802f6c:	68 fb 3e 80 00       	push   $0x803efb
  802f71:	e8 a1 04 00 00       	call   803417 <_panic>
  802f76:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7f:	89 50 04             	mov    %edx,0x4(%eax)
  802f82:	8b 45 08             	mov    0x8(%ebp),%eax
  802f85:	8b 40 04             	mov    0x4(%eax),%eax
  802f88:	85 c0                	test   %eax,%eax
  802f8a:	74 0c                	je     802f98 <insert_sorted_with_merge_freeList+0x2cd>
  802f8c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f91:	8b 55 08             	mov    0x8(%ebp),%edx
  802f94:	89 10                	mov    %edx,(%eax)
  802f96:	eb 08                	jmp    802fa0 <insert_sorted_with_merge_freeList+0x2d5>
  802f98:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9b:	a3 38 51 80 00       	mov    %eax,0x805138
  802fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  802fab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fb1:	a1 44 51 80 00       	mov    0x805144,%eax
  802fb6:	40                   	inc    %eax
  802fb7:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802fbc:	e9 53 04 00 00       	jmp    803414 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802fc1:	a1 38 51 80 00       	mov    0x805138,%eax
  802fc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fc9:	e9 15 04 00 00       	jmp    8033e3 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802fce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd1:	8b 00                	mov    (%eax),%eax
  802fd3:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802fd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd9:	8b 50 08             	mov    0x8(%eax),%edx
  802fdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fdf:	8b 40 08             	mov    0x8(%eax),%eax
  802fe2:	39 c2                	cmp    %eax,%edx
  802fe4:	0f 86 f1 03 00 00    	jbe    8033db <insert_sorted_with_merge_freeList+0x710>
  802fea:	8b 45 08             	mov    0x8(%ebp),%eax
  802fed:	8b 50 08             	mov    0x8(%eax),%edx
  802ff0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff3:	8b 40 08             	mov    0x8(%eax),%eax
  802ff6:	39 c2                	cmp    %eax,%edx
  802ff8:	0f 83 dd 03 00 00    	jae    8033db <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802ffe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803001:	8b 50 08             	mov    0x8(%eax),%edx
  803004:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803007:	8b 40 0c             	mov    0xc(%eax),%eax
  80300a:	01 c2                	add    %eax,%edx
  80300c:	8b 45 08             	mov    0x8(%ebp),%eax
  80300f:	8b 40 08             	mov    0x8(%eax),%eax
  803012:	39 c2                	cmp    %eax,%edx
  803014:	0f 85 b9 01 00 00    	jne    8031d3 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80301a:	8b 45 08             	mov    0x8(%ebp),%eax
  80301d:	8b 50 08             	mov    0x8(%eax),%edx
  803020:	8b 45 08             	mov    0x8(%ebp),%eax
  803023:	8b 40 0c             	mov    0xc(%eax),%eax
  803026:	01 c2                	add    %eax,%edx
  803028:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80302b:	8b 40 08             	mov    0x8(%eax),%eax
  80302e:	39 c2                	cmp    %eax,%edx
  803030:	0f 85 0d 01 00 00    	jne    803143 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803036:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803039:	8b 50 0c             	mov    0xc(%eax),%edx
  80303c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80303f:	8b 40 0c             	mov    0xc(%eax),%eax
  803042:	01 c2                	add    %eax,%edx
  803044:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803047:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80304a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80304e:	75 17                	jne    803067 <insert_sorted_with_merge_freeList+0x39c>
  803050:	83 ec 04             	sub    $0x4,%esp
  803053:	68 a4 3f 80 00       	push   $0x803fa4
  803058:	68 5c 01 00 00       	push   $0x15c
  80305d:	68 fb 3e 80 00       	push   $0x803efb
  803062:	e8 b0 03 00 00       	call   803417 <_panic>
  803067:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80306a:	8b 00                	mov    (%eax),%eax
  80306c:	85 c0                	test   %eax,%eax
  80306e:	74 10                	je     803080 <insert_sorted_with_merge_freeList+0x3b5>
  803070:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803073:	8b 00                	mov    (%eax),%eax
  803075:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803078:	8b 52 04             	mov    0x4(%edx),%edx
  80307b:	89 50 04             	mov    %edx,0x4(%eax)
  80307e:	eb 0b                	jmp    80308b <insert_sorted_with_merge_freeList+0x3c0>
  803080:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803083:	8b 40 04             	mov    0x4(%eax),%eax
  803086:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80308b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80308e:	8b 40 04             	mov    0x4(%eax),%eax
  803091:	85 c0                	test   %eax,%eax
  803093:	74 0f                	je     8030a4 <insert_sorted_with_merge_freeList+0x3d9>
  803095:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803098:	8b 40 04             	mov    0x4(%eax),%eax
  80309b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80309e:	8b 12                	mov    (%edx),%edx
  8030a0:	89 10                	mov    %edx,(%eax)
  8030a2:	eb 0a                	jmp    8030ae <insert_sorted_with_merge_freeList+0x3e3>
  8030a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a7:	8b 00                	mov    (%eax),%eax
  8030a9:	a3 38 51 80 00       	mov    %eax,0x805138
  8030ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030c1:	a1 44 51 80 00       	mov    0x805144,%eax
  8030c6:	48                   	dec    %eax
  8030c7:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8030cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030cf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8030d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8030e0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030e4:	75 17                	jne    8030fd <insert_sorted_with_merge_freeList+0x432>
  8030e6:	83 ec 04             	sub    $0x4,%esp
  8030e9:	68 d8 3e 80 00       	push   $0x803ed8
  8030ee:	68 5f 01 00 00       	push   $0x15f
  8030f3:	68 fb 3e 80 00       	push   $0x803efb
  8030f8:	e8 1a 03 00 00       	call   803417 <_panic>
  8030fd:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803103:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803106:	89 10                	mov    %edx,(%eax)
  803108:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80310b:	8b 00                	mov    (%eax),%eax
  80310d:	85 c0                	test   %eax,%eax
  80310f:	74 0d                	je     80311e <insert_sorted_with_merge_freeList+0x453>
  803111:	a1 48 51 80 00       	mov    0x805148,%eax
  803116:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803119:	89 50 04             	mov    %edx,0x4(%eax)
  80311c:	eb 08                	jmp    803126 <insert_sorted_with_merge_freeList+0x45b>
  80311e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803121:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803126:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803129:	a3 48 51 80 00       	mov    %eax,0x805148
  80312e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803131:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803138:	a1 54 51 80 00       	mov    0x805154,%eax
  80313d:	40                   	inc    %eax
  80313e:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803143:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803146:	8b 50 0c             	mov    0xc(%eax),%edx
  803149:	8b 45 08             	mov    0x8(%ebp),%eax
  80314c:	8b 40 0c             	mov    0xc(%eax),%eax
  80314f:	01 c2                	add    %eax,%edx
  803151:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803154:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803157:	8b 45 08             	mov    0x8(%ebp),%eax
  80315a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803161:	8b 45 08             	mov    0x8(%ebp),%eax
  803164:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80316b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80316f:	75 17                	jne    803188 <insert_sorted_with_merge_freeList+0x4bd>
  803171:	83 ec 04             	sub    $0x4,%esp
  803174:	68 d8 3e 80 00       	push   $0x803ed8
  803179:	68 64 01 00 00       	push   $0x164
  80317e:	68 fb 3e 80 00       	push   $0x803efb
  803183:	e8 8f 02 00 00       	call   803417 <_panic>
  803188:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80318e:	8b 45 08             	mov    0x8(%ebp),%eax
  803191:	89 10                	mov    %edx,(%eax)
  803193:	8b 45 08             	mov    0x8(%ebp),%eax
  803196:	8b 00                	mov    (%eax),%eax
  803198:	85 c0                	test   %eax,%eax
  80319a:	74 0d                	je     8031a9 <insert_sorted_with_merge_freeList+0x4de>
  80319c:	a1 48 51 80 00       	mov    0x805148,%eax
  8031a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8031a4:	89 50 04             	mov    %edx,0x4(%eax)
  8031a7:	eb 08                	jmp    8031b1 <insert_sorted_with_merge_freeList+0x4e6>
  8031a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ac:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b4:	a3 48 51 80 00       	mov    %eax,0x805148
  8031b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031bc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031c3:	a1 54 51 80 00       	mov    0x805154,%eax
  8031c8:	40                   	inc    %eax
  8031c9:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8031ce:	e9 41 02 00 00       	jmp    803414 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8031d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d6:	8b 50 08             	mov    0x8(%eax),%edx
  8031d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8031df:	01 c2                	add    %eax,%edx
  8031e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e4:	8b 40 08             	mov    0x8(%eax),%eax
  8031e7:	39 c2                	cmp    %eax,%edx
  8031e9:	0f 85 7c 01 00 00    	jne    80336b <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8031ef:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031f3:	74 06                	je     8031fb <insert_sorted_with_merge_freeList+0x530>
  8031f5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031f9:	75 17                	jne    803212 <insert_sorted_with_merge_freeList+0x547>
  8031fb:	83 ec 04             	sub    $0x4,%esp
  8031fe:	68 14 3f 80 00       	push   $0x803f14
  803203:	68 69 01 00 00       	push   $0x169
  803208:	68 fb 3e 80 00       	push   $0x803efb
  80320d:	e8 05 02 00 00       	call   803417 <_panic>
  803212:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803215:	8b 50 04             	mov    0x4(%eax),%edx
  803218:	8b 45 08             	mov    0x8(%ebp),%eax
  80321b:	89 50 04             	mov    %edx,0x4(%eax)
  80321e:	8b 45 08             	mov    0x8(%ebp),%eax
  803221:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803224:	89 10                	mov    %edx,(%eax)
  803226:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803229:	8b 40 04             	mov    0x4(%eax),%eax
  80322c:	85 c0                	test   %eax,%eax
  80322e:	74 0d                	je     80323d <insert_sorted_with_merge_freeList+0x572>
  803230:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803233:	8b 40 04             	mov    0x4(%eax),%eax
  803236:	8b 55 08             	mov    0x8(%ebp),%edx
  803239:	89 10                	mov    %edx,(%eax)
  80323b:	eb 08                	jmp    803245 <insert_sorted_with_merge_freeList+0x57a>
  80323d:	8b 45 08             	mov    0x8(%ebp),%eax
  803240:	a3 38 51 80 00       	mov    %eax,0x805138
  803245:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803248:	8b 55 08             	mov    0x8(%ebp),%edx
  80324b:	89 50 04             	mov    %edx,0x4(%eax)
  80324e:	a1 44 51 80 00       	mov    0x805144,%eax
  803253:	40                   	inc    %eax
  803254:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803259:	8b 45 08             	mov    0x8(%ebp),%eax
  80325c:	8b 50 0c             	mov    0xc(%eax),%edx
  80325f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803262:	8b 40 0c             	mov    0xc(%eax),%eax
  803265:	01 c2                	add    %eax,%edx
  803267:	8b 45 08             	mov    0x8(%ebp),%eax
  80326a:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80326d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803271:	75 17                	jne    80328a <insert_sorted_with_merge_freeList+0x5bf>
  803273:	83 ec 04             	sub    $0x4,%esp
  803276:	68 a4 3f 80 00       	push   $0x803fa4
  80327b:	68 6b 01 00 00       	push   $0x16b
  803280:	68 fb 3e 80 00       	push   $0x803efb
  803285:	e8 8d 01 00 00       	call   803417 <_panic>
  80328a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80328d:	8b 00                	mov    (%eax),%eax
  80328f:	85 c0                	test   %eax,%eax
  803291:	74 10                	je     8032a3 <insert_sorted_with_merge_freeList+0x5d8>
  803293:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803296:	8b 00                	mov    (%eax),%eax
  803298:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80329b:	8b 52 04             	mov    0x4(%edx),%edx
  80329e:	89 50 04             	mov    %edx,0x4(%eax)
  8032a1:	eb 0b                	jmp    8032ae <insert_sorted_with_merge_freeList+0x5e3>
  8032a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a6:	8b 40 04             	mov    0x4(%eax),%eax
  8032a9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b1:	8b 40 04             	mov    0x4(%eax),%eax
  8032b4:	85 c0                	test   %eax,%eax
  8032b6:	74 0f                	je     8032c7 <insert_sorted_with_merge_freeList+0x5fc>
  8032b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032bb:	8b 40 04             	mov    0x4(%eax),%eax
  8032be:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032c1:	8b 12                	mov    (%edx),%edx
  8032c3:	89 10                	mov    %edx,(%eax)
  8032c5:	eb 0a                	jmp    8032d1 <insert_sorted_with_merge_freeList+0x606>
  8032c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ca:	8b 00                	mov    (%eax),%eax
  8032cc:	a3 38 51 80 00       	mov    %eax,0x805138
  8032d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032dd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032e4:	a1 44 51 80 00       	mov    0x805144,%eax
  8032e9:	48                   	dec    %eax
  8032ea:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8032ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8032f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032fc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803303:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803307:	75 17                	jne    803320 <insert_sorted_with_merge_freeList+0x655>
  803309:	83 ec 04             	sub    $0x4,%esp
  80330c:	68 d8 3e 80 00       	push   $0x803ed8
  803311:	68 6e 01 00 00       	push   $0x16e
  803316:	68 fb 3e 80 00       	push   $0x803efb
  80331b:	e8 f7 00 00 00       	call   803417 <_panic>
  803320:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803326:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803329:	89 10                	mov    %edx,(%eax)
  80332b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80332e:	8b 00                	mov    (%eax),%eax
  803330:	85 c0                	test   %eax,%eax
  803332:	74 0d                	je     803341 <insert_sorted_with_merge_freeList+0x676>
  803334:	a1 48 51 80 00       	mov    0x805148,%eax
  803339:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80333c:	89 50 04             	mov    %edx,0x4(%eax)
  80333f:	eb 08                	jmp    803349 <insert_sorted_with_merge_freeList+0x67e>
  803341:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803344:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803349:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80334c:	a3 48 51 80 00       	mov    %eax,0x805148
  803351:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803354:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80335b:	a1 54 51 80 00       	mov    0x805154,%eax
  803360:	40                   	inc    %eax
  803361:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803366:	e9 a9 00 00 00       	jmp    803414 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  80336b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80336f:	74 06                	je     803377 <insert_sorted_with_merge_freeList+0x6ac>
  803371:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803375:	75 17                	jne    80338e <insert_sorted_with_merge_freeList+0x6c3>
  803377:	83 ec 04             	sub    $0x4,%esp
  80337a:	68 70 3f 80 00       	push   $0x803f70
  80337f:	68 73 01 00 00       	push   $0x173
  803384:	68 fb 3e 80 00       	push   $0x803efb
  803389:	e8 89 00 00 00       	call   803417 <_panic>
  80338e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803391:	8b 10                	mov    (%eax),%edx
  803393:	8b 45 08             	mov    0x8(%ebp),%eax
  803396:	89 10                	mov    %edx,(%eax)
  803398:	8b 45 08             	mov    0x8(%ebp),%eax
  80339b:	8b 00                	mov    (%eax),%eax
  80339d:	85 c0                	test   %eax,%eax
  80339f:	74 0b                	je     8033ac <insert_sorted_with_merge_freeList+0x6e1>
  8033a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a4:	8b 00                	mov    (%eax),%eax
  8033a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8033a9:	89 50 04             	mov    %edx,0x4(%eax)
  8033ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033af:	8b 55 08             	mov    0x8(%ebp),%edx
  8033b2:	89 10                	mov    %edx,(%eax)
  8033b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033ba:	89 50 04             	mov    %edx,0x4(%eax)
  8033bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c0:	8b 00                	mov    (%eax),%eax
  8033c2:	85 c0                	test   %eax,%eax
  8033c4:	75 08                	jne    8033ce <insert_sorted_with_merge_freeList+0x703>
  8033c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033ce:	a1 44 51 80 00       	mov    0x805144,%eax
  8033d3:	40                   	inc    %eax
  8033d4:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8033d9:	eb 39                	jmp    803414 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8033db:	a1 40 51 80 00       	mov    0x805140,%eax
  8033e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033e7:	74 07                	je     8033f0 <insert_sorted_with_merge_freeList+0x725>
  8033e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ec:	8b 00                	mov    (%eax),%eax
  8033ee:	eb 05                	jmp    8033f5 <insert_sorted_with_merge_freeList+0x72a>
  8033f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8033f5:	a3 40 51 80 00       	mov    %eax,0x805140
  8033fa:	a1 40 51 80 00       	mov    0x805140,%eax
  8033ff:	85 c0                	test   %eax,%eax
  803401:	0f 85 c7 fb ff ff    	jne    802fce <insert_sorted_with_merge_freeList+0x303>
  803407:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80340b:	0f 85 bd fb ff ff    	jne    802fce <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803411:	eb 01                	jmp    803414 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803413:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803414:	90                   	nop
  803415:	c9                   	leave  
  803416:	c3                   	ret    

00803417 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803417:	55                   	push   %ebp
  803418:	89 e5                	mov    %esp,%ebp
  80341a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80341d:	8d 45 10             	lea    0x10(%ebp),%eax
  803420:	83 c0 04             	add    $0x4,%eax
  803423:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803426:	a1 5c 51 80 00       	mov    0x80515c,%eax
  80342b:	85 c0                	test   %eax,%eax
  80342d:	74 16                	je     803445 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80342f:	a1 5c 51 80 00       	mov    0x80515c,%eax
  803434:	83 ec 08             	sub    $0x8,%esp
  803437:	50                   	push   %eax
  803438:	68 c4 3f 80 00       	push   $0x803fc4
  80343d:	e8 24 d1 ff ff       	call   800566 <cprintf>
  803442:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803445:	a1 00 50 80 00       	mov    0x805000,%eax
  80344a:	ff 75 0c             	pushl  0xc(%ebp)
  80344d:	ff 75 08             	pushl  0x8(%ebp)
  803450:	50                   	push   %eax
  803451:	68 c9 3f 80 00       	push   $0x803fc9
  803456:	e8 0b d1 ff ff       	call   800566 <cprintf>
  80345b:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80345e:	8b 45 10             	mov    0x10(%ebp),%eax
  803461:	83 ec 08             	sub    $0x8,%esp
  803464:	ff 75 f4             	pushl  -0xc(%ebp)
  803467:	50                   	push   %eax
  803468:	e8 8e d0 ff ff       	call   8004fb <vcprintf>
  80346d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803470:	83 ec 08             	sub    $0x8,%esp
  803473:	6a 00                	push   $0x0
  803475:	68 e5 3f 80 00       	push   $0x803fe5
  80347a:	e8 7c d0 ff ff       	call   8004fb <vcprintf>
  80347f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803482:	e8 fd cf ff ff       	call   800484 <exit>

	// should not return here
	while (1) ;
  803487:	eb fe                	jmp    803487 <_panic+0x70>

00803489 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803489:	55                   	push   %ebp
  80348a:	89 e5                	mov    %esp,%ebp
  80348c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80348f:	a1 20 50 80 00       	mov    0x805020,%eax
  803494:	8b 50 74             	mov    0x74(%eax),%edx
  803497:	8b 45 0c             	mov    0xc(%ebp),%eax
  80349a:	39 c2                	cmp    %eax,%edx
  80349c:	74 14                	je     8034b2 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80349e:	83 ec 04             	sub    $0x4,%esp
  8034a1:	68 e8 3f 80 00       	push   $0x803fe8
  8034a6:	6a 26                	push   $0x26
  8034a8:	68 34 40 80 00       	push   $0x804034
  8034ad:	e8 65 ff ff ff       	call   803417 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8034b2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8034b9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8034c0:	e9 c2 00 00 00       	jmp    803587 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8034c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034c8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8034cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d2:	01 d0                	add    %edx,%eax
  8034d4:	8b 00                	mov    (%eax),%eax
  8034d6:	85 c0                	test   %eax,%eax
  8034d8:	75 08                	jne    8034e2 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8034da:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8034dd:	e9 a2 00 00 00       	jmp    803584 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8034e2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8034e9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8034f0:	eb 69                	jmp    80355b <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8034f2:	a1 20 50 80 00       	mov    0x805020,%eax
  8034f7:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8034fd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803500:	89 d0                	mov    %edx,%eax
  803502:	01 c0                	add    %eax,%eax
  803504:	01 d0                	add    %edx,%eax
  803506:	c1 e0 03             	shl    $0x3,%eax
  803509:	01 c8                	add    %ecx,%eax
  80350b:	8a 40 04             	mov    0x4(%eax),%al
  80350e:	84 c0                	test   %al,%al
  803510:	75 46                	jne    803558 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803512:	a1 20 50 80 00       	mov    0x805020,%eax
  803517:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80351d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803520:	89 d0                	mov    %edx,%eax
  803522:	01 c0                	add    %eax,%eax
  803524:	01 d0                	add    %edx,%eax
  803526:	c1 e0 03             	shl    $0x3,%eax
  803529:	01 c8                	add    %ecx,%eax
  80352b:	8b 00                	mov    (%eax),%eax
  80352d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803530:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803533:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803538:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80353a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80353d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803544:	8b 45 08             	mov    0x8(%ebp),%eax
  803547:	01 c8                	add    %ecx,%eax
  803549:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80354b:	39 c2                	cmp    %eax,%edx
  80354d:	75 09                	jne    803558 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80354f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803556:	eb 12                	jmp    80356a <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803558:	ff 45 e8             	incl   -0x18(%ebp)
  80355b:	a1 20 50 80 00       	mov    0x805020,%eax
  803560:	8b 50 74             	mov    0x74(%eax),%edx
  803563:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803566:	39 c2                	cmp    %eax,%edx
  803568:	77 88                	ja     8034f2 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80356a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80356e:	75 14                	jne    803584 <CheckWSWithoutLastIndex+0xfb>
			panic(
  803570:	83 ec 04             	sub    $0x4,%esp
  803573:	68 40 40 80 00       	push   $0x804040
  803578:	6a 3a                	push   $0x3a
  80357a:	68 34 40 80 00       	push   $0x804034
  80357f:	e8 93 fe ff ff       	call   803417 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803584:	ff 45 f0             	incl   -0x10(%ebp)
  803587:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80358a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80358d:	0f 8c 32 ff ff ff    	jl     8034c5 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803593:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80359a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8035a1:	eb 26                	jmp    8035c9 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8035a3:	a1 20 50 80 00       	mov    0x805020,%eax
  8035a8:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8035ae:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8035b1:	89 d0                	mov    %edx,%eax
  8035b3:	01 c0                	add    %eax,%eax
  8035b5:	01 d0                	add    %edx,%eax
  8035b7:	c1 e0 03             	shl    $0x3,%eax
  8035ba:	01 c8                	add    %ecx,%eax
  8035bc:	8a 40 04             	mov    0x4(%eax),%al
  8035bf:	3c 01                	cmp    $0x1,%al
  8035c1:	75 03                	jne    8035c6 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8035c3:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8035c6:	ff 45 e0             	incl   -0x20(%ebp)
  8035c9:	a1 20 50 80 00       	mov    0x805020,%eax
  8035ce:	8b 50 74             	mov    0x74(%eax),%edx
  8035d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035d4:	39 c2                	cmp    %eax,%edx
  8035d6:	77 cb                	ja     8035a3 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8035d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035db:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8035de:	74 14                	je     8035f4 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8035e0:	83 ec 04             	sub    $0x4,%esp
  8035e3:	68 94 40 80 00       	push   $0x804094
  8035e8:	6a 44                	push   $0x44
  8035ea:	68 34 40 80 00       	push   $0x804034
  8035ef:	e8 23 fe ff ff       	call   803417 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8035f4:	90                   	nop
  8035f5:	c9                   	leave  
  8035f6:	c3                   	ret    
  8035f7:	90                   	nop

008035f8 <__udivdi3>:
  8035f8:	55                   	push   %ebp
  8035f9:	57                   	push   %edi
  8035fa:	56                   	push   %esi
  8035fb:	53                   	push   %ebx
  8035fc:	83 ec 1c             	sub    $0x1c,%esp
  8035ff:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803603:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803607:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80360b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80360f:	89 ca                	mov    %ecx,%edx
  803611:	89 f8                	mov    %edi,%eax
  803613:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803617:	85 f6                	test   %esi,%esi
  803619:	75 2d                	jne    803648 <__udivdi3+0x50>
  80361b:	39 cf                	cmp    %ecx,%edi
  80361d:	77 65                	ja     803684 <__udivdi3+0x8c>
  80361f:	89 fd                	mov    %edi,%ebp
  803621:	85 ff                	test   %edi,%edi
  803623:	75 0b                	jne    803630 <__udivdi3+0x38>
  803625:	b8 01 00 00 00       	mov    $0x1,%eax
  80362a:	31 d2                	xor    %edx,%edx
  80362c:	f7 f7                	div    %edi
  80362e:	89 c5                	mov    %eax,%ebp
  803630:	31 d2                	xor    %edx,%edx
  803632:	89 c8                	mov    %ecx,%eax
  803634:	f7 f5                	div    %ebp
  803636:	89 c1                	mov    %eax,%ecx
  803638:	89 d8                	mov    %ebx,%eax
  80363a:	f7 f5                	div    %ebp
  80363c:	89 cf                	mov    %ecx,%edi
  80363e:	89 fa                	mov    %edi,%edx
  803640:	83 c4 1c             	add    $0x1c,%esp
  803643:	5b                   	pop    %ebx
  803644:	5e                   	pop    %esi
  803645:	5f                   	pop    %edi
  803646:	5d                   	pop    %ebp
  803647:	c3                   	ret    
  803648:	39 ce                	cmp    %ecx,%esi
  80364a:	77 28                	ja     803674 <__udivdi3+0x7c>
  80364c:	0f bd fe             	bsr    %esi,%edi
  80364f:	83 f7 1f             	xor    $0x1f,%edi
  803652:	75 40                	jne    803694 <__udivdi3+0x9c>
  803654:	39 ce                	cmp    %ecx,%esi
  803656:	72 0a                	jb     803662 <__udivdi3+0x6a>
  803658:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80365c:	0f 87 9e 00 00 00    	ja     803700 <__udivdi3+0x108>
  803662:	b8 01 00 00 00       	mov    $0x1,%eax
  803667:	89 fa                	mov    %edi,%edx
  803669:	83 c4 1c             	add    $0x1c,%esp
  80366c:	5b                   	pop    %ebx
  80366d:	5e                   	pop    %esi
  80366e:	5f                   	pop    %edi
  80366f:	5d                   	pop    %ebp
  803670:	c3                   	ret    
  803671:	8d 76 00             	lea    0x0(%esi),%esi
  803674:	31 ff                	xor    %edi,%edi
  803676:	31 c0                	xor    %eax,%eax
  803678:	89 fa                	mov    %edi,%edx
  80367a:	83 c4 1c             	add    $0x1c,%esp
  80367d:	5b                   	pop    %ebx
  80367e:	5e                   	pop    %esi
  80367f:	5f                   	pop    %edi
  803680:	5d                   	pop    %ebp
  803681:	c3                   	ret    
  803682:	66 90                	xchg   %ax,%ax
  803684:	89 d8                	mov    %ebx,%eax
  803686:	f7 f7                	div    %edi
  803688:	31 ff                	xor    %edi,%edi
  80368a:	89 fa                	mov    %edi,%edx
  80368c:	83 c4 1c             	add    $0x1c,%esp
  80368f:	5b                   	pop    %ebx
  803690:	5e                   	pop    %esi
  803691:	5f                   	pop    %edi
  803692:	5d                   	pop    %ebp
  803693:	c3                   	ret    
  803694:	bd 20 00 00 00       	mov    $0x20,%ebp
  803699:	89 eb                	mov    %ebp,%ebx
  80369b:	29 fb                	sub    %edi,%ebx
  80369d:	89 f9                	mov    %edi,%ecx
  80369f:	d3 e6                	shl    %cl,%esi
  8036a1:	89 c5                	mov    %eax,%ebp
  8036a3:	88 d9                	mov    %bl,%cl
  8036a5:	d3 ed                	shr    %cl,%ebp
  8036a7:	89 e9                	mov    %ebp,%ecx
  8036a9:	09 f1                	or     %esi,%ecx
  8036ab:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8036af:	89 f9                	mov    %edi,%ecx
  8036b1:	d3 e0                	shl    %cl,%eax
  8036b3:	89 c5                	mov    %eax,%ebp
  8036b5:	89 d6                	mov    %edx,%esi
  8036b7:	88 d9                	mov    %bl,%cl
  8036b9:	d3 ee                	shr    %cl,%esi
  8036bb:	89 f9                	mov    %edi,%ecx
  8036bd:	d3 e2                	shl    %cl,%edx
  8036bf:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036c3:	88 d9                	mov    %bl,%cl
  8036c5:	d3 e8                	shr    %cl,%eax
  8036c7:	09 c2                	or     %eax,%edx
  8036c9:	89 d0                	mov    %edx,%eax
  8036cb:	89 f2                	mov    %esi,%edx
  8036cd:	f7 74 24 0c          	divl   0xc(%esp)
  8036d1:	89 d6                	mov    %edx,%esi
  8036d3:	89 c3                	mov    %eax,%ebx
  8036d5:	f7 e5                	mul    %ebp
  8036d7:	39 d6                	cmp    %edx,%esi
  8036d9:	72 19                	jb     8036f4 <__udivdi3+0xfc>
  8036db:	74 0b                	je     8036e8 <__udivdi3+0xf0>
  8036dd:	89 d8                	mov    %ebx,%eax
  8036df:	31 ff                	xor    %edi,%edi
  8036e1:	e9 58 ff ff ff       	jmp    80363e <__udivdi3+0x46>
  8036e6:	66 90                	xchg   %ax,%ax
  8036e8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8036ec:	89 f9                	mov    %edi,%ecx
  8036ee:	d3 e2                	shl    %cl,%edx
  8036f0:	39 c2                	cmp    %eax,%edx
  8036f2:	73 e9                	jae    8036dd <__udivdi3+0xe5>
  8036f4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8036f7:	31 ff                	xor    %edi,%edi
  8036f9:	e9 40 ff ff ff       	jmp    80363e <__udivdi3+0x46>
  8036fe:	66 90                	xchg   %ax,%ax
  803700:	31 c0                	xor    %eax,%eax
  803702:	e9 37 ff ff ff       	jmp    80363e <__udivdi3+0x46>
  803707:	90                   	nop

00803708 <__umoddi3>:
  803708:	55                   	push   %ebp
  803709:	57                   	push   %edi
  80370a:	56                   	push   %esi
  80370b:	53                   	push   %ebx
  80370c:	83 ec 1c             	sub    $0x1c,%esp
  80370f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803713:	8b 74 24 34          	mov    0x34(%esp),%esi
  803717:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80371b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80371f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803723:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803727:	89 f3                	mov    %esi,%ebx
  803729:	89 fa                	mov    %edi,%edx
  80372b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80372f:	89 34 24             	mov    %esi,(%esp)
  803732:	85 c0                	test   %eax,%eax
  803734:	75 1a                	jne    803750 <__umoddi3+0x48>
  803736:	39 f7                	cmp    %esi,%edi
  803738:	0f 86 a2 00 00 00    	jbe    8037e0 <__umoddi3+0xd8>
  80373e:	89 c8                	mov    %ecx,%eax
  803740:	89 f2                	mov    %esi,%edx
  803742:	f7 f7                	div    %edi
  803744:	89 d0                	mov    %edx,%eax
  803746:	31 d2                	xor    %edx,%edx
  803748:	83 c4 1c             	add    $0x1c,%esp
  80374b:	5b                   	pop    %ebx
  80374c:	5e                   	pop    %esi
  80374d:	5f                   	pop    %edi
  80374e:	5d                   	pop    %ebp
  80374f:	c3                   	ret    
  803750:	39 f0                	cmp    %esi,%eax
  803752:	0f 87 ac 00 00 00    	ja     803804 <__umoddi3+0xfc>
  803758:	0f bd e8             	bsr    %eax,%ebp
  80375b:	83 f5 1f             	xor    $0x1f,%ebp
  80375e:	0f 84 ac 00 00 00    	je     803810 <__umoddi3+0x108>
  803764:	bf 20 00 00 00       	mov    $0x20,%edi
  803769:	29 ef                	sub    %ebp,%edi
  80376b:	89 fe                	mov    %edi,%esi
  80376d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803771:	89 e9                	mov    %ebp,%ecx
  803773:	d3 e0                	shl    %cl,%eax
  803775:	89 d7                	mov    %edx,%edi
  803777:	89 f1                	mov    %esi,%ecx
  803779:	d3 ef                	shr    %cl,%edi
  80377b:	09 c7                	or     %eax,%edi
  80377d:	89 e9                	mov    %ebp,%ecx
  80377f:	d3 e2                	shl    %cl,%edx
  803781:	89 14 24             	mov    %edx,(%esp)
  803784:	89 d8                	mov    %ebx,%eax
  803786:	d3 e0                	shl    %cl,%eax
  803788:	89 c2                	mov    %eax,%edx
  80378a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80378e:	d3 e0                	shl    %cl,%eax
  803790:	89 44 24 04          	mov    %eax,0x4(%esp)
  803794:	8b 44 24 08          	mov    0x8(%esp),%eax
  803798:	89 f1                	mov    %esi,%ecx
  80379a:	d3 e8                	shr    %cl,%eax
  80379c:	09 d0                	or     %edx,%eax
  80379e:	d3 eb                	shr    %cl,%ebx
  8037a0:	89 da                	mov    %ebx,%edx
  8037a2:	f7 f7                	div    %edi
  8037a4:	89 d3                	mov    %edx,%ebx
  8037a6:	f7 24 24             	mull   (%esp)
  8037a9:	89 c6                	mov    %eax,%esi
  8037ab:	89 d1                	mov    %edx,%ecx
  8037ad:	39 d3                	cmp    %edx,%ebx
  8037af:	0f 82 87 00 00 00    	jb     80383c <__umoddi3+0x134>
  8037b5:	0f 84 91 00 00 00    	je     80384c <__umoddi3+0x144>
  8037bb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8037bf:	29 f2                	sub    %esi,%edx
  8037c1:	19 cb                	sbb    %ecx,%ebx
  8037c3:	89 d8                	mov    %ebx,%eax
  8037c5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8037c9:	d3 e0                	shl    %cl,%eax
  8037cb:	89 e9                	mov    %ebp,%ecx
  8037cd:	d3 ea                	shr    %cl,%edx
  8037cf:	09 d0                	or     %edx,%eax
  8037d1:	89 e9                	mov    %ebp,%ecx
  8037d3:	d3 eb                	shr    %cl,%ebx
  8037d5:	89 da                	mov    %ebx,%edx
  8037d7:	83 c4 1c             	add    $0x1c,%esp
  8037da:	5b                   	pop    %ebx
  8037db:	5e                   	pop    %esi
  8037dc:	5f                   	pop    %edi
  8037dd:	5d                   	pop    %ebp
  8037de:	c3                   	ret    
  8037df:	90                   	nop
  8037e0:	89 fd                	mov    %edi,%ebp
  8037e2:	85 ff                	test   %edi,%edi
  8037e4:	75 0b                	jne    8037f1 <__umoddi3+0xe9>
  8037e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8037eb:	31 d2                	xor    %edx,%edx
  8037ed:	f7 f7                	div    %edi
  8037ef:	89 c5                	mov    %eax,%ebp
  8037f1:	89 f0                	mov    %esi,%eax
  8037f3:	31 d2                	xor    %edx,%edx
  8037f5:	f7 f5                	div    %ebp
  8037f7:	89 c8                	mov    %ecx,%eax
  8037f9:	f7 f5                	div    %ebp
  8037fb:	89 d0                	mov    %edx,%eax
  8037fd:	e9 44 ff ff ff       	jmp    803746 <__umoddi3+0x3e>
  803802:	66 90                	xchg   %ax,%ax
  803804:	89 c8                	mov    %ecx,%eax
  803806:	89 f2                	mov    %esi,%edx
  803808:	83 c4 1c             	add    $0x1c,%esp
  80380b:	5b                   	pop    %ebx
  80380c:	5e                   	pop    %esi
  80380d:	5f                   	pop    %edi
  80380e:	5d                   	pop    %ebp
  80380f:	c3                   	ret    
  803810:	3b 04 24             	cmp    (%esp),%eax
  803813:	72 06                	jb     80381b <__umoddi3+0x113>
  803815:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803819:	77 0f                	ja     80382a <__umoddi3+0x122>
  80381b:	89 f2                	mov    %esi,%edx
  80381d:	29 f9                	sub    %edi,%ecx
  80381f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803823:	89 14 24             	mov    %edx,(%esp)
  803826:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80382a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80382e:	8b 14 24             	mov    (%esp),%edx
  803831:	83 c4 1c             	add    $0x1c,%esp
  803834:	5b                   	pop    %ebx
  803835:	5e                   	pop    %esi
  803836:	5f                   	pop    %edi
  803837:	5d                   	pop    %ebp
  803838:	c3                   	ret    
  803839:	8d 76 00             	lea    0x0(%esi),%esi
  80383c:	2b 04 24             	sub    (%esp),%eax
  80383f:	19 fa                	sbb    %edi,%edx
  803841:	89 d1                	mov    %edx,%ecx
  803843:	89 c6                	mov    %eax,%esi
  803845:	e9 71 ff ff ff       	jmp    8037bb <__umoddi3+0xb3>
  80384a:	66 90                	xchg   %ax,%ax
  80384c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803850:	72 ea                	jb     80383c <__umoddi3+0x134>
  803852:	89 d9                	mov    %ebx,%ecx
  803854:	e9 62 ff ff ff       	jmp    8037bb <__umoddi3+0xb3>
