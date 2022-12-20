
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
  80003e:	e8 66 1d 00 00       	call   801da9 <sys_getenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int32 parentenvID = sys_getparentenvid();
  800046:	e8 90 1d 00 00       	call   801ddb <sys_getparentenvid>
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
  80005f:	68 00 3b 80 00       	push   $0x803b00
  800064:	ff 75 ec             	pushl  -0x14(%ebp)
  800067:	e8 52 18 00 00       	call   8018be <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	numOfElements = sget(parentenvID,"arrSize") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 04 3b 80 00       	push   $0x803b04
  80007a:	ff 75 ec             	pushl  -0x14(%ebp)
  80007d:	e8 3c 18 00 00       	call   8018be <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//Get the check-finishing counter
	int *finishedCount = NULL;
  800088:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	finishedCount = sget(parentenvID,"finishedCount") ;
  80008f:	83 ec 08             	sub    $0x8,%esp
  800092:	68 0c 3b 80 00       	push   $0x803b0c
  800097:	ff 75 ec             	pushl  -0x14(%ebp)
  80009a:	e8 1f 18 00 00       	call   8018be <sget>
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
  8000b3:	68 1a 3b 80 00       	push   $0x803b1a
  8000b8:	e8 53 17 00 00       	call   801810 <smalloc>
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
  800126:	68 24 3b 80 00       	push   $0x803b24
  80012b:	e8 0d 06 00 00       	call   80073d <cprintf>
  800130:	83 c4 10             	add    $0x10,%esp

	/*[3] SHARE THE RESULTS & DECLARE FINISHING*/
	int *shMean, *shVar, *shMin, *shMax, *shMed;
	shMean = smalloc("mean", sizeof(int), 0) ; *shMean = mean;
  800133:	83 ec 04             	sub    $0x4,%esp
  800136:	6a 00                	push   $0x0
  800138:	6a 04                	push   $0x4
  80013a:	68 49 3b 80 00       	push   $0x803b49
  80013f:	e8 cc 16 00 00       	call   801810 <smalloc>
  800144:	83 c4 10             	add    $0x10,%esp
  800147:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80014a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80014d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800150:	89 10                	mov    %edx,(%eax)
	shVar = smalloc("var", sizeof(int), 0) ; *shVar = var;
  800152:	83 ec 04             	sub    $0x4,%esp
  800155:	6a 00                	push   $0x0
  800157:	6a 04                	push   $0x4
  800159:	68 4e 3b 80 00       	push   $0x803b4e
  80015e:	e8 ad 16 00 00       	call   801810 <smalloc>
  800163:	83 c4 10             	add    $0x10,%esp
  800166:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800169:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80016c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80016f:	89 10                	mov    %edx,(%eax)
	shMin = smalloc("min", sizeof(int), 0) ; *shMin = min;
  800171:	83 ec 04             	sub    $0x4,%esp
  800174:	6a 00                	push   $0x0
  800176:	6a 04                	push   $0x4
  800178:	68 52 3b 80 00       	push   $0x803b52
  80017d:	e8 8e 16 00 00       	call   801810 <smalloc>
  800182:	83 c4 10             	add    $0x10,%esp
  800185:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800188:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80018b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80018e:	89 10                	mov    %edx,(%eax)
	shMax = smalloc("max", sizeof(int), 0) ; *shMax = max;
  800190:	83 ec 04             	sub    $0x4,%esp
  800193:	6a 00                	push   $0x0
  800195:	6a 04                	push   $0x4
  800197:	68 56 3b 80 00       	push   $0x803b56
  80019c:	e8 6f 16 00 00       	call   801810 <smalloc>
  8001a1:	83 c4 10             	add    $0x10,%esp
  8001a4:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8001a7:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8001aa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001ad:	89 10                	mov    %edx,(%eax)
	shMed = smalloc("med", sizeof(int), 0) ; *shMed = med;
  8001af:	83 ec 04             	sub    $0x4,%esp
  8001b2:	6a 00                	push   $0x0
  8001b4:	6a 04                	push   $0x4
  8001b6:	68 5a 3b 80 00       	push   $0x803b5a
  8001bb:	e8 50 16 00 00       	call   801810 <smalloc>
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
  800230:	e8 d9 1b 00 00       	call   801e0e <sys_get_virtual_time>
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
  800533:	e8 8a 18 00 00       	call   801dc2 <sys_getenvindex>
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
  80059e:	e8 2c 16 00 00       	call   801bcf <sys_disable_interrupt>
	cprintf("**************************************\n");
  8005a3:	83 ec 0c             	sub    $0xc,%esp
  8005a6:	68 78 3b 80 00       	push   $0x803b78
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
  8005ce:	68 a0 3b 80 00       	push   $0x803ba0
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
  8005ff:	68 c8 3b 80 00       	push   $0x803bc8
  800604:	e8 34 01 00 00       	call   80073d <cprintf>
  800609:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80060c:	a1 20 50 80 00       	mov    0x805020,%eax
  800611:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800617:	83 ec 08             	sub    $0x8,%esp
  80061a:	50                   	push   %eax
  80061b:	68 20 3c 80 00       	push   $0x803c20
  800620:	e8 18 01 00 00       	call   80073d <cprintf>
  800625:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800628:	83 ec 0c             	sub    $0xc,%esp
  80062b:	68 78 3b 80 00       	push   $0x803b78
  800630:	e8 08 01 00 00       	call   80073d <cprintf>
  800635:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800638:	e8 ac 15 00 00       	call   801be9 <sys_enable_interrupt>

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
  800650:	e8 39 17 00 00       	call   801d8e <sys_destroy_env>
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
  800661:	e8 8e 17 00 00       	call   801df4 <sys_exit_env>
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
  8006af:	e8 6d 13 00 00       	call   801a21 <sys_cputs>
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
  800726:	e8 f6 12 00 00       	call   801a21 <sys_cputs>
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
  800770:	e8 5a 14 00 00       	call   801bcf <sys_disable_interrupt>
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
  800790:	e8 54 14 00 00       	call   801be9 <sys_enable_interrupt>
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
  8007da:	e8 a5 30 00 00       	call   803884 <__udivdi3>
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
  80082a:	e8 65 31 00 00       	call   803994 <__umoddi3>
  80082f:	83 c4 10             	add    $0x10,%esp
  800832:	05 54 3e 80 00       	add    $0x803e54,%eax
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
  800985:	8b 04 85 78 3e 80 00 	mov    0x803e78(,%eax,4),%eax
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
  800a66:	8b 34 9d c0 3c 80 00 	mov    0x803cc0(,%ebx,4),%esi
  800a6d:	85 f6                	test   %esi,%esi
  800a6f:	75 19                	jne    800a8a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a71:	53                   	push   %ebx
  800a72:	68 65 3e 80 00       	push   $0x803e65
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
  800a8b:	68 6e 3e 80 00       	push   $0x803e6e
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
  800ab8:	be 71 3e 80 00       	mov    $0x803e71,%esi
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
  8014de:	68 d0 3f 80 00       	push   $0x803fd0
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
  8015ae:	e8 b2 05 00 00       	call   801b65 <sys_allocate_chunk>
  8015b3:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8015b6:	a1 20 51 80 00       	mov    0x805120,%eax
  8015bb:	83 ec 0c             	sub    $0xc,%esp
  8015be:	50                   	push   %eax
  8015bf:	e8 27 0c 00 00       	call   8021eb <initialize_MemBlocksList>
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
  8015ec:	68 f5 3f 80 00       	push   $0x803ff5
  8015f1:	6a 33                	push   $0x33
  8015f3:	68 13 40 80 00       	push   $0x804013
  8015f8:	e8 a7 20 00 00       	call   8036a4 <_panic>
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
  80166b:	68 20 40 80 00       	push   $0x804020
  801670:	6a 34                	push   $0x34
  801672:	68 13 40 80 00       	push   $0x804013
  801677:	e8 28 20 00 00       	call   8036a4 <_panic>
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
  801703:	e8 2b 08 00 00       	call   801f33 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801708:	85 c0                	test   %eax,%eax
  80170a:	74 11                	je     80171d <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  80170c:	83 ec 0c             	sub    $0xc,%esp
  80170f:	ff 75 e8             	pushl  -0x18(%ebp)
  801712:	e8 96 0e 00 00       	call   8025ad <alloc_block_FF>
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
  801729:	e8 f2 0b 00 00       	call   802320 <insert_sorted_allocList>
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
  801743:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801746:	8b 45 08             	mov    0x8(%ebp),%eax
  801749:	83 ec 08             	sub    $0x8,%esp
  80174c:	50                   	push   %eax
  80174d:	68 40 50 80 00       	push   $0x805040
  801752:	e8 71 0b 00 00       	call   8022c8 <find_block>
  801757:	83 c4 10             	add    $0x10,%esp
  80175a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(free_block!=NULL)
  80175d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801761:	0f 84 a6 00 00 00    	je     80180d <free+0xcd>
	{
		sys_free_user_mem(free_block->sva,free_block->size);
  801767:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80176a:	8b 50 0c             	mov    0xc(%eax),%edx
  80176d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801770:	8b 40 08             	mov    0x8(%eax),%eax
  801773:	83 ec 08             	sub    $0x8,%esp
  801776:	52                   	push   %edx
  801777:	50                   	push   %eax
  801778:	e8 b0 03 00 00       	call   801b2d <sys_free_user_mem>
  80177d:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,free_block);
  801780:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801784:	75 14                	jne    80179a <free+0x5a>
  801786:	83 ec 04             	sub    $0x4,%esp
  801789:	68 f5 3f 80 00       	push   $0x803ff5
  80178e:	6a 74                	push   $0x74
  801790:	68 13 40 80 00       	push   $0x804013
  801795:	e8 0a 1f 00 00       	call   8036a4 <_panic>
  80179a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80179d:	8b 00                	mov    (%eax),%eax
  80179f:	85 c0                	test   %eax,%eax
  8017a1:	74 10                	je     8017b3 <free+0x73>
  8017a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017a6:	8b 00                	mov    (%eax),%eax
  8017a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017ab:	8b 52 04             	mov    0x4(%edx),%edx
  8017ae:	89 50 04             	mov    %edx,0x4(%eax)
  8017b1:	eb 0b                	jmp    8017be <free+0x7e>
  8017b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017b6:	8b 40 04             	mov    0x4(%eax),%eax
  8017b9:	a3 44 50 80 00       	mov    %eax,0x805044
  8017be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017c1:	8b 40 04             	mov    0x4(%eax),%eax
  8017c4:	85 c0                	test   %eax,%eax
  8017c6:	74 0f                	je     8017d7 <free+0x97>
  8017c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017cb:	8b 40 04             	mov    0x4(%eax),%eax
  8017ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017d1:	8b 12                	mov    (%edx),%edx
  8017d3:	89 10                	mov    %edx,(%eax)
  8017d5:	eb 0a                	jmp    8017e1 <free+0xa1>
  8017d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017da:	8b 00                	mov    (%eax),%eax
  8017dc:	a3 40 50 80 00       	mov    %eax,0x805040
  8017e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8017ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8017f4:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8017f9:	48                   	dec    %eax
  8017fa:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(free_block);
  8017ff:	83 ec 0c             	sub    $0xc,%esp
  801802:	ff 75 f4             	pushl  -0xc(%ebp)
  801805:	e8 4e 17 00 00       	call   802f58 <insert_sorted_with_merge_freeList>
  80180a:	83 c4 10             	add    $0x10,%esp
	}

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  80180d:	90                   	nop
  80180e:	c9                   	leave  
  80180f:	c3                   	ret    

00801810 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801810:	55                   	push   %ebp
  801811:	89 e5                	mov    %esp,%ebp
  801813:	83 ec 38             	sub    $0x38,%esp
  801816:	8b 45 10             	mov    0x10(%ebp),%eax
  801819:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80181c:	e8 a6 fc ff ff       	call   8014c7 <InitializeUHeap>
	if (size == 0) return NULL ;
  801821:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801825:	75 0a                	jne    801831 <smalloc+0x21>
  801827:	b8 00 00 00 00       	mov    $0x0,%eax
  80182c:	e9 8b 00 00 00       	jmp    8018bc <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801831:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801838:	8b 55 0c             	mov    0xc(%ebp),%edx
  80183b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80183e:	01 d0                	add    %edx,%eax
  801840:	48                   	dec    %eax
  801841:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801844:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801847:	ba 00 00 00 00       	mov    $0x0,%edx
  80184c:	f7 75 f0             	divl   -0x10(%ebp)
  80184f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801852:	29 d0                	sub    %edx,%eax
  801854:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801857:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80185e:	e8 d0 06 00 00       	call   801f33 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801863:	85 c0                	test   %eax,%eax
  801865:	74 11                	je     801878 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801867:	83 ec 0c             	sub    $0xc,%esp
  80186a:	ff 75 e8             	pushl  -0x18(%ebp)
  80186d:	e8 3b 0d 00 00       	call   8025ad <alloc_block_FF>
  801872:	83 c4 10             	add    $0x10,%esp
  801875:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  801878:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80187c:	74 39                	je     8018b7 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  80187e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801881:	8b 40 08             	mov    0x8(%eax),%eax
  801884:	89 c2                	mov    %eax,%edx
  801886:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80188a:	52                   	push   %edx
  80188b:	50                   	push   %eax
  80188c:	ff 75 0c             	pushl  0xc(%ebp)
  80188f:	ff 75 08             	pushl  0x8(%ebp)
  801892:	e8 21 04 00 00       	call   801cb8 <sys_createSharedObject>
  801897:	83 c4 10             	add    $0x10,%esp
  80189a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  80189d:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8018a1:	74 14                	je     8018b7 <smalloc+0xa7>
  8018a3:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8018a7:	74 0e                	je     8018b7 <smalloc+0xa7>
  8018a9:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  8018ad:	74 08                	je     8018b7 <smalloc+0xa7>
			return (void*) mem_block->sva;
  8018af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018b2:	8b 40 08             	mov    0x8(%eax),%eax
  8018b5:	eb 05                	jmp    8018bc <smalloc+0xac>
	}
	return NULL;
  8018b7:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8018bc:	c9                   	leave  
  8018bd:	c3                   	ret    

008018be <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
  8018c1:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018c4:	e8 fe fb ff ff       	call   8014c7 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8018c9:	83 ec 08             	sub    $0x8,%esp
  8018cc:	ff 75 0c             	pushl  0xc(%ebp)
  8018cf:	ff 75 08             	pushl  0x8(%ebp)
  8018d2:	e8 0b 04 00 00       	call   801ce2 <sys_getSizeOfSharedObject>
  8018d7:	83 c4 10             	add    $0x10,%esp
  8018da:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  8018dd:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  8018e1:	74 76                	je     801959 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8018e3:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8018ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018f0:	01 d0                	add    %edx,%eax
  8018f2:	48                   	dec    %eax
  8018f3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8018f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8018fe:	f7 75 ec             	divl   -0x14(%ebp)
  801901:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801904:	29 d0                	sub    %edx,%eax
  801906:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801909:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801910:	e8 1e 06 00 00       	call   801f33 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801915:	85 c0                	test   %eax,%eax
  801917:	74 11                	je     80192a <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801919:	83 ec 0c             	sub    $0xc,%esp
  80191c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80191f:	e8 89 0c 00 00       	call   8025ad <alloc_block_FF>
  801924:	83 c4 10             	add    $0x10,%esp
  801927:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  80192a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80192e:	74 29                	je     801959 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801930:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801933:	8b 40 08             	mov    0x8(%eax),%eax
  801936:	83 ec 04             	sub    $0x4,%esp
  801939:	50                   	push   %eax
  80193a:	ff 75 0c             	pushl  0xc(%ebp)
  80193d:	ff 75 08             	pushl  0x8(%ebp)
  801940:	e8 ba 03 00 00       	call   801cff <sys_getSharedObject>
  801945:	83 c4 10             	add    $0x10,%esp
  801948:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  80194b:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  80194f:	74 08                	je     801959 <sget+0x9b>
				return (void *)mem_block->sva;
  801951:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801954:	8b 40 08             	mov    0x8(%eax),%eax
  801957:	eb 05                	jmp    80195e <sget+0xa0>
		}
	}
	return NULL;
  801959:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80195e:	c9                   	leave  
  80195f:	c3                   	ret    

00801960 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801960:	55                   	push   %ebp
  801961:	89 e5                	mov    %esp,%ebp
  801963:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801966:	e8 5c fb ff ff       	call   8014c7 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80196b:	83 ec 04             	sub    $0x4,%esp
  80196e:	68 44 40 80 00       	push   $0x804044
  801973:	68 f7 00 00 00       	push   $0xf7
  801978:	68 13 40 80 00       	push   $0x804013
  80197d:	e8 22 1d 00 00       	call   8036a4 <_panic>

00801982 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801982:	55                   	push   %ebp
  801983:	89 e5                	mov    %esp,%ebp
  801985:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()


	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801988:	83 ec 04             	sub    $0x4,%esp
  80198b:	68 6c 40 80 00       	push   $0x80406c
  801990:	68 0c 01 00 00       	push   $0x10c
  801995:	68 13 40 80 00       	push   $0x804013
  80199a:	e8 05 1d 00 00       	call   8036a4 <_panic>

0080199f <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80199f:	55                   	push   %ebp
  8019a0:	89 e5                	mov    %esp,%ebp
  8019a2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019a5:	83 ec 04             	sub    $0x4,%esp
  8019a8:	68 90 40 80 00       	push   $0x804090
  8019ad:	68 44 01 00 00       	push   $0x144
  8019b2:	68 13 40 80 00       	push   $0x804013
  8019b7:	e8 e8 1c 00 00       	call   8036a4 <_panic>

