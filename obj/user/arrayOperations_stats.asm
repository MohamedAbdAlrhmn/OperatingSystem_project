
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
  80003e:	e8 69 1b 00 00       	call   801bac <sys_getenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int32 parentenvID = sys_getparentenvid();
  800046:	e8 93 1b 00 00       	call   801bde <sys_getparentenvid>
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
  80005f:	68 00 39 80 00       	push   $0x803900
  800064:	ff 75 ec             	pushl  -0x14(%ebp)
  800067:	e8 d5 16 00 00       	call   801741 <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	numOfElements = sget(parentenvID,"arrSize") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 04 39 80 00       	push   $0x803904
  80007a:	ff 75 ec             	pushl  -0x14(%ebp)
  80007d:	e8 bf 16 00 00       	call   801741 <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//Get the check-finishing counter
	int *finishedCount = NULL;
  800088:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	finishedCount = sget(parentenvID,"finishedCount") ;
  80008f:	83 ec 08             	sub    $0x8,%esp
  800092:	68 0c 39 80 00       	push   $0x80390c
  800097:	ff 75 ec             	pushl  -0x14(%ebp)
  80009a:	e8 a2 16 00 00       	call   801741 <sget>
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
  8000b3:	68 1a 39 80 00       	push   $0x80391a
  8000b8:	e8 50 16 00 00       	call   80170d <smalloc>
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
  800126:	68 24 39 80 00       	push   $0x803924
  80012b:	e8 0d 06 00 00       	call   80073d <cprintf>
  800130:	83 c4 10             	add    $0x10,%esp

	/*[3] SHARE THE RESULTS & DECLARE FINISHING*/
	int *shMean, *shVar, *shMin, *shMax, *shMed;
	shMean = smalloc("mean", sizeof(int), 0) ; *shMean = mean;
  800133:	83 ec 04             	sub    $0x4,%esp
  800136:	6a 00                	push   $0x0
  800138:	6a 04                	push   $0x4
  80013a:	68 49 39 80 00       	push   $0x803949
  80013f:	e8 c9 15 00 00       	call   80170d <smalloc>
  800144:	83 c4 10             	add    $0x10,%esp
  800147:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80014a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80014d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800150:	89 10                	mov    %edx,(%eax)
	shVar = smalloc("var", sizeof(int), 0) ; *shVar = var;
  800152:	83 ec 04             	sub    $0x4,%esp
  800155:	6a 00                	push   $0x0
  800157:	6a 04                	push   $0x4
  800159:	68 4e 39 80 00       	push   $0x80394e
  80015e:	e8 aa 15 00 00       	call   80170d <smalloc>
  800163:	83 c4 10             	add    $0x10,%esp
  800166:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800169:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80016c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80016f:	89 10                	mov    %edx,(%eax)
	shMin = smalloc("min", sizeof(int), 0) ; *shMin = min;
  800171:	83 ec 04             	sub    $0x4,%esp
  800174:	6a 00                	push   $0x0
  800176:	6a 04                	push   $0x4
  800178:	68 52 39 80 00       	push   $0x803952
  80017d:	e8 8b 15 00 00       	call   80170d <smalloc>
  800182:	83 c4 10             	add    $0x10,%esp
  800185:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800188:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80018b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80018e:	89 10                	mov    %edx,(%eax)
	shMax = smalloc("max", sizeof(int), 0) ; *shMax = max;
  800190:	83 ec 04             	sub    $0x4,%esp
  800193:	6a 00                	push   $0x0
  800195:	6a 04                	push   $0x4
  800197:	68 56 39 80 00       	push   $0x803956
  80019c:	e8 6c 15 00 00       	call   80170d <smalloc>
  8001a1:	83 c4 10             	add    $0x10,%esp
  8001a4:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8001a7:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8001aa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001ad:	89 10                	mov    %edx,(%eax)
	shMed = smalloc("med", sizeof(int), 0) ; *shMed = med;
  8001af:	83 ec 04             	sub    $0x4,%esp
  8001b2:	6a 00                	push   $0x0
  8001b4:	6a 04                	push   $0x4
  8001b6:	68 5a 39 80 00       	push   $0x80395a
  8001bb:	e8 4d 15 00 00       	call   80170d <smalloc>
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
  800230:	e8 dc 19 00 00       	call   801c11 <sys_get_virtual_time>
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
  800533:	e8 8d 16 00 00       	call   801bc5 <sys_getenvindex>
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
  80059e:	e8 2f 14 00 00       	call   8019d2 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8005a3:	83 ec 0c             	sub    $0xc,%esp
  8005a6:	68 78 39 80 00       	push   $0x803978
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
  8005ce:	68 a0 39 80 00       	push   $0x8039a0
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
  8005ff:	68 c8 39 80 00       	push   $0x8039c8
  800604:	e8 34 01 00 00       	call   80073d <cprintf>
  800609:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80060c:	a1 20 50 80 00       	mov    0x805020,%eax
  800611:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800617:	83 ec 08             	sub    $0x8,%esp
  80061a:	50                   	push   %eax
  80061b:	68 20 3a 80 00       	push   $0x803a20
  800620:	e8 18 01 00 00       	call   80073d <cprintf>
  800625:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800628:	83 ec 0c             	sub    $0xc,%esp
  80062b:	68 78 39 80 00       	push   $0x803978
  800630:	e8 08 01 00 00       	call   80073d <cprintf>
  800635:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800638:	e8 af 13 00 00       	call   8019ec <sys_enable_interrupt>

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
  800650:	e8 3c 15 00 00       	call   801b91 <sys_destroy_env>
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
  800661:	e8 91 15 00 00       	call   801bf7 <sys_exit_env>
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
  8006af:	e8 70 11 00 00       	call   801824 <sys_cputs>
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
  800726:	e8 f9 10 00 00       	call   801824 <sys_cputs>
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
  800770:	e8 5d 12 00 00       	call   8019d2 <sys_disable_interrupt>
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
  800790:	e8 57 12 00 00       	call   8019ec <sys_enable_interrupt>
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
  8007da:	e8 a9 2e 00 00       	call   803688 <__udivdi3>
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
  80082a:	e8 69 2f 00 00       	call   803798 <__umoddi3>
  80082f:	83 c4 10             	add    $0x10,%esp
  800832:	05 54 3c 80 00       	add    $0x803c54,%eax
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
  800985:	8b 04 85 78 3c 80 00 	mov    0x803c78(,%eax,4),%eax
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
  800a66:	8b 34 9d c0 3a 80 00 	mov    0x803ac0(,%ebx,4),%esi
  800a6d:	85 f6                	test   %esi,%esi
  800a6f:	75 19                	jne    800a8a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a71:	53                   	push   %ebx
  800a72:	68 65 3c 80 00       	push   $0x803c65
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
  800a8b:	68 6e 3c 80 00       	push   $0x803c6e
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
  800ab8:	be 71 3c 80 00       	mov    $0x803c71,%esi
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
  8014de:	68 d0 3d 80 00       	push   $0x803dd0
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
  8015ae:	e8 b5 03 00 00       	call   801968 <sys_allocate_chunk>
  8015b3:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8015b6:	a1 20 51 80 00       	mov    0x805120,%eax
  8015bb:	83 ec 0c             	sub    $0xc,%esp
  8015be:	50                   	push   %eax
  8015bf:	e8 2a 0a 00 00       	call   801fee <initialize_MemBlocksList>
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
  8015ec:	68 f5 3d 80 00       	push   $0x803df5
  8015f1:	6a 33                	push   $0x33
  8015f3:	68 13 3e 80 00       	push   $0x803e13
  8015f8:	e8 aa 1e 00 00       	call   8034a7 <_panic>
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
  80166b:	68 20 3e 80 00       	push   $0x803e20
  801670:	6a 34                	push   $0x34
  801672:	68 13 3e 80 00       	push   $0x803e13
  801677:	e8 2b 1e 00 00       	call   8034a7 <_panic>
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
  8016c8:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016cb:	e8 f7 fd ff ff       	call   8014c7 <InitializeUHeap>
	if (size == 0) return NULL ;
  8016d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016d4:	75 07                	jne    8016dd <malloc+0x18>
  8016d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8016db:	eb 14                	jmp    8016f1 <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8016dd:	83 ec 04             	sub    $0x4,%esp
  8016e0:	68 44 3e 80 00       	push   $0x803e44
  8016e5:	6a 46                	push   $0x46
  8016e7:	68 13 3e 80 00       	push   $0x803e13
  8016ec:	e8 b6 1d 00 00       	call   8034a7 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8016f1:	c9                   	leave  
  8016f2:	c3                   	ret    

008016f3 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8016f3:	55                   	push   %ebp
  8016f4:	89 e5                	mov    %esp,%ebp
  8016f6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  8016f9:	83 ec 04             	sub    $0x4,%esp
  8016fc:	68 6c 3e 80 00       	push   $0x803e6c
  801701:	6a 61                	push   $0x61
  801703:	68 13 3e 80 00       	push   $0x803e13
  801708:	e8 9a 1d 00 00       	call   8034a7 <_panic>

0080170d <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80170d:	55                   	push   %ebp
  80170e:	89 e5                	mov    %esp,%ebp
  801710:	83 ec 18             	sub    $0x18,%esp
  801713:	8b 45 10             	mov    0x10(%ebp),%eax
  801716:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801719:	e8 a9 fd ff ff       	call   8014c7 <InitializeUHeap>
	if (size == 0) return NULL ;
  80171e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801722:	75 07                	jne    80172b <smalloc+0x1e>
  801724:	b8 00 00 00 00       	mov    $0x0,%eax
  801729:	eb 14                	jmp    80173f <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  80172b:	83 ec 04             	sub    $0x4,%esp
  80172e:	68 90 3e 80 00       	push   $0x803e90
  801733:	6a 76                	push   $0x76
  801735:	68 13 3e 80 00       	push   $0x803e13
  80173a:	e8 68 1d 00 00       	call   8034a7 <_panic>

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80173f:	c9                   	leave  
  801740:	c3                   	ret    

00801741 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801741:	55                   	push   %ebp
  801742:	89 e5                	mov    %esp,%ebp
  801744:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801747:	e8 7b fd ff ff       	call   8014c7 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  80174c:	83 ec 04             	sub    $0x4,%esp
  80174f:	68 b8 3e 80 00       	push   $0x803eb8
  801754:	68 93 00 00 00       	push   $0x93
  801759:	68 13 3e 80 00       	push   $0x803e13
  80175e:	e8 44 1d 00 00       	call   8034a7 <_panic>

00801763 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801763:	55                   	push   %ebp
  801764:	89 e5                	mov    %esp,%ebp
  801766:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801769:	e8 59 fd ff ff       	call   8014c7 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80176e:	83 ec 04             	sub    $0x4,%esp
  801771:	68 dc 3e 80 00       	push   $0x803edc
  801776:	68 c5 00 00 00       	push   $0xc5
  80177b:	68 13 3e 80 00       	push   $0x803e13
  801780:	e8 22 1d 00 00       	call   8034a7 <_panic>

00801785 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801785:	55                   	push   %ebp
  801786:	89 e5                	mov    %esp,%ebp
  801788:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80178b:	83 ec 04             	sub    $0x4,%esp
  80178e:	68 04 3f 80 00       	push   $0x803f04
  801793:	68 d9 00 00 00       	push   $0xd9
  801798:	68 13 3e 80 00       	push   $0x803e13
  80179d:	e8 05 1d 00 00       	call   8034a7 <_panic>

008017a2 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8017a2:	55                   	push   %ebp
  8017a3:	89 e5                	mov    %esp,%ebp
  8017a5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017a8:	83 ec 04             	sub    $0x4,%esp
  8017ab:	68 28 3f 80 00       	push   $0x803f28
  8017b0:	68 e4 00 00 00       	push   $0xe4
  8017b5:	68 13 3e 80 00       	push   $0x803e13
  8017ba:	e8 e8 1c 00 00       	call   8034a7 <_panic>

008017bf <shrink>:

}
void shrink(uint32 newSize)
{
  8017bf:	55                   	push   %ebp
  8017c0:	89 e5                	mov    %esp,%ebp
  8017c2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017c5:	83 ec 04             	sub    $0x4,%esp
  8017c8:	68 28 3f 80 00       	push   $0x803f28
  8017cd:	68 e9 00 00 00       	push   $0xe9
  8017d2:	68 13 3e 80 00       	push   $0x803e13
  8017d7:	e8 cb 1c 00 00       	call   8034a7 <_panic>

008017dc <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017dc:	55                   	push   %ebp
  8017dd:	89 e5                	mov    %esp,%ebp
  8017df:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017e2:	83 ec 04             	sub    $0x4,%esp
  8017e5:	68 28 3f 80 00       	push   $0x803f28
  8017ea:	68 ee 00 00 00       	push   $0xee
  8017ef:	68 13 3e 80 00       	push   $0x803e13
  8017f4:	e8 ae 1c 00 00       	call   8034a7 <_panic>

008017f9 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017f9:	55                   	push   %ebp
  8017fa:	89 e5                	mov    %esp,%ebp
  8017fc:	57                   	push   %edi
  8017fd:	56                   	push   %esi
  8017fe:	53                   	push   %ebx
  8017ff:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801802:	8b 45 08             	mov    0x8(%ebp),%eax
  801805:	8b 55 0c             	mov    0xc(%ebp),%edx
  801808:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80180b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80180e:	8b 7d 18             	mov    0x18(%ebp),%edi
  801811:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801814:	cd 30                	int    $0x30
  801816:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801819:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80181c:	83 c4 10             	add    $0x10,%esp
  80181f:	5b                   	pop    %ebx
  801820:	5e                   	pop    %esi
  801821:	5f                   	pop    %edi
  801822:	5d                   	pop    %ebp
  801823:	c3                   	ret    

00801824 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801824:	55                   	push   %ebp
  801825:	89 e5                	mov    %esp,%ebp
  801827:	83 ec 04             	sub    $0x4,%esp
  80182a:	8b 45 10             	mov    0x10(%ebp),%eax
  80182d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801830:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801834:	8b 45 08             	mov    0x8(%ebp),%eax
  801837:	6a 00                	push   $0x0
  801839:	6a 00                	push   $0x0
  80183b:	52                   	push   %edx
  80183c:	ff 75 0c             	pushl  0xc(%ebp)
  80183f:	50                   	push   %eax
  801840:	6a 00                	push   $0x0
  801842:	e8 b2 ff ff ff       	call   8017f9 <syscall>
  801847:	83 c4 18             	add    $0x18,%esp
}
  80184a:	90                   	nop
  80184b:	c9                   	leave  
  80184c:	c3                   	ret    

0080184d <sys_cgetc>:

int
sys_cgetc(void)
{
  80184d:	55                   	push   %ebp
  80184e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801850:	6a 00                	push   $0x0
  801852:	6a 00                	push   $0x0
  801854:	6a 00                	push   $0x0
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	6a 01                	push   $0x1
  80185c:	e8 98 ff ff ff       	call   8017f9 <syscall>
  801861:	83 c4 18             	add    $0x18,%esp
}
  801864:	c9                   	leave  
  801865:	c3                   	ret    

00801866 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801866:	55                   	push   %ebp
  801867:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801869:	8b 55 0c             	mov    0xc(%ebp),%edx
  80186c:	8b 45 08             	mov    0x8(%ebp),%eax
  80186f:	6a 00                	push   $0x0
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	52                   	push   %edx
  801876:	50                   	push   %eax
  801877:	6a 05                	push   $0x5
  801879:	e8 7b ff ff ff       	call   8017f9 <syscall>
  80187e:	83 c4 18             	add    $0x18,%esp
}
  801881:	c9                   	leave  
  801882:	c3                   	ret    

00801883 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801883:	55                   	push   %ebp
  801884:	89 e5                	mov    %esp,%ebp
  801886:	56                   	push   %esi
  801887:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801888:	8b 75 18             	mov    0x18(%ebp),%esi
  80188b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80188e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801891:	8b 55 0c             	mov    0xc(%ebp),%edx
  801894:	8b 45 08             	mov    0x8(%ebp),%eax
  801897:	56                   	push   %esi
  801898:	53                   	push   %ebx
  801899:	51                   	push   %ecx
  80189a:	52                   	push   %edx
  80189b:	50                   	push   %eax
  80189c:	6a 06                	push   $0x6
  80189e:	e8 56 ff ff ff       	call   8017f9 <syscall>
  8018a3:	83 c4 18             	add    $0x18,%esp
}
  8018a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018a9:	5b                   	pop    %ebx
  8018aa:	5e                   	pop    %esi
  8018ab:	5d                   	pop    %ebp
  8018ac:	c3                   	ret    

008018ad <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018ad:	55                   	push   %ebp
  8018ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 00                	push   $0x0
  8018bc:	52                   	push   %edx
  8018bd:	50                   	push   %eax
  8018be:	6a 07                	push   $0x7
  8018c0:	e8 34 ff ff ff       	call   8017f9 <syscall>
  8018c5:	83 c4 18             	add    $0x18,%esp
}
  8018c8:	c9                   	leave  
  8018c9:	c3                   	ret    

008018ca <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018ca:	55                   	push   %ebp
  8018cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	ff 75 0c             	pushl  0xc(%ebp)
  8018d6:	ff 75 08             	pushl  0x8(%ebp)
  8018d9:	6a 08                	push   $0x8
  8018db:	e8 19 ff ff ff       	call   8017f9 <syscall>
  8018e0:	83 c4 18             	add    $0x18,%esp
}
  8018e3:	c9                   	leave  
  8018e4:	c3                   	ret    

