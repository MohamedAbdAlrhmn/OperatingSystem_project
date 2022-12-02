
obj/user/arrayOperations_mergesort:     file format elf32-i386


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
  800031:	e8 3d 04 00 00       	call   800473 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

//int *Left;
//int *Right;

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	int32 parentenvID = sys_getparentenvid();
  80003e:	e8 e1 1a 00 00       	call   801b24 <sys_getparentenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int ret;
	/*[1] GET SHARED VARs*/
	//Get the shared array & its size
	int *numOfElements = NULL;
  800046:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	int *sharedArray = NULL;
  80004d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	sharedArray = sget(parentenvID, "arr") ;
  800054:	83 ec 08             	sub    $0x8,%esp
  800057:	68 40 38 80 00       	push   $0x803840
  80005c:	ff 75 f0             	pushl  -0x10(%ebp)
  80005f:	e8 23 16 00 00       	call   801687 <sget>
  800064:	83 c4 10             	add    $0x10,%esp
  800067:	89 45 e8             	mov    %eax,-0x18(%ebp)
	numOfElements = sget(parentenvID, "arrSize") ;
  80006a:	83 ec 08             	sub    $0x8,%esp
  80006d:	68 44 38 80 00       	push   $0x803844
  800072:	ff 75 f0             	pushl  -0x10(%ebp)
  800075:	e8 0d 16 00 00       	call   801687 <sget>
  80007a:	83 c4 10             	add    $0x10,%esp
  80007d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//PrintElements(sharedArray, *numOfElements);

	//Get the check-finishing counter
	int *finishedCount = NULL;
  800080:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	finishedCount = sget(parentenvID, "finishedCount") ;
  800087:	83 ec 08             	sub    $0x8,%esp
  80008a:	68 4c 38 80 00       	push   $0x80384c
  80008f:	ff 75 f0             	pushl  -0x10(%ebp)
  800092:	e8 f0 15 00 00       	call   801687 <sget>
  800097:	83 c4 10             	add    $0x10,%esp
  80009a:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	/*[2] DO THE JOB*/
	//take a copy from the original array
	int *sortedArray;

	sortedArray = smalloc("mergesortedArr", sizeof(int) * *numOfElements, 0) ;
  80009d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000a0:	8b 00                	mov    (%eax),%eax
  8000a2:	c1 e0 02             	shl    $0x2,%eax
  8000a5:	83 ec 04             	sub    $0x4,%esp
  8000a8:	6a 00                	push   $0x0
  8000aa:	50                   	push   %eax
  8000ab:	68 5a 38 80 00       	push   $0x80385a
  8000b0:	e8 9e 15 00 00       	call   801653 <smalloc>
  8000b5:	83 c4 10             	add    $0x10,%esp
  8000b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8000bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8000c2:	eb 25                	jmp    8000e9 <_main+0xb1>
	{
		sortedArray[i] = sharedArray[i];
  8000c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000c7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000d1:	01 c2                	add    %eax,%edx
  8000d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000d6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8000dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000e0:	01 c8                	add    %ecx,%eax
  8000e2:	8b 00                	mov    (%eax),%eax
  8000e4:	89 02                	mov    %eax,(%edx)
	//take a copy from the original array
	int *sortedArray;

	sortedArray = smalloc("mergesortedArr", sizeof(int) * *numOfElements, 0) ;
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8000e6:	ff 45 f4             	incl   -0xc(%ebp)
  8000e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000ec:	8b 00                	mov    (%eax),%eax
  8000ee:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8000f1:	7f d1                	jg     8000c4 <_main+0x8c>
	}
//	//Create two temps array for "left" & "right"
//	Left = smalloc("mergesortLeftArr", sizeof(int) * (*numOfElements), 1) ;
//	Right = smalloc("mergesortRightArr", sizeof(int) * (*numOfElements), 1) ;

	MSort(sortedArray, 1, *numOfElements);
  8000f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000f6:	8b 00                	mov    (%eax),%eax
  8000f8:	83 ec 04             	sub    $0x4,%esp
  8000fb:	50                   	push   %eax
  8000fc:	6a 01                	push   $0x1
  8000fe:	ff 75 e0             	pushl  -0x20(%ebp)
  800101:	e8 fc 00 00 00       	call   800202 <MSort>
  800106:	83 c4 10             	add    $0x10,%esp
	cprintf("Merge sort is Finished!!!!\n") ;
  800109:	83 ec 0c             	sub    $0xc,%esp
  80010c:	68 69 38 80 00       	push   $0x803869
  800111:	e8 6d 05 00 00       	call   800683 <cprintf>
  800116:	83 c4 10             	add    $0x10,%esp

	/*[3] SHARE THE RESULTS & DECLARE FINISHING*/
	(*finishedCount)++ ;
  800119:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80011c:	8b 00                	mov    (%eax),%eax
  80011e:	8d 50 01             	lea    0x1(%eax),%edx
  800121:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800124:	89 10                	mov    %edx,(%eax)

}
  800126:	90                   	nop
  800127:	c9                   	leave  
  800128:	c3                   	ret    

00800129 <Swap>:

void Swap(int *Elements, int First, int Second)
{
  800129:	55                   	push   %ebp
  80012a:	89 e5                	mov    %esp,%ebp
  80012c:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  80012f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800132:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800139:	8b 45 08             	mov    0x8(%ebp),%eax
  80013c:	01 d0                	add    %edx,%eax
  80013e:	8b 00                	mov    (%eax),%eax
  800140:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800143:	8b 45 0c             	mov    0xc(%ebp),%eax
  800146:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80014d:	8b 45 08             	mov    0x8(%ebp),%eax
  800150:	01 c2                	add    %eax,%edx
  800152:	8b 45 10             	mov    0x10(%ebp),%eax
  800155:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80015c:	8b 45 08             	mov    0x8(%ebp),%eax
  80015f:	01 c8                	add    %ecx,%eax
  800161:	8b 00                	mov    (%eax),%eax
  800163:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800165:	8b 45 10             	mov    0x10(%ebp),%eax
  800168:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80016f:	8b 45 08             	mov    0x8(%ebp),%eax
  800172:	01 c2                	add    %eax,%edx
  800174:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800177:	89 02                	mov    %eax,(%edx)
}
  800179:	90                   	nop
  80017a:	c9                   	leave  
  80017b:	c3                   	ret    

0080017c <PrintElements>:


void PrintElements(int *Elements, int NumOfElements)
{
  80017c:	55                   	push   %ebp
  80017d:	89 e5                	mov    %esp,%ebp
  80017f:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800182:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800189:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800190:	eb 42                	jmp    8001d4 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800192:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800195:	99                   	cltd   
  800196:	f7 7d f0             	idivl  -0x10(%ebp)
  800199:	89 d0                	mov    %edx,%eax
  80019b:	85 c0                	test   %eax,%eax
  80019d:	75 10                	jne    8001af <PrintElements+0x33>
			cprintf("\n");
  80019f:	83 ec 0c             	sub    $0xc,%esp
  8001a2:	68 85 38 80 00       	push   $0x803885
  8001a7:	e8 d7 04 00 00       	call   800683 <cprintf>
  8001ac:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  8001af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8001bc:	01 d0                	add    %edx,%eax
  8001be:	8b 00                	mov    (%eax),%eax
  8001c0:	83 ec 08             	sub    $0x8,%esp
  8001c3:	50                   	push   %eax
  8001c4:	68 87 38 80 00       	push   $0x803887
  8001c9:	e8 b5 04 00 00       	call   800683 <cprintf>
  8001ce:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  8001d1:	ff 45 f4             	incl   -0xc(%ebp)
  8001d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d7:	48                   	dec    %eax
  8001d8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8001db:	7f b5                	jg     800192 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  8001dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001e0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8001ea:	01 d0                	add    %edx,%eax
  8001ec:	8b 00                	mov    (%eax),%eax
  8001ee:	83 ec 08             	sub    $0x8,%esp
  8001f1:	50                   	push   %eax
  8001f2:	68 8c 38 80 00       	push   $0x80388c
  8001f7:	e8 87 04 00 00       	call   800683 <cprintf>
  8001fc:	83 c4 10             	add    $0x10,%esp

}
  8001ff:	90                   	nop
  800200:	c9                   	leave  
  800201:	c3                   	ret    

00800202 <MSort>:


void MSort(int* A, int p, int r)
{
  800202:	55                   	push   %ebp
  800203:	89 e5                	mov    %esp,%ebp
  800205:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  800208:	8b 45 0c             	mov    0xc(%ebp),%eax
  80020b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80020e:	7d 54                	jge    800264 <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  800210:	8b 55 0c             	mov    0xc(%ebp),%edx
  800213:	8b 45 10             	mov    0x10(%ebp),%eax
  800216:	01 d0                	add    %edx,%eax
  800218:	89 c2                	mov    %eax,%edx
  80021a:	c1 ea 1f             	shr    $0x1f,%edx
  80021d:	01 d0                	add    %edx,%eax
  80021f:	d1 f8                	sar    %eax
  800221:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  800224:	83 ec 04             	sub    $0x4,%esp
  800227:	ff 75 f4             	pushl  -0xc(%ebp)
  80022a:	ff 75 0c             	pushl  0xc(%ebp)
  80022d:	ff 75 08             	pushl  0x8(%ebp)
  800230:	e8 cd ff ff ff       	call   800202 <MSort>
  800235:	83 c4 10             	add    $0x10,%esp
//	cprintf("LEFT is sorted: from %d to %d\n", p, q);

	MSort(A, q + 1, r);
  800238:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80023b:	40                   	inc    %eax
  80023c:	83 ec 04             	sub    $0x4,%esp
  80023f:	ff 75 10             	pushl  0x10(%ebp)
  800242:	50                   	push   %eax
  800243:	ff 75 08             	pushl  0x8(%ebp)
  800246:	e8 b7 ff ff ff       	call   800202 <MSort>
  80024b:	83 c4 10             	add    $0x10,%esp
//	cprintf("RIGHT is sorted: from %d to %d\n", q+1, r);

	Merge(A, p, q, r);
  80024e:	ff 75 10             	pushl  0x10(%ebp)
  800251:	ff 75 f4             	pushl  -0xc(%ebp)
  800254:	ff 75 0c             	pushl  0xc(%ebp)
  800257:	ff 75 08             	pushl  0x8(%ebp)
  80025a:	e8 08 00 00 00       	call   800267 <Merge>
  80025f:	83 c4 10             	add    $0x10,%esp
  800262:	eb 01                	jmp    800265 <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  800264:	90                   	nop
//	cprintf("RIGHT is sorted: from %d to %d\n", q+1, r);

	Merge(A, p, q, r);
	//cprintf("[%d %d] + [%d %d] = [%d %d]\n", p, q, q+1, r, p, r);

}
  800265:	c9                   	leave  
  800266:	c3                   	ret    

00800267 <Merge>:

void Merge(int* A, int p, int q, int r)
{
  800267:	55                   	push   %ebp
  800268:	89 e5                	mov    %esp,%ebp
  80026a:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  80026d:	8b 45 10             	mov    0x10(%ebp),%eax
  800270:	2b 45 0c             	sub    0xc(%ebp),%eax
  800273:	40                   	inc    %eax
  800274:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  800277:	8b 45 14             	mov    0x14(%ebp),%eax
  80027a:	2b 45 10             	sub    0x10(%ebp),%eax
  80027d:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  800280:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  800287:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int* Left = malloc(sizeof(int) * leftCapacity);
  80028e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800291:	c1 e0 02             	shl    $0x2,%eax
  800294:	83 ec 0c             	sub    $0xc,%esp
  800297:	50                   	push   %eax
  800298:	e8 6e 13 00 00       	call   80160b <malloc>
  80029d:	83 c4 10             	add    $0x10,%esp
  8002a0:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  8002a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002a6:	c1 e0 02             	shl    $0x2,%eax
  8002a9:	83 ec 0c             	sub    $0xc,%esp
  8002ac:	50                   	push   %eax
  8002ad:	e8 59 13 00 00       	call   80160b <malloc>
  8002b2:	83 c4 10             	add    $0x10,%esp
  8002b5:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  8002b8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8002bf:	eb 2f                	jmp    8002f0 <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  8002c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002ce:	01 c2                	add    %eax,%edx
  8002d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002d6:	01 c8                	add    %ecx,%eax
  8002d8:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8002dd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e7:	01 c8                	add    %ecx,%eax
  8002e9:	8b 00                	mov    (%eax),%eax
  8002eb:	89 02                	mov    %eax,(%edx)
	int* Left = malloc(sizeof(int) * leftCapacity);

	int* Right = malloc(sizeof(int) * rightCapacity);

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  8002ed:	ff 45 ec             	incl   -0x14(%ebp)
  8002f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002f3:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002f6:	7c c9                	jl     8002c1 <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8002f8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8002ff:	eb 2a                	jmp    80032b <Merge+0xc4>
	{
		Right[j] = A[q + j];
  800301:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800304:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80030b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80030e:	01 c2                	add    %eax,%edx
  800310:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800313:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800316:	01 c8                	add    %ecx,%eax
  800318:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80031f:	8b 45 08             	mov    0x8(%ebp),%eax
  800322:	01 c8                	add    %ecx,%eax
  800324:	8b 00                	mov    (%eax),%eax
  800326:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  800328:	ff 45 e8             	incl   -0x18(%ebp)
  80032b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80032e:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800331:	7c ce                	jl     800301 <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  800333:	8b 45 0c             	mov    0xc(%ebp),%eax
  800336:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800339:	e9 0a 01 00 00       	jmp    800448 <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  80033e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800341:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800344:	0f 8d 95 00 00 00    	jge    8003df <Merge+0x178>
  80034a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80034d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800350:	0f 8d 89 00 00 00    	jge    8003df <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800356:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800359:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800360:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800363:	01 d0                	add    %edx,%eax
  800365:	8b 10                	mov    (%eax),%edx
  800367:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80036a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800371:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800374:	01 c8                	add    %ecx,%eax
  800376:	8b 00                	mov    (%eax),%eax
  800378:	39 c2                	cmp    %eax,%edx
  80037a:	7d 33                	jge    8003af <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  80037c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80037f:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800384:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80038b:	8b 45 08             	mov    0x8(%ebp),%eax
  80038e:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800391:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800394:	8d 50 01             	lea    0x1(%eax),%edx
  800397:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80039a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003a1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003a4:	01 d0                	add    %edx,%eax
  8003a6:	8b 00                	mov    (%eax),%eax
  8003a8:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8003aa:	e9 96 00 00 00       	jmp    800445 <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  8003af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003b2:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8003b7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003be:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c1:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8003c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003c7:	8d 50 01             	lea    0x1(%eax),%edx
  8003ca:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8003cd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003d4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003d7:	01 d0                	add    %edx,%eax
  8003d9:	8b 00                	mov    (%eax),%eax
  8003db:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8003dd:	eb 66                	jmp    800445 <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  8003df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003e2:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8003e5:	7d 30                	jge    800417 <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  8003e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003ea:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8003ef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f9:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8003fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003ff:	8d 50 01             	lea    0x1(%eax),%edx
  800402:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800405:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80040c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80040f:	01 d0                	add    %edx,%eax
  800411:	8b 00                	mov    (%eax),%eax
  800413:	89 01                	mov    %eax,(%ecx)
  800415:	eb 2e                	jmp    800445 <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  800417:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80041a:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80041f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800426:	8b 45 08             	mov    0x8(%ebp),%eax
  800429:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80042c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80042f:	8d 50 01             	lea    0x1(%eax),%edx
  800432:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800435:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80043c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80043f:	01 d0                	add    %edx,%eax
  800441:	8b 00                	mov    (%eax),%eax
  800443:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  800445:	ff 45 e4             	incl   -0x1c(%ebp)
  800448:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80044b:	3b 45 14             	cmp    0x14(%ebp),%eax
  80044e:	0f 8e ea fe ff ff    	jle    80033e <Merge+0xd7>
		{
			A[k - 1] = Right[rightIndex++];
		}
	}

	free(Left);
  800454:	83 ec 0c             	sub    $0xc,%esp
  800457:	ff 75 d8             	pushl  -0x28(%ebp)
  80045a:	e8 da 11 00 00       	call   801639 <free>
  80045f:	83 c4 10             	add    $0x10,%esp
	free(Right);
  800462:	83 ec 0c             	sub    $0xc,%esp
  800465:	ff 75 d4             	pushl  -0x2c(%ebp)
  800468:	e8 cc 11 00 00       	call   801639 <free>
  80046d:	83 c4 10             	add    $0x10,%esp

}
  800470:	90                   	nop
  800471:	c9                   	leave  
  800472:	c3                   	ret    

00800473 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800473:	55                   	push   %ebp
  800474:	89 e5                	mov    %esp,%ebp
  800476:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800479:	e8 8d 16 00 00       	call   801b0b <sys_getenvindex>
  80047e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800481:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800484:	89 d0                	mov    %edx,%eax
  800486:	c1 e0 03             	shl    $0x3,%eax
  800489:	01 d0                	add    %edx,%eax
  80048b:	01 c0                	add    %eax,%eax
  80048d:	01 d0                	add    %edx,%eax
  80048f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800496:	01 d0                	add    %edx,%eax
  800498:	c1 e0 04             	shl    $0x4,%eax
  80049b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8004a0:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8004a5:	a1 20 50 80 00       	mov    0x805020,%eax
  8004aa:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8004b0:	84 c0                	test   %al,%al
  8004b2:	74 0f                	je     8004c3 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8004b4:	a1 20 50 80 00       	mov    0x805020,%eax
  8004b9:	05 5c 05 00 00       	add    $0x55c,%eax
  8004be:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8004c7:	7e 0a                	jle    8004d3 <libmain+0x60>
		binaryname = argv[0];
  8004c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004cc:	8b 00                	mov    (%eax),%eax
  8004ce:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8004d3:	83 ec 08             	sub    $0x8,%esp
  8004d6:	ff 75 0c             	pushl  0xc(%ebp)
  8004d9:	ff 75 08             	pushl  0x8(%ebp)
  8004dc:	e8 57 fb ff ff       	call   800038 <_main>
  8004e1:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8004e4:	e8 2f 14 00 00       	call   801918 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8004e9:	83 ec 0c             	sub    $0xc,%esp
  8004ec:	68 a8 38 80 00       	push   $0x8038a8
  8004f1:	e8 8d 01 00 00       	call   800683 <cprintf>
  8004f6:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8004f9:	a1 20 50 80 00       	mov    0x805020,%eax
  8004fe:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800504:	a1 20 50 80 00       	mov    0x805020,%eax
  800509:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80050f:	83 ec 04             	sub    $0x4,%esp
  800512:	52                   	push   %edx
  800513:	50                   	push   %eax
  800514:	68 d0 38 80 00       	push   $0x8038d0
  800519:	e8 65 01 00 00       	call   800683 <cprintf>
  80051e:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800521:	a1 20 50 80 00       	mov    0x805020,%eax
  800526:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80052c:	a1 20 50 80 00       	mov    0x805020,%eax
  800531:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800537:	a1 20 50 80 00       	mov    0x805020,%eax
  80053c:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800542:	51                   	push   %ecx
  800543:	52                   	push   %edx
  800544:	50                   	push   %eax
  800545:	68 f8 38 80 00       	push   $0x8038f8
  80054a:	e8 34 01 00 00       	call   800683 <cprintf>
  80054f:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800552:	a1 20 50 80 00       	mov    0x805020,%eax
  800557:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80055d:	83 ec 08             	sub    $0x8,%esp
  800560:	50                   	push   %eax
  800561:	68 50 39 80 00       	push   $0x803950
  800566:	e8 18 01 00 00       	call   800683 <cprintf>
  80056b:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80056e:	83 ec 0c             	sub    $0xc,%esp
  800571:	68 a8 38 80 00       	push   $0x8038a8
  800576:	e8 08 01 00 00       	call   800683 <cprintf>
  80057b:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80057e:	e8 af 13 00 00       	call   801932 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800583:	e8 19 00 00 00       	call   8005a1 <exit>
}
  800588:	90                   	nop
  800589:	c9                   	leave  
  80058a:	c3                   	ret    

0080058b <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80058b:	55                   	push   %ebp
  80058c:	89 e5                	mov    %esp,%ebp
  80058e:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800591:	83 ec 0c             	sub    $0xc,%esp
  800594:	6a 00                	push   $0x0
  800596:	e8 3c 15 00 00       	call   801ad7 <sys_destroy_env>
  80059b:	83 c4 10             	add    $0x10,%esp
}
  80059e:	90                   	nop
  80059f:	c9                   	leave  
  8005a0:	c3                   	ret    

008005a1 <exit>:

void
exit(void)
{
  8005a1:	55                   	push   %ebp
  8005a2:	89 e5                	mov    %esp,%ebp
  8005a4:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8005a7:	e8 91 15 00 00       	call   801b3d <sys_exit_env>
}
  8005ac:	90                   	nop
  8005ad:	c9                   	leave  
  8005ae:	c3                   	ret    

008005af <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8005af:	55                   	push   %ebp
  8005b0:	89 e5                	mov    %esp,%ebp
  8005b2:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8005b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005b8:	8b 00                	mov    (%eax),%eax
  8005ba:	8d 48 01             	lea    0x1(%eax),%ecx
  8005bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005c0:	89 0a                	mov    %ecx,(%edx)
  8005c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8005c5:	88 d1                	mov    %dl,%cl
  8005c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ca:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8005ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d1:	8b 00                	mov    (%eax),%eax
  8005d3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005d8:	75 2c                	jne    800606 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8005da:	a0 24 50 80 00       	mov    0x805024,%al
  8005df:	0f b6 c0             	movzbl %al,%eax
  8005e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005e5:	8b 12                	mov    (%edx),%edx
  8005e7:	89 d1                	mov    %edx,%ecx
  8005e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ec:	83 c2 08             	add    $0x8,%edx
  8005ef:	83 ec 04             	sub    $0x4,%esp
  8005f2:	50                   	push   %eax
  8005f3:	51                   	push   %ecx
  8005f4:	52                   	push   %edx
  8005f5:	e8 70 11 00 00       	call   80176a <sys_cputs>
  8005fa:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800600:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800606:	8b 45 0c             	mov    0xc(%ebp),%eax
  800609:	8b 40 04             	mov    0x4(%eax),%eax
  80060c:	8d 50 01             	lea    0x1(%eax),%edx
  80060f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800612:	89 50 04             	mov    %edx,0x4(%eax)
}
  800615:	90                   	nop
  800616:	c9                   	leave  
  800617:	c3                   	ret    

00800618 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800618:	55                   	push   %ebp
  800619:	89 e5                	mov    %esp,%ebp
  80061b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800621:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800628:	00 00 00 
	b.cnt = 0;
  80062b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800632:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800635:	ff 75 0c             	pushl  0xc(%ebp)
  800638:	ff 75 08             	pushl  0x8(%ebp)
  80063b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800641:	50                   	push   %eax
  800642:	68 af 05 80 00       	push   $0x8005af
  800647:	e8 11 02 00 00       	call   80085d <vprintfmt>
  80064c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80064f:	a0 24 50 80 00       	mov    0x805024,%al
  800654:	0f b6 c0             	movzbl %al,%eax
  800657:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80065d:	83 ec 04             	sub    $0x4,%esp
  800660:	50                   	push   %eax
  800661:	52                   	push   %edx
  800662:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800668:	83 c0 08             	add    $0x8,%eax
  80066b:	50                   	push   %eax
  80066c:	e8 f9 10 00 00       	call   80176a <sys_cputs>
  800671:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800674:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  80067b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800681:	c9                   	leave  
  800682:	c3                   	ret    

00800683 <cprintf>:

int cprintf(const char *fmt, ...) {
  800683:	55                   	push   %ebp
  800684:	89 e5                	mov    %esp,%ebp
  800686:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800689:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800690:	8d 45 0c             	lea    0xc(%ebp),%eax
  800693:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800696:	8b 45 08             	mov    0x8(%ebp),%eax
  800699:	83 ec 08             	sub    $0x8,%esp
  80069c:	ff 75 f4             	pushl  -0xc(%ebp)
  80069f:	50                   	push   %eax
  8006a0:	e8 73 ff ff ff       	call   800618 <vcprintf>
  8006a5:	83 c4 10             	add    $0x10,%esp
  8006a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006ae:	c9                   	leave  
  8006af:	c3                   	ret    

008006b0 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8006b0:	55                   	push   %ebp
  8006b1:	89 e5                	mov    %esp,%ebp
  8006b3:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8006b6:	e8 5d 12 00 00       	call   801918 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8006bb:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006be:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c4:	83 ec 08             	sub    $0x8,%esp
  8006c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8006ca:	50                   	push   %eax
  8006cb:	e8 48 ff ff ff       	call   800618 <vcprintf>
  8006d0:	83 c4 10             	add    $0x10,%esp
  8006d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8006d6:	e8 57 12 00 00       	call   801932 <sys_enable_interrupt>
	return cnt;
  8006db:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006de:	c9                   	leave  
  8006df:	c3                   	ret    

008006e0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006e0:	55                   	push   %ebp
  8006e1:	89 e5                	mov    %esp,%ebp
  8006e3:	53                   	push   %ebx
  8006e4:	83 ec 14             	sub    $0x14,%esp
  8006e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8006ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006f3:	8b 45 18             	mov    0x18(%ebp),%eax
  8006f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8006fb:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006fe:	77 55                	ja     800755 <printnum+0x75>
  800700:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800703:	72 05                	jb     80070a <printnum+0x2a>
  800705:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800708:	77 4b                	ja     800755 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80070a:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80070d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800710:	8b 45 18             	mov    0x18(%ebp),%eax
  800713:	ba 00 00 00 00       	mov    $0x0,%edx
  800718:	52                   	push   %edx
  800719:	50                   	push   %eax
  80071a:	ff 75 f4             	pushl  -0xc(%ebp)
  80071d:	ff 75 f0             	pushl  -0x10(%ebp)
  800720:	e8 ab 2e 00 00       	call   8035d0 <__udivdi3>
  800725:	83 c4 10             	add    $0x10,%esp
  800728:	83 ec 04             	sub    $0x4,%esp
  80072b:	ff 75 20             	pushl  0x20(%ebp)
  80072e:	53                   	push   %ebx
  80072f:	ff 75 18             	pushl  0x18(%ebp)
  800732:	52                   	push   %edx
  800733:	50                   	push   %eax
  800734:	ff 75 0c             	pushl  0xc(%ebp)
  800737:	ff 75 08             	pushl  0x8(%ebp)
  80073a:	e8 a1 ff ff ff       	call   8006e0 <printnum>
  80073f:	83 c4 20             	add    $0x20,%esp
  800742:	eb 1a                	jmp    80075e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800744:	83 ec 08             	sub    $0x8,%esp
  800747:	ff 75 0c             	pushl  0xc(%ebp)
  80074a:	ff 75 20             	pushl  0x20(%ebp)
  80074d:	8b 45 08             	mov    0x8(%ebp),%eax
  800750:	ff d0                	call   *%eax
  800752:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800755:	ff 4d 1c             	decl   0x1c(%ebp)
  800758:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80075c:	7f e6                	jg     800744 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80075e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800761:	bb 00 00 00 00       	mov    $0x0,%ebx
  800766:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800769:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80076c:	53                   	push   %ebx
  80076d:	51                   	push   %ecx
  80076e:	52                   	push   %edx
  80076f:	50                   	push   %eax
  800770:	e8 6b 2f 00 00       	call   8036e0 <__umoddi3>
  800775:	83 c4 10             	add    $0x10,%esp
  800778:	05 94 3b 80 00       	add    $0x803b94,%eax
  80077d:	8a 00                	mov    (%eax),%al
  80077f:	0f be c0             	movsbl %al,%eax
  800782:	83 ec 08             	sub    $0x8,%esp
  800785:	ff 75 0c             	pushl  0xc(%ebp)
  800788:	50                   	push   %eax
  800789:	8b 45 08             	mov    0x8(%ebp),%eax
  80078c:	ff d0                	call   *%eax
  80078e:	83 c4 10             	add    $0x10,%esp
}
  800791:	90                   	nop
  800792:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800795:	c9                   	leave  
  800796:	c3                   	ret    