008019bc <shrink>:

}
void shrink(uint32 newSize)
{
  8019bc:	55                   	push   %ebp
  8019bd:	89 e5                	mov    %esp,%ebp
  8019bf:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019c2:	83 ec 04             	sub    $0x4,%esp
  8019c5:	68 90 40 80 00       	push   $0x804090
  8019ca:	68 49 01 00 00       	push   $0x149
  8019cf:	68 13 40 80 00       	push   $0x804013
  8019d4:	e8 cb 1c 00 00       	call   8036a4 <_panic>

008019d9 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8019d9:	55                   	push   %ebp
  8019da:	89 e5                	mov    %esp,%ebp
  8019dc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019df:	83 ec 04             	sub    $0x4,%esp
  8019e2:	68 90 40 80 00       	push   $0x804090
  8019e7:	68 4e 01 00 00       	push   $0x14e
  8019ec:	68 13 40 80 00       	push   $0x804013
  8019f1:	e8 ae 1c 00 00       	call   8036a4 <_panic>

008019f6 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8019f6:	55                   	push   %ebp
  8019f7:	89 e5                	mov    %esp,%ebp
  8019f9:	57                   	push   %edi
  8019fa:	56                   	push   %esi
  8019fb:	53                   	push   %ebx
  8019fc:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801a02:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a05:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a08:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a0b:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a0e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a11:	cd 30                	int    $0x30
  801a13:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a16:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a19:	83 c4 10             	add    $0x10,%esp
  801a1c:	5b                   	pop    %ebx
  801a1d:	5e                   	pop    %esi
  801a1e:	5f                   	pop    %edi
  801a1f:	5d                   	pop    %ebp
  801a20:	c3                   	ret    

00801a21 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a21:	55                   	push   %ebp
  801a22:	89 e5                	mov    %esp,%ebp
  801a24:	83 ec 04             	sub    $0x4,%esp
  801a27:	8b 45 10             	mov    0x10(%ebp),%eax
  801a2a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801a2d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a31:	8b 45 08             	mov    0x8(%ebp),%eax
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	52                   	push   %edx
  801a39:	ff 75 0c             	pushl  0xc(%ebp)
  801a3c:	50                   	push   %eax
  801a3d:	6a 00                	push   $0x0
  801a3f:	e8 b2 ff ff ff       	call   8019f6 <syscall>
  801a44:	83 c4 18             	add    $0x18,%esp
}
  801a47:	90                   	nop
  801a48:	c9                   	leave  
  801a49:	c3                   	ret    

00801a4a <sys_cgetc>:

int
sys_cgetc(void)
{
  801a4a:	55                   	push   %ebp
  801a4b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	6a 01                	push   $0x1
  801a59:	e8 98 ff ff ff       	call   8019f6 <syscall>
  801a5e:	83 c4 18             	add    $0x18,%esp
}
  801a61:	c9                   	leave  
  801a62:	c3                   	ret    

00801a63 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a66:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a69:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	52                   	push   %edx
  801a73:	50                   	push   %eax
  801a74:	6a 05                	push   $0x5
  801a76:	e8 7b ff ff ff       	call   8019f6 <syscall>
  801a7b:	83 c4 18             	add    $0x18,%esp
}
  801a7e:	c9                   	leave  
  801a7f:	c3                   	ret    

00801a80 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a80:	55                   	push   %ebp
  801a81:	89 e5                	mov    %esp,%ebp
  801a83:	56                   	push   %esi
  801a84:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a85:	8b 75 18             	mov    0x18(%ebp),%esi
  801a88:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a8b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a91:	8b 45 08             	mov    0x8(%ebp),%eax
  801a94:	56                   	push   %esi
  801a95:	53                   	push   %ebx
  801a96:	51                   	push   %ecx
  801a97:	52                   	push   %edx
  801a98:	50                   	push   %eax
  801a99:	6a 06                	push   $0x6
  801a9b:	e8 56 ff ff ff       	call   8019f6 <syscall>
  801aa0:	83 c4 18             	add    $0x18,%esp
}
  801aa3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aa6:	5b                   	pop    %ebx
  801aa7:	5e                   	pop    %esi
  801aa8:	5d                   	pop    %ebp
  801aa9:	c3                   	ret    

00801aaa <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801aaa:	55                   	push   %ebp
  801aab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801aad:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	52                   	push   %edx
  801aba:	50                   	push   %eax
  801abb:	6a 07                	push   $0x7
  801abd:	e8 34 ff ff ff       	call   8019f6 <syscall>
  801ac2:	83 c4 18             	add    $0x18,%esp
}
  801ac5:	c9                   	leave  
  801ac6:	c3                   	ret    

00801ac7 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801ac7:	55                   	push   %ebp
  801ac8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	ff 75 0c             	pushl  0xc(%ebp)
  801ad3:	ff 75 08             	pushl  0x8(%ebp)
  801ad6:	6a 08                	push   $0x8
  801ad8:	e8 19 ff ff ff       	call   8019f6 <syscall>
  801add:	83 c4 18             	add    $0x18,%esp
}
  801ae0:	c9                   	leave  
  801ae1:	c3                   	ret    

00801ae2 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801ae2:	55                   	push   %ebp
  801ae3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	6a 09                	push   $0x9
  801af1:	e8 00 ff ff ff       	call   8019f6 <syscall>
  801af6:	83 c4 18             	add    $0x18,%esp
}
  801af9:	c9                   	leave  
  801afa:	c3                   	ret    

00801afb <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801afb:	55                   	push   %ebp
  801afc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	6a 0a                	push   $0xa
  801b0a:	e8 e7 fe ff ff       	call   8019f6 <syscall>
  801b0f:	83 c4 18             	add    $0x18,%esp
}
  801b12:	c9                   	leave  
  801b13:	c3                   	ret    

00801b14 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801b14:	55                   	push   %ebp
  801b15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 0b                	push   $0xb
  801b23:	e8 ce fe ff ff       	call   8019f6 <syscall>
  801b28:	83 c4 18             	add    $0x18,%esp
}
  801b2b:	c9                   	leave  
  801b2c:	c3                   	ret    

00801b2d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b2d:	55                   	push   %ebp
  801b2e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	ff 75 0c             	pushl  0xc(%ebp)
  801b39:	ff 75 08             	pushl  0x8(%ebp)
  801b3c:	6a 0f                	push   $0xf
  801b3e:	e8 b3 fe ff ff       	call   8019f6 <syscall>
  801b43:	83 c4 18             	add    $0x18,%esp
	return;
  801b46:	90                   	nop
}
  801b47:	c9                   	leave  
  801b48:	c3                   	ret    

00801b49 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b49:	55                   	push   %ebp
  801b4a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	ff 75 0c             	pushl  0xc(%ebp)
  801b55:	ff 75 08             	pushl  0x8(%ebp)
  801b58:	6a 10                	push   $0x10
  801b5a:	e8 97 fe ff ff       	call   8019f6 <syscall>
  801b5f:	83 c4 18             	add    $0x18,%esp
	return ;
  801b62:	90                   	nop
}
  801b63:	c9                   	leave  
  801b64:	c3                   	ret    

00801b65 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b65:	55                   	push   %ebp
  801b66:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	ff 75 10             	pushl  0x10(%ebp)
  801b6f:	ff 75 0c             	pushl  0xc(%ebp)
  801b72:	ff 75 08             	pushl  0x8(%ebp)
  801b75:	6a 11                	push   $0x11
  801b77:	e8 7a fe ff ff       	call   8019f6 <syscall>
  801b7c:	83 c4 18             	add    $0x18,%esp
	return ;
  801b7f:	90                   	nop
}
  801b80:	c9                   	leave  
  801b81:	c3                   	ret    

00801b82 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801b82:	55                   	push   %ebp
  801b83:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 0c                	push   $0xc
  801b91:	e8 60 fe ff ff       	call   8019f6 <syscall>
  801b96:	83 c4 18             	add    $0x18,%esp
}
  801b99:	c9                   	leave  
  801b9a:	c3                   	ret    

00801b9b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801b9b:	55                   	push   %ebp
  801b9c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	ff 75 08             	pushl  0x8(%ebp)
  801ba9:	6a 0d                	push   $0xd
  801bab:	e8 46 fe ff ff       	call   8019f6 <syscall>
  801bb0:	83 c4 18             	add    $0x18,%esp
}
  801bb3:	c9                   	leave  
  801bb4:	c3                   	ret    

00801bb5 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801bb5:	55                   	push   %ebp
  801bb6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 0e                	push   $0xe
  801bc4:	e8 2d fe ff ff       	call   8019f6 <syscall>
  801bc9:	83 c4 18             	add    $0x18,%esp
}
  801bcc:	90                   	nop
  801bcd:	c9                   	leave  
  801bce:	c3                   	ret    

00801bcf <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801bcf:	55                   	push   %ebp
  801bd0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 13                	push   $0x13
  801bde:	e8 13 fe ff ff       	call   8019f6 <syscall>
  801be3:	83 c4 18             	add    $0x18,%esp
}
  801be6:	90                   	nop
  801be7:	c9                   	leave  
  801be8:	c3                   	ret    

00801be9 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801be9:	55                   	push   %ebp
  801bea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 14                	push   $0x14
  801bf8:	e8 f9 fd ff ff       	call   8019f6 <syscall>
  801bfd:	83 c4 18             	add    $0x18,%esp
}
  801c00:	90                   	nop
  801c01:	c9                   	leave  
  801c02:	c3                   	ret    

00801c03 <sys_cputc>:


void
sys_cputc(const char c)
{
  801c03:	55                   	push   %ebp
  801c04:	89 e5                	mov    %esp,%ebp
  801c06:	83 ec 04             	sub    $0x4,%esp
  801c09:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c0f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	50                   	push   %eax
  801c1c:	6a 15                	push   $0x15
  801c1e:	e8 d3 fd ff ff       	call   8019f6 <syscall>
  801c23:	83 c4 18             	add    $0x18,%esp
}
  801c26:	90                   	nop
  801c27:	c9                   	leave  
  801c28:	c3                   	ret    

00801c29 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c29:	55                   	push   %ebp
  801c2a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 16                	push   $0x16
  801c38:	e8 b9 fd ff ff       	call   8019f6 <syscall>
  801c3d:	83 c4 18             	add    $0x18,%esp
}
  801c40:	90                   	nop
  801c41:	c9                   	leave  
  801c42:	c3                   	ret    

00801c43 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801c43:	55                   	push   %ebp
  801c44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801c46:	8b 45 08             	mov    0x8(%ebp),%eax
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	ff 75 0c             	pushl  0xc(%ebp)
  801c52:	50                   	push   %eax
  801c53:	6a 17                	push   $0x17
  801c55:	e8 9c fd ff ff       	call   8019f6 <syscall>
  801c5a:	83 c4 18             	add    $0x18,%esp
}
  801c5d:	c9                   	leave  
  801c5e:	c3                   	ret    

00801c5f <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801c5f:	55                   	push   %ebp
  801c60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c62:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c65:	8b 45 08             	mov    0x8(%ebp),%eax
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	52                   	push   %edx
  801c6f:	50                   	push   %eax
  801c70:	6a 1a                	push   $0x1a
  801c72:	e8 7f fd ff ff       	call   8019f6 <syscall>
  801c77:	83 c4 18             	add    $0x18,%esp
}
  801c7a:	c9                   	leave  
  801c7b:	c3                   	ret    

00801c7c <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c7c:	55                   	push   %ebp
  801c7d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c82:	8b 45 08             	mov    0x8(%ebp),%eax
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	52                   	push   %edx
  801c8c:	50                   	push   %eax
  801c8d:	6a 18                	push   $0x18
  801c8f:	e8 62 fd ff ff       	call   8019f6 <syscall>
  801c94:	83 c4 18             	add    $0x18,%esp
}
  801c97:	90                   	nop
  801c98:	c9                   	leave  
  801c99:	c3                   	ret    

00801c9a <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c9a:	55                   	push   %ebp
  801c9b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	52                   	push   %edx
  801caa:	50                   	push   %eax
  801cab:	6a 19                	push   $0x19
  801cad:	e8 44 fd ff ff       	call   8019f6 <syscall>
  801cb2:	83 c4 18             	add    $0x18,%esp
}
  801cb5:	90                   	nop
  801cb6:	c9                   	leave  
  801cb7:	c3                   	ret    

00801cb8 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801cb8:	55                   	push   %ebp
  801cb9:	89 e5                	mov    %esp,%ebp
  801cbb:	83 ec 04             	sub    $0x4,%esp
  801cbe:	8b 45 10             	mov    0x10(%ebp),%eax
  801cc1:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801cc4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801cc7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cce:	6a 00                	push   $0x0
  801cd0:	51                   	push   %ecx
  801cd1:	52                   	push   %edx
  801cd2:	ff 75 0c             	pushl  0xc(%ebp)
  801cd5:	50                   	push   %eax
  801cd6:	6a 1b                	push   $0x1b
  801cd8:	e8 19 fd ff ff       	call   8019f6 <syscall>
  801cdd:	83 c4 18             	add    $0x18,%esp
}
  801ce0:	c9                   	leave  
  801ce1:	c3                   	ret    

00801ce2 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ce2:	55                   	push   %ebp
  801ce3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ce5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	52                   	push   %edx
  801cf2:	50                   	push   %eax
  801cf3:	6a 1c                	push   $0x1c
  801cf5:	e8 fc fc ff ff       	call   8019f6 <syscall>
  801cfa:	83 c4 18             	add    $0x18,%esp
}
  801cfd:	c9                   	leave  
  801cfe:	c3                   	ret    

00801cff <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801cff:	55                   	push   %ebp
  801d00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d02:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d05:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d08:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 00                	push   $0x0
  801d0f:	51                   	push   %ecx
  801d10:	52                   	push   %edx
  801d11:	50                   	push   %eax
  801d12:	6a 1d                	push   $0x1d
  801d14:	e8 dd fc ff ff       	call   8019f6 <syscall>
  801d19:	83 c4 18             	add    $0x18,%esp
}
  801d1c:	c9                   	leave  
  801d1d:	c3                   	ret    

00801d1e <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d1e:	55                   	push   %ebp
  801d1f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d21:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d24:	8b 45 08             	mov    0x8(%ebp),%eax
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	52                   	push   %edx
  801d2e:	50                   	push   %eax
  801d2f:	6a 1e                	push   $0x1e
  801d31:	e8 c0 fc ff ff       	call   8019f6 <syscall>
  801d36:	83 c4 18             	add    $0x18,%esp
}
  801d39:	c9                   	leave  
  801d3a:	c3                   	ret    

00801d3b <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801d3b:	55                   	push   %ebp
  801d3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	6a 1f                	push   $0x1f
  801d4a:	e8 a7 fc ff ff       	call   8019f6 <syscall>
  801d4f:	83 c4 18             	add    $0x18,%esp
}
  801d52:	c9                   	leave  
  801d53:	c3                   	ret    

00801d54 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d54:	55                   	push   %ebp
  801d55:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d57:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5a:	6a 00                	push   $0x0
  801d5c:	ff 75 14             	pushl  0x14(%ebp)
  801d5f:	ff 75 10             	pushl  0x10(%ebp)
  801d62:	ff 75 0c             	pushl  0xc(%ebp)
  801d65:	50                   	push   %eax
  801d66:	6a 20                	push   $0x20
  801d68:	e8 89 fc ff ff       	call   8019f6 <syscall>
  801d6d:	83 c4 18             	add    $0x18,%esp
}
  801d70:	c9                   	leave  
  801d71:	c3                   	ret    

00801d72 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801d72:	55                   	push   %ebp
  801d73:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d75:	8b 45 08             	mov    0x8(%ebp),%eax
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	50                   	push   %eax
  801d81:	6a 21                	push   $0x21
  801d83:	e8 6e fc ff ff       	call   8019f6 <syscall>
  801d88:	83 c4 18             	add    $0x18,%esp
}
  801d8b:	90                   	nop
  801d8c:	c9                   	leave  
  801d8d:	c3                   	ret    

00801d8e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801d8e:	55                   	push   %ebp
  801d8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801d91:	8b 45 08             	mov    0x8(%ebp),%eax
  801d94:	6a 00                	push   $0x0
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 00                	push   $0x0
  801d9c:	50                   	push   %eax
  801d9d:	6a 22                	push   $0x22
  801d9f:	e8 52 fc ff ff       	call   8019f6 <syscall>
  801da4:	83 c4 18             	add    $0x18,%esp
}
  801da7:	c9                   	leave  
  801da8:	c3                   	ret    

00801da9 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801da9:	55                   	push   %ebp
  801daa:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 00                	push   $0x0
  801db4:	6a 00                	push   $0x0
  801db6:	6a 02                	push   $0x2
  801db8:	e8 39 fc ff ff       	call   8019f6 <syscall>
  801dbd:	83 c4 18             	add    $0x18,%esp
}
  801dc0:	c9                   	leave  
  801dc1:	c3                   	ret    

00801dc2 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801dc2:	55                   	push   %ebp
  801dc3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 03                	push   $0x3
  801dd1:	e8 20 fc ff ff       	call   8019f6 <syscall>
  801dd6:	83 c4 18             	add    $0x18,%esp
}
  801dd9:	c9                   	leave  
  801dda:	c3                   	ret    

00801ddb <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ddb:	55                   	push   %ebp
  801ddc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	6a 00                	push   $0x0
  801de6:	6a 00                	push   $0x0
  801de8:	6a 04                	push   $0x4
  801dea:	e8 07 fc ff ff       	call   8019f6 <syscall>
  801def:	83 c4 18             	add    $0x18,%esp
}
  801df2:	c9                   	leave  
  801df3:	c3                   	ret    

00801df4 <sys_exit_env>:


void sys_exit_env(void)
{
  801df4:	55                   	push   %ebp
  801df5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 00                	push   $0x0
  801e01:	6a 23                	push   $0x23
  801e03:	e8 ee fb ff ff       	call   8019f6 <syscall>
  801e08:	83 c4 18             	add    $0x18,%esp
}
  801e0b:	90                   	nop
  801e0c:	c9                   	leave  
  801e0d:	c3                   	ret    

00801e0e <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801e0e:	55                   	push   %ebp
  801e0f:	89 e5                	mov    %esp,%ebp
  801e11:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e14:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e17:	8d 50 04             	lea    0x4(%eax),%edx
  801e1a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e1d:	6a 00                	push   $0x0
  801e1f:	6a 00                	push   $0x0
  801e21:	6a 00                	push   $0x0
  801e23:	52                   	push   %edx
  801e24:	50                   	push   %eax
  801e25:	6a 24                	push   $0x24
  801e27:	e8 ca fb ff ff       	call   8019f6 <syscall>
  801e2c:	83 c4 18             	add    $0x18,%esp
	return result;
  801e2f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e32:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e35:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e38:	89 01                	mov    %eax,(%ecx)
  801e3a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e40:	c9                   	leave  
  801e41:	c2 04 00             	ret    $0x4

