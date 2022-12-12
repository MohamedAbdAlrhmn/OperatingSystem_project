
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
  80003e:	e8 49 1b 00 00       	call   801b8c <sys_getparentenvid>
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
  800057:	68 a0 38 80 00       	push   $0x8038a0
  80005c:	ff 75 f0             	pushl  -0x10(%ebp)
  80005f:	e8 8b 16 00 00       	call   8016ef <sget>
  800064:	83 c4 10             	add    $0x10,%esp
  800067:	89 45 e8             	mov    %eax,-0x18(%ebp)
	numOfElements = sget(parentenvID, "arrSize") ;
  80006a:	83 ec 08             	sub    $0x8,%esp
  80006d:	68 a4 38 80 00       	push   $0x8038a4
  800072:	ff 75 f0             	pushl  -0x10(%ebp)
  800075:	e8 75 16 00 00       	call   8016ef <sget>
  80007a:	83 c4 10             	add    $0x10,%esp
  80007d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//PrintElements(sharedArray, *numOfElements);

	//Get the check-finishing counter
	int *finishedCount = NULL;
  800080:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	finishedCount = sget(parentenvID, "finishedCount") ;
  800087:	83 ec 08             	sub    $0x8,%esp
  80008a:	68 ac 38 80 00       	push   $0x8038ac
  80008f:	ff 75 f0             	pushl  -0x10(%ebp)
  800092:	e8 58 16 00 00       	call   8016ef <sget>
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
  8000ab:	68 ba 38 80 00       	push   $0x8038ba
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
  80010c:	68 c9 38 80 00       	push   $0x8038c9
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
  8001a2:	68 e5 38 80 00       	push   $0x8038e5
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
  8001c4:	68 e7 38 80 00       	push   $0x8038e7
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
  8001f2:	68 ec 38 80 00       	push   $0x8038ec
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
  800479:	e8 f5 16 00 00       	call   801b73 <sys_getenvindex>
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
  8004e4:	e8 97 14 00 00       	call   801980 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8004e9:	83 ec 0c             	sub    $0xc,%esp
  8004ec:	68 08 39 80 00       	push   $0x803908
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
  800514:	68 30 39 80 00       	push   $0x803930
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
  800545:	68 58 39 80 00       	push   $0x803958
  80054a:	e8 34 01 00 00       	call   800683 <cprintf>
  80054f:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800552:	a1 20 50 80 00       	mov    0x805020,%eax
  800557:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80055d:	83 ec 08             	sub    $0x8,%esp
  800560:	50                   	push   %eax
  800561:	68 b0 39 80 00       	push   $0x8039b0
  800566:	e8 18 01 00 00       	call   800683 <cprintf>
  80056b:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80056e:	83 ec 0c             	sub    $0xc,%esp
  800571:	68 08 39 80 00       	push   $0x803908
  800576:	e8 08 01 00 00       	call   800683 <cprintf>
  80057b:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80057e:	e8 17 14 00 00       	call   80199a <sys_enable_interrupt>

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
  800596:	e8 a4 15 00 00       	call   801b3f <sys_destroy_env>
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
  8005a7:	e8 f9 15 00 00       	call   801ba5 <sys_exit_env>
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
  8005f5:	e8 d8 11 00 00       	call   8017d2 <sys_cputs>
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
  80066c:	e8 61 11 00 00       	call   8017d2 <sys_cputs>
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
  8006b6:	e8 c5 12 00 00       	call   801980 <sys_disable_interrupt>
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
  8006d6:	e8 bf 12 00 00       	call   80199a <sys_enable_interrupt>
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
  800720:	e8 13 2f 00 00       	call   803638 <__udivdi3>
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
  800770:	e8 d3 2f 00 00       	call   803748 <__umoddi3>
  800775:	83 c4 10             	add    $0x10,%esp
  800778:	05 f4 3b 80 00       	add    $0x803bf4,%eax
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
  8008cb:	8b 04 85 18 3c 80 00 	mov    0x803c18(,%eax,4),%eax
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
  8009ac:	8b 34 9d 60 3a 80 00 	mov    0x803a60(,%ebx,4),%esi
  8009b3:	85 f6                	test   %esi,%esi
  8009b5:	75 19                	jne    8009d0 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009b7:	53                   	push   %ebx
  8009b8:	68 05 3c 80 00       	push   $0x803c05
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
  8009d1:	68 0e 3c 80 00       	push   $0x803c0e
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
  8009fe:	be 11 3c 80 00       	mov    $0x803c11,%esi
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
  801424:	68 70 3d 80 00       	push   $0x803d70
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
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  8014d7:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8014de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014e1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014e6:	2d 00 10 00 00       	sub    $0x1000,%eax
  8014eb:	83 ec 04             	sub    $0x4,%esp
  8014ee:	6a 06                	push   $0x6
  8014f0:	ff 75 f4             	pushl  -0xc(%ebp)
  8014f3:	50                   	push   %eax
  8014f4:	e8 1d 04 00 00       	call   801916 <sys_allocate_chunk>
  8014f9:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8014fc:	a1 20 51 80 00       	mov    0x805120,%eax
  801501:	83 ec 0c             	sub    $0xc,%esp
  801504:	50                   	push   %eax
  801505:	e8 92 0a 00 00       	call   801f9c <initialize_MemBlocksList>
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
  801532:	68 95 3d 80 00       	push   $0x803d95
  801537:	6a 33                	push   $0x33
  801539:	68 b3 3d 80 00       	push   $0x803db3
  80153e:	e8 12 1f 00 00       	call   803455 <_panic>
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
  8015b1:	68 c0 3d 80 00       	push   $0x803dc0
  8015b6:	6a 34                	push   $0x34
  8015b8:	68 b3 3d 80 00       	push   $0x803db3
  8015bd:	e8 93 1e 00 00       	call   803455 <_panic>
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
  801626:	68 e4 3d 80 00       	push   $0x803de4
  80162b:	6a 46                	push   $0x46
  80162d:	68 b3 3d 80 00       	push   $0x803db3
  801632:	e8 1e 1e 00 00       	call   803455 <_panic>
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
  801642:	68 0c 3e 80 00       	push   $0x803e0c
  801647:	6a 61                	push   $0x61
  801649:	68 b3 3d 80 00       	push   $0x803db3
  80164e:	e8 02 1e 00 00       	call   803455 <_panic>

00801653 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801653:	55                   	push   %ebp
  801654:	89 e5                	mov    %esp,%ebp
  801656:	83 ec 38             	sub    $0x38,%esp
  801659:	8b 45 10             	mov    0x10(%ebp),%eax
  80165c:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80165f:	e8 a9 fd ff ff       	call   80140d <InitializeUHeap>
	if (size == 0) return NULL ;
  801664:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801668:	75 07                	jne    801671 <smalloc+0x1e>
  80166a:	b8 00 00 00 00       	mov    $0x0,%eax
  80166f:	eb 7c                	jmp    8016ed <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801671:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801678:	8b 55 0c             	mov    0xc(%ebp),%edx
  80167b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80167e:	01 d0                	add    %edx,%eax
  801680:	48                   	dec    %eax
  801681:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801684:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801687:	ba 00 00 00 00       	mov    $0x0,%edx
  80168c:	f7 75 f0             	divl   -0x10(%ebp)
  80168f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801692:	29 d0                	sub    %edx,%eax
  801694:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801697:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80169e:	e8 41 06 00 00       	call   801ce4 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016a3:	85 c0                	test   %eax,%eax
  8016a5:	74 11                	je     8016b8 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  8016a7:	83 ec 0c             	sub    $0xc,%esp
  8016aa:	ff 75 e8             	pushl  -0x18(%ebp)
  8016ad:	e8 ac 0c 00 00       	call   80235e <alloc_block_FF>
  8016b2:	83 c4 10             	add    $0x10,%esp
  8016b5:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  8016b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016bc:	74 2a                	je     8016e8 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8016be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c1:	8b 40 08             	mov    0x8(%eax),%eax
  8016c4:	89 c2                	mov    %eax,%edx
  8016c6:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8016ca:	52                   	push   %edx
  8016cb:	50                   	push   %eax
  8016cc:	ff 75 0c             	pushl  0xc(%ebp)
  8016cf:	ff 75 08             	pushl  0x8(%ebp)
  8016d2:	e8 92 03 00 00       	call   801a69 <sys_createSharedObject>
  8016d7:	83 c4 10             	add    $0x10,%esp
  8016da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  8016dd:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  8016e1:	74 05                	je     8016e8 <smalloc+0x95>
			return (void*)virtual_address;
  8016e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016e6:	eb 05                	jmp    8016ed <smalloc+0x9a>
	}
	return NULL;
  8016e8:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8016ed:	c9                   	leave  
  8016ee:	c3                   	ret    

008016ef <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016ef:	55                   	push   %ebp
  8016f0:	89 e5                	mov    %esp,%ebp
  8016f2:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016f5:	e8 13 fd ff ff       	call   80140d <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8016fa:	83 ec 04             	sub    $0x4,%esp
  8016fd:	68 30 3e 80 00       	push   $0x803e30
  801702:	68 a2 00 00 00       	push   $0xa2
  801707:	68 b3 3d 80 00       	push   $0x803db3
  80170c:	e8 44 1d 00 00       	call   803455 <_panic>

00801711 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801711:	55                   	push   %ebp
  801712:	89 e5                	mov    %esp,%ebp
  801714:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801717:	e8 f1 fc ff ff       	call   80140d <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80171c:	83 ec 04             	sub    $0x4,%esp
  80171f:	68 54 3e 80 00       	push   $0x803e54
  801724:	68 e6 00 00 00       	push   $0xe6
  801729:	68 b3 3d 80 00       	push   $0x803db3
  80172e:	e8 22 1d 00 00       	call   803455 <_panic>

00801733 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801733:	55                   	push   %ebp
  801734:	89 e5                	mov    %esp,%ebp
  801736:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801739:	83 ec 04             	sub    $0x4,%esp
  80173c:	68 7c 3e 80 00       	push   $0x803e7c
  801741:	68 fa 00 00 00       	push   $0xfa
  801746:	68 b3 3d 80 00       	push   $0x803db3
  80174b:	e8 05 1d 00 00       	call   803455 <_panic>

00801750 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
  801753:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801756:	83 ec 04             	sub    $0x4,%esp
  801759:	68 a0 3e 80 00       	push   $0x803ea0
  80175e:	68 05 01 00 00       	push   $0x105
  801763:	68 b3 3d 80 00       	push   $0x803db3
  801768:	e8 e8 1c 00 00       	call   803455 <_panic>

0080176d <shrink>:

}
void shrink(uint32 newSize)
{
  80176d:	55                   	push   %ebp
  80176e:	89 e5                	mov    %esp,%ebp
  801770:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801773:	83 ec 04             	sub    $0x4,%esp
  801776:	68 a0 3e 80 00       	push   $0x803ea0
  80177b:	68 0a 01 00 00       	push   $0x10a
  801780:	68 b3 3d 80 00       	push   $0x803db3
  801785:	e8 cb 1c 00 00       	call   803455 <_panic>

0080178a <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80178a:	55                   	push   %ebp
  80178b:	89 e5                	mov    %esp,%ebp
  80178d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801790:	83 ec 04             	sub    $0x4,%esp
  801793:	68 a0 3e 80 00       	push   $0x803ea0
  801798:	68 0f 01 00 00       	push   $0x10f
  80179d:	68 b3 3d 80 00       	push   $0x803db3
  8017a2:	e8 ae 1c 00 00       	call   803455 <_panic>

008017a7 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017a7:	55                   	push   %ebp
  8017a8:	89 e5                	mov    %esp,%ebp
  8017aa:	57                   	push   %edi
  8017ab:	56                   	push   %esi
  8017ac:	53                   	push   %ebx
  8017ad:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017b9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017bc:	8b 7d 18             	mov    0x18(%ebp),%edi
  8017bf:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8017c2:	cd 30                	int    $0x30
  8017c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8017c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017ca:	83 c4 10             	add    $0x10,%esp
  8017cd:	5b                   	pop    %ebx
  8017ce:	5e                   	pop    %esi
  8017cf:	5f                   	pop    %edi
  8017d0:	5d                   	pop    %ebp
  8017d1:	c3                   	ret    

008017d2 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8017d2:	55                   	push   %ebp
  8017d3:	89 e5                	mov    %esp,%ebp
  8017d5:	83 ec 04             	sub    $0x4,%esp
  8017d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8017db:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8017de:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 00                	push   $0x0
  8017e9:	52                   	push   %edx
  8017ea:	ff 75 0c             	pushl  0xc(%ebp)
  8017ed:	50                   	push   %eax
  8017ee:	6a 00                	push   $0x0
  8017f0:	e8 b2 ff ff ff       	call   8017a7 <syscall>
  8017f5:	83 c4 18             	add    $0x18,%esp
}
  8017f8:	90                   	nop
  8017f9:	c9                   	leave  
  8017fa:	c3                   	ret    

008017fb <sys_cgetc>:

int
sys_cgetc(void)
{
  8017fb:	55                   	push   %ebp
  8017fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8017fe:	6a 00                	push   $0x0
  801800:	6a 00                	push   $0x0
  801802:	6a 00                	push   $0x0
  801804:	6a 00                	push   $0x0
  801806:	6a 00                	push   $0x0
  801808:	6a 01                	push   $0x1
  80180a:	e8 98 ff ff ff       	call   8017a7 <syscall>
  80180f:	83 c4 18             	add    $0x18,%esp
}
  801812:	c9                   	leave  
  801813:	c3                   	ret    

00801814 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801814:	55                   	push   %ebp
  801815:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801817:	8b 55 0c             	mov    0xc(%ebp),%edx
  80181a:	8b 45 08             	mov    0x8(%ebp),%eax
  80181d:	6a 00                	push   $0x0
  80181f:	6a 00                	push   $0x0
  801821:	6a 00                	push   $0x0
  801823:	52                   	push   %edx
  801824:	50                   	push   %eax
  801825:	6a 05                	push   $0x5
  801827:	e8 7b ff ff ff       	call   8017a7 <syscall>
  80182c:	83 c4 18             	add    $0x18,%esp
}
  80182f:	c9                   	leave  
  801830:	c3                   	ret    

00801831 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801831:	55                   	push   %ebp
  801832:	89 e5                	mov    %esp,%ebp
  801834:	56                   	push   %esi
  801835:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801836:	8b 75 18             	mov    0x18(%ebp),%esi
  801839:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80183c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80183f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801842:	8b 45 08             	mov    0x8(%ebp),%eax
  801845:	56                   	push   %esi
  801846:	53                   	push   %ebx
  801847:	51                   	push   %ecx
  801848:	52                   	push   %edx
  801849:	50                   	push   %eax
  80184a:	6a 06                	push   $0x6
  80184c:	e8 56 ff ff ff       	call   8017a7 <syscall>
  801851:	83 c4 18             	add    $0x18,%esp
}
  801854:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801857:	5b                   	pop    %ebx
  801858:	5e                   	pop    %esi
  801859:	5d                   	pop    %ebp
  80185a:	c3                   	ret    

0080185b <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80185b:	55                   	push   %ebp
  80185c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80185e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801861:	8b 45 08             	mov    0x8(%ebp),%eax
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	52                   	push   %edx
  80186b:	50                   	push   %eax
  80186c:	6a 07                	push   $0x7
  80186e:	e8 34 ff ff ff       	call   8017a7 <syscall>
  801873:	83 c4 18             	add    $0x18,%esp
}
  801876:	c9                   	leave  
  801877:	c3                   	ret    

00801878 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801878:	55                   	push   %ebp
  801879:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80187b:	6a 00                	push   $0x0
  80187d:	6a 00                	push   $0x0
  80187f:	6a 00                	push   $0x0
  801881:	ff 75 0c             	pushl  0xc(%ebp)
  801884:	ff 75 08             	pushl  0x8(%ebp)
  801887:	6a 08                	push   $0x8
  801889:	e8 19 ff ff ff       	call   8017a7 <syscall>
  80188e:	83 c4 18             	add    $0x18,%esp
}
  801891:	c9                   	leave  
  801892:	c3                   	ret    

00801893 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801893:	55                   	push   %ebp
  801894:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	6a 00                	push   $0x0
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 09                	push   $0x9
  8018a2:	e8 00 ff ff ff       	call   8017a7 <syscall>
  8018a7:	83 c4 18             	add    $0x18,%esp
}
  8018aa:	c9                   	leave  
  8018ab:	c3                   	ret    

008018ac <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018ac:	55                   	push   %ebp
  8018ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 0a                	push   $0xa
  8018bb:	e8 e7 fe ff ff       	call   8017a7 <syscall>
  8018c0:	83 c4 18             	add    $0x18,%esp
}
  8018c3:	c9                   	leave  
  8018c4:	c3                   	ret    

008018c5 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8018c5:	55                   	push   %ebp
  8018c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 0b                	push   $0xb
  8018d4:	e8 ce fe ff ff       	call   8017a7 <syscall>
  8018d9:	83 c4 18             	add    $0x18,%esp
}
  8018dc:	c9                   	leave  
  8018dd:	c3                   	ret    

