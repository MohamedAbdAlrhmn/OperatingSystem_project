
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
  80003e:	e8 28 1c 00 00       	call   801c6b <sys_getparentenvid>
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
  800057:	68 80 39 80 00       	push   $0x803980
  80005c:	ff 75 f0             	pushl  -0x10(%ebp)
  80005f:	e8 ea 16 00 00       	call   80174e <sget>
  800064:	83 c4 10             	add    $0x10,%esp
  800067:	89 45 e8             	mov    %eax,-0x18(%ebp)
	numOfElements = sget(parentenvID, "arrSize") ;
  80006a:	83 ec 08             	sub    $0x8,%esp
  80006d:	68 84 39 80 00       	push   $0x803984
  800072:	ff 75 f0             	pushl  -0x10(%ebp)
  800075:	e8 d4 16 00 00       	call   80174e <sget>
  80007a:	83 c4 10             	add    $0x10,%esp
  80007d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//PrintElements(sharedArray, *numOfElements);

	//Get the check-finishing counter
	int *finishedCount = NULL;
  800080:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	finishedCount = sget(parentenvID, "finishedCount") ;
  800087:	83 ec 08             	sub    $0x8,%esp
  80008a:	68 8c 39 80 00       	push   $0x80398c
  80008f:	ff 75 f0             	pushl  -0x10(%ebp)
  800092:	e8 b7 16 00 00       	call   80174e <sget>
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
  8000ab:	68 9a 39 80 00       	push   $0x80399a
  8000b0:	e8 eb 15 00 00       	call   8016a0 <smalloc>
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
  80010c:	68 a9 39 80 00       	push   $0x8039a9
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
  8001a2:	68 c5 39 80 00       	push   $0x8039c5
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
  8001c4:	68 c7 39 80 00       	push   $0x8039c7
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
  8001f2:	68 cc 39 80 00       	push   $0x8039cc
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
  800479:	e8 d4 17 00 00       	call   801c52 <sys_getenvindex>
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
  8004e4:	e8 76 15 00 00       	call   801a5f <sys_disable_interrupt>
	cprintf("**************************************\n");
  8004e9:	83 ec 0c             	sub    $0xc,%esp
  8004ec:	68 e8 39 80 00       	push   $0x8039e8
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
  800514:	68 10 3a 80 00       	push   $0x803a10
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
  800545:	68 38 3a 80 00       	push   $0x803a38
  80054a:	e8 34 01 00 00       	call   800683 <cprintf>
  80054f:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800552:	a1 20 50 80 00       	mov    0x805020,%eax
  800557:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80055d:	83 ec 08             	sub    $0x8,%esp
  800560:	50                   	push   %eax
  800561:	68 90 3a 80 00       	push   $0x803a90
  800566:	e8 18 01 00 00       	call   800683 <cprintf>
  80056b:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80056e:	83 ec 0c             	sub    $0xc,%esp
  800571:	68 e8 39 80 00       	push   $0x8039e8
  800576:	e8 08 01 00 00       	call   800683 <cprintf>
  80057b:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80057e:	e8 f6 14 00 00       	call   801a79 <sys_enable_interrupt>

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
  800596:	e8 83 16 00 00       	call   801c1e <sys_destroy_env>
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
  8005a7:	e8 d8 16 00 00       	call   801c84 <sys_exit_env>
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
  8005f5:	e8 b7 12 00 00       	call   8018b1 <sys_cputs>
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
  80066c:	e8 40 12 00 00       	call   8018b1 <sys_cputs>
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
  8006b6:	e8 a4 13 00 00       	call   801a5f <sys_disable_interrupt>
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
  8006d6:	e8 9e 13 00 00       	call   801a79 <sys_enable_interrupt>
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
  800720:	e8 ef 2f 00 00       	call   803714 <__udivdi3>
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
  800770:	e8 af 30 00 00       	call   803824 <__umoddi3>
  800775:	83 c4 10             	add    $0x10,%esp
  800778:	05 d4 3c 80 00       	add    $0x803cd4,%eax
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
  8008cb:	8b 04 85 f8 3c 80 00 	mov    0x803cf8(,%eax,4),%eax
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
  8009ac:	8b 34 9d 40 3b 80 00 	mov    0x803b40(,%ebx,4),%esi
  8009b3:	85 f6                	test   %esi,%esi
  8009b5:	75 19                	jne    8009d0 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009b7:	53                   	push   %ebx
  8009b8:	68 e5 3c 80 00       	push   $0x803ce5
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
  8009d1:	68 ee 3c 80 00       	push   $0x803cee
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
  8009fe:	be f1 3c 80 00       	mov    $0x803cf1,%esi
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
  801424:	68 50 3e 80 00       	push   $0x803e50
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
  8014f4:	e8 fc 04 00 00       	call   8019f5 <sys_allocate_chunk>
  8014f9:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8014fc:	a1 20 51 80 00       	mov    0x805120,%eax
  801501:	83 ec 0c             	sub    $0xc,%esp
  801504:	50                   	push   %eax
  801505:	e8 71 0b 00 00       	call   80207b <initialize_MemBlocksList>
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
  801532:	68 75 3e 80 00       	push   $0x803e75
  801537:	6a 33                	push   $0x33
  801539:	68 93 3e 80 00       	push   $0x803e93
  80153e:	e8 f1 1f 00 00       	call   803534 <_panic>
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
  8015b1:	68 a0 3e 80 00       	push   $0x803ea0
  8015b6:	6a 34                	push   $0x34
  8015b8:	68 93 3e 80 00       	push   $0x803e93
  8015bd:	e8 72 1f 00 00       	call   803534 <_panic>
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
  801649:	e8 75 07 00 00       	call   801dc3 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80164e:	85 c0                	test   %eax,%eax
  801650:	74 11                	je     801663 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801652:	83 ec 0c             	sub    $0xc,%esp
  801655:	ff 75 e8             	pushl  -0x18(%ebp)
  801658:	e8 e0 0d 00 00       	call   80243d <alloc_block_FF>
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
  80166f:	e8 3c 0b 00 00       	call   8021b0 <insert_sorted_allocList>
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
  801689:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80168c:	83 ec 04             	sub    $0x4,%esp
  80168f:	68 c4 3e 80 00       	push   $0x803ec4
  801694:	6a 6f                	push   $0x6f
  801696:	68 93 3e 80 00       	push   $0x803e93
  80169b:	e8 94 1e 00 00       	call   803534 <_panic>

008016a0 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8016a0:	55                   	push   %ebp
  8016a1:	89 e5                	mov    %esp,%ebp
  8016a3:	83 ec 38             	sub    $0x38,%esp
  8016a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a9:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016ac:	e8 5c fd ff ff       	call   80140d <InitializeUHeap>
	if (size == 0) return NULL ;
  8016b1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016b5:	75 0a                	jne    8016c1 <smalloc+0x21>
  8016b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8016bc:	e9 8b 00 00 00       	jmp    80174c <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8016c1:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8016c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ce:	01 d0                	add    %edx,%eax
  8016d0:	48                   	dec    %eax
  8016d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8016d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8016dc:	f7 75 f0             	divl   -0x10(%ebp)
  8016df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016e2:	29 d0                	sub    %edx,%eax
  8016e4:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8016e7:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8016ee:	e8 d0 06 00 00       	call   801dc3 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016f3:	85 c0                	test   %eax,%eax
  8016f5:	74 11                	je     801708 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  8016f7:	83 ec 0c             	sub    $0xc,%esp
  8016fa:	ff 75 e8             	pushl  -0x18(%ebp)
  8016fd:	e8 3b 0d 00 00       	call   80243d <alloc_block_FF>
  801702:	83 c4 10             	add    $0x10,%esp
  801705:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  801708:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80170c:	74 39                	je     801747 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  80170e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801711:	8b 40 08             	mov    0x8(%eax),%eax
  801714:	89 c2                	mov    %eax,%edx
  801716:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80171a:	52                   	push   %edx
  80171b:	50                   	push   %eax
  80171c:	ff 75 0c             	pushl  0xc(%ebp)
  80171f:	ff 75 08             	pushl  0x8(%ebp)
  801722:	e8 21 04 00 00       	call   801b48 <sys_createSharedObject>
  801727:	83 c4 10             	add    $0x10,%esp
  80172a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  80172d:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801731:	74 14                	je     801747 <smalloc+0xa7>
  801733:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801737:	74 0e                	je     801747 <smalloc+0xa7>
  801739:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  80173d:	74 08                	je     801747 <smalloc+0xa7>
			return (void*) mem_block->sva;
  80173f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801742:	8b 40 08             	mov    0x8(%eax),%eax
  801745:	eb 05                	jmp    80174c <smalloc+0xac>
	}
	return NULL;
  801747:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80174c:	c9                   	leave  
  80174d:	c3                   	ret    

0080174e <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80174e:	55                   	push   %ebp
  80174f:	89 e5                	mov    %esp,%ebp
  801751:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801754:	e8 b4 fc ff ff       	call   80140d <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801759:	83 ec 08             	sub    $0x8,%esp
  80175c:	ff 75 0c             	pushl  0xc(%ebp)
  80175f:	ff 75 08             	pushl  0x8(%ebp)
  801762:	e8 0b 04 00 00       	call   801b72 <sys_getSizeOfSharedObject>
  801767:	83 c4 10             	add    $0x10,%esp
  80176a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  80176d:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  801771:	74 76                	je     8017e9 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801773:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80177a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80177d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801780:	01 d0                	add    %edx,%eax
  801782:	48                   	dec    %eax
  801783:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801786:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801789:	ba 00 00 00 00       	mov    $0x0,%edx
  80178e:	f7 75 ec             	divl   -0x14(%ebp)
  801791:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801794:	29 d0                	sub    %edx,%eax
  801796:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801799:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8017a0:	e8 1e 06 00 00       	call   801dc3 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017a5:	85 c0                	test   %eax,%eax
  8017a7:	74 11                	je     8017ba <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  8017a9:	83 ec 0c             	sub    $0xc,%esp
  8017ac:	ff 75 e4             	pushl  -0x1c(%ebp)
  8017af:	e8 89 0c 00 00       	call   80243d <alloc_block_FF>
  8017b4:	83 c4 10             	add    $0x10,%esp
  8017b7:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  8017ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017be:	74 29                	je     8017e9 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  8017c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017c3:	8b 40 08             	mov    0x8(%eax),%eax
  8017c6:	83 ec 04             	sub    $0x4,%esp
  8017c9:	50                   	push   %eax
  8017ca:	ff 75 0c             	pushl  0xc(%ebp)
  8017cd:	ff 75 08             	pushl  0x8(%ebp)
  8017d0:	e8 ba 03 00 00       	call   801b8f <sys_getSharedObject>
  8017d5:	83 c4 10             	add    $0x10,%esp
  8017d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  8017db:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  8017df:	74 08                	je     8017e9 <sget+0x9b>
				return (void *)mem_block->sva;
  8017e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017e4:	8b 40 08             	mov    0x8(%eax),%eax
  8017e7:	eb 05                	jmp    8017ee <sget+0xa0>
		}
	}
	return (void *)NULL;
  8017e9:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8017ee:	c9                   	leave  
  8017ef:	c3                   	ret    

008017f0 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017f0:	55                   	push   %ebp
  8017f1:	89 e5                	mov    %esp,%ebp
  8017f3:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017f6:	e8 12 fc ff ff       	call   80140d <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8017fb:	83 ec 04             	sub    $0x4,%esp
  8017fe:	68 e8 3e 80 00       	push   $0x803ee8
  801803:	68 f1 00 00 00       	push   $0xf1
  801808:	68 93 3e 80 00       	push   $0x803e93
  80180d:	e8 22 1d 00 00       	call   803534 <_panic>

00801812 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801812:	55                   	push   %ebp
  801813:	89 e5                	mov    %esp,%ebp
  801815:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801818:	83 ec 04             	sub    $0x4,%esp
  80181b:	68 10 3f 80 00       	push   $0x803f10
  801820:	68 05 01 00 00       	push   $0x105
  801825:	68 93 3e 80 00       	push   $0x803e93
  80182a:	e8 05 1d 00 00       	call   803534 <_panic>

0080182f <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80182f:	55                   	push   %ebp
  801830:	89 e5                	mov    %esp,%ebp
  801832:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801835:	83 ec 04             	sub    $0x4,%esp
  801838:	68 34 3f 80 00       	push   $0x803f34
  80183d:	68 10 01 00 00       	push   $0x110
  801842:	68 93 3e 80 00       	push   $0x803e93
  801847:	e8 e8 1c 00 00       	call   803534 <_panic>

0080184c <shrink>:

}
void shrink(uint32 newSize)
{
  80184c:	55                   	push   %ebp
  80184d:	89 e5                	mov    %esp,%ebp
  80184f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801852:	83 ec 04             	sub    $0x4,%esp
  801855:	68 34 3f 80 00       	push   $0x803f34
  80185a:	68 15 01 00 00       	push   $0x115
  80185f:	68 93 3e 80 00       	push   $0x803e93
  801864:	e8 cb 1c 00 00       	call   803534 <_panic>

00801869 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801869:	55                   	push   %ebp
  80186a:	89 e5                	mov    %esp,%ebp
  80186c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80186f:	83 ec 04             	sub    $0x4,%esp
  801872:	68 34 3f 80 00       	push   $0x803f34
  801877:	68 1a 01 00 00       	push   $0x11a
  80187c:	68 93 3e 80 00       	push   $0x803e93
  801881:	e8 ae 1c 00 00       	call   803534 <_panic>

00801886 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801886:	55                   	push   %ebp
  801887:	89 e5                	mov    %esp,%ebp
  801889:	57                   	push   %edi
  80188a:	56                   	push   %esi
  80188b:	53                   	push   %ebx
  80188c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80188f:	8b 45 08             	mov    0x8(%ebp),%eax
  801892:	8b 55 0c             	mov    0xc(%ebp),%edx
  801895:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801898:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80189b:	8b 7d 18             	mov    0x18(%ebp),%edi
  80189e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018a1:	cd 30                	int    $0x30
  8018a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8018a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018a9:	83 c4 10             	add    $0x10,%esp
  8018ac:	5b                   	pop    %ebx
  8018ad:	5e                   	pop    %esi
  8018ae:	5f                   	pop    %edi
  8018af:	5d                   	pop    %ebp
  8018b0:	c3                   	ret    

008018b1 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018b1:	55                   	push   %ebp
  8018b2:	89 e5                	mov    %esp,%ebp
  8018b4:	83 ec 04             	sub    $0x4,%esp
  8018b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8018ba:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8018bd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	52                   	push   %edx
  8018c9:	ff 75 0c             	pushl  0xc(%ebp)
  8018cc:	50                   	push   %eax
  8018cd:	6a 00                	push   $0x0
  8018cf:	e8 b2 ff ff ff       	call   801886 <syscall>
  8018d4:	83 c4 18             	add    $0x18,%esp
}
  8018d7:	90                   	nop
  8018d8:	c9                   	leave  
  8018d9:	c3                   	ret    

008018da <sys_cgetc>:

int
sys_cgetc(void)
{
  8018da:	55                   	push   %ebp
  8018db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018dd:	6a 00                	push   $0x0
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 01                	push   $0x1
  8018e9:	e8 98 ff ff ff       	call   801886 <syscall>
  8018ee:	83 c4 18             	add    $0x18,%esp
}
  8018f1:	c9                   	leave  
  8018f2:	c3                   	ret    

008018f3 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018f3:	55                   	push   %ebp
  8018f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	52                   	push   %edx
  801903:	50                   	push   %eax
  801904:	6a 05                	push   $0x5
  801906:	e8 7b ff ff ff       	call   801886 <syscall>
  80190b:	83 c4 18             	add    $0x18,%esp
}
  80190e:	c9                   	leave  
  80190f:	c3                   	ret    

00801910 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801910:	55                   	push   %ebp
  801911:	89 e5                	mov    %esp,%ebp
  801913:	56                   	push   %esi
  801914:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801915:	8b 75 18             	mov    0x18(%ebp),%esi
  801918:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80191b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80191e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801921:	8b 45 08             	mov    0x8(%ebp),%eax
  801924:	56                   	push   %esi
  801925:	53                   	push   %ebx
  801926:	51                   	push   %ecx
  801927:	52                   	push   %edx
  801928:	50                   	push   %eax
  801929:	6a 06                	push   $0x6
  80192b:	e8 56 ff ff ff       	call   801886 <syscall>
  801930:	83 c4 18             	add    $0x18,%esp
}
  801933:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801936:	5b                   	pop    %ebx
  801937:	5e                   	pop    %esi
  801938:	5d                   	pop    %ebp
  801939:	c3                   	ret    

0080193a <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80193a:	55                   	push   %ebp
  80193b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80193d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801940:	8b 45 08             	mov    0x8(%ebp),%eax
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	52                   	push   %edx
  80194a:	50                   	push   %eax
  80194b:	6a 07                	push   $0x7
  80194d:	e8 34 ff ff ff       	call   801886 <syscall>
  801952:	83 c4 18             	add    $0x18,%esp
}
  801955:	c9                   	leave  
  801956:	c3                   	ret    

00801957 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801957:	55                   	push   %ebp
  801958:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	ff 75 0c             	pushl  0xc(%ebp)
  801963:	ff 75 08             	pushl  0x8(%ebp)
  801966:	6a 08                	push   $0x8
  801968:	e8 19 ff ff ff       	call   801886 <syscall>
  80196d:	83 c4 18             	add    $0x18,%esp
}
  801970:	c9                   	leave  
  801971:	c3                   	ret    

