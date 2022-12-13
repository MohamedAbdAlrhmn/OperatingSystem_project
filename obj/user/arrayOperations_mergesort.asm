
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
  80003e:	e8 6e 1b 00 00       	call   801bb1 <sys_getparentenvid>
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
  800057:	68 c0 38 80 00       	push   $0x8038c0
  80005c:	ff 75 f0             	pushl  -0x10(%ebp)
  80005f:	e8 b0 16 00 00       	call   801714 <sget>
  800064:	83 c4 10             	add    $0x10,%esp
  800067:	89 45 e8             	mov    %eax,-0x18(%ebp)
	numOfElements = sget(parentenvID, "arrSize") ;
  80006a:	83 ec 08             	sub    $0x8,%esp
  80006d:	68 c4 38 80 00       	push   $0x8038c4
  800072:	ff 75 f0             	pushl  -0x10(%ebp)
  800075:	e8 9a 16 00 00       	call   801714 <sget>
  80007a:	83 c4 10             	add    $0x10,%esp
  80007d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//PrintElements(sharedArray, *numOfElements);

	//Get the check-finishing counter
	int *finishedCount = NULL;
  800080:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	finishedCount = sget(parentenvID, "finishedCount") ;
  800087:	83 ec 08             	sub    $0x8,%esp
  80008a:	68 cc 38 80 00       	push   $0x8038cc
  80008f:	ff 75 f0             	pushl  -0x10(%ebp)
  800092:	e8 7d 16 00 00       	call   801714 <sget>
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
  8000ab:	68 da 38 80 00       	push   $0x8038da
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
  80010c:	68 e9 38 80 00       	push   $0x8038e9
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
  8001a2:	68 05 39 80 00       	push   $0x803905
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
  8001c4:	68 07 39 80 00       	push   $0x803907
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
  8001f2:	68 0c 39 80 00       	push   $0x80390c
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
  800479:	e8 1a 17 00 00       	call   801b98 <sys_getenvindex>
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
  8004e4:	e8 bc 14 00 00       	call   8019a5 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8004e9:	83 ec 0c             	sub    $0xc,%esp
  8004ec:	68 28 39 80 00       	push   $0x803928
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
  800514:	68 50 39 80 00       	push   $0x803950
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
  800545:	68 78 39 80 00       	push   $0x803978
  80054a:	e8 34 01 00 00       	call   800683 <cprintf>
  80054f:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800552:	a1 20 50 80 00       	mov    0x805020,%eax
  800557:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80055d:	83 ec 08             	sub    $0x8,%esp
  800560:	50                   	push   %eax
  800561:	68 d0 39 80 00       	push   $0x8039d0
  800566:	e8 18 01 00 00       	call   800683 <cprintf>
  80056b:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80056e:	83 ec 0c             	sub    $0xc,%esp
  800571:	68 28 39 80 00       	push   $0x803928
  800576:	e8 08 01 00 00       	call   800683 <cprintf>
  80057b:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80057e:	e8 3c 14 00 00       	call   8019bf <sys_enable_interrupt>

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
  800596:	e8 c9 15 00 00       	call   801b64 <sys_destroy_env>
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
  8005a7:	e8 1e 16 00 00       	call   801bca <sys_exit_env>
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
  8005f5:	e8 fd 11 00 00       	call   8017f7 <sys_cputs>
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
  80066c:	e8 86 11 00 00       	call   8017f7 <sys_cputs>
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
  8006b6:	e8 ea 12 00 00       	call   8019a5 <sys_disable_interrupt>
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
  8006d6:	e8 e4 12 00 00       	call   8019bf <sys_enable_interrupt>
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
  800720:	e8 37 2f 00 00       	call   80365c <__udivdi3>
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
  800770:	e8 f7 2f 00 00       	call   80376c <__umoddi3>
  800775:	83 c4 10             	add    $0x10,%esp
  800778:	05 14 3c 80 00       	add    $0x803c14,%eax
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
  8008cb:	8b 04 85 38 3c 80 00 	mov    0x803c38(,%eax,4),%eax
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
  8009ac:	8b 34 9d 80 3a 80 00 	mov    0x803a80(,%ebx,4),%esi
  8009b3:	85 f6                	test   %esi,%esi
  8009b5:	75 19                	jne    8009d0 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009b7:	53                   	push   %ebx
  8009b8:	68 25 3c 80 00       	push   $0x803c25
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
  8009d1:	68 2e 3c 80 00       	push   $0x803c2e
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
  8009fe:	be 31 3c 80 00       	mov    $0x803c31,%esi
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
  801424:	68 90 3d 80 00       	push   $0x803d90
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
  8014f4:	e8 42 04 00 00       	call   80193b <sys_allocate_chunk>
  8014f9:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8014fc:	a1 20 51 80 00       	mov    0x805120,%eax
  801501:	83 ec 0c             	sub    $0xc,%esp
  801504:	50                   	push   %eax
  801505:	e8 b7 0a 00 00       	call   801fc1 <initialize_MemBlocksList>
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
  801532:	68 b5 3d 80 00       	push   $0x803db5
  801537:	6a 33                	push   $0x33
  801539:	68 d3 3d 80 00       	push   $0x803dd3
  80153e:	e8 37 1f 00 00       	call   80347a <_panic>
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
  8015b1:	68 e0 3d 80 00       	push   $0x803de0
  8015b6:	6a 34                	push   $0x34
  8015b8:	68 d3 3d 80 00       	push   $0x803dd3
  8015bd:	e8 b8 1e 00 00       	call   80347a <_panic>
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
  801626:	68 04 3e 80 00       	push   $0x803e04
  80162b:	6a 46                	push   $0x46
  80162d:	68 d3 3d 80 00       	push   $0x803dd3
  801632:	e8 43 1e 00 00       	call   80347a <_panic>
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
  801642:	68 2c 3e 80 00       	push   $0x803e2c
  801647:	6a 61                	push   $0x61
  801649:	68 d3 3d 80 00       	push   $0x803dd3
  80164e:	e8 27 1e 00 00       	call   80347a <_panic>

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
  801668:	75 0a                	jne    801674 <smalloc+0x21>
  80166a:	b8 00 00 00 00       	mov    $0x0,%eax
  80166f:	e9 9e 00 00 00       	jmp    801712 <smalloc+0xbf>
	//3-If the Kernel successfully creates the shared variable, return its virtual address
	//4-Else, return NULL



	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801674:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80167b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80167e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801681:	01 d0                	add    %edx,%eax
  801683:	48                   	dec    %eax
  801684:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801687:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80168a:	ba 00 00 00 00       	mov    $0x0,%edx
  80168f:	f7 75 f0             	divl   -0x10(%ebp)
  801692:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801695:	29 d0                	sub    %edx,%eax
  801697:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  80169a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8016a1:	e8 63 06 00 00       	call   801d09 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016a6:	85 c0                	test   %eax,%eax
  8016a8:	74 11                	je     8016bb <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  8016aa:	83 ec 0c             	sub    $0xc,%esp
  8016ad:	ff 75 e8             	pushl  -0x18(%ebp)
  8016b0:	e8 ce 0c 00 00       	call   802383 <alloc_block_FF>
  8016b5:	83 c4 10             	add    $0x10,%esp
  8016b8:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  8016bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016bf:	74 4c                	je     80170d <smalloc+0xba>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8016c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c4:	8b 40 08             	mov    0x8(%eax),%eax
  8016c7:	89 c2                	mov    %eax,%edx
  8016c9:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8016cd:	52                   	push   %edx
  8016ce:	50                   	push   %eax
  8016cf:	ff 75 0c             	pushl  0xc(%ebp)
  8016d2:	ff 75 08             	pushl  0x8(%ebp)
  8016d5:	e8 b4 03 00 00       	call   801a8e <sys_createSharedObject>
  8016da:	83 c4 10             	add    $0x10,%esp
  8016dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("Output is :  %d \n" , result);
  8016e0:	83 ec 08             	sub    $0x8,%esp
  8016e3:	ff 75 e0             	pushl  -0x20(%ebp)
  8016e6:	68 4f 3e 80 00       	push   $0x803e4f
  8016eb:	e8 93 ef ff ff       	call   800683 <cprintf>
  8016f0:	83 c4 10             	add    $0x10,%esp
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  8016f3:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8016f7:	74 14                	je     80170d <smalloc+0xba>
  8016f9:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8016fd:	74 0e                	je     80170d <smalloc+0xba>
  8016ff:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801703:	74 08                	je     80170d <smalloc+0xba>
			return (void*) mem_block->sva;
  801705:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801708:	8b 40 08             	mov    0x8(%eax),%eax
  80170b:	eb 05                	jmp    801712 <smalloc+0xbf>
	}
	return NULL;
  80170d:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801712:	c9                   	leave  
  801713:	c3                   	ret    

00801714 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801714:	55                   	push   %ebp
  801715:	89 e5                	mov    %esp,%ebp
  801717:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80171a:	e8 ee fc ff ff       	call   80140d <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  80171f:	83 ec 04             	sub    $0x4,%esp
  801722:	68 64 3e 80 00       	push   $0x803e64
  801727:	68 ab 00 00 00       	push   $0xab
  80172c:	68 d3 3d 80 00       	push   $0x803dd3
  801731:	e8 44 1d 00 00       	call   80347a <_panic>

00801736 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801736:	55                   	push   %ebp
  801737:	89 e5                	mov    %esp,%ebp
  801739:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80173c:	e8 cc fc ff ff       	call   80140d <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801741:	83 ec 04             	sub    $0x4,%esp
  801744:	68 88 3e 80 00       	push   $0x803e88
  801749:	68 ef 00 00 00       	push   $0xef
  80174e:	68 d3 3d 80 00       	push   $0x803dd3
  801753:	e8 22 1d 00 00       	call   80347a <_panic>

00801758 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801758:	55                   	push   %ebp
  801759:	89 e5                	mov    %esp,%ebp
  80175b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80175e:	83 ec 04             	sub    $0x4,%esp
  801761:	68 b0 3e 80 00       	push   $0x803eb0
  801766:	68 03 01 00 00       	push   $0x103
  80176b:	68 d3 3d 80 00       	push   $0x803dd3
  801770:	e8 05 1d 00 00       	call   80347a <_panic>

00801775 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801775:	55                   	push   %ebp
  801776:	89 e5                	mov    %esp,%ebp
  801778:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80177b:	83 ec 04             	sub    $0x4,%esp
  80177e:	68 d4 3e 80 00       	push   $0x803ed4
  801783:	68 0e 01 00 00       	push   $0x10e
  801788:	68 d3 3d 80 00       	push   $0x803dd3
  80178d:	e8 e8 1c 00 00       	call   80347a <_panic>

00801792 <shrink>:

}
void shrink(uint32 newSize)
{
  801792:	55                   	push   %ebp
  801793:	89 e5                	mov    %esp,%ebp
  801795:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801798:	83 ec 04             	sub    $0x4,%esp
  80179b:	68 d4 3e 80 00       	push   $0x803ed4
  8017a0:	68 13 01 00 00       	push   $0x113
  8017a5:	68 d3 3d 80 00       	push   $0x803dd3
  8017aa:	e8 cb 1c 00 00       	call   80347a <_panic>

008017af <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017af:	55                   	push   %ebp
  8017b0:	89 e5                	mov    %esp,%ebp
  8017b2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017b5:	83 ec 04             	sub    $0x4,%esp
  8017b8:	68 d4 3e 80 00       	push   $0x803ed4
  8017bd:	68 18 01 00 00       	push   $0x118
  8017c2:	68 d3 3d 80 00       	push   $0x803dd3
  8017c7:	e8 ae 1c 00 00       	call   80347a <_panic>

008017cc <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017cc:	55                   	push   %ebp
  8017cd:	89 e5                	mov    %esp,%ebp
  8017cf:	57                   	push   %edi
  8017d0:	56                   	push   %esi
  8017d1:	53                   	push   %ebx
  8017d2:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017db:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017de:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017e1:	8b 7d 18             	mov    0x18(%ebp),%edi
  8017e4:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8017e7:	cd 30                	int    $0x30
  8017e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8017ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017ef:	83 c4 10             	add    $0x10,%esp
  8017f2:	5b                   	pop    %ebx
  8017f3:	5e                   	pop    %esi
  8017f4:	5f                   	pop    %edi
  8017f5:	5d                   	pop    %ebp
  8017f6:	c3                   	ret    

008017f7 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8017f7:	55                   	push   %ebp
  8017f8:	89 e5                	mov    %esp,%ebp
  8017fa:	83 ec 04             	sub    $0x4,%esp
  8017fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801800:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801803:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801807:	8b 45 08             	mov    0x8(%ebp),%eax
  80180a:	6a 00                	push   $0x0
  80180c:	6a 00                	push   $0x0
  80180e:	52                   	push   %edx
  80180f:	ff 75 0c             	pushl  0xc(%ebp)
  801812:	50                   	push   %eax
  801813:	6a 00                	push   $0x0
  801815:	e8 b2 ff ff ff       	call   8017cc <syscall>
  80181a:	83 c4 18             	add    $0x18,%esp
}
  80181d:	90                   	nop
  80181e:	c9                   	leave  
  80181f:	c3                   	ret    

00801820 <sys_cgetc>:

int
sys_cgetc(void)
{
  801820:	55                   	push   %ebp
  801821:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801823:	6a 00                	push   $0x0
  801825:	6a 00                	push   $0x0
  801827:	6a 00                	push   $0x0
  801829:	6a 00                	push   $0x0
  80182b:	6a 00                	push   $0x0
  80182d:	6a 01                	push   $0x1
  80182f:	e8 98 ff ff ff       	call   8017cc <syscall>
  801834:	83 c4 18             	add    $0x18,%esp
}
  801837:	c9                   	leave  
  801838:	c3                   	ret    

00801839 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801839:	55                   	push   %ebp
  80183a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80183c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80183f:	8b 45 08             	mov    0x8(%ebp),%eax
  801842:	6a 00                	push   $0x0
  801844:	6a 00                	push   $0x0
  801846:	6a 00                	push   $0x0
  801848:	52                   	push   %edx
  801849:	50                   	push   %eax
  80184a:	6a 05                	push   $0x5
  80184c:	e8 7b ff ff ff       	call   8017cc <syscall>
  801851:	83 c4 18             	add    $0x18,%esp
}
  801854:	c9                   	leave  
  801855:	c3                   	ret    

00801856 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801856:	55                   	push   %ebp
  801857:	89 e5                	mov    %esp,%ebp
  801859:	56                   	push   %esi
  80185a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80185b:	8b 75 18             	mov    0x18(%ebp),%esi
  80185e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801861:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801864:	8b 55 0c             	mov    0xc(%ebp),%edx
  801867:	8b 45 08             	mov    0x8(%ebp),%eax
  80186a:	56                   	push   %esi
  80186b:	53                   	push   %ebx
  80186c:	51                   	push   %ecx
  80186d:	52                   	push   %edx
  80186e:	50                   	push   %eax
  80186f:	6a 06                	push   $0x6
  801871:	e8 56 ff ff ff       	call   8017cc <syscall>
  801876:	83 c4 18             	add    $0x18,%esp
}
  801879:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80187c:	5b                   	pop    %ebx
  80187d:	5e                   	pop    %esi
  80187e:	5d                   	pop    %ebp
  80187f:	c3                   	ret    

00801880 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801880:	55                   	push   %ebp
  801881:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801883:	8b 55 0c             	mov    0xc(%ebp),%edx
  801886:	8b 45 08             	mov    0x8(%ebp),%eax
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	52                   	push   %edx
  801890:	50                   	push   %eax
  801891:	6a 07                	push   $0x7
  801893:	e8 34 ff ff ff       	call   8017cc <syscall>
  801898:	83 c4 18             	add    $0x18,%esp
}
  80189b:	c9                   	leave  
  80189c:	c3                   	ret    

0080189d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80189d:	55                   	push   %ebp
  80189e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	ff 75 0c             	pushl  0xc(%ebp)
  8018a9:	ff 75 08             	pushl  0x8(%ebp)
  8018ac:	6a 08                	push   $0x8
  8018ae:	e8 19 ff ff ff       	call   8017cc <syscall>
  8018b3:	83 c4 18             	add    $0x18,%esp
}
  8018b6:	c9                   	leave  
  8018b7:	c3                   	ret    

008018b8 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018b8:	55                   	push   %ebp
  8018b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 09                	push   $0x9
  8018c7:	e8 00 ff ff ff       	call   8017cc <syscall>
  8018cc:	83 c4 18             	add    $0x18,%esp
}
  8018cf:	c9                   	leave  
  8018d0:	c3                   	ret    

008018d1 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018d1:	55                   	push   %ebp
  8018d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 0a                	push   $0xa
  8018e0:	e8 e7 fe ff ff       	call   8017cc <syscall>
  8018e5:	83 c4 18             	add    $0x18,%esp
}
  8018e8:	c9                   	leave  
  8018e9:	c3                   	ret    

008018ea <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8018ea:	55                   	push   %ebp
  8018eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 0b                	push   $0xb
  8018f9:	e8 ce fe ff ff       	call   8017cc <syscall>
  8018fe:	83 c4 18             	add    $0x18,%esp
}
  801901:	c9                   	leave  
  801902:	c3                   	ret    