008018de <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8018de:	55                   	push   %ebp
  8018df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 00                	push   $0x0
  8018e7:	ff 75 0c             	pushl  0xc(%ebp)
  8018ea:	ff 75 08             	pushl  0x8(%ebp)
  8018ed:	6a 0f                	push   $0xf
  8018ef:	e8 b3 fe ff ff       	call   8017a7 <syscall>
  8018f4:	83 c4 18             	add    $0x18,%esp
	return;
  8018f7:	90                   	nop
}
  8018f8:	c9                   	leave  
  8018f9:	c3                   	ret    

008018fa <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8018fa:	55                   	push   %ebp
  8018fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 00                	push   $0x0
  801901:	6a 00                	push   $0x0
  801903:	ff 75 0c             	pushl  0xc(%ebp)
  801906:	ff 75 08             	pushl  0x8(%ebp)
  801909:	6a 10                	push   $0x10
  80190b:	e8 97 fe ff ff       	call   8017a7 <syscall>
  801910:	83 c4 18             	add    $0x18,%esp
	return ;
  801913:	90                   	nop
}
  801914:	c9                   	leave  
  801915:	c3                   	ret    

00801916 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801916:	55                   	push   %ebp
  801917:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	ff 75 10             	pushl  0x10(%ebp)
  801920:	ff 75 0c             	pushl  0xc(%ebp)
  801923:	ff 75 08             	pushl  0x8(%ebp)
  801926:	6a 11                	push   $0x11
  801928:	e8 7a fe ff ff       	call   8017a7 <syscall>
  80192d:	83 c4 18             	add    $0x18,%esp
	return ;
  801930:	90                   	nop
}
  801931:	c9                   	leave  
  801932:	c3                   	ret    

00801933 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801933:	55                   	push   %ebp
  801934:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	6a 0c                	push   $0xc
  801942:	e8 60 fe ff ff       	call   8017a7 <syscall>
  801947:	83 c4 18             	add    $0x18,%esp
}
  80194a:	c9                   	leave  
  80194b:	c3                   	ret    

0080194c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80194c:	55                   	push   %ebp
  80194d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	ff 75 08             	pushl  0x8(%ebp)
  80195a:	6a 0d                	push   $0xd
  80195c:	e8 46 fe ff ff       	call   8017a7 <syscall>
  801961:	83 c4 18             	add    $0x18,%esp
}
  801964:	c9                   	leave  
  801965:	c3                   	ret    

00801966 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801966:	55                   	push   %ebp
  801967:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 0e                	push   $0xe
  801975:	e8 2d fe ff ff       	call   8017a7 <syscall>
  80197a:	83 c4 18             	add    $0x18,%esp
}
  80197d:	90                   	nop
  80197e:	c9                   	leave  
  80197f:	c3                   	ret    

00801980 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801980:	55                   	push   %ebp
  801981:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	6a 13                	push   $0x13
  80198f:	e8 13 fe ff ff       	call   8017a7 <syscall>
  801994:	83 c4 18             	add    $0x18,%esp
}
  801997:	90                   	nop
  801998:	c9                   	leave  
  801999:	c3                   	ret    

0080199a <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 14                	push   $0x14
  8019a9:	e8 f9 fd ff ff       	call   8017a7 <syscall>
  8019ae:	83 c4 18             	add    $0x18,%esp
}
  8019b1:	90                   	nop
  8019b2:	c9                   	leave  
  8019b3:	c3                   	ret    

008019b4 <sys_cputc>:


void
sys_cputc(const char c)
{
  8019b4:	55                   	push   %ebp
  8019b5:	89 e5                	mov    %esp,%ebp
  8019b7:	83 ec 04             	sub    $0x4,%esp
  8019ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019c0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	50                   	push   %eax
  8019cd:	6a 15                	push   $0x15
  8019cf:	e8 d3 fd ff ff       	call   8017a7 <syscall>
  8019d4:	83 c4 18             	add    $0x18,%esp
}
  8019d7:	90                   	nop
  8019d8:	c9                   	leave  
  8019d9:	c3                   	ret    

008019da <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019da:	55                   	push   %ebp
  8019db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 16                	push   $0x16
  8019e9:	e8 b9 fd ff ff       	call   8017a7 <syscall>
  8019ee:	83 c4 18             	add    $0x18,%esp
}
  8019f1:	90                   	nop
  8019f2:	c9                   	leave  
  8019f3:	c3                   	ret    

008019f4 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8019f4:	55                   	push   %ebp
  8019f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8019f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	ff 75 0c             	pushl  0xc(%ebp)
  801a03:	50                   	push   %eax
  801a04:	6a 17                	push   $0x17
  801a06:	e8 9c fd ff ff       	call   8017a7 <syscall>
  801a0b:	83 c4 18             	add    $0x18,%esp
}
  801a0e:	c9                   	leave  
  801a0f:	c3                   	ret    

00801a10 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a10:	55                   	push   %ebp
  801a11:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a13:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a16:	8b 45 08             	mov    0x8(%ebp),%eax
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	52                   	push   %edx
  801a20:	50                   	push   %eax
  801a21:	6a 1a                	push   $0x1a
  801a23:	e8 7f fd ff ff       	call   8017a7 <syscall>
  801a28:	83 c4 18             	add    $0x18,%esp
}
  801a2b:	c9                   	leave  
  801a2c:	c3                   	ret    

00801a2d <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a2d:	55                   	push   %ebp
  801a2e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a30:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a33:	8b 45 08             	mov    0x8(%ebp),%eax
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	52                   	push   %edx
  801a3d:	50                   	push   %eax
  801a3e:	6a 18                	push   $0x18
  801a40:	e8 62 fd ff ff       	call   8017a7 <syscall>
  801a45:	83 c4 18             	add    $0x18,%esp
}
  801a48:	90                   	nop
  801a49:	c9                   	leave  
  801a4a:	c3                   	ret    

00801a4b <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a4b:	55                   	push   %ebp
  801a4c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a51:	8b 45 08             	mov    0x8(%ebp),%eax
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	52                   	push   %edx
  801a5b:	50                   	push   %eax
  801a5c:	6a 19                	push   $0x19
  801a5e:	e8 44 fd ff ff       	call   8017a7 <syscall>
  801a63:	83 c4 18             	add    $0x18,%esp
}
  801a66:	90                   	nop
  801a67:	c9                   	leave  
  801a68:	c3                   	ret    

00801a69 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a69:	55                   	push   %ebp
  801a6a:	89 e5                	mov    %esp,%ebp
  801a6c:	83 ec 04             	sub    $0x4,%esp
  801a6f:	8b 45 10             	mov    0x10(%ebp),%eax
  801a72:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a75:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a78:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7f:	6a 00                	push   $0x0
  801a81:	51                   	push   %ecx
  801a82:	52                   	push   %edx
  801a83:	ff 75 0c             	pushl  0xc(%ebp)
  801a86:	50                   	push   %eax
  801a87:	6a 1b                	push   $0x1b
  801a89:	e8 19 fd ff ff       	call   8017a7 <syscall>
  801a8e:	83 c4 18             	add    $0x18,%esp
}
  801a91:	c9                   	leave  
  801a92:	c3                   	ret    

00801a93 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a93:	55                   	push   %ebp
  801a94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a96:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a99:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	52                   	push   %edx
  801aa3:	50                   	push   %eax
  801aa4:	6a 1c                	push   $0x1c
  801aa6:	e8 fc fc ff ff       	call   8017a7 <syscall>
  801aab:	83 c4 18             	add    $0x18,%esp
}
  801aae:	c9                   	leave  
  801aaf:	c3                   	ret    

00801ab0 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801ab0:	55                   	push   %ebp
  801ab1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ab3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ab6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	51                   	push   %ecx
  801ac1:	52                   	push   %edx
  801ac2:	50                   	push   %eax
  801ac3:	6a 1d                	push   $0x1d
  801ac5:	e8 dd fc ff ff       	call   8017a7 <syscall>
  801aca:	83 c4 18             	add    $0x18,%esp
}
  801acd:	c9                   	leave  
  801ace:	c3                   	ret    

00801acf <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801acf:	55                   	push   %ebp
  801ad0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801ad2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	52                   	push   %edx
  801adf:	50                   	push   %eax
  801ae0:	6a 1e                	push   $0x1e
  801ae2:	e8 c0 fc ff ff       	call   8017a7 <syscall>
  801ae7:	83 c4 18             	add    $0x18,%esp
}
  801aea:	c9                   	leave  
  801aeb:	c3                   	ret    

00801aec <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801aec:	55                   	push   %ebp
  801aed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801aef:	6a 00                	push   $0x0
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 1f                	push   $0x1f
  801afb:	e8 a7 fc ff ff       	call   8017a7 <syscall>
  801b00:	83 c4 18             	add    $0x18,%esp
}
  801b03:	c9                   	leave  
  801b04:	c3                   	ret    

00801b05 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b05:	55                   	push   %ebp
  801b06:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b08:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0b:	6a 00                	push   $0x0
  801b0d:	ff 75 14             	pushl  0x14(%ebp)
  801b10:	ff 75 10             	pushl  0x10(%ebp)
  801b13:	ff 75 0c             	pushl  0xc(%ebp)
  801b16:	50                   	push   %eax
  801b17:	6a 20                	push   $0x20
  801b19:	e8 89 fc ff ff       	call   8017a7 <syscall>
  801b1e:	83 c4 18             	add    $0x18,%esp
}
  801b21:	c9                   	leave  
  801b22:	c3                   	ret    

00801b23 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b23:	55                   	push   %ebp
  801b24:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b26:	8b 45 08             	mov    0x8(%ebp),%eax
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	50                   	push   %eax
  801b32:	6a 21                	push   $0x21
  801b34:	e8 6e fc ff ff       	call   8017a7 <syscall>
  801b39:	83 c4 18             	add    $0x18,%esp
}
  801b3c:	90                   	nop
  801b3d:	c9                   	leave  
  801b3e:	c3                   	ret    

00801b3f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b3f:	55                   	push   %ebp
  801b40:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b42:	8b 45 08             	mov    0x8(%ebp),%eax
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	50                   	push   %eax
  801b4e:	6a 22                	push   $0x22
  801b50:	e8 52 fc ff ff       	call   8017a7 <syscall>
  801b55:	83 c4 18             	add    $0x18,%esp
}
  801b58:	c9                   	leave  
  801b59:	c3                   	ret    

00801b5a <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b5a:	55                   	push   %ebp
  801b5b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	6a 02                	push   $0x2
  801b69:	e8 39 fc ff ff       	call   8017a7 <syscall>
  801b6e:	83 c4 18             	add    $0x18,%esp
}
  801b71:	c9                   	leave  
  801b72:	c3                   	ret    

00801b73 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b73:	55                   	push   %ebp
  801b74:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 03                	push   $0x3
  801b82:	e8 20 fc ff ff       	call   8017a7 <syscall>
  801b87:	83 c4 18             	add    $0x18,%esp
}
  801b8a:	c9                   	leave  
  801b8b:	c3                   	ret    

00801b8c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b8c:	55                   	push   %ebp
  801b8d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	6a 04                	push   $0x4
  801b9b:	e8 07 fc ff ff       	call   8017a7 <syscall>
  801ba0:	83 c4 18             	add    $0x18,%esp
}
  801ba3:	c9                   	leave  
  801ba4:	c3                   	ret    

00801ba5 <sys_exit_env>:


void sys_exit_env(void)
{
  801ba5:	55                   	push   %ebp
  801ba6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 23                	push   $0x23
  801bb4:	e8 ee fb ff ff       	call   8017a7 <syscall>
  801bb9:	83 c4 18             	add    $0x18,%esp
}
  801bbc:	90                   	nop
  801bbd:	c9                   	leave  
  801bbe:	c3                   	ret    

00801bbf <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801bbf:	55                   	push   %ebp
  801bc0:	89 e5                	mov    %esp,%ebp
  801bc2:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801bc5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bc8:	8d 50 04             	lea    0x4(%eax),%edx
  801bcb:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	52                   	push   %edx
  801bd5:	50                   	push   %eax
  801bd6:	6a 24                	push   $0x24
  801bd8:	e8 ca fb ff ff       	call   8017a7 <syscall>
  801bdd:	83 c4 18             	add    $0x18,%esp
	return result;
  801be0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801be3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801be6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801be9:	89 01                	mov    %eax,(%ecx)
  801beb:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801bee:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf1:	c9                   	leave  
  801bf2:	c2 04 00             	ret    $0x4

00801bf5 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801bf5:	55                   	push   %ebp
  801bf6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	ff 75 10             	pushl  0x10(%ebp)
  801bff:	ff 75 0c             	pushl  0xc(%ebp)
  801c02:	ff 75 08             	pushl  0x8(%ebp)
  801c05:	6a 12                	push   $0x12
  801c07:	e8 9b fb ff ff       	call   8017a7 <syscall>
  801c0c:	83 c4 18             	add    $0x18,%esp
	return ;
  801c0f:	90                   	nop
}
  801c10:	c9                   	leave  
  801c11:	c3                   	ret    

00801c12 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c12:	55                   	push   %ebp
  801c13:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 25                	push   $0x25
  801c21:	e8 81 fb ff ff       	call   8017a7 <syscall>
  801c26:	83 c4 18             	add    $0x18,%esp
}
  801c29:	c9                   	leave  
  801c2a:	c3                   	ret    

00801c2b <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c2b:	55                   	push   %ebp
  801c2c:	89 e5                	mov    %esp,%ebp
  801c2e:	83 ec 04             	sub    $0x4,%esp
  801c31:	8b 45 08             	mov    0x8(%ebp),%eax
  801c34:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c37:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 00                	push   $0x0
  801c43:	50                   	push   %eax
  801c44:	6a 26                	push   $0x26
  801c46:	e8 5c fb ff ff       	call   8017a7 <syscall>
  801c4b:	83 c4 18             	add    $0x18,%esp
	return ;
  801c4e:	90                   	nop
}
  801c4f:	c9                   	leave  
  801c50:	c3                   	ret    

00801c51 <rsttst>:
void rsttst()
{
  801c51:	55                   	push   %ebp
  801c52:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 28                	push   $0x28
  801c60:	e8 42 fb ff ff       	call   8017a7 <syscall>
  801c65:	83 c4 18             	add    $0x18,%esp
	return ;
  801c68:	90                   	nop
}
  801c69:	c9                   	leave  
  801c6a:	c3                   	ret    

00801c6b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c6b:	55                   	push   %ebp
  801c6c:	89 e5                	mov    %esp,%ebp
  801c6e:	83 ec 04             	sub    $0x4,%esp
  801c71:	8b 45 14             	mov    0x14(%ebp),%eax
  801c74:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c77:	8b 55 18             	mov    0x18(%ebp),%edx
  801c7a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c7e:	52                   	push   %edx
  801c7f:	50                   	push   %eax
  801c80:	ff 75 10             	pushl  0x10(%ebp)
  801c83:	ff 75 0c             	pushl  0xc(%ebp)
  801c86:	ff 75 08             	pushl  0x8(%ebp)
  801c89:	6a 27                	push   $0x27
  801c8b:	e8 17 fb ff ff       	call   8017a7 <syscall>
  801c90:	83 c4 18             	add    $0x18,%esp
	return ;
  801c93:	90                   	nop
}
  801c94:	c9                   	leave  
  801c95:	c3                   	ret    

00801c96 <chktst>:
void chktst(uint32 n)
{
  801c96:	55                   	push   %ebp
  801c97:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 00                	push   $0x0
  801ca1:	ff 75 08             	pushl  0x8(%ebp)
  801ca4:	6a 29                	push   $0x29
  801ca6:	e8 fc fa ff ff       	call   8017a7 <syscall>
  801cab:	83 c4 18             	add    $0x18,%esp
	return ;
  801cae:	90                   	nop
}
  801caf:	c9                   	leave  
  801cb0:	c3                   	ret    

00801cb1 <inctst>:

void inctst()
{
  801cb1:	55                   	push   %ebp
  801cb2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 2a                	push   $0x2a
  801cc0:	e8 e2 fa ff ff       	call   8017a7 <syscall>
  801cc5:	83 c4 18             	add    $0x18,%esp
	return ;
  801cc8:	90                   	nop
}
  801cc9:	c9                   	leave  
  801cca:	c3                   	ret    

00801ccb <gettst>:
uint32 gettst()
{
  801ccb:	55                   	push   %ebp
  801ccc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 2b                	push   $0x2b
  801cda:	e8 c8 fa ff ff       	call   8017a7 <syscall>
  801cdf:	83 c4 18             	add    $0x18,%esp
}
  801ce2:	c9                   	leave  
  801ce3:	c3                   	ret    

00801ce4 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801ce4:	55                   	push   %ebp
  801ce5:	89 e5                	mov    %esp,%ebp
  801ce7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 2c                	push   $0x2c
  801cf6:	e8 ac fa ff ff       	call   8017a7 <syscall>
  801cfb:	83 c4 18             	add    $0x18,%esp
  801cfe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d01:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d05:	75 07                	jne    801d0e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d07:	b8 01 00 00 00       	mov    $0x1,%eax
  801d0c:	eb 05                	jmp    801d13 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d0e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d13:	c9                   	leave  
  801d14:	c3                   	ret    

