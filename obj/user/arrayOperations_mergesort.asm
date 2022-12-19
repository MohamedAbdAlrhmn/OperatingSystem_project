
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
  80003e:	e8 de 1c 00 00       	call   801d21 <sys_getparentenvid>
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
  800057:	68 40 3a 80 00       	push   $0x803a40
  80005c:	ff 75 f0             	pushl  -0x10(%ebp)
  80005f:	e8 a0 17 00 00       	call   801804 <sget>
  800064:	83 c4 10             	add    $0x10,%esp
  800067:	89 45 e8             	mov    %eax,-0x18(%ebp)
	numOfElements = sget(parentenvID, "arrSize") ;
  80006a:	83 ec 08             	sub    $0x8,%esp
  80006d:	68 44 3a 80 00       	push   $0x803a44
  800072:	ff 75 f0             	pushl  -0x10(%ebp)
  800075:	e8 8a 17 00 00       	call   801804 <sget>
  80007a:	83 c4 10             	add    $0x10,%esp
  80007d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//PrintElements(sharedArray, *numOfElements);

	//Get the check-finishing counter
	int *finishedCount = NULL;
  800080:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	finishedCount = sget(parentenvID, "finishedCount") ;
  800087:	83 ec 08             	sub    $0x8,%esp
  80008a:	68 4c 3a 80 00       	push   $0x803a4c
  80008f:	ff 75 f0             	pushl  -0x10(%ebp)
  800092:	e8 6d 17 00 00       	call   801804 <sget>
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
  8000ab:	68 5a 3a 80 00       	push   $0x803a5a
  8000b0:	e8 a1 16 00 00       	call   801756 <smalloc>
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
  80010c:	68 69 3a 80 00       	push   $0x803a69
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
  8001a2:	68 85 3a 80 00       	push   $0x803a85
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
  8001c4:	68 87 3a 80 00       	push   $0x803a87
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
  8001f2:	68 8c 3a 80 00       	push   $0x803a8c
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
  80045a:	e8 27 12 00 00       	call   801686 <free>
  80045f:	83 c4 10             	add    $0x10,%esp
	free(Right);
  800462:	83 ec 0c             	sub    $0xc,%esp
  800465:	ff 75 d4             	pushl  -0x2c(%ebp)
  800468:	e8 19 12 00 00       	call   801686 <free>
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
  800479:	e8 8a 18 00 00       	call   801d08 <sys_getenvindex>
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
  8004e4:	e8 2c 16 00 00       	call   801b15 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8004e9:	83 ec 0c             	sub    $0xc,%esp
  8004ec:	68 a8 3a 80 00       	push   $0x803aa8
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
  800514:	68 d0 3a 80 00       	push   $0x803ad0
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
  800545:	68 f8 3a 80 00       	push   $0x803af8
  80054a:	e8 34 01 00 00       	call   800683 <cprintf>
  80054f:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800552:	a1 20 50 80 00       	mov    0x805020,%eax
  800557:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80055d:	83 ec 08             	sub    $0x8,%esp
  800560:	50                   	push   %eax
  800561:	68 50 3b 80 00       	push   $0x803b50
  800566:	e8 18 01 00 00       	call   800683 <cprintf>
  80056b:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80056e:	83 ec 0c             	sub    $0xc,%esp
  800571:	68 a8 3a 80 00       	push   $0x803aa8
  800576:	e8 08 01 00 00       	call   800683 <cprintf>
  80057b:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80057e:	e8 ac 15 00 00       	call   801b2f <sys_enable_interrupt>

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
  800596:	e8 39 17 00 00       	call   801cd4 <sys_destroy_env>
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
  8005a7:	e8 8e 17 00 00       	call   801d3a <sys_exit_env>
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
  8005f5:	e8 6d 13 00 00       	call   801967 <sys_cputs>
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
  80066c:	e8 f6 12 00 00       	call   801967 <sys_cputs>
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
  8006b6:	e8 5a 14 00 00       	call   801b15 <sys_disable_interrupt>
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
  8006d6:	e8 54 14 00 00       	call   801b2f <sys_enable_interrupt>
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
  800720:	e8 a7 30 00 00       	call   8037cc <__udivdi3>
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
  800770:	e8 67 31 00 00       	call   8038dc <__umoddi3>
  800775:	83 c4 10             	add    $0x10,%esp
  800778:	05 94 3d 80 00       	add    $0x803d94,%eax
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
  8008cb:	8b 04 85 b8 3d 80 00 	mov    0x803db8(,%eax,4),%eax
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
  8009ac:	8b 34 9d 00 3c 80 00 	mov    0x803c00(,%ebx,4),%esi
  8009b3:	85 f6                	test   %esi,%esi
  8009b5:	75 19                	jne    8009d0 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009b7:	53                   	push   %ebx
  8009b8:	68 a5 3d 80 00       	push   $0x803da5
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
  8009d1:	68 ae 3d 80 00       	push   $0x803dae
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
  8009fe:	be b1 3d 80 00       	mov    $0x803db1,%esi
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
  801424:	68 10 3f 80 00       	push   $0x803f10
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
  8014f4:	e8 b2 05 00 00       	call   801aab <sys_allocate_chunk>
  8014f9:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8014fc:	a1 20 51 80 00       	mov    0x805120,%eax
  801501:	83 ec 0c             	sub    $0xc,%esp
  801504:	50                   	push   %eax
  801505:	e8 27 0c 00 00       	call   802131 <initialize_MemBlocksList>
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
  801532:	68 35 3f 80 00       	push   $0x803f35
  801537:	6a 33                	push   $0x33
  801539:	68 53 3f 80 00       	push   $0x803f53
  80153e:	e8 a7 20 00 00       	call   8035ea <_panic>
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
  8015b1:	68 60 3f 80 00       	push   $0x803f60
  8015b6:	6a 34                	push   $0x34
  8015b8:	68 53 3f 80 00       	push   $0x803f53
  8015bd:	e8 28 20 00 00       	call   8035ea <_panic>
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
  80160e:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801611:	e8 f7 fd ff ff       	call   80140d <InitializeUHeap>
	if (size == 0) return NULL ;
  801616:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80161a:	75 07                	jne    801623 <malloc+0x18>
  80161c:	b8 00 00 00 00       	mov    $0x0,%eax
  801621:	eb 61                	jmp    801684 <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  801623:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80162a:	8b 55 08             	mov    0x8(%ebp),%edx
  80162d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801630:	01 d0                	add    %edx,%eax
  801632:	48                   	dec    %eax
  801633:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801636:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801639:	ba 00 00 00 00       	mov    $0x0,%edx
  80163e:	f7 75 f0             	divl   -0x10(%ebp)
  801641:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801644:	29 d0                	sub    %edx,%eax
  801646:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801649:	e8 2b 08 00 00       	call   801e79 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80164e:	85 c0                	test   %eax,%eax
  801650:	74 11                	je     801663 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801652:	83 ec 0c             	sub    $0xc,%esp
  801655:	ff 75 e8             	pushl  -0x18(%ebp)
  801658:	e8 96 0e 00 00       	call   8024f3 <alloc_block_FF>
  80165d:	83 c4 10             	add    $0x10,%esp
  801660:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  801663:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801667:	74 16                	je     80167f <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  801669:	83 ec 0c             	sub    $0xc,%esp
  80166c:	ff 75 f4             	pushl  -0xc(%ebp)
  80166f:	e8 f2 0b 00 00       	call   802266 <insert_sorted_allocList>
  801674:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  801677:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80167a:	8b 40 08             	mov    0x8(%eax),%eax
  80167d:	eb 05                	jmp    801684 <malloc+0x79>
	}

    return NULL;
  80167f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801684:	c9                   	leave  
  801685:	c3                   	ret    

00801686 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801686:	55                   	push   %ebp
  801687:	89 e5                	mov    %esp,%ebp
  801689:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  80168c:	8b 45 08             	mov    0x8(%ebp),%eax
  80168f:	83 ec 08             	sub    $0x8,%esp
  801692:	50                   	push   %eax
  801693:	68 40 50 80 00       	push   $0x805040
  801698:	e8 71 0b 00 00       	call   80220e <find_block>
  80169d:	83 c4 10             	add    $0x10,%esp
  8016a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(free_block!=NULL)
  8016a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016a7:	0f 84 a6 00 00 00    	je     801753 <free+0xcd>
	{
		sys_free_user_mem(free_block->sva,free_block->size);
  8016ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016b0:	8b 50 0c             	mov    0xc(%eax),%edx
  8016b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016b6:	8b 40 08             	mov    0x8(%eax),%eax
  8016b9:	83 ec 08             	sub    $0x8,%esp
  8016bc:	52                   	push   %edx
  8016bd:	50                   	push   %eax
  8016be:	e8 b0 03 00 00       	call   801a73 <sys_free_user_mem>
  8016c3:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,free_block);
  8016c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016ca:	75 14                	jne    8016e0 <free+0x5a>
  8016cc:	83 ec 04             	sub    $0x4,%esp
  8016cf:	68 35 3f 80 00       	push   $0x803f35
  8016d4:	6a 74                	push   $0x74
  8016d6:	68 53 3f 80 00       	push   $0x803f53
  8016db:	e8 0a 1f 00 00       	call   8035ea <_panic>
  8016e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e3:	8b 00                	mov    (%eax),%eax
  8016e5:	85 c0                	test   %eax,%eax
  8016e7:	74 10                	je     8016f9 <free+0x73>
  8016e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016ec:	8b 00                	mov    (%eax),%eax
  8016ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016f1:	8b 52 04             	mov    0x4(%edx),%edx
  8016f4:	89 50 04             	mov    %edx,0x4(%eax)
  8016f7:	eb 0b                	jmp    801704 <free+0x7e>
  8016f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016fc:	8b 40 04             	mov    0x4(%eax),%eax
  8016ff:	a3 44 50 80 00       	mov    %eax,0x805044
  801704:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801707:	8b 40 04             	mov    0x4(%eax),%eax
  80170a:	85 c0                	test   %eax,%eax
  80170c:	74 0f                	je     80171d <free+0x97>
  80170e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801711:	8b 40 04             	mov    0x4(%eax),%eax
  801714:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801717:	8b 12                	mov    (%edx),%edx
  801719:	89 10                	mov    %edx,(%eax)
  80171b:	eb 0a                	jmp    801727 <free+0xa1>
  80171d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801720:	8b 00                	mov    (%eax),%eax
  801722:	a3 40 50 80 00       	mov    %eax,0x805040
  801727:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80172a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801730:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801733:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80173a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80173f:	48                   	dec    %eax
  801740:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(free_block);
  801745:	83 ec 0c             	sub    $0xc,%esp
  801748:	ff 75 f4             	pushl  -0xc(%ebp)
  80174b:	e8 4e 17 00 00       	call   802e9e <insert_sorted_with_merge_freeList>
  801750:	83 c4 10             	add    $0x10,%esp
	}

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801753:	90                   	nop
  801754:	c9                   	leave  
  801755:	c3                   	ret    

00801756 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801756:	55                   	push   %ebp
  801757:	89 e5                	mov    %esp,%ebp
  801759:	83 ec 38             	sub    $0x38,%esp
  80175c:	8b 45 10             	mov    0x10(%ebp),%eax
  80175f:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801762:	e8 a6 fc ff ff       	call   80140d <InitializeUHeap>
	if (size == 0) return NULL ;
  801767:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80176b:	75 0a                	jne    801777 <smalloc+0x21>
  80176d:	b8 00 00 00 00       	mov    $0x0,%eax
  801772:	e9 8b 00 00 00       	jmp    801802 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801777:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80177e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801781:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801784:	01 d0                	add    %edx,%eax
  801786:	48                   	dec    %eax
  801787:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80178a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80178d:	ba 00 00 00 00       	mov    $0x0,%edx
  801792:	f7 75 f0             	divl   -0x10(%ebp)
  801795:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801798:	29 d0                	sub    %edx,%eax
  80179a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  80179d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8017a4:	e8 d0 06 00 00       	call   801e79 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017a9:	85 c0                	test   %eax,%eax
  8017ab:	74 11                	je     8017be <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  8017ad:	83 ec 0c             	sub    $0xc,%esp
  8017b0:	ff 75 e8             	pushl  -0x18(%ebp)
  8017b3:	e8 3b 0d 00 00       	call   8024f3 <alloc_block_FF>
  8017b8:	83 c4 10             	add    $0x10,%esp
  8017bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  8017be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017c2:	74 39                	je     8017fd <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8017c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017c7:	8b 40 08             	mov    0x8(%eax),%eax
  8017ca:	89 c2                	mov    %eax,%edx
  8017cc:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8017d0:	52                   	push   %edx
  8017d1:	50                   	push   %eax
  8017d2:	ff 75 0c             	pushl  0xc(%ebp)
  8017d5:	ff 75 08             	pushl  0x8(%ebp)
  8017d8:	e8 21 04 00 00       	call   801bfe <sys_createSharedObject>
  8017dd:	83 c4 10             	add    $0x10,%esp
  8017e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  8017e3:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8017e7:	74 14                	je     8017fd <smalloc+0xa7>
  8017e9:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8017ed:	74 0e                	je     8017fd <smalloc+0xa7>
  8017ef:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  8017f3:	74 08                	je     8017fd <smalloc+0xa7>
			return (void*) mem_block->sva;
  8017f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017f8:	8b 40 08             	mov    0x8(%eax),%eax
  8017fb:	eb 05                	jmp    801802 <smalloc+0xac>
	}
	return NULL;
  8017fd:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801802:	c9                   	leave  
  801803:	c3                   	ret    

00801804 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801804:	55                   	push   %ebp
  801805:	89 e5                	mov    %esp,%ebp
  801807:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80180a:	e8 fe fb ff ff       	call   80140d <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80180f:	83 ec 08             	sub    $0x8,%esp
  801812:	ff 75 0c             	pushl  0xc(%ebp)
  801815:	ff 75 08             	pushl  0x8(%ebp)
  801818:	e8 0b 04 00 00       	call   801c28 <sys_getSizeOfSharedObject>
  80181d:	83 c4 10             	add    $0x10,%esp
  801820:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  801823:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  801827:	74 76                	je     80189f <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801829:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801830:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801833:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801836:	01 d0                	add    %edx,%eax
  801838:	48                   	dec    %eax
  801839:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80183c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80183f:	ba 00 00 00 00       	mov    $0x0,%edx
  801844:	f7 75 ec             	divl   -0x14(%ebp)
  801847:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80184a:	29 d0                	sub    %edx,%eax
  80184c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  80184f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801856:	e8 1e 06 00 00       	call   801e79 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80185b:	85 c0                	test   %eax,%eax
  80185d:	74 11                	je     801870 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  80185f:	83 ec 0c             	sub    $0xc,%esp
  801862:	ff 75 e4             	pushl  -0x1c(%ebp)
  801865:	e8 89 0c 00 00       	call   8024f3 <alloc_block_FF>
  80186a:	83 c4 10             	add    $0x10,%esp
  80186d:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  801870:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801874:	74 29                	je     80189f <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801876:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801879:	8b 40 08             	mov    0x8(%eax),%eax
  80187c:	83 ec 04             	sub    $0x4,%esp
  80187f:	50                   	push   %eax
  801880:	ff 75 0c             	pushl  0xc(%ebp)
  801883:	ff 75 08             	pushl  0x8(%ebp)
  801886:	e8 ba 03 00 00       	call   801c45 <sys_getSharedObject>
  80188b:	83 c4 10             	add    $0x10,%esp
  80188e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  801891:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  801895:	74 08                	je     80189f <sget+0x9b>
				return (void *)mem_block->sva;
  801897:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80189a:	8b 40 08             	mov    0x8(%eax),%eax
  80189d:	eb 05                	jmp    8018a4 <sget+0xa0>
		}
	}
	return NULL;
  80189f:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8018a4:	c9                   	leave  
  8018a5:	c3                   	ret    

008018a6 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8018a6:	55                   	push   %ebp
  8018a7:	89 e5                	mov    %esp,%ebp
  8018a9:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018ac:	e8 5c fb ff ff       	call   80140d <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8018b1:	83 ec 04             	sub    $0x4,%esp
  8018b4:	68 84 3f 80 00       	push   $0x803f84
  8018b9:	68 f7 00 00 00       	push   $0xf7
  8018be:	68 53 3f 80 00       	push   $0x803f53
  8018c3:	e8 22 1d 00 00       	call   8035ea <_panic>

008018c8 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8018c8:	55                   	push   %ebp
  8018c9:	89 e5                	mov    %esp,%ebp
  8018cb:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8018ce:	83 ec 04             	sub    $0x4,%esp
  8018d1:	68 ac 3f 80 00       	push   $0x803fac
  8018d6:	68 0b 01 00 00       	push   $0x10b
  8018db:	68 53 3f 80 00       	push   $0x803f53
  8018e0:	e8 05 1d 00 00       	call   8035ea <_panic>

008018e5 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8018e5:	55                   	push   %ebp
  8018e6:	89 e5                	mov    %esp,%ebp
  8018e8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018eb:	83 ec 04             	sub    $0x4,%esp
  8018ee:	68 d0 3f 80 00       	push   $0x803fd0
  8018f3:	68 16 01 00 00       	push   $0x116
  8018f8:	68 53 3f 80 00       	push   $0x803f53
  8018fd:	e8 e8 1c 00 00       	call   8035ea <_panic>