00800797 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800797:	55                   	push   %ebp
  800798:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80079a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80079e:	7e 1c                	jle    8007bc <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a3:	8b 00                	mov    (%eax),%eax
  8007a5:	8d 50 08             	lea    0x8(%eax),%edx
  8007a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ab:	89 10                	mov    %edx,(%eax)
  8007ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b0:	8b 00                	mov    (%eax),%eax
  8007b2:	83 e8 08             	sub    $0x8,%eax
  8007b5:	8b 50 04             	mov    0x4(%eax),%edx
  8007b8:	8b 00                	mov    (%eax),%eax
  8007ba:	eb 40                	jmp    8007fc <getuint+0x65>
	else if (lflag)
  8007bc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007c0:	74 1e                	je     8007e0 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c5:	8b 00                	mov    (%eax),%eax
  8007c7:	8d 50 04             	lea    0x4(%eax),%edx
  8007ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cd:	89 10                	mov    %edx,(%eax)
  8007cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d2:	8b 00                	mov    (%eax),%eax
  8007d4:	83 e8 04             	sub    $0x4,%eax
  8007d7:	8b 00                	mov    (%eax),%eax
  8007d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8007de:	eb 1c                	jmp    8007fc <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8007e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e3:	8b 00                	mov    (%eax),%eax
  8007e5:	8d 50 04             	lea    0x4(%eax),%edx
  8007e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007eb:	89 10                	mov    %edx,(%eax)
  8007ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f0:	8b 00                	mov    (%eax),%eax
  8007f2:	83 e8 04             	sub    $0x4,%eax
  8007f5:	8b 00                	mov    (%eax),%eax
  8007f7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007fc:	5d                   	pop    %ebp
  8007fd:	c3                   	ret    

008007fe <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007fe:	55                   	push   %ebp
  8007ff:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800801:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800805:	7e 1c                	jle    800823 <getint+0x25>
		return va_arg(*ap, long long);
  800807:	8b 45 08             	mov    0x8(%ebp),%eax
  80080a:	8b 00                	mov    (%eax),%eax
  80080c:	8d 50 08             	lea    0x8(%eax),%edx
  80080f:	8b 45 08             	mov    0x8(%ebp),%eax
  800812:	89 10                	mov    %edx,(%eax)
  800814:	8b 45 08             	mov    0x8(%ebp),%eax
  800817:	8b 00                	mov    (%eax),%eax
  800819:	83 e8 08             	sub    $0x8,%eax
  80081c:	8b 50 04             	mov    0x4(%eax),%edx
  80081f:	8b 00                	mov    (%eax),%eax
  800821:	eb 38                	jmp    80085b <getint+0x5d>
	else if (lflag)
  800823:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800827:	74 1a                	je     800843 <getint+0x45>
		return va_arg(*ap, long);
  800829:	8b 45 08             	mov    0x8(%ebp),%eax
  80082c:	8b 00                	mov    (%eax),%eax
  80082e:	8d 50 04             	lea    0x4(%eax),%edx
  800831:	8b 45 08             	mov    0x8(%ebp),%eax
  800834:	89 10                	mov    %edx,(%eax)
  800836:	8b 45 08             	mov    0x8(%ebp),%eax
  800839:	8b 00                	mov    (%eax),%eax
  80083b:	83 e8 04             	sub    $0x4,%eax
  80083e:	8b 00                	mov    (%eax),%eax
  800840:	99                   	cltd   
  800841:	eb 18                	jmp    80085b <getint+0x5d>
	else
		return va_arg(*ap, int);
  800843:	8b 45 08             	mov    0x8(%ebp),%eax
  800846:	8b 00                	mov    (%eax),%eax
  800848:	8d 50 04             	lea    0x4(%eax),%edx
  80084b:	8b 45 08             	mov    0x8(%ebp),%eax
  80084e:	89 10                	mov    %edx,(%eax)
  800850:	8b 45 08             	mov    0x8(%ebp),%eax
  800853:	8b 00                	mov    (%eax),%eax
  800855:	83 e8 04             	sub    $0x4,%eax
  800858:	8b 00                	mov    (%eax),%eax
  80085a:	99                   	cltd   
}
  80085b:	5d                   	pop    %ebp
  80085c:	c3                   	ret    

0080085d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80085d:	55                   	push   %ebp
  80085e:	89 e5                	mov    %esp,%ebp
  800860:	56                   	push   %esi
  800861:	53                   	push   %ebx
  800862:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800865:	eb 17                	jmp    80087e <vprintfmt+0x21>
			if (ch == '\0')
  800867:	85 db                	test   %ebx,%ebx
  800869:	0f 84 af 03 00 00    	je     800c1e <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80086f:	83 ec 08             	sub    $0x8,%esp
  800872:	ff 75 0c             	pushl  0xc(%ebp)
  800875:	53                   	push   %ebx
  800876:	8b 45 08             	mov    0x8(%ebp),%eax
  800879:	ff d0                	call   *%eax
  80087b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80087e:	8b 45 10             	mov    0x10(%ebp),%eax
  800881:	8d 50 01             	lea    0x1(%eax),%edx
  800884:	89 55 10             	mov    %edx,0x10(%ebp)
  800887:	8a 00                	mov    (%eax),%al
  800889:	0f b6 d8             	movzbl %al,%ebx
  80088c:	83 fb 25             	cmp    $0x25,%ebx
  80088f:	75 d6                	jne    800867 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800891:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800895:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80089c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008a3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008aa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8008b4:	8d 50 01             	lea    0x1(%eax),%edx
  8008b7:	89 55 10             	mov    %edx,0x10(%ebp)
  8008ba:	8a 00                	mov    (%eax),%al
  8008bc:	0f b6 d8             	movzbl %al,%ebx
  8008bf:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008c2:	83 f8 55             	cmp    $0x55,%eax
  8008c5:	0f 87 2b 03 00 00    	ja     800bf6 <vprintfmt+0x399>
  8008cb:	8b 04 85 b8 3b 80 00 	mov    0x803bb8(,%eax,4),%eax
  8008d2:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008d4:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8008d8:	eb d7                	jmp    8008b1 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008da:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8008de:	eb d1                	jmp    8008b1 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008e0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8008e7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008ea:	89 d0                	mov    %edx,%eax
  8008ec:	c1 e0 02             	shl    $0x2,%eax
  8008ef:	01 d0                	add    %edx,%eax
  8008f1:	01 c0                	add    %eax,%eax
  8008f3:	01 d8                	add    %ebx,%eax
  8008f5:	83 e8 30             	sub    $0x30,%eax
  8008f8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8008fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8008fe:	8a 00                	mov    (%eax),%al
  800900:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800903:	83 fb 2f             	cmp    $0x2f,%ebx
  800906:	7e 3e                	jle    800946 <vprintfmt+0xe9>
  800908:	83 fb 39             	cmp    $0x39,%ebx
  80090b:	7f 39                	jg     800946 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80090d:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800910:	eb d5                	jmp    8008e7 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800912:	8b 45 14             	mov    0x14(%ebp),%eax
  800915:	83 c0 04             	add    $0x4,%eax
  800918:	89 45 14             	mov    %eax,0x14(%ebp)
  80091b:	8b 45 14             	mov    0x14(%ebp),%eax
  80091e:	83 e8 04             	sub    $0x4,%eax
  800921:	8b 00                	mov    (%eax),%eax
  800923:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800926:	eb 1f                	jmp    800947 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800928:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80092c:	79 83                	jns    8008b1 <vprintfmt+0x54>
				width = 0;
  80092e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800935:	e9 77 ff ff ff       	jmp    8008b1 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80093a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800941:	e9 6b ff ff ff       	jmp    8008b1 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800946:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800947:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80094b:	0f 89 60 ff ff ff    	jns    8008b1 <vprintfmt+0x54>
				width = precision, precision = -1;
  800951:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800954:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800957:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80095e:	e9 4e ff ff ff       	jmp    8008b1 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800963:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800966:	e9 46 ff ff ff       	jmp    8008b1 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80096b:	8b 45 14             	mov    0x14(%ebp),%eax
  80096e:	83 c0 04             	add    $0x4,%eax
  800971:	89 45 14             	mov    %eax,0x14(%ebp)
  800974:	8b 45 14             	mov    0x14(%ebp),%eax
  800977:	83 e8 04             	sub    $0x4,%eax
  80097a:	8b 00                	mov    (%eax),%eax
  80097c:	83 ec 08             	sub    $0x8,%esp
  80097f:	ff 75 0c             	pushl  0xc(%ebp)
  800982:	50                   	push   %eax
  800983:	8b 45 08             	mov    0x8(%ebp),%eax
  800986:	ff d0                	call   *%eax
  800988:	83 c4 10             	add    $0x10,%esp
			break;
  80098b:	e9 89 02 00 00       	jmp    800c19 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800990:	8b 45 14             	mov    0x14(%ebp),%eax
  800993:	83 c0 04             	add    $0x4,%eax
  800996:	89 45 14             	mov    %eax,0x14(%ebp)
  800999:	8b 45 14             	mov    0x14(%ebp),%eax
  80099c:	83 e8 04             	sub    $0x4,%eax
  80099f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009a1:	85 db                	test   %ebx,%ebx
  8009a3:	79 02                	jns    8009a7 <vprintfmt+0x14a>
				err = -err;
  8009a5:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009a7:	83 fb 64             	cmp    $0x64,%ebx
  8009aa:	7f 0b                	jg     8009b7 <vprintfmt+0x15a>
  8009ac:	8b 34 9d 00 3a 80 00 	mov    0x803a00(,%ebx,4),%esi
  8009b3:	85 f6                	test   %esi,%esi
  8009b5:	75 19                	jne    8009d0 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009b7:	53                   	push   %ebx
  8009b8:	68 a5 3b 80 00       	push   $0x803ba5
  8009bd:	ff 75 0c             	pushl  0xc(%ebp)
  8009c0:	ff 75 08             	pushl  0x8(%ebp)
  8009c3:	e8 5e 02 00 00       	call   800c26 <printfmt>
  8009c8:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009cb:	e9 49 02 00 00       	jmp    800c19 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009d0:	56                   	push   %esi
  8009d1:	68 ae 3b 80 00       	push   $0x803bae
  8009d6:	ff 75 0c             	pushl  0xc(%ebp)
  8009d9:	ff 75 08             	pushl  0x8(%ebp)
  8009dc:	e8 45 02 00 00       	call   800c26 <printfmt>
  8009e1:	83 c4 10             	add    $0x10,%esp
			break;
  8009e4:	e9 30 02 00 00       	jmp    800c19 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ec:	83 c0 04             	add    $0x4,%eax
  8009ef:	89 45 14             	mov    %eax,0x14(%ebp)
  8009f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f5:	83 e8 04             	sub    $0x4,%eax
  8009f8:	8b 30                	mov    (%eax),%esi
  8009fa:	85 f6                	test   %esi,%esi
  8009fc:	75 05                	jne    800a03 <vprintfmt+0x1a6>
				p = "(null)";
  8009fe:	be b1 3b 80 00       	mov    $0x803bb1,%esi
			if (width > 0 && padc != '-')
  800a03:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a07:	7e 6d                	jle    800a76 <vprintfmt+0x219>
  800a09:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a0d:	74 67                	je     800a76 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a12:	83 ec 08             	sub    $0x8,%esp
  800a15:	50                   	push   %eax
  800a16:	56                   	push   %esi
  800a17:	e8 0c 03 00 00       	call   800d28 <strnlen>
  800a1c:	83 c4 10             	add    $0x10,%esp
  800a1f:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a22:	eb 16                	jmp    800a3a <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a24:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a28:	83 ec 08             	sub    $0x8,%esp
  800a2b:	ff 75 0c             	pushl  0xc(%ebp)
  800a2e:	50                   	push   %eax
  800a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a32:	ff d0                	call   *%eax
  800a34:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a37:	ff 4d e4             	decl   -0x1c(%ebp)
  800a3a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a3e:	7f e4                	jg     800a24 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a40:	eb 34                	jmp    800a76 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a42:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a46:	74 1c                	je     800a64 <vprintfmt+0x207>
  800a48:	83 fb 1f             	cmp    $0x1f,%ebx
  800a4b:	7e 05                	jle    800a52 <vprintfmt+0x1f5>
  800a4d:	83 fb 7e             	cmp    $0x7e,%ebx
  800a50:	7e 12                	jle    800a64 <vprintfmt+0x207>
					putch('?', putdat);
  800a52:	83 ec 08             	sub    $0x8,%esp
  800a55:	ff 75 0c             	pushl  0xc(%ebp)
  800a58:	6a 3f                	push   $0x3f
  800a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5d:	ff d0                	call   *%eax
  800a5f:	83 c4 10             	add    $0x10,%esp
  800a62:	eb 0f                	jmp    800a73 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a64:	83 ec 08             	sub    $0x8,%esp
  800a67:	ff 75 0c             	pushl  0xc(%ebp)
  800a6a:	53                   	push   %ebx
  800a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6e:	ff d0                	call   *%eax
  800a70:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a73:	ff 4d e4             	decl   -0x1c(%ebp)
  800a76:	89 f0                	mov    %esi,%eax
  800a78:	8d 70 01             	lea    0x1(%eax),%esi
  800a7b:	8a 00                	mov    (%eax),%al
  800a7d:	0f be d8             	movsbl %al,%ebx
  800a80:	85 db                	test   %ebx,%ebx
  800a82:	74 24                	je     800aa8 <vprintfmt+0x24b>
  800a84:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a88:	78 b8                	js     800a42 <vprintfmt+0x1e5>
  800a8a:	ff 4d e0             	decl   -0x20(%ebp)
  800a8d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a91:	79 af                	jns    800a42 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a93:	eb 13                	jmp    800aa8 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a95:	83 ec 08             	sub    $0x8,%esp
  800a98:	ff 75 0c             	pushl  0xc(%ebp)
  800a9b:	6a 20                	push   $0x20
  800a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa0:	ff d0                	call   *%eax
  800aa2:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800aa5:	ff 4d e4             	decl   -0x1c(%ebp)
  800aa8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800aac:	7f e7                	jg     800a95 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800aae:	e9 66 01 00 00       	jmp    800c19 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ab3:	83 ec 08             	sub    $0x8,%esp
  800ab6:	ff 75 e8             	pushl  -0x18(%ebp)
  800ab9:	8d 45 14             	lea    0x14(%ebp),%eax
  800abc:	50                   	push   %eax
  800abd:	e8 3c fd ff ff       	call   8007fe <getint>
  800ac2:	83 c4 10             	add    $0x10,%esp
  800ac5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ac8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800acb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ace:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ad1:	85 d2                	test   %edx,%edx
  800ad3:	79 23                	jns    800af8 <vprintfmt+0x29b>
				putch('-', putdat);
  800ad5:	83 ec 08             	sub    $0x8,%esp
  800ad8:	ff 75 0c             	pushl  0xc(%ebp)
  800adb:	6a 2d                	push   $0x2d
  800add:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae0:	ff d0                	call   *%eax
  800ae2:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ae5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ae8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800aeb:	f7 d8                	neg    %eax
  800aed:	83 d2 00             	adc    $0x0,%edx
  800af0:	f7 da                	neg    %edx
  800af2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800af5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800af8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800aff:	e9 bc 00 00 00       	jmp    800bc0 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b04:	83 ec 08             	sub    $0x8,%esp
  800b07:	ff 75 e8             	pushl  -0x18(%ebp)
  800b0a:	8d 45 14             	lea    0x14(%ebp),%eax
  800b0d:	50                   	push   %eax
  800b0e:	e8 84 fc ff ff       	call   800797 <getuint>
  800b13:	83 c4 10             	add    $0x10,%esp
  800b16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b19:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b1c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b23:	e9 98 00 00 00       	jmp    800bc0 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b28:	83 ec 08             	sub    $0x8,%esp
  800b2b:	ff 75 0c             	pushl  0xc(%ebp)
  800b2e:	6a 58                	push   $0x58
  800b30:	8b 45 08             	mov    0x8(%ebp),%eax
  800b33:	ff d0                	call   *%eax
  800b35:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b38:	83 ec 08             	sub    $0x8,%esp
  800b3b:	ff 75 0c             	pushl  0xc(%ebp)
  800b3e:	6a 58                	push   $0x58
  800b40:	8b 45 08             	mov    0x8(%ebp),%eax
  800b43:	ff d0                	call   *%eax
  800b45:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b48:	83 ec 08             	sub    $0x8,%esp
  800b4b:	ff 75 0c             	pushl  0xc(%ebp)
  800b4e:	6a 58                	push   $0x58
  800b50:	8b 45 08             	mov    0x8(%ebp),%eax
  800b53:	ff d0                	call   *%eax
  800b55:	83 c4 10             	add    $0x10,%esp
			break;
  800b58:	e9 bc 00 00 00       	jmp    800c19 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b5d:	83 ec 08             	sub    $0x8,%esp
  800b60:	ff 75 0c             	pushl  0xc(%ebp)
  800b63:	6a 30                	push   $0x30
  800b65:	8b 45 08             	mov    0x8(%ebp),%eax
  800b68:	ff d0                	call   *%eax
  800b6a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b6d:	83 ec 08             	sub    $0x8,%esp
  800b70:	ff 75 0c             	pushl  0xc(%ebp)
  800b73:	6a 78                	push   $0x78
  800b75:	8b 45 08             	mov    0x8(%ebp),%eax
  800b78:	ff d0                	call   *%eax
  800b7a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b80:	83 c0 04             	add    $0x4,%eax
  800b83:	89 45 14             	mov    %eax,0x14(%ebp)
  800b86:	8b 45 14             	mov    0x14(%ebp),%eax
  800b89:	83 e8 04             	sub    $0x4,%eax
  800b8c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b91:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b98:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b9f:	eb 1f                	jmp    800bc0 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ba1:	83 ec 08             	sub    $0x8,%esp
  800ba4:	ff 75 e8             	pushl  -0x18(%ebp)
  800ba7:	8d 45 14             	lea    0x14(%ebp),%eax
  800baa:	50                   	push   %eax
  800bab:	e8 e7 fb ff ff       	call   800797 <getuint>
  800bb0:	83 c4 10             	add    $0x10,%esp
  800bb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800bb9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bc0:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800bc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bc7:	83 ec 04             	sub    $0x4,%esp
  800bca:	52                   	push   %edx
  800bcb:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bce:	50                   	push   %eax
  800bcf:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd2:	ff 75 f0             	pushl  -0x10(%ebp)
  800bd5:	ff 75 0c             	pushl  0xc(%ebp)
  800bd8:	ff 75 08             	pushl  0x8(%ebp)
  800bdb:	e8 00 fb ff ff       	call   8006e0 <printnum>
  800be0:	83 c4 20             	add    $0x20,%esp
			break;
  800be3:	eb 34                	jmp    800c19 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800be5:	83 ec 08             	sub    $0x8,%esp
  800be8:	ff 75 0c             	pushl  0xc(%ebp)
  800beb:	53                   	push   %ebx
  800bec:	8b 45 08             	mov    0x8(%ebp),%eax
  800bef:	ff d0                	call   *%eax
  800bf1:	83 c4 10             	add    $0x10,%esp
			break;
  800bf4:	eb 23                	jmp    800c19 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bf6:	83 ec 08             	sub    $0x8,%esp
  800bf9:	ff 75 0c             	pushl  0xc(%ebp)
  800bfc:	6a 25                	push   $0x25
  800bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800c01:	ff d0                	call   *%eax
  800c03:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c06:	ff 4d 10             	decl   0x10(%ebp)
  800c09:	eb 03                	jmp    800c0e <vprintfmt+0x3b1>
  800c0b:	ff 4d 10             	decl   0x10(%ebp)
  800c0e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c11:	48                   	dec    %eax
  800c12:	8a 00                	mov    (%eax),%al
  800c14:	3c 25                	cmp    $0x25,%al
  800c16:	75 f3                	jne    800c0b <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800c18:	90                   	nop
		}
	}
  800c19:	e9 47 fc ff ff       	jmp    800865 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c1e:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c1f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c22:	5b                   	pop    %ebx
  800c23:	5e                   	pop    %esi
  800c24:	5d                   	pop    %ebp
  800c25:	c3                   	ret    

00800c26 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c26:	55                   	push   %ebp
  800c27:	89 e5                	mov    %esp,%ebp
  800c29:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c2c:	8d 45 10             	lea    0x10(%ebp),%eax
  800c2f:	83 c0 04             	add    $0x4,%eax
  800c32:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c35:	8b 45 10             	mov    0x10(%ebp),%eax
  800c38:	ff 75 f4             	pushl  -0xc(%ebp)
  800c3b:	50                   	push   %eax
  800c3c:	ff 75 0c             	pushl  0xc(%ebp)
  800c3f:	ff 75 08             	pushl  0x8(%ebp)
  800c42:	e8 16 fc ff ff       	call   80085d <vprintfmt>
  800c47:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c4a:	90                   	nop
  800c4b:	c9                   	leave  
  800c4c:	c3                   	ret    

00800c4d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c4d:	55                   	push   %ebp
  800c4e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c53:	8b 40 08             	mov    0x8(%eax),%eax
  800c56:	8d 50 01             	lea    0x1(%eax),%edx
  800c59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c62:	8b 10                	mov    (%eax),%edx
  800c64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c67:	8b 40 04             	mov    0x4(%eax),%eax
  800c6a:	39 c2                	cmp    %eax,%edx
  800c6c:	73 12                	jae    800c80 <sprintputch+0x33>
		*b->buf++ = ch;
  800c6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c71:	8b 00                	mov    (%eax),%eax
  800c73:	8d 48 01             	lea    0x1(%eax),%ecx
  800c76:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c79:	89 0a                	mov    %ecx,(%edx)
  800c7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7e:	88 10                	mov    %dl,(%eax)
}
  800c80:	90                   	nop
  800c81:	5d                   	pop    %ebp
  800c82:	c3                   	ret    

00800c83 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c83:	55                   	push   %ebp
  800c84:	89 e5                	mov    %esp,%ebp
  800c86:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c89:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c92:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c95:	8b 45 08             	mov    0x8(%ebp),%eax
  800c98:	01 d0                	add    %edx,%eax
  800c9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c9d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ca4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ca8:	74 06                	je     800cb0 <vsnprintf+0x2d>
  800caa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cae:	7f 07                	jg     800cb7 <vsnprintf+0x34>
		return -E_INVAL;
  800cb0:	b8 03 00 00 00       	mov    $0x3,%eax
  800cb5:	eb 20                	jmp    800cd7 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800cb7:	ff 75 14             	pushl  0x14(%ebp)
  800cba:	ff 75 10             	pushl  0x10(%ebp)
  800cbd:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800cc0:	50                   	push   %eax
  800cc1:	68 4d 0c 80 00       	push   $0x800c4d
  800cc6:	e8 92 fb ff ff       	call   80085d <vprintfmt>
  800ccb:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800cce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cd1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800cd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800cd7:	c9                   	leave  
  800cd8:	c3                   	ret    

00800cd9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cd9:	55                   	push   %ebp
  800cda:	89 e5                	mov    %esp,%ebp
  800cdc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800cdf:	8d 45 10             	lea    0x10(%ebp),%eax
  800ce2:	83 c0 04             	add    $0x4,%eax
  800ce5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ce8:	8b 45 10             	mov    0x10(%ebp),%eax
  800ceb:	ff 75 f4             	pushl  -0xc(%ebp)
  800cee:	50                   	push   %eax
  800cef:	ff 75 0c             	pushl  0xc(%ebp)
  800cf2:	ff 75 08             	pushl  0x8(%ebp)
  800cf5:	e8 89 ff ff ff       	call   800c83 <vsnprintf>
  800cfa:	83 c4 10             	add    $0x10,%esp
  800cfd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d00:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d03:	c9                   	leave  
  800d04:	c3                   	ret    

00800d05 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800d05:	55                   	push   %ebp
  800d06:	89 e5                	mov    %esp,%ebp
  800d08:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d0b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d12:	eb 06                	jmp    800d1a <strlen+0x15>
		n++;
  800d14:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d17:	ff 45 08             	incl   0x8(%ebp)
  800d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1d:	8a 00                	mov    (%eax),%al
  800d1f:	84 c0                	test   %al,%al
  800d21:	75 f1                	jne    800d14 <strlen+0xf>
		n++;
	return n;
  800d23:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d26:	c9                   	leave  
  800d27:	c3                   	ret    

00800d28 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d28:	55                   	push   %ebp
  800d29:	89 e5                	mov    %esp,%ebp
  800d2b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d2e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d35:	eb 09                	jmp    800d40 <strnlen+0x18>
		n++;
  800d37:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d3a:	ff 45 08             	incl   0x8(%ebp)
  800d3d:	ff 4d 0c             	decl   0xc(%ebp)
  800d40:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d44:	74 09                	je     800d4f <strnlen+0x27>
  800d46:	8b 45 08             	mov    0x8(%ebp),%eax
  800d49:	8a 00                	mov    (%eax),%al
  800d4b:	84 c0                	test   %al,%al
  800d4d:	75 e8                	jne    800d37 <strnlen+0xf>
		n++;
	return n;
  800d4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d52:	c9                   	leave  
  800d53:	c3                   	ret    

00800d54 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d54:	55                   	push   %ebp
  800d55:	89 e5                	mov    %esp,%ebp
  800d57:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d60:	90                   	nop
  800d61:	8b 45 08             	mov    0x8(%ebp),%eax
  800d64:	8d 50 01             	lea    0x1(%eax),%edx
  800d67:	89 55 08             	mov    %edx,0x8(%ebp)
  800d6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d6d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d70:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d73:	8a 12                	mov    (%edx),%dl
  800d75:	88 10                	mov    %dl,(%eax)
  800d77:	8a 00                	mov    (%eax),%al
  800d79:	84 c0                	test   %al,%al
  800d7b:	75 e4                	jne    800d61 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d80:	c9                   	leave  
  800d81:	c3                   	ret    

