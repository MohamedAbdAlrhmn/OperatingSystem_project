
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
  80003e:	e8 47 1a 00 00       	call   801a8a <sys_getenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int32 parentenvID = sys_getparentenvid();
  800046:	e8 71 1a 00 00       	call   801abc <sys_getparentenvid>
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
  80005f:	68 e0 37 80 00       	push   $0x8037e0
  800064:	ff 75 ec             	pushl  -0x14(%ebp)
  800067:	e8 b3 15 00 00       	call   80161f <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	numOfElements = sget(parentenvID,"arrSize") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 e4 37 80 00       	push   $0x8037e4
  80007a:	ff 75 ec             	pushl  -0x14(%ebp)
  80007d:	e8 9d 15 00 00       	call   80161f <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//Get the check-finishing counter
	int *finishedCount = NULL;
  800088:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	finishedCount = sget(parentenvID,"finishedCount") ;
  80008f:	83 ec 08             	sub    $0x8,%esp
  800092:	68 ec 37 80 00       	push   $0x8037ec
  800097:	ff 75 ec             	pushl  -0x14(%ebp)
  80009a:	e8 80 15 00 00       	call   80161f <sget>
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
  8000b3:	68 fa 37 80 00       	push   $0x8037fa
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
  800112:	68 09 38 80 00       	push   $0x803809
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
  800166:	e8 84 19 00 00       	call   801aef <sys_get_virtual_time>
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
  8002f6:	68 25 38 80 00       	push   $0x803825
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
  800318:	68 27 38 80 00       	push   $0x803827
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
  800346:	68 2c 38 80 00       	push   $0x80382c
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
  80035c:	e8 42 17 00 00       	call   801aa3 <sys_getenvindex>
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
  8003c7:	e8 e4 14 00 00       	call   8018b0 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8003cc:	83 ec 0c             	sub    $0xc,%esp
  8003cf:	68 48 38 80 00       	push   $0x803848
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
  8003f7:	68 70 38 80 00       	push   $0x803870
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
  800428:	68 98 38 80 00       	push   $0x803898
  80042d:	e8 34 01 00 00       	call   800566 <cprintf>
  800432:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800435:	a1 20 50 80 00       	mov    0x805020,%eax
  80043a:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800440:	83 ec 08             	sub    $0x8,%esp
  800443:	50                   	push   %eax
  800444:	68 f0 38 80 00       	push   $0x8038f0
  800449:	e8 18 01 00 00       	call   800566 <cprintf>
  80044e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800451:	83 ec 0c             	sub    $0xc,%esp
  800454:	68 48 38 80 00       	push   $0x803848
  800459:	e8 08 01 00 00       	call   800566 <cprintf>
  80045e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800461:	e8 64 14 00 00       	call   8018ca <sys_enable_interrupt>

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
  800479:	e8 f1 15 00 00       	call   801a6f <sys_destroy_env>
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
  80048a:	e8 46 16 00 00       	call   801ad5 <sys_exit_env>
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
  8004d8:	e8 25 12 00 00       	call   801702 <sys_cputs>
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
  80054f:	e8 ae 11 00 00       	call   801702 <sys_cputs>
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
  800599:	e8 12 13 00 00       	call   8018b0 <sys_disable_interrupt>
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
  8005b9:	e8 0c 13 00 00       	call   8018ca <sys_enable_interrupt>
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
  800603:	e8 60 2f 00 00       	call   803568 <__udivdi3>
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
  800653:	e8 20 30 00 00       	call   803678 <__umoddi3>
  800658:	83 c4 10             	add    $0x10,%esp
  80065b:	05 34 3b 80 00       	add    $0x803b34,%eax
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
  8007ae:	8b 04 85 58 3b 80 00 	mov    0x803b58(,%eax,4),%eax
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
  80088f:	8b 34 9d a0 39 80 00 	mov    0x8039a0(,%ebx,4),%esi
  800896:	85 f6                	test   %esi,%esi
  800898:	75 19                	jne    8008b3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80089a:	53                   	push   %ebx
  80089b:	68 45 3b 80 00       	push   $0x803b45
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
  8008b4:	68 4e 3b 80 00       	push   $0x803b4e
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
  8008e1:	be 51 3b 80 00       	mov    $0x803b51,%esi
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
  801307:	68 b0 3c 80 00       	push   $0x803cb0
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
  8013d7:	e8 6a 04 00 00       	call   801846 <sys_allocate_chunk>
  8013dc:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013df:	a1 20 51 80 00       	mov    0x805120,%eax
  8013e4:	83 ec 0c             	sub    $0xc,%esp
  8013e7:	50                   	push   %eax
  8013e8:	e8 df 0a 00 00       	call   801ecc <initialize_MemBlocksList>
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
  801415:	68 d5 3c 80 00       	push   $0x803cd5
  80141a:	6a 33                	push   $0x33
  80141c:	68 f3 3c 80 00       	push   $0x803cf3
  801421:	e8 5f 1f 00 00       	call   803385 <_panic>
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
  801494:	68 00 3d 80 00       	push   $0x803d00
  801499:	6a 34                	push   $0x34
  80149b:	68 f3 3c 80 00       	push   $0x803cf3
  8014a0:	e8 e0 1e 00 00       	call   803385 <_panic>
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
  80152c:	e8 e3 06 00 00       	call   801c14 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801531:	85 c0                	test   %eax,%eax
  801533:	74 11                	je     801546 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801535:	83 ec 0c             	sub    $0xc,%esp
  801538:	ff 75 e8             	pushl  -0x18(%ebp)
  80153b:	e8 4e 0d 00 00       	call   80228e <alloc_block_FF>
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
  801552:	e8 aa 0a 00 00       	call   802001 <insert_sorted_allocList>
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
  801572:	68 24 3d 80 00       	push   $0x803d24
  801577:	6a 6f                	push   $0x6f
  801579:	68 f3 3c 80 00       	push   $0x803cf3
  80157e:	e8 02 1e 00 00       	call   803385 <_panic>

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
  801598:	75 07                	jne    8015a1 <smalloc+0x1e>
  80159a:	b8 00 00 00 00       	mov    $0x0,%eax
  80159f:	eb 7c                	jmp    80161d <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8015a1:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8015a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ae:	01 d0                	add    %edx,%eax
  8015b0:	48                   	dec    %eax
  8015b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8015b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8015bc:	f7 75 f0             	divl   -0x10(%ebp)
  8015bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015c2:	29 d0                	sub    %edx,%eax
  8015c4:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8015c7:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8015ce:	e8 41 06 00 00       	call   801c14 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015d3:	85 c0                	test   %eax,%eax
  8015d5:	74 11                	je     8015e8 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  8015d7:	83 ec 0c             	sub    $0xc,%esp
  8015da:	ff 75 e8             	pushl  -0x18(%ebp)
  8015dd:	e8 ac 0c 00 00       	call   80228e <alloc_block_FF>
  8015e2:	83 c4 10             	add    $0x10,%esp
  8015e5:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  8015e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015ec:	74 2a                	je     801618 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8015ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f1:	8b 40 08             	mov    0x8(%eax),%eax
  8015f4:	89 c2                	mov    %eax,%edx
  8015f6:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8015fa:	52                   	push   %edx
  8015fb:	50                   	push   %eax
  8015fc:	ff 75 0c             	pushl  0xc(%ebp)
  8015ff:	ff 75 08             	pushl  0x8(%ebp)
  801602:	e8 92 03 00 00       	call   801999 <sys_createSharedObject>
  801607:	83 c4 10             	add    $0x10,%esp
  80160a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  80160d:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  801611:	74 05                	je     801618 <smalloc+0x95>
			return (void*)virtual_address;
  801613:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801616:	eb 05                	jmp    80161d <smalloc+0x9a>
	}
	return NULL;
  801618:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80161d:	c9                   	leave  
  80161e:	c3                   	ret    

0080161f <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80161f:	55                   	push   %ebp
  801620:	89 e5                	mov    %esp,%ebp
  801622:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801625:	e8 c6 fc ff ff       	call   8012f0 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  80162a:	83 ec 04             	sub    $0x4,%esp
  80162d:	68 48 3d 80 00       	push   $0x803d48
  801632:	68 b0 00 00 00       	push   $0xb0
  801637:	68 f3 3c 80 00       	push   $0x803cf3
  80163c:	e8 44 1d 00 00       	call   803385 <_panic>

00801641 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801641:	55                   	push   %ebp
  801642:	89 e5                	mov    %esp,%ebp
  801644:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801647:	e8 a4 fc ff ff       	call   8012f0 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80164c:	83 ec 04             	sub    $0x4,%esp
  80164f:	68 6c 3d 80 00       	push   $0x803d6c
  801654:	68 f4 00 00 00       	push   $0xf4
  801659:	68 f3 3c 80 00       	push   $0x803cf3
  80165e:	e8 22 1d 00 00       	call   803385 <_panic>

00801663 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801663:	55                   	push   %ebp
  801664:	89 e5                	mov    %esp,%ebp
  801666:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801669:	83 ec 04             	sub    $0x4,%esp
  80166c:	68 94 3d 80 00       	push   $0x803d94
  801671:	68 08 01 00 00       	push   $0x108
  801676:	68 f3 3c 80 00       	push   $0x803cf3
  80167b:	e8 05 1d 00 00       	call   803385 <_panic>

00801680 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801680:	55                   	push   %ebp
  801681:	89 e5                	mov    %esp,%ebp
  801683:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801686:	83 ec 04             	sub    $0x4,%esp
  801689:	68 b8 3d 80 00       	push   $0x803db8
  80168e:	68 13 01 00 00       	push   $0x113
  801693:	68 f3 3c 80 00       	push   $0x803cf3
  801698:	e8 e8 1c 00 00       	call   803385 <_panic>

0080169d <shrink>:

}
void shrink(uint32 newSize)
{
  80169d:	55                   	push   %ebp
  80169e:	89 e5                	mov    %esp,%ebp
  8016a0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016a3:	83 ec 04             	sub    $0x4,%esp
  8016a6:	68 b8 3d 80 00       	push   $0x803db8
  8016ab:	68 18 01 00 00       	push   $0x118
  8016b0:	68 f3 3c 80 00       	push   $0x803cf3
  8016b5:	e8 cb 1c 00 00       	call   803385 <_panic>

008016ba <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8016ba:	55                   	push   %ebp
  8016bb:	89 e5                	mov    %esp,%ebp
  8016bd:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016c0:	83 ec 04             	sub    $0x4,%esp
  8016c3:	68 b8 3d 80 00       	push   $0x803db8
  8016c8:	68 1d 01 00 00       	push   $0x11d
  8016cd:	68 f3 3c 80 00       	push   $0x803cf3
  8016d2:	e8 ae 1c 00 00       	call   803385 <_panic>

008016d7 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8016d7:	55                   	push   %ebp
  8016d8:	89 e5                	mov    %esp,%ebp
  8016da:	57                   	push   %edi
  8016db:	56                   	push   %esi
  8016dc:	53                   	push   %ebx
  8016dd:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016e6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016e9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016ec:	8b 7d 18             	mov    0x18(%ebp),%edi
  8016ef:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8016f2:	cd 30                	int    $0x30
  8016f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8016f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8016fa:	83 c4 10             	add    $0x10,%esp
  8016fd:	5b                   	pop    %ebx
  8016fe:	5e                   	pop    %esi
  8016ff:	5f                   	pop    %edi
  801700:	5d                   	pop    %ebp
  801701:	c3                   	ret    

00801702 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801702:	55                   	push   %ebp
  801703:	89 e5                	mov    %esp,%ebp
  801705:	83 ec 04             	sub    $0x4,%esp
  801708:	8b 45 10             	mov    0x10(%ebp),%eax
  80170b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80170e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801712:	8b 45 08             	mov    0x8(%ebp),%eax
  801715:	6a 00                	push   $0x0
  801717:	6a 00                	push   $0x0
  801719:	52                   	push   %edx
  80171a:	ff 75 0c             	pushl  0xc(%ebp)
  80171d:	50                   	push   %eax
  80171e:	6a 00                	push   $0x0
  801720:	e8 b2 ff ff ff       	call   8016d7 <syscall>
  801725:	83 c4 18             	add    $0x18,%esp
}
  801728:	90                   	nop
  801729:	c9                   	leave  
  80172a:	c3                   	ret    

0080172b <sys_cgetc>:

int
sys_cgetc(void)
{
  80172b:	55                   	push   %ebp
  80172c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80172e:	6a 00                	push   $0x0
  801730:	6a 00                	push   $0x0
  801732:	6a 00                	push   $0x0
  801734:	6a 00                	push   $0x0
  801736:	6a 00                	push   $0x0
  801738:	6a 01                	push   $0x1
  80173a:	e8 98 ff ff ff       	call   8016d7 <syscall>
  80173f:	83 c4 18             	add    $0x18,%esp
}
  801742:	c9                   	leave  
  801743:	c3                   	ret    

00801744 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801744:	55                   	push   %ebp
  801745:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801747:	8b 55 0c             	mov    0xc(%ebp),%edx
  80174a:	8b 45 08             	mov    0x8(%ebp),%eax
  80174d:	6a 00                	push   $0x0
  80174f:	6a 00                	push   $0x0
  801751:	6a 00                	push   $0x0
  801753:	52                   	push   %edx
  801754:	50                   	push   %eax
  801755:	6a 05                	push   $0x5
  801757:	e8 7b ff ff ff       	call   8016d7 <syscall>
  80175c:	83 c4 18             	add    $0x18,%esp
}
  80175f:	c9                   	leave  
  801760:	c3                   	ret    

00801761 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801761:	55                   	push   %ebp
  801762:	89 e5                	mov    %esp,%ebp
  801764:	56                   	push   %esi
  801765:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801766:	8b 75 18             	mov    0x18(%ebp),%esi
  801769:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80176c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80176f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801772:	8b 45 08             	mov    0x8(%ebp),%eax
  801775:	56                   	push   %esi
  801776:	53                   	push   %ebx
  801777:	51                   	push   %ecx
  801778:	52                   	push   %edx
  801779:	50                   	push   %eax
  80177a:	6a 06                	push   $0x6
  80177c:	e8 56 ff ff ff       	call   8016d7 <syscall>
  801781:	83 c4 18             	add    $0x18,%esp
}
  801784:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801787:	5b                   	pop    %ebx
  801788:	5e                   	pop    %esi
  801789:	5d                   	pop    %ebp
  80178a:	c3                   	ret    

0080178b <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80178b:	55                   	push   %ebp
  80178c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80178e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801791:	8b 45 08             	mov    0x8(%ebp),%eax
  801794:	6a 00                	push   $0x0
  801796:	6a 00                	push   $0x0
  801798:	6a 00                	push   $0x0
  80179a:	52                   	push   %edx
  80179b:	50                   	push   %eax
  80179c:	6a 07                	push   $0x7
  80179e:	e8 34 ff ff ff       	call   8016d7 <syscall>
  8017a3:	83 c4 18             	add    $0x18,%esp
}
  8017a6:	c9                   	leave  
  8017a7:	c3                   	ret    

008017a8 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8017a8:	55                   	push   %ebp
  8017a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8017ab:	6a 00                	push   $0x0
  8017ad:	6a 00                	push   $0x0
  8017af:	6a 00                	push   $0x0
  8017b1:	ff 75 0c             	pushl  0xc(%ebp)
  8017b4:	ff 75 08             	pushl  0x8(%ebp)
  8017b7:	6a 08                	push   $0x8
  8017b9:	e8 19 ff ff ff       	call   8016d7 <syscall>
  8017be:	83 c4 18             	add    $0x18,%esp
}
  8017c1:	c9                   	leave  
  8017c2:	c3                   	ret    

008017c3 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8017c3:	55                   	push   %ebp
  8017c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8017c6:	6a 00                	push   $0x0
  8017c8:	6a 00                	push   $0x0
  8017ca:	6a 00                	push   $0x0
  8017cc:	6a 00                	push   $0x0
  8017ce:	6a 00                	push   $0x0
  8017d0:	6a 09                	push   $0x9
  8017d2:	e8 00 ff ff ff       	call   8016d7 <syscall>
  8017d7:	83 c4 18             	add    $0x18,%esp
}
  8017da:	c9                   	leave  
  8017db:	c3                   	ret    

008017dc <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8017dc:	55                   	push   %ebp
  8017dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8017df:	6a 00                	push   $0x0
  8017e1:	6a 00                	push   $0x0
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 00                	push   $0x0
  8017e9:	6a 0a                	push   $0xa
  8017eb:	e8 e7 fe ff ff       	call   8016d7 <syscall>
  8017f0:	83 c4 18             	add    $0x18,%esp
}
  8017f3:	c9                   	leave  
  8017f4:	c3                   	ret    

008017f5 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8017f5:	55                   	push   %ebp
  8017f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8017f8:	6a 00                	push   $0x0
  8017fa:	6a 00                	push   $0x0
  8017fc:	6a 00                	push   $0x0
  8017fe:	6a 00                	push   $0x0
  801800:	6a 00                	push   $0x0
  801802:	6a 0b                	push   $0xb
  801804:	e8 ce fe ff ff       	call   8016d7 <syscall>
  801809:	83 c4 18             	add    $0x18,%esp
}
  80180c:	c9                   	leave  
  80180d:	c3                   	ret    

