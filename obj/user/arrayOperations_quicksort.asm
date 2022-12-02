
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
  80003e:	e8 92 19 00 00       	call   8019d5 <sys_getenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int32 parentenvID = sys_getparentenvid();
  800046:	e8 bc 19 00 00       	call   801a07 <sys_getparentenvid>
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
  80005f:	68 20 37 80 00       	push   $0x803720
  800064:	ff 75 ec             	pushl  -0x14(%ebp)
  800067:	e8 fe 14 00 00       	call   80156a <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	numOfElements = sget(parentenvID,"arrSize") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 24 37 80 00       	push   $0x803724
  80007a:	ff 75 ec             	pushl  -0x14(%ebp)
  80007d:	e8 e8 14 00 00       	call   80156a <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//Get the check-finishing counter
	int *finishedCount = NULL;
  800088:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	finishedCount = sget(parentenvID,"finishedCount") ;
  80008f:	83 ec 08             	sub    $0x8,%esp
  800092:	68 2c 37 80 00       	push   $0x80372c
  800097:	ff 75 ec             	pushl  -0x14(%ebp)
  80009a:	e8 cb 14 00 00       	call   80156a <sget>
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
  8000b3:	68 3a 37 80 00       	push   $0x80373a
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
  800112:	68 49 37 80 00       	push   $0x803749
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
  800166:	e8 cf 18 00 00       	call   801a3a <sys_get_virtual_time>
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
  8002f6:	68 65 37 80 00       	push   $0x803765
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
  800318:	68 67 37 80 00       	push   $0x803767
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
  800346:	68 6c 37 80 00       	push   $0x80376c
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
  80035c:	e8 8d 16 00 00       	call   8019ee <sys_getenvindex>
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
  8003c7:	e8 2f 14 00 00       	call   8017fb <sys_disable_interrupt>
	cprintf("**************************************\n");
  8003cc:	83 ec 0c             	sub    $0xc,%esp
  8003cf:	68 88 37 80 00       	push   $0x803788
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
  8003f7:	68 b0 37 80 00       	push   $0x8037b0
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
  800428:	68 d8 37 80 00       	push   $0x8037d8
  80042d:	e8 34 01 00 00       	call   800566 <cprintf>
  800432:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800435:	a1 20 50 80 00       	mov    0x805020,%eax
  80043a:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800440:	83 ec 08             	sub    $0x8,%esp
  800443:	50                   	push   %eax
  800444:	68 30 38 80 00       	push   $0x803830
  800449:	e8 18 01 00 00       	call   800566 <cprintf>
  80044e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800451:	83 ec 0c             	sub    $0xc,%esp
  800454:	68 88 37 80 00       	push   $0x803788
  800459:	e8 08 01 00 00       	call   800566 <cprintf>
  80045e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800461:	e8 af 13 00 00       	call   801815 <sys_enable_interrupt>

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
  800479:	e8 3c 15 00 00       	call   8019ba <sys_destroy_env>
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
  80048a:	e8 91 15 00 00       	call   801a20 <sys_exit_env>
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
  8004d8:	e8 70 11 00 00       	call   80164d <sys_cputs>
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
  80054f:	e8 f9 10 00 00       	call   80164d <sys_cputs>
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
  800599:	e8 5d 12 00 00       	call   8017fb <sys_disable_interrupt>
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
  8005b9:	e8 57 12 00 00       	call   801815 <sys_enable_interrupt>
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
  800603:	e8 a8 2e 00 00       	call   8034b0 <__udivdi3>
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
  800653:	e8 68 2f 00 00       	call   8035c0 <__umoddi3>
  800658:	83 c4 10             	add    $0x10,%esp
  80065b:	05 74 3a 80 00       	add    $0x803a74,%eax
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
  8007ae:	8b 04 85 98 3a 80 00 	mov    0x803a98(,%eax,4),%eax
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
  80088f:	8b 34 9d e0 38 80 00 	mov    0x8038e0(,%ebx,4),%esi
  800896:	85 f6                	test   %esi,%esi
  800898:	75 19                	jne    8008b3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80089a:	53                   	push   %ebx
  80089b:	68 85 3a 80 00       	push   $0x803a85
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
  8008b4:	68 8e 3a 80 00       	push   $0x803a8e
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
  8008e1:	be 91 3a 80 00       	mov    $0x803a91,%esi
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
  801307:	68 f0 3b 80 00       	push   $0x803bf0
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
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_PRESENT);
  8013ba:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8013c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013c4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013c9:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013ce:	83 ec 04             	sub    $0x4,%esp
  8013d1:	6a 03                	push   $0x3
  8013d3:	ff 75 f4             	pushl  -0xc(%ebp)
  8013d6:	50                   	push   %eax
  8013d7:	e8 b5 03 00 00       	call   801791 <sys_allocate_chunk>
  8013dc:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013df:	a1 20 51 80 00       	mov    0x805120,%eax
  8013e4:	83 ec 0c             	sub    $0xc,%esp
  8013e7:	50                   	push   %eax
  8013e8:	e8 2a 0a 00 00       	call   801e17 <initialize_MemBlocksList>
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
  801415:	68 15 3c 80 00       	push   $0x803c15
  80141a:	6a 33                	push   $0x33
  80141c:	68 33 3c 80 00       	push   $0x803c33
  801421:	e8 aa 1e 00 00       	call   8032d0 <_panic>
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
  801494:	68 40 3c 80 00       	push   $0x803c40
  801499:	6a 34                	push   $0x34
  80149b:	68 33 3c 80 00       	push   $0x803c33
  8014a0:	e8 2b 1e 00 00       	call   8032d0 <_panic>
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
  801509:	68 64 3c 80 00       	push   $0x803c64
  80150e:	6a 46                	push   $0x46
  801510:	68 33 3c 80 00       	push   $0x803c33
  801515:	e8 b6 1d 00 00       	call   8032d0 <_panic>
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
  801525:	68 8c 3c 80 00       	push   $0x803c8c
  80152a:	6a 61                	push   $0x61
  80152c:	68 33 3c 80 00       	push   $0x803c33
  801531:	e8 9a 1d 00 00       	call   8032d0 <_panic>

00801536 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801536:	55                   	push   %ebp
  801537:	89 e5                	mov    %esp,%ebp
  801539:	83 ec 18             	sub    $0x18,%esp
  80153c:	8b 45 10             	mov    0x10(%ebp),%eax
  80153f:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801542:	e8 a9 fd ff ff       	call   8012f0 <InitializeUHeap>
	if (size == 0) return NULL ;
  801547:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80154b:	75 07                	jne    801554 <smalloc+0x1e>
  80154d:	b8 00 00 00 00       	mov    $0x0,%eax
  801552:	eb 14                	jmp    801568 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801554:	83 ec 04             	sub    $0x4,%esp
  801557:	68 b0 3c 80 00       	push   $0x803cb0
  80155c:	6a 76                	push   $0x76
  80155e:	68 33 3c 80 00       	push   $0x803c33
  801563:	e8 68 1d 00 00       	call   8032d0 <_panic>

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801568:	c9                   	leave  
  801569:	c3                   	ret    

0080156a <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80156a:	55                   	push   %ebp
  80156b:	89 e5                	mov    %esp,%ebp
  80156d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801570:	e8 7b fd ff ff       	call   8012f0 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801575:	83 ec 04             	sub    $0x4,%esp
  801578:	68 d8 3c 80 00       	push   $0x803cd8
  80157d:	68 93 00 00 00       	push   $0x93
  801582:	68 33 3c 80 00       	push   $0x803c33
  801587:	e8 44 1d 00 00       	call   8032d0 <_panic>

0080158c <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80158c:	55                   	push   %ebp
  80158d:	89 e5                	mov    %esp,%ebp
  80158f:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801592:	e8 59 fd ff ff       	call   8012f0 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801597:	83 ec 04             	sub    $0x4,%esp
  80159a:	68 fc 3c 80 00       	push   $0x803cfc
  80159f:	68 c5 00 00 00       	push   $0xc5
  8015a4:	68 33 3c 80 00       	push   $0x803c33
  8015a9:	e8 22 1d 00 00       	call   8032d0 <_panic>

008015ae <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8015ae:	55                   	push   %ebp
  8015af:	89 e5                	mov    %esp,%ebp
  8015b1:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8015b4:	83 ec 04             	sub    $0x4,%esp
  8015b7:	68 24 3d 80 00       	push   $0x803d24
  8015bc:	68 d9 00 00 00       	push   $0xd9
  8015c1:	68 33 3c 80 00       	push   $0x803c33
  8015c6:	e8 05 1d 00 00       	call   8032d0 <_panic>

008015cb <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8015cb:	55                   	push   %ebp
  8015cc:	89 e5                	mov    %esp,%ebp
  8015ce:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015d1:	83 ec 04             	sub    $0x4,%esp
  8015d4:	68 48 3d 80 00       	push   $0x803d48
  8015d9:	68 e4 00 00 00       	push   $0xe4
  8015de:	68 33 3c 80 00       	push   $0x803c33
  8015e3:	e8 e8 1c 00 00       	call   8032d0 <_panic>

008015e8 <shrink>:

}
void shrink(uint32 newSize)
{
  8015e8:	55                   	push   %ebp
  8015e9:	89 e5                	mov    %esp,%ebp
  8015eb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015ee:	83 ec 04             	sub    $0x4,%esp
  8015f1:	68 48 3d 80 00       	push   $0x803d48
  8015f6:	68 e9 00 00 00       	push   $0xe9
  8015fb:	68 33 3c 80 00       	push   $0x803c33
  801600:	e8 cb 1c 00 00       	call   8032d0 <_panic>

00801605 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801605:	55                   	push   %ebp
  801606:	89 e5                	mov    %esp,%ebp
  801608:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80160b:	83 ec 04             	sub    $0x4,%esp
  80160e:	68 48 3d 80 00       	push   $0x803d48
  801613:	68 ee 00 00 00       	push   $0xee
  801618:	68 33 3c 80 00       	push   $0x803c33
  80161d:	e8 ae 1c 00 00       	call   8032d0 <_panic>

00801622 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801622:	55                   	push   %ebp
  801623:	89 e5                	mov    %esp,%ebp
  801625:	57                   	push   %edi
  801626:	56                   	push   %esi
  801627:	53                   	push   %ebx
  801628:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80162b:	8b 45 08             	mov    0x8(%ebp),%eax
  80162e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801631:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801634:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801637:	8b 7d 18             	mov    0x18(%ebp),%edi
  80163a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80163d:	cd 30                	int    $0x30
  80163f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801642:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801645:	83 c4 10             	add    $0x10,%esp
  801648:	5b                   	pop    %ebx
  801649:	5e                   	pop    %esi
  80164a:	5f                   	pop    %edi
  80164b:	5d                   	pop    %ebp
  80164c:	c3                   	ret    

0080164d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80164d:	55                   	push   %ebp
  80164e:	89 e5                	mov    %esp,%ebp
  801650:	83 ec 04             	sub    $0x4,%esp
  801653:	8b 45 10             	mov    0x10(%ebp),%eax
  801656:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801659:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80165d:	8b 45 08             	mov    0x8(%ebp),%eax
  801660:	6a 00                	push   $0x0
  801662:	6a 00                	push   $0x0
  801664:	52                   	push   %edx
  801665:	ff 75 0c             	pushl  0xc(%ebp)
  801668:	50                   	push   %eax
  801669:	6a 00                	push   $0x0
  80166b:	e8 b2 ff ff ff       	call   801622 <syscall>
  801670:	83 c4 18             	add    $0x18,%esp
}
  801673:	90                   	nop
  801674:	c9                   	leave  
  801675:	c3                   	ret    

00801676 <sys_cgetc>:

int
sys_cgetc(void)
{
  801676:	55                   	push   %ebp
  801677:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801679:	6a 00                	push   $0x0
  80167b:	6a 00                	push   $0x0
  80167d:	6a 00                	push   $0x0
  80167f:	6a 00                	push   $0x0
  801681:	6a 00                	push   $0x0
  801683:	6a 01                	push   $0x1
  801685:	e8 98 ff ff ff       	call   801622 <syscall>
  80168a:	83 c4 18             	add    $0x18,%esp
}
  80168d:	c9                   	leave  
  80168e:	c3                   	ret    

0080168f <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80168f:	55                   	push   %ebp
  801690:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801692:	8b 55 0c             	mov    0xc(%ebp),%edx
  801695:	8b 45 08             	mov    0x8(%ebp),%eax
  801698:	6a 00                	push   $0x0
  80169a:	6a 00                	push   $0x0
  80169c:	6a 00                	push   $0x0
  80169e:	52                   	push   %edx
  80169f:	50                   	push   %eax
  8016a0:	6a 05                	push   $0x5
  8016a2:	e8 7b ff ff ff       	call   801622 <syscall>
  8016a7:	83 c4 18             	add    $0x18,%esp
}
  8016aa:	c9                   	leave  
  8016ab:	c3                   	ret    

008016ac <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8016ac:	55                   	push   %ebp
  8016ad:	89 e5                	mov    %esp,%ebp
  8016af:	56                   	push   %esi
  8016b0:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8016b1:	8b 75 18             	mov    0x18(%ebp),%esi
  8016b4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c0:	56                   	push   %esi
  8016c1:	53                   	push   %ebx
  8016c2:	51                   	push   %ecx
  8016c3:	52                   	push   %edx
  8016c4:	50                   	push   %eax
  8016c5:	6a 06                	push   $0x6
  8016c7:	e8 56 ff ff ff       	call   801622 <syscall>
  8016cc:	83 c4 18             	add    $0x18,%esp
}
  8016cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016d2:	5b                   	pop    %ebx
  8016d3:	5e                   	pop    %esi
  8016d4:	5d                   	pop    %ebp
  8016d5:	c3                   	ret    

008016d6 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8016d6:	55                   	push   %ebp
  8016d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8016d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016df:	6a 00                	push   $0x0
  8016e1:	6a 00                	push   $0x0
  8016e3:	6a 00                	push   $0x0
  8016e5:	52                   	push   %edx
  8016e6:	50                   	push   %eax
  8016e7:	6a 07                	push   $0x7
  8016e9:	e8 34 ff ff ff       	call   801622 <syscall>
  8016ee:	83 c4 18             	add    $0x18,%esp
}
  8016f1:	c9                   	leave  
  8016f2:	c3                   	ret    

008016f3 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8016f3:	55                   	push   %ebp
  8016f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8016f6:	6a 00                	push   $0x0
  8016f8:	6a 00                	push   $0x0
  8016fa:	6a 00                	push   $0x0
  8016fc:	ff 75 0c             	pushl  0xc(%ebp)
  8016ff:	ff 75 08             	pushl  0x8(%ebp)
  801702:	6a 08                	push   $0x8
  801704:	e8 19 ff ff ff       	call   801622 <syscall>
  801709:	83 c4 18             	add    $0x18,%esp
}
  80170c:	c9                   	leave  
  80170d:	c3                   	ret    

0080170e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80170e:	55                   	push   %ebp
  80170f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801711:	6a 00                	push   $0x0
  801713:	6a 00                	push   $0x0
  801715:	6a 00                	push   $0x0
  801717:	6a 00                	push   $0x0
  801719:	6a 00                	push   $0x0
  80171b:	6a 09                	push   $0x9
  80171d:	e8 00 ff ff ff       	call   801622 <syscall>
  801722:	83 c4 18             	add    $0x18,%esp
}
  801725:	c9                   	leave  
  801726:	c3                   	ret    

00801727 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801727:	55                   	push   %ebp
  801728:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80172a:	6a 00                	push   $0x0
  80172c:	6a 00                	push   $0x0
  80172e:	6a 00                	push   $0x0
  801730:	6a 00                	push   $0x0
  801732:	6a 00                	push   $0x0
  801734:	6a 0a                	push   $0xa
  801736:	e8 e7 fe ff ff       	call   801622 <syscall>
  80173b:	83 c4 18             	add    $0x18,%esp
}
  80173e:	c9                   	leave  
  80173f:	c3                   	ret    

00801740 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801740:	55                   	push   %ebp
  801741:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801743:	6a 00                	push   $0x0
  801745:	6a 00                	push   $0x0
  801747:	6a 00                	push   $0x0
  801749:	6a 00                	push   $0x0
  80174b:	6a 00                	push   $0x0
  80174d:	6a 0b                	push   $0xb
  80174f:	e8 ce fe ff ff       	call   801622 <syscall>
  801754:	83 c4 18             	add    $0x18,%esp
}
  801757:	c9                   	leave  
  801758:	c3                   	ret    

00801759 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801759:	55                   	push   %ebp
  80175a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80175c:	6a 00                	push   $0x0
  80175e:	6a 00                	push   $0x0
  801760:	6a 00                	push   $0x0
  801762:	ff 75 0c             	pushl  0xc(%ebp)
  801765:	ff 75 08             	pushl  0x8(%ebp)
  801768:	6a 0f                	push   $0xf
  80176a:	e8 b3 fe ff ff       	call   801622 <syscall>
  80176f:	83 c4 18             	add    $0x18,%esp
	return;
  801772:	90                   	nop
}
  801773:	c9                   	leave  
  801774:	c3                   	ret    

