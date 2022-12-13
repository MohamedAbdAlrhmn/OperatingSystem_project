
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
  80003e:	e8 96 1b 00 00       	call   801bd9 <sys_getparentenvid>
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
  800057:	68 00 39 80 00       	push   $0x803900
  80005c:	ff 75 f0             	pushl  -0x10(%ebp)
  80005f:	e8 d8 16 00 00       	call   80173c <sget>
  800064:	83 c4 10             	add    $0x10,%esp
  800067:	89 45 e8             	mov    %eax,-0x18(%ebp)
	numOfElements = sget(parentenvID, "arrSize") ;
  80006a:	83 ec 08             	sub    $0x8,%esp
  80006d:	68 04 39 80 00       	push   $0x803904
  800072:	ff 75 f0             	pushl  -0x10(%ebp)
  800075:	e8 c2 16 00 00       	call   80173c <sget>
  80007a:	83 c4 10             	add    $0x10,%esp
  80007d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//PrintElements(sharedArray, *numOfElements);

	//Get the check-finishing counter
	int *finishedCount = NULL;
  800080:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	finishedCount = sget(parentenvID, "finishedCount") ;
  800087:	83 ec 08             	sub    $0x8,%esp
  80008a:	68 0c 39 80 00       	push   $0x80390c
  80008f:	ff 75 f0             	pushl  -0x10(%ebp)
  800092:	e8 a5 16 00 00       	call   80173c <sget>
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
  8000ab:	68 1a 39 80 00       	push   $0x80391a
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
  80010c:	68 29 39 80 00       	push   $0x803929
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
  8001a2:	68 45 39 80 00       	push   $0x803945
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
  8001c4:	68 47 39 80 00       	push   $0x803947
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
  8001f2:	68 4c 39 80 00       	push   $0x80394c
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
  800479:	e8 42 17 00 00       	call   801bc0 <sys_getenvindex>
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
  8004e4:	e8 e4 14 00 00       	call   8019cd <sys_disable_interrupt>
	cprintf("**************************************\n");
  8004e9:	83 ec 0c             	sub    $0xc,%esp
  8004ec:	68 68 39 80 00       	push   $0x803968
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
  800514:	68 90 39 80 00       	push   $0x803990
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
  800545:	68 b8 39 80 00       	push   $0x8039b8
  80054a:	e8 34 01 00 00       	call   800683 <cprintf>
  80054f:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800552:	a1 20 50 80 00       	mov    0x805020,%eax
  800557:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80055d:	83 ec 08             	sub    $0x8,%esp
  800560:	50                   	push   %eax
  800561:	68 10 3a 80 00       	push   $0x803a10
  800566:	e8 18 01 00 00       	call   800683 <cprintf>
  80056b:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80056e:	83 ec 0c             	sub    $0xc,%esp
  800571:	68 68 39 80 00       	push   $0x803968
  800576:	e8 08 01 00 00       	call   800683 <cprintf>
  80057b:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80057e:	e8 64 14 00 00       	call   8019e7 <sys_enable_interrupt>

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
  800596:	e8 f1 15 00 00       	call   801b8c <sys_destroy_env>
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
  8005a7:	e8 46 16 00 00       	call   801bf2 <sys_exit_env>
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
  8005f5:	e8 25 12 00 00       	call   80181f <sys_cputs>
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
  80066c:	e8 ae 11 00 00       	call   80181f <sys_cputs>
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
  8006b6:	e8 12 13 00 00       	call   8019cd <sys_disable_interrupt>
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
  8006d6:	e8 0c 13 00 00       	call   8019e7 <sys_enable_interrupt>
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
  800720:	e8 5f 2f 00 00       	call   803684 <__udivdi3>
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
  800770:	e8 1f 30 00 00       	call   803794 <__umoddi3>
  800775:	83 c4 10             	add    $0x10,%esp
  800778:	05 54 3c 80 00       	add    $0x803c54,%eax
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
  8008cb:	8b 04 85 78 3c 80 00 	mov    0x803c78(,%eax,4),%eax
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
  8009ac:	8b 34 9d c0 3a 80 00 	mov    0x803ac0(,%ebx,4),%esi
  8009b3:	85 f6                	test   %esi,%esi
  8009b5:	75 19                	jne    8009d0 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009b7:	53                   	push   %ebx
  8009b8:	68 65 3c 80 00       	push   $0x803c65
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
  8009d1:	68 6e 3c 80 00       	push   $0x803c6e
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
  8009fe:	be 71 3c 80 00       	mov    $0x803c71,%esi
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
  801424:	68 d0 3d 80 00       	push   $0x803dd0
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
  8014f4:	e8 6a 04 00 00       	call   801963 <sys_allocate_chunk>
  8014f9:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8014fc:	a1 20 51 80 00       	mov    0x805120,%eax
  801501:	83 ec 0c             	sub    $0xc,%esp
  801504:	50                   	push   %eax
  801505:	e8 df 0a 00 00       	call   801fe9 <initialize_MemBlocksList>
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
  801532:	68 f5 3d 80 00       	push   $0x803df5
  801537:	6a 33                	push   $0x33
  801539:	68 13 3e 80 00       	push   $0x803e13
  80153e:	e8 5f 1f 00 00       	call   8034a2 <_panic>
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
  8015b1:	68 20 3e 80 00       	push   $0x803e20
  8015b6:	6a 34                	push   $0x34
  8015b8:	68 13 3e 80 00       	push   $0x803e13
  8015bd:	e8 e0 1e 00 00       	call   8034a2 <_panic>
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
  801649:	e8 e3 06 00 00       	call   801d31 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80164e:	85 c0                	test   %eax,%eax
  801650:	74 11                	je     801663 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801652:	83 ec 0c             	sub    $0xc,%esp
  801655:	ff 75 e8             	pushl  -0x18(%ebp)
  801658:	e8 4e 0d 00 00       	call   8023ab <alloc_block_FF>
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
  80166f:	e8 aa 0a 00 00       	call   80211e <insert_sorted_allocList>
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
  80168f:	68 44 3e 80 00       	push   $0x803e44
  801694:	6a 6f                	push   $0x6f
  801696:	68 13 3e 80 00       	push   $0x803e13
  80169b:	e8 02 1e 00 00       	call   8034a2 <_panic>

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
  8016b5:	75 07                	jne    8016be <smalloc+0x1e>
  8016b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8016bc:	eb 7c                	jmp    80173a <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8016be:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8016c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016cb:	01 d0                	add    %edx,%eax
  8016cd:	48                   	dec    %eax
  8016ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8016d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8016d9:	f7 75 f0             	divl   -0x10(%ebp)
  8016dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016df:	29 d0                	sub    %edx,%eax
  8016e1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8016e4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8016eb:	e8 41 06 00 00       	call   801d31 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016f0:	85 c0                	test   %eax,%eax
  8016f2:	74 11                	je     801705 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  8016f4:	83 ec 0c             	sub    $0xc,%esp
  8016f7:	ff 75 e8             	pushl  -0x18(%ebp)
  8016fa:	e8 ac 0c 00 00       	call   8023ab <alloc_block_FF>
  8016ff:	83 c4 10             	add    $0x10,%esp
  801702:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801705:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801709:	74 2a                	je     801735 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  80170b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80170e:	8b 40 08             	mov    0x8(%eax),%eax
  801711:	89 c2                	mov    %eax,%edx
  801713:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801717:	52                   	push   %edx
  801718:	50                   	push   %eax
  801719:	ff 75 0c             	pushl  0xc(%ebp)
  80171c:	ff 75 08             	pushl  0x8(%ebp)
  80171f:	e8 92 03 00 00       	call   801ab6 <sys_createSharedObject>
  801724:	83 c4 10             	add    $0x10,%esp
  801727:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  80172a:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  80172e:	74 05                	je     801735 <smalloc+0x95>
			return (void*)virtual_address;
  801730:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801733:	eb 05                	jmp    80173a <smalloc+0x9a>
	}
	return NULL;
  801735:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80173a:	c9                   	leave  
  80173b:	c3                   	ret    

0080173c <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80173c:	55                   	push   %ebp
  80173d:	89 e5                	mov    %esp,%ebp
  80173f:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801742:	e8 c6 fc ff ff       	call   80140d <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801747:	83 ec 04             	sub    $0x4,%esp
  80174a:	68 68 3e 80 00       	push   $0x803e68
  80174f:	68 b0 00 00 00       	push   $0xb0
  801754:	68 13 3e 80 00       	push   $0x803e13
  801759:	e8 44 1d 00 00       	call   8034a2 <_panic>

0080175e <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80175e:	55                   	push   %ebp
  80175f:	89 e5                	mov    %esp,%ebp
  801761:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801764:	e8 a4 fc ff ff       	call   80140d <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801769:	83 ec 04             	sub    $0x4,%esp
  80176c:	68 8c 3e 80 00       	push   $0x803e8c
  801771:	68 f4 00 00 00       	push   $0xf4
  801776:	68 13 3e 80 00       	push   $0x803e13
  80177b:	e8 22 1d 00 00       	call   8034a2 <_panic>

00801780 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801780:	55                   	push   %ebp
  801781:	89 e5                	mov    %esp,%ebp
  801783:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801786:	83 ec 04             	sub    $0x4,%esp
  801789:	68 b4 3e 80 00       	push   $0x803eb4
  80178e:	68 08 01 00 00       	push   $0x108
  801793:	68 13 3e 80 00       	push   $0x803e13
  801798:	e8 05 1d 00 00       	call   8034a2 <_panic>

0080179d <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80179d:	55                   	push   %ebp
  80179e:	89 e5                	mov    %esp,%ebp
  8017a0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017a3:	83 ec 04             	sub    $0x4,%esp
  8017a6:	68 d8 3e 80 00       	push   $0x803ed8
  8017ab:	68 13 01 00 00       	push   $0x113
  8017b0:	68 13 3e 80 00       	push   $0x803e13
  8017b5:	e8 e8 1c 00 00       	call   8034a2 <_panic>

008017ba <shrink>:

}
void shrink(uint32 newSize)
{
  8017ba:	55                   	push   %ebp
  8017bb:	89 e5                	mov    %esp,%ebp
  8017bd:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017c0:	83 ec 04             	sub    $0x4,%esp
  8017c3:	68 d8 3e 80 00       	push   $0x803ed8
  8017c8:	68 18 01 00 00       	push   $0x118
  8017cd:	68 13 3e 80 00       	push   $0x803e13
  8017d2:	e8 cb 1c 00 00       	call   8034a2 <_panic>

008017d7 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017d7:	55                   	push   %ebp
  8017d8:	89 e5                	mov    %esp,%ebp
  8017da:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017dd:	83 ec 04             	sub    $0x4,%esp
  8017e0:	68 d8 3e 80 00       	push   $0x803ed8
  8017e5:	68 1d 01 00 00       	push   $0x11d
  8017ea:	68 13 3e 80 00       	push   $0x803e13
  8017ef:	e8 ae 1c 00 00       	call   8034a2 <_panic>

008017f4 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017f4:	55                   	push   %ebp
  8017f5:	89 e5                	mov    %esp,%ebp
  8017f7:	57                   	push   %edi
  8017f8:	56                   	push   %esi
  8017f9:	53                   	push   %ebx
  8017fa:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801800:	8b 55 0c             	mov    0xc(%ebp),%edx
  801803:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801806:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801809:	8b 7d 18             	mov    0x18(%ebp),%edi
  80180c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80180f:	cd 30                	int    $0x30
  801811:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801814:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801817:	83 c4 10             	add    $0x10,%esp
  80181a:	5b                   	pop    %ebx
  80181b:	5e                   	pop    %esi
  80181c:	5f                   	pop    %edi
  80181d:	5d                   	pop    %ebp
  80181e:	c3                   	ret    

0080181f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80181f:	55                   	push   %ebp
  801820:	89 e5                	mov    %esp,%ebp
  801822:	83 ec 04             	sub    $0x4,%esp
  801825:	8b 45 10             	mov    0x10(%ebp),%eax
  801828:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80182b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80182f:	8b 45 08             	mov    0x8(%ebp),%eax
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	52                   	push   %edx
  801837:	ff 75 0c             	pushl  0xc(%ebp)
  80183a:	50                   	push   %eax
  80183b:	6a 00                	push   $0x0
  80183d:	e8 b2 ff ff ff       	call   8017f4 <syscall>
  801842:	83 c4 18             	add    $0x18,%esp
}
  801845:	90                   	nop
  801846:	c9                   	leave  
  801847:	c3                   	ret    

00801848 <sys_cgetc>:

int
sys_cgetc(void)
{
  801848:	55                   	push   %ebp
  801849:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	6a 00                	push   $0x0
  801853:	6a 00                	push   $0x0
  801855:	6a 01                	push   $0x1
  801857:	e8 98 ff ff ff       	call   8017f4 <syscall>
  80185c:	83 c4 18             	add    $0x18,%esp
}
  80185f:	c9                   	leave  
  801860:	c3                   	ret    

00801861 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801861:	55                   	push   %ebp
  801862:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801864:	8b 55 0c             	mov    0xc(%ebp),%edx
  801867:	8b 45 08             	mov    0x8(%ebp),%eax
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	52                   	push   %edx
  801871:	50                   	push   %eax
  801872:	6a 05                	push   $0x5
  801874:	e8 7b ff ff ff       	call   8017f4 <syscall>
  801879:	83 c4 18             	add    $0x18,%esp
}
  80187c:	c9                   	leave  
  80187d:	c3                   	ret    

0080187e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80187e:	55                   	push   %ebp
  80187f:	89 e5                	mov    %esp,%ebp
  801881:	56                   	push   %esi
  801882:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801883:	8b 75 18             	mov    0x18(%ebp),%esi
  801886:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801889:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80188c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80188f:	8b 45 08             	mov    0x8(%ebp),%eax
  801892:	56                   	push   %esi
  801893:	53                   	push   %ebx
  801894:	51                   	push   %ecx
  801895:	52                   	push   %edx
  801896:	50                   	push   %eax
  801897:	6a 06                	push   $0x6
  801899:	e8 56 ff ff ff       	call   8017f4 <syscall>
  80189e:	83 c4 18             	add    $0x18,%esp
}
  8018a1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018a4:	5b                   	pop    %ebx
  8018a5:	5e                   	pop    %esi
  8018a6:	5d                   	pop    %ebp
  8018a7:	c3                   	ret    

008018a8 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018a8:	55                   	push   %ebp
  8018a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 00                	push   $0x0
  8018b7:	52                   	push   %edx
  8018b8:	50                   	push   %eax
  8018b9:	6a 07                	push   $0x7
  8018bb:	e8 34 ff ff ff       	call   8017f4 <syscall>
  8018c0:	83 c4 18             	add    $0x18,%esp
}
  8018c3:	c9                   	leave  
  8018c4:	c3                   	ret    

008018c5 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018c5:	55                   	push   %ebp
  8018c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	ff 75 0c             	pushl  0xc(%ebp)
  8018d1:	ff 75 08             	pushl  0x8(%ebp)
  8018d4:	6a 08                	push   $0x8
  8018d6:	e8 19 ff ff ff       	call   8017f4 <syscall>
  8018db:	83 c4 18             	add    $0x18,%esp
}
  8018de:	c9                   	leave  
  8018df:	c3                   	ret    

008018e0 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 09                	push   $0x9
  8018ef:	e8 00 ff ff ff       	call   8017f4 <syscall>
  8018f4:	83 c4 18             	add    $0x18,%esp
}
  8018f7:	c9                   	leave  
  8018f8:	c3                   	ret    

008018f9 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018f9:	55                   	push   %ebp
  8018fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 0a                	push   $0xa
  801908:	e8 e7 fe ff ff       	call   8017f4 <syscall>
  80190d:	83 c4 18             	add    $0x18,%esp
}
  801910:	c9                   	leave  
  801911:	c3                   	ret    

00801912 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801912:	55                   	push   %ebp
  801913:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	6a 0b                	push   $0xb
  801921:	e8 ce fe ff ff       	call   8017f4 <syscall>
  801926:	83 c4 18             	add    $0x18,%esp
}
  801929:	c9                   	leave  
  80192a:	c3                   	ret    

0080192b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80192b:	55                   	push   %ebp
  80192c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	ff 75 0c             	pushl  0xc(%ebp)
  801937:	ff 75 08             	pushl  0x8(%ebp)
  80193a:	6a 0f                	push   $0xf
  80193c:	e8 b3 fe ff ff       	call   8017f4 <syscall>
  801941:	83 c4 18             	add    $0x18,%esp
	return;
  801944:	90                   	nop
}
  801945:	c9                   	leave  
  801946:	c3                   	ret    

00801947 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80194a:	6a 00                	push   $0x0
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	ff 75 0c             	pushl  0xc(%ebp)
  801953:	ff 75 08             	pushl  0x8(%ebp)
  801956:	6a 10                	push   $0x10
  801958:	e8 97 fe ff ff       	call   8017f4 <syscall>
  80195d:	83 c4 18             	add    $0x18,%esp
	return ;
  801960:	90                   	nop
}
  801961:	c9                   	leave  
  801962:	c3                   	ret    