00801902 <shrink>:

}
void shrink(uint32 newSize)
{
  801902:	55                   	push   %ebp
  801903:	89 e5                	mov    %esp,%ebp
  801905:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801908:	83 ec 04             	sub    $0x4,%esp
  80190b:	68 d0 3f 80 00       	push   $0x803fd0
  801910:	68 1b 01 00 00       	push   $0x11b
  801915:	68 53 3f 80 00       	push   $0x803f53
  80191a:	e8 cb 1c 00 00       	call   8035ea <_panic>

0080191f <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80191f:	55                   	push   %ebp
  801920:	89 e5                	mov    %esp,%ebp
  801922:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801925:	83 ec 04             	sub    $0x4,%esp
  801928:	68 d0 3f 80 00       	push   $0x803fd0
  80192d:	68 20 01 00 00       	push   $0x120
  801932:	68 53 3f 80 00       	push   $0x803f53
  801937:	e8 ae 1c 00 00       	call   8035ea <_panic>

0080193c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80193c:	55                   	push   %ebp
  80193d:	89 e5                	mov    %esp,%ebp
  80193f:	57                   	push   %edi
  801940:	56                   	push   %esi
  801941:	53                   	push   %ebx
  801942:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801945:	8b 45 08             	mov    0x8(%ebp),%eax
  801948:	8b 55 0c             	mov    0xc(%ebp),%edx
  80194b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80194e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801951:	8b 7d 18             	mov    0x18(%ebp),%edi
  801954:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801957:	cd 30                	int    $0x30
  801959:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80195c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80195f:	83 c4 10             	add    $0x10,%esp
  801962:	5b                   	pop    %ebx
  801963:	5e                   	pop    %esi
  801964:	5f                   	pop    %edi
  801965:	5d                   	pop    %ebp
  801966:	c3                   	ret    

00801967 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801967:	55                   	push   %ebp
  801968:	89 e5                	mov    %esp,%ebp
  80196a:	83 ec 04             	sub    $0x4,%esp
  80196d:	8b 45 10             	mov    0x10(%ebp),%eax
  801970:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801973:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801977:	8b 45 08             	mov    0x8(%ebp),%eax
  80197a:	6a 00                	push   $0x0
  80197c:	6a 00                	push   $0x0
  80197e:	52                   	push   %edx
  80197f:	ff 75 0c             	pushl  0xc(%ebp)
  801982:	50                   	push   %eax
  801983:	6a 00                	push   $0x0
  801985:	e8 b2 ff ff ff       	call   80193c <syscall>
  80198a:	83 c4 18             	add    $0x18,%esp
}
  80198d:	90                   	nop
  80198e:	c9                   	leave  
  80198f:	c3                   	ret    

00801990 <sys_cgetc>:

int
sys_cgetc(void)
{
  801990:	55                   	push   %ebp
  801991:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 01                	push   $0x1
  80199f:	e8 98 ff ff ff       	call   80193c <syscall>
  8019a4:	83 c4 18             	add    $0x18,%esp
}
  8019a7:	c9                   	leave  
  8019a8:	c3                   	ret    

008019a9 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8019a9:	55                   	push   %ebp
  8019aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8019ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019af:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	52                   	push   %edx
  8019b9:	50                   	push   %eax
  8019ba:	6a 05                	push   $0x5
  8019bc:	e8 7b ff ff ff       	call   80193c <syscall>
  8019c1:	83 c4 18             	add    $0x18,%esp
}
  8019c4:	c9                   	leave  
  8019c5:	c3                   	ret    

008019c6 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8019c6:	55                   	push   %ebp
  8019c7:	89 e5                	mov    %esp,%ebp
  8019c9:	56                   	push   %esi
  8019ca:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8019cb:	8b 75 18             	mov    0x18(%ebp),%esi
  8019ce:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019d1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019da:	56                   	push   %esi
  8019db:	53                   	push   %ebx
  8019dc:	51                   	push   %ecx
  8019dd:	52                   	push   %edx
  8019de:	50                   	push   %eax
  8019df:	6a 06                	push   $0x6
  8019e1:	e8 56 ff ff ff       	call   80193c <syscall>
  8019e6:	83 c4 18             	add    $0x18,%esp
}
  8019e9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019ec:	5b                   	pop    %ebx
  8019ed:	5e                   	pop    %esi
  8019ee:	5d                   	pop    %ebp
  8019ef:	c3                   	ret    

008019f0 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8019f0:	55                   	push   %ebp
  8019f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8019f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	52                   	push   %edx
  801a00:	50                   	push   %eax
  801a01:	6a 07                	push   $0x7
  801a03:	e8 34 ff ff ff       	call   80193c <syscall>
  801a08:	83 c4 18             	add    $0x18,%esp
}
  801a0b:	c9                   	leave  
  801a0c:	c3                   	ret    

00801a0d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a0d:	55                   	push   %ebp
  801a0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	ff 75 0c             	pushl  0xc(%ebp)
  801a19:	ff 75 08             	pushl  0x8(%ebp)
  801a1c:	6a 08                	push   $0x8
  801a1e:	e8 19 ff ff ff       	call   80193c <syscall>
  801a23:	83 c4 18             	add    $0x18,%esp
}
  801a26:	c9                   	leave  
  801a27:	c3                   	ret    

00801a28 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a28:	55                   	push   %ebp
  801a29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 09                	push   $0x9
  801a37:	e8 00 ff ff ff       	call   80193c <syscall>
  801a3c:	83 c4 18             	add    $0x18,%esp
}
  801a3f:	c9                   	leave  
  801a40:	c3                   	ret    

00801a41 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a41:	55                   	push   %ebp
  801a42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 0a                	push   $0xa
  801a50:	e8 e7 fe ff ff       	call   80193c <syscall>
  801a55:	83 c4 18             	add    $0x18,%esp
}
  801a58:	c9                   	leave  
  801a59:	c3                   	ret    

00801a5a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a5a:	55                   	push   %ebp
  801a5b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	6a 0b                	push   $0xb
  801a69:	e8 ce fe ff ff       	call   80193c <syscall>
  801a6e:	83 c4 18             	add    $0x18,%esp
}
  801a71:	c9                   	leave  
  801a72:	c3                   	ret    

00801a73 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a73:	55                   	push   %ebp
  801a74:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	ff 75 0c             	pushl  0xc(%ebp)
  801a7f:	ff 75 08             	pushl  0x8(%ebp)
  801a82:	6a 0f                	push   $0xf
  801a84:	e8 b3 fe ff ff       	call   80193c <syscall>
  801a89:	83 c4 18             	add    $0x18,%esp
	return;
  801a8c:	90                   	nop
}
  801a8d:	c9                   	leave  
  801a8e:	c3                   	ret    

00801a8f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a8f:	55                   	push   %ebp
  801a90:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	ff 75 0c             	pushl  0xc(%ebp)
  801a9b:	ff 75 08             	pushl  0x8(%ebp)
  801a9e:	6a 10                	push   $0x10
  801aa0:	e8 97 fe ff ff       	call   80193c <syscall>
  801aa5:	83 c4 18             	add    $0x18,%esp
	return ;
  801aa8:	90                   	nop
}
  801aa9:	c9                   	leave  
  801aaa:	c3                   	ret    

00801aab <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801aab:	55                   	push   %ebp
  801aac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	ff 75 10             	pushl  0x10(%ebp)
  801ab5:	ff 75 0c             	pushl  0xc(%ebp)
  801ab8:	ff 75 08             	pushl  0x8(%ebp)
  801abb:	6a 11                	push   $0x11
  801abd:	e8 7a fe ff ff       	call   80193c <syscall>
  801ac2:	83 c4 18             	add    $0x18,%esp
	return ;
  801ac5:	90                   	nop
}
  801ac6:	c9                   	leave  
  801ac7:	c3                   	ret    

00801ac8 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801ac8:	55                   	push   %ebp
  801ac9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 0c                	push   $0xc
  801ad7:	e8 60 fe ff ff       	call   80193c <syscall>
  801adc:	83 c4 18             	add    $0x18,%esp
}
  801adf:	c9                   	leave  
  801ae0:	c3                   	ret    

00801ae1 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ae1:	55                   	push   %ebp
  801ae2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	ff 75 08             	pushl  0x8(%ebp)
  801aef:	6a 0d                	push   $0xd
  801af1:	e8 46 fe ff ff       	call   80193c <syscall>
  801af6:	83 c4 18             	add    $0x18,%esp
}
  801af9:	c9                   	leave  
  801afa:	c3                   	ret    

00801afb <sys_scarce_memory>:

void sys_scarce_memory()
{
  801afb:	55                   	push   %ebp
  801afc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	6a 0e                	push   $0xe
  801b0a:	e8 2d fe ff ff       	call   80193c <syscall>
  801b0f:	83 c4 18             	add    $0x18,%esp
}
  801b12:	90                   	nop
  801b13:	c9                   	leave  
  801b14:	c3                   	ret    

00801b15 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801b15:	55                   	push   %ebp
  801b16:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 13                	push   $0x13
  801b24:	e8 13 fe ff ff       	call   80193c <syscall>
  801b29:	83 c4 18             	add    $0x18,%esp
}
  801b2c:	90                   	nop
  801b2d:	c9                   	leave  
  801b2e:	c3                   	ret    

00801b2f <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801b2f:	55                   	push   %ebp
  801b30:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 14                	push   $0x14
  801b3e:	e8 f9 fd ff ff       	call   80193c <syscall>
  801b43:	83 c4 18             	add    $0x18,%esp
}
  801b46:	90                   	nop
  801b47:	c9                   	leave  
  801b48:	c3                   	ret    

00801b49 <sys_cputc>:


void
sys_cputc(const char c)
{
  801b49:	55                   	push   %ebp
  801b4a:	89 e5                	mov    %esp,%ebp
  801b4c:	83 ec 04             	sub    $0x4,%esp
  801b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b52:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b55:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	50                   	push   %eax
  801b62:	6a 15                	push   $0x15
  801b64:	e8 d3 fd ff ff       	call   80193c <syscall>
  801b69:	83 c4 18             	add    $0x18,%esp
}
  801b6c:	90                   	nop
  801b6d:	c9                   	leave  
  801b6e:	c3                   	ret    

00801b6f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b6f:	55                   	push   %ebp
  801b70:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 16                	push   $0x16
  801b7e:	e8 b9 fd ff ff       	call   80193c <syscall>
  801b83:	83 c4 18             	add    $0x18,%esp
}
  801b86:	90                   	nop
  801b87:	c9                   	leave  
  801b88:	c3                   	ret    

00801b89 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b89:	55                   	push   %ebp
  801b8a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	ff 75 0c             	pushl  0xc(%ebp)
  801b98:	50                   	push   %eax
  801b99:	6a 17                	push   $0x17
  801b9b:	e8 9c fd ff ff       	call   80193c <syscall>
  801ba0:	83 c4 18             	add    $0x18,%esp
}
  801ba3:	c9                   	leave  
  801ba4:	c3                   	ret    

00801ba5 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801ba5:	55                   	push   %ebp
  801ba6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ba8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bab:	8b 45 08             	mov    0x8(%ebp),%eax
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	52                   	push   %edx
  801bb5:	50                   	push   %eax
  801bb6:	6a 1a                	push   $0x1a
  801bb8:	e8 7f fd ff ff       	call   80193c <syscall>
  801bbd:	83 c4 18             	add    $0x18,%esp
}
  801bc0:	c9                   	leave  
  801bc1:	c3                   	ret    

00801bc2 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801bc2:	55                   	push   %ebp
  801bc3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bc5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	52                   	push   %edx
  801bd2:	50                   	push   %eax
  801bd3:	6a 18                	push   $0x18
  801bd5:	e8 62 fd ff ff       	call   80193c <syscall>
  801bda:	83 c4 18             	add    $0x18,%esp
}
  801bdd:	90                   	nop
  801bde:	c9                   	leave  
  801bdf:	c3                   	ret    

00801be0 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801be3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be6:	8b 45 08             	mov    0x8(%ebp),%eax
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	52                   	push   %edx
  801bf0:	50                   	push   %eax
  801bf1:	6a 19                	push   $0x19
  801bf3:	e8 44 fd ff ff       	call   80193c <syscall>
  801bf8:	83 c4 18             	add    $0x18,%esp
}
  801bfb:	90                   	nop
  801bfc:	c9                   	leave  
  801bfd:	c3                   	ret    

00801bfe <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
  801c01:	83 ec 04             	sub    $0x4,%esp
  801c04:	8b 45 10             	mov    0x10(%ebp),%eax
  801c07:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c0a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c0d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c11:	8b 45 08             	mov    0x8(%ebp),%eax
  801c14:	6a 00                	push   $0x0
  801c16:	51                   	push   %ecx
  801c17:	52                   	push   %edx
  801c18:	ff 75 0c             	pushl  0xc(%ebp)
  801c1b:	50                   	push   %eax
  801c1c:	6a 1b                	push   $0x1b
  801c1e:	e8 19 fd ff ff       	call   80193c <syscall>
  801c23:	83 c4 18             	add    $0x18,%esp
}
  801c26:	c9                   	leave  
  801c27:	c3                   	ret    

00801c28 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c28:	55                   	push   %ebp
  801c29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	52                   	push   %edx
  801c38:	50                   	push   %eax
  801c39:	6a 1c                	push   $0x1c
  801c3b:	e8 fc fc ff ff       	call   80193c <syscall>
  801c40:	83 c4 18             	add    $0x18,%esp
}
  801c43:	c9                   	leave  
  801c44:	c3                   	ret    

00801c45 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c45:	55                   	push   %ebp
  801c46:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c48:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	51                   	push   %ecx
  801c56:	52                   	push   %edx
  801c57:	50                   	push   %eax
  801c58:	6a 1d                	push   $0x1d
  801c5a:	e8 dd fc ff ff       	call   80193c <syscall>
  801c5f:	83 c4 18             	add    $0x18,%esp
}
  801c62:	c9                   	leave  
  801c63:	c3                   	ret    

00801c64 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c64:	55                   	push   %ebp
  801c65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c67:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	52                   	push   %edx
  801c74:	50                   	push   %eax
  801c75:	6a 1e                	push   $0x1e
  801c77:	e8 c0 fc ff ff       	call   80193c <syscall>
  801c7c:	83 c4 18             	add    $0x18,%esp
}
  801c7f:	c9                   	leave  
  801c80:	c3                   	ret    

00801c81 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c81:	55                   	push   %ebp
  801c82:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c84:	6a 00                	push   $0x0
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 1f                	push   $0x1f
  801c90:	e8 a7 fc ff ff       	call   80193c <syscall>
  801c95:	83 c4 18             	add    $0x18,%esp
}
  801c98:	c9                   	leave  
  801c99:	c3                   	ret    

00801c9a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c9a:	55                   	push   %ebp
  801c9b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca0:	6a 00                	push   $0x0
  801ca2:	ff 75 14             	pushl  0x14(%ebp)
  801ca5:	ff 75 10             	pushl  0x10(%ebp)
  801ca8:	ff 75 0c             	pushl  0xc(%ebp)
  801cab:	50                   	push   %eax
  801cac:	6a 20                	push   $0x20
  801cae:	e8 89 fc ff ff       	call   80193c <syscall>
  801cb3:	83 c4 18             	add    $0x18,%esp
}
  801cb6:	c9                   	leave  
  801cb7:	c3                   	ret    

00801cb8 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801cb8:	55                   	push   %ebp
  801cb9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	50                   	push   %eax
  801cc7:	6a 21                	push   $0x21
  801cc9:	e8 6e fc ff ff       	call   80193c <syscall>
  801cce:	83 c4 18             	add    $0x18,%esp
}
  801cd1:	90                   	nop
  801cd2:	c9                   	leave  
  801cd3:	c3                   	ret    

00801cd4 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801cd4:	55                   	push   %ebp
  801cd5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 00                	push   $0x0
  801ce2:	50                   	push   %eax
  801ce3:	6a 22                	push   $0x22
  801ce5:	e8 52 fc ff ff       	call   80193c <syscall>
  801cea:	83 c4 18             	add    $0x18,%esp
}
  801ced:	c9                   	leave  
  801cee:	c3                   	ret    

00801cef <sys_getenvid>:

int32 sys_getenvid(void)
{
  801cef:	55                   	push   %ebp
  801cf0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 02                	push   $0x2
  801cfe:	e8 39 fc ff ff       	call   80193c <syscall>
  801d03:	83 c4 18             	add    $0x18,%esp
}
  801d06:	c9                   	leave  
  801d07:	c3                   	ret    

00801d08 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d08:	55                   	push   %ebp
  801d09:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	6a 03                	push   $0x3
  801d17:	e8 20 fc ff ff       	call   80193c <syscall>
  801d1c:	83 c4 18             	add    $0x18,%esp
}
  801d1f:	c9                   	leave  
  801d20:	c3                   	ret    

00801d21 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d21:	55                   	push   %ebp
  801d22:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 04                	push   $0x4
  801d30:	e8 07 fc ff ff       	call   80193c <syscall>
  801d35:	83 c4 18             	add    $0x18,%esp
}
  801d38:	c9                   	leave  
  801d39:	c3                   	ret    

00801d3a <sys_exit_env>:


void sys_exit_env(void)
{
  801d3a:	55                   	push   %ebp
  801d3b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 23                	push   $0x23
  801d49:	e8 ee fb ff ff       	call   80193c <syscall>
  801d4e:	83 c4 18             	add    $0x18,%esp
}
  801d51:	90                   	nop
  801d52:	c9                   	leave  
  801d53:	c3                   	ret    

00801d54 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801d54:	55                   	push   %ebp
  801d55:	89 e5                	mov    %esp,%ebp
  801d57:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d5a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d5d:	8d 50 04             	lea    0x4(%eax),%edx
  801d60:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d63:	6a 00                	push   $0x0
  801d65:	6a 00                	push   $0x0
  801d67:	6a 00                	push   $0x0
  801d69:	52                   	push   %edx
  801d6a:	50                   	push   %eax
  801d6b:	6a 24                	push   $0x24
  801d6d:	e8 ca fb ff ff       	call   80193c <syscall>
  801d72:	83 c4 18             	add    $0x18,%esp
	return result;
  801d75:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d78:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d7b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d7e:	89 01                	mov    %eax,(%ecx)
  801d80:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d83:	8b 45 08             	mov    0x8(%ebp),%eax
  801d86:	c9                   	leave  
  801d87:	c2 04 00             	ret    $0x4

00801d8a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d8a:	55                   	push   %ebp
  801d8b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 00                	push   $0x0
  801d91:	ff 75 10             	pushl  0x10(%ebp)
  801d94:	ff 75 0c             	pushl  0xc(%ebp)
  801d97:	ff 75 08             	pushl  0x8(%ebp)
  801d9a:	6a 12                	push   $0x12
  801d9c:	e8 9b fb ff ff       	call   80193c <syscall>
  801da1:	83 c4 18             	add    $0x18,%esp
	return ;
  801da4:	90                   	nop
}
  801da5:	c9                   	leave  
  801da6:	c3                   	ret    