00801972 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801972:	55                   	push   %ebp
  801973:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	6a 09                	push   $0x9
  801981:	e8 00 ff ff ff       	call   801886 <syscall>
  801986:	83 c4 18             	add    $0x18,%esp
}
  801989:	c9                   	leave  
  80198a:	c3                   	ret    

0080198b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80198b:	55                   	push   %ebp
  80198c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	6a 00                	push   $0x0
  801994:	6a 00                	push   $0x0
  801996:	6a 00                	push   $0x0
  801998:	6a 0a                	push   $0xa
  80199a:	e8 e7 fe ff ff       	call   801886 <syscall>
  80199f:	83 c4 18             	add    $0x18,%esp
}
  8019a2:	c9                   	leave  
  8019a3:	c3                   	ret    

008019a4 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019a4:	55                   	push   %ebp
  8019a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 0b                	push   $0xb
  8019b3:	e8 ce fe ff ff       	call   801886 <syscall>
  8019b8:	83 c4 18             	add    $0x18,%esp
}
  8019bb:	c9                   	leave  
  8019bc:	c3                   	ret    

008019bd <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019bd:	55                   	push   %ebp
  8019be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 00                	push   $0x0
  8019c6:	ff 75 0c             	pushl  0xc(%ebp)
  8019c9:	ff 75 08             	pushl  0x8(%ebp)
  8019cc:	6a 0f                	push   $0xf
  8019ce:	e8 b3 fe ff ff       	call   801886 <syscall>
  8019d3:	83 c4 18             	add    $0x18,%esp
	return;
  8019d6:	90                   	nop
}
  8019d7:	c9                   	leave  
  8019d8:	c3                   	ret    

008019d9 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019d9:	55                   	push   %ebp
  8019da:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	ff 75 0c             	pushl  0xc(%ebp)
  8019e5:	ff 75 08             	pushl  0x8(%ebp)
  8019e8:	6a 10                	push   $0x10
  8019ea:	e8 97 fe ff ff       	call   801886 <syscall>
  8019ef:	83 c4 18             	add    $0x18,%esp
	return ;
  8019f2:	90                   	nop
}
  8019f3:	c9                   	leave  
  8019f4:	c3                   	ret    

008019f5 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019f5:	55                   	push   %ebp
  8019f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	ff 75 10             	pushl  0x10(%ebp)
  8019ff:	ff 75 0c             	pushl  0xc(%ebp)
  801a02:	ff 75 08             	pushl  0x8(%ebp)
  801a05:	6a 11                	push   $0x11
  801a07:	e8 7a fe ff ff       	call   801886 <syscall>
  801a0c:	83 c4 18             	add    $0x18,%esp
	return ;
  801a0f:	90                   	nop
}
  801a10:	c9                   	leave  
  801a11:	c3                   	ret    

00801a12 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a12:	55                   	push   %ebp
  801a13:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 0c                	push   $0xc
  801a21:	e8 60 fe ff ff       	call   801886 <syscall>
  801a26:	83 c4 18             	add    $0x18,%esp
}
  801a29:	c9                   	leave  
  801a2a:	c3                   	ret    

00801a2b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a2b:	55                   	push   %ebp
  801a2c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	ff 75 08             	pushl  0x8(%ebp)
  801a39:	6a 0d                	push   $0xd
  801a3b:	e8 46 fe ff ff       	call   801886 <syscall>
  801a40:	83 c4 18             	add    $0x18,%esp
}
  801a43:	c9                   	leave  
  801a44:	c3                   	ret    

00801a45 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a45:	55                   	push   %ebp
  801a46:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	6a 0e                	push   $0xe
  801a54:	e8 2d fe ff ff       	call   801886 <syscall>
  801a59:	83 c4 18             	add    $0x18,%esp
}
  801a5c:	90                   	nop
  801a5d:	c9                   	leave  
  801a5e:	c3                   	ret    

00801a5f <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a5f:	55                   	push   %ebp
  801a60:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 13                	push   $0x13
  801a6e:	e8 13 fe ff ff       	call   801886 <syscall>
  801a73:	83 c4 18             	add    $0x18,%esp
}
  801a76:	90                   	nop
  801a77:	c9                   	leave  
  801a78:	c3                   	ret    

00801a79 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a79:	55                   	push   %ebp
  801a7a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 14                	push   $0x14
  801a88:	e8 f9 fd ff ff       	call   801886 <syscall>
  801a8d:	83 c4 18             	add    $0x18,%esp
}
  801a90:	90                   	nop
  801a91:	c9                   	leave  
  801a92:	c3                   	ret    

00801a93 <sys_cputc>:


void
sys_cputc(const char c)
{
  801a93:	55                   	push   %ebp
  801a94:	89 e5                	mov    %esp,%ebp
  801a96:	83 ec 04             	sub    $0x4,%esp
  801a99:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a9f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	50                   	push   %eax
  801aac:	6a 15                	push   $0x15
  801aae:	e8 d3 fd ff ff       	call   801886 <syscall>
  801ab3:	83 c4 18             	add    $0x18,%esp
}
  801ab6:	90                   	nop
  801ab7:	c9                   	leave  
  801ab8:	c3                   	ret    

00801ab9 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ab9:	55                   	push   %ebp
  801aba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 16                	push   $0x16
  801ac8:	e8 b9 fd ff ff       	call   801886 <syscall>
  801acd:	83 c4 18             	add    $0x18,%esp
}
  801ad0:	90                   	nop
  801ad1:	c9                   	leave  
  801ad2:	c3                   	ret    

00801ad3 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801ad3:	55                   	push   %ebp
  801ad4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	ff 75 0c             	pushl  0xc(%ebp)
  801ae2:	50                   	push   %eax
  801ae3:	6a 17                	push   $0x17
  801ae5:	e8 9c fd ff ff       	call   801886 <syscall>
  801aea:	83 c4 18             	add    $0x18,%esp
}
  801aed:	c9                   	leave  
  801aee:	c3                   	ret    

00801aef <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801aef:	55                   	push   %ebp
  801af0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801af2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af5:	8b 45 08             	mov    0x8(%ebp),%eax
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	52                   	push   %edx
  801aff:	50                   	push   %eax
  801b00:	6a 1a                	push   $0x1a
  801b02:	e8 7f fd ff ff       	call   801886 <syscall>
  801b07:	83 c4 18             	add    $0x18,%esp
}
  801b0a:	c9                   	leave  
  801b0b:	c3                   	ret    

00801b0c <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b0c:	55                   	push   %ebp
  801b0d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b12:	8b 45 08             	mov    0x8(%ebp),%eax
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	52                   	push   %edx
  801b1c:	50                   	push   %eax
  801b1d:	6a 18                	push   $0x18
  801b1f:	e8 62 fd ff ff       	call   801886 <syscall>
  801b24:	83 c4 18             	add    $0x18,%esp
}
  801b27:	90                   	nop
  801b28:	c9                   	leave  
  801b29:	c3                   	ret    

00801b2a <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b2a:	55                   	push   %ebp
  801b2b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b30:	8b 45 08             	mov    0x8(%ebp),%eax
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	52                   	push   %edx
  801b3a:	50                   	push   %eax
  801b3b:	6a 19                	push   $0x19
  801b3d:	e8 44 fd ff ff       	call   801886 <syscall>
  801b42:	83 c4 18             	add    $0x18,%esp
}
  801b45:	90                   	nop
  801b46:	c9                   	leave  
  801b47:	c3                   	ret    

00801b48 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b48:	55                   	push   %ebp
  801b49:	89 e5                	mov    %esp,%ebp
  801b4b:	83 ec 04             	sub    $0x4,%esp
  801b4e:	8b 45 10             	mov    0x10(%ebp),%eax
  801b51:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b54:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b57:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5e:	6a 00                	push   $0x0
  801b60:	51                   	push   %ecx
  801b61:	52                   	push   %edx
  801b62:	ff 75 0c             	pushl  0xc(%ebp)
  801b65:	50                   	push   %eax
  801b66:	6a 1b                	push   $0x1b
  801b68:	e8 19 fd ff ff       	call   801886 <syscall>
  801b6d:	83 c4 18             	add    $0x18,%esp
}
  801b70:	c9                   	leave  
  801b71:	c3                   	ret    

00801b72 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b72:	55                   	push   %ebp
  801b73:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b75:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b78:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	52                   	push   %edx
  801b82:	50                   	push   %eax
  801b83:	6a 1c                	push   $0x1c
  801b85:	e8 fc fc ff ff       	call   801886 <syscall>
  801b8a:	83 c4 18             	add    $0x18,%esp
}
  801b8d:	c9                   	leave  
  801b8e:	c3                   	ret    

00801b8f <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b8f:	55                   	push   %ebp
  801b90:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b92:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b95:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b98:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	51                   	push   %ecx
  801ba0:	52                   	push   %edx
  801ba1:	50                   	push   %eax
  801ba2:	6a 1d                	push   $0x1d
  801ba4:	e8 dd fc ff ff       	call   801886 <syscall>
  801ba9:	83 c4 18             	add    $0x18,%esp
}
  801bac:	c9                   	leave  
  801bad:	c3                   	ret    

00801bae <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801bae:	55                   	push   %ebp
  801baf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801bb1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	52                   	push   %edx
  801bbe:	50                   	push   %eax
  801bbf:	6a 1e                	push   $0x1e
  801bc1:	e8 c0 fc ff ff       	call   801886 <syscall>
  801bc6:	83 c4 18             	add    $0x18,%esp
}
  801bc9:	c9                   	leave  
  801bca:	c3                   	ret    

00801bcb <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801bcb:	55                   	push   %ebp
  801bcc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 1f                	push   $0x1f
  801bda:	e8 a7 fc ff ff       	call   801886 <syscall>
  801bdf:	83 c4 18             	add    $0x18,%esp
}
  801be2:	c9                   	leave  
  801be3:	c3                   	ret    

00801be4 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801be4:	55                   	push   %ebp
  801be5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801be7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bea:	6a 00                	push   $0x0
  801bec:	ff 75 14             	pushl  0x14(%ebp)
  801bef:	ff 75 10             	pushl  0x10(%ebp)
  801bf2:	ff 75 0c             	pushl  0xc(%ebp)
  801bf5:	50                   	push   %eax
  801bf6:	6a 20                	push   $0x20
  801bf8:	e8 89 fc ff ff       	call   801886 <syscall>
  801bfd:	83 c4 18             	add    $0x18,%esp
}
  801c00:	c9                   	leave  
  801c01:	c3                   	ret    

00801c02 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c02:	55                   	push   %ebp
  801c03:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c05:	8b 45 08             	mov    0x8(%ebp),%eax
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	50                   	push   %eax
  801c11:	6a 21                	push   $0x21
  801c13:	e8 6e fc ff ff       	call   801886 <syscall>
  801c18:	83 c4 18             	add    $0x18,%esp
}
  801c1b:	90                   	nop
  801c1c:	c9                   	leave  
  801c1d:	c3                   	ret    

00801c1e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c1e:	55                   	push   %ebp
  801c1f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c21:	8b 45 08             	mov    0x8(%ebp),%eax
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 00                	push   $0x0
  801c2c:	50                   	push   %eax
  801c2d:	6a 22                	push   $0x22
  801c2f:	e8 52 fc ff ff       	call   801886 <syscall>
  801c34:	83 c4 18             	add    $0x18,%esp
}
  801c37:	c9                   	leave  
  801c38:	c3                   	ret    

00801c39 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c39:	55                   	push   %ebp
  801c3a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 02                	push   $0x2
  801c48:	e8 39 fc ff ff       	call   801886 <syscall>
  801c4d:	83 c4 18             	add    $0x18,%esp
}
  801c50:	c9                   	leave  
  801c51:	c3                   	ret    

00801c52 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c52:	55                   	push   %ebp
  801c53:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 03                	push   $0x3
  801c61:	e8 20 fc ff ff       	call   801886 <syscall>
  801c66:	83 c4 18             	add    $0x18,%esp
}
  801c69:	c9                   	leave  
  801c6a:	c3                   	ret    

00801c6b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c6b:	55                   	push   %ebp
  801c6c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	6a 04                	push   $0x4
  801c7a:	e8 07 fc ff ff       	call   801886 <syscall>
  801c7f:	83 c4 18             	add    $0x18,%esp
}
  801c82:	c9                   	leave  
  801c83:	c3                   	ret    

00801c84 <sys_exit_env>:


void sys_exit_env(void)
{
  801c84:	55                   	push   %ebp
  801c85:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 23                	push   $0x23
  801c93:	e8 ee fb ff ff       	call   801886 <syscall>
  801c98:	83 c4 18             	add    $0x18,%esp
}
  801c9b:	90                   	nop
  801c9c:	c9                   	leave  
  801c9d:	c3                   	ret    

00801c9e <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
  801ca1:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ca4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ca7:	8d 50 04             	lea    0x4(%eax),%edx
  801caa:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	52                   	push   %edx
  801cb4:	50                   	push   %eax
  801cb5:	6a 24                	push   $0x24
  801cb7:	e8 ca fb ff ff       	call   801886 <syscall>
  801cbc:	83 c4 18             	add    $0x18,%esp
	return result;
  801cbf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cc2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cc5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cc8:	89 01                	mov    %eax,(%ecx)
  801cca:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd0:	c9                   	leave  
  801cd1:	c2 04 00             	ret    $0x4

00801cd4 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801cd4:	55                   	push   %ebp
  801cd5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 00                	push   $0x0
  801cdb:	ff 75 10             	pushl  0x10(%ebp)
  801cde:	ff 75 0c             	pushl  0xc(%ebp)
  801ce1:	ff 75 08             	pushl  0x8(%ebp)
  801ce4:	6a 12                	push   $0x12
  801ce6:	e8 9b fb ff ff       	call   801886 <syscall>
  801ceb:	83 c4 18             	add    $0x18,%esp
	return ;
  801cee:	90                   	nop
}
  801cef:	c9                   	leave  
  801cf0:	c3                   	ret    

00801cf1 <sys_rcr2>:
uint32 sys_rcr2()
{
  801cf1:	55                   	push   %ebp
  801cf2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 25                	push   $0x25
  801d00:	e8 81 fb ff ff       	call   801886 <syscall>
  801d05:	83 c4 18             	add    $0x18,%esp
}
  801d08:	c9                   	leave  
  801d09:	c3                   	ret    

00801d0a <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d0a:	55                   	push   %ebp
  801d0b:	89 e5                	mov    %esp,%ebp
  801d0d:	83 ec 04             	sub    $0x4,%esp
  801d10:	8b 45 08             	mov    0x8(%ebp),%eax
  801d13:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d16:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	50                   	push   %eax
  801d23:	6a 26                	push   $0x26
  801d25:	e8 5c fb ff ff       	call   801886 <syscall>
  801d2a:	83 c4 18             	add    $0x18,%esp
	return ;
  801d2d:	90                   	nop
}
  801d2e:	c9                   	leave  
  801d2f:	c3                   	ret    

00801d30 <rsttst>:
void rsttst()
{
  801d30:	55                   	push   %ebp
  801d31:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d33:	6a 00                	push   $0x0
  801d35:	6a 00                	push   $0x0
  801d37:	6a 00                	push   $0x0
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 28                	push   $0x28
  801d3f:	e8 42 fb ff ff       	call   801886 <syscall>
  801d44:	83 c4 18             	add    $0x18,%esp
	return ;
  801d47:	90                   	nop
}
  801d48:	c9                   	leave  
  801d49:	c3                   	ret    

00801d4a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d4a:	55                   	push   %ebp
  801d4b:	89 e5                	mov    %esp,%ebp
  801d4d:	83 ec 04             	sub    $0x4,%esp
  801d50:	8b 45 14             	mov    0x14(%ebp),%eax
  801d53:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d56:	8b 55 18             	mov    0x18(%ebp),%edx
  801d59:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d5d:	52                   	push   %edx
  801d5e:	50                   	push   %eax
  801d5f:	ff 75 10             	pushl  0x10(%ebp)
  801d62:	ff 75 0c             	pushl  0xc(%ebp)
  801d65:	ff 75 08             	pushl  0x8(%ebp)
  801d68:	6a 27                	push   $0x27
  801d6a:	e8 17 fb ff ff       	call   801886 <syscall>
  801d6f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d72:	90                   	nop
}
  801d73:	c9                   	leave  
  801d74:	c3                   	ret    

00801d75 <chktst>:
void chktst(uint32 n)
{
  801d75:	55                   	push   %ebp
  801d76:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	ff 75 08             	pushl  0x8(%ebp)
  801d83:	6a 29                	push   $0x29
  801d85:	e8 fc fa ff ff       	call   801886 <syscall>
  801d8a:	83 c4 18             	add    $0x18,%esp
	return ;
  801d8d:	90                   	nop
}
  801d8e:	c9                   	leave  
  801d8f:	c3                   	ret    

00801d90 <inctst>:

void inctst()
{
  801d90:	55                   	push   %ebp
  801d91:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	6a 00                	push   $0x0
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 2a                	push   $0x2a
  801d9f:	e8 e2 fa ff ff       	call   801886 <syscall>
  801da4:	83 c4 18             	add    $0x18,%esp
	return ;
  801da7:	90                   	nop
}
  801da8:	c9                   	leave  
  801da9:	c3                   	ret    

