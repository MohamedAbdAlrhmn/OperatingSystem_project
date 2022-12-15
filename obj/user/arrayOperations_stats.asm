
obj/user/arrayOperations_stats:     file format elf32-i386


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
  800031:	e8 f7 04 00 00       	call   80052d <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void ArrayStats(int *Elements, int NumOfElements, int *mean, int *var, int *min, int *max, int *med);
int KthElement(int *Elements, int NumOfElements, int k);
int QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex, int kIndex);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 58             	sub    $0x58,%esp
	int32 envID = sys_getenvid();
  80003e:	e8 b0 1c 00 00       	call   801cf3 <sys_getenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int32 parentenvID = sys_getparentenvid();
  800046:	e8 da 1c 00 00       	call   801d25 <sys_getparentenvid>
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
  80005f:	68 40 3a 80 00       	push   $0x803a40
  800064:	ff 75 ec             	pushl  -0x14(%ebp)
  800067:	e8 9c 17 00 00       	call   801808 <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	numOfElements = sget(parentenvID,"arrSize") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 44 3a 80 00       	push   $0x803a44
  80007a:	ff 75 ec             	pushl  -0x14(%ebp)
  80007d:	e8 86 17 00 00       	call   801808 <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//Get the check-finishing counter
	int *finishedCount = NULL;
  800088:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	finishedCount = sget(parentenvID,"finishedCount") ;
  80008f:	83 ec 08             	sub    $0x8,%esp
  800092:	68 4c 3a 80 00       	push   $0x803a4c
  800097:	ff 75 ec             	pushl  -0x14(%ebp)
  80009a:	e8 69 17 00 00       	call   801808 <sget>
  80009f:	83 c4 10             	add    $0x10,%esp
  8000a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int max ;
	int med ;

	//take a copy from the original array
	int *tmpArray;
	tmpArray = smalloc("tmpArr", sizeof(int) * *numOfElements, 0) ;
  8000a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000a8:	8b 00                	mov    (%eax),%eax
  8000aa:	c1 e0 02             	shl    $0x2,%eax
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 00                	push   $0x0
  8000b2:	50                   	push   %eax
  8000b3:	68 5a 3a 80 00       	push   $0x803a5a
  8000b8:	e8 9d 16 00 00       	call   80175a <smalloc>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8000c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8000ca:	eb 25                	jmp    8000f1 <_main+0xb9>
	{
		tmpArray[i] = sharedArray[i];
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

	//take a copy from the original array
	int *tmpArray;
	tmpArray = smalloc("tmpArr", sizeof(int) * *numOfElements, 0) ;
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8000ee:	ff 45 f4             	incl   -0xc(%ebp)
  8000f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000f4:	8b 00                	mov    (%eax),%eax
  8000f6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8000f9:	7f d1                	jg     8000cc <_main+0x94>
	{
		tmpArray[i] = sharedArray[i];
	}

	ArrayStats(tmpArray ,*numOfElements, &mean, &var, &min, &max, &med);
  8000fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000fe:	8b 00                	mov    (%eax),%eax
  800100:	83 ec 04             	sub    $0x4,%esp
  800103:	8d 55 b4             	lea    -0x4c(%ebp),%edx
  800106:	52                   	push   %edx
  800107:	8d 55 b8             	lea    -0x48(%ebp),%edx
  80010a:	52                   	push   %edx
  80010b:	8d 55 bc             	lea    -0x44(%ebp),%edx
  80010e:	52                   	push   %edx
  80010f:	8d 55 c0             	lea    -0x40(%ebp),%edx
  800112:	52                   	push   %edx
  800113:	8d 55 c4             	lea    -0x3c(%ebp),%edx
  800116:	52                   	push   %edx
  800117:	50                   	push   %eax
  800118:	ff 75 dc             	pushl  -0x24(%ebp)
  80011b:	e8 55 02 00 00       	call   800375 <ArrayStats>
  800120:	83 c4 20             	add    $0x20,%esp
	cprintf("Stats Calculations are Finished!!!!\n") ;
  800123:	83 ec 0c             	sub    $0xc,%esp
  800126:	68 64 3a 80 00       	push   $0x803a64
  80012b:	e8 0d 06 00 00       	call   80073d <cprintf>
  800130:	83 c4 10             	add    $0x10,%esp

	/*[3] SHARE THE RESULTS & DECLARE FINISHING*/
	int *shMean, *shVar, *shMin, *shMax, *shMed;
	shMean = smalloc("mean", sizeof(int), 0) ; *shMean = mean;
  800133:	83 ec 04             	sub    $0x4,%esp
  800136:	6a 00                	push   $0x0
  800138:	6a 04                	push   $0x4
  80013a:	68 89 3a 80 00       	push   $0x803a89
  80013f:	e8 16 16 00 00       	call   80175a <smalloc>
  800144:	83 c4 10             	add    $0x10,%esp
  800147:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80014a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80014d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800150:	89 10                	mov    %edx,(%eax)
	shVar = smalloc("var", sizeof(int), 0) ; *shVar = var;
  800152:	83 ec 04             	sub    $0x4,%esp
  800155:	6a 00                	push   $0x0
  800157:	6a 04                	push   $0x4
  800159:	68 8e 3a 80 00       	push   $0x803a8e
  80015e:	e8 f7 15 00 00       	call   80175a <smalloc>
  800163:	83 c4 10             	add    $0x10,%esp
  800166:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800169:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80016c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80016f:	89 10                	mov    %edx,(%eax)
	shMin = smalloc("min", sizeof(int), 0) ; *shMin = min;
  800171:	83 ec 04             	sub    $0x4,%esp
  800174:	6a 00                	push   $0x0
  800176:	6a 04                	push   $0x4
  800178:	68 92 3a 80 00       	push   $0x803a92
  80017d:	e8 d8 15 00 00       	call   80175a <smalloc>
  800182:	83 c4 10             	add    $0x10,%esp
  800185:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800188:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80018b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80018e:	89 10                	mov    %edx,(%eax)
	shMax = smalloc("max", sizeof(int), 0) ; *shMax = max;
  800190:	83 ec 04             	sub    $0x4,%esp
  800193:	6a 00                	push   $0x0
  800195:	6a 04                	push   $0x4
  800197:	68 96 3a 80 00       	push   $0x803a96
  80019c:	e8 b9 15 00 00       	call   80175a <smalloc>
  8001a1:	83 c4 10             	add    $0x10,%esp
  8001a4:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8001a7:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8001aa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001ad:	89 10                	mov    %edx,(%eax)
	shMed = smalloc("med", sizeof(int), 0) ; *shMed = med;
  8001af:	83 ec 04             	sub    $0x4,%esp
  8001b2:	6a 00                	push   $0x0
  8001b4:	6a 04                	push   $0x4
  8001b6:	68 9a 3a 80 00       	push   $0x803a9a
  8001bb:	e8 9a 15 00 00       	call   80175a <smalloc>
  8001c0:	83 c4 10             	add    $0x10,%esp
  8001c3:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8001c6:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  8001c9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8001cc:	89 10                	mov    %edx,(%eax)

	(*finishedCount)++ ;
  8001ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001d1:	8b 00                	mov    (%eax),%eax
  8001d3:	8d 50 01             	lea    0x1(%eax),%edx
  8001d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001d9:	89 10                	mov    %edx,(%eax)

}
  8001db:	90                   	nop
  8001dc:	c9                   	leave  
  8001dd:	c3                   	ret    

008001de <KthElement>:



///Kth Element
int KthElement(int *Elements, int NumOfElements, int k)
{
  8001de:	55                   	push   %ebp
  8001df:	89 e5                	mov    %esp,%ebp
  8001e1:	83 ec 08             	sub    $0x8,%esp
	return QSort(Elements, NumOfElements, 0, NumOfElements-1, k-1) ;
  8001e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8001e7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8001ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ed:	48                   	dec    %eax
  8001ee:	83 ec 0c             	sub    $0xc,%esp
  8001f1:	52                   	push   %edx
  8001f2:	50                   	push   %eax
  8001f3:	6a 00                	push   $0x0
  8001f5:	ff 75 0c             	pushl  0xc(%ebp)
  8001f8:	ff 75 08             	pushl  0x8(%ebp)
  8001fb:	e8 05 00 00 00       	call   800205 <QSort>
  800200:	83 c4 20             	add    $0x20,%esp
}
  800203:	c9                   	leave  
  800204:	c3                   	ret    

00800205 <QSort>:


int QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex, int kIndex)
{
  800205:	55                   	push   %ebp
  800206:	89 e5                	mov    %esp,%ebp
  800208:	83 ec 28             	sub    $0x28,%esp
	if (startIndex >= finalIndex) return Elements[finalIndex];
  80020b:	8b 45 10             	mov    0x10(%ebp),%eax
  80020e:	3b 45 14             	cmp    0x14(%ebp),%eax
  800211:	7c 16                	jl     800229 <QSort+0x24>
  800213:	8b 45 14             	mov    0x14(%ebp),%eax
  800216:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80021d:	8b 45 08             	mov    0x8(%ebp),%eax
  800220:	01 d0                	add    %edx,%eax
  800222:	8b 00                	mov    (%eax),%eax
  800224:	e9 4a 01 00 00       	jmp    800373 <QSort+0x16e>

	int pvtIndex = RAND(startIndex, finalIndex) ;
  800229:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80022c:	83 ec 0c             	sub    $0xc,%esp
  80022f:	50                   	push   %eax
  800230:	e8 23 1b 00 00       	call   801d58 <sys_get_virtual_time>
  800235:	83 c4 0c             	add    $0xc,%esp
  800238:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80023b:	8b 55 14             	mov    0x14(%ebp),%edx
  80023e:	2b 55 10             	sub    0x10(%ebp),%edx
  800241:	89 d1                	mov    %edx,%ecx
  800243:	ba 00 00 00 00       	mov    $0x0,%edx
  800248:	f7 f1                	div    %ecx
  80024a:	8b 45 10             	mov    0x10(%ebp),%eax
  80024d:	01 d0                	add    %edx,%eax
  80024f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	Swap(Elements, startIndex, pvtIndex);
  800252:	83 ec 04             	sub    $0x4,%esp
  800255:	ff 75 ec             	pushl  -0x14(%ebp)
  800258:	ff 75 10             	pushl  0x10(%ebp)
  80025b:	ff 75 08             	pushl  0x8(%ebp)
  80025e:	e8 77 02 00 00       	call   8004da <Swap>
  800263:	83 c4 10             	add    $0x10,%esp

	int i = startIndex+1, j = finalIndex;
  800266:	8b 45 10             	mov    0x10(%ebp),%eax
  800269:	40                   	inc    %eax
  80026a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80026d:	8b 45 14             	mov    0x14(%ebp),%eax
  800270:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  800273:	e9 80 00 00 00       	jmp    8002f8 <QSort+0xf3>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800278:	ff 45 f4             	incl   -0xc(%ebp)
  80027b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80027e:	3b 45 14             	cmp    0x14(%ebp),%eax
  800281:	7f 2b                	jg     8002ae <QSort+0xa9>
  800283:	8b 45 10             	mov    0x10(%ebp),%eax
  800286:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80028d:	8b 45 08             	mov    0x8(%ebp),%eax
  800290:	01 d0                	add    %edx,%eax
  800292:	8b 10                	mov    (%eax),%edx
  800294:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800297:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80029e:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a1:	01 c8                	add    %ecx,%eax
  8002a3:	8b 00                	mov    (%eax),%eax
  8002a5:	39 c2                	cmp    %eax,%edx
  8002a7:	7d cf                	jge    800278 <QSort+0x73>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  8002a9:	eb 03                	jmp    8002ae <QSort+0xa9>
  8002ab:	ff 4d f0             	decl   -0x10(%ebp)
  8002ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002b1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8002b4:	7e 26                	jle    8002dc <QSort+0xd7>
  8002b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002b9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c3:	01 d0                	add    %edx,%eax
  8002c5:	8b 10                	mov    (%eax),%edx
  8002c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002ca:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d4:	01 c8                	add    %ecx,%eax
  8002d6:	8b 00                	mov    (%eax),%eax
  8002d8:	39 c2                	cmp    %eax,%edx
  8002da:	7e cf                	jle    8002ab <QSort+0xa6>

		if (i <= j)
  8002dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002df:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8002e2:	7f 14                	jg     8002f8 <QSort+0xf3>
		{
			Swap(Elements, i, j);
  8002e4:	83 ec 04             	sub    $0x4,%esp
  8002e7:	ff 75 f0             	pushl  -0x10(%ebp)
  8002ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8002ed:	ff 75 08             	pushl  0x8(%ebp)
  8002f0:	e8 e5 01 00 00       	call   8004da <Swap>
  8002f5:	83 c4 10             	add    $0x10,%esp
	int pvtIndex = RAND(startIndex, finalIndex) ;
	Swap(Elements, startIndex, pvtIndex);

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  8002f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002fb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8002fe:	0f 8e 77 ff ff ff    	jle    80027b <QSort+0x76>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  800304:	83 ec 04             	sub    $0x4,%esp
  800307:	ff 75 f0             	pushl  -0x10(%ebp)
  80030a:	ff 75 10             	pushl  0x10(%ebp)
  80030d:	ff 75 08             	pushl  0x8(%ebp)
  800310:	e8 c5 01 00 00       	call   8004da <Swap>
  800315:	83 c4 10             	add    $0x10,%esp

	if (kIndex == j)
  800318:	8b 45 18             	mov    0x18(%ebp),%eax
  80031b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80031e:	75 13                	jne    800333 <QSort+0x12e>
		return Elements[kIndex] ;
  800320:	8b 45 18             	mov    0x18(%ebp),%eax
  800323:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80032a:	8b 45 08             	mov    0x8(%ebp),%eax
  80032d:	01 d0                	add    %edx,%eax
  80032f:	8b 00                	mov    (%eax),%eax
  800331:	eb 40                	jmp    800373 <QSort+0x16e>
	else if (kIndex < j)
  800333:	8b 45 18             	mov    0x18(%ebp),%eax
  800336:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800339:	7d 1e                	jge    800359 <QSort+0x154>
		return QSort(Elements, NumOfElements, startIndex, j - 1, kIndex);
  80033b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80033e:	48                   	dec    %eax
  80033f:	83 ec 0c             	sub    $0xc,%esp
  800342:	ff 75 18             	pushl  0x18(%ebp)
  800345:	50                   	push   %eax
  800346:	ff 75 10             	pushl  0x10(%ebp)
  800349:	ff 75 0c             	pushl  0xc(%ebp)
  80034c:	ff 75 08             	pushl  0x8(%ebp)
  80034f:	e8 b1 fe ff ff       	call   800205 <QSort>
  800354:	83 c4 20             	add    $0x20,%esp
  800357:	eb 1a                	jmp    800373 <QSort+0x16e>
	else
		return QSort(Elements, NumOfElements, i, finalIndex, kIndex);
  800359:	83 ec 0c             	sub    $0xc,%esp
  80035c:	ff 75 18             	pushl  0x18(%ebp)
  80035f:	ff 75 14             	pushl  0x14(%ebp)
  800362:	ff 75 f4             	pushl  -0xc(%ebp)
  800365:	ff 75 0c             	pushl  0xc(%ebp)
  800368:	ff 75 08             	pushl  0x8(%ebp)
  80036b:	e8 95 fe ff ff       	call   800205 <QSort>
  800370:	83 c4 20             	add    $0x20,%esp
}
  800373:	c9                   	leave  
  800374:	c3                   	ret    

00800375 <ArrayStats>:

void ArrayStats(int *Elements, int NumOfElements, int *mean, int *var, int *min, int *max, int *med)
{
  800375:	55                   	push   %ebp
  800376:	89 e5                	mov    %esp,%ebp
  800378:	53                   	push   %ebx
  800379:	83 ec 14             	sub    $0x14,%esp
	int i ;
	*mean =0 ;
  80037c:	8b 45 10             	mov    0x10(%ebp),%eax
  80037f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*min = 0x7FFFFFFF ;
  800385:	8b 45 18             	mov    0x18(%ebp),%eax
  800388:	c7 00 ff ff ff 7f    	movl   $0x7fffffff,(%eax)
	*max = 0x80000000 ;
  80038e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800391:	c7 00 00 00 00 80    	movl   $0x80000000,(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  800397:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80039e:	e9 80 00 00 00       	jmp    800423 <ArrayStats+0xae>
	{
		(*mean) += Elements[i];
  8003a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8003a6:	8b 10                	mov    (%eax),%edx
  8003a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003ab:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b5:	01 c8                	add    %ecx,%eax
  8003b7:	8b 00                	mov    (%eax),%eax
  8003b9:	01 c2                	add    %eax,%edx
  8003bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8003be:	89 10                	mov    %edx,(%eax)
		if (Elements[i] < (*min))
  8003c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8003cd:	01 d0                	add    %edx,%eax
  8003cf:	8b 10                	mov    (%eax),%edx
  8003d1:	8b 45 18             	mov    0x18(%ebp),%eax
  8003d4:	8b 00                	mov    (%eax),%eax
  8003d6:	39 c2                	cmp    %eax,%edx
  8003d8:	7d 16                	jge    8003f0 <ArrayStats+0x7b>
		{
			(*min) = Elements[i];
  8003da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e7:	01 d0                	add    %edx,%eax
  8003e9:	8b 10                	mov    (%eax),%edx
  8003eb:	8b 45 18             	mov    0x18(%ebp),%eax
  8003ee:	89 10                	mov    %edx,(%eax)
		}
		if (Elements[i] > (*max))
  8003f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003f3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fd:	01 d0                	add    %edx,%eax
  8003ff:	8b 10                	mov    (%eax),%edx
  800401:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800404:	8b 00                	mov    (%eax),%eax
  800406:	39 c2                	cmp    %eax,%edx
  800408:	7e 16                	jle    800420 <ArrayStats+0xab>
		{
			(*max) = Elements[i];
  80040a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80040d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800414:	8b 45 08             	mov    0x8(%ebp),%eax
  800417:	01 d0                	add    %edx,%eax
  800419:	8b 10                	mov    (%eax),%edx
  80041b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80041e:	89 10                	mov    %edx,(%eax)
{
	int i ;
	*mean =0 ;
	*min = 0x7FFFFFFF ;
	*max = 0x80000000 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800420:	ff 45 f4             	incl   -0xc(%ebp)
  800423:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800426:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800429:	0f 8c 74 ff ff ff    	jl     8003a3 <ArrayStats+0x2e>
		{
			(*max) = Elements[i];
		}
	}

	(*med) = KthElement(Elements, NumOfElements, NumOfElements/2);
  80042f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800432:	89 c2                	mov    %eax,%edx
  800434:	c1 ea 1f             	shr    $0x1f,%edx
  800437:	01 d0                	add    %edx,%eax
  800439:	d1 f8                	sar    %eax
  80043b:	83 ec 04             	sub    $0x4,%esp
  80043e:	50                   	push   %eax
  80043f:	ff 75 0c             	pushl  0xc(%ebp)
  800442:	ff 75 08             	pushl  0x8(%ebp)
  800445:	e8 94 fd ff ff       	call   8001de <KthElement>
  80044a:	83 c4 10             	add    $0x10,%esp
  80044d:	89 c2                	mov    %eax,%edx
  80044f:	8b 45 20             	mov    0x20(%ebp),%eax
  800452:	89 10                	mov    %edx,(%eax)

	(*mean) /= NumOfElements;
  800454:	8b 45 10             	mov    0x10(%ebp),%eax
  800457:	8b 00                	mov    (%eax),%eax
  800459:	99                   	cltd   
  80045a:	f7 7d 0c             	idivl  0xc(%ebp)
  80045d:	89 c2                	mov    %eax,%edx
  80045f:	8b 45 10             	mov    0x10(%ebp),%eax
  800462:	89 10                	mov    %edx,(%eax)
	(*var) = 0;
  800464:	8b 45 14             	mov    0x14(%ebp),%eax
  800467:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  80046d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800474:	eb 46                	jmp    8004bc <ArrayStats+0x147>
	{
		(*var) += (Elements[i] - (*mean))*(Elements[i] - (*mean));
  800476:	8b 45 14             	mov    0x14(%ebp),%eax
  800479:	8b 10                	mov    (%eax),%edx
  80047b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80047e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800485:	8b 45 08             	mov    0x8(%ebp),%eax
  800488:	01 c8                	add    %ecx,%eax
  80048a:	8b 08                	mov    (%eax),%ecx
  80048c:	8b 45 10             	mov    0x10(%ebp),%eax
  80048f:	8b 00                	mov    (%eax),%eax
  800491:	89 cb                	mov    %ecx,%ebx
  800493:	29 c3                	sub    %eax,%ebx
  800495:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800498:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80049f:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a2:	01 c8                	add    %ecx,%eax
  8004a4:	8b 08                	mov    (%eax),%ecx
  8004a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8004a9:	8b 00                	mov    (%eax),%eax
  8004ab:	29 c1                	sub    %eax,%ecx
  8004ad:	89 c8                	mov    %ecx,%eax
  8004af:	0f af c3             	imul   %ebx,%eax
  8004b2:	01 c2                	add    %eax,%edx
  8004b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b7:	89 10                	mov    %edx,(%eax)

	(*med) = KthElement(Elements, NumOfElements, NumOfElements/2);

	(*mean) /= NumOfElements;
	(*var) = 0;
	for (i = 0 ; i < NumOfElements ; i++)
  8004b9:	ff 45 f4             	incl   -0xc(%ebp)
  8004bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004bf:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004c2:	7c b2                	jl     800476 <ArrayStats+0x101>
	{
		(*var) += (Elements[i] - (*mean))*(Elements[i] - (*mean));
	}
	(*var) /= NumOfElements;
  8004c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c7:	8b 00                	mov    (%eax),%eax
  8004c9:	99                   	cltd   
  8004ca:	f7 7d 0c             	idivl  0xc(%ebp)
  8004cd:	89 c2                	mov    %eax,%edx
  8004cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d2:	89 10                	mov    %edx,(%eax)
}
  8004d4:	90                   	nop
  8004d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004d8:	c9                   	leave  
  8004d9:	c3                   	ret    

008004da <Swap>:

///Private Functions
void Swap(int *Elements, int First, int Second)
{
  8004da:	55                   	push   %ebp
  8004db:	89 e5                	mov    %esp,%ebp
  8004dd:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  8004e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ed:	01 d0                	add    %edx,%eax
  8004ef:	8b 00                	mov    (%eax),%eax
  8004f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  8004f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800501:	01 c2                	add    %eax,%edx
  800503:	8b 45 10             	mov    0x10(%ebp),%eax
  800506:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80050d:	8b 45 08             	mov    0x8(%ebp),%eax
  800510:	01 c8                	add    %ecx,%eax
  800512:	8b 00                	mov    (%eax),%eax
  800514:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800516:	8b 45 10             	mov    0x10(%ebp),%eax
  800519:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800520:	8b 45 08             	mov    0x8(%ebp),%eax
  800523:	01 c2                	add    %eax,%edx
  800525:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800528:	89 02                	mov    %eax,(%edx)
}
  80052a:	90                   	nop
  80052b:	c9                   	leave  
  80052c:	c3                   	ret    

0080052d <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80052d:	55                   	push   %ebp
  80052e:	89 e5                	mov    %esp,%ebp
  800530:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800533:	e8 d4 17 00 00       	call   801d0c <sys_getenvindex>
  800538:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80053b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80053e:	89 d0                	mov    %edx,%eax
  800540:	c1 e0 03             	shl    $0x3,%eax
  800543:	01 d0                	add    %edx,%eax
  800545:	01 c0                	add    %eax,%eax
  800547:	01 d0                	add    %edx,%eax
  800549:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800550:	01 d0                	add    %edx,%eax
  800552:	c1 e0 04             	shl    $0x4,%eax
  800555:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80055a:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80055f:	a1 20 50 80 00       	mov    0x805020,%eax
  800564:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80056a:	84 c0                	test   %al,%al
  80056c:	74 0f                	je     80057d <libmain+0x50>
		binaryname = myEnv->prog_name;
  80056e:	a1 20 50 80 00       	mov    0x805020,%eax
  800573:	05 5c 05 00 00       	add    $0x55c,%eax
  800578:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80057d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800581:	7e 0a                	jle    80058d <libmain+0x60>
		binaryname = argv[0];
  800583:	8b 45 0c             	mov    0xc(%ebp),%eax
  800586:	8b 00                	mov    (%eax),%eax
  800588:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  80058d:	83 ec 08             	sub    $0x8,%esp
  800590:	ff 75 0c             	pushl  0xc(%ebp)
  800593:	ff 75 08             	pushl  0x8(%ebp)
  800596:	e8 9d fa ff ff       	call   800038 <_main>
  80059b:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80059e:	e8 76 15 00 00       	call   801b19 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8005a3:	83 ec 0c             	sub    $0xc,%esp
  8005a6:	68 b8 3a 80 00       	push   $0x803ab8
  8005ab:	e8 8d 01 00 00       	call   80073d <cprintf>
  8005b0:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8005b3:	a1 20 50 80 00       	mov    0x805020,%eax
  8005b8:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8005be:	a1 20 50 80 00       	mov    0x805020,%eax
  8005c3:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8005c9:	83 ec 04             	sub    $0x4,%esp
  8005cc:	52                   	push   %edx
  8005cd:	50                   	push   %eax
  8005ce:	68 e0 3a 80 00       	push   $0x803ae0
  8005d3:	e8 65 01 00 00       	call   80073d <cprintf>
  8005d8:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8005db:	a1 20 50 80 00       	mov    0x805020,%eax
  8005e0:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8005e6:	a1 20 50 80 00       	mov    0x805020,%eax
  8005eb:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8005f1:	a1 20 50 80 00       	mov    0x805020,%eax
  8005f6:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8005fc:	51                   	push   %ecx
  8005fd:	52                   	push   %edx
  8005fe:	50                   	push   %eax
  8005ff:	68 08 3b 80 00       	push   $0x803b08
  800604:	e8 34 01 00 00       	call   80073d <cprintf>
  800609:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80060c:	a1 20 50 80 00       	mov    0x805020,%eax
  800611:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800617:	83 ec 08             	sub    $0x8,%esp
  80061a:	50                   	push   %eax
  80061b:	68 60 3b 80 00       	push   $0x803b60
  800620:	e8 18 01 00 00       	call   80073d <cprintf>
  800625:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800628:	83 ec 0c             	sub    $0xc,%esp
  80062b:	68 b8 3a 80 00       	push   $0x803ab8
  800630:	e8 08 01 00 00       	call   80073d <cprintf>
  800635:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800638:	e8 f6 14 00 00       	call   801b33 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80063d:	e8 19 00 00 00       	call   80065b <exit>
}
  800642:	90                   	nop
  800643:	c9                   	leave  
  800644:	c3                   	ret    

00800645 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800645:	55                   	push   %ebp
  800646:	89 e5                	mov    %esp,%ebp
  800648:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80064b:	83 ec 0c             	sub    $0xc,%esp
  80064e:	6a 00                	push   $0x0
  800650:	e8 83 16 00 00       	call   801cd8 <sys_destroy_env>
  800655:	83 c4 10             	add    $0x10,%esp
}
  800658:	90                   	nop
  800659:	c9                   	leave  
  80065a:	c3                   	ret    

0080065b <exit>:

void
exit(void)
{
  80065b:	55                   	push   %ebp
  80065c:	89 e5                	mov    %esp,%ebp
  80065e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800661:	e8 d8 16 00 00       	call   801d3e <sys_exit_env>
}
  800666:	90                   	nop
  800667:	c9                   	leave  
  800668:	c3                   	ret    

00800669 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800669:	55                   	push   %ebp
  80066a:	89 e5                	mov    %esp,%ebp
  80066c:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80066f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800672:	8b 00                	mov    (%eax),%eax
  800674:	8d 48 01             	lea    0x1(%eax),%ecx
  800677:	8b 55 0c             	mov    0xc(%ebp),%edx
  80067a:	89 0a                	mov    %ecx,(%edx)
  80067c:	8b 55 08             	mov    0x8(%ebp),%edx
  80067f:	88 d1                	mov    %dl,%cl
  800681:	8b 55 0c             	mov    0xc(%ebp),%edx
  800684:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800688:	8b 45 0c             	mov    0xc(%ebp),%eax
  80068b:	8b 00                	mov    (%eax),%eax
  80068d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800692:	75 2c                	jne    8006c0 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800694:	a0 24 50 80 00       	mov    0x805024,%al
  800699:	0f b6 c0             	movzbl %al,%eax
  80069c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80069f:	8b 12                	mov    (%edx),%edx
  8006a1:	89 d1                	mov    %edx,%ecx
  8006a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006a6:	83 c2 08             	add    $0x8,%edx
  8006a9:	83 ec 04             	sub    $0x4,%esp
  8006ac:	50                   	push   %eax
  8006ad:	51                   	push   %ecx
  8006ae:	52                   	push   %edx
  8006af:	e8 b7 12 00 00       	call   80196b <sys_cputs>
  8006b4:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006c3:	8b 40 04             	mov    0x4(%eax),%eax
  8006c6:	8d 50 01             	lea    0x1(%eax),%edx
  8006c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006cc:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006cf:	90                   	nop
  8006d0:	c9                   	leave  
  8006d1:	c3                   	ret    

008006d2 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006d2:	55                   	push   %ebp
  8006d3:	89 e5                	mov    %esp,%ebp
  8006d5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006db:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006e2:	00 00 00 
	b.cnt = 0;
  8006e5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006ec:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006ef:	ff 75 0c             	pushl  0xc(%ebp)
  8006f2:	ff 75 08             	pushl  0x8(%ebp)
  8006f5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006fb:	50                   	push   %eax
  8006fc:	68 69 06 80 00       	push   $0x800669
  800701:	e8 11 02 00 00       	call   800917 <vprintfmt>
  800706:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800709:	a0 24 50 80 00       	mov    0x805024,%al
  80070e:	0f b6 c0             	movzbl %al,%eax
  800711:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800717:	83 ec 04             	sub    $0x4,%esp
  80071a:	50                   	push   %eax
  80071b:	52                   	push   %edx
  80071c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800722:	83 c0 08             	add    $0x8,%eax
  800725:	50                   	push   %eax
  800726:	e8 40 12 00 00       	call   80196b <sys_cputs>
  80072b:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80072e:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800735:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80073b:	c9                   	leave  
  80073c:	c3                   	ret    

0080073d <cprintf>:

int cprintf(const char *fmt, ...) {
  80073d:	55                   	push   %ebp
  80073e:	89 e5                	mov    %esp,%ebp
  800740:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800743:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  80074a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80074d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800750:	8b 45 08             	mov    0x8(%ebp),%eax
  800753:	83 ec 08             	sub    $0x8,%esp
  800756:	ff 75 f4             	pushl  -0xc(%ebp)
  800759:	50                   	push   %eax
  80075a:	e8 73 ff ff ff       	call   8006d2 <vcprintf>
  80075f:	83 c4 10             	add    $0x10,%esp
  800762:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800765:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800768:	c9                   	leave  
  800769:	c3                   	ret    

0080076a <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80076a:	55                   	push   %ebp
  80076b:	89 e5                	mov    %esp,%ebp
  80076d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800770:	e8 a4 13 00 00       	call   801b19 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800775:	8d 45 0c             	lea    0xc(%ebp),%eax
  800778:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80077b:	8b 45 08             	mov    0x8(%ebp),%eax
  80077e:	83 ec 08             	sub    $0x8,%esp
  800781:	ff 75 f4             	pushl  -0xc(%ebp)
  800784:	50                   	push   %eax
  800785:	e8 48 ff ff ff       	call   8006d2 <vcprintf>
  80078a:	83 c4 10             	add    $0x10,%esp
  80078d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800790:	e8 9e 13 00 00       	call   801b33 <sys_enable_interrupt>
	return cnt;
  800795:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800798:	c9                   	leave  
  800799:	c3                   	ret    

0080079a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80079a:	55                   	push   %ebp
  80079b:	89 e5                	mov    %esp,%ebp
  80079d:	53                   	push   %ebx
  80079e:	83 ec 14             	sub    $0x14,%esp
  8007a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007ad:	8b 45 18             	mov    0x18(%ebp),%eax
  8007b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007b8:	77 55                	ja     80080f <printnum+0x75>
  8007ba:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007bd:	72 05                	jb     8007c4 <printnum+0x2a>
  8007bf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007c2:	77 4b                	ja     80080f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007c4:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007c7:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007ca:	8b 45 18             	mov    0x18(%ebp),%eax
  8007cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d2:	52                   	push   %edx
  8007d3:	50                   	push   %eax
  8007d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8007d7:	ff 75 f0             	pushl  -0x10(%ebp)
  8007da:	e8 f1 2f 00 00       	call   8037d0 <__udivdi3>
  8007df:	83 c4 10             	add    $0x10,%esp
  8007e2:	83 ec 04             	sub    $0x4,%esp
  8007e5:	ff 75 20             	pushl  0x20(%ebp)
  8007e8:	53                   	push   %ebx
  8007e9:	ff 75 18             	pushl  0x18(%ebp)
  8007ec:	52                   	push   %edx
  8007ed:	50                   	push   %eax
  8007ee:	ff 75 0c             	pushl  0xc(%ebp)
  8007f1:	ff 75 08             	pushl  0x8(%ebp)
  8007f4:	e8 a1 ff ff ff       	call   80079a <printnum>
  8007f9:	83 c4 20             	add    $0x20,%esp
  8007fc:	eb 1a                	jmp    800818 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8007fe:	83 ec 08             	sub    $0x8,%esp
  800801:	ff 75 0c             	pushl  0xc(%ebp)
  800804:	ff 75 20             	pushl  0x20(%ebp)
  800807:	8b 45 08             	mov    0x8(%ebp),%eax
  80080a:	ff d0                	call   *%eax
  80080c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80080f:	ff 4d 1c             	decl   0x1c(%ebp)
  800812:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800816:	7f e6                	jg     8007fe <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800818:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80081b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800820:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800823:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800826:	53                   	push   %ebx
  800827:	51                   	push   %ecx
  800828:	52                   	push   %edx
  800829:	50                   	push   %eax
  80082a:	e8 b1 30 00 00       	call   8038e0 <__umoddi3>
  80082f:	83 c4 10             	add    $0x10,%esp
  800832:	05 94 3d 80 00       	add    $0x803d94,%eax
  800837:	8a 00                	mov    (%eax),%al
  800839:	0f be c0             	movsbl %al,%eax
  80083c:	83 ec 08             	sub    $0x8,%esp
  80083f:	ff 75 0c             	pushl  0xc(%ebp)
  800842:	50                   	push   %eax
  800843:	8b 45 08             	mov    0x8(%ebp),%eax
  800846:	ff d0                	call   *%eax
  800848:	83 c4 10             	add    $0x10,%esp
}
  80084b:	90                   	nop
  80084c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80084f:	c9                   	leave  
  800850:	c3                   	ret    

00800851 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800851:	55                   	push   %ebp
  800852:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800854:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800858:	7e 1c                	jle    800876 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80085a:	8b 45 08             	mov    0x8(%ebp),%eax
  80085d:	8b 00                	mov    (%eax),%eax
  80085f:	8d 50 08             	lea    0x8(%eax),%edx
  800862:	8b 45 08             	mov    0x8(%ebp),%eax
  800865:	89 10                	mov    %edx,(%eax)
  800867:	8b 45 08             	mov    0x8(%ebp),%eax
  80086a:	8b 00                	mov    (%eax),%eax
  80086c:	83 e8 08             	sub    $0x8,%eax
  80086f:	8b 50 04             	mov    0x4(%eax),%edx
  800872:	8b 00                	mov    (%eax),%eax
  800874:	eb 40                	jmp    8008b6 <getuint+0x65>
	else if (lflag)
  800876:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80087a:	74 1e                	je     80089a <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80087c:	8b 45 08             	mov    0x8(%ebp),%eax
  80087f:	8b 00                	mov    (%eax),%eax
  800881:	8d 50 04             	lea    0x4(%eax),%edx
  800884:	8b 45 08             	mov    0x8(%ebp),%eax
  800887:	89 10                	mov    %edx,(%eax)
  800889:	8b 45 08             	mov    0x8(%ebp),%eax
  80088c:	8b 00                	mov    (%eax),%eax
  80088e:	83 e8 04             	sub    $0x4,%eax
  800891:	8b 00                	mov    (%eax),%eax
  800893:	ba 00 00 00 00       	mov    $0x0,%edx
  800898:	eb 1c                	jmp    8008b6 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80089a:	8b 45 08             	mov    0x8(%ebp),%eax
  80089d:	8b 00                	mov    (%eax),%eax
  80089f:	8d 50 04             	lea    0x4(%eax),%edx
  8008a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a5:	89 10                	mov    %edx,(%eax)
  8008a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008aa:	8b 00                	mov    (%eax),%eax
  8008ac:	83 e8 04             	sub    $0x4,%eax
  8008af:	8b 00                	mov    (%eax),%eax
  8008b1:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008b6:	5d                   	pop    %ebp
  8008b7:	c3                   	ret    

008008b8 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008b8:	55                   	push   %ebp
  8008b9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008bb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008bf:	7e 1c                	jle    8008dd <getint+0x25>
		return va_arg(*ap, long long);
  8008c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c4:	8b 00                	mov    (%eax),%eax
  8008c6:	8d 50 08             	lea    0x8(%eax),%edx
  8008c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cc:	89 10                	mov    %edx,(%eax)
  8008ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d1:	8b 00                	mov    (%eax),%eax
  8008d3:	83 e8 08             	sub    $0x8,%eax
  8008d6:	8b 50 04             	mov    0x4(%eax),%edx
  8008d9:	8b 00                	mov    (%eax),%eax
  8008db:	eb 38                	jmp    800915 <getint+0x5d>
	else if (lflag)
  8008dd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008e1:	74 1a                	je     8008fd <getint+0x45>
		return va_arg(*ap, long);
  8008e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e6:	8b 00                	mov    (%eax),%eax
  8008e8:	8d 50 04             	lea    0x4(%eax),%edx
  8008eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ee:	89 10                	mov    %edx,(%eax)
  8008f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f3:	8b 00                	mov    (%eax),%eax
  8008f5:	83 e8 04             	sub    $0x4,%eax
  8008f8:	8b 00                	mov    (%eax),%eax
  8008fa:	99                   	cltd   
  8008fb:	eb 18                	jmp    800915 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8008fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800900:	8b 00                	mov    (%eax),%eax
  800902:	8d 50 04             	lea    0x4(%eax),%edx
  800905:	8b 45 08             	mov    0x8(%ebp),%eax
  800908:	89 10                	mov    %edx,(%eax)
  80090a:	8b 45 08             	mov    0x8(%ebp),%eax
  80090d:	8b 00                	mov    (%eax),%eax
  80090f:	83 e8 04             	sub    $0x4,%eax
  800912:	8b 00                	mov    (%eax),%eax
  800914:	99                   	cltd   
}
  800915:	5d                   	pop    %ebp
  800916:	c3                   	ret    

00800917 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800917:	55                   	push   %ebp
  800918:	89 e5                	mov    %esp,%ebp
  80091a:	56                   	push   %esi
  80091b:	53                   	push   %ebx
  80091c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80091f:	eb 17                	jmp    800938 <vprintfmt+0x21>
			if (ch == '\0')
  800921:	85 db                	test   %ebx,%ebx
  800923:	0f 84 af 03 00 00    	je     800cd8 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800929:	83 ec 08             	sub    $0x8,%esp
  80092c:	ff 75 0c             	pushl  0xc(%ebp)
  80092f:	53                   	push   %ebx
  800930:	8b 45 08             	mov    0x8(%ebp),%eax
  800933:	ff d0                	call   *%eax
  800935:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800938:	8b 45 10             	mov    0x10(%ebp),%eax
  80093b:	8d 50 01             	lea    0x1(%eax),%edx
  80093e:	89 55 10             	mov    %edx,0x10(%ebp)
  800941:	8a 00                	mov    (%eax),%al
  800943:	0f b6 d8             	movzbl %al,%ebx
  800946:	83 fb 25             	cmp    $0x25,%ebx
  800949:	75 d6                	jne    800921 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80094b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80094f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800956:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80095d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800964:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80096b:	8b 45 10             	mov    0x10(%ebp),%eax
  80096e:	8d 50 01             	lea    0x1(%eax),%edx
  800971:	89 55 10             	mov    %edx,0x10(%ebp)
  800974:	8a 00                	mov    (%eax),%al
  800976:	0f b6 d8             	movzbl %al,%ebx
  800979:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80097c:	83 f8 55             	cmp    $0x55,%eax
  80097f:	0f 87 2b 03 00 00    	ja     800cb0 <vprintfmt+0x399>
  800985:	8b 04 85 b8 3d 80 00 	mov    0x803db8(,%eax,4),%eax
  80098c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80098e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800992:	eb d7                	jmp    80096b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800994:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800998:	eb d1                	jmp    80096b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80099a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009a1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009a4:	89 d0                	mov    %edx,%eax
  8009a6:	c1 e0 02             	shl    $0x2,%eax
  8009a9:	01 d0                	add    %edx,%eax
  8009ab:	01 c0                	add    %eax,%eax
  8009ad:	01 d8                	add    %ebx,%eax
  8009af:	83 e8 30             	sub    $0x30,%eax
  8009b2:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8009b8:	8a 00                	mov    (%eax),%al
  8009ba:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009bd:	83 fb 2f             	cmp    $0x2f,%ebx
  8009c0:	7e 3e                	jle    800a00 <vprintfmt+0xe9>
  8009c2:	83 fb 39             	cmp    $0x39,%ebx
  8009c5:	7f 39                	jg     800a00 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009c7:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009ca:	eb d5                	jmp    8009a1 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8009cf:	83 c0 04             	add    $0x4,%eax
  8009d2:	89 45 14             	mov    %eax,0x14(%ebp)
  8009d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d8:	83 e8 04             	sub    $0x4,%eax
  8009db:	8b 00                	mov    (%eax),%eax
  8009dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8009e0:	eb 1f                	jmp    800a01 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8009e2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009e6:	79 83                	jns    80096b <vprintfmt+0x54>
				width = 0;
  8009e8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8009ef:	e9 77 ff ff ff       	jmp    80096b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8009f4:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8009fb:	e9 6b ff ff ff       	jmp    80096b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a00:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a01:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a05:	0f 89 60 ff ff ff    	jns    80096b <vprintfmt+0x54>
				width = precision, precision = -1;
  800a0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a0e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a11:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a18:	e9 4e ff ff ff       	jmp    80096b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a1d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a20:	e9 46 ff ff ff       	jmp    80096b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a25:	8b 45 14             	mov    0x14(%ebp),%eax
  800a28:	83 c0 04             	add    $0x4,%eax
  800a2b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a2e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a31:	83 e8 04             	sub    $0x4,%eax
  800a34:	8b 00                	mov    (%eax),%eax
  800a36:	83 ec 08             	sub    $0x8,%esp
  800a39:	ff 75 0c             	pushl  0xc(%ebp)
  800a3c:	50                   	push   %eax
  800a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a40:	ff d0                	call   *%eax
  800a42:	83 c4 10             	add    $0x10,%esp
			break;
  800a45:	e9 89 02 00 00       	jmp    800cd3 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a4a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4d:	83 c0 04             	add    $0x4,%eax
  800a50:	89 45 14             	mov    %eax,0x14(%ebp)
  800a53:	8b 45 14             	mov    0x14(%ebp),%eax
  800a56:	83 e8 04             	sub    $0x4,%eax
  800a59:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a5b:	85 db                	test   %ebx,%ebx
  800a5d:	79 02                	jns    800a61 <vprintfmt+0x14a>
				err = -err;
  800a5f:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a61:	83 fb 64             	cmp    $0x64,%ebx
  800a64:	7f 0b                	jg     800a71 <vprintfmt+0x15a>
  800a66:	8b 34 9d 00 3c 80 00 	mov    0x803c00(,%ebx,4),%esi
  800a6d:	85 f6                	test   %esi,%esi
  800a6f:	75 19                	jne    800a8a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a71:	53                   	push   %ebx
  800a72:	68 a5 3d 80 00       	push   $0x803da5
  800a77:	ff 75 0c             	pushl  0xc(%ebp)
  800a7a:	ff 75 08             	pushl  0x8(%ebp)
  800a7d:	e8 5e 02 00 00       	call   800ce0 <printfmt>
  800a82:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a85:	e9 49 02 00 00       	jmp    800cd3 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a8a:	56                   	push   %esi
  800a8b:	68 ae 3d 80 00       	push   $0x803dae
  800a90:	ff 75 0c             	pushl  0xc(%ebp)
  800a93:	ff 75 08             	pushl  0x8(%ebp)
  800a96:	e8 45 02 00 00       	call   800ce0 <printfmt>
  800a9b:	83 c4 10             	add    $0x10,%esp
			break;
  800a9e:	e9 30 02 00 00       	jmp    800cd3 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800aa3:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa6:	83 c0 04             	add    $0x4,%eax
  800aa9:	89 45 14             	mov    %eax,0x14(%ebp)
  800aac:	8b 45 14             	mov    0x14(%ebp),%eax
  800aaf:	83 e8 04             	sub    $0x4,%eax
  800ab2:	8b 30                	mov    (%eax),%esi
  800ab4:	85 f6                	test   %esi,%esi
  800ab6:	75 05                	jne    800abd <vprintfmt+0x1a6>
				p = "(null)";
  800ab8:	be b1 3d 80 00       	mov    $0x803db1,%esi
			if (width > 0 && padc != '-')
  800abd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ac1:	7e 6d                	jle    800b30 <vprintfmt+0x219>
  800ac3:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ac7:	74 67                	je     800b30 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ac9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800acc:	83 ec 08             	sub    $0x8,%esp
  800acf:	50                   	push   %eax
  800ad0:	56                   	push   %esi
  800ad1:	e8 0c 03 00 00       	call   800de2 <strnlen>
  800ad6:	83 c4 10             	add    $0x10,%esp
  800ad9:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800adc:	eb 16                	jmp    800af4 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ade:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ae2:	83 ec 08             	sub    $0x8,%esp
  800ae5:	ff 75 0c             	pushl  0xc(%ebp)
  800ae8:	50                   	push   %eax
  800ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aec:	ff d0                	call   *%eax
  800aee:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800af1:	ff 4d e4             	decl   -0x1c(%ebp)
  800af4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800af8:	7f e4                	jg     800ade <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800afa:	eb 34                	jmp    800b30 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800afc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b00:	74 1c                	je     800b1e <vprintfmt+0x207>
  800b02:	83 fb 1f             	cmp    $0x1f,%ebx
  800b05:	7e 05                	jle    800b0c <vprintfmt+0x1f5>
  800b07:	83 fb 7e             	cmp    $0x7e,%ebx
  800b0a:	7e 12                	jle    800b1e <vprintfmt+0x207>
					putch('?', putdat);
  800b0c:	83 ec 08             	sub    $0x8,%esp
  800b0f:	ff 75 0c             	pushl  0xc(%ebp)
  800b12:	6a 3f                	push   $0x3f
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	ff d0                	call   *%eax
  800b19:	83 c4 10             	add    $0x10,%esp
  800b1c:	eb 0f                	jmp    800b2d <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b1e:	83 ec 08             	sub    $0x8,%esp
  800b21:	ff 75 0c             	pushl  0xc(%ebp)
  800b24:	53                   	push   %ebx
  800b25:	8b 45 08             	mov    0x8(%ebp),%eax
  800b28:	ff d0                	call   *%eax
  800b2a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b2d:	ff 4d e4             	decl   -0x1c(%ebp)
  800b30:	89 f0                	mov    %esi,%eax
  800b32:	8d 70 01             	lea    0x1(%eax),%esi
  800b35:	8a 00                	mov    (%eax),%al
  800b37:	0f be d8             	movsbl %al,%ebx
  800b3a:	85 db                	test   %ebx,%ebx
  800b3c:	74 24                	je     800b62 <vprintfmt+0x24b>
  800b3e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b42:	78 b8                	js     800afc <vprintfmt+0x1e5>
  800b44:	ff 4d e0             	decl   -0x20(%ebp)
  800b47:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b4b:	79 af                	jns    800afc <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b4d:	eb 13                	jmp    800b62 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b4f:	83 ec 08             	sub    $0x8,%esp
  800b52:	ff 75 0c             	pushl  0xc(%ebp)
  800b55:	6a 20                	push   $0x20
  800b57:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5a:	ff d0                	call   *%eax
  800b5c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b5f:	ff 4d e4             	decl   -0x1c(%ebp)
  800b62:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b66:	7f e7                	jg     800b4f <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b68:	e9 66 01 00 00       	jmp    800cd3 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b6d:	83 ec 08             	sub    $0x8,%esp
  800b70:	ff 75 e8             	pushl  -0x18(%ebp)
  800b73:	8d 45 14             	lea    0x14(%ebp),%eax
  800b76:	50                   	push   %eax
  800b77:	e8 3c fd ff ff       	call   8008b8 <getint>
  800b7c:	83 c4 10             	add    $0x10,%esp
  800b7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b82:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b88:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b8b:	85 d2                	test   %edx,%edx
  800b8d:	79 23                	jns    800bb2 <vprintfmt+0x29b>
				putch('-', putdat);
  800b8f:	83 ec 08             	sub    $0x8,%esp
  800b92:	ff 75 0c             	pushl  0xc(%ebp)
  800b95:	6a 2d                	push   $0x2d
  800b97:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9a:	ff d0                	call   *%eax
  800b9c:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ba2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ba5:	f7 d8                	neg    %eax
  800ba7:	83 d2 00             	adc    $0x0,%edx
  800baa:	f7 da                	neg    %edx
  800bac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800baf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bb2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bb9:	e9 bc 00 00 00       	jmp    800c7a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bbe:	83 ec 08             	sub    $0x8,%esp
  800bc1:	ff 75 e8             	pushl  -0x18(%ebp)
  800bc4:	8d 45 14             	lea    0x14(%ebp),%eax
  800bc7:	50                   	push   %eax
  800bc8:	e8 84 fc ff ff       	call   800851 <getuint>
  800bcd:	83 c4 10             	add    $0x10,%esp
  800bd0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bd3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800bd6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bdd:	e9 98 00 00 00       	jmp    800c7a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800be2:	83 ec 08             	sub    $0x8,%esp
  800be5:	ff 75 0c             	pushl  0xc(%ebp)
  800be8:	6a 58                	push   $0x58
  800bea:	8b 45 08             	mov    0x8(%ebp),%eax
  800bed:	ff d0                	call   *%eax
  800bef:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800bf2:	83 ec 08             	sub    $0x8,%esp
  800bf5:	ff 75 0c             	pushl  0xc(%ebp)
  800bf8:	6a 58                	push   $0x58
  800bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfd:	ff d0                	call   *%eax
  800bff:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c02:	83 ec 08             	sub    $0x8,%esp
  800c05:	ff 75 0c             	pushl  0xc(%ebp)
  800c08:	6a 58                	push   $0x58
  800c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0d:	ff d0                	call   *%eax
  800c0f:	83 c4 10             	add    $0x10,%esp
			break;
  800c12:	e9 bc 00 00 00       	jmp    800cd3 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c17:	83 ec 08             	sub    $0x8,%esp
  800c1a:	ff 75 0c             	pushl  0xc(%ebp)
  800c1d:	6a 30                	push   $0x30
  800c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c22:	ff d0                	call   *%eax
  800c24:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c27:	83 ec 08             	sub    $0x8,%esp
  800c2a:	ff 75 0c             	pushl  0xc(%ebp)
  800c2d:	6a 78                	push   $0x78
  800c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c32:	ff d0                	call   *%eax
  800c34:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c37:	8b 45 14             	mov    0x14(%ebp),%eax
  800c3a:	83 c0 04             	add    $0x4,%eax
  800c3d:	89 45 14             	mov    %eax,0x14(%ebp)
  800c40:	8b 45 14             	mov    0x14(%ebp),%eax
  800c43:	83 e8 04             	sub    $0x4,%eax
  800c46:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c48:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c4b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c52:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c59:	eb 1f                	jmp    800c7a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c5b:	83 ec 08             	sub    $0x8,%esp
  800c5e:	ff 75 e8             	pushl  -0x18(%ebp)
  800c61:	8d 45 14             	lea    0x14(%ebp),%eax
  800c64:	50                   	push   %eax
  800c65:	e8 e7 fb ff ff       	call   800851 <getuint>
  800c6a:	83 c4 10             	add    $0x10,%esp
  800c6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c70:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c73:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c7a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c81:	83 ec 04             	sub    $0x4,%esp
  800c84:	52                   	push   %edx
  800c85:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c88:	50                   	push   %eax
  800c89:	ff 75 f4             	pushl  -0xc(%ebp)
  800c8c:	ff 75 f0             	pushl  -0x10(%ebp)
  800c8f:	ff 75 0c             	pushl  0xc(%ebp)
  800c92:	ff 75 08             	pushl  0x8(%ebp)
  800c95:	e8 00 fb ff ff       	call   80079a <printnum>
  800c9a:	83 c4 20             	add    $0x20,%esp
			break;
  800c9d:	eb 34                	jmp    800cd3 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c9f:	83 ec 08             	sub    $0x8,%esp
  800ca2:	ff 75 0c             	pushl  0xc(%ebp)
  800ca5:	53                   	push   %ebx
  800ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca9:	ff d0                	call   *%eax
  800cab:	83 c4 10             	add    $0x10,%esp
			break;
  800cae:	eb 23                	jmp    800cd3 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cb0:	83 ec 08             	sub    $0x8,%esp
  800cb3:	ff 75 0c             	pushl  0xc(%ebp)
  800cb6:	6a 25                	push   $0x25
  800cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbb:	ff d0                	call   *%eax
  800cbd:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cc0:	ff 4d 10             	decl   0x10(%ebp)
  800cc3:	eb 03                	jmp    800cc8 <vprintfmt+0x3b1>
  800cc5:	ff 4d 10             	decl   0x10(%ebp)
  800cc8:	8b 45 10             	mov    0x10(%ebp),%eax
  800ccb:	48                   	dec    %eax
  800ccc:	8a 00                	mov    (%eax),%al
  800cce:	3c 25                	cmp    $0x25,%al
  800cd0:	75 f3                	jne    800cc5 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800cd2:	90                   	nop
		}
	}
  800cd3:	e9 47 fc ff ff       	jmp    80091f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800cd8:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800cd9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800cdc:	5b                   	pop    %ebx
  800cdd:	5e                   	pop    %esi
  800cde:	5d                   	pop    %ebp
  800cdf:	c3                   	ret    

00800ce0 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ce0:	55                   	push   %ebp
  800ce1:	89 e5                	mov    %esp,%ebp
  800ce3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ce6:	8d 45 10             	lea    0x10(%ebp),%eax
  800ce9:	83 c0 04             	add    $0x4,%eax
  800cec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800cef:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf2:	ff 75 f4             	pushl  -0xc(%ebp)
  800cf5:	50                   	push   %eax
  800cf6:	ff 75 0c             	pushl  0xc(%ebp)
  800cf9:	ff 75 08             	pushl  0x8(%ebp)
  800cfc:	e8 16 fc ff ff       	call   800917 <vprintfmt>
  800d01:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d04:	90                   	nop
  800d05:	c9                   	leave  
  800d06:	c3                   	ret    

00800d07 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d07:	55                   	push   %ebp
  800d08:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0d:	8b 40 08             	mov    0x8(%eax),%eax
  800d10:	8d 50 01             	lea    0x1(%eax),%edx
  800d13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d16:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1c:	8b 10                	mov    (%eax),%edx
  800d1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d21:	8b 40 04             	mov    0x4(%eax),%eax
  800d24:	39 c2                	cmp    %eax,%edx
  800d26:	73 12                	jae    800d3a <sprintputch+0x33>
		*b->buf++ = ch;
  800d28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2b:	8b 00                	mov    (%eax),%eax
  800d2d:	8d 48 01             	lea    0x1(%eax),%ecx
  800d30:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d33:	89 0a                	mov    %ecx,(%edx)
  800d35:	8b 55 08             	mov    0x8(%ebp),%edx
  800d38:	88 10                	mov    %dl,(%eax)
}
  800d3a:	90                   	nop
  800d3b:	5d                   	pop    %ebp
  800d3c:	c3                   	ret    

00800d3d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d3d:	55                   	push   %ebp
  800d3e:	89 e5                	mov    %esp,%ebp
  800d40:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d43:	8b 45 08             	mov    0x8(%ebp),%eax
  800d46:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d52:	01 d0                	add    %edx,%eax
  800d54:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d57:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d5e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d62:	74 06                	je     800d6a <vsnprintf+0x2d>
  800d64:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d68:	7f 07                	jg     800d71 <vsnprintf+0x34>
		return -E_INVAL;
  800d6a:	b8 03 00 00 00       	mov    $0x3,%eax
  800d6f:	eb 20                	jmp    800d91 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d71:	ff 75 14             	pushl  0x14(%ebp)
  800d74:	ff 75 10             	pushl  0x10(%ebp)
  800d77:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d7a:	50                   	push   %eax
  800d7b:	68 07 0d 80 00       	push   $0x800d07
  800d80:	e8 92 fb ff ff       	call   800917 <vprintfmt>
  800d85:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d8b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d91:	c9                   	leave  
  800d92:	c3                   	ret    