00801775 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801775:	55                   	push   %ebp
  801776:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801778:	6a 00                	push   $0x0
  80177a:	6a 00                	push   $0x0
  80177c:	6a 00                	push   $0x0
  80177e:	ff 75 0c             	pushl  0xc(%ebp)
  801781:	ff 75 08             	pushl  0x8(%ebp)
  801784:	6a 10                	push   $0x10
  801786:	e8 97 fe ff ff       	call   801622 <syscall>
  80178b:	83 c4 18             	add    $0x18,%esp
	return ;
  80178e:	90                   	nop
}
  80178f:	c9                   	leave  
  801790:	c3                   	ret    

00801791 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801791:	55                   	push   %ebp
  801792:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801794:	6a 00                	push   $0x0
  801796:	6a 00                	push   $0x0
  801798:	ff 75 10             	pushl  0x10(%ebp)
  80179b:	ff 75 0c             	pushl  0xc(%ebp)
  80179e:	ff 75 08             	pushl  0x8(%ebp)
  8017a1:	6a 11                	push   $0x11
  8017a3:	e8 7a fe ff ff       	call   801622 <syscall>
  8017a8:	83 c4 18             	add    $0x18,%esp
	return ;
  8017ab:	90                   	nop
}
  8017ac:	c9                   	leave  
  8017ad:	c3                   	ret    

008017ae <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017ae:	55                   	push   %ebp
  8017af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8017b1:	6a 00                	push   $0x0
  8017b3:	6a 00                	push   $0x0
  8017b5:	6a 00                	push   $0x0
  8017b7:	6a 00                	push   $0x0
  8017b9:	6a 00                	push   $0x0
  8017bb:	6a 0c                	push   $0xc
  8017bd:	e8 60 fe ff ff       	call   801622 <syscall>
  8017c2:	83 c4 18             	add    $0x18,%esp
}
  8017c5:	c9                   	leave  
  8017c6:	c3                   	ret    

008017c7 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017c7:	55                   	push   %ebp
  8017c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8017ca:	6a 00                	push   $0x0
  8017cc:	6a 00                	push   $0x0
  8017ce:	6a 00                	push   $0x0
  8017d0:	6a 00                	push   $0x0
  8017d2:	ff 75 08             	pushl  0x8(%ebp)
  8017d5:	6a 0d                	push   $0xd
  8017d7:	e8 46 fe ff ff       	call   801622 <syscall>
  8017dc:	83 c4 18             	add    $0x18,%esp
}
  8017df:	c9                   	leave  
  8017e0:	c3                   	ret    

008017e1 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8017e1:	55                   	push   %ebp
  8017e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8017e4:	6a 00                	push   $0x0
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 00                	push   $0x0
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 0e                	push   $0xe
  8017f0:	e8 2d fe ff ff       	call   801622 <syscall>
  8017f5:	83 c4 18             	add    $0x18,%esp
}
  8017f8:	90                   	nop
  8017f9:	c9                   	leave  
  8017fa:	c3                   	ret    

008017fb <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8017fb:	55                   	push   %ebp
  8017fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8017fe:	6a 00                	push   $0x0
  801800:	6a 00                	push   $0x0
  801802:	6a 00                	push   $0x0
  801804:	6a 00                	push   $0x0
  801806:	6a 00                	push   $0x0
  801808:	6a 13                	push   $0x13
  80180a:	e8 13 fe ff ff       	call   801622 <syscall>
  80180f:	83 c4 18             	add    $0x18,%esp
}
  801812:	90                   	nop
  801813:	c9                   	leave  
  801814:	c3                   	ret    

00801815 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801815:	55                   	push   %ebp
  801816:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801818:	6a 00                	push   $0x0
  80181a:	6a 00                	push   $0x0
  80181c:	6a 00                	push   $0x0
  80181e:	6a 00                	push   $0x0
  801820:	6a 00                	push   $0x0
  801822:	6a 14                	push   $0x14
  801824:	e8 f9 fd ff ff       	call   801622 <syscall>
  801829:	83 c4 18             	add    $0x18,%esp
}
  80182c:	90                   	nop
  80182d:	c9                   	leave  
  80182e:	c3                   	ret    

0080182f <sys_cputc>:


void
sys_cputc(const char c)
{
  80182f:	55                   	push   %ebp
  801830:	89 e5                	mov    %esp,%ebp
  801832:	83 ec 04             	sub    $0x4,%esp
  801835:	8b 45 08             	mov    0x8(%ebp),%eax
  801838:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80183b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80183f:	6a 00                	push   $0x0
  801841:	6a 00                	push   $0x0
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	50                   	push   %eax
  801848:	6a 15                	push   $0x15
  80184a:	e8 d3 fd ff ff       	call   801622 <syscall>
  80184f:	83 c4 18             	add    $0x18,%esp
}
  801852:	90                   	nop
  801853:	c9                   	leave  
  801854:	c3                   	ret    

00801855 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801855:	55                   	push   %ebp
  801856:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 16                	push   $0x16
  801864:	e8 b9 fd ff ff       	call   801622 <syscall>
  801869:	83 c4 18             	add    $0x18,%esp
}
  80186c:	90                   	nop
  80186d:	c9                   	leave  
  80186e:	c3                   	ret    

0080186f <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80186f:	55                   	push   %ebp
  801870:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801872:	8b 45 08             	mov    0x8(%ebp),%eax
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	ff 75 0c             	pushl  0xc(%ebp)
  80187e:	50                   	push   %eax
  80187f:	6a 17                	push   $0x17
  801881:	e8 9c fd ff ff       	call   801622 <syscall>
  801886:	83 c4 18             	add    $0x18,%esp
}
  801889:	c9                   	leave  
  80188a:	c3                   	ret    

0080188b <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80188b:	55                   	push   %ebp
  80188c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80188e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801891:	8b 45 08             	mov    0x8(%ebp),%eax
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	52                   	push   %edx
  80189b:	50                   	push   %eax
  80189c:	6a 1a                	push   $0x1a
  80189e:	e8 7f fd ff ff       	call   801622 <syscall>
  8018a3:	83 c4 18             	add    $0x18,%esp
}
  8018a6:	c9                   	leave  
  8018a7:	c3                   	ret    

008018a8 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018a8:	55                   	push   %ebp
  8018a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 00                	push   $0x0
  8018b7:	52                   	push   %edx
  8018b8:	50                   	push   %eax
  8018b9:	6a 18                	push   $0x18
  8018bb:	e8 62 fd ff ff       	call   801622 <syscall>
  8018c0:	83 c4 18             	add    $0x18,%esp
}
  8018c3:	90                   	nop
  8018c4:	c9                   	leave  
  8018c5:	c3                   	ret    

008018c6 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018c6:	55                   	push   %ebp
  8018c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 00                	push   $0x0
  8018d5:	52                   	push   %edx
  8018d6:	50                   	push   %eax
  8018d7:	6a 19                	push   $0x19
  8018d9:	e8 44 fd ff ff       	call   801622 <syscall>
  8018de:	83 c4 18             	add    $0x18,%esp
}
  8018e1:	90                   	nop
  8018e2:	c9                   	leave  
  8018e3:	c3                   	ret    

008018e4 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8018e4:	55                   	push   %ebp
  8018e5:	89 e5                	mov    %esp,%ebp
  8018e7:	83 ec 04             	sub    $0x4,%esp
  8018ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8018ed:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8018f0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018f3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fa:	6a 00                	push   $0x0
  8018fc:	51                   	push   %ecx
  8018fd:	52                   	push   %edx
  8018fe:	ff 75 0c             	pushl  0xc(%ebp)
  801901:	50                   	push   %eax
  801902:	6a 1b                	push   $0x1b
  801904:	e8 19 fd ff ff       	call   801622 <syscall>
  801909:	83 c4 18             	add    $0x18,%esp
}
  80190c:	c9                   	leave  
  80190d:	c3                   	ret    

0080190e <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80190e:	55                   	push   %ebp
  80190f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801911:	8b 55 0c             	mov    0xc(%ebp),%edx
  801914:	8b 45 08             	mov    0x8(%ebp),%eax
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	52                   	push   %edx
  80191e:	50                   	push   %eax
  80191f:	6a 1c                	push   $0x1c
  801921:	e8 fc fc ff ff       	call   801622 <syscall>
  801926:	83 c4 18             	add    $0x18,%esp
}
  801929:	c9                   	leave  
  80192a:	c3                   	ret    

0080192b <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80192b:	55                   	push   %ebp
  80192c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80192e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801931:	8b 55 0c             	mov    0xc(%ebp),%edx
  801934:	8b 45 08             	mov    0x8(%ebp),%eax
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	51                   	push   %ecx
  80193c:	52                   	push   %edx
  80193d:	50                   	push   %eax
  80193e:	6a 1d                	push   $0x1d
  801940:	e8 dd fc ff ff       	call   801622 <syscall>
  801945:	83 c4 18             	add    $0x18,%esp
}
  801948:	c9                   	leave  
  801949:	c3                   	ret    

0080194a <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80194d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801950:	8b 45 08             	mov    0x8(%ebp),%eax
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	52                   	push   %edx
  80195a:	50                   	push   %eax
  80195b:	6a 1e                	push   $0x1e
  80195d:	e8 c0 fc ff ff       	call   801622 <syscall>
  801962:	83 c4 18             	add    $0x18,%esp
}
  801965:	c9                   	leave  
  801966:	c3                   	ret    

00801967 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801967:	55                   	push   %ebp
  801968:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	6a 1f                	push   $0x1f
  801976:	e8 a7 fc ff ff       	call   801622 <syscall>
  80197b:	83 c4 18             	add    $0x18,%esp
}
  80197e:	c9                   	leave  
  80197f:	c3                   	ret    

00801980 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801980:	55                   	push   %ebp
  801981:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801983:	8b 45 08             	mov    0x8(%ebp),%eax
  801986:	6a 00                	push   $0x0
  801988:	ff 75 14             	pushl  0x14(%ebp)
  80198b:	ff 75 10             	pushl  0x10(%ebp)
  80198e:	ff 75 0c             	pushl  0xc(%ebp)
  801991:	50                   	push   %eax
  801992:	6a 20                	push   $0x20
  801994:	e8 89 fc ff ff       	call   801622 <syscall>
  801999:	83 c4 18             	add    $0x18,%esp
}
  80199c:	c9                   	leave  
  80199d:	c3                   	ret    

0080199e <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80199e:	55                   	push   %ebp
  80199f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8019a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	50                   	push   %eax
  8019ad:	6a 21                	push   $0x21
  8019af:	e8 6e fc ff ff       	call   801622 <syscall>
  8019b4:	83 c4 18             	add    $0x18,%esp
}
  8019b7:	90                   	nop
  8019b8:	c9                   	leave  
  8019b9:	c3                   	ret    

008019ba <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8019ba:	55                   	push   %ebp
  8019bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8019bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 00                	push   $0x0
  8019c8:	50                   	push   %eax
  8019c9:	6a 22                	push   $0x22
  8019cb:	e8 52 fc ff ff       	call   801622 <syscall>
  8019d0:	83 c4 18             	add    $0x18,%esp
}
  8019d3:	c9                   	leave  
  8019d4:	c3                   	ret    

008019d5 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8019d5:	55                   	push   %ebp
  8019d6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 02                	push   $0x2
  8019e4:	e8 39 fc ff ff       	call   801622 <syscall>
  8019e9:	83 c4 18             	add    $0x18,%esp
}
  8019ec:	c9                   	leave  
  8019ed:	c3                   	ret    

008019ee <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8019ee:	55                   	push   %ebp
  8019ef:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 03                	push   $0x3
  8019fd:	e8 20 fc ff ff       	call   801622 <syscall>
  801a02:	83 c4 18             	add    $0x18,%esp
}
  801a05:	c9                   	leave  
  801a06:	c3                   	ret    

00801a07 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a07:	55                   	push   %ebp
  801a08:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 04                	push   $0x4
  801a16:	e8 07 fc ff ff       	call   801622 <syscall>
  801a1b:	83 c4 18             	add    $0x18,%esp
}
  801a1e:	c9                   	leave  
  801a1f:	c3                   	ret    

00801a20 <sys_exit_env>:


void sys_exit_env(void)
{
  801a20:	55                   	push   %ebp
  801a21:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a23:	6a 00                	push   $0x0
  801a25:	6a 00                	push   $0x0
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 23                	push   $0x23
  801a2f:	e8 ee fb ff ff       	call   801622 <syscall>
  801a34:	83 c4 18             	add    $0x18,%esp
}
  801a37:	90                   	nop
  801a38:	c9                   	leave  
  801a39:	c3                   	ret    

00801a3a <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801a3a:	55                   	push   %ebp
  801a3b:	89 e5                	mov    %esp,%ebp
  801a3d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a40:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a43:	8d 50 04             	lea    0x4(%eax),%edx
  801a46:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	52                   	push   %edx
  801a50:	50                   	push   %eax
  801a51:	6a 24                	push   $0x24
  801a53:	e8 ca fb ff ff       	call   801622 <syscall>
  801a58:	83 c4 18             	add    $0x18,%esp
	return result;
  801a5b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a5e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a61:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a64:	89 01                	mov    %eax,(%ecx)
  801a66:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a69:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6c:	c9                   	leave  
  801a6d:	c2 04 00             	ret    $0x4

00801a70 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a70:	55                   	push   %ebp
  801a71:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	ff 75 10             	pushl  0x10(%ebp)
  801a7a:	ff 75 0c             	pushl  0xc(%ebp)
  801a7d:	ff 75 08             	pushl  0x8(%ebp)
  801a80:	6a 12                	push   $0x12
  801a82:	e8 9b fb ff ff       	call   801622 <syscall>
  801a87:	83 c4 18             	add    $0x18,%esp
	return ;
  801a8a:	90                   	nop
}
  801a8b:	c9                   	leave  
  801a8c:	c3                   	ret    

00801a8d <sys_rcr2>:
uint32 sys_rcr2()
{
  801a8d:	55                   	push   %ebp
  801a8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 25                	push   $0x25
  801a9c:	e8 81 fb ff ff       	call   801622 <syscall>
  801aa1:	83 c4 18             	add    $0x18,%esp
}
  801aa4:	c9                   	leave  
  801aa5:	c3                   	ret    

00801aa6 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801aa6:	55                   	push   %ebp
  801aa7:	89 e5                	mov    %esp,%ebp
  801aa9:	83 ec 04             	sub    $0x4,%esp
  801aac:	8b 45 08             	mov    0x8(%ebp),%eax
  801aaf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ab2:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	50                   	push   %eax
  801abf:	6a 26                	push   $0x26
  801ac1:	e8 5c fb ff ff       	call   801622 <syscall>
  801ac6:	83 c4 18             	add    $0x18,%esp
	return ;
  801ac9:	90                   	nop
}
  801aca:	c9                   	leave  
  801acb:	c3                   	ret    

00801acc <rsttst>:
void rsttst()
{
  801acc:	55                   	push   %ebp
  801acd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 28                	push   $0x28
  801adb:	e8 42 fb ff ff       	call   801622 <syscall>
  801ae0:	83 c4 18             	add    $0x18,%esp
	return ;
  801ae3:	90                   	nop
}
  801ae4:	c9                   	leave  
  801ae5:	c3                   	ret    

00801ae6 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ae6:	55                   	push   %ebp
  801ae7:	89 e5                	mov    %esp,%ebp
  801ae9:	83 ec 04             	sub    $0x4,%esp
  801aec:	8b 45 14             	mov    0x14(%ebp),%eax
  801aef:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801af2:	8b 55 18             	mov    0x18(%ebp),%edx
  801af5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801af9:	52                   	push   %edx
  801afa:	50                   	push   %eax
  801afb:	ff 75 10             	pushl  0x10(%ebp)
  801afe:	ff 75 0c             	pushl  0xc(%ebp)
  801b01:	ff 75 08             	pushl  0x8(%ebp)
  801b04:	6a 27                	push   $0x27
  801b06:	e8 17 fb ff ff       	call   801622 <syscall>
  801b0b:	83 c4 18             	add    $0x18,%esp
	return ;
  801b0e:	90                   	nop
}
  801b0f:	c9                   	leave  
  801b10:	c3                   	ret    

00801b11 <chktst>:
void chktst(uint32 n)
{
  801b11:	55                   	push   %ebp
  801b12:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	ff 75 08             	pushl  0x8(%ebp)
  801b1f:	6a 29                	push   $0x29
  801b21:	e8 fc fa ff ff       	call   801622 <syscall>
  801b26:	83 c4 18             	add    $0x18,%esp
	return ;
  801b29:	90                   	nop
}
  801b2a:	c9                   	leave  
  801b2b:	c3                   	ret    

00801b2c <inctst>:

void inctst()
{
  801b2c:	55                   	push   %ebp
  801b2d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	6a 2a                	push   $0x2a
  801b3b:	e8 e2 fa ff ff       	call   801622 <syscall>
  801b40:	83 c4 18             	add    $0x18,%esp
	return ;
  801b43:	90                   	nop
}
  801b44:	c9                   	leave  
  801b45:	c3                   	ret    

00801b46 <gettst>:
uint32 gettst()
{
  801b46:	55                   	push   %ebp
  801b47:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	6a 2b                	push   $0x2b
  801b55:	e8 c8 fa ff ff       	call   801622 <syscall>
  801b5a:	83 c4 18             	add    $0x18,%esp
}
  801b5d:	c9                   	leave  
  801b5e:	c3                   	ret    