00801daa <gettst>:
uint32 gettst()
{
  801daa:	55                   	push   %ebp
  801dab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801dad:	6a 00                	push   $0x0
  801daf:	6a 00                	push   $0x0
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	6a 00                	push   $0x0
  801db7:	6a 2b                	push   $0x2b
  801db9:	e8 c8 fa ff ff       	call   801886 <syscall>
  801dbe:	83 c4 18             	add    $0x18,%esp
}
  801dc1:	c9                   	leave  
  801dc2:	c3                   	ret    

00801dc3 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801dc3:	55                   	push   %ebp
  801dc4:	89 e5                	mov    %esp,%ebp
  801dc6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 2c                	push   $0x2c
  801dd5:	e8 ac fa ff ff       	call   801886 <syscall>
  801dda:	83 c4 18             	add    $0x18,%esp
  801ddd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801de0:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801de4:	75 07                	jne    801ded <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801de6:	b8 01 00 00 00       	mov    $0x1,%eax
  801deb:	eb 05                	jmp    801df2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ded:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801df2:	c9                   	leave  
  801df3:	c3                   	ret    

00801df4 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801df4:	55                   	push   %ebp
  801df5:	89 e5                	mov    %esp,%ebp
  801df7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 00                	push   $0x0
  801e02:	6a 00                	push   $0x0
  801e04:	6a 2c                	push   $0x2c
  801e06:	e8 7b fa ff ff       	call   801886 <syscall>
  801e0b:	83 c4 18             	add    $0x18,%esp
  801e0e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e11:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e15:	75 07                	jne    801e1e <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e17:	b8 01 00 00 00       	mov    $0x1,%eax
  801e1c:	eb 05                	jmp    801e23 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e1e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e23:	c9                   	leave  
  801e24:	c3                   	ret    

00801e25 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e25:	55                   	push   %ebp
  801e26:	89 e5                	mov    %esp,%ebp
  801e28:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 00                	push   $0x0
  801e33:	6a 00                	push   $0x0
  801e35:	6a 2c                	push   $0x2c
  801e37:	e8 4a fa ff ff       	call   801886 <syscall>
  801e3c:	83 c4 18             	add    $0x18,%esp
  801e3f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e42:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e46:	75 07                	jne    801e4f <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e48:	b8 01 00 00 00       	mov    $0x1,%eax
  801e4d:	eb 05                	jmp    801e54 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e4f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e54:	c9                   	leave  
  801e55:	c3                   	ret    

00801e56 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e56:	55                   	push   %ebp
  801e57:	89 e5                	mov    %esp,%ebp
  801e59:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e5c:	6a 00                	push   $0x0
  801e5e:	6a 00                	push   $0x0
  801e60:	6a 00                	push   $0x0
  801e62:	6a 00                	push   $0x0
  801e64:	6a 00                	push   $0x0
  801e66:	6a 2c                	push   $0x2c
  801e68:	e8 19 fa ff ff       	call   801886 <syscall>
  801e6d:	83 c4 18             	add    $0x18,%esp
  801e70:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e73:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e77:	75 07                	jne    801e80 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e79:	b8 01 00 00 00       	mov    $0x1,%eax
  801e7e:	eb 05                	jmp    801e85 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e80:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e85:	c9                   	leave  
  801e86:	c3                   	ret    

00801e87 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e87:	55                   	push   %ebp
  801e88:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e8a:	6a 00                	push   $0x0
  801e8c:	6a 00                	push   $0x0
  801e8e:	6a 00                	push   $0x0
  801e90:	6a 00                	push   $0x0
  801e92:	ff 75 08             	pushl  0x8(%ebp)
  801e95:	6a 2d                	push   $0x2d
  801e97:	e8 ea f9 ff ff       	call   801886 <syscall>
  801e9c:	83 c4 18             	add    $0x18,%esp
	return ;
  801e9f:	90                   	nop
}
  801ea0:	c9                   	leave  
  801ea1:	c3                   	ret    

00801ea2 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ea2:	55                   	push   %ebp
  801ea3:	89 e5                	mov    %esp,%ebp
  801ea5:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ea6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ea9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801eac:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb2:	6a 00                	push   $0x0
  801eb4:	53                   	push   %ebx
  801eb5:	51                   	push   %ecx
  801eb6:	52                   	push   %edx
  801eb7:	50                   	push   %eax
  801eb8:	6a 2e                	push   $0x2e
  801eba:	e8 c7 f9 ff ff       	call   801886 <syscall>
  801ebf:	83 c4 18             	add    $0x18,%esp
}
  801ec2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ec5:	c9                   	leave  
  801ec6:	c3                   	ret    

00801ec7 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ec7:	55                   	push   %ebp
  801ec8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801eca:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 00                	push   $0x0
  801ed6:	52                   	push   %edx
  801ed7:	50                   	push   %eax
  801ed8:	6a 2f                	push   $0x2f
  801eda:	e8 a7 f9 ff ff       	call   801886 <syscall>
  801edf:	83 c4 18             	add    $0x18,%esp
}
  801ee2:	c9                   	leave  
  801ee3:	c3                   	ret    

00801ee4 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801ee4:	55                   	push   %ebp
  801ee5:	89 e5                	mov    %esp,%ebp
  801ee7:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801eea:	83 ec 0c             	sub    $0xc,%esp
  801eed:	68 44 3f 80 00       	push   $0x803f44
  801ef2:	e8 8c e7 ff ff       	call   800683 <cprintf>
  801ef7:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801efa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f01:	83 ec 0c             	sub    $0xc,%esp
  801f04:	68 70 3f 80 00       	push   $0x803f70
  801f09:	e8 75 e7 ff ff       	call   800683 <cprintf>
  801f0e:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f11:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f15:	a1 38 51 80 00       	mov    0x805138,%eax
  801f1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f1d:	eb 56                	jmp    801f75 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f1f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f23:	74 1c                	je     801f41 <print_mem_block_lists+0x5d>
  801f25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f28:	8b 50 08             	mov    0x8(%eax),%edx
  801f2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f2e:	8b 48 08             	mov    0x8(%eax),%ecx
  801f31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f34:	8b 40 0c             	mov    0xc(%eax),%eax
  801f37:	01 c8                	add    %ecx,%eax
  801f39:	39 c2                	cmp    %eax,%edx
  801f3b:	73 04                	jae    801f41 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f3d:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f44:	8b 50 08             	mov    0x8(%eax),%edx
  801f47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f4a:	8b 40 0c             	mov    0xc(%eax),%eax
  801f4d:	01 c2                	add    %eax,%edx
  801f4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f52:	8b 40 08             	mov    0x8(%eax),%eax
  801f55:	83 ec 04             	sub    $0x4,%esp
  801f58:	52                   	push   %edx
  801f59:	50                   	push   %eax
  801f5a:	68 85 3f 80 00       	push   $0x803f85
  801f5f:	e8 1f e7 ff ff       	call   800683 <cprintf>
  801f64:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f6d:	a1 40 51 80 00       	mov    0x805140,%eax
  801f72:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f75:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f79:	74 07                	je     801f82 <print_mem_block_lists+0x9e>
  801f7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7e:	8b 00                	mov    (%eax),%eax
  801f80:	eb 05                	jmp    801f87 <print_mem_block_lists+0xa3>
  801f82:	b8 00 00 00 00       	mov    $0x0,%eax
  801f87:	a3 40 51 80 00       	mov    %eax,0x805140
  801f8c:	a1 40 51 80 00       	mov    0x805140,%eax
  801f91:	85 c0                	test   %eax,%eax
  801f93:	75 8a                	jne    801f1f <print_mem_block_lists+0x3b>
  801f95:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f99:	75 84                	jne    801f1f <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f9b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f9f:	75 10                	jne    801fb1 <print_mem_block_lists+0xcd>
  801fa1:	83 ec 0c             	sub    $0xc,%esp
  801fa4:	68 94 3f 80 00       	push   $0x803f94
  801fa9:	e8 d5 e6 ff ff       	call   800683 <cprintf>
  801fae:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801fb1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801fb8:	83 ec 0c             	sub    $0xc,%esp
  801fbb:	68 b8 3f 80 00       	push   $0x803fb8
  801fc0:	e8 be e6 ff ff       	call   800683 <cprintf>
  801fc5:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801fc8:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fcc:	a1 40 50 80 00       	mov    0x805040,%eax
  801fd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fd4:	eb 56                	jmp    80202c <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801fd6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fda:	74 1c                	je     801ff8 <print_mem_block_lists+0x114>
  801fdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fdf:	8b 50 08             	mov    0x8(%eax),%edx
  801fe2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fe5:	8b 48 08             	mov    0x8(%eax),%ecx
  801fe8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801feb:	8b 40 0c             	mov    0xc(%eax),%eax
  801fee:	01 c8                	add    %ecx,%eax
  801ff0:	39 c2                	cmp    %eax,%edx
  801ff2:	73 04                	jae    801ff8 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801ff4:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ff8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffb:	8b 50 08             	mov    0x8(%eax),%edx
  801ffe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802001:	8b 40 0c             	mov    0xc(%eax),%eax
  802004:	01 c2                	add    %eax,%edx
  802006:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802009:	8b 40 08             	mov    0x8(%eax),%eax
  80200c:	83 ec 04             	sub    $0x4,%esp
  80200f:	52                   	push   %edx
  802010:	50                   	push   %eax
  802011:	68 85 3f 80 00       	push   $0x803f85
  802016:	e8 68 e6 ff ff       	call   800683 <cprintf>
  80201b:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80201e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802021:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802024:	a1 48 50 80 00       	mov    0x805048,%eax
  802029:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80202c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802030:	74 07                	je     802039 <print_mem_block_lists+0x155>
  802032:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802035:	8b 00                	mov    (%eax),%eax
  802037:	eb 05                	jmp    80203e <print_mem_block_lists+0x15a>
  802039:	b8 00 00 00 00       	mov    $0x0,%eax
  80203e:	a3 48 50 80 00       	mov    %eax,0x805048
  802043:	a1 48 50 80 00       	mov    0x805048,%eax
  802048:	85 c0                	test   %eax,%eax
  80204a:	75 8a                	jne    801fd6 <print_mem_block_lists+0xf2>
  80204c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802050:	75 84                	jne    801fd6 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802052:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802056:	75 10                	jne    802068 <print_mem_block_lists+0x184>
  802058:	83 ec 0c             	sub    $0xc,%esp
  80205b:	68 d0 3f 80 00       	push   $0x803fd0
  802060:	e8 1e e6 ff ff       	call   800683 <cprintf>
  802065:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802068:	83 ec 0c             	sub    $0xc,%esp
  80206b:	68 44 3f 80 00       	push   $0x803f44
  802070:	e8 0e e6 ff ff       	call   800683 <cprintf>
  802075:	83 c4 10             	add    $0x10,%esp

}
  802078:	90                   	nop
  802079:	c9                   	leave  
  80207a:	c3                   	ret    

0080207b <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80207b:	55                   	push   %ebp
  80207c:	89 e5                	mov    %esp,%ebp
  80207e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802081:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802088:	00 00 00 
  80208b:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802092:	00 00 00 
  802095:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80209c:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  80209f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8020a6:	e9 9e 00 00 00       	jmp    802149 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8020ab:	a1 50 50 80 00       	mov    0x805050,%eax
  8020b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020b3:	c1 e2 04             	shl    $0x4,%edx
  8020b6:	01 d0                	add    %edx,%eax
  8020b8:	85 c0                	test   %eax,%eax
  8020ba:	75 14                	jne    8020d0 <initialize_MemBlocksList+0x55>
  8020bc:	83 ec 04             	sub    $0x4,%esp
  8020bf:	68 f8 3f 80 00       	push   $0x803ff8
  8020c4:	6a 46                	push   $0x46
  8020c6:	68 1b 40 80 00       	push   $0x80401b
  8020cb:	e8 64 14 00 00       	call   803534 <_panic>
  8020d0:	a1 50 50 80 00       	mov    0x805050,%eax
  8020d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020d8:	c1 e2 04             	shl    $0x4,%edx
  8020db:	01 d0                	add    %edx,%eax
  8020dd:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8020e3:	89 10                	mov    %edx,(%eax)
  8020e5:	8b 00                	mov    (%eax),%eax
  8020e7:	85 c0                	test   %eax,%eax
  8020e9:	74 18                	je     802103 <initialize_MemBlocksList+0x88>
  8020eb:	a1 48 51 80 00       	mov    0x805148,%eax
  8020f0:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8020f6:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8020f9:	c1 e1 04             	shl    $0x4,%ecx
  8020fc:	01 ca                	add    %ecx,%edx
  8020fe:	89 50 04             	mov    %edx,0x4(%eax)
  802101:	eb 12                	jmp    802115 <initialize_MemBlocksList+0x9a>
  802103:	a1 50 50 80 00       	mov    0x805050,%eax
  802108:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80210b:	c1 e2 04             	shl    $0x4,%edx
  80210e:	01 d0                	add    %edx,%eax
  802110:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802115:	a1 50 50 80 00       	mov    0x805050,%eax
  80211a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80211d:	c1 e2 04             	shl    $0x4,%edx
  802120:	01 d0                	add    %edx,%eax
  802122:	a3 48 51 80 00       	mov    %eax,0x805148
  802127:	a1 50 50 80 00       	mov    0x805050,%eax
  80212c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80212f:	c1 e2 04             	shl    $0x4,%edx
  802132:	01 d0                	add    %edx,%eax
  802134:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80213b:	a1 54 51 80 00       	mov    0x805154,%eax
  802140:	40                   	inc    %eax
  802141:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802146:	ff 45 f4             	incl   -0xc(%ebp)
  802149:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80214f:	0f 82 56 ff ff ff    	jb     8020ab <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802155:	90                   	nop
  802156:	c9                   	leave  
  802157:	c3                   	ret    