008018e5 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018e5:	55                   	push   %ebp
  8018e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018e8:	6a 00                	push   $0x0
  8018ea:	6a 00                	push   $0x0
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 09                	push   $0x9
  8018f4:	e8 00 ff ff ff       	call   8017f9 <syscall>
  8018f9:	83 c4 18             	add    $0x18,%esp
}
  8018fc:	c9                   	leave  
  8018fd:	c3                   	ret    

008018fe <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018fe:	55                   	push   %ebp
  8018ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801901:	6a 00                	push   $0x0
  801903:	6a 00                	push   $0x0
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	6a 0a                	push   $0xa
  80190d:	e8 e7 fe ff ff       	call   8017f9 <syscall>
  801912:	83 c4 18             	add    $0x18,%esp
}
  801915:	c9                   	leave  
  801916:	c3                   	ret    

00801917 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801917:	55                   	push   %ebp
  801918:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	6a 0b                	push   $0xb
  801926:	e8 ce fe ff ff       	call   8017f9 <syscall>
  80192b:	83 c4 18             	add    $0x18,%esp
}
  80192e:	c9                   	leave  
  80192f:	c3                   	ret    

00801930 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801930:	55                   	push   %ebp
  801931:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	ff 75 0c             	pushl  0xc(%ebp)
  80193c:	ff 75 08             	pushl  0x8(%ebp)
  80193f:	6a 0f                	push   $0xf
  801941:	e8 b3 fe ff ff       	call   8017f9 <syscall>
  801946:	83 c4 18             	add    $0x18,%esp
	return;
  801949:	90                   	nop
}
  80194a:	c9                   	leave  
  80194b:	c3                   	ret    

0080194c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80194c:	55                   	push   %ebp
  80194d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	ff 75 0c             	pushl  0xc(%ebp)
  801958:	ff 75 08             	pushl  0x8(%ebp)
  80195b:	6a 10                	push   $0x10
  80195d:	e8 97 fe ff ff       	call   8017f9 <syscall>
  801962:	83 c4 18             	add    $0x18,%esp
	return ;
  801965:	90                   	nop
}
  801966:	c9                   	leave  
  801967:	c3                   	ret    

00801968 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801968:	55                   	push   %ebp
  801969:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	ff 75 10             	pushl  0x10(%ebp)
  801972:	ff 75 0c             	pushl  0xc(%ebp)
  801975:	ff 75 08             	pushl  0x8(%ebp)
  801978:	6a 11                	push   $0x11
  80197a:	e8 7a fe ff ff       	call   8017f9 <syscall>
  80197f:	83 c4 18             	add    $0x18,%esp
	return ;
  801982:	90                   	nop
}
  801983:	c9                   	leave  
  801984:	c3                   	ret    

00801985 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801985:	55                   	push   %ebp
  801986:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	6a 0c                	push   $0xc
  801994:	e8 60 fe ff ff       	call   8017f9 <syscall>
  801999:	83 c4 18             	add    $0x18,%esp
}
  80199c:	c9                   	leave  
  80199d:	c3                   	ret    

0080199e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80199e:	55                   	push   %ebp
  80199f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	ff 75 08             	pushl  0x8(%ebp)
  8019ac:	6a 0d                	push   $0xd
  8019ae:	e8 46 fe ff ff       	call   8017f9 <syscall>
  8019b3:	83 c4 18             	add    $0x18,%esp
}
  8019b6:	c9                   	leave  
  8019b7:	c3                   	ret    

008019b8 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019b8:	55                   	push   %ebp
  8019b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 0e                	push   $0xe
  8019c7:	e8 2d fe ff ff       	call   8017f9 <syscall>
  8019cc:	83 c4 18             	add    $0x18,%esp
}
  8019cf:	90                   	nop
  8019d0:	c9                   	leave  
  8019d1:	c3                   	ret    

008019d2 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 13                	push   $0x13
  8019e1:	e8 13 fe ff ff       	call   8017f9 <syscall>
  8019e6:	83 c4 18             	add    $0x18,%esp
}
  8019e9:	90                   	nop
  8019ea:	c9                   	leave  
  8019eb:	c3                   	ret    

008019ec <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8019ec:	55                   	push   %ebp
  8019ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 14                	push   $0x14
  8019fb:	e8 f9 fd ff ff       	call   8017f9 <syscall>
  801a00:	83 c4 18             	add    $0x18,%esp
}
  801a03:	90                   	nop
  801a04:	c9                   	leave  
  801a05:	c3                   	ret    

00801a06 <sys_cputc>:


void
sys_cputc(const char c)
{
  801a06:	55                   	push   %ebp
  801a07:	89 e5                	mov    %esp,%ebp
  801a09:	83 ec 04             	sub    $0x4,%esp
  801a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a12:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	50                   	push   %eax
  801a1f:	6a 15                	push   $0x15
  801a21:	e8 d3 fd ff ff       	call   8017f9 <syscall>
  801a26:	83 c4 18             	add    $0x18,%esp
}
  801a29:	90                   	nop
  801a2a:	c9                   	leave  
  801a2b:	c3                   	ret    

00801a2c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 16                	push   $0x16
  801a3b:	e8 b9 fd ff ff       	call   8017f9 <syscall>
  801a40:	83 c4 18             	add    $0x18,%esp
}
  801a43:	90                   	nop
  801a44:	c9                   	leave  
  801a45:	c3                   	ret    

00801a46 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a46:	55                   	push   %ebp
  801a47:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a49:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	ff 75 0c             	pushl  0xc(%ebp)
  801a55:	50                   	push   %eax
  801a56:	6a 17                	push   $0x17
  801a58:	e8 9c fd ff ff       	call   8017f9 <syscall>
  801a5d:	83 c4 18             	add    $0x18,%esp
}
  801a60:	c9                   	leave  
  801a61:	c3                   	ret    

00801a62 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a62:	55                   	push   %ebp
  801a63:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a65:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a68:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	52                   	push   %edx
  801a72:	50                   	push   %eax
  801a73:	6a 1a                	push   $0x1a
  801a75:	e8 7f fd ff ff       	call   8017f9 <syscall>
  801a7a:	83 c4 18             	add    $0x18,%esp
}
  801a7d:	c9                   	leave  
  801a7e:	c3                   	ret    

00801a7f <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a7f:	55                   	push   %ebp
  801a80:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a82:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a85:	8b 45 08             	mov    0x8(%ebp),%eax
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	52                   	push   %edx
  801a8f:	50                   	push   %eax
  801a90:	6a 18                	push   $0x18
  801a92:	e8 62 fd ff ff       	call   8017f9 <syscall>
  801a97:	83 c4 18             	add    $0x18,%esp
}
  801a9a:	90                   	nop
  801a9b:	c9                   	leave  
  801a9c:	c3                   	ret    

00801a9d <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a9d:	55                   	push   %ebp
  801a9e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801aa0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	52                   	push   %edx
  801aad:	50                   	push   %eax
  801aae:	6a 19                	push   $0x19
  801ab0:	e8 44 fd ff ff       	call   8017f9 <syscall>
  801ab5:	83 c4 18             	add    $0x18,%esp
}
  801ab8:	90                   	nop
  801ab9:	c9                   	leave  
  801aba:	c3                   	ret    

00801abb <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801abb:	55                   	push   %ebp
  801abc:	89 e5                	mov    %esp,%ebp
  801abe:	83 ec 04             	sub    $0x4,%esp
  801ac1:	8b 45 10             	mov    0x10(%ebp),%eax
  801ac4:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ac7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801aca:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ace:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad1:	6a 00                	push   $0x0
  801ad3:	51                   	push   %ecx
  801ad4:	52                   	push   %edx
  801ad5:	ff 75 0c             	pushl  0xc(%ebp)
  801ad8:	50                   	push   %eax
  801ad9:	6a 1b                	push   $0x1b
  801adb:	e8 19 fd ff ff       	call   8017f9 <syscall>
  801ae0:	83 c4 18             	add    $0x18,%esp
}
  801ae3:	c9                   	leave  
  801ae4:	c3                   	ret    

00801ae5 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ae5:	55                   	push   %ebp
  801ae6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ae8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	52                   	push   %edx
  801af5:	50                   	push   %eax
  801af6:	6a 1c                	push   $0x1c
  801af8:	e8 fc fc ff ff       	call   8017f9 <syscall>
  801afd:	83 c4 18             	add    $0x18,%esp
}
  801b00:	c9                   	leave  
  801b01:	c3                   	ret    

00801b02 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b02:	55                   	push   %ebp
  801b03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b05:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b08:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	51                   	push   %ecx
  801b13:	52                   	push   %edx
  801b14:	50                   	push   %eax
  801b15:	6a 1d                	push   $0x1d
  801b17:	e8 dd fc ff ff       	call   8017f9 <syscall>
  801b1c:	83 c4 18             	add    $0x18,%esp
}
  801b1f:	c9                   	leave  
  801b20:	c3                   	ret    

00801b21 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b21:	55                   	push   %ebp
  801b22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b24:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b27:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	52                   	push   %edx
  801b31:	50                   	push   %eax
  801b32:	6a 1e                	push   $0x1e
  801b34:	e8 c0 fc ff ff       	call   8017f9 <syscall>
  801b39:	83 c4 18             	add    $0x18,%esp
}
  801b3c:	c9                   	leave  
  801b3d:	c3                   	ret    

00801b3e <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b3e:	55                   	push   %ebp
  801b3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 1f                	push   $0x1f
  801b4d:	e8 a7 fc ff ff       	call   8017f9 <syscall>
  801b52:	83 c4 18             	add    $0x18,%esp
}
  801b55:	c9                   	leave  
  801b56:	c3                   	ret    

00801b57 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b57:	55                   	push   %ebp
  801b58:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5d:	6a 00                	push   $0x0
  801b5f:	ff 75 14             	pushl  0x14(%ebp)
  801b62:	ff 75 10             	pushl  0x10(%ebp)
  801b65:	ff 75 0c             	pushl  0xc(%ebp)
  801b68:	50                   	push   %eax
  801b69:	6a 20                	push   $0x20
  801b6b:	e8 89 fc ff ff       	call   8017f9 <syscall>
  801b70:	83 c4 18             	add    $0x18,%esp
}
  801b73:	c9                   	leave  
  801b74:	c3                   	ret    

00801b75 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b75:	55                   	push   %ebp
  801b76:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b78:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	50                   	push   %eax
  801b84:	6a 21                	push   $0x21
  801b86:	e8 6e fc ff ff       	call   8017f9 <syscall>
  801b8b:	83 c4 18             	add    $0x18,%esp
}
  801b8e:	90                   	nop
  801b8f:	c9                   	leave  
  801b90:	c3                   	ret    

00801b91 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b91:	55                   	push   %ebp
  801b92:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b94:	8b 45 08             	mov    0x8(%ebp),%eax
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	50                   	push   %eax
  801ba0:	6a 22                	push   $0x22
  801ba2:	e8 52 fc ff ff       	call   8017f9 <syscall>
  801ba7:	83 c4 18             	add    $0x18,%esp
}
  801baa:	c9                   	leave  
  801bab:	c3                   	ret    

00801bac <sys_getenvid>:

int32 sys_getenvid(void)
{
  801bac:	55                   	push   %ebp
  801bad:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 02                	push   $0x2
  801bbb:	e8 39 fc ff ff       	call   8017f9 <syscall>
  801bc0:	83 c4 18             	add    $0x18,%esp
}
  801bc3:	c9                   	leave  
  801bc4:	c3                   	ret    

00801bc5 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801bc5:	55                   	push   %ebp
  801bc6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 03                	push   $0x3
  801bd4:	e8 20 fc ff ff       	call   8017f9 <syscall>
  801bd9:	83 c4 18             	add    $0x18,%esp
}
  801bdc:	c9                   	leave  
  801bdd:	c3                   	ret    

00801bde <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bde:	55                   	push   %ebp
  801bdf:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 04                	push   $0x4
  801bed:	e8 07 fc ff ff       	call   8017f9 <syscall>
  801bf2:	83 c4 18             	add    $0x18,%esp
}
  801bf5:	c9                   	leave  
  801bf6:	c3                   	ret    

00801bf7 <sys_exit_env>:


void sys_exit_env(void)
{
  801bf7:	55                   	push   %ebp
  801bf8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 23                	push   $0x23
  801c06:	e8 ee fb ff ff       	call   8017f9 <syscall>
  801c0b:	83 c4 18             	add    $0x18,%esp
}
  801c0e:	90                   	nop
  801c0f:	c9                   	leave  
  801c10:	c3                   	ret    

00801c11 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c11:	55                   	push   %ebp
  801c12:	89 e5                	mov    %esp,%ebp
  801c14:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c17:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c1a:	8d 50 04             	lea    0x4(%eax),%edx
  801c1d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	52                   	push   %edx
  801c27:	50                   	push   %eax
  801c28:	6a 24                	push   $0x24
  801c2a:	e8 ca fb ff ff       	call   8017f9 <syscall>
  801c2f:	83 c4 18             	add    $0x18,%esp
	return result;
  801c32:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c35:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c38:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c3b:	89 01                	mov    %eax,(%ecx)
  801c3d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c40:	8b 45 08             	mov    0x8(%ebp),%eax
  801c43:	c9                   	leave  
  801c44:	c2 04 00             	ret    $0x4

00801c47 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c47:	55                   	push   %ebp
  801c48:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	ff 75 10             	pushl  0x10(%ebp)
  801c51:	ff 75 0c             	pushl  0xc(%ebp)
  801c54:	ff 75 08             	pushl  0x8(%ebp)
  801c57:	6a 12                	push   $0x12
  801c59:	e8 9b fb ff ff       	call   8017f9 <syscall>
  801c5e:	83 c4 18             	add    $0x18,%esp
	return ;
  801c61:	90                   	nop
}
  801c62:	c9                   	leave  
  801c63:	c3                   	ret    

00801c64 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c64:	55                   	push   %ebp
  801c65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 25                	push   $0x25
  801c73:	e8 81 fb ff ff       	call   8017f9 <syscall>
  801c78:	83 c4 18             	add    $0x18,%esp
}
  801c7b:	c9                   	leave  
  801c7c:	c3                   	ret    

00801c7d <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c7d:	55                   	push   %ebp
  801c7e:	89 e5                	mov    %esp,%ebp
  801c80:	83 ec 04             	sub    $0x4,%esp
  801c83:	8b 45 08             	mov    0x8(%ebp),%eax
  801c86:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c89:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	50                   	push   %eax
  801c96:	6a 26                	push   $0x26
  801c98:	e8 5c fb ff ff       	call   8017f9 <syscall>
  801c9d:	83 c4 18             	add    $0x18,%esp
	return ;
  801ca0:	90                   	nop
}
  801ca1:	c9                   	leave  
  801ca2:	c3                   	ret    

00801ca3 <rsttst>:
void rsttst()
{
  801ca3:	55                   	push   %ebp
  801ca4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 28                	push   $0x28
  801cb2:	e8 42 fb ff ff       	call   8017f9 <syscall>
  801cb7:	83 c4 18             	add    $0x18,%esp
	return ;
  801cba:	90                   	nop
}
  801cbb:	c9                   	leave  
  801cbc:	c3                   	ret    

00801cbd <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801cbd:	55                   	push   %ebp
  801cbe:	89 e5                	mov    %esp,%ebp
  801cc0:	83 ec 04             	sub    $0x4,%esp
  801cc3:	8b 45 14             	mov    0x14(%ebp),%eax
  801cc6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801cc9:	8b 55 18             	mov    0x18(%ebp),%edx
  801ccc:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cd0:	52                   	push   %edx
  801cd1:	50                   	push   %eax
  801cd2:	ff 75 10             	pushl  0x10(%ebp)
  801cd5:	ff 75 0c             	pushl  0xc(%ebp)
  801cd8:	ff 75 08             	pushl  0x8(%ebp)
  801cdb:	6a 27                	push   $0x27
  801cdd:	e8 17 fb ff ff       	call   8017f9 <syscall>
  801ce2:	83 c4 18             	add    $0x18,%esp
	return ;
  801ce5:	90                   	nop
}
  801ce6:	c9                   	leave  
  801ce7:	c3                   	ret    

00801ce8 <chktst>:
void chktst(uint32 n)
{
  801ce8:	55                   	push   %ebp
  801ce9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 00                	push   $0x0
  801cf3:	ff 75 08             	pushl  0x8(%ebp)
  801cf6:	6a 29                	push   $0x29
  801cf8:	e8 fc fa ff ff       	call   8017f9 <syscall>
  801cfd:	83 c4 18             	add    $0x18,%esp
	return ;
  801d00:	90                   	nop
}
  801d01:	c9                   	leave  
  801d02:	c3                   	ret    

00801d03 <inctst>:

void inctst()
{
  801d03:	55                   	push   %ebp
  801d04:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d06:	6a 00                	push   $0x0
  801d08:	6a 00                	push   $0x0
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 2a                	push   $0x2a
  801d12:	e8 e2 fa ff ff       	call   8017f9 <syscall>
  801d17:	83 c4 18             	add    $0x18,%esp
	return ;
  801d1a:	90                   	nop
}
  801d1b:	c9                   	leave  
  801d1c:	c3                   	ret    