00801d15 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d15:	55                   	push   %ebp
  801d16:	89 e5                	mov    %esp,%ebp
  801d18:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	6a 2c                	push   $0x2c
  801d27:	e8 7b fa ff ff       	call   8017a7 <syscall>
  801d2c:	83 c4 18             	add    $0x18,%esp
  801d2f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d32:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d36:	75 07                	jne    801d3f <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d38:	b8 01 00 00 00       	mov    $0x1,%eax
  801d3d:	eb 05                	jmp    801d44 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d3f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d44:	c9                   	leave  
  801d45:	c3                   	ret    

00801d46 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d46:	55                   	push   %ebp
  801d47:	89 e5                	mov    %esp,%ebp
  801d49:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	6a 2c                	push   $0x2c
  801d58:	e8 4a fa ff ff       	call   8017a7 <syscall>
  801d5d:	83 c4 18             	add    $0x18,%esp
  801d60:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d63:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d67:	75 07                	jne    801d70 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d69:	b8 01 00 00 00       	mov    $0x1,%eax
  801d6e:	eb 05                	jmp    801d75 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d75:	c9                   	leave  
  801d76:	c3                   	ret    

00801d77 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d77:	55                   	push   %ebp
  801d78:	89 e5                	mov    %esp,%ebp
  801d7a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	6a 2c                	push   $0x2c
  801d89:	e8 19 fa ff ff       	call   8017a7 <syscall>
  801d8e:	83 c4 18             	add    $0x18,%esp
  801d91:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d94:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d98:	75 07                	jne    801da1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d9a:	b8 01 00 00 00       	mov    $0x1,%eax
  801d9f:	eb 05                	jmp    801da6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801da1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da6:	c9                   	leave  
  801da7:	c3                   	ret    

00801da8 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801da8:	55                   	push   %ebp
  801da9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801dab:	6a 00                	push   $0x0
  801dad:	6a 00                	push   $0x0
  801daf:	6a 00                	push   $0x0
  801db1:	6a 00                	push   $0x0
  801db3:	ff 75 08             	pushl  0x8(%ebp)
  801db6:	6a 2d                	push   $0x2d
  801db8:	e8 ea f9 ff ff       	call   8017a7 <syscall>
  801dbd:	83 c4 18             	add    $0x18,%esp
	return ;
  801dc0:	90                   	nop
}
  801dc1:	c9                   	leave  
  801dc2:	c3                   	ret    

00801dc3 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801dc3:	55                   	push   %ebp
  801dc4:	89 e5                	mov    %esp,%ebp
  801dc6:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801dc7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801dca:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dcd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd3:	6a 00                	push   $0x0
  801dd5:	53                   	push   %ebx
  801dd6:	51                   	push   %ecx
  801dd7:	52                   	push   %edx
  801dd8:	50                   	push   %eax
  801dd9:	6a 2e                	push   $0x2e
  801ddb:	e8 c7 f9 ff ff       	call   8017a7 <syscall>
  801de0:	83 c4 18             	add    $0x18,%esp
}
  801de3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801de6:	c9                   	leave  
  801de7:	c3                   	ret    

00801de8 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801de8:	55                   	push   %ebp
  801de9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801deb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dee:	8b 45 08             	mov    0x8(%ebp),%eax
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	52                   	push   %edx
  801df8:	50                   	push   %eax
  801df9:	6a 2f                	push   $0x2f
  801dfb:	e8 a7 f9 ff ff       	call   8017a7 <syscall>
  801e00:	83 c4 18             	add    $0x18,%esp
}
  801e03:	c9                   	leave  
  801e04:	c3                   	ret    

00801e05 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e05:	55                   	push   %ebp
  801e06:	89 e5                	mov    %esp,%ebp
  801e08:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e0b:	83 ec 0c             	sub    $0xc,%esp
  801e0e:	68 b0 3e 80 00       	push   $0x803eb0
  801e13:	e8 6b e8 ff ff       	call   800683 <cprintf>
  801e18:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e1b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e22:	83 ec 0c             	sub    $0xc,%esp
  801e25:	68 dc 3e 80 00       	push   $0x803edc
  801e2a:	e8 54 e8 ff ff       	call   800683 <cprintf>
  801e2f:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e32:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e36:	a1 38 51 80 00       	mov    0x805138,%eax
  801e3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e3e:	eb 56                	jmp    801e96 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e40:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e44:	74 1c                	je     801e62 <print_mem_block_lists+0x5d>
  801e46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e49:	8b 50 08             	mov    0x8(%eax),%edx
  801e4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e4f:	8b 48 08             	mov    0x8(%eax),%ecx
  801e52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e55:	8b 40 0c             	mov    0xc(%eax),%eax
  801e58:	01 c8                	add    %ecx,%eax
  801e5a:	39 c2                	cmp    %eax,%edx
  801e5c:	73 04                	jae    801e62 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801e5e:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e65:	8b 50 08             	mov    0x8(%eax),%edx
  801e68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e6b:	8b 40 0c             	mov    0xc(%eax),%eax
  801e6e:	01 c2                	add    %eax,%edx
  801e70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e73:	8b 40 08             	mov    0x8(%eax),%eax
  801e76:	83 ec 04             	sub    $0x4,%esp
  801e79:	52                   	push   %edx
  801e7a:	50                   	push   %eax
  801e7b:	68 f1 3e 80 00       	push   $0x803ef1
  801e80:	e8 fe e7 ff ff       	call   800683 <cprintf>
  801e85:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e8e:	a1 40 51 80 00       	mov    0x805140,%eax
  801e93:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e96:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e9a:	74 07                	je     801ea3 <print_mem_block_lists+0x9e>
  801e9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e9f:	8b 00                	mov    (%eax),%eax
  801ea1:	eb 05                	jmp    801ea8 <print_mem_block_lists+0xa3>
  801ea3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea8:	a3 40 51 80 00       	mov    %eax,0x805140
  801ead:	a1 40 51 80 00       	mov    0x805140,%eax
  801eb2:	85 c0                	test   %eax,%eax
  801eb4:	75 8a                	jne    801e40 <print_mem_block_lists+0x3b>
  801eb6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801eba:	75 84                	jne    801e40 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801ebc:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801ec0:	75 10                	jne    801ed2 <print_mem_block_lists+0xcd>
  801ec2:	83 ec 0c             	sub    $0xc,%esp
  801ec5:	68 00 3f 80 00       	push   $0x803f00
  801eca:	e8 b4 e7 ff ff       	call   800683 <cprintf>
  801ecf:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801ed2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801ed9:	83 ec 0c             	sub    $0xc,%esp
  801edc:	68 24 3f 80 00       	push   $0x803f24
  801ee1:	e8 9d e7 ff ff       	call   800683 <cprintf>
  801ee6:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801ee9:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801eed:	a1 40 50 80 00       	mov    0x805040,%eax
  801ef2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ef5:	eb 56                	jmp    801f4d <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ef7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801efb:	74 1c                	je     801f19 <print_mem_block_lists+0x114>
  801efd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f00:	8b 50 08             	mov    0x8(%eax),%edx
  801f03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f06:	8b 48 08             	mov    0x8(%eax),%ecx
  801f09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f0c:	8b 40 0c             	mov    0xc(%eax),%eax
  801f0f:	01 c8                	add    %ecx,%eax
  801f11:	39 c2                	cmp    %eax,%edx
  801f13:	73 04                	jae    801f19 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f15:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f1c:	8b 50 08             	mov    0x8(%eax),%edx
  801f1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f22:	8b 40 0c             	mov    0xc(%eax),%eax
  801f25:	01 c2                	add    %eax,%edx
  801f27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2a:	8b 40 08             	mov    0x8(%eax),%eax
  801f2d:	83 ec 04             	sub    $0x4,%esp
  801f30:	52                   	push   %edx
  801f31:	50                   	push   %eax
  801f32:	68 f1 3e 80 00       	push   $0x803ef1
  801f37:	e8 47 e7 ff ff       	call   800683 <cprintf>
  801f3c:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f42:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f45:	a1 48 50 80 00       	mov    0x805048,%eax
  801f4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f4d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f51:	74 07                	je     801f5a <print_mem_block_lists+0x155>
  801f53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f56:	8b 00                	mov    (%eax),%eax
  801f58:	eb 05                	jmp    801f5f <print_mem_block_lists+0x15a>
  801f5a:	b8 00 00 00 00       	mov    $0x0,%eax
  801f5f:	a3 48 50 80 00       	mov    %eax,0x805048
  801f64:	a1 48 50 80 00       	mov    0x805048,%eax
  801f69:	85 c0                	test   %eax,%eax
  801f6b:	75 8a                	jne    801ef7 <print_mem_block_lists+0xf2>
  801f6d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f71:	75 84                	jne    801ef7 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801f73:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f77:	75 10                	jne    801f89 <print_mem_block_lists+0x184>
  801f79:	83 ec 0c             	sub    $0xc,%esp
  801f7c:	68 3c 3f 80 00       	push   $0x803f3c
  801f81:	e8 fd e6 ff ff       	call   800683 <cprintf>
  801f86:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801f89:	83 ec 0c             	sub    $0xc,%esp
  801f8c:	68 b0 3e 80 00       	push   $0x803eb0
  801f91:	e8 ed e6 ff ff       	call   800683 <cprintf>
  801f96:	83 c4 10             	add    $0x10,%esp

}
  801f99:	90                   	nop
  801f9a:	c9                   	leave  
  801f9b:	c3                   	ret    

00801f9c <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801f9c:	55                   	push   %ebp
  801f9d:	89 e5                	mov    %esp,%ebp
  801f9f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801fa2:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801fa9:	00 00 00 
  801fac:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801fb3:	00 00 00 
  801fb6:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801fbd:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801fc0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801fc7:	e9 9e 00 00 00       	jmp    80206a <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801fcc:	a1 50 50 80 00       	mov    0x805050,%eax
  801fd1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fd4:	c1 e2 04             	shl    $0x4,%edx
  801fd7:	01 d0                	add    %edx,%eax
  801fd9:	85 c0                	test   %eax,%eax
  801fdb:	75 14                	jne    801ff1 <initialize_MemBlocksList+0x55>
  801fdd:	83 ec 04             	sub    $0x4,%esp
  801fe0:	68 64 3f 80 00       	push   $0x803f64
  801fe5:	6a 46                	push   $0x46
  801fe7:	68 87 3f 80 00       	push   $0x803f87
  801fec:	e8 64 14 00 00       	call   803455 <_panic>
  801ff1:	a1 50 50 80 00       	mov    0x805050,%eax
  801ff6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ff9:	c1 e2 04             	shl    $0x4,%edx
  801ffc:	01 d0                	add    %edx,%eax
  801ffe:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802004:	89 10                	mov    %edx,(%eax)
  802006:	8b 00                	mov    (%eax),%eax
  802008:	85 c0                	test   %eax,%eax
  80200a:	74 18                	je     802024 <initialize_MemBlocksList+0x88>
  80200c:	a1 48 51 80 00       	mov    0x805148,%eax
  802011:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802017:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80201a:	c1 e1 04             	shl    $0x4,%ecx
  80201d:	01 ca                	add    %ecx,%edx
  80201f:	89 50 04             	mov    %edx,0x4(%eax)
  802022:	eb 12                	jmp    802036 <initialize_MemBlocksList+0x9a>
  802024:	a1 50 50 80 00       	mov    0x805050,%eax
  802029:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80202c:	c1 e2 04             	shl    $0x4,%edx
  80202f:	01 d0                	add    %edx,%eax
  802031:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802036:	a1 50 50 80 00       	mov    0x805050,%eax
  80203b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80203e:	c1 e2 04             	shl    $0x4,%edx
  802041:	01 d0                	add    %edx,%eax
  802043:	a3 48 51 80 00       	mov    %eax,0x805148
  802048:	a1 50 50 80 00       	mov    0x805050,%eax
  80204d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802050:	c1 e2 04             	shl    $0x4,%edx
  802053:	01 d0                	add    %edx,%eax
  802055:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80205c:	a1 54 51 80 00       	mov    0x805154,%eax
  802061:	40                   	inc    %eax
  802062:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802067:	ff 45 f4             	incl   -0xc(%ebp)
  80206a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802070:	0f 82 56 ff ff ff    	jb     801fcc <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802076:	90                   	nop
  802077:	c9                   	leave  
  802078:	c3                   	ret    