00800d93 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d93:	55                   	push   %ebp
  800d94:	89 e5                	mov    %esp,%ebp
  800d96:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d99:	8d 45 10             	lea    0x10(%ebp),%eax
  800d9c:	83 c0 04             	add    $0x4,%eax
  800d9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800da2:	8b 45 10             	mov    0x10(%ebp),%eax
  800da5:	ff 75 f4             	pushl  -0xc(%ebp)
  800da8:	50                   	push   %eax
  800da9:	ff 75 0c             	pushl  0xc(%ebp)
  800dac:	ff 75 08             	pushl  0x8(%ebp)
  800daf:	e8 89 ff ff ff       	call   800d3d <vsnprintf>
  800db4:	83 c4 10             	add    $0x10,%esp
  800db7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800dba:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800dbd:	c9                   	leave  
  800dbe:	c3                   	ret    

00800dbf <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800dbf:	55                   	push   %ebp
  800dc0:	89 e5                	mov    %esp,%ebp
  800dc2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800dc5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dcc:	eb 06                	jmp    800dd4 <strlen+0x15>
		n++;
  800dce:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800dd1:	ff 45 08             	incl   0x8(%ebp)
  800dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd7:	8a 00                	mov    (%eax),%al
  800dd9:	84 c0                	test   %al,%al
  800ddb:	75 f1                	jne    800dce <strlen+0xf>
		n++;
	return n;
  800ddd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800de0:	c9                   	leave  
  800de1:	c3                   	ret    

00800de2 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800de2:	55                   	push   %ebp
  800de3:	89 e5                	mov    %esp,%ebp
  800de5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800de8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800def:	eb 09                	jmp    800dfa <strnlen+0x18>
		n++;
  800df1:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800df4:	ff 45 08             	incl   0x8(%ebp)
  800df7:	ff 4d 0c             	decl   0xc(%ebp)
  800dfa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dfe:	74 09                	je     800e09 <strnlen+0x27>
  800e00:	8b 45 08             	mov    0x8(%ebp),%eax
  800e03:	8a 00                	mov    (%eax),%al
  800e05:	84 c0                	test   %al,%al
  800e07:	75 e8                	jne    800df1 <strnlen+0xf>
		n++;
	return n;
  800e09:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e0c:	c9                   	leave  
  800e0d:	c3                   	ret    

00800e0e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e0e:	55                   	push   %ebp
  800e0f:	89 e5                	mov    %esp,%ebp
  800e11:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e14:	8b 45 08             	mov    0x8(%ebp),%eax
  800e17:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e1a:	90                   	nop
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1e:	8d 50 01             	lea    0x1(%eax),%edx
  800e21:	89 55 08             	mov    %edx,0x8(%ebp)
  800e24:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e27:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e2a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e2d:	8a 12                	mov    (%edx),%dl
  800e2f:	88 10                	mov    %dl,(%eax)
  800e31:	8a 00                	mov    (%eax),%al
  800e33:	84 c0                	test   %al,%al
  800e35:	75 e4                	jne    800e1b <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e37:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e3a:	c9                   	leave  
  800e3b:	c3                   	ret    

00800e3c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e3c:	55                   	push   %ebp
  800e3d:	89 e5                	mov    %esp,%ebp
  800e3f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e42:	8b 45 08             	mov    0x8(%ebp),%eax
  800e45:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e48:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e4f:	eb 1f                	jmp    800e70 <strncpy+0x34>
		*dst++ = *src;
  800e51:	8b 45 08             	mov    0x8(%ebp),%eax
  800e54:	8d 50 01             	lea    0x1(%eax),%edx
  800e57:	89 55 08             	mov    %edx,0x8(%ebp)
  800e5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e5d:	8a 12                	mov    (%edx),%dl
  800e5f:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e64:	8a 00                	mov    (%eax),%al
  800e66:	84 c0                	test   %al,%al
  800e68:	74 03                	je     800e6d <strncpy+0x31>
			src++;
  800e6a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e6d:	ff 45 fc             	incl   -0x4(%ebp)
  800e70:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e73:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e76:	72 d9                	jb     800e51 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e78:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e7b:	c9                   	leave  
  800e7c:	c3                   	ret    

00800e7d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e7d:	55                   	push   %ebp
  800e7e:	89 e5                	mov    %esp,%ebp
  800e80:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e83:	8b 45 08             	mov    0x8(%ebp),%eax
  800e86:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e89:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e8d:	74 30                	je     800ebf <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e8f:	eb 16                	jmp    800ea7 <strlcpy+0x2a>
			*dst++ = *src++;
  800e91:	8b 45 08             	mov    0x8(%ebp),%eax
  800e94:	8d 50 01             	lea    0x1(%eax),%edx
  800e97:	89 55 08             	mov    %edx,0x8(%ebp)
  800e9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e9d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ea0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ea3:	8a 12                	mov    (%edx),%dl
  800ea5:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ea7:	ff 4d 10             	decl   0x10(%ebp)
  800eaa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eae:	74 09                	je     800eb9 <strlcpy+0x3c>
  800eb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb3:	8a 00                	mov    (%eax),%al
  800eb5:	84 c0                	test   %al,%al
  800eb7:	75 d8                	jne    800e91 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebc:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ebf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec5:	29 c2                	sub    %eax,%edx
  800ec7:	89 d0                	mov    %edx,%eax
}
  800ec9:	c9                   	leave  
  800eca:	c3                   	ret    

00800ecb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ecb:	55                   	push   %ebp
  800ecc:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ece:	eb 06                	jmp    800ed6 <strcmp+0xb>
		p++, q++;
  800ed0:	ff 45 08             	incl   0x8(%ebp)
  800ed3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed9:	8a 00                	mov    (%eax),%al
  800edb:	84 c0                	test   %al,%al
  800edd:	74 0e                	je     800eed <strcmp+0x22>
  800edf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee2:	8a 10                	mov    (%eax),%dl
  800ee4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee7:	8a 00                	mov    (%eax),%al
  800ee9:	38 c2                	cmp    %al,%dl
  800eeb:	74 e3                	je     800ed0 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800eed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef0:	8a 00                	mov    (%eax),%al
  800ef2:	0f b6 d0             	movzbl %al,%edx
  800ef5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef8:	8a 00                	mov    (%eax),%al
  800efa:	0f b6 c0             	movzbl %al,%eax
  800efd:	29 c2                	sub    %eax,%edx
  800eff:	89 d0                	mov    %edx,%eax
}
  800f01:	5d                   	pop    %ebp
  800f02:	c3                   	ret    

00800f03 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f03:	55                   	push   %ebp
  800f04:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f06:	eb 09                	jmp    800f11 <strncmp+0xe>
		n--, p++, q++;
  800f08:	ff 4d 10             	decl   0x10(%ebp)
  800f0b:	ff 45 08             	incl   0x8(%ebp)
  800f0e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f11:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f15:	74 17                	je     800f2e <strncmp+0x2b>
  800f17:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1a:	8a 00                	mov    (%eax),%al
  800f1c:	84 c0                	test   %al,%al
  800f1e:	74 0e                	je     800f2e <strncmp+0x2b>
  800f20:	8b 45 08             	mov    0x8(%ebp),%eax
  800f23:	8a 10                	mov    (%eax),%dl
  800f25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f28:	8a 00                	mov    (%eax),%al
  800f2a:	38 c2                	cmp    %al,%dl
  800f2c:	74 da                	je     800f08 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f2e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f32:	75 07                	jne    800f3b <strncmp+0x38>
		return 0;
  800f34:	b8 00 00 00 00       	mov    $0x0,%eax
  800f39:	eb 14                	jmp    800f4f <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3e:	8a 00                	mov    (%eax),%al
  800f40:	0f b6 d0             	movzbl %al,%edx
  800f43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f46:	8a 00                	mov    (%eax),%al
  800f48:	0f b6 c0             	movzbl %al,%eax
  800f4b:	29 c2                	sub    %eax,%edx
  800f4d:	89 d0                	mov    %edx,%eax
}
  800f4f:	5d                   	pop    %ebp
  800f50:	c3                   	ret    

00800f51 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f51:	55                   	push   %ebp
  800f52:	89 e5                	mov    %esp,%ebp
  800f54:	83 ec 04             	sub    $0x4,%esp
  800f57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f5d:	eb 12                	jmp    800f71 <strchr+0x20>
		if (*s == c)
  800f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f62:	8a 00                	mov    (%eax),%al
  800f64:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f67:	75 05                	jne    800f6e <strchr+0x1d>
			return (char *) s;
  800f69:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6c:	eb 11                	jmp    800f7f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f6e:	ff 45 08             	incl   0x8(%ebp)
  800f71:	8b 45 08             	mov    0x8(%ebp),%eax
  800f74:	8a 00                	mov    (%eax),%al
  800f76:	84 c0                	test   %al,%al
  800f78:	75 e5                	jne    800f5f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f7f:	c9                   	leave  
  800f80:	c3                   	ret    

00800f81 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f81:	55                   	push   %ebp
  800f82:	89 e5                	mov    %esp,%ebp
  800f84:	83 ec 04             	sub    $0x4,%esp
  800f87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f8d:	eb 0d                	jmp    800f9c <strfind+0x1b>
		if (*s == c)
  800f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f92:	8a 00                	mov    (%eax),%al
  800f94:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f97:	74 0e                	je     800fa7 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f99:	ff 45 08             	incl   0x8(%ebp)
  800f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9f:	8a 00                	mov    (%eax),%al
  800fa1:	84 c0                	test   %al,%al
  800fa3:	75 ea                	jne    800f8f <strfind+0xe>
  800fa5:	eb 01                	jmp    800fa8 <strfind+0x27>
		if (*s == c)
			break;
  800fa7:	90                   	nop
	return (char *) s;
  800fa8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fab:	c9                   	leave  
  800fac:	c3                   	ret    

00800fad <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800fad:	55                   	push   %ebp
  800fae:	89 e5                	mov    %esp,%ebp
  800fb0:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800fb9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800fbf:	eb 0e                	jmp    800fcf <memset+0x22>
		*p++ = c;
  800fc1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc4:	8d 50 01             	lea    0x1(%eax),%edx
  800fc7:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fca:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fcd:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800fcf:	ff 4d f8             	decl   -0x8(%ebp)
  800fd2:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800fd6:	79 e9                	jns    800fc1 <memset+0x14>
		*p++ = c;

	return v;
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fdb:	c9                   	leave  
  800fdc:	c3                   	ret    

00800fdd <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800fdd:	55                   	push   %ebp
  800fde:	89 e5                	mov    %esp,%ebp
  800fe0:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800fe3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fec:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800fef:	eb 16                	jmp    801007 <memcpy+0x2a>
		*d++ = *s++;
  800ff1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff4:	8d 50 01             	lea    0x1(%eax),%edx
  800ff7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ffa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ffd:	8d 4a 01             	lea    0x1(%edx),%ecx
  801000:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801003:	8a 12                	mov    (%edx),%dl
  801005:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801007:	8b 45 10             	mov    0x10(%ebp),%eax
  80100a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80100d:	89 55 10             	mov    %edx,0x10(%ebp)
  801010:	85 c0                	test   %eax,%eax
  801012:	75 dd                	jne    800ff1 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801014:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801017:	c9                   	leave  
  801018:	c3                   	ret    

00801019 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801019:	55                   	push   %ebp
  80101a:	89 e5                	mov    %esp,%ebp
  80101c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80101f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801022:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801025:	8b 45 08             	mov    0x8(%ebp),%eax
  801028:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80102b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80102e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801031:	73 50                	jae    801083 <memmove+0x6a>
  801033:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801036:	8b 45 10             	mov    0x10(%ebp),%eax
  801039:	01 d0                	add    %edx,%eax
  80103b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80103e:	76 43                	jbe    801083 <memmove+0x6a>
		s += n;
  801040:	8b 45 10             	mov    0x10(%ebp),%eax
  801043:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801046:	8b 45 10             	mov    0x10(%ebp),%eax
  801049:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80104c:	eb 10                	jmp    80105e <memmove+0x45>
			*--d = *--s;
  80104e:	ff 4d f8             	decl   -0x8(%ebp)
  801051:	ff 4d fc             	decl   -0x4(%ebp)
  801054:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801057:	8a 10                	mov    (%eax),%dl
  801059:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80105c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80105e:	8b 45 10             	mov    0x10(%ebp),%eax
  801061:	8d 50 ff             	lea    -0x1(%eax),%edx
  801064:	89 55 10             	mov    %edx,0x10(%ebp)
  801067:	85 c0                	test   %eax,%eax
  801069:	75 e3                	jne    80104e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80106b:	eb 23                	jmp    801090 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80106d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801070:	8d 50 01             	lea    0x1(%eax),%edx
  801073:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801076:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801079:	8d 4a 01             	lea    0x1(%edx),%ecx
  80107c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80107f:	8a 12                	mov    (%edx),%dl
  801081:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801083:	8b 45 10             	mov    0x10(%ebp),%eax
  801086:	8d 50 ff             	lea    -0x1(%eax),%edx
  801089:	89 55 10             	mov    %edx,0x10(%ebp)
  80108c:	85 c0                	test   %eax,%eax
  80108e:	75 dd                	jne    80106d <memmove+0x54>
			*d++ = *s++;

	return dst;
  801090:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801093:	c9                   	leave  
  801094:	c3                   	ret    

00801095 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801095:	55                   	push   %ebp
  801096:	89 e5                	mov    %esp,%ebp
  801098:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80109b:	8b 45 08             	mov    0x8(%ebp),%eax
  80109e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a4:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010a7:	eb 2a                	jmp    8010d3 <memcmp+0x3e>
		if (*s1 != *s2)
  8010a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ac:	8a 10                	mov    (%eax),%dl
  8010ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010b1:	8a 00                	mov    (%eax),%al
  8010b3:	38 c2                	cmp    %al,%dl
  8010b5:	74 16                	je     8010cd <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ba:	8a 00                	mov    (%eax),%al
  8010bc:	0f b6 d0             	movzbl %al,%edx
  8010bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c2:	8a 00                	mov    (%eax),%al
  8010c4:	0f b6 c0             	movzbl %al,%eax
  8010c7:	29 c2                	sub    %eax,%edx
  8010c9:	89 d0                	mov    %edx,%eax
  8010cb:	eb 18                	jmp    8010e5 <memcmp+0x50>
		s1++, s2++;
  8010cd:	ff 45 fc             	incl   -0x4(%ebp)
  8010d0:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8010d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010d9:	89 55 10             	mov    %edx,0x10(%ebp)
  8010dc:	85 c0                	test   %eax,%eax
  8010de:	75 c9                	jne    8010a9 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8010e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010e5:	c9                   	leave  
  8010e6:	c3                   	ret    

008010e7 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8010e7:	55                   	push   %ebp
  8010e8:	89 e5                	mov    %esp,%ebp
  8010ea:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8010ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f3:	01 d0                	add    %edx,%eax
  8010f5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8010f8:	eb 15                	jmp    80110f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8010fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fd:	8a 00                	mov    (%eax),%al
  8010ff:	0f b6 d0             	movzbl %al,%edx
  801102:	8b 45 0c             	mov    0xc(%ebp),%eax
  801105:	0f b6 c0             	movzbl %al,%eax
  801108:	39 c2                	cmp    %eax,%edx
  80110a:	74 0d                	je     801119 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80110c:	ff 45 08             	incl   0x8(%ebp)
  80110f:	8b 45 08             	mov    0x8(%ebp),%eax
  801112:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801115:	72 e3                	jb     8010fa <memfind+0x13>
  801117:	eb 01                	jmp    80111a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801119:	90                   	nop
	return (void *) s;
  80111a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80111d:	c9                   	leave  
  80111e:	c3                   	ret    

0080111f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80111f:	55                   	push   %ebp
  801120:	89 e5                	mov    %esp,%ebp
  801122:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801125:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80112c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801133:	eb 03                	jmp    801138 <strtol+0x19>
		s++;
  801135:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801138:	8b 45 08             	mov    0x8(%ebp),%eax
  80113b:	8a 00                	mov    (%eax),%al
  80113d:	3c 20                	cmp    $0x20,%al
  80113f:	74 f4                	je     801135 <strtol+0x16>
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
  801144:	8a 00                	mov    (%eax),%al
  801146:	3c 09                	cmp    $0x9,%al
  801148:	74 eb                	je     801135 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80114a:	8b 45 08             	mov    0x8(%ebp),%eax
  80114d:	8a 00                	mov    (%eax),%al
  80114f:	3c 2b                	cmp    $0x2b,%al
  801151:	75 05                	jne    801158 <strtol+0x39>
		s++;
  801153:	ff 45 08             	incl   0x8(%ebp)
  801156:	eb 13                	jmp    80116b <strtol+0x4c>
	else if (*s == '-')
  801158:	8b 45 08             	mov    0x8(%ebp),%eax
  80115b:	8a 00                	mov    (%eax),%al
  80115d:	3c 2d                	cmp    $0x2d,%al
  80115f:	75 0a                	jne    80116b <strtol+0x4c>
		s++, neg = 1;
  801161:	ff 45 08             	incl   0x8(%ebp)
  801164:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80116b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80116f:	74 06                	je     801177 <strtol+0x58>
  801171:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801175:	75 20                	jne    801197 <strtol+0x78>
  801177:	8b 45 08             	mov    0x8(%ebp),%eax
  80117a:	8a 00                	mov    (%eax),%al
  80117c:	3c 30                	cmp    $0x30,%al
  80117e:	75 17                	jne    801197 <strtol+0x78>
  801180:	8b 45 08             	mov    0x8(%ebp),%eax
  801183:	40                   	inc    %eax
  801184:	8a 00                	mov    (%eax),%al
  801186:	3c 78                	cmp    $0x78,%al
  801188:	75 0d                	jne    801197 <strtol+0x78>
		s += 2, base = 16;
  80118a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80118e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801195:	eb 28                	jmp    8011bf <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801197:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80119b:	75 15                	jne    8011b2 <strtol+0x93>
  80119d:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a0:	8a 00                	mov    (%eax),%al
  8011a2:	3c 30                	cmp    $0x30,%al
  8011a4:	75 0c                	jne    8011b2 <strtol+0x93>
		s++, base = 8;
  8011a6:	ff 45 08             	incl   0x8(%ebp)
  8011a9:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011b0:	eb 0d                	jmp    8011bf <strtol+0xa0>
	else if (base == 0)
  8011b2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011b6:	75 07                	jne    8011bf <strtol+0xa0>
		base = 10;
  8011b8:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c2:	8a 00                	mov    (%eax),%al
  8011c4:	3c 2f                	cmp    $0x2f,%al
  8011c6:	7e 19                	jle    8011e1 <strtol+0xc2>
  8011c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cb:	8a 00                	mov    (%eax),%al
  8011cd:	3c 39                	cmp    $0x39,%al
  8011cf:	7f 10                	jg     8011e1 <strtol+0xc2>
			dig = *s - '0';
  8011d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d4:	8a 00                	mov    (%eax),%al
  8011d6:	0f be c0             	movsbl %al,%eax
  8011d9:	83 e8 30             	sub    $0x30,%eax
  8011dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011df:	eb 42                	jmp    801223 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8011e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e4:	8a 00                	mov    (%eax),%al
  8011e6:	3c 60                	cmp    $0x60,%al
  8011e8:	7e 19                	jle    801203 <strtol+0xe4>
  8011ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ed:	8a 00                	mov    (%eax),%al
  8011ef:	3c 7a                	cmp    $0x7a,%al
  8011f1:	7f 10                	jg     801203 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8011f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f6:	8a 00                	mov    (%eax),%al
  8011f8:	0f be c0             	movsbl %al,%eax
  8011fb:	83 e8 57             	sub    $0x57,%eax
  8011fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801201:	eb 20                	jmp    801223 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801203:	8b 45 08             	mov    0x8(%ebp),%eax
  801206:	8a 00                	mov    (%eax),%al
  801208:	3c 40                	cmp    $0x40,%al
  80120a:	7e 39                	jle    801245 <strtol+0x126>
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	8a 00                	mov    (%eax),%al
  801211:	3c 5a                	cmp    $0x5a,%al
  801213:	7f 30                	jg     801245 <strtol+0x126>
			dig = *s - 'A' + 10;
  801215:	8b 45 08             	mov    0x8(%ebp),%eax
  801218:	8a 00                	mov    (%eax),%al
  80121a:	0f be c0             	movsbl %al,%eax
  80121d:	83 e8 37             	sub    $0x37,%eax
  801220:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801223:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801226:	3b 45 10             	cmp    0x10(%ebp),%eax
  801229:	7d 19                	jge    801244 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80122b:	ff 45 08             	incl   0x8(%ebp)
  80122e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801231:	0f af 45 10          	imul   0x10(%ebp),%eax
  801235:	89 c2                	mov    %eax,%edx
  801237:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80123a:	01 d0                	add    %edx,%eax
  80123c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80123f:	e9 7b ff ff ff       	jmp    8011bf <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801244:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801245:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801249:	74 08                	je     801253 <strtol+0x134>
		*endptr = (char *) s;
  80124b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124e:	8b 55 08             	mov    0x8(%ebp),%edx
  801251:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801253:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801257:	74 07                	je     801260 <strtol+0x141>
  801259:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80125c:	f7 d8                	neg    %eax
  80125e:	eb 03                	jmp    801263 <strtol+0x144>
  801260:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801263:	c9                   	leave  
  801264:	c3                   	ret    

00801265 <ltostr>:

void
ltostr(long value, char *str)
{
  801265:	55                   	push   %ebp
  801266:	89 e5                	mov    %esp,%ebp
  801268:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80126b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801272:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801279:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80127d:	79 13                	jns    801292 <ltostr+0x2d>
	{
		neg = 1;
  80127f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801286:	8b 45 0c             	mov    0xc(%ebp),%eax
  801289:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80128c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80128f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801292:	8b 45 08             	mov    0x8(%ebp),%eax
  801295:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80129a:	99                   	cltd   
  80129b:	f7 f9                	idiv   %ecx
  80129d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012a3:	8d 50 01             	lea    0x1(%eax),%edx
  8012a6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012a9:	89 c2                	mov    %eax,%edx
  8012ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ae:	01 d0                	add    %edx,%eax
  8012b0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012b3:	83 c2 30             	add    $0x30,%edx
  8012b6:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012bb:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012c0:	f7 e9                	imul   %ecx
  8012c2:	c1 fa 02             	sar    $0x2,%edx
  8012c5:	89 c8                	mov    %ecx,%eax
  8012c7:	c1 f8 1f             	sar    $0x1f,%eax
  8012ca:	29 c2                	sub    %eax,%edx
  8012cc:	89 d0                	mov    %edx,%eax
  8012ce:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8012d1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012d4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012d9:	f7 e9                	imul   %ecx
  8012db:	c1 fa 02             	sar    $0x2,%edx
  8012de:	89 c8                	mov    %ecx,%eax
  8012e0:	c1 f8 1f             	sar    $0x1f,%eax
  8012e3:	29 c2                	sub    %eax,%edx
  8012e5:	89 d0                	mov    %edx,%eax
  8012e7:	c1 e0 02             	shl    $0x2,%eax
  8012ea:	01 d0                	add    %edx,%eax
  8012ec:	01 c0                	add    %eax,%eax
  8012ee:	29 c1                	sub    %eax,%ecx
  8012f0:	89 ca                	mov    %ecx,%edx
  8012f2:	85 d2                	test   %edx,%edx
  8012f4:	75 9c                	jne    801292 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8012f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8012fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801300:	48                   	dec    %eax
  801301:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801304:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801308:	74 3d                	je     801347 <ltostr+0xe2>
		start = 1 ;
  80130a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801311:	eb 34                	jmp    801347 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801313:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801316:	8b 45 0c             	mov    0xc(%ebp),%eax
  801319:	01 d0                	add    %edx,%eax
  80131b:	8a 00                	mov    (%eax),%al
  80131d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801320:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801323:	8b 45 0c             	mov    0xc(%ebp),%eax
  801326:	01 c2                	add    %eax,%edx
  801328:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80132b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132e:	01 c8                	add    %ecx,%eax
  801330:	8a 00                	mov    (%eax),%al
  801332:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801334:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801337:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133a:	01 c2                	add    %eax,%edx
  80133c:	8a 45 eb             	mov    -0x15(%ebp),%al
  80133f:	88 02                	mov    %al,(%edx)
		start++ ;
  801341:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801344:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801347:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80134a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80134d:	7c c4                	jl     801313 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80134f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801352:	8b 45 0c             	mov    0xc(%ebp),%eax
  801355:	01 d0                	add    %edx,%eax
  801357:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80135a:	90                   	nop
  80135b:	c9                   	leave  
  80135c:	c3                   	ret    

0080135d <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80135d:	55                   	push   %ebp
  80135e:	89 e5                	mov    %esp,%ebp
  801360:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801363:	ff 75 08             	pushl  0x8(%ebp)
  801366:	e8 54 fa ff ff       	call   800dbf <strlen>
  80136b:	83 c4 04             	add    $0x4,%esp
  80136e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801371:	ff 75 0c             	pushl  0xc(%ebp)
  801374:	e8 46 fa ff ff       	call   800dbf <strlen>
  801379:	83 c4 04             	add    $0x4,%esp
  80137c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80137f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801386:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80138d:	eb 17                	jmp    8013a6 <strcconcat+0x49>
		final[s] = str1[s] ;
  80138f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801392:	8b 45 10             	mov    0x10(%ebp),%eax
  801395:	01 c2                	add    %eax,%edx
  801397:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80139a:	8b 45 08             	mov    0x8(%ebp),%eax
  80139d:	01 c8                	add    %ecx,%eax
  80139f:	8a 00                	mov    (%eax),%al
  8013a1:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013a3:	ff 45 fc             	incl   -0x4(%ebp)
  8013a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013a9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013ac:	7c e1                	jl     80138f <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013ae:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013b5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013bc:	eb 1f                	jmp    8013dd <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013c1:	8d 50 01             	lea    0x1(%eax),%edx
  8013c4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013c7:	89 c2                	mov    %eax,%edx
  8013c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8013cc:	01 c2                	add    %eax,%edx
  8013ce:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8013d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d4:	01 c8                	add    %ecx,%eax
  8013d6:	8a 00                	mov    (%eax),%al
  8013d8:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8013da:	ff 45 f8             	incl   -0x8(%ebp)
  8013dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013e0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013e3:	7c d9                	jl     8013be <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8013e5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8013eb:	01 d0                	add    %edx,%eax
  8013ed:	c6 00 00             	movb   $0x0,(%eax)
}
  8013f0:	90                   	nop
  8013f1:	c9                   	leave  
  8013f2:	c3                   	ret    

008013f3 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8013f3:	55                   	push   %ebp
  8013f4:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8013f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8013f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8013ff:	8b 45 14             	mov    0x14(%ebp),%eax
  801402:	8b 00                	mov    (%eax),%eax
  801404:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80140b:	8b 45 10             	mov    0x10(%ebp),%eax
  80140e:	01 d0                	add    %edx,%eax
  801410:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801416:	eb 0c                	jmp    801424 <strsplit+0x31>
			*string++ = 0;
  801418:	8b 45 08             	mov    0x8(%ebp),%eax
  80141b:	8d 50 01             	lea    0x1(%eax),%edx
  80141e:	89 55 08             	mov    %edx,0x8(%ebp)
  801421:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801424:	8b 45 08             	mov    0x8(%ebp),%eax
  801427:	8a 00                	mov    (%eax),%al
  801429:	84 c0                	test   %al,%al
  80142b:	74 18                	je     801445 <strsplit+0x52>
  80142d:	8b 45 08             	mov    0x8(%ebp),%eax
  801430:	8a 00                	mov    (%eax),%al
  801432:	0f be c0             	movsbl %al,%eax
  801435:	50                   	push   %eax
  801436:	ff 75 0c             	pushl  0xc(%ebp)
  801439:	e8 13 fb ff ff       	call   800f51 <strchr>
  80143e:	83 c4 08             	add    $0x8,%esp
  801441:	85 c0                	test   %eax,%eax
  801443:	75 d3                	jne    801418 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801445:	8b 45 08             	mov    0x8(%ebp),%eax
  801448:	8a 00                	mov    (%eax),%al
  80144a:	84 c0                	test   %al,%al
  80144c:	74 5a                	je     8014a8 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80144e:	8b 45 14             	mov    0x14(%ebp),%eax
  801451:	8b 00                	mov    (%eax),%eax
  801453:	83 f8 0f             	cmp    $0xf,%eax
  801456:	75 07                	jne    80145f <strsplit+0x6c>
		{
			return 0;
  801458:	b8 00 00 00 00       	mov    $0x0,%eax
  80145d:	eb 66                	jmp    8014c5 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80145f:	8b 45 14             	mov    0x14(%ebp),%eax
  801462:	8b 00                	mov    (%eax),%eax
  801464:	8d 48 01             	lea    0x1(%eax),%ecx
  801467:	8b 55 14             	mov    0x14(%ebp),%edx
  80146a:	89 0a                	mov    %ecx,(%edx)
  80146c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801473:	8b 45 10             	mov    0x10(%ebp),%eax
  801476:	01 c2                	add    %eax,%edx
  801478:	8b 45 08             	mov    0x8(%ebp),%eax
  80147b:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80147d:	eb 03                	jmp    801482 <strsplit+0x8f>
			string++;
  80147f:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801482:	8b 45 08             	mov    0x8(%ebp),%eax
  801485:	8a 00                	mov    (%eax),%al
  801487:	84 c0                	test   %al,%al
  801489:	74 8b                	je     801416 <strsplit+0x23>
  80148b:	8b 45 08             	mov    0x8(%ebp),%eax
  80148e:	8a 00                	mov    (%eax),%al
  801490:	0f be c0             	movsbl %al,%eax
  801493:	50                   	push   %eax
  801494:	ff 75 0c             	pushl  0xc(%ebp)
  801497:	e8 b5 fa ff ff       	call   800f51 <strchr>
  80149c:	83 c4 08             	add    $0x8,%esp
  80149f:	85 c0                	test   %eax,%eax
  8014a1:	74 dc                	je     80147f <strsplit+0x8c>
			string++;
	}
  8014a3:	e9 6e ff ff ff       	jmp    801416 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014a8:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ac:	8b 00                	mov    (%eax),%eax
  8014ae:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b8:	01 d0                	add    %edx,%eax
  8014ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014c0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014c5:	c9                   	leave  
  8014c6:	c3                   	ret    

008014c7 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8014c7:	55                   	push   %ebp
  8014c8:	89 e5                	mov    %esp,%ebp
  8014ca:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8014cd:	a1 04 50 80 00       	mov    0x805004,%eax
  8014d2:	85 c0                	test   %eax,%eax
  8014d4:	74 1f                	je     8014f5 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8014d6:	e8 1d 00 00 00       	call   8014f8 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8014db:	83 ec 0c             	sub    $0xc,%esp
  8014de:	68 10 3f 80 00       	push   $0x803f10
  8014e3:	e8 55 f2 ff ff       	call   80073d <cprintf>
  8014e8:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8014eb:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  8014f2:	00 00 00 
	}
}
  8014f5:	90                   	nop
  8014f6:	c9                   	leave  
  8014f7:	c3                   	ret    