00801903 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801903:	55                   	push   %ebp
  801904:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	ff 75 0c             	pushl  0xc(%ebp)
  80190f:	ff 75 08             	pushl  0x8(%ebp)
  801912:	6a 0f                	push   $0xf
  801914:	e8 b3 fe ff ff       	call   8017cc <syscall>
  801919:	83 c4 18             	add    $0x18,%esp
	return;
  80191c:	90                   	nop
}
  80191d:	c9                   	leave  
  80191e:	c3                   	ret    

0080191f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80191f:	55                   	push   %ebp
  801920:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	ff 75 0c             	pushl  0xc(%ebp)
  80192b:	ff 75 08             	pushl  0x8(%ebp)
  80192e:	6a 10                	push   $0x10
  801930:	e8 97 fe ff ff       	call   8017cc <syscall>
  801935:	83 c4 18             	add    $0x18,%esp
	return ;
  801938:	90                   	nop
}
  801939:	c9                   	leave  
  80193a:	c3                   	ret    

0080193b <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80193b:	55                   	push   %ebp
  80193c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	ff 75 10             	pushl  0x10(%ebp)
  801945:	ff 75 0c             	pushl  0xc(%ebp)
  801948:	ff 75 08             	pushl  0x8(%ebp)
  80194b:	6a 11                	push   $0x11
  80194d:	e8 7a fe ff ff       	call   8017cc <syscall>
  801952:	83 c4 18             	add    $0x18,%esp
	return ;
  801955:	90                   	nop
}
  801956:	c9                   	leave  
  801957:	c3                   	ret    

00801958 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801958:	55                   	push   %ebp
  801959:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	6a 0c                	push   $0xc
  801967:	e8 60 fe ff ff       	call   8017cc <syscall>
  80196c:	83 c4 18             	add    $0x18,%esp
}
  80196f:	c9                   	leave  
  801970:	c3                   	ret    

00801971 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801971:	55                   	push   %ebp
  801972:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	6a 00                	push   $0x0
  80197a:	6a 00                	push   $0x0
  80197c:	ff 75 08             	pushl  0x8(%ebp)
  80197f:	6a 0d                	push   $0xd
  801981:	e8 46 fe ff ff       	call   8017cc <syscall>
  801986:	83 c4 18             	add    $0x18,%esp
}
  801989:	c9                   	leave  
  80198a:	c3                   	ret    

0080198b <sys_scarce_memory>:

void sys_scarce_memory()
{
  80198b:	55                   	push   %ebp
  80198c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	6a 00                	push   $0x0
  801994:	6a 00                	push   $0x0
  801996:	6a 00                	push   $0x0
  801998:	6a 0e                	push   $0xe
  80199a:	e8 2d fe ff ff       	call   8017cc <syscall>
  80199f:	83 c4 18             	add    $0x18,%esp
}
  8019a2:	90                   	nop
  8019a3:	c9                   	leave  
  8019a4:	c3                   	ret    

008019a5 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019a5:	55                   	push   %ebp
  8019a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 13                	push   $0x13
  8019b4:	e8 13 fe ff ff       	call   8017cc <syscall>
  8019b9:	83 c4 18             	add    $0x18,%esp
}
  8019bc:	90                   	nop
  8019bd:	c9                   	leave  
  8019be:	c3                   	ret    

008019bf <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8019bf:	55                   	push   %ebp
  8019c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 14                	push   $0x14
  8019ce:	e8 f9 fd ff ff       	call   8017cc <syscall>
  8019d3:	83 c4 18             	add    $0x18,%esp
}
  8019d6:	90                   	nop
  8019d7:	c9                   	leave  
  8019d8:	c3                   	ret    

008019d9 <sys_cputc>:


void
sys_cputc(const char c)
{
  8019d9:	55                   	push   %ebp
  8019da:	89 e5                	mov    %esp,%ebp
  8019dc:	83 ec 04             	sub    $0x4,%esp
  8019df:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019e5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	50                   	push   %eax
  8019f2:	6a 15                	push   $0x15
  8019f4:	e8 d3 fd ff ff       	call   8017cc <syscall>
  8019f9:	83 c4 18             	add    $0x18,%esp
}
  8019fc:	90                   	nop
  8019fd:	c9                   	leave  
  8019fe:	c3                   	ret    

008019ff <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019ff:	55                   	push   %ebp
  801a00:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 16                	push   $0x16
  801a0e:	e8 b9 fd ff ff       	call   8017cc <syscall>
  801a13:	83 c4 18             	add    $0x18,%esp
}
  801a16:	90                   	nop
  801a17:	c9                   	leave  
  801a18:	c3                   	ret    

00801a19 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a19:	55                   	push   %ebp
  801a1a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	6a 00                	push   $0x0
  801a25:	ff 75 0c             	pushl  0xc(%ebp)
  801a28:	50                   	push   %eax
  801a29:	6a 17                	push   $0x17
  801a2b:	e8 9c fd ff ff       	call   8017cc <syscall>
  801a30:	83 c4 18             	add    $0x18,%esp
}
  801a33:	c9                   	leave  
  801a34:	c3                   	ret    

00801a35 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a35:	55                   	push   %ebp
  801a36:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a38:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	52                   	push   %edx
  801a45:	50                   	push   %eax
  801a46:	6a 1a                	push   $0x1a
  801a48:	e8 7f fd ff ff       	call   8017cc <syscall>
  801a4d:	83 c4 18             	add    $0x18,%esp
}
  801a50:	c9                   	leave  
  801a51:	c3                   	ret    

00801a52 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a52:	55                   	push   %ebp
  801a53:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a55:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a58:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	52                   	push   %edx
  801a62:	50                   	push   %eax
  801a63:	6a 18                	push   $0x18
  801a65:	e8 62 fd ff ff       	call   8017cc <syscall>
  801a6a:	83 c4 18             	add    $0x18,%esp
}
  801a6d:	90                   	nop
  801a6e:	c9                   	leave  
  801a6f:	c3                   	ret    

00801a70 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a70:	55                   	push   %ebp
  801a71:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a73:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a76:	8b 45 08             	mov    0x8(%ebp),%eax
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	52                   	push   %edx
  801a80:	50                   	push   %eax
  801a81:	6a 19                	push   $0x19
  801a83:	e8 44 fd ff ff       	call   8017cc <syscall>
  801a88:	83 c4 18             	add    $0x18,%esp
}
  801a8b:	90                   	nop
  801a8c:	c9                   	leave  
  801a8d:	c3                   	ret    

00801a8e <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a8e:	55                   	push   %ebp
  801a8f:	89 e5                	mov    %esp,%ebp
  801a91:	83 ec 04             	sub    $0x4,%esp
  801a94:	8b 45 10             	mov    0x10(%ebp),%eax
  801a97:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a9a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a9d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa4:	6a 00                	push   $0x0
  801aa6:	51                   	push   %ecx
  801aa7:	52                   	push   %edx
  801aa8:	ff 75 0c             	pushl  0xc(%ebp)
  801aab:	50                   	push   %eax
  801aac:	6a 1b                	push   $0x1b
  801aae:	e8 19 fd ff ff       	call   8017cc <syscall>
  801ab3:	83 c4 18             	add    $0x18,%esp
}
  801ab6:	c9                   	leave  
  801ab7:	c3                   	ret    

00801ab8 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ab8:	55                   	push   %ebp
  801ab9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801abb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801abe:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	52                   	push   %edx
  801ac8:	50                   	push   %eax
  801ac9:	6a 1c                	push   $0x1c
  801acb:	e8 fc fc ff ff       	call   8017cc <syscall>
  801ad0:	83 c4 18             	add    $0x18,%esp
}
  801ad3:	c9                   	leave  
  801ad4:	c3                   	ret    

00801ad5 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801ad5:	55                   	push   %ebp
  801ad6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ad8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801adb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ade:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	51                   	push   %ecx
  801ae6:	52                   	push   %edx
  801ae7:	50                   	push   %eax
  801ae8:	6a 1d                	push   $0x1d
  801aea:	e8 dd fc ff ff       	call   8017cc <syscall>
  801aef:	83 c4 18             	add    $0x18,%esp
}
  801af2:	c9                   	leave  
  801af3:	c3                   	ret    

00801af4 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801af4:	55                   	push   %ebp
  801af5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801af7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801afa:	8b 45 08             	mov    0x8(%ebp),%eax
  801afd:	6a 00                	push   $0x0
  801aff:	6a 00                	push   $0x0
  801b01:	6a 00                	push   $0x0
  801b03:	52                   	push   %edx
  801b04:	50                   	push   %eax
  801b05:	6a 1e                	push   $0x1e
  801b07:	e8 c0 fc ff ff       	call   8017cc <syscall>
  801b0c:	83 c4 18             	add    $0x18,%esp
}
  801b0f:	c9                   	leave  
  801b10:	c3                   	ret    

00801b11 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b11:	55                   	push   %ebp
  801b12:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 1f                	push   $0x1f
  801b20:	e8 a7 fc ff ff       	call   8017cc <syscall>
  801b25:	83 c4 18             	add    $0x18,%esp
}
  801b28:	c9                   	leave  
  801b29:	c3                   	ret    

00801b2a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b2a:	55                   	push   %ebp
  801b2b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b30:	6a 00                	push   $0x0
  801b32:	ff 75 14             	pushl  0x14(%ebp)
  801b35:	ff 75 10             	pushl  0x10(%ebp)
  801b38:	ff 75 0c             	pushl  0xc(%ebp)
  801b3b:	50                   	push   %eax
  801b3c:	6a 20                	push   $0x20
  801b3e:	e8 89 fc ff ff       	call   8017cc <syscall>
  801b43:	83 c4 18             	add    $0x18,%esp
}
  801b46:	c9                   	leave  
  801b47:	c3                   	ret    

00801b48 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b48:	55                   	push   %ebp
  801b49:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	50                   	push   %eax
  801b57:	6a 21                	push   $0x21
  801b59:	e8 6e fc ff ff       	call   8017cc <syscall>
  801b5e:	83 c4 18             	add    $0x18,%esp
}
  801b61:	90                   	nop
  801b62:	c9                   	leave  
  801b63:	c3                   	ret    

00801b64 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b64:	55                   	push   %ebp
  801b65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b67:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	50                   	push   %eax
  801b73:	6a 22                	push   $0x22
  801b75:	e8 52 fc ff ff       	call   8017cc <syscall>
  801b7a:	83 c4 18             	add    $0x18,%esp
}
  801b7d:	c9                   	leave  
  801b7e:	c3                   	ret    

00801b7f <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b7f:	55                   	push   %ebp
  801b80:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 02                	push   $0x2
  801b8e:	e8 39 fc ff ff       	call   8017cc <syscall>
  801b93:	83 c4 18             	add    $0x18,%esp
}
  801b96:	c9                   	leave  
  801b97:	c3                   	ret    

00801b98 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b98:	55                   	push   %ebp
  801b99:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 00                	push   $0x0
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 03                	push   $0x3
  801ba7:	e8 20 fc ff ff       	call   8017cc <syscall>
  801bac:	83 c4 18             	add    $0x18,%esp
}
  801baf:	c9                   	leave  
  801bb0:	c3                   	ret    

00801bb1 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bb1:	55                   	push   %ebp
  801bb2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 04                	push   $0x4
  801bc0:	e8 07 fc ff ff       	call   8017cc <syscall>
  801bc5:	83 c4 18             	add    $0x18,%esp
}
  801bc8:	c9                   	leave  
  801bc9:	c3                   	ret    

00801bca <sys_exit_env>:


void sys_exit_env(void)
{
  801bca:	55                   	push   %ebp
  801bcb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 23                	push   $0x23
  801bd9:	e8 ee fb ff ff       	call   8017cc <syscall>
  801bde:	83 c4 18             	add    $0x18,%esp
}
  801be1:	90                   	nop
  801be2:	c9                   	leave  
  801be3:	c3                   	ret    

00801be4 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801be4:	55                   	push   %ebp
  801be5:	89 e5                	mov    %esp,%ebp
  801be7:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801bea:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bed:	8d 50 04             	lea    0x4(%eax),%edx
  801bf0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	52                   	push   %edx
  801bfa:	50                   	push   %eax
  801bfb:	6a 24                	push   $0x24
  801bfd:	e8 ca fb ff ff       	call   8017cc <syscall>
  801c02:	83 c4 18             	add    $0x18,%esp
	return result;
  801c05:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c08:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c0b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c0e:	89 01                	mov    %eax,(%ecx)
  801c10:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c13:	8b 45 08             	mov    0x8(%ebp),%eax
  801c16:	c9                   	leave  
  801c17:	c2 04 00             	ret    $0x4

00801c1a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c1a:	55                   	push   %ebp
  801c1b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	ff 75 10             	pushl  0x10(%ebp)
  801c24:	ff 75 0c             	pushl  0xc(%ebp)
  801c27:	ff 75 08             	pushl  0x8(%ebp)
  801c2a:	6a 12                	push   $0x12
  801c2c:	e8 9b fb ff ff       	call   8017cc <syscall>
  801c31:	83 c4 18             	add    $0x18,%esp
	return ;
  801c34:	90                   	nop
}
  801c35:	c9                   	leave  
  801c36:	c3                   	ret    

00801c37 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c37:	55                   	push   %ebp
  801c38:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 25                	push   $0x25
  801c46:	e8 81 fb ff ff       	call   8017cc <syscall>
  801c4b:	83 c4 18             	add    $0x18,%esp
}
  801c4e:	c9                   	leave  
  801c4f:	c3                   	ret    

00801c50 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c50:	55                   	push   %ebp
  801c51:	89 e5                	mov    %esp,%ebp
  801c53:	83 ec 04             	sub    $0x4,%esp
  801c56:	8b 45 08             	mov    0x8(%ebp),%eax
  801c59:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c5c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	50                   	push   %eax
  801c69:	6a 26                	push   $0x26
  801c6b:	e8 5c fb ff ff       	call   8017cc <syscall>
  801c70:	83 c4 18             	add    $0x18,%esp
	return ;
  801c73:	90                   	nop
}
  801c74:	c9                   	leave  
  801c75:	c3                   	ret    

00801c76 <rsttst>:
void rsttst()
{
  801c76:	55                   	push   %ebp
  801c77:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	6a 28                	push   $0x28
  801c85:	e8 42 fb ff ff       	call   8017cc <syscall>
  801c8a:	83 c4 18             	add    $0x18,%esp
	return ;
  801c8d:	90                   	nop
}
  801c8e:	c9                   	leave  
  801c8f:	c3                   	ret    

00801c90 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
  801c93:	83 ec 04             	sub    $0x4,%esp
  801c96:	8b 45 14             	mov    0x14(%ebp),%eax
  801c99:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c9c:	8b 55 18             	mov    0x18(%ebp),%edx
  801c9f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ca3:	52                   	push   %edx
  801ca4:	50                   	push   %eax
  801ca5:	ff 75 10             	pushl  0x10(%ebp)
  801ca8:	ff 75 0c             	pushl  0xc(%ebp)
  801cab:	ff 75 08             	pushl  0x8(%ebp)
  801cae:	6a 27                	push   $0x27
  801cb0:	e8 17 fb ff ff       	call   8017cc <syscall>
  801cb5:	83 c4 18             	add    $0x18,%esp
	return ;
  801cb8:	90                   	nop
}
  801cb9:	c9                   	leave  
  801cba:	c3                   	ret    

00801cbb <chktst>:
void chktst(uint32 n)
{
  801cbb:	55                   	push   %ebp
  801cbc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	ff 75 08             	pushl  0x8(%ebp)
  801cc9:	6a 29                	push   $0x29
  801ccb:	e8 fc fa ff ff       	call   8017cc <syscall>
  801cd0:	83 c4 18             	add    $0x18,%esp
	return ;
  801cd3:	90                   	nop
}
  801cd4:	c9                   	leave  
  801cd5:	c3                   	ret    

00801cd6 <inctst>:

void inctst()
{
  801cd6:	55                   	push   %ebp
  801cd7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801cd9:	6a 00                	push   $0x0
  801cdb:	6a 00                	push   $0x0
  801cdd:	6a 00                	push   $0x0
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 2a                	push   $0x2a
  801ce5:	e8 e2 fa ff ff       	call   8017cc <syscall>
  801cea:	83 c4 18             	add    $0x18,%esp
	return ;
  801ced:	90                   	nop
}
  801cee:	c9                   	leave  
  801cef:	c3                   	ret    

00801cf0 <gettst>:
uint32 gettst()
{
  801cf0:	55                   	push   %ebp
  801cf1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 2b                	push   $0x2b
  801cff:	e8 c8 fa ff ff       	call   8017cc <syscall>
  801d04:	83 c4 18             	add    $0x18,%esp
}
  801d07:	c9                   	leave  
  801d08:	c3                   	ret    

00801d09 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d09:	55                   	push   %ebp
  801d0a:	89 e5                	mov    %esp,%ebp
  801d0c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	6a 2c                	push   $0x2c
  801d1b:	e8 ac fa ff ff       	call   8017cc <syscall>
  801d20:	83 c4 18             	add    $0x18,%esp
  801d23:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d26:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d2a:	75 07                	jne    801d33 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d2c:	b8 01 00 00 00       	mov    $0x1,%eax
  801d31:	eb 05                	jmp    801d38 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d33:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d38:	c9                   	leave  
  801d39:	c3                   	ret    