00802079 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802079:	55                   	push   %ebp
  80207a:	89 e5                	mov    %esp,%ebp
  80207c:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80207f:	8b 45 08             	mov    0x8(%ebp),%eax
  802082:	8b 00                	mov    (%eax),%eax
  802084:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802087:	eb 19                	jmp    8020a2 <find_block+0x29>
	{
		if(va==point->sva)
  802089:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80208c:	8b 40 08             	mov    0x8(%eax),%eax
  80208f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802092:	75 05                	jne    802099 <find_block+0x20>
		   return point;
  802094:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802097:	eb 36                	jmp    8020cf <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802099:	8b 45 08             	mov    0x8(%ebp),%eax
  80209c:	8b 40 08             	mov    0x8(%eax),%eax
  80209f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020a6:	74 07                	je     8020af <find_block+0x36>
  8020a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020ab:	8b 00                	mov    (%eax),%eax
  8020ad:	eb 05                	jmp    8020b4 <find_block+0x3b>
  8020af:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8020b7:	89 42 08             	mov    %eax,0x8(%edx)
  8020ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bd:	8b 40 08             	mov    0x8(%eax),%eax
  8020c0:	85 c0                	test   %eax,%eax
  8020c2:	75 c5                	jne    802089 <find_block+0x10>
  8020c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020c8:	75 bf                	jne    802089 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8020ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020cf:	c9                   	leave  
  8020d0:	c3                   	ret    

008020d1 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8020d1:	55                   	push   %ebp
  8020d2:	89 e5                	mov    %esp,%ebp
  8020d4:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8020d7:	a1 40 50 80 00       	mov    0x805040,%eax
  8020dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8020df:	a1 44 50 80 00       	mov    0x805044,%eax
  8020e4:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8020e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ea:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8020ed:	74 24                	je     802113 <insert_sorted_allocList+0x42>
  8020ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f2:	8b 50 08             	mov    0x8(%eax),%edx
  8020f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020f8:	8b 40 08             	mov    0x8(%eax),%eax
  8020fb:	39 c2                	cmp    %eax,%edx
  8020fd:	76 14                	jbe    802113 <insert_sorted_allocList+0x42>
  8020ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802102:	8b 50 08             	mov    0x8(%eax),%edx
  802105:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802108:	8b 40 08             	mov    0x8(%eax),%eax
  80210b:	39 c2                	cmp    %eax,%edx
  80210d:	0f 82 60 01 00 00    	jb     802273 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802113:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802117:	75 65                	jne    80217e <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802119:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80211d:	75 14                	jne    802133 <insert_sorted_allocList+0x62>
  80211f:	83 ec 04             	sub    $0x4,%esp
  802122:	68 64 3f 80 00       	push   $0x803f64
  802127:	6a 6b                	push   $0x6b
  802129:	68 87 3f 80 00       	push   $0x803f87
  80212e:	e8 22 13 00 00       	call   803455 <_panic>
  802133:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802139:	8b 45 08             	mov    0x8(%ebp),%eax
  80213c:	89 10                	mov    %edx,(%eax)
  80213e:	8b 45 08             	mov    0x8(%ebp),%eax
  802141:	8b 00                	mov    (%eax),%eax
  802143:	85 c0                	test   %eax,%eax
  802145:	74 0d                	je     802154 <insert_sorted_allocList+0x83>
  802147:	a1 40 50 80 00       	mov    0x805040,%eax
  80214c:	8b 55 08             	mov    0x8(%ebp),%edx
  80214f:	89 50 04             	mov    %edx,0x4(%eax)
  802152:	eb 08                	jmp    80215c <insert_sorted_allocList+0x8b>
  802154:	8b 45 08             	mov    0x8(%ebp),%eax
  802157:	a3 44 50 80 00       	mov    %eax,0x805044
  80215c:	8b 45 08             	mov    0x8(%ebp),%eax
  80215f:	a3 40 50 80 00       	mov    %eax,0x805040
  802164:	8b 45 08             	mov    0x8(%ebp),%eax
  802167:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80216e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802173:	40                   	inc    %eax
  802174:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802179:	e9 dc 01 00 00       	jmp    80235a <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80217e:	8b 45 08             	mov    0x8(%ebp),%eax
  802181:	8b 50 08             	mov    0x8(%eax),%edx
  802184:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802187:	8b 40 08             	mov    0x8(%eax),%eax
  80218a:	39 c2                	cmp    %eax,%edx
  80218c:	77 6c                	ja     8021fa <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80218e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802192:	74 06                	je     80219a <insert_sorted_allocList+0xc9>
  802194:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802198:	75 14                	jne    8021ae <insert_sorted_allocList+0xdd>
  80219a:	83 ec 04             	sub    $0x4,%esp
  80219d:	68 a0 3f 80 00       	push   $0x803fa0
  8021a2:	6a 6f                	push   $0x6f
  8021a4:	68 87 3f 80 00       	push   $0x803f87
  8021a9:	e8 a7 12 00 00       	call   803455 <_panic>
  8021ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021b1:	8b 50 04             	mov    0x4(%eax),%edx
  8021b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b7:	89 50 04             	mov    %edx,0x4(%eax)
  8021ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021c0:	89 10                	mov    %edx,(%eax)
  8021c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021c5:	8b 40 04             	mov    0x4(%eax),%eax
  8021c8:	85 c0                	test   %eax,%eax
  8021ca:	74 0d                	je     8021d9 <insert_sorted_allocList+0x108>
  8021cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021cf:	8b 40 04             	mov    0x4(%eax),%eax
  8021d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8021d5:	89 10                	mov    %edx,(%eax)
  8021d7:	eb 08                	jmp    8021e1 <insert_sorted_allocList+0x110>
  8021d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021dc:	a3 40 50 80 00       	mov    %eax,0x805040
  8021e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8021e7:	89 50 04             	mov    %edx,0x4(%eax)
  8021ea:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021ef:	40                   	inc    %eax
  8021f0:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021f5:	e9 60 01 00 00       	jmp    80235a <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8021fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fd:	8b 50 08             	mov    0x8(%eax),%edx
  802200:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802203:	8b 40 08             	mov    0x8(%eax),%eax
  802206:	39 c2                	cmp    %eax,%edx
  802208:	0f 82 4c 01 00 00    	jb     80235a <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80220e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802212:	75 14                	jne    802228 <insert_sorted_allocList+0x157>
  802214:	83 ec 04             	sub    $0x4,%esp
  802217:	68 d8 3f 80 00       	push   $0x803fd8
  80221c:	6a 73                	push   $0x73
  80221e:	68 87 3f 80 00       	push   $0x803f87
  802223:	e8 2d 12 00 00       	call   803455 <_panic>
  802228:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80222e:	8b 45 08             	mov    0x8(%ebp),%eax
  802231:	89 50 04             	mov    %edx,0x4(%eax)
  802234:	8b 45 08             	mov    0x8(%ebp),%eax
  802237:	8b 40 04             	mov    0x4(%eax),%eax
  80223a:	85 c0                	test   %eax,%eax
  80223c:	74 0c                	je     80224a <insert_sorted_allocList+0x179>
  80223e:	a1 44 50 80 00       	mov    0x805044,%eax
  802243:	8b 55 08             	mov    0x8(%ebp),%edx
  802246:	89 10                	mov    %edx,(%eax)
  802248:	eb 08                	jmp    802252 <insert_sorted_allocList+0x181>
  80224a:	8b 45 08             	mov    0x8(%ebp),%eax
  80224d:	a3 40 50 80 00       	mov    %eax,0x805040
  802252:	8b 45 08             	mov    0x8(%ebp),%eax
  802255:	a3 44 50 80 00       	mov    %eax,0x805044
  80225a:	8b 45 08             	mov    0x8(%ebp),%eax
  80225d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802263:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802268:	40                   	inc    %eax
  802269:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80226e:	e9 e7 00 00 00       	jmp    80235a <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802273:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802276:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802279:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802280:	a1 40 50 80 00       	mov    0x805040,%eax
  802285:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802288:	e9 9d 00 00 00       	jmp    80232a <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80228d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802290:	8b 00                	mov    (%eax),%eax
  802292:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802295:	8b 45 08             	mov    0x8(%ebp),%eax
  802298:	8b 50 08             	mov    0x8(%eax),%edx
  80229b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229e:	8b 40 08             	mov    0x8(%eax),%eax
  8022a1:	39 c2                	cmp    %eax,%edx
  8022a3:	76 7d                	jbe    802322 <insert_sorted_allocList+0x251>
  8022a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a8:	8b 50 08             	mov    0x8(%eax),%edx
  8022ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022ae:	8b 40 08             	mov    0x8(%eax),%eax
  8022b1:	39 c2                	cmp    %eax,%edx
  8022b3:	73 6d                	jae    802322 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8022b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022b9:	74 06                	je     8022c1 <insert_sorted_allocList+0x1f0>
  8022bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022bf:	75 14                	jne    8022d5 <insert_sorted_allocList+0x204>
  8022c1:	83 ec 04             	sub    $0x4,%esp
  8022c4:	68 fc 3f 80 00       	push   $0x803ffc
  8022c9:	6a 7f                	push   $0x7f
  8022cb:	68 87 3f 80 00       	push   $0x803f87
  8022d0:	e8 80 11 00 00       	call   803455 <_panic>
  8022d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d8:	8b 10                	mov    (%eax),%edx
  8022da:	8b 45 08             	mov    0x8(%ebp),%eax
  8022dd:	89 10                	mov    %edx,(%eax)
  8022df:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e2:	8b 00                	mov    (%eax),%eax
  8022e4:	85 c0                	test   %eax,%eax
  8022e6:	74 0b                	je     8022f3 <insert_sorted_allocList+0x222>
  8022e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022eb:	8b 00                	mov    (%eax),%eax
  8022ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8022f0:	89 50 04             	mov    %edx,0x4(%eax)
  8022f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8022f9:	89 10                	mov    %edx,(%eax)
  8022fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802301:	89 50 04             	mov    %edx,0x4(%eax)
  802304:	8b 45 08             	mov    0x8(%ebp),%eax
  802307:	8b 00                	mov    (%eax),%eax
  802309:	85 c0                	test   %eax,%eax
  80230b:	75 08                	jne    802315 <insert_sorted_allocList+0x244>
  80230d:	8b 45 08             	mov    0x8(%ebp),%eax
  802310:	a3 44 50 80 00       	mov    %eax,0x805044
  802315:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80231a:	40                   	inc    %eax
  80231b:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802320:	eb 39                	jmp    80235b <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802322:	a1 48 50 80 00       	mov    0x805048,%eax
  802327:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80232a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80232e:	74 07                	je     802337 <insert_sorted_allocList+0x266>
  802330:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802333:	8b 00                	mov    (%eax),%eax
  802335:	eb 05                	jmp    80233c <insert_sorted_allocList+0x26b>
  802337:	b8 00 00 00 00       	mov    $0x0,%eax
  80233c:	a3 48 50 80 00       	mov    %eax,0x805048
  802341:	a1 48 50 80 00       	mov    0x805048,%eax
  802346:	85 c0                	test   %eax,%eax
  802348:	0f 85 3f ff ff ff    	jne    80228d <insert_sorted_allocList+0x1bc>
  80234e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802352:	0f 85 35 ff ff ff    	jne    80228d <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802358:	eb 01                	jmp    80235b <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80235a:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80235b:	90                   	nop
  80235c:	c9                   	leave  
  80235d:	c3                   	ret    

0080235e <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80235e:	55                   	push   %ebp
  80235f:	89 e5                	mov    %esp,%ebp
  802361:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802364:	a1 38 51 80 00       	mov    0x805138,%eax
  802369:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80236c:	e9 85 01 00 00       	jmp    8024f6 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802371:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802374:	8b 40 0c             	mov    0xc(%eax),%eax
  802377:	3b 45 08             	cmp    0x8(%ebp),%eax
  80237a:	0f 82 6e 01 00 00    	jb     8024ee <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802380:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802383:	8b 40 0c             	mov    0xc(%eax),%eax
  802386:	3b 45 08             	cmp    0x8(%ebp),%eax
  802389:	0f 85 8a 00 00 00    	jne    802419 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80238f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802393:	75 17                	jne    8023ac <alloc_block_FF+0x4e>
  802395:	83 ec 04             	sub    $0x4,%esp
  802398:	68 30 40 80 00       	push   $0x804030
  80239d:	68 93 00 00 00       	push   $0x93
  8023a2:	68 87 3f 80 00       	push   $0x803f87
  8023a7:	e8 a9 10 00 00       	call   803455 <_panic>
  8023ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023af:	8b 00                	mov    (%eax),%eax
  8023b1:	85 c0                	test   %eax,%eax
  8023b3:	74 10                	je     8023c5 <alloc_block_FF+0x67>
  8023b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b8:	8b 00                	mov    (%eax),%eax
  8023ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023bd:	8b 52 04             	mov    0x4(%edx),%edx
  8023c0:	89 50 04             	mov    %edx,0x4(%eax)
  8023c3:	eb 0b                	jmp    8023d0 <alloc_block_FF+0x72>
  8023c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c8:	8b 40 04             	mov    0x4(%eax),%eax
  8023cb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8023d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d3:	8b 40 04             	mov    0x4(%eax),%eax
  8023d6:	85 c0                	test   %eax,%eax
  8023d8:	74 0f                	je     8023e9 <alloc_block_FF+0x8b>
  8023da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023dd:	8b 40 04             	mov    0x4(%eax),%eax
  8023e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023e3:	8b 12                	mov    (%edx),%edx
  8023e5:	89 10                	mov    %edx,(%eax)
  8023e7:	eb 0a                	jmp    8023f3 <alloc_block_FF+0x95>
  8023e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ec:	8b 00                	mov    (%eax),%eax
  8023ee:	a3 38 51 80 00       	mov    %eax,0x805138
  8023f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802406:	a1 44 51 80 00       	mov    0x805144,%eax
  80240b:	48                   	dec    %eax
  80240c:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802411:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802414:	e9 10 01 00 00       	jmp    802529 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802419:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241c:	8b 40 0c             	mov    0xc(%eax),%eax
  80241f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802422:	0f 86 c6 00 00 00    	jbe    8024ee <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802428:	a1 48 51 80 00       	mov    0x805148,%eax
  80242d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802430:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802433:	8b 50 08             	mov    0x8(%eax),%edx
  802436:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802439:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  80243c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80243f:	8b 55 08             	mov    0x8(%ebp),%edx
  802442:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802445:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802449:	75 17                	jne    802462 <alloc_block_FF+0x104>
  80244b:	83 ec 04             	sub    $0x4,%esp
  80244e:	68 30 40 80 00       	push   $0x804030
  802453:	68 9b 00 00 00       	push   $0x9b
  802458:	68 87 3f 80 00       	push   $0x803f87
  80245d:	e8 f3 0f 00 00       	call   803455 <_panic>
  802462:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802465:	8b 00                	mov    (%eax),%eax
  802467:	85 c0                	test   %eax,%eax
  802469:	74 10                	je     80247b <alloc_block_FF+0x11d>
  80246b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80246e:	8b 00                	mov    (%eax),%eax
  802470:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802473:	8b 52 04             	mov    0x4(%edx),%edx
  802476:	89 50 04             	mov    %edx,0x4(%eax)
  802479:	eb 0b                	jmp    802486 <alloc_block_FF+0x128>
  80247b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80247e:	8b 40 04             	mov    0x4(%eax),%eax
  802481:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802486:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802489:	8b 40 04             	mov    0x4(%eax),%eax
  80248c:	85 c0                	test   %eax,%eax
  80248e:	74 0f                	je     80249f <alloc_block_FF+0x141>
  802490:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802493:	8b 40 04             	mov    0x4(%eax),%eax
  802496:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802499:	8b 12                	mov    (%edx),%edx
  80249b:	89 10                	mov    %edx,(%eax)
  80249d:	eb 0a                	jmp    8024a9 <alloc_block_FF+0x14b>
  80249f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024a2:	8b 00                	mov    (%eax),%eax
  8024a4:	a3 48 51 80 00       	mov    %eax,0x805148
  8024a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024b5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024bc:	a1 54 51 80 00       	mov    0x805154,%eax
  8024c1:	48                   	dec    %eax
  8024c2:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8024c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ca:	8b 50 08             	mov    0x8(%eax),%edx
  8024cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d0:	01 c2                	add    %eax,%edx
  8024d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d5:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8024d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024db:	8b 40 0c             	mov    0xc(%eax),%eax
  8024de:	2b 45 08             	sub    0x8(%ebp),%eax
  8024e1:	89 c2                	mov    %eax,%edx
  8024e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e6:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8024e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ec:	eb 3b                	jmp    802529 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8024ee:	a1 40 51 80 00       	mov    0x805140,%eax
  8024f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024fa:	74 07                	je     802503 <alloc_block_FF+0x1a5>
  8024fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ff:	8b 00                	mov    (%eax),%eax
  802501:	eb 05                	jmp    802508 <alloc_block_FF+0x1aa>
  802503:	b8 00 00 00 00       	mov    $0x0,%eax
  802508:	a3 40 51 80 00       	mov    %eax,0x805140
  80250d:	a1 40 51 80 00       	mov    0x805140,%eax
  802512:	85 c0                	test   %eax,%eax
  802514:	0f 85 57 fe ff ff    	jne    802371 <alloc_block_FF+0x13>
  80251a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80251e:	0f 85 4d fe ff ff    	jne    802371 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802524:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802529:	c9                   	leave  
  80252a:	c3                   	ret    

0080252b <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80252b:	55                   	push   %ebp
  80252c:	89 e5                	mov    %esp,%ebp
  80252e:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802531:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802538:	a1 38 51 80 00       	mov    0x805138,%eax
  80253d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802540:	e9 df 00 00 00       	jmp    802624 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802545:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802548:	8b 40 0c             	mov    0xc(%eax),%eax
  80254b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80254e:	0f 82 c8 00 00 00    	jb     80261c <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802554:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802557:	8b 40 0c             	mov    0xc(%eax),%eax
  80255a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80255d:	0f 85 8a 00 00 00    	jne    8025ed <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802563:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802567:	75 17                	jne    802580 <alloc_block_BF+0x55>
  802569:	83 ec 04             	sub    $0x4,%esp
  80256c:	68 30 40 80 00       	push   $0x804030
  802571:	68 b7 00 00 00       	push   $0xb7
  802576:	68 87 3f 80 00       	push   $0x803f87
  80257b:	e8 d5 0e 00 00       	call   803455 <_panic>
  802580:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802583:	8b 00                	mov    (%eax),%eax
  802585:	85 c0                	test   %eax,%eax
  802587:	74 10                	je     802599 <alloc_block_BF+0x6e>
  802589:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258c:	8b 00                	mov    (%eax),%eax
  80258e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802591:	8b 52 04             	mov    0x4(%edx),%edx
  802594:	89 50 04             	mov    %edx,0x4(%eax)
  802597:	eb 0b                	jmp    8025a4 <alloc_block_BF+0x79>
  802599:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259c:	8b 40 04             	mov    0x4(%eax),%eax
  80259f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8025a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a7:	8b 40 04             	mov    0x4(%eax),%eax
  8025aa:	85 c0                	test   %eax,%eax
  8025ac:	74 0f                	je     8025bd <alloc_block_BF+0x92>
  8025ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b1:	8b 40 04             	mov    0x4(%eax),%eax
  8025b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025b7:	8b 12                	mov    (%edx),%edx
  8025b9:	89 10                	mov    %edx,(%eax)
  8025bb:	eb 0a                	jmp    8025c7 <alloc_block_BF+0x9c>
  8025bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c0:	8b 00                	mov    (%eax),%eax
  8025c2:	a3 38 51 80 00       	mov    %eax,0x805138
  8025c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025da:	a1 44 51 80 00       	mov    0x805144,%eax
  8025df:	48                   	dec    %eax
  8025e0:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8025e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e8:	e9 4d 01 00 00       	jmp    80273a <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8025ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8025f3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025f6:	76 24                	jbe    80261c <alloc_block_BF+0xf1>
  8025f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fb:	8b 40 0c             	mov    0xc(%eax),%eax
  8025fe:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802601:	73 19                	jae    80261c <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802603:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  80260a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260d:	8b 40 0c             	mov    0xc(%eax),%eax
  802610:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802613:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802616:	8b 40 08             	mov    0x8(%eax),%eax
  802619:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80261c:	a1 40 51 80 00       	mov    0x805140,%eax
  802621:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802624:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802628:	74 07                	je     802631 <alloc_block_BF+0x106>
  80262a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262d:	8b 00                	mov    (%eax),%eax
  80262f:	eb 05                	jmp    802636 <alloc_block_BF+0x10b>
  802631:	b8 00 00 00 00       	mov    $0x0,%eax
  802636:	a3 40 51 80 00       	mov    %eax,0x805140
  80263b:	a1 40 51 80 00       	mov    0x805140,%eax
  802640:	85 c0                	test   %eax,%eax
  802642:	0f 85 fd fe ff ff    	jne    802545 <alloc_block_BF+0x1a>
  802648:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80264c:	0f 85 f3 fe ff ff    	jne    802545 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802652:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802656:	0f 84 d9 00 00 00    	je     802735 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  80265c:	a1 48 51 80 00       	mov    0x805148,%eax
  802661:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802664:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802667:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80266a:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  80266d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802670:	8b 55 08             	mov    0x8(%ebp),%edx
  802673:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802676:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80267a:	75 17                	jne    802693 <alloc_block_BF+0x168>
  80267c:	83 ec 04             	sub    $0x4,%esp
  80267f:	68 30 40 80 00       	push   $0x804030
  802684:	68 c7 00 00 00       	push   $0xc7
  802689:	68 87 3f 80 00       	push   $0x803f87
  80268e:	e8 c2 0d 00 00       	call   803455 <_panic>
  802693:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802696:	8b 00                	mov    (%eax),%eax
  802698:	85 c0                	test   %eax,%eax
  80269a:	74 10                	je     8026ac <alloc_block_BF+0x181>
  80269c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80269f:	8b 00                	mov    (%eax),%eax
  8026a1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026a4:	8b 52 04             	mov    0x4(%edx),%edx
  8026a7:	89 50 04             	mov    %edx,0x4(%eax)
  8026aa:	eb 0b                	jmp    8026b7 <alloc_block_BF+0x18c>
  8026ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026af:	8b 40 04             	mov    0x4(%eax),%eax
  8026b2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8026b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026ba:	8b 40 04             	mov    0x4(%eax),%eax
  8026bd:	85 c0                	test   %eax,%eax
  8026bf:	74 0f                	je     8026d0 <alloc_block_BF+0x1a5>
  8026c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026c4:	8b 40 04             	mov    0x4(%eax),%eax
  8026c7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026ca:	8b 12                	mov    (%edx),%edx
  8026cc:	89 10                	mov    %edx,(%eax)
  8026ce:	eb 0a                	jmp    8026da <alloc_block_BF+0x1af>
  8026d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026d3:	8b 00                	mov    (%eax),%eax
  8026d5:	a3 48 51 80 00       	mov    %eax,0x805148
  8026da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026e6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026ed:	a1 54 51 80 00       	mov    0x805154,%eax
  8026f2:	48                   	dec    %eax
  8026f3:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8026f8:	83 ec 08             	sub    $0x8,%esp
  8026fb:	ff 75 ec             	pushl  -0x14(%ebp)
  8026fe:	68 38 51 80 00       	push   $0x805138
  802703:	e8 71 f9 ff ff       	call   802079 <find_block>
  802708:	83 c4 10             	add    $0x10,%esp
  80270b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  80270e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802711:	8b 50 08             	mov    0x8(%eax),%edx
  802714:	8b 45 08             	mov    0x8(%ebp),%eax
  802717:	01 c2                	add    %eax,%edx
  802719:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80271c:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  80271f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802722:	8b 40 0c             	mov    0xc(%eax),%eax
  802725:	2b 45 08             	sub    0x8(%ebp),%eax
  802728:	89 c2                	mov    %eax,%edx
  80272a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80272d:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802730:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802733:	eb 05                	jmp    80273a <alloc_block_BF+0x20f>
	}
	return NULL;
  802735:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80273a:	c9                   	leave  
  80273b:	c3                   	ret    