00802158 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802158:	55                   	push   %ebp
  802159:	89 e5                	mov    %esp,%ebp
  80215b:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80215e:	8b 45 08             	mov    0x8(%ebp),%eax
  802161:	8b 00                	mov    (%eax),%eax
  802163:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802166:	eb 19                	jmp    802181 <find_block+0x29>
	{
		if(va==point->sva)
  802168:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80216b:	8b 40 08             	mov    0x8(%eax),%eax
  80216e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802171:	75 05                	jne    802178 <find_block+0x20>
		   return point;
  802173:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802176:	eb 36                	jmp    8021ae <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802178:	8b 45 08             	mov    0x8(%ebp),%eax
  80217b:	8b 40 08             	mov    0x8(%eax),%eax
  80217e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802181:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802185:	74 07                	je     80218e <find_block+0x36>
  802187:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80218a:	8b 00                	mov    (%eax),%eax
  80218c:	eb 05                	jmp    802193 <find_block+0x3b>
  80218e:	b8 00 00 00 00       	mov    $0x0,%eax
  802193:	8b 55 08             	mov    0x8(%ebp),%edx
  802196:	89 42 08             	mov    %eax,0x8(%edx)
  802199:	8b 45 08             	mov    0x8(%ebp),%eax
  80219c:	8b 40 08             	mov    0x8(%eax),%eax
  80219f:	85 c0                	test   %eax,%eax
  8021a1:	75 c5                	jne    802168 <find_block+0x10>
  8021a3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021a7:	75 bf                	jne    802168 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8021a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021ae:	c9                   	leave  
  8021af:	c3                   	ret    

008021b0 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8021b0:	55                   	push   %ebp
  8021b1:	89 e5                	mov    %esp,%ebp
  8021b3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8021b6:	a1 40 50 80 00       	mov    0x805040,%eax
  8021bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8021be:	a1 44 50 80 00       	mov    0x805044,%eax
  8021c3:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8021c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021c9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8021cc:	74 24                	je     8021f2 <insert_sorted_allocList+0x42>
  8021ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d1:	8b 50 08             	mov    0x8(%eax),%edx
  8021d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d7:	8b 40 08             	mov    0x8(%eax),%eax
  8021da:	39 c2                	cmp    %eax,%edx
  8021dc:	76 14                	jbe    8021f2 <insert_sorted_allocList+0x42>
  8021de:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e1:	8b 50 08             	mov    0x8(%eax),%edx
  8021e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021e7:	8b 40 08             	mov    0x8(%eax),%eax
  8021ea:	39 c2                	cmp    %eax,%edx
  8021ec:	0f 82 60 01 00 00    	jb     802352 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8021f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021f6:	75 65                	jne    80225d <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8021f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021fc:	75 14                	jne    802212 <insert_sorted_allocList+0x62>
  8021fe:	83 ec 04             	sub    $0x4,%esp
  802201:	68 f8 3f 80 00       	push   $0x803ff8
  802206:	6a 6b                	push   $0x6b
  802208:	68 1b 40 80 00       	push   $0x80401b
  80220d:	e8 22 13 00 00       	call   803534 <_panic>
  802212:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802218:	8b 45 08             	mov    0x8(%ebp),%eax
  80221b:	89 10                	mov    %edx,(%eax)
  80221d:	8b 45 08             	mov    0x8(%ebp),%eax
  802220:	8b 00                	mov    (%eax),%eax
  802222:	85 c0                	test   %eax,%eax
  802224:	74 0d                	je     802233 <insert_sorted_allocList+0x83>
  802226:	a1 40 50 80 00       	mov    0x805040,%eax
  80222b:	8b 55 08             	mov    0x8(%ebp),%edx
  80222e:	89 50 04             	mov    %edx,0x4(%eax)
  802231:	eb 08                	jmp    80223b <insert_sorted_allocList+0x8b>
  802233:	8b 45 08             	mov    0x8(%ebp),%eax
  802236:	a3 44 50 80 00       	mov    %eax,0x805044
  80223b:	8b 45 08             	mov    0x8(%ebp),%eax
  80223e:	a3 40 50 80 00       	mov    %eax,0x805040
  802243:	8b 45 08             	mov    0x8(%ebp),%eax
  802246:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80224d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802252:	40                   	inc    %eax
  802253:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802258:	e9 dc 01 00 00       	jmp    802439 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80225d:	8b 45 08             	mov    0x8(%ebp),%eax
  802260:	8b 50 08             	mov    0x8(%eax),%edx
  802263:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802266:	8b 40 08             	mov    0x8(%eax),%eax
  802269:	39 c2                	cmp    %eax,%edx
  80226b:	77 6c                	ja     8022d9 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80226d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802271:	74 06                	je     802279 <insert_sorted_allocList+0xc9>
  802273:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802277:	75 14                	jne    80228d <insert_sorted_allocList+0xdd>
  802279:	83 ec 04             	sub    $0x4,%esp
  80227c:	68 34 40 80 00       	push   $0x804034
  802281:	6a 6f                	push   $0x6f
  802283:	68 1b 40 80 00       	push   $0x80401b
  802288:	e8 a7 12 00 00       	call   803534 <_panic>
  80228d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802290:	8b 50 04             	mov    0x4(%eax),%edx
  802293:	8b 45 08             	mov    0x8(%ebp),%eax
  802296:	89 50 04             	mov    %edx,0x4(%eax)
  802299:	8b 45 08             	mov    0x8(%ebp),%eax
  80229c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80229f:	89 10                	mov    %edx,(%eax)
  8022a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022a4:	8b 40 04             	mov    0x4(%eax),%eax
  8022a7:	85 c0                	test   %eax,%eax
  8022a9:	74 0d                	je     8022b8 <insert_sorted_allocList+0x108>
  8022ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ae:	8b 40 04             	mov    0x4(%eax),%eax
  8022b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8022b4:	89 10                	mov    %edx,(%eax)
  8022b6:	eb 08                	jmp    8022c0 <insert_sorted_allocList+0x110>
  8022b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bb:	a3 40 50 80 00       	mov    %eax,0x805040
  8022c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8022c6:	89 50 04             	mov    %edx,0x4(%eax)
  8022c9:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022ce:	40                   	inc    %eax
  8022cf:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022d4:	e9 60 01 00 00       	jmp    802439 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8022d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022dc:	8b 50 08             	mov    0x8(%eax),%edx
  8022df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022e2:	8b 40 08             	mov    0x8(%eax),%eax
  8022e5:	39 c2                	cmp    %eax,%edx
  8022e7:	0f 82 4c 01 00 00    	jb     802439 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8022ed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022f1:	75 14                	jne    802307 <insert_sorted_allocList+0x157>
  8022f3:	83 ec 04             	sub    $0x4,%esp
  8022f6:	68 6c 40 80 00       	push   $0x80406c
  8022fb:	6a 73                	push   $0x73
  8022fd:	68 1b 40 80 00       	push   $0x80401b
  802302:	e8 2d 12 00 00       	call   803534 <_panic>
  802307:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80230d:	8b 45 08             	mov    0x8(%ebp),%eax
  802310:	89 50 04             	mov    %edx,0x4(%eax)
  802313:	8b 45 08             	mov    0x8(%ebp),%eax
  802316:	8b 40 04             	mov    0x4(%eax),%eax
  802319:	85 c0                	test   %eax,%eax
  80231b:	74 0c                	je     802329 <insert_sorted_allocList+0x179>
  80231d:	a1 44 50 80 00       	mov    0x805044,%eax
  802322:	8b 55 08             	mov    0x8(%ebp),%edx
  802325:	89 10                	mov    %edx,(%eax)
  802327:	eb 08                	jmp    802331 <insert_sorted_allocList+0x181>
  802329:	8b 45 08             	mov    0x8(%ebp),%eax
  80232c:	a3 40 50 80 00       	mov    %eax,0x805040
  802331:	8b 45 08             	mov    0x8(%ebp),%eax
  802334:	a3 44 50 80 00       	mov    %eax,0x805044
  802339:	8b 45 08             	mov    0x8(%ebp),%eax
  80233c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802342:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802347:	40                   	inc    %eax
  802348:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80234d:	e9 e7 00 00 00       	jmp    802439 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802352:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802355:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802358:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80235f:	a1 40 50 80 00       	mov    0x805040,%eax
  802364:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802367:	e9 9d 00 00 00       	jmp    802409 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80236c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236f:	8b 00                	mov    (%eax),%eax
  802371:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802374:	8b 45 08             	mov    0x8(%ebp),%eax
  802377:	8b 50 08             	mov    0x8(%eax),%edx
  80237a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237d:	8b 40 08             	mov    0x8(%eax),%eax
  802380:	39 c2                	cmp    %eax,%edx
  802382:	76 7d                	jbe    802401 <insert_sorted_allocList+0x251>
  802384:	8b 45 08             	mov    0x8(%ebp),%eax
  802387:	8b 50 08             	mov    0x8(%eax),%edx
  80238a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80238d:	8b 40 08             	mov    0x8(%eax),%eax
  802390:	39 c2                	cmp    %eax,%edx
  802392:	73 6d                	jae    802401 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802394:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802398:	74 06                	je     8023a0 <insert_sorted_allocList+0x1f0>
  80239a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80239e:	75 14                	jne    8023b4 <insert_sorted_allocList+0x204>
  8023a0:	83 ec 04             	sub    $0x4,%esp
  8023a3:	68 90 40 80 00       	push   $0x804090
  8023a8:	6a 7f                	push   $0x7f
  8023aa:	68 1b 40 80 00       	push   $0x80401b
  8023af:	e8 80 11 00 00       	call   803534 <_panic>
  8023b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b7:	8b 10                	mov    (%eax),%edx
  8023b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bc:	89 10                	mov    %edx,(%eax)
  8023be:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c1:	8b 00                	mov    (%eax),%eax
  8023c3:	85 c0                	test   %eax,%eax
  8023c5:	74 0b                	je     8023d2 <insert_sorted_allocList+0x222>
  8023c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ca:	8b 00                	mov    (%eax),%eax
  8023cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8023cf:	89 50 04             	mov    %edx,0x4(%eax)
  8023d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8023d8:	89 10                	mov    %edx,(%eax)
  8023da:	8b 45 08             	mov    0x8(%ebp),%eax
  8023dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023e0:	89 50 04             	mov    %edx,0x4(%eax)
  8023e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e6:	8b 00                	mov    (%eax),%eax
  8023e8:	85 c0                	test   %eax,%eax
  8023ea:	75 08                	jne    8023f4 <insert_sorted_allocList+0x244>
  8023ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ef:	a3 44 50 80 00       	mov    %eax,0x805044
  8023f4:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8023f9:	40                   	inc    %eax
  8023fa:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8023ff:	eb 39                	jmp    80243a <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802401:	a1 48 50 80 00       	mov    0x805048,%eax
  802406:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802409:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80240d:	74 07                	je     802416 <insert_sorted_allocList+0x266>
  80240f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802412:	8b 00                	mov    (%eax),%eax
  802414:	eb 05                	jmp    80241b <insert_sorted_allocList+0x26b>
  802416:	b8 00 00 00 00       	mov    $0x0,%eax
  80241b:	a3 48 50 80 00       	mov    %eax,0x805048
  802420:	a1 48 50 80 00       	mov    0x805048,%eax
  802425:	85 c0                	test   %eax,%eax
  802427:	0f 85 3f ff ff ff    	jne    80236c <insert_sorted_allocList+0x1bc>
  80242d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802431:	0f 85 35 ff ff ff    	jne    80236c <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802437:	eb 01                	jmp    80243a <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802439:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80243a:	90                   	nop
  80243b:	c9                   	leave  
  80243c:	c3                   	ret    

0080243d <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80243d:	55                   	push   %ebp
  80243e:	89 e5                	mov    %esp,%ebp
  802440:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802443:	a1 38 51 80 00       	mov    0x805138,%eax
  802448:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80244b:	e9 85 01 00 00       	jmp    8025d5 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802450:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802453:	8b 40 0c             	mov    0xc(%eax),%eax
  802456:	3b 45 08             	cmp    0x8(%ebp),%eax
  802459:	0f 82 6e 01 00 00    	jb     8025cd <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80245f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802462:	8b 40 0c             	mov    0xc(%eax),%eax
  802465:	3b 45 08             	cmp    0x8(%ebp),%eax
  802468:	0f 85 8a 00 00 00    	jne    8024f8 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80246e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802472:	75 17                	jne    80248b <alloc_block_FF+0x4e>
  802474:	83 ec 04             	sub    $0x4,%esp
  802477:	68 c4 40 80 00       	push   $0x8040c4
  80247c:	68 93 00 00 00       	push   $0x93
  802481:	68 1b 40 80 00       	push   $0x80401b
  802486:	e8 a9 10 00 00       	call   803534 <_panic>
  80248b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248e:	8b 00                	mov    (%eax),%eax
  802490:	85 c0                	test   %eax,%eax
  802492:	74 10                	je     8024a4 <alloc_block_FF+0x67>
  802494:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802497:	8b 00                	mov    (%eax),%eax
  802499:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80249c:	8b 52 04             	mov    0x4(%edx),%edx
  80249f:	89 50 04             	mov    %edx,0x4(%eax)
  8024a2:	eb 0b                	jmp    8024af <alloc_block_FF+0x72>
  8024a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a7:	8b 40 04             	mov    0x4(%eax),%eax
  8024aa:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8024af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b2:	8b 40 04             	mov    0x4(%eax),%eax
  8024b5:	85 c0                	test   %eax,%eax
  8024b7:	74 0f                	je     8024c8 <alloc_block_FF+0x8b>
  8024b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bc:	8b 40 04             	mov    0x4(%eax),%eax
  8024bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024c2:	8b 12                	mov    (%edx),%edx
  8024c4:	89 10                	mov    %edx,(%eax)
  8024c6:	eb 0a                	jmp    8024d2 <alloc_block_FF+0x95>
  8024c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cb:	8b 00                	mov    (%eax),%eax
  8024cd:	a3 38 51 80 00       	mov    %eax,0x805138
  8024d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024de:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024e5:	a1 44 51 80 00       	mov    0x805144,%eax
  8024ea:	48                   	dec    %eax
  8024eb:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8024f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f3:	e9 10 01 00 00       	jmp    802608 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8024f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fb:	8b 40 0c             	mov    0xc(%eax),%eax
  8024fe:	3b 45 08             	cmp    0x8(%ebp),%eax
  802501:	0f 86 c6 00 00 00    	jbe    8025cd <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802507:	a1 48 51 80 00       	mov    0x805148,%eax
  80250c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  80250f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802512:	8b 50 08             	mov    0x8(%eax),%edx
  802515:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802518:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  80251b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80251e:	8b 55 08             	mov    0x8(%ebp),%edx
  802521:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802524:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802528:	75 17                	jne    802541 <alloc_block_FF+0x104>
  80252a:	83 ec 04             	sub    $0x4,%esp
  80252d:	68 c4 40 80 00       	push   $0x8040c4
  802532:	68 9b 00 00 00       	push   $0x9b
  802537:	68 1b 40 80 00       	push   $0x80401b
  80253c:	e8 f3 0f 00 00       	call   803534 <_panic>
  802541:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802544:	8b 00                	mov    (%eax),%eax
  802546:	85 c0                	test   %eax,%eax
  802548:	74 10                	je     80255a <alloc_block_FF+0x11d>
  80254a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80254d:	8b 00                	mov    (%eax),%eax
  80254f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802552:	8b 52 04             	mov    0x4(%edx),%edx
  802555:	89 50 04             	mov    %edx,0x4(%eax)
  802558:	eb 0b                	jmp    802565 <alloc_block_FF+0x128>
  80255a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80255d:	8b 40 04             	mov    0x4(%eax),%eax
  802560:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802565:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802568:	8b 40 04             	mov    0x4(%eax),%eax
  80256b:	85 c0                	test   %eax,%eax
  80256d:	74 0f                	je     80257e <alloc_block_FF+0x141>
  80256f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802572:	8b 40 04             	mov    0x4(%eax),%eax
  802575:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802578:	8b 12                	mov    (%edx),%edx
  80257a:	89 10                	mov    %edx,(%eax)
  80257c:	eb 0a                	jmp    802588 <alloc_block_FF+0x14b>
  80257e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802581:	8b 00                	mov    (%eax),%eax
  802583:	a3 48 51 80 00       	mov    %eax,0x805148
  802588:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80258b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802591:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802594:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80259b:	a1 54 51 80 00       	mov    0x805154,%eax
  8025a0:	48                   	dec    %eax
  8025a1:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8025a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a9:	8b 50 08             	mov    0x8(%eax),%edx
  8025ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8025af:	01 c2                	add    %eax,%edx
  8025b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b4:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8025b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8025bd:	2b 45 08             	sub    0x8(%ebp),%eax
  8025c0:	89 c2                	mov    %eax,%edx
  8025c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c5:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8025c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025cb:	eb 3b                	jmp    802608 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8025cd:	a1 40 51 80 00       	mov    0x805140,%eax
  8025d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025d9:	74 07                	je     8025e2 <alloc_block_FF+0x1a5>
  8025db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025de:	8b 00                	mov    (%eax),%eax
  8025e0:	eb 05                	jmp    8025e7 <alloc_block_FF+0x1aa>
  8025e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e7:	a3 40 51 80 00       	mov    %eax,0x805140
  8025ec:	a1 40 51 80 00       	mov    0x805140,%eax
  8025f1:	85 c0                	test   %eax,%eax
  8025f3:	0f 85 57 fe ff ff    	jne    802450 <alloc_block_FF+0x13>
  8025f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025fd:	0f 85 4d fe ff ff    	jne    802450 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802603:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802608:	c9                   	leave  
  802609:	c3                   	ret    

0080260a <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80260a:	55                   	push   %ebp
  80260b:	89 e5                	mov    %esp,%ebp
  80260d:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802610:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802617:	a1 38 51 80 00       	mov    0x805138,%eax
  80261c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80261f:	e9 df 00 00 00       	jmp    802703 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802624:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802627:	8b 40 0c             	mov    0xc(%eax),%eax
  80262a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80262d:	0f 82 c8 00 00 00    	jb     8026fb <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802633:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802636:	8b 40 0c             	mov    0xc(%eax),%eax
  802639:	3b 45 08             	cmp    0x8(%ebp),%eax
  80263c:	0f 85 8a 00 00 00    	jne    8026cc <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802642:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802646:	75 17                	jne    80265f <alloc_block_BF+0x55>
  802648:	83 ec 04             	sub    $0x4,%esp
  80264b:	68 c4 40 80 00       	push   $0x8040c4
  802650:	68 b7 00 00 00       	push   $0xb7
  802655:	68 1b 40 80 00       	push   $0x80401b
  80265a:	e8 d5 0e 00 00       	call   803534 <_panic>
  80265f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802662:	8b 00                	mov    (%eax),%eax
  802664:	85 c0                	test   %eax,%eax
  802666:	74 10                	je     802678 <alloc_block_BF+0x6e>
  802668:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266b:	8b 00                	mov    (%eax),%eax
  80266d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802670:	8b 52 04             	mov    0x4(%edx),%edx
  802673:	89 50 04             	mov    %edx,0x4(%eax)
  802676:	eb 0b                	jmp    802683 <alloc_block_BF+0x79>
  802678:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267b:	8b 40 04             	mov    0x4(%eax),%eax
  80267e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802683:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802686:	8b 40 04             	mov    0x4(%eax),%eax
  802689:	85 c0                	test   %eax,%eax
  80268b:	74 0f                	je     80269c <alloc_block_BF+0x92>
  80268d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802690:	8b 40 04             	mov    0x4(%eax),%eax
  802693:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802696:	8b 12                	mov    (%edx),%edx
  802698:	89 10                	mov    %edx,(%eax)
  80269a:	eb 0a                	jmp    8026a6 <alloc_block_BF+0x9c>
  80269c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269f:	8b 00                	mov    (%eax),%eax
  8026a1:	a3 38 51 80 00       	mov    %eax,0x805138
  8026a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026b9:	a1 44 51 80 00       	mov    0x805144,%eax
  8026be:	48                   	dec    %eax
  8026bf:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8026c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c7:	e9 4d 01 00 00       	jmp    802819 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8026cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8026d2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026d5:	76 24                	jbe    8026fb <alloc_block_BF+0xf1>
  8026d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026da:	8b 40 0c             	mov    0xc(%eax),%eax
  8026dd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8026e0:	73 19                	jae    8026fb <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8026e2:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8026e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8026f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f5:	8b 40 08             	mov    0x8(%eax),%eax
  8026f8:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8026fb:	a1 40 51 80 00       	mov    0x805140,%eax
  802700:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802703:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802707:	74 07                	je     802710 <alloc_block_BF+0x106>
  802709:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270c:	8b 00                	mov    (%eax),%eax
  80270e:	eb 05                	jmp    802715 <alloc_block_BF+0x10b>
  802710:	b8 00 00 00 00       	mov    $0x0,%eax
  802715:	a3 40 51 80 00       	mov    %eax,0x805140
  80271a:	a1 40 51 80 00       	mov    0x805140,%eax
  80271f:	85 c0                	test   %eax,%eax
  802721:	0f 85 fd fe ff ff    	jne    802624 <alloc_block_BF+0x1a>
  802727:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80272b:	0f 85 f3 fe ff ff    	jne    802624 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802731:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802735:	0f 84 d9 00 00 00    	je     802814 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  80273b:	a1 48 51 80 00       	mov    0x805148,%eax
  802740:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802743:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802746:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802749:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  80274c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80274f:	8b 55 08             	mov    0x8(%ebp),%edx
  802752:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802755:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802759:	75 17                	jne    802772 <alloc_block_BF+0x168>
  80275b:	83 ec 04             	sub    $0x4,%esp
  80275e:	68 c4 40 80 00       	push   $0x8040c4
  802763:	68 c7 00 00 00       	push   $0xc7
  802768:	68 1b 40 80 00       	push   $0x80401b
  80276d:	e8 c2 0d 00 00       	call   803534 <_panic>
  802772:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802775:	8b 00                	mov    (%eax),%eax
  802777:	85 c0                	test   %eax,%eax
  802779:	74 10                	je     80278b <alloc_block_BF+0x181>
  80277b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80277e:	8b 00                	mov    (%eax),%eax
  802780:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802783:	8b 52 04             	mov    0x4(%edx),%edx
  802786:	89 50 04             	mov    %edx,0x4(%eax)
  802789:	eb 0b                	jmp    802796 <alloc_block_BF+0x18c>
  80278b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80278e:	8b 40 04             	mov    0x4(%eax),%eax
  802791:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802796:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802799:	8b 40 04             	mov    0x4(%eax),%eax
  80279c:	85 c0                	test   %eax,%eax
  80279e:	74 0f                	je     8027af <alloc_block_BF+0x1a5>
  8027a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027a3:	8b 40 04             	mov    0x4(%eax),%eax
  8027a6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027a9:	8b 12                	mov    (%edx),%edx
  8027ab:	89 10                	mov    %edx,(%eax)
  8027ad:	eb 0a                	jmp    8027b9 <alloc_block_BF+0x1af>
  8027af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027b2:	8b 00                	mov    (%eax),%eax
  8027b4:	a3 48 51 80 00       	mov    %eax,0x805148
  8027b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027cc:	a1 54 51 80 00       	mov    0x805154,%eax
  8027d1:	48                   	dec    %eax
  8027d2:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8027d7:	83 ec 08             	sub    $0x8,%esp
  8027da:	ff 75 ec             	pushl  -0x14(%ebp)
  8027dd:	68 38 51 80 00       	push   $0x805138
  8027e2:	e8 71 f9 ff ff       	call   802158 <find_block>
  8027e7:	83 c4 10             	add    $0x10,%esp
  8027ea:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8027ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027f0:	8b 50 08             	mov    0x8(%eax),%edx
  8027f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f6:	01 c2                	add    %eax,%edx
  8027f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027fb:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8027fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802801:	8b 40 0c             	mov    0xc(%eax),%eax
  802804:	2b 45 08             	sub    0x8(%ebp),%eax
  802807:	89 c2                	mov    %eax,%edx
  802809:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80280c:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  80280f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802812:	eb 05                	jmp    802819 <alloc_block_BF+0x20f>
	}
	return NULL;
  802814:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802819:	c9                   	leave  
  80281a:	c3                   	ret    