00801d1d <gettst>:
uint32 gettst()
{
  801d1d:	55                   	push   %ebp
  801d1e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 2b                	push   $0x2b
  801d2c:	e8 c8 fa ff ff       	call   8017f9 <syscall>
  801d31:	83 c4 18             	add    $0x18,%esp
}
  801d34:	c9                   	leave  
  801d35:	c3                   	ret    

00801d36 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d36:	55                   	push   %ebp
  801d37:	89 e5                	mov    %esp,%ebp
  801d39:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	6a 2c                	push   $0x2c
  801d48:	e8 ac fa ff ff       	call   8017f9 <syscall>
  801d4d:	83 c4 18             	add    $0x18,%esp
  801d50:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d53:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d57:	75 07                	jne    801d60 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d59:	b8 01 00 00 00       	mov    $0x1,%eax
  801d5e:	eb 05                	jmp    801d65 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d60:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d65:	c9                   	leave  
  801d66:	c3                   	ret    

00801d67 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d67:	55                   	push   %ebp
  801d68:	89 e5                	mov    %esp,%ebp
  801d6a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	6a 2c                	push   $0x2c
  801d79:	e8 7b fa ff ff       	call   8017f9 <syscall>
  801d7e:	83 c4 18             	add    $0x18,%esp
  801d81:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d84:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d88:	75 07                	jne    801d91 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d8a:	b8 01 00 00 00       	mov    $0x1,%eax
  801d8f:	eb 05                	jmp    801d96 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d91:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d96:	c9                   	leave  
  801d97:	c3                   	ret    

00801d98 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d98:	55                   	push   %ebp
  801d99:	89 e5                	mov    %esp,%ebp
  801d9b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d9e:	6a 00                	push   $0x0
  801da0:	6a 00                	push   $0x0
  801da2:	6a 00                	push   $0x0
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	6a 2c                	push   $0x2c
  801daa:	e8 4a fa ff ff       	call   8017f9 <syscall>
  801daf:	83 c4 18             	add    $0x18,%esp
  801db2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801db5:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801db9:	75 07                	jne    801dc2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801dbb:	b8 01 00 00 00       	mov    $0x1,%eax
  801dc0:	eb 05                	jmp    801dc7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801dc2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dc7:	c9                   	leave  
  801dc8:	c3                   	ret    

00801dc9 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801dc9:	55                   	push   %ebp
  801dca:	89 e5                	mov    %esp,%ebp
  801dcc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 2c                	push   $0x2c
  801ddb:	e8 19 fa ff ff       	call   8017f9 <syscall>
  801de0:	83 c4 18             	add    $0x18,%esp
  801de3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801de6:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801dea:	75 07                	jne    801df3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801dec:	b8 01 00 00 00       	mov    $0x1,%eax
  801df1:	eb 05                	jmp    801df8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801df3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801df8:	c9                   	leave  
  801df9:	c3                   	ret    

00801dfa <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801dfa:	55                   	push   %ebp
  801dfb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 00                	push   $0x0
  801e01:	6a 00                	push   $0x0
  801e03:	6a 00                	push   $0x0
  801e05:	ff 75 08             	pushl  0x8(%ebp)
  801e08:	6a 2d                	push   $0x2d
  801e0a:	e8 ea f9 ff ff       	call   8017f9 <syscall>
  801e0f:	83 c4 18             	add    $0x18,%esp
	return ;
  801e12:	90                   	nop
}
  801e13:	c9                   	leave  
  801e14:	c3                   	ret    

00801e15 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e15:	55                   	push   %ebp
  801e16:	89 e5                	mov    %esp,%ebp
  801e18:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e19:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e1c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e22:	8b 45 08             	mov    0x8(%ebp),%eax
  801e25:	6a 00                	push   $0x0
  801e27:	53                   	push   %ebx
  801e28:	51                   	push   %ecx
  801e29:	52                   	push   %edx
  801e2a:	50                   	push   %eax
  801e2b:	6a 2e                	push   $0x2e
  801e2d:	e8 c7 f9 ff ff       	call   8017f9 <syscall>
  801e32:	83 c4 18             	add    $0x18,%esp
}
  801e35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e38:	c9                   	leave  
  801e39:	c3                   	ret    

00801e3a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e3a:	55                   	push   %ebp
  801e3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e40:	8b 45 08             	mov    0x8(%ebp),%eax
  801e43:	6a 00                	push   $0x0
  801e45:	6a 00                	push   $0x0
  801e47:	6a 00                	push   $0x0
  801e49:	52                   	push   %edx
  801e4a:	50                   	push   %eax
  801e4b:	6a 2f                	push   $0x2f
  801e4d:	e8 a7 f9 ff ff       	call   8017f9 <syscall>
  801e52:	83 c4 18             	add    $0x18,%esp
}
  801e55:	c9                   	leave  
  801e56:	c3                   	ret    

00801e57 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e57:	55                   	push   %ebp
  801e58:	89 e5                	mov    %esp,%ebp
  801e5a:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e5d:	83 ec 0c             	sub    $0xc,%esp
  801e60:	68 38 3f 80 00       	push   $0x803f38
  801e65:	e8 d3 e8 ff ff       	call   80073d <cprintf>
  801e6a:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e6d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e74:	83 ec 0c             	sub    $0xc,%esp
  801e77:	68 64 3f 80 00       	push   $0x803f64
  801e7c:	e8 bc e8 ff ff       	call   80073d <cprintf>
  801e81:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e84:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e88:	a1 38 51 80 00       	mov    0x805138,%eax
  801e8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e90:	eb 56                	jmp    801ee8 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e92:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e96:	74 1c                	je     801eb4 <print_mem_block_lists+0x5d>
  801e98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e9b:	8b 50 08             	mov    0x8(%eax),%edx
  801e9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ea1:	8b 48 08             	mov    0x8(%eax),%ecx
  801ea4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ea7:	8b 40 0c             	mov    0xc(%eax),%eax
  801eaa:	01 c8                	add    %ecx,%eax
  801eac:	39 c2                	cmp    %eax,%edx
  801eae:	73 04                	jae    801eb4 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801eb0:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801eb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb7:	8b 50 08             	mov    0x8(%eax),%edx
  801eba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ebd:	8b 40 0c             	mov    0xc(%eax),%eax
  801ec0:	01 c2                	add    %eax,%edx
  801ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec5:	8b 40 08             	mov    0x8(%eax),%eax
  801ec8:	83 ec 04             	sub    $0x4,%esp
  801ecb:	52                   	push   %edx
  801ecc:	50                   	push   %eax
  801ecd:	68 79 3f 80 00       	push   $0x803f79
  801ed2:	e8 66 e8 ff ff       	call   80073d <cprintf>
  801ed7:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801eda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801edd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ee0:	a1 40 51 80 00       	mov    0x805140,%eax
  801ee5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ee8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801eec:	74 07                	je     801ef5 <print_mem_block_lists+0x9e>
  801eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef1:	8b 00                	mov    (%eax),%eax
  801ef3:	eb 05                	jmp    801efa <print_mem_block_lists+0xa3>
  801ef5:	b8 00 00 00 00       	mov    $0x0,%eax
  801efa:	a3 40 51 80 00       	mov    %eax,0x805140
  801eff:	a1 40 51 80 00       	mov    0x805140,%eax
  801f04:	85 c0                	test   %eax,%eax
  801f06:	75 8a                	jne    801e92 <print_mem_block_lists+0x3b>
  801f08:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f0c:	75 84                	jne    801e92 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f0e:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f12:	75 10                	jne    801f24 <print_mem_block_lists+0xcd>
  801f14:	83 ec 0c             	sub    $0xc,%esp
  801f17:	68 88 3f 80 00       	push   $0x803f88
  801f1c:	e8 1c e8 ff ff       	call   80073d <cprintf>
  801f21:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f24:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f2b:	83 ec 0c             	sub    $0xc,%esp
  801f2e:	68 ac 3f 80 00       	push   $0x803fac
  801f33:	e8 05 e8 ff ff       	call   80073d <cprintf>
  801f38:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f3b:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f3f:	a1 40 50 80 00       	mov    0x805040,%eax
  801f44:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f47:	eb 56                	jmp    801f9f <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f49:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f4d:	74 1c                	je     801f6b <print_mem_block_lists+0x114>
  801f4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f52:	8b 50 08             	mov    0x8(%eax),%edx
  801f55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f58:	8b 48 08             	mov    0x8(%eax),%ecx
  801f5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f5e:	8b 40 0c             	mov    0xc(%eax),%eax
  801f61:	01 c8                	add    %ecx,%eax
  801f63:	39 c2                	cmp    %eax,%edx
  801f65:	73 04                	jae    801f6b <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f67:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6e:	8b 50 08             	mov    0x8(%eax),%edx
  801f71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f74:	8b 40 0c             	mov    0xc(%eax),%eax
  801f77:	01 c2                	add    %eax,%edx
  801f79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7c:	8b 40 08             	mov    0x8(%eax),%eax
  801f7f:	83 ec 04             	sub    $0x4,%esp
  801f82:	52                   	push   %edx
  801f83:	50                   	push   %eax
  801f84:	68 79 3f 80 00       	push   $0x803f79
  801f89:	e8 af e7 ff ff       	call   80073d <cprintf>
  801f8e:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f94:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f97:	a1 48 50 80 00       	mov    0x805048,%eax
  801f9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f9f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fa3:	74 07                	je     801fac <print_mem_block_lists+0x155>
  801fa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa8:	8b 00                	mov    (%eax),%eax
  801faa:	eb 05                	jmp    801fb1 <print_mem_block_lists+0x15a>
  801fac:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb1:	a3 48 50 80 00       	mov    %eax,0x805048
  801fb6:	a1 48 50 80 00       	mov    0x805048,%eax
  801fbb:	85 c0                	test   %eax,%eax
  801fbd:	75 8a                	jne    801f49 <print_mem_block_lists+0xf2>
  801fbf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fc3:	75 84                	jne    801f49 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801fc5:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fc9:	75 10                	jne    801fdb <print_mem_block_lists+0x184>
  801fcb:	83 ec 0c             	sub    $0xc,%esp
  801fce:	68 c4 3f 80 00       	push   $0x803fc4
  801fd3:	e8 65 e7 ff ff       	call   80073d <cprintf>
  801fd8:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801fdb:	83 ec 0c             	sub    $0xc,%esp
  801fde:	68 38 3f 80 00       	push   $0x803f38
  801fe3:	e8 55 e7 ff ff       	call   80073d <cprintf>
  801fe8:	83 c4 10             	add    $0x10,%esp

}
  801feb:	90                   	nop
  801fec:	c9                   	leave  
  801fed:	c3                   	ret    

00801fee <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801fee:	55                   	push   %ebp
  801fef:	89 e5                	mov    %esp,%ebp
  801ff1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801ff4:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801ffb:	00 00 00 
  801ffe:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802005:	00 00 00 
  802008:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80200f:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802012:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802019:	e9 9e 00 00 00       	jmp    8020bc <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  80201e:	a1 50 50 80 00       	mov    0x805050,%eax
  802023:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802026:	c1 e2 04             	shl    $0x4,%edx
  802029:	01 d0                	add    %edx,%eax
  80202b:	85 c0                	test   %eax,%eax
  80202d:	75 14                	jne    802043 <initialize_MemBlocksList+0x55>
  80202f:	83 ec 04             	sub    $0x4,%esp
  802032:	68 ec 3f 80 00       	push   $0x803fec
  802037:	6a 46                	push   $0x46
  802039:	68 0f 40 80 00       	push   $0x80400f
  80203e:	e8 64 14 00 00       	call   8034a7 <_panic>
  802043:	a1 50 50 80 00       	mov    0x805050,%eax
  802048:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80204b:	c1 e2 04             	shl    $0x4,%edx
  80204e:	01 d0                	add    %edx,%eax
  802050:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802056:	89 10                	mov    %edx,(%eax)
  802058:	8b 00                	mov    (%eax),%eax
  80205a:	85 c0                	test   %eax,%eax
  80205c:	74 18                	je     802076 <initialize_MemBlocksList+0x88>
  80205e:	a1 48 51 80 00       	mov    0x805148,%eax
  802063:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802069:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80206c:	c1 e1 04             	shl    $0x4,%ecx
  80206f:	01 ca                	add    %ecx,%edx
  802071:	89 50 04             	mov    %edx,0x4(%eax)
  802074:	eb 12                	jmp    802088 <initialize_MemBlocksList+0x9a>
  802076:	a1 50 50 80 00       	mov    0x805050,%eax
  80207b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80207e:	c1 e2 04             	shl    $0x4,%edx
  802081:	01 d0                	add    %edx,%eax
  802083:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802088:	a1 50 50 80 00       	mov    0x805050,%eax
  80208d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802090:	c1 e2 04             	shl    $0x4,%edx
  802093:	01 d0                	add    %edx,%eax
  802095:	a3 48 51 80 00       	mov    %eax,0x805148
  80209a:	a1 50 50 80 00       	mov    0x805050,%eax
  80209f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020a2:	c1 e2 04             	shl    $0x4,%edx
  8020a5:	01 d0                	add    %edx,%eax
  8020a7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020ae:	a1 54 51 80 00       	mov    0x805154,%eax
  8020b3:	40                   	inc    %eax
  8020b4:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8020b9:	ff 45 f4             	incl   -0xc(%ebp)
  8020bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020bf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020c2:	0f 82 56 ff ff ff    	jb     80201e <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8020c8:	90                   	nop
  8020c9:	c9                   	leave  
  8020ca:	c3                   	ret    