00801b5f <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801b5f:	55                   	push   %ebp
  801b60:	89 e5                	mov    %esp,%ebp
  801b62:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 2c                	push   $0x2c
  801b71:	e8 ac fa ff ff       	call   801622 <syscall>
  801b76:	83 c4 18             	add    $0x18,%esp
  801b79:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801b7c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801b80:	75 07                	jne    801b89 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801b82:	b8 01 00 00 00       	mov    $0x1,%eax
  801b87:	eb 05                	jmp    801b8e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801b89:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b8e:	c9                   	leave  
  801b8f:	c3                   	ret    

00801b90 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801b90:	55                   	push   %ebp
  801b91:	89 e5                	mov    %esp,%ebp
  801b93:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 2c                	push   $0x2c
  801ba2:	e8 7b fa ff ff       	call   801622 <syscall>
  801ba7:	83 c4 18             	add    $0x18,%esp
  801baa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801bad:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801bb1:	75 07                	jne    801bba <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801bb3:	b8 01 00 00 00       	mov    $0x1,%eax
  801bb8:	eb 05                	jmp    801bbf <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801bba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bbf:	c9                   	leave  
  801bc0:	c3                   	ret    

00801bc1 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801bc1:	55                   	push   %ebp
  801bc2:	89 e5                	mov    %esp,%ebp
  801bc4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 2c                	push   $0x2c
  801bd3:	e8 4a fa ff ff       	call   801622 <syscall>
  801bd8:	83 c4 18             	add    $0x18,%esp
  801bdb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801bde:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801be2:	75 07                	jne    801beb <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801be4:	b8 01 00 00 00       	mov    $0x1,%eax
  801be9:	eb 05                	jmp    801bf0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801beb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bf0:	c9                   	leave  
  801bf1:	c3                   	ret    

00801bf2 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801bf2:	55                   	push   %ebp
  801bf3:	89 e5                	mov    %esp,%ebp
  801bf5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 2c                	push   $0x2c
  801c04:	e8 19 fa ff ff       	call   801622 <syscall>
  801c09:	83 c4 18             	add    $0x18,%esp
  801c0c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c0f:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c13:	75 07                	jne    801c1c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c15:	b8 01 00 00 00       	mov    $0x1,%eax
  801c1a:	eb 05                	jmp    801c21 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c1c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c21:	c9                   	leave  
  801c22:	c3                   	ret    

00801c23 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c23:	55                   	push   %ebp
  801c24:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c26:	6a 00                	push   $0x0
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 00                	push   $0x0
  801c2e:	ff 75 08             	pushl  0x8(%ebp)
  801c31:	6a 2d                	push   $0x2d
  801c33:	e8 ea f9 ff ff       	call   801622 <syscall>
  801c38:	83 c4 18             	add    $0x18,%esp
	return ;
  801c3b:	90                   	nop
}
  801c3c:	c9                   	leave  
  801c3d:	c3                   	ret    

00801c3e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c3e:	55                   	push   %ebp
  801c3f:	89 e5                	mov    %esp,%ebp
  801c41:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c42:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c45:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c48:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4e:	6a 00                	push   $0x0
  801c50:	53                   	push   %ebx
  801c51:	51                   	push   %ecx
  801c52:	52                   	push   %edx
  801c53:	50                   	push   %eax
  801c54:	6a 2e                	push   $0x2e
  801c56:	e8 c7 f9 ff ff       	call   801622 <syscall>
  801c5b:	83 c4 18             	add    $0x18,%esp
}
  801c5e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c61:	c9                   	leave  
  801c62:	c3                   	ret    

00801c63 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c63:	55                   	push   %ebp
  801c64:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c66:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c69:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	52                   	push   %edx
  801c73:	50                   	push   %eax
  801c74:	6a 2f                	push   $0x2f
  801c76:	e8 a7 f9 ff ff       	call   801622 <syscall>
  801c7b:	83 c4 18             	add    $0x18,%esp
}
  801c7e:	c9                   	leave  
  801c7f:	c3                   	ret    

00801c80 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801c80:	55                   	push   %ebp
  801c81:	89 e5                	mov    %esp,%ebp
  801c83:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801c86:	83 ec 0c             	sub    $0xc,%esp
  801c89:	68 58 3d 80 00       	push   $0x803d58
  801c8e:	e8 d3 e8 ff ff       	call   800566 <cprintf>
  801c93:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801c96:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801c9d:	83 ec 0c             	sub    $0xc,%esp
  801ca0:	68 84 3d 80 00       	push   $0x803d84
  801ca5:	e8 bc e8 ff ff       	call   800566 <cprintf>
  801caa:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801cad:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801cb1:	a1 38 51 80 00       	mov    0x805138,%eax
  801cb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cb9:	eb 56                	jmp    801d11 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801cbb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801cbf:	74 1c                	je     801cdd <print_mem_block_lists+0x5d>
  801cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cc4:	8b 50 08             	mov    0x8(%eax),%edx
  801cc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cca:	8b 48 08             	mov    0x8(%eax),%ecx
  801ccd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cd0:	8b 40 0c             	mov    0xc(%eax),%eax
  801cd3:	01 c8                	add    %ecx,%eax
  801cd5:	39 c2                	cmp    %eax,%edx
  801cd7:	73 04                	jae    801cdd <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801cd9:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801cdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ce0:	8b 50 08             	mov    0x8(%eax),%edx
  801ce3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ce6:	8b 40 0c             	mov    0xc(%eax),%eax
  801ce9:	01 c2                	add    %eax,%edx
  801ceb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cee:	8b 40 08             	mov    0x8(%eax),%eax
  801cf1:	83 ec 04             	sub    $0x4,%esp
  801cf4:	52                   	push   %edx
  801cf5:	50                   	push   %eax
  801cf6:	68 99 3d 80 00       	push   $0x803d99
  801cfb:	e8 66 e8 ff ff       	call   800566 <cprintf>
  801d00:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d06:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d09:	a1 40 51 80 00       	mov    0x805140,%eax
  801d0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d11:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d15:	74 07                	je     801d1e <print_mem_block_lists+0x9e>
  801d17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d1a:	8b 00                	mov    (%eax),%eax
  801d1c:	eb 05                	jmp    801d23 <print_mem_block_lists+0xa3>
  801d1e:	b8 00 00 00 00       	mov    $0x0,%eax
  801d23:	a3 40 51 80 00       	mov    %eax,0x805140
  801d28:	a1 40 51 80 00       	mov    0x805140,%eax
  801d2d:	85 c0                	test   %eax,%eax
  801d2f:	75 8a                	jne    801cbb <print_mem_block_lists+0x3b>
  801d31:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d35:	75 84                	jne    801cbb <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801d37:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801d3b:	75 10                	jne    801d4d <print_mem_block_lists+0xcd>
  801d3d:	83 ec 0c             	sub    $0xc,%esp
  801d40:	68 a8 3d 80 00       	push   $0x803da8
  801d45:	e8 1c e8 ff ff       	call   800566 <cprintf>
  801d4a:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801d4d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801d54:	83 ec 0c             	sub    $0xc,%esp
  801d57:	68 cc 3d 80 00       	push   $0x803dcc
  801d5c:	e8 05 e8 ff ff       	call   800566 <cprintf>
  801d61:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801d64:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801d68:	a1 40 50 80 00       	mov    0x805040,%eax
  801d6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d70:	eb 56                	jmp    801dc8 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d72:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d76:	74 1c                	je     801d94 <print_mem_block_lists+0x114>
  801d78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d7b:	8b 50 08             	mov    0x8(%eax),%edx
  801d7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d81:	8b 48 08             	mov    0x8(%eax),%ecx
  801d84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d87:	8b 40 0c             	mov    0xc(%eax),%eax
  801d8a:	01 c8                	add    %ecx,%eax
  801d8c:	39 c2                	cmp    %eax,%edx
  801d8e:	73 04                	jae    801d94 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801d90:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d97:	8b 50 08             	mov    0x8(%eax),%edx
  801d9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d9d:	8b 40 0c             	mov    0xc(%eax),%eax
  801da0:	01 c2                	add    %eax,%edx
  801da2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da5:	8b 40 08             	mov    0x8(%eax),%eax
  801da8:	83 ec 04             	sub    $0x4,%esp
  801dab:	52                   	push   %edx
  801dac:	50                   	push   %eax
  801dad:	68 99 3d 80 00       	push   $0x803d99
  801db2:	e8 af e7 ff ff       	call   800566 <cprintf>
  801db7:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801dba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dbd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801dc0:	a1 48 50 80 00       	mov    0x805048,%eax
  801dc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dc8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dcc:	74 07                	je     801dd5 <print_mem_block_lists+0x155>
  801dce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd1:	8b 00                	mov    (%eax),%eax
  801dd3:	eb 05                	jmp    801dda <print_mem_block_lists+0x15a>
  801dd5:	b8 00 00 00 00       	mov    $0x0,%eax
  801dda:	a3 48 50 80 00       	mov    %eax,0x805048
  801ddf:	a1 48 50 80 00       	mov    0x805048,%eax
  801de4:	85 c0                	test   %eax,%eax
  801de6:	75 8a                	jne    801d72 <print_mem_block_lists+0xf2>
  801de8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dec:	75 84                	jne    801d72 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801dee:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801df2:	75 10                	jne    801e04 <print_mem_block_lists+0x184>
  801df4:	83 ec 0c             	sub    $0xc,%esp
  801df7:	68 e4 3d 80 00       	push   $0x803de4
  801dfc:	e8 65 e7 ff ff       	call   800566 <cprintf>
  801e01:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801e04:	83 ec 0c             	sub    $0xc,%esp
  801e07:	68 58 3d 80 00       	push   $0x803d58
  801e0c:	e8 55 e7 ff ff       	call   800566 <cprintf>
  801e11:	83 c4 10             	add    $0x10,%esp

}
  801e14:	90                   	nop
  801e15:	c9                   	leave  
  801e16:	c3                   	ret    

00801e17 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801e17:	55                   	push   %ebp
  801e18:	89 e5                	mov    %esp,%ebp
  801e1a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801e1d:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801e24:	00 00 00 
  801e27:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801e2e:	00 00 00 
  801e31:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801e38:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801e3b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801e42:	e9 9e 00 00 00       	jmp    801ee5 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801e47:	a1 50 50 80 00       	mov    0x805050,%eax
  801e4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e4f:	c1 e2 04             	shl    $0x4,%edx
  801e52:	01 d0                	add    %edx,%eax
  801e54:	85 c0                	test   %eax,%eax
  801e56:	75 14                	jne    801e6c <initialize_MemBlocksList+0x55>
  801e58:	83 ec 04             	sub    $0x4,%esp
  801e5b:	68 0c 3e 80 00       	push   $0x803e0c
  801e60:	6a 46                	push   $0x46
  801e62:	68 2f 3e 80 00       	push   $0x803e2f
  801e67:	e8 64 14 00 00       	call   8032d0 <_panic>
  801e6c:	a1 50 50 80 00       	mov    0x805050,%eax
  801e71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e74:	c1 e2 04             	shl    $0x4,%edx
  801e77:	01 d0                	add    %edx,%eax
  801e79:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801e7f:	89 10                	mov    %edx,(%eax)
  801e81:	8b 00                	mov    (%eax),%eax
  801e83:	85 c0                	test   %eax,%eax
  801e85:	74 18                	je     801e9f <initialize_MemBlocksList+0x88>
  801e87:	a1 48 51 80 00       	mov    0x805148,%eax
  801e8c:	8b 15 50 50 80 00    	mov    0x805050,%edx
  801e92:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801e95:	c1 e1 04             	shl    $0x4,%ecx
  801e98:	01 ca                	add    %ecx,%edx
  801e9a:	89 50 04             	mov    %edx,0x4(%eax)
  801e9d:	eb 12                	jmp    801eb1 <initialize_MemBlocksList+0x9a>
  801e9f:	a1 50 50 80 00       	mov    0x805050,%eax
  801ea4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ea7:	c1 e2 04             	shl    $0x4,%edx
  801eaa:	01 d0                	add    %edx,%eax
  801eac:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801eb1:	a1 50 50 80 00       	mov    0x805050,%eax
  801eb6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eb9:	c1 e2 04             	shl    $0x4,%edx
  801ebc:	01 d0                	add    %edx,%eax
  801ebe:	a3 48 51 80 00       	mov    %eax,0x805148
  801ec3:	a1 50 50 80 00       	mov    0x805050,%eax
  801ec8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ecb:	c1 e2 04             	shl    $0x4,%edx
  801ece:	01 d0                	add    %edx,%eax
  801ed0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ed7:	a1 54 51 80 00       	mov    0x805154,%eax
  801edc:	40                   	inc    %eax
  801edd:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801ee2:	ff 45 f4             	incl   -0xc(%ebp)
  801ee5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee8:	3b 45 08             	cmp    0x8(%ebp),%eax
  801eeb:	0f 82 56 ff ff ff    	jb     801e47 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801ef1:	90                   	nop
  801ef2:	c9                   	leave  
  801ef3:	c3                   	ret    