0080180e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80180e:	55                   	push   %ebp
  80180f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801811:	6a 00                	push   $0x0
  801813:	6a 00                	push   $0x0
  801815:	6a 00                	push   $0x0
  801817:	ff 75 0c             	pushl  0xc(%ebp)
  80181a:	ff 75 08             	pushl  0x8(%ebp)
  80181d:	6a 0f                	push   $0xf
  80181f:	e8 b3 fe ff ff       	call   8016d7 <syscall>
  801824:	83 c4 18             	add    $0x18,%esp
	return;
  801827:	90                   	nop
}
  801828:	c9                   	leave  
  801829:	c3                   	ret    

0080182a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80182a:	55                   	push   %ebp
  80182b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	ff 75 0c             	pushl  0xc(%ebp)
  801836:	ff 75 08             	pushl  0x8(%ebp)
  801839:	6a 10                	push   $0x10
  80183b:	e8 97 fe ff ff       	call   8016d7 <syscall>
  801840:	83 c4 18             	add    $0x18,%esp
	return ;
  801843:	90                   	nop
}
  801844:	c9                   	leave  
  801845:	c3                   	ret    

00801846 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801846:	55                   	push   %ebp
  801847:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	ff 75 10             	pushl  0x10(%ebp)
  801850:	ff 75 0c             	pushl  0xc(%ebp)
  801853:	ff 75 08             	pushl  0x8(%ebp)
  801856:	6a 11                	push   $0x11
  801858:	e8 7a fe ff ff       	call   8016d7 <syscall>
  80185d:	83 c4 18             	add    $0x18,%esp
	return ;
  801860:	90                   	nop
}
  801861:	c9                   	leave  
  801862:	c3                   	ret    

00801863 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801863:	55                   	push   %ebp
  801864:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	6a 0c                	push   $0xc
  801872:	e8 60 fe ff ff       	call   8016d7 <syscall>
  801877:	83 c4 18             	add    $0x18,%esp
}
  80187a:	c9                   	leave  
  80187b:	c3                   	ret    

0080187c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80187c:	55                   	push   %ebp
  80187d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80187f:	6a 00                	push   $0x0
  801881:	6a 00                	push   $0x0
  801883:	6a 00                	push   $0x0
  801885:	6a 00                	push   $0x0
  801887:	ff 75 08             	pushl  0x8(%ebp)
  80188a:	6a 0d                	push   $0xd
  80188c:	e8 46 fe ff ff       	call   8016d7 <syscall>
  801891:	83 c4 18             	add    $0x18,%esp
}
  801894:	c9                   	leave  
  801895:	c3                   	ret    

00801896 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801896:	55                   	push   %ebp
  801897:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801899:	6a 00                	push   $0x0
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 0e                	push   $0xe
  8018a5:	e8 2d fe ff ff       	call   8016d7 <syscall>
  8018aa:	83 c4 18             	add    $0x18,%esp
}
  8018ad:	90                   	nop
  8018ae:	c9                   	leave  
  8018af:	c3                   	ret    

008018b0 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8018b0:	55                   	push   %ebp
  8018b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 13                	push   $0x13
  8018bf:	e8 13 fe ff ff       	call   8016d7 <syscall>
  8018c4:	83 c4 18             	add    $0x18,%esp
}
  8018c7:	90                   	nop
  8018c8:	c9                   	leave  
  8018c9:	c3                   	ret    

008018ca <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8018ca:	55                   	push   %ebp
  8018cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 14                	push   $0x14
  8018d9:	e8 f9 fd ff ff       	call   8016d7 <syscall>
  8018de:	83 c4 18             	add    $0x18,%esp
}
  8018e1:	90                   	nop
  8018e2:	c9                   	leave  
  8018e3:	c3                   	ret    

008018e4 <sys_cputc>:


void
sys_cputc(const char c)
{
  8018e4:	55                   	push   %ebp
  8018e5:	89 e5                	mov    %esp,%ebp
  8018e7:	83 ec 04             	sub    $0x4,%esp
  8018ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ed:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8018f0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	50                   	push   %eax
  8018fd:	6a 15                	push   $0x15
  8018ff:	e8 d3 fd ff ff       	call   8016d7 <syscall>
  801904:	83 c4 18             	add    $0x18,%esp
}
  801907:	90                   	nop
  801908:	c9                   	leave  
  801909:	c3                   	ret    

0080190a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80190a:	55                   	push   %ebp
  80190b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	6a 16                	push   $0x16
  801919:	e8 b9 fd ff ff       	call   8016d7 <syscall>
  80191e:	83 c4 18             	add    $0x18,%esp
}
  801921:	90                   	nop
  801922:	c9                   	leave  
  801923:	c3                   	ret    

00801924 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801924:	55                   	push   %ebp
  801925:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801927:	8b 45 08             	mov    0x8(%ebp),%eax
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	ff 75 0c             	pushl  0xc(%ebp)
  801933:	50                   	push   %eax
  801934:	6a 17                	push   $0x17
  801936:	e8 9c fd ff ff       	call   8016d7 <syscall>
  80193b:	83 c4 18             	add    $0x18,%esp
}
  80193e:	c9                   	leave  
  80193f:	c3                   	ret    

00801940 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801943:	8b 55 0c             	mov    0xc(%ebp),%edx
  801946:	8b 45 08             	mov    0x8(%ebp),%eax
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	52                   	push   %edx
  801950:	50                   	push   %eax
  801951:	6a 1a                	push   $0x1a
  801953:	e8 7f fd ff ff       	call   8016d7 <syscall>
  801958:	83 c4 18             	add    $0x18,%esp
}
  80195b:	c9                   	leave  
  80195c:	c3                   	ret    

0080195d <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80195d:	55                   	push   %ebp
  80195e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801960:	8b 55 0c             	mov    0xc(%ebp),%edx
  801963:	8b 45 08             	mov    0x8(%ebp),%eax
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	52                   	push   %edx
  80196d:	50                   	push   %eax
  80196e:	6a 18                	push   $0x18
  801970:	e8 62 fd ff ff       	call   8016d7 <syscall>
  801975:	83 c4 18             	add    $0x18,%esp
}
  801978:	90                   	nop
  801979:	c9                   	leave  
  80197a:	c3                   	ret    

0080197b <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80197b:	55                   	push   %ebp
  80197c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80197e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801981:	8b 45 08             	mov    0x8(%ebp),%eax
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	52                   	push   %edx
  80198b:	50                   	push   %eax
  80198c:	6a 19                	push   $0x19
  80198e:	e8 44 fd ff ff       	call   8016d7 <syscall>
  801993:	83 c4 18             	add    $0x18,%esp
}
  801996:	90                   	nop
  801997:	c9                   	leave  
  801998:	c3                   	ret    

00801999 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801999:	55                   	push   %ebp
  80199a:	89 e5                	mov    %esp,%ebp
  80199c:	83 ec 04             	sub    $0x4,%esp
  80199f:	8b 45 10             	mov    0x10(%ebp),%eax
  8019a2:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8019a5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019a8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8019af:	6a 00                	push   $0x0
  8019b1:	51                   	push   %ecx
  8019b2:	52                   	push   %edx
  8019b3:	ff 75 0c             	pushl  0xc(%ebp)
  8019b6:	50                   	push   %eax
  8019b7:	6a 1b                	push   $0x1b
  8019b9:	e8 19 fd ff ff       	call   8016d7 <syscall>
  8019be:	83 c4 18             	add    $0x18,%esp
}
  8019c1:	c9                   	leave  
  8019c2:	c3                   	ret    

008019c3 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8019c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	52                   	push   %edx
  8019d3:	50                   	push   %eax
  8019d4:	6a 1c                	push   $0x1c
  8019d6:	e8 fc fc ff ff       	call   8016d7 <syscall>
  8019db:	83 c4 18             	add    $0x18,%esp
}
  8019de:	c9                   	leave  
  8019df:	c3                   	ret    

008019e0 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8019e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	51                   	push   %ecx
  8019f1:	52                   	push   %edx
  8019f2:	50                   	push   %eax
  8019f3:	6a 1d                	push   $0x1d
  8019f5:	e8 dd fc ff ff       	call   8016d7 <syscall>
  8019fa:	83 c4 18             	add    $0x18,%esp
}
  8019fd:	c9                   	leave  
  8019fe:	c3                   	ret    

008019ff <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8019ff:	55                   	push   %ebp
  801a00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a02:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a05:	8b 45 08             	mov    0x8(%ebp),%eax
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	52                   	push   %edx
  801a0f:	50                   	push   %eax
  801a10:	6a 1e                	push   $0x1e
  801a12:	e8 c0 fc ff ff       	call   8016d7 <syscall>
  801a17:	83 c4 18             	add    $0x18,%esp
}
  801a1a:	c9                   	leave  
  801a1b:	c3                   	ret    

00801a1c <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801a1c:	55                   	push   %ebp
  801a1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	6a 00                	push   $0x0
  801a25:	6a 00                	push   $0x0
  801a27:	6a 00                	push   $0x0
  801a29:	6a 1f                	push   $0x1f
  801a2b:	e8 a7 fc ff ff       	call   8016d7 <syscall>
  801a30:	83 c4 18             	add    $0x18,%esp
}
  801a33:	c9                   	leave  
  801a34:	c3                   	ret    

00801a35 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a35:	55                   	push   %ebp
  801a36:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a38:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3b:	6a 00                	push   $0x0
  801a3d:	ff 75 14             	pushl  0x14(%ebp)
  801a40:	ff 75 10             	pushl  0x10(%ebp)
  801a43:	ff 75 0c             	pushl  0xc(%ebp)
  801a46:	50                   	push   %eax
  801a47:	6a 20                	push   $0x20
  801a49:	e8 89 fc ff ff       	call   8016d7 <syscall>
  801a4e:	83 c4 18             	add    $0x18,%esp
}
  801a51:	c9                   	leave  
  801a52:	c3                   	ret    

00801a53 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801a53:	55                   	push   %ebp
  801a54:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a56:	8b 45 08             	mov    0x8(%ebp),%eax
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	50                   	push   %eax
  801a62:	6a 21                	push   $0x21
  801a64:	e8 6e fc ff ff       	call   8016d7 <syscall>
  801a69:	83 c4 18             	add    $0x18,%esp
}
  801a6c:	90                   	nop
  801a6d:	c9                   	leave  
  801a6e:	c3                   	ret    

00801a6f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a6f:	55                   	push   %ebp
  801a70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a72:	8b 45 08             	mov    0x8(%ebp),%eax
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	50                   	push   %eax
  801a7e:	6a 22                	push   $0x22
  801a80:	e8 52 fc ff ff       	call   8016d7 <syscall>
  801a85:	83 c4 18             	add    $0x18,%esp
}
  801a88:	c9                   	leave  
  801a89:	c3                   	ret    

00801a8a <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a8a:	55                   	push   %ebp
  801a8b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 02                	push   $0x2
  801a99:	e8 39 fc ff ff       	call   8016d7 <syscall>
  801a9e:	83 c4 18             	add    $0x18,%esp
}
  801aa1:	c9                   	leave  
  801aa2:	c3                   	ret    

00801aa3 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801aa3:	55                   	push   %ebp
  801aa4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 03                	push   $0x3
  801ab2:	e8 20 fc ff ff       	call   8016d7 <syscall>
  801ab7:	83 c4 18             	add    $0x18,%esp
}
  801aba:	c9                   	leave  
  801abb:	c3                   	ret    

00801abc <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 04                	push   $0x4
  801acb:	e8 07 fc ff ff       	call   8016d7 <syscall>
  801ad0:	83 c4 18             	add    $0x18,%esp
}
  801ad3:	c9                   	leave  
  801ad4:	c3                   	ret    

00801ad5 <sys_exit_env>:


void sys_exit_env(void)
{
  801ad5:	55                   	push   %ebp
  801ad6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 23                	push   $0x23
  801ae4:	e8 ee fb ff ff       	call   8016d7 <syscall>
  801ae9:	83 c4 18             	add    $0x18,%esp
}
  801aec:	90                   	nop
  801aed:	c9                   	leave  
  801aee:	c3                   	ret    

00801aef <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801aef:	55                   	push   %ebp
  801af0:	89 e5                	mov    %esp,%ebp
  801af2:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801af5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801af8:	8d 50 04             	lea    0x4(%eax),%edx
  801afb:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	52                   	push   %edx
  801b05:	50                   	push   %eax
  801b06:	6a 24                	push   $0x24
  801b08:	e8 ca fb ff ff       	call   8016d7 <syscall>
  801b0d:	83 c4 18             	add    $0x18,%esp
	return result;
  801b10:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b13:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b16:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b19:	89 01                	mov    %eax,(%ecx)
  801b1b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b21:	c9                   	leave  
  801b22:	c2 04 00             	ret    $0x4

00801b25 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b25:	55                   	push   %ebp
  801b26:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	ff 75 10             	pushl  0x10(%ebp)
  801b2f:	ff 75 0c             	pushl  0xc(%ebp)
  801b32:	ff 75 08             	pushl  0x8(%ebp)
  801b35:	6a 12                	push   $0x12
  801b37:	e8 9b fb ff ff       	call   8016d7 <syscall>
  801b3c:	83 c4 18             	add    $0x18,%esp
	return ;
  801b3f:	90                   	nop
}
  801b40:	c9                   	leave  
  801b41:	c3                   	ret    

00801b42 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b42:	55                   	push   %ebp
  801b43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 25                	push   $0x25
  801b51:	e8 81 fb ff ff       	call   8016d7 <syscall>
  801b56:	83 c4 18             	add    $0x18,%esp
}
  801b59:	c9                   	leave  
  801b5a:	c3                   	ret    

00801b5b <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801b5b:	55                   	push   %ebp
  801b5c:	89 e5                	mov    %esp,%ebp
  801b5e:	83 ec 04             	sub    $0x4,%esp
  801b61:	8b 45 08             	mov    0x8(%ebp),%eax
  801b64:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b67:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	50                   	push   %eax
  801b74:	6a 26                	push   $0x26
  801b76:	e8 5c fb ff ff       	call   8016d7 <syscall>
  801b7b:	83 c4 18             	add    $0x18,%esp
	return ;
  801b7e:	90                   	nop
}
  801b7f:	c9                   	leave  
  801b80:	c3                   	ret    

00801b81 <rsttst>:
void rsttst()
{
  801b81:	55                   	push   %ebp
  801b82:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b84:	6a 00                	push   $0x0
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 28                	push   $0x28
  801b90:	e8 42 fb ff ff       	call   8016d7 <syscall>
  801b95:	83 c4 18             	add    $0x18,%esp
	return ;
  801b98:	90                   	nop
}
  801b99:	c9                   	leave  
  801b9a:	c3                   	ret    

00801b9b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b9b:	55                   	push   %ebp
  801b9c:	89 e5                	mov    %esp,%ebp
  801b9e:	83 ec 04             	sub    $0x4,%esp
  801ba1:	8b 45 14             	mov    0x14(%ebp),%eax
  801ba4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ba7:	8b 55 18             	mov    0x18(%ebp),%edx
  801baa:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bae:	52                   	push   %edx
  801baf:	50                   	push   %eax
  801bb0:	ff 75 10             	pushl  0x10(%ebp)
  801bb3:	ff 75 0c             	pushl  0xc(%ebp)
  801bb6:	ff 75 08             	pushl  0x8(%ebp)
  801bb9:	6a 27                	push   $0x27
  801bbb:	e8 17 fb ff ff       	call   8016d7 <syscall>
  801bc0:	83 c4 18             	add    $0x18,%esp
	return ;
  801bc3:	90                   	nop
}
  801bc4:	c9                   	leave  
  801bc5:	c3                   	ret    

00801bc6 <chktst>:
void chktst(uint32 n)
{
  801bc6:	55                   	push   %ebp
  801bc7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	ff 75 08             	pushl  0x8(%ebp)
  801bd4:	6a 29                	push   $0x29
  801bd6:	e8 fc fa ff ff       	call   8016d7 <syscall>
  801bdb:	83 c4 18             	add    $0x18,%esp
	return ;
  801bde:	90                   	nop
}
  801bdf:	c9                   	leave  
  801be0:	c3                   	ret    

00801be1 <inctst>:

void inctst()
{
  801be1:	55                   	push   %ebp
  801be2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 2a                	push   $0x2a
  801bf0:	e8 e2 fa ff ff       	call   8016d7 <syscall>
  801bf5:	83 c4 18             	add    $0x18,%esp
	return ;
  801bf8:	90                   	nop
}
  801bf9:	c9                   	leave  
  801bfa:	c3                   	ret    

00801bfb <gettst>:
uint32 gettst()
{
  801bfb:	55                   	push   %ebp
  801bfc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	6a 2b                	push   $0x2b
  801c0a:	e8 c8 fa ff ff       	call   8016d7 <syscall>
  801c0f:	83 c4 18             	add    $0x18,%esp
}
  801c12:	c9                   	leave  
  801c13:	c3                   	ret    

00801c14 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c14:	55                   	push   %ebp
  801c15:	89 e5                	mov    %esp,%ebp
  801c17:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 2c                	push   $0x2c
  801c26:	e8 ac fa ff ff       	call   8016d7 <syscall>
  801c2b:	83 c4 18             	add    $0x18,%esp
  801c2e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c31:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c35:	75 07                	jne    801c3e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c37:	b8 01 00 00 00       	mov    $0x1,%eax
  801c3c:	eb 05                	jmp    801c43 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c43:	c9                   	leave  
  801c44:	c3                   	ret    