00801e44 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e44:	55                   	push   %ebp
  801e45:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e47:	6a 00                	push   $0x0
  801e49:	6a 00                	push   $0x0
  801e4b:	ff 75 10             	pushl  0x10(%ebp)
  801e4e:	ff 75 0c             	pushl  0xc(%ebp)
  801e51:	ff 75 08             	pushl  0x8(%ebp)
  801e54:	6a 12                	push   $0x12
  801e56:	e8 9b fb ff ff       	call   8019f6 <syscall>
  801e5b:	83 c4 18             	add    $0x18,%esp
	return ;
  801e5e:	90                   	nop
}
  801e5f:	c9                   	leave  
  801e60:	c3                   	ret    

00801e61 <sys_rcr2>:
uint32 sys_rcr2()
{
  801e61:	55                   	push   %ebp
  801e62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	6a 00                	push   $0x0
  801e6e:	6a 25                	push   $0x25
  801e70:	e8 81 fb ff ff       	call   8019f6 <syscall>
  801e75:	83 c4 18             	add    $0x18,%esp
}
  801e78:	c9                   	leave  
  801e79:	c3                   	ret    

00801e7a <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801e7a:	55                   	push   %ebp
  801e7b:	89 e5                	mov    %esp,%ebp
  801e7d:	83 ec 04             	sub    $0x4,%esp
  801e80:	8b 45 08             	mov    0x8(%ebp),%eax
  801e83:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e86:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e8a:	6a 00                	push   $0x0
  801e8c:	6a 00                	push   $0x0
  801e8e:	6a 00                	push   $0x0
  801e90:	6a 00                	push   $0x0
  801e92:	50                   	push   %eax
  801e93:	6a 26                	push   $0x26
  801e95:	e8 5c fb ff ff       	call   8019f6 <syscall>
  801e9a:	83 c4 18             	add    $0x18,%esp
	return ;
  801e9d:	90                   	nop
}
  801e9e:	c9                   	leave  
  801e9f:	c3                   	ret    

00801ea0 <rsttst>:
void rsttst()
{
  801ea0:	55                   	push   %ebp
  801ea1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ea3:	6a 00                	push   $0x0
  801ea5:	6a 00                	push   $0x0
  801ea7:	6a 00                	push   $0x0
  801ea9:	6a 00                	push   $0x0
  801eab:	6a 00                	push   $0x0
  801ead:	6a 28                	push   $0x28
  801eaf:	e8 42 fb ff ff       	call   8019f6 <syscall>
  801eb4:	83 c4 18             	add    $0x18,%esp
	return ;
  801eb7:	90                   	nop
}
  801eb8:	c9                   	leave  
  801eb9:	c3                   	ret    

00801eba <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801eba:	55                   	push   %ebp
  801ebb:	89 e5                	mov    %esp,%ebp
  801ebd:	83 ec 04             	sub    $0x4,%esp
  801ec0:	8b 45 14             	mov    0x14(%ebp),%eax
  801ec3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ec6:	8b 55 18             	mov    0x18(%ebp),%edx
  801ec9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ecd:	52                   	push   %edx
  801ece:	50                   	push   %eax
  801ecf:	ff 75 10             	pushl  0x10(%ebp)
  801ed2:	ff 75 0c             	pushl  0xc(%ebp)
  801ed5:	ff 75 08             	pushl  0x8(%ebp)
  801ed8:	6a 27                	push   $0x27
  801eda:	e8 17 fb ff ff       	call   8019f6 <syscall>
  801edf:	83 c4 18             	add    $0x18,%esp
	return ;
  801ee2:	90                   	nop
}
  801ee3:	c9                   	leave  
  801ee4:	c3                   	ret    

00801ee5 <chktst>:
void chktst(uint32 n)
{
  801ee5:	55                   	push   %ebp
  801ee6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 00                	push   $0x0
  801eec:	6a 00                	push   $0x0
  801eee:	6a 00                	push   $0x0
  801ef0:	ff 75 08             	pushl  0x8(%ebp)
  801ef3:	6a 29                	push   $0x29
  801ef5:	e8 fc fa ff ff       	call   8019f6 <syscall>
  801efa:	83 c4 18             	add    $0x18,%esp
	return ;
  801efd:	90                   	nop
}
  801efe:	c9                   	leave  
  801eff:	c3                   	ret    

00801f00 <inctst>:

void inctst()
{
  801f00:	55                   	push   %ebp
  801f01:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f03:	6a 00                	push   $0x0
  801f05:	6a 00                	push   $0x0
  801f07:	6a 00                	push   $0x0
  801f09:	6a 00                	push   $0x0
  801f0b:	6a 00                	push   $0x0
  801f0d:	6a 2a                	push   $0x2a
  801f0f:	e8 e2 fa ff ff       	call   8019f6 <syscall>
  801f14:	83 c4 18             	add    $0x18,%esp
	return ;
  801f17:	90                   	nop
}
  801f18:	c9                   	leave  
  801f19:	c3                   	ret    

00801f1a <gettst>:
uint32 gettst()
{
  801f1a:	55                   	push   %ebp
  801f1b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f1d:	6a 00                	push   $0x0
  801f1f:	6a 00                	push   $0x0
  801f21:	6a 00                	push   $0x0
  801f23:	6a 00                	push   $0x0
  801f25:	6a 00                	push   $0x0
  801f27:	6a 2b                	push   $0x2b
  801f29:	e8 c8 fa ff ff       	call   8019f6 <syscall>
  801f2e:	83 c4 18             	add    $0x18,%esp
}
  801f31:	c9                   	leave  
  801f32:	c3                   	ret    

00801f33 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f33:	55                   	push   %ebp
  801f34:	89 e5                	mov    %esp,%ebp
  801f36:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f39:	6a 00                	push   $0x0
  801f3b:	6a 00                	push   $0x0
  801f3d:	6a 00                	push   $0x0
  801f3f:	6a 00                	push   $0x0
  801f41:	6a 00                	push   $0x0
  801f43:	6a 2c                	push   $0x2c
  801f45:	e8 ac fa ff ff       	call   8019f6 <syscall>
  801f4a:	83 c4 18             	add    $0x18,%esp
  801f4d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f50:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f54:	75 07                	jne    801f5d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f56:	b8 01 00 00 00       	mov    $0x1,%eax
  801f5b:	eb 05                	jmp    801f62 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f62:	c9                   	leave  
  801f63:	c3                   	ret    

00801f64 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f64:	55                   	push   %ebp
  801f65:	89 e5                	mov    %esp,%ebp
  801f67:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 00                	push   $0x0
  801f6e:	6a 00                	push   $0x0
  801f70:	6a 00                	push   $0x0
  801f72:	6a 00                	push   $0x0
  801f74:	6a 2c                	push   $0x2c
  801f76:	e8 7b fa ff ff       	call   8019f6 <syscall>
  801f7b:	83 c4 18             	add    $0x18,%esp
  801f7e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f81:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f85:	75 07                	jne    801f8e <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f87:	b8 01 00 00 00       	mov    $0x1,%eax
  801f8c:	eb 05                	jmp    801f93 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f93:	c9                   	leave  
  801f94:	c3                   	ret    

00801f95 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801f95:	55                   	push   %ebp
  801f96:	89 e5                	mov    %esp,%ebp
  801f98:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f9b:	6a 00                	push   $0x0
  801f9d:	6a 00                	push   $0x0
  801f9f:	6a 00                	push   $0x0
  801fa1:	6a 00                	push   $0x0
  801fa3:	6a 00                	push   $0x0
  801fa5:	6a 2c                	push   $0x2c
  801fa7:	e8 4a fa ff ff       	call   8019f6 <syscall>
  801fac:	83 c4 18             	add    $0x18,%esp
  801faf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801fb2:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801fb6:	75 07                	jne    801fbf <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801fb8:	b8 01 00 00 00       	mov    $0x1,%eax
  801fbd:	eb 05                	jmp    801fc4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801fbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fc4:	c9                   	leave  
  801fc5:	c3                   	ret    

00801fc6 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801fc6:	55                   	push   %ebp
  801fc7:	89 e5                	mov    %esp,%ebp
  801fc9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fcc:	6a 00                	push   $0x0
  801fce:	6a 00                	push   $0x0
  801fd0:	6a 00                	push   $0x0
  801fd2:	6a 00                	push   $0x0
  801fd4:	6a 00                	push   $0x0
  801fd6:	6a 2c                	push   $0x2c
  801fd8:	e8 19 fa ff ff       	call   8019f6 <syscall>
  801fdd:	83 c4 18             	add    $0x18,%esp
  801fe0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801fe3:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801fe7:	75 07                	jne    801ff0 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801fe9:	b8 01 00 00 00       	mov    $0x1,%eax
  801fee:	eb 05                	jmp    801ff5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ff0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ff5:	c9                   	leave  
  801ff6:	c3                   	ret    

00801ff7 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ff7:	55                   	push   %ebp
  801ff8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ffa:	6a 00                	push   $0x0
  801ffc:	6a 00                	push   $0x0
  801ffe:	6a 00                	push   $0x0
  802000:	6a 00                	push   $0x0
  802002:	ff 75 08             	pushl  0x8(%ebp)
  802005:	6a 2d                	push   $0x2d
  802007:	e8 ea f9 ff ff       	call   8019f6 <syscall>
  80200c:	83 c4 18             	add    $0x18,%esp
	return ;
  80200f:	90                   	nop
}
  802010:	c9                   	leave  
  802011:	c3                   	ret    

00802012 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802012:	55                   	push   %ebp
  802013:	89 e5                	mov    %esp,%ebp
  802015:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802016:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802019:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80201c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80201f:	8b 45 08             	mov    0x8(%ebp),%eax
  802022:	6a 00                	push   $0x0
  802024:	53                   	push   %ebx
  802025:	51                   	push   %ecx
  802026:	52                   	push   %edx
  802027:	50                   	push   %eax
  802028:	6a 2e                	push   $0x2e
  80202a:	e8 c7 f9 ff ff       	call   8019f6 <syscall>
  80202f:	83 c4 18             	add    $0x18,%esp
}
  802032:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802035:	c9                   	leave  
  802036:	c3                   	ret    

00802037 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802037:	55                   	push   %ebp
  802038:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80203a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80203d:	8b 45 08             	mov    0x8(%ebp),%eax
  802040:	6a 00                	push   $0x0
  802042:	6a 00                	push   $0x0
  802044:	6a 00                	push   $0x0
  802046:	52                   	push   %edx
  802047:	50                   	push   %eax
  802048:	6a 2f                	push   $0x2f
  80204a:	e8 a7 f9 ff ff       	call   8019f6 <syscall>
  80204f:	83 c4 18             	add    $0x18,%esp
}
  802052:	c9                   	leave  
  802053:	c3                   	ret    

00802054 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802054:	55                   	push   %ebp
  802055:	89 e5                	mov    %esp,%ebp
  802057:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80205a:	83 ec 0c             	sub    $0xc,%esp
  80205d:	68 a0 40 80 00       	push   $0x8040a0
  802062:	e8 d6 e6 ff ff       	call   80073d <cprintf>
  802067:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80206a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802071:	83 ec 0c             	sub    $0xc,%esp
  802074:	68 cc 40 80 00       	push   $0x8040cc
  802079:	e8 bf e6 ff ff       	call   80073d <cprintf>
  80207e:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802081:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802085:	a1 38 51 80 00       	mov    0x805138,%eax
  80208a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80208d:	eb 56                	jmp    8020e5 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80208f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802093:	74 1c                	je     8020b1 <print_mem_block_lists+0x5d>
  802095:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802098:	8b 50 08             	mov    0x8(%eax),%edx
  80209b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80209e:	8b 48 08             	mov    0x8(%eax),%ecx
  8020a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8020a7:	01 c8                	add    %ecx,%eax
  8020a9:	39 c2                	cmp    %eax,%edx
  8020ab:	73 04                	jae    8020b1 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8020ad:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8020b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b4:	8b 50 08             	mov    0x8(%eax),%edx
  8020b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8020bd:	01 c2                	add    %eax,%edx
  8020bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c2:	8b 40 08             	mov    0x8(%eax),%eax
  8020c5:	83 ec 04             	sub    $0x4,%esp
  8020c8:	52                   	push   %edx
  8020c9:	50                   	push   %eax
  8020ca:	68 e1 40 80 00       	push   $0x8040e1
  8020cf:	e8 69 e6 ff ff       	call   80073d <cprintf>
  8020d4:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8020d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020da:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8020dd:	a1 40 51 80 00       	mov    0x805140,%eax
  8020e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020e9:	74 07                	je     8020f2 <print_mem_block_lists+0x9e>
  8020eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ee:	8b 00                	mov    (%eax),%eax
  8020f0:	eb 05                	jmp    8020f7 <print_mem_block_lists+0xa3>
  8020f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f7:	a3 40 51 80 00       	mov    %eax,0x805140
  8020fc:	a1 40 51 80 00       	mov    0x805140,%eax
  802101:	85 c0                	test   %eax,%eax
  802103:	75 8a                	jne    80208f <print_mem_block_lists+0x3b>
  802105:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802109:	75 84                	jne    80208f <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80210b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80210f:	75 10                	jne    802121 <print_mem_block_lists+0xcd>
  802111:	83 ec 0c             	sub    $0xc,%esp
  802114:	68 f0 40 80 00       	push   $0x8040f0
  802119:	e8 1f e6 ff ff       	call   80073d <cprintf>
  80211e:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802121:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802128:	83 ec 0c             	sub    $0xc,%esp
  80212b:	68 14 41 80 00       	push   $0x804114
  802130:	e8 08 e6 ff ff       	call   80073d <cprintf>
  802135:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802138:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80213c:	a1 40 50 80 00       	mov    0x805040,%eax
  802141:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802144:	eb 56                	jmp    80219c <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802146:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80214a:	74 1c                	je     802168 <print_mem_block_lists+0x114>
  80214c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214f:	8b 50 08             	mov    0x8(%eax),%edx
  802152:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802155:	8b 48 08             	mov    0x8(%eax),%ecx
  802158:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80215b:	8b 40 0c             	mov    0xc(%eax),%eax
  80215e:	01 c8                	add    %ecx,%eax
  802160:	39 c2                	cmp    %eax,%edx
  802162:	73 04                	jae    802168 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802164:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802168:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216b:	8b 50 08             	mov    0x8(%eax),%edx
  80216e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802171:	8b 40 0c             	mov    0xc(%eax),%eax
  802174:	01 c2                	add    %eax,%edx
  802176:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802179:	8b 40 08             	mov    0x8(%eax),%eax
  80217c:	83 ec 04             	sub    $0x4,%esp
  80217f:	52                   	push   %edx
  802180:	50                   	push   %eax
  802181:	68 e1 40 80 00       	push   $0x8040e1
  802186:	e8 b2 e5 ff ff       	call   80073d <cprintf>
  80218b:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80218e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802191:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802194:	a1 48 50 80 00       	mov    0x805048,%eax
  802199:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80219c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021a0:	74 07                	je     8021a9 <print_mem_block_lists+0x155>
  8021a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a5:	8b 00                	mov    (%eax),%eax
  8021a7:	eb 05                	jmp    8021ae <print_mem_block_lists+0x15a>
  8021a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ae:	a3 48 50 80 00       	mov    %eax,0x805048
  8021b3:	a1 48 50 80 00       	mov    0x805048,%eax
  8021b8:	85 c0                	test   %eax,%eax
  8021ba:	75 8a                	jne    802146 <print_mem_block_lists+0xf2>
  8021bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021c0:	75 84                	jne    802146 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8021c2:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8021c6:	75 10                	jne    8021d8 <print_mem_block_lists+0x184>
  8021c8:	83 ec 0c             	sub    $0xc,%esp
  8021cb:	68 2c 41 80 00       	push   $0x80412c
  8021d0:	e8 68 e5 ff ff       	call   80073d <cprintf>
  8021d5:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8021d8:	83 ec 0c             	sub    $0xc,%esp
  8021db:	68 a0 40 80 00       	push   $0x8040a0
  8021e0:	e8 58 e5 ff ff       	call   80073d <cprintf>
  8021e5:	83 c4 10             	add    $0x10,%esp

}
  8021e8:	90                   	nop
  8021e9:	c9                   	leave  
  8021ea:	c3                   	ret    

008021eb <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8021eb:	55                   	push   %ebp
  8021ec:	89 e5                	mov    %esp,%ebp
  8021ee:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8021f1:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8021f8:	00 00 00 
  8021fb:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802202:	00 00 00 
  802205:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80220c:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  80220f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802216:	e9 9e 00 00 00       	jmp    8022b9 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  80221b:	a1 50 50 80 00       	mov    0x805050,%eax
  802220:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802223:	c1 e2 04             	shl    $0x4,%edx
  802226:	01 d0                	add    %edx,%eax
  802228:	85 c0                	test   %eax,%eax
  80222a:	75 14                	jne    802240 <initialize_MemBlocksList+0x55>
  80222c:	83 ec 04             	sub    $0x4,%esp
  80222f:	68 54 41 80 00       	push   $0x804154
  802234:	6a 46                	push   $0x46
  802236:	68 77 41 80 00       	push   $0x804177
  80223b:	e8 64 14 00 00       	call   8036a4 <_panic>
  802240:	a1 50 50 80 00       	mov    0x805050,%eax
  802245:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802248:	c1 e2 04             	shl    $0x4,%edx
  80224b:	01 d0                	add    %edx,%eax
  80224d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802253:	89 10                	mov    %edx,(%eax)
  802255:	8b 00                	mov    (%eax),%eax
  802257:	85 c0                	test   %eax,%eax
  802259:	74 18                	je     802273 <initialize_MemBlocksList+0x88>
  80225b:	a1 48 51 80 00       	mov    0x805148,%eax
  802260:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802266:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802269:	c1 e1 04             	shl    $0x4,%ecx
  80226c:	01 ca                	add    %ecx,%edx
  80226e:	89 50 04             	mov    %edx,0x4(%eax)
  802271:	eb 12                	jmp    802285 <initialize_MemBlocksList+0x9a>
  802273:	a1 50 50 80 00       	mov    0x805050,%eax
  802278:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80227b:	c1 e2 04             	shl    $0x4,%edx
  80227e:	01 d0                	add    %edx,%eax
  802280:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802285:	a1 50 50 80 00       	mov    0x805050,%eax
  80228a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80228d:	c1 e2 04             	shl    $0x4,%edx
  802290:	01 d0                	add    %edx,%eax
  802292:	a3 48 51 80 00       	mov    %eax,0x805148
  802297:	a1 50 50 80 00       	mov    0x805050,%eax
  80229c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80229f:	c1 e2 04             	shl    $0x4,%edx
  8022a2:	01 d0                	add    %edx,%eax
  8022a4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022ab:	a1 54 51 80 00       	mov    0x805154,%eax
  8022b0:	40                   	inc    %eax
  8022b1:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8022b6:	ff 45 f4             	incl   -0xc(%ebp)
  8022b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022bc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022bf:	0f 82 56 ff ff ff    	jb     80221b <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8022c5:	90                   	nop
  8022c6:	c9                   	leave  
  8022c7:	c3                   	ret    