00801d3a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d3a:	55                   	push   %ebp
  801d3b:	89 e5                	mov    %esp,%ebp
  801d3d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 2c                	push   $0x2c
  801d4c:	e8 7b fa ff ff       	call   8017cc <syscall>
  801d51:	83 c4 18             	add    $0x18,%esp
  801d54:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d57:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d5b:	75 07                	jne    801d64 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d5d:	b8 01 00 00 00       	mov    $0x1,%eax
  801d62:	eb 05                	jmp    801d69 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d64:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d69:	c9                   	leave  
  801d6a:	c3                   	ret    

00801d6b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d6b:	55                   	push   %ebp
  801d6c:	89 e5                	mov    %esp,%ebp
  801d6e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 2c                	push   $0x2c
  801d7d:	e8 4a fa ff ff       	call   8017cc <syscall>
  801d82:	83 c4 18             	add    $0x18,%esp
  801d85:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d88:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d8c:	75 07                	jne    801d95 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d8e:	b8 01 00 00 00       	mov    $0x1,%eax
  801d93:	eb 05                	jmp    801d9a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d9a:	c9                   	leave  
  801d9b:	c3                   	ret    

00801d9c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d9c:	55                   	push   %ebp
  801d9d:	89 e5                	mov    %esp,%ebp
  801d9f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801da2:	6a 00                	push   $0x0
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	6a 00                	push   $0x0
  801daa:	6a 00                	push   $0x0
  801dac:	6a 2c                	push   $0x2c
  801dae:	e8 19 fa ff ff       	call   8017cc <syscall>
  801db3:	83 c4 18             	add    $0x18,%esp
  801db6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801db9:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801dbd:	75 07                	jne    801dc6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801dbf:	b8 01 00 00 00       	mov    $0x1,%eax
  801dc4:	eb 05                	jmp    801dcb <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801dc6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dcb:	c9                   	leave  
  801dcc:	c3                   	ret    

00801dcd <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801dcd:	55                   	push   %ebp
  801dce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	ff 75 08             	pushl  0x8(%ebp)
  801ddb:	6a 2d                	push   $0x2d
  801ddd:	e8 ea f9 ff ff       	call   8017cc <syscall>
  801de2:	83 c4 18             	add    $0x18,%esp
	return ;
  801de5:	90                   	nop
}
  801de6:	c9                   	leave  
  801de7:	c3                   	ret    

00801de8 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801de8:	55                   	push   %ebp
  801de9:	89 e5                	mov    %esp,%ebp
  801deb:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801dec:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801def:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801df2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801df5:	8b 45 08             	mov    0x8(%ebp),%eax
  801df8:	6a 00                	push   $0x0
  801dfa:	53                   	push   %ebx
  801dfb:	51                   	push   %ecx
  801dfc:	52                   	push   %edx
  801dfd:	50                   	push   %eax
  801dfe:	6a 2e                	push   $0x2e
  801e00:	e8 c7 f9 ff ff       	call   8017cc <syscall>
  801e05:	83 c4 18             	add    $0x18,%esp
}
  801e08:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e0b:	c9                   	leave  
  801e0c:	c3                   	ret    

00801e0d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e0d:	55                   	push   %ebp
  801e0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e10:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e13:	8b 45 08             	mov    0x8(%ebp),%eax
  801e16:	6a 00                	push   $0x0
  801e18:	6a 00                	push   $0x0
  801e1a:	6a 00                	push   $0x0
  801e1c:	52                   	push   %edx
  801e1d:	50                   	push   %eax
  801e1e:	6a 2f                	push   $0x2f
  801e20:	e8 a7 f9 ff ff       	call   8017cc <syscall>
  801e25:	83 c4 18             	add    $0x18,%esp
}
  801e28:	c9                   	leave  
  801e29:	c3                   	ret    

00801e2a <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e2a:	55                   	push   %ebp
  801e2b:	89 e5                	mov    %esp,%ebp
  801e2d:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e30:	83 ec 0c             	sub    $0xc,%esp
  801e33:	68 e4 3e 80 00       	push   $0x803ee4
  801e38:	e8 46 e8 ff ff       	call   800683 <cprintf>
  801e3d:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e40:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e47:	83 ec 0c             	sub    $0xc,%esp
  801e4a:	68 10 3f 80 00       	push   $0x803f10
  801e4f:	e8 2f e8 ff ff       	call   800683 <cprintf>
  801e54:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e57:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e5b:	a1 38 51 80 00       	mov    0x805138,%eax
  801e60:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e63:	eb 56                	jmp    801ebb <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e65:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e69:	74 1c                	je     801e87 <print_mem_block_lists+0x5d>
  801e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e6e:	8b 50 08             	mov    0x8(%eax),%edx
  801e71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e74:	8b 48 08             	mov    0x8(%eax),%ecx
  801e77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e7a:	8b 40 0c             	mov    0xc(%eax),%eax
  801e7d:	01 c8                	add    %ecx,%eax
  801e7f:	39 c2                	cmp    %eax,%edx
  801e81:	73 04                	jae    801e87 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801e83:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e8a:	8b 50 08             	mov    0x8(%eax),%edx
  801e8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e90:	8b 40 0c             	mov    0xc(%eax),%eax
  801e93:	01 c2                	add    %eax,%edx
  801e95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e98:	8b 40 08             	mov    0x8(%eax),%eax
  801e9b:	83 ec 04             	sub    $0x4,%esp
  801e9e:	52                   	push   %edx
  801e9f:	50                   	push   %eax
  801ea0:	68 25 3f 80 00       	push   $0x803f25
  801ea5:	e8 d9 e7 ff ff       	call   800683 <cprintf>
  801eaa:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ead:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801eb3:	a1 40 51 80 00       	mov    0x805140,%eax
  801eb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ebb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ebf:	74 07                	je     801ec8 <print_mem_block_lists+0x9e>
  801ec1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec4:	8b 00                	mov    (%eax),%eax
  801ec6:	eb 05                	jmp    801ecd <print_mem_block_lists+0xa3>
  801ec8:	b8 00 00 00 00       	mov    $0x0,%eax
  801ecd:	a3 40 51 80 00       	mov    %eax,0x805140
  801ed2:	a1 40 51 80 00       	mov    0x805140,%eax
  801ed7:	85 c0                	test   %eax,%eax
  801ed9:	75 8a                	jne    801e65 <print_mem_block_lists+0x3b>
  801edb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801edf:	75 84                	jne    801e65 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801ee1:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801ee5:	75 10                	jne    801ef7 <print_mem_block_lists+0xcd>
  801ee7:	83 ec 0c             	sub    $0xc,%esp
  801eea:	68 34 3f 80 00       	push   $0x803f34
  801eef:	e8 8f e7 ff ff       	call   800683 <cprintf>
  801ef4:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801ef7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801efe:	83 ec 0c             	sub    $0xc,%esp
  801f01:	68 58 3f 80 00       	push   $0x803f58
  801f06:	e8 78 e7 ff ff       	call   800683 <cprintf>
  801f0b:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f0e:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f12:	a1 40 50 80 00       	mov    0x805040,%eax
  801f17:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f1a:	eb 56                	jmp    801f72 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f1c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f20:	74 1c                	je     801f3e <print_mem_block_lists+0x114>
  801f22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f25:	8b 50 08             	mov    0x8(%eax),%edx
  801f28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f2b:	8b 48 08             	mov    0x8(%eax),%ecx
  801f2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f31:	8b 40 0c             	mov    0xc(%eax),%eax
  801f34:	01 c8                	add    %ecx,%eax
  801f36:	39 c2                	cmp    %eax,%edx
  801f38:	73 04                	jae    801f3e <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f3a:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f41:	8b 50 08             	mov    0x8(%eax),%edx
  801f44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f47:	8b 40 0c             	mov    0xc(%eax),%eax
  801f4a:	01 c2                	add    %eax,%edx
  801f4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f4f:	8b 40 08             	mov    0x8(%eax),%eax
  801f52:	83 ec 04             	sub    $0x4,%esp
  801f55:	52                   	push   %edx
  801f56:	50                   	push   %eax
  801f57:	68 25 3f 80 00       	push   $0x803f25
  801f5c:	e8 22 e7 ff ff       	call   800683 <cprintf>
  801f61:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f67:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f6a:	a1 48 50 80 00       	mov    0x805048,%eax
  801f6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f76:	74 07                	je     801f7f <print_mem_block_lists+0x155>
  801f78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7b:	8b 00                	mov    (%eax),%eax
  801f7d:	eb 05                	jmp    801f84 <print_mem_block_lists+0x15a>
  801f7f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f84:	a3 48 50 80 00       	mov    %eax,0x805048
  801f89:	a1 48 50 80 00       	mov    0x805048,%eax
  801f8e:	85 c0                	test   %eax,%eax
  801f90:	75 8a                	jne    801f1c <print_mem_block_lists+0xf2>
  801f92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f96:	75 84                	jne    801f1c <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801f98:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f9c:	75 10                	jne    801fae <print_mem_block_lists+0x184>
  801f9e:	83 ec 0c             	sub    $0xc,%esp
  801fa1:	68 70 3f 80 00       	push   $0x803f70
  801fa6:	e8 d8 e6 ff ff       	call   800683 <cprintf>
  801fab:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801fae:	83 ec 0c             	sub    $0xc,%esp
  801fb1:	68 e4 3e 80 00       	push   $0x803ee4
  801fb6:	e8 c8 e6 ff ff       	call   800683 <cprintf>
  801fbb:	83 c4 10             	add    $0x10,%esp

}
  801fbe:	90                   	nop
  801fbf:	c9                   	leave  
  801fc0:	c3                   	ret    

00801fc1 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801fc1:	55                   	push   %ebp
  801fc2:	89 e5                	mov    %esp,%ebp
  801fc4:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801fc7:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801fce:	00 00 00 
  801fd1:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801fd8:	00 00 00 
  801fdb:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801fe2:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801fe5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801fec:	e9 9e 00 00 00       	jmp    80208f <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801ff1:	a1 50 50 80 00       	mov    0x805050,%eax
  801ff6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ff9:	c1 e2 04             	shl    $0x4,%edx
  801ffc:	01 d0                	add    %edx,%eax
  801ffe:	85 c0                	test   %eax,%eax
  802000:	75 14                	jne    802016 <initialize_MemBlocksList+0x55>
  802002:	83 ec 04             	sub    $0x4,%esp
  802005:	68 98 3f 80 00       	push   $0x803f98
  80200a:	6a 46                	push   $0x46
  80200c:	68 bb 3f 80 00       	push   $0x803fbb
  802011:	e8 64 14 00 00       	call   80347a <_panic>
  802016:	a1 50 50 80 00       	mov    0x805050,%eax
  80201b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80201e:	c1 e2 04             	shl    $0x4,%edx
  802021:	01 d0                	add    %edx,%eax
  802023:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802029:	89 10                	mov    %edx,(%eax)
  80202b:	8b 00                	mov    (%eax),%eax
  80202d:	85 c0                	test   %eax,%eax
  80202f:	74 18                	je     802049 <initialize_MemBlocksList+0x88>
  802031:	a1 48 51 80 00       	mov    0x805148,%eax
  802036:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80203c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80203f:	c1 e1 04             	shl    $0x4,%ecx
  802042:	01 ca                	add    %ecx,%edx
  802044:	89 50 04             	mov    %edx,0x4(%eax)
  802047:	eb 12                	jmp    80205b <initialize_MemBlocksList+0x9a>
  802049:	a1 50 50 80 00       	mov    0x805050,%eax
  80204e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802051:	c1 e2 04             	shl    $0x4,%edx
  802054:	01 d0                	add    %edx,%eax
  802056:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80205b:	a1 50 50 80 00       	mov    0x805050,%eax
  802060:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802063:	c1 e2 04             	shl    $0x4,%edx
  802066:	01 d0                	add    %edx,%eax
  802068:	a3 48 51 80 00       	mov    %eax,0x805148
  80206d:	a1 50 50 80 00       	mov    0x805050,%eax
  802072:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802075:	c1 e2 04             	shl    $0x4,%edx
  802078:	01 d0                	add    %edx,%eax
  80207a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802081:	a1 54 51 80 00       	mov    0x805154,%eax
  802086:	40                   	inc    %eax
  802087:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  80208c:	ff 45 f4             	incl   -0xc(%ebp)
  80208f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802092:	3b 45 08             	cmp    0x8(%ebp),%eax
  802095:	0f 82 56 ff ff ff    	jb     801ff1 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  80209b:	90                   	nop
  80209c:	c9                   	leave  
  80209d:	c3                   	ret    