00801963 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801963:	55                   	push   %ebp
  801964:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	ff 75 10             	pushl  0x10(%ebp)
  80196d:	ff 75 0c             	pushl  0xc(%ebp)
  801970:	ff 75 08             	pushl  0x8(%ebp)
  801973:	6a 11                	push   $0x11
  801975:	e8 7a fe ff ff       	call   8017f4 <syscall>
  80197a:	83 c4 18             	add    $0x18,%esp
	return ;
  80197d:	90                   	nop
}
  80197e:	c9                   	leave  
  80197f:	c3                   	ret    

00801980 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801980:	55                   	push   %ebp
  801981:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	6a 0c                	push   $0xc
  80198f:	e8 60 fe ff ff       	call   8017f4 <syscall>
  801994:	83 c4 18             	add    $0x18,%esp
}
  801997:	c9                   	leave  
  801998:	c3                   	ret    

00801999 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801999:	55                   	push   %ebp
  80199a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80199c:	6a 00                	push   $0x0
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	ff 75 08             	pushl  0x8(%ebp)
  8019a7:	6a 0d                	push   $0xd
  8019a9:	e8 46 fe ff ff       	call   8017f4 <syscall>
  8019ae:	83 c4 18             	add    $0x18,%esp
}
  8019b1:	c9                   	leave  
  8019b2:	c3                   	ret    

008019b3 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019b3:	55                   	push   %ebp
  8019b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 0e                	push   $0xe
  8019c2:	e8 2d fe ff ff       	call   8017f4 <syscall>
  8019c7:	83 c4 18             	add    $0x18,%esp
}
  8019ca:	90                   	nop
  8019cb:	c9                   	leave  
  8019cc:	c3                   	ret    

008019cd <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019cd:	55                   	push   %ebp
  8019ce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 13                	push   $0x13
  8019dc:	e8 13 fe ff ff       	call   8017f4 <syscall>
  8019e1:	83 c4 18             	add    $0x18,%esp
}
  8019e4:	90                   	nop
  8019e5:	c9                   	leave  
  8019e6:	c3                   	ret    

008019e7 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8019e7:	55                   	push   %ebp
  8019e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 14                	push   $0x14
  8019f6:	e8 f9 fd ff ff       	call   8017f4 <syscall>
  8019fb:	83 c4 18             	add    $0x18,%esp
}
  8019fe:	90                   	nop
  8019ff:	c9                   	leave  
  801a00:	c3                   	ret    

00801a01 <sys_cputc>:


void
sys_cputc(const char c)
{
  801a01:	55                   	push   %ebp
  801a02:	89 e5                	mov    %esp,%ebp
  801a04:	83 ec 04             	sub    $0x4,%esp
  801a07:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a0d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	50                   	push   %eax
  801a1a:	6a 15                	push   $0x15
  801a1c:	e8 d3 fd ff ff       	call   8017f4 <syscall>
  801a21:	83 c4 18             	add    $0x18,%esp
}
  801a24:	90                   	nop
  801a25:	c9                   	leave  
  801a26:	c3                   	ret    

00801a27 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a27:	55                   	push   %ebp
  801a28:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	6a 16                	push   $0x16
  801a36:	e8 b9 fd ff ff       	call   8017f4 <syscall>
  801a3b:	83 c4 18             	add    $0x18,%esp
}
  801a3e:	90                   	nop
  801a3f:	c9                   	leave  
  801a40:	c3                   	ret    

00801a41 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a41:	55                   	push   %ebp
  801a42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a44:	8b 45 08             	mov    0x8(%ebp),%eax
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	ff 75 0c             	pushl  0xc(%ebp)
  801a50:	50                   	push   %eax
  801a51:	6a 17                	push   $0x17
  801a53:	e8 9c fd ff ff       	call   8017f4 <syscall>
  801a58:	83 c4 18             	add    $0x18,%esp
}
  801a5b:	c9                   	leave  
  801a5c:	c3                   	ret    

00801a5d <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a5d:	55                   	push   %ebp
  801a5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a60:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a63:	8b 45 08             	mov    0x8(%ebp),%eax
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	52                   	push   %edx
  801a6d:	50                   	push   %eax
  801a6e:	6a 1a                	push   $0x1a
  801a70:	e8 7f fd ff ff       	call   8017f4 <syscall>
  801a75:	83 c4 18             	add    $0x18,%esp
}
  801a78:	c9                   	leave  
  801a79:	c3                   	ret    

00801a7a <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a7a:	55                   	push   %ebp
  801a7b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a80:	8b 45 08             	mov    0x8(%ebp),%eax
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	52                   	push   %edx
  801a8a:	50                   	push   %eax
  801a8b:	6a 18                	push   $0x18
  801a8d:	e8 62 fd ff ff       	call   8017f4 <syscall>
  801a92:	83 c4 18             	add    $0x18,%esp
}
  801a95:	90                   	nop
  801a96:	c9                   	leave  
  801a97:	c3                   	ret    

00801a98 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a98:	55                   	push   %ebp
  801a99:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	52                   	push   %edx
  801aa8:	50                   	push   %eax
  801aa9:	6a 19                	push   $0x19
  801aab:	e8 44 fd ff ff       	call   8017f4 <syscall>
  801ab0:	83 c4 18             	add    $0x18,%esp
}
  801ab3:	90                   	nop
  801ab4:	c9                   	leave  
  801ab5:	c3                   	ret    

00801ab6 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ab6:	55                   	push   %ebp
  801ab7:	89 e5                	mov    %esp,%ebp
  801ab9:	83 ec 04             	sub    $0x4,%esp
  801abc:	8b 45 10             	mov    0x10(%ebp),%eax
  801abf:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ac2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ac5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  801acc:	6a 00                	push   $0x0
  801ace:	51                   	push   %ecx
  801acf:	52                   	push   %edx
  801ad0:	ff 75 0c             	pushl  0xc(%ebp)
  801ad3:	50                   	push   %eax
  801ad4:	6a 1b                	push   $0x1b
  801ad6:	e8 19 fd ff ff       	call   8017f4 <syscall>
  801adb:	83 c4 18             	add    $0x18,%esp
}
  801ade:	c9                   	leave  
  801adf:	c3                   	ret    

00801ae0 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ae0:	55                   	push   %ebp
  801ae1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ae3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	52                   	push   %edx
  801af0:	50                   	push   %eax
  801af1:	6a 1c                	push   $0x1c
  801af3:	e8 fc fc ff ff       	call   8017f4 <syscall>
  801af8:	83 c4 18             	add    $0x18,%esp
}
  801afb:	c9                   	leave  
  801afc:	c3                   	ret    

00801afd <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801afd:	55                   	push   %ebp
  801afe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b00:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b03:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b06:	8b 45 08             	mov    0x8(%ebp),%eax
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	51                   	push   %ecx
  801b0e:	52                   	push   %edx
  801b0f:	50                   	push   %eax
  801b10:	6a 1d                	push   $0x1d
  801b12:	e8 dd fc ff ff       	call   8017f4 <syscall>
  801b17:	83 c4 18             	add    $0x18,%esp
}
  801b1a:	c9                   	leave  
  801b1b:	c3                   	ret    

00801b1c <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b1c:	55                   	push   %ebp
  801b1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b22:	8b 45 08             	mov    0x8(%ebp),%eax
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	52                   	push   %edx
  801b2c:	50                   	push   %eax
  801b2d:	6a 1e                	push   $0x1e
  801b2f:	e8 c0 fc ff ff       	call   8017f4 <syscall>
  801b34:	83 c4 18             	add    $0x18,%esp
}
  801b37:	c9                   	leave  
  801b38:	c3                   	ret    

00801b39 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b39:	55                   	push   %ebp
  801b3a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 1f                	push   $0x1f
  801b48:	e8 a7 fc ff ff       	call   8017f4 <syscall>
  801b4d:	83 c4 18             	add    $0x18,%esp
}
  801b50:	c9                   	leave  
  801b51:	c3                   	ret    

00801b52 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b52:	55                   	push   %ebp
  801b53:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b55:	8b 45 08             	mov    0x8(%ebp),%eax
  801b58:	6a 00                	push   $0x0
  801b5a:	ff 75 14             	pushl  0x14(%ebp)
  801b5d:	ff 75 10             	pushl  0x10(%ebp)
  801b60:	ff 75 0c             	pushl  0xc(%ebp)
  801b63:	50                   	push   %eax
  801b64:	6a 20                	push   $0x20
  801b66:	e8 89 fc ff ff       	call   8017f4 <syscall>
  801b6b:	83 c4 18             	add    $0x18,%esp
}
  801b6e:	c9                   	leave  
  801b6f:	c3                   	ret    

00801b70 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b73:	8b 45 08             	mov    0x8(%ebp),%eax
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 00                	push   $0x0
  801b7e:	50                   	push   %eax
  801b7f:	6a 21                	push   $0x21
  801b81:	e8 6e fc ff ff       	call   8017f4 <syscall>
  801b86:	83 c4 18             	add    $0x18,%esp
}
  801b89:	90                   	nop
  801b8a:	c9                   	leave  
  801b8b:	c3                   	ret    

00801b8c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b8c:	55                   	push   %ebp
  801b8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	50                   	push   %eax
  801b9b:	6a 22                	push   $0x22
  801b9d:	e8 52 fc ff ff       	call   8017f4 <syscall>
  801ba2:	83 c4 18             	add    $0x18,%esp
}
  801ba5:	c9                   	leave  
  801ba6:	c3                   	ret    

00801ba7 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ba7:	55                   	push   %ebp
  801ba8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 02                	push   $0x2
  801bb6:	e8 39 fc ff ff       	call   8017f4 <syscall>
  801bbb:	83 c4 18             	add    $0x18,%esp
}
  801bbe:	c9                   	leave  
  801bbf:	c3                   	ret    

00801bc0 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801bc0:	55                   	push   %ebp
  801bc1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 03                	push   $0x3
  801bcf:	e8 20 fc ff ff       	call   8017f4 <syscall>
  801bd4:	83 c4 18             	add    $0x18,%esp
}
  801bd7:	c9                   	leave  
  801bd8:	c3                   	ret    

00801bd9 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bd9:	55                   	push   %ebp
  801bda:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	6a 04                	push   $0x4
  801be8:	e8 07 fc ff ff       	call   8017f4 <syscall>
  801bed:	83 c4 18             	add    $0x18,%esp
}
  801bf0:	c9                   	leave  
  801bf1:	c3                   	ret    

00801bf2 <sys_exit_env>:


void sys_exit_env(void)
{
  801bf2:	55                   	push   %ebp
  801bf3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 23                	push   $0x23
  801c01:	e8 ee fb ff ff       	call   8017f4 <syscall>
  801c06:	83 c4 18             	add    $0x18,%esp
}
  801c09:	90                   	nop
  801c0a:	c9                   	leave  
  801c0b:	c3                   	ret    

00801c0c <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c0c:	55                   	push   %ebp
  801c0d:	89 e5                	mov    %esp,%ebp
  801c0f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c12:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c15:	8d 50 04             	lea    0x4(%eax),%edx
  801c18:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	52                   	push   %edx
  801c22:	50                   	push   %eax
  801c23:	6a 24                	push   $0x24
  801c25:	e8 ca fb ff ff       	call   8017f4 <syscall>
  801c2a:	83 c4 18             	add    $0x18,%esp
	return result;
  801c2d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c30:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c33:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c36:	89 01                	mov    %eax,(%ecx)
  801c38:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3e:	c9                   	leave  
  801c3f:	c2 04 00             	ret    $0x4

00801c42 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c42:	55                   	push   %ebp
  801c43:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c45:	6a 00                	push   $0x0
  801c47:	6a 00                	push   $0x0
  801c49:	ff 75 10             	pushl  0x10(%ebp)
  801c4c:	ff 75 0c             	pushl  0xc(%ebp)
  801c4f:	ff 75 08             	pushl  0x8(%ebp)
  801c52:	6a 12                	push   $0x12
  801c54:	e8 9b fb ff ff       	call   8017f4 <syscall>
  801c59:	83 c4 18             	add    $0x18,%esp
	return ;
  801c5c:	90                   	nop
}
  801c5d:	c9                   	leave  
  801c5e:	c3                   	ret    

00801c5f <sys_rcr2>:
uint32 sys_rcr2()
{
  801c5f:	55                   	push   %ebp
  801c60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 25                	push   $0x25
  801c6e:	e8 81 fb ff ff       	call   8017f4 <syscall>
  801c73:	83 c4 18             	add    $0x18,%esp
}
  801c76:	c9                   	leave  
  801c77:	c3                   	ret    

00801c78 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c78:	55                   	push   %ebp
  801c79:	89 e5                	mov    %esp,%ebp
  801c7b:	83 ec 04             	sub    $0x4,%esp
  801c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c81:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c84:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	50                   	push   %eax
  801c91:	6a 26                	push   $0x26
  801c93:	e8 5c fb ff ff       	call   8017f4 <syscall>
  801c98:	83 c4 18             	add    $0x18,%esp
	return ;
  801c9b:	90                   	nop
}
  801c9c:	c9                   	leave  
  801c9d:	c3                   	ret    

00801c9e <rsttst>:
void rsttst()
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 28                	push   $0x28
  801cad:	e8 42 fb ff ff       	call   8017f4 <syscall>
  801cb2:	83 c4 18             	add    $0x18,%esp
	return ;
  801cb5:	90                   	nop
}
  801cb6:	c9                   	leave  
  801cb7:	c3                   	ret    

00801cb8 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801cb8:	55                   	push   %ebp
  801cb9:	89 e5                	mov    %esp,%ebp
  801cbb:	83 ec 04             	sub    $0x4,%esp
  801cbe:	8b 45 14             	mov    0x14(%ebp),%eax
  801cc1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801cc4:	8b 55 18             	mov    0x18(%ebp),%edx
  801cc7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ccb:	52                   	push   %edx
  801ccc:	50                   	push   %eax
  801ccd:	ff 75 10             	pushl  0x10(%ebp)
  801cd0:	ff 75 0c             	pushl  0xc(%ebp)
  801cd3:	ff 75 08             	pushl  0x8(%ebp)
  801cd6:	6a 27                	push   $0x27
  801cd8:	e8 17 fb ff ff       	call   8017f4 <syscall>
  801cdd:	83 c4 18             	add    $0x18,%esp
	return ;
  801ce0:	90                   	nop
}
  801ce1:	c9                   	leave  
  801ce2:	c3                   	ret    

00801ce3 <chktst>:
void chktst(uint32 n)
{
  801ce3:	55                   	push   %ebp
  801ce4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	ff 75 08             	pushl  0x8(%ebp)
  801cf1:	6a 29                	push   $0x29
  801cf3:	e8 fc fa ff ff       	call   8017f4 <syscall>
  801cf8:	83 c4 18             	add    $0x18,%esp
	return ;
  801cfb:	90                   	nop
}
  801cfc:	c9                   	leave  
  801cfd:	c3                   	ret    

00801cfe <inctst>:

void inctst()
{
  801cfe:	55                   	push   %ebp
  801cff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 2a                	push   $0x2a
  801d0d:	e8 e2 fa ff ff       	call   8017f4 <syscall>
  801d12:	83 c4 18             	add    $0x18,%esp
	return ;
  801d15:	90                   	nop
}
  801d16:	c9                   	leave  
  801d17:	c3                   	ret    

00801d18 <gettst>:
uint32 gettst()
{
  801d18:	55                   	push   %ebp
  801d19:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	6a 2b                	push   $0x2b
  801d27:	e8 c8 fa ff ff       	call   8017f4 <syscall>
  801d2c:	83 c4 18             	add    $0x18,%esp
}
  801d2f:	c9                   	leave  
  801d30:	c3                   	ret    

00801d31 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d31:	55                   	push   %ebp
  801d32:	89 e5                	mov    %esp,%ebp
  801d34:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d37:	6a 00                	push   $0x0
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 2c                	push   $0x2c
  801d43:	e8 ac fa ff ff       	call   8017f4 <syscall>
  801d48:	83 c4 18             	add    $0x18,%esp
  801d4b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d4e:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d52:	75 07                	jne    801d5b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d54:	b8 01 00 00 00       	mov    $0x1,%eax
  801d59:	eb 05                	jmp    801d60 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d60:	c9                   	leave  
  801d61:	c3                   	ret    

00801d62 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d62:	55                   	push   %ebp
  801d63:	89 e5                	mov    %esp,%ebp
  801d65:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 00                	push   $0x0
  801d72:	6a 2c                	push   $0x2c
  801d74:	e8 7b fa ff ff       	call   8017f4 <syscall>
  801d79:	83 c4 18             	add    $0x18,%esp
  801d7c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d7f:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d83:	75 07                	jne    801d8c <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d85:	b8 01 00 00 00       	mov    $0x1,%eax
  801d8a:	eb 05                	jmp    801d91 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d8c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d91:	c9                   	leave  
  801d92:	c3                   	ret    