0080281b <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80281b:	55                   	push   %ebp
  80281c:	89 e5                	mov    %esp,%ebp
  80281e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802821:	a1 28 50 80 00       	mov    0x805028,%eax
  802826:	85 c0                	test   %eax,%eax
  802828:	0f 85 de 01 00 00    	jne    802a0c <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80282e:	a1 38 51 80 00       	mov    0x805138,%eax
  802833:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802836:	e9 9e 01 00 00       	jmp    8029d9 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  80283b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283e:	8b 40 0c             	mov    0xc(%eax),%eax
  802841:	3b 45 08             	cmp    0x8(%ebp),%eax
  802844:	0f 82 87 01 00 00    	jb     8029d1 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  80284a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284d:	8b 40 0c             	mov    0xc(%eax),%eax
  802850:	3b 45 08             	cmp    0x8(%ebp),%eax
  802853:	0f 85 95 00 00 00    	jne    8028ee <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802859:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80285d:	75 17                	jne    802876 <alloc_block_NF+0x5b>
  80285f:	83 ec 04             	sub    $0x4,%esp
  802862:	68 c4 40 80 00       	push   $0x8040c4
  802867:	68 e0 00 00 00       	push   $0xe0
  80286c:	68 1b 40 80 00       	push   $0x80401b
  802871:	e8 be 0c 00 00       	call   803534 <_panic>
  802876:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802879:	8b 00                	mov    (%eax),%eax
  80287b:	85 c0                	test   %eax,%eax
  80287d:	74 10                	je     80288f <alloc_block_NF+0x74>
  80287f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802882:	8b 00                	mov    (%eax),%eax
  802884:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802887:	8b 52 04             	mov    0x4(%edx),%edx
  80288a:	89 50 04             	mov    %edx,0x4(%eax)
  80288d:	eb 0b                	jmp    80289a <alloc_block_NF+0x7f>
  80288f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802892:	8b 40 04             	mov    0x4(%eax),%eax
  802895:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80289a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289d:	8b 40 04             	mov    0x4(%eax),%eax
  8028a0:	85 c0                	test   %eax,%eax
  8028a2:	74 0f                	je     8028b3 <alloc_block_NF+0x98>
  8028a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a7:	8b 40 04             	mov    0x4(%eax),%eax
  8028aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028ad:	8b 12                	mov    (%edx),%edx
  8028af:	89 10                	mov    %edx,(%eax)
  8028b1:	eb 0a                	jmp    8028bd <alloc_block_NF+0xa2>
  8028b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b6:	8b 00                	mov    (%eax),%eax
  8028b8:	a3 38 51 80 00       	mov    %eax,0x805138
  8028bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028d0:	a1 44 51 80 00       	mov    0x805144,%eax
  8028d5:	48                   	dec    %eax
  8028d6:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8028db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028de:	8b 40 08             	mov    0x8(%eax),%eax
  8028e1:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8028e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e9:	e9 f8 04 00 00       	jmp    802de6 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8028ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8028f4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028f7:	0f 86 d4 00 00 00    	jbe    8029d1 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8028fd:	a1 48 51 80 00       	mov    0x805148,%eax
  802902:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802905:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802908:	8b 50 08             	mov    0x8(%eax),%edx
  80290b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80290e:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802911:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802914:	8b 55 08             	mov    0x8(%ebp),%edx
  802917:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80291a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80291e:	75 17                	jne    802937 <alloc_block_NF+0x11c>
  802920:	83 ec 04             	sub    $0x4,%esp
  802923:	68 c4 40 80 00       	push   $0x8040c4
  802928:	68 e9 00 00 00       	push   $0xe9
  80292d:	68 1b 40 80 00       	push   $0x80401b
  802932:	e8 fd 0b 00 00       	call   803534 <_panic>
  802937:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293a:	8b 00                	mov    (%eax),%eax
  80293c:	85 c0                	test   %eax,%eax
  80293e:	74 10                	je     802950 <alloc_block_NF+0x135>
  802940:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802943:	8b 00                	mov    (%eax),%eax
  802945:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802948:	8b 52 04             	mov    0x4(%edx),%edx
  80294b:	89 50 04             	mov    %edx,0x4(%eax)
  80294e:	eb 0b                	jmp    80295b <alloc_block_NF+0x140>
  802950:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802953:	8b 40 04             	mov    0x4(%eax),%eax
  802956:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80295b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80295e:	8b 40 04             	mov    0x4(%eax),%eax
  802961:	85 c0                	test   %eax,%eax
  802963:	74 0f                	je     802974 <alloc_block_NF+0x159>
  802965:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802968:	8b 40 04             	mov    0x4(%eax),%eax
  80296b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80296e:	8b 12                	mov    (%edx),%edx
  802970:	89 10                	mov    %edx,(%eax)
  802972:	eb 0a                	jmp    80297e <alloc_block_NF+0x163>
  802974:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802977:	8b 00                	mov    (%eax),%eax
  802979:	a3 48 51 80 00       	mov    %eax,0x805148
  80297e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802981:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802987:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80298a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802991:	a1 54 51 80 00       	mov    0x805154,%eax
  802996:	48                   	dec    %eax
  802997:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  80299c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80299f:	8b 40 08             	mov    0x8(%eax),%eax
  8029a2:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8029a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029aa:	8b 50 08             	mov    0x8(%eax),%edx
  8029ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b0:	01 c2                	add    %eax,%edx
  8029b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b5:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8029b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8029be:	2b 45 08             	sub    0x8(%ebp),%eax
  8029c1:	89 c2                	mov    %eax,%edx
  8029c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c6:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8029c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029cc:	e9 15 04 00 00       	jmp    802de6 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8029d1:	a1 40 51 80 00       	mov    0x805140,%eax
  8029d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029dd:	74 07                	je     8029e6 <alloc_block_NF+0x1cb>
  8029df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e2:	8b 00                	mov    (%eax),%eax
  8029e4:	eb 05                	jmp    8029eb <alloc_block_NF+0x1d0>
  8029e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8029eb:	a3 40 51 80 00       	mov    %eax,0x805140
  8029f0:	a1 40 51 80 00       	mov    0x805140,%eax
  8029f5:	85 c0                	test   %eax,%eax
  8029f7:	0f 85 3e fe ff ff    	jne    80283b <alloc_block_NF+0x20>
  8029fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a01:	0f 85 34 fe ff ff    	jne    80283b <alloc_block_NF+0x20>
  802a07:	e9 d5 03 00 00       	jmp    802de1 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a0c:	a1 38 51 80 00       	mov    0x805138,%eax
  802a11:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a14:	e9 b1 01 00 00       	jmp    802bca <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1c:	8b 50 08             	mov    0x8(%eax),%edx
  802a1f:	a1 28 50 80 00       	mov    0x805028,%eax
  802a24:	39 c2                	cmp    %eax,%edx
  802a26:	0f 82 96 01 00 00    	jb     802bc2 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802a2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2f:	8b 40 0c             	mov    0xc(%eax),%eax
  802a32:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a35:	0f 82 87 01 00 00    	jb     802bc2 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3e:	8b 40 0c             	mov    0xc(%eax),%eax
  802a41:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a44:	0f 85 95 00 00 00    	jne    802adf <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a4a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a4e:	75 17                	jne    802a67 <alloc_block_NF+0x24c>
  802a50:	83 ec 04             	sub    $0x4,%esp
  802a53:	68 c4 40 80 00       	push   $0x8040c4
  802a58:	68 fc 00 00 00       	push   $0xfc
  802a5d:	68 1b 40 80 00       	push   $0x80401b
  802a62:	e8 cd 0a 00 00       	call   803534 <_panic>
  802a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6a:	8b 00                	mov    (%eax),%eax
  802a6c:	85 c0                	test   %eax,%eax
  802a6e:	74 10                	je     802a80 <alloc_block_NF+0x265>
  802a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a73:	8b 00                	mov    (%eax),%eax
  802a75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a78:	8b 52 04             	mov    0x4(%edx),%edx
  802a7b:	89 50 04             	mov    %edx,0x4(%eax)
  802a7e:	eb 0b                	jmp    802a8b <alloc_block_NF+0x270>
  802a80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a83:	8b 40 04             	mov    0x4(%eax),%eax
  802a86:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8e:	8b 40 04             	mov    0x4(%eax),%eax
  802a91:	85 c0                	test   %eax,%eax
  802a93:	74 0f                	je     802aa4 <alloc_block_NF+0x289>
  802a95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a98:	8b 40 04             	mov    0x4(%eax),%eax
  802a9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a9e:	8b 12                	mov    (%edx),%edx
  802aa0:	89 10                	mov    %edx,(%eax)
  802aa2:	eb 0a                	jmp    802aae <alloc_block_NF+0x293>
  802aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa7:	8b 00                	mov    (%eax),%eax
  802aa9:	a3 38 51 80 00       	mov    %eax,0x805138
  802aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ac1:	a1 44 51 80 00       	mov    0x805144,%eax
  802ac6:	48                   	dec    %eax
  802ac7:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acf:	8b 40 08             	mov    0x8(%eax),%eax
  802ad2:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ada:	e9 07 03 00 00       	jmp    802de6 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae2:	8b 40 0c             	mov    0xc(%eax),%eax
  802ae5:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ae8:	0f 86 d4 00 00 00    	jbe    802bc2 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802aee:	a1 48 51 80 00       	mov    0x805148,%eax
  802af3:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802af6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af9:	8b 50 08             	mov    0x8(%eax),%edx
  802afc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aff:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b02:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b05:	8b 55 08             	mov    0x8(%ebp),%edx
  802b08:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b0b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b0f:	75 17                	jne    802b28 <alloc_block_NF+0x30d>
  802b11:	83 ec 04             	sub    $0x4,%esp
  802b14:	68 c4 40 80 00       	push   $0x8040c4
  802b19:	68 04 01 00 00       	push   $0x104
  802b1e:	68 1b 40 80 00       	push   $0x80401b
  802b23:	e8 0c 0a 00 00       	call   803534 <_panic>
  802b28:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b2b:	8b 00                	mov    (%eax),%eax
  802b2d:	85 c0                	test   %eax,%eax
  802b2f:	74 10                	je     802b41 <alloc_block_NF+0x326>
  802b31:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b34:	8b 00                	mov    (%eax),%eax
  802b36:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b39:	8b 52 04             	mov    0x4(%edx),%edx
  802b3c:	89 50 04             	mov    %edx,0x4(%eax)
  802b3f:	eb 0b                	jmp    802b4c <alloc_block_NF+0x331>
  802b41:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b44:	8b 40 04             	mov    0x4(%eax),%eax
  802b47:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b4c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b4f:	8b 40 04             	mov    0x4(%eax),%eax
  802b52:	85 c0                	test   %eax,%eax
  802b54:	74 0f                	je     802b65 <alloc_block_NF+0x34a>
  802b56:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b59:	8b 40 04             	mov    0x4(%eax),%eax
  802b5c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b5f:	8b 12                	mov    (%edx),%edx
  802b61:	89 10                	mov    %edx,(%eax)
  802b63:	eb 0a                	jmp    802b6f <alloc_block_NF+0x354>
  802b65:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b68:	8b 00                	mov    (%eax),%eax
  802b6a:	a3 48 51 80 00       	mov    %eax,0x805148
  802b6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b72:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b78:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b7b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b82:	a1 54 51 80 00       	mov    0x805154,%eax
  802b87:	48                   	dec    %eax
  802b88:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802b8d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b90:	8b 40 08             	mov    0x8(%eax),%eax
  802b93:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802b98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9b:	8b 50 08             	mov    0x8(%eax),%edx
  802b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba1:	01 c2                	add    %eax,%edx
  802ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba6:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802ba9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bac:	8b 40 0c             	mov    0xc(%eax),%eax
  802baf:	2b 45 08             	sub    0x8(%ebp),%eax
  802bb2:	89 c2                	mov    %eax,%edx
  802bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb7:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802bba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bbd:	e9 24 02 00 00       	jmp    802de6 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802bc2:	a1 40 51 80 00       	mov    0x805140,%eax
  802bc7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bce:	74 07                	je     802bd7 <alloc_block_NF+0x3bc>
  802bd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd3:	8b 00                	mov    (%eax),%eax
  802bd5:	eb 05                	jmp    802bdc <alloc_block_NF+0x3c1>
  802bd7:	b8 00 00 00 00       	mov    $0x0,%eax
  802bdc:	a3 40 51 80 00       	mov    %eax,0x805140
  802be1:	a1 40 51 80 00       	mov    0x805140,%eax
  802be6:	85 c0                	test   %eax,%eax
  802be8:	0f 85 2b fe ff ff    	jne    802a19 <alloc_block_NF+0x1fe>
  802bee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bf2:	0f 85 21 fe ff ff    	jne    802a19 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802bf8:	a1 38 51 80 00       	mov    0x805138,%eax
  802bfd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c00:	e9 ae 01 00 00       	jmp    802db3 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802c05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c08:	8b 50 08             	mov    0x8(%eax),%edx
  802c0b:	a1 28 50 80 00       	mov    0x805028,%eax
  802c10:	39 c2                	cmp    %eax,%edx
  802c12:	0f 83 93 01 00 00    	jae    802dab <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802c18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1b:	8b 40 0c             	mov    0xc(%eax),%eax
  802c1e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c21:	0f 82 84 01 00 00    	jb     802dab <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802c27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2a:	8b 40 0c             	mov    0xc(%eax),%eax
  802c2d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c30:	0f 85 95 00 00 00    	jne    802ccb <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802c36:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c3a:	75 17                	jne    802c53 <alloc_block_NF+0x438>
  802c3c:	83 ec 04             	sub    $0x4,%esp
  802c3f:	68 c4 40 80 00       	push   $0x8040c4
  802c44:	68 14 01 00 00       	push   $0x114
  802c49:	68 1b 40 80 00       	push   $0x80401b
  802c4e:	e8 e1 08 00 00       	call   803534 <_panic>
  802c53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c56:	8b 00                	mov    (%eax),%eax
  802c58:	85 c0                	test   %eax,%eax
  802c5a:	74 10                	je     802c6c <alloc_block_NF+0x451>
  802c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5f:	8b 00                	mov    (%eax),%eax
  802c61:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c64:	8b 52 04             	mov    0x4(%edx),%edx
  802c67:	89 50 04             	mov    %edx,0x4(%eax)
  802c6a:	eb 0b                	jmp    802c77 <alloc_block_NF+0x45c>
  802c6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6f:	8b 40 04             	mov    0x4(%eax),%eax
  802c72:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7a:	8b 40 04             	mov    0x4(%eax),%eax
  802c7d:	85 c0                	test   %eax,%eax
  802c7f:	74 0f                	je     802c90 <alloc_block_NF+0x475>
  802c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c84:	8b 40 04             	mov    0x4(%eax),%eax
  802c87:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c8a:	8b 12                	mov    (%edx),%edx
  802c8c:	89 10                	mov    %edx,(%eax)
  802c8e:	eb 0a                	jmp    802c9a <alloc_block_NF+0x47f>
  802c90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c93:	8b 00                	mov    (%eax),%eax
  802c95:	a3 38 51 80 00       	mov    %eax,0x805138
  802c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ca3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cad:	a1 44 51 80 00       	mov    0x805144,%eax
  802cb2:	48                   	dec    %eax
  802cb3:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbb:	8b 40 08             	mov    0x8(%eax),%eax
  802cbe:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802cc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc6:	e9 1b 01 00 00       	jmp    802de6 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802ccb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cce:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd1:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cd4:	0f 86 d1 00 00 00    	jbe    802dab <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802cda:	a1 48 51 80 00       	mov    0x805148,%eax
  802cdf:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce5:	8b 50 08             	mov    0x8(%eax),%edx
  802ce8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ceb:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802cee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cf1:	8b 55 08             	mov    0x8(%ebp),%edx
  802cf4:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802cf7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802cfb:	75 17                	jne    802d14 <alloc_block_NF+0x4f9>
  802cfd:	83 ec 04             	sub    $0x4,%esp
  802d00:	68 c4 40 80 00       	push   $0x8040c4
  802d05:	68 1c 01 00 00       	push   $0x11c
  802d0a:	68 1b 40 80 00       	push   $0x80401b
  802d0f:	e8 20 08 00 00       	call   803534 <_panic>
  802d14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d17:	8b 00                	mov    (%eax),%eax
  802d19:	85 c0                	test   %eax,%eax
  802d1b:	74 10                	je     802d2d <alloc_block_NF+0x512>
  802d1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d20:	8b 00                	mov    (%eax),%eax
  802d22:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d25:	8b 52 04             	mov    0x4(%edx),%edx
  802d28:	89 50 04             	mov    %edx,0x4(%eax)
  802d2b:	eb 0b                	jmp    802d38 <alloc_block_NF+0x51d>
  802d2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d30:	8b 40 04             	mov    0x4(%eax),%eax
  802d33:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d3b:	8b 40 04             	mov    0x4(%eax),%eax
  802d3e:	85 c0                	test   %eax,%eax
  802d40:	74 0f                	je     802d51 <alloc_block_NF+0x536>
  802d42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d45:	8b 40 04             	mov    0x4(%eax),%eax
  802d48:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d4b:	8b 12                	mov    (%edx),%edx
  802d4d:	89 10                	mov    %edx,(%eax)
  802d4f:	eb 0a                	jmp    802d5b <alloc_block_NF+0x540>
  802d51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d54:	8b 00                	mov    (%eax),%eax
  802d56:	a3 48 51 80 00       	mov    %eax,0x805148
  802d5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d5e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d64:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d67:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d6e:	a1 54 51 80 00       	mov    0x805154,%eax
  802d73:	48                   	dec    %eax
  802d74:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802d79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d7c:	8b 40 08             	mov    0x8(%eax),%eax
  802d7f:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802d84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d87:	8b 50 08             	mov    0x8(%eax),%edx
  802d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8d:	01 c2                	add    %eax,%edx
  802d8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d92:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d98:	8b 40 0c             	mov    0xc(%eax),%eax
  802d9b:	2b 45 08             	sub    0x8(%ebp),%eax
  802d9e:	89 c2                	mov    %eax,%edx
  802da0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da3:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802da6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802da9:	eb 3b                	jmp    802de6 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802dab:	a1 40 51 80 00       	mov    0x805140,%eax
  802db0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802db3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802db7:	74 07                	je     802dc0 <alloc_block_NF+0x5a5>
  802db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbc:	8b 00                	mov    (%eax),%eax
  802dbe:	eb 05                	jmp    802dc5 <alloc_block_NF+0x5aa>
  802dc0:	b8 00 00 00 00       	mov    $0x0,%eax
  802dc5:	a3 40 51 80 00       	mov    %eax,0x805140
  802dca:	a1 40 51 80 00       	mov    0x805140,%eax
  802dcf:	85 c0                	test   %eax,%eax
  802dd1:	0f 85 2e fe ff ff    	jne    802c05 <alloc_block_NF+0x3ea>
  802dd7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ddb:	0f 85 24 fe ff ff    	jne    802c05 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802de1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802de6:	c9                   	leave  
  802de7:	c3                   	ret    