00801c45 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c45:	55                   	push   %ebp
  801c46:	89 e5                	mov    %esp,%ebp
  801c48:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 2c                	push   $0x2c
  801c57:	e8 7b fa ff ff       	call   8016d7 <syscall>
  801c5c:	83 c4 18             	add    $0x18,%esp
  801c5f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c62:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c66:	75 07                	jne    801c6f <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c68:	b8 01 00 00 00       	mov    $0x1,%eax
  801c6d:	eb 05                	jmp    801c74 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c74:	c9                   	leave  
  801c75:	c3                   	ret    

00801c76 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c76:	55                   	push   %ebp
  801c77:	89 e5                	mov    %esp,%ebp
  801c79:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	6a 00                	push   $0x0
  801c84:	6a 00                	push   $0x0
  801c86:	6a 2c                	push   $0x2c
  801c88:	e8 4a fa ff ff       	call   8016d7 <syscall>
  801c8d:	83 c4 18             	add    $0x18,%esp
  801c90:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c93:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c97:	75 07                	jne    801ca0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c99:	b8 01 00 00 00       	mov    $0x1,%eax
  801c9e:	eb 05                	jmp    801ca5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ca0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ca5:	c9                   	leave  
  801ca6:	c3                   	ret    

00801ca7 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801ca7:	55                   	push   %ebp
  801ca8:	89 e5                	mov    %esp,%ebp
  801caa:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 2c                	push   $0x2c
  801cb9:	e8 19 fa ff ff       	call   8016d7 <syscall>
  801cbe:	83 c4 18             	add    $0x18,%esp
  801cc1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801cc4:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801cc8:	75 07                	jne    801cd1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801cca:	b8 01 00 00 00       	mov    $0x1,%eax
  801ccf:	eb 05                	jmp    801cd6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801cd1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cd6:	c9                   	leave  
  801cd7:	c3                   	ret    

00801cd8 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801cd8:	55                   	push   %ebp
  801cd9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801cdb:	6a 00                	push   $0x0
  801cdd:	6a 00                	push   $0x0
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	ff 75 08             	pushl  0x8(%ebp)
  801ce6:	6a 2d                	push   $0x2d
  801ce8:	e8 ea f9 ff ff       	call   8016d7 <syscall>
  801ced:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf0:	90                   	nop
}
  801cf1:	c9                   	leave  
  801cf2:	c3                   	ret    

00801cf3 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801cf3:	55                   	push   %ebp
  801cf4:	89 e5                	mov    %esp,%ebp
  801cf6:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801cf7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cfa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cfd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d00:	8b 45 08             	mov    0x8(%ebp),%eax
  801d03:	6a 00                	push   $0x0
  801d05:	53                   	push   %ebx
  801d06:	51                   	push   %ecx
  801d07:	52                   	push   %edx
  801d08:	50                   	push   %eax
  801d09:	6a 2e                	push   $0x2e
  801d0b:	e8 c7 f9 ff ff       	call   8016d7 <syscall>
  801d10:	83 c4 18             	add    $0x18,%esp
}
  801d13:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d16:	c9                   	leave  
  801d17:	c3                   	ret    

00801d18 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d18:	55                   	push   %ebp
  801d19:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	6a 00                	push   $0x0
  801d27:	52                   	push   %edx
  801d28:	50                   	push   %eax
  801d29:	6a 2f                	push   $0x2f
  801d2b:	e8 a7 f9 ff ff       	call   8016d7 <syscall>
  801d30:	83 c4 18             	add    $0x18,%esp
}
  801d33:	c9                   	leave  
  801d34:	c3                   	ret    

00801d35 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801d35:	55                   	push   %ebp
  801d36:	89 e5                	mov    %esp,%ebp
  801d38:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801d3b:	83 ec 0c             	sub    $0xc,%esp
  801d3e:	68 c8 3d 80 00       	push   $0x803dc8
  801d43:	e8 1e e8 ff ff       	call   800566 <cprintf>
  801d48:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801d4b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801d52:	83 ec 0c             	sub    $0xc,%esp
  801d55:	68 f4 3d 80 00       	push   $0x803df4
  801d5a:	e8 07 e8 ff ff       	call   800566 <cprintf>
  801d5f:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801d62:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d66:	a1 38 51 80 00       	mov    0x805138,%eax
  801d6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d6e:	eb 56                	jmp    801dc6 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d70:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d74:	74 1c                	je     801d92 <print_mem_block_lists+0x5d>
  801d76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d79:	8b 50 08             	mov    0x8(%eax),%edx
  801d7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d7f:	8b 48 08             	mov    0x8(%eax),%ecx
  801d82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d85:	8b 40 0c             	mov    0xc(%eax),%eax
  801d88:	01 c8                	add    %ecx,%eax
  801d8a:	39 c2                	cmp    %eax,%edx
  801d8c:	73 04                	jae    801d92 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801d8e:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d95:	8b 50 08             	mov    0x8(%eax),%edx
  801d98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d9b:	8b 40 0c             	mov    0xc(%eax),%eax
  801d9e:	01 c2                	add    %eax,%edx
  801da0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da3:	8b 40 08             	mov    0x8(%eax),%eax
  801da6:	83 ec 04             	sub    $0x4,%esp
  801da9:	52                   	push   %edx
  801daa:	50                   	push   %eax
  801dab:	68 09 3e 80 00       	push   $0x803e09
  801db0:	e8 b1 e7 ff ff       	call   800566 <cprintf>
  801db5:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801db8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801dbe:	a1 40 51 80 00       	mov    0x805140,%eax
  801dc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dc6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dca:	74 07                	je     801dd3 <print_mem_block_lists+0x9e>
  801dcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dcf:	8b 00                	mov    (%eax),%eax
  801dd1:	eb 05                	jmp    801dd8 <print_mem_block_lists+0xa3>
  801dd3:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd8:	a3 40 51 80 00       	mov    %eax,0x805140
  801ddd:	a1 40 51 80 00       	mov    0x805140,%eax
  801de2:	85 c0                	test   %eax,%eax
  801de4:	75 8a                	jne    801d70 <print_mem_block_lists+0x3b>
  801de6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dea:	75 84                	jne    801d70 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801dec:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801df0:	75 10                	jne    801e02 <print_mem_block_lists+0xcd>
  801df2:	83 ec 0c             	sub    $0xc,%esp
  801df5:	68 18 3e 80 00       	push   $0x803e18
  801dfa:	e8 67 e7 ff ff       	call   800566 <cprintf>
  801dff:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801e02:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801e09:	83 ec 0c             	sub    $0xc,%esp
  801e0c:	68 3c 3e 80 00       	push   $0x803e3c
  801e11:	e8 50 e7 ff ff       	call   800566 <cprintf>
  801e16:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801e19:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e1d:	a1 40 50 80 00       	mov    0x805040,%eax
  801e22:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e25:	eb 56                	jmp    801e7d <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e27:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e2b:	74 1c                	je     801e49 <print_mem_block_lists+0x114>
  801e2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e30:	8b 50 08             	mov    0x8(%eax),%edx
  801e33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e36:	8b 48 08             	mov    0x8(%eax),%ecx
  801e39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e3c:	8b 40 0c             	mov    0xc(%eax),%eax
  801e3f:	01 c8                	add    %ecx,%eax
  801e41:	39 c2                	cmp    %eax,%edx
  801e43:	73 04                	jae    801e49 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801e45:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e4c:	8b 50 08             	mov    0x8(%eax),%edx
  801e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e52:	8b 40 0c             	mov    0xc(%eax),%eax
  801e55:	01 c2                	add    %eax,%edx
  801e57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e5a:	8b 40 08             	mov    0x8(%eax),%eax
  801e5d:	83 ec 04             	sub    $0x4,%esp
  801e60:	52                   	push   %edx
  801e61:	50                   	push   %eax
  801e62:	68 09 3e 80 00       	push   $0x803e09
  801e67:	e8 fa e6 ff ff       	call   800566 <cprintf>
  801e6c:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e72:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e75:	a1 48 50 80 00       	mov    0x805048,%eax
  801e7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e7d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e81:	74 07                	je     801e8a <print_mem_block_lists+0x155>
  801e83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e86:	8b 00                	mov    (%eax),%eax
  801e88:	eb 05                	jmp    801e8f <print_mem_block_lists+0x15a>
  801e8a:	b8 00 00 00 00       	mov    $0x0,%eax
  801e8f:	a3 48 50 80 00       	mov    %eax,0x805048
  801e94:	a1 48 50 80 00       	mov    0x805048,%eax
  801e99:	85 c0                	test   %eax,%eax
  801e9b:	75 8a                	jne    801e27 <print_mem_block_lists+0xf2>
  801e9d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ea1:	75 84                	jne    801e27 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801ea3:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801ea7:	75 10                	jne    801eb9 <print_mem_block_lists+0x184>
  801ea9:	83 ec 0c             	sub    $0xc,%esp
  801eac:	68 54 3e 80 00       	push   $0x803e54
  801eb1:	e8 b0 e6 ff ff       	call   800566 <cprintf>
  801eb6:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801eb9:	83 ec 0c             	sub    $0xc,%esp
  801ebc:	68 c8 3d 80 00       	push   $0x803dc8
  801ec1:	e8 a0 e6 ff ff       	call   800566 <cprintf>
  801ec6:	83 c4 10             	add    $0x10,%esp

}
  801ec9:	90                   	nop
  801eca:	c9                   	leave  
  801ecb:	c3                   	ret    

00801ecc <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801ecc:	55                   	push   %ebp
  801ecd:	89 e5                	mov    %esp,%ebp
  801ecf:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801ed2:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801ed9:	00 00 00 
  801edc:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801ee3:	00 00 00 
  801ee6:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801eed:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801ef0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801ef7:	e9 9e 00 00 00       	jmp    801f9a <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801efc:	a1 50 50 80 00       	mov    0x805050,%eax
  801f01:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f04:	c1 e2 04             	shl    $0x4,%edx
  801f07:	01 d0                	add    %edx,%eax
  801f09:	85 c0                	test   %eax,%eax
  801f0b:	75 14                	jne    801f21 <initialize_MemBlocksList+0x55>
  801f0d:	83 ec 04             	sub    $0x4,%esp
  801f10:	68 7c 3e 80 00       	push   $0x803e7c
  801f15:	6a 46                	push   $0x46
  801f17:	68 9f 3e 80 00       	push   $0x803e9f
  801f1c:	e8 64 14 00 00       	call   803385 <_panic>
  801f21:	a1 50 50 80 00       	mov    0x805050,%eax
  801f26:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f29:	c1 e2 04             	shl    $0x4,%edx
  801f2c:	01 d0                	add    %edx,%eax
  801f2e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801f34:	89 10                	mov    %edx,(%eax)
  801f36:	8b 00                	mov    (%eax),%eax
  801f38:	85 c0                	test   %eax,%eax
  801f3a:	74 18                	je     801f54 <initialize_MemBlocksList+0x88>
  801f3c:	a1 48 51 80 00       	mov    0x805148,%eax
  801f41:	8b 15 50 50 80 00    	mov    0x805050,%edx
  801f47:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801f4a:	c1 e1 04             	shl    $0x4,%ecx
  801f4d:	01 ca                	add    %ecx,%edx
  801f4f:	89 50 04             	mov    %edx,0x4(%eax)
  801f52:	eb 12                	jmp    801f66 <initialize_MemBlocksList+0x9a>
  801f54:	a1 50 50 80 00       	mov    0x805050,%eax
  801f59:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f5c:	c1 e2 04             	shl    $0x4,%edx
  801f5f:	01 d0                	add    %edx,%eax
  801f61:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801f66:	a1 50 50 80 00       	mov    0x805050,%eax
  801f6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f6e:	c1 e2 04             	shl    $0x4,%edx
  801f71:	01 d0                	add    %edx,%eax
  801f73:	a3 48 51 80 00       	mov    %eax,0x805148
  801f78:	a1 50 50 80 00       	mov    0x805050,%eax
  801f7d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f80:	c1 e2 04             	shl    $0x4,%edx
  801f83:	01 d0                	add    %edx,%eax
  801f85:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f8c:	a1 54 51 80 00       	mov    0x805154,%eax
  801f91:	40                   	inc    %eax
  801f92:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801f97:	ff 45 f4             	incl   -0xc(%ebp)
  801f9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9d:	3b 45 08             	cmp    0x8(%ebp),%eax
  801fa0:	0f 82 56 ff ff ff    	jb     801efc <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801fa6:	90                   	nop
  801fa7:	c9                   	leave  
  801fa8:	c3                   	ret    