0080209e <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80209e:	55                   	push   %ebp
  80209f:	89 e5                	mov    %esp,%ebp
  8020a1:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8020a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a7:	8b 00                	mov    (%eax),%eax
  8020a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020ac:	eb 19                	jmp    8020c7 <find_block+0x29>
	{
		if(va==point->sva)
  8020ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020b1:	8b 40 08             	mov    0x8(%eax),%eax
  8020b4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8020b7:	75 05                	jne    8020be <find_block+0x20>
		   return point;
  8020b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020bc:	eb 36                	jmp    8020f4 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8020be:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c1:	8b 40 08             	mov    0x8(%eax),%eax
  8020c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020cb:	74 07                	je     8020d4 <find_block+0x36>
  8020cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020d0:	8b 00                	mov    (%eax),%eax
  8020d2:	eb 05                	jmp    8020d9 <find_block+0x3b>
  8020d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8020dc:	89 42 08             	mov    %eax,0x8(%edx)
  8020df:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e2:	8b 40 08             	mov    0x8(%eax),%eax
  8020e5:	85 c0                	test   %eax,%eax
  8020e7:	75 c5                	jne    8020ae <find_block+0x10>
  8020e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020ed:	75 bf                	jne    8020ae <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8020ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020f4:	c9                   	leave  
  8020f5:	c3                   	ret    

008020f6 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8020f6:	55                   	push   %ebp
  8020f7:	89 e5                	mov    %esp,%ebp
  8020f9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8020fc:	a1 40 50 80 00       	mov    0x805040,%eax
  802101:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802104:	a1 44 50 80 00       	mov    0x805044,%eax
  802109:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80210c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80210f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802112:	74 24                	je     802138 <insert_sorted_allocList+0x42>
  802114:	8b 45 08             	mov    0x8(%ebp),%eax
  802117:	8b 50 08             	mov    0x8(%eax),%edx
  80211a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80211d:	8b 40 08             	mov    0x8(%eax),%eax
  802120:	39 c2                	cmp    %eax,%edx
  802122:	76 14                	jbe    802138 <insert_sorted_allocList+0x42>
  802124:	8b 45 08             	mov    0x8(%ebp),%eax
  802127:	8b 50 08             	mov    0x8(%eax),%edx
  80212a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80212d:	8b 40 08             	mov    0x8(%eax),%eax
  802130:	39 c2                	cmp    %eax,%edx
  802132:	0f 82 60 01 00 00    	jb     802298 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802138:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80213c:	75 65                	jne    8021a3 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80213e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802142:	75 14                	jne    802158 <insert_sorted_allocList+0x62>
  802144:	83 ec 04             	sub    $0x4,%esp
  802147:	68 98 3f 80 00       	push   $0x803f98
  80214c:	6a 6b                	push   $0x6b
  80214e:	68 bb 3f 80 00       	push   $0x803fbb
  802153:	e8 22 13 00 00       	call   80347a <_panic>
  802158:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80215e:	8b 45 08             	mov    0x8(%ebp),%eax
  802161:	89 10                	mov    %edx,(%eax)
  802163:	8b 45 08             	mov    0x8(%ebp),%eax
  802166:	8b 00                	mov    (%eax),%eax
  802168:	85 c0                	test   %eax,%eax
  80216a:	74 0d                	je     802179 <insert_sorted_allocList+0x83>
  80216c:	a1 40 50 80 00       	mov    0x805040,%eax
  802171:	8b 55 08             	mov    0x8(%ebp),%edx
  802174:	89 50 04             	mov    %edx,0x4(%eax)
  802177:	eb 08                	jmp    802181 <insert_sorted_allocList+0x8b>
  802179:	8b 45 08             	mov    0x8(%ebp),%eax
  80217c:	a3 44 50 80 00       	mov    %eax,0x805044
  802181:	8b 45 08             	mov    0x8(%ebp),%eax
  802184:	a3 40 50 80 00       	mov    %eax,0x805040
  802189:	8b 45 08             	mov    0x8(%ebp),%eax
  80218c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802193:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802198:	40                   	inc    %eax
  802199:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80219e:	e9 dc 01 00 00       	jmp    80237f <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8021a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a6:	8b 50 08             	mov    0x8(%eax),%edx
  8021a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ac:	8b 40 08             	mov    0x8(%eax),%eax
  8021af:	39 c2                	cmp    %eax,%edx
  8021b1:	77 6c                	ja     80221f <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8021b3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021b7:	74 06                	je     8021bf <insert_sorted_allocList+0xc9>
  8021b9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021bd:	75 14                	jne    8021d3 <insert_sorted_allocList+0xdd>
  8021bf:	83 ec 04             	sub    $0x4,%esp
  8021c2:	68 d4 3f 80 00       	push   $0x803fd4
  8021c7:	6a 6f                	push   $0x6f
  8021c9:	68 bb 3f 80 00       	push   $0x803fbb
  8021ce:	e8 a7 12 00 00       	call   80347a <_panic>
  8021d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d6:	8b 50 04             	mov    0x4(%eax),%edx
  8021d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021dc:	89 50 04             	mov    %edx,0x4(%eax)
  8021df:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021e5:	89 10                	mov    %edx,(%eax)
  8021e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ea:	8b 40 04             	mov    0x4(%eax),%eax
  8021ed:	85 c0                	test   %eax,%eax
  8021ef:	74 0d                	je     8021fe <insert_sorted_allocList+0x108>
  8021f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021f4:	8b 40 04             	mov    0x4(%eax),%eax
  8021f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8021fa:	89 10                	mov    %edx,(%eax)
  8021fc:	eb 08                	jmp    802206 <insert_sorted_allocList+0x110>
  8021fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802201:	a3 40 50 80 00       	mov    %eax,0x805040
  802206:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802209:	8b 55 08             	mov    0x8(%ebp),%edx
  80220c:	89 50 04             	mov    %edx,0x4(%eax)
  80220f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802214:	40                   	inc    %eax
  802215:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80221a:	e9 60 01 00 00       	jmp    80237f <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80221f:	8b 45 08             	mov    0x8(%ebp),%eax
  802222:	8b 50 08             	mov    0x8(%eax),%edx
  802225:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802228:	8b 40 08             	mov    0x8(%eax),%eax
  80222b:	39 c2                	cmp    %eax,%edx
  80222d:	0f 82 4c 01 00 00    	jb     80237f <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802233:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802237:	75 14                	jne    80224d <insert_sorted_allocList+0x157>
  802239:	83 ec 04             	sub    $0x4,%esp
  80223c:	68 0c 40 80 00       	push   $0x80400c
  802241:	6a 73                	push   $0x73
  802243:	68 bb 3f 80 00       	push   $0x803fbb
  802248:	e8 2d 12 00 00       	call   80347a <_panic>
  80224d:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802253:	8b 45 08             	mov    0x8(%ebp),%eax
  802256:	89 50 04             	mov    %edx,0x4(%eax)
  802259:	8b 45 08             	mov    0x8(%ebp),%eax
  80225c:	8b 40 04             	mov    0x4(%eax),%eax
  80225f:	85 c0                	test   %eax,%eax
  802261:	74 0c                	je     80226f <insert_sorted_allocList+0x179>
  802263:	a1 44 50 80 00       	mov    0x805044,%eax
  802268:	8b 55 08             	mov    0x8(%ebp),%edx
  80226b:	89 10                	mov    %edx,(%eax)
  80226d:	eb 08                	jmp    802277 <insert_sorted_allocList+0x181>
  80226f:	8b 45 08             	mov    0x8(%ebp),%eax
  802272:	a3 40 50 80 00       	mov    %eax,0x805040
  802277:	8b 45 08             	mov    0x8(%ebp),%eax
  80227a:	a3 44 50 80 00       	mov    %eax,0x805044
  80227f:	8b 45 08             	mov    0x8(%ebp),%eax
  802282:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802288:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80228d:	40                   	inc    %eax
  80228e:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802293:	e9 e7 00 00 00       	jmp    80237f <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802298:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80229b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80229e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8022a5:	a1 40 50 80 00       	mov    0x805040,%eax
  8022aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022ad:	e9 9d 00 00 00       	jmp    80234f <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8022b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b5:	8b 00                	mov    (%eax),%eax
  8022b7:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8022ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bd:	8b 50 08             	mov    0x8(%eax),%edx
  8022c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c3:	8b 40 08             	mov    0x8(%eax),%eax
  8022c6:	39 c2                	cmp    %eax,%edx
  8022c8:	76 7d                	jbe    802347 <insert_sorted_allocList+0x251>
  8022ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cd:	8b 50 08             	mov    0x8(%eax),%edx
  8022d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022d3:	8b 40 08             	mov    0x8(%eax),%eax
  8022d6:	39 c2                	cmp    %eax,%edx
  8022d8:	73 6d                	jae    802347 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8022da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022de:	74 06                	je     8022e6 <insert_sorted_allocList+0x1f0>
  8022e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022e4:	75 14                	jne    8022fa <insert_sorted_allocList+0x204>
  8022e6:	83 ec 04             	sub    $0x4,%esp
  8022e9:	68 30 40 80 00       	push   $0x804030
  8022ee:	6a 7f                	push   $0x7f
  8022f0:	68 bb 3f 80 00       	push   $0x803fbb
  8022f5:	e8 80 11 00 00       	call   80347a <_panic>
  8022fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fd:	8b 10                	mov    (%eax),%edx
  8022ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802302:	89 10                	mov    %edx,(%eax)
  802304:	8b 45 08             	mov    0x8(%ebp),%eax
  802307:	8b 00                	mov    (%eax),%eax
  802309:	85 c0                	test   %eax,%eax
  80230b:	74 0b                	je     802318 <insert_sorted_allocList+0x222>
  80230d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802310:	8b 00                	mov    (%eax),%eax
  802312:	8b 55 08             	mov    0x8(%ebp),%edx
  802315:	89 50 04             	mov    %edx,0x4(%eax)
  802318:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231b:	8b 55 08             	mov    0x8(%ebp),%edx
  80231e:	89 10                	mov    %edx,(%eax)
  802320:	8b 45 08             	mov    0x8(%ebp),%eax
  802323:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802326:	89 50 04             	mov    %edx,0x4(%eax)
  802329:	8b 45 08             	mov    0x8(%ebp),%eax
  80232c:	8b 00                	mov    (%eax),%eax
  80232e:	85 c0                	test   %eax,%eax
  802330:	75 08                	jne    80233a <insert_sorted_allocList+0x244>
  802332:	8b 45 08             	mov    0x8(%ebp),%eax
  802335:	a3 44 50 80 00       	mov    %eax,0x805044
  80233a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80233f:	40                   	inc    %eax
  802340:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802345:	eb 39                	jmp    802380 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802347:	a1 48 50 80 00       	mov    0x805048,%eax
  80234c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80234f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802353:	74 07                	je     80235c <insert_sorted_allocList+0x266>
  802355:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802358:	8b 00                	mov    (%eax),%eax
  80235a:	eb 05                	jmp    802361 <insert_sorted_allocList+0x26b>
  80235c:	b8 00 00 00 00       	mov    $0x0,%eax
  802361:	a3 48 50 80 00       	mov    %eax,0x805048
  802366:	a1 48 50 80 00       	mov    0x805048,%eax
  80236b:	85 c0                	test   %eax,%eax
  80236d:	0f 85 3f ff ff ff    	jne    8022b2 <insert_sorted_allocList+0x1bc>
  802373:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802377:	0f 85 35 ff ff ff    	jne    8022b2 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80237d:	eb 01                	jmp    802380 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80237f:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802380:	90                   	nop
  802381:	c9                   	leave  
  802382:	c3                   	ret    

00802383 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802383:	55                   	push   %ebp
  802384:	89 e5                	mov    %esp,%ebp
  802386:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802389:	a1 38 51 80 00       	mov    0x805138,%eax
  80238e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802391:	e9 85 01 00 00       	jmp    80251b <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802396:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802399:	8b 40 0c             	mov    0xc(%eax),%eax
  80239c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80239f:	0f 82 6e 01 00 00    	jb     802513 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8023a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a8:	8b 40 0c             	mov    0xc(%eax),%eax
  8023ab:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023ae:	0f 85 8a 00 00 00    	jne    80243e <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8023b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023b8:	75 17                	jne    8023d1 <alloc_block_FF+0x4e>
  8023ba:	83 ec 04             	sub    $0x4,%esp
  8023bd:	68 64 40 80 00       	push   $0x804064
  8023c2:	68 93 00 00 00       	push   $0x93
  8023c7:	68 bb 3f 80 00       	push   $0x803fbb
  8023cc:	e8 a9 10 00 00       	call   80347a <_panic>
  8023d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d4:	8b 00                	mov    (%eax),%eax
  8023d6:	85 c0                	test   %eax,%eax
  8023d8:	74 10                	je     8023ea <alloc_block_FF+0x67>
  8023da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023dd:	8b 00                	mov    (%eax),%eax
  8023df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023e2:	8b 52 04             	mov    0x4(%edx),%edx
  8023e5:	89 50 04             	mov    %edx,0x4(%eax)
  8023e8:	eb 0b                	jmp    8023f5 <alloc_block_FF+0x72>
  8023ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ed:	8b 40 04             	mov    0x4(%eax),%eax
  8023f0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8023f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f8:	8b 40 04             	mov    0x4(%eax),%eax
  8023fb:	85 c0                	test   %eax,%eax
  8023fd:	74 0f                	je     80240e <alloc_block_FF+0x8b>
  8023ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802402:	8b 40 04             	mov    0x4(%eax),%eax
  802405:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802408:	8b 12                	mov    (%edx),%edx
  80240a:	89 10                	mov    %edx,(%eax)
  80240c:	eb 0a                	jmp    802418 <alloc_block_FF+0x95>
  80240e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802411:	8b 00                	mov    (%eax),%eax
  802413:	a3 38 51 80 00       	mov    %eax,0x805138
  802418:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802421:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802424:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80242b:	a1 44 51 80 00       	mov    0x805144,%eax
  802430:	48                   	dec    %eax
  802431:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802436:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802439:	e9 10 01 00 00       	jmp    80254e <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  80243e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802441:	8b 40 0c             	mov    0xc(%eax),%eax
  802444:	3b 45 08             	cmp    0x8(%ebp),%eax
  802447:	0f 86 c6 00 00 00    	jbe    802513 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80244d:	a1 48 51 80 00       	mov    0x805148,%eax
  802452:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802455:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802458:	8b 50 08             	mov    0x8(%eax),%edx
  80245b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80245e:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802461:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802464:	8b 55 08             	mov    0x8(%ebp),%edx
  802467:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80246a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80246e:	75 17                	jne    802487 <alloc_block_FF+0x104>
  802470:	83 ec 04             	sub    $0x4,%esp
  802473:	68 64 40 80 00       	push   $0x804064
  802478:	68 9b 00 00 00       	push   $0x9b
  80247d:	68 bb 3f 80 00       	push   $0x803fbb
  802482:	e8 f3 0f 00 00       	call   80347a <_panic>
  802487:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80248a:	8b 00                	mov    (%eax),%eax
  80248c:	85 c0                	test   %eax,%eax
  80248e:	74 10                	je     8024a0 <alloc_block_FF+0x11d>
  802490:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802493:	8b 00                	mov    (%eax),%eax
  802495:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802498:	8b 52 04             	mov    0x4(%edx),%edx
  80249b:	89 50 04             	mov    %edx,0x4(%eax)
  80249e:	eb 0b                	jmp    8024ab <alloc_block_FF+0x128>
  8024a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024a3:	8b 40 04             	mov    0x4(%eax),%eax
  8024a6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8024ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ae:	8b 40 04             	mov    0x4(%eax),%eax
  8024b1:	85 c0                	test   %eax,%eax
  8024b3:	74 0f                	je     8024c4 <alloc_block_FF+0x141>
  8024b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024b8:	8b 40 04             	mov    0x4(%eax),%eax
  8024bb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024be:	8b 12                	mov    (%edx),%edx
  8024c0:	89 10                	mov    %edx,(%eax)
  8024c2:	eb 0a                	jmp    8024ce <alloc_block_FF+0x14b>
  8024c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c7:	8b 00                	mov    (%eax),%eax
  8024c9:	a3 48 51 80 00       	mov    %eax,0x805148
  8024ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024da:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024e1:	a1 54 51 80 00       	mov    0x805154,%eax
  8024e6:	48                   	dec    %eax
  8024e7:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8024ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ef:	8b 50 08             	mov    0x8(%eax),%edx
  8024f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f5:	01 c2                	add    %eax,%edx
  8024f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fa:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8024fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802500:	8b 40 0c             	mov    0xc(%eax),%eax
  802503:	2b 45 08             	sub    0x8(%ebp),%eax
  802506:	89 c2                	mov    %eax,%edx
  802508:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250b:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  80250e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802511:	eb 3b                	jmp    80254e <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802513:	a1 40 51 80 00       	mov    0x805140,%eax
  802518:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80251b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80251f:	74 07                	je     802528 <alloc_block_FF+0x1a5>
  802521:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802524:	8b 00                	mov    (%eax),%eax
  802526:	eb 05                	jmp    80252d <alloc_block_FF+0x1aa>
  802528:	b8 00 00 00 00       	mov    $0x0,%eax
  80252d:	a3 40 51 80 00       	mov    %eax,0x805140
  802532:	a1 40 51 80 00       	mov    0x805140,%eax
  802537:	85 c0                	test   %eax,%eax
  802539:	0f 85 57 fe ff ff    	jne    802396 <alloc_block_FF+0x13>
  80253f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802543:	0f 85 4d fe ff ff    	jne    802396 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802549:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80254e:	c9                   	leave  
  80254f:	c3                   	ret    

00802550 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802550:	55                   	push   %ebp
  802551:	89 e5                	mov    %esp,%ebp
  802553:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802556:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80255d:	a1 38 51 80 00       	mov    0x805138,%eax
  802562:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802565:	e9 df 00 00 00       	jmp    802649 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80256a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256d:	8b 40 0c             	mov    0xc(%eax),%eax
  802570:	3b 45 08             	cmp    0x8(%ebp),%eax
  802573:	0f 82 c8 00 00 00    	jb     802641 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802579:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257c:	8b 40 0c             	mov    0xc(%eax),%eax
  80257f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802582:	0f 85 8a 00 00 00    	jne    802612 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802588:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80258c:	75 17                	jne    8025a5 <alloc_block_BF+0x55>
  80258e:	83 ec 04             	sub    $0x4,%esp
  802591:	68 64 40 80 00       	push   $0x804064
  802596:	68 b7 00 00 00       	push   $0xb7
  80259b:	68 bb 3f 80 00       	push   $0x803fbb
  8025a0:	e8 d5 0e 00 00       	call   80347a <_panic>
  8025a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a8:	8b 00                	mov    (%eax),%eax
  8025aa:	85 c0                	test   %eax,%eax
  8025ac:	74 10                	je     8025be <alloc_block_BF+0x6e>
  8025ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b1:	8b 00                	mov    (%eax),%eax
  8025b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025b6:	8b 52 04             	mov    0x4(%edx),%edx
  8025b9:	89 50 04             	mov    %edx,0x4(%eax)
  8025bc:	eb 0b                	jmp    8025c9 <alloc_block_BF+0x79>
  8025be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c1:	8b 40 04             	mov    0x4(%eax),%eax
  8025c4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8025c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cc:	8b 40 04             	mov    0x4(%eax),%eax
  8025cf:	85 c0                	test   %eax,%eax
  8025d1:	74 0f                	je     8025e2 <alloc_block_BF+0x92>
  8025d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d6:	8b 40 04             	mov    0x4(%eax),%eax
  8025d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025dc:	8b 12                	mov    (%edx),%edx
  8025de:	89 10                	mov    %edx,(%eax)
  8025e0:	eb 0a                	jmp    8025ec <alloc_block_BF+0x9c>
  8025e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e5:	8b 00                	mov    (%eax),%eax
  8025e7:	a3 38 51 80 00       	mov    %eax,0x805138
  8025ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025ff:	a1 44 51 80 00       	mov    0x805144,%eax
  802604:	48                   	dec    %eax
  802605:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  80260a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260d:	e9 4d 01 00 00       	jmp    80275f <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802612:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802615:	8b 40 0c             	mov    0xc(%eax),%eax
  802618:	3b 45 08             	cmp    0x8(%ebp),%eax
  80261b:	76 24                	jbe    802641 <alloc_block_BF+0xf1>
  80261d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802620:	8b 40 0c             	mov    0xc(%eax),%eax
  802623:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802626:	73 19                	jae    802641 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802628:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  80262f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802632:	8b 40 0c             	mov    0xc(%eax),%eax
  802635:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802638:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263b:	8b 40 08             	mov    0x8(%eax),%eax
  80263e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802641:	a1 40 51 80 00       	mov    0x805140,%eax
  802646:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802649:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80264d:	74 07                	je     802656 <alloc_block_BF+0x106>
  80264f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802652:	8b 00                	mov    (%eax),%eax
  802654:	eb 05                	jmp    80265b <alloc_block_BF+0x10b>
  802656:	b8 00 00 00 00       	mov    $0x0,%eax
  80265b:	a3 40 51 80 00       	mov    %eax,0x805140
  802660:	a1 40 51 80 00       	mov    0x805140,%eax
  802665:	85 c0                	test   %eax,%eax
  802667:	0f 85 fd fe ff ff    	jne    80256a <alloc_block_BF+0x1a>
  80266d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802671:	0f 85 f3 fe ff ff    	jne    80256a <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802677:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80267b:	0f 84 d9 00 00 00    	je     80275a <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802681:	a1 48 51 80 00       	mov    0x805148,%eax
  802686:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802689:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80268c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80268f:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802692:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802695:	8b 55 08             	mov    0x8(%ebp),%edx
  802698:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  80269b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80269f:	75 17                	jne    8026b8 <alloc_block_BF+0x168>
  8026a1:	83 ec 04             	sub    $0x4,%esp
  8026a4:	68 64 40 80 00       	push   $0x804064
  8026a9:	68 c7 00 00 00       	push   $0xc7
  8026ae:	68 bb 3f 80 00       	push   $0x803fbb
  8026b3:	e8 c2 0d 00 00       	call   80347a <_panic>
  8026b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026bb:	8b 00                	mov    (%eax),%eax
  8026bd:	85 c0                	test   %eax,%eax
  8026bf:	74 10                	je     8026d1 <alloc_block_BF+0x181>
  8026c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026c4:	8b 00                	mov    (%eax),%eax
  8026c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026c9:	8b 52 04             	mov    0x4(%edx),%edx
  8026cc:	89 50 04             	mov    %edx,0x4(%eax)
  8026cf:	eb 0b                	jmp    8026dc <alloc_block_BF+0x18c>
  8026d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026d4:	8b 40 04             	mov    0x4(%eax),%eax
  8026d7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8026dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026df:	8b 40 04             	mov    0x4(%eax),%eax
  8026e2:	85 c0                	test   %eax,%eax
  8026e4:	74 0f                	je     8026f5 <alloc_block_BF+0x1a5>
  8026e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026e9:	8b 40 04             	mov    0x4(%eax),%eax
  8026ec:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026ef:	8b 12                	mov    (%edx),%edx
  8026f1:	89 10                	mov    %edx,(%eax)
  8026f3:	eb 0a                	jmp    8026ff <alloc_block_BF+0x1af>
  8026f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026f8:	8b 00                	mov    (%eax),%eax
  8026fa:	a3 48 51 80 00       	mov    %eax,0x805148
  8026ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802702:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802708:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80270b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802712:	a1 54 51 80 00       	mov    0x805154,%eax
  802717:	48                   	dec    %eax
  802718:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  80271d:	83 ec 08             	sub    $0x8,%esp
  802720:	ff 75 ec             	pushl  -0x14(%ebp)
  802723:	68 38 51 80 00       	push   $0x805138
  802728:	e8 71 f9 ff ff       	call   80209e <find_block>
  80272d:	83 c4 10             	add    $0x10,%esp
  802730:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802733:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802736:	8b 50 08             	mov    0x8(%eax),%edx
  802739:	8b 45 08             	mov    0x8(%ebp),%eax
  80273c:	01 c2                	add    %eax,%edx
  80273e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802741:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802744:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802747:	8b 40 0c             	mov    0xc(%eax),%eax
  80274a:	2b 45 08             	sub    0x8(%ebp),%eax
  80274d:	89 c2                	mov    %eax,%edx
  80274f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802752:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802755:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802758:	eb 05                	jmp    80275f <alloc_block_BF+0x20f>
	}
	return NULL;
  80275a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80275f:	c9                   	leave  
  802760:	c3                   	ret    