00801da7 <sys_rcr2>:
uint32 sys_rcr2()
{
  801da7:	55                   	push   %ebp
  801da8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 00                	push   $0x0
  801db4:	6a 25                	push   $0x25
  801db6:	e8 81 fb ff ff       	call   80193c <syscall>
  801dbb:	83 c4 18             	add    $0x18,%esp
}
  801dbe:	c9                   	leave  
  801dbf:	c3                   	ret    

00801dc0 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801dc0:	55                   	push   %ebp
  801dc1:	89 e5                	mov    %esp,%ebp
  801dc3:	83 ec 04             	sub    $0x4,%esp
  801dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801dcc:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	50                   	push   %eax
  801dd9:	6a 26                	push   $0x26
  801ddb:	e8 5c fb ff ff       	call   80193c <syscall>
  801de0:	83 c4 18             	add    $0x18,%esp
	return ;
  801de3:	90                   	nop
}
  801de4:	c9                   	leave  
  801de5:	c3                   	ret    

00801de6 <rsttst>:
void rsttst()
{
  801de6:	55                   	push   %ebp
  801de7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801de9:	6a 00                	push   $0x0
  801deb:	6a 00                	push   $0x0
  801ded:	6a 00                	push   $0x0
  801def:	6a 00                	push   $0x0
  801df1:	6a 00                	push   $0x0
  801df3:	6a 28                	push   $0x28
  801df5:	e8 42 fb ff ff       	call   80193c <syscall>
  801dfa:	83 c4 18             	add    $0x18,%esp
	return ;
  801dfd:	90                   	nop
}
  801dfe:	c9                   	leave  
  801dff:	c3                   	ret    

00801e00 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e00:	55                   	push   %ebp
  801e01:	89 e5                	mov    %esp,%ebp
  801e03:	83 ec 04             	sub    $0x4,%esp
  801e06:	8b 45 14             	mov    0x14(%ebp),%eax
  801e09:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e0c:	8b 55 18             	mov    0x18(%ebp),%edx
  801e0f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e13:	52                   	push   %edx
  801e14:	50                   	push   %eax
  801e15:	ff 75 10             	pushl  0x10(%ebp)
  801e18:	ff 75 0c             	pushl  0xc(%ebp)
  801e1b:	ff 75 08             	pushl  0x8(%ebp)
  801e1e:	6a 27                	push   $0x27
  801e20:	e8 17 fb ff ff       	call   80193c <syscall>
  801e25:	83 c4 18             	add    $0x18,%esp
	return ;
  801e28:	90                   	nop
}
  801e29:	c9                   	leave  
  801e2a:	c3                   	ret    

00801e2b <chktst>:
void chktst(uint32 n)
{
  801e2b:	55                   	push   %ebp
  801e2c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 00                	push   $0x0
  801e32:	6a 00                	push   $0x0
  801e34:	6a 00                	push   $0x0
  801e36:	ff 75 08             	pushl  0x8(%ebp)
  801e39:	6a 29                	push   $0x29
  801e3b:	e8 fc fa ff ff       	call   80193c <syscall>
  801e40:	83 c4 18             	add    $0x18,%esp
	return ;
  801e43:	90                   	nop
}
  801e44:	c9                   	leave  
  801e45:	c3                   	ret    

00801e46 <inctst>:

void inctst()
{
  801e46:	55                   	push   %ebp
  801e47:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e49:	6a 00                	push   $0x0
  801e4b:	6a 00                	push   $0x0
  801e4d:	6a 00                	push   $0x0
  801e4f:	6a 00                	push   $0x0
  801e51:	6a 00                	push   $0x0
  801e53:	6a 2a                	push   $0x2a
  801e55:	e8 e2 fa ff ff       	call   80193c <syscall>
  801e5a:	83 c4 18             	add    $0x18,%esp
	return ;
  801e5d:	90                   	nop
}
  801e5e:	c9                   	leave  
  801e5f:	c3                   	ret    

00801e60 <gettst>:
uint32 gettst()
{
  801e60:	55                   	push   %ebp
  801e61:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e63:	6a 00                	push   $0x0
  801e65:	6a 00                	push   $0x0
  801e67:	6a 00                	push   $0x0
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 2b                	push   $0x2b
  801e6f:	e8 c8 fa ff ff       	call   80193c <syscall>
  801e74:	83 c4 18             	add    $0x18,%esp
}
  801e77:	c9                   	leave  
  801e78:	c3                   	ret    

00801e79 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e79:	55                   	push   %ebp
  801e7a:	89 e5                	mov    %esp,%ebp
  801e7c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	6a 00                	push   $0x0
  801e87:	6a 00                	push   $0x0
  801e89:	6a 2c                	push   $0x2c
  801e8b:	e8 ac fa ff ff       	call   80193c <syscall>
  801e90:	83 c4 18             	add    $0x18,%esp
  801e93:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e96:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e9a:	75 07                	jne    801ea3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e9c:	b8 01 00 00 00       	mov    $0x1,%eax
  801ea1:	eb 05                	jmp    801ea8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ea3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ea8:	c9                   	leave  
  801ea9:	c3                   	ret    

00801eaa <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801eaa:	55                   	push   %ebp
  801eab:	89 e5                	mov    %esp,%ebp
  801ead:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 00                	push   $0x0
  801eba:	6a 2c                	push   $0x2c
  801ebc:	e8 7b fa ff ff       	call   80193c <syscall>
  801ec1:	83 c4 18             	add    $0x18,%esp
  801ec4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ec7:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ecb:	75 07                	jne    801ed4 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801ecd:	b8 01 00 00 00       	mov    $0x1,%eax
  801ed2:	eb 05                	jmp    801ed9 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801ed4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ed9:	c9                   	leave  
  801eda:	c3                   	ret    

00801edb <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801edb:	55                   	push   %ebp
  801edc:	89 e5                	mov    %esp,%ebp
  801ede:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ee1:	6a 00                	push   $0x0
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 00                	push   $0x0
  801eeb:	6a 2c                	push   $0x2c
  801eed:	e8 4a fa ff ff       	call   80193c <syscall>
  801ef2:	83 c4 18             	add    $0x18,%esp
  801ef5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ef8:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801efc:	75 07                	jne    801f05 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801efe:	b8 01 00 00 00       	mov    $0x1,%eax
  801f03:	eb 05                	jmp    801f0a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f05:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f0a:	c9                   	leave  
  801f0b:	c3                   	ret    

00801f0c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801f0c:	55                   	push   %ebp
  801f0d:	89 e5                	mov    %esp,%ebp
  801f0f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f12:	6a 00                	push   $0x0
  801f14:	6a 00                	push   $0x0
  801f16:	6a 00                	push   $0x0
  801f18:	6a 00                	push   $0x0
  801f1a:	6a 00                	push   $0x0
  801f1c:	6a 2c                	push   $0x2c
  801f1e:	e8 19 fa ff ff       	call   80193c <syscall>
  801f23:	83 c4 18             	add    $0x18,%esp
  801f26:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f29:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f2d:	75 07                	jne    801f36 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f2f:	b8 01 00 00 00       	mov    $0x1,%eax
  801f34:	eb 05                	jmp    801f3b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f36:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f3b:	c9                   	leave  
  801f3c:	c3                   	ret    

00801f3d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f3d:	55                   	push   %ebp
  801f3e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f40:	6a 00                	push   $0x0
  801f42:	6a 00                	push   $0x0
  801f44:	6a 00                	push   $0x0
  801f46:	6a 00                	push   $0x0
  801f48:	ff 75 08             	pushl  0x8(%ebp)
  801f4b:	6a 2d                	push   $0x2d
  801f4d:	e8 ea f9 ff ff       	call   80193c <syscall>
  801f52:	83 c4 18             	add    $0x18,%esp
	return ;
  801f55:	90                   	nop
}
  801f56:	c9                   	leave  
  801f57:	c3                   	ret    

00801f58 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f58:	55                   	push   %ebp
  801f59:	89 e5                	mov    %esp,%ebp
  801f5b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f5c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f5f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f62:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f65:	8b 45 08             	mov    0x8(%ebp),%eax
  801f68:	6a 00                	push   $0x0
  801f6a:	53                   	push   %ebx
  801f6b:	51                   	push   %ecx
  801f6c:	52                   	push   %edx
  801f6d:	50                   	push   %eax
  801f6e:	6a 2e                	push   $0x2e
  801f70:	e8 c7 f9 ff ff       	call   80193c <syscall>
  801f75:	83 c4 18             	add    $0x18,%esp
}
  801f78:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f7b:	c9                   	leave  
  801f7c:	c3                   	ret    

00801f7d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f7d:	55                   	push   %ebp
  801f7e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f80:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f83:	8b 45 08             	mov    0x8(%ebp),%eax
  801f86:	6a 00                	push   $0x0
  801f88:	6a 00                	push   $0x0
  801f8a:	6a 00                	push   $0x0
  801f8c:	52                   	push   %edx
  801f8d:	50                   	push   %eax
  801f8e:	6a 2f                	push   $0x2f
  801f90:	e8 a7 f9 ff ff       	call   80193c <syscall>
  801f95:	83 c4 18             	add    $0x18,%esp
}
  801f98:	c9                   	leave  
  801f99:	c3                   	ret    

00801f9a <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f9a:	55                   	push   %ebp
  801f9b:	89 e5                	mov    %esp,%ebp
  801f9d:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801fa0:	83 ec 0c             	sub    $0xc,%esp
  801fa3:	68 e0 3f 80 00       	push   $0x803fe0
  801fa8:	e8 d6 e6 ff ff       	call   800683 <cprintf>
  801fad:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801fb0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801fb7:	83 ec 0c             	sub    $0xc,%esp
  801fba:	68 0c 40 80 00       	push   $0x80400c
  801fbf:	e8 bf e6 ff ff       	call   800683 <cprintf>
  801fc4:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801fc7:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801fcb:	a1 38 51 80 00       	mov    0x805138,%eax
  801fd0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fd3:	eb 56                	jmp    80202b <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801fd5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fd9:	74 1c                	je     801ff7 <print_mem_block_lists+0x5d>
  801fdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fde:	8b 50 08             	mov    0x8(%eax),%edx
  801fe1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fe4:	8b 48 08             	mov    0x8(%eax),%ecx
  801fe7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fea:	8b 40 0c             	mov    0xc(%eax),%eax
  801fed:	01 c8                	add    %ecx,%eax
  801fef:	39 c2                	cmp    %eax,%edx
  801ff1:	73 04                	jae    801ff7 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801ff3:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ff7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffa:	8b 50 08             	mov    0x8(%eax),%edx
  801ffd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802000:	8b 40 0c             	mov    0xc(%eax),%eax
  802003:	01 c2                	add    %eax,%edx
  802005:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802008:	8b 40 08             	mov    0x8(%eax),%eax
  80200b:	83 ec 04             	sub    $0x4,%esp
  80200e:	52                   	push   %edx
  80200f:	50                   	push   %eax
  802010:	68 21 40 80 00       	push   $0x804021
  802015:	e8 69 e6 ff ff       	call   800683 <cprintf>
  80201a:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80201d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802020:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802023:	a1 40 51 80 00       	mov    0x805140,%eax
  802028:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80202b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80202f:	74 07                	je     802038 <print_mem_block_lists+0x9e>
  802031:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802034:	8b 00                	mov    (%eax),%eax
  802036:	eb 05                	jmp    80203d <print_mem_block_lists+0xa3>
  802038:	b8 00 00 00 00       	mov    $0x0,%eax
  80203d:	a3 40 51 80 00       	mov    %eax,0x805140
  802042:	a1 40 51 80 00       	mov    0x805140,%eax
  802047:	85 c0                	test   %eax,%eax
  802049:	75 8a                	jne    801fd5 <print_mem_block_lists+0x3b>
  80204b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80204f:	75 84                	jne    801fd5 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802051:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802055:	75 10                	jne    802067 <print_mem_block_lists+0xcd>
  802057:	83 ec 0c             	sub    $0xc,%esp
  80205a:	68 30 40 80 00       	push   $0x804030
  80205f:	e8 1f e6 ff ff       	call   800683 <cprintf>
  802064:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802067:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80206e:	83 ec 0c             	sub    $0xc,%esp
  802071:	68 54 40 80 00       	push   $0x804054
  802076:	e8 08 e6 ff ff       	call   800683 <cprintf>
  80207b:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80207e:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802082:	a1 40 50 80 00       	mov    0x805040,%eax
  802087:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80208a:	eb 56                	jmp    8020e2 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80208c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802090:	74 1c                	je     8020ae <print_mem_block_lists+0x114>
  802092:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802095:	8b 50 08             	mov    0x8(%eax),%edx
  802098:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80209b:	8b 48 08             	mov    0x8(%eax),%ecx
  80209e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020a1:	8b 40 0c             	mov    0xc(%eax),%eax
  8020a4:	01 c8                	add    %ecx,%eax
  8020a6:	39 c2                	cmp    %eax,%edx
  8020a8:	73 04                	jae    8020ae <print_mem_block_lists+0x114>
			sorted = 0 ;
  8020aa:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8020ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b1:	8b 50 08             	mov    0x8(%eax),%edx
  8020b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8020ba:	01 c2                	add    %eax,%edx
  8020bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020bf:	8b 40 08             	mov    0x8(%eax),%eax
  8020c2:	83 ec 04             	sub    $0x4,%esp
  8020c5:	52                   	push   %edx
  8020c6:	50                   	push   %eax
  8020c7:	68 21 40 80 00       	push   $0x804021
  8020cc:	e8 b2 e5 ff ff       	call   800683 <cprintf>
  8020d1:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8020d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8020da:	a1 48 50 80 00       	mov    0x805048,%eax
  8020df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020e6:	74 07                	je     8020ef <print_mem_block_lists+0x155>
  8020e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020eb:	8b 00                	mov    (%eax),%eax
  8020ed:	eb 05                	jmp    8020f4 <print_mem_block_lists+0x15a>
  8020ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f4:	a3 48 50 80 00       	mov    %eax,0x805048
  8020f9:	a1 48 50 80 00       	mov    0x805048,%eax
  8020fe:	85 c0                	test   %eax,%eax
  802100:	75 8a                	jne    80208c <print_mem_block_lists+0xf2>
  802102:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802106:	75 84                	jne    80208c <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802108:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80210c:	75 10                	jne    80211e <print_mem_block_lists+0x184>
  80210e:	83 ec 0c             	sub    $0xc,%esp
  802111:	68 6c 40 80 00       	push   $0x80406c
  802116:	e8 68 e5 ff ff       	call   800683 <cprintf>
  80211b:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80211e:	83 ec 0c             	sub    $0xc,%esp
  802121:	68 e0 3f 80 00       	push   $0x803fe0
  802126:	e8 58 e5 ff ff       	call   800683 <cprintf>
  80212b:	83 c4 10             	add    $0x10,%esp

}
  80212e:	90                   	nop
  80212f:	c9                   	leave  
  802130:	c3                   	ret    

00802131 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802131:	55                   	push   %ebp
  802132:	89 e5                	mov    %esp,%ebp
  802134:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802137:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80213e:	00 00 00 
  802141:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802148:	00 00 00 
  80214b:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802152:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802155:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80215c:	e9 9e 00 00 00       	jmp    8021ff <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802161:	a1 50 50 80 00       	mov    0x805050,%eax
  802166:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802169:	c1 e2 04             	shl    $0x4,%edx
  80216c:	01 d0                	add    %edx,%eax
  80216e:	85 c0                	test   %eax,%eax
  802170:	75 14                	jne    802186 <initialize_MemBlocksList+0x55>
  802172:	83 ec 04             	sub    $0x4,%esp
  802175:	68 94 40 80 00       	push   $0x804094
  80217a:	6a 46                	push   $0x46
  80217c:	68 b7 40 80 00       	push   $0x8040b7
  802181:	e8 64 14 00 00       	call   8035ea <_panic>
  802186:	a1 50 50 80 00       	mov    0x805050,%eax
  80218b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80218e:	c1 e2 04             	shl    $0x4,%edx
  802191:	01 d0                	add    %edx,%eax
  802193:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802199:	89 10                	mov    %edx,(%eax)
  80219b:	8b 00                	mov    (%eax),%eax
  80219d:	85 c0                	test   %eax,%eax
  80219f:	74 18                	je     8021b9 <initialize_MemBlocksList+0x88>
  8021a1:	a1 48 51 80 00       	mov    0x805148,%eax
  8021a6:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8021ac:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8021af:	c1 e1 04             	shl    $0x4,%ecx
  8021b2:	01 ca                	add    %ecx,%edx
  8021b4:	89 50 04             	mov    %edx,0x4(%eax)
  8021b7:	eb 12                	jmp    8021cb <initialize_MemBlocksList+0x9a>
  8021b9:	a1 50 50 80 00       	mov    0x805050,%eax
  8021be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021c1:	c1 e2 04             	shl    $0x4,%edx
  8021c4:	01 d0                	add    %edx,%eax
  8021c6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8021cb:	a1 50 50 80 00       	mov    0x805050,%eax
  8021d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021d3:	c1 e2 04             	shl    $0x4,%edx
  8021d6:	01 d0                	add    %edx,%eax
  8021d8:	a3 48 51 80 00       	mov    %eax,0x805148
  8021dd:	a1 50 50 80 00       	mov    0x805050,%eax
  8021e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021e5:	c1 e2 04             	shl    $0x4,%edx
  8021e8:	01 d0                	add    %edx,%eax
  8021ea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021f1:	a1 54 51 80 00       	mov    0x805154,%eax
  8021f6:	40                   	inc    %eax
  8021f7:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8021fc:	ff 45 f4             	incl   -0xc(%ebp)
  8021ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802202:	3b 45 08             	cmp    0x8(%ebp),%eax
  802205:	0f 82 56 ff ff ff    	jb     802161 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  80220b:	90                   	nop
  80220c:	c9                   	leave  
  80220d:	c3                   	ret    