00801fa9 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801fa9:	55                   	push   %ebp
  801faa:	89 e5                	mov    %esp,%ebp
  801fac:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801faf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb2:	8b 00                	mov    (%eax),%eax
  801fb4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801fb7:	eb 19                	jmp    801fd2 <find_block+0x29>
	{
		if(va==point->sva)
  801fb9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fbc:	8b 40 08             	mov    0x8(%eax),%eax
  801fbf:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801fc2:	75 05                	jne    801fc9 <find_block+0x20>
		   return point;
  801fc4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fc7:	eb 36                	jmp    801fff <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcc:	8b 40 08             	mov    0x8(%eax),%eax
  801fcf:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801fd2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801fd6:	74 07                	je     801fdf <find_block+0x36>
  801fd8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fdb:	8b 00                	mov    (%eax),%eax
  801fdd:	eb 05                	jmp    801fe4 <find_block+0x3b>
  801fdf:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe4:	8b 55 08             	mov    0x8(%ebp),%edx
  801fe7:	89 42 08             	mov    %eax,0x8(%edx)
  801fea:	8b 45 08             	mov    0x8(%ebp),%eax
  801fed:	8b 40 08             	mov    0x8(%eax),%eax
  801ff0:	85 c0                	test   %eax,%eax
  801ff2:	75 c5                	jne    801fb9 <find_block+0x10>
  801ff4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801ff8:	75 bf                	jne    801fb9 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801ffa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fff:	c9                   	leave  
  802000:	c3                   	ret    

00802001 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802001:	55                   	push   %ebp
  802002:	89 e5                	mov    %esp,%ebp
  802004:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802007:	a1 40 50 80 00       	mov    0x805040,%eax
  80200c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  80200f:	a1 44 50 80 00       	mov    0x805044,%eax
  802014:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802017:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80201a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80201d:	74 24                	je     802043 <insert_sorted_allocList+0x42>
  80201f:	8b 45 08             	mov    0x8(%ebp),%eax
  802022:	8b 50 08             	mov    0x8(%eax),%edx
  802025:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802028:	8b 40 08             	mov    0x8(%eax),%eax
  80202b:	39 c2                	cmp    %eax,%edx
  80202d:	76 14                	jbe    802043 <insert_sorted_allocList+0x42>
  80202f:	8b 45 08             	mov    0x8(%ebp),%eax
  802032:	8b 50 08             	mov    0x8(%eax),%edx
  802035:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802038:	8b 40 08             	mov    0x8(%eax),%eax
  80203b:	39 c2                	cmp    %eax,%edx
  80203d:	0f 82 60 01 00 00    	jb     8021a3 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802043:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802047:	75 65                	jne    8020ae <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802049:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80204d:	75 14                	jne    802063 <insert_sorted_allocList+0x62>
  80204f:	83 ec 04             	sub    $0x4,%esp
  802052:	68 7c 3e 80 00       	push   $0x803e7c
  802057:	6a 6b                	push   $0x6b
  802059:	68 9f 3e 80 00       	push   $0x803e9f
  80205e:	e8 22 13 00 00       	call   803385 <_panic>
  802063:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802069:	8b 45 08             	mov    0x8(%ebp),%eax
  80206c:	89 10                	mov    %edx,(%eax)
  80206e:	8b 45 08             	mov    0x8(%ebp),%eax
  802071:	8b 00                	mov    (%eax),%eax
  802073:	85 c0                	test   %eax,%eax
  802075:	74 0d                	je     802084 <insert_sorted_allocList+0x83>
  802077:	a1 40 50 80 00       	mov    0x805040,%eax
  80207c:	8b 55 08             	mov    0x8(%ebp),%edx
  80207f:	89 50 04             	mov    %edx,0x4(%eax)
  802082:	eb 08                	jmp    80208c <insert_sorted_allocList+0x8b>
  802084:	8b 45 08             	mov    0x8(%ebp),%eax
  802087:	a3 44 50 80 00       	mov    %eax,0x805044
  80208c:	8b 45 08             	mov    0x8(%ebp),%eax
  80208f:	a3 40 50 80 00       	mov    %eax,0x805040
  802094:	8b 45 08             	mov    0x8(%ebp),%eax
  802097:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80209e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8020a3:	40                   	inc    %eax
  8020a4:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8020a9:	e9 dc 01 00 00       	jmp    80228a <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8020ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b1:	8b 50 08             	mov    0x8(%eax),%edx
  8020b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020b7:	8b 40 08             	mov    0x8(%eax),%eax
  8020ba:	39 c2                	cmp    %eax,%edx
  8020bc:	77 6c                	ja     80212a <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8020be:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020c2:	74 06                	je     8020ca <insert_sorted_allocList+0xc9>
  8020c4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020c8:	75 14                	jne    8020de <insert_sorted_allocList+0xdd>
  8020ca:	83 ec 04             	sub    $0x4,%esp
  8020cd:	68 b8 3e 80 00       	push   $0x803eb8
  8020d2:	6a 6f                	push   $0x6f
  8020d4:	68 9f 3e 80 00       	push   $0x803e9f
  8020d9:	e8 a7 12 00 00       	call   803385 <_panic>
  8020de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020e1:	8b 50 04             	mov    0x4(%eax),%edx
  8020e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e7:	89 50 04             	mov    %edx,0x4(%eax)
  8020ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ed:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020f0:	89 10                	mov    %edx,(%eax)
  8020f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020f5:	8b 40 04             	mov    0x4(%eax),%eax
  8020f8:	85 c0                	test   %eax,%eax
  8020fa:	74 0d                	je     802109 <insert_sorted_allocList+0x108>
  8020fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ff:	8b 40 04             	mov    0x4(%eax),%eax
  802102:	8b 55 08             	mov    0x8(%ebp),%edx
  802105:	89 10                	mov    %edx,(%eax)
  802107:	eb 08                	jmp    802111 <insert_sorted_allocList+0x110>
  802109:	8b 45 08             	mov    0x8(%ebp),%eax
  80210c:	a3 40 50 80 00       	mov    %eax,0x805040
  802111:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802114:	8b 55 08             	mov    0x8(%ebp),%edx
  802117:	89 50 04             	mov    %edx,0x4(%eax)
  80211a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80211f:	40                   	inc    %eax
  802120:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802125:	e9 60 01 00 00       	jmp    80228a <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80212a:	8b 45 08             	mov    0x8(%ebp),%eax
  80212d:	8b 50 08             	mov    0x8(%eax),%edx
  802130:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802133:	8b 40 08             	mov    0x8(%eax),%eax
  802136:	39 c2                	cmp    %eax,%edx
  802138:	0f 82 4c 01 00 00    	jb     80228a <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80213e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802142:	75 14                	jne    802158 <insert_sorted_allocList+0x157>
  802144:	83 ec 04             	sub    $0x4,%esp
  802147:	68 f0 3e 80 00       	push   $0x803ef0
  80214c:	6a 73                	push   $0x73
  80214e:	68 9f 3e 80 00       	push   $0x803e9f
  802153:	e8 2d 12 00 00       	call   803385 <_panic>
  802158:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80215e:	8b 45 08             	mov    0x8(%ebp),%eax
  802161:	89 50 04             	mov    %edx,0x4(%eax)
  802164:	8b 45 08             	mov    0x8(%ebp),%eax
  802167:	8b 40 04             	mov    0x4(%eax),%eax
  80216a:	85 c0                	test   %eax,%eax
  80216c:	74 0c                	je     80217a <insert_sorted_allocList+0x179>
  80216e:	a1 44 50 80 00       	mov    0x805044,%eax
  802173:	8b 55 08             	mov    0x8(%ebp),%edx
  802176:	89 10                	mov    %edx,(%eax)
  802178:	eb 08                	jmp    802182 <insert_sorted_allocList+0x181>
  80217a:	8b 45 08             	mov    0x8(%ebp),%eax
  80217d:	a3 40 50 80 00       	mov    %eax,0x805040
  802182:	8b 45 08             	mov    0x8(%ebp),%eax
  802185:	a3 44 50 80 00       	mov    %eax,0x805044
  80218a:	8b 45 08             	mov    0x8(%ebp),%eax
  80218d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802193:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802198:	40                   	inc    %eax
  802199:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80219e:	e9 e7 00 00 00       	jmp    80228a <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8021a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8021a9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8021b0:	a1 40 50 80 00       	mov    0x805040,%eax
  8021b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021b8:	e9 9d 00 00 00       	jmp    80225a <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8021bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c0:	8b 00                	mov    (%eax),%eax
  8021c2:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8021c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c8:	8b 50 08             	mov    0x8(%eax),%edx
  8021cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ce:	8b 40 08             	mov    0x8(%eax),%eax
  8021d1:	39 c2                	cmp    %eax,%edx
  8021d3:	76 7d                	jbe    802252 <insert_sorted_allocList+0x251>
  8021d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d8:	8b 50 08             	mov    0x8(%eax),%edx
  8021db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021de:	8b 40 08             	mov    0x8(%eax),%eax
  8021e1:	39 c2                	cmp    %eax,%edx
  8021e3:	73 6d                	jae    802252 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8021e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021e9:	74 06                	je     8021f1 <insert_sorted_allocList+0x1f0>
  8021eb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021ef:	75 14                	jne    802205 <insert_sorted_allocList+0x204>
  8021f1:	83 ec 04             	sub    $0x4,%esp
  8021f4:	68 14 3f 80 00       	push   $0x803f14
  8021f9:	6a 7f                	push   $0x7f
  8021fb:	68 9f 3e 80 00       	push   $0x803e9f
  802200:	e8 80 11 00 00       	call   803385 <_panic>
  802205:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802208:	8b 10                	mov    (%eax),%edx
  80220a:	8b 45 08             	mov    0x8(%ebp),%eax
  80220d:	89 10                	mov    %edx,(%eax)
  80220f:	8b 45 08             	mov    0x8(%ebp),%eax
  802212:	8b 00                	mov    (%eax),%eax
  802214:	85 c0                	test   %eax,%eax
  802216:	74 0b                	je     802223 <insert_sorted_allocList+0x222>
  802218:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221b:	8b 00                	mov    (%eax),%eax
  80221d:	8b 55 08             	mov    0x8(%ebp),%edx
  802220:	89 50 04             	mov    %edx,0x4(%eax)
  802223:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802226:	8b 55 08             	mov    0x8(%ebp),%edx
  802229:	89 10                	mov    %edx,(%eax)
  80222b:	8b 45 08             	mov    0x8(%ebp),%eax
  80222e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802231:	89 50 04             	mov    %edx,0x4(%eax)
  802234:	8b 45 08             	mov    0x8(%ebp),%eax
  802237:	8b 00                	mov    (%eax),%eax
  802239:	85 c0                	test   %eax,%eax
  80223b:	75 08                	jne    802245 <insert_sorted_allocList+0x244>
  80223d:	8b 45 08             	mov    0x8(%ebp),%eax
  802240:	a3 44 50 80 00       	mov    %eax,0x805044
  802245:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80224a:	40                   	inc    %eax
  80224b:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802250:	eb 39                	jmp    80228b <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802252:	a1 48 50 80 00       	mov    0x805048,%eax
  802257:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80225a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80225e:	74 07                	je     802267 <insert_sorted_allocList+0x266>
  802260:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802263:	8b 00                	mov    (%eax),%eax
  802265:	eb 05                	jmp    80226c <insert_sorted_allocList+0x26b>
  802267:	b8 00 00 00 00       	mov    $0x0,%eax
  80226c:	a3 48 50 80 00       	mov    %eax,0x805048
  802271:	a1 48 50 80 00       	mov    0x805048,%eax
  802276:	85 c0                	test   %eax,%eax
  802278:	0f 85 3f ff ff ff    	jne    8021bd <insert_sorted_allocList+0x1bc>
  80227e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802282:	0f 85 35 ff ff ff    	jne    8021bd <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802288:	eb 01                	jmp    80228b <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80228a:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80228b:	90                   	nop
  80228c:	c9                   	leave  
  80228d:	c3                   	ret    

0080228e <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80228e:	55                   	push   %ebp
  80228f:	89 e5                	mov    %esp,%ebp
  802291:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802294:	a1 38 51 80 00       	mov    0x805138,%eax
  802299:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80229c:	e9 85 01 00 00       	jmp    802426 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8022a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8022a7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022aa:	0f 82 6e 01 00 00    	jb     80241e <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8022b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8022b6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022b9:	0f 85 8a 00 00 00    	jne    802349 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8022bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022c3:	75 17                	jne    8022dc <alloc_block_FF+0x4e>
  8022c5:	83 ec 04             	sub    $0x4,%esp
  8022c8:	68 48 3f 80 00       	push   $0x803f48
  8022cd:	68 93 00 00 00       	push   $0x93
  8022d2:	68 9f 3e 80 00       	push   $0x803e9f
  8022d7:	e8 a9 10 00 00       	call   803385 <_panic>
  8022dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022df:	8b 00                	mov    (%eax),%eax
  8022e1:	85 c0                	test   %eax,%eax
  8022e3:	74 10                	je     8022f5 <alloc_block_FF+0x67>
  8022e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e8:	8b 00                	mov    (%eax),%eax
  8022ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022ed:	8b 52 04             	mov    0x4(%edx),%edx
  8022f0:	89 50 04             	mov    %edx,0x4(%eax)
  8022f3:	eb 0b                	jmp    802300 <alloc_block_FF+0x72>
  8022f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f8:	8b 40 04             	mov    0x4(%eax),%eax
  8022fb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802300:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802303:	8b 40 04             	mov    0x4(%eax),%eax
  802306:	85 c0                	test   %eax,%eax
  802308:	74 0f                	je     802319 <alloc_block_FF+0x8b>
  80230a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230d:	8b 40 04             	mov    0x4(%eax),%eax
  802310:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802313:	8b 12                	mov    (%edx),%edx
  802315:	89 10                	mov    %edx,(%eax)
  802317:	eb 0a                	jmp    802323 <alloc_block_FF+0x95>
  802319:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231c:	8b 00                	mov    (%eax),%eax
  80231e:	a3 38 51 80 00       	mov    %eax,0x805138
  802323:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802326:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80232c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802336:	a1 44 51 80 00       	mov    0x805144,%eax
  80233b:	48                   	dec    %eax
  80233c:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802341:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802344:	e9 10 01 00 00       	jmp    802459 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802349:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234c:	8b 40 0c             	mov    0xc(%eax),%eax
  80234f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802352:	0f 86 c6 00 00 00    	jbe    80241e <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802358:	a1 48 51 80 00       	mov    0x805148,%eax
  80235d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802360:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802363:	8b 50 08             	mov    0x8(%eax),%edx
  802366:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802369:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  80236c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80236f:	8b 55 08             	mov    0x8(%ebp),%edx
  802372:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802375:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802379:	75 17                	jne    802392 <alloc_block_FF+0x104>
  80237b:	83 ec 04             	sub    $0x4,%esp
  80237e:	68 48 3f 80 00       	push   $0x803f48
  802383:	68 9b 00 00 00       	push   $0x9b
  802388:	68 9f 3e 80 00       	push   $0x803e9f
  80238d:	e8 f3 0f 00 00       	call   803385 <_panic>
  802392:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802395:	8b 00                	mov    (%eax),%eax
  802397:	85 c0                	test   %eax,%eax
  802399:	74 10                	je     8023ab <alloc_block_FF+0x11d>
  80239b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80239e:	8b 00                	mov    (%eax),%eax
  8023a0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023a3:	8b 52 04             	mov    0x4(%edx),%edx
  8023a6:	89 50 04             	mov    %edx,0x4(%eax)
  8023a9:	eb 0b                	jmp    8023b6 <alloc_block_FF+0x128>
  8023ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ae:	8b 40 04             	mov    0x4(%eax),%eax
  8023b1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8023b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b9:	8b 40 04             	mov    0x4(%eax),%eax
  8023bc:	85 c0                	test   %eax,%eax
  8023be:	74 0f                	je     8023cf <alloc_block_FF+0x141>
  8023c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c3:	8b 40 04             	mov    0x4(%eax),%eax
  8023c6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023c9:	8b 12                	mov    (%edx),%edx
  8023cb:	89 10                	mov    %edx,(%eax)
  8023cd:	eb 0a                	jmp    8023d9 <alloc_block_FF+0x14b>
  8023cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d2:	8b 00                	mov    (%eax),%eax
  8023d4:	a3 48 51 80 00       	mov    %eax,0x805148
  8023d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023ec:	a1 54 51 80 00       	mov    0x805154,%eax
  8023f1:	48                   	dec    %eax
  8023f2:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8023f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fa:	8b 50 08             	mov    0x8(%eax),%edx
  8023fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802400:	01 c2                	add    %eax,%edx
  802402:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802405:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802408:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240b:	8b 40 0c             	mov    0xc(%eax),%eax
  80240e:	2b 45 08             	sub    0x8(%ebp),%eax
  802411:	89 c2                	mov    %eax,%edx
  802413:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802416:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802419:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80241c:	eb 3b                	jmp    802459 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80241e:	a1 40 51 80 00       	mov    0x805140,%eax
  802423:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802426:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80242a:	74 07                	je     802433 <alloc_block_FF+0x1a5>
  80242c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242f:	8b 00                	mov    (%eax),%eax
  802431:	eb 05                	jmp    802438 <alloc_block_FF+0x1aa>
  802433:	b8 00 00 00 00       	mov    $0x0,%eax
  802438:	a3 40 51 80 00       	mov    %eax,0x805140
  80243d:	a1 40 51 80 00       	mov    0x805140,%eax
  802442:	85 c0                	test   %eax,%eax
  802444:	0f 85 57 fe ff ff    	jne    8022a1 <alloc_block_FF+0x13>
  80244a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80244e:	0f 85 4d fe ff ff    	jne    8022a1 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802454:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802459:	c9                   	leave  
  80245a:	c3                   	ret    

0080245b <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80245b:	55                   	push   %ebp
  80245c:	89 e5                	mov    %esp,%ebp
  80245e:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802461:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802468:	a1 38 51 80 00       	mov    0x805138,%eax
  80246d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802470:	e9 df 00 00 00       	jmp    802554 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802475:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802478:	8b 40 0c             	mov    0xc(%eax),%eax
  80247b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80247e:	0f 82 c8 00 00 00    	jb     80254c <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802484:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802487:	8b 40 0c             	mov    0xc(%eax),%eax
  80248a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80248d:	0f 85 8a 00 00 00    	jne    80251d <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802493:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802497:	75 17                	jne    8024b0 <alloc_block_BF+0x55>
  802499:	83 ec 04             	sub    $0x4,%esp
  80249c:	68 48 3f 80 00       	push   $0x803f48
  8024a1:	68 b7 00 00 00       	push   $0xb7
  8024a6:	68 9f 3e 80 00       	push   $0x803e9f
  8024ab:	e8 d5 0e 00 00       	call   803385 <_panic>
  8024b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b3:	8b 00                	mov    (%eax),%eax
  8024b5:	85 c0                	test   %eax,%eax
  8024b7:	74 10                	je     8024c9 <alloc_block_BF+0x6e>
  8024b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bc:	8b 00                	mov    (%eax),%eax
  8024be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024c1:	8b 52 04             	mov    0x4(%edx),%edx
  8024c4:	89 50 04             	mov    %edx,0x4(%eax)
  8024c7:	eb 0b                	jmp    8024d4 <alloc_block_BF+0x79>
  8024c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cc:	8b 40 04             	mov    0x4(%eax),%eax
  8024cf:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8024d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d7:	8b 40 04             	mov    0x4(%eax),%eax
  8024da:	85 c0                	test   %eax,%eax
  8024dc:	74 0f                	je     8024ed <alloc_block_BF+0x92>
  8024de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e1:	8b 40 04             	mov    0x4(%eax),%eax
  8024e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024e7:	8b 12                	mov    (%edx),%edx
  8024e9:	89 10                	mov    %edx,(%eax)
  8024eb:	eb 0a                	jmp    8024f7 <alloc_block_BF+0x9c>
  8024ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f0:	8b 00                	mov    (%eax),%eax
  8024f2:	a3 38 51 80 00       	mov    %eax,0x805138
  8024f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802500:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802503:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80250a:	a1 44 51 80 00       	mov    0x805144,%eax
  80250f:	48                   	dec    %eax
  802510:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802515:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802518:	e9 4d 01 00 00       	jmp    80266a <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  80251d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802520:	8b 40 0c             	mov    0xc(%eax),%eax
  802523:	3b 45 08             	cmp    0x8(%ebp),%eax
  802526:	76 24                	jbe    80254c <alloc_block_BF+0xf1>
  802528:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252b:	8b 40 0c             	mov    0xc(%eax),%eax
  80252e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802531:	73 19                	jae    80254c <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802533:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  80253a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253d:	8b 40 0c             	mov    0xc(%eax),%eax
  802540:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802543:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802546:	8b 40 08             	mov    0x8(%eax),%eax
  802549:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80254c:	a1 40 51 80 00       	mov    0x805140,%eax
  802551:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802554:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802558:	74 07                	je     802561 <alloc_block_BF+0x106>
  80255a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255d:	8b 00                	mov    (%eax),%eax
  80255f:	eb 05                	jmp    802566 <alloc_block_BF+0x10b>
  802561:	b8 00 00 00 00       	mov    $0x0,%eax
  802566:	a3 40 51 80 00       	mov    %eax,0x805140
  80256b:	a1 40 51 80 00       	mov    0x805140,%eax
  802570:	85 c0                	test   %eax,%eax
  802572:	0f 85 fd fe ff ff    	jne    802475 <alloc_block_BF+0x1a>
  802578:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80257c:	0f 85 f3 fe ff ff    	jne    802475 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802582:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802586:	0f 84 d9 00 00 00    	je     802665 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  80258c:	a1 48 51 80 00       	mov    0x805148,%eax
  802591:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802594:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802597:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80259a:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  80259d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8025a3:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8025a6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8025aa:	75 17                	jne    8025c3 <alloc_block_BF+0x168>
  8025ac:	83 ec 04             	sub    $0x4,%esp
  8025af:	68 48 3f 80 00       	push   $0x803f48
  8025b4:	68 c7 00 00 00       	push   $0xc7
  8025b9:	68 9f 3e 80 00       	push   $0x803e9f
  8025be:	e8 c2 0d 00 00       	call   803385 <_panic>
  8025c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025c6:	8b 00                	mov    (%eax),%eax
  8025c8:	85 c0                	test   %eax,%eax
  8025ca:	74 10                	je     8025dc <alloc_block_BF+0x181>
  8025cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025cf:	8b 00                	mov    (%eax),%eax
  8025d1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025d4:	8b 52 04             	mov    0x4(%edx),%edx
  8025d7:	89 50 04             	mov    %edx,0x4(%eax)
  8025da:	eb 0b                	jmp    8025e7 <alloc_block_BF+0x18c>
  8025dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025df:	8b 40 04             	mov    0x4(%eax),%eax
  8025e2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8025e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025ea:	8b 40 04             	mov    0x4(%eax),%eax
  8025ed:	85 c0                	test   %eax,%eax
  8025ef:	74 0f                	je     802600 <alloc_block_BF+0x1a5>
  8025f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025f4:	8b 40 04             	mov    0x4(%eax),%eax
  8025f7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025fa:	8b 12                	mov    (%edx),%edx
  8025fc:	89 10                	mov    %edx,(%eax)
  8025fe:	eb 0a                	jmp    80260a <alloc_block_BF+0x1af>
  802600:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802603:	8b 00                	mov    (%eax),%eax
  802605:	a3 48 51 80 00       	mov    %eax,0x805148
  80260a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80260d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802613:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802616:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80261d:	a1 54 51 80 00       	mov    0x805154,%eax
  802622:	48                   	dec    %eax
  802623:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802628:	83 ec 08             	sub    $0x8,%esp
  80262b:	ff 75 ec             	pushl  -0x14(%ebp)
  80262e:	68 38 51 80 00       	push   $0x805138
  802633:	e8 71 f9 ff ff       	call   801fa9 <find_block>
  802638:	83 c4 10             	add    $0x10,%esp
  80263b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  80263e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802641:	8b 50 08             	mov    0x8(%eax),%edx
  802644:	8b 45 08             	mov    0x8(%ebp),%eax
  802647:	01 c2                	add    %eax,%edx
  802649:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80264c:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  80264f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802652:	8b 40 0c             	mov    0xc(%eax),%eax
  802655:	2b 45 08             	sub    0x8(%ebp),%eax
  802658:	89 c2                	mov    %eax,%edx
  80265a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80265d:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802660:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802663:	eb 05                	jmp    80266a <alloc_block_BF+0x20f>
	}
	return NULL;
  802665:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80266a:	c9                   	leave  
  80266b:	c3                   	ret    