008022c8 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8022c8:	55                   	push   %ebp
  8022c9:	89 e5                	mov    %esp,%ebp
  8022cb:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8022ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d1:	8b 00                	mov    (%eax),%eax
  8022d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8022d6:	eb 19                	jmp    8022f1 <find_block+0x29>
	{
		if(va==point->sva)
  8022d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022db:	8b 40 08             	mov    0x8(%eax),%eax
  8022de:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8022e1:	75 05                	jne    8022e8 <find_block+0x20>
		   return point;
  8022e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022e6:	eb 36                	jmp    80231e <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8022e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022eb:	8b 40 08             	mov    0x8(%eax),%eax
  8022ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8022f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8022f5:	74 07                	je     8022fe <find_block+0x36>
  8022f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022fa:	8b 00                	mov    (%eax),%eax
  8022fc:	eb 05                	jmp    802303 <find_block+0x3b>
  8022fe:	b8 00 00 00 00       	mov    $0x0,%eax
  802303:	8b 55 08             	mov    0x8(%ebp),%edx
  802306:	89 42 08             	mov    %eax,0x8(%edx)
  802309:	8b 45 08             	mov    0x8(%ebp),%eax
  80230c:	8b 40 08             	mov    0x8(%eax),%eax
  80230f:	85 c0                	test   %eax,%eax
  802311:	75 c5                	jne    8022d8 <find_block+0x10>
  802313:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802317:	75 bf                	jne    8022d8 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802319:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80231e:	c9                   	leave  
  80231f:	c3                   	ret    

00802320 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802320:	55                   	push   %ebp
  802321:	89 e5                	mov    %esp,%ebp
  802323:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802326:	a1 40 50 80 00       	mov    0x805040,%eax
  80232b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  80232e:	a1 44 50 80 00       	mov    0x805044,%eax
  802333:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802336:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802339:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80233c:	74 24                	je     802362 <insert_sorted_allocList+0x42>
  80233e:	8b 45 08             	mov    0x8(%ebp),%eax
  802341:	8b 50 08             	mov    0x8(%eax),%edx
  802344:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802347:	8b 40 08             	mov    0x8(%eax),%eax
  80234a:	39 c2                	cmp    %eax,%edx
  80234c:	76 14                	jbe    802362 <insert_sorted_allocList+0x42>
  80234e:	8b 45 08             	mov    0x8(%ebp),%eax
  802351:	8b 50 08             	mov    0x8(%eax),%edx
  802354:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802357:	8b 40 08             	mov    0x8(%eax),%eax
  80235a:	39 c2                	cmp    %eax,%edx
  80235c:	0f 82 60 01 00 00    	jb     8024c2 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802362:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802366:	75 65                	jne    8023cd <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802368:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80236c:	75 14                	jne    802382 <insert_sorted_allocList+0x62>
  80236e:	83 ec 04             	sub    $0x4,%esp
  802371:	68 54 41 80 00       	push   $0x804154
  802376:	6a 6b                	push   $0x6b
  802378:	68 77 41 80 00       	push   $0x804177
  80237d:	e8 22 13 00 00       	call   8036a4 <_panic>
  802382:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802388:	8b 45 08             	mov    0x8(%ebp),%eax
  80238b:	89 10                	mov    %edx,(%eax)
  80238d:	8b 45 08             	mov    0x8(%ebp),%eax
  802390:	8b 00                	mov    (%eax),%eax
  802392:	85 c0                	test   %eax,%eax
  802394:	74 0d                	je     8023a3 <insert_sorted_allocList+0x83>
  802396:	a1 40 50 80 00       	mov    0x805040,%eax
  80239b:	8b 55 08             	mov    0x8(%ebp),%edx
  80239e:	89 50 04             	mov    %edx,0x4(%eax)
  8023a1:	eb 08                	jmp    8023ab <insert_sorted_allocList+0x8b>
  8023a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a6:	a3 44 50 80 00       	mov    %eax,0x805044
  8023ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ae:	a3 40 50 80 00       	mov    %eax,0x805040
  8023b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023bd:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8023c2:	40                   	inc    %eax
  8023c3:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8023c8:	e9 dc 01 00 00       	jmp    8025a9 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8023cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d0:	8b 50 08             	mov    0x8(%eax),%edx
  8023d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d6:	8b 40 08             	mov    0x8(%eax),%eax
  8023d9:	39 c2                	cmp    %eax,%edx
  8023db:	77 6c                	ja     802449 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8023dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023e1:	74 06                	je     8023e9 <insert_sorted_allocList+0xc9>
  8023e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023e7:	75 14                	jne    8023fd <insert_sorted_allocList+0xdd>
  8023e9:	83 ec 04             	sub    $0x4,%esp
  8023ec:	68 90 41 80 00       	push   $0x804190
  8023f1:	6a 6f                	push   $0x6f
  8023f3:	68 77 41 80 00       	push   $0x804177
  8023f8:	e8 a7 12 00 00       	call   8036a4 <_panic>
  8023fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802400:	8b 50 04             	mov    0x4(%eax),%edx
  802403:	8b 45 08             	mov    0x8(%ebp),%eax
  802406:	89 50 04             	mov    %edx,0x4(%eax)
  802409:	8b 45 08             	mov    0x8(%ebp),%eax
  80240c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80240f:	89 10                	mov    %edx,(%eax)
  802411:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802414:	8b 40 04             	mov    0x4(%eax),%eax
  802417:	85 c0                	test   %eax,%eax
  802419:	74 0d                	je     802428 <insert_sorted_allocList+0x108>
  80241b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80241e:	8b 40 04             	mov    0x4(%eax),%eax
  802421:	8b 55 08             	mov    0x8(%ebp),%edx
  802424:	89 10                	mov    %edx,(%eax)
  802426:	eb 08                	jmp    802430 <insert_sorted_allocList+0x110>
  802428:	8b 45 08             	mov    0x8(%ebp),%eax
  80242b:	a3 40 50 80 00       	mov    %eax,0x805040
  802430:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802433:	8b 55 08             	mov    0x8(%ebp),%edx
  802436:	89 50 04             	mov    %edx,0x4(%eax)
  802439:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80243e:	40                   	inc    %eax
  80243f:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802444:	e9 60 01 00 00       	jmp    8025a9 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802449:	8b 45 08             	mov    0x8(%ebp),%eax
  80244c:	8b 50 08             	mov    0x8(%eax),%edx
  80244f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802452:	8b 40 08             	mov    0x8(%eax),%eax
  802455:	39 c2                	cmp    %eax,%edx
  802457:	0f 82 4c 01 00 00    	jb     8025a9 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80245d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802461:	75 14                	jne    802477 <insert_sorted_allocList+0x157>
  802463:	83 ec 04             	sub    $0x4,%esp
  802466:	68 c8 41 80 00       	push   $0x8041c8
  80246b:	6a 73                	push   $0x73
  80246d:	68 77 41 80 00       	push   $0x804177
  802472:	e8 2d 12 00 00       	call   8036a4 <_panic>
  802477:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80247d:	8b 45 08             	mov    0x8(%ebp),%eax
  802480:	89 50 04             	mov    %edx,0x4(%eax)
  802483:	8b 45 08             	mov    0x8(%ebp),%eax
  802486:	8b 40 04             	mov    0x4(%eax),%eax
  802489:	85 c0                	test   %eax,%eax
  80248b:	74 0c                	je     802499 <insert_sorted_allocList+0x179>
  80248d:	a1 44 50 80 00       	mov    0x805044,%eax
  802492:	8b 55 08             	mov    0x8(%ebp),%edx
  802495:	89 10                	mov    %edx,(%eax)
  802497:	eb 08                	jmp    8024a1 <insert_sorted_allocList+0x181>
  802499:	8b 45 08             	mov    0x8(%ebp),%eax
  80249c:	a3 40 50 80 00       	mov    %eax,0x805040
  8024a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a4:	a3 44 50 80 00       	mov    %eax,0x805044
  8024a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024b2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8024b7:	40                   	inc    %eax
  8024b8:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8024bd:	e9 e7 00 00 00       	jmp    8025a9 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8024c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8024c8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8024cf:	a1 40 50 80 00       	mov    0x805040,%eax
  8024d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024d7:	e9 9d 00 00 00       	jmp    802579 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8024dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024df:	8b 00                	mov    (%eax),%eax
  8024e1:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8024e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e7:	8b 50 08             	mov    0x8(%eax),%edx
  8024ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ed:	8b 40 08             	mov    0x8(%eax),%eax
  8024f0:	39 c2                	cmp    %eax,%edx
  8024f2:	76 7d                	jbe    802571 <insert_sorted_allocList+0x251>
  8024f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f7:	8b 50 08             	mov    0x8(%eax),%edx
  8024fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024fd:	8b 40 08             	mov    0x8(%eax),%eax
  802500:	39 c2                	cmp    %eax,%edx
  802502:	73 6d                	jae    802571 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802504:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802508:	74 06                	je     802510 <insert_sorted_allocList+0x1f0>
  80250a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80250e:	75 14                	jne    802524 <insert_sorted_allocList+0x204>
  802510:	83 ec 04             	sub    $0x4,%esp
  802513:	68 ec 41 80 00       	push   $0x8041ec
  802518:	6a 7f                	push   $0x7f
  80251a:	68 77 41 80 00       	push   $0x804177
  80251f:	e8 80 11 00 00       	call   8036a4 <_panic>
  802524:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802527:	8b 10                	mov    (%eax),%edx
  802529:	8b 45 08             	mov    0x8(%ebp),%eax
  80252c:	89 10                	mov    %edx,(%eax)
  80252e:	8b 45 08             	mov    0x8(%ebp),%eax
  802531:	8b 00                	mov    (%eax),%eax
  802533:	85 c0                	test   %eax,%eax
  802535:	74 0b                	je     802542 <insert_sorted_allocList+0x222>
  802537:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253a:	8b 00                	mov    (%eax),%eax
  80253c:	8b 55 08             	mov    0x8(%ebp),%edx
  80253f:	89 50 04             	mov    %edx,0x4(%eax)
  802542:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802545:	8b 55 08             	mov    0x8(%ebp),%edx
  802548:	89 10                	mov    %edx,(%eax)
  80254a:	8b 45 08             	mov    0x8(%ebp),%eax
  80254d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802550:	89 50 04             	mov    %edx,0x4(%eax)
  802553:	8b 45 08             	mov    0x8(%ebp),%eax
  802556:	8b 00                	mov    (%eax),%eax
  802558:	85 c0                	test   %eax,%eax
  80255a:	75 08                	jne    802564 <insert_sorted_allocList+0x244>
  80255c:	8b 45 08             	mov    0x8(%ebp),%eax
  80255f:	a3 44 50 80 00       	mov    %eax,0x805044
  802564:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802569:	40                   	inc    %eax
  80256a:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  80256f:	eb 39                	jmp    8025aa <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802571:	a1 48 50 80 00       	mov    0x805048,%eax
  802576:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802579:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80257d:	74 07                	je     802586 <insert_sorted_allocList+0x266>
  80257f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802582:	8b 00                	mov    (%eax),%eax
  802584:	eb 05                	jmp    80258b <insert_sorted_allocList+0x26b>
  802586:	b8 00 00 00 00       	mov    $0x0,%eax
  80258b:	a3 48 50 80 00       	mov    %eax,0x805048
  802590:	a1 48 50 80 00       	mov    0x805048,%eax
  802595:	85 c0                	test   %eax,%eax
  802597:	0f 85 3f ff ff ff    	jne    8024dc <insert_sorted_allocList+0x1bc>
  80259d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025a1:	0f 85 35 ff ff ff    	jne    8024dc <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8025a7:	eb 01                	jmp    8025aa <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8025a9:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8025aa:	90                   	nop
  8025ab:	c9                   	leave  
  8025ac:	c3                   	ret    

008025ad <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8025ad:	55                   	push   %ebp
  8025ae:	89 e5                	mov    %esp,%ebp
  8025b0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8025b3:	a1 38 51 80 00       	mov    0x805138,%eax
  8025b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025bb:	e9 85 01 00 00       	jmp    802745 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8025c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8025c6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025c9:	0f 82 6e 01 00 00    	jb     80273d <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8025cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8025d5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025d8:	0f 85 8a 00 00 00    	jne    802668 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8025de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025e2:	75 17                	jne    8025fb <alloc_block_FF+0x4e>
  8025e4:	83 ec 04             	sub    $0x4,%esp
  8025e7:	68 20 42 80 00       	push   $0x804220
  8025ec:	68 93 00 00 00       	push   $0x93
  8025f1:	68 77 41 80 00       	push   $0x804177
  8025f6:	e8 a9 10 00 00       	call   8036a4 <_panic>
  8025fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fe:	8b 00                	mov    (%eax),%eax
  802600:	85 c0                	test   %eax,%eax
  802602:	74 10                	je     802614 <alloc_block_FF+0x67>
  802604:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802607:	8b 00                	mov    (%eax),%eax
  802609:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80260c:	8b 52 04             	mov    0x4(%edx),%edx
  80260f:	89 50 04             	mov    %edx,0x4(%eax)
  802612:	eb 0b                	jmp    80261f <alloc_block_FF+0x72>
  802614:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802617:	8b 40 04             	mov    0x4(%eax),%eax
  80261a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80261f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802622:	8b 40 04             	mov    0x4(%eax),%eax
  802625:	85 c0                	test   %eax,%eax
  802627:	74 0f                	je     802638 <alloc_block_FF+0x8b>
  802629:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262c:	8b 40 04             	mov    0x4(%eax),%eax
  80262f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802632:	8b 12                	mov    (%edx),%edx
  802634:	89 10                	mov    %edx,(%eax)
  802636:	eb 0a                	jmp    802642 <alloc_block_FF+0x95>
  802638:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263b:	8b 00                	mov    (%eax),%eax
  80263d:	a3 38 51 80 00       	mov    %eax,0x805138
  802642:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802645:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80264b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802655:	a1 44 51 80 00       	mov    0x805144,%eax
  80265a:	48                   	dec    %eax
  80265b:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802660:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802663:	e9 10 01 00 00       	jmp    802778 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802668:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266b:	8b 40 0c             	mov    0xc(%eax),%eax
  80266e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802671:	0f 86 c6 00 00 00    	jbe    80273d <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802677:	a1 48 51 80 00       	mov    0x805148,%eax
  80267c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  80267f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802682:	8b 50 08             	mov    0x8(%eax),%edx
  802685:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802688:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  80268b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80268e:	8b 55 08             	mov    0x8(%ebp),%edx
  802691:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802694:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802698:	75 17                	jne    8026b1 <alloc_block_FF+0x104>
  80269a:	83 ec 04             	sub    $0x4,%esp
  80269d:	68 20 42 80 00       	push   $0x804220
  8026a2:	68 9b 00 00 00       	push   $0x9b
  8026a7:	68 77 41 80 00       	push   $0x804177
  8026ac:	e8 f3 0f 00 00       	call   8036a4 <_panic>
  8026b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026b4:	8b 00                	mov    (%eax),%eax
  8026b6:	85 c0                	test   %eax,%eax
  8026b8:	74 10                	je     8026ca <alloc_block_FF+0x11d>
  8026ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026bd:	8b 00                	mov    (%eax),%eax
  8026bf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026c2:	8b 52 04             	mov    0x4(%edx),%edx
  8026c5:	89 50 04             	mov    %edx,0x4(%eax)
  8026c8:	eb 0b                	jmp    8026d5 <alloc_block_FF+0x128>
  8026ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026cd:	8b 40 04             	mov    0x4(%eax),%eax
  8026d0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8026d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026d8:	8b 40 04             	mov    0x4(%eax),%eax
  8026db:	85 c0                	test   %eax,%eax
  8026dd:	74 0f                	je     8026ee <alloc_block_FF+0x141>
  8026df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e2:	8b 40 04             	mov    0x4(%eax),%eax
  8026e5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026e8:	8b 12                	mov    (%edx),%edx
  8026ea:	89 10                	mov    %edx,(%eax)
  8026ec:	eb 0a                	jmp    8026f8 <alloc_block_FF+0x14b>
  8026ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026f1:	8b 00                	mov    (%eax),%eax
  8026f3:	a3 48 51 80 00       	mov    %eax,0x805148
  8026f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802701:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802704:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80270b:	a1 54 51 80 00       	mov    0x805154,%eax
  802710:	48                   	dec    %eax
  802711:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802716:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802719:	8b 50 08             	mov    0x8(%eax),%edx
  80271c:	8b 45 08             	mov    0x8(%ebp),%eax
  80271f:	01 c2                	add    %eax,%edx
  802721:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802724:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802727:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272a:	8b 40 0c             	mov    0xc(%eax),%eax
  80272d:	2b 45 08             	sub    0x8(%ebp),%eax
  802730:	89 c2                	mov    %eax,%edx
  802732:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802735:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802738:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80273b:	eb 3b                	jmp    802778 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80273d:	a1 40 51 80 00       	mov    0x805140,%eax
  802742:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802745:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802749:	74 07                	je     802752 <alloc_block_FF+0x1a5>
  80274b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274e:	8b 00                	mov    (%eax),%eax
  802750:	eb 05                	jmp    802757 <alloc_block_FF+0x1aa>
  802752:	b8 00 00 00 00       	mov    $0x0,%eax
  802757:	a3 40 51 80 00       	mov    %eax,0x805140
  80275c:	a1 40 51 80 00       	mov    0x805140,%eax
  802761:	85 c0                	test   %eax,%eax
  802763:	0f 85 57 fe ff ff    	jne    8025c0 <alloc_block_FF+0x13>
  802769:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80276d:	0f 85 4d fe ff ff    	jne    8025c0 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802773:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802778:	c9                   	leave  
  802779:	c3                   	ret    

0080277a <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80277a:	55                   	push   %ebp
  80277b:	89 e5                	mov    %esp,%ebp
  80277d:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802780:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802787:	a1 38 51 80 00       	mov    0x805138,%eax
  80278c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80278f:	e9 df 00 00 00       	jmp    802873 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802794:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802797:	8b 40 0c             	mov    0xc(%eax),%eax
  80279a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80279d:	0f 82 c8 00 00 00    	jb     80286b <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8027a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8027a9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027ac:	0f 85 8a 00 00 00    	jne    80283c <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8027b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027b6:	75 17                	jne    8027cf <alloc_block_BF+0x55>
  8027b8:	83 ec 04             	sub    $0x4,%esp
  8027bb:	68 20 42 80 00       	push   $0x804220
  8027c0:	68 b7 00 00 00       	push   $0xb7
  8027c5:	68 77 41 80 00       	push   $0x804177
  8027ca:	e8 d5 0e 00 00       	call   8036a4 <_panic>
  8027cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d2:	8b 00                	mov    (%eax),%eax
  8027d4:	85 c0                	test   %eax,%eax
  8027d6:	74 10                	je     8027e8 <alloc_block_BF+0x6e>
  8027d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027db:	8b 00                	mov    (%eax),%eax
  8027dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027e0:	8b 52 04             	mov    0x4(%edx),%edx
  8027e3:	89 50 04             	mov    %edx,0x4(%eax)
  8027e6:	eb 0b                	jmp    8027f3 <alloc_block_BF+0x79>
  8027e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027eb:	8b 40 04             	mov    0x4(%eax),%eax
  8027ee:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8027f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f6:	8b 40 04             	mov    0x4(%eax),%eax
  8027f9:	85 c0                	test   %eax,%eax
  8027fb:	74 0f                	je     80280c <alloc_block_BF+0x92>
  8027fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802800:	8b 40 04             	mov    0x4(%eax),%eax
  802803:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802806:	8b 12                	mov    (%edx),%edx
  802808:	89 10                	mov    %edx,(%eax)
  80280a:	eb 0a                	jmp    802816 <alloc_block_BF+0x9c>
  80280c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280f:	8b 00                	mov    (%eax),%eax
  802811:	a3 38 51 80 00       	mov    %eax,0x805138
  802816:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802819:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80281f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802822:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802829:	a1 44 51 80 00       	mov    0x805144,%eax
  80282e:	48                   	dec    %eax
  80282f:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802834:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802837:	e9 4d 01 00 00       	jmp    802989 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  80283c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283f:	8b 40 0c             	mov    0xc(%eax),%eax
  802842:	3b 45 08             	cmp    0x8(%ebp),%eax
  802845:	76 24                	jbe    80286b <alloc_block_BF+0xf1>
  802847:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284a:	8b 40 0c             	mov    0xc(%eax),%eax
  80284d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802850:	73 19                	jae    80286b <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802852:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802859:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285c:	8b 40 0c             	mov    0xc(%eax),%eax
  80285f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802862:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802865:	8b 40 08             	mov    0x8(%eax),%eax
  802868:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80286b:	a1 40 51 80 00       	mov    0x805140,%eax
  802870:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802873:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802877:	74 07                	je     802880 <alloc_block_BF+0x106>
  802879:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287c:	8b 00                	mov    (%eax),%eax
  80287e:	eb 05                	jmp    802885 <alloc_block_BF+0x10b>
  802880:	b8 00 00 00 00       	mov    $0x0,%eax
  802885:	a3 40 51 80 00       	mov    %eax,0x805140
  80288a:	a1 40 51 80 00       	mov    0x805140,%eax
  80288f:	85 c0                	test   %eax,%eax
  802891:	0f 85 fd fe ff ff    	jne    802794 <alloc_block_BF+0x1a>
  802897:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80289b:	0f 85 f3 fe ff ff    	jne    802794 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8028a1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8028a5:	0f 84 d9 00 00 00    	je     802984 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8028ab:	a1 48 51 80 00       	mov    0x805148,%eax
  8028b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8028b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028b6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028b9:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8028bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8028c2:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8028c5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8028c9:	75 17                	jne    8028e2 <alloc_block_BF+0x168>
  8028cb:	83 ec 04             	sub    $0x4,%esp
  8028ce:	68 20 42 80 00       	push   $0x804220
  8028d3:	68 c7 00 00 00       	push   $0xc7
  8028d8:	68 77 41 80 00       	push   $0x804177
  8028dd:	e8 c2 0d 00 00       	call   8036a4 <_panic>
  8028e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028e5:	8b 00                	mov    (%eax),%eax
  8028e7:	85 c0                	test   %eax,%eax
  8028e9:	74 10                	je     8028fb <alloc_block_BF+0x181>
  8028eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028ee:	8b 00                	mov    (%eax),%eax
  8028f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028f3:	8b 52 04             	mov    0x4(%edx),%edx
  8028f6:	89 50 04             	mov    %edx,0x4(%eax)
  8028f9:	eb 0b                	jmp    802906 <alloc_block_BF+0x18c>
  8028fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028fe:	8b 40 04             	mov    0x4(%eax),%eax
  802901:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802906:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802909:	8b 40 04             	mov    0x4(%eax),%eax
  80290c:	85 c0                	test   %eax,%eax
  80290e:	74 0f                	je     80291f <alloc_block_BF+0x1a5>
  802910:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802913:	8b 40 04             	mov    0x4(%eax),%eax
  802916:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802919:	8b 12                	mov    (%edx),%edx
  80291b:	89 10                	mov    %edx,(%eax)
  80291d:	eb 0a                	jmp    802929 <alloc_block_BF+0x1af>
  80291f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802922:	8b 00                	mov    (%eax),%eax
  802924:	a3 48 51 80 00       	mov    %eax,0x805148
  802929:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80292c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802932:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802935:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80293c:	a1 54 51 80 00       	mov    0x805154,%eax
  802941:	48                   	dec    %eax
  802942:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802947:	83 ec 08             	sub    $0x8,%esp
  80294a:	ff 75 ec             	pushl  -0x14(%ebp)
  80294d:	68 38 51 80 00       	push   $0x805138
  802952:	e8 71 f9 ff ff       	call   8022c8 <find_block>
  802957:	83 c4 10             	add    $0x10,%esp
  80295a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  80295d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802960:	8b 50 08             	mov    0x8(%eax),%edx
  802963:	8b 45 08             	mov    0x8(%ebp),%eax
  802966:	01 c2                	add    %eax,%edx
  802968:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80296b:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  80296e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802971:	8b 40 0c             	mov    0xc(%eax),%eax
  802974:	2b 45 08             	sub    0x8(%ebp),%eax
  802977:	89 c2                	mov    %eax,%edx
  802979:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80297c:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  80297f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802982:	eb 05                	jmp    802989 <alloc_block_BF+0x20f>
	}
	return NULL;
  802984:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802989:	c9                   	leave  
  80298a:	c3                   	ret    