00801d93 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d93:	55                   	push   %ebp
  801d94:	89 e5                	mov    %esp,%ebp
  801d96:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 00                	push   $0x0
  801da3:	6a 2c                	push   $0x2c
  801da5:	e8 4a fa ff ff       	call   8017f4 <syscall>
  801daa:	83 c4 18             	add    $0x18,%esp
  801dad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801db0:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801db4:	75 07                	jne    801dbd <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801db6:	b8 01 00 00 00       	mov    $0x1,%eax
  801dbb:	eb 05                	jmp    801dc2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801dbd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dc2:	c9                   	leave  
  801dc3:	c3                   	ret    

00801dc4 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801dc4:	55                   	push   %ebp
  801dc5:	89 e5                	mov    %esp,%ebp
  801dc7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 2c                	push   $0x2c
  801dd6:	e8 19 fa ff ff       	call   8017f4 <syscall>
  801ddb:	83 c4 18             	add    $0x18,%esp
  801dde:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801de1:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801de5:	75 07                	jne    801dee <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801de7:	b8 01 00 00 00       	mov    $0x1,%eax
  801dec:	eb 05                	jmp    801df3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801dee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801df3:	c9                   	leave  
  801df4:	c3                   	ret    

00801df5 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801df5:	55                   	push   %ebp
  801df6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	ff 75 08             	pushl  0x8(%ebp)
  801e03:	6a 2d                	push   $0x2d
  801e05:	e8 ea f9 ff ff       	call   8017f4 <syscall>
  801e0a:	83 c4 18             	add    $0x18,%esp
	return ;
  801e0d:	90                   	nop
}
  801e0e:	c9                   	leave  
  801e0f:	c3                   	ret    

00801e10 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e10:	55                   	push   %ebp
  801e11:	89 e5                	mov    %esp,%ebp
  801e13:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e14:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e17:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e20:	6a 00                	push   $0x0
  801e22:	53                   	push   %ebx
  801e23:	51                   	push   %ecx
  801e24:	52                   	push   %edx
  801e25:	50                   	push   %eax
  801e26:	6a 2e                	push   $0x2e
  801e28:	e8 c7 f9 ff ff       	call   8017f4 <syscall>
  801e2d:	83 c4 18             	add    $0x18,%esp
}
  801e30:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e33:	c9                   	leave  
  801e34:	c3                   	ret    

00801e35 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e35:	55                   	push   %ebp
  801e36:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e38:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 00                	push   $0x0
  801e42:	6a 00                	push   $0x0
  801e44:	52                   	push   %edx
  801e45:	50                   	push   %eax
  801e46:	6a 2f                	push   $0x2f
  801e48:	e8 a7 f9 ff ff       	call   8017f4 <syscall>
  801e4d:	83 c4 18             	add    $0x18,%esp
}
  801e50:	c9                   	leave  
  801e51:	c3                   	ret    

00801e52 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e52:	55                   	push   %ebp
  801e53:	89 e5                	mov    %esp,%ebp
  801e55:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e58:	83 ec 0c             	sub    $0xc,%esp
  801e5b:	68 e8 3e 80 00       	push   $0x803ee8
  801e60:	e8 1e e8 ff ff       	call   800683 <cprintf>
  801e65:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e68:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e6f:	83 ec 0c             	sub    $0xc,%esp
  801e72:	68 14 3f 80 00       	push   $0x803f14
  801e77:	e8 07 e8 ff ff       	call   800683 <cprintf>
  801e7c:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e7f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e83:	a1 38 51 80 00       	mov    0x805138,%eax
  801e88:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e8b:	eb 56                	jmp    801ee3 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e8d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e91:	74 1c                	je     801eaf <print_mem_block_lists+0x5d>
  801e93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e96:	8b 50 08             	mov    0x8(%eax),%edx
  801e99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e9c:	8b 48 08             	mov    0x8(%eax),%ecx
  801e9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ea2:	8b 40 0c             	mov    0xc(%eax),%eax
  801ea5:	01 c8                	add    %ecx,%eax
  801ea7:	39 c2                	cmp    %eax,%edx
  801ea9:	73 04                	jae    801eaf <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801eab:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801eaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb2:	8b 50 08             	mov    0x8(%eax),%edx
  801eb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb8:	8b 40 0c             	mov    0xc(%eax),%eax
  801ebb:	01 c2                	add    %eax,%edx
  801ebd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec0:	8b 40 08             	mov    0x8(%eax),%eax
  801ec3:	83 ec 04             	sub    $0x4,%esp
  801ec6:	52                   	push   %edx
  801ec7:	50                   	push   %eax
  801ec8:	68 29 3f 80 00       	push   $0x803f29
  801ecd:	e8 b1 e7 ff ff       	call   800683 <cprintf>
  801ed2:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ed5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801edb:	a1 40 51 80 00       	mov    0x805140,%eax
  801ee0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ee3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ee7:	74 07                	je     801ef0 <print_mem_block_lists+0x9e>
  801ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eec:	8b 00                	mov    (%eax),%eax
  801eee:	eb 05                	jmp    801ef5 <print_mem_block_lists+0xa3>
  801ef0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef5:	a3 40 51 80 00       	mov    %eax,0x805140
  801efa:	a1 40 51 80 00       	mov    0x805140,%eax
  801eff:	85 c0                	test   %eax,%eax
  801f01:	75 8a                	jne    801e8d <print_mem_block_lists+0x3b>
  801f03:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f07:	75 84                	jne    801e8d <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f09:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f0d:	75 10                	jne    801f1f <print_mem_block_lists+0xcd>
  801f0f:	83 ec 0c             	sub    $0xc,%esp
  801f12:	68 38 3f 80 00       	push   $0x803f38
  801f17:	e8 67 e7 ff ff       	call   800683 <cprintf>
  801f1c:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f1f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f26:	83 ec 0c             	sub    $0xc,%esp
  801f29:	68 5c 3f 80 00       	push   $0x803f5c
  801f2e:	e8 50 e7 ff ff       	call   800683 <cprintf>
  801f33:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f36:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f3a:	a1 40 50 80 00       	mov    0x805040,%eax
  801f3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f42:	eb 56                	jmp    801f9a <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f44:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f48:	74 1c                	je     801f66 <print_mem_block_lists+0x114>
  801f4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f4d:	8b 50 08             	mov    0x8(%eax),%edx
  801f50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f53:	8b 48 08             	mov    0x8(%eax),%ecx
  801f56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f59:	8b 40 0c             	mov    0xc(%eax),%eax
  801f5c:	01 c8                	add    %ecx,%eax
  801f5e:	39 c2                	cmp    %eax,%edx
  801f60:	73 04                	jae    801f66 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f62:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f69:	8b 50 08             	mov    0x8(%eax),%edx
  801f6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6f:	8b 40 0c             	mov    0xc(%eax),%eax
  801f72:	01 c2                	add    %eax,%edx
  801f74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f77:	8b 40 08             	mov    0x8(%eax),%eax
  801f7a:	83 ec 04             	sub    $0x4,%esp
  801f7d:	52                   	push   %edx
  801f7e:	50                   	push   %eax
  801f7f:	68 29 3f 80 00       	push   $0x803f29
  801f84:	e8 fa e6 ff ff       	call   800683 <cprintf>
  801f89:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f92:	a1 48 50 80 00       	mov    0x805048,%eax
  801f97:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f9a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f9e:	74 07                	je     801fa7 <print_mem_block_lists+0x155>
  801fa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa3:	8b 00                	mov    (%eax),%eax
  801fa5:	eb 05                	jmp    801fac <print_mem_block_lists+0x15a>
  801fa7:	b8 00 00 00 00       	mov    $0x0,%eax
  801fac:	a3 48 50 80 00       	mov    %eax,0x805048
  801fb1:	a1 48 50 80 00       	mov    0x805048,%eax
  801fb6:	85 c0                	test   %eax,%eax
  801fb8:	75 8a                	jne    801f44 <print_mem_block_lists+0xf2>
  801fba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fbe:	75 84                	jne    801f44 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801fc0:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fc4:	75 10                	jne    801fd6 <print_mem_block_lists+0x184>
  801fc6:	83 ec 0c             	sub    $0xc,%esp
  801fc9:	68 74 3f 80 00       	push   $0x803f74
  801fce:	e8 b0 e6 ff ff       	call   800683 <cprintf>
  801fd3:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801fd6:	83 ec 0c             	sub    $0xc,%esp
  801fd9:	68 e8 3e 80 00       	push   $0x803ee8
  801fde:	e8 a0 e6 ff ff       	call   800683 <cprintf>
  801fe3:	83 c4 10             	add    $0x10,%esp

}
  801fe6:	90                   	nop
  801fe7:	c9                   	leave  
  801fe8:	c3                   	ret    

00801fe9 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801fe9:	55                   	push   %ebp
  801fea:	89 e5                	mov    %esp,%ebp
  801fec:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801fef:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801ff6:	00 00 00 
  801ff9:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802000:	00 00 00 
  802003:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80200a:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  80200d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802014:	e9 9e 00 00 00       	jmp    8020b7 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802019:	a1 50 50 80 00       	mov    0x805050,%eax
  80201e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802021:	c1 e2 04             	shl    $0x4,%edx
  802024:	01 d0                	add    %edx,%eax
  802026:	85 c0                	test   %eax,%eax
  802028:	75 14                	jne    80203e <initialize_MemBlocksList+0x55>
  80202a:	83 ec 04             	sub    $0x4,%esp
  80202d:	68 9c 3f 80 00       	push   $0x803f9c
  802032:	6a 46                	push   $0x46
  802034:	68 bf 3f 80 00       	push   $0x803fbf
  802039:	e8 64 14 00 00       	call   8034a2 <_panic>
  80203e:	a1 50 50 80 00       	mov    0x805050,%eax
  802043:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802046:	c1 e2 04             	shl    $0x4,%edx
  802049:	01 d0                	add    %edx,%eax
  80204b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802051:	89 10                	mov    %edx,(%eax)
  802053:	8b 00                	mov    (%eax),%eax
  802055:	85 c0                	test   %eax,%eax
  802057:	74 18                	je     802071 <initialize_MemBlocksList+0x88>
  802059:	a1 48 51 80 00       	mov    0x805148,%eax
  80205e:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802064:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802067:	c1 e1 04             	shl    $0x4,%ecx
  80206a:	01 ca                	add    %ecx,%edx
  80206c:	89 50 04             	mov    %edx,0x4(%eax)
  80206f:	eb 12                	jmp    802083 <initialize_MemBlocksList+0x9a>
  802071:	a1 50 50 80 00       	mov    0x805050,%eax
  802076:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802079:	c1 e2 04             	shl    $0x4,%edx
  80207c:	01 d0                	add    %edx,%eax
  80207e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802083:	a1 50 50 80 00       	mov    0x805050,%eax
  802088:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80208b:	c1 e2 04             	shl    $0x4,%edx
  80208e:	01 d0                	add    %edx,%eax
  802090:	a3 48 51 80 00       	mov    %eax,0x805148
  802095:	a1 50 50 80 00       	mov    0x805050,%eax
  80209a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80209d:	c1 e2 04             	shl    $0x4,%edx
  8020a0:	01 d0                	add    %edx,%eax
  8020a2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020a9:	a1 54 51 80 00       	mov    0x805154,%eax
  8020ae:	40                   	inc    %eax
  8020af:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8020b4:	ff 45 f4             	incl   -0xc(%ebp)
  8020b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ba:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020bd:	0f 82 56 ff ff ff    	jb     802019 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8020c3:	90                   	nop
  8020c4:	c9                   	leave  
  8020c5:	c3                   	ret    