00800d82 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d82:	55                   	push   %ebp
  800d83:	89 e5                	mov    %esp,%ebp
  800d85:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d8e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d95:	eb 1f                	jmp    800db6 <strncpy+0x34>
		*dst++ = *src;
  800d97:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9a:	8d 50 01             	lea    0x1(%eax),%edx
  800d9d:	89 55 08             	mov    %edx,0x8(%ebp)
  800da0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800da3:	8a 12                	mov    (%edx),%dl
  800da5:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800da7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800daa:	8a 00                	mov    (%eax),%al
  800dac:	84 c0                	test   %al,%al
  800dae:	74 03                	je     800db3 <strncpy+0x31>
			src++;
  800db0:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800db3:	ff 45 fc             	incl   -0x4(%ebp)
  800db6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800db9:	3b 45 10             	cmp    0x10(%ebp),%eax
  800dbc:	72 d9                	jb     800d97 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800dbe:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800dc1:	c9                   	leave  
  800dc2:	c3                   	ret    

00800dc3 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800dc3:	55                   	push   %ebp
  800dc4:	89 e5                	mov    %esp,%ebp
  800dc6:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800dcf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dd3:	74 30                	je     800e05 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800dd5:	eb 16                	jmp    800ded <strlcpy+0x2a>
			*dst++ = *src++;
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dda:	8d 50 01             	lea    0x1(%eax),%edx
  800ddd:	89 55 08             	mov    %edx,0x8(%ebp)
  800de0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800de3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800de6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800de9:	8a 12                	mov    (%edx),%dl
  800deb:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ded:	ff 4d 10             	decl   0x10(%ebp)
  800df0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800df4:	74 09                	je     800dff <strlcpy+0x3c>
  800df6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df9:	8a 00                	mov    (%eax),%al
  800dfb:	84 c0                	test   %al,%al
  800dfd:	75 d8                	jne    800dd7 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800dff:	8b 45 08             	mov    0x8(%ebp),%eax
  800e02:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e05:	8b 55 08             	mov    0x8(%ebp),%edx
  800e08:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e0b:	29 c2                	sub    %eax,%edx
  800e0d:	89 d0                	mov    %edx,%eax
}
  800e0f:	c9                   	leave  
  800e10:	c3                   	ret    

00800e11 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e11:	55                   	push   %ebp
  800e12:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e14:	eb 06                	jmp    800e1c <strcmp+0xb>
		p++, q++;
  800e16:	ff 45 08             	incl   0x8(%ebp)
  800e19:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1f:	8a 00                	mov    (%eax),%al
  800e21:	84 c0                	test   %al,%al
  800e23:	74 0e                	je     800e33 <strcmp+0x22>
  800e25:	8b 45 08             	mov    0x8(%ebp),%eax
  800e28:	8a 10                	mov    (%eax),%dl
  800e2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2d:	8a 00                	mov    (%eax),%al
  800e2f:	38 c2                	cmp    %al,%dl
  800e31:	74 e3                	je     800e16 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e33:	8b 45 08             	mov    0x8(%ebp),%eax
  800e36:	8a 00                	mov    (%eax),%al
  800e38:	0f b6 d0             	movzbl %al,%edx
  800e3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3e:	8a 00                	mov    (%eax),%al
  800e40:	0f b6 c0             	movzbl %al,%eax
  800e43:	29 c2                	sub    %eax,%edx
  800e45:	89 d0                	mov    %edx,%eax
}
  800e47:	5d                   	pop    %ebp
  800e48:	c3                   	ret    

00800e49 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e49:	55                   	push   %ebp
  800e4a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e4c:	eb 09                	jmp    800e57 <strncmp+0xe>
		n--, p++, q++;
  800e4e:	ff 4d 10             	decl   0x10(%ebp)
  800e51:	ff 45 08             	incl   0x8(%ebp)
  800e54:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e57:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e5b:	74 17                	je     800e74 <strncmp+0x2b>
  800e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e60:	8a 00                	mov    (%eax),%al
  800e62:	84 c0                	test   %al,%al
  800e64:	74 0e                	je     800e74 <strncmp+0x2b>
  800e66:	8b 45 08             	mov    0x8(%ebp),%eax
  800e69:	8a 10                	mov    (%eax),%dl
  800e6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6e:	8a 00                	mov    (%eax),%al
  800e70:	38 c2                	cmp    %al,%dl
  800e72:	74 da                	je     800e4e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e74:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e78:	75 07                	jne    800e81 <strncmp+0x38>
		return 0;
  800e7a:	b8 00 00 00 00       	mov    $0x0,%eax
  800e7f:	eb 14                	jmp    800e95 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e81:	8b 45 08             	mov    0x8(%ebp),%eax
  800e84:	8a 00                	mov    (%eax),%al
  800e86:	0f b6 d0             	movzbl %al,%edx
  800e89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8c:	8a 00                	mov    (%eax),%al
  800e8e:	0f b6 c0             	movzbl %al,%eax
  800e91:	29 c2                	sub    %eax,%edx
  800e93:	89 d0                	mov    %edx,%eax
}
  800e95:	5d                   	pop    %ebp
  800e96:	c3                   	ret    

00800e97 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e97:	55                   	push   %ebp
  800e98:	89 e5                	mov    %esp,%ebp
  800e9a:	83 ec 04             	sub    $0x4,%esp
  800e9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ea3:	eb 12                	jmp    800eb7 <strchr+0x20>
		if (*s == c)
  800ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea8:	8a 00                	mov    (%eax),%al
  800eaa:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ead:	75 05                	jne    800eb4 <strchr+0x1d>
			return (char *) s;
  800eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb2:	eb 11                	jmp    800ec5 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800eb4:	ff 45 08             	incl   0x8(%ebp)
  800eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eba:	8a 00                	mov    (%eax),%al
  800ebc:	84 c0                	test   %al,%al
  800ebe:	75 e5                	jne    800ea5 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ec0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ec5:	c9                   	leave  
  800ec6:	c3                   	ret    

00800ec7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ec7:	55                   	push   %ebp
  800ec8:	89 e5                	mov    %esp,%ebp
  800eca:	83 ec 04             	sub    $0x4,%esp
  800ecd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ed3:	eb 0d                	jmp    800ee2 <strfind+0x1b>
		if (*s == c)
  800ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed8:	8a 00                	mov    (%eax),%al
  800eda:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800edd:	74 0e                	je     800eed <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800edf:	ff 45 08             	incl   0x8(%ebp)
  800ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee5:	8a 00                	mov    (%eax),%al
  800ee7:	84 c0                	test   %al,%al
  800ee9:	75 ea                	jne    800ed5 <strfind+0xe>
  800eeb:	eb 01                	jmp    800eee <strfind+0x27>
		if (*s == c)
			break;
  800eed:	90                   	nop
	return (char *) s;
  800eee:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ef1:	c9                   	leave  
  800ef2:	c3                   	ret    

00800ef3 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ef3:	55                   	push   %ebp
  800ef4:	89 e5                	mov    %esp,%ebp
  800ef6:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  800efc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800eff:	8b 45 10             	mov    0x10(%ebp),%eax
  800f02:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f05:	eb 0e                	jmp    800f15 <memset+0x22>
		*p++ = c;
  800f07:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f0a:	8d 50 01             	lea    0x1(%eax),%edx
  800f0d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f10:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f13:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800f15:	ff 4d f8             	decl   -0x8(%ebp)
  800f18:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f1c:	79 e9                	jns    800f07 <memset+0x14>
		*p++ = c;

	return v;
  800f1e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f21:	c9                   	leave  
  800f22:	c3                   	ret    

00800f23 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f23:	55                   	push   %ebp
  800f24:	89 e5                	mov    %esp,%ebp
  800f26:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f32:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f35:	eb 16                	jmp    800f4d <memcpy+0x2a>
		*d++ = *s++;
  800f37:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f3a:	8d 50 01             	lea    0x1(%eax),%edx
  800f3d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f40:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f43:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f46:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f49:	8a 12                	mov    (%edx),%dl
  800f4b:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f4d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f50:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f53:	89 55 10             	mov    %edx,0x10(%ebp)
  800f56:	85 c0                	test   %eax,%eax
  800f58:	75 dd                	jne    800f37 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f5a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f5d:	c9                   	leave  
  800f5e:	c3                   	ret    

00800f5f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f5f:	55                   	push   %ebp
  800f60:	89 e5                	mov    %esp,%ebp
  800f62:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f68:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f71:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f74:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f77:	73 50                	jae    800fc9 <memmove+0x6a>
  800f79:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7f:	01 d0                	add    %edx,%eax
  800f81:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f84:	76 43                	jbe    800fc9 <memmove+0x6a>
		s += n;
  800f86:	8b 45 10             	mov    0x10(%ebp),%eax
  800f89:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f8c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f92:	eb 10                	jmp    800fa4 <memmove+0x45>
			*--d = *--s;
  800f94:	ff 4d f8             	decl   -0x8(%ebp)
  800f97:	ff 4d fc             	decl   -0x4(%ebp)
  800f9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f9d:	8a 10                	mov    (%eax),%dl
  800f9f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa2:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fa4:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800faa:	89 55 10             	mov    %edx,0x10(%ebp)
  800fad:	85 c0                	test   %eax,%eax
  800faf:	75 e3                	jne    800f94 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fb1:	eb 23                	jmp    800fd6 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fb3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fb6:	8d 50 01             	lea    0x1(%eax),%edx
  800fb9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fbc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fbf:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fc2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fc5:	8a 12                	mov    (%edx),%dl
  800fc7:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fc9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fcf:	89 55 10             	mov    %edx,0x10(%ebp)
  800fd2:	85 c0                	test   %eax,%eax
  800fd4:	75 dd                	jne    800fb3 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800fd6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fd9:	c9                   	leave  
  800fda:	c3                   	ret    

00800fdb <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800fdb:	55                   	push   %ebp
  800fdc:	89 e5                	mov    %esp,%ebp
  800fde:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800fe7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fea:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800fed:	eb 2a                	jmp    801019 <memcmp+0x3e>
		if (*s1 != *s2)
  800fef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ff2:	8a 10                	mov    (%eax),%dl
  800ff4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff7:	8a 00                	mov    (%eax),%al
  800ff9:	38 c2                	cmp    %al,%dl
  800ffb:	74 16                	je     801013 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ffd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801000:	8a 00                	mov    (%eax),%al
  801002:	0f b6 d0             	movzbl %al,%edx
  801005:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801008:	8a 00                	mov    (%eax),%al
  80100a:	0f b6 c0             	movzbl %al,%eax
  80100d:	29 c2                	sub    %eax,%edx
  80100f:	89 d0                	mov    %edx,%eax
  801011:	eb 18                	jmp    80102b <memcmp+0x50>
		s1++, s2++;
  801013:	ff 45 fc             	incl   -0x4(%ebp)
  801016:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801019:	8b 45 10             	mov    0x10(%ebp),%eax
  80101c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80101f:	89 55 10             	mov    %edx,0x10(%ebp)
  801022:	85 c0                	test   %eax,%eax
  801024:	75 c9                	jne    800fef <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801026:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80102b:	c9                   	leave  
  80102c:	c3                   	ret    

0080102d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80102d:	55                   	push   %ebp
  80102e:	89 e5                	mov    %esp,%ebp
  801030:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801033:	8b 55 08             	mov    0x8(%ebp),%edx
  801036:	8b 45 10             	mov    0x10(%ebp),%eax
  801039:	01 d0                	add    %edx,%eax
  80103b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80103e:	eb 15                	jmp    801055 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801040:	8b 45 08             	mov    0x8(%ebp),%eax
  801043:	8a 00                	mov    (%eax),%al
  801045:	0f b6 d0             	movzbl %al,%edx
  801048:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104b:	0f b6 c0             	movzbl %al,%eax
  80104e:	39 c2                	cmp    %eax,%edx
  801050:	74 0d                	je     80105f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801052:	ff 45 08             	incl   0x8(%ebp)
  801055:	8b 45 08             	mov    0x8(%ebp),%eax
  801058:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80105b:	72 e3                	jb     801040 <memfind+0x13>
  80105d:	eb 01                	jmp    801060 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80105f:	90                   	nop
	return (void *) s;
  801060:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801063:	c9                   	leave  
  801064:	c3                   	ret    

00801065 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801065:	55                   	push   %ebp
  801066:	89 e5                	mov    %esp,%ebp
  801068:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80106b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801072:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801079:	eb 03                	jmp    80107e <strtol+0x19>
		s++;
  80107b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80107e:	8b 45 08             	mov    0x8(%ebp),%eax
  801081:	8a 00                	mov    (%eax),%al
  801083:	3c 20                	cmp    $0x20,%al
  801085:	74 f4                	je     80107b <strtol+0x16>
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	8a 00                	mov    (%eax),%al
  80108c:	3c 09                	cmp    $0x9,%al
  80108e:	74 eb                	je     80107b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801090:	8b 45 08             	mov    0x8(%ebp),%eax
  801093:	8a 00                	mov    (%eax),%al
  801095:	3c 2b                	cmp    $0x2b,%al
  801097:	75 05                	jne    80109e <strtol+0x39>
		s++;
  801099:	ff 45 08             	incl   0x8(%ebp)
  80109c:	eb 13                	jmp    8010b1 <strtol+0x4c>
	else if (*s == '-')
  80109e:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a1:	8a 00                	mov    (%eax),%al
  8010a3:	3c 2d                	cmp    $0x2d,%al
  8010a5:	75 0a                	jne    8010b1 <strtol+0x4c>
		s++, neg = 1;
  8010a7:	ff 45 08             	incl   0x8(%ebp)
  8010aa:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010b5:	74 06                	je     8010bd <strtol+0x58>
  8010b7:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010bb:	75 20                	jne    8010dd <strtol+0x78>
  8010bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c0:	8a 00                	mov    (%eax),%al
  8010c2:	3c 30                	cmp    $0x30,%al
  8010c4:	75 17                	jne    8010dd <strtol+0x78>
  8010c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c9:	40                   	inc    %eax
  8010ca:	8a 00                	mov    (%eax),%al
  8010cc:	3c 78                	cmp    $0x78,%al
  8010ce:	75 0d                	jne    8010dd <strtol+0x78>
		s += 2, base = 16;
  8010d0:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010d4:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010db:	eb 28                	jmp    801105 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8010dd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010e1:	75 15                	jne    8010f8 <strtol+0x93>
  8010e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e6:	8a 00                	mov    (%eax),%al
  8010e8:	3c 30                	cmp    $0x30,%al
  8010ea:	75 0c                	jne    8010f8 <strtol+0x93>
		s++, base = 8;
  8010ec:	ff 45 08             	incl   0x8(%ebp)
  8010ef:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010f6:	eb 0d                	jmp    801105 <strtol+0xa0>
	else if (base == 0)
  8010f8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010fc:	75 07                	jne    801105 <strtol+0xa0>
		base = 10;
  8010fe:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801105:	8b 45 08             	mov    0x8(%ebp),%eax
  801108:	8a 00                	mov    (%eax),%al
  80110a:	3c 2f                	cmp    $0x2f,%al
  80110c:	7e 19                	jle    801127 <strtol+0xc2>
  80110e:	8b 45 08             	mov    0x8(%ebp),%eax
  801111:	8a 00                	mov    (%eax),%al
  801113:	3c 39                	cmp    $0x39,%al
  801115:	7f 10                	jg     801127 <strtol+0xc2>
			dig = *s - '0';
  801117:	8b 45 08             	mov    0x8(%ebp),%eax
  80111a:	8a 00                	mov    (%eax),%al
  80111c:	0f be c0             	movsbl %al,%eax
  80111f:	83 e8 30             	sub    $0x30,%eax
  801122:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801125:	eb 42                	jmp    801169 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801127:	8b 45 08             	mov    0x8(%ebp),%eax
  80112a:	8a 00                	mov    (%eax),%al
  80112c:	3c 60                	cmp    $0x60,%al
  80112e:	7e 19                	jle    801149 <strtol+0xe4>
  801130:	8b 45 08             	mov    0x8(%ebp),%eax
  801133:	8a 00                	mov    (%eax),%al
  801135:	3c 7a                	cmp    $0x7a,%al
  801137:	7f 10                	jg     801149 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801139:	8b 45 08             	mov    0x8(%ebp),%eax
  80113c:	8a 00                	mov    (%eax),%al
  80113e:	0f be c0             	movsbl %al,%eax
  801141:	83 e8 57             	sub    $0x57,%eax
  801144:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801147:	eb 20                	jmp    801169 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801149:	8b 45 08             	mov    0x8(%ebp),%eax
  80114c:	8a 00                	mov    (%eax),%al
  80114e:	3c 40                	cmp    $0x40,%al
  801150:	7e 39                	jle    80118b <strtol+0x126>
  801152:	8b 45 08             	mov    0x8(%ebp),%eax
  801155:	8a 00                	mov    (%eax),%al
  801157:	3c 5a                	cmp    $0x5a,%al
  801159:	7f 30                	jg     80118b <strtol+0x126>
			dig = *s - 'A' + 10;
  80115b:	8b 45 08             	mov    0x8(%ebp),%eax
  80115e:	8a 00                	mov    (%eax),%al
  801160:	0f be c0             	movsbl %al,%eax
  801163:	83 e8 37             	sub    $0x37,%eax
  801166:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801169:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80116c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80116f:	7d 19                	jge    80118a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801171:	ff 45 08             	incl   0x8(%ebp)
  801174:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801177:	0f af 45 10          	imul   0x10(%ebp),%eax
  80117b:	89 c2                	mov    %eax,%edx
  80117d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801180:	01 d0                	add    %edx,%eax
  801182:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801185:	e9 7b ff ff ff       	jmp    801105 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80118a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80118b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80118f:	74 08                	je     801199 <strtol+0x134>
		*endptr = (char *) s;
  801191:	8b 45 0c             	mov    0xc(%ebp),%eax
  801194:	8b 55 08             	mov    0x8(%ebp),%edx
  801197:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801199:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80119d:	74 07                	je     8011a6 <strtol+0x141>
  80119f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a2:	f7 d8                	neg    %eax
  8011a4:	eb 03                	jmp    8011a9 <strtol+0x144>
  8011a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011a9:	c9                   	leave  
  8011aa:	c3                   	ret    

008011ab <ltostr>:

void
ltostr(long value, char *str)
{
  8011ab:	55                   	push   %ebp
  8011ac:	89 e5                	mov    %esp,%ebp
  8011ae:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011b8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011c3:	79 13                	jns    8011d8 <ltostr+0x2d>
	{
		neg = 1;
  8011c5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cf:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011d2:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011d5:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011db:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011e0:	99                   	cltd   
  8011e1:	f7 f9                	idiv   %ecx
  8011e3:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e9:	8d 50 01             	lea    0x1(%eax),%edx
  8011ec:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011ef:	89 c2                	mov    %eax,%edx
  8011f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f4:	01 d0                	add    %edx,%eax
  8011f6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011f9:	83 c2 30             	add    $0x30,%edx
  8011fc:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801201:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801206:	f7 e9                	imul   %ecx
  801208:	c1 fa 02             	sar    $0x2,%edx
  80120b:	89 c8                	mov    %ecx,%eax
  80120d:	c1 f8 1f             	sar    $0x1f,%eax
  801210:	29 c2                	sub    %eax,%edx
  801212:	89 d0                	mov    %edx,%eax
  801214:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801217:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80121a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80121f:	f7 e9                	imul   %ecx
  801221:	c1 fa 02             	sar    $0x2,%edx
  801224:	89 c8                	mov    %ecx,%eax
  801226:	c1 f8 1f             	sar    $0x1f,%eax
  801229:	29 c2                	sub    %eax,%edx
  80122b:	89 d0                	mov    %edx,%eax
  80122d:	c1 e0 02             	shl    $0x2,%eax
  801230:	01 d0                	add    %edx,%eax
  801232:	01 c0                	add    %eax,%eax
  801234:	29 c1                	sub    %eax,%ecx
  801236:	89 ca                	mov    %ecx,%edx
  801238:	85 d2                	test   %edx,%edx
  80123a:	75 9c                	jne    8011d8 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80123c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801243:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801246:	48                   	dec    %eax
  801247:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80124a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80124e:	74 3d                	je     80128d <ltostr+0xe2>
		start = 1 ;
  801250:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801257:	eb 34                	jmp    80128d <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801259:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80125c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125f:	01 d0                	add    %edx,%eax
  801261:	8a 00                	mov    (%eax),%al
  801263:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801266:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801269:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126c:	01 c2                	add    %eax,%edx
  80126e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801271:	8b 45 0c             	mov    0xc(%ebp),%eax
  801274:	01 c8                	add    %ecx,%eax
  801276:	8a 00                	mov    (%eax),%al
  801278:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80127a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80127d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801280:	01 c2                	add    %eax,%edx
  801282:	8a 45 eb             	mov    -0x15(%ebp),%al
  801285:	88 02                	mov    %al,(%edx)
		start++ ;
  801287:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80128a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80128d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801290:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801293:	7c c4                	jl     801259 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801295:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801298:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129b:	01 d0                	add    %edx,%eax
  80129d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012a0:	90                   	nop
  8012a1:	c9                   	leave  
  8012a2:	c3                   	ret    

008012a3 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012a3:	55                   	push   %ebp
  8012a4:	89 e5                	mov    %esp,%ebp
  8012a6:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012a9:	ff 75 08             	pushl  0x8(%ebp)
  8012ac:	e8 54 fa ff ff       	call   800d05 <strlen>
  8012b1:	83 c4 04             	add    $0x4,%esp
  8012b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012b7:	ff 75 0c             	pushl  0xc(%ebp)
  8012ba:	e8 46 fa ff ff       	call   800d05 <strlen>
  8012bf:	83 c4 04             	add    $0x4,%esp
  8012c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012d3:	eb 17                	jmp    8012ec <strcconcat+0x49>
		final[s] = str1[s] ;
  8012d5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012db:	01 c2                	add    %eax,%edx
  8012dd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e3:	01 c8                	add    %ecx,%eax
  8012e5:	8a 00                	mov    (%eax),%al
  8012e7:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012e9:	ff 45 fc             	incl   -0x4(%ebp)
  8012ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012ef:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012f2:	7c e1                	jl     8012d5 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012f4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012fb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801302:	eb 1f                	jmp    801323 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801304:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801307:	8d 50 01             	lea    0x1(%eax),%edx
  80130a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80130d:	89 c2                	mov    %eax,%edx
  80130f:	8b 45 10             	mov    0x10(%ebp),%eax
  801312:	01 c2                	add    %eax,%edx
  801314:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801317:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131a:	01 c8                	add    %ecx,%eax
  80131c:	8a 00                	mov    (%eax),%al
  80131e:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801320:	ff 45 f8             	incl   -0x8(%ebp)
  801323:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801326:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801329:	7c d9                	jl     801304 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80132b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80132e:	8b 45 10             	mov    0x10(%ebp),%eax
  801331:	01 d0                	add    %edx,%eax
  801333:	c6 00 00             	movb   $0x0,(%eax)
}
  801336:	90                   	nop
  801337:	c9                   	leave  
  801338:	c3                   	ret    

00801339 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801339:	55                   	push   %ebp
  80133a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80133c:	8b 45 14             	mov    0x14(%ebp),%eax
  80133f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801345:	8b 45 14             	mov    0x14(%ebp),%eax
  801348:	8b 00                	mov    (%eax),%eax
  80134a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801351:	8b 45 10             	mov    0x10(%ebp),%eax
  801354:	01 d0                	add    %edx,%eax
  801356:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80135c:	eb 0c                	jmp    80136a <strsplit+0x31>
			*string++ = 0;
  80135e:	8b 45 08             	mov    0x8(%ebp),%eax
  801361:	8d 50 01             	lea    0x1(%eax),%edx
  801364:	89 55 08             	mov    %edx,0x8(%ebp)
  801367:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80136a:	8b 45 08             	mov    0x8(%ebp),%eax
  80136d:	8a 00                	mov    (%eax),%al
  80136f:	84 c0                	test   %al,%al
  801371:	74 18                	je     80138b <strsplit+0x52>
  801373:	8b 45 08             	mov    0x8(%ebp),%eax
  801376:	8a 00                	mov    (%eax),%al
  801378:	0f be c0             	movsbl %al,%eax
  80137b:	50                   	push   %eax
  80137c:	ff 75 0c             	pushl  0xc(%ebp)
  80137f:	e8 13 fb ff ff       	call   800e97 <strchr>
  801384:	83 c4 08             	add    $0x8,%esp
  801387:	85 c0                	test   %eax,%eax
  801389:	75 d3                	jne    80135e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80138b:	8b 45 08             	mov    0x8(%ebp),%eax
  80138e:	8a 00                	mov    (%eax),%al
  801390:	84 c0                	test   %al,%al
  801392:	74 5a                	je     8013ee <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801394:	8b 45 14             	mov    0x14(%ebp),%eax
  801397:	8b 00                	mov    (%eax),%eax
  801399:	83 f8 0f             	cmp    $0xf,%eax
  80139c:	75 07                	jne    8013a5 <strsplit+0x6c>
		{
			return 0;
  80139e:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a3:	eb 66                	jmp    80140b <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8013a8:	8b 00                	mov    (%eax),%eax
  8013aa:	8d 48 01             	lea    0x1(%eax),%ecx
  8013ad:	8b 55 14             	mov    0x14(%ebp),%edx
  8013b0:	89 0a                	mov    %ecx,(%edx)
  8013b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8013bc:	01 c2                	add    %eax,%edx
  8013be:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c1:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013c3:	eb 03                	jmp    8013c8 <strsplit+0x8f>
			string++;
  8013c5:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cb:	8a 00                	mov    (%eax),%al
  8013cd:	84 c0                	test   %al,%al
  8013cf:	74 8b                	je     80135c <strsplit+0x23>
  8013d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d4:	8a 00                	mov    (%eax),%al
  8013d6:	0f be c0             	movsbl %al,%eax
  8013d9:	50                   	push   %eax
  8013da:	ff 75 0c             	pushl  0xc(%ebp)
  8013dd:	e8 b5 fa ff ff       	call   800e97 <strchr>
  8013e2:	83 c4 08             	add    $0x8,%esp
  8013e5:	85 c0                	test   %eax,%eax
  8013e7:	74 dc                	je     8013c5 <strsplit+0x8c>
			string++;
	}
  8013e9:	e9 6e ff ff ff       	jmp    80135c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013ee:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8013f2:	8b 00                	mov    (%eax),%eax
  8013f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8013fe:	01 d0                	add    %edx,%eax
  801400:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801406:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80140b:	c9                   	leave  
  80140c:	c3                   	ret    

0080140d <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80140d:	55                   	push   %ebp
  80140e:	89 e5                	mov    %esp,%ebp
  801410:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801413:	a1 04 50 80 00       	mov    0x805004,%eax
  801418:	85 c0                	test   %eax,%eax
  80141a:	74 1f                	je     80143b <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  80141c:	e8 1d 00 00 00       	call   80143e <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801421:	83 ec 0c             	sub    $0xc,%esp
  801424:	68 10 3d 80 00       	push   $0x803d10
  801429:	e8 55 f2 ff ff       	call   800683 <cprintf>
  80142e:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801431:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801438:	00 00 00 
	}
}
  80143b:	90                   	nop
  80143c:	c9                   	leave  
  80143d:	c3                   	ret    