0080298b <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80298b:	55                   	push   %ebp
  80298c:	89 e5                	mov    %esp,%ebp
  80298e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802991:	a1 28 50 80 00       	mov    0x805028,%eax
  802996:	85 c0                	test   %eax,%eax
  802998:	0f 85 de 01 00 00    	jne    802b7c <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80299e:	a1 38 51 80 00       	mov    0x805138,%eax
  8029a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029a6:	e9 9e 01 00 00       	jmp    802b49 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8029ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8029b1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029b4:	0f 82 87 01 00 00    	jb     802b41 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8029ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8029c0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029c3:	0f 85 95 00 00 00    	jne    802a5e <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8029c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029cd:	75 17                	jne    8029e6 <alloc_block_NF+0x5b>
  8029cf:	83 ec 04             	sub    $0x4,%esp
  8029d2:	68 20 42 80 00       	push   $0x804220
  8029d7:	68 e0 00 00 00       	push   $0xe0
  8029dc:	68 77 41 80 00       	push   $0x804177
  8029e1:	e8 be 0c 00 00       	call   8036a4 <_panic>
  8029e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e9:	8b 00                	mov    (%eax),%eax
  8029eb:	85 c0                	test   %eax,%eax
  8029ed:	74 10                	je     8029ff <alloc_block_NF+0x74>
  8029ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f2:	8b 00                	mov    (%eax),%eax
  8029f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029f7:	8b 52 04             	mov    0x4(%edx),%edx
  8029fa:	89 50 04             	mov    %edx,0x4(%eax)
  8029fd:	eb 0b                	jmp    802a0a <alloc_block_NF+0x7f>
  8029ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a02:	8b 40 04             	mov    0x4(%eax),%eax
  802a05:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0d:	8b 40 04             	mov    0x4(%eax),%eax
  802a10:	85 c0                	test   %eax,%eax
  802a12:	74 0f                	je     802a23 <alloc_block_NF+0x98>
  802a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a17:	8b 40 04             	mov    0x4(%eax),%eax
  802a1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a1d:	8b 12                	mov    (%edx),%edx
  802a1f:	89 10                	mov    %edx,(%eax)
  802a21:	eb 0a                	jmp    802a2d <alloc_block_NF+0xa2>
  802a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a26:	8b 00                	mov    (%eax),%eax
  802a28:	a3 38 51 80 00       	mov    %eax,0x805138
  802a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a30:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a39:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a40:	a1 44 51 80 00       	mov    0x805144,%eax
  802a45:	48                   	dec    %eax
  802a46:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4e:	8b 40 08             	mov    0x8(%eax),%eax
  802a51:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802a56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a59:	e9 f8 04 00 00       	jmp    802f56 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802a5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a61:	8b 40 0c             	mov    0xc(%eax),%eax
  802a64:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a67:	0f 86 d4 00 00 00    	jbe    802b41 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a6d:	a1 48 51 80 00       	mov    0x805148,%eax
  802a72:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802a75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a78:	8b 50 08             	mov    0x8(%eax),%edx
  802a7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a7e:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802a81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a84:	8b 55 08             	mov    0x8(%ebp),%edx
  802a87:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802a8a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a8e:	75 17                	jne    802aa7 <alloc_block_NF+0x11c>
  802a90:	83 ec 04             	sub    $0x4,%esp
  802a93:	68 20 42 80 00       	push   $0x804220
  802a98:	68 e9 00 00 00       	push   $0xe9
  802a9d:	68 77 41 80 00       	push   $0x804177
  802aa2:	e8 fd 0b 00 00       	call   8036a4 <_panic>
  802aa7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aaa:	8b 00                	mov    (%eax),%eax
  802aac:	85 c0                	test   %eax,%eax
  802aae:	74 10                	je     802ac0 <alloc_block_NF+0x135>
  802ab0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab3:	8b 00                	mov    (%eax),%eax
  802ab5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ab8:	8b 52 04             	mov    0x4(%edx),%edx
  802abb:	89 50 04             	mov    %edx,0x4(%eax)
  802abe:	eb 0b                	jmp    802acb <alloc_block_NF+0x140>
  802ac0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac3:	8b 40 04             	mov    0x4(%eax),%eax
  802ac6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802acb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ace:	8b 40 04             	mov    0x4(%eax),%eax
  802ad1:	85 c0                	test   %eax,%eax
  802ad3:	74 0f                	je     802ae4 <alloc_block_NF+0x159>
  802ad5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad8:	8b 40 04             	mov    0x4(%eax),%eax
  802adb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ade:	8b 12                	mov    (%edx),%edx
  802ae0:	89 10                	mov    %edx,(%eax)
  802ae2:	eb 0a                	jmp    802aee <alloc_block_NF+0x163>
  802ae4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae7:	8b 00                	mov    (%eax),%eax
  802ae9:	a3 48 51 80 00       	mov    %eax,0x805148
  802aee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802af7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802afa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b01:	a1 54 51 80 00       	mov    0x805154,%eax
  802b06:	48                   	dec    %eax
  802b07:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802b0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b0f:	8b 40 08             	mov    0x8(%eax),%eax
  802b12:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802b17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1a:	8b 50 08             	mov    0x8(%eax),%edx
  802b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b20:	01 c2                	add    %eax,%edx
  802b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b25:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2b:	8b 40 0c             	mov    0xc(%eax),%eax
  802b2e:	2b 45 08             	sub    0x8(%ebp),%eax
  802b31:	89 c2                	mov    %eax,%edx
  802b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b36:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802b39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b3c:	e9 15 04 00 00       	jmp    802f56 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802b41:	a1 40 51 80 00       	mov    0x805140,%eax
  802b46:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b49:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b4d:	74 07                	je     802b56 <alloc_block_NF+0x1cb>
  802b4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b52:	8b 00                	mov    (%eax),%eax
  802b54:	eb 05                	jmp    802b5b <alloc_block_NF+0x1d0>
  802b56:	b8 00 00 00 00       	mov    $0x0,%eax
  802b5b:	a3 40 51 80 00       	mov    %eax,0x805140
  802b60:	a1 40 51 80 00       	mov    0x805140,%eax
  802b65:	85 c0                	test   %eax,%eax
  802b67:	0f 85 3e fe ff ff    	jne    8029ab <alloc_block_NF+0x20>
  802b6d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b71:	0f 85 34 fe ff ff    	jne    8029ab <alloc_block_NF+0x20>
  802b77:	e9 d5 03 00 00       	jmp    802f51 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b7c:	a1 38 51 80 00       	mov    0x805138,%eax
  802b81:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b84:	e9 b1 01 00 00       	jmp    802d3a <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802b89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8c:	8b 50 08             	mov    0x8(%eax),%edx
  802b8f:	a1 28 50 80 00       	mov    0x805028,%eax
  802b94:	39 c2                	cmp    %eax,%edx
  802b96:	0f 82 96 01 00 00    	jb     802d32 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9f:	8b 40 0c             	mov    0xc(%eax),%eax
  802ba2:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ba5:	0f 82 87 01 00 00    	jb     802d32 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802bab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bae:	8b 40 0c             	mov    0xc(%eax),%eax
  802bb1:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bb4:	0f 85 95 00 00 00    	jne    802c4f <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802bba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bbe:	75 17                	jne    802bd7 <alloc_block_NF+0x24c>
  802bc0:	83 ec 04             	sub    $0x4,%esp
  802bc3:	68 20 42 80 00       	push   $0x804220
  802bc8:	68 fc 00 00 00       	push   $0xfc
  802bcd:	68 77 41 80 00       	push   $0x804177
  802bd2:	e8 cd 0a 00 00       	call   8036a4 <_panic>
  802bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bda:	8b 00                	mov    (%eax),%eax
  802bdc:	85 c0                	test   %eax,%eax
  802bde:	74 10                	je     802bf0 <alloc_block_NF+0x265>
  802be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be3:	8b 00                	mov    (%eax),%eax
  802be5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802be8:	8b 52 04             	mov    0x4(%edx),%edx
  802beb:	89 50 04             	mov    %edx,0x4(%eax)
  802bee:	eb 0b                	jmp    802bfb <alloc_block_NF+0x270>
  802bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf3:	8b 40 04             	mov    0x4(%eax),%eax
  802bf6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802bfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfe:	8b 40 04             	mov    0x4(%eax),%eax
  802c01:	85 c0                	test   %eax,%eax
  802c03:	74 0f                	je     802c14 <alloc_block_NF+0x289>
  802c05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c08:	8b 40 04             	mov    0x4(%eax),%eax
  802c0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c0e:	8b 12                	mov    (%edx),%edx
  802c10:	89 10                	mov    %edx,(%eax)
  802c12:	eb 0a                	jmp    802c1e <alloc_block_NF+0x293>
  802c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c17:	8b 00                	mov    (%eax),%eax
  802c19:	a3 38 51 80 00       	mov    %eax,0x805138
  802c1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c21:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c31:	a1 44 51 80 00       	mov    0x805144,%eax
  802c36:	48                   	dec    %eax
  802c37:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802c3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3f:	8b 40 08             	mov    0x8(%eax),%eax
  802c42:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802c47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4a:	e9 07 03 00 00       	jmp    802f56 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802c4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c52:	8b 40 0c             	mov    0xc(%eax),%eax
  802c55:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c58:	0f 86 d4 00 00 00    	jbe    802d32 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802c5e:	a1 48 51 80 00       	mov    0x805148,%eax
  802c63:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c69:	8b 50 08             	mov    0x8(%eax),%edx
  802c6c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c6f:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802c72:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c75:	8b 55 08             	mov    0x8(%ebp),%edx
  802c78:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802c7b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802c7f:	75 17                	jne    802c98 <alloc_block_NF+0x30d>
  802c81:	83 ec 04             	sub    $0x4,%esp
  802c84:	68 20 42 80 00       	push   $0x804220
  802c89:	68 04 01 00 00       	push   $0x104
  802c8e:	68 77 41 80 00       	push   $0x804177
  802c93:	e8 0c 0a 00 00       	call   8036a4 <_panic>
  802c98:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c9b:	8b 00                	mov    (%eax),%eax
  802c9d:	85 c0                	test   %eax,%eax
  802c9f:	74 10                	je     802cb1 <alloc_block_NF+0x326>
  802ca1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ca4:	8b 00                	mov    (%eax),%eax
  802ca6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ca9:	8b 52 04             	mov    0x4(%edx),%edx
  802cac:	89 50 04             	mov    %edx,0x4(%eax)
  802caf:	eb 0b                	jmp    802cbc <alloc_block_NF+0x331>
  802cb1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cb4:	8b 40 04             	mov    0x4(%eax),%eax
  802cb7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802cbc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cbf:	8b 40 04             	mov    0x4(%eax),%eax
  802cc2:	85 c0                	test   %eax,%eax
  802cc4:	74 0f                	je     802cd5 <alloc_block_NF+0x34a>
  802cc6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cc9:	8b 40 04             	mov    0x4(%eax),%eax
  802ccc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ccf:	8b 12                	mov    (%edx),%edx
  802cd1:	89 10                	mov    %edx,(%eax)
  802cd3:	eb 0a                	jmp    802cdf <alloc_block_NF+0x354>
  802cd5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cd8:	8b 00                	mov    (%eax),%eax
  802cda:	a3 48 51 80 00       	mov    %eax,0x805148
  802cdf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ce2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ce8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ceb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cf2:	a1 54 51 80 00       	mov    0x805154,%eax
  802cf7:	48                   	dec    %eax
  802cf8:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802cfd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d00:	8b 40 08             	mov    0x8(%eax),%eax
  802d03:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802d08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0b:	8b 50 08             	mov    0x8(%eax),%edx
  802d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d11:	01 c2                	add    %eax,%edx
  802d13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d16:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802d19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1c:	8b 40 0c             	mov    0xc(%eax),%eax
  802d1f:	2b 45 08             	sub    0x8(%ebp),%eax
  802d22:	89 c2                	mov    %eax,%edx
  802d24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d27:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802d2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d2d:	e9 24 02 00 00       	jmp    802f56 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802d32:	a1 40 51 80 00       	mov    0x805140,%eax
  802d37:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d3a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d3e:	74 07                	je     802d47 <alloc_block_NF+0x3bc>
  802d40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d43:	8b 00                	mov    (%eax),%eax
  802d45:	eb 05                	jmp    802d4c <alloc_block_NF+0x3c1>
  802d47:	b8 00 00 00 00       	mov    $0x0,%eax
  802d4c:	a3 40 51 80 00       	mov    %eax,0x805140
  802d51:	a1 40 51 80 00       	mov    0x805140,%eax
  802d56:	85 c0                	test   %eax,%eax
  802d58:	0f 85 2b fe ff ff    	jne    802b89 <alloc_block_NF+0x1fe>
  802d5e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d62:	0f 85 21 fe ff ff    	jne    802b89 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802d68:	a1 38 51 80 00       	mov    0x805138,%eax
  802d6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d70:	e9 ae 01 00 00       	jmp    802f23 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d78:	8b 50 08             	mov    0x8(%eax),%edx
  802d7b:	a1 28 50 80 00       	mov    0x805028,%eax
  802d80:	39 c2                	cmp    %eax,%edx
  802d82:	0f 83 93 01 00 00    	jae    802f1b <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802d88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8b:	8b 40 0c             	mov    0xc(%eax),%eax
  802d8e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d91:	0f 82 84 01 00 00    	jb     802f1b <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802d97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9a:	8b 40 0c             	mov    0xc(%eax),%eax
  802d9d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802da0:	0f 85 95 00 00 00    	jne    802e3b <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802da6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802daa:	75 17                	jne    802dc3 <alloc_block_NF+0x438>
  802dac:	83 ec 04             	sub    $0x4,%esp
  802daf:	68 20 42 80 00       	push   $0x804220
  802db4:	68 14 01 00 00       	push   $0x114
  802db9:	68 77 41 80 00       	push   $0x804177
  802dbe:	e8 e1 08 00 00       	call   8036a4 <_panic>
  802dc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc6:	8b 00                	mov    (%eax),%eax
  802dc8:	85 c0                	test   %eax,%eax
  802dca:	74 10                	je     802ddc <alloc_block_NF+0x451>
  802dcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcf:	8b 00                	mov    (%eax),%eax
  802dd1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dd4:	8b 52 04             	mov    0x4(%edx),%edx
  802dd7:	89 50 04             	mov    %edx,0x4(%eax)
  802dda:	eb 0b                	jmp    802de7 <alloc_block_NF+0x45c>
  802ddc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddf:	8b 40 04             	mov    0x4(%eax),%eax
  802de2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802de7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dea:	8b 40 04             	mov    0x4(%eax),%eax
  802ded:	85 c0                	test   %eax,%eax
  802def:	74 0f                	je     802e00 <alloc_block_NF+0x475>
  802df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df4:	8b 40 04             	mov    0x4(%eax),%eax
  802df7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dfa:	8b 12                	mov    (%edx),%edx
  802dfc:	89 10                	mov    %edx,(%eax)
  802dfe:	eb 0a                	jmp    802e0a <alloc_block_NF+0x47f>
  802e00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e03:	8b 00                	mov    (%eax),%eax
  802e05:	a3 38 51 80 00       	mov    %eax,0x805138
  802e0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e16:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e1d:	a1 44 51 80 00       	mov    0x805144,%eax
  802e22:	48                   	dec    %eax
  802e23:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802e28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2b:	8b 40 08             	mov    0x8(%eax),%eax
  802e2e:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802e33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e36:	e9 1b 01 00 00       	jmp    802f56 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802e3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3e:	8b 40 0c             	mov    0xc(%eax),%eax
  802e41:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e44:	0f 86 d1 00 00 00    	jbe    802f1b <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802e4a:	a1 48 51 80 00       	mov    0x805148,%eax
  802e4f:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802e52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e55:	8b 50 08             	mov    0x8(%eax),%edx
  802e58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e5b:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802e5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e61:	8b 55 08             	mov    0x8(%ebp),%edx
  802e64:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802e67:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802e6b:	75 17                	jne    802e84 <alloc_block_NF+0x4f9>
  802e6d:	83 ec 04             	sub    $0x4,%esp
  802e70:	68 20 42 80 00       	push   $0x804220
  802e75:	68 1c 01 00 00       	push   $0x11c
  802e7a:	68 77 41 80 00       	push   $0x804177
  802e7f:	e8 20 08 00 00       	call   8036a4 <_panic>
  802e84:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e87:	8b 00                	mov    (%eax),%eax
  802e89:	85 c0                	test   %eax,%eax
  802e8b:	74 10                	je     802e9d <alloc_block_NF+0x512>
  802e8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e90:	8b 00                	mov    (%eax),%eax
  802e92:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e95:	8b 52 04             	mov    0x4(%edx),%edx
  802e98:	89 50 04             	mov    %edx,0x4(%eax)
  802e9b:	eb 0b                	jmp    802ea8 <alloc_block_NF+0x51d>
  802e9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ea0:	8b 40 04             	mov    0x4(%eax),%eax
  802ea3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ea8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eab:	8b 40 04             	mov    0x4(%eax),%eax
  802eae:	85 c0                	test   %eax,%eax
  802eb0:	74 0f                	je     802ec1 <alloc_block_NF+0x536>
  802eb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eb5:	8b 40 04             	mov    0x4(%eax),%eax
  802eb8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ebb:	8b 12                	mov    (%edx),%edx
  802ebd:	89 10                	mov    %edx,(%eax)
  802ebf:	eb 0a                	jmp    802ecb <alloc_block_NF+0x540>
  802ec1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ec4:	8b 00                	mov    (%eax),%eax
  802ec6:	a3 48 51 80 00       	mov    %eax,0x805148
  802ecb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ece:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ed4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ed7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ede:	a1 54 51 80 00       	mov    0x805154,%eax
  802ee3:	48                   	dec    %eax
  802ee4:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802ee9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eec:	8b 40 08             	mov    0x8(%eax),%eax
  802eef:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802ef4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef7:	8b 50 08             	mov    0x8(%eax),%edx
  802efa:	8b 45 08             	mov    0x8(%ebp),%eax
  802efd:	01 c2                	add    %eax,%edx
  802eff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f02:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802f05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f08:	8b 40 0c             	mov    0xc(%eax),%eax
  802f0b:	2b 45 08             	sub    0x8(%ebp),%eax
  802f0e:	89 c2                	mov    %eax,%edx
  802f10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f13:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802f16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f19:	eb 3b                	jmp    802f56 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802f1b:	a1 40 51 80 00       	mov    0x805140,%eax
  802f20:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f23:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f27:	74 07                	je     802f30 <alloc_block_NF+0x5a5>
  802f29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2c:	8b 00                	mov    (%eax),%eax
  802f2e:	eb 05                	jmp    802f35 <alloc_block_NF+0x5aa>
  802f30:	b8 00 00 00 00       	mov    $0x0,%eax
  802f35:	a3 40 51 80 00       	mov    %eax,0x805140
  802f3a:	a1 40 51 80 00       	mov    0x805140,%eax
  802f3f:	85 c0                	test   %eax,%eax
  802f41:	0f 85 2e fe ff ff    	jne    802d75 <alloc_block_NF+0x3ea>
  802f47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f4b:	0f 85 24 fe ff ff    	jne    802d75 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802f51:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f56:	c9                   	leave  
  802f57:	c3                   	ret    