008020cb <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8020cb:	55                   	push   %ebp
  8020cc:	89 e5                	mov    %esp,%ebp
  8020ce:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8020d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d4:	8b 00                	mov    (%eax),%eax
  8020d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020d9:	eb 19                	jmp    8020f4 <find_block+0x29>
	{
		if(va==point->sva)
  8020db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020de:	8b 40 08             	mov    0x8(%eax),%eax
  8020e1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8020e4:	75 05                	jne    8020eb <find_block+0x20>
		   return point;
  8020e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020e9:	eb 36                	jmp    802121 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8020eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ee:	8b 40 08             	mov    0x8(%eax),%eax
  8020f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020f8:	74 07                	je     802101 <find_block+0x36>
  8020fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020fd:	8b 00                	mov    (%eax),%eax
  8020ff:	eb 05                	jmp    802106 <find_block+0x3b>
  802101:	b8 00 00 00 00       	mov    $0x0,%eax
  802106:	8b 55 08             	mov    0x8(%ebp),%edx
  802109:	89 42 08             	mov    %eax,0x8(%edx)
  80210c:	8b 45 08             	mov    0x8(%ebp),%eax
  80210f:	8b 40 08             	mov    0x8(%eax),%eax
  802112:	85 c0                	test   %eax,%eax
  802114:	75 c5                	jne    8020db <find_block+0x10>
  802116:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80211a:	75 bf                	jne    8020db <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  80211c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802121:	c9                   	leave  
  802122:	c3                   	ret    

00802123 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802123:	55                   	push   %ebp
  802124:	89 e5                	mov    %esp,%ebp
  802126:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802129:	a1 40 50 80 00       	mov    0x805040,%eax
  80212e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802131:	a1 44 50 80 00       	mov    0x805044,%eax
  802136:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802139:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80213c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80213f:	74 24                	je     802165 <insert_sorted_allocList+0x42>
  802141:	8b 45 08             	mov    0x8(%ebp),%eax
  802144:	8b 50 08             	mov    0x8(%eax),%edx
  802147:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80214a:	8b 40 08             	mov    0x8(%eax),%eax
  80214d:	39 c2                	cmp    %eax,%edx
  80214f:	76 14                	jbe    802165 <insert_sorted_allocList+0x42>
  802151:	8b 45 08             	mov    0x8(%ebp),%eax
  802154:	8b 50 08             	mov    0x8(%eax),%edx
  802157:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80215a:	8b 40 08             	mov    0x8(%eax),%eax
  80215d:	39 c2                	cmp    %eax,%edx
  80215f:	0f 82 60 01 00 00    	jb     8022c5 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802165:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802169:	75 65                	jne    8021d0 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80216b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80216f:	75 14                	jne    802185 <insert_sorted_allocList+0x62>
  802171:	83 ec 04             	sub    $0x4,%esp
  802174:	68 ec 3f 80 00       	push   $0x803fec
  802179:	6a 6b                	push   $0x6b
  80217b:	68 0f 40 80 00       	push   $0x80400f
  802180:	e8 22 13 00 00       	call   8034a7 <_panic>
  802185:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80218b:	8b 45 08             	mov    0x8(%ebp),%eax
  80218e:	89 10                	mov    %edx,(%eax)
  802190:	8b 45 08             	mov    0x8(%ebp),%eax
  802193:	8b 00                	mov    (%eax),%eax
  802195:	85 c0                	test   %eax,%eax
  802197:	74 0d                	je     8021a6 <insert_sorted_allocList+0x83>
  802199:	a1 40 50 80 00       	mov    0x805040,%eax
  80219e:	8b 55 08             	mov    0x8(%ebp),%edx
  8021a1:	89 50 04             	mov    %edx,0x4(%eax)
  8021a4:	eb 08                	jmp    8021ae <insert_sorted_allocList+0x8b>
  8021a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a9:	a3 44 50 80 00       	mov    %eax,0x805044
  8021ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b1:	a3 40 50 80 00       	mov    %eax,0x805040
  8021b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021c0:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021c5:	40                   	inc    %eax
  8021c6:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021cb:	e9 dc 01 00 00       	jmp    8023ac <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8021d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d3:	8b 50 08             	mov    0x8(%eax),%edx
  8021d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d9:	8b 40 08             	mov    0x8(%eax),%eax
  8021dc:	39 c2                	cmp    %eax,%edx
  8021de:	77 6c                	ja     80224c <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8021e0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021e4:	74 06                	je     8021ec <insert_sorted_allocList+0xc9>
  8021e6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021ea:	75 14                	jne    802200 <insert_sorted_allocList+0xdd>
  8021ec:	83 ec 04             	sub    $0x4,%esp
  8021ef:	68 28 40 80 00       	push   $0x804028
  8021f4:	6a 6f                	push   $0x6f
  8021f6:	68 0f 40 80 00       	push   $0x80400f
  8021fb:	e8 a7 12 00 00       	call   8034a7 <_panic>
  802200:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802203:	8b 50 04             	mov    0x4(%eax),%edx
  802206:	8b 45 08             	mov    0x8(%ebp),%eax
  802209:	89 50 04             	mov    %edx,0x4(%eax)
  80220c:	8b 45 08             	mov    0x8(%ebp),%eax
  80220f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802212:	89 10                	mov    %edx,(%eax)
  802214:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802217:	8b 40 04             	mov    0x4(%eax),%eax
  80221a:	85 c0                	test   %eax,%eax
  80221c:	74 0d                	je     80222b <insert_sorted_allocList+0x108>
  80221e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802221:	8b 40 04             	mov    0x4(%eax),%eax
  802224:	8b 55 08             	mov    0x8(%ebp),%edx
  802227:	89 10                	mov    %edx,(%eax)
  802229:	eb 08                	jmp    802233 <insert_sorted_allocList+0x110>
  80222b:	8b 45 08             	mov    0x8(%ebp),%eax
  80222e:	a3 40 50 80 00       	mov    %eax,0x805040
  802233:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802236:	8b 55 08             	mov    0x8(%ebp),%edx
  802239:	89 50 04             	mov    %edx,0x4(%eax)
  80223c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802241:	40                   	inc    %eax
  802242:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802247:	e9 60 01 00 00       	jmp    8023ac <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80224c:	8b 45 08             	mov    0x8(%ebp),%eax
  80224f:	8b 50 08             	mov    0x8(%eax),%edx
  802252:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802255:	8b 40 08             	mov    0x8(%eax),%eax
  802258:	39 c2                	cmp    %eax,%edx
  80225a:	0f 82 4c 01 00 00    	jb     8023ac <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802260:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802264:	75 14                	jne    80227a <insert_sorted_allocList+0x157>
  802266:	83 ec 04             	sub    $0x4,%esp
  802269:	68 60 40 80 00       	push   $0x804060
  80226e:	6a 73                	push   $0x73
  802270:	68 0f 40 80 00       	push   $0x80400f
  802275:	e8 2d 12 00 00       	call   8034a7 <_panic>
  80227a:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802280:	8b 45 08             	mov    0x8(%ebp),%eax
  802283:	89 50 04             	mov    %edx,0x4(%eax)
  802286:	8b 45 08             	mov    0x8(%ebp),%eax
  802289:	8b 40 04             	mov    0x4(%eax),%eax
  80228c:	85 c0                	test   %eax,%eax
  80228e:	74 0c                	je     80229c <insert_sorted_allocList+0x179>
  802290:	a1 44 50 80 00       	mov    0x805044,%eax
  802295:	8b 55 08             	mov    0x8(%ebp),%edx
  802298:	89 10                	mov    %edx,(%eax)
  80229a:	eb 08                	jmp    8022a4 <insert_sorted_allocList+0x181>
  80229c:	8b 45 08             	mov    0x8(%ebp),%eax
  80229f:	a3 40 50 80 00       	mov    %eax,0x805040
  8022a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a7:	a3 44 50 80 00       	mov    %eax,0x805044
  8022ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8022af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022b5:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022ba:	40                   	inc    %eax
  8022bb:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022c0:	e9 e7 00 00 00       	jmp    8023ac <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8022c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8022cb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8022d2:	a1 40 50 80 00       	mov    0x805040,%eax
  8022d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022da:	e9 9d 00 00 00       	jmp    80237c <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8022df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e2:	8b 00                	mov    (%eax),%eax
  8022e4:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8022e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ea:	8b 50 08             	mov    0x8(%eax),%edx
  8022ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f0:	8b 40 08             	mov    0x8(%eax),%eax
  8022f3:	39 c2                	cmp    %eax,%edx
  8022f5:	76 7d                	jbe    802374 <insert_sorted_allocList+0x251>
  8022f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fa:	8b 50 08             	mov    0x8(%eax),%edx
  8022fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802300:	8b 40 08             	mov    0x8(%eax),%eax
  802303:	39 c2                	cmp    %eax,%edx
  802305:	73 6d                	jae    802374 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802307:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80230b:	74 06                	je     802313 <insert_sorted_allocList+0x1f0>
  80230d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802311:	75 14                	jne    802327 <insert_sorted_allocList+0x204>
  802313:	83 ec 04             	sub    $0x4,%esp
  802316:	68 84 40 80 00       	push   $0x804084
  80231b:	6a 7f                	push   $0x7f
  80231d:	68 0f 40 80 00       	push   $0x80400f
  802322:	e8 80 11 00 00       	call   8034a7 <_panic>
  802327:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232a:	8b 10                	mov    (%eax),%edx
  80232c:	8b 45 08             	mov    0x8(%ebp),%eax
  80232f:	89 10                	mov    %edx,(%eax)
  802331:	8b 45 08             	mov    0x8(%ebp),%eax
  802334:	8b 00                	mov    (%eax),%eax
  802336:	85 c0                	test   %eax,%eax
  802338:	74 0b                	je     802345 <insert_sorted_allocList+0x222>
  80233a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233d:	8b 00                	mov    (%eax),%eax
  80233f:	8b 55 08             	mov    0x8(%ebp),%edx
  802342:	89 50 04             	mov    %edx,0x4(%eax)
  802345:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802348:	8b 55 08             	mov    0x8(%ebp),%edx
  80234b:	89 10                	mov    %edx,(%eax)
  80234d:	8b 45 08             	mov    0x8(%ebp),%eax
  802350:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802353:	89 50 04             	mov    %edx,0x4(%eax)
  802356:	8b 45 08             	mov    0x8(%ebp),%eax
  802359:	8b 00                	mov    (%eax),%eax
  80235b:	85 c0                	test   %eax,%eax
  80235d:	75 08                	jne    802367 <insert_sorted_allocList+0x244>
  80235f:	8b 45 08             	mov    0x8(%ebp),%eax
  802362:	a3 44 50 80 00       	mov    %eax,0x805044
  802367:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80236c:	40                   	inc    %eax
  80236d:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802372:	eb 39                	jmp    8023ad <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802374:	a1 48 50 80 00       	mov    0x805048,%eax
  802379:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80237c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802380:	74 07                	je     802389 <insert_sorted_allocList+0x266>
  802382:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802385:	8b 00                	mov    (%eax),%eax
  802387:	eb 05                	jmp    80238e <insert_sorted_allocList+0x26b>
  802389:	b8 00 00 00 00       	mov    $0x0,%eax
  80238e:	a3 48 50 80 00       	mov    %eax,0x805048
  802393:	a1 48 50 80 00       	mov    0x805048,%eax
  802398:	85 c0                	test   %eax,%eax
  80239a:	0f 85 3f ff ff ff    	jne    8022df <insert_sorted_allocList+0x1bc>
  8023a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023a4:	0f 85 35 ff ff ff    	jne    8022df <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8023aa:	eb 01                	jmp    8023ad <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8023ac:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8023ad:	90                   	nop
  8023ae:	c9                   	leave  
  8023af:	c3                   	ret    

008023b0 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8023b0:	55                   	push   %ebp
  8023b1:	89 e5                	mov    %esp,%ebp
  8023b3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8023b6:	a1 38 51 80 00       	mov    0x805138,%eax
  8023bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023be:	e9 85 01 00 00       	jmp    802548 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8023c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8023c9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023cc:	0f 82 6e 01 00 00    	jb     802540 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8023d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8023d8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023db:	0f 85 8a 00 00 00    	jne    80246b <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8023e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023e5:	75 17                	jne    8023fe <alloc_block_FF+0x4e>
  8023e7:	83 ec 04             	sub    $0x4,%esp
  8023ea:	68 b8 40 80 00       	push   $0x8040b8
  8023ef:	68 93 00 00 00       	push   $0x93
  8023f4:	68 0f 40 80 00       	push   $0x80400f
  8023f9:	e8 a9 10 00 00       	call   8034a7 <_panic>
  8023fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802401:	8b 00                	mov    (%eax),%eax
  802403:	85 c0                	test   %eax,%eax
  802405:	74 10                	je     802417 <alloc_block_FF+0x67>
  802407:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240a:	8b 00                	mov    (%eax),%eax
  80240c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80240f:	8b 52 04             	mov    0x4(%edx),%edx
  802412:	89 50 04             	mov    %edx,0x4(%eax)
  802415:	eb 0b                	jmp    802422 <alloc_block_FF+0x72>
  802417:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241a:	8b 40 04             	mov    0x4(%eax),%eax
  80241d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802422:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802425:	8b 40 04             	mov    0x4(%eax),%eax
  802428:	85 c0                	test   %eax,%eax
  80242a:	74 0f                	je     80243b <alloc_block_FF+0x8b>
  80242c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242f:	8b 40 04             	mov    0x4(%eax),%eax
  802432:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802435:	8b 12                	mov    (%edx),%edx
  802437:	89 10                	mov    %edx,(%eax)
  802439:	eb 0a                	jmp    802445 <alloc_block_FF+0x95>
  80243b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243e:	8b 00                	mov    (%eax),%eax
  802440:	a3 38 51 80 00       	mov    %eax,0x805138
  802445:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802448:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80244e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802451:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802458:	a1 44 51 80 00       	mov    0x805144,%eax
  80245d:	48                   	dec    %eax
  80245e:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802463:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802466:	e9 10 01 00 00       	jmp    80257b <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  80246b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246e:	8b 40 0c             	mov    0xc(%eax),%eax
  802471:	3b 45 08             	cmp    0x8(%ebp),%eax
  802474:	0f 86 c6 00 00 00    	jbe    802540 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80247a:	a1 48 51 80 00       	mov    0x805148,%eax
  80247f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802482:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802485:	8b 50 08             	mov    0x8(%eax),%edx
  802488:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80248b:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  80248e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802491:	8b 55 08             	mov    0x8(%ebp),%edx
  802494:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802497:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80249b:	75 17                	jne    8024b4 <alloc_block_FF+0x104>
  80249d:	83 ec 04             	sub    $0x4,%esp
  8024a0:	68 b8 40 80 00       	push   $0x8040b8
  8024a5:	68 9b 00 00 00       	push   $0x9b
  8024aa:	68 0f 40 80 00       	push   $0x80400f
  8024af:	e8 f3 0f 00 00       	call   8034a7 <_panic>
  8024b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024b7:	8b 00                	mov    (%eax),%eax
  8024b9:	85 c0                	test   %eax,%eax
  8024bb:	74 10                	je     8024cd <alloc_block_FF+0x11d>
  8024bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c0:	8b 00                	mov    (%eax),%eax
  8024c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024c5:	8b 52 04             	mov    0x4(%edx),%edx
  8024c8:	89 50 04             	mov    %edx,0x4(%eax)
  8024cb:	eb 0b                	jmp    8024d8 <alloc_block_FF+0x128>
  8024cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d0:	8b 40 04             	mov    0x4(%eax),%eax
  8024d3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8024d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024db:	8b 40 04             	mov    0x4(%eax),%eax
  8024de:	85 c0                	test   %eax,%eax
  8024e0:	74 0f                	je     8024f1 <alloc_block_FF+0x141>
  8024e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e5:	8b 40 04             	mov    0x4(%eax),%eax
  8024e8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024eb:	8b 12                	mov    (%edx),%edx
  8024ed:	89 10                	mov    %edx,(%eax)
  8024ef:	eb 0a                	jmp    8024fb <alloc_block_FF+0x14b>
  8024f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f4:	8b 00                	mov    (%eax),%eax
  8024f6:	a3 48 51 80 00       	mov    %eax,0x805148
  8024fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802504:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802507:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80250e:	a1 54 51 80 00       	mov    0x805154,%eax
  802513:	48                   	dec    %eax
  802514:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802519:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251c:	8b 50 08             	mov    0x8(%eax),%edx
  80251f:	8b 45 08             	mov    0x8(%ebp),%eax
  802522:	01 c2                	add    %eax,%edx
  802524:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802527:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  80252a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252d:	8b 40 0c             	mov    0xc(%eax),%eax
  802530:	2b 45 08             	sub    0x8(%ebp),%eax
  802533:	89 c2                	mov    %eax,%edx
  802535:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802538:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  80253b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80253e:	eb 3b                	jmp    80257b <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802540:	a1 40 51 80 00       	mov    0x805140,%eax
  802545:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802548:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80254c:	74 07                	je     802555 <alloc_block_FF+0x1a5>
  80254e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802551:	8b 00                	mov    (%eax),%eax
  802553:	eb 05                	jmp    80255a <alloc_block_FF+0x1aa>
  802555:	b8 00 00 00 00       	mov    $0x0,%eax
  80255a:	a3 40 51 80 00       	mov    %eax,0x805140
  80255f:	a1 40 51 80 00       	mov    0x805140,%eax
  802564:	85 c0                	test   %eax,%eax
  802566:	0f 85 57 fe ff ff    	jne    8023c3 <alloc_block_FF+0x13>
  80256c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802570:	0f 85 4d fe ff ff    	jne    8023c3 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802576:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80257b:	c9                   	leave  
  80257c:	c3                   	ret    

0080257d <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80257d:	55                   	push   %ebp
  80257e:	89 e5                	mov    %esp,%ebp
  802580:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802583:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80258a:	a1 38 51 80 00       	mov    0x805138,%eax
  80258f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802592:	e9 df 00 00 00       	jmp    802676 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802597:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259a:	8b 40 0c             	mov    0xc(%eax),%eax
  80259d:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025a0:	0f 82 c8 00 00 00    	jb     80266e <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8025a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ac:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025af:	0f 85 8a 00 00 00    	jne    80263f <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8025b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025b9:	75 17                	jne    8025d2 <alloc_block_BF+0x55>
  8025bb:	83 ec 04             	sub    $0x4,%esp
  8025be:	68 b8 40 80 00       	push   $0x8040b8
  8025c3:	68 b7 00 00 00       	push   $0xb7
  8025c8:	68 0f 40 80 00       	push   $0x80400f
  8025cd:	e8 d5 0e 00 00       	call   8034a7 <_panic>
  8025d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d5:	8b 00                	mov    (%eax),%eax
  8025d7:	85 c0                	test   %eax,%eax
  8025d9:	74 10                	je     8025eb <alloc_block_BF+0x6e>
  8025db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025de:	8b 00                	mov    (%eax),%eax
  8025e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025e3:	8b 52 04             	mov    0x4(%edx),%edx
  8025e6:	89 50 04             	mov    %edx,0x4(%eax)
  8025e9:	eb 0b                	jmp    8025f6 <alloc_block_BF+0x79>
  8025eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ee:	8b 40 04             	mov    0x4(%eax),%eax
  8025f1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8025f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f9:	8b 40 04             	mov    0x4(%eax),%eax
  8025fc:	85 c0                	test   %eax,%eax
  8025fe:	74 0f                	je     80260f <alloc_block_BF+0x92>
  802600:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802603:	8b 40 04             	mov    0x4(%eax),%eax
  802606:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802609:	8b 12                	mov    (%edx),%edx
  80260b:	89 10                	mov    %edx,(%eax)
  80260d:	eb 0a                	jmp    802619 <alloc_block_BF+0x9c>
  80260f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802612:	8b 00                	mov    (%eax),%eax
  802614:	a3 38 51 80 00       	mov    %eax,0x805138
  802619:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802622:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802625:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80262c:	a1 44 51 80 00       	mov    0x805144,%eax
  802631:	48                   	dec    %eax
  802632:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802637:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263a:	e9 4d 01 00 00       	jmp    80278c <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  80263f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802642:	8b 40 0c             	mov    0xc(%eax),%eax
  802645:	3b 45 08             	cmp    0x8(%ebp),%eax
  802648:	76 24                	jbe    80266e <alloc_block_BF+0xf1>
  80264a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264d:	8b 40 0c             	mov    0xc(%eax),%eax
  802650:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802653:	73 19                	jae    80266e <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802655:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  80265c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265f:	8b 40 0c             	mov    0xc(%eax),%eax
  802662:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802665:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802668:	8b 40 08             	mov    0x8(%eax),%eax
  80266b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80266e:	a1 40 51 80 00       	mov    0x805140,%eax
  802673:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802676:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80267a:	74 07                	je     802683 <alloc_block_BF+0x106>
  80267c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267f:	8b 00                	mov    (%eax),%eax
  802681:	eb 05                	jmp    802688 <alloc_block_BF+0x10b>
  802683:	b8 00 00 00 00       	mov    $0x0,%eax
  802688:	a3 40 51 80 00       	mov    %eax,0x805140
  80268d:	a1 40 51 80 00       	mov    0x805140,%eax
  802692:	85 c0                	test   %eax,%eax
  802694:	0f 85 fd fe ff ff    	jne    802597 <alloc_block_BF+0x1a>
  80269a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80269e:	0f 85 f3 fe ff ff    	jne    802597 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8026a4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8026a8:	0f 84 d9 00 00 00    	je     802787 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8026ae:	a1 48 51 80 00       	mov    0x805148,%eax
  8026b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8026b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026b9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026bc:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8026bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8026c5:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8026c8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8026cc:	75 17                	jne    8026e5 <alloc_block_BF+0x168>
  8026ce:	83 ec 04             	sub    $0x4,%esp
  8026d1:	68 b8 40 80 00       	push   $0x8040b8
  8026d6:	68 c7 00 00 00       	push   $0xc7
  8026db:	68 0f 40 80 00       	push   $0x80400f
  8026e0:	e8 c2 0d 00 00       	call   8034a7 <_panic>
  8026e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026e8:	8b 00                	mov    (%eax),%eax
  8026ea:	85 c0                	test   %eax,%eax
  8026ec:	74 10                	je     8026fe <alloc_block_BF+0x181>
  8026ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026f1:	8b 00                	mov    (%eax),%eax
  8026f3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026f6:	8b 52 04             	mov    0x4(%edx),%edx
  8026f9:	89 50 04             	mov    %edx,0x4(%eax)
  8026fc:	eb 0b                	jmp    802709 <alloc_block_BF+0x18c>
  8026fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802701:	8b 40 04             	mov    0x4(%eax),%eax
  802704:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802709:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80270c:	8b 40 04             	mov    0x4(%eax),%eax
  80270f:	85 c0                	test   %eax,%eax
  802711:	74 0f                	je     802722 <alloc_block_BF+0x1a5>
  802713:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802716:	8b 40 04             	mov    0x4(%eax),%eax
  802719:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80271c:	8b 12                	mov    (%edx),%edx
  80271e:	89 10                	mov    %edx,(%eax)
  802720:	eb 0a                	jmp    80272c <alloc_block_BF+0x1af>
  802722:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802725:	8b 00                	mov    (%eax),%eax
  802727:	a3 48 51 80 00       	mov    %eax,0x805148
  80272c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80272f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802735:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802738:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80273f:	a1 54 51 80 00       	mov    0x805154,%eax
  802744:	48                   	dec    %eax
  802745:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  80274a:	83 ec 08             	sub    $0x8,%esp
  80274d:	ff 75 ec             	pushl  -0x14(%ebp)
  802750:	68 38 51 80 00       	push   $0x805138
  802755:	e8 71 f9 ff ff       	call   8020cb <find_block>
  80275a:	83 c4 10             	add    $0x10,%esp
  80275d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802760:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802763:	8b 50 08             	mov    0x8(%eax),%edx
  802766:	8b 45 08             	mov    0x8(%ebp),%eax
  802769:	01 c2                	add    %eax,%edx
  80276b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80276e:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802771:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802774:	8b 40 0c             	mov    0xc(%eax),%eax
  802777:	2b 45 08             	sub    0x8(%ebp),%eax
  80277a:	89 c2                	mov    %eax,%edx
  80277c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80277f:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802782:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802785:	eb 05                	jmp    80278c <alloc_block_BF+0x20f>
	}
	return NULL;
  802787:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80278c:	c9                   	leave  
  80278d:	c3                   	ret    