00802761 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802761:	55                   	push   %ebp
  802762:	89 e5                	mov    %esp,%ebp
  802764:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802767:	a1 28 50 80 00       	mov    0x805028,%eax
  80276c:	85 c0                	test   %eax,%eax
  80276e:	0f 85 de 01 00 00    	jne    802952 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802774:	a1 38 51 80 00       	mov    0x805138,%eax
  802779:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80277c:	e9 9e 01 00 00       	jmp    80291f <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802781:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802784:	8b 40 0c             	mov    0xc(%eax),%eax
  802787:	3b 45 08             	cmp    0x8(%ebp),%eax
  80278a:	0f 82 87 01 00 00    	jb     802917 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802790:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802793:	8b 40 0c             	mov    0xc(%eax),%eax
  802796:	3b 45 08             	cmp    0x8(%ebp),%eax
  802799:	0f 85 95 00 00 00    	jne    802834 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  80279f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027a3:	75 17                	jne    8027bc <alloc_block_NF+0x5b>
  8027a5:	83 ec 04             	sub    $0x4,%esp
  8027a8:	68 64 40 80 00       	push   $0x804064
  8027ad:	68 e0 00 00 00       	push   $0xe0
  8027b2:	68 bb 3f 80 00       	push   $0x803fbb
  8027b7:	e8 be 0c 00 00       	call   80347a <_panic>
  8027bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bf:	8b 00                	mov    (%eax),%eax
  8027c1:	85 c0                	test   %eax,%eax
  8027c3:	74 10                	je     8027d5 <alloc_block_NF+0x74>
  8027c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c8:	8b 00                	mov    (%eax),%eax
  8027ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027cd:	8b 52 04             	mov    0x4(%edx),%edx
  8027d0:	89 50 04             	mov    %edx,0x4(%eax)
  8027d3:	eb 0b                	jmp    8027e0 <alloc_block_NF+0x7f>
  8027d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d8:	8b 40 04             	mov    0x4(%eax),%eax
  8027db:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8027e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e3:	8b 40 04             	mov    0x4(%eax),%eax
  8027e6:	85 c0                	test   %eax,%eax
  8027e8:	74 0f                	je     8027f9 <alloc_block_NF+0x98>
  8027ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ed:	8b 40 04             	mov    0x4(%eax),%eax
  8027f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027f3:	8b 12                	mov    (%edx),%edx
  8027f5:	89 10                	mov    %edx,(%eax)
  8027f7:	eb 0a                	jmp    802803 <alloc_block_NF+0xa2>
  8027f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fc:	8b 00                	mov    (%eax),%eax
  8027fe:	a3 38 51 80 00       	mov    %eax,0x805138
  802803:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802806:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80280c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802816:	a1 44 51 80 00       	mov    0x805144,%eax
  80281b:	48                   	dec    %eax
  80281c:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802821:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802824:	8b 40 08             	mov    0x8(%eax),%eax
  802827:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  80282c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282f:	e9 f8 04 00 00       	jmp    802d2c <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802834:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802837:	8b 40 0c             	mov    0xc(%eax),%eax
  80283a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80283d:	0f 86 d4 00 00 00    	jbe    802917 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802843:	a1 48 51 80 00       	mov    0x805148,%eax
  802848:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  80284b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284e:	8b 50 08             	mov    0x8(%eax),%edx
  802851:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802854:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802857:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80285a:	8b 55 08             	mov    0x8(%ebp),%edx
  80285d:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802860:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802864:	75 17                	jne    80287d <alloc_block_NF+0x11c>
  802866:	83 ec 04             	sub    $0x4,%esp
  802869:	68 64 40 80 00       	push   $0x804064
  80286e:	68 e9 00 00 00       	push   $0xe9
  802873:	68 bb 3f 80 00       	push   $0x803fbb
  802878:	e8 fd 0b 00 00       	call   80347a <_panic>
  80287d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802880:	8b 00                	mov    (%eax),%eax
  802882:	85 c0                	test   %eax,%eax
  802884:	74 10                	je     802896 <alloc_block_NF+0x135>
  802886:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802889:	8b 00                	mov    (%eax),%eax
  80288b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80288e:	8b 52 04             	mov    0x4(%edx),%edx
  802891:	89 50 04             	mov    %edx,0x4(%eax)
  802894:	eb 0b                	jmp    8028a1 <alloc_block_NF+0x140>
  802896:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802899:	8b 40 04             	mov    0x4(%eax),%eax
  80289c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a4:	8b 40 04             	mov    0x4(%eax),%eax
  8028a7:	85 c0                	test   %eax,%eax
  8028a9:	74 0f                	je     8028ba <alloc_block_NF+0x159>
  8028ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ae:	8b 40 04             	mov    0x4(%eax),%eax
  8028b1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028b4:	8b 12                	mov    (%edx),%edx
  8028b6:	89 10                	mov    %edx,(%eax)
  8028b8:	eb 0a                	jmp    8028c4 <alloc_block_NF+0x163>
  8028ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028bd:	8b 00                	mov    (%eax),%eax
  8028bf:	a3 48 51 80 00       	mov    %eax,0x805148
  8028c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028d7:	a1 54 51 80 00       	mov    0x805154,%eax
  8028dc:	48                   	dec    %eax
  8028dd:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  8028e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e5:	8b 40 08             	mov    0x8(%eax),%eax
  8028e8:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8028ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f0:	8b 50 08             	mov    0x8(%eax),%edx
  8028f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f6:	01 c2                	add    %eax,%edx
  8028f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fb:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8028fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802901:	8b 40 0c             	mov    0xc(%eax),%eax
  802904:	2b 45 08             	sub    0x8(%ebp),%eax
  802907:	89 c2                	mov    %eax,%edx
  802909:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290c:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  80290f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802912:	e9 15 04 00 00       	jmp    802d2c <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802917:	a1 40 51 80 00       	mov    0x805140,%eax
  80291c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80291f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802923:	74 07                	je     80292c <alloc_block_NF+0x1cb>
  802925:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802928:	8b 00                	mov    (%eax),%eax
  80292a:	eb 05                	jmp    802931 <alloc_block_NF+0x1d0>
  80292c:	b8 00 00 00 00       	mov    $0x0,%eax
  802931:	a3 40 51 80 00       	mov    %eax,0x805140
  802936:	a1 40 51 80 00       	mov    0x805140,%eax
  80293b:	85 c0                	test   %eax,%eax
  80293d:	0f 85 3e fe ff ff    	jne    802781 <alloc_block_NF+0x20>
  802943:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802947:	0f 85 34 fe ff ff    	jne    802781 <alloc_block_NF+0x20>
  80294d:	e9 d5 03 00 00       	jmp    802d27 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802952:	a1 38 51 80 00       	mov    0x805138,%eax
  802957:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80295a:	e9 b1 01 00 00       	jmp    802b10 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  80295f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802962:	8b 50 08             	mov    0x8(%eax),%edx
  802965:	a1 28 50 80 00       	mov    0x805028,%eax
  80296a:	39 c2                	cmp    %eax,%edx
  80296c:	0f 82 96 01 00 00    	jb     802b08 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802972:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802975:	8b 40 0c             	mov    0xc(%eax),%eax
  802978:	3b 45 08             	cmp    0x8(%ebp),%eax
  80297b:	0f 82 87 01 00 00    	jb     802b08 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802981:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802984:	8b 40 0c             	mov    0xc(%eax),%eax
  802987:	3b 45 08             	cmp    0x8(%ebp),%eax
  80298a:	0f 85 95 00 00 00    	jne    802a25 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802990:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802994:	75 17                	jne    8029ad <alloc_block_NF+0x24c>
  802996:	83 ec 04             	sub    $0x4,%esp
  802999:	68 64 40 80 00       	push   $0x804064
  80299e:	68 fc 00 00 00       	push   $0xfc
  8029a3:	68 bb 3f 80 00       	push   $0x803fbb
  8029a8:	e8 cd 0a 00 00       	call   80347a <_panic>
  8029ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b0:	8b 00                	mov    (%eax),%eax
  8029b2:	85 c0                	test   %eax,%eax
  8029b4:	74 10                	je     8029c6 <alloc_block_NF+0x265>
  8029b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b9:	8b 00                	mov    (%eax),%eax
  8029bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029be:	8b 52 04             	mov    0x4(%edx),%edx
  8029c1:	89 50 04             	mov    %edx,0x4(%eax)
  8029c4:	eb 0b                	jmp    8029d1 <alloc_block_NF+0x270>
  8029c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c9:	8b 40 04             	mov    0x4(%eax),%eax
  8029cc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8029d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d4:	8b 40 04             	mov    0x4(%eax),%eax
  8029d7:	85 c0                	test   %eax,%eax
  8029d9:	74 0f                	je     8029ea <alloc_block_NF+0x289>
  8029db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029de:	8b 40 04             	mov    0x4(%eax),%eax
  8029e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029e4:	8b 12                	mov    (%edx),%edx
  8029e6:	89 10                	mov    %edx,(%eax)
  8029e8:	eb 0a                	jmp    8029f4 <alloc_block_NF+0x293>
  8029ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ed:	8b 00                	mov    (%eax),%eax
  8029ef:	a3 38 51 80 00       	mov    %eax,0x805138
  8029f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a00:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a07:	a1 44 51 80 00       	mov    0x805144,%eax
  802a0c:	48                   	dec    %eax
  802a0d:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a15:	8b 40 08             	mov    0x8(%eax),%eax
  802a18:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a20:	e9 07 03 00 00       	jmp    802d2c <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a28:	8b 40 0c             	mov    0xc(%eax),%eax
  802a2b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a2e:	0f 86 d4 00 00 00    	jbe    802b08 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a34:	a1 48 51 80 00       	mov    0x805148,%eax
  802a39:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3f:	8b 50 08             	mov    0x8(%eax),%edx
  802a42:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a45:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802a48:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a4b:	8b 55 08             	mov    0x8(%ebp),%edx
  802a4e:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802a51:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a55:	75 17                	jne    802a6e <alloc_block_NF+0x30d>
  802a57:	83 ec 04             	sub    $0x4,%esp
  802a5a:	68 64 40 80 00       	push   $0x804064
  802a5f:	68 04 01 00 00       	push   $0x104
  802a64:	68 bb 3f 80 00       	push   $0x803fbb
  802a69:	e8 0c 0a 00 00       	call   80347a <_panic>
  802a6e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a71:	8b 00                	mov    (%eax),%eax
  802a73:	85 c0                	test   %eax,%eax
  802a75:	74 10                	je     802a87 <alloc_block_NF+0x326>
  802a77:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a7a:	8b 00                	mov    (%eax),%eax
  802a7c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a7f:	8b 52 04             	mov    0x4(%edx),%edx
  802a82:	89 50 04             	mov    %edx,0x4(%eax)
  802a85:	eb 0b                	jmp    802a92 <alloc_block_NF+0x331>
  802a87:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a8a:	8b 40 04             	mov    0x4(%eax),%eax
  802a8d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a92:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a95:	8b 40 04             	mov    0x4(%eax),%eax
  802a98:	85 c0                	test   %eax,%eax
  802a9a:	74 0f                	je     802aab <alloc_block_NF+0x34a>
  802a9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a9f:	8b 40 04             	mov    0x4(%eax),%eax
  802aa2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802aa5:	8b 12                	mov    (%edx),%edx
  802aa7:	89 10                	mov    %edx,(%eax)
  802aa9:	eb 0a                	jmp    802ab5 <alloc_block_NF+0x354>
  802aab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aae:	8b 00                	mov    (%eax),%eax
  802ab0:	a3 48 51 80 00       	mov    %eax,0x805148
  802ab5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ab8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802abe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ac1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ac8:	a1 54 51 80 00       	mov    0x805154,%eax
  802acd:	48                   	dec    %eax
  802ace:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802ad3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ad6:	8b 40 08             	mov    0x8(%eax),%eax
  802ad9:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802ade:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae1:	8b 50 08             	mov    0x8(%eax),%edx
  802ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae7:	01 c2                	add    %eax,%edx
  802ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aec:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af2:	8b 40 0c             	mov    0xc(%eax),%eax
  802af5:	2b 45 08             	sub    0x8(%ebp),%eax
  802af8:	89 c2                	mov    %eax,%edx
  802afa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afd:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802b00:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b03:	e9 24 02 00 00       	jmp    802d2c <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b08:	a1 40 51 80 00       	mov    0x805140,%eax
  802b0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b10:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b14:	74 07                	je     802b1d <alloc_block_NF+0x3bc>
  802b16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b19:	8b 00                	mov    (%eax),%eax
  802b1b:	eb 05                	jmp    802b22 <alloc_block_NF+0x3c1>
  802b1d:	b8 00 00 00 00       	mov    $0x0,%eax
  802b22:	a3 40 51 80 00       	mov    %eax,0x805140
  802b27:	a1 40 51 80 00       	mov    0x805140,%eax
  802b2c:	85 c0                	test   %eax,%eax
  802b2e:	0f 85 2b fe ff ff    	jne    80295f <alloc_block_NF+0x1fe>
  802b34:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b38:	0f 85 21 fe ff ff    	jne    80295f <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b3e:	a1 38 51 80 00       	mov    0x805138,%eax
  802b43:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b46:	e9 ae 01 00 00       	jmp    802cf9 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4e:	8b 50 08             	mov    0x8(%eax),%edx
  802b51:	a1 28 50 80 00       	mov    0x805028,%eax
  802b56:	39 c2                	cmp    %eax,%edx
  802b58:	0f 83 93 01 00 00    	jae    802cf1 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802b5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b61:	8b 40 0c             	mov    0xc(%eax),%eax
  802b64:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b67:	0f 82 84 01 00 00    	jb     802cf1 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802b6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b70:	8b 40 0c             	mov    0xc(%eax),%eax
  802b73:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b76:	0f 85 95 00 00 00    	jne    802c11 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802b7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b80:	75 17                	jne    802b99 <alloc_block_NF+0x438>
  802b82:	83 ec 04             	sub    $0x4,%esp
  802b85:	68 64 40 80 00       	push   $0x804064
  802b8a:	68 14 01 00 00       	push   $0x114
  802b8f:	68 bb 3f 80 00       	push   $0x803fbb
  802b94:	e8 e1 08 00 00       	call   80347a <_panic>
  802b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9c:	8b 00                	mov    (%eax),%eax
  802b9e:	85 c0                	test   %eax,%eax
  802ba0:	74 10                	je     802bb2 <alloc_block_NF+0x451>
  802ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba5:	8b 00                	mov    (%eax),%eax
  802ba7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802baa:	8b 52 04             	mov    0x4(%edx),%edx
  802bad:	89 50 04             	mov    %edx,0x4(%eax)
  802bb0:	eb 0b                	jmp    802bbd <alloc_block_NF+0x45c>
  802bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb5:	8b 40 04             	mov    0x4(%eax),%eax
  802bb8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802bbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc0:	8b 40 04             	mov    0x4(%eax),%eax
  802bc3:	85 c0                	test   %eax,%eax
  802bc5:	74 0f                	je     802bd6 <alloc_block_NF+0x475>
  802bc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bca:	8b 40 04             	mov    0x4(%eax),%eax
  802bcd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bd0:	8b 12                	mov    (%edx),%edx
  802bd2:	89 10                	mov    %edx,(%eax)
  802bd4:	eb 0a                	jmp    802be0 <alloc_block_NF+0x47f>
  802bd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd9:	8b 00                	mov    (%eax),%eax
  802bdb:	a3 38 51 80 00       	mov    %eax,0x805138
  802be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bf3:	a1 44 51 80 00       	mov    0x805144,%eax
  802bf8:	48                   	dec    %eax
  802bf9:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802bfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c01:	8b 40 08             	mov    0x8(%eax),%eax
  802c04:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802c09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0c:	e9 1b 01 00 00       	jmp    802d2c <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802c11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c14:	8b 40 0c             	mov    0xc(%eax),%eax
  802c17:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c1a:	0f 86 d1 00 00 00    	jbe    802cf1 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802c20:	a1 48 51 80 00       	mov    0x805148,%eax
  802c25:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2b:	8b 50 08             	mov    0x8(%eax),%edx
  802c2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c31:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802c34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c37:	8b 55 08             	mov    0x8(%ebp),%edx
  802c3a:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802c3d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c41:	75 17                	jne    802c5a <alloc_block_NF+0x4f9>
  802c43:	83 ec 04             	sub    $0x4,%esp
  802c46:	68 64 40 80 00       	push   $0x804064
  802c4b:	68 1c 01 00 00       	push   $0x11c
  802c50:	68 bb 3f 80 00       	push   $0x803fbb
  802c55:	e8 20 08 00 00       	call   80347a <_panic>
  802c5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c5d:	8b 00                	mov    (%eax),%eax
  802c5f:	85 c0                	test   %eax,%eax
  802c61:	74 10                	je     802c73 <alloc_block_NF+0x512>
  802c63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c66:	8b 00                	mov    (%eax),%eax
  802c68:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c6b:	8b 52 04             	mov    0x4(%edx),%edx
  802c6e:	89 50 04             	mov    %edx,0x4(%eax)
  802c71:	eb 0b                	jmp    802c7e <alloc_block_NF+0x51d>
  802c73:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c76:	8b 40 04             	mov    0x4(%eax),%eax
  802c79:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c81:	8b 40 04             	mov    0x4(%eax),%eax
  802c84:	85 c0                	test   %eax,%eax
  802c86:	74 0f                	je     802c97 <alloc_block_NF+0x536>
  802c88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c8b:	8b 40 04             	mov    0x4(%eax),%eax
  802c8e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c91:	8b 12                	mov    (%edx),%edx
  802c93:	89 10                	mov    %edx,(%eax)
  802c95:	eb 0a                	jmp    802ca1 <alloc_block_NF+0x540>
  802c97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c9a:	8b 00                	mov    (%eax),%eax
  802c9c:	a3 48 51 80 00       	mov    %eax,0x805148
  802ca1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ca4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802caa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cb4:	a1 54 51 80 00       	mov    0x805154,%eax
  802cb9:	48                   	dec    %eax
  802cba:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802cbf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cc2:	8b 40 08             	mov    0x8(%eax),%eax
  802cc5:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802cca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccd:	8b 50 08             	mov    0x8(%eax),%edx
  802cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd3:	01 c2                	add    %eax,%edx
  802cd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd8:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802cdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cde:	8b 40 0c             	mov    0xc(%eax),%eax
  802ce1:	2b 45 08             	sub    0x8(%ebp),%eax
  802ce4:	89 c2                	mov    %eax,%edx
  802ce6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce9:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802cec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cef:	eb 3b                	jmp    802d2c <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802cf1:	a1 40 51 80 00       	mov    0x805140,%eax
  802cf6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cf9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cfd:	74 07                	je     802d06 <alloc_block_NF+0x5a5>
  802cff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d02:	8b 00                	mov    (%eax),%eax
  802d04:	eb 05                	jmp    802d0b <alloc_block_NF+0x5aa>
  802d06:	b8 00 00 00 00       	mov    $0x0,%eax
  802d0b:	a3 40 51 80 00       	mov    %eax,0x805140
  802d10:	a1 40 51 80 00       	mov    0x805140,%eax
  802d15:	85 c0                	test   %eax,%eax
  802d17:	0f 85 2e fe ff ff    	jne    802b4b <alloc_block_NF+0x3ea>
  802d1d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d21:	0f 85 24 fe ff ff    	jne    802b4b <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802d27:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d2c:	c9                   	leave  
  802d2d:	c3                   	ret    