0080220e <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80220e:	55                   	push   %ebp
  80220f:	89 e5                	mov    %esp,%ebp
  802211:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802214:	8b 45 08             	mov    0x8(%ebp),%eax
  802217:	8b 00                	mov    (%eax),%eax
  802219:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80221c:	eb 19                	jmp    802237 <find_block+0x29>
	{
		if(va==point->sva)
  80221e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802221:	8b 40 08             	mov    0x8(%eax),%eax
  802224:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802227:	75 05                	jne    80222e <find_block+0x20>
		   return point;
  802229:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80222c:	eb 36                	jmp    802264 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80222e:	8b 45 08             	mov    0x8(%ebp),%eax
  802231:	8b 40 08             	mov    0x8(%eax),%eax
  802234:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802237:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80223b:	74 07                	je     802244 <find_block+0x36>
  80223d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802240:	8b 00                	mov    (%eax),%eax
  802242:	eb 05                	jmp    802249 <find_block+0x3b>
  802244:	b8 00 00 00 00       	mov    $0x0,%eax
  802249:	8b 55 08             	mov    0x8(%ebp),%edx
  80224c:	89 42 08             	mov    %eax,0x8(%edx)
  80224f:	8b 45 08             	mov    0x8(%ebp),%eax
  802252:	8b 40 08             	mov    0x8(%eax),%eax
  802255:	85 c0                	test   %eax,%eax
  802257:	75 c5                	jne    80221e <find_block+0x10>
  802259:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80225d:	75 bf                	jne    80221e <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  80225f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802264:	c9                   	leave  
  802265:	c3                   	ret    

00802266 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802266:	55                   	push   %ebp
  802267:	89 e5                	mov    %esp,%ebp
  802269:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80226c:	a1 40 50 80 00       	mov    0x805040,%eax
  802271:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802274:	a1 44 50 80 00       	mov    0x805044,%eax
  802279:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80227c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80227f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802282:	74 24                	je     8022a8 <insert_sorted_allocList+0x42>
  802284:	8b 45 08             	mov    0x8(%ebp),%eax
  802287:	8b 50 08             	mov    0x8(%eax),%edx
  80228a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80228d:	8b 40 08             	mov    0x8(%eax),%eax
  802290:	39 c2                	cmp    %eax,%edx
  802292:	76 14                	jbe    8022a8 <insert_sorted_allocList+0x42>
  802294:	8b 45 08             	mov    0x8(%ebp),%eax
  802297:	8b 50 08             	mov    0x8(%eax),%edx
  80229a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80229d:	8b 40 08             	mov    0x8(%eax),%eax
  8022a0:	39 c2                	cmp    %eax,%edx
  8022a2:	0f 82 60 01 00 00    	jb     802408 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8022a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022ac:	75 65                	jne    802313 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8022ae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022b2:	75 14                	jne    8022c8 <insert_sorted_allocList+0x62>
  8022b4:	83 ec 04             	sub    $0x4,%esp
  8022b7:	68 94 40 80 00       	push   $0x804094
  8022bc:	6a 6b                	push   $0x6b
  8022be:	68 b7 40 80 00       	push   $0x8040b7
  8022c3:	e8 22 13 00 00       	call   8035ea <_panic>
  8022c8:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8022ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d1:	89 10                	mov    %edx,(%eax)
  8022d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d6:	8b 00                	mov    (%eax),%eax
  8022d8:	85 c0                	test   %eax,%eax
  8022da:	74 0d                	je     8022e9 <insert_sorted_allocList+0x83>
  8022dc:	a1 40 50 80 00       	mov    0x805040,%eax
  8022e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8022e4:	89 50 04             	mov    %edx,0x4(%eax)
  8022e7:	eb 08                	jmp    8022f1 <insert_sorted_allocList+0x8b>
  8022e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ec:	a3 44 50 80 00       	mov    %eax,0x805044
  8022f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f4:	a3 40 50 80 00       	mov    %eax,0x805040
  8022f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802303:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802308:	40                   	inc    %eax
  802309:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80230e:	e9 dc 01 00 00       	jmp    8024ef <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802313:	8b 45 08             	mov    0x8(%ebp),%eax
  802316:	8b 50 08             	mov    0x8(%eax),%edx
  802319:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80231c:	8b 40 08             	mov    0x8(%eax),%eax
  80231f:	39 c2                	cmp    %eax,%edx
  802321:	77 6c                	ja     80238f <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802323:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802327:	74 06                	je     80232f <insert_sorted_allocList+0xc9>
  802329:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80232d:	75 14                	jne    802343 <insert_sorted_allocList+0xdd>
  80232f:	83 ec 04             	sub    $0x4,%esp
  802332:	68 d0 40 80 00       	push   $0x8040d0
  802337:	6a 6f                	push   $0x6f
  802339:	68 b7 40 80 00       	push   $0x8040b7
  80233e:	e8 a7 12 00 00       	call   8035ea <_panic>
  802343:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802346:	8b 50 04             	mov    0x4(%eax),%edx
  802349:	8b 45 08             	mov    0x8(%ebp),%eax
  80234c:	89 50 04             	mov    %edx,0x4(%eax)
  80234f:	8b 45 08             	mov    0x8(%ebp),%eax
  802352:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802355:	89 10                	mov    %edx,(%eax)
  802357:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80235a:	8b 40 04             	mov    0x4(%eax),%eax
  80235d:	85 c0                	test   %eax,%eax
  80235f:	74 0d                	je     80236e <insert_sorted_allocList+0x108>
  802361:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802364:	8b 40 04             	mov    0x4(%eax),%eax
  802367:	8b 55 08             	mov    0x8(%ebp),%edx
  80236a:	89 10                	mov    %edx,(%eax)
  80236c:	eb 08                	jmp    802376 <insert_sorted_allocList+0x110>
  80236e:	8b 45 08             	mov    0x8(%ebp),%eax
  802371:	a3 40 50 80 00       	mov    %eax,0x805040
  802376:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802379:	8b 55 08             	mov    0x8(%ebp),%edx
  80237c:	89 50 04             	mov    %edx,0x4(%eax)
  80237f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802384:	40                   	inc    %eax
  802385:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80238a:	e9 60 01 00 00       	jmp    8024ef <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80238f:	8b 45 08             	mov    0x8(%ebp),%eax
  802392:	8b 50 08             	mov    0x8(%eax),%edx
  802395:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802398:	8b 40 08             	mov    0x8(%eax),%eax
  80239b:	39 c2                	cmp    %eax,%edx
  80239d:	0f 82 4c 01 00 00    	jb     8024ef <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8023a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023a7:	75 14                	jne    8023bd <insert_sorted_allocList+0x157>
  8023a9:	83 ec 04             	sub    $0x4,%esp
  8023ac:	68 08 41 80 00       	push   $0x804108
  8023b1:	6a 73                	push   $0x73
  8023b3:	68 b7 40 80 00       	push   $0x8040b7
  8023b8:	e8 2d 12 00 00       	call   8035ea <_panic>
  8023bd:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8023c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c6:	89 50 04             	mov    %edx,0x4(%eax)
  8023c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cc:	8b 40 04             	mov    0x4(%eax),%eax
  8023cf:	85 c0                	test   %eax,%eax
  8023d1:	74 0c                	je     8023df <insert_sorted_allocList+0x179>
  8023d3:	a1 44 50 80 00       	mov    0x805044,%eax
  8023d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8023db:	89 10                	mov    %edx,(%eax)
  8023dd:	eb 08                	jmp    8023e7 <insert_sorted_allocList+0x181>
  8023df:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e2:	a3 40 50 80 00       	mov    %eax,0x805040
  8023e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ea:	a3 44 50 80 00       	mov    %eax,0x805044
  8023ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023f8:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8023fd:	40                   	inc    %eax
  8023fe:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802403:	e9 e7 00 00 00       	jmp    8024ef <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802408:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80240b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80240e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802415:	a1 40 50 80 00       	mov    0x805040,%eax
  80241a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80241d:	e9 9d 00 00 00       	jmp    8024bf <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802422:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802425:	8b 00                	mov    (%eax),%eax
  802427:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80242a:	8b 45 08             	mov    0x8(%ebp),%eax
  80242d:	8b 50 08             	mov    0x8(%eax),%edx
  802430:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802433:	8b 40 08             	mov    0x8(%eax),%eax
  802436:	39 c2                	cmp    %eax,%edx
  802438:	76 7d                	jbe    8024b7 <insert_sorted_allocList+0x251>
  80243a:	8b 45 08             	mov    0x8(%ebp),%eax
  80243d:	8b 50 08             	mov    0x8(%eax),%edx
  802440:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802443:	8b 40 08             	mov    0x8(%eax),%eax
  802446:	39 c2                	cmp    %eax,%edx
  802448:	73 6d                	jae    8024b7 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80244a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80244e:	74 06                	je     802456 <insert_sorted_allocList+0x1f0>
  802450:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802454:	75 14                	jne    80246a <insert_sorted_allocList+0x204>
  802456:	83 ec 04             	sub    $0x4,%esp
  802459:	68 2c 41 80 00       	push   $0x80412c
  80245e:	6a 7f                	push   $0x7f
  802460:	68 b7 40 80 00       	push   $0x8040b7
  802465:	e8 80 11 00 00       	call   8035ea <_panic>
  80246a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246d:	8b 10                	mov    (%eax),%edx
  80246f:	8b 45 08             	mov    0x8(%ebp),%eax
  802472:	89 10                	mov    %edx,(%eax)
  802474:	8b 45 08             	mov    0x8(%ebp),%eax
  802477:	8b 00                	mov    (%eax),%eax
  802479:	85 c0                	test   %eax,%eax
  80247b:	74 0b                	je     802488 <insert_sorted_allocList+0x222>
  80247d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802480:	8b 00                	mov    (%eax),%eax
  802482:	8b 55 08             	mov    0x8(%ebp),%edx
  802485:	89 50 04             	mov    %edx,0x4(%eax)
  802488:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248b:	8b 55 08             	mov    0x8(%ebp),%edx
  80248e:	89 10                	mov    %edx,(%eax)
  802490:	8b 45 08             	mov    0x8(%ebp),%eax
  802493:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802496:	89 50 04             	mov    %edx,0x4(%eax)
  802499:	8b 45 08             	mov    0x8(%ebp),%eax
  80249c:	8b 00                	mov    (%eax),%eax
  80249e:	85 c0                	test   %eax,%eax
  8024a0:	75 08                	jne    8024aa <insert_sorted_allocList+0x244>
  8024a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a5:	a3 44 50 80 00       	mov    %eax,0x805044
  8024aa:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8024af:	40                   	inc    %eax
  8024b0:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8024b5:	eb 39                	jmp    8024f0 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8024b7:	a1 48 50 80 00       	mov    0x805048,%eax
  8024bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024c3:	74 07                	je     8024cc <insert_sorted_allocList+0x266>
  8024c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c8:	8b 00                	mov    (%eax),%eax
  8024ca:	eb 05                	jmp    8024d1 <insert_sorted_allocList+0x26b>
  8024cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8024d1:	a3 48 50 80 00       	mov    %eax,0x805048
  8024d6:	a1 48 50 80 00       	mov    0x805048,%eax
  8024db:	85 c0                	test   %eax,%eax
  8024dd:	0f 85 3f ff ff ff    	jne    802422 <insert_sorted_allocList+0x1bc>
  8024e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024e7:	0f 85 35 ff ff ff    	jne    802422 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8024ed:	eb 01                	jmp    8024f0 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8024ef:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8024f0:	90                   	nop
  8024f1:	c9                   	leave  
  8024f2:	c3                   	ret    

008024f3 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8024f3:	55                   	push   %ebp
  8024f4:	89 e5                	mov    %esp,%ebp
  8024f6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8024f9:	a1 38 51 80 00       	mov    0x805138,%eax
  8024fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802501:	e9 85 01 00 00       	jmp    80268b <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802506:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802509:	8b 40 0c             	mov    0xc(%eax),%eax
  80250c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80250f:	0f 82 6e 01 00 00    	jb     802683 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802515:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802518:	8b 40 0c             	mov    0xc(%eax),%eax
  80251b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80251e:	0f 85 8a 00 00 00    	jne    8025ae <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802524:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802528:	75 17                	jne    802541 <alloc_block_FF+0x4e>
  80252a:	83 ec 04             	sub    $0x4,%esp
  80252d:	68 60 41 80 00       	push   $0x804160
  802532:	68 93 00 00 00       	push   $0x93
  802537:	68 b7 40 80 00       	push   $0x8040b7
  80253c:	e8 a9 10 00 00       	call   8035ea <_panic>
  802541:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802544:	8b 00                	mov    (%eax),%eax
  802546:	85 c0                	test   %eax,%eax
  802548:	74 10                	je     80255a <alloc_block_FF+0x67>
  80254a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254d:	8b 00                	mov    (%eax),%eax
  80254f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802552:	8b 52 04             	mov    0x4(%edx),%edx
  802555:	89 50 04             	mov    %edx,0x4(%eax)
  802558:	eb 0b                	jmp    802565 <alloc_block_FF+0x72>
  80255a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255d:	8b 40 04             	mov    0x4(%eax),%eax
  802560:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802565:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802568:	8b 40 04             	mov    0x4(%eax),%eax
  80256b:	85 c0                	test   %eax,%eax
  80256d:	74 0f                	je     80257e <alloc_block_FF+0x8b>
  80256f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802572:	8b 40 04             	mov    0x4(%eax),%eax
  802575:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802578:	8b 12                	mov    (%edx),%edx
  80257a:	89 10                	mov    %edx,(%eax)
  80257c:	eb 0a                	jmp    802588 <alloc_block_FF+0x95>
  80257e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802581:	8b 00                	mov    (%eax),%eax
  802583:	a3 38 51 80 00       	mov    %eax,0x805138
  802588:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802591:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802594:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80259b:	a1 44 51 80 00       	mov    0x805144,%eax
  8025a0:	48                   	dec    %eax
  8025a1:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8025a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a9:	e9 10 01 00 00       	jmp    8026be <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8025ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8025b4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025b7:	0f 86 c6 00 00 00    	jbe    802683 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8025bd:	a1 48 51 80 00       	mov    0x805148,%eax
  8025c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8025c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c8:	8b 50 08             	mov    0x8(%eax),%edx
  8025cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ce:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8025d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8025d7:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8025da:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025de:	75 17                	jne    8025f7 <alloc_block_FF+0x104>
  8025e0:	83 ec 04             	sub    $0x4,%esp
  8025e3:	68 60 41 80 00       	push   $0x804160
  8025e8:	68 9b 00 00 00       	push   $0x9b
  8025ed:	68 b7 40 80 00       	push   $0x8040b7
  8025f2:	e8 f3 0f 00 00       	call   8035ea <_panic>
  8025f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025fa:	8b 00                	mov    (%eax),%eax
  8025fc:	85 c0                	test   %eax,%eax
  8025fe:	74 10                	je     802610 <alloc_block_FF+0x11d>
  802600:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802603:	8b 00                	mov    (%eax),%eax
  802605:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802608:	8b 52 04             	mov    0x4(%edx),%edx
  80260b:	89 50 04             	mov    %edx,0x4(%eax)
  80260e:	eb 0b                	jmp    80261b <alloc_block_FF+0x128>
  802610:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802613:	8b 40 04             	mov    0x4(%eax),%eax
  802616:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80261b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80261e:	8b 40 04             	mov    0x4(%eax),%eax
  802621:	85 c0                	test   %eax,%eax
  802623:	74 0f                	je     802634 <alloc_block_FF+0x141>
  802625:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802628:	8b 40 04             	mov    0x4(%eax),%eax
  80262b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80262e:	8b 12                	mov    (%edx),%edx
  802630:	89 10                	mov    %edx,(%eax)
  802632:	eb 0a                	jmp    80263e <alloc_block_FF+0x14b>
  802634:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802637:	8b 00                	mov    (%eax),%eax
  802639:	a3 48 51 80 00       	mov    %eax,0x805148
  80263e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802641:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802647:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80264a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802651:	a1 54 51 80 00       	mov    0x805154,%eax
  802656:	48                   	dec    %eax
  802657:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  80265c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265f:	8b 50 08             	mov    0x8(%eax),%edx
  802662:	8b 45 08             	mov    0x8(%ebp),%eax
  802665:	01 c2                	add    %eax,%edx
  802667:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266a:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  80266d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802670:	8b 40 0c             	mov    0xc(%eax),%eax
  802673:	2b 45 08             	sub    0x8(%ebp),%eax
  802676:	89 c2                	mov    %eax,%edx
  802678:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267b:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  80267e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802681:	eb 3b                	jmp    8026be <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802683:	a1 40 51 80 00       	mov    0x805140,%eax
  802688:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80268b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80268f:	74 07                	je     802698 <alloc_block_FF+0x1a5>
  802691:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802694:	8b 00                	mov    (%eax),%eax
  802696:	eb 05                	jmp    80269d <alloc_block_FF+0x1aa>
  802698:	b8 00 00 00 00       	mov    $0x0,%eax
  80269d:	a3 40 51 80 00       	mov    %eax,0x805140
  8026a2:	a1 40 51 80 00       	mov    0x805140,%eax
  8026a7:	85 c0                	test   %eax,%eax
  8026a9:	0f 85 57 fe ff ff    	jne    802506 <alloc_block_FF+0x13>
  8026af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026b3:	0f 85 4d fe ff ff    	jne    802506 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8026b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026be:	c9                   	leave  
  8026bf:	c3                   	ret    

008026c0 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8026c0:	55                   	push   %ebp
  8026c1:	89 e5                	mov    %esp,%ebp
  8026c3:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8026c6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8026cd:	a1 38 51 80 00       	mov    0x805138,%eax
  8026d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026d5:	e9 df 00 00 00       	jmp    8027b9 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8026da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8026e0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026e3:	0f 82 c8 00 00 00    	jb     8027b1 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8026e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ef:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026f2:	0f 85 8a 00 00 00    	jne    802782 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8026f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026fc:	75 17                	jne    802715 <alloc_block_BF+0x55>
  8026fe:	83 ec 04             	sub    $0x4,%esp
  802701:	68 60 41 80 00       	push   $0x804160
  802706:	68 b7 00 00 00       	push   $0xb7
  80270b:	68 b7 40 80 00       	push   $0x8040b7
  802710:	e8 d5 0e 00 00       	call   8035ea <_panic>
  802715:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802718:	8b 00                	mov    (%eax),%eax
  80271a:	85 c0                	test   %eax,%eax
  80271c:	74 10                	je     80272e <alloc_block_BF+0x6e>
  80271e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802721:	8b 00                	mov    (%eax),%eax
  802723:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802726:	8b 52 04             	mov    0x4(%edx),%edx
  802729:	89 50 04             	mov    %edx,0x4(%eax)
  80272c:	eb 0b                	jmp    802739 <alloc_block_BF+0x79>
  80272e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802731:	8b 40 04             	mov    0x4(%eax),%eax
  802734:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802739:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273c:	8b 40 04             	mov    0x4(%eax),%eax
  80273f:	85 c0                	test   %eax,%eax
  802741:	74 0f                	je     802752 <alloc_block_BF+0x92>
  802743:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802746:	8b 40 04             	mov    0x4(%eax),%eax
  802749:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80274c:	8b 12                	mov    (%edx),%edx
  80274e:	89 10                	mov    %edx,(%eax)
  802750:	eb 0a                	jmp    80275c <alloc_block_BF+0x9c>
  802752:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802755:	8b 00                	mov    (%eax),%eax
  802757:	a3 38 51 80 00       	mov    %eax,0x805138
  80275c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802765:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802768:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80276f:	a1 44 51 80 00       	mov    0x805144,%eax
  802774:	48                   	dec    %eax
  802775:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  80277a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277d:	e9 4d 01 00 00       	jmp    8028cf <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802782:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802785:	8b 40 0c             	mov    0xc(%eax),%eax
  802788:	3b 45 08             	cmp    0x8(%ebp),%eax
  80278b:	76 24                	jbe    8027b1 <alloc_block_BF+0xf1>
  80278d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802790:	8b 40 0c             	mov    0xc(%eax),%eax
  802793:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802796:	73 19                	jae    8027b1 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802798:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  80279f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8027a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8027a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ab:	8b 40 08             	mov    0x8(%eax),%eax
  8027ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8027b1:	a1 40 51 80 00       	mov    0x805140,%eax
  8027b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027bd:	74 07                	je     8027c6 <alloc_block_BF+0x106>
  8027bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c2:	8b 00                	mov    (%eax),%eax
  8027c4:	eb 05                	jmp    8027cb <alloc_block_BF+0x10b>
  8027c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8027cb:	a3 40 51 80 00       	mov    %eax,0x805140
  8027d0:	a1 40 51 80 00       	mov    0x805140,%eax
  8027d5:	85 c0                	test   %eax,%eax
  8027d7:	0f 85 fd fe ff ff    	jne    8026da <alloc_block_BF+0x1a>
  8027dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027e1:	0f 85 f3 fe ff ff    	jne    8026da <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8027e7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8027eb:	0f 84 d9 00 00 00    	je     8028ca <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8027f1:	a1 48 51 80 00       	mov    0x805148,%eax
  8027f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8027f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027fc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027ff:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802802:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802805:	8b 55 08             	mov    0x8(%ebp),%edx
  802808:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  80280b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80280f:	75 17                	jne    802828 <alloc_block_BF+0x168>
  802811:	83 ec 04             	sub    $0x4,%esp
  802814:	68 60 41 80 00       	push   $0x804160
  802819:	68 c7 00 00 00       	push   $0xc7
  80281e:	68 b7 40 80 00       	push   $0x8040b7
  802823:	e8 c2 0d 00 00       	call   8035ea <_panic>
  802828:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80282b:	8b 00                	mov    (%eax),%eax
  80282d:	85 c0                	test   %eax,%eax
  80282f:	74 10                	je     802841 <alloc_block_BF+0x181>
  802831:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802834:	8b 00                	mov    (%eax),%eax
  802836:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802839:	8b 52 04             	mov    0x4(%edx),%edx
  80283c:	89 50 04             	mov    %edx,0x4(%eax)
  80283f:	eb 0b                	jmp    80284c <alloc_block_BF+0x18c>
  802841:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802844:	8b 40 04             	mov    0x4(%eax),%eax
  802847:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80284c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80284f:	8b 40 04             	mov    0x4(%eax),%eax
  802852:	85 c0                	test   %eax,%eax
  802854:	74 0f                	je     802865 <alloc_block_BF+0x1a5>
  802856:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802859:	8b 40 04             	mov    0x4(%eax),%eax
  80285c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80285f:	8b 12                	mov    (%edx),%edx
  802861:	89 10                	mov    %edx,(%eax)
  802863:	eb 0a                	jmp    80286f <alloc_block_BF+0x1af>
  802865:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802868:	8b 00                	mov    (%eax),%eax
  80286a:	a3 48 51 80 00       	mov    %eax,0x805148
  80286f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802872:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802878:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80287b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802882:	a1 54 51 80 00       	mov    0x805154,%eax
  802887:	48                   	dec    %eax
  802888:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  80288d:	83 ec 08             	sub    $0x8,%esp
  802890:	ff 75 ec             	pushl  -0x14(%ebp)
  802893:	68 38 51 80 00       	push   $0x805138
  802898:	e8 71 f9 ff ff       	call   80220e <find_block>
  80289d:	83 c4 10             	add    $0x10,%esp
  8028a0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8028a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028a6:	8b 50 08             	mov    0x8(%eax),%edx
  8028a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ac:	01 c2                	add    %eax,%edx
  8028ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028b1:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8028b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8028ba:	2b 45 08             	sub    0x8(%ebp),%eax
  8028bd:	89 c2                	mov    %eax,%edx
  8028bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028c2:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8028c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028c8:	eb 05                	jmp    8028cf <alloc_block_BF+0x20f>
	}
	return NULL;
  8028ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028cf:	c9                   	leave  
  8028d0:	c3                   	ret    