0080278e <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80278e:	55                   	push   %ebp
  80278f:	89 e5                	mov    %esp,%ebp
  802791:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802794:	a1 28 50 80 00       	mov    0x805028,%eax
  802799:	85 c0                	test   %eax,%eax
  80279b:	0f 85 de 01 00 00    	jne    80297f <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8027a1:	a1 38 51 80 00       	mov    0x805138,%eax
  8027a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027a9:	e9 9e 01 00 00       	jmp    80294c <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8027ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8027b4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027b7:	0f 82 87 01 00 00    	jb     802944 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8027bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8027c3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027c6:	0f 85 95 00 00 00    	jne    802861 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8027cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027d0:	75 17                	jne    8027e9 <alloc_block_NF+0x5b>
  8027d2:	83 ec 04             	sub    $0x4,%esp
  8027d5:	68 b8 40 80 00       	push   $0x8040b8
  8027da:	68 e0 00 00 00       	push   $0xe0
  8027df:	68 0f 40 80 00       	push   $0x80400f
  8027e4:	e8 be 0c 00 00       	call   8034a7 <_panic>
  8027e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ec:	8b 00                	mov    (%eax),%eax
  8027ee:	85 c0                	test   %eax,%eax
  8027f0:	74 10                	je     802802 <alloc_block_NF+0x74>
  8027f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f5:	8b 00                	mov    (%eax),%eax
  8027f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027fa:	8b 52 04             	mov    0x4(%edx),%edx
  8027fd:	89 50 04             	mov    %edx,0x4(%eax)
  802800:	eb 0b                	jmp    80280d <alloc_block_NF+0x7f>
  802802:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802805:	8b 40 04             	mov    0x4(%eax),%eax
  802808:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80280d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802810:	8b 40 04             	mov    0x4(%eax),%eax
  802813:	85 c0                	test   %eax,%eax
  802815:	74 0f                	je     802826 <alloc_block_NF+0x98>
  802817:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281a:	8b 40 04             	mov    0x4(%eax),%eax
  80281d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802820:	8b 12                	mov    (%edx),%edx
  802822:	89 10                	mov    %edx,(%eax)
  802824:	eb 0a                	jmp    802830 <alloc_block_NF+0xa2>
  802826:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802829:	8b 00                	mov    (%eax),%eax
  80282b:	a3 38 51 80 00       	mov    %eax,0x805138
  802830:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802833:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802839:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802843:	a1 44 51 80 00       	mov    0x805144,%eax
  802848:	48                   	dec    %eax
  802849:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  80284e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802851:	8b 40 08             	mov    0x8(%eax),%eax
  802854:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802859:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285c:	e9 f8 04 00 00       	jmp    802d59 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802861:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802864:	8b 40 0c             	mov    0xc(%eax),%eax
  802867:	3b 45 08             	cmp    0x8(%ebp),%eax
  80286a:	0f 86 d4 00 00 00    	jbe    802944 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802870:	a1 48 51 80 00       	mov    0x805148,%eax
  802875:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802878:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287b:	8b 50 08             	mov    0x8(%eax),%edx
  80287e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802881:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802884:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802887:	8b 55 08             	mov    0x8(%ebp),%edx
  80288a:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80288d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802891:	75 17                	jne    8028aa <alloc_block_NF+0x11c>
  802893:	83 ec 04             	sub    $0x4,%esp
  802896:	68 b8 40 80 00       	push   $0x8040b8
  80289b:	68 e9 00 00 00       	push   $0xe9
  8028a0:	68 0f 40 80 00       	push   $0x80400f
  8028a5:	e8 fd 0b 00 00       	call   8034a7 <_panic>
  8028aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ad:	8b 00                	mov    (%eax),%eax
  8028af:	85 c0                	test   %eax,%eax
  8028b1:	74 10                	je     8028c3 <alloc_block_NF+0x135>
  8028b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b6:	8b 00                	mov    (%eax),%eax
  8028b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028bb:	8b 52 04             	mov    0x4(%edx),%edx
  8028be:	89 50 04             	mov    %edx,0x4(%eax)
  8028c1:	eb 0b                	jmp    8028ce <alloc_block_NF+0x140>
  8028c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c6:	8b 40 04             	mov    0x4(%eax),%eax
  8028c9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d1:	8b 40 04             	mov    0x4(%eax),%eax
  8028d4:	85 c0                	test   %eax,%eax
  8028d6:	74 0f                	je     8028e7 <alloc_block_NF+0x159>
  8028d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028db:	8b 40 04             	mov    0x4(%eax),%eax
  8028de:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028e1:	8b 12                	mov    (%edx),%edx
  8028e3:	89 10                	mov    %edx,(%eax)
  8028e5:	eb 0a                	jmp    8028f1 <alloc_block_NF+0x163>
  8028e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ea:	8b 00                	mov    (%eax),%eax
  8028ec:	a3 48 51 80 00       	mov    %eax,0x805148
  8028f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802904:	a1 54 51 80 00       	mov    0x805154,%eax
  802909:	48                   	dec    %eax
  80290a:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  80290f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802912:	8b 40 08             	mov    0x8(%eax),%eax
  802915:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  80291a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291d:	8b 50 08             	mov    0x8(%eax),%edx
  802920:	8b 45 08             	mov    0x8(%ebp),%eax
  802923:	01 c2                	add    %eax,%edx
  802925:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802928:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  80292b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292e:	8b 40 0c             	mov    0xc(%eax),%eax
  802931:	2b 45 08             	sub    0x8(%ebp),%eax
  802934:	89 c2                	mov    %eax,%edx
  802936:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802939:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  80293c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293f:	e9 15 04 00 00       	jmp    802d59 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802944:	a1 40 51 80 00       	mov    0x805140,%eax
  802949:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80294c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802950:	74 07                	je     802959 <alloc_block_NF+0x1cb>
  802952:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802955:	8b 00                	mov    (%eax),%eax
  802957:	eb 05                	jmp    80295e <alloc_block_NF+0x1d0>
  802959:	b8 00 00 00 00       	mov    $0x0,%eax
  80295e:	a3 40 51 80 00       	mov    %eax,0x805140
  802963:	a1 40 51 80 00       	mov    0x805140,%eax
  802968:	85 c0                	test   %eax,%eax
  80296a:	0f 85 3e fe ff ff    	jne    8027ae <alloc_block_NF+0x20>
  802970:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802974:	0f 85 34 fe ff ff    	jne    8027ae <alloc_block_NF+0x20>
  80297a:	e9 d5 03 00 00       	jmp    802d54 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80297f:	a1 38 51 80 00       	mov    0x805138,%eax
  802984:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802987:	e9 b1 01 00 00       	jmp    802b3d <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  80298c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298f:	8b 50 08             	mov    0x8(%eax),%edx
  802992:	a1 28 50 80 00       	mov    0x805028,%eax
  802997:	39 c2                	cmp    %eax,%edx
  802999:	0f 82 96 01 00 00    	jb     802b35 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  80299f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8029a5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029a8:	0f 82 87 01 00 00    	jb     802b35 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8029ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8029b4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029b7:	0f 85 95 00 00 00    	jne    802a52 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8029bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029c1:	75 17                	jne    8029da <alloc_block_NF+0x24c>
  8029c3:	83 ec 04             	sub    $0x4,%esp
  8029c6:	68 b8 40 80 00       	push   $0x8040b8
  8029cb:	68 fc 00 00 00       	push   $0xfc
  8029d0:	68 0f 40 80 00       	push   $0x80400f
  8029d5:	e8 cd 0a 00 00       	call   8034a7 <_panic>
  8029da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029dd:	8b 00                	mov    (%eax),%eax
  8029df:	85 c0                	test   %eax,%eax
  8029e1:	74 10                	je     8029f3 <alloc_block_NF+0x265>
  8029e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e6:	8b 00                	mov    (%eax),%eax
  8029e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029eb:	8b 52 04             	mov    0x4(%edx),%edx
  8029ee:	89 50 04             	mov    %edx,0x4(%eax)
  8029f1:	eb 0b                	jmp    8029fe <alloc_block_NF+0x270>
  8029f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f6:	8b 40 04             	mov    0x4(%eax),%eax
  8029f9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8029fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a01:	8b 40 04             	mov    0x4(%eax),%eax
  802a04:	85 c0                	test   %eax,%eax
  802a06:	74 0f                	je     802a17 <alloc_block_NF+0x289>
  802a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0b:	8b 40 04             	mov    0x4(%eax),%eax
  802a0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a11:	8b 12                	mov    (%edx),%edx
  802a13:	89 10                	mov    %edx,(%eax)
  802a15:	eb 0a                	jmp    802a21 <alloc_block_NF+0x293>
  802a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1a:	8b 00                	mov    (%eax),%eax
  802a1c:	a3 38 51 80 00       	mov    %eax,0x805138
  802a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a24:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a34:	a1 44 51 80 00       	mov    0x805144,%eax
  802a39:	48                   	dec    %eax
  802a3a:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802a3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a42:	8b 40 08             	mov    0x8(%eax),%eax
  802a45:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4d:	e9 07 03 00 00       	jmp    802d59 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802a52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a55:	8b 40 0c             	mov    0xc(%eax),%eax
  802a58:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a5b:	0f 86 d4 00 00 00    	jbe    802b35 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a61:	a1 48 51 80 00       	mov    0x805148,%eax
  802a66:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6c:	8b 50 08             	mov    0x8(%eax),%edx
  802a6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a72:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802a75:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a78:	8b 55 08             	mov    0x8(%ebp),%edx
  802a7b:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802a7e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a82:	75 17                	jne    802a9b <alloc_block_NF+0x30d>
  802a84:	83 ec 04             	sub    $0x4,%esp
  802a87:	68 b8 40 80 00       	push   $0x8040b8
  802a8c:	68 04 01 00 00       	push   $0x104
  802a91:	68 0f 40 80 00       	push   $0x80400f
  802a96:	e8 0c 0a 00 00       	call   8034a7 <_panic>
  802a9b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a9e:	8b 00                	mov    (%eax),%eax
  802aa0:	85 c0                	test   %eax,%eax
  802aa2:	74 10                	je     802ab4 <alloc_block_NF+0x326>
  802aa4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aa7:	8b 00                	mov    (%eax),%eax
  802aa9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802aac:	8b 52 04             	mov    0x4(%edx),%edx
  802aaf:	89 50 04             	mov    %edx,0x4(%eax)
  802ab2:	eb 0b                	jmp    802abf <alloc_block_NF+0x331>
  802ab4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ab7:	8b 40 04             	mov    0x4(%eax),%eax
  802aba:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802abf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ac2:	8b 40 04             	mov    0x4(%eax),%eax
  802ac5:	85 c0                	test   %eax,%eax
  802ac7:	74 0f                	je     802ad8 <alloc_block_NF+0x34a>
  802ac9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802acc:	8b 40 04             	mov    0x4(%eax),%eax
  802acf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ad2:	8b 12                	mov    (%edx),%edx
  802ad4:	89 10                	mov    %edx,(%eax)
  802ad6:	eb 0a                	jmp    802ae2 <alloc_block_NF+0x354>
  802ad8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802adb:	8b 00                	mov    (%eax),%eax
  802add:	a3 48 51 80 00       	mov    %eax,0x805148
  802ae2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ae5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aeb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802af5:	a1 54 51 80 00       	mov    0x805154,%eax
  802afa:	48                   	dec    %eax
  802afb:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802b00:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b03:	8b 40 08             	mov    0x8(%eax),%eax
  802b06:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802b0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0e:	8b 50 08             	mov    0x8(%eax),%edx
  802b11:	8b 45 08             	mov    0x8(%ebp),%eax
  802b14:	01 c2                	add    %eax,%edx
  802b16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b19:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802b1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1f:	8b 40 0c             	mov    0xc(%eax),%eax
  802b22:	2b 45 08             	sub    0x8(%ebp),%eax
  802b25:	89 c2                	mov    %eax,%edx
  802b27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2a:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802b2d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b30:	e9 24 02 00 00       	jmp    802d59 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b35:	a1 40 51 80 00       	mov    0x805140,%eax
  802b3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b41:	74 07                	je     802b4a <alloc_block_NF+0x3bc>
  802b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b46:	8b 00                	mov    (%eax),%eax
  802b48:	eb 05                	jmp    802b4f <alloc_block_NF+0x3c1>
  802b4a:	b8 00 00 00 00       	mov    $0x0,%eax
  802b4f:	a3 40 51 80 00       	mov    %eax,0x805140
  802b54:	a1 40 51 80 00       	mov    0x805140,%eax
  802b59:	85 c0                	test   %eax,%eax
  802b5b:	0f 85 2b fe ff ff    	jne    80298c <alloc_block_NF+0x1fe>
  802b61:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b65:	0f 85 21 fe ff ff    	jne    80298c <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b6b:	a1 38 51 80 00       	mov    0x805138,%eax
  802b70:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b73:	e9 ae 01 00 00       	jmp    802d26 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7b:	8b 50 08             	mov    0x8(%eax),%edx
  802b7e:	a1 28 50 80 00       	mov    0x805028,%eax
  802b83:	39 c2                	cmp    %eax,%edx
  802b85:	0f 83 93 01 00 00    	jae    802d1e <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8e:	8b 40 0c             	mov    0xc(%eax),%eax
  802b91:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b94:	0f 82 84 01 00 00    	jb     802d1e <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802b9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9d:	8b 40 0c             	mov    0xc(%eax),%eax
  802ba0:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ba3:	0f 85 95 00 00 00    	jne    802c3e <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802ba9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bad:	75 17                	jne    802bc6 <alloc_block_NF+0x438>
  802baf:	83 ec 04             	sub    $0x4,%esp
  802bb2:	68 b8 40 80 00       	push   $0x8040b8
  802bb7:	68 14 01 00 00       	push   $0x114
  802bbc:	68 0f 40 80 00       	push   $0x80400f
  802bc1:	e8 e1 08 00 00       	call   8034a7 <_panic>
  802bc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc9:	8b 00                	mov    (%eax),%eax
  802bcb:	85 c0                	test   %eax,%eax
  802bcd:	74 10                	je     802bdf <alloc_block_NF+0x451>
  802bcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd2:	8b 00                	mov    (%eax),%eax
  802bd4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bd7:	8b 52 04             	mov    0x4(%edx),%edx
  802bda:	89 50 04             	mov    %edx,0x4(%eax)
  802bdd:	eb 0b                	jmp    802bea <alloc_block_NF+0x45c>
  802bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be2:	8b 40 04             	mov    0x4(%eax),%eax
  802be5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802bea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bed:	8b 40 04             	mov    0x4(%eax),%eax
  802bf0:	85 c0                	test   %eax,%eax
  802bf2:	74 0f                	je     802c03 <alloc_block_NF+0x475>
  802bf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf7:	8b 40 04             	mov    0x4(%eax),%eax
  802bfa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bfd:	8b 12                	mov    (%edx),%edx
  802bff:	89 10                	mov    %edx,(%eax)
  802c01:	eb 0a                	jmp    802c0d <alloc_block_NF+0x47f>
  802c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c06:	8b 00                	mov    (%eax),%eax
  802c08:	a3 38 51 80 00       	mov    %eax,0x805138
  802c0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c10:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c19:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c20:	a1 44 51 80 00       	mov    0x805144,%eax
  802c25:	48                   	dec    %eax
  802c26:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2e:	8b 40 08             	mov    0x8(%eax),%eax
  802c31:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802c36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c39:	e9 1b 01 00 00       	jmp    802d59 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c41:	8b 40 0c             	mov    0xc(%eax),%eax
  802c44:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c47:	0f 86 d1 00 00 00    	jbe    802d1e <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802c4d:	a1 48 51 80 00       	mov    0x805148,%eax
  802c52:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802c55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c58:	8b 50 08             	mov    0x8(%eax),%edx
  802c5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c5e:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802c61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c64:	8b 55 08             	mov    0x8(%ebp),%edx
  802c67:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802c6a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c6e:	75 17                	jne    802c87 <alloc_block_NF+0x4f9>
  802c70:	83 ec 04             	sub    $0x4,%esp
  802c73:	68 b8 40 80 00       	push   $0x8040b8
  802c78:	68 1c 01 00 00       	push   $0x11c
  802c7d:	68 0f 40 80 00       	push   $0x80400f
  802c82:	e8 20 08 00 00       	call   8034a7 <_panic>
  802c87:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c8a:	8b 00                	mov    (%eax),%eax
  802c8c:	85 c0                	test   %eax,%eax
  802c8e:	74 10                	je     802ca0 <alloc_block_NF+0x512>
  802c90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c93:	8b 00                	mov    (%eax),%eax
  802c95:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c98:	8b 52 04             	mov    0x4(%edx),%edx
  802c9b:	89 50 04             	mov    %edx,0x4(%eax)
  802c9e:	eb 0b                	jmp    802cab <alloc_block_NF+0x51d>
  802ca0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ca3:	8b 40 04             	mov    0x4(%eax),%eax
  802ca6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802cab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cae:	8b 40 04             	mov    0x4(%eax),%eax
  802cb1:	85 c0                	test   %eax,%eax
  802cb3:	74 0f                	je     802cc4 <alloc_block_NF+0x536>
  802cb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cb8:	8b 40 04             	mov    0x4(%eax),%eax
  802cbb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cbe:	8b 12                	mov    (%edx),%edx
  802cc0:	89 10                	mov    %edx,(%eax)
  802cc2:	eb 0a                	jmp    802cce <alloc_block_NF+0x540>
  802cc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cc7:	8b 00                	mov    (%eax),%eax
  802cc9:	a3 48 51 80 00       	mov    %eax,0x805148
  802cce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cd1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cda:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ce1:	a1 54 51 80 00       	mov    0x805154,%eax
  802ce6:	48                   	dec    %eax
  802ce7:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802cec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cef:	8b 40 08             	mov    0x8(%eax),%eax
  802cf2:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802cf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfa:	8b 50 08             	mov    0x8(%eax),%edx
  802cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  802d00:	01 c2                	add    %eax,%edx
  802d02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d05:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802d08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0b:	8b 40 0c             	mov    0xc(%eax),%eax
  802d0e:	2b 45 08             	sub    0x8(%ebp),%eax
  802d11:	89 c2                	mov    %eax,%edx
  802d13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d16:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802d19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d1c:	eb 3b                	jmp    802d59 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802d1e:	a1 40 51 80 00       	mov    0x805140,%eax
  802d23:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d26:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d2a:	74 07                	je     802d33 <alloc_block_NF+0x5a5>
  802d2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2f:	8b 00                	mov    (%eax),%eax
  802d31:	eb 05                	jmp    802d38 <alloc_block_NF+0x5aa>
  802d33:	b8 00 00 00 00       	mov    $0x0,%eax
  802d38:	a3 40 51 80 00       	mov    %eax,0x805140
  802d3d:	a1 40 51 80 00       	mov    0x805140,%eax
  802d42:	85 c0                	test   %eax,%eax
  802d44:	0f 85 2e fe ff ff    	jne    802b78 <alloc_block_NF+0x3ea>
  802d4a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d4e:	0f 85 24 fe ff ff    	jne    802b78 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802d54:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d59:	c9                   	leave  
  802d5a:	c3                   	ret    