0080143e <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80143e:	55                   	push   %ebp
  80143f:	89 e5                	mov    %esp,%ebp
  801441:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  801444:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  80144b:	00 00 00 
  80144e:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801455:	00 00 00 
  801458:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  80145f:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801462:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801469:	00 00 00 
  80146c:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801473:	00 00 00 
  801476:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  80147d:	00 00 00 
	uint32 arr_size = 0;
  801480:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  801487:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  80148e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801491:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801496:	2d 00 10 00 00       	sub    $0x1000,%eax
  80149b:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  8014a0:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  8014a7:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  8014aa:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8014b1:	a1 20 51 80 00       	mov    0x805120,%eax
  8014b6:	c1 e0 04             	shl    $0x4,%eax
  8014b9:	89 c2                	mov    %eax,%edx
  8014bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014be:	01 d0                	add    %edx,%eax
  8014c0:	48                   	dec    %eax
  8014c1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8014c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8014cc:	f7 75 ec             	divl   -0x14(%ebp)
  8014cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014d2:	29 d0                	sub    %edx,%eax
  8014d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_PRESENT);
  8014d7:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8014de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014e1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014e6:	2d 00 10 00 00       	sub    $0x1000,%eax
  8014eb:	83 ec 04             	sub    $0x4,%esp
  8014ee:	6a 03                	push   $0x3
  8014f0:	ff 75 f4             	pushl  -0xc(%ebp)
  8014f3:	50                   	push   %eax
  8014f4:	e8 b5 03 00 00       	call   8018ae <sys_allocate_chunk>
  8014f9:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8014fc:	a1 20 51 80 00       	mov    0x805120,%eax
  801501:	83 ec 0c             	sub    $0xc,%esp
  801504:	50                   	push   %eax
  801505:	e8 2a 0a 00 00       	call   801f34 <initialize_MemBlocksList>
  80150a:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  80150d:	a1 48 51 80 00       	mov    0x805148,%eax
  801512:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  801515:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801518:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  80151f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801522:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  801529:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80152d:	75 14                	jne    801543 <initialize_dyn_block_system+0x105>
  80152f:	83 ec 04             	sub    $0x4,%esp
  801532:	68 35 3d 80 00       	push   $0x803d35
  801537:	6a 33                	push   $0x33
  801539:	68 53 3d 80 00       	push   $0x803d53
  80153e:	e8 aa 1e 00 00       	call   8033ed <_panic>
  801543:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801546:	8b 00                	mov    (%eax),%eax
  801548:	85 c0                	test   %eax,%eax
  80154a:	74 10                	je     80155c <initialize_dyn_block_system+0x11e>
  80154c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80154f:	8b 00                	mov    (%eax),%eax
  801551:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801554:	8b 52 04             	mov    0x4(%edx),%edx
  801557:	89 50 04             	mov    %edx,0x4(%eax)
  80155a:	eb 0b                	jmp    801567 <initialize_dyn_block_system+0x129>
  80155c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80155f:	8b 40 04             	mov    0x4(%eax),%eax
  801562:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801567:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80156a:	8b 40 04             	mov    0x4(%eax),%eax
  80156d:	85 c0                	test   %eax,%eax
  80156f:	74 0f                	je     801580 <initialize_dyn_block_system+0x142>
  801571:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801574:	8b 40 04             	mov    0x4(%eax),%eax
  801577:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80157a:	8b 12                	mov    (%edx),%edx
  80157c:	89 10                	mov    %edx,(%eax)
  80157e:	eb 0a                	jmp    80158a <initialize_dyn_block_system+0x14c>
  801580:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801583:	8b 00                	mov    (%eax),%eax
  801585:	a3 48 51 80 00       	mov    %eax,0x805148
  80158a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80158d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801593:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801596:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80159d:	a1 54 51 80 00       	mov    0x805154,%eax
  8015a2:	48                   	dec    %eax
  8015a3:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  8015a8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8015ac:	75 14                	jne    8015c2 <initialize_dyn_block_system+0x184>
  8015ae:	83 ec 04             	sub    $0x4,%esp
  8015b1:	68 60 3d 80 00       	push   $0x803d60
  8015b6:	6a 34                	push   $0x34
  8015b8:	68 53 3d 80 00       	push   $0x803d53
  8015bd:	e8 2b 1e 00 00       	call   8033ed <_panic>
  8015c2:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8015c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015cb:	89 10                	mov    %edx,(%eax)
  8015cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015d0:	8b 00                	mov    (%eax),%eax
  8015d2:	85 c0                	test   %eax,%eax
  8015d4:	74 0d                	je     8015e3 <initialize_dyn_block_system+0x1a5>
  8015d6:	a1 38 51 80 00       	mov    0x805138,%eax
  8015db:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8015de:	89 50 04             	mov    %edx,0x4(%eax)
  8015e1:	eb 08                	jmp    8015eb <initialize_dyn_block_system+0x1ad>
  8015e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015e6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8015eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015ee:	a3 38 51 80 00       	mov    %eax,0x805138
  8015f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015f6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015fd:	a1 44 51 80 00       	mov    0x805144,%eax
  801602:	40                   	inc    %eax
  801603:	a3 44 51 80 00       	mov    %eax,0x805144
}
  801608:	90                   	nop
  801609:	c9                   	leave  
  80160a:	c3                   	ret    

0080160b <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  80160b:	55                   	push   %ebp
  80160c:	89 e5                	mov    %esp,%ebp
  80160e:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801611:	e8 f7 fd ff ff       	call   80140d <InitializeUHeap>
	if (size == 0) return NULL ;
  801616:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80161a:	75 07                	jne    801623 <malloc+0x18>
  80161c:	b8 00 00 00 00       	mov    $0x0,%eax
  801621:	eb 14                	jmp    801637 <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801623:	83 ec 04             	sub    $0x4,%esp
  801626:	68 84 3d 80 00       	push   $0x803d84
  80162b:	6a 46                	push   $0x46
  80162d:	68 53 3d 80 00       	push   $0x803d53
  801632:	e8 b6 1d 00 00       	call   8033ed <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801637:	c9                   	leave  
  801638:	c3                   	ret    

00801639 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801639:	55                   	push   %ebp
  80163a:	89 e5                	mov    %esp,%ebp
  80163c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80163f:	83 ec 04             	sub    $0x4,%esp
  801642:	68 ac 3d 80 00       	push   $0x803dac
  801647:	6a 61                	push   $0x61
  801649:	68 53 3d 80 00       	push   $0x803d53
  80164e:	e8 9a 1d 00 00       	call   8033ed <_panic>

00801653 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801653:	55                   	push   %ebp
  801654:	89 e5                	mov    %esp,%ebp
  801656:	83 ec 18             	sub    $0x18,%esp
  801659:	8b 45 10             	mov    0x10(%ebp),%eax
  80165c:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80165f:	e8 a9 fd ff ff       	call   80140d <InitializeUHeap>
	if (size == 0) return NULL ;
  801664:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801668:	75 07                	jne    801671 <smalloc+0x1e>
  80166a:	b8 00 00 00 00       	mov    $0x0,%eax
  80166f:	eb 14                	jmp    801685 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801671:	83 ec 04             	sub    $0x4,%esp
  801674:	68 d0 3d 80 00       	push   $0x803dd0
  801679:	6a 76                	push   $0x76
  80167b:	68 53 3d 80 00       	push   $0x803d53
  801680:	e8 68 1d 00 00       	call   8033ed <_panic>

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801685:	c9                   	leave  
  801686:	c3                   	ret    

00801687 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801687:	55                   	push   %ebp
  801688:	89 e5                	mov    %esp,%ebp
  80168a:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80168d:	e8 7b fd ff ff       	call   80140d <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801692:	83 ec 04             	sub    $0x4,%esp
  801695:	68 f8 3d 80 00       	push   $0x803df8
  80169a:	68 93 00 00 00       	push   $0x93
  80169f:	68 53 3d 80 00       	push   $0x803d53
  8016a4:	e8 44 1d 00 00       	call   8033ed <_panic>

008016a9 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8016a9:	55                   	push   %ebp
  8016aa:	89 e5                	mov    %esp,%ebp
  8016ac:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016af:	e8 59 fd ff ff       	call   80140d <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8016b4:	83 ec 04             	sub    $0x4,%esp
  8016b7:	68 1c 3e 80 00       	push   $0x803e1c
  8016bc:	68 c5 00 00 00       	push   $0xc5
  8016c1:	68 53 3d 80 00       	push   $0x803d53
  8016c6:	e8 22 1d 00 00       	call   8033ed <_panic>

008016cb <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8016cb:	55                   	push   %ebp
  8016cc:	89 e5                	mov    %esp,%ebp
  8016ce:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8016d1:	83 ec 04             	sub    $0x4,%esp
  8016d4:	68 44 3e 80 00       	push   $0x803e44
  8016d9:	68 d9 00 00 00       	push   $0xd9
  8016de:	68 53 3d 80 00       	push   $0x803d53
  8016e3:	e8 05 1d 00 00       	call   8033ed <_panic>

008016e8 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8016e8:	55                   	push   %ebp
  8016e9:	89 e5                	mov    %esp,%ebp
  8016eb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016ee:	83 ec 04             	sub    $0x4,%esp
  8016f1:	68 68 3e 80 00       	push   $0x803e68
  8016f6:	68 e4 00 00 00       	push   $0xe4
  8016fb:	68 53 3d 80 00       	push   $0x803d53
  801700:	e8 e8 1c 00 00       	call   8033ed <_panic>

00801705 <shrink>:

}
void shrink(uint32 newSize)
{
  801705:	55                   	push   %ebp
  801706:	89 e5                	mov    %esp,%ebp
  801708:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80170b:	83 ec 04             	sub    $0x4,%esp
  80170e:	68 68 3e 80 00       	push   $0x803e68
  801713:	68 e9 00 00 00       	push   $0xe9
  801718:	68 53 3d 80 00       	push   $0x803d53
  80171d:	e8 cb 1c 00 00       	call   8033ed <_panic>

00801722 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801722:	55                   	push   %ebp
  801723:	89 e5                	mov    %esp,%ebp
  801725:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801728:	83 ec 04             	sub    $0x4,%esp
  80172b:	68 68 3e 80 00       	push   $0x803e68
  801730:	68 ee 00 00 00       	push   $0xee
  801735:	68 53 3d 80 00       	push   $0x803d53
  80173a:	e8 ae 1c 00 00       	call   8033ed <_panic>

0080173f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80173f:	55                   	push   %ebp
  801740:	89 e5                	mov    %esp,%ebp
  801742:	57                   	push   %edi
  801743:	56                   	push   %esi
  801744:	53                   	push   %ebx
  801745:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801748:	8b 45 08             	mov    0x8(%ebp),%eax
  80174b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80174e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801751:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801754:	8b 7d 18             	mov    0x18(%ebp),%edi
  801757:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80175a:	cd 30                	int    $0x30
  80175c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80175f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801762:	83 c4 10             	add    $0x10,%esp
  801765:	5b                   	pop    %ebx
  801766:	5e                   	pop    %esi
  801767:	5f                   	pop    %edi
  801768:	5d                   	pop    %ebp
  801769:	c3                   	ret    

0080176a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80176a:	55                   	push   %ebp
  80176b:	89 e5                	mov    %esp,%ebp
  80176d:	83 ec 04             	sub    $0x4,%esp
  801770:	8b 45 10             	mov    0x10(%ebp),%eax
  801773:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801776:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80177a:	8b 45 08             	mov    0x8(%ebp),%eax
  80177d:	6a 00                	push   $0x0
  80177f:	6a 00                	push   $0x0
  801781:	52                   	push   %edx
  801782:	ff 75 0c             	pushl  0xc(%ebp)
  801785:	50                   	push   %eax
  801786:	6a 00                	push   $0x0
  801788:	e8 b2 ff ff ff       	call   80173f <syscall>
  80178d:	83 c4 18             	add    $0x18,%esp
}
  801790:	90                   	nop
  801791:	c9                   	leave  
  801792:	c3                   	ret    

00801793 <sys_cgetc>:

int
sys_cgetc(void)
{
  801793:	55                   	push   %ebp
  801794:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801796:	6a 00                	push   $0x0
  801798:	6a 00                	push   $0x0
  80179a:	6a 00                	push   $0x0
  80179c:	6a 00                	push   $0x0
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 01                	push   $0x1
  8017a2:	e8 98 ff ff ff       	call   80173f <syscall>
  8017a7:	83 c4 18             	add    $0x18,%esp
}
  8017aa:	c9                   	leave  
  8017ab:	c3                   	ret    

008017ac <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8017ac:	55                   	push   %ebp
  8017ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8017af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b5:	6a 00                	push   $0x0
  8017b7:	6a 00                	push   $0x0
  8017b9:	6a 00                	push   $0x0
  8017bb:	52                   	push   %edx
  8017bc:	50                   	push   %eax
  8017bd:	6a 05                	push   $0x5
  8017bf:	e8 7b ff ff ff       	call   80173f <syscall>
  8017c4:	83 c4 18             	add    $0x18,%esp
}
  8017c7:	c9                   	leave  
  8017c8:	c3                   	ret    

008017c9 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8017c9:	55                   	push   %ebp
  8017ca:	89 e5                	mov    %esp,%ebp
  8017cc:	56                   	push   %esi
  8017cd:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8017ce:	8b 75 18             	mov    0x18(%ebp),%esi
  8017d1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017d4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017da:	8b 45 08             	mov    0x8(%ebp),%eax
  8017dd:	56                   	push   %esi
  8017de:	53                   	push   %ebx
  8017df:	51                   	push   %ecx
  8017e0:	52                   	push   %edx
  8017e1:	50                   	push   %eax
  8017e2:	6a 06                	push   $0x6
  8017e4:	e8 56 ff ff ff       	call   80173f <syscall>
  8017e9:	83 c4 18             	add    $0x18,%esp
}
  8017ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017ef:	5b                   	pop    %ebx
  8017f0:	5e                   	pop    %esi
  8017f1:	5d                   	pop    %ebp
  8017f2:	c3                   	ret    

008017f3 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8017f3:	55                   	push   %ebp
  8017f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8017f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fc:	6a 00                	push   $0x0
  8017fe:	6a 00                	push   $0x0
  801800:	6a 00                	push   $0x0
  801802:	52                   	push   %edx
  801803:	50                   	push   %eax
  801804:	6a 07                	push   $0x7
  801806:	e8 34 ff ff ff       	call   80173f <syscall>
  80180b:	83 c4 18             	add    $0x18,%esp
}
  80180e:	c9                   	leave  
  80180f:	c3                   	ret    

00801810 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801810:	55                   	push   %ebp
  801811:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801813:	6a 00                	push   $0x0
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	ff 75 0c             	pushl  0xc(%ebp)
  80181c:	ff 75 08             	pushl  0x8(%ebp)
  80181f:	6a 08                	push   $0x8
  801821:	e8 19 ff ff ff       	call   80173f <syscall>
  801826:	83 c4 18             	add    $0x18,%esp
}
  801829:	c9                   	leave  
  80182a:	c3                   	ret    

0080182b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80182b:	55                   	push   %ebp
  80182c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80182e:	6a 00                	push   $0x0
  801830:	6a 00                	push   $0x0
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	6a 09                	push   $0x9
  80183a:	e8 00 ff ff ff       	call   80173f <syscall>
  80183f:	83 c4 18             	add    $0x18,%esp
}
  801842:	c9                   	leave  
  801843:	c3                   	ret    

00801844 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801844:	55                   	push   %ebp
  801845:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	6a 0a                	push   $0xa
  801853:	e8 e7 fe ff ff       	call   80173f <syscall>
  801858:	83 c4 18             	add    $0x18,%esp
}
  80185b:	c9                   	leave  
  80185c:	c3                   	ret    

0080185d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80185d:	55                   	push   %ebp
  80185e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	6a 0b                	push   $0xb
  80186c:	e8 ce fe ff ff       	call   80173f <syscall>
  801871:	83 c4 18             	add    $0x18,%esp
}
  801874:	c9                   	leave  
  801875:	c3                   	ret    

00801876 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801876:	55                   	push   %ebp
  801877:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	6a 00                	push   $0x0
  80187f:	ff 75 0c             	pushl  0xc(%ebp)
  801882:	ff 75 08             	pushl  0x8(%ebp)
  801885:	6a 0f                	push   $0xf
  801887:	e8 b3 fe ff ff       	call   80173f <syscall>
  80188c:	83 c4 18             	add    $0x18,%esp
	return;
  80188f:	90                   	nop
}
  801890:	c9                   	leave  
  801891:	c3                   	ret    

00801892 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801892:	55                   	push   %ebp
  801893:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801895:	6a 00                	push   $0x0
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	ff 75 0c             	pushl  0xc(%ebp)
  80189e:	ff 75 08             	pushl  0x8(%ebp)
  8018a1:	6a 10                	push   $0x10
  8018a3:	e8 97 fe ff ff       	call   80173f <syscall>
  8018a8:	83 c4 18             	add    $0x18,%esp
	return ;
  8018ab:	90                   	nop
}
  8018ac:	c9                   	leave  
  8018ad:	c3                   	ret    

008018ae <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8018ae:	55                   	push   %ebp
  8018af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 00                	push   $0x0
  8018b5:	ff 75 10             	pushl  0x10(%ebp)
  8018b8:	ff 75 0c             	pushl  0xc(%ebp)
  8018bb:	ff 75 08             	pushl  0x8(%ebp)
  8018be:	6a 11                	push   $0x11
  8018c0:	e8 7a fe ff ff       	call   80173f <syscall>
  8018c5:	83 c4 18             	add    $0x18,%esp
	return ;
  8018c8:	90                   	nop
}
  8018c9:	c9                   	leave  
  8018ca:	c3                   	ret    

008018cb <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8018cb:	55                   	push   %ebp
  8018cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 0c                	push   $0xc
  8018da:	e8 60 fe ff ff       	call   80173f <syscall>
  8018df:	83 c4 18             	add    $0x18,%esp
}
  8018e2:	c9                   	leave  
  8018e3:	c3                   	ret    

008018e4 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8018e4:	55                   	push   %ebp
  8018e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	ff 75 08             	pushl  0x8(%ebp)
  8018f2:	6a 0d                	push   $0xd
  8018f4:	e8 46 fe ff ff       	call   80173f <syscall>
  8018f9:	83 c4 18             	add    $0x18,%esp
}
  8018fc:	c9                   	leave  
  8018fd:	c3                   	ret    

008018fe <sys_scarce_memory>:

void sys_scarce_memory()
{
  8018fe:	55                   	push   %ebp
  8018ff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801901:	6a 00                	push   $0x0
  801903:	6a 00                	push   $0x0
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	6a 0e                	push   $0xe
  80190d:	e8 2d fe ff ff       	call   80173f <syscall>
  801912:	83 c4 18             	add    $0x18,%esp
}
  801915:	90                   	nop
  801916:	c9                   	leave  
  801917:	c3                   	ret    

00801918 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801918:	55                   	push   %ebp
  801919:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	6a 13                	push   $0x13
  801927:	e8 13 fe ff ff       	call   80173f <syscall>
  80192c:	83 c4 18             	add    $0x18,%esp
}
  80192f:	90                   	nop
  801930:	c9                   	leave  
  801931:	c3                   	ret    

00801932 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801932:	55                   	push   %ebp
  801933:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	6a 14                	push   $0x14
  801941:	e8 f9 fd ff ff       	call   80173f <syscall>
  801946:	83 c4 18             	add    $0x18,%esp
}
  801949:	90                   	nop
  80194a:	c9                   	leave  
  80194b:	c3                   	ret    

0080194c <sys_cputc>:


void
sys_cputc(const char c)
{
  80194c:	55                   	push   %ebp
  80194d:	89 e5                	mov    %esp,%ebp
  80194f:	83 ec 04             	sub    $0x4,%esp
  801952:	8b 45 08             	mov    0x8(%ebp),%eax
  801955:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801958:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	50                   	push   %eax
  801965:	6a 15                	push   $0x15
  801967:	e8 d3 fd ff ff       	call   80173f <syscall>
  80196c:	83 c4 18             	add    $0x18,%esp
}
  80196f:	90                   	nop
  801970:	c9                   	leave  
  801971:	c3                   	ret    

00801972 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801972:	55                   	push   %ebp
  801973:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	6a 16                	push   $0x16
  801981:	e8 b9 fd ff ff       	call   80173f <syscall>
  801986:	83 c4 18             	add    $0x18,%esp
}
  801989:	90                   	nop
  80198a:	c9                   	leave  
  80198b:	c3                   	ret    

0080198c <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80198c:	55                   	push   %ebp
  80198d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80198f:	8b 45 08             	mov    0x8(%ebp),%eax
  801992:	6a 00                	push   $0x0
  801994:	6a 00                	push   $0x0
  801996:	6a 00                	push   $0x0
  801998:	ff 75 0c             	pushl  0xc(%ebp)
  80199b:	50                   	push   %eax
  80199c:	6a 17                	push   $0x17
  80199e:	e8 9c fd ff ff       	call   80173f <syscall>
  8019a3:	83 c4 18             	add    $0x18,%esp
}
  8019a6:	c9                   	leave  
  8019a7:	c3                   	ret    

008019a8 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8019a8:	55                   	push   %ebp
  8019a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	52                   	push   %edx
  8019b8:	50                   	push   %eax
  8019b9:	6a 1a                	push   $0x1a
  8019bb:	e8 7f fd ff ff       	call   80173f <syscall>
  8019c0:	83 c4 18             	add    $0x18,%esp
}
  8019c3:	c9                   	leave  
  8019c4:	c3                   	ret    

008019c5 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019c5:	55                   	push   %ebp
  8019c6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	52                   	push   %edx
  8019d5:	50                   	push   %eax
  8019d6:	6a 18                	push   $0x18
  8019d8:	e8 62 fd ff ff       	call   80173f <syscall>
  8019dd:	83 c4 18             	add    $0x18,%esp
}
  8019e0:	90                   	nop
  8019e1:	c9                   	leave  
  8019e2:	c3                   	ret    

008019e3 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019e3:	55                   	push   %ebp
  8019e4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	52                   	push   %edx
  8019f3:	50                   	push   %eax
  8019f4:	6a 19                	push   $0x19
  8019f6:	e8 44 fd ff ff       	call   80173f <syscall>
  8019fb:	83 c4 18             	add    $0x18,%esp
}
  8019fe:	90                   	nop
  8019ff:	c9                   	leave  
  801a00:	c3                   	ret    

00801a01 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a01:	55                   	push   %ebp
  801a02:	89 e5                	mov    %esp,%ebp
  801a04:	83 ec 04             	sub    $0x4,%esp
  801a07:	8b 45 10             	mov    0x10(%ebp),%eax
  801a0a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a0d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a10:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a14:	8b 45 08             	mov    0x8(%ebp),%eax
  801a17:	6a 00                	push   $0x0
  801a19:	51                   	push   %ecx
  801a1a:	52                   	push   %edx
  801a1b:	ff 75 0c             	pushl  0xc(%ebp)
  801a1e:	50                   	push   %eax
  801a1f:	6a 1b                	push   $0x1b
  801a21:	e8 19 fd ff ff       	call   80173f <syscall>
  801a26:	83 c4 18             	add    $0x18,%esp
}
  801a29:	c9                   	leave  
  801a2a:	c3                   	ret    

00801a2b <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a2b:	55                   	push   %ebp
  801a2c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a31:	8b 45 08             	mov    0x8(%ebp),%eax
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	52                   	push   %edx
  801a3b:	50                   	push   %eax
  801a3c:	6a 1c                	push   $0x1c
  801a3e:	e8 fc fc ff ff       	call   80173f <syscall>
  801a43:	83 c4 18             	add    $0x18,%esp
}
  801a46:	c9                   	leave  
  801a47:	c3                   	ret    

00801a48 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a48:	55                   	push   %ebp
  801a49:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a4b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a51:	8b 45 08             	mov    0x8(%ebp),%eax
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	51                   	push   %ecx
  801a59:	52                   	push   %edx
  801a5a:	50                   	push   %eax
  801a5b:	6a 1d                	push   $0x1d
  801a5d:	e8 dd fc ff ff       	call   80173f <syscall>
  801a62:	83 c4 18             	add    $0x18,%esp
}
  801a65:	c9                   	leave  
  801a66:	c3                   	ret    

00801a67 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a67:	55                   	push   %ebp
  801a68:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	52                   	push   %edx
  801a77:	50                   	push   %eax
  801a78:	6a 1e                	push   $0x1e
  801a7a:	e8 c0 fc ff ff       	call   80173f <syscall>
  801a7f:	83 c4 18             	add    $0x18,%esp
}
  801a82:	c9                   	leave  
  801a83:	c3                   	ret    

00801a84 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801a84:	55                   	push   %ebp
  801a85:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 1f                	push   $0x1f
  801a93:	e8 a7 fc ff ff       	call   80173f <syscall>
  801a98:	83 c4 18             	add    $0x18,%esp
}
  801a9b:	c9                   	leave  
  801a9c:	c3                   	ret    

00801a9d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a9d:	55                   	push   %ebp
  801a9e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa3:	6a 00                	push   $0x0
  801aa5:	ff 75 14             	pushl  0x14(%ebp)
  801aa8:	ff 75 10             	pushl  0x10(%ebp)
  801aab:	ff 75 0c             	pushl  0xc(%ebp)
  801aae:	50                   	push   %eax
  801aaf:	6a 20                	push   $0x20
  801ab1:	e8 89 fc ff ff       	call   80173f <syscall>
  801ab6:	83 c4 18             	add    $0x18,%esp
}
  801ab9:	c9                   	leave  
  801aba:	c3                   	ret    

00801abb <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801abb:	55                   	push   %ebp
  801abc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801abe:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	50                   	push   %eax
  801aca:	6a 21                	push   $0x21
  801acc:	e8 6e fc ff ff       	call   80173f <syscall>
  801ad1:	83 c4 18             	add    $0x18,%esp
}
  801ad4:	90                   	nop
  801ad5:	c9                   	leave  
  801ad6:	c3                   	ret    

00801ad7 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ad7:	55                   	push   %ebp
  801ad8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801ada:	8b 45 08             	mov    0x8(%ebp),%eax
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	50                   	push   %eax
  801ae6:	6a 22                	push   $0x22
  801ae8:	e8 52 fc ff ff       	call   80173f <syscall>
  801aed:	83 c4 18             	add    $0x18,%esp
}
  801af0:	c9                   	leave  
  801af1:	c3                   	ret    

00801af2 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801af2:	55                   	push   %ebp
  801af3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	6a 00                	push   $0x0
  801aff:	6a 02                	push   $0x2
  801b01:	e8 39 fc ff ff       	call   80173f <syscall>
  801b06:	83 c4 18             	add    $0x18,%esp
}
  801b09:	c9                   	leave  
  801b0a:	c3                   	ret    

00801b0b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b0b:	55                   	push   %ebp
  801b0c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 03                	push   $0x3
  801b1a:	e8 20 fc ff ff       	call   80173f <syscall>
  801b1f:	83 c4 18             	add    $0x18,%esp
}
  801b22:	c9                   	leave  
  801b23:	c3                   	ret    