008028d1 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8028d1:	55                   	push   %ebp
  8028d2:	89 e5                	mov    %esp,%ebp
  8028d4:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8028d7:	a1 28 50 80 00       	mov    0x805028,%eax
  8028dc:	85 c0                	test   %eax,%eax
  8028de:	0f 85 de 01 00 00    	jne    802ac2 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8028e4:	a1 38 51 80 00       	mov    0x805138,%eax
  8028e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028ec:	e9 9e 01 00 00       	jmp    802a8f <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8028f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8028f7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028fa:	0f 82 87 01 00 00    	jb     802a87 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802900:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802903:	8b 40 0c             	mov    0xc(%eax),%eax
  802906:	3b 45 08             	cmp    0x8(%ebp),%eax
  802909:	0f 85 95 00 00 00    	jne    8029a4 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  80290f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802913:	75 17                	jne    80292c <alloc_block_NF+0x5b>
  802915:	83 ec 04             	sub    $0x4,%esp
  802918:	68 60 41 80 00       	push   $0x804160
  80291d:	68 e0 00 00 00       	push   $0xe0
  802922:	68 b7 40 80 00       	push   $0x8040b7
  802927:	e8 be 0c 00 00       	call   8035ea <_panic>
  80292c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292f:	8b 00                	mov    (%eax),%eax
  802931:	85 c0                	test   %eax,%eax
  802933:	74 10                	je     802945 <alloc_block_NF+0x74>
  802935:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802938:	8b 00                	mov    (%eax),%eax
  80293a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80293d:	8b 52 04             	mov    0x4(%edx),%edx
  802940:	89 50 04             	mov    %edx,0x4(%eax)
  802943:	eb 0b                	jmp    802950 <alloc_block_NF+0x7f>
  802945:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802948:	8b 40 04             	mov    0x4(%eax),%eax
  80294b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802950:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802953:	8b 40 04             	mov    0x4(%eax),%eax
  802956:	85 c0                	test   %eax,%eax
  802958:	74 0f                	je     802969 <alloc_block_NF+0x98>
  80295a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295d:	8b 40 04             	mov    0x4(%eax),%eax
  802960:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802963:	8b 12                	mov    (%edx),%edx
  802965:	89 10                	mov    %edx,(%eax)
  802967:	eb 0a                	jmp    802973 <alloc_block_NF+0xa2>
  802969:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296c:	8b 00                	mov    (%eax),%eax
  80296e:	a3 38 51 80 00       	mov    %eax,0x805138
  802973:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802976:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80297c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802986:	a1 44 51 80 00       	mov    0x805144,%eax
  80298b:	48                   	dec    %eax
  80298c:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802991:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802994:	8b 40 08             	mov    0x8(%eax),%eax
  802997:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  80299c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299f:	e9 f8 04 00 00       	jmp    802e9c <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8029a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8029aa:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029ad:	0f 86 d4 00 00 00    	jbe    802a87 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8029b3:	a1 48 51 80 00       	mov    0x805148,%eax
  8029b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8029bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029be:	8b 50 08             	mov    0x8(%eax),%edx
  8029c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c4:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8029c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8029cd:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8029d0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029d4:	75 17                	jne    8029ed <alloc_block_NF+0x11c>
  8029d6:	83 ec 04             	sub    $0x4,%esp
  8029d9:	68 60 41 80 00       	push   $0x804160
  8029de:	68 e9 00 00 00       	push   $0xe9
  8029e3:	68 b7 40 80 00       	push   $0x8040b7
  8029e8:	e8 fd 0b 00 00       	call   8035ea <_panic>
  8029ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f0:	8b 00                	mov    (%eax),%eax
  8029f2:	85 c0                	test   %eax,%eax
  8029f4:	74 10                	je     802a06 <alloc_block_NF+0x135>
  8029f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f9:	8b 00                	mov    (%eax),%eax
  8029fb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029fe:	8b 52 04             	mov    0x4(%edx),%edx
  802a01:	89 50 04             	mov    %edx,0x4(%eax)
  802a04:	eb 0b                	jmp    802a11 <alloc_block_NF+0x140>
  802a06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a09:	8b 40 04             	mov    0x4(%eax),%eax
  802a0c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a14:	8b 40 04             	mov    0x4(%eax),%eax
  802a17:	85 c0                	test   %eax,%eax
  802a19:	74 0f                	je     802a2a <alloc_block_NF+0x159>
  802a1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a1e:	8b 40 04             	mov    0x4(%eax),%eax
  802a21:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a24:	8b 12                	mov    (%edx),%edx
  802a26:	89 10                	mov    %edx,(%eax)
  802a28:	eb 0a                	jmp    802a34 <alloc_block_NF+0x163>
  802a2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a2d:	8b 00                	mov    (%eax),%eax
  802a2f:	a3 48 51 80 00       	mov    %eax,0x805148
  802a34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a37:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a40:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a47:	a1 54 51 80 00       	mov    0x805154,%eax
  802a4c:	48                   	dec    %eax
  802a4d:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802a52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a55:	8b 40 08             	mov    0x8(%eax),%eax
  802a58:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a60:	8b 50 08             	mov    0x8(%eax),%edx
  802a63:	8b 45 08             	mov    0x8(%ebp),%eax
  802a66:	01 c2                	add    %eax,%edx
  802a68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6b:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802a6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a71:	8b 40 0c             	mov    0xc(%eax),%eax
  802a74:	2b 45 08             	sub    0x8(%ebp),%eax
  802a77:	89 c2                	mov    %eax,%edx
  802a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7c:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802a7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a82:	e9 15 04 00 00       	jmp    802e9c <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802a87:	a1 40 51 80 00       	mov    0x805140,%eax
  802a8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a8f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a93:	74 07                	je     802a9c <alloc_block_NF+0x1cb>
  802a95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a98:	8b 00                	mov    (%eax),%eax
  802a9a:	eb 05                	jmp    802aa1 <alloc_block_NF+0x1d0>
  802a9c:	b8 00 00 00 00       	mov    $0x0,%eax
  802aa1:	a3 40 51 80 00       	mov    %eax,0x805140
  802aa6:	a1 40 51 80 00       	mov    0x805140,%eax
  802aab:	85 c0                	test   %eax,%eax
  802aad:	0f 85 3e fe ff ff    	jne    8028f1 <alloc_block_NF+0x20>
  802ab3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ab7:	0f 85 34 fe ff ff    	jne    8028f1 <alloc_block_NF+0x20>
  802abd:	e9 d5 03 00 00       	jmp    802e97 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802ac2:	a1 38 51 80 00       	mov    0x805138,%eax
  802ac7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aca:	e9 b1 01 00 00       	jmp    802c80 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad2:	8b 50 08             	mov    0x8(%eax),%edx
  802ad5:	a1 28 50 80 00       	mov    0x805028,%eax
  802ada:	39 c2                	cmp    %eax,%edx
  802adc:	0f 82 96 01 00 00    	jb     802c78 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802ae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ae8:	3b 45 08             	cmp    0x8(%ebp),%eax
  802aeb:	0f 82 87 01 00 00    	jb     802c78 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802af1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af4:	8b 40 0c             	mov    0xc(%eax),%eax
  802af7:	3b 45 08             	cmp    0x8(%ebp),%eax
  802afa:	0f 85 95 00 00 00    	jne    802b95 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802b00:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b04:	75 17                	jne    802b1d <alloc_block_NF+0x24c>
  802b06:	83 ec 04             	sub    $0x4,%esp
  802b09:	68 60 41 80 00       	push   $0x804160
  802b0e:	68 fc 00 00 00       	push   $0xfc
  802b13:	68 b7 40 80 00       	push   $0x8040b7
  802b18:	e8 cd 0a 00 00       	call   8035ea <_panic>
  802b1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b20:	8b 00                	mov    (%eax),%eax
  802b22:	85 c0                	test   %eax,%eax
  802b24:	74 10                	je     802b36 <alloc_block_NF+0x265>
  802b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b29:	8b 00                	mov    (%eax),%eax
  802b2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b2e:	8b 52 04             	mov    0x4(%edx),%edx
  802b31:	89 50 04             	mov    %edx,0x4(%eax)
  802b34:	eb 0b                	jmp    802b41 <alloc_block_NF+0x270>
  802b36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b39:	8b 40 04             	mov    0x4(%eax),%eax
  802b3c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b44:	8b 40 04             	mov    0x4(%eax),%eax
  802b47:	85 c0                	test   %eax,%eax
  802b49:	74 0f                	je     802b5a <alloc_block_NF+0x289>
  802b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4e:	8b 40 04             	mov    0x4(%eax),%eax
  802b51:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b54:	8b 12                	mov    (%edx),%edx
  802b56:	89 10                	mov    %edx,(%eax)
  802b58:	eb 0a                	jmp    802b64 <alloc_block_NF+0x293>
  802b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5d:	8b 00                	mov    (%eax),%eax
  802b5f:	a3 38 51 80 00       	mov    %eax,0x805138
  802b64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b67:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b70:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b77:	a1 44 51 80 00       	mov    0x805144,%eax
  802b7c:	48                   	dec    %eax
  802b7d:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802b82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b85:	8b 40 08             	mov    0x8(%eax),%eax
  802b88:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b90:	e9 07 03 00 00       	jmp    802e9c <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b98:	8b 40 0c             	mov    0xc(%eax),%eax
  802b9b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b9e:	0f 86 d4 00 00 00    	jbe    802c78 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802ba4:	a1 48 51 80 00       	mov    0x805148,%eax
  802ba9:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802bac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802baf:	8b 50 08             	mov    0x8(%eax),%edx
  802bb2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bb5:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802bb8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bbb:	8b 55 08             	mov    0x8(%ebp),%edx
  802bbe:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802bc1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802bc5:	75 17                	jne    802bde <alloc_block_NF+0x30d>
  802bc7:	83 ec 04             	sub    $0x4,%esp
  802bca:	68 60 41 80 00       	push   $0x804160
  802bcf:	68 04 01 00 00       	push   $0x104
  802bd4:	68 b7 40 80 00       	push   $0x8040b7
  802bd9:	e8 0c 0a 00 00       	call   8035ea <_panic>
  802bde:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802be1:	8b 00                	mov    (%eax),%eax
  802be3:	85 c0                	test   %eax,%eax
  802be5:	74 10                	je     802bf7 <alloc_block_NF+0x326>
  802be7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bea:	8b 00                	mov    (%eax),%eax
  802bec:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bef:	8b 52 04             	mov    0x4(%edx),%edx
  802bf2:	89 50 04             	mov    %edx,0x4(%eax)
  802bf5:	eb 0b                	jmp    802c02 <alloc_block_NF+0x331>
  802bf7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bfa:	8b 40 04             	mov    0x4(%eax),%eax
  802bfd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c02:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c05:	8b 40 04             	mov    0x4(%eax),%eax
  802c08:	85 c0                	test   %eax,%eax
  802c0a:	74 0f                	je     802c1b <alloc_block_NF+0x34a>
  802c0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c0f:	8b 40 04             	mov    0x4(%eax),%eax
  802c12:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c15:	8b 12                	mov    (%edx),%edx
  802c17:	89 10                	mov    %edx,(%eax)
  802c19:	eb 0a                	jmp    802c25 <alloc_block_NF+0x354>
  802c1b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c1e:	8b 00                	mov    (%eax),%eax
  802c20:	a3 48 51 80 00       	mov    %eax,0x805148
  802c25:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c28:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c2e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c31:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c38:	a1 54 51 80 00       	mov    0x805154,%eax
  802c3d:	48                   	dec    %eax
  802c3e:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802c43:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c46:	8b 40 08             	mov    0x8(%eax),%eax
  802c49:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802c4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c51:	8b 50 08             	mov    0x8(%eax),%edx
  802c54:	8b 45 08             	mov    0x8(%ebp),%eax
  802c57:	01 c2                	add    %eax,%edx
  802c59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5c:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c62:	8b 40 0c             	mov    0xc(%eax),%eax
  802c65:	2b 45 08             	sub    0x8(%ebp),%eax
  802c68:	89 c2                	mov    %eax,%edx
  802c6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6d:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802c70:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c73:	e9 24 02 00 00       	jmp    802e9c <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c78:	a1 40 51 80 00       	mov    0x805140,%eax
  802c7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c80:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c84:	74 07                	je     802c8d <alloc_block_NF+0x3bc>
  802c86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c89:	8b 00                	mov    (%eax),%eax
  802c8b:	eb 05                	jmp    802c92 <alloc_block_NF+0x3c1>
  802c8d:	b8 00 00 00 00       	mov    $0x0,%eax
  802c92:	a3 40 51 80 00       	mov    %eax,0x805140
  802c97:	a1 40 51 80 00       	mov    0x805140,%eax
  802c9c:	85 c0                	test   %eax,%eax
  802c9e:	0f 85 2b fe ff ff    	jne    802acf <alloc_block_NF+0x1fe>
  802ca4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ca8:	0f 85 21 fe ff ff    	jne    802acf <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802cae:	a1 38 51 80 00       	mov    0x805138,%eax
  802cb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cb6:	e9 ae 01 00 00       	jmp    802e69 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802cbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbe:	8b 50 08             	mov    0x8(%eax),%edx
  802cc1:	a1 28 50 80 00       	mov    0x805028,%eax
  802cc6:	39 c2                	cmp    %eax,%edx
  802cc8:	0f 83 93 01 00 00    	jae    802e61 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802cce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd1:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd4:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cd7:	0f 82 84 01 00 00    	jb     802e61 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802cdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ce3:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ce6:	0f 85 95 00 00 00    	jne    802d81 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802cec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cf0:	75 17                	jne    802d09 <alloc_block_NF+0x438>
  802cf2:	83 ec 04             	sub    $0x4,%esp
  802cf5:	68 60 41 80 00       	push   $0x804160
  802cfa:	68 14 01 00 00       	push   $0x114
  802cff:	68 b7 40 80 00       	push   $0x8040b7
  802d04:	e8 e1 08 00 00       	call   8035ea <_panic>
  802d09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0c:	8b 00                	mov    (%eax),%eax
  802d0e:	85 c0                	test   %eax,%eax
  802d10:	74 10                	je     802d22 <alloc_block_NF+0x451>
  802d12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d15:	8b 00                	mov    (%eax),%eax
  802d17:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d1a:	8b 52 04             	mov    0x4(%edx),%edx
  802d1d:	89 50 04             	mov    %edx,0x4(%eax)
  802d20:	eb 0b                	jmp    802d2d <alloc_block_NF+0x45c>
  802d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d25:	8b 40 04             	mov    0x4(%eax),%eax
  802d28:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d30:	8b 40 04             	mov    0x4(%eax),%eax
  802d33:	85 c0                	test   %eax,%eax
  802d35:	74 0f                	je     802d46 <alloc_block_NF+0x475>
  802d37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3a:	8b 40 04             	mov    0x4(%eax),%eax
  802d3d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d40:	8b 12                	mov    (%edx),%edx
  802d42:	89 10                	mov    %edx,(%eax)
  802d44:	eb 0a                	jmp    802d50 <alloc_block_NF+0x47f>
  802d46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d49:	8b 00                	mov    (%eax),%eax
  802d4b:	a3 38 51 80 00       	mov    %eax,0x805138
  802d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d53:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d63:	a1 44 51 80 00       	mov    0x805144,%eax
  802d68:	48                   	dec    %eax
  802d69:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802d6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d71:	8b 40 08             	mov    0x8(%eax),%eax
  802d74:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802d79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7c:	e9 1b 01 00 00       	jmp    802e9c <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802d81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d84:	8b 40 0c             	mov    0xc(%eax),%eax
  802d87:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d8a:	0f 86 d1 00 00 00    	jbe    802e61 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d90:	a1 48 51 80 00       	mov    0x805148,%eax
  802d95:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802d98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9b:	8b 50 08             	mov    0x8(%eax),%edx
  802d9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802da1:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802da4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802da7:	8b 55 08             	mov    0x8(%ebp),%edx
  802daa:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802dad:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802db1:	75 17                	jne    802dca <alloc_block_NF+0x4f9>
  802db3:	83 ec 04             	sub    $0x4,%esp
  802db6:	68 60 41 80 00       	push   $0x804160
  802dbb:	68 1c 01 00 00       	push   $0x11c
  802dc0:	68 b7 40 80 00       	push   $0x8040b7
  802dc5:	e8 20 08 00 00       	call   8035ea <_panic>
  802dca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dcd:	8b 00                	mov    (%eax),%eax
  802dcf:	85 c0                	test   %eax,%eax
  802dd1:	74 10                	je     802de3 <alloc_block_NF+0x512>
  802dd3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd6:	8b 00                	mov    (%eax),%eax
  802dd8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ddb:	8b 52 04             	mov    0x4(%edx),%edx
  802dde:	89 50 04             	mov    %edx,0x4(%eax)
  802de1:	eb 0b                	jmp    802dee <alloc_block_NF+0x51d>
  802de3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802de6:	8b 40 04             	mov    0x4(%eax),%eax
  802de9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802dee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802df1:	8b 40 04             	mov    0x4(%eax),%eax
  802df4:	85 c0                	test   %eax,%eax
  802df6:	74 0f                	je     802e07 <alloc_block_NF+0x536>
  802df8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dfb:	8b 40 04             	mov    0x4(%eax),%eax
  802dfe:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e01:	8b 12                	mov    (%edx),%edx
  802e03:	89 10                	mov    %edx,(%eax)
  802e05:	eb 0a                	jmp    802e11 <alloc_block_NF+0x540>
  802e07:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e0a:	8b 00                	mov    (%eax),%eax
  802e0c:	a3 48 51 80 00       	mov    %eax,0x805148
  802e11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e14:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e1d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e24:	a1 54 51 80 00       	mov    0x805154,%eax
  802e29:	48                   	dec    %eax
  802e2a:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802e2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e32:	8b 40 08             	mov    0x8(%eax),%eax
  802e35:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802e3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3d:	8b 50 08             	mov    0x8(%eax),%edx
  802e40:	8b 45 08             	mov    0x8(%ebp),%eax
  802e43:	01 c2                	add    %eax,%edx
  802e45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e48:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802e4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4e:	8b 40 0c             	mov    0xc(%eax),%eax
  802e51:	2b 45 08             	sub    0x8(%ebp),%eax
  802e54:	89 c2                	mov    %eax,%edx
  802e56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e59:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802e5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e5f:	eb 3b                	jmp    802e9c <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802e61:	a1 40 51 80 00       	mov    0x805140,%eax
  802e66:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e69:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e6d:	74 07                	je     802e76 <alloc_block_NF+0x5a5>
  802e6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e72:	8b 00                	mov    (%eax),%eax
  802e74:	eb 05                	jmp    802e7b <alloc_block_NF+0x5aa>
  802e76:	b8 00 00 00 00       	mov    $0x0,%eax
  802e7b:	a3 40 51 80 00       	mov    %eax,0x805140
  802e80:	a1 40 51 80 00       	mov    0x805140,%eax
  802e85:	85 c0                	test   %eax,%eax
  802e87:	0f 85 2e fe ff ff    	jne    802cbb <alloc_block_NF+0x3ea>
  802e8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e91:	0f 85 24 fe ff ff    	jne    802cbb <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802e97:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e9c:	c9                   	leave  
  802e9d:	c3                   	ret    