0080266c <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80266c:	55                   	push   %ebp
  80266d:	89 e5                	mov    %esp,%ebp
  80266f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802672:	a1 28 50 80 00       	mov    0x805028,%eax
  802677:	85 c0                	test   %eax,%eax
  802679:	0f 85 de 01 00 00    	jne    80285d <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80267f:	a1 38 51 80 00       	mov    0x805138,%eax
  802684:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802687:	e9 9e 01 00 00       	jmp    80282a <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  80268c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268f:	8b 40 0c             	mov    0xc(%eax),%eax
  802692:	3b 45 08             	cmp    0x8(%ebp),%eax
  802695:	0f 82 87 01 00 00    	jb     802822 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  80269b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269e:	8b 40 0c             	mov    0xc(%eax),%eax
  8026a1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026a4:	0f 85 95 00 00 00    	jne    80273f <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8026aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ae:	75 17                	jne    8026c7 <alloc_block_NF+0x5b>
  8026b0:	83 ec 04             	sub    $0x4,%esp
  8026b3:	68 48 3f 80 00       	push   $0x803f48
  8026b8:	68 e0 00 00 00       	push   $0xe0
  8026bd:	68 9f 3e 80 00       	push   $0x803e9f
  8026c2:	e8 be 0c 00 00       	call   803385 <_panic>
  8026c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ca:	8b 00                	mov    (%eax),%eax
  8026cc:	85 c0                	test   %eax,%eax
  8026ce:	74 10                	je     8026e0 <alloc_block_NF+0x74>
  8026d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d3:	8b 00                	mov    (%eax),%eax
  8026d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026d8:	8b 52 04             	mov    0x4(%edx),%edx
  8026db:	89 50 04             	mov    %edx,0x4(%eax)
  8026de:	eb 0b                	jmp    8026eb <alloc_block_NF+0x7f>
  8026e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e3:	8b 40 04             	mov    0x4(%eax),%eax
  8026e6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8026eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ee:	8b 40 04             	mov    0x4(%eax),%eax
  8026f1:	85 c0                	test   %eax,%eax
  8026f3:	74 0f                	je     802704 <alloc_block_NF+0x98>
  8026f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f8:	8b 40 04             	mov    0x4(%eax),%eax
  8026fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026fe:	8b 12                	mov    (%edx),%edx
  802700:	89 10                	mov    %edx,(%eax)
  802702:	eb 0a                	jmp    80270e <alloc_block_NF+0xa2>
  802704:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802707:	8b 00                	mov    (%eax),%eax
  802709:	a3 38 51 80 00       	mov    %eax,0x805138
  80270e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802711:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802717:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802721:	a1 44 51 80 00       	mov    0x805144,%eax
  802726:	48                   	dec    %eax
  802727:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  80272c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272f:	8b 40 08             	mov    0x8(%eax),%eax
  802732:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802737:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273a:	e9 f8 04 00 00       	jmp    802c37 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  80273f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802742:	8b 40 0c             	mov    0xc(%eax),%eax
  802745:	3b 45 08             	cmp    0x8(%ebp),%eax
  802748:	0f 86 d4 00 00 00    	jbe    802822 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80274e:	a1 48 51 80 00       	mov    0x805148,%eax
  802753:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802756:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802759:	8b 50 08             	mov    0x8(%eax),%edx
  80275c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80275f:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802762:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802765:	8b 55 08             	mov    0x8(%ebp),%edx
  802768:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80276b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80276f:	75 17                	jne    802788 <alloc_block_NF+0x11c>
  802771:	83 ec 04             	sub    $0x4,%esp
  802774:	68 48 3f 80 00       	push   $0x803f48
  802779:	68 e9 00 00 00       	push   $0xe9
  80277e:	68 9f 3e 80 00       	push   $0x803e9f
  802783:	e8 fd 0b 00 00       	call   803385 <_panic>
  802788:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80278b:	8b 00                	mov    (%eax),%eax
  80278d:	85 c0                	test   %eax,%eax
  80278f:	74 10                	je     8027a1 <alloc_block_NF+0x135>
  802791:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802794:	8b 00                	mov    (%eax),%eax
  802796:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802799:	8b 52 04             	mov    0x4(%edx),%edx
  80279c:	89 50 04             	mov    %edx,0x4(%eax)
  80279f:	eb 0b                	jmp    8027ac <alloc_block_NF+0x140>
  8027a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a4:	8b 40 04             	mov    0x4(%eax),%eax
  8027a7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8027ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027af:	8b 40 04             	mov    0x4(%eax),%eax
  8027b2:	85 c0                	test   %eax,%eax
  8027b4:	74 0f                	je     8027c5 <alloc_block_NF+0x159>
  8027b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b9:	8b 40 04             	mov    0x4(%eax),%eax
  8027bc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027bf:	8b 12                	mov    (%edx),%edx
  8027c1:	89 10                	mov    %edx,(%eax)
  8027c3:	eb 0a                	jmp    8027cf <alloc_block_NF+0x163>
  8027c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c8:	8b 00                	mov    (%eax),%eax
  8027ca:	a3 48 51 80 00       	mov    %eax,0x805148
  8027cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027db:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027e2:	a1 54 51 80 00       	mov    0x805154,%eax
  8027e7:	48                   	dec    %eax
  8027e8:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  8027ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f0:	8b 40 08             	mov    0x8(%eax),%eax
  8027f3:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8027f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fb:	8b 50 08             	mov    0x8(%eax),%edx
  8027fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802801:	01 c2                	add    %eax,%edx
  802803:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802806:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802809:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280c:	8b 40 0c             	mov    0xc(%eax),%eax
  80280f:	2b 45 08             	sub    0x8(%ebp),%eax
  802812:	89 c2                	mov    %eax,%edx
  802814:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802817:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  80281a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80281d:	e9 15 04 00 00       	jmp    802c37 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802822:	a1 40 51 80 00       	mov    0x805140,%eax
  802827:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80282a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80282e:	74 07                	je     802837 <alloc_block_NF+0x1cb>
  802830:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802833:	8b 00                	mov    (%eax),%eax
  802835:	eb 05                	jmp    80283c <alloc_block_NF+0x1d0>
  802837:	b8 00 00 00 00       	mov    $0x0,%eax
  80283c:	a3 40 51 80 00       	mov    %eax,0x805140
  802841:	a1 40 51 80 00       	mov    0x805140,%eax
  802846:	85 c0                	test   %eax,%eax
  802848:	0f 85 3e fe ff ff    	jne    80268c <alloc_block_NF+0x20>
  80284e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802852:	0f 85 34 fe ff ff    	jne    80268c <alloc_block_NF+0x20>
  802858:	e9 d5 03 00 00       	jmp    802c32 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80285d:	a1 38 51 80 00       	mov    0x805138,%eax
  802862:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802865:	e9 b1 01 00 00       	jmp    802a1b <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  80286a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286d:	8b 50 08             	mov    0x8(%eax),%edx
  802870:	a1 28 50 80 00       	mov    0x805028,%eax
  802875:	39 c2                	cmp    %eax,%edx
  802877:	0f 82 96 01 00 00    	jb     802a13 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  80287d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802880:	8b 40 0c             	mov    0xc(%eax),%eax
  802883:	3b 45 08             	cmp    0x8(%ebp),%eax
  802886:	0f 82 87 01 00 00    	jb     802a13 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  80288c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288f:	8b 40 0c             	mov    0xc(%eax),%eax
  802892:	3b 45 08             	cmp    0x8(%ebp),%eax
  802895:	0f 85 95 00 00 00    	jne    802930 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80289b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80289f:	75 17                	jne    8028b8 <alloc_block_NF+0x24c>
  8028a1:	83 ec 04             	sub    $0x4,%esp
  8028a4:	68 48 3f 80 00       	push   $0x803f48
  8028a9:	68 fc 00 00 00       	push   $0xfc
  8028ae:	68 9f 3e 80 00       	push   $0x803e9f
  8028b3:	e8 cd 0a 00 00       	call   803385 <_panic>
  8028b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bb:	8b 00                	mov    (%eax),%eax
  8028bd:	85 c0                	test   %eax,%eax
  8028bf:	74 10                	je     8028d1 <alloc_block_NF+0x265>
  8028c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c4:	8b 00                	mov    (%eax),%eax
  8028c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028c9:	8b 52 04             	mov    0x4(%edx),%edx
  8028cc:	89 50 04             	mov    %edx,0x4(%eax)
  8028cf:	eb 0b                	jmp    8028dc <alloc_block_NF+0x270>
  8028d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d4:	8b 40 04             	mov    0x4(%eax),%eax
  8028d7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8028dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028df:	8b 40 04             	mov    0x4(%eax),%eax
  8028e2:	85 c0                	test   %eax,%eax
  8028e4:	74 0f                	je     8028f5 <alloc_block_NF+0x289>
  8028e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e9:	8b 40 04             	mov    0x4(%eax),%eax
  8028ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028ef:	8b 12                	mov    (%edx),%edx
  8028f1:	89 10                	mov    %edx,(%eax)
  8028f3:	eb 0a                	jmp    8028ff <alloc_block_NF+0x293>
  8028f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f8:	8b 00                	mov    (%eax),%eax
  8028fa:	a3 38 51 80 00       	mov    %eax,0x805138
  8028ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802902:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802908:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802912:	a1 44 51 80 00       	mov    0x805144,%eax
  802917:	48                   	dec    %eax
  802918:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  80291d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802920:	8b 40 08             	mov    0x8(%eax),%eax
  802923:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802928:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292b:	e9 07 03 00 00       	jmp    802c37 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802930:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802933:	8b 40 0c             	mov    0xc(%eax),%eax
  802936:	3b 45 08             	cmp    0x8(%ebp),%eax
  802939:	0f 86 d4 00 00 00    	jbe    802a13 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80293f:	a1 48 51 80 00       	mov    0x805148,%eax
  802944:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802947:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294a:	8b 50 08             	mov    0x8(%eax),%edx
  80294d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802950:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802953:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802956:	8b 55 08             	mov    0x8(%ebp),%edx
  802959:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80295c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802960:	75 17                	jne    802979 <alloc_block_NF+0x30d>
  802962:	83 ec 04             	sub    $0x4,%esp
  802965:	68 48 3f 80 00       	push   $0x803f48
  80296a:	68 04 01 00 00       	push   $0x104
  80296f:	68 9f 3e 80 00       	push   $0x803e9f
  802974:	e8 0c 0a 00 00       	call   803385 <_panic>
  802979:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80297c:	8b 00                	mov    (%eax),%eax
  80297e:	85 c0                	test   %eax,%eax
  802980:	74 10                	je     802992 <alloc_block_NF+0x326>
  802982:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802985:	8b 00                	mov    (%eax),%eax
  802987:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80298a:	8b 52 04             	mov    0x4(%edx),%edx
  80298d:	89 50 04             	mov    %edx,0x4(%eax)
  802990:	eb 0b                	jmp    80299d <alloc_block_NF+0x331>
  802992:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802995:	8b 40 04             	mov    0x4(%eax),%eax
  802998:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80299d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029a0:	8b 40 04             	mov    0x4(%eax),%eax
  8029a3:	85 c0                	test   %eax,%eax
  8029a5:	74 0f                	je     8029b6 <alloc_block_NF+0x34a>
  8029a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029aa:	8b 40 04             	mov    0x4(%eax),%eax
  8029ad:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029b0:	8b 12                	mov    (%edx),%edx
  8029b2:	89 10                	mov    %edx,(%eax)
  8029b4:	eb 0a                	jmp    8029c0 <alloc_block_NF+0x354>
  8029b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029b9:	8b 00                	mov    (%eax),%eax
  8029bb:	a3 48 51 80 00       	mov    %eax,0x805148
  8029c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029cc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029d3:	a1 54 51 80 00       	mov    0x805154,%eax
  8029d8:	48                   	dec    %eax
  8029d9:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8029de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029e1:	8b 40 08             	mov    0x8(%eax),%eax
  8029e4:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  8029e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ec:	8b 50 08             	mov    0x8(%eax),%edx
  8029ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f2:	01 c2                	add    %eax,%edx
  8029f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f7:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8029fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fd:	8b 40 0c             	mov    0xc(%eax),%eax
  802a00:	2b 45 08             	sub    0x8(%ebp),%eax
  802a03:	89 c2                	mov    %eax,%edx
  802a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a08:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802a0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a0e:	e9 24 02 00 00       	jmp    802c37 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a13:	a1 40 51 80 00       	mov    0x805140,%eax
  802a18:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a1b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a1f:	74 07                	je     802a28 <alloc_block_NF+0x3bc>
  802a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a24:	8b 00                	mov    (%eax),%eax
  802a26:	eb 05                	jmp    802a2d <alloc_block_NF+0x3c1>
  802a28:	b8 00 00 00 00       	mov    $0x0,%eax
  802a2d:	a3 40 51 80 00       	mov    %eax,0x805140
  802a32:	a1 40 51 80 00       	mov    0x805140,%eax
  802a37:	85 c0                	test   %eax,%eax
  802a39:	0f 85 2b fe ff ff    	jne    80286a <alloc_block_NF+0x1fe>
  802a3f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a43:	0f 85 21 fe ff ff    	jne    80286a <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a49:	a1 38 51 80 00       	mov    0x805138,%eax
  802a4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a51:	e9 ae 01 00 00       	jmp    802c04 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802a56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a59:	8b 50 08             	mov    0x8(%eax),%edx
  802a5c:	a1 28 50 80 00       	mov    0x805028,%eax
  802a61:	39 c2                	cmp    %eax,%edx
  802a63:	0f 83 93 01 00 00    	jae    802bfc <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6c:	8b 40 0c             	mov    0xc(%eax),%eax
  802a6f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a72:	0f 82 84 01 00 00    	jb     802bfc <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7b:	8b 40 0c             	mov    0xc(%eax),%eax
  802a7e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a81:	0f 85 95 00 00 00    	jne    802b1c <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a8b:	75 17                	jne    802aa4 <alloc_block_NF+0x438>
  802a8d:	83 ec 04             	sub    $0x4,%esp
  802a90:	68 48 3f 80 00       	push   $0x803f48
  802a95:	68 14 01 00 00       	push   $0x114
  802a9a:	68 9f 3e 80 00       	push   $0x803e9f
  802a9f:	e8 e1 08 00 00       	call   803385 <_panic>
  802aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa7:	8b 00                	mov    (%eax),%eax
  802aa9:	85 c0                	test   %eax,%eax
  802aab:	74 10                	je     802abd <alloc_block_NF+0x451>
  802aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab0:	8b 00                	mov    (%eax),%eax
  802ab2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ab5:	8b 52 04             	mov    0x4(%edx),%edx
  802ab8:	89 50 04             	mov    %edx,0x4(%eax)
  802abb:	eb 0b                	jmp    802ac8 <alloc_block_NF+0x45c>
  802abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac0:	8b 40 04             	mov    0x4(%eax),%eax
  802ac3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ac8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acb:	8b 40 04             	mov    0x4(%eax),%eax
  802ace:	85 c0                	test   %eax,%eax
  802ad0:	74 0f                	je     802ae1 <alloc_block_NF+0x475>
  802ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad5:	8b 40 04             	mov    0x4(%eax),%eax
  802ad8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802adb:	8b 12                	mov    (%edx),%edx
  802add:	89 10                	mov    %edx,(%eax)
  802adf:	eb 0a                	jmp    802aeb <alloc_block_NF+0x47f>
  802ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae4:	8b 00                	mov    (%eax),%eax
  802ae6:	a3 38 51 80 00       	mov    %eax,0x805138
  802aeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802afe:	a1 44 51 80 00       	mov    0x805144,%eax
  802b03:	48                   	dec    %eax
  802b04:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0c:	8b 40 08             	mov    0x8(%eax),%eax
  802b0f:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b17:	e9 1b 01 00 00       	jmp    802c37 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802b1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1f:	8b 40 0c             	mov    0xc(%eax),%eax
  802b22:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b25:	0f 86 d1 00 00 00    	jbe    802bfc <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b2b:	a1 48 51 80 00       	mov    0x805148,%eax
  802b30:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b36:	8b 50 08             	mov    0x8(%eax),%edx
  802b39:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b3c:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b42:	8b 55 08             	mov    0x8(%ebp),%edx
  802b45:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b48:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b4c:	75 17                	jne    802b65 <alloc_block_NF+0x4f9>
  802b4e:	83 ec 04             	sub    $0x4,%esp
  802b51:	68 48 3f 80 00       	push   $0x803f48
  802b56:	68 1c 01 00 00       	push   $0x11c
  802b5b:	68 9f 3e 80 00       	push   $0x803e9f
  802b60:	e8 20 08 00 00       	call   803385 <_panic>
  802b65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b68:	8b 00                	mov    (%eax),%eax
  802b6a:	85 c0                	test   %eax,%eax
  802b6c:	74 10                	je     802b7e <alloc_block_NF+0x512>
  802b6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b71:	8b 00                	mov    (%eax),%eax
  802b73:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b76:	8b 52 04             	mov    0x4(%edx),%edx
  802b79:	89 50 04             	mov    %edx,0x4(%eax)
  802b7c:	eb 0b                	jmp    802b89 <alloc_block_NF+0x51d>
  802b7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b81:	8b 40 04             	mov    0x4(%eax),%eax
  802b84:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b89:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b8c:	8b 40 04             	mov    0x4(%eax),%eax
  802b8f:	85 c0                	test   %eax,%eax
  802b91:	74 0f                	je     802ba2 <alloc_block_NF+0x536>
  802b93:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b96:	8b 40 04             	mov    0x4(%eax),%eax
  802b99:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b9c:	8b 12                	mov    (%edx),%edx
  802b9e:	89 10                	mov    %edx,(%eax)
  802ba0:	eb 0a                	jmp    802bac <alloc_block_NF+0x540>
  802ba2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba5:	8b 00                	mov    (%eax),%eax
  802ba7:	a3 48 51 80 00       	mov    %eax,0x805148
  802bac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802baf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bb8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bbf:	a1 54 51 80 00       	mov    0x805154,%eax
  802bc4:	48                   	dec    %eax
  802bc5:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802bca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bcd:	8b 40 08             	mov    0x8(%eax),%eax
  802bd0:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802bd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd8:	8b 50 08             	mov    0x8(%eax),%edx
  802bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bde:	01 c2                	add    %eax,%edx
  802be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be3:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be9:	8b 40 0c             	mov    0xc(%eax),%eax
  802bec:	2b 45 08             	sub    0x8(%ebp),%eax
  802bef:	89 c2                	mov    %eax,%edx
  802bf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf4:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802bf7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bfa:	eb 3b                	jmp    802c37 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802bfc:	a1 40 51 80 00       	mov    0x805140,%eax
  802c01:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c04:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c08:	74 07                	je     802c11 <alloc_block_NF+0x5a5>
  802c0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0d:	8b 00                	mov    (%eax),%eax
  802c0f:	eb 05                	jmp    802c16 <alloc_block_NF+0x5aa>
  802c11:	b8 00 00 00 00       	mov    $0x0,%eax
  802c16:	a3 40 51 80 00       	mov    %eax,0x805140
  802c1b:	a1 40 51 80 00       	mov    0x805140,%eax
  802c20:	85 c0                	test   %eax,%eax
  802c22:	0f 85 2e fe ff ff    	jne    802a56 <alloc_block_NF+0x3ea>
  802c28:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c2c:	0f 85 24 fe ff ff    	jne    802a56 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802c32:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c37:	c9                   	leave  
  802c38:	c3                   	ret    