00801b24 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b24:	55                   	push   %ebp
  801b25:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 04                	push   $0x4
  801b33:	e8 07 fc ff ff       	call   80173f <syscall>
  801b38:	83 c4 18             	add    $0x18,%esp
}
  801b3b:	c9                   	leave  
  801b3c:	c3                   	ret    

00801b3d <sys_exit_env>:


void sys_exit_env(void)
{
  801b3d:	55                   	push   %ebp
  801b3e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 23                	push   $0x23
  801b4c:	e8 ee fb ff ff       	call   80173f <syscall>
  801b51:	83 c4 18             	add    $0x18,%esp
}
  801b54:	90                   	nop
  801b55:	c9                   	leave  
  801b56:	c3                   	ret    

00801b57 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801b57:	55                   	push   %ebp
  801b58:	89 e5                	mov    %esp,%ebp
  801b5a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b5d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b60:	8d 50 04             	lea    0x4(%eax),%edx
  801b63:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	52                   	push   %edx
  801b6d:	50                   	push   %eax
  801b6e:	6a 24                	push   $0x24
  801b70:	e8 ca fb ff ff       	call   80173f <syscall>
  801b75:	83 c4 18             	add    $0x18,%esp
	return result;
  801b78:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b7b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b7e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b81:	89 01                	mov    %eax,(%ecx)
  801b83:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b86:	8b 45 08             	mov    0x8(%ebp),%eax
  801b89:	c9                   	leave  
  801b8a:	c2 04 00             	ret    $0x4

00801b8d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b8d:	55                   	push   %ebp
  801b8e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	ff 75 10             	pushl  0x10(%ebp)
  801b97:	ff 75 0c             	pushl  0xc(%ebp)
  801b9a:	ff 75 08             	pushl  0x8(%ebp)
  801b9d:	6a 12                	push   $0x12
  801b9f:	e8 9b fb ff ff       	call   80173f <syscall>
  801ba4:	83 c4 18             	add    $0x18,%esp
	return ;
  801ba7:	90                   	nop
}
  801ba8:	c9                   	leave  
  801ba9:	c3                   	ret    

00801baa <sys_rcr2>:
uint32 sys_rcr2()
{
  801baa:	55                   	push   %ebp
  801bab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 25                	push   $0x25
  801bb9:	e8 81 fb ff ff       	call   80173f <syscall>
  801bbe:	83 c4 18             	add    $0x18,%esp
}
  801bc1:	c9                   	leave  
  801bc2:	c3                   	ret    

00801bc3 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
  801bc6:	83 ec 04             	sub    $0x4,%esp
  801bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801bcf:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	50                   	push   %eax
  801bdc:	6a 26                	push   $0x26
  801bde:	e8 5c fb ff ff       	call   80173f <syscall>
  801be3:	83 c4 18             	add    $0x18,%esp
	return ;
  801be6:	90                   	nop
}
  801be7:	c9                   	leave  
  801be8:	c3                   	ret    

00801be9 <rsttst>:
void rsttst()
{
  801be9:	55                   	push   %ebp
  801bea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 28                	push   $0x28
  801bf8:	e8 42 fb ff ff       	call   80173f <syscall>
  801bfd:	83 c4 18             	add    $0x18,%esp
	return ;
  801c00:	90                   	nop
}
  801c01:	c9                   	leave  
  801c02:	c3                   	ret    

00801c03 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c03:	55                   	push   %ebp
  801c04:	89 e5                	mov    %esp,%ebp
  801c06:	83 ec 04             	sub    $0x4,%esp
  801c09:	8b 45 14             	mov    0x14(%ebp),%eax
  801c0c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c0f:	8b 55 18             	mov    0x18(%ebp),%edx
  801c12:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c16:	52                   	push   %edx
  801c17:	50                   	push   %eax
  801c18:	ff 75 10             	pushl  0x10(%ebp)
  801c1b:	ff 75 0c             	pushl  0xc(%ebp)
  801c1e:	ff 75 08             	pushl  0x8(%ebp)
  801c21:	6a 27                	push   $0x27
  801c23:	e8 17 fb ff ff       	call   80173f <syscall>
  801c28:	83 c4 18             	add    $0x18,%esp
	return ;
  801c2b:	90                   	nop
}
  801c2c:	c9                   	leave  
  801c2d:	c3                   	ret    

00801c2e <chktst>:
void chktst(uint32 n)
{
  801c2e:	55                   	push   %ebp
  801c2f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	ff 75 08             	pushl  0x8(%ebp)
  801c3c:	6a 29                	push   $0x29
  801c3e:	e8 fc fa ff ff       	call   80173f <syscall>
  801c43:	83 c4 18             	add    $0x18,%esp
	return ;
  801c46:	90                   	nop
}
  801c47:	c9                   	leave  
  801c48:	c3                   	ret    

00801c49 <inctst>:

void inctst()
{
  801c49:	55                   	push   %ebp
  801c4a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 2a                	push   $0x2a
  801c58:	e8 e2 fa ff ff       	call   80173f <syscall>
  801c5d:	83 c4 18             	add    $0x18,%esp
	return ;
  801c60:	90                   	nop
}
  801c61:	c9                   	leave  
  801c62:	c3                   	ret    

00801c63 <gettst>:
uint32 gettst()
{
  801c63:	55                   	push   %ebp
  801c64:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 2b                	push   $0x2b
  801c72:	e8 c8 fa ff ff       	call   80173f <syscall>
  801c77:	83 c4 18             	add    $0x18,%esp
}
  801c7a:	c9                   	leave  
  801c7b:	c3                   	ret    

00801c7c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c7c:	55                   	push   %ebp
  801c7d:	89 e5                	mov    %esp,%ebp
  801c7f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c82:	6a 00                	push   $0x0
  801c84:	6a 00                	push   $0x0
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 2c                	push   $0x2c
  801c8e:	e8 ac fa ff ff       	call   80173f <syscall>
  801c93:	83 c4 18             	add    $0x18,%esp
  801c96:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c99:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c9d:	75 07                	jne    801ca6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c9f:	b8 01 00 00 00       	mov    $0x1,%eax
  801ca4:	eb 05                	jmp    801cab <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ca6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cab:	c9                   	leave  
  801cac:	c3                   	ret    

00801cad <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801cad:	55                   	push   %ebp
  801cae:	89 e5                	mov    %esp,%ebp
  801cb0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 2c                	push   $0x2c
  801cbf:	e8 7b fa ff ff       	call   80173f <syscall>
  801cc4:	83 c4 18             	add    $0x18,%esp
  801cc7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801cca:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801cce:	75 07                	jne    801cd7 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801cd0:	b8 01 00 00 00       	mov    $0x1,%eax
  801cd5:	eb 05                	jmp    801cdc <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801cd7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cdc:	c9                   	leave  
  801cdd:	c3                   	ret    

00801cde <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801cde:	55                   	push   %ebp
  801cdf:	89 e5                	mov    %esp,%ebp
  801ce1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	6a 2c                	push   $0x2c
  801cf0:	e8 4a fa ff ff       	call   80173f <syscall>
  801cf5:	83 c4 18             	add    $0x18,%esp
  801cf8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801cfb:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801cff:	75 07                	jne    801d08 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d01:	b8 01 00 00 00       	mov    $0x1,%eax
  801d06:	eb 05                	jmp    801d0d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d08:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d0d:	c9                   	leave  
  801d0e:	c3                   	ret    

00801d0f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d0f:	55                   	push   %ebp
  801d10:	89 e5                	mov    %esp,%ebp
  801d12:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 2c                	push   $0x2c
  801d21:	e8 19 fa ff ff       	call   80173f <syscall>
  801d26:	83 c4 18             	add    $0x18,%esp
  801d29:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d2c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d30:	75 07                	jne    801d39 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d32:	b8 01 00 00 00       	mov    $0x1,%eax
  801d37:	eb 05                	jmp    801d3e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d39:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d3e:	c9                   	leave  
  801d3f:	c3                   	ret    

00801d40 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d40:	55                   	push   %ebp
  801d41:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	ff 75 08             	pushl  0x8(%ebp)
  801d4e:	6a 2d                	push   $0x2d
  801d50:	e8 ea f9 ff ff       	call   80173f <syscall>
  801d55:	83 c4 18             	add    $0x18,%esp
	return ;
  801d58:	90                   	nop
}
  801d59:	c9                   	leave  
  801d5a:	c3                   	ret    

00801d5b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d5b:	55                   	push   %ebp
  801d5c:	89 e5                	mov    %esp,%ebp
  801d5e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d5f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d62:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d65:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d68:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6b:	6a 00                	push   $0x0
  801d6d:	53                   	push   %ebx
  801d6e:	51                   	push   %ecx
  801d6f:	52                   	push   %edx
  801d70:	50                   	push   %eax
  801d71:	6a 2e                	push   $0x2e
  801d73:	e8 c7 f9 ff ff       	call   80173f <syscall>
  801d78:	83 c4 18             	add    $0x18,%esp
}
  801d7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d7e:	c9                   	leave  
  801d7f:	c3                   	ret    

00801d80 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d80:	55                   	push   %ebp
  801d81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d83:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d86:	8b 45 08             	mov    0x8(%ebp),%eax
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	52                   	push   %edx
  801d90:	50                   	push   %eax
  801d91:	6a 2f                	push   $0x2f
  801d93:	e8 a7 f9 ff ff       	call   80173f <syscall>
  801d98:	83 c4 18             	add    $0x18,%esp
}
  801d9b:	c9                   	leave  
  801d9c:	c3                   	ret    

00801d9d <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801d9d:	55                   	push   %ebp
  801d9e:	89 e5                	mov    %esp,%ebp
  801da0:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801da3:	83 ec 0c             	sub    $0xc,%esp
  801da6:	68 78 3e 80 00       	push   $0x803e78
  801dab:	e8 d3 e8 ff ff       	call   800683 <cprintf>
  801db0:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801db3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801dba:	83 ec 0c             	sub    $0xc,%esp
  801dbd:	68 a4 3e 80 00       	push   $0x803ea4
  801dc2:	e8 bc e8 ff ff       	call   800683 <cprintf>
  801dc7:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801dca:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801dce:	a1 38 51 80 00       	mov    0x805138,%eax
  801dd3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dd6:	eb 56                	jmp    801e2e <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801dd8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ddc:	74 1c                	je     801dfa <print_mem_block_lists+0x5d>
  801dde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de1:	8b 50 08             	mov    0x8(%eax),%edx
  801de4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801de7:	8b 48 08             	mov    0x8(%eax),%ecx
  801dea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ded:	8b 40 0c             	mov    0xc(%eax),%eax
  801df0:	01 c8                	add    %ecx,%eax
  801df2:	39 c2                	cmp    %eax,%edx
  801df4:	73 04                	jae    801dfa <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801df6:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801dfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dfd:	8b 50 08             	mov    0x8(%eax),%edx
  801e00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e03:	8b 40 0c             	mov    0xc(%eax),%eax
  801e06:	01 c2                	add    %eax,%edx
  801e08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e0b:	8b 40 08             	mov    0x8(%eax),%eax
  801e0e:	83 ec 04             	sub    $0x4,%esp
  801e11:	52                   	push   %edx
  801e12:	50                   	push   %eax
  801e13:	68 b9 3e 80 00       	push   $0x803eb9
  801e18:	e8 66 e8 ff ff       	call   800683 <cprintf>
  801e1d:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e23:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e26:	a1 40 51 80 00       	mov    0x805140,%eax
  801e2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e32:	74 07                	je     801e3b <print_mem_block_lists+0x9e>
  801e34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e37:	8b 00                	mov    (%eax),%eax
  801e39:	eb 05                	jmp    801e40 <print_mem_block_lists+0xa3>
  801e3b:	b8 00 00 00 00       	mov    $0x0,%eax
  801e40:	a3 40 51 80 00       	mov    %eax,0x805140
  801e45:	a1 40 51 80 00       	mov    0x805140,%eax
  801e4a:	85 c0                	test   %eax,%eax
  801e4c:	75 8a                	jne    801dd8 <print_mem_block_lists+0x3b>
  801e4e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e52:	75 84                	jne    801dd8 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801e54:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e58:	75 10                	jne    801e6a <print_mem_block_lists+0xcd>
  801e5a:	83 ec 0c             	sub    $0xc,%esp
  801e5d:	68 c8 3e 80 00       	push   $0x803ec8
  801e62:	e8 1c e8 ff ff       	call   800683 <cprintf>
  801e67:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801e6a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801e71:	83 ec 0c             	sub    $0xc,%esp
  801e74:	68 ec 3e 80 00       	push   $0x803eec
  801e79:	e8 05 e8 ff ff       	call   800683 <cprintf>
  801e7e:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801e81:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e85:	a1 40 50 80 00       	mov    0x805040,%eax
  801e8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e8d:	eb 56                	jmp    801ee5 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e8f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e93:	74 1c                	je     801eb1 <print_mem_block_lists+0x114>
  801e95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e98:	8b 50 08             	mov    0x8(%eax),%edx
  801e9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e9e:	8b 48 08             	mov    0x8(%eax),%ecx
  801ea1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ea4:	8b 40 0c             	mov    0xc(%eax),%eax
  801ea7:	01 c8                	add    %ecx,%eax
  801ea9:	39 c2                	cmp    %eax,%edx
  801eab:	73 04                	jae    801eb1 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801ead:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801eb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb4:	8b 50 08             	mov    0x8(%eax),%edx
  801eb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eba:	8b 40 0c             	mov    0xc(%eax),%eax
  801ebd:	01 c2                	add    %eax,%edx
  801ebf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec2:	8b 40 08             	mov    0x8(%eax),%eax
  801ec5:	83 ec 04             	sub    $0x4,%esp
  801ec8:	52                   	push   %edx
  801ec9:	50                   	push   %eax
  801eca:	68 b9 3e 80 00       	push   $0x803eb9
  801ecf:	e8 af e7 ff ff       	call   800683 <cprintf>
  801ed4:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ed7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eda:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801edd:	a1 48 50 80 00       	mov    0x805048,%eax
  801ee2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ee5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ee9:	74 07                	je     801ef2 <print_mem_block_lists+0x155>
  801eeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eee:	8b 00                	mov    (%eax),%eax
  801ef0:	eb 05                	jmp    801ef7 <print_mem_block_lists+0x15a>
  801ef2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef7:	a3 48 50 80 00       	mov    %eax,0x805048
  801efc:	a1 48 50 80 00       	mov    0x805048,%eax
  801f01:	85 c0                	test   %eax,%eax
  801f03:	75 8a                	jne    801e8f <print_mem_block_lists+0xf2>
  801f05:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f09:	75 84                	jne    801e8f <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801f0b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f0f:	75 10                	jne    801f21 <print_mem_block_lists+0x184>
  801f11:	83 ec 0c             	sub    $0xc,%esp
  801f14:	68 04 3f 80 00       	push   $0x803f04
  801f19:	e8 65 e7 ff ff       	call   800683 <cprintf>
  801f1e:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801f21:	83 ec 0c             	sub    $0xc,%esp
  801f24:	68 78 3e 80 00       	push   $0x803e78
  801f29:	e8 55 e7 ff ff       	call   800683 <cprintf>
  801f2e:	83 c4 10             	add    $0x10,%esp

}
  801f31:	90                   	nop
  801f32:	c9                   	leave  
  801f33:	c3                   	ret    

00801f34 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801f34:	55                   	push   %ebp
  801f35:	89 e5                	mov    %esp,%ebp
  801f37:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801f3a:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801f41:	00 00 00 
  801f44:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801f4b:	00 00 00 
  801f4e:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801f55:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801f58:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801f5f:	e9 9e 00 00 00       	jmp    802002 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801f64:	a1 50 50 80 00       	mov    0x805050,%eax
  801f69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f6c:	c1 e2 04             	shl    $0x4,%edx
  801f6f:	01 d0                	add    %edx,%eax
  801f71:	85 c0                	test   %eax,%eax
  801f73:	75 14                	jne    801f89 <initialize_MemBlocksList+0x55>
  801f75:	83 ec 04             	sub    $0x4,%esp
  801f78:	68 2c 3f 80 00       	push   $0x803f2c
  801f7d:	6a 46                	push   $0x46
  801f7f:	68 4f 3f 80 00       	push   $0x803f4f
  801f84:	e8 64 14 00 00       	call   8033ed <_panic>
  801f89:	a1 50 50 80 00       	mov    0x805050,%eax
  801f8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f91:	c1 e2 04             	shl    $0x4,%edx
  801f94:	01 d0                	add    %edx,%eax
  801f96:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801f9c:	89 10                	mov    %edx,(%eax)
  801f9e:	8b 00                	mov    (%eax),%eax
  801fa0:	85 c0                	test   %eax,%eax
  801fa2:	74 18                	je     801fbc <initialize_MemBlocksList+0x88>
  801fa4:	a1 48 51 80 00       	mov    0x805148,%eax
  801fa9:	8b 15 50 50 80 00    	mov    0x805050,%edx
  801faf:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801fb2:	c1 e1 04             	shl    $0x4,%ecx
  801fb5:	01 ca                	add    %ecx,%edx
  801fb7:	89 50 04             	mov    %edx,0x4(%eax)
  801fba:	eb 12                	jmp    801fce <initialize_MemBlocksList+0x9a>
  801fbc:	a1 50 50 80 00       	mov    0x805050,%eax
  801fc1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fc4:	c1 e2 04             	shl    $0x4,%edx
  801fc7:	01 d0                	add    %edx,%eax
  801fc9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801fce:	a1 50 50 80 00       	mov    0x805050,%eax
  801fd3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fd6:	c1 e2 04             	shl    $0x4,%edx
  801fd9:	01 d0                	add    %edx,%eax
  801fdb:	a3 48 51 80 00       	mov    %eax,0x805148
  801fe0:	a1 50 50 80 00       	mov    0x805050,%eax
  801fe5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fe8:	c1 e2 04             	shl    $0x4,%edx
  801feb:	01 d0                	add    %edx,%eax
  801fed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ff4:	a1 54 51 80 00       	mov    0x805154,%eax
  801ff9:	40                   	inc    %eax
  801ffa:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801fff:	ff 45 f4             	incl   -0xc(%ebp)
  802002:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802005:	3b 45 08             	cmp    0x8(%ebp),%eax
  802008:	0f 82 56 ff ff ff    	jb     801f64 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  80200e:	90                   	nop
  80200f:	c9                   	leave  
  802010:	c3                   	ret    