00802d5b <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802d5b:	55                   	push   %ebp
  802d5c:	89 e5                	mov    %esp,%ebp
  802d5e:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802d61:	a1 38 51 80 00       	mov    0x805138,%eax
  802d66:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802d69:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d6e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802d71:	a1 38 51 80 00       	mov    0x805138,%eax
  802d76:	85 c0                	test   %eax,%eax
  802d78:	74 14                	je     802d8e <insert_sorted_with_merge_freeList+0x33>
  802d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7d:	8b 50 08             	mov    0x8(%eax),%edx
  802d80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d83:	8b 40 08             	mov    0x8(%eax),%eax
  802d86:	39 c2                	cmp    %eax,%edx
  802d88:	0f 87 9b 01 00 00    	ja     802f29 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802d8e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d92:	75 17                	jne    802dab <insert_sorted_with_merge_freeList+0x50>
  802d94:	83 ec 04             	sub    $0x4,%esp
  802d97:	68 ec 3f 80 00       	push   $0x803fec
  802d9c:	68 38 01 00 00       	push   $0x138
  802da1:	68 0f 40 80 00       	push   $0x80400f
  802da6:	e8 fc 06 00 00       	call   8034a7 <_panic>
  802dab:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802db1:	8b 45 08             	mov    0x8(%ebp),%eax
  802db4:	89 10                	mov    %edx,(%eax)
  802db6:	8b 45 08             	mov    0x8(%ebp),%eax
  802db9:	8b 00                	mov    (%eax),%eax
  802dbb:	85 c0                	test   %eax,%eax
  802dbd:	74 0d                	je     802dcc <insert_sorted_with_merge_freeList+0x71>
  802dbf:	a1 38 51 80 00       	mov    0x805138,%eax
  802dc4:	8b 55 08             	mov    0x8(%ebp),%edx
  802dc7:	89 50 04             	mov    %edx,0x4(%eax)
  802dca:	eb 08                	jmp    802dd4 <insert_sorted_with_merge_freeList+0x79>
  802dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dcf:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd7:	a3 38 51 80 00       	mov    %eax,0x805138
  802ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802de6:	a1 44 51 80 00       	mov    0x805144,%eax
  802deb:	40                   	inc    %eax
  802dec:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802df1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802df5:	0f 84 a8 06 00 00    	je     8034a3 <insert_sorted_with_merge_freeList+0x748>
  802dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfe:	8b 50 08             	mov    0x8(%eax),%edx
  802e01:	8b 45 08             	mov    0x8(%ebp),%eax
  802e04:	8b 40 0c             	mov    0xc(%eax),%eax
  802e07:	01 c2                	add    %eax,%edx
  802e09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e0c:	8b 40 08             	mov    0x8(%eax),%eax
  802e0f:	39 c2                	cmp    %eax,%edx
  802e11:	0f 85 8c 06 00 00    	jne    8034a3 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802e17:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1a:	8b 50 0c             	mov    0xc(%eax),%edx
  802e1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e20:	8b 40 0c             	mov    0xc(%eax),%eax
  802e23:	01 c2                	add    %eax,%edx
  802e25:	8b 45 08             	mov    0x8(%ebp),%eax
  802e28:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802e2b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e2f:	75 17                	jne    802e48 <insert_sorted_with_merge_freeList+0xed>
  802e31:	83 ec 04             	sub    $0x4,%esp
  802e34:	68 b8 40 80 00       	push   $0x8040b8
  802e39:	68 3c 01 00 00       	push   $0x13c
  802e3e:	68 0f 40 80 00       	push   $0x80400f
  802e43:	e8 5f 06 00 00       	call   8034a7 <_panic>
  802e48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e4b:	8b 00                	mov    (%eax),%eax
  802e4d:	85 c0                	test   %eax,%eax
  802e4f:	74 10                	je     802e61 <insert_sorted_with_merge_freeList+0x106>
  802e51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e54:	8b 00                	mov    (%eax),%eax
  802e56:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e59:	8b 52 04             	mov    0x4(%edx),%edx
  802e5c:	89 50 04             	mov    %edx,0x4(%eax)
  802e5f:	eb 0b                	jmp    802e6c <insert_sorted_with_merge_freeList+0x111>
  802e61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e64:	8b 40 04             	mov    0x4(%eax),%eax
  802e67:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e6f:	8b 40 04             	mov    0x4(%eax),%eax
  802e72:	85 c0                	test   %eax,%eax
  802e74:	74 0f                	je     802e85 <insert_sorted_with_merge_freeList+0x12a>
  802e76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e79:	8b 40 04             	mov    0x4(%eax),%eax
  802e7c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e7f:	8b 12                	mov    (%edx),%edx
  802e81:	89 10                	mov    %edx,(%eax)
  802e83:	eb 0a                	jmp    802e8f <insert_sorted_with_merge_freeList+0x134>
  802e85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e88:	8b 00                	mov    (%eax),%eax
  802e8a:	a3 38 51 80 00       	mov    %eax,0x805138
  802e8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e92:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e9b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ea2:	a1 44 51 80 00       	mov    0x805144,%eax
  802ea7:	48                   	dec    %eax
  802ea8:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802ead:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802eb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eba:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802ec1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ec5:	75 17                	jne    802ede <insert_sorted_with_merge_freeList+0x183>
  802ec7:	83 ec 04             	sub    $0x4,%esp
  802eca:	68 ec 3f 80 00       	push   $0x803fec
  802ecf:	68 3f 01 00 00       	push   $0x13f
  802ed4:	68 0f 40 80 00       	push   $0x80400f
  802ed9:	e8 c9 05 00 00       	call   8034a7 <_panic>
  802ede:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802ee4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee7:	89 10                	mov    %edx,(%eax)
  802ee9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eec:	8b 00                	mov    (%eax),%eax
  802eee:	85 c0                	test   %eax,%eax
  802ef0:	74 0d                	je     802eff <insert_sorted_with_merge_freeList+0x1a4>
  802ef2:	a1 48 51 80 00       	mov    0x805148,%eax
  802ef7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802efa:	89 50 04             	mov    %edx,0x4(%eax)
  802efd:	eb 08                	jmp    802f07 <insert_sorted_with_merge_freeList+0x1ac>
  802eff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f02:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f0a:	a3 48 51 80 00       	mov    %eax,0x805148
  802f0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f12:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f19:	a1 54 51 80 00       	mov    0x805154,%eax
  802f1e:	40                   	inc    %eax
  802f1f:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802f24:	e9 7a 05 00 00       	jmp    8034a3 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802f29:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2c:	8b 50 08             	mov    0x8(%eax),%edx
  802f2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f32:	8b 40 08             	mov    0x8(%eax),%eax
  802f35:	39 c2                	cmp    %eax,%edx
  802f37:	0f 82 14 01 00 00    	jb     803051 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802f3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f40:	8b 50 08             	mov    0x8(%eax),%edx
  802f43:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f46:	8b 40 0c             	mov    0xc(%eax),%eax
  802f49:	01 c2                	add    %eax,%edx
  802f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4e:	8b 40 08             	mov    0x8(%eax),%eax
  802f51:	39 c2                	cmp    %eax,%edx
  802f53:	0f 85 90 00 00 00    	jne    802fe9 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802f59:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f5c:	8b 50 0c             	mov    0xc(%eax),%edx
  802f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f62:	8b 40 0c             	mov    0xc(%eax),%eax
  802f65:	01 c2                	add    %eax,%edx
  802f67:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f6a:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f70:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802f77:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802f81:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f85:	75 17                	jne    802f9e <insert_sorted_with_merge_freeList+0x243>
  802f87:	83 ec 04             	sub    $0x4,%esp
  802f8a:	68 ec 3f 80 00       	push   $0x803fec
  802f8f:	68 49 01 00 00       	push   $0x149
  802f94:	68 0f 40 80 00       	push   $0x80400f
  802f99:	e8 09 05 00 00       	call   8034a7 <_panic>
  802f9e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa7:	89 10                	mov    %edx,(%eax)
  802fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fac:	8b 00                	mov    (%eax),%eax
  802fae:	85 c0                	test   %eax,%eax
  802fb0:	74 0d                	je     802fbf <insert_sorted_with_merge_freeList+0x264>
  802fb2:	a1 48 51 80 00       	mov    0x805148,%eax
  802fb7:	8b 55 08             	mov    0x8(%ebp),%edx
  802fba:	89 50 04             	mov    %edx,0x4(%eax)
  802fbd:	eb 08                	jmp    802fc7 <insert_sorted_with_merge_freeList+0x26c>
  802fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fca:	a3 48 51 80 00       	mov    %eax,0x805148
  802fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fd9:	a1 54 51 80 00       	mov    0x805154,%eax
  802fde:	40                   	inc    %eax
  802fdf:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802fe4:	e9 bb 04 00 00       	jmp    8034a4 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802fe9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fed:	75 17                	jne    803006 <insert_sorted_with_merge_freeList+0x2ab>
  802fef:	83 ec 04             	sub    $0x4,%esp
  802ff2:	68 60 40 80 00       	push   $0x804060
  802ff7:	68 4c 01 00 00       	push   $0x14c
  802ffc:	68 0f 40 80 00       	push   $0x80400f
  803001:	e8 a1 04 00 00       	call   8034a7 <_panic>
  803006:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80300c:	8b 45 08             	mov    0x8(%ebp),%eax
  80300f:	89 50 04             	mov    %edx,0x4(%eax)
  803012:	8b 45 08             	mov    0x8(%ebp),%eax
  803015:	8b 40 04             	mov    0x4(%eax),%eax
  803018:	85 c0                	test   %eax,%eax
  80301a:	74 0c                	je     803028 <insert_sorted_with_merge_freeList+0x2cd>
  80301c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803021:	8b 55 08             	mov    0x8(%ebp),%edx
  803024:	89 10                	mov    %edx,(%eax)
  803026:	eb 08                	jmp    803030 <insert_sorted_with_merge_freeList+0x2d5>
  803028:	8b 45 08             	mov    0x8(%ebp),%eax
  80302b:	a3 38 51 80 00       	mov    %eax,0x805138
  803030:	8b 45 08             	mov    0x8(%ebp),%eax
  803033:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803038:	8b 45 08             	mov    0x8(%ebp),%eax
  80303b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803041:	a1 44 51 80 00       	mov    0x805144,%eax
  803046:	40                   	inc    %eax
  803047:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80304c:	e9 53 04 00 00       	jmp    8034a4 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803051:	a1 38 51 80 00       	mov    0x805138,%eax
  803056:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803059:	e9 15 04 00 00       	jmp    803473 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  80305e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803061:	8b 00                	mov    (%eax),%eax
  803063:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803066:	8b 45 08             	mov    0x8(%ebp),%eax
  803069:	8b 50 08             	mov    0x8(%eax),%edx
  80306c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306f:	8b 40 08             	mov    0x8(%eax),%eax
  803072:	39 c2                	cmp    %eax,%edx
  803074:	0f 86 f1 03 00 00    	jbe    80346b <insert_sorted_with_merge_freeList+0x710>
  80307a:	8b 45 08             	mov    0x8(%ebp),%eax
  80307d:	8b 50 08             	mov    0x8(%eax),%edx
  803080:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803083:	8b 40 08             	mov    0x8(%eax),%eax
  803086:	39 c2                	cmp    %eax,%edx
  803088:	0f 83 dd 03 00 00    	jae    80346b <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  80308e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803091:	8b 50 08             	mov    0x8(%eax),%edx
  803094:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803097:	8b 40 0c             	mov    0xc(%eax),%eax
  80309a:	01 c2                	add    %eax,%edx
  80309c:	8b 45 08             	mov    0x8(%ebp),%eax
  80309f:	8b 40 08             	mov    0x8(%eax),%eax
  8030a2:	39 c2                	cmp    %eax,%edx
  8030a4:	0f 85 b9 01 00 00    	jne    803263 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8030aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ad:	8b 50 08             	mov    0x8(%eax),%edx
  8030b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8030b6:	01 c2                	add    %eax,%edx
  8030b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030bb:	8b 40 08             	mov    0x8(%eax),%eax
  8030be:	39 c2                	cmp    %eax,%edx
  8030c0:	0f 85 0d 01 00 00    	jne    8031d3 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8030c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c9:	8b 50 0c             	mov    0xc(%eax),%edx
  8030cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8030d2:	01 c2                	add    %eax,%edx
  8030d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d7:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8030da:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030de:	75 17                	jne    8030f7 <insert_sorted_with_merge_freeList+0x39c>
  8030e0:	83 ec 04             	sub    $0x4,%esp
  8030e3:	68 b8 40 80 00       	push   $0x8040b8
  8030e8:	68 5c 01 00 00       	push   $0x15c
  8030ed:	68 0f 40 80 00       	push   $0x80400f
  8030f2:	e8 b0 03 00 00       	call   8034a7 <_panic>
  8030f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030fa:	8b 00                	mov    (%eax),%eax
  8030fc:	85 c0                	test   %eax,%eax
  8030fe:	74 10                	je     803110 <insert_sorted_with_merge_freeList+0x3b5>
  803100:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803103:	8b 00                	mov    (%eax),%eax
  803105:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803108:	8b 52 04             	mov    0x4(%edx),%edx
  80310b:	89 50 04             	mov    %edx,0x4(%eax)
  80310e:	eb 0b                	jmp    80311b <insert_sorted_with_merge_freeList+0x3c0>
  803110:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803113:	8b 40 04             	mov    0x4(%eax),%eax
  803116:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80311b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80311e:	8b 40 04             	mov    0x4(%eax),%eax
  803121:	85 c0                	test   %eax,%eax
  803123:	74 0f                	je     803134 <insert_sorted_with_merge_freeList+0x3d9>
  803125:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803128:	8b 40 04             	mov    0x4(%eax),%eax
  80312b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80312e:	8b 12                	mov    (%edx),%edx
  803130:	89 10                	mov    %edx,(%eax)
  803132:	eb 0a                	jmp    80313e <insert_sorted_with_merge_freeList+0x3e3>
  803134:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803137:	8b 00                	mov    (%eax),%eax
  803139:	a3 38 51 80 00       	mov    %eax,0x805138
  80313e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803141:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803147:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80314a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803151:	a1 44 51 80 00       	mov    0x805144,%eax
  803156:	48                   	dec    %eax
  803157:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  80315c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80315f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803166:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803169:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803170:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803174:	75 17                	jne    80318d <insert_sorted_with_merge_freeList+0x432>
  803176:	83 ec 04             	sub    $0x4,%esp
  803179:	68 ec 3f 80 00       	push   $0x803fec
  80317e:	68 5f 01 00 00       	push   $0x15f
  803183:	68 0f 40 80 00       	push   $0x80400f
  803188:	e8 1a 03 00 00       	call   8034a7 <_panic>
  80318d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803193:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803196:	89 10                	mov    %edx,(%eax)
  803198:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80319b:	8b 00                	mov    (%eax),%eax
  80319d:	85 c0                	test   %eax,%eax
  80319f:	74 0d                	je     8031ae <insert_sorted_with_merge_freeList+0x453>
  8031a1:	a1 48 51 80 00       	mov    0x805148,%eax
  8031a6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031a9:	89 50 04             	mov    %edx,0x4(%eax)
  8031ac:	eb 08                	jmp    8031b6 <insert_sorted_with_merge_freeList+0x45b>
  8031ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b9:	a3 48 51 80 00       	mov    %eax,0x805148
  8031be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031c8:	a1 54 51 80 00       	mov    0x805154,%eax
  8031cd:	40                   	inc    %eax
  8031ce:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8031d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d6:	8b 50 0c             	mov    0xc(%eax),%edx
  8031d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8031df:	01 c2                	add    %eax,%edx
  8031e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e4:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8031e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ea:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8031f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8031fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031ff:	75 17                	jne    803218 <insert_sorted_with_merge_freeList+0x4bd>
  803201:	83 ec 04             	sub    $0x4,%esp
  803204:	68 ec 3f 80 00       	push   $0x803fec
  803209:	68 64 01 00 00       	push   $0x164
  80320e:	68 0f 40 80 00       	push   $0x80400f
  803213:	e8 8f 02 00 00       	call   8034a7 <_panic>
  803218:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80321e:	8b 45 08             	mov    0x8(%ebp),%eax
  803221:	89 10                	mov    %edx,(%eax)
  803223:	8b 45 08             	mov    0x8(%ebp),%eax
  803226:	8b 00                	mov    (%eax),%eax
  803228:	85 c0                	test   %eax,%eax
  80322a:	74 0d                	je     803239 <insert_sorted_with_merge_freeList+0x4de>
  80322c:	a1 48 51 80 00       	mov    0x805148,%eax
  803231:	8b 55 08             	mov    0x8(%ebp),%edx
  803234:	89 50 04             	mov    %edx,0x4(%eax)
  803237:	eb 08                	jmp    803241 <insert_sorted_with_merge_freeList+0x4e6>
  803239:	8b 45 08             	mov    0x8(%ebp),%eax
  80323c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803241:	8b 45 08             	mov    0x8(%ebp),%eax
  803244:	a3 48 51 80 00       	mov    %eax,0x805148
  803249:	8b 45 08             	mov    0x8(%ebp),%eax
  80324c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803253:	a1 54 51 80 00       	mov    0x805154,%eax
  803258:	40                   	inc    %eax
  803259:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80325e:	e9 41 02 00 00       	jmp    8034a4 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803263:	8b 45 08             	mov    0x8(%ebp),%eax
  803266:	8b 50 08             	mov    0x8(%eax),%edx
  803269:	8b 45 08             	mov    0x8(%ebp),%eax
  80326c:	8b 40 0c             	mov    0xc(%eax),%eax
  80326f:	01 c2                	add    %eax,%edx
  803271:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803274:	8b 40 08             	mov    0x8(%eax),%eax
  803277:	39 c2                	cmp    %eax,%edx
  803279:	0f 85 7c 01 00 00    	jne    8033fb <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80327f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803283:	74 06                	je     80328b <insert_sorted_with_merge_freeList+0x530>
  803285:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803289:	75 17                	jne    8032a2 <insert_sorted_with_merge_freeList+0x547>
  80328b:	83 ec 04             	sub    $0x4,%esp
  80328e:	68 28 40 80 00       	push   $0x804028
  803293:	68 69 01 00 00       	push   $0x169
  803298:	68 0f 40 80 00       	push   $0x80400f
  80329d:	e8 05 02 00 00       	call   8034a7 <_panic>
  8032a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a5:	8b 50 04             	mov    0x4(%eax),%edx
  8032a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ab:	89 50 04             	mov    %edx,0x4(%eax)
  8032ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032b4:	89 10                	mov    %edx,(%eax)
  8032b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b9:	8b 40 04             	mov    0x4(%eax),%eax
  8032bc:	85 c0                	test   %eax,%eax
  8032be:	74 0d                	je     8032cd <insert_sorted_with_merge_freeList+0x572>
  8032c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c3:	8b 40 04             	mov    0x4(%eax),%eax
  8032c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8032c9:	89 10                	mov    %edx,(%eax)
  8032cb:	eb 08                	jmp    8032d5 <insert_sorted_with_merge_freeList+0x57a>
  8032cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d0:	a3 38 51 80 00       	mov    %eax,0x805138
  8032d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8032db:	89 50 04             	mov    %edx,0x4(%eax)
  8032de:	a1 44 51 80 00       	mov    0x805144,%eax
  8032e3:	40                   	inc    %eax
  8032e4:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8032e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ec:	8b 50 0c             	mov    0xc(%eax),%edx
  8032ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8032f5:	01 c2                	add    %eax,%edx
  8032f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fa:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8032fd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803301:	75 17                	jne    80331a <insert_sorted_with_merge_freeList+0x5bf>
  803303:	83 ec 04             	sub    $0x4,%esp
  803306:	68 b8 40 80 00       	push   $0x8040b8
  80330b:	68 6b 01 00 00       	push   $0x16b
  803310:	68 0f 40 80 00       	push   $0x80400f
  803315:	e8 8d 01 00 00       	call   8034a7 <_panic>
  80331a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80331d:	8b 00                	mov    (%eax),%eax
  80331f:	85 c0                	test   %eax,%eax
  803321:	74 10                	je     803333 <insert_sorted_with_merge_freeList+0x5d8>
  803323:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803326:	8b 00                	mov    (%eax),%eax
  803328:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80332b:	8b 52 04             	mov    0x4(%edx),%edx
  80332e:	89 50 04             	mov    %edx,0x4(%eax)
  803331:	eb 0b                	jmp    80333e <insert_sorted_with_merge_freeList+0x5e3>
  803333:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803336:	8b 40 04             	mov    0x4(%eax),%eax
  803339:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80333e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803341:	8b 40 04             	mov    0x4(%eax),%eax
  803344:	85 c0                	test   %eax,%eax
  803346:	74 0f                	je     803357 <insert_sorted_with_merge_freeList+0x5fc>
  803348:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80334b:	8b 40 04             	mov    0x4(%eax),%eax
  80334e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803351:	8b 12                	mov    (%edx),%edx
  803353:	89 10                	mov    %edx,(%eax)
  803355:	eb 0a                	jmp    803361 <insert_sorted_with_merge_freeList+0x606>
  803357:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80335a:	8b 00                	mov    (%eax),%eax
  80335c:	a3 38 51 80 00       	mov    %eax,0x805138
  803361:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803364:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80336a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80336d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803374:	a1 44 51 80 00       	mov    0x805144,%eax
  803379:	48                   	dec    %eax
  80337a:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  80337f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803382:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803389:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80338c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803393:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803397:	75 17                	jne    8033b0 <insert_sorted_with_merge_freeList+0x655>
  803399:	83 ec 04             	sub    $0x4,%esp
  80339c:	68 ec 3f 80 00       	push   $0x803fec
  8033a1:	68 6e 01 00 00       	push   $0x16e
  8033a6:	68 0f 40 80 00       	push   $0x80400f
  8033ab:	e8 f7 00 00 00       	call   8034a7 <_panic>
  8033b0:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b9:	89 10                	mov    %edx,(%eax)
  8033bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033be:	8b 00                	mov    (%eax),%eax
  8033c0:	85 c0                	test   %eax,%eax
  8033c2:	74 0d                	je     8033d1 <insert_sorted_with_merge_freeList+0x676>
  8033c4:	a1 48 51 80 00       	mov    0x805148,%eax
  8033c9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033cc:	89 50 04             	mov    %edx,0x4(%eax)
  8033cf:	eb 08                	jmp    8033d9 <insert_sorted_with_merge_freeList+0x67e>
  8033d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033d4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033dc:	a3 48 51 80 00       	mov    %eax,0x805148
  8033e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033eb:	a1 54 51 80 00       	mov    0x805154,%eax
  8033f0:	40                   	inc    %eax
  8033f1:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8033f6:	e9 a9 00 00 00       	jmp    8034a4 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8033fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033ff:	74 06                	je     803407 <insert_sorted_with_merge_freeList+0x6ac>
  803401:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803405:	75 17                	jne    80341e <insert_sorted_with_merge_freeList+0x6c3>
  803407:	83 ec 04             	sub    $0x4,%esp
  80340a:	68 84 40 80 00       	push   $0x804084
  80340f:	68 73 01 00 00       	push   $0x173
  803414:	68 0f 40 80 00       	push   $0x80400f
  803419:	e8 89 00 00 00       	call   8034a7 <_panic>
  80341e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803421:	8b 10                	mov    (%eax),%edx
  803423:	8b 45 08             	mov    0x8(%ebp),%eax
  803426:	89 10                	mov    %edx,(%eax)
  803428:	8b 45 08             	mov    0x8(%ebp),%eax
  80342b:	8b 00                	mov    (%eax),%eax
  80342d:	85 c0                	test   %eax,%eax
  80342f:	74 0b                	je     80343c <insert_sorted_with_merge_freeList+0x6e1>
  803431:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803434:	8b 00                	mov    (%eax),%eax
  803436:	8b 55 08             	mov    0x8(%ebp),%edx
  803439:	89 50 04             	mov    %edx,0x4(%eax)
  80343c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343f:	8b 55 08             	mov    0x8(%ebp),%edx
  803442:	89 10                	mov    %edx,(%eax)
  803444:	8b 45 08             	mov    0x8(%ebp),%eax
  803447:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80344a:	89 50 04             	mov    %edx,0x4(%eax)
  80344d:	8b 45 08             	mov    0x8(%ebp),%eax
  803450:	8b 00                	mov    (%eax),%eax
  803452:	85 c0                	test   %eax,%eax
  803454:	75 08                	jne    80345e <insert_sorted_with_merge_freeList+0x703>
  803456:	8b 45 08             	mov    0x8(%ebp),%eax
  803459:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80345e:	a1 44 51 80 00       	mov    0x805144,%eax
  803463:	40                   	inc    %eax
  803464:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803469:	eb 39                	jmp    8034a4 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80346b:	a1 40 51 80 00       	mov    0x805140,%eax
  803470:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803473:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803477:	74 07                	je     803480 <insert_sorted_with_merge_freeList+0x725>
  803479:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80347c:	8b 00                	mov    (%eax),%eax
  80347e:	eb 05                	jmp    803485 <insert_sorted_with_merge_freeList+0x72a>
  803480:	b8 00 00 00 00       	mov    $0x0,%eax
  803485:	a3 40 51 80 00       	mov    %eax,0x805140
  80348a:	a1 40 51 80 00       	mov    0x805140,%eax
  80348f:	85 c0                	test   %eax,%eax
  803491:	0f 85 c7 fb ff ff    	jne    80305e <insert_sorted_with_merge_freeList+0x303>
  803497:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80349b:	0f 85 bd fb ff ff    	jne    80305e <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8034a1:	eb 01                	jmp    8034a4 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8034a3:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8034a4:	90                   	nop
  8034a5:	c9                   	leave  
  8034a6:	c3                   	ret    