00802d2e <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802d2e:	55                   	push   %ebp
  802d2f:	89 e5                	mov    %esp,%ebp
  802d31:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802d34:	a1 38 51 80 00       	mov    0x805138,%eax
  802d39:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802d3c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d41:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802d44:	a1 38 51 80 00       	mov    0x805138,%eax
  802d49:	85 c0                	test   %eax,%eax
  802d4b:	74 14                	je     802d61 <insert_sorted_with_merge_freeList+0x33>
  802d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d50:	8b 50 08             	mov    0x8(%eax),%edx
  802d53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d56:	8b 40 08             	mov    0x8(%eax),%eax
  802d59:	39 c2                	cmp    %eax,%edx
  802d5b:	0f 87 9b 01 00 00    	ja     802efc <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802d61:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d65:	75 17                	jne    802d7e <insert_sorted_with_merge_freeList+0x50>
  802d67:	83 ec 04             	sub    $0x4,%esp
  802d6a:	68 98 3f 80 00       	push   $0x803f98
  802d6f:	68 38 01 00 00       	push   $0x138
  802d74:	68 bb 3f 80 00       	push   $0x803fbb
  802d79:	e8 fc 06 00 00       	call   80347a <_panic>
  802d7e:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802d84:	8b 45 08             	mov    0x8(%ebp),%eax
  802d87:	89 10                	mov    %edx,(%eax)
  802d89:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8c:	8b 00                	mov    (%eax),%eax
  802d8e:	85 c0                	test   %eax,%eax
  802d90:	74 0d                	je     802d9f <insert_sorted_with_merge_freeList+0x71>
  802d92:	a1 38 51 80 00       	mov    0x805138,%eax
  802d97:	8b 55 08             	mov    0x8(%ebp),%edx
  802d9a:	89 50 04             	mov    %edx,0x4(%eax)
  802d9d:	eb 08                	jmp    802da7 <insert_sorted_with_merge_freeList+0x79>
  802d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802da2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802da7:	8b 45 08             	mov    0x8(%ebp),%eax
  802daa:	a3 38 51 80 00       	mov    %eax,0x805138
  802daf:	8b 45 08             	mov    0x8(%ebp),%eax
  802db2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802db9:	a1 44 51 80 00       	mov    0x805144,%eax
  802dbe:	40                   	inc    %eax
  802dbf:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802dc4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dc8:	0f 84 a8 06 00 00    	je     803476 <insert_sorted_with_merge_freeList+0x748>
  802dce:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd1:	8b 50 08             	mov    0x8(%eax),%edx
  802dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd7:	8b 40 0c             	mov    0xc(%eax),%eax
  802dda:	01 c2                	add    %eax,%edx
  802ddc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ddf:	8b 40 08             	mov    0x8(%eax),%eax
  802de2:	39 c2                	cmp    %eax,%edx
  802de4:	0f 85 8c 06 00 00    	jne    803476 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802dea:	8b 45 08             	mov    0x8(%ebp),%eax
  802ded:	8b 50 0c             	mov    0xc(%eax),%edx
  802df0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df3:	8b 40 0c             	mov    0xc(%eax),%eax
  802df6:	01 c2                	add    %eax,%edx
  802df8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfb:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802dfe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e02:	75 17                	jne    802e1b <insert_sorted_with_merge_freeList+0xed>
  802e04:	83 ec 04             	sub    $0x4,%esp
  802e07:	68 64 40 80 00       	push   $0x804064
  802e0c:	68 3c 01 00 00       	push   $0x13c
  802e11:	68 bb 3f 80 00       	push   $0x803fbb
  802e16:	e8 5f 06 00 00       	call   80347a <_panic>
  802e1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e1e:	8b 00                	mov    (%eax),%eax
  802e20:	85 c0                	test   %eax,%eax
  802e22:	74 10                	je     802e34 <insert_sorted_with_merge_freeList+0x106>
  802e24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e27:	8b 00                	mov    (%eax),%eax
  802e29:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e2c:	8b 52 04             	mov    0x4(%edx),%edx
  802e2f:	89 50 04             	mov    %edx,0x4(%eax)
  802e32:	eb 0b                	jmp    802e3f <insert_sorted_with_merge_freeList+0x111>
  802e34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e37:	8b 40 04             	mov    0x4(%eax),%eax
  802e3a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e42:	8b 40 04             	mov    0x4(%eax),%eax
  802e45:	85 c0                	test   %eax,%eax
  802e47:	74 0f                	je     802e58 <insert_sorted_with_merge_freeList+0x12a>
  802e49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e4c:	8b 40 04             	mov    0x4(%eax),%eax
  802e4f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e52:	8b 12                	mov    (%edx),%edx
  802e54:	89 10                	mov    %edx,(%eax)
  802e56:	eb 0a                	jmp    802e62 <insert_sorted_with_merge_freeList+0x134>
  802e58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e5b:	8b 00                	mov    (%eax),%eax
  802e5d:	a3 38 51 80 00       	mov    %eax,0x805138
  802e62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e65:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e6e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e75:	a1 44 51 80 00       	mov    0x805144,%eax
  802e7a:	48                   	dec    %eax
  802e7b:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802e80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e83:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802e8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e8d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802e94:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e98:	75 17                	jne    802eb1 <insert_sorted_with_merge_freeList+0x183>
  802e9a:	83 ec 04             	sub    $0x4,%esp
  802e9d:	68 98 3f 80 00       	push   $0x803f98
  802ea2:	68 3f 01 00 00       	push   $0x13f
  802ea7:	68 bb 3f 80 00       	push   $0x803fbb
  802eac:	e8 c9 05 00 00       	call   80347a <_panic>
  802eb1:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802eb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eba:	89 10                	mov    %edx,(%eax)
  802ebc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ebf:	8b 00                	mov    (%eax),%eax
  802ec1:	85 c0                	test   %eax,%eax
  802ec3:	74 0d                	je     802ed2 <insert_sorted_with_merge_freeList+0x1a4>
  802ec5:	a1 48 51 80 00       	mov    0x805148,%eax
  802eca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ecd:	89 50 04             	mov    %edx,0x4(%eax)
  802ed0:	eb 08                	jmp    802eda <insert_sorted_with_merge_freeList+0x1ac>
  802ed2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802eda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802edd:	a3 48 51 80 00       	mov    %eax,0x805148
  802ee2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eec:	a1 54 51 80 00       	mov    0x805154,%eax
  802ef1:	40                   	inc    %eax
  802ef2:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802ef7:	e9 7a 05 00 00       	jmp    803476 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802efc:	8b 45 08             	mov    0x8(%ebp),%eax
  802eff:	8b 50 08             	mov    0x8(%eax),%edx
  802f02:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f05:	8b 40 08             	mov    0x8(%eax),%eax
  802f08:	39 c2                	cmp    %eax,%edx
  802f0a:	0f 82 14 01 00 00    	jb     803024 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802f10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f13:	8b 50 08             	mov    0x8(%eax),%edx
  802f16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f19:	8b 40 0c             	mov    0xc(%eax),%eax
  802f1c:	01 c2                	add    %eax,%edx
  802f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f21:	8b 40 08             	mov    0x8(%eax),%eax
  802f24:	39 c2                	cmp    %eax,%edx
  802f26:	0f 85 90 00 00 00    	jne    802fbc <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802f2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f2f:	8b 50 0c             	mov    0xc(%eax),%edx
  802f32:	8b 45 08             	mov    0x8(%ebp),%eax
  802f35:	8b 40 0c             	mov    0xc(%eax),%eax
  802f38:	01 c2                	add    %eax,%edx
  802f3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f3d:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802f40:	8b 45 08             	mov    0x8(%ebp),%eax
  802f43:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802f54:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f58:	75 17                	jne    802f71 <insert_sorted_with_merge_freeList+0x243>
  802f5a:	83 ec 04             	sub    $0x4,%esp
  802f5d:	68 98 3f 80 00       	push   $0x803f98
  802f62:	68 49 01 00 00       	push   $0x149
  802f67:	68 bb 3f 80 00       	push   $0x803fbb
  802f6c:	e8 09 05 00 00       	call   80347a <_panic>
  802f71:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f77:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7a:	89 10                	mov    %edx,(%eax)
  802f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7f:	8b 00                	mov    (%eax),%eax
  802f81:	85 c0                	test   %eax,%eax
  802f83:	74 0d                	je     802f92 <insert_sorted_with_merge_freeList+0x264>
  802f85:	a1 48 51 80 00       	mov    0x805148,%eax
  802f8a:	8b 55 08             	mov    0x8(%ebp),%edx
  802f8d:	89 50 04             	mov    %edx,0x4(%eax)
  802f90:	eb 08                	jmp    802f9a <insert_sorted_with_merge_freeList+0x26c>
  802f92:	8b 45 08             	mov    0x8(%ebp),%eax
  802f95:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9d:	a3 48 51 80 00       	mov    %eax,0x805148
  802fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fac:	a1 54 51 80 00       	mov    0x805154,%eax
  802fb1:	40                   	inc    %eax
  802fb2:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802fb7:	e9 bb 04 00 00       	jmp    803477 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802fbc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fc0:	75 17                	jne    802fd9 <insert_sorted_with_merge_freeList+0x2ab>
  802fc2:	83 ec 04             	sub    $0x4,%esp
  802fc5:	68 0c 40 80 00       	push   $0x80400c
  802fca:	68 4c 01 00 00       	push   $0x14c
  802fcf:	68 bb 3f 80 00       	push   $0x803fbb
  802fd4:	e8 a1 04 00 00       	call   80347a <_panic>
  802fd9:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe2:	89 50 04             	mov    %edx,0x4(%eax)
  802fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe8:	8b 40 04             	mov    0x4(%eax),%eax
  802feb:	85 c0                	test   %eax,%eax
  802fed:	74 0c                	je     802ffb <insert_sorted_with_merge_freeList+0x2cd>
  802fef:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802ff4:	8b 55 08             	mov    0x8(%ebp),%edx
  802ff7:	89 10                	mov    %edx,(%eax)
  802ff9:	eb 08                	jmp    803003 <insert_sorted_with_merge_freeList+0x2d5>
  802ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffe:	a3 38 51 80 00       	mov    %eax,0x805138
  803003:	8b 45 08             	mov    0x8(%ebp),%eax
  803006:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80300b:	8b 45 08             	mov    0x8(%ebp),%eax
  80300e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803014:	a1 44 51 80 00       	mov    0x805144,%eax
  803019:	40                   	inc    %eax
  80301a:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80301f:	e9 53 04 00 00       	jmp    803477 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803024:	a1 38 51 80 00       	mov    0x805138,%eax
  803029:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80302c:	e9 15 04 00 00       	jmp    803446 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803031:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803034:	8b 00                	mov    (%eax),%eax
  803036:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803039:	8b 45 08             	mov    0x8(%ebp),%eax
  80303c:	8b 50 08             	mov    0x8(%eax),%edx
  80303f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803042:	8b 40 08             	mov    0x8(%eax),%eax
  803045:	39 c2                	cmp    %eax,%edx
  803047:	0f 86 f1 03 00 00    	jbe    80343e <insert_sorted_with_merge_freeList+0x710>
  80304d:	8b 45 08             	mov    0x8(%ebp),%eax
  803050:	8b 50 08             	mov    0x8(%eax),%edx
  803053:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803056:	8b 40 08             	mov    0x8(%eax),%eax
  803059:	39 c2                	cmp    %eax,%edx
  80305b:	0f 83 dd 03 00 00    	jae    80343e <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803061:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803064:	8b 50 08             	mov    0x8(%eax),%edx
  803067:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306a:	8b 40 0c             	mov    0xc(%eax),%eax
  80306d:	01 c2                	add    %eax,%edx
  80306f:	8b 45 08             	mov    0x8(%ebp),%eax
  803072:	8b 40 08             	mov    0x8(%eax),%eax
  803075:	39 c2                	cmp    %eax,%edx
  803077:	0f 85 b9 01 00 00    	jne    803236 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80307d:	8b 45 08             	mov    0x8(%ebp),%eax
  803080:	8b 50 08             	mov    0x8(%eax),%edx
  803083:	8b 45 08             	mov    0x8(%ebp),%eax
  803086:	8b 40 0c             	mov    0xc(%eax),%eax
  803089:	01 c2                	add    %eax,%edx
  80308b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80308e:	8b 40 08             	mov    0x8(%eax),%eax
  803091:	39 c2                	cmp    %eax,%edx
  803093:	0f 85 0d 01 00 00    	jne    8031a6 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803099:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309c:	8b 50 0c             	mov    0xc(%eax),%edx
  80309f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8030a5:	01 c2                	add    %eax,%edx
  8030a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030aa:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8030ad:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030b1:	75 17                	jne    8030ca <insert_sorted_with_merge_freeList+0x39c>
  8030b3:	83 ec 04             	sub    $0x4,%esp
  8030b6:	68 64 40 80 00       	push   $0x804064
  8030bb:	68 5c 01 00 00       	push   $0x15c
  8030c0:	68 bb 3f 80 00       	push   $0x803fbb
  8030c5:	e8 b0 03 00 00       	call   80347a <_panic>
  8030ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030cd:	8b 00                	mov    (%eax),%eax
  8030cf:	85 c0                	test   %eax,%eax
  8030d1:	74 10                	je     8030e3 <insert_sorted_with_merge_freeList+0x3b5>
  8030d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d6:	8b 00                	mov    (%eax),%eax
  8030d8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030db:	8b 52 04             	mov    0x4(%edx),%edx
  8030de:	89 50 04             	mov    %edx,0x4(%eax)
  8030e1:	eb 0b                	jmp    8030ee <insert_sorted_with_merge_freeList+0x3c0>
  8030e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e6:	8b 40 04             	mov    0x4(%eax),%eax
  8030e9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f1:	8b 40 04             	mov    0x4(%eax),%eax
  8030f4:	85 c0                	test   %eax,%eax
  8030f6:	74 0f                	je     803107 <insert_sorted_with_merge_freeList+0x3d9>
  8030f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030fb:	8b 40 04             	mov    0x4(%eax),%eax
  8030fe:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803101:	8b 12                	mov    (%edx),%edx
  803103:	89 10                	mov    %edx,(%eax)
  803105:	eb 0a                	jmp    803111 <insert_sorted_with_merge_freeList+0x3e3>
  803107:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80310a:	8b 00                	mov    (%eax),%eax
  80310c:	a3 38 51 80 00       	mov    %eax,0x805138
  803111:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803114:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80311a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80311d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803124:	a1 44 51 80 00       	mov    0x805144,%eax
  803129:	48                   	dec    %eax
  80312a:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  80312f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803132:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803139:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80313c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803143:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803147:	75 17                	jne    803160 <insert_sorted_with_merge_freeList+0x432>
  803149:	83 ec 04             	sub    $0x4,%esp
  80314c:	68 98 3f 80 00       	push   $0x803f98
  803151:	68 5f 01 00 00       	push   $0x15f
  803156:	68 bb 3f 80 00       	push   $0x803fbb
  80315b:	e8 1a 03 00 00       	call   80347a <_panic>
  803160:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803166:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803169:	89 10                	mov    %edx,(%eax)
  80316b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80316e:	8b 00                	mov    (%eax),%eax
  803170:	85 c0                	test   %eax,%eax
  803172:	74 0d                	je     803181 <insert_sorted_with_merge_freeList+0x453>
  803174:	a1 48 51 80 00       	mov    0x805148,%eax
  803179:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80317c:	89 50 04             	mov    %edx,0x4(%eax)
  80317f:	eb 08                	jmp    803189 <insert_sorted_with_merge_freeList+0x45b>
  803181:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803184:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803189:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80318c:	a3 48 51 80 00       	mov    %eax,0x805148
  803191:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803194:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80319b:	a1 54 51 80 00       	mov    0x805154,%eax
  8031a0:	40                   	inc    %eax
  8031a1:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8031a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a9:	8b 50 0c             	mov    0xc(%eax),%edx
  8031ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8031af:	8b 40 0c             	mov    0xc(%eax),%eax
  8031b2:	01 c2                	add    %eax,%edx
  8031b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b7:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8031ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8031bd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8031c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8031ce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031d2:	75 17                	jne    8031eb <insert_sorted_with_merge_freeList+0x4bd>
  8031d4:	83 ec 04             	sub    $0x4,%esp
  8031d7:	68 98 3f 80 00       	push   $0x803f98
  8031dc:	68 64 01 00 00       	push   $0x164
  8031e1:	68 bb 3f 80 00       	push   $0x803fbb
  8031e6:	e8 8f 02 00 00       	call   80347a <_panic>
  8031eb:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f4:	89 10                	mov    %edx,(%eax)
  8031f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f9:	8b 00                	mov    (%eax),%eax
  8031fb:	85 c0                	test   %eax,%eax
  8031fd:	74 0d                	je     80320c <insert_sorted_with_merge_freeList+0x4de>
  8031ff:	a1 48 51 80 00       	mov    0x805148,%eax
  803204:	8b 55 08             	mov    0x8(%ebp),%edx
  803207:	89 50 04             	mov    %edx,0x4(%eax)
  80320a:	eb 08                	jmp    803214 <insert_sorted_with_merge_freeList+0x4e6>
  80320c:	8b 45 08             	mov    0x8(%ebp),%eax
  80320f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803214:	8b 45 08             	mov    0x8(%ebp),%eax
  803217:	a3 48 51 80 00       	mov    %eax,0x805148
  80321c:	8b 45 08             	mov    0x8(%ebp),%eax
  80321f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803226:	a1 54 51 80 00       	mov    0x805154,%eax
  80322b:	40                   	inc    %eax
  80322c:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803231:	e9 41 02 00 00       	jmp    803477 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803236:	8b 45 08             	mov    0x8(%ebp),%eax
  803239:	8b 50 08             	mov    0x8(%eax),%edx
  80323c:	8b 45 08             	mov    0x8(%ebp),%eax
  80323f:	8b 40 0c             	mov    0xc(%eax),%eax
  803242:	01 c2                	add    %eax,%edx
  803244:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803247:	8b 40 08             	mov    0x8(%eax),%eax
  80324a:	39 c2                	cmp    %eax,%edx
  80324c:	0f 85 7c 01 00 00    	jne    8033ce <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803252:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803256:	74 06                	je     80325e <insert_sorted_with_merge_freeList+0x530>
  803258:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80325c:	75 17                	jne    803275 <insert_sorted_with_merge_freeList+0x547>
  80325e:	83 ec 04             	sub    $0x4,%esp
  803261:	68 d4 3f 80 00       	push   $0x803fd4
  803266:	68 69 01 00 00       	push   $0x169
  80326b:	68 bb 3f 80 00       	push   $0x803fbb
  803270:	e8 05 02 00 00       	call   80347a <_panic>
  803275:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803278:	8b 50 04             	mov    0x4(%eax),%edx
  80327b:	8b 45 08             	mov    0x8(%ebp),%eax
  80327e:	89 50 04             	mov    %edx,0x4(%eax)
  803281:	8b 45 08             	mov    0x8(%ebp),%eax
  803284:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803287:	89 10                	mov    %edx,(%eax)
  803289:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80328c:	8b 40 04             	mov    0x4(%eax),%eax
  80328f:	85 c0                	test   %eax,%eax
  803291:	74 0d                	je     8032a0 <insert_sorted_with_merge_freeList+0x572>
  803293:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803296:	8b 40 04             	mov    0x4(%eax),%eax
  803299:	8b 55 08             	mov    0x8(%ebp),%edx
  80329c:	89 10                	mov    %edx,(%eax)
  80329e:	eb 08                	jmp    8032a8 <insert_sorted_with_merge_freeList+0x57a>
  8032a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a3:	a3 38 51 80 00       	mov    %eax,0x805138
  8032a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8032ae:	89 50 04             	mov    %edx,0x4(%eax)
  8032b1:	a1 44 51 80 00       	mov    0x805144,%eax
  8032b6:	40                   	inc    %eax
  8032b7:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8032bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bf:	8b 50 0c             	mov    0xc(%eax),%edx
  8032c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8032c8:	01 c2                	add    %eax,%edx
  8032ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8032cd:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8032d0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032d4:	75 17                	jne    8032ed <insert_sorted_with_merge_freeList+0x5bf>
  8032d6:	83 ec 04             	sub    $0x4,%esp
  8032d9:	68 64 40 80 00       	push   $0x804064
  8032de:	68 6b 01 00 00       	push   $0x16b
  8032e3:	68 bb 3f 80 00       	push   $0x803fbb
  8032e8:	e8 8d 01 00 00       	call   80347a <_panic>
  8032ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f0:	8b 00                	mov    (%eax),%eax
  8032f2:	85 c0                	test   %eax,%eax
  8032f4:	74 10                	je     803306 <insert_sorted_with_merge_freeList+0x5d8>
  8032f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f9:	8b 00                	mov    (%eax),%eax
  8032fb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032fe:	8b 52 04             	mov    0x4(%edx),%edx
  803301:	89 50 04             	mov    %edx,0x4(%eax)
  803304:	eb 0b                	jmp    803311 <insert_sorted_with_merge_freeList+0x5e3>
  803306:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803309:	8b 40 04             	mov    0x4(%eax),%eax
  80330c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803311:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803314:	8b 40 04             	mov    0x4(%eax),%eax
  803317:	85 c0                	test   %eax,%eax
  803319:	74 0f                	je     80332a <insert_sorted_with_merge_freeList+0x5fc>
  80331b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80331e:	8b 40 04             	mov    0x4(%eax),%eax
  803321:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803324:	8b 12                	mov    (%edx),%edx
  803326:	89 10                	mov    %edx,(%eax)
  803328:	eb 0a                	jmp    803334 <insert_sorted_with_merge_freeList+0x606>
  80332a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80332d:	8b 00                	mov    (%eax),%eax
  80332f:	a3 38 51 80 00       	mov    %eax,0x805138
  803334:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803337:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80333d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803340:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803347:	a1 44 51 80 00       	mov    0x805144,%eax
  80334c:	48                   	dec    %eax
  80334d:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803352:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803355:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80335c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80335f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803366:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80336a:	75 17                	jne    803383 <insert_sorted_with_merge_freeList+0x655>
  80336c:	83 ec 04             	sub    $0x4,%esp
  80336f:	68 98 3f 80 00       	push   $0x803f98
  803374:	68 6e 01 00 00       	push   $0x16e
  803379:	68 bb 3f 80 00       	push   $0x803fbb
  80337e:	e8 f7 00 00 00       	call   80347a <_panic>
  803383:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803389:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80338c:	89 10                	mov    %edx,(%eax)
  80338e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803391:	8b 00                	mov    (%eax),%eax
  803393:	85 c0                	test   %eax,%eax
  803395:	74 0d                	je     8033a4 <insert_sorted_with_merge_freeList+0x676>
  803397:	a1 48 51 80 00       	mov    0x805148,%eax
  80339c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80339f:	89 50 04             	mov    %edx,0x4(%eax)
  8033a2:	eb 08                	jmp    8033ac <insert_sorted_with_merge_freeList+0x67e>
  8033a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033af:	a3 48 51 80 00       	mov    %eax,0x805148
  8033b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033be:	a1 54 51 80 00       	mov    0x805154,%eax
  8033c3:	40                   	inc    %eax
  8033c4:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8033c9:	e9 a9 00 00 00       	jmp    803477 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8033ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033d2:	74 06                	je     8033da <insert_sorted_with_merge_freeList+0x6ac>
  8033d4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033d8:	75 17                	jne    8033f1 <insert_sorted_with_merge_freeList+0x6c3>
  8033da:	83 ec 04             	sub    $0x4,%esp
  8033dd:	68 30 40 80 00       	push   $0x804030
  8033e2:	68 73 01 00 00       	push   $0x173
  8033e7:	68 bb 3f 80 00       	push   $0x803fbb
  8033ec:	e8 89 00 00 00       	call   80347a <_panic>
  8033f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f4:	8b 10                	mov    (%eax),%edx
  8033f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f9:	89 10                	mov    %edx,(%eax)
  8033fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fe:	8b 00                	mov    (%eax),%eax
  803400:	85 c0                	test   %eax,%eax
  803402:	74 0b                	je     80340f <insert_sorted_with_merge_freeList+0x6e1>
  803404:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803407:	8b 00                	mov    (%eax),%eax
  803409:	8b 55 08             	mov    0x8(%ebp),%edx
  80340c:	89 50 04             	mov    %edx,0x4(%eax)
  80340f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803412:	8b 55 08             	mov    0x8(%ebp),%edx
  803415:	89 10                	mov    %edx,(%eax)
  803417:	8b 45 08             	mov    0x8(%ebp),%eax
  80341a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80341d:	89 50 04             	mov    %edx,0x4(%eax)
  803420:	8b 45 08             	mov    0x8(%ebp),%eax
  803423:	8b 00                	mov    (%eax),%eax
  803425:	85 c0                	test   %eax,%eax
  803427:	75 08                	jne    803431 <insert_sorted_with_merge_freeList+0x703>
  803429:	8b 45 08             	mov    0x8(%ebp),%eax
  80342c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803431:	a1 44 51 80 00       	mov    0x805144,%eax
  803436:	40                   	inc    %eax
  803437:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  80343c:	eb 39                	jmp    803477 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80343e:	a1 40 51 80 00       	mov    0x805140,%eax
  803443:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803446:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80344a:	74 07                	je     803453 <insert_sorted_with_merge_freeList+0x725>
  80344c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80344f:	8b 00                	mov    (%eax),%eax
  803451:	eb 05                	jmp    803458 <insert_sorted_with_merge_freeList+0x72a>
  803453:	b8 00 00 00 00       	mov    $0x0,%eax
  803458:	a3 40 51 80 00       	mov    %eax,0x805140
  80345d:	a1 40 51 80 00       	mov    0x805140,%eax
  803462:	85 c0                	test   %eax,%eax
  803464:	0f 85 c7 fb ff ff    	jne    803031 <insert_sorted_with_merge_freeList+0x303>
  80346a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80346e:	0f 85 bd fb ff ff    	jne    803031 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803474:	eb 01                	jmp    803477 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803476:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803477:	90                   	nop
  803478:	c9                   	leave  
  803479:	c3                   	ret    