008020c6 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8020c6:	55                   	push   %ebp
  8020c7:	89 e5                	mov    %esp,%ebp
  8020c9:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8020cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cf:	8b 00                	mov    (%eax),%eax
  8020d1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020d4:	eb 19                	jmp    8020ef <find_block+0x29>
	{
		if(va==point->sva)
  8020d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020d9:	8b 40 08             	mov    0x8(%eax),%eax
  8020dc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8020df:	75 05                	jne    8020e6 <find_block+0x20>
		   return point;
  8020e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020e4:	eb 36                	jmp    80211c <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8020e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e9:	8b 40 08             	mov    0x8(%eax),%eax
  8020ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020ef:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020f3:	74 07                	je     8020fc <find_block+0x36>
  8020f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020f8:	8b 00                	mov    (%eax),%eax
  8020fa:	eb 05                	jmp    802101 <find_block+0x3b>
  8020fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802101:	8b 55 08             	mov    0x8(%ebp),%edx
  802104:	89 42 08             	mov    %eax,0x8(%edx)
  802107:	8b 45 08             	mov    0x8(%ebp),%eax
  80210a:	8b 40 08             	mov    0x8(%eax),%eax
  80210d:	85 c0                	test   %eax,%eax
  80210f:	75 c5                	jne    8020d6 <find_block+0x10>
  802111:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802115:	75 bf                	jne    8020d6 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802117:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80211c:	c9                   	leave  
  80211d:	c3                   	ret    

0080211e <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80211e:	55                   	push   %ebp
  80211f:	89 e5                	mov    %esp,%ebp
  802121:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802124:	a1 40 50 80 00       	mov    0x805040,%eax
  802129:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  80212c:	a1 44 50 80 00       	mov    0x805044,%eax
  802131:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802134:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802137:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80213a:	74 24                	je     802160 <insert_sorted_allocList+0x42>
  80213c:	8b 45 08             	mov    0x8(%ebp),%eax
  80213f:	8b 50 08             	mov    0x8(%eax),%edx
  802142:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802145:	8b 40 08             	mov    0x8(%eax),%eax
  802148:	39 c2                	cmp    %eax,%edx
  80214a:	76 14                	jbe    802160 <insert_sorted_allocList+0x42>
  80214c:	8b 45 08             	mov    0x8(%ebp),%eax
  80214f:	8b 50 08             	mov    0x8(%eax),%edx
  802152:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802155:	8b 40 08             	mov    0x8(%eax),%eax
  802158:	39 c2                	cmp    %eax,%edx
  80215a:	0f 82 60 01 00 00    	jb     8022c0 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802160:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802164:	75 65                	jne    8021cb <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802166:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80216a:	75 14                	jne    802180 <insert_sorted_allocList+0x62>
  80216c:	83 ec 04             	sub    $0x4,%esp
  80216f:	68 9c 3f 80 00       	push   $0x803f9c
  802174:	6a 6b                	push   $0x6b
  802176:	68 bf 3f 80 00       	push   $0x803fbf
  80217b:	e8 22 13 00 00       	call   8034a2 <_panic>
  802180:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802186:	8b 45 08             	mov    0x8(%ebp),%eax
  802189:	89 10                	mov    %edx,(%eax)
  80218b:	8b 45 08             	mov    0x8(%ebp),%eax
  80218e:	8b 00                	mov    (%eax),%eax
  802190:	85 c0                	test   %eax,%eax
  802192:	74 0d                	je     8021a1 <insert_sorted_allocList+0x83>
  802194:	a1 40 50 80 00       	mov    0x805040,%eax
  802199:	8b 55 08             	mov    0x8(%ebp),%edx
  80219c:	89 50 04             	mov    %edx,0x4(%eax)
  80219f:	eb 08                	jmp    8021a9 <insert_sorted_allocList+0x8b>
  8021a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a4:	a3 44 50 80 00       	mov    %eax,0x805044
  8021a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ac:	a3 40 50 80 00       	mov    %eax,0x805040
  8021b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021bb:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021c0:	40                   	inc    %eax
  8021c1:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021c6:	e9 dc 01 00 00       	jmp    8023a7 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8021cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ce:	8b 50 08             	mov    0x8(%eax),%edx
  8021d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d4:	8b 40 08             	mov    0x8(%eax),%eax
  8021d7:	39 c2                	cmp    %eax,%edx
  8021d9:	77 6c                	ja     802247 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8021db:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021df:	74 06                	je     8021e7 <insert_sorted_allocList+0xc9>
  8021e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021e5:	75 14                	jne    8021fb <insert_sorted_allocList+0xdd>
  8021e7:	83 ec 04             	sub    $0x4,%esp
  8021ea:	68 d8 3f 80 00       	push   $0x803fd8
  8021ef:	6a 6f                	push   $0x6f
  8021f1:	68 bf 3f 80 00       	push   $0x803fbf
  8021f6:	e8 a7 12 00 00       	call   8034a2 <_panic>
  8021fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021fe:	8b 50 04             	mov    0x4(%eax),%edx
  802201:	8b 45 08             	mov    0x8(%ebp),%eax
  802204:	89 50 04             	mov    %edx,0x4(%eax)
  802207:	8b 45 08             	mov    0x8(%ebp),%eax
  80220a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80220d:	89 10                	mov    %edx,(%eax)
  80220f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802212:	8b 40 04             	mov    0x4(%eax),%eax
  802215:	85 c0                	test   %eax,%eax
  802217:	74 0d                	je     802226 <insert_sorted_allocList+0x108>
  802219:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80221c:	8b 40 04             	mov    0x4(%eax),%eax
  80221f:	8b 55 08             	mov    0x8(%ebp),%edx
  802222:	89 10                	mov    %edx,(%eax)
  802224:	eb 08                	jmp    80222e <insert_sorted_allocList+0x110>
  802226:	8b 45 08             	mov    0x8(%ebp),%eax
  802229:	a3 40 50 80 00       	mov    %eax,0x805040
  80222e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802231:	8b 55 08             	mov    0x8(%ebp),%edx
  802234:	89 50 04             	mov    %edx,0x4(%eax)
  802237:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80223c:	40                   	inc    %eax
  80223d:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802242:	e9 60 01 00 00       	jmp    8023a7 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802247:	8b 45 08             	mov    0x8(%ebp),%eax
  80224a:	8b 50 08             	mov    0x8(%eax),%edx
  80224d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802250:	8b 40 08             	mov    0x8(%eax),%eax
  802253:	39 c2                	cmp    %eax,%edx
  802255:	0f 82 4c 01 00 00    	jb     8023a7 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80225b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80225f:	75 14                	jne    802275 <insert_sorted_allocList+0x157>
  802261:	83 ec 04             	sub    $0x4,%esp
  802264:	68 10 40 80 00       	push   $0x804010
  802269:	6a 73                	push   $0x73
  80226b:	68 bf 3f 80 00       	push   $0x803fbf
  802270:	e8 2d 12 00 00       	call   8034a2 <_panic>
  802275:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80227b:	8b 45 08             	mov    0x8(%ebp),%eax
  80227e:	89 50 04             	mov    %edx,0x4(%eax)
  802281:	8b 45 08             	mov    0x8(%ebp),%eax
  802284:	8b 40 04             	mov    0x4(%eax),%eax
  802287:	85 c0                	test   %eax,%eax
  802289:	74 0c                	je     802297 <insert_sorted_allocList+0x179>
  80228b:	a1 44 50 80 00       	mov    0x805044,%eax
  802290:	8b 55 08             	mov    0x8(%ebp),%edx
  802293:	89 10                	mov    %edx,(%eax)
  802295:	eb 08                	jmp    80229f <insert_sorted_allocList+0x181>
  802297:	8b 45 08             	mov    0x8(%ebp),%eax
  80229a:	a3 40 50 80 00       	mov    %eax,0x805040
  80229f:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a2:	a3 44 50 80 00       	mov    %eax,0x805044
  8022a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022b0:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022b5:	40                   	inc    %eax
  8022b6:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022bb:	e9 e7 00 00 00       	jmp    8023a7 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8022c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8022c6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8022cd:	a1 40 50 80 00       	mov    0x805040,%eax
  8022d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022d5:	e9 9d 00 00 00       	jmp    802377 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8022da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022dd:	8b 00                	mov    (%eax),%eax
  8022df:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8022e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e5:	8b 50 08             	mov    0x8(%eax),%edx
  8022e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022eb:	8b 40 08             	mov    0x8(%eax),%eax
  8022ee:	39 c2                	cmp    %eax,%edx
  8022f0:	76 7d                	jbe    80236f <insert_sorted_allocList+0x251>
  8022f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f5:	8b 50 08             	mov    0x8(%eax),%edx
  8022f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022fb:	8b 40 08             	mov    0x8(%eax),%eax
  8022fe:	39 c2                	cmp    %eax,%edx
  802300:	73 6d                	jae    80236f <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802302:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802306:	74 06                	je     80230e <insert_sorted_allocList+0x1f0>
  802308:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80230c:	75 14                	jne    802322 <insert_sorted_allocList+0x204>
  80230e:	83 ec 04             	sub    $0x4,%esp
  802311:	68 34 40 80 00       	push   $0x804034
  802316:	6a 7f                	push   $0x7f
  802318:	68 bf 3f 80 00       	push   $0x803fbf
  80231d:	e8 80 11 00 00       	call   8034a2 <_panic>
  802322:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802325:	8b 10                	mov    (%eax),%edx
  802327:	8b 45 08             	mov    0x8(%ebp),%eax
  80232a:	89 10                	mov    %edx,(%eax)
  80232c:	8b 45 08             	mov    0x8(%ebp),%eax
  80232f:	8b 00                	mov    (%eax),%eax
  802331:	85 c0                	test   %eax,%eax
  802333:	74 0b                	je     802340 <insert_sorted_allocList+0x222>
  802335:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802338:	8b 00                	mov    (%eax),%eax
  80233a:	8b 55 08             	mov    0x8(%ebp),%edx
  80233d:	89 50 04             	mov    %edx,0x4(%eax)
  802340:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802343:	8b 55 08             	mov    0x8(%ebp),%edx
  802346:	89 10                	mov    %edx,(%eax)
  802348:	8b 45 08             	mov    0x8(%ebp),%eax
  80234b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80234e:	89 50 04             	mov    %edx,0x4(%eax)
  802351:	8b 45 08             	mov    0x8(%ebp),%eax
  802354:	8b 00                	mov    (%eax),%eax
  802356:	85 c0                	test   %eax,%eax
  802358:	75 08                	jne    802362 <insert_sorted_allocList+0x244>
  80235a:	8b 45 08             	mov    0x8(%ebp),%eax
  80235d:	a3 44 50 80 00       	mov    %eax,0x805044
  802362:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802367:	40                   	inc    %eax
  802368:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  80236d:	eb 39                	jmp    8023a8 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80236f:	a1 48 50 80 00       	mov    0x805048,%eax
  802374:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802377:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80237b:	74 07                	je     802384 <insert_sorted_allocList+0x266>
  80237d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802380:	8b 00                	mov    (%eax),%eax
  802382:	eb 05                	jmp    802389 <insert_sorted_allocList+0x26b>
  802384:	b8 00 00 00 00       	mov    $0x0,%eax
  802389:	a3 48 50 80 00       	mov    %eax,0x805048
  80238e:	a1 48 50 80 00       	mov    0x805048,%eax
  802393:	85 c0                	test   %eax,%eax
  802395:	0f 85 3f ff ff ff    	jne    8022da <insert_sorted_allocList+0x1bc>
  80239b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80239f:	0f 85 35 ff ff ff    	jne    8022da <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8023a5:	eb 01                	jmp    8023a8 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8023a7:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8023a8:	90                   	nop
  8023a9:	c9                   	leave  
  8023aa:	c3                   	ret    

008023ab <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8023ab:	55                   	push   %ebp
  8023ac:	89 e5                	mov    %esp,%ebp
  8023ae:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8023b1:	a1 38 51 80 00       	mov    0x805138,%eax
  8023b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023b9:	e9 85 01 00 00       	jmp    802543 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8023be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8023c4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023c7:	0f 82 6e 01 00 00    	jb     80253b <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8023cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8023d3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023d6:	0f 85 8a 00 00 00    	jne    802466 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8023dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023e0:	75 17                	jne    8023f9 <alloc_block_FF+0x4e>
  8023e2:	83 ec 04             	sub    $0x4,%esp
  8023e5:	68 68 40 80 00       	push   $0x804068
  8023ea:	68 93 00 00 00       	push   $0x93
  8023ef:	68 bf 3f 80 00       	push   $0x803fbf
  8023f4:	e8 a9 10 00 00       	call   8034a2 <_panic>
  8023f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fc:	8b 00                	mov    (%eax),%eax
  8023fe:	85 c0                	test   %eax,%eax
  802400:	74 10                	je     802412 <alloc_block_FF+0x67>
  802402:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802405:	8b 00                	mov    (%eax),%eax
  802407:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80240a:	8b 52 04             	mov    0x4(%edx),%edx
  80240d:	89 50 04             	mov    %edx,0x4(%eax)
  802410:	eb 0b                	jmp    80241d <alloc_block_FF+0x72>
  802412:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802415:	8b 40 04             	mov    0x4(%eax),%eax
  802418:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80241d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802420:	8b 40 04             	mov    0x4(%eax),%eax
  802423:	85 c0                	test   %eax,%eax
  802425:	74 0f                	je     802436 <alloc_block_FF+0x8b>
  802427:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242a:	8b 40 04             	mov    0x4(%eax),%eax
  80242d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802430:	8b 12                	mov    (%edx),%edx
  802432:	89 10                	mov    %edx,(%eax)
  802434:	eb 0a                	jmp    802440 <alloc_block_FF+0x95>
  802436:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802439:	8b 00                	mov    (%eax),%eax
  80243b:	a3 38 51 80 00       	mov    %eax,0x805138
  802440:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802443:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802449:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802453:	a1 44 51 80 00       	mov    0x805144,%eax
  802458:	48                   	dec    %eax
  802459:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  80245e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802461:	e9 10 01 00 00       	jmp    802576 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802466:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802469:	8b 40 0c             	mov    0xc(%eax),%eax
  80246c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80246f:	0f 86 c6 00 00 00    	jbe    80253b <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802475:	a1 48 51 80 00       	mov    0x805148,%eax
  80247a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  80247d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802480:	8b 50 08             	mov    0x8(%eax),%edx
  802483:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802486:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802489:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80248c:	8b 55 08             	mov    0x8(%ebp),%edx
  80248f:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802492:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802496:	75 17                	jne    8024af <alloc_block_FF+0x104>
  802498:	83 ec 04             	sub    $0x4,%esp
  80249b:	68 68 40 80 00       	push   $0x804068
  8024a0:	68 9b 00 00 00       	push   $0x9b
  8024a5:	68 bf 3f 80 00       	push   $0x803fbf
  8024aa:	e8 f3 0f 00 00       	call   8034a2 <_panic>
  8024af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024b2:	8b 00                	mov    (%eax),%eax
  8024b4:	85 c0                	test   %eax,%eax
  8024b6:	74 10                	je     8024c8 <alloc_block_FF+0x11d>
  8024b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024bb:	8b 00                	mov    (%eax),%eax
  8024bd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024c0:	8b 52 04             	mov    0x4(%edx),%edx
  8024c3:	89 50 04             	mov    %edx,0x4(%eax)
  8024c6:	eb 0b                	jmp    8024d3 <alloc_block_FF+0x128>
  8024c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024cb:	8b 40 04             	mov    0x4(%eax),%eax
  8024ce:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8024d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d6:	8b 40 04             	mov    0x4(%eax),%eax
  8024d9:	85 c0                	test   %eax,%eax
  8024db:	74 0f                	je     8024ec <alloc_block_FF+0x141>
  8024dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e0:	8b 40 04             	mov    0x4(%eax),%eax
  8024e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024e6:	8b 12                	mov    (%edx),%edx
  8024e8:	89 10                	mov    %edx,(%eax)
  8024ea:	eb 0a                	jmp    8024f6 <alloc_block_FF+0x14b>
  8024ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ef:	8b 00                	mov    (%eax),%eax
  8024f1:	a3 48 51 80 00       	mov    %eax,0x805148
  8024f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802502:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802509:	a1 54 51 80 00       	mov    0x805154,%eax
  80250e:	48                   	dec    %eax
  80250f:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802514:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802517:	8b 50 08             	mov    0x8(%eax),%edx
  80251a:	8b 45 08             	mov    0x8(%ebp),%eax
  80251d:	01 c2                	add    %eax,%edx
  80251f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802522:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802525:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802528:	8b 40 0c             	mov    0xc(%eax),%eax
  80252b:	2b 45 08             	sub    0x8(%ebp),%eax
  80252e:	89 c2                	mov    %eax,%edx
  802530:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802533:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802536:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802539:	eb 3b                	jmp    802576 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80253b:	a1 40 51 80 00       	mov    0x805140,%eax
  802540:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802543:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802547:	74 07                	je     802550 <alloc_block_FF+0x1a5>
  802549:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254c:	8b 00                	mov    (%eax),%eax
  80254e:	eb 05                	jmp    802555 <alloc_block_FF+0x1aa>
  802550:	b8 00 00 00 00       	mov    $0x0,%eax
  802555:	a3 40 51 80 00       	mov    %eax,0x805140
  80255a:	a1 40 51 80 00       	mov    0x805140,%eax
  80255f:	85 c0                	test   %eax,%eax
  802561:	0f 85 57 fe ff ff    	jne    8023be <alloc_block_FF+0x13>
  802567:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80256b:	0f 85 4d fe ff ff    	jne    8023be <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802571:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802576:	c9                   	leave  
  802577:	c3                   	ret    

00802578 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802578:	55                   	push   %ebp
  802579:	89 e5                	mov    %esp,%ebp
  80257b:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  80257e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802585:	a1 38 51 80 00       	mov    0x805138,%eax
  80258a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80258d:	e9 df 00 00 00       	jmp    802671 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802592:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802595:	8b 40 0c             	mov    0xc(%eax),%eax
  802598:	3b 45 08             	cmp    0x8(%ebp),%eax
  80259b:	0f 82 c8 00 00 00    	jb     802669 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8025a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8025a7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025aa:	0f 85 8a 00 00 00    	jne    80263a <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8025b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025b4:	75 17                	jne    8025cd <alloc_block_BF+0x55>
  8025b6:	83 ec 04             	sub    $0x4,%esp
  8025b9:	68 68 40 80 00       	push   $0x804068
  8025be:	68 b7 00 00 00       	push   $0xb7
  8025c3:	68 bf 3f 80 00       	push   $0x803fbf
  8025c8:	e8 d5 0e 00 00       	call   8034a2 <_panic>
  8025cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d0:	8b 00                	mov    (%eax),%eax
  8025d2:	85 c0                	test   %eax,%eax
  8025d4:	74 10                	je     8025e6 <alloc_block_BF+0x6e>
  8025d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d9:	8b 00                	mov    (%eax),%eax
  8025db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025de:	8b 52 04             	mov    0x4(%edx),%edx
  8025e1:	89 50 04             	mov    %edx,0x4(%eax)
  8025e4:	eb 0b                	jmp    8025f1 <alloc_block_BF+0x79>
  8025e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e9:	8b 40 04             	mov    0x4(%eax),%eax
  8025ec:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8025f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f4:	8b 40 04             	mov    0x4(%eax),%eax
  8025f7:	85 c0                	test   %eax,%eax
  8025f9:	74 0f                	je     80260a <alloc_block_BF+0x92>
  8025fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fe:	8b 40 04             	mov    0x4(%eax),%eax
  802601:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802604:	8b 12                	mov    (%edx),%edx
  802606:	89 10                	mov    %edx,(%eax)
  802608:	eb 0a                	jmp    802614 <alloc_block_BF+0x9c>
  80260a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260d:	8b 00                	mov    (%eax),%eax
  80260f:	a3 38 51 80 00       	mov    %eax,0x805138
  802614:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802617:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80261d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802620:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802627:	a1 44 51 80 00       	mov    0x805144,%eax
  80262c:	48                   	dec    %eax
  80262d:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802632:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802635:	e9 4d 01 00 00       	jmp    802787 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  80263a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263d:	8b 40 0c             	mov    0xc(%eax),%eax
  802640:	3b 45 08             	cmp    0x8(%ebp),%eax
  802643:	76 24                	jbe    802669 <alloc_block_BF+0xf1>
  802645:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802648:	8b 40 0c             	mov    0xc(%eax),%eax
  80264b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80264e:	73 19                	jae    802669 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802650:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802657:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265a:	8b 40 0c             	mov    0xc(%eax),%eax
  80265d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802660:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802663:	8b 40 08             	mov    0x8(%eax),%eax
  802666:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802669:	a1 40 51 80 00       	mov    0x805140,%eax
  80266e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802671:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802675:	74 07                	je     80267e <alloc_block_BF+0x106>
  802677:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267a:	8b 00                	mov    (%eax),%eax
  80267c:	eb 05                	jmp    802683 <alloc_block_BF+0x10b>
  80267e:	b8 00 00 00 00       	mov    $0x0,%eax
  802683:	a3 40 51 80 00       	mov    %eax,0x805140
  802688:	a1 40 51 80 00       	mov    0x805140,%eax
  80268d:	85 c0                	test   %eax,%eax
  80268f:	0f 85 fd fe ff ff    	jne    802592 <alloc_block_BF+0x1a>
  802695:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802699:	0f 85 f3 fe ff ff    	jne    802592 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  80269f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8026a3:	0f 84 d9 00 00 00    	je     802782 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8026a9:	a1 48 51 80 00       	mov    0x805148,%eax
  8026ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8026b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026b4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026b7:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8026ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8026c0:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8026c3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8026c7:	75 17                	jne    8026e0 <alloc_block_BF+0x168>
  8026c9:	83 ec 04             	sub    $0x4,%esp
  8026cc:	68 68 40 80 00       	push   $0x804068
  8026d1:	68 c7 00 00 00       	push   $0xc7
  8026d6:	68 bf 3f 80 00       	push   $0x803fbf
  8026db:	e8 c2 0d 00 00       	call   8034a2 <_panic>
  8026e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026e3:	8b 00                	mov    (%eax),%eax
  8026e5:	85 c0                	test   %eax,%eax
  8026e7:	74 10                	je     8026f9 <alloc_block_BF+0x181>
  8026e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026ec:	8b 00                	mov    (%eax),%eax
  8026ee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026f1:	8b 52 04             	mov    0x4(%edx),%edx
  8026f4:	89 50 04             	mov    %edx,0x4(%eax)
  8026f7:	eb 0b                	jmp    802704 <alloc_block_BF+0x18c>
  8026f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026fc:	8b 40 04             	mov    0x4(%eax),%eax
  8026ff:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802704:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802707:	8b 40 04             	mov    0x4(%eax),%eax
  80270a:	85 c0                	test   %eax,%eax
  80270c:	74 0f                	je     80271d <alloc_block_BF+0x1a5>
  80270e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802711:	8b 40 04             	mov    0x4(%eax),%eax
  802714:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802717:	8b 12                	mov    (%edx),%edx
  802719:	89 10                	mov    %edx,(%eax)
  80271b:	eb 0a                	jmp    802727 <alloc_block_BF+0x1af>
  80271d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802720:	8b 00                	mov    (%eax),%eax
  802722:	a3 48 51 80 00       	mov    %eax,0x805148
  802727:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80272a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802730:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802733:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80273a:	a1 54 51 80 00       	mov    0x805154,%eax
  80273f:	48                   	dec    %eax
  802740:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802745:	83 ec 08             	sub    $0x8,%esp
  802748:	ff 75 ec             	pushl  -0x14(%ebp)
  80274b:	68 38 51 80 00       	push   $0x805138
  802750:	e8 71 f9 ff ff       	call   8020c6 <find_block>
  802755:	83 c4 10             	add    $0x10,%esp
  802758:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  80275b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80275e:	8b 50 08             	mov    0x8(%eax),%edx
  802761:	8b 45 08             	mov    0x8(%ebp),%eax
  802764:	01 c2                	add    %eax,%edx
  802766:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802769:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  80276c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80276f:	8b 40 0c             	mov    0xc(%eax),%eax
  802772:	2b 45 08             	sub    0x8(%ebp),%eax
  802775:	89 c2                	mov    %eax,%edx
  802777:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80277a:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  80277d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802780:	eb 05                	jmp    802787 <alloc_block_BF+0x20f>
	}
	return NULL;
  802782:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802787:	c9                   	leave  
  802788:	c3                   	ret    