008014f8 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8014f8:	55                   	push   %ebp
  8014f9:	89 e5                	mov    %esp,%ebp
  8014fb:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  8014fe:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801505:	00 00 00 
  801508:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  80150f:	00 00 00 
  801512:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801519:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  80151c:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801523:	00 00 00 
  801526:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  80152d:	00 00 00 
  801530:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801537:	00 00 00 
	uint32 arr_size = 0;
  80153a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  801541:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801548:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80154b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801550:	2d 00 10 00 00       	sub    $0x1000,%eax
  801555:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  80155a:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801561:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  801564:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80156b:	a1 20 51 80 00       	mov    0x805120,%eax
  801570:	c1 e0 04             	shl    $0x4,%eax
  801573:	89 c2                	mov    %eax,%edx
  801575:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801578:	01 d0                	add    %edx,%eax
  80157a:	48                   	dec    %eax
  80157b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80157e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801581:	ba 00 00 00 00       	mov    $0x0,%edx
  801586:	f7 75 ec             	divl   -0x14(%ebp)
  801589:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80158c:	29 d0                	sub    %edx,%eax
  80158e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  801591:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801598:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80159b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015a0:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015a5:	83 ec 04             	sub    $0x4,%esp
  8015a8:	6a 06                	push   $0x6
  8015aa:	ff 75 f4             	pushl  -0xc(%ebp)
  8015ad:	50                   	push   %eax
  8015ae:	e8 fc 04 00 00       	call   801aaf <sys_allocate_chunk>
  8015b3:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8015b6:	a1 20 51 80 00       	mov    0x805120,%eax
  8015bb:	83 ec 0c             	sub    $0xc,%esp
  8015be:	50                   	push   %eax
  8015bf:	e8 71 0b 00 00       	call   802135 <initialize_MemBlocksList>
  8015c4:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  8015c7:	a1 48 51 80 00       	mov    0x805148,%eax
  8015cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  8015cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015d2:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  8015d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015dc:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  8015e3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8015e7:	75 14                	jne    8015fd <initialize_dyn_block_system+0x105>
  8015e9:	83 ec 04             	sub    $0x4,%esp
  8015ec:	68 35 3f 80 00       	push   $0x803f35
  8015f1:	6a 33                	push   $0x33
  8015f3:	68 53 3f 80 00       	push   $0x803f53
  8015f8:	e8 f1 1f 00 00       	call   8035ee <_panic>
  8015fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801600:	8b 00                	mov    (%eax),%eax
  801602:	85 c0                	test   %eax,%eax
  801604:	74 10                	je     801616 <initialize_dyn_block_system+0x11e>
  801606:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801609:	8b 00                	mov    (%eax),%eax
  80160b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80160e:	8b 52 04             	mov    0x4(%edx),%edx
  801611:	89 50 04             	mov    %edx,0x4(%eax)
  801614:	eb 0b                	jmp    801621 <initialize_dyn_block_system+0x129>
  801616:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801619:	8b 40 04             	mov    0x4(%eax),%eax
  80161c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801621:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801624:	8b 40 04             	mov    0x4(%eax),%eax
  801627:	85 c0                	test   %eax,%eax
  801629:	74 0f                	je     80163a <initialize_dyn_block_system+0x142>
  80162b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80162e:	8b 40 04             	mov    0x4(%eax),%eax
  801631:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801634:	8b 12                	mov    (%edx),%edx
  801636:	89 10                	mov    %edx,(%eax)
  801638:	eb 0a                	jmp    801644 <initialize_dyn_block_system+0x14c>
  80163a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80163d:	8b 00                	mov    (%eax),%eax
  80163f:	a3 48 51 80 00       	mov    %eax,0x805148
  801644:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801647:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80164d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801650:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801657:	a1 54 51 80 00       	mov    0x805154,%eax
  80165c:	48                   	dec    %eax
  80165d:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  801662:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801666:	75 14                	jne    80167c <initialize_dyn_block_system+0x184>
  801668:	83 ec 04             	sub    $0x4,%esp
  80166b:	68 60 3f 80 00       	push   $0x803f60
  801670:	6a 34                	push   $0x34
  801672:	68 53 3f 80 00       	push   $0x803f53
  801677:	e8 72 1f 00 00       	call   8035ee <_panic>
  80167c:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801682:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801685:	89 10                	mov    %edx,(%eax)
  801687:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80168a:	8b 00                	mov    (%eax),%eax
  80168c:	85 c0                	test   %eax,%eax
  80168e:	74 0d                	je     80169d <initialize_dyn_block_system+0x1a5>
  801690:	a1 38 51 80 00       	mov    0x805138,%eax
  801695:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801698:	89 50 04             	mov    %edx,0x4(%eax)
  80169b:	eb 08                	jmp    8016a5 <initialize_dyn_block_system+0x1ad>
  80169d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016a0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8016a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016a8:	a3 38 51 80 00       	mov    %eax,0x805138
  8016ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016b0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8016b7:	a1 44 51 80 00       	mov    0x805144,%eax
  8016bc:	40                   	inc    %eax
  8016bd:	a3 44 51 80 00       	mov    %eax,0x805144
}
  8016c2:	90                   	nop
  8016c3:	c9                   	leave  
  8016c4:	c3                   	ret    

008016c5 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8016c5:	55                   	push   %ebp
  8016c6:	89 e5                	mov    %esp,%ebp
  8016c8:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016cb:	e8 f7 fd ff ff       	call   8014c7 <InitializeUHeap>
	if (size == 0) return NULL ;
  8016d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016d4:	75 07                	jne    8016dd <malloc+0x18>
  8016d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8016db:	eb 61                	jmp    80173e <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  8016dd:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8016e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8016e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ea:	01 d0                	add    %edx,%eax
  8016ec:	48                   	dec    %eax
  8016ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8016f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8016f8:	f7 75 f0             	divl   -0x10(%ebp)
  8016fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016fe:	29 d0                	sub    %edx,%eax
  801700:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801703:	e8 75 07 00 00       	call   801e7d <sys_isUHeapPlacementStrategyFIRSTFIT>
  801708:	85 c0                	test   %eax,%eax
  80170a:	74 11                	je     80171d <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  80170c:	83 ec 0c             	sub    $0xc,%esp
  80170f:	ff 75 e8             	pushl  -0x18(%ebp)
  801712:	e8 e0 0d 00 00       	call   8024f7 <alloc_block_FF>
  801717:	83 c4 10             	add    $0x10,%esp
  80171a:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  80171d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801721:	74 16                	je     801739 <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  801723:	83 ec 0c             	sub    $0xc,%esp
  801726:	ff 75 f4             	pushl  -0xc(%ebp)
  801729:	e8 3c 0b 00 00       	call   80226a <insert_sorted_allocList>
  80172e:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  801731:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801734:	8b 40 08             	mov    0x8(%eax),%eax
  801737:	eb 05                	jmp    80173e <malloc+0x79>
	}

    return NULL;
  801739:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80173e:	c9                   	leave  
  80173f:	c3                   	ret    

00801740 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801740:	55                   	push   %ebp
  801741:	89 e5                	mov    %esp,%ebp
  801743:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801746:	83 ec 04             	sub    $0x4,%esp
  801749:	68 84 3f 80 00       	push   $0x803f84
  80174e:	6a 6f                	push   $0x6f
  801750:	68 53 3f 80 00       	push   $0x803f53
  801755:	e8 94 1e 00 00       	call   8035ee <_panic>

0080175a <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80175a:	55                   	push   %ebp
  80175b:	89 e5                	mov    %esp,%ebp
  80175d:	83 ec 38             	sub    $0x38,%esp
  801760:	8b 45 10             	mov    0x10(%ebp),%eax
  801763:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801766:	e8 5c fd ff ff       	call   8014c7 <InitializeUHeap>
	if (size == 0) return NULL ;
  80176b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80176f:	75 0a                	jne    80177b <smalloc+0x21>
  801771:	b8 00 00 00 00       	mov    $0x0,%eax
  801776:	e9 8b 00 00 00       	jmp    801806 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80177b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801782:	8b 55 0c             	mov    0xc(%ebp),%edx
  801785:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801788:	01 d0                	add    %edx,%eax
  80178a:	48                   	dec    %eax
  80178b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80178e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801791:	ba 00 00 00 00       	mov    $0x0,%edx
  801796:	f7 75 f0             	divl   -0x10(%ebp)
  801799:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80179c:	29 d0                	sub    %edx,%eax
  80179e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8017a1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8017a8:	e8 d0 06 00 00       	call   801e7d <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017ad:	85 c0                	test   %eax,%eax
  8017af:	74 11                	je     8017c2 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  8017b1:	83 ec 0c             	sub    $0xc,%esp
  8017b4:	ff 75 e8             	pushl  -0x18(%ebp)
  8017b7:	e8 3b 0d 00 00       	call   8024f7 <alloc_block_FF>
  8017bc:	83 c4 10             	add    $0x10,%esp
  8017bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  8017c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017c6:	74 39                	je     801801 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8017c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017cb:	8b 40 08             	mov    0x8(%eax),%eax
  8017ce:	89 c2                	mov    %eax,%edx
  8017d0:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8017d4:	52                   	push   %edx
  8017d5:	50                   	push   %eax
  8017d6:	ff 75 0c             	pushl  0xc(%ebp)
  8017d9:	ff 75 08             	pushl  0x8(%ebp)
  8017dc:	e8 21 04 00 00       	call   801c02 <sys_createSharedObject>
  8017e1:	83 c4 10             	add    $0x10,%esp
  8017e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  8017e7:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8017eb:	74 14                	je     801801 <smalloc+0xa7>
  8017ed:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8017f1:	74 0e                	je     801801 <smalloc+0xa7>
  8017f3:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  8017f7:	74 08                	je     801801 <smalloc+0xa7>
			return (void*) mem_block->sva;
  8017f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017fc:	8b 40 08             	mov    0x8(%eax),%eax
  8017ff:	eb 05                	jmp    801806 <smalloc+0xac>
	}
	return NULL;
  801801:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801806:	c9                   	leave  
  801807:	c3                   	ret    

00801808 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801808:	55                   	push   %ebp
  801809:	89 e5                	mov    %esp,%ebp
  80180b:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80180e:	e8 b4 fc ff ff       	call   8014c7 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801813:	83 ec 08             	sub    $0x8,%esp
  801816:	ff 75 0c             	pushl  0xc(%ebp)
  801819:	ff 75 08             	pushl  0x8(%ebp)
  80181c:	e8 0b 04 00 00       	call   801c2c <sys_getSizeOfSharedObject>
  801821:	83 c4 10             	add    $0x10,%esp
  801824:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  801827:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  80182b:	74 76                	je     8018a3 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80182d:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801834:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801837:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80183a:	01 d0                	add    %edx,%eax
  80183c:	48                   	dec    %eax
  80183d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801840:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801843:	ba 00 00 00 00       	mov    $0x0,%edx
  801848:	f7 75 ec             	divl   -0x14(%ebp)
  80184b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80184e:	29 d0                	sub    %edx,%eax
  801850:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801853:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80185a:	e8 1e 06 00 00       	call   801e7d <sys_isUHeapPlacementStrategyFIRSTFIT>
  80185f:	85 c0                	test   %eax,%eax
  801861:	74 11                	je     801874 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801863:	83 ec 0c             	sub    $0xc,%esp
  801866:	ff 75 e4             	pushl  -0x1c(%ebp)
  801869:	e8 89 0c 00 00       	call   8024f7 <alloc_block_FF>
  80186e:	83 c4 10             	add    $0x10,%esp
  801871:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  801874:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801878:	74 29                	je     8018a3 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  80187a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80187d:	8b 40 08             	mov    0x8(%eax),%eax
  801880:	83 ec 04             	sub    $0x4,%esp
  801883:	50                   	push   %eax
  801884:	ff 75 0c             	pushl  0xc(%ebp)
  801887:	ff 75 08             	pushl  0x8(%ebp)
  80188a:	e8 ba 03 00 00       	call   801c49 <sys_getSharedObject>
  80188f:	83 c4 10             	add    $0x10,%esp
  801892:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  801895:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  801899:	74 08                	je     8018a3 <sget+0x9b>
				return (void *)mem_block->sva;
  80189b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80189e:	8b 40 08             	mov    0x8(%eax),%eax
  8018a1:	eb 05                	jmp    8018a8 <sget+0xa0>
		}
	}
	return NULL;
  8018a3:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8018a8:	c9                   	leave  
  8018a9:	c3                   	ret    

008018aa <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8018aa:	55                   	push   %ebp
  8018ab:	89 e5                	mov    %esp,%ebp
  8018ad:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018b0:	e8 12 fc ff ff       	call   8014c7 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8018b5:	83 ec 04             	sub    $0x4,%esp
  8018b8:	68 a8 3f 80 00       	push   $0x803fa8
  8018bd:	68 f1 00 00 00       	push   $0xf1
  8018c2:	68 53 3f 80 00       	push   $0x803f53
  8018c7:	e8 22 1d 00 00       	call   8035ee <_panic>

008018cc <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8018cc:	55                   	push   %ebp
  8018cd:	89 e5                	mov    %esp,%ebp
  8018cf:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8018d2:	83 ec 04             	sub    $0x4,%esp
  8018d5:	68 d0 3f 80 00       	push   $0x803fd0
  8018da:	68 05 01 00 00       	push   $0x105
  8018df:	68 53 3f 80 00       	push   $0x803f53
  8018e4:	e8 05 1d 00 00       	call   8035ee <_panic>

008018e9 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8018e9:	55                   	push   %ebp
  8018ea:	89 e5                	mov    %esp,%ebp
  8018ec:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018ef:	83 ec 04             	sub    $0x4,%esp
  8018f2:	68 f4 3f 80 00       	push   $0x803ff4
  8018f7:	68 10 01 00 00       	push   $0x110
  8018fc:	68 53 3f 80 00       	push   $0x803f53
  801901:	e8 e8 1c 00 00       	call   8035ee <_panic>

00801906 <shrink>:

}
void shrink(uint32 newSize)
{
  801906:	55                   	push   %ebp
  801907:	89 e5                	mov    %esp,%ebp
  801909:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80190c:	83 ec 04             	sub    $0x4,%esp
  80190f:	68 f4 3f 80 00       	push   $0x803ff4
  801914:	68 15 01 00 00       	push   $0x115
  801919:	68 53 3f 80 00       	push   $0x803f53
  80191e:	e8 cb 1c 00 00       	call   8035ee <_panic>

00801923 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801923:	55                   	push   %ebp
  801924:	89 e5                	mov    %esp,%ebp
  801926:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801929:	83 ec 04             	sub    $0x4,%esp
  80192c:	68 f4 3f 80 00       	push   $0x803ff4
  801931:	68 1a 01 00 00       	push   $0x11a
  801936:	68 53 3f 80 00       	push   $0x803f53
  80193b:	e8 ae 1c 00 00       	call   8035ee <_panic>

00801940 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
  801943:	57                   	push   %edi
  801944:	56                   	push   %esi
  801945:	53                   	push   %ebx
  801946:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801949:	8b 45 08             	mov    0x8(%ebp),%eax
  80194c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80194f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801952:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801955:	8b 7d 18             	mov    0x18(%ebp),%edi
  801958:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80195b:	cd 30                	int    $0x30
  80195d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801960:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801963:	83 c4 10             	add    $0x10,%esp
  801966:	5b                   	pop    %ebx
  801967:	5e                   	pop    %esi
  801968:	5f                   	pop    %edi
  801969:	5d                   	pop    %ebp
  80196a:	c3                   	ret    

0080196b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80196b:	55                   	push   %ebp
  80196c:	89 e5                	mov    %esp,%ebp
  80196e:	83 ec 04             	sub    $0x4,%esp
  801971:	8b 45 10             	mov    0x10(%ebp),%eax
  801974:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801977:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80197b:	8b 45 08             	mov    0x8(%ebp),%eax
  80197e:	6a 00                	push   $0x0
  801980:	6a 00                	push   $0x0
  801982:	52                   	push   %edx
  801983:	ff 75 0c             	pushl  0xc(%ebp)
  801986:	50                   	push   %eax
  801987:	6a 00                	push   $0x0
  801989:	e8 b2 ff ff ff       	call   801940 <syscall>
  80198e:	83 c4 18             	add    $0x18,%esp
}
  801991:	90                   	nop
  801992:	c9                   	leave  
  801993:	c3                   	ret    

00801994 <sys_cgetc>:

int
sys_cgetc(void)
{
  801994:	55                   	push   %ebp
  801995:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 01                	push   $0x1
  8019a3:	e8 98 ff ff ff       	call   801940 <syscall>
  8019a8:	83 c4 18             	add    $0x18,%esp
}
  8019ab:	c9                   	leave  
  8019ac:	c3                   	ret    

008019ad <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8019ad:	55                   	push   %ebp
  8019ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8019b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	52                   	push   %edx
  8019bd:	50                   	push   %eax
  8019be:	6a 05                	push   $0x5
  8019c0:	e8 7b ff ff ff       	call   801940 <syscall>
  8019c5:	83 c4 18             	add    $0x18,%esp
}
  8019c8:	c9                   	leave  
  8019c9:	c3                   	ret    

008019ca <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8019ca:	55                   	push   %ebp
  8019cb:	89 e5                	mov    %esp,%ebp
  8019cd:	56                   	push   %esi
  8019ce:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8019cf:	8b 75 18             	mov    0x18(%ebp),%esi
  8019d2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019d5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019db:	8b 45 08             	mov    0x8(%ebp),%eax
  8019de:	56                   	push   %esi
  8019df:	53                   	push   %ebx
  8019e0:	51                   	push   %ecx
  8019e1:	52                   	push   %edx
  8019e2:	50                   	push   %eax
  8019e3:	6a 06                	push   $0x6
  8019e5:	e8 56 ff ff ff       	call   801940 <syscall>
  8019ea:	83 c4 18             	add    $0x18,%esp
}
  8019ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019f0:	5b                   	pop    %ebx
  8019f1:	5e                   	pop    %esi
  8019f2:	5d                   	pop    %ebp
  8019f3:	c3                   	ret    

008019f4 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8019f4:	55                   	push   %ebp
  8019f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8019f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	52                   	push   %edx
  801a04:	50                   	push   %eax
  801a05:	6a 07                	push   $0x7
  801a07:	e8 34 ff ff ff       	call   801940 <syscall>
  801a0c:	83 c4 18             	add    $0x18,%esp
}
  801a0f:	c9                   	leave  
  801a10:	c3                   	ret    

00801a11 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a11:	55                   	push   %ebp
  801a12:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	ff 75 0c             	pushl  0xc(%ebp)
  801a1d:	ff 75 08             	pushl  0x8(%ebp)
  801a20:	6a 08                	push   $0x8
  801a22:	e8 19 ff ff ff       	call   801940 <syscall>
  801a27:	83 c4 18             	add    $0x18,%esp
}
  801a2a:	c9                   	leave  
  801a2b:	c3                   	ret    

00801a2c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 09                	push   $0x9
  801a3b:	e8 00 ff ff ff       	call   801940 <syscall>
  801a40:	83 c4 18             	add    $0x18,%esp
}
  801a43:	c9                   	leave  
  801a44:	c3                   	ret    

00801a45 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a45:	55                   	push   %ebp
  801a46:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	6a 0a                	push   $0xa
  801a54:	e8 e7 fe ff ff       	call   801940 <syscall>
  801a59:	83 c4 18             	add    $0x18,%esp
}
  801a5c:	c9                   	leave  
  801a5d:	c3                   	ret    

00801a5e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a5e:	55                   	push   %ebp
  801a5f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 0b                	push   $0xb
  801a6d:	e8 ce fe ff ff       	call   801940 <syscall>
  801a72:	83 c4 18             	add    $0x18,%esp
}
  801a75:	c9                   	leave  
  801a76:	c3                   	ret    

00801a77 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a77:	55                   	push   %ebp
  801a78:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	ff 75 0c             	pushl  0xc(%ebp)
  801a83:	ff 75 08             	pushl  0x8(%ebp)
  801a86:	6a 0f                	push   $0xf
  801a88:	e8 b3 fe ff ff       	call   801940 <syscall>
  801a8d:	83 c4 18             	add    $0x18,%esp
	return;
  801a90:	90                   	nop
}
  801a91:	c9                   	leave  
  801a92:	c3                   	ret    

00801a93 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a93:	55                   	push   %ebp
  801a94:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	ff 75 0c             	pushl  0xc(%ebp)
  801a9f:	ff 75 08             	pushl  0x8(%ebp)
  801aa2:	6a 10                	push   $0x10
  801aa4:	e8 97 fe ff ff       	call   801940 <syscall>
  801aa9:	83 c4 18             	add    $0x18,%esp
	return ;
  801aac:	90                   	nop
}
  801aad:	c9                   	leave  
  801aae:	c3                   	ret    

00801aaf <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801aaf:	55                   	push   %ebp
  801ab0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	ff 75 10             	pushl  0x10(%ebp)
  801ab9:	ff 75 0c             	pushl  0xc(%ebp)
  801abc:	ff 75 08             	pushl  0x8(%ebp)
  801abf:	6a 11                	push   $0x11
  801ac1:	e8 7a fe ff ff       	call   801940 <syscall>
  801ac6:	83 c4 18             	add    $0x18,%esp
	return ;
  801ac9:	90                   	nop
}
  801aca:	c9                   	leave  
  801acb:	c3                   	ret    

00801acc <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801acc:	55                   	push   %ebp
  801acd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 0c                	push   $0xc
  801adb:	e8 60 fe ff ff       	call   801940 <syscall>
  801ae0:	83 c4 18             	add    $0x18,%esp
}
  801ae3:	c9                   	leave  
  801ae4:	c3                   	ret    

00801ae5 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ae5:	55                   	push   %ebp
  801ae6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	ff 75 08             	pushl  0x8(%ebp)
  801af3:	6a 0d                	push   $0xd
  801af5:	e8 46 fe ff ff       	call   801940 <syscall>
  801afa:	83 c4 18             	add    $0x18,%esp
}
  801afd:	c9                   	leave  
  801afe:	c3                   	ret    

00801aff <sys_scarce_memory>:

void sys_scarce_memory()
{
  801aff:	55                   	push   %ebp
  801b00:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 0e                	push   $0xe
  801b0e:	e8 2d fe ff ff       	call   801940 <syscall>
  801b13:	83 c4 18             	add    $0x18,%esp
}
  801b16:	90                   	nop
  801b17:	c9                   	leave  
  801b18:	c3                   	ret    

00801b19 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801b19:	55                   	push   %ebp
  801b1a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	6a 13                	push   $0x13
  801b28:	e8 13 fe ff ff       	call   801940 <syscall>
  801b2d:	83 c4 18             	add    $0x18,%esp
}
  801b30:	90                   	nop
  801b31:	c9                   	leave  
  801b32:	c3                   	ret    

00801b33 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801b33:	55                   	push   %ebp
  801b34:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 14                	push   $0x14
  801b42:	e8 f9 fd ff ff       	call   801940 <syscall>
  801b47:	83 c4 18             	add    $0x18,%esp
}
  801b4a:	90                   	nop
  801b4b:	c9                   	leave  
  801b4c:	c3                   	ret    

00801b4d <sys_cputc>:


void
sys_cputc(const char c)
{
  801b4d:	55                   	push   %ebp
  801b4e:	89 e5                	mov    %esp,%ebp
  801b50:	83 ec 04             	sub    $0x4,%esp
  801b53:	8b 45 08             	mov    0x8(%ebp),%eax
  801b56:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b59:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	50                   	push   %eax
  801b66:	6a 15                	push   $0x15
  801b68:	e8 d3 fd ff ff       	call   801940 <syscall>
  801b6d:	83 c4 18             	add    $0x18,%esp
}
  801b70:	90                   	nop
  801b71:	c9                   	leave  
  801b72:	c3                   	ret    

00801b73 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b73:	55                   	push   %ebp
  801b74:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 16                	push   $0x16
  801b82:	e8 b9 fd ff ff       	call   801940 <syscall>
  801b87:	83 c4 18             	add    $0x18,%esp
}
  801b8a:	90                   	nop
  801b8b:	c9                   	leave  
  801b8c:	c3                   	ret    

00801b8d <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b8d:	55                   	push   %ebp
  801b8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b90:	8b 45 08             	mov    0x8(%ebp),%eax
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	ff 75 0c             	pushl  0xc(%ebp)
  801b9c:	50                   	push   %eax
  801b9d:	6a 17                	push   $0x17
  801b9f:	e8 9c fd ff ff       	call   801940 <syscall>
  801ba4:	83 c4 18             	add    $0x18,%esp
}
  801ba7:	c9                   	leave  
  801ba8:	c3                   	ret    

00801ba9 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801ba9:	55                   	push   %ebp
  801baa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bac:	8b 55 0c             	mov    0xc(%ebp),%edx
  801baf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	52                   	push   %edx
  801bb9:	50                   	push   %eax
  801bba:	6a 1a                	push   $0x1a
  801bbc:	e8 7f fd ff ff       	call   801940 <syscall>
  801bc1:	83 c4 18             	add    $0x18,%esp
}
  801bc4:	c9                   	leave  
  801bc5:	c3                   	ret    

00801bc6 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801bc6:	55                   	push   %ebp
  801bc7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bc9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	52                   	push   %edx
  801bd6:	50                   	push   %eax
  801bd7:	6a 18                	push   $0x18
  801bd9:	e8 62 fd ff ff       	call   801940 <syscall>
  801bde:	83 c4 18             	add    $0x18,%esp
}
  801be1:	90                   	nop
  801be2:	c9                   	leave  
  801be3:	c3                   	ret    

00801be4 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801be4:	55                   	push   %ebp
  801be5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801be7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bea:	8b 45 08             	mov    0x8(%ebp),%eax
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	52                   	push   %edx
  801bf4:	50                   	push   %eax
  801bf5:	6a 19                	push   $0x19
  801bf7:	e8 44 fd ff ff       	call   801940 <syscall>
  801bfc:	83 c4 18             	add    $0x18,%esp
}
  801bff:	90                   	nop
  801c00:	c9                   	leave  
  801c01:	c3                   	ret    