00802f58 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802f58:	55                   	push   %ebp
  802f59:	89 e5                	mov    %esp,%ebp
  802f5b:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802f5e:	a1 38 51 80 00       	mov    0x805138,%eax
  802f63:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802f66:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f6b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802f6e:	a1 38 51 80 00       	mov    0x805138,%eax
  802f73:	85 c0                	test   %eax,%eax
  802f75:	74 14                	je     802f8b <insert_sorted_with_merge_freeList+0x33>
  802f77:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7a:	8b 50 08             	mov    0x8(%eax),%edx
  802f7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f80:	8b 40 08             	mov    0x8(%eax),%eax
  802f83:	39 c2                	cmp    %eax,%edx
  802f85:	0f 87 9b 01 00 00    	ja     803126 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802f8b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f8f:	75 17                	jne    802fa8 <insert_sorted_with_merge_freeList+0x50>
  802f91:	83 ec 04             	sub    $0x4,%esp
  802f94:	68 54 41 80 00       	push   $0x804154
  802f99:	68 38 01 00 00       	push   $0x138
  802f9e:	68 77 41 80 00       	push   $0x804177
  802fa3:	e8 fc 06 00 00       	call   8036a4 <_panic>
  802fa8:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802fae:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb1:	89 10                	mov    %edx,(%eax)
  802fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb6:	8b 00                	mov    (%eax),%eax
  802fb8:	85 c0                	test   %eax,%eax
  802fba:	74 0d                	je     802fc9 <insert_sorted_with_merge_freeList+0x71>
  802fbc:	a1 38 51 80 00       	mov    0x805138,%eax
  802fc1:	8b 55 08             	mov    0x8(%ebp),%edx
  802fc4:	89 50 04             	mov    %edx,0x4(%eax)
  802fc7:	eb 08                	jmp    802fd1 <insert_sorted_with_merge_freeList+0x79>
  802fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd4:	a3 38 51 80 00       	mov    %eax,0x805138
  802fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fe3:	a1 44 51 80 00       	mov    0x805144,%eax
  802fe8:	40                   	inc    %eax
  802fe9:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802fee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ff2:	0f 84 a8 06 00 00    	je     8036a0 <insert_sorted_with_merge_freeList+0x748>
  802ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffb:	8b 50 08             	mov    0x8(%eax),%edx
  802ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  803001:	8b 40 0c             	mov    0xc(%eax),%eax
  803004:	01 c2                	add    %eax,%edx
  803006:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803009:	8b 40 08             	mov    0x8(%eax),%eax
  80300c:	39 c2                	cmp    %eax,%edx
  80300e:	0f 85 8c 06 00 00    	jne    8036a0 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  803014:	8b 45 08             	mov    0x8(%ebp),%eax
  803017:	8b 50 0c             	mov    0xc(%eax),%edx
  80301a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80301d:	8b 40 0c             	mov    0xc(%eax),%eax
  803020:	01 c2                	add    %eax,%edx
  803022:	8b 45 08             	mov    0x8(%ebp),%eax
  803025:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803028:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80302c:	75 17                	jne    803045 <insert_sorted_with_merge_freeList+0xed>
  80302e:	83 ec 04             	sub    $0x4,%esp
  803031:	68 20 42 80 00       	push   $0x804220
  803036:	68 3c 01 00 00       	push   $0x13c
  80303b:	68 77 41 80 00       	push   $0x804177
  803040:	e8 5f 06 00 00       	call   8036a4 <_panic>
  803045:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803048:	8b 00                	mov    (%eax),%eax
  80304a:	85 c0                	test   %eax,%eax
  80304c:	74 10                	je     80305e <insert_sorted_with_merge_freeList+0x106>
  80304e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803051:	8b 00                	mov    (%eax),%eax
  803053:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803056:	8b 52 04             	mov    0x4(%edx),%edx
  803059:	89 50 04             	mov    %edx,0x4(%eax)
  80305c:	eb 0b                	jmp    803069 <insert_sorted_with_merge_freeList+0x111>
  80305e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803061:	8b 40 04             	mov    0x4(%eax),%eax
  803064:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803069:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80306c:	8b 40 04             	mov    0x4(%eax),%eax
  80306f:	85 c0                	test   %eax,%eax
  803071:	74 0f                	je     803082 <insert_sorted_with_merge_freeList+0x12a>
  803073:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803076:	8b 40 04             	mov    0x4(%eax),%eax
  803079:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80307c:	8b 12                	mov    (%edx),%edx
  80307e:	89 10                	mov    %edx,(%eax)
  803080:	eb 0a                	jmp    80308c <insert_sorted_with_merge_freeList+0x134>
  803082:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803085:	8b 00                	mov    (%eax),%eax
  803087:	a3 38 51 80 00       	mov    %eax,0x805138
  80308c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80308f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803095:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803098:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80309f:	a1 44 51 80 00       	mov    0x805144,%eax
  8030a4:	48                   	dec    %eax
  8030a5:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  8030aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ad:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  8030b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030b7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  8030be:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030c2:	75 17                	jne    8030db <insert_sorted_with_merge_freeList+0x183>
  8030c4:	83 ec 04             	sub    $0x4,%esp
  8030c7:	68 54 41 80 00       	push   $0x804154
  8030cc:	68 3f 01 00 00       	push   $0x13f
  8030d1:	68 77 41 80 00       	push   $0x804177
  8030d6:	e8 c9 05 00 00       	call   8036a4 <_panic>
  8030db:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030e4:	89 10                	mov    %edx,(%eax)
  8030e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030e9:	8b 00                	mov    (%eax),%eax
  8030eb:	85 c0                	test   %eax,%eax
  8030ed:	74 0d                	je     8030fc <insert_sorted_with_merge_freeList+0x1a4>
  8030ef:	a1 48 51 80 00       	mov    0x805148,%eax
  8030f4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030f7:	89 50 04             	mov    %edx,0x4(%eax)
  8030fa:	eb 08                	jmp    803104 <insert_sorted_with_merge_freeList+0x1ac>
  8030fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ff:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803104:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803107:	a3 48 51 80 00       	mov    %eax,0x805148
  80310c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80310f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803116:	a1 54 51 80 00       	mov    0x805154,%eax
  80311b:	40                   	inc    %eax
  80311c:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803121:	e9 7a 05 00 00       	jmp    8036a0 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803126:	8b 45 08             	mov    0x8(%ebp),%eax
  803129:	8b 50 08             	mov    0x8(%eax),%edx
  80312c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80312f:	8b 40 08             	mov    0x8(%eax),%eax
  803132:	39 c2                	cmp    %eax,%edx
  803134:	0f 82 14 01 00 00    	jb     80324e <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  80313a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80313d:	8b 50 08             	mov    0x8(%eax),%edx
  803140:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803143:	8b 40 0c             	mov    0xc(%eax),%eax
  803146:	01 c2                	add    %eax,%edx
  803148:	8b 45 08             	mov    0x8(%ebp),%eax
  80314b:	8b 40 08             	mov    0x8(%eax),%eax
  80314e:	39 c2                	cmp    %eax,%edx
  803150:	0f 85 90 00 00 00    	jne    8031e6 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803156:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803159:	8b 50 0c             	mov    0xc(%eax),%edx
  80315c:	8b 45 08             	mov    0x8(%ebp),%eax
  80315f:	8b 40 0c             	mov    0xc(%eax),%eax
  803162:	01 c2                	add    %eax,%edx
  803164:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803167:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  80316a:	8b 45 08             	mov    0x8(%ebp),%eax
  80316d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803174:	8b 45 08             	mov    0x8(%ebp),%eax
  803177:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80317e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803182:	75 17                	jne    80319b <insert_sorted_with_merge_freeList+0x243>
  803184:	83 ec 04             	sub    $0x4,%esp
  803187:	68 54 41 80 00       	push   $0x804154
  80318c:	68 49 01 00 00       	push   $0x149
  803191:	68 77 41 80 00       	push   $0x804177
  803196:	e8 09 05 00 00       	call   8036a4 <_panic>
  80319b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a4:	89 10                	mov    %edx,(%eax)
  8031a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a9:	8b 00                	mov    (%eax),%eax
  8031ab:	85 c0                	test   %eax,%eax
  8031ad:	74 0d                	je     8031bc <insert_sorted_with_merge_freeList+0x264>
  8031af:	a1 48 51 80 00       	mov    0x805148,%eax
  8031b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8031b7:	89 50 04             	mov    %edx,0x4(%eax)
  8031ba:	eb 08                	jmp    8031c4 <insert_sorted_with_merge_freeList+0x26c>
  8031bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8031bf:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c7:	a3 48 51 80 00       	mov    %eax,0x805148
  8031cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8031cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031d6:	a1 54 51 80 00       	mov    0x805154,%eax
  8031db:	40                   	inc    %eax
  8031dc:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8031e1:	e9 bb 04 00 00       	jmp    8036a1 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8031e6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031ea:	75 17                	jne    803203 <insert_sorted_with_merge_freeList+0x2ab>
  8031ec:	83 ec 04             	sub    $0x4,%esp
  8031ef:	68 c8 41 80 00       	push   $0x8041c8
  8031f4:	68 4c 01 00 00       	push   $0x14c
  8031f9:	68 77 41 80 00       	push   $0x804177
  8031fe:	e8 a1 04 00 00       	call   8036a4 <_panic>
  803203:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803209:	8b 45 08             	mov    0x8(%ebp),%eax
  80320c:	89 50 04             	mov    %edx,0x4(%eax)
  80320f:	8b 45 08             	mov    0x8(%ebp),%eax
  803212:	8b 40 04             	mov    0x4(%eax),%eax
  803215:	85 c0                	test   %eax,%eax
  803217:	74 0c                	je     803225 <insert_sorted_with_merge_freeList+0x2cd>
  803219:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80321e:	8b 55 08             	mov    0x8(%ebp),%edx
  803221:	89 10                	mov    %edx,(%eax)
  803223:	eb 08                	jmp    80322d <insert_sorted_with_merge_freeList+0x2d5>
  803225:	8b 45 08             	mov    0x8(%ebp),%eax
  803228:	a3 38 51 80 00       	mov    %eax,0x805138
  80322d:	8b 45 08             	mov    0x8(%ebp),%eax
  803230:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803235:	8b 45 08             	mov    0x8(%ebp),%eax
  803238:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80323e:	a1 44 51 80 00       	mov    0x805144,%eax
  803243:	40                   	inc    %eax
  803244:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803249:	e9 53 04 00 00       	jmp    8036a1 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80324e:	a1 38 51 80 00       	mov    0x805138,%eax
  803253:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803256:	e9 15 04 00 00       	jmp    803670 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  80325b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325e:	8b 00                	mov    (%eax),%eax
  803260:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803263:	8b 45 08             	mov    0x8(%ebp),%eax
  803266:	8b 50 08             	mov    0x8(%eax),%edx
  803269:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326c:	8b 40 08             	mov    0x8(%eax),%eax
  80326f:	39 c2                	cmp    %eax,%edx
  803271:	0f 86 f1 03 00 00    	jbe    803668 <insert_sorted_with_merge_freeList+0x710>
  803277:	8b 45 08             	mov    0x8(%ebp),%eax
  80327a:	8b 50 08             	mov    0x8(%eax),%edx
  80327d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803280:	8b 40 08             	mov    0x8(%eax),%eax
  803283:	39 c2                	cmp    %eax,%edx
  803285:	0f 83 dd 03 00 00    	jae    803668 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  80328b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328e:	8b 50 08             	mov    0x8(%eax),%edx
  803291:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803294:	8b 40 0c             	mov    0xc(%eax),%eax
  803297:	01 c2                	add    %eax,%edx
  803299:	8b 45 08             	mov    0x8(%ebp),%eax
  80329c:	8b 40 08             	mov    0x8(%eax),%eax
  80329f:	39 c2                	cmp    %eax,%edx
  8032a1:	0f 85 b9 01 00 00    	jne    803460 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8032a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032aa:	8b 50 08             	mov    0x8(%eax),%edx
  8032ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8032b3:	01 c2                	add    %eax,%edx
  8032b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b8:	8b 40 08             	mov    0x8(%eax),%eax
  8032bb:	39 c2                	cmp    %eax,%edx
  8032bd:	0f 85 0d 01 00 00    	jne    8033d0 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8032c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c6:	8b 50 0c             	mov    0xc(%eax),%edx
  8032c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8032cf:	01 c2                	add    %eax,%edx
  8032d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d4:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8032d7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032db:	75 17                	jne    8032f4 <insert_sorted_with_merge_freeList+0x39c>
  8032dd:	83 ec 04             	sub    $0x4,%esp
  8032e0:	68 20 42 80 00       	push   $0x804220
  8032e5:	68 5c 01 00 00       	push   $0x15c
  8032ea:	68 77 41 80 00       	push   $0x804177
  8032ef:	e8 b0 03 00 00       	call   8036a4 <_panic>
  8032f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f7:	8b 00                	mov    (%eax),%eax
  8032f9:	85 c0                	test   %eax,%eax
  8032fb:	74 10                	je     80330d <insert_sorted_with_merge_freeList+0x3b5>
  8032fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803300:	8b 00                	mov    (%eax),%eax
  803302:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803305:	8b 52 04             	mov    0x4(%edx),%edx
  803308:	89 50 04             	mov    %edx,0x4(%eax)
  80330b:	eb 0b                	jmp    803318 <insert_sorted_with_merge_freeList+0x3c0>
  80330d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803310:	8b 40 04             	mov    0x4(%eax),%eax
  803313:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803318:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80331b:	8b 40 04             	mov    0x4(%eax),%eax
  80331e:	85 c0                	test   %eax,%eax
  803320:	74 0f                	je     803331 <insert_sorted_with_merge_freeList+0x3d9>
  803322:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803325:	8b 40 04             	mov    0x4(%eax),%eax
  803328:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80332b:	8b 12                	mov    (%edx),%edx
  80332d:	89 10                	mov    %edx,(%eax)
  80332f:	eb 0a                	jmp    80333b <insert_sorted_with_merge_freeList+0x3e3>
  803331:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803334:	8b 00                	mov    (%eax),%eax
  803336:	a3 38 51 80 00       	mov    %eax,0x805138
  80333b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80333e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803344:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803347:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80334e:	a1 44 51 80 00       	mov    0x805144,%eax
  803353:	48                   	dec    %eax
  803354:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803359:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80335c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803363:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803366:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80336d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803371:	75 17                	jne    80338a <insert_sorted_with_merge_freeList+0x432>
  803373:	83 ec 04             	sub    $0x4,%esp
  803376:	68 54 41 80 00       	push   $0x804154
  80337b:	68 5f 01 00 00       	push   $0x15f
  803380:	68 77 41 80 00       	push   $0x804177
  803385:	e8 1a 03 00 00       	call   8036a4 <_panic>
  80338a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803390:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803393:	89 10                	mov    %edx,(%eax)
  803395:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803398:	8b 00                	mov    (%eax),%eax
  80339a:	85 c0                	test   %eax,%eax
  80339c:	74 0d                	je     8033ab <insert_sorted_with_merge_freeList+0x453>
  80339e:	a1 48 51 80 00       	mov    0x805148,%eax
  8033a3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033a6:	89 50 04             	mov    %edx,0x4(%eax)
  8033a9:	eb 08                	jmp    8033b3 <insert_sorted_with_merge_freeList+0x45b>
  8033ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ae:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b6:	a3 48 51 80 00       	mov    %eax,0x805148
  8033bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033c5:	a1 54 51 80 00       	mov    0x805154,%eax
  8033ca:	40                   	inc    %eax
  8033cb:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8033d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d3:	8b 50 0c             	mov    0xc(%eax),%edx
  8033d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8033dc:	01 c2                	add    %eax,%edx
  8033de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e1:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8033e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8033ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8033f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033fc:	75 17                	jne    803415 <insert_sorted_with_merge_freeList+0x4bd>
  8033fe:	83 ec 04             	sub    $0x4,%esp
  803401:	68 54 41 80 00       	push   $0x804154
  803406:	68 64 01 00 00       	push   $0x164
  80340b:	68 77 41 80 00       	push   $0x804177
  803410:	e8 8f 02 00 00       	call   8036a4 <_panic>
  803415:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80341b:	8b 45 08             	mov    0x8(%ebp),%eax
  80341e:	89 10                	mov    %edx,(%eax)
  803420:	8b 45 08             	mov    0x8(%ebp),%eax
  803423:	8b 00                	mov    (%eax),%eax
  803425:	85 c0                	test   %eax,%eax
  803427:	74 0d                	je     803436 <insert_sorted_with_merge_freeList+0x4de>
  803429:	a1 48 51 80 00       	mov    0x805148,%eax
  80342e:	8b 55 08             	mov    0x8(%ebp),%edx
  803431:	89 50 04             	mov    %edx,0x4(%eax)
  803434:	eb 08                	jmp    80343e <insert_sorted_with_merge_freeList+0x4e6>
  803436:	8b 45 08             	mov    0x8(%ebp),%eax
  803439:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80343e:	8b 45 08             	mov    0x8(%ebp),%eax
  803441:	a3 48 51 80 00       	mov    %eax,0x805148
  803446:	8b 45 08             	mov    0x8(%ebp),%eax
  803449:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803450:	a1 54 51 80 00       	mov    0x805154,%eax
  803455:	40                   	inc    %eax
  803456:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80345b:	e9 41 02 00 00       	jmp    8036a1 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803460:	8b 45 08             	mov    0x8(%ebp),%eax
  803463:	8b 50 08             	mov    0x8(%eax),%edx
  803466:	8b 45 08             	mov    0x8(%ebp),%eax
  803469:	8b 40 0c             	mov    0xc(%eax),%eax
  80346c:	01 c2                	add    %eax,%edx
  80346e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803471:	8b 40 08             	mov    0x8(%eax),%eax
  803474:	39 c2                	cmp    %eax,%edx
  803476:	0f 85 7c 01 00 00    	jne    8035f8 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80347c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803480:	74 06                	je     803488 <insert_sorted_with_merge_freeList+0x530>
  803482:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803486:	75 17                	jne    80349f <insert_sorted_with_merge_freeList+0x547>
  803488:	83 ec 04             	sub    $0x4,%esp
  80348b:	68 90 41 80 00       	push   $0x804190
  803490:	68 69 01 00 00       	push   $0x169
  803495:	68 77 41 80 00       	push   $0x804177
  80349a:	e8 05 02 00 00       	call   8036a4 <_panic>
  80349f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034a2:	8b 50 04             	mov    0x4(%eax),%edx
  8034a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a8:	89 50 04             	mov    %edx,0x4(%eax)
  8034ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ae:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034b1:	89 10                	mov    %edx,(%eax)
  8034b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034b6:	8b 40 04             	mov    0x4(%eax),%eax
  8034b9:	85 c0                	test   %eax,%eax
  8034bb:	74 0d                	je     8034ca <insert_sorted_with_merge_freeList+0x572>
  8034bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034c0:	8b 40 04             	mov    0x4(%eax),%eax
  8034c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8034c6:	89 10                	mov    %edx,(%eax)
  8034c8:	eb 08                	jmp    8034d2 <insert_sorted_with_merge_freeList+0x57a>
  8034ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8034cd:	a3 38 51 80 00       	mov    %eax,0x805138
  8034d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8034d8:	89 50 04             	mov    %edx,0x4(%eax)
  8034db:	a1 44 51 80 00       	mov    0x805144,%eax
  8034e0:	40                   	inc    %eax
  8034e1:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8034e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e9:	8b 50 0c             	mov    0xc(%eax),%edx
  8034ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8034f2:	01 c2                	add    %eax,%edx
  8034f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f7:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8034fa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8034fe:	75 17                	jne    803517 <insert_sorted_with_merge_freeList+0x5bf>
  803500:	83 ec 04             	sub    $0x4,%esp
  803503:	68 20 42 80 00       	push   $0x804220
  803508:	68 6b 01 00 00       	push   $0x16b
  80350d:	68 77 41 80 00       	push   $0x804177
  803512:	e8 8d 01 00 00       	call   8036a4 <_panic>
  803517:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80351a:	8b 00                	mov    (%eax),%eax
  80351c:	85 c0                	test   %eax,%eax
  80351e:	74 10                	je     803530 <insert_sorted_with_merge_freeList+0x5d8>
  803520:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803523:	8b 00                	mov    (%eax),%eax
  803525:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803528:	8b 52 04             	mov    0x4(%edx),%edx
  80352b:	89 50 04             	mov    %edx,0x4(%eax)
  80352e:	eb 0b                	jmp    80353b <insert_sorted_with_merge_freeList+0x5e3>
  803530:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803533:	8b 40 04             	mov    0x4(%eax),%eax
  803536:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80353b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80353e:	8b 40 04             	mov    0x4(%eax),%eax
  803541:	85 c0                	test   %eax,%eax
  803543:	74 0f                	je     803554 <insert_sorted_with_merge_freeList+0x5fc>
  803545:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803548:	8b 40 04             	mov    0x4(%eax),%eax
  80354b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80354e:	8b 12                	mov    (%edx),%edx
  803550:	89 10                	mov    %edx,(%eax)
  803552:	eb 0a                	jmp    80355e <insert_sorted_with_merge_freeList+0x606>
  803554:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803557:	8b 00                	mov    (%eax),%eax
  803559:	a3 38 51 80 00       	mov    %eax,0x805138
  80355e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803561:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803567:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80356a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803571:	a1 44 51 80 00       	mov    0x805144,%eax
  803576:	48                   	dec    %eax
  803577:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  80357c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80357f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803586:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803589:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803590:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803594:	75 17                	jne    8035ad <insert_sorted_with_merge_freeList+0x655>
  803596:	83 ec 04             	sub    $0x4,%esp
  803599:	68 54 41 80 00       	push   $0x804154
  80359e:	68 6e 01 00 00       	push   $0x16e
  8035a3:	68 77 41 80 00       	push   $0x804177
  8035a8:	e8 f7 00 00 00       	call   8036a4 <_panic>
  8035ad:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8035b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035b6:	89 10                	mov    %edx,(%eax)
  8035b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035bb:	8b 00                	mov    (%eax),%eax
  8035bd:	85 c0                	test   %eax,%eax
  8035bf:	74 0d                	je     8035ce <insert_sorted_with_merge_freeList+0x676>
  8035c1:	a1 48 51 80 00       	mov    0x805148,%eax
  8035c6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8035c9:	89 50 04             	mov    %edx,0x4(%eax)
  8035cc:	eb 08                	jmp    8035d6 <insert_sorted_with_merge_freeList+0x67e>
  8035ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035d1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035d9:	a3 48 51 80 00       	mov    %eax,0x805148
  8035de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035e1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035e8:	a1 54 51 80 00       	mov    0x805154,%eax
  8035ed:	40                   	inc    %eax
  8035ee:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8035f3:	e9 a9 00 00 00       	jmp    8036a1 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8035f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035fc:	74 06                	je     803604 <insert_sorted_with_merge_freeList+0x6ac>
  8035fe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803602:	75 17                	jne    80361b <insert_sorted_with_merge_freeList+0x6c3>
  803604:	83 ec 04             	sub    $0x4,%esp
  803607:	68 ec 41 80 00       	push   $0x8041ec
  80360c:	68 73 01 00 00       	push   $0x173
  803611:	68 77 41 80 00       	push   $0x804177
  803616:	e8 89 00 00 00       	call   8036a4 <_panic>
  80361b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80361e:	8b 10                	mov    (%eax),%edx
  803620:	8b 45 08             	mov    0x8(%ebp),%eax
  803623:	89 10                	mov    %edx,(%eax)
  803625:	8b 45 08             	mov    0x8(%ebp),%eax
  803628:	8b 00                	mov    (%eax),%eax
  80362a:	85 c0                	test   %eax,%eax
  80362c:	74 0b                	je     803639 <insert_sorted_with_merge_freeList+0x6e1>
  80362e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803631:	8b 00                	mov    (%eax),%eax
  803633:	8b 55 08             	mov    0x8(%ebp),%edx
  803636:	89 50 04             	mov    %edx,0x4(%eax)
  803639:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80363c:	8b 55 08             	mov    0x8(%ebp),%edx
  80363f:	89 10                	mov    %edx,(%eax)
  803641:	8b 45 08             	mov    0x8(%ebp),%eax
  803644:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803647:	89 50 04             	mov    %edx,0x4(%eax)
  80364a:	8b 45 08             	mov    0x8(%ebp),%eax
  80364d:	8b 00                	mov    (%eax),%eax
  80364f:	85 c0                	test   %eax,%eax
  803651:	75 08                	jne    80365b <insert_sorted_with_merge_freeList+0x703>
  803653:	8b 45 08             	mov    0x8(%ebp),%eax
  803656:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80365b:	a1 44 51 80 00       	mov    0x805144,%eax
  803660:	40                   	inc    %eax
  803661:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803666:	eb 39                	jmp    8036a1 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803668:	a1 40 51 80 00       	mov    0x805140,%eax
  80366d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803670:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803674:	74 07                	je     80367d <insert_sorted_with_merge_freeList+0x725>
  803676:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803679:	8b 00                	mov    (%eax),%eax
  80367b:	eb 05                	jmp    803682 <insert_sorted_with_merge_freeList+0x72a>
  80367d:	b8 00 00 00 00       	mov    $0x0,%eax
  803682:	a3 40 51 80 00       	mov    %eax,0x805140
  803687:	a1 40 51 80 00       	mov    0x805140,%eax
  80368c:	85 c0                	test   %eax,%eax
  80368e:	0f 85 c7 fb ff ff    	jne    80325b <insert_sorted_with_merge_freeList+0x303>
  803694:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803698:	0f 85 bd fb ff ff    	jne    80325b <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80369e:	eb 01                	jmp    8036a1 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8036a0:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8036a1:	90                   	nop
  8036a2:	c9                   	leave  
  8036a3:	c3                   	ret    