00801ef4 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801ef4:	55                   	push   %ebp
  801ef5:	89 e5                	mov    %esp,%ebp
  801ef7:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801efa:	8b 45 08             	mov    0x8(%ebp),%eax
  801efd:	8b 00                	mov    (%eax),%eax
  801eff:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f02:	eb 19                	jmp    801f1d <find_block+0x29>
	{
		if(va==point->sva)
  801f04:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f07:	8b 40 08             	mov    0x8(%eax),%eax
  801f0a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801f0d:	75 05                	jne    801f14 <find_block+0x20>
		   return point;
  801f0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f12:	eb 36                	jmp    801f4a <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f14:	8b 45 08             	mov    0x8(%ebp),%eax
  801f17:	8b 40 08             	mov    0x8(%eax),%eax
  801f1a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f1d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f21:	74 07                	je     801f2a <find_block+0x36>
  801f23:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f26:	8b 00                	mov    (%eax),%eax
  801f28:	eb 05                	jmp    801f2f <find_block+0x3b>
  801f2a:	b8 00 00 00 00       	mov    $0x0,%eax
  801f2f:	8b 55 08             	mov    0x8(%ebp),%edx
  801f32:	89 42 08             	mov    %eax,0x8(%edx)
  801f35:	8b 45 08             	mov    0x8(%ebp),%eax
  801f38:	8b 40 08             	mov    0x8(%eax),%eax
  801f3b:	85 c0                	test   %eax,%eax
  801f3d:	75 c5                	jne    801f04 <find_block+0x10>
  801f3f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f43:	75 bf                	jne    801f04 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801f45:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f4a:	c9                   	leave  
  801f4b:	c3                   	ret    

00801f4c <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801f4c:	55                   	push   %ebp
  801f4d:	89 e5                	mov    %esp,%ebp
  801f4f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801f52:	a1 40 50 80 00       	mov    0x805040,%eax
  801f57:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801f5a:	a1 44 50 80 00       	mov    0x805044,%eax
  801f5f:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801f62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f65:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801f68:	74 24                	je     801f8e <insert_sorted_allocList+0x42>
  801f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6d:	8b 50 08             	mov    0x8(%eax),%edx
  801f70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f73:	8b 40 08             	mov    0x8(%eax),%eax
  801f76:	39 c2                	cmp    %eax,%edx
  801f78:	76 14                	jbe    801f8e <insert_sorted_allocList+0x42>
  801f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7d:	8b 50 08             	mov    0x8(%eax),%edx
  801f80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f83:	8b 40 08             	mov    0x8(%eax),%eax
  801f86:	39 c2                	cmp    %eax,%edx
  801f88:	0f 82 60 01 00 00    	jb     8020ee <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  801f8e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f92:	75 65                	jne    801ff9 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  801f94:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f98:	75 14                	jne    801fae <insert_sorted_allocList+0x62>
  801f9a:	83 ec 04             	sub    $0x4,%esp
  801f9d:	68 0c 3e 80 00       	push   $0x803e0c
  801fa2:	6a 6b                	push   $0x6b
  801fa4:	68 2f 3e 80 00       	push   $0x803e2f
  801fa9:	e8 22 13 00 00       	call   8032d0 <_panic>
  801fae:	8b 15 40 50 80 00    	mov    0x805040,%edx
  801fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb7:	89 10                	mov    %edx,(%eax)
  801fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbc:	8b 00                	mov    (%eax),%eax
  801fbe:	85 c0                	test   %eax,%eax
  801fc0:	74 0d                	je     801fcf <insert_sorted_allocList+0x83>
  801fc2:	a1 40 50 80 00       	mov    0x805040,%eax
  801fc7:	8b 55 08             	mov    0x8(%ebp),%edx
  801fca:	89 50 04             	mov    %edx,0x4(%eax)
  801fcd:	eb 08                	jmp    801fd7 <insert_sorted_allocList+0x8b>
  801fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd2:	a3 44 50 80 00       	mov    %eax,0x805044
  801fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fda:	a3 40 50 80 00       	mov    %eax,0x805040
  801fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fe9:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801fee:	40                   	inc    %eax
  801fef:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  801ff4:	e9 dc 01 00 00       	jmp    8021d5 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  801ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffc:	8b 50 08             	mov    0x8(%eax),%edx
  801fff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802002:	8b 40 08             	mov    0x8(%eax),%eax
  802005:	39 c2                	cmp    %eax,%edx
  802007:	77 6c                	ja     802075 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802009:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80200d:	74 06                	je     802015 <insert_sorted_allocList+0xc9>
  80200f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802013:	75 14                	jne    802029 <insert_sorted_allocList+0xdd>
  802015:	83 ec 04             	sub    $0x4,%esp
  802018:	68 48 3e 80 00       	push   $0x803e48
  80201d:	6a 6f                	push   $0x6f
  80201f:	68 2f 3e 80 00       	push   $0x803e2f
  802024:	e8 a7 12 00 00       	call   8032d0 <_panic>
  802029:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80202c:	8b 50 04             	mov    0x4(%eax),%edx
  80202f:	8b 45 08             	mov    0x8(%ebp),%eax
  802032:	89 50 04             	mov    %edx,0x4(%eax)
  802035:	8b 45 08             	mov    0x8(%ebp),%eax
  802038:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80203b:	89 10                	mov    %edx,(%eax)
  80203d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802040:	8b 40 04             	mov    0x4(%eax),%eax
  802043:	85 c0                	test   %eax,%eax
  802045:	74 0d                	je     802054 <insert_sorted_allocList+0x108>
  802047:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80204a:	8b 40 04             	mov    0x4(%eax),%eax
  80204d:	8b 55 08             	mov    0x8(%ebp),%edx
  802050:	89 10                	mov    %edx,(%eax)
  802052:	eb 08                	jmp    80205c <insert_sorted_allocList+0x110>
  802054:	8b 45 08             	mov    0x8(%ebp),%eax
  802057:	a3 40 50 80 00       	mov    %eax,0x805040
  80205c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80205f:	8b 55 08             	mov    0x8(%ebp),%edx
  802062:	89 50 04             	mov    %edx,0x4(%eax)
  802065:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80206a:	40                   	inc    %eax
  80206b:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802070:	e9 60 01 00 00       	jmp    8021d5 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802075:	8b 45 08             	mov    0x8(%ebp),%eax
  802078:	8b 50 08             	mov    0x8(%eax),%edx
  80207b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80207e:	8b 40 08             	mov    0x8(%eax),%eax
  802081:	39 c2                	cmp    %eax,%edx
  802083:	0f 82 4c 01 00 00    	jb     8021d5 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802089:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80208d:	75 14                	jne    8020a3 <insert_sorted_allocList+0x157>
  80208f:	83 ec 04             	sub    $0x4,%esp
  802092:	68 80 3e 80 00       	push   $0x803e80
  802097:	6a 73                	push   $0x73
  802099:	68 2f 3e 80 00       	push   $0x803e2f
  80209e:	e8 2d 12 00 00       	call   8032d0 <_panic>
  8020a3:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8020a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ac:	89 50 04             	mov    %edx,0x4(%eax)
  8020af:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b2:	8b 40 04             	mov    0x4(%eax),%eax
  8020b5:	85 c0                	test   %eax,%eax
  8020b7:	74 0c                	je     8020c5 <insert_sorted_allocList+0x179>
  8020b9:	a1 44 50 80 00       	mov    0x805044,%eax
  8020be:	8b 55 08             	mov    0x8(%ebp),%edx
  8020c1:	89 10                	mov    %edx,(%eax)
  8020c3:	eb 08                	jmp    8020cd <insert_sorted_allocList+0x181>
  8020c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c8:	a3 40 50 80 00       	mov    %eax,0x805040
  8020cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d0:	a3 44 50 80 00       	mov    %eax,0x805044
  8020d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8020de:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8020e3:	40                   	inc    %eax
  8020e4:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8020e9:	e9 e7 00 00 00       	jmp    8021d5 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8020ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8020f4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8020fb:	a1 40 50 80 00       	mov    0x805040,%eax
  802100:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802103:	e9 9d 00 00 00       	jmp    8021a5 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802108:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210b:	8b 00                	mov    (%eax),%eax
  80210d:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802110:	8b 45 08             	mov    0x8(%ebp),%eax
  802113:	8b 50 08             	mov    0x8(%eax),%edx
  802116:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802119:	8b 40 08             	mov    0x8(%eax),%eax
  80211c:	39 c2                	cmp    %eax,%edx
  80211e:	76 7d                	jbe    80219d <insert_sorted_allocList+0x251>
  802120:	8b 45 08             	mov    0x8(%ebp),%eax
  802123:	8b 50 08             	mov    0x8(%eax),%edx
  802126:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802129:	8b 40 08             	mov    0x8(%eax),%eax
  80212c:	39 c2                	cmp    %eax,%edx
  80212e:	73 6d                	jae    80219d <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802130:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802134:	74 06                	je     80213c <insert_sorted_allocList+0x1f0>
  802136:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80213a:	75 14                	jne    802150 <insert_sorted_allocList+0x204>
  80213c:	83 ec 04             	sub    $0x4,%esp
  80213f:	68 a4 3e 80 00       	push   $0x803ea4
  802144:	6a 7f                	push   $0x7f
  802146:	68 2f 3e 80 00       	push   $0x803e2f
  80214b:	e8 80 11 00 00       	call   8032d0 <_panic>
  802150:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802153:	8b 10                	mov    (%eax),%edx
  802155:	8b 45 08             	mov    0x8(%ebp),%eax
  802158:	89 10                	mov    %edx,(%eax)
  80215a:	8b 45 08             	mov    0x8(%ebp),%eax
  80215d:	8b 00                	mov    (%eax),%eax
  80215f:	85 c0                	test   %eax,%eax
  802161:	74 0b                	je     80216e <insert_sorted_allocList+0x222>
  802163:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802166:	8b 00                	mov    (%eax),%eax
  802168:	8b 55 08             	mov    0x8(%ebp),%edx
  80216b:	89 50 04             	mov    %edx,0x4(%eax)
  80216e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802171:	8b 55 08             	mov    0x8(%ebp),%edx
  802174:	89 10                	mov    %edx,(%eax)
  802176:	8b 45 08             	mov    0x8(%ebp),%eax
  802179:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80217c:	89 50 04             	mov    %edx,0x4(%eax)
  80217f:	8b 45 08             	mov    0x8(%ebp),%eax
  802182:	8b 00                	mov    (%eax),%eax
  802184:	85 c0                	test   %eax,%eax
  802186:	75 08                	jne    802190 <insert_sorted_allocList+0x244>
  802188:	8b 45 08             	mov    0x8(%ebp),%eax
  80218b:	a3 44 50 80 00       	mov    %eax,0x805044
  802190:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802195:	40                   	inc    %eax
  802196:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  80219b:	eb 39                	jmp    8021d6 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80219d:	a1 48 50 80 00       	mov    0x805048,%eax
  8021a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021a9:	74 07                	je     8021b2 <insert_sorted_allocList+0x266>
  8021ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ae:	8b 00                	mov    (%eax),%eax
  8021b0:	eb 05                	jmp    8021b7 <insert_sorted_allocList+0x26b>
  8021b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b7:	a3 48 50 80 00       	mov    %eax,0x805048
  8021bc:	a1 48 50 80 00       	mov    0x805048,%eax
  8021c1:	85 c0                	test   %eax,%eax
  8021c3:	0f 85 3f ff ff ff    	jne    802108 <insert_sorted_allocList+0x1bc>
  8021c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021cd:	0f 85 35 ff ff ff    	jne    802108 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8021d3:	eb 01                	jmp    8021d6 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021d5:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8021d6:	90                   	nop
  8021d7:	c9                   	leave  
  8021d8:	c3                   	ret    

008021d9 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8021d9:	55                   	push   %ebp
  8021da:	89 e5                	mov    %esp,%ebp
  8021dc:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8021df:	a1 38 51 80 00       	mov    0x805138,%eax
  8021e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021e7:	e9 85 01 00 00       	jmp    802371 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8021ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8021f2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021f5:	0f 82 6e 01 00 00    	jb     802369 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8021fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021fe:	8b 40 0c             	mov    0xc(%eax),%eax
  802201:	3b 45 08             	cmp    0x8(%ebp),%eax
  802204:	0f 85 8a 00 00 00    	jne    802294 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80220a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80220e:	75 17                	jne    802227 <alloc_block_FF+0x4e>
  802210:	83 ec 04             	sub    $0x4,%esp
  802213:	68 d8 3e 80 00       	push   $0x803ed8
  802218:	68 93 00 00 00       	push   $0x93
  80221d:	68 2f 3e 80 00       	push   $0x803e2f
  802222:	e8 a9 10 00 00       	call   8032d0 <_panic>
  802227:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222a:	8b 00                	mov    (%eax),%eax
  80222c:	85 c0                	test   %eax,%eax
  80222e:	74 10                	je     802240 <alloc_block_FF+0x67>
  802230:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802233:	8b 00                	mov    (%eax),%eax
  802235:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802238:	8b 52 04             	mov    0x4(%edx),%edx
  80223b:	89 50 04             	mov    %edx,0x4(%eax)
  80223e:	eb 0b                	jmp    80224b <alloc_block_FF+0x72>
  802240:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802243:	8b 40 04             	mov    0x4(%eax),%eax
  802246:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80224b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224e:	8b 40 04             	mov    0x4(%eax),%eax
  802251:	85 c0                	test   %eax,%eax
  802253:	74 0f                	je     802264 <alloc_block_FF+0x8b>
  802255:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802258:	8b 40 04             	mov    0x4(%eax),%eax
  80225b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80225e:	8b 12                	mov    (%edx),%edx
  802260:	89 10                	mov    %edx,(%eax)
  802262:	eb 0a                	jmp    80226e <alloc_block_FF+0x95>
  802264:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802267:	8b 00                	mov    (%eax),%eax
  802269:	a3 38 51 80 00       	mov    %eax,0x805138
  80226e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802271:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802277:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802281:	a1 44 51 80 00       	mov    0x805144,%eax
  802286:	48                   	dec    %eax
  802287:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  80228c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228f:	e9 10 01 00 00       	jmp    8023a4 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802294:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802297:	8b 40 0c             	mov    0xc(%eax),%eax
  80229a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80229d:	0f 86 c6 00 00 00    	jbe    802369 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8022a3:	a1 48 51 80 00       	mov    0x805148,%eax
  8022a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8022ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ae:	8b 50 08             	mov    0x8(%eax),%edx
  8022b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022b4:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8022b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8022bd:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8022c0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022c4:	75 17                	jne    8022dd <alloc_block_FF+0x104>
  8022c6:	83 ec 04             	sub    $0x4,%esp
  8022c9:	68 d8 3e 80 00       	push   $0x803ed8
  8022ce:	68 9b 00 00 00       	push   $0x9b
  8022d3:	68 2f 3e 80 00       	push   $0x803e2f
  8022d8:	e8 f3 0f 00 00       	call   8032d0 <_panic>
  8022dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e0:	8b 00                	mov    (%eax),%eax
  8022e2:	85 c0                	test   %eax,%eax
  8022e4:	74 10                	je     8022f6 <alloc_block_FF+0x11d>
  8022e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e9:	8b 00                	mov    (%eax),%eax
  8022eb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022ee:	8b 52 04             	mov    0x4(%edx),%edx
  8022f1:	89 50 04             	mov    %edx,0x4(%eax)
  8022f4:	eb 0b                	jmp    802301 <alloc_block_FF+0x128>
  8022f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022f9:	8b 40 04             	mov    0x4(%eax),%eax
  8022fc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802301:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802304:	8b 40 04             	mov    0x4(%eax),%eax
  802307:	85 c0                	test   %eax,%eax
  802309:	74 0f                	je     80231a <alloc_block_FF+0x141>
  80230b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80230e:	8b 40 04             	mov    0x4(%eax),%eax
  802311:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802314:	8b 12                	mov    (%edx),%edx
  802316:	89 10                	mov    %edx,(%eax)
  802318:	eb 0a                	jmp    802324 <alloc_block_FF+0x14b>
  80231a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80231d:	8b 00                	mov    (%eax),%eax
  80231f:	a3 48 51 80 00       	mov    %eax,0x805148
  802324:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802327:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80232d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802330:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802337:	a1 54 51 80 00       	mov    0x805154,%eax
  80233c:	48                   	dec    %eax
  80233d:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802342:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802345:	8b 50 08             	mov    0x8(%eax),%edx
  802348:	8b 45 08             	mov    0x8(%ebp),%eax
  80234b:	01 c2                	add    %eax,%edx
  80234d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802350:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802353:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802356:	8b 40 0c             	mov    0xc(%eax),%eax
  802359:	2b 45 08             	sub    0x8(%ebp),%eax
  80235c:	89 c2                	mov    %eax,%edx
  80235e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802361:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802364:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802367:	eb 3b                	jmp    8023a4 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802369:	a1 40 51 80 00       	mov    0x805140,%eax
  80236e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802371:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802375:	74 07                	je     80237e <alloc_block_FF+0x1a5>
  802377:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237a:	8b 00                	mov    (%eax),%eax
  80237c:	eb 05                	jmp    802383 <alloc_block_FF+0x1aa>
  80237e:	b8 00 00 00 00       	mov    $0x0,%eax
  802383:	a3 40 51 80 00       	mov    %eax,0x805140
  802388:	a1 40 51 80 00       	mov    0x805140,%eax
  80238d:	85 c0                	test   %eax,%eax
  80238f:	0f 85 57 fe ff ff    	jne    8021ec <alloc_block_FF+0x13>
  802395:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802399:	0f 85 4d fe ff ff    	jne    8021ec <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  80239f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023a4:	c9                   	leave  
  8023a5:	c3                   	ret    

008023a6 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8023a6:	55                   	push   %ebp
  8023a7:	89 e5                	mov    %esp,%ebp
  8023a9:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8023ac:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8023b3:	a1 38 51 80 00       	mov    0x805138,%eax
  8023b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023bb:	e9 df 00 00 00       	jmp    80249f <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8023c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8023c6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023c9:	0f 82 c8 00 00 00    	jb     802497 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8023cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8023d5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023d8:	0f 85 8a 00 00 00    	jne    802468 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8023de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023e2:	75 17                	jne    8023fb <alloc_block_BF+0x55>
  8023e4:	83 ec 04             	sub    $0x4,%esp
  8023e7:	68 d8 3e 80 00       	push   $0x803ed8
  8023ec:	68 b7 00 00 00       	push   $0xb7
  8023f1:	68 2f 3e 80 00       	push   $0x803e2f
  8023f6:	e8 d5 0e 00 00       	call   8032d0 <_panic>
  8023fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fe:	8b 00                	mov    (%eax),%eax
  802400:	85 c0                	test   %eax,%eax
  802402:	74 10                	je     802414 <alloc_block_BF+0x6e>
  802404:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802407:	8b 00                	mov    (%eax),%eax
  802409:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80240c:	8b 52 04             	mov    0x4(%edx),%edx
  80240f:	89 50 04             	mov    %edx,0x4(%eax)
  802412:	eb 0b                	jmp    80241f <alloc_block_BF+0x79>
  802414:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802417:	8b 40 04             	mov    0x4(%eax),%eax
  80241a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80241f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802422:	8b 40 04             	mov    0x4(%eax),%eax
  802425:	85 c0                	test   %eax,%eax
  802427:	74 0f                	je     802438 <alloc_block_BF+0x92>
  802429:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242c:	8b 40 04             	mov    0x4(%eax),%eax
  80242f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802432:	8b 12                	mov    (%edx),%edx
  802434:	89 10                	mov    %edx,(%eax)
  802436:	eb 0a                	jmp    802442 <alloc_block_BF+0x9c>
  802438:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243b:	8b 00                	mov    (%eax),%eax
  80243d:	a3 38 51 80 00       	mov    %eax,0x805138
  802442:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802445:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80244b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802455:	a1 44 51 80 00       	mov    0x805144,%eax
  80245a:	48                   	dec    %eax
  80245b:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802460:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802463:	e9 4d 01 00 00       	jmp    8025b5 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802468:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246b:	8b 40 0c             	mov    0xc(%eax),%eax
  80246e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802471:	76 24                	jbe    802497 <alloc_block_BF+0xf1>
  802473:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802476:	8b 40 0c             	mov    0xc(%eax),%eax
  802479:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80247c:	73 19                	jae    802497 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80247e:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802485:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802488:	8b 40 0c             	mov    0xc(%eax),%eax
  80248b:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  80248e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802491:	8b 40 08             	mov    0x8(%eax),%eax
  802494:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802497:	a1 40 51 80 00       	mov    0x805140,%eax
  80249c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80249f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024a3:	74 07                	je     8024ac <alloc_block_BF+0x106>
  8024a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a8:	8b 00                	mov    (%eax),%eax
  8024aa:	eb 05                	jmp    8024b1 <alloc_block_BF+0x10b>
  8024ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8024b1:	a3 40 51 80 00       	mov    %eax,0x805140
  8024b6:	a1 40 51 80 00       	mov    0x805140,%eax
  8024bb:	85 c0                	test   %eax,%eax
  8024bd:	0f 85 fd fe ff ff    	jne    8023c0 <alloc_block_BF+0x1a>
  8024c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024c7:	0f 85 f3 fe ff ff    	jne    8023c0 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8024cd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8024d1:	0f 84 d9 00 00 00    	je     8025b0 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8024d7:	a1 48 51 80 00       	mov    0x805148,%eax
  8024dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8024df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024e2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024e5:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8024e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8024ee:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8024f1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8024f5:	75 17                	jne    80250e <alloc_block_BF+0x168>
  8024f7:	83 ec 04             	sub    $0x4,%esp
  8024fa:	68 d8 3e 80 00       	push   $0x803ed8
  8024ff:	68 c7 00 00 00       	push   $0xc7
  802504:	68 2f 3e 80 00       	push   $0x803e2f
  802509:	e8 c2 0d 00 00       	call   8032d0 <_panic>
  80250e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802511:	8b 00                	mov    (%eax),%eax
  802513:	85 c0                	test   %eax,%eax
  802515:	74 10                	je     802527 <alloc_block_BF+0x181>
  802517:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80251a:	8b 00                	mov    (%eax),%eax
  80251c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80251f:	8b 52 04             	mov    0x4(%edx),%edx
  802522:	89 50 04             	mov    %edx,0x4(%eax)
  802525:	eb 0b                	jmp    802532 <alloc_block_BF+0x18c>
  802527:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80252a:	8b 40 04             	mov    0x4(%eax),%eax
  80252d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802532:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802535:	8b 40 04             	mov    0x4(%eax),%eax
  802538:	85 c0                	test   %eax,%eax
  80253a:	74 0f                	je     80254b <alloc_block_BF+0x1a5>
  80253c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80253f:	8b 40 04             	mov    0x4(%eax),%eax
  802542:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802545:	8b 12                	mov    (%edx),%edx
  802547:	89 10                	mov    %edx,(%eax)
  802549:	eb 0a                	jmp    802555 <alloc_block_BF+0x1af>
  80254b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80254e:	8b 00                	mov    (%eax),%eax
  802550:	a3 48 51 80 00       	mov    %eax,0x805148
  802555:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802558:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80255e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802561:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802568:	a1 54 51 80 00       	mov    0x805154,%eax
  80256d:	48                   	dec    %eax
  80256e:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802573:	83 ec 08             	sub    $0x8,%esp
  802576:	ff 75 ec             	pushl  -0x14(%ebp)
  802579:	68 38 51 80 00       	push   $0x805138
  80257e:	e8 71 f9 ff ff       	call   801ef4 <find_block>
  802583:	83 c4 10             	add    $0x10,%esp
  802586:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802589:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80258c:	8b 50 08             	mov    0x8(%eax),%edx
  80258f:	8b 45 08             	mov    0x8(%ebp),%eax
  802592:	01 c2                	add    %eax,%edx
  802594:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802597:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  80259a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80259d:	8b 40 0c             	mov    0xc(%eax),%eax
  8025a0:	2b 45 08             	sub    0x8(%ebp),%eax
  8025a3:	89 c2                	mov    %eax,%edx
  8025a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025a8:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8025ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025ae:	eb 05                	jmp    8025b5 <alloc_block_BF+0x20f>
	}
	return NULL;
  8025b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025b5:	c9                   	leave  
  8025b6:	c3                   	ret    