00802c39 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802c39:	55                   	push   %ebp
  802c3a:	89 e5                	mov    %esp,%ebp
  802c3c:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802c3f:	a1 38 51 80 00       	mov    0x805138,%eax
  802c44:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802c47:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802c4c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802c4f:	a1 38 51 80 00       	mov    0x805138,%eax
  802c54:	85 c0                	test   %eax,%eax
  802c56:	74 14                	je     802c6c <insert_sorted_with_merge_freeList+0x33>
  802c58:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5b:	8b 50 08             	mov    0x8(%eax),%edx
  802c5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c61:	8b 40 08             	mov    0x8(%eax),%eax
  802c64:	39 c2                	cmp    %eax,%edx
  802c66:	0f 87 9b 01 00 00    	ja     802e07 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802c6c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c70:	75 17                	jne    802c89 <insert_sorted_with_merge_freeList+0x50>
  802c72:	83 ec 04             	sub    $0x4,%esp
  802c75:	68 7c 3e 80 00       	push   $0x803e7c
  802c7a:	68 38 01 00 00       	push   $0x138
  802c7f:	68 9f 3e 80 00       	push   $0x803e9f
  802c84:	e8 fc 06 00 00       	call   803385 <_panic>
  802c89:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c92:	89 10                	mov    %edx,(%eax)
  802c94:	8b 45 08             	mov    0x8(%ebp),%eax
  802c97:	8b 00                	mov    (%eax),%eax
  802c99:	85 c0                	test   %eax,%eax
  802c9b:	74 0d                	je     802caa <insert_sorted_with_merge_freeList+0x71>
  802c9d:	a1 38 51 80 00       	mov    0x805138,%eax
  802ca2:	8b 55 08             	mov    0x8(%ebp),%edx
  802ca5:	89 50 04             	mov    %edx,0x4(%eax)
  802ca8:	eb 08                	jmp    802cb2 <insert_sorted_with_merge_freeList+0x79>
  802caa:	8b 45 08             	mov    0x8(%ebp),%eax
  802cad:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb5:	a3 38 51 80 00       	mov    %eax,0x805138
  802cba:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cc4:	a1 44 51 80 00       	mov    0x805144,%eax
  802cc9:	40                   	inc    %eax
  802cca:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802ccf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cd3:	0f 84 a8 06 00 00    	je     803381 <insert_sorted_with_merge_freeList+0x748>
  802cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cdc:	8b 50 08             	mov    0x8(%eax),%edx
  802cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce2:	8b 40 0c             	mov    0xc(%eax),%eax
  802ce5:	01 c2                	add    %eax,%edx
  802ce7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cea:	8b 40 08             	mov    0x8(%eax),%eax
  802ced:	39 c2                	cmp    %eax,%edx
  802cef:	0f 85 8c 06 00 00    	jne    803381 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf8:	8b 50 0c             	mov    0xc(%eax),%edx
  802cfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cfe:	8b 40 0c             	mov    0xc(%eax),%eax
  802d01:	01 c2                	add    %eax,%edx
  802d03:	8b 45 08             	mov    0x8(%ebp),%eax
  802d06:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802d09:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d0d:	75 17                	jne    802d26 <insert_sorted_with_merge_freeList+0xed>
  802d0f:	83 ec 04             	sub    $0x4,%esp
  802d12:	68 48 3f 80 00       	push   $0x803f48
  802d17:	68 3c 01 00 00       	push   $0x13c
  802d1c:	68 9f 3e 80 00       	push   $0x803e9f
  802d21:	e8 5f 06 00 00       	call   803385 <_panic>
  802d26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d29:	8b 00                	mov    (%eax),%eax
  802d2b:	85 c0                	test   %eax,%eax
  802d2d:	74 10                	je     802d3f <insert_sorted_with_merge_freeList+0x106>
  802d2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d32:	8b 00                	mov    (%eax),%eax
  802d34:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d37:	8b 52 04             	mov    0x4(%edx),%edx
  802d3a:	89 50 04             	mov    %edx,0x4(%eax)
  802d3d:	eb 0b                	jmp    802d4a <insert_sorted_with_merge_freeList+0x111>
  802d3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d42:	8b 40 04             	mov    0x4(%eax),%eax
  802d45:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4d:	8b 40 04             	mov    0x4(%eax),%eax
  802d50:	85 c0                	test   %eax,%eax
  802d52:	74 0f                	je     802d63 <insert_sorted_with_merge_freeList+0x12a>
  802d54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d57:	8b 40 04             	mov    0x4(%eax),%eax
  802d5a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d5d:	8b 12                	mov    (%edx),%edx
  802d5f:	89 10                	mov    %edx,(%eax)
  802d61:	eb 0a                	jmp    802d6d <insert_sorted_with_merge_freeList+0x134>
  802d63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d66:	8b 00                	mov    (%eax),%eax
  802d68:	a3 38 51 80 00       	mov    %eax,0x805138
  802d6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d70:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d79:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d80:	a1 44 51 80 00       	mov    0x805144,%eax
  802d85:	48                   	dec    %eax
  802d86:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802d8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d8e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802d95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d98:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802d9f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802da3:	75 17                	jne    802dbc <insert_sorted_with_merge_freeList+0x183>
  802da5:	83 ec 04             	sub    $0x4,%esp
  802da8:	68 7c 3e 80 00       	push   $0x803e7c
  802dad:	68 3f 01 00 00       	push   $0x13f
  802db2:	68 9f 3e 80 00       	push   $0x803e9f
  802db7:	e8 c9 05 00 00       	call   803385 <_panic>
  802dbc:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802dc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc5:	89 10                	mov    %edx,(%eax)
  802dc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dca:	8b 00                	mov    (%eax),%eax
  802dcc:	85 c0                	test   %eax,%eax
  802dce:	74 0d                	je     802ddd <insert_sorted_with_merge_freeList+0x1a4>
  802dd0:	a1 48 51 80 00       	mov    0x805148,%eax
  802dd5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dd8:	89 50 04             	mov    %edx,0x4(%eax)
  802ddb:	eb 08                	jmp    802de5 <insert_sorted_with_merge_freeList+0x1ac>
  802ddd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802de5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de8:	a3 48 51 80 00       	mov    %eax,0x805148
  802ded:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802df7:	a1 54 51 80 00       	mov    0x805154,%eax
  802dfc:	40                   	inc    %eax
  802dfd:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e02:	e9 7a 05 00 00       	jmp    803381 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802e07:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0a:	8b 50 08             	mov    0x8(%eax),%edx
  802e0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e10:	8b 40 08             	mov    0x8(%eax),%eax
  802e13:	39 c2                	cmp    %eax,%edx
  802e15:	0f 82 14 01 00 00    	jb     802f2f <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802e1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e1e:	8b 50 08             	mov    0x8(%eax),%edx
  802e21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e24:	8b 40 0c             	mov    0xc(%eax),%eax
  802e27:	01 c2                	add    %eax,%edx
  802e29:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2c:	8b 40 08             	mov    0x8(%eax),%eax
  802e2f:	39 c2                	cmp    %eax,%edx
  802e31:	0f 85 90 00 00 00    	jne    802ec7 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802e37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e3a:	8b 50 0c             	mov    0xc(%eax),%edx
  802e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e40:	8b 40 0c             	mov    0xc(%eax),%eax
  802e43:	01 c2                	add    %eax,%edx
  802e45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e48:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802e55:	8b 45 08             	mov    0x8(%ebp),%eax
  802e58:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e5f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e63:	75 17                	jne    802e7c <insert_sorted_with_merge_freeList+0x243>
  802e65:	83 ec 04             	sub    $0x4,%esp
  802e68:	68 7c 3e 80 00       	push   $0x803e7c
  802e6d:	68 49 01 00 00       	push   $0x149
  802e72:	68 9f 3e 80 00       	push   $0x803e9f
  802e77:	e8 09 05 00 00       	call   803385 <_panic>
  802e7c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e82:	8b 45 08             	mov    0x8(%ebp),%eax
  802e85:	89 10                	mov    %edx,(%eax)
  802e87:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8a:	8b 00                	mov    (%eax),%eax
  802e8c:	85 c0                	test   %eax,%eax
  802e8e:	74 0d                	je     802e9d <insert_sorted_with_merge_freeList+0x264>
  802e90:	a1 48 51 80 00       	mov    0x805148,%eax
  802e95:	8b 55 08             	mov    0x8(%ebp),%edx
  802e98:	89 50 04             	mov    %edx,0x4(%eax)
  802e9b:	eb 08                	jmp    802ea5 <insert_sorted_with_merge_freeList+0x26c>
  802e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea8:	a3 48 51 80 00       	mov    %eax,0x805148
  802ead:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eb7:	a1 54 51 80 00       	mov    0x805154,%eax
  802ebc:	40                   	inc    %eax
  802ebd:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802ec2:	e9 bb 04 00 00       	jmp    803382 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802ec7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ecb:	75 17                	jne    802ee4 <insert_sorted_with_merge_freeList+0x2ab>
  802ecd:	83 ec 04             	sub    $0x4,%esp
  802ed0:	68 f0 3e 80 00       	push   $0x803ef0
  802ed5:	68 4c 01 00 00       	push   $0x14c
  802eda:	68 9f 3e 80 00       	push   $0x803e9f
  802edf:	e8 a1 04 00 00       	call   803385 <_panic>
  802ee4:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802eea:	8b 45 08             	mov    0x8(%ebp),%eax
  802eed:	89 50 04             	mov    %edx,0x4(%eax)
  802ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef3:	8b 40 04             	mov    0x4(%eax),%eax
  802ef6:	85 c0                	test   %eax,%eax
  802ef8:	74 0c                	je     802f06 <insert_sorted_with_merge_freeList+0x2cd>
  802efa:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802eff:	8b 55 08             	mov    0x8(%ebp),%edx
  802f02:	89 10                	mov    %edx,(%eax)
  802f04:	eb 08                	jmp    802f0e <insert_sorted_with_merge_freeList+0x2d5>
  802f06:	8b 45 08             	mov    0x8(%ebp),%eax
  802f09:	a3 38 51 80 00       	mov    %eax,0x805138
  802f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f11:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f16:	8b 45 08             	mov    0x8(%ebp),%eax
  802f19:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f1f:	a1 44 51 80 00       	mov    0x805144,%eax
  802f24:	40                   	inc    %eax
  802f25:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f2a:	e9 53 04 00 00       	jmp    803382 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802f2f:	a1 38 51 80 00       	mov    0x805138,%eax
  802f34:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f37:	e9 15 04 00 00       	jmp    803351 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802f3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3f:	8b 00                	mov    (%eax),%eax
  802f41:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802f44:	8b 45 08             	mov    0x8(%ebp),%eax
  802f47:	8b 50 08             	mov    0x8(%eax),%edx
  802f4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4d:	8b 40 08             	mov    0x8(%eax),%eax
  802f50:	39 c2                	cmp    %eax,%edx
  802f52:	0f 86 f1 03 00 00    	jbe    803349 <insert_sorted_with_merge_freeList+0x710>
  802f58:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5b:	8b 50 08             	mov    0x8(%eax),%edx
  802f5e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f61:	8b 40 08             	mov    0x8(%eax),%eax
  802f64:	39 c2                	cmp    %eax,%edx
  802f66:	0f 83 dd 03 00 00    	jae    803349 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802f6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6f:	8b 50 08             	mov    0x8(%eax),%edx
  802f72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f75:	8b 40 0c             	mov    0xc(%eax),%eax
  802f78:	01 c2                	add    %eax,%edx
  802f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7d:	8b 40 08             	mov    0x8(%eax),%eax
  802f80:	39 c2                	cmp    %eax,%edx
  802f82:	0f 85 b9 01 00 00    	jne    803141 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802f88:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8b:	8b 50 08             	mov    0x8(%eax),%edx
  802f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f91:	8b 40 0c             	mov    0xc(%eax),%eax
  802f94:	01 c2                	add    %eax,%edx
  802f96:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f99:	8b 40 08             	mov    0x8(%eax),%eax
  802f9c:	39 c2                	cmp    %eax,%edx
  802f9e:	0f 85 0d 01 00 00    	jne    8030b1 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802fa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa7:	8b 50 0c             	mov    0xc(%eax),%edx
  802faa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fad:	8b 40 0c             	mov    0xc(%eax),%eax
  802fb0:	01 c2                	add    %eax,%edx
  802fb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb5:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802fb8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fbc:	75 17                	jne    802fd5 <insert_sorted_with_merge_freeList+0x39c>
  802fbe:	83 ec 04             	sub    $0x4,%esp
  802fc1:	68 48 3f 80 00       	push   $0x803f48
  802fc6:	68 5c 01 00 00       	push   $0x15c
  802fcb:	68 9f 3e 80 00       	push   $0x803e9f
  802fd0:	e8 b0 03 00 00       	call   803385 <_panic>
  802fd5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fd8:	8b 00                	mov    (%eax),%eax
  802fda:	85 c0                	test   %eax,%eax
  802fdc:	74 10                	je     802fee <insert_sorted_with_merge_freeList+0x3b5>
  802fde:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe1:	8b 00                	mov    (%eax),%eax
  802fe3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fe6:	8b 52 04             	mov    0x4(%edx),%edx
  802fe9:	89 50 04             	mov    %edx,0x4(%eax)
  802fec:	eb 0b                	jmp    802ff9 <insert_sorted_with_merge_freeList+0x3c0>
  802fee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff1:	8b 40 04             	mov    0x4(%eax),%eax
  802ff4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ff9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ffc:	8b 40 04             	mov    0x4(%eax),%eax
  802fff:	85 c0                	test   %eax,%eax
  803001:	74 0f                	je     803012 <insert_sorted_with_merge_freeList+0x3d9>
  803003:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803006:	8b 40 04             	mov    0x4(%eax),%eax
  803009:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80300c:	8b 12                	mov    (%edx),%edx
  80300e:	89 10                	mov    %edx,(%eax)
  803010:	eb 0a                	jmp    80301c <insert_sorted_with_merge_freeList+0x3e3>
  803012:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803015:	8b 00                	mov    (%eax),%eax
  803017:	a3 38 51 80 00       	mov    %eax,0x805138
  80301c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80301f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803025:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803028:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80302f:	a1 44 51 80 00       	mov    0x805144,%eax
  803034:	48                   	dec    %eax
  803035:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  80303a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80303d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803044:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803047:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80304e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803052:	75 17                	jne    80306b <insert_sorted_with_merge_freeList+0x432>
  803054:	83 ec 04             	sub    $0x4,%esp
  803057:	68 7c 3e 80 00       	push   $0x803e7c
  80305c:	68 5f 01 00 00       	push   $0x15f
  803061:	68 9f 3e 80 00       	push   $0x803e9f
  803066:	e8 1a 03 00 00       	call   803385 <_panic>
  80306b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803071:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803074:	89 10                	mov    %edx,(%eax)
  803076:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803079:	8b 00                	mov    (%eax),%eax
  80307b:	85 c0                	test   %eax,%eax
  80307d:	74 0d                	je     80308c <insert_sorted_with_merge_freeList+0x453>
  80307f:	a1 48 51 80 00       	mov    0x805148,%eax
  803084:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803087:	89 50 04             	mov    %edx,0x4(%eax)
  80308a:	eb 08                	jmp    803094 <insert_sorted_with_merge_freeList+0x45b>
  80308c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80308f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803094:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803097:	a3 48 51 80 00       	mov    %eax,0x805148
  80309c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80309f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030a6:	a1 54 51 80 00       	mov    0x805154,%eax
  8030ab:	40                   	inc    %eax
  8030ac:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8030b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b4:	8b 50 0c             	mov    0xc(%eax),%edx
  8030b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8030bd:	01 c2                	add    %eax,%edx
  8030bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c2:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8030c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8030cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8030d9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030dd:	75 17                	jne    8030f6 <insert_sorted_with_merge_freeList+0x4bd>
  8030df:	83 ec 04             	sub    $0x4,%esp
  8030e2:	68 7c 3e 80 00       	push   $0x803e7c
  8030e7:	68 64 01 00 00       	push   $0x164
  8030ec:	68 9f 3e 80 00       	push   $0x803e9f
  8030f1:	e8 8f 02 00 00       	call   803385 <_panic>
  8030f6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ff:	89 10                	mov    %edx,(%eax)
  803101:	8b 45 08             	mov    0x8(%ebp),%eax
  803104:	8b 00                	mov    (%eax),%eax
  803106:	85 c0                	test   %eax,%eax
  803108:	74 0d                	je     803117 <insert_sorted_with_merge_freeList+0x4de>
  80310a:	a1 48 51 80 00       	mov    0x805148,%eax
  80310f:	8b 55 08             	mov    0x8(%ebp),%edx
  803112:	89 50 04             	mov    %edx,0x4(%eax)
  803115:	eb 08                	jmp    80311f <insert_sorted_with_merge_freeList+0x4e6>
  803117:	8b 45 08             	mov    0x8(%ebp),%eax
  80311a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80311f:	8b 45 08             	mov    0x8(%ebp),%eax
  803122:	a3 48 51 80 00       	mov    %eax,0x805148
  803127:	8b 45 08             	mov    0x8(%ebp),%eax
  80312a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803131:	a1 54 51 80 00       	mov    0x805154,%eax
  803136:	40                   	inc    %eax
  803137:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80313c:	e9 41 02 00 00       	jmp    803382 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803141:	8b 45 08             	mov    0x8(%ebp),%eax
  803144:	8b 50 08             	mov    0x8(%eax),%edx
  803147:	8b 45 08             	mov    0x8(%ebp),%eax
  80314a:	8b 40 0c             	mov    0xc(%eax),%eax
  80314d:	01 c2                	add    %eax,%edx
  80314f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803152:	8b 40 08             	mov    0x8(%eax),%eax
  803155:	39 c2                	cmp    %eax,%edx
  803157:	0f 85 7c 01 00 00    	jne    8032d9 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80315d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803161:	74 06                	je     803169 <insert_sorted_with_merge_freeList+0x530>
  803163:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803167:	75 17                	jne    803180 <insert_sorted_with_merge_freeList+0x547>
  803169:	83 ec 04             	sub    $0x4,%esp
  80316c:	68 b8 3e 80 00       	push   $0x803eb8
  803171:	68 69 01 00 00       	push   $0x169
  803176:	68 9f 3e 80 00       	push   $0x803e9f
  80317b:	e8 05 02 00 00       	call   803385 <_panic>
  803180:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803183:	8b 50 04             	mov    0x4(%eax),%edx
  803186:	8b 45 08             	mov    0x8(%ebp),%eax
  803189:	89 50 04             	mov    %edx,0x4(%eax)
  80318c:	8b 45 08             	mov    0x8(%ebp),%eax
  80318f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803192:	89 10                	mov    %edx,(%eax)
  803194:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803197:	8b 40 04             	mov    0x4(%eax),%eax
  80319a:	85 c0                	test   %eax,%eax
  80319c:	74 0d                	je     8031ab <insert_sorted_with_merge_freeList+0x572>
  80319e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a1:	8b 40 04             	mov    0x4(%eax),%eax
  8031a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8031a7:	89 10                	mov    %edx,(%eax)
  8031a9:	eb 08                	jmp    8031b3 <insert_sorted_with_merge_freeList+0x57a>
  8031ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ae:	a3 38 51 80 00       	mov    %eax,0x805138
  8031b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8031b9:	89 50 04             	mov    %edx,0x4(%eax)
  8031bc:	a1 44 51 80 00       	mov    0x805144,%eax
  8031c1:	40                   	inc    %eax
  8031c2:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8031c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ca:	8b 50 0c             	mov    0xc(%eax),%edx
  8031cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8031d3:	01 c2                	add    %eax,%edx
  8031d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d8:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8031db:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031df:	75 17                	jne    8031f8 <insert_sorted_with_merge_freeList+0x5bf>
  8031e1:	83 ec 04             	sub    $0x4,%esp
  8031e4:	68 48 3f 80 00       	push   $0x803f48
  8031e9:	68 6b 01 00 00       	push   $0x16b
  8031ee:	68 9f 3e 80 00       	push   $0x803e9f
  8031f3:	e8 8d 01 00 00       	call   803385 <_panic>
  8031f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031fb:	8b 00                	mov    (%eax),%eax
  8031fd:	85 c0                	test   %eax,%eax
  8031ff:	74 10                	je     803211 <insert_sorted_with_merge_freeList+0x5d8>
  803201:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803204:	8b 00                	mov    (%eax),%eax
  803206:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803209:	8b 52 04             	mov    0x4(%edx),%edx
  80320c:	89 50 04             	mov    %edx,0x4(%eax)
  80320f:	eb 0b                	jmp    80321c <insert_sorted_with_merge_freeList+0x5e3>
  803211:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803214:	8b 40 04             	mov    0x4(%eax),%eax
  803217:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80321c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80321f:	8b 40 04             	mov    0x4(%eax),%eax
  803222:	85 c0                	test   %eax,%eax
  803224:	74 0f                	je     803235 <insert_sorted_with_merge_freeList+0x5fc>
  803226:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803229:	8b 40 04             	mov    0x4(%eax),%eax
  80322c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80322f:	8b 12                	mov    (%edx),%edx
  803231:	89 10                	mov    %edx,(%eax)
  803233:	eb 0a                	jmp    80323f <insert_sorted_with_merge_freeList+0x606>
  803235:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803238:	8b 00                	mov    (%eax),%eax
  80323a:	a3 38 51 80 00       	mov    %eax,0x805138
  80323f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803242:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803248:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80324b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803252:	a1 44 51 80 00       	mov    0x805144,%eax
  803257:	48                   	dec    %eax
  803258:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  80325d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803260:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803267:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80326a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803271:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803275:	75 17                	jne    80328e <insert_sorted_with_merge_freeList+0x655>
  803277:	83 ec 04             	sub    $0x4,%esp
  80327a:	68 7c 3e 80 00       	push   $0x803e7c
  80327f:	68 6e 01 00 00       	push   $0x16e
  803284:	68 9f 3e 80 00       	push   $0x803e9f
  803289:	e8 f7 00 00 00       	call   803385 <_panic>
  80328e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803294:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803297:	89 10                	mov    %edx,(%eax)
  803299:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80329c:	8b 00                	mov    (%eax),%eax
  80329e:	85 c0                	test   %eax,%eax
  8032a0:	74 0d                	je     8032af <insert_sorted_with_merge_freeList+0x676>
  8032a2:	a1 48 51 80 00       	mov    0x805148,%eax
  8032a7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032aa:	89 50 04             	mov    %edx,0x4(%eax)
  8032ad:	eb 08                	jmp    8032b7 <insert_sorted_with_merge_freeList+0x67e>
  8032af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ba:	a3 48 51 80 00       	mov    %eax,0x805148
  8032bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032c9:	a1 54 51 80 00       	mov    0x805154,%eax
  8032ce:	40                   	inc    %eax
  8032cf:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8032d4:	e9 a9 00 00 00       	jmp    803382 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8032d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032dd:	74 06                	je     8032e5 <insert_sorted_with_merge_freeList+0x6ac>
  8032df:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032e3:	75 17                	jne    8032fc <insert_sorted_with_merge_freeList+0x6c3>
  8032e5:	83 ec 04             	sub    $0x4,%esp
  8032e8:	68 14 3f 80 00       	push   $0x803f14
  8032ed:	68 73 01 00 00       	push   $0x173
  8032f2:	68 9f 3e 80 00       	push   $0x803e9f
  8032f7:	e8 89 00 00 00       	call   803385 <_panic>
  8032fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ff:	8b 10                	mov    (%eax),%edx
  803301:	8b 45 08             	mov    0x8(%ebp),%eax
  803304:	89 10                	mov    %edx,(%eax)
  803306:	8b 45 08             	mov    0x8(%ebp),%eax
  803309:	8b 00                	mov    (%eax),%eax
  80330b:	85 c0                	test   %eax,%eax
  80330d:	74 0b                	je     80331a <insert_sorted_with_merge_freeList+0x6e1>
  80330f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803312:	8b 00                	mov    (%eax),%eax
  803314:	8b 55 08             	mov    0x8(%ebp),%edx
  803317:	89 50 04             	mov    %edx,0x4(%eax)
  80331a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80331d:	8b 55 08             	mov    0x8(%ebp),%edx
  803320:	89 10                	mov    %edx,(%eax)
  803322:	8b 45 08             	mov    0x8(%ebp),%eax
  803325:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803328:	89 50 04             	mov    %edx,0x4(%eax)
  80332b:	8b 45 08             	mov    0x8(%ebp),%eax
  80332e:	8b 00                	mov    (%eax),%eax
  803330:	85 c0                	test   %eax,%eax
  803332:	75 08                	jne    80333c <insert_sorted_with_merge_freeList+0x703>
  803334:	8b 45 08             	mov    0x8(%ebp),%eax
  803337:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80333c:	a1 44 51 80 00       	mov    0x805144,%eax
  803341:	40                   	inc    %eax
  803342:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803347:	eb 39                	jmp    803382 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803349:	a1 40 51 80 00       	mov    0x805140,%eax
  80334e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803351:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803355:	74 07                	je     80335e <insert_sorted_with_merge_freeList+0x725>
  803357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335a:	8b 00                	mov    (%eax),%eax
  80335c:	eb 05                	jmp    803363 <insert_sorted_with_merge_freeList+0x72a>
  80335e:	b8 00 00 00 00       	mov    $0x0,%eax
  803363:	a3 40 51 80 00       	mov    %eax,0x805140
  803368:	a1 40 51 80 00       	mov    0x805140,%eax
  80336d:	85 c0                	test   %eax,%eax
  80336f:	0f 85 c7 fb ff ff    	jne    802f3c <insert_sorted_with_merge_freeList+0x303>
  803375:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803379:	0f 85 bd fb ff ff    	jne    802f3c <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80337f:	eb 01                	jmp    803382 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803381:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803382:	90                   	nop
  803383:	c9                   	leave  
  803384:	c3                   	ret    