00802de8 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802de8:	55                   	push   %ebp
  802de9:	89 e5                	mov    %esp,%ebp
  802deb:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802dee:	a1 38 51 80 00       	mov    0x805138,%eax
  802df3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802df6:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802dfb:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802dfe:	a1 38 51 80 00       	mov    0x805138,%eax
  802e03:	85 c0                	test   %eax,%eax
  802e05:	74 14                	je     802e1b <insert_sorted_with_merge_freeList+0x33>
  802e07:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0a:	8b 50 08             	mov    0x8(%eax),%edx
  802e0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e10:	8b 40 08             	mov    0x8(%eax),%eax
  802e13:	39 c2                	cmp    %eax,%edx
  802e15:	0f 87 9b 01 00 00    	ja     802fb6 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802e1b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e1f:	75 17                	jne    802e38 <insert_sorted_with_merge_freeList+0x50>
  802e21:	83 ec 04             	sub    $0x4,%esp
  802e24:	68 f8 3f 80 00       	push   $0x803ff8
  802e29:	68 38 01 00 00       	push   $0x138
  802e2e:	68 1b 40 80 00       	push   $0x80401b
  802e33:	e8 fc 06 00 00       	call   803534 <_panic>
  802e38:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e41:	89 10                	mov    %edx,(%eax)
  802e43:	8b 45 08             	mov    0x8(%ebp),%eax
  802e46:	8b 00                	mov    (%eax),%eax
  802e48:	85 c0                	test   %eax,%eax
  802e4a:	74 0d                	je     802e59 <insert_sorted_with_merge_freeList+0x71>
  802e4c:	a1 38 51 80 00       	mov    0x805138,%eax
  802e51:	8b 55 08             	mov    0x8(%ebp),%edx
  802e54:	89 50 04             	mov    %edx,0x4(%eax)
  802e57:	eb 08                	jmp    802e61 <insert_sorted_with_merge_freeList+0x79>
  802e59:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e61:	8b 45 08             	mov    0x8(%ebp),%eax
  802e64:	a3 38 51 80 00       	mov    %eax,0x805138
  802e69:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e73:	a1 44 51 80 00       	mov    0x805144,%eax
  802e78:	40                   	inc    %eax
  802e79:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e7e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e82:	0f 84 a8 06 00 00    	je     803530 <insert_sorted_with_merge_freeList+0x748>
  802e88:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8b:	8b 50 08             	mov    0x8(%eax),%edx
  802e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e91:	8b 40 0c             	mov    0xc(%eax),%eax
  802e94:	01 c2                	add    %eax,%edx
  802e96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e99:	8b 40 08             	mov    0x8(%eax),%eax
  802e9c:	39 c2                	cmp    %eax,%edx
  802e9e:	0f 85 8c 06 00 00    	jne    803530 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea7:	8b 50 0c             	mov    0xc(%eax),%edx
  802eaa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ead:	8b 40 0c             	mov    0xc(%eax),%eax
  802eb0:	01 c2                	add    %eax,%edx
  802eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb5:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802eb8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ebc:	75 17                	jne    802ed5 <insert_sorted_with_merge_freeList+0xed>
  802ebe:	83 ec 04             	sub    $0x4,%esp
  802ec1:	68 c4 40 80 00       	push   $0x8040c4
  802ec6:	68 3c 01 00 00       	push   $0x13c
  802ecb:	68 1b 40 80 00       	push   $0x80401b
  802ed0:	e8 5f 06 00 00       	call   803534 <_panic>
  802ed5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed8:	8b 00                	mov    (%eax),%eax
  802eda:	85 c0                	test   %eax,%eax
  802edc:	74 10                	je     802eee <insert_sorted_with_merge_freeList+0x106>
  802ede:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee1:	8b 00                	mov    (%eax),%eax
  802ee3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ee6:	8b 52 04             	mov    0x4(%edx),%edx
  802ee9:	89 50 04             	mov    %edx,0x4(%eax)
  802eec:	eb 0b                	jmp    802ef9 <insert_sorted_with_merge_freeList+0x111>
  802eee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef1:	8b 40 04             	mov    0x4(%eax),%eax
  802ef4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ef9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802efc:	8b 40 04             	mov    0x4(%eax),%eax
  802eff:	85 c0                	test   %eax,%eax
  802f01:	74 0f                	je     802f12 <insert_sorted_with_merge_freeList+0x12a>
  802f03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f06:	8b 40 04             	mov    0x4(%eax),%eax
  802f09:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f0c:	8b 12                	mov    (%edx),%edx
  802f0e:	89 10                	mov    %edx,(%eax)
  802f10:	eb 0a                	jmp    802f1c <insert_sorted_with_merge_freeList+0x134>
  802f12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f15:	8b 00                	mov    (%eax),%eax
  802f17:	a3 38 51 80 00       	mov    %eax,0x805138
  802f1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f1f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f28:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f2f:	a1 44 51 80 00       	mov    0x805144,%eax
  802f34:	48                   	dec    %eax
  802f35:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802f3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f3d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802f44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f47:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802f4e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f52:	75 17                	jne    802f6b <insert_sorted_with_merge_freeList+0x183>
  802f54:	83 ec 04             	sub    $0x4,%esp
  802f57:	68 f8 3f 80 00       	push   $0x803ff8
  802f5c:	68 3f 01 00 00       	push   $0x13f
  802f61:	68 1b 40 80 00       	push   $0x80401b
  802f66:	e8 c9 05 00 00       	call   803534 <_panic>
  802f6b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f74:	89 10                	mov    %edx,(%eax)
  802f76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f79:	8b 00                	mov    (%eax),%eax
  802f7b:	85 c0                	test   %eax,%eax
  802f7d:	74 0d                	je     802f8c <insert_sorted_with_merge_freeList+0x1a4>
  802f7f:	a1 48 51 80 00       	mov    0x805148,%eax
  802f84:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f87:	89 50 04             	mov    %edx,0x4(%eax)
  802f8a:	eb 08                	jmp    802f94 <insert_sorted_with_merge_freeList+0x1ac>
  802f8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f8f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f97:	a3 48 51 80 00       	mov    %eax,0x805148
  802f9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f9f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fa6:	a1 54 51 80 00       	mov    0x805154,%eax
  802fab:	40                   	inc    %eax
  802fac:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802fb1:	e9 7a 05 00 00       	jmp    803530 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb9:	8b 50 08             	mov    0x8(%eax),%edx
  802fbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fbf:	8b 40 08             	mov    0x8(%eax),%eax
  802fc2:	39 c2                	cmp    %eax,%edx
  802fc4:	0f 82 14 01 00 00    	jb     8030de <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802fca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fcd:	8b 50 08             	mov    0x8(%eax),%edx
  802fd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fd3:	8b 40 0c             	mov    0xc(%eax),%eax
  802fd6:	01 c2                	add    %eax,%edx
  802fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdb:	8b 40 08             	mov    0x8(%eax),%eax
  802fde:	39 c2                	cmp    %eax,%edx
  802fe0:	0f 85 90 00 00 00    	jne    803076 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802fe6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fe9:	8b 50 0c             	mov    0xc(%eax),%edx
  802fec:	8b 45 08             	mov    0x8(%ebp),%eax
  802fef:	8b 40 0c             	mov    0xc(%eax),%eax
  802ff2:	01 c2                	add    %eax,%edx
  802ff4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ff7:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803004:	8b 45 08             	mov    0x8(%ebp),%eax
  803007:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80300e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803012:	75 17                	jne    80302b <insert_sorted_with_merge_freeList+0x243>
  803014:	83 ec 04             	sub    $0x4,%esp
  803017:	68 f8 3f 80 00       	push   $0x803ff8
  80301c:	68 49 01 00 00       	push   $0x149
  803021:	68 1b 40 80 00       	push   $0x80401b
  803026:	e8 09 05 00 00       	call   803534 <_panic>
  80302b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803031:	8b 45 08             	mov    0x8(%ebp),%eax
  803034:	89 10                	mov    %edx,(%eax)
  803036:	8b 45 08             	mov    0x8(%ebp),%eax
  803039:	8b 00                	mov    (%eax),%eax
  80303b:	85 c0                	test   %eax,%eax
  80303d:	74 0d                	je     80304c <insert_sorted_with_merge_freeList+0x264>
  80303f:	a1 48 51 80 00       	mov    0x805148,%eax
  803044:	8b 55 08             	mov    0x8(%ebp),%edx
  803047:	89 50 04             	mov    %edx,0x4(%eax)
  80304a:	eb 08                	jmp    803054 <insert_sorted_with_merge_freeList+0x26c>
  80304c:	8b 45 08             	mov    0x8(%ebp),%eax
  80304f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803054:	8b 45 08             	mov    0x8(%ebp),%eax
  803057:	a3 48 51 80 00       	mov    %eax,0x805148
  80305c:	8b 45 08             	mov    0x8(%ebp),%eax
  80305f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803066:	a1 54 51 80 00       	mov    0x805154,%eax
  80306b:	40                   	inc    %eax
  80306c:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803071:	e9 bb 04 00 00       	jmp    803531 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803076:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80307a:	75 17                	jne    803093 <insert_sorted_with_merge_freeList+0x2ab>
  80307c:	83 ec 04             	sub    $0x4,%esp
  80307f:	68 6c 40 80 00       	push   $0x80406c
  803084:	68 4c 01 00 00       	push   $0x14c
  803089:	68 1b 40 80 00       	push   $0x80401b
  80308e:	e8 a1 04 00 00       	call   803534 <_panic>
  803093:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803099:	8b 45 08             	mov    0x8(%ebp),%eax
  80309c:	89 50 04             	mov    %edx,0x4(%eax)
  80309f:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a2:	8b 40 04             	mov    0x4(%eax),%eax
  8030a5:	85 c0                	test   %eax,%eax
  8030a7:	74 0c                	je     8030b5 <insert_sorted_with_merge_freeList+0x2cd>
  8030a9:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8030ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8030b1:	89 10                	mov    %edx,(%eax)
  8030b3:	eb 08                	jmp    8030bd <insert_sorted_with_merge_freeList+0x2d5>
  8030b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b8:	a3 38 51 80 00       	mov    %eax,0x805138
  8030bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030ce:	a1 44 51 80 00       	mov    0x805144,%eax
  8030d3:	40                   	inc    %eax
  8030d4:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8030d9:	e9 53 04 00 00       	jmp    803531 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8030de:	a1 38 51 80 00       	mov    0x805138,%eax
  8030e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030e6:	e9 15 04 00 00       	jmp    803500 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8030eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ee:	8b 00                	mov    (%eax),%eax
  8030f0:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8030f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f6:	8b 50 08             	mov    0x8(%eax),%edx
  8030f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fc:	8b 40 08             	mov    0x8(%eax),%eax
  8030ff:	39 c2                	cmp    %eax,%edx
  803101:	0f 86 f1 03 00 00    	jbe    8034f8 <insert_sorted_with_merge_freeList+0x710>
  803107:	8b 45 08             	mov    0x8(%ebp),%eax
  80310a:	8b 50 08             	mov    0x8(%eax),%edx
  80310d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803110:	8b 40 08             	mov    0x8(%eax),%eax
  803113:	39 c2                	cmp    %eax,%edx
  803115:	0f 83 dd 03 00 00    	jae    8034f8 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  80311b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80311e:	8b 50 08             	mov    0x8(%eax),%edx
  803121:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803124:	8b 40 0c             	mov    0xc(%eax),%eax
  803127:	01 c2                	add    %eax,%edx
  803129:	8b 45 08             	mov    0x8(%ebp),%eax
  80312c:	8b 40 08             	mov    0x8(%eax),%eax
  80312f:	39 c2                	cmp    %eax,%edx
  803131:	0f 85 b9 01 00 00    	jne    8032f0 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803137:	8b 45 08             	mov    0x8(%ebp),%eax
  80313a:	8b 50 08             	mov    0x8(%eax),%edx
  80313d:	8b 45 08             	mov    0x8(%ebp),%eax
  803140:	8b 40 0c             	mov    0xc(%eax),%eax
  803143:	01 c2                	add    %eax,%edx
  803145:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803148:	8b 40 08             	mov    0x8(%eax),%eax
  80314b:	39 c2                	cmp    %eax,%edx
  80314d:	0f 85 0d 01 00 00    	jne    803260 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803153:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803156:	8b 50 0c             	mov    0xc(%eax),%edx
  803159:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80315c:	8b 40 0c             	mov    0xc(%eax),%eax
  80315f:	01 c2                	add    %eax,%edx
  803161:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803164:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803167:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80316b:	75 17                	jne    803184 <insert_sorted_with_merge_freeList+0x39c>
  80316d:	83 ec 04             	sub    $0x4,%esp
  803170:	68 c4 40 80 00       	push   $0x8040c4
  803175:	68 5c 01 00 00       	push   $0x15c
  80317a:	68 1b 40 80 00       	push   $0x80401b
  80317f:	e8 b0 03 00 00       	call   803534 <_panic>
  803184:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803187:	8b 00                	mov    (%eax),%eax
  803189:	85 c0                	test   %eax,%eax
  80318b:	74 10                	je     80319d <insert_sorted_with_merge_freeList+0x3b5>
  80318d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803190:	8b 00                	mov    (%eax),%eax
  803192:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803195:	8b 52 04             	mov    0x4(%edx),%edx
  803198:	89 50 04             	mov    %edx,0x4(%eax)
  80319b:	eb 0b                	jmp    8031a8 <insert_sorted_with_merge_freeList+0x3c0>
  80319d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a0:	8b 40 04             	mov    0x4(%eax),%eax
  8031a3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ab:	8b 40 04             	mov    0x4(%eax),%eax
  8031ae:	85 c0                	test   %eax,%eax
  8031b0:	74 0f                	je     8031c1 <insert_sorted_with_merge_freeList+0x3d9>
  8031b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b5:	8b 40 04             	mov    0x4(%eax),%eax
  8031b8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031bb:	8b 12                	mov    (%edx),%edx
  8031bd:	89 10                	mov    %edx,(%eax)
  8031bf:	eb 0a                	jmp    8031cb <insert_sorted_with_merge_freeList+0x3e3>
  8031c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c4:	8b 00                	mov    (%eax),%eax
  8031c6:	a3 38 51 80 00       	mov    %eax,0x805138
  8031cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031de:	a1 44 51 80 00       	mov    0x805144,%eax
  8031e3:	48                   	dec    %eax
  8031e4:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8031e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ec:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8031f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8031fd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803201:	75 17                	jne    80321a <insert_sorted_with_merge_freeList+0x432>
  803203:	83 ec 04             	sub    $0x4,%esp
  803206:	68 f8 3f 80 00       	push   $0x803ff8
  80320b:	68 5f 01 00 00       	push   $0x15f
  803210:	68 1b 40 80 00       	push   $0x80401b
  803215:	e8 1a 03 00 00       	call   803534 <_panic>
  80321a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803220:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803223:	89 10                	mov    %edx,(%eax)
  803225:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803228:	8b 00                	mov    (%eax),%eax
  80322a:	85 c0                	test   %eax,%eax
  80322c:	74 0d                	je     80323b <insert_sorted_with_merge_freeList+0x453>
  80322e:	a1 48 51 80 00       	mov    0x805148,%eax
  803233:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803236:	89 50 04             	mov    %edx,0x4(%eax)
  803239:	eb 08                	jmp    803243 <insert_sorted_with_merge_freeList+0x45b>
  80323b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80323e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803243:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803246:	a3 48 51 80 00       	mov    %eax,0x805148
  80324b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80324e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803255:	a1 54 51 80 00       	mov    0x805154,%eax
  80325a:	40                   	inc    %eax
  80325b:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803260:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803263:	8b 50 0c             	mov    0xc(%eax),%edx
  803266:	8b 45 08             	mov    0x8(%ebp),%eax
  803269:	8b 40 0c             	mov    0xc(%eax),%eax
  80326c:	01 c2                	add    %eax,%edx
  80326e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803271:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803274:	8b 45 08             	mov    0x8(%ebp),%eax
  803277:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80327e:	8b 45 08             	mov    0x8(%ebp),%eax
  803281:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803288:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80328c:	75 17                	jne    8032a5 <insert_sorted_with_merge_freeList+0x4bd>
  80328e:	83 ec 04             	sub    $0x4,%esp
  803291:	68 f8 3f 80 00       	push   $0x803ff8
  803296:	68 64 01 00 00       	push   $0x164
  80329b:	68 1b 40 80 00       	push   $0x80401b
  8032a0:	e8 8f 02 00 00       	call   803534 <_panic>
  8032a5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ae:	89 10                	mov    %edx,(%eax)
  8032b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b3:	8b 00                	mov    (%eax),%eax
  8032b5:	85 c0                	test   %eax,%eax
  8032b7:	74 0d                	je     8032c6 <insert_sorted_with_merge_freeList+0x4de>
  8032b9:	a1 48 51 80 00       	mov    0x805148,%eax
  8032be:	8b 55 08             	mov    0x8(%ebp),%edx
  8032c1:	89 50 04             	mov    %edx,0x4(%eax)
  8032c4:	eb 08                	jmp    8032ce <insert_sorted_with_merge_freeList+0x4e6>
  8032c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d1:	a3 48 51 80 00       	mov    %eax,0x805148
  8032d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032e0:	a1 54 51 80 00       	mov    0x805154,%eax
  8032e5:	40                   	inc    %eax
  8032e6:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8032eb:	e9 41 02 00 00       	jmp    803531 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8032f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f3:	8b 50 08             	mov    0x8(%eax),%edx
  8032f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8032fc:	01 c2                	add    %eax,%edx
  8032fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803301:	8b 40 08             	mov    0x8(%eax),%eax
  803304:	39 c2                	cmp    %eax,%edx
  803306:	0f 85 7c 01 00 00    	jne    803488 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80330c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803310:	74 06                	je     803318 <insert_sorted_with_merge_freeList+0x530>
  803312:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803316:	75 17                	jne    80332f <insert_sorted_with_merge_freeList+0x547>
  803318:	83 ec 04             	sub    $0x4,%esp
  80331b:	68 34 40 80 00       	push   $0x804034
  803320:	68 69 01 00 00       	push   $0x169
  803325:	68 1b 40 80 00       	push   $0x80401b
  80332a:	e8 05 02 00 00       	call   803534 <_panic>
  80332f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803332:	8b 50 04             	mov    0x4(%eax),%edx
  803335:	8b 45 08             	mov    0x8(%ebp),%eax
  803338:	89 50 04             	mov    %edx,0x4(%eax)
  80333b:	8b 45 08             	mov    0x8(%ebp),%eax
  80333e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803341:	89 10                	mov    %edx,(%eax)
  803343:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803346:	8b 40 04             	mov    0x4(%eax),%eax
  803349:	85 c0                	test   %eax,%eax
  80334b:	74 0d                	je     80335a <insert_sorted_with_merge_freeList+0x572>
  80334d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803350:	8b 40 04             	mov    0x4(%eax),%eax
  803353:	8b 55 08             	mov    0x8(%ebp),%edx
  803356:	89 10                	mov    %edx,(%eax)
  803358:	eb 08                	jmp    803362 <insert_sorted_with_merge_freeList+0x57a>
  80335a:	8b 45 08             	mov    0x8(%ebp),%eax
  80335d:	a3 38 51 80 00       	mov    %eax,0x805138
  803362:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803365:	8b 55 08             	mov    0x8(%ebp),%edx
  803368:	89 50 04             	mov    %edx,0x4(%eax)
  80336b:	a1 44 51 80 00       	mov    0x805144,%eax
  803370:	40                   	inc    %eax
  803371:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803376:	8b 45 08             	mov    0x8(%ebp),%eax
  803379:	8b 50 0c             	mov    0xc(%eax),%edx
  80337c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80337f:	8b 40 0c             	mov    0xc(%eax),%eax
  803382:	01 c2                	add    %eax,%edx
  803384:	8b 45 08             	mov    0x8(%ebp),%eax
  803387:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80338a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80338e:	75 17                	jne    8033a7 <insert_sorted_with_merge_freeList+0x5bf>
  803390:	83 ec 04             	sub    $0x4,%esp
  803393:	68 c4 40 80 00       	push   $0x8040c4
  803398:	68 6b 01 00 00       	push   $0x16b
  80339d:	68 1b 40 80 00       	push   $0x80401b
  8033a2:	e8 8d 01 00 00       	call   803534 <_panic>
  8033a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033aa:	8b 00                	mov    (%eax),%eax
  8033ac:	85 c0                	test   %eax,%eax
  8033ae:	74 10                	je     8033c0 <insert_sorted_with_merge_freeList+0x5d8>
  8033b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b3:	8b 00                	mov    (%eax),%eax
  8033b5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033b8:	8b 52 04             	mov    0x4(%edx),%edx
  8033bb:	89 50 04             	mov    %edx,0x4(%eax)
  8033be:	eb 0b                	jmp    8033cb <insert_sorted_with_merge_freeList+0x5e3>
  8033c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033c3:	8b 40 04             	mov    0x4(%eax),%eax
  8033c6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ce:	8b 40 04             	mov    0x4(%eax),%eax
  8033d1:	85 c0                	test   %eax,%eax
  8033d3:	74 0f                	je     8033e4 <insert_sorted_with_merge_freeList+0x5fc>
  8033d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033d8:	8b 40 04             	mov    0x4(%eax),%eax
  8033db:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033de:	8b 12                	mov    (%edx),%edx
  8033e0:	89 10                	mov    %edx,(%eax)
  8033e2:	eb 0a                	jmp    8033ee <insert_sorted_with_merge_freeList+0x606>
  8033e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e7:	8b 00                	mov    (%eax),%eax
  8033e9:	a3 38 51 80 00       	mov    %eax,0x805138
  8033ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803401:	a1 44 51 80 00       	mov    0x805144,%eax
  803406:	48                   	dec    %eax
  803407:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  80340c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80340f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803416:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803419:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803420:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803424:	75 17                	jne    80343d <insert_sorted_with_merge_freeList+0x655>
  803426:	83 ec 04             	sub    $0x4,%esp
  803429:	68 f8 3f 80 00       	push   $0x803ff8
  80342e:	68 6e 01 00 00       	push   $0x16e
  803433:	68 1b 40 80 00       	push   $0x80401b
  803438:	e8 f7 00 00 00       	call   803534 <_panic>
  80343d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803443:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803446:	89 10                	mov    %edx,(%eax)
  803448:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80344b:	8b 00                	mov    (%eax),%eax
  80344d:	85 c0                	test   %eax,%eax
  80344f:	74 0d                	je     80345e <insert_sorted_with_merge_freeList+0x676>
  803451:	a1 48 51 80 00       	mov    0x805148,%eax
  803456:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803459:	89 50 04             	mov    %edx,0x4(%eax)
  80345c:	eb 08                	jmp    803466 <insert_sorted_with_merge_freeList+0x67e>
  80345e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803461:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803466:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803469:	a3 48 51 80 00       	mov    %eax,0x805148
  80346e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803471:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803478:	a1 54 51 80 00       	mov    0x805154,%eax
  80347d:	40                   	inc    %eax
  80347e:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803483:	e9 a9 00 00 00       	jmp    803531 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803488:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80348c:	74 06                	je     803494 <insert_sorted_with_merge_freeList+0x6ac>
  80348e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803492:	75 17                	jne    8034ab <insert_sorted_with_merge_freeList+0x6c3>
  803494:	83 ec 04             	sub    $0x4,%esp
  803497:	68 90 40 80 00       	push   $0x804090
  80349c:	68 73 01 00 00       	push   $0x173
  8034a1:	68 1b 40 80 00       	push   $0x80401b
  8034a6:	e8 89 00 00 00       	call   803534 <_panic>
  8034ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ae:	8b 10                	mov    (%eax),%edx
  8034b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b3:	89 10                	mov    %edx,(%eax)
  8034b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b8:	8b 00                	mov    (%eax),%eax
  8034ba:	85 c0                	test   %eax,%eax
  8034bc:	74 0b                	je     8034c9 <insert_sorted_with_merge_freeList+0x6e1>
  8034be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c1:	8b 00                	mov    (%eax),%eax
  8034c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8034c6:	89 50 04             	mov    %edx,0x4(%eax)
  8034c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8034cf:	89 10                	mov    %edx,(%eax)
  8034d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034d7:	89 50 04             	mov    %edx,0x4(%eax)
  8034da:	8b 45 08             	mov    0x8(%ebp),%eax
  8034dd:	8b 00                	mov    (%eax),%eax
  8034df:	85 c0                	test   %eax,%eax
  8034e1:	75 08                	jne    8034eb <insert_sorted_with_merge_freeList+0x703>
  8034e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034eb:	a1 44 51 80 00       	mov    0x805144,%eax
  8034f0:	40                   	inc    %eax
  8034f1:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8034f6:	eb 39                	jmp    803531 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8034f8:	a1 40 51 80 00       	mov    0x805140,%eax
  8034fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803500:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803504:	74 07                	je     80350d <insert_sorted_with_merge_freeList+0x725>
  803506:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803509:	8b 00                	mov    (%eax),%eax
  80350b:	eb 05                	jmp    803512 <insert_sorted_with_merge_freeList+0x72a>
  80350d:	b8 00 00 00 00       	mov    $0x0,%eax
  803512:	a3 40 51 80 00       	mov    %eax,0x805140
  803517:	a1 40 51 80 00       	mov    0x805140,%eax
  80351c:	85 c0                	test   %eax,%eax
  80351e:	0f 85 c7 fb ff ff    	jne    8030eb <insert_sorted_with_merge_freeList+0x303>
  803524:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803528:	0f 85 bd fb ff ff    	jne    8030eb <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80352e:	eb 01                	jmp    803531 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803530:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803531:	90                   	nop
  803532:	c9                   	leave  
  803533:	c3                   	ret    