008025b7 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8025b7:	55                   	push   %ebp
  8025b8:	89 e5                	mov    %esp,%ebp
  8025ba:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8025bd:	a1 28 50 80 00       	mov    0x805028,%eax
  8025c2:	85 c0                	test   %eax,%eax
  8025c4:	0f 85 de 01 00 00    	jne    8027a8 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8025ca:	a1 38 51 80 00       	mov    0x805138,%eax
  8025cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025d2:	e9 9e 01 00 00       	jmp    802775 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8025d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025da:	8b 40 0c             	mov    0xc(%eax),%eax
  8025dd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025e0:	0f 82 87 01 00 00    	jb     80276d <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8025e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ec:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025ef:	0f 85 95 00 00 00    	jne    80268a <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8025f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025f9:	75 17                	jne    802612 <alloc_block_NF+0x5b>
  8025fb:	83 ec 04             	sub    $0x4,%esp
  8025fe:	68 d8 3e 80 00       	push   $0x803ed8
  802603:	68 e0 00 00 00       	push   $0xe0
  802608:	68 2f 3e 80 00       	push   $0x803e2f
  80260d:	e8 be 0c 00 00       	call   8032d0 <_panic>
  802612:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802615:	8b 00                	mov    (%eax),%eax
  802617:	85 c0                	test   %eax,%eax
  802619:	74 10                	je     80262b <alloc_block_NF+0x74>
  80261b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261e:	8b 00                	mov    (%eax),%eax
  802620:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802623:	8b 52 04             	mov    0x4(%edx),%edx
  802626:	89 50 04             	mov    %edx,0x4(%eax)
  802629:	eb 0b                	jmp    802636 <alloc_block_NF+0x7f>
  80262b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262e:	8b 40 04             	mov    0x4(%eax),%eax
  802631:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802636:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802639:	8b 40 04             	mov    0x4(%eax),%eax
  80263c:	85 c0                	test   %eax,%eax
  80263e:	74 0f                	je     80264f <alloc_block_NF+0x98>
  802640:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802643:	8b 40 04             	mov    0x4(%eax),%eax
  802646:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802649:	8b 12                	mov    (%edx),%edx
  80264b:	89 10                	mov    %edx,(%eax)
  80264d:	eb 0a                	jmp    802659 <alloc_block_NF+0xa2>
  80264f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802652:	8b 00                	mov    (%eax),%eax
  802654:	a3 38 51 80 00       	mov    %eax,0x805138
  802659:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802662:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802665:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80266c:	a1 44 51 80 00       	mov    0x805144,%eax
  802671:	48                   	dec    %eax
  802672:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802677:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267a:	8b 40 08             	mov    0x8(%eax),%eax
  80267d:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802682:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802685:	e9 f8 04 00 00       	jmp    802b82 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  80268a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268d:	8b 40 0c             	mov    0xc(%eax),%eax
  802690:	3b 45 08             	cmp    0x8(%ebp),%eax
  802693:	0f 86 d4 00 00 00    	jbe    80276d <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802699:	a1 48 51 80 00       	mov    0x805148,%eax
  80269e:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8026a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a4:	8b 50 08             	mov    0x8(%eax),%edx
  8026a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026aa:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8026ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8026b3:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8026b6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026ba:	75 17                	jne    8026d3 <alloc_block_NF+0x11c>
  8026bc:	83 ec 04             	sub    $0x4,%esp
  8026bf:	68 d8 3e 80 00       	push   $0x803ed8
  8026c4:	68 e9 00 00 00       	push   $0xe9
  8026c9:	68 2f 3e 80 00       	push   $0x803e2f
  8026ce:	e8 fd 0b 00 00       	call   8032d0 <_panic>
  8026d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026d6:	8b 00                	mov    (%eax),%eax
  8026d8:	85 c0                	test   %eax,%eax
  8026da:	74 10                	je     8026ec <alloc_block_NF+0x135>
  8026dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026df:	8b 00                	mov    (%eax),%eax
  8026e1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026e4:	8b 52 04             	mov    0x4(%edx),%edx
  8026e7:	89 50 04             	mov    %edx,0x4(%eax)
  8026ea:	eb 0b                	jmp    8026f7 <alloc_block_NF+0x140>
  8026ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ef:	8b 40 04             	mov    0x4(%eax),%eax
  8026f2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8026f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026fa:	8b 40 04             	mov    0x4(%eax),%eax
  8026fd:	85 c0                	test   %eax,%eax
  8026ff:	74 0f                	je     802710 <alloc_block_NF+0x159>
  802701:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802704:	8b 40 04             	mov    0x4(%eax),%eax
  802707:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80270a:	8b 12                	mov    (%edx),%edx
  80270c:	89 10                	mov    %edx,(%eax)
  80270e:	eb 0a                	jmp    80271a <alloc_block_NF+0x163>
  802710:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802713:	8b 00                	mov    (%eax),%eax
  802715:	a3 48 51 80 00       	mov    %eax,0x805148
  80271a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80271d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802723:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802726:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80272d:	a1 54 51 80 00       	mov    0x805154,%eax
  802732:	48                   	dec    %eax
  802733:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802738:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80273b:	8b 40 08             	mov    0x8(%eax),%eax
  80273e:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802743:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802746:	8b 50 08             	mov    0x8(%eax),%edx
  802749:	8b 45 08             	mov    0x8(%ebp),%eax
  80274c:	01 c2                	add    %eax,%edx
  80274e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802751:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802754:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802757:	8b 40 0c             	mov    0xc(%eax),%eax
  80275a:	2b 45 08             	sub    0x8(%ebp),%eax
  80275d:	89 c2                	mov    %eax,%edx
  80275f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802762:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802765:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802768:	e9 15 04 00 00       	jmp    802b82 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80276d:	a1 40 51 80 00       	mov    0x805140,%eax
  802772:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802775:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802779:	74 07                	je     802782 <alloc_block_NF+0x1cb>
  80277b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277e:	8b 00                	mov    (%eax),%eax
  802780:	eb 05                	jmp    802787 <alloc_block_NF+0x1d0>
  802782:	b8 00 00 00 00       	mov    $0x0,%eax
  802787:	a3 40 51 80 00       	mov    %eax,0x805140
  80278c:	a1 40 51 80 00       	mov    0x805140,%eax
  802791:	85 c0                	test   %eax,%eax
  802793:	0f 85 3e fe ff ff    	jne    8025d7 <alloc_block_NF+0x20>
  802799:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80279d:	0f 85 34 fe ff ff    	jne    8025d7 <alloc_block_NF+0x20>
  8027a3:	e9 d5 03 00 00       	jmp    802b7d <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8027a8:	a1 38 51 80 00       	mov    0x805138,%eax
  8027ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027b0:	e9 b1 01 00 00       	jmp    802966 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8027b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b8:	8b 50 08             	mov    0x8(%eax),%edx
  8027bb:	a1 28 50 80 00       	mov    0x805028,%eax
  8027c0:	39 c2                	cmp    %eax,%edx
  8027c2:	0f 82 96 01 00 00    	jb     80295e <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8027c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ce:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027d1:	0f 82 87 01 00 00    	jb     80295e <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8027d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027da:	8b 40 0c             	mov    0xc(%eax),%eax
  8027dd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027e0:	0f 85 95 00 00 00    	jne    80287b <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8027e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ea:	75 17                	jne    802803 <alloc_block_NF+0x24c>
  8027ec:	83 ec 04             	sub    $0x4,%esp
  8027ef:	68 d8 3e 80 00       	push   $0x803ed8
  8027f4:	68 fc 00 00 00       	push   $0xfc
  8027f9:	68 2f 3e 80 00       	push   $0x803e2f
  8027fe:	e8 cd 0a 00 00       	call   8032d0 <_panic>
  802803:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802806:	8b 00                	mov    (%eax),%eax
  802808:	85 c0                	test   %eax,%eax
  80280a:	74 10                	je     80281c <alloc_block_NF+0x265>
  80280c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280f:	8b 00                	mov    (%eax),%eax
  802811:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802814:	8b 52 04             	mov    0x4(%edx),%edx
  802817:	89 50 04             	mov    %edx,0x4(%eax)
  80281a:	eb 0b                	jmp    802827 <alloc_block_NF+0x270>
  80281c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281f:	8b 40 04             	mov    0x4(%eax),%eax
  802822:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802827:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282a:	8b 40 04             	mov    0x4(%eax),%eax
  80282d:	85 c0                	test   %eax,%eax
  80282f:	74 0f                	je     802840 <alloc_block_NF+0x289>
  802831:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802834:	8b 40 04             	mov    0x4(%eax),%eax
  802837:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80283a:	8b 12                	mov    (%edx),%edx
  80283c:	89 10                	mov    %edx,(%eax)
  80283e:	eb 0a                	jmp    80284a <alloc_block_NF+0x293>
  802840:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802843:	8b 00                	mov    (%eax),%eax
  802845:	a3 38 51 80 00       	mov    %eax,0x805138
  80284a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802853:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802856:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80285d:	a1 44 51 80 00       	mov    0x805144,%eax
  802862:	48                   	dec    %eax
  802863:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802868:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286b:	8b 40 08             	mov    0x8(%eax),%eax
  80286e:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802873:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802876:	e9 07 03 00 00       	jmp    802b82 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80287b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287e:	8b 40 0c             	mov    0xc(%eax),%eax
  802881:	3b 45 08             	cmp    0x8(%ebp),%eax
  802884:	0f 86 d4 00 00 00    	jbe    80295e <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80288a:	a1 48 51 80 00       	mov    0x805148,%eax
  80288f:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802892:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802895:	8b 50 08             	mov    0x8(%eax),%edx
  802898:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80289b:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80289e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8028a4:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8028a7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8028ab:	75 17                	jne    8028c4 <alloc_block_NF+0x30d>
  8028ad:	83 ec 04             	sub    $0x4,%esp
  8028b0:	68 d8 3e 80 00       	push   $0x803ed8
  8028b5:	68 04 01 00 00       	push   $0x104
  8028ba:	68 2f 3e 80 00       	push   $0x803e2f
  8028bf:	e8 0c 0a 00 00       	call   8032d0 <_panic>
  8028c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028c7:	8b 00                	mov    (%eax),%eax
  8028c9:	85 c0                	test   %eax,%eax
  8028cb:	74 10                	je     8028dd <alloc_block_NF+0x326>
  8028cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028d0:	8b 00                	mov    (%eax),%eax
  8028d2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028d5:	8b 52 04             	mov    0x4(%edx),%edx
  8028d8:	89 50 04             	mov    %edx,0x4(%eax)
  8028db:	eb 0b                	jmp    8028e8 <alloc_block_NF+0x331>
  8028dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028e0:	8b 40 04             	mov    0x4(%eax),%eax
  8028e3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028eb:	8b 40 04             	mov    0x4(%eax),%eax
  8028ee:	85 c0                	test   %eax,%eax
  8028f0:	74 0f                	je     802901 <alloc_block_NF+0x34a>
  8028f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028f5:	8b 40 04             	mov    0x4(%eax),%eax
  8028f8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028fb:	8b 12                	mov    (%edx),%edx
  8028fd:	89 10                	mov    %edx,(%eax)
  8028ff:	eb 0a                	jmp    80290b <alloc_block_NF+0x354>
  802901:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802904:	8b 00                	mov    (%eax),%eax
  802906:	a3 48 51 80 00       	mov    %eax,0x805148
  80290b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80290e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802914:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802917:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80291e:	a1 54 51 80 00       	mov    0x805154,%eax
  802923:	48                   	dec    %eax
  802924:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802929:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80292c:	8b 40 08             	mov    0x8(%eax),%eax
  80292f:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802934:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802937:	8b 50 08             	mov    0x8(%eax),%edx
  80293a:	8b 45 08             	mov    0x8(%ebp),%eax
  80293d:	01 c2                	add    %eax,%edx
  80293f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802942:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802945:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802948:	8b 40 0c             	mov    0xc(%eax),%eax
  80294b:	2b 45 08             	sub    0x8(%ebp),%eax
  80294e:	89 c2                	mov    %eax,%edx
  802950:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802953:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802956:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802959:	e9 24 02 00 00       	jmp    802b82 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80295e:	a1 40 51 80 00       	mov    0x805140,%eax
  802963:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802966:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80296a:	74 07                	je     802973 <alloc_block_NF+0x3bc>
  80296c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296f:	8b 00                	mov    (%eax),%eax
  802971:	eb 05                	jmp    802978 <alloc_block_NF+0x3c1>
  802973:	b8 00 00 00 00       	mov    $0x0,%eax
  802978:	a3 40 51 80 00       	mov    %eax,0x805140
  80297d:	a1 40 51 80 00       	mov    0x805140,%eax
  802982:	85 c0                	test   %eax,%eax
  802984:	0f 85 2b fe ff ff    	jne    8027b5 <alloc_block_NF+0x1fe>
  80298a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80298e:	0f 85 21 fe ff ff    	jne    8027b5 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802994:	a1 38 51 80 00       	mov    0x805138,%eax
  802999:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80299c:	e9 ae 01 00 00       	jmp    802b4f <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8029a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a4:	8b 50 08             	mov    0x8(%eax),%edx
  8029a7:	a1 28 50 80 00       	mov    0x805028,%eax
  8029ac:	39 c2                	cmp    %eax,%edx
  8029ae:	0f 83 93 01 00 00    	jae    802b47 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  8029b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8029ba:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029bd:	0f 82 84 01 00 00    	jb     802b47 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  8029c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8029c9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029cc:	0f 85 95 00 00 00    	jne    802a67 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8029d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029d6:	75 17                	jne    8029ef <alloc_block_NF+0x438>
  8029d8:	83 ec 04             	sub    $0x4,%esp
  8029db:	68 d8 3e 80 00       	push   $0x803ed8
  8029e0:	68 14 01 00 00       	push   $0x114
  8029e5:	68 2f 3e 80 00       	push   $0x803e2f
  8029ea:	e8 e1 08 00 00       	call   8032d0 <_panic>
  8029ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f2:	8b 00                	mov    (%eax),%eax
  8029f4:	85 c0                	test   %eax,%eax
  8029f6:	74 10                	je     802a08 <alloc_block_NF+0x451>
  8029f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fb:	8b 00                	mov    (%eax),%eax
  8029fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a00:	8b 52 04             	mov    0x4(%edx),%edx
  802a03:	89 50 04             	mov    %edx,0x4(%eax)
  802a06:	eb 0b                	jmp    802a13 <alloc_block_NF+0x45c>
  802a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0b:	8b 40 04             	mov    0x4(%eax),%eax
  802a0e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a16:	8b 40 04             	mov    0x4(%eax),%eax
  802a19:	85 c0                	test   %eax,%eax
  802a1b:	74 0f                	je     802a2c <alloc_block_NF+0x475>
  802a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a20:	8b 40 04             	mov    0x4(%eax),%eax
  802a23:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a26:	8b 12                	mov    (%edx),%edx
  802a28:	89 10                	mov    %edx,(%eax)
  802a2a:	eb 0a                	jmp    802a36 <alloc_block_NF+0x47f>
  802a2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2f:	8b 00                	mov    (%eax),%eax
  802a31:	a3 38 51 80 00       	mov    %eax,0x805138
  802a36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a39:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a42:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a49:	a1 44 51 80 00       	mov    0x805144,%eax
  802a4e:	48                   	dec    %eax
  802a4f:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a57:	8b 40 08             	mov    0x8(%eax),%eax
  802a5a:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a62:	e9 1b 01 00 00       	jmp    802b82 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6a:	8b 40 0c             	mov    0xc(%eax),%eax
  802a6d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a70:	0f 86 d1 00 00 00    	jbe    802b47 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a76:	a1 48 51 80 00       	mov    0x805148,%eax
  802a7b:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a81:	8b 50 08             	mov    0x8(%eax),%edx
  802a84:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a87:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802a8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a8d:	8b 55 08             	mov    0x8(%ebp),%edx
  802a90:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802a93:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a97:	75 17                	jne    802ab0 <alloc_block_NF+0x4f9>
  802a99:	83 ec 04             	sub    $0x4,%esp
  802a9c:	68 d8 3e 80 00       	push   $0x803ed8
  802aa1:	68 1c 01 00 00       	push   $0x11c
  802aa6:	68 2f 3e 80 00       	push   $0x803e2f
  802aab:	e8 20 08 00 00       	call   8032d0 <_panic>
  802ab0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ab3:	8b 00                	mov    (%eax),%eax
  802ab5:	85 c0                	test   %eax,%eax
  802ab7:	74 10                	je     802ac9 <alloc_block_NF+0x512>
  802ab9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802abc:	8b 00                	mov    (%eax),%eax
  802abe:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ac1:	8b 52 04             	mov    0x4(%edx),%edx
  802ac4:	89 50 04             	mov    %edx,0x4(%eax)
  802ac7:	eb 0b                	jmp    802ad4 <alloc_block_NF+0x51d>
  802ac9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802acc:	8b 40 04             	mov    0x4(%eax),%eax
  802acf:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ad4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ad7:	8b 40 04             	mov    0x4(%eax),%eax
  802ada:	85 c0                	test   %eax,%eax
  802adc:	74 0f                	je     802aed <alloc_block_NF+0x536>
  802ade:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae1:	8b 40 04             	mov    0x4(%eax),%eax
  802ae4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ae7:	8b 12                	mov    (%edx),%edx
  802ae9:	89 10                	mov    %edx,(%eax)
  802aeb:	eb 0a                	jmp    802af7 <alloc_block_NF+0x540>
  802aed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af0:	8b 00                	mov    (%eax),%eax
  802af2:	a3 48 51 80 00       	mov    %eax,0x805148
  802af7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802afa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b00:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b03:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b0a:	a1 54 51 80 00       	mov    0x805154,%eax
  802b0f:	48                   	dec    %eax
  802b10:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802b15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b18:	8b 40 08             	mov    0x8(%eax),%eax
  802b1b:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802b20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b23:	8b 50 08             	mov    0x8(%eax),%edx
  802b26:	8b 45 08             	mov    0x8(%ebp),%eax
  802b29:	01 c2                	add    %eax,%edx
  802b2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2e:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b34:	8b 40 0c             	mov    0xc(%eax),%eax
  802b37:	2b 45 08             	sub    0x8(%ebp),%eax
  802b3a:	89 c2                	mov    %eax,%edx
  802b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3f:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802b42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b45:	eb 3b                	jmp    802b82 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b47:	a1 40 51 80 00       	mov    0x805140,%eax
  802b4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b4f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b53:	74 07                	je     802b5c <alloc_block_NF+0x5a5>
  802b55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b58:	8b 00                	mov    (%eax),%eax
  802b5a:	eb 05                	jmp    802b61 <alloc_block_NF+0x5aa>
  802b5c:	b8 00 00 00 00       	mov    $0x0,%eax
  802b61:	a3 40 51 80 00       	mov    %eax,0x805140
  802b66:	a1 40 51 80 00       	mov    0x805140,%eax
  802b6b:	85 c0                	test   %eax,%eax
  802b6d:	0f 85 2e fe ff ff    	jne    8029a1 <alloc_block_NF+0x3ea>
  802b73:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b77:	0f 85 24 fe ff ff    	jne    8029a1 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802b7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b82:	c9                   	leave  
  802b83:	c3                   	ret    