00802011 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802011:	55                   	push   %ebp
  802012:	89 e5                	mov    %esp,%ebp
  802014:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802017:	8b 45 08             	mov    0x8(%ebp),%eax
  80201a:	8b 00                	mov    (%eax),%eax
  80201c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80201f:	eb 19                	jmp    80203a <find_block+0x29>
	{
		if(va==point->sva)
  802021:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802024:	8b 40 08             	mov    0x8(%eax),%eax
  802027:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80202a:	75 05                	jne    802031 <find_block+0x20>
		   return point;
  80202c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80202f:	eb 36                	jmp    802067 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802031:	8b 45 08             	mov    0x8(%ebp),%eax
  802034:	8b 40 08             	mov    0x8(%eax),%eax
  802037:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80203a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80203e:	74 07                	je     802047 <find_block+0x36>
  802040:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802043:	8b 00                	mov    (%eax),%eax
  802045:	eb 05                	jmp    80204c <find_block+0x3b>
  802047:	b8 00 00 00 00       	mov    $0x0,%eax
  80204c:	8b 55 08             	mov    0x8(%ebp),%edx
  80204f:	89 42 08             	mov    %eax,0x8(%edx)
  802052:	8b 45 08             	mov    0x8(%ebp),%eax
  802055:	8b 40 08             	mov    0x8(%eax),%eax
  802058:	85 c0                	test   %eax,%eax
  80205a:	75 c5                	jne    802021 <find_block+0x10>
  80205c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802060:	75 bf                	jne    802021 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802062:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802067:	c9                   	leave  
  802068:	c3                   	ret    

00802069 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802069:	55                   	push   %ebp
  80206a:	89 e5                	mov    %esp,%ebp
  80206c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80206f:	a1 40 50 80 00       	mov    0x805040,%eax
  802074:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802077:	a1 44 50 80 00       	mov    0x805044,%eax
  80207c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80207f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802082:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802085:	74 24                	je     8020ab <insert_sorted_allocList+0x42>
  802087:	8b 45 08             	mov    0x8(%ebp),%eax
  80208a:	8b 50 08             	mov    0x8(%eax),%edx
  80208d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802090:	8b 40 08             	mov    0x8(%eax),%eax
  802093:	39 c2                	cmp    %eax,%edx
  802095:	76 14                	jbe    8020ab <insert_sorted_allocList+0x42>
  802097:	8b 45 08             	mov    0x8(%ebp),%eax
  80209a:	8b 50 08             	mov    0x8(%eax),%edx
  80209d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020a0:	8b 40 08             	mov    0x8(%eax),%eax
  8020a3:	39 c2                	cmp    %eax,%edx
  8020a5:	0f 82 60 01 00 00    	jb     80220b <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8020ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020af:	75 65                	jne    802116 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8020b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020b5:	75 14                	jne    8020cb <insert_sorted_allocList+0x62>
  8020b7:	83 ec 04             	sub    $0x4,%esp
  8020ba:	68 2c 3f 80 00       	push   $0x803f2c
  8020bf:	6a 6b                	push   $0x6b
  8020c1:	68 4f 3f 80 00       	push   $0x803f4f
  8020c6:	e8 22 13 00 00       	call   8033ed <_panic>
  8020cb:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8020d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d4:	89 10                	mov    %edx,(%eax)
  8020d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d9:	8b 00                	mov    (%eax),%eax
  8020db:	85 c0                	test   %eax,%eax
  8020dd:	74 0d                	je     8020ec <insert_sorted_allocList+0x83>
  8020df:	a1 40 50 80 00       	mov    0x805040,%eax
  8020e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8020e7:	89 50 04             	mov    %edx,0x4(%eax)
  8020ea:	eb 08                	jmp    8020f4 <insert_sorted_allocList+0x8b>
  8020ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ef:	a3 44 50 80 00       	mov    %eax,0x805044
  8020f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f7:	a3 40 50 80 00       	mov    %eax,0x805040
  8020fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802106:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80210b:	40                   	inc    %eax
  80210c:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802111:	e9 dc 01 00 00       	jmp    8022f2 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802116:	8b 45 08             	mov    0x8(%ebp),%eax
  802119:	8b 50 08             	mov    0x8(%eax),%edx
  80211c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80211f:	8b 40 08             	mov    0x8(%eax),%eax
  802122:	39 c2                	cmp    %eax,%edx
  802124:	77 6c                	ja     802192 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802126:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80212a:	74 06                	je     802132 <insert_sorted_allocList+0xc9>
  80212c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802130:	75 14                	jne    802146 <insert_sorted_allocList+0xdd>
  802132:	83 ec 04             	sub    $0x4,%esp
  802135:	68 68 3f 80 00       	push   $0x803f68
  80213a:	6a 6f                	push   $0x6f
  80213c:	68 4f 3f 80 00       	push   $0x803f4f
  802141:	e8 a7 12 00 00       	call   8033ed <_panic>
  802146:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802149:	8b 50 04             	mov    0x4(%eax),%edx
  80214c:	8b 45 08             	mov    0x8(%ebp),%eax
  80214f:	89 50 04             	mov    %edx,0x4(%eax)
  802152:	8b 45 08             	mov    0x8(%ebp),%eax
  802155:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802158:	89 10                	mov    %edx,(%eax)
  80215a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80215d:	8b 40 04             	mov    0x4(%eax),%eax
  802160:	85 c0                	test   %eax,%eax
  802162:	74 0d                	je     802171 <insert_sorted_allocList+0x108>
  802164:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802167:	8b 40 04             	mov    0x4(%eax),%eax
  80216a:	8b 55 08             	mov    0x8(%ebp),%edx
  80216d:	89 10                	mov    %edx,(%eax)
  80216f:	eb 08                	jmp    802179 <insert_sorted_allocList+0x110>
  802171:	8b 45 08             	mov    0x8(%ebp),%eax
  802174:	a3 40 50 80 00       	mov    %eax,0x805040
  802179:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80217c:	8b 55 08             	mov    0x8(%ebp),%edx
  80217f:	89 50 04             	mov    %edx,0x4(%eax)
  802182:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802187:	40                   	inc    %eax
  802188:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80218d:	e9 60 01 00 00       	jmp    8022f2 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802192:	8b 45 08             	mov    0x8(%ebp),%eax
  802195:	8b 50 08             	mov    0x8(%eax),%edx
  802198:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80219b:	8b 40 08             	mov    0x8(%eax),%eax
  80219e:	39 c2                	cmp    %eax,%edx
  8021a0:	0f 82 4c 01 00 00    	jb     8022f2 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8021a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021aa:	75 14                	jne    8021c0 <insert_sorted_allocList+0x157>
  8021ac:	83 ec 04             	sub    $0x4,%esp
  8021af:	68 a0 3f 80 00       	push   $0x803fa0
  8021b4:	6a 73                	push   $0x73
  8021b6:	68 4f 3f 80 00       	push   $0x803f4f
  8021bb:	e8 2d 12 00 00       	call   8033ed <_panic>
  8021c0:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8021c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c9:	89 50 04             	mov    %edx,0x4(%eax)
  8021cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cf:	8b 40 04             	mov    0x4(%eax),%eax
  8021d2:	85 c0                	test   %eax,%eax
  8021d4:	74 0c                	je     8021e2 <insert_sorted_allocList+0x179>
  8021d6:	a1 44 50 80 00       	mov    0x805044,%eax
  8021db:	8b 55 08             	mov    0x8(%ebp),%edx
  8021de:	89 10                	mov    %edx,(%eax)
  8021e0:	eb 08                	jmp    8021ea <insert_sorted_allocList+0x181>
  8021e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e5:	a3 40 50 80 00       	mov    %eax,0x805040
  8021ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ed:	a3 44 50 80 00       	mov    %eax,0x805044
  8021f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021fb:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802200:	40                   	inc    %eax
  802201:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802206:	e9 e7 00 00 00       	jmp    8022f2 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80220b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80220e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802211:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802218:	a1 40 50 80 00       	mov    0x805040,%eax
  80221d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802220:	e9 9d 00 00 00       	jmp    8022c2 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802225:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802228:	8b 00                	mov    (%eax),%eax
  80222a:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80222d:	8b 45 08             	mov    0x8(%ebp),%eax
  802230:	8b 50 08             	mov    0x8(%eax),%edx
  802233:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802236:	8b 40 08             	mov    0x8(%eax),%eax
  802239:	39 c2                	cmp    %eax,%edx
  80223b:	76 7d                	jbe    8022ba <insert_sorted_allocList+0x251>
  80223d:	8b 45 08             	mov    0x8(%ebp),%eax
  802240:	8b 50 08             	mov    0x8(%eax),%edx
  802243:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802246:	8b 40 08             	mov    0x8(%eax),%eax
  802249:	39 c2                	cmp    %eax,%edx
  80224b:	73 6d                	jae    8022ba <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80224d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802251:	74 06                	je     802259 <insert_sorted_allocList+0x1f0>
  802253:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802257:	75 14                	jne    80226d <insert_sorted_allocList+0x204>
  802259:	83 ec 04             	sub    $0x4,%esp
  80225c:	68 c4 3f 80 00       	push   $0x803fc4
  802261:	6a 7f                	push   $0x7f
  802263:	68 4f 3f 80 00       	push   $0x803f4f
  802268:	e8 80 11 00 00       	call   8033ed <_panic>
  80226d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802270:	8b 10                	mov    (%eax),%edx
  802272:	8b 45 08             	mov    0x8(%ebp),%eax
  802275:	89 10                	mov    %edx,(%eax)
  802277:	8b 45 08             	mov    0x8(%ebp),%eax
  80227a:	8b 00                	mov    (%eax),%eax
  80227c:	85 c0                	test   %eax,%eax
  80227e:	74 0b                	je     80228b <insert_sorted_allocList+0x222>
  802280:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802283:	8b 00                	mov    (%eax),%eax
  802285:	8b 55 08             	mov    0x8(%ebp),%edx
  802288:	89 50 04             	mov    %edx,0x4(%eax)
  80228b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228e:	8b 55 08             	mov    0x8(%ebp),%edx
  802291:	89 10                	mov    %edx,(%eax)
  802293:	8b 45 08             	mov    0x8(%ebp),%eax
  802296:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802299:	89 50 04             	mov    %edx,0x4(%eax)
  80229c:	8b 45 08             	mov    0x8(%ebp),%eax
  80229f:	8b 00                	mov    (%eax),%eax
  8022a1:	85 c0                	test   %eax,%eax
  8022a3:	75 08                	jne    8022ad <insert_sorted_allocList+0x244>
  8022a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a8:	a3 44 50 80 00       	mov    %eax,0x805044
  8022ad:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022b2:	40                   	inc    %eax
  8022b3:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8022b8:	eb 39                	jmp    8022f3 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8022ba:	a1 48 50 80 00       	mov    0x805048,%eax
  8022bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022c6:	74 07                	je     8022cf <insert_sorted_allocList+0x266>
  8022c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cb:	8b 00                	mov    (%eax),%eax
  8022cd:	eb 05                	jmp    8022d4 <insert_sorted_allocList+0x26b>
  8022cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d4:	a3 48 50 80 00       	mov    %eax,0x805048
  8022d9:	a1 48 50 80 00       	mov    0x805048,%eax
  8022de:	85 c0                	test   %eax,%eax
  8022e0:	0f 85 3f ff ff ff    	jne    802225 <insert_sorted_allocList+0x1bc>
  8022e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022ea:	0f 85 35 ff ff ff    	jne    802225 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8022f0:	eb 01                	jmp    8022f3 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022f2:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8022f3:	90                   	nop
  8022f4:	c9                   	leave  
  8022f5:	c3                   	ret    

008022f6 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8022f6:	55                   	push   %ebp
  8022f7:	89 e5                	mov    %esp,%ebp
  8022f9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8022fc:	a1 38 51 80 00       	mov    0x805138,%eax
  802301:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802304:	e9 85 01 00 00       	jmp    80248e <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802309:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230c:	8b 40 0c             	mov    0xc(%eax),%eax
  80230f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802312:	0f 82 6e 01 00 00    	jb     802486 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802318:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231b:	8b 40 0c             	mov    0xc(%eax),%eax
  80231e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802321:	0f 85 8a 00 00 00    	jne    8023b1 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802327:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80232b:	75 17                	jne    802344 <alloc_block_FF+0x4e>
  80232d:	83 ec 04             	sub    $0x4,%esp
  802330:	68 f8 3f 80 00       	push   $0x803ff8
  802335:	68 93 00 00 00       	push   $0x93
  80233a:	68 4f 3f 80 00       	push   $0x803f4f
  80233f:	e8 a9 10 00 00       	call   8033ed <_panic>
  802344:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802347:	8b 00                	mov    (%eax),%eax
  802349:	85 c0                	test   %eax,%eax
  80234b:	74 10                	je     80235d <alloc_block_FF+0x67>
  80234d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802350:	8b 00                	mov    (%eax),%eax
  802352:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802355:	8b 52 04             	mov    0x4(%edx),%edx
  802358:	89 50 04             	mov    %edx,0x4(%eax)
  80235b:	eb 0b                	jmp    802368 <alloc_block_FF+0x72>
  80235d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802360:	8b 40 04             	mov    0x4(%eax),%eax
  802363:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802368:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236b:	8b 40 04             	mov    0x4(%eax),%eax
  80236e:	85 c0                	test   %eax,%eax
  802370:	74 0f                	je     802381 <alloc_block_FF+0x8b>
  802372:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802375:	8b 40 04             	mov    0x4(%eax),%eax
  802378:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80237b:	8b 12                	mov    (%edx),%edx
  80237d:	89 10                	mov    %edx,(%eax)
  80237f:	eb 0a                	jmp    80238b <alloc_block_FF+0x95>
  802381:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802384:	8b 00                	mov    (%eax),%eax
  802386:	a3 38 51 80 00       	mov    %eax,0x805138
  80238b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802394:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802397:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80239e:	a1 44 51 80 00       	mov    0x805144,%eax
  8023a3:	48                   	dec    %eax
  8023a4:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8023a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ac:	e9 10 01 00 00       	jmp    8024c1 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8023b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8023b7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023ba:	0f 86 c6 00 00 00    	jbe    802486 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8023c0:	a1 48 51 80 00       	mov    0x805148,%eax
  8023c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8023c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cb:	8b 50 08             	mov    0x8(%eax),%edx
  8023ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d1:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8023d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8023da:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8023dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023e1:	75 17                	jne    8023fa <alloc_block_FF+0x104>
  8023e3:	83 ec 04             	sub    $0x4,%esp
  8023e6:	68 f8 3f 80 00       	push   $0x803ff8
  8023eb:	68 9b 00 00 00       	push   $0x9b
  8023f0:	68 4f 3f 80 00       	push   $0x803f4f
  8023f5:	e8 f3 0f 00 00       	call   8033ed <_panic>
  8023fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023fd:	8b 00                	mov    (%eax),%eax
  8023ff:	85 c0                	test   %eax,%eax
  802401:	74 10                	je     802413 <alloc_block_FF+0x11d>
  802403:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802406:	8b 00                	mov    (%eax),%eax
  802408:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80240b:	8b 52 04             	mov    0x4(%edx),%edx
  80240e:	89 50 04             	mov    %edx,0x4(%eax)
  802411:	eb 0b                	jmp    80241e <alloc_block_FF+0x128>
  802413:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802416:	8b 40 04             	mov    0x4(%eax),%eax
  802419:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80241e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802421:	8b 40 04             	mov    0x4(%eax),%eax
  802424:	85 c0                	test   %eax,%eax
  802426:	74 0f                	je     802437 <alloc_block_FF+0x141>
  802428:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80242b:	8b 40 04             	mov    0x4(%eax),%eax
  80242e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802431:	8b 12                	mov    (%edx),%edx
  802433:	89 10                	mov    %edx,(%eax)
  802435:	eb 0a                	jmp    802441 <alloc_block_FF+0x14b>
  802437:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80243a:	8b 00                	mov    (%eax),%eax
  80243c:	a3 48 51 80 00       	mov    %eax,0x805148
  802441:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802444:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80244a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80244d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802454:	a1 54 51 80 00       	mov    0x805154,%eax
  802459:	48                   	dec    %eax
  80245a:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  80245f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802462:	8b 50 08             	mov    0x8(%eax),%edx
  802465:	8b 45 08             	mov    0x8(%ebp),%eax
  802468:	01 c2                	add    %eax,%edx
  80246a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246d:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802470:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802473:	8b 40 0c             	mov    0xc(%eax),%eax
  802476:	2b 45 08             	sub    0x8(%ebp),%eax
  802479:	89 c2                	mov    %eax,%edx
  80247b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247e:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802481:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802484:	eb 3b                	jmp    8024c1 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802486:	a1 40 51 80 00       	mov    0x805140,%eax
  80248b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80248e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802492:	74 07                	je     80249b <alloc_block_FF+0x1a5>
  802494:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802497:	8b 00                	mov    (%eax),%eax
  802499:	eb 05                	jmp    8024a0 <alloc_block_FF+0x1aa>
  80249b:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a0:	a3 40 51 80 00       	mov    %eax,0x805140
  8024a5:	a1 40 51 80 00       	mov    0x805140,%eax
  8024aa:	85 c0                	test   %eax,%eax
  8024ac:	0f 85 57 fe ff ff    	jne    802309 <alloc_block_FF+0x13>
  8024b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024b6:	0f 85 4d fe ff ff    	jne    802309 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8024bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024c1:	c9                   	leave  
  8024c2:	c3                   	ret    

008024c3 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8024c3:	55                   	push   %ebp
  8024c4:	89 e5                	mov    %esp,%ebp
  8024c6:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8024c9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8024d0:	a1 38 51 80 00       	mov    0x805138,%eax
  8024d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024d8:	e9 df 00 00 00       	jmp    8025bc <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8024dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8024e3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024e6:	0f 82 c8 00 00 00    	jb     8025b4 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8024ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8024f2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024f5:	0f 85 8a 00 00 00    	jne    802585 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8024fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024ff:	75 17                	jne    802518 <alloc_block_BF+0x55>
  802501:	83 ec 04             	sub    $0x4,%esp
  802504:	68 f8 3f 80 00       	push   $0x803ff8
  802509:	68 b7 00 00 00       	push   $0xb7
  80250e:	68 4f 3f 80 00       	push   $0x803f4f
  802513:	e8 d5 0e 00 00       	call   8033ed <_panic>
  802518:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251b:	8b 00                	mov    (%eax),%eax
  80251d:	85 c0                	test   %eax,%eax
  80251f:	74 10                	je     802531 <alloc_block_BF+0x6e>
  802521:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802524:	8b 00                	mov    (%eax),%eax
  802526:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802529:	8b 52 04             	mov    0x4(%edx),%edx
  80252c:	89 50 04             	mov    %edx,0x4(%eax)
  80252f:	eb 0b                	jmp    80253c <alloc_block_BF+0x79>
  802531:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802534:	8b 40 04             	mov    0x4(%eax),%eax
  802537:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80253c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253f:	8b 40 04             	mov    0x4(%eax),%eax
  802542:	85 c0                	test   %eax,%eax
  802544:	74 0f                	je     802555 <alloc_block_BF+0x92>
  802546:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802549:	8b 40 04             	mov    0x4(%eax),%eax
  80254c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80254f:	8b 12                	mov    (%edx),%edx
  802551:	89 10                	mov    %edx,(%eax)
  802553:	eb 0a                	jmp    80255f <alloc_block_BF+0x9c>
  802555:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802558:	8b 00                	mov    (%eax),%eax
  80255a:	a3 38 51 80 00       	mov    %eax,0x805138
  80255f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802562:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802568:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802572:	a1 44 51 80 00       	mov    0x805144,%eax
  802577:	48                   	dec    %eax
  802578:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  80257d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802580:	e9 4d 01 00 00       	jmp    8026d2 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802585:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802588:	8b 40 0c             	mov    0xc(%eax),%eax
  80258b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80258e:	76 24                	jbe    8025b4 <alloc_block_BF+0xf1>
  802590:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802593:	8b 40 0c             	mov    0xc(%eax),%eax
  802596:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802599:	73 19                	jae    8025b4 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80259b:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8025a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8025a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8025ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ae:	8b 40 08             	mov    0x8(%eax),%eax
  8025b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8025b4:	a1 40 51 80 00       	mov    0x805140,%eax
  8025b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025c0:	74 07                	je     8025c9 <alloc_block_BF+0x106>
  8025c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c5:	8b 00                	mov    (%eax),%eax
  8025c7:	eb 05                	jmp    8025ce <alloc_block_BF+0x10b>
  8025c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ce:	a3 40 51 80 00       	mov    %eax,0x805140
  8025d3:	a1 40 51 80 00       	mov    0x805140,%eax
  8025d8:	85 c0                	test   %eax,%eax
  8025da:	0f 85 fd fe ff ff    	jne    8024dd <alloc_block_BF+0x1a>
  8025e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025e4:	0f 85 f3 fe ff ff    	jne    8024dd <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8025ea:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8025ee:	0f 84 d9 00 00 00    	je     8026cd <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8025f4:	a1 48 51 80 00       	mov    0x805148,%eax
  8025f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8025fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025ff:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802602:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802605:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802608:	8b 55 08             	mov    0x8(%ebp),%edx
  80260b:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  80260e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802612:	75 17                	jne    80262b <alloc_block_BF+0x168>
  802614:	83 ec 04             	sub    $0x4,%esp
  802617:	68 f8 3f 80 00       	push   $0x803ff8
  80261c:	68 c7 00 00 00       	push   $0xc7
  802621:	68 4f 3f 80 00       	push   $0x803f4f
  802626:	e8 c2 0d 00 00       	call   8033ed <_panic>
  80262b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80262e:	8b 00                	mov    (%eax),%eax
  802630:	85 c0                	test   %eax,%eax
  802632:	74 10                	je     802644 <alloc_block_BF+0x181>
  802634:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802637:	8b 00                	mov    (%eax),%eax
  802639:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80263c:	8b 52 04             	mov    0x4(%edx),%edx
  80263f:	89 50 04             	mov    %edx,0x4(%eax)
  802642:	eb 0b                	jmp    80264f <alloc_block_BF+0x18c>
  802644:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802647:	8b 40 04             	mov    0x4(%eax),%eax
  80264a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80264f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802652:	8b 40 04             	mov    0x4(%eax),%eax
  802655:	85 c0                	test   %eax,%eax
  802657:	74 0f                	je     802668 <alloc_block_BF+0x1a5>
  802659:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80265c:	8b 40 04             	mov    0x4(%eax),%eax
  80265f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802662:	8b 12                	mov    (%edx),%edx
  802664:	89 10                	mov    %edx,(%eax)
  802666:	eb 0a                	jmp    802672 <alloc_block_BF+0x1af>
  802668:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80266b:	8b 00                	mov    (%eax),%eax
  80266d:	a3 48 51 80 00       	mov    %eax,0x805148
  802672:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802675:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80267b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80267e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802685:	a1 54 51 80 00       	mov    0x805154,%eax
  80268a:	48                   	dec    %eax
  80268b:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802690:	83 ec 08             	sub    $0x8,%esp
  802693:	ff 75 ec             	pushl  -0x14(%ebp)
  802696:	68 38 51 80 00       	push   $0x805138
  80269b:	e8 71 f9 ff ff       	call   802011 <find_block>
  8026a0:	83 c4 10             	add    $0x10,%esp
  8026a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8026a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026a9:	8b 50 08             	mov    0x8(%eax),%edx
  8026ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8026af:	01 c2                	add    %eax,%edx
  8026b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026b4:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8026b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8026bd:	2b 45 08             	sub    0x8(%ebp),%eax
  8026c0:	89 c2                	mov    %eax,%edx
  8026c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026c5:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8026c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026cb:	eb 05                	jmp    8026d2 <alloc_block_BF+0x20f>
	}
	return NULL;
  8026cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026d2:	c9                   	leave  
  8026d3:	c3                   	ret    

008026d4 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8026d4:	55                   	push   %ebp
  8026d5:	89 e5                	mov    %esp,%ebp
  8026d7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8026da:	a1 28 50 80 00       	mov    0x805028,%eax
  8026df:	85 c0                	test   %eax,%eax
  8026e1:	0f 85 de 01 00 00    	jne    8028c5 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8026e7:	a1 38 51 80 00       	mov    0x805138,%eax
  8026ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026ef:	e9 9e 01 00 00       	jmp    802892 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8026f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8026fa:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026fd:	0f 82 87 01 00 00    	jb     80288a <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802703:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802706:	8b 40 0c             	mov    0xc(%eax),%eax
  802709:	3b 45 08             	cmp    0x8(%ebp),%eax
  80270c:	0f 85 95 00 00 00    	jne    8027a7 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802712:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802716:	75 17                	jne    80272f <alloc_block_NF+0x5b>
  802718:	83 ec 04             	sub    $0x4,%esp
  80271b:	68 f8 3f 80 00       	push   $0x803ff8
  802720:	68 e0 00 00 00       	push   $0xe0
  802725:	68 4f 3f 80 00       	push   $0x803f4f
  80272a:	e8 be 0c 00 00       	call   8033ed <_panic>
  80272f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802732:	8b 00                	mov    (%eax),%eax
  802734:	85 c0                	test   %eax,%eax
  802736:	74 10                	je     802748 <alloc_block_NF+0x74>
  802738:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273b:	8b 00                	mov    (%eax),%eax
  80273d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802740:	8b 52 04             	mov    0x4(%edx),%edx
  802743:	89 50 04             	mov    %edx,0x4(%eax)
  802746:	eb 0b                	jmp    802753 <alloc_block_NF+0x7f>
  802748:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274b:	8b 40 04             	mov    0x4(%eax),%eax
  80274e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802753:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802756:	8b 40 04             	mov    0x4(%eax),%eax
  802759:	85 c0                	test   %eax,%eax
  80275b:	74 0f                	je     80276c <alloc_block_NF+0x98>
  80275d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802760:	8b 40 04             	mov    0x4(%eax),%eax
  802763:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802766:	8b 12                	mov    (%edx),%edx
  802768:	89 10                	mov    %edx,(%eax)
  80276a:	eb 0a                	jmp    802776 <alloc_block_NF+0xa2>
  80276c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276f:	8b 00                	mov    (%eax),%eax
  802771:	a3 38 51 80 00       	mov    %eax,0x805138
  802776:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802779:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80277f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802782:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802789:	a1 44 51 80 00       	mov    0x805144,%eax
  80278e:	48                   	dec    %eax
  80278f:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802794:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802797:	8b 40 08             	mov    0x8(%eax),%eax
  80279a:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  80279f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a2:	e9 f8 04 00 00       	jmp    802c9f <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8027a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027aa:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ad:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027b0:	0f 86 d4 00 00 00    	jbe    80288a <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8027b6:	a1 48 51 80 00       	mov    0x805148,%eax
  8027bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8027be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c1:	8b 50 08             	mov    0x8(%eax),%edx
  8027c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c7:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8027ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8027d0:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8027d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027d7:	75 17                	jne    8027f0 <alloc_block_NF+0x11c>
  8027d9:	83 ec 04             	sub    $0x4,%esp
  8027dc:	68 f8 3f 80 00       	push   $0x803ff8
  8027e1:	68 e9 00 00 00       	push   $0xe9
  8027e6:	68 4f 3f 80 00       	push   $0x803f4f
  8027eb:	e8 fd 0b 00 00       	call   8033ed <_panic>
  8027f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f3:	8b 00                	mov    (%eax),%eax
  8027f5:	85 c0                	test   %eax,%eax
  8027f7:	74 10                	je     802809 <alloc_block_NF+0x135>
  8027f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027fc:	8b 00                	mov    (%eax),%eax
  8027fe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802801:	8b 52 04             	mov    0x4(%edx),%edx
  802804:	89 50 04             	mov    %edx,0x4(%eax)
  802807:	eb 0b                	jmp    802814 <alloc_block_NF+0x140>
  802809:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80280c:	8b 40 04             	mov    0x4(%eax),%eax
  80280f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802814:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802817:	8b 40 04             	mov    0x4(%eax),%eax
  80281a:	85 c0                	test   %eax,%eax
  80281c:	74 0f                	je     80282d <alloc_block_NF+0x159>
  80281e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802821:	8b 40 04             	mov    0x4(%eax),%eax
  802824:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802827:	8b 12                	mov    (%edx),%edx
  802829:	89 10                	mov    %edx,(%eax)
  80282b:	eb 0a                	jmp    802837 <alloc_block_NF+0x163>
  80282d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802830:	8b 00                	mov    (%eax),%eax
  802832:	a3 48 51 80 00       	mov    %eax,0x805148
  802837:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80283a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802840:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802843:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80284a:	a1 54 51 80 00       	mov    0x805154,%eax
  80284f:	48                   	dec    %eax
  802850:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802855:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802858:	8b 40 08             	mov    0x8(%eax),%eax
  80285b:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802860:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802863:	8b 50 08             	mov    0x8(%eax),%edx
  802866:	8b 45 08             	mov    0x8(%ebp),%eax
  802869:	01 c2                	add    %eax,%edx
  80286b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286e:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802871:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802874:	8b 40 0c             	mov    0xc(%eax),%eax
  802877:	2b 45 08             	sub    0x8(%ebp),%eax
  80287a:	89 c2                	mov    %eax,%edx
  80287c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287f:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802882:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802885:	e9 15 04 00 00       	jmp    802c9f <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80288a:	a1 40 51 80 00       	mov    0x805140,%eax
  80288f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802892:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802896:	74 07                	je     80289f <alloc_block_NF+0x1cb>
  802898:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289b:	8b 00                	mov    (%eax),%eax
  80289d:	eb 05                	jmp    8028a4 <alloc_block_NF+0x1d0>
  80289f:	b8 00 00 00 00       	mov    $0x0,%eax
  8028a4:	a3 40 51 80 00       	mov    %eax,0x805140
  8028a9:	a1 40 51 80 00       	mov    0x805140,%eax
  8028ae:	85 c0                	test   %eax,%eax
  8028b0:	0f 85 3e fe ff ff    	jne    8026f4 <alloc_block_NF+0x20>
  8028b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028ba:	0f 85 34 fe ff ff    	jne    8026f4 <alloc_block_NF+0x20>
  8028c0:	e9 d5 03 00 00       	jmp    802c9a <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8028c5:	a1 38 51 80 00       	mov    0x805138,%eax
  8028ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028cd:	e9 b1 01 00 00       	jmp    802a83 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8028d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d5:	8b 50 08             	mov    0x8(%eax),%edx
  8028d8:	a1 28 50 80 00       	mov    0x805028,%eax
  8028dd:	39 c2                	cmp    %eax,%edx
  8028df:	0f 82 96 01 00 00    	jb     802a7b <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8028e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8028eb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028ee:	0f 82 87 01 00 00    	jb     802a7b <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8028f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8028fa:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028fd:	0f 85 95 00 00 00    	jne    802998 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802903:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802907:	75 17                	jne    802920 <alloc_block_NF+0x24c>
  802909:	83 ec 04             	sub    $0x4,%esp
  80290c:	68 f8 3f 80 00       	push   $0x803ff8
  802911:	68 fc 00 00 00       	push   $0xfc
  802916:	68 4f 3f 80 00       	push   $0x803f4f
  80291b:	e8 cd 0a 00 00       	call   8033ed <_panic>
  802920:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802923:	8b 00                	mov    (%eax),%eax
  802925:	85 c0                	test   %eax,%eax
  802927:	74 10                	je     802939 <alloc_block_NF+0x265>
  802929:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292c:	8b 00                	mov    (%eax),%eax
  80292e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802931:	8b 52 04             	mov    0x4(%edx),%edx
  802934:	89 50 04             	mov    %edx,0x4(%eax)
  802937:	eb 0b                	jmp    802944 <alloc_block_NF+0x270>
  802939:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293c:	8b 40 04             	mov    0x4(%eax),%eax
  80293f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802944:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802947:	8b 40 04             	mov    0x4(%eax),%eax
  80294a:	85 c0                	test   %eax,%eax
  80294c:	74 0f                	je     80295d <alloc_block_NF+0x289>
  80294e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802951:	8b 40 04             	mov    0x4(%eax),%eax
  802954:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802957:	8b 12                	mov    (%edx),%edx
  802959:	89 10                	mov    %edx,(%eax)
  80295b:	eb 0a                	jmp    802967 <alloc_block_NF+0x293>
  80295d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802960:	8b 00                	mov    (%eax),%eax
  802962:	a3 38 51 80 00       	mov    %eax,0x805138
  802967:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802970:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802973:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80297a:	a1 44 51 80 00       	mov    0x805144,%eax
  80297f:	48                   	dec    %eax
  802980:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802985:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802988:	8b 40 08             	mov    0x8(%eax),%eax
  80298b:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802990:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802993:	e9 07 03 00 00       	jmp    802c9f <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802998:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299b:	8b 40 0c             	mov    0xc(%eax),%eax
  80299e:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029a1:	0f 86 d4 00 00 00    	jbe    802a7b <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8029a7:	a1 48 51 80 00       	mov    0x805148,%eax
  8029ac:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8029af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b2:	8b 50 08             	mov    0x8(%eax),%edx
  8029b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029b8:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8029bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029be:	8b 55 08             	mov    0x8(%ebp),%edx
  8029c1:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8029c4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029c8:	75 17                	jne    8029e1 <alloc_block_NF+0x30d>
  8029ca:	83 ec 04             	sub    $0x4,%esp
  8029cd:	68 f8 3f 80 00       	push   $0x803ff8
  8029d2:	68 04 01 00 00       	push   $0x104
  8029d7:	68 4f 3f 80 00       	push   $0x803f4f
  8029dc:	e8 0c 0a 00 00       	call   8033ed <_panic>
  8029e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029e4:	8b 00                	mov    (%eax),%eax
  8029e6:	85 c0                	test   %eax,%eax
  8029e8:	74 10                	je     8029fa <alloc_block_NF+0x326>
  8029ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029ed:	8b 00                	mov    (%eax),%eax
  8029ef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029f2:	8b 52 04             	mov    0x4(%edx),%edx
  8029f5:	89 50 04             	mov    %edx,0x4(%eax)
  8029f8:	eb 0b                	jmp    802a05 <alloc_block_NF+0x331>
  8029fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029fd:	8b 40 04             	mov    0x4(%eax),%eax
  802a00:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a05:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a08:	8b 40 04             	mov    0x4(%eax),%eax
  802a0b:	85 c0                	test   %eax,%eax
  802a0d:	74 0f                	je     802a1e <alloc_block_NF+0x34a>
  802a0f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a12:	8b 40 04             	mov    0x4(%eax),%eax
  802a15:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a18:	8b 12                	mov    (%edx),%edx
  802a1a:	89 10                	mov    %edx,(%eax)
  802a1c:	eb 0a                	jmp    802a28 <alloc_block_NF+0x354>
  802a1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a21:	8b 00                	mov    (%eax),%eax
  802a23:	a3 48 51 80 00       	mov    %eax,0x805148
  802a28:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a2b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a31:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a34:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a3b:	a1 54 51 80 00       	mov    0x805154,%eax
  802a40:	48                   	dec    %eax
  802a41:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802a46:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a49:	8b 40 08             	mov    0x8(%eax),%eax
  802a4c:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802a51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a54:	8b 50 08             	mov    0x8(%eax),%edx
  802a57:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5a:	01 c2                	add    %eax,%edx
  802a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5f:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a65:	8b 40 0c             	mov    0xc(%eax),%eax
  802a68:	2b 45 08             	sub    0x8(%ebp),%eax
  802a6b:	89 c2                	mov    %eax,%edx
  802a6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a70:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802a73:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a76:	e9 24 02 00 00       	jmp    802c9f <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a7b:	a1 40 51 80 00       	mov    0x805140,%eax
  802a80:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a83:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a87:	74 07                	je     802a90 <alloc_block_NF+0x3bc>
  802a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8c:	8b 00                	mov    (%eax),%eax
  802a8e:	eb 05                	jmp    802a95 <alloc_block_NF+0x3c1>
  802a90:	b8 00 00 00 00       	mov    $0x0,%eax
  802a95:	a3 40 51 80 00       	mov    %eax,0x805140
  802a9a:	a1 40 51 80 00       	mov    0x805140,%eax
  802a9f:	85 c0                	test   %eax,%eax
  802aa1:	0f 85 2b fe ff ff    	jne    8028d2 <alloc_block_NF+0x1fe>
  802aa7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aab:	0f 85 21 fe ff ff    	jne    8028d2 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802ab1:	a1 38 51 80 00       	mov    0x805138,%eax
  802ab6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ab9:	e9 ae 01 00 00       	jmp    802c6c <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac1:	8b 50 08             	mov    0x8(%eax),%edx
  802ac4:	a1 28 50 80 00       	mov    0x805028,%eax
  802ac9:	39 c2                	cmp    %eax,%edx
  802acb:	0f 83 93 01 00 00    	jae    802c64 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad4:	8b 40 0c             	mov    0xc(%eax),%eax
  802ad7:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ada:	0f 82 84 01 00 00    	jb     802c64 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae3:	8b 40 0c             	mov    0xc(%eax),%eax
  802ae6:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ae9:	0f 85 95 00 00 00    	jne    802b84 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802aef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802af3:	75 17                	jne    802b0c <alloc_block_NF+0x438>
  802af5:	83 ec 04             	sub    $0x4,%esp
  802af8:	68 f8 3f 80 00       	push   $0x803ff8
  802afd:	68 14 01 00 00       	push   $0x114
  802b02:	68 4f 3f 80 00       	push   $0x803f4f
  802b07:	e8 e1 08 00 00       	call   8033ed <_panic>
  802b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0f:	8b 00                	mov    (%eax),%eax
  802b11:	85 c0                	test   %eax,%eax
  802b13:	74 10                	je     802b25 <alloc_block_NF+0x451>
  802b15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b18:	8b 00                	mov    (%eax),%eax
  802b1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b1d:	8b 52 04             	mov    0x4(%edx),%edx
  802b20:	89 50 04             	mov    %edx,0x4(%eax)
  802b23:	eb 0b                	jmp    802b30 <alloc_block_NF+0x45c>
  802b25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b28:	8b 40 04             	mov    0x4(%eax),%eax
  802b2b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b33:	8b 40 04             	mov    0x4(%eax),%eax
  802b36:	85 c0                	test   %eax,%eax
  802b38:	74 0f                	je     802b49 <alloc_block_NF+0x475>
  802b3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3d:	8b 40 04             	mov    0x4(%eax),%eax
  802b40:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b43:	8b 12                	mov    (%edx),%edx
  802b45:	89 10                	mov    %edx,(%eax)
  802b47:	eb 0a                	jmp    802b53 <alloc_block_NF+0x47f>
  802b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4c:	8b 00                	mov    (%eax),%eax
  802b4e:	a3 38 51 80 00       	mov    %eax,0x805138
  802b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b56:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b66:	a1 44 51 80 00       	mov    0x805144,%eax
  802b6b:	48                   	dec    %eax
  802b6c:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802b71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b74:	8b 40 08             	mov    0x8(%eax),%eax
  802b77:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7f:	e9 1b 01 00 00       	jmp    802c9f <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802b84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b87:	8b 40 0c             	mov    0xc(%eax),%eax
  802b8a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b8d:	0f 86 d1 00 00 00    	jbe    802c64 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b93:	a1 48 51 80 00       	mov    0x805148,%eax
  802b98:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9e:	8b 50 08             	mov    0x8(%eax),%edx
  802ba1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba4:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802ba7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802baa:	8b 55 08             	mov    0x8(%ebp),%edx
  802bad:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802bb0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802bb4:	75 17                	jne    802bcd <alloc_block_NF+0x4f9>
  802bb6:	83 ec 04             	sub    $0x4,%esp
  802bb9:	68 f8 3f 80 00       	push   $0x803ff8
  802bbe:	68 1c 01 00 00       	push   $0x11c
  802bc3:	68 4f 3f 80 00       	push   $0x803f4f
  802bc8:	e8 20 08 00 00       	call   8033ed <_panic>
  802bcd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd0:	8b 00                	mov    (%eax),%eax
  802bd2:	85 c0                	test   %eax,%eax
  802bd4:	74 10                	je     802be6 <alloc_block_NF+0x512>
  802bd6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd9:	8b 00                	mov    (%eax),%eax
  802bdb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bde:	8b 52 04             	mov    0x4(%edx),%edx
  802be1:	89 50 04             	mov    %edx,0x4(%eax)
  802be4:	eb 0b                	jmp    802bf1 <alloc_block_NF+0x51d>
  802be6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802be9:	8b 40 04             	mov    0x4(%eax),%eax
  802bec:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802bf1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bf4:	8b 40 04             	mov    0x4(%eax),%eax
  802bf7:	85 c0                	test   %eax,%eax
  802bf9:	74 0f                	je     802c0a <alloc_block_NF+0x536>
  802bfb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bfe:	8b 40 04             	mov    0x4(%eax),%eax
  802c01:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c04:	8b 12                	mov    (%edx),%edx
  802c06:	89 10                	mov    %edx,(%eax)
  802c08:	eb 0a                	jmp    802c14 <alloc_block_NF+0x540>
  802c0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c0d:	8b 00                	mov    (%eax),%eax
  802c0f:	a3 48 51 80 00       	mov    %eax,0x805148
  802c14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c17:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c20:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c27:	a1 54 51 80 00       	mov    0x805154,%eax
  802c2c:	48                   	dec    %eax
  802c2d:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802c32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c35:	8b 40 08             	mov    0x8(%eax),%eax
  802c38:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802c3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c40:	8b 50 08             	mov    0x8(%eax),%edx
  802c43:	8b 45 08             	mov    0x8(%ebp),%eax
  802c46:	01 c2                	add    %eax,%edx
  802c48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4b:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802c4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c51:	8b 40 0c             	mov    0xc(%eax),%eax
  802c54:	2b 45 08             	sub    0x8(%ebp),%eax
  802c57:	89 c2                	mov    %eax,%edx
  802c59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5c:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802c5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c62:	eb 3b                	jmp    802c9f <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c64:	a1 40 51 80 00       	mov    0x805140,%eax
  802c69:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c6c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c70:	74 07                	je     802c79 <alloc_block_NF+0x5a5>
  802c72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c75:	8b 00                	mov    (%eax),%eax
  802c77:	eb 05                	jmp    802c7e <alloc_block_NF+0x5aa>
  802c79:	b8 00 00 00 00       	mov    $0x0,%eax
  802c7e:	a3 40 51 80 00       	mov    %eax,0x805140
  802c83:	a1 40 51 80 00       	mov    0x805140,%eax
  802c88:	85 c0                	test   %eax,%eax
  802c8a:	0f 85 2e fe ff ff    	jne    802abe <alloc_block_NF+0x3ea>
  802c90:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c94:	0f 85 24 fe ff ff    	jne    802abe <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802c9a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c9f:	c9                   	leave  
  802ca0:	c3                   	ret    