00803534 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803534:	55                   	push   %ebp
  803535:	89 e5                	mov    %esp,%ebp
  803537:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80353a:	8d 45 10             	lea    0x10(%ebp),%eax
  80353d:	83 c0 04             	add    $0x4,%eax
  803540:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803543:	a1 5c 51 80 00       	mov    0x80515c,%eax
  803548:	85 c0                	test   %eax,%eax
  80354a:	74 16                	je     803562 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80354c:	a1 5c 51 80 00       	mov    0x80515c,%eax
  803551:	83 ec 08             	sub    $0x8,%esp
  803554:	50                   	push   %eax
  803555:	68 e4 40 80 00       	push   $0x8040e4
  80355a:	e8 24 d1 ff ff       	call   800683 <cprintf>
  80355f:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803562:	a1 00 50 80 00       	mov    0x805000,%eax
  803567:	ff 75 0c             	pushl  0xc(%ebp)
  80356a:	ff 75 08             	pushl  0x8(%ebp)
  80356d:	50                   	push   %eax
  80356e:	68 e9 40 80 00       	push   $0x8040e9
  803573:	e8 0b d1 ff ff       	call   800683 <cprintf>
  803578:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80357b:	8b 45 10             	mov    0x10(%ebp),%eax
  80357e:	83 ec 08             	sub    $0x8,%esp
  803581:	ff 75 f4             	pushl  -0xc(%ebp)
  803584:	50                   	push   %eax
  803585:	e8 8e d0 ff ff       	call   800618 <vcprintf>
  80358a:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80358d:	83 ec 08             	sub    $0x8,%esp
  803590:	6a 00                	push   $0x0
  803592:	68 05 41 80 00       	push   $0x804105
  803597:	e8 7c d0 ff ff       	call   800618 <vcprintf>
  80359c:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80359f:	e8 fd cf ff ff       	call   8005a1 <exit>

	// should not return here
	while (1) ;
  8035a4:	eb fe                	jmp    8035a4 <_panic+0x70>