00802789 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802789:	55                   	push   %ebp
  80278a:	89 e5                	mov    %esp,%ebp
  80278c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  80278f:	a1 28 50 80 00       	mov    0x805028,%eax
  802794:	85 c0                	test   %eax,%eax
  802796:	0f 85 de 01 00 00    	jne    80297a <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80279c:	a1 38 51 80 00       	mov    0x805138,%eax
  8027a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027a4:	e9 9e 01 00 00       	jmp    802947 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8027a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8027af:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027b2:	0f 82 87 01 00 00    	jb     80293f <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8027b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8027be:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027c1:	0f 85 95 00 00 00    	jne    80285c <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8027c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027cb:	75 17                	jne    8027e4 <alloc_block_NF+0x5b>
  8027cd:	83 ec 04             	sub    $0x4,%esp
  8027d0:	68 68 40 80 00       	push   $0x804068
  8027d5:	68 e0 00 00 00       	push   $0xe0
  8027da:	68 bf 3f 80 00       	push   $0x803fbf
  8027df:	e8 be 0c 00 00       	call   8034a2 <_panic>
  8027e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e7:	8b 00                	mov    (%eax),%eax
  8027e9:	85 c0                	test   %eax,%eax
  8027eb:	74 10                	je     8027fd <alloc_block_NF+0x74>
  8027ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f0:	8b 00                	mov    (%eax),%eax
  8027f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027f5:	8b 52 04             	mov    0x4(%edx),%edx
  8027f8:	89 50 04             	mov    %edx,0x4(%eax)
  8027fb:	eb 0b                	jmp    802808 <alloc_block_NF+0x7f>
  8027fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802800:	8b 40 04             	mov    0x4(%eax),%eax
  802803:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802808:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280b:	8b 40 04             	mov    0x4(%eax),%eax
  80280e:	85 c0                	test   %eax,%eax
  802810:	74 0f                	je     802821 <alloc_block_NF+0x98>
  802812:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802815:	8b 40 04             	mov    0x4(%eax),%eax
  802818:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80281b:	8b 12                	mov    (%edx),%edx
  80281d:	89 10                	mov    %edx,(%eax)
  80281f:	eb 0a                	jmp    80282b <alloc_block_NF+0xa2>
  802821:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802824:	8b 00                	mov    (%eax),%eax
  802826:	a3 38 51 80 00       	mov    %eax,0x805138
  80282b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802834:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802837:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80283e:	a1 44 51 80 00       	mov    0x805144,%eax
  802843:	48                   	dec    %eax
  802844:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802849:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284c:	8b 40 08             	mov    0x8(%eax),%eax
  80284f:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802854:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802857:	e9 f8 04 00 00       	jmp    802d54 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  80285c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285f:	8b 40 0c             	mov    0xc(%eax),%eax
  802862:	3b 45 08             	cmp    0x8(%ebp),%eax
  802865:	0f 86 d4 00 00 00    	jbe    80293f <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80286b:	a1 48 51 80 00       	mov    0x805148,%eax
  802870:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802873:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802876:	8b 50 08             	mov    0x8(%eax),%edx
  802879:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80287c:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  80287f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802882:	8b 55 08             	mov    0x8(%ebp),%edx
  802885:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802888:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80288c:	75 17                	jne    8028a5 <alloc_block_NF+0x11c>
  80288e:	83 ec 04             	sub    $0x4,%esp
  802891:	68 68 40 80 00       	push   $0x804068
  802896:	68 e9 00 00 00       	push   $0xe9
  80289b:	68 bf 3f 80 00       	push   $0x803fbf
  8028a0:	e8 fd 0b 00 00       	call   8034a2 <_panic>
  8028a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a8:	8b 00                	mov    (%eax),%eax
  8028aa:	85 c0                	test   %eax,%eax
  8028ac:	74 10                	je     8028be <alloc_block_NF+0x135>
  8028ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b1:	8b 00                	mov    (%eax),%eax
  8028b3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028b6:	8b 52 04             	mov    0x4(%edx),%edx
  8028b9:	89 50 04             	mov    %edx,0x4(%eax)
  8028bc:	eb 0b                	jmp    8028c9 <alloc_block_NF+0x140>
  8028be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c1:	8b 40 04             	mov    0x4(%eax),%eax
  8028c4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028cc:	8b 40 04             	mov    0x4(%eax),%eax
  8028cf:	85 c0                	test   %eax,%eax
  8028d1:	74 0f                	je     8028e2 <alloc_block_NF+0x159>
  8028d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d6:	8b 40 04             	mov    0x4(%eax),%eax
  8028d9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028dc:	8b 12                	mov    (%edx),%edx
  8028de:	89 10                	mov    %edx,(%eax)
  8028e0:	eb 0a                	jmp    8028ec <alloc_block_NF+0x163>
  8028e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e5:	8b 00                	mov    (%eax),%eax
  8028e7:	a3 48 51 80 00       	mov    %eax,0x805148
  8028ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028ff:	a1 54 51 80 00       	mov    0x805154,%eax
  802904:	48                   	dec    %eax
  802905:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  80290a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80290d:	8b 40 08             	mov    0x8(%eax),%eax
  802910:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802915:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802918:	8b 50 08             	mov    0x8(%eax),%edx
  80291b:	8b 45 08             	mov    0x8(%ebp),%eax
  80291e:	01 c2                	add    %eax,%edx
  802920:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802923:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802926:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802929:	8b 40 0c             	mov    0xc(%eax),%eax
  80292c:	2b 45 08             	sub    0x8(%ebp),%eax
  80292f:	89 c2                	mov    %eax,%edx
  802931:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802934:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802937:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293a:	e9 15 04 00 00       	jmp    802d54 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80293f:	a1 40 51 80 00       	mov    0x805140,%eax
  802944:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802947:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80294b:	74 07                	je     802954 <alloc_block_NF+0x1cb>
  80294d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802950:	8b 00                	mov    (%eax),%eax
  802952:	eb 05                	jmp    802959 <alloc_block_NF+0x1d0>
  802954:	b8 00 00 00 00       	mov    $0x0,%eax
  802959:	a3 40 51 80 00       	mov    %eax,0x805140
  80295e:	a1 40 51 80 00       	mov    0x805140,%eax
  802963:	85 c0                	test   %eax,%eax
  802965:	0f 85 3e fe ff ff    	jne    8027a9 <alloc_block_NF+0x20>
  80296b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80296f:	0f 85 34 fe ff ff    	jne    8027a9 <alloc_block_NF+0x20>
  802975:	e9 d5 03 00 00       	jmp    802d4f <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80297a:	a1 38 51 80 00       	mov    0x805138,%eax
  80297f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802982:	e9 b1 01 00 00       	jmp    802b38 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802987:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298a:	8b 50 08             	mov    0x8(%eax),%edx
  80298d:	a1 28 50 80 00       	mov    0x805028,%eax
  802992:	39 c2                	cmp    %eax,%edx
  802994:	0f 82 96 01 00 00    	jb     802b30 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  80299a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299d:	8b 40 0c             	mov    0xc(%eax),%eax
  8029a0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029a3:	0f 82 87 01 00 00    	jb     802b30 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8029a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8029af:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029b2:	0f 85 95 00 00 00    	jne    802a4d <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8029b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029bc:	75 17                	jne    8029d5 <alloc_block_NF+0x24c>
  8029be:	83 ec 04             	sub    $0x4,%esp
  8029c1:	68 68 40 80 00       	push   $0x804068
  8029c6:	68 fc 00 00 00       	push   $0xfc
  8029cb:	68 bf 3f 80 00       	push   $0x803fbf
  8029d0:	e8 cd 0a 00 00       	call   8034a2 <_panic>
  8029d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d8:	8b 00                	mov    (%eax),%eax
  8029da:	85 c0                	test   %eax,%eax
  8029dc:	74 10                	je     8029ee <alloc_block_NF+0x265>
  8029de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e1:	8b 00                	mov    (%eax),%eax
  8029e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029e6:	8b 52 04             	mov    0x4(%edx),%edx
  8029e9:	89 50 04             	mov    %edx,0x4(%eax)
  8029ec:	eb 0b                	jmp    8029f9 <alloc_block_NF+0x270>
  8029ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f1:	8b 40 04             	mov    0x4(%eax),%eax
  8029f4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8029f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fc:	8b 40 04             	mov    0x4(%eax),%eax
  8029ff:	85 c0                	test   %eax,%eax
  802a01:	74 0f                	je     802a12 <alloc_block_NF+0x289>
  802a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a06:	8b 40 04             	mov    0x4(%eax),%eax
  802a09:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a0c:	8b 12                	mov    (%edx),%edx
  802a0e:	89 10                	mov    %edx,(%eax)
  802a10:	eb 0a                	jmp    802a1c <alloc_block_NF+0x293>
  802a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a15:	8b 00                	mov    (%eax),%eax
  802a17:	a3 38 51 80 00       	mov    %eax,0x805138
  802a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a28:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a2f:	a1 44 51 80 00       	mov    0x805144,%eax
  802a34:	48                   	dec    %eax
  802a35:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802a3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3d:	8b 40 08             	mov    0x8(%eax),%eax
  802a40:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a48:	e9 07 03 00 00       	jmp    802d54 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a50:	8b 40 0c             	mov    0xc(%eax),%eax
  802a53:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a56:	0f 86 d4 00 00 00    	jbe    802b30 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a5c:	a1 48 51 80 00       	mov    0x805148,%eax
  802a61:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a67:	8b 50 08             	mov    0x8(%eax),%edx
  802a6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a6d:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802a70:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a73:	8b 55 08             	mov    0x8(%ebp),%edx
  802a76:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802a79:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a7d:	75 17                	jne    802a96 <alloc_block_NF+0x30d>
  802a7f:	83 ec 04             	sub    $0x4,%esp
  802a82:	68 68 40 80 00       	push   $0x804068
  802a87:	68 04 01 00 00       	push   $0x104
  802a8c:	68 bf 3f 80 00       	push   $0x803fbf
  802a91:	e8 0c 0a 00 00       	call   8034a2 <_panic>
  802a96:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a99:	8b 00                	mov    (%eax),%eax
  802a9b:	85 c0                	test   %eax,%eax
  802a9d:	74 10                	je     802aaf <alloc_block_NF+0x326>
  802a9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aa2:	8b 00                	mov    (%eax),%eax
  802aa4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802aa7:	8b 52 04             	mov    0x4(%edx),%edx
  802aaa:	89 50 04             	mov    %edx,0x4(%eax)
  802aad:	eb 0b                	jmp    802aba <alloc_block_NF+0x331>
  802aaf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ab2:	8b 40 04             	mov    0x4(%eax),%eax
  802ab5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802aba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802abd:	8b 40 04             	mov    0x4(%eax),%eax
  802ac0:	85 c0                	test   %eax,%eax
  802ac2:	74 0f                	je     802ad3 <alloc_block_NF+0x34a>
  802ac4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ac7:	8b 40 04             	mov    0x4(%eax),%eax
  802aca:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802acd:	8b 12                	mov    (%edx),%edx
  802acf:	89 10                	mov    %edx,(%eax)
  802ad1:	eb 0a                	jmp    802add <alloc_block_NF+0x354>
  802ad3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ad6:	8b 00                	mov    (%eax),%eax
  802ad8:	a3 48 51 80 00       	mov    %eax,0x805148
  802add:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ae0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ae6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ae9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802af0:	a1 54 51 80 00       	mov    0x805154,%eax
  802af5:	48                   	dec    %eax
  802af6:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802afb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802afe:	8b 40 08             	mov    0x8(%eax),%eax
  802b01:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802b06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b09:	8b 50 08             	mov    0x8(%eax),%edx
  802b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0f:	01 c2                	add    %eax,%edx
  802b11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b14:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802b17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1a:	8b 40 0c             	mov    0xc(%eax),%eax
  802b1d:	2b 45 08             	sub    0x8(%ebp),%eax
  802b20:	89 c2                	mov    %eax,%edx
  802b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b25:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802b28:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b2b:	e9 24 02 00 00       	jmp    802d54 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b30:	a1 40 51 80 00       	mov    0x805140,%eax
  802b35:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b38:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b3c:	74 07                	je     802b45 <alloc_block_NF+0x3bc>
  802b3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b41:	8b 00                	mov    (%eax),%eax
  802b43:	eb 05                	jmp    802b4a <alloc_block_NF+0x3c1>
  802b45:	b8 00 00 00 00       	mov    $0x0,%eax
  802b4a:	a3 40 51 80 00       	mov    %eax,0x805140
  802b4f:	a1 40 51 80 00       	mov    0x805140,%eax
  802b54:	85 c0                	test   %eax,%eax
  802b56:	0f 85 2b fe ff ff    	jne    802987 <alloc_block_NF+0x1fe>
  802b5c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b60:	0f 85 21 fe ff ff    	jne    802987 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b66:	a1 38 51 80 00       	mov    0x805138,%eax
  802b6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b6e:	e9 ae 01 00 00       	jmp    802d21 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b76:	8b 50 08             	mov    0x8(%eax),%edx
  802b79:	a1 28 50 80 00       	mov    0x805028,%eax
  802b7e:	39 c2                	cmp    %eax,%edx
  802b80:	0f 83 93 01 00 00    	jae    802d19 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802b86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b89:	8b 40 0c             	mov    0xc(%eax),%eax
  802b8c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b8f:	0f 82 84 01 00 00    	jb     802d19 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b98:	8b 40 0c             	mov    0xc(%eax),%eax
  802b9b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b9e:	0f 85 95 00 00 00    	jne    802c39 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802ba4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ba8:	75 17                	jne    802bc1 <alloc_block_NF+0x438>
  802baa:	83 ec 04             	sub    $0x4,%esp
  802bad:	68 68 40 80 00       	push   $0x804068
  802bb2:	68 14 01 00 00       	push   $0x114
  802bb7:	68 bf 3f 80 00       	push   $0x803fbf
  802bbc:	e8 e1 08 00 00       	call   8034a2 <_panic>
  802bc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc4:	8b 00                	mov    (%eax),%eax
  802bc6:	85 c0                	test   %eax,%eax
  802bc8:	74 10                	je     802bda <alloc_block_NF+0x451>
  802bca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcd:	8b 00                	mov    (%eax),%eax
  802bcf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bd2:	8b 52 04             	mov    0x4(%edx),%edx
  802bd5:	89 50 04             	mov    %edx,0x4(%eax)
  802bd8:	eb 0b                	jmp    802be5 <alloc_block_NF+0x45c>
  802bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdd:	8b 40 04             	mov    0x4(%eax),%eax
  802be0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802be5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be8:	8b 40 04             	mov    0x4(%eax),%eax
  802beb:	85 c0                	test   %eax,%eax
  802bed:	74 0f                	je     802bfe <alloc_block_NF+0x475>
  802bef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf2:	8b 40 04             	mov    0x4(%eax),%eax
  802bf5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bf8:	8b 12                	mov    (%edx),%edx
  802bfa:	89 10                	mov    %edx,(%eax)
  802bfc:	eb 0a                	jmp    802c08 <alloc_block_NF+0x47f>
  802bfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c01:	8b 00                	mov    (%eax),%eax
  802c03:	a3 38 51 80 00       	mov    %eax,0x805138
  802c08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c14:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c1b:	a1 44 51 80 00       	mov    0x805144,%eax
  802c20:	48                   	dec    %eax
  802c21:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802c26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c29:	8b 40 08             	mov    0x8(%eax),%eax
  802c2c:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c34:	e9 1b 01 00 00       	jmp    802d54 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3c:	8b 40 0c             	mov    0xc(%eax),%eax
  802c3f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c42:	0f 86 d1 00 00 00    	jbe    802d19 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802c48:	a1 48 51 80 00       	mov    0x805148,%eax
  802c4d:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802c50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c53:	8b 50 08             	mov    0x8(%eax),%edx
  802c56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c59:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802c5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c5f:	8b 55 08             	mov    0x8(%ebp),%edx
  802c62:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802c65:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c69:	75 17                	jne    802c82 <alloc_block_NF+0x4f9>
  802c6b:	83 ec 04             	sub    $0x4,%esp
  802c6e:	68 68 40 80 00       	push   $0x804068
  802c73:	68 1c 01 00 00       	push   $0x11c
  802c78:	68 bf 3f 80 00       	push   $0x803fbf
  802c7d:	e8 20 08 00 00       	call   8034a2 <_panic>
  802c82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c85:	8b 00                	mov    (%eax),%eax
  802c87:	85 c0                	test   %eax,%eax
  802c89:	74 10                	je     802c9b <alloc_block_NF+0x512>
  802c8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c8e:	8b 00                	mov    (%eax),%eax
  802c90:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c93:	8b 52 04             	mov    0x4(%edx),%edx
  802c96:	89 50 04             	mov    %edx,0x4(%eax)
  802c99:	eb 0b                	jmp    802ca6 <alloc_block_NF+0x51d>
  802c9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c9e:	8b 40 04             	mov    0x4(%eax),%eax
  802ca1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ca6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ca9:	8b 40 04             	mov    0x4(%eax),%eax
  802cac:	85 c0                	test   %eax,%eax
  802cae:	74 0f                	je     802cbf <alloc_block_NF+0x536>
  802cb0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cb3:	8b 40 04             	mov    0x4(%eax),%eax
  802cb6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cb9:	8b 12                	mov    (%edx),%edx
  802cbb:	89 10                	mov    %edx,(%eax)
  802cbd:	eb 0a                	jmp    802cc9 <alloc_block_NF+0x540>
  802cbf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cc2:	8b 00                	mov    (%eax),%eax
  802cc4:	a3 48 51 80 00       	mov    %eax,0x805148
  802cc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ccc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cd2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cd5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cdc:	a1 54 51 80 00       	mov    0x805154,%eax
  802ce1:	48                   	dec    %eax
  802ce2:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802ce7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cea:	8b 40 08             	mov    0x8(%eax),%eax
  802ced:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802cf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf5:	8b 50 08             	mov    0x8(%eax),%edx
  802cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfb:	01 c2                	add    %eax,%edx
  802cfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d00:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802d03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d06:	8b 40 0c             	mov    0xc(%eax),%eax
  802d09:	2b 45 08             	sub    0x8(%ebp),%eax
  802d0c:	89 c2                	mov    %eax,%edx
  802d0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d11:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802d14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d17:	eb 3b                	jmp    802d54 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802d19:	a1 40 51 80 00       	mov    0x805140,%eax
  802d1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d21:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d25:	74 07                	je     802d2e <alloc_block_NF+0x5a5>
  802d27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2a:	8b 00                	mov    (%eax),%eax
  802d2c:	eb 05                	jmp    802d33 <alloc_block_NF+0x5aa>
  802d2e:	b8 00 00 00 00       	mov    $0x0,%eax
  802d33:	a3 40 51 80 00       	mov    %eax,0x805140
  802d38:	a1 40 51 80 00       	mov    0x805140,%eax
  802d3d:	85 c0                	test   %eax,%eax
  802d3f:	0f 85 2e fe ff ff    	jne    802b73 <alloc_block_NF+0x3ea>
  802d45:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d49:	0f 85 24 fe ff ff    	jne    802b73 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802d4f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d54:	c9                   	leave  
  802d55:	c3                   	ret    