00802ca1 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802ca1:	55                   	push   %ebp
  802ca2:	89 e5                	mov    %esp,%ebp
  802ca4:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802ca7:	a1 38 51 80 00       	mov    0x805138,%eax
  802cac:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802caf:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802cb4:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802cb7:	a1 38 51 80 00       	mov    0x805138,%eax
  802cbc:	85 c0                	test   %eax,%eax
  802cbe:	74 14                	je     802cd4 <insert_sorted_with_merge_freeList+0x33>
  802cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc3:	8b 50 08             	mov    0x8(%eax),%edx
  802cc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc9:	8b 40 08             	mov    0x8(%eax),%eax
  802ccc:	39 c2                	cmp    %eax,%edx
  802cce:	0f 87 9b 01 00 00    	ja     802e6f <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802cd4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cd8:	75 17                	jne    802cf1 <insert_sorted_with_merge_freeList+0x50>
  802cda:	83 ec 04             	sub    $0x4,%esp
  802cdd:	68 2c 3f 80 00       	push   $0x803f2c
  802ce2:	68 38 01 00 00       	push   $0x138
  802ce7:	68 4f 3f 80 00       	push   $0x803f4f
  802cec:	e8 fc 06 00 00       	call   8033ed <_panic>
  802cf1:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfa:	89 10                	mov    %edx,(%eax)
  802cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  802cff:	8b 00                	mov    (%eax),%eax
  802d01:	85 c0                	test   %eax,%eax
  802d03:	74 0d                	je     802d12 <insert_sorted_with_merge_freeList+0x71>
  802d05:	a1 38 51 80 00       	mov    0x805138,%eax
  802d0a:	8b 55 08             	mov    0x8(%ebp),%edx
  802d0d:	89 50 04             	mov    %edx,0x4(%eax)
  802d10:	eb 08                	jmp    802d1a <insert_sorted_with_merge_freeList+0x79>
  802d12:	8b 45 08             	mov    0x8(%ebp),%eax
  802d15:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1d:	a3 38 51 80 00       	mov    %eax,0x805138
  802d22:	8b 45 08             	mov    0x8(%ebp),%eax
  802d25:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d2c:	a1 44 51 80 00       	mov    0x805144,%eax
  802d31:	40                   	inc    %eax
  802d32:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d37:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d3b:	0f 84 a8 06 00 00    	je     8033e9 <insert_sorted_with_merge_freeList+0x748>
  802d41:	8b 45 08             	mov    0x8(%ebp),%eax
  802d44:	8b 50 08             	mov    0x8(%eax),%edx
  802d47:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4a:	8b 40 0c             	mov    0xc(%eax),%eax
  802d4d:	01 c2                	add    %eax,%edx
  802d4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d52:	8b 40 08             	mov    0x8(%eax),%eax
  802d55:	39 c2                	cmp    %eax,%edx
  802d57:	0f 85 8c 06 00 00    	jne    8033e9 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d60:	8b 50 0c             	mov    0xc(%eax),%edx
  802d63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d66:	8b 40 0c             	mov    0xc(%eax),%eax
  802d69:	01 c2                	add    %eax,%edx
  802d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6e:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802d71:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d75:	75 17                	jne    802d8e <insert_sorted_with_merge_freeList+0xed>
  802d77:	83 ec 04             	sub    $0x4,%esp
  802d7a:	68 f8 3f 80 00       	push   $0x803ff8
  802d7f:	68 3c 01 00 00       	push   $0x13c
  802d84:	68 4f 3f 80 00       	push   $0x803f4f
  802d89:	e8 5f 06 00 00       	call   8033ed <_panic>
  802d8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d91:	8b 00                	mov    (%eax),%eax
  802d93:	85 c0                	test   %eax,%eax
  802d95:	74 10                	je     802da7 <insert_sorted_with_merge_freeList+0x106>
  802d97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d9a:	8b 00                	mov    (%eax),%eax
  802d9c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d9f:	8b 52 04             	mov    0x4(%edx),%edx
  802da2:	89 50 04             	mov    %edx,0x4(%eax)
  802da5:	eb 0b                	jmp    802db2 <insert_sorted_with_merge_freeList+0x111>
  802da7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802daa:	8b 40 04             	mov    0x4(%eax),%eax
  802dad:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802db2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db5:	8b 40 04             	mov    0x4(%eax),%eax
  802db8:	85 c0                	test   %eax,%eax
  802dba:	74 0f                	je     802dcb <insert_sorted_with_merge_freeList+0x12a>
  802dbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dbf:	8b 40 04             	mov    0x4(%eax),%eax
  802dc2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dc5:	8b 12                	mov    (%edx),%edx
  802dc7:	89 10                	mov    %edx,(%eax)
  802dc9:	eb 0a                	jmp    802dd5 <insert_sorted_with_merge_freeList+0x134>
  802dcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dce:	8b 00                	mov    (%eax),%eax
  802dd0:	a3 38 51 80 00       	mov    %eax,0x805138
  802dd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802de8:	a1 44 51 80 00       	mov    0x805144,%eax
  802ded:	48                   	dec    %eax
  802dee:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802df3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802dfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e00:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802e07:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e0b:	75 17                	jne    802e24 <insert_sorted_with_merge_freeList+0x183>
  802e0d:	83 ec 04             	sub    $0x4,%esp
  802e10:	68 2c 3f 80 00       	push   $0x803f2c
  802e15:	68 3f 01 00 00       	push   $0x13f
  802e1a:	68 4f 3f 80 00       	push   $0x803f4f
  802e1f:	e8 c9 05 00 00       	call   8033ed <_panic>
  802e24:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e2d:	89 10                	mov    %edx,(%eax)
  802e2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e32:	8b 00                	mov    (%eax),%eax
  802e34:	85 c0                	test   %eax,%eax
  802e36:	74 0d                	je     802e45 <insert_sorted_with_merge_freeList+0x1a4>
  802e38:	a1 48 51 80 00       	mov    0x805148,%eax
  802e3d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e40:	89 50 04             	mov    %edx,0x4(%eax)
  802e43:	eb 08                	jmp    802e4d <insert_sorted_with_merge_freeList+0x1ac>
  802e45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e48:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e50:	a3 48 51 80 00       	mov    %eax,0x805148
  802e55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e58:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e5f:	a1 54 51 80 00       	mov    0x805154,%eax
  802e64:	40                   	inc    %eax
  802e65:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e6a:	e9 7a 05 00 00       	jmp    8033e9 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e72:	8b 50 08             	mov    0x8(%eax),%edx
  802e75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e78:	8b 40 08             	mov    0x8(%eax),%eax
  802e7b:	39 c2                	cmp    %eax,%edx
  802e7d:	0f 82 14 01 00 00    	jb     802f97 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802e83:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e86:	8b 50 08             	mov    0x8(%eax),%edx
  802e89:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e8c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e8f:	01 c2                	add    %eax,%edx
  802e91:	8b 45 08             	mov    0x8(%ebp),%eax
  802e94:	8b 40 08             	mov    0x8(%eax),%eax
  802e97:	39 c2                	cmp    %eax,%edx
  802e99:	0f 85 90 00 00 00    	jne    802f2f <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802e9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ea2:	8b 50 0c             	mov    0xc(%eax),%edx
  802ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea8:	8b 40 0c             	mov    0xc(%eax),%eax
  802eab:	01 c2                	add    %eax,%edx
  802ead:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eb0:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802ec7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ecb:	75 17                	jne    802ee4 <insert_sorted_with_merge_freeList+0x243>
  802ecd:	83 ec 04             	sub    $0x4,%esp
  802ed0:	68 2c 3f 80 00       	push   $0x803f2c
  802ed5:	68 49 01 00 00       	push   $0x149
  802eda:	68 4f 3f 80 00       	push   $0x803f4f
  802edf:	e8 09 05 00 00       	call   8033ed <_panic>
  802ee4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802eea:	8b 45 08             	mov    0x8(%ebp),%eax
  802eed:	89 10                	mov    %edx,(%eax)
  802eef:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef2:	8b 00                	mov    (%eax),%eax
  802ef4:	85 c0                	test   %eax,%eax
  802ef6:	74 0d                	je     802f05 <insert_sorted_with_merge_freeList+0x264>
  802ef8:	a1 48 51 80 00       	mov    0x805148,%eax
  802efd:	8b 55 08             	mov    0x8(%ebp),%edx
  802f00:	89 50 04             	mov    %edx,0x4(%eax)
  802f03:	eb 08                	jmp    802f0d <insert_sorted_with_merge_freeList+0x26c>
  802f05:	8b 45 08             	mov    0x8(%ebp),%eax
  802f08:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f10:	a3 48 51 80 00       	mov    %eax,0x805148
  802f15:	8b 45 08             	mov    0x8(%ebp),%eax
  802f18:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f1f:	a1 54 51 80 00       	mov    0x805154,%eax
  802f24:	40                   	inc    %eax
  802f25:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f2a:	e9 bb 04 00 00       	jmp    8033ea <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802f2f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f33:	75 17                	jne    802f4c <insert_sorted_with_merge_freeList+0x2ab>
  802f35:	83 ec 04             	sub    $0x4,%esp
  802f38:	68 a0 3f 80 00       	push   $0x803fa0
  802f3d:	68 4c 01 00 00       	push   $0x14c
  802f42:	68 4f 3f 80 00       	push   $0x803f4f
  802f47:	e8 a1 04 00 00       	call   8033ed <_panic>
  802f4c:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802f52:	8b 45 08             	mov    0x8(%ebp),%eax
  802f55:	89 50 04             	mov    %edx,0x4(%eax)
  802f58:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5b:	8b 40 04             	mov    0x4(%eax),%eax
  802f5e:	85 c0                	test   %eax,%eax
  802f60:	74 0c                	je     802f6e <insert_sorted_with_merge_freeList+0x2cd>
  802f62:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f67:	8b 55 08             	mov    0x8(%ebp),%edx
  802f6a:	89 10                	mov    %edx,(%eax)
  802f6c:	eb 08                	jmp    802f76 <insert_sorted_with_merge_freeList+0x2d5>
  802f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f71:	a3 38 51 80 00       	mov    %eax,0x805138
  802f76:	8b 45 08             	mov    0x8(%ebp),%eax
  802f79:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f81:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f87:	a1 44 51 80 00       	mov    0x805144,%eax
  802f8c:	40                   	inc    %eax
  802f8d:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f92:	e9 53 04 00 00       	jmp    8033ea <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802f97:	a1 38 51 80 00       	mov    0x805138,%eax
  802f9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f9f:	e9 15 04 00 00       	jmp    8033b9 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802fa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa7:	8b 00                	mov    (%eax),%eax
  802fa9:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802fac:	8b 45 08             	mov    0x8(%ebp),%eax
  802faf:	8b 50 08             	mov    0x8(%eax),%edx
  802fb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb5:	8b 40 08             	mov    0x8(%eax),%eax
  802fb8:	39 c2                	cmp    %eax,%edx
  802fba:	0f 86 f1 03 00 00    	jbe    8033b1 <insert_sorted_with_merge_freeList+0x710>
  802fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc3:	8b 50 08             	mov    0x8(%eax),%edx
  802fc6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc9:	8b 40 08             	mov    0x8(%eax),%eax
  802fcc:	39 c2                	cmp    %eax,%edx
  802fce:	0f 83 dd 03 00 00    	jae    8033b1 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802fd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd7:	8b 50 08             	mov    0x8(%eax),%edx
  802fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fdd:	8b 40 0c             	mov    0xc(%eax),%eax
  802fe0:	01 c2                	add    %eax,%edx
  802fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe5:	8b 40 08             	mov    0x8(%eax),%eax
  802fe8:	39 c2                	cmp    %eax,%edx
  802fea:	0f 85 b9 01 00 00    	jne    8031a9 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff3:	8b 50 08             	mov    0x8(%eax),%edx
  802ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff9:	8b 40 0c             	mov    0xc(%eax),%eax
  802ffc:	01 c2                	add    %eax,%edx
  802ffe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803001:	8b 40 08             	mov    0x8(%eax),%eax
  803004:	39 c2                	cmp    %eax,%edx
  803006:	0f 85 0d 01 00 00    	jne    803119 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  80300c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300f:	8b 50 0c             	mov    0xc(%eax),%edx
  803012:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803015:	8b 40 0c             	mov    0xc(%eax),%eax
  803018:	01 c2                	add    %eax,%edx
  80301a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301d:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803020:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803024:	75 17                	jne    80303d <insert_sorted_with_merge_freeList+0x39c>
  803026:	83 ec 04             	sub    $0x4,%esp
  803029:	68 f8 3f 80 00       	push   $0x803ff8
  80302e:	68 5c 01 00 00       	push   $0x15c
  803033:	68 4f 3f 80 00       	push   $0x803f4f
  803038:	e8 b0 03 00 00       	call   8033ed <_panic>
  80303d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803040:	8b 00                	mov    (%eax),%eax
  803042:	85 c0                	test   %eax,%eax
  803044:	74 10                	je     803056 <insert_sorted_with_merge_freeList+0x3b5>
  803046:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803049:	8b 00                	mov    (%eax),%eax
  80304b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80304e:	8b 52 04             	mov    0x4(%edx),%edx
  803051:	89 50 04             	mov    %edx,0x4(%eax)
  803054:	eb 0b                	jmp    803061 <insert_sorted_with_merge_freeList+0x3c0>
  803056:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803059:	8b 40 04             	mov    0x4(%eax),%eax
  80305c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803061:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803064:	8b 40 04             	mov    0x4(%eax),%eax
  803067:	85 c0                	test   %eax,%eax
  803069:	74 0f                	je     80307a <insert_sorted_with_merge_freeList+0x3d9>
  80306b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80306e:	8b 40 04             	mov    0x4(%eax),%eax
  803071:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803074:	8b 12                	mov    (%edx),%edx
  803076:	89 10                	mov    %edx,(%eax)
  803078:	eb 0a                	jmp    803084 <insert_sorted_with_merge_freeList+0x3e3>
  80307a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80307d:	8b 00                	mov    (%eax),%eax
  80307f:	a3 38 51 80 00       	mov    %eax,0x805138
  803084:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803087:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80308d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803090:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803097:	a1 44 51 80 00       	mov    0x805144,%eax
  80309c:	48                   	dec    %eax
  80309d:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8030a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8030ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030af:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8030b6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030ba:	75 17                	jne    8030d3 <insert_sorted_with_merge_freeList+0x432>
  8030bc:	83 ec 04             	sub    $0x4,%esp
  8030bf:	68 2c 3f 80 00       	push   $0x803f2c
  8030c4:	68 5f 01 00 00       	push   $0x15f
  8030c9:	68 4f 3f 80 00       	push   $0x803f4f
  8030ce:	e8 1a 03 00 00       	call   8033ed <_panic>
  8030d3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030dc:	89 10                	mov    %edx,(%eax)
  8030de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e1:	8b 00                	mov    (%eax),%eax
  8030e3:	85 c0                	test   %eax,%eax
  8030e5:	74 0d                	je     8030f4 <insert_sorted_with_merge_freeList+0x453>
  8030e7:	a1 48 51 80 00       	mov    0x805148,%eax
  8030ec:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030ef:	89 50 04             	mov    %edx,0x4(%eax)
  8030f2:	eb 08                	jmp    8030fc <insert_sorted_with_merge_freeList+0x45b>
  8030f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ff:	a3 48 51 80 00       	mov    %eax,0x805148
  803104:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803107:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80310e:	a1 54 51 80 00       	mov    0x805154,%eax
  803113:	40                   	inc    %eax
  803114:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803119:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80311c:	8b 50 0c             	mov    0xc(%eax),%edx
  80311f:	8b 45 08             	mov    0x8(%ebp),%eax
  803122:	8b 40 0c             	mov    0xc(%eax),%eax
  803125:	01 c2                	add    %eax,%edx
  803127:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312a:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80312d:	8b 45 08             	mov    0x8(%ebp),%eax
  803130:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803137:	8b 45 08             	mov    0x8(%ebp),%eax
  80313a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803141:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803145:	75 17                	jne    80315e <insert_sorted_with_merge_freeList+0x4bd>
  803147:	83 ec 04             	sub    $0x4,%esp
  80314a:	68 2c 3f 80 00       	push   $0x803f2c
  80314f:	68 64 01 00 00       	push   $0x164
  803154:	68 4f 3f 80 00       	push   $0x803f4f
  803159:	e8 8f 02 00 00       	call   8033ed <_panic>
  80315e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803164:	8b 45 08             	mov    0x8(%ebp),%eax
  803167:	89 10                	mov    %edx,(%eax)
  803169:	8b 45 08             	mov    0x8(%ebp),%eax
  80316c:	8b 00                	mov    (%eax),%eax
  80316e:	85 c0                	test   %eax,%eax
  803170:	74 0d                	je     80317f <insert_sorted_with_merge_freeList+0x4de>
  803172:	a1 48 51 80 00       	mov    0x805148,%eax
  803177:	8b 55 08             	mov    0x8(%ebp),%edx
  80317a:	89 50 04             	mov    %edx,0x4(%eax)
  80317d:	eb 08                	jmp    803187 <insert_sorted_with_merge_freeList+0x4e6>
  80317f:	8b 45 08             	mov    0x8(%ebp),%eax
  803182:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803187:	8b 45 08             	mov    0x8(%ebp),%eax
  80318a:	a3 48 51 80 00       	mov    %eax,0x805148
  80318f:	8b 45 08             	mov    0x8(%ebp),%eax
  803192:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803199:	a1 54 51 80 00       	mov    0x805154,%eax
  80319e:	40                   	inc    %eax
  80319f:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8031a4:	e9 41 02 00 00       	jmp    8033ea <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8031a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ac:	8b 50 08             	mov    0x8(%eax),%edx
  8031af:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8031b5:	01 c2                	add    %eax,%edx
  8031b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ba:	8b 40 08             	mov    0x8(%eax),%eax
  8031bd:	39 c2                	cmp    %eax,%edx
  8031bf:	0f 85 7c 01 00 00    	jne    803341 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8031c5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031c9:	74 06                	je     8031d1 <insert_sorted_with_merge_freeList+0x530>
  8031cb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031cf:	75 17                	jne    8031e8 <insert_sorted_with_merge_freeList+0x547>
  8031d1:	83 ec 04             	sub    $0x4,%esp
  8031d4:	68 68 3f 80 00       	push   $0x803f68
  8031d9:	68 69 01 00 00       	push   $0x169
  8031de:	68 4f 3f 80 00       	push   $0x803f4f
  8031e3:	e8 05 02 00 00       	call   8033ed <_panic>
  8031e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031eb:	8b 50 04             	mov    0x4(%eax),%edx
  8031ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f1:	89 50 04             	mov    %edx,0x4(%eax)
  8031f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031fa:	89 10                	mov    %edx,(%eax)
  8031fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ff:	8b 40 04             	mov    0x4(%eax),%eax
  803202:	85 c0                	test   %eax,%eax
  803204:	74 0d                	je     803213 <insert_sorted_with_merge_freeList+0x572>
  803206:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803209:	8b 40 04             	mov    0x4(%eax),%eax
  80320c:	8b 55 08             	mov    0x8(%ebp),%edx
  80320f:	89 10                	mov    %edx,(%eax)
  803211:	eb 08                	jmp    80321b <insert_sorted_with_merge_freeList+0x57a>
  803213:	8b 45 08             	mov    0x8(%ebp),%eax
  803216:	a3 38 51 80 00       	mov    %eax,0x805138
  80321b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80321e:	8b 55 08             	mov    0x8(%ebp),%edx
  803221:	89 50 04             	mov    %edx,0x4(%eax)
  803224:	a1 44 51 80 00       	mov    0x805144,%eax
  803229:	40                   	inc    %eax
  80322a:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  80322f:	8b 45 08             	mov    0x8(%ebp),%eax
  803232:	8b 50 0c             	mov    0xc(%eax),%edx
  803235:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803238:	8b 40 0c             	mov    0xc(%eax),%eax
  80323b:	01 c2                	add    %eax,%edx
  80323d:	8b 45 08             	mov    0x8(%ebp),%eax
  803240:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803243:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803247:	75 17                	jne    803260 <insert_sorted_with_merge_freeList+0x5bf>
  803249:	83 ec 04             	sub    $0x4,%esp
  80324c:	68 f8 3f 80 00       	push   $0x803ff8
  803251:	68 6b 01 00 00       	push   $0x16b
  803256:	68 4f 3f 80 00       	push   $0x803f4f
  80325b:	e8 8d 01 00 00       	call   8033ed <_panic>
  803260:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803263:	8b 00                	mov    (%eax),%eax
  803265:	85 c0                	test   %eax,%eax
  803267:	74 10                	je     803279 <insert_sorted_with_merge_freeList+0x5d8>
  803269:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80326c:	8b 00                	mov    (%eax),%eax
  80326e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803271:	8b 52 04             	mov    0x4(%edx),%edx
  803274:	89 50 04             	mov    %edx,0x4(%eax)
  803277:	eb 0b                	jmp    803284 <insert_sorted_with_merge_freeList+0x5e3>
  803279:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80327c:	8b 40 04             	mov    0x4(%eax),%eax
  80327f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803284:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803287:	8b 40 04             	mov    0x4(%eax),%eax
  80328a:	85 c0                	test   %eax,%eax
  80328c:	74 0f                	je     80329d <insert_sorted_with_merge_freeList+0x5fc>
  80328e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803291:	8b 40 04             	mov    0x4(%eax),%eax
  803294:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803297:	8b 12                	mov    (%edx),%edx
  803299:	89 10                	mov    %edx,(%eax)
  80329b:	eb 0a                	jmp    8032a7 <insert_sorted_with_merge_freeList+0x606>
  80329d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a0:	8b 00                	mov    (%eax),%eax
  8032a2:	a3 38 51 80 00       	mov    %eax,0x805138
  8032a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032ba:	a1 44 51 80 00       	mov    0x805144,%eax
  8032bf:	48                   	dec    %eax
  8032c0:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8032c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8032cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8032d9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032dd:	75 17                	jne    8032f6 <insert_sorted_with_merge_freeList+0x655>
  8032df:	83 ec 04             	sub    $0x4,%esp
  8032e2:	68 2c 3f 80 00       	push   $0x803f2c
  8032e7:	68 6e 01 00 00       	push   $0x16e
  8032ec:	68 4f 3f 80 00       	push   $0x803f4f
  8032f1:	e8 f7 00 00 00       	call   8033ed <_panic>
  8032f6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ff:	89 10                	mov    %edx,(%eax)
  803301:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803304:	8b 00                	mov    (%eax),%eax
  803306:	85 c0                	test   %eax,%eax
  803308:	74 0d                	je     803317 <insert_sorted_with_merge_freeList+0x676>
  80330a:	a1 48 51 80 00       	mov    0x805148,%eax
  80330f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803312:	89 50 04             	mov    %edx,0x4(%eax)
  803315:	eb 08                	jmp    80331f <insert_sorted_with_merge_freeList+0x67e>
  803317:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80331a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80331f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803322:	a3 48 51 80 00       	mov    %eax,0x805148
  803327:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80332a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803331:	a1 54 51 80 00       	mov    0x805154,%eax
  803336:	40                   	inc    %eax
  803337:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80333c:	e9 a9 00 00 00       	jmp    8033ea <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803341:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803345:	74 06                	je     80334d <insert_sorted_with_merge_freeList+0x6ac>
  803347:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80334b:	75 17                	jne    803364 <insert_sorted_with_merge_freeList+0x6c3>
  80334d:	83 ec 04             	sub    $0x4,%esp
  803350:	68 c4 3f 80 00       	push   $0x803fc4
  803355:	68 73 01 00 00       	push   $0x173
  80335a:	68 4f 3f 80 00       	push   $0x803f4f
  80335f:	e8 89 00 00 00       	call   8033ed <_panic>
  803364:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803367:	8b 10                	mov    (%eax),%edx
  803369:	8b 45 08             	mov    0x8(%ebp),%eax
  80336c:	89 10                	mov    %edx,(%eax)
  80336e:	8b 45 08             	mov    0x8(%ebp),%eax
  803371:	8b 00                	mov    (%eax),%eax
  803373:	85 c0                	test   %eax,%eax
  803375:	74 0b                	je     803382 <insert_sorted_with_merge_freeList+0x6e1>
  803377:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80337a:	8b 00                	mov    (%eax),%eax
  80337c:	8b 55 08             	mov    0x8(%ebp),%edx
  80337f:	89 50 04             	mov    %edx,0x4(%eax)
  803382:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803385:	8b 55 08             	mov    0x8(%ebp),%edx
  803388:	89 10                	mov    %edx,(%eax)
  80338a:	8b 45 08             	mov    0x8(%ebp),%eax
  80338d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803390:	89 50 04             	mov    %edx,0x4(%eax)
  803393:	8b 45 08             	mov    0x8(%ebp),%eax
  803396:	8b 00                	mov    (%eax),%eax
  803398:	85 c0                	test   %eax,%eax
  80339a:	75 08                	jne    8033a4 <insert_sorted_with_merge_freeList+0x703>
  80339c:	8b 45 08             	mov    0x8(%ebp),%eax
  80339f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033a4:	a1 44 51 80 00       	mov    0x805144,%eax
  8033a9:	40                   	inc    %eax
  8033aa:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8033af:	eb 39                	jmp    8033ea <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8033b1:	a1 40 51 80 00       	mov    0x805140,%eax
  8033b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033bd:	74 07                	je     8033c6 <insert_sorted_with_merge_freeList+0x725>
  8033bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c2:	8b 00                	mov    (%eax),%eax
  8033c4:	eb 05                	jmp    8033cb <insert_sorted_with_merge_freeList+0x72a>
  8033c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8033cb:	a3 40 51 80 00       	mov    %eax,0x805140
  8033d0:	a1 40 51 80 00       	mov    0x805140,%eax
  8033d5:	85 c0                	test   %eax,%eax
  8033d7:	0f 85 c7 fb ff ff    	jne    802fa4 <insert_sorted_with_merge_freeList+0x303>
  8033dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033e1:	0f 85 bd fb ff ff    	jne    802fa4 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8033e7:	eb 01                	jmp    8033ea <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8033e9:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8033ea:	90                   	nop
  8033eb:	c9                   	leave  
  8033ec:	c3                   	ret    