00801c02 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c02:	55                   	push   %ebp
  801c03:	89 e5                	mov    %esp,%ebp
  801c05:	83 ec 04             	sub    $0x4,%esp
  801c08:	8b 45 10             	mov    0x10(%ebp),%eax
  801c0b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c0e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c11:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c15:	8b 45 08             	mov    0x8(%ebp),%eax
  801c18:	6a 00                	push   $0x0
  801c1a:	51                   	push   %ecx
  801c1b:	52                   	push   %edx
  801c1c:	ff 75 0c             	pushl  0xc(%ebp)
  801c1f:	50                   	push   %eax
  801c20:	6a 1b                	push   $0x1b
  801c22:	e8 19 fd ff ff       	call   801940 <syscall>
  801c27:	83 c4 18             	add    $0x18,%esp
}
  801c2a:	c9                   	leave  
  801c2b:	c3                   	ret    

00801c2c <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c2c:	55                   	push   %ebp
  801c2d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c32:	8b 45 08             	mov    0x8(%ebp),%eax
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	52                   	push   %edx
  801c3c:	50                   	push   %eax
  801c3d:	6a 1c                	push   $0x1c
  801c3f:	e8 fc fc ff ff       	call   801940 <syscall>
  801c44:	83 c4 18             	add    $0x18,%esp
}
  801c47:	c9                   	leave  
  801c48:	c3                   	ret    

00801c49 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c49:	55                   	push   %ebp
  801c4a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c4c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c52:	8b 45 08             	mov    0x8(%ebp),%eax
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	51                   	push   %ecx
  801c5a:	52                   	push   %edx
  801c5b:	50                   	push   %eax
  801c5c:	6a 1d                	push   $0x1d
  801c5e:	e8 dd fc ff ff       	call   801940 <syscall>
  801c63:	83 c4 18             	add    $0x18,%esp
}
  801c66:	c9                   	leave  
  801c67:	c3                   	ret    

00801c68 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c68:	55                   	push   %ebp
  801c69:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	52                   	push   %edx
  801c78:	50                   	push   %eax
  801c79:	6a 1e                	push   $0x1e
  801c7b:	e8 c0 fc ff ff       	call   801940 <syscall>
  801c80:	83 c4 18             	add    $0x18,%esp
}
  801c83:	c9                   	leave  
  801c84:	c3                   	ret    

00801c85 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c85:	55                   	push   %ebp
  801c86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 1f                	push   $0x1f
  801c94:	e8 a7 fc ff ff       	call   801940 <syscall>
  801c99:	83 c4 18             	add    $0x18,%esp
}
  801c9c:	c9                   	leave  
  801c9d:	c3                   	ret    

00801c9e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca4:	6a 00                	push   $0x0
  801ca6:	ff 75 14             	pushl  0x14(%ebp)
  801ca9:	ff 75 10             	pushl  0x10(%ebp)
  801cac:	ff 75 0c             	pushl  0xc(%ebp)
  801caf:	50                   	push   %eax
  801cb0:	6a 20                	push   $0x20
  801cb2:	e8 89 fc ff ff       	call   801940 <syscall>
  801cb7:	83 c4 18             	add    $0x18,%esp
}
  801cba:	c9                   	leave  
  801cbb:	c3                   	ret    

00801cbc <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801cbc:	55                   	push   %ebp
  801cbd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	50                   	push   %eax
  801ccb:	6a 21                	push   $0x21
  801ccd:	e8 6e fc ff ff       	call   801940 <syscall>
  801cd2:	83 c4 18             	add    $0x18,%esp
}
  801cd5:	90                   	nop
  801cd6:	c9                   	leave  
  801cd7:	c3                   	ret    

00801cd8 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801cd8:	55                   	push   %ebp
  801cd9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 00                	push   $0x0
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 00                	push   $0x0
  801ce6:	50                   	push   %eax
  801ce7:	6a 22                	push   $0x22
  801ce9:	e8 52 fc ff ff       	call   801940 <syscall>
  801cee:	83 c4 18             	add    $0x18,%esp
}
  801cf1:	c9                   	leave  
  801cf2:	c3                   	ret    

00801cf3 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801cf3:	55                   	push   %ebp
  801cf4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 02                	push   $0x2
  801d02:	e8 39 fc ff ff       	call   801940 <syscall>
  801d07:	83 c4 18             	add    $0x18,%esp
}
  801d0a:	c9                   	leave  
  801d0b:	c3                   	ret    

00801d0c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d0c:	55                   	push   %ebp
  801d0d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	6a 03                	push   $0x3
  801d1b:	e8 20 fc ff ff       	call   801940 <syscall>
  801d20:	83 c4 18             	add    $0x18,%esp
}
  801d23:	c9                   	leave  
  801d24:	c3                   	ret    

00801d25 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d25:	55                   	push   %ebp
  801d26:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	6a 04                	push   $0x4
  801d34:	e8 07 fc ff ff       	call   801940 <syscall>
  801d39:	83 c4 18             	add    $0x18,%esp
}
  801d3c:	c9                   	leave  
  801d3d:	c3                   	ret    

00801d3e <sys_exit_env>:


void sys_exit_env(void)
{
  801d3e:	55                   	push   %ebp
  801d3f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 23                	push   $0x23
  801d4d:	e8 ee fb ff ff       	call   801940 <syscall>
  801d52:	83 c4 18             	add    $0x18,%esp
}
  801d55:	90                   	nop
  801d56:	c9                   	leave  
  801d57:	c3                   	ret    

00801d58 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801d58:	55                   	push   %ebp
  801d59:	89 e5                	mov    %esp,%ebp
  801d5b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d5e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d61:	8d 50 04             	lea    0x4(%eax),%edx
  801d64:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	52                   	push   %edx
  801d6e:	50                   	push   %eax
  801d6f:	6a 24                	push   $0x24
  801d71:	e8 ca fb ff ff       	call   801940 <syscall>
  801d76:	83 c4 18             	add    $0x18,%esp
	return result;
  801d79:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d7c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d7f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d82:	89 01                	mov    %eax,(%ecx)
  801d84:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d87:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8a:	c9                   	leave  
  801d8b:	c2 04 00             	ret    $0x4

00801d8e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d8e:	55                   	push   %ebp
  801d8f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d91:	6a 00                	push   $0x0
  801d93:	6a 00                	push   $0x0
  801d95:	ff 75 10             	pushl  0x10(%ebp)
  801d98:	ff 75 0c             	pushl  0xc(%ebp)
  801d9b:	ff 75 08             	pushl  0x8(%ebp)
  801d9e:	6a 12                	push   $0x12
  801da0:	e8 9b fb ff ff       	call   801940 <syscall>
  801da5:	83 c4 18             	add    $0x18,%esp
	return ;
  801da8:	90                   	nop
}
  801da9:	c9                   	leave  
  801daa:	c3                   	ret    

00801dab <sys_rcr2>:
uint32 sys_rcr2()
{
  801dab:	55                   	push   %ebp
  801dac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 00                	push   $0x0
  801db4:	6a 00                	push   $0x0
  801db6:	6a 00                	push   $0x0
  801db8:	6a 25                	push   $0x25
  801dba:	e8 81 fb ff ff       	call   801940 <syscall>
  801dbf:	83 c4 18             	add    $0x18,%esp
}
  801dc2:	c9                   	leave  
  801dc3:	c3                   	ret    

00801dc4 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801dc4:	55                   	push   %ebp
  801dc5:	89 e5                	mov    %esp,%ebp
  801dc7:	83 ec 04             	sub    $0x4,%esp
  801dca:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801dd0:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	50                   	push   %eax
  801ddd:	6a 26                	push   $0x26
  801ddf:	e8 5c fb ff ff       	call   801940 <syscall>
  801de4:	83 c4 18             	add    $0x18,%esp
	return ;
  801de7:	90                   	nop
}
  801de8:	c9                   	leave  
  801de9:	c3                   	ret    

00801dea <rsttst>:
void rsttst()
{
  801dea:	55                   	push   %ebp
  801deb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ded:	6a 00                	push   $0x0
  801def:	6a 00                	push   $0x0
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	6a 28                	push   $0x28
  801df9:	e8 42 fb ff ff       	call   801940 <syscall>
  801dfe:	83 c4 18             	add    $0x18,%esp
	return ;
  801e01:	90                   	nop
}
  801e02:	c9                   	leave  
  801e03:	c3                   	ret    

00801e04 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e04:	55                   	push   %ebp
  801e05:	89 e5                	mov    %esp,%ebp
  801e07:	83 ec 04             	sub    $0x4,%esp
  801e0a:	8b 45 14             	mov    0x14(%ebp),%eax
  801e0d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e10:	8b 55 18             	mov    0x18(%ebp),%edx
  801e13:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e17:	52                   	push   %edx
  801e18:	50                   	push   %eax
  801e19:	ff 75 10             	pushl  0x10(%ebp)
  801e1c:	ff 75 0c             	pushl  0xc(%ebp)
  801e1f:	ff 75 08             	pushl  0x8(%ebp)
  801e22:	6a 27                	push   $0x27
  801e24:	e8 17 fb ff ff       	call   801940 <syscall>
  801e29:	83 c4 18             	add    $0x18,%esp
	return ;
  801e2c:	90                   	nop
}
  801e2d:	c9                   	leave  
  801e2e:	c3                   	ret    

00801e2f <chktst>:
void chktst(uint32 n)
{
  801e2f:	55                   	push   %ebp
  801e30:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e32:	6a 00                	push   $0x0
  801e34:	6a 00                	push   $0x0
  801e36:	6a 00                	push   $0x0
  801e38:	6a 00                	push   $0x0
  801e3a:	ff 75 08             	pushl  0x8(%ebp)
  801e3d:	6a 29                	push   $0x29
  801e3f:	e8 fc fa ff ff       	call   801940 <syscall>
  801e44:	83 c4 18             	add    $0x18,%esp
	return ;
  801e47:	90                   	nop
}
  801e48:	c9                   	leave  
  801e49:	c3                   	ret    

00801e4a <inctst>:

void inctst()
{
  801e4a:	55                   	push   %ebp
  801e4b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e4d:	6a 00                	push   $0x0
  801e4f:	6a 00                	push   $0x0
  801e51:	6a 00                	push   $0x0
  801e53:	6a 00                	push   $0x0
  801e55:	6a 00                	push   $0x0
  801e57:	6a 2a                	push   $0x2a
  801e59:	e8 e2 fa ff ff       	call   801940 <syscall>
  801e5e:	83 c4 18             	add    $0x18,%esp
	return ;
  801e61:	90                   	nop
}
  801e62:	c9                   	leave  
  801e63:	c3                   	ret    

00801e64 <gettst>:
uint32 gettst()
{
  801e64:	55                   	push   %ebp
  801e65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e67:	6a 00                	push   $0x0
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 2b                	push   $0x2b
  801e73:	e8 c8 fa ff ff       	call   801940 <syscall>
  801e78:	83 c4 18             	add    $0x18,%esp
}
  801e7b:	c9                   	leave  
  801e7c:	c3                   	ret    

00801e7d <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e7d:	55                   	push   %ebp
  801e7e:	89 e5                	mov    %esp,%ebp
  801e80:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e83:	6a 00                	push   $0x0
  801e85:	6a 00                	push   $0x0
  801e87:	6a 00                	push   $0x0
  801e89:	6a 00                	push   $0x0
  801e8b:	6a 00                	push   $0x0
  801e8d:	6a 2c                	push   $0x2c
  801e8f:	e8 ac fa ff ff       	call   801940 <syscall>
  801e94:	83 c4 18             	add    $0x18,%esp
  801e97:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e9a:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e9e:	75 07                	jne    801ea7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ea0:	b8 01 00 00 00       	mov    $0x1,%eax
  801ea5:	eb 05                	jmp    801eac <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ea7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eac:	c9                   	leave  
  801ead:	c3                   	ret    

00801eae <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801eae:	55                   	push   %ebp
  801eaf:	89 e5                	mov    %esp,%ebp
  801eb1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 00                	push   $0x0
  801eba:	6a 00                	push   $0x0
  801ebc:	6a 00                	push   $0x0
  801ebe:	6a 2c                	push   $0x2c
  801ec0:	e8 7b fa ff ff       	call   801940 <syscall>
  801ec5:	83 c4 18             	add    $0x18,%esp
  801ec8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ecb:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ecf:	75 07                	jne    801ed8 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801ed1:	b8 01 00 00 00       	mov    $0x1,%eax
  801ed6:	eb 05                	jmp    801edd <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801ed8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801edd:	c9                   	leave  
  801ede:	c3                   	ret    

00801edf <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801edf:	55                   	push   %ebp
  801ee0:	89 e5                	mov    %esp,%ebp
  801ee2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 00                	push   $0x0
  801eeb:	6a 00                	push   $0x0
  801eed:	6a 00                	push   $0x0
  801eef:	6a 2c                	push   $0x2c
  801ef1:	e8 4a fa ff ff       	call   801940 <syscall>
  801ef6:	83 c4 18             	add    $0x18,%esp
  801ef9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801efc:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f00:	75 07                	jne    801f09 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f02:	b8 01 00 00 00       	mov    $0x1,%eax
  801f07:	eb 05                	jmp    801f0e <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f09:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f0e:	c9                   	leave  
  801f0f:	c3                   	ret    

00801f10 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801f10:	55                   	push   %ebp
  801f11:	89 e5                	mov    %esp,%ebp
  801f13:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f16:	6a 00                	push   $0x0
  801f18:	6a 00                	push   $0x0
  801f1a:	6a 00                	push   $0x0
  801f1c:	6a 00                	push   $0x0
  801f1e:	6a 00                	push   $0x0
  801f20:	6a 2c                	push   $0x2c
  801f22:	e8 19 fa ff ff       	call   801940 <syscall>
  801f27:	83 c4 18             	add    $0x18,%esp
  801f2a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f2d:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f31:	75 07                	jne    801f3a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f33:	b8 01 00 00 00       	mov    $0x1,%eax
  801f38:	eb 05                	jmp    801f3f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f3a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f3f:	c9                   	leave  
  801f40:	c3                   	ret    

00801f41 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f41:	55                   	push   %ebp
  801f42:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f44:	6a 00                	push   $0x0
  801f46:	6a 00                	push   $0x0
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 00                	push   $0x0
  801f4c:	ff 75 08             	pushl  0x8(%ebp)
  801f4f:	6a 2d                	push   $0x2d
  801f51:	e8 ea f9 ff ff       	call   801940 <syscall>
  801f56:	83 c4 18             	add    $0x18,%esp
	return ;
  801f59:	90                   	nop
}
  801f5a:	c9                   	leave  
  801f5b:	c3                   	ret    

00801f5c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f5c:	55                   	push   %ebp
  801f5d:	89 e5                	mov    %esp,%ebp
  801f5f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f60:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f63:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f66:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f69:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6c:	6a 00                	push   $0x0
  801f6e:	53                   	push   %ebx
  801f6f:	51                   	push   %ecx
  801f70:	52                   	push   %edx
  801f71:	50                   	push   %eax
  801f72:	6a 2e                	push   $0x2e
  801f74:	e8 c7 f9 ff ff       	call   801940 <syscall>
  801f79:	83 c4 18             	add    $0x18,%esp
}
  801f7c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f7f:	c9                   	leave  
  801f80:	c3                   	ret    

00801f81 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f81:	55                   	push   %ebp
  801f82:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f84:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f87:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8a:	6a 00                	push   $0x0
  801f8c:	6a 00                	push   $0x0
  801f8e:	6a 00                	push   $0x0
  801f90:	52                   	push   %edx
  801f91:	50                   	push   %eax
  801f92:	6a 2f                	push   $0x2f
  801f94:	e8 a7 f9 ff ff       	call   801940 <syscall>
  801f99:	83 c4 18             	add    $0x18,%esp
}
  801f9c:	c9                   	leave  
  801f9d:	c3                   	ret    

00801f9e <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f9e:	55                   	push   %ebp
  801f9f:	89 e5                	mov    %esp,%ebp
  801fa1:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801fa4:	83 ec 0c             	sub    $0xc,%esp
  801fa7:	68 04 40 80 00       	push   $0x804004
  801fac:	e8 8c e7 ff ff       	call   80073d <cprintf>
  801fb1:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801fb4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801fbb:	83 ec 0c             	sub    $0xc,%esp
  801fbe:	68 30 40 80 00       	push   $0x804030
  801fc3:	e8 75 e7 ff ff       	call   80073d <cprintf>
  801fc8:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801fcb:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801fcf:	a1 38 51 80 00       	mov    0x805138,%eax
  801fd4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fd7:	eb 56                	jmp    80202f <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801fd9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fdd:	74 1c                	je     801ffb <print_mem_block_lists+0x5d>
  801fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe2:	8b 50 08             	mov    0x8(%eax),%edx
  801fe5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fe8:	8b 48 08             	mov    0x8(%eax),%ecx
  801feb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fee:	8b 40 0c             	mov    0xc(%eax),%eax
  801ff1:	01 c8                	add    %ecx,%eax
  801ff3:	39 c2                	cmp    %eax,%edx
  801ff5:	73 04                	jae    801ffb <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801ff7:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ffb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffe:	8b 50 08             	mov    0x8(%eax),%edx
  802001:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802004:	8b 40 0c             	mov    0xc(%eax),%eax
  802007:	01 c2                	add    %eax,%edx
  802009:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200c:	8b 40 08             	mov    0x8(%eax),%eax
  80200f:	83 ec 04             	sub    $0x4,%esp
  802012:	52                   	push   %edx
  802013:	50                   	push   %eax
  802014:	68 45 40 80 00       	push   $0x804045
  802019:	e8 1f e7 ff ff       	call   80073d <cprintf>
  80201e:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802021:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802024:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802027:	a1 40 51 80 00       	mov    0x805140,%eax
  80202c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80202f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802033:	74 07                	je     80203c <print_mem_block_lists+0x9e>
  802035:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802038:	8b 00                	mov    (%eax),%eax
  80203a:	eb 05                	jmp    802041 <print_mem_block_lists+0xa3>
  80203c:	b8 00 00 00 00       	mov    $0x0,%eax
  802041:	a3 40 51 80 00       	mov    %eax,0x805140
  802046:	a1 40 51 80 00       	mov    0x805140,%eax
  80204b:	85 c0                	test   %eax,%eax
  80204d:	75 8a                	jne    801fd9 <print_mem_block_lists+0x3b>
  80204f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802053:	75 84                	jne    801fd9 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802055:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802059:	75 10                	jne    80206b <print_mem_block_lists+0xcd>
  80205b:	83 ec 0c             	sub    $0xc,%esp
  80205e:	68 54 40 80 00       	push   $0x804054
  802063:	e8 d5 e6 ff ff       	call   80073d <cprintf>
  802068:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80206b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802072:	83 ec 0c             	sub    $0xc,%esp
  802075:	68 78 40 80 00       	push   $0x804078
  80207a:	e8 be e6 ff ff       	call   80073d <cprintf>
  80207f:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802082:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802086:	a1 40 50 80 00       	mov    0x805040,%eax
  80208b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80208e:	eb 56                	jmp    8020e6 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802090:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802094:	74 1c                	je     8020b2 <print_mem_block_lists+0x114>
  802096:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802099:	8b 50 08             	mov    0x8(%eax),%edx
  80209c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80209f:	8b 48 08             	mov    0x8(%eax),%ecx
  8020a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8020a8:	01 c8                	add    %ecx,%eax
  8020aa:	39 c2                	cmp    %eax,%edx
  8020ac:	73 04                	jae    8020b2 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8020ae:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8020b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b5:	8b 50 08             	mov    0x8(%eax),%edx
  8020b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8020be:	01 c2                	add    %eax,%edx
  8020c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c3:	8b 40 08             	mov    0x8(%eax),%eax
  8020c6:	83 ec 04             	sub    $0x4,%esp
  8020c9:	52                   	push   %edx
  8020ca:	50                   	push   %eax
  8020cb:	68 45 40 80 00       	push   $0x804045
  8020d0:	e8 68 e6 ff ff       	call   80073d <cprintf>
  8020d5:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8020d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020db:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8020de:	a1 48 50 80 00       	mov    0x805048,%eax
  8020e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020ea:	74 07                	je     8020f3 <print_mem_block_lists+0x155>
  8020ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ef:	8b 00                	mov    (%eax),%eax
  8020f1:	eb 05                	jmp    8020f8 <print_mem_block_lists+0x15a>
  8020f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f8:	a3 48 50 80 00       	mov    %eax,0x805048
  8020fd:	a1 48 50 80 00       	mov    0x805048,%eax
  802102:	85 c0                	test   %eax,%eax
  802104:	75 8a                	jne    802090 <print_mem_block_lists+0xf2>
  802106:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80210a:	75 84                	jne    802090 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80210c:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802110:	75 10                	jne    802122 <print_mem_block_lists+0x184>
  802112:	83 ec 0c             	sub    $0xc,%esp
  802115:	68 90 40 80 00       	push   $0x804090
  80211a:	e8 1e e6 ff ff       	call   80073d <cprintf>
  80211f:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802122:	83 ec 0c             	sub    $0xc,%esp
  802125:	68 04 40 80 00       	push   $0x804004
  80212a:	e8 0e e6 ff ff       	call   80073d <cprintf>
  80212f:	83 c4 10             	add    $0x10,%esp

}
  802132:	90                   	nop
  802133:	c9                   	leave  
  802134:	c3                   	ret    

00802135 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802135:	55                   	push   %ebp
  802136:	89 e5                	mov    %esp,%ebp
  802138:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  80213b:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802142:	00 00 00 
  802145:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80214c:	00 00 00 
  80214f:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802156:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802159:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802160:	e9 9e 00 00 00       	jmp    802203 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802165:	a1 50 50 80 00       	mov    0x805050,%eax
  80216a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80216d:	c1 e2 04             	shl    $0x4,%edx
  802170:	01 d0                	add    %edx,%eax
  802172:	85 c0                	test   %eax,%eax
  802174:	75 14                	jne    80218a <initialize_MemBlocksList+0x55>
  802176:	83 ec 04             	sub    $0x4,%esp
  802179:	68 b8 40 80 00       	push   $0x8040b8
  80217e:	6a 46                	push   $0x46
  802180:	68 db 40 80 00       	push   $0x8040db
  802185:	e8 64 14 00 00       	call   8035ee <_panic>
  80218a:	a1 50 50 80 00       	mov    0x805050,%eax
  80218f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802192:	c1 e2 04             	shl    $0x4,%edx
  802195:	01 d0                	add    %edx,%eax
  802197:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80219d:	89 10                	mov    %edx,(%eax)
  80219f:	8b 00                	mov    (%eax),%eax
  8021a1:	85 c0                	test   %eax,%eax
  8021a3:	74 18                	je     8021bd <initialize_MemBlocksList+0x88>
  8021a5:	a1 48 51 80 00       	mov    0x805148,%eax
  8021aa:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8021b0:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8021b3:	c1 e1 04             	shl    $0x4,%ecx
  8021b6:	01 ca                	add    %ecx,%edx
  8021b8:	89 50 04             	mov    %edx,0x4(%eax)
  8021bb:	eb 12                	jmp    8021cf <initialize_MemBlocksList+0x9a>
  8021bd:	a1 50 50 80 00       	mov    0x805050,%eax
  8021c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021c5:	c1 e2 04             	shl    $0x4,%edx
  8021c8:	01 d0                	add    %edx,%eax
  8021ca:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8021cf:	a1 50 50 80 00       	mov    0x805050,%eax
  8021d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021d7:	c1 e2 04             	shl    $0x4,%edx
  8021da:	01 d0                	add    %edx,%eax
  8021dc:	a3 48 51 80 00       	mov    %eax,0x805148
  8021e1:	a1 50 50 80 00       	mov    0x805050,%eax
  8021e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021e9:	c1 e2 04             	shl    $0x4,%edx
  8021ec:	01 d0                	add    %edx,%eax
  8021ee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021f5:	a1 54 51 80 00       	mov    0x805154,%eax
  8021fa:	40                   	inc    %eax
  8021fb:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802200:	ff 45 f4             	incl   -0xc(%ebp)
  802203:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802206:	3b 45 08             	cmp    0x8(%ebp),%eax
  802209:	0f 82 56 ff ff ff    	jb     802165 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  80220f:	90                   	nop
  802210:	c9                   	leave  
  802211:	c3                   	ret    