00802d56 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802d56:	55                   	push   %ebp
  802d57:	89 e5                	mov    %esp,%ebp
  802d59:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802d5c:	a1 38 51 80 00       	mov    0x805138,%eax
  802d61:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802d64:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d69:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802d6c:	a1 38 51 80 00       	mov    0x805138,%eax
  802d71:	85 c0                	test   %eax,%eax
  802d73:	74 14                	je     802d89 <insert_sorted_with_merge_freeList+0x33>
  802d75:	8b 45 08             	mov    0x8(%ebp),%eax
  802d78:	8b 50 08             	mov    0x8(%eax),%edx
  802d7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d7e:	8b 40 08             	mov    0x8(%eax),%eax
  802d81:	39 c2                	cmp    %eax,%edx
  802d83:	0f 87 9b 01 00 00    	ja     802f24 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802d89:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d8d:	75 17                	jne    802da6 <insert_sorted_with_merge_freeList+0x50>
  802d8f:	83 ec 04             	sub    $0x4,%esp
  802d92:	68 9c 3f 80 00       	push   $0x803f9c
  802d97:	68 38 01 00 00       	push   $0x138
  802d9c:	68 bf 3f 80 00       	push   $0x803fbf
  802da1:	e8 fc 06 00 00       	call   8034a2 <_panic>
  802da6:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802dac:	8b 45 08             	mov    0x8(%ebp),%eax
  802daf:	89 10                	mov    %edx,(%eax)
  802db1:	8b 45 08             	mov    0x8(%ebp),%eax
  802db4:	8b 00                	mov    (%eax),%eax
  802db6:	85 c0                	test   %eax,%eax
  802db8:	74 0d                	je     802dc7 <insert_sorted_with_merge_freeList+0x71>
  802dba:	a1 38 51 80 00       	mov    0x805138,%eax
  802dbf:	8b 55 08             	mov    0x8(%ebp),%edx
  802dc2:	89 50 04             	mov    %edx,0x4(%eax)
  802dc5:	eb 08                	jmp    802dcf <insert_sorted_with_merge_freeList+0x79>
  802dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dca:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd2:	a3 38 51 80 00       	mov    %eax,0x805138
  802dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dda:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802de1:	a1 44 51 80 00       	mov    0x805144,%eax
  802de6:	40                   	inc    %eax
  802de7:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802dec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802df0:	0f 84 a8 06 00 00    	je     80349e <insert_sorted_with_merge_freeList+0x748>
  802df6:	8b 45 08             	mov    0x8(%ebp),%eax
  802df9:	8b 50 08             	mov    0x8(%eax),%edx
  802dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dff:	8b 40 0c             	mov    0xc(%eax),%eax
  802e02:	01 c2                	add    %eax,%edx
  802e04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e07:	8b 40 08             	mov    0x8(%eax),%eax
  802e0a:	39 c2                	cmp    %eax,%edx
  802e0c:	0f 85 8c 06 00 00    	jne    80349e <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802e12:	8b 45 08             	mov    0x8(%ebp),%eax
  802e15:	8b 50 0c             	mov    0xc(%eax),%edx
  802e18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e1b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e1e:	01 c2                	add    %eax,%edx
  802e20:	8b 45 08             	mov    0x8(%ebp),%eax
  802e23:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802e26:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e2a:	75 17                	jne    802e43 <insert_sorted_with_merge_freeList+0xed>
  802e2c:	83 ec 04             	sub    $0x4,%esp
  802e2f:	68 68 40 80 00       	push   $0x804068
  802e34:	68 3c 01 00 00       	push   $0x13c
  802e39:	68 bf 3f 80 00       	push   $0x803fbf
  802e3e:	e8 5f 06 00 00       	call   8034a2 <_panic>
  802e43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e46:	8b 00                	mov    (%eax),%eax
  802e48:	85 c0                	test   %eax,%eax
  802e4a:	74 10                	je     802e5c <insert_sorted_with_merge_freeList+0x106>
  802e4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e4f:	8b 00                	mov    (%eax),%eax
  802e51:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e54:	8b 52 04             	mov    0x4(%edx),%edx
  802e57:	89 50 04             	mov    %edx,0x4(%eax)
  802e5a:	eb 0b                	jmp    802e67 <insert_sorted_with_merge_freeList+0x111>
  802e5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e5f:	8b 40 04             	mov    0x4(%eax),%eax
  802e62:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e6a:	8b 40 04             	mov    0x4(%eax),%eax
  802e6d:	85 c0                	test   %eax,%eax
  802e6f:	74 0f                	je     802e80 <insert_sorted_with_merge_freeList+0x12a>
  802e71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e74:	8b 40 04             	mov    0x4(%eax),%eax
  802e77:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e7a:	8b 12                	mov    (%edx),%edx
  802e7c:	89 10                	mov    %edx,(%eax)
  802e7e:	eb 0a                	jmp    802e8a <insert_sorted_with_merge_freeList+0x134>
  802e80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e83:	8b 00                	mov    (%eax),%eax
  802e85:	a3 38 51 80 00       	mov    %eax,0x805138
  802e8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e8d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e96:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e9d:	a1 44 51 80 00       	mov    0x805144,%eax
  802ea2:	48                   	dec    %eax
  802ea3:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802ea8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eab:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802eb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802ebc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ec0:	75 17                	jne    802ed9 <insert_sorted_with_merge_freeList+0x183>
  802ec2:	83 ec 04             	sub    $0x4,%esp
  802ec5:	68 9c 3f 80 00       	push   $0x803f9c
  802eca:	68 3f 01 00 00       	push   $0x13f
  802ecf:	68 bf 3f 80 00       	push   $0x803fbf
  802ed4:	e8 c9 05 00 00       	call   8034a2 <_panic>
  802ed9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802edf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee2:	89 10                	mov    %edx,(%eax)
  802ee4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee7:	8b 00                	mov    (%eax),%eax
  802ee9:	85 c0                	test   %eax,%eax
  802eeb:	74 0d                	je     802efa <insert_sorted_with_merge_freeList+0x1a4>
  802eed:	a1 48 51 80 00       	mov    0x805148,%eax
  802ef2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ef5:	89 50 04             	mov    %edx,0x4(%eax)
  802ef8:	eb 08                	jmp    802f02 <insert_sorted_with_merge_freeList+0x1ac>
  802efa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802efd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f05:	a3 48 51 80 00       	mov    %eax,0x805148
  802f0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f0d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f14:	a1 54 51 80 00       	mov    0x805154,%eax
  802f19:	40                   	inc    %eax
  802f1a:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802f1f:	e9 7a 05 00 00       	jmp    80349e <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802f24:	8b 45 08             	mov    0x8(%ebp),%eax
  802f27:	8b 50 08             	mov    0x8(%eax),%edx
  802f2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f2d:	8b 40 08             	mov    0x8(%eax),%eax
  802f30:	39 c2                	cmp    %eax,%edx
  802f32:	0f 82 14 01 00 00    	jb     80304c <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802f38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f3b:	8b 50 08             	mov    0x8(%eax),%edx
  802f3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f41:	8b 40 0c             	mov    0xc(%eax),%eax
  802f44:	01 c2                	add    %eax,%edx
  802f46:	8b 45 08             	mov    0x8(%ebp),%eax
  802f49:	8b 40 08             	mov    0x8(%eax),%eax
  802f4c:	39 c2                	cmp    %eax,%edx
  802f4e:	0f 85 90 00 00 00    	jne    802fe4 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802f54:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f57:	8b 50 0c             	mov    0xc(%eax),%edx
  802f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5d:	8b 40 0c             	mov    0xc(%eax),%eax
  802f60:	01 c2                	add    %eax,%edx
  802f62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f65:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802f68:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802f72:	8b 45 08             	mov    0x8(%ebp),%eax
  802f75:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802f7c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f80:	75 17                	jne    802f99 <insert_sorted_with_merge_freeList+0x243>
  802f82:	83 ec 04             	sub    $0x4,%esp
  802f85:	68 9c 3f 80 00       	push   $0x803f9c
  802f8a:	68 49 01 00 00       	push   $0x149
  802f8f:	68 bf 3f 80 00       	push   $0x803fbf
  802f94:	e8 09 05 00 00       	call   8034a2 <_panic>
  802f99:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa2:	89 10                	mov    %edx,(%eax)
  802fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa7:	8b 00                	mov    (%eax),%eax
  802fa9:	85 c0                	test   %eax,%eax
  802fab:	74 0d                	je     802fba <insert_sorted_with_merge_freeList+0x264>
  802fad:	a1 48 51 80 00       	mov    0x805148,%eax
  802fb2:	8b 55 08             	mov    0x8(%ebp),%edx
  802fb5:	89 50 04             	mov    %edx,0x4(%eax)
  802fb8:	eb 08                	jmp    802fc2 <insert_sorted_with_merge_freeList+0x26c>
  802fba:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc5:	a3 48 51 80 00       	mov    %eax,0x805148
  802fca:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fd4:	a1 54 51 80 00       	mov    0x805154,%eax
  802fd9:	40                   	inc    %eax
  802fda:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802fdf:	e9 bb 04 00 00       	jmp    80349f <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802fe4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fe8:	75 17                	jne    803001 <insert_sorted_with_merge_freeList+0x2ab>
  802fea:	83 ec 04             	sub    $0x4,%esp
  802fed:	68 10 40 80 00       	push   $0x804010
  802ff2:	68 4c 01 00 00       	push   $0x14c
  802ff7:	68 bf 3f 80 00       	push   $0x803fbf
  802ffc:	e8 a1 04 00 00       	call   8034a2 <_panic>
  803001:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803007:	8b 45 08             	mov    0x8(%ebp),%eax
  80300a:	89 50 04             	mov    %edx,0x4(%eax)
  80300d:	8b 45 08             	mov    0x8(%ebp),%eax
  803010:	8b 40 04             	mov    0x4(%eax),%eax
  803013:	85 c0                	test   %eax,%eax
  803015:	74 0c                	je     803023 <insert_sorted_with_merge_freeList+0x2cd>
  803017:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80301c:	8b 55 08             	mov    0x8(%ebp),%edx
  80301f:	89 10                	mov    %edx,(%eax)
  803021:	eb 08                	jmp    80302b <insert_sorted_with_merge_freeList+0x2d5>
  803023:	8b 45 08             	mov    0x8(%ebp),%eax
  803026:	a3 38 51 80 00       	mov    %eax,0x805138
  80302b:	8b 45 08             	mov    0x8(%ebp),%eax
  80302e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803033:	8b 45 08             	mov    0x8(%ebp),%eax
  803036:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80303c:	a1 44 51 80 00       	mov    0x805144,%eax
  803041:	40                   	inc    %eax
  803042:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803047:	e9 53 04 00 00       	jmp    80349f <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80304c:	a1 38 51 80 00       	mov    0x805138,%eax
  803051:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803054:	e9 15 04 00 00       	jmp    80346e <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803059:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305c:	8b 00                	mov    (%eax),%eax
  80305e:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803061:	8b 45 08             	mov    0x8(%ebp),%eax
  803064:	8b 50 08             	mov    0x8(%eax),%edx
  803067:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306a:	8b 40 08             	mov    0x8(%eax),%eax
  80306d:	39 c2                	cmp    %eax,%edx
  80306f:	0f 86 f1 03 00 00    	jbe    803466 <insert_sorted_with_merge_freeList+0x710>
  803075:	8b 45 08             	mov    0x8(%ebp),%eax
  803078:	8b 50 08             	mov    0x8(%eax),%edx
  80307b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80307e:	8b 40 08             	mov    0x8(%eax),%eax
  803081:	39 c2                	cmp    %eax,%edx
  803083:	0f 83 dd 03 00 00    	jae    803466 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803089:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308c:	8b 50 08             	mov    0x8(%eax),%edx
  80308f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803092:	8b 40 0c             	mov    0xc(%eax),%eax
  803095:	01 c2                	add    %eax,%edx
  803097:	8b 45 08             	mov    0x8(%ebp),%eax
  80309a:	8b 40 08             	mov    0x8(%eax),%eax
  80309d:	39 c2                	cmp    %eax,%edx
  80309f:	0f 85 b9 01 00 00    	jne    80325e <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8030a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a8:	8b 50 08             	mov    0x8(%eax),%edx
  8030ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8030b1:	01 c2                	add    %eax,%edx
  8030b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b6:	8b 40 08             	mov    0x8(%eax),%eax
  8030b9:	39 c2                	cmp    %eax,%edx
  8030bb:	0f 85 0d 01 00 00    	jne    8031ce <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8030c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c4:	8b 50 0c             	mov    0xc(%eax),%edx
  8030c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8030cd:	01 c2                	add    %eax,%edx
  8030cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d2:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8030d5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030d9:	75 17                	jne    8030f2 <insert_sorted_with_merge_freeList+0x39c>
  8030db:	83 ec 04             	sub    $0x4,%esp
  8030de:	68 68 40 80 00       	push   $0x804068
  8030e3:	68 5c 01 00 00       	push   $0x15c
  8030e8:	68 bf 3f 80 00       	push   $0x803fbf
  8030ed:	e8 b0 03 00 00       	call   8034a2 <_panic>
  8030f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f5:	8b 00                	mov    (%eax),%eax
  8030f7:	85 c0                	test   %eax,%eax
  8030f9:	74 10                	je     80310b <insert_sorted_with_merge_freeList+0x3b5>
  8030fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030fe:	8b 00                	mov    (%eax),%eax
  803100:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803103:	8b 52 04             	mov    0x4(%edx),%edx
  803106:	89 50 04             	mov    %edx,0x4(%eax)
  803109:	eb 0b                	jmp    803116 <insert_sorted_with_merge_freeList+0x3c0>
  80310b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80310e:	8b 40 04             	mov    0x4(%eax),%eax
  803111:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803116:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803119:	8b 40 04             	mov    0x4(%eax),%eax
  80311c:	85 c0                	test   %eax,%eax
  80311e:	74 0f                	je     80312f <insert_sorted_with_merge_freeList+0x3d9>
  803120:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803123:	8b 40 04             	mov    0x4(%eax),%eax
  803126:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803129:	8b 12                	mov    (%edx),%edx
  80312b:	89 10                	mov    %edx,(%eax)
  80312d:	eb 0a                	jmp    803139 <insert_sorted_with_merge_freeList+0x3e3>
  80312f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803132:	8b 00                	mov    (%eax),%eax
  803134:	a3 38 51 80 00       	mov    %eax,0x805138
  803139:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80313c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803142:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803145:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80314c:	a1 44 51 80 00       	mov    0x805144,%eax
  803151:	48                   	dec    %eax
  803152:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803157:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80315a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803161:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803164:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80316b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80316f:	75 17                	jne    803188 <insert_sorted_with_merge_freeList+0x432>
  803171:	83 ec 04             	sub    $0x4,%esp
  803174:	68 9c 3f 80 00       	push   $0x803f9c
  803179:	68 5f 01 00 00       	push   $0x15f
  80317e:	68 bf 3f 80 00       	push   $0x803fbf
  803183:	e8 1a 03 00 00       	call   8034a2 <_panic>
  803188:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80318e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803191:	89 10                	mov    %edx,(%eax)
  803193:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803196:	8b 00                	mov    (%eax),%eax
  803198:	85 c0                	test   %eax,%eax
  80319a:	74 0d                	je     8031a9 <insert_sorted_with_merge_freeList+0x453>
  80319c:	a1 48 51 80 00       	mov    0x805148,%eax
  8031a1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031a4:	89 50 04             	mov    %edx,0x4(%eax)
  8031a7:	eb 08                	jmp    8031b1 <insert_sorted_with_merge_freeList+0x45b>
  8031a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ac:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b4:	a3 48 51 80 00       	mov    %eax,0x805148
  8031b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031bc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031c3:	a1 54 51 80 00       	mov    0x805154,%eax
  8031c8:	40                   	inc    %eax
  8031c9:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8031ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d1:	8b 50 0c             	mov    0xc(%eax),%edx
  8031d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8031da:	01 c2                	add    %eax,%edx
  8031dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031df:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8031e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8031ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ef:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8031f6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031fa:	75 17                	jne    803213 <insert_sorted_with_merge_freeList+0x4bd>
  8031fc:	83 ec 04             	sub    $0x4,%esp
  8031ff:	68 9c 3f 80 00       	push   $0x803f9c
  803204:	68 64 01 00 00       	push   $0x164
  803209:	68 bf 3f 80 00       	push   $0x803fbf
  80320e:	e8 8f 02 00 00       	call   8034a2 <_panic>
  803213:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803219:	8b 45 08             	mov    0x8(%ebp),%eax
  80321c:	89 10                	mov    %edx,(%eax)
  80321e:	8b 45 08             	mov    0x8(%ebp),%eax
  803221:	8b 00                	mov    (%eax),%eax
  803223:	85 c0                	test   %eax,%eax
  803225:	74 0d                	je     803234 <insert_sorted_with_merge_freeList+0x4de>
  803227:	a1 48 51 80 00       	mov    0x805148,%eax
  80322c:	8b 55 08             	mov    0x8(%ebp),%edx
  80322f:	89 50 04             	mov    %edx,0x4(%eax)
  803232:	eb 08                	jmp    80323c <insert_sorted_with_merge_freeList+0x4e6>
  803234:	8b 45 08             	mov    0x8(%ebp),%eax
  803237:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80323c:	8b 45 08             	mov    0x8(%ebp),%eax
  80323f:	a3 48 51 80 00       	mov    %eax,0x805148
  803244:	8b 45 08             	mov    0x8(%ebp),%eax
  803247:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80324e:	a1 54 51 80 00       	mov    0x805154,%eax
  803253:	40                   	inc    %eax
  803254:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803259:	e9 41 02 00 00       	jmp    80349f <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80325e:	8b 45 08             	mov    0x8(%ebp),%eax
  803261:	8b 50 08             	mov    0x8(%eax),%edx
  803264:	8b 45 08             	mov    0x8(%ebp),%eax
  803267:	8b 40 0c             	mov    0xc(%eax),%eax
  80326a:	01 c2                	add    %eax,%edx
  80326c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80326f:	8b 40 08             	mov    0x8(%eax),%eax
  803272:	39 c2                	cmp    %eax,%edx
  803274:	0f 85 7c 01 00 00    	jne    8033f6 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80327a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80327e:	74 06                	je     803286 <insert_sorted_with_merge_freeList+0x530>
  803280:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803284:	75 17                	jne    80329d <insert_sorted_with_merge_freeList+0x547>
  803286:	83 ec 04             	sub    $0x4,%esp
  803289:	68 d8 3f 80 00       	push   $0x803fd8
  80328e:	68 69 01 00 00       	push   $0x169
  803293:	68 bf 3f 80 00       	push   $0x803fbf
  803298:	e8 05 02 00 00       	call   8034a2 <_panic>
  80329d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a0:	8b 50 04             	mov    0x4(%eax),%edx
  8032a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a6:	89 50 04             	mov    %edx,0x4(%eax)
  8032a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ac:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032af:	89 10                	mov    %edx,(%eax)
  8032b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b4:	8b 40 04             	mov    0x4(%eax),%eax
  8032b7:	85 c0                	test   %eax,%eax
  8032b9:	74 0d                	je     8032c8 <insert_sorted_with_merge_freeList+0x572>
  8032bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032be:	8b 40 04             	mov    0x4(%eax),%eax
  8032c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8032c4:	89 10                	mov    %edx,(%eax)
  8032c6:	eb 08                	jmp    8032d0 <insert_sorted_with_merge_freeList+0x57a>
  8032c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032cb:	a3 38 51 80 00       	mov    %eax,0x805138
  8032d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8032d6:	89 50 04             	mov    %edx,0x4(%eax)
  8032d9:	a1 44 51 80 00       	mov    0x805144,%eax
  8032de:	40                   	inc    %eax
  8032df:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8032e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e7:	8b 50 0c             	mov    0xc(%eax),%edx
  8032ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8032f0:	01 c2                	add    %eax,%edx
  8032f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f5:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8032f8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032fc:	75 17                	jne    803315 <insert_sorted_with_merge_freeList+0x5bf>
  8032fe:	83 ec 04             	sub    $0x4,%esp
  803301:	68 68 40 80 00       	push   $0x804068
  803306:	68 6b 01 00 00       	push   $0x16b
  80330b:	68 bf 3f 80 00       	push   $0x803fbf
  803310:	e8 8d 01 00 00       	call   8034a2 <_panic>
  803315:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803318:	8b 00                	mov    (%eax),%eax
  80331a:	85 c0                	test   %eax,%eax
  80331c:	74 10                	je     80332e <insert_sorted_with_merge_freeList+0x5d8>
  80331e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803321:	8b 00                	mov    (%eax),%eax
  803323:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803326:	8b 52 04             	mov    0x4(%edx),%edx
  803329:	89 50 04             	mov    %edx,0x4(%eax)
  80332c:	eb 0b                	jmp    803339 <insert_sorted_with_merge_freeList+0x5e3>
  80332e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803331:	8b 40 04             	mov    0x4(%eax),%eax
  803334:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803339:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80333c:	8b 40 04             	mov    0x4(%eax),%eax
  80333f:	85 c0                	test   %eax,%eax
  803341:	74 0f                	je     803352 <insert_sorted_with_merge_freeList+0x5fc>
  803343:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803346:	8b 40 04             	mov    0x4(%eax),%eax
  803349:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80334c:	8b 12                	mov    (%edx),%edx
  80334e:	89 10                	mov    %edx,(%eax)
  803350:	eb 0a                	jmp    80335c <insert_sorted_with_merge_freeList+0x606>
  803352:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803355:	8b 00                	mov    (%eax),%eax
  803357:	a3 38 51 80 00       	mov    %eax,0x805138
  80335c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80335f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803365:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803368:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80336f:	a1 44 51 80 00       	mov    0x805144,%eax
  803374:	48                   	dec    %eax
  803375:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  80337a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80337d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803384:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803387:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80338e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803392:	75 17                	jne    8033ab <insert_sorted_with_merge_freeList+0x655>
  803394:	83 ec 04             	sub    $0x4,%esp
  803397:	68 9c 3f 80 00       	push   $0x803f9c
  80339c:	68 6e 01 00 00       	push   $0x16e
  8033a1:	68 bf 3f 80 00       	push   $0x803fbf
  8033a6:	e8 f7 00 00 00       	call   8034a2 <_panic>
  8033ab:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b4:	89 10                	mov    %edx,(%eax)
  8033b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b9:	8b 00                	mov    (%eax),%eax
  8033bb:	85 c0                	test   %eax,%eax
  8033bd:	74 0d                	je     8033cc <insert_sorted_with_merge_freeList+0x676>
  8033bf:	a1 48 51 80 00       	mov    0x805148,%eax
  8033c4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033c7:	89 50 04             	mov    %edx,0x4(%eax)
  8033ca:	eb 08                	jmp    8033d4 <insert_sorted_with_merge_freeList+0x67e>
  8033cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033cf:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033d7:	a3 48 51 80 00       	mov    %eax,0x805148
  8033dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033e6:	a1 54 51 80 00       	mov    0x805154,%eax
  8033eb:	40                   	inc    %eax
  8033ec:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8033f1:	e9 a9 00 00 00       	jmp    80349f <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8033f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033fa:	74 06                	je     803402 <insert_sorted_with_merge_freeList+0x6ac>
  8033fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803400:	75 17                	jne    803419 <insert_sorted_with_merge_freeList+0x6c3>
  803402:	83 ec 04             	sub    $0x4,%esp
  803405:	68 34 40 80 00       	push   $0x804034
  80340a:	68 73 01 00 00       	push   $0x173
  80340f:	68 bf 3f 80 00       	push   $0x803fbf
  803414:	e8 89 00 00 00       	call   8034a2 <_panic>
  803419:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80341c:	8b 10                	mov    (%eax),%edx
  80341e:	8b 45 08             	mov    0x8(%ebp),%eax
  803421:	89 10                	mov    %edx,(%eax)
  803423:	8b 45 08             	mov    0x8(%ebp),%eax
  803426:	8b 00                	mov    (%eax),%eax
  803428:	85 c0                	test   %eax,%eax
  80342a:	74 0b                	je     803437 <insert_sorted_with_merge_freeList+0x6e1>
  80342c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80342f:	8b 00                	mov    (%eax),%eax
  803431:	8b 55 08             	mov    0x8(%ebp),%edx
  803434:	89 50 04             	mov    %edx,0x4(%eax)
  803437:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343a:	8b 55 08             	mov    0x8(%ebp),%edx
  80343d:	89 10                	mov    %edx,(%eax)
  80343f:	8b 45 08             	mov    0x8(%ebp),%eax
  803442:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803445:	89 50 04             	mov    %edx,0x4(%eax)
  803448:	8b 45 08             	mov    0x8(%ebp),%eax
  80344b:	8b 00                	mov    (%eax),%eax
  80344d:	85 c0                	test   %eax,%eax
  80344f:	75 08                	jne    803459 <insert_sorted_with_merge_freeList+0x703>
  803451:	8b 45 08             	mov    0x8(%ebp),%eax
  803454:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803459:	a1 44 51 80 00       	mov    0x805144,%eax
  80345e:	40                   	inc    %eax
  80345f:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803464:	eb 39                	jmp    80349f <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803466:	a1 40 51 80 00       	mov    0x805140,%eax
  80346b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80346e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803472:	74 07                	je     80347b <insert_sorted_with_merge_freeList+0x725>
  803474:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803477:	8b 00                	mov    (%eax),%eax
  803479:	eb 05                	jmp    803480 <insert_sorted_with_merge_freeList+0x72a>
  80347b:	b8 00 00 00 00       	mov    $0x0,%eax
  803480:	a3 40 51 80 00       	mov    %eax,0x805140
  803485:	a1 40 51 80 00       	mov    0x805140,%eax
  80348a:	85 c0                	test   %eax,%eax
  80348c:	0f 85 c7 fb ff ff    	jne    803059 <insert_sorted_with_merge_freeList+0x303>
  803492:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803496:	0f 85 bd fb ff ff    	jne    803059 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80349c:	eb 01                	jmp    80349f <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80349e:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80349f:	90                   	nop
  8034a0:	c9                   	leave  
  8034a1:	c3                   	ret    