0080273c <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80273c:	55                   	push   %ebp
  80273d:	89 e5                	mov    %esp,%ebp
  80273f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802742:	a1 28 50 80 00       	mov    0x805028,%eax
  802747:	85 c0                	test   %eax,%eax
  802749:	0f 85 de 01 00 00    	jne    80292d <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80274f:	a1 38 51 80 00       	mov    0x805138,%eax
  802754:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802757:	e9 9e 01 00 00       	jmp    8028fa <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  80275c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275f:	8b 40 0c             	mov    0xc(%eax),%eax
  802762:	3b 45 08             	cmp    0x8(%ebp),%eax
  802765:	0f 82 87 01 00 00    	jb     8028f2 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  80276b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276e:	8b 40 0c             	mov    0xc(%eax),%eax
  802771:	3b 45 08             	cmp    0x8(%ebp),%eax
  802774:	0f 85 95 00 00 00    	jne    80280f <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  80277a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80277e:	75 17                	jne    802797 <alloc_block_NF+0x5b>
  802780:	83 ec 04             	sub    $0x4,%esp
  802783:	68 30 40 80 00       	push   $0x804030
  802788:	68 e0 00 00 00       	push   $0xe0
  80278d:	68 87 3f 80 00       	push   $0x803f87
  802792:	e8 be 0c 00 00       	call   803455 <_panic>
  802797:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279a:	8b 00                	mov    (%eax),%eax
  80279c:	85 c0                	test   %eax,%eax
  80279e:	74 10                	je     8027b0 <alloc_block_NF+0x74>
  8027a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a3:	8b 00                	mov    (%eax),%eax
  8027a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027a8:	8b 52 04             	mov    0x4(%edx),%edx
  8027ab:	89 50 04             	mov    %edx,0x4(%eax)
  8027ae:	eb 0b                	jmp    8027bb <alloc_block_NF+0x7f>
  8027b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b3:	8b 40 04             	mov    0x4(%eax),%eax
  8027b6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8027bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027be:	8b 40 04             	mov    0x4(%eax),%eax
  8027c1:	85 c0                	test   %eax,%eax
  8027c3:	74 0f                	je     8027d4 <alloc_block_NF+0x98>
  8027c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c8:	8b 40 04             	mov    0x4(%eax),%eax
  8027cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027ce:	8b 12                	mov    (%edx),%edx
  8027d0:	89 10                	mov    %edx,(%eax)
  8027d2:	eb 0a                	jmp    8027de <alloc_block_NF+0xa2>
  8027d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d7:	8b 00                	mov    (%eax),%eax
  8027d9:	a3 38 51 80 00       	mov    %eax,0x805138
  8027de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027f1:	a1 44 51 80 00       	mov    0x805144,%eax
  8027f6:	48                   	dec    %eax
  8027f7:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8027fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ff:	8b 40 08             	mov    0x8(%eax),%eax
  802802:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802807:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280a:	e9 f8 04 00 00       	jmp    802d07 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  80280f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802812:	8b 40 0c             	mov    0xc(%eax),%eax
  802815:	3b 45 08             	cmp    0x8(%ebp),%eax
  802818:	0f 86 d4 00 00 00    	jbe    8028f2 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80281e:	a1 48 51 80 00       	mov    0x805148,%eax
  802823:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802826:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802829:	8b 50 08             	mov    0x8(%eax),%edx
  80282c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80282f:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802832:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802835:	8b 55 08             	mov    0x8(%ebp),%edx
  802838:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80283b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80283f:	75 17                	jne    802858 <alloc_block_NF+0x11c>
  802841:	83 ec 04             	sub    $0x4,%esp
  802844:	68 30 40 80 00       	push   $0x804030
  802849:	68 e9 00 00 00       	push   $0xe9
  80284e:	68 87 3f 80 00       	push   $0x803f87
  802853:	e8 fd 0b 00 00       	call   803455 <_panic>
  802858:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80285b:	8b 00                	mov    (%eax),%eax
  80285d:	85 c0                	test   %eax,%eax
  80285f:	74 10                	je     802871 <alloc_block_NF+0x135>
  802861:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802864:	8b 00                	mov    (%eax),%eax
  802866:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802869:	8b 52 04             	mov    0x4(%edx),%edx
  80286c:	89 50 04             	mov    %edx,0x4(%eax)
  80286f:	eb 0b                	jmp    80287c <alloc_block_NF+0x140>
  802871:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802874:	8b 40 04             	mov    0x4(%eax),%eax
  802877:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80287c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80287f:	8b 40 04             	mov    0x4(%eax),%eax
  802882:	85 c0                	test   %eax,%eax
  802884:	74 0f                	je     802895 <alloc_block_NF+0x159>
  802886:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802889:	8b 40 04             	mov    0x4(%eax),%eax
  80288c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80288f:	8b 12                	mov    (%edx),%edx
  802891:	89 10                	mov    %edx,(%eax)
  802893:	eb 0a                	jmp    80289f <alloc_block_NF+0x163>
  802895:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802898:	8b 00                	mov    (%eax),%eax
  80289a:	a3 48 51 80 00       	mov    %eax,0x805148
  80289f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028b2:	a1 54 51 80 00       	mov    0x805154,%eax
  8028b7:	48                   	dec    %eax
  8028b8:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  8028bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c0:	8b 40 08             	mov    0x8(%eax),%eax
  8028c3:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8028c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cb:	8b 50 08             	mov    0x8(%eax),%edx
  8028ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d1:	01 c2                	add    %eax,%edx
  8028d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d6:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8028d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8028df:	2b 45 08             	sub    0x8(%ebp),%eax
  8028e2:	89 c2                	mov    %eax,%edx
  8028e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e7:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8028ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ed:	e9 15 04 00 00       	jmp    802d07 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8028f2:	a1 40 51 80 00       	mov    0x805140,%eax
  8028f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028fe:	74 07                	je     802907 <alloc_block_NF+0x1cb>
  802900:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802903:	8b 00                	mov    (%eax),%eax
  802905:	eb 05                	jmp    80290c <alloc_block_NF+0x1d0>
  802907:	b8 00 00 00 00       	mov    $0x0,%eax
  80290c:	a3 40 51 80 00       	mov    %eax,0x805140
  802911:	a1 40 51 80 00       	mov    0x805140,%eax
  802916:	85 c0                	test   %eax,%eax
  802918:	0f 85 3e fe ff ff    	jne    80275c <alloc_block_NF+0x20>
  80291e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802922:	0f 85 34 fe ff ff    	jne    80275c <alloc_block_NF+0x20>
  802928:	e9 d5 03 00 00       	jmp    802d02 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80292d:	a1 38 51 80 00       	mov    0x805138,%eax
  802932:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802935:	e9 b1 01 00 00       	jmp    802aeb <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  80293a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293d:	8b 50 08             	mov    0x8(%eax),%edx
  802940:	a1 28 50 80 00       	mov    0x805028,%eax
  802945:	39 c2                	cmp    %eax,%edx
  802947:	0f 82 96 01 00 00    	jb     802ae3 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  80294d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802950:	8b 40 0c             	mov    0xc(%eax),%eax
  802953:	3b 45 08             	cmp    0x8(%ebp),%eax
  802956:	0f 82 87 01 00 00    	jb     802ae3 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  80295c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295f:	8b 40 0c             	mov    0xc(%eax),%eax
  802962:	3b 45 08             	cmp    0x8(%ebp),%eax
  802965:	0f 85 95 00 00 00    	jne    802a00 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80296b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80296f:	75 17                	jne    802988 <alloc_block_NF+0x24c>
  802971:	83 ec 04             	sub    $0x4,%esp
  802974:	68 30 40 80 00       	push   $0x804030
  802979:	68 fc 00 00 00       	push   $0xfc
  80297e:	68 87 3f 80 00       	push   $0x803f87
  802983:	e8 cd 0a 00 00       	call   803455 <_panic>
  802988:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298b:	8b 00                	mov    (%eax),%eax
  80298d:	85 c0                	test   %eax,%eax
  80298f:	74 10                	je     8029a1 <alloc_block_NF+0x265>
  802991:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802994:	8b 00                	mov    (%eax),%eax
  802996:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802999:	8b 52 04             	mov    0x4(%edx),%edx
  80299c:	89 50 04             	mov    %edx,0x4(%eax)
  80299f:	eb 0b                	jmp    8029ac <alloc_block_NF+0x270>
  8029a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a4:	8b 40 04             	mov    0x4(%eax),%eax
  8029a7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8029ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029af:	8b 40 04             	mov    0x4(%eax),%eax
  8029b2:	85 c0                	test   %eax,%eax
  8029b4:	74 0f                	je     8029c5 <alloc_block_NF+0x289>
  8029b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b9:	8b 40 04             	mov    0x4(%eax),%eax
  8029bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029bf:	8b 12                	mov    (%edx),%edx
  8029c1:	89 10                	mov    %edx,(%eax)
  8029c3:	eb 0a                	jmp    8029cf <alloc_block_NF+0x293>
  8029c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c8:	8b 00                	mov    (%eax),%eax
  8029ca:	a3 38 51 80 00       	mov    %eax,0x805138
  8029cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029db:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029e2:	a1 44 51 80 00       	mov    0x805144,%eax
  8029e7:	48                   	dec    %eax
  8029e8:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8029ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f0:	8b 40 08             	mov    0x8(%eax),%eax
  8029f3:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8029f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fb:	e9 07 03 00 00       	jmp    802d07 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a03:	8b 40 0c             	mov    0xc(%eax),%eax
  802a06:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a09:	0f 86 d4 00 00 00    	jbe    802ae3 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a0f:	a1 48 51 80 00       	mov    0x805148,%eax
  802a14:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1a:	8b 50 08             	mov    0x8(%eax),%edx
  802a1d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a20:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802a23:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a26:	8b 55 08             	mov    0x8(%ebp),%edx
  802a29:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802a2c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a30:	75 17                	jne    802a49 <alloc_block_NF+0x30d>
  802a32:	83 ec 04             	sub    $0x4,%esp
  802a35:	68 30 40 80 00       	push   $0x804030
  802a3a:	68 04 01 00 00       	push   $0x104
  802a3f:	68 87 3f 80 00       	push   $0x803f87
  802a44:	e8 0c 0a 00 00       	call   803455 <_panic>
  802a49:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a4c:	8b 00                	mov    (%eax),%eax
  802a4e:	85 c0                	test   %eax,%eax
  802a50:	74 10                	je     802a62 <alloc_block_NF+0x326>
  802a52:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a55:	8b 00                	mov    (%eax),%eax
  802a57:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a5a:	8b 52 04             	mov    0x4(%edx),%edx
  802a5d:	89 50 04             	mov    %edx,0x4(%eax)
  802a60:	eb 0b                	jmp    802a6d <alloc_block_NF+0x331>
  802a62:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a65:	8b 40 04             	mov    0x4(%eax),%eax
  802a68:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a70:	8b 40 04             	mov    0x4(%eax),%eax
  802a73:	85 c0                	test   %eax,%eax
  802a75:	74 0f                	je     802a86 <alloc_block_NF+0x34a>
  802a77:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a7a:	8b 40 04             	mov    0x4(%eax),%eax
  802a7d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a80:	8b 12                	mov    (%edx),%edx
  802a82:	89 10                	mov    %edx,(%eax)
  802a84:	eb 0a                	jmp    802a90 <alloc_block_NF+0x354>
  802a86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a89:	8b 00                	mov    (%eax),%eax
  802a8b:	a3 48 51 80 00       	mov    %eax,0x805148
  802a90:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a93:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a99:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a9c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aa3:	a1 54 51 80 00       	mov    0x805154,%eax
  802aa8:	48                   	dec    %eax
  802aa9:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802aae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ab1:	8b 40 08             	mov    0x8(%eax),%eax
  802ab4:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abc:	8b 50 08             	mov    0x8(%eax),%edx
  802abf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac2:	01 c2                	add    %eax,%edx
  802ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac7:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acd:	8b 40 0c             	mov    0xc(%eax),%eax
  802ad0:	2b 45 08             	sub    0x8(%ebp),%eax
  802ad3:	89 c2                	mov    %eax,%edx
  802ad5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad8:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802adb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ade:	e9 24 02 00 00       	jmp    802d07 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802ae3:	a1 40 51 80 00       	mov    0x805140,%eax
  802ae8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aeb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aef:	74 07                	je     802af8 <alloc_block_NF+0x3bc>
  802af1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af4:	8b 00                	mov    (%eax),%eax
  802af6:	eb 05                	jmp    802afd <alloc_block_NF+0x3c1>
  802af8:	b8 00 00 00 00       	mov    $0x0,%eax
  802afd:	a3 40 51 80 00       	mov    %eax,0x805140
  802b02:	a1 40 51 80 00       	mov    0x805140,%eax
  802b07:	85 c0                	test   %eax,%eax
  802b09:	0f 85 2b fe ff ff    	jne    80293a <alloc_block_NF+0x1fe>
  802b0f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b13:	0f 85 21 fe ff ff    	jne    80293a <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b19:	a1 38 51 80 00       	mov    0x805138,%eax
  802b1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b21:	e9 ae 01 00 00       	jmp    802cd4 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b29:	8b 50 08             	mov    0x8(%eax),%edx
  802b2c:	a1 28 50 80 00       	mov    0x805028,%eax
  802b31:	39 c2                	cmp    %eax,%edx
  802b33:	0f 83 93 01 00 00    	jae    802ccc <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802b39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3c:	8b 40 0c             	mov    0xc(%eax),%eax
  802b3f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b42:	0f 82 84 01 00 00    	jb     802ccc <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802b48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4b:	8b 40 0c             	mov    0xc(%eax),%eax
  802b4e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b51:	0f 85 95 00 00 00    	jne    802bec <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802b57:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b5b:	75 17                	jne    802b74 <alloc_block_NF+0x438>
  802b5d:	83 ec 04             	sub    $0x4,%esp
  802b60:	68 30 40 80 00       	push   $0x804030
  802b65:	68 14 01 00 00       	push   $0x114
  802b6a:	68 87 3f 80 00       	push   $0x803f87
  802b6f:	e8 e1 08 00 00       	call   803455 <_panic>
  802b74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b77:	8b 00                	mov    (%eax),%eax
  802b79:	85 c0                	test   %eax,%eax
  802b7b:	74 10                	je     802b8d <alloc_block_NF+0x451>
  802b7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b80:	8b 00                	mov    (%eax),%eax
  802b82:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b85:	8b 52 04             	mov    0x4(%edx),%edx
  802b88:	89 50 04             	mov    %edx,0x4(%eax)
  802b8b:	eb 0b                	jmp    802b98 <alloc_block_NF+0x45c>
  802b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b90:	8b 40 04             	mov    0x4(%eax),%eax
  802b93:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9b:	8b 40 04             	mov    0x4(%eax),%eax
  802b9e:	85 c0                	test   %eax,%eax
  802ba0:	74 0f                	je     802bb1 <alloc_block_NF+0x475>
  802ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba5:	8b 40 04             	mov    0x4(%eax),%eax
  802ba8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bab:	8b 12                	mov    (%edx),%edx
  802bad:	89 10                	mov    %edx,(%eax)
  802baf:	eb 0a                	jmp    802bbb <alloc_block_NF+0x47f>
  802bb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb4:	8b 00                	mov    (%eax),%eax
  802bb6:	a3 38 51 80 00       	mov    %eax,0x805138
  802bbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bce:	a1 44 51 80 00       	mov    0x805144,%eax
  802bd3:	48                   	dec    %eax
  802bd4:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802bd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdc:	8b 40 08             	mov    0x8(%eax),%eax
  802bdf:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802be4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be7:	e9 1b 01 00 00       	jmp    802d07 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bef:	8b 40 0c             	mov    0xc(%eax),%eax
  802bf2:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bf5:	0f 86 d1 00 00 00    	jbe    802ccc <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802bfb:	a1 48 51 80 00       	mov    0x805148,%eax
  802c00:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c06:	8b 50 08             	mov    0x8(%eax),%edx
  802c09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c0c:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802c0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c12:	8b 55 08             	mov    0x8(%ebp),%edx
  802c15:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802c18:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c1c:	75 17                	jne    802c35 <alloc_block_NF+0x4f9>
  802c1e:	83 ec 04             	sub    $0x4,%esp
  802c21:	68 30 40 80 00       	push   $0x804030
  802c26:	68 1c 01 00 00       	push   $0x11c
  802c2b:	68 87 3f 80 00       	push   $0x803f87
  802c30:	e8 20 08 00 00       	call   803455 <_panic>
  802c35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c38:	8b 00                	mov    (%eax),%eax
  802c3a:	85 c0                	test   %eax,%eax
  802c3c:	74 10                	je     802c4e <alloc_block_NF+0x512>
  802c3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c41:	8b 00                	mov    (%eax),%eax
  802c43:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c46:	8b 52 04             	mov    0x4(%edx),%edx
  802c49:	89 50 04             	mov    %edx,0x4(%eax)
  802c4c:	eb 0b                	jmp    802c59 <alloc_block_NF+0x51d>
  802c4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c51:	8b 40 04             	mov    0x4(%eax),%eax
  802c54:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c59:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c5c:	8b 40 04             	mov    0x4(%eax),%eax
  802c5f:	85 c0                	test   %eax,%eax
  802c61:	74 0f                	je     802c72 <alloc_block_NF+0x536>
  802c63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c66:	8b 40 04             	mov    0x4(%eax),%eax
  802c69:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c6c:	8b 12                	mov    (%edx),%edx
  802c6e:	89 10                	mov    %edx,(%eax)
  802c70:	eb 0a                	jmp    802c7c <alloc_block_NF+0x540>
  802c72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c75:	8b 00                	mov    (%eax),%eax
  802c77:	a3 48 51 80 00       	mov    %eax,0x805148
  802c7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c7f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c88:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c8f:	a1 54 51 80 00       	mov    0x805154,%eax
  802c94:	48                   	dec    %eax
  802c95:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802c9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c9d:	8b 40 08             	mov    0x8(%eax),%eax
  802ca0:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802ca5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca8:	8b 50 08             	mov    0x8(%eax),%edx
  802cab:	8b 45 08             	mov    0x8(%ebp),%eax
  802cae:	01 c2                	add    %eax,%edx
  802cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb3:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802cb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb9:	8b 40 0c             	mov    0xc(%eax),%eax
  802cbc:	2b 45 08             	sub    0x8(%ebp),%eax
  802cbf:	89 c2                	mov    %eax,%edx
  802cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc4:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802cc7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cca:	eb 3b                	jmp    802d07 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802ccc:	a1 40 51 80 00       	mov    0x805140,%eax
  802cd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cd4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cd8:	74 07                	je     802ce1 <alloc_block_NF+0x5a5>
  802cda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdd:	8b 00                	mov    (%eax),%eax
  802cdf:	eb 05                	jmp    802ce6 <alloc_block_NF+0x5aa>
  802ce1:	b8 00 00 00 00       	mov    $0x0,%eax
  802ce6:	a3 40 51 80 00       	mov    %eax,0x805140
  802ceb:	a1 40 51 80 00       	mov    0x805140,%eax
  802cf0:	85 c0                	test   %eax,%eax
  802cf2:	0f 85 2e fe ff ff    	jne    802b26 <alloc_block_NF+0x3ea>
  802cf8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cfc:	0f 85 24 fe ff ff    	jne    802b26 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802d02:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d07:	c9                   	leave  
  802d08:	c3                   	ret    