00802212 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802212:	55                   	push   %ebp
  802213:	89 e5                	mov    %esp,%ebp
  802215:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802218:	8b 45 08             	mov    0x8(%ebp),%eax
  80221b:	8b 00                	mov    (%eax),%eax
  80221d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802220:	eb 19                	jmp    80223b <find_block+0x29>
	{
		if(va==point->sva)
  802222:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802225:	8b 40 08             	mov    0x8(%eax),%eax
  802228:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80222b:	75 05                	jne    802232 <find_block+0x20>
		   return point;
  80222d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802230:	eb 36                	jmp    802268 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802232:	8b 45 08             	mov    0x8(%ebp),%eax
  802235:	8b 40 08             	mov    0x8(%eax),%eax
  802238:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80223b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80223f:	74 07                	je     802248 <find_block+0x36>
  802241:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802244:	8b 00                	mov    (%eax),%eax
  802246:	eb 05                	jmp    80224d <find_block+0x3b>
  802248:	b8 00 00 00 00       	mov    $0x0,%eax
  80224d:	8b 55 08             	mov    0x8(%ebp),%edx
  802250:	89 42 08             	mov    %eax,0x8(%edx)
  802253:	8b 45 08             	mov    0x8(%ebp),%eax
  802256:	8b 40 08             	mov    0x8(%eax),%eax
  802259:	85 c0                	test   %eax,%eax
  80225b:	75 c5                	jne    802222 <find_block+0x10>
  80225d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802261:	75 bf                	jne    802222 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802263:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802268:	c9                   	leave  
  802269:	c3                   	ret    

0080226a <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80226a:	55                   	push   %ebp
  80226b:	89 e5                	mov    %esp,%ebp
  80226d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802270:	a1 40 50 80 00       	mov    0x805040,%eax
  802275:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802278:	a1 44 50 80 00       	mov    0x805044,%eax
  80227d:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802280:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802283:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802286:	74 24                	je     8022ac <insert_sorted_allocList+0x42>
  802288:	8b 45 08             	mov    0x8(%ebp),%eax
  80228b:	8b 50 08             	mov    0x8(%eax),%edx
  80228e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802291:	8b 40 08             	mov    0x8(%eax),%eax
  802294:	39 c2                	cmp    %eax,%edx
  802296:	76 14                	jbe    8022ac <insert_sorted_allocList+0x42>
  802298:	8b 45 08             	mov    0x8(%ebp),%eax
  80229b:	8b 50 08             	mov    0x8(%eax),%edx
  80229e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022a1:	8b 40 08             	mov    0x8(%eax),%eax
  8022a4:	39 c2                	cmp    %eax,%edx
  8022a6:	0f 82 60 01 00 00    	jb     80240c <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8022ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022b0:	75 65                	jne    802317 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8022b2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022b6:	75 14                	jne    8022cc <insert_sorted_allocList+0x62>
  8022b8:	83 ec 04             	sub    $0x4,%esp
  8022bb:	68 b8 40 80 00       	push   $0x8040b8
  8022c0:	6a 6b                	push   $0x6b
  8022c2:	68 db 40 80 00       	push   $0x8040db
  8022c7:	e8 22 13 00 00       	call   8035ee <_panic>
  8022cc:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8022d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d5:	89 10                	mov    %edx,(%eax)
  8022d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022da:	8b 00                	mov    (%eax),%eax
  8022dc:	85 c0                	test   %eax,%eax
  8022de:	74 0d                	je     8022ed <insert_sorted_allocList+0x83>
  8022e0:	a1 40 50 80 00       	mov    0x805040,%eax
  8022e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8022e8:	89 50 04             	mov    %edx,0x4(%eax)
  8022eb:	eb 08                	jmp    8022f5 <insert_sorted_allocList+0x8b>
  8022ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f0:	a3 44 50 80 00       	mov    %eax,0x805044
  8022f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f8:	a3 40 50 80 00       	mov    %eax,0x805040
  8022fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802300:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802307:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80230c:	40                   	inc    %eax
  80230d:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802312:	e9 dc 01 00 00       	jmp    8024f3 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802317:	8b 45 08             	mov    0x8(%ebp),%eax
  80231a:	8b 50 08             	mov    0x8(%eax),%edx
  80231d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802320:	8b 40 08             	mov    0x8(%eax),%eax
  802323:	39 c2                	cmp    %eax,%edx
  802325:	77 6c                	ja     802393 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802327:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80232b:	74 06                	je     802333 <insert_sorted_allocList+0xc9>
  80232d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802331:	75 14                	jne    802347 <insert_sorted_allocList+0xdd>
  802333:	83 ec 04             	sub    $0x4,%esp
  802336:	68 f4 40 80 00       	push   $0x8040f4
  80233b:	6a 6f                	push   $0x6f
  80233d:	68 db 40 80 00       	push   $0x8040db
  802342:	e8 a7 12 00 00       	call   8035ee <_panic>
  802347:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80234a:	8b 50 04             	mov    0x4(%eax),%edx
  80234d:	8b 45 08             	mov    0x8(%ebp),%eax
  802350:	89 50 04             	mov    %edx,0x4(%eax)
  802353:	8b 45 08             	mov    0x8(%ebp),%eax
  802356:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802359:	89 10                	mov    %edx,(%eax)
  80235b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80235e:	8b 40 04             	mov    0x4(%eax),%eax
  802361:	85 c0                	test   %eax,%eax
  802363:	74 0d                	je     802372 <insert_sorted_allocList+0x108>
  802365:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802368:	8b 40 04             	mov    0x4(%eax),%eax
  80236b:	8b 55 08             	mov    0x8(%ebp),%edx
  80236e:	89 10                	mov    %edx,(%eax)
  802370:	eb 08                	jmp    80237a <insert_sorted_allocList+0x110>
  802372:	8b 45 08             	mov    0x8(%ebp),%eax
  802375:	a3 40 50 80 00       	mov    %eax,0x805040
  80237a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80237d:	8b 55 08             	mov    0x8(%ebp),%edx
  802380:	89 50 04             	mov    %edx,0x4(%eax)
  802383:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802388:	40                   	inc    %eax
  802389:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80238e:	e9 60 01 00 00       	jmp    8024f3 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802393:	8b 45 08             	mov    0x8(%ebp),%eax
  802396:	8b 50 08             	mov    0x8(%eax),%edx
  802399:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80239c:	8b 40 08             	mov    0x8(%eax),%eax
  80239f:	39 c2                	cmp    %eax,%edx
  8023a1:	0f 82 4c 01 00 00    	jb     8024f3 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8023a7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023ab:	75 14                	jne    8023c1 <insert_sorted_allocList+0x157>
  8023ad:	83 ec 04             	sub    $0x4,%esp
  8023b0:	68 2c 41 80 00       	push   $0x80412c
  8023b5:	6a 73                	push   $0x73
  8023b7:	68 db 40 80 00       	push   $0x8040db
  8023bc:	e8 2d 12 00 00       	call   8035ee <_panic>
  8023c1:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8023c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ca:	89 50 04             	mov    %edx,0x4(%eax)
  8023cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d0:	8b 40 04             	mov    0x4(%eax),%eax
  8023d3:	85 c0                	test   %eax,%eax
  8023d5:	74 0c                	je     8023e3 <insert_sorted_allocList+0x179>
  8023d7:	a1 44 50 80 00       	mov    0x805044,%eax
  8023dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8023df:	89 10                	mov    %edx,(%eax)
  8023e1:	eb 08                	jmp    8023eb <insert_sorted_allocList+0x181>
  8023e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e6:	a3 40 50 80 00       	mov    %eax,0x805040
  8023eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ee:	a3 44 50 80 00       	mov    %eax,0x805044
  8023f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023fc:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802401:	40                   	inc    %eax
  802402:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802407:	e9 e7 00 00 00       	jmp    8024f3 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80240c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80240f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802412:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802419:	a1 40 50 80 00       	mov    0x805040,%eax
  80241e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802421:	e9 9d 00 00 00       	jmp    8024c3 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802426:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802429:	8b 00                	mov    (%eax),%eax
  80242b:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80242e:	8b 45 08             	mov    0x8(%ebp),%eax
  802431:	8b 50 08             	mov    0x8(%eax),%edx
  802434:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802437:	8b 40 08             	mov    0x8(%eax),%eax
  80243a:	39 c2                	cmp    %eax,%edx
  80243c:	76 7d                	jbe    8024bb <insert_sorted_allocList+0x251>
  80243e:	8b 45 08             	mov    0x8(%ebp),%eax
  802441:	8b 50 08             	mov    0x8(%eax),%edx
  802444:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802447:	8b 40 08             	mov    0x8(%eax),%eax
  80244a:	39 c2                	cmp    %eax,%edx
  80244c:	73 6d                	jae    8024bb <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80244e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802452:	74 06                	je     80245a <insert_sorted_allocList+0x1f0>
  802454:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802458:	75 14                	jne    80246e <insert_sorted_allocList+0x204>
  80245a:	83 ec 04             	sub    $0x4,%esp
  80245d:	68 50 41 80 00       	push   $0x804150
  802462:	6a 7f                	push   $0x7f
  802464:	68 db 40 80 00       	push   $0x8040db
  802469:	e8 80 11 00 00       	call   8035ee <_panic>
  80246e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802471:	8b 10                	mov    (%eax),%edx
  802473:	8b 45 08             	mov    0x8(%ebp),%eax
  802476:	89 10                	mov    %edx,(%eax)
  802478:	8b 45 08             	mov    0x8(%ebp),%eax
  80247b:	8b 00                	mov    (%eax),%eax
  80247d:	85 c0                	test   %eax,%eax
  80247f:	74 0b                	je     80248c <insert_sorted_allocList+0x222>
  802481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802484:	8b 00                	mov    (%eax),%eax
  802486:	8b 55 08             	mov    0x8(%ebp),%edx
  802489:	89 50 04             	mov    %edx,0x4(%eax)
  80248c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248f:	8b 55 08             	mov    0x8(%ebp),%edx
  802492:	89 10                	mov    %edx,(%eax)
  802494:	8b 45 08             	mov    0x8(%ebp),%eax
  802497:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80249a:	89 50 04             	mov    %edx,0x4(%eax)
  80249d:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a0:	8b 00                	mov    (%eax),%eax
  8024a2:	85 c0                	test   %eax,%eax
  8024a4:	75 08                	jne    8024ae <insert_sorted_allocList+0x244>
  8024a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a9:	a3 44 50 80 00       	mov    %eax,0x805044
  8024ae:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8024b3:	40                   	inc    %eax
  8024b4:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8024b9:	eb 39                	jmp    8024f4 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8024bb:	a1 48 50 80 00       	mov    0x805048,%eax
  8024c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024c7:	74 07                	je     8024d0 <insert_sorted_allocList+0x266>
  8024c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cc:	8b 00                	mov    (%eax),%eax
  8024ce:	eb 05                	jmp    8024d5 <insert_sorted_allocList+0x26b>
  8024d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8024d5:	a3 48 50 80 00       	mov    %eax,0x805048
  8024da:	a1 48 50 80 00       	mov    0x805048,%eax
  8024df:	85 c0                	test   %eax,%eax
  8024e1:	0f 85 3f ff ff ff    	jne    802426 <insert_sorted_allocList+0x1bc>
  8024e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024eb:	0f 85 35 ff ff ff    	jne    802426 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8024f1:	eb 01                	jmp    8024f4 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8024f3:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8024f4:	90                   	nop
  8024f5:	c9                   	leave  
  8024f6:	c3                   	ret    

008024f7 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8024f7:	55                   	push   %ebp
  8024f8:	89 e5                	mov    %esp,%ebp
  8024fa:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8024fd:	a1 38 51 80 00       	mov    0x805138,%eax
  802502:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802505:	e9 85 01 00 00       	jmp    80268f <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  80250a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250d:	8b 40 0c             	mov    0xc(%eax),%eax
  802510:	3b 45 08             	cmp    0x8(%ebp),%eax
  802513:	0f 82 6e 01 00 00    	jb     802687 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802519:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251c:	8b 40 0c             	mov    0xc(%eax),%eax
  80251f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802522:	0f 85 8a 00 00 00    	jne    8025b2 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802528:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80252c:	75 17                	jne    802545 <alloc_block_FF+0x4e>
  80252e:	83 ec 04             	sub    $0x4,%esp
  802531:	68 84 41 80 00       	push   $0x804184
  802536:	68 93 00 00 00       	push   $0x93
  80253b:	68 db 40 80 00       	push   $0x8040db
  802540:	e8 a9 10 00 00       	call   8035ee <_panic>
  802545:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802548:	8b 00                	mov    (%eax),%eax
  80254a:	85 c0                	test   %eax,%eax
  80254c:	74 10                	je     80255e <alloc_block_FF+0x67>
  80254e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802551:	8b 00                	mov    (%eax),%eax
  802553:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802556:	8b 52 04             	mov    0x4(%edx),%edx
  802559:	89 50 04             	mov    %edx,0x4(%eax)
  80255c:	eb 0b                	jmp    802569 <alloc_block_FF+0x72>
  80255e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802561:	8b 40 04             	mov    0x4(%eax),%eax
  802564:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802569:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256c:	8b 40 04             	mov    0x4(%eax),%eax
  80256f:	85 c0                	test   %eax,%eax
  802571:	74 0f                	je     802582 <alloc_block_FF+0x8b>
  802573:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802576:	8b 40 04             	mov    0x4(%eax),%eax
  802579:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80257c:	8b 12                	mov    (%edx),%edx
  80257e:	89 10                	mov    %edx,(%eax)
  802580:	eb 0a                	jmp    80258c <alloc_block_FF+0x95>
  802582:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802585:	8b 00                	mov    (%eax),%eax
  802587:	a3 38 51 80 00       	mov    %eax,0x805138
  80258c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802595:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802598:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80259f:	a1 44 51 80 00       	mov    0x805144,%eax
  8025a4:	48                   	dec    %eax
  8025a5:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8025aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ad:	e9 10 01 00 00       	jmp    8026c2 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8025b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8025b8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025bb:	0f 86 c6 00 00 00    	jbe    802687 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8025c1:	a1 48 51 80 00       	mov    0x805148,%eax
  8025c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8025c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cc:	8b 50 08             	mov    0x8(%eax),%edx
  8025cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d2:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8025d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8025db:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8025de:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025e2:	75 17                	jne    8025fb <alloc_block_FF+0x104>
  8025e4:	83 ec 04             	sub    $0x4,%esp
  8025e7:	68 84 41 80 00       	push   $0x804184
  8025ec:	68 9b 00 00 00       	push   $0x9b
  8025f1:	68 db 40 80 00       	push   $0x8040db
  8025f6:	e8 f3 0f 00 00       	call   8035ee <_panic>
  8025fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025fe:	8b 00                	mov    (%eax),%eax
  802600:	85 c0                	test   %eax,%eax
  802602:	74 10                	je     802614 <alloc_block_FF+0x11d>
  802604:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802607:	8b 00                	mov    (%eax),%eax
  802609:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80260c:	8b 52 04             	mov    0x4(%edx),%edx
  80260f:	89 50 04             	mov    %edx,0x4(%eax)
  802612:	eb 0b                	jmp    80261f <alloc_block_FF+0x128>
  802614:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802617:	8b 40 04             	mov    0x4(%eax),%eax
  80261a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80261f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802622:	8b 40 04             	mov    0x4(%eax),%eax
  802625:	85 c0                	test   %eax,%eax
  802627:	74 0f                	je     802638 <alloc_block_FF+0x141>
  802629:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80262c:	8b 40 04             	mov    0x4(%eax),%eax
  80262f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802632:	8b 12                	mov    (%edx),%edx
  802634:	89 10                	mov    %edx,(%eax)
  802636:	eb 0a                	jmp    802642 <alloc_block_FF+0x14b>
  802638:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80263b:	8b 00                	mov    (%eax),%eax
  80263d:	a3 48 51 80 00       	mov    %eax,0x805148
  802642:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802645:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80264b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80264e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802655:	a1 54 51 80 00       	mov    0x805154,%eax
  80265a:	48                   	dec    %eax
  80265b:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802660:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802663:	8b 50 08             	mov    0x8(%eax),%edx
  802666:	8b 45 08             	mov    0x8(%ebp),%eax
  802669:	01 c2                	add    %eax,%edx
  80266b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266e:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802671:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802674:	8b 40 0c             	mov    0xc(%eax),%eax
  802677:	2b 45 08             	sub    0x8(%ebp),%eax
  80267a:	89 c2                	mov    %eax,%edx
  80267c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267f:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802682:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802685:	eb 3b                	jmp    8026c2 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802687:	a1 40 51 80 00       	mov    0x805140,%eax
  80268c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80268f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802693:	74 07                	je     80269c <alloc_block_FF+0x1a5>
  802695:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802698:	8b 00                	mov    (%eax),%eax
  80269a:	eb 05                	jmp    8026a1 <alloc_block_FF+0x1aa>
  80269c:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a1:	a3 40 51 80 00       	mov    %eax,0x805140
  8026a6:	a1 40 51 80 00       	mov    0x805140,%eax
  8026ab:	85 c0                	test   %eax,%eax
  8026ad:	0f 85 57 fe ff ff    	jne    80250a <alloc_block_FF+0x13>
  8026b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026b7:	0f 85 4d fe ff ff    	jne    80250a <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8026bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026c2:	c9                   	leave  
  8026c3:	c3                   	ret    

008026c4 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8026c4:	55                   	push   %ebp
  8026c5:	89 e5                	mov    %esp,%ebp
  8026c7:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8026ca:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8026d1:	a1 38 51 80 00       	mov    0x805138,%eax
  8026d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026d9:	e9 df 00 00 00       	jmp    8027bd <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8026de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8026e4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026e7:	0f 82 c8 00 00 00    	jb     8027b5 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8026ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8026f3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026f6:	0f 85 8a 00 00 00    	jne    802786 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8026fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802700:	75 17                	jne    802719 <alloc_block_BF+0x55>
  802702:	83 ec 04             	sub    $0x4,%esp
  802705:	68 84 41 80 00       	push   $0x804184
  80270a:	68 b7 00 00 00       	push   $0xb7
  80270f:	68 db 40 80 00       	push   $0x8040db
  802714:	e8 d5 0e 00 00       	call   8035ee <_panic>
  802719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271c:	8b 00                	mov    (%eax),%eax
  80271e:	85 c0                	test   %eax,%eax
  802720:	74 10                	je     802732 <alloc_block_BF+0x6e>
  802722:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802725:	8b 00                	mov    (%eax),%eax
  802727:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80272a:	8b 52 04             	mov    0x4(%edx),%edx
  80272d:	89 50 04             	mov    %edx,0x4(%eax)
  802730:	eb 0b                	jmp    80273d <alloc_block_BF+0x79>
  802732:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802735:	8b 40 04             	mov    0x4(%eax),%eax
  802738:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80273d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802740:	8b 40 04             	mov    0x4(%eax),%eax
  802743:	85 c0                	test   %eax,%eax
  802745:	74 0f                	je     802756 <alloc_block_BF+0x92>
  802747:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274a:	8b 40 04             	mov    0x4(%eax),%eax
  80274d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802750:	8b 12                	mov    (%edx),%edx
  802752:	89 10                	mov    %edx,(%eax)
  802754:	eb 0a                	jmp    802760 <alloc_block_BF+0x9c>
  802756:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802759:	8b 00                	mov    (%eax),%eax
  80275b:	a3 38 51 80 00       	mov    %eax,0x805138
  802760:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802763:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802769:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802773:	a1 44 51 80 00       	mov    0x805144,%eax
  802778:	48                   	dec    %eax
  802779:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  80277e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802781:	e9 4d 01 00 00       	jmp    8028d3 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802786:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802789:	8b 40 0c             	mov    0xc(%eax),%eax
  80278c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80278f:	76 24                	jbe    8027b5 <alloc_block_BF+0xf1>
  802791:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802794:	8b 40 0c             	mov    0xc(%eax),%eax
  802797:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80279a:	73 19                	jae    8027b5 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80279c:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8027a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8027a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8027ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027af:	8b 40 08             	mov    0x8(%eax),%eax
  8027b2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8027b5:	a1 40 51 80 00       	mov    0x805140,%eax
  8027ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027c1:	74 07                	je     8027ca <alloc_block_BF+0x106>
  8027c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c6:	8b 00                	mov    (%eax),%eax
  8027c8:	eb 05                	jmp    8027cf <alloc_block_BF+0x10b>
  8027ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8027cf:	a3 40 51 80 00       	mov    %eax,0x805140
  8027d4:	a1 40 51 80 00       	mov    0x805140,%eax
  8027d9:	85 c0                	test   %eax,%eax
  8027db:	0f 85 fd fe ff ff    	jne    8026de <alloc_block_BF+0x1a>
  8027e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027e5:	0f 85 f3 fe ff ff    	jne    8026de <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8027eb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8027ef:	0f 84 d9 00 00 00    	je     8028ce <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8027f5:	a1 48 51 80 00       	mov    0x805148,%eax
  8027fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8027fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802800:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802803:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802806:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802809:	8b 55 08             	mov    0x8(%ebp),%edx
  80280c:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  80280f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802813:	75 17                	jne    80282c <alloc_block_BF+0x168>
  802815:	83 ec 04             	sub    $0x4,%esp
  802818:	68 84 41 80 00       	push   $0x804184
  80281d:	68 c7 00 00 00       	push   $0xc7
  802822:	68 db 40 80 00       	push   $0x8040db
  802827:	e8 c2 0d 00 00       	call   8035ee <_panic>
  80282c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80282f:	8b 00                	mov    (%eax),%eax
  802831:	85 c0                	test   %eax,%eax
  802833:	74 10                	je     802845 <alloc_block_BF+0x181>
  802835:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802838:	8b 00                	mov    (%eax),%eax
  80283a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80283d:	8b 52 04             	mov    0x4(%edx),%edx
  802840:	89 50 04             	mov    %edx,0x4(%eax)
  802843:	eb 0b                	jmp    802850 <alloc_block_BF+0x18c>
  802845:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802848:	8b 40 04             	mov    0x4(%eax),%eax
  80284b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802850:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802853:	8b 40 04             	mov    0x4(%eax),%eax
  802856:	85 c0                	test   %eax,%eax
  802858:	74 0f                	je     802869 <alloc_block_BF+0x1a5>
  80285a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80285d:	8b 40 04             	mov    0x4(%eax),%eax
  802860:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802863:	8b 12                	mov    (%edx),%edx
  802865:	89 10                	mov    %edx,(%eax)
  802867:	eb 0a                	jmp    802873 <alloc_block_BF+0x1af>
  802869:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80286c:	8b 00                	mov    (%eax),%eax
  80286e:	a3 48 51 80 00       	mov    %eax,0x805148
  802873:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802876:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80287c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80287f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802886:	a1 54 51 80 00       	mov    0x805154,%eax
  80288b:	48                   	dec    %eax
  80288c:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802891:	83 ec 08             	sub    $0x8,%esp
  802894:	ff 75 ec             	pushl  -0x14(%ebp)
  802897:	68 38 51 80 00       	push   $0x805138
  80289c:	e8 71 f9 ff ff       	call   802212 <find_block>
  8028a1:	83 c4 10             	add    $0x10,%esp
  8028a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8028a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028aa:	8b 50 08             	mov    0x8(%eax),%edx
  8028ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b0:	01 c2                	add    %eax,%edx
  8028b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028b5:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8028b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8028be:	2b 45 08             	sub    0x8(%ebp),%eax
  8028c1:	89 c2                	mov    %eax,%edx
  8028c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028c6:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8028c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028cc:	eb 05                	jmp    8028d3 <alloc_block_BF+0x20f>
	}
	return NULL;
  8028ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028d3:	c9                   	leave  
  8028d4:	c3                   	ret    