008034a7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8034a7:	55                   	push   %ebp
  8034a8:	89 e5                	mov    %esp,%ebp
  8034aa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8034ad:	8d 45 10             	lea    0x10(%ebp),%eax
  8034b0:	83 c0 04             	add    $0x4,%eax
  8034b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8034b6:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8034bb:	85 c0                	test   %eax,%eax
  8034bd:	74 16                	je     8034d5 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8034bf:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8034c4:	83 ec 08             	sub    $0x8,%esp
  8034c7:	50                   	push   %eax
  8034c8:	68 d8 40 80 00       	push   $0x8040d8
  8034cd:	e8 6b d2 ff ff       	call   80073d <cprintf>
  8034d2:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8034d5:	a1 00 50 80 00       	mov    0x805000,%eax
  8034da:	ff 75 0c             	pushl  0xc(%ebp)
  8034dd:	ff 75 08             	pushl  0x8(%ebp)
  8034e0:	50                   	push   %eax
  8034e1:	68 dd 40 80 00       	push   $0x8040dd
  8034e6:	e8 52 d2 ff ff       	call   80073d <cprintf>
  8034eb:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8034ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8034f1:	83 ec 08             	sub    $0x8,%esp
  8034f4:	ff 75 f4             	pushl  -0xc(%ebp)
  8034f7:	50                   	push   %eax
  8034f8:	e8 d5 d1 ff ff       	call   8006d2 <vcprintf>
  8034fd:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803500:	83 ec 08             	sub    $0x8,%esp
  803503:	6a 00                	push   $0x0
  803505:	68 f9 40 80 00       	push   $0x8040f9
  80350a:	e8 c3 d1 ff ff       	call   8006d2 <vcprintf>
  80350f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803512:	e8 44 d1 ff ff       	call   80065b <exit>

	// should not return here
	while (1) ;
  803517:	eb fe                	jmp    803517 <_panic+0x70>