00802b84 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802b84:	55                   	push   %ebp
  802b85:	89 e5                	mov    %esp,%ebp
  802b87:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802b8a:	a1 38 51 80 00       	mov    0x805138,%eax
  802b8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802b92:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802b97:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802b9a:	a1 38 51 80 00       	mov    0x805138,%eax
  802b9f:	85 c0                	test   %eax,%eax
  802ba1:	74 14                	je     802bb7 <insert_sorted_with_merge_freeList+0x33>
  802ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba6:	8b 50 08             	mov    0x8(%eax),%edx
  802ba9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bac:	8b 40 08             	mov    0x8(%eax),%eax
  802baf:	39 c2                	cmp    %eax,%edx
  802bb1:	0f 87 9b 01 00 00    	ja     802d52 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802bb7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bbb:	75 17                	jne    802bd4 <insert_sorted_with_merge_freeList+0x50>
  802bbd:	83 ec 04             	sub    $0x4,%esp
  802bc0:	68 0c 3e 80 00       	push   $0x803e0c
  802bc5:	68 38 01 00 00       	push   $0x138
  802bca:	68 2f 3e 80 00       	push   $0x803e2f
  802bcf:	e8 fc 06 00 00       	call   8032d0 <_panic>
  802bd4:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802bda:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdd:	89 10                	mov    %edx,(%eax)
  802bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  802be2:	8b 00                	mov    (%eax),%eax
  802be4:	85 c0                	test   %eax,%eax
  802be6:	74 0d                	je     802bf5 <insert_sorted_with_merge_freeList+0x71>
  802be8:	a1 38 51 80 00       	mov    0x805138,%eax
  802bed:	8b 55 08             	mov    0x8(%ebp),%edx
  802bf0:	89 50 04             	mov    %edx,0x4(%eax)
  802bf3:	eb 08                	jmp    802bfd <insert_sorted_with_merge_freeList+0x79>
  802bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  802c00:	a3 38 51 80 00       	mov    %eax,0x805138
  802c05:	8b 45 08             	mov    0x8(%ebp),%eax
  802c08:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c0f:	a1 44 51 80 00       	mov    0x805144,%eax
  802c14:	40                   	inc    %eax
  802c15:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802c1a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c1e:	0f 84 a8 06 00 00    	je     8032cc <insert_sorted_with_merge_freeList+0x748>
  802c24:	8b 45 08             	mov    0x8(%ebp),%eax
  802c27:	8b 50 08             	mov    0x8(%eax),%edx
  802c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2d:	8b 40 0c             	mov    0xc(%eax),%eax
  802c30:	01 c2                	add    %eax,%edx
  802c32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c35:	8b 40 08             	mov    0x8(%eax),%eax
  802c38:	39 c2                	cmp    %eax,%edx
  802c3a:	0f 85 8c 06 00 00    	jne    8032cc <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802c40:	8b 45 08             	mov    0x8(%ebp),%eax
  802c43:	8b 50 0c             	mov    0xc(%eax),%edx
  802c46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c49:	8b 40 0c             	mov    0xc(%eax),%eax
  802c4c:	01 c2                	add    %eax,%edx
  802c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c51:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802c54:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c58:	75 17                	jne    802c71 <insert_sorted_with_merge_freeList+0xed>
  802c5a:	83 ec 04             	sub    $0x4,%esp
  802c5d:	68 d8 3e 80 00       	push   $0x803ed8
  802c62:	68 3c 01 00 00       	push   $0x13c
  802c67:	68 2f 3e 80 00       	push   $0x803e2f
  802c6c:	e8 5f 06 00 00       	call   8032d0 <_panic>
  802c71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c74:	8b 00                	mov    (%eax),%eax
  802c76:	85 c0                	test   %eax,%eax
  802c78:	74 10                	je     802c8a <insert_sorted_with_merge_freeList+0x106>
  802c7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c7d:	8b 00                	mov    (%eax),%eax
  802c7f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c82:	8b 52 04             	mov    0x4(%edx),%edx
  802c85:	89 50 04             	mov    %edx,0x4(%eax)
  802c88:	eb 0b                	jmp    802c95 <insert_sorted_with_merge_freeList+0x111>
  802c8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c8d:	8b 40 04             	mov    0x4(%eax),%eax
  802c90:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c98:	8b 40 04             	mov    0x4(%eax),%eax
  802c9b:	85 c0                	test   %eax,%eax
  802c9d:	74 0f                	je     802cae <insert_sorted_with_merge_freeList+0x12a>
  802c9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca2:	8b 40 04             	mov    0x4(%eax),%eax
  802ca5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ca8:	8b 12                	mov    (%edx),%edx
  802caa:	89 10                	mov    %edx,(%eax)
  802cac:	eb 0a                	jmp    802cb8 <insert_sorted_with_merge_freeList+0x134>
  802cae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb1:	8b 00                	mov    (%eax),%eax
  802cb3:	a3 38 51 80 00       	mov    %eax,0x805138
  802cb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cbb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ccb:	a1 44 51 80 00       	mov    0x805144,%eax
  802cd0:	48                   	dec    %eax
  802cd1:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802cd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802ce0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802cea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cee:	75 17                	jne    802d07 <insert_sorted_with_merge_freeList+0x183>
  802cf0:	83 ec 04             	sub    $0x4,%esp
  802cf3:	68 0c 3e 80 00       	push   $0x803e0c
  802cf8:	68 3f 01 00 00       	push   $0x13f
  802cfd:	68 2f 3e 80 00       	push   $0x803e2f
  802d02:	e8 c9 05 00 00       	call   8032d0 <_panic>
  802d07:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802d0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d10:	89 10                	mov    %edx,(%eax)
  802d12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d15:	8b 00                	mov    (%eax),%eax
  802d17:	85 c0                	test   %eax,%eax
  802d19:	74 0d                	je     802d28 <insert_sorted_with_merge_freeList+0x1a4>
  802d1b:	a1 48 51 80 00       	mov    0x805148,%eax
  802d20:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d23:	89 50 04             	mov    %edx,0x4(%eax)
  802d26:	eb 08                	jmp    802d30 <insert_sorted_with_merge_freeList+0x1ac>
  802d28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d2b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d33:	a3 48 51 80 00       	mov    %eax,0x805148
  802d38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d3b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d42:	a1 54 51 80 00       	mov    0x805154,%eax
  802d47:	40                   	inc    %eax
  802d48:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d4d:	e9 7a 05 00 00       	jmp    8032cc <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802d52:	8b 45 08             	mov    0x8(%ebp),%eax
  802d55:	8b 50 08             	mov    0x8(%eax),%edx
  802d58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d5b:	8b 40 08             	mov    0x8(%eax),%eax
  802d5e:	39 c2                	cmp    %eax,%edx
  802d60:	0f 82 14 01 00 00    	jb     802e7a <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802d66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d69:	8b 50 08             	mov    0x8(%eax),%edx
  802d6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d6f:	8b 40 0c             	mov    0xc(%eax),%eax
  802d72:	01 c2                	add    %eax,%edx
  802d74:	8b 45 08             	mov    0x8(%ebp),%eax
  802d77:	8b 40 08             	mov    0x8(%eax),%eax
  802d7a:	39 c2                	cmp    %eax,%edx
  802d7c:	0f 85 90 00 00 00    	jne    802e12 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802d82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d85:	8b 50 0c             	mov    0xc(%eax),%edx
  802d88:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8b:	8b 40 0c             	mov    0xc(%eax),%eax
  802d8e:	01 c2                	add    %eax,%edx
  802d90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d93:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802d96:	8b 45 08             	mov    0x8(%ebp),%eax
  802d99:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802da0:	8b 45 08             	mov    0x8(%ebp),%eax
  802da3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802daa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dae:	75 17                	jne    802dc7 <insert_sorted_with_merge_freeList+0x243>
  802db0:	83 ec 04             	sub    $0x4,%esp
  802db3:	68 0c 3e 80 00       	push   $0x803e0c
  802db8:	68 49 01 00 00       	push   $0x149
  802dbd:	68 2f 3e 80 00       	push   $0x803e2f
  802dc2:	e8 09 05 00 00       	call   8032d0 <_panic>
  802dc7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd0:	89 10                	mov    %edx,(%eax)
  802dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd5:	8b 00                	mov    (%eax),%eax
  802dd7:	85 c0                	test   %eax,%eax
  802dd9:	74 0d                	je     802de8 <insert_sorted_with_merge_freeList+0x264>
  802ddb:	a1 48 51 80 00       	mov    0x805148,%eax
  802de0:	8b 55 08             	mov    0x8(%ebp),%edx
  802de3:	89 50 04             	mov    %edx,0x4(%eax)
  802de6:	eb 08                	jmp    802df0 <insert_sorted_with_merge_freeList+0x26c>
  802de8:	8b 45 08             	mov    0x8(%ebp),%eax
  802deb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802df0:	8b 45 08             	mov    0x8(%ebp),%eax
  802df3:	a3 48 51 80 00       	mov    %eax,0x805148
  802df8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e02:	a1 54 51 80 00       	mov    0x805154,%eax
  802e07:	40                   	inc    %eax
  802e08:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e0d:	e9 bb 04 00 00       	jmp    8032cd <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802e12:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e16:	75 17                	jne    802e2f <insert_sorted_with_merge_freeList+0x2ab>
  802e18:	83 ec 04             	sub    $0x4,%esp
  802e1b:	68 80 3e 80 00       	push   $0x803e80
  802e20:	68 4c 01 00 00       	push   $0x14c
  802e25:	68 2f 3e 80 00       	push   $0x803e2f
  802e2a:	e8 a1 04 00 00       	call   8032d0 <_panic>
  802e2f:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802e35:	8b 45 08             	mov    0x8(%ebp),%eax
  802e38:	89 50 04             	mov    %edx,0x4(%eax)
  802e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3e:	8b 40 04             	mov    0x4(%eax),%eax
  802e41:	85 c0                	test   %eax,%eax
  802e43:	74 0c                	je     802e51 <insert_sorted_with_merge_freeList+0x2cd>
  802e45:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e4a:	8b 55 08             	mov    0x8(%ebp),%edx
  802e4d:	89 10                	mov    %edx,(%eax)
  802e4f:	eb 08                	jmp    802e59 <insert_sorted_with_merge_freeList+0x2d5>
  802e51:	8b 45 08             	mov    0x8(%ebp),%eax
  802e54:	a3 38 51 80 00       	mov    %eax,0x805138
  802e59:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e61:	8b 45 08             	mov    0x8(%ebp),%eax
  802e64:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e6a:	a1 44 51 80 00       	mov    0x805144,%eax
  802e6f:	40                   	inc    %eax
  802e70:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e75:	e9 53 04 00 00       	jmp    8032cd <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802e7a:	a1 38 51 80 00       	mov    0x805138,%eax
  802e7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e82:	e9 15 04 00 00       	jmp    80329c <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802e87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8a:	8b 00                	mov    (%eax),%eax
  802e8c:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e92:	8b 50 08             	mov    0x8(%eax),%edx
  802e95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e98:	8b 40 08             	mov    0x8(%eax),%eax
  802e9b:	39 c2                	cmp    %eax,%edx
  802e9d:	0f 86 f1 03 00 00    	jbe    803294 <insert_sorted_with_merge_freeList+0x710>
  802ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea6:	8b 50 08             	mov    0x8(%eax),%edx
  802ea9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eac:	8b 40 08             	mov    0x8(%eax),%eax
  802eaf:	39 c2                	cmp    %eax,%edx
  802eb1:	0f 83 dd 03 00 00    	jae    803294 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802eb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eba:	8b 50 08             	mov    0x8(%eax),%edx
  802ebd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec3:	01 c2                	add    %eax,%edx
  802ec5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec8:	8b 40 08             	mov    0x8(%eax),%eax
  802ecb:	39 c2                	cmp    %eax,%edx
  802ecd:	0f 85 b9 01 00 00    	jne    80308c <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed6:	8b 50 08             	mov    0x8(%eax),%edx
  802ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  802edc:	8b 40 0c             	mov    0xc(%eax),%eax
  802edf:	01 c2                	add    %eax,%edx
  802ee1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ee4:	8b 40 08             	mov    0x8(%eax),%eax
  802ee7:	39 c2                	cmp    %eax,%edx
  802ee9:	0f 85 0d 01 00 00    	jne    802ffc <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802eef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef2:	8b 50 0c             	mov    0xc(%eax),%edx
  802ef5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ef8:	8b 40 0c             	mov    0xc(%eax),%eax
  802efb:	01 c2                	add    %eax,%edx
  802efd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f00:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802f03:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f07:	75 17                	jne    802f20 <insert_sorted_with_merge_freeList+0x39c>
  802f09:	83 ec 04             	sub    $0x4,%esp
  802f0c:	68 d8 3e 80 00       	push   $0x803ed8
  802f11:	68 5c 01 00 00       	push   $0x15c
  802f16:	68 2f 3e 80 00       	push   $0x803e2f
  802f1b:	e8 b0 03 00 00       	call   8032d0 <_panic>
  802f20:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f23:	8b 00                	mov    (%eax),%eax
  802f25:	85 c0                	test   %eax,%eax
  802f27:	74 10                	je     802f39 <insert_sorted_with_merge_freeList+0x3b5>
  802f29:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f2c:	8b 00                	mov    (%eax),%eax
  802f2e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f31:	8b 52 04             	mov    0x4(%edx),%edx
  802f34:	89 50 04             	mov    %edx,0x4(%eax)
  802f37:	eb 0b                	jmp    802f44 <insert_sorted_with_merge_freeList+0x3c0>
  802f39:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f3c:	8b 40 04             	mov    0x4(%eax),%eax
  802f3f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f44:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f47:	8b 40 04             	mov    0x4(%eax),%eax
  802f4a:	85 c0                	test   %eax,%eax
  802f4c:	74 0f                	je     802f5d <insert_sorted_with_merge_freeList+0x3d9>
  802f4e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f51:	8b 40 04             	mov    0x4(%eax),%eax
  802f54:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f57:	8b 12                	mov    (%edx),%edx
  802f59:	89 10                	mov    %edx,(%eax)
  802f5b:	eb 0a                	jmp    802f67 <insert_sorted_with_merge_freeList+0x3e3>
  802f5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f60:	8b 00                	mov    (%eax),%eax
  802f62:	a3 38 51 80 00       	mov    %eax,0x805138
  802f67:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f6a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f70:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f73:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f7a:	a1 44 51 80 00       	mov    0x805144,%eax
  802f7f:	48                   	dec    %eax
  802f80:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  802f85:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f88:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  802f8f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f92:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  802f99:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f9d:	75 17                	jne    802fb6 <insert_sorted_with_merge_freeList+0x432>
  802f9f:	83 ec 04             	sub    $0x4,%esp
  802fa2:	68 0c 3e 80 00       	push   $0x803e0c
  802fa7:	68 5f 01 00 00       	push   $0x15f
  802fac:	68 2f 3e 80 00       	push   $0x803e2f
  802fb1:	e8 1a 03 00 00       	call   8032d0 <_panic>
  802fb6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802fbc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fbf:	89 10                	mov    %edx,(%eax)
  802fc1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc4:	8b 00                	mov    (%eax),%eax
  802fc6:	85 c0                	test   %eax,%eax
  802fc8:	74 0d                	je     802fd7 <insert_sorted_with_merge_freeList+0x453>
  802fca:	a1 48 51 80 00       	mov    0x805148,%eax
  802fcf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fd2:	89 50 04             	mov    %edx,0x4(%eax)
  802fd5:	eb 08                	jmp    802fdf <insert_sorted_with_merge_freeList+0x45b>
  802fd7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fda:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fdf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe2:	a3 48 51 80 00       	mov    %eax,0x805148
  802fe7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ff1:	a1 54 51 80 00       	mov    0x805154,%eax
  802ff6:	40                   	inc    %eax
  802ff7:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  802ffc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fff:	8b 50 0c             	mov    0xc(%eax),%edx
  803002:	8b 45 08             	mov    0x8(%ebp),%eax
  803005:	8b 40 0c             	mov    0xc(%eax),%eax
  803008:	01 c2                	add    %eax,%edx
  80300a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300d:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803010:	8b 45 08             	mov    0x8(%ebp),%eax
  803013:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80301a:	8b 45 08             	mov    0x8(%ebp),%eax
  80301d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803024:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803028:	75 17                	jne    803041 <insert_sorted_with_merge_freeList+0x4bd>
  80302a:	83 ec 04             	sub    $0x4,%esp
  80302d:	68 0c 3e 80 00       	push   $0x803e0c
  803032:	68 64 01 00 00       	push   $0x164
  803037:	68 2f 3e 80 00       	push   $0x803e2f
  80303c:	e8 8f 02 00 00       	call   8032d0 <_panic>
  803041:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803047:	8b 45 08             	mov    0x8(%ebp),%eax
  80304a:	89 10                	mov    %edx,(%eax)
  80304c:	8b 45 08             	mov    0x8(%ebp),%eax
  80304f:	8b 00                	mov    (%eax),%eax
  803051:	85 c0                	test   %eax,%eax
  803053:	74 0d                	je     803062 <insert_sorted_with_merge_freeList+0x4de>
  803055:	a1 48 51 80 00       	mov    0x805148,%eax
  80305a:	8b 55 08             	mov    0x8(%ebp),%edx
  80305d:	89 50 04             	mov    %edx,0x4(%eax)
  803060:	eb 08                	jmp    80306a <insert_sorted_with_merge_freeList+0x4e6>
  803062:	8b 45 08             	mov    0x8(%ebp),%eax
  803065:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80306a:	8b 45 08             	mov    0x8(%ebp),%eax
  80306d:	a3 48 51 80 00       	mov    %eax,0x805148
  803072:	8b 45 08             	mov    0x8(%ebp),%eax
  803075:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80307c:	a1 54 51 80 00       	mov    0x805154,%eax
  803081:	40                   	inc    %eax
  803082:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803087:	e9 41 02 00 00       	jmp    8032cd <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80308c:	8b 45 08             	mov    0x8(%ebp),%eax
  80308f:	8b 50 08             	mov    0x8(%eax),%edx
  803092:	8b 45 08             	mov    0x8(%ebp),%eax
  803095:	8b 40 0c             	mov    0xc(%eax),%eax
  803098:	01 c2                	add    %eax,%edx
  80309a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80309d:	8b 40 08             	mov    0x8(%eax),%eax
  8030a0:	39 c2                	cmp    %eax,%edx
  8030a2:	0f 85 7c 01 00 00    	jne    803224 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8030a8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030ac:	74 06                	je     8030b4 <insert_sorted_with_merge_freeList+0x530>
  8030ae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030b2:	75 17                	jne    8030cb <insert_sorted_with_merge_freeList+0x547>
  8030b4:	83 ec 04             	sub    $0x4,%esp
  8030b7:	68 48 3e 80 00       	push   $0x803e48
  8030bc:	68 69 01 00 00       	push   $0x169
  8030c1:	68 2f 3e 80 00       	push   $0x803e2f
  8030c6:	e8 05 02 00 00       	call   8032d0 <_panic>
  8030cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ce:	8b 50 04             	mov    0x4(%eax),%edx
  8030d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d4:	89 50 04             	mov    %edx,0x4(%eax)
  8030d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030da:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030dd:	89 10                	mov    %edx,(%eax)
  8030df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e2:	8b 40 04             	mov    0x4(%eax),%eax
  8030e5:	85 c0                	test   %eax,%eax
  8030e7:	74 0d                	je     8030f6 <insert_sorted_with_merge_freeList+0x572>
  8030e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ec:	8b 40 04             	mov    0x4(%eax),%eax
  8030ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8030f2:	89 10                	mov    %edx,(%eax)
  8030f4:	eb 08                	jmp    8030fe <insert_sorted_with_merge_freeList+0x57a>
  8030f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f9:	a3 38 51 80 00       	mov    %eax,0x805138
  8030fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803101:	8b 55 08             	mov    0x8(%ebp),%edx
  803104:	89 50 04             	mov    %edx,0x4(%eax)
  803107:	a1 44 51 80 00       	mov    0x805144,%eax
  80310c:	40                   	inc    %eax
  80310d:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803112:	8b 45 08             	mov    0x8(%ebp),%eax
  803115:	8b 50 0c             	mov    0xc(%eax),%edx
  803118:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80311b:	8b 40 0c             	mov    0xc(%eax),%eax
  80311e:	01 c2                	add    %eax,%edx
  803120:	8b 45 08             	mov    0x8(%ebp),%eax
  803123:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803126:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80312a:	75 17                	jne    803143 <insert_sorted_with_merge_freeList+0x5bf>
  80312c:	83 ec 04             	sub    $0x4,%esp
  80312f:	68 d8 3e 80 00       	push   $0x803ed8
  803134:	68 6b 01 00 00       	push   $0x16b
  803139:	68 2f 3e 80 00       	push   $0x803e2f
  80313e:	e8 8d 01 00 00       	call   8032d0 <_panic>
  803143:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803146:	8b 00                	mov    (%eax),%eax
  803148:	85 c0                	test   %eax,%eax
  80314a:	74 10                	je     80315c <insert_sorted_with_merge_freeList+0x5d8>
  80314c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80314f:	8b 00                	mov    (%eax),%eax
  803151:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803154:	8b 52 04             	mov    0x4(%edx),%edx
  803157:	89 50 04             	mov    %edx,0x4(%eax)
  80315a:	eb 0b                	jmp    803167 <insert_sorted_with_merge_freeList+0x5e3>
  80315c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80315f:	8b 40 04             	mov    0x4(%eax),%eax
  803162:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803167:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80316a:	8b 40 04             	mov    0x4(%eax),%eax
  80316d:	85 c0                	test   %eax,%eax
  80316f:	74 0f                	je     803180 <insert_sorted_with_merge_freeList+0x5fc>
  803171:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803174:	8b 40 04             	mov    0x4(%eax),%eax
  803177:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80317a:	8b 12                	mov    (%edx),%edx
  80317c:	89 10                	mov    %edx,(%eax)
  80317e:	eb 0a                	jmp    80318a <insert_sorted_with_merge_freeList+0x606>
  803180:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803183:	8b 00                	mov    (%eax),%eax
  803185:	a3 38 51 80 00       	mov    %eax,0x805138
  80318a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80318d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803193:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803196:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80319d:	a1 44 51 80 00       	mov    0x805144,%eax
  8031a2:	48                   	dec    %eax
  8031a3:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8031a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ab:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8031b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8031bc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031c0:	75 17                	jne    8031d9 <insert_sorted_with_merge_freeList+0x655>
  8031c2:	83 ec 04             	sub    $0x4,%esp
  8031c5:	68 0c 3e 80 00       	push   $0x803e0c
  8031ca:	68 6e 01 00 00       	push   $0x16e
  8031cf:	68 2f 3e 80 00       	push   $0x803e2f
  8031d4:	e8 f7 00 00 00       	call   8032d0 <_panic>
  8031d9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e2:	89 10                	mov    %edx,(%eax)
  8031e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e7:	8b 00                	mov    (%eax),%eax
  8031e9:	85 c0                	test   %eax,%eax
  8031eb:	74 0d                	je     8031fa <insert_sorted_with_merge_freeList+0x676>
  8031ed:	a1 48 51 80 00       	mov    0x805148,%eax
  8031f2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031f5:	89 50 04             	mov    %edx,0x4(%eax)
  8031f8:	eb 08                	jmp    803202 <insert_sorted_with_merge_freeList+0x67e>
  8031fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031fd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803202:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803205:	a3 48 51 80 00       	mov    %eax,0x805148
  80320a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80320d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803214:	a1 54 51 80 00       	mov    0x805154,%eax
  803219:	40                   	inc    %eax
  80321a:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80321f:	e9 a9 00 00 00       	jmp    8032cd <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803224:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803228:	74 06                	je     803230 <insert_sorted_with_merge_freeList+0x6ac>
  80322a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80322e:	75 17                	jne    803247 <insert_sorted_with_merge_freeList+0x6c3>
  803230:	83 ec 04             	sub    $0x4,%esp
  803233:	68 a4 3e 80 00       	push   $0x803ea4
  803238:	68 73 01 00 00       	push   $0x173
  80323d:	68 2f 3e 80 00       	push   $0x803e2f
  803242:	e8 89 00 00 00       	call   8032d0 <_panic>
  803247:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324a:	8b 10                	mov    (%eax),%edx
  80324c:	8b 45 08             	mov    0x8(%ebp),%eax
  80324f:	89 10                	mov    %edx,(%eax)
  803251:	8b 45 08             	mov    0x8(%ebp),%eax
  803254:	8b 00                	mov    (%eax),%eax
  803256:	85 c0                	test   %eax,%eax
  803258:	74 0b                	je     803265 <insert_sorted_with_merge_freeList+0x6e1>
  80325a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325d:	8b 00                	mov    (%eax),%eax
  80325f:	8b 55 08             	mov    0x8(%ebp),%edx
  803262:	89 50 04             	mov    %edx,0x4(%eax)
  803265:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803268:	8b 55 08             	mov    0x8(%ebp),%edx
  80326b:	89 10                	mov    %edx,(%eax)
  80326d:	8b 45 08             	mov    0x8(%ebp),%eax
  803270:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803273:	89 50 04             	mov    %edx,0x4(%eax)
  803276:	8b 45 08             	mov    0x8(%ebp),%eax
  803279:	8b 00                	mov    (%eax),%eax
  80327b:	85 c0                	test   %eax,%eax
  80327d:	75 08                	jne    803287 <insert_sorted_with_merge_freeList+0x703>
  80327f:	8b 45 08             	mov    0x8(%ebp),%eax
  803282:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803287:	a1 44 51 80 00       	mov    0x805144,%eax
  80328c:	40                   	inc    %eax
  80328d:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803292:	eb 39                	jmp    8032cd <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803294:	a1 40 51 80 00       	mov    0x805140,%eax
  803299:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80329c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032a0:	74 07                	je     8032a9 <insert_sorted_with_merge_freeList+0x725>
  8032a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a5:	8b 00                	mov    (%eax),%eax
  8032a7:	eb 05                	jmp    8032ae <insert_sorted_with_merge_freeList+0x72a>
  8032a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8032ae:	a3 40 51 80 00       	mov    %eax,0x805140
  8032b3:	a1 40 51 80 00       	mov    0x805140,%eax
  8032b8:	85 c0                	test   %eax,%eax
  8032ba:	0f 85 c7 fb ff ff    	jne    802e87 <insert_sorted_with_merge_freeList+0x303>
  8032c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032c4:	0f 85 bd fb ff ff    	jne    802e87 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8032ca:	eb 01                	jmp    8032cd <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8032cc:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8032cd:	90                   	nop
  8032ce:	c9                   	leave  
  8032cf:	c3                   	ret    