0080347a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80347a:	55                   	push   %ebp
  80347b:	89 e5                	mov    %esp,%ebp
  80347d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803480:	8d 45 10             	lea    0x10(%ebp),%eax
  803483:	83 c0 04             	add    $0x4,%eax
  803486:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803489:	a1 5c 51 80 00       	mov    0x80515c,%eax
  80348e:	85 c0                	test   %eax,%eax
  803490:	74 16                	je     8034a8 <_panic+0x2e>
		cprintf("%s: ", argv0);
  803492:	a1 5c 51 80 00       	mov    0x80515c,%eax
  803497:	83 ec 08             	sub    $0x8,%esp
  80349a:	50                   	push   %eax
  80349b:	68 84 40 80 00       	push   $0x804084
  8034a0:	e8 de d1 ff ff       	call   800683 <cprintf>
  8034a5:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8034a8:	a1 00 50 80 00       	mov    0x805000,%eax
  8034ad:	ff 75 0c             	pushl  0xc(%ebp)
  8034b0:	ff 75 08             	pushl  0x8(%ebp)
  8034b3:	50                   	push   %eax
  8034b4:	68 89 40 80 00       	push   $0x804089
  8034b9:	e8 c5 d1 ff ff       	call   800683 <cprintf>
  8034be:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8034c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8034c4:	83 ec 08             	sub    $0x8,%esp
  8034c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8034ca:	50                   	push   %eax
  8034cb:	e8 48 d1 ff ff       	call   800618 <vcprintf>
  8034d0:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8034d3:	83 ec 08             	sub    $0x8,%esp
  8034d6:	6a 00                	push   $0x0
  8034d8:	68 a5 40 80 00       	push   $0x8040a5
  8034dd:	e8 36 d1 ff ff       	call   800618 <vcprintf>
  8034e2:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8034e5:	e8 b7 d0 ff ff       	call   8005a1 <exit>

	// should not return here
	while (1) ;
  8034ea:	eb fe                	jmp    8034ea <_panic+0x70>