00802d09 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802d09:	55                   	push   %ebp
  802d0a:	89 e5                	mov    %esp,%ebp
  802d0c:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802d0f:	a1 38 51 80 00       	mov    0x805138,%eax
  802d14:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802d17:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d1c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802d1f:	a1 38 51 80 00       	mov    0x805138,%eax
  802d24:	85 c0                	test   %eax,%eax
  802d26:	74 14                	je     802d3c <insert_sorted_with_merge_freeList+0x33>
  802d28:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2b:	8b 50 08             	mov    0x8(%eax),%edx
  802d2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d31:	8b 40 08             	mov    0x8(%eax),%eax
  802d34:	39 c2                	cmp    %eax,%edx
  802d36:	0f 87 9b 01 00 00    	ja     802ed7 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802d3c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d40:	75 17                	jne    802d59 <insert_sorted_with_merge_freeList+0x50>
  802d42:	83 ec 04             	sub    $0x4,%esp
  802d45:	68 64 3f 80 00       	push   $0x803f64
  802d4a:	68 38 01 00 00       	push   $0x138
  802d4f:	68 87 3f 80 00       	push   $0x803f87
  802d54:	e8 fc 06 00 00       	call   803455 <_panic>
  802d59:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d62:	89 10                	mov    %edx,(%eax)
  802d64:	8b 45 08             	mov    0x8(%ebp),%eax
  802d67:	8b 00                	mov    (%eax),%eax
  802d69:	85 c0                	test   %eax,%eax
  802d6b:	74 0d                	je     802d7a <insert_sorted_with_merge_freeList+0x71>
  802d6d:	a1 38 51 80 00       	mov    0x805138,%eax
  802d72:	8b 55 08             	mov    0x8(%ebp),%edx
  802d75:	89 50 04             	mov    %edx,0x4(%eax)
  802d78:	eb 08                	jmp    802d82 <insert_sorted_with_merge_freeList+0x79>
  802d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d82:	8b 45 08             	mov    0x8(%ebp),%eax
  802d85:	a3 38 51 80 00       	mov    %eax,0x805138
  802d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d94:	a1 44 51 80 00       	mov    0x805144,%eax
  802d99:	40                   	inc    %eax
  802d9a:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d9f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802da3:	0f 84 a8 06 00 00    	je     803451 <insert_sorted_with_merge_freeList+0x748>
  802da9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dac:	8b 50 08             	mov    0x8(%eax),%edx
  802daf:	8b 45 08             	mov    0x8(%ebp),%eax
  802db2:	8b 40 0c             	mov    0xc(%eax),%eax
  802db5:	01 c2                	add    %eax,%edx
  802db7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dba:	8b 40 08             	mov    0x8(%eax),%eax
  802dbd:	39 c2                	cmp    %eax,%edx
  802dbf:	0f 85 8c 06 00 00    	jne    803451 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc8:	8b 50 0c             	mov    0xc(%eax),%edx
  802dcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dce:	8b 40 0c             	mov    0xc(%eax),%eax
  802dd1:	01 c2                	add    %eax,%edx
  802dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd6:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802dd9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ddd:	75 17                	jne    802df6 <insert_sorted_with_merge_freeList+0xed>
  802ddf:	83 ec 04             	sub    $0x4,%esp
  802de2:	68 30 40 80 00       	push   $0x804030
  802de7:	68 3c 01 00 00       	push   $0x13c
  802dec:	68 87 3f 80 00       	push   $0x803f87
  802df1:	e8 5f 06 00 00       	call   803455 <_panic>
  802df6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df9:	8b 00                	mov    (%eax),%eax
  802dfb:	85 c0                	test   %eax,%eax
  802dfd:	74 10                	je     802e0f <insert_sorted_with_merge_freeList+0x106>
  802dff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e02:	8b 00                	mov    (%eax),%eax
  802e04:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e07:	8b 52 04             	mov    0x4(%edx),%edx
  802e0a:	89 50 04             	mov    %edx,0x4(%eax)
  802e0d:	eb 0b                	jmp    802e1a <insert_sorted_with_merge_freeList+0x111>
  802e0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e12:	8b 40 04             	mov    0x4(%eax),%eax
  802e15:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e1d:	8b 40 04             	mov    0x4(%eax),%eax
  802e20:	85 c0                	test   %eax,%eax
  802e22:	74 0f                	je     802e33 <insert_sorted_with_merge_freeList+0x12a>
  802e24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e27:	8b 40 04             	mov    0x4(%eax),%eax
  802e2a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e2d:	8b 12                	mov    (%edx),%edx
  802e2f:	89 10                	mov    %edx,(%eax)
  802e31:	eb 0a                	jmp    802e3d <insert_sorted_with_merge_freeList+0x134>
  802e33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e36:	8b 00                	mov    (%eax),%eax
  802e38:	a3 38 51 80 00       	mov    %eax,0x805138
  802e3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e40:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e49:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e50:	a1 44 51 80 00       	mov    0x805144,%eax
  802e55:	48                   	dec    %eax
  802e56:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802e5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e5e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802e65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e68:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802e6f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e73:	75 17                	jne    802e8c <insert_sorted_with_merge_freeList+0x183>
  802e75:	83 ec 04             	sub    $0x4,%esp
  802e78:	68 64 3f 80 00       	push   $0x803f64
  802e7d:	68 3f 01 00 00       	push   $0x13f
  802e82:	68 87 3f 80 00       	push   $0x803f87
  802e87:	e8 c9 05 00 00       	call   803455 <_panic>
  802e8c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e95:	89 10                	mov    %edx,(%eax)
  802e97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e9a:	8b 00                	mov    (%eax),%eax
  802e9c:	85 c0                	test   %eax,%eax
  802e9e:	74 0d                	je     802ead <insert_sorted_with_merge_freeList+0x1a4>
  802ea0:	a1 48 51 80 00       	mov    0x805148,%eax
  802ea5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ea8:	89 50 04             	mov    %edx,0x4(%eax)
  802eab:	eb 08                	jmp    802eb5 <insert_sorted_with_merge_freeList+0x1ac>
  802ead:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802eb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb8:	a3 48 51 80 00       	mov    %eax,0x805148
  802ebd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ec7:	a1 54 51 80 00       	mov    0x805154,%eax
  802ecc:	40                   	inc    %eax
  802ecd:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802ed2:	e9 7a 05 00 00       	jmp    803451 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eda:	8b 50 08             	mov    0x8(%eax),%edx
  802edd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ee0:	8b 40 08             	mov    0x8(%eax),%eax
  802ee3:	39 c2                	cmp    %eax,%edx
  802ee5:	0f 82 14 01 00 00    	jb     802fff <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802eeb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eee:	8b 50 08             	mov    0x8(%eax),%edx
  802ef1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ef4:	8b 40 0c             	mov    0xc(%eax),%eax
  802ef7:	01 c2                	add    %eax,%edx
  802ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  802efc:	8b 40 08             	mov    0x8(%eax),%eax
  802eff:	39 c2                	cmp    %eax,%edx
  802f01:	0f 85 90 00 00 00    	jne    802f97 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802f07:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f0a:	8b 50 0c             	mov    0xc(%eax),%edx
  802f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f10:	8b 40 0c             	mov    0xc(%eax),%eax
  802f13:	01 c2                	add    %eax,%edx
  802f15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f18:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802f25:	8b 45 08             	mov    0x8(%ebp),%eax
  802f28:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802f2f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f33:	75 17                	jne    802f4c <insert_sorted_with_merge_freeList+0x243>
  802f35:	83 ec 04             	sub    $0x4,%esp
  802f38:	68 64 3f 80 00       	push   $0x803f64
  802f3d:	68 49 01 00 00       	push   $0x149
  802f42:	68 87 3f 80 00       	push   $0x803f87
  802f47:	e8 09 05 00 00       	call   803455 <_panic>
  802f4c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f52:	8b 45 08             	mov    0x8(%ebp),%eax
  802f55:	89 10                	mov    %edx,(%eax)
  802f57:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5a:	8b 00                	mov    (%eax),%eax
  802f5c:	85 c0                	test   %eax,%eax
  802f5e:	74 0d                	je     802f6d <insert_sorted_with_merge_freeList+0x264>
  802f60:	a1 48 51 80 00       	mov    0x805148,%eax
  802f65:	8b 55 08             	mov    0x8(%ebp),%edx
  802f68:	89 50 04             	mov    %edx,0x4(%eax)
  802f6b:	eb 08                	jmp    802f75 <insert_sorted_with_merge_freeList+0x26c>
  802f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f70:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f75:	8b 45 08             	mov    0x8(%ebp),%eax
  802f78:	a3 48 51 80 00       	mov    %eax,0x805148
  802f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f80:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f87:	a1 54 51 80 00       	mov    0x805154,%eax
  802f8c:	40                   	inc    %eax
  802f8d:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f92:	e9 bb 04 00 00       	jmp    803452 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802f97:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f9b:	75 17                	jne    802fb4 <insert_sorted_with_merge_freeList+0x2ab>
  802f9d:	83 ec 04             	sub    $0x4,%esp
  802fa0:	68 d8 3f 80 00       	push   $0x803fd8
  802fa5:	68 4c 01 00 00       	push   $0x14c
  802faa:	68 87 3f 80 00       	push   $0x803f87
  802faf:	e8 a1 04 00 00       	call   803455 <_panic>
  802fb4:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802fba:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbd:	89 50 04             	mov    %edx,0x4(%eax)
  802fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc3:	8b 40 04             	mov    0x4(%eax),%eax
  802fc6:	85 c0                	test   %eax,%eax
  802fc8:	74 0c                	je     802fd6 <insert_sorted_with_merge_freeList+0x2cd>
  802fca:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802fcf:	8b 55 08             	mov    0x8(%ebp),%edx
  802fd2:	89 10                	mov    %edx,(%eax)
  802fd4:	eb 08                	jmp    802fde <insert_sorted_with_merge_freeList+0x2d5>
  802fd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd9:	a3 38 51 80 00       	mov    %eax,0x805138
  802fde:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fef:	a1 44 51 80 00       	mov    0x805144,%eax
  802ff4:	40                   	inc    %eax
  802ff5:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802ffa:	e9 53 04 00 00       	jmp    803452 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802fff:	a1 38 51 80 00       	mov    0x805138,%eax
  803004:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803007:	e9 15 04 00 00       	jmp    803421 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  80300c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300f:	8b 00                	mov    (%eax),%eax
  803011:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803014:	8b 45 08             	mov    0x8(%ebp),%eax
  803017:	8b 50 08             	mov    0x8(%eax),%edx
  80301a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301d:	8b 40 08             	mov    0x8(%eax),%eax
  803020:	39 c2                	cmp    %eax,%edx
  803022:	0f 86 f1 03 00 00    	jbe    803419 <insert_sorted_with_merge_freeList+0x710>
  803028:	8b 45 08             	mov    0x8(%ebp),%eax
  80302b:	8b 50 08             	mov    0x8(%eax),%edx
  80302e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803031:	8b 40 08             	mov    0x8(%eax),%eax
  803034:	39 c2                	cmp    %eax,%edx
  803036:	0f 83 dd 03 00 00    	jae    803419 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  80303c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303f:	8b 50 08             	mov    0x8(%eax),%edx
  803042:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803045:	8b 40 0c             	mov    0xc(%eax),%eax
  803048:	01 c2                	add    %eax,%edx
  80304a:	8b 45 08             	mov    0x8(%ebp),%eax
  80304d:	8b 40 08             	mov    0x8(%eax),%eax
  803050:	39 c2                	cmp    %eax,%edx
  803052:	0f 85 b9 01 00 00    	jne    803211 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803058:	8b 45 08             	mov    0x8(%ebp),%eax
  80305b:	8b 50 08             	mov    0x8(%eax),%edx
  80305e:	8b 45 08             	mov    0x8(%ebp),%eax
  803061:	8b 40 0c             	mov    0xc(%eax),%eax
  803064:	01 c2                	add    %eax,%edx
  803066:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803069:	8b 40 08             	mov    0x8(%eax),%eax
  80306c:	39 c2                	cmp    %eax,%edx
  80306e:	0f 85 0d 01 00 00    	jne    803181 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803074:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803077:	8b 50 0c             	mov    0xc(%eax),%edx
  80307a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80307d:	8b 40 0c             	mov    0xc(%eax),%eax
  803080:	01 c2                	add    %eax,%edx
  803082:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803085:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803088:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80308c:	75 17                	jne    8030a5 <insert_sorted_with_merge_freeList+0x39c>
  80308e:	83 ec 04             	sub    $0x4,%esp
  803091:	68 30 40 80 00       	push   $0x804030
  803096:	68 5c 01 00 00       	push   $0x15c
  80309b:	68 87 3f 80 00       	push   $0x803f87
  8030a0:	e8 b0 03 00 00       	call   803455 <_panic>
  8030a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a8:	8b 00                	mov    (%eax),%eax
  8030aa:	85 c0                	test   %eax,%eax
  8030ac:	74 10                	je     8030be <insert_sorted_with_merge_freeList+0x3b5>
  8030ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b1:	8b 00                	mov    (%eax),%eax
  8030b3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030b6:	8b 52 04             	mov    0x4(%edx),%edx
  8030b9:	89 50 04             	mov    %edx,0x4(%eax)
  8030bc:	eb 0b                	jmp    8030c9 <insert_sorted_with_merge_freeList+0x3c0>
  8030be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c1:	8b 40 04             	mov    0x4(%eax),%eax
  8030c4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030cc:	8b 40 04             	mov    0x4(%eax),%eax
  8030cf:	85 c0                	test   %eax,%eax
  8030d1:	74 0f                	je     8030e2 <insert_sorted_with_merge_freeList+0x3d9>
  8030d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d6:	8b 40 04             	mov    0x4(%eax),%eax
  8030d9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030dc:	8b 12                	mov    (%edx),%edx
  8030de:	89 10                	mov    %edx,(%eax)
  8030e0:	eb 0a                	jmp    8030ec <insert_sorted_with_merge_freeList+0x3e3>
  8030e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e5:	8b 00                	mov    (%eax),%eax
  8030e7:	a3 38 51 80 00       	mov    %eax,0x805138
  8030ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030ff:	a1 44 51 80 00       	mov    0x805144,%eax
  803104:	48                   	dec    %eax
  803105:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  80310a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80310d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803114:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803117:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80311e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803122:	75 17                	jne    80313b <insert_sorted_with_merge_freeList+0x432>
  803124:	83 ec 04             	sub    $0x4,%esp
  803127:	68 64 3f 80 00       	push   $0x803f64
  80312c:	68 5f 01 00 00       	push   $0x15f
  803131:	68 87 3f 80 00       	push   $0x803f87
  803136:	e8 1a 03 00 00       	call   803455 <_panic>
  80313b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803141:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803144:	89 10                	mov    %edx,(%eax)
  803146:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803149:	8b 00                	mov    (%eax),%eax
  80314b:	85 c0                	test   %eax,%eax
  80314d:	74 0d                	je     80315c <insert_sorted_with_merge_freeList+0x453>
  80314f:	a1 48 51 80 00       	mov    0x805148,%eax
  803154:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803157:	89 50 04             	mov    %edx,0x4(%eax)
  80315a:	eb 08                	jmp    803164 <insert_sorted_with_merge_freeList+0x45b>
  80315c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80315f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803164:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803167:	a3 48 51 80 00       	mov    %eax,0x805148
  80316c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80316f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803176:	a1 54 51 80 00       	mov    0x805154,%eax
  80317b:	40                   	inc    %eax
  80317c:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803181:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803184:	8b 50 0c             	mov    0xc(%eax),%edx
  803187:	8b 45 08             	mov    0x8(%ebp),%eax
  80318a:	8b 40 0c             	mov    0xc(%eax),%eax
  80318d:	01 c2                	add    %eax,%edx
  80318f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803192:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803195:	8b 45 08             	mov    0x8(%ebp),%eax
  803198:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80319f:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8031a9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031ad:	75 17                	jne    8031c6 <insert_sorted_with_merge_freeList+0x4bd>
  8031af:	83 ec 04             	sub    $0x4,%esp
  8031b2:	68 64 3f 80 00       	push   $0x803f64
  8031b7:	68 64 01 00 00       	push   $0x164
  8031bc:	68 87 3f 80 00       	push   $0x803f87
  8031c1:	e8 8f 02 00 00       	call   803455 <_panic>
  8031c6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8031cf:	89 10                	mov    %edx,(%eax)
  8031d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d4:	8b 00                	mov    (%eax),%eax
  8031d6:	85 c0                	test   %eax,%eax
  8031d8:	74 0d                	je     8031e7 <insert_sorted_with_merge_freeList+0x4de>
  8031da:	a1 48 51 80 00       	mov    0x805148,%eax
  8031df:	8b 55 08             	mov    0x8(%ebp),%edx
  8031e2:	89 50 04             	mov    %edx,0x4(%eax)
  8031e5:	eb 08                	jmp    8031ef <insert_sorted_with_merge_freeList+0x4e6>
  8031e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ea:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f2:	a3 48 51 80 00       	mov    %eax,0x805148
  8031f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803201:	a1 54 51 80 00       	mov    0x805154,%eax
  803206:	40                   	inc    %eax
  803207:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80320c:	e9 41 02 00 00       	jmp    803452 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803211:	8b 45 08             	mov    0x8(%ebp),%eax
  803214:	8b 50 08             	mov    0x8(%eax),%edx
  803217:	8b 45 08             	mov    0x8(%ebp),%eax
  80321a:	8b 40 0c             	mov    0xc(%eax),%eax
  80321d:	01 c2                	add    %eax,%edx
  80321f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803222:	8b 40 08             	mov    0x8(%eax),%eax
  803225:	39 c2                	cmp    %eax,%edx
  803227:	0f 85 7c 01 00 00    	jne    8033a9 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80322d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803231:	74 06                	je     803239 <insert_sorted_with_merge_freeList+0x530>
  803233:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803237:	75 17                	jne    803250 <insert_sorted_with_merge_freeList+0x547>
  803239:	83 ec 04             	sub    $0x4,%esp
  80323c:	68 a0 3f 80 00       	push   $0x803fa0
  803241:	68 69 01 00 00       	push   $0x169
  803246:	68 87 3f 80 00       	push   $0x803f87
  80324b:	e8 05 02 00 00       	call   803455 <_panic>
  803250:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803253:	8b 50 04             	mov    0x4(%eax),%edx
  803256:	8b 45 08             	mov    0x8(%ebp),%eax
  803259:	89 50 04             	mov    %edx,0x4(%eax)
  80325c:	8b 45 08             	mov    0x8(%ebp),%eax
  80325f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803262:	89 10                	mov    %edx,(%eax)
  803264:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803267:	8b 40 04             	mov    0x4(%eax),%eax
  80326a:	85 c0                	test   %eax,%eax
  80326c:	74 0d                	je     80327b <insert_sorted_with_merge_freeList+0x572>
  80326e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803271:	8b 40 04             	mov    0x4(%eax),%eax
  803274:	8b 55 08             	mov    0x8(%ebp),%edx
  803277:	89 10                	mov    %edx,(%eax)
  803279:	eb 08                	jmp    803283 <insert_sorted_with_merge_freeList+0x57a>
  80327b:	8b 45 08             	mov    0x8(%ebp),%eax
  80327e:	a3 38 51 80 00       	mov    %eax,0x805138
  803283:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803286:	8b 55 08             	mov    0x8(%ebp),%edx
  803289:	89 50 04             	mov    %edx,0x4(%eax)
  80328c:	a1 44 51 80 00       	mov    0x805144,%eax
  803291:	40                   	inc    %eax
  803292:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803297:	8b 45 08             	mov    0x8(%ebp),%eax
  80329a:	8b 50 0c             	mov    0xc(%eax),%edx
  80329d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a0:	8b 40 0c             	mov    0xc(%eax),%eax
  8032a3:	01 c2                	add    %eax,%edx
  8032a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a8:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8032ab:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032af:	75 17                	jne    8032c8 <insert_sorted_with_merge_freeList+0x5bf>
  8032b1:	83 ec 04             	sub    $0x4,%esp
  8032b4:	68 30 40 80 00       	push   $0x804030
  8032b9:	68 6b 01 00 00       	push   $0x16b
  8032be:	68 87 3f 80 00       	push   $0x803f87
  8032c3:	e8 8d 01 00 00       	call   803455 <_panic>
  8032c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032cb:	8b 00                	mov    (%eax),%eax
  8032cd:	85 c0                	test   %eax,%eax
  8032cf:	74 10                	je     8032e1 <insert_sorted_with_merge_freeList+0x5d8>
  8032d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d4:	8b 00                	mov    (%eax),%eax
  8032d6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032d9:	8b 52 04             	mov    0x4(%edx),%edx
  8032dc:	89 50 04             	mov    %edx,0x4(%eax)
  8032df:	eb 0b                	jmp    8032ec <insert_sorted_with_merge_freeList+0x5e3>
  8032e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e4:	8b 40 04             	mov    0x4(%eax),%eax
  8032e7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ef:	8b 40 04             	mov    0x4(%eax),%eax
  8032f2:	85 c0                	test   %eax,%eax
  8032f4:	74 0f                	je     803305 <insert_sorted_with_merge_freeList+0x5fc>
  8032f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f9:	8b 40 04             	mov    0x4(%eax),%eax
  8032fc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032ff:	8b 12                	mov    (%edx),%edx
  803301:	89 10                	mov    %edx,(%eax)
  803303:	eb 0a                	jmp    80330f <insert_sorted_with_merge_freeList+0x606>
  803305:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803308:	8b 00                	mov    (%eax),%eax
  80330a:	a3 38 51 80 00       	mov    %eax,0x805138
  80330f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803312:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803318:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80331b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803322:	a1 44 51 80 00       	mov    0x805144,%eax
  803327:	48                   	dec    %eax
  803328:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  80332d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803330:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803337:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80333a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803341:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803345:	75 17                	jne    80335e <insert_sorted_with_merge_freeList+0x655>
  803347:	83 ec 04             	sub    $0x4,%esp
  80334a:	68 64 3f 80 00       	push   $0x803f64
  80334f:	68 6e 01 00 00       	push   $0x16e
  803354:	68 87 3f 80 00       	push   $0x803f87
  803359:	e8 f7 00 00 00       	call   803455 <_panic>
  80335e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803364:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803367:	89 10                	mov    %edx,(%eax)
  803369:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80336c:	8b 00                	mov    (%eax),%eax
  80336e:	85 c0                	test   %eax,%eax
  803370:	74 0d                	je     80337f <insert_sorted_with_merge_freeList+0x676>
  803372:	a1 48 51 80 00       	mov    0x805148,%eax
  803377:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80337a:	89 50 04             	mov    %edx,0x4(%eax)
  80337d:	eb 08                	jmp    803387 <insert_sorted_with_merge_freeList+0x67e>
  80337f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803382:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803387:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80338a:	a3 48 51 80 00       	mov    %eax,0x805148
  80338f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803392:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803399:	a1 54 51 80 00       	mov    0x805154,%eax
  80339e:	40                   	inc    %eax
  80339f:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8033a4:	e9 a9 00 00 00       	jmp    803452 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8033a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033ad:	74 06                	je     8033b5 <insert_sorted_with_merge_freeList+0x6ac>
  8033af:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033b3:	75 17                	jne    8033cc <insert_sorted_with_merge_freeList+0x6c3>
  8033b5:	83 ec 04             	sub    $0x4,%esp
  8033b8:	68 fc 3f 80 00       	push   $0x803ffc
  8033bd:	68 73 01 00 00       	push   $0x173
  8033c2:	68 87 3f 80 00       	push   $0x803f87
  8033c7:	e8 89 00 00 00       	call   803455 <_panic>
  8033cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033cf:	8b 10                	mov    (%eax),%edx
  8033d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d4:	89 10                	mov    %edx,(%eax)
  8033d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d9:	8b 00                	mov    (%eax),%eax
  8033db:	85 c0                	test   %eax,%eax
  8033dd:	74 0b                	je     8033ea <insert_sorted_with_merge_freeList+0x6e1>
  8033df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e2:	8b 00                	mov    (%eax),%eax
  8033e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8033e7:	89 50 04             	mov    %edx,0x4(%eax)
  8033ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8033f0:	89 10                	mov    %edx,(%eax)
  8033f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033f8:	89 50 04             	mov    %edx,0x4(%eax)
  8033fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fe:	8b 00                	mov    (%eax),%eax
  803400:	85 c0                	test   %eax,%eax
  803402:	75 08                	jne    80340c <insert_sorted_with_merge_freeList+0x703>
  803404:	8b 45 08             	mov    0x8(%ebp),%eax
  803407:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80340c:	a1 44 51 80 00       	mov    0x805144,%eax
  803411:	40                   	inc    %eax
  803412:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803417:	eb 39                	jmp    803452 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803419:	a1 40 51 80 00       	mov    0x805140,%eax
  80341e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803421:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803425:	74 07                	je     80342e <insert_sorted_with_merge_freeList+0x725>
  803427:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80342a:	8b 00                	mov    (%eax),%eax
  80342c:	eb 05                	jmp    803433 <insert_sorted_with_merge_freeList+0x72a>
  80342e:	b8 00 00 00 00       	mov    $0x0,%eax
  803433:	a3 40 51 80 00       	mov    %eax,0x805140
  803438:	a1 40 51 80 00       	mov    0x805140,%eax
  80343d:	85 c0                	test   %eax,%eax
  80343f:	0f 85 c7 fb ff ff    	jne    80300c <insert_sorted_with_merge_freeList+0x303>
  803445:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803449:	0f 85 bd fb ff ff    	jne    80300c <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80344f:	eb 01                	jmp    803452 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803451:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803452:	90                   	nop
  803453:	c9                   	leave  
  803454:	c3                   	ret    