008034a2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8034a2:	55                   	push   %ebp
  8034a3:	89 e5                	mov    %esp,%ebp
  8034a5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8034a8:	8d 45 10             	lea    0x10(%ebp),%eax
  8034ab:	83 c0 04             	add    $0x4,%eax
  8034ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8034b1:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8034b6:	85 c0                	test   %eax,%eax
  8034b8:	74 16                	je     8034d0 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8034ba:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8034bf:	83 ec 08             	sub    $0x8,%esp
  8034c2:	50                   	push   %eax
  8034c3:	68 88 40 80 00       	push   $0x804088
  8034c8:	e8 b6 d1 ff ff       	call   800683 <cprintf>
  8034cd:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8034d0:	a1 00 50 80 00       	mov    0x805000,%eax
  8034d5:	ff 75 0c             	pushl  0xc(%ebp)
  8034d8:	ff 75 08             	pushl  0x8(%ebp)
  8034db:	50                   	push   %eax
  8034dc:	68 8d 40 80 00       	push   $0x80408d
  8034e1:	e8 9d d1 ff ff       	call   800683 <cprintf>
  8034e6:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8034e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8034ec:	83 ec 08             	sub    $0x8,%esp
  8034ef:	ff 75 f4             	pushl  -0xc(%ebp)
  8034f2:	50                   	push   %eax
  8034f3:	e8 20 d1 ff ff       	call   800618 <vcprintf>
  8034f8:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8034fb:	83 ec 08             	sub    $0x8,%esp
  8034fe:	6a 00                	push   $0x0
  803500:	68 a9 40 80 00       	push   $0x8040a9
  803505:	e8 0e d1 ff ff       	call   800618 <vcprintf>
  80350a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80350d:	e8 8f d0 ff ff       	call   8005a1 <exit>

	// should not return here
	while (1) ;
  803512:	eb fe                	jmp    803512 <_panic+0x70>