008036a4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8036a4:	55                   	push   %ebp
  8036a5:	89 e5                	mov    %esp,%ebp
  8036a7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8036aa:	8d 45 10             	lea    0x10(%ebp),%eax
  8036ad:	83 c0 04             	add    $0x4,%eax
  8036b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8036b3:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8036b8:	85 c0                	test   %eax,%eax
  8036ba:	74 16                	je     8036d2 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8036bc:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8036c1:	83 ec 08             	sub    $0x8,%esp
  8036c4:	50                   	push   %eax
  8036c5:	68 40 42 80 00       	push   $0x804240
  8036ca:	e8 6e d0 ff ff       	call   80073d <cprintf>
  8036cf:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8036d2:	a1 00 50 80 00       	mov    0x805000,%eax
  8036d7:	ff 75 0c             	pushl  0xc(%ebp)
  8036da:	ff 75 08             	pushl  0x8(%ebp)
  8036dd:	50                   	push   %eax
  8036de:	68 45 42 80 00       	push   $0x804245
  8036e3:	e8 55 d0 ff ff       	call   80073d <cprintf>
  8036e8:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8036eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8036ee:	83 ec 08             	sub    $0x8,%esp
  8036f1:	ff 75 f4             	pushl  -0xc(%ebp)
  8036f4:	50                   	push   %eax
  8036f5:	e8 d8 cf ff ff       	call   8006d2 <vcprintf>
  8036fa:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8036fd:	83 ec 08             	sub    $0x8,%esp
  803700:	6a 00                	push   $0x0
  803702:	68 61 42 80 00       	push   $0x804261
  803707:	e8 c6 cf ff ff       	call   8006d2 <vcprintf>
  80370c:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80370f:	e8 47 cf ff ff       	call   80065b <exit>

	// should not return here
	while (1) ;
  803714:	eb fe                	jmp    803714 <_panic+0x70>