008035a6 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8035a6:	55                   	push   %ebp
  8035a7:	89 e5                	mov    %esp,%ebp
  8035a9:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8035ac:	a1 20 50 80 00       	mov    0x805020,%eax
  8035b1:	8b 50 74             	mov    0x74(%eax),%edx
  8035b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035b7:	39 c2                	cmp    %eax,%edx
  8035b9:	74 14                	je     8035cf <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8035bb:	83 ec 04             	sub    $0x4,%esp
  8035be:	68 08 41 80 00       	push   $0x804108
  8035c3:	6a 26                	push   $0x26
  8035c5:	68 54 41 80 00       	push   $0x804154
  8035ca:	e8 65 ff ff ff       	call   803534 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8035cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8035d6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8035dd:	e9 c2 00 00 00       	jmp    8036a4 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8035e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035e5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8035ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ef:	01 d0                	add    %edx,%eax
  8035f1:	8b 00                	mov    (%eax),%eax
  8035f3:	85 c0                	test   %eax,%eax
  8035f5:	75 08                	jne    8035ff <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8035f7:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8035fa:	e9 a2 00 00 00       	jmp    8036a1 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8035ff:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803606:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80360d:	eb 69                	jmp    803678 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80360f:	a1 20 50 80 00       	mov    0x805020,%eax
  803614:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80361a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80361d:	89 d0                	mov    %edx,%eax
  80361f:	01 c0                	add    %eax,%eax
  803621:	01 d0                	add    %edx,%eax
  803623:	c1 e0 03             	shl    $0x3,%eax
  803626:	01 c8                	add    %ecx,%eax
  803628:	8a 40 04             	mov    0x4(%eax),%al
  80362b:	84 c0                	test   %al,%al
  80362d:	75 46                	jne    803675 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80362f:	a1 20 50 80 00       	mov    0x805020,%eax
  803634:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80363a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80363d:	89 d0                	mov    %edx,%eax
  80363f:	01 c0                	add    %eax,%eax
  803641:	01 d0                	add    %edx,%eax
  803643:	c1 e0 03             	shl    $0x3,%eax
  803646:	01 c8                	add    %ecx,%eax
  803648:	8b 00                	mov    (%eax),%eax
  80364a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80364d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803650:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803655:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803657:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80365a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803661:	8b 45 08             	mov    0x8(%ebp),%eax
  803664:	01 c8                	add    %ecx,%eax
  803666:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803668:	39 c2                	cmp    %eax,%edx
  80366a:	75 09                	jne    803675 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80366c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803673:	eb 12                	jmp    803687 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803675:	ff 45 e8             	incl   -0x18(%ebp)
  803678:	a1 20 50 80 00       	mov    0x805020,%eax
  80367d:	8b 50 74             	mov    0x74(%eax),%edx
  803680:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803683:	39 c2                	cmp    %eax,%edx
  803685:	77 88                	ja     80360f <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803687:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80368b:	75 14                	jne    8036a1 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80368d:	83 ec 04             	sub    $0x4,%esp
  803690:	68 60 41 80 00       	push   $0x804160
  803695:	6a 3a                	push   $0x3a
  803697:	68 54 41 80 00       	push   $0x804154
  80369c:	e8 93 fe ff ff       	call   803534 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8036a1:	ff 45 f0             	incl   -0x10(%ebp)
  8036a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036a7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8036aa:	0f 8c 32 ff ff ff    	jl     8035e2 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8036b0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8036b7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8036be:	eb 26                	jmp    8036e6 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8036c0:	a1 20 50 80 00       	mov    0x805020,%eax
  8036c5:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8036cb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8036ce:	89 d0                	mov    %edx,%eax
  8036d0:	01 c0                	add    %eax,%eax
  8036d2:	01 d0                	add    %edx,%eax
  8036d4:	c1 e0 03             	shl    $0x3,%eax
  8036d7:	01 c8                	add    %ecx,%eax
  8036d9:	8a 40 04             	mov    0x4(%eax),%al
  8036dc:	3c 01                	cmp    $0x1,%al
  8036de:	75 03                	jne    8036e3 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8036e0:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8036e3:	ff 45 e0             	incl   -0x20(%ebp)
  8036e6:	a1 20 50 80 00       	mov    0x805020,%eax
  8036eb:	8b 50 74             	mov    0x74(%eax),%edx
  8036ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036f1:	39 c2                	cmp    %eax,%edx
  8036f3:	77 cb                	ja     8036c0 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8036f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f8:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8036fb:	74 14                	je     803711 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8036fd:	83 ec 04             	sub    $0x4,%esp
  803700:	68 b4 41 80 00       	push   $0x8041b4
  803705:	6a 44                	push   $0x44
  803707:	68 54 41 80 00       	push   $0x804154
  80370c:	e8 23 fe ff ff       	call   803534 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803711:	90                   	nop
  803712:	c9                   	leave  
  803713:	c3                   	ret    

00803714 <__udivdi3>:
  803714:	55                   	push   %ebp
  803715:	57                   	push   %edi
  803716:	56                   	push   %esi
  803717:	53                   	push   %ebx
  803718:	83 ec 1c             	sub    $0x1c,%esp
  80371b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80371f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803723:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803727:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80372b:	89 ca                	mov    %ecx,%edx
  80372d:	89 f8                	mov    %edi,%eax
  80372f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803733:	85 f6                	test   %esi,%esi
  803735:	75 2d                	jne    803764 <__udivdi3+0x50>
  803737:	39 cf                	cmp    %ecx,%edi
  803739:	77 65                	ja     8037a0 <__udivdi3+0x8c>
  80373b:	89 fd                	mov    %edi,%ebp
  80373d:	85 ff                	test   %edi,%edi
  80373f:	75 0b                	jne    80374c <__udivdi3+0x38>
  803741:	b8 01 00 00 00       	mov    $0x1,%eax
  803746:	31 d2                	xor    %edx,%edx
  803748:	f7 f7                	div    %edi
  80374a:	89 c5                	mov    %eax,%ebp
  80374c:	31 d2                	xor    %edx,%edx
  80374e:	89 c8                	mov    %ecx,%eax
  803750:	f7 f5                	div    %ebp
  803752:	89 c1                	mov    %eax,%ecx
  803754:	89 d8                	mov    %ebx,%eax
  803756:	f7 f5                	div    %ebp
  803758:	89 cf                	mov    %ecx,%edi
  80375a:	89 fa                	mov    %edi,%edx
  80375c:	83 c4 1c             	add    $0x1c,%esp
  80375f:	5b                   	pop    %ebx
  803760:	5e                   	pop    %esi
  803761:	5f                   	pop    %edi
  803762:	5d                   	pop    %ebp
  803763:	c3                   	ret    
  803764:	39 ce                	cmp    %ecx,%esi
  803766:	77 28                	ja     803790 <__udivdi3+0x7c>
  803768:	0f bd fe             	bsr    %esi,%edi
  80376b:	83 f7 1f             	xor    $0x1f,%edi
  80376e:	75 40                	jne    8037b0 <__udivdi3+0x9c>
  803770:	39 ce                	cmp    %ecx,%esi
  803772:	72 0a                	jb     80377e <__udivdi3+0x6a>
  803774:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803778:	0f 87 9e 00 00 00    	ja     80381c <__udivdi3+0x108>
  80377e:	b8 01 00 00 00       	mov    $0x1,%eax
  803783:	89 fa                	mov    %edi,%edx
  803785:	83 c4 1c             	add    $0x1c,%esp
  803788:	5b                   	pop    %ebx
  803789:	5e                   	pop    %esi
  80378a:	5f                   	pop    %edi
  80378b:	5d                   	pop    %ebp
  80378c:	c3                   	ret    
  80378d:	8d 76 00             	lea    0x0(%esi),%esi
  803790:	31 ff                	xor    %edi,%edi
  803792:	31 c0                	xor    %eax,%eax
  803794:	89 fa                	mov    %edi,%edx
  803796:	83 c4 1c             	add    $0x1c,%esp
  803799:	5b                   	pop    %ebx
  80379a:	5e                   	pop    %esi
  80379b:	5f                   	pop    %edi
  80379c:	5d                   	pop    %ebp
  80379d:	c3                   	ret    
  80379e:	66 90                	xchg   %ax,%ax
  8037a0:	89 d8                	mov    %ebx,%eax
  8037a2:	f7 f7                	div    %edi
  8037a4:	31 ff                	xor    %edi,%edi
  8037a6:	89 fa                	mov    %edi,%edx
  8037a8:	83 c4 1c             	add    $0x1c,%esp
  8037ab:	5b                   	pop    %ebx
  8037ac:	5e                   	pop    %esi
  8037ad:	5f                   	pop    %edi
  8037ae:	5d                   	pop    %ebp
  8037af:	c3                   	ret    
  8037b0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8037b5:	89 eb                	mov    %ebp,%ebx
  8037b7:	29 fb                	sub    %edi,%ebx
  8037b9:	89 f9                	mov    %edi,%ecx
  8037bb:	d3 e6                	shl    %cl,%esi
  8037bd:	89 c5                	mov    %eax,%ebp
  8037bf:	88 d9                	mov    %bl,%cl
  8037c1:	d3 ed                	shr    %cl,%ebp
  8037c3:	89 e9                	mov    %ebp,%ecx
  8037c5:	09 f1                	or     %esi,%ecx
  8037c7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8037cb:	89 f9                	mov    %edi,%ecx
  8037cd:	d3 e0                	shl    %cl,%eax
  8037cf:	89 c5                	mov    %eax,%ebp
  8037d1:	89 d6                	mov    %edx,%esi
  8037d3:	88 d9                	mov    %bl,%cl
  8037d5:	d3 ee                	shr    %cl,%esi
  8037d7:	89 f9                	mov    %edi,%ecx
  8037d9:	d3 e2                	shl    %cl,%edx
  8037db:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037df:	88 d9                	mov    %bl,%cl
  8037e1:	d3 e8                	shr    %cl,%eax
  8037e3:	09 c2                	or     %eax,%edx
  8037e5:	89 d0                	mov    %edx,%eax
  8037e7:	89 f2                	mov    %esi,%edx
  8037e9:	f7 74 24 0c          	divl   0xc(%esp)
  8037ed:	89 d6                	mov    %edx,%esi
  8037ef:	89 c3                	mov    %eax,%ebx
  8037f1:	f7 e5                	mul    %ebp
  8037f3:	39 d6                	cmp    %edx,%esi
  8037f5:	72 19                	jb     803810 <__udivdi3+0xfc>
  8037f7:	74 0b                	je     803804 <__udivdi3+0xf0>
  8037f9:	89 d8                	mov    %ebx,%eax
  8037fb:	31 ff                	xor    %edi,%edi
  8037fd:	e9 58 ff ff ff       	jmp    80375a <__udivdi3+0x46>
  803802:	66 90                	xchg   %ax,%ax
  803804:	8b 54 24 08          	mov    0x8(%esp),%edx
  803808:	89 f9                	mov    %edi,%ecx
  80380a:	d3 e2                	shl    %cl,%edx
  80380c:	39 c2                	cmp    %eax,%edx
  80380e:	73 e9                	jae    8037f9 <__udivdi3+0xe5>
  803810:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803813:	31 ff                	xor    %edi,%edi
  803815:	e9 40 ff ff ff       	jmp    80375a <__udivdi3+0x46>
  80381a:	66 90                	xchg   %ax,%ax
  80381c:	31 c0                	xor    %eax,%eax
  80381e:	e9 37 ff ff ff       	jmp    80375a <__udivdi3+0x46>
  803823:	90                   	nop

00803824 <__umoddi3>:
  803824:	55                   	push   %ebp
  803825:	57                   	push   %edi
  803826:	56                   	push   %esi
  803827:	53                   	push   %ebx
  803828:	83 ec 1c             	sub    $0x1c,%esp
  80382b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80382f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803833:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803837:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80383b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80383f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803843:	89 f3                	mov    %esi,%ebx
  803845:	89 fa                	mov    %edi,%edx
  803847:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80384b:	89 34 24             	mov    %esi,(%esp)
  80384e:	85 c0                	test   %eax,%eax
  803850:	75 1a                	jne    80386c <__umoddi3+0x48>
  803852:	39 f7                	cmp    %esi,%edi
  803854:	0f 86 a2 00 00 00    	jbe    8038fc <__umoddi3+0xd8>
  80385a:	89 c8                	mov    %ecx,%eax
  80385c:	89 f2                	mov    %esi,%edx
  80385e:	f7 f7                	div    %edi
  803860:	89 d0                	mov    %edx,%eax
  803862:	31 d2                	xor    %edx,%edx
  803864:	83 c4 1c             	add    $0x1c,%esp
  803867:	5b                   	pop    %ebx
  803868:	5e                   	pop    %esi
  803869:	5f                   	pop    %edi
  80386a:	5d                   	pop    %ebp
  80386b:	c3                   	ret    
  80386c:	39 f0                	cmp    %esi,%eax
  80386e:	0f 87 ac 00 00 00    	ja     803920 <__umoddi3+0xfc>
  803874:	0f bd e8             	bsr    %eax,%ebp
  803877:	83 f5 1f             	xor    $0x1f,%ebp
  80387a:	0f 84 ac 00 00 00    	je     80392c <__umoddi3+0x108>
  803880:	bf 20 00 00 00       	mov    $0x20,%edi
  803885:	29 ef                	sub    %ebp,%edi
  803887:	89 fe                	mov    %edi,%esi
  803889:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80388d:	89 e9                	mov    %ebp,%ecx
  80388f:	d3 e0                	shl    %cl,%eax
  803891:	89 d7                	mov    %edx,%edi
  803893:	89 f1                	mov    %esi,%ecx
  803895:	d3 ef                	shr    %cl,%edi
  803897:	09 c7                	or     %eax,%edi
  803899:	89 e9                	mov    %ebp,%ecx
  80389b:	d3 e2                	shl    %cl,%edx
  80389d:	89 14 24             	mov    %edx,(%esp)
  8038a0:	89 d8                	mov    %ebx,%eax
  8038a2:	d3 e0                	shl    %cl,%eax
  8038a4:	89 c2                	mov    %eax,%edx
  8038a6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038aa:	d3 e0                	shl    %cl,%eax
  8038ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8038b0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038b4:	89 f1                	mov    %esi,%ecx
  8038b6:	d3 e8                	shr    %cl,%eax
  8038b8:	09 d0                	or     %edx,%eax
  8038ba:	d3 eb                	shr    %cl,%ebx
  8038bc:	89 da                	mov    %ebx,%edx
  8038be:	f7 f7                	div    %edi
  8038c0:	89 d3                	mov    %edx,%ebx
  8038c2:	f7 24 24             	mull   (%esp)
  8038c5:	89 c6                	mov    %eax,%esi
  8038c7:	89 d1                	mov    %edx,%ecx
  8038c9:	39 d3                	cmp    %edx,%ebx
  8038cb:	0f 82 87 00 00 00    	jb     803958 <__umoddi3+0x134>
  8038d1:	0f 84 91 00 00 00    	je     803968 <__umoddi3+0x144>
  8038d7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8038db:	29 f2                	sub    %esi,%edx
  8038dd:	19 cb                	sbb    %ecx,%ebx
  8038df:	89 d8                	mov    %ebx,%eax
  8038e1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8038e5:	d3 e0                	shl    %cl,%eax
  8038e7:	89 e9                	mov    %ebp,%ecx
  8038e9:	d3 ea                	shr    %cl,%edx
  8038eb:	09 d0                	or     %edx,%eax
  8038ed:	89 e9                	mov    %ebp,%ecx
  8038ef:	d3 eb                	shr    %cl,%ebx
  8038f1:	89 da                	mov    %ebx,%edx
  8038f3:	83 c4 1c             	add    $0x1c,%esp
  8038f6:	5b                   	pop    %ebx
  8038f7:	5e                   	pop    %esi
  8038f8:	5f                   	pop    %edi
  8038f9:	5d                   	pop    %ebp
  8038fa:	c3                   	ret    
  8038fb:	90                   	nop
  8038fc:	89 fd                	mov    %edi,%ebp
  8038fe:	85 ff                	test   %edi,%edi
  803900:	75 0b                	jne    80390d <__umoddi3+0xe9>
  803902:	b8 01 00 00 00       	mov    $0x1,%eax
  803907:	31 d2                	xor    %edx,%edx
  803909:	f7 f7                	div    %edi
  80390b:	89 c5                	mov    %eax,%ebp
  80390d:	89 f0                	mov    %esi,%eax
  80390f:	31 d2                	xor    %edx,%edx
  803911:	f7 f5                	div    %ebp
  803913:	89 c8                	mov    %ecx,%eax
  803915:	f7 f5                	div    %ebp
  803917:	89 d0                	mov    %edx,%eax
  803919:	e9 44 ff ff ff       	jmp    803862 <__umoddi3+0x3e>
  80391e:	66 90                	xchg   %ax,%ax
  803920:	89 c8                	mov    %ecx,%eax
  803922:	89 f2                	mov    %esi,%edx
  803924:	83 c4 1c             	add    $0x1c,%esp
  803927:	5b                   	pop    %ebx
  803928:	5e                   	pop    %esi
  803929:	5f                   	pop    %edi
  80392a:	5d                   	pop    %ebp
  80392b:	c3                   	ret    
  80392c:	3b 04 24             	cmp    (%esp),%eax
  80392f:	72 06                	jb     803937 <__umoddi3+0x113>
  803931:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803935:	77 0f                	ja     803946 <__umoddi3+0x122>
  803937:	89 f2                	mov    %esi,%edx
  803939:	29 f9                	sub    %edi,%ecx
  80393b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80393f:	89 14 24             	mov    %edx,(%esp)
  803942:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803946:	8b 44 24 04          	mov    0x4(%esp),%eax
  80394a:	8b 14 24             	mov    (%esp),%edx
  80394d:	83 c4 1c             	add    $0x1c,%esp
  803950:	5b                   	pop    %ebx
  803951:	5e                   	pop    %esi
  803952:	5f                   	pop    %edi
  803953:	5d                   	pop    %ebp
  803954:	c3                   	ret    
  803955:	8d 76 00             	lea    0x0(%esi),%esi
  803958:	2b 04 24             	sub    (%esp),%eax
  80395b:	19 fa                	sbb    %edi,%edx
  80395d:	89 d1                	mov    %edx,%ecx
  80395f:	89 c6                	mov    %eax,%esi
  803961:	e9 71 ff ff ff       	jmp    8038d7 <__umoddi3+0xb3>
  803966:	66 90                	xchg   %ax,%ax
  803968:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80396c:	72 ea                	jb     803958 <__umoddi3+0x134>
  80396e:	89 d9                	mov    %ebx,%ecx
  803970:	e9 62 ff ff ff       	jmp    8038d7 <__umoddi3+0xb3>