008032d0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8032d0:	55                   	push   %ebp
  8032d1:	89 e5                	mov    %esp,%ebp
  8032d3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8032d6:	8d 45 10             	lea    0x10(%ebp),%eax
  8032d9:	83 c0 04             	add    $0x4,%eax
  8032dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8032df:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8032e4:	85 c0                	test   %eax,%eax
  8032e6:	74 16                	je     8032fe <_panic+0x2e>
		cprintf("%s: ", argv0);
  8032e8:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8032ed:	83 ec 08             	sub    $0x8,%esp
  8032f0:	50                   	push   %eax
  8032f1:	68 f8 3e 80 00       	push   $0x803ef8
  8032f6:	e8 6b d2 ff ff       	call   800566 <cprintf>
  8032fb:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8032fe:	a1 00 50 80 00       	mov    0x805000,%eax
  803303:	ff 75 0c             	pushl  0xc(%ebp)
  803306:	ff 75 08             	pushl  0x8(%ebp)
  803309:	50                   	push   %eax
  80330a:	68 fd 3e 80 00       	push   $0x803efd
  80330f:	e8 52 d2 ff ff       	call   800566 <cprintf>
  803314:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803317:	8b 45 10             	mov    0x10(%ebp),%eax
  80331a:	83 ec 08             	sub    $0x8,%esp
  80331d:	ff 75 f4             	pushl  -0xc(%ebp)
  803320:	50                   	push   %eax
  803321:	e8 d5 d1 ff ff       	call   8004fb <vcprintf>
  803326:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803329:	83 ec 08             	sub    $0x8,%esp
  80332c:	6a 00                	push   $0x0
  80332e:	68 19 3f 80 00       	push   $0x803f19
  803333:	e8 c3 d1 ff ff       	call   8004fb <vcprintf>
  803338:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80333b:	e8 44 d1 ff ff       	call   800484 <exit>

	// should not return here
	while (1) ;
  803340:	eb fe                	jmp    803340 <_panic+0x70>