00802e9e <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802e9e:	55                   	push   %ebp
  802e9f:	89 e5                	mov    %esp,%ebp
  802ea1:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802ea4:	a1 38 51 80 00       	mov    0x805138,%eax
  802ea9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802eac:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802eb1:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802eb4:	a1 38 51 80 00       	mov    0x805138,%eax
  802eb9:	85 c0                	test   %eax,%eax
  802ebb:	74 14                	je     802ed1 <insert_sorted_with_merge_freeList+0x33>
  802ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec0:	8b 50 08             	mov    0x8(%eax),%edx
  802ec3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec6:	8b 40 08             	mov    0x8(%eax),%eax
  802ec9:	39 c2                	cmp    %eax,%edx
  802ecb:	0f 87 9b 01 00 00    	ja     80306c <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802ed1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ed5:	75 17                	jne    802eee <insert_sorted_with_merge_freeList+0x50>
  802ed7:	83 ec 04             	sub    $0x4,%esp
  802eda:	68 94 40 80 00       	push   $0x804094
  802edf:	68 38 01 00 00       	push   $0x138
  802ee4:	68 b7 40 80 00       	push   $0x8040b7
  802ee9:	e8 fc 06 00 00       	call   8035ea <_panic>
  802eee:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef7:	89 10                	mov    %edx,(%eax)
  802ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  802efc:	8b 00                	mov    (%eax),%eax
  802efe:	85 c0                	test   %eax,%eax
  802f00:	74 0d                	je     802f0f <insert_sorted_with_merge_freeList+0x71>
  802f02:	a1 38 51 80 00       	mov    0x805138,%eax
  802f07:	8b 55 08             	mov    0x8(%ebp),%edx
  802f0a:	89 50 04             	mov    %edx,0x4(%eax)
  802f0d:	eb 08                	jmp    802f17 <insert_sorted_with_merge_freeList+0x79>
  802f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f12:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f17:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1a:	a3 38 51 80 00       	mov    %eax,0x805138
  802f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f22:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f29:	a1 44 51 80 00       	mov    0x805144,%eax
  802f2e:	40                   	inc    %eax
  802f2f:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802f34:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f38:	0f 84 a8 06 00 00    	je     8035e6 <insert_sorted_with_merge_freeList+0x748>
  802f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f41:	8b 50 08             	mov    0x8(%eax),%edx
  802f44:	8b 45 08             	mov    0x8(%ebp),%eax
  802f47:	8b 40 0c             	mov    0xc(%eax),%eax
  802f4a:	01 c2                	add    %eax,%edx
  802f4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f4f:	8b 40 08             	mov    0x8(%eax),%eax
  802f52:	39 c2                	cmp    %eax,%edx
  802f54:	0f 85 8c 06 00 00    	jne    8035e6 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5d:	8b 50 0c             	mov    0xc(%eax),%edx
  802f60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f63:	8b 40 0c             	mov    0xc(%eax),%eax
  802f66:	01 c2                	add    %eax,%edx
  802f68:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6b:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802f6e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f72:	75 17                	jne    802f8b <insert_sorted_with_merge_freeList+0xed>
  802f74:	83 ec 04             	sub    $0x4,%esp
  802f77:	68 60 41 80 00       	push   $0x804160
  802f7c:	68 3c 01 00 00       	push   $0x13c
  802f81:	68 b7 40 80 00       	push   $0x8040b7
  802f86:	e8 5f 06 00 00       	call   8035ea <_panic>
  802f8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f8e:	8b 00                	mov    (%eax),%eax
  802f90:	85 c0                	test   %eax,%eax
  802f92:	74 10                	je     802fa4 <insert_sorted_with_merge_freeList+0x106>
  802f94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f97:	8b 00                	mov    (%eax),%eax
  802f99:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f9c:	8b 52 04             	mov    0x4(%edx),%edx
  802f9f:	89 50 04             	mov    %edx,0x4(%eax)
  802fa2:	eb 0b                	jmp    802faf <insert_sorted_with_merge_freeList+0x111>
  802fa4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fa7:	8b 40 04             	mov    0x4(%eax),%eax
  802faa:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802faf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb2:	8b 40 04             	mov    0x4(%eax),%eax
  802fb5:	85 c0                	test   %eax,%eax
  802fb7:	74 0f                	je     802fc8 <insert_sorted_with_merge_freeList+0x12a>
  802fb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fbc:	8b 40 04             	mov    0x4(%eax),%eax
  802fbf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fc2:	8b 12                	mov    (%edx),%edx
  802fc4:	89 10                	mov    %edx,(%eax)
  802fc6:	eb 0a                	jmp    802fd2 <insert_sorted_with_merge_freeList+0x134>
  802fc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fcb:	8b 00                	mov    (%eax),%eax
  802fcd:	a3 38 51 80 00       	mov    %eax,0x805138
  802fd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fd5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fde:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fe5:	a1 44 51 80 00       	mov    0x805144,%eax
  802fea:	48                   	dec    %eax
  802feb:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802ff0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802ffa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ffd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803004:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803008:	75 17                	jne    803021 <insert_sorted_with_merge_freeList+0x183>
  80300a:	83 ec 04             	sub    $0x4,%esp
  80300d:	68 94 40 80 00       	push   $0x804094
  803012:	68 3f 01 00 00       	push   $0x13f
  803017:	68 b7 40 80 00       	push   $0x8040b7
  80301c:	e8 c9 05 00 00       	call   8035ea <_panic>
  803021:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803027:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80302a:	89 10                	mov    %edx,(%eax)
  80302c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80302f:	8b 00                	mov    (%eax),%eax
  803031:	85 c0                	test   %eax,%eax
  803033:	74 0d                	je     803042 <insert_sorted_with_merge_freeList+0x1a4>
  803035:	a1 48 51 80 00       	mov    0x805148,%eax
  80303a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80303d:	89 50 04             	mov    %edx,0x4(%eax)
  803040:	eb 08                	jmp    80304a <insert_sorted_with_merge_freeList+0x1ac>
  803042:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803045:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80304a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80304d:	a3 48 51 80 00       	mov    %eax,0x805148
  803052:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803055:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80305c:	a1 54 51 80 00       	mov    0x805154,%eax
  803061:	40                   	inc    %eax
  803062:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803067:	e9 7a 05 00 00       	jmp    8035e6 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  80306c:	8b 45 08             	mov    0x8(%ebp),%eax
  80306f:	8b 50 08             	mov    0x8(%eax),%edx
  803072:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803075:	8b 40 08             	mov    0x8(%eax),%eax
  803078:	39 c2                	cmp    %eax,%edx
  80307a:	0f 82 14 01 00 00    	jb     803194 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803080:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803083:	8b 50 08             	mov    0x8(%eax),%edx
  803086:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803089:	8b 40 0c             	mov    0xc(%eax),%eax
  80308c:	01 c2                	add    %eax,%edx
  80308e:	8b 45 08             	mov    0x8(%ebp),%eax
  803091:	8b 40 08             	mov    0x8(%eax),%eax
  803094:	39 c2                	cmp    %eax,%edx
  803096:	0f 85 90 00 00 00    	jne    80312c <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  80309c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80309f:	8b 50 0c             	mov    0xc(%eax),%edx
  8030a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8030a8:	01 c2                	add    %eax,%edx
  8030aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030ad:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  8030b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8030ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8030c4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030c8:	75 17                	jne    8030e1 <insert_sorted_with_merge_freeList+0x243>
  8030ca:	83 ec 04             	sub    $0x4,%esp
  8030cd:	68 94 40 80 00       	push   $0x804094
  8030d2:	68 49 01 00 00       	push   $0x149
  8030d7:	68 b7 40 80 00       	push   $0x8040b7
  8030dc:	e8 09 05 00 00       	call   8035ea <_panic>
  8030e1:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ea:	89 10                	mov    %edx,(%eax)
  8030ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ef:	8b 00                	mov    (%eax),%eax
  8030f1:	85 c0                	test   %eax,%eax
  8030f3:	74 0d                	je     803102 <insert_sorted_with_merge_freeList+0x264>
  8030f5:	a1 48 51 80 00       	mov    0x805148,%eax
  8030fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8030fd:	89 50 04             	mov    %edx,0x4(%eax)
  803100:	eb 08                	jmp    80310a <insert_sorted_with_merge_freeList+0x26c>
  803102:	8b 45 08             	mov    0x8(%ebp),%eax
  803105:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80310a:	8b 45 08             	mov    0x8(%ebp),%eax
  80310d:	a3 48 51 80 00       	mov    %eax,0x805148
  803112:	8b 45 08             	mov    0x8(%ebp),%eax
  803115:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80311c:	a1 54 51 80 00       	mov    0x805154,%eax
  803121:	40                   	inc    %eax
  803122:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803127:	e9 bb 04 00 00       	jmp    8035e7 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  80312c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803130:	75 17                	jne    803149 <insert_sorted_with_merge_freeList+0x2ab>
  803132:	83 ec 04             	sub    $0x4,%esp
  803135:	68 08 41 80 00       	push   $0x804108
  80313a:	68 4c 01 00 00       	push   $0x14c
  80313f:	68 b7 40 80 00       	push   $0x8040b7
  803144:	e8 a1 04 00 00       	call   8035ea <_panic>
  803149:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80314f:	8b 45 08             	mov    0x8(%ebp),%eax
  803152:	89 50 04             	mov    %edx,0x4(%eax)
  803155:	8b 45 08             	mov    0x8(%ebp),%eax
  803158:	8b 40 04             	mov    0x4(%eax),%eax
  80315b:	85 c0                	test   %eax,%eax
  80315d:	74 0c                	je     80316b <insert_sorted_with_merge_freeList+0x2cd>
  80315f:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803164:	8b 55 08             	mov    0x8(%ebp),%edx
  803167:	89 10                	mov    %edx,(%eax)
  803169:	eb 08                	jmp    803173 <insert_sorted_with_merge_freeList+0x2d5>
  80316b:	8b 45 08             	mov    0x8(%ebp),%eax
  80316e:	a3 38 51 80 00       	mov    %eax,0x805138
  803173:	8b 45 08             	mov    0x8(%ebp),%eax
  803176:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80317b:	8b 45 08             	mov    0x8(%ebp),%eax
  80317e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803184:	a1 44 51 80 00       	mov    0x805144,%eax
  803189:	40                   	inc    %eax
  80318a:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80318f:	e9 53 04 00 00       	jmp    8035e7 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803194:	a1 38 51 80 00       	mov    0x805138,%eax
  803199:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80319c:	e9 15 04 00 00       	jmp    8035b6 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8031a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a4:	8b 00                	mov    (%eax),%eax
  8031a6:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8031a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ac:	8b 50 08             	mov    0x8(%eax),%edx
  8031af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b2:	8b 40 08             	mov    0x8(%eax),%eax
  8031b5:	39 c2                	cmp    %eax,%edx
  8031b7:	0f 86 f1 03 00 00    	jbe    8035ae <insert_sorted_with_merge_freeList+0x710>
  8031bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c0:	8b 50 08             	mov    0x8(%eax),%edx
  8031c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c6:	8b 40 08             	mov    0x8(%eax),%eax
  8031c9:	39 c2                	cmp    %eax,%edx
  8031cb:	0f 83 dd 03 00 00    	jae    8035ae <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8031d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d4:	8b 50 08             	mov    0x8(%eax),%edx
  8031d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031da:	8b 40 0c             	mov    0xc(%eax),%eax
  8031dd:	01 c2                	add    %eax,%edx
  8031df:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e2:	8b 40 08             	mov    0x8(%eax),%eax
  8031e5:	39 c2                	cmp    %eax,%edx
  8031e7:	0f 85 b9 01 00 00    	jne    8033a6 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8031ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f0:	8b 50 08             	mov    0x8(%eax),%edx
  8031f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8031f9:	01 c2                	add    %eax,%edx
  8031fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031fe:	8b 40 08             	mov    0x8(%eax),%eax
  803201:	39 c2                	cmp    %eax,%edx
  803203:	0f 85 0d 01 00 00    	jne    803316 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803209:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320c:	8b 50 0c             	mov    0xc(%eax),%edx
  80320f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803212:	8b 40 0c             	mov    0xc(%eax),%eax
  803215:	01 c2                	add    %eax,%edx
  803217:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80321a:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80321d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803221:	75 17                	jne    80323a <insert_sorted_with_merge_freeList+0x39c>
  803223:	83 ec 04             	sub    $0x4,%esp
  803226:	68 60 41 80 00       	push   $0x804160
  80322b:	68 5c 01 00 00       	push   $0x15c
  803230:	68 b7 40 80 00       	push   $0x8040b7
  803235:	e8 b0 03 00 00       	call   8035ea <_panic>
  80323a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80323d:	8b 00                	mov    (%eax),%eax
  80323f:	85 c0                	test   %eax,%eax
  803241:	74 10                	je     803253 <insert_sorted_with_merge_freeList+0x3b5>
  803243:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803246:	8b 00                	mov    (%eax),%eax
  803248:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80324b:	8b 52 04             	mov    0x4(%edx),%edx
  80324e:	89 50 04             	mov    %edx,0x4(%eax)
  803251:	eb 0b                	jmp    80325e <insert_sorted_with_merge_freeList+0x3c0>
  803253:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803256:	8b 40 04             	mov    0x4(%eax),%eax
  803259:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80325e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803261:	8b 40 04             	mov    0x4(%eax),%eax
  803264:	85 c0                	test   %eax,%eax
  803266:	74 0f                	je     803277 <insert_sorted_with_merge_freeList+0x3d9>
  803268:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80326b:	8b 40 04             	mov    0x4(%eax),%eax
  80326e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803271:	8b 12                	mov    (%edx),%edx
  803273:	89 10                	mov    %edx,(%eax)
  803275:	eb 0a                	jmp    803281 <insert_sorted_with_merge_freeList+0x3e3>
  803277:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80327a:	8b 00                	mov    (%eax),%eax
  80327c:	a3 38 51 80 00       	mov    %eax,0x805138
  803281:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803284:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80328a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80328d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803294:	a1 44 51 80 00       	mov    0x805144,%eax
  803299:	48                   	dec    %eax
  80329a:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  80329f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8032a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ac:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8032b3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032b7:	75 17                	jne    8032d0 <insert_sorted_with_merge_freeList+0x432>
  8032b9:	83 ec 04             	sub    $0x4,%esp
  8032bc:	68 94 40 80 00       	push   $0x804094
  8032c1:	68 5f 01 00 00       	push   $0x15f
  8032c6:	68 b7 40 80 00       	push   $0x8040b7
  8032cb:	e8 1a 03 00 00       	call   8035ea <_panic>
  8032d0:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d9:	89 10                	mov    %edx,(%eax)
  8032db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032de:	8b 00                	mov    (%eax),%eax
  8032e0:	85 c0                	test   %eax,%eax
  8032e2:	74 0d                	je     8032f1 <insert_sorted_with_merge_freeList+0x453>
  8032e4:	a1 48 51 80 00       	mov    0x805148,%eax
  8032e9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032ec:	89 50 04             	mov    %edx,0x4(%eax)
  8032ef:	eb 08                	jmp    8032f9 <insert_sorted_with_merge_freeList+0x45b>
  8032f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032fc:	a3 48 51 80 00       	mov    %eax,0x805148
  803301:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803304:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80330b:	a1 54 51 80 00       	mov    0x805154,%eax
  803310:	40                   	inc    %eax
  803311:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803316:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803319:	8b 50 0c             	mov    0xc(%eax),%edx
  80331c:	8b 45 08             	mov    0x8(%ebp),%eax
  80331f:	8b 40 0c             	mov    0xc(%eax),%eax
  803322:	01 c2                	add    %eax,%edx
  803324:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803327:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80332a:	8b 45 08             	mov    0x8(%ebp),%eax
  80332d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803334:	8b 45 08             	mov    0x8(%ebp),%eax
  803337:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80333e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803342:	75 17                	jne    80335b <insert_sorted_with_merge_freeList+0x4bd>
  803344:	83 ec 04             	sub    $0x4,%esp
  803347:	68 94 40 80 00       	push   $0x804094
  80334c:	68 64 01 00 00       	push   $0x164
  803351:	68 b7 40 80 00       	push   $0x8040b7
  803356:	e8 8f 02 00 00       	call   8035ea <_panic>
  80335b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803361:	8b 45 08             	mov    0x8(%ebp),%eax
  803364:	89 10                	mov    %edx,(%eax)
  803366:	8b 45 08             	mov    0x8(%ebp),%eax
  803369:	8b 00                	mov    (%eax),%eax
  80336b:	85 c0                	test   %eax,%eax
  80336d:	74 0d                	je     80337c <insert_sorted_with_merge_freeList+0x4de>
  80336f:	a1 48 51 80 00       	mov    0x805148,%eax
  803374:	8b 55 08             	mov    0x8(%ebp),%edx
  803377:	89 50 04             	mov    %edx,0x4(%eax)
  80337a:	eb 08                	jmp    803384 <insert_sorted_with_merge_freeList+0x4e6>
  80337c:	8b 45 08             	mov    0x8(%ebp),%eax
  80337f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803384:	8b 45 08             	mov    0x8(%ebp),%eax
  803387:	a3 48 51 80 00       	mov    %eax,0x805148
  80338c:	8b 45 08             	mov    0x8(%ebp),%eax
  80338f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803396:	a1 54 51 80 00       	mov    0x805154,%eax
  80339b:	40                   	inc    %eax
  80339c:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8033a1:	e9 41 02 00 00       	jmp    8035e7 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8033a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a9:	8b 50 08             	mov    0x8(%eax),%edx
  8033ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8033af:	8b 40 0c             	mov    0xc(%eax),%eax
  8033b2:	01 c2                	add    %eax,%edx
  8033b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b7:	8b 40 08             	mov    0x8(%eax),%eax
  8033ba:	39 c2                	cmp    %eax,%edx
  8033bc:	0f 85 7c 01 00 00    	jne    80353e <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8033c2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033c6:	74 06                	je     8033ce <insert_sorted_with_merge_freeList+0x530>
  8033c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033cc:	75 17                	jne    8033e5 <insert_sorted_with_merge_freeList+0x547>
  8033ce:	83 ec 04             	sub    $0x4,%esp
  8033d1:	68 d0 40 80 00       	push   $0x8040d0
  8033d6:	68 69 01 00 00       	push   $0x169
  8033db:	68 b7 40 80 00       	push   $0x8040b7
  8033e0:	e8 05 02 00 00       	call   8035ea <_panic>
  8033e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e8:	8b 50 04             	mov    0x4(%eax),%edx
  8033eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ee:	89 50 04             	mov    %edx,0x4(%eax)
  8033f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033f7:	89 10                	mov    %edx,(%eax)
  8033f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033fc:	8b 40 04             	mov    0x4(%eax),%eax
  8033ff:	85 c0                	test   %eax,%eax
  803401:	74 0d                	je     803410 <insert_sorted_with_merge_freeList+0x572>
  803403:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803406:	8b 40 04             	mov    0x4(%eax),%eax
  803409:	8b 55 08             	mov    0x8(%ebp),%edx
  80340c:	89 10                	mov    %edx,(%eax)
  80340e:	eb 08                	jmp    803418 <insert_sorted_with_merge_freeList+0x57a>
  803410:	8b 45 08             	mov    0x8(%ebp),%eax
  803413:	a3 38 51 80 00       	mov    %eax,0x805138
  803418:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80341b:	8b 55 08             	mov    0x8(%ebp),%edx
  80341e:	89 50 04             	mov    %edx,0x4(%eax)
  803421:	a1 44 51 80 00       	mov    0x805144,%eax
  803426:	40                   	inc    %eax
  803427:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  80342c:	8b 45 08             	mov    0x8(%ebp),%eax
  80342f:	8b 50 0c             	mov    0xc(%eax),%edx
  803432:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803435:	8b 40 0c             	mov    0xc(%eax),%eax
  803438:	01 c2                	add    %eax,%edx
  80343a:	8b 45 08             	mov    0x8(%ebp),%eax
  80343d:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803440:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803444:	75 17                	jne    80345d <insert_sorted_with_merge_freeList+0x5bf>
  803446:	83 ec 04             	sub    $0x4,%esp
  803449:	68 60 41 80 00       	push   $0x804160
  80344e:	68 6b 01 00 00       	push   $0x16b
  803453:	68 b7 40 80 00       	push   $0x8040b7
  803458:	e8 8d 01 00 00       	call   8035ea <_panic>
  80345d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803460:	8b 00                	mov    (%eax),%eax
  803462:	85 c0                	test   %eax,%eax
  803464:	74 10                	je     803476 <insert_sorted_with_merge_freeList+0x5d8>
  803466:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803469:	8b 00                	mov    (%eax),%eax
  80346b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80346e:	8b 52 04             	mov    0x4(%edx),%edx
  803471:	89 50 04             	mov    %edx,0x4(%eax)
  803474:	eb 0b                	jmp    803481 <insert_sorted_with_merge_freeList+0x5e3>
  803476:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803479:	8b 40 04             	mov    0x4(%eax),%eax
  80347c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803481:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803484:	8b 40 04             	mov    0x4(%eax),%eax
  803487:	85 c0                	test   %eax,%eax
  803489:	74 0f                	je     80349a <insert_sorted_with_merge_freeList+0x5fc>
  80348b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80348e:	8b 40 04             	mov    0x4(%eax),%eax
  803491:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803494:	8b 12                	mov    (%edx),%edx
  803496:	89 10                	mov    %edx,(%eax)
  803498:	eb 0a                	jmp    8034a4 <insert_sorted_with_merge_freeList+0x606>
  80349a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80349d:	8b 00                	mov    (%eax),%eax
  80349f:	a3 38 51 80 00       	mov    %eax,0x805138
  8034a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034b0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034b7:	a1 44 51 80 00       	mov    0x805144,%eax
  8034bc:	48                   	dec    %eax
  8034bd:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8034c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034c5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8034cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034cf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8034d6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8034da:	75 17                	jne    8034f3 <insert_sorted_with_merge_freeList+0x655>
  8034dc:	83 ec 04             	sub    $0x4,%esp
  8034df:	68 94 40 80 00       	push   $0x804094
  8034e4:	68 6e 01 00 00       	push   $0x16e
  8034e9:	68 b7 40 80 00       	push   $0x8040b7
  8034ee:	e8 f7 00 00 00       	call   8035ea <_panic>
  8034f3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034fc:	89 10                	mov    %edx,(%eax)
  8034fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803501:	8b 00                	mov    (%eax),%eax
  803503:	85 c0                	test   %eax,%eax
  803505:	74 0d                	je     803514 <insert_sorted_with_merge_freeList+0x676>
  803507:	a1 48 51 80 00       	mov    0x805148,%eax
  80350c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80350f:	89 50 04             	mov    %edx,0x4(%eax)
  803512:	eb 08                	jmp    80351c <insert_sorted_with_merge_freeList+0x67e>
  803514:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803517:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80351c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80351f:	a3 48 51 80 00       	mov    %eax,0x805148
  803524:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803527:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80352e:	a1 54 51 80 00       	mov    0x805154,%eax
  803533:	40                   	inc    %eax
  803534:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803539:	e9 a9 00 00 00       	jmp    8035e7 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  80353e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803542:	74 06                	je     80354a <insert_sorted_with_merge_freeList+0x6ac>
  803544:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803548:	75 17                	jne    803561 <insert_sorted_with_merge_freeList+0x6c3>
  80354a:	83 ec 04             	sub    $0x4,%esp
  80354d:	68 2c 41 80 00       	push   $0x80412c
  803552:	68 73 01 00 00       	push   $0x173
  803557:	68 b7 40 80 00       	push   $0x8040b7
  80355c:	e8 89 00 00 00       	call   8035ea <_panic>
  803561:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803564:	8b 10                	mov    (%eax),%edx
  803566:	8b 45 08             	mov    0x8(%ebp),%eax
  803569:	89 10                	mov    %edx,(%eax)
  80356b:	8b 45 08             	mov    0x8(%ebp),%eax
  80356e:	8b 00                	mov    (%eax),%eax
  803570:	85 c0                	test   %eax,%eax
  803572:	74 0b                	je     80357f <insert_sorted_with_merge_freeList+0x6e1>
  803574:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803577:	8b 00                	mov    (%eax),%eax
  803579:	8b 55 08             	mov    0x8(%ebp),%edx
  80357c:	89 50 04             	mov    %edx,0x4(%eax)
  80357f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803582:	8b 55 08             	mov    0x8(%ebp),%edx
  803585:	89 10                	mov    %edx,(%eax)
  803587:	8b 45 08             	mov    0x8(%ebp),%eax
  80358a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80358d:	89 50 04             	mov    %edx,0x4(%eax)
  803590:	8b 45 08             	mov    0x8(%ebp),%eax
  803593:	8b 00                	mov    (%eax),%eax
  803595:	85 c0                	test   %eax,%eax
  803597:	75 08                	jne    8035a1 <insert_sorted_with_merge_freeList+0x703>
  803599:	8b 45 08             	mov    0x8(%ebp),%eax
  80359c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8035a1:	a1 44 51 80 00       	mov    0x805144,%eax
  8035a6:	40                   	inc    %eax
  8035a7:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8035ac:	eb 39                	jmp    8035e7 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8035ae:	a1 40 51 80 00       	mov    0x805140,%eax
  8035b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035ba:	74 07                	je     8035c3 <insert_sorted_with_merge_freeList+0x725>
  8035bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035bf:	8b 00                	mov    (%eax),%eax
  8035c1:	eb 05                	jmp    8035c8 <insert_sorted_with_merge_freeList+0x72a>
  8035c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8035c8:	a3 40 51 80 00       	mov    %eax,0x805140
  8035cd:	a1 40 51 80 00       	mov    0x805140,%eax
  8035d2:	85 c0                	test   %eax,%eax
  8035d4:	0f 85 c7 fb ff ff    	jne    8031a1 <insert_sorted_with_merge_freeList+0x303>
  8035da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035de:	0f 85 bd fb ff ff    	jne    8031a1 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8035e4:	eb 01                	jmp    8035e7 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8035e6:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8035e7:	90                   	nop
  8035e8:	c9                   	leave  
  8035e9:	c3                   	ret    