008028d5 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8028d5:	55                   	push   %ebp
  8028d6:	89 e5                	mov    %esp,%ebp
  8028d8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8028db:	a1 28 50 80 00       	mov    0x805028,%eax
  8028e0:	85 c0                	test   %eax,%eax
  8028e2:	0f 85 de 01 00 00    	jne    802ac6 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8028e8:	a1 38 51 80 00       	mov    0x805138,%eax
  8028ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028f0:	e9 9e 01 00 00       	jmp    802a93 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8028f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8028fb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028fe:	0f 82 87 01 00 00    	jb     802a8b <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802904:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802907:	8b 40 0c             	mov    0xc(%eax),%eax
  80290a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80290d:	0f 85 95 00 00 00    	jne    8029a8 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802913:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802917:	75 17                	jne    802930 <alloc_block_NF+0x5b>
  802919:	83 ec 04             	sub    $0x4,%esp
  80291c:	68 84 41 80 00       	push   $0x804184
  802921:	68 e0 00 00 00       	push   $0xe0
  802926:	68 db 40 80 00       	push   $0x8040db
  80292b:	e8 be 0c 00 00       	call   8035ee <_panic>
  802930:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802933:	8b 00                	mov    (%eax),%eax
  802935:	85 c0                	test   %eax,%eax
  802937:	74 10                	je     802949 <alloc_block_NF+0x74>
  802939:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293c:	8b 00                	mov    (%eax),%eax
  80293e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802941:	8b 52 04             	mov    0x4(%edx),%edx
  802944:	89 50 04             	mov    %edx,0x4(%eax)
  802947:	eb 0b                	jmp    802954 <alloc_block_NF+0x7f>
  802949:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294c:	8b 40 04             	mov    0x4(%eax),%eax
  80294f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802954:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802957:	8b 40 04             	mov    0x4(%eax),%eax
  80295a:	85 c0                	test   %eax,%eax
  80295c:	74 0f                	je     80296d <alloc_block_NF+0x98>
  80295e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802961:	8b 40 04             	mov    0x4(%eax),%eax
  802964:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802967:	8b 12                	mov    (%edx),%edx
  802969:	89 10                	mov    %edx,(%eax)
  80296b:	eb 0a                	jmp    802977 <alloc_block_NF+0xa2>
  80296d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802970:	8b 00                	mov    (%eax),%eax
  802972:	a3 38 51 80 00       	mov    %eax,0x805138
  802977:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802980:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802983:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80298a:	a1 44 51 80 00       	mov    0x805144,%eax
  80298f:	48                   	dec    %eax
  802990:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802995:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802998:	8b 40 08             	mov    0x8(%eax),%eax
  80299b:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8029a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a3:	e9 f8 04 00 00       	jmp    802ea0 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8029a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8029ae:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029b1:	0f 86 d4 00 00 00    	jbe    802a8b <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8029b7:	a1 48 51 80 00       	mov    0x805148,%eax
  8029bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8029bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c2:	8b 50 08             	mov    0x8(%eax),%edx
  8029c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c8:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8029cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8029d1:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8029d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029d8:	75 17                	jne    8029f1 <alloc_block_NF+0x11c>
  8029da:	83 ec 04             	sub    $0x4,%esp
  8029dd:	68 84 41 80 00       	push   $0x804184
  8029e2:	68 e9 00 00 00       	push   $0xe9
  8029e7:	68 db 40 80 00       	push   $0x8040db
  8029ec:	e8 fd 0b 00 00       	call   8035ee <_panic>
  8029f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f4:	8b 00                	mov    (%eax),%eax
  8029f6:	85 c0                	test   %eax,%eax
  8029f8:	74 10                	je     802a0a <alloc_block_NF+0x135>
  8029fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029fd:	8b 00                	mov    (%eax),%eax
  8029ff:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a02:	8b 52 04             	mov    0x4(%edx),%edx
  802a05:	89 50 04             	mov    %edx,0x4(%eax)
  802a08:	eb 0b                	jmp    802a15 <alloc_block_NF+0x140>
  802a0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a0d:	8b 40 04             	mov    0x4(%eax),%eax
  802a10:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a18:	8b 40 04             	mov    0x4(%eax),%eax
  802a1b:	85 c0                	test   %eax,%eax
  802a1d:	74 0f                	je     802a2e <alloc_block_NF+0x159>
  802a1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a22:	8b 40 04             	mov    0x4(%eax),%eax
  802a25:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a28:	8b 12                	mov    (%edx),%edx
  802a2a:	89 10                	mov    %edx,(%eax)
  802a2c:	eb 0a                	jmp    802a38 <alloc_block_NF+0x163>
  802a2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a31:	8b 00                	mov    (%eax),%eax
  802a33:	a3 48 51 80 00       	mov    %eax,0x805148
  802a38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a3b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a44:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a4b:	a1 54 51 80 00       	mov    0x805154,%eax
  802a50:	48                   	dec    %eax
  802a51:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802a56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a59:	8b 40 08             	mov    0x8(%eax),%eax
  802a5c:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802a61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a64:	8b 50 08             	mov    0x8(%eax),%edx
  802a67:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6a:	01 c2                	add    %eax,%edx
  802a6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6f:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a75:	8b 40 0c             	mov    0xc(%eax),%eax
  802a78:	2b 45 08             	sub    0x8(%ebp),%eax
  802a7b:	89 c2                	mov    %eax,%edx
  802a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a80:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802a83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a86:	e9 15 04 00 00       	jmp    802ea0 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802a8b:	a1 40 51 80 00       	mov    0x805140,%eax
  802a90:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a93:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a97:	74 07                	je     802aa0 <alloc_block_NF+0x1cb>
  802a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9c:	8b 00                	mov    (%eax),%eax
  802a9e:	eb 05                	jmp    802aa5 <alloc_block_NF+0x1d0>
  802aa0:	b8 00 00 00 00       	mov    $0x0,%eax
  802aa5:	a3 40 51 80 00       	mov    %eax,0x805140
  802aaa:	a1 40 51 80 00       	mov    0x805140,%eax
  802aaf:	85 c0                	test   %eax,%eax
  802ab1:	0f 85 3e fe ff ff    	jne    8028f5 <alloc_block_NF+0x20>
  802ab7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802abb:	0f 85 34 fe ff ff    	jne    8028f5 <alloc_block_NF+0x20>
  802ac1:	e9 d5 03 00 00       	jmp    802e9b <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802ac6:	a1 38 51 80 00       	mov    0x805138,%eax
  802acb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ace:	e9 b1 01 00 00       	jmp    802c84 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad6:	8b 50 08             	mov    0x8(%eax),%edx
  802ad9:	a1 28 50 80 00       	mov    0x805028,%eax
  802ade:	39 c2                	cmp    %eax,%edx
  802ae0:	0f 82 96 01 00 00    	jb     802c7c <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae9:	8b 40 0c             	mov    0xc(%eax),%eax
  802aec:	3b 45 08             	cmp    0x8(%ebp),%eax
  802aef:	0f 82 87 01 00 00    	jb     802c7c <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af8:	8b 40 0c             	mov    0xc(%eax),%eax
  802afb:	3b 45 08             	cmp    0x8(%ebp),%eax
  802afe:	0f 85 95 00 00 00    	jne    802b99 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802b04:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b08:	75 17                	jne    802b21 <alloc_block_NF+0x24c>
  802b0a:	83 ec 04             	sub    $0x4,%esp
  802b0d:	68 84 41 80 00       	push   $0x804184
  802b12:	68 fc 00 00 00       	push   $0xfc
  802b17:	68 db 40 80 00       	push   $0x8040db
  802b1c:	e8 cd 0a 00 00       	call   8035ee <_panic>
  802b21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b24:	8b 00                	mov    (%eax),%eax
  802b26:	85 c0                	test   %eax,%eax
  802b28:	74 10                	je     802b3a <alloc_block_NF+0x265>
  802b2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2d:	8b 00                	mov    (%eax),%eax
  802b2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b32:	8b 52 04             	mov    0x4(%edx),%edx
  802b35:	89 50 04             	mov    %edx,0x4(%eax)
  802b38:	eb 0b                	jmp    802b45 <alloc_block_NF+0x270>
  802b3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3d:	8b 40 04             	mov    0x4(%eax),%eax
  802b40:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b48:	8b 40 04             	mov    0x4(%eax),%eax
  802b4b:	85 c0                	test   %eax,%eax
  802b4d:	74 0f                	je     802b5e <alloc_block_NF+0x289>
  802b4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b52:	8b 40 04             	mov    0x4(%eax),%eax
  802b55:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b58:	8b 12                	mov    (%edx),%edx
  802b5a:	89 10                	mov    %edx,(%eax)
  802b5c:	eb 0a                	jmp    802b68 <alloc_block_NF+0x293>
  802b5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b61:	8b 00                	mov    (%eax),%eax
  802b63:	a3 38 51 80 00       	mov    %eax,0x805138
  802b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b74:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b7b:	a1 44 51 80 00       	mov    0x805144,%eax
  802b80:	48                   	dec    %eax
  802b81:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802b86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b89:	8b 40 08             	mov    0x8(%eax),%eax
  802b8c:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802b91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b94:	e9 07 03 00 00       	jmp    802ea0 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9c:	8b 40 0c             	mov    0xc(%eax),%eax
  802b9f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ba2:	0f 86 d4 00 00 00    	jbe    802c7c <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802ba8:	a1 48 51 80 00       	mov    0x805148,%eax
  802bad:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802bb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb3:	8b 50 08             	mov    0x8(%eax),%edx
  802bb6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bb9:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802bbc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bbf:	8b 55 08             	mov    0x8(%ebp),%edx
  802bc2:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802bc5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802bc9:	75 17                	jne    802be2 <alloc_block_NF+0x30d>
  802bcb:	83 ec 04             	sub    $0x4,%esp
  802bce:	68 84 41 80 00       	push   $0x804184
  802bd3:	68 04 01 00 00       	push   $0x104
  802bd8:	68 db 40 80 00       	push   $0x8040db
  802bdd:	e8 0c 0a 00 00       	call   8035ee <_panic>
  802be2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802be5:	8b 00                	mov    (%eax),%eax
  802be7:	85 c0                	test   %eax,%eax
  802be9:	74 10                	je     802bfb <alloc_block_NF+0x326>
  802beb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bee:	8b 00                	mov    (%eax),%eax
  802bf0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bf3:	8b 52 04             	mov    0x4(%edx),%edx
  802bf6:	89 50 04             	mov    %edx,0x4(%eax)
  802bf9:	eb 0b                	jmp    802c06 <alloc_block_NF+0x331>
  802bfb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bfe:	8b 40 04             	mov    0x4(%eax),%eax
  802c01:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c06:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c09:	8b 40 04             	mov    0x4(%eax),%eax
  802c0c:	85 c0                	test   %eax,%eax
  802c0e:	74 0f                	je     802c1f <alloc_block_NF+0x34a>
  802c10:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c13:	8b 40 04             	mov    0x4(%eax),%eax
  802c16:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c19:	8b 12                	mov    (%edx),%edx
  802c1b:	89 10                	mov    %edx,(%eax)
  802c1d:	eb 0a                	jmp    802c29 <alloc_block_NF+0x354>
  802c1f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c22:	8b 00                	mov    (%eax),%eax
  802c24:	a3 48 51 80 00       	mov    %eax,0x805148
  802c29:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c2c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c32:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c35:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c3c:	a1 54 51 80 00       	mov    0x805154,%eax
  802c41:	48                   	dec    %eax
  802c42:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802c47:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c4a:	8b 40 08             	mov    0x8(%eax),%eax
  802c4d:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802c52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c55:	8b 50 08             	mov    0x8(%eax),%edx
  802c58:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5b:	01 c2                	add    %eax,%edx
  802c5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c60:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802c63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c66:	8b 40 0c             	mov    0xc(%eax),%eax
  802c69:	2b 45 08             	sub    0x8(%ebp),%eax
  802c6c:	89 c2                	mov    %eax,%edx
  802c6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c71:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802c74:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c77:	e9 24 02 00 00       	jmp    802ea0 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c7c:	a1 40 51 80 00       	mov    0x805140,%eax
  802c81:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c84:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c88:	74 07                	je     802c91 <alloc_block_NF+0x3bc>
  802c8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8d:	8b 00                	mov    (%eax),%eax
  802c8f:	eb 05                	jmp    802c96 <alloc_block_NF+0x3c1>
  802c91:	b8 00 00 00 00       	mov    $0x0,%eax
  802c96:	a3 40 51 80 00       	mov    %eax,0x805140
  802c9b:	a1 40 51 80 00       	mov    0x805140,%eax
  802ca0:	85 c0                	test   %eax,%eax
  802ca2:	0f 85 2b fe ff ff    	jne    802ad3 <alloc_block_NF+0x1fe>
  802ca8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cac:	0f 85 21 fe ff ff    	jne    802ad3 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802cb2:	a1 38 51 80 00       	mov    0x805138,%eax
  802cb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cba:	e9 ae 01 00 00       	jmp    802e6d <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc2:	8b 50 08             	mov    0x8(%eax),%edx
  802cc5:	a1 28 50 80 00       	mov    0x805028,%eax
  802cca:	39 c2                	cmp    %eax,%edx
  802ccc:	0f 83 93 01 00 00    	jae    802e65 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802cd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd5:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd8:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cdb:	0f 82 84 01 00 00    	jb     802e65 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce4:	8b 40 0c             	mov    0xc(%eax),%eax
  802ce7:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cea:	0f 85 95 00 00 00    	jne    802d85 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802cf0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cf4:	75 17                	jne    802d0d <alloc_block_NF+0x438>
  802cf6:	83 ec 04             	sub    $0x4,%esp
  802cf9:	68 84 41 80 00       	push   $0x804184
  802cfe:	68 14 01 00 00       	push   $0x114
  802d03:	68 db 40 80 00       	push   $0x8040db
  802d08:	e8 e1 08 00 00       	call   8035ee <_panic>
  802d0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d10:	8b 00                	mov    (%eax),%eax
  802d12:	85 c0                	test   %eax,%eax
  802d14:	74 10                	je     802d26 <alloc_block_NF+0x451>
  802d16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d19:	8b 00                	mov    (%eax),%eax
  802d1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d1e:	8b 52 04             	mov    0x4(%edx),%edx
  802d21:	89 50 04             	mov    %edx,0x4(%eax)
  802d24:	eb 0b                	jmp    802d31 <alloc_block_NF+0x45c>
  802d26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d29:	8b 40 04             	mov    0x4(%eax),%eax
  802d2c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d34:	8b 40 04             	mov    0x4(%eax),%eax
  802d37:	85 c0                	test   %eax,%eax
  802d39:	74 0f                	je     802d4a <alloc_block_NF+0x475>
  802d3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3e:	8b 40 04             	mov    0x4(%eax),%eax
  802d41:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d44:	8b 12                	mov    (%edx),%edx
  802d46:	89 10                	mov    %edx,(%eax)
  802d48:	eb 0a                	jmp    802d54 <alloc_block_NF+0x47f>
  802d4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4d:	8b 00                	mov    (%eax),%eax
  802d4f:	a3 38 51 80 00       	mov    %eax,0x805138
  802d54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d57:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d60:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d67:	a1 44 51 80 00       	mov    0x805144,%eax
  802d6c:	48                   	dec    %eax
  802d6d:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802d72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d75:	8b 40 08             	mov    0x8(%eax),%eax
  802d78:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802d7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d80:	e9 1b 01 00 00       	jmp    802ea0 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802d85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d88:	8b 40 0c             	mov    0xc(%eax),%eax
  802d8b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d8e:	0f 86 d1 00 00 00    	jbe    802e65 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d94:	a1 48 51 80 00       	mov    0x805148,%eax
  802d99:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802d9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9f:	8b 50 08             	mov    0x8(%eax),%edx
  802da2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802da5:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802da8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dab:	8b 55 08             	mov    0x8(%ebp),%edx
  802dae:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802db1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802db5:	75 17                	jne    802dce <alloc_block_NF+0x4f9>
  802db7:	83 ec 04             	sub    $0x4,%esp
  802dba:	68 84 41 80 00       	push   $0x804184
  802dbf:	68 1c 01 00 00       	push   $0x11c
  802dc4:	68 db 40 80 00       	push   $0x8040db
  802dc9:	e8 20 08 00 00       	call   8035ee <_panic>
  802dce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd1:	8b 00                	mov    (%eax),%eax
  802dd3:	85 c0                	test   %eax,%eax
  802dd5:	74 10                	je     802de7 <alloc_block_NF+0x512>
  802dd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dda:	8b 00                	mov    (%eax),%eax
  802ddc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ddf:	8b 52 04             	mov    0x4(%edx),%edx
  802de2:	89 50 04             	mov    %edx,0x4(%eax)
  802de5:	eb 0b                	jmp    802df2 <alloc_block_NF+0x51d>
  802de7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dea:	8b 40 04             	mov    0x4(%eax),%eax
  802ded:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802df2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802df5:	8b 40 04             	mov    0x4(%eax),%eax
  802df8:	85 c0                	test   %eax,%eax
  802dfa:	74 0f                	je     802e0b <alloc_block_NF+0x536>
  802dfc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dff:	8b 40 04             	mov    0x4(%eax),%eax
  802e02:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e05:	8b 12                	mov    (%edx),%edx
  802e07:	89 10                	mov    %edx,(%eax)
  802e09:	eb 0a                	jmp    802e15 <alloc_block_NF+0x540>
  802e0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e0e:	8b 00                	mov    (%eax),%eax
  802e10:	a3 48 51 80 00       	mov    %eax,0x805148
  802e15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e18:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e21:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e28:	a1 54 51 80 00       	mov    0x805154,%eax
  802e2d:	48                   	dec    %eax
  802e2e:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802e33:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e36:	8b 40 08             	mov    0x8(%eax),%eax
  802e39:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802e3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e41:	8b 50 08             	mov    0x8(%eax),%edx
  802e44:	8b 45 08             	mov    0x8(%ebp),%eax
  802e47:	01 c2                	add    %eax,%edx
  802e49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4c:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e52:	8b 40 0c             	mov    0xc(%eax),%eax
  802e55:	2b 45 08             	sub    0x8(%ebp),%eax
  802e58:	89 c2                	mov    %eax,%edx
  802e5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5d:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802e60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e63:	eb 3b                	jmp    802ea0 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802e65:	a1 40 51 80 00       	mov    0x805140,%eax
  802e6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e6d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e71:	74 07                	je     802e7a <alloc_block_NF+0x5a5>
  802e73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e76:	8b 00                	mov    (%eax),%eax
  802e78:	eb 05                	jmp    802e7f <alloc_block_NF+0x5aa>
  802e7a:	b8 00 00 00 00       	mov    $0x0,%eax
  802e7f:	a3 40 51 80 00       	mov    %eax,0x805140
  802e84:	a1 40 51 80 00       	mov    0x805140,%eax
  802e89:	85 c0                	test   %eax,%eax
  802e8b:	0f 85 2e fe ff ff    	jne    802cbf <alloc_block_NF+0x3ea>
  802e91:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e95:	0f 85 24 fe ff ff    	jne    802cbf <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802e9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ea0:	c9                   	leave  
  802ea1:	c3                   	ret    

00802ea2 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802ea2:	55                   	push   %ebp
  802ea3:	89 e5                	mov    %esp,%ebp
  802ea5:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802ea8:	a1 38 51 80 00       	mov    0x805138,%eax
  802ead:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802eb0:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802eb5:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802eb8:	a1 38 51 80 00       	mov    0x805138,%eax
  802ebd:	85 c0                	test   %eax,%eax
  802ebf:	74 14                	je     802ed5 <insert_sorted_with_merge_freeList+0x33>
  802ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec4:	8b 50 08             	mov    0x8(%eax),%edx
  802ec7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eca:	8b 40 08             	mov    0x8(%eax),%eax
  802ecd:	39 c2                	cmp    %eax,%edx
  802ecf:	0f 87 9b 01 00 00    	ja     803070 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802ed5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ed9:	75 17                	jne    802ef2 <insert_sorted_with_merge_freeList+0x50>
  802edb:	83 ec 04             	sub    $0x4,%esp
  802ede:	68 b8 40 80 00       	push   $0x8040b8
  802ee3:	68 38 01 00 00       	push   $0x138
  802ee8:	68 db 40 80 00       	push   $0x8040db
  802eed:	e8 fc 06 00 00       	call   8035ee <_panic>
  802ef2:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  802efb:	89 10                	mov    %edx,(%eax)
  802efd:	8b 45 08             	mov    0x8(%ebp),%eax
  802f00:	8b 00                	mov    (%eax),%eax
  802f02:	85 c0                	test   %eax,%eax
  802f04:	74 0d                	je     802f13 <insert_sorted_with_merge_freeList+0x71>
  802f06:	a1 38 51 80 00       	mov    0x805138,%eax
  802f0b:	8b 55 08             	mov    0x8(%ebp),%edx
  802f0e:	89 50 04             	mov    %edx,0x4(%eax)
  802f11:	eb 08                	jmp    802f1b <insert_sorted_with_merge_freeList+0x79>
  802f13:	8b 45 08             	mov    0x8(%ebp),%eax
  802f16:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1e:	a3 38 51 80 00       	mov    %eax,0x805138
  802f23:	8b 45 08             	mov    0x8(%ebp),%eax
  802f26:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f2d:	a1 44 51 80 00       	mov    0x805144,%eax
  802f32:	40                   	inc    %eax
  802f33:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802f38:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f3c:	0f 84 a8 06 00 00    	je     8035ea <insert_sorted_with_merge_freeList+0x748>
  802f42:	8b 45 08             	mov    0x8(%ebp),%eax
  802f45:	8b 50 08             	mov    0x8(%eax),%edx
  802f48:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4b:	8b 40 0c             	mov    0xc(%eax),%eax
  802f4e:	01 c2                	add    %eax,%edx
  802f50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f53:	8b 40 08             	mov    0x8(%eax),%eax
  802f56:	39 c2                	cmp    %eax,%edx
  802f58:	0f 85 8c 06 00 00    	jne    8035ea <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f61:	8b 50 0c             	mov    0xc(%eax),%edx
  802f64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f67:	8b 40 0c             	mov    0xc(%eax),%eax
  802f6a:	01 c2                	add    %eax,%edx
  802f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6f:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802f72:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f76:	75 17                	jne    802f8f <insert_sorted_with_merge_freeList+0xed>
  802f78:	83 ec 04             	sub    $0x4,%esp
  802f7b:	68 84 41 80 00       	push   $0x804184
  802f80:	68 3c 01 00 00       	push   $0x13c
  802f85:	68 db 40 80 00       	push   $0x8040db
  802f8a:	e8 5f 06 00 00       	call   8035ee <_panic>
  802f8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f92:	8b 00                	mov    (%eax),%eax
  802f94:	85 c0                	test   %eax,%eax
  802f96:	74 10                	je     802fa8 <insert_sorted_with_merge_freeList+0x106>
  802f98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f9b:	8b 00                	mov    (%eax),%eax
  802f9d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fa0:	8b 52 04             	mov    0x4(%edx),%edx
  802fa3:	89 50 04             	mov    %edx,0x4(%eax)
  802fa6:	eb 0b                	jmp    802fb3 <insert_sorted_with_merge_freeList+0x111>
  802fa8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fab:	8b 40 04             	mov    0x4(%eax),%eax
  802fae:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb6:	8b 40 04             	mov    0x4(%eax),%eax
  802fb9:	85 c0                	test   %eax,%eax
  802fbb:	74 0f                	je     802fcc <insert_sorted_with_merge_freeList+0x12a>
  802fbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc0:	8b 40 04             	mov    0x4(%eax),%eax
  802fc3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fc6:	8b 12                	mov    (%edx),%edx
  802fc8:	89 10                	mov    %edx,(%eax)
  802fca:	eb 0a                	jmp    802fd6 <insert_sorted_with_merge_freeList+0x134>
  802fcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fcf:	8b 00                	mov    (%eax),%eax
  802fd1:	a3 38 51 80 00       	mov    %eax,0x805138
  802fd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fd9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fe9:	a1 44 51 80 00       	mov    0x805144,%eax
  802fee:	48                   	dec    %eax
  802fef:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802ff4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802ffe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803001:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803008:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80300c:	75 17                	jne    803025 <insert_sorted_with_merge_freeList+0x183>
  80300e:	83 ec 04             	sub    $0x4,%esp
  803011:	68 b8 40 80 00       	push   $0x8040b8
  803016:	68 3f 01 00 00       	push   $0x13f
  80301b:	68 db 40 80 00       	push   $0x8040db
  803020:	e8 c9 05 00 00       	call   8035ee <_panic>
  803025:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80302b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80302e:	89 10                	mov    %edx,(%eax)
  803030:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803033:	8b 00                	mov    (%eax),%eax
  803035:	85 c0                	test   %eax,%eax
  803037:	74 0d                	je     803046 <insert_sorted_with_merge_freeList+0x1a4>
  803039:	a1 48 51 80 00       	mov    0x805148,%eax
  80303e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803041:	89 50 04             	mov    %edx,0x4(%eax)
  803044:	eb 08                	jmp    80304e <insert_sorted_with_merge_freeList+0x1ac>
  803046:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803049:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80304e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803051:	a3 48 51 80 00       	mov    %eax,0x805148
  803056:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803059:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803060:	a1 54 51 80 00       	mov    0x805154,%eax
  803065:	40                   	inc    %eax
  803066:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80306b:	e9 7a 05 00 00       	jmp    8035ea <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803070:	8b 45 08             	mov    0x8(%ebp),%eax
  803073:	8b 50 08             	mov    0x8(%eax),%edx
  803076:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803079:	8b 40 08             	mov    0x8(%eax),%eax
  80307c:	39 c2                	cmp    %eax,%edx
  80307e:	0f 82 14 01 00 00    	jb     803198 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803084:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803087:	8b 50 08             	mov    0x8(%eax),%edx
  80308a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80308d:	8b 40 0c             	mov    0xc(%eax),%eax
  803090:	01 c2                	add    %eax,%edx
  803092:	8b 45 08             	mov    0x8(%ebp),%eax
  803095:	8b 40 08             	mov    0x8(%eax),%eax
  803098:	39 c2                	cmp    %eax,%edx
  80309a:	0f 85 90 00 00 00    	jne    803130 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8030a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030a3:	8b 50 0c             	mov    0xc(%eax),%edx
  8030a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8030ac:	01 c2                	add    %eax,%edx
  8030ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030b1:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  8030b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8030be:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8030c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030cc:	75 17                	jne    8030e5 <insert_sorted_with_merge_freeList+0x243>
  8030ce:	83 ec 04             	sub    $0x4,%esp
  8030d1:	68 b8 40 80 00       	push   $0x8040b8
  8030d6:	68 49 01 00 00       	push   $0x149
  8030db:	68 db 40 80 00       	push   $0x8040db
  8030e0:	e8 09 05 00 00       	call   8035ee <_panic>
  8030e5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ee:	89 10                	mov    %edx,(%eax)
  8030f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f3:	8b 00                	mov    (%eax),%eax
  8030f5:	85 c0                	test   %eax,%eax
  8030f7:	74 0d                	je     803106 <insert_sorted_with_merge_freeList+0x264>
  8030f9:	a1 48 51 80 00       	mov    0x805148,%eax
  8030fe:	8b 55 08             	mov    0x8(%ebp),%edx
  803101:	89 50 04             	mov    %edx,0x4(%eax)
  803104:	eb 08                	jmp    80310e <insert_sorted_with_merge_freeList+0x26c>
  803106:	8b 45 08             	mov    0x8(%ebp),%eax
  803109:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80310e:	8b 45 08             	mov    0x8(%ebp),%eax
  803111:	a3 48 51 80 00       	mov    %eax,0x805148
  803116:	8b 45 08             	mov    0x8(%ebp),%eax
  803119:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803120:	a1 54 51 80 00       	mov    0x805154,%eax
  803125:	40                   	inc    %eax
  803126:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80312b:	e9 bb 04 00 00       	jmp    8035eb <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803130:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803134:	75 17                	jne    80314d <insert_sorted_with_merge_freeList+0x2ab>
  803136:	83 ec 04             	sub    $0x4,%esp
  803139:	68 2c 41 80 00       	push   $0x80412c
  80313e:	68 4c 01 00 00       	push   $0x14c
  803143:	68 db 40 80 00       	push   $0x8040db
  803148:	e8 a1 04 00 00       	call   8035ee <_panic>
  80314d:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803153:	8b 45 08             	mov    0x8(%ebp),%eax
  803156:	89 50 04             	mov    %edx,0x4(%eax)
  803159:	8b 45 08             	mov    0x8(%ebp),%eax
  80315c:	8b 40 04             	mov    0x4(%eax),%eax
  80315f:	85 c0                	test   %eax,%eax
  803161:	74 0c                	je     80316f <insert_sorted_with_merge_freeList+0x2cd>
  803163:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803168:	8b 55 08             	mov    0x8(%ebp),%edx
  80316b:	89 10                	mov    %edx,(%eax)
  80316d:	eb 08                	jmp    803177 <insert_sorted_with_merge_freeList+0x2d5>
  80316f:	8b 45 08             	mov    0x8(%ebp),%eax
  803172:	a3 38 51 80 00       	mov    %eax,0x805138
  803177:	8b 45 08             	mov    0x8(%ebp),%eax
  80317a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80317f:	8b 45 08             	mov    0x8(%ebp),%eax
  803182:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803188:	a1 44 51 80 00       	mov    0x805144,%eax
  80318d:	40                   	inc    %eax
  80318e:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803193:	e9 53 04 00 00       	jmp    8035eb <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803198:	a1 38 51 80 00       	mov    0x805138,%eax
  80319d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031a0:	e9 15 04 00 00       	jmp    8035ba <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8031a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a8:	8b 00                	mov    (%eax),%eax
  8031aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8031ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b0:	8b 50 08             	mov    0x8(%eax),%edx
  8031b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b6:	8b 40 08             	mov    0x8(%eax),%eax
  8031b9:	39 c2                	cmp    %eax,%edx
  8031bb:	0f 86 f1 03 00 00    	jbe    8035b2 <insert_sorted_with_merge_freeList+0x710>
  8031c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c4:	8b 50 08             	mov    0x8(%eax),%edx
  8031c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ca:	8b 40 08             	mov    0x8(%eax),%eax
  8031cd:	39 c2                	cmp    %eax,%edx
  8031cf:	0f 83 dd 03 00 00    	jae    8035b2 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8031d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d8:	8b 50 08             	mov    0x8(%eax),%edx
  8031db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031de:	8b 40 0c             	mov    0xc(%eax),%eax
  8031e1:	01 c2                	add    %eax,%edx
  8031e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e6:	8b 40 08             	mov    0x8(%eax),%eax
  8031e9:	39 c2                	cmp    %eax,%edx
  8031eb:	0f 85 b9 01 00 00    	jne    8033aa <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8031f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f4:	8b 50 08             	mov    0x8(%eax),%edx
  8031f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fa:	8b 40 0c             	mov    0xc(%eax),%eax
  8031fd:	01 c2                	add    %eax,%edx
  8031ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803202:	8b 40 08             	mov    0x8(%eax),%eax
  803205:	39 c2                	cmp    %eax,%edx
  803207:	0f 85 0d 01 00 00    	jne    80331a <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  80320d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803210:	8b 50 0c             	mov    0xc(%eax),%edx
  803213:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803216:	8b 40 0c             	mov    0xc(%eax),%eax
  803219:	01 c2                	add    %eax,%edx
  80321b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80321e:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803221:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803225:	75 17                	jne    80323e <insert_sorted_with_merge_freeList+0x39c>
  803227:	83 ec 04             	sub    $0x4,%esp
  80322a:	68 84 41 80 00       	push   $0x804184
  80322f:	68 5c 01 00 00       	push   $0x15c
  803234:	68 db 40 80 00       	push   $0x8040db
  803239:	e8 b0 03 00 00       	call   8035ee <_panic>
  80323e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803241:	8b 00                	mov    (%eax),%eax
  803243:	85 c0                	test   %eax,%eax
  803245:	74 10                	je     803257 <insert_sorted_with_merge_freeList+0x3b5>
  803247:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80324a:	8b 00                	mov    (%eax),%eax
  80324c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80324f:	8b 52 04             	mov    0x4(%edx),%edx
  803252:	89 50 04             	mov    %edx,0x4(%eax)
  803255:	eb 0b                	jmp    803262 <insert_sorted_with_merge_freeList+0x3c0>
  803257:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80325a:	8b 40 04             	mov    0x4(%eax),%eax
  80325d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803262:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803265:	8b 40 04             	mov    0x4(%eax),%eax
  803268:	85 c0                	test   %eax,%eax
  80326a:	74 0f                	je     80327b <insert_sorted_with_merge_freeList+0x3d9>
  80326c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80326f:	8b 40 04             	mov    0x4(%eax),%eax
  803272:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803275:	8b 12                	mov    (%edx),%edx
  803277:	89 10                	mov    %edx,(%eax)
  803279:	eb 0a                	jmp    803285 <insert_sorted_with_merge_freeList+0x3e3>
  80327b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80327e:	8b 00                	mov    (%eax),%eax
  803280:	a3 38 51 80 00       	mov    %eax,0x805138
  803285:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803288:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80328e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803291:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803298:	a1 44 51 80 00       	mov    0x805144,%eax
  80329d:	48                   	dec    %eax
  80329e:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8032a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8032ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8032b7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032bb:	75 17                	jne    8032d4 <insert_sorted_with_merge_freeList+0x432>
  8032bd:	83 ec 04             	sub    $0x4,%esp
  8032c0:	68 b8 40 80 00       	push   $0x8040b8
  8032c5:	68 5f 01 00 00       	push   $0x15f
  8032ca:	68 db 40 80 00       	push   $0x8040db
  8032cf:	e8 1a 03 00 00       	call   8035ee <_panic>
  8032d4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032dd:	89 10                	mov    %edx,(%eax)
  8032df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e2:	8b 00                	mov    (%eax),%eax
  8032e4:	85 c0                	test   %eax,%eax
  8032e6:	74 0d                	je     8032f5 <insert_sorted_with_merge_freeList+0x453>
  8032e8:	a1 48 51 80 00       	mov    0x805148,%eax
  8032ed:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032f0:	89 50 04             	mov    %edx,0x4(%eax)
  8032f3:	eb 08                	jmp    8032fd <insert_sorted_with_merge_freeList+0x45b>
  8032f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803300:	a3 48 51 80 00       	mov    %eax,0x805148
  803305:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803308:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80330f:	a1 54 51 80 00       	mov    0x805154,%eax
  803314:	40                   	inc    %eax
  803315:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  80331a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80331d:	8b 50 0c             	mov    0xc(%eax),%edx
  803320:	8b 45 08             	mov    0x8(%ebp),%eax
  803323:	8b 40 0c             	mov    0xc(%eax),%eax
  803326:	01 c2                	add    %eax,%edx
  803328:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80332b:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80332e:	8b 45 08             	mov    0x8(%ebp),%eax
  803331:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803338:	8b 45 08             	mov    0x8(%ebp),%eax
  80333b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803342:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803346:	75 17                	jne    80335f <insert_sorted_with_merge_freeList+0x4bd>
  803348:	83 ec 04             	sub    $0x4,%esp
  80334b:	68 b8 40 80 00       	push   $0x8040b8
  803350:	68 64 01 00 00       	push   $0x164
  803355:	68 db 40 80 00       	push   $0x8040db
  80335a:	e8 8f 02 00 00       	call   8035ee <_panic>
  80335f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803365:	8b 45 08             	mov    0x8(%ebp),%eax
  803368:	89 10                	mov    %edx,(%eax)
  80336a:	8b 45 08             	mov    0x8(%ebp),%eax
  80336d:	8b 00                	mov    (%eax),%eax
  80336f:	85 c0                	test   %eax,%eax
  803371:	74 0d                	je     803380 <insert_sorted_with_merge_freeList+0x4de>
  803373:	a1 48 51 80 00       	mov    0x805148,%eax
  803378:	8b 55 08             	mov    0x8(%ebp),%edx
  80337b:	89 50 04             	mov    %edx,0x4(%eax)
  80337e:	eb 08                	jmp    803388 <insert_sorted_with_merge_freeList+0x4e6>
  803380:	8b 45 08             	mov    0x8(%ebp),%eax
  803383:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803388:	8b 45 08             	mov    0x8(%ebp),%eax
  80338b:	a3 48 51 80 00       	mov    %eax,0x805148
  803390:	8b 45 08             	mov    0x8(%ebp),%eax
  803393:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80339a:	a1 54 51 80 00       	mov    0x805154,%eax
  80339f:	40                   	inc    %eax
  8033a0:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8033a5:	e9 41 02 00 00       	jmp    8035eb <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8033aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ad:	8b 50 08             	mov    0x8(%eax),%edx
  8033b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8033b6:	01 c2                	add    %eax,%edx
  8033b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033bb:	8b 40 08             	mov    0x8(%eax),%eax
  8033be:	39 c2                	cmp    %eax,%edx
  8033c0:	0f 85 7c 01 00 00    	jne    803542 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8033c6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033ca:	74 06                	je     8033d2 <insert_sorted_with_merge_freeList+0x530>
  8033cc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033d0:	75 17                	jne    8033e9 <insert_sorted_with_merge_freeList+0x547>
  8033d2:	83 ec 04             	sub    $0x4,%esp
  8033d5:	68 f4 40 80 00       	push   $0x8040f4
  8033da:	68 69 01 00 00       	push   $0x169
  8033df:	68 db 40 80 00       	push   $0x8040db
  8033e4:	e8 05 02 00 00       	call   8035ee <_panic>
  8033e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ec:	8b 50 04             	mov    0x4(%eax),%edx
  8033ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f2:	89 50 04             	mov    %edx,0x4(%eax)
  8033f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033fb:	89 10                	mov    %edx,(%eax)
  8033fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803400:	8b 40 04             	mov    0x4(%eax),%eax
  803403:	85 c0                	test   %eax,%eax
  803405:	74 0d                	je     803414 <insert_sorted_with_merge_freeList+0x572>
  803407:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80340a:	8b 40 04             	mov    0x4(%eax),%eax
  80340d:	8b 55 08             	mov    0x8(%ebp),%edx
  803410:	89 10                	mov    %edx,(%eax)
  803412:	eb 08                	jmp    80341c <insert_sorted_with_merge_freeList+0x57a>
  803414:	8b 45 08             	mov    0x8(%ebp),%eax
  803417:	a3 38 51 80 00       	mov    %eax,0x805138
  80341c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80341f:	8b 55 08             	mov    0x8(%ebp),%edx
  803422:	89 50 04             	mov    %edx,0x4(%eax)
  803425:	a1 44 51 80 00       	mov    0x805144,%eax
  80342a:	40                   	inc    %eax
  80342b:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803430:	8b 45 08             	mov    0x8(%ebp),%eax
  803433:	8b 50 0c             	mov    0xc(%eax),%edx
  803436:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803439:	8b 40 0c             	mov    0xc(%eax),%eax
  80343c:	01 c2                	add    %eax,%edx
  80343e:	8b 45 08             	mov    0x8(%ebp),%eax
  803441:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803444:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803448:	75 17                	jne    803461 <insert_sorted_with_merge_freeList+0x5bf>
  80344a:	83 ec 04             	sub    $0x4,%esp
  80344d:	68 84 41 80 00       	push   $0x804184
  803452:	68 6b 01 00 00       	push   $0x16b
  803457:	68 db 40 80 00       	push   $0x8040db
  80345c:	e8 8d 01 00 00       	call   8035ee <_panic>
  803461:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803464:	8b 00                	mov    (%eax),%eax
  803466:	85 c0                	test   %eax,%eax
  803468:	74 10                	je     80347a <insert_sorted_with_merge_freeList+0x5d8>
  80346a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80346d:	8b 00                	mov    (%eax),%eax
  80346f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803472:	8b 52 04             	mov    0x4(%edx),%edx
  803475:	89 50 04             	mov    %edx,0x4(%eax)
  803478:	eb 0b                	jmp    803485 <insert_sorted_with_merge_freeList+0x5e3>
  80347a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80347d:	8b 40 04             	mov    0x4(%eax),%eax
  803480:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803485:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803488:	8b 40 04             	mov    0x4(%eax),%eax
  80348b:	85 c0                	test   %eax,%eax
  80348d:	74 0f                	je     80349e <insert_sorted_with_merge_freeList+0x5fc>
  80348f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803492:	8b 40 04             	mov    0x4(%eax),%eax
  803495:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803498:	8b 12                	mov    (%edx),%edx
  80349a:	89 10                	mov    %edx,(%eax)
  80349c:	eb 0a                	jmp    8034a8 <insert_sorted_with_merge_freeList+0x606>
  80349e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034a1:	8b 00                	mov    (%eax),%eax
  8034a3:	a3 38 51 80 00       	mov    %eax,0x805138
  8034a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034b4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034bb:	a1 44 51 80 00       	mov    0x805144,%eax
  8034c0:	48                   	dec    %eax
  8034c1:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8034c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034c9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8034d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034d3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8034da:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8034de:	75 17                	jne    8034f7 <insert_sorted_with_merge_freeList+0x655>
  8034e0:	83 ec 04             	sub    $0x4,%esp
  8034e3:	68 b8 40 80 00       	push   $0x8040b8
  8034e8:	68 6e 01 00 00       	push   $0x16e
  8034ed:	68 db 40 80 00       	push   $0x8040db
  8034f2:	e8 f7 00 00 00       	call   8035ee <_panic>
  8034f7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803500:	89 10                	mov    %edx,(%eax)
  803502:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803505:	8b 00                	mov    (%eax),%eax
  803507:	85 c0                	test   %eax,%eax
  803509:	74 0d                	je     803518 <insert_sorted_with_merge_freeList+0x676>
  80350b:	a1 48 51 80 00       	mov    0x805148,%eax
  803510:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803513:	89 50 04             	mov    %edx,0x4(%eax)
  803516:	eb 08                	jmp    803520 <insert_sorted_with_merge_freeList+0x67e>
  803518:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80351b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803520:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803523:	a3 48 51 80 00       	mov    %eax,0x805148
  803528:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80352b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803532:	a1 54 51 80 00       	mov    0x805154,%eax
  803537:	40                   	inc    %eax
  803538:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80353d:	e9 a9 00 00 00       	jmp    8035eb <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803542:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803546:	74 06                	je     80354e <insert_sorted_with_merge_freeList+0x6ac>
  803548:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80354c:	75 17                	jne    803565 <insert_sorted_with_merge_freeList+0x6c3>
  80354e:	83 ec 04             	sub    $0x4,%esp
  803551:	68 50 41 80 00       	push   $0x804150
  803556:	68 73 01 00 00       	push   $0x173
  80355b:	68 db 40 80 00       	push   $0x8040db
  803560:	e8 89 00 00 00       	call   8035ee <_panic>
  803565:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803568:	8b 10                	mov    (%eax),%edx
  80356a:	8b 45 08             	mov    0x8(%ebp),%eax
  80356d:	89 10                	mov    %edx,(%eax)
  80356f:	8b 45 08             	mov    0x8(%ebp),%eax
  803572:	8b 00                	mov    (%eax),%eax
  803574:	85 c0                	test   %eax,%eax
  803576:	74 0b                	je     803583 <insert_sorted_with_merge_freeList+0x6e1>
  803578:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80357b:	8b 00                	mov    (%eax),%eax
  80357d:	8b 55 08             	mov    0x8(%ebp),%edx
  803580:	89 50 04             	mov    %edx,0x4(%eax)
  803583:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803586:	8b 55 08             	mov    0x8(%ebp),%edx
  803589:	89 10                	mov    %edx,(%eax)
  80358b:	8b 45 08             	mov    0x8(%ebp),%eax
  80358e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803591:	89 50 04             	mov    %edx,0x4(%eax)
  803594:	8b 45 08             	mov    0x8(%ebp),%eax
  803597:	8b 00                	mov    (%eax),%eax
  803599:	85 c0                	test   %eax,%eax
  80359b:	75 08                	jne    8035a5 <insert_sorted_with_merge_freeList+0x703>
  80359d:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8035a5:	a1 44 51 80 00       	mov    0x805144,%eax
  8035aa:	40                   	inc    %eax
  8035ab:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8035b0:	eb 39                	jmp    8035eb <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8035b2:	a1 40 51 80 00       	mov    0x805140,%eax
  8035b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035be:	74 07                	je     8035c7 <insert_sorted_with_merge_freeList+0x725>
  8035c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c3:	8b 00                	mov    (%eax),%eax
  8035c5:	eb 05                	jmp    8035cc <insert_sorted_with_merge_freeList+0x72a>
  8035c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8035cc:	a3 40 51 80 00       	mov    %eax,0x805140
  8035d1:	a1 40 51 80 00       	mov    0x805140,%eax
  8035d6:	85 c0                	test   %eax,%eax
  8035d8:	0f 85 c7 fb ff ff    	jne    8031a5 <insert_sorted_with_merge_freeList+0x303>
  8035de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035e2:	0f 85 bd fb ff ff    	jne    8031a5 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8035e8:	eb 01                	jmp    8035eb <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8035ea:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8035eb:	90                   	nop
  8035ec:	c9                   	leave  
  8035ed:	c3                   	ret    