00803716 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803716:	55                   	push   %ebp
  803717:	89 e5                	mov    %esp,%ebp
  803719:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80371c:	a1 20 50 80 00       	mov    0x805020,%eax
  803721:	8b 50 74             	mov    0x74(%eax),%edx
  803724:	8b 45 0c             	mov    0xc(%ebp),%eax
  803727:	39 c2                	cmp    %eax,%edx
  803729:	74 14                	je     80373f <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80372b:	83 ec 04             	sub    $0x4,%esp
  80372e:	68 64 42 80 00       	push   $0x804264
  803733:	6a 26                	push   $0x26
  803735:	68 b0 42 80 00       	push   $0x8042b0
  80373a:	e8 65 ff ff ff       	call   8036a4 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80373f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803746:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80374d:	e9 c2 00 00 00       	jmp    803814 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  803752:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803755:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80375c:	8b 45 08             	mov    0x8(%ebp),%eax
  80375f:	01 d0                	add    %edx,%eax
  803761:	8b 00                	mov    (%eax),%eax
  803763:	85 c0                	test   %eax,%eax
  803765:	75 08                	jne    80376f <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  803767:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80376a:	e9 a2 00 00 00       	jmp    803811 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80376f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803776:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80377d:	eb 69                	jmp    8037e8 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80377f:	a1 20 50 80 00       	mov    0x805020,%eax
  803784:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80378a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80378d:	89 d0                	mov    %edx,%eax
  80378f:	01 c0                	add    %eax,%eax
  803791:	01 d0                	add    %edx,%eax
  803793:	c1 e0 03             	shl    $0x3,%eax
  803796:	01 c8                	add    %ecx,%eax
  803798:	8a 40 04             	mov    0x4(%eax),%al
  80379b:	84 c0                	test   %al,%al
  80379d:	75 46                	jne    8037e5 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80379f:	a1 20 50 80 00       	mov    0x805020,%eax
  8037a4:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8037aa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037ad:	89 d0                	mov    %edx,%eax
  8037af:	01 c0                	add    %eax,%eax
  8037b1:	01 d0                	add    %edx,%eax
  8037b3:	c1 e0 03             	shl    $0x3,%eax
  8037b6:	01 c8                	add    %ecx,%eax
  8037b8:	8b 00                	mov    (%eax),%eax
  8037ba:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8037bd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037c0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8037c5:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8037c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037ca:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8037d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d4:	01 c8                	add    %ecx,%eax
  8037d6:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8037d8:	39 c2                	cmp    %eax,%edx
  8037da:	75 09                	jne    8037e5 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8037dc:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8037e3:	eb 12                	jmp    8037f7 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8037e5:	ff 45 e8             	incl   -0x18(%ebp)
  8037e8:	a1 20 50 80 00       	mov    0x805020,%eax
  8037ed:	8b 50 74             	mov    0x74(%eax),%edx
  8037f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037f3:	39 c2                	cmp    %eax,%edx
  8037f5:	77 88                	ja     80377f <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8037f7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8037fb:	75 14                	jne    803811 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8037fd:	83 ec 04             	sub    $0x4,%esp
  803800:	68 bc 42 80 00       	push   $0x8042bc
  803805:	6a 3a                	push   $0x3a
  803807:	68 b0 42 80 00       	push   $0x8042b0
  80380c:	e8 93 fe ff ff       	call   8036a4 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803811:	ff 45 f0             	incl   -0x10(%ebp)
  803814:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803817:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80381a:	0f 8c 32 ff ff ff    	jl     803752 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803820:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803827:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80382e:	eb 26                	jmp    803856 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803830:	a1 20 50 80 00       	mov    0x805020,%eax
  803835:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80383b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80383e:	89 d0                	mov    %edx,%eax
  803840:	01 c0                	add    %eax,%eax
  803842:	01 d0                	add    %edx,%eax
  803844:	c1 e0 03             	shl    $0x3,%eax
  803847:	01 c8                	add    %ecx,%eax
  803849:	8a 40 04             	mov    0x4(%eax),%al
  80384c:	3c 01                	cmp    $0x1,%al
  80384e:	75 03                	jne    803853 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  803850:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803853:	ff 45 e0             	incl   -0x20(%ebp)
  803856:	a1 20 50 80 00       	mov    0x805020,%eax
  80385b:	8b 50 74             	mov    0x74(%eax),%edx
  80385e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803861:	39 c2                	cmp    %eax,%edx
  803863:	77 cb                	ja     803830 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803865:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803868:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80386b:	74 14                	je     803881 <CheckWSWithoutLastIndex+0x16b>
		panic(
  80386d:	83 ec 04             	sub    $0x4,%esp
  803870:	68 10 43 80 00       	push   $0x804310
  803875:	6a 44                	push   $0x44
  803877:	68 b0 42 80 00       	push   $0x8042b0
  80387c:	e8 23 fe ff ff       	call   8036a4 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803881:	90                   	nop
  803882:	c9                   	leave  
  803883:	c3                   	ret    

00803884 <__udivdi3>:
  803884:	55                   	push   %ebp
  803885:	57                   	push   %edi
  803886:	56                   	push   %esi
  803887:	53                   	push   %ebx
  803888:	83 ec 1c             	sub    $0x1c,%esp
  80388b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80388f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803893:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803897:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80389b:	89 ca                	mov    %ecx,%edx
  80389d:	89 f8                	mov    %edi,%eax
  80389f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8038a3:	85 f6                	test   %esi,%esi
  8038a5:	75 2d                	jne    8038d4 <__udivdi3+0x50>
  8038a7:	39 cf                	cmp    %ecx,%edi
  8038a9:	77 65                	ja     803910 <__udivdi3+0x8c>
  8038ab:	89 fd                	mov    %edi,%ebp
  8038ad:	85 ff                	test   %edi,%edi
  8038af:	75 0b                	jne    8038bc <__udivdi3+0x38>
  8038b1:	b8 01 00 00 00       	mov    $0x1,%eax
  8038b6:	31 d2                	xor    %edx,%edx
  8038b8:	f7 f7                	div    %edi
  8038ba:	89 c5                	mov    %eax,%ebp
  8038bc:	31 d2                	xor    %edx,%edx
  8038be:	89 c8                	mov    %ecx,%eax
  8038c0:	f7 f5                	div    %ebp
  8038c2:	89 c1                	mov    %eax,%ecx
  8038c4:	89 d8                	mov    %ebx,%eax
  8038c6:	f7 f5                	div    %ebp
  8038c8:	89 cf                	mov    %ecx,%edi
  8038ca:	89 fa                	mov    %edi,%edx
  8038cc:	83 c4 1c             	add    $0x1c,%esp
  8038cf:	5b                   	pop    %ebx
  8038d0:	5e                   	pop    %esi
  8038d1:	5f                   	pop    %edi
  8038d2:	5d                   	pop    %ebp
  8038d3:	c3                   	ret    
  8038d4:	39 ce                	cmp    %ecx,%esi
  8038d6:	77 28                	ja     803900 <__udivdi3+0x7c>
  8038d8:	0f bd fe             	bsr    %esi,%edi
  8038db:	83 f7 1f             	xor    $0x1f,%edi
  8038de:	75 40                	jne    803920 <__udivdi3+0x9c>
  8038e0:	39 ce                	cmp    %ecx,%esi
  8038e2:	72 0a                	jb     8038ee <__udivdi3+0x6a>
  8038e4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8038e8:	0f 87 9e 00 00 00    	ja     80398c <__udivdi3+0x108>
  8038ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8038f3:	89 fa                	mov    %edi,%edx
  8038f5:	83 c4 1c             	add    $0x1c,%esp
  8038f8:	5b                   	pop    %ebx
  8038f9:	5e                   	pop    %esi
  8038fa:	5f                   	pop    %edi
  8038fb:	5d                   	pop    %ebp
  8038fc:	c3                   	ret    
  8038fd:	8d 76 00             	lea    0x0(%esi),%esi
  803900:	31 ff                	xor    %edi,%edi
  803902:	31 c0                	xor    %eax,%eax
  803904:	89 fa                	mov    %edi,%edx
  803906:	83 c4 1c             	add    $0x1c,%esp
  803909:	5b                   	pop    %ebx
  80390a:	5e                   	pop    %esi
  80390b:	5f                   	pop    %edi
  80390c:	5d                   	pop    %ebp
  80390d:	c3                   	ret    
  80390e:	66 90                	xchg   %ax,%ax
  803910:	89 d8                	mov    %ebx,%eax
  803912:	f7 f7                	div    %edi
  803914:	31 ff                	xor    %edi,%edi
  803916:	89 fa                	mov    %edi,%edx
  803918:	83 c4 1c             	add    $0x1c,%esp
  80391b:	5b                   	pop    %ebx
  80391c:	5e                   	pop    %esi
  80391d:	5f                   	pop    %edi
  80391e:	5d                   	pop    %ebp
  80391f:	c3                   	ret    
  803920:	bd 20 00 00 00       	mov    $0x20,%ebp
  803925:	89 eb                	mov    %ebp,%ebx
  803927:	29 fb                	sub    %edi,%ebx
  803929:	89 f9                	mov    %edi,%ecx
  80392b:	d3 e6                	shl    %cl,%esi
  80392d:	89 c5                	mov    %eax,%ebp
  80392f:	88 d9                	mov    %bl,%cl
  803931:	d3 ed                	shr    %cl,%ebp
  803933:	89 e9                	mov    %ebp,%ecx
  803935:	09 f1                	or     %esi,%ecx
  803937:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80393b:	89 f9                	mov    %edi,%ecx
  80393d:	d3 e0                	shl    %cl,%eax
  80393f:	89 c5                	mov    %eax,%ebp
  803941:	89 d6                	mov    %edx,%esi
  803943:	88 d9                	mov    %bl,%cl
  803945:	d3 ee                	shr    %cl,%esi
  803947:	89 f9                	mov    %edi,%ecx
  803949:	d3 e2                	shl    %cl,%edx
  80394b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80394f:	88 d9                	mov    %bl,%cl
  803951:	d3 e8                	shr    %cl,%eax
  803953:	09 c2                	or     %eax,%edx
  803955:	89 d0                	mov    %edx,%eax
  803957:	89 f2                	mov    %esi,%edx
  803959:	f7 74 24 0c          	divl   0xc(%esp)
  80395d:	89 d6                	mov    %edx,%esi
  80395f:	89 c3                	mov    %eax,%ebx
  803961:	f7 e5                	mul    %ebp
  803963:	39 d6                	cmp    %edx,%esi
  803965:	72 19                	jb     803980 <__udivdi3+0xfc>
  803967:	74 0b                	je     803974 <__udivdi3+0xf0>
  803969:	89 d8                	mov    %ebx,%eax
  80396b:	31 ff                	xor    %edi,%edi
  80396d:	e9 58 ff ff ff       	jmp    8038ca <__udivdi3+0x46>
  803972:	66 90                	xchg   %ax,%ax
  803974:	8b 54 24 08          	mov    0x8(%esp),%edx
  803978:	89 f9                	mov    %edi,%ecx
  80397a:	d3 e2                	shl    %cl,%edx
  80397c:	39 c2                	cmp    %eax,%edx
  80397e:	73 e9                	jae    803969 <__udivdi3+0xe5>
  803980:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803983:	31 ff                	xor    %edi,%edi
  803985:	e9 40 ff ff ff       	jmp    8038ca <__udivdi3+0x46>
  80398a:	66 90                	xchg   %ax,%ax
  80398c:	31 c0                	xor    %eax,%eax
  80398e:	e9 37 ff ff ff       	jmp    8038ca <__udivdi3+0x46>
  803993:	90                   	nop

00803994 <__umoddi3>:
  803994:	55                   	push   %ebp
  803995:	57                   	push   %edi
  803996:	56                   	push   %esi
  803997:	53                   	push   %ebx
  803998:	83 ec 1c             	sub    $0x1c,%esp
  80399b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80399f:	8b 74 24 34          	mov    0x34(%esp),%esi
  8039a3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8039a7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8039ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8039af:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8039b3:	89 f3                	mov    %esi,%ebx
  8039b5:	89 fa                	mov    %edi,%edx
  8039b7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8039bb:	89 34 24             	mov    %esi,(%esp)
  8039be:	85 c0                	test   %eax,%eax
  8039c0:	75 1a                	jne    8039dc <__umoddi3+0x48>
  8039c2:	39 f7                	cmp    %esi,%edi
  8039c4:	0f 86 a2 00 00 00    	jbe    803a6c <__umoddi3+0xd8>
  8039ca:	89 c8                	mov    %ecx,%eax
  8039cc:	89 f2                	mov    %esi,%edx
  8039ce:	f7 f7                	div    %edi
  8039d0:	89 d0                	mov    %edx,%eax
  8039d2:	31 d2                	xor    %edx,%edx
  8039d4:	83 c4 1c             	add    $0x1c,%esp
  8039d7:	5b                   	pop    %ebx
  8039d8:	5e                   	pop    %esi
  8039d9:	5f                   	pop    %edi
  8039da:	5d                   	pop    %ebp
  8039db:	c3                   	ret    
  8039dc:	39 f0                	cmp    %esi,%eax
  8039de:	0f 87 ac 00 00 00    	ja     803a90 <__umoddi3+0xfc>
  8039e4:	0f bd e8             	bsr    %eax,%ebp
  8039e7:	83 f5 1f             	xor    $0x1f,%ebp
  8039ea:	0f 84 ac 00 00 00    	je     803a9c <__umoddi3+0x108>
  8039f0:	bf 20 00 00 00       	mov    $0x20,%edi
  8039f5:	29 ef                	sub    %ebp,%edi
  8039f7:	89 fe                	mov    %edi,%esi
  8039f9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8039fd:	89 e9                	mov    %ebp,%ecx
  8039ff:	d3 e0                	shl    %cl,%eax
  803a01:	89 d7                	mov    %edx,%edi
  803a03:	89 f1                	mov    %esi,%ecx
  803a05:	d3 ef                	shr    %cl,%edi
  803a07:	09 c7                	or     %eax,%edi
  803a09:	89 e9                	mov    %ebp,%ecx
  803a0b:	d3 e2                	shl    %cl,%edx
  803a0d:	89 14 24             	mov    %edx,(%esp)
  803a10:	89 d8                	mov    %ebx,%eax
  803a12:	d3 e0                	shl    %cl,%eax
  803a14:	89 c2                	mov    %eax,%edx
  803a16:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a1a:	d3 e0                	shl    %cl,%eax
  803a1c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a20:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a24:	89 f1                	mov    %esi,%ecx
  803a26:	d3 e8                	shr    %cl,%eax
  803a28:	09 d0                	or     %edx,%eax
  803a2a:	d3 eb                	shr    %cl,%ebx
  803a2c:	89 da                	mov    %ebx,%edx
  803a2e:	f7 f7                	div    %edi
  803a30:	89 d3                	mov    %edx,%ebx
  803a32:	f7 24 24             	mull   (%esp)
  803a35:	89 c6                	mov    %eax,%esi
  803a37:	89 d1                	mov    %edx,%ecx
  803a39:	39 d3                	cmp    %edx,%ebx
  803a3b:	0f 82 87 00 00 00    	jb     803ac8 <__umoddi3+0x134>
  803a41:	0f 84 91 00 00 00    	je     803ad8 <__umoddi3+0x144>
  803a47:	8b 54 24 04          	mov    0x4(%esp),%edx
  803a4b:	29 f2                	sub    %esi,%edx
  803a4d:	19 cb                	sbb    %ecx,%ebx
  803a4f:	89 d8                	mov    %ebx,%eax
  803a51:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803a55:	d3 e0                	shl    %cl,%eax
  803a57:	89 e9                	mov    %ebp,%ecx
  803a59:	d3 ea                	shr    %cl,%edx
  803a5b:	09 d0                	or     %edx,%eax
  803a5d:	89 e9                	mov    %ebp,%ecx
  803a5f:	d3 eb                	shr    %cl,%ebx
  803a61:	89 da                	mov    %ebx,%edx
  803a63:	83 c4 1c             	add    $0x1c,%esp
  803a66:	5b                   	pop    %ebx
  803a67:	5e                   	pop    %esi
  803a68:	5f                   	pop    %edi
  803a69:	5d                   	pop    %ebp
  803a6a:	c3                   	ret    
  803a6b:	90                   	nop
  803a6c:	89 fd                	mov    %edi,%ebp
  803a6e:	85 ff                	test   %edi,%edi
  803a70:	75 0b                	jne    803a7d <__umoddi3+0xe9>
  803a72:	b8 01 00 00 00       	mov    $0x1,%eax
  803a77:	31 d2                	xor    %edx,%edx
  803a79:	f7 f7                	div    %edi
  803a7b:	89 c5                	mov    %eax,%ebp
  803a7d:	89 f0                	mov    %esi,%eax
  803a7f:	31 d2                	xor    %edx,%edx
  803a81:	f7 f5                	div    %ebp
  803a83:	89 c8                	mov    %ecx,%eax
  803a85:	f7 f5                	div    %ebp
  803a87:	89 d0                	mov    %edx,%eax
  803a89:	e9 44 ff ff ff       	jmp    8039d2 <__umoddi3+0x3e>
  803a8e:	66 90                	xchg   %ax,%ax
  803a90:	89 c8                	mov    %ecx,%eax
  803a92:	89 f2                	mov    %esi,%edx
  803a94:	83 c4 1c             	add    $0x1c,%esp
  803a97:	5b                   	pop    %ebx
  803a98:	5e                   	pop    %esi
  803a99:	5f                   	pop    %edi
  803a9a:	5d                   	pop    %ebp
  803a9b:	c3                   	ret    
  803a9c:	3b 04 24             	cmp    (%esp),%eax
  803a9f:	72 06                	jb     803aa7 <__umoddi3+0x113>
  803aa1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803aa5:	77 0f                	ja     803ab6 <__umoddi3+0x122>
  803aa7:	89 f2                	mov    %esi,%edx
  803aa9:	29 f9                	sub    %edi,%ecx
  803aab:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803aaf:	89 14 24             	mov    %edx,(%esp)
  803ab2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ab6:	8b 44 24 04          	mov    0x4(%esp),%eax
  803aba:	8b 14 24             	mov    (%esp),%edx
  803abd:	83 c4 1c             	add    $0x1c,%esp
  803ac0:	5b                   	pop    %ebx
  803ac1:	5e                   	pop    %esi
  803ac2:	5f                   	pop    %edi
  803ac3:	5d                   	pop    %ebp
  803ac4:	c3                   	ret    
  803ac5:	8d 76 00             	lea    0x0(%esi),%esi
  803ac8:	2b 04 24             	sub    (%esp),%eax
  803acb:	19 fa                	sbb    %edi,%edx
  803acd:	89 d1                	mov    %edx,%ecx
  803acf:	89 c6                	mov    %eax,%esi
  803ad1:	e9 71 ff ff ff       	jmp    803a47 <__umoddi3+0xb3>
  803ad6:	66 90                	xchg   %ax,%ax
  803ad8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803adc:	72 ea                	jb     803ac8 <__umoddi3+0x134>
  803ade:	89 d9                	mov    %ebx,%ecx
  803ae0:	e9 62 ff ff ff       	jmp    803a47 <__umoddi3+0xb3>