008035ea <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8035ea:	55                   	push   %ebp
  8035eb:	89 e5                	mov    %esp,%ebp
  8035ed:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8035f0:	8d 45 10             	lea    0x10(%ebp),%eax
  8035f3:	83 c0 04             	add    $0x4,%eax
  8035f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8035f9:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8035fe:	85 c0                	test   %eax,%eax
  803600:	74 16                	je     803618 <_panic+0x2e>
		cprintf("%s: ", argv0);
  803602:	a1 5c 51 80 00       	mov    0x80515c,%eax
  803607:	83 ec 08             	sub    $0x8,%esp
  80360a:	50                   	push   %eax
  80360b:	68 80 41 80 00       	push   $0x804180
  803610:	e8 6e d0 ff ff       	call   800683 <cprintf>
  803615:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803618:	a1 00 50 80 00       	mov    0x805000,%eax
  80361d:	ff 75 0c             	pushl  0xc(%ebp)
  803620:	ff 75 08             	pushl  0x8(%ebp)
  803623:	50                   	push   %eax
  803624:	68 85 41 80 00       	push   $0x804185
  803629:	e8 55 d0 ff ff       	call   800683 <cprintf>
  80362e:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803631:	8b 45 10             	mov    0x10(%ebp),%eax
  803634:	83 ec 08             	sub    $0x8,%esp
  803637:	ff 75 f4             	pushl  -0xc(%ebp)
  80363a:	50                   	push   %eax
  80363b:	e8 d8 cf ff ff       	call   800618 <vcprintf>
  803640:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803643:	83 ec 08             	sub    $0x8,%esp
  803646:	6a 00                	push   $0x0
  803648:	68 a1 41 80 00       	push   $0x8041a1
  80364d:	e8 c6 cf ff ff       	call   800618 <vcprintf>
  803652:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803655:	e8 47 cf ff ff       	call   8005a1 <exit>

	// should not return here
	while (1) ;
  80365a:	eb fe                	jmp    80365a <_panic+0x70>