00803519 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803519:	55                   	push   %ebp
  80351a:	89 e5                	mov    %esp,%ebp
  80351c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80351f:	a1 20 50 80 00       	mov    0x805020,%eax
  803524:	8b 50 74             	mov    0x74(%eax),%edx
  803527:	8b 45 0c             	mov    0xc(%ebp),%eax
  80352a:	39 c2                	cmp    %eax,%edx
  80352c:	74 14                	je     803542 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80352e:	83 ec 04             	sub    $0x4,%esp
  803531:	68 fc 40 80 00       	push   $0x8040fc
  803536:	6a 26                	push   $0x26
  803538:	68 48 41 80 00       	push   $0x804148
  80353d:	e8 65 ff ff ff       	call   8034a7 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803542:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803549:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803550:	e9 c2 00 00 00       	jmp    803617 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  803555:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803558:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80355f:	8b 45 08             	mov    0x8(%ebp),%eax
  803562:	01 d0                	add    %edx,%eax
  803564:	8b 00                	mov    (%eax),%eax
  803566:	85 c0                	test   %eax,%eax
  803568:	75 08                	jne    803572 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80356a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80356d:	e9 a2 00 00 00       	jmp    803614 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  803572:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803579:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803580:	eb 69                	jmp    8035eb <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803582:	a1 20 50 80 00       	mov    0x805020,%eax
  803587:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80358d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803590:	89 d0                	mov    %edx,%eax
  803592:	01 c0                	add    %eax,%eax
  803594:	01 d0                	add    %edx,%eax
  803596:	c1 e0 03             	shl    $0x3,%eax
  803599:	01 c8                	add    %ecx,%eax
  80359b:	8a 40 04             	mov    0x4(%eax),%al
  80359e:	84 c0                	test   %al,%al
  8035a0:	75 46                	jne    8035e8 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8035a2:	a1 20 50 80 00       	mov    0x805020,%eax
  8035a7:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8035ad:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8035b0:	89 d0                	mov    %edx,%eax
  8035b2:	01 c0                	add    %eax,%eax
  8035b4:	01 d0                	add    %edx,%eax
  8035b6:	c1 e0 03             	shl    $0x3,%eax
  8035b9:	01 c8                	add    %ecx,%eax
  8035bb:	8b 00                	mov    (%eax),%eax
  8035bd:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8035c0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035c3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8035c8:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8035ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035cd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8035d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d7:	01 c8                	add    %ecx,%eax
  8035d9:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8035db:	39 c2                	cmp    %eax,%edx
  8035dd:	75 09                	jne    8035e8 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8035df:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8035e6:	eb 12                	jmp    8035fa <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8035e8:	ff 45 e8             	incl   -0x18(%ebp)
  8035eb:	a1 20 50 80 00       	mov    0x805020,%eax
  8035f0:	8b 50 74             	mov    0x74(%eax),%edx
  8035f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035f6:	39 c2                	cmp    %eax,%edx
  8035f8:	77 88                	ja     803582 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8035fa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8035fe:	75 14                	jne    803614 <CheckWSWithoutLastIndex+0xfb>
			panic(
  803600:	83 ec 04             	sub    $0x4,%esp
  803603:	68 54 41 80 00       	push   $0x804154
  803608:	6a 3a                	push   $0x3a
  80360a:	68 48 41 80 00       	push   $0x804148
  80360f:	e8 93 fe ff ff       	call   8034a7 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803614:	ff 45 f0             	incl   -0x10(%ebp)
  803617:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80361a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80361d:	0f 8c 32 ff ff ff    	jl     803555 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803623:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80362a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803631:	eb 26                	jmp    803659 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803633:	a1 20 50 80 00       	mov    0x805020,%eax
  803638:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80363e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803641:	89 d0                	mov    %edx,%eax
  803643:	01 c0                	add    %eax,%eax
  803645:	01 d0                	add    %edx,%eax
  803647:	c1 e0 03             	shl    $0x3,%eax
  80364a:	01 c8                	add    %ecx,%eax
  80364c:	8a 40 04             	mov    0x4(%eax),%al
  80364f:	3c 01                	cmp    $0x1,%al
  803651:	75 03                	jne    803656 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  803653:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803656:	ff 45 e0             	incl   -0x20(%ebp)
  803659:	a1 20 50 80 00       	mov    0x805020,%eax
  80365e:	8b 50 74             	mov    0x74(%eax),%edx
  803661:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803664:	39 c2                	cmp    %eax,%edx
  803666:	77 cb                	ja     803633 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803668:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80366b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80366e:	74 14                	je     803684 <CheckWSWithoutLastIndex+0x16b>
		panic(
  803670:	83 ec 04             	sub    $0x4,%esp
  803673:	68 a8 41 80 00       	push   $0x8041a8
  803678:	6a 44                	push   $0x44
  80367a:	68 48 41 80 00       	push   $0x804148
  80367f:	e8 23 fe ff ff       	call   8034a7 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803684:	90                   	nop
  803685:	c9                   	leave  
  803686:	c3                   	ret    
  803687:	90                   	nop

00803688 <__udivdi3>:
  803688:	55                   	push   %ebp
  803689:	57                   	push   %edi
  80368a:	56                   	push   %esi
  80368b:	53                   	push   %ebx
  80368c:	83 ec 1c             	sub    $0x1c,%esp
  80368f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803693:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803697:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80369b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80369f:	89 ca                	mov    %ecx,%edx
  8036a1:	89 f8                	mov    %edi,%eax
  8036a3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8036a7:	85 f6                	test   %esi,%esi
  8036a9:	75 2d                	jne    8036d8 <__udivdi3+0x50>
  8036ab:	39 cf                	cmp    %ecx,%edi
  8036ad:	77 65                	ja     803714 <__udivdi3+0x8c>
  8036af:	89 fd                	mov    %edi,%ebp
  8036b1:	85 ff                	test   %edi,%edi
  8036b3:	75 0b                	jne    8036c0 <__udivdi3+0x38>
  8036b5:	b8 01 00 00 00       	mov    $0x1,%eax
  8036ba:	31 d2                	xor    %edx,%edx
  8036bc:	f7 f7                	div    %edi
  8036be:	89 c5                	mov    %eax,%ebp
  8036c0:	31 d2                	xor    %edx,%edx
  8036c2:	89 c8                	mov    %ecx,%eax
  8036c4:	f7 f5                	div    %ebp
  8036c6:	89 c1                	mov    %eax,%ecx
  8036c8:	89 d8                	mov    %ebx,%eax
  8036ca:	f7 f5                	div    %ebp
  8036cc:	89 cf                	mov    %ecx,%edi
  8036ce:	89 fa                	mov    %edi,%edx
  8036d0:	83 c4 1c             	add    $0x1c,%esp
  8036d3:	5b                   	pop    %ebx
  8036d4:	5e                   	pop    %esi
  8036d5:	5f                   	pop    %edi
  8036d6:	5d                   	pop    %ebp
  8036d7:	c3                   	ret    
  8036d8:	39 ce                	cmp    %ecx,%esi
  8036da:	77 28                	ja     803704 <__udivdi3+0x7c>
  8036dc:	0f bd fe             	bsr    %esi,%edi
  8036df:	83 f7 1f             	xor    $0x1f,%edi
  8036e2:	75 40                	jne    803724 <__udivdi3+0x9c>
  8036e4:	39 ce                	cmp    %ecx,%esi
  8036e6:	72 0a                	jb     8036f2 <__udivdi3+0x6a>
  8036e8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8036ec:	0f 87 9e 00 00 00    	ja     803790 <__udivdi3+0x108>
  8036f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8036f7:	89 fa                	mov    %edi,%edx
  8036f9:	83 c4 1c             	add    $0x1c,%esp
  8036fc:	5b                   	pop    %ebx
  8036fd:	5e                   	pop    %esi
  8036fe:	5f                   	pop    %edi
  8036ff:	5d                   	pop    %ebp
  803700:	c3                   	ret    
  803701:	8d 76 00             	lea    0x0(%esi),%esi
  803704:	31 ff                	xor    %edi,%edi
  803706:	31 c0                	xor    %eax,%eax
  803708:	89 fa                	mov    %edi,%edx
  80370a:	83 c4 1c             	add    $0x1c,%esp
  80370d:	5b                   	pop    %ebx
  80370e:	5e                   	pop    %esi
  80370f:	5f                   	pop    %edi
  803710:	5d                   	pop    %ebp
  803711:	c3                   	ret    
  803712:	66 90                	xchg   %ax,%ax
  803714:	89 d8                	mov    %ebx,%eax
  803716:	f7 f7                	div    %edi
  803718:	31 ff                	xor    %edi,%edi
  80371a:	89 fa                	mov    %edi,%edx
  80371c:	83 c4 1c             	add    $0x1c,%esp
  80371f:	5b                   	pop    %ebx
  803720:	5e                   	pop    %esi
  803721:	5f                   	pop    %edi
  803722:	5d                   	pop    %ebp
  803723:	c3                   	ret    
  803724:	bd 20 00 00 00       	mov    $0x20,%ebp
  803729:	89 eb                	mov    %ebp,%ebx
  80372b:	29 fb                	sub    %edi,%ebx
  80372d:	89 f9                	mov    %edi,%ecx
  80372f:	d3 e6                	shl    %cl,%esi
  803731:	89 c5                	mov    %eax,%ebp
  803733:	88 d9                	mov    %bl,%cl
  803735:	d3 ed                	shr    %cl,%ebp
  803737:	89 e9                	mov    %ebp,%ecx
  803739:	09 f1                	or     %esi,%ecx
  80373b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80373f:	89 f9                	mov    %edi,%ecx
  803741:	d3 e0                	shl    %cl,%eax
  803743:	89 c5                	mov    %eax,%ebp
  803745:	89 d6                	mov    %edx,%esi
  803747:	88 d9                	mov    %bl,%cl
  803749:	d3 ee                	shr    %cl,%esi
  80374b:	89 f9                	mov    %edi,%ecx
  80374d:	d3 e2                	shl    %cl,%edx
  80374f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803753:	88 d9                	mov    %bl,%cl
  803755:	d3 e8                	shr    %cl,%eax
  803757:	09 c2                	or     %eax,%edx
  803759:	89 d0                	mov    %edx,%eax
  80375b:	89 f2                	mov    %esi,%edx
  80375d:	f7 74 24 0c          	divl   0xc(%esp)
  803761:	89 d6                	mov    %edx,%esi
  803763:	89 c3                	mov    %eax,%ebx
  803765:	f7 e5                	mul    %ebp
  803767:	39 d6                	cmp    %edx,%esi
  803769:	72 19                	jb     803784 <__udivdi3+0xfc>
  80376b:	74 0b                	je     803778 <__udivdi3+0xf0>
  80376d:	89 d8                	mov    %ebx,%eax
  80376f:	31 ff                	xor    %edi,%edi
  803771:	e9 58 ff ff ff       	jmp    8036ce <__udivdi3+0x46>
  803776:	66 90                	xchg   %ax,%ax
  803778:	8b 54 24 08          	mov    0x8(%esp),%edx
  80377c:	89 f9                	mov    %edi,%ecx
  80377e:	d3 e2                	shl    %cl,%edx
  803780:	39 c2                	cmp    %eax,%edx
  803782:	73 e9                	jae    80376d <__udivdi3+0xe5>
  803784:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803787:	31 ff                	xor    %edi,%edi
  803789:	e9 40 ff ff ff       	jmp    8036ce <__udivdi3+0x46>
  80378e:	66 90                	xchg   %ax,%ax
  803790:	31 c0                	xor    %eax,%eax
  803792:	e9 37 ff ff ff       	jmp    8036ce <__udivdi3+0x46>
  803797:	90                   	nop

00803798 <__umoddi3>:
  803798:	55                   	push   %ebp
  803799:	57                   	push   %edi
  80379a:	56                   	push   %esi
  80379b:	53                   	push   %ebx
  80379c:	83 ec 1c             	sub    $0x1c,%esp
  80379f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8037a3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8037a7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8037ab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8037af:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8037b3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8037b7:	89 f3                	mov    %esi,%ebx
  8037b9:	89 fa                	mov    %edi,%edx
  8037bb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8037bf:	89 34 24             	mov    %esi,(%esp)
  8037c2:	85 c0                	test   %eax,%eax
  8037c4:	75 1a                	jne    8037e0 <__umoddi3+0x48>
  8037c6:	39 f7                	cmp    %esi,%edi
  8037c8:	0f 86 a2 00 00 00    	jbe    803870 <__umoddi3+0xd8>
  8037ce:	89 c8                	mov    %ecx,%eax
  8037d0:	89 f2                	mov    %esi,%edx
  8037d2:	f7 f7                	div    %edi
  8037d4:	89 d0                	mov    %edx,%eax
  8037d6:	31 d2                	xor    %edx,%edx
  8037d8:	83 c4 1c             	add    $0x1c,%esp
  8037db:	5b                   	pop    %ebx
  8037dc:	5e                   	pop    %esi
  8037dd:	5f                   	pop    %edi
  8037de:	5d                   	pop    %ebp
  8037df:	c3                   	ret    
  8037e0:	39 f0                	cmp    %esi,%eax
  8037e2:	0f 87 ac 00 00 00    	ja     803894 <__umoddi3+0xfc>
  8037e8:	0f bd e8             	bsr    %eax,%ebp
  8037eb:	83 f5 1f             	xor    $0x1f,%ebp
  8037ee:	0f 84 ac 00 00 00    	je     8038a0 <__umoddi3+0x108>
  8037f4:	bf 20 00 00 00       	mov    $0x20,%edi
  8037f9:	29 ef                	sub    %ebp,%edi
  8037fb:	89 fe                	mov    %edi,%esi
  8037fd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803801:	89 e9                	mov    %ebp,%ecx
  803803:	d3 e0                	shl    %cl,%eax
  803805:	89 d7                	mov    %edx,%edi
  803807:	89 f1                	mov    %esi,%ecx
  803809:	d3 ef                	shr    %cl,%edi
  80380b:	09 c7                	or     %eax,%edi
  80380d:	89 e9                	mov    %ebp,%ecx
  80380f:	d3 e2                	shl    %cl,%edx
  803811:	89 14 24             	mov    %edx,(%esp)
  803814:	89 d8                	mov    %ebx,%eax
  803816:	d3 e0                	shl    %cl,%eax
  803818:	89 c2                	mov    %eax,%edx
  80381a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80381e:	d3 e0                	shl    %cl,%eax
  803820:	89 44 24 04          	mov    %eax,0x4(%esp)
  803824:	8b 44 24 08          	mov    0x8(%esp),%eax
  803828:	89 f1                	mov    %esi,%ecx
  80382a:	d3 e8                	shr    %cl,%eax
  80382c:	09 d0                	or     %edx,%eax
  80382e:	d3 eb                	shr    %cl,%ebx
  803830:	89 da                	mov    %ebx,%edx
  803832:	f7 f7                	div    %edi
  803834:	89 d3                	mov    %edx,%ebx
  803836:	f7 24 24             	mull   (%esp)
  803839:	89 c6                	mov    %eax,%esi
  80383b:	89 d1                	mov    %edx,%ecx
  80383d:	39 d3                	cmp    %edx,%ebx
  80383f:	0f 82 87 00 00 00    	jb     8038cc <__umoddi3+0x134>
  803845:	0f 84 91 00 00 00    	je     8038dc <__umoddi3+0x144>
  80384b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80384f:	29 f2                	sub    %esi,%edx
  803851:	19 cb                	sbb    %ecx,%ebx
  803853:	89 d8                	mov    %ebx,%eax
  803855:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803859:	d3 e0                	shl    %cl,%eax
  80385b:	89 e9                	mov    %ebp,%ecx
  80385d:	d3 ea                	shr    %cl,%edx
  80385f:	09 d0                	or     %edx,%eax
  803861:	89 e9                	mov    %ebp,%ecx
  803863:	d3 eb                	shr    %cl,%ebx
  803865:	89 da                	mov    %ebx,%edx
  803867:	83 c4 1c             	add    $0x1c,%esp
  80386a:	5b                   	pop    %ebx
  80386b:	5e                   	pop    %esi
  80386c:	5f                   	pop    %edi
  80386d:	5d                   	pop    %ebp
  80386e:	c3                   	ret    
  80386f:	90                   	nop
  803870:	89 fd                	mov    %edi,%ebp
  803872:	85 ff                	test   %edi,%edi
  803874:	75 0b                	jne    803881 <__umoddi3+0xe9>
  803876:	b8 01 00 00 00       	mov    $0x1,%eax
  80387b:	31 d2                	xor    %edx,%edx
  80387d:	f7 f7                	div    %edi
  80387f:	89 c5                	mov    %eax,%ebp
  803881:	89 f0                	mov    %esi,%eax
  803883:	31 d2                	xor    %edx,%edx
  803885:	f7 f5                	div    %ebp
  803887:	89 c8                	mov    %ecx,%eax
  803889:	f7 f5                	div    %ebp
  80388b:	89 d0                	mov    %edx,%eax
  80388d:	e9 44 ff ff ff       	jmp    8037d6 <__umoddi3+0x3e>
  803892:	66 90                	xchg   %ax,%ax
  803894:	89 c8                	mov    %ecx,%eax
  803896:	89 f2                	mov    %esi,%edx
  803898:	83 c4 1c             	add    $0x1c,%esp
  80389b:	5b                   	pop    %ebx
  80389c:	5e                   	pop    %esi
  80389d:	5f                   	pop    %edi
  80389e:	5d                   	pop    %ebp
  80389f:	c3                   	ret    
  8038a0:	3b 04 24             	cmp    (%esp),%eax
  8038a3:	72 06                	jb     8038ab <__umoddi3+0x113>
  8038a5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8038a9:	77 0f                	ja     8038ba <__umoddi3+0x122>
  8038ab:	89 f2                	mov    %esi,%edx
  8038ad:	29 f9                	sub    %edi,%ecx
  8038af:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8038b3:	89 14 24             	mov    %edx,(%esp)
  8038b6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8038ba:	8b 44 24 04          	mov    0x4(%esp),%eax
  8038be:	8b 14 24             	mov    (%esp),%edx
  8038c1:	83 c4 1c             	add    $0x1c,%esp
  8038c4:	5b                   	pop    %ebx
  8038c5:	5e                   	pop    %esi
  8038c6:	5f                   	pop    %edi
  8038c7:	5d                   	pop    %ebp
  8038c8:	c3                   	ret    
  8038c9:	8d 76 00             	lea    0x0(%esi),%esi
  8038cc:	2b 04 24             	sub    (%esp),%eax
  8038cf:	19 fa                	sbb    %edi,%edx
  8038d1:	89 d1                	mov    %edx,%ecx
  8038d3:	89 c6                	mov    %eax,%esi
  8038d5:	e9 71 ff ff ff       	jmp    80384b <__umoddi3+0xb3>
  8038da:	66 90                	xchg   %ax,%ax
  8038dc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8038e0:	72 ea                	jb     8038cc <__umoddi3+0x134>
  8038e2:	89 d9                	mov    %ebx,%ecx
  8038e4:	e9 62 ff ff ff       	jmp    80384b <__umoddi3+0xb3>