00803455 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803455:	55                   	push   %ebp
  803456:	89 e5                	mov    %esp,%ebp
  803458:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80345b:	8d 45 10             	lea    0x10(%ebp),%eax
  80345e:	83 c0 04             	add    $0x4,%eax
  803461:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803464:	a1 5c 51 80 00       	mov    0x80515c,%eax
  803469:	85 c0                	test   %eax,%eax
  80346b:	74 16                	je     803483 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80346d:	a1 5c 51 80 00       	mov    0x80515c,%eax
  803472:	83 ec 08             	sub    $0x8,%esp
  803475:	50                   	push   %eax
  803476:	68 50 40 80 00       	push   $0x804050
  80347b:	e8 03 d2 ff ff       	call   800683 <cprintf>
  803480:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803483:	a1 00 50 80 00       	mov    0x805000,%eax
  803488:	ff 75 0c             	pushl  0xc(%ebp)
  80348b:	ff 75 08             	pushl  0x8(%ebp)
  80348e:	50                   	push   %eax
  80348f:	68 55 40 80 00       	push   $0x804055
  803494:	e8 ea d1 ff ff       	call   800683 <cprintf>
  803499:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80349c:	8b 45 10             	mov    0x10(%ebp),%eax
  80349f:	83 ec 08             	sub    $0x8,%esp
  8034a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8034a5:	50                   	push   %eax
  8034a6:	e8 6d d1 ff ff       	call   800618 <vcprintf>
  8034ab:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8034ae:	83 ec 08             	sub    $0x8,%esp
  8034b1:	6a 00                	push   $0x0
  8034b3:	68 71 40 80 00       	push   $0x804071
  8034b8:	e8 5b d1 ff ff       	call   800618 <vcprintf>
  8034bd:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8034c0:	e8 dc d0 ff ff       	call   8005a1 <exit>

	// should not return here
	while (1) ;
  8034c5:	eb fe                	jmp    8034c5 <_panic+0x70>