00803385 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803385:	55                   	push   %ebp
  803386:	89 e5                	mov    %esp,%ebp
  803388:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80338b:	8d 45 10             	lea    0x10(%ebp),%eax
  80338e:	83 c0 04             	add    $0x4,%eax
  803391:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803394:	a1 5c 51 80 00       	mov    0x80515c,%eax
  803399:	85 c0                	test   %eax,%eax
  80339b:	74 16                	je     8033b3 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80339d:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8033a2:	83 ec 08             	sub    $0x8,%esp
  8033a5:	50                   	push   %eax
  8033a6:	68 68 3f 80 00       	push   $0x803f68
  8033ab:	e8 b6 d1 ff ff       	call   800566 <cprintf>
  8033b0:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8033b3:	a1 00 50 80 00       	mov    0x805000,%eax
  8033b8:	ff 75 0c             	pushl  0xc(%ebp)
  8033bb:	ff 75 08             	pushl  0x8(%ebp)
  8033be:	50                   	push   %eax
  8033bf:	68 6d 3f 80 00       	push   $0x803f6d
  8033c4:	e8 9d d1 ff ff       	call   800566 <cprintf>
  8033c9:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8033cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8033cf:	83 ec 08             	sub    $0x8,%esp
  8033d2:	ff 75 f4             	pushl  -0xc(%ebp)
  8033d5:	50                   	push   %eax
  8033d6:	e8 20 d1 ff ff       	call   8004fb <vcprintf>
  8033db:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8033de:	83 ec 08             	sub    $0x8,%esp
  8033e1:	6a 00                	push   $0x0
  8033e3:	68 89 3f 80 00       	push   $0x803f89
  8033e8:	e8 0e d1 ff ff       	call   8004fb <vcprintf>
  8033ed:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8033f0:	e8 8f d0 ff ff       	call   800484 <exit>

	// should not return here
	while (1) ;
  8033f5:	eb fe                	jmp    8033f5 <_panic+0x70>