00803514 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803514:	55                   	push   %ebp
  803515:	89 e5                	mov    %esp,%ebp
  803517:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80351a:	a1 20 50 80 00       	mov    0x805020,%eax
  80351f:	8b 50 74             	mov    0x74(%eax),%edx
  803522:	8b 45 0c             	mov    0xc(%ebp),%eax
  803525:	39 c2                	cmp    %eax,%edx
  803527:	74 14                	je     80353d <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803529:	83 ec 04             	sub    $0x4,%esp
  80352c:	68 ac 40 80 00       	push   $0x8040ac
  803531:	6a 26                	push   $0x26
  803533:	68 f8 40 80 00       	push   $0x8040f8
  803538:	e8 65 ff ff ff       	call   8034a2 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80353d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803544:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80354b:	e9 c2 00 00 00       	jmp    803612 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  803550:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803553:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80355a:	8b 45 08             	mov    0x8(%ebp),%eax
  80355d:	01 d0                	add    %edx,%eax
  80355f:	8b 00                	mov    (%eax),%eax
  803561:	85 c0                	test   %eax,%eax
  803563:	75 08                	jne    80356d <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  803565:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803568:	e9 a2 00 00 00       	jmp    80360f <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80356d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803574:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80357b:	eb 69                	jmp    8035e6 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80357d:	a1 20 50 80 00       	mov    0x805020,%eax
  803582:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803588:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80358b:	89 d0                	mov    %edx,%eax
  80358d:	01 c0                	add    %eax,%eax
  80358f:	01 d0                	add    %edx,%eax
  803591:	c1 e0 03             	shl    $0x3,%eax
  803594:	01 c8                	add    %ecx,%eax
  803596:	8a 40 04             	mov    0x4(%eax),%al
  803599:	84 c0                	test   %al,%al
  80359b:	75 46                	jne    8035e3 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80359d:	a1 20 50 80 00       	mov    0x805020,%eax
  8035a2:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8035a8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8035ab:	89 d0                	mov    %edx,%eax
  8035ad:	01 c0                	add    %eax,%eax
  8035af:	01 d0                	add    %edx,%eax
  8035b1:	c1 e0 03             	shl    $0x3,%eax
  8035b4:	01 c8                	add    %ecx,%eax
  8035b6:	8b 00                	mov    (%eax),%eax
  8035b8:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8035bb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035be:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8035c3:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8035c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035c8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8035cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d2:	01 c8                	add    %ecx,%eax
  8035d4:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8035d6:	39 c2                	cmp    %eax,%edx
  8035d8:	75 09                	jne    8035e3 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8035da:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8035e1:	eb 12                	jmp    8035f5 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8035e3:	ff 45 e8             	incl   -0x18(%ebp)
  8035e6:	a1 20 50 80 00       	mov    0x805020,%eax
  8035eb:	8b 50 74             	mov    0x74(%eax),%edx
  8035ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035f1:	39 c2                	cmp    %eax,%edx
  8035f3:	77 88                	ja     80357d <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8035f5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8035f9:	75 14                	jne    80360f <CheckWSWithoutLastIndex+0xfb>
			panic(
  8035fb:	83 ec 04             	sub    $0x4,%esp
  8035fe:	68 04 41 80 00       	push   $0x804104
  803603:	6a 3a                	push   $0x3a
  803605:	68 f8 40 80 00       	push   $0x8040f8
  80360a:	e8 93 fe ff ff       	call   8034a2 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80360f:	ff 45 f0             	incl   -0x10(%ebp)
  803612:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803615:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803618:	0f 8c 32 ff ff ff    	jl     803550 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80361e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803625:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80362c:	eb 26                	jmp    803654 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80362e:	a1 20 50 80 00       	mov    0x805020,%eax
  803633:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803639:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80363c:	89 d0                	mov    %edx,%eax
  80363e:	01 c0                	add    %eax,%eax
  803640:	01 d0                	add    %edx,%eax
  803642:	c1 e0 03             	shl    $0x3,%eax
  803645:	01 c8                	add    %ecx,%eax
  803647:	8a 40 04             	mov    0x4(%eax),%al
  80364a:	3c 01                	cmp    $0x1,%al
  80364c:	75 03                	jne    803651 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80364e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803651:	ff 45 e0             	incl   -0x20(%ebp)
  803654:	a1 20 50 80 00       	mov    0x805020,%eax
  803659:	8b 50 74             	mov    0x74(%eax),%edx
  80365c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80365f:	39 c2                	cmp    %eax,%edx
  803661:	77 cb                	ja     80362e <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803663:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803666:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803669:	74 14                	je     80367f <CheckWSWithoutLastIndex+0x16b>
		panic(
  80366b:	83 ec 04             	sub    $0x4,%esp
  80366e:	68 58 41 80 00       	push   $0x804158
  803673:	6a 44                	push   $0x44
  803675:	68 f8 40 80 00       	push   $0x8040f8
  80367a:	e8 23 fe ff ff       	call   8034a2 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80367f:	90                   	nop
  803680:	c9                   	leave  
  803681:	c3                   	ret    
  803682:	66 90                	xchg   %ax,%ax

00803684 <__udivdi3>:
  803684:	55                   	push   %ebp
  803685:	57                   	push   %edi
  803686:	56                   	push   %esi
  803687:	53                   	push   %ebx
  803688:	83 ec 1c             	sub    $0x1c,%esp
  80368b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80368f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803693:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803697:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80369b:	89 ca                	mov    %ecx,%edx
  80369d:	89 f8                	mov    %edi,%eax
  80369f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8036a3:	85 f6                	test   %esi,%esi
  8036a5:	75 2d                	jne    8036d4 <__udivdi3+0x50>
  8036a7:	39 cf                	cmp    %ecx,%edi
  8036a9:	77 65                	ja     803710 <__udivdi3+0x8c>
  8036ab:	89 fd                	mov    %edi,%ebp
  8036ad:	85 ff                	test   %edi,%edi
  8036af:	75 0b                	jne    8036bc <__udivdi3+0x38>
  8036b1:	b8 01 00 00 00       	mov    $0x1,%eax
  8036b6:	31 d2                	xor    %edx,%edx
  8036b8:	f7 f7                	div    %edi
  8036ba:	89 c5                	mov    %eax,%ebp
  8036bc:	31 d2                	xor    %edx,%edx
  8036be:	89 c8                	mov    %ecx,%eax
  8036c0:	f7 f5                	div    %ebp
  8036c2:	89 c1                	mov    %eax,%ecx
  8036c4:	89 d8                	mov    %ebx,%eax
  8036c6:	f7 f5                	div    %ebp
  8036c8:	89 cf                	mov    %ecx,%edi
  8036ca:	89 fa                	mov    %edi,%edx
  8036cc:	83 c4 1c             	add    $0x1c,%esp
  8036cf:	5b                   	pop    %ebx
  8036d0:	5e                   	pop    %esi
  8036d1:	5f                   	pop    %edi
  8036d2:	5d                   	pop    %ebp
  8036d3:	c3                   	ret    
  8036d4:	39 ce                	cmp    %ecx,%esi
  8036d6:	77 28                	ja     803700 <__udivdi3+0x7c>
  8036d8:	0f bd fe             	bsr    %esi,%edi
  8036db:	83 f7 1f             	xor    $0x1f,%edi
  8036de:	75 40                	jne    803720 <__udivdi3+0x9c>
  8036e0:	39 ce                	cmp    %ecx,%esi
  8036e2:	72 0a                	jb     8036ee <__udivdi3+0x6a>
  8036e4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8036e8:	0f 87 9e 00 00 00    	ja     80378c <__udivdi3+0x108>
  8036ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8036f3:	89 fa                	mov    %edi,%edx
  8036f5:	83 c4 1c             	add    $0x1c,%esp
  8036f8:	5b                   	pop    %ebx
  8036f9:	5e                   	pop    %esi
  8036fa:	5f                   	pop    %edi
  8036fb:	5d                   	pop    %ebp
  8036fc:	c3                   	ret    
  8036fd:	8d 76 00             	lea    0x0(%esi),%esi
  803700:	31 ff                	xor    %edi,%edi
  803702:	31 c0                	xor    %eax,%eax
  803704:	89 fa                	mov    %edi,%edx
  803706:	83 c4 1c             	add    $0x1c,%esp
  803709:	5b                   	pop    %ebx
  80370a:	5e                   	pop    %esi
  80370b:	5f                   	pop    %edi
  80370c:	5d                   	pop    %ebp
  80370d:	c3                   	ret    
  80370e:	66 90                	xchg   %ax,%ax
  803710:	89 d8                	mov    %ebx,%eax
  803712:	f7 f7                	div    %edi
  803714:	31 ff                	xor    %edi,%edi
  803716:	89 fa                	mov    %edi,%edx
  803718:	83 c4 1c             	add    $0x1c,%esp
  80371b:	5b                   	pop    %ebx
  80371c:	5e                   	pop    %esi
  80371d:	5f                   	pop    %edi
  80371e:	5d                   	pop    %ebp
  80371f:	c3                   	ret    
  803720:	bd 20 00 00 00       	mov    $0x20,%ebp
  803725:	89 eb                	mov    %ebp,%ebx
  803727:	29 fb                	sub    %edi,%ebx
  803729:	89 f9                	mov    %edi,%ecx
  80372b:	d3 e6                	shl    %cl,%esi
  80372d:	89 c5                	mov    %eax,%ebp
  80372f:	88 d9                	mov    %bl,%cl
  803731:	d3 ed                	shr    %cl,%ebp
  803733:	89 e9                	mov    %ebp,%ecx
  803735:	09 f1                	or     %esi,%ecx
  803737:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80373b:	89 f9                	mov    %edi,%ecx
  80373d:	d3 e0                	shl    %cl,%eax
  80373f:	89 c5                	mov    %eax,%ebp
  803741:	89 d6                	mov    %edx,%esi
  803743:	88 d9                	mov    %bl,%cl
  803745:	d3 ee                	shr    %cl,%esi
  803747:	89 f9                	mov    %edi,%ecx
  803749:	d3 e2                	shl    %cl,%edx
  80374b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80374f:	88 d9                	mov    %bl,%cl
  803751:	d3 e8                	shr    %cl,%eax
  803753:	09 c2                	or     %eax,%edx
  803755:	89 d0                	mov    %edx,%eax
  803757:	89 f2                	mov    %esi,%edx
  803759:	f7 74 24 0c          	divl   0xc(%esp)
  80375d:	89 d6                	mov    %edx,%esi
  80375f:	89 c3                	mov    %eax,%ebx
  803761:	f7 e5                	mul    %ebp
  803763:	39 d6                	cmp    %edx,%esi
  803765:	72 19                	jb     803780 <__udivdi3+0xfc>
  803767:	74 0b                	je     803774 <__udivdi3+0xf0>
  803769:	89 d8                	mov    %ebx,%eax
  80376b:	31 ff                	xor    %edi,%edi
  80376d:	e9 58 ff ff ff       	jmp    8036ca <__udivdi3+0x46>
  803772:	66 90                	xchg   %ax,%ax
  803774:	8b 54 24 08          	mov    0x8(%esp),%edx
  803778:	89 f9                	mov    %edi,%ecx
  80377a:	d3 e2                	shl    %cl,%edx
  80377c:	39 c2                	cmp    %eax,%edx
  80377e:	73 e9                	jae    803769 <__udivdi3+0xe5>
  803780:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803783:	31 ff                	xor    %edi,%edi
  803785:	e9 40 ff ff ff       	jmp    8036ca <__udivdi3+0x46>
  80378a:	66 90                	xchg   %ax,%ax
  80378c:	31 c0                	xor    %eax,%eax
  80378e:	e9 37 ff ff ff       	jmp    8036ca <__udivdi3+0x46>
  803793:	90                   	nop

00803794 <__umoddi3>:
  803794:	55                   	push   %ebp
  803795:	57                   	push   %edi
  803796:	56                   	push   %esi
  803797:	53                   	push   %ebx
  803798:	83 ec 1c             	sub    $0x1c,%esp
  80379b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80379f:	8b 74 24 34          	mov    0x34(%esp),%esi
  8037a3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8037a7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8037ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8037af:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8037b3:	89 f3                	mov    %esi,%ebx
  8037b5:	89 fa                	mov    %edi,%edx
  8037b7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8037bb:	89 34 24             	mov    %esi,(%esp)
  8037be:	85 c0                	test   %eax,%eax
  8037c0:	75 1a                	jne    8037dc <__umoddi3+0x48>
  8037c2:	39 f7                	cmp    %esi,%edi
  8037c4:	0f 86 a2 00 00 00    	jbe    80386c <__umoddi3+0xd8>
  8037ca:	89 c8                	mov    %ecx,%eax
  8037cc:	89 f2                	mov    %esi,%edx
  8037ce:	f7 f7                	div    %edi
  8037d0:	89 d0                	mov    %edx,%eax
  8037d2:	31 d2                	xor    %edx,%edx
  8037d4:	83 c4 1c             	add    $0x1c,%esp
  8037d7:	5b                   	pop    %ebx
  8037d8:	5e                   	pop    %esi
  8037d9:	5f                   	pop    %edi
  8037da:	5d                   	pop    %ebp
  8037db:	c3                   	ret    
  8037dc:	39 f0                	cmp    %esi,%eax
  8037de:	0f 87 ac 00 00 00    	ja     803890 <__umoddi3+0xfc>
  8037e4:	0f bd e8             	bsr    %eax,%ebp
  8037e7:	83 f5 1f             	xor    $0x1f,%ebp
  8037ea:	0f 84 ac 00 00 00    	je     80389c <__umoddi3+0x108>
  8037f0:	bf 20 00 00 00       	mov    $0x20,%edi
  8037f5:	29 ef                	sub    %ebp,%edi
  8037f7:	89 fe                	mov    %edi,%esi
  8037f9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8037fd:	89 e9                	mov    %ebp,%ecx
  8037ff:	d3 e0                	shl    %cl,%eax
  803801:	89 d7                	mov    %edx,%edi
  803803:	89 f1                	mov    %esi,%ecx
  803805:	d3 ef                	shr    %cl,%edi
  803807:	09 c7                	or     %eax,%edi
  803809:	89 e9                	mov    %ebp,%ecx
  80380b:	d3 e2                	shl    %cl,%edx
  80380d:	89 14 24             	mov    %edx,(%esp)
  803810:	89 d8                	mov    %ebx,%eax
  803812:	d3 e0                	shl    %cl,%eax
  803814:	89 c2                	mov    %eax,%edx
  803816:	8b 44 24 08          	mov    0x8(%esp),%eax
  80381a:	d3 e0                	shl    %cl,%eax
  80381c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803820:	8b 44 24 08          	mov    0x8(%esp),%eax
  803824:	89 f1                	mov    %esi,%ecx
  803826:	d3 e8                	shr    %cl,%eax
  803828:	09 d0                	or     %edx,%eax
  80382a:	d3 eb                	shr    %cl,%ebx
  80382c:	89 da                	mov    %ebx,%edx
  80382e:	f7 f7                	div    %edi
  803830:	89 d3                	mov    %edx,%ebx
  803832:	f7 24 24             	mull   (%esp)
  803835:	89 c6                	mov    %eax,%esi
  803837:	89 d1                	mov    %edx,%ecx
  803839:	39 d3                	cmp    %edx,%ebx
  80383b:	0f 82 87 00 00 00    	jb     8038c8 <__umoddi3+0x134>
  803841:	0f 84 91 00 00 00    	je     8038d8 <__umoddi3+0x144>
  803847:	8b 54 24 04          	mov    0x4(%esp),%edx
  80384b:	29 f2                	sub    %esi,%edx
  80384d:	19 cb                	sbb    %ecx,%ebx
  80384f:	89 d8                	mov    %ebx,%eax
  803851:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803855:	d3 e0                	shl    %cl,%eax
  803857:	89 e9                	mov    %ebp,%ecx
  803859:	d3 ea                	shr    %cl,%edx
  80385b:	09 d0                	or     %edx,%eax
  80385d:	89 e9                	mov    %ebp,%ecx
  80385f:	d3 eb                	shr    %cl,%ebx
  803861:	89 da                	mov    %ebx,%edx
  803863:	83 c4 1c             	add    $0x1c,%esp
  803866:	5b                   	pop    %ebx
  803867:	5e                   	pop    %esi
  803868:	5f                   	pop    %edi
  803869:	5d                   	pop    %ebp
  80386a:	c3                   	ret    
  80386b:	90                   	nop
  80386c:	89 fd                	mov    %edi,%ebp
  80386e:	85 ff                	test   %edi,%edi
  803870:	75 0b                	jne    80387d <__umoddi3+0xe9>
  803872:	b8 01 00 00 00       	mov    $0x1,%eax
  803877:	31 d2                	xor    %edx,%edx
  803879:	f7 f7                	div    %edi
  80387b:	89 c5                	mov    %eax,%ebp
  80387d:	89 f0                	mov    %esi,%eax
  80387f:	31 d2                	xor    %edx,%edx
  803881:	f7 f5                	div    %ebp
  803883:	89 c8                	mov    %ecx,%eax
  803885:	f7 f5                	div    %ebp
  803887:	89 d0                	mov    %edx,%eax
  803889:	e9 44 ff ff ff       	jmp    8037d2 <__umoddi3+0x3e>
  80388e:	66 90                	xchg   %ax,%ax
  803890:	89 c8                	mov    %ecx,%eax
  803892:	89 f2                	mov    %esi,%edx
  803894:	83 c4 1c             	add    $0x1c,%esp
  803897:	5b                   	pop    %ebx
  803898:	5e                   	pop    %esi
  803899:	5f                   	pop    %edi
  80389a:	5d                   	pop    %ebp
  80389b:	c3                   	ret    
  80389c:	3b 04 24             	cmp    (%esp),%eax
  80389f:	72 06                	jb     8038a7 <__umoddi3+0x113>
  8038a1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8038a5:	77 0f                	ja     8038b6 <__umoddi3+0x122>
  8038a7:	89 f2                	mov    %esi,%edx
  8038a9:	29 f9                	sub    %edi,%ecx
  8038ab:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8038af:	89 14 24             	mov    %edx,(%esp)
  8038b2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8038b6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8038ba:	8b 14 24             	mov    (%esp),%edx
  8038bd:	83 c4 1c             	add    $0x1c,%esp
  8038c0:	5b                   	pop    %ebx
  8038c1:	5e                   	pop    %esi
  8038c2:	5f                   	pop    %edi
  8038c3:	5d                   	pop    %ebp
  8038c4:	c3                   	ret    
  8038c5:	8d 76 00             	lea    0x0(%esi),%esi
  8038c8:	2b 04 24             	sub    (%esp),%eax
  8038cb:	19 fa                	sbb    %edi,%edx
  8038cd:	89 d1                	mov    %edx,%ecx
  8038cf:	89 c6                	mov    %eax,%esi
  8038d1:	e9 71 ff ff ff       	jmp    803847 <__umoddi3+0xb3>
  8038d6:	66 90                	xchg   %ax,%ax
  8038d8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8038dc:	72 ea                	jb     8038c8 <__umoddi3+0x134>
  8038de:	89 d9                	mov    %ebx,%ecx
  8038e0:	e9 62 ff ff ff       	jmp    803847 <__umoddi3+0xb3>