00803342 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803342:	55                   	push   %ebp
  803343:	89 e5                	mov    %esp,%ebp
  803345:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803348:	a1 20 50 80 00       	mov    0x805020,%eax
  80334d:	8b 50 74             	mov    0x74(%eax),%edx
  803350:	8b 45 0c             	mov    0xc(%ebp),%eax
  803353:	39 c2                	cmp    %eax,%edx
  803355:	74 14                	je     80336b <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803357:	83 ec 04             	sub    $0x4,%esp
  80335a:	68 1c 3f 80 00       	push   $0x803f1c
  80335f:	6a 26                	push   $0x26
  803361:	68 68 3f 80 00       	push   $0x803f68
  803366:	e8 65 ff ff ff       	call   8032d0 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80336b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803372:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803379:	e9 c2 00 00 00       	jmp    803440 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80337e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803381:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803388:	8b 45 08             	mov    0x8(%ebp),%eax
  80338b:	01 d0                	add    %edx,%eax
  80338d:	8b 00                	mov    (%eax),%eax
  80338f:	85 c0                	test   %eax,%eax
  803391:	75 08                	jne    80339b <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  803393:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803396:	e9 a2 00 00 00       	jmp    80343d <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80339b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8033a2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8033a9:	eb 69                	jmp    803414 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8033ab:	a1 20 50 80 00       	mov    0x805020,%eax
  8033b0:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8033b6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033b9:	89 d0                	mov    %edx,%eax
  8033bb:	01 c0                	add    %eax,%eax
  8033bd:	01 d0                	add    %edx,%eax
  8033bf:	c1 e0 03             	shl    $0x3,%eax
  8033c2:	01 c8                	add    %ecx,%eax
  8033c4:	8a 40 04             	mov    0x4(%eax),%al
  8033c7:	84 c0                	test   %al,%al
  8033c9:	75 46                	jne    803411 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8033cb:	a1 20 50 80 00       	mov    0x805020,%eax
  8033d0:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8033d6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033d9:	89 d0                	mov    %edx,%eax
  8033db:	01 c0                	add    %eax,%eax
  8033dd:	01 d0                	add    %edx,%eax
  8033df:	c1 e0 03             	shl    $0x3,%eax
  8033e2:	01 c8                	add    %ecx,%eax
  8033e4:	8b 00                	mov    (%eax),%eax
  8033e6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8033e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033ec:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8033f1:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8033f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033f6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8033fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803400:	01 c8                	add    %ecx,%eax
  803402:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803404:	39 c2                	cmp    %eax,%edx
  803406:	75 09                	jne    803411 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  803408:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80340f:	eb 12                	jmp    803423 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803411:	ff 45 e8             	incl   -0x18(%ebp)
  803414:	a1 20 50 80 00       	mov    0x805020,%eax
  803419:	8b 50 74             	mov    0x74(%eax),%edx
  80341c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80341f:	39 c2                	cmp    %eax,%edx
  803421:	77 88                	ja     8033ab <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803423:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803427:	75 14                	jne    80343d <CheckWSWithoutLastIndex+0xfb>
			panic(
  803429:	83 ec 04             	sub    $0x4,%esp
  80342c:	68 74 3f 80 00       	push   $0x803f74
  803431:	6a 3a                	push   $0x3a
  803433:	68 68 3f 80 00       	push   $0x803f68
  803438:	e8 93 fe ff ff       	call   8032d0 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80343d:	ff 45 f0             	incl   -0x10(%ebp)
  803440:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803443:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803446:	0f 8c 32 ff ff ff    	jl     80337e <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80344c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803453:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80345a:	eb 26                	jmp    803482 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80345c:	a1 20 50 80 00       	mov    0x805020,%eax
  803461:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803467:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80346a:	89 d0                	mov    %edx,%eax
  80346c:	01 c0                	add    %eax,%eax
  80346e:	01 d0                	add    %edx,%eax
  803470:	c1 e0 03             	shl    $0x3,%eax
  803473:	01 c8                	add    %ecx,%eax
  803475:	8a 40 04             	mov    0x4(%eax),%al
  803478:	3c 01                	cmp    $0x1,%al
  80347a:	75 03                	jne    80347f <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80347c:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80347f:	ff 45 e0             	incl   -0x20(%ebp)
  803482:	a1 20 50 80 00       	mov    0x805020,%eax
  803487:	8b 50 74             	mov    0x74(%eax),%edx
  80348a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80348d:	39 c2                	cmp    %eax,%edx
  80348f:	77 cb                	ja     80345c <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803491:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803494:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803497:	74 14                	je     8034ad <CheckWSWithoutLastIndex+0x16b>
		panic(
  803499:	83 ec 04             	sub    $0x4,%esp
  80349c:	68 c8 3f 80 00       	push   $0x803fc8
  8034a1:	6a 44                	push   $0x44
  8034a3:	68 68 3f 80 00       	push   $0x803f68
  8034a8:	e8 23 fe ff ff       	call   8032d0 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8034ad:	90                   	nop
  8034ae:	c9                   	leave  
  8034af:	c3                   	ret    

008034b0 <__udivdi3>:
  8034b0:	55                   	push   %ebp
  8034b1:	57                   	push   %edi
  8034b2:	56                   	push   %esi
  8034b3:	53                   	push   %ebx
  8034b4:	83 ec 1c             	sub    $0x1c,%esp
  8034b7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8034bb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8034bf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034c3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8034c7:	89 ca                	mov    %ecx,%edx
  8034c9:	89 f8                	mov    %edi,%eax
  8034cb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8034cf:	85 f6                	test   %esi,%esi
  8034d1:	75 2d                	jne    803500 <__udivdi3+0x50>
  8034d3:	39 cf                	cmp    %ecx,%edi
  8034d5:	77 65                	ja     80353c <__udivdi3+0x8c>
  8034d7:	89 fd                	mov    %edi,%ebp
  8034d9:	85 ff                	test   %edi,%edi
  8034db:	75 0b                	jne    8034e8 <__udivdi3+0x38>
  8034dd:	b8 01 00 00 00       	mov    $0x1,%eax
  8034e2:	31 d2                	xor    %edx,%edx
  8034e4:	f7 f7                	div    %edi
  8034e6:	89 c5                	mov    %eax,%ebp
  8034e8:	31 d2                	xor    %edx,%edx
  8034ea:	89 c8                	mov    %ecx,%eax
  8034ec:	f7 f5                	div    %ebp
  8034ee:	89 c1                	mov    %eax,%ecx
  8034f0:	89 d8                	mov    %ebx,%eax
  8034f2:	f7 f5                	div    %ebp
  8034f4:	89 cf                	mov    %ecx,%edi
  8034f6:	89 fa                	mov    %edi,%edx
  8034f8:	83 c4 1c             	add    $0x1c,%esp
  8034fb:	5b                   	pop    %ebx
  8034fc:	5e                   	pop    %esi
  8034fd:	5f                   	pop    %edi
  8034fe:	5d                   	pop    %ebp
  8034ff:	c3                   	ret    
  803500:	39 ce                	cmp    %ecx,%esi
  803502:	77 28                	ja     80352c <__udivdi3+0x7c>
  803504:	0f bd fe             	bsr    %esi,%edi
  803507:	83 f7 1f             	xor    $0x1f,%edi
  80350a:	75 40                	jne    80354c <__udivdi3+0x9c>
  80350c:	39 ce                	cmp    %ecx,%esi
  80350e:	72 0a                	jb     80351a <__udivdi3+0x6a>
  803510:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803514:	0f 87 9e 00 00 00    	ja     8035b8 <__udivdi3+0x108>
  80351a:	b8 01 00 00 00       	mov    $0x1,%eax
  80351f:	89 fa                	mov    %edi,%edx
  803521:	83 c4 1c             	add    $0x1c,%esp
  803524:	5b                   	pop    %ebx
  803525:	5e                   	pop    %esi
  803526:	5f                   	pop    %edi
  803527:	5d                   	pop    %ebp
  803528:	c3                   	ret    
  803529:	8d 76 00             	lea    0x0(%esi),%esi
  80352c:	31 ff                	xor    %edi,%edi
  80352e:	31 c0                	xor    %eax,%eax
  803530:	89 fa                	mov    %edi,%edx
  803532:	83 c4 1c             	add    $0x1c,%esp
  803535:	5b                   	pop    %ebx
  803536:	5e                   	pop    %esi
  803537:	5f                   	pop    %edi
  803538:	5d                   	pop    %ebp
  803539:	c3                   	ret    
  80353a:	66 90                	xchg   %ax,%ax
  80353c:	89 d8                	mov    %ebx,%eax
  80353e:	f7 f7                	div    %edi
  803540:	31 ff                	xor    %edi,%edi
  803542:	89 fa                	mov    %edi,%edx
  803544:	83 c4 1c             	add    $0x1c,%esp
  803547:	5b                   	pop    %ebx
  803548:	5e                   	pop    %esi
  803549:	5f                   	pop    %edi
  80354a:	5d                   	pop    %ebp
  80354b:	c3                   	ret    
  80354c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803551:	89 eb                	mov    %ebp,%ebx
  803553:	29 fb                	sub    %edi,%ebx
  803555:	89 f9                	mov    %edi,%ecx
  803557:	d3 e6                	shl    %cl,%esi
  803559:	89 c5                	mov    %eax,%ebp
  80355b:	88 d9                	mov    %bl,%cl
  80355d:	d3 ed                	shr    %cl,%ebp
  80355f:	89 e9                	mov    %ebp,%ecx
  803561:	09 f1                	or     %esi,%ecx
  803563:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803567:	89 f9                	mov    %edi,%ecx
  803569:	d3 e0                	shl    %cl,%eax
  80356b:	89 c5                	mov    %eax,%ebp
  80356d:	89 d6                	mov    %edx,%esi
  80356f:	88 d9                	mov    %bl,%cl
  803571:	d3 ee                	shr    %cl,%esi
  803573:	89 f9                	mov    %edi,%ecx
  803575:	d3 e2                	shl    %cl,%edx
  803577:	8b 44 24 08          	mov    0x8(%esp),%eax
  80357b:	88 d9                	mov    %bl,%cl
  80357d:	d3 e8                	shr    %cl,%eax
  80357f:	09 c2                	or     %eax,%edx
  803581:	89 d0                	mov    %edx,%eax
  803583:	89 f2                	mov    %esi,%edx
  803585:	f7 74 24 0c          	divl   0xc(%esp)
  803589:	89 d6                	mov    %edx,%esi
  80358b:	89 c3                	mov    %eax,%ebx
  80358d:	f7 e5                	mul    %ebp
  80358f:	39 d6                	cmp    %edx,%esi
  803591:	72 19                	jb     8035ac <__udivdi3+0xfc>
  803593:	74 0b                	je     8035a0 <__udivdi3+0xf0>
  803595:	89 d8                	mov    %ebx,%eax
  803597:	31 ff                	xor    %edi,%edi
  803599:	e9 58 ff ff ff       	jmp    8034f6 <__udivdi3+0x46>
  80359e:	66 90                	xchg   %ax,%ax
  8035a0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8035a4:	89 f9                	mov    %edi,%ecx
  8035a6:	d3 e2                	shl    %cl,%edx
  8035a8:	39 c2                	cmp    %eax,%edx
  8035aa:	73 e9                	jae    803595 <__udivdi3+0xe5>
  8035ac:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8035af:	31 ff                	xor    %edi,%edi
  8035b1:	e9 40 ff ff ff       	jmp    8034f6 <__udivdi3+0x46>
  8035b6:	66 90                	xchg   %ax,%ax
  8035b8:	31 c0                	xor    %eax,%eax
  8035ba:	e9 37 ff ff ff       	jmp    8034f6 <__udivdi3+0x46>
  8035bf:	90                   	nop

008035c0 <__umoddi3>:
  8035c0:	55                   	push   %ebp
  8035c1:	57                   	push   %edi
  8035c2:	56                   	push   %esi
  8035c3:	53                   	push   %ebx
  8035c4:	83 ec 1c             	sub    $0x1c,%esp
  8035c7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8035cb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8035cf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8035d3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8035d7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8035db:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8035df:	89 f3                	mov    %esi,%ebx
  8035e1:	89 fa                	mov    %edi,%edx
  8035e3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035e7:	89 34 24             	mov    %esi,(%esp)
  8035ea:	85 c0                	test   %eax,%eax
  8035ec:	75 1a                	jne    803608 <__umoddi3+0x48>
  8035ee:	39 f7                	cmp    %esi,%edi
  8035f0:	0f 86 a2 00 00 00    	jbe    803698 <__umoddi3+0xd8>
  8035f6:	89 c8                	mov    %ecx,%eax
  8035f8:	89 f2                	mov    %esi,%edx
  8035fa:	f7 f7                	div    %edi
  8035fc:	89 d0                	mov    %edx,%eax
  8035fe:	31 d2                	xor    %edx,%edx
  803600:	83 c4 1c             	add    $0x1c,%esp
  803603:	5b                   	pop    %ebx
  803604:	5e                   	pop    %esi
  803605:	5f                   	pop    %edi
  803606:	5d                   	pop    %ebp
  803607:	c3                   	ret    
  803608:	39 f0                	cmp    %esi,%eax
  80360a:	0f 87 ac 00 00 00    	ja     8036bc <__umoddi3+0xfc>
  803610:	0f bd e8             	bsr    %eax,%ebp
  803613:	83 f5 1f             	xor    $0x1f,%ebp
  803616:	0f 84 ac 00 00 00    	je     8036c8 <__umoddi3+0x108>
  80361c:	bf 20 00 00 00       	mov    $0x20,%edi
  803621:	29 ef                	sub    %ebp,%edi
  803623:	89 fe                	mov    %edi,%esi
  803625:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803629:	89 e9                	mov    %ebp,%ecx
  80362b:	d3 e0                	shl    %cl,%eax
  80362d:	89 d7                	mov    %edx,%edi
  80362f:	89 f1                	mov    %esi,%ecx
  803631:	d3 ef                	shr    %cl,%edi
  803633:	09 c7                	or     %eax,%edi
  803635:	89 e9                	mov    %ebp,%ecx
  803637:	d3 e2                	shl    %cl,%edx
  803639:	89 14 24             	mov    %edx,(%esp)
  80363c:	89 d8                	mov    %ebx,%eax
  80363e:	d3 e0                	shl    %cl,%eax
  803640:	89 c2                	mov    %eax,%edx
  803642:	8b 44 24 08          	mov    0x8(%esp),%eax
  803646:	d3 e0                	shl    %cl,%eax
  803648:	89 44 24 04          	mov    %eax,0x4(%esp)
  80364c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803650:	89 f1                	mov    %esi,%ecx
  803652:	d3 e8                	shr    %cl,%eax
  803654:	09 d0                	or     %edx,%eax
  803656:	d3 eb                	shr    %cl,%ebx
  803658:	89 da                	mov    %ebx,%edx
  80365a:	f7 f7                	div    %edi
  80365c:	89 d3                	mov    %edx,%ebx
  80365e:	f7 24 24             	mull   (%esp)
  803661:	89 c6                	mov    %eax,%esi
  803663:	89 d1                	mov    %edx,%ecx
  803665:	39 d3                	cmp    %edx,%ebx
  803667:	0f 82 87 00 00 00    	jb     8036f4 <__umoddi3+0x134>
  80366d:	0f 84 91 00 00 00    	je     803704 <__umoddi3+0x144>
  803673:	8b 54 24 04          	mov    0x4(%esp),%edx
  803677:	29 f2                	sub    %esi,%edx
  803679:	19 cb                	sbb    %ecx,%ebx
  80367b:	89 d8                	mov    %ebx,%eax
  80367d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803681:	d3 e0                	shl    %cl,%eax
  803683:	89 e9                	mov    %ebp,%ecx
  803685:	d3 ea                	shr    %cl,%edx
  803687:	09 d0                	or     %edx,%eax
  803689:	89 e9                	mov    %ebp,%ecx
  80368b:	d3 eb                	shr    %cl,%ebx
  80368d:	89 da                	mov    %ebx,%edx
  80368f:	83 c4 1c             	add    $0x1c,%esp
  803692:	5b                   	pop    %ebx
  803693:	5e                   	pop    %esi
  803694:	5f                   	pop    %edi
  803695:	5d                   	pop    %ebp
  803696:	c3                   	ret    
  803697:	90                   	nop
  803698:	89 fd                	mov    %edi,%ebp
  80369a:	85 ff                	test   %edi,%edi
  80369c:	75 0b                	jne    8036a9 <__umoddi3+0xe9>
  80369e:	b8 01 00 00 00       	mov    $0x1,%eax
  8036a3:	31 d2                	xor    %edx,%edx
  8036a5:	f7 f7                	div    %edi
  8036a7:	89 c5                	mov    %eax,%ebp
  8036a9:	89 f0                	mov    %esi,%eax
  8036ab:	31 d2                	xor    %edx,%edx
  8036ad:	f7 f5                	div    %ebp
  8036af:	89 c8                	mov    %ecx,%eax
  8036b1:	f7 f5                	div    %ebp
  8036b3:	89 d0                	mov    %edx,%eax
  8036b5:	e9 44 ff ff ff       	jmp    8035fe <__umoddi3+0x3e>
  8036ba:	66 90                	xchg   %ax,%ax
  8036bc:	89 c8                	mov    %ecx,%eax
  8036be:	89 f2                	mov    %esi,%edx
  8036c0:	83 c4 1c             	add    $0x1c,%esp
  8036c3:	5b                   	pop    %ebx
  8036c4:	5e                   	pop    %esi
  8036c5:	5f                   	pop    %edi
  8036c6:	5d                   	pop    %ebp
  8036c7:	c3                   	ret    
  8036c8:	3b 04 24             	cmp    (%esp),%eax
  8036cb:	72 06                	jb     8036d3 <__umoddi3+0x113>
  8036cd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8036d1:	77 0f                	ja     8036e2 <__umoddi3+0x122>
  8036d3:	89 f2                	mov    %esi,%edx
  8036d5:	29 f9                	sub    %edi,%ecx
  8036d7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8036db:	89 14 24             	mov    %edx,(%esp)
  8036de:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036e2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8036e6:	8b 14 24             	mov    (%esp),%edx
  8036e9:	83 c4 1c             	add    $0x1c,%esp
  8036ec:	5b                   	pop    %ebx
  8036ed:	5e                   	pop    %esi
  8036ee:	5f                   	pop    %edi
  8036ef:	5d                   	pop    %ebp
  8036f0:	c3                   	ret    
  8036f1:	8d 76 00             	lea    0x0(%esi),%esi
  8036f4:	2b 04 24             	sub    (%esp),%eax
  8036f7:	19 fa                	sbb    %edi,%edx
  8036f9:	89 d1                	mov    %edx,%ecx
  8036fb:	89 c6                	mov    %eax,%esi
  8036fd:	e9 71 ff ff ff       	jmp    803673 <__umoddi3+0xb3>
  803702:	66 90                	xchg   %ax,%ax
  803704:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803708:	72 ea                	jb     8036f4 <__umoddi3+0x134>
  80370a:	89 d9                	mov    %ebx,%ecx
  80370c:	e9 62 ff ff ff       	jmp    803673 <__umoddi3+0xb3>