008034c7 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8034c7:	55                   	push   %ebp
  8034c8:	89 e5                	mov    %esp,%ebp
  8034ca:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8034cd:	a1 20 50 80 00       	mov    0x805020,%eax
  8034d2:	8b 50 74             	mov    0x74(%eax),%edx
  8034d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034d8:	39 c2                	cmp    %eax,%edx
  8034da:	74 14                	je     8034f0 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8034dc:	83 ec 04             	sub    $0x4,%esp
  8034df:	68 74 40 80 00       	push   $0x804074
  8034e4:	6a 26                	push   $0x26
  8034e6:	68 c0 40 80 00       	push   $0x8040c0
  8034eb:	e8 65 ff ff ff       	call   803455 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8034f0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8034f7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8034fe:	e9 c2 00 00 00       	jmp    8035c5 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  803503:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803506:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80350d:	8b 45 08             	mov    0x8(%ebp),%eax
  803510:	01 d0                	add    %edx,%eax
  803512:	8b 00                	mov    (%eax),%eax
  803514:	85 c0                	test   %eax,%eax
  803516:	75 08                	jne    803520 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  803518:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80351b:	e9 a2 00 00 00       	jmp    8035c2 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  803520:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803527:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80352e:	eb 69                	jmp    803599 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803530:	a1 20 50 80 00       	mov    0x805020,%eax
  803535:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80353b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80353e:	89 d0                	mov    %edx,%eax
  803540:	01 c0                	add    %eax,%eax
  803542:	01 d0                	add    %edx,%eax
  803544:	c1 e0 03             	shl    $0x3,%eax
  803547:	01 c8                	add    %ecx,%eax
  803549:	8a 40 04             	mov    0x4(%eax),%al
  80354c:	84 c0                	test   %al,%al
  80354e:	75 46                	jne    803596 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803550:	a1 20 50 80 00       	mov    0x805020,%eax
  803555:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80355b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80355e:	89 d0                	mov    %edx,%eax
  803560:	01 c0                	add    %eax,%eax
  803562:	01 d0                	add    %edx,%eax
  803564:	c1 e0 03             	shl    $0x3,%eax
  803567:	01 c8                	add    %ecx,%eax
  803569:	8b 00                	mov    (%eax),%eax
  80356b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80356e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803571:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803576:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803578:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80357b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803582:	8b 45 08             	mov    0x8(%ebp),%eax
  803585:	01 c8                	add    %ecx,%eax
  803587:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803589:	39 c2                	cmp    %eax,%edx
  80358b:	75 09                	jne    803596 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80358d:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803594:	eb 12                	jmp    8035a8 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803596:	ff 45 e8             	incl   -0x18(%ebp)
  803599:	a1 20 50 80 00       	mov    0x805020,%eax
  80359e:	8b 50 74             	mov    0x74(%eax),%edx
  8035a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035a4:	39 c2                	cmp    %eax,%edx
  8035a6:	77 88                	ja     803530 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8035a8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8035ac:	75 14                	jne    8035c2 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8035ae:	83 ec 04             	sub    $0x4,%esp
  8035b1:	68 cc 40 80 00       	push   $0x8040cc
  8035b6:	6a 3a                	push   $0x3a
  8035b8:	68 c0 40 80 00       	push   $0x8040c0
  8035bd:	e8 93 fe ff ff       	call   803455 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8035c2:	ff 45 f0             	incl   -0x10(%ebp)
  8035c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035c8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8035cb:	0f 8c 32 ff ff ff    	jl     803503 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8035d1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8035d8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8035df:	eb 26                	jmp    803607 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8035e1:	a1 20 50 80 00       	mov    0x805020,%eax
  8035e6:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8035ec:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8035ef:	89 d0                	mov    %edx,%eax
  8035f1:	01 c0                	add    %eax,%eax
  8035f3:	01 d0                	add    %edx,%eax
  8035f5:	c1 e0 03             	shl    $0x3,%eax
  8035f8:	01 c8                	add    %ecx,%eax
  8035fa:	8a 40 04             	mov    0x4(%eax),%al
  8035fd:	3c 01                	cmp    $0x1,%al
  8035ff:	75 03                	jne    803604 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  803601:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803604:	ff 45 e0             	incl   -0x20(%ebp)
  803607:	a1 20 50 80 00       	mov    0x805020,%eax
  80360c:	8b 50 74             	mov    0x74(%eax),%edx
  80360f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803612:	39 c2                	cmp    %eax,%edx
  803614:	77 cb                	ja     8035e1 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803616:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803619:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80361c:	74 14                	je     803632 <CheckWSWithoutLastIndex+0x16b>
		panic(
  80361e:	83 ec 04             	sub    $0x4,%esp
  803621:	68 20 41 80 00       	push   $0x804120
  803626:	6a 44                	push   $0x44
  803628:	68 c0 40 80 00       	push   $0x8040c0
  80362d:	e8 23 fe ff ff       	call   803455 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803632:	90                   	nop
  803633:	c9                   	leave  
  803634:	c3                   	ret    
  803635:	66 90                	xchg   %ax,%ax
  803637:	90                   	nop

00803638 <__udivdi3>:
  803638:	55                   	push   %ebp
  803639:	57                   	push   %edi
  80363a:	56                   	push   %esi
  80363b:	53                   	push   %ebx
  80363c:	83 ec 1c             	sub    $0x1c,%esp
  80363f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803643:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803647:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80364b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80364f:	89 ca                	mov    %ecx,%edx
  803651:	89 f8                	mov    %edi,%eax
  803653:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803657:	85 f6                	test   %esi,%esi
  803659:	75 2d                	jne    803688 <__udivdi3+0x50>
  80365b:	39 cf                	cmp    %ecx,%edi
  80365d:	77 65                	ja     8036c4 <__udivdi3+0x8c>
  80365f:	89 fd                	mov    %edi,%ebp
  803661:	85 ff                	test   %edi,%edi
  803663:	75 0b                	jne    803670 <__udivdi3+0x38>
  803665:	b8 01 00 00 00       	mov    $0x1,%eax
  80366a:	31 d2                	xor    %edx,%edx
  80366c:	f7 f7                	div    %edi
  80366e:	89 c5                	mov    %eax,%ebp
  803670:	31 d2                	xor    %edx,%edx
  803672:	89 c8                	mov    %ecx,%eax
  803674:	f7 f5                	div    %ebp
  803676:	89 c1                	mov    %eax,%ecx
  803678:	89 d8                	mov    %ebx,%eax
  80367a:	f7 f5                	div    %ebp
  80367c:	89 cf                	mov    %ecx,%edi
  80367e:	89 fa                	mov    %edi,%edx
  803680:	83 c4 1c             	add    $0x1c,%esp
  803683:	5b                   	pop    %ebx
  803684:	5e                   	pop    %esi
  803685:	5f                   	pop    %edi
  803686:	5d                   	pop    %ebp
  803687:	c3                   	ret    
  803688:	39 ce                	cmp    %ecx,%esi
  80368a:	77 28                	ja     8036b4 <__udivdi3+0x7c>
  80368c:	0f bd fe             	bsr    %esi,%edi
  80368f:	83 f7 1f             	xor    $0x1f,%edi
  803692:	75 40                	jne    8036d4 <__udivdi3+0x9c>
  803694:	39 ce                	cmp    %ecx,%esi
  803696:	72 0a                	jb     8036a2 <__udivdi3+0x6a>
  803698:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80369c:	0f 87 9e 00 00 00    	ja     803740 <__udivdi3+0x108>
  8036a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8036a7:	89 fa                	mov    %edi,%edx
  8036a9:	83 c4 1c             	add    $0x1c,%esp
  8036ac:	5b                   	pop    %ebx
  8036ad:	5e                   	pop    %esi
  8036ae:	5f                   	pop    %edi
  8036af:	5d                   	pop    %ebp
  8036b0:	c3                   	ret    
  8036b1:	8d 76 00             	lea    0x0(%esi),%esi
  8036b4:	31 ff                	xor    %edi,%edi
  8036b6:	31 c0                	xor    %eax,%eax
  8036b8:	89 fa                	mov    %edi,%edx
  8036ba:	83 c4 1c             	add    $0x1c,%esp
  8036bd:	5b                   	pop    %ebx
  8036be:	5e                   	pop    %esi
  8036bf:	5f                   	pop    %edi
  8036c0:	5d                   	pop    %ebp
  8036c1:	c3                   	ret    
  8036c2:	66 90                	xchg   %ax,%ax
  8036c4:	89 d8                	mov    %ebx,%eax
  8036c6:	f7 f7                	div    %edi
  8036c8:	31 ff                	xor    %edi,%edi
  8036ca:	89 fa                	mov    %edi,%edx
  8036cc:	83 c4 1c             	add    $0x1c,%esp
  8036cf:	5b                   	pop    %ebx
  8036d0:	5e                   	pop    %esi
  8036d1:	5f                   	pop    %edi
  8036d2:	5d                   	pop    %ebp
  8036d3:	c3                   	ret    
  8036d4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8036d9:	89 eb                	mov    %ebp,%ebx
  8036db:	29 fb                	sub    %edi,%ebx
  8036dd:	89 f9                	mov    %edi,%ecx
  8036df:	d3 e6                	shl    %cl,%esi
  8036e1:	89 c5                	mov    %eax,%ebp
  8036e3:	88 d9                	mov    %bl,%cl
  8036e5:	d3 ed                	shr    %cl,%ebp
  8036e7:	89 e9                	mov    %ebp,%ecx
  8036e9:	09 f1                	or     %esi,%ecx
  8036eb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8036ef:	89 f9                	mov    %edi,%ecx
  8036f1:	d3 e0                	shl    %cl,%eax
  8036f3:	89 c5                	mov    %eax,%ebp
  8036f5:	89 d6                	mov    %edx,%esi
  8036f7:	88 d9                	mov    %bl,%cl
  8036f9:	d3 ee                	shr    %cl,%esi
  8036fb:	89 f9                	mov    %edi,%ecx
  8036fd:	d3 e2                	shl    %cl,%edx
  8036ff:	8b 44 24 08          	mov    0x8(%esp),%eax
  803703:	88 d9                	mov    %bl,%cl
  803705:	d3 e8                	shr    %cl,%eax
  803707:	09 c2                	or     %eax,%edx
  803709:	89 d0                	mov    %edx,%eax
  80370b:	89 f2                	mov    %esi,%edx
  80370d:	f7 74 24 0c          	divl   0xc(%esp)
  803711:	89 d6                	mov    %edx,%esi
  803713:	89 c3                	mov    %eax,%ebx
  803715:	f7 e5                	mul    %ebp
  803717:	39 d6                	cmp    %edx,%esi
  803719:	72 19                	jb     803734 <__udivdi3+0xfc>
  80371b:	74 0b                	je     803728 <__udivdi3+0xf0>
  80371d:	89 d8                	mov    %ebx,%eax
  80371f:	31 ff                	xor    %edi,%edi
  803721:	e9 58 ff ff ff       	jmp    80367e <__udivdi3+0x46>
  803726:	66 90                	xchg   %ax,%ax
  803728:	8b 54 24 08          	mov    0x8(%esp),%edx
  80372c:	89 f9                	mov    %edi,%ecx
  80372e:	d3 e2                	shl    %cl,%edx
  803730:	39 c2                	cmp    %eax,%edx
  803732:	73 e9                	jae    80371d <__udivdi3+0xe5>
  803734:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803737:	31 ff                	xor    %edi,%edi
  803739:	e9 40 ff ff ff       	jmp    80367e <__udivdi3+0x46>
  80373e:	66 90                	xchg   %ax,%ax
  803740:	31 c0                	xor    %eax,%eax
  803742:	e9 37 ff ff ff       	jmp    80367e <__udivdi3+0x46>
  803747:	90                   	nop

00803748 <__umoddi3>:
  803748:	55                   	push   %ebp
  803749:	57                   	push   %edi
  80374a:	56                   	push   %esi
  80374b:	53                   	push   %ebx
  80374c:	83 ec 1c             	sub    $0x1c,%esp
  80374f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803753:	8b 74 24 34          	mov    0x34(%esp),%esi
  803757:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80375b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80375f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803763:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803767:	89 f3                	mov    %esi,%ebx
  803769:	89 fa                	mov    %edi,%edx
  80376b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80376f:	89 34 24             	mov    %esi,(%esp)
  803772:	85 c0                	test   %eax,%eax
  803774:	75 1a                	jne    803790 <__umoddi3+0x48>
  803776:	39 f7                	cmp    %esi,%edi
  803778:	0f 86 a2 00 00 00    	jbe    803820 <__umoddi3+0xd8>
  80377e:	89 c8                	mov    %ecx,%eax
  803780:	89 f2                	mov    %esi,%edx
  803782:	f7 f7                	div    %edi
  803784:	89 d0                	mov    %edx,%eax
  803786:	31 d2                	xor    %edx,%edx
  803788:	83 c4 1c             	add    $0x1c,%esp
  80378b:	5b                   	pop    %ebx
  80378c:	5e                   	pop    %esi
  80378d:	5f                   	pop    %edi
  80378e:	5d                   	pop    %ebp
  80378f:	c3                   	ret    
  803790:	39 f0                	cmp    %esi,%eax
  803792:	0f 87 ac 00 00 00    	ja     803844 <__umoddi3+0xfc>
  803798:	0f bd e8             	bsr    %eax,%ebp
  80379b:	83 f5 1f             	xor    $0x1f,%ebp
  80379e:	0f 84 ac 00 00 00    	je     803850 <__umoddi3+0x108>
  8037a4:	bf 20 00 00 00       	mov    $0x20,%edi
  8037a9:	29 ef                	sub    %ebp,%edi
  8037ab:	89 fe                	mov    %edi,%esi
  8037ad:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8037b1:	89 e9                	mov    %ebp,%ecx
  8037b3:	d3 e0                	shl    %cl,%eax
  8037b5:	89 d7                	mov    %edx,%edi
  8037b7:	89 f1                	mov    %esi,%ecx
  8037b9:	d3 ef                	shr    %cl,%edi
  8037bb:	09 c7                	or     %eax,%edi
  8037bd:	89 e9                	mov    %ebp,%ecx
  8037bf:	d3 e2                	shl    %cl,%edx
  8037c1:	89 14 24             	mov    %edx,(%esp)
  8037c4:	89 d8                	mov    %ebx,%eax
  8037c6:	d3 e0                	shl    %cl,%eax
  8037c8:	89 c2                	mov    %eax,%edx
  8037ca:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037ce:	d3 e0                	shl    %cl,%eax
  8037d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8037d4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037d8:	89 f1                	mov    %esi,%ecx
  8037da:	d3 e8                	shr    %cl,%eax
  8037dc:	09 d0                	or     %edx,%eax
  8037de:	d3 eb                	shr    %cl,%ebx
  8037e0:	89 da                	mov    %ebx,%edx
  8037e2:	f7 f7                	div    %edi
  8037e4:	89 d3                	mov    %edx,%ebx
  8037e6:	f7 24 24             	mull   (%esp)
  8037e9:	89 c6                	mov    %eax,%esi
  8037eb:	89 d1                	mov    %edx,%ecx
  8037ed:	39 d3                	cmp    %edx,%ebx
  8037ef:	0f 82 87 00 00 00    	jb     80387c <__umoddi3+0x134>
  8037f5:	0f 84 91 00 00 00    	je     80388c <__umoddi3+0x144>
  8037fb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8037ff:	29 f2                	sub    %esi,%edx
  803801:	19 cb                	sbb    %ecx,%ebx
  803803:	89 d8                	mov    %ebx,%eax
  803805:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803809:	d3 e0                	shl    %cl,%eax
  80380b:	89 e9                	mov    %ebp,%ecx
  80380d:	d3 ea                	shr    %cl,%edx
  80380f:	09 d0                	or     %edx,%eax
  803811:	89 e9                	mov    %ebp,%ecx
  803813:	d3 eb                	shr    %cl,%ebx
  803815:	89 da                	mov    %ebx,%edx
  803817:	83 c4 1c             	add    $0x1c,%esp
  80381a:	5b                   	pop    %ebx
  80381b:	5e                   	pop    %esi
  80381c:	5f                   	pop    %edi
  80381d:	5d                   	pop    %ebp
  80381e:	c3                   	ret    
  80381f:	90                   	nop
  803820:	89 fd                	mov    %edi,%ebp
  803822:	85 ff                	test   %edi,%edi
  803824:	75 0b                	jne    803831 <__umoddi3+0xe9>
  803826:	b8 01 00 00 00       	mov    $0x1,%eax
  80382b:	31 d2                	xor    %edx,%edx
  80382d:	f7 f7                	div    %edi
  80382f:	89 c5                	mov    %eax,%ebp
  803831:	89 f0                	mov    %esi,%eax
  803833:	31 d2                	xor    %edx,%edx
  803835:	f7 f5                	div    %ebp
  803837:	89 c8                	mov    %ecx,%eax
  803839:	f7 f5                	div    %ebp
  80383b:	89 d0                	mov    %edx,%eax
  80383d:	e9 44 ff ff ff       	jmp    803786 <__umoddi3+0x3e>
  803842:	66 90                	xchg   %ax,%ax
  803844:	89 c8                	mov    %ecx,%eax
  803846:	89 f2                	mov    %esi,%edx
  803848:	83 c4 1c             	add    $0x1c,%esp
  80384b:	5b                   	pop    %ebx
  80384c:	5e                   	pop    %esi
  80384d:	5f                   	pop    %edi
  80384e:	5d                   	pop    %ebp
  80384f:	c3                   	ret    
  803850:	3b 04 24             	cmp    (%esp),%eax
  803853:	72 06                	jb     80385b <__umoddi3+0x113>
  803855:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803859:	77 0f                	ja     80386a <__umoddi3+0x122>
  80385b:	89 f2                	mov    %esi,%edx
  80385d:	29 f9                	sub    %edi,%ecx
  80385f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803863:	89 14 24             	mov    %edx,(%esp)
  803866:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80386a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80386e:	8b 14 24             	mov    (%esp),%edx
  803871:	83 c4 1c             	add    $0x1c,%esp
  803874:	5b                   	pop    %ebx
  803875:	5e                   	pop    %esi
  803876:	5f                   	pop    %edi
  803877:	5d                   	pop    %ebp
  803878:	c3                   	ret    
  803879:	8d 76 00             	lea    0x0(%esi),%esi
  80387c:	2b 04 24             	sub    (%esp),%eax
  80387f:	19 fa                	sbb    %edi,%edx
  803881:	89 d1                	mov    %edx,%ecx
  803883:	89 c6                	mov    %eax,%esi
  803885:	e9 71 ff ff ff       	jmp    8037fb <__umoddi3+0xb3>
  80388a:	66 90                	xchg   %ax,%ax
  80388c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803890:	72 ea                	jb     80387c <__umoddi3+0x134>
  803892:	89 d9                	mov    %ebx,%ecx
  803894:	e9 62 ff ff ff       	jmp    8037fb <__umoddi3+0xb3>