008033f7 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8033f7:	55                   	push   %ebp
  8033f8:	89 e5                	mov    %esp,%ebp
  8033fa:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8033fd:	a1 20 50 80 00       	mov    0x805020,%eax
  803402:	8b 50 74             	mov    0x74(%eax),%edx
  803405:	8b 45 0c             	mov    0xc(%ebp),%eax
  803408:	39 c2                	cmp    %eax,%edx
  80340a:	74 14                	je     803420 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80340c:	83 ec 04             	sub    $0x4,%esp
  80340f:	68 8c 3f 80 00       	push   $0x803f8c
  803414:	6a 26                	push   $0x26
  803416:	68 d8 3f 80 00       	push   $0x803fd8
  80341b:	e8 65 ff ff ff       	call   803385 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803420:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803427:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80342e:	e9 c2 00 00 00       	jmp    8034f5 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  803433:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803436:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80343d:	8b 45 08             	mov    0x8(%ebp),%eax
  803440:	01 d0                	add    %edx,%eax
  803442:	8b 00                	mov    (%eax),%eax
  803444:	85 c0                	test   %eax,%eax
  803446:	75 08                	jne    803450 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  803448:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80344b:	e9 a2 00 00 00       	jmp    8034f2 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  803450:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803457:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80345e:	eb 69                	jmp    8034c9 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803460:	a1 20 50 80 00       	mov    0x805020,%eax
  803465:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80346b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80346e:	89 d0                	mov    %edx,%eax
  803470:	01 c0                	add    %eax,%eax
  803472:	01 d0                	add    %edx,%eax
  803474:	c1 e0 03             	shl    $0x3,%eax
  803477:	01 c8                	add    %ecx,%eax
  803479:	8a 40 04             	mov    0x4(%eax),%al
  80347c:	84 c0                	test   %al,%al
  80347e:	75 46                	jne    8034c6 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803480:	a1 20 50 80 00       	mov    0x805020,%eax
  803485:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80348b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80348e:	89 d0                	mov    %edx,%eax
  803490:	01 c0                	add    %eax,%eax
  803492:	01 d0                	add    %edx,%eax
  803494:	c1 e0 03             	shl    $0x3,%eax
  803497:	01 c8                	add    %ecx,%eax
  803499:	8b 00                	mov    (%eax),%eax
  80349b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80349e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034a1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8034a6:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8034a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034ab:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8034b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b5:	01 c8                	add    %ecx,%eax
  8034b7:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8034b9:	39 c2                	cmp    %eax,%edx
  8034bb:	75 09                	jne    8034c6 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8034bd:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8034c4:	eb 12                	jmp    8034d8 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8034c6:	ff 45 e8             	incl   -0x18(%ebp)
  8034c9:	a1 20 50 80 00       	mov    0x805020,%eax
  8034ce:	8b 50 74             	mov    0x74(%eax),%edx
  8034d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034d4:	39 c2                	cmp    %eax,%edx
  8034d6:	77 88                	ja     803460 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8034d8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8034dc:	75 14                	jne    8034f2 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8034de:	83 ec 04             	sub    $0x4,%esp
  8034e1:	68 e4 3f 80 00       	push   $0x803fe4
  8034e6:	6a 3a                	push   $0x3a
  8034e8:	68 d8 3f 80 00       	push   $0x803fd8
  8034ed:	e8 93 fe ff ff       	call   803385 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8034f2:	ff 45 f0             	incl   -0x10(%ebp)
  8034f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034f8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8034fb:	0f 8c 32 ff ff ff    	jl     803433 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803501:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803508:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80350f:	eb 26                	jmp    803537 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803511:	a1 20 50 80 00       	mov    0x805020,%eax
  803516:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80351c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80351f:	89 d0                	mov    %edx,%eax
  803521:	01 c0                	add    %eax,%eax
  803523:	01 d0                	add    %edx,%eax
  803525:	c1 e0 03             	shl    $0x3,%eax
  803528:	01 c8                	add    %ecx,%eax
  80352a:	8a 40 04             	mov    0x4(%eax),%al
  80352d:	3c 01                	cmp    $0x1,%al
  80352f:	75 03                	jne    803534 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  803531:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803534:	ff 45 e0             	incl   -0x20(%ebp)
  803537:	a1 20 50 80 00       	mov    0x805020,%eax
  80353c:	8b 50 74             	mov    0x74(%eax),%edx
  80353f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803542:	39 c2                	cmp    %eax,%edx
  803544:	77 cb                	ja     803511 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803546:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803549:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80354c:	74 14                	je     803562 <CheckWSWithoutLastIndex+0x16b>
		panic(
  80354e:	83 ec 04             	sub    $0x4,%esp
  803551:	68 38 40 80 00       	push   $0x804038
  803556:	6a 44                	push   $0x44
  803558:	68 d8 3f 80 00       	push   $0x803fd8
  80355d:	e8 23 fe ff ff       	call   803385 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803562:	90                   	nop
  803563:	c9                   	leave  
  803564:	c3                   	ret    
  803565:	66 90                	xchg   %ax,%ax
  803567:	90                   	nop

00803568 <__udivdi3>:
  803568:	55                   	push   %ebp
  803569:	57                   	push   %edi
  80356a:	56                   	push   %esi
  80356b:	53                   	push   %ebx
  80356c:	83 ec 1c             	sub    $0x1c,%esp
  80356f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803573:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803577:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80357b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80357f:	89 ca                	mov    %ecx,%edx
  803581:	89 f8                	mov    %edi,%eax
  803583:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803587:	85 f6                	test   %esi,%esi
  803589:	75 2d                	jne    8035b8 <__udivdi3+0x50>
  80358b:	39 cf                	cmp    %ecx,%edi
  80358d:	77 65                	ja     8035f4 <__udivdi3+0x8c>
  80358f:	89 fd                	mov    %edi,%ebp
  803591:	85 ff                	test   %edi,%edi
  803593:	75 0b                	jne    8035a0 <__udivdi3+0x38>
  803595:	b8 01 00 00 00       	mov    $0x1,%eax
  80359a:	31 d2                	xor    %edx,%edx
  80359c:	f7 f7                	div    %edi
  80359e:	89 c5                	mov    %eax,%ebp
  8035a0:	31 d2                	xor    %edx,%edx
  8035a2:	89 c8                	mov    %ecx,%eax
  8035a4:	f7 f5                	div    %ebp
  8035a6:	89 c1                	mov    %eax,%ecx
  8035a8:	89 d8                	mov    %ebx,%eax
  8035aa:	f7 f5                	div    %ebp
  8035ac:	89 cf                	mov    %ecx,%edi
  8035ae:	89 fa                	mov    %edi,%edx
  8035b0:	83 c4 1c             	add    $0x1c,%esp
  8035b3:	5b                   	pop    %ebx
  8035b4:	5e                   	pop    %esi
  8035b5:	5f                   	pop    %edi
  8035b6:	5d                   	pop    %ebp
  8035b7:	c3                   	ret    
  8035b8:	39 ce                	cmp    %ecx,%esi
  8035ba:	77 28                	ja     8035e4 <__udivdi3+0x7c>
  8035bc:	0f bd fe             	bsr    %esi,%edi
  8035bf:	83 f7 1f             	xor    $0x1f,%edi
  8035c2:	75 40                	jne    803604 <__udivdi3+0x9c>
  8035c4:	39 ce                	cmp    %ecx,%esi
  8035c6:	72 0a                	jb     8035d2 <__udivdi3+0x6a>
  8035c8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8035cc:	0f 87 9e 00 00 00    	ja     803670 <__udivdi3+0x108>
  8035d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8035d7:	89 fa                	mov    %edi,%edx
  8035d9:	83 c4 1c             	add    $0x1c,%esp
  8035dc:	5b                   	pop    %ebx
  8035dd:	5e                   	pop    %esi
  8035de:	5f                   	pop    %edi
  8035df:	5d                   	pop    %ebp
  8035e0:	c3                   	ret    
  8035e1:	8d 76 00             	lea    0x0(%esi),%esi
  8035e4:	31 ff                	xor    %edi,%edi
  8035e6:	31 c0                	xor    %eax,%eax
  8035e8:	89 fa                	mov    %edi,%edx
  8035ea:	83 c4 1c             	add    $0x1c,%esp
  8035ed:	5b                   	pop    %ebx
  8035ee:	5e                   	pop    %esi
  8035ef:	5f                   	pop    %edi
  8035f0:	5d                   	pop    %ebp
  8035f1:	c3                   	ret    
  8035f2:	66 90                	xchg   %ax,%ax
  8035f4:	89 d8                	mov    %ebx,%eax
  8035f6:	f7 f7                	div    %edi
  8035f8:	31 ff                	xor    %edi,%edi
  8035fa:	89 fa                	mov    %edi,%edx
  8035fc:	83 c4 1c             	add    $0x1c,%esp
  8035ff:	5b                   	pop    %ebx
  803600:	5e                   	pop    %esi
  803601:	5f                   	pop    %edi
  803602:	5d                   	pop    %ebp
  803603:	c3                   	ret    
  803604:	bd 20 00 00 00       	mov    $0x20,%ebp
  803609:	89 eb                	mov    %ebp,%ebx
  80360b:	29 fb                	sub    %edi,%ebx
  80360d:	89 f9                	mov    %edi,%ecx
  80360f:	d3 e6                	shl    %cl,%esi
  803611:	89 c5                	mov    %eax,%ebp
  803613:	88 d9                	mov    %bl,%cl
  803615:	d3 ed                	shr    %cl,%ebp
  803617:	89 e9                	mov    %ebp,%ecx
  803619:	09 f1                	or     %esi,%ecx
  80361b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80361f:	89 f9                	mov    %edi,%ecx
  803621:	d3 e0                	shl    %cl,%eax
  803623:	89 c5                	mov    %eax,%ebp
  803625:	89 d6                	mov    %edx,%esi
  803627:	88 d9                	mov    %bl,%cl
  803629:	d3 ee                	shr    %cl,%esi
  80362b:	89 f9                	mov    %edi,%ecx
  80362d:	d3 e2                	shl    %cl,%edx
  80362f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803633:	88 d9                	mov    %bl,%cl
  803635:	d3 e8                	shr    %cl,%eax
  803637:	09 c2                	or     %eax,%edx
  803639:	89 d0                	mov    %edx,%eax
  80363b:	89 f2                	mov    %esi,%edx
  80363d:	f7 74 24 0c          	divl   0xc(%esp)
  803641:	89 d6                	mov    %edx,%esi
  803643:	89 c3                	mov    %eax,%ebx
  803645:	f7 e5                	mul    %ebp
  803647:	39 d6                	cmp    %edx,%esi
  803649:	72 19                	jb     803664 <__udivdi3+0xfc>
  80364b:	74 0b                	je     803658 <__udivdi3+0xf0>
  80364d:	89 d8                	mov    %ebx,%eax
  80364f:	31 ff                	xor    %edi,%edi
  803651:	e9 58 ff ff ff       	jmp    8035ae <__udivdi3+0x46>
  803656:	66 90                	xchg   %ax,%ax
  803658:	8b 54 24 08          	mov    0x8(%esp),%edx
  80365c:	89 f9                	mov    %edi,%ecx
  80365e:	d3 e2                	shl    %cl,%edx
  803660:	39 c2                	cmp    %eax,%edx
  803662:	73 e9                	jae    80364d <__udivdi3+0xe5>
  803664:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803667:	31 ff                	xor    %edi,%edi
  803669:	e9 40 ff ff ff       	jmp    8035ae <__udivdi3+0x46>
  80366e:	66 90                	xchg   %ax,%ax
  803670:	31 c0                	xor    %eax,%eax
  803672:	e9 37 ff ff ff       	jmp    8035ae <__udivdi3+0x46>
  803677:	90                   	nop

00803678 <__umoddi3>:
  803678:	55                   	push   %ebp
  803679:	57                   	push   %edi
  80367a:	56                   	push   %esi
  80367b:	53                   	push   %ebx
  80367c:	83 ec 1c             	sub    $0x1c,%esp
  80367f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803683:	8b 74 24 34          	mov    0x34(%esp),%esi
  803687:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80368b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80368f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803693:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803697:	89 f3                	mov    %esi,%ebx
  803699:	89 fa                	mov    %edi,%edx
  80369b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80369f:	89 34 24             	mov    %esi,(%esp)
  8036a2:	85 c0                	test   %eax,%eax
  8036a4:	75 1a                	jne    8036c0 <__umoddi3+0x48>
  8036a6:	39 f7                	cmp    %esi,%edi
  8036a8:	0f 86 a2 00 00 00    	jbe    803750 <__umoddi3+0xd8>
  8036ae:	89 c8                	mov    %ecx,%eax
  8036b0:	89 f2                	mov    %esi,%edx
  8036b2:	f7 f7                	div    %edi
  8036b4:	89 d0                	mov    %edx,%eax
  8036b6:	31 d2                	xor    %edx,%edx
  8036b8:	83 c4 1c             	add    $0x1c,%esp
  8036bb:	5b                   	pop    %ebx
  8036bc:	5e                   	pop    %esi
  8036bd:	5f                   	pop    %edi
  8036be:	5d                   	pop    %ebp
  8036bf:	c3                   	ret    
  8036c0:	39 f0                	cmp    %esi,%eax
  8036c2:	0f 87 ac 00 00 00    	ja     803774 <__umoddi3+0xfc>
  8036c8:	0f bd e8             	bsr    %eax,%ebp
  8036cb:	83 f5 1f             	xor    $0x1f,%ebp
  8036ce:	0f 84 ac 00 00 00    	je     803780 <__umoddi3+0x108>
  8036d4:	bf 20 00 00 00       	mov    $0x20,%edi
  8036d9:	29 ef                	sub    %ebp,%edi
  8036db:	89 fe                	mov    %edi,%esi
  8036dd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8036e1:	89 e9                	mov    %ebp,%ecx
  8036e3:	d3 e0                	shl    %cl,%eax
  8036e5:	89 d7                	mov    %edx,%edi
  8036e7:	89 f1                	mov    %esi,%ecx
  8036e9:	d3 ef                	shr    %cl,%edi
  8036eb:	09 c7                	or     %eax,%edi
  8036ed:	89 e9                	mov    %ebp,%ecx
  8036ef:	d3 e2                	shl    %cl,%edx
  8036f1:	89 14 24             	mov    %edx,(%esp)
  8036f4:	89 d8                	mov    %ebx,%eax
  8036f6:	d3 e0                	shl    %cl,%eax
  8036f8:	89 c2                	mov    %eax,%edx
  8036fa:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036fe:	d3 e0                	shl    %cl,%eax
  803700:	89 44 24 04          	mov    %eax,0x4(%esp)
  803704:	8b 44 24 08          	mov    0x8(%esp),%eax
  803708:	89 f1                	mov    %esi,%ecx
  80370a:	d3 e8                	shr    %cl,%eax
  80370c:	09 d0                	or     %edx,%eax
  80370e:	d3 eb                	shr    %cl,%ebx
  803710:	89 da                	mov    %ebx,%edx
  803712:	f7 f7                	div    %edi
  803714:	89 d3                	mov    %edx,%ebx
  803716:	f7 24 24             	mull   (%esp)
  803719:	89 c6                	mov    %eax,%esi
  80371b:	89 d1                	mov    %edx,%ecx
  80371d:	39 d3                	cmp    %edx,%ebx
  80371f:	0f 82 87 00 00 00    	jb     8037ac <__umoddi3+0x134>
  803725:	0f 84 91 00 00 00    	je     8037bc <__umoddi3+0x144>
  80372b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80372f:	29 f2                	sub    %esi,%edx
  803731:	19 cb                	sbb    %ecx,%ebx
  803733:	89 d8                	mov    %ebx,%eax
  803735:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803739:	d3 e0                	shl    %cl,%eax
  80373b:	89 e9                	mov    %ebp,%ecx
  80373d:	d3 ea                	shr    %cl,%edx
  80373f:	09 d0                	or     %edx,%eax
  803741:	89 e9                	mov    %ebp,%ecx
  803743:	d3 eb                	shr    %cl,%ebx
  803745:	89 da                	mov    %ebx,%edx
  803747:	83 c4 1c             	add    $0x1c,%esp
  80374a:	5b                   	pop    %ebx
  80374b:	5e                   	pop    %esi
  80374c:	5f                   	pop    %edi
  80374d:	5d                   	pop    %ebp
  80374e:	c3                   	ret    
  80374f:	90                   	nop
  803750:	89 fd                	mov    %edi,%ebp
  803752:	85 ff                	test   %edi,%edi
  803754:	75 0b                	jne    803761 <__umoddi3+0xe9>
  803756:	b8 01 00 00 00       	mov    $0x1,%eax
  80375b:	31 d2                	xor    %edx,%edx
  80375d:	f7 f7                	div    %edi
  80375f:	89 c5                	mov    %eax,%ebp
  803761:	89 f0                	mov    %esi,%eax
  803763:	31 d2                	xor    %edx,%edx
  803765:	f7 f5                	div    %ebp
  803767:	89 c8                	mov    %ecx,%eax
  803769:	f7 f5                	div    %ebp
  80376b:	89 d0                	mov    %edx,%eax
  80376d:	e9 44 ff ff ff       	jmp    8036b6 <__umoddi3+0x3e>
  803772:	66 90                	xchg   %ax,%ax
  803774:	89 c8                	mov    %ecx,%eax
  803776:	89 f2                	mov    %esi,%edx
  803778:	83 c4 1c             	add    $0x1c,%esp
  80377b:	5b                   	pop    %ebx
  80377c:	5e                   	pop    %esi
  80377d:	5f                   	pop    %edi
  80377e:	5d                   	pop    %ebp
  80377f:	c3                   	ret    
  803780:	3b 04 24             	cmp    (%esp),%eax
  803783:	72 06                	jb     80378b <__umoddi3+0x113>
  803785:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803789:	77 0f                	ja     80379a <__umoddi3+0x122>
  80378b:	89 f2                	mov    %esi,%edx
  80378d:	29 f9                	sub    %edi,%ecx
  80378f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803793:	89 14 24             	mov    %edx,(%esp)
  803796:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80379a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80379e:	8b 14 24             	mov    (%esp),%edx
  8037a1:	83 c4 1c             	add    $0x1c,%esp
  8037a4:	5b                   	pop    %ebx
  8037a5:	5e                   	pop    %esi
  8037a6:	5f                   	pop    %edi
  8037a7:	5d                   	pop    %ebp
  8037a8:	c3                   	ret    
  8037a9:	8d 76 00             	lea    0x0(%esi),%esi
  8037ac:	2b 04 24             	sub    (%esp),%eax
  8037af:	19 fa                	sbb    %edi,%edx
  8037b1:	89 d1                	mov    %edx,%ecx
  8037b3:	89 c6                	mov    %eax,%esi
  8037b5:	e9 71 ff ff ff       	jmp    80372b <__umoddi3+0xb3>
  8037ba:	66 90                	xchg   %ax,%ax
  8037bc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8037c0:	72 ea                	jb     8037ac <__umoddi3+0x134>
  8037c2:	89 d9                	mov    %ebx,%ecx
  8037c4:	e9 62 ff ff ff       	jmp    80372b <__umoddi3+0xb3>