008034ec <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8034ec:	55                   	push   %ebp
  8034ed:	89 e5                	mov    %esp,%ebp
  8034ef:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8034f2:	a1 20 50 80 00       	mov    0x805020,%eax
  8034f7:	8b 50 74             	mov    0x74(%eax),%edx
  8034fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034fd:	39 c2                	cmp    %eax,%edx
  8034ff:	74 14                	je     803515 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803501:	83 ec 04             	sub    $0x4,%esp
  803504:	68 a8 40 80 00       	push   $0x8040a8
  803509:	6a 26                	push   $0x26
  80350b:	68 f4 40 80 00       	push   $0x8040f4
  803510:	e8 65 ff ff ff       	call   80347a <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803515:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80351c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803523:	e9 c2 00 00 00       	jmp    8035ea <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  803528:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80352b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803532:	8b 45 08             	mov    0x8(%ebp),%eax
  803535:	01 d0                	add    %edx,%eax
  803537:	8b 00                	mov    (%eax),%eax
  803539:	85 c0                	test   %eax,%eax
  80353b:	75 08                	jne    803545 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80353d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803540:	e9 a2 00 00 00       	jmp    8035e7 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  803545:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80354c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803553:	eb 69                	jmp    8035be <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803555:	a1 20 50 80 00       	mov    0x805020,%eax
  80355a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803560:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803563:	89 d0                	mov    %edx,%eax
  803565:	01 c0                	add    %eax,%eax
  803567:	01 d0                	add    %edx,%eax
  803569:	c1 e0 03             	shl    $0x3,%eax
  80356c:	01 c8                	add    %ecx,%eax
  80356e:	8a 40 04             	mov    0x4(%eax),%al
  803571:	84 c0                	test   %al,%al
  803573:	75 46                	jne    8035bb <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803575:	a1 20 50 80 00       	mov    0x805020,%eax
  80357a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803580:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803583:	89 d0                	mov    %edx,%eax
  803585:	01 c0                	add    %eax,%eax
  803587:	01 d0                	add    %edx,%eax
  803589:	c1 e0 03             	shl    $0x3,%eax
  80358c:	01 c8                	add    %ecx,%eax
  80358e:	8b 00                	mov    (%eax),%eax
  803590:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803593:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803596:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80359b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80359d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035a0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8035a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035aa:	01 c8                	add    %ecx,%eax
  8035ac:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8035ae:	39 c2                	cmp    %eax,%edx
  8035b0:	75 09                	jne    8035bb <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8035b2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8035b9:	eb 12                	jmp    8035cd <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8035bb:	ff 45 e8             	incl   -0x18(%ebp)
  8035be:	a1 20 50 80 00       	mov    0x805020,%eax
  8035c3:	8b 50 74             	mov    0x74(%eax),%edx
  8035c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035c9:	39 c2                	cmp    %eax,%edx
  8035cb:	77 88                	ja     803555 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8035cd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8035d1:	75 14                	jne    8035e7 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8035d3:	83 ec 04             	sub    $0x4,%esp
  8035d6:	68 00 41 80 00       	push   $0x804100
  8035db:	6a 3a                	push   $0x3a
  8035dd:	68 f4 40 80 00       	push   $0x8040f4
  8035e2:	e8 93 fe ff ff       	call   80347a <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8035e7:	ff 45 f0             	incl   -0x10(%ebp)
  8035ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035ed:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8035f0:	0f 8c 32 ff ff ff    	jl     803528 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8035f6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8035fd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803604:	eb 26                	jmp    80362c <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803606:	a1 20 50 80 00       	mov    0x805020,%eax
  80360b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803611:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803614:	89 d0                	mov    %edx,%eax
  803616:	01 c0                	add    %eax,%eax
  803618:	01 d0                	add    %edx,%eax
  80361a:	c1 e0 03             	shl    $0x3,%eax
  80361d:	01 c8                	add    %ecx,%eax
  80361f:	8a 40 04             	mov    0x4(%eax),%al
  803622:	3c 01                	cmp    $0x1,%al
  803624:	75 03                	jne    803629 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  803626:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803629:	ff 45 e0             	incl   -0x20(%ebp)
  80362c:	a1 20 50 80 00       	mov    0x805020,%eax
  803631:	8b 50 74             	mov    0x74(%eax),%edx
  803634:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803637:	39 c2                	cmp    %eax,%edx
  803639:	77 cb                	ja     803606 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80363b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80363e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803641:	74 14                	je     803657 <CheckWSWithoutLastIndex+0x16b>
		panic(
  803643:	83 ec 04             	sub    $0x4,%esp
  803646:	68 54 41 80 00       	push   $0x804154
  80364b:	6a 44                	push   $0x44
  80364d:	68 f4 40 80 00       	push   $0x8040f4
  803652:	e8 23 fe ff ff       	call   80347a <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803657:	90                   	nop
  803658:	c9                   	leave  
  803659:	c3                   	ret    
  80365a:	66 90                	xchg   %ax,%ax

0080365c <__udivdi3>:
  80365c:	55                   	push   %ebp
  80365d:	57                   	push   %edi
  80365e:	56                   	push   %esi
  80365f:	53                   	push   %ebx
  803660:	83 ec 1c             	sub    $0x1c,%esp
  803663:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803667:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80366b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80366f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803673:	89 ca                	mov    %ecx,%edx
  803675:	89 f8                	mov    %edi,%eax
  803677:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80367b:	85 f6                	test   %esi,%esi
  80367d:	75 2d                	jne    8036ac <__udivdi3+0x50>
  80367f:	39 cf                	cmp    %ecx,%edi
  803681:	77 65                	ja     8036e8 <__udivdi3+0x8c>
  803683:	89 fd                	mov    %edi,%ebp
  803685:	85 ff                	test   %edi,%edi
  803687:	75 0b                	jne    803694 <__udivdi3+0x38>
  803689:	b8 01 00 00 00       	mov    $0x1,%eax
  80368e:	31 d2                	xor    %edx,%edx
  803690:	f7 f7                	div    %edi
  803692:	89 c5                	mov    %eax,%ebp
  803694:	31 d2                	xor    %edx,%edx
  803696:	89 c8                	mov    %ecx,%eax
  803698:	f7 f5                	div    %ebp
  80369a:	89 c1                	mov    %eax,%ecx
  80369c:	89 d8                	mov    %ebx,%eax
  80369e:	f7 f5                	div    %ebp
  8036a0:	89 cf                	mov    %ecx,%edi
  8036a2:	89 fa                	mov    %edi,%edx
  8036a4:	83 c4 1c             	add    $0x1c,%esp
  8036a7:	5b                   	pop    %ebx
  8036a8:	5e                   	pop    %esi
  8036a9:	5f                   	pop    %edi
  8036aa:	5d                   	pop    %ebp
  8036ab:	c3                   	ret    
  8036ac:	39 ce                	cmp    %ecx,%esi
  8036ae:	77 28                	ja     8036d8 <__udivdi3+0x7c>
  8036b0:	0f bd fe             	bsr    %esi,%edi
  8036b3:	83 f7 1f             	xor    $0x1f,%edi
  8036b6:	75 40                	jne    8036f8 <__udivdi3+0x9c>
  8036b8:	39 ce                	cmp    %ecx,%esi
  8036ba:	72 0a                	jb     8036c6 <__udivdi3+0x6a>
  8036bc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8036c0:	0f 87 9e 00 00 00    	ja     803764 <__udivdi3+0x108>
  8036c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8036cb:	89 fa                	mov    %edi,%edx
  8036cd:	83 c4 1c             	add    $0x1c,%esp
  8036d0:	5b                   	pop    %ebx
  8036d1:	5e                   	pop    %esi
  8036d2:	5f                   	pop    %edi
  8036d3:	5d                   	pop    %ebp
  8036d4:	c3                   	ret    
  8036d5:	8d 76 00             	lea    0x0(%esi),%esi
  8036d8:	31 ff                	xor    %edi,%edi
  8036da:	31 c0                	xor    %eax,%eax
  8036dc:	89 fa                	mov    %edi,%edx
  8036de:	83 c4 1c             	add    $0x1c,%esp
  8036e1:	5b                   	pop    %ebx
  8036e2:	5e                   	pop    %esi
  8036e3:	5f                   	pop    %edi
  8036e4:	5d                   	pop    %ebp
  8036e5:	c3                   	ret    
  8036e6:	66 90                	xchg   %ax,%ax
  8036e8:	89 d8                	mov    %ebx,%eax
  8036ea:	f7 f7                	div    %edi
  8036ec:	31 ff                	xor    %edi,%edi
  8036ee:	89 fa                	mov    %edi,%edx
  8036f0:	83 c4 1c             	add    $0x1c,%esp
  8036f3:	5b                   	pop    %ebx
  8036f4:	5e                   	pop    %esi
  8036f5:	5f                   	pop    %edi
  8036f6:	5d                   	pop    %ebp
  8036f7:	c3                   	ret    
  8036f8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8036fd:	89 eb                	mov    %ebp,%ebx
  8036ff:	29 fb                	sub    %edi,%ebx
  803701:	89 f9                	mov    %edi,%ecx
  803703:	d3 e6                	shl    %cl,%esi
  803705:	89 c5                	mov    %eax,%ebp
  803707:	88 d9                	mov    %bl,%cl
  803709:	d3 ed                	shr    %cl,%ebp
  80370b:	89 e9                	mov    %ebp,%ecx
  80370d:	09 f1                	or     %esi,%ecx
  80370f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803713:	89 f9                	mov    %edi,%ecx
  803715:	d3 e0                	shl    %cl,%eax
  803717:	89 c5                	mov    %eax,%ebp
  803719:	89 d6                	mov    %edx,%esi
  80371b:	88 d9                	mov    %bl,%cl
  80371d:	d3 ee                	shr    %cl,%esi
  80371f:	89 f9                	mov    %edi,%ecx
  803721:	d3 e2                	shl    %cl,%edx
  803723:	8b 44 24 08          	mov    0x8(%esp),%eax
  803727:	88 d9                	mov    %bl,%cl
  803729:	d3 e8                	shr    %cl,%eax
  80372b:	09 c2                	or     %eax,%edx
  80372d:	89 d0                	mov    %edx,%eax
  80372f:	89 f2                	mov    %esi,%edx
  803731:	f7 74 24 0c          	divl   0xc(%esp)
  803735:	89 d6                	mov    %edx,%esi
  803737:	89 c3                	mov    %eax,%ebx
  803739:	f7 e5                	mul    %ebp
  80373b:	39 d6                	cmp    %edx,%esi
  80373d:	72 19                	jb     803758 <__udivdi3+0xfc>
  80373f:	74 0b                	je     80374c <__udivdi3+0xf0>
  803741:	89 d8                	mov    %ebx,%eax
  803743:	31 ff                	xor    %edi,%edi
  803745:	e9 58 ff ff ff       	jmp    8036a2 <__udivdi3+0x46>
  80374a:	66 90                	xchg   %ax,%ax
  80374c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803750:	89 f9                	mov    %edi,%ecx
  803752:	d3 e2                	shl    %cl,%edx
  803754:	39 c2                	cmp    %eax,%edx
  803756:	73 e9                	jae    803741 <__udivdi3+0xe5>
  803758:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80375b:	31 ff                	xor    %edi,%edi
  80375d:	e9 40 ff ff ff       	jmp    8036a2 <__udivdi3+0x46>
  803762:	66 90                	xchg   %ax,%ax
  803764:	31 c0                	xor    %eax,%eax
  803766:	e9 37 ff ff ff       	jmp    8036a2 <__udivdi3+0x46>
  80376b:	90                   	nop

0080376c <__umoddi3>:
  80376c:	55                   	push   %ebp
  80376d:	57                   	push   %edi
  80376e:	56                   	push   %esi
  80376f:	53                   	push   %ebx
  803770:	83 ec 1c             	sub    $0x1c,%esp
  803773:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803777:	8b 74 24 34          	mov    0x34(%esp),%esi
  80377b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80377f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803783:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803787:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80378b:	89 f3                	mov    %esi,%ebx
  80378d:	89 fa                	mov    %edi,%edx
  80378f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803793:	89 34 24             	mov    %esi,(%esp)
  803796:	85 c0                	test   %eax,%eax
  803798:	75 1a                	jne    8037b4 <__umoddi3+0x48>
  80379a:	39 f7                	cmp    %esi,%edi
  80379c:	0f 86 a2 00 00 00    	jbe    803844 <__umoddi3+0xd8>
  8037a2:	89 c8                	mov    %ecx,%eax
  8037a4:	89 f2                	mov    %esi,%edx
  8037a6:	f7 f7                	div    %edi
  8037a8:	89 d0                	mov    %edx,%eax
  8037aa:	31 d2                	xor    %edx,%edx
  8037ac:	83 c4 1c             	add    $0x1c,%esp
  8037af:	5b                   	pop    %ebx
  8037b0:	5e                   	pop    %esi
  8037b1:	5f                   	pop    %edi
  8037b2:	5d                   	pop    %ebp
  8037b3:	c3                   	ret    
  8037b4:	39 f0                	cmp    %esi,%eax
  8037b6:	0f 87 ac 00 00 00    	ja     803868 <__umoddi3+0xfc>
  8037bc:	0f bd e8             	bsr    %eax,%ebp
  8037bf:	83 f5 1f             	xor    $0x1f,%ebp
  8037c2:	0f 84 ac 00 00 00    	je     803874 <__umoddi3+0x108>
  8037c8:	bf 20 00 00 00       	mov    $0x20,%edi
  8037cd:	29 ef                	sub    %ebp,%edi
  8037cf:	89 fe                	mov    %edi,%esi
  8037d1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8037d5:	89 e9                	mov    %ebp,%ecx
  8037d7:	d3 e0                	shl    %cl,%eax
  8037d9:	89 d7                	mov    %edx,%edi
  8037db:	89 f1                	mov    %esi,%ecx
  8037dd:	d3 ef                	shr    %cl,%edi
  8037df:	09 c7                	or     %eax,%edi
  8037e1:	89 e9                	mov    %ebp,%ecx
  8037e3:	d3 e2                	shl    %cl,%edx
  8037e5:	89 14 24             	mov    %edx,(%esp)
  8037e8:	89 d8                	mov    %ebx,%eax
  8037ea:	d3 e0                	shl    %cl,%eax
  8037ec:	89 c2                	mov    %eax,%edx
  8037ee:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037f2:	d3 e0                	shl    %cl,%eax
  8037f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8037f8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037fc:	89 f1                	mov    %esi,%ecx
  8037fe:	d3 e8                	shr    %cl,%eax
  803800:	09 d0                	or     %edx,%eax
  803802:	d3 eb                	shr    %cl,%ebx
  803804:	89 da                	mov    %ebx,%edx
  803806:	f7 f7                	div    %edi
  803808:	89 d3                	mov    %edx,%ebx
  80380a:	f7 24 24             	mull   (%esp)
  80380d:	89 c6                	mov    %eax,%esi
  80380f:	89 d1                	mov    %edx,%ecx
  803811:	39 d3                	cmp    %edx,%ebx
  803813:	0f 82 87 00 00 00    	jb     8038a0 <__umoddi3+0x134>
  803819:	0f 84 91 00 00 00    	je     8038b0 <__umoddi3+0x144>
  80381f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803823:	29 f2                	sub    %esi,%edx
  803825:	19 cb                	sbb    %ecx,%ebx
  803827:	89 d8                	mov    %ebx,%eax
  803829:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80382d:	d3 e0                	shl    %cl,%eax
  80382f:	89 e9                	mov    %ebp,%ecx
  803831:	d3 ea                	shr    %cl,%edx
  803833:	09 d0                	or     %edx,%eax
  803835:	89 e9                	mov    %ebp,%ecx
  803837:	d3 eb                	shr    %cl,%ebx
  803839:	89 da                	mov    %ebx,%edx
  80383b:	83 c4 1c             	add    $0x1c,%esp
  80383e:	5b                   	pop    %ebx
  80383f:	5e                   	pop    %esi
  803840:	5f                   	pop    %edi
  803841:	5d                   	pop    %ebp
  803842:	c3                   	ret    
  803843:	90                   	nop
  803844:	89 fd                	mov    %edi,%ebp
  803846:	85 ff                	test   %edi,%edi
  803848:	75 0b                	jne    803855 <__umoddi3+0xe9>
  80384a:	b8 01 00 00 00       	mov    $0x1,%eax
  80384f:	31 d2                	xor    %edx,%edx
  803851:	f7 f7                	div    %edi
  803853:	89 c5                	mov    %eax,%ebp
  803855:	89 f0                	mov    %esi,%eax
  803857:	31 d2                	xor    %edx,%edx
  803859:	f7 f5                	div    %ebp
  80385b:	89 c8                	mov    %ecx,%eax
  80385d:	f7 f5                	div    %ebp
  80385f:	89 d0                	mov    %edx,%eax
  803861:	e9 44 ff ff ff       	jmp    8037aa <__umoddi3+0x3e>
  803866:	66 90                	xchg   %ax,%ax
  803868:	89 c8                	mov    %ecx,%eax
  80386a:	89 f2                	mov    %esi,%edx
  80386c:	83 c4 1c             	add    $0x1c,%esp
  80386f:	5b                   	pop    %ebx
  803870:	5e                   	pop    %esi
  803871:	5f                   	pop    %edi
  803872:	5d                   	pop    %ebp
  803873:	c3                   	ret    
  803874:	3b 04 24             	cmp    (%esp),%eax
  803877:	72 06                	jb     80387f <__umoddi3+0x113>
  803879:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80387d:	77 0f                	ja     80388e <__umoddi3+0x122>
  80387f:	89 f2                	mov    %esi,%edx
  803881:	29 f9                	sub    %edi,%ecx
  803883:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803887:	89 14 24             	mov    %edx,(%esp)
  80388a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80388e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803892:	8b 14 24             	mov    (%esp),%edx
  803895:	83 c4 1c             	add    $0x1c,%esp
  803898:	5b                   	pop    %ebx
  803899:	5e                   	pop    %esi
  80389a:	5f                   	pop    %edi
  80389b:	5d                   	pop    %ebp
  80389c:	c3                   	ret    
  80389d:	8d 76 00             	lea    0x0(%esi),%esi
  8038a0:	2b 04 24             	sub    (%esp),%eax
  8038a3:	19 fa                	sbb    %edi,%edx
  8038a5:	89 d1                	mov    %edx,%ecx
  8038a7:	89 c6                	mov    %eax,%esi
  8038a9:	e9 71 ff ff ff       	jmp    80381f <__umoddi3+0xb3>
  8038ae:	66 90                	xchg   %ax,%ax
  8038b0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8038b4:	72 ea                	jb     8038a0 <__umoddi3+0x134>
  8038b6:	89 d9                	mov    %ebx,%ecx
  8038b8:	e9 62 ff ff ff       	jmp    80381f <__umoddi3+0xb3>