008035ee <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8035ee:	55                   	push   %ebp
  8035ef:	89 e5                	mov    %esp,%ebp
  8035f1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8035f4:	8d 45 10             	lea    0x10(%ebp),%eax
  8035f7:	83 c0 04             	add    $0x4,%eax
  8035fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8035fd:	a1 5c 51 80 00       	mov    0x80515c,%eax
  803602:	85 c0                	test   %eax,%eax
  803604:	74 16                	je     80361c <_panic+0x2e>
		cprintf("%s: ", argv0);
  803606:	a1 5c 51 80 00       	mov    0x80515c,%eax
  80360b:	83 ec 08             	sub    $0x8,%esp
  80360e:	50                   	push   %eax
  80360f:	68 a4 41 80 00       	push   $0x8041a4
  803614:	e8 24 d1 ff ff       	call   80073d <cprintf>
  803619:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80361c:	a1 00 50 80 00       	mov    0x805000,%eax
  803621:	ff 75 0c             	pushl  0xc(%ebp)
  803624:	ff 75 08             	pushl  0x8(%ebp)
  803627:	50                   	push   %eax
  803628:	68 a9 41 80 00       	push   $0x8041a9
  80362d:	e8 0b d1 ff ff       	call   80073d <cprintf>
  803632:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803635:	8b 45 10             	mov    0x10(%ebp),%eax
  803638:	83 ec 08             	sub    $0x8,%esp
  80363b:	ff 75 f4             	pushl  -0xc(%ebp)
  80363e:	50                   	push   %eax
  80363f:	e8 8e d0 ff ff       	call   8006d2 <vcprintf>
  803644:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803647:	83 ec 08             	sub    $0x8,%esp
  80364a:	6a 00                	push   $0x0
  80364c:	68 c5 41 80 00       	push   $0x8041c5
  803651:	e8 7c d0 ff ff       	call   8006d2 <vcprintf>
  803656:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803659:	e8 fd cf ff ff       	call   80065b <exit>

	// should not return here
	while (1) ;
  80365e:	eb fe                	jmp    80365e <_panic+0x70>

00803660 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803660:	55                   	push   %ebp
  803661:	89 e5                	mov    %esp,%ebp
  803663:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803666:	a1 20 50 80 00       	mov    0x805020,%eax
  80366b:	8b 50 74             	mov    0x74(%eax),%edx
  80366e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803671:	39 c2                	cmp    %eax,%edx
  803673:	74 14                	je     803689 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803675:	83 ec 04             	sub    $0x4,%esp
  803678:	68 c8 41 80 00       	push   $0x8041c8
  80367d:	6a 26                	push   $0x26
  80367f:	68 14 42 80 00       	push   $0x804214
  803684:	e8 65 ff ff ff       	call   8035ee <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803689:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803690:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803697:	e9 c2 00 00 00       	jmp    80375e <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80369c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80369f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8036a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a9:	01 d0                	add    %edx,%eax
  8036ab:	8b 00                	mov    (%eax),%eax
  8036ad:	85 c0                	test   %eax,%eax
  8036af:	75 08                	jne    8036b9 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8036b1:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8036b4:	e9 a2 00 00 00       	jmp    80375b <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8036b9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8036c0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8036c7:	eb 69                	jmp    803732 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8036c9:	a1 20 50 80 00       	mov    0x805020,%eax
  8036ce:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8036d4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036d7:	89 d0                	mov    %edx,%eax
  8036d9:	01 c0                	add    %eax,%eax
  8036db:	01 d0                	add    %edx,%eax
  8036dd:	c1 e0 03             	shl    $0x3,%eax
  8036e0:	01 c8                	add    %ecx,%eax
  8036e2:	8a 40 04             	mov    0x4(%eax),%al
  8036e5:	84 c0                	test   %al,%al
  8036e7:	75 46                	jne    80372f <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8036e9:	a1 20 50 80 00       	mov    0x805020,%eax
  8036ee:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8036f4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036f7:	89 d0                	mov    %edx,%eax
  8036f9:	01 c0                	add    %eax,%eax
  8036fb:	01 d0                	add    %edx,%eax
  8036fd:	c1 e0 03             	shl    $0x3,%eax
  803700:	01 c8                	add    %ecx,%eax
  803702:	8b 00                	mov    (%eax),%eax
  803704:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803707:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80370a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80370f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803711:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803714:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80371b:	8b 45 08             	mov    0x8(%ebp),%eax
  80371e:	01 c8                	add    %ecx,%eax
  803720:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803722:	39 c2                	cmp    %eax,%edx
  803724:	75 09                	jne    80372f <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  803726:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80372d:	eb 12                	jmp    803741 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80372f:	ff 45 e8             	incl   -0x18(%ebp)
  803732:	a1 20 50 80 00       	mov    0x805020,%eax
  803737:	8b 50 74             	mov    0x74(%eax),%edx
  80373a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80373d:	39 c2                	cmp    %eax,%edx
  80373f:	77 88                	ja     8036c9 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803741:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803745:	75 14                	jne    80375b <CheckWSWithoutLastIndex+0xfb>
			panic(
  803747:	83 ec 04             	sub    $0x4,%esp
  80374a:	68 20 42 80 00       	push   $0x804220
  80374f:	6a 3a                	push   $0x3a
  803751:	68 14 42 80 00       	push   $0x804214
  803756:	e8 93 fe ff ff       	call   8035ee <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80375b:	ff 45 f0             	incl   -0x10(%ebp)
  80375e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803761:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803764:	0f 8c 32 ff ff ff    	jl     80369c <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80376a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803771:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803778:	eb 26                	jmp    8037a0 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80377a:	a1 20 50 80 00       	mov    0x805020,%eax
  80377f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803785:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803788:	89 d0                	mov    %edx,%eax
  80378a:	01 c0                	add    %eax,%eax
  80378c:	01 d0                	add    %edx,%eax
  80378e:	c1 e0 03             	shl    $0x3,%eax
  803791:	01 c8                	add    %ecx,%eax
  803793:	8a 40 04             	mov    0x4(%eax),%al
  803796:	3c 01                	cmp    $0x1,%al
  803798:	75 03                	jne    80379d <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80379a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80379d:	ff 45 e0             	incl   -0x20(%ebp)
  8037a0:	a1 20 50 80 00       	mov    0x805020,%eax
  8037a5:	8b 50 74             	mov    0x74(%eax),%edx
  8037a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037ab:	39 c2                	cmp    %eax,%edx
  8037ad:	77 cb                	ja     80377a <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8037af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b2:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8037b5:	74 14                	je     8037cb <CheckWSWithoutLastIndex+0x16b>
		panic(
  8037b7:	83 ec 04             	sub    $0x4,%esp
  8037ba:	68 74 42 80 00       	push   $0x804274
  8037bf:	6a 44                	push   $0x44
  8037c1:	68 14 42 80 00       	push   $0x804214
  8037c6:	e8 23 fe ff ff       	call   8035ee <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8037cb:	90                   	nop
  8037cc:	c9                   	leave  
  8037cd:	c3                   	ret    
  8037ce:	66 90                	xchg   %ax,%ax

008037d0 <__udivdi3>:
  8037d0:	55                   	push   %ebp
  8037d1:	57                   	push   %edi
  8037d2:	56                   	push   %esi
  8037d3:	53                   	push   %ebx
  8037d4:	83 ec 1c             	sub    $0x1c,%esp
  8037d7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8037db:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8037df:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8037e3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8037e7:	89 ca                	mov    %ecx,%edx
  8037e9:	89 f8                	mov    %edi,%eax
  8037eb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8037ef:	85 f6                	test   %esi,%esi
  8037f1:	75 2d                	jne    803820 <__udivdi3+0x50>
  8037f3:	39 cf                	cmp    %ecx,%edi
  8037f5:	77 65                	ja     80385c <__udivdi3+0x8c>
  8037f7:	89 fd                	mov    %edi,%ebp
  8037f9:	85 ff                	test   %edi,%edi
  8037fb:	75 0b                	jne    803808 <__udivdi3+0x38>
  8037fd:	b8 01 00 00 00       	mov    $0x1,%eax
  803802:	31 d2                	xor    %edx,%edx
  803804:	f7 f7                	div    %edi
  803806:	89 c5                	mov    %eax,%ebp
  803808:	31 d2                	xor    %edx,%edx
  80380a:	89 c8                	mov    %ecx,%eax
  80380c:	f7 f5                	div    %ebp
  80380e:	89 c1                	mov    %eax,%ecx
  803810:	89 d8                	mov    %ebx,%eax
  803812:	f7 f5                	div    %ebp
  803814:	89 cf                	mov    %ecx,%edi
  803816:	89 fa                	mov    %edi,%edx
  803818:	83 c4 1c             	add    $0x1c,%esp
  80381b:	5b                   	pop    %ebx
  80381c:	5e                   	pop    %esi
  80381d:	5f                   	pop    %edi
  80381e:	5d                   	pop    %ebp
  80381f:	c3                   	ret    
  803820:	39 ce                	cmp    %ecx,%esi
  803822:	77 28                	ja     80384c <__udivdi3+0x7c>
  803824:	0f bd fe             	bsr    %esi,%edi
  803827:	83 f7 1f             	xor    $0x1f,%edi
  80382a:	75 40                	jne    80386c <__udivdi3+0x9c>
  80382c:	39 ce                	cmp    %ecx,%esi
  80382e:	72 0a                	jb     80383a <__udivdi3+0x6a>
  803830:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803834:	0f 87 9e 00 00 00    	ja     8038d8 <__udivdi3+0x108>
  80383a:	b8 01 00 00 00       	mov    $0x1,%eax
  80383f:	89 fa                	mov    %edi,%edx
  803841:	83 c4 1c             	add    $0x1c,%esp
  803844:	5b                   	pop    %ebx
  803845:	5e                   	pop    %esi
  803846:	5f                   	pop    %edi
  803847:	5d                   	pop    %ebp
  803848:	c3                   	ret    
  803849:	8d 76 00             	lea    0x0(%esi),%esi
  80384c:	31 ff                	xor    %edi,%edi
  80384e:	31 c0                	xor    %eax,%eax
  803850:	89 fa                	mov    %edi,%edx
  803852:	83 c4 1c             	add    $0x1c,%esp
  803855:	5b                   	pop    %ebx
  803856:	5e                   	pop    %esi
  803857:	5f                   	pop    %edi
  803858:	5d                   	pop    %ebp
  803859:	c3                   	ret    
  80385a:	66 90                	xchg   %ax,%ax
  80385c:	89 d8                	mov    %ebx,%eax
  80385e:	f7 f7                	div    %edi
  803860:	31 ff                	xor    %edi,%edi
  803862:	89 fa                	mov    %edi,%edx
  803864:	83 c4 1c             	add    $0x1c,%esp
  803867:	5b                   	pop    %ebx
  803868:	5e                   	pop    %esi
  803869:	5f                   	pop    %edi
  80386a:	5d                   	pop    %ebp
  80386b:	c3                   	ret    
  80386c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803871:	89 eb                	mov    %ebp,%ebx
  803873:	29 fb                	sub    %edi,%ebx
  803875:	89 f9                	mov    %edi,%ecx
  803877:	d3 e6                	shl    %cl,%esi
  803879:	89 c5                	mov    %eax,%ebp
  80387b:	88 d9                	mov    %bl,%cl
  80387d:	d3 ed                	shr    %cl,%ebp
  80387f:	89 e9                	mov    %ebp,%ecx
  803881:	09 f1                	or     %esi,%ecx
  803883:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803887:	89 f9                	mov    %edi,%ecx
  803889:	d3 e0                	shl    %cl,%eax
  80388b:	89 c5                	mov    %eax,%ebp
  80388d:	89 d6                	mov    %edx,%esi
  80388f:	88 d9                	mov    %bl,%cl
  803891:	d3 ee                	shr    %cl,%esi
  803893:	89 f9                	mov    %edi,%ecx
  803895:	d3 e2                	shl    %cl,%edx
  803897:	8b 44 24 08          	mov    0x8(%esp),%eax
  80389b:	88 d9                	mov    %bl,%cl
  80389d:	d3 e8                	shr    %cl,%eax
  80389f:	09 c2                	or     %eax,%edx
  8038a1:	89 d0                	mov    %edx,%eax
  8038a3:	89 f2                	mov    %esi,%edx
  8038a5:	f7 74 24 0c          	divl   0xc(%esp)
  8038a9:	89 d6                	mov    %edx,%esi
  8038ab:	89 c3                	mov    %eax,%ebx
  8038ad:	f7 e5                	mul    %ebp
  8038af:	39 d6                	cmp    %edx,%esi
  8038b1:	72 19                	jb     8038cc <__udivdi3+0xfc>
  8038b3:	74 0b                	je     8038c0 <__udivdi3+0xf0>
  8038b5:	89 d8                	mov    %ebx,%eax
  8038b7:	31 ff                	xor    %edi,%edi
  8038b9:	e9 58 ff ff ff       	jmp    803816 <__udivdi3+0x46>
  8038be:	66 90                	xchg   %ax,%ax
  8038c0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8038c4:	89 f9                	mov    %edi,%ecx
  8038c6:	d3 e2                	shl    %cl,%edx
  8038c8:	39 c2                	cmp    %eax,%edx
  8038ca:	73 e9                	jae    8038b5 <__udivdi3+0xe5>
  8038cc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8038cf:	31 ff                	xor    %edi,%edi
  8038d1:	e9 40 ff ff ff       	jmp    803816 <__udivdi3+0x46>
  8038d6:	66 90                	xchg   %ax,%ax
  8038d8:	31 c0                	xor    %eax,%eax
  8038da:	e9 37 ff ff ff       	jmp    803816 <__udivdi3+0x46>
  8038df:	90                   	nop

008038e0 <__umoddi3>:
  8038e0:	55                   	push   %ebp
  8038e1:	57                   	push   %edi
  8038e2:	56                   	push   %esi
  8038e3:	53                   	push   %ebx
  8038e4:	83 ec 1c             	sub    $0x1c,%esp
  8038e7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8038eb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8038ef:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8038f3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8038f7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8038fb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8038ff:	89 f3                	mov    %esi,%ebx
  803901:	89 fa                	mov    %edi,%edx
  803903:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803907:	89 34 24             	mov    %esi,(%esp)
  80390a:	85 c0                	test   %eax,%eax
  80390c:	75 1a                	jne    803928 <__umoddi3+0x48>
  80390e:	39 f7                	cmp    %esi,%edi
  803910:	0f 86 a2 00 00 00    	jbe    8039b8 <__umoddi3+0xd8>
  803916:	89 c8                	mov    %ecx,%eax
  803918:	89 f2                	mov    %esi,%edx
  80391a:	f7 f7                	div    %edi
  80391c:	89 d0                	mov    %edx,%eax
  80391e:	31 d2                	xor    %edx,%edx
  803920:	83 c4 1c             	add    $0x1c,%esp
  803923:	5b                   	pop    %ebx
  803924:	5e                   	pop    %esi
  803925:	5f                   	pop    %edi
  803926:	5d                   	pop    %ebp
  803927:	c3                   	ret    
  803928:	39 f0                	cmp    %esi,%eax
  80392a:	0f 87 ac 00 00 00    	ja     8039dc <__umoddi3+0xfc>
  803930:	0f bd e8             	bsr    %eax,%ebp
  803933:	83 f5 1f             	xor    $0x1f,%ebp
  803936:	0f 84 ac 00 00 00    	je     8039e8 <__umoddi3+0x108>
  80393c:	bf 20 00 00 00       	mov    $0x20,%edi
  803941:	29 ef                	sub    %ebp,%edi
  803943:	89 fe                	mov    %edi,%esi
  803945:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803949:	89 e9                	mov    %ebp,%ecx
  80394b:	d3 e0                	shl    %cl,%eax
  80394d:	89 d7                	mov    %edx,%edi
  80394f:	89 f1                	mov    %esi,%ecx
  803951:	d3 ef                	shr    %cl,%edi
  803953:	09 c7                	or     %eax,%edi
  803955:	89 e9                	mov    %ebp,%ecx
  803957:	d3 e2                	shl    %cl,%edx
  803959:	89 14 24             	mov    %edx,(%esp)
  80395c:	89 d8                	mov    %ebx,%eax
  80395e:	d3 e0                	shl    %cl,%eax
  803960:	89 c2                	mov    %eax,%edx
  803962:	8b 44 24 08          	mov    0x8(%esp),%eax
  803966:	d3 e0                	shl    %cl,%eax
  803968:	89 44 24 04          	mov    %eax,0x4(%esp)
  80396c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803970:	89 f1                	mov    %esi,%ecx
  803972:	d3 e8                	shr    %cl,%eax
  803974:	09 d0                	or     %edx,%eax
  803976:	d3 eb                	shr    %cl,%ebx
  803978:	89 da                	mov    %ebx,%edx
  80397a:	f7 f7                	div    %edi
  80397c:	89 d3                	mov    %edx,%ebx
  80397e:	f7 24 24             	mull   (%esp)
  803981:	89 c6                	mov    %eax,%esi
  803983:	89 d1                	mov    %edx,%ecx
  803985:	39 d3                	cmp    %edx,%ebx
  803987:	0f 82 87 00 00 00    	jb     803a14 <__umoddi3+0x134>
  80398d:	0f 84 91 00 00 00    	je     803a24 <__umoddi3+0x144>
  803993:	8b 54 24 04          	mov    0x4(%esp),%edx
  803997:	29 f2                	sub    %esi,%edx
  803999:	19 cb                	sbb    %ecx,%ebx
  80399b:	89 d8                	mov    %ebx,%eax
  80399d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8039a1:	d3 e0                	shl    %cl,%eax
  8039a3:	89 e9                	mov    %ebp,%ecx
  8039a5:	d3 ea                	shr    %cl,%edx
  8039a7:	09 d0                	or     %edx,%eax
  8039a9:	89 e9                	mov    %ebp,%ecx
  8039ab:	d3 eb                	shr    %cl,%ebx
  8039ad:	89 da                	mov    %ebx,%edx
  8039af:	83 c4 1c             	add    $0x1c,%esp
  8039b2:	5b                   	pop    %ebx
  8039b3:	5e                   	pop    %esi
  8039b4:	5f                   	pop    %edi
  8039b5:	5d                   	pop    %ebp
  8039b6:	c3                   	ret    
  8039b7:	90                   	nop
  8039b8:	89 fd                	mov    %edi,%ebp
  8039ba:	85 ff                	test   %edi,%edi
  8039bc:	75 0b                	jne    8039c9 <__umoddi3+0xe9>
  8039be:	b8 01 00 00 00       	mov    $0x1,%eax
  8039c3:	31 d2                	xor    %edx,%edx
  8039c5:	f7 f7                	div    %edi
  8039c7:	89 c5                	mov    %eax,%ebp
  8039c9:	89 f0                	mov    %esi,%eax
  8039cb:	31 d2                	xor    %edx,%edx
  8039cd:	f7 f5                	div    %ebp
  8039cf:	89 c8                	mov    %ecx,%eax
  8039d1:	f7 f5                	div    %ebp
  8039d3:	89 d0                	mov    %edx,%eax
  8039d5:	e9 44 ff ff ff       	jmp    80391e <__umoddi3+0x3e>
  8039da:	66 90                	xchg   %ax,%ax
  8039dc:	89 c8                	mov    %ecx,%eax
  8039de:	89 f2                	mov    %esi,%edx
  8039e0:	83 c4 1c             	add    $0x1c,%esp
  8039e3:	5b                   	pop    %ebx
  8039e4:	5e                   	pop    %esi
  8039e5:	5f                   	pop    %edi
  8039e6:	5d                   	pop    %ebp
  8039e7:	c3                   	ret    
  8039e8:	3b 04 24             	cmp    (%esp),%eax
  8039eb:	72 06                	jb     8039f3 <__umoddi3+0x113>
  8039ed:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8039f1:	77 0f                	ja     803a02 <__umoddi3+0x122>
  8039f3:	89 f2                	mov    %esi,%edx
  8039f5:	29 f9                	sub    %edi,%ecx
  8039f7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8039fb:	89 14 24             	mov    %edx,(%esp)
  8039fe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a02:	8b 44 24 04          	mov    0x4(%esp),%eax
  803a06:	8b 14 24             	mov    (%esp),%edx
  803a09:	83 c4 1c             	add    $0x1c,%esp
  803a0c:	5b                   	pop    %ebx
  803a0d:	5e                   	pop    %esi
  803a0e:	5f                   	pop    %edi
  803a0f:	5d                   	pop    %ebp
  803a10:	c3                   	ret    
  803a11:	8d 76 00             	lea    0x0(%esi),%esi
  803a14:	2b 04 24             	sub    (%esp),%eax
  803a17:	19 fa                	sbb    %edi,%edx
  803a19:	89 d1                	mov    %edx,%ecx
  803a1b:	89 c6                	mov    %eax,%esi
  803a1d:	e9 71 ff ff ff       	jmp    803993 <__umoddi3+0xb3>
  803a22:	66 90                	xchg   %ax,%ax
  803a24:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803a28:	72 ea                	jb     803a14 <__umoddi3+0x134>
  803a2a:	89 d9                	mov    %ebx,%ecx
  803a2c:	e9 62 ff ff ff       	jmp    803993 <__umoddi3+0xb3>