0080365c <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80365c:	55                   	push   %ebp
  80365d:	89 e5                	mov    %esp,%ebp
  80365f:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803662:	a1 20 50 80 00       	mov    0x805020,%eax
  803667:	8b 50 74             	mov    0x74(%eax),%edx
  80366a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80366d:	39 c2                	cmp    %eax,%edx
  80366f:	74 14                	je     803685 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803671:	83 ec 04             	sub    $0x4,%esp
  803674:	68 a4 41 80 00       	push   $0x8041a4
  803679:	6a 26                	push   $0x26
  80367b:	68 f0 41 80 00       	push   $0x8041f0
  803680:	e8 65 ff ff ff       	call   8035ea <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803685:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80368c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803693:	e9 c2 00 00 00       	jmp    80375a <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  803698:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80369b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8036a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a5:	01 d0                	add    %edx,%eax
  8036a7:	8b 00                	mov    (%eax),%eax
  8036a9:	85 c0                	test   %eax,%eax
  8036ab:	75 08                	jne    8036b5 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8036ad:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8036b0:	e9 a2 00 00 00       	jmp    803757 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8036b5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8036bc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8036c3:	eb 69                	jmp    80372e <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8036c5:	a1 20 50 80 00       	mov    0x805020,%eax
  8036ca:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8036d0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036d3:	89 d0                	mov    %edx,%eax
  8036d5:	01 c0                	add    %eax,%eax
  8036d7:	01 d0                	add    %edx,%eax
  8036d9:	c1 e0 03             	shl    $0x3,%eax
  8036dc:	01 c8                	add    %ecx,%eax
  8036de:	8a 40 04             	mov    0x4(%eax),%al
  8036e1:	84 c0                	test   %al,%al
  8036e3:	75 46                	jne    80372b <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8036e5:	a1 20 50 80 00       	mov    0x805020,%eax
  8036ea:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8036f0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036f3:	89 d0                	mov    %edx,%eax
  8036f5:	01 c0                	add    %eax,%eax
  8036f7:	01 d0                	add    %edx,%eax
  8036f9:	c1 e0 03             	shl    $0x3,%eax
  8036fc:	01 c8                	add    %ecx,%eax
  8036fe:	8b 00                	mov    (%eax),%eax
  803700:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803703:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803706:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80370b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80370d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803710:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803717:	8b 45 08             	mov    0x8(%ebp),%eax
  80371a:	01 c8                	add    %ecx,%eax
  80371c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80371e:	39 c2                	cmp    %eax,%edx
  803720:	75 09                	jne    80372b <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  803722:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803729:	eb 12                	jmp    80373d <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80372b:	ff 45 e8             	incl   -0x18(%ebp)
  80372e:	a1 20 50 80 00       	mov    0x805020,%eax
  803733:	8b 50 74             	mov    0x74(%eax),%edx
  803736:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803739:	39 c2                	cmp    %eax,%edx
  80373b:	77 88                	ja     8036c5 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80373d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803741:	75 14                	jne    803757 <CheckWSWithoutLastIndex+0xfb>
			panic(
  803743:	83 ec 04             	sub    $0x4,%esp
  803746:	68 fc 41 80 00       	push   $0x8041fc
  80374b:	6a 3a                	push   $0x3a
  80374d:	68 f0 41 80 00       	push   $0x8041f0
  803752:	e8 93 fe ff ff       	call   8035ea <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803757:	ff 45 f0             	incl   -0x10(%ebp)
  80375a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80375d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803760:	0f 8c 32 ff ff ff    	jl     803698 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803766:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80376d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803774:	eb 26                	jmp    80379c <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803776:	a1 20 50 80 00       	mov    0x805020,%eax
  80377b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803781:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803784:	89 d0                	mov    %edx,%eax
  803786:	01 c0                	add    %eax,%eax
  803788:	01 d0                	add    %edx,%eax
  80378a:	c1 e0 03             	shl    $0x3,%eax
  80378d:	01 c8                	add    %ecx,%eax
  80378f:	8a 40 04             	mov    0x4(%eax),%al
  803792:	3c 01                	cmp    $0x1,%al
  803794:	75 03                	jne    803799 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  803796:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803799:	ff 45 e0             	incl   -0x20(%ebp)
  80379c:	a1 20 50 80 00       	mov    0x805020,%eax
  8037a1:	8b 50 74             	mov    0x74(%eax),%edx
  8037a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037a7:	39 c2                	cmp    %eax,%edx
  8037a9:	77 cb                	ja     803776 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8037ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ae:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8037b1:	74 14                	je     8037c7 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8037b3:	83 ec 04             	sub    $0x4,%esp
  8037b6:	68 50 42 80 00       	push   $0x804250
  8037bb:	6a 44                	push   $0x44
  8037bd:	68 f0 41 80 00       	push   $0x8041f0
  8037c2:	e8 23 fe ff ff       	call   8035ea <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8037c7:	90                   	nop
  8037c8:	c9                   	leave  
  8037c9:	c3                   	ret    
  8037ca:	66 90                	xchg   %ax,%ax

008037cc <__udivdi3>:
  8037cc:	55                   	push   %ebp
  8037cd:	57                   	push   %edi
  8037ce:	56                   	push   %esi
  8037cf:	53                   	push   %ebx
  8037d0:	83 ec 1c             	sub    $0x1c,%esp
  8037d3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8037d7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8037db:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8037df:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8037e3:	89 ca                	mov    %ecx,%edx
  8037e5:	89 f8                	mov    %edi,%eax
  8037e7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8037eb:	85 f6                	test   %esi,%esi
  8037ed:	75 2d                	jne    80381c <__udivdi3+0x50>
  8037ef:	39 cf                	cmp    %ecx,%edi
  8037f1:	77 65                	ja     803858 <__udivdi3+0x8c>
  8037f3:	89 fd                	mov    %edi,%ebp
  8037f5:	85 ff                	test   %edi,%edi
  8037f7:	75 0b                	jne    803804 <__udivdi3+0x38>
  8037f9:	b8 01 00 00 00       	mov    $0x1,%eax
  8037fe:	31 d2                	xor    %edx,%edx
  803800:	f7 f7                	div    %edi
  803802:	89 c5                	mov    %eax,%ebp
  803804:	31 d2                	xor    %edx,%edx
  803806:	89 c8                	mov    %ecx,%eax
  803808:	f7 f5                	div    %ebp
  80380a:	89 c1                	mov    %eax,%ecx
  80380c:	89 d8                	mov    %ebx,%eax
  80380e:	f7 f5                	div    %ebp
  803810:	89 cf                	mov    %ecx,%edi
  803812:	89 fa                	mov    %edi,%edx
  803814:	83 c4 1c             	add    $0x1c,%esp
  803817:	5b                   	pop    %ebx
  803818:	5e                   	pop    %esi
  803819:	5f                   	pop    %edi
  80381a:	5d                   	pop    %ebp
  80381b:	c3                   	ret    
  80381c:	39 ce                	cmp    %ecx,%esi
  80381e:	77 28                	ja     803848 <__udivdi3+0x7c>
  803820:	0f bd fe             	bsr    %esi,%edi
  803823:	83 f7 1f             	xor    $0x1f,%edi
  803826:	75 40                	jne    803868 <__udivdi3+0x9c>
  803828:	39 ce                	cmp    %ecx,%esi
  80382a:	72 0a                	jb     803836 <__udivdi3+0x6a>
  80382c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803830:	0f 87 9e 00 00 00    	ja     8038d4 <__udivdi3+0x108>
  803836:	b8 01 00 00 00       	mov    $0x1,%eax
  80383b:	89 fa                	mov    %edi,%edx
  80383d:	83 c4 1c             	add    $0x1c,%esp
  803840:	5b                   	pop    %ebx
  803841:	5e                   	pop    %esi
  803842:	5f                   	pop    %edi
  803843:	5d                   	pop    %ebp
  803844:	c3                   	ret    
  803845:	8d 76 00             	lea    0x0(%esi),%esi
  803848:	31 ff                	xor    %edi,%edi
  80384a:	31 c0                	xor    %eax,%eax
  80384c:	89 fa                	mov    %edi,%edx
  80384e:	83 c4 1c             	add    $0x1c,%esp
  803851:	5b                   	pop    %ebx
  803852:	5e                   	pop    %esi
  803853:	5f                   	pop    %edi
  803854:	5d                   	pop    %ebp
  803855:	c3                   	ret    
  803856:	66 90                	xchg   %ax,%ax
  803858:	89 d8                	mov    %ebx,%eax
  80385a:	f7 f7                	div    %edi
  80385c:	31 ff                	xor    %edi,%edi
  80385e:	89 fa                	mov    %edi,%edx
  803860:	83 c4 1c             	add    $0x1c,%esp
  803863:	5b                   	pop    %ebx
  803864:	5e                   	pop    %esi
  803865:	5f                   	pop    %edi
  803866:	5d                   	pop    %ebp
  803867:	c3                   	ret    
  803868:	bd 20 00 00 00       	mov    $0x20,%ebp
  80386d:	89 eb                	mov    %ebp,%ebx
  80386f:	29 fb                	sub    %edi,%ebx
  803871:	89 f9                	mov    %edi,%ecx
  803873:	d3 e6                	shl    %cl,%esi
  803875:	89 c5                	mov    %eax,%ebp
  803877:	88 d9                	mov    %bl,%cl
  803879:	d3 ed                	shr    %cl,%ebp
  80387b:	89 e9                	mov    %ebp,%ecx
  80387d:	09 f1                	or     %esi,%ecx
  80387f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803883:	89 f9                	mov    %edi,%ecx
  803885:	d3 e0                	shl    %cl,%eax
  803887:	89 c5                	mov    %eax,%ebp
  803889:	89 d6                	mov    %edx,%esi
  80388b:	88 d9                	mov    %bl,%cl
  80388d:	d3 ee                	shr    %cl,%esi
  80388f:	89 f9                	mov    %edi,%ecx
  803891:	d3 e2                	shl    %cl,%edx
  803893:	8b 44 24 08          	mov    0x8(%esp),%eax
  803897:	88 d9                	mov    %bl,%cl
  803899:	d3 e8                	shr    %cl,%eax
  80389b:	09 c2                	or     %eax,%edx
  80389d:	89 d0                	mov    %edx,%eax
  80389f:	89 f2                	mov    %esi,%edx
  8038a1:	f7 74 24 0c          	divl   0xc(%esp)
  8038a5:	89 d6                	mov    %edx,%esi
  8038a7:	89 c3                	mov    %eax,%ebx
  8038a9:	f7 e5                	mul    %ebp
  8038ab:	39 d6                	cmp    %edx,%esi
  8038ad:	72 19                	jb     8038c8 <__udivdi3+0xfc>
  8038af:	74 0b                	je     8038bc <__udivdi3+0xf0>
  8038b1:	89 d8                	mov    %ebx,%eax
  8038b3:	31 ff                	xor    %edi,%edi
  8038b5:	e9 58 ff ff ff       	jmp    803812 <__udivdi3+0x46>
  8038ba:	66 90                	xchg   %ax,%ax
  8038bc:	8b 54 24 08          	mov    0x8(%esp),%edx
  8038c0:	89 f9                	mov    %edi,%ecx
  8038c2:	d3 e2                	shl    %cl,%edx
  8038c4:	39 c2                	cmp    %eax,%edx
  8038c6:	73 e9                	jae    8038b1 <__udivdi3+0xe5>
  8038c8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8038cb:	31 ff                	xor    %edi,%edi
  8038cd:	e9 40 ff ff ff       	jmp    803812 <__udivdi3+0x46>
  8038d2:	66 90                	xchg   %ax,%ax
  8038d4:	31 c0                	xor    %eax,%eax
  8038d6:	e9 37 ff ff ff       	jmp    803812 <__udivdi3+0x46>
  8038db:	90                   	nop

008038dc <__umoddi3>:
  8038dc:	55                   	push   %ebp
  8038dd:	57                   	push   %edi
  8038de:	56                   	push   %esi
  8038df:	53                   	push   %ebx
  8038e0:	83 ec 1c             	sub    $0x1c,%esp
  8038e3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8038e7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8038eb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8038ef:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8038f3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8038f7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8038fb:	89 f3                	mov    %esi,%ebx
  8038fd:	89 fa                	mov    %edi,%edx
  8038ff:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803903:	89 34 24             	mov    %esi,(%esp)
  803906:	85 c0                	test   %eax,%eax
  803908:	75 1a                	jne    803924 <__umoddi3+0x48>
  80390a:	39 f7                	cmp    %esi,%edi
  80390c:	0f 86 a2 00 00 00    	jbe    8039b4 <__umoddi3+0xd8>
  803912:	89 c8                	mov    %ecx,%eax
  803914:	89 f2                	mov    %esi,%edx
  803916:	f7 f7                	div    %edi
  803918:	89 d0                	mov    %edx,%eax
  80391a:	31 d2                	xor    %edx,%edx
  80391c:	83 c4 1c             	add    $0x1c,%esp
  80391f:	5b                   	pop    %ebx
  803920:	5e                   	pop    %esi
  803921:	5f                   	pop    %edi
  803922:	5d                   	pop    %ebp
  803923:	c3                   	ret    
  803924:	39 f0                	cmp    %esi,%eax
  803926:	0f 87 ac 00 00 00    	ja     8039d8 <__umoddi3+0xfc>
  80392c:	0f bd e8             	bsr    %eax,%ebp
  80392f:	83 f5 1f             	xor    $0x1f,%ebp
  803932:	0f 84 ac 00 00 00    	je     8039e4 <__umoddi3+0x108>
  803938:	bf 20 00 00 00       	mov    $0x20,%edi
  80393d:	29 ef                	sub    %ebp,%edi
  80393f:	89 fe                	mov    %edi,%esi
  803941:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803945:	89 e9                	mov    %ebp,%ecx
  803947:	d3 e0                	shl    %cl,%eax
  803949:	89 d7                	mov    %edx,%edi
  80394b:	89 f1                	mov    %esi,%ecx
  80394d:	d3 ef                	shr    %cl,%edi
  80394f:	09 c7                	or     %eax,%edi
  803951:	89 e9                	mov    %ebp,%ecx
  803953:	d3 e2                	shl    %cl,%edx
  803955:	89 14 24             	mov    %edx,(%esp)
  803958:	89 d8                	mov    %ebx,%eax
  80395a:	d3 e0                	shl    %cl,%eax
  80395c:	89 c2                	mov    %eax,%edx
  80395e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803962:	d3 e0                	shl    %cl,%eax
  803964:	89 44 24 04          	mov    %eax,0x4(%esp)
  803968:	8b 44 24 08          	mov    0x8(%esp),%eax
  80396c:	89 f1                	mov    %esi,%ecx
  80396e:	d3 e8                	shr    %cl,%eax
  803970:	09 d0                	or     %edx,%eax
  803972:	d3 eb                	shr    %cl,%ebx
  803974:	89 da                	mov    %ebx,%edx
  803976:	f7 f7                	div    %edi
  803978:	89 d3                	mov    %edx,%ebx
  80397a:	f7 24 24             	mull   (%esp)
  80397d:	89 c6                	mov    %eax,%esi
  80397f:	89 d1                	mov    %edx,%ecx
  803981:	39 d3                	cmp    %edx,%ebx
  803983:	0f 82 87 00 00 00    	jb     803a10 <__umoddi3+0x134>
  803989:	0f 84 91 00 00 00    	je     803a20 <__umoddi3+0x144>
  80398f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803993:	29 f2                	sub    %esi,%edx
  803995:	19 cb                	sbb    %ecx,%ebx
  803997:	89 d8                	mov    %ebx,%eax
  803999:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80399d:	d3 e0                	shl    %cl,%eax
  80399f:	89 e9                	mov    %ebp,%ecx
  8039a1:	d3 ea                	shr    %cl,%edx
  8039a3:	09 d0                	or     %edx,%eax
  8039a5:	89 e9                	mov    %ebp,%ecx
  8039a7:	d3 eb                	shr    %cl,%ebx
  8039a9:	89 da                	mov    %ebx,%edx
  8039ab:	83 c4 1c             	add    $0x1c,%esp
  8039ae:	5b                   	pop    %ebx
  8039af:	5e                   	pop    %esi
  8039b0:	5f                   	pop    %edi
  8039b1:	5d                   	pop    %ebp
  8039b2:	c3                   	ret    
  8039b3:	90                   	nop
  8039b4:	89 fd                	mov    %edi,%ebp
  8039b6:	85 ff                	test   %edi,%edi
  8039b8:	75 0b                	jne    8039c5 <__umoddi3+0xe9>
  8039ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8039bf:	31 d2                	xor    %edx,%edx
  8039c1:	f7 f7                	div    %edi
  8039c3:	89 c5                	mov    %eax,%ebp
  8039c5:	89 f0                	mov    %esi,%eax
  8039c7:	31 d2                	xor    %edx,%edx
  8039c9:	f7 f5                	div    %ebp
  8039cb:	89 c8                	mov    %ecx,%eax
  8039cd:	f7 f5                	div    %ebp
  8039cf:	89 d0                	mov    %edx,%eax
  8039d1:	e9 44 ff ff ff       	jmp    80391a <__umoddi3+0x3e>
  8039d6:	66 90                	xchg   %ax,%ax
  8039d8:	89 c8                	mov    %ecx,%eax
  8039da:	89 f2                	mov    %esi,%edx
  8039dc:	83 c4 1c             	add    $0x1c,%esp
  8039df:	5b                   	pop    %ebx
  8039e0:	5e                   	pop    %esi
  8039e1:	5f                   	pop    %edi
  8039e2:	5d                   	pop    %ebp
  8039e3:	c3                   	ret    
  8039e4:	3b 04 24             	cmp    (%esp),%eax
  8039e7:	72 06                	jb     8039ef <__umoddi3+0x113>
  8039e9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8039ed:	77 0f                	ja     8039fe <__umoddi3+0x122>
  8039ef:	89 f2                	mov    %esi,%edx
  8039f1:	29 f9                	sub    %edi,%ecx
  8039f3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8039f7:	89 14 24             	mov    %edx,(%esp)
  8039fa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8039fe:	8b 44 24 04          	mov    0x4(%esp),%eax
  803a02:	8b 14 24             	mov    (%esp),%edx
  803a05:	83 c4 1c             	add    $0x1c,%esp
  803a08:	5b                   	pop    %ebx
  803a09:	5e                   	pop    %esi
  803a0a:	5f                   	pop    %edi
  803a0b:	5d                   	pop    %ebp
  803a0c:	c3                   	ret    
  803a0d:	8d 76 00             	lea    0x0(%esi),%esi
  803a10:	2b 04 24             	sub    (%esp),%eax
  803a13:	19 fa                	sbb    %edi,%edx
  803a15:	89 d1                	mov    %edx,%ecx
  803a17:	89 c6                	mov    %eax,%esi
  803a19:	e9 71 ff ff ff       	jmp    80398f <__umoddi3+0xb3>
  803a1e:	66 90                	xchg   %ax,%ax
  803a20:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803a24:	72 ea                	jb     803a10 <__umoddi3+0x134>
  803a26:	89 d9                	mov    %ebx,%ecx
  803a28:	e9 62 ff ff ff       	jmp    80398f <__umoddi3+0xb3>