008033ed <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8033ed:	55                   	push   %ebp
  8033ee:	89 e5                	mov    %esp,%ebp
  8033f0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8033f3:	8d 45 10             	lea    0x10(%ebp),%eax
  8033f6:	83 c0 04             	add    $0x4,%eax
  8033f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8033fc:	a1 5c 51 80 00       	mov    0x80515c,%eax
  803401:	85 c0                	test   %eax,%eax
  803403:	74 16                	je     80341b <_panic+0x2e>
		cprintf("%s: ", argv0);
  803405:	a1 5c 51 80 00       	mov    0x80515c,%eax
  80340a:	83 ec 08             	sub    $0x8,%esp
  80340d:	50                   	push   %eax
  80340e:	68 18 40 80 00       	push   $0x804018
  803413:	e8 6b d2 ff ff       	call   800683 <cprintf>
  803418:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80341b:	a1 00 50 80 00       	mov    0x805000,%eax
  803420:	ff 75 0c             	pushl  0xc(%ebp)
  803423:	ff 75 08             	pushl  0x8(%ebp)
  803426:	50                   	push   %eax
  803427:	68 1d 40 80 00       	push   $0x80401d
  80342c:	e8 52 d2 ff ff       	call   800683 <cprintf>
  803431:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803434:	8b 45 10             	mov    0x10(%ebp),%eax
  803437:	83 ec 08             	sub    $0x8,%esp
  80343a:	ff 75 f4             	pushl  -0xc(%ebp)
  80343d:	50                   	push   %eax
  80343e:	e8 d5 d1 ff ff       	call   800618 <vcprintf>
  803443:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803446:	83 ec 08             	sub    $0x8,%esp
  803449:	6a 00                	push   $0x0
  80344b:	68 39 40 80 00       	push   $0x804039
  803450:	e8 c3 d1 ff ff       	call   800618 <vcprintf>
  803455:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803458:	e8 44 d1 ff ff       	call   8005a1 <exit>

	// should not return here
	while (1) ;
  80345d:	eb fe                	jmp    80345d <_panic+0x70>

0080345f <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80345f:	55                   	push   %ebp
  803460:	89 e5                	mov    %esp,%ebp
  803462:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803465:	a1 20 50 80 00       	mov    0x805020,%eax
  80346a:	8b 50 74             	mov    0x74(%eax),%edx
  80346d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803470:	39 c2                	cmp    %eax,%edx
  803472:	74 14                	je     803488 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803474:	83 ec 04             	sub    $0x4,%esp
  803477:	68 3c 40 80 00       	push   $0x80403c
  80347c:	6a 26                	push   $0x26
  80347e:	68 88 40 80 00       	push   $0x804088
  803483:	e8 65 ff ff ff       	call   8033ed <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803488:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80348f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803496:	e9 c2 00 00 00       	jmp    80355d <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80349b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80349e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8034a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a8:	01 d0                	add    %edx,%eax
  8034aa:	8b 00                	mov    (%eax),%eax
  8034ac:	85 c0                	test   %eax,%eax
  8034ae:	75 08                	jne    8034b8 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8034b0:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8034b3:	e9 a2 00 00 00       	jmp    80355a <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8034b8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8034bf:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8034c6:	eb 69                	jmp    803531 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8034c8:	a1 20 50 80 00       	mov    0x805020,%eax
  8034cd:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8034d3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034d6:	89 d0                	mov    %edx,%eax
  8034d8:	01 c0                	add    %eax,%eax
  8034da:	01 d0                	add    %edx,%eax
  8034dc:	c1 e0 03             	shl    $0x3,%eax
  8034df:	01 c8                	add    %ecx,%eax
  8034e1:	8a 40 04             	mov    0x4(%eax),%al
  8034e4:	84 c0                	test   %al,%al
  8034e6:	75 46                	jne    80352e <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8034e8:	a1 20 50 80 00       	mov    0x805020,%eax
  8034ed:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8034f3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034f6:	89 d0                	mov    %edx,%eax
  8034f8:	01 c0                	add    %eax,%eax
  8034fa:	01 d0                	add    %edx,%eax
  8034fc:	c1 e0 03             	shl    $0x3,%eax
  8034ff:	01 c8                	add    %ecx,%eax
  803501:	8b 00                	mov    (%eax),%eax
  803503:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803506:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803509:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80350e:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803510:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803513:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80351a:	8b 45 08             	mov    0x8(%ebp),%eax
  80351d:	01 c8                	add    %ecx,%eax
  80351f:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803521:	39 c2                	cmp    %eax,%edx
  803523:	75 09                	jne    80352e <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  803525:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80352c:	eb 12                	jmp    803540 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80352e:	ff 45 e8             	incl   -0x18(%ebp)
  803531:	a1 20 50 80 00       	mov    0x805020,%eax
  803536:	8b 50 74             	mov    0x74(%eax),%edx
  803539:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80353c:	39 c2                	cmp    %eax,%edx
  80353e:	77 88                	ja     8034c8 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803540:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803544:	75 14                	jne    80355a <CheckWSWithoutLastIndex+0xfb>
			panic(
  803546:	83 ec 04             	sub    $0x4,%esp
  803549:	68 94 40 80 00       	push   $0x804094
  80354e:	6a 3a                	push   $0x3a
  803550:	68 88 40 80 00       	push   $0x804088
  803555:	e8 93 fe ff ff       	call   8033ed <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80355a:	ff 45 f0             	incl   -0x10(%ebp)
  80355d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803560:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803563:	0f 8c 32 ff ff ff    	jl     80349b <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803569:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803570:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803577:	eb 26                	jmp    80359f <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803579:	a1 20 50 80 00       	mov    0x805020,%eax
  80357e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803584:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803587:	89 d0                	mov    %edx,%eax
  803589:	01 c0                	add    %eax,%eax
  80358b:	01 d0                	add    %edx,%eax
  80358d:	c1 e0 03             	shl    $0x3,%eax
  803590:	01 c8                	add    %ecx,%eax
  803592:	8a 40 04             	mov    0x4(%eax),%al
  803595:	3c 01                	cmp    $0x1,%al
  803597:	75 03                	jne    80359c <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  803599:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80359c:	ff 45 e0             	incl   -0x20(%ebp)
  80359f:	a1 20 50 80 00       	mov    0x805020,%eax
  8035a4:	8b 50 74             	mov    0x74(%eax),%edx
  8035a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035aa:	39 c2                	cmp    %eax,%edx
  8035ac:	77 cb                	ja     803579 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8035ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b1:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8035b4:	74 14                	je     8035ca <CheckWSWithoutLastIndex+0x16b>
		panic(
  8035b6:	83 ec 04             	sub    $0x4,%esp
  8035b9:	68 e8 40 80 00       	push   $0x8040e8
  8035be:	6a 44                	push   $0x44
  8035c0:	68 88 40 80 00       	push   $0x804088
  8035c5:	e8 23 fe ff ff       	call   8033ed <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8035ca:	90                   	nop
  8035cb:	c9                   	leave  
  8035cc:	c3                   	ret    
  8035cd:	66 90                	xchg   %ax,%ax
  8035cf:	90                   	nop

008035d0 <__udivdi3>:
  8035d0:	55                   	push   %ebp
  8035d1:	57                   	push   %edi
  8035d2:	56                   	push   %esi
  8035d3:	53                   	push   %ebx
  8035d4:	83 ec 1c             	sub    $0x1c,%esp
  8035d7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8035db:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8035df:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8035e3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8035e7:	89 ca                	mov    %ecx,%edx
  8035e9:	89 f8                	mov    %edi,%eax
  8035eb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8035ef:	85 f6                	test   %esi,%esi
  8035f1:	75 2d                	jne    803620 <__udivdi3+0x50>
  8035f3:	39 cf                	cmp    %ecx,%edi
  8035f5:	77 65                	ja     80365c <__udivdi3+0x8c>
  8035f7:	89 fd                	mov    %edi,%ebp
  8035f9:	85 ff                	test   %edi,%edi
  8035fb:	75 0b                	jne    803608 <__udivdi3+0x38>
  8035fd:	b8 01 00 00 00       	mov    $0x1,%eax
  803602:	31 d2                	xor    %edx,%edx
  803604:	f7 f7                	div    %edi
  803606:	89 c5                	mov    %eax,%ebp
  803608:	31 d2                	xor    %edx,%edx
  80360a:	89 c8                	mov    %ecx,%eax
  80360c:	f7 f5                	div    %ebp
  80360e:	89 c1                	mov    %eax,%ecx
  803610:	89 d8                	mov    %ebx,%eax
  803612:	f7 f5                	div    %ebp
  803614:	89 cf                	mov    %ecx,%edi
  803616:	89 fa                	mov    %edi,%edx
  803618:	83 c4 1c             	add    $0x1c,%esp
  80361b:	5b                   	pop    %ebx
  80361c:	5e                   	pop    %esi
  80361d:	5f                   	pop    %edi
  80361e:	5d                   	pop    %ebp
  80361f:	c3                   	ret    
  803620:	39 ce                	cmp    %ecx,%esi
  803622:	77 28                	ja     80364c <__udivdi3+0x7c>
  803624:	0f bd fe             	bsr    %esi,%edi
  803627:	83 f7 1f             	xor    $0x1f,%edi
  80362a:	75 40                	jne    80366c <__udivdi3+0x9c>
  80362c:	39 ce                	cmp    %ecx,%esi
  80362e:	72 0a                	jb     80363a <__udivdi3+0x6a>
  803630:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803634:	0f 87 9e 00 00 00    	ja     8036d8 <__udivdi3+0x108>
  80363a:	b8 01 00 00 00       	mov    $0x1,%eax
  80363f:	89 fa                	mov    %edi,%edx
  803641:	83 c4 1c             	add    $0x1c,%esp
  803644:	5b                   	pop    %ebx
  803645:	5e                   	pop    %esi
  803646:	5f                   	pop    %edi
  803647:	5d                   	pop    %ebp
  803648:	c3                   	ret    
  803649:	8d 76 00             	lea    0x0(%esi),%esi
  80364c:	31 ff                	xor    %edi,%edi
  80364e:	31 c0                	xor    %eax,%eax
  803650:	89 fa                	mov    %edi,%edx
  803652:	83 c4 1c             	add    $0x1c,%esp
  803655:	5b                   	pop    %ebx
  803656:	5e                   	pop    %esi
  803657:	5f                   	pop    %edi
  803658:	5d                   	pop    %ebp
  803659:	c3                   	ret    
  80365a:	66 90                	xchg   %ax,%ax
  80365c:	89 d8                	mov    %ebx,%eax
  80365e:	f7 f7                	div    %edi
  803660:	31 ff                	xor    %edi,%edi
  803662:	89 fa                	mov    %edi,%edx
  803664:	83 c4 1c             	add    $0x1c,%esp
  803667:	5b                   	pop    %ebx
  803668:	5e                   	pop    %esi
  803669:	5f                   	pop    %edi
  80366a:	5d                   	pop    %ebp
  80366b:	c3                   	ret    
  80366c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803671:	89 eb                	mov    %ebp,%ebx
  803673:	29 fb                	sub    %edi,%ebx
  803675:	89 f9                	mov    %edi,%ecx
  803677:	d3 e6                	shl    %cl,%esi
  803679:	89 c5                	mov    %eax,%ebp
  80367b:	88 d9                	mov    %bl,%cl
  80367d:	d3 ed                	shr    %cl,%ebp
  80367f:	89 e9                	mov    %ebp,%ecx
  803681:	09 f1                	or     %esi,%ecx
  803683:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803687:	89 f9                	mov    %edi,%ecx
  803689:	d3 e0                	shl    %cl,%eax
  80368b:	89 c5                	mov    %eax,%ebp
  80368d:	89 d6                	mov    %edx,%esi
  80368f:	88 d9                	mov    %bl,%cl
  803691:	d3 ee                	shr    %cl,%esi
  803693:	89 f9                	mov    %edi,%ecx
  803695:	d3 e2                	shl    %cl,%edx
  803697:	8b 44 24 08          	mov    0x8(%esp),%eax
  80369b:	88 d9                	mov    %bl,%cl
  80369d:	d3 e8                	shr    %cl,%eax
  80369f:	09 c2                	or     %eax,%edx
  8036a1:	89 d0                	mov    %edx,%eax
  8036a3:	89 f2                	mov    %esi,%edx
  8036a5:	f7 74 24 0c          	divl   0xc(%esp)
  8036a9:	89 d6                	mov    %edx,%esi
  8036ab:	89 c3                	mov    %eax,%ebx
  8036ad:	f7 e5                	mul    %ebp
  8036af:	39 d6                	cmp    %edx,%esi
  8036b1:	72 19                	jb     8036cc <__udivdi3+0xfc>
  8036b3:	74 0b                	je     8036c0 <__udivdi3+0xf0>
  8036b5:	89 d8                	mov    %ebx,%eax
  8036b7:	31 ff                	xor    %edi,%edi
  8036b9:	e9 58 ff ff ff       	jmp    803616 <__udivdi3+0x46>
  8036be:	66 90                	xchg   %ax,%ax
  8036c0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8036c4:	89 f9                	mov    %edi,%ecx
  8036c6:	d3 e2                	shl    %cl,%edx
  8036c8:	39 c2                	cmp    %eax,%edx
  8036ca:	73 e9                	jae    8036b5 <__udivdi3+0xe5>
  8036cc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8036cf:	31 ff                	xor    %edi,%edi
  8036d1:	e9 40 ff ff ff       	jmp    803616 <__udivdi3+0x46>
  8036d6:	66 90                	xchg   %ax,%ax
  8036d8:	31 c0                	xor    %eax,%eax
  8036da:	e9 37 ff ff ff       	jmp    803616 <__udivdi3+0x46>
  8036df:	90                   	nop

008036e0 <__umoddi3>:
  8036e0:	55                   	push   %ebp
  8036e1:	57                   	push   %edi
  8036e2:	56                   	push   %esi
  8036e3:	53                   	push   %ebx
  8036e4:	83 ec 1c             	sub    $0x1c,%esp
  8036e7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8036eb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8036ef:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8036f3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8036f7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8036fb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8036ff:	89 f3                	mov    %esi,%ebx
  803701:	89 fa                	mov    %edi,%edx
  803703:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803707:	89 34 24             	mov    %esi,(%esp)
  80370a:	85 c0                	test   %eax,%eax
  80370c:	75 1a                	jne    803728 <__umoddi3+0x48>
  80370e:	39 f7                	cmp    %esi,%edi
  803710:	0f 86 a2 00 00 00    	jbe    8037b8 <__umoddi3+0xd8>
  803716:	89 c8                	mov    %ecx,%eax
  803718:	89 f2                	mov    %esi,%edx
  80371a:	f7 f7                	div    %edi
  80371c:	89 d0                	mov    %edx,%eax
  80371e:	31 d2                	xor    %edx,%edx
  803720:	83 c4 1c             	add    $0x1c,%esp
  803723:	5b                   	pop    %ebx
  803724:	5e                   	pop    %esi
  803725:	5f                   	pop    %edi
  803726:	5d                   	pop    %ebp
  803727:	c3                   	ret    
  803728:	39 f0                	cmp    %esi,%eax
  80372a:	0f 87 ac 00 00 00    	ja     8037dc <__umoddi3+0xfc>
  803730:	0f bd e8             	bsr    %eax,%ebp
  803733:	83 f5 1f             	xor    $0x1f,%ebp
  803736:	0f 84 ac 00 00 00    	je     8037e8 <__umoddi3+0x108>
  80373c:	bf 20 00 00 00       	mov    $0x20,%edi
  803741:	29 ef                	sub    %ebp,%edi
  803743:	89 fe                	mov    %edi,%esi
  803745:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803749:	89 e9                	mov    %ebp,%ecx
  80374b:	d3 e0                	shl    %cl,%eax
  80374d:	89 d7                	mov    %edx,%edi
  80374f:	89 f1                	mov    %esi,%ecx
  803751:	d3 ef                	shr    %cl,%edi
  803753:	09 c7                	or     %eax,%edi
  803755:	89 e9                	mov    %ebp,%ecx
  803757:	d3 e2                	shl    %cl,%edx
  803759:	89 14 24             	mov    %edx,(%esp)
  80375c:	89 d8                	mov    %ebx,%eax
  80375e:	d3 e0                	shl    %cl,%eax
  803760:	89 c2                	mov    %eax,%edx
  803762:	8b 44 24 08          	mov    0x8(%esp),%eax
  803766:	d3 e0                	shl    %cl,%eax
  803768:	89 44 24 04          	mov    %eax,0x4(%esp)
  80376c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803770:	89 f1                	mov    %esi,%ecx
  803772:	d3 e8                	shr    %cl,%eax
  803774:	09 d0                	or     %edx,%eax
  803776:	d3 eb                	shr    %cl,%ebx
  803778:	89 da                	mov    %ebx,%edx
  80377a:	f7 f7                	div    %edi
  80377c:	89 d3                	mov    %edx,%ebx
  80377e:	f7 24 24             	mull   (%esp)
  803781:	89 c6                	mov    %eax,%esi
  803783:	89 d1                	mov    %edx,%ecx
  803785:	39 d3                	cmp    %edx,%ebx
  803787:	0f 82 87 00 00 00    	jb     803814 <__umoddi3+0x134>
  80378d:	0f 84 91 00 00 00    	je     803824 <__umoddi3+0x144>
  803793:	8b 54 24 04          	mov    0x4(%esp),%edx
  803797:	29 f2                	sub    %esi,%edx
  803799:	19 cb                	sbb    %ecx,%ebx
  80379b:	89 d8                	mov    %ebx,%eax
  80379d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8037a1:	d3 e0                	shl    %cl,%eax
  8037a3:	89 e9                	mov    %ebp,%ecx
  8037a5:	d3 ea                	shr    %cl,%edx
  8037a7:	09 d0                	or     %edx,%eax
  8037a9:	89 e9                	mov    %ebp,%ecx
  8037ab:	d3 eb                	shr    %cl,%ebx
  8037ad:	89 da                	mov    %ebx,%edx
  8037af:	83 c4 1c             	add    $0x1c,%esp
  8037b2:	5b                   	pop    %ebx
  8037b3:	5e                   	pop    %esi
  8037b4:	5f                   	pop    %edi
  8037b5:	5d                   	pop    %ebp
  8037b6:	c3                   	ret    
  8037b7:	90                   	nop
  8037b8:	89 fd                	mov    %edi,%ebp
  8037ba:	85 ff                	test   %edi,%edi
  8037bc:	75 0b                	jne    8037c9 <__umoddi3+0xe9>
  8037be:	b8 01 00 00 00       	mov    $0x1,%eax
  8037c3:	31 d2                	xor    %edx,%edx
  8037c5:	f7 f7                	div    %edi
  8037c7:	89 c5                	mov    %eax,%ebp
  8037c9:	89 f0                	mov    %esi,%eax
  8037cb:	31 d2                	xor    %edx,%edx
  8037cd:	f7 f5                	div    %ebp
  8037cf:	89 c8                	mov    %ecx,%eax
  8037d1:	f7 f5                	div    %ebp
  8037d3:	89 d0                	mov    %edx,%eax
  8037d5:	e9 44 ff ff ff       	jmp    80371e <__umoddi3+0x3e>
  8037da:	66 90                	xchg   %ax,%ax
  8037dc:	89 c8                	mov    %ecx,%eax
  8037de:	89 f2                	mov    %esi,%edx
  8037e0:	83 c4 1c             	add    $0x1c,%esp
  8037e3:	5b                   	pop    %ebx
  8037e4:	5e                   	pop    %esi
  8037e5:	5f                   	pop    %edi
  8037e6:	5d                   	pop    %ebp
  8037e7:	c3                   	ret    
  8037e8:	3b 04 24             	cmp    (%esp),%eax
  8037eb:	72 06                	jb     8037f3 <__umoddi3+0x113>
  8037ed:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8037f1:	77 0f                	ja     803802 <__umoddi3+0x122>
  8037f3:	89 f2                	mov    %esi,%edx
  8037f5:	29 f9                	sub    %edi,%ecx
  8037f7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8037fb:	89 14 24             	mov    %edx,(%esp)
  8037fe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803802:	8b 44 24 04          	mov    0x4(%esp),%eax
  803806:	8b 14 24             	mov    (%esp),%edx
  803809:	83 c4 1c             	add    $0x1c,%esp
  80380c:	5b                   	pop    %ebx
  80380d:	5e                   	pop    %esi
  80380e:	5f                   	pop    %edi
  80380f:	5d                   	pop    %ebp
  803810:	c3                   	ret    
  803811:	8d 76 00             	lea    0x0(%esi),%esi
  803814:	2b 04 24             	sub    (%esp),%eax
  803817:	19 fa                	sbb    %edi,%edx
  803819:	89 d1                	mov    %edx,%ecx
  80381b:	89 c6                	mov    %eax,%esi
  80381d:	e9 71 ff ff ff       	jmp    803793 <__umoddi3+0xb3>
  803822:	66 90                	xchg   %ax,%ax
  803824:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803828:	72 ea                	jb     803814 <__umoddi3+0x134>
  80382a:	89 d9                	mov    %ebx,%ecx
  80382c:	e9 62 ff ff ff       	jmp    803793 <__umoddi3+0xb3>
